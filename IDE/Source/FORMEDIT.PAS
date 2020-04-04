
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

UNIT FormEdit;

INTERFACE

USES SysUtils,Color,Classes,Forms,Graphics,Buttons,StdCtrls,Dialogs,TabCtrls,
     Menus, Messages, Clipbrd, uStream, uString, uList, Hints,
     Editors, DockTool,ToolsApi;

Uses Consts,Projects, Inspect,Form_Gen,Sib_Edit,
     IdeTools, BaseForm, Sib_Prj;

CONST
    kbCtrlShiftCLeft  = kb_Ctrl + kb_Shift + kbCLeft;
    kbCtrlShiftCRight = kb_Ctrl + kb_Shift + kbCRight;
    kbCtrlShiftCUp    = kb_Ctrl + kb_Shift + kbCUp;
    kbCtrlShiftCDown  = kb_Ctrl + kb_Shift + kbCDown;

    crDropMove        = crSize;
    crDropSize        = crArrow;
    crDragging        = crSize;
    crMultiSelect     = 3;
    crInsert          = 4;
    crPaste           = 5;
    crNormal          = crArrow;

TYPE
    PSelectItem=^TSelectItem;
    TSelectItem=RECORD
        Component:TControl;
        Offs     :TPoint;
    END;

    TMouseMode=(mmNothing,mmInsertMove,mmInsertSize,mmDrag,mmSize,mmMultiSelection);

    TFormEditor=CLASS(TForm)
      PUBLIC
         fComponentHintTimer: tTimer;
         fOldHintSender     : tControl;
         fOldMousePos       : tPoint;
         FrameInit: TPoint;
         FrameRec: TRect;
         InitSize: TPoint;
         DragPoint: TPoint;
         SelectList: TList;
         MouseMode: TMouseMode;
         SingleSelect: TControl;
         SizeCorner: BYTE;
         FrameInitPos: TPoint;
         FrameSizing: BOOLEAN;
         FillRects: BOOLEAN;
         RectsDrawn: BOOLEAN;
         NewInsertParent: TControl;
         Destroying:BOOLEAN;
         LastPopupComponent:TComponent;
         FormEditPopup:TPopupMenu;
         CopyEntry,PasteEntry,DeleteEntry,GridVisEntry,SnapGridEntry:TMenuItem;
      PRIVATE
{$IFDEF OS2}
         FHintWindow:THintWindow;
         PROCEDURE EvComponentHintTimer(Sender:TObject);
{$ENDIF}
         PROCEDURE EvFrameMouseDown(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
         PROCEDURE EvFrameMouseMove(Sender:TObject;ShiftState:TShiftState;X,Y:LONGINT);
         PROCEDURE EvFormChangeSource(Sender:TObject);
         PROCEDURE EvSaveToFile(Sender:TObject);
         PROCEDURE EvAddToRepository(Sender:TObject);
         PROCEDURE EvAlignmentPalette(Sender:TObject);
         PROCEDURE EvObjectInspector(Sender:TObject);
         PROCEDURE EvProperties(Sender:TObject);
         PROCEDURE EvDesignerEvent(Sender:TObject);
         PROCEDURE EvCallPropEditEvent(Sender:TObject);
      PROTECTED
         FUNCTION  CloseQuery:BOOLEAN;OVERRIDE;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE Activate;OVERRIDE;
         PROCEDURE SetFocus;OVERRIDE;
         PROCEDURE MenuItemFocus(AMenu:TMenu;Entry:TMenuItem);OVERRIDE;
         PROCEDURE MenuCharEvent(AMenu:TMenu;Entry:TMenuItem;VAR Key:CHAR;rep:BYTE);OVERRIDE;
         PROCEDURE MenuScanEvent(AMenu:TMenu;Entry:TMenuItem;VAR KeyCode:TKeyCode;rep:BYTE);OVERRIDE;
         PROCEDURE ScanEvent(VAR Keycode:TKeyCode;RepeatCount:BYTE);OVERRIDE;
         PROCEDURE CharEvent(VAR Key:CHAR;RepeatCount:BYTE);OVERRIDE;
         PROCEDURE TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);OVERRIDE;
         FUNCTION QueryConvertPos(VAR pos:TPoint):BOOLEAN;OVERRIDE;
         PROCEDURE Resize;OVERRIDE;
         PROCEDURE Move;OVERRIDE;
         PROCEDURE ShowContextMenu(Comp:TComponent;X,Y:LONGINT);
      PUBLIC
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE Close;OVERRIDE;
         PROCEDURE InsertComponent(AComponent:TComponent);OVERRIDE;
         PROCEDURE RemoveComponent(AComponent:TComponent);OVERRIDE;
         PROCEDURE Redraw(CONST rc:TRect);OVERRIDE;
         PROCEDURE InvalidateFormWindow;
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
         FUNCTION  GetPossibleToolBar(Comp:TToolbar;pt:TPoint;VAR rec:TRect):TToolbarAlign;
         PROCEDURE UpdateToolBarRect(Comp:TToolbar;pt:TPoint;VAR rec:TRect);
         FUNCTION  GetFirstSelected:TComponent;
         FUNCTION  TestInsert(VAR AParent:TControl;CompClass:TComponentClass):BOOLEAN;
         PROCEDURE MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseMove(ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
{$IFDEF OS2}
         Procedure ShowComponentHint(Sender:TControl; DNSCode : TDesignerNotifyCode);
         Procedure HideComponentHint(Sender:TControl);
{$ENDIF}
         PROCEDURE DesignerNotification(VAR DNS:TDesignerNotifyStruct);OVERRIDE;
         PROCEDURE SetCursorIntern(hms:TCursor);
         PROCEDURE SetWndState(NewState:TWindowState);
         FUNCTION  GetWndState:TWindowState;
         PROCEDURE UpdateFormSelect(aControl:TControl);

         PROCEDURE SelectComponent(Component:TControl);
         FUNCTION  GetSelectionPos(VAR rec:TRect):BOOLEAN;
         PROCEDURE DrawDragBorders(aCanvas:TCanvas);
         PROCEDURE DrawInvertRect(aCanvas:TCanvas;rec:TRect);
         PROCEDURE ClearSelection;
         PROCEDURE UpdateSelection;
         PROCEDURE DrawGrid(rec:TRect);
         PROCEDURE DrawComponentRects(Component:TControl;Fill:BOOLEAN);
         PROCEDURE DrawHandles(x,y,w,h:LONGINT;Component:TControl;Fill:BOOLEAN);
         PROCEDURE DrawCompRect(aCanvas:TCanvas;x,y:LONGINT);
         FUNCTION  GetParentCanvas(Component:TComponent;VAR RealParent:TControl):TCanvas;
         PROCEDURE CancelOperation;
         PROCEDURE SelectAll;
         PROCEDURE DeselectAll;
         PROCEDURE SelectParentComponent;
         PROCEDURE SelectNextComponent;
         PROCEDURE SelectPreviousComponent;
         PROCEDURE SelectNearestComponent(KeyCode:TKeyCode);
         PROCEDURE MoveSelectedComponents(KeyCode:TKeyCode;RepeatCount:BYTE);
         PROCEDURE SizeSelectedComponents(KeyCode:TKeyCode;RepeatCount:BYTE);
         PROCEDURE CutSelectedComponents;
         PROCEDURE CopySelectedComponents;
         PROCEDURE PasteComponents;
         PROCEDURE InsertPasteComponents(NewParent:TControl;X,Y:LONGINT);
         PROCEDURE DeleteSelectedComponents;
         PROCEDURE DeleteComponent(Component:TControl;destroyit:BOOLEAN);
         FUNCTION  GetFormCoordinates(Component:TControl):TRect;
         FUNCTION  Parent2ToolbarKoord(VAR AParent:TControl; VAR rec:TRect):BOOLEAN;
         FUNCTION  Parent2FormKoord(VAR AParent:TControl; VAR rec:TRect):BOOLEAN;
         FUNCTION  Form2ParentKoord(VAR AParent:TControl; VAR rec:TRect):BOOLEAN;
         FUNCTION  Toolbar2ParentKoord(VAR AParent:TControl; VAR rec:TRect):BOOLEAN;
         PROCEDURE Align1;
         PROCEDURE Align2;
         PROCEDURE Align3;
         PROCEDURE Align4;
         PROCEDURE Align5;
         PROCEDURE Align6;
         PROCEDURE Align7;
         PROCEDURE Align8;
         PROCEDURE Align9;
         PROCEDURE Align10;
         PROCEDURE Align11;
         PROCEDURE Align12;
         PROCEDURE Align13;
         PROCEDURE Align14;
         PROCEDURE ForceAlign;
         PROCEDURE RefreshAll;
         PROCEDURE DelCtrl;
         PROCEDURE GridVis;
         PROCEDURE SnapToGrid;
         PROCEDURE DesignPos;
      PUBLIC
         PROPERTY CursorIntern:TCursor write SetCursorIntern;
         PROPERTY WndState:TWindowState read GetWndState write SetWndState;
    END;


    TReferenceWindow=CLASS(TSpeedButton)
      PRIVATE
         FReference:TComponent;
         FUNCTION GetReference:TComponent;
         PROCEDURE SetReference(NewRef:TComponent);
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE GetChildren(Proc:TGetChildProc);OVERRIDE;
      PUBLIC
         DESTRUCTOR Destroy;OVERRIDE;
         FUNCTION WriteSCUResource(Stream:TResourceStream):BOOLEAN;OVERRIDE;
         PROPERTY Reference:TComponent read GetReference write SetReference;
    END;



FUNCTION  GetActiveFormWindow:TFormEditor;
FUNCTION  NewFormWindow(UnitName:STRING):TFormEditor;
FUNCTION  NewDockingToolbar:TFormEditor;
FUNCTION  OpenFormWindow(FormName:STRING):TFormEditor;
FUNCTION  OpenRelatedForm(Editor:TSibEditor):TFormEditor;
PROCEDURE UpdateAllFormWindows;

PROCEDURE ChangeSourceLocation(FormItem:PFormListItem);
PROCEDURE SaveFormToFile(FormItem:PFormListItem);

VAR NewInsertClass:TComponentClass;
    LastDesignFormName:STRING;
    cfComponents:LONGWORD;    {Clipboard Format}

var CurInsert     : tPointer;
    CurMultiSelect: tPointer;
    CurPaste      : tPointer;

IMPLEMENTATION

Uses Navigate;

{$IFDEF OS2}
USES PMWin;
{$ENDIF}
{$IFDEF Win32}
USES WinUser;
{$ENDIF}

CONST PasteInitiated:BOOLEAN=FALSE;  {PasteOperation eigeleitet}

PROCEDURE SetInspectorData(Instance:TComponent);
BEGIN
     IF Inspector <> NIL THEN
     BEGIN
          IF Instance IS TReferenceWindow
          THEN Inspector.SetInspectorData(TReferenceWindow(Instance).Reference)
          ELSE Inspector.SetInspectorData(Instance);
     END;
END;

PROCEDURE UpdateInspectorData(Instance:TComponent);
BEGIN
     IF Inspector <> NIL THEN
     BEGIN
          IF Instance IS TReferenceWindow
          THEN Instance:=TReferenceWindow(Instance).Reference;

          IF Inspector.InspectedObjectsList<>NIL
          THEN Inspector.SetInspectorData(Instance) //!!
          ELSE Inspector.UpdateInspectorData(Instance);
     END;
END;

PROCEDURE UpdateInspectorDataList(SelectList:TList;Form:TFormEditor);
VAR Item:PSelectItem;
    InstanceList:TList;
    t:LONGINT;
    Component:TComponent;
BEGIN
     IF Inspector <> NIL THEN
     BEGIN
          IF SelectList.Count=0 THEN UpdateInspectorData(Form)
          ELSE
          IF SelectList.Count=1 THEN
          BEGIN
               Item:=SelectList[0];
               IF Item=NIL THEN UpdateInspectorData(NIL)
               ELSE UpdateInspectorData(Item^.Component);
          END
          ELSE
          BEGIN
               InstanceList.Create;
               FOR t:=0 TO SelectList.Count-1 DO
               BEGIN
                    Item:=SelectList[t];
                    IF Item<>NIL THEN IF Item^.Component<>NIL THEN
                    BEGIN
                         Component:=Item^.Component;
                         IF Component IS TReferenceWindow THEN InstanceList.Add(TReferenceWindow(Component).Reference)
                         ELSE InstanceList.Add(Component);
                    END;
               END;
               Inspector.UpdateInspectorDataList(InstanceList);
               InstanceList.Destroy;
          END;
     END;
END;

PROCEDURE AddInspectorItem(Instance:TComponent);
BEGIN
     IF Inspector <> NIL THEN
     BEGIN
          Inspector.AddInspectorItem(Instance);
     END;
END;

PROCEDURE RemoveInspectorItem(Instance:TComponent);
BEGIN
     IF Inspector <> NIL THEN
     BEGIN
          Inspector.RemoveInspectorItem(Instance);
     END;
END;

PROCEDURE SetInspectorFocus(Instance:TComponent);
BEGIN
     IF Inspector <> NIL THEN
     BEGIN
          IF Instance IS TReferenceWindow
          THEN Inspector.SetInspectorFocus(TReferenceWindow(Instance).Reference)
          ELSE Inspector.SetInspectorFocus(Instance);
     END;
END;


FUNCTION NewFormWindow(UnitName:STRING):TFormEditor;
VAR  SCUInfo:POINTER;
     SCULen:LONGWORD;
     EditInfo:POINTER;
     EditLen:LONGWORD;
     Expert:TIExpert;
LABEL ok;
BEGIN
     Result := NIL;

     // Testen, ob ein Experte oder eine Vorlage fr die MainForm existiert
     IF Project.Forms.Count = 0 THEN
     BEGIN
          Expert := GetMainFormExpert(SCUInfo,SCULen,EditInfo,EditLen);
          // Experte
          IF Expert <> NIL THEN
          BEGIN
               Expert.Execute;
               goto ok;
          END;
          // Template
          IF SCUInfo <> NIL THEN
          BEGIN
               Result := TFormEditor(NewTemplateForm(SCUInfo,SCULen,EditInfo,EditLen));
               goto ok;
          END;
     END;


     // Testen, ob ein Experte oder eine Vorlage fr eine neue Form existiert
     Expert := GetNewFormExpert(SCUInfo,SCULen,EditInfo,EditLen);
     // Experte
     IF Expert <> NIL THEN
     BEGIN
          Expert.Execute;
          goto ok;
     END;
     // Template
     IF SCUInfo <> NIL THEN
     BEGIN
          Result := TFormEditor(NewTemplateForm(SCUInfo,SCULen,EditInfo,EditLen));
          goto ok;
     END;


     // Standard Form erzeugen
     Result.Create(NIL);
     Result.SetWindowPos((Screen.Width-400) DIV 2,(Screen.Height-300) DIV 2,400,300);
     Result.Color := clDlgWindow;

     GenNewForm(Result,UnitName);

ok:
     IF Result <> NIL THEN
     BEGIN
          Result.SetDesigning(TRUE);
          Result.Show;
          UpdateInspectorData(Result); {war Set...}
     END;
     Project.SCUModified := TRUE;
END;


FUNCTION NewDockingToolbar:TFormEditor;
VAR  Dock:TDockingToolbar;
     OldAutoCreate:BOOLEAN;
BEGIN
     Result.Create(NIL);
     Result.SetWindowPos((Screen.Width DIV 2)-100,(Screen.Height DIV 2)-100,200,200);
     Result.Color := clDlgWindow;

     {unbedingt AutoCreate Flag setzen}
     OldAutoCreate := IdeSettings.Designer.AutoCreateForm;
     IdeSettings.Designer.AutoCreateForm := TRUE;

     GenNewForm(Result,'');

     IdeSettings.Designer.AutoCreateForm := OldAutoCreate;

     Dock.Create(Result);
     Dock.Parent := Result;
     GenNewComponent(Result, Dock);

     Result.SetDesigning(TRUE);
     Result.Show;
     UpdateInspectorData(Dock); {war Set...}
     Project.SCUModified := TRUE;
END;


FUNCTION OpenFormWindow(FormName:STRING):TFormEditor;
VAR  s:STRING;
     i:INTEGER;
     FormItem:PFormListItem;
     SCUModified:BOOLEAN;
BEGIN
     SCUModified := Project.SCUModified;
     UpcaseStr(FormName);
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          s := Upcased(FormItem^.FormName);
          IF s = FormName THEN
          BEGIN
               IF FormItem^.Form = NIL THEN
               BEGIN
                    {Create Form and load properties}
                    IF FormItem^.SCUPointer <> NIL THEN
                    BEGIN
                         SCUPointer := FormItem^.SCUPointer;
                         PSCUFileFormat(SCUPointer)^.UseEntry := 0;
                         Result.Create(NIL);
                         FreeMem(FormItem^.SCUPointer, FormItem^.SCUSize);
                         SCUPointer := NIL;
                    END
                    ELSE
                    BEGIN
                         ErrorBox(LoadNLSStr(SiNoTempSCUInfoFound));
                         Result.Create(NIL);
                    END;

                    FormItem^.Form := Result;
                    FormItem^.SCUPointer := NIL;
                    FormItem^.SCUSize := 0;
                    Result.TypeName := 'T'+ Result.Name;
                    Result.Show;
                    Result.Focus;  {damit LastDesignForm richtig gesetzt wird}
               END
               ELSE Result := TFormEditor(FormItem^.Form);

               IF Result <> NIL THEN
               BEGIN
                    IF Result.WndState = wsMinimized
                    THEN Result.WndState := wsNormal;
                    Result.Show;
                    Result.Focus;
               END;
               break;
          END;
     END;
     Project.SCUModified := SCUModified;
END;


FUNCTION OpenRelatedForm(Editor:TSibEditor):TFormEditor;
VAR  s:STRING;
     i:INTEGER;
     FormItem:PFormListItem;
BEGIN
     Result := NIL;
     IF Editor = NIL THEN exit;
     s := Upcased(Editor.FileName);

     {try LastDesignForm}
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          IF Upcased(FormItem^.UnitName) = s THEN
            IF FormItem^.Form <> NIL THEN
              IF FormItem^.Form = LastDesignForm THEN
              BEGIN
                   Result := OpenFormWindow(FormItem^.FormName);
                   exit;
              END;
     END;

     {try first matching open Form}
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          IF Upcased(FormItem^.UnitName) = s THEN
            IF FormItem^.Form <> NIL THEN
            BEGIN
                 Result := OpenFormWindow(FormItem^.FormName);
                 exit;
            END;
     END;

     {try first matching Form}
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          IF Upcased(FormItem^.UnitName) = s THEN
          BEGIN
               Result := OpenFormWindow(FormItem^.FormName);
               exit;
          END;
     END;
END;


FUNCTION GetActiveFormWindow:TFormEditor;
BEGIN
     Result := TFormEditor(LastDesignForm);
END;


FUNCTION RectPartOfRect(src,trg:TRect):BOOLEAN;
BEGIN
     Result := FALSE;
     {mind. eine Eckpunkt-Koordinate von src muแ in trg liegen}
     IF PointInRect(Point(src.Left,src.Bottom),trg) OR
        PointInRect(Point(src.Left,src.Top),trg) OR
        PointInRect(Point(src.Right,src.Bottom),trg) OR
        PointInRect(Point(src.Right,src.Top),trg) THEN Result := TRUE;
END;


FUNCTION RectIsPartOfMultiSelection(src,trg:TRect):BOOLEAN;
BEGIN
     IF IdeSettings.Designer.MultiSelectMode = cs_Include
     THEN Result := RectInRect(src,trg)
     ELSE Result := RectPartOfRect(src,trg);
END;


FUNCTION Navigator_GetInsertComponent:TComponentClass;
BEGIN
  Result := NewInsertClass;
  IF Result = NIL THEN
    IF Navigator <> NIL THEN Result := Navigator.GetSelectedComponent;
END;


PROCEDURE Navigator_EnableArrow;
BEGIN
     IF Navigator <> NIL THEN Navigator.EnableArrow;
     NewInsertClass := NIL;
END;


FUNCTION Navigator_MultiInsertMode:BOOLEAN;
BEGIN
     Result := FALSE;
     IF Navigator <> NIL THEN Result := Navigator.MultiInsertMode;
END;



PROCEDURE GetPropEditPopupEvents(AComponent:TComponent;AStrings:TStringList);
BEGIN
END;


PROCEDURE CallPropEdit(AComponent:TComponent;Name:STRING);
BEGIN
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TFormEditor Class implementation                            บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TFormEditor.SetCursorIntern(hms:TCursor);
BEGIN
  {$IFDEF OS2}
  WinSetPointer(HWND_DESKTOP,Screen.Cursors[hms]);
  {$ENDIF}
  {$IFDEF Win32}
//  SetClassWord(Handle,-12{GCW_HCURSOR},0);
  SetClassLong(Handle,GCL_HCURSOR,0);
  SetCursor(Screen.Cursors[hms]);
  {$ENDIF}
END;


PROCEDURE TFormEditor.SetWndState(NewState:TWindowState);
VAR  Win:LONGWORD;
     WinStyle:LONGWORD;
     {$IFDEF Win32}
     Placement:WINDOWPLACEMENT;
     {$ENDIF}
BEGIN
  IF Frame = NIL THEN exit;
  Win := Frame.Handle;
  IF Win = 0 THEN exit;

{$IFDEF OS2}
  HideComponentHint(Self);
{$ENDIF}

  {$IFDEF OS2}
  CASE NewState OF
     wsNormal:    WinStyle := SWP_RESTORE;
     wsMinimized: WinStyle := SWP_MINIMIZE;
     wsMaximized: WinStyle := SWP_MAXIMIZE;
  END;
  WinSetWindowPos(Win,HWND_TOP,0,0,0,0,WinStyle);
  {$ENDIF}

  {$IFDEF Win32}
  CASE NewState OF
     wsNormal:    WinStyle := SW_NORMAL;
     wsMinimized: WinStyle := SW_SHOWMINIMIZED;
     wsMaximized: WinStyle := SW_SHOWMAXIMIZED;
  END;
  FillChar(Placement,SizeOf(Placement),0);
  Placement.Length := SizeOf(WindowPlacement);
  GetWindowPlacement(Win,Placement);
  Placement.ShowCmd := WinStyle;
  SetWindowPlacement(Win,Placement);
  {$ENDIF}
END;


FUNCTION TFormEditor.GetWndState:TWindowState;
VAR  Win:LONGWORD;
     WinStyle:LONGWORD;
     {$IFDEF Win32}
     Placement:WINDOWPLACEMENT;
     {$ENDIF}
BEGIN
     IF Frame = NIL THEN exit;
     Win := Frame.Handle;
     IF Win = 0 THEN exit;

     {$IFDEF OS2}
     WinStyle := WinQueryWindowULong(Win,QWL_STYLE);
     IF WinStyle AND WS_MAXIMIZED <> 0 THEN Result := wsMaximized
     ELSE
     IF WinStyle AND WS_MINIMIZED <> 0 THEN Result := wsMinimized
     ELSE Result := wsNormal;
     {$ENDIF}

     {$IFDEF Win32}
     FillChar(Placement,SizeOf(Placement),0);
     Placement.Length := SizeOf(WindowPlacement);
     GetWindowPlacement(Win,Placement);
     WinStyle := Placement.ShowCmd;
     IF WinStyle = SW_SHOWMAXIMIZED THEN Result := wsMaximized
     ELSE
     IF WinStyle = SW_SHOWMINIMIZED THEN Result := wsMinimized
     ELSE Result := wsNormal;
     {$ENDIF}
END;

PROCEDURE TFormEditor.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Exclude(ComponentState, csReference);

     {Font Reset, weil berschrieben durch Sibyl Application}
     Font := Screen.DefaultFont;

     {if we write a SCU dont setup !}
     IF ComponentState * [csWriting] <> [] THEN exit;

     SetDesigning(TRUE);
//     DesignerState := DesignerState + [dsHandleMouse,dsHandleKey]; {Force weil vom SCU}
     HandlesDesignMouse := TRUE;
     HandlesDesignKey := TRUE;
     SelectList.Create;
     MouseMode := mmNothing;
     SingleSelect := NIL;
     SizeCorner := 0;
     FrameSizing := FALSE;

     IF Project.Settings.ProjectType = pt_NonVisual THEN
     BEGIN
          // Form evtl. durch "New Object" Dialog erzeugt
          Project.Settings.ProjectType := pt_Visual;
     END;
END;


PROCEDURE TFormEditor.SetupShow;
BEGIN
  Inherited SetupShow;

  AddWindowListProc(2,SELF);

  Frame.OnMouseDown := EvFrameMouseDown;
  Frame.OnMouseMove := EvFrameMouseMove;
  Frame.HandlesDesignMouse := TRUE;

  Include(DesignerState, dsFormVisible);
  IF not Project.Loading THEN
  BEGIN
       Project.SCUModified := TRUE;
       {neucompilieren nicht unbedingt notwendig}
  END;

{$IFDEF OS2}
  FHintWindow := HintWindowClass.Create(nil);
  FHintWindow.CreateWnd;
  fComponentHintTimer.Create(Application.Mainform);
  fComponentHintTimer.Interval:=2000;    // ca. Sekunden
  fComponentHintTimer.OnTimer :=evComponentHintTimer;
{$ENDIF}
END;


PROCEDURE TFormEditor.InsertComponent(AComponent:TComponent);
BEGIN
     Inherited InsertComponent(AComponent);
(*
     {fge Komponente zur InspectorComboBox und dem Quellcode hinzu}
     IF not (csWriting IN ComponentState) THEN
       IF not (csReading IN ComponentState) THEN
         IF AComponent.Designed THEN
           IF not (AComponent IS TReferenceWindow) THEN
             IF AComponent IS TMenuItem THEN
             BEGIN
                  AddInspectorItem(AComponent);

                  GenNewComponent(SELF, AComponent);

                  Project.SCUModified := TRUE;
             END;
*)
END;


PROCEDURE TFormEditor.RemoveComponent(AComponent:TComponent);
BEGIN
     {entferne Komponente aus der InspectorComboBox und dem Quellcode}
     IF not (csWriting IN ComponentState) THEN
       IF not (csReading IN ComponentState) THEN
         IF not Destroying THEN
           IF AComponent.Designed THEN
             IF not (csWriting IN AComponent.ComponentState) THEN
               IF not (csReading IN AComponent.ComponentState) THEN
                 IF not (AComponent IS TReferenceWindow) THEN
// wegen Problemen mit DLL Komponenten beim Erzeugen der ShadowKomponenten
                   IF not Project.SCUSaving THEN
                   BEGIN
                        RemoveInspectorItem(AComponent);

                        GenRemoveComponent(SELF, AComponent);

                        Project.SCUModified := TRUE;
                   END;

     IF LastPopupComponent = AComponent THEN LastPopupComponent := NIL;

     Inherited RemoveComponent(AComponent);
END;


DESTRUCTOR TFormEditor.Destroy;
VAR  FormItem:PFormListItem;
     i:LONGINT;
BEGIN
  if fComponentHintTimer<>nil then
    fComponentHintTimer.Destroy;

{$IFDEF OS2}
  if FHintWindow<>nil then
    FHintWindow.Destroy;
{$ENDIF}

  Destroying := TRUE;

  IF LastFocusedForm = SELF THEN LastFocusedForm := NIL;

  IF LastDesignForm = SELF THEN
  BEGIN
       LastDesignForm := NIL;
       LastDesignFormName := Name;

       FOR i := 0 TO Project.Forms.Count-1 DO
       BEGIN
            FormItem := Project.Forms.Items[i];
            IF (FormItem^.Form <> NIL) AND (FormItem^.Form <> SELF) THEN
            BEGIN
                 LastDesignForm := TForm(FormItem^.Form);
                 break;
            END;
       END;

       UpdateInspectorData(LastDesignForm);  {war Set...}
  END;


  IF DesignPosBtn <> NIL THEN DesignPosBtn.Caption := '';

  IF SelectList <> NIL THEN SelectList.Destroy;
  SelectList := Nil;
  RemoveWindowListProc(2,SELF);

  IF FormEditPopup <> NIL THEN FormEditPopup.Destroy;
  FormEditPopup := NIL;

  Inherited Destroy;

  IF Inspector <> NIL THEN
    IF Inspector.InspectedForm = SELF THEN UpdateInspectorData(Nil);
END;


FUNCTION TFormEditor.CloseQuery:BOOLEAN;
BEGIN
Application.LogWriteln('Closse-Query');
  Inherited CloseQuery;
  Exclude(DesignerState, dsFormVisible);
  Result := CloseForm(SELF); {schreibt FormInfo in lokalen SCUPointer}
  IF Result
    THEN Project.SCUModified := TRUE
    ELSE Include(DesignerState, dsFormVisible);
Application.LogWriteln('Closse-Query-End');
END;


PROCEDURE TFormEditor.Close;
BEGIN
Application.LogWriteln('Close');
  IF CloseQuery THEN Release;
Application.LogWriteln('Close-End');
END;

PROCEDURE TFormEditor.CommandEvent(VAR Command:TCommand);
BEGIN
  CASE Command OF
    cmAlign1     : Align1;
    cmAlign2     : Align2;
    cmAlign3     : Align3;
    cmAlign4     : Align4;
    cmAlign5     : Align5;
    cmAlign6     : Align6;
    cmAlign7     : Align7;
    cmAlign8     : Align8;
    cmAlign9     : Align9;
    cmAlign10    : Align10;
    cmAlign11    : Align11;
    cmAlign12    : Align12;
    cmAlign13    : Align13;
    cmAlign14    : Align14;
    cmForceAlign : ForceAlign;
    cmRefresh    : RefreshAll;
    cmDelCtrl    : DelCtrl;
    cmGridVis    : GridVis;
    cmSnapToGrid : SnapToGrid;
    cmDesignPos  : DesignPos;
    cmUndo       : ;
    cmRedo       : ;
    cmCut        : CutSelectedComponents;
    cmCopy       : CopySelectedComponents;
    cmPaste      : PasteComponents;
    cmDelete     : DeleteSelectedComponents;
    cmSelectAll  : SelectAll;
    cmDeselectAll: DeselectAll;
    ELSE Inherited CommandEvent(Command);
  END;
END;


PROCEDURE TFormEditor.Redraw(CONST rc:TRect);
BEGIN
  Inherited Redraw(rc);

  Canvas.DeleteClipRegion;
  InvalidateFormWindow;
  IF IdeSettings.Designer.GridVisible THEN DrawGrid(rc);
END;


PROCEDURE TFormEditor.InvalidateFormWindow;
VAR  i:INTEGER;
     Item:PSelectItem;
     Component:TControl;
BEGIN
     Canvas.Pen.Color := OppositeRGB(Color);

     IF MouseMode IN [mmNothing] THEN
     BEGIN
          FOR i := 0 TO SelectList.Count-1 DO
          BEGIN
               Item := SelectList.Items[i];
               IF Item <> NIL THEN
               BEGIN
                    Component := Item^.Component;
                    IF Component <> NIL THEN
                    BEGIN
                         DrawComponentRects(Component,i=0);
                    END;
               END;
               RectsDrawn := TRUE;
          END;

          IF (SelectList.Count > 0) AND HasFocus
          THEN UpdateInspectorDataList(SelectList,SELF);
     END;
END;


FUNCTION TFormEditor.QueryConvertPos(VAR pos:TPoint):BOOLEAN;
BEGIN
  pos.X := 1;
  pos.Y := 1;
  Result := TRUE;
END;


FUNCTION TFormEditor.GetPossibleToolBar(Comp:TToolbar;pt:TPoint;VAR rec:TRect):TToolbarAlign;
VAR  mindist:LONGINT;
     client:TRect;
     tb:TToolbarAlign;
BEGIN
     Result := Comp.Alignment;
     mindist := MaxLongInt;
     client := ClientRect;

     FOR tb := tbLeft TO tbBottom DO
     BEGIN
          CASE tb OF
             tbLeft:
             IF pt.X < mindist THEN
             BEGIN
                  Result := tb;
                  mindist := pt.X;
                  rec.Left := 0;
                  rec.Bottom := 0;
                  rec.Right := Comp.Size;
                  rec.Top := client.Top;

                  IF Comp.Alignment = tb THEN
                  BEGIN
                       dec(rec.Right, Comp.Size);
                       dec(rec.Left, Comp.Size);
                  END;
             END;
             tbRight:
             IF client.Right - pt.X < mindist THEN
             BEGIN
                  Result := tb;
                  mindist := client.Right - pt.X;
                  rec.Left := client.Right - Comp.Size;
                  rec.Bottom := 0;
                  rec.Right := client.Right;
                  rec.Top := client.Top;

                  IF Comp.Alignment = tb THEN
                  BEGIN
                       inc(rec.Right, Comp.Size);
                       inc(rec.Left, Comp.Size);
                  END;
             END;
             {tbStatus,}tbBottom:
             IF pt.Y < mindist THEN
             BEGIN
                  Result := tb;
                  mindist := pt.Y;
                  rec.Left := 0;
                  rec.Bottom := 0;
                  rec.Right := client.Right;
                  rec.Top := Comp.Size;

                  IF Comp.Alignment = tb THEN
                  BEGIN
                       dec(rec.Top, Comp.Size);
                       dec(rec.Bottom, Comp.Size);
                  END;
             END;
             tbTop:
             IF client.Top - pt.Y < mindist THEN
             BEGIN
                  Result := tb;
                  mindist := client.Top - pt.Y;
                  rec.Left := 0;
                  rec.Bottom := client.Top - Comp.Size;
                  rec.Right := client.Right;
                  rec.Top := client.Top;

                  IF (Comp.Alignment = tb) AND (Comp.Handle <> 0) THEN
                  BEGIN
                       inc(rec.Top, Comp.Size);
                       inc(rec.Bottom, Comp.Size);
                  END;
             END;
          END;
     END;
END;


PROCEDURE TFormEditor.UpdateToolBarRect(Comp:TToolbar;pt:TPoint;VAR rec:TRect);
VAR  client:TRect;
BEGIN
     IF MouseMode <> mmInsertSize THEN exit;
     client := ClientRect;

     CASE Comp.Alignment OF
        tbLeft:
        BEGIN
             rec.Right := pt.X;
        END;
        tbRight:
        BEGIN
             rec.Left := pt.X;
        END;
        {tbStatus,}tbBottom:
        BEGIN
             rec.Top := pt.Y;
        END;
        tbTop:
        BEGIN
             rec.Bottom := pt.Y;
        END;
     END;
END;


FUNCTION TFormEditor.GetFirstSelected:TComponent;
VAR  Item:PSelectItem;
BEGIN
     Result := NIL;
     IF SelectList.Count = 0 THEN exit;
     Item := SelectList.First;
     IF Item = NIL THEN exit;
     Result := Item^.Component;
END;


{$HINTS OFF}
PROCEDURE TFormEditor.MenuItemFocus(AMenu:TMenu;Entry:TMenuItem);
BEGIN
     {Msg.Handled := TRUE;
     Msg.Result := 0;}

     IF AMenu <> NIL THEN IF not AMenu.Designed THEN exit;
     IF Entry <> NIL THEN IF not Entry.Designed THEN exit;

     ClearSelection;
     SelectComponent(NIL);
     IF Entry=NIL THEN
     BEGIN
          SelectComponent(TControl(AMenu));
          UpdateInspectorData(TComponent(AMenu));
     END
     ELSE
     BEGIN
          SelectComponent(TControl(Entry));
          UpdateInspectorData(TComponent(Entry));
     END;
END;


CONST MenuIDEEditStr     = '..........';

PROCEDURE TFormEditor.MenuCharEvent(AMenu:TMenu;Entry:TMenuItem;VAR Key:CHAR;rep:BYTE);
BEGIN
     IF AMenu = NIL THEN exit;
     IF not AMenu.Designed THEN exit;
     IF Entry = NIL THEN exit;
     IF not Entry.Designed THEN exit;

     Entry.Caption := Entry.Caption + Key;
     UpdateInspectorData(Entry);
     Project.SCUModified := TRUE;
     {Msg.Handled := TRUE;}
END;


PROCEDURE TFormEditor.MenuScanEvent(AMenu:TMenu;Entry:TMenuItem;VAR KeyCode:TKeyCode;rep:BYTE);
VAR  s:STRING;
     Comp:TComponent;
     idx:LONGINT;
     AParent:TMenuItem;
     NewEntry:TMenuItem;
     isedit:BOOLEAN;
BEGIN
     IF AMenu = NIL THEN exit;
     IF not AMenu.Designed THEN exit;
     IF Entry = NIL THEN exit;
     IF not Entry.Designed THEN exit;

     CASE KeyCode OF
       {$IFDEF OS2}
       kbCR,
       {$ENDIF}
       kbEnter,kbF11:
       BEGIN
            IF Inspector = NIL THEN InitInspector;
            Comp := GetFirstSelected;
            IF Comp = NIL THEN Comp := SELF;
            SetInspectorFocus(Comp);
       END;
       kbF12:
       BEGIN
            IF CodeEditorRef.WindowState = wsMinimized
            THEN CodeEditorRef.WindowState := wsNormal;
            s := GetUnitName(SELF);
            IF LoadEditor(s,0,0,0,0,TRUE,CursorIgnore,Fokus,ShowIt) = NIL
            THEN ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[s]));
       END;
       kbBkSp:
       BEGIN
            s := Entry.Caption;
            IF s <> '' THEN
            BEGIN
                 dec(s[0]);
                 Entry.Caption := s;
                 UpdateInspectorData(Entry);
                 Project.SCUModified := TRUE;
            END;
       END;
       kbDel:
       BEGIN
            IF Entry.IsEditMenuItem THEN exit;

            UpdateInspectorData(AMenu);
            ClearSelection;
            SelectComponent(NIL);

            Entry.Destroy;
            Project.SCUModified := TRUE;
       END;
       kbIns:
       BEGIN
            AParent := Entry.Parent;
            IF AParent = NIL THEN exit;
            idx := Entry.MenuIndex;
            IF idx < 0 THEN exit;

            NewEntry.Create(SELF);
            NewEntry.Caption := '';
            AParent.Insert(idx,NewEntry);

            GenNewComponent(SELF,NewEntry);

            {bei Insert im MainMenu ein EditEntry anhngen}
            IF AMenu IS TMainMenu THEN
              IF AParent = Menu.Items THEN
            BEGIN
                 Entry.Create(SELF);
                 Entry.Caption := MenuIDEEditStr;
                 NewEntry.Add(Entry);
            END;
       END;
     END;
END;

{$IFDEF OS2}
PROCEDURE TFormEditor.evComponentHintTimer(Sender:TObject);

Begin
  HideComponentHint(tControl(Sender));
End;
{$ENDIF}

PROCEDURE TFormEditor.EvFrameMouseDown(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     FrameSizing := TRUE;
     FrameInitPos.X := Left;
     FrameInitPos.Y := Bottom;
END;


PROCEDURE TFormEditor.EvFrameMouseMove(Sender:TObject;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     IF DesignPosBtn <> NIL THEN DesignPosBtn.Caption := '';
END;
{$HINTS ON}


PROCEDURE TFormEditor.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     Inherited MouseClick(Button,ShiftState,X,Y);

     IF Button = mbRight THEN ShowContextMenu(SELF,X,Y);
END;


TYPE
    TDesignerNotifyItem = CLASS(TMenuItem)
    END;


PROCEDURE TFormEditor.ShowContextMenu(Comp:TComponent; X,Y:LONGINT);
VAR  Entry:TMenuItem;
     LayoutEntry:TMenuItem;
     pt:TPoint;
     i:LONGINT;
     AStrings:TStringList;
     NotifyEntry:TDesignerNotifyItem;
BEGIN
     IF FormEditPopup = NIL THEN
     BEGIN
          Exclude(ComponentState, csDesigning);      {!!!}
          FormEditPopup.Create(SELF);
          Include(FormEditPopup.ComponentState, csDetail);
          Include(ComponentState, csDesigning);

          CopyEntry.Create(FormEditPopup);
          CopyEntry.Caption := LoadNLSStr(SiFormPopupCopy);
          CopyEntry.Command := cmCopy;
          CopyEntry.HelpContext := hctxPopupFormDesignerCopy;
          FormEditPopup.Items.Add(CopyEntry);

          PasteEntry.Create(FormEditPopup);
          PasteEntry.Caption := LoadNLSStr(SiFormPopupPaste);
          PasteEntry.Command := cmPaste;
          PasteEntry.HelpContext := hctxPopupFormDesignerPaste;
          FormEditPopup.Items.Add(PasteEntry);

          DeleteEntry.Create(FormEditPopup);
          DeleteEntry.Caption := LoadNLSStr(SiFormPopupDelete);
          DeleteEntry.Command := cmDelete;
          DeleteEntry.HelpContext := hctxPopupFormDesignerDelete;
          FormEditPopup.Items.Add(DeleteEntry);

          Entry.Create(FormEditPopup);
          Entry.Caption := '-';
          FormEditPopup.Items.Add(Entry);

          LayoutEntry.Create(FormEditPopup);
          LayoutEntry.Caption := LoadNLSStr(SiFormPopupAlignment);
          LayoutEntry.OnClick := EvAlignmentPalette;
          LayoutEntry.HelpContext := hctxPopupFormDesignerAlignment;
          FormEditPopup.Items.Add(LayoutEntry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign1);
            Entry.Command := cmAlign1;
            Entry.HelpContext := hctxPopupAlign1;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign4);
            Entry.Command := cmAlign4;
            Entry.HelpContext := hctxPopupAlign4;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign5);
            Entry.Command := cmAlign5;
            Entry.HelpContext := hctxPopupAlign5;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign8);
            Entry.Command := cmAlign8;
            Entry.HelpContext := hctxPopupAlign8;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := '-';
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign2);
            Entry.Command := cmAlign2;
            Entry.HelpContext := hctxPopupAlign2;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign6);
            Entry.Command := cmAlign6;
            Entry.HelpContext := hctxPopupAlign6;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign3);
            Entry.Command := cmAlign3;
            Entry.HelpContext := hctxPopupAlign3;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign7);
            Entry.Command := cmAlign7;
            Entry.HelpContext := hctxPopupAlign7;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := '-';
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign9);
            Entry.Command := cmAlign9;
            Entry.HelpContext := hctxPopupAlign9;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign10);
            Entry.Command := cmAlign10;
            Entry.HelpContext := hctxPopupAlign10;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign11);
            Entry.Command := cmAlign11;
            Entry.HelpContext := hctxPopupAlign11;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign12);
            Entry.Command := cmAlign12;
            Entry.HelpContext := hctxPopupAlign12;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign13);
            Entry.Command := cmAlign13;
            Entry.HelpContext := hctxPopupAlign13;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiAlign14);
            Entry.Command := cmAlign14;
            Entry.HelpContext := hctxPopupAlign14;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := '-';
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiForceAlign);
            Entry.Command := cmForceAlign;
            Entry.HelpContext := hctxPopupForceAlign;
            LayoutEntry.Add(Entry);

            Entry.Create(FormEditPopup);
            Entry.Caption := LoadNLSStr(SiRefresh);
            Entry.Command := cmRefresh;
            Entry.HelpContext := hctxPopupRefreshForm;
            LayoutEntry.Add(Entry);

            GridVisEntry.Create(FormEditPopup);
            GridVisEntry.Caption := LoadNLSStr(SiGridVisible);
            GridVisEntry.Command := cmGridVis;
            Entry.HelpContext := hctxPopupGridVisible;
            LayoutEntry.Add(GridVisEntry);

            SnapGridEntry.Create(FormEditPopup);
            SnapGridEntry.Caption := LoadNLSStr(SiSnapToGrid);
            SnapGridEntry.Command := cmSnapToGrid;
            Entry.HelpContext := hctxPopupSnapToGrid;
            LayoutEntry.Add(SnapGridEntry);


          Entry.Create(FormEditPopup);
          Entry.Caption := LoadNLSStr(SiFormPopupLayoutPalette);
          Entry.OnClick := EvAlignmentPalette;
          Entry.HelpContext := hctxPopupFormDesignerLayoutPalette;
          FormEditPopup.Items.Add(Entry);

          Entry.Create(FormEditPopup);
          Entry.Caption := LoadNLSStr(SiFormPopupObjectInspector);
          Entry.OnClick := EvObjectInspector;
          Entry.HelpContext := hctxPopupFormDesignerObjectInspector;
          FormEditPopup.Items.Add(Entry);

          Entry.Create(FormEditPopup);
          Entry.Caption := '-';
          FormEditPopup.Items.Add(Entry);

          Entry.Create(FormEditPopup);
          Entry.Caption := LoadNLSStr(SiFormPopupFormSourceLocation);
          Entry.OnClick := EvFormChangeSource;
          Entry.HelpContext := hctxPopupFormDesignerFormSourceLocation;
          FormEditPopup.Items.Add(Entry);

          Entry.Create(FormEditPopup);
          Entry.Caption := LoadNLSStr(SiFormPopupSaveFormToFile);
          Entry.OnClick := EvSaveToFile;
          Entry.HelpContext := hctxPopupFormDesignerSaveFormToFile;
          FormEditPopup.Items.Add(Entry);

          Entry.Create(FormEditPopup);
          Entry.Caption := LoadNLSStr(SiFormPopupSaveFormAsTemplate);
          Entry.OnClick := EvAddToRepository;
          Entry.HelpContext := hctxPopupFormDesignerSaveFormAsTemplate;
          FormEditPopup.Items.Add(Entry);

          Entry.Create(FormEditPopup);
          Entry.Caption := '-';
          FormEditPopup.Items.Add(Entry);

          Entry.Create(FormEditPopup);
          Entry.Caption := LoadNLSStr(SiFormPopupProperties);
          Entry.OnClick := EvProperties;
          Entry.HelpContext := hctxPopupFormDesignerProperties;
          FormEditPopup.Items.Add(Entry);
     END;


     IF LastPopupComponent <> Comp THEN
     BEGIN {entferne die MenuItems von LastPopupComponent}
          IF LastPopupComponent <> NIL THEN
          BEGIN
               FOR i := FormEditPopup.Items.Count-1 DOWNTO 0 DO
               BEGIN
                    Entry := FormEditPopup.Items[i];
                    IF Entry IS TDesignerNotifyItem THEN Entry.Destroy;
               END;
          END;

          {fge die neuen MenuItems von Comp an}
          LastPopupComponent := Comp;
          AStrings.Create;
          // Property Editoren
          GetPropEditPopupEvents(LastPopupComponent,AStrings);

          IF AStrings.Count > 0 THEN
          BEGIN
               NotifyEntry.Create(FormEditPopup);
               NotifyEntry.Caption := '-';
               FormEditPopup.Items.Insert(0,NotifyEntry);

               FOR i := AStrings.Count-1 DOWNTO 0 DO
               BEGIN
                    NotifyEntry.Create(FormEditPopup);
                    NotifyEntry.Caption := AStrings[i] + '...';
                    NotifyEntry.Tag := 0;
                    NotifyEntry.OnClick := EvCallPropEditEvent;
                    FormEditPopup.Items.Insert(0,NotifyEntry);
               END;
          END;
          AStrings.Clear;

          // Eigene Kommandos
          LastPopupComponent.GetDesignerPopupEvents(AStrings);

          IF AStrings.Count > 0 THEN
          BEGIN
               NotifyEntry.Create(FormEditPopup);
               NotifyEntry.Caption := '-';
               FormEditPopup.Items.Insert(0,NotifyEntry);

               FOR i := AStrings.Count-1 DOWNTO 0 DO
               BEGIN
                    NotifyEntry.Create(FormEditPopup);
                    NotifyEntry.Caption := AStrings[i];
                    NotifyEntry.Tag := LONGINT(AStrings.Objects[i]);
                    NotifyEntry.OnClick := EvDesignerEvent;
                    FormEditPopup.Items.Insert(0,NotifyEntry);
               END;
          END;
          AStrings.Destroy;
     END;

     CopyEntry.Enabled := SelectList.Count > 0;

     PasteEntry.Enabled := ClipBoard.IsFormatAvailable(cfComponents);

     DeleteEntry.Enabled := SelectList.Count > 0;

     GridVisEntry.Checked := IdeSettings.Designer.GridVisible;

     SnapGridEntry.Checked := IdeSettings.Designer.GridActive;


     pt := ClientToScreen(Point(X,Y));
     FormEditPopup.Popup(pt.X,pt.Y);
END;


PROCEDURE TFormEditor.EvDesignerEvent(Sender:TObject);
BEGIN
     TRY
        IF Sender IS TDesignerNotifyItem THEN
          IF LastPopupComponent IS TComponent
          THEN LastPopupComponent.DesignerPopupEvent(TComponent(Sender).Tag);
     EXCEPT
     END;
END;


PROCEDURE TFormEditor.EvCallPropEditEvent(Sender:TObject);
VAR  s:STRING;
BEGIN
     TRY
        IF Sender IS TDesignerNotifyItem THEN
          IF LastPopupComponent IS TComponent THEN
          BEGIN
               s := TDesignerNotifyItem(Sender).Caption;
               SetLength(s,Length(s)-3); // cut '...'
               CallPropEdit(LastPopupComponent,s);
          END;
     EXCEPT
     END;
END;


PROCEDURE ChangeSourceLocation(FormItem:PFormListItem);
VAR  FOD:TOpenDialog;
BEGIN
  FOD.Create(Application.MainForm);
  FOD.HelpContext := hctxDialogOpenFormSourceLocation;
  FOD.Caption := LoadNLSStr(SiChangeFormLocation);
  FOD.OkName := LoadNLSStr(SiChange);
  FOD.FileName := FormItem^.UnitName;
  FOD.AddFilter(LoadNLSStr(SiPascalFiles)+' (*.pas)','*.PAS');
  FOD.DefaultExt := GetDefaultExt('*.PAS');
  IF FOD.Execute THEN
    BEGIN
      FormItem^.UnitName := FOD.FileName;
      Project.Modified := TRUE;
      Project.NeedRecompile := TRUE;
      Project.SCUModified := TRUE;
    END;
  FOD.Destroy;
END;


PROCEDURE TFormEditor.EvFormChangeSource(Sender:TObject);
VAR  FormItem:PFormListItem;
     i:LONGINT;
BEGIN
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          IF FormItem^.Form = SELF THEN
          BEGIN
               ChangeSourceLocation(FormItem);
               exit;
          END;
     END;
END;


PROCEDURE SaveFormToFile(FormItem:PFormListItem);
VAR  FSD:TSaveDialog;
     TempList:TList;
     TMS:TMemoryStream;
     OldSCU:POINTER;
     F:FILE;
     s:STRING;
LABEL ex,ex1;
BEGIN
     FSD.Create(Application.MainForm);
     FSD.HelpContext := hctxDialogSaveFormToFile;
     FSD.Caption := FmtLoadNLSStr(SiSaveFormToFileCaption,[FormItem^.FormName]);
     FSD.FileName := FormItem^.FormName;
     FSD.AddFilter(LoadNLSStr(SiSibylFormFiles)+' (*.scu)','*.SCU');
     FSD.DefaultExt := GetDefaultExt('*.SCU');
     IF FSD.Execute THEN
     BEGIN
          s := FSD.FileName;
          IF FileExists(s) THEN
          BEGIN
               IF Dialogs.MessageBox(FmtLoadNLSStr(SiFileAlreadyExistsOverwrite,[s]),
                                     mtWarning,mbOkCancel) = mrCancel THEN goto ex1;
          END;

          OldSCU := SCUPointer;
          SCUPointer := NIL;
          TempList.Create;

          IF FormItem^.Form <> NIL THEN
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
                    ErrorBox(FmtLoadNLSStr(SiCouldNotCreateSCUForForm,
                                           [FormItem^.FormName]));
                    goto ex;
               END;
          END;

          {write TMS to file}
          Assign(F,s);
          {$i-}
          Rewrite(F,1);
          IF IoResult = 0 THEN
          BEGIN
               BlockWrite(F,FormItem^.SCUPointer^,FormItem^.SCUSize);
               IF IoResult <> 0 THEN ErrorBox(FmtLoadNLSStr(SiCouldNotWriteFile,[s]));
               System.Close(F);
          END
          ELSE ErrorBox(FmtLoadNLSStr(SiCouldNotWriteFile,[s]));
          {$i+}

          {delete temporary TMS}
          IF (FormItem^.Form <> NIL) AND (FormItem^.SCUPointer <> NIL) THEN
          BEGIN
               FreeMem(FormItem^.SCUPointer, FormItem^.SCUSize);
               FormItem^.SCUPointer := NIL;
               FormItem^.SCUSize := 0;
          END;
ex:
          TempList.Destroy;
          SCUPointer := OldSCU;
     END;
ex1:
     FSD.Destroy;
END;


PROCEDURE TFormEditor.EvSaveToFile(Sender:TObject);
VAR  FormItem:PFormListItem;
     i:LONGINT;
BEGIN
  FOR i := 0 TO Project.Forms.Count-1 DO
    BEGIN
      FormItem := Project.Forms.Items[i];
      IF FormItem^.Form = SELF THEN
        BEGIN
          SaveFormToFile(FormItem);
          exit;
        END;
    END;
END;


PROCEDURE TFormEditor.EvAddToRepository(Sender:TObject);
BEGIN
     SendMsg(Application.MainForm.Handle,CM_COMMAND,cmAddToRepository,0);
END;


PROCEDURE TFormEditor.EvAlignmentPalette(Sender:TObject);
BEGIN
  AlignmentPalette.DockingState := dsFloat;
  AlignmentPalette.Form.BringToFront;
END;


PROCEDURE TFormEditor.EvObjectInspector(Sender:TObject);
VAR  Comp:TComponent;
BEGIN
  InitInspector;

  Comp := GetFirstSelected;
  IF Comp = NIL THEN Comp := SELF;
  SetInspectorFocus(Comp);
END;


PROCEDURE TFormEditor.EvProperties(Sender:TObject);
BEGIN
  ActiveGeneralPage := DesignerPropertiesIndex;
  SendMsg(Application.MainForm.Handle,CM_COMMAND,cmGeneral,0);
END;


PROCEDURE AlignToGridWidth(VAR Width:LONGINT);
BEGIN
     WITH IdeSettings.Designer DO
     BEGIN
          Width := round(Width / GridWidth) * GridWidth;
     END;
END;


PROCEDURE AlignToGridHeight(VAR Height:LONGINT);
BEGIN
     WITH IdeSettings.Designer DO
     BEGIN
          Height := round(Height / GridHeight) * GridHeight;
     END;
END;


PROCEDURE TFormEditor.Activate;
BEGIN
     Inherited Activate;

     LastFocusedForm := SELF;
END;


FUNCTION MouseDownInsertsComponent:BOOLEAN;
BEGIN
     Result := (Navigator_GetInsertComponent <> NIL) OR (PasteInitiated);
END;


FUNCTION TFormEditor.TestInsert(VAR AParent:TControl;CompClass:TComponentClass):BOOLEAN;
BEGIN
     Result := FALSE;

     IF not (CompClass IS TComponent) THEN
     BEGIN
          MouseCapture := FALSE;
          ErrorBox(FmtLoadNLSStr(SiNoTComponentDescendant,[CompClass.ClassName]));
          exit;
     END;

     Result := TRUE;
END;


PROCEDURE TFormEditor.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR  ComponentClass:TComponentClass;
     Component:TControl;
     Item:PSelectItem;
     rec:TRect;
     i:INTEGER;
     AParent:TControl;
     Toolbar:TToolbar;
     AMenu:TMainMenu;
     MenuItem:TMenuItem;
     RefWin:TReferenceWindow;
LABEL l,form;
BEGIN
     Inherited MouseDown(Button,ShiftState,X,Y);

     LastMsg.Handled := TRUE;

     IF Button = mbRight THEN
     BEGIN
          Navigator_EnableArrow;
          exit;
     END
     ELSE IF Button <> mbLeft THEN exit;

     ClearSelection;
     MouseCapture := TRUE;

     {Insert Navigator element}
     ComponentClass := Navigator_GetInsertComponent;
     IF ComponentClass <> NIL THEN
     BEGIN
          {Suche Parent, Owner ist immer die Form}
          AParent := SELF;
          WHILE SingleSelect <> NIL DO
          BEGIN
               IF SingleSelect.ComponentState * [csAcceptsControls] <> [] THEN
               BEGIN
                    AParent := SingleSelect;
                    break; {WHILE}
               END;
               SingleSelect := SingleSelect.Parent;
          END;

          {Test, ob das Element erzeugt werden darf}
          IF not TestInsert(AParent,ComponentClass) THEN
          BEGIN
               Navigator_EnableArrow;
               SingleSelect := NIL;
               MouseCapture := FALSE;
               exit;
          END;

          {_C_R_E_A_T_E___I_T_}
          Component := TControl(ComponentClass.Create(SELF));
          NewInsertParent := AParent;

          IF not (Component IS TControl) THEN
          BEGIN
               AMenu := TMainMenu(Component);
               IF AMenu IS TMainMenu THEN
               BEGIN
                    //SelectComponent(NIL);
                    AMenu.SetDesigning(TRUE);
                    {Generate first entry}
                    MenuItem.Create(SELF);
                    MenuItem.Caption := MenuIDEEditStr;
                    AMenu.Items.Add(MenuItem);

                    IF Menu = NIL THEN Menu := AMenu; {insert MainMenu}
               END;
form:
               IF TPopupMenu(Component) IS TPopupMenu THEN
               BEGIN
                    {Generate first entry}
                    MenuItem.Create(SELF);
                    MenuItem.Caption := MenuIDEEditStr;
                    TPopupMenu(Component).Items.Add(MenuItem);
               END;


               SingleSelect := NIL;
               SelectComponent(NIL);
               Component.SetDesigning(TRUE);
               {TReference erzeugen}
               RefWin.Create(SELF);
               RefWin.SetReference(Component);
               Component := RefWin;
               Project.SCUModified := TRUE;
          END
          ELSE IF Component IS TForm THEN goto form;

          SelectComponent(NIL);
          Component.SetDesigning(TRUE);
          IF IdeSettings.Designer.InsertMode = ci_DropMove THEN
          BEGIN
               FrameInit.X := -(Component.Width DIV 2);
               FrameInit.Y := -(Component.Height DIV 2);
               Component.Left := X + FrameInit.X;
               Component.Bottom := Y + FrameInit.Y;
               MouseMode := mmInsertMove;
               CursorIntern := crDropMove;
          END
          ELSE {Drop_Size}
          BEGIN
               FrameInit := Point(X,Y);
               Component.Left := X;
               Component.Bottom := Y;
               {Store original size for Click-Insert}
               InitSize.X := Component.Width;
               InitSize.Y := Component.Height;
               MouseMode := mmInsertSize;
               CursorIntern := crDropSize;
          END;
          {bis jetzt Comp Pos relativ zu Form}
          rec.Left := Component.Left;
          rec.Bottom := Component.Bottom;
          Form2ParentKoord(AParent, rec);
          Component.Left := rec.Left;
          Component.Bottom := rec.Bottom;
          {jetzt Comp Pos relativ zu AParent}

          SelectComponent(Component);

          Toolbar := TToolBar(GetFirstSelected);
          IF Toolbar IS TToolbar THEN  {Init FrameRec if Selected is a Toolbar}
          BEGIN
               Toolbar.Alignment := GetPossibleToolBar(Toolbar,Point(X,Y),FrameRec);
               {Update FrameRec using pt}
               UpdateToolBarRect(Toolbar,Point(X,Y),FrameRec);
          END
          ELSE
          BEGIN                        {Init FrameRec if Selected is a Component}
               GetSelectionPos(FrameRec);

               IF MouseMode = mmInsertSize THEN  {Initial size = 0}
               BEGIN
                    FrameRec.Right := FrameRec.Left;
                    FrameRec.Top := FrameRec.Bottom;
               END;
          END;

          DrawDragBorders(Canvas);
          exit;
     END;

     {Insert Clipboard elements ?}
     IF PasteInitiated THEN
     BEGIN
          PasteInitiated := FALSE;

          {Suche Parent, Owner ist immer die Form}
          AParent := SELF;
          WHILE SingleSelect <> NIL DO
          BEGIN
               IF SingleSelect.ComponentState * [csAcceptsControls] <> [] THEN
               BEGIN
                    AParent := SingleSelect;
                    break; {WHILE}
               END;
               SingleSelect := SingleSelect.Parent;
          END;

          InsertPasteComponents(AParent,X,Y);

          exit;
     END;

     {Sizing}
     IF SizeCorner <> 0 THEN
     BEGIN
          IF (SizeCorner AND 1) <> 0 THEN FrameInit.X := X - FrameRec.Right
          ELSE
          IF (SizeCorner AND 8) <> 0 THEN FrameInit.X := X - FrameRec.Left;

          IF (SizeCorner AND 4) <> 0 THEN FrameInit.Y := Y - FrameRec.Top
          ELSE
          IF (SizeCorner AND 2) <> 0 THEN FrameInit.Y := Y - FrameRec.Bottom;

          DragPoint := Point(X,Y);
          MouseMode := mmSize;
          DrawDragBorders(Canvas);
          exit;
     END;

     {Dragging}
     IF SingleSelect <> NIL THEN
     BEGIN
          FOR i := 0 TO SelectList.Count-1 DO
          BEGIN
               Item := SelectList.Items[i];
               IF Item <> NIL THEN
                 IF Item^.Component <> NIL THEN
                   IF Item^.Component = SingleSelect THEN
               BEGIN
                    SelectList.Move(i,0);
                    goto l;
               END;
          END;
          SelectComponent(NIL);
          SelectComponent(SingleSelect);
l:
          GetSelectionPos(FrameRec);
          Toolbar := TToolBar(GetFirstSelected);
          IF Toolbar IS TToolbar THEN
          BEGIN
               GetPossibleToolBar(Toolbar,Point(X,Y),FrameRec);
          END;

          DragPoint := Point(X,Y);
          FrameInit.X := FrameRec.Left - X;
          FrameInit.Y := FrameRec.Bottom - Y;
          MouseMode := mmDrag;
          CursorIntern := crDragging;
          DrawDragBorders(Canvas);
          exit;
     END;

     {Multiselection}
     UpdateInspectorData(SELF);
     SingleSelect := NIL;
     SelectComponent(NIL);
     FrameInit := Point(X,Y);
     FrameRec.Left := X;
     FrameRec.Right := X;
     FrameRec.Bottom := Y;
     FrameRec.Top := Y;
     DrawInvertRect(Canvas,FrameRec);
     MouseMode := mmMultiSelection;
     CursorIntern := crMultiSelect;
END;


PROCEDURE TFormEditor.MouseMove(ShiftState:TShiftState;X,Y:LONGINT);
VAR  rec,NewRec:TRect;
     xMiddle:LONGINT;
     yMiddle:LONGINT;
     Toolbar:TToolbar;
     tb:TToolbarAlign;
     FRec:TRect;
     NewFrameRec:TRect;
     FInit:TPoint;
LABEL l;
BEGIN
     Inherited MouseMove(ShiftState,X,Y);

     IF DesignPosBtn <> NIL THEN DesignPosBtn.Caption := tostr(X) + ':' + tostr(Y);

     {Possible Insert}
     IF (Navigator_GetInsertComponent <> NIL) AND (MouseMode = mmNothing) THEN
     BEGIN
          CursorIntern := crInsert;
          exit;
     END;

     IF (PasteInitiated) AND (MouseMode = mmNothing) THEN
     BEGIN
          CursorIntern := crPaste;
          exit;
     END;

     {Borders}
     IF MouseMode IN [mmDrag,mmInsertMove,mmInsertSize] THEN
     BEGIN
          Toolbar := TToolBar(GetFirstSelected);
          IF Toolbar IS TToolbar THEN
          BEGIN
               IF MouseMode = mmInsertMove THEN
               BEGIN
                    tb := GetPossibleToolBar(Toolbar,Point(X,Y),FRec);
                    IF tb <> Toolbar.Alignment THEN
                    BEGIN
                         DrawDragBorders(Canvas);      {Delete old}
                         Toolbar.Alignment := tb;
                         FrameRec := FRec;
                         DrawDragBorders(Canvas);      {Draw new}
                    END;
               END;

               IF MouseMode = mmInsertSize THEN
               BEGIN
                    FRec := FrameRec;
                    UpdateToolBarRect(Toolbar,Point(X,Y),FRec);
                    IF FrameRec <> FRec THEN
                    BEGIN
                         DrawDragBorders(Canvas);      {Delete old}
                         FrameRec := FRec;
                         DrawDragBorders(Canvas);      {Draw new}
                    END;
               END;

               IF MouseMode = mmDrag THEN
               BEGIN
                    GetPossibleToolBar(Toolbar,Point(X,Y),FRec);
                    IF FrameRec <> FRec THEN
                    BEGIN
                         DrawDragBorders(Canvas);      {Delete old}
                         FrameRec := FRec;
                         DrawDragBorders(Canvas);      {Draw new}
                    END;
               END;
               exit;
          END;

          NewFrameRec := FrameRec;

          IF MouseMode IN [mmDrag,mmInsertMove] THEN
          BEGIN
               NewFrameRec.Left := X + FrameInit.X;
               NewFrameRec.Bottom := Y + FrameInit.Y;
          END;
          IF MouseMode IN [mmInsertSize] THEN
          BEGIN
               IF FrameInit.X < X THEN
               BEGIN
                    NewFrameRec.Left := FrameInit.X;
                    NewFrameRec.Right := X;
               END
               ELSE
               BEGIN
                    NewFrameRec.Left := X;
                    NewFrameRec.Right := FrameInit.X;
               END;
               IF FrameInit.Y < Y THEN
               BEGIN
                    NewFrameRec.Bottom := FrameInit.Y;
                    NewFrameRec.Top := Y;
               END
               ELSE
               BEGIN
                    NewFrameRec.Bottom := Y;
                    NewFrameRec.Top := FrameInit.Y;
               END;
          END;

          IF IdeSettings.Designer.GridActive THEN
          BEGIN
               AlignToGridWidth(NewFrameRec.Left);
               AlignToGridHeight(NewFrameRec.Bottom);

               IF MouseMode = mmInsertSize THEN
               BEGIN
                    AlignToGridWidth(NewFrameRec.Right);
                    AlignToGridHeight(NewFrameRec.Top);
               END;
          END;

          IF NewFrameRec = FrameRec THEN exit; {nothing to do}

          DrawDragBorders(Canvas);
          FrameRec := NewFrameRec;
          DrawDragBorders(Canvas);
          exit;
     END;

     {Sizing}
     IF MouseMode = mmSize THEN
     BEGIN
          NewRec := FrameRec;
          FInit := FrameInit;

          IF (SizeCorner AND 1) <> 0 THEN
          BEGIN
               NewRec.Right := X - FInit.X;
               IF IdeSettings.Designer.GridActive
               THEN AlignToGridWidth(NewRec.Right);
          END
          ELSE
          IF (SizeCorner AND 8) <> 0 THEN
          BEGIN
               NewRec.Left := X - FInit.X;
               IF IdeSettings.Designer.GridActive
               THEN AlignToGridWidth(NewRec.Left);
          END;
          IF (SizeCorner AND 4) <> 0 THEN
          BEGIN
               NewRec.Top := Y - FInit.Y;
               IF IdeSettings.Designer.GridActive
               THEN AlignToGridHeight(NewRec.Top);
          END
          ELSE
          IF (SizeCorner AND 2) <> 0 THEN
          BEGIN
               NewRec.Bottom := Y - FInit.Y;
               IF IdeSettings.Designer.GridActive
               THEN AlignToGridHeight(NewRec.Bottom);
          END;
          IF NewRec = FrameRec THEN exit;   {nothing to do}

          DrawDragBorders(Canvas);
          FrameRec := NewRec;
          DrawDragBorders(Canvas);
          exit;
     END;

     {Rubberband}
     IF MouseMode = mmMultiSelection THEN
     BEGIN
          DrawInvertRect(Canvas,FrameRec);
          IF FrameInit.X < X THEN
          BEGIN
               FrameRec.Left := FrameInit.X;
               FrameRec.Right := X;
          END
          ELSE
          BEGIN
               FrameRec.Left := X;
               FrameRec.Right := FrameInit.X;
          END;
          IF FrameInit.Y < Y THEN
          BEGIN
               FrameRec.Bottom := FrameInit.Y;
               FrameRec.Top := Y;
          END
          ELSE
          BEGIN
               FrameRec.Bottom := Y;
               FrameRec.Top := FrameInit.Y;
          END;
          DrawInvertRect(Canvas,FrameRec);
          exit;
     END;

     {CursorIntern}
     SizeCorner := 0;
     IF SelectList.Count <> 1 THEN goto l;

     Rec.Left := FrameRec.Left-5;
     Rec.Right := FrameRec.Right+5;
     Rec.Bottom := FrameRec.Bottom-5;
     Rec.Top := FrameRec.Top+5;
     IF NOT PointInRect(Point(X,Y),Rec) THEN goto l;

     IF PointInRect(Point(X,Y),FrameRec) THEN goto l;  {nur im Sizingbereich}

     IF X < FrameRec.Left+5 THEN SizeCorner := SizeCorner OR 8
     ELSE IF X > FrameRec.Right-5 THEN SizeCorner := SizeCorner OR 1;
     IF Y < FrameRec.Bottom+5 THEN SizeCorner := SizeCorner OR 2
     ELSE IF Y > FrameRec.Top-5 THEN SizeCorner := SizeCorner OR 4;

     xMiddle := FrameRec.Left + ((FrameRec.Right-FrameRec.Left) DIV 2);
     yMiddle := FrameRec.Bottom + ((FrameRec.Top-FrameRec.Bottom) DIV 2);

     CASE SizeCorner OF
        1 : BEGIN
                 Rec.Left := FrameRec.Right-3;
                 Rec.Bottom := yMiddle-4;
            END;
        2 : BEGIN
                 Rec.Left := xMiddle-4;
                 Rec.Bottom := FrameRec.Bottom-5;
            END;
        3 : BEGIN
                 Rec.Left := FrameRec.Right-3;
                 Rec.Bottom := FrameRec.Bottom-5;
            END;
        4 : BEGIN
                 Rec.Left := xMiddle-4;
                 Rec.Bottom := FrameRec.Top-3;
            END;
        5 : BEGIN
                 Rec.Left := FrameRec.Right-3;
                 Rec.Bottom := FrameRec.Top-3;
            END;
        8 : BEGIN
                 Rec.Left := FrameRec.Left-5;
                 Rec.Bottom := yMiddle-4;
            END;
       10 : BEGIN
                 Rec.Left := FrameRec.Left-5;
                 Rec.Bottom := FrameRec.Bottom-5;
            END;
       12 : BEGIN
                 Rec.Left := FrameRec.Left-5;
                 Rec.Bottom := FrameRec.Top-3;
            END;
       ELSE goto l;
     END;

     Rec.Right := Rec.Left+8;
     Rec.Top := Rec.Bottom+8;
     IF NOT PointInRect(Point(X,Y),Rec) THEN SizeCorner := 0;

l:
     CASE SizeCorner OF
         1,8  : CursorIntern := crSizeWE;
         2,4  : CursorIntern := crSizeNS;
         3,12 : CursorIntern := crSizeNWSE;
         5,10 : CursorIntern := crSizeNESW;
         ELSE   CursorIntern := crNormal;
     END;
END;


PROCEDURE TFormEditor.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR  Component:TControl;
     CompRec:TRect;
     Item:PSelectItem;
     rec:TRect;
     i:LONGINT;
     AParent:TControl;
     NewList:TList;
     x1,y1,w1,h1:LONGINT;
     RedrawCtrl:TControl;
     Toolbar:TToolbar;
     RefWin:TReferenceWindow;
LABEL gsp;
BEGIN
     Inherited MouseUp(Button,ShiftState,X,Y);

     LastMsg.Handled := TRUE;

     IF Button <> mbLeft THEN exit;

     DrawDragBorders(Canvas);
     MouseCapture := FALSE;
     RedrawCtrl := NIL;

     {Insert from Navigator or Clipboard}
     IF MouseMode IN [mmInsertSize,mmInsertMove] THEN
     BEGIN
          IF MouseMode = mmInsertMove THEN
          BEGIN
               FrameRec.Left := X + FrameInit.X;
               FrameRec.Bottom := Y + FrameInit.Y;

               IF IdeSettings.Designer.GridActive THEN
               BEGIN
                    AlignToGridWidth(FrameRec.Left);
                    AlignToGridHeight(FrameRec.Bottom);

                    IF MouseMode = mmInsertSize THEN
                    BEGIN
                         AlignToGridWidth(FrameRec.Right);
                         AlignToGridHeight(FrameRec.Top);
                    END;
               END;
          END;

          IF MouseMode = mmInsertSize THEN
          BEGIN
               IF (FrameRec.Right - FrameRec.Left < 3) AND
                  (FrameRec.Top - FrameRec.Bottom < 3) THEN
               BEGIN  {Click-Insert}
                    Component := TControl(GetFirstSelected);
                    IF Component IS TControl THEN
                    BEGIN
                         Component.Width := InitSize.X;
                         Component.Height := InitSize.Y;
                    END;
               END;
          END;

          IF (ShiftState * [ssShift] = []) AND (not Navigator_MultiInsertMode)
          THEN Navigator_EnableArrow;   {!! unbedingt drin lassen !!}

          MouseMode := mmNothing;
          CursorIntern := crNormal;

          FOR i := SelectList.Count-1 DOWNTO 0 DO
          BEGIN
               Item := SelectList.Items[i];
               IF Item <> NIL THEN
                 IF Item^.Component <> NIL THEN
               BEGIN
                    Component := Item^.Component;
                    Component.Left := FrameRec.Left + Item^.Offs.X;
                    Component.Bottom := FrameRec.Bottom + Item^.Offs.Y;

                    RedrawCtrl := Component;

                    IF NewInsertParent IS TControl THEN
                    BEGIN
                         AParent := NewInsertParent;
                         rec.Left := Component.Left;
                         rec.Bottom := Component.Bottom;
                         Form2ParentKoord(AParent, rec);
                         Component.Left := rec.Left;
                         Component.Bottom := rec.Bottom;

                         NewInsertParent.InsertControl(Component);
                    END;
                    NewInsertParent := NIL;

                    IF Component IS TReferenceWindow THEN
                    BEGIN
                         RefWin := TReferenceWindow(Component);
                         {TypeCast is ok weil keine Eig. von TControl gebraucht werden}
                         Component := TControl(RefWin.Reference);
                    END;
                    GenNewComponent(SELF,Component);

                    {Insert new Component in Inspector ListBox}
                    SetInspectorData(Component);  {Set new Name in Combo}
                    AddInspectorItem(Component);
               END;
               Project.SCUModified := TRUE;
          END;
     END;

     {End Dragging}
     IF MouseMode = mmDrag THEN
     BEGIN
          Project.SCUModified := TRUE;
          Toolbar := TToolBar(GetFirstSelected);
          IF Toolbar IS TToolbar THEN
          BEGIN
               Toolbar.Alignment := GetPossibleToolBar(Toolbar,Point(X,Y),FrameRec);
               goto gsp;
          END;

          FrameRec.Left := X + FrameInit.X;
          FrameRec.Bottom := Y + FrameInit.Y;
          AParent := SELF;
          Component := TControl(GetFirstSelected);
          IF Component IS TControl THEN {parent bestimmen}
          BEGIN
               AParent := TControl(Component.Parent);
               RedrawCtrl := Component;
          END;

          IF IdeSettings.Designer.GridActive THEN
          BEGIN
               AlignToGridWidth(FrameRec.Left);
               AlignToGridHeight(FrameRec.Bottom);
          END;

          Form2ParentKoord(AParent, FrameRec);

          FOR i := SelectList.Count-1 DOWNTO 0 DO
          BEGIN
               Item := SelectList.Items[i];
               IF Item <> NIL THEN
                 IF Item^.Component <> NIL THEN
                   IF Item^.Component IS TControl THEN
               BEGIN
                    Component := Item^.Component;
                    IF Component.xAlign <> xaNone THEN x1 := Component.Left
                    ELSE x1 := FrameRec.Left + Item^.Offs.X;
                    IF Component.yAlign <> yaNone THEN y1 := Component.Bottom
                    ELSE y1 := FrameRec.Bottom + Item^.Offs.Y;

                    Component.SetWindowPos(x1,y1,Component.Width,Component.Height);
               END;
          END;
     END;

     {End Sizing}
     IF MouseMode = mmSize THEN
     BEGIN
          Component := TControl(GetFirstSelected);
          AParent := TControl(Component).Parent;
          RedrawCtrl := Component;

          Form2ParentKoord(AParent, FrameRec);

          IF Component.xAlign = xaNone THEN x1 := FrameRec.Left
          ELSE x1 := Component.Left;
          IF Component.yAlign = yaNone THEN y1 := FrameRec.Bottom
          ELSE y1 := Component.Bottom;

          w1 := Component.Width;
          IF Component.xStretch = xsNone THEN
            IF not (((SizeCorner AND 8 <> 0) AND
                     (Component.xAlign IN [xaLeft])) OR
                    ((SizeCorner AND 1 <> 0) AND
                     (Component.xAlign IN [xaRight])))
            THEN w1 := FrameRec.Right - FrameRec.Left +1;

          h1 := Component.Height;
          IF Component.yStretch = ysNone THEN
            IF not (((SizeCorner AND 2 <> 0) AND
                     (Component.yAlign IN [yaBottom])) OR
                    ((SizeCorner AND 4 <> 0) AND
                     (Component.yAlign IN [yaTop])))
            THEN h1 := FrameRec.Top - FrameRec.Bottom +1;

          Component.SetWindowPos(x1,y1,w1,h1);
          Project.SCUModified := TRUE;
     END;

     {End Multiselection}
     IF MouseMode = mmMultiSelection THEN
     BEGIN
          DrawInvertRect(Canvas,FrameRec);
          {BreitenSuche nach dem ersten Element, das ins FrameRec reinpaแt}
          NewList.Create;
          {Init List}
          FOR i := 0 TO ControlCount-1 DO NewList.Add(Controls[i]);

          WHILE NewList.Count > 0 DO
          BEGIN
               Component := TControl(NewList.First);
               IF Component IS TControl THEN
                 {IF Component.Visible THEN {NoteBook Elemente!!}
                   IF Component.ComponentState * [csDetail,csReference] = [] THEN
               BEGIN
                    CompRec := GetFormCoordinates(Component);
                    IF RectIsPartOfMultiSelection(Comprec,FrameRec) THEN
                    BEGIN {erstes gefunden}
                         AParent := Component.Parent;
                         FOR i := 0 TO AParent.ControlCount-1 DO
                         BEGIN
                              Component := AParent.Controls[i];
                              CompRec := GetFormCoordinates(Component);
                              IF RectIsPartOfMultiSelection(Comprec,FrameRec) THEN
                              BEGIN
                                   SelectComponent(Component);
                                   RedrawCtrl := Component;
                              END;
                         END;
                         break; {WHILE}
                    END
                    ELSE {Append its children at the end of the list}
                    BEGIN
                         FOR i := 0 TO Component.ControlCount-1 DO
                         BEGIN
                              NewList.Add(Component.Controls[i]);
                         END;
                    END;
               END;
               NewList.Delete(0);
          END;
          NewList.Destroy;
     END;

gsp:
     UpdateFormSelect(RedrawCtrl);

     IF MouseMode <> mmNothing THEN CaptureFocus;

     MouseMode := mmNothing;
     CursorIntern := crNormal;
     InvalidateFormWindow;
     SingleSelect := NIL;
END;

{$IFDEF OS2}
Procedure TFormEditor.ShowComponentHint(Sender:TControl; DNSCode : TDesignerNotifyCode);

var HintRect   : tRect;
    Txt        : String;
    BubbleSizeX: LongInt;
    BubbleSizeY: LongInt;
    Pos        : tPoint;

Begin
  if (FHintWindow.Visible) then exit;

  if (DNSCode<>dncMouseMove) and ((HasFocus=false) or (fOldHintSender = Sender))
    then exit;

  txt:=Sender.ClassUnit+', '+Sender.Classname+', '+Sender.Name;
  FHintWindow.Canvas.GetTextExtent(txt,BubbleSizeX,BubbleSizeY);
  inc(BubbleSizeX,6);
  inc(BubbleSizeY,4);

  HintRect.Left  := Left;
  HintRect.Bottom:= Bottom-BubbleSizeY-2;
  HintRect.Right := HintRect.Left   + BubbleSizeX;
  HintRect.Top   := HintRect.Bottom + BubbleSizeY;

  FHintWindow.ActivateHint(HintRect, txt);
  fComponentHintTimer.Start;
  fOldHintSender:=Sender;
End;

Procedure TFormEditor.HideComponentHint(Sender:TControl);

Begin
  fComponentHintTimer.Stop;
  if fHintWindow <> nil then
    fHintWindow.DeactivateHint;
End;
{$ENDIF}

PROCEDURE TFormEditor.DesignerNotification(VAR DNS:TDesignerNotifyStruct);
VAR  Item:PSelectItem;
     Component:TControl;
     Sender:TControl;
     pt:TPoint;
     Button:TMouseButton;
     ShiftState:TShiftState;
     i:LONGINT;

LABEL l;

  PROCEDURE GetRealSender(VAR Sender:TControl;step,hold:TComponentState);
  BEGIN
       WHILE TRUE DO
       BEGIN
            IF Sender.ComponentState * hold <> [] THEN break;
            IF Sender.ComponentState * step <> [] THEN
            BEGIN
                 IF Sender.Parent = NIL THEN break
                 ELSE Sender := Sender.Parent;
            END
            ELSE break;
       END;
  END;

BEGIN
     Sender := TControl(DNS.Sender);
     pt := DNS.mouseparam.pt;
     Button := DNS.mouseparam.Button;
     ShiftState := DNS.mouseparam.ShiftState;

     {$IFDEF Win32}
     IF Sender IS TListBox THEN {korrigiere um die Randbreite}
     BEGIN
          inc(pt.X,3);
          dec(pt.Y,3);
     END;
     {$ENDIF}

     {$IFDEF OS2}
     if DNS.Code <> dncMouseMove
       then HideComponentHint(Sender);
     {$ENDIF}

//  Writeln('Start:', DateTimeToStr(now),',',LongWord(DNS.code),',',LongWord(dncMouseMove));
     CASE DNS.Code OF
         dncMouseDown:
         IF Button = mbLeft THEN
         BEGIN
              IF not (ssShift IN ShiftState) THEN {select new}
              BEGIN
                   IF MouseDownInsertsComponent
                   THEN GetRealSender(Sender,[csDetail,csReference],[csAcceptsControls])
                   ELSE GetRealSender(Sender,[csDetail,csReference],[]);

                   DNS.Return := 1;               {Msg.Handled := TRUE}
                   IF Sender <> SELF THEN SingleSelect := Sender;
                   MouseDown(mbLeft,ShiftState,pt.X,pt.Y);
                   IF not (MouseMode IN [mmInsertSize,mmInsertMove]) THEN
                     IF SizeCorner = 0 THEN {Inspector im MultiComponentMode}
                       IF SelectList.Count < 2 THEN UpdateInspectorData(Sender)
                       ELSE UpdateInspectorDataList(SelectList,SELF);
              END
              ELSE {toggle}
              BEGIN
                   GetRealSender(Sender,[csDetail,csReference],[]);

                   DNS.Return := 1;               {Msg.Handled := TRUE}
                   Navigator_EnableArrow;

                   IF SelectList.Count > 0 THEN
                   BEGIN
                        Item := SelectList.First;
                        IF Item = NIL THEN exit;
                        IF Item^.Component = NIL THEN exit;
                        IF Item^.Component.Parent <> Sender.Parent THEN
                        BEGIN
                             ClearSelection;
                             SelectComponent(NIL);
                        END;
                   END;

                   FOR i := 0 TO SelectList.Count-1 DO {Test whether Add or Remove}
                   BEGIN
                        Item := SelectList.Items[i];
                        IF Item <> NIL THEN
                          IF Item^.Component <> NIL THEN
                            IF Item^.Component = Sender THEN
                            BEGIN
                                 ClearSelection;
                                 SelectList.Delete(i);
                                 Dispose(Item);
                                 goto l;
                            END;
                   END;
                   SelectComponent(Sender);
l:
                   UpdateSelection;
                   IF SelectList.Count > 0 THEN
                   BEGIN
                        UpdateInspectorDataList(SelectList,SELF);
                   END
                   ELSE UpdateInspectorData(SELF);  {war Set...}

                   SingleSelect := Sender;
              END;
         END;
         dncMouseUp:
         BEGIN
              DNS.Return := 1; {Msg.Handled := TRUE}
              IF Button = mbLeft THEN SingleSelect := NIL;
         END;
         dncMouseClick:
         BEGIN
              DNS.Return := 1; {Msg.Handled := TRUE}

              IF Button = mbRight THEN
              BEGIN
                   GetRealSender(Sender,[csDetail,csReference],[]);

                   ShowContextMenu(Sender, pt.X,pt.Y);
                   DNS.Return := 1;               {Msg.Handled := TRUE}
              END;
         END;
         dncMouseDblClk:
         BEGIN
              IF Button = mbLeft THEN
              BEGIN
                   IF Sender IS TReferenceWindow THEN
                   BEGIN
                        IF TReferenceWindow(Sender).Reference IS TMainMenu THEN
                        BEGIN
                             {neues MainMenu}
                             Menu := TMainMenu(TReferenceWindow(Sender).Reference);
                             Project.SCUModified := TRUE;
                             Sender := NIL;
                        END;
                   END;

                   IF Sender <> NIL THEN InsertDefaultEvent(Sender);
                   DNS.Return := 1;               {Msg.Handled := TRUE}
              END;
         END;
         dncMouseMove:
         BEGIN

           GetRealSender(Sender,[csDetail,csReference],[]);
           DNS.Return := 1;               {Msg.Handled := TRUE}
           if (pt.x<>fOldMousePos.X) or (pt.y<>fOldMousePos.y) then
             begin  // checken ob wirklich die Maus sich bewegt hat

                MouseMove(ShiftState,pt.X,pt.Y);
               IF (ShiftState * [ssLeft,ssShift] = [ssLeft,ssShift]) THEN
                 BEGIN
                   {$IFDEF OS2}
                   HideComponentHint(Sender);
                   {$ENDIF}
                   IF Sender = SingleSelect THEN exit;

                   IF ControlCount > 0 THEN
                   BEGIN
                        Component := TControl(GetFirstSelected);
                        IF Component = NIL THEN exit;
                        IF Component.Parent <> Sender.Parent THEN exit;
                        FOR i := 0 TO SelectList.Count-1 DO {Test whether Add}
                        BEGIN
                             Item := SelectList.Items[i];
                             IF Item <> NIL THEN
                               IF Item^.Component = Sender THEN exit;
                        END;
                   END;
                   SelectComponent(Sender);
                   UpdateSelection;
                END;
{$IFDEF OS2}
                if (Sender<>Self) and (ShiftState = [])
                  then ShowComponentHint(Sender, DNS.Code)
                  else HideComponentHint(Sender);
{$ENDIF}
                fOldMousePos:=pt;
              end;
         END;
         dncPaint:
         BEGIN
              IF not RectsDrawn THEN exit;
              IF MouseMode IN [mmInsertSize,mmInsertMove,mmDrag,mmSize,
                               mmMultiSelection] THEN exit;

              IF Canvas <> NIL THEN
              BEGIN
                   Canvas.Pen.Color := OppositeRGB(Color);
                   IF SelectList<>NIL THEN
                   FOR i := 0 TO SelectList.Count-1 DO
                   BEGIN
                       Item := SelectList.Items[i];
                       IF Item <> NIL THEN
                       BEGIN
                           Component := Item^.Component;
                           IF Component <> NIL
                           THEN DrawComponentRects(Component,i=0);
                       END;
                   END;
              END;
         END;
         dncSCUModified:
         BEGIN
              Project.SCUModified := TRUE;
         END;
         dncNewMenuItem:
         BEGIN
              IF Upcased(Sender.Name) = 'MENUITEM'
              THEN GenNewComponent(SELF,Sender);
         END;
         dncPropertyUpdate:
         Begin
              IF Inspector.InspectedObjectsList<>Nil Then
                 UpdateInspectorDataList(Inspector.InspectedObjectsList,SELF)
              ELSE UpdateInspectorData(Inspector.InspectedObject);  {war Set...}
         End;
     END;
END;


PROCEDURE TFormEditor.SetFocus;
VAR  Comp:TControl;
BEGIN
     Inherited SetFocus;

     IF Inspector <> NIL THEN Inspector.WriteBackProperties;

     LastDesignForm := SELF;
     Comp := SELF;

     IF SelectList<>Nil Then
     BEGIN
          IF SelectList.Count > 0 THEN UpdateInspectorDataList(SelectList,SELF)
          ELSE UpdateInspectorData(Comp);
     END
     ELSE UpdateInspectorData(Comp);
END;


PROCEDURE TFormEditor.SelectComponent(Component:TControl);
VAR  i:LONGINT;
     Item:PSelectItem;
BEGIN
     IF Component = NIL THEN {l”sche SelectList}
     BEGIN
          FOR i := 0 TO SelectList.Count-1 DO
          BEGIN
               Item := SelectList.Items[i];
               IF Item <> NIL THEN Dispose(Item);
          END;
          SelectList.Clear;
     END
     ELSE
     BEGIN
          IF Component = SELF THEN exit;
          IF not (Component IS TControl) THEN exit;

          New(Item);
          Item^.Component := Component;
          SelectList.Add(Item);
     END;
END;


FUNCTION TFormEditor.GetSelectionPos(VAR rec:TRect):BOOLEAN;
VAR  i:LONGINT;
     Item:PSelectItem;
     Component:TControl;
     AParent:TControl;
     max:LONGINT;
     CompWidth,CompHeight:LONGINT;
BEGIN
     Result := FALSE;
     IF SelectList.Count = 0 THEN exit;
     rec.Left := MaxLongInt;
     rec.Bottom := MaxLongInt;
     rec.Right := MinLongInt;
     rec.Top := MinLongInt;
     Component := NIL;
     FOR i := 0 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
               BEGIN
                    Item^.Offs.X := Component.Left;
                    Item^.Offs.Y := Component.Bottom;
                    CompWidth := Component.Width;
                    CompHeight := Component.Height;

                    max := Item^.Offs.X + CompWidth;
                    IF max > rec.Right THEN rec.Right := max;
                    max := Item^.Offs.Y + CompHeight;
                    IF max > rec.Top THEN rec.Top := max;
                    IF Item^.Offs.X < rec.Left THEN rec.Left := Item^.Offs.X;
                    IF Item^.Offs.Y < rec.Bottom THEN rec.Bottom := Item^.Offs.Y;
               END;
          END;
     END;

     dec(rec.Right);
     dec(rec.Top);

     FOR i := 0 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Item^.Offs.X := Item^.Offs.X - rec.Left;
               Item^.Offs.Y := Item^.Offs.Y - rec.Bottom;
          END;
     END;

     IF Component IS TControl THEN      {nicht fr MenuItems...}
     BEGIN
          IF NewInsertParent <> NIL THEN AParent := NewInsertParent
          ELSE AParent := TControl(Component).Parent;

          Parent2FormKoord(AParent, rec);
          Result := TRUE;
     END;
END;


FUNCTION TFormEditor.GetParentCanvas(Component:TComponent;VAR RealParent:TControl):TCanvas;
BEGIN
     Result := Canvas;
     {beim Mouse Insert ist Parent noch nicht gesetzt}
     IF MouseMode IN [mmInsertMove,mmInsertSize]
     THEN RealParent := NewInsertParent
     ELSE RealParent := TControl(Component).Parent;

     {Suche Canvas zum Zeichnen der Border: entweder Toolbar oder Form}
     IF RealParent IS TControl THEN
     BEGIN
          WHILE (RealParent <> NIL) AND (RealParent <> SELF) AND
                 RealParent.Designed DO
          BEGIN
               IF RealParent IS TToolBar THEN
               BEGIN
                    Result := RealParent.Canvas;
                    exit;
               END;
               RealParent := TControl(RealParent).Parent;
          END;
     END;
END;


PROCEDURE TFormEditor.DrawDragBorders(aCanvas:TCanvas);
VAR  Component:TControl;
     AParent:TControl;
     Item:PSelectItem;
     rec:TRect;
     i:LONGINT;
     RealParent:TControl;
LABEL toolb;
BEGIN
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;
     IF Component IS TToolbar THEN goto toolb;
     IF MouseMode = mmInsertSize THEN goto toolb;

     IF MouseMode <> mmSize THEN
     BEGIN
          FOR i := SelectList.Count-1 DOWNTO 0 DO
          BEGIN
               Item := SelectList.Items[i];
               IF Item <> NIL THEN
               BEGIN
                    Component := Item^.Component;
                    IF Component <> NIL THEN
                    BEGIN
                         rec.Left := FrameRec.Left + Item^.Offs.X;
                         rec.Bottom := FrameRec.Bottom + Item^.Offs.Y;

                         aCanvas := GetParentCanvas(Component,RealParent);
                         IF RealParent IS TToolBar THEN
                         BEGIN
                              dec(rec.Left,RealParent.Left);
                              dec(rec.Bottom,RealParent.Bottom);
                         END;

                         rec.Right := rec.Left + Component.Width -1;
                         rec.Top := rec.Bottom + Component.Height -1;
                         DrawInvertRect(aCanvas,rec);
                    END;
               END;
          END;
     END
     ELSE
     BEGIN
toolb:
          rec := FrameRec;
          aCanvas := GetParentCanvas(Component,RealParent);
          IF RealParent IS TToolBar THEN
          BEGIN
               dec(rec.Left,RealParent.Left);
               dec(rec.Right,RealParent.Left);
               dec(rec.Bottom,RealParent.Bottom);
               dec(rec.Top,RealParent.Bottom);
          END;
          DrawInvertRect(aCanvas,rec);
     END;

     Component := TControl(GetFirstSelected);
     IF Component = NIL THEN exit;

     {do not update the real window position}
     Include(Component.DesignerState, dsNoRealSizing);

     IF Component.xAlign = xaNone THEN Component.Left := rec.Left;
     IF Component.yAlign = yaNone THEN Component.Bottom := rec.Bottom;
     IF MouseMode IN [mmSize,mmInsertSize] THEN
     BEGIN
          IF Component.xStretch = xsNone THEN
            IF not (((SizeCorner AND 8 <> 0) AND
                     (Component.xAlign IN [xaLeft])) OR
                    ((SizeCorner AND 1 <> 0) AND
                     (Component.xAlign IN [xaRight])))
            THEN Component.Width := rec.Right-rec.Left +1;

          IF Component.yStretch = ysNone THEN
            IF not (((SizeCorner AND 2 <> 0) AND
                     (Component.yAlign IN [yaBottom])) OR
                    ((SizeCorner AND 4 <> 0) AND
                     (Component.yAlign IN [yaTop])))
            THEN Component.Height := rec.Top-rec.Bottom +1;
     END;

     rec.Left := Component.Left;
     rec.Bottom := Component.Bottom;

     GetParentCanvas(Component,RealParent);

     IF NewInsertParent <> NIL THEN AParent := NewInsertParent
     ELSE AParent := TControl(Component).Parent;

     IF RealParent IS TToolBar THEN Toolbar2ParentKoord(AParent, rec)
     ELSE Form2ParentKoord(AParent, rec);

     IF Component.xAlign = xaNone THEN Component.Left := rec.Left;
     IF Component.yAlign = yaNone THEN Component.Bottom := rec.Bottom;

     Exclude(Component.DesignerState, dsNoRealSizing);

     UpdateInspectorDataList(SelectList,SELF);
END;


PROCEDURE TFormEditor.DrawInvertRect(aCanvas:TCanvas;rec:TRect);
BEGIN
     aCanvas.DrawInvertRect(rec);
END;


PROCEDURE TFormEditor.DrawGrid(rec:TRect);
VAR  t,t1:LONGINT;
     pt:TPoint;
BEGIN
     IF IdeSettings.Designer.GridWidth <= 0 THEN exit;
     IF IdeSettings.Designer.GridHeight <= 0 THEN exit;

     rec.Left := (rec.Left DIV IdeSettings.Designer.GridWidth) *
                  IdeSettings.Designer.GridWidth;
     rec.Right := (rec.Right DIV IdeSettings.Designer.GridWidth) *
                   IdeSettings.Designer.GridWidth;
     rec.Bottom := (rec.Bottom DIV IdeSettings.Designer.GridHeight) *
                    IdeSettings.Designer.GridHeight;
     rec.Top := (rec.Top DIV IdeSettings.Designer.GridHeight) *
                 IdeSettings.Designer.GridHeight;

     Canvas.Pen.Color := clBlack;
     FOR t := rec.Bottom TO rec.Top DO
     BEGIN
          FOR t1 := rec.Left TO rec.Right DO
          BEGIN
               pt.X := t1;
               pt.Y := t;
               IF GetControlFromPoint(pt) = SELF
               THEN Canvas.Pixels[t1,t]:=Canvas.Pen.Color;
               inc(t1, IdeSettings.Designer.GridWidth-1);
          END;
          inc(t, IdeSettings.Designer.GridHeight-1);
     END;
END;


PROCEDURE TFormEditor.ClearSelection;
VAR  i:LONGINT;
     Item:PSelectItem;
     Component:TControl;
BEGIN
     Component := TControl(GetFirstSelected);

     Canvas.Pen.Color := Color;
     IF Component IS TControl THEN
       IF Component.Parent IS TControl
       THEN Canvas.Pen.Color := Component.Parent.Color;

     FOR i := 0 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component <> NIL THEN DrawComponentRects(Component,i=0);
          END;
     END;
     RectsDrawn := FALSE;
     Canvas.Pen.Color := clBlack;
END;


PROCEDURE TFormEditor.UpdateSelection;
BEGIN
     GetSelectionPos(FrameRec);
     InvalidateFormWindow;
END;


PROCEDURE TFormEditor.DrawComponentRects(Component:TControl;Fill:BOOLEAN);
BEGIN
     IF not (Component IS TControl) THEN exit;
     DrawHandles(Component.Left,Component.Bottom,
                 Component.Width,Component.Height,
                 Component,Fill);
END;


PROCEDURE TFormEditor.DrawHandles(x,y,w,h:LONGINT;Component:TControl;Fill:BOOLEAN);
VAR  rec:TRect;
     xMiddle:LONGINT;
     yMiddle:LONGINT;
     AParent:TControl;
     RealParent:TControl;
     aCanvas:TCanvas;
BEGIN
     IF Component = SELF THEN exit;
     IF not (Component IS TControl) THEN exit; {MenuItems ?}

     rec.Left := X;
     rec.Bottom := Y;

     IF Component IS TToolbar THEN
     BEGIN
          rec.Left := Component.Left;
          rec.Bottom := Component.Bottom;
     END;

     dec(rec.Left, 3);
     dec(rec.Bottom, 3);

     aCanvas := GetParentCanvas(Component,RealParent);
     aCanvas.Pen.Color := Canvas.Pen.Color;
     AParent := Component.Parent;
     IF RealParent IS TToolBar THEN Parent2ToolbarKoord(AParent, rec)
     ELSE Parent2FormKoord(AParent, rec);

     rec.Right := rec.Left + W-1 +6;
     rec.Top := rec.Bottom + H-1 +6;
     xMiddle := rec.Left + ((rec.Right-rec.Left) DIV 2);
     yMiddle := rec.Bottom + ((rec.Top-rec.Bottom) DIV 2);

     FillRects := Fill;
     DrawCompRect(aCanvas,rec.Left,rec.Bottom);
     DrawCompRect(aCanvas,xMiddle,rec.Bottom);
     DrawCompRect(aCanvas,rec.Right,rec.Bottom);
     DrawCompRect(aCanvas,rec.Left,yMiddle);
     DrawCompRect(aCanvas,rec.Right,yMiddle);
     DrawCompRect(aCanvas,rec.Left,rec.Top);
     DrawCompRect(aCanvas,xMiddle,rec.Top);
     DrawCompRect(aCanvas,rec.Right,rec.Top);
END;


PROCEDURE TFormEditor.DrawCompRect(aCanvas:TCanvas;x,y:LONGINT);
VAR  rec:TRect;
     cc:TColor;
BEGIN
     rec.Left := x-2;
     rec.Bottom := y-2;
     rec.Right := x+2;
     rec.Top := y+2;
     IF FillRects THEN aCanvas.Box(rec)
     ELSE aCanvas.Rectangle(rec);

     IF Canvas.Pen.Color = Color THEN
       IF IdeSettings.Designer.GridVisible THEN
       BEGIN
            cc := Canvas.Pen.Color;
            DrawGrid(rec);
            Canvas.Pen.Color := cc;
       END;
END;


PROCEDURE TFormEditor.Resize;
VAR  Comp:TControl;
     deltaX,deltaY:LONGINT;
     i:INTEGER;
     x,y:LONGINT;
BEGIN
     Inherited Resize;

     IF Inspector <> NIL THEN
       IF Inspector.InspectedObject = SELF
       THEN Inspector.UpdateInspectorData(SELF);

     IF WndState = wsMinimized THEN exit;
     IF VDERestoring THEN exit;

{$IFDEF Win32}
exit;   {temp}
{$ENDIF}
     IF FrameSizing THEN
     BEGIN
          FrameSizing := FALSE;
          deltaX := FrameInitPos.X - Frame.Left;
          deltaY := FrameInitPos.Y - Frame.Bottom;
          IF (deltaX <> 0) OR (deltaY <> 0) THEN
          FOR i := 0 TO ControlCount-1 DO
          BEGIN
               Comp := Controls[i];
               IF Comp.ComponentState * [csDetail] = [] THEN {ScrollBars!}
                 IF not (Comp IS TToolBar) THEN
                 BEGIN
                      IF (Comp.xAlign = xaNone) AND (Comp.xStretch IN [xsNone,xsFixed])
                      THEN x := Comp.Left + deltaX
                      ELSE x := Comp.Left;

                      IF (Comp.yAlign = yaNone) AND (Comp.yStretch IN [ysNone,ysFixed])
                      THEN y := Comp.Bottom + deltaY
                      ELSE y := Comp.Bottom;

                      Comp.SetWindowPos(x,y,Comp.Width,Comp.Height);
                 END;
          END;
          GetSelectionPos(FrameRec);
          Project.SCUModified := TRUE;
     END;
END;


PROCEDURE TFormEditor.Move;
BEGIN
     Inherited Move;

     IF Inspector <> NIL THEN
       IF Inspector.InspectedObject = SELF
       THEN Inspector.UpdateInspectorData(SELF);

     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);
BEGIN
     Application.MainForm.OnTranslateShortCut(SELF,KeyCode,Receiver);

     IF KeyCode = kbShiftF10 THEN
     BEGIN
          ShowContextMenu(GetFirstSelected, Width DIV 2, Height DIV 2);
     END;
END;


PROCEDURE TFormEditor.ScanEvent(VAR Keycode:TKeyCode;RepeatCount:BYTE);
VAR  Item:PSelectItem;
     Component:TControl;
     Comp:TComponent;
     LastX:LONGINT;
     LastY:LONGINT;
     LastCX:LONGINT;
     LastCY:LONGINT;
     s:STRING;
     MsgHandled:BOOLEAN;
BEGIN
     MsgHandled := TRUE;

     CASE Keycode OF
       kbEsc:              CancelOperation;
       kbTab:              SelectNextComponent;
       kbShiftTab:         SelectPreviousComponent;
       kbShiftDel:         CutSelectedComponents;
       kbCtrlIns:          CopySelectedComponents;
       kbShiftIns:         PasteComponents;
       kbDel,
       kbCtrlDel:          DeleteSelectedComponents;
       kbCUp,
       kbCDown,
       kbCLeft,
       kbCRight:           SelectNearestComponent(Keycode);
       kbCtrlCUp,
       kbCtrlCDown,
       kbCtrlCLeft,
       kbCtrlCRight,
       kbCtrlShiftCUp,
       kbCtrlShiftCDown,
       kbCtrlShiftCLeft,
       kbCtrlShiftCRight:  MoveSelectedComponents(Keycode,RepeatCount);
       kbShiftCUp,
       kbShiftCDown,
       kbShiftCLeft,
       kbShiftCRight:      SizeSelectedComponents(Keycode,RepeatCount);
       kbAltCLeft:         Align1;
       kbAltHome:          Align2;
       kbAltPageUp:        Align3;
       kbAltCRight:        Align4;
       kbAltCUp:           Align5;
       kbAltEnd:           Align6;
       kbAltPageDown:      Align7;
       kbAltCDown:         Align8;
       {$IFDEF OS2}
       kbCR,
       {$ENDIF}
       kbF11:
       BEGIN
            IF Inspector = NIL THEN InitInspector;
            Comp := GetFirstSelected;
            IF Comp = NIL THEN Comp := SELF;
            SetInspectorFocus(Comp);
       END;
       kbF12:
       BEGIN
            IF CodeEditorRef.WindowState = wsMinimized
            THEN CodeEditorRef.WindowState := wsNormal;
            s := GetUnitName(SELF);
            IF LoadEditor(s,0,0,0,0,TRUE,CursorIgnore,Fokus,ShowIt) = NIL
            THEN ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[s]));
       END;
       kbBkSp:
       BEGIN
            Component := SELF;
            IF SelectList.Count > 0 THEN
            BEGIN
                 Item := SelectList.First;
                 IF Item <> NIL THEN Component := Item^.Component;
            END;

            IF Component IS TControl THEN
            BEGIN
                 LastX := Component.Left;
                 LastY := Component.Bottom;
                 LastCX := Component.Width;
                 LastCY := Component.Height;

                 s := Component.Caption;
                 delete(s,Length(s),1);
                 IF s = '' THEN
                 BEGIN
                      s := '';
                 END;
                 Component.Caption := s;
                 UpdateInspectorData(Component);

                 IF (LastX <> Component.Left) OR (LastY <> Component.Bottom) OR
                    (LastCX <> Component.Width) OR (LastCY <> Component.Height)
                 THEN NotifySM(LastX,LastY,LastCX,LastCY,Component);
                 Project.SCUModified := TRUE;
            END;
       END;
       kbCtrlF1:
       BEGIN
            Component := SELF;
            IF SelectList.Count > 0 THEN
            BEGIN
                 Item := SelectList.First;
                 IF Item <> NIL THEN Component := Item^.Component;
            END;
            IF Component IS TReferenceWindow
            THEN Component := TControl(TReferenceWindow(Component).Reference);

            s := Component.ClassName;
            IF not Application.HelpJump(s) THEN Application.HelpIndex;
       END;
       ELSE MsgHandled := FALSE;
     END;

     IF MsgHandled THEN KeyCode := kbNull
     ELSE Application.MainForm.ScanEvent(KeyCode,RepeatCount);
     KeyCode := kbNull;
END;


{$HINTS OFF}
PROCEDURE TFormEditor.CharEvent(VAR Key:CHAR;RepeatCount:BYTE);
VAR  Item:PSelectItem;
     Component:TControl;
     LastX:LONGINT;
     LastY:LONGINT;
     LastCX:LONGINT;
     LastCY:LONGINT;
BEGIN
     Component := SELF;
     IF SelectList.Count > 0 THEN
     BEGIN
          Item := SelectList.First;
          IF Item <> NIL THEN Component := Item^.Component;
     END;

     IF Component IS TReferenceWindow THEN exit;

     IF Component IS TControl THEN
     BEGIN
          LastX := Component.Left;
          LastY := Component.Bottom;
          LastCX := Component.Width;
          LastCY := Component.Height;

          Component.Caption := Component.Caption + Key;
          UpdateInspectorData(Component);

          IF (LastX <> Component.Left) OR (LastY <> Component.Bottom) OR
             (LastCX <> Component.Width) OR (LastCY <> Component.Height)
          THEN NotifySM(LastX,LastY,LastCX,LastCY,Component);
          Project.SCUModified := TRUE;
     END;
END;
{$HINTS ON}

PROCEDURE TFormEditor.CancelOperation;
VAR  i:LONGINT;
     Item:PSelectItem;
     SCUModified:BOOLEAN;
     GridActive:BOOLEAN;
BEGIN
     CASE MouseMode OF
         mmInsertSize,mmInsertMove:
         BEGIN
              DrawDragBorders(Canvas);
              FOR i := 0 TO SelectList.Count-1 DO
              BEGIN
                   Item := SelectList.Items[i];
                   IF Item <> NIL THEN
                     IF Item^.Component <> NIL
                     THEN Item^.Component.Destroy;
              END;
              Navigator_EnableArrow;
              MouseMode := mmNothing;
              CursorIntern := crNormal;
              SelectComponent(NIL);
              UpdateInspectorData(SELF);  {war Set...}
         END;
         mmDrag:
         BEGIN
              SCUModified := Project.SCUModified;
              GridActive := IdeSettings.Designer.GridActive;
              IdeSettings.Designer.GridActive := FALSE;

              MouseUp(mbLeft,[],DragPoint.X,DragPoint.Y);

              Project.SCUModified := SCUModified;
              IdeSettings.Designer.GridActive := GridActive;
         END;
         mmSize:
         BEGIN
              GridActive := IdeSettings.Designer.GridActive;
              IdeSettings.Designer.GridActive := FALSE;

              MouseMove([],DragPoint.X,DragPoint.Y); {Update FrameRec}
              MouseMode := mmNothing;

              IdeSettings.Designer.GridActive := GridActive;
         END;
         mmNothing:
         BEGIN
              SelectParentComponent;
         END;
     END;
END;


PROCEDURE TFormEditor.SelectAll;
VAR  i:LONGINT;
BEGIN
     SelectComponent(NIL);
     FOR i := 0 TO ControlCount-1 DO SelectComponent(Controls[i]);
     Invalidate;
END;


PROCEDURE TFormEditor.DeselectAll;
BEGIN
     SelectComponent(NIL);
     Invalidate;
END;


PROCEDURE TFormEditor.SelectParentComponent;
VAR  Item:PSelectItem;
     ActSelect:TComponent;
     AParent:TComponent;
BEGIN
     IF ControlCount = 0 THEN exit;
     AParent := SELF;
     IF SelectList.Count > 0 THEN
     BEGIN
          ClearSelection;
          Item := SelectList.First;
          IF Item <> NIL THEN
          BEGIN
               ActSelect := Item^.Component;
               AParent := ActSelect.Owner;
               SelectComponent(NIL);
          END;
     END;

     SelectComponent(TControl(AParent));
     GetSelectionPos(FrameRec);
     InvalidateFormWindow;
     IF SelectList.Count = 0 THEN UpdateInspectorData(SELF);

     IF AParent IS TControl THEN TControl(AParent).BringToFront;
END;


PROCEDURE TFormEditor.SelectNextComponent;
VAR  Item:PSelectItem;
     ActSelect:TComponent;
     AParent:TComponent;
     i:LONGINT;
BEGIN
     IF ControlCount = 0 THEN exit;
     AParent := SELF;
     IF SelectList.Count > 0 THEN
     BEGIN
          ClearSelection;
          Item := SelectList.First;
          IF Item <> NIL THEN
          BEGIN
               ActSelect := Item^.Component;
               AParent := ActSelect.Owner;
               SelectComponent(NIL);
          END;
     END
     ELSE ActSelect := NIL;

     REPEAT
        i := AParent.IndexOfComponent(ActSelect) +1;
        IF i >= AParent.ComponentCount THEN i := 0;
        ActSelect := AParent.Components[i];
     UNTIL (ActSelect.ComponentState * [csDetail] = []) AND
           not (ActSelect IS TForm) AND (ActSelect IS TControl);

     SelectComponent(TControl(ActSelect));
     GetSelectionPos(FrameRec);
     InvalidateFormWindow;

     IF ActSelect IS TControl THEN TControl(ActSelect).BringToFront;
END;


PROCEDURE TFormEditor.SelectPreviousComponent;
VAR  Item:PSelectItem;
     ActSelect:TComponent;
     AParent:TComponent;
     i:LONGINT;
BEGIN
     IF ComponentCount = 0 THEN exit;
     AParent := SELF;
     IF SelectList.Count > 0 THEN
     BEGIN
          ClearSelection;
          Item := SelectList.First;
          IF Item <> NIL THEN
          BEGIN
               ActSelect := Item^.Component;
               AParent := ActSelect.Owner;
               SelectComponent(NIL);
          END;
     END
     ELSE ActSelect := NIL;

     REPEAT
        i := AParent.IndexOfComponent(ActSelect) -1;
        IF i < 0 THEN i := AParent.ComponentCount-1;
        ActSelect := AParent.Components[i];
     UNTIL (ActSelect.ComponentState * [csDetail] = []) AND
           not (ActSelect IS TForm) AND (ActSelect IS TControl);

     SelectComponent(TControl(ActSelect));
     GetSelectionPos(FrameRec);
     InvalidateFormWindow;

     IF ActSelect IS TControl THEN TControl(ActSelect).BringToFront;
END;


PROCEDURE TFormEditor.SelectNearestComponent(KeyCode:TKeyCode);
VAR  Comp,Component:TControl;
     AParent:TControl;
     Nearest:TControl;
     i:LONGINT;
BEGIN
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;
     AParent := TControl(Component.Owner);
     IF not (AParent IS TControl) THEN exit;

     Nearest := NIL;
     CASE KeyCode OF
       kbCUp:
       BEGIN
            FOR i := 0 TO AParent.ControlCount-1 DO
            BEGIN
                 Comp := AParent.Controls[i];
                 IF not (Comp IS TForm) THEN {keine ReferenzForms}
                   IF Comp.Bottom > Component.Bottom THEN
                     IF Nearest <> NIL THEN
                     BEGIN
                          IF Comp.Bottom < Nearest.Bottom THEN Nearest := Comp;
                     END
                     ELSE Nearest := Comp;
            END;
       END;
       kbCDown:
       BEGIN
            FOR i := 0 TO AParent.ControlCount-1 DO
            BEGIN
                 Comp := AParent.Controls[i];
                 IF not (Comp IS TForm) THEN {keine ReferenzForms}
                   IF Comp.Bottom < Component.Bottom THEN
                     IF Nearest <> NIL THEN
                     BEGIN
                          IF Comp.Bottom > Nearest.Bottom THEN Nearest := Comp;
                     END
                     ELSE Nearest := Comp;
            END;
       END;
       kbCLeft:
       BEGIN
            FOR i := 0 TO AParent.ControlCount-1 DO
            BEGIN
                 Comp := AParent.Controls[i];
                 IF not (Comp IS TForm) THEN {keine ReferenzForms}
                   IF Comp.Left < Component.Left THEN
                     IF Nearest <> NIL THEN
                     BEGIN
                          IF Comp.Left > Nearest.Left THEN Nearest := Comp;
                     END
                     ELSE Nearest := Comp;
            END;
       END;
       kbCRight:
       BEGIN
            FOR i := 0 TO AParent.ControlCount-1 DO
            BEGIN
                 Comp := AParent.Controls[i];
                 IF not (Comp IS TForm) THEN {keine ReferenzForms}
                   IF Comp.Left > Component.Left THEN
                     IF Nearest <> NIL THEN
                     BEGIN
                          IF Comp.Left < Nearest.Left THEN Nearest := Comp;
                     END
                     ELSE Nearest := Comp;
            END;
       END;
       ELSE exit;
     END;
     IF Nearest = NIL THEN exit;

     ClearSelection;
     SelectComponent(NIL);
     SelectComponent(Nearest);
     UpdateSelection;

     IF Nearest IS TControl THEN TControl(Nearest).BringToFront;
END;


PROCEDURE TFormEditor.MoveSelectedComponents(KeyCode:TKeyCode;RepeatCount:BYTE);
VAR  x,y,_x,_y:LONGINT;
     Component:TControl;
     Item:PSelectItem;
     i,rc:LONGINT;
     RedrawCtrl:TControl;
BEGIN
     IF SelectList.Count = 0 THEN exit;
     x := 0;
     y := 0;
     rc := RepeatCount;
     CASE KeyCode OF
       kbCtrlCUp:         y := rc;
       kbCtrlCDown:       y := -rc;
       kbCtrlCLeft:       x := -rc;
       kbCtrlCRight:      x := rc;
       kbCtrlShiftCUp:    y := IdeSettings.Designer.GridHeight * rc;
       kbCtrlShiftCDown:  y := -IdeSettings.Designer.GridHeight * rc;
       kbCtrlShiftCLeft:  x := -IdeSettings.Designer.GridWidth * rc;
       kbCtrlShiftCRight: x := IdeSettings.Designer.GridWidth * rc;
       ELSE exit;
     END;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
               BEGIN
                    IF Component.xAlign <> xaNone THEN _x := 0
                    ELSE _x := x;
                    IF Component.yAlign <> yaNone THEN _y := 0
                    ELSE _y := y;
                    IF (_x = 0) AND (_y = 0) THEN continue;

                    Component.SetWindowPos(Component.Left+_x,Component.Bottom+_y,
                                           Component.Width,Component.Height);
                    RedrawCtrl := Component;
               END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Update;
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.SizeSelectedComponents(KeyCode:TKeyCode;RepeatCount:BYTE);
VAR  w,h,_w,_h:LONGINT;
     Component:TControl;
     Item:PSelectItem;
     i,rc:LONGINT;
     RedrawCtrl:TControl;
BEGIN
     IF SelectList.Count = 0 THEN exit;
     w := 0;
     h := 0;
     rc := RepeatCount;
     CASE KeyCode OF
       kbShiftCUp:    inc(h,rc);
       kbShiftCDown:  dec(h,rc);
       kbShiftCLeft:  dec(w,rc);
       kbShiftCRight: inc(w,rc);
       ELSE exit;
     END;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
               BEGIN
                    IF Component.xStretch <> xsNone THEN _w := 0
                    ELSE _w := w;
                    IF Component.yStretch <> ysNone THEN _h := 0
                    ELSE _h := h;
                    IF (_w = 0) AND (_h = 0) THEN continue;

                    Component.SetWindowPos(Component.Left,Component.Bottom,
                                           Component.Width+_w,Component.Height+_h);
                    RedrawCtrl := Component;
               END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Update;
     Project.SCUModified := TRUE;
END;


TYPE
    {das Format besteht aus einer Folge von Headern, die durch einen 0,0 Eintrag
     abgeschlossen werden, danach kommen die einzelnen Datenbereiche.
     Der erste Eintrag besteht aus (0, Gesamtgr”แe)}
    PComponentHeader=^TComponentHeader;
    TComponentHeader=RECORD
         Offset:LONGWORD;
         Size:LONGINT;
         ClassType:STRING[64];
    END;

    PHeaderArray=^THeaderArray;
    THeaderArray=ARRAY[0..MaxInt] OF TComponentHeader;


PROCEDURE TFormEditor.CutSelectedComponents;
BEGIN
     CopySelectedComponents;
     DeleteSelectedComponents;
END;


PROCEDURE TFormEditor.CopySelectedComponents;
TYPE PULONG=^LONGWORD;
VAR  PCH:PComponentHeader;
     PHA:PHeaderArray;
     p:PULONG;
     Item:PSelectItem;
     Comp,Ref:TComponent;
     i:LONGINT;
     StreamList:TStringList;
     tms:TMemoryStream;
     headersize,datasize,size:LONGINT;
     Offs:LONGWORD;
BEGIN
     IF SelectList.Count = 0 THEN exit;

     IF Clipboard.IsFormatAvailable(cfComponents) THEN {free the old memory}
     BEGIN
          IF Clipboard.Open(Handle) THEN
          BEGIN
               PCH := PComponentHeader(Clipboard.GetData(cfComponents));
               IF PCH <> NIL THEN
                 IF PCH^.Size > 0 THEN
                 BEGIN
                      FreeSharedMem(PCH,PCH^.Size);
                      Clipboard.SetData(0,cfComponents);
                 END;
               Clipboard.Close;
          END
          ELSE
          BEGIN
               ErrorBox(LoadNLSStr(SiCannotOpenClipboard));
               exit;
          END;
     END;

     StreamList.Create;
     datasize := 0;
     {erzeuge die einzelnen Komponenten-Streams}
     FOR i := 0 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN Comp := Item^.Component
          ELSE continue;

          IF Comp IS TReferenceWindow THEN
          BEGIN {schreibe vorher das referenzierte Objekt raus}
               Ref := TReferenceWindow(Comp).Reference;

               tms.Create;
               Ref.WriteToStream(tms);
               StreamList.AddObject(Ref.ClassName, tms);

               inc(datasize, tms.Size);
          END;

          tms.Create;
          Comp.WriteToStream(tms);
          StreamList.AddObject(Comp.ClassName, tms);

          inc(datasize, tms.Size);
     END;
     headersize := (StreamList.Count + 1) * SizeOf(TComponentHeader);
     size := headersize + datasize;

     GetSharedMem(PHA, size);
     IF PHA <> NIL THEN
     BEGIN
          {erster Eintrag zur Speicherung der Gesamtgr”แe und KomponentenAnzahl}
          PHA^[0].Offset := StreamList.Count;
          PHA^[0].Size := size;
          PHA^[0].ClassType := '';

          Offs := headersize;

          FOR i := 0 TO StreamList.Count-1 DO
          BEGIN
               tms := TMemoryStream(StreamList.Objects[i]);

               PHA^[i+1].Offset := Offs;
               PHA^[i+1].Size := tms.Size;
               PHA^[i+1].ClassType := StreamList.Strings[i];

               p := PULONG(PHA);
               inc(p, Offs);
               tms.Position := 0;
               tms.Read(p^, tms.Size);

               inc(Offs, tms.Size);

               tms.Destroy;
               StreamList.Objects[i] := NIL;
          END;

          {Kopieren}
          IF Clipboard.Open(Handle) THEN
          BEGIN
               Clipboard.SetData(LONGWORD(PHA), cfComponents);
               Clipboard.Close;
          END
          ELSE ErrorBox(LoadNLSStr(SiCannotOpenClipboard));
     END
     ELSE ErrorBox(LoadNLSStr(SiCannotAllocateSharedMem));

     {release the stream list}
     StreamList.Destroy;
END;


PROCEDURE TFormEditor.PasteComponents;
VAR  PCH:PComponentHeader;
BEGIN
     IF not Clipboard.IsFormatAvailable(cfComponents) THEN exit;

     IF Clipboard.Open(Handle) THEN
     BEGIN
          PCH := PComponentHeader(Clipboard.GetData(cfComponents));
          IF (PCH <> NIL) AND (PCH^.Size > 0) THEN
          BEGIN
               Navigator_EnableArrow;
               PasteInitiated := TRUE;
          END;
          ClipBoard.Close;
     END;
END;


{rekursiv Code einfgen und InspektorCombo fllen}
PROCEDURE RecognizePastedComponents(Owner:TForm;Comp:TComponent);
VAR  Control:TControl;
     AControl:TControl;
     RefWin:TReferenceWindow;
     i:LONGINT;
     Entry:TMenuItem;
BEGIN
     {maskiere die Methoden aus}
     Comp.Methods := NIL;

     {Referenzen werden ber das ReferenceControl gehandled}
     IF (csReference IN Comp.ComponentState) AND not (Comp IS TMenuItem) THEN exit;

     IF Comp IS TReferenceWindow THEN
     BEGIN
          RefWin := TReferenceWindow(Comp);
          Comp := RefWin.Reference;

          GenNewComponent(Owner, Comp);
          AddInspectorItem(Comp);

          {Menus werden extra behandelt}
          IF Comp IS TMenu THEN  {generiere Code fr die Items}
          BEGIN
               RecognizePastedComponents(Owner,TMenu(Comp).Items);
          END;

          exit;
     END;

     {fr Details wird kein Code erzeugt}
     IF not (csDetail IN Comp.ComponentState) THEN
     BEGIN
          GenNewComponent(Owner,Comp);
          AddInspectorItem(Comp);
     END;
     {Details k”nnen aber noch relevante Kinder haben - Page}

     IF Comp IS TControl THEN
     BEGIN
          Control := TControl(Comp);
          FOR i := 0 TO Control.ControlCount-1 DO
          BEGIN
               AControl := Control.Controls[i];
               RecognizePastedComponents(Owner,AControl);
          END;
     END;


     {MenuItems werden extra behandelt}
     IF Comp IS TMenuItem THEN
     BEGIN
          Entry := TMenuItem(Comp);
          FOR i := 0 TO Entry.Count-1 DO
          BEGIN
               IF Entry.Items[i].IsEditMenuItem THEN continue;
               RecognizePastedComponents(Owner,Entry.Items[i]);
          END;
     END;
END;


PROCEDURE TFormEditor.InsertPasteComponents(NewParent:TControl;X,Y:LONGINT);
TYPE PULONG=^LONGWORD;
VAR  PCH:PComponentHeader;
     PHA:PHeaderArray;
     p:PULONG;
     Comp,LastComp:TComponent;
     CompClass:TComponentClass;
     RefWin:TReferenceWindow;
     Item:PSelectItem;
     i:LONGINT;
     tms:TMemoryStream;
     tmsSize:LONGINT;
     Offs:LONGWORD;
     s:STRING;
     Edit:TSibEditor;
     Control:TControl;
     deltaX,deltaY:LONGINT;
BEGIN
     IF not Clipboard.IsFormatAvailable(cfComponents) THEN exit;

     IF Clipboard.Open(Handle) THEN
     BEGIN
          PCH := PComponentHeader(Clipboard.GetData(cfComponents));
          IF (PCH <> NIL) AND (PCH^.Size > 0) THEN
          BEGIN
               LastComp := NIL;

               ClearSelection;
               SelectComponent(NIL);

               Edit := GetEditor(GetUnitName(SELF));
               IF Edit <> NIL THEN Edit.BeginUpdate;

               PHA := PHeaderArray(PCH);
               FOR i := 0 TO PCH^.Offset-1 DO {Anzahl der Komponenten}
               BEGIN
                    Offs := PHA^[i+1].Offset;
                    tmsSize := PHA^[i+1].Size;
                    s := PHA^[i+1].ClassType;

                    CompClass := SearchClassByName(s);
                    IF CompClass = NIL THEN continue;

                    {Test, ob das Element erzeugt werden darf}
                    IF not TestInsert(NewParent,CompClass) THEN
                    BEGIN
                         continue;
                    END;


                    {CREATE IT}
                    Comp := CompClass.Create(SELF);

                    IF Comp IS TReferenceWindow THEN
                    BEGIN {setze die Referenz vor LoadedFromSCU}
                         RefWin := TReferenceWindow(Comp);
                         RefWin.SetReference(LastComp); {hier notwendig}
                    END;

                    p := PULONG(PHA);
                    inc(p, Offs);

                    tms.Create;
                    tms.Write(p^, tmsSize);
                    tms.Position := 0;
                    Comp.ReadFromStream(tms);  {causes LoadedFromSCU}
                    tms.Destroy;


                    IF Comp IS TControl THEN
                    BEGIN
                         Control := TControl(Comp);
                         Control.Parent := NIL; {erst mal unsichtbar}

                         IF not (Comp IS TForm) THEN SelectComponent(Control);
                    END;

                    {Code Generieren}
                    RecognizePastedComponents(SELF,Comp);

                    LastComp := Comp; {fr die Zuweisung der Referenz}
                    Project.SCUModified := TRUE;
               END;

               NewInsertParent := NewParent;
               GetSelectionPos(FrameRec);
               {die Mausposition soll mit der Mitte des FrameRec bereinstimmen}
               deltaX := X - ((FrameRec.Left + FrameRec.Right) DIV 2);
               deltaY := Y - ((FrameRec.Bottom + FrameRec.Top) DIV 2);

               {weise jetzt den Controls das neue Parent zu}
               FOR i := 0 TO SelectList.Count-1 DO
               BEGIN
                    Item := SelectList.Items[i];
                    IF Item = NIL THEN continue;

                    Control := TControl(Item^.Component);
                    IF Control IS TControl THEN
                    BEGIN
                         Control.Left := Control.Left + deltaX;
                         Control.Bottom := Control.Bottom + deltaY;
                         Control.Parent := NewParent;
                    END;
               END;

               NewInsertParent := NIL;

               UpdateSelection;

               IF Edit <> NIL THEN Edit.EndUpdate;
          END;
          Clipboard.Close;
     END
     ELSE ErrorBox(LoadNLSStr(SiCannotOpenClipboard));
END;


PROCEDURE TFormEditor.DeleteSelectedComponents;
VAR  Item:PSelectItem;
     i:LONGINT;
     Component:TControl;
     MMenu:TMenuItem;
     RedrawCtrl:TControl;
     Edit:TSibEditor;
BEGIN
     IF SelectList.Count = 0 THEN exit;
     ClearSelection;
     RedrawCtrl := NIL;

     Edit := GetEditor(GetUnitName(SELF));
     IF Edit <> NIL THEN Edit.BeginUpdate;

     SetInspectorData(NIL);  //L”schen wegen asynchronen Paint
     // gab Probleme mit der TForm.Menu Property

     FOR i := 0 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
            IF Item^.Component <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN RedrawCtrl := Component.Parent;

               MMenu := TMenuItem(Component);
               IF MMenu IS TMenuItem THEN
                 IF MMenu.IsEditMenuItem THEN continue;

               Item^.Component := NIL;   {!}
               DeleteComponent(Component,TRUE);  {destroy}
          END;
     END;

     SetInspectorData(SELF); // erst hier wieder setzen

     {Redrawbereich einschrnken auf Siblings der gel”schten Controls}
     IF RedrawCtrl IS TControl THEN
       IF RedrawCtrl.Controls[0] IS TControl THEN
         RedrawCtrl := TControl(RedrawCtrl.Controls[0]);

     IF Edit <> NIL THEN Edit.EndUpdate;

     SelectComponent(NIL);
     UpdateFormSelect(RedrawCtrl);
END;


PROCEDURE TFormEditor.DeleteComponent(Component:TControl;destroyit:BOOLEAN);
VAR  CompParent:TControl;
     CompName:STRING;
BEGIN
     IF Component = NIL THEN exit;
(* TEST
     MMenu := TMenuItem(Component);
     IF not (MMenu IS TMenuItem) THEN
     BEGIN
          IF Component IS TReferenceWindow THEN
          BEGIN
               RefWin := TReferenceWindow(Component);
               GenRemoveComponent(Component.Owner, RefWin.Reference);
          END
          ELSE
          BEGIN
               GenRemoveComponent(Component.Owner, Component);
          END;
     END;
*)

     CompParent := Component.Parent;
     CompName := Component.Name;
     TRY
        IF destroyit THEN Component.Destroy;
     EXCEPT
        ErrorBox(FmtLoadNLSStr(SiErrorDestroyingComponent,[CompName]));
        RemoveComponent(Component);
        TRY
           IF CompParent <> NIL THEN CompParent.RemoveControl(Component);
        EXCEPT
        END;
        CaptureFocus;
     END;

     Project.SCUModified := TRUE;
END;


FUNCTION TFormEditor.GetFormCoordinates(Component:TControl):TRect;
BEGIN
     Result.Left := Component.Left;
     Result.Bottom := Component.Bottom;
     Result.Right := Component.Left + Component.Width;
     Result.Top := Component.Bottom + Component.Height;

     IF Component IS TToolbar THEN exit;
     IF not (Component IS TControl) THEN exit; {MenuItems ?}

     Component := Component.Parent;
     Parent2FormKoord(Component, Result);
END;


FUNCTION TFormEditor.Parent2ToolbarKoord(VAR AParent:TControl; VAR rec:TRect):BOOLEAN;
BEGIN
     Result := FALSE;
     WHILE not (AParent IS TToolbar) DO
     BEGIN
          IF AParent IS TControl THEN
          BEGIN
               inc(rec.Left, AParent.Left);
               inc(rec.Bottom, AParent.Bottom);
               inc(rec.Right, AParent.Left);
               inc(rec.Top, AParent.Bottom);
               AParent := AParent.Parent;
          END
          ELSE exit;
     END;
     Result := TRUE;
END;


FUNCTION TFormEditor.Parent2FormKoord(VAR AParent:TControl; VAR rec:TRect):BOOLEAN;
BEGIN
     Result := FALSE;
     WHILE not (AParent = SELF) DO
     BEGIN
          IF AParent IS TControl THEN
          BEGIN
               inc(rec.Left, AParent.Left);
               inc(rec.Bottom, AParent.Bottom);
               inc(rec.Right, AParent.Left);
               inc(rec.Top, AParent.Bottom);
               AParent := AParent.Parent;
          END
          ELSE exit;
     END;
     Result := TRUE;
END;


FUNCTION TFormEditor.Form2ParentKoord(VAR AParent:TControl; VAR rec:TRect):BOOLEAN;
BEGIN
     Result := FALSE;
     WHILE not (AParent = SELF) DO
     BEGIN
          IF AParent IS TControl THEN
          BEGIN
               dec(rec.Left, AParent.Left);
               dec(rec.Bottom, AParent.Bottom);
               dec(rec.Right, AParent.Left);
               dec(rec.Top, AParent.Bottom);
               AParent := AParent.Parent;
          END
          ELSE exit;
     END;
     Result := TRUE;
END;


FUNCTION TFormEditor.Toolbar2ParentKoord(VAR AParent:TControl; VAR rec:TRect):BOOLEAN;
BEGIN
  Result := FALSE;
  WHILE not (AParent IS TToolbar) DO
    BEGIN
      IF AParent IS TControl THEN
        BEGIN
          dec(rec.Left, AParent.Left);
          dec(rec.Bottom, AParent.Bottom);
          dec(rec.Right, AParent.Left);
          dec(rec.Top, AParent.Bottom);
          AParent := AParent.Parent;
        END
      ELSE exit;
    END;
  Result := TRUE;
END;



PROCEDURE TFormEditor.UpdateFormSelect(aControl:TControl);
VAR  Component:TControl;
     aParent:TControl;
     i:LONGINT;
BEGIN
     GetSelectionPos(FrameRec);
     InvalidateFormWindow;

     aParent := SELF;
     IF aControl IS TControl THEN
     BEGIN
          aParent := aControl.Parent;
          IF aParent = NIL THEN aParent := SELF;
     END;

     //
     FOR i := 0 TO aParent.ControlCount-1 DO
     BEGIN
          Component := aParent.Controls[i];
          Component.Invalidate;
     END;

     IF HorzScrollBar <> NIL THEN HorzScrollBar.Invalidate; {notwendig}
     IF VertScrollBar <> NIL THEN VertScrollBar.Invalidate; {notwendig}
     //
END;


PROCEDURE TFormEditor.Align1;
VAR  xLeft:LONGINT;
     Component:TControl;
     Item:PSelectItem;
     i:LONGINT;
     client:TRect;
     RedrawCtrl:TControl;
BEGIN
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;

     IF SelectList.Count = 1 THEN
     BEGIN
          IF Component.Parent IS TControl THEN
          BEGIN
               client := TControl(Component.Parent).ClientRect;
               xLeft := client.Left;
          END
          ELSE exit;
     END
     ELSE xLeft := Component.Left;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
                 IF Component.xAlign = xaNone THEN
                 BEGIN
                      Component.Left := xLeft;
                      RedrawCtrl := Component;
                 END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align2;
VAR  xMiddle:LONGINT;
     Component:TControl;
     Item:PSelectItem;
     i:LONGINT;
     client:TRect;
     RedrawCtrl:TControl;
BEGIN
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;

     IF SelectList.Count = 1 THEN
     BEGIN
          IF Component.Parent IS TControl THEN
          BEGIN
               client := TControl(Component.Parent).ClientRect;
               xMiddle := client.Left + (client.Right +1 - client.Left) DIV 2;
          END
          ELSE exit;
     END
     ELSE xMiddle := Component.Left + (Component.Width DIV 2);

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
                 IF Component.xAlign = xaNone THEN
                 BEGIN
                      Component.Left := xMiddle - (Component.Width DIV 2);
                      RedrawCtrl := Component;
                 END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align3;
VAR  xOffs:LONGINT;
     dx:LONGINT;
     Component:TControl;
     AParent:TControl;
     Item:PSelectItem;
     i:LONGINT;
     rec:TRect;
     RedrawCtrl:TControl;
BEGIN
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;

     AParent := TControl(Component.Parent);
     IF AParent IS TControl THEN
     BEGIN
          IF AParent = SELF THEN rec := AParent.ClientRect
          ELSE rec := GetFormCoordinates(AParent);
     END
     ELSE exit;

     xOffs := ((rec.Right-rec.Left)-(FrameRec.Right-FrameRec.Left)) DIV 2;
     dx := FrameRec.Left - rec.Left - xOffs;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
                 IF Component.xAlign = xaNone THEN
                 BEGIN
                      Component.Left := Component.Left - dx;
                      RedrawCtrl := Component;
                 END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align4;
VAR  xRight:LONGINT;
     Component:TControl;
     Item:PSelectItem;
     i:LONGINT;
     client:TRect;
     RedrawCtrl:TControl;
BEGIN
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;

     IF SelectList.Count = 1 THEN
     BEGIN
          IF Component.Parent IS TControl THEN
          BEGIN
               client := TControl(Component.Parent).ClientRect;
               xRight := client.Right +1;
          END
          ELSE exit;
     END
     ELSE xRight := Component.Left + Component.Width;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
                 IF Component.xAlign = xaNone THEN
                 BEGIN
                      Component.Left := xRight - Component.Width;
                      RedrawCtrl := Component;
                 END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align5;
VAR  yTop:LONGINT;
     Component:TControl;
     Item:PSelectItem;
     i:LONGINT;
     client:TRect;
     RedrawCtrl:TControl;
BEGIN
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;

     IF SelectList.Count = 1 THEN
     BEGIN
          IF Component.Parent IS TControl THEN
          BEGIN
               client := TControl(Component.Parent).ClientRect;
               yTop := client.Top +1;
          END
          ELSE exit;
     END
     ELSE yTop := Component.Bottom + Component.Height;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
                 IF Component.yAlign = yaNone THEN
                 BEGIN
                      Component.Bottom := yTop - Component.Height;
                      RedrawCtrl := Component;
                 END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align6;
VAR  yMiddle:LONGINT;
     Component:TControl;
     Item:PSelectItem;
     i:LONGINT;
     client:TRect;
     RedrawCtrl:TControl;
BEGIN
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;

     IF SelectList.Count = 1 THEN
     BEGIN
          IF Component.Parent IS TControl THEN
          BEGIN
               client := TControl(Component.Parent).ClientRect;
               yMiddle := client.Bottom + (client.Top +1 - client.Bottom) DIV 2;
          END
          ELSE exit;
     END
     ELSE yMiddle := Component.Bottom + (Component.Height DIV 2);

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
                 IF Component.yAlign = yaNone THEN
                 BEGIN
                      Component.Bottom := yMiddle - (Component.Height DIV 2);
                      RedrawCtrl := Component;
                 END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align7;
VAR  yOffs:LONGINT;
     dy:LONGINT;
     Component:TControl;
     AParent:TControl;
     Item:PSelectItem;
     i:LONGINT;
     rec:TRect;
     RedrawCtrl:TControl;
BEGIN
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;

     AParent := TControl(Component.Parent);
     IF AParent IS TControl THEN
     BEGIN
          IF AParent = SELF THEN rec := AParent.ClientRect
          ELSE rec := GetFormCoordinates(AParent);
     END
     ELSE exit;

     yOffs := ((rec.Top-rec.Bottom) - (FrameRec.Top-FrameRec.Bottom)) DIV 2;
     dy := FrameRec.Bottom - rec.Bottom - yOffs;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
                 IF Component.yAlign = yaNone THEN
                 BEGIN
                      Component.Bottom := Component.Bottom - dy;
                      RedrawCtrl := Component;
                 END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align8;
VAR  yBottom:LONGINT;
     Component:TControl;
     Item:PSelectItem;
     i:LONGINT;
     client:TRect;
     RedrawCtrl:TControl;
BEGIN
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;

     IF SelectList.Count = 1 THEN
     BEGIN
          IF Component.Parent IS TControl THEN
          BEGIN
               client := TControl(Component.Parent).ClientRect;
               yBottom := client.Bottom;
          END
          ELSE exit;
     END
     ELSE yBottom := Component.Bottom;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
                 IF Component.yAlign = yaNone THEN
                 BEGIN
                      Component.Bottom := yBottom;
                      RedrawCtrl := Component;
                 END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align9;
VAR  xWidth:LONGINT;
     Component:TControl;
     Item:PSelectItem;
     i:LONGINT;
     RedrawCtrl:TControl;
BEGIN
     IF SelectList.Count < 2 THEN exit;
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;

     xWidth := Component.Width;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 1 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
                 IF Component.xStretch = xsNone THEN
                 BEGIN
                      Component.Width := xWidth;
                      RedrawCtrl := Component;
                 END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align10;
VAR  yHeight:LONGINT;
     Component:TControl;
     Item:PSelectItem;
     i:LONGINT;
     RedrawCtrl:TControl;
BEGIN
     IF SelectList.Count < 2 THEN exit;
     Component := TControl(GetFirstSelected);
     IF not (Component IS TControl) THEN exit;

     yHeight := Component.Height;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := SelectList.Count-1 DOWNTO 1 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN
                 IF Component.yStretch = ysNone THEN
                 BEGIN
                      Component.Height := yHeight;
                      RedrawCtrl := Component;
                 END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align11;
VAR  xPos,xWidth:LONGINT;
     xPosReal,xReal:EXTENDED;
     Component:TControl;
     Item:PSelectItem;
     i,j:LONGINT;
     AParent:TControl;
     rec:TRect;
     RedrawCtrl:TControl;
BEGIN
     IF SelectList.Count < 3 THEN exit;

     xWidth := FrameRec.Right - FrameRec.Left;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN dec(xWidth,Component.Width)
               ELSE exit;
          END
          ELSE exit;
     END;
     xReal := xWidth / (SelectList.Count-1);

     RedrawCtrl := NIL;
     ClearSelection;
     {Sort List}
     FOR i := 0 TO SelectList.Count-1 DO
       FOR j := 1 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[j-1];
          IF Item^.Component IS TControl THEN
          BEGIN
               xPos := Item^.Component.Left;
               Item := SelectList.Items[j];
               IF Item^.Component IS TControl THEN
                 IF xPos > Item^.Component.Left THEN SelectList.Exchange(j-1,j);
          END;
     END;

     AParent := TControl(Item^.Component.Parent);
     IF AParent = SELF THEN rec := AParent.ClientRect
     ELSE rec := GetFormCoordinates(AParent);
     xPosReal := FrameRec.Left - rec.Left;

     FOR i := 0 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[i];
          Component := Item^.Component;
          IF Component IS TControl THEN
          BEGIN
               IF i <> SelectList.Count-1 THEN
               BEGIN
                    IF Component.xAlign = xaNone THEN
                    BEGIN
                         Component.Left := round(xPosReal);
                         RedrawCtrl := Component;
                    END;
                    xPosReal := xPosReal + Component.Width + xReal;
               END
               ELSE
               BEGIN
                    IF Component.xAlign = xaNone THEN
                    BEGIN
                         Component.Left := FrameRec.Right - rec.Left -
                                           Component.Width + 1;
                         RedrawCtrl := Component;
                    END;
               END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align12;
VAR  yPos,yHeight:LONGINT;
     yPosReal,yReal:EXTENDED;
     Component:TControl;
     Item:PSelectItem;
     i,j:LONGINT;
     AParent:TControl;
     rec:TRect;
     RedrawCtrl:TControl;
BEGIN
     IF SelectList.Count < 3 THEN exit;

     yHeight := FrameRec.Top - FrameRec.Bottom;
     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN dec(yHeight,Component.Height)
               ELSE exit;
          END
          ELSE exit;
     END;
     yReal := yHeight / (SelectList.Count-1);

     RedrawCtrl := NIL;
     ClearSelection;
     {Sort List}
     FOR i := 0 TO SelectList.Count-1 DO
       FOR j := 1 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[j-1];
          IF Item^.Component IS TControl THEN
          BEGIN
               yPos := Item^.Component.Bottom;
               Item := SelectList.Items[j];
               IF Item^.Component IS TControl THEN
                 IF yPos > Item^.Component.Bottom THEN SelectList.Exchange(j-1,j);
          END;
     END;

     AParent := TControl(Item^.Component.Parent);
     IF AParent = SELF THEN rec := AParent.ClientRect
     ELSE rec := GetFormCoordinates(AParent);
     yPosReal := FrameRec.Bottom - rec.Bottom;

     FOR i := 0 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[i];
          Component := Item^.Component;
          IF Component IS TControl THEN
          BEGIN
               IF i <> SelectList.Count-1 THEN
               BEGIN
                    IF Component.yAlign = yaNone THEN
                    BEGIN
                         Component.Bottom := round(yPosReal);
                         RedrawCtrl := Component;
                    END;
                    yPosReal := yPosReal + Component.Height + yReal;
               END
               ELSE
               BEGIN
                    IF Component.yAlign = yaNone THEN
                    BEGIN
                         Component.Bottom := FrameRec.Top - rec.Bottom -
                                           Component.Height + 1;
                         RedrawCtrl := Component;
                    END;
               END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align13;    {equal space horizontal within parent}
VAR  xPos,xWidth:LONGINT;
     xPosReal,xReal:EXTENDED;
     Component:TControl;
     Item:PSelectItem;
     i,j:LONGINT;
     RedrawCtrl:TControl;
BEGIN
     IF SelectList.Count < 1 THEN exit;

     Item := SelectList.First;
     IF Item = NIL THEN exit;
     Component := Item^.Component;
     IF not (Component IS TControl) THEN exit;

     xWidth := Component.Parent.ClientWidth;

     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN dec(xWidth,Component.Width)
               ELSE exit;
          END
          ELSE exit;
     END;
     xReal := xWidth / (SelectList.Count+1);

     RedrawCtrl := NIL;
     ClearSelection;
     {Sort List}
     FOR i := 0 TO SelectList.Count-1 DO
       FOR j := 1 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[j-1];
          IF Item^.Component IS TControl THEN
          BEGIN
               xPos := Item^.Component.Left;
               Item := SelectList.Items[j];
               IF Item^.Component IS TControl THEN
                 IF xPos > Item^.Component.Left THEN SelectList.Exchange(j-1,j);
          END;
     END;

     xPosReal := xReal;

     FOR i := 0 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[i];
          Component := Item^.Component;
          IF Component IS TControl THEN
          BEGIN
               IF i <> SelectList.Count-1 THEN
               BEGIN
                    IF Component.xAlign = xaNone THEN
                    BEGIN
                         Component.Left := round(xPosReal);
                         RedrawCtrl := Component;
                    END;
                    xPosReal := xPosReal + Component.Width + xReal;
               END
               ELSE
               BEGIN
                    IF Component.xAlign = xaNone THEN
                    BEGIN
                         Component.Left := Component.Parent.ClientWidth -
                                   round(xReal) - Component.Width + 1;
                         RedrawCtrl := Component;
                    END;
               END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.Align14;   {equal space vertical within parent}
VAR  yPos,yHeight:LONGINT;
     yPosReal,yReal:EXTENDED;
     Component:TControl;
     Item:PSelectItem;
     i,j:LONGINT;
     RedrawCtrl:TControl;
BEGIN
     IF SelectList.Count < 1 THEN exit;

     Item := SelectList.First;
     IF Item = NIL THEN exit;
     Component := Item^.Component;
     IF not (Component IS TControl) THEN exit;

     yHeight := Component.Parent.ClientHeight;

     FOR i := SelectList.Count-1 DOWNTO 0 DO
     BEGIN
          Item := SelectList.Items[i];
          IF Item <> NIL THEN
          BEGIN
               Component := Item^.Component;
               IF Component IS TControl THEN dec(yHeight,Component.Height)
               ELSE exit;
          END
          ELSE exit;
     END;
     yReal := yHeight / (SelectList.Count+1);

     RedrawCtrl := NIL;
     ClearSelection;
     {Sort List}
     FOR i := 0 TO SelectList.Count-1 DO
       FOR j := 1 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[j-1];
          IF Item^.Component IS TControl THEN
          BEGIN
               yPos := Item^.Component.Bottom;
               Item := SelectList.Items[j];
               IF Item^.Component IS TControl THEN
                 IF yPos > Item^.Component.Bottom THEN SelectList.Exchange(j-1,j);
          END;
     END;

     yPosReal := yReal;

     FOR i := 0 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[i];
          Component := Item^.Component;
          IF Component IS TControl THEN
          BEGIN
               IF i <> SelectList.Count-1 THEN
               BEGIN
                    IF Component.yAlign = yaNone THEN
                    BEGIN
                         Component.Bottom := round(yPosReal);
                         RedrawCtrl := Component;
                    END;
                    yPosReal := yPosReal + Component.Height + yReal;
               END
               ELSE
               BEGIN
                    IF Component.yAlign = yaNone THEN
                    BEGIN
                         Component.Bottom := Component.Parent.ClientHeight -
                                   round(yReal) - Component.Height + 1;
                         RedrawCtrl := Component;
                    END;
               END;
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.ForceAlign;
VAR  Component:TControl;
     Item:PSelectItem;
     cLeft,cBottom:LONGINT;
     i:LONGINT;
     RedrawCtrl:TControl;
BEGIN
     IF SelectList.Count = 0 THEN exit;

     RedrawCtrl := NIL;
     ClearSelection;
     FOR i := 0 TO SelectList.Count-1 DO
     BEGIN
          Item := SelectList.Items[i];
          Component := Item^.Component;
          IF Component IS TControl THEN
          BEGIN
               cLeft := Component.Left;
               cBottom := Component.Bottom;
               IF Component.xAlign = xaNone THEN AlignToGridWidth(cLeft);
               IF Component.yAlign = yaNone THEN AlignToGridHeight(cBottom);
               Component.SetWindowPos(cLeft,cBottom,Component.Width,Component.Height);
          END;
     END;

     UpdateFormSelect(RedrawCtrl);
     Project.SCUModified := TRUE;
END;


PROCEDURE TFormEditor.RefreshAll;
VAR  i:LONGINT;
     Component:TControl;
     FormWindow:TFormEditor;
BEGIN
     FormWindow := GetActiveFormWindow;
     IF FormWindow <> NIL THEN
     BEGIN
          FormWindow.GetSelectionPos(FormWindow.FrameRec);
          FormWindow.Invalidate;
          FOR i := 0 TO FormWindow.ControlCount-1 DO
          BEGIN
               Component := FormWindow.Controls[i];
               Component.Invalidate;
          END;
     END;
END;


PROCEDURE TFormEditor.DelCtrl;
BEGIN
     DeleteSelectedComponents;
END;


PROCEDURE UpdateAllFormWindows;
VAR  FormItem:PFormListItem;
     FormWindow:TFormEditor;
     i:INTEGER;
BEGIN
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          FormWindow := TFormEditor(FormItem^.Form);
          IF FormWindow <> NIL THEN FormWindow.Invalidate;
     END;
END;


PROCEDURE TFormEditor.GridVis;
BEGIN
     IdeSettings.Designer.GridVisible := not IdeSettings.Designer.GridVisible;
     IF GridVisibleBtn <> NIL
     THEN GridVisibleBtn.Down := IdeSettings.Designer.GridVisible;
     Project.Modified := TRUE;
     UpdateAllFormWindows;
END;


PROCEDURE TFormEditor.SnapToGrid;
BEGIN
     IdeSettings.Designer.GridActive := not IdeSettings.Designer.GridActive;
     IF SnapToGridBtn <> NIL
     THEN SnapToGridBtn.Down := IdeSettings.Designer.GridActive;
     Project.Modified := TRUE;
END;


PROCEDURE TFormEditor.DesignPos;
BEGIN
     IF LastDesignForm = NIL THEN
     BEGIN {funktioniert nicht, da keine Fom mehr aktiv ist}
          IF LastDesignFormName = '' THEN exit;
          LastDesignForm := OpenFormWindow(LastDesignFormName);
     END;
     IF LastDesignForm <> NIL THEN LastDesignForm.CaptureFocus;
END;

/////////////////////////////////////////////////////////////////////////////

PROCEDURE AutomaticInsert(CompClass:TComponentClass);
VAR  pt:TPoint;
     rec:TRect;
     _LastDesignForm:TFormEditor;
     SingleSelect:TControl;
BEGIN
     IF LastDesignForm = NIL THEN exit;

     NewInsertClass := CompClass;
     _LastDesignForm := TFormEditor(LastDesignForm);
(* wird Mist bei 2 Toolbars, die hintereinander eingefgt werden
     SingleSelect := TControl(_LastDesignForm.GetFirstSelected);
     WHILE SingleSelect <> NIL DO
     BEGIN
          IF SingleSelect IS TControl THEN
            IF SingleSelect.ComponentState * [csAcceptsControls] <> [] THEN break; {ended spt. bei Form}
          SingleSelect := TControl(SingleSelect.Parent);
     END;
     IF SingleSelect IS TForm THEN SingleSelect := NIL;
*)
     SingleSelect := NIL; // immer in die Form einfgen

     IF SingleSelect = NIL THEN
     BEGIN
          pt.X := _LastDesignForm.ClientWidth DIV 2;
          pt.Y := _LastDesignForm.ClientHeight DIV 2;
     END
     ELSE
     BEGIN
          rec := _LastDesignForm.GetFormCoordinates(SingleSelect);
          pt.X := rec.Left + (rec.Right - rec.Left) DIV 2;
          pt.Y := rec.Bottom + (rec.Top - rec.Bottom) DIV 2;
     END;

     _LastDesignForm.SingleSelect := SingleSelect;
     _LastDesignForm.MouseDown(mbLeft,[],pt.X,pt.Y);
     _LastDesignForm.MouseUp(mbLeft,[ssShift],pt.X,pt.Y);
     {[ssShift] dont enables the arrow}
     NewInsertClass := NIL;
END;


PROCEDURE NotifySizeMove(x,y,w,h:LONGINT;Component:TComponent);
VAR  _LastDesignForm:TFormEditor;
BEGIN
     IF LastDesignForm = NIL THEN exit;

     IF Component IS TControl THEN
       IF not (Component IS TFormEditor) THEN
     BEGIN
          _LastDesignForm := TFormEditor(LastDesignForm);
          _LastDesignForm.Canvas.Pen.Color := _LastDesignForm.Color;
          _LastDesignForm.DrawHandles(x,y,w,h,TForm(Component),TRUE);
          _LastDesignForm.GetSelectionPos(_LastDesignForm.FrameRec);
          _LastDesignForm.InvalidateFormWindow;
          TControl(Component).Invalidate;
     END;
END;


PROCEDURE SelectControl(Component:TComponent);
VAR  _LastDesignForm:TFormEditor;
     RefOwner:TControl;
     Ref:TReferenceWindow;
     Control:TControl;
     i:LONGINT;
BEGIN
     IF LastDesignForm = NIL THEN exit;

     IF Component.ComponentState * [csReference] <> [] THEN
     BEGIN {find the TReference as Child of the Component.Owner}
          RefOwner := TControl(Component.Owner); {the Owner of the TReference}
          IF RefOwner <> NIL THEN
          FOR i := 0 TO RefOwner.ComponentCount-1 DO
          BEGIN
               Ref := TReferenceWindow(RefOwner.Components[i]);
               IF Ref IS TReferenceWindow THEN
                 IF Ref.Reference = Component THEN
                 BEGIN
                      Component := Ref;
                      break;
                 END;
          END;
     END;

     IF Component IS TControl THEN
     BEGIN
          Control := TControl(Component);
          _LastDesignForm := TFormEditor(LastDesignForm);
          _LastDesignForm.ClearSelection;
          _LastDesignForm.SelectComponent(NIL);
          IF not (Control IS TFormEditor)
          THEN _LastDesignForm.SelectComponent(Control);
          {alle Parents to top - wegen Controls in NotebookPages}
          REPEAT
                Control.BringToFront;
                Control := Control.Parent
          UNTIL (Control IS TFormEditor) OR (Control = NIL);
          _LastDesignForm.UpdateSelection;
          exit;
     END;
(* CUT
     IF Component IS TMainMenu THEN
     BEGIN
          _LastDesignForm := TFormEditor(LastDesignForm);
          _LastDesignForm.ClearSelection;
          _LastDesignForm.SelectComponent(NIL);
          _LastDesignForm.SelectComponent(TControl(Component));
     END;
*)
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TReferenceWindow Class implementation                       บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TReferenceWindow.SetupComponent;
BEGIN
  Inherited SetupComponent;

  Name := 'Reference';
  Caption := '';
  Width := 28;
  Height := 28;
  xStretch := xsFixed;
  yStretch := ysFixed;
  ZOrder := zoTop;
  TabOrder := -1;
  TabStop := FALSE;
  Include(ComponentState, csReferenceControl);
END;


PROCEDURE TReferenceWindow.SetupShow;
VAR  aBitmap:TBitmap;
BEGIN
     Inherited SetupShow;

     {Bitmap ermitteln aus Referenz}
     IF Reference = NIL THEN aBitmap := NIL
     ELSE aBitmap := GetBitmapFromClass(SELF,Reference.ClassType);

     IF aBitmap = NIL THEN {no Bitmap found -> use default}
     BEGIN
          {Provide some default bitmap}
          aBitmap.Create;
          aBitmap.LoadFromResourceId(1111);
     END;
     Include(aBitmap.ComponentState, csDetail);
     Glyph := aBitmap; {internal Copy is created}
     aBitmap.Destroy;
     Width := Glyph.Width + 4;
     Height := Glyph.Height + 4;
END;


FUNCTION TReferenceWindow.GetReference:TComponent;
BEGIN
     ASM
        PUSH DWORD PTR SELF
        CALLN32 CLASSES.GetReference
        MOV Result,EAX
     END;
END;


PROCEDURE TReferenceWindow.SetReference(NewRef:TComponent);
BEGIN
     ASM
        PUSH DWORD PTR SELF
        PUSH DWORD PTR NewRef
        CALLN32 CLASSES.SetReference
     END;
     {Flag setzen}
     IF NewRef <> NIL THEN Include(NewRef.ComponentState, csReference);
END;


PROCEDURE TReferenceWindow.GetChildren(Proc:TGetChildProc);
BEGIN
END;


DESTRUCTOR TReferenceWindow.Destroy;
BEGIN
     IF Reference <> NIL THEN
     BEGIN
          Reference.Destroy;
          Reference := NIL;
     END;
     Inherited Destroy;
END;


FUNCTION TReferenceWindow.WriteSCUResource(Stream:TResourceStream):BOOLEAN;
BEGIN
     Result := TComponent.WriteSCUResource(Stream);
END;



//////////////////////////////////////////////////////////////////////////

FUNCTION GetReference(Sender:TComponent):TComponent;
BEGIN
     IF not (Sender IS TReferenceWindow) THEN Result := Sender
     ELSE Result := TReferenceWindow(Sender).Reference;
END;


FUNCTION CreateReference(AOwner,AComponent:TComponent):TReferenceWindow;
BEGIN
     result.Create(AOwner);
     result.Reference:=AComponent;
END;

Procedure LoadPointer(iResId:LONGINT; var iPointer : tPointer);

Begin
  iPointer.Create;
  iPointer.LoadFromResourceId(iResID);
  Screen.Cursors[iResID]:=iPointer.Handle;
End;


BEGIN
  GetReferenceProc := GetReference;
  NewInsertClass := NIL;
  LastDesignForm := NIL;
  LastDesignFormName := '';
  FormEditClass := TFormEditor;
  RegisterClasses([TFormEditor]);

  AutomaticComponentInsert := @AutomaticInsert;
  NewFormWinProc := @NewFormWindow;
  NotifySM := @NotifySizeMove;
  SelectCtrl := @SelectControl;

  CreateReferenceProc := @CreateReference;

  cfComponents := Clipboard.RegisterFormat('SibylComponents');

  LoadPointer(crInsert, CurInsert);
  LoadPointer(crPaste, CurPaste);
  LoadPointer(crMultiSelect, CurMultiselect);

END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  19-Jul-06  WD         Korrektur des laden von den Cursors
  08-Dec-07  MV         TFormEditor.SetCursorIntern: Cursor korrigiert.
}


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

UNIT Browser;

INTERFACE


USES Dos,SysUtils,Color,Classes,Forms,Graphics,StdCtrls,Buttons,Outline,Dialogs,
     Editors,ComCtrls,
     Consts,Projects,Sib_Ctrl,Sib_Prj,BaseForm,Sib_Edit,Compiler,
     Menus, Messages,
     uSysClass, uSysInfo,
     uString, uList;

CONST InvalidIndex=MaxLongInt;


TYPE
    ETreeListError=CLASS(Exception);
    ETreeIndexError=CLASS(ETreeListError);
    ETreeNodeError=CLASS(ETreeListError);

    TAttachMode=(oaAdd, oaAddChild, oaInsert);

    TTreeNode=CLASS;
    TTreeList=CLASS;

    TTreeNode=CLASS
      PRIVATE
         FData:POINTER;
         FTreeList:TTreeList;
         FParent:TTreeNode;
         FSubNodes:TList;
         FUNCTION GetNode(idx:LONGINT):TTreeNode;
         FUNCTION GetNodeCount:LONGINT;
         FUNCTION InsertNode(OldNode,NewNode:TTreeNode):LONGINT;
         FUNCTION AddNode(NewNode:TTreeNode):LONGINT;
         FUNCTION HasChildren:BOOLEAN;
         FUNCTION GetLevel:LONGINT;
         FUNCTION GetList:TList;
         FUNCTION GetRootNode:TTreeNode;
         PROCEDURE Clear;
      PROTECTED
         PROPERTY RootNode:TTreeNode read GetRootNode;
      PUBLIC
         CONSTRUCTOR Create(Owner:TTreeList);
         DESTRUCTOR Destroy;OVERRIDE;
         PROPERTY Data:POINTER read FData write FData;
         PROPERTY Parent:TTreeNode read FParent;
         PROPERTY SubNodes:TList read FSubNodes;
         PROPERTY Items[idx:LONGINT]:TTreeNode read GetNode;
         PROPERTY ItemCount:LONGINT read GetNodeCount;
         PROPERTY HasItems:BOOLEAN read HasChildren;
         PROPERTY Level:LONGINT read GetLevel;
         PROPERTY List:TList read GetList;
    END;

    TNodeClass=CLASS OF TTreeNode;


    TTreeList=CLASS(TComponent)
      PRIVATE
         FRootNode:TTreeNode;
         FGoodNode:TTreeNode;
         FUpdateCount:LONGINT;
         FNodeClass:TNodeClass;
         FUNCTION AttachNode(Node:TTreeNode;Data:POINTER;Mode:TAttachMode):TTreeNode;
      PROTECTED
         PROCEDURE IndexError;VIRTUAL;
         PROCEDURE NodeError;VIRTUAL;
         FUNCTION GetRootNode:TTreeNode;
         PROCEDURE InitRoot;VIRTUAL;
      PUBLIC
         CONSTRUCTOR Create(AOwner:TComponent);OVERRIDE;
         DESTRUCTOR Destroy;OVERRIDE;
         FUNCTION AddObjectNode(Node:TTreeNode;Data:POINTER):TTreeNode;
         FUNCTION AddChildObjectNode(Node:TTreeNode;Data:POINTER):TTreeNode;
         FUNCTION InsertObjectNode(Node:TTreeNode;Data:POINTER):TTreeNode;
         PROCEDURE DeleteNode(Node:TTreeNode);
         PROCEDURE Clear;
         PROCEDURE BeginUpdate;
         PROCEDURE EndUpdate;
         PROPERTY Root:TTreeNode read GetRootNode;
         PROPERTY NodeClass:TNodeClass read FNodeClass write FNodeClass;
    END;

{ --------------------------------------------------------------------------------- }

type TBrowseList=CLASS(TList);

    PBrowseInfo=^TBrowseInfo;
    TBrowseInfo=RECORD
         BrowseType:BYTE;
         TargetUnit:PSTRING;
         Name:PSTRING;
         Typ:PSTRING;
         ParentName:PSTRING;
         ParentUnit:PSTRING;
         OwnerInfo:PBrowseInfo;
         Scope:BYTE;
         Flags:WORD;
         Line:WORD;
         NestedInfo:TBrowseList;   //of PBrowseInfo
    END;

    TBrowseObjectsNode=CLASS(TTreeNode)
         FParentName:PString;
         FUNCTION GetParentName:STRING;
         PROCEDURE SetParentName(Name:STRING);
         DESTRUCTOR Destroy;OVERRIDE;
         PROPERTY ParentName:STRING read GetParentName write SetParentName;
    END;

    TBrowseObjectsList=CLASS(TTreeList)
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE InsertParentAscending(aInfo:PBrowseInfo);
         PROCEDURE InsertNameAscending(ParentNode:TBrowseObjectsNode;aInfo:PBrowseInfo);
         PROCEDURE InsertTreeObject(ParentNode:TOutlineNode;aInfo:PBrowseInfo;rekursiv:BOOLEAN);
    END;

    PBrowseUnits=^TBrowseUnits;
    TBrowseUnits=RECORD
         Name:STRING[64];
         NameTable:POINTER;
         NameTableSize:LONGINT;
         Types:TBrowseList;        //of PBrowseInfo
         Variables:TBrowseList;    //of PBrowseInfo
         Objects:TBrowseList;      //of PBrowseInfo
         Constants:TBrowseList;    //of PBrowseInfo
         Procedures:TBrowseList;   //of PBrowseInfo
    END;

    TBrowseUnitsList=CLASS(TTreeList)
         PROCEDURE InsertUnitAscending(aUnit:PBrowseUnits);
         PROCEDURE InsertIdentifier(UnitNode:TTreeNode;aInfo:PBrowseInfo);
         PROCEDURE InsertTreeUnit(Node:TTreeNode);
    END;

    TBrowseGlobalsList=CLASS(TList)
         PROCEDURE InsertUnitAscending(aUnit:PBrowseUnits);
         PROCEDURE InsertIdentifier(aInfo:PBrowseInfo);
    END;


TYPE
    TBrowseToolBar=CLASS(TToolBar)
         PROCEDURE MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE EvResize(Sender:TObject);
    END;

    TLeftBitmapListBox=CLASS(TListBox)
         PROCEDURE DrawItem(Index:LONGINT;Rec:TRect;State:TOwnerDrawState);OVERRIDE;
         PROCEDURE MeasureItem(Index:LONGINT;VAR CX,CY:LONGINT);OVERRIDE;
         PROCEDURE MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
    END;

    TRightBitmapListBox=CLASS(TListBox)
         PROCEDURE DrawItem(Index:LONGINT;Rec:TRect;State:TOwnerDrawState);OVERRIDE;
         PROCEDURE MeasureItem(Index:LONGINT;VAR CX,CY:LONGINT);OVERRIDE;
         PROCEDURE MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
    END;

    TBrowserSwitchButton=CLASS(TXPLButton)
         PROCEDURE Click;OVERRIDE;
    END;

    TBrowserEnum=(_Constants,_Types,_Variables,_Procedures,
                  _Published,_Public,_Protected,_Private,
                  _Inherited,_Virtual,_Properties);
    TBrowserShowTypes=SET OF TBrowserEnum;

    TBrowserOutline=CLASS(TUnindexedOutLine)
         PROCEDURE ItemFocus(SelectedItem:LONGINT);OVERRIDE;
         PROCEDURE CheckMenuPopup(pt:TPoint);OVERRIDE;
    END;


    TBrowserInfo=CLASS
         Units:TList;                          {of PBrowseUnits}
         SortedObjects:TBrowseObjectsList;     {of PBrowseInfo}
         SortedUnits:TBrowseUnitsList;         {of PBrowseInfo}
         SortedGlobals:TBrowseGlobalsList;     {of PBrowseInfo}
         DataAvailable:BOOLEAN;
         CONSTRUCTOR Create;
         DESTRUCTOR Destroy;Override;
         PROCEDURE AddBrowseUnit(CONST NameExt:STRING);
         PROCEDURE ReadInformation(CONST UnitName:STRING);
         PROCEDURE ReadFromFile(VAR F:FILE;CONST UnitName:STRING);
         PROCEDURE FreeData;
         PROCEDURE UpdateSortedGlobalsList;
         PROCEDURE UpdateSortedUnitsList;
         PROCEDURE UpdateSortedObjectsList;
         PROCEDURE DestroySortedGlobalsList;
         PROCEDURE DestroySortedUnitsList;
         PROCEDURE DestroySortedObjectsList;
    END;


    TBrowser=CLASS(TSibylForm)
         Mode:TBrowseMode;
         ToolBar:TToolBar;
         RightTool:TBrowseToolBar;
         UnitsTreeView:TBrowserOutline;
         ObjectsTreeView:TBrowserOutline;
         GlobalsListBox:TLeftBitmapListBox;
         RightListBox:TRightBitmapListBox;
         Progress:TProgressBar;
         ObjectsShowTypes:TBrowserShowTypes;
         UnitsShowTypes:TBrowserShowTypes;
         GlobalsShowTypes:TBrowserShowTypes;
         LastLeftSelItem:LONGINT;
         LastLeftSelRoot:PBrowseInfo;
         LastTreeItemSel:PBrowseInfo;
         LastListSel:PBrowseInfo;
         ShowTypes:TBrowserShowTypes;
         Types:TBitmap;
         Variables:TBitmap;
         Constants:TBitmap;
         Procedures:TBitmap;
         Properties:TBitmap;

         PopUp:TPopupMenu;
         ObjectsEntry:TMenuItem;
         UnitsEntry:TMenuItem;
         GlobalsEntry:TMenuItem;
         SymbolEntry:TMenuItem;
         QualifiedEntry:TMenuItem;
         SourceEntry:TMenuItem;
         UpdateEntry:TMenuItem;
         CommandSender:TControl;

         Inherit:ARRAY[FALSE..TRUE] OF TBitmap;
         Virt:ARRAY[FALSE..TRUE] OF TBitmap;
         Publish:ARRAY[FALSE..TRUE] OF TBitmap;
         Pub:ARRAY[FALSE..TRUE] OF TBitmap;
         Priv:ARRAY[FALSE..TRUE] OF TBitmap;
         Prot:ARRAY[FALSE..TRUE] OF TBitmap;

         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE Show;OVERRIDE;

         PROCEDURE FreeAllData;
         PROCEDURE UpdateContents;
         PROCEDURE LeftListBoxFocus(Sender:TObject;Index:LONGINT);
         PROCEDURE RightListBoxFocus(Sender:TObject;Index:LONGINT);
         PROCEDURE AddItem(aListBox:TListBox;Info:PBrowseInfo);
         PROCEDURE UpdateNestedInfo(Info:PBrowseInfo);
         PROCEDURE ShowContextMenu(AOwner:TControl;X,Y:LONGINT);
         PROCEDURE TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);OVERRIDE;
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
         PROCEDURE ChildScanEvent(Sender:TObject;VAR KeyCode:TKeyCode);
         PROCEDURE EvToolBarResize(Sender:TObject);
         FUNCTION  GetSelectedBrowseInfo:PBrowseInfo;
         PROCEDURE UpdateBrowserContent;
         PROCEDURE FillGlobalsListBox;
         PROCEDURE FillUnitsTreeView;
         PROCEDURE FillObjectsTreeView;
     END;


CONST
    BrowserWin:TBrowser=NIL;
    BrowserInfo:TBrowserInfo=NIL;


PROCEDURE InitBrowser;


IMPLEMENTATION

{Browser types}
CONST br_Type        = 1;
      br_Var         = 2;
      br_Const       = 3;
      br_Class       = 4;
      br_Proc        = 5;
      br_Func        = 6;
      br_Object      = 7;
      br_Record      = 8;
      br_Property    = 9;
      br_Constructor = 10;
      br_Destructor  = 11;
      br_Enum        = 12;
      br_Set         = 13;
      br_Pointer     = 14;

PROCEDURE TBrowserOutLine.CheckMenuPopup(pt:TPoint);
BEGIN
     Inherited CheckMenuPopup(pt);

     BrowserWin.ShowContextMenu(SELF,pt.X,pt.Y);
END;


PROCEDURE TBrowserOutLine.ItemFocus(SelectedItem:LONGINT);
VAR Info:PBrowseInfo;
BEGIN
     Inherited ItemFocus(SelectedItem);

     Info:=Items[SelectedItem].Data;
     BrowserWin.LastTreeItemSel:=Info;
     IF Info=NIL THEN exit;
     BrowserWin.RightListBox.BeginUpdate;
     BrowserWin.RightListBox.Clear;
     IF Info^.NestedInfo<>NIL THEN BrowserWin.UpdateNestedInfo(Info);
     BrowserWin.RightListBox.EndUpdate;
END;


PROCEDURE TBrowserSwitchButton.Click;
VAR Enum:TBrowserEnum;
    Info:PBrowseInfo;
BEGIN
     Inherited Click;

     IF Handle=0 THEN exit;

     CASE GroupIndex OF
        Browser_Constants:  Enum:=_Constants;
        Browser_Procedures: Enum:=_Procedures;
        Browser_Types:      Enum:=_Types;
        Browser_Variables:  Enum:=_Variables;
        Browser_Properties: Enum:=_Properties;
        Browser_Inherited:  Enum:=_Inherited;
        Browser_Virtual:    Enum:=_Virtual;
        Browser_Private:    Enum:=_Private;
        Browser_Protected:  Enum:=_Protected;
        Browser_Public:     Enum:=_Public;
        Browser_Published:  Enum:=_Published;
        ELSE exit;
     END; {case}

     IdeSettings.Browse.Buttons[GroupIndex] := Down;
     IdeSettings.Modified := TRUE;

     IF Down
       THEN Include(BrowserWin.ShowTypes,Enum)
       ELSE Exclude(BrowserWin.ShowTypes,Enum);

     IF ((Enum IN [_Constants,_Procedures,_Types,_Variables])AND
         (BrowserWin.Mode<>mo_Objects)) THEN
     BEGIN
          BrowserWin.UpdateContents;
     END
     ELSE
     BEGIN
          {only change right side}
          BrowserWin.RightListBox.BeginUpdate;
          BrowserWin.RightListBox.Clear;
          IF BrowserWin.Mode=mo_Globals THEN
          BEGIN
               IF BrowserWin.LastLeftSelItem<>-1 THEN
                 IF BrowserWin.LastLeftSelItem<BrowserWin.GlobalsListBox.Items.Count THEN
               BEGIN
                    Info:=POINTER(BrowserWin.GlobalsListBox.Items.Objects[BrowserWin.LastLeftSelItem]);
                    IF Info^.NestedInfo<>NIL THEN
                    BEGIN
                         BrowserWin.LastLeftSelRoot:=Info;
                         BrowserWin.UpdateNestedInfo(Info);
                    END;
               END;
          END
          ELSE
          BEGIN
               Info:=BrowserWin.LastTreeItemSel;
               IF Info<>NIL THEN BrowserWin.UpdateNestedInfo(Info);
          END;
          BrowserWin.RightListBox.EndUpdate;
     END;
END;


PROCEDURE TLeftBitmapListBox.DrawItem(Index:LONGINT;Rec:TRect;State:TOwnerDrawState);
VAR Info:PBrowseInfo;
    Bitmap:TBitmap;
    x,y,cx,cy,cx1,cy1:LONGINT;
    s:STRING;
BEGIN
     IF State * [odSelected] <> [] THEN
     BEGIN
          Canvas.Pen.Color := clHighLightText;
          Canvas.Brush.Color := clHighLight;
     END ELSE
     BEGIN
          Canvas.Pen.Color := PenColor;
          Canvas.Brush.Color := Color;
     END;
     Canvas.FillRect(Rec,Canvas.Brush.Color);

     x := Rec.Left + 2;
     y := Rec.Bottom + 1;
     cx := Rec.Right - x;
     cy := Rec.Top - y;

     IF Index<Items.Count THEN Info:=POINTER(Items.Objects[Index])
     ELSE Info:=NIL;

     IF Info<>NIL THEN
     BEGIN
          Bitmap:=NIL;

          CASE Info^.BrowseType OF
             br_Proc,br_Func:Bitmap:=BrowserWin.Procedures;
             br_Var:Bitmap:=BrowserWin.Variables;
             br_Const:Bitmap:=BrowserWin.Constants;
             br_Type,br_Class,br_Object,br_Record,br_Set,br_Enum,br_Pointer:Bitmap:=BrowserWin.Types;
          END; {case}

          IF Bitmap<>NIL THEN
          BEGIN
               Canvas.StretchDraw(x,y,Bitmap.Width,Bitmap.Height,Bitmap);
               inc(x,Bitmap.Width+5);
          END;
     END;

     s := Items.Strings[Index];
     Canvas.GetTextExtent(s,cx1,cy1);
     y := y + ((cy - cy1) DIV 2);
     IF y <= Rec.Bottom THEN y := Rec.Bottom + 1;
     Canvas.TextOut(x,y,s);
END;

PROCEDURE TLeftBitmapListBox.MeasureItem(Index:LONGINT;VAR CX,CY:LONGINT);
BEGIN
  Inherited MeasureItem(Index,CX,CY);
  inc(CX,20);
END;

{$HINTS OFF}
PROCEDURE TLeftBitmapListBox.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
  Inherited MouseClick(Button,ShiftState,X,Y);
  IF Button <> mbRight THEN exit;
  LastMsg.CallDefaultHandler;
  BrowserWin.ShowContextMenu(SELF,X,Y);
END;
{$HINTS ON}

PROCEDURE TRightBitmapListBox.DrawItem(Index:LONGINT;Rec:TRect;State:TOwnerDrawState);
VAR  Info:PBrowseInfo;
     Bitmap:TBitmap;
     x,y,cx,cy,cx1,cy1:LONGINT;
     HighLight:BOOLEAN;
     s:STRING;
     browsetype:BYTE;
BEGIN
     IF State * [odSelected] <> [] THEN
     BEGIN
          Canvas.Pen.Color := clHighLightText;
          Canvas.Brush.Color := clHighLight;
     END ELSE
     BEGIN
          Canvas.Pen.Color := PenColor;
          Canvas.Brush.Color := Color;
     END;
     Canvas.FillRect(Rec,Canvas.Brush.Color);
     x := Rec.Left + 2;
     y := Rec.Bottom + 1;
     cx := Rec.Right - x;
     cy := Rec.Top - y;

     IF Index<Items.Count THEN Info:=POINTER(Items.Objects[Index])
     ELSE Info:=NIL;

     IF Info<>NIL THEN
     BEGIN
          Bitmap:=NIL;
          HighLight := State * [odSelected] <> [];

          browsetype := Info^.BrowseType;

          IF browsetype IN [br_Type,br_Set,br_Enum,br_Pointer]
          THEN browsetype := br_Var;

          CASE browsetype OF
             br_Proc,br_Func,br_Constructor,br_Destructor:Bitmap:=BrowserWin.Procedures;
             br_Var:Bitmap:=BrowserWin.Variables;
             br_Const:Bitmap:=BrowserWin.Constants;
             br_Type,br_Class,br_Object,br_Record,br_Set,br_Enum,br_Pointer:Bitmap:=BrowserWin.Types;
             br_Property:Bitmap:=BrowserWin.Properties;
          END; {case}

          IF Bitmap<>NIL THEN
          BEGIN
               Canvas.StretchDraw(x,y,20,20,Bitmap);
               inc(x,20);
          END;

          IF BrowserWin.Mode IN [mo_Objects,mo_Units] THEN
          BEGIN
               IF Info^.OwnerInfo<>NIL THEN
                 IF Info^.OwnerInfo<>BrowserWin.LastTreeItemSel THEN
               BEGIN
                    Bitmap:=BrowserWin.Inherit[Highlight];
                    Canvas.StretchDraw(x,y,20,20,Bitmap);
               END;
          END
          ELSE
          BEGIN
               IF Info^.OwnerInfo<>NIL THEN
                 IF Info^.OwnerInfo<>BrowserWin.LastLeftSelRoot THEN
               BEGIN
                    Bitmap:=BrowserWin.Inherit[Highlight];
                    Canvas.StretchDraw(x,y,20,20,Bitmap);
               END;
          END;
          inc(x,20);

          IF Info^.Flags AND 8=8 THEN {Virtual}
          BEGIN
               Bitmap:=BrowserWin.Virt[Highlight];
               Canvas.StretchDraw(x,y,20,20,Bitmap);
          END;
          inc(x,20);

          Bitmap:=NIL;
          IF Info^.Scope AND 8=8 THEN {Published}
            Bitmap:=BrowserWin.Publish[Highlight]
          ELSE IF Info^.Scope AND 1=1 THEN {Public}
            Bitmap:=BrowserWin.Pub[Highlight]
          ELSE IF Info^.Scope AND 4=4 THEN {Protected}
            Bitmap:=BrowserWin.Prot[Highlight]
          ELSE IF Info^.Scope AND 2=2 THEN {Private}
            Bitmap:=BrowserWin.Priv[Highlight];

          IF Bitmap<>NIL THEN Canvas.StretchDraw(x,y,20,20,Bitmap);
          inc(x,20);
     END;
     inc(x,5);

     s := Items.Strings[Index];
     Canvas.GetTextExtent(s,cx1,cy1);
     y := y + ((cy - cy1) DIV 2);
     IF y <= Rec.Bottom THEN y := Rec.Bottom + 1;
     Canvas.TextOut(x,y,s);
END;

PROCEDURE TRightBitmapListBox.MeasureItem(Index:LONGINT;VAR CX,CY:LONGINT);
BEGIN
     Inherited MeasureItem(Index,CX,CY);
     inc(CX,80);
END;

{$HINTS OFF}
PROCEDURE TRightBitmapListBox.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     Inherited MouseClick(Button,ShiftState,X,Y);

     IF Button <> mbRight THEN exit;

     LastMsg.CallDefaultHandler;
     BrowserWin.ShowContextMenu(SELF,X,Y);
END;


PROCEDURE TBrowseToolBar.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     Inherited MouseClick(Button,ShiftState,X,Y);

     IF Button <> mbRight THEN exit;

     LastMsg.CallDefaultHandler;
     BrowserWin.ShowContextMenu(SELF,X,Y);
END;


PROCEDURE TBrowseToolBar.EvResize(Sender:TObject);
BEGIN
     IF IdeSettings.Browse.DetailWindowWidth <> Size THEN
     BEGIN
          IdeSettings.Browse.DetailWindowWidth := Size;
          IdeSettings.Modified := TRUE;
     END;
END;
{$HINTS ON}

///////////////////////////////////////////////////////////////////////////////////


{$HINTS OFF}
PROCEDURE TBrowser.LeftListBoxFocus(Sender:TObject;Index:LONGINT);
VAR Info:PBrowseInfo;
BEGIN
     IF Index=LastLeftSelItem THEN exit;

     IF GlobalsListBox.Items.Objects[Index]<>NIL THEN
     BEGIN
          Info:=POINTER(GlobalsListBox.Items.Objects[Index]);
          LastLeftSelRoot := Info;

          RightListBox.BeginUpdate;
          RightListBox.Clear;
          IF Info^.NestedInfo<>NIL THEN
          BEGIN
               LastLeftSelRoot:=Info;
               UpdateNestedInfo(Info);
          END;
          RightListBox.EndUpdate;
     END;

     LastLeftSelItem:=Index;
END;


PROCEDURE TBrowser.RightListBoxFocus(Sender:TObject;Index:LONGINT);
BEGIN
     LastListSel:=NIL;
     IF RightListBox.ItemIndex=Index THEN
       IF RightListBox.Items.Objects[Index]<>NIL
       THEN LastListSel:=POINTER(RightListBox.Items.Objects[Index]);
END;
{$HINTS OFF}


PROCEDURE InitBrowser;
BEGIN
  IF BrowserWin <> NIL THEN
    BEGIN
      IF BrowserWin.WindowState = wsMinimized
        THEN BrowserWin.WindowState := wsNormal;
      BrowserWin.BringToFront;
      exit;
    END;
  BrowserWin.Create(NIL);
  BrowserWin.HelpContext := hctxDialogBrowserForm;
  BrowserWin.Show;
  BrowserWin.BringToFront;
  BrowserWin.Update;
END;


PROCEDURE TBrowser.SetupComponent;
VAR Bitmap:TBitmap;
    Switch:TBrowserSwitchButton;
    t:LONGINT;
    X:LONGINT;
BEGIN
  Inherited SetupComponent;

  SibylFormId := dwi_Browser;
  LastLeftSelItem:=-1;
  LastLeftSelRoot:=NIL;

  ShowTypes:=[];

  Inherit[FALSE].Create;
  Inherit[FALSE].LoadFromResourceId(1449);
  Inherit[TRUE].Create;
  Inherit[TRUE].LoadFromResourceId(1450);


  Virt[FALSE].Create;
  Virt[FALSE].LoadFromResourceId(1451);
  Virt[TRUE].Create;
  Virt[TRUE].LoadFromResourceId(1452);

  Publish[FALSE].Create;
  Publish[FALSE].LoadFromResourceId(1453);
  Publish[TRUE].Create;
  Publish[TRUE].LoadFromResourceId(1454);

  Pub[FALSE].Create;
  Pub[FALSE].LoadFromResourceId(1455);
  Pub[TRUE].Create;
  Pub[TRUE].LoadFromResourceId(1456);

  Priv[FALSE].Create;
  Priv[FALSE].LoadFromResourceId(1457);
  Priv[TRUE].Create;
  Priv[TRUE].LoadFromResourceId(1458);

  Prot[FALSE].Create;
  Prot[FALSE].LoadFromResourceId(1459);
  Prot[TRUE].Create;
  Prot[TRUE].LoadFromResourceId(1460);

  Width:=600;
  Height:=350;
  Left:=(Screen.Width-Width) DIV 2;
  Bottom:=(Screen.Height-Height) DIV 2;
  Color:=clLtGray;
  Mode:=IdeSettings.Browse.ViewMode;
  CASE Mode OF
    mo_Objects: Caption:=LoadNLSStr(SiBrowseObjects);
    mo_Units:   Caption:=LoadNLSStr(SiBrowseUnits);
    mo_Globals: Caption:=LoadNLSStr(SiBrowseGlobals);
  END;


  ToolBar.Create(SELF);
  ToolBar.Alignment:=tbTop;
  ToolBar.Size:=34;
  ToolBar.BevelStyle := tbNone;
  X:=10;
  FOR t:=Browser_Constants TO Browser_Published DO
  BEGIN
       IF IdeSettings.Browse.Buttons[t] THEN
       BEGIN
            CASE t OF
              Browser_Constants:  Include(ShowTypes, _Constants);
              Browser_Procedures: Include(ShowTypes, _Procedures);
              Browser_Types:      Include(ShowTypes, _Types);
              Browser_Variables:  Include(ShowTypes, _Variables);
              Browser_Properties: Include(ShowTypes, _Properties);
              Browser_Inherited:  Include(ShowTypes, _Inherited);
              Browser_Virtual:    Include(ShowTypes, _Virtual);
              Browser_Private:    Include(ShowTypes, _Private);
              Browser_Protected:  Include(ShowTypes, _Protected);
              Browser_Public:     Include(ShowTypes, _Public);
              Browser_Published:  Include(ShowTypes, _Published);
            END;
       END;

       Switch.Create(ToolBar);
       Switch.Left:=X;
       Switch.Bottom:=5;
       Switch.Width:=24;
       Switch.Height:=24;
       Switch.Hint:=BrowserHints[t];
       Switch.AllowAllUp:=TRUE;
       Switch.GroupIndex:=t;
       Switch.Down := IdeSettings.Browse.Buttons[t];
       Switch.Flat:=IdeSettings.FlatButtons;
       Bitmap.Create;
       Bitmap.LoadFromResourceId(t);
       CASE t OF
          Browser_Constants:  Constants:=Bitmap;
          Browser_Procedures: Procedures:=Bitmap;
          Browser_Types:      Types:=Bitmap;
          Browser_Variables:  Variables:=Bitmap;
          Browser_Properties: Properties:=Bitmap;
       END;
       Switch.Glyph:=Bitmap;
       ToolBar.InsertControl(Switch);
       inc(X,24);
  END;

  Progress := InsertProgressBar(ToolBar, X + 10,5,0,24);
  Progress.ProgressString := psCaption;
  Progress.Visible := FALSE;

  ToolBar.OnScan:=ChildScanEvent;
  ToolBar.OnResize:=EvToolBarResize;
  InsertControl(ToolBar);

  OnScan:=ChildScanEvent;

  RightTool.Create(SELF);
  RightTool.Alignment:=tbRight;
  RightTool.Size:=IdeSettings.Browse.DetailWindowWidth;
  RightTool.OnScan:=ChildScanEvent;
  RightTool.Sizeable := TRUE;
  RightTool.OnResize := RightTool.EvResize;

  RightListBox.Create(RightTool);
  RightListBox.HelpContext := hctxDialogBrowserDetailList;
  RightListBox.SetWindowPos(5,0,RightTool.Width-5,RightTool.Height);
  RightListBox.Color := clWindow;
  RightListBox.Style:=lbOwnerdrawFixed;
  RightListBox.ItemHeight:=22;
  RightListBox.HorzScroll:=TRUE;
  RightListBox.OnScan:=ChildScanEvent;
  RightListBox.OnItemFocus:=RightListBoxFocus;
  RightTool.InsertControl(RightListBox);
  InsertControl(RightTool);
  RightListBox.Align := alFrame; {erst nachdem Parent zugewiesen wurde}

  ObjectsTreeView.Create(SELF);
  ObjectsTreeView.HelpContext := hctxDialogBrowserObjectTree;
  ObjectsTreeView.Align:=alClient;
  ObjectsTreeView.OnScan:=ChildScanEvent;
  ObjectsTreeView.CreateCanvas;
  InsertControl(ObjectsTreeView);

  UnitsTreeView.Create(SELF);
  UnitsTreeView.HelpContext := hctxDialogBrowserUnitsTree;
  UnitsTreeView.Align:=alClient;
  UnitsTreeView.OnScan:=ChildScanEvent;
  UnitsTreeView.CreateCanvas;
  InsertControl(UnitsTreeView);

  GlobalsListBox.Create(SELF);
  GlobalsListBox.HelpContext := hctxDialogBrowserGlobalsList;
  GlobalsListBox.Align:=alClient;
  GlobalsListBox.Style:=lbOwnerdrawFixed;
  GlobalsListBox.Color := clWindow;
  GlobalsListBox.ItemHeight:=22;
  GlobalsListBox.Sorted:=TRUE;
  GlobalsListBox.HorzScroll:=TRUE;
  GlobalsListBox.OnScan:=ChildScanEvent;
  GlobalsListBox.OnItemFocus:=LeftListBoxFocus;
  InsertControl(GlobalsListBox);
END;


PROCEDURE TBrowser.EvToolBarResize;
BEGIN
  IF Progress <> NIL THEN
    BEGIN
      Progress.Width := Toolbar.Width - Progress.Left - 10;
    END;
END;


DESTRUCTOR TBrowser.Destroy;
BEGIN
  Application.LogWriteln('Browser.tBrowser.Destroy: Start');

  BrowserWin := NIL;

  IF PopUp <> NIL THEN
    PopUp.Destroy;

  FreeAllData;

  Inherit[FALSE].Destroy;
  Inherit[TRUE].Destroy;
  Virt[FALSE].Destroy;
  Virt[TRUE].Destroy;
  Publish[FALSE].Destroy;
  Publish[TRUE].Destroy;
  Pub[FALSE].Destroy;
  Pub[TRUE].Destroy;
  Priv[FALSE].Destroy;
  Priv[TRUE].Destroy;
  Prot[FALSE].Destroy;
  Prot[TRUE].Destroy;
  Constants.Destroy;
  Procedures.Destroy;
  Types.Destroy;
  Variables.Destroy;
  Properties.Destroy;

  Inherited Destroy;
  Application.LogWriteln('Browser.tBrowser.Destroy: Ende');
END;


PROCEDURE TBrowser.UpdateNestedInfo(Info:PBrowseInfo);
VAR t,t1:LONGINT;
    s,s1:STRING;
    aUnit:PBrowseUnits;
BEGIN
     IF Info = NIL THEN exit;

     IF Info^.NestedInfo <> NIL THEN
       FOR t:=0 TO Info^.NestedInfo.Count-1
          DO AddItem(RightListBox,Info^.NestedInfo.Items[t]);

     IF Info^.BrowseType IN [br_Class,br_Object] THEN
       IF _Inherited in ShowTypes THEN
         IF Info^.ParentName<>NIL THEN
         BEGIN
              {Look for parent object}
              s:=Info^.ParentName^;
              UpcaseStr(s);
              FOR t:=0 TO BrowserInfo.Units.Count-1 DO
              BEGIN
                   aUnit:=BrowserInfo.Units.Items[t];
                   IF aUnit^.Objects<>NIL THEN
                    FOR t1:=0 TO aUnit^.Objects.Count-1 DO
                    BEGIN
                         Info:=aUnit^.Objects.Items[t1];
                         s1:=Info^.Name^;
                         UpcaseStr(s1);
                         IF s=s1 THEN
                           IF Info^.NestedInfo<>NIL THEN
                           BEGIN
                                UpdateNestedInfo(Info);
                                exit;
                           END;
                    END;
              END;
         END;
END;


PROCEDURE TBrowser.AddItem(aListBox:TListBox;Info:PBrowseInfo);
VAR  s:STRING;
     browsetype:BYTE;
BEGIN
    IF Info^.Scope AND 8=8 THEN {Published}
      IF not (_Published IN ShowTypes) THEN exit;

    IF Info^.Scope AND 1=1 THEN {Public}
      IF not (_Public IN ShowTypes) THEN exit;

    IF Info^.Scope AND 4=4 THEN {Protected}
      IF not (_Protected IN ShowTypes) THEN exit;

    IF Info^.Scope AND 2=2 THEN {Private}
      IF not (_Private IN ShowTypes) THEN exit;

    s:=Info^.Name^;

    browsetype := Info^.BrowseType;

    IF aListBox = RightListBox THEN
    BEGIN
         IF browsetype IN [br_Type,br_Set,br_Enum,br_Pointer]
         THEN browsetype := br_Var;
    END;

    CASE browsetype OF
        br_Var:
        BEGIN
             IF not (_Variables IN ShowTypes) THEN exit;
             s:='Var '+s;
             IF Info^.Typ<>NIL THEN
               IF pos('?',Info^.Typ^) = 0 THEN s:=s+':'+Info^.Typ^;
        END;
        br_Const:
        BEGIN
             IF not (_Constants IN ShowTypes) THEN exit;
             s:='Const '+s;
             IF Info^.Typ<>NIL THEN s:=s+':'+Info^.Typ^;
        END;
        br_Type,br_Set,br_Enum,br_Pointer:
        BEGIN
             IF not (_Types IN ShowTypes) THEN exit;
             s:='Type '+s;
             IF Info^.Typ<>NIL THEN
             BEGIN
                  IF browsetype=br_Set THEN s:=s+'=Set Of '+Info^.Typ^
                  ELSE IF browsetype=br_Pointer THEN s:=s+'=^'+Info^.Typ^
                  ELSE s:=s+'='+Info^.Typ^;
             END
             ELSE
             BEGIN
                  CASE browsetype OF
                      br_Enum:s:=s+'=Enumeration';
                      br_Set:s:=s+'=Set';
                      br_Pointer:s:=s+'=Pointer';
                  END;
             END;
        END;
        br_Record:
        BEGIN
             IF not (_Types IN ShowTypes) THEN exit;
             s:='Type '+s+'=Record';
        END;
        br_Object:
        BEGIN
             IF not (_Types IN ShowTypes) THEN exit;
             s:='Type '+s+'=Object';
             IF Info^.ParentName<>NIL THEN s:=s+'('+Info^.ParentName^+')';
        END;
        br_Class:
        BEGIN
             IF not (_Types IN ShowTypes) THEN exit;
             s:='Type '+s+'=Class';
             IF Info^.ParentName<>NIL THEN s:=s+'('+Info^.ParentName^+')';
        END;
        br_Property:
        BEGIN
             IF not (_Properties IN ShowTypes) THEN exit;
             s:='Prop '+s;
             IF Info^.Typ<>NIL THEN s:=s+':'+Info^.Typ^;
        END;
        br_Proc,br_Func,br_Constructor,br_Destructor:
        BEGIN
             IF not (_Procedures IN ShowTypes) THEN exit;

             IF Info^.Flags AND 8=8 THEN {Virtual}
               IF not (_Virtual IN ShowTypes) THEN exit;

             IF browsetype=br_Func THEN
             BEGIN
                  s:='Func '+s;
                  IF Info^.Typ<>NIL THEN s:=s+':'+Info^.Typ^;
             END
             ELSE s:='Proc '+s;
        END;
    END; {case}

    IF Info <> NIL THEN aListBox.Items.AddObject(s,POINTER(Info))
    ELSE aListBox.Items.Add(s);   {to save time}
END;


PROCEDURE TBrowser.UpdateContents;
BEGIN
     LastLeftSelItem:=-1;
     LastLeftSelRoot:=NIL;
     LastTreeItemSel:=NIL;
     LastListSel:=NIL;

     RightListBox.Clear;
     CASE Mode OF
        mo_Objects: FillObjectsTreeView;
        mo_Units  : FillUnitsTreeView;
        mo_Globals: FillGlobalsListBox;
     END;
END;


CONST
    MaxRTLFiles=32;
    RTLFiles:ARRAY[1..MaxRTLFiles] OF STRING[8] = (
      {$IFDEF OS2}
      'BSEDEV',
      'BSEDOS',
      'BSEERR',
      'BSEEXCPT',
      'BSESUB',
      'BSETIB',
      'CRT',
      'DIVE',
      'DOS',
      'INTERNET',
      'MMIO',
      'OS2DEF',
      'OPENGL',
      'PMBITMAP',
      'PMDEV',
      'PMERR',
      'PMGPI',
      'PMHELP',
      'PMSHL',
      'PMSPL',
      'PMSTDDLG',
      'PMWIN',
      'PMWP',
      'PMWSOCK',
      'PORTIO',
      'PRINTER',
      'REXXSAA',
      'SERIALIO',
      'SOCKAPI',
      'STRINGS',
      'SYSTEM',
      'WINCRT'
      {$ENDIF}
      {$IFDEF WIN32}
      'WINDEF',
      'WINBASE',
      'WINNT',
      'WINNET',
      'WINCON',
      'COMMCTRL',
      'CRT',
      'DIVE',
      'DOS',
      'INTERNET',
      'MMSYSTEM',
      'OS2DEF',
      'OPENGL',
      'PMBITMAP',
      'PMDEV',
      'PMERR',
      'PMGPI',
      'PMHELP',
      'PMSHL',
      'PMSPL',
      'PMSTDDLG',
      'WINUSER',
      'PMWP',
      'PMWSOCK',
      'PORTIO',
      'PRINTER',
      'REXXSAA',
      'SERIALIO',
      'SOCKAPI',
      'STRINGS',
      'SYSTEM',
      'WINCRT'
      {$ENDIF}
      );

    MaxSPCCFiles=30;
    SPCCFiles:ARRAY[1..MaxSPCCFiles] OF STRING[8] = (
      'ADDUTILS',
      'BUTTONS',
      'CLASSES',
      'CLIPBRD',
      'COMCTRLS',
      'DBBASE',
      'DBCTRLS',
      'DBLAYER',
      'DDEMAN',
      'DIALOGS',
      'DOCKTOOL',
      'EDITORS',
      'EXTCTRLS',
      'FILECTRL',
      'FORMS',
      'GRAPHICS',
      'GRIDS',
      'INIFILES',
      'LANGUAGE',
      'LISTVIEW',
      'MASK',
      'MESSAGES',
      'MMEDIA',
      'OUTLINE',
      'PRINTERS',
      'PRNDLGS',
      'STDCTRLS',
      'SYSUTILS',
      'TABCTRLS',
      'TOOLSAPI'
      );


PROCEDURE UpdateBrowserInfo(Immediate:BOOLEAN);FORWARD;

PROCEDURE TBrowser.UpdateBrowserContent;
VAR  i,k:LONGINT;
     s,s1:STRING;
LABEL addFile,nextFile;
BEGIN
     Screen.Cursor := crHourglass;

     FreeAllData;

     IF not BrowserInfo.DataAvailable THEN UpdateBrowserInfo(TRUE);

     Progress.Position := 0;
     Progress.Max := 3;
     Progress.Position := 0;
     Progress.PenColor := clBlue;
     Progress.Color := clLtGray;
     Progress.Visible := TRUE;

     Update;

     CASE Mode OF
       mo_Objects:
       BEGIN
            ObjectsTreeView.Show;
            UpdateContents; {Fill the current TreeView/ListBox}
            Progress.Position := Progress.Position +1;

            UnitsTreeView.Hide;
            Progress.Position := Progress.Position +1;

            GlobalsListBox.Hide;
            Progress.Position := Progress.Position +1;
       END;
       mo_Globals:
       BEGIN
            GlobalsListBox.Show;
            UpdateContents; {Fill the current TreeView/ListBox}
            Progress.Position := Progress.Position +1;

            ObjectsTreeView.Hide;
            Progress.Position := Progress.Position +1;

            UnitsTreeView.Hide;
            Progress.Position := Progress.Position +1;
       END;
       mo_Units:
       BEGIN
            UnitsTreeView.Show;
            UpdateContents; {Fill the current TreeView/ListBox}
            Progress.Position := Progress.Position +1;

            ObjectsTreeView.Hide;
            Progress.Position := Progress.Position +1;

            GlobalsListBox.Hide;
            Progress.Position := Progress.Position +1;
       END;
     END;

     Progress.Visible := FALSE;

     Screen.Cursor := crDefault;
END;


PROCEDURE TBrowser.FreeAllData;
BEGIN
     UnitsTreeView.Clear;
     ObjectsTreeView.Clear;
     GlobalsListBox.Clear;
     RightListBox.Clear;

     UnitsShowTypes := [];
     GlobalsShowTypes := [];
END;


PROCEDURE TBrowser.Show;
BEGIN
     Inherited Show;
     Update;

     UpdateBrowserContent;

     IF Project.BrowserFiles.Count = 0 THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiNoBrowseInfoAvail)+#13#10#10+
                   LoadNLSStr(SiCloseBrowser));
     END;
END;


PROCEDURE TBrowser.ChildScanEvent(Sender:TObject;VAR KeyCode:TKeyCode);
VAR Command:TCommand;
BEGIN
     CASE KeyCode OF
        kbCtrlO:Command:=cmObjects;
        kbCtrlU:Command:=cmUnits;
        kbCtrlG:Command:=cmGlobals;
        kbCtrlY:Command:=cmSymbol;
        kbCtrlV:
        BEGIN
             CommandSender:=TControl(Sender);
             Command:=cmSource;
        END;
        kbCtrlD:Command:=cmUpdate;
        ELSE Command:=cmNull;
     END;

     IF Command<>cmNull THEN CommandEvent(Command);
END;

CONST Processing:BOOLEAN=FALSE;


PROCEDURE TBrowser.CommandEvent(VAR Command:TCommand);
VAR  Info:PBrowseInfo;
     FName:STRING;
     Edit:TSibEditor;
LABEL ex;
BEGIN
     IF Processing THEN exit;
     Processing := TRUE;

     CASE Command OF
        cmObjects:
        BEGIN
             CASE Mode OF {old mode}
                mo_Objects: goto ex;
                mo_Units:   UnitsTreeView.Hide;
                mo_Globals: GlobalsListBox.Hide;
             END;

             Mode:=mo_Objects;
             Caption:=LoadNLSStr(SiBrowseObjects);
             ObjectsTreeView.Show;
             UpdateContents;

             IdeSettings.Browse.ViewMode := Mode;
             IdeSettings.Modified := TRUE;
        END;
        cmUnits:
        BEGIN
             CASE Mode OF {old mode}
                mo_Objects: ObjectsTreeView.Hide;
                mo_Units:   goto ex;
                mo_Globals: GlobalsListBox.Hide;
             END;

             Mode:=mo_Units;
             Caption:=LoadNLSStr(SiBrowseUnits);
             UnitsTreeView.Show;
             UpdateContents;

             IdeSettings.Browse.ViewMode := Mode;
             IdeSettings.Modified := TRUE;
        END;
        cmGlobals:
        BEGIN
             CASE Mode OF {old mode}
                mo_Objects: ObjectsTreeView.Hide;
                mo_Units:   UnitsTreeView.Hide;
                mo_Globals: goto ex;
             END;

             Mode:=mo_Globals;
             Caption:=LoadNLSStr(SiBrowseGlobals);
             GlobalsListBox.Show;
             UpdateContents;

             IdeSettings.Browse.ViewMode := Mode;
             IdeSettings.Modified := TRUE;
        END;
        cmSymbol:
        BEGIN
             goto ex;
        END;
        cmQualified:
        BEGIN
             goto ex;
        END;
        cmSource:
        BEGIN
             Info := GetSelectedBrowseInfo;

             IF Info<>NIL THEN
               IF Info^.Line<>0 THEN
             BEGIN
                  FName := GetFullSourceName(ProjectPrimary(Project.Settings),Info^.TargetUnit^);
                  Edit := LoadEditor(FName,0,0,0,0,TRUE,EditorPos(Info^.Line,1),Fokus,ShowIt);
                  IF Edit <> NIL THEN Edit.GotoPosition(EditorPos(Info^.Line,1))
                  ELSE ErrorBox(FmtLoadNLSStr(SiSrcFileNotFound,[FName]));
             END;
             goto ex;
        END;
        cmUpdate:
        BEGIN
             UpdateBrowserContent;
             goto ex;
        END;
        cmBrowserProperties:
        BEGIN
             ActiveGeneralPage := BrowserPropertiesIndex;
             SendMsg(Application.MainForm.Handle,CM_COMMAND,cmGeneral,0);
        END;
        ELSE goto ex;
     END; {case}
ex:
     Processing:=FALSE;
END;


FUNCTION TBrowser.GetSelectedBrowseInfo:PBrowseInfo;
VAR  Info:PBrowseInfo;
     Node:TOutlineNode;
BEGIN
     Info := NIL;
     IF CommandSender = ObjectsTreeView THEN
     BEGIN
          Node := ObjectsTreeView.SelectedNode;
          IF Node <> NIL THEN Info := Node.Data;
     END
     ELSE IF CommandSender = UnitsTreeView THEN
     BEGIN
          Node := UnitsTreeView.SelectedNode;
          IF Node <> NIL THEN Info := Node.Data;
     END
     ELSE IF CommandSender = GlobalsListBox THEN
     BEGIN
          Info := LastLeftSelRoot;
     END
     ELSE IF CommandSender = RightListBox THEN
     BEGIN
          Info := LastListSel
     END;
     Result := Info;
END;

PROCEDURE TBrowser.ShowContextMenu(AOwner:TControl;X,Y:LONGINT);
VAR  Entry:TMenuItem;
     Info:PBrowseInfo;
     enableit:BOOLEAN;
     pt:TPoint;
BEGIN
     IF Popup=NIL THEN
     BEGIN
          Popup.Create(SELF);

          ObjectsEntry.Create(Popup);
          ObjectsEntry.Caption:=LoadNLSStr(SiBrObjects)+'\tCtrl+O';
          ObjectsEntry.Command:=cmObjects;
          ObjectsEntry.HelpContext := hctxPopupBrowseObjects;
          Popup.Items.Add(ObjectsEntry);

          UnitsEntry.Create(Popup);
          UnitsEntry.Caption:=LoadNLSStr(SiBrUnits)+'\tCtrl+U';
          UnitsEntry.Command:=cmUnits;
          UnitsEntry.HelpContext := hctxPopupBrowseUnits;
          Popup.Items.Add(UnitsEntry);

          GlobalsEntry.Create(Popup);
          GlobalsEntry.Caption:=LoadNLSStr(SiBrGlobals)+'\tCtrl+G';
          GlobalsEntry.Command:=cmGlobals;
          GlobalsEntry.HelpContext := hctxPopupBrowseGlobals;
          Popup.Items.Add(GlobalsEntry);

          Entry.Create(Popup);
          Entry.Caption:='-';
          Popup.Items.Add(Entry);

          SourceEntry.Create(Popup);
          SourceEntry.Caption:=LoadNLSStr(SiBrViewSource)+'\tCtrl+V';
          SourceEntry.Command:=cmSource;
          SourceEntry.HelpContext := hctxPopupBrowserSource;
          Popup.Items.Add(SourceEntry);

          Entry.Create(Popup);
          Entry.Caption:='-';
          Popup.Items.Add(Entry);

          UpdateEntry.Create(Popup);
          UpdateEntry.Caption:=LoadNLSStr(SiBrUpdate)+'\tCtrl+D';
          UpdateEntry.Command:=cmUpdate;
          UpdateEntry.HelpContext := hctxPopupBrowserUpdate;
          Popup.Items.Add(UpdateEntry);

          Entry.Create(Popup);
          Entry.Caption:='-';
          Popup.Items.Add(Entry);

          Entry.Create(Popup);
          Entry.Caption:=LoadNLSStr(SiBrProperties);
          Entry.Command:=cmBrowserProperties;
          Entry.HelpContext := hctxPopupBrowserProperties;
          Popup.Items.Add(Entry);
     END;

     CommandSender:=AOwner;

     {Enable/Disable Entries}
     ObjectsEntry.Enabled := Mode <> mo_Objects;
     UnitsEntry.Enabled := Mode <> mo_Units;
     GlobalsEntry.Enabled := Mode <> mo_Globals;
     //SymbolEntry.Enabled := FALSE;     {temp}
     //QualifiedEntry.Enabled := FALSE;  {temp}
     enableit := FALSE;
     Info := GetSelectedBrowseInfo;
     IF Info <> NIL THEN
       IF Info^.Line <> 0 THEN enableit := TRUE;
     SourceEntry.Enabled := enableit;
     UpdateEntry.Enabled := not Processing;

     pt := AOwner.ClientToScreen(Point(X,Y));
     Popup.Popup(pt.X,pt.Y);
END;


PROCEDURE TBrowser.TranslateShortCut(KeyCode:TKeyCode;VAR Receiver:TForm);
BEGIN
     Inherited TranslateShortCut(KeyCode,Receiver);

     IF KeyCode = kbShiftF10 THEN
     BEGIN
          ShowContextMenu(SELF, Width DIV 2, Height DIV 2);
     END;
END;

/////////////////////////////////////////////////////////////////////////////

PROCEDURE TBrowser.FillGlobalsListBox;
VAR  i:LONGINT;
BEGIN
     IF GlobalsShowTypes = ShowTypes THEN exit;    {stimmt noch}
     GlobalsListBox.Clear;
     GlobalsListBox.BeginUpdate;
     FOR i := 0 TO BrowserInfo.SortedGlobals.Count-1 DO
     BEGIN
          AddItem(GlobalsListBox,BrowserInfo.SortedGlobals.Items[i]);
     END;
     GlobalsListBox.EndUpdate;
     GlobalsShowTypes := ShowTypes;
END;


PROCEDURE TBrowser.FillUnitsTreeView;
VAR  i:LONGINT;
BEGIN
     IF UnitsShowTypes = ShowTypes THEN exit;    {stimmt noch}
     UnitsTreeView.Clear;
     UnitsTreeView.BeginUpdate;
     FOR i := 0 TO BrowserInfo.SortedUnits.Root.ItemCount-1 DO
     BEGIN
          BrowserInfo.SortedUnits.InsertTreeUnit(BrowserInfo.SortedUnits.Root.Items[i]);
     END;
     UnitsTreeView.EndUpdate;
     UnitsShowTypes := ShowTypes;
END;


PROCEDURE TBrowser.FillObjectsTreeView;
VAR  i,j:LONGINT;
     RootChild,Node:TBrowseObjectsNode;
     aInfo:PBrowseInfo;
     List:TStringList;
BEGIN
     IF ObjectsTreeView.ItemCount > 1 THEN exit; {schon gefllt; mehr als Root}

     ObjectsTreeView.Clear;
     ObjectsTreeView.BeginUpdate;

     BrowserInfo.SortedObjects.InsertTreeObject(NIL,BrowserInfo.SortedObjects.Root.Data, TRUE); {TObject einfgen}

     List.Create;
     List.Sorted := TRUE;

     FOR i := 0 TO BrowserInfo.SortedObjects.Root.ItemCount-1 DO
     BEGIN
          RootChild := TBrowseObjectsNode(BrowserInfo.SortedObjects.Root.Items[i]);
          FOR j := 0 TO RootChild.ItemCount-1 DO
          BEGIN
               Node := TBrowseObjectsNode(RootChild.Items[j]);
               aInfo := Node.Data;
               List.AddObject(aInfo^.Name^,TObject(aInfo));
          END;
     END;

     FOR i := 0 TO List.Count-1 DO
     BEGIN
          aInfo := PBrowseInfo(List.Objects[i]);
          BrowserInfo.SortedObjects.InsertTreeObject(NIL, aInfo, FALSE);
     END;

     //ObjectsTreeView.FullExpand;
     ObjectsTreeView.EndUpdate;

     List.Destroy;
END;


/////////////////////////////////////////////////////////////////////////////
// Liste zur Verwaltung der Globals
/////////////////////////////////////////////////////////////////////////////

PROCEDURE TBrowseGlobalsList.InsertUnitAscending(aUnit:PBrowseUnits);
VAR  i:LONGINT;
BEGIN
     {Bezeichner einsortieren}
     IF aUnit^.Types <> NIL THEN
       FOR i := 0 TO aUnit^.Types.Count-1
          DO InsertIdentifier(aUnit^.Types.Items[i]);

     IF aUnit^.Variables <> NIL THEN
       FOR i := 0 TO aUnit^.Variables.Count-1
          DO InsertIdentifier(aUnit^.Variables.Items[i]);

     IF aUnit^.Objects <> NIL THEN
       FOR i := 0 TO aUnit^.Objects.Count-1
          DO InsertIdentifier(aUnit^.Objects.Items[i]);

     IF aUnit^.Constants <> NIL THEN
       FOR i := 0 TO aUnit^.Constants.Count-1
          DO InsertIdentifier(aUnit^.Constants.Items[i]);

     IF aUnit^.Procedures <> NIL THEN
       FOR i := 0 TO aUnit^.Procedures.Count-1
          DO InsertIdentifier(aUnit^.Procedures.Items[i]);
END;


PROCEDURE TBrowseGlobalsList.InsertIdentifier(aInfo:PBrowseInfo);
BEGIN
     Add(aInfo);
END;

/////////////////////////////////////////////////////////////////////////////
// Tree zur Verwaltung der Units
/////////////////////////////////////////////////////////////////////////////

PROCEDURE TBrowseUnitsList.InsertUnitAscending(aUnit:PBrowseUnits);
VAR  RootChild:TTreeNode;
     UnitNode:TTreeNode;
     i:LONGINT;
     cmpUnit:STRING;
     newUnit:STRING;
LABEL l;
BEGIN
     newUnit := aUnit^.Name;
     UpcaseStr(newUnit);
     {sortiert Einfgen im Level 1}
     FOR i := 0 TO Root.ItemCount-1 DO
     BEGIN
          RootChild := Root.Items[i];
          cmpUnit := PBrowseUnits(RootChild.Data)^.Name;
          UpcaseStr(cmpUnit);
          IF cmpUnit > newUnit THEN
          BEGIN
               UnitNode := InsertObjectNode(RootChild,aUnit);
               goto l;
          END;
     END;
     UnitNode := AddChildObjectNode(Root,aUnit);
l:
     {Bezeichner einsortieren}
     IF aUnit^.Types <> NIL THEN
       FOR i := 0 TO aUnit^.Types.Count-1
          DO InsertIdentifier(UnitNode,aUnit^.Types.Items[i]);

     IF aUnit^.Variables <> NIL THEN
       FOR i := 0 TO aUnit^.Variables.Count-1
          DO InsertIdentifier(UnitNode,aUnit^.Variables.Items[i]);

     IF aUnit^.Objects <> NIL THEN
       FOR i := 0 TO aUnit^.Objects.Count-1
          DO InsertIdentifier(UnitNode,aUnit^.Objects.Items[i]);

     IF aUnit^.Constants <> NIL THEN
       FOR i := 0 TO aUnit^.Constants.Count-1
          DO InsertIdentifier(UnitNode,aUnit^.Constants.Items[i]);

     IF aUnit^.Procedures <> NIL THEN
       FOR i := 0 TO aUnit^.Procedures.Count-1
          DO InsertIdentifier(UnitNode,aUnit^.Procedures.Items[i]);
END;


PROCEDURE TBrowseUnitsList.InsertIdentifier(UnitNode:TTreeNode;aInfo:PBrowseInfo);
VAR  i:LONGINT;
     min,max:LONGINT;
     cmpInfo:PBrowseInfo;
     cmpName:STRING;
     newName:STRING;
     Node:TTreeNode;
BEGIN
     newName := aInfo^.Name^;
     UpcaseStr(newName);
(* lineares Einfgen ist viel zu langsam
     FOR i := 0 TO UnitNode.ItemCount-1 DO
     BEGIN
          Node := UnitNode.Items[i];
          cmpInfo := Node.Data;
          cmpName := cmpInfo^.Name^;
          UpcaseStr(cmpName);
          IF cmpName > newName THEN
          BEGIN
               InsertObjectNode(Node,aInfo);
               exit;
          END;
     END;

     AddChildObjectNode(UnitNode,aInfo);
*)

     {binres Einfgen ist effektiv bei groแen Datenmengen}
     min := 1;
     max := UnitNode.ItemCount;
     Node := NIL;
     REPEAT
        i := (min + max) DIV 2;
        IF (i < 1) OR (i > UnitNode.ItemCount) THEN break;

        Node := UnitNode.Items[i-1];
        cmpInfo := Node.Data;
        cmpName := cmpInfo^.Name^;
        UpcaseStr(cmpName);

        IF newName < cmpName THEN
        BEGIN
             max := i - 1;
             {Node ist noch gltig fr Insert}
        END
        ELSE
        BEGIN
             IF newName = cmpName THEN
             BEGIN
                  InsertObjectNode(Node,aInfo);
                  exit;
             END;

             min := i + 1;
             inc(i);
             Node := NIL; {Node ist ungltig fr Insert}
        END
     UNTIL (min > max);


     IF (i >= 1) AND (i <= UnitNode.ItemCount) THEN
     BEGIN
          Node := UnitNode.Items[i-1];
          InsertObjectNode(Node,aInfo);
     END
     ELSE AddChildObjectNode(UnitNode,aInfo);
END;


PROCEDURE TBrowseUnitsList.InsertTreeUnit(Node:TTreeNode);
VAR  aUnit:PBrowseUnits;
     aInfo:PBrowseInfo;
     UnitNode:TOutlineNode;
     i:LONGINT;
     ShowTypes:TBrowserShowTypes;
BEGIN
     aUnit := Node.Data;
     UnitNode := BrowserWin.UnitsTreeView.AddChildObjectNode(NIL,aUnit^.Name,aUnit);
     ShowTypes := BrowserWin.ShowTypes;

     FOR i := 0 TO Node.ItemCount-1 DO
     BEGIN
          aInfo := Node.Items[i].Data;
          CASE aInfo^.BrowseType OF
            br_Proc,br_Func: IF not (_Procedures IN ShowTypes) THEN continue;
            br_Var:          IF not (_Variables IN ShowTypes) THEN continue;
            br_Const:        IF not (_Constants IN ShowTypes) THEN continue;
            ELSE             IF not (_Types IN ShowTypes) THEN continue;
          END; {case}
          BrowserWin.UnitsTreeView.AddChildObjectNode(UnitNode,aInfo^.Name^,aInfo);
     END;
END;


/////////////////////////////////////////////////////////////////////////////
// Tree zur Verwaltung der Objekte
/////////////////////////////////////////////////////////////////////////////

PROCEDURE TBrowseObjectsList.SetupComponent;
BEGIN
     Inherited SetupComponent;
     NodeClass := TBrowseObjectsNode;
END;


PROCEDURE TBrowseObjectsList.InsertParentAscending(aInfo:PBrowseInfo);
VAR  i:LONGINT;
     newParent:STRING;
     RootChild:TBrowseObjectsNode;
     Node:TBrowseObjectsNode;
BEGIN
     IF aInfo = NIL THEN exit;

     IF aInfo^.ParentName <> NIL THEN
     BEGIN
          newParent := aInfo^.ParentName^;
          UpcaseStr(newParent);
          FOR i := 0 TO Root.ItemCount-1 DO
          BEGIN
               RootChild := TBrowseObjectsNode(Root.Items[i]);

               IF RootChild.ParentName = newParent THEN
               BEGIN
                    {sortiert Einfgen in die Liste vom RootChild}
                    InsertNameAscending(RootChild,aInfo);
                    exit;
               END;

               IF RootChild.ParentName > newParent THEN {neue Gruppe generieren}
               BEGIN
                    Node := TBrowseObjectsNode(InsertObjectNode(RootChild,NIL)); {????????????????}
                    Node.ParentName := aInfo^.ParentName^;
                    InsertNameAscending(Node,aInfo);
                    exit;
               END;
          END;

          {anhngen}
          Node := TBrowseObjectsNode(AddChildObjectNode(Root,NIL)); {?????????????????????????}
          Node.ParentName := aInfo^.ParentName^;
          InsertNameAscending(Node,aInfo);
     END
     ELSE
     BEGIN
          IF Upcased(aInfo^.Name^) = 'TOBJECT' THEN Root.Data := aInfo; {TObject}
     END;
END;


PROCEDURE TBrowseObjectsList.InsertNameAscending(ParentNode:TBrowseObjectsNode;
                                                 aInfo:PBrowseInfo);
VAR  newName:STRING;
     cmpName:STRING;
     cmpInfo:PBrowseInfo;
     min,max,i:LONGINT;
     Node:TBrowseObjectsNode;
BEGIN
     newName := aInfo^.Name^;
     UpcaseStr(newName);
(* linear ist zu langsam
     FOR i := 0 TO ParentNode.ItemCount-1 DO
     BEGIN
          Node := TBrowseObjectsNode(ParentNode.Items[i]);
          cmpName := PBrowseInfo(Node.Data)^.Name^;
          UpcaseStr(cmpName);
          IF cmpName > newName THEN
          BEGIN
               InsertObjectNode(Node,aInfo);
               exit;
          END;
     END;
     AddChildObjectNode(ParentNode,aInfo);
*)

     {binres Einfgen ist effektiv bei groแen Datenmengen}
     min := 1;
     max := ParentNode.ItemCount;
     Node := NIL;
     REPEAT
        i := (min + max) DIV 2;
        IF (i < 1) OR (i > ParentNode.ItemCount) THEN break;

        Node := TBrowseObjectsNode(ParentNode.Items[i-1]);
        cmpInfo := Node.Data;
        cmpName := cmpInfo^.Name^;
        UpcaseStr(cmpName);

        IF newName < cmpName THEN
        BEGIN
             max := i - 1;
             {Node ist noch gltig fr Insert}
        END
        ELSE
        BEGIN
             IF newName = cmpName THEN
             BEGIN
                  InsertObjectNode(Node,aInfo);
                  exit;
             END;

             min := i + 1;
             inc(i);
             Node := NIL; {Node ist ungltig fr Insert}
        END
     UNTIL (min > max);


     IF (i >= 1) AND (i <= ParentNode.ItemCount) THEN
     BEGIN
          Node := TBrowseObjectsNode(ParentNode.Items[i-1]);
          InsertObjectNode(Node,aInfo);
     END
     ELSE AddChildObjectNode(ParentNode,aInfo);
END;


PROCEDURE TBrowseObjectsList.InsertTreeObject(ParentNode:TOutlineNode;
                                    aInfo:PBrowseInfo;rekursiv:BOOLEAN);
VAR  i,j:LONGINT;
     cmpParent,cmpActual:STRING;
     Item:TBrowseObjectsNode;
     RootChild:TBrowseObjectsNode;
     NewNode:TOutlineNode;
BEGIN
     IF aInfo = NIL THEN exit;

     NewNode := BrowserWin.ObjectsTreeView.AddChildObjectNode(ParentNode,aInfo^.Name^,aInfo);

     IF Not rekursiv THEN exit;

     {suche die Gruppe im Tree, die Kinder von aInfo^.Name sind}
     cmpParent := aInfo^.Name^;
     UpcaseStr(cmpParent);
     FOR i := 0 TO Root.ItemCount-1 DO
     BEGIN
          RootChild := TBrowseObjectsNode(Root.Items[i]);
          cmpActual:=RootChild.ParentName;
          UpcaseStr(cmpActual);
          IF cmpActual = cmpParent THEN
          BEGIN
               {fge die RootChild Gruppe an NewNode an}
               FOR j := 0 TO RootChild.ItemCount-1 DO
               BEGIN
                    Item := TBrowseObjectsNode(RootChild.Items[j]);
                    InsertTreeObject(NewNode, Item.Data, rekursiv);
               END;
               break;
          END;
     END;
END;


/////////////////////////////////////////////////////////////////////////////
// Elemente der BrowseObjectsListe
/////////////////////////////////////////////////////////////////////////////

FUNCTION TBrowseObjectsNode.GetParentName:STRING;
BEGIN
     IF FParentName <> NIL THEN Result := FParentName^
     ELSE Result := '';
END;


PROCEDURE TBrowseObjectsNode.SetParentName(Name:STRING);
BEGIN
     IF FParentName <> NIL THEN FreeMem(FParentName, Length(FParentName^)+1);

     IF Name <> '' THEN
     BEGIN
          GetMem(FParentName, Length(Name)+1);
          UpcaseStr(Name);
          FParentName^ := Name;
     END
     ELSE FParentName := NIL;
END;


DESTRUCTOR TBrowseObjectsNode.Destroy;
BEGIN
     IF FParentName <> NIL THEN FreeMem(FParentName, Length(FParentName^)+1);

     Inherited Destroy;
END;



FUNCTION GetBrowserInfo(Qualifier,Identifier:String; FindMethods:BOOLEAN;
  Var ParameterList:TStringList):BOOLEAN;

TYPE
  ByteSet = SET OF BYTE;

  FUNCTION FindInfo(Const InfoName:STRING; InfoTypes:ByteSet):PBrowseInfo;
  VAR  i:LONGINT;
  BEGIN
       FOR i := 0 TO BrowserInfo.SortedGlobals.Count-1 DO
       BEGIN
            Result := BrowserInfo.SortedGlobals.Items[i];

            IF not (Result^.BrowseType IN InfoTypes) THEN continue;

            IF UpperCase(Result^.Name^) = InfoName THEN exit;
       END;
       Result := NIL;
  END;

  FUNCTION GetQual(VAR q:STRING; VAR Optional:STRING):STRING;
  VAR  i:INTEGER;
  BEGIN
       Result := '';
       Optional := '';
       WHILE (Length(q) > 0) AND (q[1] IN ['^','.']) DO Delete(q,1,1);
       i := pos('|',q);
       IF i > 0 THEN
       BEGIN
            Optional := Copy(q,1,i-1);
            Delete(q,1,i);
       END;

       FOR i := 1 TO Length(q) DO
       BEGIN
            IF q[i] IN ['^','.'] THEN break;
            Result := Result + q[i];
       END;
       Delete(q,1,Length(Result));
       WHILE (Length(q) > 0) AND (q[1] IN ['^','.']) DO Delete(q,1,1);
  END;

  FUNCTION SearchQualInfo(qual:STRING; ident:STRING; searchtypes:ByteSet):PBrowseInfo;
  VAR  s,sopt:STRING;
       i:LONGINT;
       SubInfo,FoundInfo:PBrowseInfo;
       IgnorePrivates:BOOLEAN;
  LABEL tryparent;
  BEGIN
       Result := NIL;

       s := GetQual(qual, sopt);
       IF s = '' THEN
       BEGIN
            Result := FindInfo(ident, searchtypes);
            exit;
       END;

       IgnorePrivates := FALSE;

       // s ist der Ausgangspunkt der Suche
       Result := FindInfo(s, searchtypes);

       IF Result <> NIL THEN
       BEGIN
            // Ausgangsposition gefunden
            REPEAT
                 FoundInfo := NIL;
                 s := GetQual(qual, sopt);

tryparent:
                 IF Result^.NestedInfo = NIL THEN
                 BEGIN
                      // wahrscheinlich eine Variable -> probiere den Typ
                      IF Result^.Typ = NIL THEN Result := NIL
                      ELSE Result := FindInfo(UpperCase(Result^.Typ^),searchtypes);

                      IF Result <> NIL THEN goto tryparent
                      ELSE break;
                 END;

                 FOR i := 0 TO Result^.NestedInfo.Count-1 DO
                 BEGIN
                      SubInfo := Result^.NestedInfo.Items[i];

                      IF SubInfo^.Name = NIL THEN continue;

                      IF s = '' THEN
                      BEGIN
                           IF Uppercase(SubInfo^.Name^) = ident THEN
                           BEGIN
                                IF SubInfo^.Scope AND 2=2 THEN {Private}
                                  IF IgnorePrivates THEN continue;

                                FoundInfo := SubInfo; // L”sung

                                IF FoundInfo^.BrowseType IN [br_Property] THEN
                                  IF FoundInfo^.Typ <> NIL THEN
                                    FoundInfo := FindInfo(UpperCase(FoundInfo^.Typ^),searchtypes);
                                break;
                           END;
                      END
                      ELSE
                      BEGIN
                           IF Uppercase(SubInfo^.Name^) = s THEN
                           BEGIN
                                FoundInfo := SubInfo;
                                break;
                           END;
                      END;
                 END;

                 // auch die Elternklassen durchsuchen (Vererbung!)
                 IF FoundInfo = NIL THEN
                   IF Result^.BrowseType IN [br_Class,br_Object] THEN
                   BEGIN
                        IF Result^.ParentName <> NIL THEN
                        BEGIN
                             {Look in parent object}
                             Result := FindInfo(UpperCase(Result^.ParentName^),
                                                [br_Class,br_Object]);
                             IF Result <> NIL THEN
                             BEGIN
                                  IgnorePrivates := TRUE;
                                  goto tryparent;
                             END;
                        END;
                   END;

                 Result := FoundInfo;
            UNTIL ((s = '') OR (Result = NIL));
       END;
  END;


VAR  i:LONGINT;
     Info,SubInfo:PBrowseInfo;
     s,qual1,qualopt:STRING;
     searchtypes:ByteSet;
BEGIN
     Result := FALSE;
     IF BrowserInfo = NIL THEN exit;
     IF Identifier = '' THEN exit;
     IF BrowserInfo.SortedGlobals = NIL THEN exit;

     UpcaseStr(Qualifier);
     UpcaseStr(Identifier);


     searchtypes := [br_Class,br_Object,br_Proc,br_Func,br_Property,
                     br_Constructor,br_Destructor,br_Record,br_Var];

     qual1 := GetQual(Qualifier, qualopt);

     Info := SearchQualInfo(qualopt+'.'+qual1+'.'+Qualifier, Identifier, searchtypes);

     IF Info = NIL THEN
       IF qualopt <> '' THEN
         Info := SearchQualInfo(qual1+'.'+Qualifier, Identifier, searchtypes);

     IF Info = NIL THEN
       IF qual1 <> '' THEN
         Info := SearchQualInfo(Qualifier, Identifier, searchtypes); // System.


     IF FindMethods THEN
     BEGIN
          // suche den passenden Typ
          IF Info <> NIL THEN
            IF Info^.Typ <> NIL THEN
              Info := FindInfo(UpperCase(Info^.Typ^),
                                         [br_Class,br_Object,br_Record]);

          WHILE Info <> NIL DO
          BEGIN
               IF Info^.NestedInfo <> NIL THEN
                 FOR i := 0 TO Info^.NestedInfo.Count-1 DO
                 BEGIN
                      SubInfo := Info^.NestedInfo.Items[i];

                      IF Info^.BrowseType IN [br_Class,br_Object] THEN
                        IF not ((SubInfo^.Scope AND 8=8) OR {Published}
                                (SubInfo^.Scope AND 1=1)) {Public}
                        THEN continue;

                      IF SubInfo^.Name <> NIL THEN s := SubInfo^.Name^ + '|'
                      ELSE continue;

                      IF SubInfo^.Typ <> NIL THEN s := s + ':' + SubInfo^.Typ^;

                      CASE SubInfo^.BrowseType OF
                         br_Var:         s := 'variable|' + s;
                         br_Property:    s := 'property|' + s;
                         br_Proc:        s := 'procedure|' + s;
                         br_Func:        s := 'function|' + s;
                         br_Constructor: s := 'constructor|' + s;
                         br_Destructor:  s := 'destructor|' + s;
                         ELSE            s := '|';
                      END;

                      ParameterList.Add(s);
                 END;

                 IF Info^.BrowseType IN [br_Class,br_Object] THEN
                 BEGIN
                      IF Info^.ParentName <> NIL THEN
                      BEGIN
                           {Look for parent object}
                           Info := FindInfo(UpperCase(Info^.ParentName^),
                                            [br_Class,br_Object]);
                      END
                      ELSE break; // while
                 END
                 ELSE break; // while
          END;
     END
     ELSE
     BEGIN
          IF Info <> NIL THEN // Funktion gefunden
          BEGIN
               // Parameter auswerten
               IF Info^.NestedInfo <> NIL THEN
                 FOR i := 0 TO Info^.NestedInfo.Count-1 DO
                 BEGIN
                      SubInfo := Info^.NestedInfo.Items[i];

                      IF SubInfo^.Name <> NIL THEN s := SubInfo^.Name^
                      ELSE continue;

                      IF UpperCase(s) = 'SELF' THEN continue; // hidden Pointer

                      CASE SubInfo^.BrowseType OF
                         br_Type:
                         BEGIN
                              IF SubInfo^.Typ <> NIL THEN
                                IF pos('?',SubInfo^.Typ^) = 0 THEN s := s + ':'+ SubInfo^.Typ^;
                         END;
                         br_Var:
                         BEGIN
                              s := 'Var '+ s;
                              IF SubInfo^.Typ <> NIL THEN
                                IF pos('?',SubInfo^.Typ^) = 0 THEN s := s + ':'+ SubInfo^.Typ^;
                         END;
                         br_Const:
                         BEGIN
                              s := 'Const '+ s;
                              IF SubInfo^.Typ <> NIL THEN s := s+ ':'+ SubInfo^.Typ^;
                         END;
                      END;

                      ParameterList.Add(s);
                 END;
          END;
     END;

     Result := ParameterList.Count > 0;
END;


PROCEDURE UpdateBrowserInformation;
VAR  i,k:LONGINT;
     s,s1:STRING;
LABEL addFile,nextFile;
BEGIN
     BrowserInfo.FreeData;

     {Informationen aus dem Projekt nehmen}
     FOR i := 0 TO Project.BrowserFiles.Count-1 DO
     BEGIN
          IF IdeSettings.Browse.Files <> [bf_RTL,bf_SPCC,bf_Project] THEN
          BEGIN
               {einzelne Files ausmaskieren}
               s := Upcased(Project.BrowserFiles[i]);

               {teste, ob das File ein RTL File ist}
               FOR k := 1 TO MaxRTLFiles DO
               BEGIN
                    s1 := RTLFiles[k];
                    IF s <> s1 THEN continue;
                    {Name gefunden}
                    IF (bf_RTL IN IdeSettings.Browse.Files) THEN goto addFile
                    ELSE goto nextFile;
               END;

               {teste, ob das File ein SPCC File ist}
               FOR k := 1 TO MaxSPCCFiles DO
               BEGIN
                    s1 := SPCCFiles[k];
                    IF s <> s1 THEN continue;
                    {Name gefunden}
                    IF (bf_SPCC IN IdeSettings.Browse.Files) THEN goto addFile
                    ELSE goto nextFile;
               END;

               {alle anderen Files sind Projekt Files}
               IF (bf_Project IN IdeSettings.Browse.Files) THEN goto addFile
               ELSE goto nextFile;
          END;
addFile:
          BrowserInfo.AddBrowseUnit(Project.BrowserFiles[i] + EXT_UC_WDSibyl_Project);
nextFile:
     END;

     BrowserInfo.UpdateSortedGlobalsList;
     BrowserInfo.UpdateSortedObjectsList;
     BrowserInfo.UpdateSortedUnitsList;
     BrowserInfo.DataAvailable := TRUE;
END;


TYPE
    TBrowserInfoThread=CLASS(TThread)
       PROCEDURE Execute;OVERRIDE;
    END;


PROCEDURE TBrowserInfoThread.Execute;
BEGIN
     IF BrowserWin <> NIL THEN
     BEGIN
          BrowserWin.Enabled := FALSE;
          BrowserWin.FreeAllData;
     END;

     UpdateBrowserInformation;

     IF BrowserWin <> NIL THEN
     BEGIN
          BrowserWin.UpdateBrowserContent;
          BrowserWin.Enabled := TRUE;
     END;
END;


PROCEDURE UpdateBrowserInfo(Immediate:BOOLEAN);
VAR  BrowserThread:TBrowserInfoThread;
BEGIN
     IF not Immediate THEN
     BEGIN
          BrowserThread.ExtCreate(TRUE,256*1024,tpNormal,NIL);
          BrowserThread.FreeOnTerminate := TRUE;
          BrowserThread.Resume;
     END
     ELSE UpdateBrowserInformation;
END;




CONSTRUCTOR TBrowserInfo.Create;
BEGIN
     Inherited Create;

     Units.Create;
     DataAvailable := FALSE;
END;


DESTRUCTOR TBrowserInfo.Destroy;
BEGIN
     FreeData;
     Units.Destroy;
     Units := NIL;

     Inherited Destroy;
END;


PROCEDURE TBrowserInfo.AddBrowseUnit(CONST NameExt:STRING);
VAR  d,s:STRING;
LABEL readit;
BEGIN
     {Suche im OutDir Verzeichnis}
     d := ProjectOutDir(Project.Settings);
     s := FExpand(GetNextDir(d) + '\' + NameExt);
     IF FileExists(s) THEN goto readit;

     {Suche im LibDir Verzeichnis}
     d := ProjectLibDir(Project.Settings);
     WHILE d <> '' DO
     BEGIN
          s := FExpand(GetNextDir(d) + '\' + NameExt);
          IF FileExists(s) THEN  goto readit;
     END;

     {Suche im LibSrc Verzeichnis}
     d := ProjectLibSrcDir(Project.Settings);
     WHILE d <> '' DO
     BEGIN
          s := FExpand(GetNextDir(d) + '\' + NameExt);
          IF FileExists(s) THEN  goto readit;
     END;

     {Suche im IncSrc Verzeichnis}
     d := ProjectIncSrcDir(Project.Settings);
     WHILE d <> '' DO
     BEGIN
          s := FExpand(GetNextDir(d) + '\' + NameExt);
          IF FileExists(s) THEN  goto readit;
     END;

     {Suche im CompInstallDir Verzeichnis}
     d := ProjectCompInstallDir(Project.Settings);
     WHILE d <> '' DO
     BEGIN
          s := FExpand(GetNextDir(d) + '\' + NameExt);
          IF FileExists(s) THEN  goto readit;
     END;
     exit;
readit:
     ReadInformation(s);
END;


PROCEDURE TBrowserInfo.ReadInformation(CONST UnitName:STRING);
TYPE
    T_SPU_Header=RECORD
                 //General information
                 Signatur:CSTRING[5];             //Signatur SPU01
                 Name:CSTRING[63];                //Name of Unit
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


VAR F:FILE;
    SPU_Header:T_SPU_Header;
    Dir,Name,Ext:STRING;
LABEL err;
BEGIN
     System.Assign(f,UnitName);
     {$i-}
     reset(f);
     {$I+}
     IF InOutRes<>0 THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiCouldNotLoadFile,[UnitName]));
          exit;
     END;

     {$i-}
     BlockRead(f,SPU_Header,SizeOf(SPU_Header));
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
err:
          {$i-}
          System.close(f);
          {$i+}
          ErrorBox(FmtLoadNLSStr(SiFileReadError,[UnitName]));
          exit;
     END;
     IF SPU_Header.Signatur<>'SPU40' THEN
      IF SPU_Header.Signatur<>'SPW40' THEN
     BEGIN
          {$i-}
          System.close(f);
          {$i+}
          ErrorBox(FmtLoadNLSStr(SiIllegalUnitFormat,[UnitName]));
          exit;
     END;

     {$i-}
     Seek(f,SPU_Header.BrowseInfoOffset);
     {$i+}
     IF InOutRes<>0 THEN goto err;

     FSplit(UnitName,Dir,Name,Ext);

     ReadFromFile(F,Name);
     {$i-}
     System.close(f);
     {$i+}
END;


PROCEDURE TBrowserInfo.ReadFromFile(VAR F:FILE;CONST UnitName:STRING);

   FUNCTION ReadLong(VAR l:LONGINT):BOOLEAN;
   BEGIN
        {$i-}
        BlockRead(f,l,4);
        {$i+}
        result:=InOutRes=0;
   END;

   FUNCTION ReadWord(VAR w:WORD):BOOLEAN;
   BEGIN
        {$i-}
        BlockRead(f,w,2);
        {$i+}
        result:=InOutRes=0;
   END;

   FUNCTION ReadByte(VAR b:BYTE):BOOLEAN;
   BEGIN
        {$i-}
        BlockRead(f,b,1);
        {$i+}
        result:=InOutRes=0;
   END;

   FUNCTION ReadProcedure(Info:PBrowseInfo;Typ:BYTE):BOOLEAN;
   VAR l:LONGINT;
       b:BYTE;
       Nested:PBrowseInfo;
   BEGIN
        result:=FALSE;
        IF not ReadWord(Info^.Flags) THEN exit;
        IF not ReadLong(l) THEN exit;                 //Name Index
        Info^.Name:=POINTER(l);
        IF not ReadWord(Info^.Line) THEN exit;        //Line number

        IF Typ=br_Func THEN
        BEGIN
             IF not ReadLong(l) THEN exit;                 //Name Index
             Info^.Typ:=POINTER(l);
        END;

        Info^.NestedInfo.Create;
        IF not ReadByte(b) THEN exit;
        WHILE b<>0 DO
        BEGIN
             IF b IN [1,2,3] THEN
             BEGIN
                  New(Nested);
                  Nested^.BrowseType:=b;
                  Nested^.OwnerInfo:=Info;
                  Nested^.TargetUnit:=Info^.TargetUnit;
                  Nested^.Line:=Info^.Line;
                  IF not ReadLong(l) THEN exit;                 //Name Index
                  Nested^.Name:=POINTER(l);
                  IF not ReadLong(l) THEN exit;                 //Name Index
                  Nested^.Typ:=POINTER(l);

                  Info^.NestedInfo.Add(Nested);
             END
             ELSE exit;
             IF not ReadByte(b) THEN exit;
        END;

        result:=TRUE;
   END;

   PROCEDURE FixNameTable(Info:PBrowseInfo;Add:LONGWORD);
   VAR t:LONGINT;
   BEGIN
        inc(Info^.Name,Add);
        IF Info^.Typ<>NIL THEN inc(Info^.Typ,Add);
        IF Info^.ParentName<>NIL THEN inc(Info^.ParentName,Add);
        IF Info^.ParentUnit<>NIL THEN inc(Info^.ParentUnit,Add);
        IF Info^.NestedInfo<>NIL THEN
          FOR t:=0 TO Info^.NestedInfo.Count-1 DO FixNameTable(Info^.NestedInfo.Items[t],Add);
   END;

VAR b,b1:BYTE;
    BrowseInfo,Nested:PBrowseInfo;
    UnitInfo:PBrowseUnits;
    l,t:LONGINT;
    fp:longword;
LABEL err;
BEGIN
     new(UnitInfo);
     UnitInfo^.Name:=UnitName;
     Units.Add(UnitInfo);

     BrowseInfo:=NIL;
     IF not ReadByte(b) THEN
     BEGIN
err:
          IF BrowseInfo<>NIL THEN Dispose(BrowseInfo);
          ErrorBox(FmtLoadNLSStr(SiFileReadError,[UnitName]));
          exit;
     END;
     WHILE b<>0 DO
     BEGIN
          new(BrowseInfo);
          BrowseInfo^.BrowseType:=b;
          BrowseInfo^.TargetUnit:=@UnitInfo^.Name;

          CASE b OF
              br_Type,br_Set,br_Enum,br_Pointer:
              BEGIN
                   IF not ReadLong(l) THEN goto err;                 //Name Index
                   BrowseInfo^.Name:=POINTER(l);
                   IF not ReadWord(BrowseInfo^.Line) THEN goto err;  //Line number
                   IF UnitInfo^.Types=NIL THEN UnitInfo^.Types.Create;
                   UnitInfo^.Types.Add(BrowseInfo);

                   CASE b OF
                     br_Set,br_Pointer,br_Type:
                     BEGIN
                          IF not ReadLong(l) THEN goto err;                 //Name Index
                          BrowseInfo^.Typ:=POINTER(l);
                     END;
                     br_Enum:
                     BEGIN
                          IF not ReadLong(l) THEN goto err;                 //Name Index
                          BrowseInfo^.NestedInfo.Create;
                          WHILE l<>0 DO
                          BEGIN
                               New(Nested);
                               Nested^.BrowseType:=br_Const;
                               Nested^.OwnerInfo:=BrowseInfo;
                               Nested^.TargetUnit:=@UnitInfo^.Name;
                               Nested^.Name:=Pointer(l);
                               Nested^.Line:=BrowseInfo^.Line;
                               BrowseInfo^.NestedInfo.Add(Nested);
                               IF not ReadLong(l) THEN goto err;                 //Name Index
                          END;
                     END;
                   END; {case}
              END;
              br_Var:
              BEGIN
                   IF not ReadLong(l) THEN goto err;                 //Name Index
                   BrowseInfo^.Name:=POINTER(l);
                   IF not ReadWord(BrowseInfo^.Line) THEN goto err;  //Line number
                   IF not ReadLong(l) THEN goto err;                 //TypName Index
                   BrowseInfo^.Typ:=POINTER(l);
                   IF UnitInfo^.Variables=NIL THEN UnitInfo^.Variables.Create;
                   UnitInfo^.Variables.Add(BrowseInfo);
              END;
              br_Const:
              BEGIN
                   IF not ReadLong(l) THEN goto err;                 //Name Index
                   BrowseInfo^.Name:=POINTER(l);
                   IF not ReadWord(BrowseInfo^.Line) THEN goto err;  //Line number
                   IF UnitInfo^.Constants=NIL THEN UnitInfo^.Constants.Create;
                   UnitInfo^.Constants.Add(BrowseInfo);
              END;
              br_Class,br_Object,br_Record:
              BEGIN
                   IF not ReadLong(l) THEN goto err;                 //Name Index
                   BrowseInfo^.Name:=POINTER(l);
                   IF not ReadWord(BrowseInfo^.Line) THEN goto err;  //Line number

                   IF b IN [br_Class,br_Object] THEN
                   BEGIN
                        IF not ReadLong(l) THEN goto err;                 //Name Index
                        BrowseInfo^.ParentUnit:=POINTER(l);
                        IF BrowseInfo^.ParentUnit<>NIL THEN
                        BEGIN
                             IF not ReadLong(l) THEN goto err;
                             BrowseInfo^.ParentName:=POINTER(l);
                        END;
                   END;

                   IF not ReadByte(b1) THEN goto err;
                   BrowseInfo^.NestedInfo.Create;
                   WHILE b1<>0 DO
                   BEGIN
                        New(Nested);
                        Nested^.BrowseType:=b1;
                        Nested^.OwnerInfo:=BrowseInfo;
                        Nested^.TargetUnit:=@UnitInfo^.Name;

                        CASE b1 OF
                           br_Var,br_Property:
                           BEGIN
                                IF not ReadLong(l) THEN goto err;                 //Name Index
                                Nested^.Name:=POINTER(l);
                                IF not ReadWord(Nested^.Line) THEN goto err;      //Line number
                                IF not ReadLong(l) THEN goto err;                 //TypName Index
                                Nested^.Typ:=POINTER(l);
                           END;
                           br_Func,br_Proc,br_Constructor,br_Destructor:
                           BEGIN
                                IF not ReadProcedure(Nested,b1) THEN goto err;
                           END;
                           ELSE goto err;
                        END; {case}

                        IF b IN [br_Class,br_Object] THEN
                          IF not ReadByte(Nested^.Scope) THEN goto err;

                        BrowseInfo^.NestedInfo.Add(Nested);
                        IF not ReadByte(b1) THEN goto err;
                   END;

                   IF b=br_Record THEN
                   BEGIN
                        IF UnitInfo^.Types=NIL THEN UnitInfo^.Types.Create;
                        UnitInfo^.Types.Add(BrowseInfo);
                   END
                   ELSE
                   BEGIN
                        IF UnitInfo^.Objects=NIL THEN UnitInfo^.Objects.Create;
                        UnitInfo^.Objects.Add(BrowseInfo);
                   END;
              END;
              br_Proc,br_Func:
              BEGIN
                   IF not ReadProcedure(BrowseInfo,b) THEN goto err;
                   IF UnitInfo^.Procedures=NIL THEN UnitInfo^.Procedures.Create;
                   UnitInfo^.Procedures.Add(BrowseInfo);
              END;
              ELSE goto err;
          END; {case}

          IF not ReadByte(b) THEN goto err;
     END;

     {Read Name Table and fix up names}
     IF not ReadLong(UnitInfo^.NameTableSize) THEN goto err;
     inc(UnitInfo^.NameTableSize); //add dummy byte (prevent 0 pointers)
     getmem(UnitInfo^.NameTable,UnitInfo^.NameTableSize);

     {$i-}
     BlockRead(f,UnitInfo^.NameTable^,UnitInfo^.NameTableSize);
     {$i+}
     IF InOutRes<>0 THEN goto err;

     l:=LONGWORD(UnitInfo^.NameTable);
     IF UnitInfo^.Types<>NIL THEN
       FOR t:=0 TO UnitInfo^.Types.Count-1
          DO FixNameTable(UnitInfo^.Types.Items[t],l);
     IF UnitInfo^.Variables<>NIL THEN
       FOR t:=0 TO UnitInfo^.Variables.Count-1
          DO FixNameTable(UnitInfo^.Variables.Items[t],l);
     IF UnitInfo^.Objects<>NIL THEN
       FOR t:=0 TO UnitInfo^.Objects.Count-1
          DO FixNameTable(UnitInfo^.Objects.Items[t],l);
     IF UnitInfo^.Constants<>NIL THEN
       FOR t:=0 TO UnitInfo^.Constants.Count-1
          DO FixNameTable(UnitInfo^.Constants.Items[t],l);
     IF UnitInfo^.Procedures<>NIL THEN
       FOR t:=0 TO UnitInfo^.Procedures.Count-1
          DO FixNameTable(UnitInfo^.Procedures.Items[t],l);
END;


PROCEDURE TBrowserInfo.FreeData;

   PROCEDURE FreeList(List:TList);
   VAR
      Info:PBrowseInfo;
      t:LONGINT;
   BEGIN
        IF List=NIL THEN exit;
        FOR t:=0 TO List.Count-1 DO
        BEGIN
             Info:=List[t];
             IF Info^.NestedInfo<>NIL THEN FreeList(Info^.NestedInfo);
             Dispose(Info);
        END;
        List.Destroy;
   END;

VAR
   aUnit:PBrowseUnits;
   t:LONGINT;
BEGIN
     DataAvailable := FALSE;

     DestroySortedGlobalsList;
     DestroySortedUnitsList;
     DestroySortedObjectsList;

     IF Units <> NIL THEN
     BEGIN
          FOR t:=0 TO Units.Count-1 DO
          BEGIN
               aUnit:=Units[t];

               FreeList(aUnit^.Types);
               FreeList(aUnit^.Variables);
               FreeList(aUnit^.Objects);
               FreeList(aUnit^.Constants);
               FreeList(aUnit^.Procedures);
               IF aUnit^.NameTableSize>0
               THEN FreeMem(aUnit^.NameTable,aUnit^.NameTableSize);
               Dispose(aUnit);
          END;

          Units.Clear;
     END;
END;


PROCEDURE TBrowserInfo.UpdateSortedGlobalsList;
VAR  aUnit:PBrowseUnits;
     i:LONGINT;
BEGIN
     IF SortedGlobals = NIL THEN
     BEGIN
          SortedGlobals.Create;
     END
     ELSE SortedGlobals.Clear;

     IF Units = NIL THEN exit;
     FOR i := 0 to Units.Count-1 DO
     BEGIN
          aUnit := Units.Items[i];
          SortedGlobals.InsertUnitAscending(aUnit);
     END;
END;


PROCEDURE TBrowserInfo.DestroySortedGlobalsList;
BEGIN
     IF SortedGlobals <> NIL THEN SortedGlobals.Destroy;
     SortedGlobals := NIL;
END;


PROCEDURE TBrowserInfo.UpdateSortedUnitsList;
VAR  aUnit:PBrowseUnits;
     i:LONGINT;
BEGIN
     IF SortedUnits = NIL THEN
     BEGIN
          SortedUnits.Create(NIL);
     END
     ELSE SortedUnits.Clear;

     IF Units = NIL THEN exit;
     SortedUnits.BeginUpdate;
     FOR i := 0 to Units.Count-1 DO
     BEGIN
          aUnit := Units.Items[i];
          SortedUnits.InsertUnitAscending(aUnit);
     END;
     SortedUnits.EndUpdate;
END;


PROCEDURE TBrowserInfo.DestroySortedUnitsList;
BEGIN
     IF SortedUnits <> NIL THEN SortedUnits.Destroy;
     SortedUnits := NIL;
END;


PROCEDURE TBrowserInfo.UpdateSortedObjectsList;
VAR  aUnit:PBrowseUnits;
     aInfo:PBrowseInfo;
     i,j:LONGINT;
BEGIN
     IF SortedObjects = NIL THEN
     BEGIN
          SortedObjects.Create(NIL);
     END
     ELSE SortedObjects.Clear;

     IF Units = NIL THEN exit;
     SortedObjects.BeginUpdate;
     FOR i := 0 to Units.Count-1 DO
     BEGIN
          aUnit := Units.Items[i];
          IF aUnit^.Objects <> NIL THEN
          FOR j := 0 to aUnit^.Objects.Count-1 DO
          BEGIN
               aInfo := aUnit^.Objects.Items[j];
               SortedObjects.InsertParentAscending(aInfo);
          END;
     END;
     SortedObjects.EndUpdate;
END;


PROCEDURE TBrowserInfo.DestroySortedObjectsList;
BEGIN
     IF SortedObjects <> NIL THEN SortedObjects.Destroy;
     SortedObjects := NIL;
END;

{ --------------------------------------------------------------------------------- }

PROCEDURE TTreeList.IndexError;
BEGIN
     Raise ETreeIndexError.Create('Invalid tree list index');
END;


PROCEDURE TTreeList.NodeError;
BEGIN
     Raise ETreeNodeError.Create('Invalid tree node (NIL)');
END;


CONSTRUCTOR TTreeList.Create(AOwner:TComponent);
BEGIN
     FNodeClass := TTreeNode;

     Inherited Create(AOwner);

     FUpdateCount := 0;
     FRootNode := NIL;
     FGoodNode := NIL;
END;


PROCEDURE TTreeList.InitRoot;
BEGIN
     FRootNode := FNodeClass.Create(SELF);
     FRootNode.FData := NIL;
     FRootNode.FParent := NIL;
     FGoodNode := FRootNode;
END;


DESTRUCTOR TTreeList.Destroy;
BEGIN
     Clear;
     Inherited Destroy;
END;


FUNCTION TTreeList.AddObjectNode(Node:TTreeNode;Data:POINTER):TTreeNode;
BEGIN
     IF Node <> NIL THEN
     BEGIN
          IF Node = FRootNode THEN Result := AddChildObjectNode(Node,Data)
          ELSE Result := AttachNode(Node,Data,oaAdd);
     END
     ELSE NodeError;
END;


FUNCTION TTreeList.AddChildObjectNode(Node:TTreeNode;Data:POINTER):TTreeNode;
BEGIN
     IF Node <> NIL THEN
     BEGIN
          Result := AttachNode(Node,Data,oaAddChild);
     END
     ELSE NodeError;
END;


FUNCTION TTreeList.InsertObjectNode(Node:TTreeNode;Data:POINTER):TTreeNode;
BEGIN
     IF Node <> NIL THEN
     BEGIN
          IF Node = FRootNode THEN Result := AddChildObjectNode(Node,Data)
          ELSE Result := AttachNode(Node,Data,oaInsert);
     END
     ELSE NodeError;
END;


PROCEDURE TTreeList.DeleteNode(Node:TTreeNode);
BEGIN
     IF Node <> NIL THEN
     BEGIN
          IF Node <> FRootNode THEN Node.Destroy
          ELSE Clear;
     END
     ELSE NodeError;
END;


FUNCTION TTreeList.AttachNode(Node:TTreeNode;Data:POINTER;Mode:TAttachMode):TTreeNode;
VAR  NewNode:TTreeNode;
BEGIN
     IF Node = NIL THEN NodeError;

     IF FRootNode = NIL THEN InitRoot;

     NewNode := FNodeClass.Create(SELF);
     NewNode.Data := Data;

     CASE Mode OF
       oaAddChild: Node.AddNode(NewNode);
       oaAdd:      Node.Parent.AddNode(NewNode);
       oaInsert:   Node.Parent.InsertNode(Node,NewNode);
     END;
     Result := NewNode;
END;


PROCEDURE TTreeList.Clear;
BEGIN
     IF FRootNode <> NIL THEN FRootNode.Destroy;
     FRootNode := NIL;
     FGoodNode := NIL;
END;


PROCEDURE TTreeList.BeginUpdate;
BEGIN
     inc(FUpdateCount);
END;


PROCEDURE TTreeList.EndUpdate;
BEGIN
     dec(FUpdateCount);
END;


FUNCTION TTreeList.GetRootNode:TTreeNode;
BEGIN
     IF FRootNode = NIL THEN InitRoot;
     Result := FRootNode;
END;


///////////////////////////////////////////////////////////////////////////


CONSTRUCTOR TTreeNode.Create(Owner:TTreeList);
BEGIN
     Inherited Create;

     IF not (Owner IS TTreeList) THEN
     BEGIN
          Raise ETreeListError.Create('Invalid tree node Parent');
     END;

     FTreeList := TTreeList(Owner);
END;


FUNCTION TTreeNode.GetNode(idx:LONGINT):TTreeNode;
BEGIN
     Result := FSubNodes.Items[idx];
END;


FUNCTION TTreeNode.GetNodeCount;
BEGIN
     IF FSubNodes <> NIL THEN Result := FSubNodes.Count
     ELSE Result := 0;
END;


FUNCTION TTReeNode.GetRootNode:TTreeNode;
BEGIN
     Result := FTreeList.FRootNode;
END;


FUNCTION TTreeNode.HasChildren:BOOLEAN;
BEGIN
     Result := GetNodeCount > 0;
END;


FUNCTION TTreeNode.GetLevel:LONGINT;
BEGIN
     IF SELF = RootNode THEN Result := 0
     ELSE Result := Parent.GetLevel + 1;
END;


FUNCTION TTreeNode.GetList:TList;
BEGIN
     IF FSubNodes = NIL THEN FSubNodes.Create;
     Result := FSubNodes;
END;


FUNCTION TTreeNode.InsertNode(OldNode,NewNode:TTreeNode):LONGINT;
VAR  i:LONGINT;
BEGIN
     NewNode.FParent := SELF;

     i := List.IndexOf(OldNode);
     List.Insert(i, NewNode);

     Result := InvalidIndex;
END;


FUNCTION TTreeNode.AddNode(NewNode:TTreeNode):LONGINT;
BEGIN
     NewNode.FParent := SELF;

     List.Add(NewNode);

     Result := InvalidIndex;
END;


PROCEDURE TTreeNode.Clear;
VAR  t:LONGINT;
BEGIN
     IF FSubNodes = NIL THEN exit;
     FOR t := FSubNodes.Count-1 DOWNTO 0 DO
     BEGIN
          Items[t].FParent := NIL;
          Items[t].Destroy;
     END;

     FSubNodes.Destroy;
     FSubNodes := NIL;
END;


DESTRUCTOR TTreeNode.Destroy;
BEGIN
     Clear;

     IF SELF <> RootNode THEN
     BEGIN
          IF FParent <> NIL THEN
            IF Parent.FSubNodes <> NIL THEN Parent.FSubNodes.Remove(SELF);
     END;

     Inherited Destroy;
END;

BEGIN
     InitBrowserProc := @InitBrowser;
     UpdateBrowserInfoProc := @UpdateBrowserInfo;
     GetBrowserInfoProc := @GetBrowserInfo;

     BrowserInfo.Create;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  05-Dec-02  WD         Unit-Header-Check: Statt SPU31 wird SPU40 verwendet
  09-Dec-02  WD         Einbau der Unit: uExtension
  26-Sep-04  WD         Die Komponente TreeList in diese Unit eingebaut.

}

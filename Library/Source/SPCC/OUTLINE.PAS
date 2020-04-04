
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit OutLine;

Interface

{$IFDEF OS2}
Uses Os2Def,PmWin,PmStdDlg;
{$ENDIF}

{$IFDEF Win32}
Uses winbase, WinDef,WinUser,WinGDI,CommCtrl;
{$ENDIF}

Uses Messages,SysUtils,Color,Classes,Forms,Graphics,
     uList,
     uString;


Const
    InvalidIndex = {MaxLongInt;} -1;
    tab = Chr(9);

Type
    TAttachMode = (oaAdd, oaAddChild, oaInsert);


Type
    EOutlineError=Class(Exception);
    EOutlineNodeError=Class(EOutlineError);
    EOutlineIndexError=Class(EOutlineError);

    TOutline=Class;
    TOutlineNode=Class;

    POutlineRecord=^TOutlineRecord;
    TOutlineRecord=Record
         {$IFDEF OS2}
         RecordCore:RecordCore;
         {$ENDIF}
         {$IFDEF Win32}
         RecordCore:TV_ITEM;
         {$ENDIF}
         Node:TOutlineNode;  {Extra Data}
    End;


    TOutlineNode=Class
      Private
         FCaption:PChar;
         FData:Pointer;
         FIndex:LongInt;
         FExpanded:Boolean;
         FParent:TOutlineNode;
         FOutline:TOutline;
         FSubNodes:TList;
         FPictureLeaf:TBitmap;
         FPictureOpen:TBitmap;
         FPictureClosed:TBitmap;
         Function GetCaption:String;
         Procedure SetCaption(NewCaption:String);
         Function Index2Node(idx:LongInt):TOutlineNode;
         Function GetNode(idx:LongInt):TOutlineNode;
         Function GetNodeCount:LongInt;
         Function InsertNode(OldNode,NewNode:TOutlineNode):LongInt;
         Function AddNode(NewNode:TOutlineNode):LongInt;
         Procedure Setup(RecordOrder:Pointer);
         Function HasChildren:Boolean;
         Function GetLastIndex:LongInt;
         Function GetTopItem:LongInt;
         Function ReIndex(idx,Max:LongInt):LongInt;
         Function HasVisibleParent:Boolean;
         Function GetVisibleParent:TOutlineNode;
         Function GetFullPath:String;
         Function GetLevel:LongInt;
         Function GetList:TList;
         Procedure SetLastValidIndex;
         Function GetDataItem(Value:Pointer):LongInt;
         Function GetTextItem(Const Value:String):LongInt;
         Procedure ClearSubNodes;
         Procedure SetExpanded(Value:Boolean);
         Procedure UpdatePicture;
         Procedure UpdateChildPictures;
         Procedure SetPictureLeaf(NewBitmap:TBitmap);
         Procedure SetPictureOpen(NewBitmap:TBitmap);
         Procedure SetPictureClosed(NewBitmap:TBitmap);
         Function GetItemRect:TRect;
      Protected
         Constructor Create(Owner:TOutline);
         Property OutLine:TOutline Read FOutline;
         Property List:TList Read GetList;
      Public
         FTreeRec:POutlineRecord;
         Property Items[Index:LongInt]:TOutlineNode Read GetNode;
         Property ItemCount:LongInt Read GetNodeCount;
         Destructor Destroy;Override;
         Procedure FullExpand;
         Procedure FullCollapse;
         Procedure Expand;
         Procedure Collapse;
         Procedure Clear;
         Function GetFirstChild:LongInt;
         Function GetLastChild:LongInt;
         Function GetNextChild(Value:LongInt):LongInt;
         Function GetPrevChild(Value:LongInt):LongInt;
         Property Text:String Read GetCaption Write SetCaption;
         Property Data:Pointer Read FData Write FData;
         Property Parent:TOutlineNode Read FParent;
         Property Index:LongInt Read FIndex;
         Property IsVisible:Boolean Read HasVisibleParent;
         Property HasItems:Boolean Read HasChildren;
         Property Level:LongInt Read GetLevel;
         Property Expanded:Boolean Read FExpanded Write SetExpanded;
         Property FullPath:String Read GetFullPath;
         Property TopItem:LongInt Read GetTopItem;
         Property PictureLeaf:TBitmap Read FPictureLeaf Write SetPictureLeaf;
         Property PictureClosed:TBitmap Read FPictureClosed Write SetPictureClosed;
         Property PictureOpen:TBitmap Read FPictureOpen Write SetPictureOpen;
         Property ItemRect:TRect read GetItemRect;
    End;
    TOutlineNodeClass = Class Of TOutlineNode;


{$M+}
    TOutLineItemFocusEvent=Procedure(Sender:TObject;Index:LongInt) Of Object;
    TOutLineItemSelectEvent=Procedure(Sender:TObject;Index:LongInt) Of Object;
    TOutlineChangeEvent=Procedure(Sender:TObject;Index:LongInt) Of Object;
{$M-}

    TOutline=Class(TControl)
      Private
         FLines:TStrings;
         FShowDragRects:Boolean;
         FDragRectValid:Boolean;
         FDragRect:TRect;
         FDragSelected:TOutlineNode;
         FInitLines:TStringList;
         FNodeClass:TOutlineNodeClass;
         FRootNode:TOutlineNode;
         FGoodNode:TOutlineNode;
         FUpdateCount:LongInt;
         FSeparator:String;
         FCurItem:TOutlineNode;
         FStrings:TStrings;
         FBorderStyle:TBorderStyle;
         FPictureList:TBitmapList;
         FPictureOpen:TBitmap;
         FPictureClosed:TBitmap;
         FPictureLeaf:TBitmap;
         FInitNodes:TList;
         FPlusMinusSize:TSize;
         FPictureSize:TSize;
         FShowTreeLines:Boolean;
         FShowPlusMinus:Boolean;
         FTreeLineWidth:LongInt;
         FTreeIndent:LongInt;
         FLineSpacing:LongInt;
         FIndexInsert:Boolean;
         FDragging:Boolean;
         FFocusNode:TOutlineNode;
         FPopupPos:TPoint;
         {$IFDEF Win32}
         FHim:HIMAGELIST;
         FSelItem:Pointer;
         {$ENDIF}
         FOnExpand:TOutlineChangeEvent;
         FOnCollapse:TOutlineChangeEvent;
         FOnItemFocus:TOutLineItemFocusEvent;
         FOnItemSelect:TOutLineItemSelectEvent;
         FOnClick:TNotifyEvent;
         FChangeLock:Boolean;
         {Martin}ProcessDestroyWnd : boolean;
         {$IFDEF OS2}
         Procedure WMPaint(Var Msg:TMessage);Message WM_PAINT;
         {$ENDIF}
         Function AddPicture(NewBitmap:TBitmap):TBitmap;
         Procedure SetBorderStyle(NewBorder:TBorderStyle);
         Procedure SetPlusMinusSize(NewSize:TSize);
         Procedure SetPictureSize(NewSize:TSize);
         Procedure UpdateNode(Node:TOutlineNode);
         Procedure SetCnrInfo;
         Procedure SetShowTreeLines(NewValue:Boolean);
         Procedure SetShowPlusMinus(NewValue:Boolean);
         Procedure SetTreeLineWidth(NewValue:LongInt);
         Procedure SetTreeIndent(Value:LongInt);
         Procedure SetLineSpacing(Value:LongInt);
         Procedure SetupTree;
         Procedure SetupImageList;
         Procedure SetupSubNodes(Node:TOutlineNode);
         Function GetSelectedNode:TOutlineNode;
         Procedure SetSelectedNode(NewSelected:TOutlineNode);
         Function GetSelectedItem:LongInt;
         Procedure SetSelectedItem(NewSelected:LongInt);
         Function GetPictureClosed:TBitmap;
         Procedure SetPictureClosed(NewBitmap:TBitmap);
         Function GetPictureOpen:TBitmap;
         Procedure SetPictureOpen(NewBitmap:TBitmap);
         Function GetPictureLeaf:TBitmap;
         Procedure SetPictureLeaf(NewBitmap:TBitmap);
         Function Attach(idx:LongInt;Const Text:String;Data:Pointer;Mode:TAttachMode):LongInt;
         Function Get(idx:LongInt):TOutlineNode;
         Function GetItemCount:LongInt;
         Procedure SetGoodNode(Node:TOutlineNode);
         Function GetLines:TStrings;
         Procedure SetLines(AStrings:TStrings);
         Procedure DrawDragRect;
      Protected
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure SetupComponent;Override;
         Procedure Click;Virtual;
         Procedure SetupShow;Override;
         Procedure DestroyWnd;Override;
         Procedure ParentNotification(Var Msg:TMessage);Override;
         Procedure ItemFocus(Index:LongInt);Virtual;
         Procedure ItemSelect(Index:LongInt);Virtual;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Function AttachNode(Node:TOutlineNode;Const Text:String;Data:Pointer;Mode:TAttachMode):TOutlineNode;
         Procedure IndexError;Virtual;
         Procedure NodeError;Virtual; 
         Procedure ItemChanged(Var Msg:TMessage;Expanded:Boolean);Virtual;
         Procedure Expand(Index:LongInt);Virtual;
         Procedure Collapse(Index:LongInt);Virtual;
         Procedure DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:Boolean);Override;
         Procedure DragDrop(Source:TObject;X,Y:LongInt);Override;
      Public
         Destructor Destroy;Override;
         procedure ShowItem (ShowItemIndex : longint);{Martin}
         Procedure BeginUpdate;
         Procedure EndUpdate;
         Function Add(Index:LongInt;Const Text:String):LongInt;
         Function AddObject(Index:LongInt;Const Text:String;Data:Pointer):LongInt;
         Function AddChild(Index:LongInt;Const Text:String):LongInt;
         Function AddChildObject(Index:LongInt;Const Text:String;Data:Pointer):LongInt;
         Function Insert(Index:LongInt;Const Text:String):LongInt;
         Function InsertObject(Index:LongInt;Const Text:String;Data:Pointer):LongInt;
         Procedure Delete(Index:LongInt);
         Procedure FullExpand;
         Procedure FullCollapse;
         Function GetDataItem(Value:Pointer):LongInt;
         Function GetTextItem(Const Value:String):LongInt;
         Procedure Clear;
         Function NodeFromPoint(pt:TPoint):TOutlineNode;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property NodeClass:TOutlineNodeClass Read FNodeClass Write FNodeClass;
         Property SelectedNode:TOutlineNode Read GetSelectedNode Write SetSelectedNode;
         Property SelectedItem:LongInt Read GetSelectedItem Write SetSelectedItem;
         Property Items[Index:LongInt]:TOutlineNode Read Get; Default;
         Property ItemCount:LongInt Read GetItemCount;
         Property ItemSeparator:String Read FSeparator Write FSeparator;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property BorderStyle:TBorderStyle Read FBorderStyle Write SetBorderStyle;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property Lines:TStrings Read GetLines Write SetLines;
         Property LineSpacing:LongInt Read FLineSpacing Write SetLineSpacing;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PictureClosed:TBitmap Read GetPictureClosed Write SetPictureClosed;
         Property PictureLeaf:TBitmap Read GetPictureLeaf Write SetPictureLeaf;
         Property PictureOpen:TBitmap Read GetPictureOpen Write SetPictureOpen;
         Property PictureSize:TSize Read FPictureSize Write SetPictureSize;
         Property PlusMinusSize:TSize Read FPlusMinusSize Write SetPlusMinusSize;
         Property PopupMenu;
         Property ShowDragRects:Boolean Read FShowDragRects Write FShowDragRects;
         Property ShowHint;
         Property ShowPlusMinus:Boolean Read FShowPlusMinus Write SetShowPlusMinus;
         Property ShowTreeLines:Boolean Read FShowTreeLines Write SetShowTreeLines;
         Property TabOrder;
         Property TabStop;
         Property TreeIndent:LongInt Read FTreeIndent Write SetTreeIndent;
         Property TreeLineWidth:LongInt Read FTreeLineWidth Write SetTreeLineWidth;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick:TNotifyEvent Read FOnClick Write FOnClick;
         Property OnCollapse:TOutlineChangeEvent Read FOnCollapse Write FOnCollapse;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnExpand:TOutlineChangeEvent Read FOnExpand Write FOnExpand;
         Property OnFontChange;
         Property OnItemFocus:TOutLineItemFocusEvent Read FOnItemFocus Write FOnItemFocus;
         Property OnItemSelect:TOutLineItemSelectEvent Read FOnItemSelect Write FOnItemSelect;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


Function InsertOutline(parent:TControl;Left,Bottom,Width,Height:LongInt;Hint:String):TOutline;


Implementation


Function InsertOutline(parent:TControl;Left,Bottom,Width,Height:LongInt;Hint:String):TOutline;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.TabStop := True;
     Result.Hint := Hint;
     Result.parent := parent;
End;

Type
{$IFDEF OS2}
    pRecordOrder=PRecordCore;
{$ENDIF}
{$IFDEF Win32}
    pRecordOrder=POutlineRecord;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TOutlineBitmap Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TOutlineBitmap=Class(TBitmap)
      {$IFDEF Win32}
      Private
         FHimlIndex:LongInt;
      Private
         Function CreateBitmapFromClass:LongWord;
      {$ENDIF}
    End;


{$IFDEF Win32}
Function TOutlineBitmap.CreateBitmapFromClass:LongWord;
Begin
     Result := CopyImage(Handle,IMAGE_BITMAP,Width,Height,LR_COPYRETURNORG);
End;
{$ENDIF}


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TOutlineNode Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF Win32}
Const
    CMA_FIRST:LongWord=0;
{$ENDIF}


Procedure SetupNode(Node:TOutlineNode);
Begin
     {$IFDEF OS2}
     Node.FTreeRec^.RecordCore.pszTree := Node.FCaption;
     {$ENDIF}
     {$IFDEF Win32}
     Node.FTreeRec^.RecordCore.Mask := TVIF_TEXT Or TVIF_PARAM;
     Node.FTreeRec^.RecordCore.pszText := Node.FCaption;
     If Node.FCaption <> Nil
     Then Node.FTreeRec^.RecordCore.cchTextMax := Length(Node.FCaption^)+1
     Else Node.FTreeRec^.RecordCore.cchTextMax := 0;
     {$ENDIF}

     Node.UpdatePicture;
End;


Procedure RemoveRecord(Node:TOutlineNode; Update:Boolean);
Var  TreeHandle:LongWord;
     AParent:TOutlineNode;

{$IFDEF OS2}
Flags:LongWord;
{$ENDIF}

Begin
     If Node = Nil Then Exit;
     If Node.FTreeRec = Nil Then Exit;

     TreeHandle := Node.FOutline.Handle;
     {$IFDEF OS2}
     If Node.FTreeRec^.RecordCore.pTreeItemDesc <> Nil
       Then Dispose(Node.FTreeRec^.RecordCore.pTreeItemDesc);
     {$ENDIF}

     If TreeHandle <> 0 Then
     Begin
          {$IFDEF OS2}
          Flags := CMA_FREE;
          If Update Then Flags := Flags Or CMA_INVALIDATE;
          WinSendMsg(TreeHandle,CM_REMOVERECORD,LongWord(@Node.FTreeRec),
                     MPFROM2SHORT(1,Flags));
          {$ENDIF}
          {$IFDEF Win32}
          SendMessage(TreeHandle,TVM_DELETEITEM,0,
                      LongWord(Node.FTreeRec^.RecordCore.hItem));
          {$ENDIF}
     End;

     {$IFDEF Win32}
     Dispose(Node.FTreeRec);
     {$ENDIF}
     Node.FTreeRec := Nil;

     {Update parent Bitmap}
     AParent := Node.parent;
     If AParent <> Nil Then
       If AParent <> Node.FOutline.FRootNode Then
         If AParent.ItemCount = 1 Then AParent.UpdatePicture; {Node Is the Last}
End;


Procedure InsertRecord(NewNode:TOutlineNode; AParentRecord:POutlineRecord;
                       RecordOrder:Pointer);
Var  TreeHandle:LongWord;
     Tree:TOutline;
     AParent:TOutlineNode;
     {$IFDEF OS2}
     aRecordInsert:RECORDINSERT;
     {$ENDIF}
     {$IFDEF Win32}
     tvins:TV_INSERTSTRUCT;
     {$ENDIF}
Begin
     If NewNode.FTreeRec=Nil Then exit;
     NewNode.FTreeRec^.Node := NewNode;
     {specify where To Insert}
     Tree := NewNode.FOutline;
     TreeHandle := Tree.Handle;

     {$IFDEF OS2}
     aRecordInsert.cb := SizeOf(RECORDINSERT);
     aRecordInsert.pRecordOrder := RecordOrder;
     aRecordInsert.ZOrder := CMA_TOP;
     aRecordInsert.cRecordsInsert := 1;     //Number Of records
     aRecordInsert.fInvalidateRecord := 1;  //Invalidate records
     aRecordInsert.pRecordParent := Pointer(AParentRecord);

     {Insert Record}
     WinSendMsg(TreeHandle,CM_INSERTRECORD,
                LongWord(NewNode.FTreeRec),LongWord(@aRecordInsert));

     {Expand Status}
     If NewNode.FExpanded
     Then WinSendMsg(TreeHandle,CM_EXPANDTREE, LongWord(NewNode.FTreeRec),0)
     Else WinSendMsg(TreeHandle,CM_COLLAPSETREE, LongWord(NewNode.FTreeRec),0);
     {$ENDIF}

     {$IFDEF Win32}
     {specify where To Insert}
     FillChar(tvins,SizeOf(tvins),0);
     NewNode.FTreeRec^.RecordCore.LParam:=LParam(NewNode);

     tvins.Item:=NewNode.FTreeRec^.RecordCore;
     If ((RecordOrder=Nil)Or(LongWord(RecordOrder)=CMA_FIRST)) Then tvins.hInsertAfter:=TVI_FIRST
     Else tvins.hInsertAfter:=POutlineRecord(RecordOrder)^.RecordCore.hItem;
     If AParentRecord=Nil Then tvins.hParent:=TVI_ROOT
     Else tvins.hParent:=AParentRecord^.RecordCore.hItem;
     NewNode.FTreeRec^.RecordCore.hItem:=
       HTREEITEM(SendMessage(TreeHandle,TVM_INSERTITEM,0,LongWord(@tvins)));

     {Expand Status}
     If NewNode.FExpanded
     Then SendMessage(TreeHandle,TVM_EXPAND,TVE_EXPAND,
                      LongWord(NewNode.FTreeRec^.RecordCore.hItem))
     Else SendMessage(TreeHandle,TVM_EXPAND,TVE_COLLAPSE,
                      LongWord(NewNode.FTreeRec^.RecordCore.hItem));
     {$ENDIF}

     {Update parent Bitmap}
     AParent := NewNode.parent;
     If AParent <> Nil Then
       If AParent <> Tree.FRootNode Then
         If AParent.ItemCount = 1 Then AParent.UpdatePicture; {NewNode Is the 1st}
End;


Procedure AllocateRecord(Handle:LongWord;Var porec:POutlineRecord);
Begin
     //allocate Memory
     {$IFDEF OS2}
     porec:=Pointer(WinSendMsg(Handle,
                               CM_ALLOCRECORD,
                               {additional Info For OutlineRecord}
                               SizeOf(TOutlineRecord)-SizeOf(RecordCore),
                               1));          {allocate one Record}
     {$ENDIF}
     {$IFDEF Win32}
     New(porec);
     {$ENDIF}
End;


Constructor TOutlineNode.Create(Owner:TOutline);
Begin
     Inherited Create;

     If Owner Is TOutline Then FOutline := TOutline(Owner)
     Else Raise EOutlineError.Create(LoadNLSStr(SInvalidOutlineNodeOwner));
End;


Function TOutlineNode.GetCaption:String;
Begin
     If FCaption=Nil Then Result:=''
     Else Result:=FCaption^;
End;


Procedure TOutlineNode.SetCaption(NewCaption:String);
Begin
     If NewCaption = Text Then Exit;

     If FCaption <> Nil Then FreeMem(FCaption,Length(FCaption^)+1);
     If NewCaption <> '' Then
     Begin
          GetMem(FCaption, Length(NewCaption)+1);
          FCaption^ := NewCaption;
     End
     Else FCaption := Nil;

     {$IFDEF OS2}
     If FTreeRec <> Nil Then FTreeRec^.RecordCore.pszTree := FCaption;
     {$ENDIF}
     {$IFDEF Win32}
     If FTreeRec <> Nil Then
     Begin
          FTreeRec^.RecordCore.pszText := FCaption;
          If FCaption <> Nil
          Then FTreeRec^.RecordCore.cchTextMax := Length(FCaption^)+1
          Else FTreeRec^.RecordCore.cchTextMax := 0;
     End;
     {$ENDIF}

     FOutline.UpdateNode(Self);
End;


Procedure TOutlineNode.UpdatePicture;
Var  Picture:TBitmap;
     PictureHandle:LongWord;
Begin
     PictureHandle := 0;

     If ItemCount > 0 Then
     Begin
          If Expanded Then
          Begin
               If FPictureOpen <> Nil Then Picture := FPictureOpen
               Else Picture := FOutline.FPictureOpen;

               {$IFDEF OS2}
               If Picture <> Nil Then PictureHandle := Picture.Handle;

               With FTreeRec^.RecordCore Do
               Begin
                    If PictureHandle = 0 Then
                    Begin
                         If pTreeItemDesc <> Nil Then Dispose(pTreeItemDesc);
                         pTreeItemDesc := Nil;
                    End
                    Else
                    Begin
                         If pTreeItemDesc = Nil Then New(pTreeItemDesc);
                         pTreeItemDesc^.hbmExpanded := PictureHandle;
                    End;
               End;
               {$ENDIF}
          End
          Else
          Begin
               If FPictureClosed <> Nil Then Picture := FPictureClosed
               Else Picture := FOutline.FPictureClosed;

               {$IFDEF OS2}
               If Picture <> Nil Then PictureHandle := Picture.Handle;

               With FTreeRec^.RecordCore Do
               Begin
                    If PictureHandle = 0 Then
                    Begin
                         If pTreeItemDesc <> Nil Then Dispose(pTreeItemDesc);
                         pTreeItemDesc := Nil;
                    End
                    Else
                    Begin
                         If pTreeItemDesc = Nil Then New(pTreeItemDesc);
                         pTreeItemDesc^.hbmCollapsed := PictureHandle;
                    End;
               End;
               {$ENDIF}
          End;
     End
     Else
     Begin
          If FPictureLeaf <> Nil Then Picture := FPictureLeaf
          Else Picture := FOutline.FPictureLeaf;
     End;

     If Picture <> Nil Then PictureHandle := Picture.Handle;

     {$IFDEF OS2}
     FTreeRec^.RecordCore.hbmBitmap := PictureHandle;
     {$ENDIF}

     {$IFDEF Win32}
     If Picture = Nil Then
     Begin
         FTreeRec^.RecordCore.Mask := FTreeRec^.RecordCore.Mask And not
                                      (TVIF_IMAGE Or TVIF_SELECTEDIMAGE);
         FTreeRec^.RecordCore.iImage := 0;
         FTreeRec^.RecordCore.iSelectedImage := 0;
     End
     Else
     Begin
         FTreeRec^.RecordCore.Mask := FTreeRec^.RecordCore.Mask
                                      Or TVIF_IMAGE Or TVIF_SELECTEDIMAGE;
         FTreeRec^.RecordCore.iImage := TOutlineBitmap(Picture).FHimlIndex;
         FTreeRec^.RecordCore.iSelectedImage := TOutlineBitmap(Picture).FHimlIndex;
     End;
     {$ENDIF}
End;


Procedure TOutlineNode.UpdateChildPictures;
Var  Node:TOutlineNode;
     T:LongInt;
Begin
     If FSubNodes = Nil Then Exit;
     For T := 0 To FSubNodes.Count-1 Do
     Begin
          Node := FSubNodes.Items[T];
          Node.UpdatePicture;
          {$IFDEF WIN32}
          Node.FOutLine.UpdateNode(Node);
          {$ENDIF}
          Node.UpdateChildPictures;
     End;
End;


Procedure TOutlineNode.SetPictureLeaf(NewBitmap:TBitmap);
Begin
     FPictureLeaf := FOutline.AddPicture(NewBitmap);    {Get local Copy}
     If Not HasItems Then
     Begin
          UpdatePicture;
          FOutline.UpdateNode(Self);
     End;
End;


Procedure TOutlineNode.SetPictureOpen(NewBitmap:TBitmap);
Begin
     FPictureOpen := FOutline.AddPicture(NewBitmap);    {Get local Copy}
     If HasItems And Expanded Then
     Begin
          UpdatePicture;
          FOutline.UpdateNode(Self);
     End;
End;


Procedure TOutlineNode.SetPictureClosed(NewBitmap:TBitmap);
Begin
     FPictureClosed := FOutline.AddPicture(NewBitmap);    {Get local Copy}
     If HasItems And Not Expanded Then
     Begin
          UpdatePicture;
          FOutline.UpdateNode(Self);
     End;
End;


Function TOutlineNode.GetNode(idx:LongInt):TOutlineNode;
Begin
     Result := FSubNodes.Items[idx];
End;


Function TOutlineNode.GetNodeCount;
Begin
     If FSubNodes <> Nil Then Result := FSubNodes.Count
     Else Result := 0;
End;


Function TOutlineNode.HasChildren:Boolean;
Begin
     Result := GetNodeCount > 0;
End;


Function TOutlineNode.GetLastIndex:LongInt;
Begin
     If ItemCount = 0 Then Result := Index
     Else Result := TOutlineNode(FSubNodes.Last).GetLastIndex;
End;


Function TOutlineNode.GetTopItem:LongInt;
Var  Node:TOutlineNode;
Begin
     Result := 0;
     Node := Self;
     While Node <> FOutline.FRootNode Do
     Begin
          If Node.parent = FOutline.FRootNode Then Result := Node.Index;
          Node := Node.parent;
     End;
End;


Function TOutlineNode.Index2Node(idx:LongInt):TOutlineNode;
Var  Node:TOutlineNode;
     LastNode:TOutlineNode;
     I:LongInt;
Begin
     If idx = Index Then
     Begin
          Result := Self;
          Exit;
     End;

     {Find Last Node, where Index <= idx}
     LastNode := Nil;
     For I := 0 To ItemCount-1 Do
     Begin
          Node := Items[I];
          If Node.Index = InvalidIndex Then break;
          If Node.Index > idx Then break;
          LastNode := Node;
     End;

     If LastNode <> Nil Then
     Begin
          Result := LastNode.Index2Node(idx);
          Exit;
     End;

     FOutline.indexerror;
End;


Function TOutlineNode.ReIndex(idx,Max:LongInt):LongInt;
Var  Node:TOutlineNode;
     I:LongInt;
Begin
     FIndex := idx;
     FOutline.FGoodNode := Self;

     For I := 0 To ItemCount-1 Do
     Begin
          Node := Items[I];
          idx := Node.ReIndex(idx+1,Max);

          If idx > Max Then                  {Stop reindexing}
          Begin      {Next sibling Of Node gets invalid Index}
               If I < ItemCount-1 Then Items[I+1].FIndex := InvalidIndex;
               break;
          End;
     End;
     Result := idx;
End;


Procedure TOutlineNode.SetLastValidIndex;
Var  NextSibl:TOutlineNode;
     idx:LongInt;
Begin
     idx := parent.FSubNodes.IndexOf(Self);

     If idx < parent.FSubNodes.Count-1 Then NextSibl := parent.Items[idx+1]
     Else NextSibl := Nil;

     If NextSibl <> Nil Then NextSibl.FIndex := InvalidIndex;

     If parent <> FOutline.FRootNode Then parent.SetLastValidIndex;
End;


Function TOutlineNode.HasVisibleParent:Boolean;
Begin
     If parent = FOutline.FRootNode Then Result := True
     Else If Parent<>Nil Then Result := parent.FExpanded And parent.HasVisibleParent
     Else Result:=False;
End;


Function TOutlineNode.GetVisibleParent:TOutlineNode;
Begin
     If IsVisible Then Result := Self
     Else If Parent<>Nil Then Result := parent.GetVisibleParent
     Else Result:=Nil;
End;


Procedure TOutlineNode.SetExpanded(Value:Boolean);
Begin
     If Value = FExpanded Then Exit;

     If Value Then Expand
     Else Collapse;
End;


Function TOutlineNode.GetFullPath:String;
Begin
   If Parent <> Nil Then
   Begin
      If Parent.Parent <> Nil Then
        Result := Parent.GetFullPath + FOutline.FSeparator + Text
      Else
        Result := Text
   End
   Else Result := '';
End;


Procedure TOutlineNode.FullExpand;
Var  Node:TOutlineNode;
     I:LongInt;
Begin
     //FOutline.BeginUpdate;
     For I := 0 To ItemCount-1 Do
     Begin
          Node := Items[I];
          Node.FullExpand;
     End;
     Expand;
     //FOutline.EndUpdate;
End;


Procedure TOutlineNode.FullCollapse;
Var  Node:TOutlineNode;
     I:LongInt;
Begin
     //FOutline.BeginUpdate;
     Collapse;
     For I := 0 To ItemCount-1 Do
     Begin
          Node := Items[I];
          Node.FullCollapse;
     End;
     //FOutline.EndUpdate;
End;


Procedure TOutlineNode.Expand;
Begin
     FExpanded := True;
     FOutline.Expand(FIndex);
     If ItemCount = 0 Then Exit;
     If FTreeRec = Nil Then Exit;
     If FOutline.Handle = 0 Then Exit;

     FOutline.FChangeLock:=True;
     {$IFDEF OS2}
     WinSendMsg(FOutline.Handle,CM_EXPANDTREE,LongWord(FTreeRec),0);
     {$ENDIF}

     {$IFDEF Win32}
     SendMessage(FOutline.Handle,TVM_EXPAND,TVE_EXPAND,LongWord(FTreeRec^.RecordCore.hItem));
     {$ENDIF}

     FOutline.FChangeLock:=False;

     If FTreeRec <> Nil Then UpdatePicture;

     FOutline.UpdateNode(Self);
End;

(*
Procedure TOutlineNode.Expand;
  var
    Offset : longint;
Begin
     FExpanded := True;
     FOutline.Expand(FIndex);
     If ItemCount = 0 Then Exit;
     If FTreeRec = Nil Then Exit;
     If FOutline.Handle = 0 Then Exit;

     FOutline.FChangeLock:=True;
     {Martin}
     {es ist leider nicht besonders genau bei groแen Bumen, warum weiแ ich nicht}
     Offset := (FOutline.Font.Height + FOutline.LineSpacing) * FIndex - (FOutline.Height div 2);
     if Offset < 0 then Offset := 0;
     {$IFDEF OS2}
     {gehe zuerst zum Anfang}
     WinSendMsg(FOutline.Handle, WM_CHAR, MPFROM2SHORT(KC_VIRTUALKEY,0),MPFROM2SHORT(0,VK_HOME));
     {klappe Baum vollstndig auf}
     WinSendMsg(FOutline.Handle,CM_EXPANDTREE,LongWord(FTreeRec),0);
     {verschiebe die Scrollbar um Offset Pixel}
     if Offset > 0 then
       WinSendMsg(FOutline.Handle, CM_SCROLLWINDOW, CMA_VERTICAL, Offset);
     {$ENDIF}

     {$IFDEF Win32}
     SendMessage(FOutline.Handle,TVM_EXPAND,TVE_EXPAND,LongWord(FTreeRec^.RecordCore.hItem));
     //SendMessage(FOutline.Handle,TVM_ENSUREVISIBLE,0,LongWord(FTreeRec^.RecordCore.hItem));
     {$ENDIF}

     FOutline.FChangeLock:=False;
End;
*)

Procedure TOutlineNode.Collapse;
Begin
     FExpanded := False;
     FOutline.Collapse(FIndex);
     If ItemCount = 0 Then Exit;
     If FTreeRec = Nil Then Exit;
     If FOutline.Handle = 0 Then Exit;

     FOutline.FChangeLock:=True;

     {$IFDEF OS2}
     WinSendMsg(FOutline.Handle,CM_COLLAPSETREE,LongWord(FTreeRec),0);
     {$ENDIF}

     {$IFDEF Win32}
     SendMessage(FOutline.Handle,TVM_EXPAND,TVE_COLLAPSE,LongWord(FTreeRec^.RecordCore.hItem));
     {$ENDIF}

     FOutline.FChangeLock:=False;

     If FTreeRec <> Nil Then UpdatePicture;

     FOutline.UpdateNode(Self);
End;


Function TOutlineNode.GetFirstChild:LongInt;
Begin
     Result := InvalidIndex;
     If ItemCount = 0 Then Exit;
     Result := Items[0].Index;
End;


Function TOutlineNode.GetLastChild:LongInt;
Begin
     Result := InvalidIndex;
     If ItemCount = 0 Then Exit;
     Result := Items[ItemCount-1].Index;
End;


Function TOutlineNode.GetNextChild(Value:LongInt):LongInt;
Var  idx:LongInt;
Begin
     Result := InvalidIndex;
     If FSubNodes = Nil Then Exit;

     For idx := 0 To ItemCount - 2 Do  {0,1,2,...,N-2,_not_}
     Begin
          If Items[idx].Index = Value Then
          Begin
               Result := Items[idx + 1].Index;
               Exit;
          End;
     End;
End;


Function TOutlineNode.GetPrevChild(Value:LongInt):LongInt;
Var  idx:LongInt;
Begin
     Result := InvalidIndex;
     If FSubNodes = Nil Then Exit;

     For idx := 1 To ItemCount - 1 Do  {_not_,1,2,...,N-1}
     Begin
          If Items[idx].Index = Value Then
          Begin
               Result := Items[idx + 1].Index;
               Exit;
          End;
     End;
End;


Function TOutlineNode.GetLevel:LongInt;
Begin
     If Self = FOutline.FRootNode Then Result := 0
     Else Result := parent.GetLevel + 1;
End;


Function TOutlineNode.GetList:TList;
Begin
     If FSubNodes = Nil Then FSubNodes.Create;
     Result := FSubNodes;
End;


Function TOutlineNode.InsertNode(OldNode,NewNode:TOutlineNode):LongInt;
Var  RecordOrder:pRecordOrder;
     I:LongInt;
Begin
     NewNode.FParent := Self;

     I := List.IndexOf(OldNode);
     List.Insert(I, NewNode);

     If I > 0 Then RecordOrder := Pointer(TOutlineNode(List.Items[I-1]).FTreeRec)
     Else LongWord(RecordOrder) := CMA_FIRST;

     If FOutline.FIndexInsert Then
     Begin
          NewNode.FIndex := OldNode.Index;
          FOutline.SetGoodNode(NewNode);
     End
     Else NewNode.FIndex := InvalidIndex;
     Result := NewNode.Index;

     NewNode.Setup(RecordOrder);
End;


Function TOutlineNode.AddNode(NewNode:TOutlineNode):LongInt;
Var  PrevNode:TOutlineNode;
     RecordOrder:pRecordOrder;
Begin
     NewNode.FParent := Self;

     If List.Count > 0 Then
     Begin
          PrevNode := TOutlineNode(List.Last);
          RecordOrder := Pointer(PrevNode.FTreeRec);
     End
     Else LongWord(RecordOrder) := CMA_FIRST;

     List.Add(NewNode);

     If FOutline.FIndexInsert Then
     Begin
          FOutline.SetGoodNode(Self);
          {force NewNode And successors have A correct Index}
          ReIndex(Index,MaxLongInt); {Time!}
          Result := NewNode.Index;
     End
     Else Result := InvalidIndex;

     NewNode.Setup(RecordOrder);
End;


Procedure TOutlineNode.Setup(RecordOrder:Pointer);
Var  TreeRec:POutlineRecord;
Begin
     If FOutline.Handle = 0 Then
     Begin
          {Show it With SetupTree}
          FOutline.FInitNodes := FOutline.FRootNode.FSubNodes;
          Exit;
     End;
     If FTreeRec = Nil Then AllocateRecord(FOutline.Handle,FTreeRec);
     SetupNode(Self);

     If parent = FOutline.FRootNode Then TreeRec := Nil
     Else TreeRec := parent.FTreeRec;

     InsertRecord(Self,TreeRec, pRecordOrder(RecordOrder));
     FOutline.SetupSubNodes(Self);
End;


Procedure TOutlineNode.ClearSubNodes;
Var  T:LongInt;
Begin
     If FSubNodes = Nil Then Exit;
     For T := FSubNodes.Count-1 DownTo 0 Do
     Begin
          Items[T].FParent := Nil;
          Items[T].Destroy;
     End;

     FSubNodes.Destroy;
     FSubNodes := Nil;
End;


Procedure TOutlineNode.Clear;
Begin
     FOutline.BeginUpdate;
     ClearSubNodes;
     FOutline.EndUpdate;
End;


Destructor TOutlineNode.Destroy;
Begin
     Clear; {vorher: ClearSubNodes; }

     If Self <> FOutline.FRootNode Then
     Begin
          RemoveRecord(Self, True);

          If FCaption <> Nil Then
          Begin
               FreeMem(FCaption,Length(FCaption^)+1);
               FCaption := Nil;
          End;

          If FParent <> Nil Then
            If FParent.FSubNodes <> Nil Then FParent.FSubNodes.Remove(Self);

          If FOutline.FCurItem = Self
          Then FOutline.FCurItem := FOutline.FRootNode;
     End;

     Inherited Destroy;
End;


Function TOutlineNode.GetDataItem(Value:Pointer):LongInt;
Var  I:LongInt;
     Node:TOutlineNode;
Begin
     If FData = Value Then
     Begin
          Result := FIndex;
          Exit;
     End;

     For I := 0 To ItemCount-1 Do
     Begin
          Node := Items[I];
          Result := Node.GetDataItem(Value);
          If Result > 0 Then Exit;
     End;
     Result := 0;
End;


Function TOutlineNode.GetTextItem(Const Value:String):LongInt;
Var  I:LongInt;
     Node:TOutlineNode;
Begin
     If Text = Value Then
     Begin
          Result := FIndex;
          Exit;
     End;

     For I := 0 To ItemCount-1 Do
     Begin
          Node := Items[I];
          Result := Node.GetTextItem(Value);
          If Result > 0 Then Exit;
     End;
     Result := 0;
End;

Function TOutlineNode.GetItemRect:TRect;
{$IFDEF OS2}
Var RecRect:QUERYRECORDRECT;
{$ENDIF}
Begin
     FillChar(Result,sizeof(TRect),0);
     {$IFDEF OS2}
     RecRect.cb:=sizeof(QUERYRECORDRECT);
     RecRect.pRecord:=@FTreeRec^.RecordCore;
     RecRect.fRightSplitWindow:=0;
     RecRect.fsExtent:=CMA_ICON OR CMA_TEXT;
     WinSendMsg(FOutline.Handle,CM_QUERYRECORDRECT,LongWord(@Result),LongWord(@RecRect));
     {$ENDIF}
     {$IFDEF WIN32}
     //TODO WIN32
     {$ENDIF}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TOutline Class Implementation                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TOutlineStrings=Class(TStrings)
      Private
         OutLine:TOutline;
      Protected
         Function GetCount: LongInt; Override;
         Function Get(Index: LongInt): String; Override;
         Function GetObject(Index: LongInt): TObject; Override;
         Procedure PutObject(Index: LongInt; AObject: TObject); Override;
         Procedure indexerror;
      Public
         Procedure Assign(AStrings:TStrings); Override;
         Function Add(Const S: String): LongInt; Override;
         Procedure Delete(Index: LongInt); Override;
         Procedure Insert(Index: LongInt; Const S: String); Override;
         Procedure Clear; Override;
    End;


Function TOutlineStrings.GetCount:LongInt;
Begin
     Result := OutLine.ItemCount;
End;


Function TOutlineStrings.Get(Index:LongInt):String;
Var  Node:TOutlineNode;
     Level,I:LongInt;
Begin
     Node := OutLine.Items[Index+1];
     Level := Node.Level;
     Result := '';
     For I := 0 To Level-2 Do Result := Result + tab;
     Result := Result + Node.Text;
End;


Function TOutlineStrings.GetObject(Index:LongInt):TObject;
Begin
     Result := TObject(OutLine[Index + 1].Data);
End;


Procedure TOutlineStrings.PutObject(Index:LongInt; AObject:TObject);
Var  Node:TOutlineNode;
Begin
     Node := OutLine[Index + 1];
     Node.Data := Pointer(AObject);
End;


Procedure TOutlineStrings.Assign(AStrings:TStrings);
Begin
     OutLine.BeginUpdate;
     Inherited Assign(AStrings);
     OutLine.EndUpdate;
End;


Function TOutlineStrings.Add(Const S:String):LongInt;
Var  LastNode:TOutlineNode;
     s1:String;
     CountNodes,Level,LastLevel,I:LongInt;
Begin
     {Get Level from S}
     s1 := S;
     Level := 1;
     For I := 1 To Length(S) Do
     Begin
          If s1[1] In [' ',tab] Then
          Begin
               Inc(Level);
               System.Delete(s1,1,1);
          End
          Else break;
     End;
     {Get Last Node With Level-1 To Add A New Child}
     CountNodes := OutLine.ItemCount;
     If CountNodes > 0 Then LastNode := OutLine[CountNodes]
     Else LastNode := OutLine.FRootNode;

     LastLevel := LastNode.Level;
     If (Level - LastLevel > 1) Or (LastNode = OutLine.FRootNode) Then
     Begin
          If Level - LastLevel > 1 Then OutLine.NodeError;
     End
     Else
     Begin
          For I := LastLevel DownTo Level Do
          Begin
               LastNode := LastNode.parent;
               If LastNode = Nil Then OutLine.NodeError;
          End;
     End;

     Result := OutLine.AddChild(LastNode.Index, s1) - 1;
End;


Procedure TOutlineStrings.Delete(Index:LongInt);
Begin
     OutLine.Delete(Index + 1);
End;


Procedure TOutlineStrings.Insert(Index:LongInt;Const S:String);
Begin
     OutLine.Insert(Index + 1, S);
End;


Procedure TOutlineStrings.Clear;
Begin
     OutLine.Clear;
End;


Procedure TOutlineStrings.indexerror;
Begin
     OutLine.indexerror;
End;

/////////////////////////////////////////////////////////////////////////////

Procedure TOutline.SetBorderStyle(NewBorder:TBorderStyle);
Begin
     FBorderStyle := NewBorder;
     {$IFDEF OS2}
     SetCnrInfo;
     Invalidate;
     {$ENDIF}
     {$IFDEF Win32}
     RecreateWnd;
     {$ENDIF}
End;


Function TOutline.AddPicture(NewBitmap:TBitmap):TBitmap;
Var  idx:LongInt;
Begin
     If NewBitmap = Nil Then
     Begin
          Result := Nil;
          Exit;
     End;

     If FPictureList = Nil Then
     Begin
          FPictureList.Create;
          FPictureList.BitmapClass := TOutlineBitmap;
          FPictureList.Duplicates := False;
     End;

     idx := FPictureList.IndexOfOrigin(NewBitmap);
     If idx < 0 Then                                     {Not found}
     Begin
          idx := FPictureList.Add(NewBitmap);  {Create local Bitmap}
          SetupImageList;
     End;
     Result := TBitmap(FPictureList.Bitmaps[idx]);
End;


Procedure TOutline.SetPictureLeaf(NewBitmap:TBitmap);
Begin
     FPictureLeaf := AddPicture(NewBitmap);    {Get local Copy}
     SetCnrInfo;
     FRootNode.UpdateChildPictures;
End;


Procedure TOutline.SetPictureOpen(NewBitmap:TBitmap);
Begin
     FPictureOpen := AddPicture(NewBitmap);    {Get local Copy}
     SetCnrInfo;
     FRootNode.UpdateChildPictures;
End;


Procedure TOutline.SetPictureClosed(NewBitmap:TBitmap);
Begin
     FPictureClosed := AddPicture(NewBitmap);    {Get local Copy}
     SetCnrInfo;
     FRootNode.UpdateChildPictures;
End;


Function TOutline.GetPictureClosed:TBitmap;
Begin
     If FPictureClosed = Nil Then
     Begin
          FPictureClosed := TOutlineBitmap.Create;
          Include(FPictureClosed.ComponentState, csDetail);
     End;
     Result := FPictureClosed;
End;


Function TOutline.GetPictureOpen:TBitmap;
Begin
     If FPictureOpen = Nil Then
     Begin
          FPictureOpen := TOutlineBitmap.Create;
          Include(FPictureOpen.ComponentState, csDetail);
     End;
     Result := FPictureOpen;
End;


Function TOutline.GetPictureLeaf:TBitmap;
Begin
     If FPictureLeaf = Nil Then
     Begin
          FPictureLeaf := TOutlineBitmap.Create;
          Include(FPictureLeaf.ComponentState, csDetail);
     End;
     Result := FPictureLeaf;
End;


Procedure TOutline.GetClassData(Var ClassData:TClassData);
Begin
     Inherited GetClassData(ClassData);

     {$IFDEF OS2}
     ClassData.ClassULong := WC_CONTAINER;
     {$ENDIF}
     {$IFDEF Win32}
     CreateSubClass(ClassData,WC_TREEVIEW);
     {$ENDIF}
End;


Procedure TOutline.DestroyWnd;
Begin
  {Martin}ProcessDestroyWnd := true;
  {Store Tree Items -> Linear List}
  If Handle <> 0 Then
    If FInitLines <> Nil Then 
      FInitLines.Assign(FLines);

  BeginUpdate;
  If FRootNode <> Nil Then 
    FRootNode.ClearSubNodes;
  EndUpdate;

  Inherited DestroyWnd;
  {Martin}ProcessDestroyWnd := false;
End;


Destructor TOutline.Destroy;
Begin
     FLines.Destroy;
     FLines := Nil;
     FInitLines.Destroy;
     FInitLines := Nil;
     FRootNode.Destroy;
     FRootNode := Nil;

     If FPictureList <> Nil Then
     Begin
          FPictureList.Destroy;  {Destroy local Bitmaps}
          FPictureList := Nil;
     End;

     {$IFDEF Win32}
     If FHim <> Nil Then ImageList_Destroy(FHim);
     FHim := Nil;
     {$ENDIF}

     Inherited Destroy;
End;


Procedure TOutline.SetupComponent;
Begin
     Inherited SetupComponent;

     Ownerdraw := False;
     {Martin}ProcessDestroyWnd := false;
     FRootNode.Create(Self);
     FRootNode.FIndex := 0;
     FRootNode.FParent := Nil;
     FGoodNode := FRootNode;
     FCurItem := FRootNode;
     FUpdateCount := 0;
     FSeparator := '\';
     FNodeClass := TOutlineNode;

     FLines := TOutlineStrings.Create;
     TOutlineStrings(FLines).OutLine := Self;
     FInitLines.Create;

     Height:=100;
     Width:=100;
     color:=clWindow;
     ParentPenColor:=False;
     ParentColor:=False;
     FBorderStyle:=bsSingle;
     FPlusMinusSize.CX:=16;
     FPlusMinusSize.CY:=16;
     FPictureSize.CX:=20;
     FPictureSize.CY:=20;
     FTreeLineWidth:=1;
     FShowTreeLines:=True;
     FShowPlusMinus:=True;
     FTreeIndent:=20;
     FLineSpacing:=0;
End;

Procedure TOutline.SetupShow;
Begin
     Inherited SetupShow;
     CreateCanvas;

     {Get information from StringList If available, Else Use invisible Tree}
     If FInitLines.Count > 0 Then
     Begin
          FLines.Assign(FInitLines);
          FInitLines.Clear;
     End;

     If Handle=0 Then Exit;
     {Set Options}
     SetCnrInfo;
     SetupImageList;
     SetupTree;
End;

{$IFDEF OS2}
Procedure TOutline.WMPaint(Var Msg:TMessage);
Var  rc1,rcupdate:TRect;
Begin
     If FBorderStyle = bsSingle Then
     Begin {Exclude border from Redraw area}
          rc1 := ClientRect;
          {????????????+-1}
          Inc(rc1.Right);
          Inc(rc1.Top);
          InflateRect(rc1,-2,-2);

          WinQueryUpdateRect(Handle,RECTL(rcupdate));
          WinValidateRect(Handle,RECTL(rcupdate),False);
          rcupdate := IntersectRect(rcupdate,rc1);
          WinInvalidateRect(Handle,RECTL(rcupdate),False);
     End;

     DefaultHandler(Msg);       {Do Default Action}

     If FBorderStyle = bsSingle Then
     Begin
          rc1 := ClientRect;
          DrawSystemBorder(Self,rc1,FBorderStyle); {overpaint Text ON the border}
     End;
End;
{$ENDIF}


Procedure TOutline.SetShowTreeLines(NewValue:Boolean);
Begin
     FShowTreeLines:=NewValue;
     SetCnrInfo;
End;


Procedure TOutline.SetShowPlusMinus(NewValue:Boolean);
Begin
     FShowPlusMinus:=NewValue;
     SetCnrInfo;
End;


Procedure TOutline.SetTreeLineWidth(NewValue:LongInt);
Begin
     FTreeLineWidth:=NewValue;
     SetCnrInfo;
End;


Procedure TOutline.SetPlusMinusSize(NewSize:TSize);
Begin
     FPlusMinusSize:=NewSize;
     SetCnrInfo;
End;


Procedure TOutline.SetPictureSize(NewSize:TSize);
Begin
     FPictureSize:=NewSize;
     SetCnrInfo;
End;


Procedure TOutline.SetTreeIndent(Value:LongInt);
Begin
     FTreeIndent:=Value;
     SetCnrInfo;
End;


Procedure TOutline.SetLineSpacing(Value:LongInt);
Begin
     FLineSpacing:=Value;
     SetCnrInfo;
End;


Procedure TOutline.SetCnrInfo;
{$IFDEF OS2}
Var acnrInfo:CNRINFO;
    Flags:LongWord;
{$ENDIF}
{$IFDEF Win32}
Var WinStyle:LongWord;
{$ENDIF}
Begin
     If Handle = 0 Then Exit;

     {$IFDEF OS2}
     FillChar(acnrInfo,SizeOf(CNRINFO),0);
     Flags:=CMA_FLWINDOWATTR;

     With acnrInfo Do
     Begin
          cb:=SizeOf(CNRINFO);
          If (FPictureClosed <> Nil) Or (FPictureOpen <> Nil) Or
             (FPictureLeaf <> Nil) Then
          Begin
               If Not FShowPlusMinus Then
               Begin
                    flWindowAttr:=CV_TREE Or CV_NAME;
               End
               Else flWindowAttr:=CV_TREE Or CV_ICON;
          End
          Else
          Begin
               If Not FShowPlusMinus Then
               Begin
                    flWindowAttr:=CV_TREE Or CV_NAME
               End
               Else flWindowAttr:=CV_TREE Or CV_TEXT;
          End;

          If FShowTreeLines Then flWindowAttr:=flWindowAttr Or CA_TREELINE;

          slTreeBitmapOrIcon.CX:=FPlusMinusSize.CX;
          slTreeBitmapOrIcon.CY:=FPlusMinusSize.CY;
          Flags:=Flags Or CMA_SLTREEBITMAPORICON;

          If (FPictureClosed <> Nil) Or (FPictureOpen <> Nil) Or
             (FPictureLeaf <> Nil) Then
          Begin
               slBitmapOrIcon.CX:=FPictureSize.CX;
               slBitmapOrIcon.CY:=FPictureSize.CY;
               Flags:=Flags Or CMA_SLBITMAPORICON;
               flWindowAttr:=flWindowAttr Or CA_DRAWBITMAP;
          End;

          { grayed
          If FCaption<>Nil Then
          Begin
               flWindowAttr:=flWindowAttr Or CA_CONTAINERTITLE Or CA_TITLESEPARATOR;
               pszCnrTitle:=FCaption;
               Flags:=Flags Or CMA_CNRTITLE;
          End;
          }

          If FTreeIndent<>0 Then
          Begin
               cxTreeIndent:=FTreeIndent;
               Flags:=Flags Or CMA_CXTREEINDENT;
          End;

          If FLineSpacing<>0 Then
          Begin
               cyLineSpacing:=FLineSpacing;
               Flags:=Flags Or CMA_LINESPACING;
          End;

          If FTreeLineWidth<>0 Then
          Begin
               cxTreeLine:=FTreeLineWidth;
               Flags:=Flags Or CMA_CXTREELINE;
          End;
     End;
     WinSendMsg(Handle,CM_SETCNRINFO,LongWord(@acnrInfo),Flags);
     {$ENDIF}

     {$IFDEF Win32}
     WinStyle:=GetWindowLong(Handle,GWL_STYLE);
     If FShowTreeLines Then WinStyle:=WinStyle Or TVS_HASLINES Or TVS_LINESATROOT
     Else WinStyle:=WinStyle And Not (TVS_HASLINES Or TVS_LINESATROOT);
     If FShowPlusMinus Then WinStyle:=WinStyle Or TVS_HASBUTTONS
     Else WinStyle:=WinStyle And Not TVS_HASBUTTONS;
     SetWindowLong(Handle,GWL_STYLE,WinStyle);
     Invalidate;
     {$ENDIF}
End;


Procedure TOutline.SetupSubNodes(Node:TOutlineNode);
Var T:LongInt;
    WorkNode,ParentNode,PrevNode:TOutlineNode;
    P:Pointer;
Begin
     If Handle=0 Then Exit;
     If Node.FSubNodes=Nil Then Exit;
     {Create All subnodes}
     ParentNode:=Node;
     PrevNode:=Nil;
     For T:=0 To Node.FSubNodes.Count-1 Do
     Begin
          WorkNode:=Node.FSubNodes.Items[T];
          If WorkNode.FTreeRec=Nil Then
          Begin
               AllocateRecord(Handle,WorkNode.FTreeRec);
               SetupNode(WorkNode);
          End;

          If PrevNode=Nil
          Then
          Begin
               LongWord(P):=CMA_FIRST;
               InsertRecord(WorkNode,ParentNode.FTreeRec,P)
          End
          Else InsertRecord(WorkNode,ParentNode.FTreeRec,Pointer(PrevNode.FTreeRec));
          SetupSubNodes(WorkNode);
          PrevNode:=WorkNode;
     End;
End;


Procedure TOutline.SetupTree;
Var T:LongInt;
    Node,PrevNode:TOutlineNode;
    P:Pointer;
Begin
     If Handle=0 Then Exit;
     If FInitNodes=Nil Then Exit;
     {Create All main Nodes}
     PrevNode:=Nil;
     For T:=0 To FInitNodes.Count-1 Do  {the subnodes Of the root Node}
     Begin
          Node:=FInitNodes.Items[T];
          If Node.FTreeRec=Nil Then
          Begin
               AllocateRecord(Handle,Node.FTreeRec);
               SetupNode(Node);
          End;

          If PrevNode=Nil Then
          Begin
               LongWord(P):=CMA_FIRST;
               InsertRecord(Node,Nil,P);
          End
          Else InsertRecord(Node,Nil,Pointer(PrevNode.FTreeRec));
          SetupSubNodes(Node);
          PrevNode:=Node;
     End;
     FInitNodes:=Nil;
End;


Procedure TOutline.SetupImageList;
{$IFDEF Win32}
Var  Count:LongInt;
     T:LongInt;
     Bitmap:TOutlineBitmap;
     BitHandle:LongWord;
Label NoBmps;
{$ENDIF}
Begin
     {$IFDEF Win32}
     If Handle=0 Then Exit;

     If FPictureList=Nil Then
     Begin
NoBmps:
         SendMessage(Handle,TVM_SETIMAGELIST,TVSIL_NORMAL,0);
         If FHim<>Nil Then ImageList_Destroy(FHim);
         FHim:=Nil;
         exit;
     End;

     Count:=FPictureList.Count;

     If Count=0 Then goto NoBmps;

     If FHim<>Nil Then ImageList_Destroy(FHim);
     FHim:=ImageList_Create(FPictureSize.CX,FPictureSize.CY,ILC_COLOR4,Count,0);

     For T:=0 To FPictureList.Count-1 Do
     Begin
          Bitmap:=TOutlineBitmap(FPictureList.Bitmaps[T]);
          BitHandle:=Bitmap.CreateBitmapFromClass;
          Bitmap.FHimlIndex:=ImageList_Add(FHim,BitHandle,0);
          DeleteObject(BitHandle);
     End;

     SendMessage(Handle,TVM_SETIMAGELIST,TVSIL_NORMAL,LongWord(FHim));
     {$ENDIF}
End;


Procedure TOutline.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     {$IFDEF OS2}
     Params.Style := Params.Style Or CCS_AUTOPOSITION Or CCS_EXTENDSEL;
     {$ENDIF}

     {$IFDEF Win32}
     Params.Style := Params.Style Or WS_CHILD;
     If FShowTreeLines
     Then Params.Style := Params.Style Or TVS_HASLINES Or TVS_LINESATROOT;
     If FShowPlusMinus Then Params.Style := Params.Style Or TVS_HASBUTTONS;

     If FBorderStyle = bsSingle Then
     Begin
          Params.Style := Params.Style Or WS_BORDER;             {Single}
          Params.ExStyle := Params.ExStyle Or WS_EX_CLIENTEDGE;  {Double}
     End;
     {$ENDIF}
End;


Procedure TOutline.UpdateNode(Node:TOutlineNode);
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Handle,CM_INVALIDATERECORD,LongWord(@Node.FTreeRec),
                MPFROM2SHORT(1,0));
     {$ENDIF}
     {$IFDEF Win32}
     SendMessage(Handle,TVM_SETITEM,0,LongWord(@Node.FTreeRec^.RecordCore));
     {$ENDIF}
End;


Function TOutline.GetSelectedNode:TOutlineNode;
{$IFDEF OS2}
Var RecordCore:POutlineRecord;
{$ENDIF}
{$IFDEF Win32}
Var tvItem:TV_ITEM;
{$ENDIF}
Begin
     Result:=Nil;
     If Handle=0 Then Exit;
     {$IFDEF OS2}
     RecordCore:=Pointer(WinSendMsg(Handle,CM_QUERYRECORDEMPHASIS,
                         CMA_FIRST,CRA_SELECTED));
     If RecordCore<>Nil Then Result:=RecordCore^.Node;
     {$ENDIF}
     {$IFDEF Win32}
     FillChar(tvItem,SizeOf(TV_ITEM),0);
     tvItem.hItem:=FSelItem;
     tvItem.Mask:=TVIF_PARAM;
     SendMessage(Handle,TVM_GETITEM,0,LongWord(@tvItem));
     Result:=TOutlineNode(tvItem.LParam);
     {$ENDIF}
End;


Procedure TOutline.SetSelectedNode(NewSelected:TOutlineNode);
  var
    Control : tControl;
Begin
     If Handle=0 Then Exit;
     If NewSelected=Nil Then Exit;

     If Not NewSelected.IsVisible
     Then NewSelected := NewSelected.GetVisibleParent;
     If NewSelected=Nil Then exit;

     {$IFDEF OS2}
     WinSendMsg(Handle,CM_SETRECORDEMPHASIS,LongWord(NewSelected.FTreeRec),
                MPFROM2SHORT(1,CRA_SELECTED));
     {$ENDIF}
     {$IFDEF Win32}
     //Application.Logwriteln ('SetSelectedNode '+ tostr(longword(NewSelected)) + ' '+tostr(LongWord(NewSelected.FTreeRec^.RecordCore.hItem))+ ' '+NewSelected.GetCaption);
     //SendMessage(Handle,TVM_ENSUREVISIBLE,0,
     //            longint(NewSelected.FTreeRec^.RecordCore.hItem));
     {Martin0907: Win32 requires that the outline has the focus, otherwise the selection carent won't be shown}
     if not NewSelected.Outline.HasFocus then begin
       NewSelected.Outline.Focus;
     end;
     SendMessage(Handle,TVM_SELECTITEM,TVGN_CARET,
                 longint(NewSelected.FTreeRec^.RecordCore.hItem));
     {$ENDIF}
End;


Function TOutline.GetSelectedItem:LongInt;
Var  Node:TOutlineNode;
Begin
     Node := GetSelectedNode;
     If Node <> Nil Then Result := Node.Index
     Else Result := InvalidIndex;
     //Application.Logwriteln ('GetSelectedItem '+ tostr(longword(Node)) + ' '+tostr(LongWord(Node.FTreeRec^.RecordCore.hItem))+ ' '+Node.GetCaption);
End;


Procedure TOutline.SetSelectedItem(NewSelected:LongInt);
Var  Node:TOutlineNode;
Begin
     Node := Get(NewSelected);
     //if Node = nil then Application.Logwriteln (tostr(NewSelected) + ' Node = nil')
     //else Application.Logwriteln (tostr(NewSelected) + ' Node <> nil');
     If Node <> Nil Then SetSelectedNode(Node);
End;


Function TOutline.GetDataItem(Value:Pointer):LongInt;
Begin
     Result := FRootNode.GetDataItem(Value);
End;


Function TOutline.GetTextItem(Const Value:String):LongInt;
Begin
     Result := FRootNode.GetTextItem(Value);
End;


Procedure TOutline.ItemFocus(Index:LongInt);
Begin
     If OnItemFocus <> Nil Then OnItemFocus(Self,Index);
     If SelectedItem<>InvalidIndex Then Click;
End;


Procedure TOutline.ItemSelect(Index:LongInt);
Begin
     If OnItemSelect <> Nil Then OnItemSelect(Self,Index);
End;


{$HINTS OFF}
Procedure TOutline.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Var  Node1,Node2:TOutlineNode;
Begin
     Case KeyCode Of
       kbCUp,kbCDown,kbCLeft,kbCRight,kbHome,kbEnd,kbPageUp,kbPageDown:
       Begin
            Node1 := SelectedNode;
            LastMsg.CallDefaultHandler; //!
            Node2 := SelectedNode;
            If Node1 <> Node2 Then
              If Node2 Is TOutlineNode Then ItemFocus(Node2.Index);
       End;
       Else Inherited ScanEvent(KeyCode,RepeatCount);
     End;
End;

Procedure TOutline.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     {$IFDEF WIN32}
     If Button=mbRight Then
     Begin
          LastMsg.Handled:=True;
          exit;
     End;
     {$ENDIF}

     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          FDragging := True;
          FFocusNode := SelectedNode;

     End;
End;

Procedure TOutline.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var  Node:TOutlineNode;
Begin
     Inherited MouseMove(ShiftState,X,Y);

     If FDragging Then
     Begin
          Node := SelectedNode;
          If Node <> FFocusNode Then
            If Node Is TOutlineNode Then
            Begin
                 FFocusNode := Node;
                 ItemFocus(Node.Index);
            End;
     End;
End;


Procedure TOutline.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var Node:TOutlineNode;
Begin
     {$IFDEF WIN32}
     If Button=mbRight Then
     Begin
          LastMsg.Handled:=True;
          exit;
     End;
     {$ENDIF}

     Inherited MouseUp(Button,ShiftState,X,Y);

     If FDragging Then
     Begin
          FDragging := False;
          Node := SelectedNode;
          If Node <> FFocusNode Then
            If Node Is TOutlineNode Then
            Begin
                 FFocusNode := Node;
                 ItemFocus(Node.Index);
            End;
     End;
End;

Procedure TOutline.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     {$IFDEF WIN32}
     If SelectedNode<>Nil Then ItemSelect(SelectedNode.Index);
     {$ENDIF}
End;

Procedure TOutline.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     {$IFDEF OS2}
     If OnMouseClick <> Nil Then OnMouseClick(Self,Button,ShiftState,X,Y);
     {no Inherited because Of CN_CONTEXTMENU, but Store the mouse Pos}
     FPopupPos := Point(X,Y);
     {$ENDIF}
     {$IFDEF WIN32}
     FPopupPos := Point(X,Y);
     Inherited MouseClick(Button,ShiftState,X,Y);
     {$ENDIF}
End;
{$HINTS ON}

Procedure TOutline.Expand(Index:LongInt);
Begin
    If FOnExpand <> Nil Then FOnExpand(Self,Index);
End;

Procedure TOutline.Collapse(Index:LongInt);
Begin
    If FOnCollapse <> Nil Then FOnCollapse(Self,Index);
End;

Procedure TOutline.Click;
Begin
    If FOnClick<>Nil Then FOnClick(Self);
End;

Procedure TOutline.ItemChanged(Var Msg:TMessage;Expanded:Boolean);
Var  Node:TOutlineNode;
     {$IFDEF OS2}
     RecordCore:POutlineRecord;
     {$ENDIF}
     {$IFDEF Win32}
     DispInfo:^NM_TREEVIEW;
     Item:TV_ITEM;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     RecordCore := Pointer(Msg.Param2);
     Node := RecordCore^.Node;
     If Node = Nil Then Exit;
     {$ENDIF}

     {$IFDEF Win32}
     DispInfo := Pointer(Msg.Param2);
     Item := DispInfo^.ItemNew;
     Node := TOutlineNode(Item.LParam);
     If Node = Nil Then Exit;

     Node.UpdatePicture{(Node.FPictureLeaf)???};
     {$ENDIF}

     Node.FExpanded := Expanded;
     Node.UpdatePicture;
     If Node.Expanded Then
     Begin
          If not FChangeLock Then
          Begin
               If Node.FIndex=InvalidIndex Then FRootNode.ReIndex(FRootNode.Index,MaxLongInt);
               If Node.FIndex<>InvalidIndex Then Expand(Node.FIndex);
          End;
     End
     Else
     Begin
          If not FChangeLock Then
          Begin
              If Node.FIndex=InvalidIndex Then FRootNode.ReIndex(FRootNode.Index,MaxLongInt);
              If Node.FIndex<>InvalidIndex Then Collapse(Node.FIndex);
          End;
     End;

     UpdateNode(Node);
End;


procedure tOutline.ShowItem (ShowItemIndex : longint);{Martin}
  {$ifdef os2}
  var
    Node, Topnode, Subnode, ExpandedNode : tOutlineNode;
    Offset, VisibleIndex, Ix : longint;
  {$endif}
  begin
    if ShowItemIndex <= 0 then exit;
    {$ifdef os2}
    Subnode := Items[ShowItemIndex];
    if Subnode.TopItem = Subnode.Index then Topnode := nil
    else Topnode := Items[Subnode.TopItem];
    if Topnode <> nil then begin
      ExpandedNode := nil;
      while ExpandedNode <> Subnode.Parent do begin
        Node := Subnode;
        while (Node.Parent <> nil) and (Node.Parent <> ExpandedNode) and (Node <> Topnode) do Node := Node.Parent;
        if Node <> nil then
          WinSendMsg(Handle,CM_EXPANDTREE,LongWord(Pointer(Node.FTreeRec)),0);
        ExpandedNode := Node;
      end;
    end;
    VisibleIndex := 0;
    for ix := 1 to ShowItemIndex do if Items[ix].IsVisible then inc (VisibleIndex);
    Offset := (Font.Height + 2 + LineSpacing) * (VisibleIndex-1) - (Height div 2);
    if Offset > 0 then begin
      {go with scrollbar to the beginning}
      WinSendMsg(Handle, WM_CHAR, MPFROM2SHORT(KC_VIRTUALKEY,0),MPFROM2SHORT(0,VK_HOME));
      {scroll the scrollbar to make the item visible in the middle of the window}
      WinSendMsg(Handle, CM_SCROLLWINDOW, CMA_VERTICAL, Offset);
    end;
    {$endif}
    {$ifdef win32}
    {sometimes the scrollbar does not move, both in Win2000 and in Win XP, no idea why (Windows bug?)}
    SendMessage(Handle,TVM_ENSUREVISIBLE,0,LongWord(Items[ShowItemIndex].FTreeRec^.RecordCore.hItem));
    {$endif}
  end;


Procedure TOutline.BeginUpdate;
Begin
     If FUpdateCount = 0 Then
     Begin
          If Handle <> 0 Then
          {$IFDEF OS2}
          WinEnableWindowUpdate(Handle,False);
          {$ENDIF}
          {$IFDEF Win32}
          SendMessage(Handle,WM_SETREDRAW, 0, 0);
          {$ENDIF}
     End;
     Inc(FUpdateCount);
End;


Procedure TOutline.EndUpdate;
Begin
  Dec(FUpdateCount);
  If FUpdateCount = 0 Then
    Begin
      If Handle <> 0 Then
        Begin
          {$IFDEF OS2}
          WinEnableWindowUpdate(Handle,True);
          {$ENDIF}
          {$IFDEF Win32}
          SendMessage(Handle,WM_SETREDRAW, 1, 0);
          {$ENDIF}
        End;
      {Martin}if not ProcessDestroyWnd then
        FRootNode.ReIndex(FRootNode.Index,MaxLongInt);
    End;


End;


Procedure TOutline.ParentNotification(Var Msg:TMessage);
{$IFDEF OS2}
Var  Node:TOutlineNode;
     RecordCore:POutlineRecord;
     RecEnter:PNOTIFYRECORDENTER;
     RecEmp:PNOTIFYRECORDEMPHASIS;
     SaveCount:LongInt;
{$ENDIF}
{$IFDEF WIN32}
Var DispInfo:^NM_TREEVIEW;
    Expanded:Boolean;
    KeyDown:^TV_KEYDOWN;
{$ENDIF}
CONST CN_TEST=0;
Begin
     {$IFDEF OS2}
     Case Msg.Param1Hi Of
       CN_SCROLL:
       Begin
            Inherited ParentNotification(Msg);

            {!! Update BitBlt area Of the Ownerdraw Frame}
            If FBorderStyle = bsSingle Then Invalidate;
       End;
       CN_ENTER:      {Enter & DoubleClick}
       Begin
            If Designed Then Exit;
            Inherited ParentNotification(Msg);

            RecEnter := Pointer(Msg.Param2);
            If RecEnter = Nil Then Exit;
            RecordCore := Pointer(RecEnter^.pRecord);
            If RecordCore = Nil Then Exit;
            Node := RecordCore^.Node;

            If Node Is TOutlineNode Then ItemSelect(Node.Index);
       End;
       CN_COLLAPSETREE,CN_EXPANDTREE:
       Begin
            If Designed Then Exit;
            Inherited ParentNotification(Msg);

            RecordCore := Pointer(Msg.Param2);
            Node := RecordCore^.Node;

            If Node Is TOutlineNode Then
            Begin
                 If Msg.Param1Hi = CN_COLLAPSETREE
                 Then ItemChanged(Msg,False)
                 Else ItemChanged(Msg,True)
            End;
            {!! Update area Of the Ownerdraw Frame}
            If FBorderStyle = bsSingle Then Invalidate;
       End;
       CN_CONTEXTMENU:
       Begin
            If Designed Then Exit;
            CheckMenuPopup(FPopupPos);
       End;
(* Cut no effect
       CN_REALLOCPSZ:
       Begin
       End;
       CN_ENDEDIT:
       Begin
            CnrEdit := Pointer(Msg.Param2);
            RecordCore := POutlineRecord(CnrEdit^.pRecord);
            Node := RecordCore^.Node;
            ppc := CnrEdit^.ppszText;
            pc := ppc^;
            S := pc^;
            ErrorBox2(S+' <> '+RecordCore^.RecordCore.pszTree^);
            Msg.Handled := True;
            Msg.Result := 0;
       End;
*)
       CN_EMPHASIS:
       Begin
            Inherited ParentNotification(Msg);

            RecEmp := Pointer(Msg.Param2);
            If RecEmp = Nil Then Exit;
            RecordCore := Pointer(RecEmp^.pRecord);
            If RecordCore = Nil Then Exit;
            Node := RecordCore^.Node;
            DefaultHandler(Msg);

            If (RecEmp^.fEmphasisMask And 5)=5 Then
             If SelectedNode=Node Then
            Begin
                 PostMsg(Parent.Handle,WM_CONTROL,
                         Msg.Param1Lo OR (CN_TEST SHL 16),
                         LONGWORD(Node));
            End;
       End;
       CN_TEST:
       BEGIN
            Node := Pointer(Msg.Param2);
            If (LongWord(Node) And $80000000)=0 Then
              If LongWord(Node)>$10000 Then
            Begin
               Try
                 If FUpdateCount>0 Then FRootNode.ReIndex(FRootNode.Index,MaxLongInt);
                 SaveCount:=FUpdateCount;
                 FUpdateCount:=0;
                 If Node IS TOutlineNode Then ItemFocus(Node.Index);
                 FUpdateCount:=FUpdateCount+SaveCount;
               Except
               End;
            End;
            Msg.Handled:=True;
       END;
       Else
       Begin
            Inherited ParentNotification(Msg);
       End;
     End;
     {$ENDIF}

     {$IFDEF Win32}
     If Msg.Msg<>WM_NOTIFY Then
     Begin
          Inherited ParentNotification(Msg);
          exit;
     End;

     DispInfo:=Pointer(Msg.Param2);
     If DispInfo=Nil Then Exit;
     Case DispInfo^.hdr.Code Of
         TVN_ITEMEXPANDED:
         Begin
              Expanded:=DispInfo^.Action And TVE_EXPAND=TVE_EXPAND;

              ItemChanged(Msg,Expanded);

              Msg.Handled:=True;
              Msg.Result:=0;
         End;
         TVN_KEYDOWN:
         Begin
              KeyDown:=Pointer(Msg.Param2);

              If KeyDown^.wVKey=VK_RETURN Then
               If SelectedNode<>Nil Then ItemSelect(SelectedNode.Index);
         End;
         TVN_SELCHANGED:
         Begin
              FSelItem:=DispInfo^.ItemNew.hItem;
         End;
         Else Inherited ParentNotification(Msg);
     End; {Case}
     {$ENDIF}
End;


Procedure TOutline.indexerror;
Begin
     Raise EOutlineIndexError.Create(LoadNLSStr(SInvalidOutlineNodeIndex));
End;


Procedure TOutline.NodeError;
Begin
     Raise EOutlineNodeError.Create(LoadNLSStr(SInvalidOutlineNode)+' (NIL)');
End;


Function TOutline.AttachNode(Node:TOutlineNode;Const Text:String;Data:Pointer;
                             Mode:TAttachMode):TOutlineNode;
Var  NewNode:TOutlineNode;
Begin
     If Node = Nil Then Node := FRootNode;

     NewNode := FNodeClass.Create(Self);
     NewNode.Data := Data;
     NewNode.Text := Text;
     NewNode.FIndex := InvalidIndex;
     NewNode.FExpanded := False;

     Case Mode Of
       oaAddChild: Node.AddNode(NewNode);
       oaAdd:      Node.Parent.AddNode(NewNode);
       oaInsert:   Node.Parent.InsertNode(Node,NewNode);
     End;
     Result := NewNode;
End;


Function TOutline.Add(Index:LongInt;Const Text:String):LongInt;
Begin
     Result := AddObject(Index,Text,Nil);
End;


{Add To the same Level like idx Node}
Function TOutline.AddObject(Index:LongInt;Const Text:String;Data:Pointer):LongInt;
Begin
     If Index >= 0 Then
     Begin
          If Index = 0 Then Result := AddChildObject(Index,Text,Data)
          Else Result := Attach(Index,Text,Data,oaAdd);
     End
     Else IndexError;
End;


{Add As Child Of the idx Node}
Function TOutline.AddChild(Index:LongInt;Const Text:String):LongInt;
Begin
     Result := AddChildObject(Index,Text,Nil);
End;


Function TOutline.AddChildObject(Index:LongInt;Const Text:String;Data:Pointer):LongInt;
Begin
     If Index >= 0 Then Result := Attach(Index,Text,Data,oaAddChild)
     Else indexerror;
End;


Function TOutline.Insert(Index:LongInt;Const Text:String):LongInt;
Begin
     Result := InsertObject(Index,Text,Nil);
End;


Function TOutline.InsertObject(Index:LongInt;Const Text:String;Data:Pointer):LongInt;
Begin
     If Index >= 0 Then
     Begin
          If Index = 0 Then Result := AddChildObject(Index,Text,Data)
          Else Result := Attach(Index,Text,Data,oaInsert);
     End
     Else indexerror;
End;


{Create the Node And Insert it}
Function TOutline.Attach(idx:LongInt;Const Text:String;Data:Pointer;
                         Mode:TAttachMode):LongInt;
Var  Node:TOutlineNode;
Begin
     If idx = 0 Then Node := FRootNode
     Else Node := Get(idx);
     If Node = Nil Then NodeError;

     FIndexInsert := True;   {force To Update Index}
     Node := AttachNode(Node,Text,Data,Mode);
     FIndexInsert := False;  {Index Update Mode = OFF}

     If Node <> Nil Then Result := Node.FIndex
     Else Result := InvalidIndex;
End;


Procedure TOutline.Delete(Index:LongInt);
Var  ANode:TOutlineNode;
     AParent:TOutlineNode;
Begin
     If Index > 0 Then
     Begin
          ANode := Get(Index);
          AParent := ANode.parent;
          ANode.Destroy;

          SetGoodNode(AParent);
     End
     Else indexerror;
End;


Procedure TOutline.SetGoodNode(Node:TOutlineNode);
Begin
     If FUpdateCount > 0 Then
     Begin
          FGoodNode := Node;
          If FGoodNode <> FRootNode Then FGoodNode.SetLastValidIndex;
     End
     Else FRootNode.ReIndex(FRootNode.Index,MaxLongInt);
End;


Function TOutline.GetLines:TStrings;
Begin
     If Handle <> 0 Then Result := FLines
     Else Result := FInitLines;
End;


Procedure TOutline.SetLines(AStrings:TStrings);
Begin
     If Lines <> AStrings Then Lines.Assign(AStrings);
End;


Function TOutline.Get(idx:LongInt):TOutlineNode;
Begin
     If FCurItem.Index = idx Then
     Begin
          Result := FCurItem;
          Exit;
     End;
     If FGoodNode.Index = idx Then
     Begin
          Result := FGoodNode;
          Exit;
     End;

     If FGoodNode.Index < idx Then
     Begin
          FRootNode.ReIndex(FRootNode.Index,idx);
     End;

     Result := FRootNode.Index2Node(idx);
     FCurItem := Result;
End;


Function TOutline.GetItemCount:LongInt;
Begin
     FRootNode.ReIndex(FRootNode.Index,MaxLongInt);

     Result := FRootNode.GetLastIndex;
End;


Procedure TOutline.FullExpand;
Begin
     BeginUpdate;
     FRootNode.FullExpand;
     EndUpdate;
End;


Procedure TOutline.FullCollapse;
Begin
     BeginUpdate;
     FRootNode.FullCollapse;
     EndUpdate;
End;


Procedure TOutline.Clear;
Begin
     BeginUpdate;
     FRootNode.ClearSubNodes;
     EndUpdate;
End;


Function TOutline.WriteSCUResource(Stream:TResourceStream):Boolean;
Var  aText:PChar;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If (FPictureLeaf <> Nil) And Not FPictureLeaf.Empty
     Then Result := FPictureLeaf.WriteSCUResourceName(Stream,rnPictureLeaf);
     If Not Result Then Exit;

     If (FPictureOpen <> Nil) And Not FPictureOpen.Empty
     Then Result := FPictureOpen.WriteSCUResourceName(Stream,rnPictureOpen);
     If Not Result Then Exit;

     If (FPictureClosed <> Nil) And Not FPictureClosed.Empty
     Then Result := FPictureClosed.WriteSCUResourceName(Stream,rnPictureClosed);
     If Not Result Then Exit;

     aText := Lines.GetText;
     If aText <> Nil Then
     Begin
          Result := Stream.NewResourceEntry(rnLines,aText^,Length(aText^)+1);
          StrDispose(aText);
          If Not Result Then Exit;
     End;
End;


Procedure TOutline.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  aText:PChar;
Begin
     If ResName = rnLines Then
     Begin
          aText := @Data;
          Lines.SetText(aText);
     End Else
     If ResName = rnPictureLeaf Then
     Begin
          If DataLen <> 0
          Then PictureLeaf.ReadSCUResource(rnBitmap,Data,DataLen);
     End Else
     If ResName = rnPictureOpen Then
     Begin
          If DataLen <> 0
          Then PictureOpen.ReadSCUResource(rnBitmap,Data,DataLen);
     End Else
     If ResName = rnPictureClosed Then
     Begin
          If DataLen <> 0
          Then PictureClosed.ReadSCUResource(rnBitmap,Data,DataLen);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;

Function TOutline.NodeFromPoint(pt:TPoint):TOutlineNode;
Var t:LongInt;
    rec:TRect;
Begin
  For t:=1 To ItemCount Do
    Begin
      result:=Items[t];
      rec:=Result.ItemRect;
      If ((pt.X>=rec.Left)And(pt.X<=rec.Right)) Then
        If ((pt.Y>=rec.Bottom)And(pt.Y<=rec.Top)) Then exit;
    End;
  Result:=Nil;
End;

Procedure TOutline.DrawDragRect;
Begin
     If Canvas = Nil Then Exit;
     Canvas.Pen.Mode:=pmNot;
     Canvas.Pen.color:=clBlack;
     Canvas.Pen.Style:=psDot;
     Canvas.Rectangle(FDragRect);
     Canvas.Pen.Mode:=pmCopy;
End;

Procedure TOutline.DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:Boolean);
Var Node:TOutlineNode;
Label invalid;
Begin
     Node:=Nil;
     Inherited DragOver(Source,X,Y,State,Accept);
     If FShowDragRects Then
     Begin
          If Accept Then
          Begin
               Node:=NodeFromPoint(Point(X,Y));
               If Node<>Nil Then
               Begin
                    Case State Of
                       dsDragEnter:
                       Begin
                            CreateDragCanvas;
                            If FDragRectValid Then DrawDragRect; //Delete old
                            FDragRect := Node.ItemRect;
                            FDragRectValid:=True;
                            DrawDragRect;  //Draw New
                            DeleteDragCanvas;
                       End;
                       dsDragMove:
                       If Node<>FDragSelected Then
                       Begin
                            CreateDragCanvas;
                            If FDragRectValid Then DrawDragRect; //Delete old
                            FDragRect := Node.ItemRect;
                            FDragRectValid:=True;
                            DrawDragRect; //Draw New
                            DeleteDragCanvas;
                       End;
                       dsDragLeave:
                       Begin
                            If FDragRectValid Then
                            Begin
                                 FDragRectValid:=False;
                                 CreateDragCanvas;
                                 DrawDragRect; //Delete old
                                 DeleteDragCanvas;
                            End;
                       End;
                    End; //Case
               End
               Else Goto invalid;
          End
          Else
          Begin
invalid:
               If FDragRectValid Then
               Begin
                    FDragRectValid:=False;
                    CreateDragCanvas;
                    DrawDragRect; //Delete old
                    DeleteDragCanvas;
               End;
          End;
          FDragSelected:=Node;
     End;
End;

Procedure TOutline.DragDrop(Source:TObject;X,Y:LongInt);
Begin
     If FDragRectValid Then
     Begin
          CreateDragCanvas;
          DrawDragRect; //Delete old
          DeleteDragCanvas;
          FDragRectValid:=False;
     End;
     Inherited DragDrop(Source,X,Y);
End;

Begin
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  27-Sep-02  WD         Ausbau der LINUX-Teile
  18-Nov-04  MV         Umbau von TOutlineNode.Destroy
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  26-Sep-05  MV         Kontrollvariable "ProcessDestroyWnd" eingebaut, die verhindert,
                        daแ wenn das Outline beim Destroy ist, noch einmal Eintrge sortiert
                        werden, was zu dem Fehler fhrte und jetzt auch schneller sein sollte.
  28-Jul-06  MV         FullExpand, FullCollapse now encapsulated with BeginUpdate...EndUpdate
  31-Jul-06  MV         New procedure tOutline.ShowItem (index) expands the parents and moves the scrollbar
                        to get the item really visible. The item does not get selected.
  03-Okt-06  KF         TOutline.NodeFromPoint: Outlineitem fangen bei 1 und nicht bei 0

  27-Sep-07  MV         TOutline.SetSelectedNode (for the command "Outline.SelectedItem := X") changed
                        (Win32 only)
}
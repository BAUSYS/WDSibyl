
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit ListView;

Interface

{$IFDEF OS2}
Uses Os2Def,PmWin,PmStdDlg;
{$ENDIF}

{$IFDEF Win32}
Uses WinDef,WinUser,WinGDI,CommCtrl;
{$ENDIF}

Uses Messages,SysUtils,Color,Classes,Forms,Graphics,OutLine,
     uList;

Type
    EListViewError=Class(Exception);

Type
    TListViewNode=Class;
    TListView=Class;

    PListViewRecord=^TListViewRecord;
    TListViewRecord=Record
         {$IFDEF OS2}
         RecordCore:RecordCore;
         {$ENDIF}
         {$IFDEF Win32}
         RecordCore:LV_ITEM;
         {$ENDIF}
         Node:TListViewNode;  {Extra Data}
    End;

    TListViewNode=Class
      Private
         FTreeRec:PListViewRecord;
         FCaption:PChar;
         FData:Pointer;
         FIndex:LongInt;
         FListView:TListView;
         FBitmap:TBitmap;
      Private
         Function GetCaption:String;
         Procedure SetCaption(NewCaption:String);
         Function GetBitmap:TBitmap;
         Procedure SetBitmap(NewBitmap:TBitmap);
         Function GetItemRect:TRect;
      Public
         Constructor Create(Owner:TListView);
         Destructor Destroy;Override;
      Public
         Property Data:Pointer Read FData Write FData;
         Property Text:String Read GetCaption Write SetCaption;
         Property Bitmap:TBitmap Read GetBitmap Write SetBitmap;
         Property Index:LongInt Read FIndex;
         Property ItemRect:TRect read GetItemRect;
    End;
    TListViewNodeClass=Class Of TListViewNode;

    {$M+}
    TListViewItemSelectEvent=Procedure(Sender:TObject;Index:LongInt) Of Object;
    {$M-}

    TListView=Class(TControl)
      Private
         FBitmapSize:TSize;
         FShowDragRects:Boolean;
         FDragRectValid:Boolean;
         FDragRect:TRect;
         FDragSelected:TListViewNode;
         FInitNodes:TList;
         FNodes:TList;
         FNodeClass:TListViewNodeClass;
         FPictureList:TBitmapList;
         FMultipleSel:Boolean;
         FBorderStyle:TBorderStyle;
         FPopupPos:TPoint;
         {$IFDEF Win32}
         FHim:HIMAGELIST;
         {$ENDIF}
         FOnItemSelect:TListViewItemSelectEvent;
         FUpdateCount:LongInt;
         FSorted:Boolean;
      Private
         {$IFDEF OS2}
         Procedure WMPaint(Var Msg:TMessage);Message WM_PAINT;
         {$ENDIF}
         Procedure SetCnrInfo;
         Procedure SetupImageList;
         Procedure SetupList;
         Function AddPicture(NewBitmap:TBitmap):TBitmap;
         Function Get(Index:LongInt):TListViewNode;
         Function GetItemCount:LongInt;
         Procedure UpdateNode(Node:TListViewNode);
         Procedure SetBorderStyle(NewBorder:TBorderStyle);
         Function GetItemIndex:LongInt;
         Procedure SetItemIndex(NewValue:LongInt);
         Function GetSelect(Index:LongInt):Boolean;
         Procedure SetSelect(Index:LongInt;NewValue:Boolean);
         Procedure SetSorted(NewValue:Boolean);
         Procedure DrawDragRect;
      Protected
         Procedure SetupComponent;Override;
         {$IFDEF OS2}
         Procedure SetupShow;Override;
         {$ENDIF}
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure CreateWnd;Override;
         Procedure DestroyWnd;Override;
         Procedure ParentNotification(Var Msg:TMessage);Override;
         Procedure ItemSelect(Index:LongInt);Virtual;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         {$IFDEF WIN32}
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LonGInT);Override;
         {$ENDIF}
         Procedure DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:Boolean);Override;
         Procedure DragDrop(Source:TObject;X,Y:LongInt);Override;
      Public
         Destructor Destroy;Override;
         Function Add(Const Text:String;Data:Pointer;Bitmap:TBitmap):TListViewNode;
         Function NodeFromPoint(pt:TPoint):TListViewNode;
         Procedure Clear;
         Procedure BeginUpdate;
         Procedure EndUpdate;
      Public
         Property NodeClass:TListViewNodeClass Read FNodeClass Write FNodeClass;
         Property Nodes:TList Read FNodes;
         Property Items[Index:LongInt]:TListViewNode Read Get;Default;
         Property ItemCount:LongInt Read GetItemCount;
         Property ItemIndex:LongInt Read GetItemIndex Write SetItemIndex;
         Property Selected[Index:LongInt]:Boolean Read GetSelect Write SetSelect;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property BitmapSize:TSize Read FBitmapSize Write FBitmapSize;
         Property BorderStyle:TBorderStyle Read FBorderStyle Write SetBorderStyle;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property MultipleSel:Boolean Read FMultipleSel Write FMultipleSel;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PopupMenu;
         Property ShowDragRects:Boolean Read FShowDragRects Write FShowDragRects;
         Property ShowHint;
         Property Sorted:Boolean read FSorted write SetSorted;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnItemSelect:TListViewItemSelectEvent Read FOnItemSelect Write FOnItemSelect;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


Function InsertListView(parent:TControl;Left,Bottom,Width,Height:LongInt;Hint:String):TListView;


Implementation


Function InsertListView(parent:TControl;Left,Bottom,Width,Height:LongInt;Hint:String):TListView;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.TabStop := True;
     Result.Hint := Hint;
     Result.parent := parent;
End;


{$IFDEF Win32}
Const
    CMA_FIRST:LongWord=0;
{$ENDIF}


Procedure RemoveRecord(Node:TListViewNode; Update:Boolean);
Var ListHandle:LongWord;

{$IFDEF OS2}
    Flags:LongWord;
{$ENDIF}

Begin
     If Node = Nil Then Exit;
     If Node.FTreeRec = Nil Then Exit;

     ListHandle := Node.FListView.Handle;
     If ListHandle <> 0 Then
     Begin
          {$IFDEF OS2}
          Flags := CMA_FREE;
          If Update Then Flags := Flags Or CMA_INVALIDATE;
          WinSendMsg(ListHandle,CM_REMOVERECORD,LongWord(@Node.FTreeRec),
                     MPFROM2SHORT(1,Flags));
          {$ENDIF}
          {$IFDEF Win32}
          SendMessage(ListHandle,LVM_DELETEITEM,
                      LongWord(Node.FTreeRec^.RecordCore.iItem),0);
          {$ENDIF}
     End;

     {$IFDEF Win32}
     Dispose(Node.FTreeRec);
     {$ENDIF}
     Node.FTreeRec := Nil;
End;


Procedure InsertRecord(NewNode:TListViewNode; AParentRecord:PListViewRecord;
                       RecordOrder:Pointer);
Var  ListHandle:LongWord;
     List:TListView;
     {$IFDEF OS2}
     aRecordInsert:RECORDINSERT;
     {$ENDIF}
Begin
     NewNode.FTreeRec^.Node := NewNode;
     {specify where To Insert}
     List := NewNode.FListView;
     ListHandle := List.Handle;

     {$IFDEF OS2}
     aRecordInsert.cb := SizeOf(RECORDINSERT);
     aRecordInsert.pRecordOrder := RecordOrder;
     aRecordInsert.ZOrder := CMA_TOP;
     aRecordInsert.cRecordsInsert := 1;     //Number Of records
     aRecordInsert.fInvalidateRecord := 1;  //Invalidate records
     aRecordInsert.pRecordParent := Pointer(AParentRecord);

     {Insert Record}
     WinSendMsg(ListHandle,CM_INSERTRECORD,
                LongWord(NewNode.FTreeRec),LongWord(@aRecordInsert));
     {$ENDIF}

     {$IFDEF Win32}
     SendMessage(ListHandle,LVM_INSERTITEM,0,LongWord(@NewNode.FTreeRec^.RecordCore));
     {$ENDIF}
End;


Procedure AllocateRecord(Handle:LongWord;Var porec:PListViewRecord);
Begin
     //allocate Memory
     {$IFDEF OS2}
     porec:=Pointer(WinSendMsg(Handle,
                               CM_ALLOCRECORD,
                               {additional Info For ListViewRecord}
                               SizeOf(TListViewRecord)-SizeOf(RecordCore),
                               1));          {allocate one Record}
     {$ENDIF}
     {$IFDEF Win32}
     New(porec);
     {$ENDIF}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TListViewBitmap Class Implementation                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TListViewBitmap=Class(TBitmap)
      {$IFDEF Win32}
      Private
         FHimlIndex:LongInt;
      Private
         Function CreateBitmapFromClass(CX,CY:LongWord):LongWord;
      {$ENDIF}
    End;


{$IFDEF Win32}
Function TListViewBitmap.CreateBitmapFromClass(CX,CY:LongWord):LongWord;
Var ps:HDC;
    iinfo:ICONINFO;
    HBITMAP,OldBmp:LongWord;
Begin
     HBITMAP:=CopyImage(Handle,IMAGE_BITMAP,CX,CY,0);
     iinfo.FIcon:=True;
     iinfo.hbmMask:=CreateBitmap(CX,CY,1,1,Nil);
     ps:=CreateCompatibleDC(0);
     OldBmp:=SelectObject(ps,iinfo.hbmMask);
     WinGDI.BitBlt(ps,0,0,CX-1,CY-1,0,0,0,BLACKNESS);
     iinfo.hbmColor:=HBITMAP;
     Result:=CreateIconIndirect(iinfo);

     SelectObject(ps,OldBmp);
     If Not DeleteDC(ps) Then ErrorBox2('CreateBitmapFromClass: Cannot destroy BitmapPS');;
     If Not DeleteObject(iinfo.hbmMask) Then ErrorBox2('CreateBitmapFromClass: Cannot destroy Mask BitmapHandle');
     If Not DeleteObject(HBITMAP) Then ErrorBox2('CreateBitmapFromClass: Cannot destroy BitmapHandle');
End;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TListViewNode Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TListViewNode.GetCaption:String;
Begin
     If FCaption=Nil Then Result:=''
     Else Result:=FCaption^;
End;


Procedure TListViewNode.SetCaption(NewCaption:String);
Begin
     If NewCaption = Text Then Exit;

     If FCaption<>Nil Then FreeMem(FCaption,Length(FCaption^)+1);
     FCaption:=Nil;
     If NewCaption<>'' Then
     Begin
          GetMem(FCaption,Length(NewCaption)+1);
          FCaption^:=NewCaption;
     End;

     {$IFDEF OS2}
     If FTreeRec<>Nil Then FTreeRec^.RecordCore.pszIcon:=FCaption;
     {$ENDIF}
     {$IFDEF Win32}
     If FTreeRec<>Nil Then
     Begin
          FTreeRec^.RecordCore.pszText:=FCaption;
          If FCaption<>Nil Then
             FTreeRec^.RecordCore.cchTextMax:=Length(FCaption^)+1
          Else FTreeRec^.RecordCore.cchTextMax:=0;
     End;
     {$ENDIF}

     FListView.UpdateNode(Self);
End;


Procedure TListViewNode.SetBitmap(NewBitmap:TBitmap);
Begin
     FBitmap:=FListView.AddPicture(NewBitmap);

     {$IFDEF OS2}
     If FTreeRec<>Nil Then
     Begin
        If FBitmap<>Nil Then
           FTreeRec^.RecordCore.hbmBitmap:=FBitmap.Handle
        Else
           FTreeRec^.RecordCore.hbmBitmap:=0;
     End;
     {$ENDIF}
     {$IFDEF Win32}
     If FTreeRec<>Nil Then
     Begin
        If FBitmap<>Nil Then
           FTreeRec^.RecordCore.iImage := TListViewBitmap(FBitmap).FHimlIndex
        Else
           FTreeRec^.RecordCore.iImage:=0;
     End;
     {$ENDIF}

     FListView.UpdateNode(Self);
End;


Function TListViewNode.GetBitmap:TBitmap;
Begin
     If FBitmap = Nil Then
     Begin
          FBitmap.Create;
          Include(FBitmap.ComponentState, csDetail);
     End;
     Result := FBitmap;
End;


Constructor TListViewNode.Create(Owner:TListView);
Begin
     Inherited Create;

     If Owner Is TListView Then
     Begin
          FListView := TListView(Owner)
     End
     Else Raise EListViewError.Create('Invalid listview item owner');
End;

Destructor TListViewNode.Destroy;
Begin
     RemoveRecord(Self,True);

     If FCaption <> Nil Then
     Begin
          FreeMem(FCaption,Length(FCaption^)+1);
          FCaption := Nil;
     End;

     Inherited Destroy;
End;

Function TListViewNode.GetItemRect:TRect;
{$IFDEF OS2}
Var RecRect:QUERYRECORDRECT;
{$ENDIF}
Begin
     FillChar(result,sizeof(TRect),0);
     {$IFDEF OS2}
     RecRect.cb:=sizeof(QUERYRECORDRECT);
     RecRect.pRecord:=@FTreeRec^.RecordCore;
     RecRect.fRightSplitWindow:=0;
     RecRect.fsExtent:=CMA_ICON OR CMA_TEXT;
     WinSendMsg(FListView.Handle,CM_QUERYRECORDRECT,LongWord(@Result),LongWord(@RecRect));
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TListView Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TListView.UpdateNode(Node:TListViewNode);
Begin
     If Handle=0 Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Handle,CM_INVALIDATERECORD,LongWord(@Node.FTreeRec),
                MPFROM2SHORT(1,0));
     {$ENDIF}
     {$IFDEF Win32}
     SendMessage(Handle,LVM_SETITEM,0,LongWord(@Node.FTreeRec^.RecordCore));
     {$ENDIF}
End;

Procedure TListView.SetCnrInfo;
{$IFDEF OS2}
Var acnrInfo:CNRINFO;
    Flags:LongWord;
{$ENDIF}
{$IFDEF Win32}
Var WinStyle:LongWord;
{$ENDIF}
Begin
     If Handle=0 Then Exit;

     {$IFDEF OS2}
     FillChar(acnrInfo,SizeOf(CNRINFO),0);
     Flags:=CMA_FLWINDOWATTR;

     With acnrInfo Do
     Begin
          cb:=SizeOf(CNRINFO);
          flWindowAttr:=CV_ICON;
          slBitmapOrIcon.CX:=FBitmapSize.CX;
          slBitmapOrIcon.CY:=FBitmapSize.CY;
          Flags:=Flags Or CMA_SLBITMAPORICON;
          flWindowAttr:=flWindowAttr Or CA_DRAWBITMAP;
     End;
     WinSendMsg(Handle,CM_SETCNRINFO,LongWord(@acnrInfo),Flags);
     {$ENDIF}
     {$IFDEF Win32}
     WinStyle:=GetWindowLong(Handle,GWL_STYLE);
     If Not FMultipleSel Then WinStyle:=WinStyle Or LVS_SINGLESEL;
     SetWindowLong(Handle,GWL_STYLE,WinStyle);
     Invalidate;
     {$ENDIF}
End;


Procedure TListView.GetClassData(Var ClassData:TClassData);
Begin
     Inherited GetClassData(ClassData);

     {$IFDEF OS2}
     ClassData.ClassULong := WC_CONTAINER;
     {$ENDIF}
     {$IFDEF Win32}
     CreateSubClass(ClassData,WC_LISTVIEW);
     {$ENDIF}
End;

Procedure TListView.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     {$IFDEF OS2}
     Params.Style := Params.Style Or CCS_AUTOPOSITION;
     If FMultipleSel Then Params.Style := Params.Style Or CCS_MULTIPLESEL
     Else Params.Style := Params.Style Or CCS_SINGLESEL;
     {$ENDIF}
     {$IFDEF Win32}
     Params.Style := Params.Style Or LVS_AUTOARRANGE;
     Params.Style := Params.Style Or WS_CHILD Or LVS_ICON;
     If Not FMultipleSel Then Params.Style:=Params.Style Or LVS_SINGLESEL;

     If FBorderStyle = bsSingle Then
     Begin
          Params.Style := Params.Style Or WS_BORDER;             {Single}
          Params.ExStyle := Params.ExStyle Or WS_EX_CLIENTEDGE;  {Double}
     End;
     {$ENDIF}
End;

Procedure TListView.SetupImageList;
{$IFDEF Win32}
Var  Count:LongInt;
     T:LongInt;
     Bitmap:TListViewBitmap;
     BitHandle:LongWord;
{$ENDIF}
Begin
     {$IFDEF Win32}
     If Handle=0 Then Exit;
     If FPictureList=Nil Then Exit;

     Count:=FPictureList.Count;

     If Count=0 Then Exit;

     If FHim<>Nil Then ImageList_Destroy(FHim);

     FHim:=ImageList_Create(FBitmapSize.CX,
                            FBitmapSize.CY,
                            ILC_COLOR4,Count,0);

     For T:=0 To FPictureList.Count-1 Do
     Begin
          Bitmap:=TListViewBitmap(FPictureList.Bitmaps[T]);
          BitHandle:=Bitmap.CreateBitmapFromClass(FBitmapSize.CX,FBitmapSize.CY);
          Bitmap.FHimlIndex:=ImageList_AddIcon(FHim,BitHandle);
          DeleteObject(BitHandle);
     End;

     SendMessage(Handle,LVM_SETIMAGELIST,LVSIL_NORMAL,LongWord(FHim));
     {$ENDIF}
End;

Procedure SetupNode(Node:TListViewNode);
Begin
     {$IFDEF OS2}
     Node.FTreeRec^.RecordCore.pszIcon := Node.FCaption;
     If Node.FBitmap<>Nil Then
       Node.FTreeRec^.RecordCore.hbmBitmap:=Node.FBitmap.Handle
     Else
       Node.FTreeRec^.RecordCore.hbmBitmap:=0;
     //Node.FTreeRec^.RecordCore.ptlIcon.X:=20;
     //Node.FTreeRec^.RecordCore.ptlIcon.Y:=20;
     {$ENDIF}
     {$IFDEF Win32}
     Node.FTreeRec^.RecordCore.Mask:=LVIF_TEXT Or LVIF_IMAGE Or LVIF_PARAM;
     Node.FTreeRec^.RecordCore.iItem:=Node.Index;
     Node.FTreeRec^.RecordCore.iSubItem:=0;
     Node.FTreeRec^.RecordCore.State:=0;
     Node.FTreeRec^.RecordCore.StateMask:=0;
     Node.FTreeRec^.RecordCore.pszText:=Node.FCaption;
     Node.FTreeRec^.RecordCore.cchTextMax:=Length(Node.FCaption^)+1;
     If Node.FBitmap<>Nil Then
       Node.FTreeRec^.RecordCore.iImage:=TListViewBitmap(Node.FBitmap).FHimlIndex
     Else
       Node.FTreeRec^.RecordCore.iImage:=0;
     Node.FTreeRec^.RecordCore.LParam:=LongWord(Node);
     {$ENDIF}
End;



Procedure TListView.SetupList;
Var T:LongInt;
    Node,PrevNode:TListViewNode;
    P:Pointer;
Begin
     If Handle=0 Then Exit;
     If FInitNodes=Nil Then Exit;
     {Create All main Nodes}
     PrevNode:=Nil;
     For T:=0 To FNodes.Count-1 Do
     Begin
          Node:=FNodes.Items[T];
          If Node.FTreeRec=Nil Then
          Begin
               AllocateRecord(Handle,Node.FTreeRec);
               SetupNode(Node);
          End;

          If PrevNode=Nil
          Then
          Begin
              LongWord(P):=CMA_FIRST;
              InsertRecord(Node,Nil,P);
          End
          Else InsertRecord(Node,Nil,Pointer(PrevNode.FTreeRec));
          PrevNode:=Node;
     End;
     FInitNodes:=Nil;
End;


Procedure TListView.CreateWnd;
Begin
     Inherited CreateWnd;

     If Handle=0 Then Exit;
     {Set Options}
     SetCnrInfo;
     SetupImageList;
     SetupList;
End;

Procedure TListView.SetupComponent;
Begin
     Inherited SetupComponent;

     FBitmapSize.CX:=0;
     FBitmapSize.CY:=0;

     FNodeClass := TListViewNode;
     Ownerdraw := False;
     Height:=150;
     Width:=150;
     color:=clWindow;
     ParentPenColor:=False;
     ParentColor:=False;
     FBorderStyle:=bsSingle;
End;


{$IFDEF OS2}
Procedure TListView.SetupShow;
Begin
     Inherited SetupShow;
     CreateCanvas;
End;


Procedure TListView.WMPaint(Var Msg:TMessage);
Var  rc1,rcupdate:TRect;
Begin
     If FBorderStyle = bsSingle Then
     Begin {Exclude border from Redraw area}
          rc1 := ClientRect;
          {????????+-1}
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


Procedure TListView.SetBorderStyle(NewBorder:TBorderStyle);
Begin
     FBorderStyle := NewBorder;
     {$IFDEF OS2}
     Invalidate;
     {$ENDIF}
     {$IFDEF Win32}
     RecreateWnd;
     {$ENDIF}
End;

Procedure TListView.Clear;
Var  T:LongInt;
     Node:TListViewNode;
Begin
    {Store Tree Items -> Linear List}
    If FNodes<>Nil Then
    Begin
         For t:=FNodes.Count-1 Downto 0 Do
         Begin
             Node:=FNodes[t];
             Node.Destroy;
         End;
         FNodes.Destroy;
         FNodes:=Nil;
    End;
End;

Procedure TListView.BeginUpdate;
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


Procedure TListView.EndUpdate;
Begin
     Dec(FUpdateCount);
     If FUpdateCount = 0 Then
     Begin
          If Handle <> 0 Then
          {$IFDEF OS2}
          WinEnableWindowUpdate(Handle,True);
          {$ENDIF}
          {$IFDEF Win32}
          SendMessage(Handle,WM_SETREDRAW, 1, 0);
          {$ENDIF}
          Invalidate;
     End;
End;

Procedure TListView.DestroyWnd;
Begin
     Clear;
     Inherited DestroyWnd;
End;


Destructor TListView.Destroy;
Begin
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

Function TListView.AddPicture(NewBitmap:TBitmap):TBitmap;

Var idx:LongInt;
    bmp : tBitmap;
    ico : tIcon;
    rec : trect;

Begin
     If NewBitmap = Nil Then
     Begin
          Result := Nil;
          Exit;
     End;

     If FPictureList = Nil Then
     Begin
          FPictureList.Create;
          FPictureList.BitmapClass := TListViewBitmap;
          FPictureList.Duplicates := False;
     End;

     idx := FPictureList.IndexOfOrigin(NewBitmap);

     If idx < 0 Then                                     {Not found}
     Begin
       idx := FPictureList.Add(NewBitmap);  {Create local Bitmap}
       SetupImageList;
     End;
     Result := FPictureList.Bitmaps[idx];
End;

Procedure TListView.SetSorted(NewValue:Boolean);
Var Nodes:TList;
    t:Longint;
    Node:TListViewNode;
Begin
    If NewValue=FSorted Then exit;

    FSorted:=NewValue;

    If Sorted Then //resort
      If FNodes<>Nil Then
    Begin
       BeginUpdate;

       Nodes:=FNodes;

       FNodes:=Nil;
       For t:=Nodes.Count-1 Downto 0 Do
       Begin
           Node:=Nodes[t];
           Add(Node.Text,Node.Data,Node.FBitmap);
           Node.Destroy;
       End;
       Nodes.Destroy;

       EndUpdate;
    End;
End;

Function TListView.Add(Const Text:String;Data:Pointer;Bitmap:TBitmap):TListViewNode;
Var  NewNode,PrevNode,Node:TListViewNode;
     P:Pointer;
     t,t1:LongInt;
Begin
     NewNode := FNodeClass.Create(Self);
     NewNode.Data := Data;
     NewNode.Text := Text;
     NewNode.FBitmap:=AddPicture(Bitmap);
     If Bitmap<>Nil Then
     Begin
        If FBitmapSize.CX=0 Then FBitmapSize.CX:=Bitmap.Width;
        If FBitmapSize.CY=0 Then FBitmapSize.CY:=Bitmap.Height;
     End;

     If FNodes=Nil Then FNodes.Create;
     If Sorted Then
     Begin
        NewNode.FIndex:=FNodes.Count;
        For t:=0 To FNodes.Count-1 Do
        Begin
            Node:=FNodes[t];
            If Node.Text>Text Then
            Begin
                NewNode.FIndex:=Node.FIndex;
                For t1:=t To FNodes.Count-1 Do
                Begin
                    Node:=TListViewNode(FNodes[t1]);
                    inc(Node.FIndex);
                End;
                break;
            End;
        End;

        FNodes.Insert(NewNode.FIndex,NewNode);
     End
     Else
     Begin
        NewNode.FIndex:=FNodes.Count;
        FNodes.Add(NewNode);
     End;

     If Handle=0 Then FInitNodes:=FNodes
     Else
     Begin
          If FNodes.Count=1 Then PrevNode:=Nil
          Else PrevNode:=FNodes.Items[NewNode.FIndex-1];

          If NewNode.FTreeRec=Nil Then
          Begin
               AllocateRecord(Handle,NewNode.FTreeRec);
               SetupNode(NewNode);
          End;

          If PrevNode=Nil
          Then
          Begin
              LongWord(P):=CMA_FIRST;
              InsertRecord(NewNode,Nil,P);
          End
          Else InsertRecord(NewNode,Nil,Pointer(PrevNode.FTreeRec));
     End;
     Result := NewNode;
End;

Function TListView.Get(Index:LongInt):TListViewNode;
Begin
     Result:=FNodes.Items[Index];
End;

Function TListView.GetItemCount:LongInt;
Begin
     If FNodes=Nil Then Result:=0
     Else Result:=FNodes.Count;
End;

{$HINTS OFF}
Procedure TListView.ItemSelect(Index:LongInt);
Begin
     If Assigned(OnItemSelect) Then OnItemSelect(Self,Index);
End;
{$HINTS ON}


Procedure TListView.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     Case KeyCode Of
       kbCUp,kbCDown,kbCLeft,kbCRight:
       Begin
            ; {!}
       End
       Else Inherited ScanEvent(KeyCode,RepeatCount);
     End;
End;

Procedure TListView.ParentNotification(Var Msg:TMessage);
{$IFDEF OS2}
Var  Node:TListViewNode;
     RecordCore:PListViewRecord;
     RecEnter:PNOTIFYRECORDENTER;
{$ENDIF}
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

            If Node Is TListViewNode Then ItemSelect(Node.Index);
       End;
       CN_CONTEXTMENU:
       Begin
            If Designed Then Exit;
            CheckMenuPopup(FPopupPos);
       End;
       Else Inherited ParentNotification(Msg);
     End;
     {$ENDIF}

     {$IFDEF Win32}
     Inherited ParentNotification(Msg);
     {$ENDIF}
End;

Function TListView.GetItemIndex:LongInt;
{$IFDEF OS2}
Var RecordCore:PListViewRecord;
{$ENDIF}
{$IFDEF WIN32}
Var t:LongInt;
{$ENDIF}
Begin
     Result:=-1;
     If Handle=0 Then Exit;
     {$IFDEF OS2}
     RecordCore:=Pointer(WinSendMsg(Handle,CM_QUERYRECORDEMPHASIS,
                         CMA_FIRST,CRA_SELECTED));
     If RecordCore<>Nil Then Result:=RecordCore^.Node.Index;
     {$ENDIF}
     {$IFDEF WIN32}
     For t:=0 To ItemCount-1 Do
     Begin
           If SendMessage(Handle,LVM_GETITEMSTATE,t,LVIS_SELECTED OR LVIS_FOCUSED)<>0 Then
           Begin
                Result:=t;
                exit;
           End;
     End;
     {$ENDIF}
End;

Procedure TListView.SetItemIndex(NewValue:LongInt);
{$IFDEF WIN32}
Var Item:LV_ITEM;
{$ENDIF}
Begin
     If Handle=0 Then Exit;
     If ((NewValue<0)Or(NewValue>FNodes.Count-1)) Then Exit;

     {$IFDEF OS2}
     WinSendMsg(Handle,CM_SETRECORDEMPHASIS,LongWord(Items[NewValue].FTreeRec),
                MPFROM2SHORT(1,CRA_SELECTED));
     {$ENDIF}
     {$IFDEF WIN32}
     Item.StateMask:=LVIS_SELECTED;
     Item.State:=LVIS_SELECTED;
     SendMessage(Handle,LVM_SETITEMSTATE,NewValue,LongWord(@Item));
     {$ENDIF}
End;

Function TListView.NodeFromPoint(pt:TPoint):TListViewNode;
Var t:LongInt;
    rec:TRect;
Begin
    For t:=0 To ItemCount-1 Do
    Begin
        result:=Items[t];
        rec:=result.ItemRect;
        If ((pt.X>=rec.Left)And(pt.X<=rec.Right)) Then
          If ((pt.Y>=rec.Bottom)And(pt.Y<=rec.Top)) Then exit;
    End;
    result:=Nil;
End;

Procedure TListView.DrawDragRect;
Begin
     If Canvas = Nil Then Exit;
     Canvas.Pen.Mode:=pmNot;
     Canvas.Pen.color:=clBlack;
     Canvas.Pen.Style:=psDot;
     Canvas.Rectangle(FDragRect);
     Canvas.Pen.Mode:=pmCopy;
End;

Procedure TListView.DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:Boolean);
Var Node:TListViewNode;
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

Procedure TListView.DragDrop(Source:TObject;X,Y:LongInt);
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

Function TListView.GetSelect(Index:LongInt):Boolean;
{$IFDEF OS2}
Var RecordCore:PListViewRecord;
    Start:LongWord;
{$ENDIF}
{$IFDEF WIN32}
Var Start,Index1:LongInt;
{$ENDIF}
Begin
     Result:=False;
     If Handle=0 Then Exit;
     If ((Index<0)Or(Index>FNodes.Count-1)) Then Exit;


     {$IFDEF OS2}
     If Index=0 Then Start:=CMA_FIRST
     Else Start:=LongWord(Items[Index-1].FTreeRec);

     RecordCore:=Pointer(WinSendMsg(Handle,CM_QUERYRECORDEMPHASIS,
                         Start,CRA_SELECTED));
     If RecordCore<>Nil Then
     Begin
         If Start=CMA_FIRST Then
         Begin
              If RecordCore^.Node=Items[0].FTreeRec^.Node Then Result:=True;
         End
         Else
         Begin
              If RecordCore^.Node=Items[Index].FTreeRec^.Node Then Result:=True;
         End;
     End;
     {$ENDIF}
     {$IFDEF WIN32}
     If Index=0 Then Start:=-1
     Else Start:=Index;

     Index1:=SendMessage(Handle,LVM_GETNEXTITEM,Start,MakeLParam(LVNI_ALL Or LVNI_SELECTED,0));
     If Index1=Index Then Result:=True;
     {$ENDIF}
End;

Procedure TListView.SetSelect(Index:LongInt;NewValue:Boolean);
Var Value:LongInt;
Begin
     If Handle=0 Then Exit;
     If ((Index<0)Or(Index>FNodes.Count-1)) Then Exit;

     If NewValue Then Value:=1
     Else Value:=0;

     {$IFDEF OS2}
     WinSendMsg(Handle,CM_SETRECORDEMPHASIS,LongWord(Items[Index].FTreeRec),
                MPFROM2SHORT(Value,CRA_SELECTED));
     {$ENDIF}
End;


Procedure TListView.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     If OnMouseClick <> Nil Then OnMouseClick(Self,Button,ShiftState,X,Y);
     {no Inherited because Of CN_CONTEXTMENU, but Store the mouse Pos}
     FPopupPos := Point(X,Y);
End;

{$IFDEF WIN32}
Procedure TListView.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
{$IFDEF Win32}
Var Index:LongInt;
    HitTest:LV_HITTESTINFO;
    pt:TPoint;
{$ENDIF}
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);
     LastMsg.CallDefaultHandler;
     If Button=mbLeft Then
     Begin
          {$IFDEF Win32}
          pt:=Point(X,Y);
          TransformClientPoint(pt,Self); // ,Nil);
          HitTest.pt:=pt;
          HitTest.Flags:=LVHT_ONITEMICON;
          Index:=SendMessage(Handle,LVM_HITTEST,0,LongWord(@HitTest));
          If Index<>-1 Then ItemSelect(Index);
          {$ENDIF}
     End;
End;
{$ENDIF}

Begin
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  27-Sep-02  WD         Ausbau der LINUX-Teile
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  03-Okt-06  KF         TListView.Add: Statt Bitmap.Height Width verwenden
}

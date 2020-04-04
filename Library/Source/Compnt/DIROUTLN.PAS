
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit DirOutLn;

Interface

Uses
  SysUtils, Classes, Graphics, StdCtrls, Forms, Dialogs,
  Outline,
  uList;

type
  TDirectoryOutline=Class(TOutline)
     Private
        FDirectory:String;
        FDrive:Char;
        FOnChange:TNotifyEvent;
        FlOpen,FlClose:TBitmap;
     Private
        Procedure SetDrive(NewDrive:Char);
        Procedure SetDirectory(Const NewDir:String);
        Procedure FillLevel(Node:TOutlineNode);
     Protected
        Procedure BuildTree;Virtual;
        Procedure WalkTree(Const Dir:String);
        Procedure SetupShow;Override;
        Procedure Expand(Index: Longint);Override;
        Procedure BuildOneLevel(ParentLevel:Longint);Virtual;
        Procedure Change;Virtual;
     Public
        Procedure SetupComponent;Override;
        Destructor Destroy;Override;
        Procedure Click;Override;
     Public
        Property Drive:Char read FDrive write SetDrive;
        Property Directory:String  read FDirectory write SetDirectory;
        Property Lines;
        Property OnChange:TNotifyEvent read FOnChange write FOnChange;
  End;

Implementation

{$R DirOutLn}

Procedure TDirectoryOutline.Change;
Begin
   If FOnChange<>Nil Then FOnChange(Self);
End;

Procedure TDirectoryOutline.FillLevel(Node:TOutlineNode);
Var
  TempIndex:Longint;
  Root:ShortString;
  SearchRec: TSearchRec;
  Status:Integer;
  s,s1:String;
Begin
   If Node.Data<>Nil Then exit; //already filled
   Root:=Node.FullPath;
   If Root[Length(Root)] In ['\','/'] Then dec(Root[0]);

   Status:=FindFirst(Root+'\*.*',faDirectory,SearchRec);
   While Status=0 Do
   Begin
     If SearchRec.Attr And faDirectory = faDirectory Then
     Begin
       If ((SearchRec.Name<>'.')And(SearchRec.Name<>'..')) Then //no .. and .
       Begin
          If Node.HasItems Then //must sort
          Begin
            TempIndex:=Node.GetFirstChild;
            s:=SearchRec.Name;
            UpcaseStr(s);
            If TempIndex<>-1 Then
            Begin
                 s1:=Items[TempIndex].Text;
                 UpcaseStr(s1);
            End;
            While (TempIndex<>-1)And(s1<s) Do
            Begin
                TempIndex:=Node.GetNextChild(TempIndex);
                If TempIndex<>-1 Then
                Begin
                   s1:=Items[TempIndex].Text;
                   UpcaseStr(s1);
                End;
            End;
            If TempIndex<>-1 Then Insert(TempIndex, SearchRec.Name)
            Else Add(Node.GetLastChild, SearchRec.Name);
          End
          Else AddChild(Node.Index,SearchRec.Name);
        End;
     End;
     Status:=FindNext(SearchRec);
   End;

   Node.Data:=Pointer(1); //mark item as processed
end;


Procedure TDirectoryOutline.BuildOneLevel(ParentLevel:Longint);
Var Index:LongInt;
    RootNode:TOutlineNode;
    FList:TList;
    t:longint;
Begin
   FillLevel(Items[ParentLevel]);

   RootNode := Items[ParentLevel];
   FList.Create;
   Index:=RootNode.GetFirstChild;
   While Index<>-1 Do
   Begin
        FList.Add(Items[Index]);
        Index:=RootNode.GetNextChild(Index);
   End;

   For t:=0 To FList.Count-1 Do FillLevel(TOutlineNode(FList[t]));
   FList.Destroy;
End;

Procedure TDirectoryOutline.SetupComponent;
Begin
  Inherited SetupComponent;
  BorderStyle:=bsNone;
  FlOpen.Create;
  FlOpen.LoadFromResourceName('FolderOpen');
  FlClose.Create;
  FlClose.LoadFromResourceName('FolderClose');
  PictureOpen:=FlOpen;
  PictureClosed:=FlClose;
  PictureLeaf:=PictureClosed;
  PlusMinusSize.CX:=14;
  PlusMinusSize.CY:=14;
  ShowPlusMinus:=False;
End;

Destructor TDirectoryOutline.Destroy;
Begin
   Inherited Destroy;

   FlOpen.Destroy;
   FlClose.Destroy;
End;

Procedure TDirectoryOutline.Click;
Begin
  inherited Click;
  Try
    If SelectedItem=-1 Then Beep(1200,400);
    Directory :=Items[SelectedItem].FullPath;
  Except
  End;
End;

Procedure TDirectoryOutline.SetDrive(NewDrive:Char);
Begin
   FDrive:=Upcase(NewDrive);
   ChDir(FDrive+':');
   GetDir(0,FDirectory);
   If Not (csLoading In ComponentState) Then BuildTree;
End;

Procedure TDirectoryOutline.SetDirectory(Const NewDir:String);
Var
  TempPath: ShortString;
  Node:TOutlineNode;
  t:LongInt;

  Function FindNode(Node:TOutlineNode):TOutlineNode;
  Var s:String;
      t:LongInt;
      Node1:TOutlineNode;
  Begin
      s:=Node.FullPath;
      UpcaseStr(s);
      If s=TempPath Then
      Begin
          result:=Node;
          exit;
      End;

      For t:=0 To Node.ItemCount-1 Do
      Begin
          Node1:=Node.Items[t];
          Node1:=FindNode(Node1);
          If Node1<>Nil Then
          Begin
               Result:=Node1;
               exit;
          End;
      End;
      Result:=Nil;
  End;

Begin
  If ((NewDir='')Or(NewDir=FDirectory)) Then exit;

  TempPath := ExpandFileName(NewDir);
  If TempPath[Length(TempPath)] In ['\','/'] Then
    If Length(TempPath)>3 Then Dec(TempPath[0]);

  ChDir(TempPath);
  FDirectory:=TempPath;
  If FDirectory[1]<>Drive Then Drive:=FDirectory[1]
  Else
  Begin
      WalkTree(TempPath);
      Change;
  End;

  TempPath:=FDirectory;
  UpcaseStr(TempPath);
  For t:=0 To ItemCount-1 Do
  Begin
       Node:=Items[t];
       Node:=FindNode(Node);
       If Node<>Nil Then Break;
  End;
  If Node<>Nil Then
   If SelectedNode<>Node Then SelectedNode:=Node;
End;

Procedure TDirectoryOutline.SetupShow;
Var CurDir:String;
Begin
  Inherited SetupShow;

  If FDrive=#0 Then  //test if unassigned
  Begin
    {$I-}
    GetDir(0, CurDir);
    {$I+}
    If IoResult<>0 Then exit;
    FDrive := Upcase(CurDir[1]);
    FDirectory := CurDir;
  End;

  BuildTree;
End;

Procedure TDirectoryOutline.BuildTree;
Var
  RootIndex: Longint;
Begin
  Clear;
  If FDrive=#0 Then exit;
  RootIndex:=AddChild(0,Drive+':');
  WalkTree(FDirectory);
  Change;
End;

Procedure TDirectoryOutline.WalkTree(Const Dir:String);
Var
  b:LongInt;
  CurPath,NextDir,s:ShortString;
  TempItem,TempIndex: Longint;
begin
  TempItem := 1; { start at root }

  CurPath := Dir;
  b:=Pos(':',CurPath);
  If b>0 then CurPath:=Copy(CurPath,b+1,255);
  If CurPath<>'' Then
    If CurPath[1]='\' Then System.Delete(CurPath,1,1);

  NextDir := CurPath;
  Repeat
    b:=Pos('\',CurPath);
    If b=0 Then b:=Pos('/',CurPath);
    If b > 0 then
    Begin
      NextDir:=Copy(CurPath,1,b-1);
      CurPath:=Copy(CurPath,b+1,255);
    End
    Else
    Begin
      NextDir:=CurPath;
      CurPath:='';
    End;

    Items[TempItem].Expanded:=True;
    TempIndex:=Items[TempItem].GetFirstChild;
    UpcaseStr(NextDir);
    If CurPath='' Then TempIndex:=-1
    Else While TempIndex<>-1 Do
    Begin
      s:=Items[TempIndex].Text;
      UpcaseStr(s);
      If s=NextDir Then Break;
      TempIndex:=Items[TempItem].GetNextChild(TempIndex);
    End;
    If TempIndex<>-1 Then TempItem:=TempIndex
    Else CurPath:=''; //break
  Until CurPath='';
End;

Procedure TDirectoryOutline.Expand(Index:Longint);
Begin
  BuildOneLevel(Index);
  Inherited Expand(Index);
End;

initialization
   RegisterClasses([TDirectoryOutline]);
end.

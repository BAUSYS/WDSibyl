Unit uList;

Interface

Uses SysUtils, uStream;

Const
  MaxListSize = MaxLongInt Div SizeOf(Pointer);

Type
  EListError = Class(Exception);

{TList Class}
  TList = Class;
  PPointerList = ^TPointerList;
  TPointerList = Array[0..MaxListSize-1] Of Pointer;
  TListSortCompare = Function(Item1,Item2: Pointer):LongInt;

  TFreeListItem = Procedure(Sender:TObject;Item:Pointer) Of Object;

  pList = ^tList;
  TList = Class
    Private
      FList:PPointerList;
      FCount:LongInt;
      FCapacity:LongInt;
      FGrowth:LongInt;
      FOnFreeItem:TFreeListItem;
      Function Get(Index:LongInt):Pointer;
      Procedure Put(Index:LongInt;Item:Pointer);
      Procedure SetCount(NewCount:LongInt);
    Protected
      Procedure Error; Virtual;
      Procedure Grow; Virtual;
      Procedure SetCapacity(NewCapacity:LongInt); Virtual;
      Procedure FreeItem(Item:Pointer); Virtual;
    Public
      Destructor Destroy; Override;
      Procedure Clear; Virtual;
      Function Add(Item:Pointer):LongInt;
      Procedure Delete(Index:LongInt);
      Function Remove(Item:Pointer):LongInt;
      Procedure Cut(Index1,Index2:LongInt);
      Procedure Insert(Index:LongInt;Item:Pointer);
      Procedure Exchange(Index1,Index2:LongInt);
      Procedure Move(CurIndex,NewIndex:LongInt);
      Function IndexOf(Item:Pointer):LongInt;
      Function First:Pointer;
      Function Last:Pointer;
      Function Expand:TList;
      Procedure Pack;
      Procedure Sort(Compare: TListSortCompare);
    Public
      Property  Capacity:LongInt Read FCapacity Write SetCapacity;
      Property  Count:LongInt Read FCount Write SetCount;
      Property  Growth:LongInt Read FGrowth Write FGrowth;
      Property  Items[Index:LongInt]:Pointer Read Get Write Put; Default;
      Property  List:PPointerList Read FList;
      Property  OnFreeItem:TFreeListItem Read FOnFreeItem Write FOnFreeItem;
  End;

{TChainList Class}
  PChainListItem = ^TChainListItem;
  TChainListItem = Record
                     Prev:PChainListItem;
                     Item:Pointer;
                     Next:PChainListItem;
                   End;

  TChainList = Class(TObject)
    Private
      FList:PChainListItem;
      FListEnd:PChainListItem;
      FCount:LongInt;
      FOnFreeItem:TFreeListItem;
    Private
      Function Index2PLE(Index:LongInt):PChainListItem;
      Function Item2PLE(Item:Pointer):PChainListItem;
      Function PLE2Index(ple:PChainListItem):LongInt;
      Function Item2Index(Item:Pointer):LongInt;
      Procedure Connect(ple1,ple2:PChainListItem);
      Function Get(Index:LongInt):Pointer;
      Procedure Put(Index:LongInt;Item:Pointer);
    Protected
      Procedure Error; Virtual;
      Procedure FreeItem(Item:Pointer); Virtual;
    Public
      Destructor Destroy; Override;
      Procedure Clear; Virtual;
      Function Add(Item:Pointer):LongInt;
      Function Remove(Item:Pointer):LongInt;
      Procedure Delete(Index:LongInt);
      Function First:Pointer;
      Function Last:Pointer;
      Function IndexOf(Item:Pointer):LongInt;
      Procedure Insert(Index:LongInt;Item:Pointer);
      Procedure Move(CurIndex,NewIndex:LongInt);
      Procedure Exchange(Index1,Index2:LongInt);
      Procedure Pack;
    Public
      Property  Count:LongInt Read FCount;
      Property  Items[Index:LongInt]:Pointer Read Get Write Put; Default;
      Property  OnFreeItem:TFreeListItem Read FOnFreeItem Write FOnFreeItem;
  End;

type
  tArrayPointer = Class
    private
      fColCount  : LongInt;
      fColMem    : LongWord;
      fRowList   : tList;
      fOnFreeItem: tFreeListItem;

      Procedure setColCount(iColCount : LongInt);
      Function getRowCount : LongInt;
      Function getRow(iIndex : LongInt) : pPointerArray;

      Procedure RowListFreeItem(iSender: TObject; iRow:Pointer);
    public
      Constructor Create; virtual;
      Destructor Destroy; override;
      Procedure Clear;
      Function AddList(iList : tList) : LongInt;
{      Function Add(iRow : pPointerArray) : LongInt; }
      Function Add : pPointerArray;
      Procedure Delete(iIndex : LongInt);

      Property ColCount   : LongInt  Read fColCount Write setColCount;
      Property ColMem     : LongWord Read fColMem;
      Property RowCount   : LongInt  Read getRowCount;
      Property Row[iIndex : LongInt] : pPointerArray Read getRow;

      Property OnFreeItem : tFreeListItem Read fOnFreeItem Write fOnFreeItem;
  end;

Type
  tcArray2DFix = Class
    private
      fCol, fRow : LongInt;
      fResetValue: LongWord;
      fMemorySize: LongWord;
      fMemory    : pLongWordArray;

      Function GetMemoryPos(iCol, iRow : LongInt) : LongWord;

      Procedure SetItems(Col, Row : LongInt; Value : LongWord);
      Function GetItems(Col, Row : LongInt) : LongWord;

    public
      Constructor Create(iCol, iRow : LongInt; iResetValue : LongWord); virtual;
      Destructor Destroy; override;
      Procedure Clear;

      Property Memory : pLongWordArray Read fMemory;
      Property ResetValue : LongWord Write fResetValue Read fResetValue;
      Property Items[Col, Row : LongInt] : LongWord Write SetItems Read GetItems;
  End;

{ ----------------------------------------------------------------------------- }

  tcMemoryStreamList = Class(tList)
    Private
      Function GetItems(iIndex:LongInt): tMemoryStream;
      Function GetSize : LongInt;

      Procedure DestroyMemoryStream(iMemoryStream : pMemorystream);
      Function CheckItems(iIndex:LongInt): Boolean;

    Public
      Function Add(iMemoryStream: tMemoryStream): LongInt; virtual;
      Procedure Delete(Index: LongInt); virtual;
      Procedure Cut(Index1, Index2: LongInt); virtual;

      Procedure Clear; virtual;

      Function First: tMemoryStream;
      Function Last : tMemoryStream;

      Property Items[Index:LongInt]: tMemoryStream Read GetItems; Default;
      Property Size : LongInt Read GetSize;
      Property Count;
  End;


  tcLongWordList = Class(tList)
    Private
      Function GetItems(iIndex:LongInt): LongWord; virtual;
      Procedure PutItems(iIndex:LongInt; iValue : LongWord);
    Public
      Procedure Insert(iIndex: LongInt; iValue: LongWord); virtual;
      Function Add(iValue : LongWord): LongInt; virtual;
      Function Sum : LongWord;

      Function First: LongWord;
      Function Last : LongWord;

      Property Items[Index:LongInt]: LongWord Read GetItems Write PutItems; Default;
  End;

  tcLongIntList = Class(tList)
    Private
      Function GetItems(iIndex:LongInt): LongInt; virtual;
      Procedure PutItems(iIndex:LongInt; iValue : LongInt);
    Public
      Procedure Insert(iIndex: LongInt; iValue: LongInt); virtual;
      Function Add(iValue : LongInt): LongInt; virtual;
      Function Sum : LongInt;

      Function First: LongInt;
      Function Last : LongInt;

      Property Items[Index:LongInt]: LongInt Read GetItems Write PutItems; Default;
  End;

{ ----------------------------------------------------------------------------- }

Implementation

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: tcLongIntList                                                     บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function tcLongIntList.Sum : LongWord;

var cou : LongInt;

Begin
  result:=0;
  for cou:=0 to Count-1 do
    result:=result+GetItems(Cou);
End;

Procedure tcLongIntList.Insert(iIndex: LongInt; iValue: LongInt);

var p : Pointer absolute iValue;

Begin
  inherited Insert(iIndex, p);
End;

Function tcLongIntList.Add(iValue : LongInt): LongInt;

var p : Pointer absolute iValue;

Begin
  inherited Add(p);
End;

Procedure tcLongIntList.PutItems(iIndex:LongInt; iValue : LongInt);

var p : Pointer absolute iValue;

Begin
  inherited Items[iIndex]:=p;
End;

Function tcLongIntList.GetItems(iIndex:LongInt): LongInt;

var p : Pointer absolute Result;

Begin
  p:=inherited Items[iIndex];
End;


Function tcLongIntList.First: LongInt;

var p : Pointer absolute Result;

Begin
  p:=inherited First;
End;

Function tcLongIntList.Last : LongInt;

var p : Pointer absolute Result;

Begin
  p:=inherited Last;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: tcLongWordList                                                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function tcLongWordList.Sum : LongWord;

var cou : LongInt;

Begin
  result:=0;
  for cou:=0 to Count-1 do
    result:=result+GetItems(Cou);
End;

Procedure tcLongWordList.Insert(iIndex: LongInt; iValue: LongWord);

var p : Pointer absolute iValue;

Begin
  inherited Insert(iIndex, p);
End;

Function tcLongWordList.Add(iValue : LongWord): LongInt;

var p : Pointer absolute iValue;

Begin
  inherited Add(p);
End;

Procedure tcLongWordList.PutItems(iIndex:LongInt; iValue : LongWord);

var p : Pointer absolute iValue;

Begin
  inherited Items[iIndex]:=p;
End;

Function tcLongWordList.GetItems(iIndex:LongInt): LongWord;

var p : Pointer absolute Result;

Begin
  p:=inherited Items[iIndex];
End;


Function tcLongWordList.First: LongWord;

var p : Pointer absolute Result;

Begin
  p:=inherited First;
End;

Function tcLongWordList.Last : LongWord;

var p : Pointer absolute Result;

Begin
  p:=inherited Last;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TList                                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TList.Error;
Begin
  Raise EListError.Create(LoadNLSStr(SListErrorText));
End;


Function TList.Get(Index:LongInt):Pointer;
Begin
  Result := Nil;
  If (Index < 0) Or (Index >= FCount)
    Then Error
    Else Result := FList^[Index];
End;


Procedure TList.Put(Index:LongInt;Item:Pointer);
Begin
     If (Index < 0) Or (Index >= FCount) Then Error
     Else FList^[Index] := Item;
End;


Procedure TList.Grow;
Var  gr:LongInt;
Begin
     If FGrowth <= 0 Then
     Begin
          //If FCapacity < 128 Then gr := 16
          //Else gr := FCapacity Shr 3;
          {Martin0707}
          If FCapacity < 256 Then gr := 64
          Else gr := FCapacity Shr 1;
     End
     Else gr := FGrowth;
     SetCapacity(FCapacity + gr);
End;


Procedure TList.SetCapacity(NewCapacity:LongInt);
Var  NewList:PPointerList;
Begin
     If (NewCapacity > MaxListSize) Or (NewCapacity < FCount) Then Error
     Else
     If NewCapacity <> FCapacity Then
     Begin
          If NewCapacity > 0 Then
          Begin
               GetMem(NewList, NewCapacity*SizeOf(Pointer));
               If FCount > 0 Then System.Move(FList^,NewList^,
                                              FCount*SizeOf(Pointer));
          End
          Else NewList := Nil;
          If FList<>Nil Then FreeMem(FList, FCapacity*SizeOf(Pointer));
          FCapacity := NewCapacity;
          FList := NewList;
     End;
End;


Procedure TList.SetCount(NewCount:LongInt);
Var  I:LongInt;
Begin
     If NewCount=FCount Then Exit;
     If (NewCount > MaxListSize) Or (NewCount < 0) Then Error
     Else
     Begin
          If NewCount > FCapacity Then SetCapacity(NewCount);
          If NewCount < FCount Then
          Begin
               For I := NewCount To FCount-1 Do FreeItem(FList^[I]);
          End
          Else FillChar(FList^[FCount], (NewCount-FCount)*SizeOf(Pointer),0);
          FCount := NewCount;
     End;
End;


{--- Public part ------------------------------------------------------------}

(* Clear the whole List And Destroy the List Object *)
Destructor TList.Destroy;
Begin
     Clear;
     Inherited Destroy;
End;


(* Clear the whole List And Release the allocated Memory *)
Procedure TList.Clear;
Begin
     SetCount(0);
     SetCapacity(0);
End;


(*  Append A New Item At the End Of the List And return the New Index *)
Function TList.Add(Item:Pointer):LongInt;
Begin
     If FCount = FCapacity Then Grow;
     FList^[FCount] := Item;
     Inc(FCount);
     Result := FCount-1;
End;


(* Delete the Item And decrement the Count Of elements In the List *)
Procedure TList.Delete(Index:LongInt);
Begin
     If (Index < 0) Or (Index >= FCount) Then Error
     Else
     Begin
          FreeItem(FList^[Index]);

          Dec(FCount);
          If Index <> FCount Then System.Move(FList^[Index + 1],FList^[Index],
                                              (FCount-Index)*SizeOf(Pointer));
     End;
End;


(* Remove the Item And decrement the Count Of elements In the List *)
Function TList.Remove(Item:Pointer):LongInt;
Begin
     Result := IndexOf(Item);
     If Result <> -1 Then Delete(Result);
End;


(* Release the Memory allocated by the Item *)
Procedure TList.FreeItem(Item:Pointer);
Begin
     If FOnFreeItem <> Nil Then FOnFreeItem(Self,Item);
End;


(* Cut the specified Range out Of the List (including both indices) *)
Procedure TList.Cut(Index1,Index2:LongInt);
Var  I,Swap:LongInt;
Begin
     If (Index1 < 0) Or (Index1 >= FCount) Or
        (Index2 < 0) Or (Index2 >= FCount) Then Error
     Else
     Begin
          If Index2 < Index1 Then
          Begin
               Swap := Index1;
               Index1 := Index2;
               Index2 := Swap;
          End;

          For I := Index1 To Index2 Do FreeItem(FList^[I]);

          If Index2 <> FCount-1 Then System.Move(FList^[Index2+1],FList^[Index1],
                                                 (FCount-Index2)*SizeOf(Pointer));
          Dec(FCount,Index2-Index1+1);
     End;
End;


(* Insert A New Item At the specified Position In the List *)
Procedure TList.Insert(Index:LongInt;Item:Pointer);
Begin
     If (Index < 0) Or (Index > FCount) Then Error
     Else
     Begin
          If FCount = FCapacity Then Grow;
          If Index <> FCount Then System.Move(FList^[Index],FList^[Index+1],
                                              (FCount-Index)*SizeOf(Pointer));
          FList^[Index] := Item;
          Inc(FCount);
     End;
End;


(* Exchange two Items In the List *)
Procedure TList.Exchange(Index1,Index2:LongInt);
Var  Item:Pointer;
Begin
     Item := Get(Index1);
     Put(Index1, Get(Index2));
     Put(Index2, Item);
End;


(* Move an Item To A New Position In the List *)
Procedure TList.Move(CurIndex,NewIndex:LongInt);
Var  Item:Pointer;
Begin
     If (CurIndex < 0) Or (CurIndex >= FCount) Or
        (NewIndex < 0) Or (NewIndex >= FCount) Then Error
     Else
     If CurIndex <> NewIndex Then
     Begin
          Item := FList^[CurIndex];
          If CurIndex < NewIndex
          Then System.Move(FList^[CurIndex+1], FList^[CurIndex],
                           (NewIndex-CurIndex)*SizeOf(Pointer))
          Else System.Move(FList^[NewIndex], FList^[NewIndex+1],
                           (CurIndex-NewIndex)*SizeOf(Pointer));
          FList^[NewIndex] := Item;
     End;
End;


(* return the Index Of an Item *)
Function TList.IndexOf(Item:Pointer):LongInt;
Begin
     For Result := 0 To FCount-1 Do
        If FList^[Result] = Item Then Exit;
     Result := -1;
End;


(* return the First Item In the List *)
Function TList.First:Pointer;
Begin
     Result := Get(0);
End;


(* return the Last Item In the List *)
Function TList.Last:Pointer;
Begin
     Result := Get(FCount-1);
End;


(* Expand the List If Capacity Is reached *)
Function TList.Expand:TList;
Begin
     If FCount = FCapacity Then Grow;
     Result := Self;
End;


(* Remove All Nil elements In the List *)
Procedure TList.Pack;
Var  I:LongInt;
Begin
     For I := FCount-1 DownTo 0 Do
        If FList^[I] = Nil Then Delete(I);
End;


Procedure TList.Sort(Compare: TListSortCompare);

  Procedure Swap(I, K: LongInt);
  Var
    Item: Pointer;
  Begin
    Item := FList^[I];
    FList^[I] := FList^[K];
    FList^[K] := Item;
  End;

  Procedure Reheap(I, K: LongInt);
  Var
    J: LongInt;
  Begin
    J := I;
    While J Shl 1 < K Do
    Begin
      If Compare(FList^[J Shl 1 - 1], FList^[J Shl 1 + 1 - 1]) > 0 Then J := J Shl 1
      Else J := J Shl 1 + 1;
    End;
    If J Shl 1 = K Then J := K;

    While Compare(FList^[I - 1], FList^[J - 1]) > 0 Do J := J Shr 1;

    Swap(I - 1, J - 1);
    J := J Shr 1;

    While J >= I Do
    Begin
      Swap(I - 1, J - 1);
      J := J Shr 1;
    End;
  End;

Var
  I, C: LongInt;
Begin
  C := Count;
  For I := C Shr 1 DownTo 1 Do Reheap(I, C);
  For I := C DownTo 2 Do
  Begin
    Swap(0, I - 1);
    Reheap(1, I - 1);
  End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TChainList                                                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TChainList.Error;
Begin
     Raise EListError.Create(LoadNLSStr(SListErrorText));
End;


Function TChainList.Index2PLE(Index:LongInt):PChainListItem;
Var  I:LongInt;
Begin
     If (Index < 0) Or (Index >= FCount) Then Result := Nil
     Else
     Begin
          Result := FList;
          For I := 0 To Index-1 Do Result := Result^.Next;
          If Result = Nil Then Exit;
     End;
End;


Function TChainList.Item2PLE(Item:Pointer):PChainListItem;
Begin
     Result := FList;
     While Result <> Nil Do
     Begin
          If Result^.Item = Item Then Exit;
          Result := Result^.Next;
     End;
End;


Function TChainList.PLE2Index(ple:PChainListItem):LongInt;
Var  ple1:PChainListItem;
Begin
     Result := -1;
     ple1 := FList;
     While ple1 <> Nil Do
     Begin
          Inc(Result);
          If ple1 = ple Then Exit;
          ple1 := ple1^.Next;
     End;
     Result := -1;
End;


Function TChainList.Item2Index(Item:Pointer):LongInt;
Var  ple:PChainListItem;
Begin
     Result := -1;
     ple := FList;
     While ple <> Nil Do
     Begin
          Inc(Result);
          If ple^.Item = Item Then Exit;
          ple := ple^.Next;
     End;
     Result := -1;
End;


Procedure TChainList.Connect(ple1,ple2:PChainListItem);
Begin
     If ple1 <> Nil Then ple1^.Next := ple2
     Else FList := ple2;
     If ple2 <> Nil Then ple2^.Prev := ple1
     Else FListEnd := ple1;
End;


Function TChainList.Get(Index:LongInt):Pointer;
Var  ple:PChainListItem;
Begin
     ple := Index2PLE(Index);
     If ple = Nil Then Error;
     Result := ple^.Item;
End;


Procedure TChainList.Put(Index:LongInt;Item:Pointer);
Var  ple:PChainListItem;
Begin
     ple := Index2PLE(Index);
     If ple = Nil Then Error;
     ple^.Item := Item;
End;



Destructor TChainList.Destroy;
Begin
     Clear;
     Inherited Destroy;
End;


Procedure TChainList.Clear;
Var  I:LongInt;
     ple,plenext:PChainListItem;
Begin
     ple := FList;
     For I := 0 To FCount-1 Do
     Begin
          FreeItem(ple^.Item);

          plenext := ple^.Next;
          Dispose(ple);
          ple := plenext;
     End;
     FCount := 0;
     FList := Nil;
     FListEnd := Nil;
End;


Function TChainList.Add(Item:Pointer):LongInt;
Var  plenew:PChainListItem;
Begin
     New(plenew);
     plenew^.Item := Item;
     plenew^.Next := Nil;
     Connect(FListEnd,plenew);
     FListEnd := plenew;
     Result := FCount;
     Inc(FCount);
End;


Function TChainList.Remove(Item:Pointer):LongInt;
Var  I:LongInt;
     ple:PChainListItem;
Begin
     ple := FList;
     For I := 0 To FCount-1 Do
     Begin
          If ple^.Item = Item Then
          Begin
               FreeItem(ple^.Item);

               Result := I;
               Connect(ple^.Prev,ple^.Next);
               Dispose(ple);
               Dec(FCount);
               Exit;
          End;
          ple := ple^.Next;
     End;
     Result := -1;
End;


Procedure TChainList.Delete(Index:LongInt);
Var  ple:PChainListItem;
Begin
     ple := Index2PLE(Index);
     If ple = Nil Then Error;

     FreeItem(ple^.Item);

     Connect(ple^.Prev,ple^.Next);
     Dispose(ple);
     Dec(FCount);
End;


Procedure TChainList.FreeItem(Item:Pointer);
Begin
     If FOnFreeItem <> Nil Then FOnFreeItem(Self,Item);
End;


Function TChainList.First:Pointer;
Var  ple:PChainListItem;
Begin
     ple := FList;
     If ple = Nil Then Error;
     Result := ple^.Item;
End;


Function TChainList.Last:Pointer;
Var  ple:PChainListItem;
Begin
     ple := FListEnd;
     If ple = Nil Then Error;
     Result := ple^.Item;
End;


Function TChainList.IndexOf(Item:Pointer):LongInt;
Begin
     Result := Item2Index(Item);
End;


Procedure TChainList.Insert(Index:LongInt;Item:Pointer);
Var  ple,plenew:PChainListItem;
Begin
     If Index < 0 Then Error;
     If Index > FCount Then Error;

     ple := Index2PLE(Index);
     If ple <> Nil Then
     Begin
          New(plenew);
          plenew^.Item := Item;
          Connect(ple^.Prev,plenew);
          Connect(plenew,ple);
          Inc(FCount);
     End
     Else Add(Item);
End;


Procedure TChainList.Move(CurIndex,NewIndex:LongInt);
Var  TempItem:Pointer;
Begin
     If CurIndex < 0 Then Error;
     If CurIndex >= FCount Then Error;
     If NewIndex < 0 Then Error;
     If NewIndex >= FCount Then Error;
     If CurIndex = NewIndex Then Exit;

     TempItem := Get(CurIndex);
     Delete(CurIndex);
     Insert(NewIndex,TempItem);
End;


Procedure TChainList.Exchange(Index1,Index2:LongInt);
Var  ple1,ple2:PChainListItem;
     TempItem:Pointer;
Begin
     ple1 := Index2PLE(Index1);
     ple2 := Index2PLE(Index2);
     If (ple1 = Nil) Or (ple2 = Nil) Then Error;

     TempItem := ple1^.Item;
     ple1^.Item := ple2^.Item;
     ple2^.Item := TempItem;
End;


Procedure TChainList.Pack;
Var  I:LongInt;
     ple,plenext:PChainListItem;
Begin
     ple := FList;
     For I := 0 To FCount-1 Do
     Begin
          plenext := ple^.Next;
          If ple^.Item = Nil Then
          Begin
               Connect(ple^.Prev,ple^.Next);
               Dispose(ple);
               Dec(FCount);
          End;
          ple := plenext;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TcArrayPointer                                                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tArrayPointer.setColCount(iColCount : LongInt);

Begin
  if fColCount=0
    then
      Begin
        fColCount := iColCount;
        fColMem := fColCount * sizeof(Pointer);
      End;
End;

Function tArrayPointer.getRowCount : LongInt;

Begin
  Result := fRowList.Count;
End;

Function tArrayPointer.getRow(iIndex : LongInt) : pPointerArray;

Begin
  Result := fRowList.Items[iIndex];
End;

Function tArrayPointer.Add : pPointerArray;

Begin
  getMem(Result, fColMem);
  fRowList.Add(Result);
End;

Function tArrayPointer.AddList(iList : tList) : LongInt;

Var cou : LongWord;
    pRow: pPointerArray;

Begin
  if iList.Count <> fColCount then
    exit;

  getMem(pRow, fColMem);
  for cou:=0 to fColCount-1 do
     pRow[cou] := iList.Items[cou];
  Result:=fRowList.Add(pRow);
End;

Procedure tArrayPointer.Delete(iIndex : LongInt);

Begin
  if iIndex > getRowCount then
    exit;
  freeMem(fRowList.Items[iIndex], fColMem);
  fRowList.Delete(iIndex);
End;


Procedure tArrayPointer.Clear;

Begin
  fRowList.Clear;
  fColCount:=0;
  fColMem:=0;
End;

Procedure tArrayPointer.RowListFreeItem(iSender: tobject; iRow:Pointer);

Begin
  if FOnFreeItem <> Nil Then FOnFreeItem(iSender, iRow);
  freemem(iRow, fColMem);
End;


Constructor tArrayPointer.Create;

Begin
  inherited Create;
{  Writeln('ArrayPointer'); }
  fRowList.Create;
  fRowList.OnFreeItem:=@RowListFreeItem;
  Clear;
End;

Destructor tArrayPointer.Destroy;

Begin
  Clear;
  fRowList.Destroy;
  inherited Destroy;
{  Writeln('ArrayPointer: Destroy'); }
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: tcArray2DFix                                                      บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tcArray2DFix.SetItems(Col, Row : LongInt; Value : LongWord);

Var P : LongWord;

Begin
  if (Col<0) or (Col>FCol) or
     (Row<0) or (Row>FRow) then exit;
  p:=GetMemoryPos(Col, Row);
  fMemory^[p]:=Value;
End;

Function tcArray2DFix.GetItems(Col, Row : LongInt) : LongWord;

Begin
  if (Col<0) or (Col>FCol) or
     (Row<0) or (Row>FRow) then exit;
  Result:=fMemory^[GetMemoryPos(Col, Row)];
End;

Function tcArray2DFix.GetMemoryPos(iCol, iRow : LongInt) : LongWord;

Begin
  Result:=(fCol*iRow + iCol); // * Sizeof(LongWord);
End;

Procedure tcArray2DFix.Clear;

var cou : LongWord;

Begin
  if (fResetValue =0) or (fResetValue = MAXLONGWORD)
    then FillChar(fMemory^, fMemorySize, fResetValue)
    else
      Begin
        For Cou:=0 to (fCol*fRow) do
          FMemory^[Cou]:=fResetValue;
      End;
End;

Constructor tcArray2DFix.Create(iCol, iRow : LongInt; iResetValue : LongWord);

Begin
  if (iCol < 1) or (iRow < 0) then
    Begin
      Raise EListError.Create(LoadNLSStr(SListErrorText));
      Exit;
    End;

  inherited Create;
  fCol:=iCol;
  fRow:=iRow;
  fResetValue:=iResetValue;
  fMemorySize:=GetMemoryPos(fCol,fRow) * sizeof(LongWord);
  GetMem(fMemory,fMemorySize);
  Clear;
End;

Destructor tcArray2DFix.Destroy;

begin
  FreeMem(fMemory,fMemorySize);
  inherited Destroy;
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: TcMemoryStreamList                                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tcMemoryStreamList.DestroyMemoryStream(iMemoryStream : pMemorystream);

Begin
  if iMemoryStream<>nil then
    Begin
      iMemoryStream^.Destroy;
      Dispose(iMemoryStream);
    End;
  iMemorystream:=nil;
End;


Function tcMemoryStreamList.CheckItems(iIndex:LongInt): Boolean;

Begin
  Result:=(iIndex>=0) or (iIndex<=Count);
End;

Function tcMemoryStreamList.First: tMemoryStream;

var p : pMemorystream;

Begin
  p := inherited First;
  result := p^;
End;

Function tcMemoryStreamList.Last : tMemoryStream;

var p : pMemorystream;

Begin
  p := inherited Last;
  result := p^;
End;

Function tcMemoryStreamList.Add(iMemoryStream: tMemoryStream): LongInt;

Var NewMemoryStream : pMemorystream;

Begin
  New(NewMemoryStream);
  NewMemoryStream^.Create;
  NewMemoryStream^.SetSize(iMemoryStream.Size);
  system.move(iMemoryStream.Memory[0], NewMemoryStream^.Memory[0], iMemoryStream.Size);
  result:=inherited Add(NewMemoryStream);
End;

Procedure tcMemoryStreamList.Delete(Index: LongInt);

Begin
  if CheckItems(Index) then
    Begin
      DestroyMemoryStream(inherited Items[Index]);
      inherited Delete(Index);
    End;
End;

Procedure tcMemoryStreamList.Cut(Index1, Index2: LongInt);

var Cou : LongInt;

Begin
  if (CheckItems(Index1)) and
     (CheckItems(Index2)) and
     (Index1<Index2) then
    Begin
      For Cou:=Index1 to Index2 do
        DestroyMemoryStream(inherited Items[Cou]);
      Inherited Cut(Index1, Index2);
    End;
End;

Procedure tcMemoryStreamList.Clear;

Var Cou : LongInt;

Begin
  for Cou:=0 to Count-1 do
    DestroyMemoryStream(inherited Items[Cou]);
  inherited Clear;
End;

Function tcMemoryStreamList.GetItems(iIndex:LongInt) : tMemoryStream;

var p : pMemorystream;

Begin
  if CheckItems(iIndex) then
    Begin
      p := inherited Items[iIndex];
      Result:=p^;
    End;
End;

Function tcMemoryStreamList.GetSize : LongInt;

Var Cou : LongInt;

Begin
  Result:=0;
  For Cou:=0 to Count-1 do
    Result:=Result+Items[Cou].Size;
End;

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  02-Jan-04  WD         Unit erstellt
  17-Feb-04  WD         Klasse "tcLongWordList" eingebaut
  25-Apr-04  WD         Klasse "tcLongIntList" eingebaut
  16-Mar-05  WD         Klasse "tcArray2DFix" eingebaut
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  04-Jul-07  MV         TList.Grow: Reduzieren von Getmem/Freemem
}
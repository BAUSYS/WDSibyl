Unit ExeImage;

Interface

Uses SysUtils,Classes,Forms,Graphics,Dialogs,
     uString,uList,uStream;

Type
  TResourceType=(rtIcon,rtBitmap,rtStringList);

  TResourceItem=Class(TComponent)
      Private
         FSize:LongInt;
         FRawData:Pointer;
         FId:Word;
         FType:TResourceType;
      Public
         Destructor Destroy;Override;
         Procedure SaveToFile(Const FileName:String);Virtual;Abstract;
      Public
         Property Size:LongInt read FSize;
         Property RawData:Pointer read FRawData;
         Property Id:Word read FId;
         Property ResType:TResourceType read FType;
  End;

  TIconResource=Class(TResourceItem)
      Private
         FIcon:TIcon;
      Public
         Procedure SaveToFile(Const FileName:String);Override;
      Public
         Property Icon:TIcon read FIcon;
  End;

  TBitmapResource=Class(TResourceItem)
      Private
         FBitmap:TBitmap;
      Public
         Procedure SaveToFile(Const FileName:String);Override;
      Public
         Property Bitmap:TBitmap read FBitmap;
  End;

  TStringListResource=Class(TResourceItem)
      Private
         FList:TStringList;

         Function GetStringCount:LongInt;
         Function GetString(Index:LongInt):String;
      Public
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
         Procedure SaveToFile(Const FileName:String);Override;
      Public
         Property StringCount:LongInt read GetStringCount;
         Property Strings[Index:LongInt]:String read GetString;
  End;

  TResourceList=Class(TComponent)
      Private
         FList:TList;

         Function GetCount:LongInt;
         Function GetItem(Index:LongInt):TResourceItem;
      Public
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
      Public
         Property Count:LongInt read GetCount;
         Property Items[Index:LongInt]:TResourceItem read GetItem;
  End;

  EExeError=Class(Exception);

  TResTable=Record
                Typ:Word;
                Name:Word;
                Size:LongInt;
                ObjectNr:Word;
                Offset:LongInt;
  End;

  TExeDllImage=Class(TComponent)
      Private
         FResourceList:TResourceList;

         Procedure ReadBitmap(Stream:TStream;Const ResTable:TResTable;DataOffs:LongWord);
         Procedure ReadStringTable(Stream:TStream;Const ResTable:TResTable;DataOffs:LongWord);
      Public
         Constructor Create(Const AFileName:String);Virtual;
         Destructor Destroy;Override;
      Public
         Property ResourceList:TResourceList read FResourceList;
  End;

Implementation

Destructor TResourceItem.Destroy;
Begin
    If FSize<>0 Then FreeMem(FRawData,FSize);

    Inherited Destroy;
End;

Procedure TIconResource.SaveToFile(Const FileName:String);
Begin
   If Icon<>Nil Then Icon.SaveToFile(FileName);
End;

Procedure TBitmapResource.SaveToFile(Const FileName:String);
Begin
   If Bitmap<>Nil Then Bitmap.SaveToFile(FileName);
End;

Procedure TStringListResource.SaveToFile(Const FileName:String);
Begin
End;

Function TStringListResource.GetStringCount:LongInt;
Begin
    Result:=FList.Count;
End;

Function TStringListResource.GetString(Index:LongInt):String;
Begin
   Result:=FList[Index];
End;

Procedure TStringListResource.SetupComponent;
Begin
   Inherited SetupComponent;

   FList.Create;
End;

Destructor TStringListResource.Destroy;
Begin
   FList.Destroy;
   Inherited Destroy;
End;

Function TResourceList.GetCount:LongInt;
Begin
    Result:=FList.Count;
End;

Function TResourceList.GetItem(Index:LongInt):TResourceItem;
Begin
    Result:=TResourceItem(FList[Index]);
End;

Procedure TResourceList.SetupComponent;
Begin
    Inherited SetupComponent;

    FList.Create;
End;

Destructor TResourceList.Destroy;
Var t:LongInt;
    Item:TResourceItem;
Begin
    For t:=0 To FList.Count-1 Do
    Begin
       Item:=FList[t];
       Item.Destroy;
    End;
    FList.Destroy;
    Inherited Destroy;
End;

Procedure TExeDllImage.ReadBitmap(Stream:TStream;Const ResTable:TResTable;DataOffs:LongWord);
Var Start:LongWord;
    Resource:TResourceItem;
    Bitmap:TBitmap;
Begin
     If ResTable.Typ=1 Then
     Begin
        Resource:=TIconResource.Create(Nil);
        Resource.FType:=rtIcon;
     End
     Else
     Begin
        Resource:=TBitmapResource.Create(Nil);
        Resource.FType:=rtBitmap;
     End;

     Start:=DataOffs+Restable.Offset;

     Stream.Position:=Start;

     Resource.FSize:=ResTable.Size;
     GetMem(Resource.FRawData,Resource.FSize);
     Resource.FId:=ResTable.Name;
     If Stream.Read(Resource.FRawData^,Resource.FSize)<>Resource.FSize Then
       Raise EExeError.Create('Read error');

     FResourceList.FList.Add(Resource);

     If Resource.FType=rtIcon Then Bitmap:=TIcon.Create
     Else Bitmap:=TBitmap.Create;
     Try
       Bitmap.LoadFromMem(Resource.RawData^,Resource.Size);
     Except
       Bitmap.Destroy;
       Raise;
     End;

     If Resource.FType=rtIcon Then TIconResource(Resource).FIcon:=TIcon(Bitmap)
     Else TBitmapResource(Resource).FBitmap:=Bitmap;
End;

Procedure TExeDllImage.ReadStringTable(Stream:TStream;Const ResTable:TResTable;DataOffs:LongWord);
Var Start,Nr:LongWord;
    Resource:TStringListResource;
    Bitmap:TBitmap;
    Code,w:Word;
    s:String;
Begin
     Resource.Create(Nil);
     Resource.FType:=rtStringList;

     Start:=DataOffs+restable.offset;
     Resource.FSize:=ResTable.Size;
     GetMem(Resource.FRawData,Resource.FSize);

     Stream.Position:=Start;
     If Stream.Read(Resource.FRawData^,Resource.FSize)<>Resource.FSize Then
       Raise EExeError.Create('Read error');
     Stream.Position:=Start;

     If Stream.Read(Code,2)<>2 Then
       Raise EExeError.Create('Read error');

     If not (Code In [$0352,$01b5]) Then
       Raise EExeError.Create('Unknown resource format');

     Nr:=(ResTable.Name-1)*16;
     Resource.FId:=Nr;

     For w:=0 To 15 Do
     Begin
          If Stream.Read(s[0],1)<>1 Then
            Raise EExeError.Create('Read error');
          If Stream.Read(s[1],ord(s[0]))<>ord(s[0]) Then
            Raise EExeError.Create('Read error');

          If Ord(s[0]) > 1 Then Resource.FList.Add(s);
     End;

     FResourceList.FList.Add(Resource);
End;


Constructor TExeDllImage.Create(Const AFileName:String);
Var
   ResTable:TResTable;
Type
    PSegList=^TSegList;
    TSegList=Record
                 SegOffset:LongWord;
                 SegIndex:LongWord;
                 Next:PSegList;
             End;
Var
    SegList,SegDummy:PSegList;
    Stream:TFileStream;
    w:Word;
    l,t,NewHead:LongInt;
    PageShift,SegmentTableOffs,SegmentTableEntries:LongInt;
    PageMapOffs,PageMapIndex,ResTableOffset,ResTableEntries:LongInt;
    DataOffs,DataPagesOffs:LongInt;
Begin
   Inherited Create(Nil);
   FResourceList.Create(Nil);

   Try
      Stream.Create(AFileName,fmInput);

      Try
        If Stream.Read(w,2)<>2 Then
          Raise EExeError.Create('Read error');
        If w<>$5a4d Then
        Begin
            ErrorBox('No valid EXE or DLL file');
            Raise EExeError.Create('Read error');
        End;

        Stream.Position:=60;

        If Stream.Read(NewHead,4)<>4 Then
           Raise EExeError.Create('Read error');

        Stream.Position:=NewHead;

        If Stream.Read(w,2)<>2 Then
           Raise EExeError.Create('Read error');
        If w<>$584c Then
        Begin
            ErrorBox('No valid EXE or DLL file');
            Raise EExeError.Create('Read error');
        End;

        {Get PageShift aligment}
        Stream.Position:=NewHead+44;
        If Stream.Read(PageShift,4)<>4 Then
           Raise EExeError.Create('Read error');

        {Get Segment table offset and len}
        Stream.Position:=NewHead+64;
        If Stream.Read(SegmentTableOffs,4)<>4 Then
           Raise EExeError.Create('Read error');
        If Stream.Read(SegmentTableEntries,4)<>4 Then
           Raise EExeError.Create('Read error');

        {Get Offset of Page Table}
        Stream.Position:=NewHead+72;
        If Stream.Read(PageMapOffs,4)<>4 Then
           Raise EExeError.Create('Read error');

        {Get Resource table offset and len}
        Stream.Position:=NewHead+80;
        If Stream.Read(ResTableOffset,4)<>4 Then
           Raise EExeError.Create('Read error');
        If Stream.Read(ResTableEntries,4)<>4 Then
           Raise EExeError.Create('Read error');

        {Get Offset of the data pages}
        Stream.Position:=NewHead+128;
        If Stream.Read(DataPagesOffs,4)<>4 Then {Start of code}
           Raise EExeError.Create('Read error');

       {Read all segment table entries}
       Stream.Position:=NewHead+SegmentTableOffs;
       SegList:=Nil;
       For t:=1 To SegmentTableEntries Do
       Begin
          If SegList=Nil Then
          Begin
             New(SegList);
             SegDummy:=SegList;
          End
          Else
          Begin
             SegDummy:=SegList;
             While SegDummy^.Next<>Nil Do SegDummy:=SegDummy^.Next;
             New(SegDummy^.Next);
             SegDummy:=SegDummy^.Next;
          End;

          Stream.Position:=Stream.Position+12;
          If Stream.Read(PageMapIndex,4)<>4 Then
            Raise EExeError.Create('Read error');
          Stream.Position:=Stream.Position+8;
          l:=Stream.Position;

          Stream.Position:=NewHead+PageMapOffs+((PageMapIndex-1)*8);

          If Stream.Read(SegDummy^.SegOffset,4)<>4 Then
             Raise EExeError.Create('Read error');
          SegDummy^.SegOffset:=SegDummy^.SegOffset SHL PageShift;
          SegDummy^.SegOffset:=DataPagesOffs+SegDummy^.SegOffset;
          SegDummy^.SegIndex:=t;
          SegDummy^.Next:=NIL;

          Stream.Position:=l;
       End;

       {Read all Resource table entries}
       Stream.Position:=NewHead+ResTableOffset;
       For t:=1 To ResTableEntries Do
       Begin
          If Stream.Read(ResTable,Sizeof(TResTable))<>Sizeof(TResTable) Then
            Raise EExeError.Create('Read error');

          l:=Stream.Position;

          {Search the objectnumber and setup DataOffs}
          DataOffs:=0;
          SegDummy:=SegList;
          While SegDummy<>Nil Do
          Begin
               If SegDummy^.SegIndex=ResTable.ObjectNr Then
               Begin
                 DataOffs:=SegDummy^.SegOffset;
                 Break;
               End;
               SegDummy:=SegDummy^.next;
          End;

          If DataOffs<>0 Then {Segment found ?}
          Case ResTable.Typ Of
             1: {ICON or POINTER}
             Begin
                  Try
                    ReadBitmap(Stream,ResTable,DataOffs);
                  Except
                  End;
             End;
             2: {BITMAP}
             Begin
                  Try
                    ReadBitmap(Stream,ResTable,DataOffs);
                  Except
                  End;
             End;
             5: {STRINGTABLE}
             Begin
                  Try
                    ReadStringTable(Stream,ResTable,DataOffs);
                  Except
                  End;
             End;
          End; {case}

          Stream.Position:=l;
       End;

      Finally
        While SegList<>Nil Do
        Begin
           SegDummy:=SegList^.Next;
           Dispose(SegList);
           SegList:=SegDummy;
        End;

        Stream.Destroy;
      End;
   Except
      On E:Exception Do ErrorBox(E.Message);
   End;
End;

Destructor TExeDllImage.Destroy;
Begin
    FResourceList.Destroy;
    Inherited Destroy;
End;

Initialization
End.


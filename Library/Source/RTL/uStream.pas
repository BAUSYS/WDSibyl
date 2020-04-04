Unit uStream;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ Diese Unit verwaltet diverse Stream-Objekte                               บ
บ                                                                           บ
บ   Klassen: tStream, THandleStream, TFileStream, TMemoryStream             บ
บ            tStdInStream, tStdOutStream, tStdErrStream                     บ
บ                                                                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Interface

Uses SysUtils;

//TStream Seek origins
Const soFromBeginning = 0;
      soFromCurrent   = 1;
      soFromEnd       = 2;

// FileStream Open modes
      fmCreate = $FFFF;            (* Delphi *)

      Stream_Create    = fmCreate; (* compatibility only *)
      Stream_Open      = fmInOut;  (* compatibility only *)
      Stream_OpenRead  = fmOpenRead Or fmShareDenyWrite;

// Standard-Handle
      HandleStream_StdIn = 0;
      HandleStream_StdOut= 1;
      HandleStream_StdErr= 2;

// Exception-Class
Type EStreamError=Class(Exception);
     EFCreateError=Class(EStreamError);
     EFOpenError=Class(EStreamError);

Type TStream=Class(TObject)
       Private
         Function GetSize:LongInt;Virtual;
         Function GetPosition:LongInt;
         Procedure SetPosition(NewPos:LongInt);
         Procedure Error(ResourceId:Word);Virtual;
       Public
         Procedure ReadBuffer(Var Buffer;Count:LongInt);
         Procedure WriteBuffer(Const Buffer;Count:LongInt);
         Function CopyFrom(Source: TStream; Count: LongInt): LongInt;
         Function Read(Var Buffer;Count:LongInt):LongInt;Virtual;Abstract;
         Function Write(Const Buffer;Count:LongInt):LongInt;Virtual;Abstract;
         Function Seek(Offset:LongInt;Origin:Word):LongInt;Virtual;Abstract;
         Procedure Clear; Virtual; Abstract;
         Procedure LoadFromStream(Stream: TStream); Virtual; Abstract;
         Procedure SaveToStream(Stream: TStream); Virtual; Abstract;
         Procedure SetSize(NewSize: LongInt);Virtual; Abstract;
         
         Function EndOfData: Boolean; Virtual;
         Function ReadLn: String; Virtual;
         Procedure WriteLn(Const S: String); Virtual;
         Function AnsiReadLn: AnsiString; Virtual;
         Procedure AnsiWriteLn(Const S: AnsiString); Virtual;
       Public
         Property Position:LongInt Read GetPosition Write SetPosition;
         Property Size:LongInt Read GetSize Write SetSize;
     End;

{ ----------------------------------------------------------------------------- }

Type THandleStream= Class(TStream)
       Private
         FHandle: LongInt;
       Public
         Constructor Create(AHandle: LongInt);
         Function Read(Var Buffer; Count: LongInt): LongInt; Override;
         Function Write(Const Buffer; Count: LongInt): LongInt; Override;
         Function Seek(Offset: LongInt; Origin: Word): LongInt; Override;
         Procedure Clear; Override;
         Procedure LoadFromStream(Stream: TStream); Virtual; Override;
         Procedure SaveToStream(Stream: TStream); Virtual; Override;
         Procedure SetSize(NewSize: LongInt);Virtual; Override;
       Public
         Property Handle: LongInt Read FHandle;
     End;

{ ----------------------------------------------------------------------------- }

Type TFileStream=Class(TStream)
       Private
         PStreamFile:File;
         fFileName : tFileName;

         Function getExtrFilePath : String;
         Function getExtrFileName : String;
         Function getExtrFileExt  : String;

       Public
         Constructor Create(Const FileName:String;Mode:LongWord);
         Destructor Destroy;Override;
         Function Read(Var Buffer;Count:LongInt):LongInt;Override;
         Function Write(Const Buffer;Count:LongInt):LongInt;Override;
         Function Seek(Offset:LongInt;Origin:Word):LongInt;Override;
         Procedure Clear; Override;
         Procedure LoadFromStream(Stream: TStream); Virtual; Override;
         Procedure SaveToStream(Stream: TStream); Virtual; Override;
         Procedure SetSize(NewSize: LongInt);Virtual; Override;

         Property Filename : String Read fFileName;

         Property ExtFilePath : String Read getExtrFilePath;
         Property ExtFileName : String Read getExtrFileName;
         Property ExtFileExt  : String Read getExtrFileExt;
     End;
    
{ ----------------------------------------------------------------------------- }    
    
Type TTempFileStream=Class(TFileStream)
       Private
       Public
         Constructor Create;
         Destructor Destroy;Override;
     End;

{ ----------------------------------------------------------------------------- }

     pMemoryStream = ^tMemoryStream;
     TMemoryStream=Class(TStream)
       Private
         FBuffer: PByteArray;
         FSize, FCapacity, FPosition: LongInt;
         Procedure SetCapacity(NewCapacity: LongInt);
       Protected
       Public
         Destructor Destroy;Override;
         Function Read(Var Buffer;Count:LongInt):LongInt;Override;
         Function Write(Const Buffer; Count: LongInt):LongInt;Override;
         Function Seek(Offset: LongInt; Origin: Word):LongInt;Override;
         Procedure LoadFromStream(Stream: TStream); Virtual; Override;
         Procedure LoadFromStreamLen(Stream: TStream; Const Len : LongInt);
         Procedure LoadFromFile(Const FileName:String);
         Procedure SaveToStream(Stream: TStream); Virtual; Override;
         Procedure SaveToFile(Const FileName:String); 
         Procedure Clear; Override;
         Procedure SetSize(NewSize: LongInt);Virtual; Override;

         Function BufferCopy(iStart : LongInt; iLength : Byte) : String;
{         Function Split(iStart, iEnde : LongWord; iTrennzeichen : Char;
                     iStringList : TStringList) : Boolean;
         Procedure AddMemoryStreamList(iMemoryStreamList : tcMemoryStreamList); }
         Procedure Replace(iStart, iEnde : LongWord; iOld, iNew : Byte);
         Procedure InsertStream(iStream : tStream; iStart, iLen : LongWord);

       Public
         Property Capacity:LongInt       Read FCapacity Write SetCapacity;
         Property Memory: PByteArray     Read FBuffer;
     End;

{ ----------------------------------------------------------------------------- }

// Zu Info:
// Beim Zugriff auf des SharedMemorys mit AllocSharedMemory order GetSharedMemory muss
// vorher schon die Gr”แe des Speichers (Size) gesetzt werden
// z.B.: Mem.Size:=2*1024;

Type
  tSharedMemoryStreamTyp = (SharedMemoryStreamTypNone,
                            SharedMemoryStreamTypCreate,
                            SharedMemoryStreamTypOpen);

  tSharedMemoryStream = class(tStream)
    Private
      fMemory    : PByteArray;;
      fName      : String;
      fTyp       : tSharedMemoryStreamTyp;
      fSize      : LongWord;
      fPosition  : LongWord;

// Diverse Flags fuer das Speicherobjekt.
      fGiveable   : Boolean;
      fGettable   : Boolean;

      fPAG_COMMIT : Boolean;  // Die Seiten werden gleich auch physisch angelegt

      fPAG_EXECUTE: Boolean;  // kennzeichnet ausfhrberen Code
      fPAG_GUARD  : Boolean;  // definiert die Seite als Guard-Seiten
      fPAG_READ   : Boolean;  // erlaubt nur Lese-Zugriffe
      fPAG_WRITE  : Boolean;  // erlaubt Lese- und Schreibzugriffe

      Function getTypText : String;
      Function StandardFlags : LongWord;

    Public
      Procedure AllocSharedMemory;
      Function  GiveSharedMemory(iPID : Longword) : Boolean;
      Function  GetSharedMemory : Boolean; Overload;                        // fo  Named-Shared-Memory
      Function  GetSharedMemory(iBaseAdress : Pointer) : Boolean; Overload; // for Anonyme-Shared-Memory

      Function Read(Var Buffer; Count: LongInt): LongInt; Override;
      Function Write(Const Buffer; Count: LongInt): LongInt;  Override;
      Function Seek(Offset: LongInt; Origin: Word):LongInt;Override;
      Procedure LoadFromStream(Stream: TStream); Virtual; Override;
      Procedure SaveToStream(Stream: TStream); Virtual; Override;
      Procedure Clear; Override;
      Procedure SetSize(NewSize: LongInt);Virtual; Override;

      Constructor Create(Const iName : String); Virtual;
      Destructor Destroy; Override;

      Property Name    : String           read FName;
      Property Typ     : tSharedMemoryStreamTyp read fTyp;
      Property TypText : String           read getTypText;
      Property Memory  : PByteArray       read fMemory;

      Property Giveable   : Boolean          read fGiveable    write fGiveable;
      Property Gettable   : Boolean          read fGettable    write fGettable;
      Property PAG_COMMIT : Boolean          read fPAG_COMMIT  write fPAG_COMMIT;
      Property PAG_EXECUTE: Boolean          read fPAG_EXECUTE write fPAG_EXECUTE;
      Property PAG_GUARD  : Boolean          read fPAG_GUARD   write fPAG_GUARD;
      Property PAG_READ   : Boolean          read fPAG_READ    write fPAG_READ;
      Property PAG_WRITE  : Boolean          read fPAG_WRITE   write fPAG_WRITE;
  End;


{ ----------------------------------------------------------------------------- }

Type tStdInStream= Class(tMemoryStream)
       private
       public
         Constructor Create; Virtual;
         Destructor Destroy;Override;
     end;

Type tStdOutStream= Class(tMemoryStream)
       private
         fHandle : LongInt;
       public
         Procedure WriteData;
         Constructor Create; Virtual;
         Destructor Destroy; Override;
     end;

Type tStdErrStream= Class(tStdOutStream)
       private
       public
         Constructor Create; Virtual;
     end;


Implementation

{$IFDEF OS2}
Uses OS2Def, BseDos, BseErr;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: TStream Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TStream.CopyFrom(Source:TStream;Count:LongInt):LongInt;
Var
  ActBufSize,T:LongInt;
  StreamBuffer:Pointer;
Const
  MaxBufSize = $FFFF;
Begin
  If Count = 0 Then
  Begin
    Count := Source.Size;
    Source.Position := 0;
  End;

  Result := Count;

  If Count > MaxBufSize Then ActBufSize:=MaxBufSize
  Else ActBufSize := Count;

  GetMem(StreamBuffer,ActBufSize);

  Try
    While Count<>0 Do
    Begin
      If Count>ActBufSize Then T:=ActBufSize
      Else T:=Count;

      Source.ReadBuffer(StreamBuffer^,T);
      WriteBuffer(StreamBuffer^,T);
      Dec(Count,T);
    End;
  Finally
    FreeMem(StreamBuffer, ActBufSize);
  End;
End;

Function TStream.GetSize:LongInt;

Var OldPos:LongInt;

Begin
   OldPos:=GetPosition;
   Result:=Seek(0,Seek_End);
   SetPosition(OldPos);
End;

Function TStream.EndOfData: Boolean;
Begin
  Result := (Position >= Size);
End;

Function TStream.GetPosition:LongInt;
Begin
     GetPosition:=Seek(0,Seek_Current);
End;

Procedure TStream.SetPosition(NewPos:LongInt);
Begin
     Seek(NewPos,Seek_Begin);
End;

Procedure TStream.ReadBuffer(Var Buffer;Count:LongInt);
Begin
     If Count=0 Then Exit;  {Nothing To Read}
     If Read(Buffer,Count)<>Count Then Error(SStreamReadErrorText);
End;

Procedure TStream.WriteBuffer(Const Buffer;Count:LongInt);
Begin
     If Count=0 Then Exit;
     If Write(Buffer,Count)<>Count Then Error(SStreamWriteErrorText);
End;

Procedure TStream.Error;
Begin
     Raise EStreamError.Create(LoadNLSStr(ResourceId));
End;

Function TStream.ReadLn: String;
Var
  Buffer: cstring[260];
  OldPos, Count, Temp: LongInt;
Begin
  OldPos := Position;

  Count := Read(Buffer[0], 257);
  Buffer[Count] := #0;

  Temp := 0;
  While Not (Buffer[Temp] In [#10, #13, #26]) and
        (Temp < Count) And (Temp < 255) do
    Inc (Temp);
  Move(Buffer[0], Result[1], Temp);
  Result[0]:=Chr(Temp);
  Inc(Temp);

  If (Buffer[Temp - 1] = #13) And (Buffer[Temp] = #10)
    Then Inc(Temp);

  Count:=OldPos + Temp;
  if Count > Size then Count:=Size;   // Falls an letzter Stelle kein CRLF steht.
  Position := Count;
End;

Procedure TStream.WriteLn(Const S: String);

var CRLF : Word;

Begin
  CRLF:=$0A0D;
  WriteBuffer(S[1], Length(S));
  WriteBuffer(CRLF, 2);
End;

Function TStream.AnsiReadLn: AnsiString; 

var Ch : Char;

Begin
  Result:='';
  Read(Ch, 1);
  While Not ((EndOfData) or (Ch In [#10, #13, #26])) do
    Begin
      Result:=Result+Ch;
      Read(Ch, 1);
    End;
  if Ch in [#10,#13] then      // CR oder LF ueberlesen
    Read(Ch, 1);
End;


Procedure TStream.AnsiWriteLn(Const S: AnsiString);

var Len : LongWord;
    CRLF : Word;

Begin
  CRLF:=$0A0D;
  Len:=Length(S);
  WriteBuffer(PChar(S)^, Len);
  WriteBuffer(CRLF, 2);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: THandleStream Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor THandleStream.Create(AHandle: LongInt);
Begin
  FHandle := AHandle;
End;

Function THandleStream.Read(Var Buffer; Count: LongInt): LongInt;
Begin
  Result := FileRead(Handle, Buffer, Count);
  If Result = -1 Then Result := 0;
End;

Function THandleStream.Write(Const Buffer; Count: LongInt): LongInt;
Var Temp:^Byte;
Begin
  Temp:=@Buffer;
  Result := FileWrite(Handle, Temp^, Count);
  If Result = -1 Then Result := 0;
End;

Function THandleStream.Seek(Offset: LongInt; Origin: Word): LongInt;
Begin
  Result := FileSeek(Handle, Offset, Origin);
  If Result < 0 Then Error(SStreamSeekErrorText);
End;

Procedure THandleStream.Clear;

Begin
End;

Procedure THandleStream.LoadFromStream(Stream: TStream);

Begin
End;

Procedure THandleStream.SaveToStream(Stream: TStream); 

Begin
End;

Procedure THandleStream.SetSize(NewSize: LongInt);

Begin
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: TFileStream Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TFileStream.getExtrFilePath : String;

Begin
  Result:=ExtractFilePath(fFileName);
End;

Function TFileStream.getExtrFileName : String;

Begin
  Result:=ExtractFilename(fFilename);
  Result[0]:=chr(ord(Result[0]) - length(getExtrFileExt));
End;

Function TFileStream.getExtrFileExt : String;

Begin
  Result:=ExtractFileExt(fFilename);
End;

Constructor TFileStream.Create(Const FileName:String;Mode:LongWord);

Var SaveMode: LongWord;

Begin
  Inherited Create;
  SaveMode := FileMode;
  fFileName:= FileName;
  If Mode = fmCreate
    Then FileMode := fmOpenReadWrite Or fmShareExclusive
    Else FileMode := Mode;

  Try
    Assign(PStreamFile,FileName);
    If Mode = fmCreate
      Then
        Begin
            {$I-}
            Rewrite(PStreamFile,1);
            {$I+}
            If InOutRes<>0 Then Raise EFCreateError.Create(LoadNLSStr(SStreamCreateErrorText));
        End
      Else
        Begin
           {$I-}
           Reset(PStreamFile,1);
           {$I+}
           If InOutRes<>0 Then Raise EFOpenError.Create(LoadNLSStr(SStreamOpenErrorText));
        End;
  Finally
    FileMode := SaveMode;
  End;
End;

Destructor TFileStream.Destroy;
Begin
     {$I-}
     Close(PStreamFile);
     {$I+}
     Inherited Destroy;
End;

Function TFileStream.Read(Var Buffer;Count:LongInt):LongInt;

Var BlRes :LongWord;

Begin
  {$I-}
  BlockRead(PStreamFile,Buffer,Count,BlRes);
  {$I+}
  If InOutRes<>0 Then Error(SStreamReadErrorText);
  Result:=BlRes;
End;

Function TFileStream.Write(Const Buffer;Count:LongInt):LongInt;

Var pb   : Pointer;
    BlRes: LongWord;

Begin
  pb:=@Buffer;
  {$I-}
  BlockWrite(PStreamFile,pb^,Count,BlRes);
  {$I+}
  If InOutRes<>0 Then Error(SStreamWriteErrorText);
  Result:=BlRes;
End;

Function TFileStream.Seek(Offset:LongInt;Origin:Word):LongInt;

Var  SaveSeekMode:LongWord;

Begin
  SaveSeekMode:=SeekMode;
  SeekMode:=Origin;
  {$I-}
  System.Seek(PStreamFile,Offset);
  {$I+}
  If InOutRes<>0 Then Error(SStreamSeekErrorText);
  SeekMode:=SaveSeekMode;
  {$I-}
  Seek:=FilePos(PStreamFile);
  {$I+}
  If InOutRes<>0 Then Error(SStreamSeekErrorText);
End;

Procedure TFileStream.Clear;

Begin
  Seek(soFromBeginning,0);
  System.Truncate(PStreamFile);
End;

Procedure TFileStream.LoadFromStream(Stream: TStream);

Begin
  System.Writeln('LoadFormStream:');
End;

Procedure TFileStream.SaveToStream(Stream: TStream);   

const MaxBufLen = 1024;

var FS     : LongInt;
    Buffer : Array[0..MaxBufLen] of Byte;
    ReadLen: LongInt;

Begin
  FS:=Size;
  If FS <> 0 Then 
    Begin
      Seek(soFromBeginning,0);
      ReadLen:=Read(Buffer,MaxBufLen);
      System.Writeln('BufLen:=',ReadLen, ', FileSize=',FS,', StreamSize=',Stream.Size);
      Stream.WriteBuffer(Buffer,ReadLen);
      System.Writeln('StreamSize=',Stream.Size);
    End;
End;

Procedure TFileStream.SetSize(NewSize: LongInt);

Begin
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: TTempFileStream Class Implementation                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TTempFileStream.Create;

Var SaveMode: LongWord;

Begin
  Inherited Create('D:\Privat\WDSibyl\WDDATABASE\xxx.tmp',fmCreate);
End;

Destructor TTempFileStream.Destroy;

Begin
  inherited Destroy;
//WD  DeleteFile(FileName);  // Temp-Dateien wieder l๖schen
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: TMemoryStream Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const MemoryDelta = 8192;

Destructor TMemoryStream.Destroy;
Begin
  Clear;
  Inherited Destroy;
End;

Function TMemoryStream.Read(Var Buffer; Count: LongInt): LongInt;
Begin
  If Count > 0 Then
  Begin
    Result := FSize - FPosition;
    If Count < Result Then Result := Count;
    Move(FBuffer^[FPosition], Buffer, Result);
    Inc(FPosition, Result);
  End
  Else Result := 0;
End;

Function TMemoryStream.Write(Const Buffer; Count: LongInt): LongInt;
Var
  NewPos, Needed: LongInt;
Begin
  If Count > 0 Then
  Begin
    NewPos := FPosition + Count;
    If NewPos > FSize Then
    Begin
      FSize := NewPos;
      If NewPos > FCapacity Then
      Begin
        Needed := (NewPos - FCapacity + MemoryDelta - 1) Div MemoryDelta;
        SetCapacity(FCapacity + Needed * MemoryDelta);
      End;
    End;
    Move(Buffer, FBuffer^[FPosition], Count);
    FPosition := NewPos;
  End;
  Result := Count;
End;

Function TMemoryStream.Seek(Offset: LongInt; Origin: Word): LongInt;
Begin
  Case Origin Of
    soFromBeginning: Result := Offset;
    soFromCurrent:   Result := FPosition + Offset;
    soFromEnd:       Result := FSize - Offset;
  End;
  If (Result < 0) Or (Result > FSize) Then Error(SStreamSeekErrorText)
  Else FPosition := Result;
End;

Procedure TMemoryStream.LoadFromStream(Stream: TStream);

Var ToDo: LongInt;

Begin
//  Stream.Position := 0;
  ToDo := Stream.Size;
  LoadFromStreamLen(Stream, ToDo);
End;

Procedure TMemoryStream.LoadFromStreamLen(Stream: TStream; Const Len : LongInt);

Begin
  SetSize(Len);
  If Len <> 0 Then Stream.ReadBuffer(FBuffer^[0], Len);
End;

Procedure TMemoryStream.LoadFromFile(Const FileName:String);
Var
  Source: TFileStream;
Begin
  Source := TFileStream.Create(FileName, Stream_OpenRead);
  Try
    LoadFromStream(Source);
  Finally
    Source.Destroy;
  End;
End;

Procedure TMemoryStream.SaveToStream(Stream: TStream);
Begin
  If FSize <> 0 Then Stream.WriteBuffer(FBuffer^[0], FSize);
End;

Procedure TMemoryStream.SaveToFile(Const FileName:String);
Var
  Dest: TFileStream;
Begin
  Dest := TFileStream.Create(FileName, Stream_Create);
  Try
    SaveToStream(Dest);
  Finally
    Dest.Destroy;
  End;
End;

Procedure TMemoryStream.SetCapacity(NewCapacity: LongInt);
Begin
  If FCapacity=NewCapacity Then Exit;
  FBuffer := ReAllocMem(FBuffer, FCapacity, NewCapacity);
  FCapacity := NewCapacity;
  If FSize > FCapacity Then FSize := FCapacity;
  If FPosition > FSize Then FPosition := FSize;
End;

Procedure TMemoryStream.SetSize(NewSize: LongInt);
Begin
  Clear;
  SetCapacity(NewSize);
  FSize := NewSize;
End;

Procedure TMemoryStream.Clear;
Begin
  SetCapacity(0);
End;

Procedure tMemoryStream.Replace(iStart, iEnde : LongWord; iOld, iNew : Byte);
{ Ersetzt einen alten Wert durch einen neuen Wert }

Var Cou : LongWord;

Begin
  if iEnde>Size then iEnde:=Size;
  For Cou:=iStart to iEnde do
    if Memory[Cou] = iOld then
      iNew:=Memory[Cou];
End;

Procedure tMemoryStream.InsertStream(iStream : tStream; iStart, iLen : LongWord);

Var TempStream   : pByteArray;
    TempBuffer   : pByteArray;
    LenTempBuffer: LongWord;

Begin
  LenTempBuffer:=FSize-fPosition;
  getMem(TempBuffer, LenTempBuffer);
  getMem(TempStream, iLen);

// Den Buffer ab der angegebenen Position in TempBuffer kopieren
  move(FBuffer^[FPosition], TempBuffer^, LenTempBuffer);

// Lesen des iStreamBuffers und in TempStream abspeichern
  iStream.ReadBuffer(TempStream^, iLen);

// Nun den Buffer in der richtigen Reihenfolge befuellen
  WriteBuffer(TempStream^, iLen);
  WriteBuffer(TempBuffer^, LenTempBuffer);

// Speicher wieder freigeben
  FreeMem(TempBuffer, LenTempBuffer);
  FreeMem(TempStream, iLen);
End;

{
Procedure tMemoryStream.AddMemoryStreamList(iMemoryStreamList : tcMemoryStreamList);
{ Die Inhalte von den einzelene MemoryStreams (von der MemoryListe) wird in den aktuellen Memorystream
  abgespeichert. Die aktuelle MemoryStream wird geloescht. Die MemoryStream von der MemoryStreamListe
  werden nicht modifiziert }
{
Var Cou : LongInt;

Begin
  Clear;
  SetSize(iMemoryStreamlist.Size);
  For Cou:=0 to iMemoryStreamList.Count-1 do
    WriteBuffer(iMemoryStreamList.Items[Cou].Memory^, iMemoryStreamList.Items[Cou].Size);
End;
}

Function tMemoryStream.BufferCopy(iStart : LongInt; iLength : Byte) : String;

Var Ende   : LongInt;
    Cou_Buf: LongInt;
    Cou_Str: Byte;

Begin
  Result:='';
  Ende:=iStart+iLength;
  if (Ende<=Size) then
    Begin
      Cou_Str:=0;
      For Cou_Buf:=iStart to Ende do
        Begin
          inc(Cou_Str);
          Result[Cou_Str]:=chr(Memory^[Cou_Buf]);
        End;
      Result[0]:=chr(iLength);
    End;
End;

{
Function tMemoryStream.Split(iStart, iEnde : LongWord; iTrennzeichen : Char;
                              iStringList : TStringList) : Boolean;
{ Splittet den Buffer (Vom Start bis Ende) in die Stringliste.
  Result = true ... Funktion wurde erfolgreich beendet worden }
{
Var Cou             : LongInt;
    PosTrennzeichen : LongInt;
    OrdTrennzeichen : Byte;

Begin
  if iEnde>Size then iEnde:=Size;
  if iStart>iEnde
    then Result:=false
    else
      Begin
        iStringList.Clear;
        ordTrennzeichen:=ord(iTrennzeichen);
        PosTrennzeichen:=iStart-1;
        for Cou:=iStart to iEnde do
          if Memory[Cou]=ordTrennzeichen then
            Begin
              iStringList.add(trim(BufferCopy(PosTrennzeichen+1, Cou-PosTrennzeichen-1)));
              PosTrennzeichen:=Cou;
            End;
        iStringList.add(trim(BufferCopy(PosTrennzeichen+1, iEnde-PosTrennzeichen)));
        Result:=iStringList.Count <> 0
      End;
End; }

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: tSharedMemoryStream Class Implementation                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function tSharedMemoryStream.getTypText : String;

Begin
  Case fTyp of
    SharedMemoryStreamTypNone  : Result:='None';
    SharedMemoryStreamTypCreate: Result:='Create';
    SharedMemoryStreamTypOpen  : Result:='Open';
  End;
End;

Function tSharedMemoryStream.Write(Const Buffer; Count: LongInt): LongInt;

var NewPos : LongWord;

Begin
  Result:=0;
  if fMemory=nil then exit;
  NewPos:=fPosition + Count;
  if NewPos>fSize then exit;
  Move(Buffer, fMemory^[fPosition], Count);
  fPosition:=NewPos;
  Result:=Count;
End;

Function tSharedMemoryStream.Read(Var Buffer; Count: LongInt): LongInt;

Begin
  Result:=0;
  if fMemory=nil then exit;
  If Count > 0 Then
    Begin
      Result := FSize - FPosition;
      If Count < Result Then Result := Count;
      Move(FMemory^[FPosition], Buffer, Result);
      Inc(FPosition, Result);
    End;
End;

Function tSharedMemoryStream.Seek(Offset: LongInt; Origin: Word):LongInt;

Begin
  Case Origin Of
    soFromBeginning: Result := Offset;
    soFromCurrent:   Result := FPosition + Offset;
    soFromEnd:       Result := FSize - Offset;
  End;
  If (Result < 0) Or (Result > FSize)
    Then Error(SStreamSeekErrorText)
    Else FPosition := Result;
End;

Procedure tSharedMemoryStream.LoadFromStream(Stream: TStream);

var ToDo: LongInt;

Begin
  ToDo := Stream.Size;
  If Todo <> 0 Then Stream.ReadBuffer(fMemory^[0], Todo);
End;

Procedure tSharedMemoryStream.SaveToStream(Stream: TStream);

Begin
  If FSize<>0 Then Stream.WriteBuffer(fMemory^[0], FSize);
End;

Procedure tSharedMemoryStream.Clear;

Begin
  Fillchar(fMemory^, fSize, #0);
End;

Procedure tSharedMemoryStream.SetSize(NewSize: LongInt);

Begin
  if fMemory<>nil then exit;
  fSize:=NewSize;
End;

Function tSharedMemoryStream.StandardFlags : LongWord;

Begin
  Result:=0;
{$IFDEF OS2}
  if fPAG_EXECUTE then
    Result:=Result or bsedos.PAG_EXECUTE;
  if fPAG_GUARD then
    Result:=Result or bsedos.PAG_GUARD;
  if fPAG_READ then
    Result:=Result or bsedos.PAG_READ;
  if fPAG_WRITE then
    Result:=Result or bsedos.PAG_WRITE;
{$ENDIF}
End;

Procedure tSharedMemoryStream.AllocSharedMemory;

var cs   : CString;
{$IFDEF OS2}
    rc   : ApiRet;
    flags: LongWord;
{$ENDIF}

Begin
  cs:=fName;
{$IFDEF OS2}
  flags:=StandardFlags;
  if fPAG_COMMIT then
    flags:=flags or bsedos.PAG_COMMIT;
  if fName='' then
    Begin // Anonym-Shared-Memory
      if fGiveable then
        flags:=flags or bsedos.OBJ_GIVEABLE;
      if fGettable then
        flags:=flags or bsedos.OBJ_GETTABLE;
      rc:=bsedos.DosAllocSharedMem(fMemory, nil, fSize, flags)
    End
  else   // Name-Shared-Memory
    rc:=bsedos.DosAllocSharedMem(fMemory, cs, fSize, flags);
  if rc=NO_ERROR then
    fTyp:=SharedMemoryStreamTypCreate;
{$ENDIF}
End;

Function tSharedMemoryStream.GiveSharedMemory(iPID : Longword) : Boolean;

{$IFDEF OS2}
var rc : APIRET;
    flags: LongWord;
{$ENDIF}

Begin
  Result:=false;
  if (iPID=0) or (fName<>'') or (fMemory=nil) then exit;
{$IFDEF WIN32}
{$ENDIF}
{$IFDEF OS2}
  flags:=StandardFlags;
  rc:=bsedos.DosGiveSharedmem(fMemory, iPID, flags);
  if rc=NO_ERROR then
    Begin
      fTyp:=SharedMemoryStreamTypOpen;
      Result:=true;
    End;
{$ENDIF}
End;

Function tSharedMemoryStream.GetSharedMemory : Boolean;
// Function to get the Adress of a Named-Shared Memory

var cs   : CString;
{$IFDEF OS2}
var rc   : APIRET;
    flags: LongWord;
{$ENDIF}

Begin
  Result:=false;
  fPosition:=0;
  if (fName='') or (fMemory<>nil) or (fSize=0) then exit;
  cs:=fName;
{$IFDEF WIN32}
{$ENDIF}
{$IFDEF OS2}
  flags:=StandardFlags;
  rc:=bsedos.DosGetNamedSharedMem(fMemory, cs, flags);
  if rc=NO_ERROR then
    Begin
      fTyp:=SharedMemoryStreamTypOpen;
      Result:=true;
    End;
{$ENDIF}
End;


Function tSharedMemoryStream.GetSharedMemory(iBaseAdress : Pointer) : Boolean;
// Function to get the Adress of a Anonym-Shared Memory

{$IFDEF OS2}
var rc : APIRET;
    flags: LongWord;
{$ENDIF}

Begin
  Result:=false;
  fPosition:=0;
  if (fName<>'') or (fMemory<>nil) or (fSize=0) then exit;
{$IFDEF WIN32}
{$ENDIF}
{$IFDEF OS2}
  flags:=StandardFlags;
  rc:=bsedos.DosGetSharedMem(iBaseAdress, flags);
  if rc=NO_ERROR then
    Begin
      fMemory:=iBaseAdress;
      result:=true;
    End;
{$ENDIF}
End;

Constructor tSharedMemoryStream.Create(Const iName : String);

Begin
  inherited Create;
  fMemory:=nil;
  fTyp:=SharedMemoryStreamTypNone;
  fName:=iName;
  fSize:=0;
  fPAG_READ:=true;
  fPAG_WRITE:=true;
  fPAG_COMMIT:=true;

  if fName='' then
    Begin
      fGiveable:=true;
      fGettable:=true;
    End
  else
    Begin
      fGiveable:=false;
      fGettable:=false;
      fName:=uppercase(fName);
      {$IFDEF OS2}
      if pos('\SHAREMEM\',fName)=0 then
        fName:='\SHAREMEM\'+fName;
      {$ENDIF}
    End;
End;

Destructor tSharedMemoryStream.Destroy;

Begin
  if fMemory<>nil then
    {$IFDEF OS2}
    bsedos.dosFreeMem(fMemory);
    {$ENDIF}

  inherited Destroy;
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: TStdInStream Class Implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


/*  For Cou:=0 to fInMemoryStream.Size-1 do
    Begin
      by:=fInMemoryStream.Memory[cou];
      System.Writeln(by,',',chr(by));
    End;



  System.Writeln('Size=',fInMemoryStream.Size);
  System.Writeln('End Create');
*/

Const StdInBufferSize = 8192;
//Const StdInOutBufferSize = 100;

Constructor tStdInStream.Create;

var InHndlStream: tHandleStream;
    InBuf       : pByteArray;
    InSize      : LongInt;

Begin
  inherited Create;

// Daten vom StdIn einlesen und in den InMemoryStream speichern
  InHndlStream.Create(HandleStream_StdIn);
  InSize:=StdInBufferSize;
  getMem(InBuf, StdInBufferSize);

  while InSize=StdInBufferSize do
    Begin
      InSize:=InHndlStream.Read(InBuf^, StdInBufferSize);
      Write(InBuf^,InSize);
    End;
  FreeMem(InBuf, StdInBufferSize);
  InHndlStream.Destroy;
End;

Destructor tStdInStream.Destroy;

Begin
//  fInMemoryStream.Destroy;
  inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: TStdOutStream Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TStdOutStream.WriteData;
// Daten in StdOut schreiben.

var OutHndlStream: tHandleStream;

Begin
  OutHndlStream.Create(fHandle);
  OutHndlStream.Write(fBuffer^, Size);
  OutHndlStream.Destroy;
End;

Constructor TStdOutStream.Create;

Begin
  inherited Create;
  fHandle:=HandleStream_StdOut;
End;

Destructor TStdOutStream.Destroy;

Begin
  WriteData;
  inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ This section: TStdErrStream Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TStdErrStream.Create;

Begin
  inherited Create;
  fHandle:=HandleStream_StdErr;
End;



Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  29-Aug-03  WD         TStream.ReadLn: Berr. der neuen Position
  07-Sep-04  WD         TMemoryStream: Einbau von InsertStream
  15-Jan-08  WD         Klasse tTempFileStream und TStream.Clear eingebaut und 
                        div. Korrekturen und Verbesserungen.
  29-Jan-08  WD         TMemoryStream: Einbau von LoadFromStreamLen
  12-Feb-08  WD         TStream: Einbau der Funktion AnsiWriteLn
  19-Dec-08  WD         Klasse TStdInStream, tStdOutStream, tStdErrStream eingebaut.
  12-Feb-09  WD         Klasse tSharedMemoryStream
}
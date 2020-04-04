Unit uStringTableList;

Interface

Uses SysUtils, uString, uStream, uList;

type tcStringTableList = class(tStringList)
       private
         property duplicates;
         fByName : Boolean;
         fBlockList : tList;    // Liste aller Bloecke (inkl. der Texte)
       public
         Constructor Create; virtual;
         Destructor Destroy; Override;

         Function AddStringTable(iName : String; iStringTable : tStringList) : LongInt; Virtual;
         Function GetStringTable(iID : LongInt) : tStringList;
         Function WriteOutput(iStream : tMemorystream) : LongWord;
         Property ByName : Boolean Read fByName Write fByName;
     end;

type tcStringTableIDList = class(tcStringTableList)
       Public
         Constructor Create; virtual;
         Destructor Destroy; Override;

         Function WriteResIDInfo(iStream : tMemorystream) : LongWord;
         Function WriteOutput(iStream : tMemorystream) : LongWord;
     End;

Implementation

Uses uResDef;

Const cBlockCount = 15;

Type tpBlock=^tBlock;
     tBlock = Record
                Nr       : LongWord;
                PosIDInfo: LongWord;
                Daten    : Array[0..cBlockCount] of String;
              End;

Function tcStringTableIDList.WriteResIDInfo(iStream : tMemorystream) : LongWord;

Var Cou    : LongInt;
    StrItem  : tStrItem;
    ResIDInfo: trResIDInfo;
    ResID    : tStr5;
    ResTxt   : String;

    BlockNr   : LongWord;
    AltBlockNr: LongWord;
    BlockPos  : LongWord;
    Block     : tpBlock;

Begin
  Result:=0;
  AltBlockNr:=0;
  For Cou:=0 to Count-1 do
    Begin
      StrItem:=GetStrItem(Cou);
      BlockNr:=(StrItem.fID div 16)+1;
      BlockPos:=(StrItem.fID mod 16);
      if AltBlockNr<>BlockNr then
        Begin   // Schreiben der ResIDInfo nur dann wenn sich der Block aendert
          if AltBlockNr<>0 then
            Begin
              Block^.PosIDInfo:=iStream.Position;
              iStream.WriteBuffer(ResIDInfo, SizeOf(trResIDInfo));
            End;
          getMem(Block, sizeof(tBlock));
          Block^.Nr:=BlockNr;
          fBlockList.Add(Block);
          ResIDInfo.ResTyp   := 5;             // Ist bei Stringtabellen immer 5
          ResIDInfo.ResID    := BlockNr;
          ResIDInfo.Dummy1   := 3;             // Keine Ahnung warum hier 3?
          inc(Result);
        End;
      Split(StrItem.fString, ';', ResID, ResTxt);
      Block^.Daten[BlockPos]  := ResTxt;
      ResIDInfo.Offset   := 0; // iLen+Result;
      ResIDInfo.ResLength:= $ff; //  ResIDInfo.ResLength+Length(ResTxt);
      AltBlockNr:=BlockNr;
    End;

  if Count>0 then
    Begin
{ Letzte ResIDInfo auch noch abspeichern }
      Block^.PosIDInfo:=iStream.Position;
      iStream.WriteBuffer(ResIDInfo, SizeOf(trResIDInfo));
    End;
End;

Function tcStringTableIDList.WriteOutput(iStream : tMemorystream) : LongWord;

Var Cou,Cou1  : LongInt;
    Dummy_0353: Word;
    ResTxt    : String;
    ResLen    : Byte;
    Block     : tpBlock;
    StreamPos : LongWord;
    BlockPos  : LongWord;
    ResIDInfo : trResIDInfo;

Begin
  StreamPos:=iStream.Position;
  for cou:=0 to fBlockList.Count-1 do
    Begin
      BlockPos:=iStream.Position;
      Dummy_0353:=$0352;   // Keine Ahnung warum dies geschrieben wird.  Entsp = 850; Codepage?
      iStream.WriteBuffer(Dummy_0353, sizeof(Dummy_0353));
      Block:=fBlockList.Items[Cou];
      for cou1 :=0 to cBlockCount do
        Begin
{ Resource-Daten schreiben; Mit Laengen-Byte und 0-Terminierung }
          fillchar(ResTxt,255, #0);
          ResTxt:=Block^.Daten[Cou1];
          ResLen:=ord(ResTxt[0])+1;
          ResTxt[0]:=chr(ResLen);
          iStream.WriteBuffer(ResTxt,ResLen+1);
        end;

{ Lesen/Schreiben der Resource ID }
      iStream.Position:=Block^.PosIDInfo;
      iStream.ReadBuffer(ResIDInfo,sizeof(trResIDInfo));
      ResIDInfo.ResLength:=iStream.Size-BlockPos;
      iStream.Position:=Block^.PosIDInfo;
      iStream.WriteBuffer(ResIDInfo,sizeof(trResIDInfo));

{ Wieder ans Ende des Streams zeigen }
      iStream.Position:=iStream.Size;
    End;
  Result:=iStream.Position - StreamPos;
End;

Constructor tcStringTableIDList.Create;

Begin
  inherited Create;
  fBlockList.Create;
End;

Destructor tcStringTableIDList.Destroy;

var cou : LongInt;

Begin
  inherited Destroy;
  for cou:=0 to fBlockList.Count-1 do
    Freemem(fBlockList.Items[cou], sizeof(tBlock));
  fBlockList.Destroy;
End;



{ -------------------------------------------------------------------------------- }

Function tcStringTableList.AddStringTable(iName : String; iStringTable : tStringList) : LongInt;

Begin
  Result:=AddObject(iName, iStringTable);
End;

Function tcStringTableList.GetStringTable(iID : LongInt) : tStringList;

Var ResultObj : tObject absolute Result;

Begin
  ResultObj:=getObject(iID);
End;

Function  tcStringTableList.WriteOutput(iStream : tMemorystream) : LongWord;

var Cou, Cou1: LongInt;
    Cnt, Cnt1: Word;
    Len      : LongWord;
    ResStr   : tStringList;
    ResLastID: Word;
    TblName  : String;
    Txt      : String;
    ResID    : tStr5;
    ResTxt   : String;
    ID       : Word;
    StreamPos: LongWord;

Begin
  StreamPos:=iStream.Position;
  Cnt := Count;

// Anzahl der Stringtabellen schreiben
  iStream.WriteBuffer(cnt, SizeOf(Cnt));

// Schreiben der einzellnen Stringtabellen schreiben
  for Cou:=0 to Cnt-1 do
    Begin
      tblName:=Strings[Cou];
      ResStr :=GetStringTable(Cou);
      Cnt1:=ResStr.Count-1;

// Laenge der Stringtabelle schreiben
      Len:=4;
      for Cou1:=0 to Cnt1 do
        Begin
          Split(ResStr.Strings[Cou1], ';', ResID, ResTxt);
          Len:=Len+3+(Length(ResTxt));
        End;
      iStream.WriteBuffer(len, sizeOf(len));

// Name der StringTabelle schreiben
      iStream.WriteBuffer(tblName, length(tblName)+1);

// Anzahl der Text in dem StringTabelle
      ResLastID:=0;
      iStream.WriteBuffer(ResLastID, SizeOf(ResLastID));
      ResLastID:=ResStr.GetID(Cnt1);
      iStream.WriteBuffer(ResLastID, SizeOf(ResLastID));

// Texte schreiben
      for Cou1:=0 to Cnt1 do
        Begin
          Txt:=ResStr.Strings[Cou1];
          Split(ResStr.Strings[Cou1], ';', ResID, ResTxt);
          ID:=StrToInt(ResID);
          iStream.WriteBuffer(ID, 2);
          iStream.WriteBuffer(ResTxt, length(ResTxt)+1);
        End;
    End;
  Result:=iStream.Position - StreamPos;
End;

Constructor tcStringTableList.Create;

Begin
  inherited Create;
  Sorted:=true;
  duplicates:=dupError;
  fByName:=true;
End;

Destructor tcStringTableList.Destroy;

Begin
  inherited Destroy;
End;

Initialization
End.

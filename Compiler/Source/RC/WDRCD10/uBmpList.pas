Unit uBmpList;

Interface

Uses uList, uString, SysUtils, uStream, uSysInfo,
     uConst;

Const ResTyp_Icon        = 1;
      ResTyp_Bmp         = 2;
      ResTyp_StrringTable= 5;

type tcBmpNameList = class(tStringList)
       Private
         property duplicates;
         fResTyp : LongWord;
       Public
         Constructor Create; virtual;
         Destructor Destroy; Override;

         Function AddBitmap(iName : String; iFilename : tFilename) : LongInt; Virtual;
         Function WriteOutput(iStream : tMemorystream; StartPosWin : LongInt) : LongWord; virtual;
         Property ResTyp : LongWord Read fResTyp Write fResTyp;
     end;

type tcBmpIDList = class(tcBmpNameList)
       Function AddBitmap(iID: LongInt; iFilename : tFilename) : LongInt; Virtual;
       Function WriteResIDInfo(iStream : tMemorystream) : LongWord;
       Function WriteOutput(iStream : tMemorystream) : LongWord; virtual;
     End;

Implementation

Uses uResDef;

Function tcBmpIDList.AddBitmap(iID: LongInt; iFilename : tFilename) : LongInt;

Begin
  Result:=inherited AddBitmap(toStr(iID), iFilename);
  PutID(Result, iID);
End;

Function tcBmpIDList.WriteResIDInfo(iStream : tMemorystream) : LongWord;

Var Cou      : LongInt;
    StrItem  : tStrItem;
    ResIDInfo: trResIDInfo;

Begin
  Result:=Count;
  For Cou:=0 to Result-1 do
    Begin
      StrItem:=GetStrItem(Cou);
      ResIDInfo.ResTyp   := fResTyp;
      ResIDInfo.ResID    := StrItem.fID;
      ResIDInfo.ResLength:= tMemoryStream(StrItem.fObject).Size;
      ResIDInfo.Dummy1   := 3;                   // Keine Ahnung warum hier 3?
      ResIDInfo.Offset   := $FF; // iLen+Result;

{ Jetzt die Stream-Position in der Liste Speichern }
      PutID(Cou, iStream.Position);

{ Resource-Informationen speichern }
      iStream.WriteBuffer(ResIDInfo, SizeOf(trResIDInfo));
    End;
End;

Function tcBmpIDList.WriteOutput(iStream : tMemorystream) : LongWord;

var Cnt,Cou  : LongInt;
    StrItem  : tStrItem;
    BmpStream: tMemoryStream;;
    StreamPos: LongWord;
    ResIDInfo : trResIDInfo;

Begin
  Cnt := Count;
  StreamPos:=iStream.Position;

  for Cou:=0 to Cnt-1 do
    Begin
//      Writeln('POs:',tohex(StreamPos),', ', Count);
{ Laenge in die ResId-Infos speichern }
      StrItem:=GetStrItem(Cou);
      iStream.Position:=StrItem.fID;
      iStream.ReadBuffer(ResIDInfo,sizeof(trResIDInfo));
      ResIDInfo.Offset:=iStream.Size - goPosResIDEnde;
      iStream.Position:=StrItem.fID;
      iStream.WriteBuffer(ResIDInfo,sizeof(trResIDInfo));

{ Den Zeiger wieder an das Ende setzen }
      iStream.Position:=iStream.Size;

{ Speichern des Bitmaps }
      bmpStream:= tMemoryStream(StrItem.fObject);
      iStream.WriteBuffer(BmpStream.Memory[0], BmpStream.Size);
    End;
  Result:=iStream.Position - StreamPos;
End;



{ -------------------------------------------------------------------------------- }

Function tcBmpNameList.WriteOutput(iStream : tMemorystream; StartposWin : LongInt) : LongWord;

var Cnt,Cou  : LongInt;
    sz,po    : LongInt;
    BmpStream: tMemoryStream;;
    Name     : String;
    StreamPos: LongWord;

Begin
  Cnt := Count;
  StreamPos:=iStream.Position;
  iStream.WriteBuffer(cnt, 2); // Anzahl des Bitmaps schreiben (Word)
  for Cou:=0 to Cnt-1 do
    Begin
      Name:=Strings[Cou];
      bmpStream:= tMemoryStream(GetObject(Cou));
      sz:=BmpStream.Size;
      if CompSystem=OS2
        then po:=0
        else po:=StartPosWin;
      sz:=sz-po;
      iStream.WriteBuffer(sz, 4);        // Laenge des Icons schreiben
      iStream.WriteBuffer(Name, length(Name)+1);
      iStream.WriteBuffer(BmpStream.Memory[po], sz);
    End;
  Result:=iStream.Position - StreamPos;
End;

Function tcBmpNameList.AddBitmap(iName : String; iFilename : tFilename) : LongInt;

Var Stream : tMemoryStream;

Begin
  Stream.Create;
  Stream.LoadFromFile(iFilename);
  Result:=AddObject(iName, Stream);
End;

Constructor tcBmpNameList.Create;

Begin
  inherited Create;
  Sorted:=true;
  duplicates:=dupError;
  fResTyp:=0;
End;

Destructor tcBmpNameList.Destroy;

Begin
  inherited Destroy;
End;

Initialization
End.

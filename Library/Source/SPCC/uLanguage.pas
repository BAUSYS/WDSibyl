Unit uLanguage;

Interface

Uses SysUtils,
     uString, uList,
     uStream;   { Stream-Verarbeitung }

Const LngClassEntry    = 'CL_';
      LngMenuItemEntry = 'MI_';


type tLanguageTable=Class(tStringList)
       Private
         Function GetEntry(ObjName : String) : String;
//       Procedure SetEntry(ObjName, Value : String);
       Public
         Function AddEntry(Const ObjName, Value: String): LongInt; Virtual;

         Property Entry[ObjName : String] : String Read GetEntry;
       Protected
         Procedure FreeItem(AObject: TObject); Override;
     End;


type tLanguageFile=Class
       Private
         fLangFileName: tFilename;
         fTable   : tLanguageTable;

         Procedure SetLangFileName(LangFilename : tFilename);
         Procedure Clear;

       Public
         Function GetText(iEntry, iDefault : String) : String;
         constructor Create(LangFilename : tFilename); virtual;
         Destructor Destroy; virtual;

       Published
         Property LangFileName : tFilename      Read fLangFileName Write SetLangFileName;
         Property Table        : tLanguageTable Read fTable;
     End;


Implementation

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TLanguageFile                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure tLanguageFile.Clear;

Begin
  fTable.Clear;
End;

Function tLanguageFile.GetText(iEntry, iDefault : String) : String;

Begin
  try
    Result:=fTable.Entry[iEntry];
  except
    Result:=iDefault;
  end;
End;

Procedure tLanguageFile.SetLangFileName(LangFilename : tFilename);

var f    : tFileStream;
    s,s1 : String;

Begin
  fLangFileName:=LangFileName;
  Clear;
  f.Create(fLangFileName, Stream_OpenRead);
  while f.EndOfData=false do
    Begin
      s:=f.Readln;
      if s='' then Continue;
      split(s,' ',s,s1);
      fTable.AddEntry(s,s1);
    End;
  f.Destroy;
End;

constructor tLanguageFile.Create(LangFilename : tFilename);

Begin
  inherited Create;
  fTable.Create;
  SetLangFileName(LangFileName);
End;

Destructor tLanguageFile.Destroy;

Begin
  fTable.Destroy;
  inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Portable Component Classes (SPCC)                                 บ
บ                                                                           บ
บ This section: TLanguageTable                                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function tLanguageTable.GetEntry(ObjName : String) : String;

Var LTItem : tStringValue;
    Index  : LongInt;

Begin
  if find(ObjName, Index)
    then
      Begin
        LTItem:=tStringValue(GetObject(Index));
        Result:=LTItem.Text;
      End
    else
      Begin
        Result:='';
        Raise EListError.Create('Entry not found');
      End;
End;

/*
Procedure tLanguageTable.SetEntry(ObjName, Value : String);

Begin
End;
*/

Function tLanguageTable.AddEntry(Const ObjName, Value: String): LongInt;

Var LTItem : tStringValue;

Begin
  LTItem.Create(Value);
  AddObjectid(Uppercase(ObjName), LTItem, 0);
End;

Procedure tLanguageTable.FreeItem(AObject: TObject);

Var LTItem : TStringValue absolute AObject;

Begin
  inherited FreeItem(aObject);
  aObject.Destroy;
End;

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  03-Mar-06  WD         Datei erstellt und ins Projekt eingebaut

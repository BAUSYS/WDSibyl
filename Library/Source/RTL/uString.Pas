{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for OS/2                                      บ
 บ                                                                          บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit uString;

Interface

Uses SysUtils,
     uStream,
     uList;

// UniCode: p:\os2tk45\h\unidef.h

Type TSysCharSet = Set of Char;

Type
// Char-Typen
  tChr1    = Array[0..1] of Char;
  tChr2    = Array[0..2] of Char;
  tChr3    = Array[0..3] of Char;
  tChr4    = Array[0..4] of Char;
  tChr5    = Array[0..5] of Char;
  tChr6    = Array[0..6] of Char;
  tChr7    = Array[0..7] of Char;
  tChr8    = Array[0..8] of Char;
  tChr9    = Array[0..9] of Char;
  tChr10   = Array[0..10] of Char;
  tChr11   = Array[0..11] of Char;
  tChr12   = Array[0..12] of Char;
  tChr13   = Array[0..13] of Char;
  tChr14   = Array[0..14] of Char;
  tChr15   = Array[0..15] of Char;
  tChr16   = Array[0..16] of Char;
  tChr17   = Array[0..17] of Char;
  tChr18   = Array[0..18] of Char;
  tChr19   = Array[0..19] of Char;
  tChr20   = Array[0..20] of Char;
  tChr21   = Array[0..21] of Char;
  tChr22   = Array[0..22] of Char;
  tChr23   = Array[0..23] of Char;
  tChr24   = Array[0..24] of Char;
  tChr25   = Array[0..25] of Char;
  tChr26   = Array[0..26] of Char;
  tChr27   = Array[0..27] of Char;
  tChr28   = Array[0..28] of Char;
  tChr29   = Array[0..29] of Char;
  tChr30   = Array[0..30] of Char;
  tChr31   = Array[0..31] of Char;
  tChr255  = Array[0..255] of Char;
  tChr4000 = Array[0..4000] of Char;

// Uni-String
  tUni10   = Array[0..10] of tUniChar;
  tUni15   = Array[0..15] of tUniChar;
  tUni20   = Array[0..20] of tUniChar;
  tUni25   = Array[0..25] of tUniChar;
  tUni30   = Array[0..30] of tUniChar;


// String-Typen
  tStr2  = String[2];
  tStr3  = String[3];
  tStr4  = String[4];
  tStr5  = String[5];
  tStr6  = String[6];
  tStr7  = String[7];
  tStr8  = String[8];
  tStr9  = String[8];
  tStr10 = String[10];
  tStr11 = String[11];
  tStr12 = String[12];
  tStr13 = String[13];
  tStr14 = String[14];
  tStr15 = String[15];
  tStr16 = String[16];
  tStr17 = String[17];
  tStr18 = String[18];
  tStr19 = String[19];
  tStr20 = String[20];
  tStr21 = String[21];
  tStr22 = String[22];
  tStr23 = String[23];
  tStr24 = String[24];
  tStr25 = String[25];
  tStr26 = String[26];
  tStr27 = String[27];
  tStr28 = String[28];
  tStr29 = String[29];
  tStr30 = String[30];
  tStr31 = String[31];
  tStr40 = String[40];
  tStr45 = String[45];
  tStr50 = String[50];
  tStr55 = String[55];
  tStr60 = String[60];
  tStr70 = String[70];
  tStr80 = String[80];
  tStr90 = String[90];
  tStr100= String[100];
  tStr110= String[110];
  tStr120= String[120];
  tStr128= String[128];
  tStr130= String[130];

{ Allgemeines String-Objekt }
type pStringValue=^tStringValue;
     TStringValue=Class
       Private
         fText : String;
       Public
         Constructor Create(iText : String);
         Procedure Add(iText : String);

         Property Text : String Read fText Write fText;
     End;

{ Allgemeines AnsiString-Objekt }
type pAnsiStringValue=^tAnsiStringValue;
     TAnsiStringValue=Class
       Private
         fText : AnsiString;
       Public
         Constructor Create(iText : AnsiString);
         Procedure Add(iText : AnsiString);

         Property Text : AnsiString Read fText Write fText;
     End;

{ TStrings Is an Abstract base Class For storing a
  Number Of Strings. Every String can be associated
  With A Value As well As With an Object. So, If you
  want To Store simple Strings, Or collections Of
  keys And values, Or collection Of named Objects,
  TStrings Is the Abstract ancestor you should
  derive your Class from. }

Type
  EStringListError = Class(Exception);
  TStrings = Class(TObject)
     Private
       FUpdateSemaphore: LongInt;
       FPreventFree    : Boolean;
       fTabSeperator   : Char;
       Function GetValue(Const Name: String): String;
       Procedure SetValue(Const Name, Value: String);
       Function FindValue(Const Name: String; Var Value: String): LongInt;
       Function GetName(Index: LongInt): String;
       Function GetMaxLength : Integer;
       Function GetMinLength : Integer;
     Protected
       Function Get(Index: LongInt): String; Virtual; Abstract;
       Function GetCount: LongInt; Virtual; Abstract;
       Function GetObject(Index: LongInt): TObject; Virtual;
       Function GetTab(Index:LongInt; TabPos: LongInt):String; Virtual;
       Function GetID(Index: LongInt): LongInt; Virtual;
       Procedure Put(Index: LongInt; Const S: String); Virtual;
       Procedure PutObject(Index: LongInt; AObject: TObject); Virtual;
       Procedure PutID(Index: LongInt; id : LongInt); Virtual;
       Procedure SetUpdateState(Updating: Boolean); Virtual;
       Function GetTextStr: AnsiString; Virtual;
       Procedure SetTextStr(Const Value: AnsiString); Virtual;
     Public
       Function Add(Const S: String): LongInt; Virtual;
       Function AddObject(Const S: String; AObject: TObject): LongInt; Virtual;
       Function AddObjectID(Const S: String; AObject: TObject; ID : LongInt): LongInt; Virtual;
       Procedure AddStrings(AStrings: TStrings); Virtual;
       Procedure Append(Const S: String);
       Procedure Assign(AStrings: TStrings); Virtual;
       Procedure BeginUpdate;
       Procedure Clear; Virtual; Abstract;
       Procedure Delete(Index: LongInt); Virtual; Abstract;
       Procedure EndUpdate;
       Function Equals(AStrings: TStrings): Boolean;
       Procedure Exchange(Index1, Index2: LongInt); Virtual;
       Function GetText: PChar;Virtual;
       Function IndexOf(Const S: String): LongInt; Virtual;
       Function IndexOfName(Const Name: String): LongInt;
       Function IndexOfObject(AObject: TObject): LongInt;
       Function IndexOfID(ID: LongInt): LongInt;
       Procedure Insert(Index: LongInt; Const S: String); Virtual; Abstract;
       Procedure InsertObject(Index: LongInt; Const S: String; AObject: TObject); Virtual;
       Procedure InsertID(Index: LongInt; Const S: String; ID:LongInt); Virtual;
       Procedure LoadFromFile(Const FileName: String);
       Procedure SetText(Text: PChar);Virtual;
       Procedure LoadFromStream(Stream: TStream); Virtual;
       Procedure Move(CurIndex, NewIndex: LongInt); Virtual;
       Procedure SaveToFile(Const FileName: String);
       Procedure SaveToStream(Stream: TStream); Virtual;
     Public
       Property Names[Index: LongInt]: String Read GetName;
       Property Count: LongInt Read GetCount;
       Property Objects[Index: LongInt]: TObject Read GetObject Write PutObject;
       Property IDs[Index:LongInt]: LongInt Read GetID Write PutID;
       Property values[Const Name: String]: String Read GetValue Write SetValue;
       Property Strings[Index: LongInt]: String Read Get Write Put; Default;
       Property StringsTab[Index: LongInt; TabPos: LongInt]: String Read GetTab;
       Property Text         : AnsiString Read GetTextStr    Write SetTextStr;
       Property TabSeperato  : Char       Read fTabSeperator Write fTabSeperator;
       Property MaxLength    : Integer    Read GetMaxLength;
       Property MinLength    : Integer    Read GetMinLength;
  End;

{ TStringList Is A concrete Class derived
  from TStrings. TStringList stores its Items
  In A Private field Of Type TList. It's very
  fast, since it performs binary Search For
  retrieving Objects by Name. you can specify
  whether you want TStringList To be sorted Or
  unsorted As well As Case-sensitive Or Not.
  you can also specify the way A TStringList
  Object handles duplicate entries.

  TStringList Is able To notify the user when
  the list's Data changes Or has been changed.
  Use the properties OnChange And OnChanged. }

{ StrItem Is A space-efficient way To Store an Object
  associated With A String. it Is used inside TStringList. }

Type
  PStrItem = ^TStrItem;
  TStrItem = Record
    fID    : LongInt;
    FObject: TObject;
    FString: String;
  End;

Type
  TDuplicates = (dupIgnore, dupAccept, dupError);
  TFreeStringListItem = Procedure(Sender:TObject;AObject:TObject) Of Object;

Type
  TStringList = Class(TStrings)
  Private
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FCaseSensitive: Boolean;
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;
    FOnFreeItem: TFreeStringListItem;
    FLockChange:Boolean;
    Procedure SetSorted(Value: Boolean);
    Procedure SetCaseSensitive(Value: Boolean);
  Protected
    FList: TList;
    Procedure BottomUpHeapSort; Virtual;
    Procedure Changed; Virtual;
    Procedure Changing; Virtual;
    Function Get(Index: LongInt): String; Override;
    Function GetCount: LongInt; Override;
    Function GetObject(Index: LongInt): TObject; Override;
    Function GetID(Index: LongInt): LongInt; Override;
    Function GetStrItem(Index: LongInt) : tStrItem;
    Procedure Put(Index: LongInt; Const S: String); Override;
    Procedure PutObject(Index: LongInt; AObject: TObject); Override;
    Procedure PutID(Index: LongInt; ID:LongInt); Override;
    Procedure SetUpdateState(Updating: Boolean); Override;
    Procedure FreeItem(AObject: TObject);Virtual;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function Add(Const S: String): LongInt; Override;
    Procedure AddSplit(Const iText: String; Const iTrenn: Char);
    Procedure AnsiAddSplit(Const iText: AnsiString; Const iTrenn: Char); virtual;
    Procedure Clear; Override;
    Procedure Delete(Index: LongInt); Override;
    Procedure Exchange(Index1, Index2: LongInt); Override;
    Function Find(Const S: String; Var Index: LongInt): Boolean; Virtual;
    Function IndexOf(Const S: String): LongInt; Override;
    Procedure Insert(Index: LongInt; Const S: String); Override;
    Procedure Sort; Virtual;
    Function Compare(iStringList : tStringList) : Boolean; Virtual;

    Property Duplicates: TDuplicates Read FDuplicates Write FDuplicates;
    Property CaseSensitive: Boolean Read FCaseSensitive Write SetCaseSensitive;
    Property Sorted: Boolean Read FSorted Write SetSorted;
    Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
    Property OnChanging: TNotifyEvent Read FOnChanging Write FOnChanging;
    Property OnFreeItem: TFreeStringListItem Read FOnFreeItem Write FOnFreeItem;
  End;

Type
  tDirList = Class(tStringList)
    Private
    Protected
    Public
      Function Add(Const iDir: tFileName): LongInt; Override;
      Function FindFile(iFileName : tFileName) : tFileName;
  End;


{ TAnsiStringList 
  TAsniStringList stores its Items
  In A Private field Of Type TList. It's very
  fast, since it performs binary Search For
  retrieving Objects by Name. you can specify
  whether you want TAnsiStringList To be sorted Or
  unsorted As well As Case-sensitive Or Not.
  you can also specify the way A TStringList
  Object handles duplicate entries.

  TAnsiStringList Is able To notify the user when
  the list's Data changes Or has been changed.
  Use the properties OnChange And OnChanged. }

{ AnsiStrItem Is A space-efficient way To Store an Object
  associated With A AnsiString. it Is used inside TStringList. }

Type
  PAnsiStrItem = ^TAnsiStrItem;
  TAnsiStrItem = Record
    fID    : LongInt;
    FObject: TObject;
    FString: AnsiString;
  End;

Type
  TAnsiStringList = Class(TStringList)
    Private
      FSorted: Boolean;
      FDuplicates: TDuplicates;
     
      Procedure SetSorted(Value: Boolean);
      Procedure BottomUpHeapSort; Override;
    Protected
      Function Get(Index: LongInt): AnsiString; Virtual;  
      Function GetStrItem(Index: LongInt) : tAnsiStrItem; Virtual;
      
      Procedure Put(Index: LongInt; Const S: AnsiString); Virtual;
  
    Public
      Function Add(Const S: AnsiString): LongInt; Virtual;
      Function AddObject(Const S: AnsiString; AObject: TObject): LongInt; Virtual;
      Function AddObjectID(Const S: AnsiString; AObject: TObject; ID : LongInt): LongInt; Virtual;
      Procedure AddStrings(AStrings: TStrings); Override;
      Procedure AnsiAddSplit(Const iText: AnsiString; Const iTrenn: Char); Override;
      Procedure Append(Const S: AnsiString); Virtual;
      Function Equals(AStrings: TStrings): Boolean; 
      Function Find(Const S: AnsiString; Var Index: LongInt): Boolean; Virtual;
      Procedure Insert(Index: LongInt; Const S: AnsiString); Virtual;
      Procedure InsertObject(Index: LongInt; Const S: AnsiString; AObject: TObject); Virtual;
      Procedure InsertID(Index: LongInt; Const S: AnsiString; ID:LongInt); Virtual;
      Function IndexOf(Const S: AnsiString): LongInt; Virtual;
      Function IndexOfName(Const Name: AnsiString): LongInt; Virtual;
      Procedure LoadFromStream(Stream: TStream); Override;
      Procedure SaveToStream(Stream: TStream); Override;
      
      Property Strings[Index: LongInt]: AnsiString Read Get Write Put; Default;
      Property Duplicates: TDuplicates Read FDuplicates Write FDuplicates;
      Property Sorted: Boolean Read FSorted Write SetSorted;
  End;


// ---------------------------------------------------------------------------

Function  NewStrItem(Const AString: String; AObject: TObject): PStrItem;
Function  NewAnsiStrItem(Const AString: AnsiString; AObject: TObject): PAnsiStrItem;
Procedure DisposeStrItem(P: PStrItem);
Procedure DisposeAnsiStrItem(P: PAnsiStrItem);

{ Sonder Funktionen }
Function Replace(St : String; FindChar, ReplaceChar : Char) : String;
{ Ersetzt ein Zeichen im String }

Function ReplaceAll(St : String; FindChar, ReplaceChar : Char) : String;
{ Ersetzt alle Zeichen in einem String }

Function ReplaceStr(iStr : String; iFindStr, iReplaceStr : String) : String;
{ Sucht in dem String "iStr" nach dem String "iFindStr" und ersetzt diesen mit
  dem Wert iReplaceStr }

Function CopyTab(iText : String; iSep : Char; iStart: Byte; var iEnde : Byte) : String;
{ Kopiert den Text von der angegebenen Position bis zum naechsten TAB }

Function Split(iText : String; iSep : String; var iResultWert1, iResultWert2 : String) : Byte;
{ Ermittelt aus dem String das istGleich-Zeichen und gibt die Werte vor und
  nach dem Zeichen aus. Als Returnwert wird noch die Position vom
  Gleichheitszeichen zurueckgegeben }

Function SplitAll(iText : String; iSep : Char; iResult : tStringList) : LongInt;
{ Ermittelt aus dem String das istGleich-Zeichen und gibt die Werte in der
  Variable iResult zurck. Die Anzahl der List ist in dem Rueckgabe gespeichert }

Function FillString(Anzahl : Byte; Zeichen : Char) : String;
{ Fuellt den Return-String (max ang. Anzahl) mit dem ang. Zeichen }

Function iif(iBool : Boolean; iTrueValue, iFalseValue : String) : String;
{ Liefert den Wert iTrueValue wenn iBool "true" ist, ansonsten iFalseValue. }

Function PosN(CONST substr, s:STRING; p : Byte) : Byte;
{ Sucht nach p-ten String "substr" im String "s" }

Function LastPos(iCh : Char; iStr : string) : Byte;
{ Sucht nach dem letzten Zeichen im String }

function ExtractStrings(Separators, WhiteSpace: TSysCharSet; Content: PChar;
                        var Strings: TStrings): LongInt;
{ Mit ExtractStrings kann man eine String-Liste mit den Teil-Strings des in Content bergebenen
nullterminierten Strings fllen.
Separators enthlt die Trennzeichen, mit denen die Teil-Strings voneinander getrennt sind.
Wagenrcklaufzeichen, Newline-Zeichen und Anfhrungszeichen (einfach oder doppelt) werden
immer als Trennzeichen behandelt.
Trennzeichen werden innerhalb eines Strings mit Anfhrungszeichen bis zum letzten schliessenden
Anfhrungszeichen ignoriert. (Beachte, dass Zeichen in Anfhrungszeichen in einem String mit
Anfhrungszeichen vorkommen k”nnen, wenn Anfhrungszeichen doppelt verwendet werden.)
WhiteSpace enthlt Zeichen, die bei der Analyse von Content ignoriert werden sollen, wenn sie am
Anfang eines Strings vorkommen.
Content ist der nullterminierte String, der in Teil-Strings zerlegt werden soll.
Strings ist die String-Liste, der alle aus Content extrahierten Teil-Strings hinzugefgt werden.
Diese Liste wird von ExtractStrings nicht gel”scht, d.h. alle in ihr enthaltenen Strings bleiben
beim Aufruf von ExtractStrings erhalten.
ExtractStrings gibt die Anzahl der Strings zurck, die dem Strings-Parameter hinzugefgt wurden.
Hinweis: ExtractStrings fgt der Liste keine leeren Strings hinzu.

Fills a string list with substrings parsed from a delimited list.
Separators is a set of characters that are used as delimiters, separating the substrings, where
Carriage returns, newline characters, and quote characters (single or double) are always treated
as separators. WhiteSpace is a set of characters to be ignored when parsing Content if they occur
at the beginning of a string. Content is the null-terminated string to parse into substrings.
Strings is a string list to which all substrings parsed from Content are added.
The function returns the number of strings added to the Strings parameter. }

// AnsiString-Codes
// ===============

function UTF8ToAnsi(x: string): ansistring;
// Function that recieves UTF8 string and converts to ansi string
function AnsiTrimLeft(Const S: AnsiString): AnsiString;
// Entfernt alle Leerzeiche am Anfang des Textes
function AnsiTrimRight(Const S: AnsiString): AnsiString;
// Entfernt alle Leerzeiche am Ende des Textes
function AnsiTrim(Const S: AnsiString): AnsiString;
// Entfernt alle Leerzeiche am Anfang und am Ende des angegegbene Textes


// UniString-Codes
// ===============
Function UniChar2UniChar(ch : Char) : tUniChar;
// Konvertiert ein Char in ein UniChar.
Function UniUniChar2Char(ch : tUniChar) : Char;
// Konvertiert ein UniChar in ein Char.
Function UniStrlen(const Str : pUniChar) : LongWord;
// Eermittelt die Laenge des Uni-Strings
Procedure UniStrPCopy(Dest :pUniChar; const Source: String);
// Kopiert ein String in ein Uni-String
Function UniStrPas(Str : pUniChar) : String;
// Kopiert ein Uni-String in ein String;
Function UniStrLPas(Str : pUnichar; MaxLen: Byte) : String;
// Kopiert eine Laenge von dem UniString zu ein Pascal-String
Function UniStrAnsi(Str : pUniChar) : AnsiString;
// Kopiert den Uni-String in ein AnsiString
Function UniStrLAnsi(Str : pUniChar; MaxLen : LongWord) : AnsiString;
// Kopiert die angegebene Laenge von dem Uni-String in ein AnsiString

Function UniStrScanPos(Str: pUniChar; Chr: tUniChar): LongInt;
// Durchsucht den Uni-String nach der angegebenen Uni-Char
Function UniStrScan(Str: pUniChar; Chr: tUniChar): PUniChar;
// Durchsucht den Uni-String nach der angegebenen Uni-Char

/* Rexx-Aehnliche funktionen */
Function rx_word(Str : String; WrdNum : LongWord) : String;
// rx_word uebergibt das WrdNum-te durch Leerzeichen begrenzte Wort in zeichenkette.
// Sind weniger als WrdNum Woerter in zeichenkette enthalten, so wird eine
// Leerstringe uebergeben. Diese Funktion entspricht rx_SubWord(string,n,1).

Implementation

Uses SysUtils;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Diverese AnsiString-Funktionen und Prozeduren                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

function AnsiTrimLeft(Const S: AnsiString): AnsiString;

Var L, R: LongInt;

Begin
  R := Length(S);
  L := 1;
  While (L <= R) And (S[L] <= ' ') Do Inc(L);
  Result := AnsiCopy(S, L, R - L + 1);
End;

function AnsiTrimRight(Const S: AnsiString): AnsiString;

Var R: LongInt;

Begin
  R := Length(S);
  While (R > 0) And (S[R] <= ' ') Do Dec(R);
  Result := AnsiCopy(S, 1, R);
End;

function AnsiTrim(Const S: AnsiString): AnsiString;

Var L, R: LongInt;

Begin
  R := Length(S);
  While (R > 0) And (S[R] <= ' ') Do Dec(R);
  L := 1;
  While (L <= R) And (S[L] <= ' ') Do Inc(L);
  Result := AnsiCopy(S, L, R - L + 1);

End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Diverese UniString-Funktionen und Prozeduren                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function UniChar2UniChar(ch : Char) : tUniChar;

Begin
  Result.chW:=ord(ch);
End;

Function UniUniChar2Char(ch : tUniChar) : Char;

Begin
  if ch.chW > 128 then
    case ch.chW of
      214 : Result:='';
      223 : Result:='แ';
      228 : Result:='';
      246 : Result:='1';
      252 : Result:='';
      else Writeln('UniUniChar2Char: ',ch.chW);
    end
  else Result:=ch.ch[0];
End;

Function UniStrlen(const Str : pUniChar) : LongWord;

var UniStr : pUniCodeString absolute Str;

Begin
  Result:=0;
  While (UniStr^[Result].chW<>0) do
    inc(Result);
End;

Procedure UniStrPCopy(Dest :pUniChar; const Source: String);

var cou,Cou1 : LongWord;
    d        : pUniCodeString absolute Dest;

Begin
  Cou1:=0;
  for Cou:=1 to length(Source) do
    Begin
      d^[Cou1]:=UniChar2UniChar(Source[cou]);
      inc(Cou1);
    end;
  d^[Cou1].chW:=0;
End;

Function UniStrPas(Str : pUniChar) : String;

Begin
  result:=UniStrLPas(Str, sizeof(result));
End;

Function UniStrLPas(Str : pUnichar; MaxLen: Byte) : String;

Var d   : pUniCodeString absolute Str;
    l,ls: LongInt;

Begin
  Result:='';
  l:=0;
  ls:=1;
  While (d^[l].chW<>0) and (ls<=MaxLen) do
    Begin
      Result[ls]:=UniUniChar2Char(d^[l]);
      inc(l);
      inc(ls);
    End;
  Result[0]:=chr(l);
End;

Function UniStrAnsi(Str : pUniChar) : AnsiString;

Begin
  Result:=UniStrLAnsi(Str, MAXLONGWORD);
End;

Function UniStrLAnsi(Str : pUniChar; MaxLen : LongWord) : AnsiString;

Var d   : pUniCodeString absolute Str;
    l,ls: LongWord;

Begin
  Result:='';
  l:=0;
  ls:=1;
  While (d^[l].chW<>0) and (ls<=MaxLen) do
    Begin
      Result:=Result+UniUniChar2Char(d^[l]);
      inc(l);
      inc(ls);
    End;
End;


Function UniStrScanPos(Str: pUniChar; Chr: tUniChar): LongInt;

var d : pUniCodeString absolute Str;
    c : tUniChar;

Begin
  Result:=0;
  c:=d^[0];
  while (c.chw <> chr.chw) and (c.chw>0) do
    Begin
      inc(Result);
      c:=d^[Result];
    End;
  if c.chw=0 then
    result:=0;
End;


Function UniStrScan(Str: pUniChar; Chr: tUniChar): PUniChar;

var d : pUniCodeString absolute Str;
    l : LongInt;

Begin
  result:=nil;
  l:=UniStrScanPos(str,chr);
  if l<>0 then
    result:=@d^[l];    
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Diverese Funktionen und Prozeduren                                        บ
บ                                                                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function PosN(CONST substr, s:STRING; p : Byte) : Byte;

var po, cou : LongInt;
    str     : String;

Begin
  result:=0;
  if p=0 then exit;
  str:=s;
  cou:=1;
  while cou<p do
    Begin
      po:=pos(substr, str);
      if po=0 then
        Begin
          result:=0;
          exit;
        End;
      str:=copy(str,po+1,255);
      result:=Result+po;
      inc(cou);
    End;
End;

Function LastPos(iCh : Char; iStr : string):byte;

begin
  result :=Length(iStr);
  while (result>0) and (iStr[result] <> iCh) do
    dec(result);
End;


Function iif(iBool : Boolean; iTrueValue, iFalseValue : String) : String;

Begin
  if iBool
    then Result:=iTrueValue
    else Result:=iFalseValue;
End;

Function Split(iText : String; iSep : String; var iResultWert1, iResultWert2 : String) : Byte;

Begin
  Result:=Pos(iSep, iText);
  if Result = 0
    then
      Begin
        iResultWert1:=iText;
        iResultWert2:='';
      End
    else
      Begin
        iResultWert1:=Copy(iText, 0, Result-1);
        iResultWert2:=Copy(iText, Result+length(iSep), Length(iText)-Result+1);
      End;
End;

Function SplitAll(iText : String; iSep : Char; iResult : tStringList) : LongInt;

Var po   : Byte;
    oldPo: Byte;

Begin
  Result:=0;
  oldPo:=0;
  for po:=1 to length(iText) do
    if iText[po]=iSep then
      Begin
        iResult.Add(copy(iText,oldPo+1, po-oldpo-1));
        oldpo:=po;
      End;
  iResult.Add(copy(iText,oldPo+1, length(iText)-oldpo));

  Result:=iResult.Count;
End;

Function CopyTab(iText : String; iSep: Char; iStart: Byte; var iEnde : Byte) : String;

Var len : Byte;

Begin
  Fillchar(Result,255,#0);
  iEnde:=iStart;
  Len:=Length(iText);
  Repeat
    Result[iEnde-iStart+1]:=iText[iEnde];
    inc(iEnde);
  until (iText[iEnde] = iSep) or (iEnde>Len);
  Result[0]:=chr(iEnde-iStart);
  dec(iEnde);
End;


Function ReplaceStr(iStr : String; iFindStr, iReplaceStr : String) : String;

Var p : Byte;

Begin
  P:=Pos(iFindStr,iStr);
  if p=0
    then Result:=iStr
    else Result:=Copy(iStr,1,P-1) + iReplaceStr + Copy(iStr, p+length(iFindStr), 255);
End;


Function Replace(St : String; FindChar, ReplaceChar : Char) : String;

Var P : Byte;

Begin
  Result:=St;
  P:=Pos(FindChar,Result);
  if p>0 then Result[p]:=ReplaceChar;
End;

Function ReplaceAll(St : String; FindChar, ReplaceChar : Char) : String;

Var P : Byte;

Begin
  Result:=St;
  For P:=1 to Length(Result) do
    if Result[P]=FindChar then Result[P]:=ReplaceChar;
End;

Function FillString(Anzahl : Byte; Zeichen : Char) : String;

Begin
 if Anzahl=0
  then result:=''
  else FillChar(result,255,Zeichen);
 Result[0]:=chr(Anzahl);
End;

{ --- Utility functions For TStrItem --- }

Function NewStrItem(Const AString: String; AObject: TObject): PStrItem;
Begin
  GetMem(Result, Sizeof(LongInt) + SizeOf(TObject) + Length(AString) + 1);
  Result^.FId     := 0;
  Result^.FObject := AObject;
  Result^.FString := AString;
End;

Procedure DisposeStrItem(P: PStrItem);
Begin
  FreeMem(P, Sizeof(LongInt) + SizeOf(TObject) + Length(P^.FString) + 1);
End;

Function NewAnsiStrItem(Const AString: AnsiString; AObject: TObject): PAnsiStrItem;
Begin
  GetMem(Result, Sizeof(LongInt) + SizeOf(TObject) + Length(AString) + 1);
  Result^.FId     := 0;
  Result^.FObject := AObject;
  Result^.FString := AString;
End;

Procedure DisposeAnsiStrItem(P: PAnsiStrItem);
Begin
  FreeMem(P, Sizeof(LongInt) + SizeOf(TObject) + Length(P^.FString) + 1);
End;

function ExtractStrings(Separators, WhiteSpace: TSysCharSet; Content: PChar; VAR Strings: TStrings): LongInt;

var Start,Tail  : PChar;
    InQuote,eos : Boolean;
    QuoteChar   : Char;
    ws,sep      : TSysCharSet;
    s           : string;

begin
  Result:=0;

  if not Assigned(Content) then Exit;
  if Content^=#0 then Exit;
  if not Assigned(Strings) then Exit;

  Tail      := Content;
  InQuote   := False;
  QuoteChar := #0;
  ws  := WhiteSpace + [#10,#13];
  sep := Separators + [#0,#10,#13,'''','"'];
  Strings.BeginUpdate;
  try
    repeat
      while Tail^[0] in ws do Inc(Tail); //while Tail^ in ws...
      Start := Tail;
      while True do
      begin
        while (InQuote and not (Tail^[0] in [QuoteChar,#0])) or not (Tail^[0] in sep) do
          Inc(Tail);
        if Tail^[0] in ['''', '"']
        then begin
               If (QuoteChar = #0)
               then QuoteChar := Tail^
               else if (QuoteChar = Tail^)
                    then QuoteChar := #0;
               InQuote := (QuoteChar <> #0);
               Inc(Tail);
             end
        else Break;
      end;

      eos := (Tail^ = #0);

      if (Start <> Tail) and (Start^[0] <> #0)
      then begin
             {$ifdef Speed}
               SetString(s,Start,Long(Tail)-Long(Start));
             {$else}
               SetString(s,Start,Tail-Start);
             {$endif}
             try
               Strings.Add(s);
             except
             end;
             Inc(Result);
           end;

      If not eos then Inc(Tail);
    until eos;
  finally
    Strings.EndUpdate;
  end;
end;

// Function that recieves UTF8 string and converts to ansi string
// siehe Unit...
function UTF8ToAnsi(x: string): ansistring;
var i: integer;
    b1,b2: byte;
begin
  Result := x;
  i := 1;
  while i <= Length(Result) do
  begin
    if (ord(Result[i]) and $80) <> 0
    then begin
           b1 := ord(Result[i]);
           if (b1 and $F0) <> $C0
           then Result[i] := #128
           else begin
                  b2 := ord(Result[i + 1]);
                  Result[i] := Chr((b1 shl 6) or (b2 and $3F));
                  Delete(Result,i+1,1);
                end;
         end;
    inc(i);
  end;
end;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klasse: tStrings                                                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TStrings.Append(Const S: String);
Begin
  Add(S);
End;

Procedure TStrings.Put(Index: LongInt; Const S: String);
Var  Temp:TObject;
Begin
  Temp := GetObject(Index);
  Delete(Index);
  InsertObject(Index, S, Temp);
End;

{$HINTS OFF}
Function TStrings.GetObject(Index: LongInt): TObject;
Begin
  Result := Nil;
End;

Procedure TStrings.PutObject(Index: LongInt; AObject: TObject);
Begin
End;


Function TStrings.GetID(Index: LongInt): LongInt;
Begin
  Result := 0;
End;

Procedure TStrings.PutID(Index: LongInt; ID: LongInt);
Begin
End;

Function TStrings.GetTab(Index:LongInt; TabPos: LongInt):String;

Var p : Byte;

Begin
  Result:=get(Index);
  p:=PosN(fTabSeperator, Result, TabPos);
  Result:=CopyTab(Result, fTabSeperator, 1, p);
End;

{$HINTS ON}

Function TStrings.Add(Const S: String): LongInt;
Begin
  Result := Count;
  Insert(Result, S);
End;

Function TStrings.AddObject(Const S: String; AObject: TObject): LongInt;
Begin
  Result := Add(S);
  PutObject(Result, AObject);
  PutID(Result, 0);
End;

Function TStrings.AddObjectID(Const S: String; AObject: TObject; ID : LongInt): LongInt;

Begin
  Result := Add(S);
  PutObject(Result, AObject);
  PutID(Result, ID);
End;

Procedure TStrings.AddStrings(AStrings: TStrings);
Var
  I: LongInt;
Begin
  if AStrings=nil then exit;
  BeginUpdate;
  Try
    For I := 0 To AStrings.Count - 1 Do
      AddObjectID(AStrings.Get(I), AStrings.GetObject(I), AStrings.GetID(I) );
  Finally
    EndUpdate;
  End;
End;

Procedure TStrings.Assign(AStrings: TStrings);
Begin
  If AStrings=Self Then Exit;
  BeginUpdate;
  Try
    Clear;
    If AStrings<>Nil Then AddStrings(AStrings);
  Finally
    EndUpdate;
  End;
End;

Procedure TStrings.BeginUpdate;
Begin
  If FUpdateSemaphore = 0 Then SetUpdateState(True);
  Inc(FUpdateSemaphore);
End;

Procedure TStrings.EndUpdate;
Begin
  Dec(FUpdateSemaphore);
  If FUpdateSemaphore = 0 Then SetUpdateState(False);
End;

Function TStrings.Equals(AStrings: TStrings): Boolean;
Var
  N: LongInt;
Begin
  Result := False;
  If Count <> AStrings.Count Then Exit;
  For N := 0 To Count - 1 Do If Get(N) <> AStrings.Get(N) Then Exit;
  Result := True;
End;

Procedure TStrings.Exchange(Index1, Index2: LongInt);
Var
  S: String;
  O: TObject;
  I: LongInt;
Begin
  S := Get(Index1);
  O := GetObject(Index1);
  I := GetID(Index1);
  Put(Index1, Get(Index2));
  PutObject(Index1, GetObject(Index2));
  PutiD(Index1, GetID(Index2));
  Put(Index2, S);
  PutObject(Index2, O);
  PutID(Index2, I);
End;

Function TStrings.GetName(Index: LongInt): String;
Var
  P: Integer;
Begin
  Result := Get(Index);
  P := Pos('=', Result);
  System.Delete(Result, P, Length(Result) - P + 1);
End;

Procedure SingleLineToBuffer(Const S: String; Var P: PChar);
Begin
  Move(S[1], P[0], Length(S));
  Inc(P, Length(S));
  P[0] := #13;
  P[1] := #10;
  Inc(P, 2);
End;

Function TStrings.GetText: PChar;
Var
  N, BufSize: LongInt;
  BufPtr: PChar;
Begin
  BufSize := 1;
  For N := 0 To Count - 1 Do Inc(BufSize, Length(Get(N)) + 2);
  Result := StrAlloc(BufSize);

  BufPtr := Result;
  For N := 0 To Count - 1 Do SingleLineToBuffer(Get(N), BufPtr);
  BufPtr[0] := #0;
End;

Function TStrings.GetTextStr: AnsiString;
Var
  N, BufSize: LongInt;
  BufPtr: PChar;
Begin
  BufSize := 0;
  For N := 0 To Count - 1 Do Inc(BufSize, Length(Get(N)) + 2);
  SetLength(Result, BufSize);
  BufPtr := PChar(Result);
  For N := 0 To Count - 1 Do SingleLineToBuffer(Get(N), BufPtr);
End;

Function TStrings.GetValue(Const Name: String): String;
Begin
  FindValue(Name, Result);
End;

Function TStrings.FindValue(Const Name: String; Var Value: String): LongInt;
Var
  P: Integer;
Begin
  For Result := 0 To Count - 1 Do
  Begin
    Value := Get(Result);
    P := Pos('=', Value);
    If P <> 0 Then
    Begin
      If CompareText(Copy(Value, 1, P - 1), Name) = 0 Then
      Begin
        System.Delete(Value, 1, P);
        Exit;
      End;
    End;
  End;
  Result := -1;
  Value := '';
End;

Function TStrings.IndexOfName(Const Name: String): LongInt;
Var
  P: Integer;
  S: String;
Begin
  For Result := 0 To Count - 1 Do
  Begin
    S := Get(Result);
    P := Pos('=', S);
    If CompareText(Copy(S, 1, P - 1), Name) = 0 Then Exit;
  End;
  Result := -1;
End;

Function TStrings.IndexOf(Const S: String): LongInt;
Begin
  For Result := 0 To Count-1 Do
    If CompareText(Get(Result), S) = 0 Then Exit;
  Result := -1;
End;

Function TStrings.IndexOfObject(AObject: TObject): LongInt;
Begin
  For Result := 0 To Count-1 Do
    If GetObject(Result) = AObject Then Exit;
  Result := -1;
End;

Function TStrings.IndexOfID(ID: LongInt): LongInt;
Begin
  For Result := 0 To Count-1 Do
    If GetID(Result) = ID Then Exit;
  Result := -1;
End;


Procedure TStrings.InsertObject(Index: LongInt; Const S: String; AObject: TObject);
Begin
  Insert(Index, S);
  PutObject(Index, AObject);
End;

Procedure TStrings.InsertID(Index: LongInt; Const S: String; ID:LongInt);
Begin
  Insert(Index, S);
  PutID(Index, ID);
End;

Procedure TStrings.LoadFromFile(Const FileName: String);
Var
  Source: TFileStream;
Begin
  Try
    Source := TFileStream.Create(FileName, Stream_OpenRead);
  Except
    Source.Destroy;
    Raise;
  End;

  Try
    LoadFromStream(Source);
  Finally
    Source.Destroy;
  End;
End;

Procedure TStrings.LoadFromStream(Stream: TStream);
Begin
  BeginUpdate;
  Clear;
  Try
    While Not Stream.EndOfData Do Add(Stream.ReadLn);
  Finally
    EndUpdate;
  End;
End;

Procedure TStrings.Move(CurIndex, NewIndex: LongInt);
Var O: TObject;
    S: String;
    I: LongInt;
Begin
  If CurIndex = NewIndex Then Exit;
  S := Get(CurIndex);
  O := GetObject(CurIndex);
  I := GetID(CurIndex);
  FPreventFree := True;
  Delete(CurIndex);
  InsertObject(NewIndex, S, O);
  PutID(NewIndex, I);
  FPreventFree := False;
End;

Procedure TStrings.SaveToFile(Const FileName: String);
Var
  Dest: TFileStream;
Begin
  Try
    Dest := TFileStream.Create(FileName, Stream_Create);
  Except
    Dest.Destroy;
    Raise;
  End;

  Try
    SaveToStream(Dest);
  Finally
    Dest.Destroy;
  End;
End;

Procedure TStrings.SaveToStream(Stream: TStream);
Var
  N: LongInt;
Begin
  For N := 0 To Count - 1 Do Stream.WriteLn(Get(N));
End;

Procedure TStrings.SetText(Text: PChar);

  Function SingleLineFromBuffer(Var P: PChar): String;
  Var
    I: Integer;
    Q: PChar;
  Begin
    I := 0;
    Q := P;
    While Not (Q[0] In [#13, #10, #26, #0]) And (I < 255) Do
    Begin
      Inc(Q);
      Inc(I);
    End;
    StrMove(@Result[1], P, I);
    SetLength(Result, I);
    P := Q;
    If P[0] = #13 Then Inc(P);
    If P[0] = #10 Then Inc(P);
  End;

Begin
  BeginUpdate;
  Try
    Clear;
    If Text<>Nil Then While Not (Text[0] In [#0, #26]) Do
    Begin
      Add(SingleLineFromBuffer(Text));
    End;
  Finally
    EndUpdate;
  End;
End;

Procedure TStrings.SetTextStr(Const Value: AnsiString);
Begin
  SetText(PChar(Value));
End;

{$HINTS OFF}
Procedure TStrings.SetUpdateState(Updating: Boolean);
Begin
End;
{$HINTS ON}

Procedure TStrings.SetValue(Const Name, Value: String);
Var
  I: LongInt;
  S: String;
Begin
  I := FindValue(Name, S);
  If I < 0 Then
  Begin
    If Length(Value) <> 0 Then Add(Name + '=' + Value)
  End
  Else
  Begin
    If Length(Value) <> 0 Then Put(I, Name + '=' + Value)
    Else Delete(I);
  End;
End;

Function TStrings.GetMaxLength : Integer;

Var C : LongInt;
    L : Integer;

Begin
  Result:=0;
  For C := 0 To Count - 1 Do
    Begin
      L := Length(Get(C));
      if L > Result then
        Result:=L;
    End;
End;

Function TStrings.GetMinLength : Integer;

Var C : LongInt;
    L : Integer;

Begin
  Result:=256;
  For C := 0 To Count - 1 Do
    Begin
      L := Length(Get(C));
      if L < Result then
        Result := L;
    End;
End;


{ --- TStringList --- }

Constructor TStringList.Create;
Begin
  Inherited Create;
  FList := TList.Create;
  FCaseSensitive := False;
End;

Destructor TStringList.Destroy;
Begin
  { Die folgenden zwei Zeilen spter wieder ndern }
  Pointer(FOnChanging) := Nil;
  Pointer(FOnChange) := Nil;
  Clear;
  FList.Destroy;
  FList := Nil;
  Inherited Destroy;
End;

Function TStringList.Add(Const S: String): LongInt;
Begin
  If FSorted Then
  Begin
    If Find(S, Result) Then
    Begin
      Case FDuplicates Of
        dupIgnore: Exit;
        dupError: Raise EStringListError.Create(LoadNLSStr(SStringListDupeErrorText));
      End;
    End;
  End
  Else Result := Count;
  Changing;
  FList.Insert(Result, NewStrItem(S, Nil));
  changed;
End;

     
Procedure TStringList.AddSplit(Const iText: String; Const iTrenn: Char);

Var Cou  : Byte;
    PosTr: Byte;

Begin
  if iText='' then exit;
  PosTr:=0;
  for Cou:=1 to length(iText) do
    if iText[Cou]=iTrenn then
      Begin
        add(Trim(Copy(iText,Postr+1, Cou-Postr-1)));
        PosTr:=Cou;
      End;
  add(trim(Copy(iText,PosTr+1, length(iText)-PosTr)));
End;

Procedure TStringList.AnsiAddSplit(Const iText: AnsiString; Const iTrenn: Char);

Var Cou  : LongInt;
    PosTr: LongInt; 
    S    : String;
    
Begin
  if iText='' then exit;
  PosTr:=0;
  for Cou:=1 to Length(iText) do
    if iText[Cou]=iTrenn then
      Begin
        s:=AnsiCopy(iText,Postr+1, Cou-Postr-1);
        add(Trim(s));
        PosTr:=Cou;
      End;
  s:=AnsiCopy(iText,PosTr+1, length(iText)-PosTr);
  add(trim(s));
End;      


Procedure TStringList.changed;
Begin
  If (FUpdateSemaphore = 0) And (FOnChange <> Nil) Then FOnChange(Self);
End;

Procedure TStringList.Changing;
Begin
  If (FUpdateSemaphore = 0) And (FOnChanging <> Nil) Then FOnChanging(Self);
End;

Procedure TStringList.Clear;
Var
  N: LongInt;
Begin
  If Count > 0 Then
  Begin
    Changing;
    FLockChange:=True;
    For N := Count - 1 DownTo 0 Do
      Delete(N);
    FLockChange:=False;
    changed;
  End;
End;

Procedure TStringList.Delete(Index: LongInt);
Begin
  If FLockChange Then
  Begin
       FreeItem(GetObject(Index));
{       DisposeStrItem(FList.Get(Index)); }
       DisposeStrItem(FList.Items[Index]);
       FList.Delete(Index);
  End
  Else
  Begin
       Changing;
       If Not FPreventFree Then FreeItem(GetObject(Index));
{       DisposeStrItem(FList.Get(Index));   }
       DisposeStrItem(FList.Items[Index]);
       FList.Delete(Index);
       changed;
  End;
End;

Procedure TStringList.FreeItem(AObject:TObject);
Begin
  If FOnFreeItem <> Nil Then FOnFreeItem(Self,AObject);
End;

Procedure TStringList.Exchange(Index1, Index2: LongInt);
Begin
  Changing;
  FList.Exchange(Index1, Index2);
  changed;
End;

Function TStringList.Find(Const S: String; Var Index: LongInt): Boolean;
Var
  Low, High: LongInt;
  CMP: Integer;
  DoCompare: Function(Const S, T: String): Integer;

Begin
  If CaseSensitive Then DoCompare := CompareStr
  Else DoCompare := CompareText;

  If sorted Then
  Begin
    { binary Search }
    Low := 0;
    High := GetCount - 1;
    Index := 0;
    CMP := -1;
    While (CMP <> 0) And (Low <= High) Do
    Begin
      Index := (Low + High) Div 2;
      CMP := DoCompare(S, Get(Index));
      If CMP < 0 Then High := Index -1
      Else If CMP > 0 Then Low := Index + 1;
    End;
    If Low = Index + 1 Then Inc(Index);
    Result := (CMP = 0);
  End
  Else
  Begin
    { Linear Search }
    Index := 0;
    While (Index < Count) And (DoCompare(Get(Index), S) <> 0) Do Inc(Index);
    Result := (Index < Count);
  End;
End;

Function TStringList.Get(Index: LongInt): String;
Begin
{  Result := PStrItem(FList.Get(Index))^.FString; }
  Result := PStrItem(FList.Items[Index])^.FString;
End;

Function TStringList.GetCount: LongInt;
Begin
  Result := FList.Count;
End;

Function TStringList.GetObject(Index: LongInt): TObject;
Begin
{  Result := PStrItem(FList.Get(Index))^.FObject; }
  Result := PStrItem(FList.Items[Index])^.FObject;
End;

Function TStringList.GetID(Index: LongInt): LongInt;
Begin
  Result := PStrItem(FList.Items[Index])^.FID;
End;

Function TStringList.GetStrItem(Index: LongInt) : tStrItem;

Begin
  Result := PStrItem(FList.Items[Index])^;
End;

Function TStringList.IndexOf(Const S: String): LongInt;
Begin
  If Not Find(S, Result) Then Result := -1;
End;

Procedure TStringList.Insert(Index: LongInt; Const S: String);
Begin
  Changing;
  If FSorted Then Raise EListError.Create(LoadNLSStr(SStringListInsertErrorText))
  Else FList.Insert(Index, NewStrItem(S, Nil));
  changed;
End;

Procedure TStringList.Put(Index: LongInt; Const S: String);
Var  TempObj:TObject;
     pstr:PStrItem;
Begin
  Changing;
{  pstr := FList.Get(Index); }
  pstr := FList.Items[Index];
  TempObj := pstr^.FObject;
  DisposeStrItem(pstr);
{  FList.Put(Index, NewStrItem(S, TempObj)); }
  FList.Items[Index]:=NewStrItem(S, TempObj);
  changed;
End;

Procedure TStringList.PutObject(Index: LongInt; AObject: TObject);
Var
  P: PStrItem;
Begin
{  P := FList.Get(Index); }
  P := FList.Items[Index];
  P^.FObject := AObject;
End;

Procedure TStringList.PutID(Index: LongInt; ID : LongInt);
Var
  P: PStrItem;
Begin
  P := FList.Items[Index];
  P^.FID := ID;
End;

Procedure TStringList.BottomUpHeapSort;
Var
  DoCompare: Function (Const S, T: String): Integer;

  Procedure Reheap(I, K: LongInt);
  Var
    J: LongInt;
  Begin
    J := I;
    While J Shl 1 < K Do
    Begin
      If DoCompare(Get(J Shl 1 - 1), Get(J Shl 1 + 1 - 1)) > 0 Then J := J Shl 1
      Else J := J Shl 1 + 1;
    End;
    If J Shl 1 = K Then J := K;

    While DoCompare(Get(I - 1), Get(J - 1)) > 0 Do J := J Shr 1;

    FList.Exchange(I - 1, J - 1);
    J := J Shr 1;

    While J >= I Do
    Begin
      FList.Exchange(I - 1, J - 1);
      J := J Shr 1;
    End;
  End;

Var
  I, C: LongInt;
Begin
  If CaseSensitive Then DoCompare := CompareStr
  Else DoCompare := CompareText;

  C := Count;
  For I := C Shr 1 DownTo 1 Do Reheap(I, C);
  For I := C DownTo 2 Do
  Begin
    FList.Exchange(0, I - 1);
    Reheap(1, I - 1);
  End;
End;

Procedure TStringList.SetCaseSensitive(Value: Boolean);
Var
  old: Boolean;
Begin
  Changing;
  old := FCaseSensitive;
  FCaseSensitive := Value;
  If FSorted And (FCaseSensitive <> old) Then Sort;
  changed;
End;

Procedure TStringList.SetSorted(Value: Boolean);
Begin
  Changing;
  If (Not FSorted) And Value Then Sort;
  FSorted := Value;
  changed;
End;

Procedure TStringList.SetUpdateState(Updating: Boolean);
Begin
  If Updating Then Changing
  Else changed;
End;

Procedure TStringList.Sort;
Begin
  If Count > 1 Then
  Begin
    Changing;
    BottomUpHeapSort;
    changed;
  End;
End;

Function TStringList.Compare(iStringList : tStringList) : Boolean;

Var Cou, Index : LongInt;

Begin
  Result := false;
  if getCount <> iStringList.Count
    then exit;
  For cou :=0 to getCount-1 do
    if iStringList.Find(Get(cou), Index) = false then
      exit;
  Result:=true;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ This section: TAnsiStringList                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TAnsiStringList.Add(Const S: AnsiString): LongInt;
Begin
  If FSorted Then
  Begin
    If Find(S, Result) Then
    Begin
      Case FDuplicates Of
        dupIgnore: Exit;
        dupError: Raise EStringListError.Create(LoadNLSStr(SStringListDupeErrorText));
      End;
    End;
  End
  Else Result := Count;
  Changing;
  FList.Insert(Result, NewAnsiStrItem(S, Nil));
  changed;
End;

Function TAnsiStringList.AddObject(Const S: AnsiString; AObject: TObject): LongInt;

Begin
  Result := Add(S);
  PutObject(Result, AObject);
  PutID(Result, 0);
End;

Function TAnsiStringList.AddObjectID(Const S: AnsiString; AObject: TObject; ID : LongInt): LongInt;

Begin
  Result := Add(S);
  PutObject(Result, AObject);
  PutID(Result, ID);
End;

Procedure TAnsiStringList.AddStrings(AStrings: TStrings);

Var I: LongInt;

Begin
  if AStrings=nil then exit;
  BeginUpdate;
  Try
    For I := 0 To AStrings.Count - 1 Do
      AddObjectID(AStrings.Get(I), AStrings.GetObject(I), AStrings.GetID(I) );
  Finally
    EndUpdate;
  End;
End;

Procedure TAnsiStringList.AnsiAddSplit(Const iText: AnsiString; Const iTrenn: Char);

Var Cou  : LongInt;
    PosTr: LongInt; 
    S    : AnsiString;
    
Begin
  if iText='' then exit;
  PosTr:=0;
  for Cou:=1 to Length(iText) do
    if iText[Cou]=iTrenn then
      Begin
        s:=AnsiCopy(iText,Postr+1, Cou-Postr-1);
        add(Trim(s));
        PosTr:=Cou;
      End;
  s:=AnsiCopy(iText,PosTr+1, length(iText)-PosTr);
  add(trim(s));
End;      

Procedure TAnsiStringList.Append(Const S: AnsiString);
Begin
  Add(S);
End;

Procedure TAnsiStringList.BottomUpHeapSort;
Var
  DoCompare: Function (Const S, T: String): Integer;

  Procedure Reheap(I, K: LongInt);
  Var J: LongInt;
  Begin
    J := I;
    While J Shl 1 < K Do
      Begin
        If DoCompare(Get(J Shl 1 - 1), Get(J Shl 1 + 1 - 1)) > 0
          Then J := J Shl 1
          Else J := J Shl 1 + 1;
      End;
    If J Shl 1 = K Then J := K;

    While DoCompare(Get(I - 1), Get(J - 1)) > 0 
      Do J := J Shr 1;

    FList.Exchange(I - 1, J - 1);
    J := J Shr 1;

    While J >= I Do
      Begin
        FList.Exchange(I - 1, J - 1);
        J := J Shr 1;
      End;
  End;

Var I, C: LongInt;
Begin
{$IFDEF Win32}
  If CaseSensitive
    Then DoCompare := AnsiCompareStr
    Else DoCompare := AnsiCompareText;
{$ENDIF}
{$IFDEF OS2}
  DoCompare := AnsiCompareText;
{$ENDIF}

  C := Count;
  For I := C Shr 1 DownTo 1 Do 
    Reheap(I, C);
  For I := C DownTo 2 Do
    Begin
      FList.Exchange(0, I - 1);
      Reheap(1, I - 1);
    End;
End;


Function TAnsiStringList.Equals(AStrings: TStrings): Boolean;

Var N: LongInt;

Begin
  Result := False;
  If Count <> AStrings.Count Then Exit;
    For N := 0 To Count - 1 Do 
      If Get(N) <> AStrings.Get(N) Then Exit;
  Result := True;
End;


Function TAnsiStringList.Find(Const S: AnsiString; Var Index: LongInt): Boolean;
Var
  Low, High: LongInt;
  CMP: Integer;
  DoCompare: Function(Const S, T: String): Integer;

Begin
{$IFDEF Win32}
  If CaseSensitive
    Then DoCompare := AnsiCompareStr
    Else DoCompare := AnsiCompareText;
{$ENDIF}
{$IFDEF OS2}
  DoCompare := AnsiCompareText;
{$ENDIF}

  If sorted Then
    Begin
      { binary Search }
      Low := 0;
      High := GetCount - 1;
      Index := 0;
      CMP := -1;
      While (CMP <> 0) And (Low <= High) Do
        Begin
          Index := (Low + High) Div 2;
          CMP := DoCompare(S, Get(Index));
          If CMP < 0 
            Then High := Index -1
            Else If CMP > 0 
              Then Low := Index + 1;
        End;
      If Low = Index + 1 Then Inc(Index);
      Result := (CMP = 0);
    End
  Else
    Begin
      { Linear Search }
      Index := 0;
      While (Index < Count) And (DoCompare(Get(Index), S) <> 0) Do 
        Inc(Index);
      Result := (Index < Count);
  End;
End;

Function TAnsiStringList.Get(Index: LongInt): AnsiString;

Begin
// Writeln('get');
  Result := PAnsiStrItem(FList.Items[Index])^.FString;
End;

Function TAnsiStringList.GetStrItem(Index: LongInt) : tAnsiStrItem;

Begin
  Result := PAnsiStrItem(FList.Items[Index])^;
End;

Function TAnsiStringList.IndexOf(Const S: AnsiString): LongInt;

Begin
  For Result := 0 To Count-1 Do
    If AnsiCompareText(Get(Result), S) = 0 Then Exit;
  Result := -1;
End;  

Function TAnsiStringList.IndexOfName(Const Name: AnsiString): LongInt;

Var P: Integer;
    S: AnsiString;
Begin
  For Result := 0 To Count - 1 Do
    Begin
      S := Get(Result);
      P := Pos('=', S);
      If AnsiCompareText(Copy(S, 1, P - 1), Name) = 0 Then Exit;
    End;
  Result := -1;
End;

Procedure TAnsiStringList.Insert(Index: LongInt; Const S: AnsiString); 

Begin
  Changing;
  If FSorted 
    Then Raise EListError.Create(LoadNLSStr(SStringListInsertErrorText))
    Else FList.Insert(Index, NewAnsiStrItem(S, Nil));
  changed;
End;

Procedure TAnsiStringList.InsertObject(Index: LongInt; Const S: AnsiString; AObject: TObject);
Begin
  Insert(Index, S);
  PutObject(Index, AObject);
End;

Procedure TAnsiStringList.InsertID(Index: LongInt; Const S: AnsiString; ID:LongInt);
Begin
  Insert(Index, S);
  PutID(Index, ID);
End;

Procedure TAnsiStringList.LoadFromStream(Stream: TStream);
Begin
  BeginUpdate;
  Clear;
  Try
    While Not Stream.EndOfData Do 
      Add(Stream.AnsiReadLn);
  Finally
    EndUpdate;
  End;
End;

Procedure TAnsiStringList.Put(Index: LongInt; Const S: AnsiString);

Var  TempObj:TObject;
     pstr:PAnsiStrItem;
     
Begin
  Changing;
  pstr := FList.Items[Index];
  TempObj := pstr^.FObject;
  DisposeAnsiStrItem(pstr);
  FList.Items[Index]:=NewAnsiStrItem(S, TempObj);
  changed;
End;

Procedure TAnsiStringList.SaveToStream(Stream: TStream); 

Var N: LongInt;

Begin
  For N := 0 To Count - 1 Do 
    Stream.AnsiWriteLn(Get(N));
End;

Procedure TAnsiStringList.SetSorted(Value: Boolean);
Begin
  Changing;
  If (Not FSorted) And Value Then Sort;
  FSorted := Value;
  changed;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ This section: TStringValue                                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TStringValue.Create(iText : String);

Begin
  inherited Create;
  Add(iText);
End;

Procedure TStringValue.Add(iText : String);

Begin
  fText:=iText;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ This section: TAnsiStringValue                                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TAnsiStringValue.Create(iText : AnsiString);

Begin
  inherited Create;
  Add(iText);
End;

Procedure TAnsiStringValue.Add(iText : AnsiString);

Begin
  fText:=iText;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ This section: TDirList                                                    บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function tDirList.FindFile(iFileName : tFileName) : tFileName;
// Search the File in the List.

var Cou : LongInt;
    Gef : tFileName;

Begin 
  Result:='';
  iFileName:=ExtractFileName(iFileName);
  For Cou:=0 to Count-1 do
    Begin
      Gef:=Strings[Cou]+iFileName;
      if FileExists(Gef) then 
        Begin
          Result:=Gef;
          break;  // For-Schleife verlassen
        End;  
    End; 
End;

Function tDirList.Add(Const iDir: tFileName): LongInt;

Var p : tFileName;

Begin
  p:=ExpandFileName(DeleteLastPathSeparator(iDir));
  if p=''
    then Raise EFileNotFound.Create(iDir)
    else if Find(p, Result)=false Then    // Keine doppelte Eintraege
           Result:=inherited Add(AddPathSeparator(p));
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Diverese Rexx-Aehnliche-Funktionen und Prozeduren                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function rx_word(Str : String; WrdNum : LongWord) : String;

var po,cou : LongWord;
    ch     : Char;

Begin
//  rx_subword(str,WrdNum,1);

  result:='';
  if wrdnum=1
    then po:=0
    else
      Begin
        po:=PosN(' ',str,WrdNum);
        if po=0 then exit;
      End;
  for cou:=po+1 to length(str) do
    Begin
      ch:=str[cou];
      if ch=' ' then break;
      result:=result+ch;
    End;
End;

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  01-Jan-03  WD         Von RTL ins SPCC-Projekt uebernommen.
  13-May-03  WD         Die Strings-Objekte in diese Unit uebertragen.
  04-Jun-03  WD         Einbau von Compare in tStringList.
  14-Sep-03  WD         Funktion "iif" eingebaut.
  08-Feb-04  WD         Funktion "SplitAll" eingebaut.
  11-Aug-04  WD         In tStrings und tStringList die Funktionen GetID, PutID und InsertID eingebaut
  14-Jan-05  WD         In tStrings TabSeperator und StringsTab eingebaut.
  15-Jul-05  WD         Die Schnittstelle von "SplitAll" geaendert.
  24-Feb-06  WD         Einbau der Funktion LastPos.
  04-Mar-06  WD         Klasse tStringValue eingebaut.
  16-Sep-06  WD         Funktion Split: Den Separator von Typ Char auf String geaendert
  17-Oct-06  RG         Funktion ExtractStrings: eingebaut
  26-Mar-07  WD         Klasse: tDirList eingebaut
  27-Jul-07  WD         Funktion TStrings.GetMaxLength und TString.GetMinLength eingebaut.
  23-Nov-07  WD         Typ tStr9 eingebau.
  09-Dez-07  WD         Funktion rx_word eingebaut und PosItem auf PosN umbenannt-
  01-Jan-08  WD         Typ tStr1 eingebaut.
  13-Feb-08  WD         TStringList: Variable FList und Funktion BottomUpHeapSort von Private auf Protected
  16-Feb-08  WD         Die Klassen TAnsiStringList, TAnsiStringValue erstellt.
  10-Apr-08  WD         Typ: pAnsiStringValue und pStringValue
  09-Okt-08  WD         Funktion AnsiTrimLeft, AnsiTrimRight und AnsiTrim eingebaut.
}
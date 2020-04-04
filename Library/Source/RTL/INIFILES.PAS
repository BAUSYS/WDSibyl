
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit IniFiles;

Interface

{ TIniFile: Standard (binres) OS/2 Inifile
  TAsciiIniFile: Text-Inifile, lesbar, mit Editor zu bearbeiten.

  Beide benutzen exakt das gleiche Interface und sind bis
  auf Die neue Methode 'Erase' kompatibel zu den normalen
  Delphi-IniFiles. }

Uses SysUtils, uString, uStream;

{$IFDEF OS2}
Uses PMSHL;      { OS/2 profile functions }
{$ENDIF}
{$IFDEF Win32}
Uses WinBase;
{$ENDIF}

Const gRegStandard = '[STANDARD]';

Type EIniFileError = Class(Exception);

Type
  TBaseIniFile = Class(TObject) {Martin0208 formerly "tIniFile", now tBaseIniFile}
  Private
    FFileName: PString;         // Physical Name Of File
    {$IFDEF OS2}
    FHandle: HINI;              // profile Handle
    {$ENDIF}
    Function GetFileName: String;

  Protected
    Procedure Error(Const Msg: String); Virtual;

  Public
    Constructor Create(Const FileName: String);Virtual;
    Destructor Destroy; Override;

    Procedure Erase(Const section, Ident: String); Virtual;
    Procedure EraseSection(Const section: String); Virtual;

    Function GetDataSize(Const section, Ident: String; Var Len : LongWord) : Boolean; Virtual;

    Function ReadData(Const section, Ident: String; Var pBuffer; Var Len : LongWord) : Boolean; Virtual;
    Function ReadString(Const Section, Ident, Default: String): String; Virtual;
    Function ReadChar(Const iSection, iIdent : String; iDefault: Char): Char; Virtual;
    Function ReadInteger(Const section, Ident: String; Default: LongInt): LongInt; Virtual;
    Function ReadLongWord(Const section, Ident: String; Default: LongWord): LongWord; Virtual;
    Function ReadBool(Const section, Ident: String; Default: Boolean): Boolean; Virtual;
    Procedure ReadSection(Const section: String; AStrings: TStrings); Virtual;
   {Procedure ReadSections(AStrings: TStrings); fehlt noch}
    Procedure ReadSectionValues(Const section: String; AStrings: TStrings); Virtual;
    Procedure ReadStrings(Const section, Ident: String; AStrings : tStrings);
    Function ReadMemoryStream(Const section, Ident: String; Stream : tMemoryStream) : Boolean; Virtual;

    Procedure WriteData(Const section, Ident: String; Var pBuffer; Len : LongWord); Virtual;
    Procedure WriteString(Const section, Ident, Value: String); Virtual;
    Procedure WriteStringRaw(Const section, Ident, Value: String);
    Procedure WriteInteger(Const section, Ident: String; Value: LongInt); Virtual;
    Procedure WriteLongWord(Const section, Ident: String; Value: LongWord); Virtual;
    Procedure WriteBool(Const section, Ident: String; Value: Boolean); Virtual;
    Procedure WriteStrings(Const section, Ident: String; AStrings : tStrings);
    Procedure WriteMemoryStream(Const section, Ident: String; Stream : tMemoryStream); Virtual;

    Property FileName: String Read GetFileName;
  End;

{Martin0208}
{
This class enables you writing one single code for
 - read
 - write
 - compare the file state with the current state
   This makes it possible to query the changes of a settings notebook and to ask
   "Do you want to save the changes?" if changes have been made

Simply set IniMode and rwSection before using the rw... procedures.
It is no more necessary to write separate code for reading and writing data.

You can mix old ReadXXX/WRiteXXX with new rwXXX procedures.

Code example:

  procedure rwMyprogSettings;
    begin
      with Application.ProgramInifile do begin
        rwSection := 'myprog';
        rwBool (Mybool1, 'Mybool1', true); //true=default value
        rwLongInt (MyLongInt1, 'MyLongInt1', 17); //17=default value
        //and so on
      end;
    end;

  In e.g. SetupComponent:

    Application.ProgramInifile.Inimode := imRead;
    rwMyprogSettings;

  in e.g. Close:

    Application.ProgramInifile.Inimode := imWrite;
    Application.ProgramInifile.rwWriteDefaults := true/false;
    rwMyprogSettings;

  compare the current variable values with the state in the ini file:

    Application.ProgramInifile.Inimode := imCompare;
    rwMyprogSettings;

  Now the Application.ProgramInifile.HasChanged property contains this information.

}

  tIniMode = (imRead, imWrite, imCompare);
  TIniFile = Class(TBaseIniFile)
  private
    fIniMode : tIniMode;
    fHasChanged : boolean;
    frwWriteDefaults : boolean;
    frwSection : string;

    procedure SetIniMode (NewValue : tIniMode);
  public
    Constructor Create(Const FileName: String);override;
    procedure rwString(var Value : string; Const Ident, Default: String); Virtual;
    procedure rwChar(var Value : char; Const Ident : String; Default: Char); Virtual;
    procedure rwLongInt (var Value : longint; Const Ident: String; Default: LongInt); Virtual;
    procedure rwLongWord(var Value : longword; Const Ident: String; Default: LongWord); Virtual;
    procedure rwBool(var Value : boolean; Const Ident: String; Default: Boolean); Virtual;
    Procedure rwStrings(AStrings : tStrings; Const Ident: String; Default : tStrings); Virtual;
    {additional types}
    procedure rwInteger (var Value : integer; Const Ident: String; Default: integer); Virtual;
    procedure rwWord (var Value : word; Const Ident: String; Default: word); Virtual;
    procedure rwByte (var Value : byte; Const Ident: String; Default: byte); Virtual;
    procedure rwDouble (var Value : double; Const Ident: String; Default: double); Virtual;

    {properties}
    property IniMode : tIniMode          read fIniMode write SetIniMode;
    property HasChanged : boolean     read fHasChanged;
    property rwSection : String           Read frwSection Write frwSection;
    property rwWriteDefaults : Boolean Read frwWriteDefaults Write frwWriteDefaults;

  end;

Type
  {$HINTS OFF}
  TAsciiIniFile = Class(TIniFile)
  Private
    //FFileName: PString;         // Physical Name Of File
    FSections: TStringList;     // List Of Sections And their Names
    FName: PString;             // Name Of Last used section
    FList: TStringList;         // List Of Last used section
    FChanged: Boolean;          // has the Data been changed?
    fSectionSort : Boolean;
    fIdentSort   : Boolean;
    fCodepage : TCodepage;

    Procedure WriteToSection(Const section: String);
    Function ReadFromSection(Const section: String): Boolean;
    //Function GetFileName: String;

  Protected
    TrueString  : String[7];
    FalseString : String[7];
    Procedure InitIniFile;Virtual;

  Public
    Constructor Create (Const FileName : String); override;
    Constructor CreateCP(Const FileName: String; iCodepage : tCodepage{Martin0308});Virtual;
    procedure Create_intern (Const FileName: String; iCodepage : tCodepage{Martin0308});Virtual;
    Destructor Destroy; Override;
    Procedure Erase(Const section, Ident: String); Override;
    Procedure EraseSection(Const section: String); Override;
    Function ReadData(Const section, Ident: String; Var pBuffer; Var Len : LongWord) : Boolean; Override;
    Function ReadString(Const section, Ident, Default: String): String; Override;
    Function ReadInteger(Const section, Ident: String; Default: LongInt): LongInt; Override;
    Function ReadLongWord(Const section, Ident: String; Default: LongWord): LongWord; Override;
    Function ReadBool(Const section, Ident: String; Default: Boolean): Boolean; Override;
    Procedure ReadSection(Const section: String; AStrings: TStrings); Override;
    Procedure ReadSections(AStrings: TStrings);
    Procedure ReadSectionValues(Const section: String; AStrings: TStrings); Override;
    Procedure Refresh;
    Procedure WriteString(Const section, Ident, Value: String); Override;
    Procedure WriteInteger(Const section, Ident: String; Value: LongInt); Override;
    Procedure WriteBool(Const section, Ident: String; Value: Boolean); Override;

    Property FileName   : String Read GetFileName;
    Property changed    : Boolean Read FChanged Write FChanged;
    Property SectionSort: Boolean Read fSectionSort Write fSectionSort;
    Property IdentSort  : Boolean Read fIdentSort Write fIdentSort;
    property Codepage : tCodepage Read fCodepage;

  End;
  {$HINTS ON}


type taRegTyp = (taeKEY_CLASSES_ROOT, taeKEY_CURRENT_USER, taeKEY_LOCAL_MACHINE,
                 taeKEY_USERS);

type
  tcRegistry = Class(TIniFile)
    Private
      fKeyStr : String;
      fRegTyp : taRegTyp;
      fHKey   : LongWord;

      Function ChkStandard(Ident : String) : cString;

    Public
      Constructor Create(Const iRegTyp : taRegTyp; Const iKeyStr: String);Virtual;
      Destructor Destroy; Override;
      Procedure Erase(Const section, Ident: String); Override;
      Function CreateSection(Const section: String) : tcRegistry;
      Procedure EraseSection(Const section: String); Override;
      Function ReadData(Const section, Ident: String; Var pBuffer; Var Len : LongWord) : Boolean; Override;
      Function ReadString(Const Section, Ident, Default: String): String; Override;
      Function ReadInteger(Const section, Ident: String; Default: LongInt): LongInt; Override;
      Function ReadLongWord(Const section, Ident: String; Default: LongWord): LongWord; Override;
      Function ReadBool(Const section, Ident: String; Default: Boolean): Boolean; Override;
      Procedure ReadSection(Const section: String; AStrings: TStrings); Override;
     {Procedure ReadSections(AStrings: TStrings); fehlt noch}
      Procedure ReadSectionValues(Const section: String; AStrings: TStrings); Override;
      Procedure ReadStrings(Const section, Ident: String; AStrings : tStrings);
      Procedure WriteString(Const section, Ident, Value: String); Override;
      Procedure WriteInteger(Const section, Ident: String; Value: LongInt); Override;
      Procedure WriteBool(Const section, Ident: String; Value: Boolean); Override;
      Procedure WriteStrings(Const section, Ident: String; AStrings : tStrings);

      Property FileName : String   Read fKeyStr;  { Kompatible zu tIniFile }
      Property KeyStr   : String   Read fKeyStr;
      Property Regtyp   : taRegTyp Read fRegTyp;
      Property hKey     : LongWord Read fHKey;
  End;

Implementation

{$IFDEF OS2}
Uses BseRegistry;
{$ENDIF}
{$IFDEF Win32}
Uses WinADVAPI;
{$ENDIF}

Uses uSysInfo;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: TIniSection Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
  {$HINTS OFF}
  TIniSection = Class(TStringList)
    Private
        Function GetValue(Const Name: String): String;
        Procedure SetValue(Const Name, Value: String);
        Function FindValue(Const Name: String; Var Value: String): LongInt;
        Procedure FreeItem(AObject:TObject);Override;
        Property values[Const Name: String]: String Read GetValue Write SetValue;
  End;
  {$HINTS ON}

Procedure TIniSection.FreeItem(AObject:TObject);
Var
  P: PString;
Begin
  P := PString(AObject);
  DisposeStr(P);
  Inherited FreeItem(AObject);
End;

Function TIniSection.GetValue(Const Name: String): String;
Var
  I: LongInt;
Begin
  If Find(Name, I) Then Result := PString(Objects[I])^
  Else Result := '';
End;

Function TIniSection.FindValue(Const Name: String; Var Value: String): LongInt;
Begin
  If Find(Name, Result) Then Value := PString(Objects[Result])^
  Else
  Begin
    Value := '';
    Result := -1;
  End;
End;

Procedure TIniSection.SetValue(Const Name, Value: String);
Var
  I: LongInt;
  P: PString;
  OldSorted: Boolean;
Begin
  If Find(Name, I) Then
  Begin
    P := PString(Objects[I]);
    DisposeStr(P);
    PutObject(I, TObject(NewStr(Value)));
  End
  Else
  Begin
    OldSorted := sorted;
    sorted := False;
    InsertObject(I, Name, TObject(NewStr(Value)));
    sorted := OldSorted;
  End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: tcRegistry Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function tcRegistry.ChkStandard(Ident : String) : cString;

Begin
  if UpperCase(Ident)=gRegStandard
    then Result:=''
    else Result:=Ident;
End;

Procedure tcRegistry.Erase(Const section, Ident: String);

Var cIdent : cString;

Begin
  if fhKey=0 then exit;
  cIdent:=Ident;
  RegDeleteValue(fhKey, cIdent);
End;

Function tcRegistry.CreateSection(Const section: String) : tcRegistry;

Var cSection : cString;
    cClass   : cString;
    RegResult: LongWord;
    rv       : LongWord;

Begin
  Result:=nil;
  if fhKey=0 then exit;
  cSection:=Section;
  cClass  :='REG_SZ';
  if RegCreateKeyEx(fhKey, cSection, 0, cClass, 0, KEY_ALL_ACCESS, NIL,
                    RegResult, 0) = 0 then
    Result.Create(fRegTyp,KeyStr+'\'+Section);
End;

Procedure tcRegistry.EraseSection(Const section: String);

  Procedure DelKey(S1: string);

  var cSection: cString;

  begin
    Fillchar(cSection,255,#0);
    cSection:=S1;
    RegDeleteKey(fhKey, cSection);   // Beeinflusst die Variablen
  End;

Var S       : String;
    p       : Byte;

Begin
  if fhKey=0 then exit;

// WinXP schafft es nicht mehrere Verzeichnisse gleichzeitig zu loeschen.
  S:=Section;
  delkey(s);
  p:=LastPos('\',S);
  while p<>0 do
    Begin
      S[0]:=chr(ord(p-1));
      p:=LastPos('\',s);
      delkey(s);
    end;
End;

Function tcRegistry.ReadData(Const section, Ident: String; Var pBuffer; Var Len : LongWord) : Boolean;

Begin
  Len:=0;
  Result:=false;
End;

Function tcRegistry.ReadString(Const Section, Ident, Default: String): String;

Var cIdent : cString;
    cValue : cString;
    len    : LongWord;

Begin
  if fhKey=0 then exit;
  cIdent:=ChkStandard(Ident);
  Len:=255;
  if RegQueryValueEx(fhkey, cIdent, 0, 0, cValue, Len) <> 0
    then Result:=Default
    else Result:=cValue;
End;

Function tcRegistry.ReadInteger(Const section, Ident: String; Default: LongInt): LongInt;

Begin
  Result:=StrToInt(ReadString(Section, Ident, tostr(Default)));
End;

Function tcRegistry.ReadLongWord(Const section, Ident: String; Default: LongWord): LongWord;

Begin
  Result:=0;
End;

Function tcRegistry.ReadBool(Const section, Ident: String; Default: Boolean): Boolean;

Begin
End;

Procedure tcRegistry.ReadSection(Const section: String; AStrings: TStrings);

var cou     : LongInt;
    cName   : cString;
    LenName : LongWord;
    cClass  : cString;
    LenClass: LongWord;
    LastWriteTime: PFILETIME;
    Reserved,
    SubKeys, MaxSubKeyLen, MaxClassLen,
    Values, MaxValueNameLen, MaxValueLen,
    SecurityDescriptor : LongWord;

Begin
  if fhKey=0 then exit;
  AStrings.Clear;
  if RegQueryInfoKey(fhKey, cClass, LenClass,
          Reserved, SubKeys, MaxSubKeyLen, MaxClassLen,
          Values, MaxValueNameLen, MaxValueLen,
          SecurityDescriptor,
          LastWriteTime)<>0
    then exit;
//  if Values=0 then exit;
  for cou:=0 to Values-1 do
    Begin
      LenName :=255;
      LenClass:=255;
      RegEnumKeyEx(fhKey, cou, cName, LenName, $0, cClass, LenClass, LastWriteTime);
//      if RegEnumKeyEx(fhKey, cou, cName, LenName, $0, cClass, LenClass, LastWriteTime)<>0
//        then exit;
      AStrings.Add(cName);
    End;

//  if SubKeys=0 then exit;
  for cou:=0 to SubKeys-1 do
    Begin
      LenName :=255;
      LenClass:=255;
      RegEnumKeyEx(fhKey, cou, cName, LenName, $0, cClass, LenClass, LastWriteTime);
//      if RegEnumKeyEx(fhKey, cou, cName, LenName, $0, cClass, LenClass, LastWriteTime)<>0
//        then exit;
      AStrings.Add(cName);
    End;
End;

Procedure tcRegistry.ReadSectionValues(Const section: String; AStrings: TStrings);

Begin
End;

Procedure tcRegistry.ReadStrings(Const section, Ident: String; AStrings : tStrings);

Begin
End;

Procedure tcRegistry.WriteString(Const section, Ident, Value: String);

Var cIdent : cString;
    cValue : cString;
    len    : LongWord;

Begin
  if fhKey=0 then exit;
  cIdent:=ChkStandard(Ident);
  cValue:=Value;
  Len:=255;
  if RegSetValueEx(fhKey, cIdent, 0, REG_SZ, cValue, Length(Value))<>0 then
    Error(LoadNLSStr(SWriteError)+'.');
End;

Procedure tcRegistry.WriteInteger(Const section, Ident: String; Value: LongInt);

Begin
End;

Procedure tcRegistry.WriteBool(Const section, Ident: String; Value: Boolean);

Begin
End;

Procedure tcRegistry.WriteStrings(Const section, Ident: String; AStrings : tStrings);

Begin
End;       

Constructor tcRegistry.Create(Const iRegTyp : taRegTyp; Const iKeyStr: String);

var hKey   : LongWord;
    cKeyStr: cString;
    rv     : LongWord;

Begin
  if fKeyStr[1]='\'
    then fKeyStr:= copy(iKeyStr,2,255)
    else fKeyStr:= iKeyStr;
  fRegTyp := iRegTyp;

  case fRegTyp of
    taeKEY_CLASSES_ROOT : hkey := HKEY_CLASSES_ROOT;
    taeKEY_CURRENT_USER : hkey := HKEY_CURRENT_USER;
    taeKEY_LOCAL_MACHINE: hkey := HKEY_LOCAL_MACHINE;
    taeKEY_USERS        : hkey := HKEY_USERS;
  end;
  cKeyStr := fKeyStr;
  rv:=RegOpenKeyEx(hKey, cKeyStr, 0, KEY_ALL_ACCESS, fhkey);
  if rv <> 0 then
    Begin
      fHKey:=0;
      Error(LoadNLSStr(SCannotOpenIniFile)+'. RegOpenKeyEx='+toStr(rv));
    End;
End;

Destructor tcRegistry.Destroy;

Begin
  if fHKey<>0 then RegCloseKey(fhKey);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: TBaseIniFile Class Implementation (formerly tIniFile)       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TBaseIniFile.Create(Const FileName: String);
Begin
  {$IFDEF OS2}
  FHandle := PrfOpenProfile(AppHandle, FileName);
  If FHandle = NULLHANDLE Then Error(LoadNLSStr(SCannotOpenIniFile)+'.');
  {$ENDIF}
  FFileName := NewStr(FileName);
End;

Destructor TBaseIniFile.Destroy;

var f : File;
    fs: LongInt;
    fn: tFilename;

Begin
  {$IFDEF OS2}
  PrfCloseProfile(FHandle);
  {$ENDIF}

  fn:=Filename;
  if fn<>'' then
    Begin
      {$I-}
      System.Assign(f, fn);
      System.Reset(f);
      fs:=FileSize(f);
      System.Close(f);
      if fs=0 then // Die Datei ist leer --> Kann geloescht werden
        DeleteFile(fn);
      {$I+}
      DisposeStr(FFileName);
    End;
  Inherited Destroy;

End;

Procedure TBaseIniFile.Erase(Const section, Ident: String);
Begin
  {$IFDEF OS2}
  PrfWriteProfileString(FHandle, section, Ident, Nil);
  {$ENDIF}
  {$IFDEF Win32}
  WritePrivateProfileString(section,Ident,Nil,FileName);
  {$ENDIF}
End;

Procedure TBaseIniFile.EraseSection(Const section: String);
Begin
  {$IFDEF OS2}
  PrfWriteProfileString(FHandle, section, Nil, Nil);
  {$ENDIF}
  {$IFDEF Win32}
  WritePrivateProfileString(section,Nil,Nil,FileName);
  {$ENDIF}
End;

Procedure TBaseIniFile.Error(Const Msg: String);
Begin
  Raise EIniFileError.Create(Msg);
End;

Function TBaseIniFile.GetFileName: String;
Begin
  if FFileName=nil
    then Result:=''
    else Result := FFileName^;
End;

Function TBaseIniFile.GetDataSize(Const section, Ident: String; Var Len : LongWord) : Boolean;

Begin
  {$IFDEF OS2}
  Result:=PrfQueryProfileSize(FHandle, section, Ident, len);
  {$ENDIF}
  {$IFDEF Win32}
  Len:=0;
  Result:=false;
  {$ENDIF}
End;


Function TBaseIniFile.ReadData(Const section, Ident: String; Var pBuffer; Var Len : LongWord) : Boolean;

Begin
  {$IFDEF OS2}
  Result:=PrfQueryProfileData(FHandle, section, Ident, pBuffer, len);
  {$ENDIF}
  {$IFDEF Win32}
  Len:=0;
  Result:=false;
  {$ENDIF}
End;

Function TBaseIniFile.ReadString(Const section, Ident, Default: String): String;

{$IFDEF OS2}
Var OutBuf: cstring;
{$ENDIF}

Begin
  {$IFDEF OS2}
  Fillchar(OutBuf, 255, 0); {sometimes the #0 character is not copied (cdp.ini)}
  PrfQueryProfileString(FHandle, Section, Ident, Default, OutBuf, 255);
  Result := OutBuf;
  {$ENDIF}
  {$IFDEF Win32}
  SetLength(Result,GetPrivateProfileString(
    Section,Ident,Default,cstring(Result[1]),255,FileName));
  {$ENDIF}
End;

Function TBaseIniFile.ReadChar(Const iSection, iIdent : String; iDefault: Char): Char;

var Ret : String;

Begin
  Ret:=ReadString(iSection, iIdent, iDefault);
  Result:=Ret[1];
End;


/*
  const
    StartLogCounter : longint = 0;
procedure StartLog (St : string);
  var
    dat : text;
  begin
    assign (dat, 'START.LOG');
    if StartLogCounter = 0 then rewrite (dat) else append (dat);
    inc (StartLogCounter);
    writeln (dat, St);
    close (dat);
  end;
*/

Function TBaseIniFile.ReadInteger(Const section, Ident: String; Default: LongInt): LongInt;
Begin
  {$IFDEF OS2}
  Result := PrfQueryProfileInt(FHandle, section, Ident, Default);
  {$ENDIF}
  {$IFDEF Win32}
  Result := GetPrivateProfileInt(section,Ident,Default,FileName);
  {$ENDIF}
End;

Function TBaseIniFile.ReadLongWord(Const section, Ident: String; Default: LongWord): LongWord;

Var Len : LongWord;

Begin
  if (ReadData(Section, Ident, Result, Len)=false) or
     (len<>SizeOf(Longword)) then
    Result:=Default;
End;


Function TBaseIniFile.ReadBool(Const section, Ident: String; Default: Boolean): Boolean;
Var
  L: LongInt;
Begin
  If Default Then L := 1 Else L := 0;
  {$IFDEF OS2}
  Result := (PrfQueryProfileInt(FHandle, section, Ident, L) <> 0);
  {$ENDIF}
  {$IFDEF Win32}
  Result := (GetPrivateProfileInt(section,Ident,L,FileName) <> 0);
  {$ENDIF}
End;

Procedure TBaseIniFile.ReadSection(Const section: String; AStrings: TStrings);
Var
  Size, RealSize: LongWord;
  Buffer, Pos: PChar;
  S: String;
Begin
  {$IFDEF OS2}
  If Not PrfQueryProfileSize(FHandle, section, Nil, Size) Then Exit;
  If Size=0 Then exit;
  {$ENDIF}
  {$IFDEF Win32}
  //??????????????????????????????????????????????????????????
  Size:=8192;
  {$ENDIF}
  GetMem(Buffer, Size);
  Try
    {$IFDEF OS2}
    PrfQueryProfileString(FHandle, section, Nil, Nil, Buffer^, Size);
    Buffer[Size - 1] := #0;
    {$ENDIF}
    {$IFDEF Win32}
    Buffer[GetPrivateProfileString(section,Nil,Nil,Buffer^,Size,FileName)-1] := #0;
    {$ENDIF}
    Pos := Buffer;
    While Pos[0] <> #0 Do
    Begin
      S := StrPas(Pos);
      Inc(Pos, Length(S) + 1);
      Dec(RealSize, Length(S) + 1);
      AStrings.Add(S);
    End;
  Finally
    FreeMem(Buffer, Size);
  End;
End;

Procedure TBaseIniFile.ReadSectionValues(Const section: String; AStrings: TStrings);
Var
  Temp: TIniSection;
  I: LongInt;
Begin
  Temp := TIniSection.Create;
  Temp.sorted := True;
  Temp.Duplicates := dupIgnore;
  Try
    ReadSection(section, Temp);
    For I := 0 To Temp.Count - 1 Do
      AStrings.values[Temp.Strings[I]]:=ReadString(section, Temp.Strings[I], '');
  Finally
    Temp.Destroy;
  End;
End;

Procedure TBaseIniFile.ReadStrings(Const section, Ident: String; AStrings : tStrings);

Var Anz   : LongInt;
    Cou   : LongInt;
    Size  : LongWord;
    Pos   : PChar;
    Buffer: PChar;
    item  : String;

Begin
  AStrings.Clear;
  Anz:=ReadInteger(section, Ident+'_Anz', -1);
  if Anz = -1
    then    // Einlesen der Listen in User-INI-Format.
      Begin
{$IFDEF OS2}
        if PrfQueryProfileSize(FHandle,section,Ident,Size) then
          begin
            Buffer := AllocMem(Size+1); // inkl. mit Nullen auffuellen
            if PrfQueryProfileData(FHandle,section,Ident,Buffer^,Size) then
              begin
                Pos := Buffer;
                while Pos[0] <> #0 do
                  begin
                    item := StrPas(Pos);
                    Inc(Pos, Length(item) + 1);
                    AStrings.Add(item);
                  end;
              end;
            FreeMem(Buffer,Size+1);
          end;
{$ENDIF}
      End
    else    // Einlesen des String-Tabelle
      for Cou:=0 to Anz-1 do
        AStrings.Add(ReadString(section, Ident+ '_' + tostr(Cou), ''));
End;

Function TBaseIniFile.ReadMemoryStream(Const section, Ident: String; Stream : tMemoryStream) : Boolean;

Var ms1, ms2: LongWord;
    mm : PByteArray;
    po : LongInt;

Begin
  Result:=false;
  if GetDataSize(Section, Ident, ms1) = false then exit;
  GetMem(mm, ms1);
  if (ReadData(Section, Ident, mm^, ms2)) and (ms1=ms2) then
    Begin
      Stream.Write(mm^, ms1);
      Result:=true;
    End;
  freeMem(mm, ms1);
End;

Procedure TBaseIniFile.WriteData(Const section, Ident : String; Var pBuffer; Len : LongWord);

Begin
  {$IFDEF OS2}
  PrfWriteProfileData(FHandle, section, Ident, pBuffer, Len);
  {$ENDIF}
  {$IFDEF Win32}
  {$ENDIF}
End;

Procedure TBaseIniFile.WriteString(Const section, Ident, Value: String);
Var
  CSection, CIdent, CValue: cstring[256];
Begin
  CSection := section;
  CIdent := Ident;
  CValue := Value;
  {$IFDEF OS2}
  If Not PrfWriteProfileString(FHandle, CSection, CIdent, CValue) Then
    Error(LoadNLSStr(SWriteError)+'.');
  {$ENDIF}
  {$IFDEF Win32}
  If Not WritePrivateProfileString(CSection,CIdent,CValue,FileName) Then
    Error(LoadNLSStr(SWriteError)+'.');
  {$ENDIF}
End;

Procedure TBaseIniFile.WriteStringRaw(Const section, Ident, Value: String);
Var
  CSection, CIdent, CValue: cstring[256];
  ValueArr: Array[1..256] of Char;
  i: Integer;
Begin
  CSection := section;
  CIdent := Ident;
  {$IFDEF OS2}
  for i:=1 to length(Value) do
    ValueArr[i] := Value[i];
  If Not PrfWriteProfileData(FHandle, CSection, CIdent, ValueArr, length(Value)) Then
    Error(LoadNLSStr(SWriteError)+'.');
  {$ENDIF}
  {$IFDEF Win32}
  CValue := Value;
  If Not WritePrivateProfileString(CSection,CIdent,CValue,FileName) Then
    Error(LoadNLSStr(SWriteError)+'.');
  {$ENDIF}
End;



Procedure TBaseIniFile.WriteInteger(Const section, Ident: String; Value: LongInt);
Begin
  WriteString(section, Ident, IntToStr(Value));
End;

Procedure TBaseIniFile.WriteLongWord(Const section, Ident: String; Value: LongWord);

Begin
  WriteData(Section, Ident, Value, SizeOf(LongWord));
End;

Procedure TBaseIniFile.WriteBool(Const section, Ident: String; Value: Boolean);
Var
  C: Char;
Begin
  If Value Then C := '1' Else C := '0';
  WriteString(section, Ident, C);
End;

Procedure TBaseIniFile.WriteStrings(Const section, Ident: String; AStrings : tStrings);

var Cou : LongInt;

Begin
  //EraseSection(section); {Martin0208: ist quatsch!!!! Sonst funktioniert tAsciiIniFile nicht}
  WriteInteger(section, Ident+'_Anz', AStrings.Count);
  for cou:=0 to AStrings.Count-1 do
    WriteString(section, Ident+ '_' + tostr(Cou), AStrings.Strings[Cou])
End;

Procedure TBaseIniFile.WriteMemoryStream(Const section, Ident: String; Stream : tMemoryStream);

Var Mm : PByteArray;

Begin
  mm:=Stream.Memory;
  WriteData(Section, Ident, mm^, Stream.Size);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: TIniFile Class Implementation  (Martin0208),                บ
บ                                                                           บ
บ TIniFile is an ancestor old tBaseIniFile completely new written           บ
บ The old tIniFile object has been renamed to tBaseIniFile !!!              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TIniFile.Create(Const FileName: String);
  begin
    inherited Create (FileName);
    IniMode := imRead; frwWriteDefaults := true; frwSection := 'Main';
    fHasChanged := false;
  end;

procedure TIniFile.SetIniMode (NewValue : tIniMode);
  begin
    fIniMode := NewValue;
    if NewValue = imCompare then fHasChanged := false;
  end;

procedure TIniFile.rwString(var Value : string; Const Ident, Default: String);
  var
    OldValue : string;
  begin
    if fIniMode = imCompare then begin
      OldValue := ReadString (frwSection, Ident, Default);
      if OldValue <> Value then fHasChanged := true;
      //if OldValue <> Value then StartLog (Ident +' has changed');
    end
    else if IniMode = imRead then
      Value := ReadString (frwSection, Ident, Default)
    else {IniMode = imWrite}if frwWriteDefaults or (Value <> Default) then
      WriteString (frwSection, Ident, Value)
    else
      Erase (frwSection, Ident);
  end;

procedure TIniFile.rwChar(var Value : char; Const Ident : String; Default: Char);
  var
    OldValue : char;
  begin
    if fIniMode = imCompare then begin
      OldValue := ReadChar (frwSection, Ident, Default);
      if OldValue <> Value then fHasChanged := true;
      //if OldValue <> Value then StartLog (Ident +' has changed');
    end
    else if IniMode = imRead then
      Value := ReadChar (frwSection, Ident, Default)
    else if frwWriteDefaults or (Value <> Default) then
      WriteString (frwSection, Ident, Value)
    else
      Erase (frwSection, Ident);
  end;

procedure TIniFile.rwLongInt (var Value : longint; Const Ident: String; Default: LongInt);
  var
    OldValue : longint;
  begin
    if fIniMode = imCompare then begin
      OldValue := ReadInteger{=longint}(frwSection, Ident, Default);
      if OldValue <> Value then fHasChanged := true;
      //if OldValue <> Value then StartLog (Ident +' has changed');
    end
    else if IniMode = imRead then
      Value := ReadInteger{=longint} (frwSection, Ident, Default)
    else if frwWriteDefaults or (Value <> Default) then
      WriteInteger{=longint} (frwSection, Ident, Value)
    else
      Erase (frwSection, Ident);
  end;

procedure TIniFile.rwLongWord(var Value : longword; Const Ident: String; Default: LongWord);
  var
    OldValue : longword;
  begin
    if fIniMode = imCompare then begin
      OldValue := ReadLongWord (frwSection, Ident, Default);
      if OldValue <> Value then fHasChanged := true;
      //if OldValue <> Value then StartLog (Ident +' has changed');
    end
    else if IniMode = imRead then
      Value := ReadLongWord (frwSection, Ident, Default)
    else if frwWriteDefaults or (Value <> Default) then
      WriteLongWord (frwSection, Ident, Value)
    else
      Erase (frwSection, Ident);
  end;

procedure TIniFile.rwBool(var Value : boolean; Const Ident: String; Default: Boolean);
  var
    OldValue : boolean;
  begin
    if fIniMode = imCompare then begin
      OldValue := ReadBool (frwSection, Ident, Default);
      if OldValue <> Value then fHasChanged := true;
      //if OldValue <> Value then StartLog (Ident +' has changed');
    end
    else if IniMode = imRead then
      Value := ReadBool (frwSection, Ident, Default)
    else if frwWriteDefaults or (Value <> Default) then
      WriteBool (frwSection, Ident, Value)
    else
      Erase (frwSection, Ident);
  end;

{additional types}
procedure TIniFile.rwInteger (var Value : integer; Const Ident: String; Default: integer);
  var
    OldValue : integer;
  begin
    if fIniMode = imCompare then begin
      OldValue := ReadInteger{=longint}(frwSection, Ident, Default);
      if OldValue <> Value then fHasChanged := true;
      //if OldValue <> Value then StartLog (Ident +' has changed');
    end else if IniMode = imRead then
      Value := ReadInteger{=longint} (frwSection, Ident, Default)
    else if frwWriteDefaults or (Value <> Default) then
      WriteInteger{=longint} (frwSection, Ident, Value)
    else
      Erase (frwSection, Ident);
  end;

procedure TIniFile.rwWord (var Value : word; Const Ident: String; Default: word);
  var
    OldValue : word;
  begin
    if fIniMode = imCompare then begin
      OldValue := ReadInteger{=longint}(frwSection, Ident, Default);
      if OldValue <> Value then fHasChanged := true;
      //if OldValue <> Value then StartLog (Ident +' has changed');
    end
    else if IniMode = imRead then
      Value := ReadInteger{=longint} (frwSection, Ident, Default)
    else if frwWriteDefaults or (Value <> Default) then
      WriteInteger{=longint} (frwSection, Ident, Value)
    else
      Erase (frwSection, Ident);
  end;

procedure TIniFile.rwByte (var Value : byte; Const Ident: String; Default: byte);
  var
    OldValue : byte;
  begin
    if fIniMode = imCompare then begin
      OldValue := ReadInteger{=longint}(frwSection, Ident, Default);
      if OldValue <> Value then fHasChanged := true;
      //if OldValue <> Value then StartLog (Ident +' has changed');
    end
    else if IniMode = imRead then
      Value := ReadInteger{=longint} (frwSection, Ident, Default)
    else if frwWriteDefaults or (Value <> Default) then
      WriteInteger{=longint} (frwSection, Ident, Value)
    else
      Erase (frwSection, Ident);
  end;

procedure TIniFile.rwDouble (var Value : double; Const Ident: String; Default: double);
  var
    Svalue, Sdefault : string;
  begin
    Svalue := floattostr(Value); Sdefault := floattostr(Default);
    rwString (Svalue, Ident, sDefault);
    Value := strtofloat(Svalue); 
  end;

  function DifferentStrings (s1, s2 : tStrings) : boolean;
    var
      I : longint;
      s1count, s2count : longint;
    begin
      if s1 = nil then s1count := 0 else s1count := s1.count;
      if s2 = nil then s2count := 0 else s2count := s2.count;
      if s1count <> s2count then result := true
      else begin
        result := false;
        for I := 0 to s1.Count-1 do begin
          if s1.Strings[I] <> s2.Strings[I] then begin
            result := true; break;
          end;
        end;
      end;
    end;

{Stringlist has to be created before using rwStrings !!!}
Procedure TIniFile.rwStrings(AStrings : tStrings; Const Ident: String; Default : tStrings);
   {default = nil: no effect when reading, always write when writing}
  var
    I : longint;
    OldValue : tStringList;
  begin
    if fIniMode = imCompare then begin
      if not fHasChanged then begin
        OldValue.Create;
        ReadStrings (frwSection, Ident, OldValue);
        if DifferentStrings (OldValue, AStrings) then fHasChanged := true;
        if DifferentStrings (OldValue, AStrings) then begin
          //StartLog (Ident +' has changed:');
          //for I := 0 to OldValue.Count-1 do StartLog ('OldValue:'+OldValue.Strings[I]);
          //for I := 0 to AStrings.Count-1 do StartLog ('NewValue:'+AStrings.Strings[I]);
        end;
        OldValue.Destroy;
      end;
    end
    else if IniMode = imRead then begin
      ReadStrings (frwSection, Ident, AStrings);
      if (AStrings = nil) and (Default <> nil) then begin
        {copy Default to AStrings}
        AStrings.Create;
        for I := 0 to Default.Count-1 do AStrings.Add (Default.Strings[I]);
      end;
    end
    else if frwWriteDefaults or DifferentStrings (AStrings, Default) then
      WriteStrings (frwSection, Ident, AStrings)
    else
      Erase (frwSection, Ident);
  end;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: TIniAsciiFile Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

constructor tAsciiIniFile.Create (Const FileName : String);
  begin
    Create_Intern (FileName, tcpIBM);
  end;

constructor tAsciiIniFile.CreateCP (Const FileName : String; iCodepage : tCodepage);
  begin
    Create_Intern (FileName, iCodepage);
  end;

procedure TAsciiIniFile.Create_Intern(Const FileName: String; iCodepage : tCodepage);

  Function CutStr(Var S: String; C: Char): String;

  Var P: Integer;
  Begin
    P := Pos(C, S);
    If P = 0
      Then
        Begin
          Result := S;
          SetLength(S, 0);
        End
      Else
        Begin
          Result := Copy(S, 1, P - 1);
          System.Delete(S, 1, P);
        End;
  End;

Var
  Source: Text;
  S, T: String;
Begin
  fSectionSort := False;
  fIdentSort := False;

  fCodepage := iCodepage;{Martin0803}

  InitIniFile;

  FSections := TStringList.Create;
  FSections.Duplicates := dupIgnore;
  FSections.sorted := fSectionSort;
  TrueString := 'True';
  FalseString := 'False';

  FFileName := NewStr(FileName);
  FName := NullStr;

  If FFileName <> NullStr Then
  Begin
    Assign(Source, FileName);
    {$I-}
    Reset(Source);
    {$I+}
    If IOResult = 0 Then
    Begin
      While Not Eof(Source) Do
      Begin
        ReadLn(Source, S);
        If Length(S) <> 0 Then
        Begin
          if fCodepage = tcpAnsi then StrAnsiToOEM (S);
          If S[1] = '[' Then
          Begin
            { New section }
            System.Delete(S, 1, 1);
            WriteToSection(CutStr(S, ']'));
          End
          Else
          If Not (S[1] In [';', '#', '%']) Then
          Begin
            { New entry }
            If FList = Nil Then WriteToSection('');
            T := CutStr(S, '=');
            FList.AddObject(Trim(T), TObject(NewStr(Trim(S))));
          End;
        End;
      End;
      Close(Source);
    End
    Else
    Begin
      {$I-}
      Rewrite(Source);
      {$I+}
      If IOResult = 0 Then
      Begin
        Close(Source);
        {Delete the 0 Byte dummy}
        Assign(Source, FileName);
        {$I-}
        System.Erase(Source);
        {$I+}
      End
      Else Error(LoadNLSStr(SCannotOpenIniFile)+'.')
    End;
  End;
End;

{To Setup the Sort Value Of section And Ident}
Procedure TAsciiIniFile.InitIniFile;
Begin
End;

Destructor TAsciiIniFile.Destroy;
Var
  I: LongInt;
Begin
  Refresh;
  DisposeStr(FName);
  DisposeStr(FFileName);
  For I := 0 To FSections.Count - 1 Do
  Begin
    FList := TIniSection(FSections.Objects[I]);
    FList.Destroy;
  End;
  FSections.Destroy;
End;

Procedure TAsciiIniFile.Erase(Const section, Ident: String);
Var
  I: LongInt;
Begin
  If ReadFromSection(section) Then
  Begin
    If FList.Find(Ident, I) Then
    Begin
      FList.Delete(I);
      FChanged := True;
    End;
  End;
End;

Procedure TAsciiIniFile.EraseSection(Const section: String);
Var
  I: LongInt;
  S: TIniSection;
Begin
  If FSections.Find(section, I) Then
  Begin
    S := TIniSection(FSections.Objects[I]);
    S.Destroy;
    FSections.Delete(I);
    If S = FList Then
    Begin
      AssignStr(FName, '');
      FList := Nil;
    End;
    FChanged := True;
  End;
End;

Procedure TAsciiIniFile.WriteToSection(Const section: String);
Var
  I: LongInt;
Begin
  If CompareText(section, FName^) <> 0 Then
  Begin
    If FSections.Find(section, I) Then
    Begin
      AssignStr(FName, section);
      FList := TIniSection(FSections.Objects[I]);
    End
    Else
    Begin
      FList := TIniSection.Create;
      FList.Duplicates := dupAccept;
      FList.sorted := fIdentSort;
      FList.CaseSensitive := False;
      FSections.AddObject(section, FList);
      AssignStr(FName, section);
    End;
  End;
End;

Function TAsciiIniFile.ReadFromSection(Const section: String): Boolean;
Var
  I: LongInt;
Begin
  Result := True; {!}
  If CompareText(section, FName^) <> 0 Then
  Begin
    If FSections.Find(section, I) Then
    Begin
      AssignStr(FName, section);
      FList := TIniSection(FSections.Objects[I]);
    End
    Else Result := False; {!}
  End;
//  Result := (FList <> Nil);
  {liefert sonst Die Letzte zurck, wenn section unbekannt}
End;

Function TAsciiIniFile.ReadBool(Const section, Ident: String; Default: Boolean): Boolean;
Var
  S: String;
Begin
  If ReadFromSection(section) Then
  With TIniSection(FList) { As TIniSection} Do
  Begin
    If FindValue(Ident, S) = -1 Then Result := Default
    Else
    Begin
      If CompareText(S, TrueString) = 0 Then Result := True
      Else If CompareText(S, FalseString) = 0 Then Result := False
      Else Result := Default;
    End;
  End
  Else Result := Default;
End;

Function TAsciiIniFile.ReadData(Const section, Ident: String; Var pBuffer; Var Len : LongWord) : Boolean;

Begin
  Len:=0;
  Result:=false;
End;

Function TAsciiIniFile.ReadInteger(Const section, Ident: String; Default: LongInt): LongInt;
Var
  S: String;
Begin
  If ReadFromSection(section) Then
  With TIniSection(FList) { As TIniSection} Do
  Begin
    If FindValue(Ident, S) = -1 Then Result := Default
    Else Result := StrToIntDef(S, Default);
  End
  Else Result := Default;
End;

Function TAsciiIniFile.ReadLongWord(Const section, Ident: String; Default: LongWord): LongWord;

Begin
  Result:=0;
End;

Function TAsciiIniFile.ReadString(Const section, Ident, Default: String): String;
Begin
  If ReadFromSection(section) Then
  With TIniSection(FList) { As TIniSection} Do
  Begin
    If FindValue(Ident, Result) = -1 Then Result := Default;
  End
  Else Result := Default;
End;

Procedure TAsciiIniFile.ReadSection(Const section: String; AStrings: TStrings);
Var
  N: LongInt;
Begin
  If ReadFromSection(section) Then
  Begin
    For N := 0 To FList.Count - 1 Do AStrings.Add(FList.Strings[N]);
  End;
End;

Procedure TAsciiIniFile.ReadSections(AStrings: TStrings);
Var
  N: LongInt;
Begin
  For N := 0 To FSections.Count - 1 Do AStrings.Add(FSections.Strings[N]);
End;

Procedure TAsciiIniFile.ReadSectionValues(Const section: String; AStrings: TStrings);
Var
  N: LongInt;
Begin
  If ReadFromSection(section) Then
  Begin
    For N := 0 To FList.Count - 1 Do
      AStrings.Add(FList.Strings[N] + '=' + PString(FList.Objects[N])^);
  End;
End;

Procedure TAsciiIniFile.Refresh;
Var
  Dest: Text;
  N, I: LongInt;
  L: TIniSection;
  S: String;
Begin
  If FChanged And (FFileName <> NullStr) Then
  Begin
    Assign(Dest, FileName);
    Rewrite(Dest);
    For N := 0 To FSections.Count - 1 Do
    Begin
      S := FSections.Strings[N];
      if fCodepage = tcpAnsi then strOEMtoAnsi (S);
      If Length(S) <> 0 Then
      Begin
        WriteLn(Dest, '[' + S + ']');
        WriteLn(Dest);
      End;
      L := TIniSection(FSections.Objects[N]);
      For I := 0 To L.Count - 1 Do begin
        S := L.Strings[I]+ '='+ PString(L.Objects[I])^;
        if fCodepage = tcpAnsi then strOEMtoAnsi (S);
        WriteLn(Dest, S);
      end;
      If N < FSections.Count Then WriteLn(Dest);
      FChanged := False;
    End;
    Close(Dest);
  End;
End;

Procedure TAsciiIniFile.WriteBool(Const section, Ident: String; Value: Boolean);
Begin
  FChanged := True;
  WriteToSection(section);
  If Value Then TIniSection(FList).values[Ident]:=TrueString
  Else TIniSection(FList).values[Ident]:=FalseString;
End;

Procedure TAsciiIniFile.WriteInteger(Const section, Ident: String; Value: LongInt);
Begin
  FChanged := True;
  WriteToSection(section);
  TIniSection(FList).values[Ident]:=IntToStr(Value);
End;

Procedure TAsciiIniFile.WriteString(Const section, Ident, Value: String);
Begin
  FChanged := True;
  WriteToSection(section);
  TIniSection(FList).values[Ident]:=Value;
End;

End.

{ nderungen: 26.11.95  Sections werden sortiert, Eintrge aber nicht
              28.11.95  alles wird sortiert, schneller durch Trennung
                        von Ident und Value (TIniSection).
              30.11.95  Fehler In TIniSection korrigiert, ES
                        fehlten Get/Put
              16.12.95  neue Funktion GetDefaultINI()
              16-Aug-97   J”rg: Bugfix for TIniFile.ReadString.

  To-Do: - Eventuell ReadData / WriteData einbauen
         - Eventuell ReadSectionNames einbauen = ReadSections
         - wenn String -> cstring Fehler In SP/2 behoben,
           Workaround entfernen.

{ -- date -- -- from -- -- changes ----------------------------------------------
  27-Dez-02  WD         Ausbau der Funktion GetDefaultINI
  31-Dez-02  WD         Die Funktion "TRIMSTR" ausgebaut und stattdessen SYSUTILS.TRIM verwendet
  22-Okt-03  WD         Fuer Windos die Registry-Zugriffprogrammiert
  13-Feb-05  WD         Eine leere IniFile-Datei (also DateiLen=0) wird bei Destroy gel”scht.
  28-Feb-06  WD         tcRegistry; Div. Fehler korrigiert.
  09-Jul-06  WD         TIniFile: Korrekte verarbeitung wenn FFileName=nil ist
  17-Sep-06  TB         Neue Funktion TIniFile.WriteStringRaw (nur OS/2, Win32 identisch mit WriteString)
  19-Oct-06  RG         TIniFile.ReadStrings: Erweitert.
  27-Oct-06  WD         Methoden ReadData und ReadLongWord eingebaut.
  29-Feb-08  MV         tIniFile renamed to tBaseIniFile
                        new useful functionality in tIniFile. See tIniFile declaration
  17-Mar-08  MV         tAsciiIniFile.CreateCP: new parameter AnsiCodepage (false = IBM Codepage
                        which was the only behaviour before and is still the tAsciiIniFileCreate behaviour)
   7-May-08  MV         rwWriteDefaults = false malfunction fixed
}
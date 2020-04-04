
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


{*******************************************************}
{                                                       }
{ System Utilities Unit (Delphi compatible)             }
{                                                       }
{ (C) 1995-96 Joerg Pleumann                            }
{ (C) 1996    SpeedSoft                                 }
{                                                       }
{ Please mail All bugs And suggestions To:              }
{                                                       }
{ Internet: sa021pl @ uni-duisburg.de                   }
{ FidoNet:  Joerg Pleumann @ 2:2448/136.6               }
{                                                       }
{*******************************************************}

Unit SysUtils;

Interface

{ define Compiler symbol GUI To Include functions from
  OS/2 PM API. If you need A Version Of SysUtils that
  Uses only OS/2 base API functions (And therefore lacks
  Some features), comment This Line out And recompile the
  Unit. Change This To produce programs that Run without
  the OS/2 PM being Active (may also need changes In
  System Unit). Normally you shouldn't Change This. }

{$IFDEF OS2}
Uses Os2Def,BseDos, BseErr, PmWin, PMWP, PMSHL;
{$ENDIF OS2}

{$IFDEF Win32}
Uses WinNT,WinDef,WinBase,WinUser;
{$ENDIF Win32}

{ constants For SPCC Notification And Error Messages And Month / Day Names. }
{$I SPCC.Inc}
{$R Language}                          

Type
  { Pointer To floating Point Value. }
  PExtended = ^Extended;

  { Codepages }
  tCodepage = (tCPIBM, tCPANSI);

Type
  //Override Exception definition from System To allow formatted Create...
  Exception=Class(SysException)
     Public
         Constructor CreateFmt(Const Msg:String;Const Args:Array Of Const);
         Constructor CreateRes(Ident:Word);
         Constructor CreateResFmt(Ident:Word;Const Args:Array Of Const);
         Constructor CreateResNLS(Ident:Word);
         Constructor CreateResNLSFmt(Ident:Word;Const Args:Array Of Const);
         Constructor CreateHelp(Const Msg:String;AHelpContext:LongInt);
         Constructor CreateFmtHelp(Const Msg:String;Const Args:Array Of Const;AHelpContext:LongInt);
         Constructor CreateResHelp(Ident:Word;AHelpContext:LongInt);
         Constructor CreateResFmtHelp(Ident:Word;Const Args:Array Of Const;AHelpContext:LongInt);
         Constructor CreateResNLSHelp(Ident:Word;AHelpContext:LongInt);
         Constructor CreateResNLSFmtHelp(Ident:Word;Const Args:Array Of Const;AHelpContext:LongInt);
  End;

  ExceptClass = Class Of Exception;

  EConvertError = Class(Exception);

Const

{ File Open modes - A legal File Open Mode Is A logical combination
  Of an Open Mode And A sharing Mode. Please note that OS/2 Normally
  doesn't allow fmShareCompat, but For reasons Of compatibility the
  File functions automatically replace This constant by
  fmShareDenyNone. }

  {$IFDEF OS2}
  fmOpenRead       = $0000;
  fmOpenWrite      = $0001;
  fmOpenReadWrite  = $0002;
  fmShareCompat    = $0000;
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
  fmShareDenyRead  = $0030;
  fmShareDenyNone  = $0040;
  {$ENDIF}

  {$IFDEF Win32}
  fmOpenRead       = $80000000;
  fmOpenWrite      = $40000000;
  fmOpenReadWrite  = $C0000000;
  fmShareCompat    = $00000003;
  fmShareExclusive = $00000000;
  fmShareDenyWrite = $00000001;
  fmShareDenyRead  = $00000002;
  fmShareDenyNone  = $00000003;
  {$ENDIF}

{ Array With Number Of days passed since beginning Of the Year
  Until the 1st Of Every Month. used For date/Time conversions. }

  DaysPassed: Array[False..True, 1..13] Of Integer =
    ((0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365),
     (0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366));

{ File Record}
Type TFileRec=FileRec;

{ File attribute constants - Please note that there Is no constant
  faVolumeID, since OS/2 handles volume Ids In another way than Dos
  does. }
Const
  faReadOnly       = $0001;
  faHidden         = $0002;
  faSysFile        = $0004;
  faDirectory      = $0010;
  faArchive        = $0020;
  faNormal         = $0000; // Ursprnglich: $0080;

  {$IFDEF OS2}
  faAnyFile        = LongWord(faReadOnly Or faHidden Or faSysFile Or faDirectory Or faArchive);
  {$ENDIF}
  {$IFDEF Win32}
  faAnyFile        = LongWord(faReadOnly Or faHidden Or faSysFile Or faDirectory Or faArchive or faNormal);
  {$ENDIF}

{ 'Must' attribute constants - OS/2-specific File attribute constants
  For searching files. Use these constants In logical combination
  With the normal File Attributes when calling FindFirst() To restrict
  the Search results. }

  faMustReadOnly   = $0100;
  faMustHidden     = $0200;
  faMustSysFile    = $0400;
  faMustDirectory  = $1000;
  faMustArchive    = $2000;

Const

{ File Lock-TimeOut - This TimeOut Value Is used when performing File
  locking / unlocking operations. Value Is given In ms. }

  LockTimeout: LongInt = 5000;

Type

{ support For date And Time operations - both values are stored In
  one floating Point Value. the Integer part Contains the days passed
  since 31-Dec-0000, assuming that the Gregorian calendar has always
  been used. the fractional part Contains the part Of the Day since
  00:00:00. the Time part Is always equal To Or greater than Zero
  And smaller than one. }

  TDateTime = Extended;

Const
  SecsPerDay = 24 * 60 * 60;
  MSecsPerDay = SecsPerDay * 1000;

Type

{ Some Type conversion records. }

  WordRec = Record
    Lo, Hi: Byte;
  End;

  LongRec = Record
    Lo, Hi: Word;         
  End;

  TMethod = Record
    Code, Data: Pointer;
  End;

{ Some useful arrays. }

  PByteArray = ^TByteArray;
  TByteArray = Array[0..MaxLongInt] Of Byte;

  pCharArray = ^tCharArray;
  tCharArray = Array[0..MaxLongInt] Of Char;

  PWordArray = ^TWordArray;
  TWordArray = Array[0..MaxLongInt Div 2] Of Word;

  pLongWordArray = ^tLongWordArray;
  tLongWordArray = Array[0..MaxLongInt Div 4] Of LongWord;

  pPointerArray = ^tPointerArray;
  tPointerArray = Array[0..MaxLongInt Div 4] Of Pointer;

  ppCharArray = ^tpCharArray;
  tpCharArray = Array[0..MaxLongInt Div 4] Of PChar;

{ Generic Procedure Type. }

  TProcedure = Procedure;

{ File Search Record - This Is the Data structure internally used
  by the FindFirst, FindNext, And FindClose functions. }

  TSearchRec = Record
    {$IFDEF OS2}
    SearchRecIntern:FILEFINDBUF3;
    {Martin lf}
    SearchRecInternL:FILEFINDBUF3L;
    OS2longFileSupport : boolean;

    {$ENDIF}
    {$IFDEF Win32}
    InternalAttr:LongWord;
    SearchRecIntern:WIN32_FIND_DATA;
    {$ENDIF}
    HDir: LongWord;
    Attr: Byte;
    Time: LongInt;
    Size: LongInt;
    Floatsize : extended;
    Name: String;
  End;

{ FloatToText codes - these codes are used To specify the basic
  Output format Of the various functions that Convert floating
  Point values To Strings. }

  TFloatFormat = (ffGeneral, ffExponent, ffFixed, ffNumber, ffCurrency);

{ FloatToDecimal Result Record - This Record Is used To hold the return
  Value Of the FloatToDecimal Function. }

  TFloatRec = Record
    Exponent: Integer;
    Negative: Boolean;
    Digits: Array[0..18] Of Char;
  End;

Const

{ Empty String And Pointer To Empty String - used internally by various
  String functions. }

  EmptyStr: String[1] = '';
  NullStr: PString = @EmptyStr;


{ --- Language
{ **************************************************************************** }
type tLanguage = (tLngDefault, tLngGerman, tLngDutch, tLngItalien, tLngRussian);

const
  tLngLast = tLngRussian;
  LanguageRCName : array[tLngDefault..tLngLast] of string[20] =
      ('WDSIBYL_NLS_DEFAULT', 'WDSIBYL_NLS_GERMAN', 'WDSIBYL_NLS_DUTCH',
       'WDSIBYL_NLS_ITALIEN', 'WDSIBYL_NLS_RUSSIAN');

  LanguageShortName : array[tLngDefault..tLngLast] of string[2] =
     ('EN','DE','NL','IT','RU');

  LanguageName : array[tLngDefault..tLngLast] of string[20] =
      ('english', 'deutsch (german)',       // Format: Englische-Bezeichnung; in Klammer eventuell Landesbezeichnung
       'nederlands (dutch)',
       'italiens', 'russian');

Var CurrentLanguageTable : tLanguage;

{ SetCurrentLanguageTable - sets the Language Table Name To the specified Language.
  the Name MUST Start With "WDSIBYL_NLS_". A Table With the Name MUST exist. If the Table
  cannot be found Or Some other Error occurs This Function returns False, otherise True.
  by convention the Table MUST Include All Sibyl Default Language identifiers }

Function SetCurrentLanguageTable(Table:String):Boolean;

{ GetCurrentLanguageTable - gets the Current Language Table Name. }

Function GetCurrentLanguageTable:String;

{ GetCurrentLanguage - returns the Currently Set Language. the Language String Is
  retrieved from the Current Language Table With the "SLanguage" Index. This Function
  returns an Empty String ON Error. }

Function GetCurrentLanguage:String;

Function GetCurrentLanguageShort:String;

Var
{ --- date, Time, And currency defaults ---
{ ****************************************************************************

  the following global variables contain Default values For formatting
  date, Time, And currency values. most Of them are queried from the
  System At Program startup. Some others are taken from the
  application's resources. }

{ DateSeparator - the character used To separate Year, Month, And Day,
  when converting A TDateTime Value To Text. queried from the System
  At Program startup. }

  DateSeparator: Char;

{ ShortDateFormat - the Default format String used when converting a
  TDateTime Value To Text. This one Is used whenever A short Result
  Is desired. the Value Is computed At Program startup. }

  ShortDateFormat: String[15];

{ LongDateFormat - the Default format String used when converting a
  TDateTime Value To Text. This one Is used whenever A LONG Result
  Is desired. the Value Is computed At Program startup. }

  LongDateFormat: String[31];

{ ShortMonthNames - Abbreviations For Month Names used when converting
  A TDateTime Value To Text. the Names are taken from the program's
  resources. }

  ShortMonthNames: Array[1..12] Of String[7];

{ LongMonthNames - the full Month Names used when converting a
  TDateTime Value To Text. the Names are taken from the program's
  resources. }

  LongMonthNames: Array[1..12] Of String[15];

{ ShortDayNames - Abbreviations For Day Names used when converting
  A TDateTime Value To Text. the Names are taken from the program's
  resources. }

  ShortDayNames: Array[1..7] Of String[7];

{ LongDayNames - the full Day Names used when converting A TDateTime
  Value To Text. the Names are taken from the program's resources. }

  LongDayNames: Array[1..7] Of String[15];

{ DateOrder - the order Of Year, Month, And Day assumed when trying To
  extract date information from A String. queried from the System At
  Program startup. }

  DateOrder: Byte;

{ TimeSeparator - the character used To separate Hour, Minute, And
  Second, when converting A TDateTime Value To Text. queried from the
  System At Program startup. }

  TimeSeparator: Char;

{ TimeAMString - the String appended To Time values between 00:00 And
  11:59 when converting A DateTime Value To Text. only used when
  12-Hour clock format Is used. queried from the System At Program
  startup. }

  TimeAMString: String[7];

{ TimePMString - the String appended To Time values between 12:00 And
  23:59 when converting A DateTime Value To Text. only used when
  12-Hour clock format Is used. queried from the System At Program
  startup. }

  TimePMString: String[7];

{ ShortTimeFormat - the Default format String used when converting a
  TDateTime Value To Text. This one Is used whenever A shorter Result
  Is desired. queried from the System At Program startup. }

  ShortTimeFormat: String[15];

{ LongTimeFormat - the Default format String used when converting a
  TDateTime Value To Text. This one Is used whenever A longer Result
  Is desired. queried from the System At Program startup. }

  LongTimeFormat: String[31];

{ TwelveHours - Indicates whether 12-Hour clock format Is used when
  trying To extract Time information from A String. queried from
  the System At Program startup. }

  TwelveHours: Boolean;

{ CurrencyString - the local currency String used when converting
  currency values To Text. Default Value Is queried from the System
  At Program startup. }

  CurrencyString: String[7];

{ CurrencyFormat - the order Of currency Value, currency String, And
  separating space used when converting currency values To Text.
  Default Value Is queried from the System At Program startup.

  the following values four are possible, With the fifth one
  being an additional Value that Is only supported by OS/2:

    0 = '$1'       1 = '1$'       2 = '$ 1'      3 = '1 $'

    4 = currency String replaces DECIMAL indicator }

  CurrencyFormat: Byte;

{ NegCurrFormat - Corresponds To CurrencyFormat, but Is used when
  converting Negative currency values To Text. queried from the
  System At Program startup.

  the following values are possible:

    0 = '($1)'     1 = '-$1'      2 = '$-1'      3 = '$1-'
    4 = '(1$)'     5 = '-1$'      6 = '1-$'      7 = '1$-'
    8 = '-1 $'     9 = '-$ 1'    10 = '$ 1-'

  since OS/2 doesn't support A Special format For Negative currency
  values, A format Is chosen that matches the CurrencyFormat With
  A preceding '-'. the following List shows the possible values:

    CurrencyFormat           NegCurrFormat

      0 = '$1'                 1 = -$1
      1 = '1$'                 5 = -1$
      2 = '$ 1'                9 = -$ 1
      3 = '1 $'                8 = -1 $ }

  NegCurrFormat: Byte;

{ ThousandSeparator - the character used To separate blocks Of three
  Digits when converting floating Point values To Text. queried from
  the System At Program startup. }

 ThousandSeparator: Char;

 { DecimalSeparator - the character used To separate the Integer part
  from the fractional part when converting floating Point values To
  Text. queried from the System At Program startup. }

  DecimalSeparator: Char;

{ CurrencyDigits - the Number Of Digits used In the fractional part
  Of A currency Value when converting A currency Value To Text.
  queried from the System At Program startup. }

  CurrencyDecimals: Byte;

{ ListSeparator - the character To Use when separating Items In A List.
  Currently Not used by any Function. }

  ListSeparator: Char;

Const

{ TwoDigitYearCenturyWindow - Determines what century is added to two
  digit years when converting string dates to numeric dates. }

  TwoDigitYearCenturyWindow: Word = 0;

{ --- Fucntion --- }
{ **************************************************************************** }

{ minLW - Berechnet aus den beiden Werten den Minimum  }
Function minLW(iValue1, iValue2 : LongWord) : LongWord;

{ minLI - Berechnet aus den beiden Werten den Minimum  }
Function minLI(iValue1, iValue2 : LongInt) : LongInt;

{ maxLW - Berechnet aus den beiden Werten das Maximum  }
Function maxLW(iValue1, iValue2 : LongWord) : LongWord;

{ maxLI - Berechnet aus den beiden Werten das Maximum  }
Function maxLI(iValue1, iValue2 : LongInt) : LongInt;


{ --- System function --- }
{ **************************************************************************** }

{ ModuleLoaded - schaut nach ob das Module geladen ist oder nicht }
Function ModuleLoaded(iModuleName : String): Boolean;


{ --- Memory management --- }
{ **************************************************************************** }

{ AllocMem - Allocates A Memory block Of the desired Size ON the heap.
  In contrast To the GetMem Standard Procedure, AllocMem fills the
  whole block With zeroes. }

Function AllocMem(Size: Cardinal): Pointer;

{ ReAllocMem - re-Allocates A previously allocated Memory block And
  changes its Size. copies the contents Of the old block into the
  New one. CurSize And NewSize specify the Current And the New Size
  Of the block. If the New Size Is larger than the Current Size, the
  additional Bytes are zeroed. the old Memory block Is automatically
  disposed. note that the resulting Pointer will always be different
  from the old Pointer, even If the Size isn't changed. the Function
  can Handle Nil pointers And Zero blocks. }

Function ReAllocMem(P: Pointer; CurSize, NewSize: Cardinal): Pointer;

{ --- Exit Procedure Handling --- }
{ **************************************************************************** }

{ AddExitProc - Adds A parameterless Procedure To the List Of
  procedures To be called when the Program Is Terminated. note that
  the Procedure that Is added Last will be called First. }

Procedure AddExitProc(Proc: TProcedure);

{ CallExitProcs - calls All procedures that were installed by
  AddExitProc And deletes them from the List. note that the
  Procedure that was added Last will be called First. }

Procedure CallExitProcs;

{ --- String Handling --- }
{ **************************************************************************** }


{ NewStr - Allocates A block Of Memory ON the heap And fills it With
  the given String, returns A PString To the Memory block. the Memory
  block's Size will be exactly one Byte more than the string's Real
  Length. Empty Strings don't Use any heap space, the Function returns
  NullStr In This Case. since NullStr Points To EmptyStr, the Function
  never returns Nil, So you can always de-Reference the resulting
  Pointer. Use DisposeStr To Free the Memory block. }

Function NewStr(Const S: String): PString;

{ DisposeStr - Disposes A block Of Memory ON the heap that Contains
  A String. the block MUST have been allocated by A call To NewStr.
  If the given Pointer Is NullStr (And thereby references the Empty
  String) Or Nil, the Function does absolutely Nothing. }

Procedure DisposeStr(P: PString);

{ AssignStr - Assigns A New Value To A String Pointer that has been
  previously allocated by A call To NewStr, Or Is Nil. the old String
  Is disposed by DisposeStr, And the New one Is allocated by NewStr. }

Procedure AssignStr(Var P: PString; Const S: String);

{ AppendStr - Appends A String To the End Of another. }

Procedure AppendStr(Var Dest: String; Const S: String);

{ uppercase - Converts A String To upper Case by simply Changing All
  occurences Of 'a'..'z' To the corresponding upper Case characters.
  If you want A conversion that also considers international Special
  characters, Use AnsiUpperCase. }

Function UpperCase(Const S: String): String;

{ lowercase - Converts A String To lower Case by simply Changing All
  occurences Of 'A'..'Z' To the corresponding lower Case characters.
  If you want A conversion that also considers international Special
  characters, Use AnsiLowerCase. }

Function LowerCase(Const S: String): String;

{ CompareStr - Compares two Strings And returns an Integer Value
  As In the following Table:

    s1 < s2       Result < 0
    s1 = s2       Result = 0
    s1 > s2       Result > 0

  CompareStr Is Case-sensitive, but does Not take international
  Special characters Or the Currently Selected codepage into account. }

Function CompareStr(Const s1, s2: String): Integer;

{ CompareText - Compares two Strings And returns an Integer Value
  As In the following Table:

    s1 < s2       Result < 0
    s1 = s2       Result = 0
    s1 > s2       Result > 0

  CompareText Is Case-insensitive, And does Not take international
  Special characters Or the Currently Selected codepage into account. }

Function CompareText(Const s1, s2: String): Integer;

{ AnsiUpperCase - Converts A String To upper Case. This Function
  also takes international Special characters And the Currently
  Selected codepage into account. If you don't want This, Use
  uppercase. }

Function AnsiUpperCase(Const S: String): String;

{ AnsiLowerCase - Converts A String To lower Case. This Function
  also takes international Special characters And the Currently
  Selected codepage into account. If you don't want This, Use
  lowercase. note that AnsiLowerCase Is Not available under OS/2. }

{$IFNDEF OS2}
Function AnsiLowerCase(Const S: String): String;
{$ENDIF}

{ AnsiCompareStr - Compares two Strings And returns an Integer Value
  As In the following Table:

    s1 < s2       Result < 0
    s1 = s2       Result = 0
    s1 > s2       Result > 0

  AnsiCompareStr Is Case-sensitive, And takes international Special
  characters And the Currently Selected codepage into account. note
  that the Function Is Not available under OS/2. }

{$IFNDEF OS2}
Function AnsiCompareStr(Const s1, s2: String): Integer;
{$ENDIF}

{ AnsiCompareText - Compares two Strings And returns an Integer Value
  As In the following Table:

    s1 < s2       Result < 0
    s1 = s2       Result = 0
    s1 > s2       Result > 0

  AnsiCompareText Is Case-insensitive, And takes international Special
  characters And the Currently Selected codepage into account. }

Function AnsiCompareText(Const s1, s2: String): Integer;

{ Trim - Removes leading And trailing spaces And Control characters. }

Function Trim(Const S: String): String;

{ TrimLeft - Removes leading spaces And Control characters. }

Function TrimLeft(Const S: String): String;

{ TrimRight - Removes trailing spaces And Control characters. }

Function TrimRight(Const S: String): String;

{ QuotedStr - returns the given String enclosed In quotes. quotes already
  included In the String are returned As two quote characters. }

Function QuotedStr(Const S: String): String;

{ IsValidIdent - Checks whether the given String Contains A legal
  Pascal identifier. check your Speed-Pascal manual To See what A
  legal identifier looks like. :-) }

Function IsValidIdent(Const Ident: String): Boolean;

{ IntToStr - Converts an Integer Value To A String Of Digits. }

Function IntToStr(Value: LongInt): String;

{ IntToHex - Converts an Integer Value To A String Of hexadecimal
  Digits. the minimum desired Number Of Digits can be specified.
  If the Result Contains less Digits, it Is Left-padded With zeroes. }

Function IntToHex(Value: LongInt; Digits: Integer): String;

{ HexToInt - Convert a hexadecimal string to a Integer Value }

Function HexToInt(Const S: String): LongInt;

{ StrToInt - Extracts an Integer Value from A String. If the String
  doesn't contain A legal Integer Value, Exception EConvertError
  Is raised. }

Function StrToInt(Const S: String): LongInt;

{ StrToIntDef - Extracts an Integer Value from A String. If the String
  doesn't contain A legal Integer Value, the desired Default Value
  Is returned instead. }

Function StrToIntDef(Const S: String; Default: LongInt): LongInt;

{ LoadStr - Loads A String from the application's resources. the
  String Is retrieved by an Integer Number. If the resources don't
  contain A String With the given Number, LoadStr returns an Empty
  String. }

Function LoadStr(Ident: Word): String;

{ LoadNLSStr - Loads A String from the application's Current Language Table. the
  String Is retrieved by an Integer Number. If the resources don't
  contain A String With the given Number, LoadStr returns an Empty
  String. }

Function LoadNLSStr(Ident: Word): String;

{ LoadTableStr - Loads A String from the specified String Table. the
  String Is retrieved by an Integer Number. If the resources don't
  contain A String With the given Number, LoadStr returns an Empty
  String. }

Function LoadTableStr(Const Table:String;Ident: Word): String;

{ FmtLoadStr - Loads A String from the application's resources And
  replaces Some placeholders by values given In an Open-Array. the
  String Is retrieved by an Integer Number. If the resources don't
  contain A String With the given Number, FmtLoadStr returns an
  Empty String. }

Function FmtLoadStr(Ident: Word; Const Args: Array Of Const): String;

{ FmtLoadNLSStr - Loads A String from the application's Current Language Table And
  replaces Some placeholders by values given In an Open-Array. the
  String Is retrieved by an Integer Number. If the resources don't
  contain A String With the given Number, FmtLoadStr returns an
  Empty String. }

Function FmtLoadNLSStr(Ident: Word; Const Args: Array Of Const): String;

{ FmtLoadTableStr - Loads A String from the specified String Table And
  replaces Some placeholders by values given In an Open-Array. the
  String Is retrieved by an Integer Number. If the resources don't
  contain A String With the given Number, FmtLoadStr returns an
  Empty String. }

Function FmtLoadTableStr(Const Table:String;Ident: Word; Const Args: Array Of Const): String;

{ SysErrorMessage - returns A System Error Message. }

{$IFDEF OS2}
Function SysErrorMessage(MsgNum: LongInt): String;
{$ENDIF OS2}

{ --- File management --- }

{ StrMatch - Vergleicht der Parameter iMask mit iStr. Es sind auch
Jokerzeichen, die iJoker bzw. iWild definiert werden, moeglich. }
Function StrMatch(const iMask, iStr: string; iWild, iJoker: char): Boolean;

{ FileOpen - Opens an existing File With A given File Mode. the File
  Mode Is A logical combination Of one Of the File Open constants
  (fmOpenXXX) And one Of the sharing Mode constants (fmShareXXX). If
  the File Is successfully opended, the resulting Integer Value Is
  positive And Contains the File Handle. Otherwise the Result Is the
  Negative Value Of the Error Code returned by the operating System. }

Function FileOpen(Const FileName: String; Mode: Longint): LongInt;

{ FileCreate - creates A New File Or overwrites an existing one. no
  File Mode can be specified, So the File Is always created With
  fmOpenWrite Or fmShareExclusive. If the File Is successfully
  created, the resulting Integer Value Is positive And Contains the
  File Handle. Otherwiese the Result Is the Negative Value Of the
  Error Code returned by the operating System. }

Function FileCreate(Const FileName: String): LongInt;

{ FileOpenOrCreate - Opens Or creates A File, depending ON whether
  the File already exists Or Not. A File Mode can be specified. the
  File Mode Is A logical combination Of one Of the File Open constants
  (fmOpenXXX) And one Of the sharing Mode constants (fmShareXXX). If
  the File Is successfully opended Or created, the resulting Integer
  Value Is positive And Contains the File Handle. Otherwise the
  Result Is the Negative Value Of the Error Code returned by the
  operating System. }

Function FileOpenOrCreate(Const FileName: String; Mode: Longint): LongInt;

{ FileCreateIfNew - creates A File If there's Not already A File With
  the same Name. A File Mode can be specified. the File Mode Is a
  logical combination Of one Of the File Open constants (fmOpenXXX)
  And one Of the sharing Mode constants (fmShareXXX). If the New File
  Is successfully created, the resulting Integer Value Is positive And
  Contains the File Handle. Otherwise the Result Is the Negative Value
  Of the Error Code returned by the operating System. note that This
  Function also fails If the File already exists. }

Function FileCreateIfNew(Const FileName: String; Mode: Longint): LongInt;

{ FileRead - Attempts To Read up To Count Bytes from the given File
  Handle And returns the Number Of Bytes actually Read. If an Error
  occurs, the Result Is -1. }

Function FileRead(Handle: LongInt; Var Buffer; Count: LongInt): LongInt;

{ FileWrite - Attempts To Write up To Count Bytes To the given File
  Handle And returns the Number Of Bytes actually written. If an Error
  occurs, the Result Is -1. }

Function FileWrite(Handle: LongInt; Const Buffer; Count: LongInt): LongInt;

{ FileSeek - changes the Current Position Of A File Handle by Count
  Bytes. the actual Movement depends ON the Value Of Origin, according
  To the following Table:

    Origin        Action

      0           Move relative To the file's beginning
      1           Move relative To the Current Position
      2           Move relative To the file's End

  the Function returns the New Position, Or -1 If an Error occured. }

Function FileSeek(Handle: LongInt; Offset: LongInt; Origin: Integer): LongInt;

{ FileClose - Closes A File And frees the Handle. }

Procedure FileClose(Handle: LongInt);

{ FileLock - Locks A Range Of A File For exclusive access by the
  Application. returns A Boolean Value indicating Success Or
  failure. note that the Function waits up To the Time specified
  In the LockTimeout global variable before it fails. }

Function FileLock(Handle, Offset, Range: LongInt): Boolean;

{ FileUnLock - Unlocks A Range Of A File that was previously locked
  For exclusive access by the Application. returns A Boolean Value
  indicating Success Or failure. }

Function FileUnLock(Handle, Offset, Range: LongInt): Boolean;

{ FileAge - returns the date And Time Of A file's Last modification.

  If the File doesn't exist, -1 Is returned instead.

  To Use date / Time formatting functions For This Value, Convert it
  To A TDateTime by A call To FileDateToDateTime First. }

Function FileAge(Const FileName: String): LongInt;

{ FileAgeCreation - returns the date And Time Of A file's creation.

  If the File doesn't exist, -1 Is returned instead.

  To Use date / Time formatting functions For This Value, Convert it
  To A TDateTime by A call To FileDateToDateTime First. }

Function FileAgeCreation(Const FileName: String): LongInt;

{ FileExists - Indicates whether A File exists Or Not. }

Function FileExists(Const FileName: String): Boolean;

{ FileGetSize - Get the size of the File }

Function FileGetSize(aFilename: String): LongInt;

{ PathExists - Indicates whether a directory exists Or Not. }

Function PathExists(PathName: tFileName): Boolean;

{ FindFirst - Starts A Search For files specified by A Name Pattern
  And File Attributes.

  any Pattern that Is allowed ON the Command Line Is also A legal
  argument For Path.

  Attr Is A logical combination Of File Attributes (faXXX) And
  File-MUST Attributes (faMustXXX), the latter being available only
  under OS/2.

  the Var SearchRec will contain Name And Attributes Of the First File
  that matched the given specs. In This Case the Function returns 0.
  If an Error occurs, the Result Is the Negative Value Of the Error
  Code returned by the operating System.

  Use FindNext To Find more files And FindClose To End the File
  Search. note that you MUST Use FindClose, Or you may Run out Of
  handles after A While. }

Function FindFirst(Const Path: String; Attr: LongWord; Var F: TSearchRec): LongInt;

{ FindNext - after A call To FindNext, the Var SearchRec Contains the
  Next File that matches the specs Of A File Search previously started
  by FindFirst.

  A return Value Of 0 Indicates Success. you may call FindNext Until
  an Error occures (With the Negative Value Of the operating system's
  Error Code returned), Or Until no more matching files are found
  (usually indicated by A return Value Of -18.) }

Function FindNext(Var F: TSearchRec): LongInt;

{ FindClose - Ends A File Search previously started by FindFirst. note
  that you MUST Use FindClose, Or you may Run out Of handles after a
  While. }

Procedure FindClose(Var F: TSearchRec);

{ FileGetDate - returns the date And Time Of A file's Last
  modification. If the given File Handle Is invalid, -1 Is returned
  instead.

  To Use date / Time formatting functions For the Result, Convert
  it To A TDateTime by A call To FileDateToDateTime First. }

Function FileGetDate(Handle: LongInt): LongInt;

{ FileSetDate - changes the date And Time Of A file's Last
  modification. If the Operation fails due To an invalid Handle Or
  an illegal Age Parameter, the date And Time remain unchanged.

  This Procedure doesn't Accept TDateTime values. you have To Convert
  them To A LongInt by DateTimeToFileDate First. }

Procedure FileSetDate(Handle: Integer; Age: LongInt);

{ FileGetAttr - returns A file's Attributes. the Result Value Is a
  logical combination Of File attribute constants (faXXX). If the
  Function fails due To A non-existing File Or another Error
  condition, the Result Is the Negative Value Of the operating
  system's Error Code. }

Function FileGetAttr(Const FileName: String): LongInt;

{ FileSetAttr - changes A file's Attributes. the Attr Parameter may
  contain any logical combination Of File attribute constants
  (faXXX). A Result Value Of 0 Indicates Success. If the Function
  fails due To A non-existing File Or another Error condition, the
  Result Is the Negative Value Of the operating system's Error Code. }

Function FileSetAttr(Const FileName: String; Attr: Integer): Integer;

{ CopyFile - copies A File. Result Is A Boolean indicating Success Or
  failure. }

Function CopyFile(Const SourceName, DestName: String): Boolean;

{ DeleteFile - deletes A File. Result Is A Boolean indicating Success
  Or failure. }

Function DeleteFile(Const FileName: String): Boolean;

{ RenameFile - Renames A File. Result Is A Boolean indicating Success
  Or failure. you may Use RenameFile To Move A File To A New location,
  but only If the Drive stays the same. }

Function RenameFile(Const OldName, NewName: String): Boolean;

{ ChangeFileExt - changes the extension Of A given FileName. the
  extension Is the part from the rightmost dot To the End Of the
  FileName. If the old FileName doesn't contain an extension, it
  Is simply added. the extension MUST Start With A dot.

  note that the Function only handles A String, but does Not Perform
  any Physical changes To files. }

Function ChangeFileExt(Const FileName, extension: String): String;

{ ExtractFileDrive - returns the Drive parts Of a FileName, that Is,
  everything from the Start To the rightmost colon Or backslash In the
  String. If the FileName doesn't contain Drive information,
  an Empty String Is returned. }

Function ExtractFileDrive(Const FileName: tFileName) : tFileName;

{ ExtractFilePath - returns the Drive And Directory parts Of a
  FileName, that Is, everything from the Start To the rightmost colon
  Or backslash In the String. If the FileName doesn't contain Drive Or
  Directory information, an Empty String Is returned. }

Function ExtractFilePath(Const FileName: String): String;

{ ExtractFileName - returns the Name And extension parts Of A
  FileName, that Is, everything from rightmost colon Or backslash To
  the End Of the String. If the FileName doesn't contain A Name Or
  extension, an Empty String Is returned. }

Function ExtractFileName(Const FileName: String): String;

{ ExtractFileExt - returns the extension part Of A FileName, that Is,
  everything from rightmost dot To the End Of the String. If the
  FileName doesn't contain A dot, an Empty String Is returned. }

Function ExtractFileExt(Const FileName: String): String;

{ ConcatFileName - Concatenates two filenames, assuming the First
  one specifies Some Kind Of Directory information, And the Second
  one A FileName. the Result Is A Complete legal pathname. the
  Function automatically inserts A backslash, If necessary. }

Function ConcatFileName(Const pathname, FileName: String): String;

{ ExpandPath - Expands a relative filename or directory (or multiple
  separated by ';') to an absolute file name or directory (starting with
  pathname), that Is, A FileName containing A Drive letter, Directory
  information relative To the root Of the Drive, And the FileName.
  Embedded '..' are removed. }

Function ExpandPath(pathname, FileName:String):String;

{ ExpandFileName - Expands A FileName To an Absolute FileName, that
  Is, A FileName containing A Drive letter, Directory information
  relative To the root Of the Drive, And the FileName. Embedded '..'
  are removed. }

Function ExpandFileName(FileName: String): String;

{ EditFileName - changes A FileName using A Pattern possibly
  containing the wildcards '*' And '?'. everything that would
  be Accepted by the Copy Command should be legal For Name And
  edit. }

Function EditFileName(Const Name, edit: String): String;

{ FileSearch - Searches For A File Name In A List Of directories
  given by DirList. the Directory entries MUST be separated by
  semicolons, just like the system's Path. the working Directory
  Is implicitly prepended To the List Of directories. the Result
  String Is either the First occurence Of the File Complete With
  the Directory it was found In, Or the Empty String, If the File
  could Not be found. }

Function FileSearch(Const Name : String; DirList: AnsiString): tFileName;

{ GetTempFileName - Generate a Tempfilename }
Function GetTempFileName:tFileName;

{ Deltree: Delete a directory-path; src from Toolbox }
Procedure DelTree(Const PathName : tFileName);

{ AddPathSeparator: Add the Path-Separator, if is necessary }
Function AddPathSeparator(Const PathName : tFileName) : tFileName;

{ DeleteLastPathSeparator: Delete the last Path-Separator, if there ist exist }
Function DeleteLastPathSeparator(Const PathName : tFileName) : tFileName;

{ DelPath: Delete the Files in the Path }
Procedure DelPath(Const PathName, Mask : tFileName);

{ GetBootDisk: Ermittelt das Bootlaufwerk }
function GetBootDisk: Byte;

{ DiskFree - returns the Free space Of the given disk Drive. Drive 0
  Is the Current Drive, Drive 1 Is 'A:', And So ON. If the given Drive
  Is invalid Or cannot be Read, -1 Is returned, Otherwise the Result
  Contains the Number Of Bytes Free. }

Function DiskFree(Drive: Byte): extended;      

{ DiskSize - returns the disk Size Of the given disk Drive. Drive 0
  Is the Current Drive, Drive 1 Is 'A:', And So ON. If the given Drive
  Is invalid Or cannot be Read, -1 Is returned, Otherwise the Result
  Contains the Number Of Bytes that can be potentially used For File
  storage. }

Function DiskSize(Drive: Byte): extended;

{ FileDateToDateTime - Converts A File date / Time Value To a
  TDateTime that can be used within formatting operations. }

Function FileDateToDateTime(FileDate: LongInt): TDateTime;

{ FileDateToDateTime - Converts A TDateTime To A File date / Time
  Value that can be used within File functions. }

Function DateTimeToFileDate(DateTime: TDateTime): LongInt;

{ --- 'C'-like String Handling --- }

{ StrLen - returns the Length Of Str, ignoring the terminating Zero. }

Function StrLen(Str: PChar): Cardinal;

{ StrEnd - returns A Pointer To the terminating Zero Of Str. }

Function StrEnd(Str: PChar): PChar;

{ StrMove - copies exactly Count characters from Source To Dest. It's
  okay when Source And Dest overlap, StrMove can Handle This. }

Function StrMove(Dest, Source: PChar; Count: Cardinal): PChar;

{ StrCopy - copies Source To Dest And returns Dest. }

Function StrCopy(Dest, Source: PChar): PChar;

{ StrECopy - copies Source To Dest And returns A Pointer To the
  terminating Zero Of the resulting String. }

Function StrECopy(Dest, Source: PChar): PChar;

{ StrLCopy - copies A maximum Of MaxLen characters from Source To Dest
  And returns Dest. }

Function StrLCopy(Dest, Source: PChar; MaxLen: Cardinal): PChar;

{ StrPCopy - copies A Pascal String Source To A PChar Dest And returns
  Dest. }

Function StrPCopy(Dest: PChar; Const Source: String): PChar;

{ StrPLCopy - copies A maximum Of MaxLen characters from A Pascal
  String Source To A PChar Dest. returns Dest. }

Function StrPLCopy(Dest: PChar; Const Source: String; MaxLen: Cardinal): PChar;

{ StrACopy - copies A Pascal AnsiString Source To A PChar Dest And returns
  Dest. }

Function StrACopy(Dest: PChar; Const Source: AnsiString): PChar;

{ StrALCopy - copies A Pascal AnsiString Source To A PChar Dest And returns
  Dest. }

Function StrALCopy(Dest: PChar; Const Source: AnsiString; MaxLen: Cardinal): PChar;

{ StrCat - Concatenates Dest And Source, that Is, Appends Source To
  the End Of Dest, And returns Dest. }

Function StrCat(Dest, Source: PChar): PChar;

{ StrLCat - Concatenates Dest And Source, that Is, Appends Source To
  the End Of Dest, but copies only So many characters that the
  resulting String does Not exceed MaxLen characters. returns Dest. }

Function StrLCat(Dest, Source: PChar; MaxLen: Cardinal): PChar;

{ StrComp - Compares two Strings And returns an Integer Value
  As In the following Table:

    Str1 < Str2       Result < 0
    Str1 = Str2       Result = 0
    Str1 > Str2       Result > 0

  StrComp Is Case-sensitive, but does Not take international Special
  characters Or the Currently Selected codepage into account. }

Function StrComp(Str1, Str2: PChar): Integer;

{ StrIComp - Compares two Strings And returns an Integer Value
  As In the following Table:

    Str1 < Str2       Result < 0
    Str1 = Str2       Result = 0
    Str1 > Str2       Result > 0

  StrComp Is Case-insensitive, And does Not take international
  Special characters Or the Currently Selected codepage into account. }

Function StrIComp(Str1, Str2: PChar): Integer;

{ StrLComp - Compares up To MaxLen characters Of two Strings And
  returns an Integer Value As In the following Table:

    Str1 < Str2       Result < 0
    Str1 = Str2       Result = 0
    Str1 > Str2       Result > 0

  StrLComp Is Case-sensitive, but does Not take international Special
  characters Or the Currently Selected codepage into account. }

Function StrLComp(Str1, Str2: PChar; MaxLen: Cardinal): Integer;

{ StrLIComp - Compares up To MaxLen characters Of two Strings And
  returns an Integer Value As In the following Table:

    Str1 < Str2       Result < 0
    Str1 = Str2       Result = 0
    Str1 > Str2       Result > 0

  StrLComp Is Case-insensitive, And does Not take international
  Special characters Or the Currently Selected codepage into account. }

Function StrLIComp(Str1, Str2: PChar; MaxLen: Cardinal): Integer;

{ StrScan - Searches For the First occurence Of A character In A
  String. returns the Pointer To the occurence, Or Nil, If the
  character cannot be found. }

Function StrScan(Str: PChar; Chr: Char): PChar;

{ StrRScan - Searches For the Last occurence Of A character In A
  String. returns the Pointer To the occurence, Or Nil, If the
  character cannot be found. }

Function StrRScan(Str: PChar; Chr: Char): PChar;

{ StrScanN - liefert die Position des Zeichen im String }

Function StrScanN(Str:PChar; Chr : Char):LONGINT;

{ StrPos - Searches For the First occurence Of A SubStr In A given
  String Str. returns the Pointer To the occurence, Or Nil, If the
  SubStr cannot be found. }

Function StrPos(Str, SubStr: PChar): PChar;

{ Sucht im String "Str" den angegeben "Substr". Die Funktion liefert
  die Position }

Function StrPosN(Str, SubStr: PChar) : LongInt;

{ StrUpper - Converts A String To upper Case by simply Changing All
  occurences Of 'a'..'z' To the corresponding upper Case characters.
  returns A Pointer To the String. changes the Source String, does
  Not Create A New String. does also Not take international Special
  characters Or the Currently Selected codepage into account. }

Function StrUpper(Str: PChar): PChar;

{ StrLower - Converts A String To lower Case by simply Changing All
  occurences Of 'A'..'Z' To the corresponding lower Case characters.
  returns A Pointer To the String.  changes the Source String, does
  Not Create A New String. does also Not take international Special
  characters Or the Currently Selected codepage into account. }

Function StrLower(Str: PChar): PChar;

{ StrPas - Converts A PChar Str To A Pascal String. }

Function StrPas(Str: PChar): String;

{ StrAlloc - Allocates A block Of Memory For storing PChars. the Size
  Is specified And stored In A Double Word that preceeds the Buffer.
  Use StrDispose To Free the Buffer. }

Function StrAlloc(Size: Cardinal): PChar;

{ StrBufSize - returns the Size Of A PChar Buffer that has been
  previously allocated by StrAlloc. }

Function StrBufSize(Str: PChar): Cardinal;

{ StrNew - creates A Copy Of A given String. In contrast To StrCopy,
  StrNew Allocates A Memory block that can hold the String, by a
  call To StrAlloc. Then it copies the Source String. the New
  String can be disposed by A call To StrDispose. }

Function StrNew(Str: PChar): PChar;

{ StrDispose - Disposes A PChar Buffer that has been previously
  allocated by A call To StrAlloc. }

Procedure StrDispose(Str: PChar);

{ --- String formatting --- }
{ **************************************************************************** }

{ format - formats A String And replaces placeholders by arguments.

  the format String can contain arbitrary Text. This Text Is simply
  copied into the Result. everything that Starts With A '%' Is
  considered A placeholder. placeholders are replaced by the
  Parameters given In the variant-Type Open-Array Args. the First
  placeholder Is replaced by the First argument, the Second one
  by the Second argument, And So ON. you MUST specify At least As many
  Parameters As there are placeholders, Otherwise an Exception
  EConvertError will be raised.

  the way A placeholder / argument pair will be Handled Is controlled
  by Some optional specifiers. the Line below shows the possibilities.

  Text In " " MUST appear literally, 'index', 'width' And 'precision'
  MUST be replaced by Integer numbers, And 'type' MUST be replaced by
  A character that specifies the argument Type.

  parts enclosed In angular brackets are optional, the angular
  brackets MUST Not appear In the format specifier, they are only used
  To Show the syntax.

    "%" [Index ":"] ["-"] [Width] ["." Precision] Type

  the different parts Of the format specifier MUST appear In the
  given order, And they have the following meaning:

    "%"                Begins the format specifier

    Index ":"          takes the Next argument from the Array entry
                       given by Integer Value Index. Normally the
                       arguments are used one after the other. This
                       part Of the format specifier allows To Change
                       This behaviour.

    "-"                Left-Justifies the Text inserted For the format
                       specifier. Normally the Text Is justified To
                       the Right. only applies If the String Is Left-
                       padded With spaces by the Width-specifier.

    Width              Integer Value that specifies the Width being
                       reserved For the argument. If the String
                       resulting from the conversion Of the argument
                       Contains less than Width characters, it Is
                       Left padded With spaces To achieve This minimum
                       Length. If "-" Is used To Activate Left-
                       justification, the String Is padded To the
                       Right rather than To the Left. If the String
                       already has A Length equal To Or greater than
                       Width, no padding Is Needed.

    "." Precision      Integer Value that specifies the Precision
                       used when converting the argument. the actual
                       consequences Of Precision depend ON the
                       argument Type. See descriptions below For
                       Details.

  the Index, Width, And Precision specifiers can also contain an
  asterisk ('*'). In This Case, the Real Value Is taken from the
  Next argument Array entry, which has To be an Integer Value, Or
  EConvertError will be raised.

  following are the characters allowed To specify the argument Type.
  note that 'decimal point' And 'thousand separator' mean that the
  characters contained In the global variables DecimalSeparator And
  ThousandSeparator will be inserted.

    D                  DECIMAL format. the corresponding argument MUST
                       be an Integer Value, Otherwise EConvertError Is
                       raised. the argument Is converted To A DECIMAL
                       String. If A Precision Is specified, the String
                       Is guaranteed To have At least A Number Of
                       Digits equal To Precision. If the String Is
                       shorter, it Is padded With zeroes.

    E                  Scientific (exponential) format. the
                       corresponding argument MUST be A floating Point
                       Value, Otherwise EConvertError Is raised. the
                       argument Is converted To A DECIMAL String using
                       Scientific notation. the String Starts With a
                       minus sign, If the argument Is Negative. one
                       digit always precedes the DECIMAL Point. the
                       Number Of Digits following the DECIMAL Point Is
                       controlled by the optional Precision specifier.
                       the total Number Of Digits Is always equal To
                       Precision. If Precision Is Not specified, a
                       Default Of 15 Is assumed, resulting In 1 digit
                       before And 14 after the DECIMAL Point.
                       following Is the exponential 'E' With A plus Or
                       A minus sign And up To 3 Digits indicating the
                       Exponent.

    F                  FIXED Point format. the corresponding argument
                       MUST be A floating Point Value, Otherwise
                       EConvertError Is raised. the argument Is
                       converted To A String using FIXED notation. it
                       Starts With A minus sign, If the argument Is
                       Negative. All Digits Of the argument's Integer
                       part appear In the Result. following Is a
                       DECIMAL separator And A Number Of Digits equal
                       To Precision. If no Precision Is specified, a
                       Default Of 2 DECIMAL places Is assumed.

    G                  General Number format. the argument MUST be a
                       floating Point Value, Otherwise EConvertError
                       Is raised. the argument Is converted To a
                       String using either FIXED Or Scientific format,
                       depending ON which results In A shorter String.
                       the optional Precision specifier Controls the
                       Number Of significant Digits (used For
                       rounding) With A Default Of 15. the Result will
                       contain neither unnecessary zeroes nor an
                       unnecessary DECIMAL Point. If the argument
                       Value Is greater than Or equal To 0.00001, And
                       If the Number Of Digits To the Left Of the
                       DECIMAL Point Is less than Or equal To the
                       Precision, FIXED format Is used. Otherwise the
                       Result Uses Scientific format.

    M                  currency (money) format. the corresponding
                       argument MUST be A floating Point Value,
                       Otherwise EConvertError Is raised. the argument
                       Is converted To A String using the following
                       global variables:

                         CurrencyString
                         CurrencyFormat
                         NegCurrFormat
                         CurrencyDecimals

                       If A Precision Is specified, it overrides the
                       Default Value Of CurrencyDecimals.

    N                  Number format. equal To FIXED, but the Result
                       String will contain thousand separators.

    P                  Pointer format. the corresponding argument MUST
                       be A Pointer Value, Otherwise EConvertError Is
                       raised. the Value Is converted To A String
                       containing the hexadecimal representation Of
                       the Pointer, With an additional ':' In the
                       middle. the resulting String has always a
                       Length Of 9 characters. since we are dealing
                       With flat Memory model, we have A full 32-bit
                       Pointer With no segment part, only Offset.

    S                  String format. the corresponding argument MUST
                       be A Single character, A String Or A PChar Value,
                       Otherwise EConvertError Is raised. the argument
                       Is simply copied To the destination String. If
                       A Precision Is specified, it Is considered the
                       maximum Length Of the argument String. longer
                       Strings will be truncated.

    X                  hexadecimal format. the corresponding argument
                       MUST be an Integer Value, Otherwise EConvertError
                       Is raised. the argument Is converted To a
                       hexadecimal String. If A Precision Is specified,
                       the String Is guaranteed To have At least a
                       Number Of Digits equal To Precision. If the
                       String Is shorter, it Is padded With zeroes. }

Function format(Const format: String; Const Args: Array Of Const): String;

{ FmtStr - formats A String And replaces placeholders by arguments.
  See format For A detailed description Of the format String And the
  argument Array. }

Procedure FmtStr(Var Result: String; Const format: String;
  Const Args: Array Of Const);

{ StrFmt - formats A String And replaces placeholders by arguments.
  note that the Buffer MUST be large enough To hold the Complete
  Result, Otherwise A protection fault (EGPFault) may occur. See
  format For A detailed description Of the format String And the
  argument Array. }

Function StrFmt(Buffer, format: PChar; Const Args: Array Of Const): PChar;

{ StrLFmt - formats A String And replaces placeholders by arguments.
  the Function ensures that the Size Of the Output String written into
  Buffer won't exceed MaxLen characters. the function's Result Is also
  A Pointer To Buffer. See format For A detailed description Of the
  format String And the argument Array. }

Function StrLFmt(Buffer: PChar; MaxLen: Cardinal; format: PChar;
  Const Args: Array Of Const): PChar;

{ FormatBuf - formats A String And replaces placeholders by arguments.
  format And Buffer Strings are given As untyped Var / Const
  Parameters. their sizes are given In BufLen And FmtLen. the Function
  ensures that the Size Of the Output String written into Buffer won't
  exceed BufLen characters. the Result Value Is the Number Of
  characters actually written into Buffer. See format For A detailed
  description Of the format String And the argument Array. }

Function FormatBuf(Var Buffer; BufLen: Cardinal; Const format;
  FmtLen: Cardinal; Const Args: Array Of Const): Cardinal;

{ --- floating Point conversion --- }
{ **************************************************************************** }

{ FloatToStrF - Converts A floating Point Number To A String. the
  appearance Of the Result String can be controlled by specifying
  A basic format To apply, A Precision, And A Number Of Digits.
  the Precision Parameter should be less than Or equal To 18. the
  meaning Of the Digits Parameter depends ON the format chosen.

  following Is A detailed description Of the possible formats:

    ffCurrency     money (currency) format. the argument Is converted
                   To A String using the following global variables:

                     CurrencyString
                     CurrencyFormat
                     NegCurrFormat

                   the Digits Parameter specifies the Number Of Digits
                   following the DECIMAL Point (0 To 18 being legal
                   values).

    ffExponent     Scientific (exponential) format. the argument Is
                   converted To A DECIMAL String using Scientific
                   notation. the String Starts With A minus sign, If
                   the argument Is Negative. one digit precedes the
                   DECIMAL Point. the Number Of Digits following the
                   DECIMAL Point Is controlled by Precision. the total
                   Number Of Digits Is always equal To Precision.
                   following Is the exponential 'E' With A plus Or a
                   minus sign And the Exponent With A minimum Length
                   Of Digits characters (0 To 4 being legal values).

    ffFixed        FIXED Point format. the argument Is converted To a
                   String using FIXED Point notation. it Starts With a
                   minus sign, If the argument Is Negative. All Digits
                   Of the argument's Integer part appear In the Result.
                   following Is A comma And A Number Of DECIMAL Digits
                   equal To Digits (0 To 18 being legal values). If
                   the Number Of Digits To the Left Of the DECIMAL
                   Point Is greater than Precision, the Output will be
                   In Scientific format.

    ffGeneral      General Number format. the argument Is converted
                   To A String using either FIXED Or Scientific
                   format, depending ON which results In A shorter
                   String. the Result will contain neither trailing
                   zeroes nor an unnecessary DECIMAL Point. If the
                   argument Value Is greater than Or equal To 0.00001,
                   And If the Number Of Digits To the Left Of the
                   DECIMAL Point Is less than Or equal To Precision,
                   FIXED format Is used. Otherwise the Result Is
                   formatted In Scientific format With Digits
                   specifying the minimum Number Of Digits In the
                   Exponent (0 To 4 being legal values).

    ffNumber       Number format. equal To FIXED, but the Result
                   String will contain thousand separators.

  If the Value Is Not-A-Number, positive infinity, Or Negative
  infinity, Then the Output String will also be NAN, INF, Or -INF. }

Function FloatToStrF(Value: Extended; format: TFloatFormat;
  Precision, Digits: Integer): String;

{ FloatToStr - Converts A floating Point Value To A String using
  General Number format And 15 significant Digits. See FloatToStrF
  For more Details. }

Function FloatToStr(Value: Extended): String;

{ FloatToText - Converts A floating Point Number To A String. the
  Result Is written To Buffer without A Zero teminator being
  appended. the caller has To ensure that the Buffer Is large
  enough To hold the Result. the Result can be controlled using
  format, Precision And Digits Parameters. See FloatToStrF For
  A detailed description Of these Parameters. }

Function FloatToText(Buffer: PChar; Value: Extended; format: TFloatFormat;
  Precision, Digits: Integer): Integer;

{ FormatFloat - Converts A floating Point Value To A String using a
  specified format.

  the Parameter format Controls the appearance Of the Result String.

  format can contain up To three Sections, separated from each other
  by semicolons. the First section holds the format String used For
  positive values, the Second one holds the format For Negative
  values, And the third one Is applied To Zero values. If one Of
  the Sections Is missing Or Empty, the First section Is used
  instead. If All Sections are missing Or Empty, General Number
  format Is used With A Precision Of 15. See FloatToStrF For more
  Details about General Number format.

  each Of the three Sections can contain arbitrary Text, which Is
  simply copied To the Result String. Some characters have A Special
  meaning, they serve As placeholders For inserting Data from the
  Value Parameter.

  the following List shows All placeholders And their meaning:

    0         Mandatory digit. If the Value has A digit At This
              Position, it Is copied To the Result. Otherwise a
              0 Is inserted.

    #         optional digit. If the Value has A digit At This
              Position, it Is copied To the Result. Otherwise
              This Position Of the format String will be ignored.

    .         DECIMAL separator. the First occurence Of '.' In the
              format String determines the Position At which A DECIMAL
              separator will be inserted. the DECIMAL separator Is
              taken from the global variable DecimalSeparator. further
              occurences Of '.' will be ignored.

    ,         thousand separator. any occurence Of ',' activates the
              insertion Of thousand separators into the Result, where
              necessary. the thousand separator Is taken from the
              global variable DecimalSeparator.

    E+ E-     Scientific (exponential) format. If any Of the four
    E+ E-     Strings To the Left occur In the format String, the
              Result will be formatted using Scientific notation.
              the exponential E will have the same Case As In the
              format String. the Exponent itself will always be
              preceded by its sign, If E+ Or E+ are used. E- And E-
              contain A sign only If the Exponent Value Is Negative.
              up To four digit placeholders can be used To specify the
              minimum Number Of Digits used For the Exponent.

    '...'     characters enclosed In Single Or Double quotes will
    "..."     simply be copied To the Result (without quotes).

  the floating Point Value Is rounded With A Precision equal To the
  total Number Of digit placeholders In the format String. optional
  digit placeholders between the leftmost And rightmost Mandatory
  digit placeholders will be taken As Mandatory Digits, So it makes
  no sense To specify one ore more '#' between zeroes. If the rounded
  Value Contains more Digits In the Integer part than there are
  placeholders Left Of the DECIMAL separator, the additional Digits
  will be inserted before the First placeholder. }

Function FormatFloat(Const format: String; Value: Extended): String;

{ FloatToTextFmt - Converts A floating Point Value To A String using a
  specified format. the Result Is written To Buffer without a
  terminating Zero. the caller has To ensure that the Buffer Is large
  enough To hold the Result. the Number Of characters actually written
  To Buffer Is returned. See FormatFloat For A description Of the
  format Parameter. }

Function FloatToTextFmt(Buffer: PChar; Value: Extended;
  format: PChar): Integer;

{ StrToFloat - Converts A String To A floating Point Value. the String
  MUST contain A legal floating Point Value, With the DECIMAL Point
  being the same character As In the global variable DecimalSeparator.
  it MUST Not contain thousand separators Or currency symbols. leading
  And trailing spaces are allowed. If the String does Not conform
  these restrictions, EConvertError Is raised. }

Function StrToFloat(Const S: String): Extended;

{ TextToFloat - Converts A Zero-Terminated String To A floating Point
  Value. the String MUST contain A legal floating Point Value, With
  the DECIMAL Point being the same character As In the global variable
  DecimalSeparator. it MUST Not contain thousand separators Or
  currency symbols. leading And trailing spaces are allowed. If the
  String does Not conform these restrictions, EConvertError Is raised. }

Function TextToFloat(Buffer: PChar; Var Value: Extended): Boolean;

{ FloatToDecimal - Converts A floating Point Value To A TFloatRec
  Record which separates Digits, sign, And Exponent. the Precision
  Parameter specifies the Number Of significant Digits (With 1..18
  being legal values), the Decimals Parameter specifies the desired
  minimum Number Of Digits In the fractional part. rounding Is
  controlled by Precision As well As by Decimals. To force A Number
  Of significant Digits even With large values, specify 9999 For
  Decimals.

  the resulting TFloatRec will contain the following information:

    Exponent - the result's Exponent. an Exponent Value Of -32768
    Indicates that the Value Is Not-A-Number (NAN). positive Or
    Negative infinity (INF / -INF) Is indicated by an Exponent
    Value Of 32767.

    Negative - Indicates whether the Value Is Negative Or Not. Use
    This To distinguish positive from Negative infinity, too. Zero
    Is assumed To be non-Negative.

    Digits - Contains the significant Digits With A terminating
    Zero (Chr(0)). does Not contain the DECIMAL separator. Empty,
    If the Value Is Not-A-Number, Or positive, Or Negative infinity. }

Procedure FloatToDecimal(Var Result: TFloatRec; Value: Extended;
  Precision, Decimals: Integer);

{ --- date / Time Handling --- }
{ **************************************************************************** }

{ EncodeDate - Encodes the given Year, Month, And Day into A Single
  TDateTime Value. the Result Contains the Number Of days passed since
  the 31-Dec-0000 And the given date, assuming Gregorian calendar has
  always been used. If any Parameter Contains an illegal Value,
  EConvertError Is raised. }

Function EncodeDate(Year, Month, Day: Word): TDateTime;

{ EncodeTime - Encodes the given Hour, Minute, Second And millisecond
  into A Single TDateTime Value. the Result Contains the fractional
  part Of the Day passed since 00:00:00. it Is always A Value equal To
  Or greater than Zero And And smaller that one. If any Parameter
  Contains an illegal Value, EConvertError Is raised. }

Function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;

{ DecodeDate - Extracts Year, Month, And Day from A given TDateTime
  Value. }

Procedure DecodeDate(date: TDateTime; Var Year, Month, Day: Word);

{ DecodeTime - Extracts Hour, Minute, Second, And millisecond from a
  given TDateTime Value. }

Procedure DecodeTime(Time: TDateTime; Var Hour, Min, Sec, MSec: Word);

{ DayOfWeek - Extracts the Day Of the week from A given TDateTime
  Value. the days are numbered from 1 To 7 In the following order:

    Sun / Mon / Tue / Wed / Thu / Fri / Sat }

Function DayOfWeek(date: TDateTime): Integer;

{ date - Queries the Current System date. }

Function Date: TDateTime;

{ Time - Queries the Current System Time. }

Function Time: TDateTime;

{ Now - Queries the Current System date And Time. }

Function Now: TDateTime;

{ Now - Queries the Current System date And Time as tStr }

Function NowStr: String; { gehoehrt: tStr21; }

{ DateToStr - Converts the date part Of the given TDateTime Value
  To A String, using the format specified In the global variable
  ShortDateFormat. }

Function DateToStr(date: TDateTime): String;

{ TimeToStr - Converts the Time part ao the given TDateTime Value
  To A String, using the format specified In the global variable
  LongTimeFormat. }

Function TimeToStr(Time: TDateTime): String;

{ DateTimeToStr - Converts the given TDateTime Value To A String
  using the formats specified In the global variables ShortDateFormat
  And LongTimeFormat. the Time Is only appended, If the TDateTime
  Value Contains A (fractional) Time part different from 00:00:00. }

Function DateTimeToStr(DateTime: TDateTime): String;

{ StrToDate - Tries To exctract date information from A String.
  the functions expects the String To contain two Or three numbers
  separated by the character given In the global variable
  DateSeparator. the order In which Day, Month, And Year are
  expected Is determined by the global variable DateOrder.
  If only two numbers are found, they are assumed To specify
  A Month And Day Of the Current Year. If the Year Is smaller
  than 100, it Is assumed To be A Year Of the Current century.
  If no legal date can be extracted from the String,
  EConvertError Is raised. }

Function StrToDate(Const S: String): TDateTime;

{ StrToTime - Tries To exctract Time information from A String.
  the functions expects the String To contain two Or three numbers
  separated by the character given In the global variable
  TimeSeparator, optionally followed by 'AM' Or 'PM' To indicate
  12-Hour format. the First two numbers are taken As Hour And
  Minute, the optional third one As Second. If no indicator For
  12-Hour format Is found, the Time Is assumed To be In 24-Hour
  format. If no legal Time can be extracted from the String,
  EConvertError Is raised. }

Function StrToTime(Const S: String): TDateTime;

{ StrToDateTime - Tries To extract date And Time information from A
  String. the Function expects the String To contain A date optionally
  followed by A Time. See StrToDate And StrToTime For more Details
  about the string's contents. If no legal date And Time can be
  extracted from the String, EConvertError Is raised. }

Function StrToDateTime(Const S: String): TDateTime;

{ FormatDateTime - Converts A TDateTime Value To A String using a
  format specified by the Parameter format.

  the format String may contain arbitrary Text, which Is simply
  copies To the Result String. Some characters Or character
  sequences have A Special meaning, they serve As placeholders And
  are replaced by values extracted from DateTime.

  the following placeholders are allowed In the format String. their
  Case doesn't matter. If the format String Is Empty, 'c' Is assumed
  the Default format.

    C         replaced by the date formatted As specified In the
              global variable ShortDateFormat. If the (fractional)
              Time part Is different from 00:00:00, the Time Is
              appended using the format specified In the global
              variable LongTimeFormat.

    D         replaced by A Number indicating the Day Of the Month,
              With no leading Zero.

    dd        replaced by A Number indicating the Day Of the Month,
              With leading Zero.

    ddd       replaced by the Day Of the week's Name taken from the
              global Array ShortDayNames, resulting In an abbreviation
              Of the day's Name.

    dddd      replaced by the Day Of the week's Name taken from the
              global Array LongDayNames, resulting In the day's full
              Name.

    ddddd     replaced by the date formatted As specified In the
              global variable ShortDateFormat.

    dddddd    replaced by the date formatted As specified In the
              global variable LongDateFormat.

    M         when used immediately after an Hour placeholder,
              replaced by the Minute. Otherwise replaced by A
              Number indicating the Month. no leading zeroes.

    mm        when used immediately after an Hour placeholder,
              replaced by the Minute. Otherwise replaced by A
              Number indicating the Month. leading zeroes.

    mmm       replaced by the month's Name taken from the global Array
              ShortMonthNames, resulting In an abbreviation Of the
              month's Name.

    mmmm      replaced by the month's Name taken from the global Array
              LongMonthNames, resulting In the month's full Name.

    yy        replaced by two Digits indicating the Year. leading
              zeroes.

    yyyy      replaced by four Digits indicating the Year. leading
              zeroes.

    H         replaced by the Hour without leading Zero.

    hh        replaced by the Hour With leading Zero.

    N         replaced by the Minute without leading Zero.

    nn        replaced by the Minute With leading Zero.

    S         replaced by the Second without leading Zero.

    SS        replaced by the Second With leading Zero.

    T         replaced by the Time formatted As specified In the
              global variable ShortTimeFormat.

    tt        replaced by the Time formatted As specified In the
              global variable LongTimeFormat.

    am/PM     Indicates that 12-Hour format should be used For the
              preceding Hour placeholder. replaced by 'am' Or 'pm',
              depending ON the Time, With the same Case As specified.

    A/P       Indicates that 12-Hour format should be used For the
              preceding Hour placeholder. replaced by 'a' Or 'p',
              depending ON the Time, With the same Case As specified.

    ampm      Indicates that 12-Hour format should be used For the
              preceding Hour placeholder. replaced by A String taken
              from the global variables TimeAMString Or TimePMString,
              depending ON the Time.

    /         replaced by the date separator As specified In the global
              variable DateSeparator.

    :         replaced by the Time separator As specified In the global
              variable TimeSeparator.

    '...'     characters enclosed In Single Or Double quotes will
    "..."     simply be copied To the Result (without quotes). }

Function FormatDateTime(Const format: String; DateTime: TDateTime): String;

{ DateTimeToString - Converts A TDateTime Value To A String using A
  format specified by the format Parameter . See FormatDateTime For
  A detailed description Of the format String. }

Procedure DateTimeToString(Var Result: String; Const format: String;
  DateTime: TDateTime);

{ --- System profile support --- }
{ **************************************************************************** }

{ GetProfileStr - Reads A String from the operating system's user
  profile. If section Or entry don't exist, A Default Value Is
  returned instead. }

Function GetProfileStr(Const Section, Entry, Default: String): String;

{ GetProfileChar - Reads A character from the operating system's user
  profile. If section Or entry don't exist, A Default Value Is
  returned instead. }

Function GetProfileChar(Const Section, Entry: String; Default: Char): Char;

{ GetProfileInt - Reads an Integer from the operating system's user
  profile. If section Or entry don't exist, A Default Value Is
  returned instead. }

Function GetProfileInt(Const Section, Entry: string; Default: Integer): Integer;

{ GetFormatSettings - Queries A lot Of Default values used For
  formatting functions from the Operation System. called automatically
  In the SysUtils startup Code, So an Application that Uses SysUtils
  can always access these values immediately after Program startup. }

{  Procedure GetFormatSettings;}

{ ConvertError - Raises EConvertError With the given Error Message. }

Procedure ConvertError(Const Msg: String);

{ --- Some routines that belong into System.PAS --- }

{ SetLength - changes the Length Of A String. Please Use This
  Procedure instead Of writing S[0] := NewLength To maintain
  compatibility With the forthcoming LONG Strings that won't contain
  A Length-Byte any more. }

{ Procedure SetLength(Var S: String; NewLength: Byte); }

{ StringOfChars - returns A String that consists Of
  Count occurences Of the given character CH. }

Function StringOfChars(CH: Char; Count: Integer): String;

{GetPhysicalDrives - returns information about logical drives connected
 to the system. The drives are encoded bitwise starting with bit 0 for
 drive A. A enabled bit indicates that the appropriate drive is present}
Function GetPhysicalDrives:LongWord;

{ --- Random numbers support --- }
{ **************************************************************************** }
VAR RandSeed:LONGWORD;

PROCEDURE Randomize;
FUNCTION  Random(value:word):word;

{ **************************************************************************** }

PROCEDURE SysSleep(ms:LONGWORD);
{ Wartet die in der "ms"-Variable zeit (in Millisekunden) }

Procedure SysShutDown;
{ Shutdown the Operating-System }

Function getEnvCount : LongInt;
{ get the Numnber of Environments }

Function getEnv(const iEnv:String):AnsiString;
{ get the Environmeint }

{Martin}
Procedure StrOemToAnsi(Var s:String);
Procedure StrAnsiToOem(Var s:String);

Var ConvertGetText : boolean;
    OemToAnsiTable, AnsiToOemTable: Array[#0..#255] Of Char;

Implementation

Function minLW(iValue1, iValue2 : LongWord) : LongWord;

Begin
  if iValue1<iValue2
    then Result := iValue1
    else Result := iValue2;
End;

Function minLI(iValue1, iValue2 : LongInt) : LongInt;

Begin
  if iValue1<iValue2
    then Result := iValue1
    else Result := iValue2;
End;

Function maxLW(iValue1, iValue2 : LongWord) : LongWord;

Begin
  if iValue1>iValue2
    then Result := iValue1
    else Result := iValue2;
End;

Function maxLI(iValue1, iValue2 : LongInt) : LongInt;

Begin
  if iValue1>iValue2
    then Result := iValue1
    else Result := iValue2;
End;

Function GetPhysicalDrives:LongWord;
{$IFDEF OS2}
Var  ActualDrive:LongWord;
{$ENDIF}
Begin
  {$IFDEF OS2}
  DosQueryCurrentDisk(ActualDrive,Result);
  {$ENDIF}
  {$IFDEF Win32}
  result := GetLogicalDrives;
  {$ENDIF}
End;

Function SetCurrentLanguageTable(Table:String):Boolean;

Begin
  Table:=Uppercase(Table);
  if (Table = LanguageRCName[tLngGerman]) or
     (Table = LanguageShortName[tLngGerman]) or
     (Table = 'GERMAN') or
     (Table = 'DEUTSCH') 
    then CurrentLanguageTable:=tLngGerman
  else if (Table = LanguageRCName[tLngDutch]) or
          (Table = LanguageShortName[tLngDutch]) or
          (Table = 'NEDERLANDS')
    then CurrentLanguageTable:=tLngDutch
  else if (Table = LanguageRCName[tLngItalien]) or
          (Table = LanguageShortName[tLngItalien]) or
          (Table = 'ITALIEN') or
          (Table = 'ITALIANO')
    then CurrentLanguageTable:=tLngItalien
  else if (Table = LanguageRCName[tLngRussian]) or
          (Table = LanguageShortName[tLngRussian]) or
          (Table = 'RUSSIAN')
    then CurrentLanguageTable:=tLngRussian
    else CurrentLanguageTable:=tLngDefault;
  Result:=true;
End;

Function GetCurrentLanguageTable:String;

Begin
  Result:=LanguageRCName[CurrentLanguageTable];
End;

Function GetCurrentLanguage:String;
Begin
  Result:=LoadNLSStr(SLanguage);
End;

Function GetCurrentLanguageShort:String;
Begin
  Result:=LanguageShortName[CurrentLanguageTable];
End;

Const
  ShareModes = fmShareExclusive
            Or fmShareDenyRead
            Or fmShareDenyWrite
            Or fmShareDenyNone;

Var

{ Collating sequence. Needed For sorting when OS/2 base API functions are used. }

  CollatingSequence: Array[#0..#255] Of Byte;

Procedure ConvertError(Const Msg: String);
Begin
  Raise EConvertError.Create(Msg);
End;

Procedure FmtLoadConvertError(Ident: Integer; Args: Array Of Const);
Var
  Msg: String;
Begin
  Try
    Msg := FmtLoadNLSStr(Ident, Args);
  Except
    Msg := LoadNLSStr(Ident) + ' [!]';
  End;
  ConvertError(Msg);
End;

{ --- String / PChar Utility functions --- }

Assembler

  { This Function returns the Length Of A String And A Pointer To the
    Zero terminator.

    Input:   EDI holds Pointer String
    Output:  EDI hols Pointer To Zero terminator, EAX holds String Length
    changes: EAX, EBX, ECX, EDI }

SysUtils.!StringLength Proc NEAR32
                              
    MOV       EBX, EDI
    XOR       EAX, EAX
    CMP       EDI, 0
    JE        !Out!StringLength
    MOV       ECX, $FFFFFFFF
    CLD
    REPNE     SCASB
    NOT       ECX
    MOV       EAX, ECX
    DEC       EAX
    DEC       EDI

!Out!StringLength:
    RETN32

SysUtils.!StringLength ENDP

  { This functions copies A maximum Number Of characters from one String
    To another.

    Input:   ESI holds Source, EDI holds destination, ECX hold maximum
             Number Of characters
    Output:  EDI holds End Of destination String
    changes: EAX, EBX, ECX, EDX, ESI, EDI }

SysUtils.!StringCopy Proc NEAR32
    MOV       EBX, ECX
    MOV       EDX, EDI
    XOR       EAX, EAX
    CMP       EDI, 0
    JE        !Out!StringCopy
    CMP       ESI, 0
    JE        !Out!StringCopy
    MOV       EDI, ESI
    // look for 0 terminator, starting from EDI
    // or stop at max chars, when ECX = 0
    CLD
    REPNE     SCASB
    // ECX is now (max chars - length) or 0 if limit reached
    // EBX is still max chars
    SUB       EBX, ECX // (max - ( max - length ) ) = length to copy

    // so EBX now contains number of chars
    // to copy INCLUDING null terminator
    CMP       ECX, 0
    JE        !ReachedMaxChars
    DEC       EBX       // Don't wanna copy null teriminator
!ReachedMaxChars:
    MOV       ECX, EBX
    SHR       ECX, 2
    MOV       EDI, EDX
    REP       MOVSD
    MOV       ECX, EBX
    AND       ECX, 3
    REP       MOVSB
    STOSB          // zero terminate result
    DEC       EDI  //Point to zero terminator
!Out!StringCopy:
    RETN32
SysUtils.!StringCopy ENDP

  // This Function Compares A maximum Number Of characters

  SysUtils.!StringCompare Proc NEAR32

    CLD
        REPE       CMPSB
    XOR        EAX, EAX
    MOV        AL, [ESI - 1]
    MOV        BL, [EDI - 1]
    SUB        EAX, EBX
    RETN32

  SysUtils.!StringCompare ENDP

  //

  SysUtils.!StringICompare Proc NEAR32

    XOR        EAX, EAX;
    CLD

  !Loop!StringICompare:

    REPE       CMPSB
    JE         !Out!StringICompare

    XOR        EBX, EBX
    MOV        BL, [ESI - 1]
    CMP        BL, 'A'
    JL         !UpcaseSecondChar!StringICompare
    CMP        BL, 'Z'
    JG         !UpcaseSecondChar!StringICompare
    OR         BL, 32

  !UpcaseSecondChar!StringICompare:

    XOR        EDX, EDX
    MOV        DL, [EDI - 1]
    CMP        DL, 'A'
    JL         !CompareSingleChar!StringICompare
    CMP        DL, 'Z'
    JG         !CompareSingleChar!StringICompare
    OR         DL, 32

  !CompareSingleChar!StringICompare:

    SUB        EBX, EDX
    JE         !Loop!StringICompare
    MOV        EAX, EBX

  !Out!StringICompare:

    RETN32

  SysUtils.!StringICompare ENDP

End;

{ --- System function --- }
{ ************************************************************************ }

Function ModuleLoaded(iModuleName : String): Boolean;

{$IFDEF OS2}
var cModuleName : CString;
    phmod       : HModule;
{$ENDIF}

Begin
  {$IFDEF OS2}
  cModuleName := iModuleName;
  Result:=DosQueryModuleHandle(cModuleName, phmod) = NO_ERROR;
  {$ENDIF OS2}
  {$IFDEF Win32}
  Result:=false;
  {$ENDIF Win32}
End;


{ --- Memory management --- }
{ ************************************************************************ }

Function AllocMem(Size: Cardinal): Pointer;
Begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
End;

Function ReAllocMem(P: Pointer; CurSize, NewSize: Cardinal): Pointer;
Var
  Q: PByteArray;
Begin
  If NewSize <> 0 Then GetMem(Q, NewSize) Else Q := Nil;

  If NewSize > 0 Then
  Begin
    If NewSize > CurSize Then
    Begin
      FillChar(Q^[CurSize], NewSize - CurSize, 0);
      NewSize := CurSize;
    End;
    If NewSize <> 0 Then Move(P^, Q^, NewSize);
  End;
  If CurSize <> 0 Then FreeMem(P, CurSize);
  Result := Q;
End;

{ Exit Procedure Handling }

Type
  PExitNode = ^TExitNode;
  TExitNode = Record
    Next: PExitNode;
    Proc: TProcedure;
  End;

Const
  ExitChain: PExitNode = Nil;

Var
  SaveExitProc: Pointer;

Procedure CallExitProcs;
Var
  First: PExitNode;
  Proc: TProcedure;
Begin
  While ExitChain <> Nil Do
  Begin
    First := ExitChain;
    Proc := First^.Proc;
    ExitChain := First^.Next;
    ExitProc := Nil; { Avoids recursion! }
    Dispose(First);
    Proc;
  End;
  ExitProc := SaveExitProc;
End;

Procedure AddExitProc(Proc: TProcedure);
Var
  NewNode: PExitNode;
Begin
  If ExitChain = Nil Then SaveExitProc := ExitProc;
  New(NewNode);
  NewNode^.Next := ExitChain;
  NewNode^.Proc := Proc;
  ExitChain := NewNode;
  ExitProc := @CallExitProcs;
End;

{ --- Pascal String Handling --- }

Function NewStr(Const S: String): PString;
Begin
  If Length(S) = 0
    Then Result := NullStr
    Else
      Begin
        GetMem(Result, integer(Length(S)) + 1);
        Result^ := S;
      End;
End;

Procedure DisposeStr(P: PString);
Begin
  If (P <> NullStr) And (P <> Nil) Then
    FreeMem(P, integer(Length(P^)) + 1);
End;

Procedure AssignStr(Var P: PString; Const S: String);
Begin
  DisposeStr(P);
  P := NewStr(S);
End;

Procedure AppendStr(Var Dest: String; Const S: String);
Begin
  Insert(S, Dest, integer(Length(Dest)) + 1);
End;

Function uppercase(Const S: String): String;
Var
  T: String;
  N, C: Integer;
Begin
  T := S;
  For N := 1 To Length(T) Do
    Begin
      C := Ord(T[N]);
      If (C >= Ord('a')) And (C <= Ord('z')) Then
        T[N] := Chr(C And Not 32);
    End;
  Result := T;
End;

Function lowercase(Const S: String): String;
Var
  T: String;
  N, C: Integer;
Begin
  T := S;
  For N := 1 To Length(T) Do
  Begin
    C := Ord(T[N]);
    If (C >= Ord('A')) And (C <= Ord('Z')) Then T[N] := Chr(C Or 32);
  End;
  Result := T;
End;

Function CompareStr(Const s1, s2: String): Integer;
Begin
  If s1 <= s2 Then
  Begin
    If s1 = s2 Then Result := 0 Else Result := -1;
  End
  Else Result := +1
End;

Function CompareText(Const s1, s2: String): Integer;
Var
  l1, l2, L: Integer;
Begin
  l1 := Length(s1);
  l2 := Length(s2);
  If l1 <= l2 Then L := l1 Else L := l2;
  Result := StrLIComp(@s1[1], @s2[1], L);
  If Result = 0 Then
  Begin
    If l1 < l2 Then Result := -1 Else If l1 > l2 Then Result := 1;
  End;
End;

{$IFDEF OS2}
Function AnsiUpperCase(Const S: String): String;
Var
  Temp: cstring;
Begin
  Temp := S;
  WinUpper(AppHandle, 0, 0, Temp);
  Result := Temp;
End;
{$ENDIF OS2}

{$IFDEF Win32}
Function AnsiUpperCase(Const S: String): String;
Var
  s1: cstring;
Begin
  s1 := S;
  AnsiUpperBuff(s1, Length(s));
  AnsiUpperCase:=s1;
End;
{$ENDIF Win32}

{$IFDEF Win32}
Function AnsiLowerCase(Const S: String): String;
Var
  s1: cstring;
Begin
  s1 := S;
  AnsiLowerBuff(s1, Length(s));
  Result := s1;
End;
{$ENDIF Win32}

{$IFDEF OS2}
Function AnsiCompareText(Const s1, s2: String): Integer;
Var
  Temp1, Temp2: cstring[256];
Begin
  Temp1 := s1;
  Temp2 := s2;
  Case WinCompareStrings(AppHandle, 0, 0, Temp1, Temp2, 0) Of
    WCS_LT: Result := -1;
    WCS_EQ: Result :=  0;
    WCS_GT: Result :=  1;
  End;
End;
{$ENDIF OS2}

{$IFDEF Win32}
Function AnsiCompareText(Const s1, s2: String): Integer;
Var
  Temp1, Temp2: Array[0..255] Of Char;
Begin
  AnsiCompareText:=lstrcmpi(StrPCopy(Temp1,s1)^,
                            StrPCopy(Temp2,s2)^);
End;
{$ENDIF Win32}

{$IFDEF Win32}
Function AnsiCompareStr(Const s1, s2: String): Integer;
Var
  Temp1, Temp2: Array[0..255] Of Char;
Begin
  Result := lstrcmp(StrPCopy(Temp1,s1)^, StrPCopy(Temp2,s2)^);
End;
{$ENDIF Win32}

Function IsValidIdent(Const Ident: String): Boolean;
Var
  L, N: Integer;
Begin
  L := Length(Ident);
  If L = 0 Then IsValidIdent := False
  Else
  Begin
    If Ident[1] In ['a'..'z', 'A'..'Z', '_'] Then
    Begin
      N := 2;
      While (N <= L) And (Ident[N] In ['a'..'z', 'A'..'Z', '_', '0'..'9']) Do Inc(N);
      If N > L Then IsValidIdent := True
      Else IsValidIdent := False;
    End
    Else IsValidIdent := False;
  End;
End;

Function IntToStr(Value: LongInt): String;
Begin
  Str(Value, Result);
End;

Function IntToHex(Value: LongInt; Digits: Integer): String;
Begin
  Result := '';
  Repeat
    Dec(Digits);
    Result := HexDecimals[Value And $0F] + Result;
    Value := Value Shr 4;
  Until Value = 0;
  If Digits > 0 Then
  Begin
    Move(Result[1], Result[1 + Digits], Byte(Result[0]));
    FillChar(Result[1], Digits, '0');
    Inc(Byte(Result[0]), Digits);
  End;
End;

Function HexToInt(Const S: String): LongInt;

Begin
  Result:=StrToInt(s);
End;

Function StrToInt(Const S: String): LongInt;
Var
  err: Integer;
Begin
  Val(S, Result, err);
  If err <> 0 Then FmtLoadConvertError(SInvalidInteger, [S]);
End;

Function StrToIntDef(Const S: String; Default: LongInt): LongInt;
Var
  err: Integer;
Begin
  Val(S, Result, err);
  If err <> 0 Then Result := Default;
End;

{$IFDEF OS2}
Function LoadStr(Ident: Word): String;
Var
  Buffer: cstring;
Begin
  WinLoadString(AppHandle, 0, Ident, 256, Buffer);
  Result := Buffer;
End;
{$ENDIF OS2}

{$IFDEF Win32}
Function LoadStr(Ident: Word): String;
Begin
  Result[0] := Char(LoadString(DllModule,Ident,cstring(Result[1]),254));
End;
{$ENDIF}

Function LoadTableStr(Const Table:String;Ident: Word): String;
Begin
  Result:=GetStringTableEntry(Table,Ident);
End;

Function LoadNLSStr(Ident: Word): String;

Begin
  Result:=GetStringTableEntry(GetCurrentLanguageTable,Ident);
  if Result='' then
    Result:=GetStringTableEntry('WDSIBYL_NLS_Default',Ident);
End;

Function FmtLoadTableStr(Const Table:String;Ident: Word; Const Args: Array Of Const): String;
Begin
  FmtStr(Result, LoadTableStr(Table,Ident), Args);
End;

Function FmtLoadNLSStr(Ident: Word; Const Args: Array Of Const): String;
Begin
  FmtStr(Result, LoadNLSStr(Ident), Args);
End;

Function FmtLoadStr(Ident: Word; Const Args: Array Of Const): String;
Begin
  FmtStr(Result, LoadStr(Ident), Args);
End;

{$IFDEF OS2}
Function SysErrorMessage(MsgNum: LongInt): String;
Var
  len, rc: LongWord;
  Table: PChar;
Begin
  rc := DosGetMessage(Table, 0, Result[1], 255, MsgNum, 'OSO001.MSG', len);
  If rc = 0 Then SetLength(Result, len)
  Else
  Begin
    Str(rc, Result);
    Result := 'DosGetMessage error #' + Result;
  End;
End;
{$ENDIF}

{
Procedure SetLength(Var S: String; NewLength: Byte);
Begin
  Byte(S[0]) := NewLength;
End;
}

Function Trim(Const S: String): String;
Var
  L, R: Integer;
Begin
  R := Length(S);
  While (R > 0) And (S[R] <= ' ') Do Dec(R);
  L := 1;
  While (L <= R) And (S[L] <= ' ') Do Inc(L);
  Result := Copy(S, L, R - L + 1);
End;

Function TrimLeft(Const S: String): String;
Var
  L, R: Integer;
Begin
  R := Length(S);
  L := 1;
  While (L <= R) And (S[L] <= ' ') Do Inc(L);
  Result := Copy(S, L, R - L + 1);
End;

Function TrimRight(Const S: String): String;
Var
  R: Integer;
Begin
  R := Length(S);
  While (R > 0) And (S[R] <= ' ') Do Dec(R);
  Result := Copy(S, 1, R);
End;

Function QuotedStr(Const S: String): String;
Var
  N: Integer;
Begin
  Result := #39;
  For N := 1 To Length(S) Do
  Begin
    Result := Result + S[N];
    If S[N] = #39 Then Result := Result + #39;
  End;
  Result := Result + #39;
End;

{ --- File management --- }

Function StrMatch(const iMask, iStr: string; iWild, iJoker: char): Boolean;

var poMask, lenMask: Byte;
    poStr, lenStr: Byte;
    powild : byte;

Begin
  Result:=true;
  lenMask:=Length(iMask);
  lenStr:=Length(iStr);
  powild := 0;
  poMask:=1;
  poStr:=1;
  While (poMask<=LenMask) or (poStr<=LenStr) do
    if iMask[poMask] = iWild
      then
        Begin
          powild := poMask;
          if poMask >= lenMask then exit;
          inc(poMask);
          While (iMask[poMask] <> iStr[poStr]) and (poStr<LenStr) do
            inc(poStr);
        End
      else
        Begin
          if (poMask > LenMask) or (poStr > LenStr) then begin
            result := iMask[LenMask] = iStr[LenStr];
            exit;
          end;
          if ((iMask[poMask] <> iStr[poStr]) and (iMask[poMask] <> iJoker)) then begin
            if powild > 0 then begin
              pomask := powild+1;
              While (iMask[poMask] <> iStr[poStr]) and (poStr<=LenStr) do
                inc(poStr);
              if poStr > LenStr then begin
                result := false; exit;
              end;
              continue;
            end;
            result:=false;
            exit;
          end;
          inc(poMask);
          inc(poStr);
        End;
End;

Function FileOpen(Const FileName: String; Mode: Longint): LongInt;
{$IFDEF OS2}
Const
  Action = OPEN_ACTION_OPEN_IF_EXISTS Or OPEN_ACTION_FAIL_IF_NEW;
Var
  ActionTaken, Handle: LongWord;
{$ENDIF}
{$IFDEF Win32}
Const
  Action = OPEN_EXISTING;
VAR SA:SECURITY_ATTRIBUTES;
{$ENDIF}
Var
  FileNameZ: cstring[256];
Begin
  FileNameZ := FileName;
  If Mode And ShareModes = 0 Then Mode := Mode Or fmShareDenyNone;
  {$IFDEF OS2}
  Result := - DosOpen(FileNameZ, Handle, ActionTaken, 0, 0, Action, Mode, Nil);
  If Result = NO_ERROR Then Result := Handle;
  {$ENDIF}
  {$IFDEF Win32}
  SA.nLength:=sizeof(SA);
  SA.lpSecurityDescriptor:=Nil;
  SA.bInheritHandle:=True;
  Result:=CreateFile(FileNameZ,Mode And Not 3,Mode And 3,SA,Action,
                     FILE_ATTRIBUTE_NORMAL,0);
  {$ENDIF}
End;

Function FileOpenOrCreate(Const FileName: String; Mode: Longint): LongInt;
{$IFDEF OS2}
Const
  Action = OPEN_ACTION_OPEN_IF_EXISTS Or OPEN_ACTION_CREATE_IF_NEW;
Var
  ActionTaken, Handle: LongWord;
{$ENDIF}
{$IFDEF Win32}
Const
  Action = OPEN_ALWAYS;
Var SA:SECURITY_ATTRIBUTES;
{$ENDIF}
Var
  FileNameZ: cstring[256];
Begin
  FileNameZ := FileName;
  If Mode And ShareModes = 0 Then Mode := Mode Or fmShareDenyNone;
  {$IFDEF OS2}
  Result := - DosOpen(FileNameZ, Handle, ActionTaken, 0, 0, Action, Mode, Nil);
  If Result = NO_ERROR Then Result := Handle;
  {$ENDIF}
  {$IFDEF Win32}
  SA.nLength:=sizeof(SA);
  SA.lpSecurityDescriptor:=Nil;
  SA.bInheritHandle:=True;
  Result:=CreateFile(FileNameZ,Mode And Not 3,Mode And 3,SA,Action,
                     FILE_ATTRIBUTE_NORMAL,0);
  {$ENDIF}
End;

Function FileCreateIfNew(Const FileName: String; Mode: Longint): LongInt;
{$IFDEF OS2}
Const
  Action = OPEN_ACTION_FAIL_IF_EXISTS Or OPEN_ACTION_CREATE_IF_NEW;
Var
  ActionTaken, Handle: LongWord;
{$ENDIF}
{$IFDEF Win32}
Const
  Action = CREATE_NEW;
Var SA:SECURITY_ATTRIBUTES;
{$ENDIF}
Var
  FileNameZ: cstring[256];
Begin
  FileNameZ := FileName;
  If Mode And ShareModes = 0 Then Mode := Mode Or fmShareDenyNone;
  {$IFDEF OS2}
  Result := - DosOpen(FileNameZ, Handle, ActionTaken, 0, 0, Action, Mode, Nil);
  If Result = NO_ERROR Then Result := Handle;
  {$ENDIF}
  {$IFDEF Win32}
  SA.nLength:=sizeof(SA);
  SA.lpSecurityDescriptor:=Nil;
  SA.bInheritHandle:=True;
  Result:=CreateFile(FileNameZ,Mode And Not 3,Mode And 3,SA,Action,
                     FILE_ATTRIBUTE_NORMAL,0);
  {$ENDIF}
End;

Function FileCreate(Const FileName: String): LongInt;
{$IFDEF OS2}
Const
  Action = OPEN_ACTION_REPLACE_IF_EXISTS Or OPEN_ACTION_CREATE_IF_NEW;
Var
  ActionTaken, Handle: LongWord;
{$ENDIF}
{$IFDEF Win32}
Const
  Action = CREATE_ALWAYS;
Var SA:SECURITY_ATTRIBUTES;
{$ENDIF}
Const
  Mode = fmOpenReadWrite Or fmShareExclusive;
Var
  FileNameZ: cstring[256];
Begin
  FileNameZ := FileName;
  {$IFDEF OS2}
  Result := - DosOpen(FileNameZ, Handle, ActionTaken, 0, 0, Action, Mode, Nil);
  If Result = NO_ERROR Then Result := Handle;
  {$ENDIF}
  {$IFDEF Win32}
  SA.nLength:=sizeof(SA);
  SA.lpSecurityDescriptor:=Nil;
  SA.bInheritHandle:=True;
  Result:=CreateFile(FileNameZ,Mode And Not 3,Mode And 3,SA,Action,
                     FILE_ATTRIBUTE_NORMAL,0);
  {$ENDIF}
End;

Function FileRead(Handle: LongInt; Var Buffer; Count: LongInt): LongInt;
Var
  Result: LongWord;
Begin
  {$IFDEF OS2}
  If DosRead(Handle, Buffer, Count, Result) = NO_ERROR Then FileRead := Result
  Else FileRead := -1;
  {$ENDIF}
  {$IFDEF Win32}
  If ReadFile(Handle,Buffer,Count,Result,Nil) Then FileRead := Result
  Else FileRead := -1;
  {$ENDIF}
End;

Function FileWrite(Handle: LongInt; Const Buffer; Count: LongInt): LongInt;
Var
   Result:LongWord;
Begin
  {$IFDEF OS2}
  If DosWrite(Handle, Buffer, Count, Result) = NO_ERROR Then FileWrite := Result
  Else FileWrite := -1;
  {$ENDIF}
  {$IFDEF Win32}
  If Not WriteFile(Handle,Buffer,Count,Result,Nil) Then Result := -1
  Else FileWrite := Result;
  {$ENDIF}
End;

Function FileSeek(Handle: LongInt; Offset: LongInt; Origin: Integer): LongInt;
{$IFDEF OS2}
Var
  NewPos: LongWord;
{$ENDIF}
Begin
  {$IFDEF OS2}
  If DosSetFilePtr(Handle, Offset, Origin, NewPos) = NO_ERROR Then FileSeek := NewPos
  Else FileSeek := -1;
  {$ENDIF}
  {$IFDEF Win32}
  Result:=SetFilePointer(Handle,Offset,Nil,Origin);
  {$ENDIF}
End;

Procedure FileClose(Handle: LongInt);
Begin
  {$IFDEF OS2}
  DosClose(Handle);
  {$ENDIF}
  {$IFDEF Win32}
  CloseHandle(Handle);
  {$ENDIF}
End;

Function FileLock(Handle, Offset, Range: LongInt): Boolean;
{$IFDEF OS2}
Var
  Lock, UnLock: BseDos.FileLock;
{$ENDIF}
Begin
  {$IFDEF OS2}
  Lock.LOffset := Offset;
  Lock.LRange := Range;
  UnLock.LOffset := 0;
  UnLock.LRange := 0;
  Result := (DosSetFileLocks(Handle, UnLock, Lock, LockTimeout, 0) = NO_ERROR);
  {$ENDIF}
  {$IFDEF Win32}
  Result := LockFile(Handle,Offset,0,Range,0);
  {$ENDIF}
End;

Function FileUnLock(Handle, Offset, Range: LongInt): Boolean;
{$IFDEF OS2}
Var
  Lock, UnLock: BseDos.FileLock;
{$ENDIF}
Begin
  {$IFDEF OS2}
  UnLock.LOffset := Offset;
  UnLock.LRange := Range;
  Lock.LOffset := 0;
  Lock.LRange := 0;
  Result := (DosSetFileLocks(Handle, UnLock, Lock, LockTimeout, 0) = NO_ERROR);
  {$ENDIF}
  {$IFDEF Win32}
  Result := UnlockFile(Handle,Offset,0,Range,0);
  {$ENDIF}
End;

Function FileAge(Const FileName: String): LongInt;
Var
  FileNameZ: cstring;
{$IFDEF OS2}
  Buffer: FILESTATUS3;
{$ENDIF}
{$IFDEF Win32}
  Handle:LongWord;
  LastAccess,Creation,LastWrite,Actual:FILETIME;
  date,Time:Word;
{$ENDIF}
Begin
  FileNameZ := FileName;
  {$IFDEF OS2}
  If DosQueryPathInfo(FileNameZ, FIL_STANDARD, Buffer, SizeOf(Buffer)) = NO_ERROR
    then FileAge := ({Martin0508}longword(Buffer.fdateLastWrite) Shl 16) Or Buffer.ftimeLastWrite
    else FileAge := -1;
  {$ENDIF}
  {$IFDEF Win32}
  Handle:=CreateFile(FileNameZ,GENERIC_READ,0,Nil,OPEN_EXISTING,
                     FILE_ATTRIBUTE_NORMAL,0);
  If Handle=-1 Then
  Begin
       FileAge:=-1;
       Exit;
  End;
  If Not GetFileTime(Handle,Creation,LastAccess,LastWrite) Then
  Begin
       CloseHandle(Handle);
       FileAge:=-1;
       Exit;
  End;
  CloseHandle(Handle);
  FileTimeToLocalFileTime(LastWrite,actual);
  FileTimeToDosDateTime(actual,date,Time);
  //FileAge := (date Shl 16) Or Time;
  {Martin}
  FileAge := (longint(date) Shl 16) Or Time;
  {$ENDIF}
End;

Function FileAgeCreation(Const FileName: String): LongInt;
Var
  FileNameZ: cstring;
{$IFDEF OS2}
  Buffer: FILESTATUS3;
{$ENDIF}
{$IFDEF Win32}
  Handle:LongWord;
  LastAccess,Creation,LastWrite,actual:FILETIME;
  date,Time:Word;
{$ENDIF}
Begin
  FileNameZ := FileName;
  {$IFDEF OS2}
  If DosQueryPathInfo(FileNameZ, FIL_STANDARD, Buffer, SizeOf(Buffer)) = NO_ERROR Then
    FileAgeCreation := (Buffer.fdateCreation Shl 16) Or Buffer.ftimeCreation
  Else FileAgeCreation := -1;
  {$ENDIF}
  {$IFDEF Win32}
  Handle:=CreateFile(FileNameZ,GENERIC_READ,0,Nil,OPEN_EXISTING,
                     FILE_ATTRIBUTE_NORMAL,0);
  If Handle=-1 Then
  Begin
       FileAgeCreation:=-1;
       Exit;
  End;
  If Not GetFileTime(Handle,Creation,LastAccess,LastWrite) Then
  Begin
       CloseHandle(Handle);
       FileAgeCreation:=-1;
       Exit;
  End;
  CloseHandle(Handle);
  FileTimeToLocalFileTime(Creation,actual);
  FileTimeToDosDateTime(actual,date,Time);
  {Martin}FileAgeCreation := (longint(date) Shl 16) Or Time;
  {$ENDIF}
End;

{***********************************
* get file size
*
* @param aFilename: String
* @return LongInt
***********************************}
Function FileGetSize(aFilename: String): LongInt;

var SearchRec: TSearchRec;

Begin
  Result:=0;
  if FindFirst(aFilename,faAnyFile,SearchRec)=0 then
    Begin
      RESULT := SearchRec.Size;
      FindClose(SearchRec);
    End;
End;

Function FileExists(Const FileName: String): Boolean;
Var
  SearchRec: TSearchRec;
Begin
  If FindFirst(FileName, faAnyFile, SearchRec) = 0 Then
  Begin
    FileExists := True;
    FindClose(SearchRec);
  End
  Else FileExists := False;
End;

Function PathExists(PathName: tFileName): Boolean;

Var SearchRec: TSearchRec;

Begin
  PathName:=DeleteLastPathSeparator(PathName);
  If (FindFirst(PathName, faDirectory or faMustDirectory, SearchRec) = 0)
    Then
      Begin
        Result:= True;
        FindClose(SearchRec);
      End
    Else Result := False;
End;


{Martin lf}
function ExtendedOfLongword (lw : longword) : extended;
  type
    longwordhack = record case Integer of 0 : (low, high : word); 1 : (lw : longword); end;
  var
    lwh : longwordhack;
  begin
    lwh.lw := lw;
    result := extended (65536.0) * lwh.high + lwh.low;
  end;

Function DoFindFile(Var F:TSearchRec):LongInt;

{$IFDEF WIN32}
Var
  Actual:FILETIME;
  date,time:Word;
{$ENDIF}

Begin
   {$IFDEF OS2}
   if F.OS2longfilesupport then begin
     With F.SearchRecInternL Do Begin
       F.Name := achName;
       //F.Size := cbFile;
       if F.SearchRecInternL.cbFile.high > 0 then
         f.Size := 1 {1 bytes = error}
       else
         f.Size:=F.SearchRecInternL.cbFile.low;
       {longlong: low : longword; high : longint;}
       f.floatSize := extended(65536.0) * 65536.0 * F.SearchRecInternL.cbFile.high
                    + ExtendedOfLongword (F.SearchRecInternL.cbFile.low);
       F.Attr := attrFile;
       F.Time := fdateLastWrite;
       F.Time := F.Time Shl 16 + ftimeLastWrite;
     End;
   end
   else begin
     With F.SearchRecIntern Do Begin
       F.Name := achName;
       F.Size := cbFile;
       F.Attr := attrFile;
       F.Time := fdateLastWrite;
       F.Time := F.Time Shl 16 + ftimeLastWrite;
     End;
   end;
   Result:=0;
   {$ENDIF}
   {$IFDEF Win32}
   While F.SearchRecIntern.dwFileAttributes And F.InternalAttr=0 Do
   Begin
       If FindNextFile(F.HDir,F.SearchRecIntern)=False Then
       Begin
           Result:=-GetLastError;
           WinBase.FindClose(F.HDir);
           Exit;
       End;
   End;

   FileTimeToLocalFileTime(F.SearchRecIntern.ftLastWriteTime,Actual);
   FileTimeToDosDateTime(Actual,date,time);
   {Martin}F.Time:=(longword(date) Shl 16) Or Time;
   F.Size:=F.SearchRecIntern.nFileSizeLow;
   {longlong: low : longword; high : longint;}
   f.floatSize := extended(65536.0) * 65536.0 * F.SearchRecIntern.nFileSizeHigh
                + ExtendedOfLongword (F.SearchRecIntern.nFileSizeLow);

   F.Attr:=F.SearchRecIntern.dwFileAttributes;
   F.Name:=cstring(F.SearchRecIntern.cFileName);
   Result := 0;
   {$ENDIF}
End;

{Martin lf   a lot of changes in FindFirst, FindNext}
Function FindFirst(Const Path: String; Attr: LongWord; Var F: TSearchRec): LongInt;

{$IFDEF OS2}
Var
    Result, Count: LongWord;

{$ENDIF}

Var
  PathZ: cstring;
Begin
  PathZ := Path;
  {$IFDEF OS2}
  F.HDir := HDIR_CREATE;
  Count := 1;
  //Result := DosFindFirst(PathZ, F.HDir, Attr, OS2SearchRec, Size, Count, FIL_STANDARD);
  {Martin lf}
  result:=DosFindFirst(PathZ,F.Hdir,Attr,F.SearchRecInternL,sizeof(FILEFINDBUF3L),count,FIL_STANDARDL);
  F.OS2longfilesupport := Result = NO_ERROR;//<> ERROR_INVALID_PARAMETER;
  {On old OS/2 systems, it should return 87 = ERROR_INVALID_PARAMETER, but it does return 124. ????}
  if not F.OS2longfilesupport then begin
    {perhaps an old OS/2 system is here without long file support! Warp4 < FP15,
     so run the old structure,
     or no files are here}
    result:=DosFindFirst(PathZ,F.Hdir,Attr,F.SearchRecIntern,sizeof(FILEFINDBUF3),count,FIL_STANDARD);
  end;
  If Result = NO_ERROR Then
  Begin
       FindFirst := DoFindFile(F);
  End
  Else FindFirst := -Result;
  {$ENDIF}
  {$IFDEF Win32}
  F.InternalAttr:=Attr;
  F.HDir:=FindFirstFile(PathZ,F.SearchRecIntern);
  If F.HDir=INVALID_HANDLE_VALUE Then
  Begin
       FindFirst:=-GetLastError;
       Exit;
  End;

  FindFirst:=DoFindFile(F);
  {$ENDIF}
End;

Function FindNext(Var F: TSearchRec): LongInt;
{$IFDEF OS2}
Var
    Result: Integer;
    Count: LongWord;
{$ENDIF}

Begin
  {$IFDEF OS2}
  Count := 1;
  if F.OS2longfilesupport then
    Result := DosFindNext (F.HDir, F.SearchrecInternL, sizeof(FILEFINDBUF3L), Count)
  else
    Result := DosFindNext (F.HDir, F.SearchrecIntern, sizeof(FILEFINDBUF3), Count);
  If Result = NO_ERROR Then
  Begin
    FindNext := DoFindFile(F);
  End
  Else FindNext := -Result;
  {$ENDIF}
  {$IFDEF Win32}
  If FindNextFile(F.HDir,F.SearchRecIntern)=False Then
  Begin
       Result:=-GetLastError;
       WinBase.FindClose(F.HDir);
       Exit;
  End;

  Result:=DoFindFile(F);
  {$ENDIF}
End;

Procedure FindClose(Var F: TSearchRec);
Begin
  {$IFDEF OS2}
  DosFindClose(F.HDir);
  {$ENDIF}
  {$IFDEF Win32}
  WinBase.FindClose(F.HDir);
  {$ENDIF}
End;

Function FileGetDate(Handle: LongInt): LongInt;
{$IFDEF OS2}
Var
  Buffer: FILESTATUS3;
{$ENDIF}
{$IFDEF Win32}
Var
  LastAccess,creation,LastWrite,actual:FILETIME;
  date,Time:Word;
{$ENDIF}
Begin
  {$IFDEF OS2}
  If DosQueryFileInfo(Handle, FIL_STANDARD, Buffer, SizeOf(Buffer)) = NO_ERROR Then
    FileGetDate := (Buffer.fdateLastWrite Shl 16) Or Buffer.ftimeLastWrite
  Else FileGetDate := -1;
  {$ENDIF}
  {$IFDEF Win32}
  If Not GetFileTime(Handle,creation,LastAccess,LastWrite) Then
  Begin
       CloseHandle(Handle);
       FileGetDate:=-1;
       Exit;
  End;
  CloseHandle(Handle);
  FileTimeToLocalFileTime(LastWrite,actual);
  FileTimeToDosDateTime(actual,date,Time);
  {Martin}FileGetDate := (longint(date) Shl 16) Or Time;
  {$ENDIF}
End;

Procedure FileSetDate(Handle: Integer; Age: LongInt);
{$IFDEF OS2}
Var
  Buffer: FILESTATUS3;
{$ENDIF}
{$IFDEF Win32}
Var
   date,Time:Word;
   LastWrite:FILETIME;
{$ENDIF}
Begin
  {$IFDEF OS2}
  FillChar(Buffer, SizeOf(Buffer), 0);
  Buffer.ftimeLastWrite := Age And $FFFF;
  Buffer.fdateLastWrite := Age Shr 16;
  DosSetFileInfo(Handle, FIL_STANDARD, Buffer, SizeOf(Buffer));
  {$ENDIF}
  {$IFDEF Win32}
  date:= Age Shr 16;
  Time:= Age And $FFFF;
  DosDateTimeToFileTime(date,Time,LastWrite);

  WinBase.SetFileTime(Handle,Nil,Nil,LastWrite);
  {$ENDIF}
End;

Function FileGetAttr(Const FileName: String): LongInt;
{$IFDEF OS2}
Var
  Buffer: FILESTATUS3;
{$ENDIF}
Var
  FileNameZ: cstring;
Begin
  FileNameZ := FileName;
  {$IFDEF OS2}
  Result := - DosQueryPathInfo(FileNameZ, FIL_STANDARD, Buffer, SizeOf(Buffer));
  If Result = 0 Then Result := Buffer.attrFile;
  {$ENDIF}
  {$IFDEF Win32}
  Result := GetFileAttributes(FileNameZ);
  {$ENDIF}
End;

Function FileSetAttr(Const FileName: String; Attr: Integer): Integer;
{$IFDEF OS2}
Var
  Buffer: FILESTATUS3;
{$ENDIF}
Var
  FileNameZ: cstring;
Begin
  FileNameZ := FileName;
  {$IFDEF OS2}
  FillChar(Buffer, SizeOf(Buffer), 0);
  Buffer.attrFile := Attr;
  Result := - DosSetPathInfo(FileNameZ, FIL_STANDARD, Buffer, SizeOf(Buffer), 0);
  {$ENDIF}
  {$IFDEF Win32}
  If SetFileAttributes(FileNameZ,Attr) Then Result:=0
  Else Result := -GetLastError;
  {$ENDIF}
End;

Function CopyFile(Const SourceName, DestName: String): Boolean;
{overwrites without query!}
Var
  SourceZ, DestZ: cstring;
Begin
  SourceZ := SourceName;
  DestZ := DestName;
  {$IFDEF OS2}
  Result := (DosCopy(SourceZ, DestZ, DCPY_EXISTING) = NO_ERROR);
  {$ENDIF}
  {$IFDEF Win32}
  Result := WinBase.CopyFile(SourceZ, DestZ, FALSE(*True*){Martin0508});
  {$ENDIF}
End;

Function DeleteFile(Const FileName: String): Boolean;
Var
  FileNameZ: cstring;
Begin
  FileNameZ := FileName;
  {$IFDEF OS2}
  Result := (DosDelete(FileNameZ) = NO_ERROR);
  {$ENDIF}
  {$IFDEF Win32}
  Result := WinBase.DeleteFile(FileNameZ);
  {$ENDIF}
End;

Function RenameFile(Const OldName, NewName: String): Boolean;
Var
  OldNameZ, NewNameZ: cstring;
Begin
  OldNameZ := OldName;
  NewNameZ := NewName;
  {$IFDEF OS2}
  Result := (DosMove(OldNameZ, NewNameZ) = NO_ERROR);
  {$ENDIF}
  {$IFDEF Win32}
  Result := MoveFile(OldNameZ, NewNameZ);
  {$ENDIF}
End;

Function ChangeFileExt(Const FileName, extension: String): String;

Var P: Integer;
Begin
  P := Length(FileName);
  While (P > 0) And (FileName[P] <> '.') Do
    Dec(P);
  If P = 0
    Then Result := FileName + extension
    Else Result := Copy(FileName, 1, P - 1) + extension;
End;

Function ExtractFileDrive(Const FileName: tFileName) : tFileName;

Var P: Integer;

Begin
  P := Length(FileName);
  While (P > 0) And (FileName[P] <> DriveSeparator) Do
    Dec(P);
  Result := Copy(FileName, 1, P);
End;

Function ExtractFilePath(Const FileName: String): String;

Var P: Integer;

Begin
  P := Length(FileName);
  While (P > 0) And (FileName[P] <> DriveSeparator) And (FileName[P] <> PathSeparator) Do
    Dec(P);
  Result := Copy(FileName, 1, P);
End;

Function ExtractFileName(Const FileName: String): String;
Var
  P: Integer;
Begin
  P := Length(FileName);
  While (P > 0) And (FileName[P] <> DriveSeparator) And (FileName[P] <> PathSeparator) Do
    Dec(P);
  Result := Copy(FileName, P + 1, 255);
End;

Function ExtractFileExt(Const FileName: String): String;
Var
  P: Integer;
Begin
  P := Length(FileName);
  While (P > 0) And (FileName[P] <> '.') Do
    Dec(P);
  If P = 0
    Then Result := ''
    Else Result := Copy(FileName, P, 255);
End;

Function ConcatFileName(Const pathname, FileName: String): String;
Begin
  If (pathname = '') Or (FileName = '') Or
     (pathname[Length(pathname)] In [PathSeparator, DriveSeparator])
    Then Result := pathname + FileName
    Else Result := pathname + PathSeparator + FileName;
End;

Function ExpandPath(pathname, FileName:String):String;
Var  I,P:Byte;
     S:String;
     t:Integer;
Label L,l2;
Begin
     // normalize directory name
     If pathname[Length(pathname)] = PathSeparator Then dec(pathname[0]);

     // multiple file names separated by semicolon
     t := pos(';',FileName);
     If t <> 0 Then
     Begin
          s := FileName;
          delete(s,1,t);
          FileName[0] := chr(t);
          FileName := FileName + ExpandPath(pathname,s);
     End;


     S := pathname;
     If Length(S) = 3 Then
       If S[2] = DriveSeparator Then
         If S[3] In ['\','/'] Then Dec(S[0]);

     If (Pos('\',FileName) = 1) Or (Pos('/',FileName) = 1)
     Then FileName := Copy(S,1,2) + FileName;

     If (Length(FileName) >= 2) And (FileName[2] = DriveSeparator) Then
     Begin
          S := Copy(FileName,1,2);
          Delete(FileName,1,2);
     End;
     If Not (FileName[1] In ['\','/']) Then FileName := '\'+ FileName;

     Repeat
           If ((Pos('\..',FileName) = 1) Or (Pos('/..',FileName) = 1)) Then
           Begin
                If (Length(FileName) >= 4) And (Not (FileName[4] In ['\','/'])) Then Goto l2;
                Delete(FileName,1,3);
                For I := Length(S) DownTo 3 Do
                Begin
                     If S[I] = DriveSeparator Then break;
                     Dec(S[0]);
                     If S[I] In ['\','/'] Then break;
                End;
           End
           Else
           If ((Pos('\.',FileName) = 1) Or (Pos('/.',FileName) =1)) Then
           Begin
                If (Length(FileName) >= 3) And (Not (FileName[3] In ['\','/'])) Then Goto l2;
                Delete(FileName,1,2);
           End
           Else
           If ((Pos('\',FileName) = 1) Or (Pos('/',FileName) = 1)) Then
           Begin
l2:
                Delete(FileName,1,1);
                S := S + '\';
           End
           Else
           Begin
L:
                P := Pos('\',FileName);
                If P = 0 Then P := Pos('/',FileName);
                If P > 0 Then
                Begin
                     S := S + Copy(FileName,1,P-1);
                     Delete(FileName,1,P-1);
                End
                Else
                Begin
                     S := S + FileName;
                     FileName := '';
                End;
           End;
     Until FileName = '';
     If Length(S) = 2 Then S := S +'\';

     Result := S;
End;

Function ExpandFileName(FileName: String): String;
{$IFDEF OS2}
Const
  Level = FIL_QUERYFULLNAME;
Var
  Buffer:CString;
{$ENDIF}
{$IFDEF Win32}
Var
   TempName : PChar;
{$ENDIF}
Var
  FileNameZ: cstring;
Begin
  FileNameZ := FileName;
  {$IFDEF OS2}
  If DosQueryPathInfo(FileNameZ, Level, Buffer, SizeOf(Buffer)) = NO_ERROR
    Then Result := Buffer
    Else
      Begin
        If ((length(FileName)=2)And(FileName[2]=':'))
          Then
            Begin
              {$I-}
              GetDir(ord(Upcase(FileName[1]))-64,Result);
              {$I+}
              If IoResult<>0 Then Result:='';
            End
        Else Result:='';
      End;
  {$ENDIF}
  {$IFDEF Win32}
  Result[0]:=Chr(GetFullPathName(FileNameZ,256,cstring(Result[1]),TempName));
  {$ENDIF}
End;


Function EditFileName(Const Name, edit: String): String;
{$IFDEF OS2}
Var
  Buffer: cstring;
{$ENDIF}        
Var
  NameZ, EditZ: cstring;
Begin
  NameZ := Name;
  EditZ := edit;
  {$IFDEF OS2}
  If DosEditName(1, NameZ, EditZ, Buffer, 256) = 0 Then Result := Buffer
  Else Result := '';
  {$ENDIF}
  {$IFDEF Win32}
  Result := '';  //Not supported
  {$ENDIF}
End;

Function FileSearch(Const Name : String; DirList: AnsiString): tFileName;
{$IFDEF OS2}
Const
  Flags = SEARCH_IGNORENETERRS;
{$ENDIF}
{$IFDEF Win32}
Var Temp    : PChar;
    DirListZ: cString;
{$ENDIF}
Var NameZ, Buffer: Cstring;

Begin
  NameZ := Name;
  {$IFDEF OS2}
  If DosSearchPath(Flags, DirList, NameZ, Buffer, SizeOf(Buffer)) = NO_ERROR
    then Result := Buffer
    else Result := '';
  {$ENDIF}
  {$IFDEF Win32}
  DirListZ:=DirList;
  If SearchPath(DirListZ,Name,Nil,256,Buffer,Temp)=0
    Then Result:=''
    Else Result:=Buffer;
  {$ENDIF}
End;

Function GetTempFileName : tFileName;
Var  Hour,Minute,Second,Sec100:Word;
     S,dir:String;
Begin
//  If GetTime(Hour,Minute,Second,Sec100) = 0 Then
//  Begin
//       S := 'tmp'+ {tostr(Minute)+}tostr(Second)+tostr(Sec100) +'.tmp';
//  End
//  Else S := 'tmp0001.tmp';
  DecodeTime(now, Hour, Minute, Second, Sec100);
  S := 'tmp'+ {tostr(Minute)+}tostr(Second)+tostr(Sec100) +'.tmp';
  dir := getEnv('TMP');
  If dir = '' Then dir := GetEnv('TEMP');
  If dir = '' Then
  Begin
       {$I-}
       GetDir(0,dir);
       {$I+}
  End;
  If dir[Length(dir)] <> '\' Then dir := dir + '\';
  Result := dir + S;
End;

Procedure DelTree(Const PathName : tFileName);

var FileSearch : tSearchRec;
    inResult   : LongInt;

Begin
  if PathExists(PathName) then
    Begin
      inResult:=FindFirst(PathName+PathSeparator+'*.*', faAnyFile, FileSearch);
      while inResult=0 do
        Begin
          if (FileSearch.Attr and faDirectory) = faDirectory
            then
              Begin
                if FileSearch.Name[1]<>'.' then
                  Deltree(PathName+PathSeparator+FileSearch.Name);
              End
            else
              DeleteFile(PathName+PathSeparator+FileSearch.Name);
          inResult:=FindNext(FileSearch);
        end;
      FindClose(FileSearch);
      RmDir(PathName);
    End;
End;

Function AddPathSeparator(Const PathName : tFileName) : tFileName;

Begin
  if PathName[length(PathName)]=PathSeparator
    then Result:=PathName
    else Result:=PathName+PathSeparator;
End;

Function DeleteLastPathSeparator(Const PathName : tFileName) : tFileName;

Begin
  if PathName[length(PathName)]=PathSeparator
    then Result:=Copy(PathName,1,length(PathName)-1)
    else Result:=PathName;
End;


Procedure DelPath(Const PathName, Mask : tFileName);

var FileSearch : tSearchRec;
    inResult   : LongInt;

Begin
  if PathExists(DeleteLastPathSeparator(PathName)) then
    Begin
      inResult:=FindFirst(PathName+PathSeparator+Mask, faAnyFile, FileSearch);
      while inResult=0 do
        Begin
          DeleteFile(PathName+PathSeparator+FileSearch.Name);
          inResult:=FindNext(FileSearch);
        End;
    End;
End;

function GetBootDisk: Byte;

{$IFDEF OS2}
var drvltr : LongWord; { CString;}
{$ENDIF}

begin
  {$IFDEF OS2}
  if DosQuerySysInfo(QSV_BOOT_DRIVE,
                     QSV_BOOT_DRIVE,
                     drvltr,
                     sizeOf(drvLtr)) = NO_ERROR
    then Result:=drvLtr
    else Result:=0;
  {$ENDIF}
  {$IFDEF WIN32}
  Result:=3; //C:
  {$ENDIF}
end;

{Martin
DiskFree und Disksize haben sowohl bei OS/2 als auch bei Windows nur bei < 2 GB Partitionsgr”แe funktioniert,
geht jetzt bei beiden OS wieder einwandfrei

DiskFree and Disksize did only work together with max. 2 GB partitions, both OS/2 and Windows were envolved.
Now all works fine again.
}

Function DiskFree(Drive: Byte): extended;
{$IFDEF OS2}
Var
  Buffer: FSALLOCATE;
{$ENDIF}
{$IFDEF Win32}
Var
  C : cstring;
  //S:LongWord;
  //Sec,clust,freeclust:LongWord;
  ThreadFree, Space, Free : ULARGE_INTEGER;
{$ENDIF}
Begin
  {$IFDEF OS2}
  If DosQueryFSInfo(Drive, FSIL_ALLOC, Buffer, SizeOf(Buffer)) = NO_ERROR Then
    With Buffer Do Result := 1.0 * cUnitAvail * cSectorUnit * cbSector{=512}
  Else Result := -1.0;
  {$ENDIF}
  {$IFDEF Win32}
  If Drive=0 Then
  Begin
       If Not GetDiskFreeSpaceEx(Nil,ThreadFree, Space, Free) Then
       Begin
            Result:=-1.0;
            Exit;
       End;
  End
  Else
  Begin
       C:=Chr(Ord('A')+(Drive-1))+':\';
       If Not GetDiskFreeSpaceEx(C,ThreadFree, Space, Free) Then
       Begin
            Result:=-1.0;
            Exit;
       End;
  End;
  //Result:= 1.0 * S*Sec*freeclust;
  {Martin: Sibyl Compiler Bug umschifft; Longword Werte > maxlongint werden als longint weiterverarbeitet}
  with Free do Result := 1.0*lo(Lowpart) + 1.0*maxword*hi(Lowpart)
                       + 1.0*lo(Highpart)*maxword*maxword + 1.0*hi(Highpart)*maxword*maxword*maxword;
  {$ENDIF}
End;

Function DiskSize(Drive: Byte): extended;
{$IFDEF OS2}
Var
  Buffer: FSALLOCATE;
{$ENDIF}
{$IFDEF Win32}
Var
  C : cstring;
  //S:LongWord;
  //Sec,clust,freeclust:LongWord;
  ThreadFree, Space, Free : ULARGE_INTEGER;
{$ENDIF}
Begin
  {$IFDEF OS2}
  If DosQueryFSInfo(Drive, FSIL_ALLOC, Buffer, SizeOf(Buffer)) = NO_ERROR Then
    With Buffer Do Result := 1.0 * cUnit * cSectorUnit * cbSector
  Else Result := -1.0;
  {$ENDIF}
  {$IFDEF Win32}
  If Drive=0 Then
  Begin
       If Not GetDiskFreeSpaceEx(Nil,ThreadFree, Space, Free) Then
       Begin
            Result:=-1.0;
            Exit;
       End;
  End
  Else
  Begin
       C:=Chr(Ord('A')+(Drive-1))+':\';
       If Not GetDiskFreeSpaceEx(C,ThreadFree, Space, Free) Then
       Begin
            Result:=-1.0;
            Exit;
       End;
  End;
  //Result:= 1.0 * S*Sec*clust;
  with Space do Result := 1.0*lo(Lowpart) + 1.0*maxword*hi(Lowpart)
                        + 1.0*lo(Highpart)*maxword*maxword + 1.0*hi(Highpart)*maxword*maxword*maxword;
  {$ENDIF}
End;

Function FileDateToDateTime(FileDate: LongInt): TDateTime;
Var
  Day, Month, Year, Hour, Min, Sec: Word;
Begin
  Sec      := (FileDate And 31) Shl 1;
  FileDate := FileDate Shr 5;
  Min      := FileDate And 63;
  FileDate := FileDate Shr 6;
  Hour     := FileDate And 31;
  FileDate := FileDate Shr 5;

  Day      := FileDate And 31;
  FileDate := FileDate Shr 5;
  Month    := FileDate And 15;
  FileDate := FileDate Shr 4;
  Year     := 1980 + (FileDate And 127);

  Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Min, Sec, 0);
End;

Function DateTimeToFileDate(DateTime: TDateTime): LongInt;
Var
  Day, Month, Year, Hour, Min, Sec, MSec: Word;
  FileDate, FILETIME: LongInt;
Begin
  DecodeDate(DateTime, Year, Month, Day);
  DecodeTime(DateTime, Hour, Min, Sec, MSec);

  FileDate := Year - 1980;
  FileDate := (FileDate Shl 4) Or Month;
  FileDate := (FileDate Shl 5) Or Day;

  FILETIME := Hour;
  FILETIME := (FILETIME Shl 6) Or Min;
  FILETIME := (FILETIME Shl 5) Or (Sec Div 2);

  Result := (FileDate Shl 16) Or FILETIME;
End;

{ --- PChar Handling --- }

Function StrLen(Str:PChar): Cardinal;
Begin
  Asm
    MOV       EDI, Str
    CALLN32   !StringLength
    MOV       Result, EAX
  End;
End;

Function StrEnd(Str:PChar):PChar;
Begin
  Asm
    MOV       EDI, Str
    CALLN32   !StringLength
    MOV       Result, EDI
  End;
End;

Function StrMove(Dest, Source: PChar; Count: Cardinal): PChar;
Begin
  If (Source = Nil) Or (Dest = Nil) Or (Count = 0) Then Result := Nil
  Else
  Begin
    Move(Source^, Dest^, Count);
    Result := Dest;
  End;
End;

Function StrCopy(Dest, Source:PChar):PChar;
Begin
  Asm
    MOV       ESI, Source
    MOV       EDI, Dest
    MOV       ECX, $FFFFFFFF
    CALLN32   !StringCopy
    MOV       EAX, Dest
    MOV       Result, EAX
  End;
End;

Function StrECopy(Dest, Source:PChar):PChar;
Begin
  Asm
    MOV       ESI, Source
    MOV       EDI, Dest
    MOV       ECX, $FFFFFFFF
    CALLN32   !StringCopy
    MOV       Result, EDI
  End;
End;

Function StrLCopy(Dest, Source:PChar; MaxLen: Cardinal):PChar;
Begin
  Asm
    MOV       ESI, Source
    MOV       EDI, Dest
    MOV       ECX, MaxLen
    CALLN32   !StringCopy
    MOV       EAX, Dest
    MOV       Result, EAX
  End;
End;

Function StrPCopy(Dest: PChar; Const Source: String): PChar;
Begin
  Asm
    MOV       EDI, Dest
    MOV       ESI, Source
    Xor       ECX, ECX
    MOV       CL, [ESI]
    Inc       ESI
    CALLN32   !StringCopy
    MOV       EAX, Dest
    MOV       Result, EAX
  End;
End;

Function StrPLCopy(Dest: PChar; Const Source: String; MaxLen: Cardinal): PChar;
Begin
  Asm
    MOV       EDI, Dest
    MOV       ESI, Source
    Xor       ECX, ECX
    MOV       CL, [ESI]
    Inc       ESI
    CMP       ECX, MaxLen
    JLE       StrPLCopy_1
    MOV       ECX, MaxLen

    StrPLCopy_1:

    CALLN32   !StringCopy
    MOV       EAX, Dest
    MOV       Result, EAX
  End;
End;

Function StrACopy(Dest: PChar; Const Source: AnsiString): PChar;

Begin
  Result:=StrALCopy(Dest, Source, MAXLONGWORD);
End;

Function StrALCopy(Dest: PChar; Const Source: AnsiString; MaxLen: Cardinal): PChar;

Var I,L,M : LongWord;

Begin
  L:=length(Source);
  M:=MaxLen;
  if L<M then M:=L;
  for I:=1 to M do
    Dest^[I-1]:=Source[I];
  Dest[I]:=#00;
  Result:=Dest;
End;

Function StrCat(Dest, Source: PChar): PChar;
Begin
  Asm
    MOV       EDI, Dest
    MOV       ESI, Source
    CALLN32   !StringLength
    MOV       ECX, $FFFFFFFF
    CALLN32   !StringCopy
    MOV       EAX, Dest
    MOV       Result, EAX
  End;
End;

Function StrLCat(Dest, Source: PChar; MaxLen: Cardinal): PChar;
Begin
  Asm
    MOV       EDI, Dest
    MOV       ESI, Source
    CALLN32   !StringLength
    MOV       ECX, MaxLen
    SUB       ECX, EAX
    JLE       StrLCat_1
    CALLN32   !StringCopy

    StrLCat_1:

    MOV       EAX, Dest
    MOV       Result, EAX
  End;
End;

Function StrComp(Str1, Str2: PChar): Integer;
Begin
  Asm
    MOV        EDI, Str1
    CALLN32    !StringLength
    MOV        ECX, EAX
    MOV        ESI, Str1
    MOV        EDI, Str2
    CALLN32    !StringCompare
    MOV        Result, EAX
  End;
End;

Function StrLComp(Str1, Str2: PChar; MaxLen: Cardinal): Integer;
Begin
  Asm
    MOV        EDI, Str1
    MOV        ECX, MaxLen
    MOV        EBX, ECX
    XOR        EAX, EAX
    CLD
    REPNZ      SCASB
    SUB        EBX, ECX
    MOV        ECX, EBX
    MOV        ESI, Str1
    MOV        EDI, Str2
    CALLN32    !StringCompare
    MOV        Result, EAX
  End;
End;

Function StrIComp(Str1, Str2: PChar): Integer;
Begin
  Asm
    MOV        EDI, Str1
    CALLN32    !StringLength
    MOV        ECX, EAX
    MOV        ESI, Str1
    MOV        EDI, Str2
    CALLN32    !StringICompare
    MOV        Result, EAX
  End;
End;

Function StrLIComp(Str1, Str2: PChar; MaxLen: Cardinal): Integer;
Begin
  Asm
    MOV        EDI, Str1
    MOV        ECX, MaxLen
    MOV        EBX, ECX
    XOR        EAX, EAX
    CLD
    REPNZ      SCASB
    SUB        EBX, ECX
    MOV        ECX, EBX
    MOV        ESI, Str1
    MOV        EDI, Str2
    CALLN32    !StringICompare
    MOV        Result, EAX
  End;
End;

Function StrScan(Str: PChar; Chr: Char): PChar;
Begin
  Asm
    MOV        EDI, Str
    CALLN32    !StringLength
    INC        EAX
    MOV        ECX, EAX
    XOR        EBX, EBX
    MOV        AL, Chr
    MOV        EDI, Str
    CLD
    REPNZ      SCASB
    DEC        EDI
    CMP        AL, [EDI]
    JNE        !StrScan_1
    MOV        EBX, EDI

    !StrScan_1:

    MOV        Result, EBX
  End;
End;


FUNCTION StrScanN(Str:PChar; Chr : Char):LONGINT;
{returns -1 IF Chr is not inside of Str, Otherwise position}

Var Len : Cardinal;

BEGIN
  Len:=StrLen(Str);
  if Len=0
    then Result:=-1
    else
      Begin
        Result:=0;
        While (str^[Result]<>Chr) and (Result<=Len) do
          inc(Result);
        if Result>Len then Result:=-1  { Laenge ueberschritten }
      End;
End;

Function StrRScan(Str: PChar; Chr: Char): PChar;
Begin
  Asm
    MOV        EDI, Str
    CALLN32    !StringLength
    INC        EAX
    MOV        ECX, EAX
    XOR        EBX, EBX
    MOV        AL, Chr
    STD
    REPNZ      SCASB
    INC        EDI
    CMP        AL, [EDI]
    JNE        !StrRScan_1
    MOV        EBX, EDI

    !StrRScan_1:

    CLD
    MOV        Result, EBX
  End;
End;

Function StrPos(Str, SubStr: PChar): PChar;
Begin
  Asm
    MOV       EDI, SubStr
    CALLN32   !StringLength
    CMP       EAX, 0
    JE        !ErrOutStrPos

    MOV       EDX, EAX
    MOV       EDI, Str
    CALLN32   !StringLength
    CMP       EAX, 0
    JE        !ErrOutStrPos
    SUB       EAX, EDX
    JB        !ErrOutStrPos
    MOV       EDI, Str

    !1:

    MOV       ESI, SubStr
    CLD
    LODSB
    REPNE     SCASB
    JNE       !ErrOutStrPos;
    MOV       EAX, ECX
    PUSH      EDI
    MOV       ECX, EDX
    DEC       ECX
    REPE      CMPSB
    MOV       ECX, EAX
    POP       EDI
    JNE       !1
    MOV       EAX, EDI
    DEC       EAX
    JMP       !out

    !ErrOutStrPos:

    XOR EAX,EAX

    !out:

    MOV Result, EAX
  End;
End;


Function StrPosN(Str, SubStr: PChar) : LongInt;

Begin
  Asm
    MOV       EDI, SubStr       // Laenge von Substr berechnen
    CALLN32    !StringLength
    CMP        EAX,0            // EAX = 0   (Im EAX steht das Ergebnis von !StringLength)
    JE         !ErrOutPos       //   Funktion beenden
    MOV        EDX,EAX          // Laenge von SubStr in EDX

    MOV        EDI, Str         // Laenge von Str berechnen
    CALLN32    !StringLength
    CMP        EAX,0
    JE         !ErrOutPos


    SUB        EAX,EDX
    JB         !ErrOutPos
    MOV        EDI,Str
!1_1:
    MOV        ESI,SubStr
    CLD
    LODSB
    REPNE
    SCASB
    JNE        !ErrOutPos
    MOV        EAX,ECX

    PUSH       EDI
    MOV        ECX,EDX  //Lnge SubStr nach ECX
    DEC        ECX
    REPE
    CMPSB
    MOV        ECX,EAX
    POP        EDI
    JNE        !1_1

    SUB        EDI,Str
    MOV        EAX,EDI
    DEC        EAX
    JMP        !out_1
!ErrOutPos:
    MOV        EAX,$0FFFFFFFF
!Out_1:
    MOV        Result,EAX
  END;
END;

Function StrLower(Str: PChar): PChar;
Begin
  Asm
    CLD
    MOV       ESI, Str

    !StringLower1:

    LODSB
    OR        AL, AL
    JE        !OutStrLower

    CMP       AL, 'A'
    JB        !StringLower1
    CMP       AL, 'Z'
    JA        !StringLower1
    Or        AL, 32
    MOV       [ESI-1], AL
    JMP       !StringLower1

    !OutStrLower:

    MOV        EAX, Str
    MOV        Result, EAX
  End;
End;

Function StrUpper(Str: PChar): PChar;
Begin
  Asm
    CLD
    MOV       ESI, Str

    !StringUpper_Loop:

    LODSB
    OR        AL, AL
    JE        !OutStrUpper

    CMP       AL, 'a'
    JB        !StringUpper_Loop
    CMP       AL, 'z'
    JA        !StringUpper_Loop
    And       AL, $DF
    MOV       [ESI-1], AL
    JMP       !StringUpper_Loop

    !OutStrUpper:

    MOV        EAX, Str
    MOV        Result, EAX
  End;
End;

Function StrPas(Str: PChar): String;
Begin
  Result := Str^;
End;

Function StrAlloc(Size: Cardinal): PChar;
Type
  PLong = ^LongInt;
Var
  P: PChar;
Begin
  GetMem(P, Size + 4);
  PLong(P)^ := Size + 4;
  Inc(P, 4);
  StrAlloc := P;
End;

Function StrBufSize(Str: PChar): Cardinal;
Type
  PLong = ^LongInt;
Begin
  Dec(Str, 4);
  StrBufSize := PLong(Str)^ - 4;
End;

Function StrNew(Str: PChar): PChar;
Var
  Size: LongInt;
Begin
  If Str = Nil Then StrNew := Nil
  Else
  Begin
    Size := StrLen(Str) + 1;
    StrNew := StrMove(StrAlloc(Size), Str, Size);
  End;
End;

Procedure StrDispose(Str: PChar);
Type
  PLong = ^LongInt;
Begin
  If Str <> Nil Then
    If Str <> NullStr Then
    Begin
      Dec(Str, 4);
      FreeMem(Str, PLong(Str)^);
    End;
End;

{ --- String formatting --- }

{$HINTS OFF}
Function FormatBuf(Var Buffer; BufLen: Cardinal; Const format; FmtLen: Cardinal; Const Args: Array Of Const): Cardinal;
Var
  { format And Result buffers }

  FmtPos, OldFmtPos, BufPos, ArgPos: LongInt;
  Buf: cstring Absolute Buffer;
  Fmt: cstring Absolute format;

  { argument Buffer }

  VArgs: Array[0..1023] Of TVarRec Absolute Args;

  { Workaround For High() problem }

  High_Args: LongInt;

  { format Details }

  Index, Width, Precision: LongInt;
  LeftAlign: Boolean;
  ArgType: Char;

  { temporary variables }

  C : Char;
  P : Pointer;
  E : Extended;
  Pnt,M:LongInt;
  L : LongInt;
  S : String[80];
  Po: Integer;

  { Raise Exception: format And argument don't match }

  Procedure IllegalArg;
  Begin
    FmtLoadConvertError(SInvalidFormat, [ArgType]);
  End;

  { Raise Exception: out Of arguments }

  Procedure OutOfArgs;
  Begin
    FmtLoadConvertError(SArgumentMissing, [ArgType]);
  End;

  { Get an argument from the Open Array. If the
    Type Is unexpected, Raise an Exception. }

  Function GetIntegerArg: LongInt;
  Begin
    If ArgPos > High_Args Then OutOfArgs;
    If VArgs[ArgPos].VType <> vtInteger Then IllegalArg;
    Result := VArgs[ArgPos].VInteger;
    Inc(ArgPos);
  End;

  Function GetExtendedArg: Extended;
  Begin
    If ArgPos > High_Args Then OutOfArgs;
    If VArgs[ArgPos].VType <> vtExtended
    then begin
           If VArgs[ArgPos].VType <> vtInteger Then IllegalArg;
           Result := VArgs[ArgPos].VInteger;
         end
    else Result := VArgs[ArgPos].VExtended^;
    Inc(ArgPos);
  End;

  Function GetPointerArg: Pointer;
  Begin
    If ArgPos > High_Args Then OutOfArgs;
    If VArgs[ArgPos].VType <> vtPointer Then IllegalArg;
    Result := VArgs[ArgPos].VPointer;
    Inc(ArgPos);
  End;

  Procedure GetStringArg(Var FirstChar: Pointer; Var len: LongInt);
  Begin
    If ArgPos > High_Args Then OutOfArgs;
    Case VArgs[ArgPos].VType Of
      vtChar:
      Begin
        FirstChar := @VArgs[ArgPos].VChar;
        len := 1;
      End;

      vtString:
      Begin
        FirstChar := VArgs[ArgPos].VString;
        len := Byte(FirstChar^);
        Inc(FirstChar);
      End;

      vtPointer,
      vtPChar:
      Begin
        FirstChar := VArgs[ArgPos].VPChar;
        len := StrLen(FirstChar);
      End;

      vtAnsiString:
      Begin
        FirstChar := VArgs[ArgPos].VPChar;
        len := Length(AnsiString(VArgs[ArgPos].VAnsiString));
      End;
    Else
      IllegalArg;
    End;
    Inc(ArgPos);
  End;

  { Parse A Number from the format String. A '*' means:
    Get the Next Integer argument from the Open Array. }

  Function ParseNum: LongInt;
  Begin
    If Fmt[FmtPos] = '*' Then Result := GetIntegerArg
    Else
    Begin
      Result := 0;
      While (Fmt[FmtPos] In ['0'..'9']) And (FmtPos < FmtLen) Do
      Begin
        Result := Result * 10 + Ord(Fmt[FmtPos]) - 48;
        Inc(FmtPos);
      End;
    End;
  End;

  { Parse A whole format specifier. }

  Function ParseFmtSpec: Char;
  Label
    LIndex, LColon, LMinus, LWidth, LPoint, LType;
  Begin
    Width := -1;
    Index := -1;
    Precision := -1;
    LeftAlign := False;
    ArgType := #0;
    C := Fmt[FmtPos];

    LIndex:

      If Not (C In ['0'..'9']) Then Goto LMinus;
      Width := ParseNum;
      If FmtPos >= FmtLen Then Exit;
      C := Fmt[FmtPos];

    LColon:

      If C <> ':' Then Goto LPoint;
      Index := Width;
      Width := -1;
      Inc(FmtPos);
      If FmtPos >= FmtLen Then Exit;
      C := Fmt[FmtPos];

    LMinus:

      If C <> '-' Then Goto LWidth;
      LeftAlign := True;
      Inc(FmtPos);
      If FmtPos >= FmtLen Then Exit;
      C := Fmt[FmtPos];

    LWidth:

      If Not (C In ['0'..'9']) Then Goto LPoint;
      Width := ParseNum;
      If FmtPos >= FmtLen Then Exit;
      C := Fmt[FmtPos];

    LPoint:

      If C <> '.' Then Goto LType;
      Inc(FmtPos);
      Precision := ParseNum;
      If FmtPos >= FmtLen Then Exit;
      C := Fmt[FmtPos];

    LType:

      Result := UpCase(C);
      ArgType := Result;

      Inc(FmtPos);
  End;

  { Append something To the Result Buffer }

  Procedure AppendStr(P: Pointer; Count: LongInt);
  Begin
    If BufLen - BufPos < Count Then Count := BufLen - BufPos;
    Move(P^, Buf[BufPos], Count);
    Inc(BufPos, Count);
  End;

  Procedure AppendChar(C: Char; Count: LongInt);
  Begin
    If BufLen - BufPos < Count Then Count := BufLen - BufPos;
    FillChar(Buf[BufPos], Count, C);
    Inc(BufPos, Count);
  End;

Begin
  FmtPos := 0;
  OldFmtPos := 0;
  BufPos := 0;
  ArgPos := 0;

  High_Args := High(Args);

  While (FmtPos < FmtLen) And (BufPos < BufLen) Do
  Begin
    C := Fmt[FmtPos];
    Inc(FmtPos);
    If C = '%' Then
    Begin
      C := ParseFmtSpec;
      If C = 'S' Then
      Begin
        GetStringArg(P, L);
        If (Precision > -1) And (Precision < L) Then L := Precision;
      End
      Else
      Begin
        Case C Of
          'D': Begin
                 Str(GetIntegerArg, S);
                 L := Length(S);
                 If (Precision <> -1) And (L < Precision) Then
                 Begin
                   SetLength(S, Precision);
                   Move(S[1], S[1 + Precision - L], L);
                   FillChar(S[1], Precision - L, '0');
                 End;
               End;
          'E': S := FloatToStrF(GetExtendedArg, ffExponent, Precision, 3);
          'F': S := FloatToStrF(GetExtendedArg, ffFixed, 9999, Precision);
          'G': S := FloatToStrF(GetExtendedArg, ffGeneral, Precision, 3);
          'N': Begin
                 S := FloatToStrF(GetExtendedArg, ffFixed, 9999, Precision);
                 Po := Pos(DecimalSeparator,S);
                 if Po = 0 then Po := Length(S)+1;
                 Dec(Po,3);
                 while (Po > 1) do
                   begin
                     if S[Po-1] in ['0'..'9']
                       then Insert(ThousandSeparator,S,Po);
                     Dec(Po,3);
                   end;
               End;
          'M': S := FloatToStrF(GetExtendedArg, ffCurrency, 9999, Precision);
          'P': Begin
                 L := LongInt(GetPointerArg);
                 S := IntToHex(L Shr 16, 4) + ':' + IntToHex(L And $FFFF, 4);
               End;
          'X': Begin
                 If Precision <> -1 Then S := IntToHex(GetIntegerArg, Precision)
                 Else S := IntToHex(GetIntegerArg, 0);
               End;
          '%': begin //RG Ausgabe '%'-Zeichen
                 S := '%';
               end;
          Else FmtLoadConvertError(SInvalidFormat, [C]);
        End;
        P := @S[1];
        L := Length(S);
      End;

      { now P Points To the First Char To Append To our Result, L holds the
        Length Of the Text To Insert. If Width > L Then we have To pad our
        Text With spaces. }

      If LeftAlign Then
      Begin
        AppendStr(P, L);
        If (Width > -1) And (L < Width) Then AppendChar(' ', Width - L );
      End
      Else
      Begin
        If (Width > -1) And (L < Width) Then AppendChar(' ', Width - L );
        AppendStr(P, L);
      End;
    End
    Else
    Begin
      { Ordinary character }
      Buf[BufPos] := C;
      Inc(BufPos);
    End;
    OldFmtPos := FmtPos;
  End;
  Result := BufPos;
End;
{$HINTS ON}


Function format(Const format: String; Const Args: Array Of Const): String;
Begin
  SetLength(Result, FormatBuf(Result[1], 255, format[1], Length(format), Args));
End;

Procedure FmtStr(Var Result: String; Const format: String; Const Args: Array Of Const);
Begin
  SetLength(Result, FormatBuf(Result[1], 255, format[1], Length(format), Args));
End;

Function StrFmt(Buffer, format: PChar; Const Args: Array Of Const): PChar;
Begin
  FormatBuf(Buffer, MaxLongInt, format, StrLen(format), Args);
  Result := Buffer;
End;

Function StrLFmt(Buffer: PChar; MaxLen: Cardinal; format: PChar; Const Args: Array Of Const): PChar;
Begin
  FormatBuf(Buffer, MaxLen, format, StrLen(format), Args);
  Result := Buffer;
End;

{ --- floating Point conversion --- }

Function FloatToStr(Value: Extended): String;
Begin
  Result := FloatToStrF(Value, ffGeneral, 15, 0);
End;

Function FloatToStrF(Value: Extended; format: TFloatFormat; Precision, Digits: Integer): String;
Var
  P: Integer;
  Negative, TooSmall, TooLarge: Boolean;
Begin
  Case format Of

    ffGeneral:

      Begin
        If (Precision = -1) Or (Precision > 15) Then Precision := 15;
        TooSmall := Abs(Value) < 0.00001;
        If Not TooSmall Then
        Begin
          Str(Value:0:999, Result);
          P := Pos('.', Result);
          Result[P] := DecimalSeparator;
          TooLarge := P > Precision + 1;
        End;

        If TooSmall Or TooLarge Then
          Result := FloatToStrF(Value, ffExponent, Precision, Digits);

        P := Length(Result);
        While Result[P] = '0' Do Dec(P);
        If Result[P] = DecimalSeparator Then Dec(P);
        SetLength(Result, P);
      End;

    ffExponent:

      Begin
        If (Precision = -1) Or (Precision > 15) Then Precision := 15;
        Str(Value:Precision + 8, Result);
        Result[3] := DecimalSeparator;
        If (Digits < 4) And (Result[Precision + 5] = '0') Then
        Begin
          Delete(Result, Precision + 5, 1);
          If (Digits < 3) And (Result[Precision + 5] = '0') Then
          Begin
            Delete(Result, Precision + 5, 1);
            If (Digits < 2) And (Result[Precision + 5] = '0') Then
            Begin
              Delete(Result, Precision + 5, 1);
              If (Digits < 1) And (Result[Precision + 5] = '0') Then Delete(Result, Precision + 3, 3);
            End;
          End;
        End;
        If Result[1] = ' ' Then Delete(Result, 1, 1);
      End;

    ffFixed:

      Begin
        If Digits = -1 Then Digits := 2
        Else If Digits > 15 Then Digits := 15;
        Str(Value:0:Digits, Result);
        If Result[1] = ' ' Then Delete(Result, 1, 1);
        P := Pos('.', Result);
        If P <> 0 Then Result[P] := DecimalSeparator;
      End;

    ffNumber:

      Begin
        If Digits = -1 Then Digits := 2
        Else If Digits > 15 Then Digits := 15;
        Str(Value:0:Digits, Result);
        If Result[1] = ' ' Then Delete(Result, 1, 1);
        P := Pos('.', Result);
        If P <> 0 Then Result[P] := DecimalSeparator;
        Dec(P, 3);
        While (P > 1) Do
        Begin
          If Result[P - 1] <> '-' Then Insert(ThousandSeparator, Result, P);
          Dec(P, 3);
        End;
      End;

    ffCurrency:

      Begin
        If Value < 0 Then
        Begin
          Negative := True;
          Value := -Value;
        End
        Else Negative := False;

        If Digits = -1 Then Digits := CurrencyDecimals
        Else If Digits > 15 Then Digits := 15;
        Str(Value:0:Digits, Result);
        If Result[1] = ' ' Then Delete(Result, 1, 1);
        P := Pos('.', Result);
        If P <> 0 Then Result[P] := DecimalSeparator;
        Dec(P, 3);
        While (P > 1) Do
        Begin
          Insert(ThousandSeparator, Result, P);
          Dec(P, 3);
        End;

        If Not Negative Then
        Begin
          Case CurrencyFormat Of
            0: Result := CurrencyString + Result;
            1: Result := Result + CurrencyString;
            2: Result := CurrencyString + ' ' + Result;
            3: Result := Result + ' ' + CurrencyString;
          End
        End
        Else
        Begin
          Case NegCurrFormat Of
            0: Result := '(' + CurrencyString + Result + ')';
            1: Result := '-' + CurrencyString + Result;
            2: Result := CurrencyString + '-' + Result;
            3: Result := CurrencyString + Result + '-';
            4: Result := '(' + Result + CurrencyString + ')';
            5: Result := '-' + Result + CurrencyString;
            6: Result := Result + '-' + CurrencyString;
            7: Result := Result + CurrencyString + '-';
            8: Result := '-' + Result + ' ' + CurrencyString;
            9: Result := '-' + CurrencyString + ' ' + Result;
            10: Result := CurrencyString + ' ' + Result + '-';
          End;
        End;
      End;
  End;
End;

Function FloatToText(Buffer: PChar; Value: Extended; format: TFloatFormat; Precision, Digits: Integer): Integer;
Var
  Tmp: String[40];
Begin
  Tmp := FloatToStrF(Value, format, Precision, Digits);
  Result := Length(Tmp);
  Move(Tmp[1], Buffer[0], Result);
End;

Function StrToFloat(Const S: String): Extended;
Var
  Error: Integer;
  Tmp: String;
  P: Integer;
Begin
  Tmp := S;
  P := Pos(DecimalSeparator, Tmp);
  If P <> 0 Then Tmp[P] := '.';
  Val(Tmp, Result, Error);
  If Error <> 0 Then FmtLoadConvertError(SInvalidFloat, [S]);
End;

Function TextToFloat(Buffer: PChar; Var Value: Extended): Boolean;
Var
  Error: Integer;
  Tmp: String;
  P: Integer;
Begin
  Tmp := StrPas(Buffer);
  P := Pos(DecimalSeparator, Tmp);
  If P <> 0 Then Tmp[P] := '.';
  Val(Tmp, Value, Error);
  Result := (Error = 0);
End;

Function FloatToTextFmt(Buffer: PChar; Value: Extended; format: PChar): Integer;
Var
  Digits: String[40];                         { String Of Digits                 }
  Exponent: String[8];                        { Exponent strin                   }
  FmtStart, FmtStop: PChar;                   { Start And End Of relevant part   }
                                              { Of format String                 }
  ExpFmt, ExpSize: Integer;                   { Type And Length Of               }
                                              { exponential format chosen        }
  Placehold: Array[1..4] Of Integer;          { Number Of placeholders In All    }
                                              { four Sections                    }
  thousand: Boolean;                          { thousand separators?             }
  UnexpectedDigits: Integer;                  { Number Of unexpected Digits that }
                                              { have To be inserted before the   }
                                              { First placeholder.               }
  DigitExponent: Integer;                     { Exponent Of First digit In       }
                                              { Digits Array.                    }

  { Find end of format section starting at P. False, if empty }

  Function GetSectionEnd(Var P: PChar): Boolean;
  Var
    C: Char;
    SQ, DQ: Boolean;
  Begin
    Result := False;
    SQ := False;
    DQ := False;
    C := P[0];
    While (C <> #0) And ((C <> ';') Or SQ Or DQ) Do
    Begin
      Result := True;
      Case C Of
        #34: If Not SQ Then DQ := Not DQ;
        #39: If Not DQ Then SQ := Not SQ;
      End;
      Inc(P);
      C := P[0];
    End;
  End;

  { Find start and end of format section to apply. If section doesn't exist,
    use section 1. If section 2 is used, the sign of value is ignored.       }

  Procedure GetSectionRange(section: Integer);
  Var
    Sec: Array[1..3] Of PChar;
    SecOk: Array[1..3] Of Boolean;
  Begin
    Sec[1] := format;
    SecOk[1] := GetSectionEnd(Sec[1]);
    If section > 1 Then
    Begin
      Sec[2] := Sec[1];
      If Sec[2][0] <> #0 Then Inc(Sec[2]);
      SecOk[2] := GetSectionEnd(Sec[2]);
      If section > 2 Then
      Begin
        Sec[3] := Sec[2];
        If Sec[3][0] <> #0 Then Inc(Sec[3]);
        SecOk[3] := GetSectionEnd(Sec[3]);
      End;
    End;
    If Not SecOk[1] Then FmtStart := Nil
    Else
    Begin
      If Not SecOk[section] Then section := 1
      Else If section = 2 Then Value := -Value;   { Remove sign }
      If section = 1 Then FmtStart := format Else
      Begin
        FmtStart := Sec[section - 1];
        Inc(FmtStart);
      End;
      FmtStop := Sec[section];
    End;
  End;

  { Find format section ranging from FmtStart to FmtStop. }

  Procedure GetFormatOptions;
  Var
    Fmt: PChar;
    SQ, DQ: Boolean;
    area: Integer;
  Begin
    SQ := False;
    DQ := False;
    Fmt := FmtStart;
    ExpFmt := 0;
    area := 1;
    thousand := False;
    Placehold[1] := 0;
    Placehold[2] := 0;
    Placehold[3] := 0;
    Placehold[4] := 0;

    While Fmt < FmtStop Do
    Begin
      Case Fmt[0] Of
        #34:
        Begin
          If Not SQ Then DQ := Not DQ;
          Inc(Fmt);
        End;

        #39:
        Begin
          If Not DQ Then SQ := Not SQ;
          Inc(Fmt);
        End;

      Else
        { This was 'if not SQ or DQ'. Looked wrong... }
        If Not SQ Or DQ Then
        Begin
          Case Fmt[0] Of
            '0':
            Begin
              Case area Of
                1:
                area := 2;
                4:
                Begin
                  area := 3;
                  Inc(Placehold[3], Placehold[4]);
                  Placehold[4] := 0;
                End;
              End;
              Inc(Placehold[area]);
              Inc(Fmt);
            End;

            '#':
            Begin
              If area = 3 Then area := 4;
              Inc(Placehold[area]);
              Inc(Fmt);
            End;

            '.':
            Begin
              If area < 3 Then area := 3;
              Inc(Fmt);
            End;

            ',':
            Begin
              thousand := True;
              Inc(Fmt);
            End;

            'e', 'E':
            If ExpFmt = 0 Then
            Begin
              If Fmt[0] = 'E' Then ExpFmt := 1 Else ExpFmt := 3;
              Inc(Fmt);
              If Fmt < FmtStop Then
              Begin
                Case Fmt[0] Of
                  '+':
                  Begin
                  End;

                  '-':
                  Inc(ExpFmt);

                Else
                  ExpFmt := 0;
                End;

                If ExpFmt <> 0 Then
                Begin
                  Inc(Fmt);
                  ExpSize := 0;
                  While (Fmt < FmtStop) And (ExpSize < 4) And (Fmt[0] In ['0'..'9']) Do
                  Begin
                    Inc(ExpSize);
                    Inc(Fmt);
                  End;
                End;
              End;
            End
            Else Inc(Fmt);

          Else { Case }
            Inc(Fmt);
          End; { Case }
        End; { Begin }
      End; { Case }
    End; { While .. Begin }
  End;

  Procedure FloatToStr;
  Var
    I, J, Exp, Width, Decimals, DecimalPoint, len: Integer;
  Begin
    If ExpFmt = 0 Then
    Begin
      { Fixpoint }
      Decimals := Placehold[3] + Placehold[4];
      Width := Placehold[1] + Placehold[2] + Decimals;

      If Decimals = 0 Then Str(Value: Width: 0, Digits)
      Else Str(Value: Width + 1: Decimals, Digits);

      len := Length(Digits);

      { Find the decimal point }
      If Decimals = 0 Then DecimalPoint := len  + 1 Else DecimalPoint := len - Decimals;

      { If value is very small, and no decimal places
        are desired, remove the leading 0.            }
      If (Abs(Value) < 1) And (Placehold[2] = 0) Then
      Begin
        If Placehold[1] = 0 Then Delete(Digits, DecimalPoint - 1, 1)
        Else Digits[DecimalPoint - 1] := ' ';
      End;

      { Convert optional zeroes to spaces. }
      I := len;
      J := DecimalPoint + Placehold[3];
      While (I > J) And (Digits[I] = '0') Do
      Begin
        Digits[I] := ' ';
        Dec(I);
      End;

      { If integer value and no obligatory decimal
        places, remove decimal point. }

      If (DecimalPoint < len) And (Digits[DecimalPoint + 1] = ' ') Then
          Digits[DecimalPoint] := ' ';

      { Convert spaces left from obligatory decimal point to zeroes. }

      I := DecimalPoint - Placehold[2];
      While (I < DecimalPoint) And (Digits[I] = ' ') Do
      Begin
        Digits[I] := '0';
        Inc(I);
      End;

      Exp := 0;
    End
    Else
    Begin
      { Scientific: exactly <Width> Digits With <Precision> Decimals
        And adjusted Exponent. }
      If Placehold[1] + Placehold[2] = 0 Then Placehold[1] := 1;

      Decimals := Placehold[3] + Placehold[4];
      Width := Placehold[1] + Placehold[2] + Decimals;

      Str(Value: Width + 8, Digits);

      { Find and cut out exponent. Always the
        last 6 characters in the string.
        -> 0000E+0000                         }

      I := Length(Digits) - 5;

      Val(Copy(Digits, I  + 1, 5), Exp, J);

      Exp := Exp + 1 - (Placehold[1] + Placehold[2]);
      Delete(Digits, I, 6);

      { Str() always returns at least one digit after the decimal point.
        If we don't want it, we have to remove it. }
      If (Decimals = 0) And (Placehold[1] + Placehold[2] <= 1) Then
      Begin
        If Digits[4] >= '5' Then
        Begin
          Inc(Digits[2]);
          If Digits[2] > '9' Then
          Begin
            Digits[2] := '1';
            Inc(Exp);
          End;
        End;
        Delete(Digits, 3, 2);
        DecimalPoint := Length(Digits) + 1;
      End
      Else
      Begin
        { Move decimal point at the desired position }
        Delete(Digits, 3, 1);
        DecimalPoint := 2 + Placehold[1] + Placehold[2];
        If Decimals <> 0 Then Insert('.', Digits, DecimalPoint);
      End;

      { Convert optional zeroes to spaces. }
      I := Length(Digits);
      J := DecimalPoint + Placehold[3];
      While (I > J) And (Digits[I] = '0') Do
      Begin
        Digits[I] := ' ';
        Dec(I);
      End;

      { If integer number and no obligatory decimal paces, remove decimal point }

      If (DecimalPoint < Length(Digits)) And (Digits[DecimalPoint + 1] = ' ') Then
          Digits[DecimalPoint] := ' ';

      If Digits[1] = ' ' Then
      Begin
        Delete(Digits, 1, 1);
        Dec(DecimalPoint);
      End;

      { Calculate exponent string }
      Str(Abs(Exp), Exponent);
      While Length(Exponent) < ExpSize Do Insert('0', Exponent, 1);
      If Exp >= 0 Then
      Begin
        If ExpFmt In [1, 3] Then Insert('+', Exponent, 1);
      End
      Else Insert('-', Exponent, 1);
      If ExpFmt < 3 Then Insert('E', Exponent, 1) Else Insert('e', Exponent, 1);
    End;

    DigitExponent := DecimalPoint - 2;
    If Digits[1] = '-' Then Dec(DigitExponent);

    UnexpectedDigits := DecimalPoint - 1 - (Placehold[1] + Placehold[2]);
  End;

  Function PutResult: LongInt;
  Var
    SQ, DQ: Boolean;
    Fmt, Buf: PChar;
    Dig, N: Integer;
  Begin
    SQ := False;
    DQ := False;
    Fmt := FmtStart;
    Buf := Buffer;
    Dig := 1;

    While Fmt < FmtStop Do
    Begin
      //Write(Fmt[0]);

      Case Fmt[0] Of
        #34:
        Begin
          If Not SQ Then DQ := Not DQ;
          Inc(Fmt);
        End;

        #39:
        Begin
          If Not DQ Then SQ := Not SQ;
          Inc(Fmt);
        End;

      Else

        If Not (SQ Or DQ) Then
        Begin
          Case Fmt[0] Of
            '0', '#', '.':
            Begin
              If (Dig = 1) And (UnexpectedDigits > 0) Then
              Begin
                { Everything unexpected is written before the first digit }
                For N := 1 To UnexpectedDigits Do
                Begin
                  Buf[0] := Digits[N];
                  Inc(Buf);
                  If thousand And (Digits[N] <> '-') Then
                  Begin
                    If (DigitExponent Mod 3 = 0) And (DigitExponent > 0) Then
                    Begin
                      Buf[0] := ThousandSeparator;
                      Inc(Buf);
                    End;
                    Dec(DigitExponent);
                  End;
                End;
                Inc(Dig, UnexpectedDigits);
              End;

              If Digits[Dig] <> ' ' Then
              Begin
                If Digits[Dig] = '.' Then Buf[0] := DecimalSeparator
                Else Buf[0] := Digits[Dig];
                Inc(Buf);
                If thousand And (DigitExponent Mod 3 = 0) And (DigitExponent > 0) Then
                Begin
                  Buf[0] := ThousandSeparator;
                  Inc(Buf);
                End;
              End;
              Inc(Dig);
              Dec(DigitExponent);
              Inc(Fmt);
            End;

            'e', 'E':
            Begin
              If ExpFmt <> 0 Then
              Begin
                Inc(Fmt);
                If Fmt < FmtStop Then
                Begin
                  If Fmt[0] In ['+', '-'] Then
                  Begin
                    Inc(Fmt, ExpSize);

                    For N := 1 To Length(Exponent) Do Buf[N - 1] := Exponent[N];
                    Inc(Buf, Length(Exponent));
                    ExpFmt := 0;
                  End;
                  Inc(Fmt);
                End;
              End
              Else
              Begin
                { No legal exponential format. Simply write
                  the 'E' to the reult. }
                Buf[0] := Fmt[0];
                Inc(Buf);
                Inc(Fmt);
              End;
            End;

          Else
            { Usual character }
            If Fmt[0] <> ',' Then
            Begin
              Buf[0] := Fmt[0];
              Inc(Buf);
            End;
            Inc(Fmt);
          End; { Case }
        End

        Else { IF }

        Begin
          { Character inside single or double quotes }
          Buf[0] := Fmt[0];
          Inc(Buf);
          Inc(Fmt);
        End;
      End; { Case }
    End; { While .. Begin }

    Result := LongInt(Buf) - LongInt(Buffer);
  End;

Begin
  If Value > 0 Then GetSectionRange(1)
  Else If Value < 0 Then GetSectionRange(2)
  Else GetSectionRange(3);

  If FmtStart = Nil Then
  Begin
    Result := FloatToText(Buffer, Value, ffGeneral, 15, 4);
  End
  Else
  Begin
    GetFormatOptions;
    If (ExpFmt = 0) And (Abs(Value) >= 1E18) Then Result := FloatToText(Buffer, Value, ffGeneral, 15, 4)
    Else
    Begin
      FloatToStr;
      Result := PutResult;
    End;
  End;
End;


Function FormatFloat(Const format: String; Value: Extended): String;
Var
  Temp: cstring[128];
Begin
  Temp := format;
  SetLength(Result, FloatToTextFmt(@Result[1], Value, @Temp));
End;


Procedure FloatToDecimal(Var Result: TFloatRec; Value: Extended; Precision, Decimals: Integer);
Var
  Buffer: String[24];
  Error, N: Integer;
Begin
{  If Precision > 15 Then Precision := 15;
   If Decimals > 15 Then Decimals := 15; }

  Str(Value:23, Buffer);

  Result.Negative := (Buffer[1] = '-');
  Val(Copy(Buffer, 19, 5), Result.Exponent, Error);
  Inc(Result. Exponent);

  Result.Digits[0] := Buffer[2];
  Move(Buffer[4], Result.Digits[1], 14);

  If Decimals + Result.Exponent < Precision Then N := Decimals + Result.Exponent
  Else N := Precision;

  If N > 15 Then N := 15;

  If N = 0 Then
  Begin
    If Result.Digits[0] >= '5' Then
    Begin
      Result.Digits[0] := '1';
      Result.Digits[1] := #0;
      Inc(Result.Exponent);
    End
    Else Result.Digits[0] := #0;
  End
  Else If N > 0 Then
  Begin
    If Result.Digits[N] >= '5' Then
    Begin
      { Round up }
      Repeat
        Result.Digits[N] := #0;
        Dec(N);
        Inc(Result.Digits[N]);
      Until (N = 0) Or (Result.Digits[N] < ':');
      If Result.Digits[0] = ':' Then
      Begin
        Result.Digits[0] := '1';
        Inc(Result.Exponent);
      End;
    End
    Else
    Begin
      { Cut zeros }
      Result.Digits[N] := '0';
      While (Result.Digits[N] = '0') And (N > -1) Do
      Begin
        Result.Digits[N] := #0;
        Dec(N);
      End;
    End;
  End
  Else Result.Digits[0] := #0;

  If Result.Digits[0] = #0 Then
  Begin
    { Zero has neither Exponent nor signum }
    Result.Exponent := 0;
    Result.Negative := False;
  End;
End;

{ Time encoding And decoding }

Procedure FastDiv(P, Q: LongWord; Var X, Y: LongInt); Assembler;
Asm
  MOV EAX, P;
  XOR EDX, EDX;
  DIV DWord Ptr Q;
  MOV EBX, X;
  MOV [EBX], EAX;
  MOV EBX, Y;
  MOV [EBX], EDX;
End;

Function _EncodeDate(Var date: TDateTime; Year, Month, Day: LongInt): Boolean;
Begin
  If (Year <= 9999) And (Month In [1..12]) And (Day In [1..31]) Then
  Begin
    If Month > 2 Then Dec (Month, 3)
    Else
    Begin
      Inc (Month, 9);
      Dec (Year);
    End;
    date:= (146097 * (Year Div 100)) Shr 2
         + (longint(1461) * (Year Mod 100)) Shr 2
         + (longint(153) * Month + 2) Div 5 + Day - 306;
    Result := True;
  End
  Else Result := False;
End;

/*
Function _EncodeDate(Var date: TDateTime; Year, Month, Day: LongWord): Boolean;
Var
  LeapYear: Boolean;
Begin
  If (Year <= 9999) And (Month In [1..12]) And (Day In [1..31]) Then
  Begin
    LeapYear := (Year Mod 4 = 0) And Not (Year Mod 100 = 0) Or (Year Mod 400 = 0);
    Dec(Year);
    date := Year * 365 + Year Div 4 - Year Div 100 + Year Div 400
            + 1 + DaysPassed[LeapYear, Month] + Day - 1;
    Result := True;
  End
  Else Result := False;
End;
*/

Function _EncodeTime(Var Time: TDateTime; Hour, Min, Sec, MSec: LongInt): Boolean;
Begin
  If (Hour < 24) And (Min < 60) And (Sec < 60) And (MSec < 1000) Then
  Begin
    Time := (((Hour * 60 + Min) * 60 + Sec) * 1000 + MSec) / MSecsPerDay;
    Result := True
  End
  Else Result := False;
End;

Function EncodeDate(Year, Month, Day: Word): TDateTime;
Begin
  If Not _EncodeDate(Result, Year, Month, Day) Then
    FmtLoadConvertError(SDateEncodeError, [Year, Month, Day]);
End;

Function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;
Begin
  If Not _EncodeTime(Result, Hour, Min, Sec, MSec) Then
    FmtLoadConvertError(STimeEncodeError, [Hour, Min, Sec, MSec]);
End;

Procedure DecodeDate(date: TDateTime; Var Year, Month, Day: Word);
Const
  Days400 = 146097;
  Days4   = 1461;
Var
  Y, M, D, Tmp1, Tmp2, Tmp3, Tmp4:{Martin}longint;
Begin
  Tmp1 := Trunc (date) + 306;
  Tmp2 := {Martin0806}longint(4) * Tmp1 - 1;

  FastDiv(Tmp2, Days400, Tmp3, Tmp1);

  Tmp2 := Tmp1 Shr 2;
  Tmp4 :={Martin}longint(4) * Tmp2 + 3;

  FastDiv(Tmp4, Days4, Tmp1, Tmp2);

  Tmp2 := (Tmp2 + 4) Shr 2;

  Y :={Martin}longint(100) * Tmp3 + Tmp1;
  Tmp3 :={Martin}longint(5) * Tmp2 - 3;

  FastDiv(Tmp3, 153, M, Tmp2);

  D := (Tmp2 + 5) Div 5;
  If M < 10 Then Inc (M, 3)
  Else
  Begin
    Dec (M, 9);
    Inc (Y);
  End;

  Year := Y;
  Month := M;
  Day := D;
End;

Procedure DecodeTime(Time: TDateTime; Var Hour, Min, Sec, MSec: Word);
Begin
  Time := Frac(Time) * 24;
  Hour := Trunc(Time);
  Time := Frac(Time) * 60;
  Min  := Trunc(Time);
  Time := Frac(Time) * 60;
  Sec  := Trunc(Time);
  MSec := Trunc(Frac(Time) * 1000);
End;

Function DayOfWeek(date: TDateTime): Integer;
Begin
  Result := (1 + Trunc(date)) Mod 7;
  If Result = 0 Then Result := 7;
End;

Function Date: TDateTime;
{$IFDEF OS2}
Var
  dt: DateTime;
{$ENDIF}
{$IFDEF Win32}
Var
  dt: SYSTEMTIME;
{$ENDIF}
Begin
  {$IFDEF OS2}
  DosGetDateTime (dt);
  Result := EncodeDate(dt.Year, dt.Month, dt.Day);
  {$ENDIF}
  {$IFDEF Win32}
  GetLocalTime(dt);
  Result := EncodeDate(dt.wYear, dt.wMonth, dt.wDay);
  {$ENDIF}
End;

Function Time: TDateTime;
{$IFDEF OS2}
Var
  dt: DateTime;
{$ENDIF}
{$IFDEF Win32}
Var
  dt: SYSTEMTIME;
{$ENDIF}
Begin
  {$IFDEF OS2}
  DosGetDateTime (dt);
  Result := EncodeTime(dt.Hour, dt.Min, dt.Sec, integer(dt.Hundredths) * 10);
  {$ENDIF}
  {$IFDEF Win32}
  GetLocalTime(dt);
  Result := EncodeTime(dt.wHour, dt.wMinute, dt.wSecond, dt.wMilliSeconds);
  {$ENDIF}
End;

Function Now: TDateTime;
{$IFDEF OS2}
Var
  dt: DateTime;
{$ENDIF}
{$IFDEF Win32}
Var
  dt: SYSTEMTIME;
{$ENDIF}
Begin
  {$IFDEF OS2}
  DosGetDateTime (dt);
  Result := EncodeDate(dt.Year, dt.Month, dt.Day) + EncodeTime(dt.Hour, dt.Min, dt.Sec, integer(dt.Hundredths) * 10);
  {$ENDIF}
  {$IFDEF Win32}
  GetLocalTime(dt);
  Result := EncodeDate(dt.wYear, dt.wMonth, dt.wDay) + EncodeTime(dt.wHour, dt.wMinute, dt.wSecond, dt.wMilliSeconds);
  {$ENDIF}
End;

Function NowStr: String; { gehoehrt: tStr21; }

var w1, w2, w3, w4 : Word;
    n : tDateTime;

Begin
  n:=now;
  DecodeDate(n,w1,w2,w3);
  Result:=tostr(w1)+'.'+tostr(w2)+'.'+tostr(w3)+' ';
  DecodeTime(n,w1,w2,w3,w4);
  Result:=Result+tostr(w1)+':'+tostr(w2)+':'+tostr(w3)+'.'+tostr(w4);
End;

{ --- date/Time To String conversion --- }

Procedure DateTimeToString(Var Result: String; Const format: String; DateTime: TDateTime);
Var
  Year, Month, Day, Hour, Min, Sec, MSec, Hour12: Word;
  BeforeNoon: Boolean;

  Procedure _DateTimeToString(Var Result: String; Const format: String; recursive: Boolean);
    { internal Function To Control recursion In format specifiers. Avoids
      stack overflow when format Strings contain Macros For other format
      Strings. }

  Var
    Start, Count, Pos, len, LastHourPos, LastHourSize, Tmp: Integer;
    Token: Char;
    UseMinutes: Boolean;

    Procedure AppendInt(I, Digits: Integer);
    Var
      S: String[5];
      P: Integer;
    Begin
      Str(I:Digits, S);
      P := 1;
      While S[P] = ' ' Do
      Begin
        S[P] := '0';
        Inc(P);
      End;
      AppendStr(Result, S);
    End;

    Procedure AppendStr(Const S: String);
    Begin
      Insert(S, Result, Length(Result) + 1);
    End;

    Function CountChar(C: Char; Max: Integer): Integer;
    Var
      Result: Integer;
    Begin
      Result := 1;
      While (Pos <= len) And (UpCase(format[Pos]) = C) And (Result < Max) Do
      Begin
        Inc(Pos);
        Inc(Result);
      End;
      CountChar := Result;
    End;

    Function IsSubStr(Const S: String): Boolean;
    Begin
      IsSubStr := (uppercase(Copy(format, Pos, Length(S))) = S);
    End;

    Procedure GetNextToken(BeforeNoon: Boolean);
    Begin
      Start := Pos;
      Token := UpCase(format[Pos]);
      Inc(Pos);
      Case Token Of
        #34,
        #39: Begin
               Inc(Start);
               While (Pos <= len) And (format[Pos] <> Token) Do Inc(Pos);
               Count := Pos - Start;
               If Pos < len Then Inc(Pos);
               Token := '$';
             End;
        'D': Count := CountChar('D', 6);
        'M': Count := CountChar('M', 4);
        'Y': Count := CountChar('Y', 4);
        'H',
        'N',
        'S',
        'T': Count := CountChar(Token, 2);
        'A': Begin
               If IsSubStr('MPM') Then
               Begin
                 Inc(Pos, 3);
                 Count := 0;
               End
               Else If IsSubStr('/P') Then
               Begin
                 Inc(Pos, 2);
                 If Not BeforeNoon Then Inc(Start, 2);
                 Count := 1;
               End
               Else If IsSubStr('M/PM') Then
               Begin
                 Inc(Pos, 4);
                 If Not BeforeNoon Then Inc(Start, 3);
                 Count := 2;
               End
               Else
               Begin
                 Token := '$';
                 Count := 1;
               End;
             End;
        'C',
        '/',
        ':': Begin
               { Nope }
             End;
        Else Begin
               Token := '$';
               Count := 1;
               While (Pos <= len) And Not (UpCase(format[Pos]) In
                   [#34, #39, 'A', 'C', 'D', 'H', 'M', 'N', 'S', 'T', 'Y', ':', '/']) Do
               Begin
                 Inc(Pos);
                 Inc(Count);
               End;
             End;
      End;

      If (Token = 'M') And UseMinutes Then Token := 'N';

      Case Token Of
        'H': UseMinutes := True;
        'A', 'C', 'D', 'M', 'N', 'S', 'T', 'Y': UseMinutes := False;
      End;
    End;

  Begin
    Pos := 1;
    len := Length(format);
    LastHourPos := 0;
    UseMinutes := False;

    If len = 0 Then _DateTimeToString(Result, 'C', True)
    Else While (Pos <= len) Do
    Begin
      GetNextToken(BeforeNoon);
      Case Token Of
        'C': If recursive Then
             Begin
               _DateTimeToString(Result, ShortDateFormat, False);
               If (Hour + Min + Sec) > 0 Then
               Begin
                 AppendStr(' ');
                 _DateTimeToString(Result, LongTimeFormat, False);
               End;
             End
             Else AppendStr('C');
        'D': Case Count Of
               1: AppendInt(Day, 1);
               2: AppendInt(Day, 2);
               3: AppendStr(ShortDayNames[DayOfWeek(DateTime)]);
               4: AppendStr(LongDayNames[DayOfWeek(DateTime)]);
               5: If recursive Then _DateTimeToString(Result, ShortDateFormat, False)
                  Else AppendStr('DDDDD');
               6: If recursive Then _DateTimeToString(Result, LongDateFormat, False)
                  Else AppendStr('DDDDDD');
             End;
        'M': Case Count Of
               1: AppendInt(Month, 1);
               2: AppendInt(Month, 2);
               3: AppendStr(ShortMonthNames[Month]);
               4: AppendStr(LongMonthNames[Month]);
             End;
        'Y': Case Count Of
               1, 2: AppendInt(Year Mod 100, 2);
               3, 4: AppendInt(Year, 4);
             End;
        'H': Begin
               LastHourPos := Length(Result) + 1;
               LastHourSize := Count;
               AppendInt(Hour, Count);
             End;
        'N': AppendInt(Min, Count);
        'S': AppendInt(Sec, Count);
        'T': Case Count Of
               1: If recursive Then _DateTimeToString(Result, ShortTimeFormat, False)
                  Else AppendStr('T');
               2: If recursive Then _DateTimeToString(Result, LongTimeFormat, False)
                  Else AppendStr('TT');
             End;
        'A': Begin
               If LastHourPos <> 0 Then
               Begin
                 If (LastHourSize = 1) And (Hour < 10) Then Tmp := 1
                 Else Tmp := 2;
                 Delete(Result, LastHourPos, Tmp);
                 If (LastHourSize = 2) And (Hour12 < 10) Then
                     Insert('0' + IntToStr(Hour12), Result, LastHourPos)
                 Else Insert(IntToStr(Hour12), Result, LastHourPos);
                 LastHourPos := 0;
               End;
               Case Count Of
                 0: If BeforeNoon Then AppendStr(TimeAMString)
                    Else AppendStr(TimePMString);
                 1: AppendStr(format[Start]);
                 2: AppendStr(format[Start] + format[Start  + 1]);
               End
             End;
        '/': AppendStr(DateSeparator);
        ':': AppendStr(TimeSeparator);
        '$': AppendStr(Copy(format, Start, Count));
      End;
    End;
  End;

Begin
  DateTime := DateTime + 5.79e-6;  // avoid rounding problems

  DecodeDate(DateTime, Year, Month, Day);
  DecodeTime(DateTime, Hour, Min, Sec, MSec);

  If (Hour = 0) Or (Hour > 12) Then
  Begin
    If Hour = 0 Then Hour12 := 12
    Else Hour12 := Hour - 12;
    BeforeNoon := False;
  End
  Else
  Begin
    BeforeNoon := True;
    Hour12 := Hour;
  End;
  Result := '';

  If Length(format) <> 0 Then _DateTimeToString(Result, format, True)
  Else _DateTimeToString(Result, 'C', True)
End;

Function DateToStr(date: TDateTime): String;
Begin
  DateTimeToString(Result, ShortDateFormat, date);
End;

Function TimeToStr(Time: TDateTime): String;
Begin
  DateTimeToString(Result, LongTimeFormat, Time);
End;

Function DateTimeToStr(DateTime: TDateTime): String;
Begin
  DateTimeToString(Result, ShortDateFormat + ' ' + LongTimeFormat, DateTime);
End;

Function FormatDateTime(Const format: String; DateTime: TDateTime): String;
Begin
  DateTimeToString(Result, format, DateTime);
End;

{ --- String To date/Time conversions --- }

Procedure IgnoreSpaces(Const S: String; Var Pos: Integer; len: Integer);
Begin
  While (Pos <= len) And (S[Pos] = ' ') Do Inc(Pos);
End;

Function GetNumber(Var Num: Integer; Const S: String; Var Pos: Integer; len: Integer): Boolean;
Begin
  Result := False;
  Num := 0;
  IgnoreSpaces(S, Pos, len);
  While (Pos <= len) And (S[Pos] In ['0'..'9']) Do
  Begin
    Result := True;
    Num := Num * 10 + Ord(S[Pos]) - 48;
    Inc(Pos);
  End;
End;

{$HINTS OFF}
Function CompareString(Const SubStr, S: String; Var Pos: Integer; len: Integer): Boolean;
Begin
  If CompareText(SubStr, Copy(S, 1, Length(SubStr))) = 0 Then
  Begin
    Result := True;
    Inc(Pos, Length(SubStr));
  End
  Else Result := False;
End;
{$HINTS ON}

Function CompareChar(C: Char; S: String; Var Pos: Integer; len: Integer): Boolean;
Begin
  If (Pos <= len) And (UpCase(C) = UpCase(S[Pos])) Then
  Begin
    Result := True;
    Inc(Pos);
  End
  Else Result := False;
End;

Function CutString(Var S: String; separator: Char): String;
Var
  P: Integer;
Begin
  P := Pos(separator, S);
  If P = 0 Then P := Length(S) + 1;
  Result := Copy(S, 1, P - 1);
  Delete(S, 1, P);
End;

Function ParseDate(Var date: TDateTime; Const S: String; Var Pos: Integer; len: Integer): Boolean;
Var
  Head, Temp: String[15];
  N, Year, Month, Day: Integer;
  Number: Array[1..3] Of Integer;
  order: String[3];
  CenturyBase: Integer;

  Function GetCurrentYear: Integer;
  Var
    Y, M, D: Word;
  Begin
    DecodeDate(Now, Y, M, D);
    Result := Y;
  End;

Begin
  order := 'XXX';

  Result := False;

  If Not GetNumber(Number[1], S, Pos, len) Then Exit;
  If Not CompareChar(DateSeparator, S, Pos, len) Then Exit;
  If Not GetNumber(Number[2], S, Pos, len) Then Exit;
  If Not CompareChar(DateSeparator, S, Pos, len) Then Exit;
  If Not GetNumber(Number[3], S, Pos, len) Then Number[3] := -1;

  Temp := ShortDateFormat;

  For N := 1 To 3 Do
  Begin
    Head := CutString(Temp, DateSeparator);
    If Length(Head) <> 0 Then order[N] := UpCase(Head[1]);
  End;

  If order = 'MDY' Then
  Begin
    Month := Number[1];
    Day := Number[2];
    Year := Number[3];
  End
  Else If order = 'DMY' Then
  Begin
    Day := Number[1];
    Month := Number[2];
    Year := Number[3];
  End
  Else If order = 'YMD' Then
  Begin
    If Number[3] = -1 Then
    Begin
      Year := -1;
      Month := Number[1];
      Day := Number[2];
    End
    Else
    Begin
      Year := Number[1];
      Month := Number[2];
      Day := Number[3];
    End;
  End;

  If Year = -1 Then Year := GetCurrentYear
  Else 
    If Year < 100 Then
    Begin
      // Inc(Year, 1900);
      CenturyBase := GetCurrentYear - TwoDigitYearCenturyWindow;
      Inc(Year, (CenturyBase Div 100) * 100);
      If (TwoDigitYearCenturyWindow > 0) And (Year < CenturyBase) 
          Then Inc(Year, 100);
    End;


  Result := True;
  Result := _EncodeDate(date, Year, Month, Day);
End;

Function ParseTime(Var Time: TDateTime; Const S: String; Var Pos: Integer; len: Integer): Boolean;
Var
  Hour, Min, Sec: Integer;
Begin
  Result := False;

  If Not GetNumber(Hour, S, Pos, len) Then Exit;
  If Not CompareChar(TimeSeparator, S, Pos, len) Then Exit;
  If Not GetNumber(Min, S, Pos, len) Then Exit;
  If CompareChar(TimeSeparator, S, Pos, len) And Not GetNumber(Sec, S, Pos, len) Then Exit;

  IgnoreSpaces(S, Pos, len);
  If CompareChar('A', S, Pos, len) Then
  Begin
    CompareChar('M', S, Pos, len);
    If Hour = 12 Then Hour := 0;
  End
  Else If CompareChar('P', S, Pos, len) Then
  Begin
    CompareChar('M', S, Pos, len);
    If (Hour >= 1) And (Hour <= 11) Then Inc(Hour, 12);
  End;

  Result := _EncodeTime(Time, Hour, Min, Sec, 0);
End;

Function StrToDate(Const S: String): TDateTime;
Var
  Pos, len: Integer;
Begin
  Pos := 1;
  len := Length(S);
  If Not ParseDate(Result, S, Pos, len) Then FmtLoadConvertError(SInvalidDate, [S]);
End;

Function StrToTime(Const S: String): TDateTime;
Var
  Pos, len: Integer;
Begin
  Pos := 1;
  len := Length(S);
  If Not ParseTime(Result, S, Pos, len) Then FmtLoadConvertError(SInvalidTime, [S]);
End;

Function StrToDateTime(Const S: String): TDateTime;
Var
  Time: TDateTime;
  Pos, len: Integer;
Begin
  Pos := 1;
  len := Length(S);
  If Not ParseDate(Result, S, Pos, len) Then FmtLoadConvertError(SInvalidDateTime, [S]);
  If ParseTime(Time, S, Pos, len) Then Result := Result + Time;
End;

{ --- Initialization File support --- }

Function GetProfileStr(Const Section, Entry, Default: String): String;
Var
  CDefault: cstring;
  {$IFDEF OS2}
  OutBuf: cstring;
  {$ENDIF}
Begin
  CDefault := Default;
  {$IFDEF OS2}
  Fillchar(OutBuf, 255, 0); {sometimes the #0 character is not copied (cdp.ini)}
  PrfQueryProfileString(HINI_UserProfile, Section, Entry, Default, OutBuf, 255);
  Result := OutBuf;
  {$ENDIF}
  {$IFDEF Win32}
  If entry='' Then GetProfileString('USER',section,Default,CDefault,255)
  Else GetProfileString('USER',section,entry,CDefault,255);
  result:=CDefault;
  {$ENDIF}
End;

{$HINTS OFF}
Function GetProfileChar(Const Section, Entry: String; Default: Char): Char;
Var
  InBuf, OutBuf: cstring[2];
Begin
  InBuf[0] := Default;
  InBuf[1] := #0;
  {$IFDEF OS2}
  PrfQueryProfileString(HINI_UserProfile,
                        Section, Entry,
                        InBuf, OutBuf, 2);
  Result := OutBuf[0];
  {$ENDIF}
  {$IFDEF Win32}
  GetProfileString('USER',section,InBuf,OutBuf,255);
  Result:= OutBuf[0];
  {$ENDIF}
End;
{$HINTS ON}

Function GetProfileInt(Const Section, Entry: string; Default: Integer): Integer;
{$IFDEF Win32}
Var
  S: String;
  C: Integer;
{$ENDIF}
Begin
  {$IFDEF OS2}
  Result := PrfQueryProfileInt(HINI_UserProfile,Section, Entry,Default);
  {$ENDIF}
  {$IFDEF Win32}
  S:=GetProfileStr(section,entry,'');
  Val(S,Result,C);
  If C<>0 Then Result:=Default;
  {$ENDIF}
End;
{
Procedure GetFormatSettings;
Const
  key = 'PM_National';
Var
  N: Integer;
Begin
  TimeAMString := GetProfileStr(key, 's1159', 'am');
  TimePMString := GetProfileStr(key, 's2359', 'pm');
  CurrencyString := GetProfileStr(key, 'sCurrency', '$');
  ThousandSeparator := GetProfileChar(key, 'sThousand', ',');
  DecimalSeparator := GetProfileChar(key, 'sDecimal', '.');
  DateSeparator := GetProfileChar(key, 'sDate', '/');
  TimeSeparator := GetProfileChar(key, 'sTime', ':');
  ListSeparator := GetProfileChar(key, 'sList', ';');

  DateOrder := GetProfileInt(key, 'iDate', 0);
  Case DateOrder Of
    0: Begin
         ShortDateFormat := 'mm/dd/yyyy';
         LongDateFormat := 'dddd, mmmm d. yyyy';
       End;
    1: Begin
         ShortDateFormat := 'dd/mm/yyyy';
         LongDateFormat := 'dddd, d. mmmm yyyy';
       End;
    2: Begin
         ShortDateFormat := 'yyyy/mm/dd';
         LongDateFormat := 'dddd, yyyy mmmm d.';
       End;
  End;

  CurrencyFormat := GetProfileInt(key, 'iCurrency', 0);

  Case CurrencyFormat Of
    0: NegCurrFormat := 1;
    1: NegCurrFormat := 5;
    2: NegCurrFormat := 9;
    3: NegCurrFormat := 8;
  End;

  CurrencyDecimals := GetProfileInt(key, 'iDigits', 2);

  Case GetProfileInt(key, 'iLzero', 0) Of
    0: Begin
         ShortTimeFormat := 'h:mm';
         LongTimeFormat := 'h:mm:ss';
       End;
    1: Begin
         ShortTimeFormat := 'hh:mm';
         LongTimeFormat := 'hh:mm:ss';
       End;
  End;

  If GetProfileInt(key, 'iTime', 0) = 0 Then
  Begin
    ShortTimeFormat := ShortTimeFormat + ' ampm';
    LongTimeFormat := LongTimeFormat + ' ampm';
    TwelveHours := True;
  End
  Else TwelveHours := False;

  For N := 1 To 12 Do
  Begin
    ShortMonthNames[N] := LoadNLSStr(SShortMonthNames + N - 1);
    LongMonthNames[N] := LoadNLSStr(SLongMonthNames + N - 1);
  End;

  For N := 1 To 7 Do
  Begin
    ShortDayNames[N] := LoadNLSStr(SShortDayNames + N - 1);
    LongDayNames[N] := LoadNLSStr(SLongDayNames + N - 1);
  End;
End;}

Function StringOfChars(CH: Char; Count: Integer): String;
Begin
  SetLength(Result, Count);
  FillChar(Result[1], Count, CH);
End;

{Exception management}
Constructor Exception.CreateFmt(Const Msg:String;Const Args:Array Of Const);
Begin
     Inherited Create(format(Msg,Args));
End;

Constructor Exception.CreateRes(Ident:Word);
Begin
     Inherited Create(LoadStr(Ident));
End;

Constructor Exception.CreateResFmt(Ident:Word;Const Args:Array Of Const);
Begin
     Inherited Create(format(LoadStr(Ident),Args));
End;

Constructor Exception.CreateResNLS(Ident:Word);
Begin
     Inherited Create(LoadNLSStr(Ident));
End;

Constructor Exception.CreateResNLSFmt(Ident:Word;Const Args:Array Of Const);
Begin
     Inherited Create(format(LoadNLSStr(Ident),Args));
End;

Constructor Exception.CreateHelp(Const Msg:String;AHelpContext:LongInt);
Begin
     Inherited Create(Msg);
     HelpContext:=AHelpContext;
End;

Constructor Exception.CreateFmtHelp(Const Msg:String;Const Args:Array Of Const;AHelpContext:LongInt);
Begin
     Inherited Create(format(Msg,Args));
     HelpContext:=AHelpContext;
End;

Constructor Exception.CreateResHelp(Ident:Word;AHelpContext:LongInt);
Begin
     Inherited Create(LoadStr(Ident));
     HelpContext:=AHelpContext;
End;

Constructor Exception.CreateResFmtHelp(Ident:Word;Const Args:Array Of Const;AHelpContext:LongInt);
Begin
     Inherited Create(format(LoadStr(Ident),Args));
     HelpContext:=AHelpContext;
End;

Constructor Exception.CreateResNLSHelp(Ident:Word;AHelpContext:LongInt);
Begin
     Inherited Create(LoadNLSStr(Ident));
     HelpContext:=AHelpContext;
End;

Constructor Exception.CreateResNLSFmtHelp(Ident:Word;Const Args:Array Of Const;AHelpContext:LongInt);
Begin
     Inherited Create(format(LoadNLSStr(Ident),Args));
     HelpContext:=AHelpContext;
End;

//**************************************************************************
//
//    Random support
//
//**************************************************************************}


CONST
   Factor:WORD=$8405;

Procedure Randomize;

var Hour, Min, Sec, MSec: Word;

Begin
  DecodeTime(Time, Hour, Min, Sec, MSec);
  RandSeed:=(((Hour SHL 8)+Min) SHL 16)+
                ((Sec SHL 8)+MSec);
end;

PROCEDURE NextRandom;
BEGIN
     ASM
        MOV AX,SYSUTILS.RandSeed
        MOV BX,SYSUTILS.RandSeed+2
        MOV CX,AX
        MULW SYSUTILS.Factor
        SHL CX,3
        ADD CH,CL
        ADD DX,CX
        ADD DX,BX
        SHL BX,2
        ADD DX,BX
        ADD DH,BL
        MOV CL,5
        SHL BX,CL
        ADD DH,BL
        ADD AX,1
        ADC DX,0
        MOV SYSUTILS.RandSeed,AX
        MOV SYSUTILS.RandSeed+2,DX
     END;
END;

FUNCTION  Random(value:word):word;
BEGIN
     ASM
        CALLN32 SYSUTILS.NextRandom
        MOV CX,DX
        MOV BX,value
        MUL BX
        MOV AX,CX
        MOV CX,DX
        MUL BX
        ADD AX,CX
        ADC DX,0
        MOV AX,DX
        MOV Result,AX
    END;
END;

FUNCTION FloatRandom:EXTENDED;
BEGIN
     result:=Random(8192)/8192;
END;

PROCEDURE SysSleep(ms:LONGWORD);

BEGIN
  {$IFDEF OS2}
  DosSleep(ms);
  {$ENDIF}
  {$IFDEF Win32}
  Sleep(ms);
  {$ENDIF}
END;


Procedure SysShutDown;

Begin
  {$IFDEF OS2}
  WinShutdownSystem(AppHandle, HMQ_CURRENT);
  {$ENDIF}
  {$IFDEF Win32}
  ExitWindowsEx(EWX_SHUTDOWN, 0);
  {$ENDIF}
End;

Function getEnvCount : LongInt;

var P : ^cString;

Begin
  asm
     MOV EAX,SYSTEM.EnvStart
     MOV P,EAX
  end;
  result:=0;
  if P<>nil then
    while P^[0]<>#0 do
       Begin
          while P^[1]<>#0 do inc(P);
          inc(P);
          inc(P);
          Inc(Result);
       end;
End;

Function getEnv(const iEnv:String):AnsiString;

var c:CSTRING;
    res:LONGWORD;
    {$IFDEF OS2}
    c1:PChar;
    {$ENDIF}
    {$IFDEF Win32}
    c1: cString;
    {$ENDIF}

Begin
  c:=iEnv;
  {$IFDEF OS2}
  Res:=DosScanEnv(c,c1);
  IF res=0
    then Result:=PChar(c1)^ // StrPas(c1)
    else Result:='';
  {$ENDIF}

  {$IFDEF Win32}
  res:=GetEnvironmentVariable(c,c1,255);
  IF res>0
    then Result:=c1
    else Result:='';
  {$ENDIF}
End;

Procedure StrOemToAnsi(Var s:String);
  var
    I : byte;
  begin
    for I := 1 to length(s) do s[I] := OemToAnsiTable[s[I]];
  end;
Procedure StrAnsiToOem(Var s:String);
  var
    I : byte;
  begin
    for I := 1 to length(s) do s[I] := AnsiToOemTable[s[I]];
  end;



{ ***************************************************************************** }

Begin
  {$IFDEF OS2}
  InitPM;
  {$ENDIF}
  CurrentLanguageTable:=tLngDefault;
{  GetFormatSettings;}
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  28-Feb-96             assume fmShareDenyNone, If no sharing Mode Is specified.
                        added support For File locking.
  08-Mar-96             added lots Of comments. added resources And loading Of
                        Error Messages And Month / Day Names.
                        FIXED A bug In FormatStr.
  14-Apr-96             removed Some forgotten debugging Code.
  18-Apr-96             added windows-only AnsiLowerCase And AnsiCompareStr.
                        FIXED A bug In DayOfWeek.
                        Faster EncodeDate / DecodeDate.
  12-may-96             Error codes returned by File Open functions were always -1.
  24-may-96             added Trim, TrimLeft, TrimRight, And QuotedStr functions As
                        In Delphi 2.0.
  11-Jun-96             bug In FloatToStrF, ffGeneral With values < 0.001 always used
                        FIXED Point.
  27-Jul-96             removed SetLength, already declared In System Unit.
  27-Aug-96             added SysErrorMessage.
  26-Dec-96             FIXED Error In date encoding. changed numerous Parameters In
                        API calls from LongInt To LongWord where ULONG was expected.
  27-Dec-96             added support For AnsiStrings As Open Array Parameters In
                        String formatting functions.
  02-Feb-97             FIXED Some bugs:
                        - FileWrite returned -1 ON Success instead Of ON failure.
                        - DateTimeToFileDate didn't work With New Compiler.
                        changed File access Mode For FileCreate To RD/WR/exclusive.
  02-Aug-99             - Adapted to Linux (RN)
  26-Sep-02   WD        Ausbau der LINUX-Teile
  24-Jul-03   WD        Ausbau von GUI
  04-Okt-03   WD        Einbau der Random-Funktionen aus SYSTEM.PAS
  25-Nov-03   WD        Einbau der SysSleep-Funktion (aus DOS.PAS)
  30-Dez-03   WD        Ausbau der Funktion von "GetFormatSettings". Diese Funktion wird
                        durch uSysInfo ersetzt.
  22-Mar-04   WD        Einbau der Funktion "StrMatch".
  12-Apr-04   WD        Einbau der Funktion "NowStr".
  07-Jun-04   MV        Korrektur von der Funktion "StrMatch". Die Funktion hat fehlgeschlagen
                        bei ('*.pasx', 'text.pas') und beim umgekehrten Fall ('*.pas', 'text.pasx').
                        In beiden Fllen wird flschlicherweise TRUE ausgegeben.
  06-Aug-04   MV        Compiler-Prob korr.: Der Compiler rechnet mit dem Variablentyp weiter,
                        mit dem er einmal angefangen hat.
  06-Aug-04   MV        Umbau der Funktionen "DiskFree" und "Disksize"
  08-Aug-04   MV        StrOEMtoAnsi, StrAnsiToOEM moved to FORMS.PAS
  15-Sep-04   CW        The FindFirst function in Windows 2000 doesn't locate files with the archive bit turned off.
  16-Nov-04   WD        Umbau des Sprachsystems.
                        Sibyl_NLS_* auf WDSibyl_NLS_* umbenannt.
  16-Mar-05   WD        Einbau vom der Definition tLongWordArray
  14-Mai-05   MV        Ich habe bei einer Handvoll Stellen Range Check Errors eliminiert,
                        indem ich integer() bzw. longint() eingefgt habe.
  28-Aug-05   WD        Variablen die nicht verwendet werden entfernt.
  15-Feb-06   WD        Die niederlaendische Sprache eingebaut
  21-Jan-06   WD        Korrektur von ParseDate (Verwendet jetzt den DateSeparator)
  22-Jan-06   MV        Long file support > 2GB for findfirst, findnext, findclose. Changes marked with "Martin lf"
                             simply use searchrec.floatsize (: extended) instead of searchrec.size !!!
  22-Jan-06   MV        Bug in sysutils.FindFirst, Sysutils.FindNext fixed: os2searchrec in findfirst, findnext was local
  08-Feb-06   Vova/WD   Die russische Sprache eingebaut
  17-Mar-06   MV        Funktion OS/Time; dt.Hundredths auf Integer
  01-Apr-06   MS/WD     Die italienische Sprache eingebaut.
  06-Apr-06   WD        Funktion: PathExists und DelTree eingebaut
  17-Apr-06   WD        Funktion: SysShutDown eingebaut
  13-Jul-06   WD        Funktion: DeleteLastPathSeparator eingebaut
  21-Aug-06   RG        Format: Korrektur Ausgabe von Format('%0.0n MB',[dSize])
  30-Aug-06   MV        DecodeDate: Range-Error korrigiert.
  12-Sep-06   WD        Funktion: HexToInt eingebaut.
  24-Sep-06   TB        Funktion: FileGetSize eingebaut.
  20-Oct-06   MV        Funktion: tStrMatch umgebaunt.
  14-Dec-06   RG        Format: Korrektur Ausgabe von zB Format('%D%%',[PercentDone])
  16-May-07   RG        FormatBuf: Integer-Uebergabe bei %N,%E,%F... erlaubt
  22-Aug-07   WD        FileSearch: Umbau der Liste auf AnsiString
  01-Jan-08   WD        GetTempFileName: Kopiert aus Classes.pas
  01-Jan-08   WD        GetEnv und GetEnvCount aus uSysInfo kopiert.
  09-Mar-08   MV        StrOEMtoAnsi, StrAnsiToOEM moved from FORMS.PAS
  01-Jun-08   MV        Korrekturen bei FileAge und FileCopy
  12-Aug-08   WD        Funktion: ExtractFileDrive eingebaut.
  17-Jan-09   WD        Funktion: StrACopy, StrALCopy eingebaut.
  20-Apr-09   PE        Konstante fanormal von $0080 auf $0000 geaendert.
}

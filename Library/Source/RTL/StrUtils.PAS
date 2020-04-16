
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl  Unit StrUtils                                                บ
 บ                                                                          บ
 บ    erstellt:  14. Apr 2020   Rolf Gachnang                               บ
 บ                                                                          บ
 บ    String handling routines                                              บ
 บ    ...analog Delphi System.StrUtils oder FreePascal StrUtils             บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit StrUtils;

Interface


function PosEx(const SubStr, s: string; Offset: Integer): Integer;

// m”gliche Erweiterungen:

//Function AnsiResemblesText(const AText, AOther: string): Boolean;
//Function AnsiContainsText(const AText, ASubText: string): Boolean;
//Function AnsiStartsText(const ASubText, AText: string): Boolean;
//Function AnsiEndsText(const ASubText, AText: string): Boolean;
//Function AnsiReplaceText(const AText, AFromText, AToText: string): string;
//Function AnsiMatchText(const AText: string; const AValues: array of string): Boolean;
//Function AnsiIndexText(const AText: string; const AValues: array of string): Integer;
//Function AnsiContainsStr(const AText, ASubText: string): Boolean;
//Function AnsiStartsStr(const ASubText, AText: string): Boolean;
//Function AnsiEndsStr(const ASubText, AText: string): Boolean;
//x Function AnsiReplaceStr(const AText, AFromText, AToText: string): string; {uBS_AnsiString}
//Function AnsiMatchStr(const AText: string; const AValues: array of string): Boolean;
//Function AnsiIndexStr(const AText: string; const AValues: array of string): Integer;
//Function DupeString(const AText: string; ACount: Integer): string;
//Function ReverseString(const AText: string): string;
//Function AnsiReverseString(const AText: AnsiString): AnsiString;
//
//function PosSet (const c:string;const s : ansistring ):Integer;
//function PosSetEx (const c:string;const s : ansistring;count:Integer ):Integer;
//
//Function StuffString(const AText: string; AStart, ALength: Cardinal;  const ASubText: string): string;
//Function RandomFrom(const AValues: array of string): string;
//Function LeftStr(const AText: AnsiString; const ACount: Integer): AnsiString;
//Function RightStr(const AText: AnsiString; const ACount: Integer): AnsiString;
//Function MidStr(const AText: AnsiString; const AStart, ACount: Integer): AnsiString;
//Function RightBStr(const AText: AnsiString; const AByteCount: Integer): AnsiString;
//Function MidBStr(const AText: AnsiString; const AByteStart, AByteCount: Integer): AnsiString;
//Function AnsiLeftStr(const AText: AnsiString; const ACount: Integer): AnsiString;
//Function AnsiRightStr(const AText: AnsiString; const ACount: Integer): AnsiString;
//Function AnsiMidStr(const AText: AnsiString; const AStart, ACount: Integer): AnsiString;
//Function LeftBStr(const AText: AnsiString; const AByteCount: Integer): AnsiString;
//Function SearchBuf(Buf: PChar; BufLen: Integer; SelStart, SelLength: Integer; SearchString: String; Options: TStringSearchOptions): PChar;
//Function SearchBuf(Buf: PChar; BufLen: Integer; SelStart, SelLength: Integer; SearchString: String): PChar; // ; Options: TStringSearchOptions = [soDown]
//x Function ReplaceStr(const AText, AFromText, AToText: string): string;  {uString}
//Function ReplaceText(const AText, AFromText, AToText: string): string;
//function DelSpace(const S: string): string;
//function DelChars(const S: string; Chr: Char): string;
//function Tab2Space(const S: string; Numb: Byte): string;
//function NPos(const C: string; S: string; N: Integer): Integer;
//Function RPos(c:char;const S : AnsiString):Integer;
//Function RPos(Const Substr : AnsiString; Const Source : AnsiString) : Integer;
//function AddChar(C: Char; const S: string; N: Integer): string;
//function AddCharR(C: Char; const S: string; N: Integer): string;
//function PadLeft(const S: string; N: Integer): string;
//function PadRight(const S: string; N: Integer): string;
//function PadCenter(const S: string; Len: Integer): string;
//function Hex2Dec(const S: string): Longint;
//function Dec2Numb(N: Longint; Len, Base: Byte): string;
//function Numb2Dec(S: string; Base: Byte): Longint;
//function IntToBin(Value: Longint; Digits, Spaces: Integer): string;
//procedure BinToHex(BinValue, HexValue: PChar; BinBufSize: Integer);
//function HexToBin(HexValue, BinValue: PChar; BinBufSize: Integer): Integer;


Implementation


{--------------------------------------------------------------------}
  function PosEx(const SubStr, s: string; Offset: Integer): Integer;
{--------------------------------------------------------------------}
{ Textsuche ab einer bestimmten Position                             }
var snew : String;
    SubLen : Longint;
    p : LongInt;

begin
  Result := 0;
  SubLen := Length(SubStr);
  if (SubLen > 0) and (Offset > 0) and (Offset <= Length(s))
  then begin
         snew := s;
         Delete(snew,1,Offset-1);
         p := Pos(SubStr,snew);
         if p > 0
         then Result := p + Offset - 1;
       end;
end;


Initialization

Finalization

End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  14-Apr-20  RG         Erstellung der Unit
  14-Apr-20  RG         PosEx()

}



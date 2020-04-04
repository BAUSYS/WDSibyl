Unit uDateTime;

Interface

Uses SysUtils, uString;

Function DateTimetoUNIX(aDateTime: TDateTime): LongInt;
// Konvertieren des Pascal-Datumformat in ein UnixFormat

Function UnixtoDateTime(aTime: Longint): TDateTime;
// Konvertieren des Unix-Datumsformat in ein Pascal-Datumformat.

Function DateToWeek(Date : tDateTime) : Byte;
// Liefert die Kalenderwoche von dem Datum zurueck; src from Toolbox

Function MonthToNumber(iMonthTxt : tStr3) : Byte;

type
  tcDateTime=Class
    Private
      fValue : tDateTime;

      Function getDaysPerMonth : Byte;
    Public
      Property Value        : tDateTime Read fValue Write fValue;
      Property DaysPerMonth : Byte Read getDaysPerMonth;
    Published
  End;

Type iMonthInfo = Record
       DaysPerMonth : Byte;
       ShortNameGR  : tStr3;
       ShortNameGB  : tStr3;
     End;

Const cDaysPerMonth : Array[1..12] Of iMonthInfo =
    ((DaysPerMonth: 31; ShortNameGR: 'Jan'; ShortNameGB: 'Jan'),
     (DaysPerMonth: 28; ShortNameGR: 'Feb'; ShortNameGB: 'Feb'),
     (DaysPerMonth: 31; ShortNameGR: 'Mar'; ShortNameGB: 'Mar'),
     (DaysPerMonth: 30; ShortNameGR: 'Apr'; ShortNameGB: 'Apr'),
     (DaysPerMonth: 31; ShortNameGR: 'Mai'; ShortNameGB: 'May'),
     (DaysPerMonth: 30; ShortNameGR: 'Jun'; ShortNameGB: 'Jun'),
     (DaysPerMonth: 31; ShortNameGR: 'Jul'; ShortNameGB: 'Jul'),
     (DaysPerMonth: 31; ShortNameGR: 'Aug'; ShortNameGB: 'Aug'),
     (DaysPerMonth: 30; ShortNameGR: 'Sep'; ShortNameGB: 'Sep'),
     (DaysPerMonth: 31; ShortNameGR: 'Okt'; ShortNameGB: 'Oct'),
     (DaysPerMonth: 30; ShortNameGR: 'Nov'; ShortNameGB: 'Nov'),
     (DaysPerMonth: 31; ShortNameGR: 'Dez'; ShortNameGB: 'Dec'));

Implementation


Function tcDateTime.getDaysPerMonth : Byte;

Begin

End;

Function DateToWeek(Date : tDateTime) : Byte;

Var y,m,d: Word;      // Jahr, Monat, Tag
    FDay : Word;      // Wochentag des 1. Januar im Jahr
    JanF : tDateTime; // 1. Januar des Jahres
    Days : Word;      // Anzahl Tage seit dem 1. Januar des Jahres

Begin
  try
    decodeDate(Date, Y, M, D);
    JanF := EncodeDate(Y, 1, 1);
    fDay := DayOfWeek(JanF);
    days := trunc(int(date)-janF) + 7 - dayofWeek(date - 1);
    inc(days, 7 * ord(fday in [2..5]));
    result:=days div 7;
    if result = 0
      then
        Begin
          if (dayofWeek(EncodeDate(y - 1, 1, 1)) > 5) or
             (dayofWeek(EncodeDate(y - 1, 12, 31)) < 5)
            then Result := 52
            else Result := 53;
        End
      else
        if Result = 53 then
          Begin
            if (fDay > 5) or (DayOfWeek(EncodeDate(Y, 12, 31)) < 5)
              then Result:=1;
          End;
  except
    Result:=0
  end;
End;

Function MonthToNumber(iMonthTxt : tStr3) : Byte;

var Month: tStr3;

Begin
  Month:=UpperCase(iMonthTxt);
  if Month[1] in ['A'..'Z']
    then
      Begin
        Result:=0;
        repeat
          inc(Result);
        until (Result=13) or
              (Month = uppercase(cDaysPerMonth[Result].ShortNameGR)) or
              (Month = uppercase(cDaysPerMonth[Result].ShortNameGB));
        if Result=13 then Result:=0;
      End
    else
      Result:=StrToInt(iMonthTxt);
End;

{***********************************
* convert unix timestamp to TDateTime
*
* @param aTime: LongInt
* @return TDateTime
***********************************}
Function UnixtoDateTime(aTime: LongInt): TDateTime;
var
  nUnixDelta, nTime: Extended;
begin
  nUnixDelta := EncodeDate(1970,1,1);
  nTime := aTime/24/60/60;
  Result := nTime+nUnixDelta;
end;

{***********************************
* convert TDateTime to unix timestamp
*
* @param aDateTime: TDateTime
* @return LongInt
***********************************}
Function DateTimetoUnix(aDateTime: TDateTime): LongInt;
var
  nUnixDelta, nDiff: Extended;
begin
  nUnixDelta := EncodeDate(1970,1,1);
  nDiff := aDateTime-nUnixDelta;
  Result:=nDiff*24*60*60;
end;



Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  18-Apr-06  WD         Funktion DateToWeek eingebaut
  24-Sep-06  TB         Funktion DateTimeToUnix, UnixToDateTime eingebaut.
}
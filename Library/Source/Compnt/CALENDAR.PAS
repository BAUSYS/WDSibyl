
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit Calendar;

Interface

Uses Classes, Forms, StdCtrls, SysUtils, Grids, Color,
     uDateTime, uSysInfo,
     uString;

{Declare new class}
Type
  TCalendar=Class(TGrid)
    Private
      FDate: TDateTime;
      FMonthOffset: Integer;
      FOnChange:TNotifyEvent;
    Private
      Function DayNum(Col,Row:LongInt):LongInt;
      Function GetYear:LongInt;
      Function GetMonth:LongInt;
      Function GetDay:LongInt;
      Procedure SetYear(NewValue:LongInt);
      Procedure SetMonth(NewValue:LongInt);
      Procedure SetDay(NewValue:LongInt);
      Procedure UpdateCalendar;
      Procedure SetCalendarDate(NewValue:TDateTime);
    Protected
      Procedure SetupComponent; Override;
      Procedure Resize; Override;
      Procedure DrawCell(Col,Row:LONGINT;rec:TRect;AState:TGridDrawState); Override;
      Procedure Change;Virtual;
    Public
      Destructor Destroy; Override;
      Procedure NextYear;
      Procedure PrevYear;
      Procedure NextMonth;
      Procedure PrevMonth;
    Public
      Property Year:LongInt read GetYear write SetYear;
      Property Month:LongInt read GetMonth write SetMonth;
      Property Day:LongInt read GetDay write SetDay;
      Property CalendarDate:TDateTime read FDate write SetCalendarDate;
    Published
      Property OnChange:TNotifyEvent  read FOnChange write FOnChange;
      Property Align;
      Property Bottom;
      Property DragCursor;
      Property DragMode;
      Property Enabled;
      Property Font;
      Property Height;
      Property Left;
      Property ParentFont;
      Property ParentShowHint;
      Property PopupMenu;
      Property ShowHint;
      Property TabOrder;
      Property Visible;
      Property Width;
      Property ZOrder;

      Property OnCanDrag;
      Property OnCommand;
      Property OnDblClick;
      Property OnDragDrop;
      Property OnDragOver;
      Property OnEndDrag;
      Property OnEnter;
      Property OnExit;
      Property OnFontChange;
  End;

// ------------------------------------------------------------------------------------

  tEditDate=Class(TControl)
  Private
    fcbDay  : tComboBox;
    fcbMonth: tComboBox;
    fcbYear : tComboBox;
    fYearMin: LongInt;
    fYearMax: LongInt;
    fTabStop: Boolean;

    Procedure FillYear;
    Procedure SetYearMin(iYearMin : LongInt);
    Procedure SetYearMax(iYearMax : LongInt);
    Procedure SetDate(iDate : tDateTime);
    Procedure SetTabStop(iTabStop : Boolean);
    Function GetDate : tDateTime;
    Function GetMonth : Byte;

    Procedure evDayOnExit(iSender: TObject);
    Procedure evDayOnPresskey(iSender: TObject; var ikey: Char);
    Procedure evMonthOnExit(iSender: TObject);
    Procedure evMonthOnPresskey(iSender: TObject; var ikey: Char);
    Procedure evYearOnExit(iSender: TObject);

  Protected
    Procedure SetupComponent; Override;
    Procedure Resize; Override;
    Procedure FontChange; Override;
    Procedure SetupShow; Override;

  Public
    Destructor Destroy; Override;
    Procedure ResetComponent; Override;

    Property Date : tDateTime Read getDate Write SetDate;

  Published
    Property Align;
    Property YearMin : LongInt Read fYearMin Write SetYearMin;
    Property YearMax : LongInt Read fYearMax Write SetYearMax;
    Property Font;
    Property TabOrder;
    Property TabStop : Boolean Read fTabStop Write SetTabStop;
  End;


Implementation

Const MaxYear = 2100;

Procedure TCalendar.Change;
Begin
  IF FOnChange<>Nil Then FOnChange(Self);
End;

Procedure TCalendar.SetCalendarDate(NewValue: TDateTime);
Begin
  FDate := NewValue;
  UpdateCalendar;
  Change;
End;

Function TCalendar.GetYear:LongInt;
Var AYear,AMonth,ADay:Word;
Begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  Result := AYear;
End;

Function TCalendar.GetMonth:LongInt;
Var AYear,AMonth,ADay:Word;
Begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  Result := AMonth;
End;

Function TCalendar.GetDay:LongInt;
Var AYear,AMonth,ADay:Word;
Begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  Result := ADay;
End;

Procedure TCalendar.SetYear(NewValue:LongInt);
Var AYear,AMonth,ADay:Word;
Begin
  If NewValue<0 Then exit;
  DecodeDate(FDate, AYear, AMonth, ADay);
  AYear:=NewValue;
  FDate := EncodeDate(AYear, AMonth, ADay);
  UpdateCalendar;
  Change;
End;

Procedure TCalendar.SetMonth(NewValue:LongInt);
Var AYear,AMonth,ADay:Word;
Begin
  If NewValue<0 Then exit;
  DecodeDate(FDate, AYear, AMonth, ADay);
  AMonth:=NewValue;
  FDate := EncodeDate(AYear, AMonth, ADay);
  UpdateCalendar;
  Change;
End;

Procedure TCalendar.SetDay(NewValue:LongInt);
Var AYear,AMonth,ADay:Word;
Begin
  If NewValue<0 Then exit;
  DecodeDate(FDate, AYear, AMonth, ADay);
  ADay:=NewValue;
  FDate := EncodeDate(AYear, AMonth, ADay);
  UpdateCalendar;
  Change;
End;

Procedure TCalendar.UpdateCalendar;
Var AYear, AMonth, ADay: Word;
    ADate:TDateTime;
Begin
  If FDate <> 0 Then
  Begin
    DecodeDate(FDate,AYear,AMonth,ADay);
    ADate:=EncodeDate(AYear,AMonth,1);
    FMonthOffset:=2-DayOfWeek(ADate);
    Row:=(ADay-FMonthOffset) Div 7+1;
    Col:=(ADay-FMonthOffset) Mod 7;
  End;
  Refresh;
End;

Procedure TCalendar.SetupComponent;
Begin
  Inherited SetupComponent;

  ColCount:=7;
  RowCount:=7;
  FixedCols:=0;
  FixedRows:=1;
  FDate:=Date;
  Options:=Options-[goMouseSelect]+[goAlwaysShowSelection];
  UpdateCalendar;
End;

Destructor TCalendar.Destroy;
Begin
  Inherited Destroy;
End;

Procedure TCalendar.Resize;
Begin
  Inherited Resize;
  DefaultColWidth:=Width DIV 7;
  DefaultRowHeight:=Height DIV 7;
End;

Function TCalendar.DayNum(Col,Row:LongInt):LongInt;
Begin
  Result:=FMonthOffset+Col+(Row-1)*7;
  If (Result<1) Or
     (Result>goSysInfo.Datetime.DaysThisMonth(Year,Month)) Then Result :=-1;
End;

Procedure TCalendar.DrawCell(Col,Row:LONGINT;rec:TRect;AState:TGridDrawState);
Var OldClip,Exclude:TRect;
    X,Y,CX,CY:LongInt;
    Cap:String;
    Day:LongInt;
    Back,Fore:TColor;
Begin
  SetupCellColors(Col,Row,AState,Back,Fore);
  Canvas.Brush.Color:=Back;
  Canvas.Pen.Color:=Fore;

  If Row=0 Then Cap:=ShortDayNames[Col+1] //Fixed
  Else
  Begin
       Day:=DayNum(Col,Row);
       If Day>=0 Then Cap:=tostr(Day)
       Else Cap:='';
  End;

  X:=rec.Left+2;
  Y:=rec.Top-2-Canvas.Font.Height;
  Canvas.GetTextExtent(Cap,CX,CY);
  Canvas.TextOut(X,Y,Cap);

  OldClip:=Canvas.ClipRect;
  Exclude.Left:=X;
  Exclude.Right:=X+CX-1;
  Exclude.Bottom:=Y;
  Exclude.Top:=Y+CY-1;
  Canvas.ClipRect:=rec;
  Canvas.ExcludeClipRect(Exclude);
  Inherited DrawCell(Col,Row,rec,AState);
  Canvas.ClipRect:=OldClip;
End;

Procedure TCalendar.NextYear;
Begin
  Year:=Year+1;
End;

Procedure TCalendar.PrevYear;
Begin
  Year:=Year-1;
End;

Procedure TCalendar.NextMonth;
Begin
  If Month=12 Then
  Begin
     Month:=1;
     NextYear;
  End
  Else Month:=Month+1;
End;

Procedure TCalendar.PrevMonth;
Begin
  If Month=1 Then
  Begin
     Month:=12;
     PrevYear;
  End
  Else Month:=Month-1;
End;

// ------------------------------------------------------------------------------------

Procedure tEditDate.SetDate(iDate : tDateTime);

var Year, Month, Day : Word;

Begin
  DecodeDate(iDate, Year, Month, Day);
  if Day<10
    then fcbDay.Text:='0'+tostr(Day)
    else fcbDay.Text:=tostr(Day);
  fcbMonth.Text:=cDaysPerMonth[Month].ShortnameGR;
  fcbYear.Text:=tostr(Year);
End;

Function tEditDate.GetMonth : Byte;

Begin
  Result:=MonthToNumber(fcbMonth.Text);
End;

Function tEditDate.GetDate : tDateTime;

Begin
  Result:=EncodeDate(StrToInt(fcbYear.Text),
                     getMonth,
                     StrToInt(fcbDay.Text));
  SetDate(Result);
End;

Procedure tEditDate.SetTabStop(iTabStop : Boolean);

Begin
  fTabStop := iTabStop;
  if fcbDay<>nil then
    Begin
      fcbDay.TabStop:=iTabStop;
      fcbMonth.TabStop:=iTabStop;
      fcbYear.TabStop:=iTabStop;
    End;
End;

Procedure tEditDate.SetYearMin(iYearMin : LongInt);

Begin
  if iYearMin < 0 then iYearMin:=0;
  if iYearMin > MaxYear then iYearMin:=MaxYear;
  fYearMin:=iYearMin;
  fcbYear.SelText:=toStr(fYearMin);
  FillYear;
End;

Procedure tEditDate.SetYearMax(iYearMax : LongInt);

Begin
  if iYearMax < fYearMin then iYearMax:=fYearMin;
  if iYearMax > MaxYear then iYearMax:=MaxYear;
  fYearMax:=iYearMax;
  FillYear;
End;

Procedure tEditDate.FillYear;

var cou : LongWord;

Begin
  fcbYear.Items.Clear;
  for cou:=fYearMin to fYearMax do
    fcbYear.Items.add(toStr(cou));
End;

Procedure tEditDate.evYearOnExit(iSender: TObject);

var Value : LongInt;

Begin
  Value:=StrToInt(fcbYear.Text);
End;

Procedure tEditDate.evDayOnExit(iSender: TObject);

var Day : LongInt;

Begin
  day:=StrToInt(fcbDay.Text);
  if (day<1) or (day>31) then
    fcbDay.CaptureFocus;
End;

Procedure tEditDate.evDayOnPresskey(iSender: TObject; var ikey: Char);

Begin
  if iKey in ['0'..'9'] then exit;
  if iKey='.' then fcbMonth.Focus;
  iKey:=#0;
End;

Procedure tEditDate.evMonthOnExit(iSender: TObject);

var Month : LongInt;

Begin
  Month:=getMonth;
  if Month in [1..12]
    then fcbMonth.Text:=cDaysPerMonth[Month].ShortnameGR
    else fcbMonth.CaptureFocus;
End;

Procedure tEditDate.evMonthOnPresskey(iSender: TObject; var ikey: Char);

Begin
  if iKey='.' then
    Begin
      fcbYear.Focus;
      ikey:=#0;
      evMonthOnExit(iSender);
    End;
End;

Procedure tEditDate.SetupShow;

Begin
  inherited SetupShow;
  setTabStop(true);   {inherited tabstop); }
  fcbDay.DropDownCount:=6;
  fcbDay.Hint:=inherited Hint;

  fcbMonth.DropDownCount:=6;
  fcbMonth.Hint:=inherited Hint;

  fcbYear.DropDownCount:=6;
  fcbYear.Hint:=inherited Hint;

End;

Procedure tEditDate.Resize;

{$IFDEF OS2}
Var FW : LongInt;
{$ENDIF}

Begin
  inherited Resize;
{ Unter OS/2 die Groeแe berechnen.
  Bei Windows fixe groesse, weil die Berchnung nicht korrekt ablaeuft }
{$IFDEF OS2}
  FW:=Font.MaximumPointSize;
  fcbDay.SetWindowPos(0,6, FW*5, Font.Height);
  fcbMonth.SetWindowPos(fcbDay.Width,6,FW*5, Font.Height);
  fcbYear.SetWindowPos(fcbMonth.Left + fcbMonth.Width,6,FW*7, Font.Height);
  Height:=Font.Height+6;
  Width:=fcbYear.Left + fcbYear.Width;
{$ENDIF}
{$IFDEF WIN32}
  fcbDay.SetWindowPos(0,6, 60, 20);
  fcbMonth.SetWindowPos(60,6,60, 20);
  fcbYear.SetWindowPos(120,6,80, 20);
  Height:=26;
  Width:=210;
{$ENDIF}
End;

Procedure tEditDate.FontChange;

Begin
  inherited FontChange;
  Resize;
End;

Procedure TEditDate.ResetComponent;

Begin
  inherited ResetComponent;
  setDate(now);
End;

Procedure tEditDate.SetupComponent;

var cou    : LongWord;

Begin                                  
  Inherited SetupComponent;

  Name:='EditDate';
  Width:=200;
  Height:=22;
  ParentPenColor:= True;
  ParentColor   := True;

  Inherited TabStop := false;   { Damit kann das Controlselber nicht angesprungen werden }
{  Inherited TabStop := true; }

  fYearMin:=1998;
  fYearMax:=2010;

  fcbDay:=InsertComboBox(Self, 0, 0, 30, Height, csDropDown);
  fcbDay.Name         := 'cbDay';
  fcbDay.NumbersOnly  := true;
  fcbDay.ParentFont   := true;
  fcbDay.OnExit       := evDayOnExit;
  fcbDay.OnKeyPress   := evDayOnPresskey;
  fcbDay.TabStop      := true;
  fcbDay.MaxLength    := 2;
  InsertControl(fcbDay);

  fcbMonth:=InsertComboBox(Self, 50, 0, 30, Height, csDropDown);
  fcbMonth.Name       := 'cbMonth';
  fcbMonth.NumbersOnly:= false;
  fcbMonth.ParentFont := true;
  fcbMonth.OnExit     := evMonthOnExit;
  fcbMonth.OnKeyPress := evMonthOnPresskey;
  fcbMonth.TabStop    := true;
  fcbMonth.MaxLength  := 3;
  InsertControl(fcbMonth);

  fcbYear:=InsertComboBox(Self, 90, 0,30, Height, csDropDown);
  fcbYear.Name        := 'cbYear';
  fcbYear.NumbersOnly := true;
  fcbYear.ParentFont  := true;
  fcbYear.TabStop     := true;
  fcbYear.OnExit      := evYearOnExit;
  fcbYear.MaxLength   := 4;
  InsertControl(fcbYear);

  If Designed
    then
      Begin   { In diesem Fall funktioniert auch die Taborder }
        Include(fcbDay.ComponentState, csDetail);
        Include(fcbMonth.ComponentState, csDetail);
        Include(fcbYear.ComponentState, csDetail);
      End
    else
      Begin
        for cou:=1 to 31 do
          if cou < 10
            then fcbDay.Items.add('0'+toStr(cou))
            else fcbDay.Items.add(toStr(cou));
        for cou:=1 to 12 do
          fcbMonth.Items.add(cDaysPerMonth[Cou].ShortNameGR);
        FillYear;
      End;

  setTabStop(true);
  ResetComponent;
End;

Destructor tEditDate.Destroy;
Begin
  Inherited Destroy;
End;

Initialization
  RegisterClasses([TCalendar, tEditDate]);
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  08-Sep-04  WD         Von uEditDate die Klasse "tEditDate" uebernommen
  02-Apr-05  WD         Diverse Korrektueren von der Klasse "tEditDate"
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
}
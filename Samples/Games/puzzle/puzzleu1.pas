unit puzzleu1;

interface

uses
  Classes, Forms, Graphics, StdCtrls, Buttons, ExtCtrls, Gradient, SysUtils;

type
  TPuzzleForm = class (TForm)
    PuzzleSet: TValueSet;
    StartBtn: TBitBtn;
    StopBtn: TBitBtn;
    ScorePanel: TPanel;
    Gradient1: TGradient;
    procedure PuzzleFormOnCreate (Sender: TObject);
    procedure StopBtnOnClick (Sender: TObject);
    procedure StartBtnOnClick (Sender: TObject);
    procedure PuzzleSetOnItemSelect (Sender: TObject; Index: LongInt);
  private
    {Insert private declarations here}
    MoveCount: Integer;
    SpaceIndex: Integer;
    procedure MixPieces;
    function MovePiece(Index: Integer): Integer;
  public
    {Insert public declarations here}
  end;

var
  PuzzleForm: TPuzzleForm;

implementation

procedure TPuzzleForm.PuzzleFormOnCreate (Sender: TObject);
var
  I: Integer;
begin
  with PuzzleSet do
  begin
    for I := 0 to RowCount * ColCount - 2 do
      Strings[I] := Chr(65 + I);
    SpaceIndex := RowCount * ColCount - 1;
  end;
end;

procedure TPuzzleForm.PuzzleSetOnItemSelect (Sender: TObject;
  Index: LongInt);
var
  I: Integer;
begin
  if MovePiece(Index) <> - 1 then
  begin
    Inc(MoveCount);
    ScorePanel.Caption := ToStr(MoveCount) + ' moves so far...';

    for I := 0 to PuzzleSet.RowCount * PuzzleSet.ColCount - 2 do
      if PuzzleSet.Strings[I] <> Chr(65 + I) then Exit;

    ScorePanel.Caption := 'Puzzle solved in ' + ToStr(MoveCount) + ' moves.';
    StopBtn.Enabled := False;
    PuzzleSet.Enabled := False;
    StartBtn.Enabled := True;
  end;
end;

procedure TPuzzleForm.StopBtnOnClick (Sender: TObject);
begin
  StopBtn.Enabled := False;
  PuzzleSet.Enabled := False;
  StartBtn.Enabled := True;
  ScorePanel.Caption := 'You gave up after ' + ToStr(MoveCount) + ' moves.';
end;

procedure TPuzzleForm.StartBtnOnClick (Sender: TObject);
begin
  StartBtn.Enabled := False;
  StopBtn.Enabled := True;
  PuzzleSet.Enabled := True;
  MixPieces;
  MoveCount := 0;
  ScorePanel.Caption := '0 moves so far...';
end;

procedure TPuzzleForm.MixPieces;
var
  I: Integer;
begin
  with PuzzleSet do
  begin
    BeginUpdate;
    I := 0;
    while I < 1000 do
    begin
      if MovePiece(Random(RowCount * ColCount)) <> -1 then Inc(I);
    end;
    EndUpdate;
  end;
end;

function TPuzzleForm.MovePiece(Index: Integer): Integer;
begin
  with PuzzleSet do
  begin
    if (Index >= ColCount) and (Index - ColCount = SpaceIndex) then
      Result := Index - ColCount
    else if (Index mod ColCount <> 0) and (Index - 1 = SpaceIndex) then
      Result := Index - 1
    else if ((Index + 1) mod ColCount <> 0) and (Index + 1 = SpaceIndex) then
      Result := Index + 1
    else if (Index < (RowCount - 1) * ColCount) and (Index + ColCount = SpaceIndex) then
      Result := Index + ColCount
    else
      Result := -1;

    if Result <> -1 then
    begin
      BeginUpdate;
      Strings[Result] := PuzzleSet.Strings[Index];
      Strings[Index] := '';
      EndUpdate;
      SpaceIndex := Index;
    end;
  end;
end;

initialization
  RegisterClasses ([TPuzzleForm, TValueSet, TBitBtn, TPanel, TGradient]);
end.

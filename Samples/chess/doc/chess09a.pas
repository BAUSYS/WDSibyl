program Chess;

uses
  Crt;

type
  TPosition = record
    X: LongInt;
    Y: LongInt;
  end;

  TColor = (Black, White);

  TPiece = class
  private
    FPosition: TPosition;
    FColor:   TColor;
  protected
    procedure GetPicture(var Head, Body, Feet: string); virtual;
  public
    constructor Create(Color: TColor; Position: TPosition);
    function CanMoveTo(NewPosition: TPosition): Boolean; virtual;
    function GetColor: TColor;
    function GetPosition: TPosition;
    procedure SetPosition(NewPosition: TPosition); virtual;
    procedure Draw;
    procedure Erase;
  end;

  TExtPiece = class(TPiece)
  private
    FHasBeenMoved: Boolean;
  public
    constructor Create(Color: TColor; Position: TPosition);
    procedure SetPosition(NewPosition: TPosition); override;
  end;

  TBishop = class(TPiece)
  protected
    procedure GetPicture(var Head, Body, Feet: string); override;
  public
    function CanMoveTo(NewPosition: TPosition): Boolean; override;
  end;

  TKnight = class(TPiece)
  protected
    procedure GetPicture(var Head, Body, Feet: string); override;
  public
    function CanMoveTo(NewPosition: TPosition): Boolean; override;
  end;

  TQueen = class(TBishop)
  protected
    procedure GetPicture(var Head, Body, Feet: string); override;
  public
    function CanMoveTo(NewPosition: TPosition): Boolean; override;
  end;

  TKing = class(TExtPiece)
  protected
    procedure GetPicture(var Head, Body, Feet: string); override;
  public
    function CanMoveTo(NewPosition: TPosition): Boolean; override;
  end;

  TRook = class(TExtPiece)
  protected
    procedure GetPicture(var Head, Body, Feet: string); override;
  public
    function CanMoveTo(NewPosition: TPosition): Boolean; override;
  end;

  TPawn = class(TExtPiece)
  protected
    procedure GetPicture(var Head, Body, Feet: string); override;
  public
    function CanMoveTo(NewPosition: TPosition): Boolean; override;
  end;

{ --- General Procedures / Functions --- }

function MakePosition(X, Y: Integer): TPosition;
begin
  Result.X := X;
  Result.Y := Y;
end;

procedure PositionToScreen(Position: TPosition; var X, Y, Color: Integer);
begin
  X := 2 + (Position.X - 1) * 7;
  Y := 25 - Position.Y * 3;
  if Odd(Position.X + Position.Y) then Color := 4
  else Color := 2;
end;

{ --- TPiece --- }

function TPiece.CanMoveTo(NewPosition: TPosition): Boolean;
begin
  Result := not (NewPosition = FPosition);
end;

function TPiece.GetColor: TColor;
begin
  Result := FColor;
end;

function TPiece.GetPosition: TPosition;
begin
  Result := FPosition;
end;

constructor TPiece.Create(Color: TColor; Position: TPosition);
begin
  FColor := Color;
  FPosition := Position;
end;

procedure TPiece.SetPosition(NewPosition: TPosition);
begin
  FPosition := NewPosition;
end;

procedure TPiece.GetPicture(var Head, Body, Feet: string);
begin
end;

procedure TPiece.Draw;
var
  Row, Column, Color: Integer;
  Head, Body, Feet: string;
begin
  PositionToScreen(FPosition, Column, Row, Color);
  TextBackground(Color);
  if FColor = White then TextColor(15) else TextColor(0);
  GetPicture(Head, Body, Feet);
  GotoXY(Column, Row);
  Write(Head);
  GotoXY(Column, Row + 1);
  Write(Body);
  GotoXY(Column, Row + 2);
  Write(Feet);
end;

procedure TPiece.Erase;
var
  Row, Column, Color: Integer;
begin
  PositionToScreen(FPosition, Column, Row, Color);
  TextBackground(Color);
  GotoXY(Column, Row);
  Write('       ');
  GotoXY(Column, Row + 1);
  Write('       ');
  GotoXY(Column, Row + 2);
  Write('       ');
end;

{ --- TExtPiece --- }

constructor TExtPiece.Create(Color: TColor; Position: TPosition);
begin
  inherited Create(Color, Position);
  FHasBeenMoved := False;
end;

procedure TExtPiece.SetPosition(NewPosition: TPosition);
begin
  inherited SetPosition(NewPosition);
  FHasBeenMoved := True;
end;

{ --- TBishop --- }

function TBishop.CanMoveTo(NewPosition: TPosition): Boolean;
var
  VerticalMove, HorizontalMove: Integer;
begin
  HorizontalMove := NewPosition.X - FPosition.X;
  VerticalMove := NewPosition.Y - FPosition.Y;

  Result := inherited CanMoveTo(NewPosition) and
            (Abs(VerticalMove) = Abs(HorizontalMove));
end;

procedure TBishop.GetPicture(var Head, Body, Feet: string);
begin
  Head := '  //\  ';
  Body := ' //  \ ';
  Feet := ' \ B / ';
end;

{ --- TKnight --- }

function TKnight.CanMoveTo(NewPosition: TPosition): Boolean;
var
  VerticalMove, HorizontalMove: Integer;
begin
  HorizontalMove := NewPosition.X - FPosition.X;
  VerticalMove := NewPosition.Y - FPosition.Y;

  Result := inherited CanMoveTo(NewPosition) and
            (Abs(VerticalMove)   = 2) and
            (Abs(HorizontalMove) = 1) or
            (Abs(VerticalMove)   = 1) and
            (Abs(HorizontalMove) = 2);
end;

procedure TKnight.GetPicture(var Head, Body, Feet: string);
begin
  Head := ' /^^^\ ';
  Body := ' \_/ | ';
  Feet := '  /K | ';
end;

{ --- TQueen --- }

function TQueen.CanMoveTo(NewPosition: TPosition): Boolean;
var
  VerticalMove, HorizontalMove: Integer;
begin
  HorizontalMove := NewPosition.X - FPosition.X;
  VerticalMove := NewPosition.Y - FPosition.Y;

  Result := inherited CanMoveTo(NewPosition) and
            (Abs(VerticalMove) = Abs(HorizontalMove)) or
            (VerticalMove   = 0) or
            (HorizontalMove = 0);
end;

procedure TQueen.GetPicture(var Head, Body, Feet: string);
begin
  Head := ' !!!!! ';
  Body := ' //  \ ';
  Feet := ' \ Q / ';
end;

{ --- TKing --- }

function TKing.CanMoveTo(NewPosition: TPosition): Boolean;
var
  VerticalMove, HorizontalMove: Integer;
begin
  HorizontalMove := NewPosition.X - FPosition.X;
  VerticalMove := NewPosition.Y - FPosition.Y;

  Result := inherited CanMoveTo(NewPosition) and
            (VerticalMove   in [-1, 0, 1]) and
            (HorizontalMove in [-1, 0, 1]) or
            (NewPosition.Y  in [2, 7]) and
            (VerticalMove = 0) and
            not FHasBeenMoved;
end;

procedure TKing.GetPicture(var Head, Body, Feet: string);
begin
  Head := '  _+_  ';
  Body := ' //  \ ';
  Feet := ' \ K / ';
end;

{ --- TRook --- }

function TRook.CanMoveTo(NewPosition: TPosition): Boolean;
var
  VerticalMove, HorizontalMove: Integer;
begin
  HorizontalMove := NewPosition.X - FPosition.X;
  VerticalMove := NewPosition.Y - FPosition.Y;

  Result := inherited CanMoveTo(NewPosition) and
            (VerticalMove   = 0) or
            (HorizontalMove = 0);
end;

procedure TRook.GetPicture(var Head, Body, Feet: string);
begin
  Head := '\/\_/\/';
  Body := ' |   | ';
  Feet := ' | R | ';
end;

{ --- TPawn --- }

function TPawn.CanMoveTo(NewPosition: TPosition): Boolean;
var
  VerticalMove, HorizontalMove: Integer;
begin
  HorizontalMove := NewPosition.X - FPosition.X;
  VerticalMove := NewPosition.Y - FPosition.Y;

  if FColor = White then
    Result := inherited CanMoveTo(NewPosition)   and
              (HorizontalMove in [-1, 0, 1])     and
              (VerticalMove   = 1)               or
              (HorizontalMove = 0)               and
              (VerticalMove   = 2)               and
              not FHasBeenMoved
  else
    Result := inherited CanMoveTo(NewPosition)   and
              (HorizontalMove in [-1, 0, 1])     and
              (VerticalMove   = -1)              or
              (HorizontalMove =  0)              and
              (VerticalMove   = -2)              and
              not FHasBeenMoved;
end;

procedure TPawn.GetPicture(var Head, Body, Feet: string);
begin
  Head := '  (^)  ';
  Body := '  / \  ';
  Feet := ' / P \ ';
end;

var
  Pieces: array[1..16] of TPiece;
  N: Integer;

begin
  ClrScr;

  Pieces[1] := TRook.Create(White, MakePosition(1, 1));

  Pieces[2] := TKnight.Create(White, MakePosition(2, 1));
  Pieces[3] := TBishop.Create(White, MakePosition(3, 1));
  Pieces[4] := TQueen.Create(White, MakePosition(4, 1));
  Pieces[5] := TKing.Create(White, MakePosition(5, 1));
  Pieces[6] := TBishop.Create(White, MakePosition(6, 1));
  Pieces[7] := TKnight.Create(White, MakePosition(7, 1));
  Pieces[8] := TRook.Create(White, MakePosition(8, 1));

  for N := 1 to 8 do
  begin
    Pieces[8 + N] := TPawn.Create(White, MakePosition(N, 2));
  end;

  for N := 1 to 16 do Pieces[N].Draw;

  for N := 1 to 16 do Pieces[N].Destroy;

  GotoXY(1, 1);
  Write('<Return>');
  ReadLn;
end.


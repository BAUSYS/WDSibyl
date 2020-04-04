program Chess;  // Properties, die auf Methoden basieren

uses
  SysUtils, Crt;

type
  TPosition = record
    X: LongInt;
    Y: LongInt;
  end;

  TColour = (Black, White);

  TPiece = class
  private
    FPosition: TPosition;
    FColour:   TColour;
  protected
    procedure GetPicture(var Head, Body, Feet: string); virtual; abstract;
  public
    constructor Create(Colour: TColour; Position: TPosition);
    destructor Destroy; override;
    function CanMoveTo(NewPosition: TPosition): Boolean; virtual;
    procedure SetPosition(NewPosition: TPosition); virtual;
    procedure Draw;
    procedure Erase;

    property Colour: TColour read FColour;
    property Position: TPosition read FPosition write SetPosition;
  end;

  TExtPiece = class(TPiece)
  private
    FHasBeenMoved: Boolean;
  public
    constructor Create(Colour: TColour; Position: TPosition);
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

  TPlayer = class
  private
    FPieces: array[1..16] of TPiece;
    FPieceCount: Integer;
    FName: PString;
  public
    constructor Create(const aName: string; Colour: TColour);
    destructor Destroy; override;

    function GetPiece(Number: Integer): TPiece;
    procedure DeletePiece(Number: Integer);
    function GetName: string;
    procedure SetName(const aName: string);

    property Name: string read GetName write SetName;
    property PieceCount: Integer read FPieceCount;
  end;

{ --- Allgemeine Prozeduren / Funktionen --- }

function MakePosition(X, Y: Integer): TPosition;
begin
  Result.X := X;
  Result.Y := Y;
end;

procedure PositionToScreen(Position: TPosition; var X, Y, Colour: Integer);
begin
  X := 2 + (Position.X - 1) * 7;
  Y := 25 - Position.Y * 3;
  if Odd(Position.X + Position.Y) then Colour := 4
  else Colour := 2;
end;

{ --- TPiece --- }

function TPiece.CanMoveTo(NewPosition: TPosition): Boolean;
begin
  Result := not (NewPosition = FPosition);
end;

constructor TPiece.Create(Colour: TColour; Position: TPosition);
begin
  FColour := Colour;
  FPosition := Position;
  Draw;
end;

destructor TPiece.Destroy;
begin
  Erase;
end;

procedure TPiece.SetPosition(NewPosition: TPosition);
begin
  Erase;
  FPosition := NewPosition;
  Draw;
end;

procedure TPiece.Draw;
var
  Row, Column, Colour: Integer;
  Head, Body, Feet: string;
begin
  PositionToScreen(FPosition, Column, Row, Colour);
  TextBackground(Colour);
  if FColour = White then TextColor(15) else TextColor(0);
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
  Row, Column, Colour: Integer;
begin
  PositionToScreen(FPosition, Column, Row, Colour);
  TextBackground(Colour);
  GotoXY(Column, Row);
  Write('       ');
  GotoXY(Column, Row + 1);
  Write('       ');
  GotoXY(Column, Row + 2);
  Write('       ');
end;

{ --- TExtPiece --- }

constructor TExtPiece.Create(Colour: TColour; Position: TPosition);
begin
  inherited Create(Colour, Position);
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

  if FColour = White then
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

{ --- TPlayer --- }

constructor TPlayer.Create(const aName: string; Colour: TColour);
var
  N, Row: Integer;
begin
  FName := NewStr(aName);

  if Colour = White then Row := 1 else Row := 8;

  FPieces[1] := TRook.Create(Colour, MakePosition(1, Row));
  FPieces[2] := TKnight.Create(Colour, MakePosition(2, Row));
  FPieces[3] := TBishop.Create(Colour, MakePosition(3, Row));
  FPieces[4] := TQueen.Create(Colour, MakePosition(4, Row));
  FPieces[5] := TKing.Create(Colour, MakePosition(5, Row));
  FPieces[6] := TBishop.Create(Colour, MakePosition(6, Row));
  FPieces[7] := TKnight.Create(Colour, MakePosition(7, Row));
  FPieces[8] := TRook.Create(Colour, MakePosition(8, Row));

  if Colour = White then Row := 2 else Row := 7;

  for N := 1 to 8 do
  begin
    FPieces[8 + N] := TPawn.Create(Colour, MakePosition(N, Row));
  end;

  FPieceCount := 16;
end;

destructor TPlayer.Destroy;
var
  N: Integer;
begin
  DisposeStr(FName);
  for N := 1 to FPieceCount do FPieces[N].Destroy;
end;

function TPlayer.GetPiece(Number: Integer): TPiece;
begin
  if (Number < 1) or (Number > FPieceCount) then Result := nil
  else Result := FPieces[Number];
end;

procedure TPlayer.DeletePiece(Number: Integer);
var
  I: Integer;
begin
  if (Number >= 1) and (Number <= FPieceCount) then
  begin
    FPieces[Number].Destroy;
    for I := Number + 1 to FPieceCount do FPieces[I - 1] := FPieces[I];
    Dec(FPieceCount);
  end;
end;

function TPlayer.GetName: string;
begin
  Result := FName^;
end;

procedure TPlayer.SetName(const aName: string);
begin
  DisposeStr(FName);
  FName := NewStr(aName);
end;

var
  WhitePlayer, BlackPlayer: TPlayer;

begin
  ClrScr;

  WhitePlayer.Create('White player', White);
  BlackPlayer.Create('Black player', Black);

  GotoXY(1, 10);
  Write('<Return>');
  ReadLn;

  WhitePlayer.Destroy;
  BlackPlayer.Destroy;
end.


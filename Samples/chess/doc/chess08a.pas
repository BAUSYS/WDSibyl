program Chess;

uses
  Crt;

type
  TPosition = record
    X: LongInt;
    Y: LongInt;
  end;

  TName = (King, Queen, Knight, Bishop, Rook, Pawn);

  TColor = (Black, White);

  TPiece = class
  private
    FName:     TName;
    FPosition: TPosition;
    FColor:    TColor;
  protected
    procedure GetPicture(var Head, Body, Feet: string);
  public
    constructor Create(Name: TName; Color: TColor; Position: TPosition);
    function CanMoveTo(NewPosition: TPosition): Boolean;
    function GetColor: TColor;
    function GetName: TName;
    function GetPosition: TPosition;
    procedure SetPosition(NewPosition: TPosition);
    procedure Draw;
    procedure Erase;
  end;

  TExtPiece = class(TPiece)
  private
    FHasBeenMoved: Boolean;
  protected
    procedure GetPicture(var Head, Body, Feet: string);
  public
    constructor Create(Name: TName; Color: TColor; Position: TPosition);
    function CanMoveTo(NewPosition: TPosition): Boolean;
    procedure SetPosition(NewPosition: TPosition);
  end;

{ --- Allgemeine Prozeduren / Funktionen --- }

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
var
  VerticalMove, HorizontalMove: Integer;
begin
  HorizontalMove := NewPosition.X - FPosition.X;
  VerticalMove := NewPosition.Y - FPosition.Y;

  if (VerticalMove = 0) and (HorizontalMove = 0) then
  begin
    Result := False;
    Exit;
  end;

  case FName of
    Queen:  Result := (Abs(VerticalMove) = Abs(HorizontalMove)) or
                      (VerticalMove   = 0) or
                      (HorizontalMove = 0);

    Knight: Result := (Abs(VerticalMove)   = 2) and
                      (Abs(HorizontalMove) = 1) or
                      (Abs(VerticalMove)   = 1) and
                      (Abs(HorizontalMove) = 2);

    Bishop: Result := Abs(VerticalMove) = Abs(HorizontalMove);
  end;
end;

function TPiece.GetColor: TColor;
begin
  Result := FColor;
end;

function TPiece.GetName: TName;
begin
  Result := FName;
end;

function TPiece.GetPosition: TPosition;
begin
  Result := FPosition;
end;

constructor TPiece.Create(Name: TName; Color: TColor; Position: TPosition);
begin
  FName := Name;
  FColor := Color;
  FPosition := Position;
end;

procedure TPiece.SetPosition(NewPosition: TPosition);
begin
  FPosition := NewPosition;
end;

procedure TPiece.GetPicture(var Head, Body, Feet: string);
begin
  case FName of
    Bishop: begin
              Head := '  //\  ';
              Body := ' //  \ ';
              Feet := ' \ B / ';
            end;

    Knight: begin
              Head := ' /^^^\ ';
              Body := ' \_/ | ';
              Feet := '  /K | ';
            end;

    Queen:  begin
              Head := ' !!!!! ';
              Body := ' //  \ ';
              Feet := ' \ Q / ';
            end;
  else
    Head := '       ';
    Body := '   ?   ';
    Feet := '       ';
  end;
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

function TExtPiece.CanMoveTo(NewPosition: TPosition): Boolean;
var
  VerticalMove, HorizontalMove: Integer;
begin
  HorizontalMove := NewPosition.X - FPosition.X;
  VerticalMove := NewPosition.Y - FPosition.Y;

  if (VerticalMove = 0) and (HorizontalMove = 0) then
  begin
    Result := False;
    Exit;
  end;

  case FName of
    King:   Result := (VerticalMove   in [-1, 0, 1]) and
                      (HorizontalMove in [-1, 0, 1]) or
                      (NewPosition.Y  in [2, 7]) and
                      (VerticalMove = 0) and
                      not FHasBeenMoved;

    Rook:   Result := (VerticalMove   = 0) or
                      (HorizontalMove = 0);

    Pawn:   begin
              if FColor = White then
                Result := (HorizontalMove in [-1, 0, 1]) and
                          (VerticalMove   = 1) or
                          (HorizontalMove = 0) and
                          (VerticalMove   = 2) and
                          not FHasBeenMoved
              else
                Result := (HorizontalMove in [-1, 0, 1]) and
                          (VerticalMove   = -1) or
                          (HorizontalMove =  0) and
                          (VerticalMove   = -2) and
                          not FHasBeenMoved;
            end;
  end;
end;

constructor TExtPiece.Create(Name: TName; Color: TColor; Position: TPosition);
begin
  inherited Create(Name, Color, Position);
  FHasBeenMoved := False;
end;

procedure TExtPiece.SetPosition(NewPosition: TPosition);
begin
  inherited SetPosition(NewPosition);
  FHasBeenMoved := True;
end;

procedure TExtPiece.GetPicture(var Head, Body, Feet: string);
begin
  case FName of
    King: begin
            Head := '  _+_  ';
            Body := ' //  \ ';
            Feet := ' \ K / ';
          end;

    Pawn: begin
            Head := '  (^)  ';
            Body := '  / \  ';
            Feet := ' / P \ ';
          end;

    Rook: begin
            Head := '\/\_/\/';
            Body := ' |   | ';
            Feet := ' | R | ';
          end;
  else
    Head := '       ';
    Body := '   ?   ';
    Feet := '       ';
  end;
end;

var
  Pieces: array[1..5] of TPiece;
  ExtPieces: array[1..11] of TExtPiece;

  N: Integer;
  P: TPosition;

begin
  ClrScr;

  ExtPieces[1].Create(Rook, White, MakePosition(1, 1));
  Pieces   [1].Create(Knight, White, MakePosition(2, 1));
  Pieces   [2].Create(Bishop, White, MakePosition(3, 1));
  Pieces   [3].Create(Queen, White, MakePosition(4, 1));
  ExtPieces[2].Create(King, White, MakePosition(5, 1));
  Pieces   [4].Create(Bishop, White, MakePosition(6, 1));
  Pieces   [5].Create(Knight, White, MakePosition(7, 1));
  ExtPieces[3].Create(Rook, White, MakePosition(8, 1));

  for N := 1 to 8 do ExtPieces[3 + N].Create(Pawn, White, MakePosition(N, 2));

  for N := 1 to 5 do Pieces[N].Draw;
  for N := 1 to 11 do ExtPieces[N].Draw;

  for N := 1 to 5 do Pieces[N].Destroy;
  for N := 1 to 11 do ExtPieces[N].Destroy;

  GotoXY(1, 1);
  Write('<Return>');
  ReadLn;
end.


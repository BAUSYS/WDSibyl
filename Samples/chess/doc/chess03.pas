program Chess;

type
  TPosition = record
    X: LongInt;
    Y: LongInt;
  end;

  TName = (King, Queen, Knight, Bishop, Rook, Pawn);

  TColor = (Black, White);

  TPiece = class
    Name:     TName;
    Position: TPosition;
    Color:    TColor;
  end;

  TExtPiece = class(TPiece)
    HasBeenMoved: Boolean;
  end;

function MakePosition(X, Y: Integer): TPosition;
begin
  Result.X := X;
  Result.Y := Y;
end;

function CanMoveTo(Piece: TPiece; NewPosition: TPosition): Boolean;
var
  VerticalMove, HorizontalMove: Integer;
begin
  HorizontalMove := NewPosition.X - Piece.Position.X;
  VerticalMove := NewPosition.Y - Piece.Position.Y;

  if (VerticalMove = 0) and (HorizontalMove = 0) then
  begin
    Result := False;
    Exit;
  end;

  case Piece.Name of
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

function ExtCanMoveTo(Piece: TExtPiece; NewPosition: TPosition): Boolean;
var
  VerticalMove, HorizontalMove: Integer;
begin
  HorizontalMove := NewPosition.X - Piece.Position.X;
  VerticalMove := NewPosition.Y - Piece.Position.Y;

  if (VerticalMove = 0) and (HorizontalMove = 0) then
  begin
    Result := False;
    Exit;
  end;

  case Piece.Name of
    King:   Result := (VerticalMove   in [-1, 0, 1]) and
                      (HorizontalMove in [-1, 0, 1]) or
                      (NewPosition.Y  in [2, 7]) and
                      (VerticalMove = 0) and
                      not Piece.HasBeenMoved;

    Rook:   Result := (VerticalMove   = 0) or
                      (HorizontalMove = 0);

    Pawn:   begin
              if Piece.Color = White then
                Result := (HorizontalMove in [-1, 0, 1]) and
                          (VerticalMove   = 1) or
                          (HorizontalMove = 0) and
                          (VerticalMove   = 2) and
                          not Piece.HasBeenMoved
              else
                Result := (HorizontalMove in [-1, 0, 1]) and
                          (VerticalMove   = -1) or
                          (HorizontalMove =  0) and
                          (VerticalMove   = -2) and
                          not Piece.HasBeenMoved;
            end;
  end;
end;

begin
end.


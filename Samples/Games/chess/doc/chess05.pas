program Chess;

type
  TPosition = record
    X: LongInt;
    Y: LongInt;
  end;

  TName = (King, Queen, Knight, Bishop, Rook, Pawn);

  TColor = (Black, White);

  TPiece = class
    FName:     TName;
    FPosition: TPosition;
    FColor:    TColor;
    function CanMoveTo(NewPosition: TPosition): Boolean;
    function GetColor: TColor;
    function GetName: TName;
    function GetPosition: TPosition;
    procedure Initialize(Name: TName; Color: TColor; Position: TPosition);
    procedure SetPosition(NewPosition: TPosition);
  end;

  TExtPiece = class(TPiece)
    FHasBeenMoved: Boolean;
    function CanMoveTo(NewPosition: TPosition): Boolean;
    procedure Initialize(Name: TName; Color: TColor; Position: TPosition);
    procedure SetPosition(NewPosition: TPosition);
  end;

function MakePosition(X, Y: Integer): TPosition;
begin
  Result.X := X;
  Result.Y := Y;
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

procedure TPiece.Initialize(Name: TName; Color: TColor; Position: TPosition);
begin
  FName := Name;
  FColor := Color;
  FPosition := Position;
end;

procedure TPiece.SetPosition(NewPosition: TPosition);
begin
  FPosition := NewPosition;
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

procedure TExtPiece.Initialize(Name: TName; Color: TColor; Position: TPosition);
begin
  inherited Initialize(Name, Color, Position);
  FHasBeenMoved := False;
end;

procedure TExtPiece.SetPosition(NewPosition: TPosition);
begin
  inherited SetPosition(NewPosition);
  FHasBeenMoved := True;
end;

begin
end.


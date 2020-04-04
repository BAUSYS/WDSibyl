program Chess;

type
  TPosition = record
    X: LongInt;
    Y: LongInt;
  end;

  TName = (King, Queen, Knight, Bishop, Rook, Pawn);

  TColour = (Black, White);

  TPiece = class
  private
    FName:     TName;
    FPosition: TPosition;
    FColour:   TColour;
  public
    constructor Create(Name: TName; Colour: TColour; Position: TPosition);
    function CanMoveTo(NewPosition: TPosition): Boolean;
    function GetColour: TColour;
    function GetName: TName;
    function GetPosition: TPosition;
    procedure SetPosition(NewPosition: TPosition);
  end;

  TExtPiece = class(TPiece)
  private
    FHasBeenMoved: Boolean;
  public
    constructor Create(Name: TName; Colour: TColour; Position: TPosition);
    function CanMoveTo(NewPosition: TPosition): Boolean;
    procedure SetPosition(NewPosition: TPosition);
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

function TPiece.GetColour: TColour;
begin
  Result := FColour;
end;

function TPiece.GetName: TName;
begin
  Result := FName;
end;

function TPiece.GetPosition: TPosition;
begin
  Result := FPosition;
end;

constructor TPiece.Create(Name: TName; Colour: TColour; Position: TPosition);
begin
  FName := Name;
  FColour := Colour;
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
              if FColour = White then
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

constructor TExtPiece.Create(Name: TName; Colour: TColour; Position: TPosition);
begin
  inherited Create(Name, Colour, Position);
  FHasBeenMoved := False;
end;

procedure TExtPiece.SetPosition(NewPosition: TPosition);
begin
  inherited SetPosition(NewPosition);
  FHasBeenMoved := True;
end;

function MakePosition(X, Y: Integer): TPosition;
begin
  Result.X := X;
  Result.Y := Y;
end;

var
  Pieces: array[1..16] of TPiece;

  N: Integer;

begin
  WriteLn('Free memory at program start:');
  WriteLn(MemAvail, ' Byte.');

  Pieces[1] := TExtPiece.Create(Rook, White, MakePosition(1, 1));
  Pieces[2] := TPiece.Create(Knight, White, MakePosition(2, 1));
  Pieces[3] := TPiece.Create(Bishop, White, MakePosition(3, 1));
  Pieces[4] := TPiece.Create(Queen, White, MakePosition(4, 1));
  Pieces[5] := TExtPiece.Create(King, White, MakePosition(5, 1));
  Pieces[6] := TPiece.Create(Bishop, White, MakePosition(6, 1));
  Pieces[7] := TPiece.Create(Knight, White, MakePosition(7, 1));
  Pieces[8] := TExtPiece.Create(Rook, White, MakePosition(8, 1));

  for N := 1 to 8 do
  begin
    Pieces[8 + N] := TExtPiece.Create(Pawn, White, MakePosition(N, 2));
  end;

  WriteLn('Free memory after creating figures:');
  WriteLn(MemAvail, ' Byte.');

  for N := 1 to 16 do Pieces[N].Destroy;

  WriteLn('Free memory after destroying figures:');
  WriteLn(MemAvail, ' Byte.');

  Write('<Return>');
  ReadLn;
end.


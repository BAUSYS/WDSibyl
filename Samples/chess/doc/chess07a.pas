program Chess;

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
  public
    constructor Create(Name: TName; Color: TColor; Position: TPosition);
    function CanMoveTo(NewPosition: TPosition): Boolean;
    function GetColor: TColor;
    function GetName: TName;
    function GetPosition: TPosition;
    procedure SetPosition(NewPosition: TPosition);
  end;

  TExtPiece = class(TPiece)
  private
    FHasBeenMoved: Boolean;
  public
    constructor Create(Name: TName; Color: TColor; Position: TPosition);
    function CanMoveTo(NewPosition: TPosition): Boolean;
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

function MakePos(X, Y: Integer): TPosition;
begin
  Result.X := X;
  Result.Y := Y;
end;

var
  Pieces: array[1..5] of TPiece;
  ExtPieces: array[1..11] of TExtPiece;

  N: Integer;

begin
  WriteLn('Free memory at program start:');
  WriteLn(MemAvail, ' Byte.');

  ExtPieces[1].Create(Rook, White, MakePos(1, 1));
  Pieces   [1].Create(Knight, White, MakePos(2, 1));
  Pieces   [2].Create(Bishop, White, MakePos(3, 1));
  Pieces   [3].Create(Queen, White, MakePos(4, 1));
  ExtPieces[2].Create(King, White, MakePos(5, 1));
  Pieces   [4].Create(Bishop, White, MakePos(3, 1));
  Pieces   [5].Create(Knight, White, MakePos(2, 1));
  ExtPieces[3].Create(Rook, White, MakePos(2, 1));

  for N := 1 to 8 do ExtPieces[3 + N].Create(Pawn, White, MakePos(N, 2));

  WriteLn('Free memory after creating figures:');
  WriteLn(MemAvail, ' Byte.');

  for N := 1 to 5 do Pieces[N].Destroy;
  for N := 1 to 11 do ExtPieces[N].Destroy;

  WriteLn('Free memory after destroying figures:');
  WriteLn(MemAvail, ' Byte.');

  Write('<Return>');
  ReadLn;
end.


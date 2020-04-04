program Chess;  // Properties, basing onto methods

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
    function CanRochadeWith(Piece: TPiece): Boolean;
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
    procedure DeletePiece(aPiece: TPiece);
    function GetName: string;
    procedure SetName(const aName: string);

    property Name: string read GetName write SetName;
    property PieceCount: Integer read FPieceCount;
    property Pieces[Number: Integer]: TPiece read GetPiece;
  end;

  TBoard = class
  private
    FPlayers: array[Black..White] of TPlayer;
    FCurrentPlayer, FWaitingPlayer: TColour;
  public
    constructor Create(const WhiteName, BlackName: string);
    destructor Destroy; override;
    procedure Play;
  protected
    function GetPlayer(Colour: TColour): TPlayer;
    function GetField(Position: TPosition): TPiece;

    function LegalMove(Colour: TColour; Start, Dest: TPosition): Boolean;
    function IsCheck(Colour: TColour): Boolean;

    procedure NextPlayer;
    procedure PerformMove(A, B: TPosition);
    procedure DrawScreen;
    procedure ShowWelcomeMessage;

    procedure ShowMessage(const Msg: string);
    procedure EnterMove(var Start, Dest: TPosition);

    property CurrentPlayer: TColour read FCurrentPlayer;
    property WaitingPlayer: TColour read FWaitingPlayer;

    property Players[Colour: TColour]: TPlayer read GetPlayer;
    property Fields[Position: TPosition]: TPiece read GetField;
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

function EnterPosition: TPosition;
var
  A, B: Char;
begin
  repeat
    A := UpCase(ReadKey);
  until A in ['A'..'H'];
  Write(A);
  Beep(1000, 50);

  repeat
    B := UpCase(ReadKey);
  until B in ['1'..'8'];
  Write(B);
  Beep(1000, 50);

  Result := MakePosition(Ord(A) - 64, Ord(B) - 48);
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
            (NewPosition.X  in [2, 7]) and
            (VerticalMove = 0) and
            not FHasBeenMoved;
end;

function TKing.CanRochadeWith(Piece: TPiece): Boolean;
begin
  Result := (Piece is TRook) and (Piece.Colour = Colour) or
            not (FHasBeenMoved or Piece as TExtPiece.FHasBeenMoved);
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

procedure TPlayer.DeletePiece(aPiece: TPiece);
var
  Number: Integer;
begin
  Number := 1;
  while (Pieces[Number] <> aPiece) and (Number <= PieceCount) do Inc(Number);
  if Number > PieceCount then Exit;

  FPieces[Number].Destroy;
  for Number := Number + 1 to FPieceCount do FPieces[Number - 1] := FPieces[Number];
  Dec(FPieceCount);
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

{ --- TBoard --- }

constructor TBoard.Create(const WhiteName, BlackName: string);
begin
  TextBackground(Blue);
  ClrScr;
  TextBackground(0);
  Window(59, 2, 79, 24);
  ClrScr;
  Window(1, 1, 80, 25);

  FPlayers[White].Create(WhiteName, White);
  FPlayers[Black].Create(BlackName, Black);

  FCurrentPlayer := White;
  FWaitingPlayer := Black;

  DrawScreen;
  ShowWelcomeMessage;
end;

destructor TBoard.Destroy;
begin
  FPlayers[White].Destroy;
  FPlayers[Black].Destroy;
end;

procedure TBoard.DrawScreen;
var
  Row, Column, X, Y, Colour: Integer;
begin
  for Row := 3 to 6 do
  begin
    for Column := 1 to 8 do
    begin
      PositionToScreen(MakePosition(Column, Row), X, Y, Colour);
      TextBackground(Colour);
      GotoXY(X, Y    ); Write('       ');
      GotoXY(X, Y + 1); Write('       ');
      GotoXY(X, Y + 2); Write('       ');
    end;
  end;

  TextColor(Yellow);
  TextBackground(Blue);
  for X := 1 to 8 do
  begin
    GotoXY(1, 26 - 3 * X); Write((X));
    GotoXY(7 * X - 2, 25);     Write(Chr(64 + X));
  end;
end;

procedure TBoard.ShowWelcomeMessage;
begin
  ShowMessage('- CHESS -');
  ShowMessage('');
  ShowMessage('WDSibyl');
  ShowMessage('Demo-Program for');
  ShowMessage('object-oriented');
  ShowMessage('Programming');
  ShowMessage('');
  ShowMessage('Ctrl-C for Escape.');
  ShowMessage('');
  ShowMessage('White player:');
  ShowMessage('  ' + Players[White].Name);
  ShowMessage('');
  ShowMessage('Black player:');
  ShowMessage('  ' + Players[Black].Name);
  ShowMessage('');
end;

function TBoard.GetPlayer(Colour: TColour): TPlayer;
begin
  Result := FPlayers[Colour];
end;

function TBoard.GetField(Position: TPosition): TPiece;
var
  Colour: TColour;
  Player: TPlayer;
  Number: Integer;
begin
  for Colour := Black to White do
  begin
    Player := GetPlayer(Colour);
    for Number := 1 to Player.PieceCount do
    begin
      Result := Player.Pieces[Number];
      if Result.Position = Position then Exit;
    end;
  end;
  Result := nil;
end;

function TBoard.LegalMove(Colour: TColour; Start, Dest: TPosition): Boolean;
var
  Piece, Victim: TPiece;
  Temp: TPosition;
  HorizMove, VertiMove: Integer;
begin
  Result := False;

  Piece := Fields[Start];

  if Piece = nil then Exit;
  if Piece.Colour <> Colour then Exit;
  if not Piece.CanMoveTo(Dest) then Exit;

  Victim := Fields[Dest];
  if (Victim <> nil) and (Victim.Colour = Colour) then Exit;

  if Piece is TKnight then
  begin
    Result := True;
    Exit;  // Pferde k”nnen springen
  end;

  { Alle anderen mssen freie Bahn haben }

  HorizMove := Dest.X - Start.X;
  if HorizMove > 0 then HorizMove := 1
  else if HorizMove < 0 then HorizMove := -1;

  VertiMove := Dest.Y - Start.Y;
  if VertiMove > 0 then VertiMove := 1
  else if VertiMove < 0 then VertiMove := -1;

  Temp := Piece.FPosition;

  Temp.X := Temp.X + HorizMove;
  Temp.Y := Temp.Y + VertiMove;

  while Temp <> Dest do
  begin
    if Fields[Temp] <> nil then Exit;
    Temp.X := Temp.X + HorizMove;
    Temp.Y := Temp.Y + VertiMove;
  end;

  if Piece is TPawn then
  begin
    if (HorizMove <> 0) and (Victim =  nil) or
       (HorizMove =  0) and (Victim <> nil) then Exit;
  end;

  if (Piece is TKing) and (Abs(Dest.X - Start.X) > 1) then
  begin
    if Dest.X = 2 then Temp.X := 1 else Temp.X := 8;
    Temp.Y := Dest.Y;
    if not TKing(Piece).CanRochadeWith(Fields[Temp]) then Exit;
  end;

  Result := True;
end;

procedure TBoard.NextPlayer;
var
  Temp: TColour;
begin
  Exit;

  Temp := FCurrentPlayer;
  FCurrentPlayer := FWaitingPlayer;
  FWaitingPlayer := Temp;
  ShowMessage('Move: ' + Players[CurrentPlayer].Name);
  ShowMessage('');
end;

procedure TBoard.ShowMessage(const Msg: string);
begin
  Window(60, 2, 78, 24);
  TextBackground(0);
  TextColor(15);
  GotoXY(1, 23);
  WriteLn(Msg);
  Window(1, 1, 80, 25);
end;

function TBoard.IsCheck(Colour: TColour): Boolean;
var
  N: Integer;
  KingPos: TPosition;
begin
  Result := False;

  with FPlayers[Colour] do
  begin
    for N := 1 to PieceCount do if Pieces[N] is TKing then
    begin
      KingPos := Pieces[N].FPosition;
      ShowMessage('King found.');
      Break;
    end;
  end;

  if Colour = White then Colour := Black else Colour := White;

  with FPlayers[Colour] do
  begin
    for N := 1 to PieceCount do if LegalMove(Colour, Pieces[N].FPosition, KingPos) then
    begin
      ShowMessage('King in danger.');
      Result := True;
      Exit;
    end;
  end;

  Result := False;
end;

procedure TBoard.EnterMove(var Start, Dest: TPosition);
begin
  Window(60, 2, 78, 24);
  TextBackground(0);
  TextColor(15);
  GotoXY(1, 23);
  Write('Your move: ');
  Start := EnterPosition;
  Write (' - ');
  Dest := EnterPosition;
  WriteLn;
  Window(1, 1, 80, 25);
end;

procedure TBoard.PerformMove(A, B: TPosition);
var
  Actor, Victim: TPiece;
begin
  Actor := Fields[A];
  Victim := Fields[B];

  if Victim <> nil then
  begin
    { Gegnerische Figur schlagen }
    ShowMessage('Touche! :-)');
    Players[WaitingPlayer].DeletePiece(Victim);
  end;

  Actor.Position := B;

  if (Actor is TKing) and (Abs(B.X - A.X) > 1) then
  begin
    ShowMessage('Rochade.');
    if B.X = 2 then
    begin
      A.X := 4;
      B.X := 1;
    end
    else
    begin
      A.X := 6;
      B.X := 8;
    end;
    Fields[B].Position := A;
  end;
end;

procedure TBoard.Play;
var
  A, B: TPosition;
  Actor, Victim: TPiece;
  N: Integer;
  L: Boolean;
begin
  repeat
    { Solange Zug eingeben bis erlaubt. }

    repeat
      EnterMove(A, B);
      L := LegalMove(CurrentPlayer, A, B);
      if not L then
      begin
        ShowMessage('Illegal move!');
        ShowMessage('');
      end;
    until L;

    PerformMove(A, B);

    if IsCheck(WaitingPlayer) then ShowMessage('Chess!');

    NextPlayer;
  until False;
end;

var
  Board: TBoard;

begin
  Board.Create('White', 'Black');
  Board.Play;
  Board.Destroy;
end.


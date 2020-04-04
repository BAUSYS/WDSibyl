Program Os2Chess;

Uses
  Forms, Graphics,
  ChessU1, ChessOpt;

{$r Os2Chess.scu}

Begin
  Application.Create;
  Application.CreateForm (TChessForm, ChessForm);
  Application.Run;
  Application.Destroy;
End.

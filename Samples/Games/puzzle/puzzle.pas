program Puzzle;

uses
  Forms, Graphics, PuzzleU1;

{$r Puzzle.scu}

begin
  Application.Create;
  Application.CreateForm (TPuzzleForm, PuzzleForm);
  Application.Run;
  Application.Destroy;
end.

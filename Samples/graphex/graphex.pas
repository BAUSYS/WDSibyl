Program GraphEx;

Uses
  Forms, Graphics, GraphWin, MainTool, BrshTool, PenTool, ColTool, NewImage;

{$r GraphEx.scu}

Begin
  Application.Create;
  Application.CreateForm (TGraphExForm, GraphExForm);
  Application.Run;
  Application.Destroy;
End.

Program DragDrop;

Uses
  Forms, Graphics, DrgDrpU1;

{$r DragDrop.scu}

Begin
  Application.Create;
  Application.CreateForm (TDragDropForm, DragDropForm);
  Application.Run;
  Application.Destroy;
End.

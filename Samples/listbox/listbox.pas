Program ListBox;

Uses
  Forms, Graphics, ListU1;

{$r ListBox.scu}

Begin
  Application.Create;
  Application.CreateForm (TOwnerDrawListBoxForm, OwnerDrawListBoxForm);
  Application.Run;
  Application.Destroy;
End.

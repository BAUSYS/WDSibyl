Program Editor;
          
Uses
  Forms, Graphics, EditU1;

{$r Editor.scu}

Begin
  Application.Create;
  Application.CreateForm (TForm1, Form1);
  Application.Run;
  Application.Destroy;
End.

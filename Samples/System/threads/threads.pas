Program Threads;

Uses
  Forms, SortForm;

{$r Threads.scu}

Begin
  Application.Create;
  Application.CreateForm (TThreadSortForm, ThreadSortForm);
  Application.Run;
  Application.Destroy;
End.
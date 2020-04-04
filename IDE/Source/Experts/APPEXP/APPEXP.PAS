Program AppExp;
     
Uses         
  Forms, uAppExp;

Begin        
  Application.Create;
  Application.CreateForm (TAppExpertDlg0, AppExpertDlg0);
  Application.Run;
  Application.Destroy;
End.

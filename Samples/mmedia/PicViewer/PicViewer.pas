Program PicViewer;
             
Uses sysUtils, WinCrt, ComCtrls,
  Forms, Graphics, 
  uPicViewer;
                        
{$r PicViewer.scu}

Var FSections:THeaderSections;
         
Begin
  Application.Create;
  Application.CreateForm(TfrmPicViewer, frmPicViewer);
  Application.Run;
  Application.Destroy;
End.

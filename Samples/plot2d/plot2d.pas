Program plot2d;

Uses Forms, Graphics, XY, about;

{$r plot2d.scu}

var
  t : longint;
Begin
  Application.Create;
  Application.CreateForm (TXYplot, XYPlot);
  Application.CreateForm (TAboutForm, AboutForm);
  getmem(xyplot.xdata,sizeof(double)*1000);
  getmem(xyplot.ydata,sizeof(double)*1000);
  xyplot.nrp:=1000;
  for t:=1 to 1000 do
  begin
    xyplot.xdata^[t]:=t/5.0-100;
    xyplot.ydata^[t]:=10.0*sin(t/1000.0*2*pi);
  end;
  AboutForm.ShowModal;
  Application.Run;
  Application.Destroy;
End.

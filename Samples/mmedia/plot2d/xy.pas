Unit XY;

Interface

Uses Classes, Forms, Graphics, ExtCtrls,Axes, Buttons, StdCtrls,
     Color;

Type
  TXYFrame =
        Class (TObject)
          userx    : boolean;
          remxleft,
          remxright : double;
          backcolor,
          boxcolor : TColor;
          X,Y  : Tax;
          constructor Create;
          procedure Draw(width,height:integer;canvas:TCanvas);
          function XYScale(px,py:double):TPoint;
          function ScaleXY(sx,sy:integer;var px,py:double):boolean;
          procedure setuserx(left,right:double);
          procedure resetx;
        end;

  tdarray = array [1..maxint] of double;
  pdarray = ^tdarray;
  TXYplot = Class (TForm)
    xdata,
    ydata       : pdarray;
    nrp         : longint;
    XY          : TXYFrame;
    DrawArea    : TPaintBox;
    ContourPanel: TPanel;
    Printerlist : TComboBox;
    Button1     : TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    XisTime: TCheckBox;
      ResetAxes: TButton;
    Label1: TLabel;
    Messages: TPanel;
    date_time: TPanel;
    Interval: TEdit;
    Min: TRadioButton;
    Hour: TRadioButton;
    Day: TRadioButton;
    Week: TRadioButton;
    Mnth: TRadioButton;
    Year: TRadioButton;
    UserInterval: TCheckBox;
    Xleft: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Xright: TSpeedButton;
    ClockTimer: TTimer;
    Procedure UpdateX (Sender: TObject);
    Procedure XrightOnClick (Sender: TObject);
    Procedure XleftOnClick (Sender: TObject);
    Procedure UserIntervalOnClick (Sender: TObject);
      PROCEDURE ResetAxesOnClick (Sender: TObject);
      PROCEDURE DrawAreaOnMouseClick (Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X: LongInt; Y: LongInt);
    Procedure ClockTimerOnTimer (Sender: TObject);
    Procedure DrawAreaOnMouseMove (Sender: TObject; Shift: TShiftState;
      X: LongInt; Y: LongInt);
    Procedure XisTimeOnClick (Sender: TObject);
    Procedure Timer1OnTimer (Sender: TObject);
    Procedure Button2OnClick (Sender: TObject);
    Procedure Button1OnClick (Sender: TObject);
    Procedure PrinterlistOnItemSelect (Sender: TObject; Index: LongInt);
    Procedure ComboBox1OnSetupShow (Sender: TObject);
    Procedure SpeedButton1OnClick (Sender: TObject);
    Procedure DrawAreaOnPaint (Sender: TObject; Const rec: TRect);
    Procedure ContourWindowOnCreate (Sender: TObject);
  Public
    procedure DrawXY(canvas:TCanvas;dnr:longint;var x,y: array of double);virtual;
  Private
    {Insert private declarations here}
    {Insert public declarations here}
  End;

VAR
  XYPlot : TXYPlot;

Implementation

uses printers,pmgpi,sysutils;

constructor TXyFrame.Create;
begin
  X:=Tax.Create;
  x.settitle('This is the X-axis');
  Y:=Tax.Create;
  y.settitle('This is the Y-axis');
  backcolor:=clWhite;
  boxcolor:=clWhite;
  userx:=false;
end;

function TXYFrame.XYScale(px,py:double):TPoint;
begin
  with X do
    xyscale.x:=round((px-workl)/(workr-workl)*length)+start;
  with Y do
    xyscale.y:=round((py-workl)/(workr-workl)*length)+start;
end;

function TXYFrame.ScaleXY(sx,sy:integer;var px,py:double):boolean;
begin
  scalexy:=false;
  with X do
    if (sx>=start) and (sx<=start+length) then
    begin
      px:=(sx-start)/length*(workr-workl)+workl;
      with Y do
        if (sy>=start) and (sy<=start+length) then
        begin
          py:=(sy-start)/length*(workr-workl)+workl;
          scalexy:=true;
        end;
    end;
end;

procedure tXYFrame.setuserx;
begin
  if not userx then
    with x do
    begin
      remxleft:=x.left;
      remxright:=x.right;
    end;
  x.left:=left;
  x.right:=right;
  userx:=true;
end;

procedure tXYFrame.resetx;
begin
  if userx then
   with x do
   begin
    left:=remxleft;
    right:=remxright;
   end;
  userx:=false;
end;

procedure TXYFrame.Draw;
var
  endp,
  org : TPoint;
  wid,
  hei : longint;
begin
  org.x:=Width div 8;org.y:=Height div 8;
  wid:=width div 4*3;hei:=Height div 4*3;
  endp.x:=org.x+wid;endp.y:=org.y+hei;
  x.setscalecoord(org,endp,true);
  y.setscalecoord(org,endp,false);
  canvas.FillRect(rect(0,0,width,height),backcolor);
  if boxcolor<>backcolor then
    canvas.FillRect(rect(org.x,org.y,endp.x,endp.y),boxcolor);
  X.Draw(canvas);
  Y.Draw(canvas);
  canvas.SetClipRegion(rect(org.x,org.y,endp.x,endp.y));
end;

procedure TXYPlot.DrawXY;
var
  broken : boolean;
  func,
  step   : longint;
  px,py  : double;
  t      : TPoint;
begin
{
  with canvas do
  begin
    pen.color:=colors[1];
    pen.width:=widths[1];
    pen.style:=styles[1];
  end;
}
  with canvas.pen do
  begin
    color:=clBlack;
    style:=psSolid;
    width:=2;
  end;

  broken:=true;
   for step:=0 to dnr-1 do
   begin
    px:=x[step];
    py:=y[step];
    if py<1E30 then
    begin
      t:=xy.XYScale(px,py);
      if broken then
      begin
        canvas.moveto(t.x,t.y);
        broken:=false;
      end
      else
        canvas.lineto(t.x,t.y);
    end
    else
      broken:=true;;
    inc(step);
   end;
end;

Procedure TXYplot.UpdateX (Sender: TObject);
var
  int : double;
  ok : integer;
Begin
  Val(interval.text,int,ok);
  if ok<>0 then exit;
  with xy.x do
  begin
    if min.checked then right:=left+int*1/24/60;
    if hour.checked then right:=left+int*1/24;
    if day.checked then right:=left+int;
    if week.checked then right:=left+int*7;
    if mnth.checked then right:=left+int*31;
    if year.checked then right:=left+int*365;
  end;
  drawarea.repaint;
End;

Procedure TXYplot.XrightOnClick (Sender: TObject);
var
  diff : double;
Begin
  with xy.x do
  begin
    diff:=right-left;
    xy.setuserx(right,right+diff);
  end;
  drawarea.repaint;
End;

Procedure TXYplot.XleftOnClick (Sender: TObject);
var
  diff : double;
Begin
  with xy.x do
  begin
    diff:=right-left;
    xy.setuserx(left-diff,left);
  end;
  drawarea.repaint;
End;

Procedure TXYplot.UserIntervalOnClick (Sender: TObject);
Begin
  interval.enabled:=userinterval.checked;
  min.enabled:=userinterval.checked;
  hour.enabled:=userinterval.checked;
  day.enabled:=userinterval.checked;
  week.enabled:=userinterval.checked;
  mnth.enabled:=userinterval.checked;
  year.enabled:=userinterval.checked;
  if userinterval.checked then
  begin
    xy.setuserx(xy.x.left,xy.x.right);
    UpdateX(Sender);
  end
  else
  begin
    ResetAxesOnClick(Sender);
  end;
End;

PROCEDURE TXYplot.ResetAxesOnClick (Sender: TObject);
BEGIN
 xy.resetx;
 with xy.x do
 begin
   workl:=left;workr:=right;
   zoom:=1;offs:=0;
 end;
 with xy.y do
 begin
   workl:=left;workr:=right;
   zoom:=1;offs:=0;
 end;
 drawarea.repaint;
END;

PROCEDURE TXYplot.DrawAreaOnMouseClick (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X: LongInt; Y: LongInt);
var
  px,py : double;
BEGIN
  if xy.scalexy(x,y,px,py) then
  begin
    if button =mbLeft then
      xy.x.zoom:=xy.x.zoom/2
    else
      xy.x.zoom:=xy.x.zoom*2;
    with xy.x do
      offs:=(px-left)/(right-left)-zoom/2;
    if button=mbLeft then
      xy.y.zoom:=xy.y.zoom/2
    else
      xy.y.zoom:=xy.y.zoom*2;
    with xy.y do
      offs:=(py-left)/(right-left)-zoom/2;
  end;
  drawarea.repaint;
END;

Procedure TXYplot.ClockTimerOnTimer (Sender: TObject);
var
  tim : double;
Begin
  tim:=now;
  date_time.caption:=formatdatetime('D/mmm/yy hh:mm:ss',now);
End;

Procedure TXYplot.DrawAreaOnMouseMove (Sender: TObject; Shift: TShiftState;
  X: LongInt; Y: LongInt);
var
  s1,s2 : string;
  px,py : double;
Begin
  if xy.Scalexy(x,y,px,py) then
  begin
    str(px:0:1,s1);str(py:0:1,s2);
    messages.caption:=s1+' '+s2;
  end
  else
    messages.caption:='';;
End;

Procedure TXYplot.XisTimeOnClick (Sender: TObject);
Begin
  if xistime.checked then
    xy.x.setstyle(true,'d/mmm/yy hh:mm')
  else
  begin
    xy.x.setstyle(false,'0.0');
    userinterval.checked:=false;
    userintervalonclick(sender);
  end;
  drawarea.repaint;
  userinterval.enabled:=xistime.checked;
End;

Procedure TXYplot.Timer1OnTimer (Sender: TObject);
Begin
  if printer.printing then
    messages.caption:='Printing';
End;

Procedure TXYplot.Button2OnClick (Sender: TObject);
Begin
  Printer.OptionsDlg;
End;

Procedure TXYplot.Button1OnClick (Sender: TObject);
var
  endp,
  org : TPoint;
  wid,
  hei : longint;
Begin
  messages.caption:='Printing...';
  messages.update;
  Printer.BeginDoc;
  GpiCreateLogColorTable(Printer.Canvas.Handle,
                         LCOL_RESET,
                         LCOLF_RGB,
                         0,
                         0,
                         Nil);

  with printer do
    XY.draw(pagewidth,pageheight,canvas);
  drawxy(printer.canvas,nrp,xdata^,ydata^);
  Printer.EndDoc;
  messages.caption:='';
End;

Procedure TXYplot.PrinterlistOnItemSelect (Sender: TObject; Index: LongInt);
Begin
  printer.printerindex:=index;
End;

Procedure TXYplot.ComboBox1OnSetupShow (Sender: TObject);
Begin
  printerlist.Items:=Printer.Printers;
  printerlist.seltext:=printerlist.items[printer.printerindex];
End;

Procedure TXYplot.SpeedButton1OnClick (Sender: TObject);
Begin
End;

Procedure TXYplot.DrawAreaOnPaint (Sender: TObject; Const rec: TRect);
var
  endp,
  org : TPoint;
  wid,
  hei : longint;
Begin
  xy.draw(drawarea.width,drawarea.height,drawarea.canvas);
  drawxy(drawarea.canvas,nrp,xdata^,ydata^);
End;

Procedure TXYplot.ContourWindowOnCreate (Sender: TObject);
Begin
  XY:=TXYFrame.Create;
  messages.caption:='Welcome!';
  clocktimer.start;
  nrp:=0;
End;

Initialization
  RegisterClasses ([TXYplot, TPaintBox, TPanel, TComboBox, TButton, TCheckBox,
    TLabel, TTimer, TGroupBox, TEdit, TRadioButton, TSpeedButton]);
End.

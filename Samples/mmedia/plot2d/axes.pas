unit axes;

interface

Uses
  Classes, Forms, Graphics, ExtCtrls, Buttons, StdCtrls,
  Color;

TYPE
  TAx = Class (TObject)
          zoom,
          offs,
          workr,
          workl,
          left,
          right : double;
          grcolor,
          color : TColor;
          grstyle,
          style : TPenStyle;
          grwidth,
          width,
          marks,
          ticks : integer;
          OrgP,
          EndP  : TPoint;
          length,
          start : longint;
          pr,
          horiz,
          istime,
          grid,
          Log   : boolean;
          format,
          NrFont,
          Titlefont  : String[80];
          Title      : String;
          NrFontSz,
          TitleFontSz: integer;
          constructor Create;
          procedure Draw(canvas:TCanvas);
          procedure SetTitle(s:string);
          procedure SetStyle(usetim:boolean;fmt:string);
          procedure SetScaleCoord(axorg,axend:TPoint;hor:boolean);
          procedure SetAlign(horiz:boolean;startx,starty,length:longint);
          function Scale(value:double):tpoint;
        end;

implementation

uses sysutils,printers,pmgpi;

procedure Tax.SetStyle;
begin
  istime:=usetim;
  format:=fmt;
end;

function Tax.Scale(value:double):tpoint;
begin
  if horiz then
  begin
    scale.x:=round((value-workl)/(workr-workl)*length)+start;
    scale.y:=orgp.y;
  end
  else
  begin
    scale.y:=round((value-workl)/(workr-workl)*length)+start;
    scale.x:=orgp.x;
  end;
end;

constructor Tax.Create;
begin
  length:=1;
  orgp:=point(1,1);
  endp:=point(1,2);
  left:=-10;
  right:=30;
  ticks:=2;
  marks:=4;
  log:=false;
  color:=clBlack;
  Width:=1;
  Style:=psSolid;
  grid:=true;
  format:='0.0';
  istime:=false;
  grcolor:=clGray;
  grstyle:=psDot;
  grwidth:=1;
  zoom:=1;
  offs:=0;
  NrFont:='Helv';NrFontSz:=8;
  TitleFont:='Times New Roman';TitleFontSz:=10;
  Title:='';
end;

procedure Tax.Draw;

procedure Line(l,r:TPoint);
begin
  canvas.Line(l.x,l.y,r.x,r.y);
end;

var
  now,
  nowr : double;
  pp,
  p   : TPoint;
  wid,
  widt,
  t,
  tt,
  dd,
  ddd  : integer;
  s    : string;
  grad : gradientl;
  test : boolean;
Begin
  dd:=length div 100;ddd:=length div 200;
  workl:=left+offs*(right-left);
  workr:=workl+zoom*(right-left);
  with canvas do
  begin
    pen.color:=color;
    pen.width:=width;
    pen.style:=style;
  end;
  Line(scale(workl),scale(workr));
  canvas.Font:=Screen.GetFontFromPointSize(NrFont,NrFontSz);
  for t:=0 to marks do
  begin
    now:=t/marks*(workr-workl)+workl;
    p:=Scale(now);pp:=p;
    if horiz then dec(pp.y,dd) else dec(pp.x,dd);
    Line(p,pp);
    if istime then
      s:=FormatDateTime(format,now)
    else
      s:=FormatFloat(format,now);
    if horiz then
      canvas.TextOut(pp.x,pp.y-canvas.TextHeight(s),s)
    else
      canvas.TextOut(pp.x-canvas.TextWidth(s)-dd-4,pp.y,s);
    if t<>marks then
      for tt:=1 to ticks do
      begin
        nowr:=now+tt*(workr-workl)/marks/ticks;
        p:=Scale(nowr);pp:=p;
        if horiz then dec(pp.y,ddd) else dec(pp.x,ddd);
        Line(p,pp);
      end;
  end;
  wid:=3*canvas.TextWidth(s) div 2;
  canvas.Font:=Screen.GetFontFromPointSize(TitleFont,TitleFontSz);
  widt:=canvas.TextWidth(Title) div 2;
  grad.x:=0;
  grad.y:=1;
  if not horiz then
    test:=GPISetCharAngle(canvas.handle,grad);
  pp:=Scale((workr+workl)/2);
    if horiz then
      canvas.TextOut(pp.x-widt,pp.y-2*canvas.TextHeight(Title),Title)
    else
      canvas.TextOut(pp.x-wid-dd-4,pp.y-widt,Title);
  grad.y:=0;
  if not horiz then
    test:=GPISetCharAngle(canvas.handle,grad);
  with canvas do
  begin
    pen.color:=grcolor;
    pen.width:=grwidth;
    pen.style:=grstyle;
  end;
  if grid then
  begin
    for t:=1 to marks-1 do
    begin
      now:=t/marks*(workr-workl)+workl;
      p:=Scale(now);pp:=p;
      if horiz then pp.y:=endp.y else pp.x:=endp.x;
      Line(p,pp);
    end;
  end;
end;

procedure Tax.SetTitle(s:string);
begin
  Title:=s;
end;

procedure Tax.SetScaleCoord;
begin
  orgp:=axorg;
  endp:=axend;
  horiz:=hor;
  if horiz then length:=Endp.x-Orgp.x else length:=EndP.Y-Orgp.Y;
  if horiz then start:=orgp.x else start:=orgp.y;
end;

procedure Tax.SetAlign(horiz:boolean;startx,starty,length:longint);
begin
end;


end.
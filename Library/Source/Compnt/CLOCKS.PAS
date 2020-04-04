
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT Clocks;

INTERFACE

USES Dos,Color,Classes,Forms;

TYPE TAnalogClock=CLASS(TControl)
        PRIVATE
              FVertRes,FHorzRes:LONGINT;
              FCXPixel,FCYPixel:LONGINT;
              FHour,FMinute,FSecond,FSec100:WORD;
              FTimer:TTimer;
              FHourColor,FMinuteColor,FSecondColor:TColor;
              PROCEDURE MakePoints(VAR pts:ARRAY OF TPoint;Count,Angle:LONGINT);
              PROCEDURE DrawHand(pts:ARRAY OF TPoint;Value:WORD);
              PROPERTY Caption;
              PROPERTY Font;
        PROTECTED
              PROCEDURE SetupComponent;OVERRIDE;
              PROCEDURE SetupShow;OVERRIDE;
              PROCEDURE Resize;OVERRIDE;
              PROCEDURE TimerEvent(Sender:TObject);
        PUBLIC
              DESTRUCTOR Destroy;OVERRIDE;
              PROCEDURE Redraw(CONST rec:TRect);OVERRIDE;
        PUBLISHED
              PROPERTY Align;
              PROPERTY Color;
              PROPERTY PenColor;
              PROPERTY DragCursor;
              PROPERTY DragMode;
              PROPERTY ParentColor;
              PROPERTY ParentPenColor;
              PROPERTY ParentShowHint;
              PROPERTY ShowHint;
              PROPERTY Visible;
              PROPERTY ZOrder;

              PROPERTY OnCanDrag;
              PROPERTY OnDragDrop;
              PROPERTY OnDragOver;
              PROPERTY OnEndDrag;
              PROPERTY OnEnter;
              PROPERTY OnExit;
              PROPERTY OnMouseClick;
              PROPERTY OnMouseDblClick;
              PROPERTY OnMouseDown;
              PROPERTY OnMouseMove;
              PROPERTY OnMouseUp;
              PROPERTY OnResize;
              PROPERTY OnSetupShow;
              PROPERTY OnStartDrag;
              PROPERTY HourColor:TColor read FHourColor write FHourColor;
              PROPERTY MinuteColor:TColor read FMinuteColor write FMinuteColor;
              PROPERTY SecondColor:TColor read FSecondColor write FSecondColor;
     END;

IMPLEMENTATION

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TAnalogClock Class implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

CONST aptlHour:ARRAY[0..4] OF TPoint=((X:0;Y:-15),(x:7;y:0),(x:0;y:60),
                                      (x:-7;y:0),(x:0;y:-15));
      aptlMinute:ARRAY[0..4] OF TPoint=((X:0;Y:-20),(X:5;Y:0),(X:0;Y:80),
                                        (X:-5;Y:0),(X:0;Y:-20));
      aptlSecond:ARRAY[0..1] OF TPoint=((X:0;Y:0),(X:0;Y:80));

PROCEDURE TAnalogClock.SetupComponent;
BEGIN
     Inherited SetupComponent;

     FTimer.Create(SELF);
     Include(FTimer.ComponentState,csDetail);
     FTimer.Interval:=1000;
     Color:=clBlack;
     FHourColor:=clBlack;
     FMinuteColor:=clBlack;
     FSecondColor:=clBlack;
     ParentColor:=TRUE;
     Width:=150;
     Height:=150;
END;

DESTRUCTOR TAnalogClock.Destroy;
BEGIN
     FTimer.Destroy;
     FTimer:=NIL;
     Inherited Destroy;
END;

PROCEDURE TAnalogClock.TimerEvent(Sender:TObject);
VAR Hour,Minute,Second,Sec100:WORD;
BEGIN
     IF Handle=0 THEN exit;

     IF TTimer(Sender)=FTimer THEN
     BEGIN
          GetTime(Hour,Minute,Second,Sec100);
          Hour:=((Hour*5) MOD 60) + Minute DIV 12;

          Canvas.ClipRect:=ClientRect;

          Canvas.Pen.Color:=HourColor;
          DrawHand(aptlHour,Hour);
          Canvas.Pen.Color:=MinuteColor;
          DrawHand(aptlMinute,Minute);
          Canvas.Pen.Color:=SecondColor;
          DrawHand(aptlSecond,Second);

          Canvas.Pen.Color:=Color;

          DrawHand(aptlSecond,FSecond);
          IF ((Hour<>FHour)OR(Minute<>FMinute)) THEN
          BEGIN
               DrawHand(aptlHour,FHour);
               DrawHand(aptlMinute,FMinute);
          END;

          Canvas.DeleteClipRegion;

          FHour:=Hour;
          FMinute:=Minute;
          FSecond:=Second;
          FSec100:=Sec100;
     END;
END;

PROCEDURE TAnalogClock.SetupShow;
BEGIN
     Inherited SetupShow;

     FVertRes:=Canvas.VerticalResolution;
     FHorzRes:=Canvas.HorizontalResolution;
     Resize;
     GetTime(FHour,FMinute,FSecond,FSec100);
     FHour:=(FHour*5) MOD 60 + FMinute DIV 12;
     FTimer.OnTimer:=TimerEvent;
     FTimer.Start;
END;

PROCEDURE TAnalogClock.Resize;
VAR Temp:LONGINT;
    CX,CY:LONGINT;
BEGIN
     Inherited Resize;

     CX:=Width*1000 DIV FHorzRes;
     CY:=Height*1000 DIV FVertRes;
     IF CX<CY THEN Temp:=CX
     ELSE Temp:=CY;

     FCXPixel:=FHorzRes*Temp DIV 1000;
     FCYPixel:=FVertRes*Temp DIV 1000;
END;

PROCEDURE TAnalogClock.MakePoints(VAR pts:ARRAY OF TPoint;Count,Angle:LONGINT);
CONST SinTable:ARRAY[0..59] OF LONGINT=
         (
          0,105,208,309,407,500,588,669,743,809,
          866,914,951,978,995,1000,995,978,951,914,
          866,809,743,669,588,500,407,309,208,105,
          0,-104,-207,-308,-406,-499,-587,-668,-742,-808,
          -865,-913,-950,-977,-994,-999,-994,-977,-950,-913,
          -865,-808,-742,-668,-587,-499,-406,-308,-207,-104
         );
VAR t:LONGINT;
    Cos1,Sin1:LONGINT;
    pt:TPoint;
CONST
  Factor: Single = 6 * PI / 180;
BEGIN
     Cos1:=SinTable[(Angle+15) MOD 60];
     Sin1:=SinTable[Angle];
     FOR t:=0 TO Count-1 DO
     BEGIN
          pt:=pts[t];
          pt:=Point((pt.X*Cos1+pt.Y*Sin1) DIV 1000,(pt.Y*Cos1-pt.X*Sin1) DIV 1000);
          pt.X:=((pt.X*FCXPixel) DIV 200);
          inc(pt.x,Width DIV 2);
          pt.Y:=((pt.Y*FCYPixel) DIV 200);
          inc(pt.y,Height DIV 2);
          pts[t]:=pt;
     END;
END;

PROCEDURE TAnalogClock.DrawHand(pts:ARRAY OF TPoint;Value:WORD);
VAR t:LONGINT;
BEGIN
     MakePoints(pts,High(pts)+1,Value);

     Canvas.BeginPath;
     Canvas.PenPos:=pts[0];
     FOR t:=1 TO High(pts) DO Canvas.LineTo(pts[t].X,pts[t].Y);
     Canvas.EndPath;
     Canvas.FillPath;

     Canvas.BeginPath;
     Canvas.PenPos:=pts[0];
     FOR t:=1 TO High(pts) DO Canvas.LineTo(pts[t].X,pts[t].Y);
     Canvas.EndPath;
     Canvas.PathToClipRegion(paDiff);
END;

PROCEDURE TAnalogClock.Redraw(CONST rec:TRect);
VAR Angle:LONGINT;
    pt:ARRAY[0..0] OF TPoint;
    Radius:LONGINT;
BEGIN
     Canvas.Pen.Color:=HourColor;
     DrawHand(aptlHour,FHour);
     Canvas.Pen.Color:=MinuteColor;
     DrawHand(aptlMinute,FMinute);
     Canvas.Pen.Color:=SecondColor;
     DrawHand(aptlSecond,FSecond);

     Inherited Redraw(rec);

     Canvas.Pen.Color:=PenColor;

     FOR Angle:=0 TO 59 DO
     BEGIN
          IF Angle MOD 5<>0 THEN Radius:=1
          ELSE Radius:=4;

          pt[0]:=Point(0,90);
          MakePoints(pt,1,Angle);

          Canvas.FilledCircle(pt[0].X,pt[0].Y,Radius*FCXPixel DIV 200);
     END;
END;

BEGIN
     RegisterClasses([TAnalogClock]);
END.
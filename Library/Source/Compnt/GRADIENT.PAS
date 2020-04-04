
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT Gradient;

INTERFACE

USES Color,Classes, Forms, Graphics;

TYPE
  TDirection = (dLeft, dRight, dUp, dDown);

  TGradient = CLASS(TControl)
   PRIVATE
         FDirection  : TDirection;
         FStartColor : TColor;
         FEndColor   : TColor;
         PROCEDURE SetDirection(NewDirection:TDirection);
         PROCEDURE SetStartColor(NewColor:TColor);
         PROCEDURE SetEndColor(NewColor:TColor);
         PROPERTY Caption;
         PROPERTY Font;
         PROPERTY Color;
         PROPERTY PenColor;
         PROPERTY ParentColor;
         PROPERTY ParentPenColor;
         PROPERTY TabStop;
   PROTECTED
         PROCEDURE SetupComponent; OVERRIDE;
   PUBLIC
         PROCEDURE Redraw(CONST rc:TRect); OVERRIDE;
   PUBLISHED
         PROPERTY Align;
         PROPERTY DragCursor;
         PROPERTY DragMode;
         PROPERTY Enabled;
         PROPERTY ParentFont;
         PROPERTY ParentShowHint;
         PROPERTY PopupMenu;
         PROPERTY ShowHint;
         PROPERTY TabOrder;
         PROPERTY Visible;
         PROPERTY ZOrder;

         PROPERTY OnCanDrag;
         PROPERTY OnCommand;
         PROPERTY OnDblClick;
         PROPERTY OnDragDrop;
         PROPERTY OnDragOver;
         PROPERTY OnEndDrag;
         PROPERTY OnEnter;
         PROPERTY OnExit;
         PROPERTY OnFontChange;
         PROPERTY OnMouseClick;
         PROPERTY OnMouseDblClick;
         PROPERTY OnMouseDown;
         PROPERTY OnMouseMove;
         PROPERTY OnMouseUp;
         PROPERTY OnResize;
         PROPERTY OnSetupShow;
         PROPERTY OnStartDrag;
         PROPERTY Direction:TDirection read FDirection write SetDirection;
         PROPERTY StartColor:TColor read FStartColor write SetStartColor;
         PROPERTY EndColor:TColor read FEndColor write SetEndColor;
  END;

Function InsertGradient(parent              : TControl;
                        Left, Bottom,
                        Width, Height       : LongInt;
                        StartColor, EndColor: TColor;
                        Hint                : String): TGradient;

IMPLEMENTATION

Function InsertGradient(parent : TControl;Left, Bottom, Width, Height : LongInt;
                StartColor, EndColor: TColor; Hint : String): TGradient;


Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.ShowHint:=true;
  Result.Hint:=Hint;
  Result.Parent:= Parent;
  Result.StartColor:= StartColor;
  Result.EndColor:= EndColor;
End;

PROCEDURE TGradient.SetDirection(NewDirection:TDirection);
BEGIN
   FDirection:=NewDirection;
   Invalidate;
END;

PROCEDURE TGradient.SetStartColor(NewColor:TColor);
BEGIN
     FStartColor:=NewColor;
     Invalidate;
END;

PROCEDURE TGradient.SetEndColor(NewColor:TColor);
BEGIN
     FEndColor:=NewColor;
     Invalidate;
END;

PROCEDURE TGradient.SetupComponent;
BEGIN
   Inherited SetUpComponent;

   FDirection:= dUp;
   FStartColor:=clBlack;
   FEndColor:=clBlue;
   Width:=200;
   Height:=200;
   ZOrder:=zoBottom;
   TabStop:=FALSE;
END;

PROCEDURE TGradient.Redraw(CONST rc:TRect);
VAR
    SaveColor:TColor;
    DRed,DGreen,DBlue,DR,DG,DB:Extended;
    StartLoop,EndLoop:LONGINT;
    rec:TRect;
BEGIN
     SaveColor:=Canvas.Pen.Color;
     Canvas.ClipRect:=rc;

     DRed:=TRGB(FStartColor).Red;
     DGreen:=TRGB(FStartColor).Green;
     DBlue:=TRGB(FStartColor).Blue;
     DR:=TRGB(FEndColor).Red-DRed;
     DG:=TRGB(FEndColor).Green-DGreen;
     DB:=TRGB(FEndColor).Blue-DBlue;

     CASE FDirection OF
        dUp,dDown,dLeft,dRight:
        BEGIN
             IF FDirection IN [dUp,dDown] THEN
             BEGIN
                  DR:=DR / Height;
                  DG:=DG / Height;
                  DB:=DB / Height;
             END
             ELSE
             BEGIN
                  DR:=DR / Width;
                  DG:=DG / Width;
                  DB:=DB / Width;
             END;

             IF FDirection=dUp THEN
             BEGIN
                  StartLoop:=0;
                  EndLoop:=Height+1;
             END
             ELSE IF FDirection=dDown THEN
             BEGIN
                  StartLoop:=Height+1;
                  EndLoop:=0;
             END
             ELSE IF FDirection=dLeft THEN
             BEGIN
                  StartLoop:=0;
                  EndLoop:=Width+1;
             END
             ELSE
             BEGIN
                  StartLoop:=Width+1;
                  EndLoop:=0;
             END;

             WHILE StartLoop<>EndLoop DO
             BEGIN
                  IF FDirection IN [dUp,dDown] THEN
                  BEGIN
                       rec.Left:=0;
                       rec.Right:=Width;
                       rec.Bottom:=StartLoop;
                       rec.Top:=rec.Bottom+1;
                  END
                  ELSE
                  BEGIN
                       rec.Left:=StartLoop;
                       rec.Right:=rec.Left+1;
                       rec.Bottom:=0;
                       rec.Top:=Height;
                  END;
                  Canvas.FillRect(rec,ValuesToRGB(Round(DRed),Round(DGreen),Round(DBlue)));

                  DRed:=DRed+DR;
                  DGreen:=DGreen+DG;
                  DBlue:=DBlue+DB;

                  IF FDirection IN [dUp,dLeft] THEN inc(StartLoop)
                  ELSE dec(StartLoop);
             END;
        END;
     END; //case

     Canvas.Pen.Color:=SaveColor;
     Canvas.DeleteClipRegion;
end;

begin
  RegisterClasses([TGradient]);
end.

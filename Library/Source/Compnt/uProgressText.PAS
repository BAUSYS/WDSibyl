Unit uProgressText;

{
tProgressText is like tMemo, but only for output and without scrollbar. The text disappears finally after
scrolling on top outside the area and is not stored. tProgressText is very fast, in opposite to tMemo.

tProgressText ist wie tMemo, aber nur fÅr Output und ohne Scrollbar. Der Text rutscht unwiederbringlich
nach oben aus dem Fenster weg. tProgressText ist sehr schnell, im Unterschied zu tMemo.

Author: Martin Vieregg www.hypermake.com
}

Interface

Uses
  Classes, Color, Forms, SysUtils,
  uSysInfo;

const
  ProgressTextbufmax = 8192;

{Declare new class}
Type
  tTProgressText=Class(TControl)
  Protected
    Buffer : array[1..ProgressTextbufmax] of char;
    BeginB, EndB, TopB : integer;
    LineCount : integer;
    Cur : tPoint;
    Procedure SetupComponent; Override;
    Procedure Redraw(Const rec:TRect);Override;
    procedure ScrollOneLine;
    procedure FillBuffer (Ch : char);
    procedure incB (var B : integer);
    procedure ScreenNewLine;
    procedure SetCanvas;
  Published
    Property Font;
    Property Color;
    Property ParentFont;
    Property PenColor;
    property Visible;
    Margin : integer;
  Public
    Destructor Destroy; Override;
    procedure Add (St : string);
    procedure NewLine;
    procedure Clear;
  End;

{Define components to export}
{You may define a page of the component palette and a component bitmap file}
Exports
  tTProgressText,'Samples','';

Implementation

    procedure tTProgressText.incB (var B : integer);
      begin
        if B = ProgressTextbufmax then B := 1
        else inc (B);
      end;

  procedure tTProgressText.SetCanvas;
    begin
      Canvas.Brush.Color := Color;
      Canvas.Pen.Color := PenColor;
      Canvas.Font := Font;
    end;

procedure tTProgressText.ScrollOneLine;
  var
    Dest, Source : tRect; {left bottom right top}
  begin
    with Canvas do begin
      CopyMode := cmSrcCopy;
      Source.left := Margin; Source.right := ClientWidth-Margin;
      Source.top := ClientHeight-Margin; Source.bottom := Margin;
      Dest := Source;
      Source.top := Source.top - Font.Height;
      Dest.bottom := Dest.bottom + Font.Height;
      CopyRect (Dest, self.Canvas, Source);
      Source.top := Dest.bottom-1;
      FillRect (Source, Brush.Color);
    end;
    {set TopB TopBuffer pointer to the beginning of the next line}
    incB (TopB);
    while (Buffer[TopB-1] <> ^M) and (TopB <> EndB) do incB(TopB);
  end;

     procedure tTProgressText.FillBuffer (Ch : char);
       begin
         incB (EndB); Buffer[EndB] := Ch;
         if EndB = BeginB then incB (BeginB);{do not overlap the ring-buffer}
       end;

  procedure tTProgressText.ScreenNewLine;
    begin
      Cur.X := Margin; Cur.Y := Cur.Y-Font.Height;
      if Cur.Y < Margin then begin
        ScrollOneLine; Cur.Y := Cur.Y+Font.Height;
      end;
    end;

procedure tTProgressText.NewLine;
  begin
    ScreenNewLine;
    FillBuffer (^M);
  end;

procedure tTProgressText.Add (St : string);
  var
    L, S : byte;
    LineSt : string;
    W, OldW, LeftEnd : integer;

  begin
    SetCanvas;
    with Canvas do begin
      S := 0;
      LeftEnd := ClientWidth-3*Margin;
      while S < length(St) do begin
        LineSt := ''; L := 0;
        W := Cur.X; OldW := W;
        while (W < LeftEnd) and (S < length(St)) do begin
          inc (S);
          inc (L); LineSt[L] := St[S]; W := W + TextWidth(St[S]);
          FillBuffer (St[S]);
        end;
        LineSt[0] := char(L);
        PenPos := Cur;
        {$IFDEF WIN32}
        StrOemToAnsi(LineSt);
        {$ENDIF}
        DrawString (LineSt);
        if W >= LeftEnd then NewLine
        else Cur.X := Cur.X + W - OldW;
      end;
    end;
  end;

procedure tTProgressText.Redraw (Const rec : tRect);
  var
    LightColor,DarkColor:TColor;
    rc1 : tRect;
    ActB : integer;
    LineSt : string;
  begin
     If Canvas = Nil Then Exit;
     Inherited Redraw(rec);

     if (goSysInfo.OS.Platform = OS2Ver20) or
        (goSysInfo.OS.Platform = OS2Ver30)
       then
         Begin
           DarkColor := clWindowFrame;
           LightColor := clBtnHighlight;
         End
       else
         Begin
           DarkColor := clDkGray;
           LightColor := clWhite;
         End;
     rc1 := ClientRect;
     DrawSystemFrame(Self,rc1,LightColor,DarkColor);


     if not ((BeginB = 1) and (EndB = 0)) then begin
       SetCanvas;
       Cur.X := Margin; Cur.Y := ClientHeight - Margin - Font.Height;
       ActB := TopB; LineSt := '';
       repeat
         if Buffer[ActB] = ^M then begin
           Canvas.PenPos := Cur;
           {$IFDEF WIN32}
           StrOemToAnsi(LineSt);
           {$ENDIF}
           Canvas.DrawString (LineSt); LineSt := '';
           ScreenNewLine;
         end
         else begin
           inc (LineSt[0]); LineSt[length(LineSt)] := Buffer[ActB];
         end;
         if ActB = EndB then begin
           if length(LineSt) > 0 then begin
             Canvas.PenPos := Cur;
             {$IFDEF WIN32}
             StrOemToAnsi(LineSt);
             {$ENDIF}
             Canvas.DrawString (LineSt);
           end;
           Cur := Canvas.PenPos;
           break;
         end;
         incB (ActB);
       until false;

     end;
     Canvas.DeleteClipRegion;

  end;

procedure tTProgressText.Clear;
  begin
    BeginB := 1; TopB := 1; EndB := 0;
    Cur.X := Margin; Cur.Y := ClientHeight - Margin - Font.Height;
    Invalidate;
  end;

Procedure tTProgressText.SetupComponent;
Begin
  Inherited SetupComponent;
  Name := 'TProgressText';
  BeginB := 1; TopB := 1; EndB := 0;

  //EndB := 0+2; Buffer[1] := 'H'; Buffer[2] := 'a';

  Height := 60; Width := 200; Margin := 5;
  Cur.X := Margin; Cur.Y := ClientHeight - Margin;
  Color := clDlgWindow; PenColor := clBlack;
End;

Destructor tTProgressText.Destroy;
Begin
  Inherited Destroy;
End;

Initialization
  {Register classes}
  RegisterClasses([tTProgressText]);
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  09-Aug-04  MV         OEM to ANSI conversion for Windows added
}
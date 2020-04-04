
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT BmpList;

INTERFACE

USES SysUtils,Messages,Color,Classes,Forms,Graphics,StdCtrls;

TYPE
    TBitmapListBox=CLASS(TListBox)
      PRIVATE
         FBitmapList:TBitmapList;
         FScaleBitmap:Boolean;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE DrawItem(Index:LONGINT;Rec:TRect;State:TOwnerDrawState);OVERRIDE;
         PROCEDURE SetBitmap(Index:LONGINT;NewBitmap:TBitmap);
      PUBLIC
         DESTRUCTOR Destroy;OVERRIDE;
         FUNCTION  AddBitmap(CONST S:STRING;ABitmap:TBitmap):LONGINT;
         PROCEDURE InsertBitmap(Index:LONGINT;CONST S:STRING;ABitmap:TBitmap);
         PROCEDURE Clear;OVERRIDE;
         PROPERTY Bitmaps[Index:LONGINT]:TBitmap write SetBitmap;
      PUBLISHED
         PROPERTY ScaleBitmap:BOOLEAN read FScaleBitmap write FScaleBitmap;
    END;

FUNCTION InsertBitmapListBox(Parent:TControl;X,Y,W,H,ItemHeight:LONGINT):TBitmapListBox;

IMPLEMENTATION

FUNCTION InsertBitmapListBox(Parent:TControl;X,Y,W,H,ItemHeight:LONGINT):TBitmapListBox;
BEGIN
     Result.Create(Parent);
     Result.SetWindowPos(X,Y,W,H);
     Result.TabStop := TRUE;
     Result.ItemHeight := ItemHeight;
     Result.Parent := Parent;
END;

{ TBitmapListBox }

PROCEDURE TBitmapListBox.SetupComponent;
BEGIN
     Inherited SetupComponent;
     FBitmapList.Create;
     FBitmapList.Duplicates := TRUE;
     Style:=lbOwnerdrawFixed;
END;


PROCEDURE TBitmapListBox.DrawItem(Index:LONGINT;Rec:TRect;State:TOwnerDrawState);
VAR  x,y,y1,cx,cy,cx1,cy1:LONGINT;
     idx:LONGINT;
     Bitmap:TBitmap;
     s:STRING;
BEGIN
     IF State * [odSelected] <> [] THEN
     BEGIN
          Canvas.Pen.Color := clHighLightText;
          Canvas.Brush.Color := clHighLight;
     END ELSE
     BEGIN
          Canvas.Pen.Color := PenColor;
          Canvas.Brush.Color := Color;
     END;
     Canvas.FillRect(Rec,Canvas.Brush.Color);

     x := Rec.Left + 2;
     y := Rec.Bottom + 1;
     cx := Rec.Right - x;
     cy := Rec.Top - y;

     idx := LONGINT(Items.Objects[Index]);
     IF idx >= 0 THEN Bitmap := FBitmapList.Bitmaps[idx]
     ELSE Bitmap := NIL;

     IF Bitmap <> NIL THEN
     BEGIN
          cx1 := Bitmap.Width;
          cy1 := Bitmap.Height;
          y1 := y + ((cy - cy1) DIV 2);
          IF y1 <= Rec.Bottom THEN y1 := Rec.Bottom + 1;

          IF ScaleBitmap THEN
          BEGIN
               IF y1+cy1>Rec.Top THEN cy1:=Rec.Top-y1-1;
               IF Bitmap.Width=Bitmap.Height THEN cx1:=cy1;
          END;

          Canvas.StretchDraw(x,y1,cx1,cy1,Bitmap);
          inc(x,Bitmap.Width + 5);
     END;

     s := Items.Strings[Index];
     Canvas.GetTextExtent(s,cx1,cy1);
     y1 := y + ((cy - cy1) DIV 2);
     IF y1 < Rec.Bottom THEN y1 := Rec.Bottom;
     Canvas.Brush.Mode := bmTransparent;
     Canvas.TextOut(x,y1,s);
END;


DESTRUCTOR TBitmapListBox.Destroy;
BEGIN
     FBitmapList.Destroy;
     Inherited Destroy;
END;


PROCEDURE TBitmapListBox.SetBitmap(Index:LONGINT;NewBitmap:TBitmap);
BEGIN
     FBitmapList.Bitmaps[Index]:=NewBitmap;
END;

FUNCTION TBitmapListBox.AddBitmap(CONST S:STRING;ABitmap:TBitmap):LONGINT;
VAR  idx:LONGINT;
BEGIN
  IF ABitmap IS TBitmap
    THEN idx := FBitmapList.Add(ABitmap)
  else idx := -1;

  Result := Items.AddObject(S,TObject(idx));
END;


PROCEDURE TBitmapListBox.InsertBitmap(Index:LONGINT;CONST S:STRING;ABitmap:TBitmap);
VAR  idx:LONGINT;
BEGIN
     IF ABitmap IS TBitmap THEN idx := FBitmapList.Add(ABitmap)
     ELSE idx := -1;

     Items.InsertObject(Index,S,TObject(idx));
END;


PROCEDURE TBitmapListBox.Clear;
BEGIN
     Inherited.Clear;

     FBitmapList.Clear;
END;

BEGIN
     RegisterClasses([TBitmapListBox]);
END.

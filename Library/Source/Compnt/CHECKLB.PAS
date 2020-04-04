
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit CheckLB;

Interface

Uses Color,Classes,Forms,Graphics,StdCtrls;

Type
    TCheckListBoxState=(clsUnchecked,clsChecked,cls3State);

    TCheckListBox=Class(TListBox)
      Private
         FBitmapList:TBitmapList;
         FOnStateChanged:TNotifyEvent;
      Private
         Function GetState(Index:LongInt):TCheckListBoxState;
         Procedure SetState(Index:LongInt;Value:TCheckListBoxState);
         Property Style;
      Protected
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
         Procedure ItemSelect(Index:LongInt);Override;
         Procedure DrawItem(Index:LongInt;rec:TRect;State:TOwnerDrawState);Override;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
      Public
         Property State[Index:LongInt]:TCheckListBoxState Read GetState Write SetState;
      Published
         Property OnStateChanged:TNotifyEvent Read FOnStateChanged Write FOnStateChanged;
    End;

Function InsertCheckListBox(parent:TControl;X,Y,W,H:LongInt):TCheckListBox;


Implementation

{$R CheckLB}

Function InsertCheckListBox(parent:TControl;X,Y,W,H:LongInt):TCheckListBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(X,Y,W,H);
     Result.TabStop := True;
     Result.parent := parent;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TCheckListBox Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCheckListBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Style := lbOwnerdrawFixed;
     ItemHeight := 20;
     FBitmapList.Create;
     FBitmapList.AddResourceName('BmpLBUnChecked');
     FBitmapList.AddResourceName('BmpLBChecked');
     FBitmapList.AddResourceName('BmpLB3State');
End;


Destructor TCheckListBox.Destroy;
Begin
     Inherited Destroy;
     FBitmapList.Destroy;
End;

Procedure TCheckListBox.DrawItem(Index:LongInt;rec:TRect;State:TOwnerDrawState);
Var  X,Y,y1,CX,CY,cx1,cy1:LongInt;
     idx:LongInt;
     Bitmap:TBitmap;
     S:String;
Begin
     If OnDrawItem <> Nil Then Exit;

     If State * [odSelected] <> [] Then
     Begin
          Canvas.Pen.color := clHighlightText;
          Canvas.Brush.color := clHighlight;
     End Else
     Begin
          Canvas.Pen.color := PenColor;
          Canvas.Brush.color := color;
     End;

     Canvas.FillRect(Rec,Canvas.Brush.Color);


     //Canvas.ClipRect:=rec;
     X := rec.Left + 2;
     Y := rec.Bottom + 1;
     CX := rec.Right - X;
     CY := rec.Top - Y;

     idx := LongInt(Items.Objects[Index]);
     If idx >= 0 Then Bitmap := FBitmapList.Bitmaps[idx]
     Else Bitmap := Nil;

     If Bitmap<>Nil Then Inc(X,Bitmap.Width + 5);
     S := Items.Strings[Index];
     Canvas.GetTextExtent(S,cx1,cy1);
     y1 := Y + ((CY - cy1) Div 2);
     If y1 < rec.Bottom Then y1 := rec.Bottom;
     //Canvas.TextOut(X,y1,S);
     //Canvas.ExcludeClipRect(Rect(X,y1,X+cx1-1,Y+cy1-1));
     Canvas.Brush.Mode := bmTransparent;
     Canvas.TextOut(x,y1{$ifdef win32}-2{$endif}{Martin},s);

     If Bitmap <> Nil Then
     Begin
          X := rec.Left + 2;
          Y := rec.Bottom + 1 {$ifdef win32}-5{$endif}{Martin};
          CX := rec.Right - X;
          CY := rec.Top - Y;
          cy1 := Bitmap.Height;
          y1 := Y + ((CY - cy1) Div 2);
          If y1 <= rec.Bottom Then y1 := rec.Bottom + 1;
          Canvas.StretchDraw(X,y1,Bitmap.Width,Bitmap.Height,Bitmap);
          //Canvas.ExcludeClipRect(Rect(X,y1,X+Bitmap.Width-1,y1+Bitmap.Height-1));
     End;

     //Canvas.FillRect(rec,Canvas.Brush.color);

     //Canvas.DeleteClipRegion;
End;


Procedure TCheckListBox.ItemSelect(Index:LongInt);
Begin
     Inherited ItemSelect(Index);

     If State[ItemIndex] <> clsUnchecked Then State[ItemIndex] := clsUnchecked
     Else State[ItemIndex] := clsChecked;
     If OnStateChanged <> Nil Then OnStateChanged(Self);
End;


Procedure TCheckListBox.CharEvent(Var key:Char;RepeatCount:Byte);
Begin
     If key=#32 Then
     Begin
          If State[ItemIndex] <> clsUnchecked Then State[ItemIndex] := clsUnchecked
          Else State[ItemIndex] := clsChecked;
          If OnStateChanged <> Nil Then OnStateChanged(Self);
     End;
     Inherited CharEvent(key,RepeatCount);
End;


Function TCheckListBox.GetState(Index:LongInt):TCheckListBoxState;
Var  obj:TObject;
Begin
     Result := clsUnchecked;
     If (Index < 0) Or (Index >= Items.Count) Then Exit;
     obj := Items.Objects[Index];
     Result := TCheckListBoxState(obj);
End;


Procedure TCheckListBox.SetState(Index:LongInt;Value:TCheckListBoxState);
Var  obj:TObject;
Begin
     If (Index < 0) Or (Index >= Items.Count) Then Exit;
     obj := TObject(Value);
     Items.Objects[Index] := obj;

     Invalidate;
End;

Begin
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  24-Sep-06     MV                 TCheckListBox.DrawItem: Statt +7 gehoehrt hier -7
  15-Mai-07     MV                 TCheckListBox.DrawItem: Statt -7 gehoehrt hier 5
}


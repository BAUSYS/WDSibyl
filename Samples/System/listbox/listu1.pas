Unit ListU1;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, Color;

Type
  TOwnerDrawListBoxForm = Class (TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Procedure ListBox1OnSetupShow (Sender: TObject);
    Procedure ListBox1OnItemFocus (Sender: TObject; Index: LongInt);
    Procedure ListBox1OnDrawItem (Sender: TObject; Index: LongInt; Rec: TRect;
                                  State: TOwnerDrawState);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  OwnerDrawListBoxForm: TOwnerDrawListBoxForm;

Implementation

Procedure TOwnerDrawListBoxForm.ListBox1OnSetupShow (Sender: TObject);
Var t:LongInt;
Begin
    For t:=0 To Screen.FontCount-1 Do
   ListBox1.Items.Add(Screen.Fonts[t].FaceName);
End;

Procedure TOwnerDrawListBoxForm.ListBox1OnItemFocus (Sender: TObject; Index: LongInt);
Begin
  Label1.Text:='Selected:'+Screen.Fonts[Index].FaceName;
End;

Procedure TOwnerDrawListBoxForm.ListBox1OnDrawItem (Sender: TObject; Index: LongInt;
                                     Rec: TRect; State: TOwnerDrawState);
Var OldFont:TFont;
    rc:TRect;
    CX,CY:LongInt;
    TheFont:TFont;
Begin
   //set the desired font
   OldFont:=ListBox1.Canvas.Font;
   TheFont:=Screen.Fonts[Index];
   ListBox1.Canvas.Font:=TheFont;

   //Set the clipping region
   ListBox1.Canvas.ClipRect:=Rec;

   //put out the text and remove the text rectangle from the clipping region
   ListBox1.Canvas.GetTextExtent(TheFont.FaceName,CX,CY);
   rc.Left:=rec.Left;
   rc.Right:=rc.Left+CX-1;
   rc.Bottom:=rec.Bottom;
   rc.Top:=rc.Bottom+CY-1;
   If State*[odSelected]<>[] Then ListBox1.Canvas.Brush.Color:=clHighlight
   Else ListBox1.Canvas.Brush.Color:=ListBox1.Color;
   ListBox1.Canvas.TextOut(rc.Left,rc.Bottom,TheFont.FaceName);
   ListBox1.Canvas.ExcludeClipRect(rc);

   //fill the rest portion of the entries rectangle
   If State*[odSelected]<>[] Then ListBox1.Canvas.FillRect(rec,clHighlight)
   Else ListBox1.Canvas.FillRect(rec,ListBox1.Color);

   //Delete the clipping region and restore the old font
   ListBox1.Canvas.DeleteClipRegion;
   ListBox1.Canvas.Font:=OldFont;
End;

Initialization
  RegisterClasses ([TOwnerDrawListBoxForm, TListBox, TLabel]);
End.

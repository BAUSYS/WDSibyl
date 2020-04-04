Unit RxMain;

Interface

Uses
  SysUtils, Classes, Forms, Graphics, OutLine, ExtCtrls, Dialogs, ExeImage,
  AboutUnit,
  Menus,uStream,Color;

Type
    TMainForm=Class(TForm)
    Procedure AboutOnClick (Sender: TObject);
      Published
         ToolBar1: TToolbar;
         Outline1: TOutline;
         SizeBorder1: TSizeBorder;
         PaintBox1: TPaintBox;
         MainMenu1: TMainMenu;
         MenuItem1: TMenuItem;
         FileLoad: TMenuItem;
         MenuItem3: TMenuItem;
         FileSave: TMenuItem;
         FileExit: TMenuItem;
         OpenDialog1: TOpenDialog;
         About: TMenuItem;
         SaveDialog1: TSaveDialog;
         MenuItem2: TMenuItem;
         Procedure SizeBorder1OnSized (Sender: TObject; Var SizeDelta: LongInt);
         Procedure FileLoadOnClick (Sender: TObject);
         Procedure PaintBox1OnPaint (Sender: TObject; Const rec: TRect);
         Procedure SizeBorder1OnSizing (Sender: TObject; Var SizeDelta: LongInt);
         Procedure MainFormOnCreate (Sender: TObject);
         Procedure FileSaveOnClick (Sender: TObject);
         Procedure Outline1OnMouseClick (Sender: TObject; Button: TMouseButton;
                                      Shift: TShiftState; X: LongInt; Y: LongInt);
         Procedure Outline1OnItemFocus (Sender: TObject; Index: LongInt);
      Public
         ExeDllImage:TExeDllImage;
     End;

Var MainForm:TMainForm;

Implementation

Procedure TMainForm.AboutOnClick (Sender: TObject);
Begin
  AboutForm.ShowModal;
End;

Procedure TMainForm.FileSaveOnClick (Sender: TObject);
Var Item:TResourceItem;
    Bitmap:TBitmap;
    t:LongInt;
    s:String;
    Stream:TFileStream;
Begin
  If Outline1.SelectedNode<>Nil Then
  Begin
    Item:=Outline1.SelectedNode.Data;
    If Item<>Nil Then
    Begin
        If ((Item Is TBitmapResource)Or(Item Is TIconResource)) Then
        Begin
             If Item Is TBitmapResource Then
             Begin
                 Bitmap:=TBitmapResource(Item).Bitmap;
                 SaveDialog1.FilterIndex:=1;
                 SaveDialog1.FileName:='*.bmp';
             End
             Else
             Begin
                 Bitmap:=TIconResource(Item).Icon;
                 SaveDialog1.FilterIndex:=2;
                 SaveDialog1.FileName:='*.ico';
             End;

             If Bitmap<>Nil Then
             Begin
                 If SaveDialog1.Execute Then
                 Begin
                     Try
                       Bitmap.SaveToFile(SaveDialog1.FileName);
                     Except
                       On E:Exception Do ErrorBox(E.Message);
                     End;
                 End;
             End;
        End
        Else If Item Is TStringListResource Then
        Begin
             SaveDialog1.FilterIndex:=3;
             SaveDialog1.FileName:='*.txt';
             If SaveDialog1.Execute Then
             Begin
                Try
                  Stream.Create(SaveDialog1.FileName,fmCreate);

                  Try
                    For t:=0 To TStringListResource(Item).StringCount-1 Do
                    Begin
                         s:=TStringListResource(Item).Strings[t];

                         s:=tostr(Item.Id+t)+' , "'+s+'"';
                         Stream.WriteLn(s);
                    End;
                  Finally
                    Stream.Destroy;
                  End;
                Except
                   On E:Exception Do ErrorBox(E.Message);
                End;
             End;
        End;
    End;
  End;
End;

Procedure TMainForm.Outline1OnMouseClick (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
Begin
  If Button<>mbLeft Then exit;
  PaintBox1.Invalidate;
End;

Procedure TMainForm.Outline1OnItemFocus (Sender: TObject; Index: LongInt);
Begin
   PaintBox1.Invalidate;
End;

Procedure TMainForm.MainFormOnCreate (Sender: TObject);
Begin
  Application.Font:=Font;
End;

Procedure TMainForm.FileLoadOnClick (Sender: TObject);
Var RootIndex,LastIndex:LongInt;
    t:Longint;
    Item:TResourceItem;
Begin
  If OpenDialog1.Execute Then
  Begin
     If ExeDllImage<>Nil Then ExeDllImage.Destroy;
     ExeDllImage.Create(OpenDialog1.FileName);
     Outline1.Clear;

     //Build the outline
     LastIndex:=Outline1.Add(0,OpenDialog1.FileName);
     RootIndex:=Outline1.AddChild(LastIndex,'Resources');

     LastIndex:=Outline1.AddChild(RootIndex,'Bitmaps');
     For t:=0 To ExeDllImage.ResourceList.Count-1 Do
     Begin
         Item:=ExeDllImage.ResourceList.Items[t];
         If Item Is TBitmapResource Then
           Outline1.AddChildObject(LastIndex,IntToStr(Item.Id),Item);
     End;

     LastIndex:=Outline1.AddChild(RootIndex,'Icons');
     For t:=0 To ExeDllImage.ResourceList.Count-1 Do
     Begin
         Item:=ExeDllImage.ResourceList.Items[t];
         If Item Is TIconResource Then
           Outline1.AddChildObject(LastIndex,IntToStr(Item.Id),Item);
     End;

     LastIndex:=Outline1.AddChild(RootIndex,'StringTables');
     For t:=0 To ExeDllImage.ResourceList.Count-1 Do
     Begin
         Item:=ExeDllImage.ResourceList.Items[t];
         If Item Is TStringListResource Then
           Outline1.AddChildObject(LastIndex,IntToStr(Item.Id),Item);
     End;
  End;
End;

Procedure TMainForm.PaintBox1OnPaint (Sender: TObject; Const rec: TRect);
Var Item:TResourceItem;
    Bitmap:TBitmap;
    Dest:TRect;
    t:LongInt;
    s:String;
    y:LongInt;
Begin
  PaintBox1.Canvas.FillRect(rec,clWhite);

  If Outline1.SelectedNode<>Nil Then
  Begin
    Item:=Outline1.SelectedNode.Data;
    If Item<>Nil Then
    Begin
        If ((Item Is TBitmapResource)Or(Item Is TIconResource)) Then
        Begin
           If Item Is TBitmapResource Then Bitmap:=TBitmapResource(Item).Bitmap
           Else Bitmap:=TIconResource(Item).Icon;

           If Bitmap<>Nil Then
           Begin
              Dest.Left:=SizeBorder1.Width;
              Dest.Right:=Dest.Left+Bitmap.Width;
              Dest.Bottom:=PaintBox1.Height-Bitmap.Height;
              Dest.Top:=PaintBox1.Height;
              Bitmap.Draw(PaintBox1.Canvas,Dest);
           End;
        End
        Else If Item Is TStringListResource Then
        Begin
           y:=PaintBox1.Height-PaintBox1.Canvas.Font.Height;
           For t:=0 To TStringListResource(Item).StringCount-1 Do
           Begin
              s:=TStringListResource(Item).Strings[t];

              s:=tostr(Item.Id+t)+' , "'+s+'"';

              PaintBox1.Canvas.TextOut(SizeBorder1.Width,y,s);
              dec(y,PaintBox1.Canvas.Font.Height);
           End;
        End;
    End;
  End;
End;

Procedure TMainForm.SizeBorder1OnSizing (Sender: TObject;
                                         Var SizeDelta: LongInt);
Var NewSize:LongInt;
Begin
   NewSize:=ToolBar1.Size+SizeDelta;
   If NewSize<20 Then NewSize:=20;
   If NewSize>Width-20 Then NewSize:=Width-20;
   SizeDelta:=NewSize-ToolBar1.Size;
End;

Procedure TMainForm.SizeBorder1OnSized (Sender: TObject;
                                        Var SizeDelta: LongInt);
Var NewSize:LongInt;
Begin
   NewSize:=ToolBar1.Size+SizeDelta;
   If NewSize<20 Then NewSize:=20;
   If NewSize>Width-20 Then NewSize:=Width-20;
   ToolBar1.Size:=NewSize;
End;

Initialization
  RegisterClasses ([ TToolbar, TOutline, TSizeBorder, TPaintBox,
    TMainMenu, TMenuItem, TOpenDialog, TMainForm, TSaveDialog]);
End.

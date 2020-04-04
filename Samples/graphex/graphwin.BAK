Unit GraphWin;

Interface

Uses
  SysUtils, Classes, Forms, Graphics, Dialogs, ComCtrls, MainTool,
  BrshTool, PenTool, DockTool, ColTool, ExtCtrls, NewImage, Buttons, DBBase,
  ColorGrd, StdCtrls,
  Menus, Color;

Type
  TGraphExForm = Class (TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    New: TMenuItem;
    Open: TMenuItem;
    Save: TMenuItem;
    SaveAs: TMenuItem;
    MenuItem8: TMenuItem;
    Exit: TMenuItem;
    Cut: TMenuItem;
    Copy: TMenuItem;
    Paste: TMenuItem;
    ToolBar1: TToolbar;
    StatusBar1: TStatusBar;
    Image1: TImage;
    MenuItem10: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    Procedure PasteOnClick (Sender: TObject);
    Procedure CopyOnClick (Sender: TObject);
    Procedure CutOnClick (Sender: TObject);
    Procedure SaveAsOnClick (Sender: TObject);
    Procedure SaveOnClick (Sender: TObject);
    Procedure GraphExFormOnCreate (Sender: TObject);
    Procedure OpenOnClick (Sender: TObject);
    Procedure Image1OnMouseUp (Sender: TObject; Button: TMouseButton;
                               Shift: TShiftState; X: LongInt; Y: LongInt);
    Procedure Image1OnMouseMove (Sender: TObject; Shift: TShiftState;
                                 X: LongInt; Y: LongInt);
    Procedure Image1OnMouseDown (Sender: TObject; Button: TMouseButton;
                                 Shift: TShiftState; X: LongInt; Y: LongInt);
    Procedure NewOnClick (Sender: TObject);
    Procedure Form1OnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
    DrawMode:Boolean;
    StartPoint,EndPoint:TPoint;
    FileName:String;
    Procedure NewBitmap(CX,CY:LongInt);
    Procedure DrawFigure(Canvas:TCanvas);
  End;

Var
  GraphExForm: TGraphExForm;

Implementation

Procedure TGraphExForm.PasteOnClick (Sender: TObject);
Var Bitmap1:TBitmap;
    rc:TRect;
Begin
   Bitmap1.Create;
   Try
     If Bitmap1.LoadFromClipboard Then
     Begin
       rc.Left:=0;
       rc.Right:=Bitmap1.Width;
       rc.Bottom:=0;
       rc.Top:=Bitmap1.Height;
       Bitmap1.Draw(Image1.Bitmap.Canvas,rc);
       Bitmap1.Draw(Image1.Canvas,rc);
     End;
   Except
   End;
   Bitmap1.Destroy;
End;

Procedure TGraphExForm.CopyOnClick (Sender: TObject);
Var rc:TRect;
Begin
   rc.Left:=0;
   rc.Right:=Image1.Bitmap.Width;
   rc.Bottom:=0;
   rc.Top:=Image1.Bitmap.Height;
   Image1.Bitmap.CopyToClipboard(rc);
End;

Procedure TGraphExForm.CutOnClick (Sender: TObject);
Var rc:TRect;
Begin
   rc.Left:=0;
   rc.Right:=Image1.Bitmap.Width;
   rc.Bottom:=0;
   rc.Top:=Image1.Bitmap.Height;
   Image1.Bitmap.CopyToClipboard(rc);

   Image1.Bitmap.Canvas.Brush.Color:=clWhite;
   Image1.Bitmap.Canvas.Pen.Color:=clWhite;
   Image1.Bitmap.Canvas.Box(rc);
   Image1.Canvas.Brush.Color:=clWhite;
   Image1.Canvas.Pen.Color:=clWhite;
   Image1.Canvas.Box(rc);
End;

Procedure TGraphExForm.SaveAsOnClick (Sender: TObject);
Begin
   SaveDialog1.FileName:=FileName;
   If SaveDialog1.Execute Then
   Begin
       Try
         StatusBar1.SimpleText:='Saving...';
         Image1.Bitmap.SaveToFile(SaveDialog1.FileName);
         FileName:=SaveDialog1.FileName;
         StatusBar1.SimpleText:='';
       Except
         On E:Exception Do ErrorBox(E.Message);
       End;
   End;
End;

Procedure TGraphExForm.SaveOnClick (Sender: TObject);
Begin
   If FileName='' Then SaveAsOnClick(Sender)
   Else
   Begin
       Try
         StatusBar1.SimpleText:='Saving...';
         StatusBar1.Update;
         Image1.Bitmap.SaveToFile(FileName);
         StatusBar1.SimpleText:='';
       Except
         On E:Exception Do ErrorBox(E.Message);
       End;
   End;
End;

Procedure TGraphExForm.GraphExFormOnCreate (Sender: TObject);
Begin
  Application.Font:=Font;
End;

Procedure TGraphExForm.OpenOnClick (Sender: TObject);
Var Bitmap:TBitmap;
Begin
  If OpenDialog1.Execute Then
  Begin
     Try
       StatusBar1.SimpleText:='Loading...';
       StatusBar1.Update;
       Bitmap.Create;
       Bitmap.CreatePalette:=True;
       Bitmap.LoadFromFile(OpenDialog1.FileName);
       Image1.Bitmap:=Bitmap;
       FileName:=OpenDialog1.FileName;
       StatusBar1.SimpleText:='';
     Except
       On E:Exception Do ErrorBox(E.Message);
     End;
     Bitmap.Destroy;
  End;
End;

Procedure TGraphExForm.DrawFigure(Canvas:TCanvas);
Var rc:TRect;
    W,H:LongInt;
Begin
   If Canvas.Pen.Mode=pmNot Then
   Begin
      Canvas.Pen.Color:=clBlack;
      Canvas.Brush.Color:=clBlack;
      If BrushStylesForm.BrushStyle<>bsClear Then Canvas.Brush.Style:=bsSolid;
      Canvas.Pen.Style:=psSolid;
   End
   Else
   Begin
      Canvas.Pen.Color:=ColorGridForm.ColorGrid1.ForegroundColor;
      Canvas.Brush.Color:=ColorGridForm.ColorGrid1.BackgroundColor;
      Canvas.Brush.Style:=BrushStylesForm.BrushStyle;
      Canvas.Pen.Style:=PenStylesForm.PenStyle;
   End;

   Case MainToolBarForm.DrawingTool Of
      dtLine:
      Begin
         Canvas.Line(StartPoint.X,StartPoint.Y,EndPoint.X,EndPoint.Y);
      End;
      dtRectangle:
      Begin
         rc.Left:=StartPoint.X;
         rc.Top:=StartPoint.Y;
         rc.Right:=EndPoint.X;
         rc.Bottom:=EndPoint.Y;
         If BrushStylesForm.BrushStyle=bsClear Then Canvas.Rectangle(rc)
         Else Canvas.Box(rc);
      End;
      dtRoundRect:
      Begin
         rc.Left:=StartPoint.X;
         rc.Top:=StartPoint.Y;
         rc.Right:=EndPoint.X;
         rc.Bottom:=EndPoint.Y;
         If BrushStylesForm.BrushStyle=bsClear Then Canvas.RoundRect(rc,10,10)
         Else Canvas.FilledRoundRect(rc,10,10);
      End;
      dtEllipse:
      Begin
         W:=EndPoint.X-StartPoint.X;
         If W<0 Then W:=-W;
         H:=EndPoint.Y-StartPoint.Y;
         If W<0 Then H:=-H;

         If BrushStylesForm.BrushStyle=bsClear Then
             Canvas.Ellipse(StartPoint.X,StartPoint.Y,W,H)
         Else
             Canvas.FilledEllipse(StartPoint.X,StartPoint.Y,W,H);
      End;
   End; //case
End;

Procedure TGraphExForm.Image1OnMouseUp (Sender: TObject; Button: TMouseButton;
                                        Shift: TShiftState; X: LongInt; Y: LongInt);
Begin
   If Button<>mbLeft Then System.exit;

   If DrawMode Then
   Begin
      If EndPoint<>StartPoint Then //erase old figure
      Begin
          Image1.Canvas.Pen.Mode:=pmNot;
          DrawFigure(Image1.Canvas);
      End;

      Image1.Canvas.Pen.Mode:=pmCopy;
      DrawFigure(Image1.Canvas);
      DrawFigure(Image1.Bitmap.Canvas);
      DrawMode:=False;
      Image1.MouseCapture:=False;
   End;
End;

Procedure TGraphExForm.Image1OnMouseMove (Sender: TObject; Shift: TShiftState;
                                          X: LongInt; Y: LongInt);
Begin
   If DrawMode Then
   Begin
       If EndPoint<>StartPoint Then //erase old figure
       Begin
           Image1.Canvas.Pen.Mode:=pmNot;
           DrawFigure(Image1.Canvas);
       End;

       //Draw new figure
       EndPoint:=Point(X,Y);
       Image1.Canvas.Pen.Mode:=pmNot;
       DrawFigure(Image1.Canvas);
   End;
End;

Procedure TGraphExForm.Image1OnMouseDown (Sender: TObject;
               Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
Begin
   If Button<>mbLeft Then System.exit;
   StartPoint:=Point(X,Y);
   EndPoint:=StartPoint;
   DrawMode:=True;
   Image1.MouseCapture:=True;
End;

Procedure TGraphExForm.NewBitmap(CX,CY:LongInt);
Var Bitmap:TBitmap;
    rec:TRect;
Begin
   Bitmap.Create;
   Bitmap.CreatePalette:=True;
   Bitmap.CreateNew(CX,CY,16);
   Bitmap.Canvas.Brush.Color:=clWhite;
   Bitmap.Canvas.Pen.Color:=clWhite;
   rec.Left:=0;
   rec.Right:=CX;
   rec.Bottom:=0;
   rec.Top:=CY;
   Bitmap.Canvas.Box(rec);

   Image1.Bitmap:=Bitmap;
   Bitmap.Destroy;
End;

Procedure TGraphExForm.NewOnClick (Sender: TObject);
Var CX,CY:LongInt;
Begin
   CX:=200;
   CY:=200;
   NewImageForm.Edit1.Text:=IntToStr(CX);
   NewImageForm.Edit2.Text:=IntToStr(CY);
   NewImageForm.ShowModal;
   If NewImageForm.ModalResult=0 Then
   Begin
       Try
          NewBitmap(StrToInt(NewImageForm.Edit1.Text),
                    StrToInt(NewImageForm.Edit2.Text));
       Except
          ErrorBox('Cannot create bitmap. Invalid input');
       End;
   End
End;

Procedure TGraphExForm.Form1OnSetupShow (Sender: TObject);
Begin
  {
  MainToolBarForm.Create(Nil);
  MainToolBarForm.MainToolBar.DockingForm:=Self;
  MainToolBarForm.MainToolBar.DockingState:=dsDock;

  BrushStylesForm.Create(Nil);
  BrushStylesForm.BrushStyles.DockingForm:=Application.MainForm;

  PenStylesForm.Create(Nil);
  PenStylesForm.PenStyles.DockingForm:=Application.MainForm;

  ColorGridForm.Create(Nil);
  ColorGridForm.ColorGrid.DockingForm:=Application.MainForm;
  }
  NewBitmap(200,200);
End;

Initialization
  RegisterClasses ([TGraphExForm, TMainMenu, TMenuItem, TToolbar, TStatusBar,
    TImage, TOpenDialog, TSaveDialog, TLabel]);
End.

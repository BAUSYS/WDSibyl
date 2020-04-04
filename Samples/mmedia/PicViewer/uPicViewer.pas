Unit uPicViewer;

Interface

Uses
  Classes, Forms, Graphics, Buttons, Dialogs, Color, SysUtils,
  ExtCtrls, StdCtrls, WinCrt, TabCtrls, Menus, ExtCtrls, FileCtrl,
  uSysInfo;

type
  TfrmPicViewer = Class (TForm)
    btnLoad: TButton;
    Image: TImage;
    lblBild: TLabel;
    EditFileName: tEditFileName;
    lblTransparentColor: TLabel;
    Shape: TShape;
    fIcon : ticon;
    Procedure frmPicViewerOnPaint (Sender: TObject; Const rec: tRect);
    Procedure btnLoadOnClick (Sender: TObject);
    Procedure frmPicViewerOnSetupShow (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var frmPicViewer : TfrmPicViewer;


Implementation

Procedure TfrmPicViewer.frmPicViewerOnPaint (Sender: TObject;
  Const rec: tRect);
Begin
  Redraw(rec);
/*  Canvas.Pen.Color:=clRed;
  Canvas.Line(0,0, Width, Height);
  Canvas.Line(0,Height, Width, 0); */
End;

Procedure TfrmPicViewer.btnLoadOnClick (Sender: TObject);

Var fn   : tFileName;
    bm   : tBitmap;
    tc   : tColor;
    R,G,B: Byte;

Begin
  fn:=EditFileName.FileName;
  if FileExists(fn)=false then
    Begin
      Messagebox('File not found',mtError,[mbOk]);
      exit;
    End;
  Image.Picture.LoadFromFile(fn);
  bm:=Image.Picture.Bitmap;

// Transparent-Farbe herausfinden
  tc:=bm.TransparentColor;
  lblTransparentColor.PenColor:=bm.TransparentColor;
  RGBToValues(tc,R,G,B);
  lblTransparentColor.Caption:='R='+tostr(R)+', G='+tostr(G)+', B='+tostr(B);
  Shape.Color:=tc;
End;

Procedure TfrmPicViewer.frmPicViewerOnSetupShow (Sender: TObject);

Var CurDir : tFileName;

Begin
  GetDir(0,CurDir);
{$IFDEF OS2}
//  EditFileName.FileName:='V:\SharedFolder\WDSibyl\Test_OS2.bmp';
//  EditFileName.FileName:='V:\SharedFolder\WDSibyl\Test_OS2_16.bmp';
//  EditFileName.FileName:='V:\SharedFolder\WDSibyl\Test_OS2_256.bmp';
//  EditFileName.FileName:=CurDir+'\Test_W32.bmp';
//  EditFileName.FileName:='V:\SharedFolder\WDSibyl\Test_W32_16.bmp';
//  EditFileName.FileName:='V:\SharedFolder\WDSibyl\Test_W32_256.bmp';
//  EditFileName.FileName:='V:\SharedFolder\WDSibyl\Test_W32.ico';
//  EditFileName.FileName:='P:\WDSibyl\WDSibyl\Bmp\WDSibyl\OS2\HELP.PTR';
//  EditFileName.FileName:='V:\SharedFolder\WDSibyl\Test.pcx';
//  EditFileName.FileName:='V:\SharedFolder\WDSibyl\Test.jpg';
//  EditFileName.FileName:='V:\SharedFolder\WDSibyl\Test.gif';
//  EditFileName.FileName:='P:\Toolbox\OnlineCD\quelltexte\TX1997-S1\GIF\FACTORY.GIF';
//    EditFileName.FileName:='P:\WDSibyl\WDSibyl\Bmp\Internet\EMailPOP.bmp';
    EditFileName.FileName:=CurDir+'\Test.gif';

{$ENDIF}
{$IFDEF WIN32}
  EditFileName.FileName:=CurDir+'\Test.gif';
{$ENDIF}
End;


Initialization
  RegisterClasses ([TButton, TImage, TLabel, tEditFileName, TShape]);
End.

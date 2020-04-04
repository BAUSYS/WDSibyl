Unit ImageWin;

Interface

Uses
  SysUtils, Classes, Forms, Graphics, FileCtrl, StdCtrls, ExtCtrls, Buttons,
  Dialogs,ViewWin;

Type
  TImageForm = Class (TForm)
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    FilterComboBox1: TFilterComboBox;
    FileEdit: TEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Image1: TImage;
    ViewBtn: TBitBtn;
    StretchBox: TCheckBox;
    GlyphCheck: TCheckBox;
    UpDownGroup: TGroupBox;
    DisabledGrp: TGroupBox;
    BitBtn1: TBitBtn;
    SpeedButton1: TSpeedButton;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    Procedure ViewBtnOnClick (Sender: TObject);
    Procedure FileListBox1OnItemFocus (Sender: TObject; Index: LongInt);
    Procedure GlyphCheckOnClick (Sender: TObject);
    Procedure StretchBoxOnClick (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
    Bitmap:TBitmap;
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  ImageForm : TImageForm;

Implementation

Procedure TImageForm.ViewBtnOnClick (Sender: TObject);
Begin
  ViewForm.Show;
  ViewForm.BringToFront;
End;

Procedure TImageForm.FileListBox1OnItemFocus (Sender: TObject;Index: LongInt);
Var FileExt:String;
Begin
     If Bitmap<>Nil Then Bitmap.Destroy;
     FileExt:=UpperCase(ExtractFileExt(FileListBox1.FileName));
     If FileExt='.ICO' Then Bitmap:=TIcon.Create
     Else Bitmap:=TBitmap.Create;
     Try
        Bitmap.LoadFromFile(FileListBox1.FileName);
     Except
        On E:Exception Do
        Begin
           ErrorBox(E.Message+' for file:'+FileListBox1.FileName);
           Bitmap.Destroy;
           Bitmap:=Nil;
        End;
     End;

     If Bitmap<>Nil Then
     Begin
         Image1.Bitmap:=Bitmap;
         GlyphCheckOnClick(GlyphCheck);
         ViewForm.Image1.Bitmap:=Bitmap;
         Caption:='Sibyl ImageView ['+tostr(Bitmap.Width)+'x'+
                  tostr(Bitmap.Height)+']';
         ViewForm.Caption:='Sibyl ImageView Full View ['+tostr(Bitmap.Width)+'x'+
                           tostr(Bitmap.Height)+']';
     End;
End;

Procedure TImageForm.GlyphCheckOnClick (Sender: TObject);
Begin
   If GlyphCheck.Checked Then
   Begin
      BitBtn1.Glyph:=Bitmap;
      SpeedButton1.Glyph:=Bitmap;
      BitBtn2.Glyph:=Bitmap;
      SpeedButton2.Glyph:=Bitmap;
   End
   Else
   Begin
      BitBtn1.Glyph:=Nil;
      SpeedButton1.Glyph:=Nil;
      BitBtn2.Glyph:=Nil;
      SpeedButton2.Glyph:=Nil;
   End;
End;

Procedure TImageForm.StretchBoxOnClick (Sender: TObject);
Begin
  Image1.Stretch:=StretchBox.Checked;
End;

Initialization
  RegisterClasses ([TImageForm, TFileListBox, TDirectoryListBox, TDriveComboBox,
    TFilterComboBox, TEdit, TBevel, TImage, TBitBtn, TCheckBox, TGroupBox,
    TSpeedButton, TImageForm]);
End.

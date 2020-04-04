unit Unit2;

interface

uses  Classes, Graphics, Forms,
  FileCtrl, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TImageForm1 = class(TForm)
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    FileEdit: TEdit;
    UpDownGroup: TGroupBox;
    SpeedButton1: TSpeedButton;
    BitBtn1: TBitBtn;
    DisabledGrp: TGroupBox;
    SpeedButton2: TSpeedButton;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Image1: TImage;
    FileListBox1: TFileListBox;
    Label2: TLabel;
    ViewBtn: TBitBtn;
    FilterComboBox1: TFilterComboBox;
    GlyphCheck: TCheckBox;
    StretchCheck: TCheckBox;
    UpDownEdit: TEdit;
    UpDown1: TUpDown;
    Procedure BitBtn1OnClick (Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
    procedure ViewAsGlyph(const FileExt: string);
    procedure GlyphCheckClick(Sender: TObject);
    procedure StretchCheckClick(Sender: TObject);
    procedure FileEditKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FormCaption: string;    
  end;

var
  ImageForm1: TImageForm1;

implementation

uses Unit3,SysUtils;



Procedure TImageForm1.BitBtn1OnClick (Sender: TObject);
Begin
  MessageBox2('Text',mtInformation,[mbOk]);
End;

procedure TImageForm1.FileListBox1Click(Sender: TObject);
var
  FileExt: string[4];
begin
  FileExt := AnsiUpperCase(ExtractFileExt(FileListBox1.Filename));
  if (FileExt = '.BMP') or (FileExt = '.ICO') or (FileExt = '.WMF') or
    (FileExt = '.EMF') then
  begin
    Image1.Picture.LoadFromFile(FileListBox1.Filename);
    Caption := FormCaption + ExtractFilename(FileListBox1.Filename);
    if (FileExt = '.BMP') then
    begin
      Caption := Caption + 
        Format(' (%d x %d)', [Image1.Picture.Width, Image1.Picture.Height]);
      ViewForm1.Image1.Picture := Image1.Picture;
      ViewForm1.Caption := Caption;
      if GlyphCheck.Checked then ViewAsGlyph(FileExt);
    end
    else
      GlyphCheck.Checked := False;
    //if FileExt = '.ICO' then Icon := Image1.Picture.Icon;
    //if (FileExt = '.WMF') or (FileExt = '.EMF') then
    //  ViewForm1.Image1.Picture.Metafile := Image1.Picture.Metafile;
  end;
end;

procedure TImageForm1.GlyphCheckClick(Sender: TObject);
begin
  ViewAsGlyph(AnsiUpperCase(ExtractFileExt(FileListBox1.Filename)));
end;

procedure TImageForm1.ViewAsGlyph(const FileExt: string);
begin
  if GlyphCheck.Checked and (FileExt = '.BMP') then 
  begin
    SpeedButton1.Glyph := Image1.Picture;
    SpeedButton2.Glyph := Image1.Picture;
    //UpDown1.Position := SpeedButton1.NumGlyphs;
    BitBtn1.Glyph := Image1.Picture;
    BitBtn2.Glyph := Image1.Picture;
    UpDown1.Enabled := True;
    UpDownEdit.Enabled := True;
    Label2.Enabled := True;
  end
  else begin
    SpeedButton1.Glyph := nil;
    SpeedButton2.Glyph := nil;
    BitBtn1.Glyph := nil;
    BitBtn2.Glyph := nil;
    UpDown1.Enabled := False;
    UpDownEdit.Enabled := False;
    Label2.Enabled := False;
  end;
end;

procedure TImageForm1.ViewBtnClick(Sender: TObject);
begin
  ViewForm1.HorzScrollBar.Max := Image1.Picture.Width;
  ViewForm1.VertScrollBar.Max := Image1.Picture.Height;
  ViewForm1.Caption := Caption;
  ViewForm1.Show;
  ViewForm1.WindowState := wsNormal;
end;

procedure TImageForm1.UpDownEditChange(Sender: TObject);
begin
  //SpeedButton1.NumGlyphs := UpDown1.Position;
  //SpeedButton2.NumGlyphs := UpDown1.Position;
end;

procedure TImageForm1.StretchCheckClick(Sender: TObject);
begin
  Image1.Stretch := StretchCheck.Checked;
end;

procedure TImageForm1.FileEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then 
  begin
    //FileListBox1.ApplyFilePath(FileEdit.Text);
    Key := #0;
  end;
end;

procedure TImageForm1.FormCreate(Sender: TObject);
begin
  FormCaption := Caption + ' - ';
end;

Initialization
  RegisterClasses ([TImageForm1, TLabel, TDirectoryListBox,
    TDriveComboBox, TEdit, TGroupBox, TSpeedButton, TBitBtn, TPanel, TImage,
    TFileListBox, TFilterComboBox, TCheckBox, TUpDown]);
end.

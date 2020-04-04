Unit AboutWin;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, Buttons, StdCtrls;

Type
  TAboutBox1 = Class (TForm)
      Panel1: TPanel;
      ProgramIcon: TImage;
      OkButton: TBitBtn;
      ProductName: TLabel;
      Version: TLabel;
      Copyright: TLabel;
      Comment: TLabel;
    Private
      {Insert private declarations here}
    Public
      {Insert public declarations here}
  End;

Var
  AboutBox1: TAboutBox1;

Implementation

Initialization
  RegisterClasses ([TAboutBox1]);
End.

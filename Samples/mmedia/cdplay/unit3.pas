unit Unit3;

interface

uses
  SysUtils,  Messages, Classes, Graphics,
  Forms, Dialogs, ExtCtrls;

type                             
  TViewForm1 = class(TForm)
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewForm1: TViewForm1;

implementation


begin
  RegisterClasses ([TViewForm1, TImage]);
end.
 

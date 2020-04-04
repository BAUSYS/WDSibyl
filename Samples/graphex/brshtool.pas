Unit BrshTool;

Interface

Uses
  Classes, Forms, Graphics, DockTool, Buttons;

Type
  TBrushStylesForm = Class (TForm)
    BrushStyles: TDockingToolbar;
    BDiagBtn: TSpeedButton;
    CrossBtn: TSpeedButton;
    DCrossBtn: TSpeedButton;
    ClearBtn: TSpeedButton;
    FDiagBtn: TSpeedButton;
    HorizBtn: TSpeedButton;
    SolidBtn: TSpeedButton;
    VerticBtn: TSpeedButton;
    Procedure StyleChange (Sender: TObject);
    Procedure BrushStylesFormOnCreate (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
    BrushStyle:TBrushStyle;
  End;

Var
  BrushStylesForm: TBrushStylesForm;

Implementation

Procedure TBrushStylesForm.StyleChange (Sender: TObject);
Var Btn:TSpeedButton;
Begin
  Btn:=TSpeedButton(Sender);
  If not Btn.Down Then exit;

  If Btn=BDiagBtn Then BrushStyle:=bsBDiagonal
  Else If Btn=CrossBtn Then BrushStyle:=bsCross
  Else If Btn=DCrossBtn Then BrushStyle:=bsDiagCross
  Else If Btn=ClearBtn Then BrushStyle:=bsClear
  Else If Btn=FDiagBtn Then BrushStyle:=bsFDiagonal
  Else If Btn=HorizBtn Then BrushStyle:=bsHorizontal
  Else If Btn=SolidBtn Then BrushStyle:=bsSolid
  Else If Btn=VerticBtn Then BrushStyle:=bsVertical;
End;

Procedure TBrushStylesForm.BrushStylesFormOnCreate (Sender: TObject);
Begin
  BrushStyle:=bsSolid;
  SolidBtn.Down:=True;
End;

Initialization
  RegisterClasses ([TBrushStylesForm, TDockingToolbar, TSpeedButton]);
End.

Unit PenTool;

Interface

Uses
  Classes, Forms, Graphics, DockTool, Buttons, StdCtrls;

Type
  TPenStylesForm = Class (TForm)
    PenStyles: TDockingToolbar;
    ClearBtn: TSpeedButton;
    DashDotBtn: TSpeedButton;
    DashDot2Btn: TSpeedButton;
    DashedBtn: TSpeedButton;
    DottedBtn: TSpeedButton;
    SolidBtn: TSpeedButton;
    Procedure PenStylesFormOnCreate (Sender: TObject);
    Procedure StyleChange (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
    PenStyle:TPenStyle;
  End;

Var
  PenStylesForm: TPenStylesForm;

Implementation

Procedure TPenStylesForm.PenStylesFormOnCreate (Sender: TObject);
Begin
   PenStyle:=psSolid;
   SolidBtn.Down:=True;
End;

Procedure TPenStylesForm.StyleChange (Sender: TObject);
Var Btn:TSpeedButton;
Begin
    Btn:=TSpeedButton(Sender);
    If not Btn.Down Then exit;

    If Btn=ClearBtn Then PenStyle:=psClear
    Else If Btn=DashDotBtn Then PenStyle:=psDashDot
    Else If Btn=DashDot2Btn Then PenStyle:=psDashDotDot
    Else If Btn=DashedBtn Then PenStyle:=psDash
    Else If Btn=DottedBtn Then PenStyle:=psDot
    Else If Btn=SolidBtn Then PenStyle:=psSolid;
End;

Initialization
  RegisterClasses ([TPenStylesForm, TDockingToolbar, TSpeedButton]);
End.

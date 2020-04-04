Unit MainTool;

Interface

Uses
  Classes, Forms, Graphics, DockTool, Buttons, BrshTool, PenTool,
  ColTool;

Type
  TDrawingTool=(dtLine,dtRectangle,dtRoundRect,dtEllipse);

  TMainToolBarForm = Class (TForm)
    MainToolbar: TDockingToolbar;
    EllipseBtn: TSpeedButton;
    LineBtn: TSpeedButton;
    RectangleBtn: TSpeedButton;
    RoundRectBtn: TSpeedButton;
    PenStylesBtn: TSpeedButton;
    BrushStylesBtn: TSpeedButton;
    ColorGridBtn: TSpeedButton;
    Procedure FigureChanged (Sender: TObject);
    Procedure MainToolBarFormOnCreate (Sender: TObject);
    Procedure ColorGridBtnOnClick (Sender: TObject);
    Procedure PenStylesBtnOnClick (Sender: TObject);
    Procedure BrushStylesBtnOnClick (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
    DrawingTool:TDrawingTool;
  End;

Var
  MainToolBarForm: TMainToolBarForm;

Implementation

Procedure TMainToolBarForm.FigureChanged (Sender: TObject);
Var Btn:TSpeedButton;
Begin
   Btn:=TSpeedButton(Sender);
   If not Btn.Down Then exit;

   If Btn=EllipseBtn Then DrawingTool:=dtEllipse
   Else If Btn=LineBtn Then DrawingTool:=dtLine
   Else If Btn=RectangleBtn Then DrawingTool:=dtRectangle
   Else If Btn=RoundRectBtn Then DrawingTool:=dtRoundRect;
End;

Procedure TMainToolBarForm.MainToolBarFormOnCreate (Sender: TObject);
Begin
  DrawingTool:=dtLine;
  LineBtn.Down:=True;
End;

Procedure TMainToolBarForm.ColorGridBtnOnClick (Sender: TObject);
Begin
  If ColorGridBtn.Down Then ColorGridForm.ColorGrid.DockingState:=dsFloat
  Else ColorGridForm.ColorGrid.DockingState:=dsHide;
End;

Procedure TMainToolBarForm.PenStylesBtnOnClick (Sender: TObject);
Begin
  If PenStylesBtn.Down Then PenStylesForm.PenStyles.DockingState:=dsDock
  Else PenStylesForm.PenStyles.DockingState:=dsHide;
End;

Procedure TMainToolBarForm.BrushStylesBtnOnClick (Sender: TObject);
Begin
  If BrushStylesBtn.Down Then BrushStylesForm.BrushStyles.DockingState:=dsDock
  Else BrushStylesForm.BrushStyles.DockingState:=dsHide;
End;

Initialization
  RegisterClasses ([TMainToolBarForm, TDockingToolbar, TSpeedButton]);
End.

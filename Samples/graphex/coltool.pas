Unit ColTool;

Interface

Uses
  Classes, Forms, Graphics, DockTool, ColorGrd;

Type
  TColorGridForm = Class (TForm)
    ColorGrid: TDockingToolbar;
    ColorGrid1: TColorGrid;
  Private
    {Private Deklarationen hier einf�gen}
  Public
    {�ffentliche Deklarationen hier einf�gen}
  End;

Var
  ColorGridForm: TColorGridForm;

Implementation

Initialization
  RegisterClasses ([TColorGridForm, TDockingToolbar, TColorGrid]);
End.

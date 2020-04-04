Unit ColTool;

Interface

Uses
  Classes, Forms, Graphics, DockTool, ColorGrd;

Type
  TColorGridForm = Class (TForm)
    ColorGrid: TDockingToolbar;
    ColorGrid1: TColorGrid;
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  ColorGridForm: TColorGridForm;

Implementation

Initialization
  RegisterClasses ([TColorGridForm, TDockingToolbar, TColorGrid]);
End.

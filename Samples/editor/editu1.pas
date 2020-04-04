Unit EditU1;

Interface

Uses
  Classes, Forms, Graphics, Buttons, Dialogs, Editors, Menus;

Type
  TForm1 = Class (TForm)
    MainMenu1: TMainMenu;
    Toolbar1: TToolbar;
    OpenButton1: TSpeedButton;
    NewButton1: TSpeedButton;
    SaveButton1: TSpeedButton;
    SaveAsButton1: TSpeedButton;
    CutButton1: TSpeedButton;
    CopyButton1: TSpeedButton;
    PasteButton1: TSpeedButton;
    UndoButton1: TSpeedButton;
    RedoButton1: TSpeedButton;
    TileButton1: TSpeedButton;
    CascadeButton1: TSpeedButton;
    HelpButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Toolbar2: TToolbar;
    Procedure CloseOnClick (Sender: TObject);
    Procedure PreviousOnClick (Sender: TObject);
    Procedure NextOnClick (Sender: TObject);
    Procedure MaximizeOnClick (Sender: TObject);
    Procedure CloseAllOnClick (Sender: TObject);
    Procedure CascadeOnClick (Sender: TObject);
    Procedure TileOnClick (Sender: TObject);
    Procedure PasteOnClick (Sender: TObject);
    Procedure CopyOnClick (Sender: TObject);
    Procedure CutOnClick (Sender: TObject);
    Procedure RedoOnClick (Sender: TObject);
    Procedure UndoOnClick (Sender: TObject);
    Procedure SaveAsOnClick (Sender: TObject);
    Procedure SaveOnClick (Sender: TObject);
    Procedure OpenOnClick (Sender: TObject);
    Procedure NewOnClick (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  Form1: TForm1;

Implementation

Procedure TForm1.CloseOnClick (Sender: TObject);
Begin
    If ActiveMDIChild=Nil Then exit;
    TEditor(ActiveMDIChild).Close;
End;

Procedure TForm1.PreviousOnClick (Sender: TObject);
Begin
    Previous;
End;

Procedure TForm1.NextOnClick (Sender: TObject);
Begin
    Next;
End;

Procedure TForm1.MaximizeOnClick (Sender: TObject);
Begin
    If ActiveMDIChild=Nil Then exit;
    TEditor(ActiveMDIChild).WindowState:=wsMaximized;
End;

Procedure TForm1.CloseAllOnClick (Sender: TObject);
Begin
    CloseAll;
End;

Procedure TForm1.CascadeOnClick (Sender: TObject);
Begin
    Cascade;
End;

Procedure TForm1.TileOnClick (Sender: TObject);
Begin
    Tile;
End;

Procedure TForm1.PasteOnClick (Sender: TObject);
Begin
    If ActiveMDIChild=Nil Then exit;
    TEditor(ActiveMDIChild).PasteFromClipBoard;
End;

Procedure TForm1.CopyOnClick (Sender: TObject);
Begin
    If ActiveMDIChild=Nil Then exit;
    TEditor(ActiveMDIChild).CopyToClipBoard;
End;

Procedure TForm1.CutOnClick (Sender: TObject);
Begin
    If ActiveMDIChild=Nil Then exit;
    TEditor(ActiveMDIChild).CutToClipBoard;
End;

Procedure TForm1.RedoOnClick (Sender: TObject);
Begin
    If ActiveMDIChild=Nil Then exit;
    TEditor(ActiveMDIChild).Redo;
End;

Procedure TForm1.UndoOnClick (Sender: TObject);
Begin
    If ActiveMDIChild=Nil Then exit;
    TEditor(ActiveMDIChild).Undo;
End;

Procedure TForm1.SaveAsOnClick (Sender: TObject);
Begin
   If ActiveMDIChild=Nil Then exit;
   If SaveDialog1.Execute Then
   Begin
        TEditor(ActiveMDIChild).SaveToFile(SaveDialog1.FileName);
        TEditor(ActiveMDIChild).Caption:=TEditor(ActiveMDIChild).FileName;
   End;
End;

Procedure TForm1.SaveOnClick (Sender: TObject);
Begin
   TEditor(ActiveMDIChild).SaveToFile(TEditor(ActiveMDIChild).FileName);;
End;

Procedure TForm1.OpenOnClick (Sender: TObject);
Var Editor:TEditor;
Begin
   If OpenDialog1.Execute Then
   Begin
        Editor.Create(Self);
        Editor.FormStyle:=fsMDIChild;
        Editor.LoadFromFile(OpenDialog1.FileName);
        Editor.Caption:=OpenDialog1.FileName;
        Editor.Parent:=Self;
        Editor.WindowState:=wsMaximized;
        Editor.Show;
        Editor.BringToFront;
   End;
End;

Procedure TForm1.NewOnClick (Sender: TObject);
Var Editor:TEditor;
Begin
     Editor.Create(Self);
     Editor.FormStyle:=fsMDIChild;
     Editor.Caption:='Untitled.txt';
     Editor.FileName:=Editor.Caption;
     Editor.Parent:=Self;
     Editor.WindowState:=wsMaximized;
     Editor.Show;
     Editor.BringToFront;
End;

Initialization
  RegisterClasses ([TForm1, TMainMenu, TToolbar, TSpeedButton, TOpenDialog,
    TSaveDialog]);
End.

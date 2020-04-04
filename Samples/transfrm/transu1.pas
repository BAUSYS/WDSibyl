Unit TransU1;

{
This example uses model transform operations to perform various
graphical transformations to a picture. It also shows usage of
operator overloading and path/area usage in Sibyl
}

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, StdCtrls,
  Color;

Type
  TTransformForm = Class (TForm)
    ToolBar1: TToolbar;
    PaintBox1: TPaintBox;
    ScrollBar1: TScrollBar;
    Label1: TLabel;
    ScrollBar2: TScrollBar;
    Label2: TLabel;
    ScrollBar3: TScrollBar;
    Label3: TLabel;
    ScrollBar4: TScrollBar;
    Label4: TLabel;
    Procedure ScrollBar4OnChange (Sender: TObject);
    Procedure TransformFormOnCreate (Sender: TObject);
    Procedure ScrollBar3OnChange (Sender: TObject);
    Procedure ScrollBar2OnChange (Sender: TObject);
    Procedure ScrollBar1OnChange (Sender: TObject);
    Procedure PaintBox1OnPaint (Sender: TObject; Const rec: TRect);
  Private
    {Insert private declarations here}
    ShearXMatrix,ShearYMatrix,RotationMatrix,ScalingMatrix:TMatrix;
  Public
    {Insert public declarations here}
    Procedure DrawPetals;
    Procedure DrawPetal(Path:Boolean);
  End;

Var
  TransformForm: TTransformForm;

Implementation

Procedure TTransformForm.ScrollBar4OnChange (Sender: TObject);
Begin
  ScalingMatrix.CreateScaling(ScrollBar4.Position,ScrollBar4.Position);
  PaintBox1.Invalidate;
End;

Procedure TTransformForm.TransformFormOnCreate (Sender: TObject);
Begin
  ShearXMatrix.CreateXShear(0);
  ShearYMatrix.CreateYShear(0);
  RotationMatrix.CreateRotation(0);
  ScalingMatrix.CreateScaling(25,25);
End;

Procedure TTransformForm.DrawPetal(Path:Boolean);
Const aptl:Array[0..6] Of TPoint=
        (
         (x:0;y:0),
         (x:125;y:125),
         (x:475;y:125),
         (x:600;y:0),
         (x:475;y:-125),
         (x:125;y:-125),
         (x:0;y:0)
        );
Begin
     PaintBox1.Canvas.LineColor:=clGreen;
     PaintBox1.Canvas.AreaColor:=clRed;
     If Path Then PaintBox1.Canvas.BeginPath
     Else PaintBox1.Canvas.BeginArea(arBoundaryAlternate);
     PaintBox1.Canvas.PolySpline(aptl);
     If Path Then
     Begin
          PaintBox1.Canvas.EndPath;
          PaintBox1.Canvas.PathToClipRegion(paDiff);
     End
     Else PaintBox1.Canvas.EndArea;
End;

Procedure TTransformForm.DrawPetals;
Var i:LongInt;
    OldMatrix:TMatrix;
    m:TMatrix;
Begin
     //get current transformation matrix
     OldMatrix:=PaintBox1.Canvas.TransformMatrix;

     //add the various transforms
     //this uses operator overloading for matrix classes defined
     //in the FORMS unit

     //add X shear
     OldMatrix:=ShearXMatrix*OldMatrix;

     //add Y shear
     OldMatrix:=ShearYMatrix*OldMatrix;

     //add Rotation
     OldMatrix:=RotationMatrix*OldMatrix;

     //add scaling
     OldMatrix:=ScalingMatrix*OldMatrix;

     For i:=0 To 7 Do
     Begin
          //create a rotation Matrix for each piece of the flower
          m.CreateRotation(180*i/4);

          //add matrix to the current transformation and replace it
          //this uses operator overloading for matrix classes defined
          //in the FORMS unit
          PaintBox1.Canvas.Transform(m*OldMatrix,trReplace);

          //Draw a petal
          DrawPetal(False);

          //subtract this path from the clipping region of the window
          DrawPetal(True);

          PaintBox1.Canvas.ResetTransform;
     End;
End;

Procedure TTransformForm.ScrollBar3OnChange (Sender: TObject);
Begin
    RotationMatrix.CreateRotation(ScrollBar3.Position);
    PaintBox1.Invalidate;
End;

Procedure TTransformForm.ScrollBar2OnChange (Sender: TObject);
Begin
    ShearYMatrix.CreateYShear(ScrollBar2.Position/2);
    PaintBox1.Invalidate;
End;

Procedure TTransformForm.ScrollBar1OnChange (Sender: TObject);
Begin
    ShearXMatrix.CreateXShear(ScrollBar1.Position/2);
    PaintBox1.Invalidate;
End;

Procedure TTransformForm.PaintBox1OnPaint (Sender: TObject; Const rec: TRect);
Var
    m:TMatrix;
Begin
     PaintBox1.Canvas.ClipRect:=rec;

     //Translate transformation for all subsequent drawings
     m.CreateTranslation(PaintBox1.Width Div 2,PaintBox1.Height Div 2);
     PaintBox1.Canvas.TransformMatrix:=m;

     //draw the petals of the flower
     DrawPetals;

     //undo all transformations made for this canvas
     PaintBox1.Canvas.ResetTransform;

     //Fill the interior with white
     PaintBox1.Canvas.FillRect(rec,clWhite);
End;

Initialization
  RegisterClasses ([TTransformForm, TToolbar, TPaintBox, TScrollBar, TLabel]);
End.

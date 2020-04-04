Unit SortForm;

Interface

Uses
  Dos, Classes, Forms, ExtCtrls, Buttons, StdCtrls,
  uSysClass, Graphics, Color, SysUtils;

Type
  TThreadSortForm = Class (TForm)
    StartBtn: TBitBtn;
    gbBubbleSort: TGroupBox;
    gbSelectionSort: TGroupBox;
    gbQuickSort: TGroupBox;

    BubbleSortBox: TPaintBox;
    SelectionSortBox: TPaintBox;
    QuickSortBox: TPaintBox;

    Procedure ThreadSortFormOnResize (Sender: TObject);
    Procedure SelectionSortBoxOnPaint (Sender: TObject; Const rec: TRect);
    Procedure StartBtnOnClick(Sender:TObject);
    Procedure ThreadSortFormOnCreate (Sender: TComponent);
    Procedure QuickSortBoxOnPaint (Sender: TObject; Const rec: TRect);
    Procedure BubbleSortBoxOnPaint (Sender: TObject; Const rec: TRect);

  Private
    {Insert private declarations here}
    ThreadsRunning:LongInt;
    procedure RandomizeArrays;
    procedure PaintArray(Box: TPaintBox; const A: array of LongInt);
    procedure ThreadDone(Sender: TObject);
  Public
    {Insert public declarations here}
  End;

Var
  ThreadSortForm: TThreadSortForm;

Type
  PSortArray = ^TSortArray;
  TSortArray = array[0..114] of LongInt;

var
  ArraysRandom: Boolean;
  BubbleSortArray, SelectionSortArray, QuickSortArray: TSortArray;

type
  TSortThread = class(TThread)
  private
    FBox: TPaintBox;
    FSortArray: PSortArray;
    FSize: LongInt;
    FA, FB, FI, FJ: LongInt;
    procedure DoVisualSwap;
  protected
    procedure Execute; override;
    procedure VisualSwap(A, B, I, J: LongInt);
    procedure Sort(var A: array of LongInt); virtual; abstract;
  public
    constructor Create(Box: TPaintBox; var SortArray: array of LongInt);
  end;

  TBubbleSort = class(TSortThread)
  protected
    procedure Sort(var A: array of LongInt); override;
  end;

  TSelectionSort = class(TSortThread)
  protected
    procedure Sort(var A: array of LongInt); override;
  end;

  TQuickSort = class(TSortThread)
  protected
    procedure Sort(var A: array of LongInt); override;
  end;

procedure PaintLine(Box:TPaintBox; Canvas: TCanvas; I, Len: LongInt);

Implementation

procedure PaintLine(Box:TPaintBox; Canvas: TCanvas; I, Len: LongInt);
var SaveColor:TColor;
begin
  Canvas.PolyLine([Point(0, Box.ClientHeight-I * 2 + 1), Point(Len, Box.ClientHeight-I * 2 + 1)]);
  SaveColor:=Canvas.Pen.Color;
  Canvas.Pen.Color:=Box.Color;
  Canvas.PolyLine([Point(Len, Box.ClientHeight-I * 2 + 1), Point(Box.ClientWidth, Box.ClientHeight-I * 2 + 1)]);
  Canvas.PolyLine([Point(0, Box.ClientHeight-I * 2), Point(Box.ClientWidth, Box.ClientHeight-I * 2)]);
  Canvas.Pen.Color:=SaveColor;
end;

//TSortThread

constructor TSortThread.Create(Box: TPaintBox; var SortArray: array of LongInt);
begin
  FBox := Box;
  FSortArray := @SortArray;
  FSize := High(SortArray) - Low(SortArray) + 1;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TSortThread.DoVisualSwap;
begin
  with FBox do
  begin
    Canvas.Pen.Color := clBtnFace;
    PaintLine(FBox,Canvas, FI, FA);
    PaintLine(FBox,Canvas, FJ, FB);
    Canvas.Pen.Color := clRed;
    PaintLine(FBox,Canvas, FI, FB);
    PaintLine(FBox,Canvas, FJ, FA);
  end;
end;

procedure TSortThread.VisualSwap(A, B, I, J: LongInt);
begin
  FA := A;
  FB := B;
  FI := I;
  FJ := J;
  Synchronize(DoVisualSwap);
end;

procedure TSortThread.Execute;
begin
  Sort(Slice(FSortArray^,FSize));
end;

//TBubbleSort

procedure TBubbleSort.Sort(var A: array of LongInt);
var
  I, J, T: Integer;
begin
  for I := High(A) downto Low(A) do
  Begin
    for J := Low(A) to High(A) - 1 do
      if A[J] > A[J + 1] then
      begin
        VisualSwap(A[J], A[J + 1], J, J + 1);
        T := A[J];
        A[J] := A[J + 1];
        A[J + 1] := T;
        if Terminated then Exit;
      end;
  End;
end;

//TSelectionSort

procedure TSelectionSort.Sort(var A: array of LongInt);
var
  I, J, T: Integer;
begin
  for I := Low(A) to High(A) - 1 do
  begin
    for J := High(A) downto I + 1 do
      if A[I] > A[J] then
      begin
        VisualSwap(A[I], A[J], I, J);
        T := A[I];
        A[I] := A[J];
        A[J] := T;
        if Terminated then Exit;
      end;
  end;
end;

//TQuickSort

procedure TQuickSort.Sort(var A: array of LongInt);

  procedure QuickSort(var A: array of LongInt; iLo, iHi: LongInt);
  var
    Lo, Hi, Mid, T: Integer;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := A[(Lo + Hi) div 2];
    repeat
      while A[Lo] < Mid do Inc(Lo);
      while A[Hi] > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        VisualSwap(A[Lo], A[Hi], Lo, Hi);
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
    if Terminated then Exit;
  end;

begin
  QuickSort(A, Low(A), High(A));
end;

//TThreadSortForm

Procedure TThreadSortForm.SelectionSortBoxOnPaint (Sender: TObject;
                                                   Const rec: TRect);
Begin
   PaintArray(SelectionSortBox, SelectionSortArray);
End;

Procedure TThreadSortForm.StartBtnOnClick (Sender: TObject);
var bs:TBubbleSort;
    qs:TQuickSort;
    ss:TSelectionSort;
Begin
  RandomizeArrays;
  ThreadsRunning := 3;
  bs.Create(BubbleSortBox, BubbleSortArray);
  bs.OnTerminate := ThreadDone;
  Delay(10);
  ss.Create(SelectionSortBox, SelectionSortArray);
  ss.OnTerminate := ThreadDone;
  Delay(10);
  qs.Create(QuickSortBox, QuickSortArray);
  qs.OnTerminate := ThreadDone;
  Delay(10);
  StartBtn.Enabled := False;
End;

procedure TThreadSortForm.RandomizeArrays;
var
  I: LongInt;
begin
  if not ArraysRandom then
  begin
    Randomize;
    for I := Low(BubbleSortArray) to High(BubbleSortArray) do
      BubbleSortArray[I] := Random(170);
    SelectionSortArray := BubbleSortArray;
    QuickSortArray := BubbleSortArray;
    ArraysRandom := True;
    Repaint;         
  end;
end;

procedure TThreadSortForm.PaintArray(Box: TPaintBox; const A: array of LongInt);
var
  I: LongInt;
begin
  with Box do
  begin
    Canvas.Pen.Color := clRed;
    for I := Low(A) to High(A) do PaintLine(Box, Canvas, I, A[I]);
    for I := High(A) to Box.ClientHeight do PaintLine(Box, Canvas, I, 0);
  end;
end;

Procedure TThreadSortForm.ThreadSortFormOnCreate (Sender: TComponent);
Begin
  RandomizeArrays;
End;

Procedure TThreadSortForm.QuickSortBoxOnPaint (Sender: TObject; Const rec: TRect);
Begin
   PaintArray(QuickSortBox, BubbleSortArray);
End;

Procedure TThreadSortForm.BubbleSortBoxOnPaint (Sender: TObject; Const rec: TRect);
Begin
   PaintArray(BubbleSortBox, BubbleSortArray);
End;

procedure TThreadSortForm.ThreadDone(Sender: TObject);
begin
  Dec(ThreadsRunning);
  if ThreadsRunning = 0 then
  begin
    StartBtn.Enabled := True;
    ArraysRandom := False;
  end;
end;

// -----------------------------------------------------------------------

Procedure TThreadSortForm.ThreadSortFormOnResize (Sender: TObject);

var l, w, h : LongInt;

Begin
  l:=Round(Width/3);
  w:=l-20;
  h:=Height-100;

  gbBubbleSort.SetWindowPos(16,64,w,h);
  gbSelectionSort.SetWindowPos(l+10,64,w,h);
  gbQuickSort.SetWindowPos(l*2+10,64,w,h);

  h:=h-50;
  w:=w-32;
  BubbleSortBox.SetWindowPos(16,16,w,h);
  SelectionSortBox.SetWindowPos(16,16,w,h);
  QuickSortBox.SetWindowPos(16,16,w,h);
End;



Begin
  RegisterClasses ([TThreadSortForm, TBitBtn, TPaintBox,
    TGroupBox]);
End.

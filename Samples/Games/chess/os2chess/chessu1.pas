Unit ChessU1;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, Grids,
  Buttons, ComCtrls, ExtCtrls,  ChessOpt, uList,
  Color, Menus, Chess;

Type
  TChessForm = Class (TForm)
    DrawGrid: TDrawGrid;
    ImageList1: TImageList;
    StatusBar: TStatusBar;
    Panel: TPanel;
    lbl8: TLabel;
    lbl7: TLabel;
    lbl6: TLabel;
    lbl5: TLabel;
    lbl4: TLabel;
    lbl3: TLabel;
    lbl2: TLabel;
    lbl1: TLabel;
    MainMenu: TMainMenu;
    lblA: TLabel;
    lblB: TLabel;
    lblC: TLabel;
    lblD: TLabel;
    lblE: TLabel;
    lblF: TLabel;
    lblG: TLabel;
    lblH: TLabel;
    ChangeColorsItem: TMenuItem;
    StopButton: TButton;
    NewItem: TMenuItem;
    TakeBackItem: TMenuItem;
    HintItem: TMenuItem;
    OptionsItem: TMenuItem;
    MenuItem8: TMenuItem;
    ExitItem: TMenuItem;
    ListBox1: TListBox;
    lblMoves: TLabel;
    TakeBackMoveBtn: TButton;
    HintBtn: TButton;
    DoMoveBtn: TButton;
    MenuItem6: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem1: TMenuItem;
    Procedure ChangeColorsItemOnClick (Sender: TObject);
    Procedure StopButtonOnClick (Sender: TObject);
    Procedure OptionsItemOnClick (Sender: TObject);
    Procedure DoMoveBtnOnClick (Sender: TObject);
    Procedure HintItemOnClick (Sender: TObject);
    Procedure TakeBackItemOnClick (Sender: TObject);
    Procedure NewItemOnClick (Sender: TObject);
    Procedure DrawGrid1OnSelectCell (Sender: TObject; Col: LongInt;
      Row: LongInt);
    Procedure Form1OnCreate (Sender: TObject);
    Procedure DrawGrid1OnDrawCell (Sender: TObject; ACol: LongInt;
                                   ARow: LongInt; rc: TRect; State: TGridDrawState);
  Private
    {Insert private declarations here}
    Move:Integer;
    PlayerColor:LongInt;
    MoveFrom:LongInt;
    InBack:Boolean;
    Moves:TList;
    LastMove:TMove;

    BoardFlipped:Boolean;
    Procedure ComputerMove;
    Procedure DoMoveFigure(Mov:TMove);
    Function MakeMove(Mov:TMove):String;
  Public
    {Insert public declarations here}
  End;

Var
  ChessForm: TChessForm;

Implementation

Const MapFigure:Array[1..6] of integer=(3,5,0,2,4,1);

Procedure TChessForm.ChangeColorsItemOnClick (Sender: TObject);
Begin
    PlayerColor:=-PlayerColor;
    BoardFlipped:=not BoardFlipped;
    DrawGrid.Invalidate;
    If BoardFlipped Then
    Begin
       lbl1.Caption:='1';
       lbl2.Caption:='2';
       lbl3.Caption:='3';
       lbl4.Caption:='4';
       lbl5.Caption:='5';
       lbl6.Caption:='6';
       lbl7.Caption:='7';
       lbl8.Caption:='8';
       lblH.Caption:='H';
       lblG.Caption:='G';
       lblF.Caption:='F';
       lblE.Caption:='E';
       lblD.Caption:='D';
       lblC.Caption:='C';
       lblB.Caption:='B';
       lblA.Caption:='A';
    End
    Else
    Begin
       Lbl1.Caption:='8';
       Lbl2.Caption:='7';
       Lbl3.Caption:='6';
       Lbl4.Caption:='5';
       Lbl5.Caption:='4';
       Lbl6.Caption:='3';
       Lbl7.Caption:='2';
       Lbl8.Caption:='1';
       LblH.Caption:='A';
       LblG.Caption:='B';
       LblF.Caption:='C';
       LblE.Caption:='D';
       LblD.Caption:='E';
       LblC.Caption:='F';
       LblB.Caption:='G';
       LblA.Caption:='H';
    End;
    If Move=-PlayerColor Then DoMoveBtnOnClick(Sender);
End;

Procedure TChessForm.StopButtonOnClick (Sender: TObject);
Begin
  ChessCalculator.Stop:=True;
End;

Procedure TChessForm.OptionsItemOnClick (Sender: TObject);
Begin
  ChessCalculator.Stop:=True;
  OptionsForm.ShowModal;
End;

Procedure TChessForm.DoMoveBtnOnClick (Sender: TObject);
Begin
   If not ChessCalculator.Stop Then exit; //Computer is thinking
   If Move=PlayerColor Then ComputerMove;
   ComputerMove;
End;

Procedure TChessForm.HintItemOnClick (Sender: TObject);
Var Mov:TMove;
    FromCol,FromRow,ToCol,ToRow:LongInt;
    s:String;
Begin
   If not ChessCalculator.Stop Then exit; //Computer is thinking
   If Move=PLAYER_WHITE
     Then StatusBar.SimpleText:='White is thinking...'
     Else StatusBar.SimpleText:='Black is thinking...';
   Mov:=ChessCalculator.Start(Move);

   FromCol:=(Mov.FromField Mod 10)-1;
   FromRow:=9-(Mov.FromField Div 10);
   ToCol:=(Mov.ToField Mod 10)-1;
   ToRow:=9-(Mov.ToField Div 10);

   s:=chr(ord('A')+FromCol)+chr(ord('1')+7-FromRow)+'-'+
          chr(ord('A')+ToCol)+chr(ord('1')+7-ToRow);

   If Mov.RochadeArt=SHORTROCHADE Then s:='0-0'
   Else If Mov.RochadeArt=LONGROCHADE Then s:='0-0-0';

   StatusBar.SimpleText:='Hint: '+s;
End;

Procedure TChessForm.TakeBackItemOnClick (Sender: TObject);
Var Mov:PMove;
    s:String;
Begin
  If not ChessCalculator.Stop Then exit; //Computer is thinking
  If Moves.Count=0 Then exit;
  Mov:=PMove(Moves[Moves.Count-1]);
  ChessCalculator.TakeBackMove(Mov^,Move);
  MakeMove(Mov^);
  Dispose(Mov);
  Moves.Delete(Moves.Count-1);
  If Move=PLAYER_BLACK Then
    ListBox1.Items.Delete(ListBox1.Items.Count-1)
  Else
    Begin
      s:=ListBox1.Items[ListBox1.Items.Count-1];
      While ((s<>'')And(s[length(s)]<>#32)) Do
        dec(s[0]);
      While s[length(s)]=#32 do
        dec(s[0]);
      ListBox1.Items[ListBox1.Items.Count-1]:=s;
   End;
  Move:=-Move;
  InBack:=not InBack;
End;

Procedure TChessForm.NewItemOnClick (Sender: TObject);
Var t:LongInt;
    Mov:PMove;
Begin
   ChessCalculator.Stop:=True;
   For t:=0 To Moves.Count-1 Do
   Begin
       Mov:=Moves[t];
       Dispose(Mov);
   End;
   Moves.Clear;
   ChessCalculator.Destroy;
   ChessCalculator.Create(Nil);
   Move:=PLAYER_WHITE;
   MoveFrom:=0;
   ListBox1.Clear;
   DrawGrid.Invalidate;
   StatusBar.SimpleText:='';
   If BoardFlipped Then
     Begin
       PlayerColor:=PLAYER_BLACK;
       ComputerMove;
     End
   Else PlayerColor:=PLAYER_WHITE;
End;

Procedure TChessForm.DrawGrid1OnSelectCell (Sender: TObject; Col: LongInt;
                                        Row: LongInt);
Var i:LongInt;
    Figure:LongInt;
    Mov:TMove;
Begin
    If Move<>PlayerColor Then If not InBack Then exit;

    If BoardFlipped Then i:=(2+Row)*10+8-Col
    Else i:=(9-Row)*10+Col+1;
    Figure:=ChessCalculator.FigureAt(i);

    If MoveFrom<>0 Then
    Begin
        If ChessCalculator.IsLegalMove(MoveFrom,i,Move) Then
        Begin
             FillChar(Mov,sizeof(Mov),0);
             Mov.FromField:=MoveFrom;
             Mov.ToField:=i;

             If Abs(ChessCalculator.FigureAt(MoveFrom))=White_King Then
             Begin
                 If Mov.FromField=E1 Then If Move=PLAYER_WHITE Then
                 Begin
                    If Mov.ToField=g1 Then Mov.RochadeArt:=SHORTROCHADE
                    Else If Mov.ToField=c1 Then Mov.RochadeArt:=LONGROCHADE;
                 End;

                 If Mov.FromField=E8 Then If Move=PLAYER_BLACK Then
                 Begin
                    If Mov.ToField=g8 Then Mov.RochadeArt:=SHORTROCHADE
                    Else If Mov.ToField=c8 Then Mov.RochadeArt:=LONGROCHADE;
                 End;
             End;

             DoMoveFigure(Mov);
             Move:=-Move;
             If not InBack Then ComputerMove
             Else InBack:=False;
        End
        Else
        Begin
           Beep(400,250);
           StatusBar.SimpleText:='Illegal Move !';
        End;

        If BoardFlipped Then
        Begin
            Col:=8-(MoveFrom Mod 10);
            Row:=(MoveFrom Div 10)-2;
        End
        Else
        Begin
            Col:=(MoveFrom Mod 10)-1;
            Row:=9-(MoveFrom Div 10);
        End;
        MoveFrom:=0;
        DrawGrid.InvalidateRect(DrawGrid.GridRects[Col,Row]);
    End
    Else
    Begin
         If Figure=Empty Then exit;
         If Move=PLAYER_WHITE Then If Figure<0 Then exit;
         If Move=PLAYER_BLACK Then If Figure>0 Then exit;
         MoveFrom:=i;
         DrawGrid.InvalidateRect(DrawGrid.GridRects[Col,Row]);
    End;
End;

Procedure TChessForm.Form1OnCreate (Sender: TObject);
Begin
  Move:=PLAYER_WHITE;
  PlayerColor:=PLAYER_WHITE;
  Moves.Create;
End;

Function TChessForm.MakeMove(Mov:TMove):String;
Var
   FromCol,FromRow,ToCol,ToRow:LongInt;
Begin
    If BoardFlipped Then
    Begin
        FromCol:=8-(Mov.FromField Mod 10);
        FromRow:=(Mov.FromField Div 10)-2;
        ToCol:=8-(Mov.ToField Mod 10);
        ToRow:=(Mov.ToField Div 10)-2;
    End
    Else
    Begin
        FromCol:=(Mov.FromField Mod 10)-1;
        FromRow:=9-(Mov.FromField Div 10);
        ToCol:=(Mov.ToField Mod 10)-1;
        ToRow:=9-(Mov.ToField Div 10);
    End;

    result:=chr(ord('A')+FromCol)+chr(ord('1')+7-FromRow)+'-'+
            chr(ord('A')+ToCol)+chr(ord('1')+7-ToRow);

    DrawGrid.InvalidateRect(DrawGrid.GridRects[FromCol,FromRow]);
    DrawGrid.InvalidateRect(DrawGrid.GridRects[ToCol,ToRow]);

    If ChessCalculator.InCheck Then result:=result+'+';

    If Mov.RochadeArt=SHORTROCHADE Then
    Begin
         result:='0-0';
         If Move=PLAYER_WHITE Then
         Begin
             If BoardFlipped Then
             Begin
                DrawGrid.InvalidateRect(DrawGrid.GridRects[0,0]);
                DrawGrid.InvalidateRect(DrawGrid.GridRects[2,0]);
             End
             Else
             Begin
                DrawGrid.InvalidateRect(DrawGrid.GridRects[7,7]);
                DrawGrid.InvalidateRect(DrawGrid.GridRects[5,7]);
             End;
         End
         Else
         Begin
             If BoardFlipped Then
             Begin
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[0,7]);
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[2,7]);
             End
             Else
             Begin
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[7,0]);
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[5,0]);
             End;
         End;
    End
    Else If Mov.RochadeArt=LONGROCHADE Then
    Begin
         result:='0-0-0';
         If Move=PLAYER_WHITE Then
         Begin
             If BoardFlipped Then
             Begin
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[7,0]);
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[4,0]);
             End
             Else
             Begin
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[0,7]);
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[3,7]);
             End;
         End
         Else
         Begin
             If BoardFlipped Then
             Begin
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[7,7]);
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[4,7]);
             End
             Else
             Begin
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[0,0]);
                 DrawGrid.InvalidateRect(DrawGrid.GridRects[3,0]);
             End;
         End;
    End;
End;

Procedure TChessForm.DoMoveFigure(Mov:TMove);
Var
    s:String;
    s1:String;
    m:PMove;
    Value:LongInt;
Begin
    ChessCalculator.DoMove(Mov);
    Value:=ChessCalculator.Calculate_Board(-MATE,MATE,-Move);
    If Value=MATE Then ChessCalculator.Status:=checkmate;

    New(m);
    m^:=Mov;
    Moves.Add(m);

    s:=MakeMove(Mov);

    If Move=PLAYER_WHITE Then
    Begin
        s1:=tostr(ListBox1.Items.Count+1);
        While length(s1)<3 Do s1:=s1+' ';
        ListBox1.Items.Add(s1+')'+'  '+s);
    End
    Else ListBox1.Items[ListBox1.Items.Count-1]:=
          ListBox1.Items[ListBox1.Items.Count-1]+'     '+s;

    DrawGrid.Update;

    If ChessCalculator.Status=CheckMate Then
    Begin
        Beep(500,100);
        Beep(800,100);
        Beep(600,100);
        StatusBar.SimpleText:='Check mate !';
    End
    Else If ChessCalculator.InCheck Then
    Begin
        StatusBar.SimpleText:='Check !';
        Beep(800,100);
        Beep(600,100);
    End;
End;

Procedure TChessForm.ComputerMove;
Var Mov:TMove;
Begin
    If ChessCalculator.Status<>CheckMate Then
    Begin
       If Move=PLAYER_WHITE
         Then StatusBar.SimpleText:='White is thinking...'
         Else StatusBar.SimpleText:='Black is thinking...';
    End;
    Mov:=ChessCalculator.Start(Move);
    DoMoveFigure(Mov);
    If ChessCalculator.Status<>CheckMate Then
      If not ChessCalculator.InCheck Then
        StatusBar.SimpleText:='It'#39's your turn !';
    Move:=-Move;
End;

Procedure TChessForm.DrawGrid1OnDrawCell (Sender: TObject; ACol: LongInt;
                                      ARow: LongInt; rc: TRect;
                                      State: TGridDrawState);
Var Index:LongInt;
    Figure,FigureIndex,MaskIndex:integer;
    Back,Mask,Bitmap:TBitmap;
    Source,Dest:TRect;
Begin
   If ((ARow+ACol) And 1)<>0 Then Index:=18
   Else Index:=19;

   If BoardFlipped Then Figure:=ChessCalculator.FigureAt((2+ARow)*10+8-ACol)
   Else Figure:=ChessCalculator.FigureAt((9-ARow)*10+ACol+1);
   If ((Figure<>0)And(Figure<=6)And(Figure>=-6)) Then
   Begin
       Back.Create;
       ImageList1.GetBitmap(Index,Back);

       Mask.Create;
       Bitmap.Create;

       FigureIndex:=MapFigure[abs(Figure)];
       If Figure>0 Then inc(FigureIndex,6);
       MaskIndex:=12+MapFigure[abs(Figure)];

       ImageList1.GetBitmap(MaskIndex,Mask);
       ImageList1.GetBitmap(FigureIndex,Bitmap);

       Source.Left:=0;
       Source.Right:=Mask.Width;
       Source.Bottom:=0;
       Source.Top:=Mask.Height;

       Dest.Left:=4;
       If abs(Figure)=White_Pawn Then inc(Dest.Left,3);
       Dest.Right:=Dest.Left+24;
       If abs(Figure)=White_Pawn Then dec(Dest.Right,3);
       Dest.Bottom:=18; // 4
       Dest.Top:=Dest.Bottom+28; //24
       If abs(Figure)=White_Pawn Then dec(Dest.Top,5);

       Mask.Canvas.BitBlt(Back.Canvas,Dest,Source,cmSrcAnd,bitfIgnore);
       Bitmap.Canvas.BitBlt(Back.Canvas,Dest,Source,cmSrcPaint,bitfIgnore);

       Back.Canvas.BitBlt(DrawGrid.Canvas,rc,Source,cmSrcCopy,bitfIgnore);

       Mask.Destroy;
       Bitmap.Destroy;
       Back.Destroy;

       If BoardFlipped Then Index:=(2+ARow)*10+8-ACol
       Else Index:=(9-ARow)*10+ACol+1;

       If MoveFrom=Index Then
       Begin
           InflateRect(rc,-3,-3);
           DrawGrid.Canvas.Pen.Width:=3;
           DrawGrid.Canvas.Pen.Color:=clRed;
           DrawGrid.Canvas.Rectangle(rc);
           DrawGrid.Canvas.Pen.Width:=1;
       End;
   End
   Else ImageList1.Draw(DrawGrid.Canvas,rc.Left,rc.Bottom,Index);
End;

Initialization
  RegisterClasses ([TChessForm, TDrawGrid, TImageList, TStatusBar
   , TPanel, TLabel, TMainMenu, TMenuItem, TListBox, TButton]);
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  24-Feb-09  WD         Die Konstante "WHITE" bzw. "BLACK" auf "PLAYER_WHITE"
                        bzw. "PLAYER_BLACK" geaendert.
}

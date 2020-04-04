Unit ChessU1;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, Grids, Chess, Buttons, ComCtrls,
  ExtCtrls,  ChessOpt, uList, Color, Menus;

Type
  TChessForm = Class (TForm)
    DrawGrid1: TDrawGrid;
    ImageList1: TImageList;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MainMenu1: TMainMenu;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    ChangeColorsItem: TMenuItem;
    StopButton: TButton;
    NewItem: TMenuItem;
    TakeBackItem: TMenuItem;
    HintItem: TMenuItem;
    OptionsItem: TMenuItem;
    MenuItem8: TMenuItem;
    ExitItem: TMenuItem;
    ListBox1: TListBox;
    Label17: TLabel;
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
    DrawGrid1.Invalidate;
    If BoardFlipped Then
    Begin
       Label1.Caption:='1';
       Label2.Caption:='2';
       Label3.Caption:='3';
       Label4.Caption:='4';
       Label5.Caption:='5';
       Label6.Caption:='6';
       Label7.Caption:='7';
       Label8.Caption:='8';
       Label9.Caption:='H';
       Label10.Caption:='G';
       Label11.Caption:='F';
       Label12.Caption:='E';
       Label13.Caption:='D';
       Label14.Caption:='C';
       Label15.Caption:='B';
       Label16.Caption:='A';
    End
    Else
    Begin
       Label1.Caption:='8';
       Label2.Caption:='7';
       Label3.Caption:='6';
       Label4.Caption:='5';
       Label5.Caption:='4';
       Label6.Caption:='3';
       Label7.Caption:='2';
       Label8.Caption:='1';
       Label9.Caption:='A';
       Label10.Caption:='B';
       Label11.Caption:='C';
       Label12.Caption:='D';
       Label13.Caption:='E';
       Label14.Caption:='F';
       Label15.Caption:='G';
       Label16.Caption:='H';
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
   If Move=WHITE Then StatusBar1.SimpleText:='White is thinking...'
   Else StatusBar1.SimpleText:='Black is thinking...';
   Mov:=ChessCalculator.Start(Move);

   FromCol:=(Mov.FromField Mod 10)-1;
   FromRow:=9-(Mov.FromField Div 10);
   ToCol:=(Mov.ToField Mod 10)-1;
   ToRow:=9-(Mov.ToField Div 10);

   s:=chr(ord('A')+FromCol)+chr(ord('1')+7-FromRow)+'-'+
          chr(ord('A')+ToCol)+chr(ord('1')+7-ToRow);

   If Mov.RochadeArt=SHORTROCHADE Then s:='0-0'
   Else If Mov.RochadeArt=LONGROCHADE Then s:='0-0-0';

   StatusBar1.SimpleText:='Hint: '+s;
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
    If Move=BLACK Then ListBox1.Items.Delete(ListBox1.Items.Count-1)
    Else
    Begin
         s:=ListBox1.Items[ListBox1.Items.Count-1];
         While ((s<>'')And(s[length(s)]<>#32)) Do dec(s[0]);
         While s[length(s)]=#32 do dec(s[0]);
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
   Move:=WHITE;
   MoveFrom:=0;
   ListBox1.Clear;
   DrawGrid1.Invalidate;
   StatusBar1.SimpleText:='';
   If BoardFlipped Then
   Begin
       PlayerColor:=Black;
       ComputerMove;
   End
   Else PlayerColor:=White;
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
                 If Mov.FromField=E1 Then If Move=WHITE Then
                 Begin
                    If Mov.ToField=g1 Then Mov.RochadeArt:=SHORTROCHADE
                    Else If Mov.ToField=c1 Then Mov.RochadeArt:=LONGROCHADE;
                 End;

                 If Mov.FromField=E8 Then If Move=BLACK Then
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
           StatusBar1.SimpleText:='Illegal Move !';
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
        DrawGrid1.InvalidateRect(DrawGrid1.GridRects[Col,Row]);
    End
    Else
    Begin
         If Figure=Empty Then exit;
         If Move=WHITE Then If Figure<0 Then exit;
         If Move=BLACK Then If Figure>0 Then exit;
         MoveFrom:=i;
         DrawGrid1.InvalidateRect(DrawGrid1.GridRects[Col,Row]);
    End;
End;

Procedure TChessForm.Form1OnCreate (Sender: TObject);
Begin
  Move:=WHITE;
  PlayerColor:=WHITE;
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

    DrawGrid1.InvalidateRect(DrawGrid1.GridRects[FromCol,FromRow]);
    DrawGrid1.InvalidateRect(DrawGrid1.GridRects[ToCol,ToRow]);

    If ChessCalculator.InCheck Then result:=result+'+';

    If Mov.RochadeArt=SHORTROCHADE Then
    Begin
         result:='0-0';
         If Move=WHITE Then
         Begin
             If BoardFlipped Then
             Begin
                DrawGrid1.InvalidateRect(DrawGrid1.GridRects[0,0]);
                DrawGrid1.InvalidateRect(DrawGrid1.GridRects[2,0]);
             End
             Else
             Begin
                DrawGrid1.InvalidateRect(DrawGrid1.GridRects[7,7]);
                DrawGrid1.InvalidateRect(DrawGrid1.GridRects[5,7]);
             End;
         End
         Else
         Begin
             If BoardFlipped Then
             Begin
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[0,7]);
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[2,7]);
             End
             Else
             Begin
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[7,0]);
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[5,0]);
             End;
         End;
    End
    Else If Mov.RochadeArt=LONGROCHADE Then
    Begin
         result:='0-0-0';
         If Move=WHITE Then
         Begin
             If BoardFlipped Then
             Begin
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[7,0]);
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[4,0]);
             End
             Else
             Begin
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[0,7]);
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[3,7]);
             End;
         End
         Else
         Begin
             If BoardFlipped Then
             Begin
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[7,7]);
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[4,7]);
             End
             Else
             Begin
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[0,0]);
                 DrawGrid1.InvalidateRect(DrawGrid1.GridRects[3,0]);
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

    If Move=WHITE Then
    Begin
        s1:=tostr(ListBox1.Items.Count+1);
        While length(s1)<3 Do s1:=s1+' ';
        ListBox1.Items.Add(s1+')'+'  '+s);
    End
    Else ListBox1.Items[ListBox1.Items.Count-1]:=
          ListBox1.Items[ListBox1.Items.Count-1]+'     '+s;

    DrawGrid1.Update;

    If ChessCalculator.Status=CheckMate Then
    Begin
        Beep(500,100);
        Beep(800,100);
        Beep(600,100);
        StatusBar1.SimpleText:='Check mate !';
    End
    Else If ChessCalculator.InCheck Then
    Begin
        StatusBar1.SimpleText:='Check !';
        Beep(800,100);
        Beep(600,100);
    End;
End;

Procedure TChessForm.ComputerMove;
Var Mov:TMove;
Begin
    If ChessCalculator.Status<>CheckMate Then
    Begin
       If Move=WHITE Then StatusBar1.SimpleText:='White is thinking...'
       Else StatusBar1.SimpleText:='Black is thinking...';
    End;
    Mov:=ChessCalculator.Start(Move);
    DoMoveFigure(Mov);
    If ChessCalculator.Status<>CheckMate Then
     If not ChessCalculator.InCheck Then StatusBar1.SimpleText:='It'#39's your turn !';
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

       Back.Canvas.BitBlt(DrawGrid1.Canvas,rc,Source,cmSrcCopy,bitfIgnore);

       Mask.Destroy;
       Bitmap.Destroy;
       Back.Destroy;

       If BoardFlipped Then Index:=(2+ARow)*10+8-ACol
       Else Index:=(9-ARow)*10+ACol+1;

       If MoveFrom=Index Then
       Begin
           InflateRect(rc,-3,-3);
           DrawGrid1.Canvas.Pen.Width:=3;
           DrawGrid1.Canvas.Pen.Color:=clRed;
           DrawGrid1.Canvas.Rectangle(rc);
           DrawGrid1.Canvas.Pen.Width:=1;
       End;
   End
   Else ImageList1.Draw(DrawGrid1.Canvas,rc.Left,rc.Bottom,Index);
End;

Initialization
  RegisterClasses ([TChessForm, TDrawGrid, TImageList, TStatusBar
   , TPanel, TLabel, TMainMenu, TMenuItem, TListBox, TButton]);
End.

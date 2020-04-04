unit Chess;

//Portions Copyright (C) Uwe Auerswald@T-Online.de

interface

uses
  SysUtils, Classes, Forms;

Const
  INVALIDVALUE = 1000;

  NOROCHADE = 0;
  SHORTROCHADE = 1;
  LONGROCHADE = 2;

  CalcDepth:LongInt=3;

  CheckMate = 1;
  Patt = 2;
  Illegal_Move = 3;
  Error = 6;

  a1=21;b1=22;c1=23;d1=24;e1=25;f1=26;g1=27;h1=28;
  a2=31;b2=32;c2=33;d2=34;e2=35;f2=36;g2=37;h2=38;
  a3=41;b3=42;c3=43;d3=44;e3=45;f3=46;g3=47;h3=48;
  a4=51;b4=52;c4=53;d4=54;e4=55;f4=56;g4=57;h4=58;
  a5=61;b5=62;c5=63;d5=64;e5=65;f5=66;g5=67;h5=68;
  a6=71;b6=72;c6=73;d6=74;e6=75;f6=76;g6=77;h6=78;
  a7=81;b7=82;c7=83;d7=84;e7=85;f7=86;g7=87;h7=88;
  a8=91;b8=92;c8=93;d8=94;e8=95;f8=96;g8=97;h8=98;

  PLAYER_WHITE  =  1;
  PLAYER_BLACK  = -1;

  MAX_DEPTH =       50;
  MOVESTACKDIM =     5000;

  Black_King   = -6;
  Black_Queen  = -5;
  Black_Knight = -4;
  Black_Bishop = -3;
  Black_Rook   = -2;
  Black_Pawn   = -1;
  Empty        =  0;
  White_Pawn   =  1;
  White_Rook   =  2;
  White_Bishop =  3;
  White_Knight =  4;
  White_Queen  =  5;
  White_King   =  6;
  Edge         = 100;

Type
     PChessBoard=^TChessBoard;
     TChessBoard=Array[0..119] Of LongInt;

     TRochademoeglichkeiten = set of byte;

     PMove = ^TMove;
     TMove = Record
                ZugNummer : word;
                Rochademoeglichkeiten : TRochademoeglichkeiten;
                epField, CurrentPlayer, FromField, ToField, epSchlag, RochadeArt:ShortInt;
                ToFigure, Figuretaken, attr1 : ShortInt;
            End;

     TMoveFromTo = Record
          FromField : LongInt;
          ToField : LongInt;
          Figure_taken : LongInt;
          To_Figure : LongInt;
          rochade_nr : LongInt;
          Ep_Field : LongInt;
          Value : LongInt;
     end;

     TFromTo = Record
          FromField : LongInt;
          ToField : LongInt;
     End;

     TKiller = Record
          killer1 : TFromTo;
          killer2 : TFromTo;
     End;

     PMoveStack = ^TMoveStack;
     TMoveStack = array[0..MOVESTACKDIM] of TMoveFromTo;

Const
  A_LINE =  1;
  B_LINE =  2;
  C_LINE =  3;
  D_LINE =  4;
  E_LINE =  5;
  F_LINE =  6;
  G_LINE =  7;
  H_LINE =  8;
  ROW_1 =  2;
  ROW_2 =  3;
  ROW_3 =  4;
  ROW_4 =  5;
  ROW_5 =  6;
  ROW_6 =  7;
  ROW_7 =  8;
  ROW_8 =  9;

  MATE = 32000;

  WsR = 1;
  wlr = 2;
  BsR = 3;
  BlR = 4;


Type
  TChessCalculator = Class(TComponent)
    Private
          SaveDepth:LongInt;
          FStatus:Byte;
          CurrentMove:TMove;
          Board,SaveBoard:TChessBoard;
          Ep_Field:Array[0..MAX_DEPTH-1] Of LongInt;
          MoveStack:PMoveStack;
          Moved:Array[0..H8+1-1] Of LongInt;
          Rochade:Array[0..3-1] Of Boolean;
          Index:LongInt;
          RPossible:TRochademoeglichkeiten;
          StackValue:Array[0..MAX_DEPTH-1] Of LongInt;
          HVar:Array[0..MAX_DEPTH-1,0..MAX_DEPTH-1] Of TFromTo;
          KillerTab:Array[0..MAX_DEPTH-1] of TKiller;
          PControl:Array[0..119,PLAYER_BLACK..PLAYER_WHITE] Of LongInt;
          Pawns:Array[0..H_LINE+2-1,PLAYER_BLACK..PLAYER_WHITE] Of LongInt;
          Rooks:Array[0..H_LINE+2-1,PLAYER_BLACK..PLAYER_WHITE] Of LongInt;
          Mobile:Array[0..MAX_DEPTH-1] Of LongInt;
          TargetField:Array[0..MAX_DEPTH-1] Of LongInt;
          Kings:Array[PLAYER_BLACK..PLAYER_WHITE] Of LongInt;
          MatBalance:Array[0..MAX_DEPTH-1] Of LongInt;
          MatSum:Array[0..MAX_DEPTH-1] Of LongInt;
          Color:LongInt;
          TargetDepth:LongInt;
          MaxExtension:LongInt;
          Depth:LongInt;
          NodeCount:longInt;
          LastMove:LongInt;
          FInCheck:Boolean;
          ZugNr:LongInt;
    Private
          Procedure Generate_Moves(allezuege : LongInt);
          Procedure InitializeTree;
          Function  Enter_Move(FromField,ToField, ToFigure : LongInt) : Boolean;
          Procedure ExecuteMove(aktzug : LongInt);
          Procedure MoveBack(aktzug : LongInt);
          Procedure InitCalc ;
          Procedure Copy_hvar(aktzug : LongInt);
          Function  NextMove:LongInt;
          Function  alpha_beta(alpha, beta, Distance : LongInt)  : LongInt;
          Function  Calc_Pawns(Color,feld, reihe,  linie, developed : LongInt) : LongInt;
          Function  AttacksField(feld,  seite : LongInt ) : Boolean;
          Procedure Notate_Move( FromField,ToField:LongInt;Nest:Boolean);
          Procedure Notate_epMove( FromField,ToField, epField : LongInt);
          Procedure Enter_Board;
          Procedure PStop;
    Public
          Stop : Boolean;
          Constructor Create(AOwner : TComponent);Override;
          Procedure Computer_Move ;
          Procedure TakeBackMove(Move:TMove;Color:LongInt);
          Function  Start(mcolor:LongInt):TMove;
          Function  IsLegalMove(FromField,ToField,Color:LongInt) : Boolean;
          Function  FigureAt(pos:LongInt):LongInt;
          Procedure DoMove(Var Move:TMove);
          Function  Calculate_Board(alpha, beta, seite : LongInt) : LongInt;
          Property  Status:Byte read FStatus write FStatus;
          Property  InCheck:Boolean read FInCheck write FInCheck;
  End;

Var
   ChessCalculator : TChessCalculator;

Implementation

Const
  MAT_B =  100;
  MAT_T =  500;
  MAT_L =  350;
  MAT_S =  325;
  MAT_D =  900;
  MAT_K =   0;

  HVARBONUS =      500;
  KILLER1BONUS =   250;
  KILLER2BONUS =   150;

  MAX_POS  =  MAT_L;

  MAT_GESAMT = ((4*(MAT_T+MAT_L+MAT_S))+(2*MAT_D));
  ENDSPIELMATERIAL =(4*MAT_T+(2*MAT_L));

  LEGAL         = 1;
  ILLEGAL       = 0;
  OK            = 1;

Const
  DefaultBoard : TChessBoard =  (
                 Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,
                 Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,
                 White_Rook, White_Knight ,White_Bishop ,White_Queen ,
                 White_King ,White_Bishop ,White_Knight ,White_Rook, Edge,
                 Edge,White_Pawn, White_Pawn ,White_Pawn ,White_Pawn ,
                 White_Pawn ,White_Pawn ,White_Pawn ,White_Pawn, Edge,
                 Edge,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Edge,
                 Edge,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Edge,
                 Edge,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Edge,
                 Edge,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Edge,
                 Edge,Black_Pawn ,Black_Pawn ,Black_Pawn ,Black_Pawn ,
                 Black_Pawn ,Black_Pawn ,Black_Pawn ,Black_Pawn, Edge,
                 Edge,Black_Rook, Black_Knight ,Black_Bishop ,Black_Queen ,
                 Black_King ,Black_Bishop ,Black_Knight ,Black_Rook, Edge,
                 Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,
                 Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge,Edge);

const Offset : array[0..15] of LongInt = (
      -9,-11,9,11,
      -1,10,1,-10,
      19,21,12,-8,-19,-21,-12,8);

Type
    TFigOffset = Record
          FStart : LongInt;
          FEnd : LongInt;
          longmove : Boolean;
     end;

Const
      FigOffset : array[0..6] of TFigOffset= (
                (FStart:0;FEnd:0;longmove:FALSE),
                (FStart:-1;FEnd:-1;longmove:FALSE),
                (FStart:4;FEnd:7;longmove:TRUE),
                (FStart:0;FEnd:3;longmove:TRUE),
                (FStart:8;FEnd:15;longmove:FALSE),
                (FStart:0;FEnd:7;longmove:TRUE),
                (FStart:0;FEnd:7;longmove:FALSE));

const CenterTable : array[0..H8+1-1] of LongInt = (
                0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                0,  4,  0,  8, 12, 12,  8,  0,  4,  0,
                0,  4,  8, 12, 16, 16, 12,  8,  4,  0,
                0,  8, 12, 16, 20, 20, 16, 12,  8,  0,
                0, 12, 16, 20, 24, 24, 20, 16, 12,  0,
                0, 12, 16, 20, 24, 24, 20, 16, 12,  0,
                0,  8, 12, 16, 20, 20, 16, 12,  8,  0,
                0,  4,  8, 12, 16, 16, 12,  8,  4,  0,
                0,  4,  0,  8, 12, 12,  8,  0,  4);

const wBFeldWert : array[0..H7+1-1] of LongInt= (
                0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                0,  4,  4,  0,  0,  0,  6,  6,  6,  0,
                0,  6,  6,  8,  8,  8,  4,  6,  6,  0,
                0,  8,  8, 16, 22, 22,  4,  4,  4,  0,
                0, 10, 10, 20, 26, 26, 10, 10, 10,  0,
                0, 12, 12, 22, 28, 28, 14, 14, 14,  0,
                0, 18, 18, 28, 32, 32, 20, 20, 20);

const sBFeldWert : array[0..H7+1-1] of LongInt= (
                0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                0, 18, 18, 28, 32, 32, 20, 20, 20,  0,
                0, 12, 12, 22, 28, 28, 14, 14, 14,  0,
                0, 10, 10, 20, 26, 26, 10, 10, 10,  0,
                0,  8,  8, 16, 22, 22,  4,  4,  4,  0,
                0,  6,  6,  8,  8,  8,  4,  6,  6,  0,
                0,  4,  4,  0,  0,  0,  6,  6,  6);

Const FigMaterial : array[0..6] of LongInt=
               (0,MAT_B,MAT_T,MAT_L,MAT_S,MAT_D,MAT_K);

const FigSymbol : array[0..6] of Char =
               ( '.','B','T','L','S','D','K' );

const vokabeln : array[0..3] of string[10] =
               ('Depth','Depth','Value','Value');

Function TChessCalculator.alpha_beta(alpha, beta, Distance : LongInt)  : LongInt;
Var
   i,Value,besterwert:LongInt;
   Check : boolean;
Begin
   NodeCount:=NodeCount+1;
   HVar[Depth][Depth].FromField:=0;

   Value:=Calculate_Board(alpha,beta,Color);

   Check:=InCheck;
   If ((Check)AND(Depth+Distance<MaxExtension+1)) Then Distance:=Distance+1
   Else If((Depth>=2)And(Depth+Distance<MaxExtension)And
           (TargetField[Depth]=TargetField[Depth-1])And
           (Value>=alpha-150)And(Value<=beta+150)) Then Distance:=Distance+1;

   Application.ProcessMessages;

   If ((Stop)Or(((Distance<-5)Or(Value=MATE-Depth)Or(Depth>=MAX_DEPTH)))Or
       (((Value>=beta)And(Distance+ord(Check)<=1)))) Then
   Begin
     result:=Value;
     exit;
   End;

   Generate_Moves(Distance); { Abfrage, ob ueberhaupt Zuege vorhanden }
   If(Distance>0) Then besterwert := -MATE
   Else besterwert := Value;

   i:=NextMove;
   While i>=0 Do
   Begin
      ExecuteMove(i);
      Value:=-alpha_beta(-beta,-alpha,Distance-1);
      MoveBack(i);

      If Value>besterwert Then besterwert:=Value;

      If Value>=beta Then
      Begin
           if(Distance>0) then Copy_hvar(i);
           break;
      End;

      If Value>alpha Then
      Begin
           If(Distance>0) Then Copy_hvar(i);
           alpha:=Value;
      End;
      i:=NextMove;
   End;

   If ((Value>=beta)And(i>=0)) Then
   Begin
      KillerTab[Depth].killer2:=KillerTab[Depth].killer1;
      KillerTab[Depth].killer1.FromField:=MoveStack^[i].FromField;
      KillerTab[Depth].killer1.ToField:=MoveStack^[i].ToField;
   End;

   If besterwert=-(MATE-(Depth+1)) Then If not Check Then
   Begin
        result:= 0;
        exit;
   End;
   result:= besterwert;
End;

Procedure TChessCalculator.ExecuteMove(aktzug : LongInt);
Var
   FromField,ToField,epField,matveraenderung : LongInt;
Begin
   ZugNr:=ZugNr+1;
   FromField:=MoveStack^[aktzug].FromField;
   ToField:=MoveStack^[aktzug].ToField;
   epField:=MoveStack^[aktzug].Ep_Field;
   LastMove:=aktzug;
   Depth:=Depth+1;
   TargetField[Depth]:=ToField;

   Ep_Field[Depth]:=ILLEGAL;

   MatBalance[Depth]:= -MatBalance[Depth-1];
   MatSum[Depth]:=MatSum[Depth-1];

   Moved[FromField]:=Moved[FromField]+1;
   Moved[ToField]:=Moved[ToField]+1;
   If epField<>ILLEGAL Then
   Begin
      If(Board[epField]=Empty) Then Ep_Field[Depth]:=epField
      else
      Begin
         Board[epField]:=Empty;
         MatBalance[Depth]:= MatBalance[Depth] - MAT_B;
      End;
   End
   Else
   Begin
      if(MoveStack^[aktzug].Figure_taken<>Empty) Then
      Begin
         matveraenderung:= FigMaterial[MoveStack^[aktzug].Figure_taken];
         MatBalance[Depth]:= MatBalance[Depth] - matveraenderung;

         if(matveraenderung<>MAT_B) Then
            MatSum[Depth] := MatSum[Depth] - matveraenderung;
      End;
   End;

   Board[ToField]:=Board[FromField];
   Board[FromField]:=Empty;
   If(MoveStack^[aktzug].To_Figure<>Empty) Then
   Begin
      Board[ToField]:=Color*MoveStack^[aktzug].To_Figure;
      matveraenderung:= (FigMaterial[MoveStack^[aktzug].To_Figure]-MAT_B);
      MatBalance[Depth]:=MatBalance[Depth] - matveraenderung;
      MatSum[Depth] :=MatSum[Depth] + matveraenderung + MAT_B;
   End
   Else
   Begin
      If(MoveStack^[aktzug].rochade_nr=SHORTROCHADE) Then
      Begin
         Board[ToField+1]:=Empty;
         Board[ToField-1]:=Color*White_Rook;
         Rochade[Color+1]:=TRUE;
      End
      Else If MoveStack^[aktzug].rochade_nr=LONGROCHADE Then
      Begin
         Board[ToField-2]:=Empty;
         Board[ToField+1]:=Color*White_Rook;
         Rochade[Color+1]:=TRUE;
      End;
   End;

   If Board[ToField]=White_King
     Then Kings[PLAYER_WHITE]:=ToField
     Else If Board[ToField]=Black_King Then Kings[PLAYER_BLACK]:=ToField;

   Color := -Color;
End;

Function TChessCalculator.Calc_Pawns(Color,feld, reihe,  linie, developed : LongInt) : LongInt;
Var
   i,j : LongInt;
Begin
   If Color=PLAYER_BLACK Then reihe := (ROW_8+ROW_1)-reihe;

   If MatSum[Depth]>ENDSPIELMATERIAL Then
   Begin
      If Color=PLAYER_BLACK
        Then result:=sBFeldWert[feld]
        Else result:=wBFeldWert[feld];
      If ((developed<4)And((linie>=F_LINE)Or(linie<=B_LINE))And
          (reihe>ROW_3)) Then result := result - 15;
   End
   Else result := reihe*4;

   If((Pawns[linie-1][Color]=0)And(Pawns[linie+1][Color]=0)) Then
   Begin
      result := result - 12;
      If Pawns[linie][Color]>1 Then result := result - 12;
   End;

   If Pawns[linie][Color]>1 Then result := result - 15;

   If Color=PLAYER_BLACK
     THEN i:=-10
     Else i:=10;

   If ((PControl[feld][Color]>0)Or(PControl[feld+i][Color]>0)) Then result := result + reihe ;

   If(Pawns[linie][-Color]=0) Then
   Begin
      If ((PControl[feld][Color]=0)And(PControl[feld+i][-Color]>PControl[feld+i][Color])) Then
      Begin
         result := result - 10;
         If Rooks[linie][-Color]>0 Then result:=result -8;
      End
      Else
      Begin
         j:=feld;
         While j>H2 Do
         Begin
            If PControl[j][-Color]>0 Then exit;
            dec(j,10);
         End;

         If MatSum[Depth]<ENDSPIELMATERIAL Then result := result + reihe*16
         Else result:=result+ reihe*8;

         If MatSum[Depth]<ENDSPIELMATERIAL Then
         Begin
             If Rooks[linie][Color]>0 Then result :=  result + reihe*2;
             If Rooks[linie][-Color]>0 Then result := result - reihe*2;

             If MatSum[Depth]=0 Then result := result + reihe*8;
             If ((PControl[feld][Color]>0)Or
                 (PControl[feld+i][Color]>0)) Then result := result + reihe*4;
             If ((Board[feld+i]<0)And(PControl[feld+i][Color]=0)) Then result:=result - reihe*4;
         End
         Else If ((PControl[feld][Color]>0)Or
                  (PControl[feld+i][Color]>0)) Then result := result + reihe*2;
      End;
   End;
End;

Function Sgn(i:LongInt):LongInt;
Begin
    If i>0 Then Sgn:=1
    Else If i<0 Then Sgn:=-1
    Else Sgn:=0;
End;

Function TChessCalculator.AttacksField(feld,  seite : LongInt ) : Boolean;
Var
   i,Direction,ToField,Figure,glide : LongInt;
label glideagain, weiter;
Begin
   If ((Board[feld-9*Seite]=White_Pawn*Seite)Or
       (Board[feld-11*Seite]=White_Pawn*Seite)) Then
   Begin
       result:= TRUE;
       exit;
   End;

   i:=8;
   While i<16 Do
   Begin
      ToField:=feld+Offset[i];
      If ((Board[ToField]=Empty)Or(Board[ToField]=Edge)) Then goto weiter;

      If(Board[ToField]=White_Knight*Seite) Then
      Begin
          result:= TRUE;
          exit;
      End;
weiter:
      inc(i);
   End; //while

   For i:=0 To 7 Do
   Begin
      ToField:=feld;
      Direction:=Offset[i];
      glide:=0;
glideagain:
      inc(glide);
      inc(ToField,Direction);
      If Board[ToField]=Empty Then goto glideagain;
      If Board[ToField]=Edge Then continue;

      Figure:=Board[ToField];
      If Sgn(Figure)=Sgn(Seite) Then
      Begin
        If(Figure=White_King*Seite) Then
        Begin
             If glide<=1 Then
             Begin
                  result:=TRUE;
                  exit;
             End
        End
        Else
        Begin
             If ((FigOffset[abs(Figure)].FStart<=i)AND(FigOffset[abs(Figure)].FEnd>=i)) Then
             Begin
                  result:= TRUE;
                  exit;
             End;
        End;
      End;
   End;

   result:= FALSE;
End;


Function TChessCalculator.Calculate_Board( alpha, beta, seite : LongInt) : LongInt;
Var
   Value,PosValue,i,j,k,feld,WBishops,BBishops : LongInt;
   PawnCount : LongInt;
   matsum1,wron7,bron2 : LongInt;
   developed:Array[PLAYER_BLACK..PLAYER_WHITE] Of LongInt;
   col:LongInt;
Begin
   If AttacksField(Kings[-seite],seite) Then
   Begin
        result:= MATE-Depth;
        exit;
   End
   Else InCheck:=AttacksField(Kings[seite],-seite);

   Value:=MatBalance[Depth];
   matsum1:=MatSum[Depth];
   if(matsum1>(2*MAT_L)) Then
   Begin
      if((Value<alpha-MAX_POS)Or(Value>beta+MAX_POS)) Then
      Begin
         result:= Value;
         exit;
      End;
   End;

   InitCalc;
   PosValue:=0;

   BBishops:=0;
   WBishops:=0;

   PawnCount:=0;

   wron7:=0;
   bron2:=0;

   developed[PLAYER_WHITE]:=ord(Rochade[PLAYER_WHITE+1]);
   developed[PLAYER_BLACK]:=ord(Rochade[PLAYER_BLACK+1]);
   inc(developed[PLAYER_WHITE],ord(Moved[B1])+ord(Moved[C1])+ord(Moved[F1])+ord(Moved[G1]));
   inc(developed[PLAYER_BLACK],ord(Moved[B8])+ord(Moved[C8])+ord(Moved[F8])+ord(Moved[G8]));

   For i:=ROW_1 To ROW_8 Do
   Begin
      feld:=i*10+A_LINE;
      For j:=A_LINE To H_LINE Do
      Begin
         Case Board[feld] Of
          Black_King,White_King:
          Begin
            If Board[feld]=Black_King
              Then col:=PLAYER_BLACK
              Else Col:=PLAYER_WHITE;

            If matsum1<ENDSPIELMATERIAL Then
            Begin
                 PosValue:=PosValue+CenterTable[feld]*col;
                 If col=PLAYER_WHITE Then
                 Begin
                      if((abs(feld-Kings[PLAYER_BLACK])=20)Or(abs(feld-Kings[PLAYER_BLACK])=2)) Then
                      Begin
                           If matsum1=0 Then k:=30
                           Else k:=10;
                           dec(PosValue,k*Color);
                      End;
                 End;
            End
            Else
            Begin
               If col=PLAYER_BLACK Then
               Begin
                  If ((not Rochade[PLAYER_BLACK+1])AND
                      ((Moved[E8]>0)Or((Moved[H8]>0)And(Moved[A8]>0)))) Then
                    inc(PosValue,35);
               End
               Else
               Begin
                    If ((not Rochade[PLAYER_WHITE+1])And
                        ((Moved[E1]>0)OR((Moved[H1]>0)And(Moved[A1]>0)))) Then
                     dec(PosValue,35);
               End;

               PosValue:=PosValue-(4*CenterTable[feld])*col;
               For k:=-1 To 1 Do
               Begin
                    If Board[feld+(10*col)+k]=White_Pawn*col Then inc(PosValue,15*col);
                    If Board[feld+(20*col)+k]=White_Pawn*col Then inc(PosValue,6*col);
                    If ((Pawns[j+k][-col]=0)And(Rooks[j+k][-col]>0)) Then dec(PosValue,12*col);
               End;
            End;
          End;
          Black_Queen,White_Queen:
          Begin
            If Board[feld]=Black_Queen
              Then col:=PLAYER_BLACK
              Else Col:=PLAYER_WHITE;

            If developed[col]<4 Then
              Begin
                 If Col=PLAYER_BLACK Then If feld<A8 Then inc(PosValue,15);
                 If Col=PLAYER_WHITE Then If feld>H1 Then dec(PosValue,15);
              End
            Else
              PosValue:=PosValue- 2*(abs((Kings[-col] div 10)-(feld div 10)) +
                        abs((KINGS[-col] mod 10)-(feld mod 10)));
          End;
          Black_Knight:dec(PosValue,CenterTable[feld] div 2);
          White_Knight:inc(PosValue,CenterTable[feld] div 2);
          Black_Bishop:
          Begin
               If (((feld=D6)Or(feld=E6))And(Board[feld+10]=Black_Pawn)) Then inc(PosValue,20);
               inc(BBishops);
          End;
          White_Bishop:
          Begin
               If (((feld=D3)Or(feld=E3))And(Board[feld-10]=White_Pawn)) Then dec(PosValue,20);
               inc(WBishops);
          End;
          Black_Rook,White_Rook:
          Begin
               If Board[feld]=Black_Rook
                 Then col:=PLAYER_BLACK
                 Else Col:=PLAYER_WHITE;

               If Col=PLAYER_BLACK Then
                 Begin
                   If feld<=H2 Then inc(bron2);
                 End
               Else
                 Begin
                   If feld>=A7 Then inc(wron7);
                 End;

               If ((j>=C_LINE)And(j<=E_LINE)) Then PosValue:=PosValue+4*Col;

               If Pawns[j][-col]=0 Then inc(PosValue,8*Col);
               If Pawns[j][col]=0 Then inc(PosValue,5*Col);
          End;
          Black_Pawn,White_Pawn:
          Begin
               If Board[feld]=Black_Pawn
                 Then col:=PLAYER_BLACK
                 Else Col:=PLAYER_WHITE;
               inc(PosValue,Col*Calc_Pawns(PLAYER_BLACK,feld,i,j,developed[PLAYER_BLACK]));
               inc(PawnCount);
          End;
         End; //case
         inc(feld);
      End; //for
   End;

   If PawnCount=0 Then
    If ((matsum1<=MAT_L)Or(matsum1=2*MAT_S)Or((abs(MatBalance[Depth])<100)And(matsum1<=(2*MAT_L)))) Then
   Begin
        result:= 0;
        exit;
   End;

   If WBishops>=2 Then inc(PosValue,15);
   If BBishops>=2 Then dec(PosValue,15);

   If ((wron7>0)And(Kings[PLAYER_BLACK]>=A7)) Then
   Begin
      inc(PosValue,10);
      If wron7>1 Then inc(PosValue,25);
   End;

   If ((bron2>0)And(Kings[PLAYER_WHITE]<=H2)) Then
   Begin
      dec(PosValue,10);
      If bron2>1 Then dec(PosValue,25);
   End;

   PosValue:=PosValue*seite;

   If Depth>=1 Then PosValue:=PosValue-((Mobile[Depth]-Mobile[Depth-1]) div 16);
   result:= Value+PosValue;
End;

Procedure TChessCalculator.Notate_Move(FromField,ToField:LongInt;Nest:Boolean);
Var FigValue:LongInt;
    i:LongInt;
Begin
   If not Nest Then
    If ((((Board[FromField]=White_Pawn)And(FromField>=A7)))Or
        (((Board[FromField]=Black_Pawn)And(FromField<=H2)))) Then
   Begin
       i:=White_Queen;
       While i>White_Pawn Do
       Begin
           Notate_Move(FromField,ToField,True);
           MoveStack^[Index-1].To_Figure:=i;
           dec(i);
       End;
       exit;
   End;

   If Board[ToField]=Empty Then
   Begin
       If ((Board[FromField]=White_Bishop*Color)OR(Board[FromField]=White_Rook*Color)) Then
         Mobile[Depth]:=Mobile[Depth]+CenterTable[ToField];

       If ((HVar[0][Depth].FromField=FromField)And(HVar[0][Depth].ToField=ToField)) Then
         MoveStack^[Index].Value:=HVARBONUS
       Else If ((KillerTab[Depth].killer1.FromField=FromField)And
                (KillerTab[Depth].killer1.ToField=ToField)) Then
         MoveStack^[Index].Value:=KILLER1BONUS
       Else If ((KillerTab[Depth].killer2.FromField=FromField)And
                (KillerTab[Depth].killer2.ToField=ToField)) Then
         MoveStack^[Index].Value:=KILLER2BONUS
       Else MoveStack^[Index].Value:=Empty;

       MoveStack^[Index].FromField:=FromField;
       MoveStack^[Index].ToField:=ToField;
       MoveStack^[Index].Figure_taken:=Empty;
   End
   Else
   Begin
       If ((Board[ToField]=White_King)OR(Board[ToField]=Black_King)) Then exit;

       FigValue:=FigMaterial[abs(Board[ToField])];
       MoveStack^[Index].FromField:=FromField;
       MoveStack^[Index].ToField:=ToField;
       MoveStack^[Index].Figure_taken:=abs(Board[ToField]);
       MoveStack^[Index].Value:=FigValue-(FigMaterial[abs(Board[FromField])] div 8);

       If ((Depth>0)And(ToField=TargetField[Depth-1])) Then
         MoveStack^[Index].Value:=MoveStack^[Index].Value+300;

       If ((HVar[0][Depth].FromField=FromField)And(HVar[0][Depth].ToField=ToField)) Then
         MoveStack^[Index].Value:=MoveStack^[Index].Value+HVARBONUS
       Else If ((KillerTab[Depth].killer1.FromField=FromField)And
                (KillerTab[Depth].killer1.ToField=ToField)) Then
         MoveStack^[Index].Value:=MoveStack^[Index].Value+KILLER1BONUS
       Else If ((KillerTab[Depth].killer2.FromField=FromField)And
                (KillerTab[Depth].killer2.ToField=ToField)) Then
         MoveStack^[Index].Value:=MoveStack^[Index].Value+KILLER2BONUS;

   End;

   MoveStack^[Index].To_Figure:=Empty;
   MoveStack^[Index].rochade_nr:=NOROCHADE;
   MoveStack^[Index].Ep_Field:=ILLEGAL;

   If Index<MOVESTACKDIM Then inc(Index)
   Else
   Begin
      Status:=Error;
      PStop;
   End;
End;

Procedure TChessCalculator.Notate_epMove( FromField,ToField, epField : LongInt);
Begin
   If ((Board[ToField]=White_King)OR(Board[ToField]=Black_King)) Then exit;

   MoveStack^[Index].FromField:=FromField;
   MoveStack^[Index].ToField:=ToField;
   MoveStack^[Index].Figure_taken:=White_Pawn;
   MoveStack^[Index].To_Figure:=Empty;
   MoveStack^[Index].rochade_nr:=NOROCHADE;
   MoveStack^[Index].Ep_Field:=epField;
   MoveStack^[Index].Value:=MAT_B;

   If Index<MOVESTACKDIM Then inc(Index)
   Else
   Begin
      Status:=Error;
      PStop;
   End;
End;

Procedure TChessCalculator.Generate_Moves(allezuege : LongInt);
Var
   FromField,ToField,Figure : LongInt;
   i:LongInt;
   longmove: Boolean;
   Direction : LongInt;
   epField : LongInt;
Label goahead;
Label glideagain;
Begin
   Index:=StackValue[Depth];
   Mobile[Depth]:=0;

   For FromField:=A1 To H8 Do
   Begin
      Figure:=Board[FromField];
      If ((Figure=Empty)Or(Figure=Edge)Or(Sgn(Figure)=-Sgn(Color))) Then Continue;

      Figure:=abs(Figure);

      If Figure=White_Pawn Then
      Begin
           If(Board[FromField+10*Color]=Empty) Then
           Begin
               if ((Color=PLAYER_WHITE)And(FromField>=A7))Or((Color=PLAYER_BLACK)And(FromField<=H2)) Then
                 Notate_Move(FromField,FromField+10*Color,False)
               Else If allezuege>0 Then
               Begin
                  Notate_Move(FromField,FromField+10*Color,False);

                  If Board[FromField+20*Color]=Empty Then
                    If ((Color=PLAYER_WHITE)And(FromField<=H2))Or((Color=PLAYER_BLACK)And(FromField>=A7)) Then
                  Begin
                     Notate_Move(FromField,FromField+20*Color,False);
                     MoveStack^[Index-1].Ep_Field:=FromField+10*Color;
                  End;
               End;
            End;

            If sgn(Board[FromField+11*Color])=-Sgn(Color) Then
            Begin
               If ((Color=PLAYER_WHITE)Or(Board[FromField+11*Color]<>Edge)) Then
                 Notate_Move(FromField,FromField+11*Color,False);
            End;

            If Sgn(Board[FromField+9*Color])=-Sgn(Color) Then
            Begin
               If ((Color=PLAYER_WHITE)Or(Board[FromField+9*Color]<>Edge)) Then
                 Notate_Move(FromField,FromField+9*Color,False);
            End;

            continue;
      End;

      longmove:=FigOffset[Figure].longmove;
      i:=FigOffset[Figure].FStart;
      While i<=FigOffset[Figure].FEnd Do
      Begin
         Direction:=Offset[i];
         ToField:=FromField;
glideagain:
         ToField:=ToField+Direction;

         If Board[ToField]=Empty Then
         Begin
            If allezuege>0 Then Notate_Move(FromField,ToField,False);
            If longmove Then goto glideagain
            Else goto goahead;
         End;

         If Board[ToField]=Edge Then goto goahead;

         If Sgn(Color)=-Sgn(Board[ToField]) Then Notate_Move(FromField,ToField,False);
goahead:
         inc(i);
      End;
   End;

   If Ep_Field[Depth]<>ILLEGAL Then
   Begin
      epField:=Ep_Field[Depth];
      If Board[epField-9*Color]=White_Pawn*Color Then
        Notate_epMove(epField-9*Color,epField,epField-10*Color);
      If Board[epField-11*Color]=White_Pawn*Color Then
        Notate_epMove(epField-11*Color,epField,epField-10*Color);
   End;

   If Color=PLAYER_WHITE Then
   Begin
      If ((Kings[PLAYER_WHITE]=E1)And(Moved[E1]=0)) Then
      Begin
         If ((Board[H1]=White_Rook)And(Moved[H1]=0)And
             (Board[F1]=Empty)And(Board[G1]=Empty)And
             (not AttacksField(E1,PLAYER_BLACK))And(not AttacksField(F1,PLAYER_BLACK))And
             (not AttacksField(G1,PLAYER_BLACK))) Then
         Begin
            Notate_Move(E1,G1,False);
            MoveStack^[Index-1].rochade_nr:=SHORTROCHADE;
         End;

         If ((Board[A1]=White_Rook)And(Moved[A1]=0)And
             (Board[D1]=Empty)And(Board[C1]=Empty)And
             (Board[B1]=Empty)And(not AttacksField(E1,PLAYER_BLACK))And
             (not AttacksField(D1,PLAYER_BLACK))And
             (not AttacksField(C1,PLAYER_BLACK))) Then
         Begin
            Notate_Move(E1,C1,False);
            MoveStack^[Index-1].rochade_nr:=LONGROCHADE;
         End;
      End;
   End
   Else
   Begin
      If ((Kings[PLAYER_BLACK]=E8)And(Moved[E8]=0)) Then
      Begin
         If ((Board[H8]=Black_Rook)And(Moved[H8]=0)And
             (Board[F8]=Empty)And(Board[G8]=Empty)And
             (not AttacksField(E8,PLAYER_WHITE))And(not AttacksField(F8,PLAYER_WHITE))And
             (not AttacksField(G8,PLAYER_WHITE))) Then
         Begin
            Notate_Move(E8,G8,False);
            MoveStack^[Index-1].rochade_nr:=SHORTROCHADE;
         End;

         If ((Board[A8]=Black_Rook)AND(Moved[A8]=0)And
             (Board[D8]=Empty)AND(Board[C8]=Empty)And
             (Board[B8]=Empty)And(not AttacksField(E8,PLAYER_WHITE))And
             (not AttacksField(D8,PLAYER_WHITE))And
             (not AttacksField(C8,PLAYER_WHITE))) Then
         Begin
            Notate_Move(E8,C8,False);
            MoveStack^[Index-1].rochade_nr:=LONGROCHADE;
         End;
      End;
   End;

   StackValue[Depth+1]:=Index;
End;

Procedure TChessCalculator.InitCalc;
Var
   i,Col:LongInt;
Begin
   For i:=A1 To H8 Do
   Begin
      PControl[i][PLAYER_WHITE]:=0;
      PControl[i][PLAYER_BLACK]:=0;
   End;

   For i:=0 To H_LINE+1 Do
   Begin
      Pawns[i][PLAYER_WHITE]:=0;
      Pawns[i][PLAYER_BLACK]:=0;
      Rooks[i][PLAYER_WHITE]:=0;
      Rooks[i][PLAYER_BLACK]:=0;
   End;

   For i:=A1 To H8 Do
   Begin
      Case (Board[i]) Of
       White_Pawn,Black_Pawn:
       Begin
            Col:=Sgn(Board[i]);
            inc(PControl[i+9*Col][Col]);
            inc(PControl[i+11*Col][Col]);
            inc(Pawns[i mod 10][Col]);
       End;
       Black_Rook:inc(Rooks[i mod 10][PLAYER_BLACK]);
       White_Rook:inc(Rooks[i mod 10][PLAYER_WHITE]);
      End; //case
   End;
End;

Procedure TChessCalculator.Computer_Move;
Var
   Distance,alpha,beta,i,Value,besterwert,j : LongInt;
   Check : Boolean;
   tmp : TMoveFromTo;
Label goahead;
Begin
   InitializeTree;
   Value:=Calculate_Board(-MATE,MATE,Color);
   If Value=MATE Then exit;

   Check:=InCheck;
   NodeCount:=0;
   Generate_Moves(1);
   Distance:=1;
   While Distance<=TargetDepth Do
   Begin
      If Distance=1 Then
      Begin
         alpha:=-MATE;
         beta:=MATE;
      End
      Else
      Begin
         beta:=alpha+100;
         dec(alpha,100);
      End;

      MaxExtension:=Distance+3;

      i:=0;
      While i<StackValue[1] Do
      Begin
         HVar[Depth][Depth].FromField:=0;

         ExecuteMove(i);
         Value:=-alpha_beta(-beta,-alpha,Distance-1);
         MoveBack(i);

         If Stop Then goto goahead;
         If i=0 Then
         Begin
            If Value<alpha Then
            Begin
               alpha:=-MATE;
               beta:=Value;
               ExecuteMove(i);
               Value:=-alpha_beta(-beta,-alpha,Distance-1);
               MoveBack(i);
            End
            Else If Value>=beta Then
            Begin
               alpha:=Value;
               beta:=MATE;
               ExecuteMove(i);
               Value:=-alpha_beta(-beta,-alpha,Distance-1);
               MoveBack(i);
            End;
            alpha:=Value;
            beta:=alpha+1;
            Copy_hvar(i);
         End
         Else
         Begin
            If Value>alpha Then
            Begin
               besterwert:=alpha;
               alpha:=Value;
               beta:=MATE;
               ExecuteMove(i);
               Value:=-alpha_beta(-beta,-alpha,Distance-1);
               MoveBack(i);
               If Value>besterwert Then
               Begin
                  alpha:=Value;
                  beta:=alpha+1;
                  Copy_hvar(i);
                  tmp:=MoveStack^[i];
                  j:=i;
                  While j>0 Do
                  Begin
                     MoveStack^[j]:=MoveStack^[j-1];
                     dec(j);
                  End;
                  MoveStack^[0]:=tmp;
               End;
            End;
         End;
         inc(i);
      End;
      inc(Distance);
   End;

goahead:
   stop:=true;
   If alpha> -(MATE-1) Then
   Begin
      If ((alpha>=MATE-10)Or(alpha<=-MATE+10)) Then
        If trunc((MATE-2-alpha)/2)=0 Then Status:=CheckMate;
   End
   Else
   Begin
      If Check Then Status:=CheckMate
      Else Status:=Patt;
   End;
End;


Function TChessCalculator.Enter_Move(FromField,ToField, ToFigure : LongInt): Boolean;
Var
   i:LongInt;
   tmp:LongInt;
Begin
   Generate_Moves(1);
   i:=StackValue[Depth];

   While i<StackValue[Depth+1] Do
   Begin
      If ((MoveStack^[i].FromField=FromField)And(MoveStack^[i].ToField=ToField)) Then
      Begin
         If MoveStack^[i].To_Figure<>Empty Then
         Begin
            If abs(ToFigure)=White_Knight Then inc(i)
            Else If abs(ToFigure)=White_Bishop Then inc(i,2)
            Else If abs(ToFigure)=White_Rook Then inc(i,3);
         End;

         InitializeTree;
         tmp:=LastMove;
         ExecuteMove(i);

         If AttacksField(Kings[-Color],Color) Then
         Begin
             status:=Illegal_Move;
             MoveBack(i);
             LastMove:=tmp;
             Result:= FALSE;
             exit;
         End;

         MoveBack(i);
         result:=TRUE;
         exit;
      End;
      inc(i);
   End;
   result:=FALSE;
End;

constructor TChessCalculator.Create(AOwner : TComponent);
Var t:LongInt;
begin
  Inherited Create(AOwner);
  ZugNr:=0;
  RPossible:=[WlR,WsR,BlR,BsR];
  Move(DefaultBoard,Board,sizeof(DefaultBoard));
  Kings[PLAYER_WHITE]:=E1;
  Kings[PLAYER_BLACK]:=E8;
  For t:=0 To 2 Do Rochade[t]:=FALSE;
  For t:=A1 To H8 Do Moved[t]:=0;
  Ep_Field[0]:=ILLEGAL;
  MatSum[0]:=MAT_GESAMT;
  MatBalance[0]:=0;
  StackValue[0]:=0;
  TargetDepth:=CalcDepth;
  Depth:=0;
  SaveDepth:=0;
  Color:=PLAYER_WHITE;
  Stop:=true;
  New(MoveStack);
End;

Procedure TChessCalculator.PStop;
Begin
  With CurrentMove Do
  Begin
    FromField:=MoveStack^[0].FromField;
    ToField:=MoveStack^[0].ToField;
    If ((epField<>ILLEGAL)And(MoveStack^[0].Figure_taken<>Empty)) Then
    Begin
      epSchlag:=MoveStack^[0].Ep_Field;
      epField:=Empty;
    End
    Else
    Begin
      epSchlag:=Empty;
      epField:=MoveStack^[0].Ep_Field;
    End;

    Figuretaken:=MoveStack^[0].Figure_taken*-CurrentPlayer;
    ToFigure:=MoveStack^[0].To_Figure*CurrentPlayer;
    rochadeArt:=MoveStack^[0].Rochade_Nr;
  End;

  If Moved[e1]<>0 Then CurrentMove.Rochademoeglichkeiten:=CurrentMove.Rochademoeglichkeiten-[WsR, WlR];
  If Moved[a1]<>0 Then CurrentMove.Rochademoeglichkeiten:=CurrentMove.Rochademoeglichkeiten-[WlR];
  If Moved[h1]<>0 Then CurrentMove.Rochademoeglichkeiten:=CurrentMove.Rochademoeglichkeiten-[WsR];
  If Moved[e8]<>0 Then CurrentMove.Rochademoeglichkeiten:=CurrentMove.Rochademoeglichkeiten-[BsR, BlR];
  If Moved[a8]<>0 Then CurrentMove.Rochademoeglichkeiten:=CurrentMove.Rochademoeglichkeiten-[BlR];
  If Moved[h8]<>0 Then CurrentMove.Rochademoeglichkeiten:=CurrentMove.Rochademoeglichkeiten-[BsR];

  Dispose(MoveStack);
  Stop:=true;
End;

Procedure TChessCalculator.Enter_Board;
Var t,Temp:LongInt;
begin
  Depth:=0;
  MatBalance[0]:=0;
  MatSum[0]:=0;
  for t:=A1 to H8 do
  Begin
     If Board[t] In [Empty,Edge] Then continue;

     If(Board[t]>0)
       Then temp:= PLAYER_WHITE
       Else temp:= PLAYER_BLACK;
     MatBalance[0]:=MatBalance[0]+temp*FigMaterial[abs(Board[t])];
     if(abs(Board[t])<>White_Pawn) then
        MatSum[0]:=MatSum[0] + FigMaterial[abs(Board[t])];
     If ((Board[t]=White_King)Or(Board[t]=Black_King)) then Kings[temp]:=t;
  End;

  MatBalance[0]:=Color*MatBalance[0];

  For t:=A1 To H8 Do Moved[t]:=1;

  Moved[E1]:=0;
  Moved[E8]:=0;
  ZugNr:=0;

  If WsR In CurrentMove.Rochademoeglichkeiten  Then Moved[h1]:=0;
  If wlr In CurrentMove.Rochademoeglichkeiten  Then Moved[a1]:=0;
  If BsR In CurrentMove.Rochademoeglichkeiten  Then Moved[h8]:=0;
  If BlR In CurrentMove.Rochademoeglichkeiten  Then Moved[a8]:=0;
  If (WsR In CurrentMove.Rochademoeglichkeiten)And(wlr in CurrentMove.Rochademoeglichkeiten) Then
    rochade[PLAYER_WHITE+1]:=FALSE
  Else
    rochade[PLAYER_WHITE+1]:=TRUE;
  If (BsR In CurrentMove.Rochademoeglichkeiten)And(BlR in CurrentMove.Rochademoeglichkeiten) Then
    rochade[PLAYER_BLACK+1]:=FALSE
  Else
    rochade[PLAYER_BLACK+1]:=TRUE;
  Ep_Field[0]:=CurrentMove.epField;
End;

Function TChessCalculator.FigureAt(pos:LongInt):LongInt;
Begin
   If stop Then result:=Board[pos]
   Else result:=SaveBoard[pos];
End;

Procedure TChessCalculator.DoMove(Var Move:TMove);
Begin
   New(MoveStack);
   Move.Figuretaken:=Board[Move.ToField];
   With MoveStack^[0] Do
   Begin
       FromField:=Move.FromField;
       ToField:=Move.ToField;
       Rochade_Nr:=Move.RochadeArt;
       If Board[FromField]=White_Pawn Then
        If (ToField Div 10)=9 Then To_Figure:=White_Queen;
       If Board[FromField]=Black_Pawn Then
        If (ToField Div 10)=2 Then To_Figure:=White_Queen;
   End;
   ExecuteMove(0);
   Dispose(MoveStack);
End;

Function TChessCalculator.Start(mcolor:LongInt):TMove;
Var Value:Longint;
Begin
 If stop Then
 begin
   New(MoveStack);
   Status:=0;
   TargetDepth:=CalcDepth;
   Color:=mcolor;
   CurrentMove.CurrentPlayer:=mcolor;
   System.Move(Board,SaveBoard,sizeof(Board));
   Stop:=false;
   Computer_Move;
   If (stop)And(status=patt) Then
   Begin
     stop:=false;
     TargetDepth:=1;
     Status:=0;
     Computer_Move;
   End;
   PStop;
   Result:=CurrentMove;
 End;
End;


Procedure TChessCalculator.MoveBack(aktzug : LongInt);
Var
   FromField,ToField,epField : LongInt;
Begin
   dec(ZugNr);
   FromField:=MoveStack^[aktzug].FromField;
   ToField:=MoveStack^[aktzug].ToField;
   epField:=MoveStack^[aktzug].Ep_Field;

   Color := -Color;
   dec(Depth);
   Board[FromField]:=Board[ToField];
   Board[ToField]:=Empty;

   If ((epField<>ILLEGAL)And(MoveStack^[aktzug].Figure_taken=White_Pawn)) Then
      Board[epField]:=-Color
   Else If(MoveStack^[aktzug].Figure_taken<>Empty) Then
      Board[ToField]:= (-Color)*MoveStack^[aktzug].Figure_taken;

   dec(Moved[FromField]);
   dec(Moved[ToField]);

   If MoveStack^[aktzug].rochade_nr=SHORTROCHADE Then
   Begin
      Board[ToField+1]:=Color*White_Rook;
      Board[ToField-1]:=Empty;
      Rochade[Color+1]:=FALSE;
   End
   Else If MoveStack^[aktzug].rochade_nr=LONGROCHADE Then
   Begin
      Board[ToField-2]:=Color*White_Rook;
      Board[ToField+1]:=Empty;
      Rochade[Color+1]:=FALSE;
   End;

   If MoveStack^[aktzug].To_Figure<>Empty Then Board[FromField]:=Color;

   If Board[FromField]=White_King Then Kings[PLAYER_WHITE]:=FromField
   Else If Board[FromField]=Black_King Then Kings[PLAYER_BLACK]:=FromField;
End;

Procedure TChessCalculator.TakeBackMove(Move:TMove;Color:LongInt);
Begin
  New(MoveStack);
  FillChar(CurrentMove,sizeof(CurrentMove),0);
  CurrentMove.FromField:=Move.FromField;
  CurrentMove.ToField:=Move.ToField;
  CurrentMove.CurrentPlayer:=Color;
  CurrentMove.Rochademoeglichkeiten:=RPossible;
  With MoveStack^[0] Do
  Begin
     FromField:=Move.FromField;
     ToField:=Move.ToField;
     Figure_taken:=abs(Move.Figuretaken);
     To_Figure:=Move.ToFigure;
     rochade_nr:=Move.RochadeArt;
  End;
  MoveBack(0);
  Dispose(MoveStack);
End;

Function TChessCalculator.IsLegalMove(FromField,ToField,Color:LongInt) : Boolean;
begin
  New(MoveStack);
  FillChar(CurrentMove,sizeof(CurrentMove),0);
  CurrentMove.FromField:=FromField;
  CurrentMove.ToField:=ToField;
  CurrentMove.CurrentPlayer:=Color;
  CurrentMove.Rochademoeglichkeiten:=RPossible;

  CurrentMove.Figuretaken:=Board[FromField];
  CurrentMove.RochadeArt:=0;
  Case Board[FromField] Of
    White_King:If FromField=e1 Then
    Begin
         Case ToField Of
            g1 : CurrentMove.RochadeArt:=SHORTROCHADE;
            c1 : CurrentMove.RochadeArt:=LONGROCHADE;
         End;
    End;
    Black_King:If FromField=e8 Then
    Begin
         Case ToField Of
            g8 : CurrentMove.RochadeArt:=SHORTROCHADE;
            c8 : CurrentMove.RochadeArt:=LONGROCHADE;
         End;
    End;
  End;

  Color:=CurrentMove.CurrentPlayer;
  Enter_Board;
  If not Enter_Move(CurrentMove.FromField, CurrentMove.ToField, 0) Then result:=false
  Else
  Begin
       If Board[FromField]=White_Rook Then
       Begin
           If FromField=a1 Then RPossible:=RPossible-[WlR];
           If FromField=h1 Then RPossible:=RPossible-[WsR];
       End;

       If Board[FromField]=White_King Then
       Begin
           If FromField=a8 Then RPossible:=RPossible-[BlR];
           If FromField=h8 Then RPossible:=RPossible-[BsR];
       End;

       If Board[FromField]=White_King Then RPossible:=RPossible-[WlR,WsR];
       If Board[FromField]=Black_King Then RPossible:=RPossible-[BlR,BsR];

       result:=true;
  End;
  Dispose(MoveStack);
End;

Procedure TChessCalculator.InitializeTree;
Begin
   If(Depth=0) Then exit;

   Ep_Field[0] := Ep_Field[1];
   MatBalance[0]:=MatBalance[1];
   MatSum[0]:=MatSum[1];
   Depth := 0;
End;

Procedure TChessCalculator.Copy_hvar(aktzug : LongInt);
var
   i : LongInt;
BEGIN
   HVar[Depth][Depth].FromField:=MoveStack^[aktzug].FromField;
   HVar[Depth][Depth].ToField:=MoveStack^[aktzug].ToField;
   i:=1;
   Repeat
      If(HVar[Depth+1][Depth+i].FromField=0) Then
      Begin
         HVar[Depth][Depth+i]:=HVar[Depth+1][Depth+i];
         exit;
      End;
      HVar[Depth][Depth+i]:=HVar[Depth+1][Depth+i];
      inc(i);
   Until 1=2;
End;


Function TChessCalculator.NextMove:LongInt;
Var i,besterwert: LongInt;
Begin
   result:=-1;
   besterwert:=-MATE;
   i:=StackValue[Depth];
   While i< StackValue[Depth+1] Do
   Begin
      if(MoveStack^[i].Value>besterwert) Then
      Begin
         result:=i;
         besterwert:=MoveStack^[i].Value;
      End;
      inc(i);
   End;

   If result>=0 Then MoveStack^[result].Value:=-MATE;
End;


Initialization
Begin
  ChessCalculator:=TChessCalculator.Create(Nil);
End;

Finalization
Begin
  ChessCalculator.Destroy;
End;
    
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  24-Feb-09  WD         Die Konstante "WHITE" bzw. "BLACK" auf "PLAYER_WHITE"
                        bzw. "PLAYER_BLACK" geaendert.
}

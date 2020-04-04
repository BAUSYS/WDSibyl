PROGRAM Test;

{Blake: This is an example program that demonstrates the use of operator overloading.
        I'd like to extent it a bit, but I need the exact mathematical words
        in english for some things. For instance I don't know if "Amount" is the
        right word for the amount of a vector... Same for Perpendicular and
        Direction and Square and Len and... I hope you know what I mean. Also
        I need the english words for polar-coordinates and "kartesische" (sorry,
        no english word) coordinates}

USES Crt,Vector;

PROCEDURE Test2DVectors;
VAR a,b,a0:TVector;
    dist,r,fi:Extended;
BEGIN
     Writeln('2D vectors test.');
     Writeln('----------------');

     a.Create2D(2,-3);
     b.Create2D(-1,1);

     Writeln('a= ',a.tostr);
     Writeln('-a= ',(-a).tostr);
     Writeln('b= ',b.tostr);
     Writeln('a+b= ',(a+b).tostr);
     Writeln('a-b= ',(a-b).tostr);
     Writeln('a*b= ',tostr(a*b:0:6));
     Writeln('|a|= ',tostr(a.Amount:0:6));
     Writeln('|a x b|= ',(a#b).Amount:0:6);
     Writeln('3*a= ',(Extended(3.0)*a).tostr);
     Writeln('a*3= ',(a*Extended(3.0)).tostr);
     a0:=a;
     a0.Normalize;
     Writeln('a0= ',a0.tostr);
END;

PROCEDURE Test3DVectors;
VAR a,b,a0:TVector;
    dist,r,fi:Extended;
BEGIN
     Writeln('3D vectors test.');
     Writeln('----------------');

     a.Create(2,-3,2);
     b.Create(-1,1,1);

     Writeln('a= ',a.tostr);
     Writeln('-a= ',(-a).tostr);
     Writeln('b= ',b.tostr);
     Writeln('a+b= ',(a+b).tostr);
     Writeln('a-b= ',(a-b).tostr);
     Writeln('a*b= ',tostr(a*b:0:6));
     Writeln('|a|= ',tostr(a.Amount:0:6));
     Writeln('a x b= ',(a#b).tostr);
     Writeln('3*a= ',(Extended(3.0)*a).tostr);
     Writeln('a*3= ',(a*Extended(3.0)).tostr);
     a0:=a;
     a0.Normalize;
     Writeln('a0= ',a0.tostr);
END;

PROCEDURE Test2DLines;
VAR A,B,C,D:TPoint;
    g,h,AC,AD:TLine;
BEGIN
     Writeln('2D Lines test.');
     Writeln('--------------');

     A.Create2D(3,2);
     B.Create2D(-1,0);
     C.Create2D(0,4);
     D.Create2D(-2,1);

     g.Create(A,B);
     h.Create(C,D);

     Writeln('A= ',A.tostr);
     Writeln('B= ',B.tostr);
     Writeln('C= ',C.tostr);
     Writeln('D= ',D.tostr);
     Writeln('g (AB)= ',g.tostr);
     Writeln('h (CD)= ',h.tostr);
     Writeln('Calculating intersection point of g and h...');
     Writeln('g#h= S ',(g#h).tostr);
     Writeln('Calculating intersection point of AC and AD...');
     AC.Create(A,C);
     AD.Create(A,D);
     Writeln('AC # AC = S ',(AC#AD).tostr);
END;

PROCEDURE Test3DPlanes;
VAR A,B,C,P,Q,R,X,Y:TPoint;
    g:TLine;
    e,f:TPlain;
BEGIN
     Writeln('3D planes test.');
     Writeln('--------------');

     A.Create(1,0,0);
     B.Create(0,1,0);
     C.Create(0,0,1);
     P:=B;
     Q:=C;
     R.Create(0,0,10);
     X.Create(0,0,0);
     Y.Create(1,1,1);

     g.Create(X,Y);
     e.CreateFrom3Points(A,B,C);
     f.CreateFrom3Points(P,Q,R);

     Writeln('e= ',e.tostr);
     Writeln('f= ',f.tostr);
     Writeln('g= ',g.tostr);
     Writeln('e#f= ',(e#f).tostr);
     Writeln('e#g= ',(e#g).tostr);
END;

BEGIN
     Test2DVectors;
     Writeln;
     Writeln('Press any key...');
     readKey;
     Writeln;
     Test3DVectors;
     Writeln;
     Writeln('Press any key...');
     readkey;
     Writeln;
     Test2DLines;
     Writeln;
     Writeln('Press any key...');
     readkey;
     Writeln;
     Test3DPlanes;
END.


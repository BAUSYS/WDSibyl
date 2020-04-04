UNIT Vector;

{**************************************************************************
 *                                                                        *
 *                                                                        *
 *                                                                        *
 * Demonstration of operator overloading in Sibyl                         *
 *                                                                        *
 *                                                                        *
 **************************************************************************}

INTERFACE

USES SysUtils;

TYPE TStatus=(stOk,stError);

TYPE EVectorError=CLASS(Exception);

TYPE TVector=OBJECT
        PRIVATE
              Fx,Fy,Fz:Extended;
              FStatus:TStatus;
        PUBLIC
              CONSTRUCTOR Create(CONST x,y,z:Extended);
              CONSTRUCTOR Create2D(CONST x,y:Extended);
              PROCEDURE Normalize;
              FUNCTION Amount:Extended;
              FUNCTION ToStr:STRING;
        PUBLIC
              PROPERTY x:Extended read Fx write Fx;
              PROPERTY y:Extended read Fy write Fy;
              PROPERTY z:Extended read Fz write Fz;
              PROPERTY Status:TStatus read FStatus write FStatus;
     END;

     TPoint=TVector;

     TLine=OBJECT
        PRIVATE
              FStartPoint:TPoint;
              FDirection:TVector;
              FStatus:TStatus;
        PUBLIC
              CONSTRUCTOR Create(CONST p1,p2:TPoint);
              CONSTRUCTOR CreateFromDirection(CONST p1:TPoint;CONST Direction:TVector);
              FUNCTION SmallestDistance(h:TLine):Extended;
              FUNCTION Perpendicular(h:TLine):TVector;
              FUNCTION ToStr:STRING;
        PUBLIC
              PROPERTY StartPoint:TPoint read FStartPoint write FStartPoint;
              PROPERTY Direction:TVector read FDirection write FDirection;
              PROPERTY Status:TStatus read FStatus write FStatus;
     END;

     TPlain=OBJECT
        PRIVATE
              FBasePoint:TPoint;
              FPerpendicular:TVector;
              Direction1:TVector;
              Direction2:TVector;
              FConstant:Extended;
              FStatus:TStatus;
        PUBLIC
              CONSTRUCTOR Create(CONST p1:TPoint;CONST Perpendicular:TVector);
              CONSTRUCTOR CreateFromPerpendicularConst(CONST Perpendicular:TVector;CONST Constant:Extended);
              CONSTRUCTOR CreateFrom3Points(CONST p1,p2,p3:TPoint);
              CONSTRUCTOR CreateFromLinePoint(CONST g:TLine;CONST p:TPoint);
              FUNCTION Distance(p:TPoint):Extended;
              FUNCTION tostr:STRING;
        PUBLIC
              PROPERTY BasePoint:TPoint read FBasePoint write FBasePoint;
              PROPERTY Perpendicular:TVector read FPerpendicular write FPerpendicular;
              PROPERTY Constant:Extended read FConstant write FConstant;
              PROPERTY Status:TStatus read FStatus write FStatus;
     END;

CONST
     TostrLen:LONGWORD=0;
     TostrDigits:LONGWORD=6;

//Operator overloads for TVector

//a+b=(ax+bx,ay+by,az+bz)
FUNCTION VectorAdd(CONST a,b:TVector):TVector;operator +;
//a-b=(ax-bx.ay-by,az-bz)
FUNCTION VectorSub(CONST a,b:TVector):TVector;operator -;
//a*b=ax*bx+ay*by+az*bz
FUNCTION VectorMul(CONST a,b:TVector):Extended;operator *;
//a#b=(ay*bz-az*by,az*bx-ax*bz,ax*by-ay*bx)
FUNCTION VectorCrossMul(CONST a,b:TVector):TVector;operator #;
//-a=(-ax,-ay,-az)
FUNCTION VectorNegate(CONST a:TVector):TVector;operator -;
//c*a=(ax*c,ay*c,az*c)
FUNCTION VectorScalarMul1(CONST c:Extended;CONST a:TVector):TVector;operator *;
//a*c=c*a
FUNCTION VectorScalarMul2(CONST a:TVector;CONST c:Extended):TVector;operator *;
//a/c=(ax/c,ay/c,az/c)
FUNCTION VectorScalarDiv(CONST a:TVector;CONST c:Extended):TVector;operator /;

//Operator overloads for TLine

//Intersection point of two lines
FUNCTION LineIntersect(CONST g,h:TLine):TPoint;operator #;

//Operator overloads for TPlain

//Intersection Point of Line and Plain
FUNCTION LinePlainIntersect(CONST g:TLine;CONST e:TPlain):TPoint;operator #;
//Intersection Poinz of Plain and Line
FUNCTION PlainLineIntersect(CONST e:TPlain;CONST g:TLine):TPoint;operator #;
//Intersection Point of 2 plains
FUNCTION PlainIntersect(CONST e1,e2:TPlain):TLine;operator #;


IMPLEMENTATION

{****************************************************************************
 *                                                                          +
 *                                                                          *
 * TVector                                                                  *
 *                                                                          *
 *                                                                          *
 ****************************************************************************}

//Operator overloads

//a+b=(ax+bx,ay+by,az+bz)
FUNCTION VectorAdd(CONST a,b:TVector):TVector;
BEGIN
     result.Create(a.x+b.x,a.y+b.y,a.z+b.z);
END;

//a-b=(ax-bx.ay-by,az-bz)
FUNCTION VectorSub(CONST a,b:TVector):TVector;
BEGIN
     result.Create(a.x-b.x,a.y-b.y,a.z-b.z);
END;

//a*b=ax*bx+ay*by+az*bz
FUNCTION VectorMul(CONST a,b:TVector):Extended;
BEGIN
     result:=a.x*b.x+a.y*b.y+a.z*b.z;
END;

//a#b=(ay*bz-az*by,az*bx-ax*bz,ax*by-ay*bx)
FUNCTION VectorCrossMul(CONST a,b:TVector):TVector;
BEGIN
     result.Create(a.y*b.z-a.z*b.y,a.z*b.x-a.x*b.z,a.x*b.y-a.y*b.x);
END;

//-a=(-ax,-ay,-az)
FUNCTION VectorNegate(CONST a:TVector):TVector;
BEGIN
     result.Create(-a.x,-a.y,-a.z);
END;

//c*a=(ax*c,ay*c,az*c)
FUNCTION VectorScalarMul1(CONST c:Extended;CONST a:TVector):TVector;
BEGIN
     result.Create(a.x*c,a.y*c,a.z*c);
END;

//a*c=c*a
FUNCTION VectorScalarMul2(CONST a:TVector;CONST c:Extended):TVector;
BEGIN
     result:=c*a;
END;

//a/c=(ax/c,ay/c,az/c)
FUNCTION VectorScalarDiv(CONST a:TVector;CONST c:Extended):TVector;
BEGIN
     result.Create(a.x/c,a.y/c,a.z/c);
END;

CONSTRUCTOR TVector.Create(CONST x,y,z:Extended);
BEGIN
     SELF.x:=x;
     SELF.y:=y;
     SELF.z:=z;
     Status:=stOk;
END;

CONSTRUCTOR TVector.Create2D(CONST x,y:Extended);
BEGIN
     TVector.Create(x,y,0);
END;

FUNCTION TVector.Amount:Extended;
BEGIN
     result:=sqrt(sqr(x)+sqr(y)+sqr(z));
END;

PROCEDURE TVector.Normalize;
VAR A:Extended;
BEGIN
     A:=Amount;
     x:=x/A;
     y:=y/A;
     z:=z/A;
END;

FUNCTION TVector.ToStr:STRING;
BEGIN
     result:='( '+System.ToStr(x:TostrLen:ToStrDigits)+', '+
                  System.ToStr(y:TostrLen:TostrDigits)+', '+
                  System.ToStr(z:TostrLen:TostrDigits)+' )';
END;

{****************************************************************************
 *                                                                          +
 *                                                                          *
 * TLine                                                                    *
 *                                                                          *
 *                                                                          *
 ****************************************************************************}

//Operator overloads for TLine

//Intersection point of two lines
FUNCTION LineIntersect(CONST g,h:TLine):TPoint;
VAR n:TVector;
    k,t:Extended;
BEGIN
     //Make cross product of direction vectors
     n:=g.Direction#h.Direction;

     IF n.Amount=0 THEN //identical or parallel
     BEGIN
          result.Create(1E38,1E38,1E38);
          result.Status:=stError;
          RAISE EVectorError.Create('Lines have no intersection point');
          exit;
     END;

     k:=abs((h.StartPoint-g.StartPoint)*n);
     IF k<>0 THEN  //lines don't cross (Smalles distance <>0)
     BEGIN
          result.Create(1E38,1E38,1E38);
          result.Status:=stError;
          RAISE EVectorError.Create('Lines have no intersection point');
          exit;
     END;

     //Parameter for intersection point
     t:=(((g.StartPoint.y-h.StartPoint.y) * (h.Direction.x)) - ((g.StartPoint.x-h.StartPoint.x) * (h.Direction.y)))
        / ((g.Direction.x*h.Direction.y) - (g.Direction.y*h.Direction.x));

     result:=g.StartPoint+t*g.Direction;
     result.Status:=stOk;
END;


CONSTRUCTOR TLine.Create(CONST p1,p2:TPoint);
VAR p1p2:TVector;
BEGIN
     p1p2:=p2-p1;
     TLine.CreateFromDirection(p1,p1p2);
END;

CONSTRUCTOR TLine.CreateFromDirection(CONST p1:TPoint;CONST Direction:TVector);
BEGIN
     StartPoint:=p1;
     SELF.Direction:=Direction;
     SELF.Direction.Normalize;
     Status:=stOk;
END;

FUNCTION TLine.SmallestDistance(h:TLine):Extended;
VAR n:TVector;
BEGIN
     n:=Direction#h.Direction;
     result:=abs((h.StartPoint-StartPoint)*n);
END;

FUNCTION TLine.Perpendicular(h:TLine):TVector;
BEGIN
     result:=Direction#h.Direction;
END;

FUNCTION TLine.ToStr:STRING;
BEGIN
     result:=StartPoint.tostr+' + t '+Direction.tostr;
END;

{****************************************************************************
 *                                                                          +
 *                                                                          *
 * TPlain                                                                   *
 *                                                                          *
 *                                                                          *
 ****************************************************************************}

//Operator overloads for TPlain

//Intersection Point of Line and Plain
FUNCTION LinePlainIntersect(CONST g:TLine;CONST e:TPlain):TPoint;
BEGIN
     result:=e#g;
END;

//Intersection Point of Plain and Line
FUNCTION PlainLineIntersect(CONST e:TPlain;CONST g:TLine):TPoint;
VAR temp:Extended;
BEGIN
     //test scalar product
     temp:=g.Direction*e.Perpendicular;
     IF temp=0 THEN //identical or parallel
     BEGIN
          result.Create(0,0,0);
          result.Status:=stError;
          RAISE EVectorError.Create('Plane and line have no intersection point');
          exit;
     END;

     temp:=(e.Constant-g.StartPoint*e.Perpendicular)/temp;
     result:=g.StartPoint+temp*g.Direction;
END;

//Intersection Point of 2 plains
FUNCTION PlainIntersect(CONST e1,e2:TPlain):TLine;
VAR
    S:TPoint;
    n:TVector;
    temp,temp1:Extended;
BEGIN
     //Make cross product of perpendicular vectors (direction of intersectionn line)
     n:=e1.Perpendicular#e2.Perpendicular;

     IF n.Amount=0 THEN //identical or parallel
     BEGIN
          result.Create(e1.BasePoint,e1.BasePoint);
          result.Status:=stError;
          RAISE EVectorError.Create('Planes have no intersection line');
          exit;
     END;

     temp:=e1.Perpendicular*e2.Direction1;
     temp1:=e1.Constant-e1.Perpendicular*e2.BasePoint;

     IF temp=0 THEN S:=e2.BasePoint+((temp1/(e1.Perpendicular*e2.Direction2))*e2.Direction2)
     ELSE S:=e2.BasePoint+((temp1/temp)*e2.Direction1);

     result.CreateFromDirection(S,n);
END;

CONSTRUCTOR TPlain.Create(CONST p1:TPoint;CONST Perpendicular:TVector);
BEGIN
     BasePoint:=p1;
     SELF.Perpendicular:=Perpendicular;
     SELF.Perpendicular.Normalize;
     Constant:=BasePoint*SELF.Perpendicular;
     IF ((SELF.Perpendicular.X=0)AND(SELF.Perpendicular.Y=0)) THEN Direction1.Create(1,0,0)
     ELSE
     BEGIN
          Direction1.Create(-SELF.Perpendicular.Y,SELF.Perpendicular.X,0);
          Direction1.Normalize;
     END;
     Direction2:=SELF.Perpendicular#Direction1;
     Status:=stOk;
END;

CONSTRUCTOR TPlain.CreateFromPerpendicularConst(CONST Perpendicular:TVector;CONST Constant:Extended);
VAR p1:TPoint;
BEGIN
     IF Perpendicular.z<>0 THEN p1.Create(0,0,Constant/Perpendicular.Z)
     ELSE IF Perpendicular.y<>0 THEN p1.Create(0,Constant/Perpendicular.Y,0)
     ELSE IF Perpendicular.x<>0 THEN p1.Create(Constant/Perpendicular.X,0,0)
     ELSE
     BEGIN
          Status:=stError;
          RAISE EVectorError.Create('Invalid plane definition');
          exit;
     END;
     TPlain.Create(p1,Perpendicular);
END;

CONSTRUCTOR TPlain.CreateFrom3Points(CONST p1,p2,p3:TPoint);
VAR n:TVector;
BEGIN
     n:=(p2-p1)#(p3-p1);
     TPlain.Create(p1,n);
END;

CONSTRUCTOR TPlain.CreateFromLinePoint(CONST g:TLine;CONST p:TPoint);
VAR p3:TPoint;
BEGIN
     p3:=g.StartPoint+g.Direction;
     TPlain.CreateFrom3Points(p,g.StartPoint,p3);
END;

FUNCTION TPlain.Distance(p:TPoint):Extended;
BEGIN
     result:=BasePoint*Perpendicular-Constant;
END;

FUNCTION TPlain.tostr:STRING;
BEGIN
     result:=Perpendicular.tostr+' * '+BasePoint.tostr+' = '+System.tostr(Constant:TostrLen:TostrDigits);
END;

END.

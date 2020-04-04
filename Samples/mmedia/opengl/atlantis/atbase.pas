Unit AtBase;

Interface

Uses OpenGL;

Const RAD  = 57.295;
      RRAD = 0.01745;

      NUM_SHARKS  =4;
      SHARKSIZE   =6000;
      SHARKSPEED  =100.0;

      WHALESPEED  =250.0;

Type fishRec=Record
                 x, y, z, phi, theta, psi, v:Single;
                 xt, yt, zt:Single;
                 htail, vtail:Single;
                 dtheta:Single;
                 spurt:Boolean;
                 attack:Boolean;
     End;

Var sharks:Array[0..NUM_SHARKS-1] Of fishRec;
    momWhale:fishRec;
    babyWhale:fishRec;
    dolph:fishRec;


Implementation

Begin
End.
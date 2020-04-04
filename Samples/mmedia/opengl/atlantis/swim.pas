Unit Swim;

{**
 * (c) Copyright 1993, 1994, Silicon Graphics, Inc.
 * ALL RIGHTS RESERVED
 * Permission to use, copy, modify, and distribute this software for
 * any purpose and without fee is hereby granted, provided that the above
 * copyright notice appear in all copies and that both the copyright notice
 * and this permission notice appear in supporting documentation, and that
 * the name of Silicon Graphics, Inc. not be used in advertising
 * or publicity pertaining to distribution of the software without specific,
 * written prior permission.
 *
 * THE MATERIAL EMBODIED ON THIS SOFTWARE IS PROVIDED TO YOU "AS-IS"
 * AND WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR OTHERWISE,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY OR
 * FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL SILICON
 * GRAPHICS, INC.  BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT,
 * SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY
 * KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION,
 * LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF
 * THIRD PARTIES, WHETHER OR NOT SILICON GRAPHICS, INC.  HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE
 * POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * US Government Users Restricted Rights
 * Use, duplication, or disclosure by the Government is subject to
 * restrictions set forth in FAR 52.227.19(c)(2) or subparagraph
 * (c)(1)(ii) of the Rights in Technical Data and Computer Software
 * clause at DFARS 252.227-7013 and/or in similar or successor
 * clauses in the FAR or the DOD or NASA FAR Supplement.
 * Unpublished-- rights reserved under the copyright laws of the
 * United States.  Contractor/manufacturer is Silicon Graphics,
 * Inc., 2011 N.  Shoreline Blvd., Mountain View, CA 94039-7311.
 *
 * OpenGL(TM) is a trademark of Silicon Graphics, Inc.
 *
}

Interface

Uses AtBase,OpenGL,Sysutils;

Procedure FishTransform(Var fish:fishRec);
Procedure WhalePilot(Var fish:fishRec);
Procedure SharkPilot(Var fish:fishRec);
Procedure SharkMiss(i:LongInt);

Implementation

Procedure FishTransform(Var fish:fishRec);
Begin
    glTranslatef(fish.y, fish.z, -fish.x);
    glRotatef(-fish.psi, 0.0, 1.0, 0.0);
    glRotatef(fish.theta, 1.0, 0.0, 0.0);
    glRotatef(-fish.phi, 0.0, 0.0, 1.0);
End;

Procedure WhalePilot(Var fish:fishRec);
Begin
    fish.phi := -20.0;
    fish.theta := 0.0;
    fish.psi := fish.psi - 0.5;

    fish.x := fish.x + WHALESPEED * fish.v * cos(fish.psi / RAD) *
              cos(fish.theta / RAD);
    fish.y := fish.y + WHALESPEED * fish.v * sin(fish.psi / RAD) *
              cos(fish.theta / RAD);
    fish.z := fish.z + WHALESPEED * fish.v * sin(fish.theta / RAD);
End;

Procedure SharkPilot(Var fish:fishRec);
Const
    sign:LongInt = 1;
Var
    X, Y, Z, tpsi, ttheta, thetal:Single;
Begin
    fish.xt := 60000.0;
    fish.yt := 0.0;
    fish.zt := 0.0;

    X := fish.xt - fish.x;
    Y := fish.yt - fish.y;
    Z := fish.zt - fish.z;

    thetal := fish.theta;

    ttheta := RAD * arctan(Z / (sqrt(X * X + Y * Y)));

    If ttheta > fish.theta + 0.25 Then fish.theta := fish.theta + 0.5
    Else If ttheta < fish.theta - 0.25 Then fish.theta := fish.theta - 0.5;

    If fish.theta > 90.0 Then fish.theta := 90.0;

    If fish.theta < -90.0 Then fish.theta := -90.0;

    fish.dtheta := fish.theta - thetal;

    tpsi := RAD * arctan(Y/X);

    fish.attack := False;

    If abs(tpsi - fish.psi) < 10.0 Then fish.attack := True
    Else If abs(tpsi - fish.psi) < 45.0 Then
    Begin
        If fish.psi > tpsi Then
        Begin
            fish.psi := fish.psi - 0.5;
            If fish.psi < -180.0 Then fish.psi := fish.psi + 360.0;
        End
        Else If fish.psi < tpsi Then
        Begin
            fish.psi := fish.psi + 0.5;
            If fish.psi > 180.0 Then fish.psi := fish.psi - 360.0;
        End;
    End
    Else
    Begin
        //Randomize;
        If Random(10000) Mod 100 > 98 Then sign := 1 - sign;

        fish.psi := fish.psi + sign;
        If fish.psi > 180.0 Then fish.psi := fish.psi - 360.0;

        If fish.psi < -180.0 Then fish.psi := fish.psi + 360.0;
    End;

    If fish.attack Then
    Begin
        If fish.v < 1.1 Then fish.spurt := True;

        If fish.spurt Then fish.v := fish.v + 0.2;

        If fish.v > 5.0 Then fish.spurt := False;

        If ((fish.v > 1.0) And (not fish.spurt)) Then fish.v := fish.v - 0.2;
    End
    Else
    Begin
        Randomize;
        If ((Round((random(10000)*1.0)) Mod 400=0) And (not fish.spurt)) Then fish.spurt := True;

        If fish.spurt Then fish.v := fish.v + 0.05;

        If fish.v > 3.0 Then fish.spurt := False;

        If ((fish.v > 1.0) And (not fish.spurt)) Then fish.v := fish.v - 0.05;
    End;

    fish.x := fish.x + SHARKSPEED * fish.v * cos(fish.psi / RAD) *
              cos(fish.theta / RAD);
    fish.y := fish.y + SHARKSPEED * fish.v * sin(fish.psi / RAD) *
              cos(fish.theta / RAD);
    fish.z := fish.z + SHARKSPEED * fish.v * sin(fish.theta / RAD);
End;

Procedure SharkMiss(i:LongInt);
Var
   j:LongInt;
   avoid, thetal:Single;
   X, Y, Z, R:Single;
Begin
    For j := 0 To NUM_SHARKS-1 Do
    Begin
        If j <> i Then
        Begin
            X := sharks[j].x - sharks[i].x;
            Y := sharks[j].y - sharks[i].y;
            Z := sharks[j].z - sharks[i].z;

            R := sqrt(X * X + Y * Y + Z * Z);

            avoid := 1.0;
            thetal := sharks[i].theta;

            If R < SHARKSIZE Then
            Begin
                If Z > 0.0 Then sharks[i].theta := sharks[i].theta - avoid
                Else sharks[i].theta := sharks[i].theta + avoid;
            End;
            sharks[i].dtheta := sharks[i].dtheta + (sharks[i].theta - thetal);
        End;
    End;
End;

End.

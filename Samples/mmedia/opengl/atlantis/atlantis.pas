Program Atlantis;

{$M 1024000}

{ Copyright (c) Mark J. Kilgard, 1994. }

{
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

Uses AtBase,OpenGl,Whale,Dolphin,Shark,Swim, SysUtils;

Var moving:GLboolean;

Procedure InitFishs;
Var
   i:LongInt;
Begin
    For i := 0 to NUM_SHARKS-1 Do
    Begin
        //Randomize;
        sharks[i].x := 70000.0 + Random(60000) Mod 6000;
        sharks[i].y := Random(60000) Mod 6000;
        sharks[i].z := Random(60000) Mod 6000;
        sharks[i].psi := Random(60000) Mod 360 - 180.0;
        sharks[i].v := 1.0;
    End;

    dolph.x := 30000.0;
    dolph.y := 0.0;
    dolph.z := 6000.0;
    dolph.psi := 90.0;
    dolph.theta := 0.0;
    dolph.v := 3.0;

    momWhale.x := 70000.0;
    momWhale.y := 0.0;
    momWhale.z := 0.0;
    momWhale.psi := 90.0;
    momWhale.theta := 0.0;
    momWhale.v := 3.0;

    babyWhale.x := 60000.0;
    babyWhale.y := -2000.0;
    babyWhale.z := -2000.0;
    babyWhale.psi := 90.0;
    babyWhale.theta := 0.0;
    babyWhale.v := 3.0;
End;

Procedure Init;
Const
    ambient:Array[0..3] Of Single = (0.1, 0.1, 0.1, 1.0);
    diffuse:Array[0..3] Of Single = (1.0, 1.0, 1.0, 1.0);
    position:Array[0..3] Of Single = (0.0, 1.0, 0.0, 0.0);
    mat_shininess:Array[0..0] Of Single = (90.0);
    mat_specular:Array[0..3] Of Single = (0.8, 0.8, 0.8, 1.0);
    mat_diffuse:Array[0..3] Of Single = (0.46, 0.66, 0.795, 1.0);
    mat_ambient:Array[0..3] Of Single = (0.0, 0.1, 0.2, 1.0);
    lmodel_ambient:Array[0..3] Of Single = (0.4, 0.4, 0.4, 1.0);
    lmodel_localviewer:Array[0..0] Of Single = (0.0);
    map1:Array[0..3] Of GLfloat = (0.0, 0.0, 0.0, 0.0);
    map2:Array[0..3] Of GLfloat = (0.0, 0.0, 0.0, 0.0);
Begin
    glFrontFace(GL_CW);

    glDepthFunc(GL_LEQUAL);
    glEnable(GL_DEPTH_TEST);

    glLightfv(GL_LIGHT0, GL_AMBIENT, ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
    glLightfv(GL_LIGHT0, GL_POSITION, position);
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, lmodel_ambient);
    glLightModelfv(GL_LIGHT_MODEL_LOCAL_VIEWER, lmodel_localviewer);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);

    glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, mat_shininess);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, mat_specular);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, mat_diffuse);
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, mat_ambient);

    InitFishs;

    glClearColor(0.0, 0.5, 0.9, 0.0);
End;

Procedure Reshape(width,height:LongInt);CDecl;
Begin
    glViewport(0, 0, width, height);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity;
    gluPerspective(400.0, 2.0, 1.0, 2000000.0);
    glMatrixMode(GL_MODELVIEW);
End;

Procedure Animate;CDecl;
Var
   i:LongInt;
Begin
    For i := 0 To NUM_SHARKS-1 Do
    Begin
        SharkPilot(sharks[i]);
        SharkMiss(i);
    End;

    WhalePilot(dolph);
    dolph.phi:=dolph.phi+1;
    glutPostRedisplay;
    WhalePilot(momWhale);
    momWhale.phi:=momWhale.phi+1;
    WhalePilot(babyWhale);
    babyWhale.phi:=babyWhale.phi+1;
End;

Procedure Key(key:Byte;x,y:LongInt);CDecl;
Begin
    Case Key Of
       27:exit;    { Esc will quit }
       32:         { space will advance frame }
       Begin
           If not moving Then Animate;
       End;
    End;
End;

Procedure Display;CDecl;
Var
   i:LongInt;
Begin
    glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT);

    For i := 0 To NUM_SHARKS-1 Do
    Begin
        glPushMatrix;
        FishTransform(sharks[i]);
        DrawShark(sharks[i]);
        glPopMatrix;
    End;

    glPushMatrix;
    FishTransform(dolph);
    DrawDolphin(dolph);
    glPopMatrix;

    glPushMatrix;
    FishTransform(momWhale);
    DrawWhale(momWhale);
    glPopMatrix;

    glPushMatrix;
    FishTransform(babyWhale);
    glScalef(0.45, 0.45, 0.3);
    DrawWhale(babyWhale);
    glPopMatrix;

    glutSwapBuffers;
End;

Procedure Visible(state:LongInt);CDecl;
Begin
    If state = GLUT_VISIBLE Then
    Begin
        If moving Then glutIdleFunc(Animate);
    End
    Else
    Begin
        If moving Then glutIdleFunc(Nil);
    End;
End;

Procedure Select(value:LongInt);CDecl;
Begin
    Case value Of
       1:
       Begin
          moving := GL_TRUE;
          glutIdleFunc(Animate);
       End;
       2:
       Begin
          moving := GL_FALSE;;
          glutIdleFunc(Nil);
       End;
       3:exit;
    End;
End;

Var argc:LongInt;
    argv,c:CString;
    pargv:PChar;
    i : integer;

Begin
    glutInitWindowSize(500, 250);
    argc:=1;
    argv:=ParamStr(0);
    pargv:=@argv;
    glutInit(argc,pargv);
    glutInitDisplayMode(GLUT_RGB); // Or GLUT_DOUBLE Or GLUT_DEPTH);
    c:='GLUT Atlantis Demo'#0;
    i := glutCreateWindow(c);
    Init;
    glutDisplayFunc(Display);
    glutReshapeFunc(Reshape);
    glutKeyboardFunc(Key);
    moving := GL_TRUE;
    glutIdleFunc(Animate);
    glutVisibilityFunc(Visible);
    glutCreateMenu(Select);
    glutAddMenuEntry('Start motion', 1);
    glutAddMenuEntry('Stop motion', 2);
    glutAddMenuEntry('Quit', 3);
    glutAttachMenu(GLUT_RIGHT_BUTTON);
    glutMainLoop;
End.

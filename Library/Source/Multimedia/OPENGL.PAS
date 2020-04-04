
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit OpenGL;

{****************************************************************************
 *                                                                          *
 * Copyright 1991-1993, Silicon Graphics, Inc.                              *
 * Ported to Sibyl by SpeedSoft 1997                                        *
 * All Rights Reserved.                                                     *
 *                                                                          *
 ****************************************************************************}

Interface

Type
    GLenum=LongWord;
    GLboolean=Boolean;
    GLbitfield=LongWord;
    GLbyte=ShortInt;
    GLshort=ShortInt;
    GLint=LongInt;
    GLsizei=LongInt;
    GLubyte=Byte;
    GLushort=Word;
    GLuint=LongWord;
    GLfloat=Single;
    GLclampf=Single;
    GLdouble=Double;
    GLclampd=Double;
    GLvoid=Pointer;

    PGLuByte=^GLubyte;

Const
      GLUT_RGB                        =0;
      GLUT_RGBA                       =GLUT_RGB;
      GLUT_INDEX                      =1;
      GLUT_SINGLE                     =0;
      GLUT_DOUBLE                     =2;
      GLUT_ACCUM                      =4;
      GLUT_ALPHA                      =8;
      GLUT_DEPTH                      =16;
      GLUT_STENCIL                    =32;
      GLUT_MULTISAMPLE                =128;
      GLUT_STEREO                     =256;

      GLUT_LEFT_BUTTON                =0;
      GLUT_MIDDLE_BUTTON              =1;
      GLUT_RIGHT_BUTTON               =2;

      GLUT_DOWN                       =0;
      GLUT_UP                         =1;

      GLUT_KEY_F1                     =1;
      GLUT_KEY_F2                     =2;
      GLUT_KEY_F3                     =3;
      GLUT_KEY_F4                     =4;
      GLUT_KEY_F5                     =5;
      GLUT_KEY_F6                     =6;
      GLUT_KEY_F7                     =7;
      GLUT_KEY_F8                     =8;
      GLUT_KEY_F9                     =9;
      GLUT_KEY_F10                    =10;
      GLUT_KEY_F11                    =11;
      GLUT_KEY_F12                    =12;
      GLUT_KEY_LEFT                   =100;
      GLUT_KEY_UP                     =101;
      GLUT_KEY_RIGHT                  =102;
      GLUT_KEY_DOWN                   =103;
      GLUT_KEY_PAGE_UP                =104;
      GLUT_KEY_PAGE_DOWN              =105;
      GLUT_KEY_HOME                   =106;
      GLUT_KEY_END                    =107;
      GLUT_KEY_INSERT                 =108;

      GLUT_LEFT                       =0;
      GLUT_ENTERED                    =1;

      GLUT_MENU_NOT_IN_USE            =0;
      GLUT_MENU_IN_USE                =1;

      GLUT_NOT_VISIBLE                =0;
      GLUT_VISIBLE                    =1;

      GLUT_RED                        =0;
      GLUT_GREEN                      =1;
      GLUT_BLUE                       =2;

{
/* bitmap font opaque addresses (use constants instead in source code) */
extern void *glutBitmap9By15;
extern void *glutBitmap8By13;
extern void *glutBitmapTimesRoman10;
extern void *glutBitmapTimesRoman24;
extern void *glutStrokeRoman;
extern void *glutStrokeMonoRoman;

/* stroke font constants (use these in GLUT program) */
      GLUT_STROKE_ROMAN               (&glutStrokeRoman)
      GLUT_STROKE_MONO_ROMAN          (&glutStrokeMonoRoman)

      GLUT_BITMAP_9_BY_15             (&glutBitmap9By15)
      GLUT_BITMAP_8_BY_13             (&glutBitmap8By13)
      GLUT_BITMAP_TIMES_ROMAN_10      (&glutBitmapTimesRoman10)
      GLUT_BITMAP_TIMES_ROMAN_24      (&glutBitmapTimesRoman24)
}

Const
      GLUT_WINDOW_X                   =100;
      GLUT_WINDOW_Y                   =101;
      GLUT_WINDOW_WIDTH               =102;
      GLUT_WINDOW_HEIGHT              =103;
      GLUT_WINDOW_BUFFER_SIZE         =104;
      GLUT_WINDOW_STENCIL_SIZE        =105;
      GLUT_WINDOW_DEPTH_SIZE          =106;
      GLUT_WINDOW_RED_SIZE            =107;
      GLUT_WINDOW_GREEN_SIZE          =108;
      GLUT_WINDOW_BLUE_SIZE           =109;
      GLUT_WINDOW_ALPHA_SIZE          =110;
      GLUT_WINDOW_ACCUM_RED_SIZE      =111;
      GLUT_WINDOW_ACCUM_GREEN_SIZE    =112;
      GLUT_WINDOW_ACCUM_BLUE_SIZE     =113;
      GLUT_WINDOW_ACCUM_ALPHA_SIZE    =114;
      GLUT_WINDOW_DOUBLEBUFFER        =115;
      GLUT_WINDOW_RGBA                =116;
      GLUT_WINDOW_PARENT              =117;
      GLUT_WINDOW_NUM_CHILDREN        =118;
      GLUT_WINDOW_COLORMAP_SIZE       =119;
      GLUT_WINDOW_NUM_SAMPLES         =120;
      GLUT_WINDOW_STEREO              =121;
      GLUT_SCREEN_WIDTH               =200;
      GLUT_SCREEN_HEIGHT              =201;
      GLUT_SCREEN_WIDTH_MM            =202;
      GLUT_SCREEN_HEIGHT_MM           =203;
      GLUT_MENU_NUM_ITEMS             =300;
      GLUT_DISPLAY_MODE_POSSIBLE      =400;
      GLUT_INIT_WINDOW_X              =500;
      GLUT_INIT_WINDOW_Y              =501;
      GLUT_INIT_WINDOW_WIDTH          =502;
      GLUT_INIT_WINDOW_HEIGHT         =503;
      GLUT_INIT_DISPLAY_MODE          =504;
      GLUT_ELAPSED_TIME               =700;

      GLUT_HAS_KEYBOARD               =600;
      GLUT_HAS_MOUSE                  =601;
      GLUT_HAS_SPACEBALL              =602;
      GLUT_HAS_DIAL_AND_BUTTON_BOX    =603;
      GLUT_HAS_TABLET                 =604;
      GLUT_NUM_MOUSE_BUTTONS          =605;
      GLUT_NUM_SPACEBALL_BUTTONS      =606;
      GLUT_NUM_BUTTON_BOX_BUTTONS     =607;
      GLUT_NUM_DIALS                  =608;
      GLUT_NUM_TABLET_BUTTONS         =609;

Const
   GLU_FALSE                            =0;
   GLU_TRUE                             =1;

   GLU_VERSION_1_1                      =1;
   GLU_VERSION_1_2                      =1;

   GLU_VERSION                          =100800;
   GLU_EXTENSIONS                       =100801;

   GLU_INVALID_ENUM                     =100900;
   GLU_INVALID_VALUE                    =100901;
   GLU_OUT_OF_MEMORY                    =100902;
   GLU_INCOMPATIBLE_GL_VERSION          =100903;

   GLU_OUTLINE_POLYGON                  =100240;
   GLU_OUTLINE_PATCH                    =100241;

   GLU_ERROR                            =100103;

   GLU_NURBS_ERROR1                     =100251;
   GLU_NURBS_ERROR2                     =100252;
   GLU_NURBS_ERROR3                     =100253;
   GLU_NURBS_ERROR4                     =100254;
   GLU_NURBS_ERROR5                     =100255;
   GLU_NURBS_ERROR6                     =100256;
   GLU_NURBS_ERROR7                     =100257;
   GLU_NURBS_ERROR8                     =100258;
   GLU_NURBS_ERROR9                     =100259;
   GLU_NURBS_ERROR10                    =100260;
   GLU_NURBS_ERROR11                    =100261;
   GLU_NURBS_ERROR12                    =100262;
   GLU_NURBS_ERROR13                    =100263;
   GLU_NURBS_ERROR14                    =100264;
   GLU_NURBS_ERROR15                    =100265;
   GLU_NURBS_ERROR16                    =100266;
   GLU_NURBS_ERROR17                    =100267;
   GLU_NURBS_ERROR18                    =100268;
   GLU_NURBS_ERROR19                    =100269;
   GLU_NURBS_ERROR20                    =100270;
   GLU_NURBS_ERROR21                    =100271;
   GLU_NURBS_ERROR22                    =100272;
   GLU_NURBS_ERROR23                    =100273;
   GLU_NURBS_ERROR24                    =100274;
   GLU_NURBS_ERROR25                    =100275;
   GLU_NURBS_ERROR26                    =100276;
   GLU_NURBS_ERROR27                    =100277;
   GLU_NURBS_ERROR28                    =100278;
   GLU_NURBS_ERROR29                    =100279;
   GLU_NURBS_ERROR30                    =100280;
   GLU_NURBS_ERROR31                    =100281;
   GLU_NURBS_ERROR32                    =100282;
   GLU_NURBS_ERROR33                    =100283;
   GLU_NURBS_ERROR34                    =100284;
   GLU_NURBS_ERROR35                    =100285;
   GLU_NURBS_ERROR36                    =100286;
   GLU_NURBS_ERROR37                    =100287;

   GLU_AUTO_LOAD_MATRIX                 =100200;
   GLU_CULLING                          =100201;
   GLU_SAMPLING_TOLERANCE               =100203;
   GLU_DISPLAY_MODE                     =100204;
   GLU_PARAMETRIC_TOLERANCE             =100202;
   GLU_SAMPLING_METHOD                  =100205;
   GLU_U_STEP                           =100206;
   GLU_V_STEP                           =100207;

   GLU_PATH_LENGTH                      =100215;
   GLU_PARAMETRIC_ERROR                 =100216;
   GLU_DOMAIN_DISTANCE                  =100217;

   GLU_MAP1_TRIM_2                      =100210;
   GLU_MAP1_TRIM_3                      =100211;

   GLU_POINT                            =100010;
   GLU_LINE                             =100011;
   GLU_FILL                             =100012;
   GLU_SILHOUETTE                       =100013;

   GLU_SMOOTH                           =100000;
   GLU_FLAT                             =100001;
   GLU_NONE                             =100002;

   GLU_OUTSIDE                          =100020;
   GLU_INSIDE                           =100021;

   GLU_TESS_BEGIN                       =100100;
   GLU_BEGIN                            =100100;
   GLU_TESS_VERTEX                      =100101;
   GLU_VERTEX                           =100101;
   GLU_TESS_END                         =100102;
   GLU_END                              =100102;
   GLU_TESS_ERROR                       =100103;
   GLU_TESS_EDGE_FLAG                   =100104;
   GLU_EDGE_FLAG                        =100104;
   GLU_TESS_COMBINE                     =100105;
   GLU_TESS_BEGIN_DATA                  =100106;
   GLU_TESS_VERTEX_DATA                 =100107;
   GLU_TESS_END_DATA                    =100108;
   GLU_TESS_ERROR_DATA                  =100109;
   GLU_TESS_EDGE_FLAG_DATA              =100110;
   GLU_TESS_COMBINE_DATA                =100111;

   GLU_CW                               =100120;
   GLU_CCW                              =100121;
   GLU_INTERIOR                         =100122;
   GLU_EXTERIOR                         =100123;
   GLU_UNKNOWN                          =100124;

   GLU_TESS_WINDING_RULE                =100140;
   GLU_TESS_BOUNDARY_ONLY               =100141;
   GLU_TESS_TOLERANCE                   =100142;

   GLU_TESS_ERROR1                      =100151;
   GLU_TESS_ERROR2                      =100152;
   GLU_TESS_ERROR3                      =100153;
   GLU_TESS_ERROR4                      =100154;
   GLU_TESS_ERROR5                      =100155;
   GLU_TESS_ERROR6                      =100156;
   GLU_TESS_ERROR7                      =100157;
   GLU_TESS_ERROR8                      =100158;
   GLU_TESS_MISSING_BEGIN_POLYGON       =100151;
   GLU_TESS_MISSING_BEGIN_CONTOUR       =100152;
   GLU_TESS_MISSING_END_POLYGON         =100153;
   GLU_TESS_MISSING_END_CONTOUR         =100154;
   GLU_TESS_COORD_TOO_LARGE             =100155;
   GLU_TESS_NEED_COMBINE_CALLBACK       =100156;

   GLU_TESS_WINDING_ODD                 =100130;
   GLU_TESS_WINDING_NONZERO             =100131;
   GLU_TESS_WINDING_POSITIVE            =100132;
   GLU_TESS_WINDING_NEGATIVE            =100133;
   GLU_TESS_WINDING_ABS_GEQ_TWO         =100134;


Type GLUnurbs=Record End;
     GLUquadric=Record End;
     GLUtesselator=Record End;

     GLUnurbsObj=GLUnurbs;
     GLUquadricObj=GLUquadric;
     GLUtesselatorObj=GLUtesselator;
     GLUtriangulatorObj=GLUtesselator;

Const
     GLU_TESS_MAX_COORD   =1.0e150;

Const
   AUX_RGB              =0;
   AUX_RGBA             =AUX_RGB;
   AUX_INDEX            =1;
   AUX_SINGLE           =0;
   AUX_DOUBLE           =2;
   AUX_DIRECT           =0;
   AUX_INDIRECT         =4;

   AUX_ACCUM            =8;
   AUX_ALPHA            =16;
   AUX_DEPTH            =32;
   AUX_STENCIL          =64;
   AUX_AUX              =128;

Type AUX_EVENTREC=Record
                        event:GLint;
                        data:Array[0..3] Of GLint;
     End;

Const
    AUX_EXPOSE         = 1;
    AUX_CONFIG         = 2;
    AUX_DRAW           = 4;
    AUX_KEYEVENT       = 8;
    AUX_MOUSEDOWN      = 16;
    AUX_MOUSEUP        = 32;
    AUX_MOUSELOC       = 64;

    AUX_WINDOWX         =0;
    AUX_WINDOWY         =1;
    AUX_MOUSEX          =0;
    AUX_MOUSEY          =1;
    AUX_MOUSESTATUS     =3;
    AUX_KEY             =0;
    AUX_KEYSTATUS       =1;

    AUX_LEFTBUTTON      =1;
    AUX_RIGHTBUTTON     =2;
    AUX_MIDDLEBUTTON    =4;
    AUX_SHIFT           =1;
    AUX_CONTROL         =2;

    AUX_RETURN          =$0D;
    AUX_ESCAPE          =$1B;
    AUX_SPACE           =$20;
    AUX_LEFT            =$25;
    AUX_UP              =$26;
    AUX_RIGHT           =$27;
    AUX_DOWN            =$28;
    AUX_A               ='A';
    AUX_B               ='B';
    AUX_C               ='C';
    AUX_D               ='D';
    AUX_E               ='E';
    AUX_F               ='F';
    AUX_G               ='G';
    AUX_H               ='H';
    AUX_I               ='I';
    AUX_J               ='J';
    AUX_K               ='K';
    AUX_L               ='L';
    AUX_M               ='M';
    AUX_N               ='N';
    AUX_O               ='O';
    AUX_P               ='P';
    AUX_Q               ='Q';
    AUX_R               ='R';
    AUX_S               ='S';
    AUX_T               ='T';
    AUX_U               ='U';
    AUX_V               ='V';
    AUX_W               ='W';
    AUX_X               ='X';
    AUX_Y               ='Y';
    AUX_Z               ='Z';
    AUX__a              ='a';
    AUX__b              ='b';
    AUX__c              ='c';
    AUX__d              ='d';
    AUX__e              ='e';
    AUX__f              ='f';
    AUX__g              ='g';
    AUX__h              ='h';
    AUX__i              ='i';
    AUX__j              ='j';
    AUX__k              ='k';
    AUX__l              ='l';
    AUX__m              ='m';
    AUX__n              ='n';
    AUX__o              ='o';
    AUX__p              ='p';
    AUX__q              ='q';
    AUX__r              ='r';
    AUX__s              ='s';
    AUX__t              ='t';
    AUX__u              ='u';
    AUX__v              ='v';
    AUX__w              ='w';
    AUX__x              ='x';
    AUX__y              ='y';
    AUX__z              ='z';
    AUX_0               ='0';
    AUX_1               ='1';
    AUX_2               ='2';
    AUX_3               ='3';
    AUX_4               ='4';
    AUX_5               ='5';
    AUX_6               ='6';
    AUX_7               ='7';
    AUX_8               ='8';
    AUX_9               ='9';

    AUX_FD              =1;
    AUX_COLORMAP        =3;
    AUX_GREYSCALEMAP    =4;
    AUX_FOGMAP          =5;
    AUX_ONECOLOR        =6;

    AUX_BLACK   = 0;
    AUX_RED     = 1;
    AUX_GREEN   = 2;
    AUX_YELLOW  = 3;
    AUX_BLUE    = 4;
    AUX_MAGENTA = 5;
    AUX_CYAN    = 6;
    AUX_WHITE   = 7;

Var auxRGBMap:Array[0..7,0..2] Of Single;

Type
     PAUX_RGBImageRec=^AUX_RGBImageRec;
     AUX_RGBImageRec=Record
                           sizeX, sizeY:GLint;
                           data:Pointer;
     End;

Const
    AUX_USE_ID            = 1;
    AUX_EXACT_MATCH       = 2;
    AUX_MINIMUM_CRITERIA  = 3;

Const
   GL_ACCUM                          =$0100;
   GL_LOAD                           =$0101;
   GL_RETURN                         =$0102;
   GL_MULT                           =$0103;
   GL_ADD                            =$0104;

   GL_NEVER                          =$0200;
   GL_LESS                           =$0201;
   GL_EQUAL                          =$0202;
   GL_LEQUAL                         =$0203;
   GL_GREATER                        =$0204;
   GL_NOTEQUAL                       =$0205;
   GL_GEQUAL                         =$0206;
   GL_ALWAYS                         =$0207;

   GL_CURRENT_BIT                    =$00000001;
   GL_POINT_BIT                      =$00000002;
   GL_LINE_BIT                       =$00000004;
   GL_POLYGON_BIT                    =$00000008;
   GL_POLYGON_STIPPLE_BIT            =$00000010;
   GL_PIXEL_MODE_BIT                 =$00000020;
   GL_LIGHTING_BIT                   =$00000040;
   GL_FOG_BIT                        =$00000080;
   GL_DEPTH_BUFFER_BIT               =$00000100;
   GL_ACCUM_BUFFER_BIT               =$00000200;
   GL_STENCIL_BUFFER_BIT             =$00000400;
   GL_VIEWPORT_BIT                   =$00000800;
   GL_TRANSFORM_BIT                  =$00001000;
   GL_ENABLE_BIT                     =$00002000;
   GL_COLOR_BUFFER_BIT               =$00004000;
   GL_HINT_BIT                       =$00008000;
   GL_EVAL_BIT                       =$00010000;
   GL_LIST_BIT                       =$00020000;
   GL_TEXTURE_BIT                    =$00040000;
   GL_SCISSOR_BIT                    =$00080000;
   GL_ALL_ATTRIB_BITS                =$000fffff;

   GL_POINTS                         =$0000;
   GL_LINES                          =$0001;
   GL_LINE_LOOP                      =$0002;
   GL_LINE_STRIP                     =$0003;
   GL_TRIANGLES                      =$0004;
   GL_TRIANGLE_STRIP                 =$0005;
   GL_TRIANGLE_FAN                   =$0006;
   GL_QUADS                          =$0007;
   GL_QUAD_STRIP                     =$0008;
   GL_POLYGON                        =$0009;

   GL_ZERO                           =0;
   GL_ONE                            =1;
   GL_SRC_COLOR                      =$0300;
   GL_ONE_MINUS_SRC_COLOR            =$0301;
   GL_SRC_ALPHA                      =$0302;
   GL_ONE_MINUS_SRC_ALPHA            =$0303;
   GL_DST_ALPHA                      =$0304;
   GL_ONE_MINUS_DST_ALPHA            =$0305;

   GL_DST_COLOR                      =$0306;
   GL_ONE_MINUS_DST_COLOR            =$0307;
   GL_SRC_ALPHA_SATURATE             =$0308;

   GL_TRUE                           =True;
   GL_FALSE                          =False;

   GL_CLIP_PLANE0                    =$3000;
   GL_CLIP_PLANE1                    =$3001;
   GL_CLIP_PLANE2                    =$3002;
   GL_CLIP_PLANE3                    =$3003;
   GL_CLIP_PLANE4                    =$3004;
   GL_CLIP_PLANE5                    =$3005;

   GL_NONE                           =0;
   GL_FRONT_LEFT                     =$0400;
   GL_FRONT_RIGHT                    =$0401;
   GL_BACK_LEFT                      =$0402;
   GL_BACK_RIGHT                     =$0403;
   GL_FRONT                          =$0404;
   GL_BACK                           =$0405;
   GL_LEFT                           =$0406;
   GL_RIGHT                          =$0407;
   GL_FRONT_AND_BACK                 =$0408;
   GL_AUX0                           =$0409;
   GL_AUX1                           =$040A;
   GL_AUX2                           =$040B;
   GL_AUX3                           =$040C;

   GL_NO_ERROR                       =0;
   GL_INVALID_ENUM                   =$0500;
   GL_INVALID_VALUE                  =$0501;
   GL_INVALID_OPERATION              =$0502;
   GL_STACK_OVERFLOW                 =$0503;
   GL_STACK_UNDERFLOW                =$0504;
   GL_OUT_OF_MEMORY                  =$0505;

   GL_2D                             =$0600;
   GL_3D                             =$0601;
   GL_3D_COLOR                       =$0602;
   GL_3D_COLOR_TEXTURE               =$0603;
   GL_4D_COLOR_TEXTURE               =$0604;

   GL_PASS_THROUGH_TOKEN             =$0700;
   GL_POINT_TOKEN                    =$0701;
   GL_LINE_TOKEN                     =$0702;
   GL_POLYGON_TOKEN                  =$0703;
   GL_BITMAP_TOKEN                   =$0704;
   GL_DRAW_PIXEL_TOKEN               =$0705;
   GL_COPY_PIXEL_TOKEN               =$0706;
   GL_LINE_RESET_TOKEN               =$0707;

   GL_EXP                            =$0800;
   GL_EXP2                           =$0801;

   GL_CW                             =$0900;
   GL_CCW                            =$0901;

   GL_COEFF                          =$0A00;
   GL_ORDER                          =$0A01;
   GL_DOMAIN                         =$0A02;

   GL_CURRENT_COLOR                  =$0B00;
   GL_CURRENT_INDEX                  =$0B01;
   GL_CURRENT_NORMAL                 =$0B02;
   GL_CURRENT_TEXTURE_COORDS         =$0B03;
   GL_CURRENT_RASTER_COLOR           =$0B04;
   GL_CURRENT_RASTER_INDEX           =$0B05;
   GL_CURRENT_RASTER_TEXTURE_COORDS  =$0B06;
   GL_CURRENT_RASTER_POSITION        =$0B07;
   GL_CURRENT_RASTER_POSITION_VALID  =$0B08;
   GL_CURRENT_RASTER_DISTANCE        =$0B09;
   GL_POINT_SMOOTH                   =$0B10;
   GL_POINT_SIZE                     =$0B11;
   GL_POINT_SIZE_RANGE               =$0B12;
   GL_POINT_SIZE_GRANULARITY         =$0B13;
   GL_LINE_SMOOTH                    =$0B20;
   GL_LINE_WIDTH                     =$0B21;
   GL_LINE_WIDTH_RANGE               =$0B22;
   GL_LINE_WIDTH_GRANULARITY         =$0B23;
   GL_LINE_STIPPLE                   =$0B24;
   GL_LINE_STIPPLE_PATTERN           =$0B25;
   GL_LINE_STIPPLE_REPEAT            =$0B26;
   GL_LIST_MODE                      =$0B30;
   GL_MAX_LIST_NESTING               =$0B31;
   GL_LIST_BASE                      =$0B32;
   GL_LIST_INDEX                     =$0B33;
   GL_POLYGON_MODE                   =$0B40;
   GL_POLYGON_SMOOTH                 =$0B41;
   GL_POLYGON_STIPPLE                =$0B42;
   GL_EDGE_FLAG                      =$0B43;
   GL_CULL_FACE                      =$0B44;
   GL_CULL_FACE_MODE                 =$0B45;
   GL_FRONT_FACE                     =$0B46;
   GL_LIGHTING                       =$0B50;
   GL_LIGHT_MODEL_LOCAL_VIEWER       =$0B51;
   GL_LIGHT_MODEL_TWO_SIDE           =$0B52;
   GL_LIGHT_MODEL_AMBIENT            =$0B53;
   GL_SHADE_MODEL                    =$0B54;
   GL_COLOR_MATERIAL_FACE            =$0B55;
   GL_COLOR_MATERIAL_PARAMETER       =$0B56;
   GL_COLOR_MATERIAL                 =$0B57;
   GL_FOG                            =$0B60;
   GL_FOG_INDEX                      =$0B61;
   GL_FOG_DENSITY                    =$0B62;
   GL_FOG_START                      =$0B63;
   GL_FOG_END                        =$0B64;
   GL_FOG_MODE                       =$0B65;
   GL_FOG_COLOR                      =$0B66;
   GL_DEPTH_RANGE                    =$0B70;
   GL_DEPTH_TEST                     =$0B71;
   GL_DEPTH_WRITEMASK                =$0B72;
   GL_DEPTH_CLEAR_VALUE              =$0B73;
   GL_DEPTH_FUNC                     =$0B74;
   GL_ACCUM_CLEAR_VALUE              =$0B80;
   GL_STENCIL_TEST                   =$0B90;
   GL_STENCIL_CLEAR_VALUE            =$0B91;
   GL_STENCIL_FUNC                   =$0B92;
   GL_STENCIL_VALUE_MASK             =$0B93;
   GL_STENCIL_FAIL                   =$0B94;
   GL_STENCIL_PASS_DEPTH_FAIL        =$0B95;
   GL_STENCIL_PASS_DEPTH_PASS        =$0B96;
   GL_STENCIL_REF                    =$0B97;
   GL_STENCIL_WRITEMASK              =$0B98;
   GL_MATRIX_MODE                    =$0BA0;
   GL_NORMALIZE                      =$0BA1;
   GL_VIEWPORT                       =$0BA2;
   GL_MODELVIEW_STACK_DEPTH          =$0BA3;
   GL_PROJECTION_STACK_DEPTH         =$0BA4;
   GL_TEXTURE_STACK_DEPTH            =$0BA5;
   GL_MODELVIEW_MATRIX               =$0BA6;
   GL_PROJECTION_MATRIX              =$0BA7;
   GL_TEXTURE_MATRIX                 =$0BA8;
   GL_ATTRIB_STACK_DEPTH             =$0BB0;
   GL_ALPHA_TEST                     =$0BC0;
   GL_ALPHA_TEST_FUNC                =$0BC1;
   GL_ALPHA_TEST_REF                 =$0BC2;
   GL_DITHER                         =$0BD0;
   GL_BLEND_DST                      =$0BE0;
   GL_BLEND_SRC                      =$0BE1;
   GL_BLEND                          =$0BE2;
   GL_LOGIC_OP_MODE                  =$0BF0;
   GL_LOGIC_OP                       =$0BF1;
   GL_AUX_BUFFERS                    =$0C00;
   GL_DRAW_BUFFER                    =$0C01;
   GL_READ_BUFFER                    =$0C02;
   GL_SCISSOR_BOX                    =$0C10;
   GL_SCISSOR_TEST                   =$0C11;
   GL_INDEX_CLEAR_VALUE              =$0C20;
   GL_INDEX_WRITEMASK                =$0C21;
   GL_COLOR_CLEAR_VALUE              =$0C22;
   GL_COLOR_WRITEMASK                =$0C23;
   GL_INDEX_MODE                     =$0C30;
   GL_RGBA_MODE                      =$0C31;
   GL_DOUBLEBUFFER                   =$0C32;
   GL_STEREO                         =$0C33;
   GL_RENDER_MODE                    =$0C40;
   GL_PERSPECTIVE_CORRECTION_HINT    =$0C50;
   GL_POINT_SMOOTH_HINT              =$0C51;
   GL_LINE_SMOOTH_HINT               =$0C52;
   GL_POLYGON_SMOOTH_HINT            =$0C53;
   GL_FOG_HINT                       =$0C54;

   GL_TEXTURE_GEN_S                  =$0C60;
   GL_TEXTURE_GEN_T                  =$0C61;
   GL_TEXTURE_GEN_R                  =$0C62;
   GL_TEXTURE_GEN_Q                  =$0C63;
   GL_PIXEL_MAP_I_TO_I               =$0C70;
   GL_PIXEL_MAP_S_TO_S               =$0C71;
   GL_PIXEL_MAP_I_TO_R               =$0C72;
   GL_PIXEL_MAP_I_TO_G               =$0C73;
   GL_PIXEL_MAP_I_TO_B               =$0C74;
   GL_PIXEL_MAP_I_TO_A               =$0C75;
   GL_PIXEL_MAP_R_TO_R               =$0C76;
   GL_PIXEL_MAP_G_TO_G               =$0C77;
   GL_PIXEL_MAP_B_TO_B               =$0C78;
   GL_PIXEL_MAP_A_TO_A               =$0C79;
   GL_PIXEL_MAP_I_TO_I_SIZE          =$0CB0;
   GL_PIXEL_MAP_S_TO_S_SIZE          =$0CB1;
   GL_PIXEL_MAP_I_TO_R_SIZE          =$0CB2;
   GL_PIXEL_MAP_I_TO_G_SIZE          =$0CB3;
   GL_PIXEL_MAP_I_TO_B_SIZE          =$0CB4;
   GL_PIXEL_MAP_I_TO_A_SIZE          =$0CB5;
   GL_PIXEL_MAP_R_TO_R_SIZE          =$0CB6;
   GL_PIXEL_MAP_G_TO_G_SIZE          =$0CB7;
   GL_PIXEL_MAP_B_TO_B_SIZE          =$0CB8;
   GL_PIXEL_MAP_A_TO_A_SIZE          =$0CB9;
   GL_UNPACK_SWAP_BYTES              =$0CF0;
   GL_UNPACK_LSB_FIRST               =$0CF1;
   GL_UNPACK_ROW_LENGTH              =$0CF2;
   GL_UNPACK_SKIP_ROWS               =$0CF3;
   GL_UNPACK_SKIP_PIXELS             =$0CF4;
   GL_UNPACK_ALIGNMENT               =$0CF5;
   GL_PACK_SWAP_BYTES                =$0D00;
   GL_PACK_LSB_FIRST                 =$0D01;
   GL_PACK_ROW_LENGTH                =$0D02;
   GL_PACK_SKIP_ROWS                 =$0D03;
   GL_PACK_SKIP_PIXELS               =$0D04;
   GL_PACK_ALIGNMENT                 =$0D05;
   GL_MAP_COLOR                      =$0D10;
   GL_MAP_STENCIL                    =$0D11;
   GL_INDEX_SHIFT                    =$0D12;
   GL_INDEX_OFFSET                   =$0D13;
   GL_RED_SCALE                      =$0D14;
   GL_RED_BIAS                       =$0D15;
   GL_ZOOM_X                         =$0D16;
   GL_ZOOM_Y                         =$0D17;
   GL_GREEN_SCALE                    =$0D18;
   GL_GREEN_BIAS                     =$0D19;
   GL_BLUE_SCALE                     =$0D1A;
   GL_BLUE_BIAS                      =$0D1B;
   GL_ALPHA_SCALE                    =$0D1C;
   GL_ALPHA_BIAS                     =$0D1D;
   GL_DEPTH_SCALE                    =$0D1E;
   GL_DEPTH_BIAS                     =$0D1F;
   GL_MAX_EVAL_ORDER                 =$0D30;
   GL_MAX_LIGHTS                     =$0D31;
   GL_MAX_CLIP_PLANES                =$0D32;
   GL_MAX_TEXTURE_SIZE               =$0D33;
   GL_MAX_PIXEL_MAP_TABLE            =$0D34;
   GL_MAX_ATTRIB_STACK_DEPTH         =$0D35;
   GL_MAX_MODELVIEW_STACK_DEPTH      =$0D36;
   GL_MAX_NAME_STACK_DEPTH           =$0D37;
   GL_MAX_PROJECTION_STACK_DEPTH     =$0D38;
   GL_MAX_TEXTURE_STACK_DEPTH        =$0D39;
   GL_MAX_VIEWPORT_DIMS              =$0D3A;
   GL_SUBPIXEL_BITS                  =$0D50;
   GL_INDEX_BITS                     =$0D51;
   GL_RED_BITS                       =$0D52;
   GL_GREEN_BITS                     =$0D53;
   GL_BLUE_BITS                      =$0D54;
   GL_ALPHA_BITS                     =$0D55;
   GL_DEPTH_BITS                     =$0D56;
   GL_STENCIL_BITS                   =$0D57;
   GL_ACCUM_RED_BITS                 =$0D58;
   GL_ACCUM_GREEN_BITS               =$0D59;
   GL_ACCUM_BLUE_BITS                =$0D5A;
   GL_ACCUM_ALPHA_BITS               =$0D5B;
   GL_NAME_STACK_DEPTH               =$0D70;
   GL_AUTO_NORMAL                    =$0D80;
   GL_MAP1_COLOR_4                   =$0D90;
   GL_MAP1_INDEX                     =$0D91;
   GL_MAP1_NORMAL                    =$0D92;
   GL_MAP1_TEXTURE_COORD_1           =$0D93;
   GL_MAP1_TEXTURE_COORD_2           =$0D94;
   GL_MAP1_TEXTURE_COORD_3           =$0D95;
   GL_MAP1_TEXTURE_COORD_4           =$0D96;
   GL_MAP1_VERTEX_3                  =$0D97;
   GL_MAP1_VERTEX_4                  =$0D98;
   GL_MAP2_COLOR_4                   =$0DB0;
   GL_MAP2_INDEX                     =$0DB1;
   GL_MAP2_NORMAL                    =$0DB2;
   GL_MAP2_TEXTURE_COORD_1           =$0DB3;
   GL_MAP2_TEXTURE_COORD_2           =$0DB4;
   GL_MAP2_TEXTURE_COORD_3           =$0DB5;
   GL_MAP2_TEXTURE_COORD_4           =$0DB6;
   GL_MAP2_VERTEX_3                  =$0DB7;
   GL_MAP2_VERTEX_4                  =$0DB8;
   GL_MAP1_GRID_DOMAIN               =$0DD0;
   GL_MAP1_GRID_SEGMENTS             =$0DD1;
   GL_MAP2_GRID_DOMAIN               =$0DD2;
   GL_MAP2_GRID_SEGMENTS             =$0DD3;
   GL_TEXTURE_1D                     =$0DE0;
   GL_TEXTURE_2D                     =$0DE1;

   GL_TEXTURE_WIDTH                  =$1000;
   GL_TEXTURE_HEIGHT                 =$1001;
   GL_TEXTURE_COMPONENTS             =$1003;
   GL_TEXTURE_BORDER_COLOR           =$1004;
   GL_TEXTURE_BORDER                 =$1005;

   GL_DONT_CARE                      =$1100;
   GL_FASTEST                        =$1101;
   GL_NICEST                         =$1102;

   GL_LIGHT0                         =$4000;
   GL_LIGHT1                         =$4001;
   GL_LIGHT2                         =$4002;
   GL_LIGHT3                         =$4003;
   GL_LIGHT4                         =$4004;
   GL_LIGHT5                         =$4005;
   GL_LIGHT6                         =$4006;
   GL_LIGHT7                         =$4007;

   GL_AMBIENT                        =$1200;
   GL_DIFFUSE                        =$1201;
   GL_SPECULAR                       =$1202;
   GL_POSITION                       =$1203;
   GL_SPOT_DIRECTION                 =$1204;
   GL_SPOT_EXPONENT                  =$1205;
   GL_SPOT_CUTOFF                    =$1206;
   GL_CONSTANT_ATTENUATION           =$1207;
   GL_LINEAR_ATTENUATION             =$1208;
   GL_QUADRATIC_ATTENUATION          =$1209;

   GL_COMPILE                        =$1300;
   GL_COMPILE_AND_EXECUTE            =$1301;

   GL_BYTE                           =$1400;
   GL_UNSIGNED_BYTE                  =$1401;
   GL_SHORT                          =$1402;
   GL_UNSIGNED_SHORT                 =$1403;
   GL_INT                            =$1404;
   GL_UNSIGNED_INT                   =$1405;
   GL_FLOAT                          =$1406;
   GL_2_BYTES                        =$1407;
   GL_3_BYTES                        =$1408;
   GL_4_BYTES                        =$1409;
   GL_DOUBLE_EXT                     =$140A;

   GL_CLEAR                          =$1500;
   GL_AND                            =$1501;
   GL_AND_REVERSE                    =$1502;
   GL_COPY                           =$1503;
   GL_AND_INVERTED                   =$1504;
   GL_NOOP                           =$1505;
   GL_XOR                            =$1506;
   GL_OR                             =$1507;
   GL_NOR                            =$1508;
   GL_EQUIV                          =$1509;
   GL_INVERT                         =$150A;
   GL_OR_REVERSE                     =$150B;
   GL_COPY_INVERTED                  =$150C;
   GL_OR_INVERTED                    =$150D;
   GL_NAND                           =$150E;
   GL_SET                            =$150F;

   GL_EMISSION                       =$1600;
   GL_SHININESS                      =$1601;
   GL_AMBIENT_AND_DIFFUSE            =$1602;
   GL_COLOR_INDEXES                  =$1603;

   GL_MODELVIEW                      =$1700;
   GL_PROJECTION                     =$1701;
   GL_TEXTURE                        =$1702;

   GL_COLOR                          =$1800;
   GL_DEPTH                          =$1801;
   GL_STENCIL                        =$1802;

   GL_COLOR_INDEX                    =$1900;
   GL_STENCIL_INDEX                  =$1901;
   GL_DEPTH_COMPONENT                =$1902;
   GL_RED                            =$1903;
   GL_GREEN                          =$1904;
   GL_BLUE                           =$1905;
   GL_ALPHA                          =$1906;
   GL_RGB                            =$1907;
   GL_RGBA                           =$1908;
   GL_LUMINANCE                      =$1909;
   GL_LUMINANCE_ALPHA                =$190A;

   GL_BITMAP                         =$1A00;

   GL_POINT                          =$1B00;
   GL_LINE                           =$1B01;
   GL_FILL                           =$1B02;

   GL_RENDER                         =$1C00;
   GL_FEEDBACK                       =$1C01;
   GL_SELECT                         =$1C02;

   GL_FLAT                           =$1D00;
   GL_SMOOTH                         =$1D01;

   GL_KEEP                           =$1E00;
   GL_REPLACE                        =$1E01;
   GL_INCR                           =$1E02;
   GL_DECR                           =$1E03;

   GL_VENDOR                         =$1F00;
   GL_RENDERER                       =$1F01;
   GL_VERSION                        =$1F02;
   GL_EXTENSIONS                     =$1F03;

   GL_S                              =$2000;
   GL_T                              =$2001;
   GL_R                              =$2002;
   GL_Q                              =$2003;

   GL_MODULATE                       =$2100;
   GL_DECAL                          =$2101;

   GL_TEXTURE_ENV_MODE               =$2200;
   GL_TEXTURE_ENV_COLOR              =$2201;

   GL_TEXTURE_ENV                    =$2300;

   GL_EYE_LINEAR                     =$2400;
   GL_OBJECT_LINEAR                  =$2401;
   GL_SPHERE_MAP                     =$2402;

   GL_TEXTURE_GEN_MODE               =$2500;
   GL_OBJECT_PLANE                   =$2501;
   GL_EYE_PLANE                      =$2502;

   GL_NEAREST                        =$2600;
   GL_LINEAR                         =$2601;

   GL_NEAREST_MIPMAP_NEAREST         =$2700;
   GL_LINEAR_MIPMAP_NEAREST          =$2701;
   GL_NEAREST_MIPMAP_LINEAR          =$2702;
   GL_LINEAR_MIPMAP_LINEAR           =$2703;

   GL_TEXTURE_MAG_FILTER             =$2800;
   GL_TEXTURE_MIN_FILTER             =$2801;
   GL_TEXTURE_WRAP_S                 =$2802;
   GL_TEXTURE_WRAP_T                 =$2803;

   GL_CLAMP                          =$2900;
   GL_REPEAT                         =$2901;

   GL_EXT_abgr                       =1;
   GL_EXT_blend_logic_op             =1;
   GL_EXT_blend_minmax               =1;
   GL_EXT_blend_subtract             =1;
   GL_EXT_polygon_offset             =1;
   GL_EXT_rescale_normal             =1;
   GL_EXT_subtexture                 =1;
   GL_EXT_texture_object             =1;
   GL_EXT_vertex_array               =1;

   GL_ABGR_EXT                       =$8000;

   GL_FUNC_ADD_EXT                   =$8006;
   GL_MIN_EXT                        =$8007;
   GL_MAX_EXT                        =$8008;
   GL_BLEND_EQUATION_EXT             =$8009;

   GL_FUNC_SUBTRACT_EXT              =$800A;
   GL_FUNC_REVERSE_SUBTRACT_EXT      =$800B;

   GL_POLYGON_OFFSET_EXT             =$8037;
   GL_POLYGON_OFFSET_FACTOR_EXT      =$8038;
   GL_POLYGON_OFFSET_BIAS_EXT        =$8039;

   GL_RESCALE_NORMAL_EXT             =$803A;

   GL_TEXTURE_PRIORITY_EXT           =$8066;
   GL_TEXTURE_RESIDENT_EXT           =$8067;
   GL_TEXTURE_1D_BINDING_EXT         =$8068;
   GL_TEXTURE_2D_BINDING_EXT         =$8069;

   GL_VERTEX_ARRAY_EXT               =$8074;
   GL_NORMAL_ARRAY_EXT               =$8075;
   GL_COLOR_ARRAY_EXT                =$8076;
   GL_INDEX_ARRAY_EXT                =$8077;
   GL_TEXTURE_COORD_ARRAY_EXT        =$8078;
   GL_EDGE_FLAG_ARRAY_EXT            =$8079;
   GL_VERTEX_ARRAY_SIZE_EXT          =$807A;
   GL_VERTEX_ARRAY_TYPE_EXT          =$807B;
   GL_VERTEX_ARRAY_STRIDE_EXT        =$807C;
   GL_VERTEX_ARRAY_COUNT_EXT         =$807D;
   GL_NORMAL_ARRAY_TYPE_EXT          =$807E;
   GL_NORMAL_ARRAY_STRIDE_EXT        =$807F;
   GL_NORMAL_ARRAY_COUNT_EXT         =$8080;
   GL_COLOR_ARRAY_SIZE_EXT           =$8081;
   GL_COLOR_ARRAY_TYPE_EXT           =$8082;
   GL_COLOR_ARRAY_STRIDE_EXT         =$8083;
   GL_COLOR_ARRAY_COUNT_EXT          =$8084;
   GL_INDEX_ARRAY_TYPE_EXT           =$8085;
   GL_INDEX_ARRAY_STRIDE_EXT         =$8086;
   GL_INDEX_ARRAY_COUNT_EXT          =$8087;
   GL_TEXTURE_COORD_ARRAY_SIZE_EXT   =$8088;
   GL_TEXTURE_COORD_ARRAY_TYPE_EXT   =$8089;
   GL_TEXTURE_COORD_ARRAY_STRIDE_EXT =$808A;
   GL_TEXTURE_COORD_ARRAY_COUNT_EXT  =$808B;
   GL_EDGE_FLAG_ARRAY_STRIDE_EXT     =$808C;
   GL_EDGE_FLAG_ARRAY_COUNT_EXT      =$808D;
   GL_VERTEX_ARRAY_POINTER_EXT       =$808E;
   GL_NORMAL_ARRAY_POINTER_EXT       =$808F;
   GL_COLOR_ARRAY_POINTER_EXT        =$8090;
   GL_INDEX_ARRAY_POINTER_EXT        =$8091;
   GL_TEXTURE_COORD_ARRAY_POINTER_EXT=$8092;
   GL_EDGE_FLAG_ARRAY_POINTER_EXT    =$8093;

Type
    auxproc1=Procedure;CDecl;
    auxproc2=Procedure(w,h:GLsizei);CDecl;
    auxfunc1=Function(i:LongInt;e:GLenum):GLenum;CDecl;
    auxfunc2=Function(x,y:LongInt;e:GLEnum):GLenum;CDecl;
    auxproc3=Procedure(Var e:AUX_EVENTREC);CDecl;
    glutproc1=Procedure(x,y:LongInt);CDecl;
    glutproc2=Procedure(c:Byte;x,y:LongInt);CDecl;
    glutproc3=Procedure(x,y,w,h:LongInt);CDecl;
    glutproc4=Procedure(x:LongInt);CDecl;

Imports
    Procedure glAccum (op:GLenum;value:GLfloat);ApiEntry; 'OPENGL' name 'glAccum';
    Procedure glAlphaFunc (func:GLenum;ref:GLclampf);ApiEntry; 'OPENGL' name 'glAlphaFunc';
    Function glAreTexturesResidentEXT (n:GLsizei;Var textures;
                                       Var residences:GLboolean):GLboolean;ApiEntry; 'OPENGL' name 'glAreTexturesResidentEXT';
    Procedure glArrayElementEXT (i:GLint);ApiEntry; 'OPENGL' name 'glArrayElementEXT';
    Procedure glBegin (mode:GLenum);ApiEntry; 'OPENGL' name 'glBegin';
    Procedure glBindTextureEXT (target:GLenum;texture:GLuint);ApiEntry; 'OPENGL' name 'glBindTextureEXT';
    Procedure glBitmap (width,height:GLsizei;xorig,yorig:GLfloat;
                        xmove,ymove:GLfloat;Var Bitmap);ApiEntry; 'OPENGL' name 'glBitmap';
    Procedure glBlendEquationEXT (mode:GLenum);ApiEntry; 'OPENGL' name 'glBlendEquationEXT';
    Procedure glBlendFunc (sfactor,dfactor:GLenum);ApiEntry; 'OPENGL' name 'glBlendFunc';
    Procedure glCallList (list:GLuint);ApiEntry; 'OPENGL' name 'glCallList';
    Procedure glCallLists (n:GLsizei;typ:GLenum;Const Lists);ApiEntry; 'OPENGL' name 'glCallLists';
    Procedure glClear (mask:GLbitfield);ApiEntry; 'OPENGL' name 'glClear';
    Procedure glClearAccum (read,green,blue:GLfloat;alpha:GLfloat);ApiEntry; 'OPENGL' name 'glClearAccum';
    Procedure glClearColor (red,green,blue:GLclampf;alpha:GLclampf);ApiEntry; 'OPENGL' name 'glClearColor';
    Procedure glClearDepth (depth:GLclampd);ApiEntry; 'OPENGL' name 'glClearDepth';
    Procedure glClearIndex (c:GLfloat);ApiEntry; 'OPENGL' name 'glClearIndex';
    Procedure glClearStencil (s:GLint);ApiEntry; 'OPENGL' name 'glClearStencil';
    Procedure glClipPlane (plane:GLenum;Const equation:GLdouble);ApiEntry; 'OPENGL' name 'glClipPlane';
    Procedure glColor3b (red,green,blue:GLbyte);ApiEntry; 'OPENGL' name 'glColor3b';
    Procedure glColor3bv (Const v);ApiEntry; 'OPENGL' name 'glColor3bv';
    Procedure glColor3d (red,green,blue:GLdouble);ApiEntry; 'OPENGL' name 'glColor3d';
    Procedure glColor3dv (Const v);ApiEntry; 'OPENGL' name 'glColor3dv';
    Procedure glColor3f (red,green,blue:GLfloat);ApiEntry; 'OPENGL' name 'glColor3f';
    Procedure glColor3fv (Const v);ApiEntry; 'OPENGL' name 'glColor3fv';
    Procedure glColor3i (red,green,blue:GLint);ApiEntry; 'OPENGL' name 'glColor3i';
    Procedure glColor3iv (Const v);ApiEntry; 'OPENGL' name 'glColor3iv';
    Procedure glColor3s (red,green,blue:GLshort);ApiEntry; 'OPENGL' name 'glColor3s';
    Procedure glColor3sv (Const v);ApiEntry; 'OPENGL' name 'glColor3sv';
    Procedure glColor3ub (red,green,blue:GLubyte);ApiEntry; 'OPENGL' name 'glColor3ub';
    Procedure glColor3ubv (Const v);ApiEntry; 'OPENGL' name 'glColor3ubv';
    Procedure glColor3ui (red,green,blue:GLuint);ApiEntry; 'OPENGL' name 'glColor3ui';
    Procedure glColor3uiv (Const v);ApiEntry; 'OPENGL' name 'glColor3uiv';
    Procedure glColor3us (red,green,blue:GLushort);ApiEntry; 'OPENGL' name 'glColor3us';
    Procedure glColor3usv (Const v);ApiEntry; 'OPENGL' name 'glColor3us';
    Procedure glColor4b (red,green,blue,alpha:GLbyte);ApiEntry; 'OPENGL' name 'glColor4b';
    Procedure glColor4bv (Const v);ApiEntry; 'OPENGL' name 'glColor4bv';
    Procedure glColor4d (red,green,blue,alpha:GLdouble);ApiEntry; 'OPENGL' name 'glColor4d';
    Procedure glColor4dv (Const v);ApiEntry; 'OPENGL' name 'glColor4dv';
    Procedure glColor4f (red,green,blue,alpha:GLfloat);ApiEntry; 'OPENGL' name 'glColor4f';
    Procedure glColor4fv (Const v);ApiEntry; 'OPENGL' name 'glColor4fv';
    Procedure glColor4i (red,green,blue,alpha:GLint);ApiEntry; 'OPENGL' name 'glColor4i';
    Procedure glColor4iv (Const v);ApiEntry; 'OPENGL' name 'glColor4iv';
    Procedure glColor4s (red,green,blue,alpha:GLshort);ApiEntry; 'OPENGL' name 'glColor4s';
    Procedure glColor4sv (Const v);ApiEntry; 'OPENGL' name 'glColor4sv';
    Procedure glColor4ub (red,green,blue,alpha:GLubyte);ApiEntry; 'OPENGL' name 'glColor4ub';
    Procedure glColor4ubv (Const v);ApiEntry; 'OPENGL' name 'glColor4ubv';
    Procedure glColor4ui (red,green,blue,alpha:GLuint);ApiEntry; 'OPENGL' name 'glColor4ui';
    Procedure glColor4uiv (Const v);ApiEntry; 'OPENGL' name 'glColor4uiv';
    Procedure glColor4us (red,green,blue,alpha:GLushort);ApiEntry; 'OPENGL' name 'glColor4us';
    Procedure glColor4usv (Const v);ApiEntry; 'OPENGL' name 'glColor4usv';
    Procedure glColorMask (red,green,blue,alpha:GLboolean);ApiEntry; 'OPENGL' name 'glColorMask';
    Procedure glColorMaterial (face,mode:GLenum);ApiEntry; 'OPENGL' name 'glColorMaterial';
    Procedure glColorPointerEXT (size:GLint;typ:GLenum;stride:GLsizei;
                                 count:GLsizei;Const Buf);ApiEntry; 'OPENGL' name 'glColorPointerEXT';
    Procedure glCopyPixels (x,y:GLint;width,height:GLsizei;typ:GLenum);ApiEntry; 'OPENGL' name 'glCopyPixels';
    Procedure glCullFace (mode:GLenum);ApiEntry; 'OPENGL' name 'glCullFace';
    Procedure glDeleteLists (list:GLuint;range:GLsizei);ApiEntry; 'OPENGL' name 'glDeleteLists';
    Procedure glDeleteTexturesEXT (n:GLsizei;Const textures);ApiEntry; 'OPENGL' name 'glDeleteTexturesEXT';
    Procedure glDepthFunc (func:GLenum);ApiEntry; 'OPENGL' name 'glDepthFunc';
    Procedure glDepthMask (flag:GLboolean);ApiEntry; 'OPENGL' name 'glDepthMask';
    Procedure glDepthRange (near,far:GLclampd);ApiEntry; 'OPENGL' name 'glDepthRange';
    Procedure glDisable (cap:GLenum);ApiEntry; 'OPENGL' name 'glDisable';
    Procedure glDrawArraysEXT (mode:GLenum;first:GLint;count:GLsizei);ApiEntry; 'OPENGL' name 'glDrawArraysEXT';
    Procedure glDrawBuffer (mode:GLenum);ApiEntry; 'OPENGL' name 'glDrawBuffer';
    Procedure glDrawPixels (width,height:GLsizei;format,typ:GLenum;Const pixels); 'OPENGL' name 'glDrawPixels';
    Procedure glEdgeFlag (flag:GLboolean);ApiEntry; 'OPENGL' name 'glEdgeFlag';
    Procedure glEdgeFlagPointerEXT (stride:GLsizei;count:GLsizei;Const Buf);ApiEntry; 'OPENGL' name 'glEdgeFlagPointerEXT';
    Procedure glEdgeFlagv (Const Flag);ApiEntry; 'OPENGL' name 'glEdgeFlagv';
    Procedure glEnable (cap:GLenum);ApiEntry; 'OPENGL' name 'glEnable';
    Procedure glEnd;ApiEntry; 'OPENGL' name 'glEnd';
    Procedure glEndList;ApiEntry; 'OPENGL' name 'glEndList';
    Procedure glEvalCoord1d (u:GLdouble);ApiEntry; 'OPENGL' name 'glEvalCoord1d';
    Procedure glEvalCoord1dv (Const u);ApiEntry; 'OPENGL' name 'glEvalCoord1dv';
    Procedure glEvalCoord1f (u:GLfloat);ApiEntry; 'OPENGL' name 'glEvalCoord1f';
    Procedure glEvalCoord1fv (Const u);ApiEntry; 'OPENGL' name 'glEvalCoord1fv';
    Procedure glEvalCoord2d (u,v:GLdouble);ApiEntry; 'OPENGL' name 'glEvalCoord2d';
    Procedure glEvalCoord2dv (Const u);ApiEntry; 'OPENGL' name 'glEvalCoord2dv';
    Procedure glEvalCoord2f (u,v:GLfloat);ApiEntry; 'OPENGL' name 'glEvalCoord2f';
    Procedure glEvalCoord2fv (Const u);ApiEntry; 'OPENGL' name 'glEvalCoord2fv';
    Procedure glEvalMesh1 (mode:GLenum;i1,i2:GLint);ApiEntry; 'OPENGL' name 'glEvalMesh1';
    Procedure glEvalMesh2 (mode:GLenum;i1,i2,j1,j2:GLint);ApiEntry; 'OPENGL' name 'glEvalMesh1';
    Procedure glEvalPoint1 (i:GLint);ApiEntry; 'OPENGL' name 'glEvalPoint1';
    Procedure glEvalPoint2 (i,j:GLint);ApiEntry; 'OPENGL' name 'glEvalPoint2';
    Procedure glFeedbackBuffer (size:GLsizei;typ:GLenum;Var buffer);ApiEntry; 'OPENGL' name 'glFeedbackBuffer';
    Procedure glFinish;ApiEntry; 'OPENGL' name 'glFinish';
    Procedure glFlush;ApiEntry; 'OPENGL' name 'glFlush';
    Procedure glFogf (pname:GLenum;param:GLfloat);ApiEntry; 'OPENGL' name 'glFogf';
    Procedure glFogfv (pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glFogfv';
    Procedure glFogi (pname:GLenum;param:GLint);ApiEntry; 'OPENGL' name 'glFogi';
    Procedure glFogiv (pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glFogiv';
    Procedure glFrontFace (mode:GLenum);ApiEntry; 'OPENGL' name 'glFrontFace';
    Procedure glFrustum (left,right,bottom,top,near,far:GLdouble);ApiEntry; 'OPENGL' name 'glFrustum';
    Function glGenLists (range:GLsizei):GLuint;ApiEntry; 'OPENGL' name 'glGenLists';
    Procedure glGenTexturesEXT (n:GLsizei;Var textures);ApiEntry; 'OPENGL' name 'glGenTexturesEXT';
    Procedure glGetBooleanv (pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetBooleanv';
    Procedure glGetClipPlane (plane:GLenum;Var equation:GLdouble);ApiEntry; 'OPENGL' name 'glGetClipPlane';
    Procedure glGetDoublev (pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetDoublev';
    Function glGetError:GLenum;ApiEntry; 'OPENGL' name 'glGetError';
    Procedure glGetFloatv (pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetFloatv';
    Procedure glGetIntegerv (pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetIntegerv';
    Procedure glGetLightfv (light,pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetLightfv';
    Procedure glGetLightiv (light,pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetLightiv';
    Procedure glGetMapdv (target,query:GLenum;Var v);ApiEntry; 'OPENGL' name 'glGetMapdv';
    Procedure glGetMapfv (target,query:GLenum;Var v);ApiEntry; 'OPENGL' name 'glGetMapfv';
    Procedure glGetMapiv (target,query:GLenum;Var v);ApiEntry; 'OPENGL' name 'glGetMapiv';
    Procedure glGetMaterialfv (face,pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetMaterialfv';
    Procedure glGetMaterialiv (face,pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetMaterialiv';
    Procedure glGetPixelMapfv (map:GLenum;Var values);ApiEntry; 'OPENGL' name 'glGetPixelMapfv';
    Procedure glGetPixelMapuiv (map:GLenum;Var values);ApiEntry; 'OPENGL' name 'glGetPixelMapuiv';
    Procedure glGetPixelMapusv (map:GLenum;Var values);ApiEntry; 'OPENGL' name 'glGetPixelMapusv';
    Procedure glGetPointervEXT (pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetPointervEXT';
    Procedure glGetPolygonStipple (Var mask:GLubyte);ApiEntry; 'OPENGL' name 'glGetPolygonStipple';
    Function  glGetString (name:GLenum):PGLubyte;ApiEntry; 'OPENGL' name 'glGetString';
    Procedure glGetTexEnvfv (target,pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetTexEnvfv';
    Procedure glGetTexEnviv (target,pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetTexEnviv';
    Procedure glGetTexGendv (coord,pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetTexGendv';
    Procedure glGetTexGenfv (coord,pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetTexGenfv';
    Procedure glGetTexGeniv (coord,pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetTexGeniv';
    Procedure glGetTexImage (target:GLenum;level:GLint;format:GLenum;
                             typ:GLenum;Var pixels);ApiEntry; 'OPENGL' name 'glGetTexImage';
    Procedure glGetTexLevelParameterfv (target:GLenum;level:GLint;pname:GLenum;
                                        Var params);ApiEntry; 'OPENGL' name 'glGetTexLevelParameterfv';
    Procedure glGetTexLevelParameteriv (target:GLenum;level:GLint;pname:GLenum;
                                        Var params);ApiEntry; 'OPENGL' name 'glGetTexLevelParameteriv';
    Procedure glGetTexParameterfv (target:GLenum;pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetTexParameterfv';
    Procedure glGetTexParameteriv (target:GLenum;pname:GLenum;Var params);ApiEntry; 'OPENGL' name 'glGetTexParameteriv';
    Procedure glHint (target,mode:GLenum);ApiEntry; 'OPENGL' name 'glHint';
    Procedure glIndexMask (mask:GLuint);ApiEntry; 'OPENGL' name 'glIndexMask';
    Procedure glIndexPointerEXT (typ:GLenum;stride,count:GLsizei;Const Buf);ApiEntry; 'OPENGL' name 'glIndexPointerEXT';
    Procedure glIndexd (c:GLdouble);ApiEntry; 'OPENGL' name 'glIndexd';
    Procedure glIndexdv (Const c);ApiEntry; 'OPENGL' name 'glIndexdv';
    Procedure glIndexf (c:GLfloat);ApiEntry; 'OPENGL' name 'glIndexf';
    Procedure glIndexfv (Const c);ApiEntry; 'OPENGL' name 'glIndexfv';
    Procedure glIndexi (c:GLint);ApiEntry; 'OPENGL' name 'glIndexi';
    Procedure glIndexiv (Const c);ApiEntry; 'OPENGL' name 'glIndexiv';
    Procedure glIndexs (c:GLshort);ApiEntry; 'OPENGL' name 'glIndexs';
    Procedure glIndexsv (Const c);ApiEntry; 'OPENGL' name 'glIndexsv';
    Procedure glInitNames;ApiEntry; 'OPENGL' name 'glInitNames';
    Function glIsEnabled (cap:GLenum):GLboolean;ApiEntry; 'OPENGL' name 'glIsEnabled';
    Function glIsList (list:GLuint):GLboolean;ApiEntry; 'OPENGL' name 'glIsList';
    Function glIsTextureEXT (texture:GLuint):GLboolean;ApiEntry; 'OPENGL' name 'glIsTextureEXT';
    Procedure glLightModelf (pname:GLenum;param:GLfloat);ApiEntry; 'OPENGL' name 'glLightModelf';
    Procedure glLightModelfv (pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glLightModelfv';
    Procedure glLightModeli (pname:GLenum;param:GLint);ApiEntry; 'OPENGL' name 'glLightModeli';
    Procedure glLightModeliv (pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glLightModeliv';
    Procedure glLightf (light,pname:GLenum;param:GLfloat);ApiEntry; 'OPENGL' name 'glLightf';
    Procedure glLightfv (light,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glLightfv';
    Procedure glLighti (light,pname:GLenum;param:GLint);ApiEntry; 'OPENGL' name 'glLighti';
    Procedure glLightiv (light,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glLightiv';
    Procedure glLineStipple (factor:GLint;pattern:GLushort);ApiEntry; 'OPENGL' name 'glLineStipple';
    Procedure glLineWidth (width:GLfloat);ApiEntry; 'OPENGL' name 'glLineWidth';
    Procedure glListBase (base:GLuint);ApiEntry; 'OPENGL' name 'glListBase';
    Procedure glLoadIdentity;ApiEntry; 'OPENGL' name 'glLoadIdentity';
    Procedure glLoadMatrixd (Const m);ApiEntry; 'OPENGL' name 'glLoadMatrixd';
    Procedure glLoadMatrixf (Const m);ApiEntry; 'OPENGL' name 'glLoadMatrixf';
    Procedure glLoadName (name:GLuint);ApiEntry; 'OPENGL' name 'glLoadName';
    Procedure glLogicOp (opcode:GLenum);ApiEntry; 'OPENGL' name 'glLogicOp';
    Procedure glMap1d (target:GLenum;u1,u2:GLdouble;stride,order:GLint;
                       Const points);ApiEntry; 'OPENGL' name 'glMap1d';
    Procedure glMap1f (target:GLenum;u1,u2:GLfloat;stride,order:GLint;
                       Const points);ApiEntry; 'OPENGL' name 'glMap1f';
    Procedure glMap2d (target:GLenum;u1,u2:GLdouble;ustride,uorder:GLint;
                       v1,v2:GLdouble;vstride,vorder:GLint;Const points);ApiEntry; 'OPENGL' name 'glMap2d';
    Procedure glMap2f (target:GLenum;u1,u2:GLfloat;ustride,uorder:GLint;
                       v1,v2:GLfloat;vstride,vorder:GLint;Const points);ApiEntry; 'OPENGL' name 'glMap2f';
    Procedure glMapGrid1d (un:GLint;u1,u2:GLdouble);ApiEntry; 'OPENGL' name 'glMapGrid1d';
    Procedure glMapGrid1f (un:GLint;u1,u2:GLfloat);ApiEntry; 'OPENGL' name 'glMapGrid1f';
    Procedure glMapGrid2d (un:GLint;u1,u2:GLdouble;vn:GLint;v1,v2:GLdouble);ApiEntry; 'OPENGL' name 'glMapGrid2d';
    Procedure glMapGrid2f (un:GLint;u1,u2:GLfloat;vn:GLint;v1,v2:GLfloat);ApiEntry; 'OPENGL' name 'glMapGrid2f';
    Procedure glMaterialf (face,pname:GLenum;param:GLfloat);ApiEntry; 'OPENGL' name 'glMaterialf';
    Procedure glMaterialfv (face,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glMaterialfv';
    Procedure glMateriali (face,pname:GLenum;param:GLint);ApiEntry; 'OPENGL' name 'glMateriali';
    Procedure glMaterialiv (face,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glMaterialiv';
    Procedure glMatrixMode (mode:GLenum);ApiEntry; 'OPENGL' name 'glMatrixMode';
    Procedure glMultMatrixd (Const m);ApiEntry; 'OPENGL' name 'glMultMatrixd';
    Procedure glMultMatrixf (Const m);ApiEntry; 'OPENGL' name 'glMultMatrixf';
    Procedure glNewList (list:GLuint;mode:GLenum);ApiEntry; 'OPENGL' name 'glNewList';
    Procedure glNormal3b (nx,ny,nz:GLbyte);ApiEntry; 'OPENGL' name 'glNormal3b';
    Procedure glNormal3bv (Const v);ApiEntry; 'OPENGL' name 'glNormal3bv';
    Procedure glNormal3d (nx,ny,nz:GLdouble);ApiEntry; 'OPENGL' name 'glNormal3d';
    Procedure glNormal3dv (Const v);ApiEntry; 'OPENGL' name 'glNormal3dv';
    Procedure glNormal3f (nx,ny,nz:GLfloat);ApiEntry; 'OPENGL' name 'glNormal3f';
    Procedure glNormal3fv (Const v);ApiEntry; 'OPENGL' name 'glNormal3fv';
    Procedure glNormal3i (nx,ny,nz:GLint);ApiEntry; 'OPENGL' name 'glNormal3i';
    Procedure glNormal3iv (Const v);ApiEntry; 'OPENGL' name 'glNormal3iv';
    Procedure glNormal3s (nx,ny,nz:GLshort);ApiEntry; 'OPENGL' name 'glNormal3s';
    Procedure glNormal3sv (Const v);ApiEntry; 'OPENGL' name 'glNormal3sv';
    Procedure glNormalPointerEXT (typ:GLenum;stride,count:GLsizei;Const Buf);ApiEntry; 'OPENGL' name 'glNormalPointerEXT';
    Procedure glOrtho (left,right,bottom,top,near,far:GLdouble);ApiEntry; 'OPENGL' name 'glOrtho';
    Procedure glPassThrough (token:GLfloat);ApiEntry; 'OPENGL' name 'glPassThrough';
    Procedure glPixelMapfv (map:GLenum;mapsize:GLsizei;Const values);ApiEntry; 'OPENGL' name 'glPixelMapfv';
    Procedure glPixelMapuiv (map:GLenum;mapsize:GLsizei;Const values);ApiEntry; 'OPENGL' name 'glPixelMapuiv';
    Procedure glPixelMapusv (map:GLenum;mapsize:GLsizei;Const values);ApiEntry; 'OPENGL' name 'glPixelMapusv';
    Procedure glPixelStoref (pname:GLenum;param:GLfloat);ApiEntry; 'OPENGL' name 'glPixelStoref';
    Procedure glPixelStorei (pname:GLenum;param:GLint);ApiEntry; 'OPENGL' name 'glPixelStorei';
    Procedure glPixelTransferf (pname:GLenum;param:GLfloat);ApiEntry; 'OPENGL' name 'glPixelTransferf';
    Procedure glPixelTransferi (pname:GLenum;param:GLint);ApiEntry; 'OPENGL' name 'glPixelTransferi';
    Procedure glPixelZoom (xfactor,yfactor:GLfloat);ApiEntry; 'OPENGL' name 'glPixelZoom';
    Procedure glPointSize (size:GLfloat);ApiEntry; 'OPENGL' name 'glPointSize';
    Procedure glPolygonMode (face,mode:GLenum);ApiEntry; 'OPENGL' name 'glPolygonMode';
    Procedure glPolygonOffsetEXT (factor,bias:GLfloat);ApiEntry; 'OPENGL' name 'glPolygonOffsetEXT';
    Procedure glPolygonStipple (Const mask);ApiEntry; 'OPENGL' name 'glPolygonStipple';
    Procedure glPopAttrib;ApiEntry; 'OPENGL' name 'glPopAttrib';
    Procedure glPopMatrix;ApiEntry; 'OPENGL' name 'glPopMatrix';
    Procedure glPopName;ApiEntry; 'OPENGL' name 'glPopName';
    Procedure glPrioritizeTexturesEXT (n:GLsizei;Const textures;Const priorities);ApiEntry; 'OPENGL' name 'glPrioritizeTexturesEXT';
    Procedure glPushAttrib (mask:GLbitfield);ApiEntry; 'OPENGL' name 'glPushAttrib';
    Procedure glPushMatrix;ApiEntry; 'OPENGL' name 'glPushMatrix';
    Procedure glPushName (name:GLuint);ApiEntry; 'OPENGL' name 'glPushName';
    Procedure glRasterPos2d (x,y:GLdouble);ApiEntry; 'OPENGL' name 'glRasterPos2d';
    Procedure glRasterPos2dv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos2dv';
    Procedure glRasterPos2f (x,y:GLfloat);ApiEntry; 'OPENGL' name 'glRasterPos2f';
    Procedure glRasterPos2fv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos2fv';
    Procedure glRasterPos2i (x,y:GLint);ApiEntry; 'OPENGL' name 'glRasterPos2i';
    Procedure glRasterPos2iv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos2iv';
    Procedure glRasterPos2s (x,y:GLshort);ApiEntry; 'OPENGL' name 'glRasterPos2s';
    Procedure glRasterPos2sv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos2sv';
    Procedure glRasterPos3d (x,y,z:GLdouble);ApiEntry; 'OPENGL' name 'glRasterPos3d';
    Procedure glRasterPos3dv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos3dv';
    Procedure glRasterPos3f (x,y,z:GLfloat);ApiEntry; 'OPENGL' name 'glRasterPos3f';
    Procedure glRasterPos3fv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos3fv';
    Procedure glRasterPos3i (x,y,z:GLint);ApiEntry; 'OPENGL' name 'glRasterPos3i';
    Procedure glRasterPos3iv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos3iv';
    Procedure glRasterPos3s (x,y,z:GLshort);ApiEntry; 'OPENGL' name 'glRasterPos3s';
    Procedure glRasterPos3sv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos3sv';
    Procedure glRasterPos4d (x,y,z,w:GLdouble);ApiEntry; 'OPENGL' name 'glRasterPos4d';
    Procedure glRasterPos4dv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos4dv';
    Procedure glRasterPos4f (x,y,z,w:GLfloat);ApiEntry; 'OPENGL' name 'glRasterPos4f';
    Procedure glRasterPos4fv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos4fv';
    Procedure glRasterPos4i (x,y,z,w:GLint);ApiEntry; 'OPENGL' name 'glRasterPos4i';
    Procedure glRasterPos4iv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos4iv';
    Procedure glRasterPos4s (x,y,z,w:GLshort);ApiEntry; 'OPENGL' name 'glRasterPos4s';
    Procedure glRasterPos4sv (Const v);ApiEntry; 'OPENGL' name 'glRasterPos4sv';
    Procedure glReadBuffer (mode:GLenum);ApiEntry; 'OPENGL' name 'glReadBuffer';
    Procedure glReadPixels (x,y:GLint;width,height:GLsizei;
                            format,typ:GLenum;Var pixels);ApiEntry; 'OPENGL' name 'glReadPixels';
    Procedure glRectd (x1,y1,x2,y2:GLdouble);ApiEntry; 'OPENGL' name 'glRectd';
    Procedure glRectdv (Const v1;Const v2);ApiEntry; 'OPENGL' name 'glRectdv';
    Procedure glRectf (x1,y1,x2,y2:GLfloat);ApiEntry; 'OPENGL' name 'glRectf';
    Procedure glRectfv (Const v1;Const v2);ApiEntry; 'OPENGL' name 'glRectfv';
    Procedure glRecti (x1,y1,x2,y2:GLint);ApiEntry; 'OPENGL' name 'glRecti';
    Procedure glRectiv (Const v1;Const v2);ApiEntry; 'OPENGL' name 'glRectiv';
    Procedure glRects (x1,y1,x2,y2:GLshort);ApiEntry; 'OPENGL' name 'glRects';
    Procedure glRectsv (Const v1;Const v2);ApiEntry; 'OPENGL' name 'glRectsv';
    Function glRenderMode (mode:GLenum):GLint;ApiEntry; 'OPENGL' name 'glRenderMode';
    Procedure glRotated (angle,x,y,z:GLdouble);ApiEntry; 'OPENGL' name 'glRotated';
    Procedure glRotatef (angle,x,y,z:GLfloat);ApiEntry; 'OPENGL' name 'glRotatef';
    Procedure glScaled (x,y,z:GLdouble);ApiEntry; 'OPENGL' name 'glScaled';
    Procedure glScalef (x,y,z:GLfloat);ApiEntry; 'OPENGL' name 'glScalef';
    Procedure glScissor (x,y:GLint;width,height:GLsizei);ApiEntry; 'OPENGL' name 'glScissor';
    Procedure glSelectBuffer (size:GLsizei;Var buffer);ApiEntry; 'OPENGL' name 'glSelectBuffer';
    Procedure glShadeModel (mode:GLenum);ApiEntry; 'OPENGL' name 'glShadeModel';
    Procedure glStencilFunc (func:GLenum;ref:GLint;mask:GLuint);ApiEntry; 'OPENGL' name 'glStencilFunc';
    Procedure glStencilMask (mask:GLuint);ApiEntry; 'OPENGL' name 'glStencilMask';
    Procedure glStencilOp (fail,zfail,zpass:GLenum);ApiEntry; 'OPENGL' name 'glStencilOp';
    Procedure glTexCoord1d (s:GLdouble);ApiEntry; 'OPENGL' name 'glTexCoord1d';
    Procedure glTexCoord1dv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord1dv';
    Procedure glTexCoord1f (s:GLfloat);ApiEntry; 'OPENGL' name 'glTexCoord1f';
    Procedure glTexCoord1fv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord1fv';
    Procedure glTexCoord1i (s:GLint);ApiEntry; 'OPENGL' name 'glTexCoord1i';
    Procedure glTexCoord1iv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord1iv';
    Procedure glTexCoord1s (s:GLshort);ApiEntry; 'OPENGL' name 'glTexCoord1s';
    Procedure glTexCoord1sv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord1sv';
    Procedure glTexCoord2d (s,t:GLdouble);ApiEntry; 'OPENGL' name 'glTexCoord2d';
    Procedure glTexCoord2dv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord2dv';
    Procedure glTexCoord2f (s,t:GLfloat);ApiEntry; 'OPENGL' name 'glTexCoord2f';
    Procedure glTexCoord2fv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord2fv';
    Procedure glTexCoord2i (s,t:GLint);ApiEntry; 'OPENGL' name 'glTexCoord2i';
    Procedure glTexCoord2iv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord2iv';
    Procedure glTexCoord2s (s,t:GLshort);ApiEntry; 'OPENGL' name 'glTexCoord2s';
    Procedure glTexCoord2sv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord2sv';
    Procedure glTexCoord3d (s,t,r:GLdouble);ApiEntry; 'OPENGL' name 'glTexCoord3d';
    Procedure glTexCoord3dv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord3dv';
    Procedure glTexCoord3f (s,t,r:GLfloat);ApiEntry; 'OPENGL' name 'glTexCoord3f';
    Procedure glTexCoord3fv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord3fv';
    Procedure glTexCoord3i (s,t,r:GLint);ApiEntry; 'OPENGL' name 'glTexCoord3i';
    Procedure glTexCoord3iv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord3iv';
    Procedure glTexCoord3s (s,t,r:GLshort);ApiEntry; 'OPENGL' name 'glTexCoord3s';
    Procedure glTexCoord3sv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord3sv';
    Procedure glTexCoord4d (s,t,r,q:GLdouble);ApiEntry; 'OPENGL' name 'glTexCoord4d';
    Procedure glTexCoord4dv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord4dv';
    Procedure glTexCoord4f (s,t,r,q:GLfloat);ApiEntry; 'OPENGL' name 'glTexCoord4f';
    Procedure glTexCoord4fv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord4fv';
    Procedure glTexCoord4i (s,t,r,q:GLint);ApiEntry; 'OPENGL' name 'glTexCoord4i';
    Procedure glTexCoord4iv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord4iv';
    Procedure glTexCoord4s (s,t,r,q:GLshort);ApiEntry; 'OPENGL' name 'glTexCoord4s';
    Procedure glTexCoord4sv (Const v);ApiEntry; 'OPENGL' name 'glTexCoord4sv';
    Procedure glTexCoordPointerEXT (size:GLint;typ:GLenum;stride,count:GLsizei;
                                    Const Buf);ApiEntry; 'OPENGL' name 'glTexCoordPointerEXT';
    Procedure glTexEnvf (target,pname:GLenum;param:GLfloat);ApiEntry; 'OPENGL' name 'glTexEnvf';
    Procedure glTexEnvfv (target,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glTexEnvfv';
    Procedure glTexEnvi (target,pname:GLenum;param:GLint);ApiEntry; 'OPENGL' name 'glTexEnvi';
    Procedure glTexEnviv (target,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glTexEnviv';
    Procedure glTexGend (coord,pname:GLenum;param:GLdouble);ApiEntry; 'OPENGL' name 'glTexGend';
    Procedure glTexGendv (coord,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glTexGendv';
    Procedure glTexGenf (coord,pname:GLenum;param:GLfloat);ApiEntry; 'OPENGL' name 'glTexGenf';
    Procedure glTexGenfv (coord,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glTexGenfv';
    Procedure glTexGeni (coord,pname:GLenum;param:GLint);ApiEntry; 'OPENGL' name 'glTexGeni';
    Procedure glTexGeniv (coord,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glTexGeniv';
    Procedure glTexImage1D (target:GLenum;level,components:GLint;
                            width:GLsizei;border:GLint;format:GLenum;
                            typ:GLenum;Const pixels);ApiEntry; 'OPENGL' name 'glTexImage1D';
    Procedure glTexImage2D (target:GLenum;level,components:GLint;
                            width,height:GLsizei;border:GLint;
                            format,typ:GLenum;Const pixels);ApiEntry; 'OPENGL' name 'glTexImage2D';
    Procedure glTexParameterf (target,pname:GLenum;param:GLfloat);ApiEntry; 'OPENGL' name 'glTexParameterf';
    Procedure glTexParameterfv (target,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glTexParameterfv';
    Procedure glTexParameteri (target,pname:GLenum;param:GLint);ApiEntry; 'OPENGL' name 'glTexParameteri';
    Procedure glTexParameteriv (target,pname:GLenum;Const params);ApiEntry; 'OPENGL' name 'glTexParameteriv';
    Procedure glTexSubImage1DEXT (target:GLenum;level,xoffset:GLint;
                                  width:GLsizei;format,typ:GLenum;Const pixels);ApiEntry; 'OPENGL' name 'glTexSubImage1DEXT';
    Procedure glTexSubImage2DEXT (target:GLenum;level,xoffset,yoffset:GLint;
                                  width,height:GLsizei;format,typ:GLenum;
                                  Const pixels);ApiEntry; 'OPENGL' name 'glTexSubImage2DEXT';
    Procedure glTranslated (x,y,z:GLdouble);ApiEntry; 'OPENGL' name 'glTranslated';
    Procedure glTranslatef (x,y,z:GLfloat);ApiEntry; 'OPENGL' name 'glTranslatef';
    Procedure glVertex2d (x,y:GLdouble);ApiEntry; 'OPENGL' name 'glVertex2d';
    Procedure glVertex2dv (Const v);ApiEntry; 'OPENGL' name 'glVertex2dv';
    Procedure glVertex2f (x,y:GLfloat);ApiEntry; 'OPENGL' name 'glVertex2f';
    Procedure glVertex2fv (Const v);ApiEntry; 'OPENGL' name 'glVertex2fv';
    Procedure glVertex2i (x,y:GLint);ApiEntry; 'OPENGL' name 'glVertex2i';
    Procedure glVertex2iv (Const v);ApiEntry; 'OPENGL' name 'glVertex2iv';
    Procedure glVertex2s (x,y:GLshort);ApiEntry; 'OPENGL' name 'glVertex2s';
    Procedure glVertex2sv (Const v);ApiEntry; 'OPENGL' name 'glVertex2sv';
    Procedure glVertex3d (x,y,z:GLdouble);ApiEntry; 'OPENGL' name 'glVertex3d';
    Procedure glVertex3dv (Const v);ApiEntry; 'OPENGL' name 'glVertex3dv';
    Procedure glVertex3f (x,y,z:GLfloat);ApiEntry; 'OPENGL' name 'glVertex3f';
    Procedure glVertex3fv (Const v);ApiEntry; 'OPENGL' name 'glVertex3fv';
    Procedure glVertex3i (x,y,z:GLint);ApiEntry; 'OPENGL' name 'glVertex3i';
    Procedure glVertex3iv (Const v);ApiEntry; 'OPENGL' name 'glVertex3iv';
    Procedure glVertex3s (x,y,z:GLshort);ApiEntry; 'OPENGL' name 'glVertex3s';
    Procedure glVertex3sv (Const v);ApiEntry; 'OPENGL' name 'glVertex3sv';
    Procedure glVertex4d (x,y,z,w:GLdouble);ApiEntry; 'OPENGL' name 'glVertex4d';
    Procedure glVertex4dv (Const v);ApiEntry; 'OPENGL' name 'glVertex4dv';
    Procedure glVertex4f (x,y,z,w:GLfloat);ApiEntry; 'OPENGL' name 'glVertex4f';
    Procedure glVertex4fv (Const v);ApiEntry; 'OPENGL' name 'glVertex4fv';
    Procedure glVertex4i (x,y,z,w:GLint);ApiEntry; 'OPENGL' name 'glVertex4i';
    Procedure glVertex4iv (Const v);ApiEntry; 'OPENGL' name 'glVertex4iv';
    Procedure glVertex4s (x,y,z,w:GLshort);ApiEntry; 'OPENGL' name 'glVertex4s';
    Procedure glVertex4sv (Const v);ApiEntry; 'OPENGL' name 'glVertex4sv';
    Procedure glVertexPointerEXT (size:GLint;typ:GLenum;stride,count:GLsizei;
                                  Const Buf);ApiEntry; 'OPENGL' name 'glVertexPointerEXT';
    Procedure glViewport (x,y:GLint;width,height:GLsizei);ApiEntry; 'OPENGL' name 'glViewport';

    Procedure auxInitDisplayMode(mode:GLenum);ApiEntry; 'LIBAUX' name 'auxInitDisplayMode';
    Procedure auxInitPosition(x,y,w,h:LongInt);ApiEntry;'LIBAUX' name 'auxInitPosition';
    Function auxInitWindow(Const t:CString):GLenum;ApiEntry; 'LIBAUX' name 'auxInitWindow';
    Procedure auxCloseWindow;ApiEntry; 'LIBAUX' name 'auxCloseWindow';
    Procedure auxQuit;ApiEntry; 'LIBAUX' name 'auxQuit';
    Procedure auxClipBoard;ApiEntry; 'LIBAUX' name 'auxClipBoard';
    Procedure auxSwapBuffers;ApiEntry; 'LIBAUX' name 'auxSwapBuffers';

    Procedure gluBeginCurve (Var nurb);ApiEntry; 'OPENGL' name 'gluBeginCurve';
    Procedure gluBeginPolygon (Var tess);ApiEntry; 'OPENGL' name 'gluBeginPolygon';
    Procedure gluBeginSurface (Var nurb);ApiEntry; 'OPENGL' name 'gluBeginSurface';
    Procedure gluBeginTrim (Var nurb);ApiEntry; 'OPENGL' name 'gluBeginTrim';
    Function gluBuild1DMipmaps (target:GLenum;component:GLint;
                                width:GLsizei;format,typ:GLenum;
                                Const data):GLint;ApiEntry; 'OPENGL' name 'gluBuild1DMipmaps';
    Function gluBuild2DMipmaps (target:GLenum;component:GLint;
                                width,height:GLsizei;format,typ:GLenum;
                                Const data):GLint;ApiEntry; 'OPENGL' name 'gluBuild2DMipmaps';
    Procedure gluCylinder (Var quad;base,top,height:GLdouble;slices:GLint;
                           stacks:GLint);ApiEntry; 'OPENGL' name 'gluCylinder';
    Procedure gluDeleteNurbsRenderer (Var nurb);ApiEntry; 'OPENGL' name 'gluDeleteNurbsRenderer';
    Procedure gluDeleteQuadric (Var quad);ApiEntry; 'OPENGL' name 'gluDeleteQuadric';
    Procedure gluDeleteTess (Var tess);ApiEntry; 'OPENGL' name 'gluDeleteTess';
    Procedure gluDisk (Var quad;inner,outer:GLdouble;slices,loops:GLint);ApiEntry; 'OPENGL' name 'gluDisk';
    Procedure gluEndCurve (Var nurb);ApiEntry; 'OPENGL' name 'gluEndCurve';
    Procedure gluEndPolygon (Var tess);ApiEntry; 'OPENGL' name 'gluEndPolygon';
    Procedure gluEndSurface (Var nurb);ApiEntry; 'OPENGL' name 'gluEndSurface';
    Procedure gluEndTrim (Var nurb);ApiEntry; 'OPENGL' name 'gluEndTrim';
    Function gluErrorString (error:GLenum):PChar;ApiEntry; 'OPENGL' name 'gluErrorString';
    Procedure gluGetNurbsProperty (Var nurb;property:GLenum;Var data);ApiEntry; 'OPENGL' name 'gluGetNurbsProperty';
    Function gluGetString (name:GLenum):PChar;ApiEntry; 'OPENGL' name 'gluGetString';
    Procedure gluGetTessProperty (Var tess;which:GLenum;Var data);ApiEntry; 'OPENGL' name 'gluGetTessProperty';
    Procedure gluLoadSamplingMatrices (Var nurb;Const model;Const perspective;
                                       Const view);ApiEntry; 'OPENGL' name 'gluLoadSamplingMatrices';
    Procedure gluLookAt (eyeX,eyeY,eyeZ,centerX,centerY,centerZ:GLdouble;
                         upX,upY,upZ:GLdouble);ApiEntry; 'OPENGL' name 'gluLookAt';
    Function gluNewNurbsRenderer:Pointer;ApiEntry; 'OPENGL' name 'gluNewNurbsRenderer';
    Function gluNewQuadric:Pointer;ApiEntry; 'OPENGL' name 'gluNewQuadric';
    Function gluNewTess:Pointer;ApiEntry; 'OPENGL' name 'gluNewTess';
    Procedure gluNextContour (Var tess;typ:GLenum);ApiEntry; 'OPENGL' name 'gluNextContour';
    Procedure gluNurbsCallback (Var nurb;which:GLenum;
                                CallBackFunc:auxproc1);ApiEntry; 'OPENGL' name 'gluNurbsCallback';
    Procedure gluNurbsCurve (Var nurb;knotCount:GLint;Var knots;
                             stride:GLint;Var control;order:GLint;
                             typ:GLenum);ApiEntry; 'OPENGL' name 'gluNurbsCurve';
    Procedure gluNurbsProperty (Var nurb;property:GLenum;value:GLfloat);ApiEntry; 'OPENGL' name 'gluNurbsProperty';
    Procedure gluNurbsSurface (Var nurb;sKnotCount:GLint;Var sKnots;
                               tKnotCount:GLint;Var tKnots;sStride:GLint;
                               tStride:GLint;Var control;
                               sOrder,tOrder:GLint;typ:GLenum);ApiEntry; 'OPENGL' name 'gluNurbsSurface';
    Procedure gluOrtho2D (left,right,bottom,top:GLdouble);ApiEntry; 'OPENGL' name 'gluOrtho2D';
    Procedure gluPartialDisk (Var quad;inner,outer:GLdouble;slices:GLint;
                              loops:GLint;start,sweep:GLdouble);ApiEntry; 'OPENGL' name 'gluPartialDisk';
    Procedure gluPerspective (fovy,aspect,near,far:GLdouble);ApiEntry; 'OPENGL' name 'gluPerspective';
    Procedure gluPickMatrix (x,y,delx,dely:GLdouble;Var viewport);ApiEntry; 'OPENGL' name 'gluPickMatrix';
    Function gluProject (objX,objY,objZ:GLdouble;Const model;Const proj;
                         Const view;Var winX;Var WinY;Var WinZ):GLint;ApiEntry; 'OPENGL' name 'gluProject';
    Procedure gluPwlCurve (Var nurb;count:GLint;Var data;stride:GLint;
                           typ:GLenum);ApiEntry; 'OPENGL' name 'gluPwlCurve';
    Procedure gluQuadricCallback (Var quad;which:GLenum;CallBackFunc:auxproc1);ApiEntry; 'OPENGL' name 'gluQuadricCallback';
    Procedure gluQuadricDrawStyle (Var quad;draw:GLenum);ApiEntry; 'OPENGL' name 'gluQuadricDrawStyle';
    Procedure gluQuadricNormals (Var quad;normal:GLenum);ApiEntry; 'OPENGL' name 'gluQuadricNormals';
    Procedure gluQuadricOrientation (Var quad;orientation:GLenum);ApiEntry; 'OPENGL' name 'gluQuadricOrientation';
    Procedure gluQuadricTexture (Var quad;texture:GLboolean);ApiEntry; 'OPENGL' name 'gluQuadricTexture';
    Function gluScaleImage (format:GLenum;wIn,hIn:GLsizei;typeIn:GLenum;
                            Const dataIn;wOut,hOut:GLsizei;typeOut:GLenum;
                            Var dataOut):GLint;ApiEntry; 'OPENGL' name 'gluScaleImage';
    Procedure gluSphere (Var quad;radius:GLdouble;slices,stacks:GLint);ApiEntry; 'OPENGL' name 'gluSphere';
    Procedure gluTessBeginContour (Var tess);ApiEntry; 'OPENGL' name 'gluTessBeginContour';
    Procedure gluTessBeginPolygon (Var tess;Var data);ApiEntry; 'OPENGL' name 'gluTessBeginPolygon';
    Procedure gluTessCallback (Var tess;which:GLenum;CallBackFunc:auxproc1);ApiEntry; 'OPENGL' name 'gluTessCallback';
    Procedure gluTessEndContour (Var tess);ApiEntry; 'OPENGL' name 'gluTessEndContour';
    Procedure gluTessEndPolygon (Var tess);ApiEntry; 'OPENGL' name 'gluTessEndPolygon';
    Procedure gluTessNormal (Var tess;valueX,valueY,valueZ:GLdouble);ApiEntry; 'OPENGL' name 'gluTessNormal';
    Procedure gluTessProperty (Var tess;which:GLenum;data:GLdouble);ApiEntry; 'OPENGL' name 'gluTessProperty';
    Procedure gluTessVertex (Var tess;Var location;Var data);ApiEntry; 'OPENGL' name 'gluTessVertex';
    Function gluUnProject (winX,winY,winZ:GLdouble;Const model;Const proj;
                           Const view;Var objX;Var objY;Var objZ):GLint;ApiEntry; 'OPENGL' name 'gluUnProject';

    Procedure auxMainLoop(f:auxproc1);ApiEntry; 'LIBAUX' name 'auxMainLoop';
    Procedure auxExposeFunc(f:auxproc2);ApiEntry; 'LIBAUX' name 'auxExposeFunc';
    Procedure auxReshapeFunc(f:auxproc2);ApiEntry; 'LIBAUX' name 'auxReshapeFunc';
    Procedure auxIdleFunc(f:auxproc1);ApiEntry; 'LIBAUX' name 'auxIdleFunc';
    Procedure auxKeyFunc(i:LongInt;f:auxproc1);ApiEntry; 'LIBAUX' name 'auxKeyFunc';
    Procedure auxKeyDownFunc(f:auxfunc1);ApiEntry; 'LIBAUX' name 'auxKeyDownFunc';
    Procedure auxMouseFunc(x,y:LongInt;f:auxproc3);ApiEntry; 'LIBAUX' name 'auxMouseFunc';
    Procedure auxMouseDownFunc(f:auxfunc2);ApiEntry; 'LIBAUX' name 'auxMouseDownFunc';
    Procedure auxMouseUpFunc(f:auxfunc2);ApiEntry; 'LIBAUX' name 'auxMouseUpFunc';
    Procedure auxMouseMoveFunc(f:auxfunc2);ApiEntry; 'LIBAUX' name 'auxMouseMoveFunc';
    Function auxGetColorMapSize:GLint;ApiEntry; 'LIBAUX' name 'auxGetColorMapSize';
    Procedure auxGetMouseLoc(Var x,y:LongInt);ApiEntry; 'LIBAUX' name 'auxGetMouseLoc';
    Procedure auxSetOneColor(i:LongInt;r,g,b:Single);ApiEntry; 'LIBAUX' name 'auxSetOneColor';
    Procedure auxSetFogRamp(i1,i2:LongInt);ApiEntry; 'LIBAUX' name 'auxSetFogRamp';
    Procedure auxSetGreyRamp;ApiEntry; 'LIBAUX' name 'auxSetGreyRamp';
    Procedure auxSetRGBMap(c:LongInt;Var Buf);ApiEntry; 'LIBAUX' name 'auxSetRGBMap';
    Function auxRGBImageLoad(c:PChar):PAUX_RGBImageRec; 'LIBAUX'name 'auxRGBImageLoad';
    Procedure auxCreateFont;ApiEntry; 'LIBAUX' name 'auxCreateFont';
    Procedure auxDrawStr(Const s:CString);ApiEntry; 'LIBAUX' name 'auxDrawStr';
    Procedure auxWireSphere(d:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireSphere';
    Procedure auxSolidSphere(d:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidSphere';
    Procedure auxWireCube(c:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireCube';
    Procedure auxSolidCube(c:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidCube';
    Procedure auxWireBox(a,b,c:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireBox';
    Procedure auxSolidBox(a,b,c:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidBox';
    Procedure auxWireTorus(a,b:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireTorus';
    Procedure auxSolidTorus(a,b:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidTorus';
    Procedure auxWireCylinder(a,b:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireCylinder';
    Procedure auxSolidCylinder(a,b:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidCylinder';
    Procedure auxWireIcosahedron(a:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireIcosahedron';
    Procedure auxSolidIcosahedron(a:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidIcosahedron';
    Procedure auxWireOctahedron(a:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireOctahedron';
    Procedure auxSolidOctahedron(a:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidOctahedron';
    Procedure auxWireTetrahedron(a:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireTetrahedron';
    Procedure auxSolidTetrahedron(a:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidTetrahedron';
    Procedure auxWireDodecahedron(a:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireDodecahedron';
    Procedure auxSolidDodecahedron(a:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidDodecahedron';
    Procedure auxWireCone(a,b:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireCone';
    Procedure auxSolidCone(a,b:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidCone';
    Procedure auxWireTeapot(a:GLdouble);ApiEntry; 'LIBAUX' name 'auxWireTeapot';
    Procedure auxSolidTeapot(a:GLdouble);ApiEntry; 'LIBAUX' name 'auxSolidTeapot';

    Procedure glutInit (Var argc;Var argv);ApiEntry; 'GLUT' name 'glutInit';
    Procedure glutInitDisplayMode (m:LongWord);ApiEntry; 'GLUT' name 'glutInitDisplayMode';
    Procedure glutInitWindowPosition (x,y:LongInt);ApiEntry; 'GLUT' name 'glutInitWindowPosition';
    Procedure glutInitWindowSize (cx,cy:LongInt);ApiEntry; 'GLUT' name 'glutInitWindowSize';
    Procedure glutMainLoop;ApiEntry; 'GLUT' name 'glutMainLoop';
    Function glutCreateWindow (Var c:CString):LongInt;ApiEntry; 'GLUT' name 'glutCreateWindow';
    Function glutCreateSubWindow (x,y,w,h,i:LongInt):LongInt;ApiEntry; 'GLUT' name 'glutCreateSubWindow';
    Procedure glutDestroyWindow (i:LongInt);ApiEntry; 'GLUT' name 'glutDestroyWindow';
    Procedure glutPostRedisplay;ApiEntry; 'GLUT' name 'glutPostRedisplay';
    Procedure glutSwapBuffers;ApiEntry; 'GLUT' name 'glutSwapBuffers';
    Function glutGetWindow:LongInt;ApiEntry; 'GLUT' name 'glutGetWindow';
    Procedure glutSetWindow (i:LongInt);ApiEntry; 'GLUT' name 'glutSetWindow';
    Procedure glutSetWindowTitle (Const c:CString);ApiEntry; 'GLUT' name 'glutSetWindowTitle';
    Procedure glutSetIconTitle (Const c:CString);ApiEntry; 'GLUT' name 'glutSetIconTitle';
    Procedure glutPositionWindow (x,y:LongInt);ApiEntry; 'GLUT' name 'glutPositionWindow';
    Procedure glutReshapeWindow (i1,i2:LongInt);ApiEntry; 'GLUT' name 'glutReshapeWindow';
    Procedure glutPopWindow;ApiEntry; 'GLUT' name 'glutPopWindow';
    Procedure glutPushWindow;ApiEntry; 'GLUT' name 'glutPushWindow';
    Procedure glutIconifyWindow;ApiEntry; 'GLUT' name 'glutIconifyWindow';
    Procedure glutShowWindow;ApiEntry; 'GLUT' name 'glutShowWindow';
    Procedure glutHideWindow;ApiEntry; 'GLUT' name 'glutHideWindow';
    Function glutCreateMenu (f:glutproc4):LongInt;ApiEntry; 'GLUT' name 'glutCreateMenu';
    Procedure glutDestroyMenu(i:LongInt);ApiEntry; 'GLUT' name 'glutDestroyMenu';
    Function glutGetMenu:LongInt;ApiEntry; 'GLUT' name 'glutGetMenu';
    Procedure glutSetMenu (i:LongInt);ApiEntry; 'GLUT' name 'glutSetMenu';
    Procedure glutAddMenuEntry (Const c:CString;i:LongInt);ApiEntry; 'GLUT' name 'glutAddMenuEntry';
    Procedure glutAddSubMenu (Const c:CString;i:LongInt);ApiEntry; 'GLUT' name 'glutAddSubMenu';
    Procedure glutChangeToMenuEntry (i:LongInt;Const c:CString;i1:LongInt);ApiEntry; 'GLUT' name 'glutChangeToMenuEntry';
    Procedure glutChangeToSubMenu (i:LongInt;Const c:CString;i1:LongInt);ApiEntry; 'GLUT' name 'glutChangeToSubMenu';
    Procedure glutRemoveMenuItem (i:LongInt);ApiEntry; 'GLUT' name 'glutRemoveMenuItem';
    Procedure glutAttachMenu (i:LongInt);ApiEntry; 'GLUT' name 'glutAttachMenu';
    Procedure glutDetachMenu (i:LongInt);ApiEntry; 'GLUT' name 'glutDetachMenu';
    Procedure glutDisplayFunc (f:auxproc1);ApiEntry; 'GLUT' name 'glutDisplayFunc';
    Procedure glutReshapeFunc (f:glutproc1);ApiEntry; 'GLUT' name 'glutReshapeFunc';
    Procedure glutKeyboardFunc (f:glutproc2);ApiEntry; 'GLUT' name 'glutKeyboardFunc';
    Procedure glutMouseFunc (f:glutproc3);ApiEntry; 'GLUT' name 'glutMouseFunc';
    Procedure glutMotionFunc (f:glutproc1);ApiEntry; 'GLUT' name 'glutMotionFunc';
    Procedure glutPassiveMotionFunc (f:glutproc1);ApiEntry; 'GLUT' name 'glutPassiveMotionFunc';
    Procedure glutEntryFunc (f:glutproc4);ApiEntry; 'GLUT' name 'glutEntryFunc';
    Procedure glutVisibilityFunc (f:glutproc4);ApiEntry; 'GLUT' name 'glutVisibilityFunc';
    Procedure glutIdleFunc (f:auxproc1);ApiEntry; 'GLUT' name 'glutIdleFunc';
    Procedure glutTimerFunc (u:LongWord;f:glutproc1);ApiEntry; 'GLUT' name 'glutTimerFunc';
    Procedure glutMenuStateFunc (f:glutproc4);ApiEntry; 'GLUT' name 'glutMenuStateFunc';
    Procedure glutSetColor (i:LongInt;f1,f2,f3:GLfloat);ApiEntry; 'GLUT' name 'glutSetColor';
    Function glutGetColor (i1,i2:LongInt):GLfloat;ApiEntry; 'GLUT' name 'glutGetColor';
    Procedure glutCopyColormap (i:LongInt);ApiEntry; 'GLUT' name 'glutCopyColormap';
    Function glutGet (r:GLenum):LongInt;ApiEntry; 'GLUT' name 'glutGet';
    Function glutDeviceGet (e:GLenum):LongInt;ApiEntry; 'GLUT' name 'glutDeviceGet';
    Procedure glutStrokeCharacter (Var Buf;i:LongInt);ApiEntry; 'GLUT' name 'glutStrokeCharacter';
    Procedure glutBitmapCharacter (Var Buf;i:LongInt);ApiEntry; 'GLUT' name 'glutBitmapCharacter';
    Procedure glutWireSphere (d:GLdouble;i1,i2:GLint);ApiEntry; 'GLUT' name 'glutWireSphere';
    Procedure glutSolidSphere (d:GLdouble;i1,i2:GLint);ApiEntry; 'GLUT' name 'glutSolidSphere';
    Procedure glutWireCone (d1,d2:GLdouble;i1,i2:GLint);ApiEntry; 'GLUT' name 'glutWireCone';
    Procedure glutSolidCone (d1,d2:GLdouble;i1,i2:GLint);ApiEntry; 'GLUT' name 'glutSolidCone';
    Procedure glutWireCube (d:GLdouble);ApiEntry; 'GLUT' name 'glutWireCube';
    Procedure glutSolidCube (d:GLdouble);ApiEntry; 'GLUT' name 'glutSolidCube';
    Procedure glutWireTorus (d1,d2:GLdouble;i1,i2:GLint);ApiEntry; 'GLUT' name 'glutWireTorus';
    Procedure glutSolidTorus (d1,d2:GLdouble;i1,i2:GLint);ApiEntry; 'GLUT' name 'glutSolidTorus';
    Procedure glutWireDodecahedron;ApiEntry; 'GLUT' name 'glutWireDodecahedron';
    Procedure glutSolidDodecahedron;ApiEntry; 'GLUT' name 'glutSolidDodecahedron';
    Procedure glutWireTeapot (d:GLdouble);ApiEntry; 'GLUT' name 'glutWireTeapot';
    Procedure glutSolidTeapot (d:GLdouble);ApiEntry; 'GLUT' name 'glutSolidTeapot';
    Procedure glutWireOctahedron;ApiEntry; 'GLUT' name 'glutWireOctahedron';
    Procedure glutSolidOctahedron;ApiEntry; 'GLUT' name 'glutSolidOctahedron';
    Procedure glutWireTetrahedron;ApiEntry; 'GLUT' name 'glutWireTetrahedron';
    Procedure glutSolidTetrahedron;ApiEntry; 'GLUT' name 'glutSolidTetrahedron';
    Procedure glutWireIcosahedron;ApiEntry; 'GLUT' name 'glutWireIcosahedron';
    Procedure glutSolidIcosahedron;ApiEntry; 'GLUT' name 'glutSolidIcosahedron';
End;

Function AUX_WIND_IS_RGB(x:LongWord):Boolean;
Function AUX_WIND_IS_INDEX(x:LongWord):Boolean;
Function AUX_WIND_IS_SINGLE(x:LongWord):Boolean;
Function AUX_WIND_IS_DOUBLE(x:LongWord):Boolean;
Function AUX_WIND_IS_INDIRECT(x:LongWord):Boolean;
Function AUX_WIND_IS_DIRECT(x:LongWord):Boolean;
Function AUX_WIND_HAS_ACCUM(x:LongWord):Boolean;
Function AUX_WIND_HAS_ALPHA(x:LongWord):Boolean;
Function AUX_WIND_HAS_DEPTH(x:LongWord):Boolean;
Function AUX_WIND_HAS_STENCIL(x:LongWord):Boolean;
Procedure AUX_SETCOLOR(x,y:LongWord);

Implementation

Function AUX_WIND_IS_RGB(x:LongWord):Boolean;
Begin
    Result:=(x AND AUX_INDEX) = 0;
End;

Function AUX_WIND_IS_INDEX(x:LongWord):Boolean;
Begin
     Result:=(x And AUX_INDEX) <> 0;
End;

Function AUX_WIND_IS_SINGLE(x:LongWord):Boolean;
Begin
    Result:=(x And AUX_DOUBLE) = 0;
End;

Function AUX_WIND_IS_DOUBLE(x:LongWord):Boolean;
Begin
    Result:=(x And AUX_DOUBLE) <> 0;
End;

Function AUX_WIND_IS_INDIRECT(x:LongWord):Boolean;
Begin
    Result:=(x And AUX_INDIRECT) <> 0;
End;

Function AUX_WIND_IS_DIRECT(x:LongWord):Boolean;
Begin
     Result:=(x And AUX_INDIRECT) = 0;
End;

Function AUX_WIND_HAS_ACCUM(x:LongWord):Boolean;
Begin
    Result:=(x And AUX_ACCUM) <> 0;
End;

Function AUX_WIND_HAS_ALPHA(x:LongWord):Boolean;
Begin
    Result:=(x And AUX_ALPHA) <> 0;
End;

Function AUX_WIND_HAS_DEPTH(x:LongWord):Boolean;
Begin
    Result:=(x And AUX_DEPTH) <> 0;
End;

Function AUX_WIND_HAS_STENCIL(x:LongWord):Boolean;
Begin
    Result:=(x And AUX_STENCIL) <> 0;
End;

Procedure AUX_SETCOLOR(x,y:LongWord);
Begin
    If AUX_WIND_IS_RGB(x) Then glColor3fv(auxRGBMap[y][0])
    Else glIndexf(y);
End;


End.
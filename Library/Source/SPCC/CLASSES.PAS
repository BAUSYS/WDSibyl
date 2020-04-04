
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
 
                       
Unit Classes;
                         
Interface

Uses SysUtils, uSysClass, Color, Dos, IniFiles,
     uString,   { diverse Stringfunktionen }
     uList,
     uStream;

{$IFDEF OS2}
Uses PmWin,BseDos;
{$ENDIF}
{$IFDEF Win32}
Uses WinUser,WinBase;
{$ENDIF}

Type
    {internal Window Procedure format}
    {$IFDEF OS2}
    TWndProc=Function(Win,Msg,para1,para2:LongWord):LongWord;CDecl;
    {$ENDIF}
    {$IFDEF Win32}
    TWndProc=Function(Win,Msg,para1,para2:LongWord):LongWord;APIENTRY;
    {$ENDIF}
    {Standard help context Type}
    THelpContext=LongWord;

Type
    {General KeyCode Type. KeyCode constants apply to ScanEvent Methods}
{$M+}
    TKeyCode = LongWord;

Const
    {predefined Keyboars codes. To determine If Ctrl,Shift Or Alt was
     Pressed together With the key you may Use Boolean operations}
    kbNull             = TKeyCode(0);
    kb_VK              = 256;
    kb_Ctrl            = 512;
    kb_Shift           = 1024;
    kb_Alt             = 2048;
    kb_Char            = 4096;
    kbF1               = TKeyCode(kb_VK + VK_F1);
    kbF2               = TKeyCode(kb_VK + VK_F2);
    kbF3               = TKeyCode(kb_VK + VK_F3);
    kbF4               = TKeyCode(kb_VK + VK_F4);
    kbF5               = TKeyCode(kb_VK + VK_F5);
    kbF6               = TKeyCode(kb_VK + VK_F6);
    kbF7               = TKeyCode(kb_VK + VK_F7);
    kbF8               = TKeyCode(kb_VK + VK_F8);
    kbF9               = TKeyCode(kb_VK + VK_F9);
    kbF10              = TKeyCode(kb_VK + VK_F10);
    kbF11              = TKeyCode(kb_VK + VK_F11);
    kbF12              = TKeyCode(kb_VK + VK_F12);
    kbCLeft            = TKeyCode(kb_VK + VK_LEFT);
    kbCRight           = TKeyCode(kb_VK + VK_RIGHT);
    kbCUp              = TKeyCode(kb_VK + VK_UP);
    kbCDown            = TKeyCode(kb_VK + VK_DOWN);
    kbDel              = TKeyCode(kb_VK + VK_DELETE);
    kbIns              = TKeyCode(kb_VK + VK_INSERT);
    kbEnd              = TKeyCode(kb_VK + VK_END);
    kbHome             = TKeyCode(kb_VK + VK_HOME);
    {$IFDEF OS2}
    kbPageDown         = TKeyCode(kb_VK + VK_PAGEDOWN);
    kbPageUp           = TKeyCode(kb_VK + VK_PAGEUP);
    kbBkSp             = TKeyCode(kb_VK + VK_BACKSPACE);
    kbCR               = TKeyCode(kb_VK + VK_NEWLINE);
    kbEsc              = TKeyCode(kb_VK + VK_ESC);
    kbCapsLock         = TKeyCode(kb_VK + VK_CAPSLOCK);
    kbScrollLock       = TKeyCode(kb_VK + VK_SCRLLOCK);
    kbEnter            = TKeyCode(kb_VK + VK_ENTER);
    kbPrintScrn        = TKeyCode(kb_VK + VK_PRINTSCRN);
    kbCtrl             = TKeyCode(kb_VK + VK_CTRL + kb_Ctrl);
    kbAlt              = TKeyCode(kb_VK + VK_ALT + kb_Alt);
    kbAltGraf          = TKeyCode(kb_VK + VK_ALTGRAF);
    kbBackTab          = TKeyCode(kb_VK + VK_BACKTAB);
    kbBreak            = TKeyCode(kb_VK + VK_BREAK);
    kbTab              = TKeyCode(kb_VK + VK_TAB);
    kbNumLock          = TKeyCode(kb_VK + VK_NUMLOCK);
    kbSpace            = TKeyCode(kb_VK + VK_SPACE);
    kbPause            = TKeyCode(kb_VK + VK_PAUSE);
    kbShift            = TKeyCode(kb_VK + VK_SHIFT + kb_Shift);
    {$ENDIF}
    {$IFDEF Win32}
    kbPageDown         = TKeyCode(kb_VK + VK_NEXT);
    kbPageUp           = TKeyCode(kb_VK + VK_PRIOR);
    kbBkSp             = TKeyCode(kb_VK + VK_BACK);
    kbCR               = TKeyCode(kb_VK + VK_RETURN);
    kbEsc              = TKeyCode(kb_VK + VK_ESCAPE);
    kbCapsLock         = TKeyCode(kb_VK + VK_CAPITAL);
    kbScrollLock       = TKeyCode(kb_VK + VK_SCROLL);
    kbEnter            = TKeyCode(kb_VK + VK_RETURN);
    kbPrintScrn        = TKeyCode(kb_VK + VK_PRINT);
    kbCtrl             = TKeyCode(kb_VK + VK_CONTROL + kb_Ctrl);
    kbAlt              = TKeyCode(kb_VK + VK_MENU + kb_Alt);
    kbAltGraf          = TKeyCode(kb_VK + VK_MENU + kb_Alt + kb_Ctrl);
    kbBackTab          = TKeyCode(kb_VK + VK_TAB);
    kbBreak            = TKeyCode(kb_VK + VK_ESCAPE);    {?}
    kbTab              = TKeyCode(kb_VK + VK_TAB);
    kbNumLock          = TKeyCode(kb_VK + VK_NUMLOCK);
    kbSpace            = TKeyCode(kb_VK + VK_SPACE);
    kbPause            = TKeyCode(kb_VK + VK_PAUSE);
    kbShift            = TKeyCode(kb_VK + VK_SHIFT + kb_Shift);
    {$ENDIF}

    {Shift codes are basic codes + kb_Shift}
    kbShiftF1          = TKeyCode(kb_Shift + kbF1);
    kbShiftF2          = TKeyCode(kb_Shift + kbF2);
    kbShiftF3          = TKeyCode(kb_Shift + kbF3);
    kbShiftF4          = TKeyCode(kb_Shift + kbF4);
    kbShiftF5          = TKeyCode(kb_Shift + kbF5);
    kbShiftF6          = TKeyCode(kb_Shift + kbF6);
    kbShiftF7          = TKeyCode(kb_Shift + kbF7);
    kbShiftF8          = TKeyCode(kb_Shift + kbF8);
    kbShiftF9          = TKeyCode(kb_Shift + kbF9);
    kbShiftF10         = TKeyCode(kb_Shift + kbF10);
    kbShiftF11         = TKeyCode(kb_Shift + kbF11);
    kbShiftF12         = TKeyCode(kb_Shift + kbF12);
    kbShiftCLeft       = TKeyCode(kb_Shift + kbCLeft);
    kbShiftCRight      = TKeyCode(kb_Shift + kbCRight);
    kbShiftCUp         = TKeyCode(kb_Shift + kbCUp);
    kbShiftCDown       = TKeyCode(kb_Shift + kbCDown);
    kbShiftDel         = TKeyCode(kb_Shift + kbDel);
    kbShiftIns         = TKeyCode(kb_Shift + kbIns);
    kbShiftEnd         = TKeyCode(kb_Shift + kbEnd);
    kbShiftHome        = TKeyCode(kb_Shift + kbHome);
    kbShiftPageDown    = TKeyCode(kb_Shift + kbPageDown);
    kbShiftPageUp      = TKeyCode(kb_Shift + kbPageUp);
    kbShiftBkSp        = TKeyCode(kb_Shift + kbBkSp);
    kbShiftCR          = TKeyCode(kb_Shift + kbCR);
    kbShiftSpace       = TKeyCode(kb_Shift + kbSpace);
    kbShiftTab         = TKeyCode(kb_Shift + kbBackTab);
    kbShiftEnter       = TKeyCode(kb_Shift + kbEnter);
    kbShiftPause       = TKeyCode(kb_Shift + kbPause);
    kbShiftBreak       = TKeyCode(kb_Shift + kbBreak);

    {$IFDEF OS2}
    kbScanBase=TKeyCode(97);
    {$ENDIF}
    {$IFDEF WIN32}
    kbScanBase=TKeyCode(65);
    {$ENDIF}

    kbA                = TKeyCode(kbScanBase+0);
    kbB                = TKeyCode(kbScanBase+1);
    kbC                = TKeyCode(kbScanBase+2);
    kbD                = TKeyCode(kbScanBase+3);
    kbE                = TKeyCode(kbScanBase+4);
    kbF                = TKeyCode(kbScanBase+5);
    kbG                = TKeyCode(kbScanBase+6);
    kbH                = TKeyCode(kbScanBase+7);
    kbI                = TKeyCode(kbScanBase+8);
    kbJ                = TKeyCode(kbScanBase+9);
    kbK                = TKeyCode(kbScanBase+10);
    kbL                = TKeyCode(kbScanBase+11);
    kbM                = TKeyCode(kbScanBase+12);
    kbN                = TKeyCode(kbScanBase+13);
    kbO                = TKeyCode(kbScanBase+14);
    kbP                = TKeyCode(kbScanBase+15);
    kbQ                = TKeyCode(kbScanBase+16);
    kbR                = TKeyCode(kbScanBase+17);
    kbS                = TKeyCode(kbScanBase+18);
    kbT                = TKeyCode(kbScanBase+19);
    kbU                = TKeyCode(kbScanBase+20);
    kbV                = TKeyCode(kbScanBase+21);
    kbW                = TKeyCode(kbScanBase+22);
    kbX                = TKeyCode(kbScanBase+23);
    kbY                = TKeyCode(kbScanBase+24);
    kbZ                = TKeyCode(kbScanBase+25);

    kb0                = TKeyCode(48);
    kb1                = TKeyCode(49);
    kb2                = TKeyCode(50);
    kb3                = TKeyCode(51);
    kb4                = TKeyCode(52);
    kb5                = TKeyCode(53);
    kb6                = TKeyCode(54);
    kb7                = TKeyCode(55);
    kb8                = TKeyCode(56);
    kb9                = TKeyCode(57);

    {Ctrl codes are basic codes + kbCtrl}
    kbCtrl0            = TKeyCode(kb_Ctrl + kb_Char + kb1);
    kbCtrl1            = TKeyCode(kb_Ctrl + kb_Char + kb1);
    kbCtrl2            = TKeyCode(kb_Ctrl + kb_Char + kb2);
    kbCtrl3            = TKeyCode(kb_Ctrl + kb_Char + kb3);
    kbCtrl4            = TKeyCode(kb_Ctrl + kb_Char + kb4);
    kbCtrl5            = TKeyCode(kb_Ctrl + kb_Char + kb5);
    kbCtrl6            = TKeyCode(kb_Ctrl + kb_Char + kb6);
    kbCtrl7            = TKeyCode(kb_Ctrl + kb_Char + kb7);
    kbCtrl8            = TKeyCode(kb_Ctrl + kb_Char + kb8);
    kbCtrl9            = TKeyCode(kb_Ctrl + kb_Char + kb9);

    kbCtrlA             = TKeyCode(kb_Ctrl + kb_Char + kbA);
    kbCtrlB             = TKeyCode(kb_Ctrl + kb_Char + kbB);
    kbCtrlC             = TKeyCode(kb_Ctrl + kb_Char + kbC);
    kbCtrlD             = TKeyCode(kb_Ctrl + kb_Char + kbD);
    kbCtrlE             = TKeyCode(kb_Ctrl + kb_Char + kbE);
    kbCtrlF             = TKeyCode(kb_Ctrl + kb_Char + kbF);
    kbCtrlG             = TKeyCode(kb_Ctrl + kb_Char + kbG);
    kbCtrlH             = TKeyCode(kb_Ctrl + kb_Char + kbH);
    kbCtrlI             = TKeyCode(kb_Ctrl + kb_Char + kbI);
    kbCtrlJ             = TKeyCode(kb_Ctrl + kb_Char + kbJ);
    kbCtrlK             = TKeyCode(kb_Ctrl + kb_Char + kbK);
    kbCtrlL             = TKeyCode(kb_Ctrl + kb_Char + kbL);
    kbCtrlM             = TKeyCode(kb_Ctrl + kb_Char + kbM);
    kbCtrlN             = TKeyCode(kb_Ctrl + kb_Char + kbN);
    kbCtrlO             = TKeyCode(kb_Ctrl + kb_Char + kbO);
    kbCtrlP             = TKeyCode(kb_Ctrl + kb_Char + kbP);
    kbCtrlQ             = TKeyCode(kb_Ctrl + kb_Char + kbQ);
    kbCtrlR             = TKeyCode(kb_Ctrl + kb_Char + kbR);
    kbCtrlS             = TKeyCode(kb_Ctrl + kb_Char + kbS);
    kbCtrlT             = TKeyCode(kb_Ctrl + kb_Char + kbT);
    kbCtrlU             = TKeyCode(kb_Ctrl + kb_Char + kbU);
    kbCtrlV             = TKeyCode(kb_Ctrl + kb_Char + kbV);
    kbCtrlW             = TKeyCode(kb_Ctrl + kb_Char + kbW);
    kbCtrlX             = TKeyCode(kb_Ctrl + kb_Char + kbX);
    kbCtrlY             = TKeyCode(kb_Ctrl + kb_Char + kbY);
    kbCtrlZ             = TKeyCode(kb_Ctrl + kb_Char + kbZ);

    kbCtrlF1           = TKeyCode(kb_Ctrl + kbF1);
    kbCtrlF2           = TKeyCode(kb_Ctrl + kbF2);
    kbCtrlF3           = TKeyCode(kb_Ctrl + kbF3);
    kbCtrlF4           = TKeyCode(kb_Ctrl + kbF4);
    kbCtrlF5           = TKeyCode(kb_Ctrl + kbF5);
    kbCtrlF6           = TKeyCode(kb_Ctrl + kbF6);
    kbCtrlF7           = TKeyCode(kb_Ctrl + kbF7);
    kbCtrlF8           = TKeyCode(kb_Ctrl + kbF8);
    kbCtrlF9           = TKeyCode(kb_Ctrl + kbF9);
    kbCtrlF10          = TKeyCode(kb_Ctrl + kbF10);
    kbCtrlF11          = TKeyCode(kb_Ctrl + kbF11);
    kbCtrlF12          = TKeyCode(kb_Ctrl + kbF12);
    kbCtrlCLeft        = TKeyCode(kb_Ctrl + kbCLeft);
    kbCtrlCRight       = TKeyCode(kb_Ctrl + kbCRight);
    kbCtrlCUp          = TKeyCode(kb_Ctrl + kbCUp);
    kbCtrlCDown        = TKeyCode(kb_Ctrl + kbCDown);
    kbCtrlDel          = TKeyCode(kb_Ctrl + kbDel);
    kbCtrlIns          = TKeyCode(kb_Ctrl + kbIns);
    kbCtrlEnd          = TKeyCode(kb_Ctrl + kbEnd);
    kbCtrlHome         = TKeyCode(kb_Ctrl + kbHome);
    kbCtrlPageDown     = TKeyCode(kb_Ctrl + kbPageDown);
    kbCtrlPageUp       = TKeyCode(kb_Ctrl + kbPageUp);
    kbCtrlBkSp         = TKeyCode(kb_Ctrl + kbBkSp
                             {$ifdef os2}+ kb_Alt{$endif});     {Martin0308}
    kbCtrlCR           = TKeyCode(kb_Ctrl + kbCR);
    kbCtrlSpace        = TKeyCode(kb_Ctrl + kbSpace);
    kbCtrlTab          = TKeyCode(kb_Ctrl + kbTab);
    kbCtrlEnter        = TKeyCode(kb_Ctrl + kbEnter);
    kbCtrlPause        = TKeyCode(kb_Ctrl + kbPause);
    kbCtrlBreak        = TKeyCode(kb_Ctrl + kbBreak);

    {Alt codes are basic codes + kbAlt}
    kbAlt0             = TKeyCode(kb_Alt + kb_Char + 48);
    kbAlt1             = TKeyCode(kb_Alt + kb_Char + 49);
    kbAlt2             = TKeyCode(kb_Alt + kb_Char + 50);
    kbAlt3             = TKeyCode(kb_Alt + kb_Char + 51);
    kbAlt4             = TKeyCode(kb_Alt + kb_Char + 52);
    kbAlt5             = TKeyCode(kb_Alt + kb_Char + 53);
    kbAlt6             = TKeyCode(kb_Alt + kb_Char + 54);
    kbAlt7             = TKeyCode(kb_Alt + kb_Char + 55);
    kbAlt8             = TKeyCode(kb_Alt + kb_Char + 56);
    kbAlt9             = TKeyCode(kb_Alt + kb_Char + 57);

    kbAltA             = TKeyCode(kb_Alt + kb_Char + kbA);
    kbAltB             = TKeyCode(kb_Alt + kb_Char + kbB);
    kbAltC             = TKeyCode(kb_Alt + kb_Char + kbC);
    kbAltD             = TKeyCode(kb_Alt + kb_Char + kbD);
    kbAltE             = TKeyCode(kb_Alt + kb_Char + kbE);
    kbAltF             = TKeyCode(kb_Alt + kb_Char + kbF);
    kbAltG             = TKeyCode(kb_Alt + kb_Char + kbG);
    kbAltH             = TKeyCode(kb_Alt + kb_Char + kbH);
    kbAltI             = TKeyCode(kb_Alt + kb_Char + kbI);
    kbAltJ             = TKeyCode(kb_Alt + kb_Char + kbJ);
    kbAltK             = TKeyCode(kb_Alt + kb_Char + kbK);
    kbAltL             = TKeyCode(kb_Alt + kb_Char + kbL);
    kbAltM             = TKeyCode(kb_Alt + kb_Char + kbM);
    kbAltN             = TKeyCode(kb_Alt + kb_Char + kbN);
    kbAltO             = TKeyCode(kb_Alt + kb_Char + kbO);
    kbAltP             = TKeyCode(kb_Alt + kb_Char + kbP);
    kbAltQ             = TKeyCode(kb_Alt + kb_Char + kbQ);
    kbAltR             = TKeyCode(kb_Alt + kb_Char + kbR);
    kbAltS             = TKeyCode(kb_Alt + kb_Char + kbS);
    kbAltT             = TKeyCode(kb_Alt + kb_Char + kbT);
    kbAltU             = TKeyCode(kb_Alt + kb_Char + kbU);
    kbAltV             = TKeyCode(kb_Alt + kb_Char + kbV);
    kbAltW             = TKeyCode(kb_Alt + kb_Char + kbW);
    kbAltX             = TKeyCode(kb_Alt + kb_Char + kbX);
    kbAltY             = TKeyCode(kb_Alt + kb_Char + kbY);
    kbAltZ             = TKeyCode(kb_Alt + kb_Char + kbZ);

    kbAltF1            = TKeyCode(kb_Alt + kbF1);
    kbAltF2            = TKeyCode(kb_Alt + kbF2);
    kbAltF3            = TKeyCode(kb_Alt + kbF3);
    kbAltF4            = TKeyCode(kb_Alt + kbF4);
    kbAltF5            = TKeyCode(kb_Alt + kbF5);
    kbAltF6            = TKeyCode(kb_Alt + kbF6);
    kbAltF7            = TKeyCode(kb_Alt + kbF7);
    kbAltF8            = TKeyCode(kb_Alt + kbF8);
    kbAltF9            = TKeyCode(kb_Alt + kbF9);
    kbAltF10           = TKeyCode(kb_Alt + kbF10);
    kbAltF11           = TKeyCode(kb_Alt + kbF11);
    kbAltF12           = TKeyCode(kb_Alt + kbF12);
    kbAltCLeft         = TKeyCode(kb_Alt + kbCLeft);
    kbAltCRight        = TKeyCode(kb_Alt + kbCRight);
    kbAltCUp           = TKeyCode(kb_Alt + kbCUp);
    kbAltCDown         = TKeyCode(kb_Alt + kbCDown);
    kbAltDel           = TKeyCode(kb_Alt + kbDel);
    kbAltIns           = TKeyCode(kb_Alt + kbIns);
    kbAltEnd           = TKeyCode(kb_Alt + kbEnd);
    kbAltHome          = TKeyCode(kb_Alt + kbHome);
    kbAltPageDown      = TKeyCode(kb_Alt + kbPageDown);
    kbAltPageUp        = TKeyCode(kb_Alt + kbPageUp);
    kbAltBkSp          = TKeyCode(kb_Alt + kbBkSp);
    kbAltCR            = TKeyCode(kb_Alt + kbCR);
    kbAltSpace         = TKeyCode(kb_Alt + kbSpace);
    kbAltTab           = TKeyCode(kb_Alt + kbTab);
    kbAltEnter         = TKeyCode(kb_Alt + kbEnter);
    kbAltPause         = TKeyCode(kb_Alt + kbPause);
    kbAltBreak         = TKeyCode(kb_Alt + kbBreak);
{$M-}

    { A notify event Is A method variable, I.E. A Procedure
    variable For Objects. Some Classes allow the specification
    Of Objects To be notified Of changes. }

// Konstanten fuer die Methoden WriteInfoToINI und ReadInfoFromINI;
Const TagINI_End           = '];';
      TagINI_Control       = '[tControl=';
      TagINI_Form          = '[tForm=';
      TagINI_Menu          = '[tMenu=';
      TagINI_HeaderControl = '[tHeaderControl=';

Type
    TComponent=Class;

Type

{ TBits implements A Boolean Array. entries are
  numbered 0 .. Size - 1, As usual. Bits allows
  Read / Write access To entries. OpenBit returns
  Index Of First True bit, Or -1 If none Is True. }

  PBitsArray = ^TBitsArray;
  TBitsArray = Array[0..MaxLongInt Div 4] Of LongWord;

  EBitsError = Class(Exception);

  TBits = Class
  Private
    FBits: PBitsArray;
    FSize: LongInt;
    Procedure Error;
    Function GetBit(Index: LongInt): Boolean;
    Procedure SetBit(Index: LongInt; bit: Boolean);
    Procedure SetSize(NewSize: LongInt);
  Public
    Destructor Destroy; Override;
    Function OpenBit: LongInt;
    Property Bits[Index: LongInt]: Boolean Read GetBit Write SetBit; Default;
    Property Size: LongInt Read FSize Write SetSize;
  End;


Type
    //General types
    HWindow=LongWord;

    PMessage=^TMessage;
{$M+}
    TMessage=Record
{$M-}
         Msg:LongWord;
         ReceiverClass: TObject;
         Receiver: HWindow;
         Handled: LongBool;  {True If the Message was Handled}
         Case Integer Of
            0: ( Param1: LongWord;
                 Param2: LongWord;
                 Result: LongWord);
            1: ( WParam: LongWord;
                 LParam: LongWord;
                 MsgResult: LongWord);
            2: ( Param1Lo: Word;
                 Param1Hi: Word;
                 Param2Lo: Word;
                 Param2Hi: Word;
                 ResultLo: Word;
                 ResultHi: Word);
            3: ( Param1LoByteLo:Byte;
                 Param1LoByteHi:Byte;
                 Param1HiByteLo:Byte;
                 Param1HiByteHi:Byte;
                 Param2LoByteLo:Byte;
                 Param2LoByteHi:Byte;
                 Param2HiByteLo:Byte;
                 Param2HiByteHi:Byte;
                 ResultLoByteLo:Byte;
                 ResultLoByteHi:Byte;
                 ResultHiByteLo:Byte;
                 ResultHiByteHi:Byte);
    End;

    HDC=LongWord;
    HPalette=LongWord;

    PFromInfo=^TFormInfo;
{$M+}
    TFormInfo=Record
        Left,Bottom,Width,Height:LongInt;
        FontName                : String;
        FontSize                : Byte;
        Color                   : tColor;
    End;
{$M-}

{$M+}
    TRGB=Record
         Blue:Byte;
         Green:Byte;
         Red:Byte;
         Fill:Byte;
    End;
{$M-}

Type
    TResourceName=String[32];
    TResourceStream=Class(TMemoryStream)
      Private
         FHeaderPos:LongInt;
         FResourceList:TList;
         SCUStream:TStream;
      Protected
         Property Capacity;
      Public
         Function NewResourceEntry(Const ResName:TResourceName;
                                   Var Data;DataLen:LongInt):Boolean;
         Function WriteResourcesToStream(Stream:TMemoryStream):Boolean;
         Destructor Destroy;Override;
    End;


{Standard Resource Names For NewResourceEntry}
Const
    rnGlyph         = 'rnGlyph';
    rnBitmap        = 'rnBitmap';
    rnPicture       = 'rnPicture';
    rnPictureLeaf   = 'rnPictureLeaf';
    rnPictureOpen   = 'rnPictureOpen';
    rnPictureClosed = 'rnPictureClosed';
    rnFont          = 'rnFont';
    rnTabFont       = 'rnTabFont';
    rnLines         = 'rnLines';
    rnItems         = 'rnItems';
    rnTabs          = 'rnTabs';
    rnDBServer      = 'rnDBServer';
    rnDBDataBase    = 'rnDBDataBase';
    rnDBTable       = 'rnDBTable';
    rnDBQuery       = 'rnDBQuery';
    rnDBDataField   = 'rnDBDataField';
    rnGridSizes     = 'rnGridSize';
    rnFileName      = 'rnFileName';
    rnIcon          = 'rnIcon';
    rnDBGridCols    = 'rnDBGridCols';
    rnStatusPanels  = 'rnStatusPanels';
    rnHeaders       = 'rnHeaders';
    rnBitmapList    = 'rnBitmapList';
    rnScrollExtents = 'rnScrollExtents';
    rnConstraints   = 'rnConstraints';

Type
    TComponentState=Set Of (csDesigning,csReading,csWriting,csDestroying,
                            csLoaded,csForm,csDetail,csReferenceControl,
                            csReference,csAcceptsControls,csHandleLinks,
                            csHasMainMenu,csLoading);

    TDesignerState=Set Of (dsFormVisible,dsNoRealSizing,
                           dsNoSourceCode,dsStored,dsAutoCreate);

    TOperation=(opInsert,opRemove);

    TGetChildProc=Procedure(Child:TComponent) Of Object;


    ESCUError=Class(Exception);

    TPersistent=Class(TObject)
       Private
             Procedure AssignError(Source:TPersistent);
       Protected
             Procedure AssignTo(Dest:TPersistent);Virtual;
       Public
             Procedure Assign(Source:TPersistent);Virtual;
    End;

    TPersistentClass = class of TPersistent;

    TComponent=Class(TPersistent)
      Private
         FLanguages:Pointer;
         FName:PString;
         FUnitName:PString;
         FTypeName:PString;
         FOwner:TComponent;
         FComponentState:TComponentState;
         FDesignerState:TDesignerState;
         FCreateFromSCU:Boolean;
         FComponents:TList;
         FFreeNotifyList:TList;
         FMethods:Pointer;
         FTag:LongInt;
         FWriteComponentCount:LongInt;
         fSaveLoadInfo : Boolean;   // Steuert ob die Komponenteinformation (Font, Farbe,..) in die INI gespeichert werden soll
         SCUStream:TMemoryStream;
         SCUResStream:TResourceStream;
         SCUWriteError:Boolean;
         FReference:TComponent;

         FOnResetComponent : TNotifyEvent;

         Function GetComponentCount:LongInt;
         Function GetComponent(AIndex:LongInt):TComponent;
         Function GetComponentIndex:LongInt;
         Procedure SetComponentIndex(Index:LongInt);
         Function GetName:String;
         Procedure SetName(Const NewName:String);
         Function GetUnitName:String;
         Function GetTypeName:String;
         Procedure SetTypeName(NewName:String);
         Function GetDesigned:Boolean;
         Procedure SetupSCU;
         Function ReadPropertiesSCU(COwner:TComponent;Namep,Resourcep:Pointer;Var ClassPointer:Pointer):Boolean;
         Function ReadComponentsSCU(NameTable,ResourceTable:Pointer;Var ClassP:Pointer):Boolean;
         Procedure ReadResourceSCU(ResourceTable:Pointer;Var ClassP:Pointer);
         Procedure WriteComponent(Child:TComponent);
         Procedure ReadSCU(Data:Pointer);
         Function GetUniqueName : String;
      Protected
         Procedure SetupComponent;Virtual;
         Procedure Loaded;Virtual;
         Procedure LoadedFromSCU(SCUParent:TComponent);Virtual;
         Procedure LoadingFromSCU(SCUParent:TComponent);Virtual;
         Procedure GetChildren(Proc:TGetChildProc);Virtual;
         Function HasParent:Boolean;Virtual;
         Procedure UpdateLinkList(Const PropertyName:String;LinkList:TList);Virtual;  //For Component links
      Public
         Constructor Create(AOwner:TComponent);Virtual;
         Destructor Destroy;Override;
         Procedure InsertComponent(AComponent:TComponent);Virtual;
         Procedure RemoveComponent(AComponent:TComponent);Virtual;
         Function IndexOfComponent(AComponent:TComponent):LongInt;
         Procedure DestroyComponents;
         Procedure ResetComponent;Virtual;
         Function FindComponent(Const AName:String):TComponent;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Virtual;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Virtual;
         Procedure ReadFromStream(SCUStream:TStream);
         Procedure WriteToStream(SCUStream:TStream);
         Procedure WriteInfoToINI(InfoLine : String); Virtual;
         Function ReadInfoFromINI : String; Virtual;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Virtual;
         Procedure FreeNotification(AComponent:TComponent);Virtual;
         Procedure SetDesigning(Value:Boolean);Virtual;
         Procedure GetDesignerPopupEvents(AString:TStringList);Virtual;
         Procedure DesignerPopupEvent(Id:LongInt);Virtual;

         Property Owner:TComponent Read FOwner write FOwner;
         Property Components[Index:LongInt]:TComponent Read GetComponent;
         Property ComponentCount:LongInt Read GetComponentCount;
         Property ComponentIndex:LongInt Read GetComponentIndex Write SetComponentIndex;
         Property ComponentState:TComponentState Read FComponentState Write FComponentState;
         Property DesignerState:TDesignerState Read FDesignerState Write FDesignerState; stored;
         Property UnitName:String Read GetUnitName;
         Property TypeName:String Read GetTypeName Write SetTypeName;
         Property Designed:Boolean Read GetDesigned;
         Property FreeNotifyList:TList Read FFreeNotifyList;
         Property Methods:Pointer Read FMethods Write FMethods;      {undocumented}
         Property UniqueName : String Read GetUniqueName;
      Published
         Property Name:String Read GetName Write SetName;
         Property Tag:LongInt Read FTag Write FTag;
         Property SaveLoadInfo : Boolean Read fSaveLoadInfo Write fSaveLoadInfo; //  SetSaveLoadInfo;

         Property OnResetComponent : TNotifyEvent Read FOnResetComponent Write FOnResetComponent;
    End;
    TComponentClass=Class Of TComponent;

    TCollection = Class;

    TCollectionItem = Class
      Private
         FCollection:TCollection;
      Private
         Function GetIndex:LongInt;
         Procedure SetCollection(NewValue:TCollection);
      Protected
         Procedure SetIndex(NewIndex:LongInt);Virtual;
         Procedure changed(AllItems:Boolean);
      Public
         Procedure Assign(Source:TCollectionItem);Virtual;Abstract;
         Constructor Create(ACollection: TCollection);Virtual;
         Destructor Destroy;Override;
      Public
         Property collection:TCollection Read FCollection Write SetCollection;
         Property Index:LongInt Read GetIndex Write SetIndex;
    End;

    TCollectionItemClass=Class Of TCollectionItem;

    TCollection=Class(TComponent)
      Private
         FItemClass:TCollectionItemClass;
         FItems:TList;
         FUpdateCount:LongInt;
      Private
         Function GetCount:LongInt;
         Procedure InsertItem(Item:TCollectionItem);
         Procedure RemoveItem(Item:TCollectionItem);
      Protected
         Procedure changed;
         Function GetItem(Index:LongInt):TCollectionItem;
         Procedure SetItem(Index:LongInt;Value:TCollectionItem);
      Public
         Procedure Update(Item:TCollectionItem);Virtual;
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
         Function Add:TCollectionItem;
         Procedure Assign(Source:TCollection);Virtual;
         Procedure BeginUpdate;
         Procedure Clear;
         Procedure EndUpdate;
      Public
         Property Count:LongInt Read GetCount;
         Property Items[Index:LongInt]:TCollectionItem Read GetItem Write SetItem;
         Property ItemClass:TCollectionItemClass Read FItemClass Write FItemClass;
    End;


    TStringSelectList=Class(TComponent)
      Private
         FList:TStringList;
         FSelected:String;
      Protected
         Procedure SetStringItem(NewValue:String);Virtual;
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         Function GetItems:TStringList;Virtual;
         Property SelectedItem:String Read FSelected Write SetStringItem;
         Property Items:TStringList Read GetItems;
    End;

Function GetInfoTag(iTag, iTagInfo : String; iTagList : tStringList) : String;
Procedure RegisterClasses(Const ComponentClasses: Array Of TComponentClass);
Function SearchClassByName(Const Name:String):TComponentClass;
Function CallReadProp(Objekt:TObject;FuncAddr:Pointer;Typ:Byte;
                      TypLen:LongInt;Value:Pointer):Boolean;
Function CallWriteProp(Objekt:TObject;ProcAddr:Pointer;Typ:Byte;
                       TypLen:LongInt;Value:Pointer):Boolean;


Type
    PSCUFileFormat=^TSCUFileFormat;
    TSCUFileFormat=Record
         Version:String[5];
         ObjectOffset,ObjectLen:LongInt;
         NameTableOffset,NameTableLen:LongInt;
         ResourceOffset,ResourceLen:LongInt;
         ObjectCount:LongInt;
         UseEntry:LongInt; {used by project management}
         NextEntry:Pointer;
         {auch System ndern (AddSCUData) und Compiler.PAS}
    End;


    PFormListItem=^TFormListItem;
    TFormListItem=Record
         Form:TComponent;
         FormName:String[64];
         UnitName:String;
         AutoCreate:Boolean;
         SCUPointer:Pointer;
         SCUSize:LongInt;
    End;


Function WritePropertiesToStream(FormList:TList):TMemoryStream;
Function WritePropertiesToFile(FileName:String;FormList:TList):Boolean;


Type
    TMsgDlgBtn=(mbYes,mbNo,mbOk,mbCancel,mbAbort,mbRetry,mbIgnore,mbAll,mbHelp);
    TMsgDlgButtons=Set Of TMsgDlgBtn;
    TMsgDlgType=(mtWarning,mtError,mtInformation,mtConfirmation,mtCustom,mtCritical);
    TMsgDlgReturn=LongWord;

Const
    mrBase    = $8000;      //cmBase
    mrOk      = mrBase+50;  //cmOk
    mrCancel  = mrBase+51;  //cmCancel
    mrYes     = mrBase+53;  //cmYes
    mrNo      = mrBase+54;  //cmNo
    mrIgnore  = mrBase+58;  //cmIgnore
    mrRetry   = mrBase+57;  //cmRetry
    mrAbort   = mrBase+56;  //cmAbort
    mrNone    = 0;          //cmNull
    mrAll     = mrBase+59;  //cmAll

Const
    mbYesNo=[mbYes,mbNo];
    mbYesNoCancel=[mbYes,mbNo,mbCancel];
    mbOkCancel=[mbOk,mbCancel];
    mbAbortRetryIgnore=[mbAbort,mbRetry,mbIgnore];


Function MessageBox2(Const Msg:String;Typ:TMsgDlgType;Buttons:TMsgDlgButtons):TMsgDlgReturn;
Function ErrorBox2(Const Msg:String):TMsgDlgReturn;

Function GetExperts:TList;  {noch raus?}


Var RegisteredClasses:TList;
    PropertyEditDialogs:TList;
    LibExperts:TList;
    LibExpertInstances:TList;

Type
    TPropertyEditorReturn=(edOk,edCancel,edList,edNoEditor);

    TPropertyEditor=Class(TComponent)
       Private
         FPropertyOwner:TComponent;
         FPropertyName:String;
         FList:TStringList;
       Public
         Function Execute(Var Value;ValueLen:LongInt):TPropertyEditorReturn;Virtual;Abstract;
       Public
         Property PropertyOwner:TComponent Read FPropertyOwner;
         Property PropertyName:String Read FPropertyName;
         Property List:TStringList Read FList;
    End;
    TPropertyEditorClass=Class Of TPropertyEditor;

    {$HINTS OFF}
    TStringPropertyEditor=Class(TPropertyEditor)
       Public
         Function Execute(Var Value:String;ValueLen:LongInt):TPropertyEditorReturn;Virtual;Abstract;
    End;

    TShortIntPropertyEditor=Class(TPropertyEditor)
       Public
         Function Execute(Var Value:ShortInt):TPropertyEditorReturn;Virtual;Abstract;
    End;

    TIntegerPropertyEditor=Class(TPropertyEditor)
       Public
         Function Execute(Var Value:Integer):TPropertyEditorReturn;Virtual;Abstract;
    End;

    TLongIntPropertyEditor=Class(TPropertyEditor)
       Public
         Function Execute(Var Value:LongInt):TPropertyEditorReturn;Virtual;Abstract;
    End;

    TClassPropertyEditorReturn=(peOk,peCancel,peClear,peNoEditor);

    TClassPropertyEditor=Class(TPropertyEditor)
      Private
         Property PropertyOwner;
         Property PropertyName;
         Property List;
      Public
         Function Execute(Var ClassToEdit:TObject):TClassPropertyEditorReturn;Virtual;
    End;
    TClassPropertyEditorClass=Class Of TClassPropertyEditor;
    {$HINTS ON}

    EClassNotFound=Class(Exception);


// Diverse Funktionen

Procedure RegisterClass(Const ComponentClass:TComponentClass);
Function GetClass(Const ClassName:String):TComponentClass;
Function FindClass(Const ClassName:String):TComponentClass;
Procedure UnRegisterClass(AClass:TComponentClass);
Procedure UnRegisterClasses(Const AClasses:Array of TComponentClass);
Procedure AddPropertyEditor(OwnerClass:TClass;PropertyName:String;PropertyEditor:TPropertyEditorClass);
Function CallPropertyEditor(Owner:TComponent;PropertyName:String;Var Value;ValueLen:LongInt;
                             Var List:TStringList):TPropertyEditorReturn;
Function PropertyEditorAvailable(OwnerClass:TClass;PropertyName:String):Boolean;

Procedure AddClassPropertyEditor(ClassToEdit:TClass;PropertyEditor:TClassPropertyEditorClass);
Function CallClassPropertyEditor(Var ClassToEdit:TObject):TClassPropertyEditorReturn;
Function ClassPropertyEditorAvailable(ClassName:String):Boolean;

Procedure AddDesignerPopupEvent(AString:TStringList;Caption:String;Id:LongInt);

Function InDesigner:Boolean;

// Allgemeine INI-Sections
Var AppIniFile : tIniFile;

Const
   INI_Sec_Program  = 'Program';
   INI_Sec_FormInfo = 'FormInfo';

Implementation

Uses uSysInfo;


// ---------- Original Langauge Sibyl Version

//!!!!!!!!!! bei nderungen auch Language Manager und SIB_DLG ndern!!!!!!!!!!!!!!!!!!!
Type
     PLanguageMessages=^TLanguageMessages;
     TLanguageMessages=Record
                         Name:PString;  //Language Name
                         StringTableLen:LongWord;
                         StringTable:Pointer;
                         Next:PLanguageMessages;
     End;

     PLanguageComponent=^TLanguageComponent;
     TLanguageComponent=Record
                         Name:PString;
                         OriginalInstance:TComponent;
                         Instance:TComponent;
                         ValueScope:Byte;
                         ValueTyp:Byte;
                         ValueRead:TPropertyReadWriteRecord;
                         ValueWrite:TPropertyReadWriteRecord;
                         ValueSize:LongWord;
                         ValueLen:LongWord;
                         Value:Pointer;
                         ControlLeft,ControlBottom:LongInt;
                         ControlWidth,ControlHeight:LongInt;
                         OrigControlLeft,OrigControlBottom:LongInt;
                         OrigControlWidth,OrigControlHeight:LongInt;
                         Next:PLanguageComponent;
     End;

     PLanguageItem=^TLanguageItem;
     TLanguageItem=Record
                         Name:PString;
                         Components:PLanguageComponent;
                         Menus:PLanguageComponent;
                         StringTables:PLanguageComponent;
                         Next:PLanguageItem;
     End;
//!!!!!!!!!! bei nderungen auch Language Manager ndern!!!!!!!!!!!!!!!!!!!
     PLanguageInfo=^TLanguageInfo;
     TLanguageInfo=Record
                         CurrentLanguageName:PString;  //only Copy !!
                         CurrentLanguageComponents:PLanguageComponent;  //only Copy !
                         CurrentLanguageMenus:PLanguageComponent; //only Copy !
                         CurrentLanguageStringTables:PLanguageComponent; //only Copy
                         Items:PLanguageItem;
     End;
//!!!!!!!!!! bei nderungen auch Language Manager und SIB_DLG ndern!!!!!!!!!!!!!!!!!!!
//////////////////////////////////////////////////////////////////////////////////////////////////////////

Var LanguageMessages: PLanguageMessages;
    AppLanguage     : String;

Procedure DestroyMessages;
Var dummy:PLanguageMessages;
Begin
  While LanguageMessages<>NIL Do
    Begin
          dummy:=LanguageMessages^.Next;
          If LanguageMessages^.Name<>Nil Then
            FreeMem(LanguageMessages^.Name,length(LanguageMessages^.Name^)+1);
          If LanguageMessages^.StringTable<>Nil Then
            FreeMem(LanguageMessages^.StringTable,LanguageMessages^.StringTableLen);
          Dispose(LanguageMessages);
          LanguageMessages:=dummy;
     End;
  LanguageMessages:=Nil;
  AppLanguage:='Default';
End;

Type TLanguageComponentKinds=(Captions,Menus,StringTables);


Procedure SetupLanguageComponents(Component:TComponent;Items:PLanguageComponent;Kind:TLanguageComponentKinds);
Var
    WriteTyp,ReadTyp:Byte;
    WriteOffset,ReadOffset:LongWord;
    ValueTyp:Byte;
    Info:TPropertyTypeInfo;
    S,s1:String;
    T:LongInt;
    Temp,Temp1:TComponent;
    p2:^LongWord;
    B:Byte;
    C:TObject;

    Procedure WriteInt(Const Name:String;Value:LongInt);
    Var Info:TPropertyTypeInfo;
    Begin
         If Temp.GetPropertyTypeInfo(Name,Info) Then
         Begin
              //Info available
              Case Info.Write.Kind Of
                 1:
                 Begin
                      p2:=Pointer(Temp);
                      Inc(p2,Info.Write.VarOffset);
                      System.Move(Value,p2^,Info.Size);
                 End;
                 2,3:
                 Begin
                      CallWriteProp(Temp,Pointer(Info.Write.VarOffset),
                                    Info.Typ,Info.Size,@Value);
                 End;
              End; //Case
         End;
    End;

Label skip;
Begin
     While Items<>Nil Do //process All Language Components
     Begin
          If ((Items^.ValueTyp<>0)And(Items^.ValueWrite.Kind<>0)And(Items^.Instance<>Nil)) Then //Read And Write information are Valid
          Begin
               ValueTyp:=Items^.ValueTyp;
               WriteTyp:=Items^.ValueWrite.Kind;
               WriteOffset:=Items^.ValueWrite.VarOffset;
               ReadTyp:=Items^.ValueRead.Kind;
               ReadOffset:=Items^.ValueRead.VarOffset;
               Temp:=Items^.Instance;
          End
          Else
          Begin
               Temp:=Component;
               S:=Items^.Name^;
               B:=Pos('.',S);
               While B<>0 Do
               Begin
                    s1:=Copy(S,1,B-1);
                    Delete(S,1,B);

                    Temp1:=Nil;
                    For T:=0 To Temp.ComponentCount-1 Do
                    Begin
                        Temp1:=Temp.Components[T];
                        If Temp1.Name=s1 Then
                        Begin
                             Temp:=Temp1;
                             break; //found !
                        End;
                        Temp1:=Nil;
                    End;
                    If Temp1=Nil Then Goto skip;  //Not found

                    B:=Pos('.',S);
               End;

               If Not Temp.GetPropertyTypeInfo(S,Info) Then Goto skip;

               Items^.Instance:=Temp;
               Items^.ValueRead:=Info.Read;
               Items^.ValueWrite:=Info.Write;
               Items^.ValueSize:=Info.Size;
               Items^.ValueTyp:=Info.Typ;
               ValueTyp:=Info.Typ;
               WriteTyp:=Info.Write.Kind;
               WriteOffset:=Info.Write.VarOffset;
               ReadTyp:=Info.Read.Kind;
               ReadOffset:=Info.Read.VarOffset;
          End;

          If ((ValueTyp=PropType_Class)And(Kind=StringTables)) Then
          Begin
               Case ReadTyp Of
                 0:Goto skip;
                 1:
                 Begin
                    p2:=Pointer(Temp);
                    Inc(p2,ReadOffset);
                    System.Move(p2^,C,4);
                 End;
                 2,3:
                 Begin
                    CallReadProp(Temp,Pointer(ReadOffset),
                                 ValueTyp,4,@C);
                End;
                Else Goto skip;
               End; //Case

               If Not (C Is TStrings) Then Goto skip;
               TStrings(C).SetText(Pointer(Items^.Value));
               Goto skip;
          End
          Else If ((ValueTyp<>PropType_String)And(ValueTyp<>PropType_CString)) Then Goto skip;

          //Info available
          Case WriteTyp Of
             1:
             Begin
                 p2:=Pointer(Temp);
                 Inc(p2,WriteOffset);
                 System.Move(Items^.Value^,p2^,Items^.ValueLen);
             End;
             2,3:
             Begin
                 CallWriteProp(Temp,Pointer(WriteOffset),
                               ValueTyp,
                               Items^.ValueLen,Items^.Value);
             End;
             Else Goto skip;
          End; //Case

          If Kind=Captions Then
            If Not (csForm In Temp.ComponentState) Then
          Begin
               //Write Language specific Position
               WriteInt('Left',Items^.ControlLeft);
               WriteInt('Bottom',Items^.ControlBottom);
               WriteInt('Width',Items^.ControlWidth);
               WriteInt('Height',Items^.ControlHeight);
          End;
skip:
          Items:=Items^.Next;
     End;
End;

Procedure GetLanguage(Component:TComponent;Var Language:String);
Var Info:PLanguageInfo;
Begin
   Info:=PLanguageInfo(Component.FLanguages);
   If ((Info=Nil)Or(Info^.CurrentLanguageName=Nil)) Then Language:='Default'
   Else Language:=Info^.CurrentLanguageName^;
End;

Procedure UpdateLanguageComponents(Items:PLanguageComponent;Kind:TLanguageComponentKinds);
Var
    ReadTyp:Byte;
    ReadOffset:LongWord;
    ValueTyp:Byte;
    Temp:TComponent;
    p2:^LongWord;
    C:TObject;
    P:PChar;
    S:String;

    Procedure ReadInt(Const Name:String;Var Value:LongInt);
    Var Info:TPropertyTypeInfo;
    Begin
         If Temp.GetPropertyTypeInfo(Name,Info) Then
         Begin
              //Info available
              Case Info.Read.Kind Of
                 1:
                 Begin
                      p2:=Pointer(Temp);
                      Inc(p2,Info.Read.VarOffset);
                      System.Move(p2^,Value,Info.Size);
                 End;
                 2,3:
                 Begin
                      CallReadProp(Temp,Pointer(Info.Read.VarOffset),
                                   Info.Typ,Info.Size,@Value);
                 End;
              End; //Case
         End;
    End;

Label skip;
Begin
     While Items<>Nil Do //process All Language Components
     Begin
          If ((Items^.ValueTyp<>0)And(Items^.ValueRead.Kind>0)And(Items^.Instance<>Nil)) Then
          Begin
               ValueTyp:=Items^.ValueTyp;
               ReadTyp:=Items^.ValueWrite.Kind;
               ReadOffset:=Items^.ValueRead.VarOffset;
               Temp:=Items^.Instance;

               If not (Temp Is TComponent) Then continue;

               Try
                  If ((ValueTyp=PropType_Class)And(Kind=StringTables)) Then
                  Begin
                       Case ReadTyp Of
                         0:Goto skip;
                         1:
                         Begin
                            p2:=Pointer(Temp);
                            Inc(p2,ReadOffset);
                            System.Move(p2^,C,4);
                         End;
                         2,3:
                         Begin
                            CallReadProp(Temp,Pointer(ReadOffset),
                                         ValueTyp,4,@C);
                        End;
                        Else Goto skip;
                       End; //Case

                       If Not (C Is TStrings) Then Goto skip;
                       P:=TStrings(C).GetText;
                       If Items^.ValueLen>0 Then FreeMem(Items^.Value,Items^.ValueLen);
                       If P=Nil Then
                       Begin
                            Items^.ValueLen:=0;
                            Items^.Value:=Nil;
                       End
                       Else
                       Begin
                            Items^.ValueLen:=Length(P^)+1;
                            GetMem(Items^.Value,Items^.ValueLen);
                            Move(P^,Items^.Value^,Items^.ValueLen);
                            StrDispose(P);
                       End;

                       Goto skip;
                  End
                  Else If ValueTyp<>PropType_String Then Goto skip;

                  //Info available
                  S:='';
                  Case ReadTyp Of
                     1:
                     Begin
                         p2:=Pointer(Temp);
                         Inc(p2,ReadOffset);
                         System.Move(p2^,S,Items^.ValueSize);
                     End;
                     2,3:
                     Begin
                         CallReadProp(Temp,Pointer(ReadOffset),
                                      ValueTyp,
                                      Items^.ValueSize,@S);
                     End;
                     Else Goto skip;
                  End; //Case

                  If Items^.ValueLen>0 Then FreeMem(Items^.Value,Items^.ValueLen);
                  Items^.ValueLen:=Length(S)+1;
                  GetMem(Items^.Value,Items^.ValueLen);
                  Move(S,Items^.Value^,Items^.ValueLen);

                  If Kind=Captions Then
                    If Not (csForm In Temp.ComponentState) Then
                  Begin
                       //Write Language specific Position
                       ReadInt('Left',Items^.ControlLeft);
                       ReadInt('Bottom',Items^.ControlBottom);
                       ReadInt('Width',Items^.ControlWidth);
                       ReadInt('Height',Items^.ControlHeight);
                  End;
               Except
               End;
          End;
skip:
          Items:=Items^.Next;
     End;
End;


Procedure SetLanguage(Component:TComponent;Language:String);
Var Info:PLanguageInfo;
    Item:PLanguageItem;
    S,s1,s2:String;
Begin
     Info:=PLanguageInfo(Component.FLanguages);
     If Info=Nil Then Exit;
     S:=Language;
     UpcaseStr(S);
     If Info^.CurrentLanguageName<>Nil Then
     Begin
          s1:=Info^.CurrentLanguageName^;
          UpcaseStr(s1);
          If S=s1 Then If S<>'DEFAULT' Then
          Begin
               Item:=Info^.Items;
               While Item<>Nil Do
               Begin
                    s1:=Item^.Name^;
                    UpcaseStr(s1);
                    If S=s1 Then Exit; //the Item Is present And Set !
                    Item:=Item^.Next;
               End;

               S:='DEFAULT';
          End;

          //Update old Language
          s1:=Info^.CurrentLanguageName^;
          UpcaseStr(s1);
          Item:=Info^.Items;
          While Item<>Nil Do
          Begin
               s2:=Item^.Name^;
               UpcaseStr(s2);
               If s1=s2 Then
               Begin
                    UpdateLanguageComponents(Item^.Components,Captions);
                    UpdateLanguageComponents(Item^.Menus,Menus);
                    UpdateLanguageComponents(Item^.StringTables,StringTables);
                    break;
               End;
               Item:=Item^.Next;
          End;
     End;

     Item:=Info^.Items;
     While Item<>Nil Do
     Begin
          s1:=Item^.Name^;
          UpcaseStr(s1);
          If S=s1 Then
          Begin
               SetupLanguageComponents(Component,Item^.Components,Captions);
               SetupLanguageComponents(Component,Item^.Menus,Menus);
               SetupLanguageComponents(Component,Item^.StringTables,StringTables);

               Info^.CurrentLanguageName:=Item^.Name;
               Info^.CurrentLanguageComponents:=Item^.Components;
               Info^.CurrentLanguageMenus:=Item^.Menus;
               Info^.CurrentLanguageStringTables:=Item^.StringTables;

               Exit;
          End;
          Item:=Item^.Next;
     End;
End;

Procedure GetAppLanguage(Var Language:String);
Begin
     Language:=AppLanguage;
End;

Procedure SetAppLanguage(Const Language:String);
Begin
     AppLanguage:=Language;
End;

Const
    {$IFDEF OS2}
    SCUVersion:String[5] = 'SCU01';
    {$ENDIF}
    {$IFDEF Win32}
    SCUVersion:String[5] = 'SCW01';
    {$ENDIF}

Var
    InsideCompLib:Boolean;
    InsideWriteSCU:Boolean;
    InsideWriteSCUAdr:^Boolean;
    InsideDesigner:Boolean;
//WDLng    InsideLanguageDesigner:Boolean;

Type
    PIDE_OwnerList=^TIDE_OwnerList;
    TIDE_OwnerList=Record
         PropertyName:PString;
         Objekt:TComponent;
    End;

    PIDE_Methods=^TIDE_Methods;
    TIDE_Methods=Record
         Name:PString;
         Params:PString;
         Owners:TList;
         Next:PIDE_Methods;
    End;

Function InDesigner:Boolean;
Begin
     Result:=InsideDesigner;
End;

Function GetInfoTag(iTag, iTagInfo : String; iTagList : tStringList) : String;

var TI    : String;
    pTag, TagInfoLen, TagLen : Byte;

Begin
  Result:=iTagInfo;
  iTagList.Clear;
  if (iTag='') or (iTagInfo='') then exit;

  pTag:=pos(iTag, iTagInfo);
  TagLen:=pTag + length(iTag);

  TI:=copy(iTagInfo, TagLen, 255);
  TagInfoLen:=pos(TagINI_End, TI) -1;   // -1 --> "]" entfernen
  TI[0]:=chr(TagInfoLen);
  SplitAll(TI, ';',iTagList);

  Result:=Copy(iTagInfo,1,pTag-1) + Copy(iTagInfo, pTag + TagLen + TagInfoLen +1,255);

End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: Some useful functions                                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function MessageBox2(Const Msg:String;Typ:TMsgDlgType;Buttons:TMsgDlgButtons):TMsgDlgReturn;
Var C,Title:cstring;
    iFlags:LongWord;
    mresult:LongWord;
Begin
     C:=Msg;

     {$IFDEF OS2}
     iFlags:=MB_MOVEABLE OR MB_APPLMODAL;

     If Typ=mtError Then
     Begin
          Title:=LoadNLSStr(SError);
          iFlags:=iFlags Or MB_ERROR;
     End
     Else If Typ=mtCritical Then
     Begin
          Title:=LoadNLSStr(SCriticalError);
          iFlags:=iFlags Or MB_CRITICAL;
     End
     Else If Typ=mtInformation Then
     Begin
          Title:=LoadNLSStr(sInformation);
          iFlags:=iFlags Or MB_INFORMATION;
     End
     Else If Typ=mtWarning Then
     Begin
          Title:=LoadNLSStr(SWarning);
          iFlags:=iFlags Or MB_WARNING;
     End
     Else If Typ=mtConfirmation Then
     Begin
          Title:=LoadNLSStr(SMessage);
          iFlags:=iFlags Or MB_ICONQUESTION;
     End
     Else
     Begin
          Title:=goSysInfo.ProgramInfo.Name;   // ParamStr(0);
          iFlags:=iFlags Or MB_NOICON;
     End;

     If Buttons*[mbOk]<>[] Then
     Begin
          If Buttons*[mbCancel]<>[] Then iFlags:=iFlags Or MB_OKCANCEL
          Else iFlags:=iFlags Or MB_OK;
     End
     Else If Buttons*[mbCancel]<>[] Then
     Begin
          If Buttons*mbYesNo<>[] Then iFlags:=iFlags Or MB_YESNOCANCEL
          Else If Buttons*[mbRetry]<>[] Then iFlags:=iFlags Or MB_RETRYCANCEL
          Else iFlags:=iFlags Or MB_CANCEL;
     End
     Else If Buttons*[mbYes]<>[] Then
     Begin
          If Buttons*[mbNo]<>[] Then iFlags:=iFlags Or MB_YESNO
          Else iFlags:=iFlags Or MB_OK;
     End;

     If Buttons*mbAbortRetryIgnore<>[] Then iFlags:=iFlags Or MB_ABORTRETRYIGNORE;

     InitPM;
     mresult:=WinMessageBox(HWND_DESKTOP,HWND_DESKTOP,C,Title,0,iFlags);

     Case mresult Of
         MBID_OK:Result:=mrOk;
         MBID_CANCEL:Result:=mrCancel;
         MBID_YES:Result:=mrYes;
         MBID_NO:Result:=mrNo;
         MBID_IGNORE:Result:=mrIgnore;
         MBID_ABORT:Result:=mrAbort;
         MBID_RETRY:Result:=mrRetry;
         Else Result:=mrCancel;
     End; {Case}
     {$ENDIF}

     {$IFDEF Win32}
     iFlags:=MB_TASKMODAL;

     If Typ=mtError Then
     Begin
          Title:=LoadNLSStr(SError);
          iFlags:=iFlags Or MB_ICONHAND;
     End
     Else If Typ=mtCritical Then
     Begin
          Title:=LoadNLSStr(SCriticalError);
          iFlags:=iFlags Or MB_ICONHAND;
     End
     Else If Typ=mtInformation Then
     Begin
          Title:=LoadNLSStr(sInformation);
          iFlags:=iFlags Or MB_ICONEXCLAMATION;
     End
     Else If Typ=mtWarning Then
     Begin
          Title:=LoadNLSStr(SWarning);
          iFlags:=iFlags Or MB_ICONEXCLAMATION;
     End
     Else If Typ=mtConfirmation Then
     Begin
          Title:=LoadNLSStr(SMessage);
          iFlags:=iFlags Or MB_ICONQUESTION;
     End
     Else
     Begin
          Title:=goSysInfo.ProgramInfo.Name; // ParamStr(0);
     End;

     If Buttons*[mbOk]<>[] Then
     Begin
          If Buttons*[mbCancel]<>[] Then iFlags:=iFlags Or MB_OKCANCEL
          Else iFlags:=iFlags Or MB_OK;
     End
     Else If Buttons*[mbCancel]<>[] Then
     Begin
          If Buttons*mbYesNo<>[] Then iFlags:=iFlags Or MB_YESNOCANCEL
          Else If Buttons*[mbRetry]<>[] Then iFlags:=iFlags Or MB_RETRYCANCEL
          Else iFlags:=iFlags Or MB_OK; //MB_CANCEL only Not present
     End
     Else If Buttons*[mbYes]<>[] Then
     Begin
          If Buttons*[mbNo]<>[] Then iFlags:=iFlags Or MB_YESNO
          Else iFlags:=iFlags Or MB_OK;
     End;

     If Buttons*mbAbortRetryIgnore<>[] Then iFlags:=iFlags Or MB_ABORTRETRYIGNORE;

     mresult:=WinUser.MessageBox(0,C,Title,iFlags);

     Case mresult Of
         IDOK:Result:=mrOk;
         IDCANCEL:Result:=mrCancel;
         IDYES:Result:=mrYes;
         IDNO:Result:=mrNo;
         IDIGNORE:Result:=mrIgnore;
         IDABORT:Result:=mrAbort;
         IDRETRY:Result:=mrRetry;
         Else Result:=mrCancel;
     End; {Case}
     {$ENDIF}
End;


Function ErrorBox2(Const Msg:String):TMsgDlgReturn;
Begin
     Beep(1000,200);
     Result:=MessageBox2(Msg,mtError,[mbOk]);
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: SCU File format types And records                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    PResourceEntry=^TResourceEntry;
    TResourceEntry=Record
                         ResName:TResourceName;
                         DataOffset:LongInt;
                         DataLen:LongInt;
                   End;

Function CompareResMem(Var Buf1,Buf2;Size:LongWord):Boolean;
Var R:Boolean;
Begin
     Asm
        MOV ESI,Buf1
        MOV EDI,Buf2
        MOV ECX,Size
        CLD
        REP
        CMPSB
        SETE AL
        MOV R,AL
     End;
     Result:=R;
End;

{$HINTS OFF}
Function TResourceStream.NewResourceEntry(Const ResName:TResourceName;
                                          Var Data;DataLen:LongInt):Boolean;
Var dummy:PResourceEntry;
    SavePos,T,HeadPos:LongInt;
    P:Pointer;
Label L;
Begin
     Result:=False;
     If DataLen=0 Then Exit;

     SavePos:=Position;
     HeadPos:=8;          {Initial Resource Header}
     If FResourceList<>Nil Then
     Begin
          For T:=0 To FResourceList.Count-1 Do
          Begin
               dummy:=FResourceList.Items[T];
               If dummy^.ResName=ResName Then
                 If dummy^.DataLen=DataLen Then
               Begin
                    Position:=dummy^.DataOffset;
                    P:=Pointer(Memory);     { Frueher: FBuffer); }
                    Inc(P,Position);
                    If CompareResMem(P^,Data,DataLen) Then
                    Begin
                         Position:=SavePos;
                         SavePos:=dummy^.DataOffset;
                         Goto L;
                    End;
               End;
               Inc(HeadPos,SizeOf(TResourceEntry));  {Length Of Info}
          End;
     End;
     Position:=SavePos;

     If Write(Data,DataLen)=0 Then Exit;

     //reserve A Header entry
     HeadPos:=FHeaderPos;
     Inc(FHeaderPos,SizeOf(TResourceEntry));  {Length Of Info}

     New(dummy);

     dummy^.ResName:=ResName;
     dummy^.DataOffset:=SavePos;
     dummy^.DataLen:=DataLen;

     If FResourceList=Nil Then FResourceList.Create;
     FResourceList.Add(dummy);
L:
     //Write Position Of Resource
     If SCUStream.Write(HeadPos,4)=0 Then Exit;

     Result:=True;
End;
{$HINTS ON}

Function TResourceStream.WriteResourcesToStream(Stream:TMemoryStream):Boolean;
Var T,t1:LongInt;
    PatchOffset,StartPos:LongInt;
    dummy:PResourceEntry;
    P:Pointer;
Begin
     Result:=False;
     If FResourceList=Nil Then
     Begin
          T:=0;  //no resources
          If Stream.Write(T,4)=0 Then Exit;
          Result:=True;
          Exit;
     End;

     StartPos:=Stream.Position;

     T:=FResourceList.Count;          //Count Of Resource entries
     If Stream.Write(T,4)=0 Then Exit;

     PatchOffset:=Stream.Position;
     T:=0;
     If Stream.Write(T,4)=0 Then Exit;  // Resource Data Offset patched later

     For T:=0 To FResourceList.Count-1 Do
     Begin
          dummy:=FResourceList.Items[T];
          If Stream.Write(dummy^,SizeOf(TResourceEntry))=0 Then Exit;
     End;

     //patch Offset To Resource Data
     T:=Stream.Position;
     Stream.Position:=PatchOffset;
     t1:=T-StartPos;
     If Stream.Write(t1,4)=0 Then Exit;
     Stream.Position:=T;

     //Write Resource Data

     P:=Memory;
     If Stream.Write(P^,Size)=0 Then Exit;

     Result:=True;
End;

Destructor TResourceStream.Destroy;
Var T:LongInt;
    dummy:PResourceEntry;
Begin
     If FResourceList<>Nil Then
     Begin
          For T:=0 To FResourceList.Count-1 Do
          Begin
               dummy:=FResourceList.Items[T];
               Dispose(dummy);
          End;
          FResourceList.Destroy;
          FResourceList := Nil;
     End;

     Inherited Destroy;
End;

Type
    TPropertyTyp=(TPropString,TPropSet,TPropLongInt,TPropEnum,
                  TPropClass);

    PSCUPropInit=^TSCUPropInit;
    TSCUPropInit=Record
                   PropertyName:String;
                   PropertySize:LongInt;
                   PropertyTyp:TPropertyTyp;
                   PropertyValue:Pointer;
    End;

    PSCUDesc=^TSCUDesc;
    TSCUDesc=Record
                   NextEntryOffset:LongInt;
                   ClassName:String;      //subclassed Class Name
                   BaseClassName:String;  //base Class Name For designer
                   PropertyCount:LongInt; //Count Of properties To initialize
                   properties:PSCUPropInit;
    End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TPersistent Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPersistent.AssignError(Source:TPersistent);
Var Msg:String;
Begin
     If Source=Nil Then Msg:='Nil'
     Else Msg:=Source.ClassName;
     Raise EConvertError.Create('Convert '+ClassName+' to '+Msg+'.');
End;

Procedure TPersistent.AssignTo(Dest:TPersistent);
Begin
     Dest.AssignError(Self);
End;

Procedure TPersistent.Assign(Source:TPersistent);
Begin
     If Source<>Nil Then Source.AssignTo(Self)
     Else AssignError(nil);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TComponent Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const //OldStyleFormat:Boolean=False;
      LastSCUForm:TComponent=Nil;

Function GetClassNameFromSCU(NameTable:Pointer;Namep:LongWord):String;
Var ps:^String;
Begin
     ps:=NameTable;
     Inc(ps,Namep);
     Result:=ps^;
End;

Function GetParentSCUFormDesign(Component:TComponent):TComponent;
Var AOwner:TComponent;
Begin
     Result:=Nil;
     AOwner:=Component;

     //Search For First parent that has Is A Form And TypeName match
     While AOwner <> Nil Do
     Begin
          //If AOwner.IDESCU_Data<>Nil Then
          If csForm In AOwner.ComponentState Then
          Begin
               Result:=AOwner;
               Exit;
          End;

          AOwner:=AOwner.FOwner;
     End;
     Result := Nil;   //Error
End;

Function GetParentSCUFormRuntime(Component:TComponent;Name:String):TComponent;
Var AOwner:TComponent;
    S:String;
Begin
     Result:=Nil;
     AOwner:=Component;
     UpcaseStr(Name);

     //Search For First parent that has TypeName match
     While AOwner <> Nil Do
     Begin
          S:=AOwner.ClassName;
          UpcaseStr(S);
          If S=Name Then
          Begin
               Result:=AOwner;
               Exit;
          End;
          AOwner:=AOwner.FOwner;
     End;
     Result := Nil;   //Error
End;

Procedure InsertSCUMethod(AParent,Objekt:TComponent;
                          ProcName,ProcParams,PropertyName:String);
Var Methods:PIDE_Methods;
    S,s2:String[64];
    s1,s3:String;
    Own:PIDE_OwnerList;
Label L;
Begin
     S:=ProcName;
     UpcaseStr(S);
     s1:=ProcParams;
     UpcaseStr(s1);
     s2:=PropertyName;
     UpcaseStr(s2);

     //look If method Is still here
     Methods:=AParent.FMethods;
     While Methods<>Nil Do
     Begin
          s3:=Methods^.Name^;
          UpcaseStr(s3);
          If s3=S Then  //ProcNames match
          Begin
               s3:=Methods^.Params^;
               UpcaseStr(s3);
               If s3=s1 Then  //Parameters match --> only Add To List
               Begin
                    Goto L;
               End;
          End;

          Methods:=Methods^.Next;
     End;

     //Insert New Item
     New(Methods);
     Methods^.Next:=AParent.FMethods;
     AParent.FMethods:=Methods;

     AssignStr(Methods^.Name,ProcName);
     AssignStr(Methods^.Params,ProcParams);
     Methods^.Owners.Create;
L:
     New(Own);
     AssignStr(Own^.PropertyName,PropertyName);
     Own^.Objekt:=Objekt;
     Methods^.Owners.Add(Own);
End;

Function GetSCUProcParamsFromName(Objekt:TComponent;PropertyName:String):String;
Var p1:^LongWord;
    B:Byte;
    S,s1:String;
    ps:^String;
    pParent:Pointer;
    Scope:Byte;
    NameIndex:LongInt;
    NameTable:^String;
Label L,ex,again;
Begin
     //Search PropertyName
     UpcaseStr(PropertyName);
     p1:=Objekt.ClassInfo;
again:
     //overread Object Size
     Inc(p1,4);
     pParent:=Pointer(p1^);
     Inc(p1,8);               //onto First Property Name
     p1:=Pointer(p1^);
     Inc(p1,4);               //overread End Ptr
     NameTable:=Pointer(p1^); //Name Table Of Class
     Inc(p1,4);               //overread Name Table poinzer

     NameIndex:=p1^ AND longword(255);
     Inc(p1);
     While NameIndex<>0 Do
     Begin
          s1[0]:=Chr(NameIndex);
          Move(p1^,s1[1],NameIndex);
          Inc(p1,NameIndex);

          Scope:=p1^ AND longword(255);
          Inc(p1);
          If Scope And 16=16 Then  //stored ??
          Begin
               UpcaseStr(s1);
               If s1=PropertyName Then  //found
               Begin
                   p1:=Pointer(p1^);   //Type information

                   //overread Property access Info
                   If p1^ AND longword(255)<>0 Then Inc(p1,5)
                   Else Inc(p1);
                   If p1^ AND longword(255)<>0 Then Inc(p1,5)
                   Else Inc(p1);

                   //overread Property Type len
                   Inc(p1,4);

                   //Get Property Type
                   B:=p1^ AND longword(255);
                   If Not (B In [PropType_ProcVar,PropType_FuncVar]) Then Goto ex;  //Error
                   Inc(p1);
                   Goto L;
               End;
          End;

          Inc(p1,4);    //overread Type information Pointer
          NameIndex:=p1^ AND longword(255);
          Inc(p1);
     End;

     If pParent<>Nil Then
     Begin
          p1:=pParent;
          Inc(p1,4);
          p1:=Pointer(p1^);  //ClassInfo
          Goto again;
     End;
ex:
     Result:='?';
     Exit;  //Not found;
L:
     NameIndex:=p1^;
     Inc(p1,4);
     S:='';
     While NameIndex<>0 Do
     Begin
          If S<>'' Then S:=S+';';
          ps:=NameTable+NameIndex;
          s1:=ps^;

          B:=p1^ AND longword(255);
          Inc(p1);
          Case B Of
            1:s1:='VAR '+s1;
            2:;
            3:s1:='CONST '+s1;
          End;

          S:=S+s1;
          NameIndex:=p1^;  //TypeName
          Inc(p1,4);
          If NameIndex<>0 Then
          Begin
               ps:=NameTable+NameIndex;
               s1:=ps^;
               S:=S+':'+s1;
          End;

          NameIndex:=p1^;
          Inc(p1,4);
     End; //While

     If S<>'' Then Result:='('+S+');'
     Else Result:=S;
End;


Type PPropertyLink=^TPropertyLink;
     TPropertyLink=Record
                         SelfPtr:TComponent;
                         Owner:TComponent;
                         WriteTyp:Byte;
                         WriteOffset:LongInt;
                         //WriteName:String[64];
                         LinkName:String[64];
                         Next:PPropertyLink;
     End;

Const PropertyLinks:PPropertyLink=Nil;

Function GetPropertyTypeInfo2(Instance:TComponent;PropertyName:String;Var Info:TPropertyTypeInfo):Boolean;
Var L :^LongWord;
    C :^LongWord;    // Altuelle Class-Info
    ps:^String;
    S :String;
Label weiter;

Begin
     Result:=False;
     UpcaseStr(PropertyName);

     L:=Pointer(Instance);
     L:=Pointer(L^);  //VMT address
     
     While L<>Nil Do
     Begin
     
{$IFDEF SPDLL30W32}
          Inc(L,4);
          L:=Pointer(L + L^);  //Class Info
          C:=L;
          Inc(L,12);
          L:=Pointer(L + L^);  //Property Info
          Inc(L,4);
          Info.NameTable:=Pointer(L + L^);
          Inc(L,4);        //Start Of properties
          ps:=Pointer(L);
          While ps^[0]<>#0 Do
          Begin
               If ps^[0]=PropertyName[0] Then  //found !!
               Begin
                    S:=ps^;
                    UpcaseStr(S);
                    If S=PropertyName Then
                    Begin
                         Result:=True;
                         Inc(L,Ord(ps^[0])+1); //skip Name
                         Info.Scope:=L^ AND longword(255);

                         Inc(L);
                         L:=Pointer(L^);     //Type And access Info

                         If ((Info.Scope And 24=0)Or(L=Nil)) Then
                         Begin
                              L:=Pointer(ps);
                              Goto weiter;   //Search also parent !
                         End;

                         Info.PropInfo:=Pointer(L);
                         Info.Read.Kind:=L^ AND longword(255);
                         Inc(L);
                         If Info.Read.Kind<>0 Then
                         Begin
                           case Info.Read.Kind of
                             1,3: Info.Read.VarOffset:=L^;
                             2  : Info.Read.VarOffset:=LongWord(L) + L^;
                           End;
                           Inc(L,4);
                         End;
                         
                         Inc(L,2);

                         Info.Write.Kind:=L^ AND longword(255);
                         Inc(L);
                         If Info.Write.Kind<>0 Then
                         Begin
                           case Info.Write.Kind of
                             1,3: Info.Write.VarOffset:=L^;
                             2  : Info.Write.VarOffset:=LongWord(L) + L^;
                           End;
                           Inc(L,4);
                         End;
                         
                         Inc(L,2);
                         
                         Info.Size:=L^;
                         Inc(L,4);
                         Info.TypeInfo:=Pointer(L);
                         Info.Typ:=L^ AND longword(255);

                         Exit;
                    End;
               End;
weiter:
               Inc(L,Ord(ps^[0])+6);    //skip This entry
               ps:=Pointer(L);
          End;

          Inc(C,4);
          L:=Pointer(C + C^);     // Position von Funktion "GetVMT"
          L:=GetVMTCall(L);       //parent VMT Or Nil
     {$ELSE}
          Inc(L,4);
          L:=Pointer(L^);  //Class Info
          C:=L;
          Inc(L,12);
          L:=Pointer(L^);  //Property Info
          Inc(L,4);
          Info.NameTable:=Pointer(L^);
          Inc(L,4);        //Start Of properties
          ps:=Pointer(L);
          While ps^[0]<>#0 Do
          Begin
               If ps^[0]=PropertyName[0] Then  //found !!
               Begin
                    S:=ps^;
                    UpcaseStr(S);
                    If S=PropertyName Then
                    Begin
                         {$IFDEF SPDLL30OS2}
                         Result:=True;
                         Inc(L,Ord(ps^[0])+1); //skip Name
                         Info.Scope:=L^ AND longword(255);

                         Inc(L);
                         L:=Pointer(L^);     //Type And access Info

                         If ((Info.Scope And 24=0)Or(L=Nil)) Then
                         Begin
                              L:=Pointer(ps);
                              Goto weiter;   //Search also parent !
                         End;

                         Info.PropInfo:=Pointer(L);
                         Info.Read.Kind:=L^ AND longword(255);
                         Inc(L);
                         If Info.Read.Kind<>0 Then
                         Begin
                           case Info.Read.Kind of
                             1,3: Info.Read.VarOffset:=L^;
                             2  : Info.Read.VarOffset:=LongWord(L);
                           End;
                           Inc(L,4);
                         End;
                         
                         Inc(L,2);
                         
                         Info.Write.Kind:=L^ AND longword(255);
                         Inc(L);
                         If Info.Write.Kind<>0 Then
                         Begin
                           case Info.Write.Kind of
                             1,3: Info.Write.VarOffset:=L^;
                             2  : Info.Write.VarOffset:=LongWord(L);
                           End;
                           Inc(L,4);
                         End;
                         
                         Inc(L,2);
                         
                         Info.Size:=L^;
                         Inc(L,4);
                         Info.TypeInfo:=Pointer(L);
                         Info.Typ:=L^ AND longword(255);
                         {$ELSE}
                         Result:=True;
                         Inc(L,Ord(ps^[0])+1); //skip Name
                         Info.Scope:=L^ AND longword(255);

                         Inc(L);
                         L:=Pointer(L^);     //Type And access Info

                         If ((Info.Scope And 24=0)Or(L=Nil)) Then
                         Begin
                              L:=Pointer(ps);
                              Goto weiter;   //Search also parent !
                         End;

                         Info.PropInfo:=Pointer(L);
                         Info.Read.Kind:=L^ AND longword(255);
                         Inc(L);
                         If Info.Read.Kind<>0 Then
                         Begin
                              Info.Read.VarOffset:=L^;
                              Inc(L,4);
                         End;
                         Info.Write.Kind:=L^ AND longword(255);
                         Inc(L);
                         If Info.Write.Kind<>0 Then
                         Begin
                              Info.Write.VarOffset:=L^;
                              Inc(L,4);
                         End;
                         Info.Size:=L^;
                         Inc(L,4);
                         Info.TypeInfo:=Pointer(L);
                         Info.Typ:=L^ AND longword(255);
                         {$ENDIF}

                         Exit;
                    End;
               End;
weiter:
               Inc(L,Ord(ps^[0])+6);    //skip This entry
               ps:=Pointer(L);
          End;

          Inc(C,4);
          {$IFDEF SPDLL30OS2}
          L:=Pointer(C^);
          L:=GetVMTCall(L);  //parent VMT Or Nil
          {$ELSE}
          L:=Pointer(C^);  //parent VMT Or Nil
          {$ENDIF}
     {$ENDIF}
     End;
End;

Function GetReference(Owner:TComponent):TComponent;
Begin
     Result:=Owner.FReference;
End;

Procedure SetReference(Owner,Ref:TComponent);
Begin
     Owner.FReference:=Ref;
End;


{$HINTS OFF}
Procedure TComponent.UpdateLinkList(Const PropertyName:String;LinkList:TList);
Begin
     //LinkList Is A List Of TComponent Instances that the Inspector
     //will display For the specified Property, you may only Remove Items !
End;
{$HINTS ON}


Type SCUTypes=(SCUNull,SCUByte,SCUWord,SCULongWord,SCUShortInt,SCUInteger,SCULongInt,SCUSingle,
               SCUDouble,SCUExtended,SCUByteBool,SCUWordBool,SCULongBool,SCUString,
               SCUCString,SCURecord,SCUSet4,SCUSet32,SCUEnum,SCUProcVar,SCUFuncVar,SCUClassVar,
               SCULink,SCUClass,SCUChar,SCUBinary);


{$HINTS OFF}
Function TComponent.ReadPropertiesSCU(COwner:TComponent;Namep,Resourcep:Pointer;Var ClassPointer:Pointer):Boolean;
// Liest die Properties der Komponente ein.

Var P,p2:^LongInt;
    B:Byte;
    tt,TypeLen:LongInt;
    Typ:Byte;
    WriteTyp:Byte;
    WriteOffset,PropNameOffset:LongInt;
    Value,Temp:Pointer;
    TypeName,ProcName,PropertyName:String[64];
    ProcParams:String;
    ActComponentClass:TComponentClass;
    Proc:Pointer;
    AParent:TComponent;
    dummy:PPropertyLink;
    Error:Boolean;
    Info:TPropertyTypeInfo;
    InheritedComp:TComponent;
    SectionLen:LongWord;
    SCUTyp:SCUTypes;
Label L,err;
Begin
     Result:=False;
     P:=ClassPointer;
     SectionLen:=P^;
     Inc(P,4);  //overread Property section len
L:
     Error:=False;
     B:=P^ AND longword(255);  //properties avail ?
     Inc(P);
     If ((B=1)Or(B=2)) Then
     Begin
          //there follows A Property entry - we are At Name Index
          PropNameOffset:=P^;
          Inc(P,4);

          SCUTyp:=SCUNull;
          System.Move(P^,SCUTyp,1);
          Inc(P);
          If ((SCUTyp=SCURecord)Or(SCUTyp=SCUBinary)) Then
          Begin
               System.Move(P^,TypeLen,4);
               Inc(P,4);
          End;

          PropertyName:=GetClassNameFromSCU(Namep,PropNameOffset);
          If Not GetPropertyTypeInfo2(Self,PropertyName,Info) Then
          Begin
               //evtll schon beim Rausschreiben skippen
               ErrorBox2(FmtLoadNLSStr(SPropertyNotFound,[PropertyName,ClassName])+' !'#13+
                         LoadNLSStr(SPropertySkipped));
               Case SCUTyp Of
                   SCUByte,SCUShortInt,SCUByteBool,SCUChar:Inc(P,1);
                   SCUWord,SCUInteger,SCUWordBool:Inc(P,2);
                   SCULongWord,SCULongInt,SCULongBool,SCUSingle:Inc(P,4);
                   SCUDouble:Inc(P,8);
                   SCUExtended:Inc(P,10);
                   SCUString:Inc(P,(P^ AND longword(255))+1);
                   SCUCString:
                   Begin
                        While (P^ AND longword(255))<>0 Do Inc(P);
                        Inc(P); //skip #0
                   End;
                   SCULink:Inc(P,4);  //Name Index
                   SCURecord,SCUBinary:Inc(P,TypeLen);
                   SCUSet4:Inc(P,4);
                   SCUSet32:Inc(P,32);
                   SCUEnum:Inc(P,4);
                   SCUProcVar,SCUFuncVar:Inc(P,12); //Owner,method,Property Name Index
                   {SCUClassVar:Inc(P,4);
                   SCUClass:Inc(P,4);}
                   Else Goto err; //Error !
               End;
               Goto L;  //Until All properties Read
err:
               Inc(ClassPointer,SectionLen);
               Result:=True;
               Exit;
          End;

          TypeLen:=Info.Size;
          Typ:=Info.Typ;
          WriteTyp:=Info.Write.Kind;
          WriteOffset:=Info.Write.VarOffset;

          Case WriteTyp Of
              1,2,3:;
              Else If Typ<>PropType_Class Then
              Begin
                   ErrorBox2(FmtLoadNLSStr(SPropertyReadOnly,[PropertyName])+'. '+
                             LoadNLSStr(SPropertySkipped)+'.');
                   Error:=True;
              End;
          End; {Case}

          If B=2 Then //Link
          Begin
               Typ:=PropType_Link;
          End;

          If Typ=PropType_String Then //String
          Begin
               B:=P^ AND longword(255);
               TypeLen:=longint(B)+1;{Martin0207}
          End;

          Case Typ Of
            PropType_Class: //Class
            Begin
                 //Get Value Of the Property
                 Case Info.Read.Kind Of
                   1:
                   Begin
                        GetMem(Value,TypeLen);
                        p2:=Pointer(Self);
                        Inc(p2,Info.Read.VarOffset);
                        Move(p2^,Value^,TypeLen);
                   End;
                   2,3:
                   Begin
                        GetMem(Value,TypeLen);
                        If Not CallReadProp(Self,Pointer(Info.Read.VarOffset),Typ,TypeLen,Value) Then
                        Begin
                            ErrorBox2('SCU Error 3: '+FmtLoadNLSStr(SCouldNotReadFromProperty,[PropertyName])+'.');
                            FreeMem(Value,TypeLen);
                            Exit;
                        End;
                   End;
                   Else
                   Begin
                        ErrorBox2(FmtLoadNLSStr(SCouldNotReadFromProperty,[PropertyName])+'.');
                        Goto err;
                   End;
                 End;

                 System.Move(Value^,InheritedComp,4);
                 If InheritedComp=Nil Then
                 Begin
                      ErrorBox2('Property '+Name+'.'+PropertyName+' is NIL');
                      FreeMem(Value,TypeLen);
                      Goto err;
                 End;

                 If Not InheritedComp.ReadPropertiesSCU(COwner,Namep,Resourcep,P) Then
                 Begin
                      ErrorBox2('Property '+Name+'.'+PropertyName+' could not be initialized');
                      FreeMem(Value,TypeLen);
                      Goto err;
                 End;
                 Error:=True; {!!}
            End;
            PropType_ProcVar,PropType_FuncVar:  //ProcVar,FuncVar
            Begin
                 tt:=P^;
                 Inc(P,4);
                 TypeName:='T'+GetClassNameFromSCU(Namep,tt);
                 tt:=P^;
                 Inc(P,4);
                 ProcName:=GetClassNameFromSCU(Namep,tt);
                 tt:=P^;
                 Inc(P,4);
                 PropertyName:=GetClassNameFromSCU(Namep,tt);

                 If TypeLen<>8 Then Exit;  //Of Object !!

                 GetMem(Value,TypeLen);

                 If (InsideDesigner) then //WDLng Or(InsideLanguageDesigner)) Then
                 Begin
                      //Owner IDESCU_Data suchen !
                      AParent:=GetParentSCUFormDesign(Self);
                      If AParent=Nil Then Exit; //Error
                      //Proc In AParent IDESCU_Data einfgen

                      ProcParams:=GetSCUProcParamsFromName(Self,PropertyName);
                      If ProcParams='?' Then
                      Begin
                           ErrorBox2(FmtLoadNLSStr(SPropError,[PropertyName]));
                           Error:=True;
                      End
                      Else InsertSCUMethod(AParent,Self,ProcName,ProcParams,PropertyName);
                      FillChar(Value^,TypeLen,0);  {!!}
                 End
                 Else
                 Begin
                      //Search For TypeName.ProcName
                      //dazu In SetupSCU alle Forms mit RegisterClasses registrieren
                      ActComponentClass:=SearchClassByName(TypeName);
                      If ActComponentClass=Nil Then
                      Begin
                           ErrorBox2('SCU Error 1: '+FmtLoadNLSStr(SComponentNotFound,[TypeName])+'.'#13+
                                     LoadNLSStr(SUseRegisterClasses));
                           Error:=True;
                      End
                      Else
                      Begin
                           //Get Object For that method
                           AParent:=GetParentSCUFormRuntime(Self,TypeName);
                           If AParent=Nil Then
                           Begin
                                ErrorBox2(FmtLoadNLSStr(SSCUErrorInClass,[TypeName]));
                                Error:=True;
                           End
                           Else
                           Begin
                                Proc:=AParent.MethodAddress(ProcName);
                                If Proc=Nil Then
                                Begin
                                     ErrorBox2(FmtLoadNLSStr(SMethodNotFound,[ProcName,ClassName]));
                                     Error:=True;
                                End
                                Else
                                Begin
                                     //Proc Adresse setzen
                                     Move(Proc,Value^,4);
                                     Inc(Value,4);
                                     //method Object Pointer setzen
                                     Move(AParent,Value^,4);
                                     Dec(Value,4);
                                End;
                           End;
                      End;
                 End;
            End;
            PropType_Link: //Link
            Begin
                 If ComponentState*[csForm]<>[] Then
                   If PropertyName='Menu' Then
                 Begin
                     Include(ComponentState,csHasMainMenu);
                 End;

                 //Name Of Property To Link
                 tt:=P^;
                 Inc(P,4);
                 PropertyName:=GetClassNameFromSCU(Namep,tt);

                 If PropertyLinks=Nil Then
                 Begin
                      New(PropertyLinks);
                      dummy:=PropertyLinks;
                      dummy^.Next:=Nil;
                 End
                 Else
                 Begin
                      New(dummy);
                      dummy^.Next:=PropertyLinks;
                      PropertyLinks:=dummy;
                 End;
                 dummy^.SelfPtr:=Self;
                 dummy^.Owner:=COwner;
                 dummy^.WriteTyp:=WriteTyp;
                 dummy^.WriteOffset:=WriteOffset;
                 dummy^.LinkName:=PropertyName;
                 Goto L; //dont Write here
            End;
            Else
            Begin
                 GetMem(Value,TypeLen);
                 Move(P^,Value^,TypeLen);
                 Inc(P,TypeLen);
            End;
          End; {Case}

          If Not Error Then
             Case WriteTyp Of
               1:
               Begin
                    p2:=Pointer(Self);
                    Inc(p2,WriteOffset);
                    Move(Value^,p2^,TypeLen);
               End;
               2,3:
               Begin
                    If Not CallWriteProp(Self,Pointer(WriteOffset),Typ,TypeLen,Value) Then
                    Begin
                         ErrorBox2('SCU Error 3: '+FmtLoadNLSStr(SCouldNotWriteToProperty,[PropertyName])+' !');
                    End;
               End;
               Else Goto err;  //Some Error
             End;

          FreeMem(Value,TypeLen);

          Goto L;  //Until All properties Read
     End
     Else If B<>0 Then Exit;  //Some Error
     ClassPointer:=P;
     Result:=True;
End;
{$HINTS ON}


Procedure TComponent.ReadResourceSCU(ResourceTable:Pointer;Var ClassP:Pointer);
Var DataOfs:LongWord;
    P:^LongWord;
    ps:PString;
    ResName:TResourceName;
    Data:Pointer;
    DataLen:LongInt;
    pp:^LongWord;
    DOfs:LongWord;
    reshead:LongWord;
Label L;
Begin
L:
  pp:=ClassP;
  Inc(ClassP,4);
  reshead:=pp^;
  If reshead=0 Then Exit; {no resources For This Component}

  P:=ResourceTable+4;  //onto Resource Data Offset
  DataOfs:=P^;

  P:=ResourceTable;
  Inc(P,reshead);      {Offset To Resource Header}

  {process Resource Header}
  ps := PString(P);
  ResName := TResourceName(ps^);
  Inc(P,SizeOf(TResourceName));
  Data:=ResourceTable;
  DOfs:=P^;
  Inc(Data,DataOfs+DOfs);  //Start Of Resource information
  Inc(P,4);
  DataLen:=P^;
  Inc(P,4);
  //Load resources For This Component
  ReadSCUResource(ResName,Data^,DataLen);
  Goto L; {Until no more resources For This}
End;


Procedure HandlePropertyLinks(Component:TComponent);
Var dummy,Next:PPropertyLink;
    P,p2:Pointer;
    T,t1:LongInt;
    Comp,Comp1,Comp2:TComponent;
    S:String;
Label found,again;
Begin
     dummy:=PropertyLinks;
     While dummy<>Nil Do
     Begin
          UpcaseStr(dummy^.LinkName);
          P:=Nil;
          Comp1:=Component;
again:
          For T:=0 To Comp1.ComponentCount-1 Do
          Begin
               Comp:=Comp1.Components[T];

               If csReferenceControl In Comp.ComponentState Then continue;

               If Comp Is TComponent Then
               Begin
                    S:=Comp.Name;
                    UpcaseStr(S);
                    If S=dummy^.LinkName Then
                    Begin
                        P:=@Comp;
                        Goto found;
                    End;
               End;

               For t1:=0 To Comp.ComponentCount-1 Do
               Begin
                   Comp2:=Comp.Components[t1];

                   If csReferenceControl In Comp2.ComponentState Then continue;

                   If Comp2 Is TComponent Then
                   Begin
                        S:=Comp2.Name;
                        UpcaseStr(S);
                        If S=dummy^.LinkName Then
                        Begin
                            P:=@Comp2;
                            Goto found;
                        End;
                   End;
               End;
          End;

          Comp1:=Comp1.Owner;
          If Comp1<>Nil Then Goto again;
found:
          If P<>Nil Then
          Begin
               Case dummy^.WriteTyp Of
                 1:
                 Begin
                     p2:=Pointer(dummy^.SelfPtr);
                     Inc(p2,dummy^.WriteOffset);
                     Move(P^,p2^,4);
                 End;
                 2,3:  //method call (direct Or VMT)
                 Begin
                     If Not CallWriteProp(dummy^.SelfPtr,Pointer(dummy^.WriteOffset),PropType_Unsigned,4,P) Then
                     Begin
                     End;
                 End;
               End; {Case}
          End;

          dummy:=dummy^.Next;
     End;

     dummy:=PropertyLinks;
     While dummy<>Nil Do
     Begin
          If dummy^.SelfPtr=Nil Then
          Begin
               ErrorBox2('SCU Error: '+FmtLoadNLSStr(SLinkNotFound,[dummy^.LinkName])+' !');
          End;

          If ((dummy^.SelfPtr<>Nil)And(dummy^.SelfPtr.FComponentState*[csLoaded]=[])) Then
          Begin
               dummy^.SelfPtr.LoadedFromSCU(dummy^.Owner);
               dummy^.SelfPtr.Loaded;
          End;

          Next:=dummy^.Next;
          Dispose(dummy);
          dummy:=Next;
     End;

     PropertyLinks:=Nil;
End;


Function TComponent.ReadComponentsSCU(NameTable,ResourceTable:Pointer;Var ClassP:Pointer):Boolean;
Var ChildCount,T:LongInt;
    NameIndex,NameIndex1:LongInt;
    ComponentClass:TComponentClass;
    Component:TComponent;
    S,s1:String[64];
    ClassPointer:^LongWord;
    B:Byte;
    P:Pointer;
    RemoveReferenceButton:Boolean;
    ChildIsReferenceButton:Boolean;
    SavePropertyLinks,dummy:PPropertyLink;
    idx:LongInt;
    Ref:TComponent;
    LastReference:TComponent;

    Procedure SkipChildComponents;
    Var t1,Count:LongInt;
        B:Byte;
    Begin
         Count:=ClassPointer^;
         Inc(ClassPointer,4);
         For t1:=1 To Count Do //skip All Child Components
         Begin
              Inc(ClassPointer,4);  //skip Name Index
              B:=ClassPointer^ AND longword(255);
              Inc(ClassPointer);
              If B=1 Then  {runtime Class Name differs from Inspector Class Name}
              Begin
                   Inc(ClassPointer,4);  //skip NameIndex
              End;

              {overread Property section}
              Inc(ClassPointer,ClassPointer^);

              {overread Components section}
              SkipChildComponents; //overread All Child Components

              {overread Resource section}
              While ClassPointer^<>0 Do Inc(ClassPointer,4);
              Inc(ClassPointer,4);  {overread 0}
         End;
    End;

Label skip,skipIt;
Begin
     Result:=False;
     SavePropertyLinks:=PropertyLinks;
     PropertyLinks:=Nil;
     ClassPointer:=ClassP;
     ChildCount:=ClassPointer^;
     Inc(ClassPointer,4);
     LastReference:=Nil;
     For T:=1 To ChildCount Do
     Begin
          NameIndex:=ClassPointer^;
          Inc(ClassPointer,4);
          S:=GetClassNameFromSCU(NameTable,NameIndex); {Of the New Child}

          RemoveReferenceButton := False;
          ChildIsReferenceButton := False;
          If S = 'TReferenceWindow' Then
          Begin
               ChildIsReferenceButton := True;
               If Not InsideDesigner Then RemoveReferenceButton := True;
          End;
          s1 := '';

          {check If runtime Class Name Is avail}
          B:=ClassPointer^ AND longword(255);
          Inc(ClassPointer);
          If B=1 Then  {runtime Class Name differs from Inspector Class Name}
          Begin
               NameIndex1:=ClassPointer^;
               Inc(ClassPointer,4);
               s1:=GetClassNameFromSCU(NameTable,NameIndex1);
               {Use runtime Class Name To Create the Class}
               If Not (InsideDesigner) then //WDLng Or(InsideLanguageDesigner)) Then
                 If s1 <> '' Then S := s1; {!!}
          End;

          {note: runtime Class Names MUST be registered In Form Unit Or
                 main Program Of an Application !!}

          If RemoveReferenceButton Then ComponentClass:=SearchClassByName('TCONTROL')
          Else ComponentClass:=SearchClassByName(S);

          If ComponentClass=Nil Then
          Begin
               ErrorBox2('SCU Error 2: '+FmtLoadNLSStr(SComponentNotFound,[S])+'.'#13 +
                         LoadNLSStr(SUseRegisterClasses)+' !');
               Goto skipIt;
          End;

          {C R E A T E  the Child Object}
          FCreateFromSCU := True;
          Component := ComponentClass.Create(LastSCUForm);
          FCreateFromSCU := False;

          {zur Sicherheit}
          If ChildIsReferenceButton Then
            If Not RemoveReferenceButton Then
          Begin {Predecessor Is the Reference -> Set the flag}
               idx := LastSCUForm.IndexOfComponent(LastReference);
               If idx >= 0 Then
               Begin
                    Ref := LastSCUForm.Components[idx];
                    Include(Ref.ComponentState, csReference); {!}
               End;
          End;

          Component.SetDesigning(InsideDesigner); // WDLng Or InsideLanguageDesigner);
          Component.LoadingFromSCU(Self);

          If (InsideDesigner) then // WDLng Or(InsideLanguageDesigner)) Then
          {Set TypeName And IDESCU_Data}
            If s1<>'' Then
            Begin
                 Component.TypeName:=s1;
                 Component.FMethods:=Nil; {no Methods defined}
            End;

          If RemoveReferenceButton Then
          Begin
               Component.Destroy;   {besser gar nicht erst erzeugen}
skipIt:
               {overread Property section}
               Inc(ClassPointer,ClassPointer^);

               {overread Components section}
               SkipChildComponents; //overread All Child Components

               {overread Resource section}
               While ClassPointer^<>0 Do Inc(ClassPointer,4);
               Inc(ClassPointer,4);  {overread 0}

               continue;
          End
          Else
          Begin
               If Not Component.ReadPropertiesSCU(Self,NameTable,ResourceTable,ClassPointer) Then Exit;
               If Not Component.ReadComponentsSCU(NameTable,ResourceTable,ClassPointer) Then Exit;
               Component.ReadResourceSCU(ResourceTable,ClassPointer);
          End;


          If Not (InsideDesigner) then // WDLng Or(InsideLanguageDesigner)) Then
          Begin
               {Set Object variable If present}
               P := LastSCUForm.FieldAddress(Component.Name);
               If P <> Nil Then Move(Component,P^,4);
          End;

          //If This Component expects A Link Then we don't call Loaded unless the
          //Link Is established
          dummy:=PropertyLinks;
          While dummy<>Nil Do
          Begin
               If dummy^.SelfPtr=Component Then Goto skip;
               dummy:=dummy^.Next;
          End;

          If Component.FComponentState*[csLoaded]=[] Then
          Begin
               If ChildIsReferenceButton Then
               Begin
                    //Set the Reference
                    Component.FReference:=LastReference;
                    Include(LastReference.ComponentState,csReference);
                    Component.LoadedFromSCU(Self);
               End
               Else Component.LoadedFromSCU(Self);
               Component.Loaded;
          End;
skip:
          //This Is the Last Reference Window
          //we have To Store it because it may contain Child Items...
          LastReference:=Component;
     End;

     If PropertyLinks<>Nil Then
     Begin
          dummy:=PropertyLinks;
          While dummy^.Next<>Nil Do dummy:=dummy^.Next;
          dummy^.Next:=SavePropertyLinks;  {Append}
     End
     Else PropertyLinks:=SavePropertyLinks;

     ClassP:=ClassPointer;
     Result:=True;
End;


Function SearchClassSCU(Data:Pointer;NameToFind:String;ObjectCount:LongInt;ClassUnit:String):Pointer;
Var dummy:^LongWord;
    len:LongWord;
    Count:LongInt;
    ps:^String;
    S,D,N,E:String;
Label L;
Begin
     Result:=Nil;
     Count:=0;
     UpcaseStr(ClassUnit);
L:
     If Count>=ObjectCount Then Exit;
     dummy:=Data;
     len:=dummy^;   //len Of This entry
     Inc(dummy,4);  //onto Inspector Class Name
     Inc(dummy,(dummy^ AND longword(255))+1); //overread Inspector Name
     ps:=Pointer(dummy);     //runtime Class Name
     S:=ps^;
     UpcaseStr(S);
     If S=NameToFind Then
     Begin
          Inc(ps,Length(S)+1);               //ON Unit Name
          S:=ps^;
          UpcaseStr(S);
          FSplit(S,D,N,E);
          If N=ClassUnit Then
          Begin
               Result:=Data;
               Exit;
          End;
     End;

     Inc(Data,len); //Next entry
     Inc(Count);
     Goto L;
End;


Procedure TComponent.SetupSCU;
Var
    SaveSCU:Pointer;
    OldInsideDesigner:Boolean;
Begin
  If SCUPointer=Nil Then Exit;
  If ComponentState * [csForm] = [] Then Exit;

  OldInsideDesigner:=InsideDesigner;
  SaveSCU:=SCUPointer;
  SCUPointer:=Nil; //prevent recursion
  Try
     ReadSCU(SaveSCU);
  Except
     On E:Exception Do
       If (InsideDesigner)  // WDLng Or(InsideLanguageDesigner))
               Then ErrorBox2('Illegal SCU format: '+E.Message);
  End;

  SCUPointer:=SaveSCU;
  InsideDesigner:=OldInsideDesigner;
End;


{$HINTS OFF}
Procedure TComponent.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
End;

Function TComponent.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result:=True;
End;

Procedure TComponent.LoadedFromSCU(SCUParent:TComponent);
Begin
     Exclude(FComponentState, csReading);
     Exclude(FComponentState, csLoading);
     Include(FComponentState, csLoaded);
End;

Procedure TComponent.LoadingFromSCU(SCUParent:TComponent);
Begin
     Include(FComponentState, csReading);
     Include(FComponentState, csLoading);
     Exclude(FComponentState, csLoaded);
End;
{$HINTS ON}

Procedure TComponent.Loaded;
Begin
End;

Procedure TComponent.ResetComponent;

Begin
  if fOnResetComponent<>nil then fOnResetComponent(Self);
End;

Procedure TComponent.SetupComponent;
Begin
  //Name := 'Component';
  Name := Copy(ClassName,2,255);
  Tag := 0;
  fSaveLoadInfo:=false;
  If Designed Then Include(ComponentState,csReference);
End;


Constructor TComponent.Create(AOwner:TComponent);
Begin
     //Inherited Create;

     If InsideWriteSCUAdr^ Then Include(ComponentState, csWriting);

     If AOwner Is TComponent Then AOwner.InsertComponent(Self);

     SetupComponent;
End;


Procedure SetupFormSCU(Form:TComponent);
Begin
     If SCUPointer <> Nil Then Form.SetupSCU;
End;


Procedure TComponent.Notification(AComponent:TComponent;Operation:TOperation);
Var  I:LongInt;
Begin
     If (FFreeNotifyList <> Nil) And (Operation = opRemove) Then
     Begin
          FFreeNotifyList.Remove(AComponent);
          If FFreeNotifyList.Count = 0 Then
          Begin
               FFreeNotifyList.Destroy;
               FFreeNotifyList := Nil;
          End;
     End;

     For I := 0 To ComponentCount-1 Do
     Begin
          Components[I].Notification(AComponent,Operation);
     End;
End;


Procedure TComponent.FreeNotification(AComponent:TComponent);
Begin
     If FFreeNotifyList = Nil Then FFreeNotifyList.Create;

     If FFreeNotifyList.IndexOf(AComponent) < 0 Then
     Begin
          FFreeNotifyList.Add(AComponent);
          AComponent.FreeNotification(Self);
     End;
End;

Function GetLanguages(Component:TComponent):PLanguageInfo;
Begin
  Result:=Component.FLanguages;
End;

Procedure SetLanguages(Component:TComponent;Info:PLanguageInfo);
Begin
  Component.FLanguages:=Info;
End;

Procedure FreeLanguage(Var LangComp:PLanguageComponent);
Var NextLangComp:PLanguageComponent;
Begin
     While LangComp<>Nil Do
     Begin
          FreeMem(LangComp^.Name,Length(LangComp^.Name^)+1);
          If LangComp^.ValueLen>0 Then
           FreeMem(LangComp^.Value,LangComp^.ValueLen);

          NextLangComp:=LangComp^.Next;
          Dispose(LangComp);
          LangComp:=NextLangComp;
     End;
End;

Destructor TComponent.Destroy;
Var Meth,Last:PIDE_Methods;
    T:LongInt;
    Own:PIDE_OwnerList;
    I:LongInt;
    LangItem,NextLangItem:PLanguageItem;
Begin
     {inform All linked Components}
     If FFreeNotifyList <> Nil Then
     Begin
          For I := 0 To FFreeNotifyList.Count-1 Do
          Begin
               TComponent(FFreeNotifyList[I]).Notification(Self,opRemove);
          End;
          FFreeNotifyList.Destroy;
          FFreeNotifyList := Nil;
     End;

     Meth:=FMethods;
     While Meth<>Nil Do
     Begin
          DisposeStr(Meth^.Name);
          DisposeStr(Meth^.Params);
          If Meth^.Owners<>Nil Then
          Begin
               For T:=0 To Meth^.Owners.Count-1 Do
               Begin
                    Own:=Meth^.Owners.Items[T];
                    DisposeStr(Own^.PropertyName);
               End;
               Meth^.Owners.Destroy;
          End;

          Last:=Meth^.Next;
          Dispose(Meth);
          Meth:=Last;
     End;
     FMethods := Nil;

     //Free registered languages
/*     If FLanguages<>Nil Then
     Begin
          LangItem:=PLanguageInfo(FLanguages)^.Items;
          FreeMem(FLanguages,SizeOf(TLanguageInfo));
          FLanguages:=Nil;
          While LangItem<>Nil Do
          Begin
               FreeMem(LangItem^.Name,Length(LangItem^.Name^)+1);

               FreeLanguage(LangItem^.Components);
               FreeLanguage(LangItem^.Menus);
               FreeLanguage(LangItem^.StringTables);

               NextLangItem:=LangItem^.Next;
               Dispose(LangItem);
               LangItem:=NextLangItem;
          End;
     End; */

     DestroyComponents;

     If FOwner <> Nil Then FOwner.RemoveComponent(Self);

     DisposeStr(FName);
     FName := Nil;
     DisposeStr(FUnitName);
     FUnitName := Nil;
     DisposeStr(FTypeName);
     FTypeName := Nil;

     Inherited Destroy;
End;


Procedure TComponent.DestroyComponents;
Var  I:LongInt;
     Component:TComponent;
Begin
     If FComponents <> Nil Then
     Begin
          I := ComponentCount;
          While I > 0 Do
          Begin
               Component := Components[I-1];
               RemoveComponent(Component);
               Component.Destroy;
               I := ComponentCount;
          End;

          FComponents.Destroy;
          FComponents := Nil;
     End;
End;

Function TComponent.GetComponentIndex:LongInt;
Begin
     Result := -1;
     If FOwner = Nil Then Exit;
     If FOwner.FComponents = Nil Then Exit;
     Result := FOwner.FComponents.IndexOf(Self);
End;

Procedure TComponent.SetComponentIndex(Index:LongInt);
Var  I:LongInt;
Begin
     If FOwner = Nil Then Exit;
     I := FOwner.IndexOfComponent(Self);
     If I < 0 Then Exit;
     If Index = I Then Exit;
     If Index < 0 Then Index := 0;
     If Index >= FOwner.FComponents.Count
     Then Index := FOwner.FComponents.Count -1;
     FOwner.FComponents.Move(I,Index);
End;

Function TComponent.GetComponentCount:LongInt;
Begin
     If FComponents=Nil Then Result:=0
     Else Result:=FComponents.Count;
End;

Function TComponent.GetComponent(AIndex:LongInt):TComponent;
Begin
     If (FComponents=Nil) Or (AIndex<0) Or (AIndex>=FComponents.Count)
     Then Result:=Nil
     Else Result:=FComponents.Items[AIndex];
End;

Function TComponent.GetName:String;
Begin
     If FName<>Nil Then Result:=FName^
     Else Result:='';
End;

Procedure TComponent.SetName(Const NewName:String);
Begin
     AssignStr(FName,NewName);
End;

Function TComponent.GetUniqueName : String;

Begin
 if fOwner=nil
   then Result:=GetName
   else Result:=fOwner.UniqueName +'\'+ GetName;
End;

Function TComponent.GetUnitName:String;
Begin
  If FUnitName <> Nil
    Then Result := FUnitName^
    Else Result := '';
End;

Function TComponent.GetTypeName:String;
Begin
  If FTypeName <> Nil
    Then Result := FTypeName^
    Else Result := '';
End;

Procedure TComponent.SetTypeName(NewName:String);
Begin
     AssignStr(FTypeName,NewName);
End;

Function TComponent.GetDesigned:Boolean;
Begin
     Result := FComponentState * [csDesigning] <> [];
End;

Procedure TComponent.InsertComponent(AComponent:TComponent);
Begin
     If FComponents = Nil Then FComponents.Create;
     FComponents.Add(AComponent);
     AComponent.FOwner := Self;

     AComponent.SetDesigning(Designed);    {!}

     Notification(AComponent,opInsert);
End;

Procedure TComponent.RemoveComponent(AComponent:TComponent);
Begin
     Notification(AComponent,opRemove);
     If FComponents = Nil Then Exit;
     FComponents.Remove(AComponent);
End;

Function TComponent.IndexOfComponent(AComponent:TComponent):LongInt;
Begin
     Result := -1;
     If FComponents = Nil Then Exit;
     Result := FComponents.IndexOf(AComponent);
End;

Function TComponent.FindComponent(Const AName:String):TComponent;
Var  I:LongInt;
Begin
     Result := Nil;
     For I := 0 To ComponentCount-1 Do
       If Components[I].Name = AName Then
       Begin
            Result := Components[I];
            break;
       End;
End;


Procedure TComponent.SetDesigning(Value:Boolean);
Var  I:LongInt;
Begin
     If Value Then Include(FComponentState, csDesigning)
     Else Exclude(FComponentState, csDesigning);

     For I := 0 To ComponentCount-1 Do Components[I].SetDesigning(Value);
End;


Procedure AddDesignerPopupEvent(AString:TStringList;Caption:String;Id:LongInt);
Begin
     If AString Is TStringList Then AString.AddObject(Caption, TObject(Id));
End;


{event from the designer PopupMenu}
{$HINTS OFF}
Procedure TComponent.GetDesignerPopupEvents(AString:TStringList);
Begin
End;

Procedure TComponent.DesignerPopupEvent(Id:LongInt);
Begin
End;
{$HINTS ON}


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: General functions Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
   SearchCompLibComponentByName:Function(Const Name:String):TComponentClass=Nil;
   CallCompLibClassPropertyEditor:Function(Var ClassToEdit:TObject):TClassPropertyEditorReturn=Nil;
   CallCompLibPropertyEditor:Function(Owner:TComponent;PropertyName:String;Var Value;ValueLen:LongInt;
                                      Var List:TStringList):TPropertyEditorReturn=Nil;
   CallCompLibPropertyEditorAvailable:Function(OwnerClass:TClass;PropertyName:String):Boolean=Nil;
   CallCompLibClassPropertyEditorAvailable:Function(ClassName:String):Boolean=Nil;

Var
    NameTable:TList;

Function NameTableAdd(P:PString):LongInt;
Var T:LongInt;
    Ofs:LongInt;
    pp:PString;
Begin
     Ofs:=0;
     For T:=0 To NameTable.Count-1 Do
     Begin
          pp:=NameTable.Items[T];
          If pp^=P^ Then
          Begin
               Result:=Ofs;
               Exit;
          End;
          Inc(Ofs,Length(pp^)+1);
     End;
     NameTable.Add(P);
     Result:=Ofs;
End;


Function SearchClassByName(Const Name:String):TComponentClass;
Var  T:LongInt;
     Comp:TComponentClass;
     S,s1:String;
Begin
     Result := Nil;
     S := Name;
     UpcaseStr(S);
     For T := 0 To RegisteredClasses.Count-1 Do
     Begin
          Comp := RegisteredClasses.Items[T];
          s1 := Comp.ClassName;
          UpcaseStr(s1);
          If s1 = S Then
          Begin
               Result := Comp;
               Exit;
          End;
     End;

     {Search In registered Components Of the complib}
     If @SearchCompLibComponentByName<>Nil
     Then Result := SearchCompLibComponentByName(Name);
End;

Procedure RegisterClass(Const ComponentClass:TComponentClass);
Var Comp:TComponentClass;
    t1:LongInt;
Begin
     For t1:=0 To RegisteredClasses.Count-1 Do
     Begin
          Comp:=RegisteredClasses.Items[t1];
          If Comp.ClassName=ComponentClass.ClassName Then exit;
     End;

     RegisteredClasses.Add(ComponentClass);
End;

Function GetClass(Const ClassName:String):TComponentClass;
Begin
     Result:=SearchClassByName(ClassName);
End;

Function FindClass(Const ClassName:String):TComponentClass;
Begin
     Result:=GetClass(ClassName);
     If Result=Nil Then Raise EClassNotFound.Create(ClassName);
End;

Procedure UnRegisterClass(AClass:TComponentClass);
Var t1:LongInt;
    Comp:TComponentClass;
Label again;
Begin
again:
     For t1:=0 To RegisteredClasses.Count-1 Do
     Begin
          Comp:=RegisteredClasses.Items[t1];
          If Comp.ClassName=AClass.ClassName Then
          Begin
               RegisteredClasses.Remove(Comp);
               goto again;
          End;
     End;
End;

Procedure UnRegisterClasses(Const AClasses:Array of TComponentClass);
Var t:LongInt;
Begin
     For t:=0 To High(AClasses) Do UnRegisterClass(AClasses[t]);
End;


Procedure RegisterClasses(Const ComponentClasses: Array Of TComponentClass);
Var T,t1:LongInt;
    Comp,Comp1:TComponentClass;
Label l1;
Begin
     For T:=0 To High(ComponentClasses) Do
     Begin
          Comp1:=ComponentClasses[T];
          For t1:=0 To RegisteredClasses.Count-1 Do
          Begin
               Comp:=RegisteredClasses.Items[t1];
               If Comp.ClassName=Comp1.ClassName Then Goto l1;
          End;

          RegisteredClasses.Add(Comp1);
l1:
     End;
End;

{copies actual Value Of Property To Value.
 Value MUST be allocated With At least TypLen Bytes !}
Function CallReadProp(Objekt:TObject;FuncAddr:Pointer;Typ:Byte;
                      TypLen:LongInt;Value:Pointer):Boolean;
Var
    FResult:LongInt;
    Func:Function(SelfObj:TObject):LongInt;
    FuncVar:Function(VarRef:Pointer;SelfObj:TObject):LongInt;
Begin
     Result:=False;

     If FuncAddr=Nil Then Exit;  //method Not found

     If ((Typ=PropType_Set)And(TypLen=4)) Then Typ:=PropType_Unsigned;

     If LongWord(FuncAddr)<65535 Then //VMT call
     Begin
          Case Typ Of
             PropType_Unsigned,PropType_Signed,PropType_Class,
             PropType_Enum,PropType_Boolean,PropType_Char,PropType_ClassVar:
             Begin
                  Asm
                     PUSH DWord Ptr Objekt   //Self
                     MOV EAX,FuncAddr        //VMT Index
                     CALLN32 System.!VmtCall
                     MOV FResult,EAX
                  End;
                  Move(FResult,Value^,TypLen);
             End;
             PropType_Float,PropType_String,PropType_Set,PropType_CString,
             PropType_ProcVar,PropType_FuncVar,PropType_Record:
             Begin
                  Asm
                     PUSH DWord Ptr Value    //Var Parameter Of return Value
                     PUSH DWord Ptr Objekt   //Self
                     MOV EAX,FuncAddr        //VMT Index
                     CALLN32 System.!VmtCall
                  End;
             End;
             Else Exit;  //Some Error
          End; {Case}
     End
     Else
     Begin
          Case Typ Of
             PropType_Unsigned,PropType_Signed,PropType_Class,
             PropType_Enum,PropType_Boolean,PropType_Char,PropType_ClassVar:
             Begin
                  Func:=FuncAddr;
                  FResult:=Func(Objekt);
                  Move(FResult,Value^,TypLen);
             End;
             PropType_Float,PropType_String,PropType_Set,PropType_CString,
             PropType_ProcVar,PropType_FuncVar,PropType_Record:
             Begin
                  FuncVar:=FuncAddr;
                  FResult:=FuncVar(Value,Objekt);
             End;
             Else Exit;  //Some Error
          End; {Case}
     End;

     Result:=True;
End;

{copies actual Value Of Value To the Property.
 Value MUST be allocated With At least TypLen Bytes !}
Function CallWriteProp(Objekt:TObject;ProcAddr:Pointer;Typ:Byte;
                       TypLen:LongInt;Value:Pointer):Boolean;
Var
    Proc:Procedure(Value:LongWord;SelfObj:TObject);
    ProcVar:Procedure(Value:Pointer;SelfObj:TObject);
    pb:^LongWord;
    pw:^Word;
    pl:^LongWord;
    L:LongWord;
Begin
     Result:=False;

     If ProcAddr=Nil Then Exit;  //method Not found

     If TypLen In [1,2,3,4] Then
       If Not (Typ In [PropType_String,PropType_CString]) Then Typ:=PropType_Unsigned;

     If LongWord(ProcAddr)<65535 Then //VMT call
     Begin
          Case Typ Of
             PropType_Unsigned,PropType_Signed,PropType_Class,
             PropType_Enum,PropType_Boolean,PropType_Char,PropType_ClassVar:
             Begin
                  Case TypLen Of
                    1:
                    Begin
                         pb:=Value;
                         L:=pb^;
                    End;
                    2:
                    Begin
                         pw:=Value;
                         L:=pw^;
                    End;
                    3:
                    Begin
                         L:=0;
                         Move(pl^,L,3);
                    End;
                    4:
                    Begin
                         pl:=Value;
                         L:=pl^;
                    End;
                    Else Exit;  //no Valid Type Size For Val
                  End; {Case}

                  Asm
                     PUSH DWord Ptr L        //Value To Set
                     PUSH DWord Ptr Objekt   //Self
                     MOV EAX,ProcAddr        //VMT Index
                     CALLN32 System.!VmtCall
                  End;
             End;
             PropType_Float,PropType_String,PropType_Set,PropType_CString,
             PropType_ProcVar,PropType_FuncVar,PropType_Record:
             Begin
                  Asm
                     PUSH DWord Ptr Value    //Var Parameter Of Data To Assign
                     PUSH DWord Ptr Objekt   //Self
                     MOV EAX,ProcAddr        //VMT Index
                     CALLN32 System.!VmtCall
                  End;
             End;
             Else Exit;  //Some Error
          End; {Case}
     End
     Else
     Begin
          Case Typ Of
             PropType_Unsigned,PropType_Signed,PropType_Class,
             PropType_Enum,PropType_Boolean,PropType_Char,PropType_ClassVar:
             Begin
                  {$IFDEF SPDLL30OS2}
                  Proc:=ProcAddr^;
                  {$ELSE}
                  Proc:=ProcAddr;
                  {$ENDIF}
                  Case TypLen Of
                    1:
                    Begin
                         pb:=Value;
                         L:=pb^;
                    End;
                    2:
                    Begin
                         pw:=Value;
                         L:=pw^;
                    End;
                    3:
                    Begin
                         L:=0;
                         Move(pl^,L,3);
                    End;
                    4:
                    Begin
                         pl:=Value;
                         L:=pl^;
                    End;
                    Else Exit;  //no Valid Type Size For Val
                  End; {Case}
                  Proc(L,Objekt);
             End;
             PropType_Float,PropType_String,PropType_Set,PropType_CString,
             PropType_ProcVar,PropType_FuncVar,PropType_Record:
             Begin
                  {$IFDEF SPDLL30OS2}
                  ProcVar:=ProcAddr^;
                  {$ELSE}
                  ProcVar:=ProcAddr;
                  {$ENDIF}
                  ProcVar(Value,Objekt);
             End;
             Else Exit;  //Some Error
          End; {Case}
     End;

     Result:=True;
End;

Var PropertyNameTable:Pointer;


Const SCUUnsignedTypes:Array[1..4] Of SCUTypes=(SCUByte,SCUWord,SCUNull,SCULongWord);
      SCUSignedTypes:Array[1..4] Of SCUTypes=(SCUShortInt,SCUInteger,SCUNull,SCULongInt);
      SCUFloatTypes:Array[4..10] Of SCUTypes=(SCUSingle,SCUNull,SCUNull,SCUNull,SCUDouble,SCUNull,SCUExtended);
      SCUBooleanTypes:Array[1..4] Of SCUTypes=(SCUByteBool,SCUWordBool,SCUNull,SCULongBool);

Function WriteProperties(Stream:TMemoryStream;p1:Pointer;Objekt:TComponent;
                         pParent:Pointer):Boolean; Forward;


Function WritePropertyValues(Stream:TMemoryStream;P:Pointer;Objekt:TComponent;
                             Namep:Pointer;ReferenceObjekt:TComponent):Boolean;
Var Typep,p1,p2:^LongInt;
    Typ,B:Byte;
    tt,TypLen:LongInt;
    ReadTyp,WriteTyp:Byte;
    S:String;
    ps:^String;
    Value,ReferenceValue:^LongInt;
    ValueLen:LongInt;
    ReadOffset,WriteOffset:LongInt;
    s3:String;
    ReadAddr,WriteAddr:Pointer;
    ValidProp:Boolean;
    AOwner:TComponent;
    Methods:PIDE_Methods;
    Own:PIDE_OwnerList;
    MyComp:TComponent;
    pParent1:Pointer;
Label L,lll,lll1,ex,weiter;
Begin
     Result:=False;
     ValidProp:=True;
     p1:=P;
     MyComp:=Nil;

     ReadTyp:=p1^ AND longword(255);
     Inc(p1);
     Case ReadTyp Of
        0:;  //Not avail
        1:   //Var Offset
        Begin
             ReadOffset:=p1^;
             Inc(p1,4);
        End;
        2,3:   //Procedure Or Function (direct Or VMT call)
        Begin
             ReadAddr:=Pointer(p1^);
             Inc(p1,4);
        End;
        Else Goto ex;  //Some Error
     End;

     WriteTyp:=p1^ AND longword(255);
     Inc(p1);
     Case WriteTyp Of
        0:;  //Not avail
        1:   //Var Offset
        Begin
             WriteOffset:=p1^;
             Inc(p1,4);
        End;
        2,3:   //Procedure Or Function (direct Or VMT call)
        Begin
             WriteAddr:=Pointer(p1^);
             Inc(p1,4);
        End;
        Else Goto ex;  //Some Error
     End;

     //determine Type Of the Property
     TypLen:=p1^;
     ValueLen:=TypLen;
     GetMem(Value,TypLen);
     GetMem(ReferenceValue,TypLen);
     Inc(p1,4);
     Typ:=p1^ AND longword(255);             //Property Type
     Typep:=p1;

     //Write Value Of the Property
     Case ReadTyp Of
        0:;  //Not avail
        1:   //Var Offset
        Begin
             p2:=Pointer(Objekt);
             Inc(p2,ReadOffset);
             Move(p2^,Value^,TypLen);
             p2:=Pointer(ReferenceObjekt);
             Inc(p2,ReadOffset);
             Move(p2^,ReferenceValue^,TypLen);
        End;
        2,3:   //Procedure Or Function (direct Or VMT call)
        Begin
             If Not CallReadProp(Objekt,ReadAddr,Typ,TypLen,Value) Then Goto ex;
             If Not CallReadProp(ReferenceObjekt,ReadAddr,Typ,TypLen,ReferenceValue) Then Goto ex;
        End;
        Else Goto ex;  //Some Error
     End;

     If ReadTyp In [1,2,3] Then
     Begin
          If Typ In [PropType_ProcVar,PropType_FuncVar,
                     PropType_Class,PropType_ClassVar] Then //ON... properties
                                                            //ClassVar And
                                                            //Classes
          Begin
               Own:=Nil;
               If Value^=0 Then
               Begin
                    If Typ In [PropType_ProcVar,PropType_FuncVar] Then //ON properties
                    Begin
                         //Search Owner
                         AOwner:=Objekt;
                         ps:=Namep;
                         S:=ps^;
                         UpcaseStr(S);
lll:
                         While AOwner<>Nil Do
                         Begin
                              Methods:=AOwner.FMethods;

                              While Methods<>Nil Do
                              Begin
                                   For tt:=0 To Methods^.Owners.Count-1 Do
                                   Begin
                                       Own:=Methods^.Owners.Items[tt];
                                       s3:=Own^.PropertyName^;
                                       UpcaseStr(s3);
                                       If S=s3 Then
                                         If Own^.Objekt=TComponent(Objekt) Then
                                       Begin  //found
                                            Goto lll1;
                                       End;
                                   End;

                                   Methods:=Methods^.Next;
                              End;
weiter:
                              AOwner:=AOwner.FOwner;
                              Goto lll;
                         End;  //While AOwner<>Nil

                         Goto L;  //Not found --> dont Write
                    End
                    Else Goto L; //dont Write
               End;

               If Typ=PropType_Class Then {Class}
               Begin
                    MyComp:=Pointer(Value^);
                    If MyComp<>Nil Then
                      If MyComp Is TComponent Then
                        If MyComp.Designed Then
                           If MyComp.ComponentState * [csHandleLinks] <> [] Then
                           Begin
                               Typ:=PropType_Link;  //Link
                               Goto lll1;
                           End;

                    If MyComp Is TComponent Then
                      If MyComp.DesignerState*[dsStored]<>[] Then
                    Begin
                         p1:=Pointer(PropertyNameTable);

                         p2:=Pointer(MyComp);  //Object address
                         If p2<>Nil Then
                         Begin
                              //Write properties Of the Class
                              B:=1;
                              If Stream.Write(B,1)=0 Then Goto ex;

                              tt:=NameTableAdd(Namep);  //Name Of the Property
                              If Stream.Write(tt,4)=0 Then Goto ex;

                              {Type Info For the Property}
                              B:=Ord(SCUClass);
                              If Stream.Write(B,1)=0 Then Goto ex;


                              p2:=Pointer(p2^);  //VMT address
                              Inc(p2,4);
                              p2:=Pointer(p2^);  //Class Info
                              Inc(p2,4);
                              pParent1:=Pointer(p2^); //parent Class VMT Or Nil
                              Inc(p2,8);
                              p2:=Pointer(p2^);  //Property Info
                              If Not WriteProperties(Stream,p2,MyComp,pParent1) Then Goto ex;
                              PropertyNameTable:=Pointer(p1);
                         End;
                    End;
               End;

               //dont Write TBitmap here (Extra Data In BitButton Or Picture)

               Goto L; //don't Write Class/ClassVar
          End
          Else
          Begin
               //only Write If Value Is different from Default Value
              If Typ=PropType_String Then ValueLen:=(Value^ AND longword(255))+1;  //String
              If ValueLen>TypLen Then ValueLen:=TypLen;

               If CompareResMem(Value^,ReferenceValue^,ValueLen) Then Goto L;
          End;
lll1:
          //the Value differs from the Default Value And MUST be written

          If Typ=PropType_Link Then B:=2
          Else B:=1;
          If Stream.Write(B,1)=0 Then Goto ex;

          tt:=NameTableAdd(Namep);  //Name Of the Property
          If Stream.Write(tt,4)=0 Then Goto ex;

          tt:=0;
          Case Typ Of
              PropType_Unsigned:B:=Ord(SCUUnsignedTypes[ValueLen]);
              PropType_Signed:B:=Ord(SCUSignedTypes[ValueLen]);
              PropType_Float:B:=Ord(SCUFloatTypes[ValueLen]);
              PropType_Set:
              Begin
                   If ValueLen=4 Then B:=Ord(SCUSet4)
                   Else B:=Ord(SCUSet32);
              End;
              PropType_CString:B:=Ord(SCUCString);
              PropType_Record:
              Begin
                   B:=Ord(SCURecord);
                   If Stream.Write(B,1)=0 Then Goto ex;
                   tt:=ValueLen;
                   If Stream.Write(tt,4)=0 Then Goto ex;
              End;
              PropType_Class:B:=Ord(SCUClass);
              PropType_String:B:=Ord(SCUString);
              PropType_Enum:B:=Ord(SCUEnum);
              PropType_Boolean:B:=Ord(SCUBooleanTypes[ValueLen]);
              PropType_Char:B:=Ord(SCUChar);
              PropType_ClassVar:B:=Ord(SCUClassVar);
              PropType_ProcVar:B:=Ord(SCUProcVar);
              PropType_FuncVar:B:=Ord(SCUFuncVar);
              PropType_Link:B:=Ord(SCULink);
              Else
              Begin
                   B:=Ord(SCUBinary);
                   If Stream.Write(B,1)=0 Then Goto ex;
                   tt:=ValueLen;
                   If Stream.Write(tt,4)=0 Then Goto ex;
              End;
          End;

          If tt=0 Then If Stream.Write(B,1)=0 Then Goto ex; //Not For records

          Case Typ Of
              PropType_ProcVar,PropType_FuncVar: //Events
              Begin
                   //Owner Type Name
                   If AOwner.FName=Nil Then AOwner.Name:=AOwner.ClassName;
                   tt:=NameTableAdd(AOwner.FName);
                   If Stream.Write(tt,4)=0 Then Goto ex;

                   //method Name
                   tt:=NameTableAdd(Methods^.Name);
                   If Stream.Write(tt,4)=0 Then Goto ex;

                   //Property Name
                   tt:=NameTableAdd(Namep);
                   If Stream.Write(tt,4)=0 Then Goto ex;
              End;
              PropType_Link:  //Link
              Begin
                   //Link field Name
                   If MyComp=Nil Then Goto ex;

                   If MyComp.FName=Nil Then MyComp.Name:=MyComp.ClassName;
                   tt:=NameTableAdd(MyComp.FName);
                   If Stream.Write(tt,4)=0 Then Goto ex;
              End;
              Else //others
              Begin
                  If Typ=PropType_String Then ValueLen:=(Value^ AND longword(255))+1;  //String
                  If ValueLen>TypLen Then ValueLen:=TypLen;
                  If Stream.Write(Value^,ValueLen)=0 Then Goto ex;
              End;
          End; {Case}
     End
     Else Goto ex; //Some Error
L:
     Result:=True;
ex:
     FreeMem(Value,TypLen);
     FreeMem(ReferenceValue,TypLen);
End;



Function WriteProperties(Stream:TMemoryStream;p1:Pointer;Objekt:TComponent;
                         pParent:Pointer):Boolean;
Var Namep,P,pp,p2:^LongInt;
    B:Byte;
    NameLen:LongInt;
    len,OldPos,EndPos:LongInt;
    ReferenceObjekt:TComponent;
    ObjektClass:TComponentClass;
    Scope:Byte;
Label L,ex;
Begin
     Result:=False;
     P:=p1;

     ObjektClass:=Objekt.ClassType;
     InsideWriteSCUAdr^:=True;
     ReferenceObjekt:=Nil;
     Try
        ReferenceObjekt:=ObjektClass.Create({Objekt.FOwner}Nil);
        Include(ReferenceObjekt.ComponentState, csWriting);
        InsideWriteSCUAdr^:=False;

        OldPos:=Stream.Position;
        len:=0;                     //patched later
        If Stream.Write(len,4)=0 Then Goto ex;
        Inc(P,4);                  //onto Property Name Table
        PropertyNameTable:=Pointer(P^);
        Inc(P,4);                  //onto First Name
L:
        NameLen:=P^ AND longword(255);
        Namep:=Pointer(P);

        If NameLen<>0 Then
        Begin
             Inc(P,NameLen+1);  //overread Name
             Scope:=P^ AND longword(255);
             Inc(P);
             If Scope And 16=0 Then  //Not stored
             Begin
                  Inc(P,4);
                  Goto L;
             End;

             //Property Is stored, Find out If we need To Write the Value Of it To the SCU Stream
             p2:=Pointer(P^);   //Property Type And access Info
             If p2<>Nil Then
               If Not WritePropertyValues(Stream,p2,Objekt,Namep,ReferenceObjekt) Then Goto ex;  //Some Error
             Inc(P,4);   //Until All properties written
             Goto L;
        End;

        If pParent<>Nil Then
        Begin
             pp:=pParent;            //parent VMT Info
             Inc(pp,4);
             pp:=Pointer(pp^);       //ClassInfo
             Inc(pp,4);
             pParent:=Pointer(pp^);  //parent Class VMT Or Nil
             Inc(pp,8);
             pp:=Pointer(pp^);       //Property Pointer
             P:=pp;
             p1:=P;
             Inc(P,4);               //onto Property Name Table
             PropertyNameTable:=Pointer(P^);
             Inc(P,4);               //onto First Name
             Goto L;                 //Write parent properties
        End;

        B:=0;
        If Stream.Write(B,1)=0 Then Goto ex;

        EndPos:=Stream.Position;
        len:=EndPos-OldPos;
        Stream.Position:=OldPos;
        If Stream.Write(len,4)=0 Then Goto ex;
        Stream.Position:=EndPos;

        Result:=True;
ex:
     Finally
        If ReferenceObjekt<>Nil Then ReferenceObjekt.Destroy;
        InsideWriteSCUAdr^:=False;
     End;
End;

Function WriteNameTable(Stream:TMemoryStream):Boolean;
Var T:LongInt;
    pp:PString;
Begin
     Result:=False;

     For T:=0 To NameTable.Count-1 Do
     Begin
          pp:=NameTable.Items[T];
          If Stream.Write(pp^,Length(pp^)+1)=0 Then Exit;
     End;

     NameTable.Destroy; {!!}
     Result:=True;
End;


Function WriteObjectComponents(Stream:TMemoryStream;ResStream:TResourceStream;
                               Objekt:TComponent):Boolean;
Var  Count:LongInt;
     PatchStreamPos:LongInt;
     CurStreamPos:LongInt;
Begin
     Result := False;

     Objekt.SCUStream := Stream;
     Objekt.SCUResStream := ResStream;
     PatchStreamPos := Stream.Position;

     Count := 0;
     If Stream.Write(Count,4) = 0 Then Exit; {Write dummy, patch it later}
     Objekt.FWriteComponentCount := 0;
     Objekt.GetChildren(Objekt.WriteComponent);
     Count := Objekt.FWriteComponentCount;

     Objekt.SCUStream := Nil;
     Objekt.SCUResStream := Nil;

     CurStreamPos := Stream.Position;
     Stream.Position := PatchStreamPos;
     If Stream.Write(Count,4) = 0 Then Exit;
     Stream.Position := CurStreamPos;

     Result := Not Objekt.SCUWriteError;
End;


{Write SCU information Of the Child Component}
Procedure TComponent.WriteComponent(Child:TComponent);
{ WD: Schreibt die SCU-Informationnen in die Datei }

Const Zero:LongInt=0;
Var  pp,pp1,pParent1:^LongInt;
     tt:LongInt;
     B:Byte;
     Ok:Boolean;
     err:String[40];
Label ex;
Begin
     If csReferenceControl In Child.ComponentState Then
     Begin //Write the referenced Component before Self
          If Child.FReference <> Nil Then WriteComponent(Child.FReference);
     End;

     Ok:=False;
     err:='Stream write error';
     Try
        SCUWriteError := True;
        If SCUStream = Nil Then Goto ex;
        If SCUResStream = Nil Then Goto ex;

        pp:=Pointer(Child);
        pp:=Pointer(pp^);       //VMT Info

        Inc(pp,4);
        pp:=Pointer(pp^);       //ClassInfo
        pp1:=pp;
        Inc(pp,4);
        pParent1:=Pointer(pp^); //parent Class VMT Or Nil
        Inc(pp,8);
        pp:=Pointer(pp^);       //Property Pointer

        //Write Inspector Class Name
        Inc(pp1,16);   //onto ClassName
        tt:=NameTableAdd(Pointer(pp1));
        If SCUStream.Write(tt,4)=0 Then Goto ex;

        //Write runtime Class Name
        If Child.FTypeName=Nil Then
        Begin
             B:=0;     //runtime And Inspector Type Name are identical
             If SCUStream.Write(B,1)=0 Then Goto ex;
        End
        Else
        Begin
             B:=1;     //runtime Name Is different from Inspector Name
             If SCUStream.Write(B,1)=0 Then Goto ex;
             tt:=NameTableAdd(Child.FTypeName);
             If SCUStream.Write(tt,4)=0 Then Goto ex;
        End;

        If Not WriteProperties(SCUStream,pp,Child,pParent1) Then
        Begin
             err:='WriteProperties error';
             Goto ex;  //Some Error
        End;

        //Write Components that are owned by the Object
        If Not WriteObjectComponents(SCUStream,SCUResStream,Child) Then
        Begin
             err:='WriteObjectComponents error';
             Goto ex;
        End;

        //Write Extra Data For that Component
        If Not Child.WriteSCUResource(SCUResStream) Then
        Begin
             err:='WriteSCUResource error';
             Goto ex;
        End;
        If SCUStream.Write(Zero,4)=0 Then Goto ex; {no more resources}

        SCUWriteError := False;

        Inc(FWriteComponentCount);

        Ok:=True;
     Except
        err:=err+' due to exception';
     End;
ex:
     If Not Ok Then
     Begin
          Raise ESCUError.Create('SCU write error for '+Child.ClassName+': '+err);
     End;
End;


Procedure TComponent.WriteToStream(SCUStream:TStream);
Const Zero:LongInt=0;
Var  Stream:TMemoryStream;
     ResourceStream:TResourceStream;
     P,p1,pParent:^LongInt;
     FileDesc:TSCUFileFormat;
Begin
     Stream.Create;
     Stream.Capacity:=32768;

     ResourceStream.Create;
     ResourceStream.Capacity:=32768;
     ResourceStream.SCUStream:=Stream;
     ResourceStream.FHeaderPos:=8;    {Initial Resource Header}

     NameTable.Create; {wo zerst”rt??}

     FillChar(FileDesc,SizeOf(TSCUFileFormat),0);
     FileDesc.Version:=SCUVersion;
     If Stream.Write(FileDesc,SizeOf(TSCUFileFormat))=0 Then  //SCU Header
       Raise ESCUError.Create('Stream write error');

     FileDesc.ObjectOffset:=Stream.Position;
     FileDesc.ObjectCount:=1;      //Count Of Objects

     P:=Pointer(Self);
     P:=Pointer(P^);               //VMT Info

     Inc(P,4);
     P:=Pointer(P^);               //ClassInfo
     p1:=P;
     Inc(P,4);
     pParent:=Pointer(P^);         //parent Class VMT Or Nil
     Inc(P,8);
     P:=Pointer(P^);               //Property Pointer

     Inc(p1,16);                   //onto ClassName

     If Not WriteProperties(Stream,P,Self,pParent) Then
       Raise ESCUError.Create('WriteProperties failed');

     //Write Components that are owned by the Object
     If Not WriteObjectComponents(Stream,ResourceStream,Self) Then
       Raise ESCUError.Create('WriteObjectComponents failed');

     If Not WriteSCUResource(ResourceStream) Then
         Raise ESCUError.Create('WriteSCUResource failed');
     If Stream.Write(Zero,4)=0 Then
         Raise ESCUError.Create('Stream Write Error'); {no more resources}

     FileDesc.ObjectLen:=Stream.Position-FileDesc.ObjectOffset;

     //patch Name Table
     FileDesc.NameTableOffset:=Stream.Position;
     If Not WriteNameTable(Stream) Then
       Raise ESCUError.Create('Stream write error');
     FileDesc.NameTableLen:=Stream.Position-FileDesc.NameTableOffset;

     FileDesc.ResourceOffset:=Stream.Position;
     {Write Resource information}
     If Not ResourceStream.WriteResourcesToStream(Stream) Then
       Raise ESCUError.Create('Stream write error');
     ResourceStream.Destroy;
     FileDesc.ResourceLen:=Stream.Position-FileDesc.ResourceOffset;

     Stream.Position:=0;    //patch Header
     If Stream.Write(FileDesc,SizeOf(TSCUFileFormat))=0 Then
       Raise ESCUError.Create('Stream write error');

     //Copy Stream
     SCUStream.WriteBuffer(Stream.Memory^, Stream.Size);  { Frueher: Stream.FBuffer^,Stream.FSize); }
     Stream.Destroy;
End;

Procedure TComponent.ReadSCU(Data:Pointer);
Var
   ClassPointer,P,p1:^LongWord;
   dummy:PSCUFileFormat;
   NameTable:^LongWord;
   ResourceTable:^LongWord;
   ActComponentClass:TComponentClass;
   S,s1:String;
   ObjectCount:LongInt;
   ps:^String;
   OldInsideDesigner:Boolean;
   LanguageInfo:^LongWord;
   MessageInfo:^LongWord;
   Flags:Byte;
   T:LongInt;
   CurrentLanguage:String;
   LangItem:PLanguageItem;
   Msgs:PLanguageMessages;
   MsgLen:LongWord;

   Procedure ReadLanguage(Var Components:PLanguageComponent);
   Var
      LangComp:PLanguageComponent;
      ps:^String;
   Begin
        Components:=Nil;

        While (LanguageInfo^ AND longword(255))<>0 Do //Read All Components entries
        Begin
             Inc(LanguageInfo);  //skip 1

             If Components=Nil Then
             Begin
                  New(Components);
                  LangComp:=Components;
             End
             Else
             Begin
                  LangComp:=Components;
                  While LangComp^.Next<>Nil Do LangComp:=LangComp^.Next;
                  New(LangComp^.Next);
                  LangComp:=LangComp^.Next;
             End;
             LangComp^.Next:=Nil;

             ps:=Pointer(LanguageInfo);
             GetMem(LangComp^.Name,Length(ps^)+1);
             LangComp^.Name^:=ps^;
             Inc(LanguageInfo,Length(ps^)+1);

             LangComp^.ValueTyp:=LanguageInfo^ AND longword(255);
             Inc(LanguageInfo);

             LangComp^.ValueLen:=LanguageInfo^;
             Inc(LanguageInfo,4);

             GetMem(LangComp^.Value,LangComp^.ValueLen);
             Move(LanguageInfo^,LangComp^.Value^,LangComp^.ValueLen);
             Inc(LanguageInfo,LangComp^.ValueLen);

             LangComp^.ControlLeft:=LanguageInfo^;
             Inc(LanguageInfo,4);
             LangComp^.ControlBottom:=LanguageInfo^;
             Inc(LanguageInfo,4);
             LangComp^.ControlWidth:=LanguageInfo^;
             Inc(LanguageInfo,4);
             LangComp^.ControlHeight:=LanguageInfo^;
             Inc(LanguageInfo,4);
        End;
        Inc(LanguageInfo);  //skip 0
   End;
                                       
Label loadit,Next,skip;
Begin
     OldInsideDesigner:=InsideDesigner;
     dummy:=Data;
     PropertyLinks:=Nil;
     MessageInfo:=NIL;
     LanguageInfo:=NIL;

     While dummy<>Nil Do
     Begin
          NameTable:=Pointer(dummy);
          Inc(NameTable,dummy^.NameTableOffset);
          ResourceTable:=Pointer(dummy);
          Inc(ResourceTable,dummy^.ResourceOffset);

          P:=Pointer(dummy);
          Inc(P,dummy^.ObjectOffset);

          S:=ClassName;
          UpcaseStr(S);
//WDLng          If ((((InsideDesigner)Or(InsideLanguageDesigner)))And(S='TFORMEDITOR')) Then
          If (InsideDesigner) And (S='TFORMEDITOR') Then
          Begin
               //always Use the Class entry defined by dummy^.UseEntry !
               p1:=Pointer(dummy);
               Inc(p1,SizeOf(TSCUFileFormat));
               ObjectCount:=0;
               LanguageInfo:=Nil;
               MessageInfo:=Nil;
               While ObjectCount<>dummy^.UseEntry+1 Do
               Begin
                    Flags:=p1^ AND longword(255);  //1- auto Create, 2- Language Info avail
                    Inc(p1);                  //skip flag
                    Inc(p1,(p1^ AND longword(255))+1);  //skip Form Name
                    Inc(p1,(p1^ AND longword(255))+1);  //skip Form Unit Name
                    Inc(p1,(p1^ AND longword(255))+1);  //skip Form TypeName
                    //If Message information Is available For This Form (only For First) remember And skip it !
                    If (Flags And 8)<>0 Then
                    Begin
                         MessageInfo:=Pointer(p1);
                         Inc(p1,p1^);
                    End;
                    //If Language information Is available For This Form, remember And skip
                    LanguageInfo:=Pointer(p1);
                    If Flags And 2<>0 Then Inc(p1,p1^);  //skip Language Info
                    Inc(ObjectCount);
               End;

// WDLng       If (Flags And 2)=0 Then LanguageInfo:=Nil;  //no languages avail
// WDLng       If (Flags And 4)<>0 Then LanguageInfo:=Nil; //locked !!

               ObjectCount:=0;
               While ObjectCount<>dummy^.UseEntry Do
               Begin
                    Inc(P,{4+}P^);        //overread This entry
                    Inc(ObjectCount);
               End;

               ClassPointer:=P;
               Inc(P,4);              //Set ON Inspector Class Name
               Inc(P,(P^ AND longword(255))+1); //overread Inspector Name
               Inc(P,(P^ AND longword(255))+1); //overread runtime Class Name
               ps:=Pointer(P);        //Unit Name For This Form
               AssignStr(FUnitName,ps^);
               Goto loadit;
          End
          Else
          Begin
              //don't Read any Classes when inside designer !
              //If (InsideDesigner And (Not InsideCompLib)) Then Exit;
              If InsideCompLib Then InsideDesigner:=False;

              //Search For Class named S inside area P With dummy^.ObjectCount
              //entries And Set ClassPointer To Object Data Start
              //Use also ClassUnit For Reference
              ClassPointer:=SearchClassSCU(P,S,dummy^.ObjectCount,ClassUnit);
              If ClassPointer=Nil Then Goto Next;  //no Class found

              //look If Language Info Is avail
              p1:=Pointer(dummy);
              Inc(p1,SizeOf(TSCUFileFormat));
              For T:=1 To dummy^.ObjectCount Do
              Begin
                   Flags:=p1^ AND longword(255);
                   Inc(p1);                  //skip flag
                   Inc(p1,(p1^ AND longword(255))+1);  //skip Form Name
                   Inc(p1,(p1^ AND longword(255))+1);  //skip Form Unit Name
                   If (Flags And 2)<>0 Then //Language Info avail ??? WDLng: Nicht mehr notwendig
                   Begin
                        ps:=Pointer(p1);
                        Inc(p1,(p1^ AND longword(255))+1);  //skip Form Type Name

                        //If Message information Is available For This Form (only For First) skip it !
                        If (Flags And 8)<>0 Then Inc(p1,p1^);

                        s1:=ps^;
                        UpcaseStr(s1);
                        If S=s1 Then //found !
                        Begin
                             LanguageInfo:=Pointer(p1);
                             If (Flags And 4)<>0 Then LanguageInfo:=Nil; //locked !!
                             Goto loadit;
                        End
                        Else Inc(p1,p1^); //only skip Info
                   End
                   Else
                   Begin
                        Inc(p1,(p1^ AND longword(255))+1);  //skip Form Type Name
                        //If Message information Is available For This Form (only For First) skip it !
                        If (Flags And 8)<>0 Then Inc(p1,p1^);
                   End;
              End;
              LanguageInfo:=Nil; //Not found
loadit:
              Inc(ClassPointer,4);                         //Set ON Inspector Class Name
              Inc(ClassPointer,(ClassPointer^ AND longword(255))+1); //overread Inspector Name
              Inc(ClassPointer,(ClassPointer^ AND longword(255))+1); //overread runtime Class Name
              Inc(ClassPointer,(ClassPointer^ AND longword(255))+1); //overread Unit Name

              ActComponentClass:=ClassType;
              RegisterClasses([ActComponentClass]);  //Form registrieren
              If (InsideDesigner) then // WDLng Or(InsideLanguageDesigner)) Then
              Begin
                   FMethods:=Nil;  //no Methods defined
              End;

              LastSCUForm:=Self;

              LoadingFromSCU(Nil);

              //Build Message lists
              If MessageInfo<>Nil Then
              Begin
                   Inc(MessageInfo,4);  //skip Size

                   ps:=Pointer(MessageInfo);
                   AppLanguage:=ps^;
                   Inc(MessageInfo,Length(ps^)+1);

                   ps:=Pointer(MessageInfo);
                   While Length(ps^)<>0 Do
                   Begin

                        //look If the Language Is installed, skip If True
                        If LanguageMessages=Nil Then
                        Begin
                             New(LanguageMessages);
                             Msgs:=LanguageMessages;
                        End
                        Else
                        Begin
                             Msgs:=LanguageMessages;
                             While Msgs^.Next<>Nil Do
                             Begin
                                  If Msgs^.Name^=ps^ Then
                                  Begin
                                       Inc(MessageInfo,Length(ps^));
                                       MsgLen:=MessageInfo^;
                                       Inc(MessageInfo,4);
                                       Inc(MessageInfo,MsgLen);
                                       Goto skip;
                                  End;
                                  Msgs:=Msgs^.Next;
                             End;
                             If Msgs^.Name^=ps^ Then
                             Begin
                                  Inc(MessageInfo,Length(ps^)+1);
                                  MsgLen:=MessageInfo^;
                                  Inc(MessageInfo,4);
                                  Inc(MessageInfo,MsgLen);
                                  Goto skip;
                             End;
                             New(Msgs^.Next);
                             Msgs:=Msgs^.Next;
                        End;

                        GetMem(Msgs^.Name,Length(ps^)+1);
                        Msgs^.Name^:=ps^;
                        Inc(MessageInfo,Length(ps^)+1);
                        Msgs^.StringTableLen:=MessageInfo^;
                        Inc(MessageInfo,4);
                        GetMem(Msgs^.StringTable,Msgs^.StringTableLen);
                        Move(MessageInfo^,Msgs^.StringTable^,Msgs^.StringTableLen);
                        Inc(MessageInfo,Msgs^.StringTableLen);
skip:
                        ps:=Pointer(MessageInfo);
                   End;
              End;

// Alter Language-Source Source; Mit WDSibyl wird dies mittels eine Text-Datei
// erm”glicht --> Nicht mehr notwendig.
              //Build Language lists
/*            If LanguageInfo<>Nil Then
              Begin
                   Inc(LanguageInfo,4);  //skip Size
                   GetMem(FLanguages,SizeOf(TLanguageInfo));
                   ps:=Pointer(LanguageInfo);
                   CurrentLanguage:=ps^;  //To determine Language !
                   Inc(LanguageInfo,Length(CurrentLanguage)+1);

                   While (LanguageInfo^ AND longword(255))<>0 Do //Read All entries
                   Begin
                        Inc(LanguageInfo);  //skip 1

                        If PLanguageInfo(FLanguages)^.Items=Nil Then
                        Begin
                             New(LangItem);
                             PLanguageInfo(FLanguages)^.Items:=LangItem;
                        End
                        Else
                        Begin
                             LangItem:=PLanguageInfo(FLanguages)^.Items;
                             While LangItem^.Next<>Nil Do LangItem:=LangItem^.Next;
                             New(LangItem^.Next);
                             LangItem:=LangItem^.Next;
                        End;

                        LangItem^.Next:=Nil;

                        ps:=Pointer(LanguageInfo);
                        GetMem(LangItem^.Name,Length(ps^)+1);
                        LangItem^.Name^:=ps^;
                        Inc(LanguageInfo,Length(ps^)+1);

                        ReadLanguage(LangItem^.Components);
                        ReadLanguage(LangItem^.Menus);
                        ReadLanguage(LangItem^.StringTables);
                   End; //While
                   Inc(LanguageInfo); //skip 0

                   If PLanguageInfo(FLanguages)^.Items=Nil Then //no Items
                   Begin
                        FreeMem(FLanguages,SizeOf(TLanguageInfo));
                        FLanguages:=Nil;
                   End
                   Else
                   Begin
                       //Set Current Language into Form^.LanguageInfo
                       LangItem:=PLanguageInfo(FLanguages)^.Items;
                       While LangItem<>Nil Do
                       Begin
                            If LangItem^.Name^=CurrentLanguage Then //found
                            Begin
                             PLanguageInfo(FLanguages)^.CurrentLanguageName:=LangItem^.Name;
                             PLanguageInfo(FLanguages)^.CurrentLanguageComponents:=LangItem^.Components;
                             PLanguageInfo(FLanguages)^.CurrentLanguageMenus:=LangItem^.Menus;
                             PLanguageInfo(FLanguages)^.CurrentLanguageStringTables:=LangItem^.StringTables;
                             break;
                            End;
                            LangItem:=LangItem^.Next;
                       End;

                       If PLanguageInfo(FLanguages)^.CurrentLanguageName=Nil Then
                       Begin
                           //Not found - Use First available Language
                           LangItem:=PLanguageInfo(FLanguages)^.Items;
                           PLanguageInfo(FLanguages)^.CurrentLanguageName:=LangItem^.Name;
                           PLanguageInfo(FLanguages)^.CurrentLanguageComponents:=LangItem^.Components;
                           PLanguageInfo(FLanguages)^.CurrentLanguageMenus:=LangItem^.Menus;
                           PLanguageInfo(FLanguages)^.CurrentLanguageStringTables:=LangItem^.StringTables;
                       End;
                   End;
              End;   */

              If Not ReadPropertiesSCU(Self,NameTable,ResourceTable,ClassPointer) Then
              Begin
                   InsideDesigner:=OldInsideDesigner;
                   Raise ESCUError.Create('ReadPropertiesSCU error');
              End;

              SetDesigning(InsideDesigner); //WDLng Or InsideLanguageDesigner);

              //check For Child Components
              If Not ReadComponentsSCU(NameTable,ResourceTable,ClassPointer) Then
              Begin
                   InsideDesigner:=OldInsideDesigner;
                   Raise ESCUError.Create('ReadComponentsSCU error');
              End;

              //links For the Form
              HandlePropertyLinks(Self);

              ReadResourceSCU(ResourceTable,ClassPointer);

/* WDLng      If FLanguages<>Nil Then
                If PLanguageInfo(FLanguages)^.CurrentLanguageName<>Nil Then
                   SetLanguage(Self,PLanguageInfo(FLanguages)^.CurrentLanguageName^);

              //If there's only the Default Language Left, Erase it !
              If FLanguages<>Nil Then
                If PLanguageInfo(FLanguages)^.Items<>Nil Then
                  If PLanguageInfo(FLanguages)^.Items^.Next=Nil Then
                    If PLanguageInfo(FLanguages)^.Items^.Name^='Default' Then
              Begin
                   FreeLanguage(PLanguageInfo(FLanguages)^.Items^.Components);
                   FreeLanguage(PLanguageInfo(FLanguages)^.Items^.Menus);
                   FreeLanguage(PLanguageInfo(FLanguages)^.Items^.StringTables);
                   FreeMem(PLanguageInfo(FLanguages)^.Items^.Name,Length(PLanguageInfo(FLanguages)^.Items^.Name^)+1);
                   Dispose(PLanguageInfo(FLanguages)^.Items);
                   FreeMem(FLanguages,SizeOf(TLanguageInfo));
                   FLanguages:=Nil;
              End; */

              {For the Form}
              LoadedFromSCU(Nil);
              Loaded;

              InsideDesigner:=OldInsideDesigner;
              Exit;
         End;
Next:
         dummy:=dummy^.NextEntry;
     End;

     InsideDesigner:=OldInsideDesigner;
End;


Procedure TComponent.ReadFromStream(SCUStream:TStream);
Var
    ClassMem,ClassPointer:^LongWord;
    OldPos:LongInt;
    OldInsideDesigner:Boolean;
    FileDesc:TSCUFileFormat;
    len:LongInt;
    NameTable:^LongWord;
    ResourceTable:^LongWord;
Begin
     Try
       ClassPointer:=Nil;
       OldInsideDesigner:=InsideDesigner;
       If InsideCompLib Then InsideDesigner:=False;

       OldPos:=SCUStream.Position;
       SCUStream.ReadBuffer(FileDesc,SizeOf(FileDesc));
       SCUStream.Position:=OldPos;

       len:=SizeOf(FileDesc)+FileDesc.ObjectLen+FileDesc.NameTableLen+FileDesc.ResourceLen;
       GetMem(ClassPointer,len);
       ClassMem:=ClassPointer;
       SCUStream.ReadBuffer(ClassPointer^,len);

       NameTable:=Pointer(ClassPointer);
       Inc(NameTable,FileDesc.NameTableOffset);
       ResourceTable:=Pointer(ClassPointer);
       Inc(ResourceTable,FileDesc.ResourceOffset);
       Inc(ClassPointer,FileDesc.ObjectOffset);

       LastSCUForm:=Owner;
       SetDesigning(InsideDesigner); // WDLng Or InsideLanguageDesigner);
       LoadingFromSCU(LastSCUForm);

       If Not ReadPropertiesSCU(LastSCUForm,NameTable,ResourceTable,ClassPointer) Then
         Raise ESCUError.Create('SCU error');
       If Not ReadComponentsSCU(NameTable,ResourceTable,ClassPointer) Then
         Raise ESCUError.Create('SCU error');
       ReadResourceSCU(ResourceTable,ClassPointer);

       LoadedFromSCU(LastSCUForm);
     Finally
       InsideDesigner:=OldInsideDesigner;
       If ClassMem<>Nil Then FreeMem(ClassMem,len);
     End;
End;

Procedure TComponent.WriteInfoToINI(InfoLine : String);

Var Cou : LongInt;

Begin
  if (AppIniFile=nil) or (fSaveLoadInfo=false) or (Designed) then exit;

  if InfoLine <> '' then
    AppIniFile.WriteString(INI_Sec_FormInfo, 'CI_'+UniqueName, InfoLine);

// Die Informationen fr Komponenten speichern
  For Cou:=0 to ComponentCount-1 do
    Components[Cou].WriteInfoToINI('');

End;

Function TComponent.ReadInfoFromINI : String;

Var Cou : LongInt;

Begin
  Result:='';
  if (AppIniFile=nil) or (fSaveLoadInfo=false) or (Designed) then exit;
  Result:=AppIniFile.ReadString(INI_Sec_FormInfo, 'CI_'+UniqueName, '');

// Die Informationen fr Komponenten lesen
  For Cou:=0 to ComponentCount-1 do
    Components[Cou].ReadInfoFromINI
End;

{$HINTS OFF}
Procedure TComponent.GetChildren(Proc:TGetChildProc);
Begin
End;
{$HINTS ON}


Function TComponent.HasParent:Boolean;
Begin
     Result := False;
End;

Function WritePropertiesToStream(FormList:TList):TMemoryStream;
Const Zero:LongInt=0;
      bt:Byte=1;
      bf:Byte=0;
Var  P,p1:^LongInt;
     pParent:^LongInt;
     S:String;
     tt,tt1,Pos1:LongInt;
     FormItem:PFormListItem;
     Stream:TMemoryStream;
     ResourceStream:TResourceStream;
     FileDesc:TSCUFileFormat;
     C:TComponent;
     D,N,E:String;
     bb:Byte;
     LangItem:PLanguageItem;
     LangPos,LangTemp:LongInt;
     dummy:PLanguageMessages;

     Function WriteLanguage(LangComp:PLanguageComponent):Boolean;
     Var Ende:Byte;
     Begin
          Result:=False;
          While LangComp<>Nil Do
          Begin
               If Stream.Write(bt,1)=0 Then Exit; //one more entry
               If Stream.Write(LangComp^.Name^,Length(LangComp^.Name^)+1)=0 Then Exit;
               If Stream.Write(LangComp^.ValueTyp,1)=0 Then Exit;
               If Stream.Write(LangComp^.ValueLen,4)=0 Then Exit;
               If Stream.Write(LangComp^.Value^,LangComp^.ValueLen)=0 Then Exit;

               If Stream.Write(LangComp^.ControlLeft,4)=0 Then Exit;
               If Stream.Write(LangComp^.ControlBottom,4)=0 Then Exit;
               If Stream.Write(LangComp^.ControlWidth,4)=0 Then Exit;
               If Stream.Write(LangComp^.ControlHeight,4)=0 Then Exit;

               LangComp:=LangComp^.Next;
          End;

          Ende:=0;
          If Stream.Write(Ende,1)=0 Then Exit; //no more entries
          Result:=True;
     End;

Label err;
Begin
     Result:=Nil;  //Some Error

     Stream.Create;
     Stream.Capacity:=32768;

     ResourceStream.Create;
     ResourceStream.Capacity:=32768;
     ResourceStream.SCUStream:=Stream;
     ResourceStream.FHeaderPos:=8;    {Initial Resource Header}

     NameTable.Create;

     FillChar(FileDesc,SizeOf(TSCUFileFormat),0);
     FileDesc.Version:=SCUVersion;
     If Stream.Write(FileDesc,SizeOf(TSCUFileFormat))=0 Then  //SCU Header
     Begin
err:
          Stream.Destroy;
          ResourceStream.Destroy;
          Result:=Nil;
          Exit;  //Some Error
     End;

     Try
        For tt:=0 To FormList.Count-1 Do
        Begin
             FormItem:=FormList.Items[tt];
             C:=Pointer(FormItem^.Form);
             If C = Nil Then Goto err; {need Form}

             bb:=0;

             If C.DesignerState*[dsAutoCreate]<>[] Then bb:=bb Or 1; //auto-created Form
// WDLng     If C.FLanguages<>Nil Then bb:=bb Or 2;                  //Multi Language
             //!!!!!!!!!! 4 Is reserved For locking Language !!!!!!!!!!!!!!!!!!!

             //note: Messages are global To an Application, Not To A Form !!!!
             If ((tt=0)And(LanguageMessages<>Nil)) Then bb:=bb Or 8; //Messages avail

             If Stream.Write(bb,1)=0 Then Goto err;

             S:=FormItem^.FormName+#0;
             UpcaseStr(S);
             If Stream.Write(S,Length(S)+1)=0 Then Goto err;
             S:=FormItem^.UnitName;
             FSplit(S,D,N,E);
             N:=N+#0;
             UpcaseStr(N);
             If Stream.Write(N,Length(N)+1)=0 Then Goto err;
             If FormItem^.FormName<>'' Then S:='T'+FormItem^.FormName
             Else S:=FormItem^.Form.ClassName;
             If Stream.Write(S,Length(S)+1)=0 Then Goto err; //runtime Class Name

             //Language Messages are only evaluated by Application.Create by examining the SCU Pointer !!!
             If ((tt=0)And(LanguageMessages<>Nil)) Then
             Begin
                  //Write Language Message information
                  LangPos:=Stream.Position;  //save Position
                  If Stream.Write(LangPos,4)=0 Then Goto err; //Size: patched later

                  If Stream.Write(AppLanguage,Length(AppLanguage)+1)=0 Then Goto err;

                  dummy:=LanguageMessages;
                  While dummy<>Nil Do
                  Begin
                      If Stream.Write(dummy^.Name^,Length(dummy^.Name^)+1)=0 Then Goto err;
                      If Stream.Write(dummy^.StringTableLen,4)=0 Then Goto err;
                      If dummy^.StringTableLen>0 Then
                        If Stream.Write(dummy^.StringTable^,dummy^.StringTableLen)=0 Then Goto err;
                      dummy:=dummy^.Next;
                  End;
                  If Stream.Write(bf,1)=0 Then Goto err; //no more entries
                  LangTemp:=Stream.Position;
                  Stream.Position:=LangPos;  //patch Size
                  LangPos:=LangTemp-LangPos;
                  If Stream.Write(LangPos,4)=0 Then Goto err;
                  Stream.Position:=LangTemp; //restore old Position
             End;

/* WDLng     If C.FLanguages<>Nil Then
             Begin
                  //Write Language information
                  LangPos:=Stream.Position;  //save Position
                  If Stream.Write(LangPos,4)=0 Then Goto err; //Size: patched later

                  If PLanguageInfo(C.FLanguages)^.CurrentLanguageName<>Nil Then
                  Begin
                      If Stream.Write(PLanguageInfo(C.FLanguages)^.CurrentLanguageName^,
                                      Length(PLanguageInfo(C.FLanguages)^.CurrentLanguageName^)+1)=0 Then Goto err;
                  End
                  Else
                  Begin
                      S:='Default';
                      If Stream.Write(S,Length(S)+1)=0 Then Goto err;
                  End;

                  LangItem:=PLanguageInfo(C.FLanguages)^.Items;

                  While LangItem<>Nil Do
                  Begin
                       If Stream.Write(bt,1)=0 Then Goto err; //one more entry
                       If Stream.Write(LangItem^.Name^,Length(LangItem^.Name^)+1)=0 Then Goto err;

                       If Not WriteLanguage(LangItem^.Components) Then Goto err;
                       If Not WriteLanguage(LangItem^.Menus) Then Goto err;
                       If Not WriteLanguage(LangItem^.StringTables) Then Goto err;

                       LangItem:=LangItem^.Next;
                  End;

                  If Stream.Write(bf,1)=0 Then Goto err; //no more entries

                  LangTemp:=Stream.Position;
                  Stream.Position:=LangPos;  //patch Size
                  LangPos:=LangTemp-LangPos;
                  If Stream.Write(LangPos,4)=0 Then Goto err;
                  Stream.Position:=LangTemp; //restore old Position
             End; */
        End;

        FileDesc.ObjectOffset:=Stream.Position;
        FileDesc.ObjectCount:=FormList.Count;    //Count Of Objects

        For tt:=0 To FormList.Count-1 Do
        Begin
             Pos1:=Stream.Position;

             tt1:=0;
             If Stream.Write(tt1,4)=0 Then Goto err;  //Length Of Object Info
                                                      //- patched later

             FormItem:=FormList.Items[tt];
             P:=Pointer(FormItem^.Form);
             P:=Pointer(P^);               //VMT Info

             Inc(P,4);
             P:=Pointer(P^);               //ClassInfo
             p1:=P;
             Inc(P,4);
             pParent:=Pointer(P^);         //parent Class VMT Or Nil
             Inc(P,8);
             P:=Pointer(P^);               //Property Pointer

             Inc(p1,16);                   //onto ClassName
             Move(p1^,S,(p1^ AND longword(255))+1);  //Inspector Class Name
             If Stream.Write(S,Length(S)+1)=0 Then Goto err; //Inspector Class Name

             If FormItem^.FormName<>'' Then S:='T'+FormItem^.FormName
             Else S:=FormItem^.Form.ClassName;
             If Stream.Write(S,Length(S)+1)=0 Then Goto err; //runtime Class Name
             If Stream.Write(FormItem^.UnitName,Length(FormItem^.UnitName)+1)=0 Then Goto err;

             If Not WriteProperties(Stream,P,TComponent(FormItem^.Form),pParent) Then Goto err;

             //Write Components that are owned by the Object
             If Not WriteObjectComponents(Stream,ResourceStream,TComponent(FormItem^.Form)) Then Goto err;

             If Not FormItem^.Form.WriteSCUResource(ResourceStream) Then Goto err;
             If Stream.Write(Zero,4)=0 Then Goto err; {no more resources}


             tt1:=Stream.Position;
             Stream.Position:=Pos1;
             Pos1:=tt1-Pos1;
             Stream.Write(Pos1,4);  //patch len Of Object Info For This entry
             Stream.Position:=tt1;
        End; //For

        FileDesc.ObjectLen:=Stream.Position-FileDesc.ObjectOffset;

        //patch Name Table
        FileDesc.NameTableOffset:=Stream.Position;
        If Not WriteNameTable(Stream) Then Goto err;
        FileDesc.NameTableLen:=Stream.Position-FileDesc.NameTableOffset;

        FileDesc.ResourceOffset:=Stream.Position;
        {Write Resource information}
        If Not ResourceStream.WriteResourcesToStream(Stream) Then Goto err;
        ResourceStream.Destroy;
        FileDesc.ResourceLen:=Stream.Position-FileDesc.ResourceOffset;
        {ab hier nichts mehr schreiben, sonst System.AddSCUData ndern}

        tt:=Stream.Position;   //save Position
        Stream.Position:=0;    //patch Header
        If Stream.Write(FileDesc,SizeOf(TSCUFileFormat))=0 Then Goto err;
        Stream.Position:=tt;   //restore Position
     Except
         ON ex:Exception Do
         Begin
             ErrorBox2(ex.Message);
             Stream.Destroy;
             ResourceStream.Destroy;
             Stream:=Nil;
         End;
     End;
     Result:=Stream;
End;


Function WritePropertiesToFile(FileName:String;FormList:TList):Boolean;
Var Stream:TMemoryStream;
Begin
     Stream:=WritePropertiesToStream(FormList);
     If Stream=Nil Then
     Begin
          Result:=False;
          Exit;
     End;

     Result:=True;
     Try
        Stream.SaveToFile(FileName);
     Except
        ON ex:Exception Do
        Begin
             ErrorBox2(ex.Message);
             Result:=False;
        End;
     End;

     Stream.Destroy;
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TStringItem Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TStringSelectList.SetupComponent;
Begin
     Inherited SetupComponent;
     FList.Create;
     FList.sorted:=True;
     Include(ComponentState, csDetail);
End;

Procedure TStringSelectList.SetStringItem(NewValue:String);
Begin
     FSelected:=NewValue;
End;

Destructor TStringSelectList.Destroy;
Begin
     FList.Destroy;
     FList := Nil;
     Inherited Destroy;
End;

Function TStringSelectList.GetItems:TStringList;
Begin
     Result:=FList;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TBits Class Implementation                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Destructor TBits.Destroy;
Begin
  FreeMem(FBits, (FSize + 31) Shr 5);
  FBits := Nil;
  Inherited Destroy;
End;

Procedure TBits.Error;
Begin
  Raise EBitsError.Create(LoadNLSStr(SEBitsErrorText));
End;

Function TBits.GetBit(Index: LongInt): Boolean;
Var
  Place: Cardinal;
Begin
  If (Index < 0) Or (Index >= FSize) Then Error;
  Place := longword(1) Shl (Index And 31);
  Index := Index Shr 5;
  Result := (FBits^[Index] And Place) <> 0;
End;

Function TBits.OpenBit: LongInt;
Var
  I, J, K: LongInt;
  B: Cardinal;
Begin
  I := 0;
  J := (FSize + 31) Shr 5;
  While (I < J) And (FBits^[I] = 0) Do Inc(I);
  If I < J Then
  Begin
    K := 1;
    Result := I Shl 5;
    B := FBits^[I];
    While (B And K) = 0 Do
    Begin
      K := K Shl 1;
      Inc(Result);
    End;
    If Result >= FSize Then Result := -1;
  End
  Else Result := -1;
End;

Procedure TBits.SetBit(Index: LongInt; bit: Boolean);
Var
  Place: Cardinal;
Begin
  If (Index < 0) Or (Index >= FSize) Then Error;
  Place := longword(1) Shl (Index And 31);
  Index := Index Shr 5;
  If bit Then FBits^[Index] := FBits^[Index] Or Place
  Else FBits^[Index] := FBits^[Index] And Not Place;
End;

Procedure TBits.SetSize(NewSize: LongInt);
Begin
  If NewSize < 0 Then Error;
  If FSize = 0 Then FBits := AllocMem((NewSize + 31) Shr 3)
  Else FBits := ReAllocMem(FBits, (FSize + 31) Shr 3, (NewSize + 31) Shr 3);
  FSize := NewSize;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TPropertyEditClassDialog Class Implementation               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    PPropertyEditClassItem=^TPropertyEditClassItem;
    TPropertyEditClassItem=Record
         ClassToEdit: TClass;                            //Editor Class (Class editors) Or parent Class (others)
         PropertyName:String[64];                        //Property Name For normal editors
         ClassPropertyEditor: TClassPropertyEditorClass; //<>Nil For Class Property editors
         PropertyEditor:TPropertyEditorClass;            //<>Nil For normal Property editors
    End;


{$HINTS OFF}
Function TClassPropertyEditor.Execute(Var ClassToEdit:TObject):TClassPropertyEditorReturn;
Begin
     Result:=peCancel;  //Not Handled
End;
{$HINTS ON}

Procedure AddPropertyEditor(OwnerClass:TClass;PropertyName:String;PropertyEditor:TPropertyEditorClass);
Var T:LongInt;
    dummy:PPropertyEditClassItem;
Begin
     UpcaseStr(PropertyName);

     For T:=0 To PropertyEditDialogs.Count-1 Do
     Begin
          dummy:=PropertyEditDialogs.Items[T];

          If dummy^.PropertyEditor<>Nil Then //normal Property Editor ??
            If OwnerClass=dummy^.ClassToEdit Then
              If dummy^.PropertyName=PropertyName Then
              Begin
                  //replace existing
                  dummy^.PropertyEditor:=PropertyEditor;
                  Exit;
              End;
     End;

     New(dummy);
     dummy^.ClassToEdit:=OwnerClass;
     dummy^.PropertyName:=PropertyName;
     dummy^.PropertyEditor:=PropertyEditor;
      PropertyEditDialogs.Add(dummy);
End;

Function CallPropertyEditor(Owner:TComponent;PropertyName:String;Var Value;ValueLen:LongInt;
                            Var List:TStringList):TPropertyEditorReturn;
Var T:LongInt;
    dummy:PPropertyEditClassItem;
    Editor:TPropertyEditor;
    S:String;

Label go;
Begin
  Result:=edNoEditor;
  UpcaseStr(PropertyName);
  For T:=0 To PropertyEditDialogs.Count-1 Do
    Begin
      dummy:=PropertyEditDialogs.Items[T];
      If dummy^.PropertyEditor<>Nil Then //normal Property Editor ??
        If Owner.ClassType=dummy^.ClassToEdit Then
          If dummy^.PropertyName=PropertyName Then
            Begin
go:
              Editor:=dummy^.PropertyEditor.Create(Nil);
              Editor.FOwner:=Owner;
              Editor.FPropertyName:=PropertyName;
              List.Create;
              Editor.FList:=List;
              Try
                If Editor Is TStringPropertyEditor
                  Then
                    Begin
                      System.Move(Value,S,ValueLen);
                      Result:=TStringPropertyEditor(Editor).Execute(S,ValueLen);
                      System.Move(S,Value,ValueLen);
                    End
                  Else If Editor Is TShortIntPropertyEditor Then
                    Result:=TShortIntPropertyEditor(Editor).Execute(ShortInt(Value))
                  Else If Editor Is TIntegerPropertyEditor Then
                    Result:=TIntegerPropertyEditor(Editor).Execute(Integer(Value))
                  Else If Editor Is TLongIntPropertyEditor Then
                    Result:=TLongIntPropertyEditor(Editor).Execute(LongInt(Value))
                  Else
                    Result:=Editor.Execute(Value,ValueLen);
                  List:=Editor.FList;
                  Editor.Destroy;
              Except
                Result:=edNoEditor;
              End;
              Exit;
            End;
    End;
    For T:=0 To PropertyEditDialogs.Count-1 Do
      Begin
        dummy:=PropertyEditDialogs.Items[T];
        If dummy^.PropertyEditor<>Nil Then //normal Property Editor ??
          If Owner Is dummy^.ClassToEdit Then
            If dummy^.PropertyName=PropertyName Then
              Begin
                Goto go;
              End;
      End;

     {Search In registered Property editors Of the complib}
    If @CallCompLibPropertyEditor<>Nil
      Then Result := CallCompLibPropertyEditor(Owner,PropertyName,Value,ValueLen,List);
End;

Function PropertyEditorAvailable(OwnerClass:TClass;PropertyName:String):Boolean;
Var T:LongInt;
    dummy:PPropertyEditClassItem;
Begin
     Result:=False;
     UpcaseStr(PropertyName);

     For T:=0 To PropertyEditDialogs.Count-1 Do
     Begin
          dummy:=PropertyEditDialogs.Items[T];

          If dummy^.PropertyEditor<>Nil Then //normal Property Editor ??
            If dummy^.PropertyName=PropertyName Then
              If OwnerClass Is dummy^.ClassToEdit Then
              Begin
                  Result:=True;
                  Exit;
              End;
     End;

     If @CallCompLibPropertyEditorAvailable<>Nil Then
        Result:=CallCompLibPropertyEditorAvailable(OwnerClass,PropertyName);
End;


Procedure AddClassPropertyEditor(ClassToEdit:TClass;PropertyEditor:TClassPropertyEditorClass);
Var T:LongInt;
    dummy:PPropertyEditClassItem;
Begin
     For T:=0 To PropertyEditDialogs.Count-1 Do
     Begin
          dummy:=PropertyEditDialogs.Items[T];

          If dummy^.ClassPropertyEditor<>Nil Then //Class Property Editor ??
            If dummy^.ClassToEdit=ClassToEdit Then
            Begin
                 //replace existing
                 dummy^.ClassPropertyEditor:=PropertyEditor;
                 Exit;
            End;
     End;

     New(dummy);
     dummy^.ClassToEdit:=ClassToEdit;
     dummy^.ClassPropertyEditor:=PropertyEditor;
     PropertyEditDialogs.Add(dummy);
End;

Function ClassPropertyEditorAvailable(ClassName:String):Boolean;

Var s1:String;
    AOwner:TClass;

  Function process(Const s1:String):Boolean;
  Var T:LongInt;
      dummy:PPropertyEditClassItem;
      S:String;
  Begin
    Result:=False;
    For T:=0 To PropertyEditDialogs.Count-1 Do
      Begin
        dummy:=PropertyEditDialogs.Items[T];
        If dummy^.ClassPropertyEditor<>Nil Then //Class Property Editor ???
          Begin
            S:=dummy^.ClassToEdit.ClassName;
            UpcaseStr(S);
            If S=s1 Then
              Begin
                Result:=True;
                Exit;
              End;
          End;
      End;
  End;  { Function: Process }

Label L,ex;
Begin
   Result:=False;
   s1:=ClassName;
   UpcaseStr(s1);
   If process(s1) Then
     Begin
       Result:=True;
       Exit;
     End;

   //check If it Is Some derived Object
   AOwner:=SearchClassByName(ClassName);
   If AOwner=Nil Then goto ex;
L:
   AOwner:=AOwner.ClassParent;
   If AOwner<>Nil Then
     Begin
       s1:=AOwner.ClassName;
       UpcaseStr(s1);
       If process(s1)
         Then Result:=True
         Else Goto L;
     End;

ex:
     If @CallComplibClassPropertyEditorAvailable<>Nil Then
       Result:=Result Or CallCompLibClassPropertyEditorAvailable(ClassName);
End;

Function CallClassPropertyEditor(Var ClassToEdit:TObject):TClassPropertyEditorReturn;
Var s1:String;
    AOwner:TClass;
    res:TClassPropertyEditorReturn;

  Function process(Const s1:String):Boolean;
  Var T:LongInt;
      dummy:PPropertyEditClassItem;
      Editor:TClassPropertyEditor;
      S:String;
  Begin
    Result:=False;
    For T:=0 To PropertyEditDialogs.Count-1 Do
      Begin
        dummy:=PropertyEditDialogs.Items[T];
        If dummy^.ClassPropertyEditor<>Nil Then //Is it A Class Property Editor ??
          Begin
             S:=dummy^.ClassToEdit.ClassName;
             UpcaseStr(S);
             If S=s1 Then
               Begin
                 Editor:=dummy^.ClassPropertyEditor.Create(Nil);
                 res:=Editor.Execute(ClassToEdit);
                 Editor.Destroy;
                 Result:=True;
                 Exit;
               End;
          End;
      End;
  End;     { Function: Process }

Begin
  Result:=peNoEditor;
  s1:=ClassToEdit.ClassName;

  UpcaseStr(s1);
  If process(s1) Then
    Begin
      Result:=res;
      Exit;
    End;

  {Search In registered Property editors Of the complib}
  If @CallCompLibClassPropertyEditor<>Nil
     Then Result := CallCompLibClassPropertyEditor(ClassToEdit);
  If Result<>peNoEditor Then exit;

  //check If it Is Some derived Object
  AOwner := ClassToEdit.ClassType;

  While AOwner.ClassParent <> Nil Do
    Begin
      AOwner:=AOwner.ClassParent;
      s1:=AOwner.ClassName;
      UpcaseStr(s1);
      If process(s1) Then
        Begin
          Result:=res;
          Exit;
        End;
    End;
  Result:=peNoEditor;
End;

///////////////////////////////////////////////////////////////////////////

Function GetExperts:TList;
Begin
 Result:=LibExperts;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TCollectionItem Class Implementation                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TCollectionItem.GetIndex:LongInt;
Begin
     If FCollection=Nil Then Result:=-1
     Else Result:=FCollection.FItems.IndexOf(Self);
End;

Procedure TCollectionItem.SetCollection(NewValue:TCollection);
Begin
     If NewValue=FCollection Then Exit;

     If FCollection<>Nil Then FCollection.RemoveItem(Self);
     If NewValue<>Nil Then NewValue.InsertItem(Self);
End;

Procedure TCollectionItem.changed(AllItems:Boolean);
Begin
     If FCollection<>Nil Then If FCollection.FUpdateCount=0 Then
     Begin
          If AllItems Then FCollection.Update(Nil)
          Else FCollection.Update(Self);
     End;
End;

Procedure TCollectionItem.SetIndex(NewIndex:LongInt);
Begin
     If NewIndex=Index Then Exit
     Else If Index>=0 Then
     Begin
          FCollection.FItems.Move(Index,NewIndex);
          changed(True);
     End;
End;

Constructor TCollectionItem.Create(ACollection: TCollection);
Begin
     Inherited Create;
     collection:=ACollection;
End;

Destructor TCollectionItem.Destroy;
Begin
     collection:=Nil;
     Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TCollection Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TCollection.GetCount:LongInt;
Begin
     Result:=FItems.Count;
End;

Procedure TCollection.InsertItem(Item:TCollectionItem);
Begin
     If Not (Item Is FItemClass) Then Raise EListError.Create(LoadNLSStr(SCollectionErrorText))
     Else
     Begin
          FItems.Add(Item);
          Item.FCollection:=Self;
          changed;
     End;
End;

Procedure TCollection.RemoveItem(Item:TCollectionItem);
Begin
     FItems.Remove(Item);
     Item.FCollection:=Nil;
     changed;
End;

Procedure TCollection.changed;
Begin
     If FUpdateCount=0 Then Update(Nil);
End;

Function TCollection.GetItem(Index:LongInt):TCollectionItem;
Begin
     Result:=TCollectionItem(FItems[Index]);
End;

Procedure TCollection.SetItem(Index:LongInt;Value:TCollectionItem);
Var dummy:TCollectionItem;
Begin
     dummy:=TCollectionItem(FItems[Index]);
     dummy.Assign(Value);
End;

{$HINTS OFF}
Procedure TCollection.Update(Item:TCollectionItem);
Begin
End;
{$HINTS ON}

Procedure TCollection.SetupComponent;
Begin
     Inherited SetupComponent;

     FItemClass:=TCollectionItem;
     FItems.Create;
     Include(ComponentState,csDetail);
End;

Destructor TCollection.Destroy;
Begin
     FUpdateCount:=1;
     Clear;
     FItems.Destroy;

     Inherited Destroy;
End;

Function TCollection.Add:TCollectionItem;
Begin
     Result:=FItemClass.Create(Self);
End;

Procedure TCollection.Assign(Source:TCollection);
Var dummy:TCollectionItem;
    T:LongInt;
Begin
     If ((Source=Nil)Or(Source=Self)) Then Exit;

     BeginUpdate;
     Try
        Clear;
        For T:=0 To Source.Count-1 Do
        Begin
             dummy:=Self.Add;
             dummy.Assign(Source.Items[T]);
        End;
     Finally
            EndUpdate;
     End;
End;

Procedure TCollection.BeginUpdate;
Begin
     Inc(FUpdateCount);
End;

Procedure TCollection.EndUpdate;
Begin
     Dec(FUpdateCount);
     changed;
End;

Procedure TCollection.Clear;
Var T:LongInt;
    dummy:TCollectionItem;
Begin
     If FItems.Count=0 Then Exit;

     BeginUpdate;
     Try
        For T:=FItems.Count-1 DownTo 0 Do
        Begin
             dummy:=FItems[T];
             dummy.Destroy;
        End;
        FItems.Clear;
     Finally
        EndUpdate;
     End;
End;

Begin
  LanguageMessages:=Nil;
  AppLanguage:='Default';
  AppIniFile:=nil;
  InsideCompLib:=False;
  InsideWriteSCU:=False;
  InsideWriteSCUAdr:=@InsideWriteSCU;
  InsideDesigner:=False;
//WDLng  InsideLanguageDesigner:=False;
  RegisteredClasses.Create;
  PropertyEditDialogs.Create;
  LibExperts.Create;
  LibExpertInstances.Create;
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  27-Sep-02  WD         Ausbau der LINUX-Teile
  01-Jan-03  WD         Funktion tStringList.AddSplit eingebaut
  26-Nov-03  WD         Delay-Funktion mit SysSleep ausgetauscht
  10-Jun-04  WD         Ausbau von tThread. Diese Klasse ist zu uSysClass gewandert
  08-Aug-04  MV         1 Shl --> longword(1) Shl, AND 255  -->  AND longword(255)
  07-Jul-05  WD         TComponent.UniqueName: Ermittelt einen eindeutigen Namen
  20-Jul-05  WD         Abspeichern div Infos in die Application-INI-Datei
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  05-Sep-05  WD         Umbau der Datei auf den WDSibyl-Compiler
  09-Mar-06  WD         Paramstr(0) durch goSysInfo ersetzt.
  02-Dez-06  WD         Entfernen der Variable "InsideLanguageDesigner"
  01-Jan-08  WD         GetTempFileName ist jetzt in SysUtil gewandert.
  15-Mar.08  MV         Const-Teil: kbCtrlBkSp: OS/2 liefert hier immer eine gedrckte Alt Taste
}


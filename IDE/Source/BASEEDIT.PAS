
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Visual Development Environment                                บ
 บ                                                                          บ
 บ    Copyright (C) 1995,99 SpeedSoft Germany,   All rights reserved.       บ
 บ    Copyright (C) 2002..  Ing. Wolfgang Draxler,   All rights reserved.   บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ WDSibyl Integrated Development Environment (IDE)                         บ
 บ Object-oriented development system.                                      บ
 บ                                                                          บ
 บ Copyright (C) 1995,99 SpeedSoft GbR, Germany                             บ
 บ Copyright (C) 2002..  Ing. Wolfgang Draxler                              บ
 บ                                                                          บ
 บ This program is free software; you can redistribute it and/or modify it  บ
 บ under the terms of the GNU General Public License (GPL) as published by  บ
 บ the Free Software Foundation; either version 2 of the License, or (at    บ
 บ your option) any later version. This program is distributed in the hope  บ
 บ that it will be useful, but WITHOUT ANY WARRANTY; without even the       บ
 บ implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR          บ
 บ PURPOSE.                                                                 บ
 บ See the GNU General Public License for more details. You should have     บ
 บ received a copy of the GNU General Public License along with this        บ
 บ program; if not, write to the Free Software Foundation, Inc., 59 Temple  บ
 บ Place - Suite 330, Boston, MA 02111-1307, USA.                           บ
 บ                                                                          บ
 บ In summary the original copyright holders (SpeedSoft) grant you the      บ
 บ right to:                                                                บ
 บ                                                                          บ
 บ - Freely modify and publish the sources provided that your modification  บ
 บ   is entirely free and you also make the modified source code available  บ
 บ   to all for free (except a fee for disk/CD production etc).             บ
 บ                                                                          บ
 บ - Adapt the sources to other platforms and make the result available     บ
 บ   for free.                                                              บ
 บ                                                                          บ
 บ Under this licence you are not allowed to:                               บ
 บ                                                                          บ
 บ - Create a commercial product on whatever platform that is based on the  บ
 บ   whole or parts of the sources covered by the license agreement. The    บ
 บ   entire program or development environment must also be published       บ
 บ   under the GNU General Public License as entirely free.                 บ
 บ                                                                          บ
 บ - Remove any of the copyright comments in the source files.              บ
 บ                                                                          บ
 บ - Disclosure any content of the source files or use parts of the source  บ
 บ   files to create commercial products. You always must make available    บ
 บ   all source files whether modified or not.                              บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

UNIT BaseEdit;

INTERFACE

// WDSibyl.RC muss da geladen werden, denn sonst koennen die Resourcen im
// Initialisierungsteil nicht geladen werden

{$R WDSIBYL}       
                        
{$IFDEF OS2}              
USES Os2Def,BseDos;
{$ENDIF}

{$IFDEF Win32}
USES WinDef;             
{$ENDIF}

USES Dos,SysUtils,Color,Classes,Forms,Graphics,Grids,Dialogs,Editors,Consts, DAsm,
     uList;

CONST
    bgcRight          = 7;
    fgcHIL            = 8;
    bgcHIL            = 9;
    fgcSTR            = 10;
    bgcSTR            = 11;
    fgcASM            = 12;
    bgcASM            = 13;
    fgcNumber         = 14;
    bgcNumber         = 15;
    fgcSymbol         = 16;
    bgcSymbol         = 17;
    fgcREM1           = 18;     {}
    bgcREM1           = 19;     {}
    fgcREM2           = 20;     (**)
    bgcREM2           = 21;     (**)
    fgcREM3           = 22;     /**/
    bgcREM3           = 23;     /**/
    fgcREM4           = 24;     //
    bgcREM4           = 25;     //
    fgcREM5           = 26;     { $}
    bgcREM5           = 27;     { $}
    fgcBreak          = 28;
    bgcBreak          = 29;
    fgcInvBrk         = 30;
    bgcInvBrk         = 31;
    fgcExec           = 32;
    bgcExec           = 33;
    fgcError          = 34;
    bgcError          = 35;

    ciDebugLine       = 32;
    ciBreakpointLine  = 64;
    ciErrorLine       = 128;
    ciRem1            = 256;      {}
    ciRem2            = 512;      (**)
    ciRem3            = 1024;     /**/
    ciRem5            = 2048;     { $%}
    ciAsm             = 4096;     {ASM...END}
    ciMultiLineBits   = ciRem1 + ciRem2 + ciRem3 + ciRem5 + ciAsm;


TYPE
    TBaseEditor=CLASS;

    TIconBar=CLASS(TToolbar)
      PRIVATE
         Editor:TBaseEditor;
         IconArray:ARRAY[1..80] OF WORD;
         PROCEDURE UpdateIcon(ScrY:INTEGER;pl:PLine);
         FUNCTION GetBitmapFromLine(pl:PLine;row:LONGINT):WORD;
         FUNCTION IconRectFromLine(ScrY:INTEGER):TRect;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
      PUBLIC
         PROCEDURE Redraw(CONST rec:TRect);OVERRIDE;
    END;


    TBaseEditor=CLASS(TEditor)
      PRIVATE
         FShortName:STRING;
         FRightBackColor:TColor;
         FHilightColor:TColor;
         FHilightBackColor:TColor;
         FStringColor:TColor;
         FStringBackColor:TColor;
         FAsmColor:TColor;
         FAsmBackColor:TColor;
         FNumberColor:TColor;
         FNumberBackColor:TColor;
         FSymbolColor:TColor;
         FSymbolBackColor:TColor;
         FRem1Color:TColor;
         FRem1BackColor:TColor;
         FRem2Color:TColor;
         FRem2BackColor:TColor;
         FRem3Color:TColor;
         FRem3BackColor:TColor;
         FRem4Color:TColor;
         FRem4BackColor:TColor;
         FRem5Color:TColor;
         FRem5BackColor:TColor;
         FBreakColor:TColor;
         FBreakBackColor:TColor;
         FInvBrkColor:TColor;
         FInvBrkBackColor:TColor;
         FExecColor:TColor;
         FExecBackColor:TColor;
         FErrorColor:TColor;
         FErrorBackColor:TColor;
         CurrentScreenLine:LONGINT;

         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt); Override;
      PROTECTED
         flagPlainText:BYTE;
         flagMarkedBlock:BYTE;
         flagSearchMatch:BYTE;
         flagReservedWord:BYTE;
         flagAsmBlock:BYTE;
         flagStrings:BYTE;
         flagNumber:BYTE;
         flagSymbol:BYTE;
         flagComment1:BYTE;
         flagComment2:BYTE;
         flagComment3:BYTE;
         flagComment4:BYTE;
         flagComment5:BYTE;
         flagValidBreak:BYTE;
         flagInvalidBreak:BYTE;
         flagExecPoint:BYTE;
         flagErrorLine:BYTE;
         flagRightMargin:BYTE;
      PUBLIC
         IconBar:TIconBar;
         DebuggerLine:PLine;
         DebuggerY:LONGINT;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE CalcLineColorFlag(zk:PSTRING;VAR flag:LONGWORD);
         FUNCTION  UpdateLineColorFlag(pl:PLine):BOOLEAN;OVERRIDE;
         PROCEDURE SetLineColorFlag(pl1,pl2:PLine);OVERRIDE;
         PROCEDURE CalcLineColor(pl:PLine;VAR LineColor:TColorArray;Var LineAtt : tAttributeArray);OVERRIDE;
         PROCEDURE CalcPascalColor(pl:PLine;VAR LineColor:TColorArray);
         PROCEDURE SetColorEntry(ColorIndex:INTEGER;NewColor:TColor);OVERRIDE;
         FUNCTION  GetColorEntry(ColorIndex:INTEGER):TColor;OVERRIDE;
         PROCEDURE InvalidateScreenLine(ScrY:INTEGER);OVERRIDE;
         PROCEDURE ReadBreakPoints;
         PROCEDURE WriteBreakPoints;
         FUNCTION CursorFromMouse(pt:TPoint):TEditorPos;
         PROCEDURE DoEndDrag(Target:TObject; X,Y:LONGINT);OVERRIDE;
         PROCEDURE SetFileName(CONST FName:STRING);OVERRIDE;
      PUBLIC
         FUNCTION  LoadFromFile(CONST FName:STRING):BOOLEAN;OVERRIDE;
         PROCEDURE ToTop;VIRTUAL;
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE SetDebuggerLine(y:LONGINT);
         PROCEDURE cmToggleBreakpoint;
         PROCEDURE ClearAllBreakPoints;
         PROCEDURE DebugStepInto;
         PROCEDURE DebugStepOver;
         PROCEDURE DebugGotoLine;
         PROPERTY FirstLine;
         PROPERTY PLines;
         PROPERTY ShortName:STRING read FShortName;
         PROCEDURE InvalidateEditor(y1,y2:INTEGER);OVERRIDE;
    END;


    TAdrAccess=(aaNone,aaRead,aaWrite,aaReadWrite);
    TBreakPointStatus=(bpsActive,bpsInactive,bpsCleared);

    PBreakPoint=^TBreakPoint;
    TBreakPoint=RECORD
         FileName:PSTRING;             {DateiName}
         Line:LONGINT;                 {ZeilenNummer}
         Address:LongWord;             {Adresse der Zeile}
         Condition:PSTRING;            {Bedingung}
         AdrAddress:LongWord;             {berwachte Adresse}
         AdrAccess:TAdrAccess;         {Zugriffsart auf Adresse}
         AdrSize:BYTE;                 {0,1,2,4 Byte}
         Status:TBreakPointStatus;     {aktiv,inaktiv,gel”scht}
    END;


    TBreakPointList=CLASS(TList)
      PRIVATE
         FUNCTION  GetFName(idx:LONGINT):STRING;
         FUNCTION  GetFileName(idx:LONGINT):STRING;
         PROCEDURE SetFileName(idx:LONGINT;Value:STRING);
         FUNCTION  GetLine(idx:LONGINT):LONGINT;
         PROCEDURE SetLine(idx:LONGINT;Value:LONGINT);
         FUNCTION  GetAddress(idx:LONGINT):LongWord;
         PROCEDURE SetAddress(idx:LONGINT;Value:LongWord);
         FUNCTION  GetState(idx:LONGINT):TBreakPointStatus;
         PROCEDURE SetState(idx:LONGINT;Value:TBreakPointStatus);
         FUNCTION  GetBreakCount:LONGINT;
      PROTECTED
         PROCEDURE FreeItem(Item:PBreakPoint); virtual; {OVERRIDE; }
      PUBLIC
         FUNCTION  AddBreakPoint(FileName:STRING;Line:LONGINT):LONGINT;
         PROCEDURE RemoveBreakPoint(FileName:STRING;Line:LONGINT);
         FUNCTION  RemoveBreakPointShort(FileName:STRING;Line:LONGINT):STRING;
         PROCEDURE DeleteBreakPoint(idx:LONGINT);
         PROCEDURE ClearBreakPoints;
         PROCEDURE SetDebuggerBreakPoint(idx:LONGINT);
         PROCEDURE ResetDebuggerBreakPoint(idx:LONGINT);
      PUBLIC
         PROPERTY  FNames[idx:LONGINT]:STRING              {Name.Ext}
                   read GetFName;
         PROPERTY  FileNames[idx:LONGINT]:STRING           {Dir\Name.Ext}
                   read GetFileName write SetFileName;
         PROPERTY  Lines[idx:LONGINT]:LONGINT              {Zeilennummer}
                   read GetLine write SetLine;
         PROPERTY  Address[idx:LONGINT]:LongWord              {Adresse der Zeile}
                   read GetAddress write SetAddress;
         PROPERTY  States[idx:LONGINT]:TBreakPointStatus   {aktiv,inaktiv,gel”scht}
                   read GetState write SetState;
         PROPERTY  BreakCount:LONGINT
                   read GetBreakCount;
    END;


PROCEDURE ClearAllBreakPoints;  {l”scht alle BPs in Liste,Editors,Debugger}
PROCEDURE InitBreakPoints;      {initialisiert alle BPs beim Start des Debuggers}
FUNCTION GetColorCode(fg,bg,flag:BYTE):WORD;
Function CheckWordsOnly(pl:PLine; Var I:Integer; Const S:String):Boolean;

CONST
    TestProjectBookMarkProc:FUNCTION(Editor:TEditor;row:LONGINT):BOOLEAN=NIL;
    AddDAsmEditorNotify:PROCEDURE(Editor:TEditor)=NIL;
    DAsmEditorCloseNotify:PROCEDURE(Editor:TEditor)=NIL;
    RemarkAllCPUBreaksProc:PROCEDURE=NIL;
    UpdateBreakpointListProc:PROCEDURE=NIL;

VAR
    EditorIconList:ARRAY[1400..1416] OF TBitmap;
    UpcaseTable:STRING;
    SymbolTable:STRING;
    BreakPointList:TBreakPointList;

CONST
    LastDbgEditor:TBaseEditor=NIL;


IMPLEMENTATION


FUNCTION SearchKeyWord:BOOLEAN;ASSEMBLER;
{ Fast search for PASCAL keywords
  IN:  AL  - character
       ESI - points to the next char
  OUT: EBX - number of chars of the keyword (0..NoKey)
       AX  - TAGflag (Bit0=ASM/ASSEMBLER)}
     ASM
        CMP EBX,0
        JE !PascalSyntax
        ////////////////
        // andere Syntax verwenden
        ////////////////
!PascalSyntax:
        MOV AH,0
        MOV EDX,[ESI+0]
        AND EAX,255
        SUB AL,65
        LEA EBX,*!CaseTable
        JMP [EBX+EAX*4]

!Char_A:
        MOV EBX,3                 //length of keyword
        CMP DX,'ND'
        JE !FKeyWord              //AND
        MOV EBX,5
        CMP EDX,'RRAY'
        JE !FKeyWord              //ARRAY
        CMP EDX,'BSTR'
        JNE !NoABSTR
        CMPW [ESI+4],'AC'
        JNE !FNoKey
        CMPB [ESI+6],'T'
        JNE !FNoKey
        MOV EBX,8
        JMP !FKeyWord             //ABSTRACT
!NoABSTR:
        CMP EDX,'BSOL'
        JNE !NoABSOL
        CMPW [ESI+4],'UT'
        JNE !FNoKey
        CMPB [ESI+6],'E'
        JNE !FNoKey
        MOV EBX,8
        JMP !FKeyWord             //ABSOLUTE
!NoABSOL:
        CMP DL,'S'
        JNE !FNoKey
        MOV EBX,3
        CMP DX,'SM'
        JE !FAsmWord              //ASM
        MOV EBX,2
        CMP EDX,'SSEM'
        JNE !FKeyWord             //AS
        CMPD [ESI+4],'BLER'
        JNE !FKeyWord             //AS
        MOV EBX,9
        JMP !FAsmWord             //ASSEMBLER

!Char_B:
        CMP EDX,'EGIN'
        JNE !FNoKey
        MOV EBX,5
        JMP !FKeyWord             //BEGIN

!Char_C:
        CMP DX,'AS'
        JNE !NoCAS
        CMPB [ESI+2],'E'
        JNE !FNoKey
        MOV EBX,4
        JMP !FKeyWord             //CASE
!NoCAS:
        CMP EDX,'STRI'
        JNE !NoCSTRI
        CMPW [ESI+4],'NG'
        JNE !FNoKey
        MOV EBX,7
        JMP !FKeyWord             //CSTRING
!NoCSTRI:
        CMP EDX,'LASS'
        JNE !NoCLASS
        MOV EBX,5
        JMP !FKeyWord             //CLASS
!NoCLASS:
        CMP EDX,'ONST'
        JNE !FNoKey
        MOV EBX,5
        CMPD [ESI+4],'RUCT'
        JNE !FKeyWord             //CONST
        CMPW [ESI+8],'OR'
        JNE !FKeyWord             //CONST
        MOV EBX,11
        JMP !FKeyWord             //CONSTRUCTOR

!Char_D:
        MOV EBX,3
        CMP DX,'IV'
        JE !FKeyWord              //DIV
        CMP DL,'O'
        JNE !NoDO
        MOV EBX,2
        CMPD [ESI+1],'WNTO'
        JNE !FKeyWord             //DO
        MOV EBX,6
        JMP !FKeyWord             //DOWNTO
!NoDO:
        CMP EDX,'YNAM'
        JNE !NoDYNAM
        CMPW [ESI+4],'IC'
        JNE !FNoKey
        MOV EBX,7
        JMP !FKeyWord             //DYNAMIC
!NoDYNAM:
        CMP EDX,'ESTR'
        JNE !FNokey
        CMPD [ESI+4],'UCTO'
        JNE !FNokey
        CMPB [ESI+8],'R'
        JNE !FNoKey
        MOV EBX,10
        JMP !FKeyWord             //DESTRUCTOR

!Char_E:
        MOV EBX,3
        CMP DX,'ND'
        JE !FKeyWord              //_END
        CMP DX,'LS'
        JNE !NoELS
        CMPB [ESI+2],'E'
        JNE !FNoKey
        MOV EBX,4
        JMP !FKeyWord             //ELSE
!NoELS:
        CMP EDX,'XCEP'
        JNE !NoEXCEP
        CMPB [ESI+4],'T'
        JNE !FNoKey
        MOV EBX,6
        JMP !FKeyWord             //EXCEPT
!NoEXCEP:
        CMP EDX,'XPOR'
        JNE !FNoKey
        CMPW [ESI+4],'TS'
        JNE !FNoKey
        MOV EBX,7
        JMP !FKeyWord             //EXPORTS

!Char_F:
        CMP DX,'OR'
        JNE !NoFOR
        MOV EBX,3
        CMPD [ESI+2],'WARD'
        JNE !FKeyWord             //FOR
        MOV EBX,7
        JMP !FKeyWord             //FORWARD
!NoFOR:
        CMP EDX,'UNCT'
        JNE !NoFUNCT
        CMPW [ESI+4],'IO'
        JNE !FNoKey
        CMPB [ESI+6],'N'
        JNE !FNoKey
        MOV EBX,8
        JMP !FKeyWord             //FUNCTION
!NoFUNCT:
        CMP DX,'IL'
        JNE !NoFIL
        CMPB [ESI+2],'E'
        JNE !FNoKey
        MOV EBX,4
        JMP !FKeyWord             //FILE
!NoFIL:
        CMP EDX,'INAL'
        JNE !FNoKey
        CMPW [ESI+4],'LY'
        JNE !NoFINALLY
        MOV EBX,7
        JMP !FKeyWord             //FINALLY
!NoFINALLY:
        CMPD [ESI+4],'IZAT'
        JNE !FNoKey
        CMPW [ESI+8],'IO'
        JNE !FNoKey
        CMPB [ESI+10],'N'
        JNE !FNoKey
        MOV EBX,12
        JMP !FKeyWord             //FINALIZATION

!Char_G:
        CMP DX,'OT'
        JNE !FNoKey
        CMPB [ESI+2],'O'
        JNE !FNoKey
        MOV EBX,4
        JMP !FKeyWord             //GOTO

!Char_I:
        MOV EBX,2
        CMP DL,'F'
        JE !FKeyWord              //IF
        CMP DL,'S'
        JE !FKeyWord              //IS
        CMP DL,'N'
        JNE !NoIN
        CMP EDX,'NHER'
        JNE !NoINHER
        MOV EBX,9
        CMPD [ESI+4],'ITED'
        JE !FKeyWord              //INHERITED
        JMP !IsIN
!NoINHER:
        CMP EDX,'NTER'
        JNE !NoINTER
        CMPD [ESI+4],'FACE'
        JNE !IsIN
        MOV EBX,9
        JMP !FKeyWord             //INTERFACE
!NoINTER:
        CMP EDX,'NITI'
        JNE !IsIN
        CMPD [ESI+4],'ALIZ'
        JNE !IsIN
        CMPD [ESI+8],'ATIO'
        JNE !IsIN
        CMPB [ESI+12],'N'
        JNE !IsIN
        MOV EBX,14
        JMP !FKeyWord             //INITIALIZATION
!IsIN:
        MOV EBX,2
        JNE !FKeyWord             //IN
!NoIN:
        CMP EDX,'MPOR'
        JNE !NoIMPOR
        CMPW [ESI+4],'TS'
        JNE !FNoKey
        MOV EBX,7
        JMP !FKeyWord             //IMPORTS
!NoIMPOR:
        CMP EDX,'MPLE'
        JNE !FNoKey
        CMPD [ESI+4],'MENT'
        JNE !FNoKey
        CMPD [ESI+8],'ATIO'
        JNE !FNoKey
        CMPB [ESI+12],'N'
        JNE !FNoKey
        MOV EBX,14
        JMP !FKeyWord             //IMPLEMENTATION

!Char_L:
        MOV EBX,5
        CMP EDX,'ABEL'
        JE !FKeyWord              //LABEL
        CMP EDX,'IBRA'
        JNE !FNoKey
        CMPW [ESI+4],'RY'
        JNE !FNoKey
        MOV EBX,7
        JMP !FKeyWord             //LIBRARY

!Char_M:
        CMP DX,'OD'
        JNE !NoMOD
        MOV EBX,3
        JMP !FKeyWord             //MOD
!NoMOD:
        CMP EDX,'ETHO'
        JNE !NoMETHO
        CMPB [ESI+4],'D'
        JNE !FNoKey
        MOV EBX,6
        JMP !FKeyWord             //METHOD
!NoMETHO:
        CMP EDX,'ESSA'
        JNE !FNoKey
        CMPW [ESI+4],'GE'
        JNE !FNoKey
        CMPB [ESI-2],'.'
        JE !FNoKey                {part of record}
        MOV EBX,7
        JMP !FKeyWord             //MESSAGE

!Char_N:
        MOV EBX,3
        CMP DX,'IL'
        JE !FKeyWord              //NIL
        CMP DX,'OT'
        JE !FKeyWord              //NOT
        JMP !FNokey

!Char_O:
        MOV EBX,2
        CMP DL,'R'
        JE !FKeyWord              //OR
        CMP DL,'F'
        JE !FKeyWord              //OF
        CMP DL,'N'
        JE !FKeyWord              //ON
        CMP EDX,'VERR'
        JNE !NoOVERR
        CMPW [ESI+4],'ID'
        JNE !FNoKey
        CMPB [ESI+6],'E'
        JNE !FNoKey
        MOV EBX,8
        JMP !FKeyWord             //OVERRIDE
!NoOVERR:
        CMP EDX,'BJEC'
        JNE !NoOBJEC
        CMPB [ESI+4],'T'
        JNE !FNoKey
        MOV EBX,6
        JMP !FKeyWord             //OBJECT
!NoOBJEC:
        CMP EDX,'PERA'
        JNE !FNoKey
        CMPW [ESI+4],'TO'
        JNE !FNoKey
        CMPB [ESI+6],'R'
        JNE !FNoKey
        MOV EBX,8
        JMP !FKeyWord             //OPERATOR

!Char_P:
        CMP EDX,'ROCE'
        JNE !NoPROCE
        CMPD [ESI+4],'DURE'
        JNE !FNoKey
        MOV EBX,9
        JMP !FKeyWord             //PROCEDURE
!NoPROCE:
        CMP EDX,'RIVA'
        JNE !NoPRIVA
        CMPW [ESI+4],'TE'
        JNE !FNoKey
        MOV EBX,7
        JMP !FKeyWord             //PRIVATE
!NoPRIVA:
        CMP EDX,'UBLI'
        JNE !NoPUBLI
        CMPB [ESI+4],'C'
        JNE !NoPUBLIC
        MOV EBX,6
        JMP !FKeyWord             //PUBLIC
!NoPUBLIC:
        CMPD [ESI+4],'SHED'
        JNE !FNoKey
        MOV EBX,9
        JMP !FKeyWord             //PUBLISHED
!NoPUBLI:
        CMP DX,'RO'
        JNE !FNoKey
        CMPD [ESI+2],'PERT'
        JNE !NoPROPERT
        CMPB [ESI+6],'Y'
        JNE !FNoKey
        MOV EBX,8
        JMP !FKeyWord             //PROPERTY
!NoPROPERT:
        CMP EDX,'ROTE'
        JNE !NoPROTE
        CMPD [ESI+4],'CTED'
        JNE !FNoKey
        MOV EBX,9
        JMP !FKeyWord             //PROTECTED
!NoPROTE:
        CMPD [ESI+2],'GRAM'
        JNE !FNoKey
        MOV EBX,7
        JMP !FKeyWord             //PROGRAM

!Char_R:
        CMP EDX,'ECOR'
        JNE !NoRECOR
        CMPB [ESI+4],'D'
        JNE !FNoKey
        MOV EBX,6
        JMP !FKeyWord             //RECORD
!NoRECOR:
        CMP EDX,'EPEA'
        JNE !NoREPEA
        CMPB [ESI+4],'T'
        JNE !FNoKey
        MOV EBX,6
        JMP !FKeyWord             //REPEAT
!NoREPEA:
        CMP EDX,'AISE'
        JNE !FNoKey
        MOV EBX,5
        JMP !FKeyWord             //RAISE

!Char_S:
        MOV EBX,3
        CMP DX,'ET'
        JE !FKeyWord              //SET
        CMP DX,'HL'
        JE !FKeyWord              //SHL
        CMP DX,'HR'
        JE !FKeyWord              //SHR
        CMP EDX,'TRIN'
        JNE !NoSTRIN
        CMPB [ESI+4],'G'
        JNE !FNoKey
        MOV EBX,6
        JMP !FKeyWord             //STRING
!NoSTRIN:
        CMP DX,'EL'
        JNE !NoSEL
        CMPB [ESI+2],'F'
        JNE !FNoKey
        MOV EBX,4
        JMP !FKeyWord             //SELF
!NoSEL:
        CMP EDX,'TORE'
        JNE !FNoKey
        CMPB [ESI+4],'D'
        JNE !FNoKey
        MOV EBX,6
        JMP !FKeyWord             //STORED

!Char_T:
        CMP DX,'HE'
        JNE !NoTHE
        CMPB [ESI+2],'N'
        JNE !FNoKey
        MOV EBX,4
        JMP !FKeyWord             //THEN
!NoTHE:
        MOV EBX,2
        CMP DL,'O'
        JE !FKeyWord              //TO
        MOV EBX,3
        CMP DX,'RY'
        JE !FKeyWord              //TRY
        CMP DX,'YP'
        JNE !NoTYP
        CMPB [ESI+2],'E'
        JNE !FNoKey
        MOV EBX,4
        JMP !FKeyWord             //TYPE
!NoTYP:
        CMP EDX,'HREA'
        JNE !FNoKey
        CMPD [ESI+4],'DVAR'
        JNE !FNoKey
        MOV EBX,9
        JMP !FKeyWord             //THREADVAR

!Char_U:
        MOV EBX,5
        CMP EDX,'NTIL'
        JE !FKeyWord              //UNTIL
        CMP DX,'SE'
        JNE !NoUSE
        CMPB [ESI+2],'S'
        JNE !FNoKey
        MOV EBX,4
        JMP !FKeyWord             //USES
!NoUSE:
        CMP DX,'NI'
        JNE !FNoKey
        CMPB [ESI+2],'T'
        JNE !FNoKey
        MOV EBX,4
        JMP !FKeyWord             //UNIT

!Char_V:
        CMP DX,'AR'
        JNE !NoVAR
        MOV EBX,3
        JMP !FKeyWord             //VAR
!NoVAR:
        CMP EDX,'IRTU'
        JNE !FNoKey
        CMPW [ESI+4],'AL'
        JNE !FNoKey
        MOV EBX,7
        JMP !FKeyWord             //VIRTUAL

!Char_W:
        MOV EBX,5
        CMP EDX,'HILE'
        JE !FKeyWord              //WHILE
        CMP DX,'IT'
        JNE !FNoKey
        CMPB [ESI+2],'H'
        JNE !FNoKey
        MOV EBX,4
        JMP !FKeyWord             //WITH

!Char_X:
        MOV EBX,3
        CMP DX,'OR'
        JE !FKeyWord              //XOR
!FNoKey:
        MOV EBX,0
        JMP !FEnd
!FKeyWord:
        MOV AX,0
        JMP !FEnd
!FAsmWord:
        MOV AX,1                  //tagASM
        JMP !FEnd

!CaseTable:
        DD *!Char_A
        DD *!Char_B
        DD *!Char_C
        DD *!Char_D
        DD *!Char_E
        DD *!Char_F
        DD *!Char_G
        DD *!FNoKey
        DD *!Char_I
        DD *!FNoKey
        DD *!FNoKey
        DD *!Char_L
        DD *!Char_M
        DD *!Char_N
        DD *!Char_O
        DD *!Char_P
        DD *!FNoKey
        DD *!Char_R
        DD *!Char_S
        DD *!Char_T
        DD *!Char_U
        DD *!Char_V
        DD *!Char_W
        DD *!Char_X
        DD *!FNoKey
        DD *!FNoKey
!FEnd:
        MOV result,AX
     END;

Function CheckWordsOnly(pl:PLine; Var I:Integer; Const S:String):Boolean;
Begin
     Result := False;
     If I = 0 Then Exit;

     If I > 1 Then
       If pl^.zk^[I-1] In NormalChars Then
       Begin
            I := - I;
            Exit;
       End;

     If I+Length(S)-1 < Length(pl^.zk^) Then
       If pl^.zk^[I+Length(S)] In NormalChars Then
       Begin
            I := - I;
            Exit;
       End;
     Result := True;
End;



PROCEDURE TBaseEditor.CalcLineColorFlag(zk:PSTRING; VAR flag:LONGWORD);
VAR  REMflag:LONGWORD;
     ASMflag:LONGWORD;
BEGIN
     REMflag := flag;
     ASMflag := REMflag AND ciAsm;
      ASM
        CLD
        MOV EDI,0
        MOV ESI,zk
        XOR ECX,ECX
        MOV CL,[ESI]
        CMP ECX,0
        JE !srs0
        INC ESI

        MOV EAX,REMflag
        TEST EAX,256     //ciRem1
        JNZ !srsREM1a

        TEST EAX,2048    //ciRem5
        JNZ !srsREM1a

        TEST EAX,512     //ciRem2
        MOV BH,')'
        JNZ !srsREM2a

        TEST EAX,1024    //ciRem3
        MOV BH,'/'
        JNZ !srsREM2a

        TEST EAX,4096    //ciAsm
        JNZ !srsASMa

!srsloop:
        LODSB
        CMP AL,39
        JE !srsSTR
        CMP AL,'{'
        JE !srsREM1
        CMP AL,'*'
        JE !srsREM2
        CMP AL,'/'
        JE !srsREM4
        OR AL,$20
        CMP AL,'a'
        JE !srsASM
        JMP !srsnext


!srsSTR:
        MOVD REMflag,0
        DEC CL
        JZ !srs0
!srsstr1:
        LODSB
        CMP AL,39
        JE !srsnext
        LOOP !srsstr1
        JMP !srs0

!srsREM1:
        MOV EAX,256      //ciRem1
        CMPB [ESI],'$'
        JE !srsREM1x
        CMPB [ESI],'%'
        JNE !srsREM1y
!srsREM1x:
        MOV EAX,2048     //ciRem5
!srsREM1y:
        MOV REMflag,EAX
        DEC CL
        JZ !srs0
!srsREM1a:
        LODSB
        CMP AL,'}'
        JE !srsnext
        LOOP !srsREM1a
        JMP !srs0

!srsREM2:
        CMPB [ESI-2],'('
        JE !srs1
        CMPB [ESI-2],'/'
        JNE !srsnext
        ADD EDI,2
        CMP EDI,ESI
        JE !srsnext
        MOV BH,'/'
        MOV EAX,1024     //ciRem3
        MOV REMflag,EAX
        JMP !srs2
!srs1:
        MOV BH,')'
        MOV EAX,512      //ciRem2
        MOV REMflag,EAX
!srs2:
        DEC CL
        JZ !srs0
!srsREM2a:
        LODSB
        CMP AL,'*'
        JNE !srsREM2b
        CMP [ESI+0],BH
        JNE !srsREM2b
        DEC CL
        JZ !srs0
        MOV EDI,ESI
        LODSB
        JMP !srsnext
!srsREM2b:
        LOOP !srsREM2a
        JMP !srs0

!srsREM4:
        CMPB [ESI+0],'/'
        JNE !srsnext
        MOVD REMflag,0
        JMP !srs0

!srsASM:
        MOV EBX,OFFSET(BaseEdit.UpcaseTable)
        CMP CL,3
        JB !srsnext
        MOV AX,[ESI+0]
        OR AX,$2020
        CMP AX,'sm'
        MOV AL,[ESI+2]  //Separator nach 'asm'
        JE !srsAsmSep
        CMP CL,9
        JB !srsnext
        MOV EAX,[ESI+0]
        OR EAX,$20202020
        CMP EAX,'ssem'
        JNE !srsnext
        MOV EAX,[ESI+4]
        OR EAX,$20202020
        CMP EAX,'bler'
        JNE !srsnext
        CMP CL,9
        JE !srsasm3
        MOV AL,[ESI+8]  //Separator nach 'assembler'
!srsAsmSep:
        CMP CL,3
        JE !srsasm3
        XLAT
        CMP AL,'0'
        JB !srsasm3
        CMP AL,'_'
        JE !srsnext
        CMP AL,'Z'
        JA !srsasm3
        CMP AL,':'
        JB !srsnext
        CMP AL,'?'
        JA !srsnext
!srsasm3:
        MOV AL,[ESI-2]
        XLAT
        CMP AL,'0'
        JB !srsisasm
        CMP AL,'_'
        JE !srsnext
        CMP AL,'Z'
        JA !srsisasm
        CMP AL,':'
        JB !srsnext
        CMP AL,'?'
        JA !srsnext
!srsisasm:
        MOV EAX,4096     //ciAsm
        MOV REMflag,EAX
        MOV ASMflag,EAX
        ADD ESI,2
        SUB CL,3
        JZ !srs0
!srsASMa:
        LODSB
        MOV AH,[ESI+0]
        CMP AX,'//'
        JE !srs0

        CMP AL,'{'
        JE !srsREM1
        CMP AL,'*'
        JE !srsREM2

        CMP AL,39
        JNE !srsNoAsmStr
        DEC CL
        JZ !srs0
!srsAsmStr:
        LODSB
        CMP AL,39
        JE !srsNoAsmEnd
        LOOP !srsasmStr
        JMP !srs0

!srsNoAsmStr:
        CMP CL,3
        JB !srsNoAsmEnd
        OR AL,$20
        CMP AL,'e'
        JNE !srsNoAsmEnd
        MOV AX,[ESI+0]
        OR AX,$2020
        CMP AX,'nd'
        JNE !srsNoAsmEnd
        MOV AL,[ESI+2]
        MOV EBX,OFFSET(BaseEdit.UpcaseTable)
        XLAT
        CMP AL,'0'
        JB !srsasm4
        CMP AL,'_'
        JE !srsNoAsmEnd
        CMP AL,'Z'
        JA !srsasm4
        CMP AL,':'
        JB !srsNoAsmEnd
        CMP AL,'?'
        JA !srsNoAsmEnd
!srsasm4:
        MOV AL,[ESI-2]
        XLAT
        CMP AL,'0'
        JB !srsisend
        CMP AL,'_'
        JE !srsNoAsmEnd
        CMP AL,'Z'
        JA !srsisend
        CMP AL,':'
        JB !srsNoAsmEnd
        CMP AL,'?'
        JA !srsNoAsmEnd
!srsisend:
        MOVD REMflag,0
        MOVD ASMflag,0
        JMP !srsnext

!srsNoAsmEnd:
        DEC CL
        JNZ !srsASMa
        JMP !srs0

!srsnext:
        MOVD REMflag,4096   //ciAsm
        CMPD ASMflag,0
        JNE !srsNoAsmEnd

        MOVD REMflag,0
        DEC ECX
        JNZ !srsloop
!srs0:
     END;

     flag := REMflag OR ASMflag;
END;


FUNCTION TBaseEditor.UpdateLineColorFlag(pl:PLine):BOOLEAN;
VAR  zk:PSTRING;
     REMflag:LONGWORD;
     OldREMflag:LONGWORD;
BEGIN
     Result := FALSE;
     IF pl = NIL THEN exit;

     REMflag := pl^.flag AND ciMultiLineBits;
     WHILE pl <> LastLine DO
     BEGIN
          zk := PStrings[pl];
          CalcLineColorFlag(zk,REMflag);

          pl := pl^.next;
          OldREMflag := pl^.flag AND ciMultiLineBits;
          pl^.flag := (pl^.flag AND (NOT ciMultiLineBits)) OR REMflag;

          IF OldREMflag = REMflag THEN pl := LastLine
          ELSE Result := TRUE;
     END;
END;


PROCEDURE TBaseEditor.SetLineColorFlag(pl1,pl2:PLine);
VAR  zk:PSTRING;
     REMflag:LONGWORD;
BEGIN
     IF (pl1 = NIL) OR (pl2 = NIL) THEN exit;

     REMflag := pl1^.flag AND ciMultiLineBits;
     WHILE pl1 <> pl2 DO
     BEGIN
          zk := PStrings[pl1];
          CalcLineColorFlag(zk,REMflag);

          pl1 := pl1^.next;
          pl1^.flag := (pl1^.flag AND (NOT ciMultiLineBits)) OR REMflag;
     END;
     UpdateLineColorFlag(pl2);
END;


PROCEDURE TBaseEditor.CalcLineColor(pl:PLine;VAR LineColor:TColorArray;Var LineAtt : tAttributeArray);
BEGIN
  Inherited CalcLineColor(pl,LineColor,LineAtt);
  IF pl = NIL THEN exit;
  CalcPascalColor(pl,LineColor);
END;


FUNCTION GetColorCode(fg,bg,flag:BYTE):WORD;
BEGIN
  IF (flag AND usefore) <> 0 THEN fg := fgcPlainText;
  IF (flag AND useback) <> 0 THEN bg := bgcPlainText;
  Result := fg OR (bg SHL 8);
END;


PROCEDURE TBaseEditor.CalcPascalColor(pl:PLine;VAR LineColor:TColorArray);
VAR  aHil:WORD;
     aStr:WORD;
     aAsm:WORD;
     aNum:WORD;
     aSym:WORD;
     aRem1:WORD;
     aRem2:WORD;
     aRem3:WORD;
     aRem4:WORD;
     aRem5:WORD;
     aPlain:WORD;
     aTestSel:BYTE;
     aTestFind:BYTE;
     REMflag:LONGWORD;
     ASMflag:LONGWORD;
     HLS:STRING;
     Lng:BYTE;
     i,ac:INTEGER;
     row:LONGINT;
     usefg,usebg:BOOLEAN;
     invalid:BOOLEAN;
     HexZahl:BYTE;
     SyntaxCaseTable:POINTER;
BEGIN
     SyntaxCaseTable := NIL;

     {Berechne Farben der PASCAL-Keywords}
     aHIL := GetColorCode(fgcHIL,bgcHIL,flagReservedWord);
     aStr := GetColorCode(fgcSTR,bgcSTR,flagStrings);
     aAsm := GetColorCode(fgcASM,bgcASM,flagAsmBlock);
     aNum := GetColorCode(fgcNumber,bgcNumber,flagNumber);
     aSym := GetColorCode(fgcSymbol,bgcSymbol,flagSymbol);
     aRem1 := GetColorCode(fgcREM1,bgcREM1,flagComment1);
     aRem2 := GetColorCode(fgcREM2,bgcREM2,flagComment2);
     aRem3 := GetColorCode(fgcREM3,bgcREM3,flagComment3);
     aRem4 := GetColorCode(fgcREM4,bgcREM4,flagComment4);
     aRem5 := GetColorCode(fgcREM5,bgcREM5,flagComment5);
     aPlain := GetColorCode(fgcPlainText,bgcPlainText,flagPlainText);
     aTestSel := bgcMarkedBlock;
     aTestFind := bgcSearchMatch;

     HLS := PStrings[pl]^;
     Lng := Length(HLS);
     REMflag := pl^.flag;
     ASMflag := REMflag AND ciAsm;
     ASM
        MOV EDI,LineColor
        CLD
        LEA ESI,HLS
        XOR ECX,ECX
        MOV CL,Lng
        OR CL,CL
        JE !NoChar
        INC ESI
        MOV EBX,OFFSET(BaseEdit.UpcaseTable)
!ucsfilter:
        MOV AL,[ESI]
        XLAT
        MOV [ESI],AL
        INC ESI
        DEC ECX
        JNZ !ucsfilter
        MOVB [ESI+0],0       //StringEnde #0

        CLD
        MOV EDI,LineColor
        LEA ESI,HLS
        MOV EBX,0
        MOV ECX,0
        MOV CL,Lng
        MOVB [ESI+0],0       //StringAnfang #0
        INC ESI

        MOV EAX,REMflag
        MOV DX,aRem1
        TEST EAX,256         //ciRem1
        JNZ !rem1a

        MOV DX,aRem5
        TEST EAX,2048        //ciRem5
        JNZ !rem1a

        MOV DX,aRem2
        TEST EAX,512         //ciRem2
        MOV BH,')'
        JNZ !rem2a

        MOV DX,aRem3
        TEST EAX,1024        //ciRem3
        MOV BH,'/'
        JNZ !rem2a

        MOV DX,aAsm
        TEST EAX,4096        //ciAsm
        MOV BH,0
        JNZ !remasma

!loop:
        LODSB
        CMP AL,39
        JE !Str1
        CMP AL,'{'
        JE !Rem1
        CMP AL,'*'
        JE !Rem2
        CMP AL,'/'
        JE !Rem4
        CMP AL,'#'
        JE !Str2
        CMP AL,'^'
        JE !Str3

        CMP AL,'A'
        JB !NoLetter
        CMP AL,'Z'
        JA !NoLetter

!Letter:
        MOV AH,[ESI-2]
        CMP AH,'0'
        JB !prevOk
        CMP AH,'_'
        JE !next
        CMP AH,'Z'
        JA !prevOk
        CMP AH,':'
        JB !next
        CMP AH,'?'
        JA !next
!prevOk:
        MOV EBX,SyntaxCaseTable  {Adresse der Syntax CASE Table}

        CALLN32 BaseEdit.SearchKeyWord
        CMP BL,0
        JE !next
        PUSH ESI
        ADD ESI,EBX
        DEC ESI

        MOV BH,[ESI+0]
        CMP BH,'0'
        JB !Key
        CMP BH,'_'
        JE !NoSep
        CMP BH,'Z'
        JA !Key
        CMP BH,':'
        JB !NoSep
        CMP BH,'?'
        JA !NoSep
        JMP !Key
!NoSep:
        POP ESI
        JMP !next
!Key:
        POP EDX
        SUB CL,BL
        MOV DX,aHil
        TEST AX,1
        JNZ !RemASM
!mark:
        MOV AL,aTestSel
        CMP [EDI+1],AL
        JE !NotMark
        MOV AL,aTestFind
        CMP [EDI+1],AL
        JE !NotMark
        MOV [EDI+0],DX
!NotMark:
        ADD EDI,2
        DEC BL
        JNZ !mark
        CMP ECX,0
        JZ  !NoChar

        CMPD ASMflag,0
        JNE !remasma

        JMP !loop

!Str1:
        MOV DX,aStr
        MOV BL,1
        DEC CL
        JZ !mark
!str1a:
        DEC CL
        INC BL
        LODSB
        CMP AL,39
        JE !mark
        CMP CL,0
        JNZ !str1a
        JMP !mark

!Str2:
        MOV AH,[ESI-2]
        CMP AH,'A'
        JB !str2a
        CMP AH,'Z'
        JBE !NoLetter            {check symbol #}
        CMP AH,'_'
        JE !NoLetter             {check symbol #}
!str2a:
        MOV AH,[ESI+0]
        CMP AH,'$'               //Hex Zahlen?
        JNE !str2aa
        MOV AH,[ESI+1]
!str2aa:                         //Zahlen?
        CMP AH,'9'
        JA !NoLetter             {check symbol #}
        CMP AH,'0'
        JB !NoLetter             {check symbol #}
        MOV DX,aStr
        MOV BL,1
        DEC CL
        JZ !mark
!str2b:
        MOV AL,[ESI+0]
        CMP AL,'$'
        JE !str2bb
        CMP AL,'9'
        JA !mark
        CMP AL,'0'
        JB !mark
!str2bb:
        DEC CL
        INC BL
        LODSB
        CMP CL,0
        JNZ !str2b
        JMP !mark

!Str3:
        MOV AH,[ESI-2]
        CMP AH,39        // '
        JE !Str3a
        CMP AH,'+'       // +
        JE !Str3a
        CMP AH,'('       // (
        JE !Str3a
        CMP AH,'0'
        JB !NoLetter             {check symbol ^}
        CMP AH,'9'
        JBE !Str3a
        CMP AH,'A'
        JB !NoLetter             {check symbol ^}
        CMP AH,'Z'
        JA !NoLetter             {check symbol ^}
!Str3a:
        MOV AH,[ESI+0]         {gltige SteuerCodes}
        CMP AH,'@'
        JE !Str3b
//        CMP AH,'['
//        JE !Str3b
        CMP AH,']'
        JE !Str3b
        CMP AH,'\'
        JE !Str3b
        CMP AH,'^'
        JE !Str3b
        CMP AH,'_'
        JE !Str3b
        CMP AH,'A'
        JB !NoLetter             {check symbol ^}
        CMP AH,'Z'
        JA !NoLetter             {check symbol ^}
!Str3b:
        MOV DX,aStr
        MOV BL,2
        DEC CL
        DEC CL
        LODSB
        JMP !mark

!Rem1:
        MOV DX,aRem1
        CMPB [ESI],'$'
        JNE !Rem1_
        MOV DX,aRem5
!Rem1_:
        MOV BL,1
        DEC CL
        JZ !mark
!rem1a:
        DEC CL
        INC BL
        LODSB
        CMP AL,'}'
        JE !mark
        CMP CL,0
        JNZ !rem1a
        JMP !mark

!Rem2:
        CMPB [ESI-2],'('
        JE !r1
        CMPB [ESI-2],'/'
        JNE !NoLetter             {check symbol *}
        MOV DX,aRem3
        MOV BH,'/'
        JMP !r0
!r1:
        MOV DX,aRem2
        MOV BH,')'
!r0:
        SUB EDI,2
        MOV BL,2
        DEC CL
        JZ !mark
!rem2a:
        DEC CL
        INC BL
        LODSB
        CMP AL,'*'
        JNE !rem2b
        CMP [ESI+0],BH
        JNE !rem2a
        DEC CL
        INC BL
        LODSB
        MOVB [ESI-1],0
        JMP !mark
!rem2b:
        CMP CL,0
        JNZ !rem2a
        JMP !mark

!Rem4:
        CMPB [ESI+0],'/'
        JNE !NoLetter             {check symbol *}
        MOV DX,aRem4
        MOV BL,CL
        MOV CL,0
        JMP !mark

!RemASM:
        MOVD ASMflag,2048
        MOV AL,aTestSel
        CMP [EDI+1],AL
        JE !NotMarkASM
        MOV AL,aTestFind
        CMP [EDI+1],AL
        JE !NotMarkASM
        MOV [EDI+0],DX
!NotMarkASM:
        ADD EDI,2
        DEC BL
        JNZ !RemASM
        CMP ECX,0
        JZ !NoChar
        MOV BL,0

!remasma:
        LODSB
        CMP AL,'{'
        JE !AsmRem
        MOV AH,[ESI-2]
        CMP AX,'*('
        JE !AsmRem
        CMP AX,'*/'
        JE !AsmRem
        MOV AH,[ESI+0]
        CMP AX,'//'
        JNE !NoAsmRem

!AsmRem:
        CMP BL,0
        JE !gray1
!Green1:
        MOV DL,aTestSel
        CMP [EDI+1],DL
        JE !NotGreen1
        MOV DL,aTestFind
        CMP [EDI+1],DL
        JE !NotGreen1
        MOV DL,aAsm
        MOV [EDI+0],DX
!NotGreen1:
        ADD EDI,2
        DEC BL
        JNZ !Green1
        CMP ECX,0
        JZ !NoChar
!gray1:
        MOV DX,aRem1
        CMP AL,'{'
        JE !Rem1
        MOV DX,aRem2
        CMP AL,'*'
        JE !Rem2

        MOV BL,CL              // // erkannt
        MOV CL,0
        MOV DX,aRem4
        JMP !mark

!NoAsmRem:
        CMP AL,39
        JNE !NoAsmStr
        CMP BL,0
        JE !red2
        MOV DX,aAsm
!Green2:
        MOV AL,aTestSel
        CMP [EDI+1],AL
        JE !NotGreen2
        MOV AL,aTestFind
        CMP [EDI+1],AL
        JE !NotGreen2
        MOV [EDI+0],DX
!NotGreen2:
        ADD EDI,2
        DEC BL
        JNZ !Green2
        CMP ECX,0
        JZ !NoChar
!red2:
        MOV DX,aStr
        MOV BL,1
        DEC CL
        JZ !mark
!red2a:
        DEC CL
        INC BL
        LODSB
        CMP AL,39
        JE !red2b
        CMP CL,0
        JNZ !red2a
        JMP !mark
!red2b:
        MOV AL,aTestSel
        CMP [EDI+1],AL
        JE !red2c
        MOV AL,aTestFind
        CMP [EDI+1],AL
        JE !red2c
        MOV [EDI+0],DX
!red2c:
        ADD EDI,2
        DEC BL
        JNZ !red2b
        CMP ECX,0
        JZ !NoChar
        JMP !remasma

!NoAsmStr:
        CMP AL,'E'
        JNE !NoAsmEnd
        CMPW [ESI+0],'ND'
        JNE !NoAsmEnd
        MOV AH,[ESI+2]
        CMP AH,'0'
        JB !asm3
        CMP AH,'_'
        JE !NoAsmEnd
        CMP AH,'Z'
        JA !asm3
        CMP AH,':'
        JB !NoAsmEnd
        CMP AH,'?'
        JA !NoAsmEnd
!asm3:
        MOV AH,[ESI-2]
        CMP AH,'0'
        JB !isend
        CMP AH,'_'
        JE !NoAsmEnd
        CMP AH,'Z'
        JA !isend
        CMP AH,':'
        JB !NoAsmEnd
        CMP AH,'?'
        JA !NoAsmEnd
!isend:
        CMP BL,0
        JE !white3
        MOV DX,aAsm
!Green3:
        MOV AL,aTestSel
        CMP [EDI+1],AL
        JE !NotGreen3
        MOV AL,aTestFind
        CMP [EDI+1],AL
        JE !NotGreen3
        MOV [EDI+0],DX
!NotGreen3:
        ADD EDI,2
        DEC BL
        JNZ !Green3
        CMP ECX,0
        JZ !NoChar
!white3:
        MOVD ASMflag,0
        ADD ESI,2
        MOV DX,aHil
        MOV BL,3
        SUB CL,3
        JMP !mark

!NoAsmEnd:
        INC BL
        DEC CL
        JNZ !remasma
        MOV DX,aAsm
        JMP !mark

!NoLetter:                 {test ob Symbol oder Nummer}
        PUSH EBX
        MOV AH,AL          {save}
        MOV EBX,OFFSET(BaseEdit.SymbolTable)
        XLAT
        POP EBX
        CMP AL,0
        JE !NoSymbol
        MOV DX,aSym
        MOV BL,1
        DEC CL
        JMP !mark

!NoSymbol:
        MOV AL,AH          {restore}
        CMP AL,'0'
        JB !NoNumber
        CMP AL,'9'
        JA !NoNumber
        {Number? test Separators}
        MOV AH,[ESI-2]     {Sep bevor}
        /////////////////////////////////
        MOV HexZahl,AH     {wenn dort '$' drin steht, wird auch a-f akzeptiert}
        ////////////////////////////////
        CMP AH,'0'
        JB !prevNumOk
        CMP AH,'9'
        JBE !next          {keine Zahl!}
        CMP AH,'?'
        JBE !prevNumOk
        CMP AH,'_'
        JE !next
        CMP AH,'Z'
        JBE !next
!prevNumOk:
        MOV DX,aNum
        MOV BL,1
        DEC CL
        JZ !mark
!Num1a:
        DEC CL
        INC BL
        LODSB
        ////////////////////
        CMP HexZahl,'$'
        JNE !TestNum          {nur Zahlen sind erlaubt}
        CMP AL,'F'
        JA !nextNumTest
        CMP AL,'A'
        JAE !NumOk
!TestNum:
        ///////////////////
        CMP AL,'0'
        JB !nextNumTest
        CMP AL,'9'
        JA !nextNumTest
!NumOk:
        CMP CL,0
        JNZ !Num1a
        ////////////////
        CMP HexZahl,'$'
        JNE !mark
        DEC EDI
        DEC EDI
        INC BL            {'$' auch mit highlighten}
        ////////////////
        JMP !mark
!nextNumTest:
        CMP AL,'?'
        JBE !nextNumOk
        CMP AL,'_'
        JE !nextNumFailed
        CMP AL,'Z'
        JBE !nextNumFailed
!nextNumOk:                  {Sep danach ist Ok}
        DEC BL               {Sep nicht mit hiliten}
        INC CL
        DEC ESI
        ////////////////
        CMP HexZahl,'$'
        JNE !mark
        DEC EDI
        DEC EDI
        INC BL            {'$' auch mit highlighten}
        ////////////////
        JMP !mark
!nextNumFailed:
        MOV DX,aPlain
        JMP !mark

!NoNumber:

!next:
        ADD EDI,2
        DEC ECX
        JNZ !loop
!NoChar:
        {test
        mov dl,16
        mov[edi+1],dl}
     END;

     ac := CursorPos.X-OffsetPos.X+1;

     IF pl^.flag AND ciErrorLine <> 0 THEN
     BEGIN
          usefg := (flagErrorLine AND usefore) <> 0;
          usebg := (flagErrorLine AND useback) <> 0;

          FOR i := ac TO ac+Columns-1 DO
          BEGIN
               IF not usefg THEN LineColor[i].Fgc := fgcError;
               IF not usebg THEN LineColor[i].Bgc := bgcError;
          END;
          exit;
     END;

     IF pl^.flag AND ciDebugLine <> 0 THEN
     BEGIN
          usefg := (flagExecPoint AND usefore) <> 0;
          usebg := (flagExecPoint AND useback) <> 0;

          FOR i := ac TO ac+Columns-1 DO
          BEGIN
               IF not usefg THEN LineColor[i].Fgc := fgcExec;
               IF not usebg THEN LineColor[i].Bgc := bgcExec;
          END;
          exit;
     END;

     IF pl^.flag AND ciBreakpointLine <> 0 THEN
     BEGIN
          row := CurrentScreenLine + CursorPos.Y - OffsetPos.Y;
          invalid := InDebugger AND (not DbgLineAvail(ShortName,row));

          IF invalid THEN
          BEGIN
               usefg := (flagInvalidBreak AND usefore) <> 0;
               usebg := (flagInvalidBreak AND useback) <> 0;

               FOR i := ac TO ac+Columns-1 DO
               BEGIN
                    IF not usefg THEN LineColor[i].Fgc := fgcInvBrk;
                    IF not usebg THEN LineColor[i].Bgc := bgcInvBrk;
               END;
          END
          ELSE
          BEGIN
               usefg := (flagValidBreak AND usefore) <> 0;
               usebg := (flagValidBreak AND useback) <> 0;

               FOR i := ac TO ac+Columns-1 DO
               BEGIN
                    IF not usefg THEN LineColor[i].Fgc := fgcBreak;
                    IF not usebg THEN LineColor[i].Bgc := bgcBreak;
               END;
          END;
          exit;
     END;
END;


PROCEDURE TBaseEditor.SetColorEntry(ColorIndex:INTEGER;NewColor:TColor);
BEGIN
     NewColor := SysColorToRGB(NewColor);
     {$IFDEF Win32}
     IF NewColor = $00CCCCCC THEN NewColor := clLtGray;
     {$ENDIF}

     CASE ColorIndex OF
        bgcRight:  FRightBackColor := NewColor;
        fgcHIL:    FHilightColor := NewColor;
        bgcHIL:    FHilightBackColor := NewColor;
        fgcSTR:    FStringColor := NewColor;
        bgcSTR:    FStringBackColor := NewColor;
        fgcASM:    FAsmColor := NewColor;
        bgcASM:    FAsmBackColor := NewColor;
        fgcNumber: FNumberColor := NewColor;
        bgcNumber: FNumberBackColor := NewColor;
        fgcSymbol: FSymbolColor := NewColor;
        bgcSymbol: FSymbolBackColor := NewColor;
        fgcREM1:   FRem1Color := NewColor;
        bgcREM1:   FRem1BackColor := NewColor;
        fgcREM2:   FRem2Color := NewColor;
        bgcREM2:   FRem2BackColor := NewColor;
        fgcREM3:   FRem3Color := NewColor;
        bgcREM3:   FRem3BackColor := NewColor;
        fgcREM4:   FRem4Color := NewColor;
        bgcREM4:   FRem4BackColor := NewColor;
        fgcREM5:   FRem5Color := NewColor;
        bgcREM5:   FRem5BackColor := NewColor;
        fgcBreak:  FBreakColor := NewColor;
        bgcBreak:  FBreakBackColor := NewColor;
        fgcInvBrk: FInvBrkColor := NewColor;
        bgcInvBrk: FInvBrkBackColor := NewColor;
        fgcExec:   FExecColor := NewColor;
        bgcExec:   FExecBackColor := NewColor;
        fgcError:  FErrorColor := NewColor;
        bgcError:  FErrorBackColor := NewColor;
        ELSE Inherited SetColorEntry(ColorIndex,NewColor);
     END;
     IF ColorIndex >= fgcHIL THEN Invalidate;
END;


FUNCTION TBaseEditor.GetColorEntry(ColorIndex:INTEGER):TColor;
BEGIN
     CASE ColorIndex OF
        fgcPlainText:
        BEGIN
             IF flagPlainText AND usefore <> 0 THEN Result := clWindowText
             ELSE Result := Inherited GetColorEntry(ColorIndex);
        END;
        bgcPlainText:
        BEGIN
             IF flagPlainText AND useback <> 0 THEN Result := clWindow
             ELSE Result := Inherited GetColorEntry(ColorIndex);
        END;
        fgcMarkedBlock:
        BEGIN
             IF flagMarkedBlock AND usefore <> 0 THEN Result := clHighLightText
             ELSE Result := Inherited GetColorEntry(ColorIndex);
        END;
        bgcMarkedBlock:
        BEGIN
             IF flagMarkedBlock AND useback <> 0 THEN Result := clHighLight
             ELSE Result := Inherited GetColorEntry(ColorIndex);
        END;
        bgcRight:  Result := FRightBackColor;
        fgcHIL:    Result := FHilightColor;
        bgcHIL:    Result := FHilightBackColor;
        fgcSTR:    Result := FStringColor;
        bgcSTR:    Result := FStringBackColor;
        fgcASM:    Result := FAsmColor;
        bgcASM:    Result := FAsmBackColor;
        fgcNumber: Result := FNumberColor;
        bgcNumber: Result := FNumberBackColor;
        fgcSymbol: Result := FSymbolColor;
        bgcSymbol: Result := FSymbolBackColor;
        fgcREM1:   Result := FRem1Color;
        bgcREM1:   Result := FRem1BackColor;
        fgcREM2:   Result := FRem2Color;
        bgcREM2:   Result := FRem2BackColor;
        fgcREM3:   Result := FRem3Color;
        bgcREM3:   Result := FRem3BackColor;
        fgcREM4:   Result := FRem4Color;
        bgcREM4:   Result := FRem4BackColor;
        fgcREM5:   Result := FRem5Color;
        bgcREM5:   Result := FRem5BackColor;
        fgcBreak:  Result := FBreakColor;
        bgcBreak:  Result := FBreakBackColor;
        fgcInvBrk: Result := FInvBrkColor;
        bgcInvBrk: Result := FInvBrkBackColor;
        fgcExec:   Result := FExecColor;
        bgcExec:   Result := FExecBackColor;
        fgcError:  Result := FErrorColor;
        bgcError:  Result := FErrorBackColor;
        ELSE Result := Inherited GetColorEntry(ColorIndex);
     END;
END;


PROCEDURE TBaseEditor.InvalidateScreenLine(ScrY:INTEGER);
VAR  i:LONGINT;
     pl:PLine;
BEGIN
     CurrentScreenLine := ScrY;
     Inherited InvalidateScreenLine(ScrY);

     IF IconBar = NIL THEN exit;

     pl := TopScreenLine;
     FOR i := 2 TO ScrY DO
        IF pl <> NIL THEN pl := pl^.next;

     IconBar.UpdateIcon(ScrY,pl);
END;


FUNCTION TBaseEditor.CursorFromMouse(pt:TPoint):TEditorPos;
BEGIN
     Result := GetCursorFromMouse(pt);
END;


PROCEDURE TBaseEditor.DoEndDrag(Target:TObject; X,Y:LONGINT);
BEGIN
     IF Target IS TStringGrid THEN Target := SELF; {prevent "move"}

     Inherited DoEndDrag(Target,X,Y);
END;


PROCEDURE TBaseEditor.SetFileName(CONST FName:STRING);
VAR  d,n,e:STRING;
BEGIN
     Inherited SetFileName(FName);

     FSplit(FName,d,n,e);
     FShortName := Upcased(n+e);
END;


/////////////////////////////////////////////////////////////////////////////
//       BreakPoint Handling
/////////////////////////////////////////////////////////////////////////////

CONST
    BreakPointMask:LONGWORD = $0FFFF;

PROCEDURE SetBreakPointIndex(pl:PLine;idx:LONGINT);
BEGIN
     IF pl = NIL THEN exit;  {?}
     IF idx < 0 THEN exit;   {?}
     pl^.add := pl^.add AND (not BreakPointMask);
     pl^.add := pl^.add OR idx;
END;


FUNCTION GetBreakPointIndex(pl:PLine):LONGINT;
BEGIN
     IF pl = NIL THEN exit;
     Result := pl^.add AND BreakPointMask;
END;


{bertragen der BPs aus der Liste in den Editor}
PROCEDURE TBaseEditor.ReadBreakPoints;
VAR  i,y:LONGINT;
     pl:PLine;
     fname:STRING;
BEGIN
     fname := Upcased(FileName);

     FOR i := 0 TO BreakPointList.Count-1 DO
     BEGIN
          IF Upcased(BreakPointList.FileNames[i]) = fname THEN
          BEGIN
               IF BreakPointList.States[i] = bpsCleared THEN continue;

               y := BreakPointList.Lines[i];
               pl := PLines[y];
               IF pl = NIL THEN exit;  {BreakPoint ist eine Watch Adresse?}
               pl^.flag := pl^.flag OR ciBreakpointLine;
               SetBreakPointIndex(pl,i);     {Merke den Index in der Liste}
          END;
     END;

     UpdateBreakpointListProc;
END;


{Liste updaten mit den aktuellen BPs im Editor, auch beim Anzeigen des Dialogs}
PROCEDURE TBaseEditor.WriteBreakPoints;
VAR  pl:PLine;
     i,idx:LONGINT;
     fname:STRING;
BEGIN
     fname := Upcased(FileName);
     pl := FirstLine;
     FOR i := 1 TO CountLines DO
     BEGIN
          IF pl^.flag AND ciBreakPointLine <> 0 THEN
          BEGIN
               idx := GetBreakPointIndex(pl);                   {aus ^.add}
               BreakPointList.FileNames[idx] := fname;       {wegen SaveAs}
               BreakPointList.Lines[idx] := -i;  {markiere, daแ BP noch da}
          END;
          pl := pl^.next;
     END;

     {Entferne nicht mehr vorhandene BPs aus der Liste}
     FOR idx := 0 TO BreakPointList.Count-1 DO
     BEGIN
          IF BreakPointList.FileNames[idx] = fname THEN
          BEGIN
               IF BreakPointList.Lines[idx] < 0    {die markierten}
               THEN BreakPointList.Lines[idx] := abs(BreakPointList.Lines[idx])
               ELSE BreakPointList.States[idx] := bpsCleared;
          END;
     END;

     UpdateBreakpointListProc;
END;

PROCEDURE TBaseEditor.SetupComponent;
BEGIN
  Inherited SetupComponent;

  RunInAnsi     := false;
  LoadSaveAsAnsi:= false;

  NormalChar[{OEM}false, '_'] := true;
  NormalChar[{ANSI}true, '_'] := true;

  Ctl3D := TRUE;
  ScrollBars := ssVertical;
  IndentRect.Bottom := 3;

  IconBar.Create(SELF);
  IconBar.Editor := SELF;
  InsertControl(IconBar);
END;


PROCEDURE TBaseEditor.SetupShow;
BEGIN
  Inherited SetupShow;
  {Filename ist jetzt gesetzt, wegen Pfad}
  IF AddDAsmEditorNotify <> NIL THEN AddDAsmEditorNotify(SELF);
END;


FUNCTION TBaseEditor.LoadFromFile(CONST FName:STRING):BOOLEAN;
VAR  d,n,e:STRING;
BEGIN
     Result := Inherited LoadFromFile(FName);

     FSplit(FileName,d,n,e);
     FShortName := Upcased(n+e);
     ReadBreakPoints;  {BreakPoints aus Liste laden}
END;


DESTRUCTOR TBaseEditor.Destroy;
BEGIN
     IF DAsmEditorCloseNotify <> NIL THEN DAsmEditorCloseNotify(SELF);

     {BreakPoints in Liste aktualisieren, weil evtl. verndert}
     IF not InDebugger THEN WriteBreakPoints;

     Inherited Destroy;
END;

PROCEDURE TBaseEditor.ToTop;
BEGIN
     BringToFront; //berschrieben in TSibEditor
END;


PROCEDURE TBaseEditor.cmToggleBreakPoint; {F8 expired}
VAR  pl:PLine;
     idx:LONGINT;
BEGIN
     pl := ActLine;
     IF pl^.flag AND ciBreakpointLine = 0 THEN
     BEGIN
          idx := BreakPointList.AddBreakPoint(FileName,CursorPos.Y);
          pl^.flag := pl^.flag OR ciBreakpointLine;
          SetBreakPointIndex(pl,idx);    {Merke den Index in der Liste}
     END
     ELSE
     BEGIN
          BreakPointList.RemoveBreakPoint(FileName,CursorPos.Y);
          pl^.flag := pl^.flag AND (not ciBreakpointLine);
     END;
     InvalidateWorkLine;

     UpdateBreakpointListProc;
END;


PROCEDURE TBaseEditor.ClearAllBreakPoints;
VAR  pl:PLine;
     i:LONGINT;
     needRedraw:BOOLEAN;
BEGIN
     pl := FirstLine;
     needRedraw := FALSE;
     FOR i := 1 TO CountLines DO
     BEGIN
          IF pl^.flag AND ciBreakpointLine <> 0 THEN
          BEGIN
               pl^.flag := pl^.flag AND (not ciBreakpointLine);
               needRedraw := TRUE;
          END;
          pl := pl^.next;
     END;
     IF needRedraw THEN InvalidateEditor(0,0);
END;


PROCEDURE TBaseEditor.SetDebuggerLine(y:LONGINT);
VAR  pt:TEditorPos;
BEGIN
     IF DebuggerLine <> NIL THEN
     BEGIN
          IF DebuggerY = y THEN exit;
          DebuggerLine^.flag := DebuggerLine^.flag AND (not ciDebugLine);
     END;

     DebuggerLine := PLines[y];
     IF DebuggerLine = NIL THEN
     BEGIN
          InvalidateEditor(0,0);
          exit;
     END;
     DebuggerLine^.flag := DebuggerLine^.flag OR ciDebugLine;
     pt.x := 1;
     pt.y := y;
     BeginUpdate;
     GotoPosition(pt);
     InvalidateEditor(0,0);
     EndUpdate;
     DebuggerY := y;
END;


PROCEDURE TBaseEditor.DebugStepInto;
BEGIN
     IF DebuggerLine = NIL THEN exit;
     IF (not InDebugger) OR (DebuggerRunning) THEN exit;
     IF RemarkAllCPUBreaksProc <> NIL THEN RemarkAllCPUBreaksProc;
     LastCommandFromSrc := TRUE;
     IF LastDbgEditor<>NIL THEN LastDbgEditor.SetDebuggerLine(-1); {clear}
     LastDbgEditor:=NIL;
     DebugCommand(DBG_C_STEPINTO);
END;


PROCEDURE TBaseEditor.DebugStepOver;
BEGIN
     IF DebuggerLine = NIL THEN exit;
     IF (not InDebugger) OR (DebuggerRunning) THEN exit;
     IF RemarkAllCPUBreaksProc <> NIL THEN RemarkAllCPUBreaksProc;
     LastCommandFromSrc := TRUE;
     IF LastDbgEditor<>NIL THEN LastDbgEditor.SetDebuggerLine(-1); {clear}
     LastDbgEditor:=NIL;
     DebugCommand(DBG_C_SSTEP);
END;


PROCEDURE TBaseEditor.DebugGotoLine;
VAR  Addr:LONGWORD;
     pt:TEditorPos;
     s:STRING;
     Buf:TDbgBuf;
     catch:BOOLEAN;
BEGIN
     pt := CursorPos;
     IF (not InDebugger) OR (DebuggerRunning) THEN exit;
     s := Upcased(FileName);
     IF GetAdressFromLine(s,pt.y,Addr) THEN
     BEGIN
          catch:=FALSE;
          IF GetRegisterSet(Buf) THEN
           IF Buf.EIP=Addr THEN
          BEGIN
             catch:=TRUE;
             SetNextDbgBrk(Addr,3);
          END;

          IF RemarkAllCPUBreaksProc <> NIL THEN RemarkAllCPUBreaksProc;
          IF not catch THEN EnableBreakpoint(Addr,3);
          LastCommandFromSrc := TRUE;
          IF LastDbgEditor<>NIL THEN LastDbgEditor.SetDebuggerLine(-1); {clear}
          LastDbgEditor:=NIL;
          DebugCommand(DBG_C_GO);
     END
     ELSE ErrorBox('No code generated for this line!');
END;


PROCEDURE TBaseEditor.InvalidateEditor(y1,y2:INTEGER);
BEGIN
  Inherited InvalidateEditor(y1,y2);
END;

Procedure tBaseEditor.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);

begin
  inherited MouseDblClick (Button, Shiftstate, X, Y);
  SelectWord (Cursorpos);
end;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: SIBYL Editor IconBar                                        บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TIconBar.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Color := clLtGray;
     Alignment := tbLeft;
     BevelStyle := tbNone;
     Size := 2 * IconWidth;
END;


PROCEDURE TIconBar.UpdateIcon(ScrY:INTEGER;pl:PLine);
VAR  id:WORD;
     rc:TRect;
     row:LONGINT;
BEGIN
     IF ScrY > 50 THEN exit;

     row := ScrY + Editor.CursorPos.Y - Editor.OffsetPos.Y;
     id := GetBitmapFromLine(pl,row);
     IF IconArray[ScrY] = id THEN exit;
     IconArray[ScrY] := id;

     IF Handle = 0 THEN exit;
     rc := IconRectFromLine(ScrY);
     Canvas.ClipRect := rc;
     Redraw(rc);
END;


FUNCTION TIconBar.GetBitmapFromLine(pl:PLine;row:LONGINT):WORD;
VAR  flag:LONGWORD;
BEGIN
     Result := 0;

     IF pl = NIL THEN exit;

     IF pl^.flag AND ciErrorLine <> 0 THEN
     BEGIN
          Result := 1414;
          exit;
     END;

     IF pl^.flag AND ciDebugLine <> 0 THEN
     BEGIN
          IF pl^.flag AND ciBreakpointLine <> 0 THEN Result := 1416
          ELSE Result := 1411;
          exit;
     END;

     IF pl^.flag AND ciBreakpointLine <> 0 THEN
     BEGIN
          Result := 1412;
          IF InDebugger AND (not DbgLineAvail(Editor.ShortName,row))
          THEN Result := 1413;   {Invalid Breakpoint}
          exit;
     END;

     flag := pl^.flag AND ciBookMarkMask;
     IF flag <> 0 THEN
     BEGIN
          Result := 1400 + flag;
          exit;
     END;

     IF @TestProjectBookMarkProc <> NIL THEN
       IF TestProjectBookMarkProc(Editor,row) THEN
       BEGIN
            Result := 1400;
            exit;
       END;

     IF InDebugger THEN
       IF DbgLineAvail(Editor.ShortName,row) THEN
       BEGIN
            Result := 1415;
            exit;
       END;
END;


PROCEDURE TIconBar.Redraw(CONST rec:TRect);
VAR  i:INTEGER;
     rc:TRect;
BEGIN
     FOR i := 1 TO Editor.Rows DO
     BEGIN
          {if the line is part of rec then draw the bitmap and exclude the rect}
          rc := IconRectFromLine(i);
          IF IconArray[i] = 0 THEN continue;
          IF IsRectEmpty(IntersectRect(rec,rc)) THEN continue;

          Canvas.Draw(rc.Left,rc.Bottom, EditorIconList[IconArray[i]]);
          Canvas.ExcludeClipRect(rc);
     END;

     Inherited Redraw(rec);
END;


FUNCTION TIconBar.IconRectFromLine(ScrY:INTEGER):TRect;
VAR  y:LONGINT;
BEGIN
     y := Editor.ClientRect.Top+1 - (ScrY*Editor.Canvas.FontHeight) -
          3{Editor.IndentRect.Top} - 2{Editor.FBorderWidth};
     y := y + (Editor.Canvas.FontHeight - IconHeight) DIV 2; {zentriert}

     Result.Left := IconWidth DIV 2;
     Result.Right := Result.Left + IconWidth-1;
     Result.Bottom := y;
     Result.Top := Result.Bottom + IconHeight-1;
END;


PROCEDURE TIconBar.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR  p:TEditorPos;
     row:LONGINT;
     pl:PLine;
     idx:LONGINT;
BEGIN
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     p := Editor.CursorFromMouse(Forms.Point(X,Y));
     row := p.Y + Editor.CursorPos.Y - Editor.OffsetPos.Y;
     IF row < 1 THEN row := 1;
     IF row > Editor.CountLines THEN exit;

     {Toggle BreakPoint}
     pl := Editor.PLines[row];
     IF pl = NIL THEN exit;
     IF pl^.flag AND ciBreakpointLine = 0 THEN
     BEGIN
          idx := BreakPointList.AddBreakPoint(Editor.FileName,row);
          pl^.flag := pl^.flag OR ciBreakpointLine;
          SetBreakPointIndex(pl,idx);    {Merke den Index in der Liste}
     END
     ELSE
     BEGIN
          BreakPointList.RemoveBreakPoint(Editor.FileName,row);
          pl^.flag := pl^.flag AND (not ciBreakpointLine);
     END;
     Editor.InvalidateScreenLine(p.Y);

     UpdateBreakpointListProc;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: BreakPointList                                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TBreakPointList.FreeItem(Item:PBreakPoint);
BEGIN
     IF Item <> NIL THEN
     BEGIN
          AssignStr(Item^.FileName,'');
          AssignStr(Item^.Condition,'');
          Dispose(Item);
     END;
END;


FUNCTION TBreakPointList.GetFName(idx:LONGINT):STRING;
VAR  d,n,e:STRING;
BEGIN
     FSplit(GetFileName(idx),d,n,e);
     Result := n + e;
END;


FUNCTION TBreakPointList.GetFileName(idx:LONGINT):STRING;
VAR  Item:PBreakPoint;
BEGIN
     Result := '';
     Item := Items[idx];
     IF Item <> NIL THEN
       IF Item^.FileName <> NIL THEN Result := Item^.FileName^;
END;


PROCEDURE TBreakPointList.SetFileName(idx:LONGINT;Value:STRING);
VAR  Item:PBreakPoint;
BEGIN
     Item := Items[idx];
     IF Item <> NIL THEN AssignStr(Item^.FileName,Value);
END;


FUNCTION TBreakPointList.GetLine(idx:LONGINT):LONGINT;
VAR  Item:PBreakPoint;
BEGIN
     Result := 0;
     Item := Items[idx];
     IF Item <> NIL THEN Result := Item^.Line;
END;


PROCEDURE TBreakPointList.SetLine(idx:LONGINT;Value:LONGINT);
VAR  Item:PBreakPoint;
BEGIN
     Item := Items[idx];
     IF Item <> NIL THEN Item^.Line := Value;
END;


FUNCTION TBreakPointList.GetAddress(idx:LONGINT):LongWord;
VAR  Item:PBreakPoint;
BEGIN
     Result := 0;
     Item := Items[idx];
     IF Item <> NIL THEN Result := Item^.Address;
END;


PROCEDURE TBreakPointList.SetAddress(idx:LONGINT;Value:LongWord);
VAR  Item:PBreakPoint;
BEGIN
     Item := Items[idx];
     IF Item <> NIL THEN Item^.Address := Value;
END;


FUNCTION TBreakPointList.GetState(idx:LONGINT):TBreakPointStatus;
VAR  Item:PBreakPoint;
BEGIN
     Result := bpsCleared;
     Item := Items[idx];
     IF Item <> NIL THEN Result := Item^.Status;
END;


PROCEDURE TBreakPointList.SetState(idx:LONGINT;Value:TBreakPointStatus);
VAR  Item:PBreakPoint;
BEGIN
     Item := Items[idx];
     IF Item <> NIL THEN Item^.Status := Value;
     IF Value = bpsCleared THEN
     BEGIN
          FreeItem(Item);
          Items[idx] := NIL;
     END;
END;


{ermittelt die Anzahl gltiger Breakpoints}
FUNCTION TBreakPointList.GetBreakCount:LONGINT;
VAR  i:LONGINT;
BEGIN
     Result := 0;
     FOR i := 0 TO Count-1 DO
     BEGIN
          IF States[i] <> bpsCleared THEN inc(Result);
     END;
END;


{fgt einen neuen BreakPoint zur Liste hinzu}
FUNCTION TBreakPointList.AddBreakPoint(FileName:STRING;Line:LONGINT):LONGINT;
VAR  Item:PBreakPoint;
BEGIN
     New(Item);
     Result := Add(Item);

     FileNames[Result] := Upcased(FileName);
     Lines[Result] := Line;
     Address[Result] := 0;
     States[Result] := bpsActive;

     {Debugger luft -> Breakpoint auch im Debugger setzen}
     IF InDebugger THEN
     BEGIN
          SetDebuggerBreakPoint(Result);
     END;
END;


PROCEDURE TBreakPointList.RemoveBreakPoint(FileName:STRING;Line:LONGINT);
VAR  i:LONGINT;
BEGIN
     UpcaseStr(FileName);
     FOR i := 0 TO Count-1 DO
     BEGIN
          IF Lines[i] = Line THEN
          BEGIN
               IF FileNames[i] = FileName THEN
               BEGIN
                    DeleteBreakPoint(i);
                    break;
               END;
          END;
     END;
END;


FUNCTION TBreakPointList.RemoveBreakPointShort(FileName:STRING;Line:LONGINT):STRING;
VAR  i:LONGINT;
BEGIN
     Result := FileName;

     UpcaseStr(FileName);    // Short FileName
     FOR i := 0 TO Count-1 DO
     BEGIN
          IF Lines[i] = Line THEN
          BEGIN
               IF FNames[i] = FileName THEN
               BEGIN
                    Result := FileNames[i]; // voller Name zurck

                    DeleteBreakPoint(i);
                    break;
               END;
          END;
     END;
END;


PROCEDURE TBreakPointList.DeleteBreakPoint(idx:LONGINT);
BEGIN
     IF InDebugger THEN ResetDebuggerBreakPoint(idx);
     States[idx] := bpsCleared;
END;


PROCEDURE TBreakPointList.ClearBreakPoints;
VAR  i:LONGINT;
BEGIN
     FOR i := 0 TO Count-1 DO
     BEGIN
          DeleteBreakPoint(i);
     END;
     Clear;

     UpdateBreakpointListProc;
END;


{Setzt einen BreakPoint physisch im Debugger}
PROCEDURE TBreakPointList.SetDebuggerBreakPoint(idx:LONGINT);
VAR  Adr:LongWord;
BEGIN
     IF States[idx] <> bpsActive THEN exit;

     {evtl. unterscheiden zwischen BreakPoint in einer Zeile und
      berwachen einer Adresse}
     IF SetBreakPointLine(FileNames[idx],Lines[idx], 0, Adr) THEN
     BEGIN
          {Adr merken}
          Address[idx] := Adr;
     END
     ELSE
     BEGIN
          {invalid breakpoint -> l”schen}
          States[idx] := bpsCleared;
     END;
END;


{L”scht einen BreakPoint physisch im Debugger}
PROCEDURE TBreakPointList.ResetDebuggerBreakPoint(idx:LONGINT);
VAR  b:BYTE;
     LastDbgBreakAddr:LONGWORD;
     LastDbgBreakTyp:BYTE;
BEGIN
     IF States[idx] <> bpsActive THEN exit;

     {evtl. unterscheiden zwischen BreakPoint in einer Zeile und
      berwachen einer Adresse}

     IF UnsetBreakPoint(Address[idx],b) THEN
     BEGIN
     END;

     GetNextDbgBrkInfo(LastDbgBreakAddr,LastDbgBreakTyp);
     IF LastDbgBreakAddr=Address[idx] THEN SetNextDbgBrk(0,0);

     States[idx] := bpsCleared;
END;


{L”scht die BreakPoint Liste und cleared die OpenEditors}
PROCEDURE ClearAllBreakPoints;
VAR  Edit:TBaseEditor;
     i:INTEGER;
BEGIN
     IF DAsmInsideIDE THEN          {nur fr IDE}
     BEGIN
          FOR i := 0 TO CodeEditorRef.MDIChildCount-1 DO
          BEGIN
               Edit := TBaseEditor(CodeEditorRef.MDIChildren[i]);
               IF Edit IS TBaseEditor THEN Edit.ClearAllBreakPoints;
          END;
     END
     ELSE
     BEGIN
          FOR i := 0 TO Screen.FormCount-1 DO
          BEGIN
               Edit := TBaseEditor(Screen.Forms[i]);
               IF Edit IS TBaseEditor THEN Edit.ClearAllBreakPoints;
          END;
     END;
     {l”sche Breakpoints auch im Debugger}
     BreakPointList.ClearBreakPoints;
END;


{Updated die Liste mit den OpenEditors und setzt die BreakPoints im Debugger}
PROCEDURE InitBreakPoints; {beim START des Debuggers}
VAR  Edit:TBaseEditor;
     i:LONGINT;
BEGIN                  
     {Update der Liste, mit den OpenEditors}
     IF DAsmInsideIDE THEN     {nur fr IDE}
     BEGIN
          FOR i := 0 TO CodeEditorRef.MDIChildCount-1 DO
          BEGIN
               Edit := TBaseEditor(CodeEditorRef.MDIChildren[i]);
               IF Edit IS TBaseEditor THEN Edit.WriteBreakPoints;
          END;
     END
     ELSE
     BEGIN
          FOR i := 0 TO Screen.FormCount-1 DO
          BEGIN
               Edit := TBaseEditor(Screen.Forms[i]);
               IF Edit IS TBaseEditor THEN Edit.WriteBreakPoints;
          END;
     END;               

     {BreakPoints fr den Debugger setzen}
     FOR i := 0 TO BreakPointList.Count-1 DO
     BEGIN
          BreakPointList.SetDebuggerBreakPoint(i);
     END;
END;             
                       

VAR  i:WORD;

BEGIN
// Bitmaps von den Resourcen einlesen
  FOR i := 1400 TO 1416 DO
    BEGIN
      EditorIconList[i].Create;
      EditorIconList[i].LoadFromResourceId(i);
    END;

// Diverse Tabellen fuellen
  FOR i := 0 TO 255 DO UpcaseTable[i] := Upcase(chr(i));
  FOR i := 0 TO 255 DO SymbolTable[i] := #0; {clear all}
  FOR i := 33 TO 47 DO SymbolTable[i] := #1;
  FOR i := 58 TO 63 DO SymbolTable[i] := #1;
  FOR i := 91 TO 96 DO SymbolTable[i] := #1;
  FOR i := 123 TO 127 DO SymbolTable[i] := #1;
  BreakPointList.Create;
END.


{ -- date -- -- from -- -- changes ----------------------------------------------
  18-Okt-04  MV/WD      Bei DoubleClick wird nun das Wort makiert.
  13-Jan-05  MV/WD      Die Funktion "CheckWordsOnly" von Editors.pas eingebaut
  26-Sep-05  MV/WD      Die Funktion "CalcLineColor" mit dem Parameter "LineAtt" erweitert
}
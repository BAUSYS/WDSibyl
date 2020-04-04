
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Visual Development Environment                                 บ
 บ                                                                          บ
 บ     Copyright (C) 1995,99 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ Sibyl Integrated Development Environment (IDE)                           บ
 บ Object-oriented development system.                                      บ
 บ                                                                          บ
 บ Copyright (C) 1995,99 SpeedSoft GbR, Germany                             บ
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

UNIT ParseObj;

INTERFACE

USES SysUtils,Color,Classes,Forms,Dialogs,Editors,Sib_Prj,
     uString, uList;


PROCEDURE InitSourceBuffer(Buf:Pointer;Len,Line,Column:LONGINT);
FUNCTION  ParseOBJECT:BOOLEAN;
FUNCTION  GetNewComponentLine(Component:TComponent):LONGINT;
FUNCTION  GetNewMethodLine:LONGINT;
FUNCTION  GetMethodPosition(methodname:STRING;VAR prc,mth:TEditorPos):BOOLEAN;
FUNCTION  MethodNameExist(methodname:STRING;VAR prc,mth:TEditorPos):BOOLEAN;
FUNCTION  ComponentExist(compname:STRING;VAR cmp,cmpt:TEditorPos):BOOLEAN;
FUNCTION  GetComponentPosition(compname,comptype:STRING;VAR cmp,cmpt:TEditorPos):BOOLEAN;
FUNCTION  GetClassEndPosition(VAR ep:TEditorPos):BOOLEAN;
PROCEDURE DestroySymbolTable;
PROCEDURE ExtractMethodName(VAR methodname:STRING);


TYPE
    PSymbolTable=^TSymbolTable;
    TSymbolTable=RECORD
                       name:STRING[64];
                       typ :STRING[64];
                       IsClassVar:BOOLEAN;
                       npos:TEditorPos;
                       tpos:TEditorPos;
                 END;

    EParserError=CLASS(Exception);

VAR
   SymbolTable:TList;
   LastParserError:STRING;


IMPLEMENTATION


CONST
     CR    =#13;
     TAB   =#8;
     LF    =#10;
     HK    =#39;
     Blank =#32;

{Error Messages}
     ERR_ILLEGAL_ARRAY_SEL   =1;
     ERR_ILLEGAL_PROC_TYPE   =2;
     ERR_ILLEGAL_REC_COMP    =3;
     ERR_OUT_OF_MEMORY       =4;
     ERR_IDENTIFIER_EXP      =5;
     ERR_ILLEGAL_ARRAY_IND   =6;
     ERR_NUMBER_EXPECTED     =7;
     ERR_ILLEGAL_TYPE        =8;
     ERR_CONSTANT_EXP        =9;
     ERR_ILLEGAL_FACTOR      =10;
     ERR_ILLEGAL_QUALIFIER   =11;
     ERR_ILLEGAL_WITH_VAR    =12;
     ERR_ILLEGAL_TOKEN       =13;
     ERR_ILLEGAL_STATEMENT   =14;
     ERR_PROGRAM_EXPECTED    =15;
     ERR_POINT_EXPECTED      =16;
     ERR_SOURCE_NOT_FOUND    =17;
     ERR_SOURCE_READ         =18;
     ERR_UNDEFINED_IDENT     =19;
     ERR_DUPLICATE_IDENT     =20;
     ERR_ILLEGAL_CHARACTER   =21;
     ERR_SYNTAX              =22;
     ERR_DIV_BY_ZERO         =23;
     ERR_NO_MORE_REGS        =24;
     ERR_TOO_MUCH_PARAMS     =25;
     ERR_TOO_FEW_PARAMS      =26;
     ERR_ILL_WRITE_TYPE      =27;
     ERR_ILL_READ_TYPE       =28;
     ERR_ILLEGAL_NUMBER      =29;
     ERR_IMPL_EXPECTED       =30;
     ERR_BEGIN_EXPECTED      =31;
     ERR_INTERFACE_EXP       =32;
     ERR_TYPE_CONFLICT       =33;
     ERR_BRACK_EXP           =34;
     ERR_ILLEGAL_STR_DIM     =35;
     ERR_REC_TYPE_EXP        =36;
     ERR_TOO_MANY_WITH       =37;
     ERR_ILL_ARRAY_REF       =38;
     ERR_ILL_ARRAY_DIM       =39;
     ERR_HEADER_NOT_MATCH    =40;
     ERR_FEW_PARAMS          =41;
     ERR_MUCH_PARAMS         =42;
     ERR_VARREF_EXPECTED     =43;
     ERR_ILL_PARASIZE        =44;
     ERR_DLL_API_EXP         =45;
     ERR_DLLNAME_EXP         =46;
     ERR_INDEX_NAME_EXP      =47;
     ERR_NUMCONST_EXP        =48;
     ERR_STRCONST_EXP        =49;
     ERR_ILL_DLLNAME         =50;
     ERR_UNIT_GEN            =51;
     ERR_FILE_WRITE          =52;
     ERR_UNIT_MISMATCH       =53;
     ERR_IN_ASM              =54;
     ERR_TYPENAME_EXP        =55;
     ERR_FORWARDS_LEFT       =56;
     ERR_ILL_UNIT_NAME       =57;
     ERR_UNIT_NOT_FOUND      =58;
     ERR_FILE_READ           =59;
     ERR_FILE_NOT_FOUND      =60;
     ERR_END_EXPECTED        =61;
     ERR_LABEL_NOT_DEF       =62;
     ERR_LABEL_EXP           =63;
     ERR_DUP_DYN_INDEX       =64;
     ERR_ILL_VIR_CONST       =65;
     ERR_ILL_VIR_DEST        =66;
     ERR_ILLEGAL_FORWARD     =67;
     ERR_METHOD_UNDEF        =68;
     ERR_ILL_OBJ_CALL        =69;
     ERR_CONST_EXP           =70;
     ERR_DEST_EXP            =71;
     ERR_READ_WRITE_EXP      =72;
     ERR_DUP_READ            =73;
     ERR_DUP_WRITE           =74;
     ERR_FIELD_IDENT_EXP     =75;
     ERR_ILL_FUNC_RES        =76;
     ERR_PROP_READONLY       =77;
     ERR_PROP_WRITEONLY      =78;
     ERR_ILL_INHERITED       =79;
     ERR_CLASS_OBJECT_MIX    =80;
     ERR_FUNC_PROC_EXP       =81;
     ERR_VAR_INACCESSABLE    =82;
     ERR_METH_INACCESSABLE   =83;
     ERR_ILL_CONST_ASSIGN    =84;
     ERR_ILL_FORWARD         =85;
     ERR_INV_MSG_HANDLER     =86;
     ERR_INV_MSG_PARAMS      =87;
     ERR_ILL_FAIL            =88;
     ERR_RANGE_CHECK         =89;
     ERR_CANNOT_WRITE        =90;
     ERR_UNIT_VERS_MIS       =91;
     ERR_ILL_DIRECTIVE       =92;
     ERR_MISSING_ENDIF       =93;
     ERR_ILL_SET             =94;
     ERR_ILL_ADDR_REF        =95;
     ERR_INV_FILE_TYPE       =96;
     ERR_CANNOT_READ         =97;
     ERR_ILL_BREAK           =98;
     ERR_ILL_CONTINUE        =99;
     ERR_ILL_TYPECAST        =100;
     ERR_DUP_INDEX           =101;
     ERR_ILL_EXPORT          =102;
     ERR_EXPORT_UNDEF        =103;
     ERR_ILL_FUNCREF         =104;
     ERR_CONST_OUT_OF_RANGE  =105;
     ERR_STRING_EXCEEDS_LINE =106;
     ERR_OBJTYPE_EXP         =107;
     ERR_METHOD_NOT_INPARENT =108;
     ERR_DUP_DEFAULT         =109;
     ERR_ILL_DEFAULT         =110;
     ERR_INDEXED_PUB         =111;
     ERR_INDEX95             =112;
     ERR_ILL_OVERRIDE        =113;
     ERR_DUP_VAR_IMPORT      =114;
     ERR_BOOL_EXP            =115;
     ERR_DUP_NAME            =116;
     ERR_NAME_MISMATCH       =117;
     ERR_ILL_PROP_ASSIGN     =118;
     ERR_ILL_ABSTRACT        =119;
     ERR_INTERNAL            =255;


TYPE
    T_Variablen=(
                 Variable,
                 VAR_Parameter,
                 VAL_Parameter,
                 CONST_Parameter,
                 Komponente
                );


    T_Symbol=(
              S_ABSOLUTE,
              S_AND,
              S_AS,
              S_ARRAY,
              S_ASM,
              S_ASSEMBLER,
              S_BEGIN,
              S_CASE,
              S_CONST,
              S_CONSTRUCTOR,
              S_CSTRING,
              S_DESTRUCTOR,
              S_DIV,
              S_DO,
              S_DOWNTO,
              S_ELSE,
              S_END,
              S_EXCEPT,
              S_EXPORTS,
              S_FILE,
              S_FINALLY,
              S_FOR,
              S_FUNCTION,
              S_GOTO,
              S_IF,
              S_IMPORTS,
              S_IN,
              S_INHERITED,
              S_INTERFACE,
              S_IMPLEMENTATION,
              S_IS,
              S_LABEL,
              S_LIBRARY,
              S_MOD,
              S_NIL,
              S_NOT,
              S_OBJECT,
              S_ON,
              S_CLASS,
              S_OF,
              S_OR,
              S_PACKED,
              S_PROCEDURE,
              S_PROGRAM,
              S_RAISE,
              S_RECORD,
              S_REPEAT,
              S_SET,
              S_SHL,
              S_SHR,
              S_STRING,
              S_THEN,
              S_TO,
              S_TRY,
              S_TYPE,
              S_UNIT,
              S_UNTIL,
              S_USES,
              S_VAR,
              S_WHILE,
              S_WITH,
              S_XOR,
              S_L,
              S_LE,
              S_G,
              S_GE,
              S_NE,
              S_Assign,
              S_Point,
              S_Period,
              S_Plus,
              S_Minus,
              S_Times,
              S_Divide,
              S_LBRAC,
              S_RBRAC,
              S_Arrow,
              S_LB,
              S_RB,
              S_Comma,
              S_Colon,
              S_Semicolon,
              S_E,
              S_AddrOp,
              S_Pointer,
              S_Name,
              S_Name_FORWARD,
              S_STRING_Text,
              S_Konstante,
              S_Prozedur,
              S_Variable,
              S_Property,
              S_Funktion,
              S_StdProc,
              S_StdFunc,
              S_TypBez,
              S_Zahl,
              S_Hex,
              S_FloatZahl,
              S_ObjFunktion,
              S_ObjProzedur,
              S_Destruktor,
              S_Konstruktor,
              S_ClassFunktion,
              S_ClassProzedur,
              S_UnitBez,
              S_LabelBez,
              S_PreChar,
              S_ExcptVar,
              S_Nichts
             );


    T_StdNamen=(
                N_FALSE,
                N_TRUE,
                N_WRITELN,
                N_WRITE,
                N_READLN,
                N_READ,
                N_NEW,
                N_ORD,
                N_CHR,
                N_ADDR,
                N_SUCC,
                N_PRED,
                N_EXIT,
                N_BREAK,
                N_CONTINUE,
                N_INC,
                N_DEC,
                N_LENGTH,
                N_SIZEOF,
                N_DISPOSE,
                N_ADDROP,
                N_LO,
                N_HI,
                N_LOW,
                N_HIGH,
                N_ABS,
                N_CONCAT,
                N_SIN,
                N_COS,
                N_TAN,
                N_COT,
                N_ARCSIN,
                N_ARCCOS,
                N_ARCTAN,
                N_ARCCOT,
                N_SINH,
                N_COSH,
                N_TANH,
                N_COTH,
                N_FRAC,
                N_ROUND,
                N_INT,
                N_TRUNC,
                N_SQR,
                N_SQRT,
                N_EXP,
                N_LN,
                N_LG,
                N_LB,
                N_VAL,
                N_STR,
                N_ODD,
                N_OFS,
                N_TYPEOF,
                N_FAIL,
                N_INDEXOF,
                N_TOSTR,
                N_UPCASE,
                N_N
               );


    T_Zeichenart=(
                  Buchstabe,
                  Ziffer,
                  Doppelzeichen,
                  Einzelzeichen,
                  Hochkomma,
                  Nix
                 );


    T_SymbolText=RECORD
                       Symbol:T_Symbol;
                       Text:STRING[15];
                 END;


    TSourceArray=ARRAY [1..1] OF CHAR;


CONST
     MaxSymbols=110;

     SymbolText:ARRAY [1..MaxSymbols] OF T_SymbolText =
     ((Symbol:S_ABSOLUTE;        Text:'ABSOLUTE'),
      (Symbol:S_AND;             Text:'AND'),
      (Symbol:S_AS;              Text:'AS'),
      (Symbol:S_ARRAY;           Text:'ARRAY'),
      (Symbol:S_ASM;             Text:'ASM'),
      (Symbol:S_ASSEMBLER;       Text:'ASSEMBLER'),
      (Symbol:S_BEGIN;           Text:'BEGIN'),
      (Symbol:S_CASE;            Text:'CASE'),
      (Symbol:S_CONST;           Text:'CONST'),
      (Symbol:S_CONSTRUCTOR;     Text:'CONSTRUCTOR'),
      (Symbol:S_CSTRING;         Text:'CSTRING'),
      (Symbol:S_DESTRUCTOR;      Text:'DESTRUCTOR'),
      (Symbol:S_DIV;             Text:'DIV'),
      (Symbol:S_DO;              Text:'DO'),
      (Symbol:S_DOWNTO;          Text:'DOWNTO'),
      (Symbol:S_ELSE;            Text:'ELSE'),
      (Symbol:S_END;             Text:'END'),
      (Symbol:S_EXCEPT;          Text:'EXCEPT'),
      (Symbol:S_EXPORTS;         Text:'EXPORTS'),
      (Symbol:S_FILE;            Text:'FILE'),
      (Symbol:S_FINALLY;         Text:'FINALLY'),
      (Symbol:S_FOR;             Text:'FOR'),
      (Symbol:S_FUNCTION;        Text:'FUNCTION'),
      (Symbol:S_GOTO;            Text:'GOTO'),
      (Symbol:S_IF;              Text:'IF'),
      (Symbol:S_IMPORTS;         Text:'IMPORTS'),
      (Symbol:S_IN;              Text:'IN'),
      (Symbol:S_INHERITED;       Text:'INHERITED'),
      (Symbol:S_INTERFACE;       Text:'INTERFACE'),
      (Symbol:S_IMPLEMENTATION;  Text:'IMPLEMENTATION'),
      (Symbol:S_IS;              Text:'IS'),
      (Symbol:S_LABEL;           Text:'LABEL'),
      (Symbol:S_LIBRARY;         Text:'LIBRARY'),
      (Symbol:S_MOD;             Text:'MOD'),
      (Symbol:S_NIL;             Text:'NIL'),
      (Symbol:S_NOT;             Text:'NOT'),
      (Symbol:S_OBJECT;          Text:'OBJECT'),
      (Symbol:S_ON;              Text:'ON'),
      (Symbol:S_CLASS;           Text:'CLASS'),
      (Symbol:S_OF;              Text:'OF'),
      (Symbol:S_OR;              Text:'OR'),
      (Symbol:S_PACKED;          Text:'PACKED'),
      (Symbol:S_PROCEDURE;       Text:'PROCEDURE'),
      (Symbol:S_PROGRAM;         Text:'PROGRAM'),
      (Symbol:S_RAISE;           Text:'RAISE'),
      (Symbol:S_RECORD;          Text:'RECORD'),
      (Symbol:S_REPEAT;          Text:'REPEAT'),
      (Symbol:S_SET;             Text:'SET'),
      (Symbol:S_SHL;             Text:'SHL'),
      (Symbol:S_SHR;             Text:'SHR'),
      (Symbol:S_STRING;          Text:'STRING'),
      (Symbol:S_THEN;            Text:'THEN'),
      (Symbol:S_TO;              Text:'TO'),
      (Symbol:S_TRY;             Text:'TRY'),
      (Symbol:S_TYPE;            Text:'TYPE'),
      (Symbol:S_UNIT;            Text:'UNIT'),
      (Symbol:S_UNTIL;           Text:'UNTIL'),
      (Symbol:S_USES;            Text:'USES'),
      (Symbol:S_VAR;             Text:'VAR'),
      (Symbol:S_WHILE;           Text:'WHILE'),
      (Symbol:S_WITH;            Text:'WITH'),
      (Symbol:S_XOR;             Text:'XOR'),
      (Symbol:S_L;               Text:'<'),
      (Symbol:S_LE;              Text:'<='),
      (Symbol:S_G;               Text:'>'),
      (Symbol:S_GE;              Text:'>='),
      (Symbol:S_NE;              Text:'<>'),
      (Symbol:S_Assign;          Text:':='),
      (Symbol:S_Point;           Text:'.'),
      (Symbol:S_Period;          Text:'..'),
      (Symbol:S_Plus;            Text:'+'),
      (Symbol:S_Minus;           Text:'-'),
      (Symbol:S_Times;           Text:'*'),
      (Symbol:S_Divide;          Text:'/'),
      (Symbol:S_LBRAC;           Text:'['),
      (Symbol:S_RBRAC;           Text:']'),
      (Symbol:S_Arrow;           Text:'^'),
      (Symbol:S_LB;              Text:'('),
      (Symbol:S_RB;              Text:')'),
      (Symbol:S_Comma;           Text:','),
      (Symbol:S_Colon;           Text:':'),
      (Symbol:S_Semicolon;       Text:';'),
      (Symbol:S_E;               Text:'='),
      (Symbol:S_AddrOp;          Text:'@'),
      (Symbol:S_Pointer;         Text:'@'),
      (Symbol:S_Name;            Text:''),
      (Symbol:S_Name_FORWARD;    Text:''),
      (Symbol:S_STRING_Text;     Text:''),
      (Symbol:S_Konstante;       Text:''),
      (Symbol:S_Prozedur;        Text:''),
      (Symbol:S_Variable;        Text:''),
      (Symbol:S_Property;        Text:''),
      (Symbol:S_Funktion;        Text:''),
      (Symbol:S_StdProc;         Text:''),
      (Symbol:S_StdFunc;         Text:''),
      (Symbol:S_TypBez;          Text:''),
      (Symbol:S_Zahl;            Text:''),
      (Symbol:S_Hex;             Text:'$'),
      (Symbol:S_FloatZahl;       Text:''),
      (Symbol:S_ObjFunktion;     Text:''),
      (Symbol:S_ObjProzedur;     Text:''),
      (Symbol:S_Destruktor;      Text:''),
      (Symbol:S_Konstruktor;     Text:''),
      (Symbol:S_ClassFunktion;   Text:''),
      (Symbol:S_ClassProzedur;   Text:''),
      (Symbol:S_UnitBez;         Text:''),
      (Symbol:S_LabelBez;        Text:''),
      (Symbol:S_PreChar;         Text:''),
      (Symbol:S_ExcptVar;        Text:''),
      (Symbol:S_Nichts;          Text:''));


VAR EOFSource:BOOLEAN;
    ch,chn:CHAR;
    Sym:T_Symbol;
    yyText:STRING;
    yylineno:LONGINT;
    yycolno:LONGINT;
    lastyylineno:LONGINT;
    lastyycolno:LONGINT;
    SourceBuffer:^TSourceArray;
    SourceBufLen:LONGINT;
    SourceBufPtr:LONGINT;
    Zeichenart:ARRAY[#0..#255] OF T_Zeichenart;
    InProcDecl:BOOLEAN;

PROCEDURE InitSourceBuffer(Buf:Pointer;Len,Line,Column:LONGINT);
BEGIN
     SourceBuffer := Buf;
     SourceBufLen := Len;
     SourceBufPtr := Column-1;
     yylineno := Line;
     lastyylineno := Line;
     yycolno := Column;
     lastyycolno := Column;
     ch := ' ';
     chn := SourceBuffer^[SourceBufPtr+1];
     yytext := '';
     Sym := S_ABSOLUTE;
     EOFSource := FALSE;
END;


PROCEDURE Error(ErrNum:INTEGER;Comment:STRING);
VAR  Err:STRING;
BEGIN
     CASE ErrNum OF
         ERR_ILLEGAL_ARRAY_SEL : Err:='Illegal array selector';
         ERR_ILLEGAL_PROC_TYPE : Err:='Illegal procedure type';
         ERR_ILLEGAL_REC_COMP  : Err:='Illegal record component';
         ERR_OUT_OF_MEMORY     : Err:='Out of memory';
         ERR_IDENTIFIER_EXP    : Err:='Identifier expected';
         ERR_ILLEGAL_ARRAY_IND : Err:='Illegal array index';
         ERR_NUMBER_EXPECTED   : Err:='Number expected';
         ERR_ILLEGAL_TYPE      : Err:='Illegal type';
         ERR_CONSTANT_EXP      : Err:='Constant expected';
         ERR_ILLEGAL_FACTOR    : Err:='Illegal factor';
         ERR_ILLEGAL_QUALIFIER : Err:='Illegal qualifier';
         ERR_ILLEGAL_WITH_VAR  : Err:='Illegal WITH variable';
         ERR_ILLEGAL_TOKEN     : Err:='Illegal Token';
         ERR_ILLEGAL_STATEMENT : Err:='Illegal statement';
         ERR_PROGRAM_EXPECTED  : Err:='PROGRAM, UNIT or LIBRARY expected';
         ERR_POINT_EXPECTED    : Err:='. expected';
         ERR_SOURCE_NOT_FOUND  : Err:='Source file not found';
         ERR_SOURCE_READ       : Err:='Could not read from source file';
         ERR_UNDEFINED_IDENT   : Err:='Undefined identifier';
         ERR_DUPLICATE_IDENT   : Err:='Duplicate identifier';
         ERR_ILLEGAL_CHARACTER : Err:='Illegal character';
         ERR_SYNTAX            : Err:='Syntax error';
         ERR_DIV_BY_ZERO       : Err:='Division by zero';
         ERR_NO_MORE_REGS      : Err:='No more registers';
         ERR_TOO_MUCH_PARAMS   : Err:='Too much parameters for call';
         ERR_TOO_FEW_PARAMS    : Err:='Too few parameters for call';
         ERR_ILL_WRITE_TYPE    : Err:='Illegal type for output';
         ERR_ILL_READ_TYPE     : Err:='Illegal type for input';
         ERR_ILLEGAL_NUMBER    : Err:='Illegal character in number';
         ERR_IMPL_EXPECTED     : Err:='IMPLEMENTATION expected';
         ERR_BEGIN_EXPECTED    : Err:='BEGIN expected';
         ERR_INTERFACE_EXP     : Err:='INTERFACE expected';
         ERR_TYPE_CONFLICT     : Err:='Type conflict';
         ERR_BRACK_EXP         : Err:=' [ expected';
         ERR_ILLEGAL_STR_DIM   : Err:='Illegal string dimension';
         ERR_REC_TYPE_EXP      : Err:='Invalid qualifier';
         ERR_TOO_MANY_WITH     : Err:='Too many nested WITH statements';
         ERR_ILL_ARRAY_REF     : Err:='Illegal array reference';
         ERR_ILL_ARRAY_DIM     : Err:='Illegal ARRAY dimension';
         ERR_HEADER_NOT_MATCH  : Err:='Header does not match previous definition';
         ERR_FEW_PARAMS        : Err:='Too few parameters for procedure/function call';
         ERR_MUCH_PARAMS       : Err:='Too much parameters for procedure/function call';
         ERR_VARREF_EXPECTED   : Err:='Variable reference expected';
         ERR_ILL_PARASIZE      : Err:='Incorrect size of parameter';
         ERR_DLL_API_EXP       : Err:='DLL name or APIENTRY expected';
         ERR_DLLNAME_EXP       : Err:='DLL name expected';
         ERR_INDEX_NAME_EXP    : Err:='INDEX or NAME expected';
         ERR_NUMCONST_EXP      : Err:='Numeric constant expected';
         ERR_STRCONST_EXP      : Err:='String constant expected';
         ERR_ILL_DLLNAME       : Err:='Illegal DLL name';
         ERR_UNIT_GEN          : Err:='Could not generate unit file';
         ERR_FILE_WRITE        : Err:='File write error';
         ERR_UNIT_MISMATCH     : Err:='Unit name mismatch';
         ERR_IN_ASM            : Err:='Error in ASM statement';
         ERR_TYPENAME_EXP      : Err:='Type identifier expected';
         ERR_FORWARDS_LEFT     : Err:='Undefined forward definition';
         ERR_ILL_UNIT_NAME     : Err:='Illegal Unit name';
         ERR_UNIT_NOT_FOUND    : Err:='Unit file not found';
         ERR_FILE_READ         : Err:='File read error';
         ERR_FILE_NOT_FOUND    : Err:='File not found';
         ERR_END_EXPECTED      : Err:='END expected';
         ERR_LABEL_NOT_DEF     : Err:='Label not defined in previous statement part';
         ERR_LABEL_EXP         : Err:='Label identifier expected';
         ERR_DUP_DYN_INDEX     : Err:='Duplicate dynamic method index';
         ERR_ILL_VIR_CONST     : Err:='Illegal virtual constructor';
         ERR_ILL_VIR_DEST      : Err:='Illegal virtual destructor';
         ERR_ILLEGAL_FORWARD   : Err:='Undefined forward';
         ERR_METHOD_UNDEF      : Err:='Object method undefined';
         ERR_ILL_OBJ_CALL      : Err:='Illegal object call';
         ERR_CONST_EXP         : Err:='Constructor expected';
         ERR_DEST_EXP          : Err:='Destructor expected';
         ERR_READ_WRITE_EXP    : Err:='READ or WRITE clause expected';
         ERR_DUP_READ          : Err:='Duplicate property read method';
         ERR_DUP_WRITE         : Err:='Duplicate property write method';
         ERR_FIELD_IDENT_EXP   : Err:='Field identifier expected';
         ERR_ILL_FUNC_RES      : Err:='Illegal function result type';
         ERR_PROP_READONLY     : Err:='Property is read only';
         ERR_PROP_WRITEONLY    : Err:='Property is write only';
         ERR_ILL_INHERITED     : Err:='Illegal INHERITED statement';
         ERR_CLASS_OBJECT_MIX  : Err:='You cannot mix CLASS and OBJECT';
         ERR_FUNC_PROC_EXP     : Err:='PROCEDURE or FUNCTION expected';
         ERR_VAR_INACCESSABLE  : Err:='Instance variables not accessible here';
         ERR_METH_INACCESSABLE : Err:='Instance methods not accessible here';
         ERR_ILL_CONST_ASSIGN  : Err:='Illegal assignment to constant parameter';
         ERR_ILL_FORWARD       : Err:='Illegal forward type usage';
         ERR_INV_MSG_HANDLER   : Err:='Invalid message handler';
         ERR_INV_MSG_PARAMS    : Err:='Invalid message handler parameter list';
         ERR_ILL_FAIL          : Err:='Fail only allowed within constructors';
         ERR_RANGE_CHECK       : Err:='Range check error';
         ERR_CANNOT_WRITE      : Err:='Cannot write variables of this type';
         ERR_UNIT_VERS_MIS     : Err:='Unit version mismatch';
         ERR_ILL_DIRECTIVE     : Err:='Illegal compiler directive';
         ERR_MISSING_ENDIF     : Err:='Missing ENDIF directive';
         ERR_ILL_SET           : Err:='Illegal set member type (256 elements max)';
         ERR_ILL_ADDR_REF      : Err:='Cannot evaluate address reference';
         ERR_INV_FILE_TYPE     : Err:='Invalid file type';
         ERR_CANNOT_READ       : Err:='Cannot read variables of this type';
         ERR_ILL_BREAK         : Err:='Illegal break command';
         ERR_ILL_CONTINUE      : Err:='Illegal continue command';
         ERR_ILL_TYPECAST      : Err:='Illegal type cast';
         ERR_DUP_INDEX         : Err:='Duplicate EXPORT index';
         ERR_ILL_EXPORT        : Err:='Illegal export';
         ERR_EXPORT_UNDEF      : Err:='Exported identifier undefined';
         ERR_ILL_FUNCREF       : Err:='Illegal function reference';
         ERR_CONST_OUT_OF_RANGE: Err:='Constant out of range';
         ERR_STRING_EXCEEDS_LINE:Err:='String constant exceeds line';
         ERR_OBJTYPE_EXP       : Err:='Object/Class type expected';
         ERR_METHOD_NOT_INPARENT:Err:='Method not declared in parent class';
         ERR_DUP_DEFAULT       : Err:='Duplicate default array property';
         ERR_ILL_DEFAULT       : Err:='Illegal default array property';
         ERR_INDEXED_PUB       : Err:='You cannot publish indexed properties';
         ERR_INDEX95           : Err:='Indexed Export/Import not supported for Win32';
         ERR_ILL_OVERRIDE      : Err:='Illegal OVERRIDE statement';
         ERR_DUP_VAR_IMPORT    : Err:='Importing a variable list is not allowed';
         ERR_BOOL_EXP          : Err:='Boolean expression expected';
         ERR_DUP_NAME          : Err:='Duplicate Property default name';
         ERR_NAME_MISMATCH     : Err:='Property default name mismatch';
         ERR_ILL_PROP_ASSIGN   : Err:='You cannot pass properties by reference';
         ERR_ILL_ABSTRACT      : Err:='Only virtual or overrided methods can be abstract';
         ELSE                    Err:='Internal error';
     END;

     IF Comment <> '' THEN Err := Err+' ('+Comment+')';

     Err := Err +' in ['+tostr(lastyylineno)+','+tostr(lastyycolno)+']';
     LastParserError := 'Parser: '+ Err;
     SetMainStatusText(LastParserError,clRed,clLtGray);
     RAISE EParserError.Create(Err);
END;


PROCEDURE DictSearch(CONST Name:STRING;VAR Token:T_Symbol);
VAR  i:INTEGER;
BEGIN
     FOR i := 1 TO MaxSymbols DO
     BEGIN
          IF SymbolText[i].Text = Name THEN
          BEGIN
               Token := SymbolText[i].Symbol;
               exit;
          END;
     END;
     Token := S_Name;
END;


PROCEDURE _input;
BEGIN
     IF SourceBufPtr < SourceBufLen THEN
     BEGIN
          ch := chn;
          inc(yycolno);
          inc(SourceBufPtr);
          IF SourceBufPtr = SourceBufLen THEN chn := #32
          ELSE chn := SourceBuffer^[SourceBufPtr+1];

          IF ch = CR THEN
          BEGIN
               inc(yylineno);
               yycolno := 0;
               IF SourceBufPtr+2 <= SourceBufLen THEN
               BEGIN
                    IF SourceBuffer^[SourceBufPtr+1] = LF THEN
                    BEGIN
                         inc(SourceBufPtr);
                         chn := SourceBuffer^[SourceBufPtr+1];
                    END;
               END;
               ch := #32;
          END;

          IF ch < #32 THEN ch := #32;
     END
     ELSE EOFSource := TRUE;
END;


{berspringe Leerrume, TAB und Kommentare}
PROCEDURE SkipWhiteSpace;
VAR  OldLine:longint;
BEGIN
     WHILE not EOFSource DO
     CASE ch OF
         Blank,CR,LF,TAB,#9: _input;
         '{':
         BEGIN
              REPEAT
                    _input;
              UNTIL ((ch = '}' ) OR EOFSource);
              _input;
         END;
         '(':
         BEGIN
              IF chn = '*' THEN
              BEGIN
                   REPEAT
                         _input;
                   UNTIL (((ch = '*') AND (chn = ')')) OR EOFSource);
                   _input;
                   _input;
              END
              ELSE exit;
         END;
         '/':
         BEGIN
              IF chn = '*' THEN
              BEGIN
                   REPEAT
                         _input;
                   UNTIL (((ch = '*') AND (chn = '/')) OR EOFSource);
                   _input;
                   _input;
              END
              ELSE
              BEGIN
                   IF chn = '/' THEN
                   BEGIN
                        OldLine := yylineno;
                        REPEAT
                              _input;
                        UNTIL ((OldLine <> yylineno) OR EOFSource);
                        _input;
                        _input;
                   END
                   ELSE exit;
              END;
         END;
         ELSE exit;
     END;
END;



{Suche Bezeichner oder reserviertes Wort
liefert : yytext    - ASCII Text eines  Bezeichners
          yylval.o  - Eintrag in der Symboltabelle
          yylval.i  - Code fr reserviertes Word
          Sym       - aktuelles Symbol}
PROCEDURE ScanWords;
VAR  k:BYTE;
BEGIN
     k := 1;
     REPEAT
           IF k < 64 THEN
           BEGIN
                yytext[k] := Upcase(ch);
                inc(k);
           END;
           _input;
     UNTIL not ((Zeichenart[ch] = Buchstabe) OR (Zeichenart[ch] = Ziffer));
     yytext[0] := chr(k-1);

     IF ((k = 1) OR (k > 15)) THEN Sym := S_Name{yylval.o := NIL}
     ELSE DictSearch(yytext,Sym);
END;


PROCEDURE ScanNumbers;
VAR  k:BYTE;
     typ:T_Symbol;
Label l,l1;
BEGIN
     k := 1;
     WHILE ZeichenArt[ch]=Ziffer DO
     BEGIN
          yyText[k] := ch;
          inc(k);
          _input;
     END;
     typ := S_Zahl;
     IF Upcase(ch) IN ['.','E'] THEN  {Floating point number}
     BEGIN
          IF ch = '.' THEN
          BEGIN
               IF ZeichenArt[chN] <> Ziffer THEN
               BEGIN
                    IF chn = '.' THEN goto l;  {..}
                    typ := S_FloatZahl;
                    yyText[k] := '.';
                    _input;
                    inc(k);
                    yyText[k] := '0';
                    inc(k);
                    IF Upcase(ch) = 'E' THEN goto l1;
                    goto l;
               END;
               yyText[k] := '.';
               _input;
               inc(k);
          END
          ELSE IF ZeichenArt[chn] <> Ziffer THEN
                 IF not(chn IN ['-','+']) THEN goto l;

          typ := S_FloatZahl;
          WHILE ZeichenArt[ch] = Ziffer DO
          BEGIN
               yyText[k] := ch;
               inc(k);
               _input;
          END;
          IF Upcase(ch) = 'E' THEN
          BEGIN
l1:
               yyText[k] := ch;
               inc(k);
               _input;
               IF ch = '-' THEN
               BEGIN
                    yyText[k] := ch;
                    inc(k);
                    _input;
               END
               ELSE
               IF ch = '+' THEN
               BEGIN
                    yyText[k] := ch;
                    inc(k);
                    _input;
               END;
               WHILE ZeichenArt[ch] = Ziffer DO
               BEGIN
                    yyText[k] := ch;
                    inc(k);
                    _input;
               END;
          END;
     END;
l:
     yyText[0] := chr(k-1);
     Sym := typ;
     {EnterConstant(yyText,typ,0,yylval.o);
     Sym := yylval.o^.Symbol;}
END;


PROCEDURE ScanHexNumbers;
VAR  k:BYTE;
     typ:T_Symbol;
BEGIN
     k := 1;
     _input;  {Overread $}
     {WHILE ZeichenArt[ch] IN [Ziffer,Buchstabe] DO}
     WHILE Upcase(ch) IN ['0'..'9','A'..'F'] DO
     BEGIN
          yyText[k] := ch;
          inc(k);
          _input;
     END;
     typ := S_Zahl;

     yyText[0] := chr(k-1);
     yyText := '$'+ yyText;
     Sym := typ;
     {EnterConstant(yyText,typ,0,yylVal.o);
     Sym:=yylVal.o^.Symbol;}
END;


{Suche die Einzelzeichen}
PROCEDURE ScanSingleChars;
BEGIN
     yytext[1] := ch;
     yytext[0] := #1;

     DictSearch(yytext,Sym);
     _input;
END;


{Suche die Doppelzeichen}
PROCEDURE ScanDoubleChars;
BEGIN
     IF (ch = '.') AND EOFSource THEN
     BEGIN
          ScanSingleChars;
          exit;
     END;

     yytext[1] := ch;
     yytext[2] := chn;
     yytext[0] := #2;

     DictSearch(yytext,Sym);
     IF Sym <> S_Name THEN
     BEGIN
          _input;
          _input;
     END
     ELSE ScanSingleChars;
END;


{Suche Strings}
PROCEDURE ScanStrings;
VAR  EndeString:BOOLEAN;
     Index:BYTE;
     StartLine:LONGINT;
BEGIN
     EndeString := FALSE;
     Index := 1;

     yytext[0] := #0;
     _input;
     StartLine := yylineno;

     REPEAT
           IF yylineno <> StartLine THEN
             IF ch <> HK THEN Error(ERR_STRING_EXCEEDS_LINE,'');

           IF (ch = HK) AND (chn = HK) THEN
           BEGIN
                EndeString := FALSE;
                yytext[Index] := ch;
                inc(Index);
                _input;
           END
           ELSE
           BEGIN
                EndeString := (ch = HK) AND (chn <> HK);
                IF NOT EndeString THEN
                BEGIN
                     yytext[Index] := ch;
                     inc(Index);
                END;
           END;
           _input;
     UNTIL (EndeString OR EOFSource);

     yytext[0] := chr(Index-1);
     Sym := S_STRING;
     {EnterConstant(yytext,S_STRING_Text,0,yylval.o);
     IF yylval.o^.Typ^.TypArt<>Typ_Char THEN yylval.o^.TypDesc:=Ptr_String_Object
     ELSE yylval.o^.TypDesc:=Ptr_Char_Object;
     Sym:=yylval.o^.Symbol;}
END;


{Steuerung des Scanners}
PROCEDURE yylex;
BEGIN
     SkipWhiteSpace;

     lastyylineno := yylineno;
     lastyycolno := yycolno;

     IF EOFSource THEN
     BEGIN
          Sym := S_Nichts;
          exit;
     END;

     CASE (Zeichenart[ch]) OF
         Buchstabe    : ScanWords;
         Doppelzeichen: ScanDoubleChars;
         Einzelzeichen: ScanSingleChars;
         Ziffer       : ScanNumbers;
         Hochkomma    : ScanStrings;
         ELSE
         BEGIN
              CASE ch OF
                '$': ScanHexNumbers;
                '@':
                BEGIN
                     Sym := S_AddrOp;
                     _input;
                END;
                ELSE IF not EOFSource THEN Error(ERR_ILLEGAL_CHARACTER,'');
              END; {case}
         END;
     END;
END;


FUNCTION GetSymbolText(TestSymbol:T_Symbol):STRING;
VAR  i:INTEGER;
BEGIN
     FOR i := 1 TO MaxSymbols DO
     BEGIN
          IF SymbolText[i].Symbol = TestSymbol THEN
          BEGIN
               GetSymbolText := SymbolText[i].Text;
               exit;
          END;
     END;
END;


{Teste Symbol}
PROCEDURE TestScan(TestSymbol:T_Symbol);
BEGIN
     IF Sym = TestSymbol THEN yylex
     ELSE Error(ERR_SYNTAX,#39+GetSymbolText(TestSymbol)+#39+' expected');
END;



PROCEDURE ParseTyp;FORWARD;
PROCEDURE ParseConstExpr;FORWARD;
PROCEDURE ParseObjDecl(ObjektTyp:T_Variablen; IsClassVar:BOOLEAN);FORWARD;


{Parser fr TYPE ...:= XOR ...}
PROCEDURE ParsePointer;
BEGIN
     yylex;
     IF Sym <> S_Name{S_TypBez} THEN
       IF Sym <> S_Name_FORWARD THEN
     BEGIN
          CASE Sym OF
             S_STRING:;
             S_CSTRING:;
             S_FILE:
             BEGIN
                  ParseTyp;
                  exit;
             END;
             ELSE Error(ERR_TYPENAME_EXP,'');
          END;
     END;
     yylex;
END;


{Parser fr TYPE ...:= Name}
PROCEDURE ParseSimpleTypes;
BEGIN
     IF Sym <> S_Name{S_TypBez} THEN
     BEGIN
          CASE Sym OF
              S_STRING:;
              S_CSTRING:;
              S_Name_FORWARD:;
              ELSE Error (ERR_IDENTIFIER_EXP,'');
          END; {case}
          yylex;
          exit;
     END;
     yylex;
     IF Sym = S_TO THEN ParsePointer;
END;


{Parser fr TYPE ...:= X ..Y}
PROCEDURE ParseRangeTypes;
BEGIN
     ParseConstExpr;
     TestScan(S_Period);
     ParseConstExpr;
END;


{Parser fr TYPE ...:= (Rot ,Gruen ,Gelb )}
PROCEDURE ParseEnumTypes;
BEGIN
     yylex;
     REPEAT
           IF Sym <> S_Name THEN Error(ERR_IDENTIFIER_EXP,'');
           yylex;
           {IF yytext = 'NAME' THEN
           BEGIN
                yylex;
                IF Sym <> S_STRING_Text THEN Error(ERR_SYNTAX,'');
                yylex;
           END;}
           IF Sym <> S_RB THEN TestScan(S_Comma);
     UNTIL Sym = S_RB ;

     yylex ;
END;


PROCEDURE ParseRecordCase(nested:BOOLEAN);
LABEL l;
BEGIN
     yylex;

     TestScan(S_OF);

     WHILE Sym<>S_END DO
     BEGIN
l:
          IF not (Sym IN [S_Zahl,S_Name{S_Konstante},S_String_Text])
          THEN Error(ERR_TYPE_CONFLICT,'');
          yylex;
          IF Sym = S_Comma THEN
          BEGIN
               yylex;
               goto l;
          END;
          TestScan(S_Colon);
          TestScan(S_LB);
          WHILE Sym<>S_RB DO
          BEGIN
               IF Sym = S_CASE THEN ParseRecordCase(TRUE)
               ELSE
               BEGIN
                    IF Sym <> S_Name THEN Error(ERR_IDENTIFIER_EXP,'');
                    ParseObjDecl(Komponente, FALSE); // ist keine Klassenvariable

                    WHILE Sym = S_Semicolon DO yylex;
               END;
          END;
          yylex;

          IF nested THEN
          BEGIN
               IF Sym = S_RB THEN exit
               ELSE IF Sym <> S_END THEN TestScan(S_Semicolon);
          END
          ELSE IF Sym <> S_END THEN TestScan(S_Semicolon);
      END;
END;


{Parser fr TYPE ...:= RECORD ...END}
PROCEDURE ParseRECORD;
BEGIN
     yylex;

     WHILE Sym = S_Name DO
     BEGIN
          ParseObjDecl(Komponente, FALSE);   // ist keine Klassenvariable
          WHILE Sym = S_Semicolon DO yylex;
     END;

     IF Sym = S_CASE THEN ParseRecordCase(FALSE);

     TestScan(S_END);
END;


PROCEDURE ParseUnitBez;
BEGIN
     yylex;
     TestScan(S_Point);
     yylex;
END;


PROCEDURE GetStringConcat;
LABEL l;
BEGIN
l:
     CASE Sym OF
        S_Arrow:
        BEGIN
             yylex;
             IF Sym <> S_Name THEN Error(ERR_TYPE_CONFLICT,'');
             IF Length(yytext) <> 1 THEN Error(ERR_TYPE_CONFLICT,'');

             yylex;
             IF Sym IN [S_PreChar,S_Arrow,S_Name{S_Konstante},S_STRING_Text]
             THEN goto l;
        END;
        S_PreChar:
        BEGIN
             yylex;
             yylex;
             IF Sym IN [S_PreChar,S_Arrow,S_Name{S_Konstante},S_STRING_Text]
             THEN goto l;
        END;
        S_Name{S_Konstante},S_STRING_Text:
        BEGIN
             yylex;
             IF Sym IN [S_PreChar,S_Arrow] THEN goto l;
        END;
     END; {case}
END;


PROCEDURE ParsePreChar;
BEGIN
     yylex;
     yylex;

     IF Sym IN [S_PreChar,S_Name{S_Konstante},S_STRING_Text] THEN GetStringConcat;
END;


PROCEDURE ParseCtrlChar;
BEGIN
     yylex;
     IF Length(yytext) <> 1 THEN Error(ERR_TYPE_CONFLICT,'');

     yylex;

     IF Sym IN [S_PreChar,S_Arrow,S_Name{S_Konstante},S_STRING_Text] THEN GetStringConcat;
END;


{Parser fr h”chsten Vorrang in PASCAL}
PROCEDURE ParseConstPrec1;
VAR  OldSym:T_Symbol;
LABEL l1,l2,typecast;
BEGIN
l1:
     CASE Sym OF
         S_UnitBez:
         BEGIN
              ParseUnitBez;
              goto l1;
         END;
         S_Point: {FloatZahl ??}
         BEGIN
              yylex;
              IF Sym <> S_Zahl THEN Error(ERR_NUMBER_EXPECTED,'');
              goto l2;
         END;
         S_FloatZahl:
         BEGIN
l2:
              yylex;
         END;
         S_Zahl, S_NIL, S_STRING_Text, S_Name{zB Konstante}:
         BEGIN
              OldSym := Sym;
              yylex;
              IF (OldSym = S_Name) AND (Sym = S_LB) THEN  {possible TYPECAST}
              BEGIN
                   TestScan(S_LB);
                   ParseConstExpr;
                   TestScan(S_RB);
              END;
         END;
         S_NOT:
         BEGIN
              yylex;
              ParseConstPrec1;
         END;
         S_LB:
         BEGIN
              yylex;
              ParseConstExpr;
              TestScan(S_RB);
         END;
         S_PreChar:ParsePreChar;
         S_Arrow:ParseCtrlChar;
         S_STRING,S_CSTRING:
         BEGIN
typecast:
              yylex;
              TestScan(S_LB);
              ParseConstExpr;
              TestScan(S_RB);
         END;
         ELSE Error (ERR_ILLEGAL_FACTOR ,'');
     END;
END;


{Parser fr zweith”chsten Vorrang in PASCAL}
PROCEDURE ParseConstPrec2;
BEGIN
     ParseConstPrec1;

     WHILE Sym IN [S_Times,S_DIV,S_MOD,S_AND,S_SHL,S_SHR,S_Divide] DO
     BEGIN
          yylex;
          ParseConstPrec1;
     END;
END;


{Parser fr dritth”chsten Vorrang in PASCAL}
PROCEDURE ParseConstPrec3;
BEGIN
     IF Sym IN [S_Plus,S_Minus] THEN yylex;

     ParseConstPrec2;

     WHILE Sym IN [S_Plus,S_Minus,S_OR,S_XOR] DO
     BEGIN
          yylex;
          ParseConstPrec2;
     END;
END;


{Parser fr geringsten Vorrang in PASCAL}
PROCEDURE ParseConstExpr;
BEGIN
     ParseConstPrec3;
END;


{Parser fr TYPE ...:= ARRAY [ ...,...,] OF ...}
PROCEDURE ParseARRAYList;
BEGIN
     ParseTyp;

     IF Sym=S_Period THEN
     BEGIN
          yylex;
          ParseTyp;
     END;

     IF Sym = S_Comma THEN
     BEGIN
          yylex;
          ParseARRAYList;
     END
     ELSE
     BEGIN
          TestScan(S_RBRAC );
          TestScan(S_OF );
          ParseTyp;
     END;
END;


{ARRAY Deklaration verarbeiten}
PROCEDURE ParseARRAY;
BEGIN
     yylex;
     IF Sym = S_OF THEN
       IF InProcDecl THEN
     BEGIN
          {Open array parameter}
          TestScan(S_OF);
          IF Sym = S_CONST THEN yylex {Array OF CONST}
          ELSE ParseTyp;
          exit;
     END;
     TestScan(S_LBRAC);
     ParseARRAYList;
END;


{String Deklaration behandeln}
PROCEDURE ParseSTRING;
BEGIN
     yylex;
     IF Sym = S_LBRAC THEN
     BEGIN
          yylex;
          ParseConstExpr;
          TestScan(S_RBRAC);
     END;
END;


{File Deklaration behandeln}
PROCEDURE ParseFILE;
BEGIN
     yylex;
     IF Sym = S_OF THEN
     BEGIN
          yylex;
          ParseTyp;
     END;
END;


PROCEDURE ParseSet;
BEGIN
     yylex;
     TestScan(S_OF);
     ParseTyp;
END;


PROCEDURE ParseProcFuncVar;
VAR  Art:T_Symbol;
     VarParameter:T_Variablen;
BEGIN
     CASE Sym OF
         S_FUNCTION:    Art := S_Funktion;
         S_PROCEDURE:   Art := S_Prozedur;
         S_CONSTRUCTOR: Art := S_Konstruktor;
         S_DESTRUCTOR:  Art := S_Destruktor;
         ELSE Error(ERR_TYPE_CONFLICT,'');
     END; {case}

     yylex;

     IF Sym = S_LB THEN
     BEGIN
          InProcDecl := TRUE;
          yylex;
          REPEAT
               CASE Sym OF
                   S_VAR:
                   BEGIN
                        yylex;
                        VarParameter := VAR_Parameter
                   END;
                   S_CONST:
                   BEGIN
                        yylex;
                        VarParameter := CONST_Parameter
                   END;
                   ELSE VarParameter := VAL_Parameter;
               END; {case}

               ParseObjDecl(VarParameter, FALSE);  // ist keine Klassenvariable
               WHILE Sym = S_Semicolon DO yylex;
          UNTIL Sym = S_RB;

          InProcDecl := FALSE;
          yylex;
     END;

     IF Art = S_Funktion THEN
     BEGIN
         TestScan(S_Colon);
         ParseSimpleTypes;
     END;

     IF Sym = S_OF THEN {of object ??}
     BEGIN
          yylex;
          TestScan(S_OBJECT);
     END;

     SkipWhiteSpace;
     IF ch = 'C' THEN
       IF chn = 'D' THEN
     BEGIN
          IF Sym <> S_END THEN TestScan(S_Semicolon);
          IF yytext <> 'CDECL' THEN Error(ERR_SYNTAX,'CDECL or Semicolon expected');
          yylex;
     END;
     IF ch = 'A' THEN
       IF chn = 'P' THEN
     BEGIN
          IF Sym <> S_END THEN TestScan(S_Semicolon);
          IF yytext <> 'APIENTRY' THEN Error(ERR_SYNTAX,'APIENTRY or Semicolon expected');
          yylex;
     END;
END;


{Hauptverteiler fr die Analyse von Datentypen}
PROCEDURE ParseTyp;
LABEL l;
BEGIN
l:
     CASE Sym OF
         S_UnitBez:
         BEGIN
              ParseUnitBez;
              goto l;
         END;
         S_ARRAY            :ParseARRAY;
         S_PACKED           :
         BEGIN
              yylex;
              CASE Sym OF
                 S_ARRAY :ParseARRAY;
                 S_RECORD:ParseRECORD;
                 ELSE Error(ERR_SYNTAX,'ARRAY or RECORD expected');
              END; {case}
         END;
         S_RECORD           :ParseRECORD;
         S_OBJECT,S_CLASS   :ParseOBJECT;
         S_Arrow            :ParsePointer;
         S_Name{S_TypBez}   :ParseSimpleTypes;
         {S_Konstante,}S_Zahl,S_StdFunc,S_PreChar,S_Hex,
         S_Minus,S_Plus     :ParseRangeTypes;
         S_LB               :ParseEnumTypes;
         S_STRING,S_CSTRING :ParseSTRING;
         S_PROCEDURE        :ParseProcFuncVar;
         S_FUNCTION         :ParseProcFuncVar;
         S_CONSTRUCTOR      :ParseProcFuncVar;
         S_DESTRUCTOR       :ParseProcFuncVar;
         S_FILE             :ParseFile;
         S_SET              :ParseSet;
         ELSE Error (ERR_ILLEGAL_TYPE ,'');
     END;
END;


PROCEDURE ParseConstVar;
BEGIN
     yylex;
     WHILE Sym IN [S_Point,S_LBRAC] DO
     BEGIN
          CASE Sym OF
            S_Point: yylex;
            S_LBRAC:
            BEGIN
                 yylex;
                 ParseConstExpr;
                 TestScan(S_RBRAC);
            END;
          END; {case}
     END;
END;


{Parser fr eine Liste von Objektdeklarationen}
PROCEDURE ParseObjDecl(ObjektTyp:T_Variablen; IsClassVar:BOOLEAN);
VAR  pSymT:PSymbolTable;
BEGIN
     IF Sym <> S_Name THEN Error(ERR_IDENTIFIER_EXP,'');

     WHILE Sym = S_Name DO
     BEGIN
          New(pSymT);
          SymbolTable.Add(pSymT);
          pSymT^.name := yytext;
          pSymT^.typ := '';
          pSymT^.IsClassVar := IsClassVar;
          pSymT^.npos.X := lastyycolno;
          pSymT^.npos.Y := lastyylineno;
          {lastyy,yytext BEZEICHNER}
          yylex;     {Overread identifier}
          IF Sym <> S_Comma THEN break
          ELSE yylex; {Overread Comma}
     END;

     IF ((Sym IN [S_Semicolon,S_RB]) AND
         (ObjektTyp IN [VAR_Parameter,CONST_Parameter])) THEN {Untyped VAR}
     BEGIN
     END
     ELSE
     BEGIN
          TestScan(S_Colon);
          pSymT^.typ := yytext;
          pSymT^.tpos.X := lastyycolno;
          pSymT^.tpos.Y := lastyylineno;
          {lastyy,yytext TYP}
          ParseTyp;

          IF Sym = S_ABSOLUTE THEN
          BEGIN
               IF ObjektTyp IN [VAR_Parameter,VAL_Parameter,Komponente]
               THEN Error(ERR_SYNTAX,'');
               yylex;
               IF Sym <> S_Variable THEN Error(ERR_SYNTAX,'');
               ParseConstVar;
          END;
     END;
END;


PROCEDURE ParseProperty;
VAR  Nr:T_StdNamen;
LABEL l1,l2;
BEGIN
     yylex;

     {new Property}
     yylex;
     IF Sym = S_LBRAC THEN {indexed property}
     BEGIN
          yylex;
l2:
          IF Sym = S_CONST THEN yylex;
          IF Sym <> S_Name THEN Error(ERR_SYNTAX,'');

          ParseObjDecl(Variable, FALSE);   // ist keine Klassenvariable

          IF Sym <> S_RBRAC THEN
          BEGIN
               TestScan(S_Semicolon);
               goto l2;
          END;

          TestScan(S_RBRAC);
     END;

     TestScan(S_Colon);
     ParseTyp;

l1:
     nr := N_N;
     IF yytext = 'READ' THEN Nr := N_READ;
     IF yytext = 'WRITE' THEN Nr := N_WRITE;
     {IF yytext = 'NAME' THEN Nr := N_TRUE;}
     CASE nr OF
         N_TRUE:
         BEGIN
              yylex;
              IF Sym <> S_String_Text THEN Error(ERR_SYNTAX,'');
              yylex;
              IF Sym <> S_Semicolon THEN goto l1;
         END;
         N_READ,N_WRITE:
         BEGIN
              yylex;
              yylex;

              IF Sym <> S_Semicolon THEN goto l1;
         END;
         ELSE Error(ERR_READ_WRITE_EXP,'');
     END; {case}
END;


{Parser fr Deklarationsteil}
PROCEDURE ParseProcDecl;
VAR  Symbol2,Symbol:T_Symbol;
     InLB:BOOLEAN;
     VarParameter:T_Variablen;
     pSymT:PSymbolTable;
LABEL l;
BEGIN
     New(pSymT);
     SymbolTable.Add(pSymT);
     pSymT^.name := yytext;
     pSymT^.typ := '';
     pSymT^.npos.X := lastyycolno;
     pSymT^.npos.Y := lastyylineno;
     Symbol2 := Sym;
     CASE Sym OF
         S_PROGRAM     :Symbol := S_UnitBez;
         S_UNIT        :Symbol := S_UnitBez;
         S_LIBRARY     :Symbol := S_UnitBez;
         S_FUNCTION    :Symbol := S_Funktion;
         S_PROCEDURE   :Symbol := S_Prozedur;
         S_DESTRUCTOR  :Symbol := S_Destruktor;
         S_CONSTRUCTOR :Symbol := S_Konstruktor;
         S_CLASS:
         BEGIN
              yylex;
              Symbol2 := Sym;
              CASE Sym OF
                 S_FUNCTION :Symbol := S_ClassFunktion;
                 S_PROCEDURE:Symbol := S_ClassProzedur;
                 ELSE Error(ERR_FUNC_PROC_EXP,'');
              END;
         END;
     END; {case}

     yylex;   {Bezeichner}
     pSymT^.typ := yytext;
     pSymT^.tpos.X := lastyycolno;
     pSymT^.tpos.Y := lastyylineno;
     yylex;   {LB oder ;}

     InLB := FALSE;
     IF Sym = S_LB THEN
     BEGIN
          InProcDecl := TRUE;
          InLB := TRUE;
          yylex;
          REPEAT
               CASE Sym OF
                   S_VAR:
                   BEGIN
                        yylex;
                        VarParameter := VAR_Parameter;
                   END;
                   S_CONST:
                   BEGIN
                        yylex;
                        VarParameter := CONST_Parameter;
                   END;
                   ELSE VarParameter := VAL_Parameter;
               END; {case}

               ParseObjDecl(VarParameter, FALSE);  // ist keine Klassenvariable
               WHILE Sym = S_Semicolon DO yylex;
          UNTIL Sym = S_RB;

          InProcDecl := FALSE;

          yylex;

          IF Symbol IN [S_Funktion,S_ObjFunktion,S_ClassFunktion] THEN
          BEGIN
               TestScan(S_Colon);
               ParseSimpleTypes;
          END;
     END
     ELSE
     BEGIN
          IF Symbol IN [S_Funktion,S_ObjFunktion,S_ClassFunktion] THEN
          BEGIN
               TestScan(S_Colon);
               ParseSimpleTypes;
          END;
     END;

     IF Sym = S_Semicolon THEN yylex
     ELSE IF Sym <> S_END THEN TestScan(S_Semicolon);

     IF Symbol <> S_UnitBez THEN
     BEGIN
l:
          IF Sym = S_Name{yylval.o = NIL} THEN
          BEGIN
               IF ((yytext = 'VIRTUAL') OR (yytext = 'MESSAGE') OR
                   (yytext = 'DYNAMIC')) THEN
               BEGIN
                    yylex;
                    IF Sym IN [S_Zahl,S_Name] THEN ParseConstExpr
                    {ELSE Sym := S_Name{yylval.o := NIL};

                    IF Sym <> S_END THEN TestScan(S_Semicolon);

                    IF Sym = S_Name{yylval.o = NIL} THEN
                      IF ((yytext = 'VIRTUAL') OR (yytext = 'MESSAGE') OR
                          (yytext = 'DYNAMIC') OR (yytext = 'OVERRIDE'))
                      THEN Error(ERR_SYNTAX,'');
                    goto l;
               END;
               IF yytext = 'CDECL' THEN
               BEGIN
                    yylex;
                    IF Sym <> S_END THEN TestScan(S_Semicolon);
                    IF Sym = S_Name{yylval.o = NIL} THEN
                      IF yytext = 'CDECL' THEN Error(ERR_SYNTAX,'');
                    goto l;
               END;
               IF yytext = 'APIENTRY' THEN
               BEGIN
                    yylex;
                    {Sym := S_Name{yylval.o := NIL};
                    IF Sym <> S_END THEN TestScan(S_Semicolon);
                    IF Sym = S_Name{yylval.o = NIL} THEN
                      IF yytext = 'APIENTRY' THEN Error(ERR_SYNTAX,'');
                    goto l;
               END;
               IF yytext = 'ABSTRACT' THEN
               BEGIN
                    yylex;
                    {Sym := S_Name{yylval.o := NIL};
                    IF Sym <> S_END THEN TestScan(S_Semicolon);
                    IF Sym = S_Name{yylval.o = NIL} THEN
                      IF yytext = 'ABSTRACT' THEN Error(ERR_SYNTAX,'');
                    goto l;
               END;
               IF yytext = 'OVERRIDE' THEN
               BEGIN
                    yylex;
                    {Sym := S_Name{yylval.o := NIL};
                    IF Sym <> S_END THEN TestScan(S_Semicolon);
                    IF Sym = S_Name{yylval.o = NIL} THEN
                      IF ((yytext = 'VIRTUAL') OR (yytext = 'MESSAGE') OR
                          (yytext = 'DYNAMIC') OR (yytext = 'OVERRIDE') OR
                          (yytext = 'ABSTRACT')) THEN Error(ERR_SYNTAX,'');
                    goto l;
               END;
               IF yytext = 'DEFAULT' THEN
               BEGIN
                    yylex;
                    {Sym := S_Name{yylval.o := NIL};
                    IF Sym <> S_END THEN TestScan(S_Semicolon);
                    IF Sym = S_Name{yylval.o = NIL} THEN
                      IF (yytext = 'DEFAULT') THEN Error(ERR_SYNTAX,'');
                    goto l;
               END;
               IF yytext = 'FORWARD' THEN
               BEGIN
                    yylex;
                    {Sym := S_Name{yylval.o := NIL};
                    IF Sym <> S_END THEN TestScan(S_Semicolon);
                    IF Sym = S_Name{yylval.o = NIL} THEN
                      IF yytext = 'FORWARD' THEN Error(ERR_SYNTAX,'');
                    goto l;
               END;
               IF ((yytext = 'FAR') OR (yytext = 'NEAR')) THEN
               BEGIN
                    yylex;
                    {Sym := S_Name{yylval.o := NIL};
                    IF Sym <> S_END THEN TestScan(S_Semicolon);
                    IF Sym = S_Name{yylval.o = NIL} THEN
                      IF ((yytext = 'FAR') OR (yytext = 'NEAR'))
                      THEN Error(ERR_SYNTAX,'');
                    goto l;
               END;
               IF yytext = 'EXPORT' THEN
               BEGIN
                    yylex;
                    {Sym := S_Name{yylval.o := NIL};
                    IF Sym <> S_END THEN TestScan(S_Semicolon);
                    IF Sym = S_Name{yylval.o = NIL} THEN
                      IF yytext = 'EXPORT' THEN Error(ERR_SYNTAX,'');
                    goto l;
               END;
          END
          ELSE
          BEGIN
               IF Sym = S_ASSEMBLER THEN
               BEGIN
                    yylex;
                    {Sym := S_Name{yylval.o := NIL};
                    IF Sym <> S_END THEN TestScan(S_Semicolon);
                    goto l;
               END;
          END;
     END;
END;


{CLASS gelesen, SourcePtr zeigt auf das erste Zeichen nach CLASS}
FUNCTION ParseOBJECT:BOOLEAN;
VAR  pSymT:PSymbolTable;
LABEL l;
BEGIN
     SymbolTable.Create;

     Result := FALSE;

     New(pSymT);
     SymbolTable.Add(pSymT);
     pSymT^.name := '';
     pSymT^.typ := '()';
     pSymT^.tpos.X := lastyycolno;
     pSymT^.tpos.Y := lastyylineno;

     yylex;             {LB}
     IF Sym = S_LB THEN {Parents exist}
     BEGIN
          yylex;        {Parent}
          yylex;        {RB}
          pSymT^.tpos.X := lastyycolno;
          pSymT^.tpos.Y := lastyylineno;
          TestScan(S_RB);
     END;

     IF Sym = S_Semicolon THEN exit;          {empty class}

     WHILE Sym IN [S_Name,S_PROCEDURE,S_FUNCTION,S_CONSTRUCTOR,
                   S_DESTRUCTOR,S_CLASS] DO
     BEGIN
          CASE Sym OF
             S_Name:
             BEGIN
                  IF (yytext = 'PRIVATE') OR (yytext = 'PUBLISHED') OR
                     (yytext = 'PROTECTED') OR (yytext = 'PUBLIC') THEN
                  BEGIN
                       New(pSymT);
                       SymbolTable.Add(pSymT);
                       pSymT^.name := yytext;
                       pSymT^.typ := '';
                       pSymT^.tpos.X := lastyycolno;
                       pSymT^.tpos.Y := lastyylineno;

                       yylex;
                       goto l;
                  END;

                  IF yytext = 'PROPERTY' THEN
                  BEGIN
                       ParseProperty;
                       IF Sym <> S_END THEN TestScan(S_Semicolon);
                       goto l;
                  END;

                  ParseObjDecl(Komponente, TRUE); // ist eine Klassenvariable

                  IF Sym <> S_END THEN TestScan(S_SemiColon);

                  WHILE Sym = S_Semicolon DO yylex;
l:
             END;
             S_PROCEDURE,S_FUNCTION,S_CONSTRUCTOR,S_DESTRUCTOR,S_CLASS:
             BEGIN
                  ParseProcDecl;
             END;
          END; {case}
     END; {While}

     TestScan(S_END);

     New(pSymT);
     SymbolTable.Add(pSymT);
     pSymT^.name := 'END;';
     pSymT^.typ := '';
     pSymT^.npos.X := lastyycolno;
     pSymT^.npos.Y := lastyylineno;

     Result := TRUE;
END;



FUNCTION GetNewComponentLine(Component:TComponent):LONGINT;
VAR  AParent,Comp:TComponent;
     compname,comptype:STRING;
     pSymT:PSymbolTable;
     i,j:LONGINT;
BEGIN
     Result := -1;
     AParent := Component.Owner; {in dieser ChildList steht die Comp}
     FOR i := AParent.ComponentCount-1 DOWNTO 0 DO
     BEGIN
          Comp := AParent.Components[i];

          IF Comp <> Component THEN
            IF not (csDetail IN Comp.ComponentState) THEN
          BEGIN
               compname := Comp.Name;
               comptype := Comp.ClassName;
               UpcaseStr(compname);
               UpcaseStr(comptype);

               FOR j := 1 TO SymbolTable.Count-2 DO
               BEGIN
                    pSymT := SymbolTable.Items[j];
                    IF pSymT^.IsClassVar THEN
                      IF (pSymT^.name = compname) AND (pSymT^.typ = comptype) THEN
                      BEGIN
                           Result := pSymT^.tpos.Y+1;
                           exit;
                      END;
               END;
          END;
     END;

     IF Result < 0 THEN
     BEGIN
          pSymT := SymbolTable.Items[0];
          Result := pSymT^.tpos.Y+1;
     END;
END;


FUNCTION GetNewMethodLine:LONGINT;
VAR  pSymT:PSymbolTable;
     j:LONGINT;
BEGIN
     Result := -1;
     FOR j := 0 TO SymbolTable.Count-2 DO
     BEGIN
          pSymT := SymbolTable.Items[j];
          IF (pSymT^.name = 'PROCEDURE') OR
             (pSymT^.name = 'FUNCTION') OR
             (pSymT^.name = 'CONSTRUCTOR') OR
             (pSymT^.name = 'DESTRUCTOR') OR
             (pSymT^.name = 'PRIVATE') OR
             (pSymT^.name = 'PROTECTED') OR
             (pSymT^.name = 'PUBLIC') OR
             (pSymT^.name = 'PUBLISHED') THEN
          BEGIN
               Result := pSymT^.tpos.Y;
               exit;
          END;
          {Merke letzte Komponente}
          Result := pSymT^.tpos.Y+1;
     END;
END;


PROCEDURE ExtractMethodName(VAR methodname:STRING);
VAR  p:INTEGER;
BEGIN
     p := pos(';', methodname);
     IF p > 0 THEN methodname[0] := chr(p-1);
     p := pos('(', methodname);
     IF p > 0 THEN methodname[0] := chr(p-1);
     p := pos(' ', methodname);
     IF p > 0 THEN methodname[0] := chr(p-1);
END;


FUNCTION GetMethodPosition(methodname:STRING;VAR prc,mth:TEditorPos):BOOLEAN;
VAR  pSymT:PSymbolTable;
     j:LONGINT;
BEGIN
     Result := FALSE;
     IF SymbolTable = NIL THEN exit;  {nach ParserError}

     UpcaseStr(methodname);
     {Extract name of method}
     ExtractMethodName(methodname);

     FOR j := 0 TO SymbolTable.Count-2 DO
     BEGIN
          pSymT := SymbolTable.Items[j];
          IF (pSymT^.name = 'PROCEDURE') AND (pSymT^.typ = methodname) THEN
          BEGIN
               prc := pSymT^.npos;
               mth := pSymT^.tpos;
               Result := TRUE;
               exit;
          END;
     END;
END;


FUNCTION MethodNameExist(methodname:STRING;VAR prc,mth:TEditorPos):BOOLEAN;
VAR  pSymT:PSymbolTable;
     j:LONGINT;
BEGIN
     Result := FALSE;
     IF SymbolTable = NIL THEN exit;  {nach ParserError}

     UpcaseStr(methodname);
     {Extract name of method}
     ExtractMethodName(methodname);

     FOR j := 0 TO SymbolTable.Count-2 DO
     BEGIN
          pSymT := SymbolTable.Items[j];
          IF ((pSymT^.name = 'PROCEDURE') OR (pSymT^.name = 'FUNCTION') OR
              (pSymT^.name = 'CONSTRUCTOR') OR (pSymT^.name = 'DESTRUCTOR'))
             AND (pSymT^.typ = methodname) THEN
          BEGIN
               prc := pSymT^.npos;
               mth := pSymT^.tpos;
               Result := TRUE;
               exit;
          END;
     END;
END;


FUNCTION ComponentExist(compname:STRING;VAR cmp,cmpt:TEditorPos):BOOLEAN;
VAR  pSymT:PSymbolTable;
     j:LONGINT;
BEGIN
     Result := FALSE;
     UpcaseStr(compname);

     IF SymbolTable = NIL THEN exit;  {nach ParserError}

     FOR j := 0 TO SymbolTable.Count-2 DO
     BEGIN
          pSymT := SymbolTable.Items[j];
          IF pSymT^.IsClassVar THEN
            IF pSymT^.name = compname THEN
            BEGIN
                 cmp := pSymT^.npos;
                 cmpt := pSymT^.tpos;
                 Result := TRUE;
                 exit;
            END;
     END;
END;


FUNCTION GetComponentPosition(compname,comptype:STRING;VAR cmp,cmpt:TEditorPos):BOOLEAN;
VAR  pSymT:PSymbolTable;
     j:LONGINT;
BEGIN
     Result := FALSE;
     UpcaseStr(compname);
     UpcaseStr(comptype);

     IF SymbolTable = NIL THEN exit;  {nach ParserError}

     FOR j := 0 TO SymbolTable.Count-2 DO
     BEGIN
          pSymT := SymbolTable.Items[j];
          IF pSymT^.IsClassVar THEN
            IF (pSymT^.name = compname) AND (pSymT^.typ = comptype) THEN
            BEGIN
                 cmp := pSymT^.npos;
                 cmpt := pSymT^.tpos;
                 Result := TRUE;
                 exit;
            END;
     END;
END;


FUNCTION GetClassEndPosition(VAR ep:TEditorPos):BOOLEAN;
VAR  pSymT:PSymbolTable;
BEGIN
     Result := FALSE;

     IF SymbolTable = NIL THEN exit;  {nach ParserError}

     pSymT := SymbolTable.Last;
     IF pSymT^.name = 'END;' THEN
     BEGIN
          ep := pSymT^.npos;
          Result := TRUE;
     END;
END;



PROCEDURE DestroySymbolTable;
VAR  i:INTEGER;
     pSymT:PSymbolTable;
BEGIN
     IF SymbolTable <> NIL THEN
     BEGIN
          FOR i := 0 TO SymbolTable.Count-1 DO
          BEGIN
               pSymT := SymbolTable.Items[i];
               Dispose(pSymT);
          END;
          SymbolTable.Destroy;
     END;
     SymbolTable := NIL;
END;



VAR  b:BYTE;

BEGIN
  FOR b := 0 TO 255 DO
  CASE chr(b) OF
      'A'..'Z',
      'a'..'z' :Zeichenart[chr(b)] := Buchstabe;
      '0'..'9' :Zeichenart[chr(b)] := Ziffer;
      ELSE Zeichenart[chr(b)] := Nix;
  END;

  Zeichenart['_'] := Buchstabe;
  Zeichenart['.'] := Doppelzeichen;
  Zeichenart[':'] := Doppelzeichen;
  Zeichenart['<'] := Doppelzeichen;
  Zeichenart['>'] := Doppelzeichen;
  Zeichenart['('] := Doppelzeichen;
  Zeichenart['*'] := Einzelzeichen;
  Zeichenart['+'] := Einzelzeichen;
  Zeichenart['-'] := Einzelzeichen;
  Zeichenart['|'] := Einzelzeichen;
  Zeichenart['&'] := Einzelzeichen;
  Zeichenart['='] := Einzelzeichen;
  Zeichenart['['] := Einzelzeichen;
  Zeichenart[']'] := Einzelzeichen;
  Zeichenart[')'] := Einzelzeichen;
  Zeichenart[','] := Einzelzeichen;
  Zeichenart['^'] := Einzelzeichen;
  Zeichenart[';'] := Einzelzeichen;
  Zeichenart['/'] := Einzelzeichen;
  Zeichenart['#'] := Einzelzeichen;
  Zeichenart[HK] := Hochkomma;
END.

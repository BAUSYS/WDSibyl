
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library                                               บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

UNIT System;
                      
{$S-,I-,Q-,R-}

{***************************************************************************
 * Note: Compile with DWORD align !!                                       *
 ***************************************************************************}

INTERFACE

//General functions
FUNCTION Swap(i:INTEGER):INTEGER;

//General constants
CONST MINSHORTINT  = -128;
      MAXSHORTINT  = 127;
      MAXINT       = 32767;
      MININT       =-32768;
      MAXLONGINT   = 2147483647;
      {$IFDEF DOSOS2}    //BP doesn't accept this
      MINLONGINT   =-2147483647;
      {$ELSE}
      MINLONGINT   =-2147483648;
      {$ENDIF}
      MINBYTE      = 0;
      MAXBYTE      = 255;
      MINWORD      = 0;
      MAXWORD      = 65535;
      MAXLONGWORD  = $ffffffff;
      MINLONGWORD  = 0;
      NULLHANDLE   = 0;
      SCUPointer   : POINTER=NIL;

Type tCompDataTyp = (CompTyp_Kein, CompTyp_Boolean, CompTyp_ByteBool, CompTyp_WordBool, CompTyp_LongBool,
                     CompTyp_Char, CompTyp_ShortInt, CompTyp_Integer, CompTyp_LongInt,
                     CompTyp_Byte, CompTyp_Word, CompTyp_LongWord,
                     CompTyp_Aufzaehlung,
                     CompTyp_Pointer,CompTyp_Array, CompTyp_String, CompTyp_Record, CompTyp_Prozedur,
                     CompTyp_Single, CompTyp_Real, CompTyp_Double, CompTyp_Extended,
                     CompTyp_Object, CompTyp_Class, CompTyp_Set, CompTyp_Untyped,CompTyp_CString,
                     CompTyp_ProcVar, CompTyp_FuncVar, CompTyp_ObjProcVar,CompTyp_ObjFuncVar,
                     CompTyp_ClassVar, CompTyp_File, CompTyp_Text,CompTyp_AnsiString,CompTyp_Variant,
                     CompTyp_Comp, CompTyp_Currency, CompTyp_OpenString);


PROCEDURE Beep(Freq,duration:LONGWORD);

//General types
TYPE PChar    =^CSTRING;
     PString  =^STRING;
     Cardinal =LONGWORD;
     AnsiChar =CHAR;
     TFileName= String;   // Generic FileName Type

type tUniChar = Record
                  case INTEGER of
                    1: (chW: Word;);
                    2: (chB: Array[0..1] of Byte;);
                    3: (ch : Array[0..1] of Char;);
                End;
     pUniChar    = ^tUniChar;
     tUniString  = Array[0..255] of tUniChar;
     pUniString = ^tUniString;

Type tUniCodeString = Array[0..MAXLONGINT] of tUniChar;
     pUniCodeString = ^tUniCodeString;

     PDATETIME=^DATETIME;
     DATETIME=RECORD
                   CASE INTEGER OF
                      1: ( hour:BYTE;
                           min:BYTE;
                           sec:BYTE;
                           hundredths:BYTE;
                           day:BYTE;
                           month:BYTE;
                           year:WORD;
                           timezone:INTEGER;
                           weekday:BYTE;
                         );
                      2: ( hours:BYTE;
                           minutes:BYTE;
                           seconds:BYTE;
                         );
              END;

     {Generic procedure pointer}
     TProcedure = procedure;

// LongLong-Support
type LONGLONG = record
                  low : longword;
                  high : longint;
                End;

// Memory management functions
// Heapmanagement Martin Vieregg 4/07
TYPE HeapFunc=FUNCTION(size:LONGWORD):Integer;
VAR HeapError:HeapFunc;        {Heap Error Function}
FUNCTION  MaxAvail:LongWord;
FUNCTION  MemAvail:LongWord;
Procedure Heap_Change(iHeapGroup : Pointer; iHeapFinal : Boolean);
Function Heapgroup_BlocksCurrentlyUsed (ID : integer) : longint;
PROCEDURE GetMem(VAR p:Pointer;size:LongWord);
PROCEDURE FreeMem(p:POINTER;size:LongWord);
PROCEDURE GetMemG(ID : integer; VAR p:POINTER;size :LONGWORD);
    {wie getmem, aber mit Angabe Gruppenzugeh”rigkeit}
function GetNewHeapGroupID : integer;
    {gibt eine noch unbenutzte Group-ID aus}
procedure ReleaseHeapGroup (ID : integer);
    {freet eine Gruppe auf einen Schlag}

//PROCEDURE GetMem(VAR p:Pointer;size:LongWord);
PROCEDURE GetSharedMem(VAR p:Pointer;size:LongWord);
{$IFNDEF Win32}
PROCEDURE GetNamedSharedMem(CONST Name:STRING;VAR pp:POINTER;size:LongWord);
FUNCTION AccessNamedSharedMem(CONST Name:STRING;VAR pp:POINTER):BOOLEAN;
PROCEDURE FreeNamedSharedMem(CONST Name:STRING);
{$ENDIF}
FUNCTION AccessSharedMem(VAR p:POINTER):BOOLEAN;
PROCEDURE Mark(VAR p:POINTER);
PROCEDURE Release(VAR p:POINTER);
//PROCEDURE FreeMem(p:POINTER;size:LongWord);
PROCEDURE FreeSharedMem(p:POINTER;size:LongWord);
FUNCTION SysGetMem(Size:LONGWORD):POINTER;
FUNCTION SysFreeMem(p:POINTER;size:LONGWORD):POINTER;
PROCEDURE GetAPIMem(VAR p:POINTER;size:LONGWORD);
PROCEDURE FreeAPIMem(p:POINTER;size:LONGWORD);
PROCEDURE NewSystemHeap (ID : integer);
//FUNCTION  CreateSystemHeap(Size:LONGWORD):BOOLEAN;
//PROCEDURE DestroySystemHeap;
//PROCEDURE DestroyHeap(Heap:POINTER);
{Use this rotines to synchronize heap access when a thread is killed and
 you don't know the state of the thread. This prevents heap corruption}
//PROCEDURE RequestHeapMutex;
//PROCEDURE ReleaseHeapMutex;
procedure SysCreateMutex (var Mutex : longword);
PROCEDURE SysRequestMutex (Mutex : longword);
PROCEDURE SysReleaseMutex (Mutex : longword);
procedure SysCleanupMutex (var Mutex : longword);

{use this routine to write trace messages to the sibyl VDE}
PROCEDURE Trace(CONST Value:STRING);

// Error functions
VAR ExitCode:LONGWORD;
    ErrorAdr:POINTER;
    ExitProc:POINTER;

Const RunError_NoError= 0;
      RunError_Heap   = 218;
      RunError_LOG    = 219;

PROCEDURE RunError(Code:LONGWORD);
PROCEDURE Halt(Code:LONGWORD);

//Direct memory access
PROCEDURE Move(CONST source;VAR dest;size:LongWord);
PROCEDURE FillChar(VAR dest;size:LongWord;value:byte);Assembler;
FUNCTION CompareMem(VAR Buf1,Buf2;Size:LONGWORD):BOOLEAN;

//LongJmp support
TYPE Jmp_Buf=ARRAY[0..8] OF LONGWORD;

FUNCTION SetJmp(VAR JmpBuf:Jmp_Buf):LONGWORD;
PROCEDURE LongJmp(VAR JmpBuf:Jmp_Buf;RetVal:LONGWORD);

//String functions
FUNCTION Pos(CONST item,source:STRING):BYTE;
FUNCTION Copy(CONST Source:STRING; Index,Count:INTEGER):STRING;
PROCEDURE Insert(CONST Source:STRING; VAR S:STRING; Index:INTEGER);
PROCEDURE Delete(VAR S:STRING; Index,Count:INTEGER);

FUNCTION AnsiPOS(CONST item,source:AnsiString):LONGINT;
FUNCTION AnsiPOSStr(CONST item:STRING;CONST source:AnsiString):LONGINT;
FUNCTION AnsiCopy(CONST Source:AnsiString;Index,Count:LONGINT):AnsiString;
PROCEDURE AnsiInsert(CONST Source:AnsiString; VAR S:AnsiString; Index:LONGINT);
PROCEDURE AnsiInsertStr(CONST Source:String; VAR S:AnsiString; Index:LONGINT);
PROCEDURE AnsiDelete(VAR S:AnsiString; Index,Count:LONGINT);
PROCEDURE AnsiSetLength(VAR S:AnsiString;NewLength:LONGINT);
PROCEDURE AnsiSetString(VAR S:AnsiString;Buffer:PChar;Len:LONGINT);
PROCEDURE SetLength(VAR S:String;NewLength:LONGINT);
PROCEDURE SetString(VAR S:String;Buffer:PChar;Len:LONGINT);
PROCEDURE UniqueStr(VAR S:AnsiString);


FUNCTION ToHex(l:LONGWORD):STRING;
PROCEDURE SubStr(VAR source:STRING;start,ende:Byte);
PROCEDURE UpcaseStr(VAR s:STRING);

{$IFDEF OS2}
PROCEDURE InitPM;
{$ENDIF}

//Floating point support
CONST
    rad=1;
    deg=2;
    gra=3;

VAR
    IsNotRad:BOOLEAN;
    ToRad,FromRad:EXTENDED;
    FPUResult:WORD;

PROCEDURE SetTrigMode(mode:BYTE);

PROCEDURE Default8087CW ; ASSEMBLER;

PROCEDURE Set8087CW (cw : WORD); ASSEMBLER;

FUNCTION Get8087CW : WORD; ASSEMBLER;

CONST PI=3.141592653589793240;
      HexDecimals: Array[0..15] Of Char = '0123456789ABCDEF'; { Array For creation Of hexadecimal numbers }

      Inch2mm = 25.4; // Zoll bzw. Inch in mm

{$IFDEF OS2}
      PathSeparator ='\';
      DriveSeparator =':';
{$ENDIF}
{$IFDEF Win32}
      PathSeparator ='\';
      DriveSeparator =':';
{$ENDIF}

// Class structures layout, particulary also valid for objects
TYPE pPropertyInfo = ^tPropertyInfo;
     tPropertyInfo = Record
                       PropertyInfoEnd : Pointer;    // Zeigt ans Ende von PropertyInfo
                       PropertyNameInfo: LongWord;   // Rel. Adressse zu den PropertyNames
                       Data            : byte;       // Ab hier sind die Namen der Properties gespeichert
                     End;

     PClassInfoLayout=^TClassInfoLayout;
     TClassInfoLayout=RECORD                         // in Asm: !CLASSINFO!<Nr>! PROC NEAR2
                        ClassSize:LONGWORD;          // Bytegroesse der Klasse
                        ParentGetvmtAddr:POINTER;    // Rel. Adresse auf die Funktion GetVMT des Parents
                        FieldAdress:POINTER;         // Adresse an der sich die Property-Tabelle befindet
           // Class Info following here
                        PropertyInfo  : LongWord;    // Rel. Adresse zu den PropertysInfos; In Asm: !PROPERTYINFO!<Nr>! PROC NEAR32
                        ClassName     : STRING;      // Klassennamen
           // restliche Klasseninformation
                     // Klassen Unit
                     // Fuer jede Klassenfunktion wiederholen:
                     //     Rel.Adresse der Funktion
                     //     Laenge und Namen der Funktion
                     // LongWord: 0
                     // LongWord: 0
                      END;

     PDmtLayout=^TDmtLayout;
     TDmtLayout=RECORD                               
                  NumDmts:LONGWORD;                  // Number of entries
                  { entries follow here each entry is 8 byte long
                    the first DWord contains the message id,
                    the second DWord contains the VMT index }
                END;

     PVmtLayOut=^TVmtLayOut;
     TVmtLayOut=RECORD                               // in Asm: !VMT!<Nr>! PROC NEAR2
                  Dmt:PDmtLayout;                    // Pointer to DMT
                  ClassInfo:PClassInfoLayout;        // Rel. Adresse zu der ClassInfo.
                  ClassSize:LONGWORD;                // Bytegroesse der Klasse
                  VmtSize:LONGWORD;                  // Number of entries
                  { entries follow here each entry is 4 byte long and 
                    contains the address for that VMT index }
                 END;
     TClassLayout=RECORD
                    Vmt:PVmtLayout;
                    // Object variables follow here
                  END;

{Property type codes}
TYPE
     TPropertyType=BYTE;

CONST
     PropType_Unsigned  =TPropertyType($80);
     PropType_Signed    =TPropertyType($81);
     PropType_Float     =TPropertyType($82);
     PropType_Class     =TPropertyType($83);
     PropType_String    =TPropertyType($84);
     PropType_Enum      =TPropertyType($85);
     PropType_Set       =TPropertyType($86);
     PropType_Boolean   =TPropertyType($87);
     PropType_Char      =TPropertyType($88);
     PropType_CString   =TPropertyType($89);
     PropType_ClassVar  =TPropertyType($8a);
     PropType_ProcVar   =TPropertyType($8b);
     PropType_FuncVar   =TPropertyType($8c);
     PropType_Record    =TPropertyType($8d);
     PropType_Link      =TPropertyType($8e);

{Property info record}
TYPE
    TPropertyReadWriteKind=BYTE;

CONST
    PropReadWriteKind_Illegal       = TPropertyReadWriteKind(0);
    PropReadWriteKind_VarOffset     = TPropertyReadWriteKind(1);
    PropReadWriteKind_MethodOfs     = TPropertyReadWriteKind(2);
    PropReadWriteKind_VmtIndex      = TPropertyReadWriteKind(3);

TYPE
     TPropertyReadWriteRecord=RECORD
                                    CASE Kind:TPropertyReadWriteKind OF
                                        1:(VarOffset:LONGWORD);
                                        2:(MethodAddress:POINTER);
                                        3:(VmtIndex:LONGWORD);
                              END;

TYPE TPropertyScope=Byte;

CONST
     PropScope_Published  = 8;
     PropScope_Stored     = 16;

TYPE TPropertyTypeInfo=RECORD
                             Typ:TPropertyType;
                             Size:LONGWORD;
                             PropInfo:Pointer;
                             NameTable:Pointer;
                             TypeInfo:Pointer;
                             Scope:TPropertyScope;
                             Read:TPropertyReadWriteRecord;
                             Write:TPropertyReadWriteRecord;
                       END;

{Property enumeration}
TYPE
    TPropertyEnumProc=PROCEDURE(CONST PropertyName:PString;CONST Info:TPropertyTypeInfo);

TYPE
    TObject = CLASS;
    TClass  = CLASS OF TObject;
    TObject = CLASS
      PUBLIC
            CONSTRUCTOR Create;
            DESTRUCTOR Destroy; VIRTUAL;
            PROCEDURE Free;
            CLASS FUNCTION NewInstance: TObject;
            PROCEDURE FreeInstance; VIRTUAL;
            CLASS FUNCTION InitInstance(Instance: Pointer): TObject;
            CLASS FUNCTION ClassType: TClass;                    //WD; umbauen ClassInfo???
            CLASS FUNCTION ClassName: STRING;                    //WD; gestestet; okay
            CLASS FUNCTION ClassUnit: STRING;                    //WD; gestestet; okay
            CLASS FUNCTION ClassParent: TClass;                  //WD; gestestet; okay
            CLASS FUNCTION ClassInfo: POINTER;      //conflicts with PMWIN CLASSINFO, WD; gestestet; okay
            CLASS FUNCTION ClassInfo_V30: Pointer;
//          class Function ClassInfoLayout:tClassInfoLayout;
            CLASS FUNCTION InstanceSize: LONGWORD;               //WD; gestestet; okay
            CLASS FUNCTION InheritsFrom(AClass: TClass): BOOLEAN;//WD; gestestet; okay
            FUNCTION GetPropertyTypeInfo(PropertyName:STRING;VAR Info:TPropertyTypeInfo):BOOLEAN;
            PROCEDURE EnumProperties(EnumProc:TPropertyEnumProc);
            PROCEDURE DefaultHandler(VAR Message); VIRTUAL;
            PROCEDURE DefaultFrameHandler(VAR Message); VIRTUAL;
            PROCEDURE Dispatch(VAR Message);
            PROCEDURE DispatchCommand(VAR Message;Command:LONGWORD);
            PROCEDURE FrameDispatch(VAR Message);
            CLASS FUNCTION MethodAddress(Name: STRING): POINTER; //WD; gestestet; okay
            CLASS FUNCTION VMTIndex(Name: STRING): LONGINT;      //WD; gestestet; okay
            CLASS FUNCTION MethodName(Address: POINTER): STRING; //WD; gestestet; okay
            FUNCTION FieldAddress(Name: STRING): POINTER;        //WD; gestestet; okay
    END;

type
{$M+}
    TNotifyEvent = Procedure(Sender:TObject) Of Object;
{$M-}


//TextScreen IO support
VAR
   Input,Output:TEXT;

CONST
     { CRT modes }
     BW40          = 0;            { 40x25 B/W on Color Adapter   }
     CO40          = 1;            { 40x25 Color on Color Adapter }
     BW80          = 2;            { 80x25 B/W on Color Adapter   }
     CO80          = 3;            { 80x25 Color on Color Adapter }
     Mono          = 7;            { 80x25 on Monochrome Adapter  }
     Font8x8       = 256;          { Add-in for 8x8 font          }

VAR
   WindMin: WORD;    { Window upper left coordinates  }
   WindMax: WORD;    { Window lower right coordinates }
   LastMode: Word;   { Current text mode              }
   TextAttr: BYTE;   { Current text attribute         }


{ Application - Type: Wird in im "Begin"-Statement vom Hauptprogramm gesetzt. Dieser
                      Source wird im Compiler generiert }
   ApplicationType       : BYTE;

Const cApplicationType_GUI             = 1;
      cApplicationType_Textmode_Full   = 2;
      cApplicationType_Textmode_Window = 3;

TYPE TScreenInOutClass=CLASS
         PROCEDURE WriteStr(CONST s:STRING);VIRTUAL;
         PROCEDURE WriteCStr(CONST s:CSTRING);VIRTUAL;
         PROCEDURE WriteLF;VIRTUAL;
         PROCEDURE ReadLF(VAR s:STRING);VIRTUAL;
         PROCEDURE GotoXY(x,y:BYTE);VIRTUAL;
     END;

     TPMScreenInOutClass=CLASS
         PROCEDURE WriteStr(CONST s:STRING);VIRTUAL;
         PROCEDURE WriteCStr(CONST s:CSTRING);VIRTUAL;
         PROCEDURE WriteLF;VIRTUAL;
         PROCEDURE ReadLF(VAR s:STRING);VIRTUAL;
         PROCEDURE GotoXY(x,y:BYTE);VIRTUAL;
         PROCEDURE Error;
     END;

{$IFDEF OS2}
IMPORTS
  FUNCTION WinInitializeAPI(flOptions:LONGWORD):LONGWORD;
                         APIENTRY;             'PMWIN' index 763;
  FUNCTION WinTerminateAPI(ahab:LONGWORD):BOOLEAN;
                         APIENTRY;             'PMWIN' index 888;
  FUNCTION WinCreateMsgQueueAPI(ahab:LONGWORD;cmsg:LONGINT):LONGWORD;
                         APIENTRY;             'PMWIN' index 716;
  FUNCTION WinDestroyMsgQueueAPI(ahmq:LONGWORD):BOOLEAN;
                         APIENTRY;             'PMWIN' index 726;
END;
{$ENDIF}

VAR ScreenInOut:TScreenInOutClass;

//File I/O support
TYPE
{$IFDEF OS2}
      {Extended attributes information returned by GetEAInfo}
      PFEADATA=^TFEADATA;
      TFEADATA=ARRAY[0..65535] OF BYTE;
      PHOLDFEA=^THOLDFEA;
      THOLDFEA=RECORD
                     {oNextEntryOffset:LONGWORD; // new field}
                     fEA:BYTE;                  // Flag byte
                     cbName:BYTE;
                     cbValue:WORD;
                     szName:CSTRING;
                     aValue:PFEADATA;
                     Deleted:BOOLEAN;           //true to delete EA on write
                     next:PHOLDFEA;
      END;
{$ENDIF}

      P_FileBuffer=^T_FileBuffer;
      T_FileBuffer=ARRAY[0..MaxLongInt-1] OF BYTE; {handled dynamically}

      FileRec = RECORD
                      Handle          : LongWord;     {FileHandle            }
                      RecSize         : LongWord;     {Record size           }
                      Name            : STRING;       {(Long) file name      }
                      {$IFDEF OS2}
                      EAS             : PHOLDFEA;     {extended attributes   }
                      {$ELSE}
                      EAS             : POINTER;      {Unused                }
                      {$ENDIF}
                      Mode            : LONGWORD;     {Current file mode     }
                      Reserved        : POINTER;      {for private extensions}
                      Block           : LONGWORD;     {current block in file }
                      LBlock          : LONGWORD;     {Last block in file    }
                      Offset          : LONGWORD;     {Current offset in Block}
                      LOffset         : LONGWORD;     {Last Offset in LBlock }
                      Changed         : LONGBOOL;     {TRUE if Block has changed}
                      Buffer          : P_FileBuffer; {I/O Buffer            }
                      MaxCacheMem     : LONGWORD;     {Size of I/O Buffer    }
                      Flags           : LONGWORD;     {Assign flags $6666    }
                      Reserved1       : WORD;         {dont use              }
                      BufferBytes     : WORD;         {dont use              }
                      {312 byte til here}
                END;

VAR
   InOutRes:LONGWORD;

FUNCTION IOResult: Integer;
{$IFDEF OS2}
FUNCTION OS2Result: Integer;
{$ENDIF}

{$IFDEF OS2}
CONST
   //Sharing options - use this way: FileMode:=(FileMode AND 15) OR Value;
   fmDenyRead   = $30;   {deny read access by other processes         }
   fmDenyWrite  = $20;   {deny write access by other processes        }
   fmDenyNone   = $40;   {deny neither read nor write                 }
   fmDenyBoth   = $10;   {deny both read and write access (standard)  }

   {FileMode values}
   fmClosed     = 0;
   fmInput      = 0 OR fmDenyWrite; {Read only                                   }
   fmOutput     = 1 OR fmDenyRead;  {Write only                                  }
   fmInOut      = 2 OR fmDenyNone;  {allow both read and write access (standard) }
{$ENDIF}
{$IFDEF Win32}
CONST
   {FileMode values}
   fmDenyRead   = $00000002; {deny read access by other processes         }
   fmDenyWrite  = $00000001; {deny write access by other processes        }
   fmDenyNone   = $00000003; {deny neither read nor write                 }
   fmDenyBoth   = $0;        {deny both read and write access (standard)  }

   fmClosed     = 0;
   fmInput      = $80000000 or fmDenyWrite; {Read only                                   }
   fmOutput     = $40000000 or fmDenyRead;  {Write only                                  }
   fmInOut      = $C0000000 or fmDenyNone;  {allow both read and write access (standard) }
{$ENDIF}

CONST
   {Seek Origin Constants}
   Seek_Begin     = 0;   //Seek from beginning of file
   Seek_Current   = 1;   //Seek from current position of file
   Seek_End       = 2;   //Seek from end of file

VAR
   FileMode:LONGWORD;   {file mode for both reset and rewrite}
   SeekMode:LONGWORD;   {seek mode for seek                  }

TYPE TextFile=TEXT;

PROCEDURE Assign(VAR f:FILE;CONST s:STRING);
PROCEDURE AssignFile(VAR f:FILE;CONST s:STRING);
PROCEDURE Rewrite(VAR f:FILE;recsize:LONGWORD);
PROCEDURE Reset(VAR f:FILE;recsize:LONGWORD);
PROCEDURE Close(VAR f:FILE);
PROCEDURE CloseFile(VAR f:FILE);
PROCEDURE BlockRead(VAR f:file;var Buf;Count:LongWord;VAR result:LONGWORD);
PROCEDURE BlockWrite(VAR f:file;VAR Buf;Count:LongWord;VAR result:LONGWORD);
PROCEDURE Rename(VAR f:file;NewName:String);
PROCEDURE Truncate(VAR f:FILE);
PROCEDURE Append(VAR f:Text);
PROCEDURE Seek(VAR f:FILE;n:LONGINT);
FUNCTION SeekEof(VAR F :Text):Boolean;
FUNCTION SeekEoln(VAR F:Text):Boolean;
FUNCTION FilePos(VAR f:FILE):LONGWORD;
FUNCTION FileSize(VAR f:FILE):LONGWORD;
FUNCTION Eof(VAR f:FILE):BOOLEAN;
FUNCTION Eoln(VAR F:Text):Boolean;
PROCEDURE Erase(VAR f:FILE);
PROCEDURE SetFileBuf(VAR f:FILE;VAR Buf;BufSize:LONGWORD);
PROCEDURE SetTextBuf(VAR f:TEXT;VAR Buf;BufSize:LONGWORD);

//Funtions for manipulating EAS
//EAS will be written with a DosClose call, but the file should then
//not be occupied by another process or thread, Close must have
//exclusive access to the file or EA setting will fail ! When using
//the standard filemode with fmdenyBoth this is save
{$IFDEF OS2}
FUNCTION GetEAData(VAR f:FILE):PHOLDFEA;
PROCEDURE SetEAData(VAR f:FILE;EAData:PHOLDFEA);
PROCEDURE DeleteEAData(VAR f:FILE);
{$ENDIF}

//Functions for manipulating directories
PROCEDURE ChDir(CONST path:STRING);
PROCEDURE GetDir(drive:byte;VAR path:STRING);
PROCEDURE RmDir(CONST dir:STRING);
PROCEDURE MkDir(CONST dir:STRING);

FUNCTION PARAMSTR(item:Byte):STRING;
FUNCTION PARAMCOUNT:Byte;

//Exception Management
{$IFDEF OS2}
  {
   * ExceptionReportRecord
   *
   * This structure contains machine independant information about an
   * exception/unwind. No system exception will ever have more than
   * EXCEPTION_MAXIMUM_PARAMETERS parameters. User exceptions are not
   * bound to this limit.
   }
CONST
    EXCEPTION_MAXIMUM_PARAMETERS =4;  { Enough for all system exceptions. }

TYPE
    PEXCEPTIONREPORTRECORD=^EXCEPTIONREPORTRECORD;
    EXCEPTIONREPORTRECORD=RECORD
             ExceptionNum:LONGWORD;     { exception number }
             fHandlerFlags:LONGWORD;
             NestedExceptionReportRecord:PEXCEPTIONREPORTRECORD;
             ExceptionAddress:POINTER;
             cParameters:LONGWORD; { Size of Exception Specific Info }
             ExceptionInfo:ARRAY[0..EXCEPTION_MAXIMUM_PARAMETERS] OF LONGWORD;
    END;

    {
     * ExceptionRegistrationRecord
     *
     * These are linked together to form a chain of exception handlers that
     * will be dispatched to upon receipt of an exception.
    }
    _ERR=POINTER; {Exception handler entry address}

    SysException=Class;  {forward definition}

    PEXCEPTIONREGISTRATIONRECORD=^EXCEPTIONREGISTRATIONRECORD;
    EXCEPTIONREGISTRATIONRECORD=RECORD
              prev_structure:PEXCEPTIONREGISTRATIONRECORD;
              ExceptionHandler:_ERR;
              {this fields are new !!}
              ObjectType:SysException;
              jmpWorker:jmp_buf;
    END;

    PFPEG=^FPREG;
    FPREG=RECORD {pack 1}
               losig:LONGWORD;
               hisig:LONGWORD;
               signexp:WORD;
          END;

    PCONTEXTRECORD=^CONTEXTRECORD;
    CONTEXTRECORD=RECORD
                  ContextFlags:LONGWORD;
                  ctx_env:ARRAY[0..6] OF LONGWORD;
                  ctx_stack:ARRAY[0..7] OF FPREG;
                  ctx_SegGs:LONGWORD;
                  ctx_SegFs:LONGWORD;
                  ctx_SegEs:LONGWORD;
                  ctx_SegDs:LONGWORD;
                  ctx_RegEdi:LONGWORD;
                  ctx_RegEsi:LONGWORD;
                  ctx_RegEax:LONGWORD;
                  ctx_RegEbx:LONGWORD;
                  ctx_RegEcx:LONGWORD;
                  ctx_RegEdx:LONGWORD;
                  ctx_RegEbp:LONGWORD;
                  ctx_RegEip:LONGWORD;
                  ctx_SegCs:LONGWORD;
                  ctx_EFlags:LONGWORD;
                  ctx_RegEsp:LONGWORD;
                  ctx_SegSs:LONGWORD;
           END;
{$ENDIF}

{$IFDEF Win32}
//Exception Management

  { Exceptions }
CONST
     SIZE_OF_80387_REGISTERS      = 80;

TYPE
    PFLOATING_SAVE_AREA=^FLOATING_SAVE_AREA;
    FLOATING_SAVE_AREA=RECORD
                             ControlWord:LONGWORD;
                             StatusWord:LONGWORD;
                             TagWord:LONGWORD;
                             ErrorOffset:LONGWORD;
                             ErrorSelector:LONGWORD;
                             DataOffset:LONGWORD;
                             DataSelector:LONGWORD;
                             RegisterArea:ARRAY[0..SIZE_OF_80387_REGISTERS-1] OF BYTE;
                             Cr0NpxState:LONGWORD;
    END;

TYPE
    PCONTEXT=^CONTEXT;
    CONTEXT=RECORD
                  ContextFlags:LONGWORD;
                  Dr0:LONGWORD;
                  Dr1:LONGWORD;
                  Dr2:LONGWORD;
                  Dr3:LONGWORD;
                  Dr6:LONGWORD;
                  Dr7:LONGWORD;

                  FloatSave:FLOATING_SAVE_AREA;

                  SegGs:LONGWORD;
                  SegFs:LONGWORD;
                  SegEs:LONGWORD;
                  SegDs:LONGWORD;

                  Edi:LONGWORD;
                  Esi:LONGWORD;
                  Ebx:LONGWORD;
                  Edx:LONGWORD;
                  Ecx:LONGWORD;
                  Eax:LONGWORD;

                  Ebp:LONGWORD;
                  Eip:LONGWORD;
                  SegCs:LONGWORD;
                  EFlags:LONGWORD;
                  Esp:LONGWORD;
                  SegSs:LONGWORD;
    END;

CONST
     EXCEPTION_CONTINUABLE         = 0; // Continuable exception
     EXCEPTION_NONCONTINUABLE      = 1; // Noncontinuable exception
     EXCEPTION_MAXIMUM_PARAMETERS  =15; // maximum number of exception parameters

TYPE
    PEXCEPTION_RECORD=^EXCEPTION_RECORD;
    EXCEPTION_RECORD=RECORD
                           ExceptionCode:LONGWORD;
                           ExceptionFlags:LONGWORD;
                           ExceptionRecord:PEXCEPTION_RECORD;
                           ExceptionAddress:POINTER;
                           NumberParameters:LONGWORD;
                           ExceptionInformation:ARRAY[0..EXCEPTION_MAXIMUM_PARAMETERS-1] OF LONGWORD;
    END;

TYPE
    PEXCEPTION_POINTERS=^EXCEPTION_POINTERS;
    EXCEPTION_POINTERS=RECORD
                             ExceptionRecord:PEXCEPTION_RECORD;
                             ContextRecord:PCONTEXT;
    END;

TYPE
  SysException=CLASS;

  PExcptInfo=^TExcptInfo;
  TExcptInfo=RECORD
                     TryAddr:POINTER;
                     ExcptAddr:POINTER;
                     OldEBP,OldESP:LONGWORD;
                     OldFPUControl:LONGWORD;
                     ExcptObject:SysException;
                     ThreadId:LONGWORD;
                     Next:PExcptInfo;
                     Last:PExcptInfo;
  END;
{$ENDIF}

  { Exceptions }
  //base exception record - derive all new exceptions from that !
  SysException = CLASS(TObject)
      PRIVATE
            FMessage: PString;
            FHelpContext:LONGINT;
            FUNCTION GetMessage: STRING;
            PROCEDURE SetMessage(CONST Value: STRING);
      PUBLIC
            {$IFDEF OS2}
            ReportRecord:EXCEPTIONREPORTRECORD;
            {$ENDIF}
            {$IFDEF Win32}
            ReportRecord:EXCEPTION_RECORD;
            {$ENDIF}
            ExcptNum:LONGWORD;
            CameFromRTL:BOOLEAN;
            Nested:BOOLEAN;
            ExcptAddr:POINTER;
            RTLExcptAddr:POINTER;
            {$IFDEF OS2}
            RegistrationRecord:EXCEPTIONREGISTRATIONRECORD;
            ContextRecord:CONTEXTRECORD;
            {$ENDIF}
            {$IFDEF Win32}
            ContextRecord:CONTEXT;
            {$ENDIF}

            CONSTRUCTOR Create(CONST Msg: STRING);
            DESTRUCTOR Destroy;OVERRIDE;
      PUBLIC
            PROPERTY HelpContext:LONGINT read FHelpContext write FHelpContext;
            PROPERTY Message:STRING read GetMessage write SetMessage;
            PROPERTY  MessagePtr: PString read FMessage;
  END;

  //General exception class
  SysExceptClass = class OF SysException;

  //Software generated excpetions
  EProcessTerm = CLASS(SysException);

  //Hardware generated exceptions
  EProcessorException=CLASS(SysException);  //Basisklasse fuer CPU Ausnahmen
  EFault = CLASS(EProcessorException);      //Basisklasse fuer Faults
  EGPFault = CLASS(EFault);                 //Schutzverletzung (GPF)
  EStackFault = CLASS(EFault);              //Stackfehler
  EPageFault = CLASS(EFault);               //Pagefehler
  EInvalidOpCode = CLASS(EFault);           //ungueltiger Opcode
  EBreakpoint = CLASS(EProcessorException); //Haltepunkt
  ESingleStep = CLASS(EProcessorException); //Einzelschritt

  //Memory exceptions
  EOutOfMemory = CLASS(SysException);       //Speichermangel
  EInvalidPointer = CLASS(SysException);    //ungueltiger Zeiger
  EInvalidHeap    = CLASS(SysException);    //ungueltiger Heap

  //Input/Output exceptions
  EInOutError = CLASS(SysException)         //Ein-Ausgabe Fehler
    PUBLIC
      ErrorCode: Integer;
  END;
  EFileNotFound=CLASS(EInOutError);         //Datei nicht gefunden
  EInvalidFileName=CLASS(EInOutError);      //Ungueltiger Dateiname
  ETooManyOpenFiles=CLASS(EInOutError);     //zu viele offene Dateien
  EAccessDenied=CLASS(EInOutError);         //Dateizugriff verweigert
  EEndOfFile=CLASS(EInOutError);            //Dateiende erreicht
  EDiskFull=CLASS(EInOutError);             //Diskette//Platte voll
  EInvalidInput=CLASS(EInOutError);         //ungueltige Eingabe

  //Integer math exceptions
  EIntError = CLASS(SysException);          //Basisklasse Integer-Ausnahmen
  EDivByZero = CLASS(EIntError);            //Division durch 0
  ERangeError = CLASS(EIntError);           //Bereichsgrenzenfehler
  EIntOverflow = CLASS(EIntError);          //Integer-Ueberlauf

  //Floating point math exceptions
  EMathError = CLASS(SysException);         //Basisklasse FPU Ausnahmen
  EInvalidOp = CLASS(EMathError);           //ungueltiger FPU Opcode
  EZeroDivide = CLASS(EMathError);          //Division durch 0
  EOverflow = CLASS(EMathError);            //FPU Ueberlauf
  EUnderflow = CLASS(EMathError);           //FPU Unterlauf

  //type cast exceptions
  EInvalidCast = CLASS(SysException);

  //Silent exceptions
  EAbort = CLASS(SysException);

PROCEDURE Abort;
                   
//PM Routines
VAR
    DllModule:LONGWORD;
    DllTerminating:LONGWORD;
    DllInitTermResult:LONGWORD;
    ModuleCount:BYTE;
    RaiseIOError:BOOLEAN;

{$IFDEF OS2}
FUNCTION WinInitialize(flOptions:LONGWORD):LONGWORD;
FUNCTION WinTerminate(ahab:LONGWORD):BOOLEAN;
FUNCTION WinCreateMsgQueue(ahab:LONGWORD;cmsg:LONGINT):LONGWORD;
FUNCTION WinDestroyMsgQueue(ahmq:LONGWORD):BOOLEAN;
PROCEDURE SelToFlat(VAR p:POINTER);
{$ENDIF}
PROCEDURE MainDispatchLoop;

//Variant support
FUNCTION VarType(CONST v:VARIANT):WORD;Assembler;
FUNCTION VarIsNull(CONST v:VARIANT):BOOLEAN;Assembler;

//Variant type constants (also in BASIS.PAS)
CONST
     VarEmpty      = $0000;
     VarNull       = $0001;
     VarSmallInt   = $0002;
     VarInteger    = $0003;
     VarLongint    = $0004;
     VarSingle     = $0005;
     VarDouble     = $0006;
     VarExtended   = $0007;
     VarBoolean    = $0008;
     VarByte       = $0009;
     VarWord       = $000a;
     VarLongWord   = $000b;
     VarChar       = $000c;
     VarComp       = $000d;
     VarCurrency   = $000e;
     VarString     = $0100;

     VarTypeMask   = $0fff;

TYPE EVariantError=CLASS(SysException);

     //Variant Record
     TVarData=RECORD
                    VType:WORD;
                    CASE Integer OF
                       0:(Data:ARRAY[1..5] OF WORD;reserved1,reserved2:WORD);
                       VarSmallInt:(VSmallInt:ShortInt);
                       VarInteger:(VInteger:Integer);
                       VarLongint:(VLongInt:LONGINT);
                       VarSingle:(VSingle:Single);
                       VarDouble:(VDouble:Double);
                       VarExtended:(VExtended:Extended);
                       VarComp:(VComp:Comp);
                       VarBoolean:(VBoolean:Boolean);
                       VarByte:(VByte:BYTE);
                       VarWord:(VWord:Word);
                       VarLongWord:(VLongWord:LongWord);
                       VarChar:(VChar:Char);
                       VarString:(VString:Pointer);
                       VarCurrency:(VCurrency:Currency);
     END;

//Open array support
CONST
     vtInteger    =0;
     vtBoolean    =1;
     vtChar       =2;
     vtExtended   =3;
     vtString     =4;
     vtPointer    =5;
     vtPChar      =6;
     vtObject     =7;
     vtClass      =8;
     vtWideChar   =9;
     vtPWideChar  =10;
     vtAnsiString =11;
     vtCurrency   =12;
     vtVariant    =13;

TYPE
     //Open Array Record
     TVarRec=RECORD
                   CASE VType:BYTE OF
                       vtInteger:(VInteger:LONGINT);
                       vtBoolean:(VBoolean:Boolean);
                       vtChar:(VChar:Char);
                       vtExtended:(VExtended:^Extended);
                       vtString:(VString:^ShortString);
                       vtPointer:(VPointer:Pointer);
                       vtPChar:(VPChar:PChar);
                       vtObject:(VObject:TObject);
                       vtClass:(VClass:TClass);
                       //vtWideChar:(VWideChar:WideChar);
                       //vtPWideChar:(VPWideChar:PWideChar);
                       vtAnsiString:(VAnsiString:Pointer);
                       vtCurrency:(VCurrency:^Currency);
                       vtVariant:(VVariant:^Variant);
             END;

//Named resource management
Function GenUniqueResName(iResID : LongInt; iTyp : String) : String;
FUNCTION FindIconRes(CONST Name:STRING;VAR DataLen:LONGWORD):Pointer;
FUNCTION FindBitmapRes(CONST Name:STRING;VAR DataLen:LONGWORD):Pointer;
FUNCTION FindPointerRes(CONST Name:STRING;VAR DataLen:LONGWORD):Pointer;
FUNCTION FindStringTableRes(CONST Name:STRING;VAR DataLen:LONGWORD):Pointer;
FUNCTION GetStringTableEntry(CONST Table:STRING;Ident:WORD):STRING;

//Thread support
TYPE TThreadFunc=FUNCTION(Param:POINTER):LONGINT;

     EAssertionFailed=Class(SysException);

CONST //BeginThread options
      {$IFDEF OS2}
      THREAD_SUSPENDED     =1;
      {$ENDIF}
      {$IFDEF Win32}
      THREAD_SUSPENDED     =4;
      {$ENDIF}

FUNCTION GetThreadId:LONGWORD;
FUNCTION GetProcessId:LongWord;
FUNCTION BeginThread(SecurityAttrs:POINTER;StackSize:LONGWORD;
                     ThreadFunc:TThreadFunc;Parameter:Pointer;
                     Options:LONGWORD;VAR id:LONGWORD):LONGWORD;
PROCEDURE KillThread(atid:LONGWORD);
PROCEDURE EndThread(ExitCode:LONGINT);

FUNCTION IsConsole:BOOLEAN;
FUNCTION IsLibrary:BOOLEAN;

FUNCTION AppHandle:LONGWORD;
FUNCTION MainAppHandle:LONGWORD;
FUNCTION AppQueueHandle:LONGWORD;
FUNCTION MainAppQueueHandle:LONGWORD;
FUNCTION HInstance:LONGWORD;

{$IFDEF SPDLL30}
Function GetVMTCall(p : Pointer) : Pointer;
// Ermittelt die Position der VMT-Tabelle
{$ENDIF}

Const INVALID_HANDLE_VALUE  = -1;

type ULONG    = LONGWORD;
     PULONG   = ^ULONG;
     USHORT   = WORD;
     PUSHORT  = ^USHORT;
     SHORT    = INTEGER;
     PSHORT   = ^SHORT;
     UCHAR    = BYTE;
     PUCHAR   = ^UCHAR;
     PBYTE    = ^BYTE;
     LONG     = LONGINT;
     PLONG    = ^LONG;

{ General System Type. System constants apply To SystemMetrics method }
     tSystemMetrics = LongInt;

type pPoint = ^tPoint;
{$M+}
     tPoint = record
       X,Y:LongInt;
     end;
{$M-}

     pRect = ^tRect;
{$M+}
     tRect = record
       Case LongInt Of
         0: (Left,Bottom,Right,Top:LongInt);
         1: (LeftBottom,RightTop:TPoint);
     end;
{$M-}

    PSize=^TSize;
{$M+}
    TSize=Record
       CX,CY:LongInt;
    End;
{$M-}

IMPLEMENTATION



TYPE VIOMODEINFO=RECORD {pack 1}
                     cb:WORD;
                     fbType:BYTE;
                     color:BYTE;
                     col:WORD;
                     row:WORD;
                     hres:WORD;
                     vres:WORD;
                     fmt_ID:BYTE;
                     attrib:BYTE;
                     buf_addr:LONGWORD;
                     buf_length:LONGWORD;
                     full_length:LONGWORD;
                     partial_length:LONGWORD;
                     ext_data_addr:POINTER;
                END;

{$IFDEF OS2}
Imports
  Function VioScrollUpProc(usTopRow,usLeftCol,usBotRow,usRightCol,cbLines:LONGWORD;VAR pCell;ahvio:LONGWORD):WORD;
                         APIENTRY;             'EMXWRAP' index 107;
  Function VioGetCurPosProc(VAR pusRow,pusColumn:WORD; ahvio:LongWord):WORD;
                         APIENTRY;             'EMXWRAP' index 109;
  Function VioSetCurPosProc(usRow,usColumn, ahvio:LONGWORD):WORD;
                         APIENTRY;             'EMXWRAP' index 115;
  Function VioReadCellStrProc(VAR pchCellStr;VAR pcb:WORD;usRow,usColumn:LONGWORD;ahvio:LONGWORD):WORD;
                         APIENTRY;             'EMXWRAP' index 124;
  Function VioGetModeProc(VAR apvioModeInfo:VIOMODEINFO; ahvio:Longword):WORD;
                         APIENTRY;             'EMXWRAP' index 121;
End;
{$ENDIF}

{$IFDEF SPDLL30}
Function GetVMTCall(p : Pointer) : Pointer;

Begin
  asm
    MOV     EDI, p
    CALLN32 EDI             // Die Funktion GETVMT des Parents aufrufen
    MOV     Result, EAX
  end;
End;
{$ENDIF}

Function GetClassParent(ci : PClassInfoLayout) : PVmtLayOut;

BEGIN
  Result:=nil;
{$IFDEF SPDLL30W32}
  ASM
    MOV EDI,ci
    CMP EDI,0
    JE !ClassParent_NoInfo
    ADD EDI,4              //get Class info pointer
    MOV EAX, [EDI]
    CMP EAX,0
    JE !ClassParent_NoInfo
    ADD EDI, EAX
    CALLN32 EDI            //Ermittlung der VMT-Tabelle --> EAX (pVMTLayOut)
    CMP EAX,0
    JE !ClassParent_NoInfo
    MOV Result, EAX        //Get Parent Class pointer
!ClassParent_NoInfo:
  END;
{$ENDIF}                 // SPDLL 30
{$IFDEF SPDLL30OS2}
  ASM
    MOV EDI,ci             //get Class info pointer
    MOV EAX,[EDI+4]        //Get Parent Class pointer
    CMP EAX,0
    JE !ClassParent_NoInfo
    CALLN32 EAX            //Ermittlung der VMT-Tabelle --> EAX (pVMTLayOut)
    CMP EAX,0
    JE !ClassParent_NoInfo
!ClassParent_NoInfo:
    MOV Result,EAX
  END;
{$ENDIF}
End;

PROCEDURE Assertion(Expression:Boolean;Const Msg:String;line:LongWord;
                    Const FileName:String);
Var s:String;
Begin
     If not Expression Then
     Begin
          If Msg='' Then s:='Assertion failed'
          Else s:=Msg;
          s:=s+#13#10+'in '+FileName+' ('+ToStr(Line)+')';
          Raise EAssertionFailed.Create(s);
     End;
End;

VAR AppHandleIntern,AppQueueHandleIntern:LONGWORD;

FUNCTION MainAppHandle:LONGWORD;
BEGIN
     result:=AppHandleIntern;
END;

FUNCTION MainAppQueueHandle:LONGWORD;
BEGIN
     result:=AppQueueHandleIntern;
END;

{$IFDEF OS2}
FUNCTION WinQueryAnchorBlock(ahwnd:LONGWORD):LONGWORD;
                          APIENTRY;           external 'PMWIN' index 800;

FUNCTION WinQueryActiveWindow(hwndDesktop:LONGWORD):LONGWORD;
                          APIENTRY;           external 'PMWIN' index 799;

CONST
     HWND_DESKTOP           =1;
{$ENDIF}

FUNCTION AppHandle:LONGWORD;
{$IFDEF OS2}
VAR id:LONGINT;
{$ENDIF}
BEGIN
     result:=AppHandleIntern;
     {$IFDEF OS2}
     ASM
        MOV EDI,$0c
        db $64
        MOV EBX,[EDI]          //MOV EBX,FS:[EDI]
        MOV EBX,[EBX]          //get thread ID
        DEC EBX
        MOV id,EBX
     END;

     IF id>0 THEN IF ApplicationType=cApplicationType_GUI THEN
     BEGIN
          result:=WinQueryAnchorBlock(HWND_DESKTOP);
          IF result=0 THEN result:=WinQueryAnchorBlock(WinQueryActiveWindow(HWND_DESKTOP));
          IF result=0 THEN result:=AppHandleIntern;
     END;
     {$ENDIF}
END;

//Thread information block (TIB)
TYPE
    PTIB2=^TIB2;
    TIB2=RECORD
              tib2_ultid:LONGWORD;             { Thread I.D. }
              tib2_ulpri:LONGWORD;             { Thread priority }
              tib2_version:LONGWORD;           { Version number for this structure }
              tib2_usMCCount:WORD;        { Must Complete count }
              tib2_fMCForceFlag:WORD;     { Must Complete force flag }
         END;

    PTIB=^TIB;
    TIB=RECORD
              tib_pexchain:POINTER;     { Head of exception handler chain }
              tib_pstack:POINTER;       { Pointer to base of stack }
              tib_pstacklimit:POINTER;  { Pointer to end of stack }
              tib_ptib2:PTIB2;          { Pointer to system specific TIB }
              tib_version:LONGWORD;        { Version number for this TIB structure }
              tib_ordinal:LONGWORD;        { Thread ordinal number        }
        END;


//Process Information Block (PIB)
TYPE
    PPIB=^PIB;
    PIB=RECORD
             pib_ulpid:LONGWORD;          { Process I.D. }
             pib_ulppid:LONGWORD;         { Parent process I.D. }
             pib_hmte:LONGWORD;           { Program (.EXE) module handle }
             pib_pchcmd:PChar;         { Command line pointer }
             pib_pchenv:PChar;         { Environment pointer }
             pib_flstatus:LONGWORD;       { Process' status bits }
             pib_ultype:LONGWORD;         { Process' type code }
       END;


{$IFDEF OS2}
FUNCTION DosGetInfoBlocks(VAR pptib:PTIB;VAR pppib:PPIB):LONGWORD;
                    APIENTRY;    external 'DOSCALLS' index 312;

FUNCTION WinQueueFromId(ahab:LONGWORD;idPid:LONGWORD;idTid:LONGWORD):LONGWORD;
                    APIENTRY;    external 'PMWIN' index 993;
{$ENDIF}

FUNCTION AppQueueHandle:LONGWORD;
{$IFDEF OS2}
VAR tib:PTIB;
    pib:PPIB;
{$ENDIF}
BEGIN
     result:=AppQueueHandleIntern;

     {$IFDEF OS2}
     tib:=NIL;
     pib:=NIL;
     DosGetInfoBlocks(tib,pib);
     IF ((tib<>NIL)AND(tib^.tib_ptib2<>NIL)AND(pib<>NIL)) THEN
       IF tib^.tib_ptib2^.tib2_ultid>1 THEN //not for main thread
     BEGIN
          result:=WinQueueFromId(AppHandle,pib^.pib_ulpid,tib^.tib_ptib2^.tib2_ultid);
          IF result=0 THEN result:=AppQueueHandleIntern;
     END;
     {$ENDIF}
END;

FUNCTION HInstance:LONGWORD;
BEGIN
     result:=AppHandle;
END;

//Currency constants
CONST ToCurrency:Extended=10000;
      FromCurrency:Extended=0.0001;

//Variant support

FUNCTION Variant2Str(CONST v:VARIANT):STRING;
VAR
    p:POINTER;
    s:^SINGLE ABSOLUTE p;
    e:^EXTENDED ABSOLUTE p;
    d:^DOUBLE ABSOLUTE p;
    si:^SHORTINT ABSOLUTE p;
    i:^INTEGER ABSOLUTE p;
    li:^LONGINT ABSOLUTE p;
    b:^BYTE ABSOLUTE p;
    w:^WORD ABSOLUTE p;
    co:^COMP ABSOLUTE p;
    cu:^Currency ABSOLUTE p;
    lw:^LONGWORD ABSOLUTE p;
    bo:^BOOLEAN ABSOLUTE p;
    c:^CHAR ABSOLUTE p;
BEGIN
     p:=@v;
     inc(p,2);
     CASE VarType(v) AND VarTypeMask OF
        VarEmpty:result:='';
        VarNull:Raise EVariantError.Create('Access to invalid variant variable');
        VarSmallInt:STR(si^,result);
        VarInteger:STR(i^,result);
        VarLongint:STR(li^,result);
        VarSingle:STR(s^,result);
        VarDouble:STR(d^,result);
        VarExtended:STR(e^,result);
        VarComp:STR(co^,result);
        VarCurrency:STR(cu^,result);
        VarBoolean:IF bo^ THEN result:='TRUE' ELSE result:='FALSE';
        VarByte:STR(b^,result);
        VarWord:STR(w^,result);
        VarLongWord:STR(lw^,result);
        VarChar:result:=c^;
        VarString:
        BEGIN
             ASM
                MOV EAX,v
                ADD EAX,2
                PUSH EAX                     //Ansi string
                PUSH DWORD PTR result        //result buffer address
                PUSHL 255
                CALLN32 SYSTEM.!AssignAnsi2Str
             END;
        END;
     END; {case}
END;

FUNCTION Variant2CStr(CONST v:VARIANT):CSTRING;
BEGIN
     result:=Variant2Str(v);
END;

FUNCTION Variant2AnsiStr(CONST v:VARIANT):AnsiString;
BEGIN
     IF VarType(v) AND VarTypeMask=VarString THEN
     BEGIN
          ASM
             MOV EAX,v
             ADD EAX,2
             PUSH EAX
             MOV EAX,result
             PUSH EAX
             CALLN32 SYSTEM.!AnsiCopy
          END;
     END
     ELSE result:=Variant2Str(v);
END;




FUNCTION Variant2LongInt(CONST v:VARIANT):LONGINT;
VAR
    p:POINTER;
    s:^SINGLE ABSOLUTE p;
    e:^EXTENDED ABSOLUTE p;
    d:^DOUBLE ABSOLUTE p;
    si:^SHORTINT ABSOLUTE p;
    i:^INTEGER ABSOLUTE p;
    li:^LONGINT ABSOLUTE p;
    b:^BYTE ABSOLUTE p;
    w:^WORD ABSOLUTE p;
    lw:^LONGWORD ABSOLUTE p;
    bo:^BOOLEAN ABSOLUTE p;
    c:^CHAR ABSOLUTE p;
    co:^COMP ABSOLUTE p;
    cu:^Currency ABSOLUTE p;
    ss:STRING;
    cc:INTEGER;
BEGIN
     p:=@v;
     inc(p,2);
     CASE VarType(v) AND VarTypeMask OF
        VarEmpty:result:=0;
        VarNull:Raise EVariantError.Create('Access to invalid variant variable');
        VarSmallInt:result:=si^;
        VarInteger:result:=i^;
        VarLongint:result:=li^;
        VarSingle:result:=s^;
        VarDouble:result:=d^;
        VarExtended:result:=e^;
        VarComp:result:=co^;
        VarCurrency:result:=cu^;
        VarBoolean:IF bo^ THEN result:=1 ELSE result:=0;
        VarByte:result:=b^;
        VarWord:result:=w^;
        VarLongWord:result:=lw^;
        VarChar:result:=ord(c^);
        VarString:
        BEGIN
             ASM
                MOV EAX,v
                ADD EAX,2
                PUSH EAX            //Ansi string
                LEA EAX,ss
                PUSH EAX
                PUSHL 255
                CALLN32 SYSTEM.!AssignAnsi2Str
             END;
             VAL(ss,result,cc);
             IF cc<>0 THEN Raise EVariantError.Create('Invalid numeric format');
        END;
     END; {case}
END;

FUNCTION Variant2LongWord(CONST v:VARIANT):LONGWORD;
VAR
    p:POINTER;
    s:^SINGLE ABSOLUTE p;
    e:^EXTENDED ABSOLUTE p;
    d:^DOUBLE ABSOLUTE p;
    si:^SHORTINT ABSOLUTE p;
    i:^INTEGER ABSOLUTE p;
    li:^LONGINT ABSOLUTE p;
    b:^BYTE ABSOLUTE p;
    w:^WORD ABSOLUTE p;
    lw:^LONGWORD ABSOLUTE p;
    bo:^BOOLEAN ABSOLUTE p;
    c:^CHAR ABSOLUTE p;
    co:^COMP ABSOLUTE p;
    cu:^Currency ABSOLUTE p;
    ss:STRING;
    cc:INTEGER;
BEGIN
     p:=@v;
     inc(p,2);
     CASE VarType(v) AND VarTypeMask OF
        VarEmpty:result:=0;
        VarNull:Raise EVariantError.Create('Access to invalid variant variable');
        VarSmallInt:result:=si^;
        VarInteger:result:=i^;
        VarLongint:result:=li^;
        VarSingle:result:=s^;
        VarDouble:result:=d^;
        VarExtended:result:=e^;
        VarComp:result:=co^;
        VarCurrency:result:=cu^;
        VarBoolean:IF bo^ THEN result:=1 ELSE result:=0;
        VarByte:result:=b^;
        VarWord:result:=w^;
        VarLongWord:result:=lw^;
        VarChar:result:=ord(c^);
        VarString:
        BEGIN
             ASM
                MOV EAX,v
                ADD EAX,2
                PUSH EAX            //Ansi string
                LEA EAX,ss
                PUSH EAX
                PUSHL 255
                CALLN32 SYSTEM.!AssignAnsi2Str
             END;
             VAL(ss,result,cc);
             IF cc<>0 THEN Raise EVariantError.Create('Invalid numeric format');
        END;
     END; {case}
END;

FUNCTION Variant2Extended(CONST v:VARIANT):EXTENDED;
VAR
    p:POINTER;
    s:^SINGLE ABSOLUTE p;
    e:^EXTENDED ABSOLUTE p;
    d:^DOUBLE ABSOLUTE p;
    si:^SHORTINT ABSOLUTE p;
    i:^INTEGER ABSOLUTE p;
    li:^LONGINT ABSOLUTE p;
    b:^BYTE ABSOLUTE p;
    w:^WORD ABSOLUTE p;
    lw:^LONGWORD ABSOLUTE p;
    bo:^BOOLEAN ABSOLUTE p;
    c:^CHAR ABSOLUTE p;
    co:^COMP ABSOLUTE p;
    cu:^Currency ABSOLUTE p;
    ss:STRING;
    cc:INTEGER;
BEGIN
     p:=@v;
     inc(p,2);
     CASE VarType(v) AND VarTypeMask OF
        VarEmpty:result:=0;
        VarNull:Raise EVariantError.Create('Access to invalid variant variable');
        VarSmallInt:result:=si^;
        VarInteger:result:=i^;
        VarLongint:result:=li^;
        VarSingle:result:=s^;
        VarDouble:result:=d^;
        VarExtended:result:=e^;
        VarComp:result:=co^;
        VarCurrency:result:=cu^;
        VarBoolean:IF bo^ THEN result:=1 ELSE result:=0;
        VarByte:result:=b^;
        VarWord:result:=w^;
        VarLongWord:result:=lw^;
        VarChar:result:=ord(c^);
        VarString:
        BEGIN
             ASM
                MOV EAX,v
                ADD EAX,2
                PUSH EAX            //Ansi string
                LEA EAX,ss
                PUSH EAX
                PUSHL 255
                CALLN32 SYSTEM.!AssignAnsi2Str
             END;
             VAL(ss,result,cc);
             IF cc<>0 THEN Raise EVariantError.Create('Invalid numeric format');
        END;
     END; {case}
END;

FUNCTION Variant2LongBool(CONST v:VARIANT):LONGBOOL;
VAR
    p:POINTER;
    s:^SINGLE ABSOLUTE p;
    e:^EXTENDED ABSOLUTE p;
    d:^DOUBLE ABSOLUTE p;
    si:^SHORTINT ABSOLUTE p;
    i:^INTEGER ABSOLUTE p;
    li:^LONGINT ABSOLUTE p;
    b:^BYTE ABSOLUTE p;
    w:^WORD ABSOLUTE p;
    lw:^LONGWORD ABSOLUTE p;
    bo:^BOOLEAN ABSOLUTE p;
    c:^CHAR ABSOLUTE p;
    co:^COMP ABSOLUTE p;
    cu:^Currency ABSOLUTE p;
    ss:STRING;
    ee:EXTENDED;
    cc:INTEGER;
BEGIN
     p:=@v;
     inc(p,2);
     CASE VarType(v) AND VarTypeMask OF
        VarEmpty:result:=FALSE;
        VarNull:Raise EVariantError.Create('Access to invalid variant variable');
        VarSmallInt:result:=si^<>0;
        VarInteger:result:=i^<>0;
        VarLongint:result:=li^<>0;
        VarSingle:result:=s^<>0;
        VarDouble:result:=d^<>0;
        VarExtended:result:=e^<>0;
        VarComp:result:=co^<>0;
        VarCurrency:result:=cu^<>0;
        VarBoolean:result:=bo^;
        VarByte:result:=b^<>0;
        VarWord:result:=w^<>0;
        VarLongWord:result:=lw^<>0;
        VarChar:result:=ord(c^)<>0;
        VarString:
        BEGIN
             ASM
                MOV EAX,v
                ADD EAX,2
                PUSH EAX            //Ansi string
                LEA EAX,ss
                PUSH EAX
                PUSHL 255
                CALLN32 SYSTEM.!AssignAnsi2Str
             END;
             UpcaseStr(ss);
             IF ss='TRUE' THEN result:=TRUE
             ELSE IF ss='FALSE' THEN result:=FALSE
             ELSE
             BEGIN
                VAL(ss,ee,cc);
                IF cc<>0 THEN Raise EVariantError.Create('Invalid boolean format');
                result:=ee<>0;
             END;
        END;
     END; {case}
END;

FUNCTION VarType(CONST v:VARIANT):WORD;ASSEMBLER;
ASM
   MOV EAX,v
   MOV AX,[EAX]
   MOV result,AX
END;

FUNCTION VarIsNull(CONST v:VARIANT):BOOLEAN;ASSEMBLER;
ASM
   MOV EAX,v
   CMP EAX,0
   JE !vi01
   MOV AX,[EAX]
!vi01:
   CMP AX,0
   SETE AL
   MOV Result,AL
END;

CONST VarConversionProcs:ARRAY[VarSmallInt..VarCurrency] OF POINTER=
               (@Variant2LongInt{VarSmallInt},
                @Variant2LongInt{VarInteger},
                @Variant2LongInt{VarLongint},
                @Variant2Extended{VarSingle},
                @Variant2Extended{VarDouble},
                @Variant2Extended{VarExtended},
                @Variant2LongBool{VarBoolean},
                @Variant2LongWord{VarByte},
                @Variant2LongWord{VarWord},
                @Variant2LongWord{VarLongWord},
                @Variant2LongWord{VarChar},
                @Variant2Extended{VarComp},
                @Variant2Extended{VarCurrency}
              );

FUNCTION VarAsType(const v:VARIANT;VType:INTEGER):Variant;
VAR s:AnsiString;
    pp:POINTER;  {conversion address}
    res:LONGWORD;
BEGIN
     IF VType=VarType(v) AND VarTypeMask THEN
     BEGIN
          result:=v;
          exit;
     END;

     CASE VType OF
        VarString:
        BEGIN
             ASM
                PUSH DWORD PTR v
                LEA EAX,s
                PUSH EAX
                CALLN32 SYSTEM.Variant2AnsiStr
             END;
             result:=s;
        END
        ELSE
        BEGIN
             IF ((VType<VarSmallInt)OR(VType>VarCurrency)) THEN
               Raise EVariantError.Create('Illegal variant type');
             pp:=VarConversionProcs[VType];
             ASM
                PUSH DWORD PTR v
                LEA EAX,pp
                CALLN32 [EAX]
                MOV res,EAX
             END;
             CASE VType OF
                VarSmallInt,VarInteger,VarLongInt,VarByte,VarWord,
                VarLongWord,VarChar,VarBoolean:
                BEGIN
                     ASM
                        MOV EAX,result
                        MOV EBX,res
                        MOV [EAX+2],EBX
                     END;
                END;
                VarSingle:
                BEGIN
                     ASM
                        MOV EAX,DWORD PTR result
                        FSTP DWORD PTR [EAX+2]
                     END;
                END;
                VarDouble:
                BEGIN
                     ASM
                        MOV EAX,DWORD PTR result
                        FSTP QWORD PTR [EAX+2]
                     END;
                END;
                VarExtended:
                BEGIN
                     ASM
                        MOV EAX,DWORD PTR result
                        FSTP TBYTE PTR [EAX+2]
                     END;
                END;
                VarComp:
                BEGIN
                     ASM
                        MOV EAX,DWORD PTR result
                        FISTP QWORD PTR [EAX+2]
                     END;
                END;
                VarCurrency:
                BEGIN
                     ASM
                        MOV EAX,DWORD PTR result
                        FISTP QWORD PTR [EAX+2]
                     END;
                END;
             END; {case}
        END;
     END; {case}
     TVarData(result).VType:=VType;
END;

PROCEDURE VarCast(VAR Dest:Variant;CONST source:Variant;VarType:Integer);
BEGIN
     Dest:=VarAsType(source,VarType);
END;

{Variant operation codes}
CONST
    S_Times=1;
    S_Div=2;
    S_Divide=3;
    S_Mod=4;
    S_And=5;
    S_Shl=6;
    S_Shr=7;
    S_Plus=8;
    S_Minus=9;
    S_Xor=10;
    S_Or=11;
    S_Not=12;
    S_Negate=13;

CONST OpIndex:ARRAY[VarSmallInt..VarCurrency] OF WORD=
           (0{VarSmallInt},
            0{VarInteger},
            0{VarLongInt},
            1{VarSingle},
            1{VarDouble},
            1{VarExtended},
            4{VarBoolean},
            2{VarByte},
            2{VarWord},
            2{VarLongWord},
            2{VarChar},
            1{VarComp},
            1{VarCurrency}
           );

CONST OpCommonTypes:ARRAY[0..4,0..4] OF WORD=
  (
   (VarLongInt,VarExtended,VarLongInt,VarExtended,VarLongint),   {LONGINT row}
   (VarExtended,VarExtended,VarExtended,VarExtended,VarExtended),{EXTENDED row}
   (VarLongInt,VarExtended,VarLongWord,VarExtended,VarLongWord), {LONGWORD row}
   (VarExtended,VarExtended,VarExtended,VarString,VarBoolean),   {AnsiString row}
   (VarLongInt,VarExtended,VarLongWord,VarBoolean,VarBoolean)    {Boolean row}
  );

FUNCTION VariantOp(v1,v2:VARIANT;op:LONGWORD):VARIANT;
VAR v1Type:WORD;
    v2Type:WORD;
    i1,i2:LONGINT;
    resultType:WORD;

    pp1:POINTER;
    pp2:POINTER;
    ppres:POINTER;

    pp1_longint:^LONGINT ABSOLUTE pp1;
    pp1_longword:^LONGWORD ABSOLUTE pp1;
    pp1_Extended:^EXTENDED ABSOLUTE pp1;
    pp1_Boolean:^BOOLEAN ABSOLUTE pp1;
    pp1_Ansi:^AnsiString ABSOLUTE pp1;

    pp2_longint:^LONGINT ABSOLUTE pp2;
    pp2_longword:^LONGWORD ABSOLUTE pp2;
    pp2_Extended:^EXTENDED ABSOLUTE pp2;
    pp2_Boolean:^BOOLEAN ABSOLUTE pp2;
    pp2_Ansi:^AnsiString ABSOLUTE pp2;

    ppres_longint:^LONGINT ABSOLUTE ppres;
    ppres_longword:^LONGWORD ABSOLUTE ppres;
    ppres_Extended:^EXTENDED ABSOLUTE ppres;
    ppres_Boolean:^BOOLEAN ABSOLUTE ppres;
    ppres_Ansi:^AnsiString ABSOLUTE ppres;
BEGIN
     pp1:=@v1;
     inc(pp1,2);
     pp2:=@v2;
     inc(pp2,2);
     ppres:=@result;
     inc(ppres,2);

     v1Type:=VarType(v1) AND VarTypeMask;
     v2Type:=VarType(v2) AND VarTypeMask;
     IF ((v1Type=varEmpty)OR(v2Type=VarEmpty)) THEN
       Raise EVariantError.Create('Illegal variant operation on empty variant');
     IF v1Type<>VarString THEN i1:=OpIndex[v1Type]
     ELSE i1:=3;
     IF v2Type<>VarString THEN i2:=OpIndex[v2Type]
     ELSE i2:=3;

     resultType:=OpCommonTypes[i1,i2];
     CASE Op OF
        S_Times:IF resultType IN [VarString,VarBoolean] THEN
                   resultType:=VarDouble;
        S_Div:IF not (resultType IN [VarLongint,VarLongWord]) THEN
                resultType:=VarLongint;
        S_Divide:resultType:=VarExtended;
        S_Mod:IF not (resultType IN [VarLongint,VarLongWord]) THEN
                resultType:=VarLongint;
        S_And:IF not (resultType IN [VarLongint,VarLongWord,VarBoolean]) THEN
                resultType:=VarLongint;
        S_Shl:IF not (resultType IN [VarLongint,VarLongWord]) THEN
                resultType:=VarLongint;
        S_Shr:IF not (resultType IN [VarLongint,VarLongWord]) THEN
                resultType:=VarLongint;
        S_Plus:IF resultType=VarBoolean THEN resultType:=VarDouble;
        S_Minus:IF resultType IN [VarString,VarBoolean] THEN
                   resultType:=VarDouble;
        S_OR:IF not (resultType IN [VarLongint,VarLongWord,VarBoolean]) THEN
                resultType:=VarLongint;
        S_Xor:IF not (resultType IN [VarLongint,VarLongWord,VarBoolean]) THEN
                resultType:=VarLongint;
     END;
     IF resultType IN [VarLongint,VarLongWord] THEN IF Op=S_Divide THEN
       resultType:=VarExtended;
     v1:=VarAsType(v1,ResultType);
     v2:=VarAsType(v2,ResultType);

     CASE Op OF
        S_Times:
        BEGIN
             {real and integers allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=pp1_LongInt^ * pp2_Longint^;
                VarLongWord:ppres_LongWord^:=pp1_LongWord^ * pp2_LongWord^;
                VarExtended:ppres_Extended^:=pp1_Extended^ * pp2_Extended^;
             END; {case}
        END;
        S_Div:
        BEGIN
             {Only integers allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=pp1_LongInt^ DIV pp2_Longint^;
                VarLongWord:ppres_LongWord^:=pp1_LongWord^ DIV pp2_LongWord^;
             END; {case}
        END;
        S_Divide:
        BEGIN
             {only reals allowed}
             ppres_Extended^:=pp1_Extended^ / pp2_Extended^;
        END;
        S_Mod:
        BEGIN
             {Only integers allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=pp1_LongInt^ MOD pp2_Longint^;
                VarLongWord:ppres_LongWord^:=pp1_LongWord^ MOD pp2_LongWord^;
             END; {case}
        END;
        S_And:
        BEGIN
             {Only integers and boolean types allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=pp1_LongInt^ AND pp2_Longint^;
                VarLongWord:ppres_LongWord^:=pp1_LongWord^ AND pp2_LongWord^;
                VarBoolean:ppres_Boolean^:=pp1_Boolean^ AND pp2_Boolean^;
             END; {case}
        END;
        S_Shl:
        BEGIN
             {Only integers allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=pp1_LongInt^ SHL pp2_Longint^;
                VarLongWord:ppres_LongWord^:=pp1_LongWord^ SHL pp2_LongWord^;
             END; {case}
        END;
        S_Shr:
        BEGIN
             {Only integers allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=pp1_LongInt^ SHR pp2_Longint^;
                VarLongWord:ppres_LongWord^:=pp1_LongWord^ SHR pp2_LongWord^;
             END; {case}
        END;
        S_Plus:
        BEGIN
             {real and integers and AnsiStrings allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=pp1_LongInt^ + pp2_Longint^;
                VarLongWord:ppres_LongWord^:=pp1_LongWord^ + pp2_LongWord^;
                VarExtended:ppres_Extended^:=pp1_Extended^ + pp2_Extended^;
                VarString:
                BEGIN
                     ppres_Longint^:=0;  {Clear destination ansi}
                     ppres_Ansi^:=pp1_Ansi^ + pp2_Ansi^;
                END;
             END; {case}
        END;
        S_Minus:
        BEGIN
             {real and integers allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=pp1_LongInt^ - pp2_Longint^;
                VarLongWord:ppres_LongWord^:=pp1_LongWord^ - pp2_LongWord^;
                VarExtended:ppres_Extended^:=pp1_Extended^ - pp2_Extended^;
             END; {case}
        END;
        S_OR:
        BEGIN
             {Only integers and boolean types allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=pp1_LongInt^ OR pp2_Longint^;
                VarLongWord:ppres_LongWord^:=pp1_LongWord^ OR pp2_LongWord^;
                VarBoolean:ppres_Boolean^:=pp1_Boolean^ OR pp2_Boolean^;
             END; {case}
        END;
        S_Xor:
        BEGIN
             {Only integers and boolean types allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=pp1_LongInt^ XOR pp2_Longint^;
                VarLongWord:ppres_LongWord^:=pp1_LongWord^ XOR pp2_LongWord^;
                VarBoolean:ppres_Boolean^:=pp1_Boolean^ XOR pp2_Boolean^;
             END; {case}
        END;
     END;

     TVarData(result).VType:=resultType;
END;

FUNCTION VariantNegNot(v1:VARIANT;op:LONGWORD):VARIANT;
VAR v1Type:WORD;
    resultType:WORD;

    pp1:POINTER;
    ppres:POINTER;

    pp1_longint:^LONGINT ABSOLUTE pp1;
    pp1_longword:^LONGWORD ABSOLUTE pp1;
    pp1_Extended:^EXTENDED ABSOLUTE pp1;
    pp1_Boolean:^BOOLEAN ABSOLUTE pp1;
    pp1_Ansi:^AnsiString ABSOLUTE pp1;

    ppres_longint:^LONGINT ABSOLUTE ppres;
    ppres_longword:^LONGWORD ABSOLUTE ppres;
    ppres_Extended:^EXTENDED ABSOLUTE ppres;
    ppres_Boolean:^BOOLEAN ABSOLUTE ppres;
    ppres_Ansi:^AnsiString ABSOLUTE ppres;
BEGIN
     pp1:=@v1;
     inc(pp1,2);
     ppres:=@result;
     inc(ppres,2);

     v1Type:=VarType(v1) AND VarTypeMask;
     IF v1Type=varEmpty THEN
       Raise EVariantError.Create('Illegal variant operation on empty variant');

     resultType:=v1Type;
     CASE Op OF
        S_Negate:IF resultType IN [VarString,VarBoolean] THEN
                    resultType:=VarDouble;
        S_Not:IF not (resultType IN [VarBoolean,VarLongint,VarLongWord])
                THEN resultType:=VarLongint;
     END;
     v1:=VarAsType(v1,ResultType);

     CASE Op OF
        S_Negate:
        BEGIN
             {real and integers allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=-pp1_LongInt^;
                VarLongWord:ppres_LongWord^:=-pp1_LongWord^;
                VarExtended:ppres_Extended^:=-pp1_Extended^;
             END; {case}
        END;
        S_NOT:
        BEGIN
             {Only Booleans and integers allowed}
             CASE resultType OF
                VarLongint:ppres_Longint^:=NOT pp1_LongInt^;
                VarLongWord:ppres_LongWord^:=NOT pp1_LongWord^;
                VarBoolean:ppres_Boolean^:=NOT pp1_Boolean^;
             END; {case}
        END;
     END;

     TVarData(result).VType:=resultType;
END;

FUNCTION VariantCmp(v1,v2:VARIANT):BYTE;
VAR v1Type:WORD;
    v2Type:WORD;
    i1,i2:LONGINT;
    resultType:WORD;

    pp1:POINTER;
    pp2:POINTER;
    ppres:POINTER;

    pp1_longint:^LONGINT ABSOLUTE pp1;
    pp1_longword:^LONGWORD ABSOLUTE pp1;
    pp1_Extended:^EXTENDED ABSOLUTE pp1;
    pp1_Boolean:^BOOLEAN ABSOLUTE pp1;
    pp1_Ansi:^AnsiString ABSOLUTE pp1;

    pp2_longint:^LONGINT ABSOLUTE pp2;
    pp2_longword:^LONGWORD ABSOLUTE pp2;
    pp2_Extended:^EXTENDED ABSOLUTE pp2;
    pp2_Boolean:^BOOLEAN ABSOLUTE pp2;
    pp2_Ansi:^AnsiString ABSOLUTE pp2;

    ppres_longint:^LONGINT ABSOLUTE ppres;
    ppres_longword:^LONGWORD ABSOLUTE ppres;
    ppres_Extended:^EXTENDED ABSOLUTE ppres;
    ppres_Boolean:^BOOLEAN ABSOLUTE ppres;
    ppres_Ansi:^AnsiString ABSOLUTE ppres;
BEGIN
     pp1:=@v1;
     inc(pp1,2);
     pp2:=@v2;
     inc(pp2,2);
     ppres:=@result;
     inc(ppres,2);

     v1Type:=VarType(v1) AND VarTypeMask;
     v2Type:=VarType(v2) AND VarTypeMask;
     IF ((v1Type=varEmpty)OR(v2Type=VarEmpty)) THEN
     BEGIN
          IF ((v1Type=VarEmpty)AND(v2Type=VarEmpty)) THEN result:=1
          ELSE
          BEGIN
               IF v1Type=VarEmpty THEN result:=0
               ELSE result:=2;
          END;
          exit;
     END;
     IF v1Type<>VarString THEN i1:=OpIndex[v1Type]
     ELSE i1:=3;
     IF v2Type<>VarString THEN i2:=OpIndex[v2Type]
     ELSE i2:=3;

     resultType:=OpCommonTypes[i1,i2];
     v1:=VarAsType(v1,ResultType);
     v2:=VarAsType(v2,ResultType);

     CASE ResultType OF
        VarLongInt:IF pp1_Longint^=pp2_Longint^ THEN result:=1
                   ELSE IF pp1_Longint^>pp2_Longint^ THEN result:=2
                   ELSE result:=0;
        VarLongWord:IF pp1_LongWord^=pp2_LongWord^ THEN result:=1
                    ELSE IF pp1_LongWord^>pp2_LongWord^ THEN result:=2
                    ELSE result:=0;
        VarBoolean:IF pp1_Boolean^=pp2_Boolean^ THEN result:=1
                   ELSE result:=0;
        VarString:IF pp1_Ansi^=pp2_Ansi^ THEN result:=1
                    ELSE IF pp1_Ansi^>pp2_Ansi^ THEN result:=2
                    ELSE result:=0;
        VarExtended:IF pp1_Extended^=pp2_Extended^ THEN result:=1
                    ELSE IF pp1_Extended^>pp2_Extended^ THEN result:=2
                    ELSE result:=0;
     END; {case}
END;


ASSEMBLER

//(op1,op2,result,operation)
SYSTEM.!VariantOp PROC NEAR32
      PUSH EBP
      MOV EBP,ESP
      SUB ESP,16

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+20]     //first operand
      PUSH DWORD PTR [EBP+16]     //second operand
      PUSH DWORD PTR [EBP+8]      //operation to perform
      LEA EAX,[EBP-16]            //temp result
      PUSH EAX
      CALLN32 SYSTEM.VariantOp

      LEA ESI,[EBP-16]            //temp result
      MOV EDI,[EBP+12]            //result value
      CLD
      MOV ECX,4
      REP MOVSD

      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 16
SYSTEM.!VariantOp ENDP

//(op,result,operation)
SYSTEM.!VariantNegNot PROC NEAR32
      PUSH EBP
      MOV EBP,ESP
      SUB ESP,16

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+16]  //operand
      PUSH DWORD PTR [EBP+8]   //operation to perform
      LEA EAX,[EBP-16]         //temp result
      PUSH EAX
      CALLN32 SYSTEM.VariantNegNot

      LEA ESI,[EBP-16]         //temp result
      MOV EDI,[EBP+12]         //result value
      CLD
      MOV ECX,4
      REP MOVSD

      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 12
SYSTEM.!VariantNegNot ENDP

//(op1,op2)
SYSTEM.!VariantCmp PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+12]    //first operand
      PUSH DWORD PTR [EBP+8]     //second operand
      CALLN32 SYSTEM.VariantCmp

      CMP AL,1           //0 op1<op2
                         //1 op1=op2
                         //2 op1>op2

      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 8
SYSTEM.!VariantCmp ENDP

//(Source,Dest,DestLen)
SYSTEM.!Variant2Signed PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+16]   //Source
      CALLN32 SYSTEM.Variant2Longint

      MOV EBX,[EBP+8]           //DestLen
      MOV ESI,[EBP+12]          //Dest
      CMP ESI,0
      JNE !VarSignAssign
      //called as function
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      ADD ESP,4     //old EAX
      LEAVE
      RETN32 12
!VarSignAssign:
      CMP EBX,1
      JNE !not_ShortInt
      MOV [ESI],AL
      JMP !VarSignEx
!not_ShortInt:
      CMP EBX,2
      JNE !not_Integer
      MOV [ESI],AX
      JMP !VarSignEx
!not_Integer:
      MOV [ESI],EAX
!VarSignEx:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 12
SYSTEM.!Variant2Signed ENDP

//(Source,Dest,DestLen)
SYSTEM.!Variant2UnSigned PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+16]     //Source
      CALLN32 SYSTEM.Variant2LongWord

      MOV EBX,[EBP+8]             //DestLen
      MOV ESI,[EBP+12]            //Dest
      CMP ESI,0
      JNE !VarUnSignAssign
      //called as function
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      ADD ESP,4     //old EAX
      LEAVE
      RETN32 12
!VarUnSignAssign:
      CMP EBX,1
      JNE !not_Byte
      MOV [ESI],AL
      JMP !VarUnSignEx
!not_Byte:
      CMP EBX,2
      JNE !not_Word
      MOV [ESI],AX
      JMP !VarUnSignEx
!not_Word:
      MOV [ESI],EAX
!VarUnSignEx:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 12
SYSTEM.!Variant2UnSigned ENDP

//(Source,Dest,DestLen)
SYSTEM.!Variant2Real PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+16]         //Source
      CALLN32 SYSTEM.Variant2Extended

      MOV EBX,[EBP+8]                 //DestLen
      MOV ESI,[EBP+12]                //Dest
      CMP ESI,0
      JE !VarRealEx                   //called as function
      CMP EBX,4
      JNE !not_Single
      FSTP DWORD PTR [ESI]
      JMP !VarRealEx
!not_Single:
      CMP EBX,8
      JNE !not_Double
      FSTP QWORD PTR [ESI]
      JMP !VarRealEx
!not_Double:
      FSTP TBYTE PTR [ESI]
!VarRealEx:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 12
SYSTEM.!Variant2Real ENDP

//(Source,Dest)
SYSTEM.!Variant2Comp PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+12]    //Source
      CALLN32 SYSTEM.Variant2Extended

      MOV ESI,[EBP+8]           //Dest
      CMP ESI,0
      JE !VarCompEx             //called as function

      FISTP QWORD PTR [ESI]
!VarCompEx:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 8
SYSTEM.!Variant2Comp ENDP

//(Source,Dest)
SYSTEM.!Variant2Currency PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+12]    //Source
      CALLN32 SYSTEM.Variant2Extended

      MOV ESI,[EBP+8]           //Dest
      CMP ESI,0
      JE !VarCompEx             //called as function

      FLDT SYSTEM.ToCurrency  //*10000
      FMULP ST(1),ST
      FRNDINT
      FISTP QWORD PTR [ESI]
!VarCompEx:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 8
SYSTEM.!Variant2Currency ENDP


//(Source,Dest,DestLen)
SYSTEM.!Variant2Bool PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+16]         //Source
      CALLN32 SYSTEM.Variant2LongBool

      MOV EBX,[EBP+8]                 //DestLen
      MOV ESI,[EBP+12]                //Dest
      CMP ESI,0
      JNE !VarBoolAssign
      //called as function
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      ADD ESP,4     //old EAX
      LEAVE
      RETN32 12
!VarBoolAssign:
      CMP EBX,1
      JNE !not_Boolean
      MOV [ESI],AL
      JMP !VarBoolEx
!not_Boolean:
      CMP EBX,2
      JNE !not_WordBool
      MOV [ESI],AX
      JMP !VarBoolEx
!not_WordBool:
      MOV [ESI],EAX
!VarBoolEx:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 12
SYSTEM.!Variant2Bool ENDP

//(Source,Dest)
SYSTEM.!Variant2Str PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+12]                //Source
      PUSH DWORD PTR [EBP+8]                 //Dest
      CALLN32 SYSTEM.Variant2Str

      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 8
SYSTEM.!Variant2Str ENDP

//(Source,Dest)
SYSTEM.!Variant2CStr PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+12]     //Source
      PUSH DWORD PTR [EBP+8]      //Dest
      CALLN32 SYSTEM.Variant2CStr

      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 8
SYSTEM.!Variant2CStr ENDP

//(Source,Dest)
SYSTEM.!Variant2AnsiStr PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+12]  //Source
      PUSH DWORD PTR [EBP+8]   //Dest
      CALLN32 SYSTEM.Variant2AnsiStr

      //increase reference pointer by 1
      MOV EAX,[EBP+8]          //Dest
      MOV EAX,[EAX]
      CMP EAX,0
      JE !is0_ansi
      INC DWORD PTR [EAX-8]
!is0_ansi:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 8
SYSTEM.!Variant2AnsiStr ENDP

//(Source,Dest)
SYSTEM.!VariantCopy PROC NEAR32
   PUSH EBP
   MOV EBP,ESP

   PUSH EAX
   PUSH EBX
   PUSH ECX
   PUSH EDX
   PUSH ESI
   PUSH EDI

   MOV ESI,[EBP+12]        //Source
   MOV EDI,[EBP+8]         //Dest
   MOV ECX,4
   CLD
   REP
   MOVSD                   //Copy variant

   MOV ESI,[EBP+12]        //Source
   MOV EDI,[EBP+8]         //Dest
   MOV AX,[ESI]
   AND AX,$0FFF            //mask type
   CMP AX,$0100            //is it a ansi string ??
   JNE !not_a_Ansi4
   ADD ESI,2
   ADD EDI,2
   MOVD [EDI],0            //clear dest Ansi
   PUSH ESI
   PUSH EDI
   CALLN32 SYSTEM.!AnsiCopy
!not_a_Ansi4:

   POP EDI
   POP ESI
   POP EDX
   POP ECX
   POP EBX
   POP EAX

   LEAVE
   RETN32 8
SYSTEM.!VariantCopy ENDP

//(Source,Dest)
SYSTEM.!VariantCreate PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      MOV ESI,[EBP+12]  //Source
      MOV EDI,[EBP+8]   //Dest
      MOV ECX,4
      CLD
      REP
      MOVSD             //Copy variant

      MOV ESI,[EBP+12]  //Source
      MOV EDI,[EBP+8]   //Dest
      MOV AX,[ESI]
      AND AX,$0FFF      //mask type
      CMP AX,$0100      //is it a ansi string ??
      JNE !not_a_Ansi3
      ADD ESI,2
      ADD EDI,2
      PUSH ESI
      PUSH EDI
      CALLN32 SYSTEM.!AnsiCreate
!not_a_Ansi3:
      LEAVE
      RETN32 8
SYSTEM.!VariantCreate ENDP

//(Source,Dest)
SYSTEM.!VariantCreate_Clear PROC NEAR32
     PUSH EBP
     MOV EBP,ESP

     PUSH DWORD PTR [EBP+12]  //Source
     PUSH DWORD PTR [EBP+8]   //Dest
     CALLN32 SYSTEM.!VariantCreate

     MOV ESI,[EBP+12]         //Source
     CALLN32 SYSTEM.!FreeConstVariant

     LEAVE
     RETN32 8
SYSTEM.!VariantCreate_Clear ENDP

//ESI address of variant
SYSTEM.!FreeVariantAnsiStr PROC NEAR32
      MOV AX,[ESI]
      AND AX,$0FFF  //mask type
      CMP AX,$0100  //is it a ansi string ??
      JNE !not_a_Ansi
      ADD ESI,2     //points to ansi string
      CALLN32 SYSTEM.!FreeAnsiStr
      SUB ESI,2
!not_a_Ansi:
      RETN32
SYSTEM.!FreeVariantAnsiStr ENDP

//(Variant)
SYSTEM.!UniqueVariant0 PROC NEAR32
      PUSH EBP
      MOV EBP,ESP
      SUB ESP,4

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH EDI
      PUSH ESI

      MOV ESI,[EBP+8]         //Variant
      MOV AX,[ESI]
      AND AX,$0FFF            //mask type
      CMP AX,$0100            //is it a ansi string ??
      JNE !not_a_Ansi5
      ADD ESI,2               //points to ansi string
      PUSH ESI                //source and dest
      CALLN32 SYSTEM.!AnsiCreate_Clear
      MOV ESI,[EBP+8]
      ADD ESI,2
      MOV EAX,[ESI]
      CMP EAX,0
      JE !not_a_Ansi5
      MOVD [EAX-8],0          //reference count to 0
!not_a_Ansi5:
      POP ESI
      POP EDI
      POP EDX
      POP ECX
      POP EBX
      POP EAX

      LEAVE
      RETN32 4
SYSTEM.!UniqueVariant0 ENDP

//(VAR Type,TypeInfo:POINTER)
SYSTEM.!FreeVariantAnsiType PROC NEAR32

{$IFDEF SPDLL30W32}
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH EDI
      PUSH ESI

      MOV ESI,[EBP+8]    //TypeInfo
      INC ESI
      MOV EDI,[EBP+12]   //Type to free
      CMP ESI,1
      JE !No_valid_type
      CMP EDI,0
      JE !No_valid_type

      ADD ESI, EBP       // WD: hinzugekommen, korrekt?
      CMPB [ESI-1],2     //RECORD ?
      JNE !No_Record
      //Type is a record
!Rec:
      MOV AL,[ESI]
      INC ESI
      CMP AL,0           //End of list
      JE !No_valid_type

      MOV EBX,EDI
      ADD EBX,[ESI]      //Calculate address
      ADD ESI,4

      CMP AL,1           //Is it an ansi string ??
      JNE !No_Ansi_Rec
      PUSH ESI
      PUSH EDI
      MOV ESI,EBX
      CALLN32 SYSTEM.!FreeAnsiStr
      POP EDI
      POP ESI
      JMP !Rec

!No_Ansi_Rec:
      CMP AL,2           //Is it a variant ??
      JNE !No_Variant_Rec
      PUSH EBX
      CALLN32 SYSTEM.!FreeVariant
      JMP !Rec

!No_Variant_Rec:
      CMP AL,3
      JNE !No_valid_type
      //it is a nested type info
      PUSH EBX
      PUSH DWORD PTR [ESI]  //nested type info
      ADD ESI,4
      CALLN32 SYSTEM.!FreeVariantAnsiType
      JMP !Rec           //next entry

!No_Record:
      CMPB [ESI-1],3     //OBJECT or CLASS ?
      JNE !No_Class
      //Type is object or class
      PUSH EDI
      PUSH DWORD PTR [ESI] //Parent type info
      ADD ESI,4
      CALLN32 SYSTEM.!FreeVariantAnsiType
      JMP !Rec

!No_Class:
      CMPB [ESI-1],4     //Array ?
      JNE !No_Array
      //Type is an array
      MOV ECX,[ESI]      //array high index
      ADD ESI,4
      MOV EDX,[ESI]      //array elem size
      ADD ESI,4
!AAgain:
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      CMPB [ESI],1
      JNE !No_AAnsi

      MOV ESI,EDI
      CALLN32 SYSTEM.!FreeAnsiStr
      JMP !AWeiter
!No_AAnsi:
      CMPB [ESI],2
      JNE !No_AVariant

      PUSH EDI
      CALLN32 SYSTEM.!FreeVariant
      JMP !AWeiter
!No_AVariant:
      //nested info
      PUSH EDI
      PUSH DWORD PTR [ESI+1]
      CALLN32 SYSTEM.!FreeVariantAnsiType
!AWeiter:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      ADD EDI,EDX        //next array item
      LOOP !AAgain       //loop through array indizes

!No_Array:
      CMPB [ESI-1],5     //Pointer ??
      JNE !No_valid_type
      //Type is a pointer, pointers are passed by value !!!
      CMP EDI,0
      JE !No_valid_type  //Pointer is nil

      CMPB [ESI],1
      JNE !No_PAnsi

      MOV ESI,EDI
      CALLN32 SYSTEM.!FreeAnsiStr
      JMP !No_valid_type
!No_PAnsi:
      CMPB [ESI],2
      JNE !No_PVariant

      PUSH EDI
      CALLN32 SYSTEM.!FreeVariant
      JMP !No_valid_type
!No_PVariant:
      PUSH EDI
      PUSH DWORD PTR [ESI+1]  //Type info
      CALLN32 SYSTEM.!FreeVariantAnsiType

!No_valid_type:
      POP ESI
      POP EDI
      POP EDX
      POP ECX
      POP EBX
      POP EAX

      LEAVE
      RETN32 8
{$ELSE}
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH EDI
      PUSH ESI

      MOV ESI,[EBP+8]    //TypeInfo
      INC ESI
      MOV EDI,[EBP+12]   //Type to free
      CMP ESI,1
      JE !No_valid_type
      CMP EDI,0
      JE !No_valid_type

      CMPB [ESI-1],2     //RECORD ?
      JNE !No_Record
      //Type is a record
!Rec:
      MOV AL,[ESI]
      INC ESI
      CMP AL,0           //End of list
      JE !No_valid_type

      MOV EBX,EDI
      ADD EBX,[ESI]      //Calculate address
      ADD ESI,4

      CMP AL,1           //Is it an ansi string ??
      JNE !No_Ansi_Rec
      PUSH ESI
      PUSH EDI
      MOV ESI,EBX
      CALLN32 SYSTEM.!FreeAnsiStr
      POP EDI
      POP ESI
      JMP !Rec

!No_Ansi_Rec:
      CMP AL,2           //Is it a variant ??
      JNE !No_Variant_Rec
      PUSH EBX
      CALLN32 SYSTEM.!FreeVariant
      JMP !Rec

!No_Variant_Rec:
      CMP AL,3
      JNE !No_valid_type
      //it is a nested type info
      PUSH EBX
      PUSH DWORD PTR [ESI]  //nested type info
      ADD ESI,4
      CALLN32 SYSTEM.!FreeVariantAnsiType
      JMP !Rec           //next entry

!No_Record:
      CMPB [ESI-1],3     //OBJECT or CLASS ?
      JNE !No_Class
      //Type is object or class
      PUSH EDI
      PUSH DWORD PTR [ESI] //Parent type info
      ADD ESI,4
      CALLN32 SYSTEM.!FreeVariantAnsiType
      JMP !Rec

!No_Class:
      CMPB [ESI-1],4     //Array ?
      JNE !No_Array
      //Type is an array
      MOV ECX,[ESI]      //array high index
      ADD ESI,4
      MOV EDX,[ESI]      //array elem size
      ADD ESI,4
!AAgain:
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      CMPB [ESI],1
      JNE !No_AAnsi

      MOV ESI,EDI
      CALLN32 SYSTEM.!FreeAnsiStr
      JMP !AWeiter
!No_AAnsi:
      CMPB [ESI],2
      JNE !No_AVariant

      PUSH EDI
      CALLN32 SYSTEM.!FreeVariant
      JMP !AWeiter
!No_AVariant:
      //nested info
      PUSH EDI
      PUSH DWORD PTR [ESI+1]
      CALLN32 SYSTEM.!FreeVariantAnsiType
!AWeiter:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      ADD EDI,EDX        //next array item
      LOOP !AAgain       //loop through array indizes

!No_Array:
      CMPB [ESI-1],5     //Pointer ??
      JNE !No_valid_type
      //Type is a pointer, pointers are passed by value !!!
      CMP EDI,0
      JE !No_valid_type  //Pointer is nil

      CMPB [ESI],1
      JNE !No_PAnsi

      MOV ESI,EDI
      CALLN32 SYSTEM.!FreeAnsiStr
      JMP !No_valid_type
!No_PAnsi:
      CMPB [ESI],2
      JNE !No_PVariant

      PUSH EDI
      CALLN32 SYSTEM.!FreeVariant
      JMP !No_valid_type
!No_PVariant:
      PUSH EDI
      PUSH DWORD PTR [ESI+1]  //Type info
      CALLN32 SYSTEM.!FreeVariantAnsiType

!No_valid_type:
      POP ESI
      POP EDI
      POP EDX
      POP ECX
      POP EBX
      POP EAX

      LEAVE
      RETN32 8
{$ENDIF}

SYSTEM.!FreeVariantAnsiType ENDP

SYSTEM.!FreeObjectVariantAnsi PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX

      PUSH DWORD PTR [EBP+8]   //class/object to free
      PUSH DWORD PTR [EAX+12]  //typeinfo within VMT of object
      CALLN32 SYSTEM.!FreeVariantAnsiType

      POP EAX
      LEAVE
      RETN32  //dont pop !
SYSTEM.!FreeObjectVariantAnsi ENDP

SYSTEM.!FreePointerVariantAnsi PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH DWORD PTR [EBP+16]  //pointer to free
      PUSH DWORD PTR [EBP+8]   //type info
      CALLN32 SYSTEM.!FreeVariantAnsiType

      LEAVE
      RETN32 4   //dont pop others !
SYSTEM.!FreePointerVariantAnsi ENDP

//(Variant)
SYSTEM.!FreeVariant PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH EDI
      PUSH ESI

      MOV ESI,[EBP+8]     //Variant
      CALLN32 SYSTEM.!FreeVariantAnsiStr

      MOV ESI,[EBP+8]     //Variant
      MOVD [ESI],0
      MOVD [ESI+4],0

      POP ESI
      POP EDI
      POP EDX
      POP ECX
      POP EBX
      POP EAX

      LEAVE
      RETN32 4
SYSTEM.!FreeVariant ENDP

SYSTEM.!FreeConstVariant PROC NEAR32
      MOV AX,[ESI]
      AND AX,$0FFF       //mask type
      CMP AX,$0100       //is it a ansi string ??
      JNE !not_a_Ansi1
      ADD ESI,2          //points to ansi string
      CALLN32 SYSTEM.!FreeConstAnsi
      SUB ESI,2
!not_a_Ansi1:
      RETN32
SYSTEM.!FreeConstVariant ENDP

END;

//Ansi string support

FUNCTION AnsiPos(CONST item,source:AnsiString):LONGINT;
BEGIN
     ASM
         MOV EAX,0
         MOV ESI,item           //item
         CMP ESI,0
         JE Lab4
         MOV EDX,[ESI-4]
         OR EDX,EDX
         JE lab2
         MOV EDI,source         //source
         CMP EDI,0
         JE Lab4
         MOV ECX,[EDI-4]
         SUB ECX,EDX
         JB lab2
         INC ECX
lab1:
         CLD
         LODSB
         REPNE
         SCASB
         JNE lab2
         MOV EAX,EDI
         MOV EBX,ECX
         MOV ECX,EDX
         DEC ECX
         REPE
         CMPSB
         JE lab3
         MOV EDI,EAX
         MOV ECX,EBX
         MOV ESI,item      //item
         JMP lab1
Lab2:
         XOR EAX,EAX
         JMP Lab4
lab3:
         SUB EAX,Source    //source
Lab4:
         MOV result,EAX
     END;
END;

FUNCTION AnsiPosStr(CONST item:STRING;CONST source:AnsiString):LONGINT;
VAR s:AnsiString;
BEGIN
     s:=Item;
     result:=AnsiPos(s,source);
END;

FUNCTION AnsiCopy(CONST Source:AnsiString;Index,Count:LONGINT):AnsiString;
BEGIN
     ASM
        MOV EDI,Result               //Destination string
        MOVD [EDI+0],0               //Empty String

        MOV ESI,Source               //Source string
        CMP ESI,0
        JE !_CopyE

        MOV ECX,Count                //Count
        CMP ECX,1
        JL !_CopyE

        MOV EAX,Index                //Index
        CMP EAX,1
        JNL !_Copy1
        MOV EAX,1                    //Index:=1
!_Copy1:
        MOV EBX,[ESI-4]              //Length of Source
        CMP EAX,EBX
        JA !_CopyE                   //Index greater than string

        MOV EDX,EAX
        ADD EDX,ECX                  //Index+Count
        CMP EDX,EBX
        JNA !_Copy2
        MOV ECX,EBX
        SUB ECX,EAX
        INC ECX                      //Count := Length(S)-Index+1
!_Copy2:
        PUSH EDI
        PUSH ESI
        PUSH ECX
        PUSH EAX

        PUSH EDI
        PUSH ECX
        CALLN32 SYSTEM.AnsiSetLength

        POP EAX
        POP ECX
        POP ESI
        POP EDI
        MOV EDI,[EDI]

        ADD ESI,EAX                  //first char
        DEC ESI
        CLD
        MOV EDX,ECX
        SHR ECX,2
        REP
        MOVSD
        MOV ECX,EDX
        AND ECX,3
        REP
        MOVSB
!_CopyE:
     END;
END;

PROCEDURE AnsiInsert(CONST Source:AnsiString; VAR S:AnsiString; Index:LONGINT);
BEGIN
     IF Length(Source) = 0 THEN exit;
     IF Length(S) = 0 THEN
     BEGIN
          S := Source;
          exit;
     END;
     IF Index < 1 THEN Index := 1;
     IF Index > Length(S) THEN Index := Length(S)+1;
     S := AnsiCopy(S,1,Index-1) + Source + AnsiCopy(S,Index,Length(S)-Index+1);
END;

PROCEDURE AnsiInsertStr(CONST Source:String; VAR S:AnsiString; Index:LONGINT);
VAR ss:AnsiString;
BEGIN
  ss:=Source;
  AnsiInsert(ss,s,Index);
END;

PROCEDURE AnsiDelete(VAR S:AnsiString; Index,Count:LONGINT);
BEGIN
  IF Index < 1 THEN exit;
  IF Index > Length(S) THEN exit;
  IF Count < 1 THEN exit;
  IF Index+Count > Length(S) THEN Count := Length(S)-Index+1;
  S := AnsiCopy(S,1,Index-1) + AnsiCopy(S,Index+Count,Length(S)-Index-Count+1);
END;

PROCEDURE SetLength(VAR s:STRING;NewLength:LONGINT);
BEGIN
     s[0]:=chr(NewLength);
END;

PROCEDURE AnsiSetLength(VAR S:AnsiString;NewLength:LONGINT);
VAR Temp:AnsiString;
BEGIN
     ASM
        MOV EAX,NewLength
        ADD EAX,9 //Len of string plus 8 byte + zero termination byte
        LEA ESI,Temp
        PUSH ESI
        PUSH EAX
        CALLN32 SYSTEM.GetMem

        MOV EDI,Temp
        MOV EAX,NewLength
        MOV [EDI+4],EAX     //set new length
        MOVD [EDI],2        //reference count is 2 (!!)
        ADD EDI,8           //AnsiString starts at offset 8
        MOV Temp,EDI
        MOV ESI,S
        MOV ESI,[ESI]
        CMP ESI,0
        JE !ex

        MOV ECX,[ESI-4]    //get length of string
        CLD
        MOV EDX,ECX
        SHR ECX,2
        REP
        MOVSD
        MOV ECX,EDX
        AND ECX,3
        REP
        MOVSB

        //check if we can free source
        MOV ESI,S
        CALLN32 SYSTEM.!FreeAnsiStr
!ex:
        MOV ESI,S
        MOV EAX,Temp
        MOV [ESI],EAX
     END;
END;

PROCEDURE SetString(VAR s:STRING;Buffer:PChar;Len:LONGINT);
BEGIN
     s[0]:=chr(Len);
     IF Buffer<>NIL THEN Move(Buffer^,s[1],Len);
END;

PROCEDURE AnsiSetString(VAR S:AnsiString;Buffer:PChar;Len:LONGINT);
BEGIN
     AnsiSetLength(S,Len);
     IF Buffer<>NIL THEN
     BEGIN
          ASM
             MOV EDI,S
             MOV EDI,[EDI]
             MOV ESI,Buffer
             MOV ECX,Len
             CLD
             MOV EDX,ECX
             SHR ECX,2
             REP
             MOVSD
             MOV ECX,EDX
             AND ECX,3
             REP
             MOVSB
          END;
     END;
END;

ASSEMBLER

SYSTEM.!AnsiCmp PROC NEAR32
              CLD
              PUSH EBP
              MOV EBP,ESP

              PUSH EAX
              PUSH EBX
              PUSH ECX
              PUSH EDI
              PUSH ESI

              MOV AL,1
              MOV AH,0
              MOV ESI,[EBP+12]
              MOV ESI,[ESI]
              MOV EDI,[EBP+8]
              MOV EDI,[EDI]
              CMP ESI,EDI
              JE _nl3        //ok
              CMP EDI,0
              JNE _nl2_r1
              //ESI=NIL
              CMPB [ESI],0
              JE _nl3        //both empty
              JMP _nl2
_nl2_r1:
              MOV AH,2
              CMP ESI,0
              JNE _nl2_r2
              //EDI=NIL
              CMPB [EDI],0
              JE _nl3       //both empty
              JMP _nl2
_nl2_r2:
              MOV BX,$0101
              MOV EAX,[ESI-4]
              CMP EAX,[EDI-4]
              JE !_norene1
              MOV BL,0        //length does not match - strings cannot be equal
              CMP EAX,[EDI-4]
!_norene1:
              JBE _nl1
              MOV EAX,[EDI-4]
_nl1:
              MOV ECX,EAX
              CLD
              REP
              CMPSB
              JNE _nl3
              MOV AX,BX  //BL,BH are equal if length matches
_nl2:
              CMP AL,AH
_nl3:
              PUSHF

              //check if we can free first operand
              MOV ESI,[EBP+12]
              MOV EDI,[ESI]
              CMP EDI,0
              JE !AnsiCmp1
              CMPD [EDI-8],0
              JNE !AnsiCmp1
              CALLN32 SYSTEM.!FreeAnsiStr
!AnsiCmp1:
              //check if we can free second operand
              MOV ESI,[EBP+8]
              MOV EDI,[ESI]
              CMP EDI,0
              JE !AnsiCmpEx
              CMPD [EDI-8],0
              JNE !AnsiCmpEx
              CALLN32 SYSTEM.!FreeAnsiStr
!AnsiCmpEx:
              POPF
              POP ESI
              POP EDI
              POP ECX
              POP EBX
              POP EAX

              LEAVE
              RETN32 8
SYSTEM.!AnsiCmp ENDP

//(Dest,Source)
SYSTEM.!AnsiAdd PROC NEAR32
      PUSH EBP
      MOV EBP,ESP

      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH EDI
      PUSH ESI

      MOV ESI,[EBP+12]        //Dest
      MOV ESI,[ESI]
      CMP ESI,0
      JNE !AnsiAddOk          //destination not empty

      MOV ESI,[EBP+8]         //Source
      MOV EDI,[EBP+12]        //Dest
      MOV EDX,[ESI]
      MOV [EDI],EDX
      PUSH DWORD PTR [EBP+12] //Dest
      CALLN32 SYSTEM.!AnsiCreate_Clear
      MOV ESI,[EBP+12]        //Dest
      MOV ESI,[ESI]
      CMP ESI,0               //destination is empty
      JE !AnsiAddEx
      MOVD [ESI-8],0          //reference count to 0
      JMP !AnsiAddEx
!AnsiAddOk:
      //destination string is not empty
      MOV EDI,[EBP+8]         //Source
      MOV EDI,[EDI]
      CMP EDI,0
      JE !AnsiAddEx           //source is empty

      MOV EBX,[ESI-4]         //length of destination string
      MOV EAX,[EDI-4]         //length of source string
      ADD EAX,EBX             //length of destination string
      PUSH EBX
      PUSH DWORD PTR [EBP+12] //Dest
      PUSH EAX
      CALLN32 SYSTEM.AnsiSetLength
      POP EBX

      MOV EDI,[EBP+12]        //Dest
      MOV EDI,[EDI]
      MOVD [EDI-8],0          //reference count is 0
      ADD EDI,EBX             //Add old length of destination
      MOV ESI,[EBP+8]         //source
      MOV ESI,[ESI]
      MOV ECX,[ESI-4]         //length of source
      CLD
      MOV EDX,ECX
      SHR ECX,2
      REP
      MOVSD
      MOV ECX,EDX
      AND ECX,3
      REP
      MOVSB
      MOV AL,0   //terminate with 0
      STOSB

      //check if we can free source
      MOV ESI,[EBP+8]         //Source
      MOV EDI,[ESI]
      CMPD [EDI-8],0
      JNE !AnsiAddEx
      CALLN32 SYSTEM.!FreeAnsiStr
!AnsiAddEx:
      POP ESI
      POP EDI
      POP EDX
      POP ECX
      POP EBX
      POP EAX

      LEAVE
      RETN32 8
SYSTEM.!AnsiAdd ENDP

SYSTEM.!FreeAnsiStr PROC NEAR32
   //ESI address of Ansi string to free
   CMP ESI,0
   JE !String_Nil
   MOV EDI,[ESI]
   CMP EDI,0
   JE !String_Nil
   CMPD [EDI-8],0  //reference count is 0 (function result) -> free
   JE !Free_Ansi
   DECD [EDI-8]    //decrement reference count
   JNE !String_Nil //free only if reference count reaches 0
!Free_Ansi:
   PUSH ESI
   SUB EDI,8
   PUSH EDI
   MOV EAX,[EDI+4] //get len of Ansi string
   ADD EAX,9       //Len of string plus 8 byte + zero termination byte
   PUSH EAX
   CALLN32 SYSTEM.FreeMem
   //clear value
   POP ESI
   MOVD [ESI],0
!String_Nil:
   RETN32
SYSTEM.!FreeAnsiStr ENDP

SYSTEM.!DecAnsi PROC NEAR32
   PUSH EDI
   PUSH EBX

   MOV EBX,ESP
   MOV EDI,[EBX+12]
   MOV EDI,[EDI]
   CMP EDI,0
   JE !No_AnsiDec
   DECD [EDI-8]     //dec reference counter for function results
!No_AnsiDec:
   POP EBX
   POP EDI
   RETN32 4
SYSTEM.!DecAnsi ENDP

SYSTEM.!FreeConstAnsi PROC NEAR32
//Address of Ansi String in ESI
     MOV EDI,[ESI]
     CMP EDI,0
     JE !FreeAnsi0_0
     CMPD [EDI-8],0   //free only string with reference count 0
     JNE !FreeAnsi0
!Free_it:
     CALLN32 SYSTEM.!FreeAnsiStr
     JMP !FreeAnsi0_0
!FreeAnsi0:
     CMPD [EDI-8],$F0000000
     JE !Free_it
     JB !FreeAnsi0_0
     SUBD [EDI-8],$F0000000
!FreeAnsi0_0:
     RETN32
SYSTEM.!FreeConstAnsi ENDP

//(s)
SYSTEM.!FreeAnsi PROC NEAR32
   PUSH EBP
   MOV EBP,ESP

   PUSH EAX
   PUSH EBX
   PUSH ECX
   PUSH EDX
   PUSH ESI
   PUSH EDI

   MOV ESI,[EBP+8]       //Destination Ansi String
   CALLN32 SYSTEM.!FreeAnsiStr

   MOV ESI,[EBP+8]
   MOVD [ESI],0

   POP EDI
   POP ESI
   POP EDX
   POP ECX
   POP EBX
   POP EAX

   LEAVE
   RETN32 4
SYSTEM.!FreeAnsi ENDP

//(NewValue,s)
SYSTEM.!NewAnsiStr PROC NEAR32
   PUSH EBP
   MOV EBP,ESP

   PUSH EAX
   PUSH EBX
   PUSH ECX
   PUSH EDX
   PUSH ESI
   PUSH EDI

   MOV ESI,[EBP+8]              //Destination Ansi String
   CALLN32 SYSTEM.!FreeAnsiStr  //ESI contains address

   //clear destination Ansi
   MOVD [ESI],0

   MOV EDI,[EBP+12]             //String value to assign
   MOVZXB EAX,[EDI+0]
   CMP EAX,0
   JE !Ansi_0_10
   ADD EAX,9 //Len of string plus 8 byte + zero termination byte
   PUSH ESI
   PUSH EAX
   CALLN32 SYSTEM.GetMem

   MOV EDI,[EBP+8]              //Destination Ansi String
   MOV EDI,[EDI]
   MOVD [EDI],1                 //reference count to 1
   MOV ESI,[EBP+12]             //String value to assign
   MOVZXB ECX,[ESI+0]
   MOV [EDI+4],ECX              //set len
   INC ESI
   ADD EDI,8
   CLD
   MOV EDX,ECX
   SHR ECX,2
   REP
   MOVSD
   MOV ECX,EDX
   AND ECX,3
   REP
   MOVSB
   MOV AL,0                     //terminate with 0
   STOSB

   MOV EDI,[EBP+8]              //Destination Ansi String
   ADDD [EDI],8                 //AnsiString starts at offset 8
!Ansi_0_10:
   POP EDI
   POP ESI
   POP EDX
   POP ECX
   POP EBX
   POP EAX

   LEAVE
   RETN32 8
SYSTEM.!NewAnsiStr ENDP

//(NewValue,s)
SYSTEM.!NewAnsiStr0 PROC NEAR32
      PUSH EBP
      MOV EBP,ESP
      PUSH ESI

      MOV ESI,[EBP+8]   //Destination Ansi String
      MOVD [ESI],0

      PUSH DWORD PTR [EBP+12]  //String to assign
      PUSH ESI
      CALLN32 SYSTEM.!NewAnsiStr

      MOV ESI,[EBP+8]   //Destination Ansi String
      MOV ESI,[ESI]
      CMP ESI,0
      JE !Ansi0_exit
      MOVD [ESI-8],0       //reference count to 0
!Ansi0_exit:
      POP ESI
      LEAVE
      RETN32 8
SYSTEM.!NewAnsiStr0 ENDP

//(NewValue,s)
SYSTEM.!NewAnsiStrTemp PROC NEAR32
      PUSH EBP
      MOV EBP,ESP
      PUSH ESI

      MOV ESI,[EBP+8]               //Destination Ansi String
      MOVD [ESI],0

      PUSH DWORD PTR [EBP+12]       //String value to assign
      PUSH ESI
      CALLN32 SYSTEM.!NewAnsiStr

      MOV ESI,[EBP+8]               //Destination Ansi String
      MOV ESI,[ESI]
      CMP ESI,0
      JE !Ansi0_exit0
      MOVD [ESI-8],$F0000000       //reference count to $F0000000
!Ansi0_exit0:
      POP ESI
      LEAVE
      RETN32 8
SYSTEM.!NewAnsiStrTemp ENDP

//(Source,Dest)
SYSTEM.!AnsiCreate PROC NEAR32
     PUSH EBP
     MOV EBP,ESP
     PUSH EAX
     PUSH EBX
     PUSH ECX
     PUSH EDX
     PUSH ESI
     PUSH EDI

     MOV ESI,[EBP+12] //Source
     MOV EDI,[EBP+8]  //Dest
     MOV ESI,[ESI]
     MOVD [EDI],0     //Clear destination
     CMP ESI,0
     JE !No_Create
     PUSH ESI
     MOV EAX,[ESI-4]  //Get length
     ADD EAX,9        //8 byte for info + 1 Byte for zero terminator
     PUSH EDI
     PUSH EAX
     CALLN32 SYSTEM.GetMem

     POP ESI          //Source
     MOV EDI,[EBP+8]  //Dest
     MOV EDI,[EDI]
     SUB ESI,8
     MOV ECX,[ESI+4]  //get length
     ADD ECX,9        //8 byte for info + 1 Byte for zero terminator
     CLD
     MOV EDX,ECX
     SHR ECX,2
     REP
     MOVSD
     MOV ECX,EDX
     AND ECX,3
     REP
     MOVSB

     MOV EDI,[EBP+8]  //Dest
     MOV ESI,[EDI]
     ADDD [EDI],8     //AnsiString starts at offset 8
     MOVD [ESI],1     //reference count is 1
!No_Create:
     POP EDI
     POP ESI
     POP EDX
     POP ECX
     POP EBX
     POP EAX
     LEAVE
     RETN32 8
SYSTEM.!AnsiCreate ENDP

//Makes copies of parameters
//(Source)
SYSTEM.!AnsiCreate_Clear PROC NEAR32
     PUSH EBP
     MOV EBP,ESP
     SUB ESP,4

     PUSH EAX
     PUSH EBX
     PUSH ECX
     PUSH EDX
     PUSH ESI
     PUSH EDI

     MOV ESI,[EBP+8]         //Source
     MOV ESI,[ESI]
     PUSH ESI

     PUSH DWORD PTR [EBP+8]   //Source
     PUSH DWORD PTR [EBP+8]   //Dest
     CALLN32 SYSTEM.!AnsiCreate

     POP EDI
     MOV [EBP-4],EDI          //restore old value
     LEA ESI,[EBP-4]
     CALLN32 SYSTEM.!FreeConstAnsi
!cisok:
     POP EDI
     POP ESI
     POP EDX
     POP ECX
     POP EBX
     POP EAX
     LEAVE
     RETN32 4
SYSTEM.!AnsiCreate_Clear ENDP

//Makes copies of parameters for copy on write semantics s[index]:=...
//(Source)
SYSTEM.!AnsiCopy_Clear PROC NEAR32
     PUSH EBP
     MOV EBP,ESP
     SUB ESP,4

     PUSH EAX
     PUSH EBX
     PUSH ECX
     PUSH EDX
     PUSH ESI
     PUSH EDI

     MOV ESI,[EBP+8]         //Source
     MOV ESI,[ESI]
     CMPD [ESI-8],1          //only for strings with reference count >1
     JBE !cisok_cc
     PUSH ESI

     PUSH DWORD PTR [EBP+8]   //Source
     PUSH DWORD PTR [EBP+8]   //Dest
     CALLN32 SYSTEM.!AnsiCreate

     POP EDI
     MOV [EBP-4],EDI          //restore old value
     LEA ESI,[EBP-4]
     CALLN32 SYSTEM.!FreeAnsiStr
!cisok_cc:
     POP EDI
     POP ESI
     POP EDX
     POP ECX
     POP EBX
     POP EAX
     LEAVE
     RETN32 4
SYSTEM.!AnsiCopy_Clear ENDP

//(Source,Dest)
SYSTEM.!AnsiCreate0 PROC NEAR32
      PUSH EBP
      MOV EBP,ESP
      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH DWORD PTR [EBP+12]  //Source
      PUSH DWORD PTR [EBP+8]   //Dest
      CALLN32 SYSTEM.!AnsiCreate

      MOV ESI,[EBP+8]          //Dest
      MOV ESI,[ESI]
      CMP ESI,0
      JE !Ansi3_exit
      MOVD [ESI-8],0       //reference count to 0
!Ansi3_exit:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      POP EAX
      LEAVE
      RETN32 8
SYSTEM.!AnsiCreate0 ENDP

//(Source,Dest)
SYSTEM.!AnsiCopy PROC NEAR32
   PUSH EBP
   MOV EBP,ESP

   PUSH EAX
   PUSH EBX
   PUSH ECX
   PUSH EDX
   PUSH ESI
   PUSH EDI

   MOV ESI,[EBP+8]    //Dest
   MOV EDI,[EBP+12]   //Source
   MOV EDI,[EDI]
   CMP EDI,[ESI]
   JE !Ansi_0_3       //contents are equal

   CALLN32 SYSTEM.!FreeAnsiStr  //free dest str if reference count reaches 0

   MOV EDI,[EBP+12]   //Source
   MOV EDI,[EDI]
   CMP EDI,0
   JE !Ansi_0_3
   INCD [EDI-8]       //inc reference count
!Ansi_0_3:
   MOV [ESI],EDI

   POP EDI
   POP ESI
   POP EDX
   POP ECX
   POP EBX
   POP EAX

   LEAVE
   RETN32 8
SYSTEM.!AnsiCopy ENDP

//(Source,Dest,MaxLen)
SYSTEM.!AssignAnsi2Str PROC NEAR32
   PUSH EBP
   MOV EBP,ESP

   PUSH EAX
   PUSH EBX
   PUSH ECX
   PUSH EDX
   PUSH ESI
   PUSH EDI

   MOV EDI,[EBP+12]   //Dest
   MOVB [EDI],0
   MOV ESI,[EBP+16]   //Source
   MOV ESI,[ESI]
   CMP ESI,0
   JE !Ansi_0
   MOV ECX,[ESI-4]    //get length of Ansi String
   MOV EDX,[EBP+8]    //MaxLen
   CMP ECX,EDX
   JB !len_ok
   MOV ECX,EDX       //limit size
!len_ok:
   MOV [EDI],CL
   INC EDI
   CLD
   MOV EDX,ECX
   SHR ECX,2
   REP
   MOVSD
   MOV ECX,EDX
   AND ECX,3
   REP
   MOVSB

   //free Ansi if it has a length of 0
   MOV ESI,[EBP+16]    //Source
   MOV EDI,[ESI]
   CMPD [EDI-8],0
   JNE !Ansi_0
   CALLN32 SYSTEM.!FreeAnsiStr
!Ansi_0:
   POP EDI
   POP ESI
   POP EDX
   POP ECX
   POP EBX
   POP EAX

   LEAVE
   RETN32 12
SYSTEM.!AssignAnsi2Str ENDP

//(Source,Dest,MaxLen)
SYSTEM.!AssignAnsi2PChar PROC NEAR32
   PUSH EBP
   MOV EBP,ESP

   PUSH EAX
   PUSH EBX
   PUSH ECX
   PUSH EDX
   PUSH ESI
   PUSH EDI

   MOV EDI,[EBP+12]    //Dest
   MOVB [EDI],0
   MOV ESI,[EBP+16]    //Source
   MOV ESI,[ESI]
   CMP ESI,0
   JE !Ansi_0_1
   MOV ECX,[ESI-4]     //get length of Ansi String
   MOV EDX,[EBP+8]     //MaxLen
   CMP ECX,EDX
   JB !len_ok_1
   MOV ECX,EDX         //limit size
!len_ok_1:
   INC ECX             //copy with 0 terminator
   CLD
   MOV EDX,ECX
   SHR ECX,2
   REP
   MOVSD
   MOV ECX,EDX
   AND ECX,3
   REP
   MOVSB

   //free Ansi if it has a length of 0
   MOV ESI,[EBP+16]     //Source
   MOV EDI,[ESI]
   CMPD [EDI-8],0
   JNE !Ansi_0_1
   CALLN32 SYSTEM.!FreeAnsiStr
!Ansi_0_1:
   POP EDI
   POP ESI
   POP EDX
   POP ECX
   POP EBX
   POP EAX

   LEAVE
   RETN32 12
SYSTEM.!AssignAnsi2PChar ENDP

//(Source,Dest)
SYSTEM.!CSTRING2ANSI PROC NEAR32
   PUSH EBP
   MOV EBP,ESP

   PUSH EAX
   PUSH EBX
   PUSH ECX
   PUSH EDX
   PUSH ESI
   PUSH EDI

   MOV ESI,[EBP+8]    //Dest
   CALLN32 SYSTEM.!FreeAnsiStr  //free str if reference count reaches 0

   //clear dest string
   MOVD [ESI],0
   //determine length of CString
   MOV EDI,[EBP+12]  //Source
   MOV ECX,$0FFFFFFFF
   XOR AL,AL
   CLD
   REPNE
   SCASB
   NOT ECX
   DEC ECX          //without #0
   CMP ECX,0
   JE !Ansi_0_5     //empty cstring
   PUSH ECX

   PUSH DWORD PTR [EBP+8]  //Dest
   ADD ECX,9        //8 byte for info + 1 byte for terminating 0
   PUSH ECX
   CALLN32 SYSTEM.GetMem

   POP ECX
   MOV ESI,[EBP+8]  //Dest
   MOV EDI,[ESI]
   MOVD [EDI],1     //reference count to 1
   MOV [EDI+4],ECX  //set len
   ADD EDI,8        //String starts at offset 8
   MOV [ESI],EDI    //set destination
   MOV ESI,[EBP+12] //Source

   INC ECX          //copy with #0
   CLD
   MOV EDX,ECX
   SHR ECX,2
   REP
   MOVSD
   MOV ECX,EDX
   AND ECX,3
   REP
   MOVSB
!Ansi_0_5:
   POP EDI
   POP ESI
   POP EDX
   POP ECX
   POP EBX
   POP EAX

   LEAVE
   RETN32 8
SYSTEM.!CSTRING2ANSI ENDP

//(Source,Dest)
SYSTEM.!CSTRING2ANSI0 PROC NEAR32
      PUSH EBP
      MOV EBP,ESP
      PUSH ESI

      MOV ESI,[EBP+8] //Dest
      MOVD [ESI],0

      PUSH DWORD PTR [EBP+12] //Source
      PUSH ESI
      CALLN32 SYSTEM.!CString2Ansi

      MOV ESI,[EBP+8] //Dest
      MOV ESI,[ESI]
      CMP ESI,0
      JE !Ansi1_exit
      MOVD [ESI-8],0       //reference count to 0
!Ansi1_exit:
      POP ESI
      LEAVE
      RETN32 8
SYSTEM.!CSTRING2ANSI0 ENDP

//(Source,Dest)
SYSTEM.!CSTRING2ANSITemp PROC NEAR32
      PUSH EBP
      MOV EBP,ESP
      PUSH ESI

      MOV ESI,[EBP+8] //Dest
      MOVD [ESI],0

      PUSH DWORD PTR [EBP+12] //Source
      PUSH ESI
      CALLN32 SYSTEM.!CString2Ansi

      MOV ESI,[EBP+8] //Dest
      MOV ESI,[ESI]
      CMP ESI,0
      JE !Ansi1_exit0
      MOVD [ESI-8],$F0000000       //reference count to $F0000000
!Ansi1_exit0:
      POP ESI
      LEAVE
      RETN32 8
SYSTEM.!CSTRING2ANSITemp ENDP


END;

PROCEDURE UniqueStr(VAR S:AnsiString);
VAR s1:AnsiString;
BEGIN
     ASM
        MOV EDI,S
        MOV EDI,[EDI]
        CMP EDI,0
        JNE !Ansi_0_3_u
        LEAVE
        RETN32 4
!Ansi_0_3_u:
        CMPD [EDI-8],1       //check reference count
        JA !Ansi_0_3_u1
        LEAVE
        RETN32 4
!Ansi_0_3_u1:
        PUSH DWORD PTR S   //Source
        LEA EAX,s1         //Dest
        PUSH EAX
        CALLN32 SYSTEM.!AnsiCreate
     END;
     S:=s1;
END;


//General functions

{$HINTS OFF}
FUNCTION Assigned(p: Pointer): Boolean;ASSEMBLER;
ASM
  MOV EAX,p
  CMP EAX,0
  SETNE AL
  LEAVE
  RETN32 4
END;
{$HINTS ON}

PROCEDURE Check_Is(o:TObject;ClassInfo:TClass);
VAR bo:BOOLEAN;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH ESI
        PUSH EDI
     END;
     IF o=NIL THEN bo:=FALSE
     ELSE
     BEGIN
          IF ((ClassInfo<>NIL)AND(ClassInfo.ClassName='Exception')And
              (o.InheritsFrom(SysException))) THEN bo:=TRUE
          ELSE bo:=o.InheritsFrom(ClassInfo);
     END;
     ASM
        POP EDI
        POP ESI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
        CMPB bo,1
        LEAVE
        RETN32 8
     END;
END;

PROCEDURE Check_Is_Class(c:TClass;ClassInfo:TClass);
VAR bo:BOOLEAN;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH ESI
        PUSH EDI
     END;
     bo:=c.InheritsFrom(ClassInfo);
     ASM
        POP EDI
        POP ESI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
        CMPB bo,1
        LEAVE
        RETN32 8
     END;
END;

PROCEDURE Check_As(o:TObject;ClassInfo:TClass);
VAR Adr:LONGINT;
    e:EInvalidCast;
BEGIN
     ASM
        PUSHAD
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     IF not o.InheritsFrom(ClassInfo) THEN
     BEGIN
          e.Create('Invalid type cast (EInvalidCast)');
          e.CameFromRTL:=TRUE;
          e.RTLExcptAddr:=POINTER(Adr);
          raise e;
     END;
     ASM
        POPAD
        LEAVE
        RETN32 8
     END;
END;


PROCEDURE SelToFlat(VAR p:POINTER);
BEGIN
     asm
       mov edi,p
       mov eax,[edi+0]
       ror eax,16
       shr ax,3
       rol eax,16
       mov [edi+0],eax
    end;
END;


PROCEDURE OverflowError;
VAR e:EIntOverflow;
    Adr:LONGWORD;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     e.Create('Integer Overflow (EIntOverflow)');
     e.CameFromRTL:=TRUE;
     e.RTLExcptAddr:=POINTER(Adr);
     Raise e;
END;

VAR MinStack:LONGWORD;
    StackSize:LONGWORD;

PROCEDURE StackError(Adr:LONGWORD);
VAR e:EStackFault;
BEGIN
     e.Create('Stack overflow (EStackFault)');
     e.CameFromRTL:=TRUE;
     e.RTLExcptAddr:=POINTER(Adr);
     Raise e;
END;

PROCEDURE CheckStack(Needed:LONGWORD);
VAR ESP1:LONGWORD;
    Adr:LONGWORD;
BEGIN
     ASM
        PUSHAD
        MOV ESP1,ESP
        MOV EAX,[EBP+4]

        SUB EAX,5
        MOV Adr,EAX
     END;
     IF ESP1>MinStack THEN IF ESP1<MinStack+StackSize THEN
     BEGIN
          IF ((ESP1-Needed<MinStack)OR(ESP1-Needed>MinStack+StackSize))
            THEN StackError(Adr);
     END;
     ASM
        POPAD
     END;
END;

PROCEDURE RangeCheckError(Adr:LONGWORD);
VAR e:ERangeError;
BEGIN
     e.Create('Range check error (ERangeError)');
     e.CameFromRTL:=TRUE;
     e.RTLExcptAddr:=POINTER(Adr);
     Raise e;
END;

PROCEDURE CheckRange(U,O,V:LONGINT);
VAR Adr:LONGWORD;
BEGIN
     ASM
        PUSH EAX
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX

        MOV EAX,V
        CMP EAX,U
        JL !err_this_xxx
        MOV EAX,V
        CMP EAX,O
        JG !err_this_xxx

        POP EAX
        LEAVE
        RETN32 12
!err_this_xxx:
        POP EAX
        PUSH DWORD PTR Adr
        CALLN32 SYSTEM.RangeCheckError
     END;
END;

PROCEDURE CheckRangeUnsigned(U,O,V:LONGWORD);
VAR Adr:LONGWORD;
BEGIN
     ASM
        PUSH EAX
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX

        MOV EAX,V
        CMP EAX,U
        JB !err_this_xxx1
        MOV EAX,V
        CMP EAX,O
        JA !err_this_xxx1

        POP EAX
        LEAVE
        RETN32 12
!err_this_xxx1:
        POP EAX
        PUSH DWORD PTR Adr
        CALLN32 SYSTEM.RangeCheckError
     END;
END;

PROCEDURE CheckRange2(Nr,V:LONGINT);
VAR Adr:LONGWORD;
BEGIN
     ASM
         PUSH EAX
         MOV EAX,[EBP+4]
         SUB EAX,5
         MOV Adr,EAX

         MOV EAX,Nr
         CMP EAX,1
         JNE !my_lab1

         MOV EAX,V
         CMP EAX,MINSHORTINT
         JL !err_this_xxx2
         CMP EAX,MAXSHORTINT
         JG !err_this_xxx2
         jmp !ex_this_xxx
!my_lab1:
         CMP EAX,2
         JNE !my_lab2

         MOV EAX,V
         CMP EAX,MININT
         JL !err_this_xxx2
         CMP EAX,MAXINT
         JG !err_this_xxx2
         jmp !ex_this_xxx
!my_lab2:
         CMP EAX,4
         JNE !ex_this_xxx

         MOV EAX,V
         CMP EAX,MINLONGINT
         JL !err_this_xxx2
         CMP EAX,MAXLONGINT
         JG !err_this_xxx2
!ex_this_xxx:
         POP EAX
         LEAVE
         RETN32 8
!err_this_xxx2:
         POP EAX
         PUSH DWORD PTR Adr
         CALLN32 SYSTEM.RangeCheckError
     END;
END;

PROCEDURE CheckRangeUnsigned2(Nr,V:LONGWORD);
VAR Adr:LONGWORD;
BEGIN
     ASM
         PUSH EAX
         MOV EAX,[EBP+4]
         SUB EAX,5
         MOV Adr,EAX

         MOV EAX,Nr
         CMP EAX,1
         JNE !my_lab1w

         MOV EAX,V
         CMP EAX,MINBYTE
         JB !err_this_xxx2w
         CMP EAX,MAXBYTE
         JA !err_this_xxx2w
         jmp !ex_this_xxxw
!my_lab1w:
         CMP EAX,2
         JNE !my_lab2w

         MOV EAX,V
         CMP EAX,MINWORD
         JB !err_this_xxx2w
         CMP EAX,MAXWORD
         JA !err_this_xxx2w
         jmp !ex_this_xxxw
!my_lab2w:
         CMP EAX,4
         JNE !ex_this_xxxw

         MOV EAX,V
         CMP EAX,MINLONGWORD
         JB !err_this_xxx2w
         CMP EAX,MAXLONGWORD
         JA !err_this_xxx2w
!ex_this_xxxw:
         POP EAX
         LEAVE
         RETN32 8
!err_this_xxx2w:
         POP EAX
         PUSH DWORD PTR Adr
         CALLN32 SYSTEM.RangeCheckError
     END;
END;

FUNCTION Swap(i:INTEGER):INTEGER;
BEGIN
     Swap:=lo(i)*256+hi(i);
END;

VAR
   MaxWindMin: WORD;    { Max Window upper left coordinates  }
   MaxWindMax: WORD;    { Max Window lower right coordinates }
   Redirect,RedirectOut,RedirectIn:BOOLEAN;

//PM routines

{$IFDEF OS2}
IMPORTS
  FUNCTION WinMessageBox(hwndParent,hwndOwner:LONGWORD;pszText,pszCaption:CSTRING;
                         idWindow,flStyle:LONGWORD):LONGWORD;
                          APIENTRY;             'PMWIN' index 789;
END;

FUNCTION WinInitialize(flOptions:LONGWORD):LONGWORD;
VAR tib:PTIB;
    pib:PPIB;
LABEL l;
BEGIN
     DosGetInfoBlocks(tib,pib);
     IF ((tib<>NIL)AND(tib^.tib_ptib2<>NIL)) THEN
     BEGIN
          IF tib^.tib_ptib2^.tib2_ultid=1 THEN goto l; {1st thread}
          result:=WinInitializeAPI(flOptions);
     END
     ELSE
     BEGIN
l:
          IF AppHandleIntern=0 THEN AppHandleIntern:=WinInitializeAPI(flOptions);
          result:=AppHandleIntern;
     END;
END;

FUNCTION WinTerminate(ahab:LONGWORD):BOOLEAN;
BEGIN
     IF ahab=AppHandleIntern THEN
     BEGIN
          WinTerminate:=FALSE;
          exit;
     END;
     WinTerminate:=WinTerminateAPI(ahab);
END;

FUNCTION WinCreateMsgQueue(ahab:LONGWORD;cmsg:LONGINT):LONGWORD;
LABEL l;
BEGIN
     IF ahab=AppHandleIntern THEN
     BEGIN
         IF AppQueueHandleIntern<>0 THEN
         BEGIN
              IF cmsg<>0 THEN
              BEGIN
                   WinDestroyMsgQueueAPI(AppQueueHandleIntern);
                   goto l;
              END
              ELSE WinCreateMsgQueue:=AppQueueHandleIntern;
         END
         ELSE
         BEGIN
l:
              AppQueueHandleIntern:=WinCreateMsgQueueAPI(ahab,cmsg);
              result:=AppQueueHandleIntern;
         END;
     END
     ELSE result:=WinCreateMsgQueueAPI(ahab,cmsg);
END;

FUNCTION WinDestroyMsgQueue(ahmq:LONGWORD):BOOLEAN;
BEGIN
     IF ahmq=AppQueueHandleIntern THEN result:=FALSE
     ELSE result:=WinDestroyMsgQueueAPI(ahmq);
END;
{$ENDIF}

{$IFDEF Win32}
CONST
   ExcptList:PExcptInfo=NIL;
   ExcptMutex:LONGWORD=0;

TYPE
    PCOORD=^COORD;
    COORD=RECORD
                X:INTEGER;
                Y:INTEGER;
    END;

    PSMALL_RECT=^SMALL_RECT;
    SMALL_RECT=RECORD
                     Left:INTEGER;
                     Top:INTEGER;
                     Right:INTEGER;
                     Bottom:INTEGER;
    END;

    PCONSOLE_SCREEN_BUFFER_INFO=^CONSOLE_SCREEN_BUFFER_INFO;
    CONSOLE_SCREEN_BUFFER_INFO=RECORD
                                     dwSize:COORD;
                                     dwCursorPosition:COORD;
                                     wAttributes:WORD;
                                     srWindow:SMALL_RECT;
                                     dwMaximumWindowSize:COORD;
    END;

    PCHAR_INFO=^CHAR_INFO;
    CHAR_INFO=RECORD
                    Char:RECORD
                       CASE Integer OF
                           1:(UniCodeChar:WORD);
                           2:(AsciiChar:CHAR);
                    END;
                    Attributes:WORD;
    END;

CONST
     ENABLE_PROCESSED_INPUT =$0001;
     ENABLE_LINE_INPUT      =$0002;
     ENABLE_ECHO_INPUT      =$0004;
     ENABLE_WINDOW_INPUT    =$0008;
     ENABLE_MOUSE_INPUT     =$0010;

     ENABLE_PROCESSED_OUTPUT    =$0001;
     ENABLE_WRAP_AT_EOL_OUTPUT  =$0002;

IMPORTS
       FUNCTION SetFilePointer(hFile:LONGWORD;lDistanceToMove:LONGINT;
                               VAR lpDistanceToMoveHigh:LONGINT;
                               dwMoveMethod:LONGWORD):LONGWORD;
                  APIENTRY;  'KERNEL32' name 'SetFilePointer';
       FUNCTION WriteFile(hFile:LONGWORD;CONST lpBuffer;nNumberOfBytesToWrite:LONGWORD;
                          VAR lpNumberOfBytesWritten:LONGWORD;
                          VAR lpOverlapped):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'WriteFile';
       FUNCTION ReadFile(hFile:LONGWORD;VAR lpBuffer;nNumberOfBytesToRead:LONGWORD;
                         VAR lpNumberOfBytesRead:LONGWORD;
                         VAR lpOverlapped):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'ReadFile';
       FUNCTION CreateFile(CONST lpFileName:CSTRING;dwDesiredAccess:LONGWORD;
                           dwShareMode:LONGWORD;VAR lpSecurityAttributes;
                           deCreationDisposition,dwFlagsAndAttributes:LONGWORD;
                           hTemplateFile:LONGWORD):LONGWORD;
                  APIENTRY;  'KERNEL32' name 'CreateFileA';
       FUNCTION CloseHandle(hObject:LONGWORD):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'CloseHandle';
       FUNCTION SetCurrentDirectory(CONST lpPathName:CSTRING):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'SetCurrentDirectoryA';
       FUNCTION GetCurrentDirectory(nBufferLength:LONGWORD;VAR lpBuffer:CSTRING):LONGWORD;
                  APIENTRY;  'KERNEL32' name 'GetCurrentDirectoryA';
       FUNCTION RemoveDirectory(CONST lpPathName:CSTRING):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'RemoveDirectoryA';
       FUNCTION CreateDirectory(CONST lpPathName:CSTRING;
                                VAR lpSecurityAttributes):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'CreateDirectoryA';
       FUNCTION MoveFile(CONST lpExistingFileName,lpNewFileName:CSTRING):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'MoveFileA';
       FUNCTION DeleteFile(CONST lpFileName:CSTRING):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'DeleteFileA';
       FUNCTION SetEndOfFile(hFile:LONGWORD):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'SetEndOfFile';
       FUNCTION GetConsoleScreenBufferInfo(hConsoleOutput:LONGWORD;
                                    VAR lpConsoleScreenBufferInfo:CONSOLE_SCREEN_BUFFER_INFO):LONGBOOL;
             APIENTRY;  'KERNEL32' name 'GetConsoleScreenBufferInfo';
       FUNCTION FillConsoleOutputAttribute(hConsoleOutput:LONGWORD;wAttribute:WORD;
                                    nLength:LONGWORD;dwWriteCoord:LONGWORD;
                                    VAR lpNumberOfAttrsWritten:LONGWORD):LONGBOOL;
             APIENTRY;  'KERNEL32' name 'FillConsoleOutputAttribute';
       FUNCTION SetConsoleCursorPosition(hConsoleOutput:LONGWORD;dwCursorPosition:LONGWORD):LONGBOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleCursorPosition';
       FUNCTION GetStdHandle(nStdHandle:LONGWORD):LONGWORD;
                  APIENTRY;  'KERNEL32' name 'GetStdHandle';
       FUNCTION ReadConsoleOutputAttribute(hConsoleOutput:LONGWORD;VAR lpAttribute:WORD;
                                    nLength:LONGWORD;dwReadCoord:LONGWORD;
                                    VAR lpNumberOfAttrsRead:LONGWORD):LONGBOOL;
             APIENTRY;  'KERNEL32' name 'ReadConsoleOutputAttribute';
       FUNCTION SetConsoleMode(hConsoleHandle:LONGWORD;dwMode:LONGWORD):LONGBOOL;
             APIENTRY;  'KERNEL32' name 'SetConsoleMode';
       FUNCTION ScrollConsoleScreenBuffer(hConsoleOutput:LONGWORD;
                                   VAR lpScrollRectangle:SMALL_RECT;
                                   VAR lpClipRectangle:SMALL_RECT;
                                   dwDestinationOrigin:LONGWORD{COORD};
                                   CONST lpFill:CHAR_INFO):LONGBOOL;
             APIENTRY;  'KERNEL32' name 'ScrollConsoleScreenBufferA';
       FUNCTION WaitForSingleObject(hHandle:LONGWORD;dwMilliseconds:LONGWORD):LONGWORD;
                  APIENTRY;  'KERNEL32' name 'WaitForSingleObject';
       FUNCTION ReleaseMutex(hMutex:LONGWORD):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'ReleaseMutex';
       FUNCTION CreateMutex(VAR lpMutexAttributes;
                            bInitialOwner:LONGBOOL;CONST lpName:CSTRING):LONGWORD;
                  APIENTRY;  'KERNEL32' name 'CreateMutexA';
       FUNCTION SetUnhandledExceptionFilter(lpTopLevelFilter:POINTER):POINTER;
                  APIENTRY;  'KERNEL32' name 'SetUnhandledExceptionFilter';
       FUNCTION GetCurrentThreadId:LONGWORD;
                  APIENTRY;  'KERNEL32' name 'GetCurrentThreadId';
       PROCEDURE ExitProcess(RetCode:LONGWORD);
                             'KERNEL32' name 'ExitProcess';
END;

//************************************************************************
//
//
// Memory support management functions
//
//
//************************************************************************

IMPORTS
       FUNCTION GetLastError:LONGWORD;
                  APIENTRY;  'KERNEL32' name 'GetLastError';
       FUNCTION HeapCreate(flOptions:LONGWORD;dwInitialSize:LONGWORD;
                           dwMaximumSize:LONGWORD):POINTER;
                  APIENTRY;  'KERNEL32' name 'HeapCreate';
       FUNCTION HeapDestroy(hHeap:POINTER):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'HeapDestroy';
       FUNCTION GlobalAlloc(uFlags:LONGWORD;dwBytes:LONGWORD):POINTER;
                  APIENTRY;  'KERNEL32' name 'GlobalAlloc';
       FUNCTION GlobalFree(hMem:POINTER):POINTER;
                  APIENTRY;  'KERNEL32' name 'GlobalFree';
       FUNCTION HeapAlloc(hHeap:POINTER;dwFlags,dwBytes:LONGWORD):POINTER;
                  APIENTRY;  'KERNEL32' name 'HeapAlloc';
       FUNCTION HeapFree(hHeap:POINTER;dwFlags:LONGWORD;lpMem:POINTER):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'HeapFree';
       FUNCTION HeapValidate(hHeap:POINTER;dwFlags:LONGWORD;lpMem:POINTER):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'HeapValidate';
       FUNCTION GetMessage(VAR lpMsg;ahwnd,wMsgFilterMin,wMsgFilterMax:LONGWORD):LONGBOOL;
                APIENTRY; 'USER32' name 'GetMessageA';
       FUNCTION DispatchMessage(VAR lpMsg):LONGINT;
                APIENTRY; 'USER32' name 'DispatchMessageA';
       {Martin0407}
       FUNCTION VirtualAlloc(lpAddress:POINTER;dwSize:ULONG;flAllocationType:LONGWORD;
                             flProtect:ULONG):POINTER;
                  APIENTRY;  'KERNEL32' name 'VirtualAlloc';
       FUNCTION VirtualFree(lpAddress:POINTER;dwSize:ULONG;dwFreeType:ULONG):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'VirtualFree';

END;
{$ENDIF}

//Exception management

{The standard exception class}
FUNCTION SysException.GetMessage:STRING;
BEGIN
     GetMessage:=FMessage^;
END;

PROCEDURE SysException.SetMessage(CONST Value:STRING);
BEGIN
     IF FMessage<>NIL THEN
       FreeMem(FMessage,length(FMessage^)+1);
     GetMem(FMessage,length(value)+1);
     FMessage^:=value;
END;

CONSTRUCTOR SysException.Create(CONST msg:STRING);
BEGIN
     Inherited Create;

     Message:=msg;
END;

DESTRUCTOR SysException.Destroy;
BEGIN
     IF FMessage<>NIL THEN
       FreeMem(FMessage,length(FMessage^)+1);
     Inherited Destroy;
END;

PROCEDURE Abort;
BEGIN
     RAISE EAbort.Create('');
END;

{$IFDEF OS2}
//OS2 Exception numbers
CONST
     XCPT_GUARD_PAGE_VIOLATION       =$80000001;
     XCPT_DATATYPE_MISALIGNMENT      =$C000009E;
     XCPT_BREAKPOINT                 =$C000009F;
     XCPT_SINGLE_STEP                =$C00000A0;
     XCPT_ACCESS_VIOLATION           =$C0000005;
     XCPT_ILLEGAL_INSTRUCTION        =$C000001C;
     XCPT_FLOAT_DENORMAL_OPERAND     =$C0000094;
     XCPT_FLOAT_DIVIDE_BY_ZERO       =$C0000095;
     XCPT_FLOAT_INEXACT_RESULT       =$C0000096;
     XCPT_FLOAT_INVALID_OPERATION    =$C0000097;
     XCPT_FLOAT_OVERFLOW             =$C0000098;
     XCPT_FLOAT_STACK_CHECK          =$C0000099;
     XCPT_FLOAT_UNDERFLOW            =$C000009A;
     XCPT_INTEGER_DIVIDE_BY_ZERO     =$C000009B;
     XCPT_INTEGER_OVERFLOW           =$C000009C;
     XCPT_PRIVILEGED_INSTRUCTION     =$C000009D;
     XCPT_IN_PAGE_ERROR              =$C0000006;
     XCPT_PROCESS_TERMINATE          =$C0010001;
     XCPT_ASYNC_PROCESS_TERMINATE    =$C0010002;
     XCPT_NONCONTINUABLE_EXCEPTION   =$C0000024;
     XCPT_INVALID_DISPOSITION        =$C0000025;
     XCPT_INVALID_LOCK_SEQUENCE      =$C000001D;
     XCPT_ARRAY_BOUNDS_EXCEEDED      =$C0000093;
     XCPT_B1NPX_ERRATA_02            =$C0010004;
     XCPT_UNWIND                     =$C0000026;
     XCPT_BAD_STACK                  =$C0000027;
     XCPT_INVALID_UNWIND_TARGET      =$C0000028;
     XCPT_SIGNAL                     =$C0010003;

     XCPT_INTERNAL_RTL               =$E0000000;

{return values}
CONST
     XCPT_CONTINUE_SEARCH    =$00000000;     { exception not handled   }
     XCPT_CONTINUE_EXECUTION =$FFFFFFFF;     { exception handled       }
     XCPT_CONTINUE_STOP      =$00716668;     { exception handled by    }
                                             { debugger (VIA DosDebug) }

VAR
   RegisterInfo:STRING;

{$HINTS OFF}
{The exception handler. Incoming exceptions will come here first}
FUNCTION ExcptHandler(VAR p1:EXCEPTIONREPORTRECORD;
                      VAR p2:EXCEPTIONREGISTRATIONRECORD;
                      VAR p3:CONTEXTRECORD;
                      pv:POINTER):LONGWORD;CDECL;
BEGIN
  {Jump to the label set by setjmp}
  WITH p3 DO
    Registerinfo:= #13#10'at CS:EIP  ='+ToHex(ctx_SegCs )+':'+ToHex(ctx_RegEip);
  IF POINTER(p2.ObjectType)=NIL THEN {Kein Objekt dan /no object associated}
    BEGIN
      //Handle all hardware exceptions all other exceptions will be notified by an exception class
      CASE p1.ExceptionNum OF  // pruefe Ausnahen
        XCPT_BREAKPOINT:
          p2.ObjectType:=EBreakPoint.Create('Breakpoint exception (EBreakPoint) occured'+
                                            RegisterInfo);
        XCPT_BAD_STACK:
          p2.ObjectType:=EStackFault.Create('Stack fault exception (EStackFault) occured'+
                                            RegisterInfo);
        XCPT_ACCESS_VIOLATION:
          p2.ObjectType:=EGPFault.Create('Access violation exception (EGPFault) occured'+
                                           RegisterInfo);
        XCPT_IN_PAGE_ERROR:
          p2.ObjectType:=EPageFault.Create('Page fault exception (EPageFault) occured'+
                                           RegisterInfo);
        XCPT_ILLEGAL_INSTRUCTION,XCPT_PRIVILEGED_INSTRUCTION:
          p2.ObjectType:=EInvalidOpCode.Create('Invalid instruction exception (EInvalidOpCode) occured'+
                                               RegisterInfo);
        XCPT_SINGLE_STEP:
          p2.ObjectType:=ESingleStep.Create('Single step exception (ESingleStep) occured'+
                                            RegisterInfo);
        XCPT_INTEGER_DIVIDE_BY_ZERO:
          p2.ObjectType:=EDivByZero.Create('Integer divide by zero exception (EDivByZero) occured'+
                                           RegisterInfo);
        XCPT_INTEGER_OVERFLOW:
          p2.ObjectType:=EIntOverFlow.Create('Integer overflow exception (EIntOverFlow) occured'+
                                             RegisterInfo);
        XCPT_FLOAT_DIVIDE_BY_ZERO:
          p2.ObjectType:=EZeroDivide.Create('Float zero divide exception (EZeroDivide) occured'+
                                            RegisterInfo);
        XCPT_FLOAT_INVALID_OPERATION:
          p2.ObjectType:=EInvalidOp.Create('Float invalid operation exception (EInvalidOp) occured'+
                                           RegisterInfo);
        XCPT_FLOAT_OVERFLOW:
          p2.ObjectType:=EOverFlow.Create('Float overflow exception (EOverFlow) occured'+
                                          RegisterInfo);
        XCPT_FLOAT_UNDERFLOW:
          p2.ObjectType:=EUnderFlow.Create('Float underflow exception (EUnderFlow) occured'+
                                           RegisterInfo);
        XCPT_FLOAT_DENORMAL_OPERAND,XCPT_FLOAT_INEXACT_RESULT,
        XCPT_FLOAT_STACK_CHECK:
           p2.ObjectType:=EMathError.Create('General float exception (EMathError) occured'+
                                            RegisterInfo);
        XCPT_PROCESS_TERMINATE: {don't handle}
          BEGIN
            {p2.ObjectType:=EProcessTerm.Create('Process terminated exception (EProcessTerm) occured');}
            Result:=XCPT_CONTINUE_SEARCH;
            exit;
          END;
        XCPT_ASYNC_PROCESS_TERMINATE:  {Don't handle}
          BEGIN
            Result:=XCPT_CONTINUE_SEARCH;
            exit;
          END;
        XCPT_GUARD_PAGE_VIOLATION: {Don't handle}
          BEGIN
            Result:=XCPT_CONTINUE_SEARCH;
            exit;
          END;
        XCPT_ARRAY_BOUNDS_EXCEEDED:
          p2.ObjectType:=ERangeError.Create('Range check error exception (ERangeError) occured'+
                                            RegisterInfo);
        XCPT_INTERNAL_RTL:
          BEGIN
            Result:=XCPT_CONTINUE_EXECUTION;
            exit;
          END;
        ELSE  //unbekannte Ausnahme, weiterreichen an das System / Don't handle
          BEGIN
            Result:=XCPT_CONTINUE_SEARCH;
            exit;
            {p2.ObjectType:=EFault.Create('Unknown hardware exception (EFault) occured');}
          END;
      END; //case
    END;
  p2.ObjectType.ReportRecord:=p1;
  p2.ObjectType.RegistrationRecord:=p2;
  p2.ObjectType.ExcptNum:=p1.ExceptionNum;
  p2.ObjectType.ExcptAddr:=POINTER(p3.ctx_RegEIP);
  p2.ObjectType.ContextRecord:=p3;
  longjmp(p2.jmpWorker,LONGWORD(p2.ObjectType));
END;
{$HINTS ON}

IMPORTS
   FUNCTION DosRaiseException(VAR Pexcept:EXCEPTIONREPORTRECORD):LONGWORD;
                   APIENTRY;             'DOSCALLS' index 356;
END;

VAR ExceptDebugText:STRING;

PROCEDURE InitPM;
Begin
     If AppHandleIntern=0 Then If ApplicationType=cApplicationType_GUI Then
     Begin
          AppHandleIntern:=WinInitialize(0);
          AppQueueHandleIntern:=WinCreateMsgQueue(AppHandleIntern,0);
     End;
End;

PROCEDURE ExcptRunError(e:SysException);
VAR
   s:STRING;
   cs:CSTRING;
   cTitle:CSTRING;
   RepRec:EXCEPTIONREPORTRECORD;
BEGIN
     TRY
        IF e.CameFromRTL THEN IF not e.Nested THEN
        BEGIN
             e.Nested:=TRUE;
             RepRec.ExceptionNum:=XCPT_INTERNAL_RTL;
             RepRec.fHandlerFlags:=0;
             RepRec.NestedExceptionReportRecord:=NIL;
             RepRec.ExceptionAddress:=NIL;
             RepRec.cParameters:=2;
             RepRec.ExceptionInfo[0]:=LONGWORD(e.RTLExcptAddr);
             RepRec.ExceptionInfo[1]:=LONGWORD(e.FMessage);
             ExceptDebugText:=e.ClassName;
             RepRec.ExceptionInfo[2]:=LONGWORD(@ExceptDebugText);
             DosRaiseException(RepRec);
        END;
     FINALLY
        e.ExcptAddr:=e.RTLExcptAddr;
     END;

     IF POINTER(e.ExcptAddr)<>NIL THEN
       s:='Exception occured: '+e.Message+' at '+tohex(LONGWORD(e.ExcptAddr))+
           #13#10'Program is terminated.'
     ELSE
       s:='Exception occured: '+e.Message+
           #13#10'Program is terminated.';

     IF ApplicationType=cApplicationType_GUI THEN
     BEGIN
          cs:=s;
          cTitle:='Exception occured';
          InitPM;
          WinMessageBox(1,1,cs,ctitle,0,$4000 OR $0010);
     END
     ELSE Writeln(s);
     Halt;
END;

PROCEDURE RaiseException(objekt:SysException;adress:LONGWORD);
VAR
   PRegisRec:PEXCEPTIONREGISTRATIONRECORD;  {top exception registration record}
   ReportRec:EXCEPTIONREPORTRECORD;
   ContextRec:CONTEXTRECORD;
   RepRec:EXCEPTIONREPORTRECORD;
BEGIN
     ASM
        MOV ESI,0
        db $64   //SEG FS
        MOV EAX,[ESI+0]
        MOV PRegisRec,EAX
     END;

     IF LONGWORD(PRegisRec)=$ffffffff THEN {no handler installed}
     BEGIN
          ExcptRunError(objekt);
     END;

     PRegisRec^.ObjectType:=objekt;  {set exception type}
     {set up context record}
     fillchar(ContextRec,sizeof(CONTEXTRECORD),0);
     {set up report record}
     fillchar(ReportRec,sizeof(EXCEPTIONREPORTRECORD),0);
     IF Adress=0 THEN
     BEGIN
          ASM
             MOV EAX,[EBP+4]
             MOV Adress,EAX
          END;
     END;

     {Objekt.Nested:=TRUE;}
     {Objekt.CameFromRTL:=TRUE;}
     Objekt.RTLExcptAddr:=POINTER(Adress);
     RepRec.ExceptionNum:=XCPT_INTERNAL_RTL;
     RepRec.fHandlerFlags:=0;
     RepRec.NestedExceptionReportRecord:=NIL;
     RepRec.ExceptionAddress:=NIL;
     RepRec.cParameters:=2;
     RepRec.ExceptionInfo[0]:=LONGWORD(Objekt.RTLExcptAddr);
     RepRec.ExceptionInfo[1]:=LONGWORD(Objekt.FMessage);
     ExceptDebugText:=Objekt.ClassName;
     RepRec.ExceptionInfo[2]:=LONGWORD(@ExceptDebugText);
     DosRaiseException(RepRec);

     ReportRec.ExceptionAddress:=POINTER(Adress);
     ExcptHandler(ReportRec,PRegisRec^,ContextRec,NIL);
END;

PROCEDURE FreeExceptInstance(e:SysException);
BEGIN
     IF e<>NIL THEN e.Free;
END;

PROCEDURE RaiseExceptionAgain(e:SysException);
VAR
   PRegisRec:PEXCEPTIONREGISTRATIONRECORD;  {top exception registration record}
BEGIN
     IF ((e=NIL)OR(e is EAbort)) THEN exit;
     ASM
        MOV ESI,0
        db $64   //SEG FS
        MOV EAX,[ESI+0]
        MOV PRegisRec,EAX
     END;
     IF LONGWORD(PRegisRec)=$ffffffff THEN {no handler installed}
     BEGIN
          ExcptRunError(e);
     END;
     PRegisRec^.ObjectType:=e;  {set exception type}
     ExcptHandler(e.ReportRecord,PRegisRec^,e.ContextRecord,NIL);
END;

PROCEDURE Beep(Freq,duration:LONGWORD);
BEGIN
     ASM
         PUSH DWORD PTR duration
         PUSH DWORD PTR freq
         MOV AL,2
         CALLDLL DOSCALLS,286  //DosBeep
         ADD ESP,8
     END;
END;
{$ENDIF}

{$IFNDEF OS2}
PROCEDURE RequestExcptMutex;
BEGIN
    {$IFDEF Win32}
    IF ExcptMutex<>0 THEN
      WaitForSingleObject(ExcptMutex,$FFFFFFFF);
    {$ENDIF}
END;

PROCEDURE ReleaseExcptMutex;
BEGIN
     {$IFDEF Win32}
     IF ExcptMutex<>0 THEN
       ReleaseMutex(ExcptMutex);
     {$ENDIF}
END;
{$ENDIF}

{$IFDEF Win32}
//Win32 Exception numbers

CONST
     STATUS_WAIT_0                    =$00000000;
     STATUS_ABANDONED_WAIT_0          =$00000080;
     STATUS_USER_APC                  =$000000C0;
     STATUS_TIMEOUT                   =$00000102;
     STATUS_PENDING                   =$00000103;
     STATUS_GUARD_PAGE_VIOLATION      =$80000001;
     STATUS_DATATYPE_MISALIGNMENT     =$80000002;
     STATUS_BREAKPOINT                =$80000003;
     STATUS_SINGLE_STEP               =$80000004;
     STATUS_ACCESS_VIOLATION          =$C0000005;
     STATUS_IN_PAGE_ERROR             =$C0000006;
     STATUS_NO_MEMORY                 =$C0000017;
     STATUS_ILLEGAL_INSTRUCTION       =$C000001D;
     STATUS_NONCONTINUABLE_EXCEPTION  =$C0000025;
     STATUS_INVALID_DISPOSITION       =$C0000026;
     STATUS_ARRAY_BOUNDS_EXCEEDED     =$C000008C;
     STATUS_FLOAT_DENORMAL_OPERAND    =$C000008D;
     STATUS_FLOAT_DIVIDE_BY_ZERO      =$C000008E;
     STATUS_FLOAT_INEXACT_RESULT      =$C000008F;
     STATUS_FLOAT_INVALID_OPERATION   =$C0000090;
     STATUS_FLOAT_OVERFLOW            =$C0000091;
     STATUS_FLOAT_STACK_CHECK         =$C0000092;
     STATUS_FLOAT_UNDERFLOW           =$C0000093;
     STATUS_INTEGER_DIVIDE_BY_ZERO    =$C0000094;
     STATUS_INTEGER_OVERFLOW          =$C0000095;
     STATUS_PRIVILEGED_INSTRUCTION    =$C0000096;
     STATUS_STACK_OVERFLOW            =$C00000FD;
     STATUS_CONTROL_C_EXIT            =$C000013A;

CONST
     EXCEPTION_ACCESS_VIOLATION     =STATUS_ACCESS_VIOLATION;
     EXCEPTION_DATATYPE_MISALIGNMENT=STATUS_DATATYPE_MISALIGNMENT;
     EXCEPTION_BREAKPOINT           =STATUS_BREAKPOINT;
     EXCEPTION_SINGLE_STEP          =STATUS_SINGLE_STEP;
     EXCEPTION_ARRAY_BOUNDS_EXCEEDED=STATUS_ARRAY_BOUNDS_EXCEEDED;
     EXCEPTION_FLT_DENORMAL_OPERAND =STATUS_FLOAT_DENORMAL_OPERAND;
     EXCEPTION_FLT_DIVIDE_BY_ZERO   =STATUS_FLOAT_DIVIDE_BY_ZERO;
     EXCEPTION_FLT_INEXACT_RESULT   =STATUS_FLOAT_INEXACT_RESULT;
     EXCEPTION_FLT_INVALID_OPERATION=STATUS_FLOAT_INVALID_OPERATION;
     EXCEPTION_FLT_OVERFLOW         =STATUS_FLOAT_OVERFLOW;
     EXCEPTION_FLT_STACK_CHECK      =STATUS_FLOAT_STACK_CHECK;
     EXCEPTION_FLT_UNDERFLOW        =STATUS_FLOAT_UNDERFLOW;
     EXCEPTION_INT_DIVIDE_BY_ZERO   =STATUS_INTEGER_DIVIDE_BY_ZERO;
     EXCEPTION_INT_OVERFLOW         =STATUS_INTEGER_OVERFLOW;
     EXCEPTION_PRIV_INSTRUCTION     =STATUS_PRIVILEGED_INSTRUCTION;
     EXCEPTION_IN_PAGE_ERROR        =STATUS_IN_PAGE_ERROR;
     EXCEPTION_ILLEGAL_INSTRUCTION  =STATUS_ILLEGAL_INSTRUCTION;
     EXCEPTION_NONCONTINUABLE_EXCEPTION=STATUS_NONCONTINUABLE_EXCEPTION;
     EXCEPTION_STACK_OVERFLOW       =STATUS_STACK_OVERFLOW;
     EXCEPTION_INVALID_DISPOSITION  =STATUS_INVALID_DISPOSITION;
     EXCEPTION_GUARD_PAGE           =STATUS_GUARD_PAGE_VIOLATION;
     CONTROL_C_EXIT                 =STATUS_CONTROL_C_EXIT;
                                             { debugger (VIA DosDebug) }

     EXCEPTION_INTERNAL_RTL         =$E0000000;

{return values}
CONST
     EXCEPTION_EXECUTE_HANDLER       = 1;
     EXCEPTION_CONTINUE_SEARCH       = 0;
     EXCEPTION_CONTINUE_EXECUTION    =-1;

VAR
   RegisterInfo:STRING;

{$HINTS OFF}
PROCEDURE NewExceptionFilter(ExcptInfo:PExcptInfo);
VAR Dummy:PExcptInfo;
BEGIN
     exit;
     ExcptInfo^.Next:=NIL;
     ExcptInfo^.ExcptObject:=NIL;
     ASM
        MOV EDI,ExcptInfo
        ADD EDI,8
        MOV EAX,[EBP+0]     //old EBP
        MOV [EDI+0],EAX
        MOV EAX,EBP
        ADD EAX,12         //Old ESP
        MOV [EDI+4],EAX
        FSTCW [EDI+8]      //Old FPU Control
     END;

     RequestExcptMutex;

     IF ExcptList=NIL THEN
     BEGIN
          ExcptList:=ExcptInfo;
          ExcptList^.Last:=NIL;
     END
     ELSE
     BEGIN
          dummy:=ExcptList;
          WHILE dummy^.next<>NIL DO dummy:=dummy^.Next;
          dummy^.Next:=ExcptInfo;
          dummy^.Next^.Last:=Dummy;
     END;

     ReleaseExcptMutex;
END;
{$HINTS ON}

PROCEDURE ReleaseExceptionFilter(ExcptInfo:PExcptInfo);
VAR Dummy:PExcptInfo;
LABEL l;
BEGIN
     RequestExcptMutex;

     dummy:=ExcptList;
     WHILE dummy<>NIL DO
     BEGIN
          IF dummy=ExcptInfo THEN
          BEGIN
               IF dummy^.Last=NIL THEN
               BEGIN
                    ExcptList:=dummy^.Next;
                    IF ExcptList<>NIL THEN ExcptList^.Last:=NIL;
               END
               ELSE
               BEGIN
                    IF dummy^.Next<>NIL THEN
                        dummy^.Next^.Last:=dummy^.Last;
                    dummy^.Last^.Next:=dummy^.Next;
               END;
               goto l;
          END;
          dummy:=dummy^.Next;
     END;
l:
     ReleaseExcptMutex;
END;

{The exception handler. Incoming exceptions will come here first}
{$HINTS OFF}
FUNCTION ExcptHandler(VAR ExceptionInfo:EXCEPTION_POINTERS):LONGINT;APIENTRY;
VAR Dummy:PExcptInfo;
    ExcptAddr:POINTER;
    Found:PExcptInfo;
    ThreadId:LONGWORD;
LABEL l,l1;
BEGIN
     IF ExcptList=NIL THEN
     BEGIN
l:
          result:=EXCEPTION_CONTINUE_SEARCH;  //terminate process
          exit;
     END
     ElSE
     BEGIN
          IF ExceptionInfo.ExceptionRecord^.ExceptionFlags=EXCEPTION_NONCONTINUABLE
            THEN goto l; {dont handle}

          ThreadId:=GetCurrentThreadId;

          {Search exception handler}
          RequestExcptMutex;

          ExcptAddr:=ExceptionInfo.ExceptionRecord^.ExceptionAddress;

          dummy:=ExcptList;
          WHILE dummy^.Next<>NIL DO dummy:=dummy^.Next;
          Found:=NIL;
          WHILE dummy<>NIL DO
          BEGIN
               {IF LONGWORD(ExcptAddr)>=LONGWORD(dummy^.TryAddr) THEN
                 IF LONGWORD(ExcptAddr)<=LONGWORD(dummy^.ExcptAddr) THEN
                   Found:=dummy;}
               IF dummy^.ThreadId=ThreadId THEN
               BEGIN
                    Found:=dummy;
                    goto l1;
               END;

               dummy:=dummy^.Last;
          END;
l1:
          IF Found=NIL THEN
            IF ExcptList<>NIL THEN Found:=ExcptList;

          ReleaseExcptMutex;

          IF Found=NIL THEN goto l;

          Registerinfo:= #13#10'at CS:EIP  ='+
                    ToHex(LONGWORD(ExceptionInfo.ContextRecord^.SegCS))+':'
                    +ToHex(LONGWORD(ExcptAddr));
     END;

     //Handle all hardware exceptions
     //all other exceptions will be notified by an exception class
     CASE ExceptionInfo.ExceptionRecord^.ExceptionCode OF
              EXCEPTION_BREAKPOINT:
                Found^.ExcptObject:=EBreakPoint.Create('Breakpoint exception (EBreakPoint) occured'+
                                                  RegisterInfo);
              EXCEPTION_STACK_OVERFLOW:
                Found^.ExcptObject:=EStackFault.Create('Stack fault exception (EStackFault) occured'+
                                                  RegisterInfo);
              EXCEPTION_ACCESS_VIOLATION:
                Found^.ExcptObject:=EGPFault.Create('Access violation exception (EGPFault) occured'+
                                               RegisterInfo);
              EXCEPTION_IN_PAGE_ERROR:
                Found^.ExcptObject:=EPageFault.Create('Page fault exception (EPageFault) occured'+
                                                 RegisterInfo);
              EXCEPTION_ILLEGAL_INSTRUCTION,EXCEPTION_PRIV_INSTRUCTION:
                Found^.ExcptObject:=EInvalidOpCode.Create('Invalid instruction exception (EInvalidOpCode) occured'+
                                                 RegisterInfo);
              EXCEPTION_SINGLE_STEP:
                Found^.ExcptObject:=ESingleStep.Create('Single step exception (ESingleStep) occured'+
                                                 RegisterInfo);
              EXCEPTION_INT_DIVIDE_BY_ZERO:
                Found^.ExcptObject:=EDivByZero.Create('Integer divide by zero exception (EDivByZero) occured'+
                                                 RegisterInfo);
              EXCEPTION_INT_OVERFLOW:
                Found^.ExcptObject:=EIntOverFlow.Create('Integer overflow exception (EIntOverFlow) occured'+
                                                 RegisterInfo);
              EXCEPTION_FLT_DIVIDE_BY_ZERO:
                Found^.ExcptObject:=EZeroDivide.Create('Float zero divide exception (EZeroDivide) occured'+
                                                 RegisterInfo);
              EXCEPTION_FLT_INVALID_OPERATION:
                Found^.ExcptObject:=EInvalidOp.Create('Float invalid operation exception (EInvalidOp) occured'+
                                                 RegisterInfo);
              EXCEPTION_FLT_OVERFLOW:
                Found^.ExcptObject:=EOverFlow.Create('Float overflow exception (EOverFlow) occured'+
                                                 RegisterInfo);
              EXCEPTION_FLT_UNDERFLOW:
                Found^.ExcptObject:=EUnderFlow.Create('Float underflow exception (EUnderFlow) occured'+
                                                 RegisterInfo);
              EXCEPTION_FLT_DENORMAL_OPERAND,EXCEPTION_FLT_INEXACT_RESULT,
              EXCEPTION_FLT_STACK_CHECK:
                 Found^.ExcptObject:=EMathError.Create('General float exception (EMathError) occured'+
                                                 RegisterInfo);
              EXCEPTION_ARRAY_BOUNDS_EXCEEDED:
                 Found^.ExcptObject:=ERangeError.Create('Range check error exception (ERangeError) occured'+
                                                 RegisterInfo);
              EXCEPTION_INTERNAL_RTL:
              BEGIN
                   //Found^.ExcptObject already set !
                   //result:=EXCEPTION_CONTINUE_EXECUTION;
                   //exit;
              END;
              ELSE goto l; {Don't handle}
     END; {case}

     {Win32 generated exception}
     Found^.ExcptObject.ReportRecord:=ExceptionInfo.ExceptionRecord^;
     Found^.ExcptObject.ExcptNum:=ExceptionInfo.ExceptionRecord^.ExceptionCode;
     Found^.ExcptObject.ContextRecord:=ExceptionInfo.ContextRecord^;
     Found^.ExcptObject.ExcptAddr:=ExcptAddr;

     {Jump to the label set by try}
     ExceptionInfo.ContextRecord^.EAX:=LONGWORD(Found^.ExcptObject);
     ExceptionInfo.ContextRecord^.EIP:=LONGWORD(Found^.ExcptAddr);
     ExceptionInfo.ContextRecord^.EBP:=Found^.OldEBP;
     ExceptionInfo.ContextRecord^.ESP:=Found^.OldESP;
     ExceptionInfo.ContextRecord^.FloatSave.ControlWord:=Found^.OldFPUControl;
     result:=EXCEPTION_CONTINUE_EXECUTION;  //run except handling
END;
{$HINTS ON}

IMPORTS
     PROCEDURE RaiseExceptionAPI(dwExceptionCode,dwExceptionFlags:LONGWORD;
                              nNumberOfArguments:LONGWORD;VAR lpArguments);
                  APIENTRY;  'KERNEL32' name 'RaiseException';
    FUNCTION MessageBox(ahwnd:LONGWORD;CONST lpText,lpCaption:CSTRING;
                        uType:LONGWORD):LONGWORD;
               APIENTRY; 'USER32' name 'MessageBoxA';
END;

{$HINTS OFF}
PROCEDURE ExcptRunError(e:SysException);
VAR
   s:STRING;
   cs:CSTRING;
   cTitle:CSTRING;
   Arguments:ARRAY[0..1] OF LONGWORD;
Label go;
BEGIN
     If e=Nil Then
     BEGIN
          s:='Unhandled Debugger Exception';
          goto go;
     END;

     try
        IF e.CameFromRTL THEN IF not e.Nested THEN
        BEGIN
             e.Nested:=TRUE;
             Arguments[0]:=LONGWORD(e.RTLExcptAddr);
             Arguments[1]:=LONGWORD(e.FMessage);
             RaiseExceptionAPI(EXCEPTION_INTERNAL_RTL,0,2,Arguments);

             //If RaiseExceptionAPI returns from call, the exception was
             //not transferred to a handler, so we do it manually :-(
             goto go;
        END;
     finally
        e.ExcptAddr:=e.RTLExcptAddr;
     end;

     IF POINTER(e.ExcptAddr)<>NIL THEN
       s:='Exception occured: '+e.Message+' at '+tohex(LONGWORD(e.ExcptAddr))+
           #13#10'Program is terminated.'
     ELSE
       s:='Exception occured: '+e.Message+
           #13#10'Program is terminated.';
go:
     IF ApplicationType=cApplicationType_GUI THEN
     BEGIN
          cs:=s;
          cTitle:='Exception occured';
          MessageBox(0,cs,ctitle,0);
     END
     ELSE Writeln(s);
     Halt;
END;
{$HINTS ON}

CONST ProcessDebugged:Boolean=FALSE;

PROCEDURE RaiseException(objekt:SysException;adress:LONGWORD);
VAR ExcptAddr:POINTER;
    dummy,Found:PExcptInfo;
    ThreadId:LONGWORD;
    Arguments:ARRAY[0..1] OF LONGWORD;
LABEL l1;
BEGIN
     IF Adress=0 THEN
     BEGIN
          ASM
             MOV EAX,[EBP+4]
             MOV Adress,EAX
          END;
     END;

     ThreadId:=GetCurrentThreadId;

     {Search exception handler}
     RequestExcptMutex;

     ExcptAddr:=POINTER(Adress);

     dummy:=ExcptList;
     IF dummy<>NIL THEN WHILE dummy^.Next<>NIL DO dummy:=dummy^.Next;
     Found:=NIL;
     WHILE dummy<>NIL DO
     BEGIN
          {IF LONGWORD(ExcptAddr)>=LONGWORD(dummy^.TryAddr) THEN
            IF LONGWORD(ExcptAddr)<=LONGWORD(dummy^.ExcptAddr) THEN
               Found:=dummy;}
          IF dummy^.ThreadId=ThreadId THEN
          BEGIN
               Found:=dummy;
               goto l1;
          END;

          dummy:=dummy^.Last;
     END;
l1:
     IF Found=NIL THEN
        IF ExcptList<>NIL THEN Found:=ExcptList;

     ReleaseExcptMutex;

     IF Found=NIL THEN ExcptRunError(Objekt);

     Found^.ExcptObject:=Objekt;

     Objekt.RTLExcptAddr:=Pointer(Adress);
     Arguments[0]:=LongWord(Objekt.RTLExcptAddr);
     Arguments[1]:=LONGWORD(Objekt.FMessage);

     //If this process is debugged, give the debugger a chance to handle
     //the exception
     If ProcessDebugged Then
       RaiseExceptionAPI(EXCEPTION_INTERNAL_RTL,0,2,Arguments);

     //If RaiseExceptionAPI returns from call, the exception was
     //not transferred to a handler, so we do it manually :-(
     ASM
        MOV EAX,Objekt
        MOV EDI,Found
        PUSH DWORD PTR [EDI+8]    //old EBP
        POP EBP
        MOV ESP,[EDI+12] //old ESP
        FLDCW [EDI+16]   //old FPU Control Word
        FWAIT

        JMP [EDI+4]        //jump into exception handler
     END;
END;

PROCEDURE FreeExceptInstance(e:SysException);
BEGIN
     IF e<>NIL THEN e.Free;
END;

PROCEDURE RaiseExceptionAgain(e:SysException);
BEGIN
     IF e=NIL THEN exit;
     RaiseException(e,LONGWORD(e.ExcptAddr));
END;

PROCEDURE Beep(Freq,duration:LONGWORD);
BEGIN
     ASM
         PUSH DWORD PTR duration
         PUSH DWORD PTR freq
         CALLDLL KERNEL32,'Beep'
     END;
END;
{$ENDIF}

//File I/O support
{$IFDEF OS2}
TYPE
    PFEA2=^FEA2;
    FEA2=RECORD {pack 1}
                 oNextEntryOffset:LONGWORD;    { new field }
                 fEA:BYTE;
                 cbName:BYTE;
                 cbValue:WORD;
                 szName:CSTRING[1];    { new field }
    END;

    PFEA2LIST=^FEA2LIST;
    FEA2LIST=RECORD {pack 1}
                   cbList:LONGWORD;
                   list:ARRAY[0..0] OF FEA2;
    END;

    PGEA2=^GEA2;
    GEA2=RECORD {pack 1}
                 oNextEntryOffset:LONGWORD;  { new field }
                 cbName:BYTE;
                 szName:ARRAY[0..0] OF BYTE; { new field }
    END;

    PGEA2LIST=^GEA2LIST;
    GEA2LIST=RECORD      { pack 1 }
                   cbList:LONGWORD;
                   list:ARRAY [0..0] OF GEA2;
    END;

    PEAOP2=^EAOP2;
    EAOP2=RECORD  { pack 1 }
                fpGEA2List:PGEA2LIST;       { GEA set }
                fpFEA2List:PFEA2LIST;       { FEA set }
                oError:LONGWORD;            { offset of FEA error }
    END;

CONST
     MAX_GEA         = 500;  // Max size for a GEA List

IMPORTS
   FUNCTION DosOpen(pszFileName:CSTRING;VAR pHf:LONGWORD;VAR pulAction:LONGWORD;
                    cbFile,ulAttribute,fsOpenFlags,fsOpenMode:LONGWORD;
                    VAR apeaop2{:EAOP2}):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 273;
   FUNCTION DosEnumAttribute(ulRefType:LONGWORD;VAR pvFile;ulEntry:LONGWORD;
                             VAR pvBuf;cbBuf:LONGWORD;VAR pulCount:LONGWORD;
                             ulInfoLevel:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 372;
   FUNCTION DosQueryPathInfo(VAR pszPathName:CSTRING;ulInfoLevel:LONGWORD;
                             VAR pInfoBuf;cbInfoBuf:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 223;
   FUNCTION DosQueryFileInfo(hf:LONGWORD;ulInfoLevel:LONGWORD;
                             VAR pInfo;cbInfoBuf:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 279;
   FUNCTION DosSetPathInfo(pszPathName:CSTRING;ulInfoLevel:LONGWORD;VAR pInfoBuf;
                        cbInfoBuf,flOptions:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 219;
   FUNCTION DosSetFileInfo(hf:LONGWORD;ulInfoLevel:LONGWORD;VAR pInfoBuf;
                        cbInfoBuf:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 218;
   FUNCTION DosClose(ahFile:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 257;
   FUNCTION DosSetFilePtr(ahFile:LONGWORD;ib:LONGINT;method:LONGWORD;
                       VAR ibActual:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 256;
   FUNCTION DosCreateDir(pszDirName:CSTRING;VAR apeaop2:EAOP2):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 270;
   FUNCTION DosDeleteDir(pszDir:CSTRING):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 226;
   FUNCTION DosSetDefaultDisk(disknum:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 220;
   FUNCTION DosQueryCurrentDisk(VAR pdisknum,plogical:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 275;
   FUNCTION DosSetCurrentDir(pszDir:CSTRING):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 255;
   FUNCTION DosQueryCurrentDir_API(disknum:LONGWORD;VAR pBuf;
                            VAR pcbBuf:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 274;
   FUNCTION DosRead(ahFile:LONGWORD;VAR pBuffer;cbRead:LONGWORD;
                 VAR pcbActual:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 281;
   FUNCTION DosWrite(ahFile:LONGWORD;VAR pBuffer;cbWrite:LONGWORD;
                  VAR pcbActual:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 282;
   FUNCTION DosMove(VAR pszOld,pszNew:CSTRING):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 271;
   FUNCTION DosSetFileSize(ahFile:LONGWORD;cbSize:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 272;
   FUNCTION DosDelete(VAR pszFile:CSTRING):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 259;
END;

FUNCTION DosQueryCurrentDir(disknum:LONGWORD;VAR pBuf;
                            VAR pcbBuf:LONGWORD):LONGWORD;
BEGIN
     ASM
        xor eax,eax
        db $64,$ff,$30  //pushd fs:[eax]
     END;
     result:=DosQueryCurrentDir_API(disknum,pBuf,pcbBuf);
     ASM
        xor eax,eax
        db $64,$8f,$00  //popd fs:[eax]
     END;
END;
{$ENDIF}

FUNCTION IOResult: Integer;
BEGIN
  {$IFDEF OS2}
  case InOutRes of
  19: Result:=150;
  21: Result:=152;
  23: Result:=154;
  25: Result:=156;
  26: Result:=157;
  27: Result:=158;
  32: Result:=5;
  33: Result:=5;
  110: Result:=2;
  else Result:=InOutRes;
  end;
  {$ENDIF}
  {$IFDEF Win32}
  result:=InOutRes;
  {$ENDIF}
  InOutRes:=0;
END;

{$IFDEF OS2}
FUNCTION OS2Result: Integer;
BEGIN
  OS2Result:=InOutRes;
  InOutRes:=0;
END;
{$ENDIF}

VAR
   FileBufSize:LONGWORD;  {Standard file buffer size (32768 bytes}

PROCEDURE Assign(VAR f:FILE;CONST s:String);
VAR ff:^FileRec;
BEGIN
     ff:=@f;
     fillchar(f,sizeof(f),0);
     ff^.Name:=s;                  {Assign name to file variable}
     ff^.Flags:=$6666;             {File successfully assigned}
     ff^.Handle:=$ffffffff;        {No valid handle}
     ff^.MaxCacheMem:=FileBufSize; {Initial bufsize}
     ff^.Buffer:=NIL;
     IF ff^.MaxCacheMem<16 THEN ff^.MaxCacheMem:=16;
     InOutRes:=0;                  {Clear InOutRes variable}
END;

PROCEDURE AssignFile(VAR f:FILE;CONST s:String);
BEGIN
     Assign(f,s);
END;

PROCEDURE InvalidFileNameError(Adr:LONGINT);
VAR
   e:EInvalidFileName;
BEGIN
     e.Create('Invalid file name (EInvalidFileName)');
     e.CameFromRTL:=TRUE;
     e.RTLExcptAddr:=POINTER(Adr);
     e.ErrorCode:=206; {filename exceeds range}
     RAISE e;
END;

PROCEDURE InOutError(Code:LONGWORD;Adr:LONGWORD);
VAR
   e:EInOutError;
BEGIN
     e.Create('Input/Output error (EInOutError)');
     e.ErrorCode:=code;
     e.CameFromRTL:=TRUE;
     e.RTLExcptAddr:=POINTER(Adr);
     RAISE e;
END;

CONST
     {Modes for FileBlockIO}
     ReadMode        = 1;
     WriteMode       = 2;

PROCEDURE FileBlockIO(VAR f:FILE;BlockNr:LONGWORD;Mode:LONGWORD;
                      VAR result:LONGWORD);
VAR
   l:LONGWORD;
   po:LONGWORD;
   temp:LONGWORD;
   ff:^FileRec;
BEGIN
     ff:=@f;
     InOutRes:=0;
     IF ff^.changed THEN
     BEGIN
          ff^.changed:=FALSE;
          FileBlockIO(f,ff^.block,WriteMode,Temp);
          IF InOutRes<>0 THEN exit;
     END;

     IF blocknr=ff^.LBlock THEN l:=ff^.LOffset
     ELSE l:=ff^.MaxCacheMem;
     po:=ff^.MaxCacheMem*blocknr;
     {$IFDEF OS2}
     InOutRes:=DosSetFilePtr(ff^.Handle,po,0,Temp);
     {$ENDIF}
     {$IFDEF Win32}
     Temp:=SetFilePointer(ff^.Handle,po,NIL,0);  //Seek from file BEGIN
     IF Temp=$ffffffff THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN exit;

     IF l>0 THEN
     BEGIN
          CASE Mode OF
              WriteMode:
              BEGIN
                   {$IFDEF OS2}
                   InOutRes:=DosWrite(ff^.Handle,ff^.Buffer^,l,result);
                   {$ENDIF}
                   {$IFDEF Win32}
                   IF not WriteFile(ff^.Handle,ff^.Buffer^,l,result,NIL) THEN
                   BEGIN
                       InOutRes:=GetLastError;
                       IF InOutRes=0 THEN InOutRes:=1;
                   END;
                   {$ENDIF}
              END;
              ReadMode:
              BEGIN
                   {$IFDEF OS2}
                   InOutRes:=DosRead(ff^.Handle,ff^.Buffer^,l,result);
                   {$ENDIF}
                   {$IFDEF Win32}
                   IF not ReadFile(ff^.Handle,ff^.Buffer^,l,result,NIL) THEN
                   BEGIN
                        InOutRes:=GetLastError;
                        IF InOutRes=0 THEN InOutRes:=1;
                   END;
                   {$ENDIF}
              END;
          END; {case}
     END;
END;

FUNCTION FileFileSize(VAR f:FILE):LONGWORD;
VAR
   ff:^FileRec;
   Temp,Temp1,Temp2:LONGWORD;
BEGIN
     ff:=@f;

     {$IFDEF OS2}
     InOutRes:=DosSetFilePtr(ff^.Handle,0,1,Temp);
     {$ENDIF}
     {$IFDEF Win32}
     Temp:=SetFilePointer(ff^.Handle,0,NIL,1); //get current pos
     IF Temp=$ffffffff THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN exit;

     //get file length
     {$IFDEF OS2}
     InOutRes:=DosSetFilePtr(ff^.Handle,0,2,Temp1);
     {$ENDIF}
     {$IFDEF Win32}
     Temp1:=SetFilePointer(ff^.Handle,0,NIL,2); //get length
     IF Temp1=$ffffffff THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN exit;

     {$IFDEF OS2}
     InOutRes:=DosSetFilePtr(ff^.Handle,Temp,0,Temp2);
     {$ENDIF}
     {$IFDEF Win32}
     Temp2:=SetFilePointer(ff^.Handle,Temp,NIL,0); //restore position
     IF Temp2=$ffffffff THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN exit;

     FileFileSize:=Temp1;
END;

FUNCTION FileFilePos(VAR f:FILE):LONGWORD;
VAR
   ff:^FileRec;
   Temp:LONGWORD;
BEGIN
     ff:=@f;

     {$IFDEF OS2}
     InOutRes:=DosSetFilePtr(ff^.Handle,0,1,Temp);
     {$ENDIF}
     {$IFDEF Win32}
     Temp:=SetFilePointer(ff^.Handle,0,NIL,1);
     IF Temp=$ffffffff THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN exit;

     FileFilePos:=Temp;
END;

VAR OpenedFiles:ARRAY[0..256] OF LONGWORD; {Handles for opened files}
    OpenedFilesCount:BYTE;

PROCEDURE Rewrite(VAR f:FILE;recsize:LONGWORD);
VAR ff:^FileRec;
    c:CSTRING;
    e:EFileNotFound;
    Size,Temp:LONGWORD;
    SaveIOError:BOOLEAN;
    Adr:LONGWORD;

{$IFDEF OS2}
    action : LongWord;
{$ENDIF}

BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     InOutRes:=0;
     ff:=@f;
     ff^.RecSize:=recsize;

     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle<>$ffffffff THEN
     BEGIN
         {Close file first}
         SaveIoError:=RaiseIOError;
         RaiseIOError:=FALSE;
         Close(f);
         RaiseIoError:=SaveIoError;
         (*InOutRes:=85; {File already assigned}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;*)
     END;

     IF ff^.Name='' THEN {rewrite standard output}
     BEGIN
          ff^:=FileRec(Output);
          exit;
     END;

     ff^.Buffer:=NIL;
     c:=ff^.Name;

     {for rewrite no extended attributes can be determined - use reset !}
     {$IFDEF OS2}
     InOutRes:=DosOpen(c,ff^.Handle,action,0,$20,18,FileMode,NIL);
     {$ENDIF}
     {$IFDEF Win32}
     ff^.Handle:=CreateFile(c,FileMode AND not 3,FileMode AND 3,Nil,2,$00000080,0);
     IF ff^.Handle=-1 THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN
     BEGIN
          ff^.Handle:=$ffffffff;
          IF RaiseIOError THEN
          BEGIN
               e.Create('File not found (EFileNotFound)');
               e.CameFromRTL:=TRUE;
               e.RTLExcptAddr:=POINTER(Adr);
               e.ErrorCode:=InOutRes;
               RAISE e;
          END
          ELSE exit;
     END;

     ff^.Mode:=FileMode;
     ff^.Reserved1:=0;
     ff^.BufferBytes:=0;

     {Set the buffer values}

     size:=FileFileSize(f);
     IF InOutRes<>0 THEN
     BEGIN
          ff^.Handle:=$ffffffff;
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     IF OpenedFilesCount<255 THEN inc(OpenedFilesCount);
     OpenedFiles[OpenedFilesCount]:=ff^.Handle;

     getmem(ff^.Buffer,ff^.MaxCacheMem);
     ff^.LBlock:=size DIV ff^.MaxCacheMem;
     ff^.LOffset:=size MOD ff^.MaxCacheMem;
     FileBlockIO(f,0,readmode,Temp);
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
     ff^.Block:=0;
     ff^.Offset:=0;
END;

{$IFDEF Win32}
CONST
    GENERIC_READ            =$80000000;
    GENERIC_WRITE           =$40000000;

CONST
    FILE_SHARE_READ         =$00000001;
    FILE_SHARE_WRITE        =$00000002;

    OPEN_EXISTING           =3;
    FILE_ATTRIBUTE_NORMAL   =$00000080;
{$ENDIF}

PROCEDURE Reset(VAR f:FILE;recsize:LONGWORD);
VAR
   ff:^FileRec;
   c:CSTRING;
   e:EFileNotFound;
   size,Temp:LONGWORD;
   SaveIoError:BOOLEAN;
   Adr:LONGINT;
   {$IFDEF OS2}
   action:LONGWORD;
   p:POINTER;
   pAllocc:POINTER;
   pBigAlloc:POINTER;
   cbBigAlloc:WORD;
   ulEntryNum:LONGWORD;
   ulEnumCnt:LONGWORD;
   pLastIn:PHOLDFEA;
   pNewFEA:PHOLDFEA;
   pFEA:PFEA2;
   pGEAList:PGEA2LIST;
   eaopGet:EAOP2;
   apHoldFEA:PHOLDFEA;
   rc : LongWord;
LABEL l;
   {$ENDIF}
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     InOutRes:=0;
     ff:=@f;
     ff^.RecSize:=recsize;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle<>$ffffffff THEN
     BEGIN
         {Close file first}
         SaveIoError:=RaiseIOError;
         RaiseIOError:=FALSE;
         Close(f);
         RaiseIoError:=SaveIoError;
         (*InOutRes:=85; {File already assigned}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;*)
     END;

     ff^.Buffer:=NIL;
     c:=ff^.Name;

     IF ff^.Name='' THEN  {reset input}
     BEGIN
          ff^:=FileRec(Input);
          exit;
     END;

     {open and read extended attributes}
     {$IFDEF OS2}
     InOutRes:=DosOpen(c,ff^.Handle,action,0,0,1,FileMode,NIL{EAOP2});
     {$ENDIF}
     {$IFDEF Win32}
     ff^.Handle:=CreateFile(c,FileMode AND not 3,FileMode AND 3,Nil,OPEN_EXISTING,$00000080,0);
     If ff^.Handle=-1 Then
     Begin
          InOutRes:=GetLastError;
          If InOutRes=0 Then InOutRes:=1;
     End;
     {$ENDIF}
     IF InOutRes<>0 THEN
     BEGIN
          ff^.Handle:=$ffffffff;
          IF RaiseIOError THEN
          BEGIN
               e.Create('File not found (EFileNotFound)');
               e.CameFromRTL:=TRUE;
               e.RTLExcptAddr:=POINTER(Adr);
               e.ErrorCode:=InOutRes;
               RAISE e;
          END
          ELSE exit;
     END;

     {Query extended attributes}
     {$IFDEF OS2}
     pAllocc:=NIL;     // Holds the FEA struct returned by DosEnumAttribute
                       // used to create the GEA2LIST for DosQueryPathInfo
     pBigAlloc:=NIL;   // Temp buffer to hold each EA as it is read in
     cbBigAlloc:=0;    // Size of buffer

     ulEntryNum := 1;  // count of current EA to read (1-relative)

     pLastIn:=NIL;     // Points to last EA added, so new EA can link
     pNewFEA:=NIL;     // Struct to build the new EA in

     GetMem(pAllocc, MAX_GEA);
     pFEA := pAllocc;  // pFEA always uses pAlloc buffer

     apHoldFEA := NIL; // Reset the pointer for the EA linked list

     WHILE TRUE DO     // Loop continues until there are no more EAs */
     BEGIN
          ulEnumCnt := 1;
          IF DosEnumAttribute(0,ff^.Handle,ulEntryNum,pAllocc^,
                              MAX_GEA,ulEnumCnt,1) <>0 THEN
          BEGIN
               {There was some sort of error}
               goto l;
          END;

          IF ulEnumCnt <> 1 THEN goto l;  // All the EAs have been read

          inc(ulEntryNum);

          GetMem(pNewFEA, sizeof(THOLDFEA));

          pNewFEA^.cbName := pFEA^.cbName;  // Fill in the HoldFEA structure
          pNewFEA^.cbValue:= pFEA^.cbValue;
          pNewFEA^.fEA    := pFEA^.fEA;
          pNewFEA^.next   := NIL;

          pNewFEA^.szName:=pFEA^.szName;  // Copy in EA Name

          cbBigAlloc := sizeof(FEA2LIST) + pNewFEA^.cbName+1 +
                        pNewFEA^.cbValue;

          GetMem(pBigAlloc, cbBigAlloc);

          pGEAList := pAllocc;          // Set up GEAList structure

          pGEAList^.cbList := sizeof(GEA2LIST) + pNewFEA^.cbName; // +1 for NULL
          pGEAList^.list[0].oNextEntryOffset := 0;
          pGEAList^.list[0].cbName := pNewFEA^.cbName;

          CSTRING(pGEAList^.list[0].szName):=pNewFEA^.szName;

          eaopGet.fpGEA2List := pAllocc;
          eaopGet.fpFEA2List := pBigAlloc;
          eaopGet.oError     := 0;

          eaopGet.fpFEA2List^.cbList := cbBigAlloc;

          rc:=DosQueryFileInfo(ff^.Handle,       // Get the complete EA info
                           3,
                           eaopGet,
                           sizeof(EAOP2));

          getmem(pNewFEA^.aValue,pNewFEA^.cbValue); //memory for data
          p:=pBigAlloc;
          inc(p,sizeof(FEA2LIST)+pNewFEA^.cbName-1);
          move(p^,pNewFEA^.aValue^, pNewFEA^.cbValue);


          FreeMem(pBigAlloc,cbBigAlloc); // Release the temp Enum buffer

          IF apHoldFEA = NIL THEN         // If first EA, set pHoldFEA
               apHoldFEA := pNewFEA
          ELSE
             pLastIn^.next := pNewFEA;

          pLastIn := pNewFEA;            // Update the end of the list
          pLastIn^.Deleted:=FALSE;       //EA is valid
     END;  {While}
l:

     IF pLastIn<>NIL THEN pLastIn^.Next:=NIL;
     FreeMem(pAllocc,MAX_GEA);           // Free up the GEA buf for DosEnum

     ff^.EAS:=apHoldFEA;
     {$ELSE}
     ff^.EAS:=NIL;
     {$ENDIF}
     
     ff^.Mode:=FileMode;
     ff^.Reserved1:=0;
     ff^.BufferBytes:=0;

     {Set the buffer values}
     size:=FileFileSize(f);
     IF InOutRes<>0 THEN
     BEGIN
          ff^.Handle:=$ffffffff;
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     IF OpenedFilesCount<255 THEN inc(OpenedFilesCount);
     OpenedFiles[OpenedFilesCount]:=ff^.Handle;

     getmem(ff^.Buffer,ff^.MaxCacheMem);
     ff^.LBlock:=size DIV ff^.MaxCacheMem;
     ff^.LOffset:=size MOD ff^.MaxCacheMem;
     FileBlockIO(f,0,readmode,Temp);
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
     ff^.Block:=0;
     ff^.Offset:=0;
END;

{$IFDEF OS2}
{Get extended attributes from a file}
FUNCTION GetEAData(VAR f:FILE):PHOLDFEA;
VAR
   ff:^FileRec;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     InOutRes:=0;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               GetEAData:=NIL;
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;
     END;

     GetEAData:=ff^.EAS;
END;

{use with care !}
PROCEDURE EraseEAData(VAR f:FILE);
VAR
   ff:^FileRec;
   pFEA,next:PHOLDFEA;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     InOutRes:=0;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;
     END;

     pFEA:=ff^.EAS;
     WHILE pFEA<>NIL DO
     BEGIN
          freemem(pFEA^.aValue,pFEA^.cbValue);
          next:=pFEA^.next;
          dispose(pFEA);
          pFEA:=next;
     END;
     ff^.EAS:=NIL;
END;

{use with care}
PROCEDURE SetEAData(VAR f:FILE;EAData:PHOLDFEA);
VAR
   ff:^FileRec;
   dummy:PHOLDFEA;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     InOutRes:=0;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;
     END;

     {Erase old EA Data}
     EraseEAData(f);
     ff^.EAS:=NIL;

     {copy the EA Data}
     WHILE EAData<>NIL DO
     BEGIN
          IF ff^.EAS=NIL THEN
          BEGIN
               new(ff^.EAS);
               dummy:=ff^.EAS;
          END
          ELSE
          BEGIN
               dummy:=ff^.EAS;
               WHILE dummy^.Next<>NIL DO dummy:=dummy^.Next;
               new(dummy^.next);
               dummy:=dummy^.next;
          END;

          move(EAData^,dummy^,sizeof(THOLDFEA));
          getmem(dummy^.aValue,dummy^.cbValue);
          move(EAData^.aValue^,dummy^.avalue^,dummy^.cbValue);
          dummy^.Next:=NIL;

          EAData:=EAData^.Next;
     END;
END;

{use with care !}
PROCEDURE DeleteEAData(VAR f:FILE);
VAR
   ff:^FileRec;
   pFEA:PHOLDFEA;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     InOutRes:=0;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;
     END;

     pFEA:=ff^.EAS;
     WHILE pFEA<>NIL DO
     BEGIN
          pFEA^.Deleted:=TRUE;

          pFEA:=pFEA^.Next;
     END;
END;

{Write extended attributes to an open file
 The file need not to be opened but assigned
 and the EA data must have been set using SetEAData
 If the file is opened its sharing rights should not
 conflict with exclusive write access}
PROCEDURE WriteEAData(VAR f:FILE);
VAR
   ff:^FileRec;
   pDL:PHOLDFEA;
   pHFEA:PHOLDFEA;
   eaopWrite:EAOP2;
   aBuf:ARRAY[0..MAX_GEA] OF CHAR;
   aPtr:^CSTRING;
   pFEA:PFEA2;
   usMemNeeded:LONGWORD;
   pulPtr:^LONGWORD;
   c:CSTRING;
   p:POINTER;
   Adr:LONGINT;
BEGIN
   ASM
      MOV EAX,[EBP+4]
      SUB EAX,5
      MOV Adr,EAX
   END;
   ff:=@f;
   pHFEA:=ff^.EAS;
   aPtr:=NIL;
   pFEA:=@aBuf[4];
   pulPtr:=@aBuf;
   c:=ff^.Name;
   InOutRes:=0;

   IF ff^.flags<>$6666 THEN
   BEGIN
        IF RaiseIOError THEN InvalidFileNameError(Adr)
        ELSE
        BEGIN
             InOutRes:=206;
             exit;
        END;
   END;

   IF ff^.Handle=$ffffffff THEN
   BEGIN
        InOutRes:=6; {Invalid handle}
        IF RaiseIOError THEN InOutError(InOutRes,Adr)
        ELSE exit;
   END;

   eaopWrite.fpFEA2List := @aBuf;
   pFEA^.fEA     := 0;
   pFEA^.cbValue := 0;

   pDL:=ff^.EAS;
   WHILE pDL<>NIL DO      // Clean out all the deleted EA names
   BEGIN
      IF pDL^.Deleted THEN
      BEGIN
           pFEA^.cbName := pDL^.cbName;
           pulPtr^:= sizeof(FEA2LIST) + pFEA^.cbName;
           pFEA^.szName:=pDL^.szName;
           pFEA^.oNextEntryOffset := 0; {last entry}
                                     // Delete EA's by saying cbValue=0
           {DosSetPathInfo(c,2,eaopWrite,sizeof(EAOP2),$10);}
           DosSetFileInfo(ff^.Handle,2,eaopWrite,sizeof(EAOP2));
      END;
      pDL := pDL^.next;
   END;

   WHILE pHFEA<>NIL DO      // Go through each HoldFEA
   BEGIN
      IF not pHFEA^.Deleted THEN
      BEGIN
           usMemNeeded := sizeof(FEA2LIST) + pHFEA^.cbName+1 +
                                 pHFEA^.cbValue;
           GetMem(aPtr, usMemNeeded);

           eaopWrite.fpFEA2List := POINTER(aPtr);  // Fill in eaop struct
           eaopWrite.fpFEA2List^.cbList := usMemNeeded;

           eaopWrite.fpFEA2List^.list[0].fEA     := pHFEA^.fEA;
           eaopWrite.fpFEA2List^.list[0].cbName  := pHFEA^.cbName;
           eaopWrite.fpFEA2List^.list[0].cbValue := pHFEA^.cbValue;
           eaopWrite.fpFEA2List^.list[0].oNextEntryOffset := 0; {last entry}

           CSTRING(eaopWrite.fpFEA2List^.list[0].szName):=pHFEA^.szName;
           p:=@eaopWrite.fpFEA2List^.list[0].szName;
           inc(p,pHFEA^.cbName+1);
           move(pHFEA^.aValue^,p^,pHFEA^.cbValue);

           {InOutRes := DosSetPathInfo(c,2,eaopWrite,sizeof(EAOP2),$10);}
           {InOutRes:=}DosSetFileInfo(ff^.Handle,2,eaopWrite,sizeof(EAOP2));

           {IF InOutRes<>0 THEN
           BEGIN
                 IF RaiseIOError THEN InOutError(InOutRes,Adr)
                 ELSE exit;
           END;}

           FreeMem(aPtr,usMemNeeded); // Free up the FEALIST struct
      END;

      pHFEA := pHFEA^.next;
   END;
END;
{$ENDIF}

PROCEDURE Close(VAR f:FILE);
VAR
   ff:^FileRec;
   Temp:LONGWORD;
   t:BYTE;
   Adr:LONGINT;
LABEL l;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;

     ff:=@f;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
          InOutRes:=6; {Invalid handle}
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     IF ff^.Buffer=NIL THEN
     BEGIN
          {$IFDEF OS2}
          InOutRes:=DosClose(ff^.Handle);
          {$ENDIF}
          {$IFDEF WIN32}
          IF not CloseHandle(ff^.Handle) THEN
          BEGIN
              InOutRes:=GetLastError;
              IF InOutRes=0 Then InOutRes:=1;
          END;
          {$ENDIF}
          IF InOutRes<>0 THEN
          BEGIN
              IF RaiseIOError THEN InOutError(InOutRes,Adr)
              ELSE exit;
          END;
          ff^.Mode:=0;            {closed}
          ff^.Flags:=$6666;       {File successfully assigned}
          ff^.Handle:=$ffffffff;  {No valid handle}
          exit;
     END;

     InOutRes:=0;
     {Write buffer to file}
     IF ff^.changed THEN
     BEGIN
          ff^.changed:=FALSE;
          FileBlockIO(F,ff^.block,WriteMode,Temp);
          IF InOutRes<>0 THEN
          BEGIN
              IF RaiseIOError THEN InOutError(InOutRes,Adr)
              ELSE exit;
          END;
     END;

     {$IFDEF OS2}
     {Write EA's to the file}
     WriteEAData(f);
     {$ENDIF}

     FOR t:=1 TO OpenedFilesCount DO
     BEGIN
          IF OpenedFiles[t]=ff^.Handle THEN
          BEGIN
               move(OpenedFiles[t+1],OpenedFiles[t],(255-t)*4);
               dec(OpenedFilesCount);
               goto l;
          END;
     END;
l:
     {$IFDEF OS2}
     InOutRes:=DosClose(ff^.Handle);
     {$ENDIF}
     {$IFDEF Win32}
     IF not CloseHandle(ff^.Handle) THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 Then InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     {$IFDEF OS2}
     EraseEAData(f);
     {$ENDIF}
     ff^.Mode:=0;            {closed}
     ff^.Flags:=$6666;       {File successfully assigned}
     ff^.Handle:=$ffffffff;  {No valid handle}

     {free file buffers}
     IF ff^.Buffer<>NIL THEN FreeMem(ff^.Buffer,ff^.MaxCacheMem);
     ff^.Buffer:=NIL;
END;

PROCEDURE CloseAllOpenedFiles;
VAR t:LONGINT;
BEGIN
     FOR t:=1 TO OpenedFilesCount DO
     BEGIN
          {$IFDEF OS2}
          DosClose(OpenedFiles[t]);
          {$ENDIF}
          {$IFDEF WIN32}
          CloseHandle(OpenedFiles[t]);
          {$ENDIF}
     END;
     OpenedFilesCount:=0;
END;

PROCEDURE CloseFile(VAR f:FILE);
BEGIN
     Close(f);
END;

PROCEDURE Seek(VAR f:FILE;n:LONGINT);
VAR
   ff:^FileRec;
   pBlock:LONGWORD;
   POffset:LONGWORD;
   Temp:LONGWORD;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
          InOutRes:=6; {Invalid handle}
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     n:=n*ff^.RecSize;

     CASE SeekMode OF
        Seek_Current:inc(n,FilePos(f)*ff^.RecSize);   //Seek_Current
        Seek_End:inc(n,FileSize(f)*ff^.RecSize);      //Seek_End
     END;

     IF ff^.Buffer=NIL THEN
     BEGIN
          {$IFDEF OS2}
          InOutRes:=DosSetFilePtr(ff^.Handle,n,Seek_Begin,Temp);
          IF RaiseIOError THEN InOutError(InOutRes,Adr);
          {$ENDIF}
          {$IFDEF Win32}
          Temp:=SetFilePointer(ff^.Handle,n,NIL,0);  //Seek from file BEGIN
          IF Temp=$ffffffff THEN
          BEGIN
              InOutRes:=GetLastError;
              IF RaiseIOError THEN InOutError(InOutRes,Adr);
          END;
          {$ENDIF}
          exit;
     END;

     InOutRes:=0;
     pblock:=n DIV ff^.maxcachemem;
     poffset:=n MOD ff^.maxcachemem;
     IF n>ff^.loffset+ff^.maxcachemem*ff^.lblock THEN
     BEGIN
          //IF ff^.Mode AND (fmOutput OR fmInOut)<>0 THEN
          IF ff^.Mode AND (longword(fmOutput) OR longword(fmInOut))<>0 THEN  // Martin
          BEGIN
               ff^.loffset:=poffset;
               ff^.lblock:=pblock;
          END
          ELSE
          BEGIN
               InOutRes:=38;  {Illegal pos}
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;
     END;
     IF pblock<>ff^.block THEN
     BEGIN
          FileBlockIO(f,pblock,ReadMode,Temp);
          IF InOutRes<>0 THEN
          BEGIN
              IF RaiseIOError THEN InOutError(InOutRes,Adr)
              ELSE exit;
          END;
     END;
     ff^.offset:=poffset;
     ff^.block:=pblock;
END;


FUNCTION FilePos(var f:file):LongWord;
VAR
   ff:^FileRec;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
          InOutRes:=6; {Invalid handle}
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     IF ff^.Buffer=NIL THEN
     BEGIN
          Result:=FileFilePos(f);

          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;

          Result:=Result DIV ff^.RecSize;
          exit;
     END;

     InOutRes:=0;
     Result:=ff^.block*ff^.maxcachemem+ff^.offset;
     Result:=Result DIV ff^.RecSize;
END;

FUNCTION Eof(var f:file):Boolean;
VAR
   size:LONGWORD;
   ff:^FileRec;
   SaveIO:BOOLEAN;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
        MOV EAX,f
        CMP EAX,0
        JNE !Eof_ok
        MOV EAX,OFFSET(SYSTEM.Input)
        MOV f,EAX
!Eof_ok:
     END;
     ff:=@f;

     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
          InOutRes:=6; {Invalid handle}
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     IF ff^.Reserved1 AND 1=1 THEN
     BEGIN
          eof:=TRUE;
          exit;
     END;

     IF ff^.Buffer=NIL THEN
     BEGIN
          InOutRes:=0;
          SaveIO:=RaiseIOError;
          RaiseIOError:=FALSE;
          Size:=FileFileSize(f);
          RaiseIOError:=SaveIO;
          IF InOutRes<>0 THEN
          BEGIN
               {$IFDEF OS2}
               IF ((ff^.Handle=0{Input})OR(ff^.Handle=1{Output})) THEN
               {$ENDIF}
               {$IFDEF Win32}
               IF ((ff^.Handle=GetStdHandle(-10){Input})OR(ff^.Handle=GetStdHandle(-11){Output})) THEN
               {$ENDIF}
               BEGIN
                    Eof:=FALSE;
                    exit;
               END
               ELSE
               BEGIN
                    IF RaiseIOError THEN InOutError(InOutRes,Adr)
                    ELSE exit;
               END;
          END
          ELSE
          BEGIN
               Eof:=Size=FileFilePos(f);
               IF InOutRes<>0 THEN
               BEGIN
                    IF RaiseIOError THEN InOutError(InOutRes,Adr)
                    ELSE exit;
               END;
          END;
          exit;
     END;

     InOutRes:=0;
     Eof:=(ff^.offset=ff^.loffset)AND(ff^.block=ff^.lblock);
END;

FUNCTION Eoln(VAR F:Text):Boolean;
VAR
    Adr:LONGINT;
    fi:^FileRec;
    Offset:LONGINT;
    Value:BYTE;
    SaveIoError:BOOLEAN;
    Res:LONGWORD;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
        MOV EAX,f
        CMP EAX,0
        JNE !Eoln_ok
        MOV EAX,OFFSET(SYSTEM.Input)
        MOV f,EAX
!Eoln_ok:
     END;

     fi:=@f;

     IF fi^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF fi^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;
     END;

     IF eof(f) THEN
     BEGIN
          result:=TRUE;
          exit;
     END;

     Offset:=fi^.Offset;

     IF fi^.Buffer=NIL THEN
     BEGIN
          IF lo(fi^.BufferBytes)=1 THEN
          BEGIN
               Value:=Hi(fi^.BufferBytes);
          END
          ELSE
          BEGIN
               SaveIOError:=RaiseIOError;
               RaiseIOError:=FALSE;
               BlockRead(f,Value,1,Res);
               Seek(f,FilePos(f)-1);
               RaiseIOError:=SaveIOError;
               IF Res=0 THEN Value:=26; {EOF}
          END;
     END
     ELSE value:=fi^.Buffer^[Offset];

     IF value IN [13,10,26] THEN result:=TRUE
     ELSE result:=FALSE;
END;


FUNCTION FileSize(var f:file):LongWord;
VAR
   ff:^FileRec;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
          InOutRes:=6; {Invalid handle}
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     IF ff^.Buffer=NIL THEN
     BEGIN
          Result:=FileFileSize(f);
          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;

          Result:=Result DIV ff^.RecSize;
          exit;
     END;

     InOutRes:=0;
     Result:=ff^.lblock*ff^.maxcachemem+ff^.loffset;
     Result:=Result DIV ff^.RecSize;
END;

PROCEDURE Truncate(VAR f:FILE);
VAR
   ff:^FileRec;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     {$IFDEF OS2}
     InOutRes:=DosSetFileSize(ff^.Handle,FilePos(f));
     {$ENDIF}
     {$IFDEF Win32}
     IF not SetEndOfFile(ff^.Handle) THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN
     BEGIN
          ff^.Handle:=$ffffffff;
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
     
     ff^.lOffset:=ff^.Offset;
     ff^.lBlock:=ff^.Block;
END;

PROCEDURE Append(VAR f:Text);
VAR
   l:LONGWORD;
   saveseek:LONGWORD;
   Adr:LONGINT;

   FUNCTION PrecChar:Char;
   BEGIN
        Seek(f,FilePos(f)-1);
        BlockRead(f,Result,1);
   END;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     Reset(f,1);
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     l:=Filesize(f);
     IF InOutRes=0 THEN
     BEGIN
          SaveSeek:=seekmode;
          seekmode:=0; {from file BEGIN}
          Seek(f,l);
          seekmode:=saveseek;
     END
     ELSE
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     SaveSeek:=seekmode;
     seekmode:=0; {from file BEGIN}
     WHILE (FilePos(f)>1)AND(PrecChar=^Z) DO Seek(f,Filepos(f)-1);
     seekmode:=saveseek;
END;

{$HINTS OFF}
PROCEDURE ChDir(CONST path:STRING);
VAR c:CSTRING;
    Adr:LONGINT;
    s:STRING;
LABEL doit;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;

     c:=path;

     {$IFDEF OS2}
     IF length(Path)=2 THEN IF Path[2]=':' THEN
     BEGIN
          InOutRes:=DosSetDefaultDisk(ord(upcase(path[1]))-64);
          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;
          GetDir(0,s);
          ChDir(s);
          exit;
     END;

     IF POS(':\',path)=2 THEN {drive letter preceding}
     BEGIN
          InOutRes:=DosSetDefaultDisk(ord(upcase(path[1]))-64);
          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;
          c:=upcase(path[1])+':\';
          InOutRes:=DosSetCurrentDir(c);  {move to root directory}
          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;
          s:=Path;
          delete(s,1,3);
          IF s='' THEN exit;
          c:=s;
          goto doit;
     END;

     IF path[length(Path)]='\' THEN
     BEGIN
          s:=Path;
          dec(s[0]);
          c:=s;
     END
     ELSE c:=path;
doit:
     {$ENDIF}

     {$IFDEF OS2}
     InOutRes:=DosSetCurrentDir(c);
     {$ENDIF}
     {$IFDEF Win32}
     IF SetCurrentDirectory(c) <> FALSE THEN
       InOutRes := 0{Martin0807}
     else BEGIN
       InOutRes:=GetLastError;
       IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;
{$HINTS ON}


{$HINTS OFF}
PROCEDURE GetDir(drive:byte;VAR path:STRING);
VAR
   c:CSTRING;
   {$IFDEF OS2}
   drivemap,curdrive,MaxLen:LONGWORD;
   {$ENDIF}
   Adr:LONGINT;
   OldRaise:BOOLEAN;
   temp:String;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;

     InOutRes:=0;

     {$IFDEF OS2}
     IF Drive=0 THEN
     BEGIN
          {query current drive}
          InOutRes:=DosQueryCurrentDisk(curdrive,drivemap);
          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;
     END
     ELSE curdrive:=drive;
     {$ENDIF}
     {$IFDEF Win32}
     IF Drive<>0 THEN
     BEGIN
          GetDir(0,Temp);
          OldRaise:=RaiseIOError;
          RaiseIOError:=FALSE;
          temp:=chr(drive+64)+':';
          ChDir(temp);
          RaiseIOError:=OldRaise;
          IF InOutRes<>0 THEN
          BEGIN
               InOutRes:=2;
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;
          GetDir(0,path);
          ChDir(temp);
          exit;
     END;
     {$ENDIF}

     {$IFDEF OS2}
     MaxLen:=250;
     InOutRes:=DosQueryCurrentDir(curdrive,c,MaxLen);
     {$ENDIF}
     {$IFDEF Win32}
     IF GetCurrentDirectory(255,c)=0 THEN
     BEGIN
          InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     {$IFDEF OS2}
     path:=chr(curDrive+64)+':\'+c;
     {$ENDIF}
     {$IFDEF Win32}
     path:=c;
     {$ENDIF}
END;
{$HINTS ON}

PROCEDURE RmDir(CONST dir:STRING);
VAR
   c:CSTRING;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     c:=Dir;
     {$IFDEF OS2}
     InOutRes:=DosDeleteDir(c);
     {$ENDIF}
     {$IFDEF Win32}
     IF not RemoveDirectory(c) THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

PROCEDURE MkDir(CONST dir:STRING);
VAR
   c:CSTRING;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     c:=dir;
     {$IFDEF OS2}
     InOutRes:=DosCreateDir(c,NIL);
     {$ENDIF}
     {$IFDEF Win32}
     //If the function CreateDirectory succeeds, the return value is nonzero
     IF CreateDirectory(c,NIL) <> FALSE THEN
       InOutRes := 0{Martin0307}
     else BEGIN
       InOutRes:=GetLastError;
       IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

PROCEDURE FileExpand(VAR f:FILE);
VAR
   ff:^FileRec;
BEGIN
     ff:=@f;
     IF ff^.LOffset=ff^.MaxCacheMem THEN
     inc(ff^.LOffset);
     BEGIN
          inc(ff^.LBlock);
          ff^.LOffset:=0;
     END;
END;

PROCEDURE BlockRead(VAR f:file;var Buf;Count:LongWord;VAR result:LONGWORD);
VAR
   ff:^FileRec;
   pp:P_FileBuffer;
   t:LONGWORD;
   Temp:LONGWORD;
   Offset,Size:LONGWORD;
   OldBlock,OldOfs:LONGINT;
   MaxCacheMem:LONGWORD;
   Adr:LONGINT;
   TempResult:LONGINT;
BEGIN
     ASM
        MOV EAX,result
        CMP EAX,0        //result var present
        JNE !prr
        LEA EAX,TempResult
        MOV result,EAX
!prr:
     END;

     IF Count=0 THEN
     BEGIN
          result:=0;
          exit;
     END;

     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     pp:=@Buf;
     InOutRes:=0;

     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;
     END;

     IF ff^.Buffer=NIL THEN
     BEGIN
          {$IFDEF OS2}
          InOutRes:=DosRead(ff^.Handle,pp^,Count*ff^.RecSize,Result);
          {$ENDIF}
          {$IFDEF Win32}
          IF not ReadFile(ff^.Handle,pp^,Count*ff^.RecSize,Result,NIL) THEN
          BEGIN
               InOutRes:=GetLastError;
               IF InOutRes=0 THEN InOutRes:=1;
          END;
          {$ENDIF}
          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;
          exit;
     END;

     result:=0;
     Offset:=ff^.Offset;
     Size:=Count*ff^.RecSize;
     MaxCacheMem:=ff^.MaxCacheMem;

     IF Size>MaxCacheMem THEN
     BEGIN
          {Block ist gr”แer als Cache}
          IF (ff^.Block*MaxCacheMem)+Offset+Size>(ff^.LBlock*MaxCacheMem)+ff^.LOffset THEN
            Size:=((ff^.LBlock*MaxCacheMem)+ff^.LOffset)-
                  ((ff^.Block*MaxCacheMem)+Offset);

          IF ff^.Changed THEN
          BEGIN
               ff^.Changed:=FALSE;
               OldBlock:=ff^.LBlock;    {temporaray save}
               OldOfs:=ff^.LOffset;
               ff^.LBlock:=ff^.Block;
               ff^.LOffset:=Offset;
               {alten Block Schreiben}
               FileBlockIO(f,ff^.Block,WriteMode,Temp);
               IF InOutRes<>0 THEN
               BEGIN
                    IF RaiseIOError THEN InOutError(InOutRes,Adr)
                    ELSE exit;
               END;
               ff^.LBlock:=OldBlock;
               ff^.LOffset:=OldOfs;
          END
          ELSE
          BEGIN
               {$IFDEF OS2}
               InOutRes:=DosSetFilePtr(ff^.Handle,
                         (ff^.Block*MaxCacheMem)+Offset,0,Temp);
               {$ENDIF}
               {$IFDEF Win32}
               Temp:=SetFilePointer(ff^.Handle,
                                    (ff^.Block*MaxCacheMem)+Offset,NIL,0);
               IF Temp=$ffffffff THEN
               BEGIN
                    InOutRes:=GetLastError;
                    IF InOutRes=0 THEN InOutRes:=1;
               END;
               {$ENDIF}
               IF InOutRes<>0 THEN
               BEGIN
                    IF RaiseIOError THEN InOutError(InOutRes,Adr)
                    ELSE exit;
               END;
          END;

          {$IFDEF OS2}
          InOutRes:=DosRead(ff^.Handle,Buf,Size,Result);
          {$ENDIF}
          {$IFDEF Win32}
          IF not ReadFile(ff^.Handle,Buf,Size,Result,NIL) THEN
          BEGIN
               InOutRes:=GetLastError;
               IF InOutRes=0 THEN InOutRes:=1;
          END;
          {$ENDIF}
          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;
          Size:=Result; {tatschlich gelesen}

          {set file buffer}
          Temp:=Offset+size;
          t:=Temp MOD MaxCacheMem;

          IF size<MaxCacheMem THEN
          BEGIN
               t:=size;
               move(pp^{[size-t]},ff^.Buffer^,t);
               inc(ff^.Block,Temp DIV MaxCacheMem);
               ff^.Offset:=t;
               ff^.LBlock:=ff^.Block;
               ff^.LOffset:=ff^.Offset;
          END
          ELSE
          BEGIN
               {nchsten Block lesen}
               ff^.Changed:=FALSE;
               inc(ff^.Block,Temp DIV MaxCacheMem);

               FileBlockIO(f,ff^.block,ReadMode,Temp);
               IF InOutRes<>0 THEN
               BEGIN
                    IF RaiseIOError THEN InOutError(InOutRes,Adr)
                    ELSE exit;
               END;
               ff^.offset:=t;
          END;

          IF ff^.Block>ff^.LBlock THEN
          BEGIN
               ff^.LBlock:=ff^.Block;
               ff^.LOffset:=ff^.Offset;
          END;

          result:=result DIV ff^.RecSize;
          exit;
     END;

     IF ff^.block=ff^.LBlock THEN
     BEGIN
          IF Offset+size<ff^.LOffset THEN
          BEGIN
               {im letzten Block}
               move(ff^.Buffer^[Offset],pp^,size);
               inc(ff^.Offset,size);
               inc(result,size);
               result:=result DIV ff^.RecSize;
               exit;
          END;
     END
     ELSE
     BEGIN
          {irgendwo vor dem letzten Block}
          IF Offset+Size<MaxCacheMem THEN
          BEGIN
               move(ff^.Buffer^[Offset],pp^,size);
               inc(ff^.Offset,size);
               inc(result,size);
               result:=result DIV ff^.RecSize;
               exit;
          END;
     END;

     ff^.reserved1:=ff^.reserved1 and not 1;

     ASM
        MOV ECX,0
!Again:
        CMP ECX,Size
        JAE !Abort

        PUSH ECX

        PUSH DWORD PTR ff
        CALLN32 SYSTEM.EOF

        POP ECX
        CMP AL,0
        JNE !Abort    //its EOF

        {pp^[t-1]:=ff^.Buffer^[ff^.offset];}
        MOV EBX,pp
        ADD EBX,ECX
        MOV EDI,ff
        MOV ESI,[EDI].FileRec.Buffer
        ADD ESI,[EDI].FileRec.Offset
        MOV AL,[ESI]
        MOV [EBX],AL
        {inc(ff^.offset);}
        INCD [EDI].FileRec.Offset
        {inc(result);}
        MOV EAX,Result
        INCD [EAX]

        {IF ff^.offset=maxcachemem THEN}
        MOV EAX,MaxCacheMem
        CMP [EDI].FileRec.Offset,EAX
        JNE !False

        {FileBlockIO(f,ff^.block+1,ReadMode,Temp);}
        PUSH ECX

        PUSH EDI
        MOV EAX,[EDI].FileRec.Block
        INC EAX
        PUSH EAX
        PUSHL ReadMode
        LEA EAX,Temp
        PUSH EAX
        CALLN32 SYSTEM.FileBlockIO

        POP ECX
        {IF InOutRes<>0 THEN}
        CMPD SYSTEM.InOutRes,0
        JE !False1

        {IF RaiseIOError THEN InOutError(InOutRes,Adr)}
        CMPB SYSTEM.RaiseIOError,0
        JE !Abort
        PUSH DWORD PTR SYSTEM.InOutRes
        PUSH DWORD PTR Adr
        CALLN32 SYSTEM.InOutError
!False1:
        {ff^.offset:=0;}
        MOV EDI,ff
        MOVD [EDI].FileRec.Offset,0
        {inc(ff^.block);}
        INCD [EDI].FileRec.Block
!False:
        INC ECX
        JMP !Again
!Abort:
     END;

     result:=result DIV ff^.RecSize;
END;

PROCEDURE BlockWrite(VAR f:file;var Buf;Count:LongWord;VAR result:LONGWORD);
VAR
   ff:^FileRec;
   pp:P_FileBuffer;
   t,Temp:LONGWORD;
   size:LONGWORD;
   Offset:LONGWORD;
   Adr:LONGINT;
   TempResult:LONGINT;
LABEL l,l1,ex;
BEGIN
     ASM
        MOV EAX,result
        CMP EAX,0        //result var present
        JNE !prw
        LEA EAX,TempResult
        MOV result,EAX
!prw:
     END;

     IF Count=0 THEN
     BEGIN
          result:=0;
          exit;
     END;

     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     pp:=@Buf;
     InOutRes:=0;

     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               goto ex;
          END;
     END;

     IF ff^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE goto ex;
     END;

     IF ff^.Buffer=NIL THEN
     BEGIN
          {$IFDEF OS2}
          InOutRes:=DosWrite(ff^.Handle,pp^,Count*ff^.RecSize,Result);
          {$ENDIF}
          {$IFDEF Win32}
          IF not WriteFile(ff^.Handle,pp^,Count*ff^.RecSize,Result,NIL) THEN
          BEGIN
               InOutRes:=GetLastError;
               IF InOutRes=0 THEN InOutRes:=1;
          END;
          {$ENDIF}
          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE goto ex;
          END;
          goto ex;
     END;

     result:=0;
     InOutRes:=0;
     size:=Count*ff^.RecSize;
     Offset:=ff^.Offset;

     IF ff^.block=ff^.LBlock THEN
     BEGIN
          IF Offset=ff^.LOffset THEN
          BEGIN
               {am ende der Datei (im letzten Block und an LOffset)}
               IF Offset+size<ff^.MaxCacheMem THEN
               BEGIN
                    move(pp^,ff^.Buffer^[Offset],size);
                    inc(ff^.Offset,size);
                    inc(ff^.LOffset,size);
                    inc(result,size);
                    ff^.Changed:=TRUE;
                    result:=result DIV ff^.RecSize;
                    goto ex;
               END
               ELSE
               BEGIN
                    {Groesse geht ber alten Block hinaus}
l:
                    ff^.Changed:=FALSE;
                    {alten Block Schreiben}
                    FileBlockIO(f,ff^.Block,WriteMode,Temp);
                    IF InOutRes<>0 THEN
                    BEGIN
                         IF RaiseIOError THEN InOutError(InOutRes,Adr)
                         ELSE goto ex;
                    END;
l1:
                    {$IFDEF OS2}
                    InOutRes:=DosWrite(ff^.Handle,Buf,Size,Result);
                    {$ENDIF}
                    {$IFDEF Win32}
                    IF not WriteFile(ff^.Handle,Buf,Size,Result,NIL) THEN
                    BEGIN
                        InOutRes:=GetLastError;
                        IF InOutRes=0 THEN InOutRes:=1;
                    END;
                    {$ENDIF}
                    IF InOutRes<>0 THEN
                    BEGIN
                        IF RaiseIOError THEN InOutError(InOutRes,Adr)
                        ELSE goto ex;
                    END;
                    Size:=Result; {Tatschlich geschrieben}

                    {set file buffer}
                    Temp:=Offset+size;
                    t:=Temp MOD ff^.MaxCacheMem;
                    move(pp^[size-t],ff^.Buffer^,t);

                    inc(ff^.Block,Temp DIV ff^.MaxCacheMem);
                    ff^.Offset:=t;

                    {we are at the end of the file}
                    ff^.LBlock:=ff^.Block;
                    ff^.LOffset:=ff^.Offset;
                    result:=result DIV ff^.RecSize;
                    goto ex;
               END;
          END
          ELSE
          BEGIN
               {im letzten Block aber nicht an LOffset}
               IF Offset+size<ff^.LOffset THEN
               BEGIN
                    move(pp^,ff^.Buffer^[Offset],size);
                    inc(ff^.Offset,size);
                    inc(result,size);
                    ff^.Changed:=TRUE;
                    result:=result DIV ff^.RecSize;
                    goto ex;
               END;
               {ELSE goto l;}
          END;
     END
     ELSE
     BEGIN
          {irgendwo vor dem letzten Block}
          IF Offset+Size<ff^.MaxCacheMem THEN
          BEGIN
               move(pp^,ff^.Buffer^[Offset],size);
               inc(ff^.Offset,size);
               inc(result,size);
               ff^.Changed:=TRUE;
               result:=result DIV ff^.RecSize;
               goto ex;
          END;
     END;

     ff^.reserved1:=ff^.reserved1 and not 1;

     ASM
        MOV ECX,0
!Again:
        CMP ECX,Size
        JAE !Abort

        {value:=pp^[t-1];}
        MOV EBX,pp
        ADD EBX,ECX
        MOV AL,[EBX]
        {IF value<>ff^.Buffer^[ff^.offset] THEN}
        MOV EDI,ff
        MOV ESI,[EDI].FileRec.Buffer
        ADD ESI,[EDI].FileRec.Offset
        CMP AL,[ESI]
        JE !Ok

        MOV [ESI],AL
        MOVB [EDI].FileRec.Changed,1
!Ok:
        {IF EOF(f) THEN}
        PUSH ECX

        PUSH EDI
        CALLN32 SYSTEM.Eof
        CMP AL,0
        JE !notEof

        {ff^.changed:=TRUE;}
        MOV EDI,ff
        MOVB [EDI].FileRec.Changed,1
        {FileExpand(f);}
        PUSH EDI
        CALLN32 SYSTEM.FileExpand
!NotEof:
        POP ECX
        MOV EDI,ff
        {inc(ff^.Offset);}
        INCD [EDI].FileRec.Offset
        MOV EAX,Result
        INCD [EAX]

        {IF ff^.Offset=ff^.MaxCacheMem THEN}
        MOV EAX,[EDI].FileRec.Offset
        CMP EAX,[EDI].FileRec.MaxCacheMem
        JNE !Skip

        MOVB [EDI].FileRec.Changed,0
        {alten Block Schreiben}
        PUSH ECX

        PUSH EDI
        PUSH DWORD PTR [EDI].FileRec.Block
        PUSHL WriteMode
        LEA EAX,Temp
        PUSH EAX
        CALLN32 SYSTEM.FileBlockIO
        POP ECX
        CMPD System.InOutRes,0
        JE !io1ok

        CMPB System.RaiseIOError,0
        JE !Abort
        PUSH DWORD PTR System.InOutRes
        PUSH DWORD PTR Adr
        CALLN32 System.InOutError
!io1Ok:
        {neuen Block lesen}
        PUSH ECX
        MOV EDI,ff
        {ff^.Offset:=0;}
        MOVD [EDI].FileRec.Offset,0
        {inc(ff^.Block);}
        INCD [EDI].FileRec.Block
        {FileBlockIO(f,ff^.Block,ReadMode,Temp);}
        PUSH  EDI
        PUSH DWORD PTR [EDI].FileRec.Block
        PUSHL ReadMode
        LEA EAX,Temp
        PUSH EAX
        CALLN32 SYSTEM.FileBlockIO
        POP ECX
        {IF InOutRes<>0 THEN}
        CMPD System.InOutRes,0
        JE !Skip

        CMPB System.RaiseIOError,0
        JE !Abort

        PUSH DWORD PTR System.InOutRes
        PUSH DWORD PTR Adr
        CALLN32 SYSTEM.InOutError
!Skip:
        INC ECX
        JMP !Again
!Abort:
     END;
     result:=result DIV ff^.RecSize;
ex:
END;

PROCEDURE Rename(VAR f:file;NewName:String);
VAR
   c,c1:CSTRING;
   ff:^FileRec;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     c:=NewName;
     c1:=ff^.Name;
     {$IFDEF OS2}
     InOutRes:=DosMove(c1,c);
     {$ENDIF}
     {$IFDEF Win32}
     IF not MoveFile(c1,c) THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

PROCEDURE Erase(VAR f:file);
VAR
   ff:^FileRec;
   c:CSTRING;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@f;
     IF ff^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;
     c:=ff^.name;
     {$IFDEF OS2}
     InOutRes:=DosDelete(c);
     {$ENDIF}
     {$IFDEF Win32}
     IF not DeleteFile(c) THEN
     BEGIN
          InOutRes:=GetLastError;
          IF InOutRes=0 THEN InOutRes:=1;
     END;
     {$ENDIF}
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

{$HINTS OFF}
PROCEDURE SetFileBuf(VAR f:FILE;VAR Buf;BufSize:LONGWORD);
BEGIN
     IF BufSize<4096 THEN BufSize:=4096;
END;
{$HINTS ON}

PROCEDURE SetTextBuf(VAR f:TEXT;VAR Buf;BufSize:LONGWORD);
BEGIN
     if BufSize>16*1024 then SetFileBuf(F,Buf,BufSize);
END;

{$IFDEF OS2}
Function GetCurPosX : BYTE;

var Row, Col : Word;

Begin
  VioGetCurPosProc(Row, Col, 0);
  Result:=Col+1;
End;

Function GetCurPosY : BYTE;

var Row, Col : Word;

Begin
  VioGetCurPosProc(Row, Col, 0);
  Result:=Row+1;
End;
{$ENDIF}



PROCEDURE StrWriteText({VAR f:FILE}CONST s:STRING;format:LONGWORD);
VAR
    fi:^FILE;
    ss:STRING;
    fillup:BYTE;
    Adr:LONGINT;
    SaveIO:BOOLEAN;
    BlockWriteResult:LONGWORD;
BEGIN
     ASM
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
     END;
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     IF Format+Length(s)>255 THEN Format:=255-length(s);
     IF format>length(s) THEN
     BEGIN
          fillup:=format-length(s);  {erst soviele Leerzeichen}
          fillchar(ss[0],fillup,32);
          SaveIO:=RaiseIOError;
          RaiseIOError:=FALSE;
          BlockWrite(fi^,ss[0],fillup);
          RaiseIOError:=SaveIO;
          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;
     END;
     SaveIO:=RaiseIOError;
     RaiseIOError:=FALSE;
     {must do this in ASM because s is constant parameter}
     ASM
        PUSH DWORD PTR fi
        MOV EDI,s
        INC EDI
        PUSH EDI
        DEC EDI
        MOVZXB EAX,[EDI+0]
        PUSH EAX
        LEA EAX,BlockWriteResult
        PUSH EAX
        CALLN32 SYSTEM.BlockWrite
     END;
     RaiseIOError:=SaveIO;
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

PROCEDURE CStrWriteText({VAR f:FILE}CONST s:CSTRING;format:LONGWORD);
VAR
    ss:STRING;
    l:LONGWORD;
    fi:^FILE;
    fillup:BYTE;
    Adr:LONGINT;
    SaveIO:BOOLEAN;
    BlockWriteResult:LONGWORD;
BEGIN
     ASM
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
     END;
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     l:=length(s);
     IF Format+l>255 THEN Format:=255-l;
     IF format>l THEN
     BEGIN
          fillup:=format-l;
          fillchar(ss[0],fillup,32);
          SaveIO:=RaiseIOError;
          RaiseIOError:=FALSE;
          BlockWrite(fi^,ss[0],fillup);
          RaiseIOError:=SaveIO;
          IF InOutRes<>0 THEN
          BEGIN
               IF RaiseIOError THEN InOutError(InOutRes,Adr)
               ELSE exit;
          END;
     END;
     SaveIO:=RaiseIOError;
     RaiseIOError:=FALSE;
     {must do this in ASM because s is constant parameter}
     ASM
        PUSH DWORD PTR fi
        PUSH DWORD PTR s
        PUSH DWORD PTR l
        LEA EAX,BlockWriteResult
        PUSH EAX
        CALLN32 SYSTEM.BlockWrite
     END;
     RaiseIOError:=SaveIO;
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

PROCEDURE ArrayWriteText({VAR f:FILE}CONST s;format:LONGWORD;MaxLen:LONGWORD);
VAR fi:^File;
    pc:PChar;
BEGIN
     ASM
        MOV EAX,[EBP+20]  //VAR f:FILE
        MOV fi,EAX
     END;
     GetMem(pc,MaxLen+1);
     Move(s,pc^,MaxLen);
     pc^[MaxLen]:=#0;  //terminate PChar
     ASM
        PUSH DWORD PTR fi
        PUSH DWORD PTR pc
        PUSH DWORD PTR Format
        CALLN32 SYSTEM.CStrWriteText
        ADD ESP,4  //Pop f
     END;
     FreeMem(pc,MaxLen+1);
END;

PROCEDURE AnsiStrWriteText({VAR f:FILE}CONST s:AnsiString;format:LONGWORD);ASSEMBLER;
ASM
   MOV EBX,[EBP+12]  //s
   CMP EBX,0         //AnsiString is empty
   JE !ex
   PUSH DWORD PTR [EBP+16]    //f
   PUSH EBX
   PUSH DWORD PTR [EBP+8]     //format
   JE !ex
   CALLN32 SYSTEM.CStrWriteText
   ADD ESP,4         //get VAR f
!ex:
END;

PROCEDURE VariantWriteText({VAR f:FILE}CONST v:Variant;format:LONGWORD);
VAR fi:^FILE;
    s:STRING;
BEGIN
     ASM
        MOV EAX,[EBP+16]  //f:FILE
        MOV fi,EAX
     END;
     IF VarType(v) and VarTypeMask=varString THEN
     BEGIN
          ASM
             PUSH DWORD PTR fi
             MOV EAX,v
             PUSH DWORD PTR [EAX+2]  //by value !!
             PUSH DWORD PTR format
             CALLN32 SYSTEM.AnsiStrWriteText
          END;
     END
     ELSE
     BEGIN
          s:=String(v);
          ASM
             PUSH DWORD PTR fi
             LEA EAX,s
             PUSH EAX
             PUSH DWORD PTR format
             CALLN32 SYSTEM.StrWriteText
          END;
     END;
END;

{Float value is in ST(0) !}
PROCEDURE WriteExtendedText({VAR f:FILE}Format1,Format2:LONGWORD);
VAR
   float:EXTENDED;
   fi:^FILE;
   s:STRING;
   Adr:LONGINT;
   SaveIO:BOOLEAN;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ASM
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
        FSTPT float

        PUSH DWORD PTR Format1
        PUSH DWORD PTR Format2     //Nachkommas
        LEA EAX,float
        PUSH EAX
        LEA EAX,s
        PUSH EAX
        CALLN32 SYSTEM.!Extended2Str
      END;
      SaveIO:=RaiseIOError;
      RaiseIOError:=FALSE;
      BlockWrite(fi^,s[1],length(s));
      RaiseIOError:=SaveIO;
      IF InOutRes<>0 THEN
      BEGIN
           IF RaiseIOError THEN InOutError(InOutRes,Adr)
           ELSE exit;
      END;
END;

{Float value is in ST(0) !}
PROCEDURE WriteCurrencyText({VAR f:FILE}Format1,Format2:LONGWORD);
VAR
   float:EXTENDED;
   fi:^FILE;
   s:STRING;
   Adr:LONGINT;
   SaveIO:BOOLEAN;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     IF Format2>4 THEN Format2:=4;  //Immer 4 Nachkommas
     ASM
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
        FRNDINT
        FLDT SYSTEM.FromCurrency  //*0.0001
        FMULP ST(1),ST
        FSTPT float

        PUSH DWORD PTR Format1
        PUSH DWORD PTR Format2     //Nachkommas
        LEA EAX,float
        PUSH EAX
        LEA EAX,s
        PUSH EAX
        CALLN32 SYSTEM.!Extended2Str
      END;
      SaveIO:=RaiseIOError;
      RaiseIOError:=FALSE;
      BlockWrite(fi^,s[1],length(s));
      RaiseIOError:=SaveIO;
      IF InOutRes<>0 THEN
      BEGIN
           IF RaiseIOError THEN InOutError(InOutRes,Adr)
           ELSE exit;
      END;
END;


{$HINTS OFF}
{Float value is in ST(0) !}
PROCEDURE WriteCompText({VAR f:FILE}Format1,Format2:LONGWORD);
VAR
   aComp:COMP;
   fi:^FILE;
   s:STRING;
   Adr:LONGINT;
   SaveIO:BOOLEAN;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ASM
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
        FISTP QWORD PTR aComp

        PUSH DWORD PTR Format1
        PUSHL 0           //keine Nachkommas
        LEA EAX,aComp
        PUSH EAX
        LEA EAX,s
        PUSH EAX
        CALLN32 SYSTEM.!Comp2Str
      END;
      SaveIO:=RaiseIOError;
      RaiseIOError:=FALSE;
      BlockWrite(fi^,s[1],length(s));
      RaiseIOError:=SaveIO;
      IF InOutRes<>0 THEN
      BEGIN
           IF RaiseIOError THEN InOutError(InOutRes,Adr)
           ELSE exit;
      END;
END;
{$HINTS ON}

PROCEDURE WriteLongintText({VAR f:FILE}Value:LONGINT;Format:LONGWORD);
VAR
   fi:^FILE;
   s:STRING;
   Adr:LONGINT;
   SaveIO:BOOLEAN;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
     END;

     STR(Value:Format,s);
     SaveIO:=RaiseIOError;
     RaiseIOError:=FALSE;
     BlockWrite(fi^,s[1],length(s));
     RaiseIOError:=SaveIO;
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

PROCEDURE WriteLongWordText({VAR f:FILE}Value:LONGWORD;Format:LONGWORD);
VAR
   fi:^FILE;
   s:STRING;
   Adr:LONGINT;
   SaveIO:BOOLEAN;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
     END;

     STR(Value:Format,s);
     SaveIO:=RaiseIOError;
     RaiseIOError:=FALSE;
     BlockWrite(fi^,s[1],length(s));
     RaiseIOError:=SaveIO;
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

{$IFDEF SPDLL30}
PROCEDURE PointerWriteText({VAR f:FILE}Const p:Pointer;format:LongWord);

VAR fi:^FILE;
    s:STRING;
    Adr:LONGINT;
    SaveIO:BOOLEAN;

BEGIN
  ASM
    MOV EAX,[EBP+4]
    SUB EAX,5
    MOV Adr,EAX
    MOV EAX,[EBP+16]  //VAR f:FILE
    MOV fi,EAX
  END;

  s:=tohex(longword(p));
  SaveIO:=RaiseIOError;
  RaiseIOError:=FALSE;
  BlockWrite(fi^,s[1],length(s));
  RaiseIOError:=SaveIO;
  IF InOutRes<>0 THEN
    BEGIN
      IF RaiseIOError
        THEN InOutError(InOutRes,Adr)
        ELSE exit;
    END;
End;
{$ENDIF}

{$HINTS OFF}
PROCEDURE WriteBooleanText({VAR f:FILE}Value:Boolean;Format:LONGWORD);
VAR
   fi:^FILE;
   s:STRING;
   Adr:LONGINT;
   SaveIO:BOOLEAN;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
     END;

     IF Value THEN s:='TRUE'
     ELSE s:='FALSE';
     SaveIO:=RaiseIOError;
     RaiseIOError:=FALSE;
     BlockWrite(fi^,s[1],length(s));
     RaiseIOError:=SaveIO;
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;
{$HINTS ON}

PROCEDURE WriteCharText({VAR f:FILE}Value:Char;Format:LONGWORD);
VAR
   fi:^FILE;
   s:STRING;
   Adr:LONGINT;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
     END;
     s:=Value;
     ASM
        PUSH DWORD PTR fi
        LEA EAX,s
        PUSH EAX
        PUSH DWORD PTR Format
        CALLN32 SYSTEM.StrWriteText
        ADD ESP,4
     END;
END;

PROCEDURE WritelnText(VAR f:FILE);
VAR
   w:WORD;
   Adr:LONGINT;
   SaveIO:BOOLEAN;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     {Write #13#10}
     w:=$0a0d;
     SaveIO:=RaiseIOError;
     RaiseIOError:=FALSE;
     BlockWrite(f,w,2);
     RaiseIOError:=SaveIO;
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

{$HINTS OFF}
PROCEDURE WriteText(VAR f:FILE);
BEGIN
     {do nothing here - just pop f}
END;
{$HINTS ON}

PROCEDURE FileWrite({VAR f:FILE)}VAR Buf;size:LONGWORD);
VAR
   fi:^FILE;
   fr:^FileRec;
   Adr:LONGINT;
   SaveIO:BOOLEAN;
BEGIN
     ASM
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
        MOV fr,EAX
     END;
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     SaveIO:=RaiseIOError;
     RaiseIOError:=FALSE;
     BlockWrite(fi^,Buf,size DIV fr^.RecSize);
     RaiseIOError:=SaveIO;
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

PROCEDURE FileRead({VAR f:FILE}VAR Buf;size:LONGWORD);
VAR
   fi:^FILE;
   fr:^FileRec;
   Adr:LONGINT;
   SaveIO:BOOLEAN;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ASM
        MOV EAX,[EBP+16]  //VAR f:FILE
        MOV fi,EAX
        MOV fr,EAX
     END;

     SaveIO:=RaiseIOError;
     RaiseIOError:=FALSE;
     BlockRead(fi^,Buf,size DIV fr^.RecSize);
     RaiseIOError:=SaveIO;
     IF InOutRes<>0 THEN
     BEGIN
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;
END;

FUNCTION SeekEoln(VAR F:Text):Boolean;
VAR
    Adr:LONGINT;
    fi:^FileRec;
    Offset:LONGINT;
    Value:BYTE;
    SaveIoError:BOOLEAN;
    Res:LONGWORD;
    t:BYTE;
    s:STRING;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;

     fi:=@f;

     IF fi^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF fi^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;
     END;

     IF eof(f) THEN
     BEGIN
          result:=TRUE;
          exit;
     END;

     Offset:=fi^.Offset;

     IF fi^.Buffer=NIL THEN
     BEGIN
          IF lo(fi^.BufferBytes)=1 THEN
          BEGIN
               Value:=Hi(fi^.BufferBytes);
          END
          ELSE
          BEGIN
               SaveIOError:=RaiseIOError;
               RaiseIOError:=FALSE;
               BlockRead(f,Value,1,Res);
               Seek(f,FilePos(f)-1);
               RaiseIOError:=SaveIOError;
               IF Res=0 THEN Value:=26; {EOF}
          END;
     END
     ELSE value:=fi^.Buffer^[Offset];

     IF value IN [13,10,26] THEN result:=TRUE
     ELSE
     BEGIN
          IF not (value IN [9,32]) THEN result:=FALSE
          ELSE  {must read the line}
          BEGIN
               SaveIOError:=RaiseIOError;
               RaiseIOError:=FALSE;

               Offset:=FilePos(f);
               Readln(f,s);
               Seek(f,Offset);

               RaiseIOError:=SaveIOError;
               result:=TRUE;
               FOR t:=1 TO length(s) DO
                 IF not (s[t] IN [#9,#32]) THEN result:=FALSE;
          END;
     END;
END;

FUNCTION SeekEof(Var F :Text):Boolean;
VAR
    Adr:LONGINT;
    fi:^FileRec;
    OldFP:LONGWORD;
    ch:Char;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;

     fi:=@f;

     IF fi^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF fi^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;
     END;

     OldFP := FilePos(F);

     WHILE not Eof(F) DO
     BEGIN
          Read(F,ch);
          IF not (ch IN [#32,#9,#13,#10]) THEN break;
     END;

     Result := Eof(f);
     Seek(F,OldFP);
END;

PROCEDURE TextRead({VAR f:TEXT;}VAR s:STRING;Typ,MaxLen:LONGWORD);
VAR
   fi:^FileRec;
   fi2:^TEXT;
   Offset,Ende,t,Temp,Res:LONGWORD;
   Count:WORD;
   Value:BYTE;
   SaveIoError:BOOLEAN;
   Adr:LONGINT;
LABEL l,skip;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ASM
        MOV EAX,[EBP+20]  //VAR f:TEXT
        MOV fi,EAX
        MOV fi2,EAX
     END;

     IF fi^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF fi^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;
     END;

     fi^.reserved1:=fi^.reserved1 and not 1;

     IF eof(fi2^) THEN
     BEGIN
          (*InOutRes:=38;  {Handle EOF}
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;*)
          CASE Typ OF
            1:s:=''; {String}
            2:s:=chr(26); {Char}
            3:s:=''; {Number}
            ELSE s:='';
          END; {case}
          exit;
     END;

     IF fi^.Block<>fi^.LBlock THEN Ende:=fi^.MaxCacheMem
     ELSE Ende:=fi^.LOffset;

     Count:=0;
     s:='';

     Offset:=fi^.Offset;

     IF fi^.Buffer=NIL THEN
     BEGIN
          Offset:=0;
          Ende:=256;
     END;

     fi^.reserved1:=fi^.reserved1 and not 1;
l:
     FOR t:=Offset TO Ende-1 DO
     BEGIN
          IF fi^.Buffer=NIL THEN
          BEGIN
               IF lo(fi^.BufferBytes)=1 THEN
               BEGIN
                    Value:=Hi(fi^.BufferBytes);
                    fi^.BufferBytes:=0;
               END
               ELSE
               BEGIN
                    SaveIOError:=RaiseIOError;
                    RaiseIOError:=FALSE;
                    BlockRead(fi2^,Value,1,Res);
                    RaiseIOError:=SaveIOError;
                    IF InOutRes<>0 THEN
                    BEGIN
                         IF RaiseIOError THEN InOutError(InOutRes,Adr)
                         ELSE exit;
                    END;
                    IF Res=0 THEN Value:=26; {EOF}
                    fi^.BufferBytes:=1 OR (Value SHL 8);
               END;
          END
          ELSE value:=fi^.Buffer^[t];

          IF value=26 {EOF} THEN
          BEGIN
               {SaveIoError:=RaiseIoError;
               RaiseIOError:=FALSE;
               Seek(fi2^,FileSize(fi2^));
               RaiseIOError:=SaveIoError;}
               fi^.Reserved1:=fi^.Reserved1 OR 1;  {mark EOF}
               IF Count>255 THEN Count:=255;
               s[0]:=chr(Count);
               IF s='' THEN s:=#26;
               inc(fi^.Offset);
               fi^.BufferBytes:=0;
               exit;
          END;

          CASE Typ OF
            1:  {String}
            BEGIN
                 CASE value OF
                   13,10:
                   BEGIN
                        IF Count>255 THEN Count:=255;
                        IF Count>255 THEN Count:=255;
                        s[0]:=chr(Count);
                        exit;
                   END;
                 END; {case}
            END;
            2:  {Char}
            BEGIN
                 s[1]:=chr(Value);
                 s[0]:=#1;

                 IF fi^.Buffer<>NIL THEN inc(fi^.Offset)
                 ELSE fi^.BufferBytes:=0;
                 IF fi^.Offset=Ende THEN
                 BEGIN
                      IF Eof(fi2^) THEN exit;

                      {Ende erreicht --> erweitern}
                      IF fi^.Buffer=NIL THEN exit;
                      FileBlockIO(fi2^,fi^.block+1,ReadMode,Temp);
                      IF InOutRes<>0 THEN
                      BEGIN
                          IF RaiseIOError THEN InOutError(InOutRes,Adr)
                          ELSE exit;
                      END;
                      fi^.offset:=0;
                      inc(fi^.block);
                 END;
                 exit;
            END;
            3:  {Number}
            BEGIN
                 CASE value OF
                   13,10,32,9:
                   BEGIN
                        IF Count=0 THEN goto skip; {skip preceding chars}
                        IF Count>255 THEN Count:=255;
                        s[0]:=chr(Count);
                        exit;
                   END;
                 END; {case}
            END;
          END; {case}

          inc(Count);
          IF Count<256 THEN IF Count<=MaxLen THEN s[Count]:=chr(value);
skip:
          inc(fi^.Offset);
          fi^.BufferBytes:=0;
          IF Count>=MaxLen THEN
          BEGIN
               IF Count>255 THEN Count:=255;
               s[0]:=chr(Count);
               exit;
          END;
     END;

     IF eof(fi2^) THEN
     BEGIN
          (*InOutRes:=38;  {Handle EOF}
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;*)
          IF Count>255 THEN Count:=255;
          s[0]:=chr(Count);
          exit;
     END;

     {Ende erreicht --> erweitern}
     IF fi^.Buffer<>NIL THEN
     BEGIN
          FileBlockIO(fi2^,fi^.block+1,ReadMode,Temp);
          IF InOutRes<>0 THEN
          BEGIN
              IF RaiseIOError THEN InOutError(InOutRes,Adr)
              ELSE exit;
          END;

          fi^.offset:=0;
          inc(fi^.block);
     END;

     IF eof(fi2^) THEN
     BEGIN
          InOutRes:=38;  {Handle EOF}
          IF RaiseIOError THEN InOutError(InOutRes,Adr)
          ELSE exit;
     END;

     IF fi^.Block<>fi^.LBlock THEN Ende:=fi^.MaxCacheMem
     ELSE Ende:=fi^.LOffset;
     Offset:=fi^.Offset;
     IF fi^.Buffer=NIL THEN
     BEGIN
          Offset:=0;
          Ende:=256;
     END;
     goto l;
END;

PROCEDURE TextReadLF(VAR f:TEXT);
VAR
   fi:^FileRec;
   Offset,Ende,t,Temp,Res:LONGWORD;
   Value:BYTE;
   Read13,Read10:BOOLEAN;
   Adr:LONGINT;
   SaveIO:BOOLEAN;
LABEL l;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     fi:=@f;

     IF fi^.flags<>$6666 THEN
     BEGIN
          IF RaiseIOError THEN InvalidFileNameError(Adr)
          ELSE
          BEGIN
               InOutRes:=206;
               exit;
          END;
     END;

     IF fi^.Handle=$ffffffff THEN
     BEGIN
         InOutRes:=6; {Invalid handle}
         IF RaiseIOError THEN InOutError(InOutRes,Adr)
         ELSE exit;
     END;

     fi^.reserved1:=fi^.reserved1 and not 1;

     IF Eof(f) THEN exit;

     Offset:=fi^.Offset;
     IF fi^.Block<>fi^.LBlock THEN Ende:=fi^.MaxCacheMem
     ELSE Ende:=fi^.LOffset;

     IF fi^.Buffer=NIL THEN
     BEGIN
          Offset:=0;
          Ende:=256;
     END;

     Read13:=FALSE;
     Read10:=FALSE;
l:
     FOR t:=Offset TO Ende-1 DO
     BEGIN
          IF fi^.Buffer=NIL THEN
          BEGIN
               IF lo(fi^.BufferBytes)=1 THEN
               BEGIN
                    Value:=Hi(fi^.BufferBytes);
                    fi^.BufferBytes:=0;
               END
               ELSE
               BEGIN
                    SaveIO:=RaiseIOError;
                    RaiseIOError:=FALSE;
                    BlockRead(f,Value,1,Res);
                    RaiseIOError:=SaveIO;
                    IF InOutRes<>0 THEN
                    BEGIN
                         IF RaiseIOError THEN InOutError(InOutRes,Adr)
                         ELSE exit;
                    END;
                    IF Res=0 THEN Value:=26; {EOF}
                    fi^.BufferBytes:=1 OR (Value SHL 8);
               END;
          END
          ELSE value:=fi^.Buffer^[t];
          CASE value OF
            26: {EOF}
            BEGIN
               fi^.Reserved1:=fi^.Reserved1 OR 1; {mark EOF}
               exit;
            END;
            13:
            BEGIN
                 IF ((Read13)OR(Read10)) THEN
                 BEGIN
                      fi^.BufferBytes:=0;
                      exit;
                 END;
                 Read13:=TRUE;
            END;
            10:
            BEGIN
                 IF Read10 THEN
                 BEGIN
                      fi^.BufferBytes:=0;
                      exit;
                 END;
                 {$IFDEF OS2}
                 IF fi^.Handle=0{Input} THEN IF Read13 THEN
                 {$ENDIF}
                 {$IFDEF Win32}
                 IF fi^.Handle=GetStdHandle(-10){Input} THEN IF Read13 THEN
                 {$ENDIF}
                 BEGIN
                      fi^.BufferBytes:=0;
                      exit;
                 END;
                 Read10:=TRUE;
            END;
            ELSE
            BEGIN
                 IF Read13 THEN
                 BEGIN
                      fi^.BufferBytes:=0;
                      exit;
                 END;
                 IF Read10 THEN
                 BEGIN
                      fi^.BufferBytes:=0;
                      exit;
                 END;
            END;
          END; {case}
          inc(fi^.Offset);
          fi^.BufferBytes:=0;
     END;

     IF Eof(f) THEN exit;

     {Ende erreicht --> erweitern}
     IF fi^.Buffer<>NIL THEN
     BEGIN
         FileBlockIO(f,fi^.block+1,ReadMode,Temp);
         IF InOutRes<>0 THEN
         BEGIN
             IF RaiseIOError THEN InOutError(InOutRes,Adr)
             ELSE exit;
         END;
         fi^.offset:=0;
         inc(fi^.block);
     END;

     IF eof(f) THEN exit;

     IF fi^.Block<>fi^.LBlock THEN Ende:=fi^.MaxCacheMem
     ELSE Ende:=fi^.LOffset;
     Offset:=fi^.Offset;
     IF fi^.Buffer=NIL THEN
     BEGIN
          Offset:=0;
          Ende:=256;
     END;
     goto l;
END;

PROCEDURE ReadLnText(VAR source:TEXT);
BEGIN
     TextReadLF(source);
END;

//TextScreen IO support
TYPE ProcVar=PROCEDURE;

PROCEDURE TScreenInOutClass.WriteStr(CONST s:STRING);
VAR
   actual:LONGWORD;
   by,by1:LONGWORD;
   Handle:LONGWORD;
   b:BYTE;
   ff:^FileRec;
   s1,s2:STRING;
   x,y:LONGINT;
   Fill:WORD;
   {$IFDEF Win32}
   csbi:CONSOLE_SCREEN_BUFFER_INFO;
   coPos:COORD;
   sr:SMALL_RECT;
   ci:CHAR_INFO;
   {$ENDIF}
LABEL l,l1;
BEGIN
     ff:=@Output;
     Handle:=ff^.Handle;

     IF RedirectOut THEN goto l1;

     s1:=s;
     b:=Pos(#13#10,s1);
     WHILE b<>0 DO
     BEGIN
          s2:=s1;
          s1:=copy(s1,1,b-1);
          WriteStr(s1);
          s1:=#13#10;
          {$IFDEF OS2}
          ASM
            LEA EAX,actual
            PUSH EAX                //pcbActual
            LEA EDI,s1
            MOVZXB EAX,[EDI]
            PUSH EAX               //cbWrite
            INC EDI
            PUSH EDI               //pBuffer
            PUSH DWORD PTR Handle  //FileHandle
            MOV AL,4
            CALLDLL DosCalls,282   //DosWrite
            ADD ESP,16
          END;
          y:=GetCurPosY; // VioWhereYProc;
          {$ENDIF}
          {$IFDEF Win32}
          WriteFile(ff^.Handle,s1[1],length(s1),actual,NIL);
          GetConsoleScreenBufferInfo(ff^.Handle,csbi);
          y:=csbi.dwCursorPosition.Y+1;
          {$ENDIF}
          IF y-1>Hi(WindMax) THEN
          BEGIN
              {Scroll window}
              {$IFDEF OS2}
              Fill:= 32 + WORD(TextAttr) SHL 8;
              VioScrollUpProc(Hi(WindMin),Lo(WindMin),
                              Hi(WindMax),Lo(WindMax),
                              1,Fill,0);
              {$ENDIF}
              {$IFDEF Win32}
              Fill:= TextAttr;
              sr.Left:=lo(WindMin);
              sr.Right:=lo(WindMax)+1;
              sr.Top:=hi(WindMin)+1;
              sr.Bottom:=hi(WindMax);
              coPos.X:=lo(WindMin);
              coPos.Y:=hi(WindMin);
              ci.Char.AsciiChar:=#32;
              ci.Attributes:=Fill;
              ScrollConsoleScreenBuffer(ff^.Handle,sr,NIL,LONGWORD(coPos),ci);
              {$ENDIF}
              dec(y);
          END;
          GotoXY(1,y-Hi(WindMin));
          s1:=copy(s2,b+2,length(s2)-(b+1));
          b:=Pos(#13#10,s1);
     END;

     {$IFDEF OS2}
     x:=GetCurPosX;    // VioWhereXProc;
     {$ENDIF}
     {$IFDEF Win32}
     GetConsoleScreenBufferInfo(ff^.Handle,csbi);
     x:=csbi.dwCursorPosition.X+1;
     {$ENDIF}
     IF length(s1)>(Lo(WindMax)-Lo(WindMin)-
              (x-lo(WindMin)))+1 THEN
     BEGIN
          by:=(Lo(WindMax)-Lo(WindMin)-(x-lo(WindMin)))+2;
          by1:=length(s1)-by;
l:
          {$IFDEF OS2}
          ASM
             LEA EAX,actual
             PUSH EAX               //pcbActual
             LEA EDI,s1
             INC EDI
             PUSH DWORD PTR by      //cbWrite
             PUSH EDI               //pBuffer
             PUSH DWORD PTR Handle  //FileHandle
             MOV AL,4
             CALLDLL DosCalls,282   //DosWrite
             ADD ESP,16
          END;
          {$ENDIF}
          {$IFDEF Win32}
          WriteFile(ff^.Handle,s1[1],by,actual,NIL);
          {$ENDIF}
          s1:=copy(s1,by+1,length(s1)-by);

          IF ((WindMin<>MaxWindMin)OR(WindMax<>MaxWindMax)) THEN WriteLF;

          {$IFDEF OS2}
          x:=GetCurPosX;    // VioWhereXProc;
          {$ENDIF}
          {$IFDEF Win32}
          GetConsoleScreenBufferInfo(ff^.Handle,csbi);
          x:=csbi.dwCursorPosition.X+1;
          {$ENDIF}

          IF length(s1)>(Lo(WindMax)-Lo(WindMin)-(x-lo(WindMin)))+1 THEN
          BEGIN
               by:=(Lo(WindMax)-Lo(WindMin)-(x-lo(WindMin)))+2;
               by1:=length(s1)-by;
               goto l;
          END;

          {$IFDEF OS2}
          ASM
             LEA EAX,actual
             PUSH EAX               //pcbActual
             LEA EDI,s1
             INC EDI
             PUSH DWORD PTR by1     //cbWrite
             PUSH EDI               //pBuffer
             PUSH DWORD PTR Handle  //FileHandle
             MOV AL,4
             CALLDLL DosCalls,282   //DosWrite
             ADD ESP,16
          END;
          {$ENDIF}
          {$IFDEF Win32}
          WriteFile(ff^.Handle,s1[1],by1,actual,NIL);
          {$ENDIF}

          exit;
     END;
l1:
     {$IFDEF OS2}
     ASM
        LEA EAX,actual
        PUSH EAX                //pcbActual
        LEA EDI,s1
        MOVZXB EAX,[EDI]
        PUSH EAX               //cbWrite
        INC EDI
        PUSH EDI               //pBuffer
        PUSH DWORD PTR Handle  //FileHandle
        MOV AL,4
        CALLDLL DosCalls,282   //DosWrite
        ADD ESP,16
     END;
     {$ENDIF}
     {$IFDEF Win32}
     WriteFile(ff^.Handle,s1[1],length(s1),actual,NIL);
     {$ENDIF}
END;

PROCEDURE TScreenInOutClass.WriteCStr(CONST s:CSTRING);
VAR
   c:STRING;
   b:LONGWORD;
   pc:^CSTRING;
LABEL l;
BEGIN
     pc:=@s;
l:
     b:=Length(pc^);
     IF b<255 THEN
     BEGIN
          c:=pc^;
          WriteStr(c);
     END
     ELSE
     BEGIN
          move(pc^,c[1],255);
          c[0]:=#255;
          inc(pc,255);
          WriteStr(c);
          goto l;
     END;
END;

PROCEDURE TScreenInOutClass.WriteLF;
VAR y:BYTE;
    Fill:WORD;
    s:STRING[3];
    Actual:LONGWORD;
    ff:^FileRec;
    Handle:LONGWORD;
    {$IFDEF Win32}
    coPos:COORD;
    csbi:CONSOLE_SCREEN_BUFFER_INFO;
    sr:SMALL_RECT;
    ci:CHAR_INFO;
    {$ENDIF}
BEGIN
     s:=#13#10;
     ff:=@Output;
     Handle:=ff^.Handle;

     {$IFDEF OS2}
     ASM
        LEA EAX,actual
        PUSH EAX                //pcbActual
        LEA EDI,s
        MOVZXB EAX,[EDI]
        PUSH EAX               //cbWrite
        INC EDI
        PUSH EDI               //pBuffer
        PUSH DWORD PTR Handle  //FileHandle
        MOV AL,4
        CALLDLL DosCalls,282   //DosWrite
        ADD ESP,16
     END;
     {$ENDIF}
     {$IFDEF Win32}
     WriteFile(Handle,s[1],length(s),actual,NIL);
     {$ENDIF}
     {$IFDEF OS2}
     y:=GetCurPosY;   // VioWhereYProc;
     {$ENDIF}
     {$IFDEF Win32}
     GetConsoleScreenBufferInfo(ff^.Handle,csbi);
     y:=csbi.dwCursorPosition.Y+1;
     {$ENDIF}
     IF y-1>Hi(WindMax) THEN
     BEGIN
          {Scroll window}
          {$IFDEF OS2}
          Fill:= 32 + WORD(TextAttr) SHL 8;
          VioScrollUpProc(Hi(WindMin),Lo(WindMin),
                          Hi(WindMax),Lo(WindMax),
                          1,Fill,0);
          {$ENDIF}
          {$IFDEF Win32}
          Fill:= TextAttr;
          sr.Left:=lo(WindMin);
          sr.Right:=lo(WindMax);
          sr.Top:=hi(WindMin)+1;
          sr.Bottom:=hi(WindMax);
          coPos.X:=lo(WindMin);
          coPos.Y:=hi(WindMin);
          ci.Char.AsciiChar:=#32;
          ci.Attributes:=Fill;
          ScrollConsoleScreenBuffer(ff^.Handle,sr,NIL,LONGWORD(coPos),ci);
          {$ENDIF}
          dec(y);
     END;
     GotoXY(1,y-Hi(WindMin));
END;

PROCEDURE TScreenInOutClass.ReadLF(VAR s:STRING);
VAR
    ff:^FileRec;
    {$IFDEF OS2}
    t:BYTE;
    y:LONGINT;
    Fill:WORD;
    {$ENDIF}
    {$IFDEF Win32}
    Actual:LONGWORD;
    {$ENDIF}
BEGIN
     {$IFDEF OS2}
     ASM
        PUSHL OFFSET(SYSTEM.Input)
        MOV EAX,s
        PUSH EAX
        PUSHL 1
        PUSHL 255
        CALLN32 SYSTEM.TextRead
        ADD ESP,8
        PUSHL OFFSET(SYSTEM.Input)
        CALLN32 SYSTEM.TextReadLF
     END;
     t:=Pos(#26,s);
     IF t<>0 THEN
     BEGIN
          ff:=@Input;
          ff^.Reserved1:=ff^.Reserved1 OR 1; {mark EOF}
          s[0]:=chr(t-1);
     END;
     y:=GetCurPosY;    // VioWhereYProc;
     IF y-1>Hi(WindMax) THEN
     BEGIN
          {Scroll window}
          Fill:= 32 + WORD(TextAttr) SHL 8;
          VioScrollUpProc(Hi(WindMin),Lo(WindMin),
                          Hi(WindMax),Lo(WindMax),
                          1,Fill,0);
          dec(y);
     END;
     ScreenInOut.GotoXY(1,y-Hi(WindMin));
     {$ENDIF}
     {$IFDEF Win32}
     ff:=@Input;
     ReadFile(ff^.Handle,s[1],255,Actual,NIL);
     s[0]:=chr(Actual);
     IF s[length(s)]=#10 THEN dec(s[0]);
     IF s[length(s)]=#13 THEN dec(s[0]);
     {$ENDIF}
END;

PROCEDURE TScreenInOutClass.GotoXY(x,y:BYTE);
{$IFDEF Win32}
VAR coPos:COORD;
    ff:^FileRec;
{$ENDIF}
BEGIN
     X:=X-1+Lo(WindMin);
     Y:=Y-1+Hi(WindMin);
     IF (X<=Lo(WindMax))and(Y<=Hi(WindMax)) THEN
     BEGIN
          {$IFDEF OS2}
          VioSetCurPosProc(Y,X,0);
          {$ENDIF}
          {$IFDEF Win32}
          ff:=@Output;
          coPos.X:=X;
          coPos.Y:=Y;
          SetConsoleCursorPosition(ff^.Handle,LONGWORD(coPos));
          {$ENDIF}
     END;
END;

PROCEDURE TPMScreenInOutClass.Error;
{$IFDEF OS2}
VAR
   cs:CSTRING;
   cTitle:CSTRING;
{$ENDIF}
BEGIN
     {$IFDEF OS2}
     ctitle:='Wrong linker target';
     cs:='PM Linker mode does not support text screen IO.'+#13+
         'Use the unit WinCrt if you wish to use text'+#13+
         'screen IO inside PM applications.';
     InitPM;
     WinMessageBox(1,1,cs,ctitle,0,$4000 OR $0010);
     {$ENDIF}
     {$IFDEF Win32}
     MessageBox(0,'Win32 GUI linker target does not support textscreen I/O'#13+
                  'Use the Unit WINCRT if you wish to use'#13
                  'textscreen I/O within GUI applications','Error',0);
     {$ENDIF}
     Halt(0);
END;

{$HINTS OFF}
PROCEDURE TPMScreenInOutClass.WriteStr(CONST s:STRING);
BEGIN
     Error;
END;

PROCEDURE TPMScreenInOutClass.WriteCStr(CONST s:CSTRING);
BEGIN
     Error;
END;

PROCEDURE TPMScreenInOutClass.WriteLF;
BEGIN
     Error;
END;

PROCEDURE TPMScreenInOutClass.ReadLF(VAR s:STRING);
BEGIN
     Error;
END;

PROCEDURE TPMScreenInOutClass.GotoXY(x,y:BYTE);
BEGIN
     Error;
END;
{$HINTS ON}

Var sg:CString;

{$IFDEF OS2}
PROCEDURE InitScreenInOut;
VAR VioMode:VioModeInfo;
    Size,Value:WORD;

BEGIN
     ScreenInOut.Create;
     VioMode.cb := SizeOf(VioModeInfo);
     VioGetModeProc(VioMode, 0);

     WITH VioMode DO
       BEGIN
         IF Col = 40
           THEN LastMode := BW40
           ELSE LastMode := BW80;
         IF (fbType AND 4) = 0 THEN
           IF LastMode = BW40
             THEN LastMode := CO40
             ELSE LastMode := CO80;
         IF Color = 0 THEN LastMode := Mono;
         IF Row > 25 THEN Inc(LastMode,Font8x8);
     END;

     WindMin := 0;
     WindMax := VioMode.Col - 1 + (VioMode.Row - 1) SHL 8;
     MaxWindMin :=WindMin;
     MaxWindMax :=WindMax;

     Size := 2;
     VioReadCellStrProc(Value, Size, GetCurPosY-1, GetCurPosX-1, 0);
     TextAttr := Hi(Value) AND $7F;
END;
{$ENDIF}

{$IFDEF Win32}
PROCEDURE InitScreenInOut;
VAR
    Value:WORD;
    csbi:CONSOLE_SCREEN_BUFFER_INFO;
    ff:^FileRec;
    co:COORD;
    Actual:LONGWORD;
BEGIN
     ScreenInOut.Create;

     ff:=@Output;
     GetConsoleScreenBufferInfo(ff^.Handle,csbi);

     WITH csbi DO
     BEGIN
          IF dwSize.X = 40 THEN LastMode := CO40
          ELSE LastMode := CO80;
          IF dwSize.Y > 25 THEN Inc(LastMode,Font8x8);
     END;

     WindMin := 0;
     WindMax := csbi.dwSize.X - 1 + (csbi.dwSize.Y - 1) SHL 8;
     MaxWindMin :=WindMin;
     MaxWindMax :=WindMax;

     co.X:=1;
     co.Y:=1;

     ReadConsoleOutputAttribute(ff^.Handle,Value,2,LONGWORD(co),Actual);
     TextAttr := Hi(Value) AND $7F;

     ff:=@Input;
     SetConsoleMode(ff^.Handle,ENABLE_PROCESSED_INPUT OR ENABLE_LINE_INPUT OR
       ENABLE_ECHO_INPUT OR ENABLE_WINDOW_INPUT OR ENABLE_MOUSE_INPUT OR
       ENABLE_PROCESSED_OUTPUT OR ENABLE_WRAP_AT_EOL_OUTPUT);
END;
{$ENDIF}

PROCEDURE InitScreenInOutPM;
VAR
   c:TPMScreenInOutClass;
BEGIN
     c.Create;
     ScreenInOut:=TScreenInOutClass(c);
END;

PROCEDURE LongInt2Str(l:LONGINT;Format:LONGWORD;VAR result:STRING);FORWARD;
PROCEDURE LongWord2Str(l:LONGWORD;Format:LONGWORD;VAR result:STRING);FORWARD;
PROCEDURE StrWrite(CONST s:STRING;format:LONGWORD);FORWARD;

PROCEDURE BooleanWrite(l:LONGBOOL;Format:LONGWORD);
BEGIN
     IF l THEN StrWrite('TRUE',Format)
     ELSE StrWrite('FALSE',Format);
END;

PROCEDURE CharWrite(l:char;Format:LONGWORD);
VAR s:STRING;
BEGIN
     s[0]:=#1;
     s[1]:=l;
     StrWrite(s,Format);
END;

PROCEDURE LongintWrite(l:LONGINT;Format:LONGWORD);
VAR s:STRING;
BEGIN
     Longint2Str(l,Format,s);
     StrWrite(s,0);
END;

PROCEDURE LongwordWrite(l:LONGWORD;Format:LONGWORD);
VAR s:STRING;
BEGIN
     Longword2Str(l,Format,s);
     StrWrite(s,0);
END;

{$IFDEF SPDLL30}
PROCEDURE PointerWrite(Const p:Pointer;format:LongWord);

Begin
  StrWrite(tohex(longword(p)),0);
End;
{$ENDIF}


PROCEDURE StrWrite(CONST s:STRING;format:LONGWORD);
VAR ss:STRING;
    p:^STRING;
BEGIN
     IF Format+Length(s)>255 THEN Format:=255-length(s);
     IF format>length(s) THEN
     BEGIN
          format:=format-length(s);
          ss[0]:=chr(format+length(s));
          fillchar(ss[1],format,32);
          p:=@s;
          move(p^[1],ss[format+1],length(s));
          ScreenInOut.WriteStr(ss);
     END
     ELSE ScreenInOut.WriteStr(s);
END;

PROCEDURE CStrWrite(CONST s:CSTRING;format:LONGWORD);
VAR ss:CSTRING;
    p:^CSTRING;
    l:LONGWORD;
BEGIN
     l:=length(s);
     IF ((format>l)AND(l+format<255)) THEN
     BEGIN
          format:=format-l;
          fillchar(ss[0],format,32);
          p:=@s;
          move(p^[0],ss[format],l+1);
          ScreenInOut.WriteCStr(ss);
     END
     ELSE ScreenInOut.WriteCStr(s);
END;

PROCEDURE ArrayWrite(CONST s;format:LONGWORD;MaxLen:LONGWORD);
VAR pc:PChar;
BEGIN
     GetMem(pc,MaxLen+1);
     Move(s,pc^,MaxLen);
     pc^[MaxLen]:=#0;  //terminate PChar
     CStrWrite(pc^,Format);
     FreeMem(pc,MaxLen+1);
END;

PROCEDURE AnsiStrWrite(CONST s:AnsiString;Format:LONGWORD);
BEGIN
     IF PChar(s)=NIL THEN exit;  {String is empty}
     CStrWrite(PChar(s)^,format);
END;

PROCEDURE VariantWrite(CONST v:VARIANT;Format:LONGWORD);
VAR s:STRING;
BEGIN
     IF VarType(v) and VarTypeMask=varString THEN
     BEGIN
          ASM
             MOV EAX,v
             PUSH DWORD PTR [EAX+2]  //by value !!
             PUSH DWORD PTR Format
             CALLN32 SYSTEM.AnsiStrWrite
          END;
     END
     ELSE
     BEGIN
          s:=String(v);
          StrWrite(s,Format);
     END;
END;

PROCEDURE WriteLine;
BEGIN
     ScreenInOut.WriteLF;
END;

PROCEDURE ReadLine;
VAR
   s:STRING;
BEGIN
     ScreenInOut.ReadLF(s);
END;

PROCEDURE StrRead(VAR s:STRING);
BEGIN
     ScreenInOut.ReadLF(s);
END;

CONST
     Typ_String   = 1;
     Typ_Char     = 2;
     Typ_Number   = 3;

PROCEDURE GetNextStr(VAR s,Ziel:STRING;Typ:LONGWORD);
VAR t:BYTE;
LABEL l;
BEGIN
     IF s='' THEN
     BEGIN
          StrRead(s);
          s:=s+#13#10;
     END;

     Ziel:='';
     CASE Typ OF
        Typ_String:
        BEGIN
             {copy whole}
             IF s=#13#10 THEN Ziel:=''
             ELSE
             BEGIN
                  Ziel:=Copy(s,1,length(s)-2);
                  s:=#13#10;
             END;
        END;
        Typ_Char:
        BEGIN
             Ziel:=s[1];
             Delete(s,1,1);
        END;
        Typ_Number:
        BEGIN
l:
             IF length(s)<3 THEN  {am Zeilenende ??}
             BEGIN
                  StrRead(s);
                  s:=s+#13#10;
             END;

             {Skip spaces}
             IF s[1]=#32 THEN
             BEGIN
                  Delete(s,1,1);
                  goto l;
             END;

             FOR t:=1 TO length(s) DO
             BEGIN
                 CASE s[t] OF
                    #9,#13,#10,#32:  {Trennzeichen}
                    BEGIN
                         Ziel:=Copy(s,1,t-1);
                         Delete(s,1,t-1); {Trenner nicht mit l”schen}
                         exit;
                    END;
                 END; {case}
             END;
        END;
     END; {case}
END;


//************************************************************************
// CLASS support
//************************************************************************

{Constructor for all classes}
CONSTRUCTOR TObject.Create;
BEGIN
     {
     p:=POINTER(SELF);
     inc(p,4);
     fillchar(p^,4,0);
     }
     {InitInstance(POINTER(SELF));} {Memory is always initialized with zero}
END;

{Destructor for all classes}
DESTRUCTOR TObject.Destroy;
BEGIN
END;

FUNCTION TObject.GetPropertyTypeInfo(PropertyName:STRING;VAR Info:TPropertyTypeInfo):BOOLEAN;

{$IFDEF SPDLL30W32}
Var Class_Info  : PClassInfoLayout;
    Class_VMT   : PVmtLayOut;
    PropertyInfo: pPropertyInfo;
    l           : ^LongWord;
    ps          : ^String;
    s           : STRING;
{$ELSE}
VAR l,c:^LONGWORD;
    ps:^STRING;
    s:STRING;
{$ENDIF}

BEGIN
  result:=FALSE;
  UpcaseStr(PropertyName);
{$IFDEF SPDLL30W32}
  Class_Info:=ClassInfo;
  While Class_Info<>nil do
    Begin
      PropertyInfo:= Pointer(LongWord((@Class_Info^.PropertyInfo)) + Class_Info^.PropertyInfo);
      Info.NameTable:=Pointer(PropertyInfo^.PropertyNameInfo);
      l:=@PropertyInfo.Data;

      ps:=Pointer(l);
      WHILE ps^[0]<>#0 DO
        BEGIN
          IF ps^[0]=PropertyName[0] THEN  //found !!
            Begin
               s:=ps^;
               UpcaseStr(s);
               if s=PropertyName then
                 Begin
                   result:=TRUE;
                   inc(l,ord(ps^[0])+1); //skip name
                   Info.Scope:=l^ AND 255;
                   inc(l);
                   l:=Pointer(l^);     //Type and access info

                   IF ((Info.Scope AND 24=0)OR(l=NIL)) THEN
                     BEGIN
                       result:=FALSE;  //not a published property
                       exit;
                     END;
                   Info.PropInfo:=Pointer(l);
                   Info.Read.Kind:=l^ AND 255;      // read Access type (0-none, 1-Field Offset, 2- VMT call, 3- Method call)
                   inc(l);
                   IF Info.Read.Kind<>0 THEN
                     BEGIN
                       Info.Read.VarOffset:=l^;     // read Access info (Offset or VMT Index or Address)
                       inc(l,4);
                       inc(l,2);                    // read Access index (or -32768 for none)
                     END;

                   Info.Write.Kind:=l^ AND 255;     // write Access type (as read Access type)
                   inc(l);
                   IF Info.Write.Kind<>0 THEN
                     BEGIN
                       Info.Write.VarOffset:=l^;    // write Access info (as read Access info)
                       inc(l,4);
                       inc(l,2);                    // write Access index (or -32768 for none)
                     END;

                   Info.Size:=l^;
                   inc(l,4);
                   Info.TypeInfo:=Pointer(l);
                   Info.Typ:=l^ AND 255;
                   exit;
                 End;
            End;

          inc(l,ord(ps^[0])+6);    //skip this entry
          ps:=Pointer(l);
        end;

// Ermitteln der Parent-Class-Info
      Class_VMT:= GetClassParent(Class_Info);
      if Class_VMT=nil then break;
      Class_Info:=Pointer(LongWord(Class_VMT) + LongWord(Class_VMT.ClassInfo) +4);
    end;

{$ELSE}
  l:=POINTER(SELF);
  l:=POINTER(l^);  //VMT address
  WHILE l<>NIL DO
  BEGIN
       inc(l,4);
       l:=POINTER(l^);  //Class info
       c:=l;
       inc(l,12);
       l:=POINTER(l^);  //Property info
       inc(l,4);
       Info.NameTable:=Pointer(l^);
       inc(l,4);        //Start of Properties
       ps:=Pointer(l);
       WHILE ps^[0]<>#0 DO
       BEGIN
            IF ps^[0]=PropertyName[0] THEN  //found !!
            BEGIN
                 s:=ps^;
                 UpcaseStr(s);
                 IF s=PropertyName THEN
                 BEGIN
                      result:=TRUE;
                      inc(l,ord(ps^[0])+1); //skip name
                      Info.Scope:=l^ AND 255;

                      inc(l);
                      l:=Pointer(l^);     //Type and access info

                      IF ((Info.Scope AND 24=0)OR(l=NIL)) THEN
                      BEGIN
                           result:=FALSE;  //not a published property
                           exit;
                      END;

                      Info.PropInfo:=Pointer(l);
                      Info.Read.Kind:=l^ AND 255;
                      inc(l);
                      IF Info.Read.Kind<>0 THEN
                      BEGIN
                           Info.Read.VarOffset:=l^;
                           inc(l,4);
                      END;
                      Info.Write.Kind:=l^ AND 255;
                      inc(l);
                      IF Info.Write.Kind<>0 THEN
                      BEGIN
                           Info.Write.VarOffset:=l^;
                           inc(l,4);
                      END;
                      Info.Size:=l^;
                      inc(l,4);
                      Info.TypeInfo:=Pointer(l);
                      Info.Typ:=l^ AND 255;

                      exit;
                 END;
            END;

            inc(l,ord(ps^[0])+6);    //skip this entry
            ps:=Pointer(l);
       END;

       inc(c,4);
       l:=Pointer(c^);  //Parent VMT or NIL
  END;
{$ENDIF}
END;

PROCEDURE TObject.EnumProperties(EnumProc:TPropertyEnumProc);

  Procedure EnumProperties_V25;

  VAR l,l1,c:^LONGWORD;
      ps:^STRING;
      Info:TPropertyTypeInfo;

  Begin
    l:=POINTER(SELF);
    l:=POINTER(l^);  //VMT address
    WHILE l<>NIL DO
      BEGIN
        inc(l,4);
        l:=POINTER(l^);  //Class info
        c:=l;
        inc(l,12);
        l:=POINTER(l^);  //Property info
        inc(l,4);        //onto Name Table
        Info.NameTable:=Pointer(l^);
        inc(l,4);        //Start of Properties
        ps:=Pointer(l);
        WHILE ps^[0]<>#0 DO
          BEGIN
            inc(l,ord(ps^[0])+1); //skip name
            Info.Scope:=l^ AND 255;
            inc(l);
            l1:=l;
            inc(l1,4);

            l:=Pointer(l^);     //Type and access info
            IF l<>NIL
              THEN
                BEGIN
                  Info.PropInfo:=Pointer(l);
                  Info.Read.Kind:=l^ AND 255;
                  inc(l);
                  IF Info.Read.Kind<>0 THEN
                    BEGIN
                      Info.Read.VarOffset:=l^;
                      inc(l,4);
                    END;
                  Info.Write.Kind:=l^ AND 255;
                  inc(l);
                  IF Info.Write.Kind<>0 THEN
                    BEGIN
                      Info.Write.VarOffset:=l^;
                      inc(l,4);
                    END;

                  Info.Size:=l^;
                  inc(l,4);
                  Info.TypeInfo:=Pointer(l);
                  Info.Typ:=l^ AND 255;
               END
             ELSE
               BEGIN
                 Info.PropInfo:=NIL;
                 Info.Read.Kind:=0;
                 Info.Write.Kind:=0;
                 Info.Size:=0;
                 Info.TypeInfo:=NIL;
                 Info.Typ:=0;
               END;
           EnumProc(ps,Info);

           l:=l1;
           ps:=Pointer(l);
        END;

      inc(c,4);
      l:=Pointer(c^);  //Parent VMT or NIL
    END;
  end;

  Procedure EnumProperties_V30;

  Var Class_Info  : PClassInfoLayout;
      Class_VMT   : PVmtLayOut;
      PropertyInfo: pPropertyInfo;
      l,l1        : ^LongWord;
      ps          : ^String;
      s           : STRING;
      Info        : TPropertyTypeInfo;

  Begin
    Class_Info:=ClassInfo_V30;
    While Class_Info<>nil do
      Begin
        PropertyInfo:= Pointer(LongWord((@Class_Info^.PropertyInfo)) + Class_Info^.PropertyInfo);
        Info.NameTable:=Pointer(PropertyInfo^.PropertyNameInfo);
        l:=@PropertyInfo^.Data;
        ps:=Pointer(l);
        WHILE ps^[0]<>#0 DO
          BEGIN
            inc(l,ord(ps^[0])+1); //skip name
            Info.Scope:=l^ AND 255;
            inc(l);
            l1:=l;
            inc(l1,4);

            l:=Pointer(l^);     //Type and access info
            IF l<>NIL
              THEN
                BEGIN
                  Info.PropInfo:=Pointer(l);
                  Info.Read.Kind:=l^ AND 255;      // read Access type (0-none, 1-Field Offset, 2- VMT call, 3- Method call)
                  inc(l);
                  IF Info.Read.Kind<>0 THEN
                    BEGIN
                      Info.Read.VarOffset:=l^;     // read Access info (Offset or VMT Index or Address)
                      inc(l,4);
                      inc(l,2);                    // read Access index (or -32768 for none)
                    END;
                  Info.Write.Kind:=l^ AND 255;     // write Access type (as read Access type)
                  inc(l);
                  IF Info.Write.Kind<>0 THEN
                    BEGIN
                      Info.Write.VarOffset:=l^;    // write Access info (as read Access info)
                      inc(l,4);
                      inc(l,2);                    // write Access index (or -32768 for none)
                    END;

                  Info.Size:=l^;
                  inc(l,4);
                  Info.TypeInfo:=Pointer(l);
                  Info.Typ:=l^ AND 255;
               END
             ELSE
               BEGIN
                 Info.PropInfo:=NIL;
                 Info.Read.Kind:=0;
                 Info.Write.Kind:=0;
                 Info.Size:=0;
                 Info.TypeInfo:=NIL;
                 Info.Typ:=0;
               END;
           EnumProc(ps,Info);

           l:=l1;
           ps:=Pointer(l);
        END;
  // Ermitteln der Parent-Class-Info
        Class_VMT:=GetClassParent(Class_Info);
        if Class_VMT=nil then break;
        Class_Info:=Pointer(LongWord(Class_VMT) + LongWord(Class_VMT^.ClassInfo) +4);
      End;
  End;

BEGIN
{$IFDEF SPDLL30W32}
  EnumProperties_V30;
{$ELSE}
  EnumProperties_V25;
{$ENDIF}
END;

{Frees an instance of a class}
PROCEDURE TObject.Free;
BEGIN
     IF POINTER(SELF)<>NIL THEN Self.Destroy;
END;

{frees an Instance of a class}
PROCEDURE TObject.FreeInstance;
BEGIN
     {FreeInstance is normally called by the Destructor to
      deallocate memory for the object. In Speed-Pascal the
      memory deallocation is done by the compiler thus
      overriding this method has no effect}
END;

{Gets class information from the ClassInfo structure}
CLASS FUNCTION TObject.ClassInfo_V30: Pointer;
BEGIN
     ASM
        MOV EAX,!ClassInfo
        ADD EAX,4
        ADD EAX,[EAX]
        MOV Result,EAX
     END;
END;

CLASS FUNCTION TObject.ClassInfo: Pointer;
BEGIN
     ASM
        MOV EAX,!ClassInfo
{$IFDEF SPDLL30W32}
        ADD EAX,4
        ADD EAX,[EAX]
{$ELSE}      // Also SPDLL25, SPDLL30OS2, usw
        MOV EAX,[EAX+4]
{$ENDIF}
        MOV Result,EAX
     END;
END;

{Returns size of an instance of a class of TObject or a class derived
 from TObject from the ClassInfo structure}
CLASS FUNCTION TObject.InstanceSize:LONGWORD;

{$IFDEF SPDLL30W32}
Var Class_Info:PClassInfoLayout;
{$ENDIF}

BEGIN
{$IFDEF SPDLL30W32}
  Class_Info:=ClassInfo;
  ASM
    MOV EAX,0
    MOV EDI,Class_Info
    CMP EDI,0
    JE !InstanceSize_NoInfo
    MOV EAX,[EDI+0]     //Get class size
!InstanceSize_NoInfo:
    MOV Result,EAX
  End;
{$ELSE}
  ASM
    MOV EAX,0
    MOV EDI,!ClassInfo //Get Object pointer
    CMP EDI,0
    JE !InstanceSize_NoInfo
    MOV EDI,[EDI+4]     //Get class info pointer
    CMP EDI,0
    JE !InstanceSize_NoInfo
    MOV EAX,[EDI+0]     //Get class size
!InstanceSize_NoInfo:
    MOV Result,EAX
  END;
{$ENDIF}
END;

{Generates a new instance of a class from the ClassInfo structure
 and calls the constructor for that class}
CLASS FUNCTION TObject.NewInstance: TObject;
BEGIN
     {NewInstance is normally called by the Constructor to
      allocate memory for the object. In Speed-Pascal the
      memory allocation is done by the compiler thus
      overriding this method has no effect}
     result:=SELF;
END;

{Initializes an Instance from the ClassInfo structure given by Instance}
CLASS FUNCTION TObject.InitInstance(Instance: Pointer): TObject;
BEGIN
     {Fill the object with zeros. Object must be initialized with Create !}
     inc(Instance,4);
     FillChar(Instance^,InstanceSize-4,0);
     dec(Instance,4);
     InitInstance:=TObject(Instance);
END;

CLASS FUNCTION TObject.ClassName: STRING;

{$IFDEF SPDLL30W32}
var Class_Info:PClassInfoLayout;
{$ELSE}
var ps:^STRING;
{$ENDIF}

BEGIN
{$IFDEF SPDLL30W32}
  Class_Info:=ClassInfo;
  if Class_Info = nil
    then Result:=''
    else Result:=Class_Info^.ClassName;
{$ELSE}
  ASM
     MOV EAX,0
     MOV EDI,!ClassInfo //Get Object pointer
     CMP EDI,0
     JE !ClassName_NoInfo
     MOV EDI,[EDI+4]     //Get class info pointer
     CMP EDI,0
     JE !ClassName_NoInfo
     LEA EDI,[EDI+16]    //points to class name
     MOV EAX,EDI
!ClassName_NoInfo:
     MOV ps,EAX
  END;
  IF ps<>NIL
    THEN ClassName:=ps^
    ELSE ClassName:='';
{$ENDIF}
END;

CLASS FUNCTION TObject.ClassUnit:STRING;

var ps:^STRING;
{$IFDEF SPDLL30W32}
var Class_Info:PClassInfoLayout;
{$ELSE}
{$ENDIF}

BEGIN
{$IFDEF SPDLL30W32}
  Result:='';
  Class_Info:=ClassInfo;
  if Class_Info = nil then exit;
  ps:=(@Class_Info^.ClassName)+length(Class_Info^.ClassName)+1; // Nach dem Classennamen steht die Class-Unit
  if ps<>NIL then ClassUnit:=ps^;
{$ELSE}
   ASM
     MOV EAX,0
     MOV EDI,!ClassInfo //Get Object pointer
     CMP EDI,0
     JE !ClassUnit_NoInfo
     MOV EDI,[EDI+4]     //Get class info pointer
     CMP EDI,0
     JE !ClassUnit_NoInfo
     LEA EDI,[EDI+16]    //points to class name
     MOVZXB EAX,[EDI+0]  //overreas class name
     ADD EDI,EAX
     INC EDI
     MOV EAX,EDI
!ClassUnit_NoInfo:
     MOV ps,EAX
  END;
  IF ps<>NIL
    THEN ClassUnit:=ps^
    ELSE ClassUnit:='';
{$ENDIF}
END;

{$HINTS OFF}
{Default handler for messages}
PROCEDURE TObject.DefaultHandler(VAR Message);
BEGIN
     {Do nothing here !}
END;

{Default frame handler for messages}
PROCEDURE TObject.DefaultFrameHandler(VAR Message);
BEGIN
     {Do nothing here !}
END;
{$HINTS ON}

{Dispatches dynamic methods}
PROCEDURE TObject.Dispatch(VAR Message);
BEGIN
     {Check if there's a DMT entry for the message
      The message ID MUST be the first DWORD of Message !!
      If an entry is found call the message handler}


{$IFDEF SPDLL30W32}
     ASM
        MOV EDI,Message
        MOV EAX,[EDI+0]           //Get message index
        MOV EDI,SELF              //Get Object
        MOV ESI,[EDI+0]           //Get VMT pointer
        MOV EDI,[ESI+0]           //Get DMT pointer
        MOV ECX,[EDI+0]           //Get number of DMT entries
        ADD EDI,4
        PUSH ECX                  //Anzahl auf den Stack legen
        CLD
        REPNE SCASW
        JNE !EndeDispatch

        //Message found
        POP EAX                   // Die Anzahl der DMT wieder vom Stack entfernen
        ADD EAX,EAX
        SUB EAX,ECX
        SUB EDI,4
        MOV EAX,[EDI+EAX*2]

        SAL EAX, 2                // Multiplizieren mit 4
        ADD EAX, ESI              // Ermitteln der Rel-Sprungadresse
        ADD EAX, [EAX]            // Korrekter Sprungadresse

        PUSH DWORD PTR Message    //Message Parameter
        PUSH DWORD PTR SELF       //SELF Pointer to object
        CALLN32 EAX               //call VMT method
        LEAVE
        RETN32 8
!EndeDispatch:
        POP ECX                   // Die Anzahl der DMT wieder vom Stack entfernen
     END; {case}
{$ELSE}
     ASM
        MOV EDI,Message
        MOV EAX,[EDI+0]           //Get message index
        MOV EDI,SELF              //Get Object
        MOV ESI,[EDI+0]           //Get VMT pointer
        MOV EDI,[ESI+0]           //Get DMT pointer
        MOV ECX,[EDI+0]           //Get number of DMT entries
        ADD EDI,4
        PUSH ECX                  //Anzahl auf den Stack legen
        CLD
        REPNE SCASW
        JNE !EndeDispatch

        //Message found
        POP     EAX               // Die Anzahl der DMT wieder vom Stack entfernen
        ADD     EAX,EAX
        SUB     EAX,ECX
        SUB     EDI,4
        MOV     EAX,[EDI+EAX*2]
        PUSH DWORD PTR Message    //Message Parameter
        PUSH DWORD PTR SELF       //SELF Pointer to object
        CALLN32 [ESI+EAX*4]       //call VMT method
        LEAVE
        RETN32 8
!EndeDispatch:
        POP ECX                   // Die Anzahl der DMT wieder vom Stack entfernen
     END; {case}
{$ENDIF}

     {other case call the Default handler}
     DefaultHandler(Message);
END;

{Dispatches dynamic methods}
PROCEDURE TObject.DispatchCommand(VAR Message;Command:LONGWORD);
BEGIN
     {Check if there's a DMT entry for the WM_COMMAND message}
     ASM
        MOV EAX,Command  //Get message index
        MOV EDI,SELF     //Get Object
        MOV ESI,[EDI+0]  //Get VMT pointer
        MOV EDI,[ESI+0]  //Get DMT pointer
        MOV ECX,[EDI+0]  //Get number of DMT entries
        ADD EDI,4
        PUSH ECX
        CLD
        REPNE SCASW
        JNE !EndeDispatch_2

        //Message found
        POP     EAX
        ADD     EAX,EAX
        SUB     EAX,ECX
        SUB     EDI,4
        MOV     EAX,[EDI+EAX*2]
        PUSH DWORD PTR Message       //Message Parameter
        PUSH DWORD PTR SELF          //SELF Pointer to object
        CALLN32 [ESI+EAX*4]          //call VMT method
        LEAVE
        RETN32 12
!EndeDispatch_2:
        POP ECX
     END; {case}

     {other case call the Default handler}
     DefaultHandler(Message);
END;

{Dispatches dynamic methods}
PROCEDURE TObject.FrameDispatch(VAR Message);
BEGIN
     {Check if there's a DMT entry for the message
      The message ID MUST be the first DWORD of Message !!
      If an entry is found call the message handler}
      ASM
        MOV EDI,Message
        MOV EAX,[EDI+0]  //Get message index
        MOV EDI,SELF     //Get Object
        MOV ESI,[EDI+0]  //Get VMT pointer
        MOV EDI,[ESI+0]  //Get DMT pointer
        MOV ECX,[EDI+0]  //Get number of DMT entries
        ADD EDI,4
        PUSH ECX
        CLD
        REPNE SCASW
        JNE !EndeDispatch

        //Message found
        POP     EAX
        ADD     EAX,EAX
        SUB     EAX,ECX
        SUB     EDI,4
        MOV     EAX,[EDI+EAX*2]
        PUSH DWORD PTR Message       //Message Parameter
        PUSH DWORD PTR SELF          //SELF Pointer to object
        CALLN32 [ESI+EAX*4]          //call VMT method
        LEAVE
        RETN32 8
!EndeDispatch:
        POP ECX
     END; {case}

     {other case call the Default handler}
     DefaultFrameHandler(Message);
END;


ASSEMBLER

SYSTEM.!GetMethodName PROC NEAR32
        //INPUT : EAX adress to find
        //        EDI VMT pointer
        //OUTPUT: String adress or NIL in EAX

{$IFDEF SPDLL30W32}
  LEA EDI,[EDI+16]    //points to class name
  MOVZXB EBX,[EDI+0]  //get Class name length
  INC EDI
  ADD EDI,EBX
  MOVZXB EBX,[EDI+0]  //get Unit name length
  INC EDI
  ADD EDI,EBX         //points on first method adress
!MLoop:
  CMPD [EDI+0],0      //end of list ??
  JE !MELoop

  MOV ECX,EDI
  ADD ECX,[EDI]       // Adresse berechnen
  CMP ECX,EAX         // Vergleichen mit der Adr
  JNE !MWLoop

  //Method found
  LEA EAX,[EDI+4]     //points to Method name
  JMP !MEFLoop
!MWLoop:
  ADD EDI,4
  MOVZXB EBX,[EDI+0]  //get method name length
  INC EDI
  ADD EDI,EBX         //points to next method address
  JMP !MLoop          //try next
!MELoop:
  MOV EAX,0           //not found
!MEFLoop:
  RETN32
{$ELSE}
  MOV EDI,[EDI+4]     //Get class info pointer
  LEA EDI,[EDI+16]    //points to class name
  MOVZXB EBX,[EDI+0]  //get Class name length
  INC EDI
  ADD EDI,EBX
  MOVZXB EBX,[EDI+0]  //get Unit name length
  INC EDI
  ADD EDI,EBX         //points on first method adress
!MLoop:
  CMPD [EDI+0],0      //end of list ??
  JE !MELoop

  CMP [EDI+0],EAX     //Method found
  JNE !MWLoop

  //Method found
  LEA EAX,[EDI+4]     //points to Method name
  JMP !MEFLoop
!MWLoop:
  ADD EDI,4
  MOVZXB EBX,[EDI+0]  //get method name length
  INC EDI
  ADD EDI,EBX         //points to next method address
  JMP !MLoop          //try next
!MELoop:
  MOV EAX,0           //not found
!MEFLoop:
  RETN32
{$ENDIF}
SYSTEM.!GetMethodName ENDP

END;

{returns the Method Name for an adress or an empty string}
CLASS FUNCTION TObject.MethodName(Address: POINTER): STRING;

VAR ps:^STRING;
    Class_Info:POINTER;
{$IFDEF SPDLL30}
    Class_Parent:tClass;
{$ENDIF}

BEGIN
{$IFDEF SPDLL30}
  ps:=NIL;  {Default}
  if Address<>NIL then               // Sinnlos, dass nach NIL gesucht wird
    Begin
      Class_Info:=ClassInfo;
      ASM
!MAgain:
        MOV EDI,Class_Info
        MOV EAX,Address
        CALLN32 SYSTEM.!GetMethodName //search for method
        CMP EAX,0
        JE !Nfound

        //Method was found
        MOV ps,EAX
        JMP !Mfound
!Nfound:
        //Method not found, check parent
        PUSH Class_Info
        CALLN32 GetClassParent
        MOV Class_Parent, EAX   // Eventuell unnoetig
        CMP EAX,0               // Listen ende erreicht
        JE !Mfound              // not found
        ADD EAX, 4
        ADD EAX,[EAX+0]         //Get parent class adress info
        MOV Class_Info,EAX
        CMP EAX,0
        JNE !MAgain             //Try again if parents exist
!Mfound:
      END;
    End;

{$ELSE}
  ps:=NIL;  {Default}
  ASM
    MOV EDI,!ClassInfo     //get Class info pointer
    MOV Class_Info,EDI     //get address to find
!MAgain:
    MOV EDI,Class_Info
    MOV EAX,Address
    CALLN32 SYSTEM.!GetMethodName //search for method
    CMP EAX,0
    JE !Nfound

    //Method was found
    MOV ps,EAX
    JMP !Mfound
!Nfound:
    //Method not found, check parent
    MOV EDI,Class_Info    //Actual class
    MOV EDI,[EDI+4]       //Get class info pointer
    MOV EAX,[EDI+4]       //Get parent class adress info
    MOV Class_Info,EAX
    CMP EAX,0
    JNE !MAgain           //Try again if parents exist
!Mfound:
  END;
{$ENDIF}

  IF ps=NIL
    THEN MethodName:=''
    ELSE MethodName:=ps^;
END;

ASSEMBLER

SYSTEM.!GetMethodAddress PROC NEAR32
        //INPUT : ESI pointer to string to find
        //        EDI VMT pointer
        //OUTPUT: method pointer or NIL in EAX

{$IFDEF SPDLL30}
   LEA EDI,[EDI+16]    //points to class name
   MOVZXB EBX,[EDI+0]  //get Class name length
   INC EDI
   ADD EDI,EBX
   MOVZXB EBX,[EDI+0]  //get Unit name length
   INC EDI

   ADD EDI,EBX         //points on first method adress
   MOV CL,[ESI+0]      //get method string length
!ALoop:
   MOV EDX,EDI         //save pointer
   MOV EBX,ESI         //save pointer
   CMPD [EDI+0],0      //end of list ??
   JE !AELoop
   ADD EDI,4           //onto name

   CMP CL,[EDI+0]      //length correct
   JNE !AWLoop

   //length was correct
   MOVZX ECX,CL        //String length
   INC EDI
   INC ESI
   CLD
   REP
   CMPSB               //Compare strings
   JNE !AWLoop

   //Method was found
{$IFDEF SPDLL30OS2}
   MOV EAX,[EDX+0]     //get method adress
{$ENDIF}
{$IFDEF SPDLL30W32}
   MOV EAX,EDX         //get method adress
   ADD EAX,[EDX+0]     //the adress is realtiv to this adress
{$ENDIF}
   JMP !AEFLoop
!AWLoop:
   MOV EDI,EDX         //get old pointer
   MOV ESI,EBX         //get old pointer
   ADD EDI,4
   MOVZXB EAX,[EDI+0]  //get method name length
   INC EDI
   ADD EDI,EAX         //points to next method address
   MOV CL,[ESI+0]
   JMP !ALoop          //try next
!AELoop:
   MOV EAX,0           //not found
!AEFLoop:
   RETN32
SYSTEM.!GetMethodAddress ENDP

{$ELSE}
   MOV EDI,[EDI+4]     //Get class info pointer
   LEA EDI,[EDI+16]    //points to class name
   MOVZXB EBX,[EDI+0]  //get Class name length
   INC EDI
   ADD EDI,EBX
   MOVZXB EBX,[EDI+0]  //get Unit name length
   INC EDI
   ADD EDI,EBX         //points on first method adress
   MOV CL,[ESI+0]      //get method string length
!ALoop:
   MOV EDX,EDI         //save pointer
   MOV EBX,ESI         //save pointer
   CMPD [EDI+0],0      //end of list ??
   JE !AELoop
   ADD EDI,4           //onto name

   CMP CL,[EDI+0]      //length correct
   JNE !AWLoop

   //length was correct
   MOVZX ECX,CL        //String length
   INC EDI
   INC ESI
   CLD
   REP
   CMPSB               //Compare strings
   JNE !AWLoop

   //Method was found
   MOV EAX,[EDX+0]     //get method adress
   JMP !AEFLoop
!AWLoop:
   MOV EDI,EDX         //get old pointer
   MOV ESI,EBX         //get old pointer
   ADD EDI,4
   MOVZXB EAX,[EDI+0]  //get method name length
   INC EDI
   ADD EDI,EAX         //points to next method address
   MOV CL,[ESI+0]
   JMP !ALoop          //try next
!AELoop:
   MOV EAX,0           //not found
!AEFLoop:
   RETN32
SYSTEM.!GetMethodAddress ENDP
{$ENDIF}
END;

{returns the adress of a method or NIL}
CLASS FUNCTION TObject.MethodAddress(Name: STRING): POINTER;

VAR Adr:POINTER;

{$IFDEF SPDLL30}
Var Class_Info:PClassInfoLayout;
    Class_Parent:tClass;
{$ELSE}
Var Class_Info:Pointer;
{$ENDIF}

BEGIN
  Adr:=NIL;  {Default}
  UpcaseStr(Name);

{$IFDEF SPDLL30}
  Class_Info:=ClassInfo;
  ASM
!AAgain_1:
    MOV EDI,Class_Info
    LEA ESI,Name
    CALLN32 SYSTEM.!GetMethodAddress //search for method
    CMP EAX,0
    JE !ANfound

    //Method was found
    MOV Adr,EAX
    JMP !AMfound
!ANfound:
//Method not found, check parent
    PUSH Class_Info
    CALLN32 GetClassParent
    MOV Class_Parent, EAX   // Eventuell unnoetig
    CMP EAX,0
    JE !AMfound             // not found
    ADD EAX, 4
    ADD EAX,[EAX+0]         //Get parent class adress info
    MOV Class_Info,EAX
    CMP EAX,0
    JNE !AAgain_1           //Try again if parents exist
!AMfound:
  END;

{$ELSE}
  ASM
    MOV EDI,!ClassInfo     //get Class info pointer
    MOV Class_Info,EDI     //get address to find
!AAgain_1:
    MOV EDI,Class_Info
    LEA ESI,Name
    CALLN32 SYSTEM.!GetMethodAddress //search for method
    CMP EAX,0
    JE !ANfound

//Method was found
    MOV Adr,EAX
    JMP !AMfound
!ANfound:
//Method not found, check parent
    MOV EDI,Class_Info    //Actual class
    MOV EDI,[EDI+4]       //Get class info pointer
    MOV EAX,[EDI+4]       //Get parent class adress info
    MOV Class_Info,EAX
    CMP EAX,0
    JNE !AAgain_1         //Try again if parents exist
!AMfound:
  END;
{$ENDIF}
  MethodAddress:=Adr;
END;

CLASS FUNCTION TObject.VMTIndex(Name: STRING): LONGINT;

VAR Adr:POINTER;
    res:LONGINT;

{$IFDEF SPDLL30}
VAR Class_Info:PClassInfoLayout;
{$ENDIF}

BEGIN
  res:=-1;
  result:=-1;
  Adr:=MethodAddress(Name);
  IF Adr=NIL THEN exit;

{$IFDEF SPDLL30}
  Class_Info:=ClassInfo;
  ASM
     MOV EDI,Class_Info     // get Class info pointer
     LEA EDI,[EDI+16]       // points to class name
     MOVZXB EBX,[EDI+0]     // get Class name length
     INC EDI
     ADD EDI,EBX
     MOVZXB EBX,[EDI+0]     // get Unit name length
     INC EDI
     ADD EDI,EBX
     MOV EAX,Adr            // gefundene Adresse in EAX speichern
     MOV EBX,4              // Standard auf 4 Setzen
!AAgain_11:
     CMPD [EDI],0           // Ende der Liste erreicht?
     JE !Ende
     MOV ECX,EDI
     ADD ECX,[EDI]          // Adresse berechnen
     CMP ECX,EAX            // Vergleichen mit der Adr
     JE !Found
     ADD EDI,4              // Naechsten Wert ermitteln
     MOVZXB ECX,[EDI+0]     // Laenge der Methode
     ADD EDI,ECX            // Laenge dazuaddieren
     INC EDI
     INC EBX
     JMP !AAgain_11
!Found:
     MOV res,EBX
!Ende:
  END;
{$ELSE}
  ASM
     MOV EDI,!ClassInfo     // get Class info pointer
     ADD EDI,16             // First VMT metod
     MOV EAX,Adr
     MOV EBX,4
!AAgain_11:
     CMPD [EDI],0
     JE !Ende
     CMP [EDI],EAX
     JE !Found
     ADD EDI,4
     INC EBX
     JMP !AAgain_11
!Found:
     MOV res,EBX
!Ende:
  END;
{$ENDIF}

  result:=res;
END;

ASSEMBLER

SYSTEM.!GetFieldOffset PROC NEAR32
//INPUT : ESI pointer to string to find
//        EDI VMT pointer
//OUTPUT: field offset or 0 in EAX

  MOV EDI,[EDI+8]     //Field info start
  MOV AL,[ESI+0]      //get method string length
  INC ESI
!FLoop:
  MOV EDX,EDI         //save pointer
  MOV EBX,ESI         //save pointer
  CMPD [EDI+0],0      //end of list ??
  JE !FELoop

  CMP AL,[EDI+4]      //length correct
  JNE !FWLoop

  //length was correct
  MOVZX ECX,AL        //String length
  ADD EDI,5           //onto first char
  CLD
  REP
  CMPSB               //Compare strings
  JNE !FWLoop

  //Method was found
  MOV EAX,[EDX+0]     //get method adress
  JMP !FEFLoop
!FWLoop:
  MOV EDI,EDX         //get old pointer
  MOV ESI,EBX         //get old pointer
  ADD EDI,4
  MOVZXB EBX,[EDI+0]  //get method name length
  INC EDI
  ADD EDI,EBX         //points to next method address
  JMP !FLoop          //try next
!FELoop:
  MOV EAX,0           //not found
!FEFLoop:
  RETN32
SYSTEM.!GetFieldOffset ENDP

END;

FUNCTION TObject.FieldAddress(Name: STRING): POINTER;

VAR Adr:POINTER;
{$IFDEF SPDLL30}
    Class_Info  : PClassInfoLayout;
    Class_Parent: PVmtLayOut;
{$ELSE}
    Class_Info:POINTER;
{$ENDIF}

BEGIN
  Adr:=NIL;  {Default}
  UpcaseStr(Name);

{$IFDEF SPDLL30}
  Class_Info:=ClassInfo;
  ASM
!FAgain:
    MOV EDI,Class_Info
    LEA ESI,Name
    CALLN32 SYSTEM.!GetFieldOffset //search for method
    CMP EAX,0
    JE !FNfound

//Method was found
    MOV EBX,SELF
    MOV Adr,EBX
    ADD Adr,EAX
    JMP !FMfound
!FNfound:
//Method not found, check parent
    PUSH Class_Info
    CALLN32 GetClassParent
    MOV Class_Parent, EAX   // Eventuell unnoetig
    CMP EAX,0
    JE !FMfound             // not found
    ADD EAX, 4
    ADD EAX,[EAX+0]         //Get parent class adress info

    MOV Class_Info,EAX
    CMP EAX,0
    JNE !FAgain             //Try again if parents exist
!FMfound:
  END;
{$ELSE}
  ASM
    MOV EDI,SELF            //get object pointer
    MOV EDI,[EDI+0]         //get VMT Pointer
    MOV EDI,[EDI+4]         //get Class info pointer
    MOV Class_Info,EDI      //get address to find
!FAgain:
    MOV EDI,Class_Info
    LEA ESI,Name
    CALLN32 SYSTEM.!GetFieldOffset //search for method
    CMP EAX,0
    JE !FNfound

    //Method was found
    MOV EBX,SELF
    MOV Adr,EBX
    ADD Adr,EAX
    JMP !FMfound
!FNfound:
    //Method not found, check parent
    MOV EDI,Class_Info      //Actual class
    MOV EDI,[EDI+4]         //Get class info pointer
    CMP EDI,0
    JE !FMfound             //not found
    MOV EAX,[EDI+4]         //Get parent class adress info
    MOV Class_Info,EAX
    CMP EAX,0
    JNE !FAgain             //Try again if parents exist
!FMfound:
  END;
{$ENDIF}
  FieldAddress:=Adr;
END;

{returns type of a class}
CLASS FUNCTION TObject.ClassType: TClass;
BEGIN
  ASM
    MOV EAX,!ClassInfo
    MOV Result,EAX
  END;
END;

{Returns Parent Class pointer of the Object or NIL}
CLASS FUNCTION TObject.ClassParent: TClass;

{$IFDEF SPDLL30}
var ci : PClassInfoLayout;
{$ENDIF}

BEGIN
{$IFDEF SPDLL30}
  ci:=ClassInfo;
  if ci=nil
    then Result:=nil
    else Result:=tClass(GetClassParent(ci));
{$ELSE}
  ASM
    MOV EAX,0
    MOV EDI,!ClassInfo     //get Class info pointer
    CMP EDI,0
    JE !ClassParent_NoInfo
    MOV EDI,[EDI+4]        //points to Class information
    CMP EDI,0
    JE !ClassParent_NoInfo
    MOV EAX,[EDI+4]        //Get Parent Class pointer
!ClassParent_NoInfo:
    MOV Result,EAX
  END;
{$ENDIF}
END;

{returns true if the Class is derived from AClass, otherwise FALSE}
{Softmode will only be enabled within the Sibyl IDE - it will only
 check if names match}
CONST InheritsSoftMode:BOOLEAN=FALSE;

CLASS FUNCTION TObject.InheritsFrom(AClass: TClass): BOOLEAN;

{$IFDEF SPDLL30}
var ci : PClassInfoLayout;
{$ENDIF}

BEGIN
  Result:=FALSE; //Default
{$IFDEF SPDLL30}
  ci:=ClassInfo;
  IF InheritsSoftMode
    THEN
      BEGIN
        ASM
          MOV EDI,ci             //get Class info pointer
          MOV EAX,AClass         //class to check
          CMP EAX,0
          JE !SmIELoop
          ADD EAX,4
          ADD EAX,[EAX]
          LEA EBX,[EAX+16]       //Name of first class
!SmILoop:
          CMP EDI,0
          JE !SmIELoop
          PUSH EBX
          PUSH EDI

          MOV ESI,[EDI+4]        //get Class info pointer
          LEA EDI,[ESI+16]       //Name of second class
          MOV AL,0
          MOV CL,[EBX+0]
          CMP CL,[EDI+0]
          JNE !SmNoMatch
          INC EBX
          INC EDI
          CLD
          MOV ESI,EBX
          MOVZX ECX,CL
          CLD
          REP
          CMPSB
          SETE AL
!SmNoMatch:
          POP EDI
          POP EBX
          CMP AL,1               //is it this class ?
          JNE !SmIWLoop

          //The Class was found
          MOV DWORD PTR Result,1
          JMP !SmIELoop
!SmIWLoop:
          //try parent class
          PUSH EDI
          CALLN32 GetClassParent
          CMP EAX,0
          JE !SmIELoop            // not found
          ADD EAX, 4
          ADD EAX,[EAX+0]         //Get parent class adress info
          MOV EDI,EAX             // Adresse in EDI Speichern; vielleicht Funktion von EAX und EDI umdrehen
          CMP EDI,0
          JNE !SmILoop
!SmIELoop:
        END;
      END
    ELSE
// WD: getestet und okay
      BEGIN
        ASM
          MOV EDI,!ClassInfo     //get Class info pointer
!ILoop:
          MOV EAX,AClass         //class to check
          MOV DWORD PTR Result,0 //Default
          CMP EDI,EAX            //is it this class ?
          JNE !IWLoop

          //The Class was found
          MOV DWORD PTR Result,1
          JMP !IELoop
!IWLoop:
          //try parent class

{$IFDEF SPDLL30W32}
          ADD EDI, 4
          ADD EDI, [EDI]
{$ENDIF}
{$IFDEF SPDLL30OS2}
          MOV EDI,[EDI+4]       //points to class info
{$ENDIF}
          PUSH EDI
          CALLN32 GetClassParent  // Ergebnis steht in EAX
          CMP EAX,0
          JE !IELoop              // not found
          MOV EDI,EAX
          JMP !ILoop
!IELoop:
        END;
      END;

{$ELSE}
    IF InheritsSoftMode THEN
      BEGIN
         ASM
             MOV EDI,!ClassInfo     //get Class info pointer
             MOV EAX,AClass         //class to check
             CMP EAX,0
             JE !SmIELoop
             MOV EAX,[EAX+4]        //get Class info pointer
             LEA EBX,[EAX+16]       //Name of first class
!SmILoop:
             CMP EDI,0
             JE !SmIELoop
             PUSH EBX
             PUSH EDI

             MOV ESI,[EDI+4]        //get Class info pointer
             LEA EDI,[ESI+16]       //Name of second class
             MOV AL,0
             MOV CL,[EBX+0]
             CMP CL,[EDI+0]
             JNE !SmNoMatch
             INC EBX
             INC EDI
             CLD
             MOV ESI,EBX
             MOVZX ECX,CL
             CLD
             REP
             CMPSB
             SETE AL
!SmNoMatch:
             POP EDI
             POP EBX
             CMP AL,1               //is it this class ?
             JNE !SmIWLoop

             //The Class was found
             MOV DWORD PTR Result,1
             JMP !SmIELoop
!SmIWLoop:
             //try parent class
             MOV EDI,[EDI+4]       //points to class info
             MOV EDI,[EDI+4]       //get parent info
             CMP EDI,0
             JNE !SmILoop
!SmIELoop:
          END;
      END
    ELSE
      BEGIN
          ASM
             MOV EDI,!ClassInfo     //get Class info pointer
!ILoop:                             //Von WD hinaufgesetzt
             MOV EAX,AClass         //class to check
             MOV DWORD PTR Result,0 //Default
             CMP EDI,EAX            //is it this class ?
             JNE !IWLoop

             //The Class was found
             MOV DWORD PTR Result,1
             JMP !IELoop
!IWLoop:
             //try parent class
             MOV EDI,[EDI+4]       //points to class info
             MOV EDI,[EDI+4]       //get parent info
             CMP EDI,0
             JNE !ILoop
!IELoop:
          END;
      END;
{$ENDIF}
END;

{internally: returns true if the Class1 is derived from Class2 otherwise FALSE}
FUNCTION CheckDerived(Class1,Class2: TClass): BOOLEAN;
BEGIN
     ASM
        MOV EDI,Class1         //get Class info pointer
        MOV EAX,Class2         //class to check
        MOV DWORD PTR Result,0 //Default
!ILoop11:
        CMP EDI,EAX            //is it this class ?
        JNE !IWLoop11

        //The Class was found
        MOV DWORD PTR Result,1
        JMP !IELoop11
!IWLoop11:
        //try parent class
        MOV EDI,[EDI+4]       //points to class info
        MOV EDI,[EDI+4]       //get parent info
        CMP EDI,0
        JNE !ILoop11
!IELoop11:
     END;
END;

ASSEMBLER

//Abstract method (causes Runtime Error 210)
SYSTEM.!Abstract PROC NEAR32
             PUSHL 210
             CALLN32 SYSTEM.RunError
SYSTEM.!Abstract ENDP

END;

//************************************************************************
// LongJmp support
//************************************************************************


FUNCTION SetJmp(VAR JmpBuf:Jmp_Buf):LONGWORD;
BEGIN
     ASM
        MOV EDI,JmpBuf
        MOV EAX,[EBP+0]
        MOV [EDI+0],EAX
        MOV EAX,[EBP+4]
        MOV [EDI+4],EAX
        MOV EAX,EBP
        ADD EAX,12
        MOV [EDI+8],EAX
        MOV ESI,0
        db $64   //SEG FS
        MOV EAX,[ESI+0]
        MOV [EDI+$18],EAX
        FSTCW [EDI+$1C]
        XOR EAX,EAX
        MOV Result,EAX
     END;
END;

PROCEDURE LongJmp(VAR JmpBuf:Jmp_Buf;RetVal:LONGWORD);
BEGIN
     ASM
        {$IFDEF OS2}
        MOV EDI,JmpBuf
        PUSHL 0
        MOV EAX,*ljmpret
        PUSH EAX
        PUSH DWORD PTR [EDI+$18]
        MOV AL,3
        CALLDLL DosCalls,357  //DosUnwindException
        {$ENDIF}
ljmpret:
        MOV EDI,JmpBuf
        db $db,$e3              //FINIT Init FPU
        FWAIT
        FLDCW [EDI+$1C]
        FWAIT
        MOV EAX,RetVal
        AND EAX,EAX
        JNZ !rtv0
        MOV EAX,1
!rtv0:
        PUSH DWORD PTR [EDI+0]
        POP EBP
        MOV ESP,[EDI+8]
        ADD EDI,4
        db $0ff,$27       //JMP NEAR32 [EDI+0] --> jump into proc
     END;
END;

//***************************************************
// String Support routines
//***************************************************

PROCEDURE UpcaseStr(VAR s:STRING);
BEGIN
     ASM
        MOV EDI,s
        XOR ECX,ECX
        MOV CL,[EDI+0]
        OR CL,CL
        JE !usend
        INC EDI
        MOV EBX,*ustab
        CLD
!usfilter:
        MOV AL,[EDI+0]
        XLAT
        STOSB
        DEC ECX
        JNZ !usfilter
!usend:
        LEAVE
        RETN32 4
ustab:
       db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
       db 21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38
       db 39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57
       db 58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76
       db 77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96
       db 65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83
       db 84,85,86,87,88,89,90
       db 123,124,125,126,127,128,129,130,131,132,133,134,135,136,137
       db 138,139,140,141,142,143,144,145,146,147,148,149,150,151,152
       db 153,154,155,156,157,158,159,160,161,162,163,164,165,166,167
       db 168,169,170,171,172,173,174,175,176,177,178,179,180,181,182
       db 183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198
       db 199,200,201,202,203,204,205,206,207,208,209,210,211,212,213
       db 214,215,216,217,218,219,220,221,222,223,224,225,226,227,228
       db 229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244
       db 245,246,247,248,249,250,251,252,253,254,255
     END;
END;

PROCEDURE LongWord2Str(l:LONGWORD;Format:LONGWORD;VAR result:STRING);
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI

        MOV EAX,l
        MOV EBX,10
        XOR ECX,ECX
Lw46_1nn:
        XOR EDX,EDX
        DIV EBX
        PUSH DX
        INC CX
        OR EAX,EAX
        JNE Lw46_1nn

        MOV ESI,Result
        MOVB [ESI+0],0
        MOV EDI,ESI

        CMP ECX,Format
        JAE Lw47nn

        //format the string
        MOV EAX,Format
        SUB EAX,ECX
        MOV [ESI+0],AL
        INC EDI
        PUSH ECX

        MOV ECX,EAX
        MOV AL,32
        CLD
        REP STOSB       //fill up with space

        DEC EDI
        POP ECX
Lw47nn:
        POP AX
        ADD AL,48
        INCB [ESI+0]
        INC EDI
        MOV [EDI+0],AL
        LOOP Lw47nn
     END;

     ASM
        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

PROCEDURE LongWord2AnsiStr(l:LONGWORD;Format:LONGWORD;VAR result:AnsiString);
VAR s:STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI
     END;
     LongWord2Str(l,Format,s);
     result:=s;
     ASM
        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

FUNCTION GetBoolValue(b:BOOLEAN):STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI
     END;
     IF b THEN GetBoolValue:='TRUE'
     ELSE GetBoolValue:='FALSE';
     ASM
        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

PROCEDURE LongInt2Str(l:LONGINT;Format:LONGWORD;VAR result:STRING);
VAR
   IsNeg:BOOLEAN;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI

        MOV BYTE PTR IsNeg,0
        MOV EAX,l
        MOV EBX,10
        XOR ECX,ECX
        CMP EAX,0
        JNL Lw46_1
        NEG EAX
        MOV BYTE PTR IsNeg,1
Lw46_1:
        XOR EDX,EDX
        DIV EBX
        PUSH DX
        INC CX
        OR EAX,EAX
        JNE Lw46_1

        MOV ESI,Result
        MOVB [ESI+0],0
        MOV EDI,ESI

        MOV EBX,ECX

        CMP BYTE PTR IsNeg,1
        JNE !nin1
        INC EBX
!nin1:
        CMP EBX,Format
        JAE Lw47_1n

        //format the string
        MOV EAX,Format
        SUB EAX,EBX
        MOV [ESI+0],AL
        INC EDI
        PUSH ECX

        MOV ECX,EAX
        MOV AL,32
        CLD
        REP STOSB        //fill up with space

        DEC EDI
        POP ECX
Lw47_1n:
        CMP BYTE PTR IsNeg,1
        JNE Lw47
        INC EDI
        INCB [ESI+0]
        MOVB [EDI+0],45  //'-'
Lw47:
        POP AX
        ADD AL,48
        INCB [ESI+0]
        INC EDI
        MOV [EDI+0],AL
        LOOP Lw47
     END;

     ASM
        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

PROCEDURE LongInt2AnsiStr(l:LONGINT;Format:LONGWORD;VAR result:AnsiSTRING);
VAR s:STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI
     END;
     LongInt2Str(l,Format,s);
     result:=s;
     ASM
        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

FUNCTION Pos(CONST item,source:STRING):BYTE;
VAR
   result:BYTE;
BEGIN
     ASM
         MOV ESI,item          //item
         CLD
         LODSB
         OR AL,AL
         JE lab2
         MOVZX EAX,AL
         MOV EDX,EAX
         MOV EDI,source        //source
         MOVZXB ECX,[EDI+0]
         SUB ECX,EDX
         JB lab2
         INC ECX
         INC EDI
lab1:
         LODSB
         REPNE
         SCASB
         JNE lab2
         MOV EAX,EDI
         MOV EBX,ECX
         MOV ECX,EDX
         DEC ECX
         REPE
         CMPSB
         JE lab3
         MOV EDI,EAX
         MOV ECX,EBX
         MOV ESI,item     //item
         INC ESI
         JMP lab1
Lab2:
         XOR EAX,EAX
         JMP Lab4
lab3:
         DEC EAX
         SUB EAX,source   //source
Lab4:
         MOV result,AL
     END;
     POS:=result;
END;

FUNCTION Copy(CONST Source:STRING; Index,Count:INTEGER):STRING;
BEGIN
     ASM
        MOV ESI,source              //Source string
        MOV EDI,Result              //Destination string
        MOVW [EDI+0],0              //Empty String

        MOVSXW ECX,Count            //Count
        CMP ECX,1
        JL !_CopyE

        MOVSXW EAX,Index            //Index
        CMP EAX,1
        JNL !_Copy1
        MOV EAX,1                    //Index:=1
!_Copy1:
        MOVZXB EBX,[ESI+0]           //Length of Source
        CMP EAX,EBX
        JA !_CopyE

        MOV EDX,EAX
        ADD EDX,ECX                  //Index+Count
        CMP EDX,EBX
        JNA !_Copy2
        MOV ECX,EBX
        SUB ECX,EAX
        INC ECX                      //Count := Length(S)-Index+1
!_Copy2:
        MOV [EDI+0],CL
        INC EDI

        ADD ESI,EAX                  //first char
        CLD
        MOV EDX,ECX
        SHR ECX,2
        REP
        MOVSD
        MOV ECX,EDX
        AND ECX,3
        REP
        MOVSB
!_CopyE:
     END;
END;

FUNCTION ToHex(l:LONGWORD):STRING;
VAR result:STRING;
    r:LONGWORD;
BEGIN
     result:='';
     WHILE l>=16 DO
     BEGIN
          r:=l MOD 16;
          l:=l DIV 16;
          result:=HexDecimals[r]+result;
     END;
     result:=HexDecimals[l]+result;
     WHILE length(result)<8 DO result:='0'+result;
     ToHex:='$'+Result;
END;

PROCEDURE SubStr(VAR source:STRING;start,ende:Byte);
BEGIN
      ASM
        CLD
        MOV ESI,source               //Source string
        MOV EDI,ESI                  //Destination string

        MOVZXB AX,[ESI+0]            //Length of source
        MOVZXB ECX,Start             //Index
        OR ECX,ECX
        JG !_Lab1_1
        MOV ECX,1
!_Lab1_1:
        ADD ESI,ECX
        SUB AX,CX
        JB !_Lab3_1
        INC AX
        MOVZXB CX,Ende              //Count
        OR CX,CX
        JGE !_Lab2_1
        XOR CX,CX
!_Lab2_1:
        CMP AX,CX
        JBE !_Lab4_1
        MOV AX,CX
        JMP !_Lab4_1
!_Lab3_1:
        XOR AX,AX
!_Lab4_1:
        CLD
        STOSB
        MOVZX ECX,AX

        MOV EDX,ECX
        SHR ECX,2
        REP
        MOVSD
        MOV ECX,EDX
        AND ECX,3
        REP
        MOVSB
     END;
END;

PROCEDURE Insert(CONST Source:STRING; VAR S:STRING; Index:INTEGER);
BEGIN
     IF Length(Source) = 0 THEN exit;
     IF Length(S) = 0 THEN
     BEGIN
          S := Source;
          exit;
     END;
     IF Index < 1 THEN Index := 1;
     IF Index > Length(S) THEN Index := Length(S)+1;
     S := copy(S,1,Index-1) + Source + copy(S,Index,Length(S)-Index+1);
END;

PROCEDURE Delete(VAR S:STRING; Index,Count:INTEGER);
BEGIN
     IF Index < 1 THEN exit;
     IF Index > Length(S) THEN exit;
     IF Count < 1 THEN exit;
     IF Index+Count > Length(S) THEN Count := Length(S)-Index+1;
     S := copy(S,1,Index-1) + copy(S,Index+Count,Length(S)-Index-Count+1);
END;

FUNCTION ConvertStr2Long(VAR s:STRING):LONGINT;
VAR
   c:Integer;
   result:LONGINT;
BEGIN
     VAL(s,result,c);
     IF c<>0 THEN
     BEGIN
     END;
     ConvertStr2Long:=result;
END;

{Liefert Extended in ST(0) !!}
PROCEDURE ConvertStr2Extended(VAR s:STRING);
VAR
   c:Integer;
   result:Extended;
BEGIN
     VAL(s,result,c);
     IF c<>0 THEN
     BEGIN
     END;
     ASM
        FLDT result
     END;
END;


FUNCTION GetStrErrorPos(VAR s:STRING):LONGINT;
VAR t,t1:BYTE;
BEGIN
     result:=1;
     t:=1;
     IF t<=length(s) THEN IF s[t] IN ['+','-'] THEN inc(t);
     IF t<=length(s) THEN IF s[t]='$' THEN inc(t);
     FOR t1:=t TO length(s) DO
     BEGIN
          CASE s[t1] OF
            '0'..'9':;
            ELSE
            BEGIN
                 result:=t1;
                 exit;
            END;
          END;
     END;
END;

ASSEMBLER

SYSTEM.!Str2Long PROC NEAR32
        PUSH EBP
        MOV EBP,ESP
        SUB ESP,10
        DB $89,$04,$24     //Perform stack probe MOV [ESP],EAX

        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI

        MOV EDI,[EBP+16]   //s
        MOV CL,[EDI+0]     //Lnge
        MOVZX ECX,CL

!ndo_11:
        MOV AL,[EDI+1]
        CMP AL,32
        JNE !do_11
        CMP ECX,0
        JE !do_11
        DEC ECX
        INC EDI
        JMP !ndo_11       //skip spaces
!do_11:
        PUSH EDI
        ADD EDI,ECX
        CMPB [EDI+0],32
        JNE !do_11_1
        DEC ECX
        POP EDI
        JMP !do_11
!do_11_1:
        POP EDI

        MOVB [EBP-6],0

        MOVD [EBP-10],10   //Base
        MOV AL,[EDI+1]
        ADD EDI,ECX
        CMP AL,'$'         //Hexadecimal ??
        JNE !nohex
        MOVD [EBP-10],16   //Base
        CMP ECX,1
        JE !qerr
        DEC ECX
!nohex:
        CMP AL,'-'
        JNE !q2
        CMP ECX,1
        JE !qerr
        DEC ECX
        MOVB [EBP-6],1
!q2:
        CMP AL,'+'
        JNE !q1r1
        CMP ECX,1
        JE !qerr
        DEC ECX
!q1r1:
        MOV EBX,1
        MOV EAX,0
        MOV [EBP-4],EAX
!q1:
        MOV AL,[EDI+0]
        DEC EDI
        CMP AL,48
        JB !qerr
        CMP AL,57
        JNA !noqerr

        CMP AL,102
        JA !qerr
        CMP AL,65
        JB !qerr
        CMP AL,70
        JBE !hexnum
        CMP AL,97
        JB !qerr
        SUB AL,32       //To upper
!hexnum:
        CMPD [EBP-10],16
        JNE !qerr
        SUB AL,7
!noqerr:
        CLD
        SUB AL,48
        MOVZX EAX,AL
        MUL EBX
        MOV EDX,[EBP-4]
        ADD EDX,EAX
        MOV [EBP-4],EDX
        MOV EAX,EBX
        MOV EBX,[EBP-10]  //Base
        MUL EBX
        MOV EBX,EAX
        LOOP !q1
!qerr:
        MOV EDI,[EBP+8]   //result
        XOR CH,CH
        MOV [EDI+0],CX

        // failure ??
        CMP CX,0
        JE !qqqq                 //no error
        PUSH DWORD PTR [EBP+16]  //s
        CALLN32 SYSTEM.GetStrErrorPos
        MOV EDI,[EBP+8]
        MOV [EDI+0],EAX
        MOV EAX,0
        JMP !q3
!qqqq:
        MOV EAX,[EBP-4]
        CMPB [EBP-6],1
        JNE !q3
        NEG EAX
!q3:
        MOV EDI,[EBP+12]  //l
        MOV [EDI+0],EAX

        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX

        LEAVE
        RETN32 12
SYSTEM.!Str2Long ENDP

SYSTEM.!Str2Word PROC NEAR32
        PUSH EBP
        MOV EBP,ESP
        SUB ESP,10
        DB $89,$04,$24     //Perform stack probe MOV [ESP],EAX

        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI

        MOV EDI,[EBP+16]   //s
        MOV CL,[EDI+0]     //Lnge
        MOVZX ECX,CL

!ndo_22:
        MOV AL,[EDI+1]
        CMP AL,32
        JNE !do_22
        CMP ECX,0
        JE !do_22
        DEC ECX
        INC EDI
        JMP !ndo_22
!do_22:
        PUSH EDI
        ADD EDI,ECX
        CMPB [EDI+0],32
        JNE !do_22_1
        DEC ECX
        POP EDI
        JMP !do_22
!do_22_1:
        POP EDI

        MOVB [EBP-6],0

        MOVD [EBP-10],10   //Base
        MOV AL,[EDI+1]
        ADD EDI,ECX
        CMP AL,'$'         //Hexadecimal ??
        JNE !__nohex
        MOVD [EBP-10],16   //Base
        CMP ECX,1
        JE !__qerr
        DEC ECX
!__nohex:
        CMP AL,'-'
        JNE !__q2
        CMP ECX,1
        JE !__qerr
        DEC ECX
        MOVB [EBP-6],1
!__q2:
        CMP AL,'+'
        JNE !__q2r1
        CMP ECX,1
        JE !__qerr
        DEC ECX
!__q2r1:
        MOV EBX,1
        MOV EAX,0
        MOV [EBP-4],EAX
!__q1:
        MOV AL,[EDI+0]
        DEC EDI
        CMP AL,48
        JB !__qerr
        CMP AL,57
        JNA !__noqerr

        CMP AL,102
        JA !__qerr
        CMP AL,65
        JB !__qerr
        CMP AL,70
        JBE !__hexnum
        CMP AL,97
        JB !__qerr
        SUB AL,32         //To upper
!__hexnum:
        CMPD [EBP-10],16
        JNE !__qerr
        SUB AL,7
!__noqerr:
        SUB AL,48
        MOVZX EAX,AL
        MUL EBX
        MOV EDX,[EBP-4]
        ADD EDX,EAX
        MOV [EBP-4],EDX
        MOV EAX,EBX
        MOV EBX,[EBP-10]    //Base
        MUL EBX
        MOV EBX,EAX
        LOOP !__q1
!__qerr:
        MOV EDI,[EBP+8]     //result
        XOR CH,CH
        MOV [EDI+0],CX

        // failure ??
        CMP CX,0
        JE !qqqq1                //no error
        PUSH DWORD PTR [EBP+16]  //s
        CALLN32 SYSTEM.GetStrErrorPos
        MOV EDI,[EBP+8]
        MOV [EDI+0],EAX
        MOV EAX,0
        JMP !__q3
!qqqq1:
        MOV EAX,[EBP-4]
        CMPB [EBP-6],1
        JNE !__q3
        NEG EAX
!__q3:
        MOV EDI,[EBP+12]    //l
        MOV [EDI+0],AX

        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX

        LEAVE
        RETN32 12
SYSTEM.!Str2Word ENDP

SYSTEM.!Str2Byte PROC NEAR32
        PUSH EBP
        MOV EBP,ESP
        SUB ESP,10
        DB $89,$04,$24     //Perform stack probe MOV [ESP],EAX

        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI

        MOV EDI,[EBP+16]   //s
        MOV CL,[EDI+0]     //Lnge
        MOVZX ECX,CL

!ndo_33:
        MOV AL,[EDI+1]
        CMP AL,32
        JNE !do_33
        CMP ECX,0
        JE !do_33
        DEC ECX
        INC EDI
        JMP !ndo_33
!do_33:
        PUSH EDI
        ADD EDI,ECX
        CMPB [EDI+0],32
        JNE !do_33_1
        DEC ECX
        POP EDI
        JMP !do_33
!do_33_1:
        POP EDI

        MOVB [EBP-6],0

        MOVD [EBP-10],10   //Base
        MOV AL,[EDI+1]
        ADD EDI,ECX
        CMP AL,'$'         //Hexadecimal ??
        JNE !___nohex
        CMP ECX,1
        JE !___qerr
        MOVD [EBP-10],16   //Base
        DEC ECX
!___nohex:
        CMP AL,'-'
        JNE !___q2
        CMP ECX,1
        JE !___qerr
        DEC ECX
        MOVB [EBP-6],1
!___q2:
        CMP AL,'+'
        JNE !___q2r1
        CMP ECX,1
        JE !___qerr
        DEC ECX
!___q2r1:
        MOV EBX,1
        MOV EAX,0
        MOV [EBP-4],EAX
!___q1:
        MOV AL,[EDI+0]
        DEC EDI
        CMP AL,48
        JB !___qerr
        CMP AL,57
        JNA !___noqerr

        CMP AL,102
        JA !___qerr
        CMP AL,65
        JB !___qerr
        CMP AL,70
        JBE !___hexnum
        CMP AL,97
        JB !___qerr
        SUB AL,32       //To upper
!___hexnum:
        CMPD [EBP-10],16
        JNE !___qerr
        SUB AL,7
!___noqerr:
        SUB AL,48
        MOVZX EAX,AL
        MUL EBX
        MOV EDX,[EBP-4]
        ADD EDX,EAX
        MOV [EBP-4],EDX
        MOV EAX,EBX
        MOV EBX,[EBP-10]    //Base
        MUL EBX
        MOV EBX,EAX
        LOOP !___q1
!___qerr:
        MOV EDI,[EBP+8]     //result
        XOR CH,CH
        MOV [EDI+0],CX

        // failure ??
        CMP CX,0
        JE !qqqq2                //no error
        PUSH DWORD PTR [EBP+16]  //s
        CALLN32 SYSTEM.GetStrErrorPos
        MOV EDI,[EBP+8]
        MOV [EDI+0],EAX
        MOV EAX,0
        JMP !___q3
!qqqq2:
        MOV EAX,[EBP-4]
        CMPB [EBP-6],1
        JNE !___q3
        NEG EAX
!___q3:
        MOV EDI,[EBP+12]    //l
        MOV [EDI+0],AL

        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX

        LEAVE
        RETN32 12
SYSTEM.!Str2Byte ENDP

END;

PROCEDURE AnsiStr2Byte(VAR s:AnsiString;VAR b:BYTE;VAR c:INTEGER);
VAR s1:STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH ESI
        PUSH EDI
     END;

     s1:=s;
     ASM
        LEA EAX,s1
        PUSH EAX
        PUSH DWORD PTR b
        PUSH DWORD PTR c
        CALLN32 SYSTEM.!Str2Byte
     END;

     ASM
        POP EDI
        POP ESI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

PROCEDURE AnsiStr2Word(VAR s:AnsiString;VAR b:WORD;VAR c:INTEGER);
VAR s1:STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH ESI
        PUSH EDI
     END;

     s1:=s;
     ASM
        LEA EAX,s1
        PUSH EAX
        PUSH DWORD PTR b
        PUSH DWORD PTR c
        CALLN32 SYSTEM.!Str2Word
     END;

     ASM
        POP EDI
        POP ESI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;

END;

PROCEDURE AnsiStr2Long(VAR s:AnsiString;VAR b:LONGINT;VAR c:INTEGER);
VAR s1:STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH ESI
        PUSH EDI
     END;

     s1:=s;
     ASM
        LEA EAX,s1
        PUSH EAX
        PUSH DWORD PTR b
        PUSH DWORD PTR c
        CALLN32 SYSTEM.!Str2Long
     END;

     ASM
        POP EDI
        POP ESI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

ASSEMBLER

SYSTEM.!AssignStr2Array PROC NEAR32
                CLD
                PUSH EBP
                MOV EBP,ESP

                PUSH EAX
                PUSH EBX
                PUSH ECX
                PUSH EDX
                PUSH EDI
                PUSH ESI

                MOV EDI,[EBP+8]    //Destination Array
                MOV ESI,[EBP+12]   //Source String

                MOVZXB ECX,[ESI+0]
                INC ESI

                MOV EDX,ECX
                SHR ECX,2
                REP
                MOVSD
                MOV ECX,EDX
                AND ECX,3
                REP
                MOVSB

                POP ESI
                POP EDI
                POP EDX
                POP ECX
                POP EBX
                POP EAX

                LEAVE
                RETN32 8
SYSTEM.!AssignStr2Array ENDP

SYSTEM.!AssignCStr2Array PROC NEAR32
                CLD
                PUSH EBP
                MOV EBP,ESP

                PUSH EAX
                PUSH EBX
                PUSH ECX
                PUSH EDX
                PUSH EDI
                PUSH ESI

                MOV ESI,[EBP+12]   //Source CString
                MOV EDI,ESI
                MOV ECX,$0FFFFFFFF
                XOR AL,AL
                REPNE
                SCASB
                NOT ECX

                MOV EDI,[EBP+8]    //Destination Array

                MOV EDX,ECX
                SHR ECX,2
                REP
                MOVSD
                MOV ECX,EDX
                AND ECX,3
                REP
                MOVSB

                POP ESI
                POP EDI
                POP EDX
                POP ECX
                POP EBX
                POP EAX

                LEAVE
                RETN32 8
SYSTEM.!AssignCStr2Array ENDP

SYSTEM.!StrCopy PROC NEAR32
                CLD
                PUSH EBP
                MOV EBP,ESP

                PUSH EAX
                PUSH ECX
                PUSH EDI
                PUSH ESI

                MOV EDI,[EBP+12]    //Destination String
                MOV ESI,[EBP+16]    //Source String
                MOV ECX,[EBP+8]     //Maximum length
                LODSB
                CMP AL,CL
                JBE _L1
                MOV AL,CL
_L1:
                STOSB
                MOVZX ECX,AL

                MOV EAX,ECX
                SHR ECX,2
                REP
                MOVSD
                MOV ECX,EAX
                AND ECX,3
                REP
                MOVSB

                POP ESI
                POP EDI
                POP ECX
                POP EAX

                LEAVE
                RETN32 12
SYSTEM.!StrCopy ENDP

SYSTEM.!AssignStr2PChar PROC NEAR32
                CLD
                PUSH EBP
                MOV EBP,ESP

                PUSH EAX
                PUSH ECX
                PUSH EDX
                PUSH EDI
                PUSH ESI

                MOV EDI,[EBP+12]    //Destination CString
                MOV ESI,[EBP+16]    //Source String
                MOV ECX,[EBP+8]     //Maximum length

                LODSB               //get length of source string
                MOVZX EAX,AL
                CMP EAX,ECX
                JB _L1_1
                MOV EAX,ECX
_L1_1:
                MOV ECX,EAX
                MOV EDX,EAX
                SHR ECX,2
                REP
                MOVSD
                MOV ECX,EDX
                AND ECX,3
                REP
                MOVSB

                MOV AL,0
                STOSB            //terminate PChar

                POP ESI
                POP EDI
                POP EDX
                POP ECX
                POP EAX

                LEAVE
                RETN32 12
SYSTEM.!AssignStr2PChar ENDP

SYSTEM.!AssignPChar2Str PROC NEAR32
                CLD
                PUSH EBP
                MOV EBP,ESP

                PUSH EAX
                PUSH EBX
                PUSH ECX
                PUSH EDX
                PUSH EDI
                PUSH ESI

                MOV ESI,[EBP+16]   //Source CString
                MOV EDX,[EBP+8]    //Maximum length

                MOV EDI,ESI        //Source CString
                MOV ECX,$0FFFFFFFF
                XOR AL,AL
                REPNE
                SCASB
                NOT ECX
                MOV EAX,ECX        //length of source string
                DEC EAX            //without #0

                MOV EDI,[EBP+12]   //Destination String

                CMP EAX,EDX
                JB _L1_2
                MOV EAX,EDX        //set to maximum length
_L1_2:
                MOV ECX,EAX
                STOSB              //set string length

                MOV EDX,ECX
                SHR ECX,2
                REP
                MOVSD
                MOV ECX,EDX
                AND ECX,3
                REP
                MOVSB

                POP ESI
                POP EDI
                POP EDX
                POP ECX
                POP EBX
                POP EAX

                LEAVE
                RETN32 12
SYSTEM.!AssignPChar2Str ENDP

SYSTEM.!CopyArrayStr PROC NEAR32
                CLD
                MOV EBX,ESP
                MOV EDI,[EBX+12]    //Destination String
                MOV ESI,[EBX+16]    //Source Array
                MOV ECX,[EBX+8]     //Maximum string length
                DEC ECX             //minus length byte
                MOV EAX,[EBX+4]     //Array length

                CMP AL,CL
                JBE _L11
                MOV AL,CL
_L11:
                STOSB               //String length
                MOV CL,AL
                MOVZX ECX,CL

                MOV EDX,ECX
                SHR ECX,2
                REP
                MOVSD
                MOV ECX,EDX
                AND ECX,3
                REP
                MOVSB

                RETN32 16
SYSTEM.!CopyArrayStr ENDP

//(Source,Dest,MaxLen)
SYSTEM.!PCharCopy PROC NEAR32
         CLD
         PUSH EBP
         MOV EBP,ESP

         PUSH EAX
         PUSH EBX
         PUSH ECX
         PUSH EDX
         PUSH ESI
         PUSH EDI

         MOV EDI,[EBP+16]  //Source
         MOV ECX,$0FFFFFFFF
         XOR AL,AL
         REPNE
         SCASB
         NOT ECX
         MOV EDX,[EBP+8]   //Maximum length
         CMP EDX,ECX
         JAE _re
         MOV ECX,EDX
_re:
         MOV ESI,[EBP+16]  //Source
         MOV EDI,[EBP+12]  //Destination

         MOV EDX,ECX
         SHR ECX,2
         REP
         MOVSD
         MOV ECX,EDX
         AND ECX,3
         REP
         MOVSB

         POP EDI
         POP ESI
         POP EDX
         POP ECX
         POP EBX
         POP EAX

         LEAVE
         RETN32 12
SYSTEM.!PCharCopy ENDP

SYSTEM.!PCharLength PROC NEAR32
         PUSH EBP
         MOV EBP,ESP

         PUSH EBX
         PUSH EDI
         PUSH ECX

         MOV EDI,[EBP+8]   //Source

         XOR EAX,EAX
         CMP EDI,0
         JE _pcl

         MOV ECX,$0FFFFFFFF
         XOR AL,AL
         CLD
         REPNE
         SCASB
         NOT ECX
         MOV EAX,ECX
         DEC EAX           //without #0
_pcl:
         POP ECX
         POP EDI
         POP EBX

         LEAVE
         RETN32 4
SYSTEM.!PCharLength ENDP


SYSTEM.!StrAdd PROC NEAR32
        PUSH EBP
        MOV EBP,ESP

        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI

        MOV EDI,[EBP+12]    //Destination
        MOV ESI,[EBP+8]     //String to add
        MOVZXB ECX,[EDI+0]  //length of destination
        CLD
        LODSB               //length of string to add
        ADD [EDI+0],AL
        JNC _lll1
        MOVB [EDI+0],255
        MOV AL,CL
        NOT AL
_lll1:
        ADD EDI,ECX
        INC EDI
        MOV CL,AL

        MOV EDX,ECX
        SHR ECX,2
        REP
        MOVSD
        MOV ECX,EDX
        AND ECX,3
        REP
        MOVSB

        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX

        LEAVE
        RETN32 8
SYSTEM.!StrAdd ENDP

SYSTEM.!PCharAdd PROC NEAR32
        PUSH EBP
        MOV EBP,ESP

        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI

        CLD

        MOV ESI,[EBP+8]    //String to add
        MOV EDI,[EBP+8]    //String to add
        MOV ECX,$0FFFFFFFF
        XOR AL,AL
        REPNE
        SCASB
        NOT ECX            //length of string to add
        DEC ECX            //without #0
        MOV EBX,ECX

        MOV EDI,[EBP+12]   //Destination
        MOV ECX,$0FFFFFFFF
        XOR AL,AL
        REPNE
        SCASB
        NOT ECX            //length of destination
        DEC ECX            //without #0

        MOV EDI,[EBP+12]   //Destination
        ADD EDI,ECX        //add length to destination

        MOV ECX,EBX        //length of string to add

        MOV EDX,ECX
        SHR ECX,2
        REP
        MOVSD
        MOV ECX,EDX
        AND ECX,3
        REP
        MOVSB

        MOV AL,0
        STOSB              //terminate PChar

        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX

        LEAVE
        RETN32 8
SYSTEM.!PCharAdd ENDP

SYSTEM.!Str2PChar PROC NEAR32
               PUSH EBP
               MOV EBP,ESP

               PUSH EAX
               PUSH EBX
               PUSH ECX
               PUSH EDX
               PUSH EDI
               PUSH ESI

               MOV ESI,[EBP+8]     //String to convert
               MOV EDI,ESI
               MOVZXB ECX,[ESI+0]
               INC ESI

               CLD
               MOV EDX,ECX
               SHR ECX,2
               REP
               MOVSD
               MOV ECX,EDX
               AND ECX,3
               REP
               MOVSB

               MOV AL,0   //terminate PChar
               STOSB

               POP ESI
               POP EDI
               POP EDX
               POP ECX
               POP EBX
               POP EAX

               LEAVE
               RETN32 4
SYSTEM.!Str2PChar ENDP

SYSTEM.!PChar2Str PROC NEAR32
               PUSH EBP
               MOV EBP,ESP

               PUSH EAX
               PUSH EBX
               PUSH ECX
               PUSH EDX
               PUSH EDI
               PUSH ESI

               MOV EDI,[EBP+8]   //string to convert

               CLD
               MOV ECX,$0FFFFFFFF
               XOR AL,AL
               REPNE
               SCASB
               NOT ECX            //length of string
               DEC ECX            //without #0
               MOV EDX,ECX        //used to set len

               MOV ESI,[EBP+8]
               ADD ESI,ECX        //to last character of source
               DEC ESI
               MOV EDI,ESI
               INC EDI            //destination is 1 up

               STD                //move the bytes 1 up
               REP
               MOVSB

               MOV AL,DL          //set string length
               STOSB
               CLD

               POP ESI
               POP EDI
               POP EDX
               POP ECX
               POP EBX
               POP EAX

               LEAVE
               RETN32
SYSTEM.!PChar2Str ENDP

SYSTEM.!StringCmp PROC NEAR32
              CLD
              PUSH EBP
              MOV EBP,ESP

              PUSH EAX
              PUSH ECX
              PUSH EDI
              PUSH ESI

              MOV EDI,[EBP+8]
              MOV ESI,[EBP+12]
              LODSB
              MOV AH,[EDI+0]
              INC EDI
              MOV CL,AL
              CMP CL,AH
              JBE _nl1
              MOV CL,AH
_nl1:
              OR CL,CL
              JE _nl2
              MOVZX ECX,CL
              CLD
              REP
              CMPSB
              JNE _nl3
_nl2:
              CMP AL,AH
_nl3:
              POP ESI
              POP EDI
              POP ECX
              POP EAX

              LEAVE
              RETN32 8
SYSTEM.!StringCmp ENDP

SYSTEM.!StringEq PROC NEAR32
              CLD
              PUSH EBP
              MOV EBP,ESP

              PUSH EAX
              PUSH ECX
              PUSH EDI
              PUSH ESI

              MOV EDI,[EBP+12]
              MOV ESI,[EBP+8]

              LODSB
              CMP AL,[EDI]
              JNE _nl3eq
              CMP AL,0
              JE _nl3eq
              INC EDI
              MOVZX ECX,AL
              REP
              CMPSB
_nl3eq:
              POP ESI
              POP EDI
              POP ECX
              POP EAX

              LEAVE
              RETN32 8
SYSTEM.!StringEq ENDP

SYSTEM.!PCharCmp PROC NEAR32
              CLD
              PUSH EBP
              MOV EBP,ESP

              PUSH EAX
              PUSH EBX
              PUSH ECX
              PUSH EDX
              PUSH EDI
              PUSH ESI

              MOV EDI,[EBP+8]
              CLD
              MOV ECX,$0FFFFFFFF
              XOR AL,AL
              REPNE
              SCASB
              NOT ECX            //length of string
              DEC ECX            //without #0
              MOV EBX,ECX        //used to set len

              MOV EDI,[EBP+12]
              CLD
              MOV ECX,$0FFFFFFFF
              XOR AL,AL
              REPNE
              SCASB
              NOT ECX            //length of string
              DEC ECX            //without #0
              MOV EDX,ECX

              MOV EDI,[EBP+8]
              MOV ESI,[EBP+12]

              CMP EBX,ECX
              JNE _nl3_1
_nl1_1:
              OR ECX,ECX
              JE _nl2_1

              CLD
              REP
              CMPSB
              JNE _nl3_1
_nl2_1:
              CMP EBX,EDX
_nl3_1:
              POP ESI
              POP EDI
              POP EDX
              POP ECX
              POP EBX
              POP EAX

              LEAVE
              RETN32 8
SYSTEM.!PCharCmp ENDP

SYSTEM.!StrPCharCmp PROC NEAR32
              CLD
              PUSH EBP
              MOV EBP,ESP

              PUSH EAX
              PUSH EBX
              PUSH ECX
              PUSH EDX
              PUSH EDI
              PUSH ESI

              MOV EDI,[EBP+8]    //PChar
              CLD
              MOV ECX,$0FFFFFFFF
              XOR AL,AL
              REPNE
              SCASB
              NOT ECX            //length of string
              DEC ECX            //without #0
              MOV EBX,ECX        //used to set len

              MOV EDI,[EBP+12]   //Str
              MOVZXB ECX,[EDI]
              MOV EDX,ECX

              MOV EDI,[EBP+8]    //PChar
              MOV ESI,[EBP+12]   //Str
              INC ESI

              CMP EBX,ECX
              JNE _nl3_1_r1
_nl1_1_r1:
              OR ECX,ECX
              JE _nl2_1_r1

              CLD
              REP
              CMPSB
              JNE _nl3_1_r1
_nl2_1_r1:
              CMP EBX,EDX
_nl3_1_r1:
              POP ESI
              POP EDI
              POP EDX
              POP ECX
              POP EBX
              POP EAX

              LEAVE
              RETN32 8
SYSTEM.!StrPCharCmp ENDP

SYSTEM.!PCharStrCmp PROC NEAR32
              CLD
              PUSH EBP
              MOV EBP,ESP

              PUSH EAX
              PUSH EBX
              PUSH ECX
              PUSH EDX
              PUSH EDI
              PUSH ESI

              MOV EDI,[EBP+8]    //Str
              MOVZXB ECX,[EDI]
              MOV EBX,ECX        //used to set len

              MOV EDI,[EBP+12]   //PChar
              CLD
              MOV ECX,$0FFFFFFFF
              XOR AL,AL
              REPNE
              SCASB
              NOT ECX            //length of string
              DEC ECX            //without #0
              MOV EDX,ECX

              MOV EDI,[EBP+8]    //Str
              MOV ESI,[EBP+12]   //PChar
              INC EDI

              CMP EBX,ECX
              JNE _nl3_1_r2
_nl1_1_r2:
              OR ECX,ECX
              JE _nl2_1_r2

              CLD
              REP
              CMPSB
              JNE _nl3_1_r2
_nl2_1_r2:
              CMP EBX,EDX
_nl3_1_r2:
              POP ESI
              POP EDI
              POP EDX
              POP ECX
              POP EBX
              POP EAX

              LEAVE
              RETN32 8
SYSTEM.!PCharStrCmp ENDP

END;

//************************************************************************
// Error support functions
//************************************************************************

{$IFDEF OS2}
IMPORTS
       FUNCTION DosExit(action,result:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 234;
END;
{$ENDIF}


const
  xyz:^byte=nil;
var
  MainTls:POINTER; MainTlsSize : longword;

PROCEDURE SysExit;

Begin
  FreeAPIMem(MainTls,MainTlsSize); {Martin0407}
  {$IFDEF OS2}
  DosExit(1,ExitCode);
  {$ENDIF}
  {$IFDEF Win32}
  ExitProcess(ExitCode);
 {$ENDIF}
End;

PROCEDURE ExitAll;
BEGIN
  {$IFDEF OS2}
  IF ApplicationType=cApplicationType_GUI THEN {destroy PM}
  BEGIN
       WinDestroyMsgQueueAPI(AppQueueHandle);
       AppQueueHandleIntern:=0;
       WinTerminateAPI(HInstance);
       //HInstance:=0;
       AppHandleIntern:=0;
  END;
  {$ENDIF}

  SysExit;
END;


PROCEDURE ExitAllDLL;
BEGIN
  {$IFDEF OS2}
  IF ApplicationType=cApplicationType_GUI THEN {destroy PM}
    BEGIN
      WinDestroyMsgQueueAPI(AppQueueHandle);
      AppQueueHandleIntern:=0;
      WinTerminateAPI(HInstance);
      //HInstance:=0;
      AppHandleIntern:=0;
    END;
  {$ENDIF}
  ExitProc:=NIL;
END;

{$IFDEF Win32}
var
  TlsIndex:LONGWORD;
{$ENDIF}

{$IFDEF OS2}
TYPE PTlsData=^TTlsData;
//     TTlsData=ARRAY[0..1023] OF Pointer;
       TTlsData=ARRAY[0..16383] OF Pointer; //Allozierung von 64kB auf einen Schlag statt nur 4kB {Martin 0207}

VAR TlsData:PTlsData;
{$ENDIF}


{$IFDEF Win32}
IMPORTS
   FUNCTION CreateThread(ThreadAttrs:Pointer;Stack:LONGWORD;
                         lpStartAddress:POINTER;
                         lpParameter:POINTER;dwCreationFlags:LONGWORD;
                         VAR lpThreadId:LONGWORD):LONGWORD;
                  APIENTRY;  'KERNEL32' name 'CreateThread';
   PROCEDURE ExitThread(ExitCode:LONGWORD);
                  APIENTRY;  'KERNEL32' name 'ExitThread';
   FUNCTION TlsAlloc:LONGWORD;
                  APIENTRY;  'KERNEL32' name 'TlsAlloc';
   FUNCTION TlsGetValue(dwTlsIndex:LONGWORD):POINTER;
                  APIENTRY;  'KERNEL32' name 'TlsGetValue';
   FUNCTION TlsSetValue(dwTlsIndex:LONGWORD;lpTlsValue:POINTER):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'TlsSetValue';
   FUNCTION TlsFree(dwTlsIndex:LONGWORD):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'TlsFree';
END;
{$ENDIF}

PROCEDURE CleanUp;
BEGIN
  {$IFDEF Win32}
  IF TlsIndex<>-1 THEN
  TlsFree(TlsIndex);
  TlsIndex:=-1;
  /*if HeapMutex<>0 then
    if CloseHandle(HeapMutex) then
      HeapMutex:=0;*/
  {$ENDIF}
  
  {$IFDEF OS2}    
  IF TlsData<>NIL THEN
    BEGIN
      FreeAPIMem(TlsData,sizeof(TTlsData));
      TlsData:=NIL;
    END;
  //Free HeapMutex ?
  //Free Tls Memory ?          
  {$ENDIF}
END;

PROCEDURE Halt(Code:LONGWORD);

BEGIN
  CleanUp;
  ExitCode:=Code;

  ASM
!exloop:
    PUSHL *!raddr                     //Return adress for ExitProc
    PUSH DWORD PTR SYSTEM.ExitProc    //ExitProc on Stack
    RETN32
!raddr:
    {$IFDEF OS2}
    CMPD SYSTEM.DLLModule,0  //from DLL ????
    JE !exloop
    {$ENDIF}
    CMPD SYSTEM.ExitProc,0
    JNE !exloop           //until termination
  END;
//should never go to here except we are in a dll...
//     SysExit; //??
END;

PROCEDURE HaltIntern(Code:LONGWORD);
VAR
   cs:CSTRING;
   cTitle:CSTRING;
BEGIN                  
  ExitCode:=Code;
  IF ExitCode<>0 THEN
    BEGIN
      {$IFDEF OS2}
      IF ApplicationType=cApplicationType_GUI
        THEN
          BEGIN
            cs:='WDSibyl Runtime error '+tostr(ExitCode);
            cTitle:='Runtime error';
            InitPM;
            WinMessageBox(1,1,cs,ctitle,0,$4000 OR $0010);
          END
        ELSE Writeln('WDSibyl Runtime error ',ExitCode);
      {$ENDIF}        
      {$IFDEF Win32}
      IF ApplicationType=cApplicationType_GUI
        THEN
          BEGIN
            cs:='WDSibyl Runtime error '+tostr(ExitCode);
            cTitle:='Runtime error';
            MessageBox(0,cs,ctitle,0);
          END
        ELSE Writeln('WDSibyl Runtime error ',ExitCode);
      {$ENDIF}
    END;

    ASM
!exloop_11:
      PUSHL *!raddr_11                  //Return adress for ExitProc
      PUSH DWORD PTR SYSTEM.ExitProc    //ExitProc on Stack
      RETN32
!raddr_11:
      {$IFDEF OS2}
      CMP DWORD PTR SYSTEM.DLLModule,0  //from DLL ????
      JE !exloop_11
      {$ENDIF}
      CMP DWORD PTR SYSTEM.ExitProc,0
      JNE !exloop_11           //until termination
    END;

//should never go to here except we are in a dll...
    SysExit;
END;

PROCEDURE RunError(Code:LONGWORD);
BEGIN
  HaltIntern(Code);
END;


//************************************************************************
//
//
// Memory support management functions
//
//
//************************************************************************

{$IFDEF OS2}
IMPORTS
       FUNCTION DosAllocMem(VAR ppb:POINTER;cb,flag:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 299;
       FUNCTION DosFreeMem(pb:POINTER):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 304;
       FUNCTION DosSubAllocMem(pbBase:POINTER;VAR ppb:POINTER;
                        cb:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 345;
       FUNCTION DosSubFreeMem(pbBase:POINTER;pb:POINTER;
                              cb:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 346;
       FUNCTION DosSubSetMem(pbBase:POINTER;flag,cb:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 344;
       FUNCTION DosSubUnsetMem(pbBase:POINTER):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 347;
END;

CONST PAG_READ          =$00000001;      { read access                }
      PAG_WRITE         =$00000002;      { write access               }
      PAG_COMMIT        =$00000010;      { commit storage             }
      OBJ_ANY           =$00000400;      { newer OS/2 versions heap > 300MB}

      DOSSUB_INIT       =$01;            { initialize pages           }
      DOSSUB_SPARSE_OBJ =$04;            { handle commitment          }

      DC_SEM_SHARED     =$01;            { heap Semaphore flag        }
{$ENDIF}

PROCEDURE ErrorInvalidPointer(Adr:LONGINT);

VAR e:EInvalidPointer;

BEGIN
  e.Create('Invalid pointer operation (EInvalidPointer)');
  e.CameFromRTL:=TRUE;
  e.RTLExcptAddr:=POINTER(Adr);
  raise e;
END;

PROCEDURE ErrorOutOfMemory(Adr:LONGINT;Const Msg:String);

VAR e:EOutOfMemory;

BEGIN

  e.Create('Out of memory (EOutOfMemory) '+Msg);
  e.CameFromRTL:=TRUE;
  e.RTLExcptAddr:=POINTER(Adr);
  raise e;
END;

PROCEDURE ErrorInvalidHeap(Adr:LONGINT);

VAR e:EInvalidHeap;

BEGIN
  e.Create('Heap corrupted or destroyed (EInvalidHeap)');
  e.CameFromRTL:=TRUE;
  e.RTLExcptAddr:=POINTER(Adr);
  raise e;
END;

PROCEDURE ErrorInvalidHeapStructure(Adr:LONGINT; Typ : byte; ID : longint);

VAR e:EInvalidHeap;

BEGIN
  e.Create('Heap structure error (EInvalidHeapStructure) Type ' + tostr(Typ) + ' Group ID '+tostr(ID));
  e.CameFromRTL:=TRUE;
  e.RTLExcptAddr:=POINTER(Adr);
  raise e;
END;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ Speicherverwaltung fuer die Applikation (Stack, Heap usw.)               บ 
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

var
  MainHeapSize : longword; {the value of the $M Heap size}

{$ifdef win32}
const
   PAGE_READWRITE         =$04;
   MEM_COMMIT             =$1000;
   MEM_RESERVE            =$2000;
   MEM_DECOMMIT           =$4000;
   MEM_RELEASE            =$8000;
   MEM_FREE               =$10000;
{$endif}

const
  Sys_TotalAllocatedMem : longword = 0;
  Sys_GetCount : longword = 0;
  Sys_FreeCount : longword = 0;
  Sys_GetAPICount : longword = 0;
  Sys_FreeAPICount : longword = 0;

const
  InHeapErrorIntern : boolean = FALSE;

Const MinHeapSize = longword(1024)*1024*32;  // min. 32MB HeapSize
      ChgHighMem  = longword(1024)*1024*280; {Megabytes}


PROCEDURE HeapErrorIntern(Code:LONGINT;Adr:LONGWORD; ID : integer); forward;


FUNCTION SysGetMem(Size:LONGWORD):POINTER;
{$ifdef os2}
  var
    Flags,rv : longword;
{$endif}
BEGIN
  Result:=Nil;
  if Size=0 then exit;

  Sys_TotalAllocatedMem := Sys_TotalAllocatedMem + (((size-1) div 4096) + 1) * 4096{page size};
  if (Sys_TotalAllocatedMem > MainHeapSize) and (not InHeapErrorIntern) then begin
    HeapErrorIntern (1{out of memory}, 0, 0);
  end;
  {$IFDEF OS2}
  Flags := PAG_READ OR PAG_WRITE OR PAG_COMMIT;
  {when allocating more than 280 MB, use additional OBJ_ANY flag}
  if Sys_TotalAllocatedMem > ChgHighMem then
    Flags := Flags OR OBJ_ANY;
// rv:=DosAllocMem(Result,Size,Flags);
  If DosAllocMem(Result,Size,Flags) <> 0
    THEN Result:=NIL;
  {$ENDIF}
  {$IFDEF Win32}
  //Result:=GlobalAlloc($0000,Size);  {Allocate fixed memory}
  Result := VirtualAlloc(nil, Size, MEM_COMMIT, PAGE_READWRITE);
  //Rckgabewert ist nil wenn VirtualAlloc fehlgeschlagen ist
  {$ENDIF}
  inc (Sys_GetCount);
  //how much physical space has been allocated? -> round up to next 4 kB page
END;

{$HINTS OFF}
FUNCTION SysFreeMem(p:POINTER;size:LONGWORD):POINTER;
BEGIN
  {$IFDEF OS2}
  IF DosFreeMem(p)<>0
    THEN Result:=p //Failure
    ELSE Result:=NIL; //ok
  {$ENDIF}
  {$IFDEF Win32}
  //Result:=GlobalFree(p); //NIL=Ok
  if VirtualFree (p, 0, MEM_RELEASE) (*<> 0*) then
    result := NIL//OK
  else
    result := p;//failure
  //If VirtualFree succeeds, the return value is nonzero.
  {$ENDIF}
  inc (Sys_FreeCount);
  Sys_TotalAllocatedMem := Sys_TotalAllocatedMem - (((size-1) div 4096) + 1) * 4096{page size};
END;
{$HINTS ON}


PROCEDURE GetAPIMem(VAR p:POINTER;Size:LONGWORD);
VAR Adr:LONGWORD;
BEGIN
  p := SysGetMem(Size);
  IF (p = NIL) And (Size > 0) THEN
    BEGIN
      ASM
         MOV EAX,[EBP+4]
         SUB EAX,5
         MOV Adr,EAX
      END;
      ErrorOutOfMemory(Adr,'');
    END;
  inc (Sys_GetApiCount);
END;


PROCEDURE FreeAPIMem(p:POINTER;size:LONGWORD);
VAR Adr:LONGWORD;
BEGIN
     If SysFreeMem(p,Size)<>NIL THEN
     BEGIN
          ASM
            MOV EAX,[EBP+4]
            SUB EAX,5
            MOV Adr,EAX
          END;
          ErrorInvalidPointer(Adr);
     END;
  inc (Sys_FreeApiCount);
END;

{$HINTS OFF}
PROCEDURE Mark(VAR p:POINTER);
BEGIN
END;

PROCEDURE Release(VAR p:POINTER);
BEGIN
END;

FUNCTION StdHeapError(size:LONGWORD):INTEGER;
BEGIN
     StdHeapError:=0;  {Raise Runtime error}
END;
{$HINTS ON}

{$IFDEF OS2}
IMPORTS
FUNCTION DosCreateMutexSem(pszName:CSTRING;VAR aphmtx:LONGWORD;flAttr:LONGWORD;
                           fState:LONGBOOL):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 331;
FUNCTION DosRequestMutexSem(ahmtx:LONGWORD;ulTimeout:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 334;
FUNCTION DosReleaseMutexSem(ahmtx:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 335;
FUNCTION DosCloseMutexSem (ahmtx:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 333;
END;
{$ENDIF}


// muแ wegen Forms.SetupComplib erstmal stehen gelassen werden
CONST HeapFlag=$524E544C;

type
    PHeapList=^THeapList;
    THeapList=RECORD
                    Flag:LONGWORD;   {RNTM}
                    Size:LONGWORD;
                    LastLeak:PHeapList;
                    NextLeak:PHeapList;
    END;
type
    PHeapPages=^THeapPages;
    THeapPages=ARRAY[0..8191] OF PHeapList;  {Pointers to heap handles}

VAR LastHeapPage:PHeapList;
    LastHeapPageAdr:PHeapList;

CONST HeapMutex:LONGWORD=0;

{Martin0407 allgemeine Semaphoren-Funktionen}

procedure SysCreateMutex (var Mutex : longword);
  begin
    {$IFDEF WIN32}
    Mutex:=CreateMutex(Nil,False,Nil);
    IF Mutex=0 THEN RunError(RunError_Heap);
    {$ENDIF}
    {$IFDEF OS2}
    IF DosCreateMutexSem(NIL,Mutex,DC_SEM_SHARED,FALSE)<>0 THEN RunError(RunError_Heap);
    {$ENDIF}
  end;

PROCEDURE SysRequestMutex (Mutex : longword);
BEGIN
     {$IFDEF OS2}
     IF Mutex<>0 THEN
       DosRequestMutexSem(Mutex,-1);
     {$ENDIF}
     {$IFDEF WIN32}
     IF Mutex<>0 THEN
       WaitForSingleObject(Mutex,-1);
     {$ENDIF}
END;

PROCEDURE SysReleaseMutex (Mutex : longword);
BEGIN
     {$IFDEF OS2}
     IF Mutex<>0 THEN
       DosReleaseMutexSem(Mutex);
     {$ENDIF}
     {$IFDEF WIN32}
     IF Mutex<>0 THEN
       ReleaseMutex(Mutex);
     {$ENDIF}
END;

procedure SysCleanupMutex (var Mutex : longword);
  begin
    {$IFDEF Win32}
    if Mutex<>0 then
      if CloseHandle(Mutex) then
        Mutex:=0;
    {$ENDIF}

    {$IFDEF OS2}
    {Martin0407}
    if Mutex <> 0 then
      if DosCloseMutexSem (Mutex) = 0 then
        Mutex := 0;
    {$ENDIF}
  end;


{
  WDsibyl Heap management, completely new designed 3/2007 by M. Vieregg
  This code works fine even with small mem allocations up to 4 GB.
}

type
  pHeapBlock = ^tHeapBlock;
  pHeapItemEmpty = ^tHeapItemEmpty;
  pHeapItem =  ^tHeapItem;
  tHeapBlock = record
                 {4} len : longword; {brutto}
                 {2} ID : integer;
                 {8} BeginUsed, EndUsed : Pointer; //EndUsed steht am Ende des benutzten Bereichs +1
                 {1} SingleUse : boolean;{or Group usage}
                 {4} ItemCount : longint;
                 {4} FirstItemEmpty : pHeapItemEmpty;
                 {8} last, next : pHeapBlock;
                     //buf : array [0..maxlongint] of byte;{user data, this line has no effect}
               end;
  tHeapItem =  record
                 {4} ResidesInBlock : pHeapBlock;
                 {4} len : longint; {brutto}
                     //buf : array [0..maxlongint] of byte;
               end;
  {HeapItemEmpty has got always the same address as HeapItem, but different contents:
   The temporarily not used space is used for heap management instead

   ss = 'same size' pointer chain: connects all empty items with same size
   sb = 'same block' pointer chain: connects all empty items within the same block

   but the ItemEmpty management is only used if the heap useage within a block is fragmented
   }

  tHeapItemEmpty =  record
                 {4} ResidesInBlock : pHeapBlock; //restore pointer in empty-state!
                 {4} len : longint; {brutto}
                 {additional data for empty space, occupies the user data space}
                 {8} sslast, ssnext : pHeapItemEmpty;
                 {8} sblast, sbnext : pHeapItemEmpty;
                 {16 mehr als HeapItemAddlen}
                 //buf : array [0..maxlongint] of byte; //no user data ist stored in empty state
               end;
const
  HeapBlockAddlen = 31;
  HeapItemAddlen = 8;
  HeapItemEmptyBytes = 16; {Mindestanforderung fr Getmem aufgrund von Empty Management}
type
  pEmptyItemSameSize = ^tEmptyItemSameSize;
  tEmptyItemSameSize = array[1..$4000] of pHeapItemEmpty;

const
  Default_BlockShift = 2; // = block size 64 kB
  HeapGroupCount = 200;
type              //Group-ID, wird vom Anwendungsprogrammierer vergeben
                 //um ganze Gruppen von Speicheranforderungen l”schen zu k”nnen
  pHeapGroup = ^tHeapGroup;
  tHeapGroup = array[0..HeapGroupCount-1] of record
                 Anchor, LastInGroup, LastUsed : pHeapBlock;
                 LastWasGetmem, Used, EverUsed : boolean;
                 Mutex : longword;
                 EmptyItemSameSize : pEmptyItemSameSize;
                 BlockShift : byte; {0 = block size $4000,   (16 kB)
                                     1 = block size $8000    (32 kB)
                                     2 = block size $10000   (64 kB) default value
                                     3 = block size $20000  (128 kB)
                                       and so on}
                                     {one group can only handle 16384 different mem sizes,
                                      the used space gets rounded to a higher value, e.g.
                                      Blockshift 2 rounds the getmem size to a higher value which
                                      can be divided by 4, so you get 0...3 bytes lost}
                 EmptyManagement, FillZeros : boolean; {default is true, can be changed by application developer}
                 {additional statistic info}
                 ItemRequests, ItemFreed, ReusedMargin, ReusedEmpty,
                 BlockRequests, BlockFreed, UsedSingle : longint;
               end;

const HeapGroup : pHeapGroup = NIL;

const DefaultHeapGroup : integer = 0; {gets only changed for final error message in NewSystemHeap}

procedure NewSystemHeap (ID : integer);
  begin
    if ID <> DefaultHeapGroup then exit; {die Fehlerroutine luft in Group 0, und wenn die nicht betroffen ist, ist es eh OK}
    if DefaultHeapGroup = 0 then
      DefaultHeapGroup := HeapGroupCount-1
    else
      dec (DefaultHeapGroup);
  end;

PROCEDURE HeapErrorIntern(Code:LONGINT;Adr:LONGWORD; ID : integer);
  var
    I : integer;
BEGIN
     InHeapErrorIntern := TRUE; //es mssen Speicheranfragen auch bei berschreitung des MainHeapSize m”glich sein,
                                //um die Fehlermeldung korrekt anzeigen zu k”nnen.
     //if ID >= 0 then ReleaseMutex (ID); //ist nicht erforderlich, wenn eine andere Gruppe gewhlt wird
     NewSystemHeap (ID);
     //Auแer der neuen DefaultHeapGroup werden alle neuen getmem Anfragen gestoppt und ggfs. Threads angehalten
     for I := 0 to HeapGroupCount-1 do if I <> DefaultHeapGroup then begin
       if HeapGroup^[I].Used then SysRequestMutex (I);
     end;
     CASE Code OF
         1: ErrorOutOfMemory(Adr,'$M Heap size is only '+tostr(MainHeapSize div 1024)+'kB');
         2: ErrorInvalidPointer(Adr);
         3: ErrorInvalidHeap(Adr);
         ELSE
           ErrorInvalidHeapStructure (Adr, Code, ID);
     END; {case}
     halt;
END;


  procedure Sys_Alloc (VAR p:POINTER;size:LONGWORD; ID : integer);
    begin
      p := SysGetMem (size);
      inc (HeapGroup^[ID].BlockRequests);
    end;

  procedure Sys_Free (VAR p:POINTER;size:LONGWORD; ID : integer);
    begin
      SysFreeMem (p, size);
      inc (HeapGroup^[ID].BlockFreed);
    end;


  procedure InitBlock (var Block : pHeapBlock; ID : integer); {not Singleuse}
    var
      blocklen : longword;
    begin
      blocklen := longword($4000) shl HeapGroup^[ID].Blockshift;
      Sys_Alloc (Block, blocklen, ID);
      Block^.len := blocklen;
      Block^.SingleUse := false;
      Block^.Itemcount := 0;
      Block^.FirstItemEmpty := nil;
      Block^.ID := ID;
      Block^.BeginUsed := nil;
      Block^.EndUsed := nil;
    end;

  PROCEDURE GetMemG (ID : integer; VAR p:POINTER; size :LONGWORD);
    var
      Block : pHeapBlock;
      Item : pHeapItem;
      eItem : pHeapItemEmpty;
      Found : boolean;
      blocklen : longword;
      blksh : byte;
    begin
      if not HeapGroup^[ID].Used then begin
          HeapGroup^[ID].Used := true;
          HeapGroup^[ID].EverUsed := true;
          SysCreateMutex (HeapGroup^[ID].Mutex);
      end;
      SysRequestMutex (HeapGroup^[ID].Mutex);
      inc (HeapGroup^[ID].ItemRequests);
      if size < HeapItemEmptyBytes then size := HeapItemEmptyBytes;{wegen sizeof(tHeapItemEmpty)}
      blksh := HeapGroup^[ID].Blockshift;
      blocklen := longword($4000) shl blksh;
      {item}size := (((size-1) shr blksh) + 1) shl blksh;{auf den nchsten durch 4 teilbaren Wert aufrunden}
      size := size + HeapItemAddlen;
      {size = size of tHeapItem, not of getmem}
      if size+HeapBlockAddlen >= blocklen then begin
        {Speicheranforderung ist gr”แer als der blich angeforderte 64 kB sys Block
         -> nur ein Item im Block}
        size := size+HeapBlockAddlen;
        {auf den nchsten durch 8 teilbaren Wert aufrunden}
        {sample: int(((X-1)/8)+1)*8}
        size := (((size-1) div 8) + 1) * 8;
        if HeapGroup^[ID].Anchor = nil then begin
          Sys_Alloc (HeapGroup^[ID].Anchor, size, ID);
          Block := HeapGroup^[ID].Anchor;
          Block^.last := nil;
          HeapGroup^[ID].LastInGroup := Block;
        end
        else begin
          Sys_Alloc (HeapGroup^[ID].LastInGroup^.next, size, ID);
          Block := HeapGroup^[ID].LastInGroup^.next;
          Block^.Last := HeapGroup^[ID].LastInGroup;
          HeapGroup^[ID].LastInGroup := Block;
        end;
        Block^.next := nil;
        Block^.len := size;
        Block^.SingleUse := true;
        Block^.Itemcount := 1;
        Block^.FirstItemEmpty := nil;
        Block^.ID := ID;
        Block^.BeginUsed := nil;
        Block^.EndUsed := nil;
        Item := pHeapItem (Block + HeapBlockAddlen);
        Item^.ResidesInBlock := Block;
        Item^.len{brutto} := size-HeapBlockAddlen; //wegen Aufrundung wird u.U. etwas mehr Speicher alloziert
                                                   //und bei len gespeichert wie vom Anwend.programmierer angegeben
        P := Item+HeapItemAddlen;
        inc (HeapGroup^[ID].UsedSingle);
        if HeapGroup^[ID].FillZeros then
          fillchar (P^, size-HeapItemAddlen-HeapBlockAddlen, #0);
      end
      else begin
        {viele Items werden in einem Block untergebracht}
        if HeapGroup^[ID].EmptyManagement and
           (HeapGroup^[ID].EmptyItemSameSize <> nil) and
           (HeapGroup^[ID].EmptyItemSameSize^[size shr blksh] <> nil) then begin
          inc (HeapGroup^[ID].ReusedEmpty);
          {reuse of an fragmented freemem hole with same size}
          eItem := HeapGroup^[ID].EmptyItemSameSize^[size shr blksh];
          {eItem aus der ss-Kette entfernen, ist immer der erste der Kette}
          if eItem^.ssnext <> nil then eItem^.ssnext^.sslast := nil;
          HeapGroup^[ID].EmptyItemSameSize^[size shr blksh] := eItem^.ssnext;
          {eItem aus der sb-Kette entfernen, diesmal aber mitten in der Kette}
          if eItem^.sblast = nil then begin
            {eItem = FirstItemEmpty, also der Anker der sb-Kette}
            if eItem <> eItem^.ResidesInBlock^.FirstItemEmpty then
              //Beep (100, 30); {testcode}
              HeapErrorIntern (11, LONGWORD(eItem), ID);
            eItem^.ResidesInBlock^.FirstItemEmpty := eItem^.sbnext;
          end
          else begin
            eItem^.sblast^.sbnext := eItem^.sbnext;
          end;
          if eItem^.sbnext <> nil then
            eItem^.sbnext^.sblast := eItem^.sblast;
          inc (eItem^.ResidesInBlock^.ItemCount);
          Item := pHeapItem(eItem);
          Item^.len := size{brutto}; {berflssig}{war berschrieben durch anderen Pointer}
          P := Item+HeapItemAddlen;
          if HeapGroup^[ID].FillZeros then
            fillchar (P^, size-HeapItemAddlen, #0);
        end
        else begin
          Block := nil;
          repeat
            if HeapGroup^[ID].LastUsed <> nil then begin
              Block := HeapGroup^[ID].LastUsed; {das ist am hufigsten}
            end
            else begin
              if HeapGroup^[ID].Anchor = nil then begin
                InitBlock (HeapGroup^[ID].Anchor, ID);
                Block := HeapGroup^[ID].Anchor;
                HeapGroup^[ID].LastInGroup := Block;
                Block^.next := nil;
                Block^.last := nil;
              end
              else if Block = nil then begin
                {von vorne beginnen}
                Block := HeapGroup^[ID].Anchor;
              end
              else if Block^.next = nil then begin {neuen Block ans Ende anhngen}
                InitBlock (Block^.next, ID);
                Block^.next^.last := Block;
                Block := Block^.next;
                Block^.next := nil;
                HeapGroup^[ID].LastInGroup := Block;
              end
              else begin
                Block := Block^.next;
              end;
            end;
            {jetzt ist ein Block, in dem vielleicht Platz ist, auf jeden Fall gefunden}
            {schauen ob noch Platz ist}
            Found := false;
            if Block^.SingleUse then
              Found := false
            else if Block^.BeginUsed = nil then begin
              {noch unbenutzt}
              Item := pHeapItem (Block+HeapBlockAddlen);
              Block^.BeginUsed := Item; Block^.EndUsed := Item + size;
              Found := true;
              {    B      E                                }
              {OOOOXXXXXXX-------------------------------- }
            end
            else if longword(Block)+Block^.len - longword(Block^.EndUsed) >= size then begin
              {    B                E                      }
              {OOOOXXXXXXXXXXXXXXXXX---------------------- }
              Item := pHeapItem (Block^.EndUsed);
              Block^.EndUsed := Block^.EndUsed + size;
              Found := true;
            end
            else if longword(Block^.BeginUsed) - longword(Block) - HeapBlockAddlen >= size then begin
              {                          B                E}
              {OOOO----------------------XXXXXXXXXXXXXXXXX }
              Block^.BeginUsed := Block^.BeginUsed - size;
              Item := pHeapItem (Block^.BeginUsed);
              Found := true;
            end
            else
              Found := false;
            if Found then begin
              inc (HeapGroup^[ID].ReusedMargin);
              Item^.ResidesInBlock := Block;
              HeapGroup^[ID].LastUsed := Block;
              HeapGroup^[ID].LastWasGetmem := true;
              Item^.len := size{brutto};
              inc (Block^.ItemCount);
              P := Item+HeapItemAddlen;
              if HeapGroup^[ID].FillZeros then
                fillchar (P^, size-HeapItemAddlen, #0);
              break;
            end;
            {leider schon alles voll, also weitersuchen!}
            if HeapGroup^[ID].LastUsed <> nil then begin
              {der bislang benutzte Block ist leider voll. Von vorne beginnen, wenn LastWasGetmem = false,
               andernfalls gleich den nchsten Block neu erzeugen}
              if HeapGroup^[ID].LastWasGetMem then begin
                {Gleich nchsten Block erzeugen}
                Block := HeapGroup^[ID].LastInGroup;
              end
              else begin
                Block := nil;
                {von vorne mit der Schleife beginnen}
              end;
              HeapGroup^[ID].LastUsed := nil;
            end;
          until false;
        end;{not EmptyManagement}
      end;{viele Items in einem Block}
      SysReleaseMutex (HeapGroup^[ID].Mutex);
    end;


  PROCEDURE GetMem(VAR p:POINTER;size:LONGWORD);
    begin
      GetMemG (DefaultHeapGroup, P, size);
    end;

  PROCEDURE FreeMem(p:POINTER;size:LONGWORD);
    var
      Block : pHeapBlock;
      Item : pHeapItem;
      eItem, OldeItem, eItem2 : pHeapItemEmpty;
      blksh : byte;
      ID : integer;
    begin
      if P = nil then exit;
      Item := pHeapItem(P-HeapItemAddlen);
      size := Item^.len; {verlassen wir uns lieber nicht auf den Anwendungsprogrammierer!
                          wobei Item^.len = size + HeapItemAddlen}
      Block := Item^.ResidesInBlock;
      if Block = nil then
        HeapErrorIntern (12, LONGWORD(eItem), -1);
        //Beep (100, 30); {Fehlerhafte Datenstruktur}
      ID := Block^.ID;
      SysRequestMutex (HeapGroup^[ID].Mutex);
      inc (HeapGroup^[ID].ItemFreed);
      blksh := HeapGroup^[ID].Blockshift;
      if not Block^.SingleUse then begin
        //Application.Logwriteln ('Block: Group ' + tostr(ID) +  ' len ' + tostr(Block^.len) + ' itemlen ' + tostr(Item^.len));
        {ist das Item ... am Ende des benutzten Bereichs?}
        {    B       .........E                      }
        {OOOOXXXXXXXXXXXXXXXXX---------------------- }
        if Pointer(Item) = Block^.EndUsed - size then begin
          Block^.EndUsed := Block^.EndUsed - size;
          HeapGroup^[ID].LastWasGetmem := false;
          HeapGroup^[ID].LastUsed := Block; {Martin0707}
        end
        {           B.........           E           }
        {OOOO-------XXXXXXXXXXXXXXXXXXXXX----------- }
        {ist das Item am Anfang des benutzten Bereichs?}
        else if Pointer(Item) = Block^.BeginUsed then begin
          Block^.BeginUsed := Block^.BeginUsed + size;
          HeapGroup^[ID].LastWasGetmem := false;
          HeapGroup^[ID].LastUsed := Block; {Martin0707}
        end else begin
          {Item ist mittendrin freigeworden, EmptyManagement starten}
          if HeapGroup^[ID].EmptyManagement then begin
            eItem := pHeapItemEmpty (Item);
            if HeapGroup^[ID].EmptyItemSameSize = nil then begin
              {neuen Array mit den ss Pointern initialisieren}
              Sys_Alloc (HeapGroup^[ID].EmptyItemSameSize, $10000, ID);
              fillchar (HeapGroup^[ID].EmptyItemSameSize^, sizeof (HeapGroup^[ID].EmptyItemSameSize^), #0);
            end;

            {Verdrahtung ss}
            OldeItem := HeapGroup^[ID].EmptyItemSameSize^[size shr blksh];
            HeapGroup^[ID].EmptyItemSameSize^[size shr blksh] := eItem;
            eItem^.sslast := nil;
            eItem^.ssnext := OldeItem;
            if OldeItem <> nil then begin
              OldeItem^.sslast := eItem;
            end;

            {Verdrahtung sb}
            OldeItem := Block^.FirstItemEmpty;
            Block^.FirstItemEmpty := eItem;
            eItem^.sblast := nil;
            eItem^.sbnext := OldeItem;
            if OldeItem <> nil then begin
              OldeItem^.sblast := eItem;
            end;
          end;
        end;
      end;
      {bei SingleUse ist ItemCount 1 und FirstItemEmpty NIL}
      {auf jeden Fall ItemCount dekrementieren, auch wenn fragmentiert und emptymanagement}
      dec (Block^.ItemCount);
      {wenn keine Items mehr im Block, dann Block freigeben}
      if Block^.ItemCount = 0 then begin
        {Verdrahtung muแ zu l”schenden Block berbrcken}
        if (Block^.last = nil){d.h. Block ist Anker} and (Block^.next = nil){Anker war der einzige Block} then begin
          HeapGroup^[ID].Anchor := nil;
          HeapGroup^[ID].LastInGroup := nil;
          HeapGroup^[ID].LastUsed := nil;
        end
        else if Block^.last = nil then begin
          {Anker wird gel”scht, Anker^.next wird neuer Anker}
          {HeapBlockAnchor = Block}
          HeapGroup^[ID].Anchor := Block^.next;
          HeapGroup^[ID].Anchor^.last := nil;
        end
        else begin
          {Block ist mittendrin oder am Ende -> Block berbrcken}
          Block^.last^.next := Block^.next;
          if Block^.next <> nil then
            Block^.next^.last := Block^.last;
        end;
        {unbenutzten Block nun wieder freigeben}
        if Block = HeapGroup^[ID].LastUsed then
          HeapGroup^[ID].LastUsed := nil;
        if Block = HeapGroup^[ID].LastInGroup then
          HeapGroup^[ID].LastInGroup := Block^.last;
        {alle emptyitem Eintrge des aktuellen Blockes aus der ss Kette l”schen}
        {jetzt kommt die einzige Schleife im gesamten heapmanagement Programmcode !!!!}

        // [size shr blksh] ist in der Schleife falsch, weil es sich auf den aktuellen freemem item bezieht,
        // hier werden aber alle items eines Blockes mit verschiedener Gr”แe gefreet !!!!!!

        eItem := Block^.FirstItemEmpty;
        while eItem <> nil do begin
          if eItem^.sslast = nil then begin
            {es wird der Anker des sizearrays gendert}
            {es gilt hier immer: eItem = HeapGroup^[ID].EmptyItemSameSize^[eItem^.len shr blksh]}
            eItem2 := HeapGroup^[ID].EmptyItemSameSize^[eItem^.len shr blksh];
            if eItem <> eItem2 then
              HeapErrorIntern (13, LONGWORD(eItem), ID);
              //Beep (100, 30);
            HeapGroup^[ID].EmptyItemSameSize^[eItem^.len shr blksh] := eItem^.ssnext;
            if eItem^.ssnext <> nil then
              eItem^.ssnext^.sslast := nil;
          end
          else begin
            {mitten in der Kette oder am Ende der Kette}
            eItem^.sslast^.ssnext := eItem^.ssnext;
            if eItem^.ssnext <> nil then
              eItem^.ssnext^.sslast := eItem^.sslast;
          end;
          eItem := eItem^.sbnext;
        end;

        Sys_Free (Block, Block^.len, ID);
      end
      else begin
        //HeapGroup^[ID].LastUsed := Block; {Martin0707 Zeile gel”scht}
      end;
      SysReleaseMutex (HeapGroup^[ID].Mutex);
      P := nil;
    end;

  procedure HeapGroupDefaults (ID : integer);
    begin
      HeapGroup^[ID].Anchor := nil;
      HeapGroup^[ID].LastUsed := nil;
      HeapGroup^[ID].Blockshift := Default_Blockshift;
      HeapGroup^[ID].EmptyManagement := true;
      HeapGroup^[ID].FillZeros := true;
      HeapGroup^[ID].Used := false;
    end;

  procedure ReleaseHeapGroup (ID : integer);
    var
      CurH, DelH : pHeapBlock;
    begin
      if ID < 0 then exit;
      if not HeapGroup^[ID].Used then exit;
      CurH := HeapGroup^[ID].Anchor;
      while CurH <> nil do begin
        DelH := CurH;
        CurH := CurH^.next;
        Sys_Free (DelH, DelH^.len, ID);
      end;
      HeapGroupDefaults (ID);
      if HeapGroup^[ID].EmptyItemSameSize <> nil then begin
        Sys_Free (HeapGroup^[ID].EmptyItemSameSize, $10000, ID);
        HeapGroup^[ID].EmptyItemSameSize := nil;
      end;
      SysCleanupMutex (HeapGroup^[ID].Mutex);
    end;

  function GetNewHeapGroupID : integer;
    var
      ID : integer;
    begin
      {die ID 0 ist fr die klassischen Getmem Aufrufe reserviert}
      {1 bis 19 drfen vom Anwendungsprogrammierer fest vergeben werden}
      for ID := 20 to HeapGroupCount - 1 do begin
        if not HeapGroup^[ID].Used then begin
          HeapGroup^[ID].Used := true;
          HeapGroup^[ID].EverUsed := true;
          SysCreateMutex (HeapGroup^[ID].Mutex);
          result := ID; exit;
        end;
      end;
      result := -1;
      {Fehlermeldung: Keine weiteren Gruppen verfgbar!!!!!!!!! Abbruch des Programms.}
      HeapErrorIntern (14, 0, -1);
    end;


  procedure heap_Init;
    var
      ID : integer;
      PHG : pHeapGroup;
    begin
      if HeapGroup <> NIL then exit;
      HeapGroup := SysGetMem (sizeof (tHeapGroup));
      fillchar (HeapGroup^, sizeof (tHeapGroup), #0);
      for ID := 0 to HeapgroupCount-1 do begin
        HeapGroupDefaults (ID);
      end;
    end;

  procedure heap_final;
    var
      ID : integer;
      SumRemainingBlocks : longint;
      heapinfodat : text;
    begin
      if HeapGroup = nil then exit;

      //info stuff
/*      assign (heapinfodat, 'heapinfo.txt'); rewrite (heapinfodat);
      SumRemainingBlocks := 0;
      writeln (heapinfodat, '$M Heap size: '+tostr(MainHeapSize div 1024 div 1024)+' MB');
      for ID := 0 to HeapGroupCount-1 do if HeapGroup^[ID].EverUsed then begin
        writeln (heapinfodat, '---heap management (getmem/freemem) group '+tostr(ID)+ ' ---');
        writeln (heapinfodat, 'Getmem requests:  ' + tostr(HeapGroup^[ID].ItemRequests));
        writeln (heapinfodat, '- new or margin:  ' + tostr(HeapGroup^[ID].ReusedMargin));
        writeln (heapinfodat, '- use fragmented: ' + tostr(HeapGroup^[ID].ReusedEmpty));
        writeln (heapinfodat, '- single:         ' + tostr(HeapGroup^[ID].UsedSingle));
        writeln (heapinfodat, 'Freemem freed:    ' + tostr(HeapGroup^[ID].ItemFreed));
        writeln (heapinfodat, 'Block requests:   ' + tostr(HeapGroup^[ID].BlockRequests));
        writeln (heapinfodat, 'Block freed:      ' + tostr(HeapGroup^[ID].BlockFreed));
        SumRemainingBlocks := SumRemainingBlocks + HeapGroup^[ID].BlockRequests - HeapGroup^[ID].BlockFreed;
      end;
      writeln (heapinfodat, '---general memory management---');
      writeln (heapinfodat, 'Currently used memory in bytes (via sysgetmem/sysfreemem): '+tostr(Sys_TotalAllocatedMem));
      writeln (heapinfodat, 'Total Number of Sys Mem requests:  '+tostr(Sys_GetCount));
      writeln (heapinfodat, 'Total Number of Sys Free:          '+tostr(Sys_FreeCount));
      writeln (heapinfodat, 'Not freed mem requests independent from getmem/freemem and tls_Data: '+tostr(Sys_GetCount - Sys_FreeCount - SumRemainingBlocks - 2{tls_Data, Heapgroup}));
      writeln (heapinfodat, 'Total Number of ApiMem requests:  '+tostr(Sys_GetApiCount));
      writeln (heapinfodat, 'Total Number of ApiFree:          '+tostr(Sys_FreeApiCount));
      close (heapinfodat);
      // end of info stuff */

      for ID := 0 to HeapGroupCount-1 do
        ReleaseHeapGroup (ID);
      SysFreeMem (HeapGroup, sizeof (tHeapGroup));
      HeapGroup := nil;
    end;

Procedure Heap_Change(iHeapGroup : Pointer; iHeapFinal : Boolean);

Var heapinfodat : text;
    ID : integer;

Begin
  if iHeapFinal then
    Heap_final;//falls HeapGroup <> nil; Heapgroup ist jetzt auf jeden Fall NIL
  if iHeapGroup = nil
    then heap_init              //Heapgroup wird initialisiert
    else HeapGroup:=iHeapGroup; //es wird die vorhandene Heapgroup des Wirtsprogramms verwendet
End;

Function Heapgroup_BlocksCurrentlyUsed (ID : integer) : longint;

Begin
  result := HeapGroup^[ID].BlockRequests-HeapGroup^[ID].BlockFreed;
End;

FUNCTION  MaxAvail:LongWord;
BEGIN
  //result:=HeapSize;
  result := MainHeapSize;
END;

{$IFDEF OS2}
IMPORTS
     FUNCTION DosAllocSharedMem(VAR ppb:POINTER;VAR pszName:CSTRING;
                                cb,flag:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 300;
     FUNCTION DosGetSharedMem(pb:POINTER;flag:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 302;
     FUNCTION DosGetNamedSharedMem(VAR ppb:POINTER;pszName:CSTRING;
                                   flag:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 301;
END;
{$ENDIF}

PROCEDURE GetSharedMem(var p:Pointer;size:LongWord);
VAR Adr:LONGINT;
BEGIN
  {$IFDEF OS2}
  IF DosAllocSharedMem(p,NIL,size,$313) <> 0 THEN
  {$ENDIF}
  {$IFDEF WIN32}
  p:=GlobalAlloc($2000,Size);  {Allocate fixed shared memory}
  IF p=NIL THEN
  {$ENDIF}
  BEGIN
       ASM
         MOV EAX,[EBP+4]
         SUB EAX,5
         MOV Adr,EAX
       END;
       ErrorOutOfMemory(Adr,'Shared Memory');
  END;
END;

{$HINTS OFF}
PROCEDURE FreeSharedMem(p:pointer;size:LongWord);
VAR Adr:LONGINT;
BEGIN
     {$IFDEF OS2}
     If DosFreeMem(p)<>0 THEN
     {$ENDIF}
     {$IFDEF Win32}
     IF GlobalFree(p)<>NIL THEN
     {$ENDIF}
     BEGIN
          ASM
             MOV EAX,[EBP+4]
             SUB EAX,5
             MOV Adr,EAX
          END;
          ErrorInvalidPointer(Adr);
     END;
END;
{$HINTS ON}

FUNCTION AccessSharedMem(VAR p:POINTER):BOOLEAN;
BEGIN
     Result:=True;
     {$IFDEF OS2}
     Result:=DosGetSharedMem(p,3)=0;
     {$ENDIF}
END;

{$IFNDEF Win32}
{$HINTS OFF}
PROCEDURE GetNamedSharedMem(CONST Name:STRING;VAR pp:POINTER;size:LongWord);
VAR c:CSTRING;
    Adr:LONGINT;
    Msg:String;
BEGIN
     {$IFDEF OS2}
     c:='\SHAREMEM\'+Name;
     pp:=NIL;
     IF DosAllocSharedMem(pp,c,size,$13) <> 0 THEN
     {$ENDIF}
     BEGIN
          ASM
            MOV EAX,[EBP+4]
            SUB EAX,5
            MOV Adr,EAX
          END;
          Msg:='';
          ErrorOutOfMemory(Adr,Msg);
     END;
END;

FUNCTION AccessNamedSharedMem(CONST Name:STRING;VAR pp:POINTER):BOOLEAN;
VAR c:CSTRING;
BEGIN
     Result:=True;
     {$IFDEF OS2}
     c:='\SHAREMEM\'+Name;
     Result:=DosGetNamedSharedMem(pp,c,3)=0;
     IF not result THEN pp:=NIL;
     {$ENDIF}
END;

PROCEDURE FreeNamedSharedMem(CONST Name:STRING);
VAR p:POINTER;
    c:CSTRING;
BEGIN
     {$IFDEF OS2}
     c:='\SHAREMEM\'+Name;
     IF not AccessNamedSharedMem(Name,p) THEN exit;
     //we do 2x free because shared memory has a free-counter that
     //increases each time the DosGetNamedSharedMem function is called
     FreeSharedMem(p,0);
     FreeSharedMem(p,0);
     {$ENDIF}           
END;
{$HINTS ON}
{$ENDIF}

//These function is used by FAIL
PROCEDURE FreeClass(c:TObject);
BEGIN
    Try
       c.Free;
    Except
    End;
END;

//These function is used by FAIL
PROCEDURE FreeObject(p:POINTER;Len:LongWord);
BEGIN
    Try
       FreeMem(p,Len);
    Except
    End;
END;

PROCEDURE SaveGetMem(var p:Pointer;size:LongWord);
BEGIN
     ASM {!!}
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI
     END;

     GetMem(p,size);

     ASM {!!}
        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

PROCEDURE SaveFreeMem(p:pointer;size:LongWord);
BEGIN
     ASM {!!}
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI
     END;

     FreeMem(p,size);

     ASM {!!}
        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

FUNCTION MemAvail:LongWord;
BEGIN
  result:= MainHeapSize - sys_TotalAllocatedMem;
END;

//************************************************************************
//
//
// Direct Memory access support
//
//
//************************************************************************

PROCEDURE Move(CONST source; VAR dest; size:LONGWORD);

ASM
        MOV ESI,Source
        MOV EDI,Dest
        MOV ECX,Size
        CMP ESI,EDI
        JE !MoveEnd
        JA !MoveForw
        MOV EBX,ESI
        ADD EBX,ECX
        CMP EBX,EDI               // test overlapping
        JBE !MoveForw

        STD
        ADD ESI,ECX
        DEC ESI
        ADD EDI,ECX
        DEC EDI
        REP
        MOVSB
        CLD
        JMP !MoveEnd

!MoveForw:
        CLD
        MOV EDX,ECX
        SHR ECX,2
        REP
        MOVSD
        MOV ECX,EDX
        AND ECX,3
        REP
        MOVSB

!MoveEnd:
END;

PROCEDURE SaveMove(CONST source; VAR dest; size:LONGWORD);ASSEMBLER;
ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH EDI
        PUSH ESI

        MOV ESI,Source
        MOV EDI,Dest
        MOV ECX,Size
        CMP ESI,EDI
        JE !MoveEnd_1
        JA !MoveForw_1
        MOV EBX,ESI
        ADD EBX,ECX
        CMP EBX,EDI               // test overlapping
        JBE !MoveForw_1

        STD
        ADD ESI,ECX
        DEC ESI
        ADD EDI,ECX
        DEC EDI
        REP
        MOVSB
        CLD
        JMP !MoveEnd_1

!MoveForw_1:
        CLD
        MOV EDX,ECX
        SHR ECX,2
        REP
        MOVSD
        MOV ECX,EDX
        AND ECX,3
        REP
        MOVSB

!MoveEnd_1:
        POP ESI
        POP EDI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
END;

ASSEMBLER
//(Buf1,Buf2,Size)
SYSTEM.!CompareMem PROC NEAR32
        PUSH EBP
        MOV EBP,ESP
        PUSH ECX
        PUSH EDI
        PUSH ESI

        CLD
        MOV ESI,[EBP+16]  //Buf1
        MOV EDI,[EBP+12]  //Buf2
        MOV ECX,[EBP+8]   //Size
        CLD
        REP
        CMPSB

        POP ESI
        POP EDI
        POP ECX
        LEAVE
        RETN32 12
SYSTEM.!CompareMem ENDP

END;

FUNCTION CompareMem(VAR Buf1,Buf2;Size:LONGWORD):BOOLEAN;
BEGIN
     ASM
        PUSH DWORD PTR Buf1
        PUSH DWORD PTR Buf2
        PUSH DWORD PTR Size
        CALLN32 SYSTEM.!CompareMem
        SETE AL
        MOV result,AL
     END;
END;

PROCEDURE FillChar(VAR dest;size:LongWord;value:byte);ASSEMBLER;
    ASM
        CLD
        //Note: Stack is dword aligned !
        MOV EDI,Dest      //Destination pointer
        MOV ECX,Size      //count
        CMP ECX,0
        JE !ex_fillc
        MOV AL,Value      //Value
        MOV AH,AL
        PUSH AX
        PUSH AX
        POP EAX

        MOV EDX,ECX
        SHR ECX,2
        REP
        STOSD
        MOV ECX,EDX
        AND ECX,3
        REP
        STOSB
!ex_fillc:
     END;

//Set support
ASSEMBLER

//(Set,LowRange,HighRange)
SYSTEM.!SetAddRange PROC NEAR32
       PUSH EBP
       MOV EBP,ESP
       PUSH EDI
       PUSH ECX
       PUSH EDX
       PUSH EAX

       MOV EDI,[EBP+16]      //Set
       MOVZXB ECX,[EBP+12]   //LowRange
       MOVZXB EDX,[EBP+8]    //HighRange
!SaAgain:
       CMP ECX,EDX
       JA !SaEnd

       MOVZX EAX,CL
       BTS [EDI],EAX

       INC ECX
       JMP !SaAgain
!SaEnd:
       POP EAX
       POP EDX
       POP ECX
       POP EDI
       LEAVE
       RETN32 12
SYSTEM.!SetAddRange ENDP

//(Set,LowRange,HighRange)
SYSTEM.!SetMinusRange PROC NEAR32
       PUSH EBP
       MOV EBP,ESP
       PUSH EDI
       PUSH ECX
       PUSH EDX
       PUSH EAX

       MOV EDI,[EBP+16]      //Set
       MOVZXB ECX,[EBP+12]   //LowRange
       MOVZXB EDX,[EBP+8]    //HighRange
!SmAgain:
       CMP ECX,EDX
       JA !SmEnd

       MOVZX EAX,CL
       BTR [EDI],EAX

       INC ECX
       JMP !SmAgain
!SmEnd:
       POP EAX
       POP EDX
       POP ECX
       POP EDI
       LEAVE
       RETN32 12
SYSTEM.!SetMinusRange ENDP

//(LowRange,HighRange,Sub)
SYSTEM.!GenRangeDWord PROC NEAR32
      PUSH EBP
      MOV EBP,ESP
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      MOV EAX,0   //result

      MOV ECX,[EBP+16]  //LowRange
      MOV EDX,[EBP+12]  //HighRange
      MOV ESI,[EBP+8]   //Sub
!SrAgain:
      CMP ECX,EDX
      JA !SrEnd

      MOVZX EBX,CL
      SUB EBX,ESI
      BTS EAX,EBX

      INC ECX
      JMP !SrAgain
!SrEnd:
      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      LEAVE
      RETN32 12
SYSTEM.!GenRangeDWord ENDP

//(Quell,Ziel)
SYSTEM.SetOr32 PROC NEAR32
          PUSH EBP
          MOV EBP,ESP

          PUSH EAX
          PUSH EBX
          PUSH ECX
          PUSH EDX
          PUSH ESI
          PUSH EDI

          MOV EDI,[EBP+8]   //Ziel
          MOV ESI,[EBP+12]
          MOV ECX,8
!SAndl_1:
          MOV EAX,[ESI+0]
          OR EAX,[EDI+0]
          MOV [EDI+0],EAX
          ADD ESI,4
          ADD EDI,4
          LOOP !SAndl_1

          POP EDI
          POP ESI
          POP EDX
          POP ECX
          POP EBX
          POP EAX

          LEAVE
          RETN32 8
SYSTEM.SetOr32 ENDP

//(Quell,Ziel)
SYSTEM.SetAnd32 PROC NEAR32
          PUSH EBP
          MOV EBP,ESP

          PUSH EAX
          PUSH EBX
          PUSH ECX
          PUSH EDX
          PUSH ESI
          PUSH EDI

          MOV EDI,[EBP+8]   //Ziel
          MOV ESI,[EBP+12]
          MOV ECX,8
!SAndl:
          MOV EAX,[ESI+0]
          AND EAX,[EDI+0]
          MOV [EDI+0],EAX
          ADD ESI,4
          ADD EDI,4
          LOOP !SAndl

          POP EDI
          POP ESI
          POP EDX
          POP ECX
          POP EBX
          POP EAX

          LEAVE
          RETN32 8
SYSTEM.SetAnd32 ENDP

//(Quell,Ziel)
SYSTEM.SetMinus32 PROC NEAR32
          PUSH EBP
          MOV EBP,ESP

          PUSH EAX
          PUSH EBX
          PUSH ECX
          PUSH EDX
          PUSH ESI
          PUSH EDI

          MOV EDI,[EBP+8]   //Ziel
          MOV ESI,[EBP+12]
          MOV ECX,8
!SMinusl:
          MOV EAX,[ESI+0]
          NOT EAX
          AND EAX,[EDI+0]
          MOV [EDI+0],EAX
          ADD ESI,4
          ADD EDI,4
          LOOP !SMinusl

          POP EDI
          POP ESI
          POP EDX
          POP ECX
          POP EBX
          POP EAX

          LEAVE
          RETN32 8
SYSTEM.SetMinus32 ENDP


END;

//************************************************************************
//
//
// Floating point support
//
//
//************************************************************************

PROCEDURE SetTrigMode(mode:BYTE);
BEGIN
     CASE Mode OF
        Rad:IsNotRad:=FALSE;
        Deg:
        BEGIN
             ToRad:=0.01745329262;
             FromRad:=57.29577951;
             IsNotRad:=TRUE;
        END;
        Gra:                    
        BEGIN
             ToRad:=0.01570796327;
             FromRad:=63.66197724;
             IsNotRad:=TRUE;
        END;
     END; {case}
END;

CONST
    C10:LONGWORD=10;
    {$ifdef win32}
    FPUControl:WORD=$133f;
    FPURound:WORD=$1f3f;
    FPURoundUp:WORD=$1b3f;
    {$else}
    FPUControl:WORD=$1322;  // changed PE
    FPURound:WORD=$1f22;
    FPURoundUp:WORD=$1b22;
    {$endif}
    Exponent:WORD=0;
    fl1:ARRAY[0..3] OF BYTE=(0,$42,$c0,$ff);
    fl2:ARRAY[0..9] OF BYTE=($35,$c2,$68,$21,$a2,$da,$0f,$c9,$fe,$3f); //0.7853...
    fl3:ARRAY[0..9] OF BYTE=($35,$c2,$68,$21,$a2,$da,$0f,$c9,$ff,$3f);
    fl4:ARRAY[0..3] OF BYTE=(0,$4a,$c0,$ff);
    fl5:ARRAY[0..3] OF BYTE=(0,0,0,$3f);
    fl6:ARRAY[0..9] OF BYTE=($85,$64,$de,$f9,$33,$f3,4,$b5,$ff,$3f);
    fl7:ARRAY[0..9] OF BYTE=($48,$7e,$2a,$92,$a2,$da,$0f,$c9,$ff,$3f); //PI/2
    fl8:ARRAY[0..9] OF BYTE=(0,0,0,0,0,0,0,$80,$fe,$3f);  //0.5
    fl9:ARRAY[0..9] OF BYTE=(0,0,0,0,0,0,0,$80,0,$40);    //2.0
    fl10:ARRAY[0..9] OF BYTE=($83,$ab,$4b,$ac,$dd,$8d,$5d,$93,0,$40); //ln(10)
    fl11:ARRAY[0..9] OF BYTE=($7e,$c0,$68,$77,$0d,$18,$72,$b1,$fe,$3f); //ln(2)
    ln2_hi: array[0..7] of byte = ($00, $00, $E0, $FE, $42, $2E, $E6, $3F);
    ln2_lo: array[0..7] of byte = ($76, $3C, $79, $35, $EF, $39, $EA, $3D);

ASSEMBLER

SYSTEM.!FormatStr PROC NEAR32  //Format in AL, String in EDI
        //Format the string
        CMP AL,0
        JE !LLw47_1

        MOV AH,[EDI+0]  //Length of string
        CMP AH,AL
        JAE !LLw47_1    //No format to do

        SUB AL,AH       //Calculate spaces to add
        ADD [EDI+0],AL  //Set length to new value
        PUSH EDI

        MOVZX EBX,AH    //old length of string
        ADD EDI,EBX     //End of string

        MOVZX EBX,AL    //Count of spaces to add
        MOV ESI,EDI
        ADD EDI,EBX     //add count of spaces

        MOVZX ECX,AH    //Count (Length of string) to ECX
        INC ECX         //and #0

        STD             //From backwards
        REP
        MOVSB

        MOV ECX,EBX
        MOV AL,32       //Space

        POP EDI         //Pop it
        PUSH EDI
        INC EDI
        CLD
        REP
        STOSB

        POP EDI
        MOVZXB EAX,[EDI+0]
        INC EDI
        ADD EDI,EAX
        CLD
!LLw47_1:
        RETN32
SYSTEM.!FormatStr ENDP

SYSTEM.!RadArc PROC NEAR32      //Converts ST(0) to Rad
       CMPB SYSTEM.IsNotRad,1
       JNE !!!_l80
       FLDT SYSTEM.ToRad
       FMULP ST(1),ST
!!!_l80:
       RETN32
SYSTEM.!RadArc ENDP

SYSTEM.!NormRad PROC NEAR32     //Converts ST(0) to actual TrigMode
       CMPB SYSTEM.IsNotRad,1
       JNE !!!_l81
       FLDT SYSTEM.FromRad
       FMULP ST(1),ST
!!!_l81:
       RETN32
SYSTEM.!NormRad ENDP


SYSTEM.!Calculate PROC NEAR32
//Input EDI String
//CX Count
//Output Value in ST(0)
         PUSH EBP
         MOV EBP,ESP
         SUB ESP,4
         DB $89,$04,$24   //Perform stack probe MOV [ESP],EAX
!!!weiter1:
         MOV AL,[EDI+0]
         SUB AL,$3a
         ADD AL,$0a
         JNB !!!ex
         XOR AH,AH
         MOV [EBP-2],AX
         FILDD SYSTEM.C10
         FMULP ST(1),ST
         FILDW [EBP-2]
         FADDP ST(1),ST
//         FWAIT
         INC EDI
         DEC CX
         CMP CX,0
         JE !!!ex
         JMP !!!weiter1
!!!ex:
         LEAVE
         RETN32
SYSTEM.!Calculate ENDP

SYSTEM.!DivTab PROC NEAR32
        dw 0,0,0,32768,16383,0,0,0             //1
        dw 0,0,0,40960,16386,0,0,0             //10
        dw 0,0,0,51200,16389,0,0,0             //100
        dw 0,0,0,64000,16392,0,0,0             //1000
        dw 0,0,0,40000,16396,0,0,0             //10^4
        dw 0,0,0,50000,16399,0,0,0             //10^5
        dw 0,0,0,62500,16402,0,0,0             //10^6
        dw 0,0,32768,39062,16406,0,0,0         //10^7
        dw 0,0,8192,48828,16409,0,0,0          //10^8
SYSTEM.!DivTab ENDP

SYSTEM.!Power10Tab PROC NEAR32
           db 0,0,0,0,0,$20,$bc,$be,$19,$40                  //1.0E+8
           db 0,0,0,4,$bf,$c9,$1b,$8e,$34,$40                //1.0E+16
           db $9e,$b5,$70,$2b,$a8,$ad,$c5,$9d,$69,$40        //1.0E+32
           db $d5,$a6,$cf,$0ff,$49,$1f,$78,$c2,$d3,$40       //1.0E+64
           db $e0,$8c,$e9,$80,$c9,$47,$ba,$93,$a8,$41        //1.0E+128
           db $8e,$de,$0f9,$9d,$fb,$eb,$7e,$aa,$51,$43       //1.0E+256
           db $c7,$91,$0e,$a6,$ae,$a0,$19,$e3,$a3,$46        //1.0E+512
           db $17,$0c,$75,$81,$86,$75,$76,$c9,$48,$4d        //1.0E+1024
           db $e5,$5d,$3d,$c5,$5d,$3b,$8b,$9e,$92,$5a        //1.0E+2048
           db $9b,$97,$20,$8a,2,$52,$60,$c4,$25,$75          //1.0E+4096
SYSTEM.!Power10Tab ENDP

SYSTEM.!MaxMulTab PROC NEAR32
           db $9b,$97,$20,$8a,2,$52,$60,$c4,$25,$75          //1.0E+4096
SYSTEM.!MaxMulTab ENDP

SYSTEM.!DivMul10 PROC NEAR32
//Input: BX Count of divides/mult by 10
//       AL 0-mult 1-divide
        MOV CX,BX
        AND CX,7  //31 only values 0..31
        MOV ESI,@SYSTEM.!DivTab
        MOVZX ECX,CX
        SHL ECX,1
        SHL ECX,1
        SHL ECX,1
        SHL ECX,1
        ADD ESI,ECX
        FLDT [ESI+0]   //1..10^32 laden
        SHR BX,1
        SHR BX,1
        SHR BX,1                //divide numbers by 8
        MOV ESI,@SYSTEM.!Power10Tab
        CMP BX,0
        JE !!!process
!!!Power10:
        SHR BX,1
        JNB !!!mm            //until a bit is set
        FLDT [ESI+0]
        FMULP ST(1),ST
!!!mm:
        ADD ESI,10
        CMP BX,0
        JNE !!!Power10
!!!process:
        CMP AL,1
        JNE !!!_mul
        FDIVRP ST(1),ST
        RETN32
!!!_mul:
        FMULP ST(1),ST
        RETN32
SYSTEM.!DivMul10 ENDP

SYSTEM.!Str2Float PROC NEAR32
//Input EDI  String to convert
//      CX     Length of this string
//Output Floating point value in ST(0)
        PUSH EBP
        MOV EBP,ESP
        SUB ESP,6                //for Control word and sign
        DB $89,$04,$24           //Perform stack probe MOV [ESP],EAX

        MOVW SYSTEM.FPUResult,0
        FSTCW [EBP-2]            //Store control word
        FWAIT
        FCLEX                    //Clear exceptions
        FLDCW SYSTEM.FPUControl  //Load control word
        FWAIT
        FLDZ                     //Load +0.0
        MOVB [EBP-4],0           //sign is positive
        MOVW [EBP-6],0           //count of numbers after point
!!!again:
        CMP CX,0                 //String has zero length ?
        JE !!!Error

        MOV AL,[EDI+0]        //load character
        CMP AL,43  //'+'
        JNE !!!not_plus
        //Sign '+' was detected
        INC EDI
        DEC CX
        CMP CX,0
        JE !!!Error
        JMP !!!weiter
!!!not_plus:
        CMP AL,45   //'-'
        JNE !!!not_minus
        //Sign '-' was detected
        MOVB [EBP-4],1 //Sign is negative
        INC EDI
        DEC CX
        CMP CX,0
        JE !!!Error
        JMP !!!weiter
!!!not_minus:
        CMP AL,32
        JNE !!!weiter
        INC EDI
        DEC CX
        JMP !!!again
!!!weiter:
        CALLN32 SYSTEM.!Calculate   //Calculate numbers before point
        CMP CX,0
        JNE !!!a_exp
        CMPB [EBP-4],1
        JNE !!!no_exp
        FCHS
        FWAIT         //change sign
        JMP !!!no_exp
!!!a_exp:
        //Look for .
        MOV AL,[EDI+0]
        CMP AL,'.'
        JNE !!!Change
        DEC CX
        CMP CX,0
        JE !!!Change
        INC EDI
        PUSH CX
        CALLN32 SYSTEM.!Calculate    //Calculate numbers after point
        POP BX
        SUB BX,CX
        MOV [EBP-6],BX               //Count of numbers after point
!!!Change:
        //in ST(0) is now an integer value
        //[EBP-6] contains the current numbers after the point
        CMPB [EBP-4],1
        JNE !!!not_neg
        FCHS
        FWAIT         //change sign
!!!not_neg:
        //Check for exponent
        CMP CX,0
        JE !!!no_exp
        MOV AL,[EDI+0]
        CMP AL,'e'
        JE !!!exp
        CMP AL,'E'
        JNE !!!no_exp
!!!exp:
        //an exponent was detected
        INC EDI
        DEC CX
        CMP CX,0
        JE !!!Error
        FLDZ          //Load +0.0
        MOVB [EBP-4],0    //sign is positive
        MOV AL,[EDI+0]
        CMP AL,'-'
        JNE !!!no_minus
        MOVB [EBP-4],1   //sign is negative
        INC EDI
        DEC CX
        CMP CX,0
        JE !!!Error
        JMP !!!Calc
!!!no_minus:
        CMP AL,43   //'+'
        JNE !!!calc
        INC EDI
        DEC CX
        CMP CX,0
        JE !!!Error
!!!calc:
        CALLN32 SYSTEM.!Calculate
        FISTPW SYSTEM.Exponent      //Store integer value and pop
        MOV BX,SYSTEM.Exponent
        MOV AL,0                    //Mult
        CMPB [EBP-4],1
        JNE !!!make
        MOV AL,1                    //Divide if Exponent negative
!!!make:
        PUSH CX
        CALLN32 SYSTEM.!DivMul10
        POP CX
!!!no_exp:
        CMP CX,0
        JNE !!!Error                //invalid chars
        MOV BX,[EBP-6]
        MOV AL,1                    //Divide
        CALLN32 SYSTEM.!DivMul10
        JMP !!!ok
!!!Error:
        MOVW SYSTEM.InOutRes,1      //FPU error
        MOVW SYSTEM.FPUResult,1     //FPU error
!!!ok:
        LEAVE
        RETN32
SYSTEM.!Str2Float ENDP

SYSTEM.!Str2Real PROC NEAR32
       PUSH EBP
       MOV EBP,ESP

       PUSH EAX
       PUSH EBX
       PUSH ECX
       PUSH EDX
       PUSH EDI
       PUSH ESI

       MOV EDI,[EBP+16]
       MOV CL,[EDI+0]
       INC EDI
       XOR CH,CH
       CALLN32 SYSTEM.!Str2Float
       MOV EDI,[EBP+12]
       FSTPD [EDI+0]

       MOV EDI,[EBP+8]      //Result
       MOVW [EDI+0],0
       CMPW SYSTEM.FPUResult,0
       JE !!__fex1
       MOV ESI,[EBP+16]
       MOVZXB AX,[ESI+0]
       INC AX
       SUB AX,CX
       MOV [EDI+0],AX
       MOV EDI,[EBP+12]
       FLDZ
       FSTPD [EDI+0]
!!__fex1:
       POP ESI
       POP EDI
       POP EDX
       POP ECX
       POP EBX
       POP EAX

       LEAVE
       RETN32 12
SYSTEM.!Str2Real ENDP

SYSTEM.!Str2Double PROC NEAR32
       PUSH EBP
       MOV EBP,ESP

       PUSH EAX
       PUSH EBX
       PUSH ECX
       PUSH EDX
       PUSH EDI
       PUSH ESI

       MOV EDI,[EBP+16]
       MOV CL,[EDI+0]
       INC EDI
       XOR CH,CH
       CALLN32 SYSTEM.!Str2Float
       MOV EDI,[EBP+12]
       FSTPQ [EDI+0]

       MOV EDI,[EBP+8]     //Result
       MOVW [EDI+0],0
       CMPW SYSTEM.FPUResult,0
       JE !!__fex11
       MOV ESI,[EBP+16]
       MOVZXB AX,[ESI+0]
       INC AX
       SUB AX,CX
       MOV [EDI+0],AX
       MOV EDI,[EBP+12]
       FLDZ
       FSTPQ [EDI+0]
!!__fex11:
       POP ESI
       POP EDI
       POP EDX
       POP ECX
       POP EBX
       POP EAX

       LEAVE
       RETN32 12
SYSTEM.!Str2Double ENDP

SYSTEM.!Str2Comp PROC NEAR32
       PUSH EBP
       MOV EBP,ESP

       PUSH EAX
       PUSH EBX
       PUSH ECX
       PUSH EDX
       PUSH EDI
       PUSH ESI

       MOV EDI,[EBP+16]
       MOV CL,[EDI+0]
       INC EDI
       XOR CH,CH
       CALLN32 SYSTEM.!Str2Float
       MOV EDI,[EBP+12]
       FISTP QWORD PTR [EDI+0]

       MOV EDI,[EBP+8]     //Result
       MOVW [EDI+0],0
       CMPW SYSTEM.FPUResult,0
       JE !!__fex11_c
       MOV ESI,[EBP+16]
       MOVZXB AX,[ESI+0]
       INC AX
       SUB AX,CX
       MOV [EDI+0],AX
       MOV EDI,[EBP+12]
       FLDZ
       FISTP QWORD PTR [EDI+0]
!!__fex11_c:
       POP ESI
       POP EDI
       POP EDX
       POP ECX
       POP EBX
       POP EAX

       LEAVE
       RETN32 12
SYSTEM.!Str2Comp ENDP

SYSTEM.!Str2Currency PROC NEAR32
       PUSH EBP
       MOV EBP,ESP

       PUSH EAX
       PUSH EBX
       PUSH ECX
       PUSH EDX
       PUSH EDI
       PUSH ESI

       MOV EDI,[EBP+16]
       MOV CL,[EDI+0]
       INC EDI
       XOR CH,CH
       CALLN32 SYSTEM.!Str2Float
       MOV EDI,[EBP+12]
       FLDT SYSTEM.ToCurrency   //*10000
       FMULP ST(1),ST
       FRNDINT
       FISTP QWORD PTR [EDI+0]

       MOV EDI,[EBP+8]     //Result
       MOVW [EDI+0],0
       CMPW SYSTEM.FPUResult,0
       JE !!__fex11_c
       MOV ESI,[EBP+16]
       MOVZXB AX,[ESI+0]
       INC AX
       SUB AX,CX
       MOV [EDI+0],AX
       MOV EDI,[EBP+12]
       FLDZ
       FISTP QWORD PTR [EDI+0]
!!__fex11_c:
       POP ESI
       POP EDI
       POP EDX
       POP ECX
       POP EBX
       POP EAX

       LEAVE
       RETN32 12
SYSTEM.!Str2Currency ENDP


SYSTEM.!Str2Extended PROC NEAR32
       PUSH EBP
       MOV EBP,ESP

       PUSH EAX
       PUSH EBX
       PUSH ECX
       PUSH EDX
       PUSH EDI
       PUSH ESI

       MOV EDI,[EBP+16]
       MOV CL,[EDI+0]
       INC EDI
       XOR CH,CH
       CALLN32 SYSTEM.!Str2FLoat
       MOV EDI,[EBP+12]
       FSTPT [EDI+0]

       MOV EDI,[EBP+8]   //Result
       MOVW [EDI+0],0
       CMPW SYSTEM.FPUResult,0
       JE !!__fex111
       MOV ESI,[EBP+16]
       MOVZXB AX,[ESI+0]
       INC AX
       SUB AX,CX
       MOV [EDI+0],AX
       MOV EDI,[EBP+12]
       FLDZ
       FSTPT [EDI+0]
!!__fex111:
       POP ESI
       POP EDI
       POP EDX
       POP ECX
       POP EBX
       POP EAX

       LEAVE
       RETN32 12
SYSTEM.!Str2Extended ENDP

SYSTEM.!ValReal PROC NEAR32
        //Input EDI : Destination String
        //AX Kommastellen
        //BX Len oder 17h
        //Floatvalue in ST(0)
        PUSH EBP
        MOV EBP,ESP
        SUB ESP,264
        DB $89,$04,$24   //Perform stack probe MOV [ESP],EAX

        MOV [EBP-260],AX  //Comma
        CMP BX,0
        JA !!6666
        MOV BX,1
!!6666:
        CMP BX,254    //$17
        JB !!6666_1
        MOV BX,$17
!!6666_1:
        MOV [EBP-258],BX  //Len
        MOV [EBP-264],EDI //s

        MOV CX,[EBP-260]  //Comma
        OR CX,CX
        JNS !!37ea
        MOV CX,8
        SUB CX,[EBP-258]  //Len
        CMP CX,$0FFFE
        JLE !!37ea
        MOV CX,$0FFFE
!!37ea:
        LEA EDI,[EBP-256] //result
        CALLN32 SYSTEM.!Real2Str1  //Get string in EDI and length in CX

        MOV ESI,EDI
        MOV EDI,[EBP-264]  //s
        MOV DX,255
        MOV AX,[EBP-258]   //Len
        CMP AX,CX
        JNL !!3812
        MOV AX,CX
!!3812:
        CLD
        STOSB
        SUB AX,CX
        JE !!3820
        PUSH CX
        MOVZX ECX,AX
        MOV AL,$20
        REP
        STOSB
        POP CX
!!3820:
        MOVZX ECX,CX
        REP
        MOVSB

        LEAVE
        RETN32
SYSTEM.!ValReal ENDP

SYSTEM.!!!!!Help1 PROC NEAR32
        FWAIT
        FSTCW [EBP-2]
        FWAIT
        FCLEX
        FLDCW SYSTEM.FpuControl
        FWAIT
        FSTPT [EBP-$14]

        XOR EDX,EDX
        CMP CX,$12
        JLE !!311a
        MOV CX,$12
!!311a:
        CMP CX,$0FFEE
        JNL !!3122
        MOV CX,$0FFEE
!!3122:
        RETN32
SYSTEM.!!!!!Help1 ENDP

SYSTEM.!!!!!Help2 PROC NEAR32
        MOV [EBP-$0c],AX
        FLDT [EBP-$14]
        SUB AX,$3FFF
        XOR EDX,EDX
        MOV DX,$4D10
        IMUL DX
        MOV [EBP-8],DX
        MOV AX,$11
        SUB AX,DX
        CALLN32 SYSTEM.!Div_Mul10
        FRNDINT
        MOV ESI,*Tabx1
        FLDT [ESI+0]
        FCOMP ST(1)
        FSTSW [EBP-4]
        FWAIT
        RETN32
Tabx1:
     db 0,0,$40,$76,$3a,$6b,$0b,$de,$3a,$40
SYSTEM.!!!!!Help2 ENDP

SYSTEM.!!!!!Help3 PROC NEAR32
        MOV AL,$45
        CLD
        STOSB
        MOV AL,$2b
        MOV DX,[EBP-8]
        OR DX,DX
        JNS !!3280
        MOV AL,$2d
        NEG DX
!!3280:
        STOSB
        MOV EAX,$640a
        XCHG DX,AX
        DIV DH
        MOV DH,AH
        DB $66
        CBW
        DIV DL
        ADD AX,$3030
        STOSW
        MOV AL,DH
        DB $66
        CBW
        DIV DL
        ADD AX,$3030
        STOSW
        RETN32
SYSTEM.!!!!!Help3 ENDP

SYSTEM.!Real2Str1 PROC NEAR32
        PUSH EBP
        MOV EBP,ESP
        SUB ESP,$28
        DB $89,$04,$24   //Perform stack probe MOV [ESP],EAX

        PUSH EDI
        CALLN32 SYSTEM.!!!!!Help1

        CLD
        NOP
        FWAIT
        MOV [EBP-6],CX
        MOV AX,[EBP-$0c]
        MOV [EBP-$0a],AX
        AND AX,$7FFF
        JE !!315c
        CMP AX,$7FFF
        JNE !!3165
        CMPW [EBP-$0e],$8000
        JE !!3149
        MOV AX,$414e
        STOSW
        MOV AL,$4e
        STOSB
        JMP !!3299
!!3149:
        CMPW [EBP-$0a],0
        JNS !!3152
        MOV AL,$2d
        STOSB
!!3152:
        MOV AX,$4e49
        STOSW
        MOV AL,$46
        STOSB
        JMP !!3299
!!315c:
        MOV [EBP-8],AX
        MOV [EBP-$28],AL
        JMP !!3216
!!3165:
        CALLN32 SYSTEM.!!!!!Help2
        TESTW [EBP-4],$4100
        JE !!31a1
        INCW [EBP-8]
        FILDD SYSTEM.C10
        FDIVRP ST(1),ST
!!31a1:
        PUSH EBP
        POP ESI
        FBSTPT [ESI-$14]
        MOV ESI,9
        LEA EBX,[EBP-$28]
        MOV CL,4
        FWAIT
!!31af:
        PUSH EDI
        LEA EDI,[EBP-$15]
        ADD EDI,ESI
        MOV AL,[EDI+0]
        POP EDI
        MOV AH,AL
        SHR AL,CL
        AND AH,$0F
        ADD AX,$3030
        MOV [EBX+0],AX
        ADD EBX,2
        DEC ESI
        JNE !!31af

        MOV [EBX+0],SI
        CMPW [EBP-6],0
        JL !!31d8
        CMPW [EBP-8],$24
        JL !!31d8
        MOVW [EBP-6],$0FFEE
!!31d8:
        MOV SI,[EBP-6]
        OR SI,SI
        JS !!31eb
        ADD SI,[EBP-8]
        INC SI
        JNS !!31ed
        MOVB [EBP-$28],0
        JMP !!3216
!!31eb:
        NEG SI
!!31ed:
        CMP SI,$12
        JNB !!3216

        MOVZX ESI,SI
        PUSH EDI
        LEA EDI,[EBP-$28]
        ADD EDI,ESI
        CMPB [EDI+0],$35
        MOVB [EDI+0],0
        POP EDI
        JB !!3216
!!31fc:
        DEC SI
        JS !!320e
        MOVZX ESI,SI
        PUSH EDI
        LEA EDI,[EBP-$28]
        ADD EDI,ESI
        INCB [EDI+0]
        CMPB [EDI+0],$39
        POP EDI
        JBE !!3216

        PUSH EDI
        LEA EDI,[EBP-$28]
        ADD EDI,ESI
        MOVB [EDI+0],0
        POP EDI
        JMP !!31fc
!!320e:
        INCW [EBP-8]
        MOVW [EBP-$28],$31
!!3216:
        XOR ESI,ESI
        MOV DX,[EBP-6]
        OR DX,DX
        JS !!3254
        CMPW [EBP-$0a],0
        JNS !!3228
        MOV AL,$2d
        STOSB
!!3228:
        MOV CX,[EBP-8]
        OR CX,CX
        JNS !!3234
        MOV AL,$30
        STOSB
        JMP !!323b
!!3234:
        PUSH EDI
        MOVZX ESI,SI
        LEA EDI,[EBP-$28]
        ADD EDI,ESI
        MOV AL,[EDI+0]
        INC SI
        POP EDI
        OR AL,AL
        JNE !!32b6
        MOV AL,$30
        DEC SI
!!32b6:
        STOSB
        DEC CX
        JNS !!3234
!!323b:
        OR DX,DX
        JE !!3299
        MOV AL,$2e
        STOSB
!!3242:
        INC CX
        JE !!324b
!!3245:
        MOV AL,$30
        STOSB
        DEC DX
        JNE !!3242
!!324b:
        DEC DX
        JS !!3299
        PUSH EDI
        MOVZX ESI,SI
        LEA EDI,[EBP-$28]
        ADD EDI,ESI
        MOV AL,[EDI+0]
        INC SI
        POP EDI
        OR AL,AL
        JNE !!32b6_1a
        MOV AL,$30
        DEC SI
!!32b6_1a:
        STOSB
        JMP !!324b
!!3254:
        MOV AL,$20
        CMPW [EBP-$0a],0
        JNS !!325e
        MOV AL,$2d
!!325e:
        STOSB
        PUSH EDI
        MOVZX ESI,SI
        LEA EDI,[EBP-$28]
        ADD EDI,ESI
        INC SI
        MOV AL,[EDI+0]
        POP EDI
        OR AL,AL
        JNE !!32b6_1b
        MOV AL,$30
        DEC SI
!!32b6_1b:
        STOSB
        INC DX
        JE !!3270
        MOV AL,$2e
        STOSB
!!3269:
        PUSH EDI
        MOVZX ESI,SI
        LEA EDI,[EBP-$28]
        ADD EDI,ESI
        INC SI
        MOV AL,[EDI+0]
        POP EDI
        OR AL,AL
        JNE !!32b6_1c
        MOV AL,$30
        DEC SI
!!32b6_1c:
        STOSB
        INC DX
        JNE !!3269
!!3270:
        CALLN32 SYSTEM.!!!!!Help3
!!3299:
        MOV ECX,EDI
        POP EDI
        SUB ECX,EDI
        FCLEX            //Clear Exceptions
        FLDCW [EBP-2]
        FWAIT
        LEAVE
        RETN32
{*Tab1:
     db 0,0,40h,76h,3ah,6bh,0bh,deh,3ah,40h}
SYSTEM.!Real2Str1 ENDP


SYSTEM.!Div_Mul10 PROC NEAR32
        CMP AX,$1000
        JLE !!3382
        PUSH ESI
        MOV ESI,@SYSTEM.!MaxMulTab
        FLDT [ESI+0]
        POP ESI
        FMULP ST(1),ST
        SUB AX,$1000
!!3382:
        CMP AX,$0F000
        JNL !!3393
        PUSH ESI
        MOV ESI,@SYSTEM.!MaxMulTab
        FLDT [ESI+0]
        POP ESI
        FDIVRP ST(1),ST
        ADD AX,$1000
!!3393:
        MOV BX,AX
        OR AX,AX
        JE !!33d4
        JNS !!339d
        NEG AX
!!339d:
        MOV SI,AX
        AND SI,7
        MOVZX ESI,SI
        SHL ESI,1
        SHL ESI,1
        SHL ESI,1
        SHL ESI,1
        PUSH EDI
        MOV EDI,@SYSTEM.!DivTab
        ADD EDI,ESI
        FLDT [EDI+0]
        POP EDI
        SHR AX,1
        SHR AX,1
        SHR AX,1
        MOV ESI,@SYSTEM.!Power10Tab
        JMP !!33c5
!!33b7:
        SHR AX,1
        JNB !!33c2
        FLDT [ESI+0]
        FMULP ST(1),ST
!!33c2:
        ADD ESI,10
!!33c5:
        OR AX,AX
        JNE !!33b7
        OR BX,BX
        JS !!33d1
        FMULP ST(1),ST
!!33d0:
        RETN32
!!33d1:
        FDIVRP ST(1),ST
!!33d4:
        RETN32
SYSTEM.!Div_Mul10 ENDP


SYSTEM.!Real2Str PROC NEAR32  //Format in [EBP+16]
        PUSH EBP
        MOV EBP,ESP

        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        MOV EDI,[EBP+12]
        FLDD [EDI+0]        //Load real value
        MOV EDI,[EBP+8]
        MOV EAX,[EBP+16]    //Nachkommastellen  (FFFFh alle)
        MOVZXB EBX,[EBP+20] //Format value
        CALLN32 SYSTEM.!ValReal

        MOV AL,[EBP+20]    //Format value
        MOV EDI,[EBP+8]
        CALLN32 SYSTEM.!FormatStr

        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI

        LEAVE
        RETN32 16
SYSTEM.!Real2Str ENDP

SYSTEM.!Double2Str PROC NEAR32  //Format in [EBP+16]
        PUSH EBP
        MOV EBP,ESP

        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        MOV EDI,[EBP+12]
        FLDQ [EDI+0]        //Load double value
        MOV EDI,[EBP+8]
        MOV EAX,[EBP+16]    //Nachkommastellen (FFFFh alle)
        MOV EBX,[EBP+20]    //Format value
        CALLN32 SYSTEM.!ValReal

        MOV AL,[EBP+20]     //Format value
        MOV EDI,[EBP+8]
        CALLN32 SYSTEM.!FormatStr

        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI

        LEAVE
        RETN32 16
SYSTEM.!Double2Str ENDP

SYSTEM.!Comp2Str PROC NEAR32  //Format in [EBP+16]
        PUSH EBP
        MOV EBP,ESP

        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        MOV EBX,[EBP+20]
        CMP EBX,23
        JNE !not_23
        MOVD [EBP+20],1
!not_23:
        MOV EDI,[EBP+12]
        FILD QWORD PTR [EDI+0]        //Load comp value
        MOV EDI,[EBP+8]
        MOV EAX,0                     //keine Nachkommas
        MOV EBX,[EBP+20]              //Format value
        CALLN32 SYSTEM.!ValReal

        MOV AL,[EBP+20]              //Format value
        MOV EDI,[EBP+8]
        CALLN32 SYSTEM.!FormatStr

        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI

        LEAVE
        RETN32 16
SYSTEM.!Comp2Str ENDP

SYSTEM.!Currency2Str PROC NEAR32  //Format in [EBP+16]
        PUSH EBP
        MOV EBP,ESP

        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        MOV EBX,[EBP+20]
        CMP EBX,23
        JNE !not_23
        MOVD [EBP+20],1
!not_23:
        MOV EDI,[EBP+12]
        FILD QWORD PTR [EDI+0]        //Load currency value
        FRNDINT
        FLDT SYSTEM.FromCurrency  //*0.0001
        FMULP ST(1),ST
        MOV EDI,[EBP+8]
        MOV EAX,4                     //vier Nachkommas
        MOV EBX,[EBP+20]              //Format value
        CALLN32 SYSTEM.!ValReal

        MOV AL,[EBP+20]              //Format value
        MOV EDI,[EBP+8]
        CALLN32 SYSTEM.!FormatStr

        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI

        LEAVE
        RETN32 16
SYSTEM.!Currency2Str ENDP


SYSTEM.!Extended2Str PROC NEAR32  //Format in [EBP+16]
        PUSH EBP
        MOV EBP,ESP

        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        MOV EDI,[EBP+12]
        FLDT [EDI+0]       //Load extended value
        MOV EDI,[EBP+8]
        MOV EAX,[EBP+16]   //Nachkommastellen (FFFFh alle)
        MOV EBX,[EBP+20]   //Format value
        CALLN32 SYSTEM.!ValReal

        MOV AL,[EBP+20]    //Format value
        MOV EDI,[EBP+8]
        CALLN32 SYSTEM.!FormatStr

        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI

        LEAVE
        RETN32 16
SYSTEM.!Extended2Str ENDP

SYSTEM.!Extended2StrReg PROC NEAR32  //Format in [EBP+12], extended value in ST(0)
        PUSH EBP
        MOV EBP,ESP

        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        MOV EDI,[EBP+8]
        MOV EAX,[EBP+12]   //Nachkommastellen (FFFFh alle)
        MOV EBX,[EBP+16]   //Format value
        CALLN32 SYSTEM.!ValReal

        MOV AL,[EBP+16]    //Format value
        MOV EDI,[EBP+8]
        CALLN32 SYSTEM.!FormatStr

        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI

        LEAVE
        RETN32 12
SYSTEM.!Extended2StrReg ENDP

SYSTEM.!WriteExtended PROC NEAR32   //Writes extended in ST
          PUSH EBP
          MOV EBP,ESP
          SUB ESP,260
          DB $89,$04,$24   //Perform stack probe MOV [ESP],EAX
          FSTPT [EBP-260]

          PUSH DWORD PTR [EBP+12]     //Format
          PUSH DWORD PTR [EBP+8]      //Nachkommas
          LEA EAX,[EBP-260]
          PUSH EAX
          LEA EAX,[EBP-250]
          PUSH EAX
          CALLN32 SYSTEM.!Extended2Str

          LEA EAX,[EBP-250]
          PUSH EAX
          PUSHL 0                //[EBP+8]  ???     //Format value
          CALLN32 SYSTEM.StrWrite

          LEAVE
          RETN32 8
SYSTEM.!WriteExtended ENDP

SYSTEM.!WriteCurrency PROC NEAR32   //Writes currency in ST
          PUSH EBP
          MOV EBP,ESP
          SUB ESP,260
          DB $89,$04,$24   //Perform stack probe MOV [ESP],EAX
          FRNDINT
          FLDT SYSTEM.FromCurrency
          FMULP ST(1),ST
          FSTPT [EBP-260]

          MOV EAX,[EBP+12]
          CMP EAX,23
          JNE !CurFOk
          CMPD [EBP+8],4
          JBE !CurFOk
          MOV EAX,0
!CurFOk:
          PUSH EAX
          MOV EAX,[EBP+8]             //Nachkommas
          CMP EAX,4
          JBE !CurCOk
          MOV EAX,4
!CurCOk:
          PUSH EAX
          LEA EAX,[EBP-260]
          PUSH EAX
          LEA EAX,[EBP-250]
          PUSH EAX
          CALLN32 SYSTEM.!Extended2Str

          LEA EAX,[EBP-250]
          PUSH EAX
          PUSHL 0                //[EBP+8]  ???     //Format value
          CALLN32 SYSTEM.StrWrite

          LEAVE
          RETN32 8
SYSTEM.!WriteCurrency ENDP


SYSTEM.!WriteComp PROC NEAR32   //Writes extended in ST
          PUSH EBP
          MOV EBP,ESP
          SUB ESP,260
          DB $89,$04,$24   //Perform stack probe MOV [ESP],EAX
          FISTP QWORD PTR [EBP-260]

          PUSH DWORD PTR [EBP+12]     //Format
          PUSHL 0                     //keine Nachkommas
          LEA EAX,[EBP-260]
          PUSH EAX
          LEA EAX,[EBP-250]
          PUSH EAX
          CALLN32 SYSTEM.!Comp2Str

          LEA EAX,[EBP-250]
          PUSH EAX
          PUSHL 0                //[EBP+8]  ???     //Format value
          CALLN32 SYSTEM.StrWrite

          LEAVE
          RETN32 8
SYSTEM.!WriteComp ENDP

SYSTEM.!FPULoadLong PROC NEAR32
            PUSH EBP
            MOV EBP,ESP
            FILDD [EBP+8]
            LEAVE
            RETN32 4
SYSTEM.!FPULoadLong ENDP


SYSTEM.!Sin PROC NEAR32   //calculate SIN in ST(0)
    CALLN32 SYSTEM.!RadArc
    FSIN
    RETN32
SYSTEM.!Sin ENDP

SYSTEM.!Cos PROC NEAR32   //calculate COS in ST(0)
    CALLN32 SYSTEM.!RadArc
    FCOS
    RETN32
SYSTEM.!Cos ENDP

SYSTEM.!Tan PROC NEAR32  // changed PE
    CALLN32 SYSTEM.!RadArc
    FSINCOS
    fdivrp st(1),st(0)   //Compiler-Bug: fdivp wre korrekt, wird vom Compiler aber vertauscht! PE
    RETN32
SYSTEM.!Tan ENDP

SYSTEM.!Cot PROC NEAR32 // changed PE
    CALLN32 SYSTEM.!RadArc
    FSINCOS
    fdivp st(1),st(0)   //Compiler-Bug: fdivrp wre korrekt, wird vom Compiler aber vertauscht! PE
    RETN32
SYSTEM.!Cot ENDP

SYSTEM.!ArcTan PROC NEAR32 // changed PE
  fld1
  fpatan
  CALLN32 SYSTEM.!NormRad
  retn32
SYSTEM.!ArcTan ENDP

SYSTEM.!Sqrt PROC NEAR32
       FSQRT
       RETN32
SYSTEM.!Sqrt ENDP

SYSTEM.!ln PROC NEAR32 //changed PE
  fldln2
  fxch st(1)
  fyl2x
  retn32
SYSTEM.!ln ENDP

SYSTEM.!Exp PROC NEAR32          // changed PE
        Push EBP
        MOV EBP,ESP
        Sub ESP,2
        fldl2e                   // log2(e) x
        fmul st, st(1)           // z = x * log2(e) x
        FSTCW [EBP-2]            // Store control word
        FWAIT
        FLDCW SYSTEM.FPURound    // Load control word
        FWAIT
        FRNDINT                  // int(z) x
        FCLEX
        FLDCW [EBP-2]            // Load control word
        FWAIT
        fld qword ptr [ln2_hi]   // ln2_hi int(z) x
        fmul st, st(1)           // int(z)*ln2_hi int(z) x
        fsubp st(2), st          // int(z) x-int(z)*ln2_hi
        fld qword ptr [ln2_lo]   // ln2_lo int(z) x-int(z)*ln2_hi
        fmul st, st(1)           // int(z)*ln2_lo int(z) x-int(z)*ln2_hi
        fsubp st(2), st          // int(z) (x-int(z)*ln2_hi)-int(z)*ln2_lo
        fxch st(1)               // (x-int(z)*ln2_hi)-int(z)*ln2_lo int(z)
        fldl2e                   // log2(e) (x-int(z)*ln2_hi)-int(z)*ln2_lo int(z)
        fmulp st(1), st          // frac(z) int(z)
        f2xm1                    // 2^frac(z)-1 int(z)
        fld1                     // 1 2^frac(z)-1 int(z)
        faddp st(1), st          // 2^frac(z) int(z)
        fscale                   // 2^z int(z)
        fstp st(1)               // 2^z = e^x
        LEAVE
        RETN32
SYSTEM.!Exp ENDP

SYSTEM.!Frac PROC NEAR32     // changed PE
      Push EBP
      MOV EBP,ESP
      Sub ESP,2
      fld st(0)
      FSTCW [EBP-2]
      FWAIT
      FLDCW SYSTEM.FPURound  //Load control word
      FWAIT
      FRNDINT
      FCLEX
      FLDCW [EBP-2] //Load control word
      FWAIT
      FSUBP ST(1),ST
      Leave
      retn32
SYSTEM.!Frac ENDP

SYSTEM.!Int PROC NEAR32
      Push EBP
      MOV EBP,ESP
      Sub ESP,2
      FSTCW [EBP-2]
      FCLEX
      FWAIT
      FLDCW SYSTEM.FPURound  //Load control word
      FWAIT
      FRNDINT
      FCLEX
      FLDCW [EBP-2] //Load control word
      FWAIT
      LEAVE
      RETN32
SYSTEM.!Int ENDP

SYSTEM.!Round PROC NEAR32 // changed PE
      fld st(0)
      CALLN32 SYSTEM.!Frac
      FADDP ST(1),ST
      CALLN32 SYSTEM.!Trunc
      RETN32
SYSTEM.!Round ENDP

SYSTEM.!Trunc PROC NEAR32  // changed PE
      PUSH EBP
      MOV EBP,ESP
      SUB ESP,12
      DB $89,$04,$24   //Perform stack probe MOV [ESP],EAX
      FSTCW [EBP-12]
      FCLEX
      FLDCW SYSTEM.FPURound  //Load control word
      FWAIT
      FRNDINT
      FCLEX
      FLDCW [EBP-12] //Load control word
      FWAIT
      FISTPD [EBP-10]
      MOV EAX,[EBP-10]
      LEAVE
      RETN32
SYSTEM.!Trunc ENDP

SYSTEM.!Sqr PROC NEAR32
      FLD St(0)
      FMULP ST(1),ST
      RETN32
SYSTEM.!Sqr ENDP

SYSTEM.!ArcSin PROC NEAR32 // changed PE
  fld st(0)
  fld st(0)
  fmulp st(1), st(1)
  fld1
  fsubrp st(1),st(0)
  fsqrt
  fdivrp st(1),st(0)
  fld1
  fpatan
  CALLN32 SYSTEM.!NormRad
  retn32
SYSTEM.!ArcSin ENDP

SYSTEM.!ArcCos PROC NEAR32
       CALLN32 SYSTEM.!ArcSin
       FLDT SYSTEM.fl7   //PI/2
       FXCH ST(1)
       FSUBP ST(1),ST
       CALLN32 SYSTEM.!NormRad
       RETN32
SYSTEM.!ArcCos ENDP

SYSTEM.!ArcCot PROC NEAR32
       CALLN32 SYSTEM.!ArcTan
       FLDT SYSTEM.fl7   //PI/2
       FXCH ST(1)
       FSUBP ST(1),ST
       CALLN32 SYSTEM.!NormRad
       RETN32
SYSTEM.!ArcCot ENDP

SYSTEM.!Sinh PROC NEAR32
       CALLN32 SYSTEM.!Exp
       FLD St(0)
       FLD1
       FXCH ST(1)
       FDIVRP ST(1),ST
//       FXCH ST(1) // Compiler-Bug in RP // PE
       FSUBP ST(1),ST
       FLDT SYSTEM.fl8
       FMULP ST(1),ST
       RETN32
SYSTEM.!Sinh ENDP

SYSTEM.!Cosh PROC NEAR32
       CALLN32 SYSTEM.!Exp
       FLD St(0)
       FLD1
       FXCH ST(1)
       FDIVRP ST(1),ST
       FADDP ST(1),ST
       FLDT SYSTEM.fl8
       FMULP ST(1),ST
       RETN32
SYSTEM.!Cosh ENDP

SYSTEM.!Tanh PROC NEAR32
       FLDT SYSTEM.fl9   //2.0
       FMULP ST(1),ST
       CALLN32 SYSTEM.!Exp
       FLD1
       FADDP ST(1),ST
       FLDT SYSTEM.fl9   //2.0
       FDIVP ST(1),ST  // changed PE
       FLD1
       FSUBRP ST(1),ST // changed PE
       RETN32
SYSTEM.!Tanh ENDP

SYSTEM.!Coth PROC NEAR32 // changed PE
       fld st(0)
       CALLN32 SYSTEM.!Sinh
       fxch st(1)
       CALLN32 SYSTEM.!Cosh
       fdivp st(1),st
       retn32
SYSTEM.!Coth ENDP

SYSTEM.!lg PROC NEAR32
       fld1
       fldl2t
       fdivrp st(1),st
       fxch st(1)
       FYL2X
       retn32
SYSTEM.!lg ENDP

SYSTEM.!lb PROC NEAR32  // changed PE
       fld1
       fxch st(1)
       FYL2X
       retn32
SYSTEM.!lb ENDP

SYSTEM.!ReadReal PROC NEAR32
       PUSH EBP
       MOV EBP,ESP
       SUB ESP,262
       DB $89,$04,$24   //Perform stack probe MOV [ESP],EAX
       LEA EAX,[EBP-260]
       PUSH EAX
       CALLN32 SYSTEM.StrRead
       LEA EAX,[EBP-260]
       PUSH EAX
       PUSH DWORD PTR [EBP+8]
       LEA EAX,[EBP-262]
       PUSH EAX
       CALLN32 SYSTEM.!Str2Real
       LEAVE
       RETN32 4
SYSTEM.!ReadReal ENDP

SYSTEM.!ReadDouble PROC NEAR32
       PUSH EBP
       MOV EBP,ESP
       SUB ESP,262
       DB $89,$04,$24   //Perform stack probe MOV [ESP],EAX
       LEA EAX,[EBP-260]
       PUSH EAX
       CALLN32 SYSTEM.StrRead
       LEA EAX,[EBP-260]
       PUSH EAX
       PUSH DWORD PTR [EBP+8]
       LEA EAX,[EBP-262]
       PUSH EAX
       CALLN32 SYSTEM.!Str2Double
       LEAVE
       RETN32 4
SYSTEM.!ReadDouble ENDP

SYSTEM.!ReadExtended PROC NEAR32
       PUSH EBP
       MOV EBP,ESP
       SUB ESP,262
       DB $89,$04,$24   //Perform stack probe MOV [ESP],EAX
       LEA EAX,[EBP-260]
       PUSH EAX
       CALLN32 SYSTEM.StrRead
       LEA EAX,[EBP-260]
       PUSH EAX
       PUSH DWORD PTR [EBP+8]
       LEA EAX,[EBP-262]
       PUSH EAX
       CALLN32 SYSTEM.!Str2Extended
       LEAVE
       RETN32 4
SYSTEM.!ReadExtended ENDP

END;

Function Get8087CW : WORD; ASSEMBLER;
VAR CtrlWord : WORD;
ASM
  fstcw CtrlWord;
  mov ax, CtrlWord;
  MOV RESULT,ax
end;

Procedure Set8087CW (cw : WORD); ASSEMBLER;
ASM
  fclex
  fldcw cw;
  fwait
end;

Procedure Default8087CW; ASSEMBLER;
ASM
  fclex
  fldcw System.FPUControl;
  fwait
end;
PROCEDURE Real2AnsiStr(f:BYTE;n:LONGWORD;CONST r:Single;VAR result:AnsiString);
VAR s:STRING;
BEGIN
     ASM
        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        PUSH DWORD PTR f
        PUSH DWORD PTR n
        PUSH DWORD PTR r
        LEA EAX,s
        PUSH EAX
        CALLN32 SYSTEM.!Real2Str
     END;
     result:=s;
     ASM
        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI
     END;
END;

PROCEDURE Double2AnsiStr(f:BYTE;n:LONGWORD;CONST r:Double;VAR result:AnsiString);
VAR s:STRING;
BEGIN
     ASM
        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        PUSH DWORD PTR f
        PUSH DWORD PTR n
        PUSH DWORD PTR r
        LEA EAX,s
        PUSH EAX
        CALLN32 SYSTEM.!Double2Str
     END;
     result:=s;
     ASM
        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI
     END;
END;

PROCEDURE AnsiStr2Real(VAR s:AnsiString;VAR b:SINGLE;VAR c:INTEGER);
VAR s1:STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH ESI
        PUSH EDI
     END;

     s1:=s;
     ASM
        LEA EAX,s1
        PUSH EAX
        PUSH DWORD PTR b
        PUSH DWORD PTR c
        CALLN32 SYSTEM.!Str2Real
     END;

     ASM
        POP EDI
        POP ESI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

PROCEDURE AnsiStr2Double(VAR s:AnsiString;VAR b:DOUBLE;VAR c:INTEGER);
VAR s1:STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH ESI
        PUSH EDI
     END;

     s1:=s;
     ASM
        LEA EAX,s1
        PUSH EAX
        PUSH DWORD PTR b
        PUSH DWORD PTR c
        CALLN32 SYSTEM.!Str2Double
     END;

     ASM
        POP EDI
        POP ESI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;

END;

PROCEDURE AnsiStr2Comp(VAR s:AnsiString;VAR b:Comp;VAR c:INTEGER);
VAR s1:STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH ESI
        PUSH EDI
     END;

     s1:=s;
     ASM
        LEA EAX,s1
        PUSH EAX
        PUSH DWORD PTR b
        PUSH DWORD PTR c
        CALLN32 SYSTEM.!Str2Comp
     END;

     ASM
        POP EDI
        POP ESI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;

END;

PROCEDURE AnsiStr2Currency(VAR s:AnsiString;VAR b:Comp;VAR c:INTEGER);
VAR s1:STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH ESI
        PUSH EDI
     END;

     s1:=s;
     ASM
        LEA EAX,s1
        PUSH EAX
        PUSH DWORD PTR b
        PUSH DWORD PTR c
        CALLN32 SYSTEM.!Str2Currency
     END;

     ASM
        POP EDI
        POP ESI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

PROCEDURE AnsiStr2Extended(VAR s:AnsiString;VAR b:Extended;VAR c:INTEGER);
VAR s1:STRING;
BEGIN
     ASM
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX
        PUSH ESI
        PUSH EDI
     END;

     s1:=s;
     ASM
        LEA EAX,s1
        PUSH EAX
        PUSH DWORD PTR b
        PUSH DWORD PTR c
        CALLN32 SYSTEM.!Str2Extended
     END;

     ASM
        POP EDI
        POP ESI
        POP EDX
        POP ECX
        POP EBX
        POP EAX
     END;
END;

PROCEDURE Comp2AnsiStr(f:BYTE;n:LONGWORD;CONST r:Comp;VAR result:AnsiString);
VAR s:STRING;
BEGIN
     ASM
        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        PUSH DWORD PTR f
        PUSH DWORD PTR n
        PUSH DWORD PTR r
        LEA EAX,s
        PUSH EAX
        CALLN32 SYSTEM.!Comp2Str
     END;
     result:=s;
     ASM
        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI
     END;
END;

PROCEDURE Currency2AnsiStr(f:BYTE;n:LONGWORD;CONST r:Currency;VAR result:AnsiString);
VAR s:STRING;
BEGIN
     ASM
        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        PUSH DWORD PTR f
        PUSH DWORD PTR n
        PUSH DWORD PTR r
        LEA EAX,s
        PUSH EAX
        CALLN32 SYSTEM.!Currency2Str
     END;
     result:=s;
     ASM
        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI
     END;
END;


PROCEDURE Extended2AnsiStr(f:BYTE;n:LONGWORD;CONST r:Extended;VAR result:AnsiString);
VAR s:STRING;
BEGIN
     ASM
        PUSH EDI
        PUSH ESI
        PUSH EDX
        PUSH ECX
        PUSH EBX
        PUSH EAX

        PUSH DWORD PTR f
        PUSH DWORD PTR n
        PUSH DWORD PTR r
        LEA EAX,s
        PUSH EAX
        CALLN32 SYSTEM.!Extended2Str
     END;
     result:=s;
     ASM
        POP EAX
        POP EBX
        POP ECX
        POP EDX
        POP ESI
        POP EDI
     END;
END;


ASSEMBLER

{$IFDEF OS2}
SYSTEM.!ParaInfo PROC NEAR32  //(AL=Function - 1 count of parameters to CL
                              //               2 Pointer to parameter CL to ESI
                              //Input:argument start in ESI
         MOV BX,0      //we start with parameter 0
         MOV DL,0      //we are not in " state
         CMP AL,2      //get parameter name ?
         JNE !no_name
         PUSH ESI
         CMP CL,0      //parameter 0 required ?
         JE !no_args
         POP ESI
!no_name:
         //Overread the EXE file name
         CLD
         PUSH AX
!rrloop:
         LODSB
         CMP AL,0
         JNE !rrloop
         POP AX

         MOV DL,0   //we are not in " state
         CMP AL,2   //get parameter name ?
         JE !get_argname
         MOV CL,255 //impossible parameter
!get_argname:
         XOR CH,CH
         MOV BX,1      //now finally we start with parameter 1

         LODSB
         //check whether the first character is a separator
         CMP AL,' '
         JE !aagain
         CMP AL,0   //is this already the end -->Urrgh !
         JNE !al2
         PUSHL 0    //The (nonexistent) parameters -->Throw it away guy !
         MOV BL,0   //No parameters
         JMP !no_args
!al2:
         DEC ESI    //restore old position
!aagain:
         PUSH ESI   //save last adress
         CMP CL,BL  //is the parameter reached ??
         JE !no_args
!readloop:
         LODSB
         CMP AL,0
         JE !no_args1  //No more arguments detected
         //check all separators possible
         CMP AL,'"'
         JNE !xxx1
         NOT DL
!xxx1:
         CMP AL,' '
         JNE !readloop
         CMP DL,0     //only increase param if we are not in " state
         JNE !readloop
!separator:
         //Check whether more separators follow
         LODSB
         CMP AL,' '
         JE !one_more
         CMP AL,0      //A zero parameter is stupid
         JNE !no_more
         POP EAX       //Clear stack
         PUSHL 0       //The (nonexistent) parameter -->Throw it away guy !
         JMP !no_args
!one_more:
         JMP !separator
!no_more:
         DEC ESI
         INC BX        //Increment parameter count
         MOV DL,0      //we are not in " state
         POP EAX       //clear stack
         JMP !aagain
!no_args1:
         //Argument index was invalid
         POP ESI   //Clear Stack
         PUSHL 0   //Pointer to parameter is NIL
!no_args:
         MOV CL,BL     //Parameter count
         POP ESI       //Adress of last parameter
         RETN32
SYSTEM.!ParaInfo ENDP
{$ENDIF}


{$IFDEF Win32}
SYSTEM.!ParaInfo PROC NEAR32  //(AL=Function - 1 count of parameters to CL
                              //               2 Pointer to parameter CL to ESI
                              //Input:argument start in ESI
         MOV BX,0      //we start with parameter 0
         MOV DL,0      //we are not in " state
         CMP AL,2      //get parameter name ?
         JNE !no_name
         PUSH ESI
         CMP CL,0      //parameter 0 required ?
         JE !no_args
         POP ESI
!no_name:
         //Overread the EXE file name
         CLD
         PUSH AX
!rrloop:
         LODSB

         //test termination
         CMP AL,0
         JNE !noterm1

         POP AX
         PUSHL 0    //The (nonexistent) parameter
         MOV BL,0   //No parameters
         JMP !no_args
!noterm1:

         CMP AL,'"'
         JNE !xxx1
         NOT DL
!xxx1:
         CMP AL,' '
         JNE !rrloop
         CMP DL,0
         JNE !rrloop  //we are inside ", so spaces are valid

         POP AX
         MOV DL,0   //we are not in " state
         CMP AL,2   //get parameter name ?
         JE !get_argname
         MOV CL,255 //impossible parameter
!get_argname:
         XOR CH,CH
         MOV BX,1      //now finally we start with parameter 1

         LODSB
         //check whether the first character is a separator
         CMP AL,' '
         JE !aagain
         CMP AL,0   //is this already the end -->Urrgh !
         JNE !al2
         PUSHL 0    //The (nonexistent) parameters -->Throw it away guy !
         MOV BL,0   //No parameters
         JMP !no_args
!al2:
         DEC ESI    //restore old position
!aagain:
         PUSH ESI   //save last adress
         CMP CL,BL  //is the parameter reached ??
         JE !no_args
!readloop:
         LODSB
         CMP AL,0
         JE !no_args1  //No more arguments detected
         //check all separators possible
         CMP AL,'"'
         JNE !xxx2
         NOT DL
!xxx2:
         CMP AL,' '
         JNE !readloop
         CMP DL,0     //only increase param if we are not in " state
         JNE !readloop
!separator:
         //Check whether more separators follow
         LODSB
         CMP AL,' '
         JE !one_more
         CMP AL,0      //A zero parameter is stupid
         JNE !no_more
         POP EAX       //Clear stack
         PUSHL 0       //The (nonexistent) parameter -->Throw it away guy !
         JMP !no_args
!one_more:
         JMP !separator
!no_more:
         DEC ESI
         INC BX        //Increment parameter count
         MOV DL,0      //we are not in " state
         POP EAX       //clear stack
         JMP !aagain
!no_args1:
         //Argument index was invalid
         POP ESI   //Clear Stack
         PUSHL 0   //Pointer to parameter is NIL
!no_args:
         MOV CL,BL     //Parameter count
         POP ESI       //Adress of last parameter
         RETN32
SYSTEM.!ParaInfo ENDP
{$ENDIF}
END;

VAR ArgStart:POINTER;
    EnvStart:POINTER;
    SysTlsSize:LONGWORD;

FUNCTION ParamStr(item:Byte):STRING;

VAR s,s1:STRING;
    us  : string;

BEGIN
  Result:='';  {Clear}
  ASM
      MOV CL,item                 //index to CL
      MOV AL,2                    //Get Parameter name
      MOV ESI,SYSTEM.ArgStart
      CALLN32 SYSTEM.!ParaInfo
      MOV EDI,[EBP+8]             //Result string
      MOVB [EDI+0],0              //Result string is empty
      LEA EDI,s                   //result string
      XOR AL,AL                   //Stringlen to 0
      CLD
      STOSB
      CMP ESI,0                   //Parameter invalid ?
      JE _Lpe

      CLD
      LEA EDI,s    //result string
      XOR AL,AL    //Stringlen to 0
      STOSB
      MOV CL,0     //Len is 0
      MOV DL,0     //we are not in " state
__lp1:
      LODSB
      //Check all separators
      CMP AL,'"'
      JNE !xxx4
      NOT DL
!xxx4:
      CMP AL,' '
      JNE !xxx5
      CMP DL,0
      JE __Lps
!xxx5:
      CMP AL,0    //Last parameter
      JE __Lps
      INC CL
      //No separator --> save
      STOSB
      JMP __lp1
__Lps:
      LEA EDI,s             //Result string
      MOV [EDI+0],CL        //set Stringlen
_lpe:
  END;

  IF Length(s)>0 THEN
    IF s[1]='"' THEN Delete(s,1,1);
  IF s[Length(s)]='"' THEN dec(s[0]);
  Result:=s;
END;

FUNCTION PARAMCOUNT:Byte;
BEGIN
     ASM
        MOV AL,1  //get parametercount
        MOV CL,1  //avoid exit in !ParaInfo
        MOV ESI,SYSTEM.ArgStart
        CALLN32 SYSTEM.!ParaInfo
        MOV AL,CL
        XOR AH,AH
        MOV Result,AX
     END;
END;


//************************************************************************
//
//
// System initialization code and thread management
//
//
//************************************************************************

ASSEMBLER

SYSTEM.!CorrectArgList PROC NEAR32
               CLD
               MOVB SYSTEM.Redirect,0
               MOV ESI,SYSTEM.ArgStart
               CMP ESI,0
               JNE !cal1_rrloop
               RETN32

!cal1_rrloop:
               //Overread EXE file name
               LODSB
               CMP AL,0
               JNE !cal1_rrloop
!cal1_1:
               MOV AL,[ESI+0]

               CMP AL,32
               JNE !cal1_3

               CMPB [ESI+1],0
               JNE !cal1_3
               MOV AL,0
!cal1_3:
               CMP AL,'|'
               JE !cal1_51x

               CMP AL,'>'
               JE !cal1_5!

               CMP AL,'<'
               JNE !cal1_4
               MOVB SYSTEM.RedirectIn,1
               JMP !cal1_51x
!cal1_5!:
               MOVB SYSTEM.RedirectOut,1
!cal1_51x:
               pushl 1000
               pushl 1000
               calln32 system.beep
               //redirect symbol found
               //Set REDIRECT on TRUE
               MOVB SYSTEM.Redirect,1
               MOV EDI,ESI
               MOV AL,0
!cal1_51!:
               DEC EDI
               CMP EDI,SYSTEM.ArgStart
               JB !cal1_4
               CMPB [EDI+0],32
               JNE !cal1_4
               MOVB [EDI+0],0
               JMP !cal1_51!
!cal1_4:
               MOV [ESI+0],AL
               INC ESI
               CMP AL,0
               JNE !cal1_1
               RETN32
SYSTEM.!CorrectArgList ENDP

END;

TYPE
    PSCUFileFormat=^TSCUFileFormat;
    TSCUFileFormat=RECORD
                         Version:STRING[5];
                         ObjectOffset,ObjectLen:LONGINT;
                         NameTableOffset,NameTableLen:LONGINT;
                         ResourceOffset,ResourceLen:LONGINT;
                         ObjectCount:LONGINT;
                         UseEntry:LONGINT; {used by project management}
                         NextEntry:POINTER;
                   END;

PROCEDURE AddSCUData(Data:PSCUFileFormat);
VAR p:PSCUFileFormat;
BEGIN
     p:=Data^.NextEntry;
     Data^.NextEntry:=SCUPointer;
     SCUPointer:=Data;
     IF LongWord(p)=$FFFFFFFF THEN
     BEGIN
          p:=Data;
          inc(p,Data^.ResourceOffset+Data^.ResourceLen);
          AddSCUData(p);
     END;
END;

TYPE
    PDFMFileFormat=^TDFMFileFormat;
    TDFMFileFormat=RECORD
                         EntryData:POINTER;
                         EntryLen:LONGWORD;
                         NextEntry:PDFMFileFormat;
                   END;

PROCEDURE AddDFMData(Data:PDFMFileFormat;DataLen:LONGWORD);
VAR Temp:PDFMFileFormat;
BEGIN
     new(Temp);
     Temp^.EntryData:=Data;
     Temp^.EntryLen:=DataLen;
     Temp^.NextEntry:=SCUPointer;
     SCUPointer:=Temp;
END;

{$IFDEF OS2}
IMPORTS
   FUNCTION DosCreateThread(VAR aptid:LONGWORD;pfn:POINTER;param:POINTER;flag:LONGWORD;
                            cbStack:LONGWORD):LONGWORD;
                   APIENTRY;             'DOSCALLS' index 311;
   FUNCTION DosKillThread(atid:LONGWORD):LONGWORD;
                   APIENTRY;             'DOSCALLS' index 111;
   FUNCTION DosSleep(msec:LONGWORD):LONGWORD;
                    APIENTRY;             'DOSCALLS' index 229;
END;
{$ENDIF}

TYPE
    PThreadData=^TThreadData;
    TThreadData=RECORD
                      f:TThreadFunc;
                      p:Pointer;
                END;

{$HINTS OFF}
PROCEDURE NewTlsData(id:LONGWORD;Data:POINTER);
BEGIN
     {$IFDEF Win32}
     TlsSetValue(TlsIndex,Data);
     {$ENDIF}
     
     {$IFDEF OS2}
     IF TlsData=NIL THEN
       BEGIN
         GetAPIMem(TlsData,sizeof(TTlsData));
         FillChar(TlsData^,sizeof(TTlsData),0);
       END;
     TlsData^[id]:=Data;
     {$ENDIF}
END;
{$HINTS ON}

FUNCTION GetProcessId:LongWord;

{$IFDEF OS2}
VAR tib:PTIB;
    pib:PPIB;
{$ENDIF}

Begin
  Result:=0;
{$IFDEF OS2}
  tib:=NIL;
  pib:=NIL;
  DosGetInfoBlocks(tib, pib);
  Result:=pib^.pib_ulpid;
{$ENDIF}
End;

FUNCTION GetThreadId:LONGWORD;
BEGIN
     {$IFDEF OS2}
     ASM
        MOV EDI,$0c
        db $64
        MOV EBX,[EDI]          //MOV EBX,FS:[EDI]
        MOV EBX,[EBX]          //get thread ID
        MOV result,EBX
     END;
     {$ENDIF}
     {$IFDEF Win32}
     result:=GetCurrentThreadId;
     {$ENDIF}
END;

FUNCTION SysThreadProc(Param:PThreadData):LONGINT;CDECL;
VAR f:TThreadFunc;
    p:Pointer;
    Data:POINTER;
    Diff:LONGWORD;
BEGIN
     f:=Param^.f;
     p:=Param^.p;
     Dispose(Param);

     Diff:=SysTlsSize+4096;
     Diff:=Diff DIV 4096;
     Diff:=Diff*4096;

     //provide local thread storage on the stack and clear it
     ASM
        MOV EDI,ESP
        SUB EDI,4
        SUB ESP,Diff
        MOV Data,ESP
        //Fill the TLS area with 0
        MOV ECX,Diff
        SHR ECX,2
        MOV EAX,0
        STD
        REP
        STOSD
        CLD
     END;

     NewTlsData(GetThreadId-1,Data);
     result:=f(p);
     EndThread(0);

     //Terminate child thread. Should not come to here, just in case...
     Halt(0);
END;

{$HINTS OFF}
FUNCTION BeginThread(SecurityAttrs:POINTER;StackSize:LONGWORD;
                     ThreadFunc:TThreadFunc;Parameter:Pointer;
                     Options:LONGWORD;VAR id:LONGWORD):LONGWORD;
VAR Data:PThreadData;
BEGIN
     Result:=0;
     inc(StackSize,SysTlsSize+4096);
     New(Data);
     Data^.f:=ThreadFunc;
     Data^.p:=Parameter;
     {$IFDEF OS2}
     Options:=Options Or 2; // commit the stack pages
// If bit 1 is set to 0, the system uses the default method for
// initializing the thread's stack.  If bit 1 is set to 1, the
// system precommits all the pages in the stack. One page is 4KB.
     DosCreateThread(result,@SysThreadProc,Data,Options,StackSize);
     id:=0;
     {$ENDIF}
     {$IFDEF Win32}
     result:=CreateThread(SecurityAttrs,StackSize,@SysThreadProc,Data,Options,id);
     {$ENDIF}
END;
{$HINTS ON}

{$IFDEF Win32}
IMPORTS
   FUNCTION TerminateThread(hThread:LONGWORD;dwExitCode:LONGWORD):LONGBOOL;
                  APIENTRY;  'KERNEL32' name 'TerminateThread';
END;
{$ENDIF}

PROCEDURE KillThread(atid:LONGWORD);
{$IFDEF OS2}
VAR r:LONGWORD;
{$ENDIF}
BEGIN
     {$IFDEF OS2}
     REPEAT
           r := DosKillThread(atid);
           IF r = 170 THEN DosSleep(50);  //wait a while
     UNTIL r <> 170;
     {$ENDIF}
     {$IFDEF Win32}
     TerminateThread(atid,0);
     {$ENDIF}
END;


PROCEDURE EndThread(ExitCode:LONGINT);
BEGIN
     {$IFDEF OS2}
     DosExit(0,ExitCode);
     {$ENDIF}
     {$IFDEF Win32}
     ExitThread(ExitCode);
     {$ENDIF}
END;

ASSEMBLER

{$IFDEF OS2}
SYSTEM.!GetTlsVar PROC NEAR32
      PUSH EDI
      PUSH EBX

      MOV EDI,$0c
      db $64
      MOV EBX,[EDI]          //MOV EBX,FS:[EDI]
      MOV EBX,[EBX]          //get thread ID
      MOV EAX,[EAX]          //get offset
      DEC EBX
      MOV EDI,SYSTEM.TlsData
      CMP EDI,0              //NIL ?
      JNE !Tlsnn
      //TlsData is NIL for some reason
      //use global variable instead
      POP EBX
      POP EDI
      RETN32
!Tlsnn:
      LEA EDI,[EDI+EBX*4]
      CMPD [EDI],0
      JNE !TlsOk
      //this thread was not started using BeginThread,
      //use global variable instead
      MOV EDI,SYSTEM.TlsData
!TlsOk:
      ADD EAX,[EDI]          //Add offset of local Tls segments

      POP EBX
      POP EDI
      RETN32
SYSTEM.!GetTlsVar ENDP
{$ENDIF}

{$IFDEF Win32}
SYSTEM.!GetTlsVar PROC NEAR32
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH ESI
      PUSH EDI

      PUSH EAX

      PUSH DWORD PTR SYSTEM.TlsIndex
      CALLDLL KERNEL32,'TlsGetValue'
      CMP EAX,0
      JNE !TlsOk
      //this thread was not started using BeginThread,
      //use global variable instead
      MOV EAX,SYSTEM.MainTls
!TlsOk:
      POP EBX
      ADD EAX,[EBX]   //Add offset

      POP EDI
      POP ESI
      POP EDX
      POP ECX
      POP EBX
      RETN32
SYSTEM.!GetTlsVar ENDP
{$ENDIF}

END;

{$IFDEF Win32}
IMPORTS
FUNCTION GetCommandLine:PChar;
                  APIENTRY;  'KERNEL32' name 'GetCommandLineA';
FUNCTION GetModuleHandle(CONST lpModuleName:CSTRING):LONGWORD;
                  APIENTRY;  'KERNEL32' name 'GetModuleHandleA';
END;
{$ENDIF}


PROCEDURE SystemInit(HeapSize,TheStackSize,TLSSize:LONGWORD);
// SystemInit-Aufruf wird automatisch vom Compilier generiert.
// Bei der Compilerdirective $m:
// HeapSize:    > 8 MB (8388608) vom Compile weitergeleitet.
// TheStackSize:> 32 kB (32768) vom Compile weitergeleitet.


VAR
   ff:^FileRec;
   ESPA:LONGWORD;
   Data:POINTER;
BEGIN
  if HeapSize <= (MinHeapSize) then
    HeapSize:=MinHeapSize;
  ASM
     MOV ESPA,ESP
  END;
  //MemPageSize:=8192; //Min Size of a heap page
  SysTLSSize:=TLSSize;

  {$IFDEF Win32}
  TlsIndex:=TlsAlloc;
  {$ENDIF}
  {$IFDEF OS2}
  TlsData:=NIL;
  {$ENDIF}

  MainHeapSize := HeapSize;

  GetAPIMem(Data,SysTlsSize);

  MainTls:=Data;
  MainTlsSize := sysTlsSize;

  NewTlsData(0,Data);
  StackSize:=TheStackSize;
  MinStack:=(ESPA-StackSize)+16384;

  {$IFDEF OS2}
  IF DLLModule<>0 THEN ExitProc:=@ExitAllDLL
  ELSE ExitProc:=@ExitAll;
  {$ENDIF}
  {$IFDEF Win32}
  IF ModuleCount<>0 THEN ExitProc:=@ExitAllDLL
  ELSE ExitProc:=@ExitAll;
  ArgStart:=GetCommandLine;
  DllModule:=GetModuleHandle(NIL);
  {$ENDIF}
  RedirectIn:=FALSE;
  RedirectOut:=FALSE;
  Redirect:=FALSE;

  ASM
     //Initialize FPU
     FINIT
     FCLEX
     FLDCW SYSTEM.FPUControl
     FWAIT
     //correct arguments
     {$IFDEF OS2}
     CALLN32 SYSTEM.!CorrectArgList
     {$ENDIF}
  END;

  FileBufSize:=32760;   {Standard file buffer size}

  ff:=@Input;
  {$IFDEF OS2}
  ff^.Handle:=0; {Handle to standard input}
  {$ENDIF}
  {$IFDEF Win32}
  ff^.Handle:=GetStdHandle(-10); {Handle to standard input}
  {$ENDIF}
  ff^.RecSize:=1;
  ff^.Name:='';
  ff^.EAS:=NIL;
  ff^.Flags:=$6666;
  ff^.Mode:=0;
  ff^.Buffer:=NIL;
  ff^.MaxCacheMem:=0;
  ff^.Offset:=0;
  ff^.LOffset:=0;
  ff^.Block:=0;
  ff^.LBlock:=0;
  ff^.Reserved1:=0;
  ff^.BufferBytes:=0;

  ff:=@Output;
  {$IFDEF OS2}
  ff^.Handle:=1; {Handle to standard output}
  {$ENDIF}
  {$IFDEF Win32}
  ff^.Handle:=GetStdHandle(-11); {Handle to standard output}
  {$ENDIF}
  ff^.RecSize:=1;
  ff^.Name:='';
  ff^.EAS:=NIL;
  ff^.Flags:=$6666;
  ff^.Mode:=0;
  ff^.Buffer:=NIL;
  ff^.MaxCacheMem:=0;
  ff^.Offset:=0;
  ff^.LOffset:=0;
  ff^.Block:=0;
  ff^.LBlock:=0;
  ff^.Reserved1:=0;
  ff^.BufferBytes:=0;

  HeapError:=StdHeapError;

  {Initialize system variables}
  OpenedFilesCount:=0;
  InOutRes:=0;
  FileMode:=fmInOut;
  SeekMode:=0; {File BEGIN}
  SetTrigMode(rad);

  heap_Init;
END;

{$HINTS OFF}
PROCEDURE SystemEnd{(ReturnCode:Word)};
BEGIN
  CleanUp;
  Halt(0);
END;
{$HINTS ON}

{$IFDEF OS2}
TYPE
   POINTL=RECORD
         x:LONGINT;
         y:LONGINT;
   END;

   QMSG=RECORD
      hwnd:LONGWORD;
      msg:LONGWORD;
      mp1:LONGWORD;
      mp2:LONGWORD;
      time:LONGWORD;
      ptl:POINTL;
      reserved:LONGWORD;
   END;

PROCEDURE MainDispatchLoop;
VAR _qmsg:QMSG;
BEGIN
     ASM
!ndis:
        PUSHL 0
        PUSHL 0
        PUSHL 0
        LEA EAX,_qmsg
        PUSH EAX
        PUSH DWORD PTR SYSTEM.AppHandleIntern
        MOV AL,5
        CALLDLL PMWIN,915  //WinGetMsg
        ADD ESP,20
        CMP EAX,0
        JE !exdis

        LEA EAX,_qmsg
        PUSH EAX
        PUSH DWORD PTR SYSTEM.AppHandleIntern
        MOV AL,2
        CALLDLL PMWIN,912  //WinDispatchMsg
        ADD ESP,8
        JMP !ndis
!exdis:
     END;
END;
{$ENDIF}

{$IFDEF Win32}
PROCEDURE MainDispatchLoop;
VAR msg:RECORD
              hwnd:LONGWORD;
              message:LONGWORD;
              wParam:LONGWORD;
              lParam:LONGWORD;
              time:LONGWORD;
              pt:RECORD x,y:LONGINT; END;
         END;

BEGIN
  while GetMessage (msg,0, 0, 0) DO
    DispatchMessage (msg);
END;
{$ENDIF}

{*****************************************************************************
 *                                                                           *
 * Named resource management                                                 *
 *                                                                           *
 *                                                                           *
 *****************************************************************************}

TYPE
     PQuickAccess=^TQuickAccess;
     TQuickAccess=ARRAY[0..256] OF LONGWORD;
     PStringListQuickAccess=^TStringListQuickAccess;
     TStringListQuickAccess=ARRAY[0..1] OF TQuickAccess;
     PHighestQuickAccess=^THighestQuickAccess;
     THighestQuickAccess=ARRAY[0..1] OF Byte;

     PNamedRes=^TNamedRes;
     TNamedRes=RECORD
                     Res:POINTER;
                     {Quick access for string tables, Array of offsets for Item*256}
                     QuickAccess:PStringListQuickAccess;
                     HighestQuickAccess:PHighestQuickAccess;
                     next:PNamedRes;
               END;

// Name-Resourcen
CONST NamedBitmaps : PNamedRes=NIL;
      NamedPointers: PNamedRes=NIL;
      NamedIcons   : PNamedRes=NIL;
      NamedStrings : PNamedRes=NIL;

Function GenUniqueResName(iResID : LongInt; iTyp : String) : String;

Begin
  Result:='WDSIBYL_RSC_'+iTyp+toHex(iResID);
End;

FUNCTION AddRes(VAR r:PNamedRes;p:POINTER):PNamedRes;
BEGIN
  IF r=NIL
    THEN
      BEGIN
        new(r);
        result:=r;
        result^.Next:=NIL;
      END
    ELSE
      BEGIN
        New(result);
        result^.Next:=r;
        r:=result;
      END;

  result^.res:=p;
END;

PROCEDURE AddIconRes(p:POINTER);
BEGIN
  AddRes(NamedIcons,p);
END;

PROCEDURE AddBitmapRes(p:POINTER);
BEGIN
  AddRes(NamedBitmaps,p);
END;

PROCEDURE AddPointerRes(p:POINTER);
BEGIN
  AddRes(NamedPointers,p);
END;

PROCEDURE AddStringTableRes(p:POINTER);
VAR l:^LONGINT;
    len:LONGINT;
    b:^BYTE;
    s:STRING;
    Count:LONGWORD;
    Res:PNamedRes;
BEGIN
     Res:=AddRes(NamedStrings,p);

     //provide some quick access info...
     //look how many string tables we have...
     l:=Res^.res;
     len:=l^;
     Count:=0;
     WHILE len<>0 do
     BEGIN
          inc(l,4);  //Skip Len
          b:=Pointer(l);
          s[0]:=chr(b^);
          inc(b);
          IF s[0]<>#0 THEN move(b^,s[1],ord(s[0]));
          inc(b,ord(s[0]));

          l:=Pointer(b);
          inc(l,Len);
          len:=l^;
          inc(Count);
     END;

     //Allocate the quick access list
     GetMem(Res^.QuickAccess,Count*sizeof(TQuickAccess));
     GetMem(Res^.HighestQuickAccess,Count*SizeOf(Byte));
END;

FUNCTION FindRes(r:PNamedRes;Name:STRING;VAR DataLen:LONGWORD):Pointer;
VAR l:^LONGINT;
    b:^Byte;
    len:LONGINT;
    ps:^STRING;
BEGIN
     result:=NIL;
     DataLen:=0;
     UpcaseStr(Name);
     WHILE r<>NIL DO
     BEGIN
          l:=r^.res;
          len:=l^;
          WHILE len<>0 do
          BEGIN
               inc(l,4);  //skip Len
               b:=Pointer(l);

               ps:=Pointer(b);
               inc(b,length(ps^)+1);

               IF ps^=Name THEN
               BEGIN
                    result:=b;
                    DataLen:=len;
                    exit;
               END;
               l:=Pointer(b);
               inc(l,Len);
               len:=l^;
          END;
          r:=r^.Next;
     END;
END;

FUNCTION FindIconRes(CONST Name:STRING;VAR DataLen:LONGWORD):Pointer;
BEGIN
  result:=FindRes(NamedIcons,Name,DataLen);
END;

FUNCTION FindBitmapRes(CONST Name:STRING;VAR DataLen:LONGWORD):Pointer;
BEGIN
  result:=FindRes(NamedBitmaps,Name,DataLen);
END;

FUNCTION FindPointerRes(CONST Name:STRING;VAR DataLen:LONGWORD):Pointer;

BEGIN
  result:=FindRes(NamedPointers,Name,DataLen);
END;


FUNCTION FindStringTableRes(CONST Name:STRING;VAR DataLen:LONGWORD):Pointer;
BEGIN
  //The String Table includes 2 WORDS at offset 0 and 2 that specify the
  //minimum and maximum index for that table
  result:=FindRes(NamedStrings,Name,DataLen);
END;

FUNCTION GetStringTableEntry(CONST Table:STRING;Ident:WORD):STRING;
VAR StringTable:^LONGWORD;
    Len:LONGWORD;
    TableMax:LONGWORD;
    Found:BOOLEAN;
    l:^LONGINT;
    b:^Byte;
    r:PNamedRes;
    Name:STRING;
    ps:^STRING;
    MinIndex,MaxIndex:WORD;
    ModIdent:WORD;
    Count:LONGWORD;
    Quick:PQuickAccess;
LABEL weiter;
BEGIN
     //the string table may be present more than once !!!
     Result:='';

     ModIdent:=Ident SHR 8;
     Len:=0;
     Name:=Table;
     UpcaseStr(Name);
     r:=NamedStrings;
     WHILE r<>NIL DO
     BEGIN
          l:=r^.res;
          len:=l^;
          Count:=0;
          WHILE len<>0 do
          BEGIN
               inc(l,4);  //skip Len
               b:=Pointer(l);

               ps:=Pointer(b);
               inc(b,length(ps^)+1);

               IF ps^=Name THEN
               BEGIN
                    StringTable:=Pointer(b);

                    TableMax:=LONGWORD(StringTable);
                    inc(TableMax,Len-4);

                    MinIndex:=StringTable^ AND 65535;
                    inc(StringTable,2);
                    MaxIndex:=StringTable^ AND 65535;
                    inc(StringTable,2);
                    IF ((Ident<MinIndex)OR(Ident>MaxIndex)) THEN goto weiter; //cannot be this table !

                    //use quick access info !
                    Quick:=@r^.QuickAccess^[Count];
                    IF ((Quick^[ModIdent]=0)AND(ModIdent>0)) THEN inc(StringTable,Quick^[r^.HighestQuickAccess^[Count]])
                    ELSE inc(StringTable,Quick^[ModIdent]);
                    Found:=FALSE;
                    ASM
                       MOV EAX,StringTable
                       MOV BX,Ident
!GSL1:
                       MOV CX,[EAX]
                       TEST CX,255
                       JNE !GSL4

                       //Store this entry into r^.QuickAccess
                       SHR CX,8
                       MOVZX ECX,CX
                       SHL ECX,2
                       MOV EDI,Quick
                       ADD EDI,ECX
                       MOV ECX,EAX
                       SUB ECX,b
                       SUB ECX,4
                       MOV [EDI],ECX
                       MOV CX,[EAX]

                       MOV EDI,r
                       MOV EDI,[EDI].TNamedRes.HighestQuickAccess
                       ADD EDI,Count
                       MOV DX,CX
                       SHR DX,8
                       MOV DH,[EDI]
                       DEC DH
                       CMP DL,DH
                       JB !GSL4
                       JE !GSLOk1Fix

                       //Fill remaining items with value
                       PUSH EAX
                       PUSH EBX
                       PUSH ECX
                       PUSH EDI

                       MOVZX ECX,DH
                       MOVZX EBX,DL
                       MOV EDI,Quick
                       ADD EDI,ECX
                       MOV EAX,[EDI]
!GSLLoop1:
                       ADD EDI,4
                       MOV [EDI],EAX
                       INC ECX
                       CMP ECX,EBX
                       JB !GSLLoop1

                       POP EDI
                       POP ECX
                       POP EBX
                       POP EAX
!GSLOk1Fix:
                       MOV [EDI],DL
!GSL4:
                       CMP CX,BX
                       JNE !GSL2

                       //found
                       MOVB Found,1
                       ADD EAX,2
                       MOV StringTable,EAX
                       JMP !GSL3
!GSL2:
                       JA !GSL3  //list is sorted !
                       ADD EAX,2
                       MOVZXB ECX,[EAX]
                       INC ECX
                       ADD EAX,ECX

                       CMP EAX,TableMax
                       JB !GSL1
!GSL3:
                    END;

                    IF Found THEN
                    BEGIN
                         Move(StringTable^,Result,(StringTable^ AND 255)+1);
                         exit;
                    END;
               END;
weiter:
               l:=Pointer(b);
               inc(l,Len);
               len:=l^;
               inc(Count);
          END;
          r:=r^.Next;
     END; //while
END;

ASSEMBLER

SYSTEM.!Byte_Bounds4 PROC NEAR32
    DD 0,255
SYSTEM.!Byte_Bounds4 ENDP

SYSTEM.!Word_Bounds4 PROC NEAR32
    DD 0,65535
SYSTEM.!Word_Bounds4 ENDP

SYSTEM.!ShortInt_Bounds4 PROC NEAR32
    DB $80,$FF,$FF,$FF,$7f,0,0,0
SYSTEM.!ShortInt_Bounds4 ENDP

SYSTEM.!Integer_Bounds4 PROC NEAR32
    DB 0,$80,$FF,$FF,$FF,$7f,0,0
SYSTEM.!Integer_Bounds4 ENDP

SYSTEM.!Byte_Bounds2 PROC NEAR32
    DW 0,255
SYSTEM.!Byte_Bounds2 ENDP

SYSTEM.!Word_Bounds2 PROC NEAR32
    DW 0,65535
SYSTEM.!Word_Bounds2 ENDP

SYSTEM.!ShortInt_Bounds2 PROC NEAR32
    DB $80,$FF,$7f,0
SYSTEM.!ShortInt_Bounds2 ENDP

SYSTEM.!Integer_Bounds2 PROC NEAR32
    DB 0,$80,$FF,$7f
SYSTEM.!Integer_Bounds2 ENDP

END;

{$IFDEF SPDLL30}
Procedure Checkbounds(Typ : tCompDataTyp; Value, Size : LongInt; Const Adr : Pointer);

var U, O : LongInt;

Begin
  if Size=1 then         // Bei Ein-Typ-Variablen den Wert Value noch korrigieren
    Value:=Integer(Value);
    
  asm
    MOV EAX, 0           // EAX-Register loeschen
    MOV EDI, ADR
    MOV EAX, [EDI]       // Lesen des unteren Wertes
    MOV U, EAX
    MOV EAX, [EDI+4]     // Lesen des oberen Wertes
    MOV O, EAX
!CB_check:
  end;
  CheckRange(U,O,Value);
//  CheckRangeUnsigned(U,O,V:LONGWORD);
  asm
    MOV EAX, Value
  end;
End;
{$ENDIF}

//************************************************************************
//
//
// VMT and object handling support
//
//
//************************************************************************

{$IFDEF WIN32}
Function DispatchDebuggerException(ExceptionCode,ExcptAddr:LongWord):PExcptInfo;
VAR Dummy:PExcptInfo;
    ThreadId:LONGWORD;
LABEL l,l1;
Begin
     ThreadId:=GetCurrentThreadId;
     Result:=Nil;

     {Search exception handler}
     RequestExcptMutex;

     If ExcptList=Nil Then
     BEGIN
l:
          Result:=Nil;
          exit;
     END;

     dummy:=ExcptList;
     WHILE dummy^.Next<>NIL DO dummy:=dummy^.Next;
     WHILE dummy<>NIL DO
     BEGIN
          IF dummy^.ThreadId=ThreadId THEN
          BEGIN
               Result:=dummy;
               goto l1;
          END;

          dummy:=dummy^.Last;
     END;
l1:
     IF Result=NIL THEN
        IF ExcptList<>NIL THEN Result:=ExcptList;

     ReleaseExcptMutex;

     IF Result=NIL THEN goto l;

     Registerinfo:= #13#10'at EIP ='+ToHex(LONGWORD(ExcptAddr));

     //Handle all hardware exceptions
     //all other exceptions will be notified by an exception class
     CASE ExceptionCode OF
         EXCEPTION_BREAKPOINT:
           Result^.ExcptObject:=EBreakPoint.Create('Breakpoint exception (EBreakPoint) occured'+
                                             RegisterInfo);
         EXCEPTION_STACK_OVERFLOW:
           Result^.ExcptObject:=EStackFault.Create('Stack fault exception (EStackFault) occured'+
                                             RegisterInfo);
         EXCEPTION_ACCESS_VIOLATION:
           Result^.ExcptObject:=EGPFault.Create('Access violation exception (EGPFault) occured'+
                                          RegisterInfo);
         EXCEPTION_IN_PAGE_ERROR:
           Result^.ExcptObject:=EPageFault.Create('Page fault exception (EPageFault) occured'+
                                            RegisterInfo);
         EXCEPTION_ILLEGAL_INSTRUCTION,EXCEPTION_PRIV_INSTRUCTION:
           Result^.ExcptObject:=EInvalidOpCode.Create('Invalid instruction exception (EInvalidOpCode) occured'+
                                            RegisterInfo);
         EXCEPTION_SINGLE_STEP:
           Result^.ExcptObject:=ESingleStep.Create('Single step exception (ESingleStep) occured'+
                                            RegisterInfo);
         EXCEPTION_INT_DIVIDE_BY_ZERO:
           Result^.ExcptObject:=EDivByZero.Create('Integer divide by zero exception (EDivByZero) occured'+
                                            RegisterInfo);
         EXCEPTION_INT_OVERFLOW:
           Result^.ExcptObject:=EIntOverFlow.Create('Integer overflow exception (EIntOverFlow) occured'+
                                            RegisterInfo);
         EXCEPTION_FLT_DIVIDE_BY_ZERO:
           Result^.ExcptObject:=EZeroDivide.Create('Float zero divide exception (EZeroDivide) occured'+
                                            RegisterInfo);
         EXCEPTION_FLT_INVALID_OPERATION:
           Result^.ExcptObject:=EInvalidOp.Create('Float invalid operation exception (EInvalidOp) occured'+
                                            RegisterInfo);
         EXCEPTION_FLT_OVERFLOW:
           Result^.ExcptObject:=EOverFlow.Create('Float overflow exception (EOverFlow) occured'+
                                            RegisterInfo);
         EXCEPTION_FLT_UNDERFLOW:
           Result^.ExcptObject:=EUnderFlow.Create('Float underflow exception (EUnderFlow) occured'+
                                            RegisterInfo);
         EXCEPTION_FLT_DENORMAL_OPERAND,EXCEPTION_FLT_INEXACT_RESULT,
         EXCEPTION_FLT_STACK_CHECK:
            Result^.ExcptObject:=EMathError.Create('General float exception (EMathError) occured'+
                                            RegisterInfo);
         EXCEPTION_ARRAY_BOUNDS_EXCEEDED:
            Result^.ExcptObject:=ERangeError.Create('Range check error exception (ERangeError) occured'+
                                            RegisterInfo);
         EXCEPTION_INTERNAL_RTL:
         BEGIN
              //Found^.ExcptObject already set !
              //result:=EXCEPTION_CONTINUE_EXECUTION;
              //exit;
         END;
         ELSE goto l; {Don't handle}
     END; {case}

     {Win32 generated exception}
     //Found^.ExcptObject.ReportRecord:=ExceptionInfo.ExceptionRecord^;
     Result^.ExcptObject.ExcptNum:=ExceptionCode;
     //Found^.ExcptObject.ContextRecord:=ExceptionInfo.ContextRecord^;
     Result^.ExcptObject.ExcptAddr:=Pointer(ExcptAddr);
End;

Var Handler:Pointer;
{$ENDIF}

{$D+}

{$IFDEF WIN32}
ASSEMBLER

SYSTEM.!ExceptionList PROC NEAR32
      PUSH EAX //ExceptionCode
      PUSH EBX //ExcptAddr
      CALLN32 SYSTEM.DispatchDebuggerException

      CMP EAX,0
      JNE !ExceptionHandlerPresent

      PUSHL 0
      CALLN32 SYSTEM.ExcptRunError

!ExceptionHandlerPresent:
      MOV EBX,[EAX].TExcptInfo.ExcptAddr
      MOV Handler,EBX
      MOV EBX,[EAX].TExcptInfo.OldEBP
      MOV EBP,EBX
      MOV EBX,[EAX].TExcptInfo.OldESP
      MOV ESP,EBX
      MOV EAX,[EAX].TExcptInfo.ExcptObject
      MOV EDI,OFFSET(Handler)
      JMP [EDI] //Run Exception
SYSTEM.!ExceptionList ENDP

SYSTEM.!DebugPresent PROC NEAR32
      DD OFFSET(ProcessDebugged)
SYSTEM.!DebugPresent ENDP

END;
{$ENDIF}

ASSEMBLER

{$IFDEF SPDLL30W32}
// Fuer den WDSibyl-Compiler
   SYSTEM.!VMTCall PROC NEAR32
           MOV EBX,ESP
           MOV EDI,[EBX+4]
           MOV EDI,[EDI+0]
           CMP EDI,0
           JNE !VmtWeiter
           MOV EDI,[EBX+4]
           CMPD [EDI+4],0
           JNE !VmtConstructor
           PUSHL 214
           CALLN32 SYSTEM.RunError
   !VmtConstructor:
           MOV EDI,[EDI+4]
   !VmtWeiter:
           LEA EDI,[EDI+EAX*4]    //WD; Funktion-Adresse in der VMT-Tabelle ermitteln
           ADD EDI,[EDI]          //WD; Den Inhalt zu der EDI-Funktion dazu addieren (Vorzeichen)
           JMP EDI                //WD; Sprung auf die Adresse, die in der EDI steht, springen
   SYSTEM.!VMTCall ENDP

   SYSTEM.!VMTENDCALL PROC NEAR32
           RETN32
   SYSTEM.!VMTENDCALL ENDP

   //VMT call for virtual class functions
   SYSTEM.!VMTCall1 PROC NEAR32
           MOV ECX,ESP
           MOV EDI,[ECX+4]
           CMP EDI,0       //no SELF specified
           JNE !normal
           MOV EDI,EBX
           JMP !weiter
   !normal:
           MOV EDI,[EDI+0]
   !weiter:
           CMP EDI,0
           JNE !VmtWeiter1
           MOV EDI,[ECX+4]
           CMPD [EDI+4],0
           JNE !VmtConstructor1
           PUSHL 214
           CALLN32 SYSTEM.RunError
   !VmtConstructor1:
           MOV EDI,[EDI+4]
   !VmtWeiter1:
           LEA EDI,[EDI+EAX*4]    //WD; Funktion-Adresse in der VMT-Tabelle ermitteln
           ADD EDI,[EDI]          //WD; Den Inhalt zu der EDI-Funktion dazu addieren (Vorzeichen)
           JMP EDI                //WD; Sprung auf die Adresse, die in der EDI steht, springen
   SYSTEM.!VMTCall1 ENDP

{$ELSE}
// Fuer die alte Sibyl Version SPC25
   SYSTEM.!VMTCall PROC NEAR32
           MOV EBX,ESP
           MOV EDI,[EBX+4]
           MOV EDI,[EDI+0]
           CMP EDI,0
           JNE !VmtWeiter
           MOV EDI,[EBX+4]
           CMPD [EDI+4],0
           JNE !VmtConstructor
           PUSHL 214
           CALLN32 SYSTEM.RunError
   !VmtConstructor:
           MOV EDI,[EDI+4]
   !VmtWeiter:
           LEA EDI,[EDI+EAX*4]
           JMP [EDI+0]
   SYSTEM.!VMTCall ENDP

   SYSTEM.!VMTENDCALL PROC NEAR32
           RETN32
   SYSTEM.!VMTENDCALL ENDP

   //VMT call for virtual class functions
   SYSTEM.!VMTCall1 PROC NEAR32
           MOV ECX,ESP
           MOV EDI,[ECX+4]
           CMP EDI,0       //no SELF specified
           JNE !normal
           MOV EDI,EBX
           JMP !weiter
   !normal:
           MOV EDI,[EDI+0]
   !weiter:
           CMP EDI,0
           JNE !VmtWeiter1
           MOV EDI,[ECX+4]
           CMPD [EDI+4],0
           JNE !VmtConstructor1
           PUSHL 214
           CALLN32 SYSTEM.RunError
   !VmtConstructor1:
           MOV EDI,[EDI+4]
   !VmtWeiter1:
           LEA EDI,[EDI+EAX*4]
           JMP [EDI+0]
   SYSTEM.!VMTCall1 ENDP
{$ENDIF}

END;

FUNCTION IsConsole:BOOLEAN;
BEGIN
     result:=ApplicationType<>cApplicationType_GUI;
END;

FUNCTION IsLibrary:BOOLEAN;
BEGIN
     result:=DllModule<>0;
END;


///////////////// TRACE Funktion ////////////////

CONST
    CM_TRACE= $8111;
    SibylHandle:LONGWORD = 0;

    IMPORTS               
       {$IFDEF OS2}
       FUNCTION WinSendMsg(ahwnd:LONGWORD;msg:LONGWORD;mp1,mp2:LONGWORD):LONGWORD;
                           APIENTRY; 'PMWIN' index 920;
       {$ENDIF}
       {$IFDEF Win32}
       FUNCTION SendMessage(ahWnd:LONGWORD;Msg:LONGWORD;awParam:LONGWORD;alParam:LONGINT):LONGINT;
                           APIENTRY; 'USER32' name 'SendMessageA';
       {$ENDIF}
    END;


PROCEDURE Trace(CONST Value:STRING);
VAR  psm:PString;
BEGIN
  IF SibylHandle = 0 THEN exit;

  {allocate Shared Memory for the string}
  GetSharedMem(psm, Length(Value)+1);
  psm^ := Value;

  {$IFDEF OS2}
  WinSendMsg(SibylHandle,CM_TRACE,LONGWORD(psm),0);
  {$ENDIF}
  {$IFDEF Win32}
  SendMessage(SibylHandle,CM_TRACE,LONGWORD(psm),0);
  {$ENDIF}

  {deallocate Shared Memory}
  FreeSharedMem(psm, Length(Value)+1);
END;

VAR  smfh:^LONGWORD;

INITIALIZATION
  ModuleCount:=0;
  {$IFDEF OS2}
  IF AccessNamedSharedMem('WDSIBYL_MAINFORM_HANDLE', smfh) THEN
    BEGIN
      SibylHandle := smfh^;
      {Referenz auf das Shared Memory Objekt wieder freigeben}
      FreeSharedMem(smfh, SizeOf(LONGWORD));
    END
  ELSE SibylHandle := 0;
  {$ENDIF}
  {$IFDEF Win32}
  SibylHandle := 0;
  {$ENDIF}

Finalization
  heap_Final;
END.

// Hiweis:
// Um etwa auszugeben auf das WinCRT-Fenster den Befehl
// if ScreenInOut.ClassName='TWinCrtScreenInOutClass' then Writeln('xxx2');
// einbauen.

{ -- date -- -- from -- -- changes ----------------------------------------------
  27-Sep-02  WD         Ausbau der LINUX-Teile
  01-Aug-03  WD         Einige Aenderungen von von AaronL. uebnommen.
  03-Okt-03  WD         Konstanten DirectVideo, CheckSnow eintfernt (in CRT gewandert)
  04-Okt-03  WD         Random-Funktionen nach SYSUTILS ausgelagert.
  18-Jun-04  WD         Umbau von KBDVIO32.DLL auf die DLLs von EMX
  06-Aug-04  MV         Compiler-Prob korr.: Der Compiler rechnet mit dem Variablentyp weiter, mit dem er einmal angefangen hat.
  08-Sep-04  WD         Die Definitionen von uDef uebernommen. uDef aus dem Projekt entfernt.
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  23-Sep-05  WD         Cleanup: Checken ob der HeapMutex nicht schon geschlossen wurde.
  23-Sep-05  MV         Korrektur von Paramstr(0)
  30-Sep-05  WD         Die Sourceaenderungen fuer den WDSibyl-Compiler eingebaut.
  04-Nov-05  WD         Umbau der Datei fuer den WDSibyl-Compiler
  09-Mar-06  WD         ParamStr: Logik fuer Item=0 herausgenommen, bessere Logik in uSysInfo
  03-Mai-06  WD         Funktion GenUniqueResName eingebaut.
  26-Apr-06  WD         Resource-Pointer-Name eingebaut
  10-Sep-06  WD         Type: tWideChar, tWideString, tUniCodeString usw.
  31-Mar-07  MV         MkDir; Korrigiert
  13-Apr-07  MV         Neue Heap-Verwaltung
  04-Jul-07  MV         FreeMem: Diverse Korrekturen
  17-Jul-07  WD         UniCode einbauen
  01-Jan-08  WD         Typ: TFileName eingebaut
  16-Jun-08  WD         Function: GetProcessId eingebaut.
  12-Sep-08  WD         Konstante Inch2mm eingebaut (Inch in mm)
  06-Nov-08  KF         AnsiInsertStr: Korrekter aufruf von AnsiInsert
  05-Feb-09  WD         Shared-Memory-Name "SIBYL_MAINFORM_HANDLE" auf "WDSIBYL_MAINFORM_HANDLE" umbenannt.
  24-Feb-09  PE         Floating-Point-Routinen vereinfacht und korrigiert (sinh und tanh),
                        Exception-Handling fr OS/2 aktiviert.
  22-Mar-09  PE         Controlword les- und setzbar, lokale Speicherung des CW
}



{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library                                               บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
 

UNIT Dos;

{$R-,S-}

INTERFACE

Uses SysUtils;

{$IFDEF OS2}
USES BseDos,BseERR, Os2Def,PMWin,BseTib;
{$ENDIF}

{$IFDEF Win32}
USES WinNT,WinBase, WinUser;
{$ENDIF}

CONST

{ Flags bit masks }

  FCarry     = 1;
  FParity    = 4;
  FAuxiliary = 16;
  FZero      = 64;
  FSign      = 128;
  FOverflow  = 2048;

{ File attribute constants }

  {$IFDEF OS2}
  ReadOnly  = FILE_READONLY;
  Hidden    = FILE_HIDDEN;
  SysFile   = FILE_SYSTEM;
  VolumeID  = 0;  //not defined
  Directory = FILE_DIRECTORY;
  Archive   = FILE_ARCHIVED;
  AnyFile   = FILE_READONLY|FILE_HIDDEN|FILE_SYSTEM|FILE_DIRECTORY|FILE_ARCHIVED;
  {$ENDIF}
  {$IFDEF Win32}
  ReadOnly  = FILE_ATTRIBUTE_READONLY;
  Hidden    = FILE_ATTRIBUTE_HIDDEN;
  SysFile   = FILE_ATTRIBUTE_SYSTEM;
  VolumeID  = 0;  //not defined
  Directory = FILE_ATTRIBUTE_DIRECTORY;
  Archive   = FILE_ATTRIBUTE_ARCHIVE;
  AnyFile   = FILE_ATTRIBUTE_READONLY|FILE_ATTRIBUTE_HIDDEN|
              FILE_ATTRIBUTE_SYSTEM|FILE_ATTRIBUTE_DIRECTORY|
              FILE_ATTRIBUTE_ARCHIVE;
  {$ENDIF}

{Compare File times result codes}
  F_EQUAL          =0;
  F_FIRST_GREATER  =1;
  F_SECOND_GREATER =2;
  F_ERROR          =255;

type  CmdStr  = STRING;        { Command line string }
      PathStr = STRING;        { File pathname string }
      DirStr  = STRING;        { Drive and directory string }
      NameStr = STRING;        { File name string }
      ExtStr  = STRING;        { File extension string }


      Registers =
         record
           case integer of
             0: (EAX,EBX,ECX,EDX,EBP,ESI,EDI,DS_ES,EFlags:LongWord);
             1: (AX,X_AX,BX,X_BX,CX,X_CX,DX,X_DX,BP,X_BP,SI,X_SI,
                 DI,X_DI,DS,ES,Flags,X_FLAGS: Word);
             2: (AL,AH,X_AL,X_AH,BL,BH,X_BL,X_BH,CL,CH,X_CL,X_CH,
                 DL,DH,X_DL,X_DH: Byte);
           end;

{ Search record used by FindFirst and FindNext }

TYPE
   SearchRec = record
                     Fill: array[1..21] of Byte;
                     Attr: Byte;
                     Time: Longint;
                     Size: Longint;
                     floatSize : extended;{Martin lf}
                     Name: string;

                     {private}
                     HDir:LONGWORD;
                     {$IFDEF OS2}
                     SearchRecIntern:FILEFINDBUF3;

                     {Martin lf}
                     SearchRecInternL:FILEFINDBUF3L;
                     OS2longFileSupport : boolean;

                     {$ENDIF}
                     {$IFDEF Win32}
                     SearchRecIntern:WIN32_FIND_DATA;
                     InternalAttr:LONGWORD;
                     {$ENDIF}
               end;

  //TSearchRec=SearchRec; !! nein!

  {$IFDEF OS2}
  ExecResultCode=RESULTCODES;
  {$ENDIF}

  FileRec = RECORD
                  Handle          : LongWord;     {FileHandle            }
                  RecSize         : LongWord;     {Record size           }
                  Name            : STRING;       {(Long) file name      }
                  EAS             : POINTER;      {extended attributes   }
                  Mode            : LONGWORD;     {Current file mode     }
                  Reserved        : POINTER;      {for private extensions}
                  Block           : LONGWORD;     {current block in file }
                  LBlock          : LONGWORD;     {Last block in file    }
                  Offset          : LONGWORD;     {Current offset in Block}
                  LOffset         : LONGWORD;     {Last Offset in LBlock }
                  Changed         : LONGBOOL;     {TRUE if Block has changed}
                  Buffer          : POINTER;      {I/O Buffer            }
                  MaxCacheMem     : LONGWORD;     {Size of I/O Buffer    }
                  Flags           : LONGWORD;     {Assign flags $6666    }
                  Reserved1       : LONGWORD;     {dont use              }
                  {312 byte til here}
             END;

    TextRec=FileRec;

ThreadVar
         DosError    : LongInt;   {DOS unit error status}
         ExecSessPID : LongWord;

CONST ExecViaSession:BOOLEAN=TRUE; {Set to TRUE if you want to
                                    use Exec on another session.
                                    Then you cannot get the result
                                    code but you can wait via
                                    DosExitCode for the session to
                                    terminate}
      AsynchEXEC:BOOLEAN=TRUE;     {Standard: asynchronous EXEC}
      LinkSupport:Boolean=true;    {Exec: Link support z.B.: HTTP:\ }

      LastExecResult:LONGWORD=0;
      Exec_Visible : boolean = TRUE; {FALSE runs a program via
                                     "function Dos.Exec" in the background}


{Time/Date functions}
FUNCTION GetDate(VAR Year,Month,Day,DayOfWeek: Word):LONGINT;
FUNCTION SetDate(Year,Month,Day: Word):LONGINT;
FUNCTION GetTime(VAR Hour,Minute,Second,Sec100: Word):LONGINT;
FUNCTION SetTime(Hour,Minute,Second,Sec100: Word):LONGINT;
FUNCTION GetFAttr(VAR F:FILE; VAR Attr: LongWord):LONGINT;
FUNCTION SetFAttr(VAR F:FILE; Attr: LongWord):LONGINT;
FUNCTION GetFTime(VAR F:FILE;VAR Time:LONGINT):LONGINT;
FUNCTION SetFTime(VAR F:FILE;Time:LONGINT):LONGINT;
FUNCTION GetFTime2(VAR F:FILE; VAR year,month,day,hours,minutes,secs:Word):LONGINT;
FUNCTION SetFTime2(VAR F:FILE; year,month,day,hours,minutes,secs:Word):LONGINT;
PROCEDURE PackTime(VAR T: DateTime; VAR Time: Longint);
PROCEDURE UnpackTime(Time: Longint; VAR DT: DateTime);

{File find functions}
FUNCTION FindFirst(Path: PathStr; Attr: LongWord; var F: SearchRec):LONGINT;
FUNCTION FindNext(var F: SearchRec):LONGINT;
PROCEDURE FindClose(var F: SearchRec);
FUNCTION FSearch(Path: PathStr; DirList: String): PathStr;

{Common functions}
FUNCTION  DosVersion:LongWord;
FUNCTION GetVerify(var Verify: Boolean):LONGINT;
FUNCTION SetVerify(Verify: Boolean):LONGINT;
FUNCTION  GetEnv(CONST env:STRING):STRING;
FUNCTION EnvStr(Index:LONGINT):STRING;
FUNCTION EnvCount:LONGINT;
PROCEDURE SwapVectors; {ignored}

{Disk functions}
FUNCTION  DiskFree(Drive: Byte): LongWord;
FUNCTION  DiskSize(Drive: Byte): LongWord;
FUNCTION  FExpand(Path: PathStr): PathStr;
FUNCTION  FSplit(CONST Path: PathStr;VAR Dir: DirStr;
                 VAR Name: NameStr;VAR Ext: ExtStr):LONGINT;
FUNCTION  CompareFileTimes(First,Second:STRING):BYTE;

{Process functions}
FUNCTION Exec(CONST Path: PathStr; CmdLine: STRING):LONGWORD;
FUNCTION DosExitCode(SessID:LONGWORD):LONGWORD;
FUNCTION ProcessActive(pid:LONGWORD):BOOLEAN;
FUNCTION KillProcess(pid:LONGWORD):LONGINT;

{Thread functions}
FUNCTION StartThread(ThreadAddr:POINTER;StackSize:LONGWORD;
                      Params:POINTER;VAR Tid:LONGWORD):LONGINT;
FUNCTION SuspendThread(Tid:LONGWORD):LONGINT;
FUNCTION ResumeThread(Tid:LONGWORD):LONGINT;
FUNCTION KillThread(Tid:LONGWORD):LONGINT;
PROCEDURE Flush (VAR F:FILE);

PROCEDURE Delay(ms:LONGWORD);

IMPLEMENTATION

Uses uSysInfo;

VAR
   TempCmdLine:STRING;

PROCEDURE Delay(ms:LONGWORD);
BEGIN
  SysSleep(ms);
END;

PROCEDURE SwapVectors;
BEGIN
     {This function is ignored}
     DosError:=0;
END;

FUNCTION FExpand(Path:PathStr):PathStr;
VAR  i,p,t:BYTE;
     s:STRING;
LABEL l,l2;
BEGIN
     {Martin0506: do not touch network filenames  \\remotecomputer\remotefolder\file.txt }
     if (length(Path) > 2) and (Path[1] in ['\','/']) and (Path[2] in ['\','/']) then begin
       result := Path;
       exit;
     end;

     t := pos(';',Path);
     IF t <> 0 THEN
     BEGIN
          s := Path;
          delete(s,1,t);
          Path[0] := chr(t);
          Path := Path + FExpand(s);
     END;

     GetDir(0,s);
     IF length(s)=3 THEN IF s[2]=':' THEN IF s[3] IN ['\','/'] THEN dec(s[0]);

     IF pos('\',Path) = 1 THEN Path := copy(s,1,2) + Path;
     IF (Length(Path) >= 2) AND (Path[2] = ':') THEN
     BEGIN
          s := copy(Path,1,2);
          delete(Path,1,2);
     END;
     IF not (Path[1] IN ['\','/']) THEN 
     BEGIN
          Path := '\'+ Path;
     END;

     REPEAT
           IF ((pos('\..',Path) = 1)OR(pos('/..',Path) = 1)) THEN
           BEGIN
                IF (Length(Path) >= 4) AND (not (Path[4] IN ['\','/'])) THEN goto l2;
                delete(Path,1,3);
                FOR i := Length(s) DOWNTO 3 DO
                BEGIN
                     IF s[i] = ':' THEN break;
                     dec(s[0]);
                     IF s[i] IN ['\','/'] THEN break;
                END;
           END
           ELSE
           IF ((pos('\.',Path) = 1)OR(pos('/.',Path) =1)) THEN
           BEGIN
                IF (Length(Path) >= 3) AND (not (Path[3] IN ['\','/'])) THEN goto l2;
                delete(Path,1,2);
           END
           ELSE
           IF ((pos('\',Path) = 1)OR(pos('/',Path) = 1)) THEN
           BEGIN
l2:
                delete(Path,1,1);
                s := s + '\';
           END
           ELSE
           BEGIN
l:
                p := pos('\',Path);
                IF p=0 THEN p := pos('/',Path);
                IF p > 0 THEN
                BEGIN
                     s := s + copy(Path,1,p-1);
                     delete(Path,1,p-1);
                END
                ELSE
                BEGIN
                     s := s + Path;
                     Path := '';
                END;
           END;
     UNTIL Path = '';
     IF Length(s) = 2 THEN 
     BEGIN
         s := s +'\';
     END;

     Result := s;
END;

FUNCTION KillThread(Tid:LONGWORD):LONGINT;
BEGIN
     {$IFDEF OS2}
     DosError:=DosKillThread(Tid);
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=BYTE(CloseHandle(Tid)=FALSE);
     {$ENDIF}
     result:=DosError;
END;

FUNCTION SuspendThread(Tid:LONGWORD):LONGINT;
BEGIN
     {$IFDEF OS2}
     DosError:=DosSuspendThread(Tid);
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=BYTE(WinBase.SuspendThread(Tid)=$FFFFFFFF);
     {$ENDIF}
     result:=DosError;
END;

FUNCTION ResumeThread(Tid:LONGWORD):LONGINT;
BEGIN
     {$IFDEF OS2}
     DosError:=DosResumeThread(Tid);
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=BYTE(WinBase.ResumeThread(Tid)=$FFFFFFFF);
     {$ENDIF}
     result:=DosError;
END;

FUNCTION StartThread(ThreadAddr:POINTER;StackSize:LONGWORD;
                      Params:POINTER;VAR Tid:LONGWORD):LONGINT;
{$IFDEF Win32}
VAR id:LONGWORD;
{$ENDIF}
BEGIN
     {$IFDEF OS2}
     DosError:=DosCreateThread(Tid,ThreadAddr,Params,
                               STACK_SPARSE,StackSize);
     {$ENDIF}
     {$IFDEF Win32}
     Tid:=WinBase.CreateThread(NIL,StackSize,ThreadAddr,Params,0,id);
     IF Tid=0 THEN DosError:=1
     ELSE DosError:=0;
     {$ENDIF}
     result:=DosError;
END;


FUNCTION KillProcess(pid:LONGWORD):LONGINT;
BEGIN
     {$IFDEF OS2}
     DosError:=DosKillProcess(0,pid);
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=BYTE(TerminateProcess(pid,0)=FALSE);
     {$ENDIF}
     result:=DosError;
END;

FUNCTION ProcessActive(pid:LONGWORD):BOOLEAN;
{$IFDEF OS2}

VAR r   :LONGWORD;
{    rpid:LONGWORD;
    res :Execresultcode; }
{$ENDIF}

BEGIN
     {$IFDEF OS2}
     r:=DosSetPriority(PRTYS_PROCESS, PRTYC_NOCHANGE,0, pid);
     DosError:=r;
     ProcessActive:= r=ERROR_NOT_DESCENDANT

{     r:=DosWaitChild(DCWA_PROCESS,DCWW_NOWAIT,res,rpid,pid);
     DosError:=r;
     IF r = ERROR_CHILD_NOT_COMPLETE
       THEN ProcessActive:=TRUE
       ELSE ProcessActive:=FALSE; {Child complete or illegal pid}
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=1;  //not supported
     ProcessActive:=FALSE;
     {$ENDIF}
END;

FUNCTION FSplit(CONST Path: PathStr;
                 VAR Dir:DirStr;VAR Name:NameStr;VAR Ext:ExtStr):LONGINT;
Var  i    : Integer ;
     Trv  : Boolean ;
Begin
     Trv:=False ;
     For i:=Length(Path) DownTo 1 Do
     If (Path[i] IN ['\','/']) Or (Path[i]=':') Then
     Begin
          Trv:=True ;
          Dir:=Copy(Path, 1, i) ;       { or i-1 if Path[i]='\' ? }
          IF Dir[length(Dir)]='/' THEN Dir[length(Dir)]:='\';
          Name:=Copy(Path, i+1, 255) ;
          Break ;
     End ;
     If Not Trv Then
     Begin
          Dir:='' ;
          Name:=Path ;
     End ;

     Trv:=False ;
     For i:=Length(Name) DownTo 1 Do
     If Name[i]='.' Then
     Begin
          Trv:=True ;
          Ext:=Copy(Name, i, 255) ;
          Name:=Copy(Name, 1, i-1) ;
          Break ;
     End ;
     If Not Trv Then Ext:='' ;
     result:=0;
End;


FUNCTION FSearch(Path: PathStr; DirList: String): PathStr;
var
   r,c,c1:CSTRING;
   {$IFDEF Win32}
   p:PChar;
   {$ENDIF}
BEGIN
     c:=DirList;
     c1:=Path;
     {$IFDEF OS2}
     DosError:=DosSearchPath(0,c,c1,r,255);
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=BYTE(SearchPath(c,c1,NIL,255,r,p)=0);
     {$ENDIF}
     IF DosError<>0 THEN r:='';
     FSearch:=r;
END;

FUNCTION PackTimeIntern(hour,minute,twosec:Word):Word;
VAR time:Word;
BEGIN
     ASM
        MOV BL,Hour
        SHL BL,3          //multiply with 8
        MOV AL,minute
        SHR AL,3          //divide by 8
        ADD AL,BL
        SHL AX,8          //Shift
        MOV time,AX

        MOV BL,minute
        AND BL,7
        SHL BL,5          //multiply with 2 and shift
        ADD BL,TwoSec
        MOV time,BL
     END;
     DosError:=0;
     PackTimeIntern:=Time;
END;

FUNCTION PackDateIntern(year,month,day:Word):Word;
VAR Date:Word;
BEGIN
     ASM
        MOV AL,month
        MOV BL,0
        CMP AL,7
        JNA !mo1
        MOV BL,1
        SUB AL,8
!mo1:
        MOV CX,year
        SUB CX,1980
        SHL CX,1          //multiply with 2
        MOVZX BX,BL
        ADD CX,BX
        SHL CX,8         //Shift
        MOV Date,CX

        SHL AL,5         //multiply month with 2 and shift
        ADD AL,Day
        MOV Date,AL
     END;
     DosError:=0;
     PackDateIntern:=Date;
END;

PROCEDURE PackTime(var T: DateTime; var Time: Longint);
VAR year,month,day,hour,min,sec:WORD;
BEGIN
     year:=T.year;
     month:=T.month;
     day:=T.day;
     hour:=T.hour;
     min:=T.min;
     sec:=T.sec;
     ASM
        MOV AX,year
        SUB AX,1980
        MOV CL,9
        SHL AX,CL
        XCHG AX,DX
        MOV AX,month
        MOV CL,5
        SHL AX,CL
        ADD DX,AX
        MOV AX,day
        ADD DX,AX
        MOV AX,hour
        MOV CL,11
        SHL AX,CL
        XCHG AX,BX
        MOV AX,min
        MOV CL,5
        SHL AX,CL
        ADD BX,AX
        MOV AX,sec
        SHR AX,1
        ADD AX,BX
        MOV EDI,Time
        CLD
        STOSW
        XCHG AX,DX
        STOSW
     END;
END;

PROCEDURE UnPackTimeIntern(pack:Word;var hour,minute,twosec:Word);
VAR h,min,sec:WORD;
BEGIN
    ASM
       MOV DX,pack

       MOV AL,DH    //Hour/Minute
       AND AL,248   //Mask Hour
       SHR AL,3     //divide by 8
       MOVZX AX,AL
       MOV h,AX

       MOV AL,DH    //Hour/Minute
       AND AL,7     //Mask Minute
       SHL AL,3     //multiply with 8
       MOV BL,AL

       MOV AL,DL    //Minute/sec
       AND AL,224   //Mask minute
       SHR AL,5     //divide by 2 and shift
       ADD AL,BL
       MOVZX AX,AL
       MOV min,AX

       MOV AL,DL    //Minute/sec
       AND AL,31    //Mask twoseconds
       MOVZX AX,AL
       MOV sec,AX
     END;
     DosError:=0;
     Hour:=h;
     minute:=min;
     twosec:=sec;
END;

PROCEDURE UnPackDateIntern(pack:Word;var year,month,day:Word);
VAR y,m,dy:Word;
BEGIN
     ASM
        MOV DX,pack

        MOV AL,DH    //Year/Month
        AND AL,254   //Clear Bit 1
        SHR AL,1     //Divide by 2
        MOVZX AX,AL
        ADD AX,1980
        MOV y,AX     //Year
        MOV BL,0
        MOV AL,DH    //Year/Month
        AND AL,1     //Mask HSB month
        CMP AL,1
        JNE !ml7
        MOV BL,8
!ml7:
        MOV AL,DL    //month/Day
        AND AL,224   //mask month (upper 3 bits)
        SHR AL,5     //divide by 2 and shift
        ADD AL,BL
        MOVZX AX,AL
        MOV m,AX     //Month

        MOV AL,DL    //Month/day
        AND AL,31    //Mask day
        MOVZX AX,AL
        MOV dy,AX    //day
     END;
     DosError:=0;
     year:=y;
     month:=m;
     day:=dy;
END;

PROCEDURE UnpackTime(Time: Longint; var DT: DateTime);
VAR
    y,m,dy,h,mi,s:WORD;
BEGIN
     ASM
        MOV AX,Time+2
        MOV CL,9
        SHR AX,CL
        ADD AX,1980
        MOV y,AX
        MOV AX,Time+2
        MOV CL,5
        SHR AX,CL
        AND AX,15
        MOV m,AX
        MOV AX,Time+2
        AND AX,31
        MOV dy,AX
        MOV AX,Time
        MOV CL,11
        SHR AX,CL
        MOV h,AX
        MOV AX,Time
        MOV CL,5
        SHR AX,CL
        AND AX,63
        MOV mi,AX
        MOV AX,Time
        AND AX,31
        SHL AX,1
        MOV s,AX
     END;
     DosError:=0;
     DT.year:=y;
     DT.month:=m;
     DT.day:=dy;
     DT.hour:=h;
     DT.min:=mi;
     DT.sec:=s;
     DT.hundredths:=0;
END;

{Martin lf}
function ExtendedOfLongword (lw : longword) : extended;
  type
    longwordhack = record case Integer of 0 : (low, high : word); 1 : (lw : longword); end;
  var
    lwh : longwordhack;
  begin
    lwh.lw := lw;
    result := extended (65536.0) * lwh.high + lwh.low;
  end;

procedure ProceedSearchrec (var F : searchrec);
  {used by FindFirst and FindNext}
  var
  {$ifdef os2}
    tt : longword;
  {$endif}
  {$ifdef win32}
    Actual:FILETIME;
    date,time:Word;
  {$endif}
  begin
    {$ifdef os2}
    if F.OS2longfilesupport then begin
      tt:=F.SearchRecInternL.fdateLastWrite;
      f.Time:=(tt SHL 16)+F.SearchRecInternL.ftimeLastWrite;
      {if long file support and long file and the programmer has not used the "floatSize" extension,
       show the biggest possible size: longword}
      if F.SearchRecInternL.cbFile.high > 0 then
        f.Size := 1 {1 bytes = error}
      else
        f.Size:=F.SearchRecInternL.cbFile.low;
      {longlong: low : longword; high : longint;}
      f.floatSize := extended(65536.0) * 65536.0 * F.SearchRecInternL.cbFile.high
                   + ExtendedOfLongword (F.SearchRecInternL.cbFile.low);
      f.Attr:=F.SearchRecInternL.AttrFile;
      f.Name:=F.SearchRecInternL.achName;
    end
    else begin
      tt:=F.SearchRecIntern.fdateLastWrite;
      f.Time:=(tt SHL 16)+F.SearchRecIntern.ftimeLastWrite;
      f.Size:=F.SearchRecIntern.cbFile;
      f.floatSize := ExtendedOfLongword (F.SearchRecIntern.cbFile);//extended(1.0) * F.SearchRecIntern.cbFile; {Martin lf}
      f.Attr:=F.SearchRecIntern.AttrFile;
      f.Name:=F.SearchRecIntern.achName;
    end;
   {$endif}
   {$ifdef win32}
   FileTimeToLocalFileTime(F.SearchRecIntern.ftLastWriteTime,Actual);
   FileTimeToDosDateTime(Actual,date,time);
   f.Time:=(date Shl 16) Or Time;

   f.Size:=F.SearchRecIntern.nFileSizeLow;

   {longlong: low : longword; high : longint;}
   f.floatSize := extended(65536.0) * 65536.0 * F.SearchRecIntern.nFileSizeHigh
                + ExtendedOfLongword (F.SearchRecIntern.nFileSizeLow);

   f.Attr:=F.SearchRecIntern.dwFileAttributes;
   f.Name:=CSTRING(F.SearchRecIntern.cFileName);
   {$endif}
  end;

FUNCTION FindFirst(Path: PathStr; Attr: LongWord; var F: SearchRec):LONGINT;
VAR
    c:CSTRING;
    {$IFDEF OS2}
    count:LONGWORD;
    {$ENDIF}
BEGIN
     c:=Path;
     DosError:=0;
     {$IFDEF OS2}
     F.HDir:=-1;  {HDIR_CREATE}
     count:=1;

     {Martin lf}
     DosError:=DosFindFirst(c,F.Hdir,Attr,F.SearchRecInternL,sizeof(FILEFINDBUF3L),count,FIL_STANDARDL);
     F.OS2longfilesupport := DosError = 0;//<> ERROR_INVALID_PARAMETER;
     {On old OS/2 systems, it should return 87 = ERROR_INVALID_PARAMETER, but it does return 124. ????}
     if not F.OS2longfilesupport then begin
       {perhaps an old OS/2 system is here without long file support! Warp4 < FP15,
        so run the old structure,
        or no files are here}
       DosError:=DosFindFirst(c,F.Hdir,Attr,F.SearchRecIntern,sizeof(FILEFINDBUF3),count,FIL_STANDARD);
     end;

     IF ((DosError<>0)or(Count=0)) THEN
     BEGIN
          IF DosError=0 THEN DosError:=18;
          FindClose(F);
          result:=DosError;
          exit;
     END;

     {$ENDIF}
     {$IFDEF Win32}
     F.InternalAttr:=Attr;
     F.HDir:=FindFirstFile(c,F.SearchRecIntern);
     IF F.HDir=INVALID_HANDLE_VALUE THEN
     BEGIN
          DosError:=18;
          result:=DosError;
          exit;
     END;
     WHILE F.SearchRecIntern.dwFileAttributes AND F.InternalAttr=0 DO
     BEGIN
          IF FindNextFile(F.HDir,F.SearchRecIntern)=FALSE THEN
          BEGIN
               WinBase.FindClose(F.HDir);
               DosError:=18;
               result:=DosError;
               exit;
          END;
     END;
     {$ENDIF}
     ProceedSearchrec (F);
     result:=DosError;
END;

FUNCTION FindNext(var F: SearchRec):LONGINT;
    {$IFDEF OS2}
VAR
    count,tt:LONGWORD;
    {$ENDIF}
    {$IFDEF WIN32}
VAR    
    Actual:FILETIME;
    date,time:Word;
    {$ENDIF}
BEGIN
     DosError:=0;
     {$IFDEF OS2}
     Count:=1;
     if F.OS2longfilesupport then
       DosError:=DosFindNext(F.Hdir,F.SearchRecInternL,sizeof(FILEFINDBUF3L),count)
     else
       DosError:=DosFindNext(F.Hdir,F.SearchRecIntern,sizeof(FILEFINDBUF3),count);
     IF ((DosError<>0)or(Count=0)) THEN
     BEGIN
          IF DosError=0 THEN DosError:=18;
          FindClose(F);
          result:=DosError;
          exit;
     END;

     {$ENDIF}
     {$IFDEF Win32}
     IF FindNextFile(F.HDir,F.SearchRecIntern)=FALSE THEN
     BEGIN
          WinBase.FindClose(F.HDir);
          DosError:=18;
          result:=DosError;
          exit;
     END;
     WHILE F.SearchRecIntern.dwFileAttributes AND F.InternalAttr=0 DO
     BEGIN
          IF FindNextFile(F.HDir,F.SearchRecIntern)=FALSE THEN
          BEGIN
               WinBase.FindClose(F.HDir);
               DosError:=18;
               result:=DosError;
               exit;
          END;
     END;
     {$ENDIF}

     ProceedSearchrec (F);
     result:=DosError;
END;

PROCEDURE FindClose(var F: SearchRec);
BEGIN
     {$IFDEF OS2}
     DosFindClose(F.HDir);
     {$ENDIF}
     {$IFDEF Win32}
     WinBase.FindClose(F.HDir);
     {$ENDIF}
     F.HDir:=0;
END;

FUNCTION DosExitCode(SessId:LONGWORD):LONGWORD;
{$IFDEF OS2}
VAR
   rc:LONGWORD;
   Status:STATUSDATA;
   return:ExecResultCode;
{$ENDIF}
BEGIN
  {$IFDEF OS2}
  IF ExecViaSession THEN
    BEGIN
      Status.length:=6;
      Status.SelectInd:=0;
      Status.BondInd:=0;
      try
        rc:=DosSelectSession(SessID);
      except
        rc:=0;
      end;
      While (rc<>ERROR_SMG_GRP_NOT_FOUND) DO
        Begin
          SysSleep(100);
          try    // Es kommt bei Warp 3 manchmal zu einem Exception.
            rc:=DosSetSession(SessID,Status);
          except
            rc:=ERROR_SMG_GRP_NOT_FOUND;
          end;
        End;
      Result:=0;
    END
  ELSE
  BEGIN
    IF LastExecResult=0 THEN
      BEGIN
        DosWaitChild(DCWA_PROCESS,DCWW_WAIT,return,SessId,SessId);
        LastExecResult:=return.CodeResult;
        Result:=return.CodeResult;
      END
    ELSE Result:=LastExecResult;
  END;
  {$ENDIF}
  {$IFDEF Win32}
  Repeat
    GetExitCodeProcess(SessId,Result);
    If Result<>STILL_ACTIVE Then
    Begin
      Result:=0;
      break;
    End;

    //Delay 50ms
    ASM
      PUSHL 50
      CALLDLL Kernel32,'Sleep'
    END;
  Until False;
  {$ENDIF}
END;

Function getProgramFromUrl(Const url : String; Var urlProgram : tFilename) : Boolean;

Var pdb   : Byte;
    UrlTyp: String;
    Path  : tFilename;

Begin
  UrlProgram:='';
  pdb:=pos(':',url);
  if pdb=2 then
    Begin
      UrlProgram:=url;
      result:=false;
      exit;
    end;

  result:=true;
  UrlTyp:=UpperCase(Copy(url, 1, pdb-1));
  if UrlTyp='HTTP' then
    urlProgram:=goSysInfo.SysAppInfo.DefaultBrowser
  else if UrlTyp='FTP' then
    urlProgram:=goSysInfo.SysAppInfo.DefaultBrowser
  else
    Begin
      urlProgram:=url;
      exit;    // Damit der Pfad nicht gendert wird
    end;
  path:=ExtractFilePath(urlProgram);
  path[0]:=chr(ord(path[0])-1);
  chdir(path);
End;


FUNCTION Exec(CONST Path: PathStr; CmdLine: STRING):LONGWORD;
type tdata = record
             d1: word;
             d2: word
           end;
VAR
    {$IFDEF OS2}
    aStartData:STARTDATA;
    ObjectBuffer:CSTRING;
    SessID:LONGWORD;
    SessPID:PID;
    eresult:ExecResultCode;

    tib:PTIB;
    pib:PPIB;
    QueueHandle:HQUEUE;
    PIDS: STRING;
    QUE_NAME:CSTRING;

    Request:REQUESTDATA;         /* Request-identification data */
    DataLength:ULONG;            /* Length of element received */
    DataAddress:POINTER;         /* Address of element received */
    ElementCode:ULONG;           /* Request a particular element */
    NoWait:BOOL;                 /* No wait if queue is empty */
    ElemPriority:BYTE;           /* Priority of element received */

    SEM_NAME:CSTRING;
    SemHandle:HEV;               /* Semaphore handle */
    flAttr:ULONG;                /* Creation attributes */
    fState:BOOLEAN;              /* Initial state of semaphore */
    ulPostCt:LONGWORD;           /* Current post count for the semaphore */

    Queue: QMSG;                  { Message-Queue }
    ahab: hab;

    rc:APIRET;                   /* Return code */
    rdata: ^tdata;
    {$ENDIF}
    {$IFDEF Win32}
    aStartData:StartupInfo;
    aProcessInfo:PROCESS_INFORMATION;
    {$ENDIF}
    c,c1: CSTRING;
    prg : String;
    inh : Word;

BEGIN
  Result := 0; //session id

// Link-Support
  if (LinkSupport) and (getProgramFromUrl(path, prg))
    then
      Begin
        c  :=prg;
        c1 :=path+' '+cmdline;
{$IFDEF OS2}
        inh:=SSF_INHERTOPT_PARENT;
{$ENDIF}
      End
    else
      Begin
        c  :=Path;
        c1 :=CmdLine;
{$IFDEF OS2}
        inh:=SSF_INHERTOPT_SHELL;
{$ENDIF}
      End;

// Aufruf des Programmes
  {$IFDEF OS2}
  IF ExecViaSession THEN
  BEGIN
       IF NOT AsynchExec THEN
       BEGIN
         DosGetInfoBlocks(tib,pib);
         IF pib=NIL THEN raise EProcessTerm.Create('Can''t retrieve process-id')
         ELSE str(pib^.pib_ulpid,PIDS);
         QUE_NAME:='\QUEUES\TERMQ\'+PIDS+#0;
         rc := DosCreateQueue(QueueHandle,QUE_FIFO OR QUE_CONVERT_ADDRESS,QUE_NAME);
         if rc<>0 THEN raise EProcessTerm.Create('Can''t create exec termination-Queue');
         aStartData.TermQ:=@QUE_NAME;
       END
       ELSE aStartData.TermQ:=NIL;

       aStartData.Length:=sizeof(STARTDATA);
       aStartData.Related:=SSF_RELATED_CHILD;
       aStartData.FgBg:=SSF_FGBG_BACK;
       aStartData.TraceOpt:=SSF_TRACEOPT_NONE;
       aStartData.PgmTitle:=@c;
       aStartData.PgmName:=@c;
       aStartData.PgmInputs:=@c1;
       aStartData.Environment:=NIL;
       aStartData.InheritOpt:=inh;
       aStartData.SessionType:=SSF_TYPE_DEFAULT;
       aStartData.IconFile:=NIL;
       aStartData.PgmHandle:=0;
       if Exec_Visible
         then aStartData.PgmControl:=SSF_CONTROL_VISIBLE
         else aStartData.PgmControl:=SSF_CONTROL_INVISIBLE;
       aStartData.InitXPos:=0;
       aStartData.InitYPos:=0;
       aStartData.InitXSize:=0;
       aStartData.InitYSize:=0;
       aStartData.Reserved:=0;
       aStartData.ObjectBuffer:=@ObjectBuffer;
       aStartData.ObjectBuffLen:=256;

       rc:=DosStartSession(aStartData,SessId,SessPid);

       ExecSessPid:=SessPID;

       IF rc<>0 THEN
       BEGIN
         DosError:=rc;
         IF NOT AsynchExec THEN
         BEGIN
             rc := DosCloseQueue(QueueHandle);
             if rc<>0 THEN raise EProcessTerm.Create('Can''t close exec termination-Queue');
         END;
         exit;
       END;

       DosSelectSession(SessID);
       IF NOT AsynchExec THEN
       BEGIN
         IF ApplicationType<>cApplicationType_GUI THEN
         BEGIN
           Request.pid := pib^.pib_ulpid;
           ElementCode := 0;
           NoWait := FALSE;
           SemHandle := 0;
           rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
           if rc<>0 THEN raise EProcessTerm.Create('Can''t read termination-Queue');
           rdata:=DataAddress;
           Result:=rdata^.d2;
           rc := DosFreeMem(DataAddress);
           if rc<>0 THEN raise EProcessTerm.Create('Can''t free QueueData');
           rc := DosCloseQueue(QueueHandle);
           if rc<>0 THEN raise EProcessTerm.Create('Can''t close termination-Queue');
         END
         ELSE
         BEGIN
           SEM_NAME:='\SEM32\TERMQ\'+PIDS+#0;
           flAttr := 0;
           fState := FALSE;
           rc := DosCreateEventSem(SEM_NAME,SemHandle,flAttr,fState);
           if rc<>0 THEN raise EProcessTerm.Create('Can''t create event-semaphore');
           Request.pid := pib^.pib_ulpid;
           ElementCode := 0;
           NoWait := TRUE;
           ahab :=  AppHandle; //WinQueryAnchorBlock(1);
           ulPostCt:=0;
           rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
           IF (rc<>0)AND(rc<>342) THEN raise EProcessTerm.Create('Can''t read termination-Queue');
           WHILE WinGetMsg(ahab,Queue,0,0,0) DO
           BEGIN
             rc := DosQueryEventSem(SemHandle, ulPostCt);
             IF rc<>0 THEN raise EProcessTerm.Create('Can''t query event-semaphore');
             IF ulPostCt>0 THEN BREAK;
             WinDispatchMsg(ahab,Queue);
           END;

           rc := DosCloseEventSem(SemHandle);
           IF rc<>0 THEN raise EProcessTerm.Create('Can''t close event-semaphore');
           rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
           IF rc<>0 THEN raise EProcessTerm.Create('Can''t read termination-Queue');
           rdata:=DataAddress;
           Result:=rdata^.d2;
           rc := DosFreeMem(DataAddress);
           IF rc<>0 THEN raise EProcessTerm.Create('Can''t free QueueData');
           rc := DosCloseQueue(QueueHandle);
           IF rc<>0 THEN raise EProcessTerm.Create('Can''t close termination-Queue');
         END;
       END
       ELSE Result:=SessID;
  END
  ELSE
  BEGIN
       LastExecResult:=0;
       IF AsynchEXEC THEN DosExecPgm(@ObjectBuffer,256,2,c1,
                                     NIL,eresult,c)
       ELSE
       BEGIN
            c1:=#0+c1;
            DosExecPgm(@ObjectBuffer,256,0,c1,
                       NIL,eresult,c);
            LastExecresult:=eresult.CodeResult;
       END;
       Result:=LastExecResult;
  END;
  {$ENDIF}
  {$IFDEF Win32}
  DosError:=0;
  FillChar(aStartData,sizeof(aStartData),0);
  aStartData.cb:=sizeof(aStartData);
  if Exec_Visible=false then
    begin
      aStartData.dwFlags:=STARTF_USESHOWWINDOW;
      aStartData.wShowWindow:=SW_HIDE;
    End;
  C1:=C+' '+C1;
  IF not CreateProcess(C,C1,NIL,NIL,FALSE,CREATE_NEW_CONSOLE OR
                       NORMAL_PRIORITY_CLASS,NIL,NIL,
                       aStartData,aProcessInfo) THEN
    BEGIN
      DosError:=1;
      exit;
    END;
  Result:=aProcessInfo.hProcess;
  if not AsynchEXEC then
    Begin
      CloseHandle(aProcessInfo.hThread);
      if WaitForSingleObject(Result, Infinite)=Wait_Failed then
        Begin
          DosError:=1;
          exit;
        End;
      CloseHandle(Result);
    End;
  {$ENDIF}
END;



FUNCTION GetFAttr(VAR F:FILE; var Attr: LongWord):LONGINT;
VAR
    {$IFDEF OS2}
    s:FILESTATUS3;
    size:LONGWORD;
    savemode:ULONG;
    {$ENDIF}
    {$IFDEF Win32}
    Name:CSTRING;
    {$ENDIF}
    ff:^FileRec;
    b:BOOLEAN;
BEGIN
     b:=RaiseIoError;
     ff:=@f;
     DosError:=0;
     {$IFDEF OS2}
     savemode:=FileMode;
     filemode:=fmInput;
     {$i-}
     reset(f);
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
          RaiseIOError:=b;
          DosError:=InOutRes;
          result:=DosError;
          filemode := savemode;
          exit;
     END;
     size:=sizeof(FILESTATUS3);
     DosError:=DosQueryFileInfo(ff^.Handle,FIL_STANDARD,s,size);
     IF DosError=0 THEN
     BEGIN
          Attr:=s.attrFile;
     END
     ELSE Attr:=0; {invalid}
     {$i-}
     close(f);
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
          RaiseIOError:=b;
          DosError:=InOutRes;
          result:=DosError;
          filemode := savemode;
          exit;
     END;
     filemode:=SaveMode;
     {$ENDIF}
     {$IFDEF Win32}
     name:=ff^.Name;
     Attr:=GetFileAttributes(Name);
     IF Attr=$ffffffff THEN DosError:=GetLastError
     ELSE DosError:=0;
     {$ENDIF}
     RaiseIOError:=b;
     result:=DosError;
END;

FUNCTION SetFAttr(VAR F:FILE; Attr: LongWord):LONGINT;
VAR
    {$IFDEF OS2}
    s:FILESTATUS3;
    size:LONGWORD;
    {$ENDIF}
    Name:CSTRING;
    ff:^FileRec;
    b:BOOLEAN;
BEGIN
     b:=RaiseIOError;
     ff:=@f;
     if ff^.Flags<>$6666 then
     BEGIN
       RaiseIOError:=b;
       DosError:=3;
       result:=DosError;
       exit;
     END;
     DosError:=0;
     Name:=ff^.Name;
     {$IFDEF OS2}
     size:=sizeof(FILESTATUS3);
     DosError:=DosQueryPathInfo(Name,FIL_STANDARD,s,size);
     IF DosError=0 THEN
     BEGIN
          s.attrFile:=Attr;
          DosError:=DosSetPathInfo(Name,FIL_STANDARD,s,size,DSPI_WRTTHRU);
     END;
     {$ENDIF}
     {$IFDEF Win32}
     IF not SetFileAttributes(Name,Attr) THEN DosError:=GetLastError
     ELSE DosError:=0;
     {$ENDIF}
     RaiseIOError:=b;
     result:=DosError;
END;


FUNCTION GetFTime2(VAR F:FILE; VAR year,month,day,Hours,Minutes,Secs:WORD):LONGINT;
VAR
    {$IFDEF OS2}
    s:FILESTATUS3;
    size:LONGWORD;
    {$ENDIF}
    {$IFDEF Win32}
    LastAccess,Creation,LastWrite,Actual:FILETIME;
    {$ENDIF}
    date,time:WORD;
    ff:^FileRec;
BEGIN
     ff:=@f;
     DosError:=0;
     {$IFDEF OS2}
     size:=sizeof(FILESTATUS3);
     DosError:=DosQueryFileInfo(ff^.Handle,1,s,size);
     IF DosError=0 THEN
     BEGIN
          date:=s.fdateLastWrite;
          time:=s.ftimelastwrite;

          UnpackDateIntern(Date,year,month,day);
          UnpackTimeIntern(Time,hours,minutes,Secs);
          Secs:=Secs*2;
     END
     ELSE
     BEGIN
          day:=0;
          month:=0;
          year:=0;
          Hours:=0;
          Minutes:=0;
          Secs:=0;
     END;
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=0;
     IF not GetFileTime(ff^.Handle,Creation,LastAccess,LastWrite) THEN
     BEGIN
          day:=0;
          month:=0;
          year:=0;
          Hours:=0;
          Minutes:=0;
          Secs:=0;
          DosError:=GetLastError;
          exit;
     END;

     FileTimeToLocalFileTime(LastWrite,Actual);
     FileTimeToDosDateTime(Actual,date,time);

     UnpackDateIntern(Date,year,month,day);
     UnpackTimeIntern(Time,hours,minutes,Secs);
     Secs:=Secs*2;
     {$ENDIF}
     result:=DosError;
END;


FUNCTION SetFTime2(VAR F:FILE; year,month,day,Hours,Minutes,Secs:Word):LONGINT;

VAR ff:^FileRec;

{$IFDEF OS2}
    s:FILESTATUS3;
    size:LONGWORD;
    time,date:Word;
    TwoSecs:WORD;
{$ENDIF}
{$IFDEF Win32}
    LastAccess,Creation,LastWrite:FILETIME;
    time,date:Word;
    TwoSecs:WORD;
{$ENDIF}

label l;
BEGIN
     ff:=@f;
     DosError:=0;
     {$IFDEF OS2}
     TwoSecs:=Secs DIV 2;
     IF ((Month>12)or(Month=0)) THEN
     BEGIN
l:
          DosError:=1;
          result:=DosError;
          exit;
     END;
     IF ((Day>32)or(day=0)) THEN goto l;
     IF Hours>24 THEN goto l;
     IF Minutes>60 THEN goto l;
     IF TwoSecs>30 THEN goto l;
     size:=sizeof(FILESTATUS3);
     DosError:=DosQueryFileInfo(ff^.Handle,1,s,size);
     IF DosError=0 THEN
     BEGIN
          Date:=PackDateIntern(year,month,day);
          Time:=PackTimeIntern(Hours,Minutes,TwoSecs);

          s.fdatelastwrite:=date;
          s.ftimeLastWrite:=time;
          DosError:=DosSetFileInfo(ff^.Handle,1,s,size);
     END;
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=0;
     IF not GetFileTime(ff^.Handle,Creation,LastAccess,LastWrite) THEN
     BEGIN
          DosError:=GetLastError;
          result:=DosError;
          exit;
     END;

     TwoSecs:=Secs DIV 2;
     IF ((Month>12)or(Month=0)) THEN
     BEGIN
l:
          DosError:=1;
          result:=DosError;
          exit;
     END;
     IF ((Day>32)or(day=0)) THEN goto l;
     IF Hours>24 THEN goto l;
     IF Minutes>60 THEN goto l;
     IF TwoSecs>30 THEN goto l;

     Date:=PackDateIntern(year,month,day);
     Time:=PackTimeIntern(Hours,Minutes,TwoSecs);

     DosDateTimeToFileTime(date,time,Creation);

     IF not SetFileTime(ff^.Handle,Creation,LastAccess,LastWrite) THEN
     BEGIN
          DosError:=GetlastError;
          result:=DosError;
          exit;
     END;
     {$ENDIF}
     result:=DosError;
END;

FUNCTION GetFTime(VAR f:FILE;VAR Time:LONGINT):LONGINT;

VAR DT:DateTime;
    m,d,h,i,s:WORD;

BEGIN
  result:=GetFTime2(f,DT.year,m,d,h,i,s);
  DT.month:=m;
  DT.day:=d;
  DT.hour:=h;
  DT.min:=i;
  DT.sec:=s;
  PackTime(DT,Time);
END;

FUNCTION SetFTime(VAR f:FILE;Time:LONGINT):LONGINT;
VAR
   DT:DateTime;
BEGIN
     UnpackTime(time,DT);
     {DT.sec:=DT.sec DIV 2;}
     result:=SetFTime2(f,DT.year,DT.month,DT.day,DT.hour,DT.min,DT.sec);
END;

FUNCTION DiskFree(Drive: Byte): LongWord;

VAR s : LONGWORD;
    {$IFDEF OS2}
    a:FSALLOCATE;
    d:LongWord;
    {$ENDIF}
    {$IFDEF Win32}
    c:CSTRING;
    sec,clust,freeclust:LONGWORD;
    {$ENDIF}

BEGIN
     {$IFDEF OS2}
     s:=sizeof(FSALLOCATE);
     d:=Drive;
     DosError:=DosQueryFSInfo(d,1,a,s);
     IF DosError=0 THEN s:=a.cSectorUnit*a.cUnitAvail*a.cbSector
     ELSE s:=0;
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=0;
     IF Drive=0 THEN
     BEGIN
          IF not GetDiskFreeSpace(NIL,s,sec,freeclust,clust) THEN
          BEGIN
               DosError:=GetLastError;
               result:=0;
               exit;
          END;
     END
     ELSE
     BEGIN
          c:=chr(ord('A')+(Drive-1))+':\';
          IF not GetDiskFreeSpace(c,s,sec,freeclust,clust) THEN
          BEGIN
               DosError:=GetLastError;
               result:=0;
               exit;
          END;
     END;
     s:=s*sec*freeclust;
     {$ENDIF}
     DiskFree:=s;
END;

FUNCTION DiskSize(Drive: Byte): LongWord;

VAR s : LONGWORD;

    {$IFDEF OS2}
    a: FSALLOCATE;
    d: LongWord;
    {$ENDIF}
    {$IFDEF Win32}
    sec,clust,freeclust:LONGWORD;
    c:CSTRING;
    {$ENDIF}

BEGIN
     {$IFDEF OS2}
     s:=sizeof(FSALLOCATE);
     d:=Drive;
     DosErrorAPI(0); /* Action flag for disable */
     DosError:=DosQueryFSInfo(d,1,a,s);
     DosErrorAPI(1); /* Action flag for enable */
     IF DosError=0 THEN s:=a.cSectorUnit*a.cUnit*a.cbSector
     ELSE s:=$FFFFFFFF;
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=0;
     IF Drive=0 THEN
     BEGIN
          IF not GetDiskFreeSpace(NIL,s,sec,freeclust,clust) THEN
          BEGIN
               DosError:=GetLastError;
               result:=$FFFFFFFF;
               exit;
          END;
     END
     ELSE
     BEGIN
          c:=chr(ord('A')+(Drive-1))+':\';
          IF not GetDiskFreeSpace(c,s,sec,freeclust,clust) THEN
          BEGIN
               DosError:=GetLastError;
               result:=$FFFFFFFF;
               exit;
          END;
     END;
     s:=s*sec*clust;
     {$ENDIF}
     DiskSize:=s;
END;

FUNCTION EnvStr(Index:LONGINT):String;
VAR
  P:^CSTRING;
  Count: Integer;
BEGIN
  ASM
     MOV EAX,SYSTEM.EnvStart
     MOV P,EAX
  END;
  result:= '';
  IF ((Index>0)AND(P<>NIL)) THEN
  BEGIN
       Count := 1;
       WHILE ((Count<Index)AND(P^[0]<>#0)) DO
       BEGIN
            WHILE P^[1]<>#0 DO inc(P);
            inc(P);
            inc(P);
            Inc(Count);
       END;
       EnvStr := P^;
  END;
END;

FUNCTION EnvCount:LONGINT;

BEGIN
  Result:=goSysInfo.EnvCount;
END;

FUNCTION GetEnv(CONST Env:String):String;

BEGIN
  Result:=goSysInfo.Env[Env];
END;

FUNCTION GetVerify(VAR Verify: Boolean):LONGINT;

{$IFDEF OS2}
VAR v:LONGWORD;
{$ENDIF}

BEGIN
     {$IFDEF OS2}
     DosError:=DosQueryVerify(v);
     Verify:=v<>0;
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=1;   //not supported
     {$ENDIF}
     result:=DosError;
END;

FUNCTION SetVerify(Verify: Boolean):LONGINT;

{$IFDEF OS2}
VAR v:LONGWORD;
{$ENDIF}

BEGIN
     {$IFDEF OS2}
     v:=BYTE(Verify);
     DosError:=DosSetVerify(v);
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=1;   //not supported
     {$ENDIF}
     result:=DosError;
END;

FUNCTION DosVersion:LongWord;

{$IFDEF OS2}
VAR MinorVersion,MajorVersion:LONGWORD;
{$ENDIF}

BEGIN
     {$IFDEF OS2}
     DosQuerySysInfo(QSV_VERSION_MAJOR,QSV_VERSION_MAJOR,MajorVersion,4);
     DosQuerySysInfo(QSV_VERSION_MINOR,QSV_VERSION_MINOR,MinorVersion,4);
     DosVersion:=MajorVersion OR MINORVERSION SHL 8;
     {$ENDIF}
     {$IFDEF Win32}
     result:=GetVersion;
     {$ENDIF}
END;

FUNCTION GetDate(var Year,Month,Day,DayOfWeek: Word):LONGINT;
{$IFDEF OS2}
VAR d:DateTime;
{$ENDIF}
{$IFDEF Win32}
VAR d:SYSTEMTIME;
{$ENDIF}
BEGIN
     {$IFDEF OS2}
     DosGetDateTime(d);
     DosError:=0;
     Year:=d.year;
     Month:=d.month;
     Day:=d.Day;
     DayofWeek:=d.Weekday;
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=0;
     GetLocalTime(d);
     Year:=d.wYear;
     Month:=d.wMonth;
     Day:=d.wDay;
     DayofWeek:=d.wDayOfWeek;
     {$ENDIF}
     result:=DosError;
END;

FUNCTION SetDate(Year,Month,Day: Word):LONGINT;
{$IFDEF OS2}
VAR d:DateTime;
{$ENDIF}
{$IFDEF Win32}
VAR d:SYSTEMTIME;
{$ENDIF}
BEGIN
     {$IFDEF OS2}
     DosGetDateTime(d);
     DosError:=0;
     d.year:=Year;
     d.month:=Month;
     d.day:=day;
     d.Weekday:=0;
     DosSetDateTime(d);
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=0;
     GetLocalTime(d);
     d.wYear:=Year;
     d.wMonth:=Month;
     d.wDay:=Day;
     d.wDayOfWeek:=0;
     SetLocalTime(d);
     {$ENDIF}
     result:=DosError;
END;

FUNCTION GetTime(var Hour,Minute,Second,Sec100: Word):LONGINT;
{$IFDEF OS2}
VAR d:DateTime;
{$ENDIF}
{$IFDEF Win32}
VAR d:SYSTEMTIME;
{$ENDIF}
BEGIN
     {$IFDEF OS2}
     DosGetDateTime(d);
     DosError:=0;
     Hour:=d.hour;
     Minute:=d.min;
     Second:=d.Sec;
     Sec100:=d.Hundredths;
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=0;
     GetLocalTime(d);
     Hour:=d.wHour;
     Minute:=d.wMinute;
     Second:=d.wSecond;
     Sec100:=d.wMilliseconds Div 10;
     {$ENDIF}
     result:=DosError;
END;

FUNCTION SetTime(Hour,Minute,Second,Sec100: Word):LONGINT;
{$IFDEF OS2}
VAR d:DateTime;
{$ENDIF}
{$IFDEF Win32}
VAR d:SYSTEMTIME;
{$ENDIF}
BEGIN
     {$IFDEF OS2}
     DosGetDateTime(d);
     DosError:=0;
     d.Hour:=Hour;
     d.Min:=Minute;
     d.Sec:=Second;
     d.Hundredths:=Sec100;
     DosSetDateTime(d);
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=0;
     GetLocalTime(d);
     d.wHour:=Hour;
     d.wMinute:=Minute;
     d.wSecond:=Second;
     d.wMilliseconds:=sec100*10;
     SetLocalTime(d);
     {$ENDIF}
     result:=DosError;
END;

FUNCTION CompareFileTimes(First,Second:STRING):BYTE;
VAR f1,f2:FILE;
    result:BYTE;
    year1,month1,day1,Hours1,Minutes1,Secs1:WORD;
    year2,month2,day2,Hours2,Minutes2,Secs2:WORD;
    b:BOOLEAN;
Label l;
BEGIN
     b:=RaiseIOError;
     result:=F_ERROR;
     assign(f1,first);
     {$i-}
     reset(f1,1);
     {$i+}
     IF InOutRes<>0 THEN goto l;
     GetFTime2(f1,year1,month1,day1,Hours1,Minutes1,Secs1);
     IF DosError<>0 THEN
     BEGIN
          {$i-}
          Close(f1);
          {$i+}
          IF InOutRes<>0 THEN
          BEGIN
               RaiseIOError:=b;
               CompareFileTimes:=result;
               exit;
          END;
          goto l;
     END;
     {$i-}
     Close(f1);
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
          RaiseIOError:=b;
          CompareFileTimes:=result;
          exit;
     END;

     assign(f2,second);
     {$i-}
     reset(f2,1);
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
          RaiseIOError:=b;
          CompareFileTimes:=result;
          exit;
     END;
     GetFTime2(f2,year2,month2,day2,Hours2,Minutes2,Secs2);
     IF DosError<>0 THEN
     BEGIN
          {$i-}
          Close(f2);
          {$i+}
          IF InOutRes<>0 THEN
          BEGIN
               RaiseIOError:=b;
               CompareFileTimes:=result;
               exit;
          END;
          goto l;
     END;
     {$i-}
     Close(f2);
     {$i+}
     IF InOutRes<>0 THEN
     BEGIN
          RaiseIOError:=b;
          CompareFileTimes:=result;
          exit;
     END;

     IF year1=year2 THEN
     BEGIN
          IF month1=month2 THEN
          BEGIN
               IF Day1=Day2 THEN
               BEGIN
                    IF Hours1=Hours2 THEN
                    BEGIN
                         IF Minutes1=Minutes2 THEN
                         BEGIN
                              IF Secs1=Secs2 THEN result:=F_EQUAL
                              ELSE
                              BEGIN
                                   IF Secs1>Secs2 THEN Result:=F_FIRST_GREATER
                                   ELSE Result:=F_SECOND_GREATER;
                              END;
                         END
                         ELSE
                         BEGIN
                              IF Minutes1>Minutes2 THEN Result:=F_FIRST_GREATER
                              ELSE Result:=F_SECOND_GREATER;
                         END;
                    END
                    ELSE
                    BEGIN
                         IF Hours1>Hours2 THEN Result:=F_FIRST_GREATER
                         ELSE Result:=F_SECOND_GREATER;
                    END;
               END
               ELSE
               BEGIN
                    IF day1>day2 THEN Result:=F_FIRST_GREATER
                    ELSE Result:=F_SECOND_GREATER;
               END;
          END
          ELSE
          BEGIN
               IF month1>month2 THEN Result:=F_FIRST_GREATER
               ELSE Result:=F_SECOND_GREATER;
          END;
     END
     ELSE
     BEGIN
          IF year1>year2 THEN Result:=F_FIRST_GREATER
          ELSE Result:=F_SECOND_GREATER;
     END;

l:
     CompareFileTimes:=Result;
     RaiseIOError:=b;
END;

PROCEDURE Flush (VAR F:FILE);
VAR ff:^FileRec;
    Temp:LONGWORD;
    e:EInOutError;
    Adr:LongWord;
BEGIN
     ASM
        MOV EAX,[EBP+4]
        SUB EAX,5
        MOV Adr,EAX
     END;
     ff:=@F;
     IF ff^.Buffer<>NIL THEN
     BEGIN
          IF ff^.changed THEN
          BEGIN
               ff^.changed:=FALSE;
               ASM
                  //FileBlockIO(F,ff^.block,WriteMode,Temp);
                  PUSH DWORD PTR F
                  MOV EAX,ff
                  PUSH DWORD PTR [EAX].FileRec.Block
                  PUSHL 2
                  LEA EAX,Temp
                  PUSH EAX
                  CALLN32 SYSTEM.FileBlockIO
               END;
               IF InOutRes<>0 THEN
               BEGIN
                    IF RaiseIOError THEN
                    BEGIN
                         e.Create('Input/Output error (EInOutError)');
                         e.ErrorCode:=InOutRes;
                         e.CameFromRTL:=TRUE;
                         e.RTLExcptAddr:=POINTER(Adr);
                         RAISE e;
                    END
                    ELSE exit;
               END;
          END;
     END;
END;

BEGIN
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  27-Sep-02  WD         Ausbau der LINUX-Teile
  06-Okt-04  MV         Einbau der Konstante "Exec_Visible"
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  11-Dez-05  WD         Exec: Konstante "LinkSupport" eingebaut. Interpretieren von HTTP, FTP
  23-Dez-05  WD         Exec: AsynchEXEC auch fuer die Windows (Source von Toolbox).
  22-Jan-06  MV         Long file support > 2GB for findfirst, findnext, findclose. Changes marked with "Martin lf"
                             simply use searchrec.floatsize (: extended) instead of searchrec.size !!!
  26-May-06  MV         fexpand: does not touch network filenames anymore
  06-Jun-06  WD         Exec; Variable "Exec_Visible" wird auch in Windows beruecksichtigt.
  23-Jun-06  WD         OS/2, DosExitCode: Bei ExecViaSession=true und das System wartet auf Prozess-
                        Ende eine kleine Pause eingebaut, damit das System nich komplett steht.
}

Unit uSysFunc;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ WDSibyl Runtime Library (RTL)                                             บ
บ                                                                           บ
บ Diese Unit behinaltet diverse Systemfunktionen                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Interface

Uses uSysClass;

Function DLLExists(Const iDLLFileName: tFileName): Boolean;
// DLLExists - Indicates whether A DLL-File exists Or Not.

Procedure SysAsynchSleep(iMS : LongWord; iEventSemaphor : tcEventSemaphor);
// Wartet asynchron die in der "iMS"-Variable zeit (in Millisekunden).
// Nach dem Ablauf dieser Zeit wird der angegebene Semaphor gesetzt.

Function GetAssociation(FileType : String) : tFileName;
// Windows: Ermittelt zu einen Dateityp das zugeordnete Programm

Procedure SetAssociation(FileType : String; FileName : tFileName);
// Windows: Registriert zu einem Dateityp das zu startende Programm

Procedure DelAssociation(FileType : String);
// Windows: Deregestriert ein Dateityp

Function OpenObject(Filename : string) : boolean;
// Oeffnet ein Objekt


Implementation

Uses SysUtils, IniFiles;

{$IFDEF OS2}
Uses Os2Def, BseDos, PMWin,PMWP;
{$ENDIF}

{$IFDEF Win32}
Uses WinDef, WinUser, WinShell;
{$ENDIF}


{ ----------------------------------------------------------------------------- }

Function DLLExists(Const iDLLFileName: tFileName): Boolean;

var DLL : tcDLL;

Begin
  try
    DLL.Create(iDLLFileName);
    Result:=DLL.Handle<>0;
    DLL.Destroy;
  except
    Result:=false;
  end;
End;

{ ----------------------------------------------------------------------------- }

Procedure SysAsynchSleep(iMS : LongWord; iEventSemaphor : tcEventSemaphor);

{$IFDEF OS2}
var rc   : APIRet;
    Timer: HTimer;
{$ENDIF}


Begin
  if iEventSemaphor=nil then exit;
{$IFDEF OS2}
  rc:=DosAsyncTimer(iMS, iEventSemaphor.Handle, Timer);
{$ENDIF}
End;


Const cRegSoftwareClasses = 'Software\Classes';
      cShellOpenCmd       = '\shell\open\command';

Function GetAssociation(FileType : String) : tFileName;

var Reg : tcRegistry;
    FN  : String;
    p   : Byte;

Begin
  result:='';
  Reg.Create(taeKEY_LOCAL_MACHINE, cRegSoftwareClasses+'\'+FileType);
  FN:=reg.readString('',gRegStandard,'');
  Reg.Destroy;
  if FN<>'' then
    Begin
      Reg.Create(taeKEY_LOCAL_MACHINE, cRegSoftwareClasses+'\'+FN+cShellOpenCmd);
      Result:=reg.readString('',gRegStandard,'');
      Result:=copy(result,1,pos(' ',Result)-1);
      Reg.Destroy;
    End;
End;

Procedure SetAssociation(FileType : String; FileName : tFileName);

var Reg, Reg1: tcRegistry;
    FN       : String;

Begin
  if (length(FileType) = 0) or (length(FileName) = 0) then exit;
  FN:=extractFileName(FileName);
  reg.Create(taeKEY_LOCAL_MACHINE, cRegSoftwareClasses);
  Reg1:=reg.CreateSection(FileType);
  if Reg1<>nil then
    Begin
      Reg1.WriteString('',gRegStandard,FN);
      Reg1.Destroy;
      Reg1:=Reg.CreateSection(fn+cShellOpenCmd);
      Reg1.WriteString('',gRegStandard,FileName+' %1');
      Reg1.Destroy;
    End;
  reg.Destroy;
End;

Procedure DelAssociation(FileType : String);

var Reg : tcRegistry;
    FN  : String;

Begin
  if length(FileType) = 0 then exit;
  reg.Create(taeKEY_LOCAL_MACHINE, cRegSoftwareClasses+'\'+FileType);
  FN:=reg.readString('',gRegStandard,'');
  reg.Destroy;
  if FN<>'' then
    Begin
      reg.Create(taeKEY_LOCAL_MACHINE, cRegSoftwareClasses);
      reg.EraseSection(FileType);
      reg.EraseSection(FN+cShellOpenCmd);
      reg.Destroy;
    End;
End;

function OpenObject (Filename : string) : boolean;

var CSt : cstring;
    {$ifdef os2}
    hObj : HOBJECT;
    {$endif}
    {$ifdef win32}
    Hinst : HINSTANCE;
    {$endif}

begin
  //Application.Logwriteln ('OpenObject '+Filename);
  CSt := Filename;
  {$ifdef os2}
  //uses pmwin, pmwp;
  hObj := WinQueryObject(CSt);
  result := hObj <> 0;
  if result then
    WinOpenObject (hObj, OPEN_DEFAULT, true);
  {$endif}
  {$ifdef win32}
  Hinst := ShellExecute(HWND_DESKTOP, 'open', CSt, NIL, NIL, SW_SHOWNORMAL);
  result := Hinst > 32;
  {$endif}
end;

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  22-Apr-06  WD         Unit in das Projekt eingebaut
  09-Apr-07  MV/WD      Funktion OpenObject eingebaut
  02-Feb-09  WD         Unit uSysFunc erzeugt und die Funktionen aus uOSFunc uebernommen
}

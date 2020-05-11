Program MakeRTL;

{ Compilier-Reihenfolge
  MakeRTL		(Src_RTL+Src_RTL_OS+Src_RC)
  MakeTP70		(Src_RTL+Src_TP70)
  MakeSPCC		(Src_SPCC)
  MakeDB		(Src_DB)
  MakeCompnt		(Src_Compnt)
  MakeDialog		(Src_Dialog)
  MakeInternet		(Src_Inter)
  MakeMultiMedia	(Src_MM)
  MakeRest		(Src_TP70)

  MakeIDE		(?)
}
 

uses System;
 
{$IFDEF OS2}      
uses BSEDEV, BSEDOS, BSEERR, BSEEXCPT, BSETIB, BSEREGISTRY,
     BSESUB, BSEMOU, BSEKBD, BSEVIO,
     BSEKBDVIO32,

     DIVE, INTERNET,
     MMIO, OS2DEF, PMBITMAP, PMDEV, PMERR, PMGPI, PMHELP, PMSHL,
     PMSPL, PMSTDDLG, PMWIN, PMWP, PMWSOCK,
     SOM,
//     SERIALIO,
     SOCKAPI, Process;
{$ENDIF OS2}
                             
{$IFDEF WIN32}
uses COMMCTRL, COMMDLG, DDEML, MMSYSTEM, WINBASE, WINCON, WINDEF, WINGDI, WINERR,
     WINNT, WINUSER, WinADVAPI, WinSpool, WinShell, WinNetAPI;
{$ENDIF WIN32}
                              
Uses PMWINX,      { Zugfriff auf PMWINX (auch fuer Windows) }
     REXXSAA,     { Rexx bzw. Regina UnterstÅtzung }
     SYSUTILS,    { Diverse Funktionen }
     INIFiles,    { Bearbeitung von INI-Files }
     Color,       { Div. Farben }
     uString,     { Diverse String-Funktionen }
     uStream,     { Diverse Streamobjekte }

     uSysInfo,    { Diverse System-Infos }
     uSysClass,   { Diverse System-Klassen }
     uSysFunc,    { Diverse System-Funktionen }

     uDateTime,   { Datum/Uhrzeit-Klasse }
     uList,       { List-Klassen, Dynamisches Pointer-Array }
     uUnInstall,  { Install und DeInstall-Routinen }

     StrUtils,    { Diverse Funktionen } //RG 23-Apr-20
     uWebBrowser; { Diverse Browser-Funktionen } //RG 23-Apr-20              
Begin
End.
          
{ -- date -- -- from -- -- changes ----------------------------------------------
  08-Sep-04  WD         Die Unit PORT-IO aus dem Projekt ausgebaut. (Es gibt COMPNT/uSerialPort)
  26-Sep-04  WD         Verschieben von der Komponente tcJoystick von uJoystick in uSysClass
  16-Nov-04  WD         Die Unit LANGUAGE aus dem Projekt ausgebaut.
  11-Jun-05  WD         Rexx bzw. Regina UnterstÅtzung
  22-Apr-05  WD         Unit uOSFunc eingebaut.
  05-Mai-05  WD         Unit uExtension ausgebaut. (Konstanten sind nach uSysInfo gewandert)
  06-Mai-05  WD         Unit uLog ausgebaut. (tcLog ist jetzt in uSysClass)
  15-Mai-06  WD         Unit WinShell eingebaut
  10-Sep-06  WD         Unit WinNetAPI eingebaut
  25-Sep-06  WD/TB      Unit uUnInstall eingebaut
  12-Jun-07  WD         Unit SerialIO ausgebaut. (Es gibt uPorts im Verzeichnis Compnt)
  11-Feb-09  WD         Unit uOSFunc auf uSysFunc umbenannt.
  23-Apr-20  RG         Unit StrUtils und uWebBrowser eingebaut
  26-Apr-20  RG         optisch
}



{ Person:
Kuerzel Name              E-Mail
----------------------------------------------------------------------------
HO      Hitosi-Okubo
IV      Igor Vaskov       igor-vaskov@mtu-net.ru
KF      Kim Foder
MV      Martin Vieregg
PE      Peter Engels
RG      Rolf Gachnang
TB      Thomas Bohn
UJ      Uw Jacobs
WD      Wolfgang Draxler  wdsibyl@chello.at


----------------------------------------------------------------------------
}
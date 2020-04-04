{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for Win32                                     บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit WINSHELL;

Interface

Uses SysUtils;

Const CSIDL_DESKTOP                 = $00; // Verzeichnis des Desktop des Benutzers (oberste hierarchische Ebene)
      CSIDL_INTERNET                = $01;
      CSIDL_PROGRAMS                = $02; // Start-Programmverzeichnis
      CSIDL_CONTROLS                = $03; // Systemsteuerung  (Inhalt nicht darstellbar, Ergebnis: "Systemsteuerung")
      CSIDL_PRINTERS                = $04; // Drucker (Inhalt nicht darstellbar, Ergebnis: "Drucker")
      CSIDL_PERSONAL                = $05; // Verzeichnis der eigenen Dateien
      CSIDL_FAVORITES               = $06; // Verzeichnis der Favoriten des Internet-Browsers
      CSIDL_STARTUP                 = $07; // Verzeichnis des Autostart-Ordners des Benutzers (Inhalt nicht darstellbar)
      CSIDL_RECENT                  = $08; // Verzeichnis "Recent", zuletzt benutztes (Inhalt nicht darstellbar)
      CSIDL_SENDTO                  = $09; // Verzeichnis "SendTo" (kein Inhalt)
      CSIDL_BITBUCKET               = $0A; // Papierkorb (kein Inhalt, Ergebnis: "Papierkorb")
      CSIDL_STARTMENU               = $0B; // Verzeichnis des Startmenüs des Benutzers
      CSIDL_MY_DOCUMENTS            = $0C;
      CSIDL_MYMUSIC                 = $0D;
      CSIDL_MYVIDEO                 = $0E;
      CSIDL_DESKTOPDIRECTORY        = $10; // Verzeichnis des Desktop, nur mit Aktenkoffer
      CSIDL_DRIVES                  = $11; // Arbeitsplatz (alle Laufwerke, gemappte Netzlaufwerke, Systemsteuerung, Drucker; Ergebnis: Pfad oder "Arbeitsplatz" etc.)
      CSIDL_NETWORK                 = $12; // Netzwerkumgebung (Ergebnis: UNC-Pfad oder "Netzwerkumgebung")
      CSIDL_NETHOOD                 = $13; // Verzeichnis der Netzwerkumgebung des Benutzers (Inhalt nicht darstellbar)
      CSIDL_FONTS                   = $14; // Verzeichnis der Schriftarten (keine Unterverzeichnisse)
      CSIDL_TEMPLATES               = $15; // Verzeichnis ShellNew
      CSIDL_COMMON_STARTMENU        = $16; // Verzeichnis des Startmenues fuer alle Benutzer
      CSIDL_COMMON_PROGRAMS         = $17; // Verzeichnis von Startmenue/Programme für alle Benutzer
      CSIDL_COMMON_STARTUP          = $18; // Autostart-Verzeichnis fuer alle Benutzer (Inhalt nicht darstellbar)
      CSIDL_COMMON_DESKTOPDIRECTORY = $19; // Verzeichnis des Desktop fuer alle Benutzer
      CSIDL_APPDATA                 = $1A; // Verzeichnis der Anwendungsdaten des Benutzers
      CSIDL_PRINTHOOD               = $1B; // Verzeichnis der Druckumgebung des Benutzers
      CSIDL_LOCAL_APPDATA           = $1C;
      CSIDL_ALTSTARTUP              = $1D;
      CSIDL_COMMON_ALTSTARTUP       = $1E; // DBCS
      CSIDL_COMMON_FAVORITES        = $1F;
      CSIDL_INTERNET_CACHE          = $20;
      CSIDL_COOKIES                 = $21;
      CSIDL_HISTORY                 = $22;
      CSIDL_COMMON_APPDATA          = $23;
      CSIDL_WINDOWS                 = $24;
      CSIDL_SYSTEM                  = $25;
      CSIDL_PROGRAM_FILES           = $26;
      CSIDL_MYPICTURES              = $27;
      CSIDL_PROFILE                 = $28;
      CSIDL_PROGRAM_FILES_COMMON    = $2B;
      CSIDL_COMMON_TEMPLATES        = $2D;
      CSIDL_COMMON_DOCUMENTS        = $2E;
      CSIDL_COMMON_ADMINTOOLS       = $2F;
      CSIDL_ADMINTOOLS              = $30;
      CSIDL_COMMON_MUSIC            = $35;
      CSIDL_COMMON_PICTURES         = $36;
      CSIDL_COMMON_VIDEO            = $37;
      CSIDL_CDBURN_AREA             = $3B;
      CSIDL_PROFILES                = $3E;

type pSHItemID = ^TSHItemID;
     tSHItemID = record
       cb: Word;                         { Size of the ID (including cb itself) }
       abID: array[0..0] of Byte;        { The item ID (variable length) }
     end;

     pItemIDList = ^TItemIDList;
     tItemIDList = record
       mkid: TSHItemID;
     end;

Imports
  Procedure SHGetSpecialFolderLocation(
            hwnd, csidl: LongWord
            var ppidl : pItemIDList);
       APIENTRY;  'SHELL32' name 'SHGetSpecialFolderLocation';

  Function SHGetPathFromIDList(pidl: PItemIDList; var pszPath: cString): Boolean;
       APIENTRY;  'SHELL32' name 'SHGetPathFromIDList';

  Function ShellExecute(hwnd : Longint; lpOperation, lpFile, lpParameters,
                        lpDirectory : CString; nShowCmd : LongInt) : LongInt;
       APIENTRY;  'SHELL32' name 'ShellExecuteA';

End;

Function GetSpecialFolder(Folder : Word) : tFileName;
// Get the Special Folder of Windows

Implementation

Function GetSpecialFolder(Folder : Word) : tFileName;

var ppidl : pITEMIDLIST;
    path  : cString;

Begin
  Result:='';
  try
    SHGetSpecialFolderLocation(0,Folder,ppidl);
    if SHGetPathFromIDList(ppidl, Path) then
      Begin
        Result:=Path;
        Result:=AddPathSeparator(Result);
      End;
  except
  end;
End;



Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  15-Mai-06  WD         Unit erstellt
  16-Apr-07  WD         Funktion ShellExecute eingebaut

}
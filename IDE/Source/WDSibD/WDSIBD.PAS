Library WDSIBD;

USES uDLLDef, uWDSIBFun, uWDSibDlg;
// Uses WinCrt;
                  
{$R WDSIBD}       
                   
{$IFDEF OS2}          
EXPORTS
  InitWDSibDLL       Index 1,
  DestroyWDSibDLL    Index 2,

  Upcased            Index 10,
  SplitFontName      Index 11,
  SplitFixedFontName Index 12,
  NormalizeDir       Index 13,
  GetNextDir         Index 14,
  GetShortName       Index 15,
  IsFlag             Index 16,
  AddFlag            Index 17,
  ReplaceEnvStrings  Index 18,
  FExpand            Index 19,
  Exec2              Index 20,
  GetRCIcon          Index 21,

  AboutDialog        Index 100,

  LogRunCompiler     Index 200;

{$ENDIF}

{$IFDEF WIN32}         
EXPORTS
  InitWDSibDLL       Name 'INITWDSIBDLL',
  DestroyWDSibDLL    Name 'DESTROYWDSIBDLL',

  Upcased            Name 'UPCASED',
  SplitFontName      Name 'SPLITFONTNAME',
  SplitFixedFontName Name 'SPLITFIXEDFONTNAME',
  NormalizeDir       Name 'NORMALIZEDIR',
  GetNextDir         Name 'GETNEXTDIR',
  GetShortName       Name 'GETSHORTNAME',
  IsFlag             Name 'ISFLAG',
  AddFlag            Name 'ADDFLAG',
  ReplaceEnvStrings  Name 'REPLACEENVSTRINGS',
  FExpand            Name 'FEXPAND',
  Exec2              Name 'EXEC2',
  GetRCIcon          Name 'GETRCICON',

  AboutDialog        Name 'ABOUTDIALOG',

  LogRunCompiler     Name 'LOGRUNCOMPILER';
{$ENDIF}

BEGIN
END.      

{ -- date --- --from-- -- changes ----------------------------------------------
  10-Aug-2005 WD       Projekt erstellt.
  06-Jun-2006 WD       RC-Bilder so geaendert, dass diese auch unter Windows funktionieren
  03-Sep-2006 WD       Funktion: GetRCIcon
  08-Nov-2006 WD       Die Icons fuer die einzelnen Fenster geaendert.
}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library (RTL)                                         บ
 บ                                                                          บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 บ    Klassen: tcSysInfo                                                    บ
 บ    Diese Unit liefert diverser Informationenn ueber das Betriebsystem    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit uSysInfo;

Interface

Uses uSysClass, uString;

{$IFDEF OS2 }
Uses BseDos,BseERR, BseTib, Os2Def, PMSpl, PMShl, PMWP,
     PMWin;
{$ENDIF }
{$IFDEF WIN32 }
Uses WinNT, WinBase, WinUser, WinShell;
{$ENDIF }

{$IFDEF OS2 }
Const smCyTitlebar       = TSystemMetrics(SV_CYTITLEBAR);
      smCyMenu           = TSystemMetrics(SV_CYMENU);
      smCxMinMaxButton   = TSystemMetrics(SV_CXMINMAXBUTTON);
      smCyMinMaxButton   = TSystemMetrics(SV_CYMINMAXBUTTON);
      smCxSizeBorder     = TSystemMetrics(SV_CXSIZEBORDER);
      smCySizeBorder     = TSystemMetrics(SV_CYSIZEBORDER);
      smCxDlgBorder      = TSystemMetrics(SV_CXDLGFRAME);
      smCyDlgBorder      = TSystemMetrics(SV_CYDLGFRAME);
      smCxBorder         = TSystemMetrics(SV_CXBORDER);
      smCyBorder         = TSystemMetrics(SV_CYBORDER);
      smCxIcon           = TSystemMetrics(SV_CXICON);
      smCyIcon           = TSystemMetrics(SV_CYICON);
      smCxPointer        = TSystemMetrics(SV_CXPOINTER);
      smCyPointer        = TSystemMetrics(SV_CYPOINTER);
      smCxScreen         = TSystemMetrics(SV_CXSCREEN);
      smCyScreen         = TSystemMetrics(SV_CYSCREEN);
      smCxFullScreen     = TSystemMetrics(SV_CXFULLSCREEN);
      smCyFullScreen     = TSystemMetrics(SV_CYFULLSCREEN);
      smCxVScroll        = TSystemMetrics(SV_CXVSCROLL);
      smCyHScroll        = TSystemMetrics(SV_CYHSCROLL);
      smCxHScrollArrow   = TSystemMetrics(SV_CXHSCROLLARROW);
      smCyHScrollArrow   = TSystemMetrics(SV_CYHSCROLL);
      smCxVScrollArrow   = TSystemMetrics(SV_CXVSCROLL);
      smCyVScrollArrow   = TSystemMetrics(SV_CYVSCROLLARROW);
      smCxHSlider        = TSystemMetrics(SV_CXHSLIDER);
      smCyVSlider        = TSystemMetrics(SV_CYVSLIDER);
      smCMouseButtons    = TSystemMetrics(SV_CMOUSEBUTTONS);
      smMousePresent     = TSystemMetrics(SV_MOUSEPRESENT);
      smSwapButton       = TSystemMetrics(SV_SWAPBUTTON);
      smCxDoubleClick    = TSystemMetrics(SV_CXDBLCLK);
      smCyDoubleClick    = TSystemMetrics(SV_CYDBLCLK);
      smDebug            = TSystemMetrics(SV_DEBUG);
{$ENDIF }
{$IFDEF WIN32 }
Const smCyTitlebar       = TSystemMetrics(SM_CYCAPTION);
      smCyMenu           = TSystemMetrics(SM_CYMENU);
      smCxMinMaxButton   = TSystemMetrics(SM_CXSIZE);
      smCyMinMaxButton   = TSystemMetrics(SM_CYSIZE);
      smCxSizeBorder     = TSystemMetrics(SM_CXFRAME);
      smCySizeBorder     = TSystemMetrics(SM_CYFRAME);
      smCxDlgBorder      = TSystemMetrics(SM_CXDLGFRAME);
      smCyDlgBorder      = TSystemMetrics(SM_CYDLGFRAME);
      smCxBorder         = TSystemMetrics(SM_CXBORDER);
      smCyBorder         = TSystemMetrics(SM_CYBORDER);
      smCxIcon           = TSystemMetrics(SM_CXICON);
      smCyIcon           = TSystemMetrics(SM_CYICON);
      smCxPointer        = TSystemMetrics(SM_CXCURSOR);
      smCyPointer        = TSystemMetrics(SM_CYCURSOR);
      smCxScreen         = TSystemMetrics(SM_CXSCREEN);
      smCyScreen         = TSystemMetrics(SM_CYSCREEN);
      smCxFullScreen     = TSystemMetrics(SM_CXFULLSCREEN);
      smCyFullScreen     = TSystemMetrics(SM_CYFULLSCREEN);
      smCxVScroll        = TSystemMetrics(SM_CXVSCROLL);
      smCyHScroll        = TSystemMetrics(SM_CYHSCROLL);
      smCxHScrollArrow   = TSystemMetrics(SM_CXHSCROLL);
      smCyHScrollArrow   = TSystemMetrics(SM_CYHSCROLL);
      smCxVScrollArrow   = TSystemMetrics(SM_CXVSCROLL);
      smCyVScrollArrow   = TSystemMetrics(SM_CYVSCROLL);
      smCxHSlider        = TSystemMetrics(SM_CXHTHUMB);
      smCyVSlider        = TSystemMetrics(SM_CYVTHUMB);
      smCMouseButtons    = TSystemMetrics(SM_CMOUSEBUTTONS);
      smMousePresent     = TSystemMetrics(SM_MOUSEPRESENT);
      smSwapButton       = TSystemMetrics(SM_SWAPBUTTON);
      smCxDoubleClick    = TSystemMetrics(SM_CXDOUBLECLK);
      smCyDoubleClick    = TSystemMetrics(SM_CYDOUBLECLK);
      smDebug            = TSystemMetrics(SM_DEBUG);
{$ENDIF }

// Types for Devices
Type tDisc_DriveType = (tDisc_dt_Unknown, tDisc_dt_No_Root_Dir,
                        tDisc_dt_REMOVABLE, tDisc_dt_FIXED, tDisc_dt_REMOTE,
                        tDisc_dt_CDROM, tDisc_dt_RAMDISC);

// Types for Dates and Times
Const MaxMonths = 12;
      MaxDays   = 7;
      DaysPerMonth:Array[1..MaxMonths] Of Integer =
            (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

type tShortMonthNames= Array[0..MaxMonths-1] of tStr3;
     tLongMonthNames = Array[0..MaxMonths-1] of tStr15;
     tShortDayNames  = Array[0..MaxDays-1]   of tStr7;
     tLongDayNames   = Array[0..MaxDays-1]   of tStr15;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Klassse: tcSysInfo                                                        บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
  trSystem  = (OS2, Win32, Unknown);
  trPlatform= (OS2Ver20, OS2Ver30, OS2Ver40, OS2Ver45, eComStation,
               Win95, Win98, WinME,
               WinNT3, WinNT4, Win2000, WinXP, WinVista,
               OSUnknown);
  trRunUnder= (ruSystem, ruOdin, ruWine);

  trPC = Record
    CouCOM         : Byte;
    CouLPT         : Byte;
    CouFloppy      : Byte;
    CoProcessor    : Boolean;
    Model          : Byte;
    SubModel       : Byte;
  end;

  trMouse  = Record
    Present    : Boolean;
    CouBottons : Byte;
    SwapButton : Boolean;
  End;

  trScreen = Record
    MonoDisplay     : Boolean;
    Size            : tSize;
    IconSize        : tSize;
    PointerSize     : tSize;
    BorderSize      : tSize;
    SizeBorderSize  : tSize;
    DlgBorderSize   : tSize;
    FullScreenSize  : tSize;
    HScrollArrowSize: tSize;
    VScrollArrowSize: tSize;
    MinMaxButtonSize: tSize;

    TitlebarSize    : LongInt;
    VScrollSize     : LongInt;
    HScrollSize     : LongInt;
    MenuSize        : LongInt;
    HSliderSize     : LongInt;
    VSliderSize     : LongInt;

{   smCxDoubleClick
    smCyDoubleClick
    smDebug }
  end;

  trCountry = Record
    LangEnv          : tStr10;
    CountryID        : LongWord;
    CountryName      : tStr20;
    CountryEngName   : tStr20;
    Language         : tStr20;
    LanguageEng      : tStr20;
    CurrencyString   : tStr3;
    CurrencyFormat   : Byte;
    NegCurrFormat    : Byte;
    ThousandSeparator: Char;
    DecimalSeparator : Char;
    CurrencyDecimals : Byte;
    ListSeparator    : Char;
  end;

  tcOS = Class(tObject)
    Private
      fName         : tStr18;
      fSystem       : trSystem;
      fPlatform     : trPlatform;
      fVersion_Major: LongWord;
      fVersion_Minor: LongWord;
      fBuild        : LongWord;
      fOSCmd        : tFilename;
      fRunUnder     : trRunUnder;

      Function getTickCount:LongInt;
    Public
      Constructor Create; virtual;

      Property Name         : tStr18     Read fName;
      Property System       : trSystem   Read fSystem;
      Property Platform     : trPlatform Read FPlatform;
      Property Version_Major: LongWord   Read fVersion_Major;
      Property Version_Minor: LongWord   Read fVersion_Minor;
      Property Build        : LongWord   Read fBuild;
      Property OSCmd        : tFilename  Read fOSCmd;
      Property RunUnder     : trRunUnder Read fRunUnder;

      Property TickCount    : LongInt    Read getTickCount;
  End;

  tcDateTime = Class(tObject)
    Private
      fShortMonthNames: tShortMonthNames;
      fLongMonthNames : tLongMonthNames;
      fShortDayNames  : tShortDayNames;
      fLongDayNames   : tLongDayNames;
      fDateSeparator  : Char;
      fShortDateFormat: tStr15;
      fLongDateFormat : tStr31;
      fDateOrder      : Byte;
      fTimeOrder      : Byte;
      fTimeSeparator  : Char;
      fTimeAMPM       : Byte;
      fTimeAMString   : tStr7;
      fTimePMString   : tStr7;
      fShortTimeFormat: tStr15;
      fLongTimeFormat : tStr31;
      fTwelveHours    : Boolean;
    Public
      Constructor Create; virtual;
      Function IsLeapYear(iYear : LongWord) : Boolean;
      Function DaysThisMonth(iYear, iMonth : LongWord) : LongWord;

      Property ShortMonthNames: tShortMonthNames Read fShortMonthNames Write fShortMonthNames;
      Property LongMonthNames : tLongMonthNames  Read fLongMonthNames  Write fLongMonthNames;
      Property ShortDayNames  : tShortDayNames   Read fShortDayNames   Write fShortDayNames;
      Property LongDayNames   : tLongDayNames    Read fLongDayNames    Write fLongDayNames;
      Property DateSeparator  : Char             Read fDateSeparator   Write fDateSeparator;
      Property ShortDateFormat: tStr15           Read fShortDateFormat Write fShortDateFormat;
      Property LongDateFormat : tStr31           Read fLongDateFormat  Write fLongDateFormat;
      Property DateOrder      : Byte             Read fDateOrder       Write fDateOrder;
      Property TimeOrder      : Byte             Read fTimeOrder       Write fTimeOrder;
      Property TimeSeparator  : Char             Read fTimeSeparator   Write fTimeSeparator;
      Property TimeAMPM       : Byte             Read fTimeAMPM        Write fTimeAMPM;
      Property TimeAMString   : tStr7            Read fTimeAMString    Write fTimeAMString;
      Property TimePMString   : tStr7            Read fTimePMString    Write fTimePMString;
      Property ShortTimeFormat: tStr15           Read fShortTimeFormat Write fShortTimeFormat;
      Property LongTimeFormat : tStr31           Read fLongTimeFormat  Write fLongTimeFormat;
      Property TwelveHours    : Boolean          Read fTwelveHours     Write fTwelveHours;
  end;


  tcDisc = Class(tObject)
    Private
    Public
      function GetDriveType(iDrive  : Char) : tDisc_DriveType;
      function GetDriveInfo(iDrive:Char;var iType:uShort;var Name,FSDName,FSAData:string):LongWord;
  End;

  tcFolders = Class(tObject)
    Private
      fOSDevice   : tFileName;
      fOSPath     : tFileName;
      fSystemPath : tFileName;
      fDesktopPath: tFileName;
      fTempPath   : tFileName;

      Function getFontPath: tFileName;
      Function getProgramPath: tFileName;
      function getDesktopPath : tFileName;{Martin0208}
    Public
      Constructor Create; virtual;

      Property OSDevice   : tFilename Read fOSDevice;
      Property OSPath     : tFileName Read fOSPath;
      Property SystemPath : tFilename Read fSystemPath;
      Property DesktopPath: tFilename Read getDesktopPath;{Martin0208}
      Property TempPath   : tFileName Read fTempPath;
      Property ProgramPath: tFileName Read getProgramPath;
      Property FontPath   : tFileName Read getFontPath;
  End;


  tcSysAppInfo = Class(tObject)
    Private
      Function getDefaultBrowser: tFileName;
      Function getOdinPEExe     : tFileName;
      Function getSysInfo       : tFileName;
    Public
      Property DefaultBrowser: tFileName Read getDefaultBrowser; // Default Browser
      Property OdinPEExe     : tFileName Read getOdinPEExe;      // Odin: Pfad von PE.exe
      Property SysInfo       : tFileName Read getSysInfo;        // SystemInfo (Win: MSInfo32.exe)
  end;

  tcProgramInfo = Class(TObject)
    Private
      fName  : tFileName;
      fPath  : tFileName;

      Function getExeName : tFilename;
    Public
      Constructor Create; virtual;

      Property Path     : tFilename Read fPath;
      Property Name     : tFilename Read fName;
      Property ExeName  : tFilename Read getExename;
  End;

  tcWDSibylInfo = Class(TObject)
    Private
      Function GetDir           : tFilename;
      Function GetDirBin        : tFileName;
      Function GetInstalled     : Boolean;
      Function GetSibylINIFile  : tFileName;
      Function GetWDSibylINIFile: tFileName;
    Public
      Function GetToolInfo(iName : String;
                 var iToolNr : LongInt;var iFileName : tFileName; var iFileParameter : String) : Boolean;
      Function ModifyToolInfo(iToolNr : LongInt;
                 iName : String; iPrgFileName : TFileName; iPrgFileParam: String) : Boolean;

      Property Installed     : Boolean   Read getInstalled;
      Property Dir           : tFilename Read getDir;
      Property DirBin        : tFileName Read GetDirBin;
      Property SibylINIFile  : tFileName Read getSibylINIFile;
      Property WDSibylINIFile: tFileName Read getWDSibylINIFile;
  end;

  tcSysInfo = Class(TObject)
    Private

      fSystemIni    : tFileName;
      fUserIni      : tFileName;

      fPC           : trPC;
      fScreen       : trScreen;
      fMouse        : trMouse;
      fCountry      : trCountry;

      fOS           : tcOS;
      fDateTime     : tcDateTime;
      fDisc         : tcDisc;
      fFolders      : tcFolders;
      fProgramInfo  : tcProgramInfo;
      fSysAppInfo   : tcSysAppInfo;
      fWDSibylInfo  : tcWDSibylInfo;

      fCID          : LongWord;

      Function getEnvCount : LongInt;
      Function getEnv(const iEnv:String):AnsiString;

      Function SystemMetrics(Const iSystemMetrics : tSystemMetrics):LongInt;

      Function GetLocInfo(Const iLCType : LongWord; iDefault : String) : String;
      Function GetLocInfoInt(Const iLCType : LongWord; iDefault : LongInt) : LongInt;

      {$IFDEF OS2}
      Procedure getOS2Info;
      {$ENDIF}
      {$IFDEF Win32}
      Procedure getWinInfo;
      {$ENDIF}

    Public
      Constructor Create; virtual;
      Destructor Destroy; override;

      Property PC      : trPC       Read fPC;
      Property Screen  : trScreen   Read fScreen;
      Property Mouse   : trMouse    Read fMouse;
      Property Country : trCountry  Read fCountry;

      Property OS         : tcOS          Read fOS;
      Property DateTime   : tcDateTime    Read fDateTime;
      Property Disc       : tcDisc        Read fDisc;
      Property Folders    : tcFolders     Read fFolders;
      Property SysAppInfo : tcSysAppInfo  Read fSysAppInfo;
      Property ProgramInfo: tcProgramInfo Read fProgramInfo;
      Property WDSibylInfo: tcWDSibylInfo Read fWDSibylInfo;

      Property EnvCount     : LongInt             Read getEnvCount;
      Property Env[const iEnv:String]: AnsiString Read getEnv;

      Property SystemINI    : String         Read fSystemIni;
      Property UserINI      : String         Read fUserIni;

{     Property SystemINIFile   : TINIFile    Read fSystemINIFile;
      Property UserINIFile     : TINIFile    Read fUserINIFile; }

  End;

Var goSysInfo : tcSysInfo;
    GlobalCritSec: tcCriticalSection;
    GlobalMutex  : tcMutexSemaphor;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Extensions (Lower Case)                                                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
  EXT_ALL             = '.*';

{ Textformate }
  EXT_LC_HTML            = '.html';
  EXT_LC_TXT             = '.txt';
  EXT_LC_LOG             = '.log';
  EXT_LC_CSV             = '.csv';
  EXT_LC_XML             = '.xml';

{ Datenbanken }
  EXT_LC_DBF             = '.dbf'; // dBaseIII-Datei
  EXT_LC_DBT             = '.dbt'; // dBaseIII-Memo-Datei
  EXT_LC_SQL             = '.sql'; // SQL-Format

{ Staroffice }
  EXT_LC_SO_SDW          = '.sdw';

{ MS-Office }
  EXT_LC_MSO_DOC         = '.doc';
  EXT_LC_MSO_XLS         = '.xls';
  EXT_LC_MSO_PPS         = '.pps';

{ Ausfuerbare }
  EXT_LC_COM             = '.com';
  EXT_LC_EXE             = '.exe';
  EXT_LC_DLL             = '.dll';
  EXT_LC_CMD             = '.cmd';
  EXT_LC_BATCH           = '.bat';

{ Multimedia }
  EXT_LC_MP3             = '.mp3';
  EXT_LC_WAV             = '.wav';
  EXT_LC_MIDI            = '.mid';
  EXT_LC_AVI             = '.avi';
  EXT_LC_MPG             = '.mpg';

{ Grafik }
  EXT_LC_ICON            = '.ico';
  EXT_LC_BITMAP          = '.bmp';
  EXT_LC_POINTER_OS2     = '.ptr';
  EXT_LC_POINTER_WIN32   = '.cur';
  EXT_LC_MET             = '.met';
  EXT_LC_PCX             = '.pcx';
  EXT_LC_GIF             = '.gif';
  EXT_LC_JPEG            = '.jpg';

{ Hilfe }
  EXT_LC_HELP            = '.hlp';
  EXT_LC_IPF             = '.ipf';

{ Sonstiges }
  EXT_LC_INI             = '.ini';
  EXT_LC_Backup          = '.bak';
  EXT_LC_Language        = '.lng';

{ Sprachen }
  EXT_LC_PASCAL          = '.pas';
  EXT_LC_RC              = '.rc';
  EXT_LC_BASIC           = '.bas';
  EXT_LC_JAVA            = '.java';
  EXT_LC_C               = '.c';
  EXT_LC_H               = '.h';
  EXT_LC_ASM             = '.asm';
  EXT_LC_INC             = '.inc';

{ WDSibyl }
  EXT_LC_WDSibyl_SPR     = '.spr';
  EXT_LC_WDSibyl_SCU     = '.scu';
  EXT_LC_WDSibyl_SCL     = '.scl';
  EXT_LC_WDSibyl_SLF     = '.slf';   // Language-Datei
  EXT_LC_WDSibyl_Res_SRF = '.srf';
  EXT_LC_WDSibyl_Res_SRW = '.srw';
  EXT_LC_WDSibyl_Prj_SPU = '.spu';
  EXT_LC_WDSibyl_Prj_SPW = '.spw';
  EXT_LC_WDSibyl_Help    = '.shs';

{$IFDEF OS2}
  EXT_LC_WDSibyl_Project = EXT_LC_WDSibyl_Prj_SPU;   { frueher: SPUExt }
  EXT_LC_WDSibyl_Res     = EXT_LC_WDSibyl_Res_SRF;   { frueher: SRFExt }
{$ENDIF}
{$IFDEF Win32}
  EXT_LC_WDSibyl_Project = EXT_LC_WDSibyl_Prj_SPW;   { frueher: SPUExt }
  EXT_LC_WDSibyl_Res     = EXT_LC_WDSibyl_Res_SRW;   { frueher: SRFExt }
{$ENDIF}
  EXT_LC_WDBTable        = '.wdbtab';
  EXT_LC_CZTList         = '.zctlst';

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Extensions (Upper Case)                                                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{ Textformate }
  EXT_UC_HTML            = '.HTML';
  EXT_UC_TXT             = '.TXT';
  EXT_UC_LOG             = '.LOG';
  EXT_UC_CSV             = '.CSV';
  EXT_UC_XML             = '.XML';

{ Datenbanken }
  EXT_UC_DBF             = '.DBF';
  EXT_UC_DBT             = '.DBT';
  EXT_UC_SQL             = '.SQL'; // SQL-Format

{ Staroffice }
  EXT_UC_SO_SDW          = '.SDW';

{ MS-Office }
  EXT_UC_MSO_DOC         = '.DOC';
  EXT_UC_MSO_XLS         = '.XLS';
  EXT_UC_MSO_PPS         = '.PPS';

{ Ausfuerbare }
  EXT_UC_COM             = '.COM';
  EXT_UC_EXE             = '.EXE';
  EXT_UC_DLL             = '.DLL';
  EXT_UC_CMD             = '.CMD';
  EXT_UC_BATCH           = '.BAT';

{ Multimedia }
  EXT_UC_MP3             = '.MP3';
  EXT_UC_WAV             = '.WAV';
  EXT_UC_MIDI            = '.MID';
  EXT_UC_AVI             = '.AVI';
  EXT_UC_MPG             = '.MPG';

{ Grafik }
  EXT_UC_ICON            = '.ICO';
  EXT_UC_BITMAP          = '.BMP';
  EXT_UC_POINTER_OS2     = '.PTR';
  EXT_UC_POINTER_WIN32   = '.CUR';
  EXT_UC_MET             = '.MET';
  EXT_UC_PCX             = '.PCX';
  EXT_UC_GIF             = '.GIF';
  EXT_UC_JPEG            = '.JPG';

{ Hilfe }
  EXT_UC_HELP            = '.HLP';
  EXT_UC_IPF             = '.IPF';

{ Sonstiges }
  EXT_UC_INI             = '.INI';
  EXT_UC_Backup          = '.BAK';
  EXT_UC_Language        = '.LNG';

{ Sprachen }
  EXT_UC_PASCAL          = '.PAS';
  EXT_UC_RC              = '.RC';
  EXT_UC_BASIC           = '.BAS';
  EXT_UC_JAVA            = '.JAVA';
  EXT_UC_C               = '.C';
  EXT_UC_H               = '.H';
  EXT_UC_ASM             = '.ASM';
  EXT_UC_INC             = '.INC';

{ WDSibyl }
  EXT_UC_WDSibyl_SPR     = '.SPR';
  EXT_UC_WDSibyl_SCU     = '.SCU';
  EXT_UC_WDSibyl_SCL     = '.SCL';
  EXT_UC_WDSibyl_SLF     = '.SLF';   // Language-Datei
  EXT_UC_WDSibyl_Res_SRF = '.SRF';
  EXT_UC_WDSibyl_Res_SRW = '.SRW';
  EXT_UC_WDSibyl_Prj_SPU = '.SPU';
  EXT_UC_WDSibyl_Prj_SPW = '.SPW';
  EXT_UC_WDSibyl_Help    = '.SHS';

{$IFDEF OS2}
  EXT_UC_WDSibyl_Project = EXT_UC_WDSibyl_Prj_SPU;   { frueher: SPUExt }
  EXT_UC_WDSibyl_Res     = EXT_UC_WDSibyl_Res_SRF;   { frueher: SRFExt }
{$ENDIF}
{$IFDEF Win32}
  EXT_UC_WDSibyl_Project = EXT_UC_WDSibyl_Prj_SPW;   { frueher: SPUExt }
  EXT_UC_WDSibyl_Res     = EXT_UC_WDSibyl_Res_SRW;   { frueher: SRFExt }
{$ENDIF}

  EXT_UC_WDBTable        = '.WDBTAB';
  EXT_UC_CZTList         = '.ZCTLST';

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ All files from a extension                                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}
  ALL_FILES                    = '*' + EXT_ALL;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ All files from a extension (Lower Case)                                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{ Textformate }
  ALL_FILES_LC_HTML            = '*' + EXT_LC_HTML;
  ALL_FILES_LC_TXT             = '*' + EXT_LC_TXT;
  ALL_FILES_LC_LOG             = '*' + EXT_LC_LOG;
  ALL_FILES_LC_CSV             = '*' + EXT_LC_CSV;
  ALL_FILES_LC_XML             = '*' + EXT_LC_XML;

{ Datenbanken }
  ALL_FILES_LC_DBF             = '*' + EXT_LC_DBF;
  ALL_FILES_LC_DBT             = '*' + EXT_LC_DBT;
  ALL_FILES_LC_SQL             = '*' + EXT_LC_SQL;

{ Staroffice }
  ALL_FILES_LC_SO_SDW          = '*' + EXT_LC_SO_SDW;

{ MS-Office }
  ALL_FILES_LC_MSO_DOC         = '*' + EXT_LC_MSO_DOC;
  ALL_FILES_LC_MSO_XLS         = '*' + EXT_LC_MSO_XLS;
  ALL_FILES_LC_MSO_PPS         = '*' + EXT_LC_MSO_PPS;

{ Ausfuerbare }
  ALL_FILES_LC_COM             = '*' + EXT_LC_COM;
  ALL_FILES_LC_EXE             = '*' + EXT_LC_EXE;
  ALL_FILES_LC_DLL             = '*' + EXT_LC_DLL;
  ALL_FILES_LC_CMD             = '*' + EXT_LC_CMD;
  ALL_FILES_LC_BATCH           = '*' + EXT_LC_BATCH;

{ Multimedia }
  ALL_FILES_LC_MP3             = '*' + EXT_LC_MP3;
  ALL_FILES_LC_WAV             = '*' + EXT_LC_WAV;
  ALL_FILES_LC_MIDI            = '*' + EXT_LC_MIDI;
  ALL_FILES_LC_AVI             = '*' + EXT_LC_AVI;
  ALL_FILES_LC_MPG             = '*' + EXT_LC_MPG;

{ Grafik }
  ALL_FILES_LC_ICON            = '*' + EXT_LC_ICON;
  ALL_FILES_LC_BITMAP          = '*' + EXT_LC_BITMAP;
  ALL_FILES_LC_POINTER_OS2     = '*' + EXT_LC_POINTER_OS2;
  ALL_FILES_LC_POINTER_WIN32   = '*' + EXT_LC_POINTER_WIN32;
  ALL_FILES_LC_MET             = '*' + EXT_LC_MET;
  ALL_FILES_LC_PCX             = '*' + EXT_LC_PCX;
  ALL_FILES_LC_GIF             = '*' + EXT_LC_GIF;
  ALL_FILES_LC_JPEG            = '*' + EXT_LC_JPEG;

{ Hilfe }
  ALL_FILES_LC_HELP            = '*' + EXT_LC_HELP;
  ALL_FILES_LC_IPF             = '*' + EXT_LC_IPF;

{ Sonstiges }
  ALL_FILES_LC_INI             = '*' + EXT_LC_INI;
  ALL_FILES_LC_BACKUP          = '*' + EXT_LC_Backup;
  ALL_FILES_LC_Language        = '*' + EXT_LC_Language;

{ Sprachen }
  ALL_FILES_LC_PASCAL          = '*' + EXT_LC_PASCAL;
  ALL_FILES_LC_RC              = '*' + EXT_LC_RC;
  ALL_FILES_LC_BASIC           = '*' + EXT_LC_BASIC;
  ALL_FILES_LC_JAVA            = '*' + EXT_LC_JAVA;
  ALL_FILES_LC_C               = '*' + EXT_LC_C;
  ALL_FILES_LC_H               = '*' + EXT_LC_H;
  ALL_FILES_LC_ASM             = '*' + EXT_LC_ASM;
  ALL_FILES_LC_INC             = '*' + EXT_LC_INC;

{ WDSibyl }
  ALL_FILES_LC_WDSibyl_SPR     = '*' + EXT_LC_WDSibyl_SPR;
  ALL_FILES_LC_WDSibyl_SCU     = '*' + EXT_LC_WDSibyl_SCU;
  ALL_FILES_LC_WDSibyl_SCL     = '*' + EXT_LC_WDSibyl_SCL;
  ALL_FILES_LC_WDSibyl_SLF     = '*' + EXT_LC_WDSibyl_SLF;
  ALL_FILES_LC_WDSibyl_Res_SRF = '*' + EXT_LC_WDSibyl_Res_SRF;
  ALL_FILES_LC_WDSibyl_Res_SRW = '*' + EXT_LC_WDSibyl_Res_SRW;
  ALL_FILES_LC_WDSibyl_Prj_SPU = '*' + EXT_LC_WDSibyl_Prj_SPU;
  ALL_FILES_LC_WDSibyl_Prj_SPW = '*' + EXT_LC_WDSibyl_Prj_SPW;
  ALL_FILES_LC_WDSibyl_Help    = '*' + EXT_LC_WDSibyl_Help;

  ALL_FILES_LC_WDSibyl_Project = '*' + EXT_LC_WDSibyl_Project;
  ALL_FILES_LC_WDSibyl_Res     = '*' + EXT_LC_WDSibyl_Res;

  ALL_FILES_LC_WDBTable        = '*' + EXT_LC_WDBTable;
  ALL_FILES_LC_CZTList         = '*' + EXT_LC_CZTList;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ All files from a extension (Upper Case)                                   บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{ Textformate }
  ALL_FILES_UC_HTML            = '*' + EXT_UC_HTML;
  ALL_FILES_UC_TXT             = '*' + EXT_UC_TXT;
  ALL_FILES_UC_LOG             = '*' + EXT_UC_LOG;
  ALL_FILES_UC_CSV             = '*' + EXT_UC_CSV;
  ALL_FILES_UC_XML             = '*' + EXT_UC_XML;

{ Datenbanken }
  ALL_FILES_UC_DBF             = '*' + EXT_UC_DBF;
  ALL_FILES_UC_DBT             = '*' + EXT_UC_DBT;
  ALL_FILES_UC_SQL             = '*' + EXT_UC_SQL;

{ Staroffice }
  ALL_FILES_UC_SO_SDW          = '*' + EXT_UC_SO_SDW;

{ MS-Office }
  ALL_FILES_UC_MSO_DOC         = '*' + EXT_UC_MSO_DOC;
  ALL_FILES_UC_MSO_XLS         = '*' + EXT_UC_MSO_XLS;
  ALL_FILES_UC_MSO_PPS         = '*' + EXT_UC_MSO_PPS;

{ Ausfuerbare }
  ALL_FILES_UC_COM             = '*' + EXT_UC_COM;
  ALL_FILES_UC_EXE             = '*' + EXT_UC_EXE;
  ALL_FILES_UC_DLL             = '*' + EXT_UC_DLL;
  ALL_FILES_UC_CMD             = '*' + EXT_UC_CMD;
  ALL_FILES_UC_BATCH           = '*' + EXT_UC_BATCH;

{ Multimedia }
  ALL_FILES_UC_MP3             = '*' + EXT_UC_MP3;
  ALL_FILES_UC_WAV             = '*' + EXT_UC_WAV;
  ALL_FILES_UC_MIDI            = '*' + EXT_UC_MIDI;
  ALL_FILES_UC_AVI             = '*' + EXT_UC_AVI;
  ALL_FILES_UC_MPG             = '*' + EXT_UC_MPG;

{ Grafik }
  ALL_FILES_UC_ICON            = '*' + EXT_UC_ICON;
  ALL_FILES_UC_BITMAP          = '*' + EXT_UC_BITMAP;
  ALL_FILES_UC_POINTER_OS2     = '*' + EXT_UC_POINTER_OS2;
  ALL_FILES_UC_POINTER_WIN32   = '*' + EXT_UC_POINTER_WIN32;
  ALL_FILES_UC_MET             = '*' + EXT_UC_MET;
  ALL_FILES_UC_PCX             = '*' + EXT_UC_PCX;
  ALL_FILES_UC_GIF             = '*' + EXT_UC_GIF;
  ALL_FILES_UC_JPEG            = '*' + EXT_UC_JPEG;

{ Hilfe }
  ALL_FILES_UC_HELP            = '*' + EXT_UC_HELP;
  ALL_FILES_UC_IPF             = '*' + EXT_UC_IPF;

{ Sonstiges }
  ALL_FILES_UC_INI             = '*' + EXT_UC_INI;
  ALL_FILES_UC_BACKUP          = '*' + EXT_UC_Backup;
  ALL_FILES_UC_Language        = '*' + EXT_UC_Language;

{ Sprachen }
  ALL_FILES_UC_PASCAL          = '*' + EXT_UC_PASCAL;
  ALL_FILES_UC_RC              = '*' + EXT_UC_RC;
  ALL_FILES_UC_BASIC           = '*' + EXT_UC_BASIC;
  ALL_FILES_UC_JAVA            = '*' + EXT_UC_JAVA;
  ALL_FILES_UC_C               = '*' + EXT_UC_C;
  ALL_FILES_UC_H               = '*' + EXT_UC_H;
  ALL_FILES_UC_ASM             = '*' + EXT_UC_ASM;
  ALL_FILES_UC_INC             = '*' + EXT_UC_INC;

{ WDSibyl }
  ALL_FILES_UC_WDSibyl_SPR     = '*' + EXT_UC_WDSibyl_SPR;
  ALL_FILES_UC_WDSibyl_SCU     = '*' + EXT_UC_WDSibyl_SCU;
  ALL_FILES_UC_WDSibyl_SCL     = '*' + EXT_UC_WDSibyl_SCL;
  ALL_FILES_UC_WDSibyl_SLF     = '*' + EXT_UC_WDSibyl_SLF;
  ALL_FILES_UC_WDSibyl_Res_SRF = '*' + EXT_UC_WDSibyl_Res_SRF;
  ALL_FILES_UC_WDSibyl_Res_SRW = '*' + EXT_UC_WDSibyl_Res_SRW;
  ALL_FILES_UC_WDSibyl_Prj_SPU = '*' + EXT_UC_WDSibyl_Prj_SPU;
  ALL_FILES_UC_WDSibyl_Prj_SPW = '*' + EXT_UC_WDSibyl_Prj_SPW;
  ALL_FILES_UC_WDSibyl_Help    = '*' + EXT_UC_WDSibyl_Help;

  ALL_FILES_UC_WDSibyl_Project = '*' + EXT_UC_WDSibyl_Project;
  ALL_FILES_UC_WDSibyl_Res     = '*' + EXT_UC_WDSibyl_Res;

  ALL_FILES_UC_WDBTable        = '*' + EXT_UC_WDBTable;
  ALL_FILES_UC_CZTList         = '*' + EXT_UC_CZTList;


Implementation

Uses IniFiles, SysUtils, PMWinX;

Const cWDSibyl       = 'WDSibyl';
      cIDWDSibylPath = 'Path';

// -------------------------------------------------------------------------------------------

Function tcOS.getTickCount:LongInt;

{$IFDEF OS2}
var   L: longInt;
{$ENDIF}

Begin
{$IFDEF OS2}
  DosQuerySysInfo(QSV_MS_COUNT,QSV_MS_COUNT,L,4);
  Result:=L;
{$ENDIF}
{$IFDEF WIN32}
  Result:=WinBase.GetTickCount;
{$ENDIF}
End;


Constructor tcOS.Create;

{$IFDEF WIN32}
Var WinOSInfo : OSVERSIONINFO;
{$ENDIF}

Begin
 inherited Create;

{$IFDEF OS2}
  fOSCmd := GetEnv('COMSPEC');
  fName  := UpperCase(GetEnv('OS'));
  if fName = '' then fName:='OS/2';
  fSystem  := OS2;
  fPlatform:=OSUnknown;
  fRunUnder:=ruSystem;
  DosQuerySysInfo(QSV_VERSION_MAJOR,QSV_VERSION_MAJOR,fVersion_Major,4);
  DosQuerySysInfo(QSV_VERSION_MINOR,QSV_VERSION_MINOR,fVersion_Minor,4);
  If fVersion_Major = 20 Then
    Case fVersion_Minor Of
      0,10,11: fPlatform := OS2Ver20;
      30:      fPlatform := OS2Ver30;
      40:      fPlatform := OS2Ver40;
      45:      fPlatform := OS2Ver45;
    End;
  fBuild:=0;
{$ENDIF}
{$IFDEF WIN32}
  WinOSInfo.dwOSVersionInfoSize:= Sizeof(OSVERSIONINFO);
  GetVersionEx(WinOSInfo);
  fVersion_Major:=WinOSInfo.dwMajorVersion;
  fVersion_Minor:=WinOSInfo.dwMinorVersion;
  fBuild := WinOSInfo.dwBuildNumber;
  fSystem:=Win32;
  fPlatform:=OSUnknown;
  fRunUnder:=ruSystem;
  case WinOSInfo.dwPlatformId of
    1 : begin  { Win32-Schiene }
          case WinOSInfo.dwMinorVersion of
            0 : fPlatform:=Win95;
           10 : fPlatform:=Win98;
           90 : if (WinOSInfo.dwBuildNumber = 73010104)
                  then fPlatform:=WinME;
          end;
        end;
    2 : Begin  { Win32-NT-Schiene }
          case WinOSInfo.dwMajorVersion of
            3 : fPlatform:=WinNT3;
            4 : fPlatform:=WinNT4;
            5 : case WinOSInfo.dwMinorVersion of
                  0 : Begin
                        fPlatform:=Win2000;
                        if (GetEnv('OS2_SHELL')<>'') and (GetEnv('RunWorkPlace')<>'') then
                          fRunUnder:=ruOdin;
                      End;
                  1 : fPlatform:=WinXP;
                end;
            6 : fPlatform:=WinVista;
          end;
        End;
  End;

  fName :='Windows ';
  case fPlatform of
    Win95   : fName := fName + '95';
    Win98   : fName := fName + '98';
    WinME   : fName := fName + 'ME';
    WinNT3  : fName := fName + 'NT Ver 3';
    WinNT4  : fName := fName + 'NT Ver 4';
    Win2000 : fName := fName + '2000';
    WinXP   : fName := fName + 'XP';
    WinVista: fName := fName + 'Vista';

  end;

// Command-Shell herausfinden
  fOSCmd := GetEnv('COMSPEC');
  if fOSCmd='' then
    Begin
      if fPlatform in [Win95, Win98, WinME]
        then fOSCmd := goSysInfo.Folders.OSDevice + 'command.com'
        else fOSCmd := goSysInfo.Folders.SystemPath + 'cmd.exe';
    End;
{$ENDIF}
End;

// -------------------------------------------------------------------------------------------

Const defShortMonthNames: tShortMonthNames =
        ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

      defLongMonthNames: tLongMonthNames =
        ('January', 'February', 'March', 'April', 'May', 'June',
         'July', 'August', 'September', 'October', 'November', 'December');

      defShortDaysNames: tShortDayNames =
        ('Sun', 'Mon','Tue', 'Wed', 'Thu', 'Fri', 'Sat');

      defLongDaysNames: tLongDayNames =
        ('Sunday', 'Monday', 'Tuesday', 'Wednesday',
         'Thursday', 'Friday', 'Saturday');

{$IFDEF OS2}
Const SecPMNational ='PM_National';
{$ENDIF}

Constructor tcDateTime.Create;

var Cou : LongInt;
{$IFDEF OS2}
    ini : tIniFile;
{$ENDIF}

Begin
  inherited Create;

{ Lesen der Monatsbezeichnung}
  for Cou:=0 to MaxMonths-1 do
    Begin
      fShortMonthNames[Cou]:=
            goSysInfo.GetLocInfo(LOCALE_SABBREVMONTHNAME1 + Cou, defShortMonthNames[Cou]);
      fLongMonthNames[Cou]:=
            goSysInfo.GetLocInfo(LOCALE_SMONTHNAME1 + Cou, defLongMonthNames[Cou]);
    End;

  for Cou:=0 to MaxDays-1 do
    Begin
      fShortDayNames[Cou]:=
            goSysInfo.GetLocInfo(LOCALE_SABBREVDAYNAME1 + Cou, defShortDaysNames[Cou]);
      fLongDayNames[Cou]:=
            goSysInfo.GetLocInfo(LOCALE_SDAYNAME1 + Cou, defLongDaysNames[Cou]);
    End;

{$IFDEF OS2}
  Ini.Create(goSysInfo.UserIni);

{ Lesen der Datum und Zeit Parameter }
  fTimeAMString := ini.ReadString(SecPMNational, 's1159', 'am');
  fTimeAMString := iif(fTimeAMString='','am',fTimeAMString);
  fTimePMString := ini.ReadString(SecPMNational, 's2359', 'pm');
  fTimePMString := iif(fTimePMString='','pm',fTimePMString);
  fDateSeparator:= ini.ReadChar(SecPMNational, 'sDate', '/');
  fTimeSeparator:= ini.ReadChar(SecPMNational, 'sTime', ':');
  fDateOrder    := ini.ReadInteger(SecPMNational, 'iDate', 0);

  Case fDateOrder Of
    0: Begin
         fShortDateFormat:= 'mm' + fDateSeparator +
                                     'dd' + fDateSeparator +
                                         'yyyy';
         fLongDateFormat := 'dddd, mmmm d. yyyy';
       End;
    1: Begin
         fShortDateFormat:= 'dd' + fDateSeparator +
                                     'mm' + fDateSeparator +
                                     'yyyy';
         fLongDateFormat := 'dddd, d. mmmm yyyy';
       End;
    2: Begin
         fShortDateFormat:= 'yyyy' + fDateSeparator +
                                     'mm' + fDateSeparator +
                                     'dd';
         fLongDateFormat := 'dddd, yyyy mmmm d.';
       End;
  End;

  fTimeOrder := GetProfileInt(SecPMNational, 'iLzero', 0);
  Case fTimeOrder Of
    0: Begin
         fShortTimeFormat:= 'h' + fTimeSeparator + 'mm';
         fLongTimeFormat := 'h' + fTimeSeparator +
                                     'mm'  + fTimeSeparator + 'ss';
       End;
    1: Begin
         fShortTimeFormat:= 'hh' + fTimeSeparator + 'mm';
         fLongTimeFormat := 'hh' + fTimeSeparator +
                                     'mm' + fTimeSeparator + 'ss';
       End;
  End;
  fTimeAMPM := GetProfileInt(SecPMNational, 'iTime', 0);
  If fTimeAMPM=0
    then
      Begin
        fShortTimeFormat:= fShortTimeFormat + ' ampm';
        fLongTimeFormat := fLongTimeFormat + ' ampm';
        fTwelveHours := True;
      End
    else fTwelveHours := False;

  Ini.Destroy;
{$ENDIF}
{$IFDEF Win32}
{ Datum-Zeit-Parameter ermitteln }
  fTimeAMString := 'am';
  fTimePMString := 'pm';

  fDateSeparator:= goSysInfo.GetLocInfo(LOCALE_SDATE,'/')[1];
  fTimeSeparator:= goSysInfo.GetLocInfo(LOCALE_STIME,':')[1];
  fDateOrder    := goSysInfo.GetLocInfoInt(LOCALE_IDATE,0);

  fShortDateFormat:= goSysInfo.GetLocInfo(LOCALE_SSHORTDATE,
                                      'mm' + fDateSeparator +
                                      'dd' + fDateSeparator +
                                      'yyyy');
  fLongDateFormat := goSysInfo.GetLocInfo(LOCALE_SLONGDATE, 'dddd, mmmm d. yyyy');
  fTimeOrder      := goSysInfo.GetLocInfoInt(LOCALE_ILZERO, 1);
  fShortTimeFormat:= goSysInfo.GetLocInfo(LOCALE_STIMEFORMAT,
                                      'hh' + fTimeSeparator +
                                      'mm' + fTimeSeparator + 'ss');
  fLongTimeFormat := goSysInfo.GetLocInfo(LOCALE_STIMEFORMAT,
                                      'hh' + fTimeSeparator +
                                      'mm' + fTimeSeparator + 'ss');
  fTimeAMPM := goSysInfo.GetLocInfoInt(LOCALE_ITIME,0);
  If fTimeAMPM=0
    then
      Begin
        fShortTimeFormat:= fShortTimeFormat + ' ampm';
        fLongTimeFormat := fLongTimeFormat + ' ampm';
        fTwelveHours := True;
      End
    else fTwelveHours := False;
{$ENDIF}

End;

Function tcDateTime.IsLeapYear(iYear : LongWord) : Boolean;

Begin
  Result:=(iYear mod 4=0) And
         ((iYear mod 100<>0) Or (iYear mod 400=0));
End;

Function tcDateTime.DaysThisMonth(iYear, iMonth : LongWord) : LongWord;

Begin
  Result:=0;
  if iMonth>MaxMonths then exit;
  Result := DaysPerMonth[iMonth];
  If ((iMonth=2) And (IsLeapYear(iYear))) Then
    inc(Result);
End;

// -------------------------------------------------------------------------------------------

Constructor tcFolders.Create;

var cStr : cString;
{$IFDEF OS2}
    dev: LongWord;
{$ENDIF}
{$IFDEF Win32}
    Len: Byte;
{$ENDIF}

Begin
  inherited Create;

{$IFDEF OS2}
  fOSPath:=goSysInfo.GetEnv('OSDIR');
  if fOSPath='' then
    Begin
      DosQuerySysInfo(QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,dev,4);
      fOSPath:=chr(dev+64)+':\OS2'
    End;
  fOSPath := AddPathSeparator(fOSPath);
  fTempPath:=goSysInfo.Env['TEMP'];
  if fTempPath=''
    then fTempPath:=goSysInfo.Env['TMP'];
  fTempPath:=AddPathSeparator(fTempPath);
  WinQueryActiveDesktopPathname(cStr, 256);
  fDesktopPath:=AddPathSeparator(cStr);
  fSystemPath:=fOSPath+'System'+PathSeparator;
{$ENDIF}

{$IFDEF Win32}
  Len:=GetWindowsDirectory(cStr,255);
  fOSPath := cStr;                 { Muss wegen Win2000 getrennt  }
  fOSPath:=AddPathSeparator(fOSPath);

  {Martin0208}
  //fDesktopPath:=GetSpecialFolder(CSIDL_DESKTOP);
  fDesktopPath := '';
  fTempPath:=AddPathSeparator(goSysInfo.Env['TEMP']);

  Len:=GetSystemDirectory(cStr,255);
  fSystemPath:=AddPathSeparator(cStr);
  if fSystemPath = '' then
    fSystemPath:=fOSPath+'System'+PathSeparator;
{$ENDIF}
  fOSDevice:=Copy(fOSPath,1,3);
End;

{Martin0208}
function tcFolders.getDesktopPath: tFileName;
  begin
    {$ifdef win32}
    if fDesktopPath = '' then
      fDesktopPath := GetSpecialFolder(CSIDL_DESKTOP);
    {$endif}
    result := fDesktopPath;
  end;

Function tcFolders.getProgramPath: tFileName;

Begin
{$IFDEF OS2}
  Result:=goSysInfo.Env['PROGRAMS'];
  if Result='' then
    Result:=fOSDevice+'Programs';
{$ENDIF}
{$IFDEF Win32}
  Result:=GetSpecialFolder(CSIDL_PROGRAM_FILES);
  if Result = '' then
    Begin
      Result:=GetSpecialFolder(CSIDL_PROGRAMS);
      Result:=copy(Result,1,length(Result)-1);
      Result:=fOSDevice+Copy(Result,LastPos(PathSeparator, Result)+1,255);
    End;
{$ENDIF}
  Result:=AddPathSeparator(Result);
End;

Function tcFolders.getFontPath: tFileName;

Begin
{$IFDEF OS2}
  Result:=fOSPath+'PSFonts'+PathSeparator;
{$ENDIF}
{$IFDEF Win32}
  Result:=GetSpecialFolder(CSIDL_FONTS);
{$ENDIF}
End;

// -------------------------------------------------------------------------------------------

function tcDisc.GetDriveType(iDrive  : Char) : tDisc_DriveType;
{ GetDriveType ermittelt den Typ eines Laufwerks. }

var Drive : cString;

{$IFDEF OS2}
var iType : uShort;
    Name,FSDName,FSAData : string;
{$ENDIF}

begin
  Drive:=iDrive;
{$IFDEF OS2}
  Result := tDisc_DriveType(gPMWinx.Func.GetDriveType(Drive[0]));
  if Result = tDisc_dt_Unknown then
    begin
      if GetDriveInfo(Drive[0],iType,Name,FSDName,FSAData) = NO_ERROR then
        if iType = 4 then
          Result := tDisc_dt_Remote; {4} // Netz-Laufwerk
    end;
{$ENDIF}
{$IFDEF Win32}
   Result := tDisc_DriveType(GetDriveType(Drive[0]));
{$ENDIF}
end;

function tcDisc.GetDriveInfo(iDrive:Char;var iType:uShort;var Name,FSDName,FSAData:string):LongWord;
// Rckgabewerte:
// iType :   0=inexistent oder kein Medium, 3=lokal, 4=Netz oder CDWFS(->RSJ)
// Name :    Label-Name
// FSDName : getestet: 'FAT'(Floppy,VDISK...),'FAT32','HPFS','NTFS','JFS',
//                     'CDFS','LAN','CDWFS'(->RSJ),'UNKNOWN'
//           sowie offenbar: 'CD','NOVELL','TVFS','EXT2'
// FSAData : zum Beispiel: '\\SERVER\LW_G'
//

{$IFDEF OS2}
var BufLen     : uLong;
    FSQb       : pFSQBuffer2;
    DeviceName : cString;
    Ordinal    : uLong;
    DriveNr    : Word;
{$ENDIF}

begin
{$IFDEF OS2}
  BufLen := 1024;
  GetMem(FSQb,BufLen);
  FillChar(FSQb^,BufLen,0);
  DeviceName := UpperCase(iDrive)+':'#0;
  DriveNr    := ORD(DeviceName[0])-64;
  Ordinal    := 0; { =1 : keine Auswirkung festgestellt }
  iType      := 0;
  Name       := '';
  FSDName    := '';
  FSAData    := '';

  { Info: bei einem nicht existenten Disketten-Laufwerk B: kann vom System via }
  { eine DosQueryFSAttach Fehlermeldung zurckgommen, dass die Diskette nicht eingelegt sei.}
  { rc=107   ...beobachtet unter Warp-Server }
  Result := DosQueryFSAttach(DeviceName,Ordinal,FSAIL_QUERYNAME,FSQb^,BufLen);
  if Result = NO_ERROR
  then begin
         iType   := FSQb^.iType;
         Name    := StrPas(@FSQb^.szName);
         FSDName := StrPas(@FSQb^.szName+FSQb^.cbName+1);
         FSAData := StrPas(@FSQb^.szName+FSQb^.cbName+FSQb^.cbFSDName+2);

         { RAM-Disk: Bei Erstellung z.B. via config.sys-Eintrag DEVICE=C:\os2\boot\vdisk.sys}
         { 1024,128,64 ist FSDName='FAT', der Laufwerksname='OS2VDISK' und die Serial-Nr=0 }
       end;
  FreeMem(FSQb,BufLen);
{$ENDIF}
{$IFDEF Win32}
{$ENDIF}
end;


// -------------------------------------------------------------------------------------------

Function tcSysAppInfo.getDefaultBrowser : tFileName;

Var OutBuf: cstring;

Begin
{$IFDEF OS2}
  Fillchar(OutBuf, 255, 0);
  PrfQueryProfileString(HINI_USERPROFILE, 'WPURLDEFAULTSETTINGS', 'DefaultBrowserExe', '', OutBuf, 255);
  Result := OutBuf;
{$ENDIF}
{$IFDEF Win32}
  Result:=goSysInfo.Folders.OSPath+'EXPLORER.EXE';
{$ENDIF}

End;

Function tcSysAppInfo.getOdinPEExe : tFilename;

var Registry : tcRegistry;
    Path     : tFileName;

Begin
{$IFDEF OS2}
  try
    Registry.Create(taeKEY_LOCAL_MACHINE, 'SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\Setup');
    Path:=Registry.ReadString('','WinDir','');
    if Path=''
      then
        Begin
          Path:=Registry.ReadString('','SysDir','');
          if Path<>'' then begin
            Path:=Path+{system}'32\pe.exe';     // z.b. F:\OS2_SYSTEM\ODIN\SYSTEM
            Result:=iif(FileExists(Path), Path, '');
          end
        End
      else
        Begin
          Path:=Path+'SYSTEM32\PE.EXE';
          Result:=iif(FileExists(Path), Path, '');
        End;
    Registry.Destroy;
  except
    Result:='';
  end;
{$ENDIF}
{$IFDEF Win32}
  Result:='';   // Unter Windows gibt es kein Odin-System
{$ENDIF}
End;

Function tcSysAppInfo.getSysInfo : tFileName;

{$IFDEF Win32}
var Registry : tcRegistry;
{$ENDIF}

Begin
{$IFDEF OS2}
  Result:='';   // Unter OS/2 gibt es momentan kein SysInfo-Programm
{$ENDIF}
{$IFDEF Win32}
  try
    Registry.Create(taeKEY_LOCAL_MACHINE, 'Software\Microsoft\Shared Tools\MSInfo');
    Result:=Registry.ReadString('','Path','');
    Registry.Destroy;
  except
    Result:='';
  end;
{$ENDIF}
End;


// -------------------------------------------------------------------------------------------

Function tcProgramInfo.getExename : tFilename;

Begin
  Result:=fPath+fName+EXT_UC_EXE;
End;


Constructor tcProgramInfo.Create;

Var cModName: cString;
{$IFDEF OS2}
    tib     : PTIB;
    pib     : PPIB;
{$ENDIF}

Begin
  inherited Create;

{$IFDEF OS2}
  DosGetInfoBlocks(tib,pib);
  DosQueryModuleName(pib^.pib_hmte, 255, cModName);
  FName:=Uppercase(cModName);
{$ENDIF}
{$IFDEF Win32}
  {cProgName : cString;}
  GetModuleFileName(0, cModName, 255);
  FName := Uppercase(cModName);
{$ENDIF}
  FPath:=ExtractFilePath(fName);
  FName:=ExtractFileName(FName);
  FName:=Copy(FName,1,Pos('.',FName)-1);

End;

// -------------------------------------------------------------------------------------------

Function tcWDSibylInfo.GetDir : tFilename;

{$IFDEF OS2}
var UserIni : tIniFile;
{$ENDIF}
{$IFDEF Win32}
var Registry : tcRegistry;
{$ENDIF}

Begin
  try
{$IFDEF OS2}
    UserIni.Create(goSysInfo.UserINI);
    Result:=UserIni.ReadString(cWDSibyl, cIDWDSibylPath,'');
    UserIni.Destroy;
{$ENDIF}
{$IFDEF Win32}
    Registry.Create(taeKEY_LOCAL_MACHINE, 'SOFTWARE\WDSibyl');
    Result:=Registry.ReadString('',cIDWDSibylPath,'');
    Registry.Destroy;
{$ENDIF}
    if (Result<>'') and (Result[Length(Result)]<>'\') then
      Result:=Result+'\';
  except
    Result:='';
  end;
End;

Function tcWDSibylInfo.GetInstalled: Boolean;

Begin
  Result:=GetDir<>'';
End;

Function tcWDSibylInfo.GetDirBin : tFileName;

Begin
  Result:='';
  if GetInstalled=false then exit;
  Result:=GetDir+'BIN\';
{$IFDEF OS2}
  Result:=Result+'OS2\';
{$ENDIF}
{$IFDEF Win32}
  Result:=Result+'Wib32\';
{$ENDIF}
End;

Function tcWDSibylInfo.GetSibylINIFile : tFileName;

Begin
  if GetInstalled=false
    then Result:=''
    else Result:=GetDirBin+'Sibyl'+Ext_UC_INI;
End;

Function tcWDSibylInfo.GetWDSibylINIFile : tFileName;

Begin
  if GetInstalled=false
    then Result:=''
    else Result:=GetDirBin+'WDSibyl'+Ext_UC_INI;
End;

Const WDSibylSecTools = 'Tools';

Function tcWDSibylInfo.GetToolInfo(iName : String;
           var iToolNr   : LongInt;
           var iFileName : tFileName; var iFileParameter : String) : Boolean;

var f,s: String;
    ini: TAsciiIniFile;

Begin
  Result:=false;
  iToolNr:=-1;
  iFileName:='';
  iFileParameter:='';
  if GetInstalled=false then exit;

  try
    ini.Create(GetSibylINIFile);
    For iToolNr := 0 to MaxInt do
      Begin
        f := 'Tool' + tostr(iToolNr);
        s := ini.ReadString(WDSibylSecTools,f+'.Name','?');
        if s = '?'
          then break {keine weiteren Eintrge mehr vorhanden}
        else if s=iName
          then
            Begin
              Result:=true;
              iFileName     := ini.ReadString(WDSibylSecTools,f+'.Program','');
              iFileParameter:= ini.ReadString(WDSibylSecTools,f+'.Parameter','');
            End;
      End;
    ini.destroy;
  except
  end;
End;

Function tcWDSibylInfo.ModifyToolInfo(iToolNr : LongInt;
           iName : String; iPrgFileName : TFileName; iPrgFileParam: String) : Boolean;

var f  : String;
    ini: TAsciiIniFile;

Begin
  Result:=false;
  try
    ini.Create(GetSibylINIFile);
    f := 'Tool' + tostr(iToolNr);
    ini.WriteString(WDSibylSecTools,f+'.Name',     iName);
    ini.WriteString(WDSibylSecTools,f+'.Program',  iPrgFileName);
    ini.WriteString(WDSibylSecTools,f+'.Parameter',iPrgFileParam);
    ini.destroy;
  except
  end;
End;

// -------------------------------------------------------------------------------------------

Function tcSysInfo.SystemMetrics(Const iSystemMetrics : TSystemMetrics):LongInt;

Begin
  {$IFDEF OS2}
  Result := WinQuerySysValue(HWND_DESKTOP, iSystemMetrics);
  If iSystemMetrics = smCxMinMaxButton then
    Result := Result Div 2;
  {$ENDIF}
  {$IFDEF Win32}
  Result := GetSystemMetrics(iSystemMetrics);
  {$ENDIF}
End;

Function tcSysInfo.GetLocInfo(Const iLCType : LongWord; iDefault : String) : String;

Var Data : cString;

Begin
  if fCID=0
    then Result:=iDefault
    else
      if gPMWinx.Func.GetLocaleInfo(fCID, iLCType, Data, 255) = 0
        then Result:=iDefault
        else Result:=Data;
End;

Function tcSysInfo.GetLocInfoInt(Const iLCType : LongWord; iDefault : LongInt) : LongInt;

Begin
  Result:=StrToInt(GetLocInfo(iLCType, toStr(iDefault)));
End;

Function tcSysInfo.getEnvCount : LongInt;

Begin
  Result:=SysUtils.getEnvCount;
End;

Function tcSysInfo.getEnv(const iEnv:String):AnsiString;

Begin
  Result:=SysUtils.getEnv(iEnv);
End;

{$IFDEF OS2}
Procedure tcSysInfo.getOS2Info;

Var Ini    : tIniFile;
    Device : BYTE;
    Reg    : tcRegistry;

label ReadINI;

Begin
{ OS/2-Versionen herausfinden }
  fSystemIni:= GetEnv('SYSTEM_INI');
  fUserIni  := GetEnv('USER_INI');
  Ini.Create(fUserIni);

{ CID herausfinden }
  fCID:=0;
  if (ApplicationType=cApplicationType_GUI) and
     (fOS.Platform in [OS2Ver40, OS2Ver45]) then
    try
      fCID:=gpmWinX.GetUserDefaultLCID
    except
    end;

{ Ermitteln der Land-Parameter }
  fCountry.CountryID:=ini.ReadInteger(SecPMNational, 'iCountry', 0);
  fCountry.CurrencyString := ini.ReadString(SecPMNational, 'sCurrency', 'EUR');
  fCountry.LangEnv := GetEnv('LANG');

  if fOS.Version_Minor < 40
    then        // OS2-Version unter OS2/Warp
      Begin     // --> Die Daten von der OS/2-Ini nehmen
ReadINI:
        fCountry.ThousandSeparator:= ini.ReadString(SecPMNational, 'sThousand', ',')[1];
        fCountry.DecimalSeparator := ini.ReadString(SecPMNational, 'sDecimal', '.')[1];
        fCountry.CurrencyDecimals := ini.ReadInteger(SecPMNational, 'iCurrency', 2);
        fCountry.ListSeparator    := ini.ReadString(SecPMNational, 'sList', ';')[1];
      End
    else        // Es ist eine OS/2-Warp-Version oder hoeher
      Begin     // --> Die Daten von der Reg-Datenbank nehmen
        try
          Reg.Create(taeKEY_CURRENT_USER,'CONTROL PANEL\INTERNATIONAL');
          fCountry.ThousandSeparator := Reg.ReadString('','sThousand','.')[1];
          fCountry.DecimalSeparator := Reg.ReadString('','sDecimal','.')[1];
          fCountry.CurrencyDecimals := Reg.ReadInteger('','iCurrDigits',2);
          fCountry.ListSeparator := Reg.ReadString('','sList',';')[1];
          Reg.Destroy;
        except
          goto ReadINI;
        end;
      End;

{ PC-Info herausfinden }
  DosDevConfig(fPC.CouFloppy, DEVINFO_FLOPPY);
  If DosDevConfig(Device, DEVINFO_COPROCESSOR)=0 then
    fPC.CoProcessor:=Device>0;
  DosDevConfig(fPC.CouCOM, DEVINFO_RS232);
  DosDevConfig(fPC.CouLPT, DEVINFO_PRINTER);
  DosDevConfig(fPC.Model, DEVINFO_MODEL);
  DosDevConfig(fPC.SubModel, DEVINFO_SUBMODEL);

{ Screen-Info herausfinden }
  if DosDevConfig(Device, DEVINFO_ADAPTER)=0 then
    fScreen.MonoDisplay:=Device=0;

{ ben”tigte Objekte schliessen }
  Ini.Destroy;
End;
{$ENDIF}
{$IFDEF Win32}
Procedure tcSysInfo.getWinInfo;

Begin
{ Windows-Versionen herausfinden }
  fSystemIni:='';
  fUserIni  :='';

{ CID herausfinden }
  fCID:=GetUserDefaultLCID;

{ Ermitteln der Land-Parameter }
  fCountry.CountryID     := GetLocInfoInt(LOCALE_ICOUNTRY , 0);
  fCountry.CurrencyString:= GetLocInfo(LOCALE_SCURRENCY   , 'EUR');
  fCountry.LangEnv := GetEnv('LANG');
  fCountry.LangEnv:=Copy(GetLocInfo(LOCALE_SLANGUAGE, 'DE'),1,2);
  fCountry.LangEnv:=lowercase(fCountry.LangEnv) + '_' +
                        uppercase(fCountry.LangEnv);
  fCountry.ThousandSeparator:= GetLocInfo(LOCALE_STHOUSAND,'.')[1];
  fCountry.DecimalSeparator := GetLocInfo(LOCALE_SDECIMAL,',')[1];
  fCountry.CurrencyDecimals := GetLocInfoInt(LOCALE_IDIGITS,2);
  fCountry.ListSeparator    := GetLocInfo(LOCALE_SLIST,':')[1];

{ PC-Info herausfinden }
  fPC.CouCOM     :=2;     { 2 Serielle-Schnittstellen }
  fPC.CouLPT     :=1;     { 2 Parallele-Schnittstellen }
  fPC.CouFloppy  :=1;     { 1 Floppy Laufwerk }
  fPC.CoProcessor:=true;  { Luft Win32 noch ohne CoProzessor? }
  fPC.Model      :=255;
  fPC.SubModel   :=1;

{ Screen-Info herausfinden }
  fScreen.MonoDisplay:=false; { Windows verwendet ein Farb-Bildschirm }

End;
{$ENDIF}

Constructor tcSysInfo.Create;

Begin
  inherited Create;

  FillChar(fCountry, sizeof(trCountry), #0);
  FillChar(fPC, sizeof(trPC), #0);

  fDisc.Create;
  fFolders.Create;
  fOS.Create;

{$IFDEF OS2}
  getOS2Info;
{$ENDIF}
{$IFDEF Win32}
  getWinInfo;
{$ENDIF}

// Sub-Klassen
  fDateTime.Create;
  fSysAppInfo.Create;
  fProgramInfo.Create;
  fWDSibylInfo.Create;

// Formate:
  Case fCountry.CurrencyFormat Of
    0: fCountry.NegCurrFormat := 1;
    1: fCountry.NegCurrFormat := 5;
    2: fCountry.NegCurrFormat := 9;
    3: fCountry.NegCurrFormat := 8;
  End;

{ Lnderinformationen ermitteln }
  fCountry.CountryName:=GetLocInfo(LOCALE_SCOUNTRY , 'Deutschland');
  fCountry.CountryEngName:=GetLocInfo(LOCALE_SENGCOUNTRY, 'Germany');
  fCountry.Language   :=GetLocInfo(LOCALE_SLANGUAGE , 'Deutsch');
  fCountry.LanguageEng:=GetLocInfo(LOCALE_SENGLANGUAGE , 'German');

{ Screen-Informationen ermitteln }
  fScreen.Size.CX:=SystemMetrics(smCXScreen);
  fScreen.Size.CY:=SystemMetrics(smCYScreen);
  fScreen.IconSize.CX:=SystemMetrics(smCXIcon);
  fScreen.IconSize.CY:=SystemMetrics(smCYIcon);
  fScreen.PointerSize.CX:=SystemMetrics(smCXPointer);
  fScreen.PointerSize.CY:=SystemMetrics(smCYPointer);
  fScreen.SizeBorderSize.CX:=SystemMetrics(smCxSizeBorder);
  fScreen.SizeBorderSize.CY:=SystemMetrics(smCySizeBorder);
  fScreen.BorderSize.CX:=SystemMetrics(smCxBorder);
  fScreen.BorderSize.CY:=SystemMetrics(smCyBorder);
  fScreen.DlgBorderSize.CX:=SystemMetrics(smCxDlgBorder);
  fScreen.DlgBorderSize.CY:=SystemMetrics(smCyDlgBorder);
  fScreen.FullScreenSize.CX:=SystemMetrics(smCxFullScreen);
  fScreen.FullScreenSize.CY:=SystemMetrics(smCyFullScreen);
  fScreen.HScrollArrowSize.CX:=SystemMetrics(smCxHScrollArrow);
  fScreen.HScrollArrowSize.CY:=SystemMetrics(smCyHScrollArrow);
  fScreen.VScrollArrowSize.CX:=SystemMetrics(smCxVScrollArrow);
  fScreen.VScrollArrowSize.CY:=SystemMetrics(smCyVScrollArrow);
  fScreen.MinMaxButtonSize.CX:=SystemMetrics(smCxMinMaxButton);
  fScreen.MinMaxButtonSize.CY:=SystemMetrics(smCyMinMaxButton);

  fScreen.TitlebarSize:=SystemMetrics(smCyTitlebar);
  fScreen.VScrollSize :=SystemMetrics(smCxVScroll);
  fScreen.HScrollSize :=SystemMetrics(smCyHScroll);
  fScreen.MenuSize    :=SystemMetrics(smCyMenu);
  fScreen.HSliderSize :=SystemMetrics(smCxHSlider);
  fScreen.VSliderSize :=SystemMetrics(smCyVSlider);

{ Maus-Informationen herausfinden }
  fMouse.Present    :=SystemMetrics(smMousePresent)<>0;
  fMouse.CouBottons :=SystemMetrics(smCMouseButtons);
  fMouse.SwapButton :=SystemMetrics(smSwapButton)<>0;
End;

Destructor tcSysInfo.Destroy;

Begin
  fProgramInfo.Destroy;
  fSysAppInfo.Destroy;
  fWDSibylInfo.Destroy;
  fFolders.Destroy;
  fDisc.Destroy;
  fDateTime.Destroy;
  fOS.Destroy;
  inherited Destroy;
End;

var Cou : Integer;

Initialization
  goSysInfo.Create;

{ Befuellen der Variablen aus SysUtils }
  DateSeparator    := goSysInfo.DateTime.DateSeparator;
  ShortDateFormat  := goSysInfo.DateTime.ShortDateFormat;
  LongDateFormat   := goSysInfo.DateTime.LongDateFormat;
  For Cou:=1 To MaxDays Do
    Begin
      ShortDayNames[Cou]:= goSysInfo.DateTime.ShortDayNames[Cou-1];
      LongDayNames[Cou] := goSysInfo.DateTime.LongDayNames[Cou-1];
    End;
  For Cou:=1 To MaxMonths Do
    Begin
      ShortMonthNames[Cou]:= goSysInfo.DateTime.ShortMonthNames[Cou-1];
      LongMonthNames[Cou] := goSysInfo.DateTime.LongMonthNames[Cou-1];
    End;
  DateOrder        := goSysInfo.DateTime.DateOrder;
  TimeSeparator    := goSysInfo.DateTime.TimeSeparator;
  TimeAMString     := goSysInfo.DateTime.TimeAMString;
  TimePMString     := goSysInfo.DateTime.TimePMString;
  ShortTimeFormat  := goSysInfo.DateTime.ShortTimeFormat;
  LongTimeFormat   := goSysInfo.DateTime.LongTimeFormat;
  TwelveHours      := goSysInfo.DateTime.TwelveHours;
  CurrencyString   := goSysInfo.Country.CurrencyString;
  CurrencyFormat   := goSysInfo.Country.CurrencyFormat;
  NegCurrFormat    := goSysInfo.Country.NegCurrFormat;
  ThousandSeparator:= goSysInfo.Country.ThousandSeparator;
  DecimalSeparator := goSysInfo.Country.DecimalSeparator;
  CurrencyDecimals := goSysInfo.Country.CurrencyDecimals;
  ListSeparator    := goSysInfo.Country.ListSeparator;

// Globale Mutex und CrtiSev (war frueher in SyncObj.pas)
  GlobalMutex.Create(goSysInfo.ProgramInfo.Name);
  if (goSysInfo.os.RunUnder=ruOdin) and
     (ApplicationType<>cApplicationType_GUI)
    then GlobalCritSec:=nil
    else GlobalCritSec.Create;  // Funktioniert momentan nicht in ODIN

Finalization
  GlobalMutex.Destroy;
  if GlobalCritSec<>nil then
    GlobalCritSec.Destroy;

  goSysInfo.Destroy;
End.


{ -- date -- -- from -- -- changes ----------------------------------------------
  17-Nov-03  WD         Unit erstellt
  31-Jul-04  WD         Neue globale Variable "goSysInfo".
  31-Jul-04  WD         Befuellen der Variablen von SYSUtils im Unit-Begin-Teil
  18-Okt-04  WD         Umbau des Initialization/Finalization-Teil
  30-Okt-04  WD         Einbau der Druckerinformationen
  10-Mar-05  WD         Einbau von ProgramPath und ProgramName
  21-Mai-05  WD         Einbau von tros.os2cmd
  04-Dez-05  WD         Klasse tcSysAppInfo (Div. Info zu Applikationen) eingebaut.
  27-Feb-06  WD         tcSysAppInfo: Odin-PE.EXE eingebaut
  07-Mar-06  MV/WD      Bessere Ermittlung von fProgramName und fProgramPath und
                        Verschiebung der Variable in das Objekt ProgramInfo.
  09-Mar-06  MV/WD      Win32: Bessere Ermittlung von fOS.OSCmd
  17-Apr.06  WD         tcSysAppInfo: getSysInfo eingebaut.
  24-Apr-06  WD         tcSysInfo.getWinInfo: Ermittlung des LongTimeFormat korrigiert
  23-Aug-06  RG/WD      ThousandSeparator, DecimalSeparator, CurrencyDecimals und
                        ListSeparator in das Record tcCountry eingebaut.
  22-Sep-06  WD         Umbau der Verzeichnisse in die Klasse tcFolders.
  26-Oct-06  WD         Klasse: tcDisc eingebaut.
  14-Nov-06  UJ, WD     Systemabsturz, wenn das Programm "CONTROL PANEL\INTERNATIONAL" nicht einlsen kann
  23-Mar-07  WD         Bessere Ermittlung von tcFolders.OSPath.
  10-Apr-07  WD         Variable RunUnder eingebaut. Zeigt an ob das Win-Programm unter ODIN luft
  04-Mai-07  WD         Einbau von der Windows-Vesion Vista.
  10-Mai-07  MV, WD     Definition vom OS-Name verlaengert.
  31-Mai-07  MV, WD     tcSysAppInfo.getOdinPEExe: Falls WinDir nicht existiert dann SysDir verwenden
  21-Aug-07  WD         tcSysInfo.getEnv: Das Ergebnis wird statt String mit AnsiString uebergeben.
  25-Sep-07  WD         tcSysInfi.WDSibylInfo: Neue Funktionen eingebaut.
  26-Feb-08  MV         Query Windows Desktop Directory moved from initialization to first usage (vista bug problem)
  07-Mar-08  WD         Konstante EXT_CSV, EXT_XML und EXT_DBF eingebaut.
  06-Jun-08  WD         Umbau vom Record trDateTime auf die Klasse tcDateTime.
  11-Jun-08  WD         Die Extension von Grossbuchstaben auf Kleinbuchstaben
  09-Sep-08  WD         Extension: SQL eingebaut.
  31-Mar-09  RG         Funktion: TickCount
}
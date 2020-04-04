Unit PMWINX;

Interface

Uses uSysClass;

Const LOCALE_ILANGUAGE            = $01;
      LOCALE_SLANGUAGE            = $02;
      LOCALE_SENGLANGUAGE         = $1001;
      LOCALE_SABBREVLANGNAME      = $03;
      LOCALE_SNATIVELANGNAME      = $04;
      LOCALE_ICOUNTRY             = $05;
      LOCALE_SCOUNTRY             = $06;
      LOCALE_SENGCOUNTRY          = $1002;
      LOCALE_SABBREVCTRYNAME      = $07;
      LOCALE_SNATIVECTRYNAME      = $08;
      LOCALE_IDEFAULTLANGUAGE     = $09;
      LOCALE_IDEFAULTCOUNTRY      = $0A;
      LOCALE_IDEFAULTCODEPAGE     = $0B;
      LOCALE_SLIST                = $0C;
      LOCALE_IMEASURE             = $0D;
      LOCALE_SDECIMAL             = $0E;
      LOCALE_STHOUSAND            = $0F;
      LOCALE_SGROUPING            = $10;
      LOCALE_IDIGITS              = $11;
      LOCALE_ILZERO               = $12;
      LOCALE_SNATIVEDIGITS        = $13;
      LOCALE_SCURRENCY            = $14;
      LOCALE_SINTLSYMBOL          = $15;
      LOCALE_SMONDECIMALSEP       = $16;
      LOCALE_SMONTHOUSANDSEP      = $17;
      LOCALE_SMONGROUPING         = $18;
      LOCALE_ICURRDIGITS          = $19;
      LOCALE_IINTLCURRDIGITS      = $1A;
      LOCALE_ICURRENCY            = $1B;
      LOCALE_INEGCURR             = $1C;
      LOCALE_SDATE                = $1D;
      LOCALE_STIME                = $1E;
      LOCALE_SSHORTDATE           = $1F;
      LOCALE_SLONGDATE            = $20;
      LOCALE_STIMEFORMAT          = $1003;
      LOCALE_IDATE                = $21;
      LOCALE_ILDATE               = $22;
      LOCALE_ITIME                = $23;
      LOCALE_ICENTURY             = $24;
      LOCALE_ITLZERO              = $25;
      LOCALE_IDAYLZERO            = $26;
      LOCALE_IMONLZERO            = $27;
      LOCALE_S1159                = $28;
      LOCALE_S2359                = $29;
      LOCALE_SDAYNAME1            = $2A;
      LOCALE_SDAYNAME2            = $2B;
      LOCALE_SDAYNAME3            = $2C;
      LOCALE_SDAYNAME4            = $2D;
      LOCALE_SDAYNAME5            = $2E;
      LOCALE_SDAYNAME6            = $2F;
      LOCALE_SDAYNAME7            = $30;
      LOCALE_SABBREVDAYNAME1      = $31;
      LOCALE_SABBREVDAYNAME2      = $32;
      LOCALE_SABBREVDAYNAME3      = $33;
      LOCALE_SABBREVDAYNAME4      = $34;
      LOCALE_SABBREVDAYNAME5      = $35;
      LOCALE_SABBREVDAYNAME6      = $36;
      LOCALE_SABBREVDAYNAME7      = $37;
      LOCALE_SMONTHNAME1          = $38;
      LOCALE_SMONTHNAME2          = $39;
      LOCALE_SMONTHNAME3          = $3A;
      LOCALE_SMONTHNAME4          = $3B;
      LOCALE_SMONTHNAME5          = $3C;
      LOCALE_SMONTHNAME6          = $3D;
      LOCALE_SMONTHNAME7          = $3E;
      LOCALE_SMONTHNAME8          = $3F;
      LOCALE_SMONTHNAME9          = $40;
      LOCALE_SMONTHNAME10         = $41;
      LOCALE_SMONTHNAME11         = $42;
      LOCALE_SMONTHNAME12         = $43;
      LOCALE_SABBREVMONTHNAME1    = $44;
      LOCALE_SABBREVMONTHNAME2    = $45;
      LOCALE_SABBREVMONTHNAME3    = $46;
      LOCALE_SABBREVMONTHNAME4    = $47;
      LOCALE_SABBREVMONTHNAME5    = $48;
      LOCALE_SABBREVMONTHNAME6    = $49;
      LOCALE_SABBREVMONTHNAME7    = $4A;
      LOCALE_SABBREVMONTHNAME8    = $4B;
      LOCALE_SABBREVMONTHNAME9    = $4C;
      LOCALE_SABBREVMONTHNAME10   = $4D;
      LOCALE_SABBREVMONTHNAME11   = $4E;
      LOCALE_SABBREVMONTHNAME12   = $4F;
      LOCALE_SABBREVMONTHNAME13   = $100F;
      LOCALE_SPOSITIVESIGN        = $50;
      LOCALE_SNEGATIVESIGN        = $51;
      LOCALE_IPOSSIGNPOSN         = $52;
      LOCALE_INEGSIGNPOSN         = $53;
      LOCALE_IPOSSYMPRECEDES      = $54;
      LOCALE_IPOSSEPBYSPACE       = $55;
      LOCALE_INEGSYMPRECEDES      = $56;
      LOCALE_INEGSEPBYSPACE       = $57;

// Konstanten fuer GetVolumeInformation
Const FS_CASE_SENSITIVE           = $0001; // Gross- und Kleinschreibung von Dateinamen wird berÅcksichtigt
      FS_CASE_IS_PRESERVED        = $0002; // Gross- und Kleinschreibung von Dateinamen wird erhalten.
      FS_UNICODE_ON_DISK          = $0004; // Unicode Dateinamen werden unterstÅtzt.
      FS_PERSISTENT_ACLS          = $0008; // Accesslisten werden unterstÅtzt / gefordert (z.B. bei Windows2000)
      FS_FILE_COMPRESSION         = $0010; // UnterstÅtzt Dateikomprimierung.
      FS_VOL_IS_COMPRESSED        = $8000; // Komprimierter DatentrÑger.

// Konstanten fuer GetDriveType
Const DRIVE_UNKNOWN = 0;         // unbekannt
      DRIVE_NO_ROOT_DIR = 1;
      DRIVE_REMOVABLE = 2;       // Diskettenlaufwerk/WechseldatentrÑger (z.B. auch ZIP)
      DRIVE_FIXED = 3;           // Festplatte
      DRIVE_REMOTE = 4;          // Netz-Laufwerk
      DRIVE_CDROM = 5;           // CD-Rom Laufwerk
      DRIVE_RAMDISK = 6;         // RAM-Laufwerk

Type
  pPMWinxFunc=^tPMWinxFunc;
  tPMWinxFunc=Record
    GetUserDefaultLCID  : Function : LongWord; APIENTRY;
    GetLocaleInfo       : Function(LCID : LongWord; LCType : LongWord; var lpLCData : CString;
                                  lLength : Longword) : LongWord; APIENTRY;
    GetVolumeInformation: Function(CONST lpRootPathName:CSTRING;
                                   VAR lpVolumeNameBuffer:CSTRING;      // VolumeName
                                   nVolumeNameSize:ULONG;
                                   VAR lpVolumeSerialNumber:ULONG;      // SerialNumber
                                   VAR lpMaximumComponentLength:ULONG;
                                   VAR lpFileSystemFlags:ULONG;
                                   VAR lpFileSystemNameBuffer:CSTRING;  // FileSystem
                                   nFileSystemNameSize:ULONG):LongWord; APIENTRY; {BOOL;}
    GetDriveType        : Function(CONST lpRootPathName:CSTRING):ULONG; APIENTRY;
  End;

  tcPMWinx = Class(tcDLL)
    private
      fPMWinxFunc : tPMWinxFunc;
    Public
      Function GetUserDefaultLCID : LongWord;
      Constructor Create; virtual;
      property Func : tPMWinxFunc read fPMWinxFunc;
  End;

Var gPMWinx : tcPMWinx;

Implementation

Function tcPMWinx.GetUserDefaultLCID : LongWord;

Begin
  if @fPMWinxFunc.GetUserDefaultLCID=nil
    then Result:=0
    else Result:=fPMWinxFunc.GetUserDefaultLCID
End;

Constructor tcPMWinx.Create;

Begin
  try
{$IFDEF OS2}
    inherited Create('PMWINX.DLL');
    Upper:=true;
{$ENDIF}
{$IFDEF Win32}
    inherited Create('KERNEL32.DLL');
    Upper:=false;
{$ENDIF}
  except
  end;
  fillchar(fPMWinxFunc,sizeOf(tPMWinxFunc),#0);
  if DLLLoaded then
    Begin
      try
        fPMWinxFunc.GetUserDefaultLCID:=pointer(GetProcAddress('GetUserDefaultLCID'));
{$IFDEF OS2}
        fPMWinxFunc.GetLocaleInfo:=pointer(GetProcAddress('GetLocaleInfo'));
        fPMWinxFunc.GetVolumeInformation:=pointer(GetProcAddress('GETVOLUMEINFORMATION'));
        fPMWinxFunc.GetDriveType:=pointer(GetProcAddress('GETDRIVETYPE'));
{$ENDIF}
{$IFDEF Win32}
        fPMWinxFunc.GetLocaleInfo:=pointer(GetProcAddress('GetLocaleInfoA'));
        fPMWinxFunc.GetVolumeInformation:=pointer(GetProcAddress('GetVolumeInformationA'));
        fPMWinxFunc.GetDriveType:=pointer(GetProcAddress('GetDriveTypeA'));
{$ENDIF}
      except
      end;
    End;
End;

Initialization
  gPMWinx.Create;

Finalization
  if gPMWinx<>nil then
    gPMWinx.Destroy;
End.


{ -- date -- -- from -- -- changes ----------------------------------------------
  17-Nov-03  WD         Unit erstellt
  19-Jan-03  WD         Umbau in eine Klasse.
  26-Oct-06  RG, WD     Einbau von GetVolumeInformation und GetDriveType
  14-Mar-07  WD         Einbau von tcPMWinx.GetUserDefaultLCID.
}
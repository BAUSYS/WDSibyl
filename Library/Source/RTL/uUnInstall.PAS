{***********************************
 uUnInstall.pas
 WDSibyl unit for uninstall functions
 -----------------------------------
 begin  : Aug 2006
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uUnInstall;

Interface

uses SysUtils, Inifiles, uString, uSysInfo, uDateTime;

Function GetHexString(sVal: String): String;
Function GetHexVal(sVal: String): String;
Function GetFileDate(aFilename: String): TDateTime;
Function GetUnixHexFileDate(aFilename: String; aString: Boolean; aOffset: Integer): String;
Function GetHexFileSize(aFilename: String; aString: Boolean): String;
Function SetUninstall(aAuthor, aProgname, aPaket, aVersion, aUninstaller: String; aFiles, aSize: Integer): Integer;
{$IFDEF Win32}
Function DelUninstall(aProgname: String): Integer;
{$ENDIF}

Implementation

{***********************************
* convert TDateTime in Hex string
*
* @param aTime: TDateTime
* @return String
***********************************}
Function HexDateTime(aDateTime: TDateTime): String;
var
  nY, nM, nD, nH, nMn, nS, nMs: Word;
  sHex, sYear: String;
begin
  DecodeDate(aDateTime, nY, nM, nD);
  DecodeTime(aDateTime, nH, nMn, nS, nMs);
  sHex := '0' + IntToHex(nY,2);
  sYear := chr(strtoint('$'+copy(sHex,3,2))) +
           chr(strtoint('$'+copy(sHex,1,2)));
  RESULT := chr(nH) + chr(nMn) + chr(nS) + chr(14) +
  chr(nD) + chr(nM) + sYear;
end;

{***********************************
* get Hex string from value
* Attention: 4 bytes hard coded
*
* @param sVal: String
* @return String
***********************************}
Function GetHexString(sVal: String): String;
var
  sHex,sFill: String;
Begin
  sHex := '00000000' + IntToHex(strtoint(sVal),4);
  sHex := copy(sHex,length(sHex)-7,8);
  RESULT := copy(sHex,7,2)+copy(sHex,5,2)+copy(sHex,3,2)+copy(sHex,1,2);
End;

{***********************************
* get Hex value from value
* Attention: 4 bytes hard coded
*
* @param sVal: String
* @return String
***********************************}
Function GetHexVal(sVal: String): String;
var
  sHex, sFull: String;
Begin
  sHex := '00000000' + IntToHex(strtoint(sVal),4);
  sHex := copy(sHex,length(sHex)-7,8);
  sFull := chr(strtoint('$'+copy(sHex,7,2))) +
           chr(strtoint('$'+copy(sHex,5,2))) +
           chr(strtoint('$'+copy(sHex,3,2))) +
           chr(strtoint('$'+copy(sHex,1,2)));
  RESULT := sFull;
End;

{***********************************
* get file date
*
* @param aFilename: String
* @return TDateTime
***********************************}
Function GetFileDate(aFilename: String): TDateTime;
var
  nFileAge: LongInt;
Begin
  nFileAge := FileAge(aFilename);
  RESULT := FileDateToDateTime(nFileAge);
End;

{***********************************
* get file date as unix timestamp
*
* @param aFilename: String
* @param aString: boolean
* @param aOffset: Integer (in hours)
* @return String
***********************************}
Function GetUnixHexFileDate(aFilename: String; aString: Boolean; aOffset: Integer): String;
var
  nFileAge: LongInt;
  nFileDate: TDateTime;
  nUnixDate: LongInt;
Begin
  nFileAge := FileAge(aFilename);
  nFileDate := FileDateToDateTime(nFileAge);
  nUnixDate := DateTimetoUNIX(nFileDate)+aOffset;
  if aString then
    RESULT := GetHexString(inttostr(nUnixDate))
  else
    RESULT := GetHexVal(inttostr(nUnixDate));
End;

{***********************************
* get file size as unix value
*
* @param aFilename: String
* @param aString
* @return String
***********************************}
Function GetHexFileSize(aFilename: String; aString: Boolean): String;
var
  SearchRec: TSearchRec;
  nFileSize: LongInt;
Begin
  SysUtils.FindFirst(aFilename,faAnyFile,SearchRec);
  nFileSize := SearchRec.Size;
  if aString then
     RESULT := GetHexString(inttostr(nFileSize))
  else
     RESULT := GetHexVal(inttostr(nFileSize));
End;

{***********************************
* Set uninstall for OS/2
*
* @param aAuthor: String
* @param aProgname: String (without spaces !)
* @param aVersion: String
* @param aUninstaller: String
* @param aFiles: Integer
* @param aSize: Integer
* @return Integer
*    -1 initial (should never return)
*     0 ok
*     1 Error or Exception
*     2 WarpIn not installed (OS2)
*     3 Problem during conect to registry (WIN32)
***********************************}
{$IFDEF OS2}
Function SetUninstall(aAuthor, aProgname, aPaket, aVersion, aUninstaller: String; aFiles, aSize: Integer): Integer;
var sWarpInPath: String;
    oINI: TInifile;
    sProgname: String;
    sFilename, sByteString: String;
    sTargetPath: String;
    sFileDate: String;
    oCmdList: TStringList;

Begin
  RESULT := -1;
  try
    oINI := TInifile.Create(goSysInfo.UserINI);
    sWarpInPath := oINI.ReadString('WarpIN', 'Path', '');
    oINI.Free;
    if PathExists(sWarpinPath) then begin           // warpin is installed
      sTargetPath := copy(ExtractFilePath(aUninstaller),1,length(ExtractFilePath(aUninstaller))-1);
      // write uninstall.txt in program folder, warpin needs one file
      oCmdList := TStringList.Create;
      oCmdList.Add('To uninstall this program, please use Warpin!');
      oCmdList.Add('------');
      oCmdList.Add('Zum Deinstallieren dieses Programmes bitte Warpin benutzen!');
      oCmdList.Savetofile(sTargetPath+'\uninstall.txt');
      // open warpin's database ini file and write keys that necesary
      oINI := TInifile.Create(AddPathSeparator(sWarpInPath)+'DATBAS_D.INI');
      aVersion := ReplaceAll(aVersion,'.','\');
      sProgname := aAuthor + '\' + aProgname + '\' + aPaket + '\' + aVersion;
      oINI.WriteString(sProgname,'TargetPath',sTargetPath);
      oINI.WriteString(sProgname,'DirsCreated',sTargetPath);
      oINI.WriteString(sProgname,'DeExecuteResolved',aUninstaller);
      sFileDate := GetUnixHexFileDate(aUninstaller,false,+(60*60*4));
      sFilename := ExtractFileName(aUninstaller);
      sByteString := sFilename + chr(0) + sFileDate + sFileDate
        + GetHexFileSize(aUninstaller,false) + chr(0);
      sFilename := sTargetPath+'\uninstall.txt';
      sFileDate := GetUnixHexFileDate(sFilename,false,+(60*60*4));
      sByteString := sByteString + 'uninstall.txt' + chr(0) + sFileDate + sFileDate
        + GetHexFileSize(sFilename,false) + chr(0);
      oINI.WriteStringRaw(sProgname,'Files',sByteString);
      sByteString := HexDateTime(now) + chr(0) + chr(0) + chr(0);
      oINI.WriteStringRaw(sProgname,'InstallDateTime',sByteString);
      oINI.WriteStringRaw(sProgname,'WIPackHeader',chr(1)+chr(1)+getHexVal(inttostr(aFiles))
        +chr(0) + chr(0) + getHexVal(inttostr(aSize)));
      oINI.Free;
      RESULT := 0;
    end else
      RESULT := 2;
  except
    RESULT := 1;
  end;
End;
{$ENDIF}

{***********************************
* Set uninstall for WIN32
*
* @param aProgname: String (without spaces !)
* @param aVersion: String
* @param aUninstaller: String
* @return Integer
*    -1 initial (should never return)
*     0 ok
*     1 Error or Exception
*     3 Problem during conect to registry (WIN32)
***********************************}
{$IFDEF WIN32}
Function SetUninstall(aAuthor, aProgname, aPaket, aVersion, aUninstaller: String; aFiles, aSize: Integer): Integer;
var
  oReg, oRegIns : tcRegistry;
  sWin, sUninsCmd: String;
  oCmdList: TStringList;
begin
  RESULT := -1;
  try
    goSysInfo.Env['windir'];
    sUninsCmd := sWin + '\Unins_'+ aProgname+'.cmd';
    // create Unins-CMD in windows directory
    // will be written if writing in registry is ok, see later
    oCmdList := TStringList.Create;
    oCmdList.Add('@echo off');
    oCmdList.Add('rem Uninstaller call for ' + aProgname);
    oCmdList.Add(aUninstaller + ' ' +aProgname);
    oCmdList.Add('del ' + aUninstaller);
    oCmdList.Add('rd ' + ExtractFilePath(aUninstaller));
    oCmdList.Add('del ' + sUninsCmd);
    // put settings in registry
    oReg := tcRegistry.Create(taeKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\UnInstall\');
    oRegIns := oReg.CreateSection(aProgname);
    if oRegIns<>nil then begin
      oRegIns.WriteString(aProgname, 'DisplayName', aProgname);
      oRegIns.WriteString(aProgname, 'DisplayVersion', aVersion);
      oRegIns.WriteString(aProgname, 'DisplayIcon', aUninstaller);
      oRegIns.WriteString(aProgname, 'UninstallString', sUninsCmd);
      oRegIns.Free;
      RESULT := 0;
      oCmdList.Savetofile(sUninsCmd);
    end else RESULT := 3;
    oReg.Free;
    oCmdList.Free;
  except
    RESULT := 1;
  end;
end;
{$ENDIF}

{***********************************
* Delete uninstall entry (only WIN32)
*
* @param aProgname: String (without spaces !)
* @return Integer
*    -1 initial (should never return)
*     0 ok
*     1 Error or Exception
*     3 Problem during conect to registry
***********************************}
{$IFDEF Win32}
Function DelUninstall(aProgname: String): Integer;
var
  oReg, oRegIns : tcRegistry;
  sKey: String;
Begin
  RESULT := -1;
  try
    oReg := tcRegistry.Create(taeKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\UnInstall\'+aProgname);
    sKey := oReg.ReadString('', 'DisplayName', '');
    oReg.Free;
    if sKey <> '' then begin
      oRegIns := tcRegistry.Create(taeKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\UnInstall\');
      oRegIns.EraseSection(aProgname);
      oRegIns.Free;
      RESULT := 0;
    end else RESULT := 3;
  except
    RESULT := 1;
  end;
end;
{$ENDIF}

Initialization
End.

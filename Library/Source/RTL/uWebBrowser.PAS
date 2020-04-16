
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl  Unit uWebBrowser                                             บ
 บ                                                                          บ
 บ    erstellt: 14. Apr 2020   Rolf Gachnang                                บ
 บ                                                                          บ
 บ                                                                          บ
 บ    ausgelagerte Funktionen, damit die frhere gegenseitige Abhngigkeit  บ
 บ    der Units uSysClass und uSysInfo aufgehoben wird. Zudem wurde der     บ
 บ    Code von getProgramFromUrl mehrmals identisch verwendet (unit DOS)    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{
offen W32: getDefaultBrowser: bisher wird wohl immer nur der alte Explorer gefunden
}

Unit uWebBrowser;

Interface


function getDefaultBrowser : tFileName;
function getDefaultFtp: tFileName;
function getProgramFromUrl(Const url : String; Var urlProgram : String) : Boolean;


Implementation

uses SysUtils,
     StrUtils, {PosEx}

     {$IFDEF OS2}
       PMShl; {PrfQueryProfileString}
     {$ENDIF}
     {$IFDEF WIN32 }
       WinBase;
     {$ENDIF}

{--------------------------------------------------------------------}
  function getDefaultFtp: tFileName;
{--------------------------------------------------------------------}
{ offen: W32-Teil                                                    }
{$IFDEF OS2}
var OutBuf : cstring;
{$ENDIF}

begin
{$IFDEF OS2}
  Fillchar(OutBuf,255,0);
  PrfQueryProfileString(HINI_USERPROFILE,'WPURLDEFAULTSETTINGS','DefaultFTPExe','',OutBuf,255); {PMShl}
  Result := OutBuf;
{$ENDIF}
{$IFDEF Win32}
  Result := ''; {offen}
{$ENDIF}
end;

{--------------------------------------------------------------------}
  function ExtractFileNameFromShellString(Value: String):String;
{--------------------------------------------------------------------}
{ Beispiel: ExtractFileNameFromShellString(                                 }
{ '"C:\Program Files (x86)\Mozilla Firefox\firefox.exe" -osint -url "%1"'); }
begin
  Result := Value;
  if not FileExists(Result)
  then begin
         Result := Copy(Result,
                        pos('"', Result) + 1,
                        posEx('"', Result, pos('"', Result) + 1) - 2);

         if not FileExists(Result)
         then Result := '';
       end;
end;


(*  Beispiel
{--------------------------------------------------------------------}
  function GetDefaultBrowserFileName:String;
{--------------------------------------------------------------------}
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey('\http\shell\open\command', False);
    Result := Reg.ReadString('');
    Result := ExtractFileNameFromShellString(Result);
  finally
    Reg.Free;
  end;
end;
*)

{--------------------------------------------------------------------}
  function getDefaultBrowser : tFileName;
{--------------------------------------------------------------------}
{ Gibt Browser-Filename inkl. Pfad zurck                            }
{ 14-Apr-20 so umgeschrieben damit Unit uSysInfo nicht notwendig     }
{$IFDEF OS2}
var OutBuf : cstring;
{$ENDIF}
{$IFDEF Win32}
var cStr : cString;
    Len  : Byte;
    OSPath : String;
{$ENDIF}

begin
{$IFDEF OS2}
  Fillchar(OutBuf,255,0);
  PrfQueryProfileString(HINI_USERPROFILE,'WPURLDEFAULTSETTINGS','DefaultBrowserExe','',OutBuf,255); {PMShl}
  Result := OutBuf;
{$ENDIF}
{$IFDEF Win32} {offen}
  Len := GetWindowsDirectory(cStr,255);  {WinBase}
  OSPath := cStr;                        { Muss wegen Win2000 getrennt }
  OSPath := AddPathSeparator(OSPath);
  Result := OSPath+'EXPLORER.EXE';
{$ENDIF}
end;

{--------------------------------------------------------------------}
  function getProgramFromUrl(const url : String; var urlProgram : tFilename) : Boolean;
{--------------------------------------------------------------------}
{ 14-Apr-20 function von unit DOS hierher verschoben und ergnzt mit }
{           HTTPS und FTPS,                                          }
{           doppelt vorhandener Source tcExec.getProgramFromUrl in   }
{           unit uSysClass berenigt                                  }
var pdb   : Byte;
    UrlTyp: String;
    Path  : tFilename;

begin
  result := false;
  UrlProgram := '';
  if Length(url) = 0 then exit;

  pdb := pos(':',url);
  if pdb = 2 then begin
                    UrlProgram:=url;
                    //result:=false;
                    exit;
                  end;

  result := true;
  UrlTyp := UpperCase(Copy(url,1,pdb-1));

  if (UrlTyp = 'HTTP') or
     (UrlTyp = 'HTTPS')
  then urlProgram := getDefaultBrowser //alt: goSysInfo.SysAppInfo.DefaultBrowser
  else if (UrlTyp = 'FTP') or
          (UrlTyp = 'FTPS')
       then begin
              urlProgram := getDefaultFtp;
              if Length(urlProgram) = 0
              then urlProgram := getDefaultBrowser;
            end
       else begin
              urlProgram := url;
              exit;    // Damit der Pfad nicht gendert wird
            end;
  path := ExtractFilePath(urlProgram);
  path[0] := chr(ord(path[0])-1);
  chdir(path);
end;


Initialization


Finalization


End.


{ -- date -- -- from -- -- changes ----------------------------------------------
  14-Apr-20  RG         Erstellung der Unit
  14-Apr-20  RG         getProgramFromUrl von Unit DOS hierher verschoben.
                        Derselbe Code war mehrfach vorhanden (Unit uSysClass). 
                        Gegenseitige Abhngikeit uSysClass <> uSysInfo aufgel”st.
}



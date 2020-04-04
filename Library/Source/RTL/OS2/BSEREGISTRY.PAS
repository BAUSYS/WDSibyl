{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for OS/2                                      บ
 บ                                                                          บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit BseRegistry;

Interface

Uses uSysClass;

type PFILETIME=^FILETIME;
     FILETIME=RECORD
                dwLowDateTime:LONGWORD;
                dwHighDateTime:LONGWORD;
     END;

Const SYNCHRONIZE             = $100000;
      STANDARD_RIGHTS_READ    = $020000;
      STANDARD_RIGHTS_WRITE   = $020000;
      STANDARD_RIGHTS_EXECUTE = $020000;
      STANDARD_RIGHTS_REQUIRED= $0F0000;
      STANDARD_RIGHTS_ALL     = $1F0000;

      KEY_QUERY_VALUE         = $0001;    // Erlaubt, daแ Unterschlssel abgefragt werden.
      KEY_SET_VALUE           = $0002;    // Erlaubt, dass Unterschlssel geschrieben werden.
      KEY_CREATE_SUB_KEY      = $0004;    // Erlaubt Unterschlssel zu erzeugen.
      KEY_ENUMERATE_SUB_KEYS  = $0008;    // Erlaubt die Auflistung von Unterschlsseln
      KEY_NOTIFY              = $0010;    // Aktiviert die nderungsbenachrichtigung (unter Win95/98 nicht untersttzt)
      KEY_CREATE_LINK         = $0020;    // Erlaubt das erstllen symbolischer Links fr andere Unterschlssel.
      KEY_READ                = ((STANDARD_RIGHTS_READ Or KEY_QUERY_VALUE Or
                                  KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY) And (Not SYNCHRONIZE));
      KEY_EXECUTE             = (KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS);
      KEY_WRITE               = (KEY_CREATE_SUB_KEY or KEY_SET_VALUE);
      KEY_ALL_ACCESS          = (KEY_CREATE_LINK or KEY_READ or KEY_WRITE);

      DELETE                  = $00010000;
      READ_CONTROL            = $00020000;
      WRITE_DAC               = $00040000;
      WRITE_OWNER             = $00080000;

Const HKEY_CLASSES_ROOT    = $FFFFFFEC;
      HKEY_CURRENT_USER    = $FFFFFFEE;
      HKEY_LOCAL_MACHINE   = $FFFFFFEF;
      HKEY_USERS           = $FFFFFFED;

Const REG_NONE               = 0;  // Ein nicht definierter Typ.
      REG_SZ                 = 1;  // Ein nullterminierter String.
      REG_EXPAND_SZ          = 2;  // Ein nullterminierter String, der nicht aufgel”ste Verweise auf Umgebungsvariablen enthlt (z.B. %PATH%). Win9x erlaubt, daแ diese Strings gespeichert werden. Sie werden nicht automatisch expandiert.
      REG_BINARY             = 3;  // Binrdaten in beliebigem Format.
      REG_DWORD              = 4;  // Eine 32-Bit Zahl im ursprnglichen Format.
      REG_DWORD_LITTLE_ENDIAN= 4;  // Eine 32-Bit Zahl im Little-Endian-Format (wie REG_DWORD ). In diesem Format ist das obere Byte eines Wortes das h”herwertige Byte.
      REG_DWORD_BIG_ENDIAN   = 5;  // Eine 32-Bit Zahl im Big-Endian-Format (wie REG_DWORD ). In diesem Format ist das untere Byte eines Wortes das h”herwertige Byte.
      REG_LINK               = 6;  // Ein symbolischer Link zu einem anderen Unterschlssel.
      REG_MULTI_SZ           = 7;  // Eine Liste nullterminierter Strings, die durch ein weiteres Nullzeichen beendet wird.


Function RegOpenKeyEx(ihKey : LongWord; var iValueName : cString;
                         iOptions, iSamDesired: longWord; var iResult : LongWord) : Longword;
Function RegCloseKey(ihKey : LongWord) : LongWord;
Function RegCreateKeyEx(ihKey : LongWord; Var iSubKey : cString;
                 iReserved: LongWord; var iClass : cString;
                 iOptions : LongWord; isamDesired : LongWord;
                 iSecurityAttributes : Pointer;
                 var iResult :  LongWord; iDisposition : LongWord) : LongWord;
Function RegDeleteKey(ihkey : LongWord; var iSubKey : cString) : LongWord;
Function RegEnumKeyEx(ihKey, iIndex : LongWord;
                 var iName : CString; var iLenName : LongWord;
                 iReserved : LongWord;
                 var iClass : CString; var iLenClass : LongWord;
                 var iLastWriteTime : PFILETIME) : LongWord;
Function RegQueryInfoKey(ihKey: LongWord;
                 var iClass : CString; var iLenClass : LongWord;
                 var iReserved,
                     iSubKeys, iMaxSubKeyLen, iMaxClassLen,
                     iValues, iMaxValueNameLen, iMaxValueLen, iSecurityDescriptor : LongWord;
                 var iLastWriteTime : PFILETIME) : LongWord;
Function RegQueryValueEx(ihKey : LongWord; iValueName : cString;
                         iReserved : LongWord;
                         iType : LongWord;
                         var iDat  : cString;
                         var iLen  : LongWord) : LongWord;
Function RegSetValueEx(ihKey : LongWord; iValueName : cString;
                         iReserved : LongWord; iType : LongWord;
                         var iDat : cString; iLen : LongWord) : LongWord;
Function RegDeleteValue(ihKey : LongWord; iValueName : cString) : LongWord;

Implementation

Uses BseERR;

type tBSERegistryFunc = record
       RegOpenKeyEx   : Function(ihKey : LongWord; var iValueName : cString;
                           iOptions, iSamDesired: longWord; var iResult : LongWord) : Longword; APIENTRY;
       RegCloseKey    : Function(ihKey : LongWord) : LongWord; APIENTRY;
       RegCreateKeyEx : Function(ihKey : LongWord; Var iSubKey : cString;
                           iReserved: LongWord; var iClass : cString;
                           iOptions : LongWord; isamDesired : LongWord;
                           iSecurityAttributes : Pointer;
                           var iResult :  LongWord; iDisposition : LongWord) : LongWord; APIENTRY;
       RegDeleteKey   : Function(ihkey : LongWord; var iSubKey : cString) : LongWord; APIENTRY;
       RegEnumKeyEx   : Function(ihKey, iIndex : LongWord;
                           var iName : CString; var iLenName : LongWord;
                           iReserved : LongWord;
                           var iClass : CString; var iLenClass : LongWord;
                           var iLastWriteTime : PFILETIME) : LongWord; APIENTRY;
       RegQueryInfoKey: Function(ihKey: LongWord;
                           var iClass : CString; var iLenClass : LongWord;
                           var iReserved,
                           iSubKeys, iMaxSubKeyLen, iMaxClassLen,
                           iValues, iMaxValueNameLen, iMaxValueLen, iSecurityDescriptor : LongWord;
                           var iLastWriteTime : PFILETIME) : LongWord; APIENTRY;

       RegQueryValueEx: Function(ihKey : LongWord; iValueName : cString;
                           iReserved : LongWord;
                           iType : LongWord;
                           var iDat  : cString;
                           var iLen  : LongWord) : LongWord; APIENTRY;
       RegSetValueEx  : Function(ihKey : LongWord; iValueName : cString;
                           iReserved : LongWord; iType : LongWord;
                           var iDat : cString; iLen : LongWord) : LongWord; APIENTRY;
       RegDeleteValue : Function(ihKey : LongWord; iValueName : cString) : LongWord; APIENTRY;
  end;


  tcBSERegistry = Class(tcDLL)
    private
      fBSERegistryFunc : tBSERegistryFunc;
    Public
      Constructor Create; virtual;
      property Func : tBSERegistryFunc read fBSERegistryFunc;
  End;

var BSERegistry : tcBSERegistry;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: BSERegistry Functions                                       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function RegOpenKeyEx(ihKey : LongWord; var iValueName : cString;
                         iOptions, iSamDesired: longWord; var iResult : LongWord) : Longword;

Begin
  if @BSERegistry.Func.RegOpenKeyEx=nil
    then Result:=ERROR_INVALID_FUNCTION
    else Result:=BSERegistry.Func.RegOpenKeyEx(ihKey, iValueName, iOptions, iSamDesired, iResult);
End;

Function RegCloseKey(ihKey : LongWord) : LongWord;
Begin
  if @BSERegistry.Func.RegCloseKey=nil
    then Result:=ERROR_INVALID_FUNCTION
    else Result:=BSERegistry.Func.RegCloseKey(ihKey);
End;

Function RegCreateKeyEx(ihKey : LongWord; Var iSubKey : cString;
                 iReserved: LongWord; var iClass : cString;
                 iOptions : LongWord; isamDesired : LongWord;
                 iSecurityAttributes : Pointer;
                 var iResult :  LongWord; iDisposition : LongWord) : LongWord;

Begin
  if @BSERegistry.Func.RegCreateKeyEx=nil
    then Result:=ERROR_INVALID_FUNCTION
    else Result:=BSERegistry.Func.RegCreateKeyEx(ihKey, iSubKey, iReserved, iClass,
                     iOptions, isamDesired, iSecurityAttributes, iResult, iDisposition);
End;

Function RegDeleteKey(ihkey : LongWord; var iSubKey : cString) : LongWord;

Begin
  if @BSERegistry.Func.RegDeleteKey=nil
    then Result:=ERROR_INVALID_FUNCTION
    else Result:=BSERegistry.Func.RegDeleteKey(ihkey, iSubKey);
End;

Function RegEnumKeyEx(ihKey, iIndex : LongWord;
                 var iName : CString; var iLenName : LongWord;
                 iReserved : LongWord;
                 var iClass : CString; var iLenClass : LongWord;
                 var iLastWriteTime : PFILETIME) : LongWord;

Begin
  if @BSERegistry.Func.RegEnumKeyEx=nil
    then Result:=ERROR_INVALID_FUNCTION
    else Result:=BSERegistry.Func.RegEnumKeyEx(ihKey, iIndex, iName, iLenName, iReserved,
                    iClass, iLenClass, iLastWriteTime);
End;

Function RegQueryInfoKey(ihKey: LongWord;
                 var iClass : CString; var iLenClass : LongWord;
                 var iReserved,
                     iSubKeys, iMaxSubKeyLen, iMaxClassLen,
                     iValues, iMaxValueNameLen, iMaxValueLen, iSecurityDescriptor : LongWord;
                 var iLastWriteTime : PFILETIME) : LongWord;

Begin
  if @BSERegistry.Func.RegQueryInfoKey=nil
    then Result:=ERROR_INVALID_FUNCTION
    else Result:=BSERegistry.Func.RegQueryInfoKey(ihKey, iClass, iLenClass,
                     iReserved, iSubKeys, iMaxSubKeyLen, iMaxClassLen,
                     iValues, iMaxValueNameLen, iMaxValueLen, iSecurityDescriptor,
                     iLastWriteTime);
End;

Function RegQueryValueEx(ihKey : LongWord; iValueName : cString;
                         iReserved : LongWord;
                         iType : LongWord;
                         var iDat  : cString;
                         var iLen  : LongWord) : LongWord;

Begin
  if @BSERegistry.Func.RegQueryValueEx=nil
    then Result:=ERROR_INVALID_FUNCTION
    else Result:=BSERegistry.Func.RegQueryValueEx(ihKey, iValueName, iReserved,
                         iType, iDat, iLen);
End;

Function RegSetValueEx(ihKey : LongWord; iValueName : cString;
                         iReserved : LongWord; iType : LongWord;
                         var iDat : cString; iLen : LongWord) : LongWord;

Begin
  if @BSERegistry.Func.RegSetValueEx=nil
    then Result:=ERROR_INVALID_FUNCTION
    else Result:=BSERegistry.Func.RegSetValueEx(ihKey, iValueName, iReserved, iType, iDat, iLen);
End;

Function RegDeleteValue(ihKey : LongWord; iValueName : cString) : LongWord;

Begin
  if @BSERegistry.Func.RegDeleteValue=nil
    then Result:=ERROR_INVALID_FUNCTION
    else Result:=BSERegistry.Func.RegDeleteValue(ihKey, iValueName);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ This section: tcBSERegistry Class Implementation                          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor tcBSERegistry.Create;

Begin
  try
    inherited Create('REGISTRY.DLL');
    Upper:=false;
  except
  end;
  if DLLLoaded then
    Begin
      fBSERegistryFunc.RegOpenKeyEx   :=pointer(GetProcAddress('RegOpenKeyExA'));
      fBSERegistryFunc.RegCloseKey    :=pointer(GetProcAddress('RegCloseKey'));
      fBSERegistryFunc.RegCreateKeyEx :=pointer(GetProcAddress('RegCreateKeyExA'));
      fBSERegistryFunc.RegDeleteKey   :=pointer(GetProcAddress('RegDeleteKeyA'));
      fBSERegistryFunc.RegEnumKeyEx   :=pointer(GetProcAddress('RegEnumKeyExA'));
      fBSERegistryFunc.RegQueryInfoKey:=pointer(GetProcAddress('RegQueryInfoKeyA'));
      fBSERegistryFunc.RegQueryValueEx:=pointer(GetProcAddress('RegQueryValueExA'));
      fBSERegistryFunc.RegSetValueEx  :=pointer(GetProcAddress('RegSetValueExA'));
      fBSERegistryFunc.RegDeleteValue :=pointer(GetProcAddress('RegDeleteValueA'));
    End;
End;


Initialization
  BSERegistry.Create;

Finalization
  if BSERegistry<>nil then
    BSERegistry.Destroy;

End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  16-Apr-06  WD         Schreibe- und Loeschfunktionen eingebaut
  14-Mar-07  WD         Die Unit in eine Klasse konvertiert.
}


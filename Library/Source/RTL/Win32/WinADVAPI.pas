Unit WinADVAPI;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for Win32                                       บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Interface

Uses WinBase;

Const SYNCHRONIZE             = $100000;
      STANDARD_RIGHTS_READ    = $020000;
      STANDARD_RIGHTS_WRITE   = $020000;
      STANDARD_RIGHTS_EXECUTE = $020000;
      STANDARD_RIGHTS_REQUIRED= $0F0000;
      STANDARD_RIGHTS_ALL     = $1F0000;

      KEY_QUERY_VALUE         = $0001;
      KEY_SET_VALUE           = $0002;
      KEY_CREATE_SUB_KEY      = $0004;
      KEY_ENUMERATE_SUB_KEYS  = $0008;
      KEY_NOTIFY              = $0010;
      KEY_CREATE_LINK         = $0020;
      KEY_READ                = ((STANDARD_RIGHTS_READ Or KEY_QUERY_VALUE Or
                                  KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY) And (Not SYNCHRONIZE));
      KEY_EXECUTE             = (KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS);
      KEY_WRITE               = (KEY_CREATE_SUB_KEY or KEY_SET_VALUE);
      KEY_ALL_ACCESS          = (KEY_CREATE_LINK or KEY_READ or KEY_WRITE);

      DELETE                  = $00010000;
      READ_CONTROL            = $00020000;
      WRITE_DAC               = $00040000;
      WRITE_OWNER             = $00080000;

Const HKEY_CLASSES_ROOT   = $80000000;
      HKEY_CURRENT_USER   = $80000001;
      HKEY_LOCAL_MACHINE  = $80000002;
      HKEY_USERS          = $80000003;

Const REG_NONE               = 0;  // Ein nicht definierter Typ.
      REG_SZ                 = 1;  // Ein nullterminierter String.
      REG_EXPAND_SZ          = 2;  // Ein nullterminierter String, der nicht aufgel”ste Verweise auf Umgebungsvariablen enthlt (z.B. %PATH%). Win9x erlaubt, daแ diese Strings gespeichert werden. Sie werden nicht automatisch expandiert.
      REG_BINARY             = 3;  // Binrdaten in beliebigem Format.
      REG_DWORD              = 4;  // Eine 32-Bit Zahl im ursprnglichen Format.
      REG_DWORD_LITTLE_ENDIAN= 4;  // Eine 32-Bit Zahl im Little-Endian-Format (wie REG_DWORD ). In diesem Format ist das obere Byte eines Wortes das h”herwertige Byte.
      REG_DWORD_BIG_ENDIAN   = 5;  // Eine 32-Bit Zahl im Big-Endian-Format (wie REG_DWORD ). In diesem Format ist das untere Byte eines Wortes das h”herwertige Byte.
      REG_LINK               = 6;  // Ein symbolischer Link zu einem anderen Unterschlssel.
      REG_MULTI_SZ           = 7;  // Eine Liste nullterminierter Strings, die durch ein weiteres Nullzeichen beendet wird.

Imports           
   Function RegOpenKeyEx(ihKey : LongWord; var iValueName : cString;
                         iOptions, iSamDesired : LongWord;
                         var iResult : LongWord) : Longword;
                      APIENTRY; 'ADVAPI32' name 'RegOpenKeyExA';

   Function RegCloseKey(ihKey : LongWord) : LongWord;
                      APIENTRY; 'ADVAPI32' name 'RegCloseKey';

   Function RegCreateKeyEx(ihKey : LongWord; Var iSubKey : cString;
                 iReserved: LongWord; var iClass : cString;
                 iOptions : LongWord; isamDesired : LongWord;
                 iSecurityAttributes : Pointer;
                 var iResult :  LongWord; iDisposition : LongWord) : LongWord;
                      APIENTRY; 'ADVAPI32' name 'RegCreateKeyExA';

   Function RegDeleteKey(ihkey : LongWord; var iSubKey : cString) : LongWord;
                      APIENTRY; 'ADVAPI32' name 'RegDeleteKeyA';

   Function RegEnumKeyEx(ihKey, iIndex : LongWord;
                 var iName : CString; var iLenName : LongWord;
                 iReserved : LongWord;
                 var iClass : CString; var iLenClass : LongWord;
                 var iLastWriteTime : PFILETIME) : LongWord;
                      APIENTRY; 'ADVAPI32' name 'RegEnumKeyExA';

   Function RegQueryInfoKey(ihKey: LongWord;
                 var iClass : CString; var iLenClass : LongWord;
                 var iReserved,
                     iSubKeys, iMaxSubKeyLen, iMaxClassLen,
                     iValues, iMaxValueNameLen, iMaxValueLen, iSecurityDescriptor : LongWord;
                 var iLastWriteTime : PFILETIME) : LongWord;
                      APIENTRY; 'ADVAPI32' name 'RegQueryInfoKeyA';

   Function RegQueryValueEx(ihKey : LongWord; iValueName : cString;
                         iReserved : LongWord;
                         iType : LongWord;
                         var iDat  : cString;
                         var iLen  : LongWord) : LongWord;
                      APIENTRY; 'ADVAPI32' name 'RegQueryValueExA';

   Function RegSetValueEx(ihKey : LongWord; iValueName : cString;
                         iReserved : LongWord; iType : LongWord;
                         var iDat : cString; iLen : LongWord) : LongWord;
                      APIENTRY; 'ADVAPI32' name 'RegSetValueExA';

   Function RegDeleteValue(ihKey : LongWord; iValueName : cString) : LongWord;
                      APIENTRY; 'ADVAPI32' name 'RegDeleteValueA';

End;

Implementation

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  16-Apr-06  WD         Schreibe- und Loeschfunktionen eingebaut
}


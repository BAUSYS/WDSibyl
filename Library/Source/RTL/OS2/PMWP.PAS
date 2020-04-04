
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for OS/2                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT PmWP;

INTERFACE

USES Os2Def,PmWin;

{ WinCreateObject }
Const 
  CO_FAILIFEXISTS    = 0;
  CO_REPLACEIFEXISTS = 1;
  CO_UPDATEIFEXISTS  = 2;

{ WinOpenObject }
const
  OPEN_UNKNOWN    = -1;
  OPEN_DEFAULT    =  0;
  OPEN_CONTENTS   =  1;
  OPEN_SETTINGS   =  2;
  OPEN_HELP       =  3;
  OPEN_RUNNING    =  4;
  OPEN_PROMPTDLG  =  5;
  OPEN_TREE       =  101;
  OPEN_DETAILS    =  102;
  OPEN_PALETTE    =  121;
  CLOSED_ICON     =  122;


{ WinWaitForShell }  // Allow applications to wait for the Shell to be available
const
  WWFS_QUERY            = $80000000; // 0x80000000 / -2147483648
  WWFS_DESKTOPCREATED   = 1;
  WWFS_DESKTOPOPENED    = 2;
  WWFS_DESKTOPPOPULATED = 3;


IMPORTS

// The WinShutdownSystem function will close down the system. 
function WinShutdownSystem(ahab:HAB;ahmq:HMQ):BOOL;
                    APIENTRY;             'PMWP' index 149;


// The WinRegisterObjectClass function registers a workplace object class.
function WinRegisterObjectClass(pszClassName,pszModName:CSTRING):BOOL;
                    APIENTRY;             'PMWP' index 200;

// This function deregisters (removes) a workplace object class. 
function WinDeRegisterObjectClass(pszClassName:CSTRING):BOOL;
                    APIENTRY;             'PMWP' index 201;

// The WinEnumObjectClasses function will return a list of all workplace object classes 
// that have been registered. 
function WinEnumObjectClasses(VAR apObjClass:OBJCLASS;VAR pulSize:ULONG):BOOL;
                    APIENTRY;             'PMWP' index 205;

// The WinStoreWindowPos function will save the current size and position 
// of the window specified by hwnd. 
function WinStoreWindowPos(pszAppName,pszKeyName:CSTRING;ahwnd:HWND):BOOL;
                    APIENTRY;             'PMWP' index 207;

// The WinRestoreWindowPos function will restore the size and position of the window 
// specified by hwnd to the state it was in when WinStoreWindowPos was last called 
// with the same pAppName and pKeyName.
function WinRestoreWindowPos(pszAppName,pszKeyName:CSTRING;ahwnd:HWND):BOOL;
                    APIENTRY;             'PMWP' index 208;

// This function returns a pointer to an icon which is associated 
// with the file specified by pszFileName. 
function WinLoadFileIcon(pszFileName:CSTRING;fPrivate:BOOL):HPOINTER;
                    APIENTRY;             'PMWP' index 209;

// function WinLoadFileIconN(pszFileName:CSTRING;fPrivate:BOOL;ulIconIndex:ULONG):HPOINTER;
//                    APIENTRY;             'PMWP' index ???;

// WinSetFileIcon sets the icon for the file specified by pFileName 
// to the icon specified by picon. 
function WinSetFileIcon(pszFileName:CSTRING;VAR pIcon:ICONINFO):BOOL;
                    APIENTRY;             'PMWP' index 210;

// function WinSetFileIconN(pszFileName:CSTRING;VAR pIcon:ICONINFO;ulIconIndex:ULONG):BOOL;
//                     APIENTRY;             'PMWP' index ???;

// This function frees an icon pointer that was originally allocated by WinLoadFileIcon. 
function WinFreeFileIcon(hptr:HPOINTER):BOOL;
                    APIENTRY;             'PMWP' index 216;

// The WinReplaceObjectClass function replaces a registered class with another registered class.
// If fReplace is FALSE, pOldClassName will revert back to its original definition. 
function WinReplaceObjectClass(pszOldClassName,pszNewClassName:CSTRING;
                               fReplace:BOOL):BOOL;
                    APIENTRY;             'PMWP' index 219;

// This function causes the Workplace(TM) process to terminate and re-initialize.
// This function is applicable to OS/2 Warp 4, or higher, and WorkSpace On-Demand client operating systems.
function WinRestartWorkplace: BOOL;
                    APIENTRY;             'PMWP' index 221;
     

// The WinSetObjectData function is called to set data on a workplace object. 
function WinSetObjectData(aobject:HOBJECT;pszSetupString:CSTRING):BOOL;
                    APIENTRY;             'PMWP' index 250;

// This function is called to delete a workplace object. 
function WinDestroyObject(aobject:HOBJECT):BOOL;
                    APIENTRY;             'PMWP' index 251;

// The WinQueryObject function returns a handle to the given object. 
function WinQueryObject(pszObjectID:CSTRING):MRESULT;
                    APIENTRY;             'PMWP' index 252;

// This function returns the directory specification of the active desktop.
// This function is specific to OS/2 Version 3.0 or higher. 
function WinQueryActiveDesktopPathname(var pszPathName:CString; ulSize : LongWord) : BOOL;
                    APIENTRY;             'PMWP' index 262;

// This function returns the directory specification of a given object handle
// This function is specific to OS/2 Version 3.0 or higher.
function WinQueryObjectPath(aobject:HOBJECT;var pszPathName:CString; ulSize : ULONG) : BOOL;
                    APIENTRY;             'PMWP' index 263;


// This function creates an instance of object class pszClassName, with title pszTitle, 
// and places the icon and title in the location referred to by pszLocation. 
function WinCreateObject(pszClassName,pszTitle,pszSetupString,pszLocation:CSTRING;ulFlags:ULONG) : HOBJECT {ULONG};
                    APIENTRY;             'PMWP' index 281;

// This function causes an application program to attempt to unlock the system. 
// This function is specific to OS/2 Version 2.1 or higher.
function WinUnlockSystem(ab: HAB; pszPassword: CSTRING): BOOL;
                    APIENTRY;             'PMWP' index 282; 

// This function locks up the system. 
// This function is specific to OS/2 Version 2.1 or higher.
function WinLockUpSystem(ab: HAB): BOOL;
                    APIENTRY;             'PMWP' index 283; 

// This function saves the state of an object.
// This function is specific to OS/2 Version 3.0 or higher.  
function WinSaveObject(aObject: HOBJECT; fAsync: BOOL): BOOL;
                    APIENTRY;             'PMWP' index 285;

// This function eithers opens a view of the given object or surfaces an existing view
// This function is specific to OS/2 Version 3.0 or higher. 
function WinOpenObject(aObject: HOBJECT; ulView: ULONG; Flag: BOOL): BOOL;
                    APIENTRY;             'PMWP' index 286;

// This function moves an object from its existing location to a specified new destination. 
// This function is specific to OS/2 Version 3.0 or higher.
function WinMoveObject(aObjectofObject, aObjectofDest: HOBJECT; ulReserved: ULONG): HOBJECT;
                    APIENTRY;             'PMWP' index 287;

// This function copies an object from its existing location to a specified new destination. 
// This function is specific to OS/2 Version 3.0 or higher.
function WinCopyObject(aObjectofObject, aObjectofDest: HOBJECT; ulReserved: ULONG): HOBJECT;
                    APIENTRY;             'PMWP' index 288;

// This function creates a shadow of an object and places it in a specified location. 
// This function is specific to OS/2 Version 3.0 or higher. 
function WinCreateShadow(aObjectofObject, aObjectofDest: HOBJECT; ulReserved: ULONG): HOBJECT;
                    APIENTRY;             'PMWP' index 289;


// This function starts the Workplace Shell DSOM server.
function WinRestartWPDServer(fAction: BOOL): LONGWORD; {APIRET}
                    APIENTRY;             'PMWP' index 463;

// This function starts the DSOM daemon.
function WinRestartSOMDD(fAction: BOOL): LONGWORD; {APIRET}
                    APIENTRY;             'PMWP' index 464;

// This function returns the state of the Workplace Shell DSOM server.
function WinIsWPDServerReady: BOOL;
                    APIENTRY;             'PMWP' index 465;

// This function returns the state of the DSOM daemon (SOMDD), 
// started by the Workplace Shell process using WinRestartSOMDD. 
function WinIsSOMDDReady: BOOL;
                    APIENTRY;             'PMWP' index 480;

// This function exports a convience function to find BS_NOTEBOOKBUTTON buttons.  
// This function is specific to Version 4, or higher, of the OS/2 operating system. 
function WinNotebookButtonFromID(hwndDlg: HWND; id: ULONG): HWND; 
                    APIENTRY;             'PMWP' index 511; 

// This function allows applications to wait for the Shell to be available.
// This function is specific to Version 4, or higher, of the OS/2 operating system. 
function WinWaitForShell(ulEvent: ULONG): BOOL;
                    APIENTRY;             'PMWP' index 512; 


END;

IMPLEMENTATION

BEGIN
END.

//
// noch nicht implementiert :
//
//WinShutdownAndReboot    PMWP    index 152
//WinShutdown             PMWP    index 153
//MriLoadResource         PMWP    index 203
//ShlCreateContextMenu    PMWP    index 204
//ShlQueryFolderFromPath  PMWP    index 206

{ -- date -- -- from -- -- changes ----------------------------------------------
  12-Jun-05  WD         Diverse Funktionen eingebaut.
  20-Mai-06  WD         Funcktion WinQueryObjectPath eingebaut
  06-Nov_06  RG         Funktionen WinRestartWPDServer, WinIsWPDServerReady, WinRestartSOMDD,
                        WinIsSOMDDReady, WinNotebookButtonFromID, WinWaitForShell eingebaut.
  06-Nov-06  RG         zustzliche Konstanten: OPEN_TREE,OPEN_DETAILS,CLOSED_ICON
                        zustzliche Konstanten betreffend WinWaitForShell
  04-Dez-08  WD         Funktion WinRestartWorkplace aktiviert.
}

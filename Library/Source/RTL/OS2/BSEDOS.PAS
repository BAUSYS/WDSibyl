
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for OS/2                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT BseDos;

{****************************************************************************
 *                                                                          *
 * OS/2 Base include file.                                                  *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES system,Os2Def,BseTib,BseExcpt;

{ Access protection }
CONST
     PAG_READ          =$00000001;      { read access                      }
     PAG_WRITE         =$00000002;      { write access                     }
     PAG_EXECUTE       =$00000004;      { execute access                   }
     PAG_GUARD         =$00000008;      { guard protection                 }
     PAG_DEFAULT       =$00000400;      { default (initial) access         }

{ Commit}
     PAG_COMMIT        =$00000010;      { commit storage                   }
     PAG_DECOMMIT      =$00000020;      { decommit storage                 }

{ Allocation attributes }
     OBJ_TILE          =$00000040;      { tile object                      }
     OBJ_PROTECTED     =$00000080;      { protect object
                                          NOTE: This flag is NOT available at
                                          the api level }
     OBJ_GETTABLE      =$00000100;      { gettable by other processes      }
     OBJ_GIVEABLE      =$00000200;      { giveable to other processes      }
     OBJ_ANY           =$00000400;      { allocate memory anywhere         }

     fPERM             =PAG_EXECUTE OR PAG_READ OR PAG_WRITE;
     fSHARE            =OBJ_GETTABLE OR OBJ_GIVEABLE;

{ DosAllocMem flags }
     fALLOC            =OBJ_TILE OR PAG_COMMIT OR fPERM;


{ DosAllocSharedMem flags }
     fALLOCSHR         =OBJ_TILE OR PAG_COMMIT OR fSHARE OR fPERM;

{ DosGetNamedSharedMem flags }
     fGETNMSHR         =fPERM;

{ DosGetSharedMem flags }
     fGETSHR           =fPERM;

{ DosGiveSharedMem flags }
     fGIVESHR          =fPERM;

{ DosSetMem flags }
     fSET              =PAG_COMMIT + PAG_DECOMMIT + PAG_DEFAULT + fPERM;

{ Dos32SubSet flags }
     DOSSUB_INIT       =$01;      { initialize memory object for
                                    suballocation                    }
     DOSSUB_GROW       =$02;      { increase size of memory pool
                                    for suballocation                }
     DOSSUB_SPARSE_OBJ =$04;      { indicator for DosSub to
                                    manage the commitment of
                                    pages spanned by the memory pool }
     DOSSUB_SERIALIZE  =$08;      { indicates that access to the
                                    memory pool is to be
                                    serialized by DosSub             }


{ Allocation type (returned from DosQueryMem) }
     PAG_SHARED        =$00002000; { shared object                    }
     PAG_FREE          =$00004000; { pages are free                   }
     PAG_BASE          =$00010000; { first page in object             }


{ DosExit codes }
CONST
      EXIT_THREAD        =0;
      EXIT_PROCESS       =1;

TYPE
    PFNTHREAD=POINTER;

{ Action code values }
CONST
      DCWA_PROCESS       =0;
      DCWA_PROCESSTREE   =1;

   { Wait option values }

      DCWW_WAIT          =0;
      DCWW_NOWAIT        =1;

{ Thread Flags for DosCreateThread options 59468 }

   CREATE_READY          =0;                   { defect 65437  }
   CREATE_SUSPENDED      =1;
   STACK_SPARSE          =0;
   STACK_COMMITTED       =2;

TYPE
    PRESULTCODES=^RESULTCODES;
    RESULTCODES=RECORD
                     codeTerminate:ULONG;
                     codeResult:ULONG;
                END;


{ User's Debug Buffer structure }

TYPE
    PDbgBuf=^TDbgBuf;
    TDbgBuf=RECORD
                 Pid:PID;                 { Debuggee Process id          }
                 Tid:TID;                 { Debuggee Thread id           }
                 Cmd:LONGINT;             { Command or Notification      }
                 Value:LONGINT;           { Generic Data Value           }
                 Addr:LONGWORD;           { Debuggee Address             }
                 Buffer:LONGWORD;         { Debugger Buffer Address      }
                 Len:LONGWORD;            { Length of Range              }
                 index:LONGWORD;          { Generic Identifier Index     }
                 MTE:LONGWORD;            { Module Table Entry Handle    }
                 EAX:LONGWORD;            { Register Set                 }
                 ECX:LONGWORD;
                 EDX:LONGWORD;
                 EBX:LONGWORD;
                 ESP:LONGWORD;
                 EBP:LONGWORD;
                 ESI:LONGWORD;
                 EDI:LONGWORD;
                 EFlags:LONGWORD;
                 EIP:LONGWORD;
                 CSLim:LONGWORD;
                 CSBase:LONGWORD;
                 CSAcc:BYTE;
                 CSAtr:BYTE;
                 CS:WORD;
                 DSLim:LONGWORD;
                 DSBase:LONGWORD;
                 DSAcc:BYTE;
                 DSAtr:BYTE;
                 DS:WORD;
                 ESLim:LONGWORD;
                 ESBase:LONGWORD;
                 ESAcc:BYTE;
                 ESAtr:BYTE;
                 ES:WORD;
                 FSLim:LONGWORD;
                 FSBase:LONGWORD;
                 FSAcc:BYTE;
                 FSAtr:BYTE;
                 FS:WORD;
                 GSLim:LONGWORD;
                 GSBase:LONGWORD;
                 GSAcc:BYTE;
                 GSAtr:BYTE;
                 GS:WORD;
                 SSLim:LONGWORD;
                 SSBase:LONGWORD;
                 SSAcc:BYTE;
                 SSAtr:BYTE;
                 SS:WORD;
         END;

{ DosDebug Command Numbers
 *
 *      These numbers are placed in the Cmd field of the uDB on
 *      entry to DosDebug.
 *
 *      These numbers identify which command DosDebug is requested
 *      to perform.
 *
 }

CONST
   DBG_C_Null              =0;       { Null                         }
   DBG_C_ReadMem           =1;       { Read Word                    }
   DBG_C_ReadMem_I         =1;       { Read Word                    }
   DBG_C_ReadMem_D         =2;       { Read Word (same as 1)        }
   DBG_C_ReadReg           =3;       { Read Register Set            }
   DBG_C_WriteMem          =4;       { Write Word                   }
   DBG_C_WriteMem_I        =4;       { Write Word                   }
   DBG_C_WriteMem_D        =5;       { Write Word (same as 4)       }
   DBG_C_WriteReg          =6;       { Write Register Set           }
   DBG_C_Go                =7;       { Go                           }
   DBG_C_Term              =8;       { Terminate                    }
   DBG_C_SStep             =9;       { Single Step                  }
   DBG_C_Stop              =10;      { Stop                         }
   DBG_C_Freeze            =11;      { Freeze Thread                }
   DBG_C_Resume            =12;      { Resume Thread                }
   DBG_C_NumToAddr         =13;      { Object Number to Address     }
   DBG_C_ReadCoRegs        =14;      { Read Coprocessor Registers   }
   DBG_C_WriteCoRegs       =15;      { Write Coprocessor Registers  }
                                        { 16 is reserved               }
   DBG_C_ThrdStat          =17;      { Get Thread Status            }
   DBG_C_MapROAlias        =18;      { Map read-only alias          }
   DBG_C_MapRWAlias        =19;      { Map read-write alias         }
   DBG_C_UnMapAlias        =20;      { Unmap Alias                  }
   DBG_C_Connect           =21;      { Connect to Debuggee          }
   DBG_C_ReadMemBuf        =22;      { Read Memory Buffer           }
   DBG_C_WriteMemBuf       =23;      { Write Memory Buffer          }
   DBG_C_SetWatch          =24;      { Set Watchpoint               }
   DBG_C_ClearWatch        =25;      { Clear Watchpoint             }
   DBG_C_RangeStep         =26;      { Range Step                   }
   DBG_C_Continue          =27;      { Continue after an Exception  }
   DBG_C_AddrToObject      =28;      { Address to Object            }
   DBG_C_XchgOpcode        =29;      { Exchange opcode and go       }
   DBG_C_LinToSel          =30;      { 32 to 16 conversion      A001}
   DBG_C_SelToLin          =31;      { 16 to 32 conversion      A001}

   {------ Constants -------------------}
   DBG_L_386               =1;
   DBG_O_OBJMTE            =$10000000;

   {------ Notifications ---------------}
   DBG_N_SUCCESS             = 0;
   DBG_N_ERROR               =-1;
   DBG_N_ProcTerm            =-6;
   DBG_N_Exception           =-7;
   DBG_N_ModuleLoad          =-8;
   DBG_N_CoError             =-9;
   DBG_N_ThreadTerm          =-10;
   DBG_N_AsyncStop           =-11;
   DBG_N_NewProc             =-12;
   DBG_N_AliasFree           =-13;
   DBG_N_Watchpoint          =-14;
   DBG_N_ThreadCreate        =-15;
   DBG_N_ModuleFree          =-16;
   DBG_N_RangeStep           =-17;

   DBG_X_PRE_FIRST_CHANCE    = 0;
   DBG_X_FIRST_CHANCE        = 1;
   DBG_X_LAST_CHANCE         = 2;
   DBG_X_STACK_INVALID       = 3;

   DBG_W_Local               =$0000001;
   DBG_W_Global              =$0000002;
   DBG_W_Execute             =$00010000;
   DBG_W_Write               =$00020000;
   DBG_W_ReadWrite           =$00030000;

{ codeTerminate values (also passed to ExitList routines) }

CONST
      TC_EXIT            =0;
      TC_HARDERROR       =1;
      TC_TRAP            =2;
      TC_KILLPROCESS     =3;
      TC_EXCEPTION       =4;

TYPE
    PFNEXITLIST=POINTER;


{ DosExitList functions }

CONST
    EXLST_ADD          =1;
    EXLST_REMOVE       =2;
    EXLST_EXIT         =3;


{ DosExecPgm functions }
CONST
      EXEC_SYNC          =0;
      EXEC_ASYNC         =1;
      EXEC_ASYNCRESULT   =2;
      EXEC_TRACE         =3;
      EXEC_BACKGROUND    =4;
      EXEC_LOAD          =5;
      EXEC_ASYNCRESULTDB =6;



{ Priority scopes }
CONST
      PRTYS_PROCESS      =0;
      PRTYS_PROCESSTREE  =1;
      PRTYS_THREAD       =2;

{ Priority classes }
CONST
      PRTYC_NOCHANGE         =0;
      PRTYC_IDLETIME         =1;
      PRTYC_REGULAR          =2;
      PRTYC_TIMECRITICAL     =3;
      PRTYC_FOREGROUNDSERVER =4;

   { Priority deltas }

      PRTYD_MINIMUM     =-31;
      PRTYD_MAXIMUM     = 31;



CONST
      DKP_PROCESSTREE    =0;
      DKP_PROCESS        =1;

   {************************************************************************
   * CCHMAXPATH is the maximum fully qualified path name length including  *
   * the drive letter, colon, backslashes and terminating NULL.            *
   *************************************************************************}
      CCHMAXPATH         =260;

   {************************************************************************
   * CCHMAXPATHCOMP is the maximum individual path component name length   *
   * including a terminating NULL.                                         *
   *************************************************************************}
      CCHMAXPATHCOMP     =256;

{ DosSetFilePtr() file position codes }
CONST
      FILE_BEGIN      =$0000;   { Move relative to beginning of file }
      FILE_CURRENT    =$0001;   { Move relative to current fptr position }
      FILE_END        =$0002;   { Move relative to end of file }

   { DosFindFirst/Next Directory handle types }
      HDIR_SYSTEM      =  1;    { Use system handle (1) }
      HDIR_CREATE      = -1;    { Allocate a new, unused handle }

   { DosCopy control bits; may be or'ed together }
      DCPY_EXISTING   =$0001;   { Copy even if target exists }
      DCPY_APPEND     =$0002;   { Append to existing file, do not replace }
      DCPY_FAILEAS    =$0004;   { Fail if EAs not supported on target}

   { DosOpen/DosQFHandState/DosQueryFileInfo et al file attributes; also }
   { known as Dos File Mode bits... }
      FILE_NORMAL     =$0000;
      FILE_READONLY   =$0001;
      FILE_HIDDEN     =$0002;
      FILE_SYSTEM     =$0004;
      FILE_DIRECTORY  =$0010;
      FILE_ARCHIVED   =$0020;

      FILE_IGNORE     =$10000;     { ignore file attribute in }
   { DosSetPath/File Info if }
   { this bit is set}

      MUST_HAVE_READONLY     =(FILE_READONLY  SHL 8) OR FILE_READONLY;
      MUST_HAVE_HIDDEN       =(FILE_HIDDEN SHL 8) OR FILE_HIDDEN;
      MUST_HAVE_SYSTEM       =(FILE_SYSTEM SHL 8) OR FILE_SYSTEM;
      MUST_HAVE_DIRECTORY    =(FILE_DIRECTORY SHL 8) OR FILE_DIRECTORY;
      MUST_HAVE_ARCHIVED     =(FILE_ARCHIVED SHL 8) OR FILE_ARCHIVED;

   { DosOpen() actions }
      FILE_EXISTED    =$0001;
      FILE_CREATED    =$0002;
      FILE_TRUNCATED  =$0003;

   { DosOpen() open flags }
      FILE_OPEN       =$0001;
      FILE_TRUNCATE   =$0002;
      FILE_CREATE     =$0010;

   {     this nibble applies if file already exists                xxxx }
      OPEN_ACTION_FAIL_IF_EXISTS     =$0000;  { ---- ---- ---- 0000 }
      OPEN_ACTION_OPEN_IF_EXISTS     =$0001;  { ---- ---- ---- 0001 }
      OPEN_ACTION_REPLACE_IF_EXISTS  =$0002;  { ---- ---- ---- 0010 }

   {     this nibble applies if file does not exist           xxxx      }
      OPEN_ACTION_FAIL_IF_NEW        =$0000;  { ---- ---- 0000 ---- }
      OPEN_ACTION_CREATE_IF_NEW      =$0010;  { ---- ---- 0001 ---- }

   { DosOpen/DosSetFHandState flags }
      OPEN_ACCESS_READONLY           =$0000;  { ---- ---- ---- -000 }
      OPEN_ACCESS_WRITEONLY          =$0001;  { ---- ---- ---- -001 }
      OPEN_ACCESS_READWRITE          =$0002;  { ---- ---- ---- -010 }
      OPEN_SHARE_DENYREADWRITE       =$0010;  { ---- ---- -001 ---- }
      OPEN_SHARE_DENYWRITE           =$0020;  { ---- ---- -010 ---- }
      OPEN_SHARE_DENYREAD            =$0030;  { ---- ---- -011 ---- }
      OPEN_SHARE_DENYNONE            =$0040;  { ---- ---- -100 ---- }
      OPEN_FLAGS_NOINHERIT           =$0080;  { ---- ---- 1--- ---- }
      OPEN_FLAGS_NO_LOCALITY         =$0000;  { ---- -000 ---- ---- }
      OPEN_FLAGS_SEQUENTIAL          =$0100;  { ---- -001 ---- ---- }
      OPEN_FLAGS_RANDOM              =$0200;  { ---- -010 ---- ---- }
      OPEN_FLAGS_RANDOMSEQUENTIAL    =$0300;  { ---- -011 ---- ---- }
      OPEN_FLAGS_NO_CACHE            =$1000;  { ---1 ---- ---- ---- }
      OPEN_FLAGS_FAIL_ON_ERROR       =$2000;  { --1- ---- ---- ---- }
      OPEN_FLAGS_WRITE_THROUGH       =$4000;  { -1-- ---- ---- ---- }
      OPEN_FLAGS_DASD                =$8000;  { 1--- ---- ---- ---- }
      OPEN_FLAGS_NONSPOOLED          =$00040000;
      OPEN_FLAGS_PROTECTED_HANDLE =$40000000;


   { DosSearchPath() constants }
      SEARCH_PATH           =$0000;
      SEARCH_CUR_DIRECTORY  =$0001;
      SEARCH_ENVIRONMENT    =$0002;
      SEARCH_IGNORENETERRS  =$0004;

   { DosSetExtLIBPATH and DosQueryExtLIBPATH }
      BEGIN_LIBPATH = 1;
      END_LIBPATH   = 2;
      LIBPATHSTRICT = 3;


   {***********************************************************
   EA Info Levels & Find First/Next
   =========================================
   API's: DosFindFirst, DosQueryFileInfo, DosQueryPathInfo, DosSetFileInfo,
   DosSetPathInfo
   ***********************************************************}

   { File info levels&gml All listed API's }
      FIL_STANDARD          =1;     { Info level 1, standard file info }
      FIL_QUERYEASIZE       =2;     { Level 2, return Full EA size }
      FIL_QUERYEASFROMLIST  =3;     { Level 3, return requested EA's }
{Martin lf}
      FIL_STANDARDL         =11;    { LFS - Info level 11, standard file info for large files }
      FIL_QUERYEASIZEL      =12;    { LFS - Level 12, return Full EA size for large files }
      FIL_QUERYEASFROMLISTL =13;    { LFS - Level 13, return requested EA's }



   { File info levels: Dos...PathInfo only }
      FIL_QUERYFULLNAME     =5;     { Level 5, return fully qualified
   name of file }


   { DosFsAttach() }
   { Attact or detach }
      FS_ATTACH             =0;     { Attach file server }
      FS_DETACH             =1;     { Detach file server }
      FS_SPOOLATTACH        =2;     { Register a spooler device }
      FS_SPOOLDETACH        =3;     { De-register a spooler device }


   { DosFsCtl() }
   { Routing type }
      FSCTL_HANDLE          =1;     { File Handle directs req routing }
      FSCTL_PATHNAME        =2;     { Path Name directs req routing }
      FSCTL_FSDNAME         =3;     { FSD Name directs req routing }

   { defined FSCTL functions }
      FSCTL_ERROR_INFO      =1;     { return error info from FSD }
      FSCTL_MAX_EASIZE      =2;     { Max ea size for the FSD }

TYPE
   PEASIZEBUF=^EASIZEBUF;
   EASIZEBUF=RECORD       { struct for FSCTL fn 2 - max ea size }
                cbMaxEASize:WORD;        { max. size of one EA }
                cbMaxEAListSize:ULONG;   { max size of the full EA List }
             END;

   { DosQueryFSAttach() }
   { Information level types (defines method of query) }
CONST
      FSAIL_QUERYNAME       =1;     { Return data for a Drive or Device }
      FSAIL_DEVNUMBER       =2;     { Return data for Ordinal Device # }
      FSAIL_DRVNUMBER       =3;     { Return data for Ordinal Drive # }

   { Item types (from data structure item "iType") }
      FSAT_CHARDEV          =1;     { Resident character device }
      FSAT_PSEUDODEV        =2;     { Pusedu-character device }
      FSAT_LOCALDRV         =3;     { Local drive }
      FSAT_REMOTEDRV        =4;     { Remote drive attached to FSD }

TYPE
   PFSQBUFFER=^FSQBUFFER;
   FSQBUFFER=RECORD       { fsqbuf Data structure for QFSAttach}
                iType:WORD;       { Item type }
                cbName:WORD;      { Length of item name, sans NULL }
                szName:BYTE;      { ASCIIZ item name }
                cbFSDName:WORD;   { Length of FSD name, sans NULL }
                szFSDName:BYTE;   { ASCIIZ FSD name }
                cbFSAData:USHORT; { Length of FSD Attach data returned }
                rgFSAData:BYTE;  { FSD Attach data from FSD }
             END;

   PFSQBUFFER2=^FSQBUFFER2;
   FSQBUFFER2=RECORD       { fsqbuf Data structure for QFSAttach}
                iType:USHORT;
                cbName:USHORT;
                cbFSDName:USHORT;
                cbFSAData:USHORT;
                szName:BYTE;
                szFSDName:BYTE;
                rgFSAData:BYTE;
             END;

   PSPOOLATTACH=^SPOOLATTACH;
   SPOOLATTACH=RECORD
                   hNmPipe:USHORT;            { Named pipe handle }
                   ulKey:ULONG;               { Attached key }
               END;


{****************************************************************************
 * File System Drive Information&gml DosQueryFSInfo DosSetFSInfo            *
 ****************************************************************************}

   { FS Drive Info Levels }
CONST
      FSIL_ALLOC            =1;     { Drive allocation info (Query only) }
      FSIL_VOLSER           =2;     { Drive Volum/Serial info }

   { DosQueryFHType() }
   { Handle classes (low 8 bits of Handle Type) }
      FHT_DISKFILE          =$0000;   { Disk file handle }
      FHT_CHRDEV            =$0001;   { Character device handle }
      FHT_PIPE              =$0002;   { Pipe handle }

   { Handle bits (high 8 bits of Handle Type) }
      FHB_DSKREMOTE         =$8000;   { Remote disk }
      FHB_CHRDEVREMOTE      =$8000;   { Remote character device }
      FHB_PIPEREMOTE        =$8000;   { Remote pipe }


TYPE
    PFTIME=^FTIME;
    FTIME=WORD;  {twosecs Bit 0..4, minutes bit 5..10, hours bit 11..15}

    PFDATE=^FDATE;
    FDATE=WORD;  {Day Bit 0..4, Month Bit 5..8, year bit 9..15}

    PVOLUMELABEL=^VOLUMELABEL;
    VOLUMELABEL=RECORD
                      cch:BYTE;
                      szVolLabel:CSTRING[11];
                END;

    PFSINFO=^FSINFO;
    FSINFO=RECORD
               fdateCreation:FDATE;
               ftimeCreation:FTIME;
               vol:VOLUMELABEL;
           END;

   { HANDTYPE values }
CONST
      HANDTYPE_FILE         =$0000;
      HANDTYPE_DEVICE       =$0001;
      HANDTYPE_PIPE         =$0002;
      HANDTYPE_PROTECTED    =$4000;
      HANDTYPE_NETWORK      =$8000;

TYPE
      PFILELOCK=^FILELOCK;
      FILELOCK=RECORD
                    lOffset:LONG;
                    lRange:LONG;
               END;

      HFILE=LHANDLE;
      HEV=ULONG;
      FHLOCK=ULONG;


TYPE
      PFILEFINDBUF=^FILEFINDBUF;
      FILEFINDBUF=RECORD
                     fdateCreation:FDATE;
                     ftimeCreation:FTIME;
                     fdateLastAccess:FDATE;
                     ftimeLastAccess:FTIME;
                     fdateLastWrite:FDATE;
                     ftimeLastWrite:FTIME;
                     cbFile:ULONG;
                     cbFileAlloc:ULONG;
                     attrFile:USHORT;
                     cchName:BYTE;
                     achName:CSTRING[CCHMAXPATHCOMP-1];
                END;

      PFILEFINDBUF2=^FILEFINDBUF2;
      FILEFINDBUF2=RECORD    {pack 2}
                        fdateCreation:FDATE;
                        ftimeCreation:FTIME;
                        fdateLastAccess:FDATE;
                        ftimeLastAccess:FTIME;
                        fdateLastWrite:FDATE;
                        ftimeLastWrite:FTIME;
                        cbFile:ULONG;
                        cbFileAlloc:ULONG;
                        attrFile:USHORT;
                        cbList:ULONG;
                        cchName:BYTE;
                        achName:CSTRING[CCHMAXPATHCOMP-1];
                   END;

      PFILEFINDBUF3=^FILEFINDBUF3;
      FILEFINDBUF3=RECORD  { pack 2 }
                        oNextEntryOffset:ULONG;            { new field }
                        fdateCreation:FDATE;
                        ftimeCreation:FTIME;
                        fdateLastAccess:FDATE;
                        ftimeLastAccess:FTIME;
                        fdateLastWrite:FDATE;
                        ftimeLastWrite:FTIME;
                        cbFile:ULONG;
                        cbFileAlloc:ULONG;
                        attrFile:ULONG;          { widened field }
                        cchName:BYTE;
                        achName:CSTRING[CCHMAXPATHCOMP-1];
                  END;

{Martin lf}
      PFILEFINDBUF3L=^FILEFINDBUF3L;
      FILEFINDBUF3L=RECORD  { pack 2 }
                        oNextEntryOffset:ULONG;            { new field }
                        fdateCreation:FDATE;
                        ftimeCreation:FTIME;
                        fdateLastAccess:FDATE;
                        ftimeLastAccess:FTIME;
                        fdateLastWrite:FDATE;
                        ftimeLastWrite:FTIME;
                        cbFile:LONGLONG;
                        cbFileAlloc:LONGLONG;
                        attrFile:ULONG;          { widened field }
                        cchName:BYTE;
                        achName:CSTRING[CCHMAXPATHCOMP-1];
                  END;

      PFILEFINDBUF4=^FILEFINDBUF4;
      FILEFINDBUF4=RECORD   { pack 2 }
                        oNextEntryOffset:ULONG;            { new field }
                        fdateCreation:FDATE;
                        ftimeCreation:FTIME;
                        fdateLastAccess:FDATE;
                        ftimeLastAccess:FTIME;
                        fdateLastWrite:FDATE;
                        ftimeLastWrite:FTIME;
                        cbFile:ULONG;
                        cbFileAlloc:ULONG;
                        attrFile:ULONG;       { widened field }
                        cbList:ULONG;
                        cchName:BYTE;
                        achName:CSTRING[CCHMAXPATHCOMP-1];
                  END;

      { extended attribute structures }

      PGEA=^GEA;
      GEA=RECORD  {pack 2}
                cbName:BYTE;        { name length not including NULL }
                szName:CHAR;        { attribute name }
          END;

      PGEALIST=^GEALIST;
      GEALIST=RECORD  { pack 2 }
                   cbList:ULONG;    { total bytes of structure including full list }
                   list:GEA;        { variable length GEA structures }
              END;

      PFEA=^FEA;
      FEA=RECORD  {pack 2}
                fEA:BYTE;           { flags                              }
                cbName:BYTE;        { name length not including NULL }
                cbValue:USHORT;     { value length }
          END;

      { flags for _FEA.fEA }
CONST
         FEA_NEEDEA         =$80;   { need EA bit }

TYPE
      PFEALIST=^FEALIST;
      FEALIST=RECORD { pack 2}
                   cbList:ULONG;    { total bytes of structure including full list }
                   list:FEA;        { variable length FEA structures }
              END;

      PEAOP=^EAOP;
      EAOP=RECORD { pack 2}
                 fpGEAList:PGEALIST; { general EA list }
                 fpFEAList:PFEALIST; { full EA list }
                 oError:ULONG;
           END;

      PFEA2=^FEA2;
      FEA2=RECORD {pack 1}
                 oNextEntryOffset:ULONG;    { new field }
                 fEA:BYTE;
                 cbName:BYTE;
                 cbValue:USHORT;
                 szName:CString[1];            { new field }
           END;

      PFEA2LIST=^FEA2LIST;
      FEA2LIST=RECORD {pack 1}
                     cbList:ULONG;
                     list:ARRAY[0..0] OF FEA2;
               END;

      PGEA2=^GEA2;
      GEA2=RECORD {pack 1}
                 oNextEntryOffset:ULONG; { new field }
                 cbName:BYTE;
                 szName:ARRAY[0..0] OF BYTE;         { new field }
           END;

      PGEA2LIST=^GEA2LIST;
      GEA2LIST=RECORD      { pack 1 }
                     cbList:ULONG;
                     list:ARRAY[0..0] OF GEA2;
               END;

      PEAOP2=^EAOP2;
      EAOP2=RECORD  { pack 1 }
                  fpGEA2List:PGEA2LIST;       { GEA set }
                  fpFEA2List:PFEA2LIST;       { FEA set }
                  oError:ULONG;           { offset of FEA error }
            END;

      {
      * Equates for the types of EAs that follow the convention that we have
      * established.
      *
      * Values =$FFFE thru =$8000 are reserved.
      * Values =$0000 thru =$7fff are user definable.
      * Value  =$FFFC is not used
      }
CONST
         EAT_BINARY      =$FFFE;      { length preceeded binary }
         EAT_ASCII       =$FFFD;      { length preceeded ASCII }
         EAT_BITMAP      =$FFFB;      { length preceeded bitmap }
         EAT_METAFILE    =$FFFA;      { length preceeded metafile }
         EAT_ICON        =$FFF9;      { length preceeded icon }
         EAT_EA          =$FFEE;      { length preceeded ASCII }
                                          { name of associated data (#include) }
         EAT_MVMT        =$FFDF;      { multi-valued, multi-typed field }
         EAT_MVST        =$FFDE;      { multi-valued, single-typed field }
         EAT_ASN1        =$FFDD;      { ASN.1 field }

   { File time and date types }

TYPE
   PFILESTATUS=^FILESTATUS;
   FILESTATUS=RECORD
                  fdateCreation:FDATE;
                  ftimeCreation:FTIME;
                  fdateLastAccess:FDATE;
                  ftimeLastAccess:FTIME;
                  fdateLastWrite:FDATE;
                  ftimeLastWrite:FTIME;
                  cbFile:ULONG;
                  cbFileAlloc:ULONG;
                  attrFile:WORD;
              END;

   PFILESTATUS2=^FILESTATUS2;
   FILESTATUS2=RECORD
                  fdateCreation:FDATE;
                  ftimeCreation:FTIME;
                  fdateLastAccess:FDATE;
                  ftimeLastAccess:FTIME;
                  fdateLastWrite:FDATE;
                  ftimeLastWrite:FTIME;
                  cbFile:ULONG;
                  cbFileAlloc:ULONG;
                  attrFile:WORD;
                  cbList:ULONG;
               END;

   PFILESTATUS3=^FILESTATUS3;
   FILESTATUS3=RECORD
                     fdateCreation:FDATE;
                     ftimeCreation:FTIME;
                     fdateLastAccess:FDATE;
                     ftimeLastAccess:FTIME;
                     fdateLastWrite:FDATE;
                     ftimeLastWrite:FTIME;
                     cbFile:ULONG;
                     cbFileAlloc:ULONG;
                     attrFile:ULONG;
               END;

   PFILESTATUS4=^FILESTATUS4;
   FILESTATUS4=RECORD
                     fdateCreation:FDATE;
                     ftimeCreation:FTIME;
                     fdateLastAccess:FDATE;
                     ftimeLastAccess:FTIME;
                     fdateLastWrite:FDATE;
                     ftimeLastWrite:FTIME;
                     cbFile:ULONG;
                     cbFileAlloc:ULONG;
                     attrFile:ULONG;
                     cbList:ULONG;
               END;

   PFSALLOCATE=^FSALLOCATE;
   FSALLOCATE=RECORD
                   idFileSystem:ULONG;
                   cSectorUnit:ULONG;
                   cUnit:ULONG;
                   cUnitAvail:ULONG;
                   cbSector:USHORT;
              END;

   HDIR=LHANDLE;

   { defines for DosSetPathInfo -pathinfo flag }
CONST
      DSPI_WRTTHRU    =$10;    { write through }


TYPE
   PDENA1=^DENA1;
   DENA1=RECORD  { pack 1 }
              reserved:UCHAR;     { 0 }
              cbName:UCHAR;       { length of name exculding NULL }
              cbValue:USHORT;     { length of value }
              szName:UCHAR;       { variable length asciiz name }
         END;

   PDENA2=^DENA2;
   DENA2=FEA2;

   { Infolevels for DosEnumAttribute  }
CONST
      ENUMEA_LEVEL_NO_VALUE   =1;      { FEA without value }
   { Reference types for DosEnumAttribute }
      ENUMEA_REFTYPE_FHANDLE  =0;       { file handle }
      ENUMEA_REFTYPE_PATH     =1;       { path name }
      ENUMEA_REFTYPE_MAX      =ENUMEA_REFTYPE_PATH;


{ 32-bit Semaphore Support }

{ Semaphore Attributes }
CONST
      DC_SEM_SHARED   =$01;   { DosCreateMutex, DosCreateEvent, and     }
                              {   DosCreateMuxWait use it to indicate   }
                              {   whether the semaphore is shared or    }
                              {   private when the PSZ is null          }
      DCMW_WAIT_ANY   =$02;   { DosCreateMuxWait option for wait on any }
                              {   event/mutex to occur                  }
      DCMW_WAIT_ALL   =$04;   { DosCreateMuxWait option for wait on all }
                              {   events/mutexs to occur                }

      SEM_INDEFINITE_WAIT     =-1;
      SEM_IMMEDIATE_RETURN    = 0;


TYPE
    HSEM=LONGWORD;

    PSEMRECORD=^SEMRECORD;
    SEMRECORD=RECORD
                    hsemCur:HSEM;
                    ulUser:ULONG;
              END;


   HMTX=ULONG;
   HMUX=ULONG;


TYPE
     HTIMER=LHANDLE;

CONST
      PT_16BIT        =0;
      PT_32BIT        =1;

{** Resource support }

{ Predefined resource types }
CONST
      RT_POINTER      =1;   { mouse pointer shape }
      RT_BITMAP       =2;   { bitmap }
      RT_MENU         =3;   { menu template }
      RT_DIALOG       =4;   { dialog template }
      RT_STRING       =5;   { string tables }
      RT_FONTDIR      =6;   { font directory }
      RT_FONT         =7;   { font }
      RT_ACCELTABLE   =8;   { accelerator tables }
      RT_RCDATA       =9;   { binary data }
      RT_MESSAGE      =10;  { error msg     tables }
      RT_DLGINCLUDE   =11;  { dialog include file name }
      RT_VKEYTBL      =12;  { key to vkey tables }
      RT_KEYTBL       =13;  { key to UGL tables }
      RT_CHARTBL      =14;  { glyph to character tables }
      RT_DISPLAYINFO  =15;  { screen display information }

      RT_FKASHORT     =16;  { function key area short form }
      RT_FKALONG      =17;  { function key area long form }

      RT_HELPTABLE    =18;  { Help table for Cary Help manager }
      RT_HELPSUBTABLE =19;  { Help subtable for Cary Help manager }

      RT_FDDIR        =20;  { DBCS uniq/font driver directory }
      RT_FD           =21;  { DBCS uniq/font driver }

      RT_MAX          =22;  { 1st unused Resource Type }


      RF_ORDINALID    =$80000000; { ordinal id flag in resource table }


{** NLS Support }

TYPE
   PCOUNTRYCODE=^COUNTRYCODE;
   COUNTRYCODE=RECORD
                    country:ULONG;
                    codepage:ULONG;
               END;

   PCOUNTRYINFO=^COUNTRYINFO;
   COUNTRYINFO=RECORD
                    country:ULONG;
                    codepage:ULONG;
                    fsDateFmt:ULONG;
                    szCurrency:CSTRING[4];
                    szThousandsSeparator:CSTRING[1];
                    szDecimal:CSTRING[1];
                    szDateSeparator:CSTRING[1];
                    szTimeSeparator:CSTRING[1];
                    fsCurrencyFmt:UCHAR;
                    cDecimalPlace:UCHAR;
                    fsTimeFmt:UCHAR;
                    abReserved1:ARRAY[0..1] OF USHORT;
                    szDataSeparator:CSTRING[1];
                    abReserved2:ARRAY[0..4] OF USHORT;
              END;

   { DosSetSigExceptionFocus codes }
CONST
      SIG_UNSETFOCUS  =0;
      SIG_SETFOCUS    =1;

TYPE
    HQUEUE=LHANDLE;

    PREQUESTDATA=^REQUESTDATA;
    REQUESTDATA=RECORD
                    pid:PID;
                    ulData:ULONG;
                END;

CONST
         QUE_FIFO              =0;
         QUE_LIFO              =1;
         QUE_PRIORITY          =2;
         QUE_NOCONVERT_ADDRESS =0;
         QUE_CONVERT_ADDRESS   =4;

   { definitions for DosSearchPath control word }
CONST
      DSP_IMPLIEDCUR          =1; { current dir will be searched first }
      DSP_PATHREF             =2; { from env.variable }
      DSP_IGNORENETERR        =4; { ignore net errs & continue search }

   { indices for DosQuerySysInfo }
      QSV_MAX_PATH_LENGTH     =1;
      Q_MAX_PATH_LENGTH       =QSV_MAX_PATH_LENGTH;
      QSV_MAX_TEXT_SESSIONS   =2;
      QSV_MAX_PM_SESSIONS     =3;
      QSV_MAX_VDM_SESSIONS    =4;
      QSV_BOOT_DRIVE          =5;       { 1=A, 2=B, etc. }
      QSV_DYN_PRI_VARIATION   =6;       { 0=Absolute, 1=Dynamic }
      QSV_MAX_WAIT            =7;       { seconds }
      QSV_MIN_SLICE           =8;       { milli seconds }
      QSV_MAX_SLICE           =9;       { milli seconds }
      QSV_PAGE_SIZE           =10;
      QSV_VERSION_MAJOR       =11;
      QSV_VERSION_MINOR       =12;
      QSV_VERSION_REVISION    =13;      { Revision letter }
      QSV_MS_COUNT            =14;      { Free running millisecond counter }
      QSV_TIME_LOW            =15;      { Low dword of time in seconds }
      QSV_TIME_HIGH           =16;      { High dword of time in seconds }
      QSV_TOTPHYSMEM          =17;      { Physical memory on system }
      QSV_TOTRESMEM           =18;      { Resident memory on system }
      QSV_TOTAVAILMEM         =19;      { Available memory for all processes }
      QSV_MAXPRMEM            =20;      { Avail private mem for calling proc }
      QSV_MAXSHMEM            =21;      { Avail shared mem for calling proc }
      QSV_TIMER_INTERVAL      =22;      { Timer interval in tenths of ms }
      QSV_MAX_COMP_LENGTH     =23;      { max len of one component in a name }
      QSV_MAX                 =QSV_MAX_COMP_LENGTH;

   { definitions for DosError - combine with | }
      FERR_DISABLEHARDERR     =$00000000;     { disable hard error popups }
      FERR_ENABLEHARDERR      =$00000001;     { enable hard error popups }
      FERR_ENABLEEXCEPTION    =$00000000;     { enable exception popups }
      FERR_DISABLEEXCEPTION   =$00000002;     { disable exception popups }

   { definitions for DosQueryRASInfo Index }
      SIS_MMIOADDR            =0;
      SIS_MEC_TABLE           =1;
      SIS_SYS_LOG             =2;

{** Session manager support }
TYPE
   PSTARTDATA=^STARTDATA;
   STARTDATA=RECORD
                  Length:USHORT;
                  Related:USHORT;
                  FgBg:USHORT;
                  TraceOpt:USHORT;
                  PgmTitle:PChar;
                  PgmName:PChar;
                  PgmInputs:PChar;
                  TermQ:PBYTE;
                  Environment:PBYTE;
                  InheritOpt:USHORT;
                  SessionType:USHORT;
                  IconFile:PChar;
                  PgmHandle:ULONG;
                  PgmControl:USHORT;
                  InitXPos:USHORT;
                  InitYPos:USHORT;
                  InitXSize:USHORT;
                  InitYSize:USHORT;
                  Reserved:USHORT;
                  ObjectBuffer:PChar;
                  ObjectBuffLen:ULONG;
            END;

CONST
      SSF_RELATED_INDEPENDENT =0;
      SSF_RELATED_CHILD       =1;

      SSF_FGBG_FORE           =0;
      SSF_FGBG_BACK           =1;

      SSF_TRACEOPT_NONE       =0;
      SSF_TRACEOPT_TRACE      =1;
      SSF_TRACEOPT_TRACEALL   =2;

      SSF_INHERTOPT_SHELL     =0;
      SSF_INHERTOPT_PARENT    =1;

   { note that these types are identical to those in pmshl.h for PROG_* }
      SSF_TYPE_DEFAULT        =0;
      SSF_TYPE_FULLSCREEN     =1;
      SSF_TYPE_WINDOWABLEVIO  =2;
      SSF_TYPE_PM             =3;
      SSF_TYPE_VDM            =4;
      SSF_TYPE_GROUP          =5;
      SSF_TYPE_DLL            =6;
      SSF_TYPE_WINDOWEDVDM    =7;
      SSF_TYPE_PDD            =8;
      SSF_TYPE_VDD            =9;

   { note that these flags are identical to those in pmshl.h for SHE_* }
      SSF_CONTROL_VISIBLE     =$0000;
      SSF_CONTROL_INVISIBLE   =$0001;
      SSF_CONTROL_MAXIMIZE    =$0002;
      SSF_CONTROL_MINIMIZE    =$0004;
      SSF_CONTROL_NOAUTOCLOSE =$0008;
      SSF_CONTROL_SETPOS      =$8000;

TYPE
   PSTATUSDATA=^STATUSDATA;
   STATUSDATA=RECORD
                    Length:USHORT;
                    SelectInd:USHORT;
                    BondInd:USHORT;
              END;

   { SelectInd and BondInd paramater values for DosSetSession }
CONST
      SET_SESSION_UNCHANGED      =0;
      SET_SESSION_SELECTABLE     =1;
      SET_SESSION_NON_SELECTABLE =2;
      SET_SESSION_BOND           =1;
      SET_SESSION_NO_BOND        =2;

   { TargetOption (scope) parameter values for DosStopSession }
      STOP_SESSION_SPECIFIED     =0;
      STOP_SESSION_ALL           =1;

   { AppType returned in by DosQueryAppType in pFlags as follows          }
CONST
      FAPPTYP_NOTSPEC         =$0000;
      FAPPTYP_NOTWINDOWCOMPAT =$0001;
      FAPPTYP_WINDOWCOMPAT    =$0002;
      FAPPTYP_WINDOWAPI       =$0003;
      FAPPTYP_BOUND           =$0008;
      FAPPTYP_DLL             =$0010;
      FAPPTYP_DOS             =$0020;
      FAPPTYP_PHYSDRV         =$0040;  { physical device driver       }
      FAPPTYP_VIRTDRV         =$0080;  { virtual device driver        }
      FAPPTYP_PROTDLL         =$0100;  { 'protected memory' dll       }
      FAPPTYP_WINDOWSREAL     =$0200;  { Windows real mode app        }
      FAPPTYP_WINDOWSPROT     =$0400;  { Windows protect mode app     }
      FAPPTYP_WINDOWSPROT31   =$1000;  { Windows 3.1 protect mode app }
      FAPPTYP_32BIT           =$4000;
      FAPPTYP_EXETYPE         =FAPPTYP_WINDOWAPI;

      FAPPTYP_RESERVED        =NOT (FAPPTYP_WINDOWAPI | FAPPTYP_BOUND |
                                    FAPPTYP_DLL | FAPPTYP_DOS |
                                    FAPPTYP_PHYSDRV | FAPPTYP_VIRTDRV |
                                    FAPPTYP_PROTDLL | FAPPTYP_32BIT);

      EAT_APPTYP_PMAPI        =$00;            { Uses PM API }
      EAT_APPTYP_DOS          =$01;            { DOS APP }
      EAT_APPTYP_PMW          =$02;            { Window compatible }
      EAT_APPTYP_NOPMW        =$03;            { Not Window compatible }
      EAT_APPTYP_EXETYPE      =$03;            { EXE type mask }
      EAT_APPTYP_RESERVED     =NOT EAT_APPTYP_EXETYPE;

CONST
      DEVINFO_PRINTER         =0;       { Number of printers attached }
      DEVINFO_RS232           =1;       { Number of RS232 ports }
      DEVINFO_FLOPPY          =2;       { Number of diskette drives }
      DEVINFO_COPROCESSOR     =3;       { Presence of math coprocessor }
      DEVINFO_SUBMODEL        =4;       { PC Submodel Type }
      DEVINFO_MODEL           =5;       { PC Model Type }
      DEVINFO_ADAPTER         =6;       { Primary display adapter type }


CONST
      INFO_COUNT_PARTITIONABLE_DISKS  =1;       { # of partitionable disks }
      INFO_GETIOCTLHANDLE             =2;       { Obtain handle            }
      INFO_FREEIOCTLHANDLE            =3;       { Release handle           }



{** Data structures used with named pipes **}
TYPE
   HPIPE=LHANDLE;


   PAVAILDATA=^AVAILDATA;
   AVAILDATA=RECORD
                 cbpipe:USHORT;      { bytes left in the pipe }
                 cbmessage:USHORT;   { bytes left in the current message }
             END;

   PPIPEINFO=^PIPEINFO;
   PIPEINFO=RECORD
                 cbOut:USHORT;       { length of outgoing I/O buffer }
                 cbIn:USHORT;        { length of incoming I/O buffer }
                 cbMaxInst:BYTE;     { maximum number of instances   }
                 cbCurInst:BYTE;     { current number of instances   }
                 cbName:BYTE;        { length of pipe name           }
                 szName:CHAR;        { start of name                 }
            END;

   PPIPESEMSTATE=^PIPESEMSTATE;
   PIPESEMSTATE=RECORD
                     fStatus:BYTE;  { type of record, 0 = EOI, 1 = read ok, }
                                    { 2 = write ok, 3 = pipe closed         }
                     fFlag:BYTE;    { additional info, 01 = waiting thread  }
                     usKey:USHORT;  { user's key value                      }
                     usAvail:USHORT;{ available data/space if status = 1/2  }
                END;

CONST
      NP_INDEFINITE_WAIT      =-1;
      NP_DEFAULT_WAIT         =0;

   { DosPeekNmPipe() pipe states }

      NP_STATE_DISCONNECTED   =$0001;
      NP_STATE_LISTENING      =$0002;
      NP_STATE_CONNECTED      =$0003;
      NP_STATE_CLOSING        =$0004;

   { DosCreateNPipe open modes }

      NP_ACCESS_INBOUND       =$0000;
      NP_ACCESS_OUTBOUND      =$0001;
      NP_ACCESS_DUPLEX        =$0002;
      NP_INHERIT              =$0000;
      NP_NOINHERIT            =$0080;
      NP_WRITEBEHIND          =$0000;
      NP_NOWRITEBEHIND        =$4000;

   { DosCreateNPipe and DosQueryNPHState state }

      NP_READMODE_BYTE        =$0000;
      NP_READMODE_MESSAGE     =$0100;
      NP_TYPE_BYTE            =$0000;
      NP_TYPE_MESSAGE         =$0400;
      NP_END_CLIENT           =$0000;
      NP_END_SERVER           =$4000;
      NP_WAIT                 =$0000;
      NP_NOWAIT               =$8000;
      NP_UNLIMITED_INSTANCES  =$00FF;

   { values in fStatus }
CONST
      NPSS_EOI                   =0;     { End Of Information    }
      NPSS_RDATA                 =1;     { read data available   }
      NPSS_WSPACE                =2;     { write space available }
      NPSS_CLOSE                 =3;     { pipe in CLOSING state }

   { values in npss_flag }
      NPSS_WAIT                  =$01;  { waiting thread on end of pipe }

   { defined bits in pipe mode }
      NP_NBLK                    =$8000; { non-blocking read/write }
      NP_SERVER                  =$4000; { set if server end       }
      NP_WMESG                   =$0400; { write messages          }
      NP_RMESG                   =$0100; { read as messages        }
      NP_ICOUNT                  =$00FF; { instance count field    }


   {Named pipes may be in one of several states depending on the actions
   * that have been taken on it by the server end and client end.  The
   * following state/action table summarizes the valid state transitions:
   *
   * Current state           Action                  Next state
   *
   *  <none>             server DosMakeNmPipe        DISCONNECTED
   *  DISCONNECTED       server connect              LISTENING
   *  LISTENING          client open                 CONNECTED
   *  CONNECTED          server disconn              DISCONNECTED
   *  CONNECTED          client close                CLOSING
   *  CLOSING            server disconn              DISCONNECTED
   *  CONNECTED          server close                CLOSING
   *  <any other>        server close                <pipe deallocated>
   *
   * If a server disconnects his end of the pipe, the client end will enter a
   * special state in which any future operations (except close) on the file
   * descriptor associated with the pipe will return an error.
   }

   {
   *      Values for named pipe state
   }

      NP_DISCONNECTED       =1;         { after pipe creation or Disconnect }
      NP_LISTENING          =2;         { after DosNmPipeConnect            }
      NP_CONNECTED          =3;         { after Client open                 }
      NP_CLOSING            =4;         { after Client or Server close      }


   { DosProfile ordinal number }
CONST
      PROF_ORDINAL        =133;

   { DosProfile usType }

      PROF_SYSTEM           =0;
      PROF_USER             =1;
      PROF_USEDD            =2;
      PROF_KERNEL           =4;
      PROF_VERBOSE          =8;
      PROF_ENABLE           =16;

   { DosProfile usFunc }

      PROF_ALLOC            =0;
      PROF_CLEAR            =1;
      PROF_ON               =2;
      PROF_OFF              =3;
      PROF_DUMP             =4;
      PROF_FREE             =5;

   { DosProfile tic count granularity (DWORD) }

      PROF_SHIFT            =2;

   { DosProfile module name string length }

      PROF_MOD_NAME_SIZE    =10;

   { DosProfile error code for end of data }

      PROF_END_OF_DATA      =13;


TYPE
    HVDD=LHANDLE;


{ ProcStat: Verwendet fuer DosQProcStatus; DOSCALLS / 154 }
type tProcStat = Record
       PROCSTAT_Summary : ULong;
       PROCSTAT_Processes : ULong;
       PROCSTAT_Semaphores : ULong;
       PROCSTAT_Unknown1 : ULong;
       PROCSTAT_Sharedmemory : ULong;
       PROCSTAT_Modules : ULong;
       PROCSTAT_Unknown2 : ULong;
       PROCSTAT_Unknown3 : ULong;
     End;

IMPORTS

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ DLL: DosCalls                                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{Function DosGetPrty(VAR }
FUNCTION DosForceDelete(VAR pszFile:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 110;
FUNCTION DosKillThread(atid:TID):APIRET;
                    APIENTRY;             'DOSCALLS' index 111;
FUNCTION DosQueryRASInfo(index:ULONG;VAR Addr:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 112;
// 113     DosDumpProcess
// 114     DosSuppressPopUps
// 115     THK32ALLOCMEM
// 116     THK32FREEMEM
// 117     THK32ALLOCSTACK
// 118     DosOpen2Compt
// 119     Dos16GetSTDA
// 120     Dos16Error
// 121     Dos16GetSeg
// 122     Dos16LockSeg
// 123     Dos16UnlockSeg
// 124     Dos16SGSwitchProc
// 125     DosIRamSemWake
// 126     Dos16SizeSeg
// 127     Dos16MemAvail
// 128     DosIRamSemRequest
// 129     DosPhysicalDisk
// 130     Dos16GetCP
// 131     DosISetCP
// 132     DosGlobalSeg
// 133     Dos16Profile
// 134     Dos16SendSignal
// 135     DosHugeShift
// 136     DosHugeIncr
// 137     Dos16Read
// 138     Dos16Write
// 139     Dos16ErrClass
// 140     Dos16SemRequest
// 141     Dos16SemClear
// 142     Dos16SemWait
// 143     Dos16SemSet
// 144     Dos16ExecPgm
// 145     Dos16CreateThread
// 146     Dos16SubSet
// 147     Dos16SubAlloc
// 148     Dos16SubFree
// 149     Dos16ReadAsync
// 150     Dos16WriteAsync
// 151     Dos16SearchPath
// 152     Dos16ScanEnv
// 153     Dos16SetCP
FUNCTION DosQProcStatus(Var pBuf : tProcStat ;cbBuf : USHORT) : APIRET;
                    APIENTRY;             'DOSCALLS' index 154;
// 155     Dos16GetResource
// 156     Dos16GetPPID
// 157     Dos16CallBack
// 158     DosICallBack
// 159     DosRetForward
// 160     Dos16R2StackRealloc
// 161     Dos16FSRamSemRequest
// 162     Dos16FSRamSemClear
// 163     Dos16QAppType
// 164     Dos16SetProcCP
// 165     Dos16DynamicTrace
// 166     Dos16QSysInfo
// 167     DosIMakeNmPipe
// 168     DosICallNmPipe
// 169     DosIConnectNmPipe
// 170     DosIDisconnectNmPipe
// 171     DosIPeekNmPipe
// 172     DosIQNmPipeInfo
// 173     DosIQNmPHandState
// 174     DosISetNmPHandState
// 175     DosITransactNmPipe
// 176     DosIWaitNmPipe
// 177     DosISetNmPipeSem
// 178     DosIQNmPipeSemState
// 179     DosIRawReadNmPipe
// 180     DosIRawWriteNmPipe
// 181     Dos16FSAttach
// 182     Dos16QFSAttach
// 183     Dos16FSCtl
// 184     Dos16FindFirst2
// 185     Dos16MkDir2
// 186     Dos16FileIO
// 187     Dos16FindNotifyClose
// 188     Dos16FindNotifyFirst
// 189     Dos16FindNotifyNext
// 190     Dos16SetTraceInfo
// 191     Dos16EditName
// 192     Dos16LogMode
// 193     Dos16LogEntry
// 194     Dos16GetLogBuffer
// 195     Dos16LogRegister
// 196     Dos16LogRead
// 197     Dos16FindFromName
// 198     Dos16OPLockRelease
// 199     Dos16OPLockWait
// 200     DosICopy
// 201     Dos16Copy
// 202     DosIQAppType
// 203     DosForceDelete
// 204     DosEnumAttribute
// 205     Dos16OPLockShutdown
// 206     DosShutdown
// 207     DosGetResource2
// 208     DosFreeResource
FUNCTION DosSetMaxFH(cFH:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 209;
FUNCTION DosSetVerify(apBool:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 210;
FUNCTION DosErrClass(code:ULONG;VAR pClass,pAction,pLocus:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 211;
FUNCTION DosErrorAPI(error:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 212;
// 213     DosCreateVDM
// 214     DosMaxPathLen
// 215     DosPageSize
// 216     DosLocalInfo
// 217     DosGlobalInfo
FUNCTION DosSetFileInfo(hf:HFILE;ulInfoLevel:ULONG;VAR pInfoBuf;
                        cbInfoBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 218;
FUNCTION DosSetPathInfo(pszPathName:CSTRING;ulInfoLevel:ULONG;VAR pInfoBuf;
                        cbInfoBuf,flOptions:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 219;
FUNCTION DosSetDefaultDisk(disknum:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 220;
FUNCTION DosSetFHState(ahFile:HFILE;mode:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 221;
FUNCTION DosSetFSInfo(disknum,infolevel:ULONG;VAR pBuf;
                      cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 222;
FUNCTION DosQueryPathInfo(VAR pszPathName:CSTRING;ulInfoLevel:ULONG;VAR pInfoBuf;
                          cbInfoBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 223;
FUNCTION DosQueryHType(ahFile:HFILE;VAR pType,pAttr:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 224;
FUNCTION DosQueryVerify(VAR apBool:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 225;
FUNCTION DosDeleteDir(pszDir:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 226;
FUNCTION DosScanEnv(VAR pszName:CSTRING;VAR ppszValue:PCHAR):APIRET;
                    APIENTRY;             'DOSCALLS' index 227;
FUNCTION DosSearchPath(flag:ULONG;
                       pszPathOrName : AnsiString; // pszPathOrName : pChar;
                       Var pszFilename:CSTRING;
                       VAR pBuf;cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 228;
FUNCTION DosSleep(msec:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 229;
FUNCTION DosGetDateTime(VAR pdt:DATETIME):APIRET;
                    APIENTRY;             'DOSCALLS' index 230;
FUNCTION DosDevConfig(VAR pdevinfo;item:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 231;
FUNCTION DosEnterCritSec:APIRET;
                    APIENTRY;             'DOSCALLS' index 232;
FUNCTION DosExitCritSec:APIRET;
                    APIENTRY;             'DOSCALLS' index 233;
FUNCTION DosExit(action,result:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 234;
FUNCTION DosKillProcess(action:ULONG;apid:PID):APIRET;
                    APIENTRY;             'DOSCALLS' index 235;
FUNCTION DosSetPriority(scope,aclass:ULONG;delta:LONG;PorTid:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 236;
FUNCTION DosResumeThread(atid:TID):APIRET;
                    APIENTRY;             'DOSCALLS' index 237;
FUNCTION DosSuspendThread(atid:TID):APIRET;
                    APIENTRY;             'DOSCALLS' index 238;
FUNCTION DosCreatePipe(VAR phfRead,phfWrite:HFILE;cb:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 239;
FUNCTION DosCallNPipe(VAR pszName:CSTRING;VAR pInbuf;cbIn:ULONG;VAR pOutbuf;
                      cbOut:ULONG;VAR pcbActual:ULONG;msec:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 240;
FUNCTION DosConnectNPipe(ahpipe:HPIPE):APIRET;
                    APIENTRY;             'DOSCALLS' index 241;
FUNCTION DosDisConnectNPipe(ahpipe:HPIPE):APIRET;
                    APIENTRY;             'DOSCALLS' index 242;
FUNCTION DosCreateNPipe(VAR pszName:CSTRING;VAR apHpipe:HPIPE;openmode,pipemode,
                        cbInbuf,cbOutbuf,msec:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 243;
FUNCTION DosPeekNPipe(ahpipe:HPIPE;VAR pBuf;cbBuf:ULONG;VAR pcbActual:ULONG;
                      VAR pAvail:AVAILDATA;VAR pState:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 244;
FUNCTION DosQueryNPHState(ahpipe:HPIPE;VAR pState:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 245;
FUNCTION DosRawReadNPipe(VAR pszName:CSTRING;cb:ULONG;VAR pLen:ULONG;
                         VAR pBuf):APIRET;
                    APIENTRY;             'DOSCALLS' index 246;
FUNCTION DosRawWriteNPipe(VAR pszName:CSTRING;cb:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 247;
FUNCTION DosQueryNPipeInfo(ahpipe:HPIPE;infolevel:ULONG;VAR pBuf;
                           cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 248;
FUNCTION DosQueryNPipeSemState(ahsem:HSEM;VAR pnpss:PIPESEMSTATE;
                               cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 249;
FUNCTION DosSetNPHState(ahpipe:HPIPE;state:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 250;
FUNCTION DosSetNPipeSem(ahpipe:HPIPE;ahsem:HSEM;key:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 251;
FUNCTION DosTransactNPipe(ahpipe:HPIPE;VAR pOutbuf;cbOut:ULONG;
                          VAR pInbuf;cbIn:ULONG;VAR pcbRead:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 252;
FUNCTION DosWaitNPipe(VAR pszName:CSTRING;msec:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 253;
FUNCTION DosResetBuffer(ahFile:HFILE):APIRET;
                    APIENTRY;             'DOSCALLS' index 254;
FUNCTION DosSetCurrentDir(pszDir:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 255;
FUNCTION DosSetFilePtr(ahFile:HFILE;ib:LONG;method:ULONG;
                       VAR ibActual:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 256;
FUNCTION DosClose(ahFile:HFILE):APIRET;
                    APIENTRY;             'DOSCALLS' index 257;
FUNCTION DosCopy(VAR pszOld,pszNew:CSTRING;option:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 258;
FUNCTION DosDelete(VAR pszFile:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 259;
FUNCTION DosDupHandle(ahFile:HFILE;VAR apHfile:HFILE):APIRET;
                    APIENTRY;             'DOSCALLS' index 260;
FUNCTION DosEditName(metalevel:ULONG;VAR pszSource,pszEdit:CSTRING;
                     VAR pszTarget;cbTarget:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 261;
// 262     THK32FREESTACK
FUNCTION DosFindClose(ahDir:HDIR):APIRET;
                    APIENTRY;             'DOSCALLS' index 263;
FUNCTION DosFindFirst(VAR pszFileSpec:CSTRING;VAR aphdir:HDIR;flAttribute:ULONG;
                      VAR pfindbuf;cbBuf:ULONG;VAR pcFileNames:ULONG;
                      ulInfoLevel:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 264;
FUNCTION DosFindNext(ahDir:HDIR;VAR pfindbuf;cbfindbuf:ULONG;
                     VAR pcFilenames:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 265;
// 266     Dos16OpenVDD
// 267     Dos16RequestVDD
// 268     Dos16CloseVDD
FUNCTION DosFSAttach(VAR pszDevice:CSTRING;VAR pszFilesystem:CSTRING;VAR pData;
                     cbData:ULONG;flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 269;
FUNCTION DosCreateDir(pszDirName:CSTRING;VAR apeaop2:EAOP2):APIRET;
                    APIENTRY;             'DOSCALLS' index 270;
FUNCTION DosMove(VAR pszOld,pszNew:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 271;
FUNCTION DosSetFileSize(ahFile:HFILE;cbSize:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 272;
FUNCTION DosOpen(pszFileName:CSTRING;VAR pHf:HFILE;VAR pulAction:ULONG;
                 cbFile,ulAttribute,fsOpenFlags,fsOpenMode:ULONG;
                 VAR apeaop2:EAOP2):APIRET;
                    APIENTRY;             'DOSCALLS' index 273;
FUNCTION DosQueryCurrentDirAPI(disknum:ULONG;VAR pBuf;
                               VAR pcbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 274;
FUNCTION DosQueryCurrentDisk(VAR pdisknum,plogical:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 275;
FUNCTION DosQueryFHState(ahFile:HFILE;VAR pMode:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 276;
FUNCTION DosQueryFSAttach(VAR pszDeviceName:CSTRING;ulOrdinal,ulFSAInfoLevel:ULONG;
                          VAR pfsqb:FSQBUFFER2;
                          VAR pcbBuffLength:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 277;
FUNCTION DosQueryFSInfo(disknum,infolevel:ULONG;VAR pBuf;
                        cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 278;
FUNCTION DosQueryFileInfo(hf:HFILE;ulInfoLevel:ULONG;
                          VAR pInfo;cbInfoBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 279;
FUNCTION DosWaitChild(action,option:ULONG;VAR pres:RESULTCODES;
                      VAR appid:PID;apid:PID):APIRET;
                    APIENTRY;             'DOSCALLS' index 280;
FUNCTION DosRead(ahFile:HFILE;VAR pBuffer;cbRead:ULONG;
                 VAR pcbActual:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 281;
FUNCTION DosWrite(ahFile:HFILE;CONST pBuffer;cbWrite:ULONG;
                  VAR pcbActual:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 282;
FUNCTION DosExecPgm(pObjname:POINTER;cbObjname:LONG;execFlag:ULONG;
                    VAR pArg,pEnv:CSTRING;VAR pRes:RESULTCODES;
                    CONST pName:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 283;
FUNCTION DosDevIOCtl(hDevice:HFILE;category,afunction:ULONG;
                     VAR pParams;cbParmLenMax:ULONG;VAR pcbParmLen:ULONG;
                     VAR pData;cbDataLenMax:ULONG;VAR pcbDataLen:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 284;
FUNCTION DosFSCtl(VAR pData;cbData:ULONG;VAR pcbData:ULONG;VAR pParms;
                  cbParms:ULONG;VAR pcbParms:ULONG;afunction:ULONG;
                  VAR pszRoute:CSTRING;ahFile:HFILE;method:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 285;
FUNCTION DosBeep(freq,dur:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 286;
FUNCTION DosPhysicalDisk(afunction:ULONG;VAR pBuf;cbBuf:ULONG;
                         VAR pParams;cbParams:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 287;
// 288     Dos32SetCp
FUNCTION DosSetProcessCp(cp:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 289;
FUNCTION DosStopTimer(ahtimer:HTIMER):APIRET;
                    APIENTRY;             'DOSCALLS' index 290;
FUNCTION DosQueryCp(cb:ULONG;VAR arCP,pcCP:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 291;
FUNCTION DosSetDateTime(VAR pdt:DATETIME):APIRET;
                    APIENTRY;             'DOSCALLS' index 292;
// 293     Thk32AllocBlock
// 294     Thk32FreeBlock
// 295     Thk32R3DS
FUNCTION DosExitList(ordercode:ULONG;pfn:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 296;
// 297     Dos32AllocProtectedMem
// 298     Dos32AliasMem
FUNCTION DosAllocMem(VAR ppb:POINTER;cb,flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 299;
FUNCTION DosAllocSharedMem(VAR ppb:POINTER;VAR pszName:CSTRING;
                           cb,flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 300;
FUNCTION DosGetNamedSharedMem(VAR ppb:POINTER;pszName:CSTRING;
                              flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 301;
FUNCTION DosGetSharedMem(pb:POINTER;flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 302;
FUNCTION DosGiveSharedMem(pb:POINTER;apid:PID;flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 303;
FUNCTION DosFreeMem(pb:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 304;
FUNCTION DosSetMem(pb:POINTER;cb,flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 305;
FUNCTION DosQueryMem(pb:POINTER;VAR pcb,pFlag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 306;
// 307     Dos32QueryMemState
FUNCTION DosOpenVDD(VAR pszVDD:CSTRING;VAR aphvdd:HVDD):APIRET;
                    APIENTRY;             'DOSCALLS' index 308;
FUNCTION DosRequestVDD(ahvdd:HVDD;asgid:SGID;cmd,cbInput:ULONG;VAR pInput;
                       cbOutput:ULONG;VAR pOutput):APIRET;
                    APIENTRY;             'DOSCALLS' index 309;
FUNCTION DosCloseVDD(ahvdd:HVDD):APIRET;
                    APIENTRY;             'DOSCALLS' index 310;
FUNCTION DosCreateThread(VAR aptid:TID;pfn:POINTER;param:POINTER;flag:ULONG;
                         cbStack:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 311;
FUNCTION DosGetInfoBlocks(VAR pptib:PTIB;VAR pppib:PPIB):APIRET;
                    APIENTRY;             'DOSCALLS' index 312;
// 313     Dos16AllocProtSeg
// 314     Dos16AllocShrProtSeg
// 315     Dos16AllocProtHuge
// 316     Dos32DynamicTrace
FUNCTION DosDebug(VAR apdbgbuf:TDBGBUF):APIRET;
                    APIENTRY;             'DOSCALLS' index 317;
FUNCTION DosLoadModule(pszName:CSTRING;cbName:ULONG;pszModname:CSTRING;
                       VAR phmod:HMODULE):APIRET;
                    APIENTRY;             'DOSCALLS' index 318;
FUNCTION DosQueryModuleHandle(VAR pszModname:CSTRING;VAR phmod:HMODULE):APIRET;
                    APIENTRY;             'DOSCALLS' index 319;
FUNCTION DosQueryModuleName(hmod:HMODULE;cbName:ULONG;VAR apch):APIRET;
                    APIENTRY;             'DOSCALLS' index 320;
FUNCTION DosQueryProcAddr(hmod:HMODULE;ordinal:ULONG;VAR pszName:CSTRING;
                          VAR ppfn:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 321;
FUNCTION DosFreeModule(hmod:HMODULE):APIRET;
                    APIENTRY;             'DOSCALLS' index 322;
FUNCTION DosQueryAppType(CONST pszName:CSTRING;VAR pFlags:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 323;
FUNCTION DosCreateEventSem(VAR pszName:CSTRING;VAR aphev:HEV;flAttr:ULONG;
                           fState:BOOL):APIRET;
                    APIENTRY;             'DOSCALLS' index 324;
FUNCTION DosOpenEventSem (VAR pszName:CSTRING;VAR aphev:HEV):APIRET;
                    APIENTRY;             'DOSCALLS' index 325;
FUNCTION DosCloseEventSem(ahev:HEV):APIRET;
                    APIENTRY;             'DOSCALLS' index 326;
FUNCTION DosResetEventSem(ahev:HEV;VAR pulPostCt:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 327;
FUNCTION DosPostEventSem(ahev:HEV):APIRET;
                    APIENTRY;             'DOSCALLS' index 328;
FUNCTION DosWaitEventSem(ahev:HEV;ulTimeout:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 329;
FUNCTION DosQueryEventSem(ahev:HEV;VAR pulPostCt:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 330;
FUNCTION DosCreateMutexSem(pszName:CSTRING;VAR aphmtx:HMTX;flAttr:ULONG;
                           fState:BOOL):APIRET;
                    APIENTRY;             'DOSCALLS' index 331;
FUNCTION DosOpenMutexSem (pszName:CSTRING;VAR phmtx:HMTX):APIRET;
                    APIENTRY;             'DOSCALLS' index 332;
FUNCTION DosCloseMutexSem (ahmtx:HMTX):APIRET;
                    APIENTRY;             'DOSCALLS' index 333;
FUNCTION DosRequestMutexSem(ahmtx:HMTX;ulTimeout:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 334;
FUNCTION DosReleaseMutexSem(ahmtx:HMTX):APIRET;
                    APIENTRY;             'DOSCALLS' index 335;
FUNCTION DosQueryMutexSem(ahmtx:HMTX;VAR appid:PID;VAR aptid:TID;
                          VAR pulCount:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 336;
FUNCTION DosCreateMuxWaitSem(VAR pszName:CSTRING;VAR aphmux:HMUX;cSemRec:ULONG;
                             VAR pSemRec;flAttr:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 337;
FUNCTION DosOpenMuxWaitSem(VAR pszName:CSTRING;VAR aphmux:HMUX):APIRET;
                    APIENTRY;             'DOSCALLS' index 338;
FUNCTION DosCloseMuxWaitSem(ahmux:HMUX):APIRET;
                    APIENTRY;             'DOSCALLS' index 339;
FUNCTION DosWaitMuxWaitSem(ahmux:HMUX;ulTimeout:ULONG;
                           VAR pulUser:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 340;
FUNCTION DosAddMuxWaitSem(ahmux:HMUX;VAR pSemRec:SEMRECORD):APIRET;
                    APIENTRY;             'DOSCALLS' index 341;
FUNCTION DosDeleteMuxWaitSem(ahmux:HMUX;ahSem:HSEM):APIRET;
                    APIENTRY;             'DOSCALLS' index 342;
FUNCTION DosQueryMuxWaitSem(ahmux:HMUX;VAR pcSemRec:ULONG;
                            VAR pSemRec:SEMRECORD;
                            VAR pflAttr:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 343;
FUNCTION DosSubSetMem(pbBase:POINTER;flag,cb:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 344;
FUNCTION DosSubAllocMem(pbBase:POINTER;VAR ppb:POINTER;
                        cb:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 345;
FUNCTION DosSubFreeMem(pbBase:POINTER;pb:POINTER;cb:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 346;
FUNCTION DosSubUnsetMem(pbBase:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 347;
FUNCTION DosQuerySysInfo(iStart,iLast:ULONG;VAR pBuf;cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 348;
FUNCTION DosWaitThread(VAR aptid:TID;option:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 349;
FUNCTION DosAsyncTimer(msec:ULONG;ahsem:HSEM;VAR aphtimer:HTIMER):APIRET;
                    APIENTRY;             'DOSCALLS' index 350;
FUNCTION DosStartTimer(msec:ULONG;ahsem:HSEM;VAR aphtimer:HTIMER):APIRET;
                    APIENTRY;             'DOSCALLS' index 351;
FUNCTION DosGetResource(hmod:HMODULE;idType,idName:ULONG;
                        VAR ppb:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 352;
FUNCTION DosFreeResource(pb:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 353;
FUNCTION DosSetExceptionHandler(VAR PERegrec:EXCEPTIONREGISTRATIONRECORD):APIRET;
                    APIENTRY;             'DOSCALLS' index 354;
FUNCTION DosUnsetExceptionHandler(VAR PERegRec:EXCEPTIONREGISTRATIONRECORD):APIRET;
                    APIENTRY;             'DOSCALLS' index 355;
FUNCTION DosRaiseException(VAR Pexcept:EXCEPTIONREPORTRECORD):APIRET;
                    APIENTRY;             'DOSCALLS' index 356;
FUNCTION DosUnwindException(VAR pHandler:EXCEPTIONREGISTRATIONRECORD;
                            VAR pTargetIP;
                            VAR pERepRec:EXCEPTIONREPORTRECORD):APIRET;
                    APIENTRY;             'DOSCALLS' index 357;
// 358     Dos32QueryPageUsage
// 359     Dos16QueryModFromCS
// 360     Dos32QueryModFromEIP
// 361     DosFPDataArea
FUNCTION DosTmrQueryFreq(VAR pulTmrFreq:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 362;
FUNCTION DosTmrQueryTime(VAR pqwTmrTime):APIRET;
                    APIENTRY;             'DOSCALLS' index 363;
// 364     Dos32AliasPerfCtrs
// 365     Dos32ConfigPerf
// 366     Dos32DeconPerf
FUNCTION DosRegisterPerfCtrs(VAR pbDataBlk;VAR pbTextBlk;
                             flFlags:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 367;
FUNCTION DosQuerySysState(EntityList:ULONG;EntityLevel:ULONG;
                          pid:USHORT;tid:Ushort;var pDataBuf;cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 368;
// 369 Dos32FlatCS
// 370     Dos32FlatDS
// 371     Dos32QueryABIOSSupport
FUNCTION DosEnumAttribute(ulRefType:ULONG;VAR pvFile;ulEntry:ULONG;
                          VAR pvBuf;cbBuf:ULONG;VAR pulCount:ULONG;
                          ulInfoLevel:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 372;
FUNCTION DosQueryDOSProperty(asgid:SGID;VAR pszName:CSTRING;cb:ULONG;VAR apch):APIRET;
                    APIENTRY;             'DOSCALLS' index 373;
FUNCTION DosSetDOSProperty(asgid:SGID;VAR pszName:CSTRING;cb:ULONG;pch:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 374;
// 375     Dos16QueryDosProperty
// 376     Dos16SetDosProperty
// 377     Dos32Profile
FUNCTION DosSetSignalExceptionFocus(flag:BOOL;VAR pulTimes:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 378;
FUNCTION DosSendSignalException(apid:PID;exception:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 379;
FUNCTION DosEnterMustComplete(VAR pulNesting:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 380;
FUNCTION DosExitMustComplete(VAR pulNesting:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 381;
FUNCTION DosSetRelMaxFH(VAR pcbReqCount:LONG;
                        VAR pcbCurMaxFH:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 382;
// 383     Dos16PutMessage
// 384     Dos16TrueGetMessage
// 385     Dos16InsMessage
// 386     Dos32InsertMessage
// 387     Dos32PutMessage
// 388     Dos32TrueGetMessage
// 389     DosIQueryMessageCP
// 390     Dos32IQueryMessageCP
// 391     Dos16CaseMap
// 392     Dos16GetCollate
// 393     Dos16GetCtryInfo
// 394     Dos16GetDBCSEv
// 395     Dos32QueryCtryInfo
// 396     Dos32QueryDBCSEnv
// 397     Dos32MapCase
// 398     Dos32QueryCollate
// 399     Dos16MakeNmPipe
// 400     Dos16QNmPipeInfo
// 401     Dos16ConnectNmPipe
// 402     Dos16DisconnectNmPipe
// 403     Dos16QNmPHandState
// 404     Dos16SetNmPHandState
// 405     Dos16PeekNmPipe
// 406     Dos16WaitNmPipe
// 407     Dos16TransactNmPipe
// 408     Dos16CallNmPipe
// 409     Dos16RawReadNmPipe
// 410     Dos16RawWriteNmPipe
// 411     Dos16SetNmPipeSem
// 412     Dos16QNmPipeSemState
// 413     StartLazyWriter
// 414     _QueInst_Data
FUNCTION DosShutdown(ulReserved:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 415;
// 416     Dos32ICacheModule
// 417     Dos32ReplaceModule
FUNCTION DosAcknowledgeSignalException(ulSignalNum:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 418;
// 419     Dos32TIB
// 420     Dos16TmrQueryFreq
// 421     Dos16TmrQueryTime
// 422     Dos16RegisterPerfCtrs
//procedure DosFlatToSel(var P: Pointer);
//                    APIENTRY;             'DOSCALLS' index 423;
//procedure DosSelToFlat(var P: Pointer);
//                    APIENTRY;             'DOSCALLS' index 424;

// Converts Selector:Offset (16:16) pointer to FLAT (0:32) form
procedure Dos32FlatToSel(var P: Pointer);
                    APIENTRY;             'DOSCALLS' index 425;
// Converts FLAT (0:32) pointer to Selector:Offset (16:16) form
procedure Dos32SelToFlat(var P: Pointer);
                    APIENTRY;             'DOSCALLS' index 426;
// 427     DosIODelayCnt
FUNCTION DosSetFileLocks(ahFile:HFILE;VAR pflUnlock,pflLock:FILELOCK;
                         timeout,flags:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 428;
FUNCTION DosCancelLockRequest(ahFile:HFILE;VAR pflLock:FILELOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 429;
// 430     LogOpen
// 431     LogClose
// 432     LogAddEntries
// 433     LogGetEntries
// 434     LogSetState
// 435     LogSetName
// 436     LogQueryState
// 437     Dos16OpenChangeNotify
// 438     Dos16ResetChangeNotify
// 439     Dos16CloseChangeNotify
// 440     Dos32OpenChangeNotify
// 441     Dos32ResetChangeNotify
// 442     Dos32CloseChangeNotify
// 443     Dos16QueryABIOSSupport
// 444     Dos32ForceSystemDump
// 447     Dos32GetProcessorStatus
// 448     Dos32SetProcessorStatus
// 449     Dos16CreateSpinLock
// 450     Dos16AcquireSpinLock
// 451     Dos16ReleaseSpinLock
// 452     Dos16FreeSpinLock
// 453     Dos32TestPSD
// 454     Dos32AllocThreadLocalMemory
// 455     Dos32FreeThreadLocalMemory
// 460     Dos32VerifyPIDTID
// 464     PTDA_LANMAN_SEC
// 465     PTDA_PID
// 466     SAS_SEL
// 467     TCB_OPCOOKIE
// 468     TCB_OPFLAGS
// 469     TCB_NEWFLAGS
// 470     TCB_USER_ID
// 471     TCB_PROC_ID
// 472     TCB_FSHARING
// 473     TCB_SRVATTRIB
// 474     TCB_ALLOWED
// 475     TCB_PRTCB
// 476     TCB_NUMBER
// 477     TCB_THISSFT
// 478     TCB_THISCDS
// 479     TKOPTDA
// 480     PTDA_CRITSEC
// 481     PTDA_HOLDSIGCNT
// 482     PTDA_PPTDAPARENT
// 483     PTDA_PGDATA
// 484     PTDA_HANDLE
// 485     PTDA_MODULE
// 486     PTDA_LDTHANDLE
// 487     PTDA_CODEPAGE_TAG
// 488     PTDA_JFN_LENGTH
// 489     PTDA_JFN_PTABLE
// 490     PTDA_JFN_FLG_PTR
// 491     PTDA_EXTERR_LOCUS
// 492     PTDA_EXTERR
// 493     PTDA_EXTERR_ACTION
// 494     PTDA_EXTERR_CLASS
// 495     PTDA_PPID
// 496     PTDA_PROCTYPE
// 497     PTDA_CURRTCB
// 498     PTDA_CURRTSD
// 499     PTDA_SIGNATURE
// 500     T32EXITLIST
// 501     T32ALLOCPROTECTEDMEM
// 502     T32ALIASMEM
// 503     T32ALLOCMEM
// 504     T32ALLOCSHAREDMEM
// 505     T32GETNAMEDSHAREDMEM
// 506     T32GETSHAREDMEM
// 507     T32GIVESHAREDMEM
// 508     T32FREEMEM
// 509     T32SETMEM
// 510     T32QUERYMEM
// 511     T32QUERYMEMSTATE
// 512     T32OPENVDD
// 513     T32REQUESTVDD
// 514     T32CLOSEVDD
// 515     T32CREATETHREAD
// 516     T32DYNAMICTRACE
// 517     T32DEBUG
// 518     T32QUERYPROCADDR
// 519     T32CREATEEVENTSEM
// 520     T32OPENEVENTSEM
// 521     T32CLOSEEVENTSEM
// 522     T32RESETEVENTSEM
// 523     T32POSTEVENTSEM
// 524     T32WAITEVENTSEM
// 525     T32QUERYEVENTSEM
// 526     T32CREATEMUTEXSEM
// 527     T32OPENMUTEXSEM
// 528     T32CLOSEMUTEXSEM
// 529     T32REQUESTMUTEXSEM
// 530     T32RELEASEMUTEXSEM
// 531     T32QUERYMUTEXSEM
// 532     T32CREATEMUXWAITSEM
// 533     T32OPENMUXWAITSEM
// 534     T32CLOSEMUXWAITSEM
// 535     T32WAITMUXWAITSEM
// 536     T32ADDMUXWAITSEM
// 537     T32DELETEMUXWAITSEM
// 538     T32QUERYMUXWAITSEM
// 539     T32QUERYSYSINFO
// 540     T32WAITTHREAD
// 541     DosIOpenL,                T32GETRESOURCE
// 542     DosIProtectOpenL,         T32FREERESOURCE
// 543     DosISetFileSizeL,         T32EXCEPTIONCALLBACK
// 544     DosIProtectSetFileSizeL,  T32QUERYPAGEUSAGE
// 545     Dos32ExceptionCallBack,
// 546     TI32ASYNCTIMER,           THK32STRLEN
// 547     TI32STARTTIMER,           THK_UNITHUNK
// 548     Dos32R3ExceptionDispatcher
// 549     DosLibiDisp
// 550     DosLibiDisp16
// 551     DosLibiDisp32
// 552     DosR3ExitAddr
// 553     Dos32R3ExitAddr
// 554     Dos32IRead
// 555     T32IREAD
// 556     Dos32IWrite
// 557     Dos32CreateSpinLock
// 557     T32IWRITE
// 558     Dos32AcquireSpinLock,     T32TMRQUERYFREQ
// 559     Dos32ReleaseSpinLock,     T32TMRQUERYTIME
// 560     Dos32FreeSpinLock,        T32ALIASPERFCTRS
// 561     Dos32PMR3WaitEventSem,    T32CONFIGUREPERF
// 562     Dos32PMR3PostEventSem,    T32DECONPERF
// 563     Dos32QueryThreadAffinity, T32REGISTERPERFCTRS
// 564     Dos32SetThreadAffinity,   T32QUERYSYSSTATE
// 565     DosISetFileInfo
// 566     DosISetPathInfo
// 567     DosOpenL,                 T32QUERYDOSPROPERTY
// 568     DosSetFilePtrL,           T32SETDOSPROPERTY
// 569     DosIFindNext
// 570     DosSetFileSizeL,          T32PROFILE
// 571     T32QUERYRESOURCESIZE
FUNCTION DosQueryResourceSize(hmod:HMODULE;idt,idn:ULONG;
                              VAR pulsize:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 572;
// 573     DosQueryResourceSize
// 574     T32SETSIGNALEXCEPTIONFOCUS, DosPMSemWait
// 575     T32SENDSIGNALEXCEPTION,     DosPMMuxSemWait
// 576     T32STARTTIMER,              THK16_UNITHUNK
// 577     T32STOPTIMER,               HT16_STARTUP
// 578     T32ASYNCTIMER,              HT16_CLEANUP
// 579     T32INITIALIZEPORTHOLE,      HT32_STARTUP
// 580     Dos32InitializePorthole,
// 581     T32QUERYHEADERINFO,         HT32_CLEANUP
// 582     Dos32QueryHeaderInfo
// 583     DosInitializePorthole
// 584     DosQueryHeaderInfo
// 585     T32QUERYPROCTYPE,            _Dos32IMonRead
FUNCTION DosQueryProcType(hmod:HMODULE;ordinal:ULONG;VAR pszName:CSTRING;
                          VAR pulproctype:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 586;
// 587     DosQueryProcType
// 588     T32IEXITMUSTCOMPLETE,       _Dos32IMonWrite
// 589     DosISigDispatch
// 590     T32ICACHEMODULE,            Dos32PMPostEventSem
// 591     T32DLLTERM,                 Dos32PMWaitEventSem
// 592     Dos32DllTermDisp
// 593     T32IRAISEEXCEPTION,         Dos32PMRequestMutexSem
// 594     Dos32IRaiseException
// 595     T32ACKNOWLEDGESIGNALEXC
// 595     Dos32PMWaitMuxWaitSem
// 596     Dos32PM16SemChk
// 597     Dos32IQueryFHState
// 598     Dos32ISetFHState
// 599     Dos32LDTSel
// 600     Dos32R3Frestor
// 601     DosIFindFirst
// 602     T32SETFILELOCKS
// 603     T32CANCELLOCKREQUEST
// 604     T32IMONREAD
// 605     T32IMONWRITE
// 606     DosMonOpen
// 607     DosMonClose
// 608     DosMonRead
// 609     DosMonWrite
// 610     DosMonReg
// 611     T32KILLTHREAD
// 612     TQUERYRASINFO
// 615     Dos32IProtectWrite
// 617     DosIProtectSetFileInfo
// 618     Dos32IProtectSetFileInfo
// 619     Dos32IProtectSetFHState
// 620     Dos32IProtectQueryFHState
FUNCTION DosProtectSetFilePtr(ahFile:HFILE;ib:LONG;method:ULONG;
                              VAR ibActual:ULONG;
                              fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 621;
// 622     Dos16ProtectClose
// 623     Dos16ProtectFileIO
// 624     Dos16ProtectFileLocks
// 625     DosIProtectRead
// 626     DosIProtectWrite
// 627     Dos16ProtectNewSize
// 628     Dos16ProtectOpen
// 629     Dos16ProtectQFHandState
// 630     Dos16ProtectSetFHandState
// 631     Dos16ProtectQFileInfo
// 632     Dos16ProtectSetFileInfo
// 634     Dos16ProtectChgFilePtr
// 635     Dos16ProtectEnumAttribute
FUNCTION DosProtectEnumAttribute(ulRefType:ULONG;VAR pvFile;
                                 ulEntry:ULONG;VAR pvBuf;cbBuf:ULONG;
                                 VAR pulCount:ULONG;ulInfoLevel:ULONG;
                                 fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 636;
FUNCTION DosProtectOpen(pszFileName:CSTRING;VAR phf:HFILE;VAR pulAction:ULONG;
                        cbFile,ulAttribute,fsOpenFlags,fsOpenMode:ULONG;
                        VAR apeaop2:EAOP2;
                        VAR pfhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 637;
FUNCTION DosProtectClose(ahFile:HFILE;fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 638;
FUNCTION DosProtectSetFileLocks(ahFile:HFILE;VAR pflUnlock,pflLock:FILELOCK;
                                timeout,flags:ULONG;
                                fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 639;
FUNCTION DosProtectSetFileSize(ahFile:HFILE;cbSize:ULONG;
                               fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 640;
FUNCTION DosProtectRead(ahFile:HFILE;VAR pBuffer;cbRead:ULONG;
                        VAR pcbActual:ULONG;fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 641;
FUNCTION DosProtectWrite(ahFile:HFILE;VAR pBuffer;cbWrite:ULONG;
                         VAR pcbActual:ULONG;
                         fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 642;
FUNCTION DosProtectSetFileInfo(hf:HFILE;ulInfoLevel:ULONG;VAR pInfoBuf;
                               cbInfoBuf:ULONG;
                               fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 643;
FUNCTION DosProtectSetFHState(ahFile:HFILE;mode:ULONG;
                              fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 644;
FUNCTION DosProtectQueryFHState(ahFile:HFILE;VAR pMode:ULONG;
                                fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 645;
FUNCTION DosProtectQueryFileInfo(hf:HFILE;ulInfoLevel:ULONG;
                                 VAR pInfo;cbInfoBuf:ULONG;
                                 fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 646;
// 645     Dos32ProtectQueryFHState
// 646     Dos32ProtectQueryFileInfo
// 647     Dos32IProtectRead
// 649     DosCloseMessageFile
// 650     DosLDRDirtyWorker
// 651     Dos16LDRDirtyWorker
// 652     Dos32IGetInfoBlocks
// 653     T32IGETINFOBLOCKS
// 656     T32GETPROCESSORSTATUS
// 657     T32SETPROCESSORSTATUS
// 658     T32TESTPSD
// 659     T32QUERYTHREADAFFINITY
// 660     T32SETTHREADAFFINITY
// 661     Dos32ReadQueue
// 662     Dos32PurgeQueue
// 663     Dos32CloseQueue
// 664     Dos32QueryQueue
// 665     Dos32PeekQueue
// 666     Dos32WriteQueue
// 667     Dos32OpenQueue
// 668     Dos32CreateQueue
// 669     Dos32StartSession
// 670     Dos32SelectSession
// 671     Dos32SetSession
// 672     Dos32StopSession
// 673     DosRegisterNotification
// 674     Dos16ReadQueue
// 675     Dos16PurgeQueue
// 676     Dos16CloseQueue
// 677     Dos16QueryQueue
// 678     Dos16PeekQueue
// 679     Dos16WriteQueue
// 680     Dos16OpenQueue
// 681     Dos16CreateQueue
// 682     Dos16SMGetmem
// 683     Dos16SMFreemem
// 684     Dos16SMGetSGCB
// 685     Dos16SMInitSGCB
// 686     Dos16SMSGDoPopup
// 687     Dos16SMSwitch
// 688     Dos16SMServeAppReq
// 689     Dos16GetTimes
// 690     Dos16SMSetTitle
// 691     Dos16ScrUnlock
// 692     Dos16SMDoAppReq
// 693     Dos16StopSession
// 694     Dos16SelectSession
// 695     Dos16ScrLock
// 696     Dos16SavRedrawWait
// 697     Dos16SavRedrawUndo
// 698     Dos16SMSGEndPopup
// 699     Dos16SetSession
// 700     Dos16SetMNLockTime
// 701     Dos16ModeUndo
// 702     Dos16StartSession
// 703     Dos16SMGetStatus
// 704     Dos16ModeWait
// 705     Dos16SMTerminate
// 706     Dos16SMGetAppReq
// 707     Dos16SMInitialize
// 708     Dos16SMStart
// 709     Dos16SMParentSwitch
// 710     Dos16SMPause
// 711     Dos16SMHDeinit
// 712     Dos16SMPMPresent
// 713     Dos16SMRegisterDD
// 714     Dos16SMNotifyDD
// 715     Dos16SMNotifyDD2
// 716     Dos16SMOpenDD
// 717     Dos16SMSetSessionType
// 718     OS2BaseInit
// 719     MouGetPtrShape
// 720     MouSetPtrShape
// 721     MouGetNumMickeys
// 722     MouGetThreshold
// 723     MouShellInit
// 724     MouGetScaleFact
// 725     MouFlushQue
// 726     MouGetNumButtons
// 727     MouClose
// 728     MouSetThreshold
// 729     MouSetScaleFact
// 730     MouGetNumQueEl
// 731     MouDeRegister
// 732     MouGetEventMask
// 733     MouSetEventMask
// 734     MouOpen
// 735     MouRemovePtr
// 736     MouGetPtrPos
// 737     MouReadEventQue
// 738     MouSetPtrPos
// 739     MouGetDevStatus
// 740     MouSynch
// 741     MouRegister
// 742     MouSetDevStatus
// 743     MouDrawPtr
// 744     MouInitReal
// 745     KbdSetCustXt
// 746     KbdInit
// 747     KbdGetCp
// 748     KbdCharIn
// 749     KbdSetCp
// 750     KbdLoadInstance
// 751     KbdSynch
// 752     KbdRegister
// 753     KbdStringIn
// 754     KbdGetStatus
// 755     KbdSetStatus
// 756     KbdGetFocus
// 757     KbdFlushBuffer
// 758     KbdXlate
// 759     KbdSwitchFgnd
// 760     KbdShellInit
// 761     KbdClose
// 762     KbdFreeFocus
// 763     KbdFree
// 764     KbdDeRegister
// 765     KbdSetFgnd
// 766     KbdPeek
// 767     KbdOpen
// 768     KbdGetHWId
// 769     KbdSetHWId
// 770     VioEndPopup
// 771     VioGetPhysBuf
// 772     VioGetAnsi
// 773     VioFree
// 774     VioSetAnsi
// 775     VioDeRegister
// 776     VioScrollUp
// 777     VioPrtSc
// 778     VioGetCurPos
// 779     VioWrtCellStr
// 780     VioPopUp
// 781     VioScrollRt
// 782     VioWrtCharStr
// 783     Avs_Prtsc
// 784     VioSetCurPos
// 785     VioSrfUnblock
// 786     VioSrfBlock
// 787     VioScrUnlock
// 788     VioWrtTty
// 789     VioSave
// 790     VioGetMode
// 791     VioSetMode
// 792     VioScrLock
// 793     VioReadCellStr
// 794     VioSavRedrawWait
// 795     VioWrtNAttr
// 796     VioGetCurType
// 797     VioSavRedrawUndo
// 798     VioGetFont
// 799     VioReadCharStr
// 800     VioGetBuf
// 801     VioSetCurType
// 802     VioSetFont
// 803     VioHetInit
// 804     VioModeUndo
// 805     VioSswSwitch
// 806     VioModeWait
// 807     Avs_PrtscToggle
// 808     VioGetCp
// 809     VioRestore
// 810     VioSetCp
// 811     VioShowBuf
// 812     VioScrollLf
// 813     VioRegister
// 814     VioGetConfig
// 815     VioScrollDn
// 816     VioWrtCharStrAtt
// 817     VioGetState
// 818     VioPrtScToggle
// 819     VioSetState
// 820     VioWrtNCell
// 821     VioWrtNChar
// 822     VioShellInit
// 823     VioAssociate
// 824     VioCreatePS
// 825     VioDeleteSetId
// 826     VioGetDeviceCellSize
// 827     VioGetOrg
// 828     VioCreateLogFont
// 829     VioDestroyPS
// 830     VioQuerySetIds
// 831     VioSetOrg
// 832     VioQueryFonts
// 833     VioSetDeviceCellSize
// 834     VioShowPS
// 835     VioGetPSAddress
// 836     VioQueryConsole
// 837     VioRedrawSize
// 838     VioGlobalReg
// 839     XVioSetCAState
// 840     XVioCheckCharType
// 841     XVioDestroyCA
// 842     XVioCreateCA
// 843     VioCheckCharType
// 844     XVioGetCAState
// 845     BVSMAIN
// 846     BVSREDRAWSIZE
// 847     BVSGETPTRDRAWNAME
// 848     AnsiInject
// 849     AnsiKeydef
// 850     AnsiInterp
// 851     BKSMAIN
// 852     BMSMAIN
// 853     MouGetHotKey
// 854     MouSetHotKey
// 855     Dos16SMSysInit
// 856     QhKeybdHandle
// 857     QhMouseHandle
// 858     SMQueueRamSem
// 859     SMArray
// 860     SMPIDArray
// 861     SMInitialized
// 862     SMArraySize
// 863     BVSGLOBAL
// 864     SMGINSTANCE
// 865     BVHINSTANCE
// 866     THK32ALIASMEM
// 867     THK32FREEALIAS
// 868     THK32ALLOCVARLEN
// 869     THK32HANDLEBOUNDARY
// 870     THK32HANDLESTRING
// 871     THK32DEALLOC
// 872     THK32XHNDLR
FUNCTION DosSetExtLIBPATH(pszExtLIBPATH : cString; flags : ULONG) : APIRET;
                    APIENTRY;             'DOSCALLS' index 873;
FUNCTION DosQueryExtLIBPATH(VAR pszExtLIBPATH : cString; flags : ULONG) : APIRET;
                    APIENTRY;             'DOSCALLS' index 874;
// 875     Dos32PM16SemRst
// 876     Dos32SysCtl
// 877     Dos32QueryThreadContext
// 878     DosSGQueryTopmost
// 976     Dos32PerfSysCall
// 981     Dos32OpenL
// 982     Dos32ProtectOpenL
// 983     Dos32ProtectSetFileLocksL
// 984     Dos32ProtectSetFilePtrL
// 985     Dos32ProtectSetFileSizeL
// 986     Dos32SetFileLocksL
// 987     Dos32CancelLockRequestL
// 988     Dos32SetFilePtrL
// 989     Dos32SetFileSizeL
// 990     Dos32ListIOL
// 991     Dos16FSRamSemRequest2
// 992     Dos16FSRamSemClear2
// 995     Dos32SystemService
// 996     Dos32ListIO
// 997     Dos32CreateThread2
// 998     Dos16SetExtLIBPATH
// 999     Dos16QueryExtLIBPATH
// 1000-1117 T32-APIs
// 9004    Dos32CreateRamSem
// 9005    Dos32CloseRamSem
// 9006    Dos32OpenRamSem
// 9007    Dos32RequestRamSem
// 9008    Dos32ReleaseRamSem
// 9010    Dos32QueryProcessInfo
// 9011    Dos32QueryThreadInfo
// 9018    Dos32FindFromName

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ DLL: SESMGR                                                               บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

// 1       DosSMSGDoPopup
// 2       DosSMSwitch
// 3       DosSMServeAppReq
// 4       DosGetTimes
// 5       DosSMSetTitle
// 6       DosScrUnlock
// 7       DosSMDoAppReq
// 8       DosStopSession
// 9       DosSelectSession
// 10      DosScrLock
// 11      DosSavRedrawWait
// 12      DosSavRedrawUndo
// 13      DosSMSGEndPopup
// 14      DosSetSession
// 15      DosSetMNLockTime
// 16      DosModeUndo
// 17      DosStartSession
// 18      DosSMGetStatus
// 19      DosModeWait
// 20      DosSMTerminate
// 21      DosSMGetAppReq
// 22      DosSMRealPrtSc
// 23      DosSMInitialize
// 24      DosSMStart
// 25      DosSMParentSwitch
// 26      DosSMPause
// 27      DosSMHDEInit
// 28      DosSMPMPresent
// 29      DosSMRegisterDD
// 30      DosSMSysInit
// 31      DosSMNotifyDD
// 32      DosSMNotifyDD2
// 33      DosSMOpenDD
// 34      QhKeybdHandle
// 35      QhMouseHandle
// 36      DosSMSetSessionType
FUNCTION DosStartSession(VAR psd:STARTDATA;VAR pidSession:ULONG;
                         VAR appid:PID):APIRET;
                    APIENTRY;             'SESMGR' index 37;
FUNCTION DosSelectSessionAPI(idSession:ULONG):APIRET;
                    APIENTRY;             'SESMGR' index 38;
FUNCTION DosSetSession(idSession:ULONG;VAR psd:STATUSDATA):APIRET;
                    APIENTRY;             'SESMGR' index 39;
FUNCTION DosStopSession(scope,idSession:ULONG):APIRET;
                    APIENTRY;             'SESMGR' index 40;
// 41      DosRegisterNotification


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ DLL: MSG                                                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

// 1       DosPutMessage
// 2       DosTrueGetMessage
// 3       DosInsMessage
FUNCTION DosInsertMessage(VAR pTable;cTable:ULONG;VAR pszMsg:CSTRING;cbMsg:ULONG;
                          VAR pBuf;cbBuf:ULONG;VAR pcbMsg:ULONG):APIRET;
                    APIENTRY;             'MSG' index 4;
FUNCTION DosPutMessage(ahfile:HFILE;cbMsg:ULONG;VAR pBuf):APIRET;
                    APIENTRY;             'MSG' index 5;
// 6       Dos32TrueGetMessage
// 7       DosIQueryMessageCP
// 8       Dos32IQueryMessageCP
// 9       DosCloseMessageFile


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Queue - Manager: QUECALLS.DLL                                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

// 1       DosReadQueue
// 2       DosPurgeQueue
// 3       DosCloseQueue
// 4       DosQueryQueue
// 5       DosPeekQueue
// 6       DosWriteQueue
// 7       DosOpenQueue
// 8       DosCreateQueue
FUNCTION DosReadQueue(hq:HQUEUE;VAR pRequest:REQUESTDATA;VAR pcbData:ULONG;
                      VAR ppbuf;element:ULONG;wait:BOOL;
                      VAR ppriority;hsem:HEV):APIRET;
                    APIENTRY;             'QUECALLS' index 9;
FUNCTION DosPurgeQueue(hq:HQUEUE):APIRET;
                    APIENTRY;             'QUECALLS' index 10;
FUNCTION DosCloseQueue(hq:HQUEUE):APIRET;
                    APIENTRY;             'QUECALLS' index 11;
FUNCTION DosQueryQueue(hq:HQUEUE;VAR pcbEntries:ULONG):APIRET;
                    APIENTRY;             'QUECALLS' index 12;
FUNCTION DosPeekQueue(hq:HQUEUE;VAR pRequest:REQUESTDATA;VAR pcbData:ULONG;
                      VAR ppbuf;VAR element:ULONG;nowait:BOOL;
                      VAR ppriority;hsem:HEV):APIRET;
                    APIENTRY;             'QUECALLS' index 13;
FUNCTION DosWriteQueue(hq:HQUEUE;request,cbData:ULONG;VAR pbData;
                       priority:ULONG):APIRET;
                    APIENTRY;             'QUECALLS' index 14;
FUNCTION DosOpenQueue(VAR appid:PID;VAR phq:HQUEUE;VAR pszName:CSTRING):APIRET;
                    APIENTRY;             'QUECALLS' index 15;
FUNCTION DosCreateQueue(VAR phq:HQUEUE;priority:ULONG;VAR pszName:CSTRING):APIRET;
                    APIENTRY;             'QUECALLS' index 16;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ National Language: NLS.DLL                                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

// 1       DosCaseMap
// 2       DosGetCollate
// 3       DosGetCtryInfo
// 4       DosGetDBCSEv
FUNCTION DosQueryCtryInfo(cb:ULONG;VAR pcc:COUNTRYCODE;VAR pci:COUNTRYINFO;
                          VAR pcbActual:ULONG):APIRET;
                    APIENTRY;             'NLS' index 5;
FUNCTION DosQueryDBCSEnv(cb:ULONG;VAR pcc:COUNTRYCODE;
                         VAR pBuf):APIRET;
                    APIENTRY;             'NLS' index 6;
FUNCTION DosMapCase(cb:ULONG;VAR pcc:COUNTRYCODE;VAR apch):APIRET;
                    APIENTRY;             'NLS' index 7;
FUNCTION DosQueryCollate(cb:ULONG;VAR pcc:COUNTRYCODE;
                         VAR apch;VAR pcch:ULONG):APIRET;
                    APIENTRY;             'NLS' index 8;

END; {IMPORTS}


{OS/2 API errors ??}

{exception instance is deleted if pBuf crosses 64K boundary}
FUNCTION DosQueryCurrentDir(disknum:LONGWORD;VAR pBuf;
                            VAR pcbBuf:LONGWORD):LONGWORD;

{ds and es are zeroed under some circumstances}
FUNCTION DosSelectSession(idSession:ULONG):APIRET;

{additional parameter required in redirected function}
FUNCTION DosQueryMessageCP(VAR pb;cb:ULONG;VAR pszFilename:CSTRING;
                           VAR cbBuf:ULONG):APIRET;

{additional parameter required in redirected function}
FUNCTION DosGetMessage(VAR pTable;cTable:ULONG; VAR pBuf;cbBuf,msgnumber:ULONG;
                       CONST pszFile:CSTRING;VAR pcbMsg:ULONG):APIRET;


IMPLEMENTATION


FUNCTION DosQueryCurrentDir(disknum:LONGWORD;VAR pBuf;
                            VAR pcbBuf:LONGWORD):LONGWORD;
BEGIN
     //a bug in OS/2 ??
     //exception instance is deleted if pBuf crosses 64K boundary
     ASM
        XOR EAX,EAX
        DB $64,$FF,$30  //PUSHD FS:[EAX]
     END;
     Result := DosQueryCurrentDirAPI(disknum,pBuf,pcbBuf);
     ASM
        XOR EAX,EAX
        DB $64,$8F,$00  //POPD FS:[EAX]
     END;
END;


FUNCTION DosSelectSession(idSession:ULONG):APIRET;
BEGIN
     //a bug in OS/2 ???
     //DS and ES are sometimes set to 0 selectors !
     ASM
        DB $1E,06   //PUSH DS PUSH ES
     END;
     Result := DosSelectSessionAPI(idSession);
     ASM
        DB 07,$1F   //POP ES POP DS
     END;
END;




IMPORTS

FUNCTION DosIQueryMessageCP(VAR pb;cb:ULONG;VAR pszFilename:CSTRING;
                            VAR cbBuf:ULONG;Signature:POINTER):APIRET;
                    APIENTRY;             'MSG' index 8;
FUNCTION DosTrueGetMessage(Signature:POINTER;VAR pTable;cTable:ULONG;
                           VAR pBuf;cbBuf,msgnumber:ULONG;
                           CONST pszFile:CSTRING;VAR pcbMsg:ULONG):APIRET;
                    APIENTRY;             'MSG' index 6;

END; {IMPORTS}

VAR
    MagicHeaderAddress:POINTER;
    MagicEndAddress:POINTER;

{start of _MSGSEG32 segment}
ASSEMBLER
BseDos.!MagicHeaderStart PROC NEAR32
   DB $0FF
   DB $4D,$53,$47,$53,$45,$47,$33,$32, 0       //'MSGSEG32'
   DD $8001
   DD @BseDos.!MAGICHEADEREND
BseDos.!MagicHeaderStart ENDP
END;

FUNCTION DosGetMessage(VAR pTable;cTable:ULONG; VAR pBuf;cbBuf,msgnumber:ULONG;
                       CONST pszFile:CSTRING;VAR pcbMsg:ULONG):APIRET;
BEGIN
     Result := DosTrueGetMessage(MagicHeaderAddress,pTable,cTable,
                                 pBuf,cbBuf,msgnumber,pszFile,pcbMsg);
END;


FUNCTION DosQueryMessageCP(VAR pb;cb:ULONG;VAR pszFilename:CSTRING;
                           VAR cbBuf:ULONG):APIRET;
BEGIN
     Result := DosIQueryMessageCP(pb,cb,pszFileName,cbBuf,MagicEndAddress);
END;

ASSEMBLER
BseDos.!MagicHeaderEnd PROC NEAR32
   DD $0FFFF0000
BseDos.!MagicHeaderEnd ENDP
END;

BEGIN
     ASM
        MOV EAX,@BseDos.!MagicHeaderStart
        MOV BseDos.MagicHeaderAddress,EAX
        MOV EAX,@BseDos.!MagicHeaderEnd
        MOV BseDos.MagicEndAddress,EAX
     END;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  03-Nov-06  WD, RB     Funktion DosQuerySysState eingebaut
  19-Nov-07  WD         Flag OBJ_ANY eingebaut.
  22-Aug-07  WD         DosSearchPath: Umbau auf AnsiString
  15-Jun-08  WD         Funktion DosQueryExtLIBPATH und DosSetExtLIBPATH eingebaut.
}
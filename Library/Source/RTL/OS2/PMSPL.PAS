
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for OS/2                                        บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT PMSpl;

{****************************************************************************
 *                                                                          *
 * OS/2 Presentation Manager Spooler constants, types and function          *
 * declarations                                                             *
 *                                                                          *
 ****************************************************************************}

INTERFACE

USES OS2Def,BseDos;

CONST
     SPL_INI_SPOOLER       = 'PM_SPOOLER';
     SPL_INI_QUEUE         = 'PM_SPOOLER_QUEUE';
     SPL_INI_PRINTER       = 'PM_SPOOLER_PRINTER';
     SPL_INI_PRINTERDESCR  = 'PM_SPOOLER_PRINTER_DESCR';
     SPL_INI_QUEUEDESCR    = 'PM_SPOOLER_QUEUE_DESCR';
     SPL_INI_QUEUEDD       = 'PM_SPOOLER_QUEUE_DD';
     SPL_INI_QUEUEDDDATA   = 'PM_SPOOLER_QUEUE_DDDATA';

   /*** General SPL return values ******************************************/
     SPL_ERROR   = 0;
     SPL_OK      = 1;

   /*** handle to a spool file *********************************************/
TYPE
   HSPL=ULONG;               /* hspl */

   /* Used in recording of PM_Q_STD data via SplStdxxx calls */
   HSTD=ULONG;               /* hstd */
   PHSTD=^HSTD;

   /*** spooler manager open data ******************************************/
   QMOPENDATA=CSTRING;
   PQMOPENDATA=^CSTRING;       /* pqmdop */


   /*** Spooler Queue Processor interface **********************************/

CONST
   /* control codes for SplQpControl */
     SPLC_ABORT    =  1;
     SPLC_PAUSE    =  2;
     SPLC_CONTINUE =  3;

   /* flag defines for optional SplQpQueryFlags           */
   /* set this to allow spooler to bypass Queue Processor */
   /* for PM_Q_RAW jobs.  This allows print while a job   */
   /* is still spooling.                                  */
     QP_RAWDATA_BYPASS = $00000001;

   /*** handle to a spooler queue processor ********************************/
TYPE
   HPROC=ULONG;              /* hproc */


   /*** spooler processor open data ****************************************/
   PQPOPENDATA=^CSTRING;       /* pqpdop */


   /*** Definition for elements within the PQPOPENDATA block ***************/
CONST
     QPDAT_ADDRESS     =0;
     QPDAT_DRIVER_NAME =1;
     QPDAT_DRIVER_DATA =2;
     QPDAT_DATA_TYPE   =3;
     QPDAT_COMMENT     =4;
     QPDAT_PROC_PARAMS =5;
     QPDAT_SPL_PARAMS  =6;      /* SplQmOpen Spooler params **       */
     QPDAT_NET_PARAMS  =7;      /* SplQmOpen Network params **       */
     QPDAT_DOC_NAME    =8;      /* SplQmStartDoc name       **       */
     QPDAT_QUEUE_NAME  =9;      /* Queue name for job       **       */
     QPDAT_TOKEN       =10;      /* SplQmOpen token name     **       */
     QPDAT_JOBID       =11;      /* SQM job identity         **       */

TYPE
   SQPOPENDATA=RECORD       /* SplQpOpenData */
      pszLogAddress:PChar;     /*                                   */
      pszDriverName:PChar;     /*                                   */
      pdriv:PDRIVDATA;         /*                                   */
      pszDataType:PChar;       /*                                   */
      pszComment:PChar;        /*                                   */
      pszProcParams:PChar;     /*                                   */
      pszSpoolParams:PChar;    /*                                   */
      pszNetworkParams:PChar;  /*                                   */
      pszDocName:PChar;        /*                                   */
      pszQueueName:PChar;      /*                                   */
      pszToken:PChar;          /*                                   */
      idJobId:USHORT;          /*                                   */
   END;
   PSQPOPENDATA=^SQPOPENDATA; /* ptr to SQPOPENDATA */


   /*************************************************************************
   *** Error information and return codes
   *************************************************************************/

   /* Error information for SplMessageBox */
CONST
     SPLINFO_QPERROR     =  $0001;
     SPLINFO_DDERROR     =  $0002;
     SPLINFO_SPLERROR    =  $0004;
     SPLINFO_OTHERERROR  =  $0080;
     SPLINFO_INFORMATION =  $0100;
     SPLINFO_WARNING     =  $0200;
     SPLINFO_ERROR       =  $0400;
     SPLINFO_SEVERE      =  $0800;
     SPLINFO_USERINTREQD =  $1000;

   /* Error Data for SplMessageBox */
     SPLDATA_PRINTERJAM   = $0001;
     SPLDATA_FORMCHGREQD  = $0002;
     SPLDATA_CARTCHGREQD  = $0004;
     SPLDATA_PENCHGREQD   = $0008;
     SPLDATA_DATAERROR    = $0010;
     SPLDATA_UNEXPECTERROR= $0020;
     SPLDATA_OTHER        = $8000;

   /* return code for fSplStdQueryLength */
     SSQL_ERROR = -1;

TYPE
    SPLERR=ULONG;

      /* length for character arrays in structs (excluding zero terminator) */
CONST
        CNLEN         = 15;            /* Computer name length      */
        UNLEN         = 20;            /* Maximum user name length  */
        QNLEN         = 12;            /* Queue name maximum length */
        PDLEN         =  8;            /* Print destination length  */
        DTLEN         =  9;            /* Spool file data type      */
      /* e.g. PM_Q_STD,PM_Q_RAW    */
        QP_DATATYPE_SIZE      = 15;    /* returned by SplQpQueryDt  */
        DRIV_DEVICENAME_SIZE  = 31;    /* see DRIVDATA struc        */
        DRIV_NAME_SIZE        =  8;    /* name of device driver     */
        PRINTERNAME_SIZE      = 32;    /* max printer name length   */
        FORMNAME_SIZE         = 31;    /* max form name length      */
        MAXCOMMENTSZ          = 48;    /* queue comment length      */

TYPE
      DRIVPROPS=RECORD      /* dprop */
         pszKeyName:PChar;
         cbBuf:ULONG;
         pBuf:POINTER;
      END;
      PDRIVPROPS=^DRIVPROPS;
      NPDRIVPROPS=^DRIVPROPS;

      PRJINFO=RECORD      /* prj1 */
         uJobId:USHORT;
         szUserName:CSTRING[UNLEN];
         pad_1:CHAR;
         szNotifyName:CSTRING[CNLEN];
         szDataType:CSTRING[DTLEN];
         pszParms:PChar;
         uPosition:USHORT;
         fsStatus:USHORT;
         pszStatus:PChar;
         ulSubmitted:ULONG;
         ulSize:ULONG;
         pszComment:PChar;
      END;
      PPRJINFO=^PRJINFO;
      NPPRJINFO=^PRJINFO;

      PRJINFO2=RECORD      /* prj2 */
         uJobId:USHORT;
         uPriority:USHORT;
         pszUserName:PChar;
         uPosition:USHORT;
         fsStatus:USHORT;
         ulSubmitted:ULONG;
         ulSize:ULONG;
         pszComment:PChar;
         pszDocument:PChar;
      END;
      PPRJINFO2=^PRJINFO2;
      NPPRJINFO2=^PRJINFO2;

      PRJINFO3=RECORD      /* prj */
         uJobId:USHORT;
         uPriority:USHORT;
         pszUserName:PChar;
         uPosition:USHORT;
         fsStatus:USHORT;
         ulSubmitted:ULONG;
         ulSize:ULONG;
         pszComment:PChar;
         pszDocument:PChar;
         pszNotifyName:PChar;
         pszDataType:PChar;
         pszParms:PChar;
         pszStatus:PChar;
         pszQueue:PChar;
         pszQProcName:PChar;
         pszQProcParms:PChar;
         pszDriverName:PChar;
         pDriverData:PDRIVDATA;
         pszPrinterName:PChar;
      END;
      PPRJINFO3=^PRJINFO3;
      NPPRJINFO3=^PRJINFO3;

      PRDINFO=RECORD       /* prd1 */
         szName:CSTRING[PDLEN];
         szUserName:CSTRING[UNLEN];
         uJobId:USHORT;
         fsStatus:USHORT;
         pszStatus:PChar;
         time:USHORT;
      END;
      PPRDINFO=^PRDINFO;
      NPPRDINFO=^PRDINFO;

      PRDINFO3=RECORD      /* prd */
         pszPrinterName:PChar;
         pszUserName:PChar;
         pszLogAddr:PChar;
         uJobId:USHORT;
         fsStatus:USHORT;
         pszStatus:PChar;
         pszComment:PChar;
         pszDrivers:PChar;
         time:USHORT;
         usTimeOut:USHORT;
      END;
      PPRDINFO3=^PRDINFO3;
      NPPRDINFO3=^PRDINFO3;

      PRQINFO=RECORD      /* prq1 */
         szName:CSTRING[QNLEN];
         pad_1:CHAR;
         uPriority:USHORT;
         uStartTime:USHORT;
         uUntilTime:USHORT;
         pszSepFile:PChar;
         pszPrProc:PChar;
         pszDestinations:PChar;
         pszParms:PChar;
         pszComment:PChar;
         fsStatus:USHORT;
         cJobs:USHORT;
      END;
      PPRQINFO=^PRQINFO;
      NPPRQINFO=^PRQINFO;

      PRQINFO3=RECORD     /* prq */
         pszName:PChar;
         uPriority:USHORT;
         uStartTime:USHORT;
         uUntilTime:USHORT;
         fsType:USHORT;
         pszSepFile:PChar;
         pszPrProc:PChar;
         pszParms:PChar;
         pszComment:PChar;
         fsStatus:USHORT;
         cJobs:USHORT;
         pszPrinters:PChar;
         pszDriverName:PChar;
         pDriverData:PDRIVDATA;
      END;
      PPRQINFO3=^PRQINFO3;
      NPPRQINFO3=^PRQINFO3;

      PRQINFO6=RECORD     /* prq6 */
         pszName:PChar;
         uPriority:USHORT;
         uStartTime:USHORT;
         uUntilTime:USHORT;
         fsType:USHORT;
         pszSepFile:PChar;
         pszPrProc:PChar;
         pszParms:PChar;
         pszComment:PChar;
         fsStatus:USHORT;
         cJobs:USHORT;
         pszPrinters:PChar;
         pszDriverName:PChar;
         pDriverData:PDRIVDATA;
         pszRemoteComputerName:PChar;
         pszRemoteQueueName:PChar;
      END;
      PPRQINFO6=^PRQINFO6;
      NPPRQINFO6=^PRQINFO6;

      /*
      * structure for DosPrintJobGetId
      */
      PRIDINFO=RECORD     /* prjid */
         uJobId:USHORT;
         szComputerName:CSTRING[CNLEN];
         szQueueName:CSTRING[QNLEN];
         pad_1:CHAR;
      END;
      PPRIDINFO=^PRIDINFO;
      NPPRIDINFO=^PRIDINFO;

      /*
      * structure for DosPrintDriverEnum
      */
      PRDRIVINFO=RECORD    /* prdid */
         szDrivName:CSTRING[DRIV_NAME_SIZE+1+DRIV_DEVICENAME_SIZE];
      END;
      PPRDRIVINFO=^PRDRIVINFO;
      NPPRDRIVINFO=^PRDRIVINFO;

      /*
      * structure for DosPrintQProcessorEnum
      */
      PRQPROCINFO=RECORD    /* prqp */
         szQProcName:CSTRING[QNLEN];
      END;
      PPRQPROCINFO=^PRQPROCINFO;
      NPPRQPROCINFO=^PRQPROCINFO;

      /*
      * structure for DosPrintPortEnum Level 0
      */
      PRPORTINFO=RECORD    /* prpo */
         szPortName:CSTRING[PDLEN];
      END;
      PPRPORTINFO=^PRPORTINFO;
      NPPRPORTINFO=^PRPORTINFO;

      /*
      * structure for DosPrintPortEnum Level 1
      */
      PRPORTINFO1=RECORD    /* prpo1 */
         pszPortName :PChar;
         pszPortDriverName :PChar;
         pszPortDriverPathName :PChar;
      END;
      PPRPORTINFO1=^PRPORTINFO1;
      NPPRPORTINFO1=^PRPORTINFO1;


      /*** Values for parmnum in DosPrintQSetInfo/SplSetQueue  *************/
CONST
        PRQ_PRIORITY_PARMNUM        =    2;
        PRQ_STARTTIME_PARMNUM       =    3;
        PRQ_UNTILTIME_PARMNUM       =    4;
        PRQ_SEPARATOR_PARMNUM       =    5;
        PRQ_PROCESSOR_PARMNUM       =    6;
        PRQ_DESTINATIONS_PARMNUM    =    7;
        PRQ_PARMS_PARMNUM           =    8;
        PRQ_COMMENT_PARMNUM         =    9;
        PRQ_TYPE_PARMNUM            =   10;
        PRQ_PRINTERS_PARMNUM        =   12;
        PRQ_DRIVERNAME_PARMNUM      =   13;
        PRQ_DRIVERDATA_PARMNUM      =   14;
        PRQ_REMOTE_COMPUTER_PARMNUM =   15;
        PRQ_REMOTE_QUEUE_PARMNUM    =   16;
        PRQ_MAXPARMNUM              =   16;

      /*** Print Queue Priority ********************************************/
        PRQ_MAX_PRIORITY            =    1;        /* highest priority */
        PRQ_DEF_PRIORITY            =    5;
        PRQ_MIN_PRIORITY            =    9;        /* lowest priority  */
        PRQ_NO_PRIORITY             =    0;

      /*** Print queue status bitmask and values for level 1 ***************/
        PRQ_STATUS_MASK             =    3;
        PRQ_ACTIVE                  =    0;
        PRQ_PAUSED                  =    1;        /* queue is held    */
        PRQ_ERROR                   =    2;
        PRQ_PENDING                 =    3;       /* pending deletion */

      /*** Print queue status bits for level 3 *****************************/
        PRQ3_PAUSED                 =  $1;        /* queue is held    */
        PRQ3_PENDING                =  $2;        /* pending deletion */

      /*** Print queue type bits for level 3 *******************************/
        PRQ3_TYPE_RAW       =  $0001; /* spools printer-specific data */
        PRQ3_TYPE_BYPASS    =  $0002; /* allow print while spooling   */
        PRQ3_TYPE_APPDEFAULT=  $0004; /* set for Application default Q*/

      /*** Values for parmnum in DosPrintJobSetInfo/SplSetJob **************/
        PRJ_NOTIFYNAME_PARMNUM     =   3;
        PRJ_DATATYPE_PARMNUM       =   4;
        PRJ_PARMS_PARMNUM          =   5;
        PRJ_POSITION_PARMNUM       =   6;
        PRJ_JOBFILEINUSE_PARMNUM   =   7;
        PRJ_COMMENT_PARMNUM        =  11;
        PRJ_DOCUMENT_PARMNUM       =  12;
        PRJ_STATUSCOMMENT_PARMNUM  =  13;
        PRJ_PRIORITY_PARMNUM       =  14;
        PRJ_PROCPARMS_PARMNUM      =  16;
        PRJ_DRIVERDATA_PARMNUM     =  18;
        PRJ_MAXPARMNUM             =  18;

      /*** Bitmap masks for status field of PRJINFO. ***********************/
      /* 2-7 bits also used in device status */
        PRJ_QSTATUS     = $0003;      /* Bits 0,1  */
        PRJ_DEVSTATUS   = $0ffc;      /* 2-11 bits */
        PRJ_COMPLETE    = $0004;      /* Bit 2     */
        PRJ_INTERV      = $0008;      /* Bit 3     */
        PRJ_ERROR       = $0010;      /* Bit 4     */
        PRJ_DESTOFFLINE = $0020;      /* Bit 5     */
        PRJ_DESTPAUSED  = $0040;      /* Bit 6     */
        PRJ_NOTIFY      = $0080;      /* Bit 7     */
        PRJ_DESTNOPAPER = $0100;      /* Bit 8     */
        PRJ_DESTFORMCHG = $0200;      /* BIT 9     */
        PRJ_DESTCRTCHG  = $0400;      /* BIT 10    */
        PRJ_DESTPENCHG  = $0800;      /* BIT 11    */
        PRJ_JOBFILEINUSE= $4000;      /* Bit 14    */
        PRJ_DELETED     = $8000;      /* Bit 15    */

      /*** Values of PRJ_QSTATUS bits in fsStatus field of PRJINFO. ********/
        PRJ_QS_QUEUED              =   0;
        PRJ_QS_PAUSED              =   1;
        PRJ_QS_SPOOLING            =   2;
        PRJ_QS_PRINTING            =   3;

      /*** Print Job Priority **********************************************/
        PRJ_MAX_PRIORITY           =  99;          /* lowest priority  */
        PRJ_MIN_PRIORITY           =   1;          /* highest priority */
        PRJ_NO_PRIORITY            =   0;


      /*** Bitmap masks for status field of PRDINFO. ***********************/
        PRD_STATUS_MASK     =  $0003;      /* Bits 0,1 */
        PRD_DEVSTATUS       =  $0ffc;      /* 2-11 bits */

      /*** Values of PRD_STATUS_MASK bits in fsStatus field of PRDINFO. ****/
        PRD_ACTIVE               =  0;
        PRD_PAUSED               =  1;

      /*** Control codes used in DosPrintDestControl/SplControlDevice ******/
        PRD_DELETE                  =  0;
        PRD_PAUSE                   =  1;
        PRD_CONT                    =  2;
        PRD_RESTART                 =  3;

      /*** Values for parmnum in DosPrintDestSetInfo/SplSetDevice **********/
        PRD_LOGADDR_PARMNUM    =  3;
        PRD_COMMENT_PARMNUM    =  7;
        PRD_DRIVERS_PARMNUM    =  8;
        PRD_TIMEOUT_PARMNUM    =  10;

      /*** structure for SplEnumPrinter ************************************/
TYPE
      PRINTERINFO=RECORD     /* prtin */
         flType:ULONG;
         pszComputerName:PChar;
         pszPrintDestinationName:PChar;
         pszDescription:PChar;
         pszLocalName:PChar;
      END;
      PPRINTERINFO=^PRINTERINFO;

      /*** Flags for flType in  PRINTERINFO and SplEnumPrinter *************/
CONST
           SPL_PR_QUEUE          = $00000001; /* include queues */
           SPL_PR_DIRECT_DEVICE  = $00000002; /* unattached devices */
           SPL_PR_QUEUED_DEVICE  = $00000004; /* queued devices */
           SPL_PR_LOCAL_ONLY     = $00000100; /* exclude remote queues */


IMPORTS

FUNCTION SplQueryDevice(CONST pszComputerName,pszPrintDeviceName:CSTRING;
                        ulLevel:ULONG;VAR pBuf;cbBuf:ULONG;
                        VAR pcbNeeded:ULONG):LONG;
         APIENTRY;           'PMSPL' index 381;
FUNCTION SplQueryQueue(CONST pszComputerName,pszQueueName:CSTRING;
                       ulLevel:ULONG;VAR pBuf;cbBuf:ULONG;
                       VAR pcbNeeded:ULONG):LONG;
         APIENTRY;           'PMSPL' index 397;
FUNCTION SplEnumQueue(CONST pszComputerName:CSTRING;ulLevel:ULONG;VAR pBuf;
                      cbBuf:ULONG;VAR pcReturned,pcTotal,pcbNeeded:ULONG;
                      VAR pReserved):LONG;
         APIENTRY;           'PMSPL' index 399;
{FUNCTION SplQpOpen(cData:LONG;VAR pQPDataIn:QPOPENDATA):HPROC;
         APIENTRY;           'PMSPL' index ********************   ;
FUNCTION SplQpPrint(ahproc:HPROC;CONST pszFileName:CSTRING):BOOL;
         APIENTRY;           'PMSPL' index  *******************  ;
FUNCTION SplQpClose(ahproc:HPROC):BOOL;
         APIENTRY;           'PMSPL' index *******************   ;
FUNCTION SplQpControl(ahproc:HPROC;cmdCode:LONG):BOOL;
         APIENTRY;           'PMSPL' index *****************   ;
FUNCTION SplQpQueryDt(VAR pcDataType:LONG;VAR paszDataTypes:CSTRING):BOOL;
         APIENTRY;           'PMSPL' index *****************   ;
FUNCTION SplQpInstall(ahwnd:HWND):BOOL;
         APIENTRY;           'PMSPL' index ****************   ;
FUNCTION SplQpQueryFlags(VAR pulFlags:ULONG):BOOL;
         APIENTRY;           'PMSPL' index ****************   ;}
FUNCTION SplQmOpen(CONST pszToken:CSTRING;lCount:LONG;
                   VAR pqmdopData:QMOPENDATA):HSPL;
         APIENTRY;           'PMSPL' index 301;
FUNCTION SplQmStartDoc(ahspl:HSPL;CONST pszDocName:CSTRING):BOOL;
         APIENTRY;           'PMSPL' index 302;
FUNCTION SplQmWrite(ahspl:HSPL;lCount:LONG;VAR pData):BOOL;
         APIENTRY;           'PMSPL' index 304;
FUNCTION SplQmEndDoc(ahspl:HSPL):BOOL;
         APIENTRY;           'PMSPL' index 303;
FUNCTION SplQmClose(ahspl:HSPL):BOOL;
         APIENTRY;           'PMSPL' index 306;
FUNCTION SplQmAbort(ahspl:HSPL):BOOL;
         APIENTRY;           'PMSPL' index 305;
FUNCTION SplQmAbortDoc(ahspl:HSPL):BOOL;
         APIENTRY;           'PMSPL' index 308;
FUNCTION SplMessageBox(CONST pszLogAddr:CSTRING;fErrInfo,fErrData:ULONG;
                       CONST pszText,pszCaption:CSTRING;
                       idWindow,fStyle:ULONG):ULONG;
         APIENTRY;           'PMSPL' index 307;
FUNCTION PrtOpen(CONST pszDeviceName:CSTRING;VAR phDevice:HFILE;
                 VAR pActionTaken:ULONG;cbFileSize,uFileAttr:ULONG;
                 openFlag,openMode,reserved:ULONG):ULONG;
         APIENTRY;           'PMSPL' index  370;
FUNCTION PrtClose(hDevice:HFILE):ULONG;
         APIENTRY;           'PMSPL' index  373;
FUNCTION PrtWrite(hDevice:HFILE;VAR  pchData;cbData:ULONG;
                  VAR pcbWritten:ULONG):ULONG;
         APIENTRY;           'PMSPL' index  371;
FUNCTION PrtDevIOCtl(VAR pData;VAR pParms;uFunction,uCategory:ULONG;
                     hDevice:HFILE):ULONG;
         APIENTRY;           'PMSPL' index  372;
PROCEDURE PrtAbort(hDevice:HFILE);
         APIENTRY;           'PMSPL' index  375;
FUNCTION SplStdOpen(ahdc:HDC):BOOL;
         APIENTRY;           'PMSPL' index  350;
FUNCTION SplStdClose(ahdc:HDC):BOOL;
         APIENTRY;           'PMSPL' index  351;
FUNCTION SplStdStart(ahdc:HDC):BOOL;
         APIENTRY;           'PMSPL' index  352;
FUNCTION SplStdStop(ahdc:HDC):HSTD;
         APIENTRY;           'PMSPL' index  353;
FUNCTION SplStdDelete(hMetaFile:HSTD):BOOL;
         APIENTRY;           'PMSPL' index  354;
FUNCTION SplStdGetBits(hMetaFile:HSTD;offData,cbData:LONG;VAR pchData):BOOL;
         APIENTRY;           'PMSPL' index  355;
FUNCTION SplStdQueryLength(hMetaFile:HSTD):LONG;
         APIENTRY;           'PMSPL' index  356;
FUNCTION SplCreateDevice(CONST pszComputerName:CSTRING;ulLevel:ULONG;
                         VAR pBuf;cbBuf:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index  401;
FUNCTION SplControlDevice(CONST pszComputerName,pszPortName:CSTRING;
                          ulControl:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index  380;
FUNCTION SplDeleteDevice(CONST pszComputerName,pszPrintDeviceName:CSTRING):SPLERR;
         APIENTRY;           'PMSPL' index  403;
FUNCTION SplEnumDevice(CONST pszComputerName:CSTRING;ulLevel:ULONG;VAR pBuf;
                       cbBuf:ULONG;VAR pcReturned,pcTotal,pcbNeeded:ULONG;
                       VAR pReserved):SPLERR;
         APIENTRY;           'PMSPL' index  382;
FUNCTION SplSetDevice(CONST pszComputerName,pszPrintDeviceName:CSTRING;
                      ulLevel:ULONG;VAR pBuf;cbBuf,ulParmNum:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index  402;
FUNCTION SplReleaseJob(CONST pszComputerName,pszQueueName:CSTRING;
                       ulJob:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index  384;
FUNCTION SplDeleteJob(CONST pszComputerName,pszQueueName:CSTRING;ulJob:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index  386;
FUNCTION SplEnumJob(CONST pszComputerName,pszQueueName:CSTRING;ulLevel:ULONG;
                    VAR pBuf;cbBuf:ULONG;
                    VAR pcReturned,pcTotal,pcbNeeded:ULONG;
                    VAR  pReserved):SPLERR;
         APIENTRY;           'PMSPL' index 392;
FUNCTION SplQueryJob(CONST pszComputerName,pszQueueName:CSTRING;
                     ulJob,ulLevel:ULONG;VAR pBuf;cbBuf:ULONG;
                     VAR pcbNeeded:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index 390;
FUNCTION SplHoldJob(CONST pszComputerName,pszQueueName:CSTRING;ulJob:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index 385;
FUNCTION SplSetJob(CONST pszComputerName,pszQueueName:CSTRING;ulJob,ulLevel:ULONG;
                   VAR pBuf;cbBuf,ulParmNum:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index 391;
FUNCTION SplCreateQueue(CONST pszComputerName:CSTRING;ulLevel:ULONG;VAR pBuf;
                        cbBuf:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index 393;
FUNCTION SplReleaseQueue(CONST pszComputerName,pszQueueName:CSTRING):SPLERR;
         APIENTRY;           'PMSPL' index 395;
FUNCTION SplDeleteQueue(CONST pszComputerName,pszQueueName:CSTRING):SPLERR;
         APIENTRY;           'PMSPL' index 396;
FUNCTION SplHoldQueue(CONST pszComputerName,pszQueueName:CSTRING):SPLERR;
         APIENTRY;           'PMSPL' index 394;
FUNCTION SplPurgeQueue(CONST pszComputerName,pszQueueName:CSTRING):SPLERR;
         APIENTRY;           'PMSPL' index 404;
FUNCTION SplSetQueue(CONST pszComputerName,pszQueueName:CSTRING;ulLevel:ULONG;
                     VAR pBuf;cbBuf,ulParmNum:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index 398;
FUNCTION SplEnumDriver(CONST pszComputerName:CSTRING;ulLevel:ULONG;VAR pBuf;
                       cbBuf:ULONG;VAR pcReturned,pcTotal,pcbNeeded:ULONG;
                       VAR pReserved):SPLERR;
         APIENTRY;           'PMSPL' index 406;
FUNCTION SplEnumPort(CONST pszComputerName:CSTRING;ulLevel:ULONG;VAR pBuf;
                     cbBuf:ULONG;VAR pcReturned,pcTotal,pcbNeeded:ULONG;
                     VAR pReserved):SPLERR;
         APIENTRY;           'PMSPL' index 408;
FUNCTION SplEnumQueueProcessor(CONST pszComputerName:CSTRING;ulLevel:ULONG;
                               VAR pBuf;cbBuf:ULONG;
                               VAR pcReturned,pcTotal,pcbNeeded:ULONG;
                               VAR pReserved):SPLERR;
         APIENTRY;           'PMSPL' index 407;
FUNCTION SplEnumPrinter(CONST pszComputerName:CSTRING;uLevel,flType:ULONG;
                        VAR pBuf;cbbuf:ULONG;
                        VAR pcReturned,pcTotal,pcbNeeded:ULONG;
                        VAR pReserved):SPLERR;
         APIENTRY;           'PMSPL' index 441;
FUNCTION SplCopyJob(CONST pszSrcComputerName,pszSrcQueueName:CSTRING;
                    ulSrcJob:ULONG;CONST pszTrgComputerName,
                    pszTrgQueueName:CSTRING;VAR pulTrgJob:ULONG):SPLERR;
         APIENTRY;           'PMSPL' index 442;
END; {IMPORTS}



IMPLEMENTATION


BEGIN
END.

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Runtime Library for OS/2                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT MMIO;

INTERFACE

USES Os2Def,BseDos,PmBitmap,PmWin;

TYPE
     HMMIO=LONGWORD;
     HMMCF=LONGWORD;
     FOURCC=LONGWORD;
     PFOURCC=^FOURCC;

TYPE
    PMMCKINFO=^MMCKINFO;
    MMCKINFO=RECORD
                   ckid:FOURCC;
                   ckSize:LONGWORD;
                   fccType:FOURCC;
                   dwDataOffset:LONGWORD;
                   dwFlags:LONGWORD;
    END;

TYPE MMIOPROC=FUNCTION(VAR pmmioInfo;wMsg:LONGWORD;lParam1,lParam2:LONG):LONG;APIENTRY;
     PMMIOPROC=^MMIOPROC;

TYPE
    PMMIOINFO=^MMIOINFO;
    MMIOINFO=RECORD
                   dwFlags:LONGWORD;
                   fccIOProc:FOURCC;
                   pIOProc:PMMIOPROC;
                   dwErrorRet:LONGWORD;
                   cchBuffer:LONG;
                   pchBuffer:PChar;
                   pchNext:PChar;
                   pchEndRead:PChar;
                   pchEndWrite:PChar;
                   lBufOffset:LONG;
                   lDiskOffset:LONG;
                   adwInfo:ARRAY[0..3] OF LONGWORD;
                   lLogicalFilePos:LONG;
                   ulTranslate:LONGWORD;
                   fccChildIOProc:FOURCC;
                   pExtraInfoStruct:POINTER;
                   hmmio:HMMIO;
    END;

    PMMCFINFO=^MMCFINFO;
    MMCFINFO=RECORD
                   dwHeaderSize:LONGWORD;
                   dwEntriesTotal:LONGWORD;
                   dwEntriesDeleted:LONGWORD;
                   dwEntriesUnused:LONGWORD;
                   dwBytesTotal:LONGWORD;
                   dwBytesDeleted:LONGWORD;
                   dwHeaderFlags:LONGWORD;
                   wEntrySize:WORD;
                   wNameSize:WORD;
                   wExHdrFields:WORD;
                   wExEntFields:WORD;
    END;

    PMMCTOCENTRY=^MMCTOCENTRY;
    MMCTOCENTRY=RECORD
                      dwOffset:LONGWORD;
                      dwSize:LONGWORD;
                      dwMedType:LONGWORD;
                      dwMedUsage:LONGWORD;
                      dwCompressTech:LONGWORD;
                      dwUncompressBytes:LONGWORD;
    END;

CONST
      MMIO_MEDIATYPE_IMAGE       =$00000001;  /* Image media */
      MMIO_MEDIATYPE_AUDIO       =$00000002;  /* Audio media */
      MMIO_MEDIATYPE_MIDI        =$00000004;  /* MIDI media  */
      MMIO_MEDIATYPE_COMPOUND    =$00000008;  /* Cmpd media  */
      MMIO_MEDIATYPE_OTHER       =$00000010;  /* Other media */
      MMIO_MEDIATYPE_UNKNOWN     =$00000020;  /* Unknown media */
      MMIO_MEDIATYPE_DIGITALVIDEO=$00000040;  /* Digital Video */
      MMIO_MEDIATYPE_ANIMATION   =$00000080;  /* Future: Not Supported */
      MMIO_MEDIATYPE_MOVIE       =$00000100;  /* Movie File */

      MMIO_CANREADTRANSLATED            = $00000001; /*IOProc Cpbilty Flgs*/
      MMIO_CANWRITETRANSLATED           = $00000002; /* "       "       " */
      MMIO_CANREADWRITETRANSLATED       = $00000004; /* "       "       " */
      MMIO_CANREADUNTRANSLATED          = $00000008; /* "       "       " */
      MMIO_CANWRITEUNTRANSLATED         = $00000010; /* "       "       " */
      MMIO_CANREADWRITEUNTRANSLATED     = $00000020; /* "       "       " */
      MMIO_CANSEEKTRANSLATED            = $00000040; /* "       "       " */
      MMIO_CANSEEKUNTRANSLATED          = $00000080; /* "       "       " */
      MMIO_CANINSERTUNTRANSLATED        = $00000100; /* "       "       " */
      MMIO_CANSAVEUNTRANSLATED          = $00000200; /* "       "       " */
      MMIO_CANINSERTTRANSLATED          = $00000400; /* "       "       " */
      MMIO_CANSAVETRANSLATED            = $00000800; /* "       "       " */
      MMIO_CANMULTITRACKREADTRANSLATED  = $00001000; /* "       "       " */
      MMIO_CANMULTITRACKREADUNTRANSLATED= $00002000; /* "       "       " */
      MMIO_CANMULTITRACKWRITETRANSLATED = $00004000; /* "       "       " */
      MMIO_CANMULTITRACKWRITEUNTRANSLATED=$00008000; /* "       "       " */
      MMIO_CANTRACKSEEKTRANSLATED       = $00010000; /* "       "       " */
      MMIO_CANTRACKSEEKUNTRANSLATED     = $00020000; /* "       "       " */
      MMIO_CANTRACKREADTRANSLATED       = $00040000; /* "       "       " */
      MMIO_CANTRACKREADUNTRANSLATED     = $00080000; /* "       "       " */
      MMIO_CANTRACKWRITETRANSLATED      = $00100000; /* "       "       " */
      MMIO_CANTRACKWRITEUNTRANSLATED    = $00200000; /* "       "       " */

      MMIO_IOPROC_STORAGESYSTEM   = $00000001;  /* IOProc Types */
      MMIO_IOPROC_FILEFORMAT      = $00000002;
      MMIO_IOPROC_DATAFORMAT      = $00000004;

TYPE
   PMMFORMATINFO=^MMFORMATINFO;
   MMFORMATINFO=RECORD
                      dwStructLen:LONGWORD;
                      fccIOProc:FOURCC;
                      dwIOProcType:LONGWORD;
                      dwMediaType:LONGWORD;
                      dwFlags:LONGWORD;
                      achDefaultFormatExt:CSTRING[sizeof(FOURCC){+1}];
                                       /* Default extension 4 + null */
                      dwCodePage:LONGWORD;
                      dwLanguage:LONGWORD;
                      lNameLength:LONG;
   END;

CONST
      MMIO_IMAGE_UNKNOWN        = $00000000;  /* Unknown image content */
      MMIO_IMAGE_DRAWING        = $00000001;  /* Simple drawing        */
      MMIO_IMAGE_GRAPH          = $00000002;  /* Graphs & Cartoons     */
      MMIO_IMAGE_PHOTO          = $00000004;  /* Varying Color & Shades */

CONST
      MAX_PALETTE  =256;

TYPE
    XDIBHDR_PREFIX=RECORD
                         ulMemSize:LONGWORD;
                         ulPelFormat:LONGWORD;
                         usTransType:WORD;
                         ulTransVal:LONGWORD;
    END;

    PMMXDIBHEADER=^MMXDIBHEADER;
    MMXDIBHEADER=RECORD
                       XDIBHeaderPrefix:XDIBHDR_PREFIX;
                       BMPInfoHeader2:BITMAPINFOHEADER2;
    END;


    PMMIMAGEHEADER=^MMIMAGEHEADER;
    MMIMAGEHEADER=RECORD
                        dwHeaderLength:LONGWORD;
                        dwContentType:LONGWORD;
                        dwMediaType:LONGWORD;
                        mmXDIBHeader:MMXDIBHEADER;
                        bmiColors:ARRAY[0..MAX_PALETTE-1] OF RGB2;
    END;

(*
#ifndef WORD
typedef USHORT WORD;
#endif

#ifndef DWORD
typedef ULONG  DWORD;
#endif

typedef WORD  VERSION;
typedef FAR * LPSTR;
typedef FAR * LPTR;
typedef FAR * LPRECT;
typedef HWND HANDLE;
typedef WORD *  PW;
typedef WORD *  PAW;
typedef WORD * PWORD;
typedef PFN  FAR *  PPFN;
typedef DWORD (APIENTRY FNMCI) (LPTR, WORD, DWORD, DWORD, WORD);
typedef FNMCI *PFNMCI;

/* XLATON */

#ifdef XXXXX
typedef PVOID PFNMCI;
typedef PVOID LPTR;
#endif

typedef char   SZ;                    /* ASCIIZ char string type*/
*)
TYPE
    PMMTIME=^MMTIME;
    MMTIME=LONGWORD;

(*
typedef ULONG HMMIO;                  /* Handle to an MMIO object*/
typedef HMMIO FAR *PHMMIO;            /* Handle to an MMIO object*/


/**********************************************
 *
 * SPCBKEY - Stream Protocol Key
 *
 **********************************************/
typedef struct _SPCBKEY { /* spcbkey SPCB key (Stream data type) */
   ULONG    ulDataType;
   ULONG    ulDataSubType;
   ULONG    ulIntKey;                 /* generated internal key            */
   } SPCBKEY;
typedef SPCBKEY FAR *PSPCBKEY;
       _SPCBKEY_DEFINED   1
*)

TYPE
    PMMTRACKINFO=^MMTRACKINFO;
    MMTRACKINFO=RECORD
                      ulTrackID:LONGWORD;
                      ulMediaType:LONGWORD;
                      ulCountry:LONGWORD;
                      ulCodePage:LONGWORD;
                      ulReserved1:LONGWORD;
                      ulReserved2:LONGWORD;
    END;

(*
/************************
 * Clipboard formats
 ************************/
              CF_RMID                 10
              CF_RIFF                 11
              CF_WAVE                 12
              CF_AVI                  13


/************************
 * Resource formats
 ************************/
              RT_RMID                 100
              RT_RIFF                 101
              RT_WAVE                 102
              RT_AVI                  103
              RT_AVS                  104
*)

/************************
 * Sampling Rate
 ************************/
Const HZ_8000   = 8000;            /* 8.0 kHz*/
      HZ_11025  = 11025;           /* 11.025 kHz*/
      HZ_14700  = 14700;           /* 14.700 kHz (SPV/2)*/
      HZ_18900  = 18900;           /* 18.900 kHz (CD/XA LVL C)*/
      HZ_22050  = 22050;           /* 22.050 kHz*/
      HZ_37800  = 37800;           /* 37.800 kHz (CD/XA LVL B)*/
      HZ_44100  = 44100;           /* 44.100 kHz*/

/************************
 * Bits per Sample
 ************************/
      BPS_4  = 4;   /* 4 bits/sample (ADPCM)*/
      BPS_8  = 8;   /* 8 bits/sample (PCM)*/
      BPS_16 = 16;  /* 16 bits/sample(PCM)*/

/************************
 * Channels
 ************************/
      CH_MONO   = 1;     /* Mono*/
      CH_STEREO = 2;     /* Stereo*/
      CH_QUAD   = 4;     /* Quad*/

(*
/*************************************************************************
 * Multimedia Datatypes (spcbkey values)
 *************************************************************************/


/****************
 * NULL datatype
 ****************/
       DATATYPE_NULL           $0000L     /* NULL stream data type (NULL)*/
         SUBTYPE_NONE            $0000L   /* No subtype for this data type*/


/*********************
 * WAVEFORM datatypes
 *********************/
       DATATYPE_WAVEFORM       $0001L     /* WAVEFORM audio (PCM)*/

/* Subtypes for DATATYPE_WAVEFORM:*/
         WAVE_FORMAT_1M08        $0001L   /* 11.025kHz, Mono  , 8-bit*/
         WAVE_FORMAT_1S08        $0002L   /* 11.025kHz, Stereo, 8-bit*/
         WAVE_FORMAT_1M16        $0003L   /* 11.025kHz, Mono  , 16-bit*/
         WAVE_FORMAT_1S16        $0004L   /* 11.025kHz, Stereo, 16-bit*/
         WAVE_FORMAT_2M08        $0005L   /* 22.05kHz , Mono  , 8-bit*/
         WAVE_FORMAT_2S08        $0006L   /* 22.05kHz , Stereo, 8-bit*/
         WAVE_FORMAT_2M16        $0007L   /* 22.05kHz , Mono  , 16-bit*/
         WAVE_FORMAT_2S16        $0008L   /* 22.05kHz , Stereo, 16-bit*/
         WAVE_FORMAT_4M08        $0009L   /* 44.1kHz  , Mono  , 8-bit*/
         WAVE_FORMAT_4S08        $000aL   /* 44.1kHz  , Stereo, 8-bit*/
         WAVE_FORMAT_4M16        $000bL   /* 44.1kHz  , Mono  , 16-bit*/
         WAVE_FORMAT_4S16        $000cL   /* 44.1kHz  , Stereo, 16-bit*/
         WAVE_FORMAT_8M08        $000dL   /*  8.0kHz  , Mono  , 8-bit*/
         WAVE_FORMAT_8S08        $000eL   /*  8.0kHz  , Stereo, 8-bit*/
         WAVE_FORMAT_8M16        $000fL   /*  8.0kHz  , Mono  , 16-bit*/
         WAVE_FORMAT_8S16        $0010L   /*  8.0kHz  , Stereo, 16-bit*/


/*********************
 * DIGVIDEO datatypes
 *********************/
       DATATYPE_DIGVIDEO       $0002L     /* Digital Video */

/* Subtypes for DATATYPE_DIGVIDEO:*/
         DIGVIDEO_PHOTOM         $544F4850L   /* Photmotion video, FOURCC value for phio */
         DIGVIDEO_ULTIM          $49544c55L   /* Ultimotion video, FOURCC value for ulio */
         DIGVIDEO_AVI            $20495641L   /* AVI video, FOURCC value for avio */
         DIGVIDEO_MONITOR        $206E6F6DL   /* MONITOR video, FOURCC value for monitoring */
         DIGVIDEO_FLC            $63696C66L   /* FLIC video, FOURCC value for flic */
         DIGVIDEO_MPEG           $4745504DL   /* MPEG video, FOURCC value for MPEG */


/******************
 * MuLaw datatypes
 ******************/
      DATATYPE_MULAW           $0101L     /* MuLaw*/
      DATATYPE_RIFF_MULAW      $0007L    /* MuLaw*/

/* Subtypes for DATATYPE_MULAW:*/
         MULAW_8B8KS             $0001L   /* 8bit 8kHz stereo*/
         MULAW_8B11KS            $0002L   /* 8bit 11kHz stereo*/
         MULAW_8B22KS            $0003L   /* 8bit 22kHz stereo*/
         MULAW_8B44KS            $0004L   /* 8bit 44kHz stereo*/
         MULAW_8B8KM             $0005L   /* 8bit 8kHz mono*/
         MULAW_8B11KM            $0006L   /* 8bit 11kHz mono*/
         MULAW_8B22KM            $0007L   /* 8bit 22kHz mono*/
         MULAW_8B44KM            $0008L   /* 8bit 44kHz mono*/

/*****************
 * ALaw datatypes
 *****************/
      DATATYPE_ALAW            $0102L     /* ALaw*/
      DATATYPE_RIFF_ALAW       $0006L     /* ALaw*/

/* Subtypes for DATATYPE_ALAW:*/
         ALAW_8B8KS              $0001L   /* 8bit 8kHz stereo*/
         ALAW_8B11KS             $0002L   /* 8bit 11kHz stereo*/
         ALAW_8B22KS             $0003L   /* 8bit 22kHz stereo*/
         ALAW_8B44KS             $0004L   /* 8bit 44kHz stereo*/
         ALAW_8B8KM              $0005L   /* 8bit 8kHz mono*/
         ALAW_8B11KM             $0006L   /* 8bit 11kHz mono*/
         ALAW_8B22KM             $0007L   /* 8bit 22kHz mono*/
         ALAW_8B44KM             $0008L   /* 8bit 44kHz mono*/


/*******************************
 * AVC ADPCM WAVEFORM datatypes
 *******************************/
       DATATYPE_ADPCM_AVC      $0103L     /* ADPCM audio*/

/* Subtypes for DATATYPE_ADPCM_AVC:*/
         ADPCM_AVC_VOICE         $0001L
         ADPCM_AVC_MUSIC         $0002L
         ADPCM_AVC_STEREO        $0003L
         ADPCM_AVC_HQ            $0004L

/******************
 * CT_ADPCM datatypes
 ******************/
      DATATYPE_CT_ADPCM          $0200L     /* Creative technologies */

/* Subtypes for DATATYPE_CT_ADPCM:*/
         CT_ADPCM_16B8KS          $0001L   /* 16bit 8kHz stereo*/
         CT_ADPCM_16B11KS         $0002L   /* 16bit 11kHz stereo*/
         CT_ADPCM_16B22KS         $0003L   /* 16bit 22kHz stereo*/
         CT_ADPCM_16B44KS         $0004L   /* 16bit 44kHz stereo*/
         CT_ADPCM_16B8KM          $0005L   /* 16bit 8kHz mono*/
         CT_ADPCM_16B11KM         $0006L   /* 16bit 11kHz mono*/
         CT_ADPCM_16B22KM         $0007L   /* 16bit 22kHz mono*/
         CT_ADPCM_16B44KM         $0008L   /* 16bit 44kHz mono*/

/****************
 * MIDI datatype
 ****************/
       DATATYPE_MIDI           $0201L     /* MIDI*/
/*         SUBTYPE_NONE            $0000L      No subtype for this data type*/


/********************
 * GENERIC datatypes
 ********************/
       DATATYPE_GENERIC        $0202L     /* Generic for files / memory. This*/
                                             /* datatype will match any other*/
                                             /* datatype at stream creation time.*/

/**************************
 * Speech Viewer datatypes
 **************************/
       DATATYPE_SPV2           $0203L     /* Speech Viewer*/

/* Subtypes for DATATYPE_SPV2:*/
         SPV2_BPCM               $0001L
         SPV2_PCM                $0002L
         SPV2_NONE               $0003L


/******************
 * CD-XA datatypes
 ******************/
       DATATYPE_CDXA_VIDEO     $0204L     /* CD-XA Video datatype*/
       DATATYPE_CDXA_DATA      $0205L     /* CD-XA sub-band data datatype*/
       DATATYPE_CDXA_AUDIO     $0206L     /* CD-XA ADPCM Audio datatype*/
       DATATYPE_CDXA_AUDIO_HD  $0207L     /* CD-XA ADPCM Audio with Headers*/
       DATATYPE_CDXA_HEADERS   $0208L     /* CD-XA Headers and Subheaders*/


/* Subtypes for DATATYPE_CDXA_AUDIO:*/
         CDXA_LEVELB             $0000L /* LEVEL B Audio Stereo*/
         CDXA_LEVELC             $0001L /* LEVEL C Audio Stereo*/
         CDXA_LEVELB_MONO        $0002L /* LEVEL B Audio Mono*/
         CDXA_LEVELC_MONO        $0003L /* LEVEL C Audio Mono*/


/*********************
 * DIGISPEECH datatype
 *********************/
       DATATYPE_DIGISPEECH     $0208L     /* DIGISPEECH */
         DIGISPEECH_NATIVE       $0001L   /* Native digispeech */


/*********************
 * MPEG-1 Audio datatypes
 *********************/
       DATATYPE_MPEG1AUDIO       $0050L     /* MPEG-1 Audio */

/* Subtypes for DATATYPE_MPEG1AUDIO:*/
         MPEG1_FORMAT_3M16        $0001L   /* 32.000kHz,  Mono  , 16-bit*/
         MPEG1_FORMAT_3S16        $0002L   /* 32.000kHz,  Stereo, 16-bit*/
         MPEG1_FORMAT_4M16        $0003L   /* 44.1/48kHz, Mono  , 16-bit*/
         MPEG1_FORMAT_4S16        $0004L   /* 44.1/48kHz, Stereo, 16-bit*/

/*******************
 * UNKNOWN datatype
 *******************/
       DATATYPE_UNKNOWN        $FFFFFFFFL   /* Unknown datatype */
/*         SUBTYPE_NONE            $0000L      No subtype for this data type*/


/* XLATOFF */
#endif
/* XLATON */


typedef MMIMAGEHEADER *PMMIMAGEHEADER;

#endif
#endif

      MMIO_AUDIO_UNKNOWN          $00000000L  /* Unknown image content  */
      MMIO_AUDIO_VOICE            $00000001L  /* Limited Range          */
      MMIO_AUDIO_MUSIC            $00000002L  /* FM Radio or equivalent */
      MMIO_AUDIO_HIFI             $00000004L  /* High quality recording */

*)

type
  pWave_Header = ^Wave_Header;
  Wave_Header = record
    usFormatTag       : uShort;                // Type of wave format
    usChannels        : uShort;                // Number of channels
    ulSamplesPerSec   : uLong;                 // Sampling rate
    ulAvgBytesPerSec  : uLong;                 // Avg bytes per sec
    usBlockAlign      : uShort;                // Block Alignment in bytes
    usBitsPerSample   : uShort;                // Bits per sample
  end;

(*
typedef struct _XWAV_HEADERINFO {            /* xwaveheader info        */
   ULONG           ulAudioLengthInMS;        /* Audio data in millisecs */
   ULONG           ulAudioLengthInBytes;     /* Audio data in bytes     */
   PVOID           pAdditionalInformation;
   } XWAV_HEADERINFO;

typedef struct _MMXWAV_HEADER {              /* mmxwaveheader            */
   WAVE_HEADER     WAVEHeader;               /* Per RIFF WAVE Definition */
   XWAV_HEADERINFO XWAVHeaderInfo;           /* Extended wave definition */
   } MMXWAV_HEADER;

typedef struct _MMAUDIOHEADER {              /* mmaudioheader   */
   DWORD           dwHeaderLength;           /* Length in Bytes */
   DWORD           dwContentType;            /* Image content   */
   DWORD           dwMediaType;              /* Media Type      */
   MMXWAV_HEADER   mmXWAVHeader;             /* header          */
   } MMAUDIOHEADER;

typedef MMAUDIOHEADER *PMMAUDIOHEADER;

      MMIO_MIDI_UNKNOWN          $00000000L  /* Unknown midi content   */
      MMIO_MIDI_VOICE            $00000001L  /* Limited Range          */
      MMIO_MIDI_MUSIC            $00000002L  /* FM Radio or equivalent */
      MMIO_MIDI_HIFI             $00000004L  /* High quality recording */
*)

CONST
      DLLNAME_SIZE       =CCHMAXPATH;
      PROCNAME_SIZE      =32;
      MAX_EXTENSION_NAME =4;

(*
typedef struct _MMINIFILEINFO {               /* mminifileinfo          */
   FOURCC      fccIOProc;                     /* IOProc identifier      */
   CHAR        szDLLName[DLLNAME_SIZE];       /* DLL name string        */
   CHAR        szProcName[PROCNAME_SIZE];     /* Procedure name string  */
   DWORD       dwFlags;                       /* Flags for Preload      */
   DWORD       dwExtendLen;                   /* Length of ext fields   */
   DWORD       dwMediaType;                   /* Media type             */
   DWORD       dwIOProcType;                  /* Type of IOProc         */
   CHAR        szDefExt[sizeof(MAX_EXTENSION_NAME)];
                                              /* Default file extension */
   } MMINIFILEINFO;

typedef MMINIFILEINFO *PMMINIFILEINFO;

/*
 * CODEC Structures and type definitions for Rel. 1.1
 */

*)
CONST
      CODEC_INFO_SIZE    =8;
      CODEC_HW_NAME_SIZE =32;

TYPE
    PCODECPROC=^MMIOPROC;

TYPE
    PCODECINIFILEINFO=^CODECINIFILEINFO;
    CODECINIFILEINFO=RECORD
                           ulStructLen:LONGWORD;
                           fcc:FOURCC;
                           szDLLName:CSTRING[DLLNAME_SIZE-1];
                           szProcName:CSTRING[PROCNAME_SIZE-1];
                           ulCompressType:LONGWORD;
                           ulCompressSubType:LONGWORD;
                           ulMediaType:LONGWORD;
                           ulCapsFlags:LONGWORD;
                           ulFlags:LONGWORD;
                           szHWID:CSTRING[CODEC_HW_NAME_SIZE-1];
                           ulMaxSrcBufLen:LONGWORD;
                           ulSyncMethod:LONGWORD;
                           fccPreferredFormat:LONGWORD;
                           ulXalignment:LONGWORD;
                           ulYalignment:LONGWORD;
                           ulSpecInfo:CSTRING[CODEC_INFO_SIZE-1];
    END;

CONST
      CODEC_SYNC_METHOD_NO_DROP_FRAMES                  =0;
      CODEC_SYNC_METHOD_DROP_FRAMES_IMMEDIATELY         =1;
      CODEC_SYNC_METHOD_DROP_FRAMES_PRECEDING_KEY       =2;
      CODEC_SYNC_METHOD_HARDWARE                        =3;


      CODEC_COMPRESS            =$00000001;
      CODEC_DECOMPRESS          =$00000002;
      CODEC_WINDOW_CLIPPING     =$00000004;
      CODEC_PALETTE_TRANS       =$00000008;
      CODEC_SELFHEAL            =$00000010;
      CODEC_SCALE_PEL_DOUBLE    =$00000020;
      CODEC_SCALE_PEL_HALVED    =$00000040;
      CODEC_SCALE_CONTINUOUS    =$00000080;
      CODEC_MULAPERTURE         =$00000100;
      CODEC_4_BIT_COLOR         =$00000200;
      CODEC_8_BIT_COLOR         =$00000400;
      CODEC_16_BIT_COLOR        =$00000800;
      CODEC_24_BIT_COLOR        =$00001000;
      CODEC_HARDWARE            =$00002000;
      CODEC_SYMMETRIC           =$00004000;
      CODEC_ASYMMETRIC          =$00008000;
      CODEC_DIRECT_DISPLAY      =$00010000;
      CODEC_DEFAULT             =$00020000;
      CODEC_ORIGIN_LOWERLEFT    =$00040000;
      CODEC_ORIGIN_UPPERLEFT    =$00080000;
      CODEC_SET_QUALITY         =$00100000;
      CODEC_DATA_CONSTRAINT     =$00200000;
      CODEC_HW_OVERLAY          =$00400000;
      CODEC_MULTI_BUFFER        =$00800000;
      CODEC_DITHER_OUTPUT       =$01000000;
      CODEC_COMP_REALTIME       =$00020000;
      CODEC_DECOMP_REALTIME     =$00040000;

      MMIO_SET_EXTENDEDINFO                   =$0001;
      MMIO_QUERY_EXTENDEDINFO_BASE            =$0002;
      MMIO_QUERY_EXTENDEDINFO_ALL             =$0004;

TYPE
    PCODECASSOC=^CODECASSOC;
    CODECASSOC=RECORD
                     pCodecOpen:POINTER;
                     pCodecIniFileInfo:PCODECINIFILEINFO;
    END;

    PMMEXTENDINFO=^MMEXTENDINFO;
    MMEXTENDINFO=RECORD
                       ulStructLen:LONGWORD;
                       ulBufSize:LONGWORD;
                       ulFlags:LONGWORD;
                       ulTrackID:LONGWORD;
                       ulNumCODECs:LONGWORD;
                       pCODECAssoc:PCODECASSOC;
    END;

CONST
      MMIO_TRACK                =$00000001;
      MMIO_NORMAL_READ          =$00000002;
      MMIO_SCAN_READ            =$00000004;
      MMIO_REVERSE_READ         =$00000008;
      MMIO_CODEC_ASSOC          =$00000100;

(*
/* Audio Related defines */

      MMIO_REALTIME_CODEC       $00000200
*)
CONST
      MMIO_RESETTRACKS          =-1;
(*
      CODEC_START              $0EC0
      CODEC_END                $0EFF

      MMIOM_CODEC_CLOSE             CODEC_START + 1
      MMIOM_CODEC_OPEN              CODEC_START + 2
      MMIOM_CODEC_QUERYNAME         CODEC_START + 3
      MMIOM_CODEC_QUERYNAMELENGTH   CODEC_START + 4
      MMIOM_CODEC_COMPRESS          CODEC_START + 5
      MMIOM_CODEC_DECOMPRESS        CODEC_START + 6


#endif
/* End CODEC include */

*)
CONST
      MMIO_CREATE     =$00000001;       /* Open */
      MMIO_CTOCFIRST  =$00000002;       /* Open */
      MMIO_READ       =$00000004;       /* Open */
      MMIO_WRITE      =$00000008;       /* Open */
      MMIO_READWRITE  =$00000010;       /* Open */
      MMIO_COMPAT     =$00000020;       /* Open */
      MMIO_EXCLUSIVE  =$00000040;       /* Open */
      MMIO_DENYWRITE  =$00000080;       /* Open */
      MMIO_DENYREAD   =$00000100;       /* Open */
      MMIO_DENYNONE   =$00000200;       /* Open */
      MMIO_ALLOCBUF   =$00000400;       /* Open */
      MMIO_DELETE     =$00000800;       /* Open */

      MMIO_USE_TEMP   =$00001000;       /* Open/Close/Save */

      MMIO_INSERTON   =$00000001;       /* Insert */
      MMIO_INSERTOFF  =$00000002;       /* Insert */

      MMIO_RWMODE     =$00001000;       /* Open */
      MMIO_SHAREMODE  =$00002000;       /* Open */

      MMIO_DIRTY      =$00004000;       /* Write */

      MMIO_VERTBAR     =$00008000;       /* Open */
      MMIO_BUFSHARED   =$00010000;       /* Open */
      MMIO_APPEND      =$00020000;       /* Open */
      MMIO_NOIDENTIFY  =$00040000;       /* Open */


      MMIO_FINDFIRST   =$00000001;       /* CF Find Entry */
      MMIO_FINDNEXT    =$00000002;       /* CF Find Entry */
      MMIO_FINDUNUSED  =$00000004;       /* CF Find Entry */
      MMIO_FINDDELETED =$00000008;       /* CF Find Entry */

      MMIO_CHANGEDELETED =$0001;        /* CF Change Entry */

      MMIO_CF_FQNAME     =$0001;        /* CF Compact      */

      MMIO_FHOPEN      =$0001;          /* Close */

      MMIO_EMPTYBUF    =$0001;          /* Flush */

      MMIO_CREATERIFF  =$0001;          /* CreateChunk */
      MMIO_CREATELIST  =$0002;          /* CreateChunk */
      MMIO_FINDCHUNK   =$0004;          /* Descend     */
      MMIO_FINDRIFF    =$0008;          /* Descend     */
      MMIO_FINDLIST    =$0010;          /* Descend     */

      CTOC_HF_SEQUENTIAL =$00000001;    /* CTOC dwHeaderFlags */
      CTOC_HF_MEDSUBTYPE =$00000002;    /* CTOC dwHeaderFlags */

      CTOC_EFU_UNUSED          =$00000000; /* CTOC extra usage code */
      CTOC_EFU_LASTMODTIME     =$00000001; /* CTOC extra usage code */
      CTOC_EFU_CODEPAGE        =$00000002; /* CTOC extra usage code */
      CTOC_EFU_LANGUAGE        =$00000003; /* CTOC extra usage code */
      CTOC_EFU_COMPRESSPARAM0  =$00000005; /* CTOC extra usage code */
      CTOC_EFU_COMPRESSPARAM1  =$00000006; /* CTOC extra usage code */
      CTOC_EFU_COMPRESSPARAM2  =$00000007; /* CTOC extra usage code */
      CTOC_EFU_COMPRESSPARAM3  =$00000008; /* CTOC extra usage code */
      CTOC_EFU_COMPRESSPARAM4  =$00000009; /* CTOC extra usage code */
      CTOC_EFU_COMPRESSPARAM5  =$0000000A; /* CTOC extra usage code */
      CTOC_EFU_COMPRESSPARAM6  =$0000000B; /* CTOC extra usage code */
      CTOC_EFU_COMPRESSPARAM7  =$0000000C; /* CTOC extra usage code */
      CTOC_EFU_COMPRESSPARAM8  =$0000000D; /* CTOC extra usage code */
      CTOC_EFU_COMPRESSPARAM9  =$0000000E; /* CTOC extra usage code */
      CTOC_CHARSET_STANDARD    =$00000000; /* CTOC charset value    */

      MMIO_INSTALLPROC         =$00000001; /* Install IO Proc */
      MMIO_REMOVEPROC          =$00000002; /* Install IO Proc */
      MMIO_FINDPROC            =$00000004; /* Install IO Proc */

      MMIO_MATCHFIRST          =$00000010; /* Ini File Handler */
      MMIO_MATCHNEXT           =$00000020; /* Ini File Handler */
      MMIO_MATCHFOURCC         =$00000040; /* Ini File Handler */
      MMIO_MATCHDLL            =$00000080; /* Ini File Handler */
      MMIO_MATCHPROCEDURENAME  =$00000100; /* Ini File Handler */
      MMIO_FULLPATH            =$00000200; /* Ini File Handler */
      MMIO_NOVERIFY            =$00000400; /* Ini File Handler */
      MMIO_MATCHCOMPRESSTYPE   =$00000800; /* Ini File Handler */
      MMIO_EXTENDED_STRUCT     =$00001000; /* Ini File ulFlags */
      MMIO_MATCHCOMPRESSSUBTYPE= $00002000; /* Ini File Handler */
      MMIO_MATCHHWID           =$00004000; /* Ini File Handler */
      MMIO_MATCHCAPSFLAGS      =$00008000; /* Ini File Handler */
      MMIO_SKIPMATCH           =$00010000; /* Ini/Load Handler */

      MMIO_TOUPPER             =$0001;     /* StringToFourcc */

      MMIO_CF_ENTRY_EXISTS     =$00000001; /* Add CGRP element */

      MMIO_FORCE_IDENTIFY_SS   =$00000001; /* Identify */
      MMIO_FORCE_IDENTIFY_FF   =$00000002; /* Identify */

      MMIO_NOTRANSLATE         =$00000000; /* Translation */
      MMIO_TRANSLATEDATA       =$00000001; /* Translation */
      MMIO_TRANSLATEHEADER     =$00000002; /* Translation */
      MMIO_DECOMPRESS          =$00000004; /* CODEC Decompress */

      MMIO_DEFAULTBUFFER = 8192;   /* two pages under OS/2 2.0 */

      MMIO_SEEK_IFRAME         =$00010000; /* Seek to nearest previous IFRAME */

(*

/*
 * Messages :
 */

      MMIOM_START              $0E00
      MMIOM_END                $0EFF

      MMIOM_GETCF              MMIOM_START + 1
      MMIOM_GETCFENTRY         MMIOM_START + 2

      MMIOM_CLOSE              MMIOM_START + 3
      MMIOM_OPEN               MMIOM_START + 4
      MMIOM_READ               MMIOM_START + 5
      MMIOM_SEEK               MMIOM_START + 6
      MMIOM_WRITE              MMIOM_START + 7

      MMIOM_IDENTIFYFILE       MMIOM_START + 8
      MMIOM_GETHEADER          MMIOM_START + 9
      MMIOM_SETHEADER          MMIOM_START + 10
      MMIOM_QUERYHEADERLENGTH  MMIOM_START + 11
      MMIOM_GETFORMATNAME      MMIOM_START + 12
      MMIOM_GETFORMATINFO      MMIOM_START + 13
      MMIOM_SEEKBYTIME         MMIOM_START + 14
      MMIOM_TEMPCHANGE         MMIOM_START + 15
      MMIOM_BEGININSERT        MMIOM_START + 16
      MMIOM_ENDINSERT          MMIOM_START + 17
      MMIOM_SAVE               MMIOM_START + 18
      MMIOM_SET                MMIOM_START + 19
      MMIOM_COMPRESS           MMIOM_START + 20
      MMIOM_DECOMPRESS         MMIOM_START + 21
      MMIOM_MULTITRACKREAD     MMIOM_START + 22
      MMIOM_MULTITRACKWRITE    MMIOM_START + 23
      MMIOM_DELETE             MMIOM_START + 24
      MMIOM_BEGINGROUP         MMIOM_START + 25
      MMIOM_ENDGROUP           MMIOM_START + 26
      MMIOM_UNDO               MMIOM_START + 27
      MMIOM_REDO               MMIOM_START + 28
      MMIOM_BEGINSTREAM        MMIOM_START + 29
      MMIOM_ENDSTREAM          MMIOM_START + 30


      MMIOM_CUT                MMIOM_START + 31
      MMIOM_COPY               MMIOM_START + 32
      MMIOM_PASTE              MMIOM_START + 33
      MMIOM_CLEAR              MMIOM_START + 34
      MMIOM_STATUS             MMIOM_START + 35
      MMIOM_WINMSG             MMIOM_START + 36
      MMIOM_BEGINRECORD        MMIOM_START + 37
      MMIOM_ENDRECORD          MMIOM_START + 38

/* These 3 new messages were added with feature 11710 */

      MMIOM_QUERYIMAGE         MMIOM_START + 39
      MMIOM_QUERYIMAGECOUNT    MMIOM_START + 40
      MMIOM_SETIMAGE           MMIOM_START + 41

      MMIOM_USER                $0F00
      MMIOM_USER_END            $0FFF


/* Parameter structure for MMIOM_STATUS */

typedef struct _MMIO_STATUS_PARMS {       /* mmio_status_parms                */
    HWND    hwndWindow;                   /* Some items require a window handle */
    ULONG   ulReturn;                     /* Return field */
    ULONG   ulItem;                       /* Use MCI_STATUS_... flags here */
    ULONG   ulValue;                      /* Status value field */
    ULONG   ulType;                       /* MCI_FORMAT_... of ulReturn */
} MMIO_STATUS_PARMS;

typedef MMIO_STATUS_PARMS *PMMIO_STATUS_PARMS;

/* Parameter structure for MMIOM_COPY, MMIOM_CUT, MMIOM_CLEAR and MMIOM_PASTE */

typedef LONG USEC;                        /* microsecond time format */

typedef struct _MMIO_EDIT_PARMS {         /* mmio_medit_parms         */
   ULONG    ulStrucLen;                   /* length of this structure */
   HWND     hwndWindow;                   /* window handle */
   USEC     ulStartTime;                  /* starting time in usec */
   USEC     ulDuration;                   /* duration in usec */
   ULONG    ulCurrentFilePosition;        /* current file position in usec */
   ULONG    ulNewFilePosition;            /* returned by IO proc in usec, MCD will issue a seek */
   ULONG    ulNewFileLength;              /* return by IO proc in usec, MCD updates its headers */
   PVOID    pBuffer;                      /* optional buffer */
   ULONG    ulBufferLength;               /* optional buffer's length */
   PVOID    pHeader;                      /* optional pointer to header for buffer */
} MMIO_EDIT_PARMS;

typedef MMIO_EDIT_PARMS *PMMIO_EDIT_PARMS;

/* Parameter structure for MMIOM_WINMSG */

typedef struct _MMIO_WINMSG {             /* this comment needed by h2inc */
   HWND     hwndWindow;                   /* these are the parameters */
   USHORT   usMessage;                    /*  ... passed to the       */
   PVOID    pParam1;                      /*  ... window procedure    */
   PVOID    pParam2;                      /*  ... by PM               */
} MMIO_WINMSG;

typedef MMIO_WINMSG *PMMIO_WINMSG;




/*
 * Include error codes for MMIO only.
 */

#ifndef _MEERROR_H_
      INCL_MMIO_ERRORS
#include <meerror.h>
#endif
*)
CONST MMIO_SUCCESS                   = 0;
      MMIO_WARNING                   = 2;
      MMIO_ERROR                     =-1;
      MMIOERR_UNSUPPORTED_MESSAGE    =-2;

      MMIO_CF_SUCCESS                = 0;
      MMIO_CF_FAILURE                = 1;


function mmioFourCC( ch0, ch1, ch2, ch3: Char ): uLong;
{      mmioFOURCC( ch0, ch1, ch2, ch3 )                         \
                  ( (DWORD)(BYTE)(ch0) | ( (DWORD)(BYTE)(ch1) << 8 ) |    \
                  ( (DWORD)(BYTE)(ch2) << 16 ) | ( (DWORD)(BYTE)(ch3) << 24 ) ) }
(*
Const FOURCC_RIFF   mmioFOURCC( 'R', 'I', 'F', 'F' )
      FOURCC_LIST   mmioFOURCC( 'L', 'I', 'S', 'T' )
      FOURCC_MEM    mmioFOURCC( 'M', 'E', 'M', ' ' )
      FOURCC_DOS    mmioFOURCC( 'D', 'O', 'S', ' ' )
      FOURCC_BND    mmioFOURCC( 'B', 'N', 'D', ' ' )
      FOURCC_FREE   mmioFOURCC( 'F', 'R', 'E', 'E' )
      FOURCC_DEL    mmioFOURCC( 'D', 'E', 'L', ' ' )
      FOURCC_CTOC   mmioFOURCC( 'C', 'T', 'O', 'C' )
      FOURCC_CGRP   mmioFOURCC( 'C', 'G', 'R', 'P' )
      FOURCC_CF     mmioFOURCC( 'C', 'F', ' ', ' ' )

      MMIO_NLS_CHARSET_INFO    8000   /* RCDATA Name ID for NLS          */
      MMIO_IOPROC_NAME_TABLE   8500   /* RCDATA Name ID for string table */
      MMIO_CODEC_NAME_TABLE    9000   /* RCDATA Name ID for Codec  table */

(*
/*
 * Numeric equivalents of fourcc's.  These are needed for the resource
 * compiler.
 */

      HEX_FOURCC_DOS $20534f44L
      HEX_FOURCC_MEM $204d454dL
      HEX_FOURCC_BND $20444e42L
      HEX_FOURCC_CF  $20204643L

/*
 * Country codes (CC), languages (LC), and dialects (DC).
 */

      MMIO_DEFAULT_CODE_PAGE            437

      MMIO_CC_NONE                      000
      MMIO_CC_USA                       001
      MMIO_CC_CANADA                    002
      MMIO_CC_LATIN_AMERICA             003
      MMIO_CC_GREECE                    030
      MMIO_CC_NETHERLANDS               031
      MMIO_CC_BELGIUM                   032
      MMIO_CC_FRANCE                    033
      MMIO_CC_SPAIN                     034
      MMIO_CC_ITALY                     039
      MMIO_CC_SWITZERLAND               041
      MMIO_CC_AUSTRIA                   043
      MMIO_CC_UNITED_KINGDOM            044
      MMIO_CC_DENMARK                   045
      MMIO_CC_SWEDEN                    046
      MMIO_CC_NORWAY                    047
      MMIO_CC_WEST_GERMANY              049
      MMIO_CC_MEXICO                    052
      MMIO_CC_BRAZIL                    055
      MMIO_CC_AUSTRALIA                 061
      MMIO_CC_NEW_ZEALAND               064
      MMIO_CC_JAPAN                     081
      MMIO_CC_KOREA                     082
      MMIO_CC_CHINA                     086
      MMIO_CC_TAIWAN                    088
      MMIO_CC_TURKEY                    090
      MMIO_CC_PORTUGAL                  351
      MMIO_CC_LUXEMBOURG                352
      MMIO_CC_ICELAND                   354
      MMIO_CC_FINLAND                   358

      MMIO_LC_NONE                        0
      MMIO_DC_NONE                        0
      MMIO_LC_ARABIC                      1
      MMIO_DC_ARABIC                      1
      MMIO_LC_BULGARIAN                   2
      MMIO_DC_BULGARIAN                   1
      MMIO_LC_CATALAN                     3
      MMIO_DC_CATALAN                     1
      MMIO_LC_TRADITIONAL_CHINESE         4
      MMIO_DC_TRADITIONAL_CHINESE         1
      MMIO_LC_SIMPLE_CHINESE              4
      MMIO_DC_SIMPLE_CHINESE              2
      MMIO_LC_CZECH                       5
      MMIO_DC_CZECH                       1
      MMIO_LC_DANISH                      6
      MMIO_DC_DANISH                      1
      MMIO_LC_GERMAN                      7
      MMIO_DC_GERMAN                      1
      MMIO_LC_SWISS_GERMAN                7
      MMIO_DC_SWISS_GERMAN                2
      MMIO_LC_GREEK                       8
      MMIO_DC_GREEK                       1
      MMIO_LC_US_ENGLISH                  9
      MMIO_DC_US_ENGLISH                  1
      MMIO_LC_UK_ENGLISH                  9
      MMIO_DC_UK_ENGLISH                  2
      MMIO_LC_SPANISH                    10
      MMIO_DC_SPANISH                     1
      MMIO_LC_SPANISH_MEXICAN            10
      MMIO_DC_SPANISH_MEXICAN             2
      MMIO_LC_FINNISH                    11
      MMIO_DC_FINNISH                     1
      MMIO_LC_FRENCH                     12
      MMIO_DC_FRENCH                      1
      MMIO_LC_BELGIAN_FRENCH             12
      MMIO_DC_BELGIAN_FRENCH              2
      MMIO_LC_CANADIAN_FRENCH            12
      MMIO_DC_CANADIAN_FRENCH             3
      MMIO_LC_SWISS_FRENCH               12
      MMIO_DC_SWISS_FRENCH                4
      MMIO_LC_HEBREW                     13
      MMIO_DC_HEBREW                      1
      MMIO_LC_HUNGARIAN                  14
      MMIO_DC_HUNGARIAN                   1
      MMIO_LC_ICELANDIC                  15
      MMIO_DC_ICELANDIC                   1
      MMIO_LC_ITALIAN                    16
      MMIO_DC_ITALIAN                     1
      MMIO_LC_SWISS_ITALIAN              16
      MMIO_DC_SWISS_ITALIAN               2
      MMIO_LC_JAPANESE                   17
      MMIO_DC_JAPANESE                    1
      MMIO_LC_KOREAN                     18
      MMIO_DC_KOREAN                      1
      MMIO_LC_DUTCH                      19
      MMIO_DC_DUTCH                       1
      MMIO_LC_BELGIAN_DUTCH              19
      MMIO_DC_BELGIAN_DUTCH               2
      MMIO_LC_NORWEGIAN_BOKMAL           20
      MMIO_DC_NORWEGIAN_BOKMAL            1
      MMIO_LC_NORWEGIAN_NYNORSK          20
      MMIO_DC_NORWEGIAN_NYNORSK           2
      MMIO_LC_POLISH                     21
      MMIO_DC_POLISH                      1
      MMIO_LC_BRAZILIAN_PORTUGUESE       22
      MMIO_DC_BRAZILIAN_PORTUGUESE        1
      MMIO_LC_PORTUGUESE                 22
      MMIO_DC_PORTUGUESE                  2
      MMIO_LC_RHAETO_ROMANIC             23
      MMIO_DC_RHAETO_ROMANIC              1
      MMIO_LC_ROMANIAN                   24
      MMIO_DC_ROMANIAN                    1
      MMIO_LC_RUSSIAN                    25
      MMIO_DC_RUSSIAN                     1
      MMIO_LC_SERBO_CROATIAN_LATIN       26
      MMIO_DC_SERBO_CROATIAN_LATIN        1
      MMIO_LC_SERBO_CROATIAN_CYRILLIC    26
      MMIO_DC_SERBO_CROATIAN_CYRILLIC     2
      MMIO_LC_SLOVAK                     27
      MMIO_DC_SLOVAK                      1
      MMIO_LC_ALBANIAN                   28
      MMIO_DC_ALBANIAN                    1
      MMIO_LC_SWEDISH                    29
      MMIO_DC_SWEDISH                     1
      MMIO_LC_THAI                       30
      MMIO_DC_THAI                        1
      MMIO_LC_TURKISH                    31
      MMIO_DC_TURKISH                     1
      MMIO_LC_URDU                       32
      MMIO_DC_URDU                        1
      MMIO_LC_BAHASA                     33
      MMIO_DC_BAHASA                      1

/*
 * Base function prototypes:
 */

WORD APIENTRY mmioAdvance( HMMIO hmmio,
                           PMMIOINFO pmmioinfo,
                           WORD wFlags );

WORD APIENTRY mmioCreateChunk( HMMIO hmmio,
                               PMMCKINFO pckinfo,
                               WORD wFlags );

WORD APIENTRY mmioFlush( HMMIO hmmio,
                         WORD wFlags );

WORD APIENTRY mmioGetInfo( HMMIO hmmio,
                           PMMIOINFO pmmioinfo,
                           WORD wFlags );

DWORD APIENTRY mmioGetLastError( HMMIO hmmio );

PMMIOPROC APIENTRY mmioInstallIOProc( FOURCC fccIOProc,
                                      PMMIOPROC pIOProc,
                                      DWORD dwflags );

LONG APIENTRY mmioIOProc( PMMIOINFO pmmioinfo,
                          WORD wMsg,
                          LONG lParam1,
                          LONG lParam2 );

LONG APIENTRY mmioSendMessage( HMMIO hmmio,
                               WORD wMsg,
                               LONG lParam1,
                               LONG lParam2 );

WORD APIENTRY mmioSetBuffer( HMMIO hmmio,
                             PCHAR pchBuffer,
                             LONG cBytes,
                             WORD wFlags );

WORD APIENTRY mmioSetInfo( HMMIO hmmio,
                           PMMIOINFO pmmioinfo,
                           WORD wFlags );

FOURCC APIENTRY mmioStringToFOURCC( PSZ pszString,
                                    WORD wFlags );

/*
 * Compound File function prototypes:
 */

HMMCF APIENTRY mmioCFOpen( PSZ pszFileName,
                           PMMCFINFO pmmcfinfo,
                           PMMIOINFO pmmioinfo,
                           DWORD dwFlags );

DWORD APIENTRY mmioCFClose( HMMCF hmmcf,
                            DWORD dwFlags );

DWORD APIENTRY mmioCFGetInfo( HMMCF hmmcf,
                              PMMCFINFO pmmcfinfo,
                              DWORD cBytes );

DWORD APIENTRY mmioCFSetInfo( HMMCF hmmcf,
                              PMMCFINFO pmmcfinfo,
                              DWORD cBytes );

DWORD APIENTRY mmioCFFindEntry( HMMCF hmmcf,
                                PMMCTOCENTRY pmmctocentry,
                                DWORD dwFlags );

DWORD APIENTRY mmioCFAddEntry( HMMCF hmmcf,
                               PMMCTOCENTRY pmmctocentry,
                               DWORD dwFlags );

DWORD APIENTRY mmioCFChangeEntry( HMMCF hmmcf,
                                  PMMCTOCENTRY pmmctocentry,
                                  DWORD dwFlags );

DWORD APIENTRY mmioCFDeleteEntry( HMMCF hmmcf,
                                  PMMCTOCENTRY pmmctocentry,
                                  DWORD dwFlags );

DWORD APIENTRY mmioCFAddElement( HMMCF hmmcf,
                                 PSZ pszElementName,
                                 FOURCC fccType,
                                 PCHAR pchBuffer,
                                 LONG cchBytes,
                                 DWORD dwFlags );

DWORD APIENTRY mmioCFCopy( HMMCF hmmcfSource,
                           PSZ pszDestFileName,
                           DWORD dwFlags );

/*
 * Conversion Utility function prototypes:
 */

DWORD APIENTRY mmioQueryFormatCount( PMMFORMATINFO pmmformatinfo,
                                     PLONG plNumFormats,
                                     DWORD dwReserved,
                                     DWORD dwFlags );

DWORD APIENTRY mmioGetFormats( PMMFORMATINFO pmmformatinfo,
                               LONG lNumFormats,
                               PVOID pFormatInfoList,
                               PLONG plFormatsRead,
                               DWORD dwReserved,
                               DWORD dwFlags );

DWORD APIENTRY mmioGetFormatName( PMMFORMATINFO pmmformatinfo,
                                  PSZ pszFormatName,
                                  PLONG plBytesRead,
                                  DWORD dwReserved,
                                  DWORD dwFlags );

DWORD APIENTRY mmioIdentifyFile( PSZ pszFileName,
                                 PMMIOINFO pmmioinfo,
                                 PMMFORMATINFO pmmformatinfo,
                                 PFOURCC pfccStorageSystem,
                                 DWORD dwReserved,
                                 DWORD dwFlags );



DWORD APIENTRY mmioSetHeader( HMMIO hmmio,
                              PVOID pHeader,
                              LONG lHeaderLength,
                              PLONG plBytesWritten,
                              DWORD dwReserved,
                              DWORD dwFlags );

DWORD APIENTRY mmioIniFileHandler( PMMINIFILEINFO pmminifileinfo,
                                   DWORD dwFlags );

DWORD APIENTRY mmioIdentifyStorageSystem( PSZ pszFileName,
                                          PMMIOINFO pmmioinfo,
                                          PFOURCC pfccStorageSystem );

DWORD APIENTRY mmioDetermineSSIOProc( PSZ pszFileName,
                                      PMMIOINFO pmmioinfo,
                                      PFOURCC pfccStorageSystem,
                                      PSZ pszParsedRemainder );

DWORD APIENTRY mmioQueryIOProcModuleHandle( PMMIOPROC pIOProc,
                                            PHMODULE phmodIOProc );

ULONG APIENTRY mmioCFCompact( PSZ pszFileName, ULONG ulFlags );


/*
 * MMPMMMIO.INI file migration utility
 */

ULONG APIENTRY mmioMigrateIniFile( ULONG ulFlags );

/*
 * MMIO CODEC APIs
 */

#ifdef INCL_MMIO_CODEC

ULONG APIENTRY mmioIniFileCODEC( PCODECINIFILEINFO pCODECIniFileInfo,
                                 ULONG ulFlags );

ULONG APIENTRY mmioQueryCODECName( PCODECINIFILEINFO pCODECIniFileinfo,
                                  PSZ pszCODECName,
                                  PULONG pulBytesRead );

ULONG APIENTRY mmioQueryCODECNameLength( PCODECINIFILEINFO pCODECIniFileinfo,
                                         PULONG pulNameLength );


PCODECPROC  APIENTRY mmioLoadCODECProc( PCODECINIFILEINFO pCODECIniFileInfo,
                                      PHMODULE phMod, ULONG ulFlags );

USHORT APIENTRY mmioGetData( HMMIO hmmio,
                           PMMIOINFO pmmioinfo,
                           USHORT usFlags );

#endif

#pragma pack()

#endif /* _MMIO_H_ */


/******************
 * Defines:
 ******************/

/* Ultimotion CODEC type for CODECINIFILEINFO ulCompressType */
       FOURCC_ULTI       mmioFOURCC('U', 'L', 'T', 'I')
       HEX_FOURCC_ULTI   $49544C55L     /* ITLU */

/* Indeo CODEC type for CODECINIFILEINFO ulCompressType */
       FOURCC_RT21       mmioFOURCC('R', 'T', '2', '1')
       HEX_FOURCC_RT21   $31325452L     /* 12TR */

/* Mondo CODEC type for CODECINIFILEINFO ulCompressType */
       FOURCC_DIB        mmioFOURCC('D', 'I', 'B', ' ')
       HEX_FOURCC_DIB    $20424944L     /*  BID */

*)

TYPE
    PGENPAL=^GENPAL;
    GENPAL=RECORD
                 ulStartIndex:ULONG;
                 ulNumColors:ULONG;
                 prgb2Entries:PRGB2;
    END;

(*
/**********************************************
 *
 * CODECVIDEOHEADER - CODEC video Header
 *
 **********************************************/
typedef struct _CODECVIDEOHEADER {  /* codecvidhdr */
   ULONG  ulStructLen;
   ULONG  cx;
   ULONG  cy;
   USHORT cPlanes;
   USHORT cBitCount;
   ULONG  ulColorEncoding;
   GENPAL genpal;
} CODECVIDEOHEADER;
typedef CODECVIDEOHEADER *PCODECVIDEOHEADER;

/* ulColorEncoding defines: */
       MMIO_RGB_5_6_5    $0001L  /* Each pixel is a RGB_5_6_5 datatype */
       MMIO_RGB_24       $0002L  /* Each pixel is a RGB_24 datatype */
       MMIO_YUV_4_1_1    $0004L  /* Each pixel is a YUV_4_1_1 datatype */
       MMIO_COMPRESSED   $0008L  /* The data is compressed */
       MMIO_YUV_24       $0010L  /* Each pixel is a YUV_24 datatype */
       MMIO_PALETTIZED   $0020L  /* The data is palettized */
       MMIO_OS2_BITMAP24 $0020L  /* The data is palettized */


/**********************************************
 *
 * MMVIDEOOPEN - Video Open Structure
 *
 * This structure is passed on the CODEC open
 * message when video compression is being done
 * to indicate information such as quality,
 * frame rate, data rate, and key frame rate.
 *
 * Quality:
 *
 * The ulQuality field specifies a scalar value
 * in the range 0 - 10000, where 0 is the lowest
 * quality and 10000 is the highest quality.  A
 * value of -1 specifies the default quality level,
 * and the default quality level (e.g. 5000) is
 * returned in the ulQuality field.
 *
 *
 * Key Frame rate:
 *
 * The ulKeyFrameRate structure specifies the key
 * frame (aka I-frame, reference frame) frequency.
 * Every Nth frame is a key frame as specified.
 * A value of zero specifies that no periodic key
 * are to be compressed.  Additional key frames may
 * be inserted at any point by specifying
 * MMIO_IS_KEY_FRAME in the MMCOMPRESS structure.
 *
 * example:  ulKeyFrameRate = 5  results in:
 *
 *    key delta delta delta delta key delta delta delta delta key delta...
 *
 *
 * Frame rate:
 *
 * Rate = number of time units per second
 * Scale = number of time units per frame
 *
 * examples:  Rate = 30  Scale = 1     =>    30 FPS
 *            Rate = 15  Scale = 1     =>    15 FPS
 *            Rate = 25  Scale = 2     =>    12.5 FPS
 *
 *
 * Data Constraint:
 *
 * Compressors which are capable of constraining the
 * resultant compressed video data rate use the
 * information in the ulDataConstraint and
 * ulConstraintInterval fields.  A non-zero value
 * in ulDataConstraint specifies the number of bytes
 * which is not to be exceeded over an interval of
 * frames in the output data stream, regardless of
 * the requested quality level.  This value only
 * considers video data, i.e. audio data and file format
 * overhead must be considered seperately when determining
 * the final output file data rate.  The interval of
 * frames over which the data is constrained is specified
 * in ulConstraintInterval.  A value of zero for
 * ulDataContraint specifies that the data rate is not
 * to be constrained and is compressed according to
 * the requested quality level.
 *
 * example 1:  ulDataConstraint = 150000   ulConstraintInterval = 15
 *
 *             This results in an output stream wherein the sizes of any 15
 *             consecutive frames does not exceed 150000 bytes.  If the
 *             frame rate is 15 FPS, the resultant data rate will not
 *             exceed 150000 bytes per second.
 *
 * example 2:  ulDataConstraint = 10000    ulConstraintInterval = 1
 *
 *             This results in an output stream wherein any single frame
 *             does not exceed 10000 bytes.  If the frame rate is 15 FPS,
 *             the resultant data rate will not exceed 150000 bytes per
 *             second.  Note the difference between this case and example 1
 *             where individual frames may exceed 10000 bytes (the average)
 *             so long other frames in any 15 frame sequence are sufficiently
 *             smaller to satisfy the constraint within the constraint interval.
 *
 **********************************************/
typedef struct _MMVIDEOOPEN  {      /* mmvidopen */
   ULONG       ulStructLen;
   ULONG       ulQuality;
   ULONG       ulKeyFrameRate;
   ULONG       ulScale;
   ULONG       ulRate;
   ULONG       ulDataConstraint;
   ULONG       ulConstraintInterval;
   } MMVIDEOOPEN;
typedef MMVIDEOOPEN *PMMVIDEOOPEN;

#endif


typedef struct _MMAUDIOOPEN
  {
  ULONG   ulStructLen;         /* Length of struct */
  ULONG   ulSamplesPerBlock;   /* Samples in each block of compressed data */
  ULONG   ulBytesPerBlock;     /* uncompressed bytes in each block */
  ULONG   ulFlags;             /* Compression flags */
  ULONG   ulBestGuess;         /* Guess at avg. compression ratio */
  ULONG   ulBlockAlignment;    /* Block alignment of codec */
  ULONG   ulLength;            /* Length of the file */
  ULONG   hCodec;              /* Codec handle */
  PCODECPROC pfnCodec;
  } MMAUDIOOPEN;

typedef MMAUDIOOPEN    *PMMAUDIOOPEN;


/* defines for the ulFlags field of the BUFER_INFORMATION */
      BLOCK_ORIENTED        $00000001
      NON_LINEAR            $00000002
      INIT_CODEC            $00000004



/**********************************************
 *
 * CODECOPEN - CODEC open structure
 *
 **********************************************/
typedef struct _CODECOPEN  {        /* codecopen */
   ULONG       ulFlags;             /* flags & events - Refer to ulCapsFlags in CODECINIFILEINFO */
   PVOID       pControlHdr;         /* control header - (codec specific) */
   PVOID       pSrcHdr;             /* source header - Ptr CODECVIDEOHEADER */
   PVOID       pDstHdr;             /* destination header - Ptr CODECVIDEOHEADER */
   PVOID       pOtherInfo;          /* other information - Ptr MMVIDEOOPEN/MMAUDIOOPEN */
   } CODECOPEN;
typedef CODECOPEN *PCODECOPEN;

      VALID_CODECOPEN_INPUTFLAGS   (CODEC_DECOMPRESS |       \
                                      CODEC_WINDOW_CLIPPING |  \
                                      CODEC_PALETTE_TRANS |    \
                                      CODEC_SELFHEAL |         \
                                      CODEC_SCALE_PEL_DOUBLE | \
                                      CODEC_SCALE_PEL_HALVED | \
                                      CODEC_SCALE_CONTINUOUS | \
                                      CODEC_MULAPERTURE |      \
                                      CODEC_HARDWARE |         \
                                      CODEC_DIRECT_DISPLAY)


#ifdef INCL_AUDIO_CODEC


/* Stream handler communication */

typedef struct _AUDIO_CODEC_INFO
  {
  ULONG   ulStructLen;         /* Length of struct */
  ULONG   ulBytesPerBlock;     /* uncompressed bytes in each block */
  ULONG   ulBlockAlignment;    /* Block alignment of codec */
  ULONG   hCodec;              /* Codec handle */
  PCODECPROC  pfnCodec;
/*  LONG (* APIENTRY pfnCodec) (PVOID, SHORT, LONG, LONG); */
  } AUDIO_CODEC_INFO;

       AUDIO_CODEC_INF    1000

#endif

/**********************************************
 *
 * MMCOMPRESS - Compress structure
 *
 **********************************************/
typedef struct _MMCOMPRESS  {     /* mmcomp */
   ULONG       ulStructLen;       /* length of this structure */
   ULONG       ulFlags;           /* command and status flags */
   ULONG       ulSrcBufLen;       /* source buffer size */
   PVOID       pSrcBuf;           /* source buffer */
   ULONG       ulDstBufLen;       /* destination buffer length */
   PVOID       pDstBuf;           /* destination buffer */
   PVOID       pRunTimeInfo;      /* control information */
   } MMCOMPRESS;
typedef MMCOMPRESS *PMMCOMPRESS;

/* ulFlags Input values for MMCOMPRESS structure:                */
/* Note:  MMIO_IS_KEY_FRAME and MMIO_IS_PALETTE are defined      */
/* below, but are listed here for information purposes only.     */
/* MMIO_IS_KEY_FRAME         This bit is set by the application  */
/*                           to instruct the IOProc to compress  */
/*                           the pSrcBuf into a key or reference */
/*                           frame.  If the bit is not set, a    */
/*                           delta frame is compressed.          */
/* MMIO_IS_PALETTE           A video palette is provided.  This  */
/*                           is set by the application.          */


/**********************************************
 *
 * MMVIDEOCOMPRESS - Video Compress structure
 *
 **********************************************/
#ifndef INCL_AUDIO_CODEC_ONLY

typedef struct _MMVIDEOCOMPRESS { /* mmvidcomp */
   ULONG       ulStructLen;       /* Structure length */
   GENPAL      genpalVideo;       /* Video stream palette */
   PVOID       pControlHdr;       /* control header (codec specific) */
   } MMVIDEOCOMPRESS;
typedef MMVIDEOCOMPRESS *PMMVIDEOCOMPRESS;

#endif


#ifdef INCL_AUDIO_CODEC

        START_DECOMPRESSION     $00000001
        CONTINUE_DECOMPRESSION  $00000002
        START_SEEK              $00000004
        CONTINUE_SEEK           $00000008

#endif

/**********************************************
 *
 * MMDECOMPRESS - Decompress Structure
 *
 **********************************************/
typedef struct _MMDECOMPRESS  {   /* mmdec */
   ULONG       ulStructLen;       /* length of this structure */
   ULONG       ulFlags;           /* command and status flags */
   ULONG       ulSrcBufLen;       /* source buffer size */
   PVOID       pSrcBuf;           /* source buffer */
   ULONG       ulDstBufLen;       /* destination buffer length */
   PVOID       pDstBuf;           /* destination buffer */
   PVOID       pRunTimeInfo;      /* control information Ptr to MMVIDEODECOMPRESS */
   } MMDECOMPRESS;
typedef MMDECOMPRESS *PMMDECOMPRESS;

/* ulFlags defines: */
      MMIO_DROP_DELTA_FRAME $0001L /* Input/Output - Tells the IOProc to drop the delta */
                                      /* frame if the pSrcBuf contains a delta */
                                      /* frame.  On return, the bit is reset */
                                      /* if the delta frame is dropped. */
      MMIO_IS_KEY_FRAME     $0002L /* Output - This bit is set by the IOProc when */
                                      /* the data contained in the pSrcBuf is */
                                      /* a key or reference frame. */
      MMIO_IS_PALETTE       $0004L /* Output - A video palette has been found. */
                                      /* This is set by the IOProc. */
      MMIO_PALETTE_CHANGE   $0008L /* Input - The physical palette has been changed */
                                      /* in...  This is set by the application. */
      MMIO_ORIGIN_LOWERLEFT $0010L /* Input - The video frame origin */
      MMIO_RECTL_CHANGE     $0020L /* Input - The valid rectl list has changed. */
      MMIO_ORIGIN_UPPERLEFT $0040L /* Input - The video frame origin */
      MMIO_DROP_FRAME_DECODE $0080L /* Input - Tells the IOProc to drop decoding  */
      MMIO_HIGH_QUALITY      $0100L /* Input - Tells Codec to render best */
                                       /* quality image - not time critical */
      MMIO_IGNORE_CLIPPING   $0200L /* Ignore clipping rectangles used for bitmap capture */
                                       /* high performance */
      MMIO_OUTPUT_FULL_IMAGE $0400L /* Output a complete image on decompress, even if this*/
                                       /* is a delta frame */
                                      /* of the frame.                         */

      VALID_DECOMPRESS_INPUTFLAGS   (MMIO_DROP_DELTA_FRAME | \
                                       MMIO_PALETTE_CHANGE |   \
                                       MMIO_ORIGIN_LOWERLEFT | \
                                       MMIO_RECTL_CHANGE |     \
                                       MMIO_DROP_FRAME_DECODE | \
                                       MMIO_ORIGIN_UPPERLEFT | \
                                       MMIO_HIGH_QUALITY | \
                                       MMIO_IGNORE_CLIPPING | \
                                       MMIO_OUTPUT_FULL_IMAGE)


#ifdef INCL_AUDIO_CODEC

        START_COMPRESSION     $00000001
        CONTINUE_COMPRESSION  $00000002
        SOURCE_UNUSED         $00000004
        TARGET_UNUSED         $00000008


#endif


/**********************************************
 *
 * MMVIDEODECOMPRESS - Video Decompress structure
 *
 **********************************************/
#ifndef INCL_AUDIO_CODEC_ONLY
typedef struct _MMVIDEODECOMPRESS {    /* mmviddec */
   ULONG       ulStructLen;            /* Structure length */
   ULONG       ulRectlCount;           /* Valid rectangle count - for clipping */
   PRECTL      prectl;                 /* Valid rectangle array - for clipping */
   ULONG       ulSkipLength;           /* Skipped line length */
   ULONG       ulDecodeLines;          /* Num of lines to decompress */
   GENPAL      genpalPhysical;         /* Physical palette */
   GENPAL      genpalVideo;            /* Video stream palette */
   RECTL       rectlSrc;               /* Source window rectangle */
   RECTL       rectlDst;               /* Destination window rectangle */
   ULONG       ulDeltaCount;           /* Number of remaining delta frames before the next I-Frame */
   ULONG       ulParm1;                /* Codec specific parm */
   ULONG       ulParm2;                /* Codec specific parm */
   ULONG       ulParm3;                /* Codec specific parm */
   ULONG       ulParm4;                /* Codec specific parm */
   } MMVIDEODECOMPRESS;
typedef MMVIDEODECOMPRESS *PMMVIDEODECOMPRESS;

#endif
/*************************************************
 *
 * RECORDTAB - Record table
 *
 * NOTE: This structure maps to ESRCBUFTAB in ssm.h
 *************************************************/
typedef struct _RECORDTAB {       /* recordtab */
   ULONG       ulReserved1;       /* reserved for system */
   PVOID       pRecord;           /* ptr to record in buffer */
   ULONG       ulLength;          /* length of record */
   ULONG       ulReserved2;       /* reserved for system */
   ULONG       ulReserved3;       /* reserved for system */
   ULONG       ulParm1;           /* Record specific data */
   ULONG       ulParm2;           /* Record specific data */
   } RECORDTAB;
typedef RECORDTAB FAR *PRECORDTAB;/* Ptr to a buffer entry  */


/***************************************************
 *
 * RECORDTABWRITE - Record table for video write
 *
 * NOTE: This structure maps to ETGTBUFTAB in ssm.h
 ***************************************************/
typedef struct _RECORDTABWRITE {       /* recordtab */
   PVOID       pRecord;           /* ptr to record in buffer */
   ULONG       ulReserved1;       /* reserved for system */
   ULONG       ulLength;          /* length of record */
   ULONG       ulReserved2;       /* reserved for system */
   ULONG       ulReserved3;       /* reserved for system */
   ULONG       ulParm1;           /* Record specific data */
   ULONG       ulParm2;           /* Record specific data */
   } RECORDTABWRITE;
typedef RECORDTABWRITE FAR *PRECORDTABWRITE;/* Ptr to a buffer entry  */


/* ulParm1 Return values for MULTITRACK_READ only:               */
/* Note:  MMIO_IS_KEY_FRAME and MMIO_IS_PALETTE are defined      */
/* above, but are listed here for information purposes only      */
/* as they are valid ulParm1 Return values for MULTITRACK_READ.  */
/* MMIO_IS_KEY_FRAME         Frame is a Key frame                */
/* MMIO_IS_PALETTE           Buffer contains a video palette     */
      MMIO_INVISIBLE_FRAME   $1000L    /* Indicates a invisible video frame */
      MMIO_NULL_FRAME        $2000L    /* Indicates a null video frame (zero length) */

/* ulParm2 Return values for MULTITRACK_READ only:               */
/*    This field contains the frame number for this video frame  */
/*    if this track is a video track.                            */



/* ulParm1 Input values for MULTITRACK_WRITE only:               */
/* Note:  MMIO_IS_KEY_FRAME and MMIO_IS_PALETTE are defined      */
/* above, but are listed here for information purposes only      */
/* as they are valid ulParm1 Input values for MULTITRACK_WRITE.  */
/* MMIO_IS_KEY_FRAME         Frame is a Key frame                */
/* MMIO_IS_PALETTE           Buffer contains a video palette     */

/* ulParm2 Input values for MULTITRACK_WRITE only:               */
/*    This field contains the number of null frames              */
/*    that should be inserted before this frame                  */
/*    (this recordtab entry).                                    */


/************************************************
 *
 *  TRACKMAP - This structure maps a track to
 *             a record table.
 *
 ************************************************/
typedef struct _TRACKMAP {        /* trackmap */
   ULONG       ulTrackID;         /* Input - track ID */
   ULONG       ulNumEntries;      /* Input - number of record entries */
   PRECORDTAB  pRecordTabList;    /* Input/Output - Ptr to a record table */
   } TRACKMAP;
typedef TRACKMAP *PTRACKMAP;      /* Ptr to a track map table entry */



#ifndef INCL_AUDIO_CODEC_ONLY

/**********************************************
 *
 * MMMULTITRACKREAD - Multiple Track Read
 *
 **********************************************/
typedef struct _MMMULTITRACKREAD  {   /* mtread */
   ULONG       ulLength;          /* Input - Size of buffer to read.  The IO should be performed on this size of  */
                                  /*          buffer.  The actual buffer size may be bigger and is given in the   */
                                  /*          ulBufferLength field below.  Video frames can span pBuffer+ulLength */
                                  /*          as long as the frame is less than the ulBufferLength in size.       */
                                  /*          The purpose of this is to break the IO reads into smaller sizes     */
                                  /*          while still allowing large frame sizes.                             */
   PVOID       pBuffer;           /* Input - ptr to read buffer           */
   ULONG       ulFlags;           /* Input/Output - read flags            */
   ULONG       ulNumTracks;       /* Input - number of track entries      */
   PTRACKMAP   pTrackMapList;     /* Input - ptr to track-to-record list  */
/* End of old MMMULTITRACKREAD structure */
   ULONG       ulBufferLength;    /* Input - Actual length of read buffer */
   ULONG       ulReserved;        /* Input - Reserved (must be 0)         */
   } MMMULTITRACKREAD;
typedef MMMULTITRACKREAD *PMMMULTITRACKREAD;

/* ulFlags Input Values: */
      MULTITRACKREAD_EXTENDED       $0004L /* Indicates that the new extended multitrack   */
                                              /* read structure is passed from caller instead */
                                              /* of the previous multitrack read structure.   */

/* ulFlags Return Values: */
      MULTITRACKREAD_NOTDONE        $0001L /* Read is not done.  Another read of the same        */
                                              /* buffer is necessary.  There were not enough record */
                                              /* entries in the record table passed to this api.    */
      MULTITRACKREAD_EOF            $0002L /* End of File.  Used because # bytes read may not    */
                                              /* match the length of the buffer in cases of a       */
                                              /* record that spans in the next buffer.              */


/**********************************************
 *
 * MMMULTITRACKWRITE - Multiple Track Write
 *
 **********************************************/
typedef struct _MMMULTITRACKWRITE  {   /* mtwrite */
   ULONG       ulNumTracks;       /* Input - number of track entries     */
   PTRACKMAP   pTrackMapList;     /* Input - ptr to track-to-record list */
   ULONG       ulFlags;           /* Input - write flags (Default = 0)   */
   ULONG       ulReserved;        /* Input - Reserved (must be 0)        */
   } MMMULTITRACKWRITE;
typedef MMMULTITRACKWRITE *PMMMULTITRACKWRITE;

/* ulFlags Input Values: */
      MULTITRACKWRITE_MERGE        $0001L /* Attempt to interleave the data on the write. */
                                             /* The default (without this flag set) is to    */
                                             /* write all records for each track then write  */
                                             /* all records of the next track and so on.     */

*)
TYPE
    PMMMOVIEHEADER=^MMMOVIEHEADER;
    MMMOVIEHEADER=RECORD
                        ulStructLen:LONGWORD;
                        ulContentType:LONGWORD;
                        ulMediaType:LONGWORD;
                        ulMovieCapsFlags:LONGWORD;
                        ulMaxBytesPerSec:LONGWORD;
                        ulPaddingGranularity:LONGWORD;
                        ulSuggestedBufferSize:LONGWORD;
                        ulStart:LONGWORD;
                        ulLength:LONGWORD;
                        ulNextTrackID:LONGWORD;
                        ulNumEntries:LONGWORD;
                        pmmTrackInfoList:PMMTRACKINFO;
                        pszMovieTitle:PChar;
                        ulCountry:LONGWORD;
                        ulCodePage:LONGWORD;
                        ulAvgBytesPerSec:LONGWORD;
   END;

CONST
       MOVIE_HAS_VIDEO         =$0001;
       MOVIE_HAS_AUDIO         =$0002;
       MOVIE_CAN_SEEK          =$0004;
       MOVIE_CAN_SCAN          =$0008;
       MOVIE_HAS_COPYRIGHT     =$0010;
       MOVIE_WAS_CAPTUREFILE   =$0020;

TYPE
    PMMVIDEOHEADER=^MMVIDEOHEADER;
    MMVIDEOHEADER=RECORD
                        ulStructLen:LONGWORD;
                        ulContentType:LONGWORD;
                        ulMediaType:LONGWORD;
                        ulVideoCapsFlags:LONGWORD;
                        ulWidth:LONGWORD;
                        ulHeight:LONGWORD;
                        ulScale:LONGWORD;
                        ulRate:LONGWORD;
                        ulStart:LONGWORD;
                        ulLength:LONGWORD;
                        ulTotalFrames:LONGWORD;
                        ulInitialFrames:LONGWORD;
                        mmtimePerFrame:MMTIME;
                        ulSuggestedBufferSize:LONGWORD;
                        genpalVideo:GENPAL;
                        pmmXDIBHeader:PMMXDIBHEADER;
    END;

CONST MMIO_VIDEO_UNKNOWN          =$00000000;
      MMIO_VIDEO_DATA             =$00000001;

      MCI_TRUE                    =    1;
      MCI_FALSE                   =    0;

      MCI_OPEN                    =    1;
      MCI_CLOSE                   =    2;
      MCI_ESCAPE                  =    3;
      MCI_PLAY                    =    4;
      MCI_SEEK                    =    5;
      MCI_STOP                    =    6;
      MCI_PAUSE                   =    7;
      MCI_INFO                    =    8;
      MCI_GETDEVCAPS              =    9;
      MCI_STATUS                  =    10;
      MCI_SPIN                    =    11;
      MCI_SET                     =    12;
      MCI_STEP                    =    13;
      MCI_RECORD                  =    14;
      MCI_SYSINFO                 =    15;
      MCI_SAVE                    =    16;
      MCI_CUE                     =    17;
      MCI_UPDATE                  =    18;
      MCI_SET_CUEPOINT            =    19;
      MCI_SET_POSITION_ADVISE     =    20;
      MCI_SET_SYNC_OFFSET         =    21;
      MCI_LOAD                    =    22;
      MCI_ACQUIREDEVICE           =    23;
      MCI_RELEASEDEVICE           =    24;
      MCI_MASTERAUDIO             =    25;
      MCI_GETTOC                  =    26;
      MCI_DEVICESETTINGS          =    27;
      MCI_CONNECTOR               =    28;
      MCI_RESUME                  =    29;
      MCI_CONNECTORINFO           =    31;
      MCI_DEFAULT_CONNECTION      =    32;
      MCI_CONNECTION              =    33;
      MCI_GROUP                   =    34;

      MCI_CAPTURE                 =    40;
      MCI_FREEZE                  =    41;
      MCI_GETIMAGEBUFFER          =    42;
      MCI_GETIMAGEPALETTE         =    43;
      MCI_PUT                     =    44;
      MCI_REALIZE                 =    45;
      MCI_REWIND                  =    46;
      MCI_RESTORE                 =    47;
      MCI_SETIMAGEBUFFER          =    48;
      MCI_SETIMAGEPALETTE         =    49;
      MCI_UNFREEZE                =    50;
      MCI_WHERE                   =    51;
      MCI_WINDOW                  =    52;

      MCI_DELETE                  =    53;
      MCI_CUT                     =    54;
      MCI_PASTE                   =    55;
      MCI_COPY                    =    56;
      MCI_REDO                    =    57;
      MCI_UNDO                    =    58;
      MCI_MIXNOTIFY               =    59;
      MCI_SETTUNER                =    60;
      MCI_MAX_COMMAND             =    60;

(*
      RECT                            ULONG
      HDCT                            ULONG

      MCI_USER_MESSAGES               2000

/*********************************************************************/
/* Special Device ID for "all"                                       */
/*********************************************************************/
      MCI_ALL_DEVICE_ID               $FFFF

/*********************************************************************/
/* MCI implementation limits                                         */
/*********************************************************************/
      MAX_DEVICE_NAME                 20
      MAX_ALIAS_NAME                  20
      MAX_PRODINFO                    40
      MAX_EXTENSION_NAME              4
      MAX_DEV_PARAMS                  128
      MAX_VERSION_NUMBER              6
      MAX_PDD_NAME                    9
      MAX_DLL_NAME                    260
      MAX_CLASSES                     10
      MAX_CONNECTORS                  10
      MAX_EXTENSIONS                  25
      MAX_TYPEBUFFER                  256

#ifdef INCL_32
*)
/*********************************************************************/
/* MCI Device Type Constants                                         */
/*********************************************************************/
Const MCI_DEVTYPE_VIDEOTAPE         = 1;
      MCI_DEVTYPE_VIDEODISC         = 2;
      MCI_DEVTYPE_CD_AUDIO          = 3;
      MCI_DEVTYPE_DAT               = 4;
      MCI_DEVTYPE_AUDIO_TAPE        = 5;
      MCI_DEVTYPE_OTHER             = 6;
      MCI_DEVTYPE_WAVEFORM_AUDIO    = 7;
      MCI_DEVTYPE_SEQUENCER         = 8;
      MCI_DEVTYPE_AUDIO_AMPMIX      = 9;
      MCI_DEVTYPE_OVERLAY           = 10;
      MCI_DEVTYPE_ANIMATION         = 11;
      MCI_DEVTYPE_DIGITAL_VIDEO     = 12;
      MCI_DEVTYPE_SPEAKER           = 13;
      MCI_DEVTYPE_HEADPHONE         = 14;
      MCI_DEVTYPE_MICROPHONE        = 15;
      MCI_DEVTYPE_MONITOR           = 16;
      MCI_DEVTYPE_CDXA              = 17;

(*
/*********************************************************************/
/* MCI Device Type Names                                             */
/*********************************************************************/
      MCI_DEVTYPE_VIDEOTAPE_NAME          "Videotape"
      MCI_DEVTYPE_VIDEODISC_NAME          "Videodisc"
      MCI_DEVTYPE_CD_AUDIO_NAME           "CDaudio"
      MCI_DEVTYPE_DAT_NAME                "DAT"
      MCI_DEVTYPE_AUDIO_TAPE_NAME         "Audiotape"
      MCI_DEVTYPE_OTHER_NAME              "Other"
      MCI_DEVTYPE_WAVEFORM_AUDIO_NAME     "Waveaudio"
      MCI_DEVTYPE_SEQUENCER_NAME          "Sequencer"
      MCI_DEVTYPE_AUDIO_AMPMIX_NAME       "Ampmix"
      MCI_DEVTYPE_OVERLAY_NAME            "Overlay"
      MCI_DEVTYPE_ANIMATION_NAME          "Animation"
      MCI_DEVTYPE_DIGITAL_VIDEO_NAME      "Digitalvideo"
      MCI_DEVTYPE_SPEAKER_NAME            "Speaker"
      MCI_DEVTYPE_HEADPHONE_NAME          "Headphone"
      MCI_DEVTYPE_MICROPHONE_NAME         "Microphone"
      MCI_DEVTYPE_MONITOR_NAME            "Monitor"
      MCI_DEVTYPE_CDXA_NAME               "CDXA"

      MCI_MAX_SYSTEM_DEVICE_NAMES         17

#endif                       /* INCL_32 */

/*********************************************************************/
/* Getdevcaps, set, and status item base values                      */
/*********************************************************************/

      MCI_AMP_ITEM_BASE                   $00001000L
      MCI_CD_ITEM_BASE                    $00002000L
      MCI_CDXA_ITEM_BASE                  $00003000L
      MCI_VD_ITEM_BASE                    $00004000L
      MCI_SEQ_ITEM_BASE                   $00005000L
      MCI_WAVE_ITEM_BASE                  $00006000L
      MCI_VID_ITEM_BASE                   $00007000L
      MCI_DGV_ITEM_BASE                   $00008000L
      MCI_OVLY_ITEM_BASE                  $00009000L
*)
CONST
      MCI_NOTIFY_SUCCESSFUL          =     $0000;
      MCI_NOTIFY_SUPERSEDED          =     $0001;
      MCI_NOTIFY_ABORTED             =     $0002;
      MCI_NOTIFY_ERROR               =     $0003;

CONST
      MM_MCINOTIFY                   =     $0500;
      MM_MCIPASSDEVICE               =     $0501;
      MM_MCIPOSITIONCHANGE           =     $0502;
      MM_MCICUEPOINT                 =     $0503;
      MM_MCIPLAYLISTMESSAGE          =     $0504;
      MM_MCIEVENT                    =     $0505;
      MM_MCISYNCH                    =     $0506;

      MCI_LOSING_USE                 =     $00000001;
      MCI_GAINING_USE                =     $00000002;

      MCI_NOTIFY                     =     $00000001;
      MCI_WAIT                       =     $00000002;
      MCI_FROM                       =     $00000004;
      MCI_TO                         =     $00000008;
      MCI_MILLISECONDS               =     $00000010;
      MCI_TRACK                      =     $00000020;
      MCI_OVER                       =     $00000040;
      MCI_TEST                       =     $00000080;
      MCI_TO_BUFFER                  =     $00000100;
      MCI_FROM_BUFFER                =     $00000200;
      MCI_CONVERT_FORMAT             =     $00000400;


      MCI_FORMAT_MILLISECONDS        =     $00000001;
      MCI_FORMAT_MMTIME              =     $00000002;
      MCI_FORMAT_MSF                 =     $00000005;
      MCI_FORMAT_TMSF                =     $00000006;
      MCI_FORMAT_CHAPTERS            =     $00000007;
      MCI_FORMAT_FRAMES              =     $00000008;
      MCI_FORMAT_HMS                 =     $00000009;
      MCI_FORMAT_TRACKS              =     $0000000A;
      MCI_FORMAT_BYTES               =     $0000000B;
      MCI_FORMAT_SAMPLES             =     $0000000C;
      MCI_FORMAT_HMSF                =     $0000000D;
      MCI_FORMAT_SET_SMPTE_24        =     $0000000E;
      MCI_FORMAT_SET_SMPTE_25        =     $0000000F;
      MCI_FORMAT_SET_SMPTE_30        =     $00000010;
      MCI_FORMAT_SET_SMPTE_30DROP    =     $00000011;
      MCI_FORMAT_SET_SONGPTR         =     $00000012;
      MCI_FORMAT_USEC                =     $00000013;

      MCI_FORMAT_PERCENTAGE          =     $00000003;
      MCI_FORMAT_FPS                 =     $00000004;

(*
/*********************************************************************/
/*                                                                   */
/*  Time format conversions macros                                   */
/*                                                                   */
/*********************************************************************/
      MSECTOMM(value)      (((value) > ($FFFFFFFF /3)) ? 0L : \
                              ((value) * 3))

      MSECFROMMM(value)    (((value)+1) / 3)

      REDBOOKTOMM(value)   ((((value) & $000000FF) * 60 * 3000) + \
                              (((value) & $0000FF00) / $100 * 3000) + \
                              (((value) & $00FF0000) / $10000 * 3000/75))

      FPS24TOMM(value) ((((value) & $000000FF) * 60 * 60 * 3000) + \
                          (((value) & $0000FF00) / $100 * 60 * 3000) + \
                          (((value) & $00FF0000) / $10000 * 3000) + \
                          (((value) & $FF000000) / $1000000 * 3000/24))

      FPS25TOMM(value) ((((value) & $000000FF) * 60 * 60 * 3000) + \
                          (((value) & $0000FF00) / $100 * 60 * 3000) + \
                          (((value) & $00FF0000) / $10000 * 3000) + \
                          (((value) & $FF000000) / $1000000 * 3000/25))

      FPS30TOMM(value) ((((value) & $000000FF) * 60 * 60 * 3000) + \
                          (((value) & $0000FF00) / $100 * 60 * 3000) + \
                          (((value) & $00FF0000) / $10000 * 3000) + \
                          (((value) & $FF000000) / $1000000 * 3000/30))

      HMSTOMM(value)   ((((value) & $000000FF) * 60 * 60 * 3000) + \
                          (((value) & $0000FF00) / $100 * 60 * 3000) + \
                          (((value) & $00FF0000) / $10000 * 3000))


  /* The +20 is used for rounding purposes.  It is derived by:           */
  /*   1/2 * ((300 MMTIME/SEC / (75 FRAMES/SEC)) = 20 MMTIME/HALF-FRAME  */
      REDBOOKFROMMM(value) ((((value)+20) >= $100*60*3000) ? 0L : \
                              ((((value)+20) / (60*3000)) + \
                               (((value)+20) % (60*3000) / 3000 << 8) + \
                               (((value)+20) / (3000/75) % 75 << 16)))

      FPS24FROMMM(value) ((((value)+63) >= $100*60*60*3000) ? 0L : \
                        (((((((value)+63) % 3000)/(3000/24)) << 24) & $FF000000) | \
                         ((((((value)+63) / 3000) % 60) << 16) & $00FF0000)      | \
                        (((((((value)+63) / 3000) / 60) % 60) << 8) & $0000FF00) | \
                         ((((((value)+63) / 3000) / 60) / 60)  & $000000FF)))

      FPS25FROMMM(value) ((((value)+60) >= $100*60*60*3000) ? 0L : \
                        (((((((value)+60) % 3000)/(3000/25)) << 24) & $FF000000) | \
                         ((((((value)+60) / 3000) % 60) << 16) & $00FF0000)      | \
                        (((((((value)+60) / 3000) / 60) % 60) << 8) & $0000FF00) | \
                         ((((((value)+60) / 3000) / 60) / 60)  & $000000FF)))

      FPS30FROMMM(value) ((((value)+50) >= $100*60*60*3000) ? 0L : \
                        (((((((value)+50) % 3000)/(3000/30)) << 24) & $FF000000) | \
                         ((((((value)+50) / 3000) % 60) << 16) & $00FF0000)      | \
                        (((((((value)+50) / 3000) / 60) % 60) << 8) & $0000FF00) | \
                         ((((((value)+50) / 3000) / 60) / 60)  & $000000FF)))

      HMSFROMMM(value) ((((value)+50) >= $100*60*60*3000) ? 0L : \
                        (((((((value)+50) / 3000) % 60) << 16) & $00FF0000)      | \
                        (((((((value)+50) / 3000) / 60) % 60) << 8) & $0000FF00) | \
                         ((((((value)+50) / 3000) / 60) / 60)  & $000000FF)))

      TMSF_TRACK(time)     (*(BYTE * )(&(time)))
      TMSF_MINUTE(time)    (*((BYTE * )(&(time))+1))
      TMSF_SECOND(time)    (*((BYTE * )(&(time))+2))
      TMSF_FRAME(time)     (*((BYTE * )(&(time))+3))
      MSF_MINUTE(time)     (*(BYTE * )(&(time)))
      MSF_SECOND(time)     (*((BYTE * )(&(time))+1))
      MSF_FRAME(time)      (*((BYTE * )(&(time))+2))

/*********************************************************************/
/*                                                                   */
/*  BYTE ACCESS WITH A DWORD MACROS                                  */
/*                                                                   */
/*********************************************************************/
      ULONG_LWLB(ul)  (*(BYTE * )((ULONG * )(&ul)))       /* Low  Word Low Byte  */
      ULONG_LWHB(ul)  (*((BYTE * )((ULONG * )(&ul))+1))   /* Low  Word High Byte */
      ULONG_HWLB(ul)  (*((BYTE * )((ULONG * )(&ul))+2))   /* High Word Low Byte  */
      ULONG_HWHB(ul)  (*((BYTE * )((ULONG * )(&ul))+3))   /* High Word High Byte */
      ULONG_LOWD(ul)  (*(USHORT * )((ULONG * )(&ul)))     /* Low  Word           */
      ULONG_HIWD(ul)  (*((USHORT * )((ULONG * )(&ul))+1)) /* High Word           */

#ifdef INCL_32

#pragma pack(1)

/*********************************************************************/
/* parameters for default command messages with empty parameter lists*/
/*********************************************************************/
typedef struct _MCI_GENERIC_PARMS {
    HWND   hwndCallback;      /* PM window handle for MCI notify message */
} MCI_GENERIC_PARMS;
typedef MCI_GENERIC_PARMS   *PMCI_GENERIC_PARMS;

*)

// Parameters for default command messages with empty parameter lists
type
  pmci_Generic_Parms = ^mci_Generic_Parms;
  mci_Generic_Parms = record
    hwndCallback : hwnd;
  end;

/*********************************************************************/
/* flags for the MCI_ACQUIREDEVICE message                           */
/*     $0000$00 are reserved for MCI_ACQUIREDEVICE flags           */
/*********************************************************************/
Const MCI_EXCLUSIVE                     = $00000100;
      MCI_EXCLUSIVE_INSTANCE            = $00000200;
      MCI_ACQUIRE_QUEUE                 = $00000400;


/*********************************************************************/
/* flags for the MCI_CAPTURE message                                 */
/*     $000$X00 are reserved for MCI_CAPTURE flags                 */
/*     MCI_CONVERT is used by MCI_GETIMAGEBUFFER, MCI_SETIMAGEBUFFER */
/*                            MCI_CAPTURE, and MCI_RESTORE           */
/*********************************************************************/
      MCI_CAPTURE_RECT                  = $00000100;
      MCI_CONVERT                       = $00001000;

(*
/*********************************************************************/
/* parameter structure for the MCI_CAPTURE message                   */
/*********************************************************************/
typedef struct _MCI_CAPTURE_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message  */
    RECTL   rect;            /* Rectangle array specifying the area to   */
                             /* be captured                              */
} MCI_CAPTURE_PARMS;
typedef MCI_CAPTURE_PARMS   *PMCI_CAPTURE_PARMS;

*)
/*********************************************************************/
/* flags for MCI_CONNECTOR and MCI_CONNECTION messages               */
/*********************************************************************/
Const MCI_ENABLE_CONNECTOR              = $00000100;
      MCI_DISABLE_CONNECTOR             = $00000200;
      MCI_QUERY_CONNECTOR_STATUS        = $00000400;
      MCI_CONNECTOR_TYPE                = $00000800;
      MCI_CONNECTOR_INDEX               = $00001000;
      MCI_TO_CONNECTOR_INDEX            = $00002000;
      MCI_TO_CONNECTOR_TYPE             = $00004000;
      MCI_QUERY_CONNECTION              = $00008000;
      MCI_MAKE_CONNECTION               = $00010000;
      MCI_BREAK_CONNECTION              = $00020000;
      MCI_ENUMERATE_CONNECTORS          = $00040000;
      MCI_QUERY_CONNECTOR_TYPE          = $00080000;
      MCI_QUERY_VALID_CONNECTION        = $00100000;
      MCI_CONNECTOR_ALIAS               = $00200000;


/*********************************************************************/
/* Connector types                                                   */
/*********************************************************************/
Const MCI_MIDI_STREAM_CONNECTOR         = $00000001;
      MCI_CD_STREAM_CONNECTOR           = $00000002;
      MCI_WAVE_STREAM_CONNECTOR         = $00000003;
      MCI_AMP_STREAM_CONNECTOR          = $00000004;
      MCI_XA_STREAM_CONNECTOR           = $00000005;
      MCI_HEADPHONES_CONNECTOR          = $00000006;
      MCI_SPEAKERS_CONNECTOR            = $00000007;
      MCI_MICROPHONE_CONNECTOR          = $00000008;
      MCI_LINE_IN_CONNECTOR             = $00000009;
      MCI_LINE_OUT_CONNECTOR            = $0000000a;
      MCI_VIDEO_IN_CONNECTOR            = $0000000b;
      MCI_VIDEO_OUT_CONNECTOR           = $0000000c;
      MCI_PHONE_SET_CONNECTOR           = $0000000d;
      MCI_PHONE_LINE_CONNECTOR          = $0000000e;
      MCI_AUDIO_IN_CONNECTOR            = $0000000f;
      MCI_AUDIO_OUT_CONNECTOR           = $00000010;
      MCI_UNIVERSAL_CONNECTOR           = $00000011;
      MCI_INTERNAL_AUDIO_CONNECTOR      = $00000012;
      MCI_MIDI_IN_CONNECTOR             = $00000013;
      MCI_MIDI_OUT_CONNECTOR            = $00000014;
      MCI_NULL_CONNECTOR                = $00000015;

(*
/*********************************************************************/
/* parameter structure for the MCI_CONNECTION message                */
/*********************************************************************/
typedef struct _MCI_CONNECTION_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    ULONG   ulConnectorType; /* Connector type                          */
    ULONG   ulConnectorIndex;/* Connector index                         */
    PSZ     pszAlias;        /* Connection device alias                 */
    USHORT  usToDeviceID;    /* Connected to device ID                  */
    USHORT  usReserved0;     /* Reserved field                          */
    ULONG   ulReserved1;     /* Reserved field                          */
    ULONG   ulReserved2;     /* Reserved field                          */
} MCI_CONNECTION_PARMS;
typedef MCI_CONNECTION_PARMS   *PMCI_CONNECTION_PARMS;

*)
/*********************************************************************/
/* parameter structure for the MCI_CONNECTOR message                 */
/*********************************************************************/
type
  pmci_Connector_Parms = ^mci_Connector_Parms;
  mci_Connector_Parms = record
    hwndCallback     : hwnd;                   // PM window handle for MCI notify message
    ulReturn         : uLong;                  // Return information
    ulConnectorType  : uLong;                  // If specified, ulConnectorIndex is relative
                                               // to the specified connector type
    ulConnectorIndex : uLong;                  // Connector number
  end;

(* typedef struct _MCI_CONNECTOR_PARMS {
    HWND   hwndCallback;     /* PM window handle for MCI notify message    */
    ULONG  ulReturn;         /* Return information                         */
    ULONG  ulConnectorType;  /* If specified, ulConnectorIndex is relative */
                             /* to the specified connector type            */
    ULONG  ulConnectorIndex; /* Connector number                           */
} MCI_CONNECTOR_PARMS;
typedef MCI_CONNECTOR_PARMS   *PMCI_CONNECTOR_PARMS;

/*********************************************************************/
/* parameter structure for the MCI_CONNECTORINFO message             */
/*********************************************************************/
typedef struct _MCI_CONNECTORINFO_PARMS {
    HWND   hwndCallback;      /* PM window handle for MCI notify message    */
    ULONG  ulReturn;          /* Return information                         */
    ULONG  ulDeviceTypeID;    /* MCI device type                            */
    ULONG  ulConnectorType;   /* If specified, ulConnectorIndex is relative */
                              /* to the specified connector type            */
    ULONG  ulConnectorIndex;  /* Connector number                           */
    ULONG  ulToConnectorType; /* Connector type to test if                  */
                              /* MCI_QUERY_VALID_CONNECTION is specified    */
} MCI_CONNECTORINFO_PARMS;
typedef MCI_CONNECTORINFO_PARMS   *PMCI_CONNECTORINFO_PARMS;

/*********************************************************************/
/* flags for the MCI_CUE message                                     */
/*     $0000$00 are reserved for MCI_CUE flags                     */
/*********************************************************************/
      MCI_CUE_INPUT                       $00000100L
      MCI_CUE_OUTPUT                      $00000200L

    /*************************************************/
    /* Additional flags for Wave Audio for MCI_CUE   */
    /*************************************************/
      MCI_WAVE_INPUT                      $00001000L
      MCI_WAVE_OUTPUT                     $00002000L


/*********************************************************************/
/* parameter structure for the MCI_DEFAULT_CONNECTION message        */
/*********************************************************************/
typedef struct _MCI_DEFAULT_CONNECTION_PARMS  {
    HWND  hwndCallback;       /* PM window handle for MCI notify message    */
    PSZ   pszDevice;          /* Device name                                */
    ULONG ulConnectorType;    /* If specified, ulConnectorIndex is relative */
                              /* to the specified connector type            */
    ULONG ulConnectorIndex;   /* Connector number                           */
    PSZ   pszToDevice;        /* Return device name to which the connection */
                              /* exists                                     */
    ULONG ulToConnectorType;  /* Connector type                             */
    ULONG ulToConnectorIndex; /* Connector number                           */
} MCI_DEFAULT_CONNECTION_PARMS;
typedef MCI_DEFAULT_CONNECTION_PARMS    *PMCI_DEFAULT_CONNECTION_PARMS;

/*********************************************************************/
/* parameter structure for the MCI_DEVICESETTINGS message            */
/*********************************************************************/
typedef struct _MCI_DEVICESETTINGS_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message    */
    HWND    hwndNotebook;    /* Hwhd to notebook window                    */
    USHORT  usDeviceType;    /* Device type                                */
    PSZ     pszDeviceName;   /* Device name                                */
} MCI_DEVICESETTINGS_PARMS;
typedef MCI_DEVICESETTINGS_PARMS   *PMCI_DEVICESETTINGS_PARMS;

/**********************************************************************/
/* parameter structure for the MCI_CUT / COPY / DELETE / UNDO / etc...*/
/**********************************************************************/
typedef struct _MCI_EDIT_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message     */
    ULONG   ulStructLen;     /* Length of the Structure                     */
    ULONG   ulFrom;          /* Beginning Point of Range                    */
    ULONG   ulTo;            /* ending point of range                       */
    PVOID   pBuff;           /* user buffer                                 */
    ULONG   ulBufLen;        /* length of user buffer                       */
    PVOID   pHeader;         /* header which describes the buffer           */
} MCI_EDIT_PARMS;
typedef MCI_EDIT_PARMS   *PMCI_EDIT_PARMS;

/*********************************************************************/
/* flags and parameter structure for the MCI_ESCAPE message          */
/*     $0000$00 are reserved for MCI_ESCAPE flags                  */
/*********************************************************************/
      MCI_ESCAPE_STRING                   $00000100L

typedef struct _MCI_ESCAPE_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message    */
    PSZ     pszCommand;      /* Command to send to the device              */
} MCI_ESCAPE_PARMS;
typedef MCI_ESCAPE_PARMS   *PMCI_ESCAPE_PARMS;

/*********************************************************************/
/* flags for the MCI_FREEZE message                                  */
/*     $000$X00 are reserved for MCI_FREEZE flags                  */
/*********************************************************************/
      MCI_OVLY_FREEZE_RECT                $00000100L
      MCI_OVLY_FREEZE_RECT_OUTSIDE        $00000200L

/*********************************************************************/
/* flags for the MCI_GETDEVCAPS message                              */
/*     $0$XXX00 are reserved for MCI_GETDEVCAPS flags              */
/*********************************************************************/
      MCI_GETDEVCAPS_MESSAGE              $00000100L
      MCI_GETDEVCAPS_ITEM                 $00000200L
      MCI_GETDEVCAPS_EXTENDED             $00000400L

   /*************************************************/
   /* General MCI_GETDEVCAPS item values            */
   /*************************************************/
      MCI_GETDEVCAPS_CAN_EJECT            $00000001L
      MCI_GETDEVCAPS_CAN_LOCKEJECT        $00000002L
      MCI_GETDEVCAPS_CAN_PLAY             $00000003L
      MCI_GETDEVCAPS_CAN_PROCESS_INTERNAL $00000004L
      MCI_GETDEVCAPS_CAN_RECORD           $00000005L
      MCI_GETDEVCAPS_CAN_RECORD_INSERT    $00000006L
      MCI_GETDEVCAPS_CAN_SAVE             $00000007L
      MCI_GETDEVCAPS_CAN_SETVOLUME        $00000008L
      MCI_GETDEVCAPS_CAN_STREAM           $00000009L
      MCI_GETDEVCAPS_DEVICE_TYPE          $0000000AL
      MCI_GETDEVCAPS_HAS_AUDIO            $0000000BL
      MCI_GETDEVCAPS_HAS_VIDEO            $0000000CL
      MCI_GETDEVCAPS_PREROLL_TIME         $0000000DL
      MCI_GETDEVCAPS_PREROLL_TYPE         $0000000EL
      MCI_GETDEVCAPS_USES_FILES           $0000000FL
      MCI_GETDEVCAPS_HAS_IMAGE            $00000010L
      MCI_GETDEVCAPS_WAVE_FORMAT          $00000011L

    /***********************************************/
    /* return ID's for videodisc MCI_GETDEVCAPS    */
    /***********************************************/
      MCI_VD_MEDIA_CLV                    $00000001L
      MCI_VD_MEDIA_CAV                    $00000002L
      MCI_VD_MEDIA_OTHER                  $00000003L

    /*************************************************/
    /* MCI_GETDEVCAPS item values for video devices  */
    /*************************************************/
      MCI_VID_GETDEVCAPS_CAN_STRETCH       MCI_VID_ITEM_BASE
      MCI_VID_GETDEVCAPS_CAN_DISTORT       (MCI_VID_ITEM_BASE+1)
      MCI_VID_GETDEVCAPS_VIDEO_X_EXTENT    (MCI_VID_ITEM_BASE+2)
      MCI_VID_GETDEVCAPS_VIDEO_Y_EXTENT    (MCI_VID_ITEM_BASE+3)
      MCI_VID_GETDEVCAPS_IMAGE_X_EXTENT    (MCI_VID_ITEM_BASE+4)
      MCI_VID_GETDEVCAPS_IMAGE_Y_EXTENT    (MCI_VID_ITEM_BASE+5)
      MCI_VID_GETDEVCAPS_MAX_WINDOWS       (MCI_VID_ITEM_BASE+6)
      MCI_VID_GETDEVCAPS_CAN_FREEZE        (MCI_VID_ITEM_BASE+7)
      MCI_VID_GETDEVCAPS_OVERLAY_GRAPHICS  (MCI_VID_ITEM_BASE+8)

      MCI_VID_GETDEVCAPS_CAN_REVERSE       (MCI_VID_ITEM_BASE+9)
      MCI_VID_GETDEVCAPS_FAST_RATE         (MCI_VID_ITEM_BASE+10)
      MCI_VID_GETDEVCAPS_SLOW_RATE         (MCI_VID_ITEM_BASE+11)
      MCI_VID_GETDEVCAPS_NORMAL_RATE       (MCI_VID_ITEM_BASE+12)
      MCI_VID_GETDEVCAPS_MINIMUM_RATE      (MCI_VID_ITEM_BASE+13)
      MCI_VID_GETDEVCAPS_MAXIMUM_RATE      (MCI_VID_ITEM_BASE+14)

    /*************************************************/
    /* MCI_GETDEVCAPS flag values for Videodisc      */
    /*************************************************/
      MCI_VD_GETDEVCAPS_CLV               $00000400L
      MCI_VD_GETDEVCAPS_CAV               $00000800L

    /*************************************************/
    /* MCI_GETDEVCAPS item values for Videodisc      */
    /*************************************************/

      MCI_VD_GETDEVCAPS_CAN_REVERSE       MCI_VID_GETDEVCAPS_CAN_REVERSE
      MCI_VD_GETDEVCAPS_FAST_RATE         MCI_VID_GETDEVCAPS_FAST_RATE
      MCI_VD_GETDEVCAPS_SLOW_RATE         MCI_VID_GETDEVCAPS_SLOW_RATE
      MCI_VD_GETDEVCAPS_NORMAL_RATE       MCI_VID_GETDEVCAPS_NORMAL_RATE
      MCI_VD_GETDEVCAPS_MINIMUM_RATE      MCI_VID_GETDEVCAPS_MINIMUM_RATE
      MCI_VD_GETDEVCAPS_MAXIMUM_RATE      MCI_VID_GETDEVCAPS_MAXIMUM_RATE

    /************************************************/
    /* MCI_GETDEVCAPS item values for Digital Video */
    /************************************************/
      MCI_DGV_GETDEVCAPS_CAN_REVERSE      MCI_VID_GETDEVCAPS_CAN_REVERSE
      MCI_DGV_GETDEVCAPS_CAN_STRETCH      MCI_VID_GETDEVCAPS_CAN_STRETCH
      MCI_DGV_GETDEVCAPS_CAN_DISTORT      MCI_VID_GETDEVCAPS_CAN_DISTORT
      MCI_DGV_GETDEVCAPS_FAST_RATE        MCI_VID_GETDEVCAPS_FAST_RATE
      MCI_DGV_GETDEVCAPS_SLOW_RATE        MCI_VID_GETDEVCAPS_SLOW_RATE
      MCI_DGV_GETDEVCAPS_NORMAL_RATE      MCI_VID_GETDEVCAPS_NORMAL_RATE
      MCI_DGV_GETDEVCAPS_MINIMUM_RATE     MCI_VID_GETDEVCAPS_MINIMUM_RATE
      MCI_DGV_GETDEVCAPS_MAXIMUM_RATE     MCI_VID_GETDEVCAPS_MAXIMUM_RATE
      MCI_DGV_GETDEVCAPS_VIDEO_X_EXTENT   MCI_VID_GETDEVCAPS_VIDEO_X_EXTENT
      MCI_DGV_GETDEVCAPS_VIDEO_Y_EXTENT   MCI_VID_GETDEVCAPS_VIDEO_Y_EXTENT
      MCI_DGV_GETDEVCAPS_IMAGE_X_EXTENT   MCI_VID_GETDEVCAPS_IMAGE_X_EXTENT
      MCI_DGV_GETDEVCAPS_IMAGE_Y_EXTENT   MCI_VID_GETDEVCAPS_IMAGE_Y_EXTENT
      MCI_DGV_GETDEVCAPS_MAX_WINDOWS      MCI_VID_GETDEVCAPS_MAX_WINDOWS
      MCI_DGV_GETDEVCAPS_OVERLAY_GRAPHICS MCI_VID_GETDEVCAPS_OVERLAY_GRAPHICS
      MCI_DGV_GETDEVCAPS_HAS_TUNER        (MCI_DGV_ITEM_BASE)
      MCI_DGV_GETDEVCAPS_HAS_TELETEX      (MCI_DGV_ITEM_BASE+1)
      MCI_DGV_GETDEVCAPS_HAS_AFC          (MCI_DGV_ITEM_BASE+2)

   /*************************************************/
   /* MCI_GETDEVCAPS item values for Video Overlay  */
   /*************************************************/
      MCI_OVLY_GETDEVCAPS_CAN_STRETCH     MCI_VID_GETDEVCAPS_CAN_STRETCH
      MCI_OVLY_GETDEVCAPS_CAN_DISTORT     MCI_VID_GETDEVCAPS_CAN_DISTORT
      MCI_OVLY_GETDEVCAPS_VIDEO_X_EXTENT  MCI_VID_GETDEVCAPS_VIDEO_X_EXTENT
      MCI_OVLY_GETDEVCAPS_VIDEO_Y_EXTENT  MCI_VID_GETDEVCAPS_VIDEO_Y_EXTENT
      MCI_OVLY_GETDEVCAPS_IMAGE_X_EXTENT  MCI_VID_GETDEVCAPS_IMAGE_X_EXTENT
      MCI_OVLY_GETDEVCAPS_IMAGE_Y_EXTENT  MCI_VID_GETDEVCAPS_IMAGE_Y_EXTENT
      MCI_OVLY_GETDEVCAPS_MAX_WINDOWS     MCI_VID_GETDEVCAPS_MAX_WINDOWS
      MCI_OVLY_GETDEVCAPS_CAN_FREEZE      MCI_VID_GETDEVCAPS_CAN_FREEZE
      MCI_OVLY_GETDEVCAPS_OVERLAY_GRAPHICS MCI_VID_GETDEVCAPS_OVERLAY_GRAPHICS


      MCI_PREROLL_NOTIFIED                $00000001L
      MCI_PREROLL_DETERMINISTIC           $00000002L
      MCI_PREROLL_NONE                    $00000003L

/*********************************************************************/
/* parameter structure for the MCI_GETDEVCAPS message                */
/*********************************************************************/
typedef struct _MCI_GETDEVCAPS_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    ULONG   ulReturn;        /* Return field                            */
    ULONG   ulItem;          /* Item field for GETDEVCAPS item to query */
    USHORT  usMessage;       /* Field to hold MCI message to query      */
    USHORT  usReserved0;     /* Reserved field                          */
} MCI_GETDEVCAPS_PARMS;
typedef MCI_GETDEVCAPS_PARMS   * PMCI_GETDEVCAPS_PARMS;

/*********************************************************************/
/* parameter structure for the MCI_WAVE_GETDEVCAPS                   */
/*********************************************************************/
typedef struct _MCI_WAVE_GETDEVCAPS_PARMS {
    HWND    hwndCallback;     /* PM window handle for MCI notify message */
    ULONG   ulReturn;         /* Return field                            */
    ULONG   ulItem;           /* Item field for GETDEVCAPS item to query */
    USHORT  usMessage;        /* Field to hold MCI message to query      */
    USHORT  usReserved0;      /* Reserved field                          */
    ULONG   ulLength;         /* Length of structure in ULONGS           */
    ULONG   ulBitsPerSample;  /* Number of Bits per Sample               */
    ULONG   ulFormatTag;      /* Format Tag                              */
    ULONG   ulSamplesPerSec;  /* Sampling Rate                           */
    ULONG   ulChannels;       /* Number of channels                      */
    ULONG   ulFormatMode;     /* Either MCI_RECORD or MCI_PLAY           */
} MCI_WAVE_GETDEVCAPS_PARMS;
typedef MCI_WAVE_GETDEVCAPS_PARMS   * PMCI_WAVE_GETDEVCAPS_PARMS;

*)

/*********************************************************************/
/* potential values for the ulExtended field of MCI_AMP_GETDEVCAPS_PARMS*/
/*********************************************************************/
Const MCI_MIXER_LINE    = $00000001;

(*
/*********************************************************************/
/* parameter structure for the MCI_AMP_GETDEVCAPS                    */
/*********************************************************************/
typedef struct _MCI_AMP_GETDEVCAPS_PARMS {
    ULONG   hwndCallback;     /* PM window handle for MCI notify message */
    ULONG   ulReturn;         /* Return field                            */
    ULONG   ulItem;           /* Item field for GETDEVCAPS item to query */
    USHORT  usMessage;        /* Field to hold MCI message to query      */
    USHORT  usReserved0;      /* Reserved field                          */
    ULONG   ulLength;         /* Length of structure in ULONGS           */
    ULONG   ulValue;          /* Value to determine caps                 */
    ULONG   ulAttribute;      /* Flags to modified the extended parms    */
    ULONG   ulExtended;       /* Extended flags field                    */
} MCI_AMP_GETDEVCAPS_PARMS;
typedef MCI_AMP_GETDEVCAPS_PARMS   * PMCI_AMP_GETDEVCAPS_PARMS;

/*********************************************************************/
/* values for the ulFlags field of MCI_MIXEVENT_PARMS                */
/*********************************************************************/
      MCI_MIX_ATTRIBUTE       $00000001L
      MCI_MIX_CONNECTOR       $00000002L

/*********************************************************************/
/* values for the lParam field for mix_notify                        */
/*********************************************************************/

      MCI_MIXNOTIFY_ON        $00000004L
      MCI_MIXNOTIFY_OFF       $00000008L

/*********************************************************************/
/* value to indicate type of MM_MCIEVENT                             */
/*********************************************************************/

      MCI_MIXEVENT            $00000001L



/*********************************************************************/
/* parameter structure for the MCI_MIXEVENT_PARMS                    */
/*********************************************************************/
typedef struct _MCI_MIXEVENT_PARMS
   {
   ULONG  ulLength;        /* Length of struct                          */
   HWND   hwndMixer;       /* window to inform of mixer changes         */
   ULONG  ulFlags;         /* Either MCI_MIX_ATTRIBUTE                  */
                           /*      or MCI_MIX_CONNECTOR                 */
   USHORT usDeviceID;      /* device id to notify of the change         */
   ULONG  ulDeviceType;    /* Device Type which generated the change    */
   ULONG  ulDeviceOrdinal; /* Ordinal of device Type                    */
   ULONG  ulAttribute;     /* Attribute that changed(volume, bass etc.) */
   ULONG  ulValue;         /* new value of the attribute which changed  */
   ULONG  ulConnectorType; /* Connector Type                            */
   ULONG  ulConnectorIndex;/* Connector Index                           */
   ULONG  ulConnStatus;    /* Is connector enabled/disabled.            */

   } MCI_MIXEVENT_PARMS;

typedef MCI_MIXEVENT_PARMS *PMCI_MIXEVENT_PARMS;


/*********************************************************************/
/* flag values for the MCI_GETIMAGEBUFFER and MCI_SETIMAGEBUFFER msg */
/*     $000$X00 are reserved for MCI_GETIMAGEBUFFER and            */
/*       MCI_SETIMAGEBUFFER Flags                                    */
/*     MCI_CONVERT is defined by MCI_CAPTURE message as $00001000L  */
/*********************************************************************/
      MCI_USE_HW_BUFFER                   $00000400L
      MCI_GET_HW_BUFFER_PTR               $00000800L

   /***************************************************/
   /* parm structure for MCI_GETIMAGEBUFFER and       */
   /*                    MCI_SETIMAGEBUFFER messages  */
   /***************************************************/
typedef  struct _MCI_IMAGE_PARMS {
    HWND    hwndCallback;       /* PM window handle for MCI notify message */
    ULONG   ulPelFormat;        /* Format of the image data returned       */
    USHORT  usBitCount;         /* Number of bitsimage data returned       */
    USHORT  usReserved0;        /* Reserved field                          */
    ULONG   ulImageCompression; /*                                         */
    RECTL   rect;               /* Image area to get/set                   */
    PVOID   pPelBuffer;         /* Pel data buffer                         */
    ULONG   ulPelBufferHeight;  /* Number of rows in buffer                */
    ULONG   ulPelBufferWidth;   /* Pels per row in buffer                  */
    ULONG   ulBufLen;           /* Pel data buffer length in bytes         */

} MCI_IMAGE_PARMS;
typedef MCI_IMAGE_PARMS   *PMCI_IMAGE_PARMS;

/*********************************************************************/
/* flags for the MCI_GETIMAGEPALETTE message                         */
/*     $000$X00 are reserved for MCI_GETIMAGEPALETTE flags         */
/*********************************************************************/
      MCI_FIND_BEST_REGISTERED            $00000100L
      MCI_QUERY_REGISTERED_MAP            $00000200L
      MCI_QUERY_REGISTERED_MAP_SIZE       $00000400L


   /***************************************************/
   /* parameter structure for MCI_GETIMAGEPALETTE and */
   /*    MCI_SETIMAGEPALETTE messages                 */
   /***************************************************/
typedef  struct _MCI_PALETTE_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message   */
    USHORT  usRegisteredMap; /* Id of the palette from the registed color */
                             /* map                                       */
    USHORT  usReserved0;     /* Reserved field                            */
    ULONG   ulPalEntries;    /* size of the palette returned              */
    PVOID   pPalette;        /* pointer to the palette                    */
} MCI_PALETTE_PARMS;
typedef MCI_PALETTE_PARMS   *PMCI_PALETTE_PARMS;


/*********************************************************************/
/* Parameter structure for the MCI_GETTOC message                    */
/*********************************************************************/
typedef struct _MCI_TOC_REC {
    BYTE      TrackNum;      /* Returned Track Number                          */
    ULONG     ulStartAddr;   /* Starting address of the track in MMTIME format */
    ULONG     ulEndAddr;     /* Ending address of the track in MMTIME format   */
    BYTE      Control;       /* Track Control information                      */
    USHORT    usCountry;     /* Country                                        */
    ULONG     ulOwner;       /* Owner                                          */
    ULONG     ulSerialNum;   /* Serial Number                                  */
} MCI_TOC_REC;
typedef MCI_TOC_REC   *PTOCREC;

typedef struct _MCI_TOC_PARMS {
    HWND      hwndCallback;  /* PM window handle for MCI notify message    */
    PTOCREC   pBuf;          /* Pointer to array MCI_TOC_REC structures to */
                             /* be filled in by the mci device             */
    ULONG     ulBufSize;     /* Size of the array                          */
} MCI_TOC_PARMS;
typedef MCI_TOC_PARMS   * PMCI_TOC_PARMS;

/*********************************************************************/
/* parameters for the MCI_GROUP message                              */
/*     $0$XXX00 are reserved for MCI_GROUP flags                   */
/*********************************************************************/
      MCI_SYNCHRONIZE                     $00000100L
      MCI_NOPIECEMEAL                     $00000200L
      MCI_GROUP_MAKE                      $00000400L
      MCI_GROUP_DELETE                    $00000800L
      MCI_GROUP_ALIAS                     $00001000L
      MCI_GROUP_MASTER                    $00002000L

typedef struct _MCI_GROUP_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message.    */
    USHORT  usGroupID;       /* GroupID                                     */
    USHORT  usReserved0;     /* RESERVED                                    */
    ULONG   ulStructLength;  /* Length of Structure in ULONGS.              */
    USHORT  usMasterID;      /* ID of Master device in Synchrounous groups. */
    USHORT  usReserved1;     /* RESERVED                                    */
    PSZ     pszGroupAlias;   /* Pointer to Alias Name.                      */
    ULONG   ulNumDevices;    /* Number of Devices in group.                 */
    PULONG  paulDeviceID;    /* Array of Device ids in the group.           */
} MCI_GROUP_PARMS;
typedef MCI_GROUP_PARMS *PMCI_GROUP_PARMS;


/*********************************************************************/
/* flags for the MCI_INFO message                                    */
/*     $0000$00 are reserved for MCI_INFO flags                    */
/*********************************************************************/
      MCI_INFO_PRODUCT                    $00000100L
      MCI_INFO_FILE                       $00000200L

    /************************************************/
    /* CD Audio                MCI_INFO             */
    /************************************************/
      MCI_CD_INFO_ID                      $00010000L
      MCI_CD_INFO_UPC                     $00020000L

    /************************************************/
    /* Videodisc               MCI_INFO             */
    /************************************************/
      MCI_VD_INFO_LABEL                   $00001000L

    /************************************************/
    /* Digital Video           MCI_INFO             */
    /************************************************/
      MCI_DGV_INFO_VIDEO_FILE             $00001000L
      MCI_DGV_INFO_IMAGE_FILE             $00002000L
      MCI_DGV_INFO_REGION                 $00004000L
      MCI_DGV_INFO_REGION_TEXT            $00008000L
      MCI_DGV_INFO_TEXT                   $00010000L

    /************************************************/
    /* Video Overlay           MCI_INFO             */
    /************************************************/
      MCI_OVLY_INFO_TEXT                  $00010000L


typedef struct _MCI_INFO_PARMS {
    HWND      hwndCallback;  /* PM window handle for MCI notify message */
    PSZ       pszReturn;     /* Pointer to return buffer                */
    ULONG     ulRetSize;     /* Return buffer size                      */
} MCI_INFO_PARMS;
typedef MCI_INFO_PARMS   *PMCI_INFO_PARMS;

/*********************************************************************/
/* parameters and flags for the MCI_LOAD message                     */
/*     $0000$00 are reserved for MCI_LOAD flags                    */
/*********************************************************************/
typedef struct _MCI_LOAD_PARMS {
    HWND   hwndCallback;     /* PM window handle for MCI notify message */
    PSZ    pszElementName;   /* File name to loads                      */
} MCI_LOAD_PARMS;
typedef MCI_LOAD_PARMS   *PMCI_LOAD_PARMS;

/*********************************************************************/
/* parameters and flags for the MCI_MASTERAUDIO                      */
/*     $00$XX00 are reserved for MCI_MASTERAUDIO  flags            */
/*********************************************************************/
      MCI_ON                              $00000100L
      MCI_OFF                             $00000200L
      MCI_HEADPHONES                      $00000400L
      MCI_SPEAKERS                        $00000800L
      MCI_MASTERVOL                       $00001000L
      MCI_SAVESETTING                     $00002000L
      MCI_QUERYSAVEDSETTING               $00004000L
      MCI_QUERYCURRENTSETTING             $00008000L


typedef struct _MCI_MASTERAUDIO_PARMS {
    HWND    hwndDummyCallback; /* Notify not allowed for this message     */
    ULONG   ulReturn;          /* Return field for query information      */
    ULONG   ulMasterVolume;    /* Master volume field                     */
} MCI_MASTERAUDIO_PARMS;
typedef MCI_MASTERAUDIO_PARMS   *PMCI_MASTERAUDIO_PARMS;

*)
/*********************************************************************/
/* parameters and flags for the MCI_OPEN message                     */
/*     $000$X00 are reserved for MCI_OPEN flags                    */
/*********************************************************************/
Const MCI_OPEN_ELEMENT                  = $00000100;
      MCI_OPEN_ALIAS                    = $00000200;
      MCI_OPEN_ELEMENT_ID               = $00000400;
      MCI_OPEN_PLAYLIST                 = $00000800;
      MCI_OPEN_TYPE_ID                  = $00001000;
      MCI_OPEN_SHAREABLE                = $00002000;
      MCI_OPEN_MMIO                     = $00004000;
      MCI_READONLY                      = $00008000;

    /***************************************************/
    /* parameters and flags for the MCI_OPEN message   */
    /* Digital Video, Video Overlay specific           */
    /***************************************************/
      MCI_VID_OPEN_PARENT               = $01000000;
      MCI_DGV_OPEN_PARENT               = MCI_VID_OPEN_PARENT;
      MCI_OVLY_OPEN_PARENT              = MCI_VID_OPEN_PARENT;
(*
typedef struct _MCI_OPEN_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    USHORT  usDeviceID;      /* Device ID returned to user              */
    USHORT  usReserved0;     /* Reserved                                */
    PSZ     pszDeviceType;   /* Device name from SYSTEM.INI             */
    PSZ     pszElementName;  /* Typically a file name or NULL           */
    PSZ     pszAlias;        /* Optional device alias                   */
} MCI_OPEN_PARMS;
typedef MCI_OPEN_PARMS   *PMCI_OPEN_PARMS;

*)

    /**********************************************************/
    /* parameters for the AMP MCI_OPEN message                */
    /**********************************************************/
type
  pmci_Amp_Open_Parms = ^mci_Amp_Open_Parms;
  mci_Amp_Open_Parms = record
    hwndCallback     : hwnd;                   // PM window handle for MCI notify message
    usDeviceID       : uShort;                 // Device ID returned to user
    usReserved0      : uShort;                 // Reserved field
    pszDeviceType    : pChar;                  // Device name from SYSTEM.INI
    pszElementName   : pChar;                  // Typically a file name or NULL
    pszAlias         : pChar;                  // Optional device alias
    pDevDataPtr      : Pointer;                // Pointer to device data
  end;

(*
typedef struct _MCI_AMP_OPEN_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    USHORT  usDeviceID;      /* Device ID returned to user              */
    USHORT  usReserved0;     /* Reserved field                          */
    PSZ     pszDeviceType;   /* Device name from SYSTEM.INI             */
    PSZ     pszElementName;  /* Typically a file name or NULL           */
    PSZ     pszAlias;        /* Optional device alias                   */
    PVOID   pDevDataPtr;     /* Pointer to device data                  */
} MCI_AMP_OPEN_PARMS;
typedef MCI_AMP_OPEN_PARMS   *PMCI_AMP_OPEN_PARMS;

    /**********************************************************/
    /* parameters for MCI_OPEN message for video devices      */
    /**********************************************************/

typedef  struct _MCI_VID_OPEN_PARMS{
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    USHORT  usDeviceID;      /* Device ID returned to user              */
    USHORT  usReserved0;     /* Reserved field                          */
    PSZ     pszDeviceType;   /* Device name from SYSTEM.INI             */
    PSZ     pszElementName;  /* Typically a file name or NULL           */
    PSZ     pszAlias;        /* Optional device alias                   */
    HWND    hwndParent;      /* Parent window handle                    */
} MCI_VID_OPEN_PARMS;

typedef MCI_VID_OPEN_PARMS   MCI_DGV_OPEN_PARMS;
typedef MCI_DGV_OPEN_PARMS   *PMCI_DGV_OPEN_PARMS;

typedef MCI_VID_OPEN_PARMS    MCI_OVLY_OPEN_PARMS;
typedef MCI_OVLY_OPEN_PARMS   *PMCI_OVLY_OPEN_PARMS;

    /***************************************************/
    /* MCI_PLAY flag values for videodisc              */
    /***************************************************/
      MCI_VD_PLAY_REVERSE                 $00001000L
      MCI_VD_PLAY_FAST                    $00002000L
      MCI_VD_PLAY_SPEED                   $00004000L
      MCI_VD_PLAY_SCAN                    $00008000L
      MCI_VD_PLAY_SLOW                    $00010000L

    /***************************************************/
    /* MCI_PLAY flag values for digital video          */
    /***************************************************/
      MCI_DGV_PLAY_REVERSE                $00001000L
      MCI_DGV_PLAY_FAST                   $00002000L
      MCI_DGV_PLAY_SPEED                  $00004000L
      MCI_DGV_PLAY_SCAN                   $00008000L
      MCI_DGV_PLAY_SLOW                   $00010000L
      MCI_DGV_PLAY_REPEAT                 $00020000L

typedef struct _MCI_PLAY_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    ULONG   ulFrom;          /* Play from this position                 */
    ULONG   ulTo;            /* Play to this position                   */
} MCI_PLAY_PARMS;
typedef MCI_PLAY_PARMS   *PMCI_PLAY_PARMS;

typedef struct _MCI_VD_PLAY_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    ULONG   ulFrom;          /* Play from this position                 */
    ULONG   ulTo;            /* Play to this position                   */
    ULONG   ulFactor;        /* Play at this speed factor               */
} MCI_VD_PLAY_PARMS;
typedef MCI_VD_PLAY_PARMS   *PMCI_VD_PLAY_PARMS;

typedef  struct _MCI_DGV_PLAY_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    ULONG   ulFrom;          /* Play from this position                 */
    ULONG   ulTo;            /* Play to this position                   */
    ULONG   ulSpeed;         /* Specifies the play rate in frames per second */
} MCI_DGV_PLAY_PARMS;
typedef MCI_DGV_PLAY_PARMS   *PMCI_DGV_PLAY_PARMS;

/*********************************************************************/
/* parameters for the MCI_PUT  message                               */
/*     $0000$00 are reserved for MCI_PUT  flags                    */
/*********************************************************************/
      MCI_VID_PUT_RECT                    $00000100L
      MCI_VID_PUT_DESTINATION             $00000200L
      MCI_VID_PUT_SOURCE                  $00000400L
      MCI_VID_PUT_WINDOW_MOVE             $00000800L
      MCI_VID_PUT_WINDOW_SIZE             $00001000L

      MCI_DGV_PUT_RECT                    MCI_VID_PUT_RECT
      MCI_DGV_PUT_DESTINATION             MCI_VID_PUT_DESTINATION
      MCI_DGV_PUT_SOURCE                  MCI_VID_PUT_SOURCE
      MCI_DGV_PUT_WINDOW_MOVE             MCI_VID_PUT_WINDOW_MOVE
      MCI_DGV_PUT_WINDOW_SIZE             MCI_VID_PUT_WINDOW_SIZE
      MCI_DGV_MONITOR                     $00010000L
      MCI_DGV_RECORD                      $00020000L

      MCI_OVLY_PUT_RECT                   MCI_VID_PUT_RECT
      MCI_OVLY_PUT_DESTINATION            MCI_VID_PUT_DESTINATION
      MCI_OVLY_PUT_SOURCE                 MCI_VID_PUT_SOURCE
      MCI_OVLY_PUT_WINDOW_MOVE            MCI_VID_PUT_WINDOW_MOVE
      MCI_OVLY_PUT_WINDOW_SIZE            MCI_VID_PUT_WINDOW_SIZE

    /***************************************************/
    /* Rectangle parameters for MCI_PUT, MCI_WHERE,    */
    /* MCI_FREEZE, and MCI_UNFREEZE                    */
    /***************************************************/

typedef  struct _MCI_VID_RECT_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    RECTL   rc;              /* rectangle array specifying the offset   */
                             /* and size of a rectangle                 */
} MCI_VID_RECT_PARMS;

typedef MCI_VID_RECT_PARMS   MCI_DGV_RECT_PARMS;
typedef MCI_DGV_RECT_PARMS   *PMCI_DGV_RECT_PARMS;

typedef MCI_VID_RECT_PARMS   MCI_OVLY_RECT_PARMS;
typedef MCI_OVLY_RECT_PARMS  *PMCI_OVLY_RECT_PARMS;

/*********************************************************************/
/* parameters for the MCI_RECORD message                             */
/*     $0000$00 are reserved for MCI_RECORD flags                  */
/*********************************************************************/
      MCI_RECORD_INSERT                   $00000100L
      MCI_RECORD_OVERWRITE                $00000200L

      MCI_DGV_RECORD_RECT                 $00000400L

typedef struct _MCI_RECORD_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    ULONG   ulFrom;          /* Record from position                    */
    ULONG   ulTo;            /* Record to position                      */
} MCI_RECORD_PARMS;
typedef MCI_RECORD_PARMS   *PMCI_RECORD_PARMS;

/*********************************************************************/
/* parameters for the MCI_RELEASEDEVICE message                      */
/*     $XXXXXX00 are reserved for MCI_RELEASEDEVICE message         */
/*********************************************************************/
      MCI_RETURN_RESOURCE                 $00000100L

/*********************************************************************/
/* parameters for the MCI_RESTORE message                            */
/*     $000$X00 are reserved for MCI_RESTORE flags                 */
/*     MCI_CONVERT is defined by MCI_CAPTURE message as $00001000L  */
/*********************************************************************/
      MCI_RESTORE_SRC_RECT                $00000100L
      MCI_RESTORE_DEST_RECT               $00000200L

typedef struct _MCI_RESTORE_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message     */
    RECTL   SrcRect;         /* Rectangle array specifying the source       */
                             /* area to be restored                                 */
    RECTL   DestRect;        /* Rectangle array specifying the destination  */
                             /* area to be restored                         */
} MCI_RESTORE_PARMS;
typedef MCI_RESTORE_PARMS   *PMCI_RESTORE_PARMS;

/*********************************************************************/
/* parameters for the MCI_SAVE  message                              */
/*     $0000$00 are reserved for MCI_SAVE  flags                   */
/*********************************************************************/
      MCI_SAVE_FILE                       $00000100L

    /*************************************************/
    /* Digital Video               MCI_SAVE          */
    /*************************************************/

      MCI_DGV_SAVE_VIDEO_FILE             $00001000L
      MCI_DGV_SAVE_IMAGE_FILE             $00002000L

typedef struct _MCI_SAVE_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message     */
    PSZ     pszFileName;     /* Filename to save data to                    */
} MCI_SAVE_PARMS;
typedef MCI_SAVE_PARMS   *PMCI_SAVE_PARMS;

/*********************************************************************/
/* parameters for the MCI_SEEK message                               */
/*     $0000$00 are reserved for MCI_SEEK flags                    */
/*********************************************************************/
      MCI_TO_START                        $00000100L
      MCI_TO_END                          $00000200L

    /*************************************************/
    /* Digital Video               MCI_SEEK          */
    /*************************************************/

      MCI_DGV_SEEK_TO_NEAREST_IFRAME      $00100000L

    /*************************************************/
    /* Videodisc                   MCI_SEEK          */
    /*************************************************/
      MCI_VD_SEEK_REVERSE                 $00001000L

typedef struct _MCI_SEEK_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message     */
    ULONG   ulTo;            /* Seek to this position                       */
} MCI_SEEK_PARMS;
typedef MCI_SEEK_PARMS   *PMCI_SEEK_PARMS;

*)
/*********************************************************************/
/* Flags for the MCI_SET message                                     */
/*     $0$XXX00 are reserved for MCI_SET  flags                    */
/*********************************************************************/
Const MCI_SET_ITEM                      = $00000100;
      MCI_SET_ON                        = $00000200;
      MCI_SET_OFF                       = $00000400;
      MCI_SET_VIDEO                     = $00000800;
      MCI_SET_AUDIO                     = $00001000;
      MCI_SET_DOOR_OPEN                 = $00002000;
      MCI_SET_DOOR_CLOSED               = $00004000;
      MCI_SET_SPEED_FORMAT              = $00008000;
      MCI_SET_TIME_FORMAT               = $00010000;
      MCI_SET_DOOR_LOCK                 = $00020000;
      MCI_SET_DOOR_UNLOCK               = $00040000;
      MCI_SET_VOLUME                    = $00080000;
      MCI_SET_ITEM_FOURCC               = $00100000;
      MCI_SET_REVERSE                   = $00200000;

/*******************************************************/
/* Values for the ulAudio field                        */
/*******************************************************/
      MCI_SET_AUDIO_ALL                 = $00000000;
      MCI_SET_AUDIO_LEFT                = $00000001;
      MCI_SET_AUDIO_RIGHT               = $00000002;

/*******************************************************/
/* MCI_SET flags for amp/mixer                         */
/*******************************************************/
Const MCI_AMP_SET_BALANCE               = $00100000;
      MCI_AMP_SET_PITCH                 = $00200000;
      MCI_AMP_SET_TREBLE                = $00400000;
      MCI_AMP_SET_BASS                  = $00800000;
      MCI_AMP_SET_GAIN                  = $01000000;

      MCI_AMP_SET_ALC                   = $00000004;
      MCI_AMP_SET_CROSSOVER             = $00000010;
      MCI_AMP_SET_LOUDNESS              = $00000020;
      MCI_AMP_SET_MUTE                  = $00000040;
      MCI_AMP_SET_REVERB                = $00000080;
      MCI_AMP_SET_STEREOENHANCE         = $00000100;
      MCI_AMP_SET_CUSTOM1               = $00000200;
      MCI_AMP_SET_CUSTOM2               = $00000400;
      MCI_AMP_SET_CUSTOM3               = $00000800;
      MCI_AMP_SET_LRVOLUME              = $00001000;
      MCI_AMP_SET_MID                   = $00020000;
      MCI_AMP_SET_CHORUS                = $00004000;
      MCI_AMP_SET_VOLUME                = MCI_SET_VOLUME;

/*******************************************************/
/* MCI_SET flags for CDXA                              */
/*******************************************************/
      MCI_CDXA_SET_CHANNEL              = $01000000;
      MCI_CDXA_AUDIO_DEVICE             = $10000000;
      MCI_CDXA_AUDIO_BUFFER             = $02000000;
      MCI_CDXA_VIDEO_BUFFER             = $04000000;
      MCI_CDXA_DATA_BUFFER              = $08000000;

/*******************************************************/
/* MCI_SET flags for videodisc                         */
/*******************************************************/
      MCI_VD_SET_ON                     = MCI_SET_ON;
      MCI_VD_SET_OFF                    = MCI_SET_OFF;
      MCI_VD_SET_VIDEO                  = MCI_SET_VIDEO;
      MCI_VD_SET_CHANNEL                = $00100000;
      MCI_VD_SET_DISPLAY                = $00200000;
(*
/*******************************************************/
/* Generic MCI_SET item values for video devices       */
/*******************************************************/
      MCI_VID_SET_VIDEO_COMPRESSION           MCI_VID_ITEM_BASE
      MCI_VID_SET_IMAGE_COMPRESSION           (MCI_VID_ITEM_BASE+1)
      MCI_VID_SET_IMAGE_BITSPERPEL            (MCI_VID_ITEM_BASE+2)
      MCI_VID_SET_IMAGE_PELFORMAT             (MCI_VID_ITEM_BASE+3)
      MCI_VID_SET_BRIGHTNESS                  (MCI_VID_ITEM_BASE+4)
      MCI_VID_SET_CONTRAST                    (MCI_VID_ITEM_BASE+5)
      MCI_VID_SET_HUE                         (MCI_VID_ITEM_BASE+6)
      MCI_VID_SET_SATURATION                  (MCI_VID_ITEM_BASE+7)
      MCI_VID_SET_SHARPNESS                   (MCI_VID_ITEM_BASE+8)
      MCI_VID_SET_GREYSCALE                   (MCI_VID_ITEM_BASE+9)
      MCI_VID_SET_IMAGE_QUALITY               (MCI_VID_ITEM_BASE+10)
      MCI_VID_SET_VIDEO_QUALITY               (MCI_VID_ITEM_BASE+11)
      MCI_VID_SET_IMAGE_COMPRESSION_METHOD    (MCI_VID_ITEM_BASE+12)
      MCI_VID_SET_MINIMUM_VIDEO_REFRESH_RATE  (MCI_VID_ITEM_BASE+13)
      MCI_VID_SET_IMAGE_FILE_FORMAT           (MCI_VID_ITEM_BASE+14)
      MCI_VID_SET_REF_INTERVAL                (MCI_VID_ITEM_BASE+15)
      MCI_VID_SET_MAXDATARATE                 (MCI_VID_ITEM_BASE+16)
      MCI_VID_SET_VIDEO_FILE_FORMAT           (MCI_VID_ITEM_BASE+17)

/*******************************************************/
/* MCI_SET item values for video overlay               */
/*******************************************************/
      MCI_OVLY_SET_IMAGE_COMPRESSION          MCI_VID_SET_IMAGE_COMPRESSION
      MCI_OVLY_SET_IMAGE_BITSPERPEL           MCI_VID_SET_IMAGE_BITSPERPEL
      MCI_OVLY_SET_IMAGE_PELFORMAT            MCI_VID_SET_IMAGE_PELFORMAT
      MCI_OVLY_SET_BRIGHTNESS                 MCI_VID_SET_BRIGHTNESS
      MCI_OVLY_SET_CONTRAST                   MCI_VID_SET_CONTRAST
      MCI_OVLY_SET_HUE                        MCI_VID_SET_HUE
      MCI_OVLY_SET_SATURATION                 MCI_VID_SET_SATURATION
      MCI_OVLY_SET_SHARPNESS                  MCI_VID_SET_SHARPNESS
      MCI_OVLY_SET_GREYSCALE                  MCI_VID_SET_GREYSCALE
      MCI_OVLY_SET_IMAGE_QUALITY              MCI_VID_SET_IMAGE_QUALITY
      MCI_OVLY_SET_IMAGE_COMPRESSION_METHOD   MCI_VID_SET_IMAGE_COMPRESSION_METHOD
      MCI_OVLY_SET_MINIMUM_VIDEO_REFRESH_RATE MCI_VID_SET_MINIMUM_VIDEO_REFRESH_RATE
      MCI_OVLY_SET_IMAGE_FILE_FORMAT          MCI_VID_SET_IMAGE_FILE_FORMAT

/*******************************************************/
/* MCI_SET item values for digital video               */
/*******************************************************/
      MCI_DGV_SET_VIDEO_COMPRESSION           MCI_VID_SET_VIDEO_COMPRESSION
      MCI_DGV_SET_IMAGE_COMPRESSION           MCI_VID_SET_IMAGE_COMPRESSION
      MCI_DGV_SET_IMAGE_BITSPERPEL            MCI_VID_SET_IMAGE_BITSPERPEL
      MCI_DGV_SET_IMAGE_PELFORMAT             MCI_VID_SET_IMAGE_PELFORMAT
      MCI_DGV_SET_BRIGHTNESS                  MCI_VID_SET_BRIGHTNESS
      MCI_DGV_SET_CONTRAST                    MCI_VID_SET_CONTRAST
      MCI_DGV_SET_HUE                         MCI_VID_SET_HUE
      MCI_DGV_SET_SATURATION                  MCI_VID_SET_SATURATION
      MCI_DGV_SET_SHARPNESS                   MCI_VID_SET_SHARPNESS
      MCI_DGV_SET_GREYSCALE                   MCI_VID_SET_GREYSCALE
      MCI_DGV_SET_IMAGE_QUALITY               MCI_VID_SET_IMAGE_QUALITY
      MCI_DGV_SET_VIDEO_QUALITY               MCI_VID_SET_VIDEO_QUALITY
      MCI_DGV_SET_IMAGE_COMPRESSION_METHOD    MCI_VID_SET_IMAGE_COMPRESSION_METHOD
      MCI_DGV_SET_MONITOR                     MCI_SET_MONITOR
      MCI_DGV_SET_MINIMUM_VIDEO_REFRESH_RATE  MCI_VID_SET_MINIMUM_VIDEO_REFRESH_RATE
      MCI_DGV_SET_IMAGE_FILE_FORMAT           MCI_VID_SET_IMAGE_FILE_FORMAT
      MCI_DGV_SET_REF_INTERVAL                MCI_VID_SET_REF_INTERVAL
      MCI_DGV_SET_MAXDATARATE                 MCI_VID_SET_MAXDATARATE
      MCI_DGV_SET_VIDEO_FILE_FORMAT           MCI_VID_SET_VIDEO_FILE_FORMAT

      MCI_DGV_SET_AUDIO_COMPRESSION           MCI_DGV_ITEM_BASE
      MCI_DGV_SET_AUDIO_QUALITY               (MCI_DGV_ITEM_BASE+1)
      MCI_DGV_SET_CHANNELS                    (MCI_DGV_ITEM_BASE+2)
      MCI_DGV_SET_BITSPERSAMPLE               (MCI_DGV_ITEM_BASE+3)
      MCI_DGV_SET_SAMPLESPERSEC               (MCI_DGV_ITEM_BASE+4)
      MCI_DGV_SET_FORMATTAG                   (MCI_DGV_ITEM_BASE+5)
      MCI_DGV_SET_BLOCKALIGN                  (MCI_DGV_ITEM_BASE+6)
      MCI_DGV_SET_AVGBYTESPERSEC              (MCI_DGV_ITEM_BASE+7)

      MCI_DGV_SET_VIDEO_COMPRESSION_SUBTYPE   (MCI_DGV_ITEM_BASE+8)
      MCI_DGV_SET_VIDEO_RECORD_RATE           (MCI_DGV_ITEM_BASE+9)
      MCI_DGV_SET_VIDEO_RECORD_FRAME_DURATION (MCI_DGV_ITEM_BASE+10)
      MCI_DGV_SET_RECORD_AUDIO                (MCI_DGV_ITEM_BASE+11)
      MCI_DGV_SET_TRANSPARENT_COLOR           (MCI_DGV_ITEM_BASE+12)
      MCI_DGV_SET_GRAPHIC_TRANSPARENT_COLOR   (MCI_DGV_ITEM_BASE+12)
      MCI_DGV_SET_AUDIOSYNC                   (MCI_DGV_ITEM_BASE+13)
      MCI_DGV_SET_VIDEO_TRANSPARENT_COLOR     (MCI_DGV_ITEM_BASE+14)

*)
/*******************************************************/
/* General MCI_SET item values                         */
/*******************************************************/
Const MCI_SET_MONITOR                   = $00000001;
      MCI_SET_MONITOR_AUDIO             = $00000002;
      MCI_SET_MONITOR_VIDEO             = $00000003;
      MCI_SET_RECORD                    = $00000004;

/*******************************************************/
/* MCI_SET item values for amp/mixer                   */
/*******************************************************/
      MCI_AMP_SET_MONITOR               = MCI_SET_MONITOR_AUDIO;
      MCI_AMP_SET_AUDIO                 = $00000008;

/*********************************************************************/
/* potential values for the ulValue field of MCI_AMP_GETDEVCAPS  */
/*********************************************************************/
Const  MCI_AMP_CAN_SET_MONITOR         = MCI_AMP_SET_MONITOR;
       MCI_AMP_CAN_SET_BALANCE         = MCI_AMP_SET_BALANCE;
       MCI_AMP_CAN_SET_ALC             = MCI_AMP_SET_ALC;
       MCI_AMP_CAN_SET_CROSSOVER       = MCI_AMP_SET_CROSSOVER;
       MCI_AMP_CAN_SET_LOUDNESS        = MCI_AMP_SET_LOUDNESS;
       MCI_AMP_CAN_SET_MUTE            = MCI_AMP_SET_MUTE;
       MCI_AMP_CAN_SET_REVERB          = MCI_AMP_SET_REVERB;
       MCI_AMP_CAN_SET_STEREOENHANCE   = MCI_AMP_SET_STEREOENHANCE;
       MCI_AMP_CAN_SET_CUSTOM1         = MCI_AMP_SET_CUSTOM1;
       MCI_AMP_CAN_SET_CUSTOM2         = MCI_AMP_SET_CUSTOM2;
       MCI_AMP_CAN_SET_CUSTOM3         = MCI_AMP_SET_CUSTOM3;
       MCI_AMP_CAN_SET_LRVOLUME        = MCI_AMP_SET_LRVOLUME;
       MCI_AMP_CAN_SET_BASS            = MCI_AMP_SET_BASS;
       MCI_AMP_CAN_SET_MID             = MCI_AMP_SET_MID;
       MCI_AMP_CAN_SET_TREBLE          = MCI_AMP_SET_TREBLE;
       MCI_AMP_CAN_SET_PITCH           = MCI_AMP_SET_PITCH;
       MCI_AMP_CAN_SET_GAIN            = MCI_AMP_SET_GAIN;
       MCI_AMP_CAN_SET_CHORUS          = MCI_AMP_SET_CHORUS;
       MCI_AMP_CAN_SET_VOLUME          = MCI_AMP_SET_VOLUME;

/*******************************************************/
/* Video file format                                   */
/*******************************************************/
      MCI_VID_FILE_FORMAT_AVI     = $20495641;

(*
/*******************************************************/
/* Audio/video/image compression types                 */
/*******************************************************/
      MCI_AUD_COMP_ADPCM4          $00000001L
      MCI_AUD_COMP_PCM8            $00000002L

      MCI_VID_COMP_RTV_2_0         $00000101L
      MCI_VID_COMP_RTV_2_1         $00000102L
      MCI_VID_COMP_ULTI            $49544C55L
      MCI_VID_COMP_RT21            $31325452L
      MCI_VID_COMP_NONE            $20424944L   /* This is 'DIB ' now.    */

      MCI_IMG_COMP_NONE            $00000201L
      MCI_IMG_COMP_PIC9_1_0        $00000202L
      MCI_IMG_COMP_PIC16_1_0       $00000203L
      MCI_IMG_COMP_JPEG9           $00000204L
      MCI_IMG_COMP_JPEG9_1_0       MCI_IMG_COMP_JPEG9
      MCI_IMG_COMP_BMP_RLE4        $00000205L
      MCI_IMG_COMP_BMP_RLE8        $00000206L
      MCI_IMG_COMP_JPEGN           $00000207L

/*******************************************************/
/* PEL Formats (video/image)                           */
/*******************************************************/
      MCI_VID_PALETTE              $00000001L
      MCI_VID_RGB                  $00000002L
      MCI_VID_YUV                  $00000003L

      MCI_IMG_PALETTE              MCI_VID_PALETTE
      MCI_IMG_RGB                  MCI_VID_RGB
      MCI_IMG_YUV                  MCI_VID_YUV


/*******************************************************/
/* Audio/video/image quality levels                    */
/*******************************************************/
      MCI_AUD_QUALITY_HIGH         $00000001L
      MCI_AUD_QUALITY_MED          $00000002L
      MCI_AUD_QUALITY_LOW          $00000003L

      MCI_VID_QUALITY_HIGH         $00000101L
      MCI_VID_QUALITY_MED          $00000102L
      MCI_VID_QUALITY_LOW          $00000103L
      MCI_VID_QUALITY_BEST         MCI_VID_QUALITY_HIGH
      MCI_VID_QUALITY_CDROM        MCI_VID_QUALITY_MED
      MCI_VID_QUALITY_COMPACT      MCI_VID_QUALITY_LOW
      MCI_VID_QUALITY_BETTER       MCI_VID_QUALITY_MED
      MCI_VID_QUALITY_GOOD         MCI_VID_QUALITY_LOW

      MCI_IMG_QUALITY_HIGH         $00000201L
      MCI_IMG_QUALITY_MED          $00000202L
      MCI_IMG_QUALITY_LOW          $00000203L

/*******************************************************/
/* MCI_SET flags for wave audio                        */
/*******************************************************/
      MCI_WAVE_SET_SAMPLESPERSEC          $01000000L
      MCI_WAVE_SET_AVGBYTESPERSEC         $02000000L
      MCI_WAVE_SET_BLOCKALIGN             $04000000L
      MCI_WAVE_SET_FORMATTAG              $08000000L
      MCI_WAVE_SET_CHANNELS               $10000000L
      MCI_WAVE_SET_BITSPERSAMPLE          $80000000L

/*******************************************************/
/* Wave format tag defines                             */
/*******************************************************/
      MCI_WAVE_FORMAT_PCM                 DATATYPE_WAVEFORM
      MCI_WAVE_FORMAT_ADPCM               $0002L
      MCI_WAVE_FORMAT_IBM_CVSD            $0005L
      MCI_WAVE_FORMAT_ALAW                DATATYPE_RIFF_ALAW
      MCI_WAVE_FORMAT_MULAW               DATATYPE_RIFF_MULAW
      MCI_WAVE_FORMAT_OKI_ADPCM           $0010L
      MCI_WAVE_FORMAT_DVI_ADPCM           $0011L
      MCI_WAVE_FORMAT_DIGISTD             $0015L
      MCI_WAVE_FORMAT_DIGIFIX             $0016L
      MCI_WAVE_FORMAT_AVC_ADPCM           DATATYPE_ADPCM_AVC
      MCI_WAVE_FORMAT_IBM_ADPCM           DATATYPE_ADPCM_AVC
      MCI_WAVE_FORMAT_IBM_MULAW           DATATYPE_MULAW
      MCI_WAVE_FORMAT_IBM_ALAW            DATATYPE_ALAW
      MCI_WAVE_FORMAT_CT_ADPCM            DATATYPE_CT_ADPCM
      MCI_WAVE_FORMAT_MPEG1               DATATYPE_MPEG1AUDIO

/*******************************************************/
/* MCI_SET flags for sequencer                         */
/*******************************************************/
      MCI_SEQ_SET_TEMPO                   $00100000L
      MCI_SEQ_SET_PORT                    $00200000L
      MCI_SEQ_ENABLE_PORT_MAPPER          $00400000L
      MCI_SEQ_DISABLE_PORT_MAPPER         $00800000L
      MCI_SEQ_SET_OFFSET                  $01000000L
      MCI_SEQ_SET_MASTER                  $02000000L
      MCI_SEQ_SET_SLAVE                   $04000000L

   /**********************************************/
   /* SEQ time formats                           */
   /**********************************************/
         MCI_SEQ_SET_SMPTE_24             $00000100L
         MCI_SEQ_SET_SMPTE_25             $00000200L
         MCI_SEQ_SET_SMPTE_30             $00000300L
         MCI_SEQ_SET_SMPTE_30DROP         $00000400L
         MCI_SEQ_SET_SONGPTR              $00000500L

   /**********************************************/
   /* SEQ synchronization types                  */
   /**********************************************/
         MCI_SEQ_MIDI                     $00000001L
         MCI_SEQ_SMPTE                    $00000002L
         MCI_SEQ_FILE                     $00000003L
         MCI_SEQ_NONE                     $00000004L

   /**********************************************/
   /* SEQ PORT TYPES                             */
   /**********************************************/
         MCI_SET_NONE                     $10000000L
         MIDI_MAPPER                      $20000000L
         MCI_MIDI_MAPPER                  MIDI_MAPPER
*)

type
  pmci_Set_Parms = ^mci_Set_Parms;
  mci_Set_Parms = record
    hwndCallback  : hwnd;        { PM window handle for MCI notify message }
    ulTimeFormat  : uLong;       { Time format to be used by the device }
    ulSpeedFormat : uLong;       { Speed format used by this device }
    ulAudio       : uLong;       { Channel number for this operation }
                                 { (MCI_SET_AUDIO_LEFT, MCI_SET_AUDIO_RIGHT, }
                                 {  MCI_SET_AUDIO_ALL) }
    ulLevel       : uLong;       { Volume, treble or bass level as % of max. }
    ulOver        : uLong;       { Delay time for vectored change in millisecond }
    ulItem        : uLong;       { Item field for set item flags }
    ulValue       : uLong;       { Value associated with item flag }
  end;

(*
typedef struct _MCI_SET_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message        */
    ULONG   ulTimeFormat;    /* Time format to be used by the device           */
    ULONG   ulSpeedFormat;   /* Speed format used by this device               */
    ULONG   ulAudio;         /* Channel number for this operation              */
                             /* (MCI_SET_AUDIO_LEFT, MCI_SET_AUDIO_RIGHT,      */
                             /*  MCI_SET_AUDIO_ALL)                            */
    ULONG   ulLevel;         /* Volume, treble or bass level as % of max.      */
    ULONG   ulOver;          /* Delay time for vectored change in milliseconds */
    ULONG   ulItem;          /* Item field for set item flags                  */
    ULONG   ulValue;         /* Value associated with item flag                */
} MCI_SET_PARMS;
typedef MCI_SET_PARMS       *PMCI_SET_PARMS;
*)

type
  pmci_Amp_Set_Parms           = ^mci_Amp_Set_Parms;
  mci_Amp_Set_Parms            = mci_Set_Parms;

  pmci_DGV_Set_Parms           = ^mci_DGV_Set_Parms;
  mci_DGV_Set_Parms            = mci_Set_Parms;

  pmci_Ovly_Set_Parms          = ^mci_Ovly_Set_Parms;
  mci_Ovly_Set_Parms           = mci_Set_Parms;

(*
typedef MCI_SET_PARMS       MCI_AMP_SET_PARMS;
typedef MCI_AMP_SET_PARMS   *PMCI_AMP_SET_PARMS;

typedef MCI_SET_PARMS       MCI_DGV_SET_PARMS;
typedef MCI_DGV_SET_PARMS   *PMCI_DGV_SET_PARMS;

typedef MCI_SET_PARMS       MCI_OVLY_SET_PARMS;
typedef MCI_OVLY_SET_PARMS  *PMCI_OVLY_SET_PARMS;

typedef struct _MCI_CDXA_SET_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message        */
    ULONG   ulTimeFormat;    /* Time format to be used by the device           */
    ULONG   ulSpeedFormat;   /* Speed format used by this device               */
    ULONG   ulAudio;         /* Channel number for this operation              */
                             /* (MCI_SET_AUDIO_LEFT, MCI_SET_AUDIO_RIGHT,      */
                             /*  MCI_SET_AUDIO_ALL)                            */
    ULONG   ulLevel;         /* Volume, treble or bass level as % of max.      */
    ULONG   ulOver;          /* Delay time for vectored change in milliseconds */
    ULONG   ulItem;          /* Item field for set item flags                  */
    ULONG   ulValue;         /* Value associated with item flag                */
    ULONG   ulChannel;       /* Channel number                                 */
    PVOID   pPlayList;       /* Pointer to play list                           */
    ULONG   ulPlayListSize;  /* Play list size                                 */
} MCI_CDXA_SET_PARMS;
typedef MCI_CDXA_SET_PARMS   *PMCI_CDXA_SET_PARMS;

typedef struct _MCI_VD_SET_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message        */
    ULONG   ulTimeFormat;    /* Time format to be used by the device           */
    ULONG   ulSpeedFormat;   /* Speed format used by this device               */
    ULONG   ulAudio;         /* Channel number for this operation              */
                             /* (MCI_SET_AUDIO_LEFT, MCI_SET_AUDIO_RIGHT,      */
                             /*  MCI_SET_AUDIO_ALL)                            */
    ULONG   ulLevel;         /* Volume, treble or bass level as % of max.      */
    ULONG   ulOver;          /* Delay time for vectored change in milliseconds */
    ULONG   ulItem;          /* Item field for set item flags                  */
    ULONG   ulValue;         /* Value associated with item flag                */
    ULONG   ulChannel;       /* Videodisc channel                              */
} MCI_VD_SET_PARMS;
typedef MCI_VD_SET_PARMS   *PMCI_VD_SET_PARMS;

typedef struct _MCI_WAVE_SET_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message        */
    ULONG   ulTimeFormat;    /* Time format to be used by the device           */
    ULONG   ulSpeedFormat;   /* Speed format used by this device               */
    ULONG   ulAudio;         /* Channel number for this operation              */
                             /* (MCI_SET_AUDIO_LEFT, MCI_SET_AUDIO_RIGHT,      */
                             /*  MCI_SET_AUDIO_ALL)                            */
    ULONG   ulLevel;         /* Volume, trebble or bass level as % of max.     */
    ULONG   ulOver;          /* Delay time for vectored change in milliseconds */
    ULONG   ulItem;          /* Item field for set item flags                  */
    ULONG   ulValue;         /* Value associated with item flag                */
    USHORT  usInput;         /* Channel for input                              */
    USHORT  usReserved0;     /* Reserved field                                 */
    USHORT  usOutput;        /* Channel for output                             */
    USHORT  usReserved1;     /* Reserved field                                 */
    USHORT  usFormatTag;     /* Format tag                                     */
    USHORT  usReserved2;     /* Reserved field                                 */
    USHORT  usChannels;      /* mono(1) or stereo(2)                           */
    USHORT  usReserved3;     /* Reserved field                                 */
    ULONG   ulSamplesPerSec; /* Samples per seconds                            */
    ULONG   ulAvgBytesPerSec;/* Bytes per seconds                              */
    USHORT  usBlockAlign;    /* Block alignment of data                        */
    USHORT  usReserved4;     /* Reserved field                                 */
    USHORT  usBitsPerSample; /* Bits per seconds                               */
    USHORT  usReserved5;     /* Reserved field                                 */
} MCI_WAVE_SET_PARMS;
typedef MCI_WAVE_SET_PARMS   *PMCI_WAVE_SET_PARMS;

typedef struct _MCI_SEQ_SET_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message        */
    ULONG   ulTimeFormat;    /* Time format to be used by the device           */
    ULONG   ulSpeedFormat;   /* Speed format used by this device               */
    ULONG   ulAudio;         /* Channel number for this operation              */
                             /* (MCI_SET_AUDIO_LEFT, MCI_SET_AUDIO_RIGHT,      */
                             /*  MCI_SET_AUDIO_ALL)                            */
    ULONG   ulLevel;         /* Volume, trebble or bass level as % of max.     */
    ULONG   ulOver;          /* Delay time for vectored change in milliseconds */
    ULONG   ulItem;          /* Item field for set item flags                  */
    ULONG   ulValue;         /* Value associated with item flag                */
    ULONG   ulTempo;         /* Specified the tempo                            */
    ULONG   ulPort;          /* Output port                                    */
    ULONG   ulSlave;         /* Unused field                                   */
    ULONG   ulMaster;        /* Unused field                                   */
    ULONG   ulOffset;        /* Specified the data offset                      */
} MCI_SEQ_SET_PARMS;
typedef MCI_SEQ_SET_PARMS   *PMCI_SEQ_SET_PARMS;


/*********************************************************************/
/* parameters for the MCI_SET_CUEPOINT message                       */
/*     $0000$00 are reserved for MCI_SET_CUEPOINT flags            */
/*********************************************************************/
      MCI_SET_CUEPOINT_ON                 $00000100L
      MCI_SET_CUEPOINT_OFF                $00000200L

typedef struct _MCI_CUEPOINT_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message        */
    ULONG   ulCuepoint;      /* Specifies the cuepoint location                */
    USHORT  usUserParm;      /* User parmameter returned on cuepoint           */
                             /* notify message                                 */
    USHORT  usReserved0;     /* Reserved field                                 */
} MCI_CUEPOINT_PARMS;
typedef MCI_CUEPOINT_PARMS   *PMCI_CUEPOINT_PARMS;

/*********************************************************************/
/* parameters for the MCI_SETIMAGEPALETTE message                    */
/*     $00$XX00 are reserved for MCI_SETIMAGEPALETTE flags         */
/*********************************************************************/
      MCI_SET_REGISTERED                  $00000100L

/*********************************************************************/
/* flags and parameter structure for the MCI_SET_POSITION_ADVISE msg */
/*     $0000$00 are reserved for MCI_SET_POSITION_ADVISE flags     */
/*********************************************************************/
      MCI_SET_POSITION_ADVISE_ON          $00000100L
      MCI_SET_POSITION_ADVISE_OFF         $00000200L

typedef struct _MCI_POSITION_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message        */
    ULONG   ulUnits;         /* Specifies position change notifiication        */
                             /* granularity                                    */
    USHORT  usUserParm;      /* User parameter returned on position change     */
                             /* notification message.                          */
    USHORT  Reserved0;       /* Reserved field                                 */
    ULONG   Reserved1;       /* Reserved field                                 */
    } MCI_POSITION_PARMS;
typedef MCI_POSITION_PARMS   *PMCI_POSITION_PARMS;

/*********************************************************************/
/* parameter structure for the MCI_SET_SYNC_OFFSET message           */
/*********************************************************************/
typedef struct _MCI_SYNC_OFFSET_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message        */
    ULONG   ulOffset;        /* Specifies the device media position offset     */
                             /* in the currently specified device units.       */
} MCI_SYNC_OFFSET_PARMS;
typedef MCI_SYNC_OFFSET_PARMS   *PMCI_SYNC_OFFSET_PARMS;

/*********************************************************************/
/* flags for the MCI_SPIN message                                    */
/*     $0000$00 are reserved for MCI_SPIN flags                    */
/*********************************************************************/
      MCI_SPIN_UP                         $00000100L
      MCI_SPIN_DOWN                       $00000200L

/*********************************************************************/
/* MCI_STATUS message flags                                          */
/*     $00$XX00 are reserved for MCI_STATUS flags                  */
/*     MCI_VOLUME and MCI_VOLUME_DELAY are $00000100 and $00000200 */
/*********************************************************************/
      MCI_STATUS_ITEM                     $00000100L
      MCI_STATUS_START                    $00000200L
      MCI_STATUS_CONNECTOR                $00000400L

/*************************************************/
/* General MCI_STATUS item values                */
/*************************************************/
      MCI_STATUS_CURRENT_TRACK            $00000001L
      MCI_STATUS_LENGTH                   $00000002L
      MCI_STATUS_MODE                     $00000003L
      MCI_STATUS_NUMBER_OF_TRACKS         $00000004L
      MCI_STATUS_POSITION                 $00000005L
      MCI_STATUS_POSITION_IN_TRACK        $00000006L
      MCI_STATUS_MEDIA_PRESENT            $00000007L
      MCI_STATUS_VOLUME                   $00000008L
      MCI_STATUS_READY                    $00000009L
      MCI_STATUS_TIME_FORMAT              $0000000AL
      MCI_STATUS_SPEED_FORMAT             $0000000BL
      MCI_STATUS_MONITOR                  $0000000CL
      MCI_STATUS_AUDIO                    $0000000DL
      MCI_STATUS_VIDEO                    $0000000EL
      MCI_STATUS_CLIPBOARD                $0000000FL
      MCI_STATUS_CAN_PASTE                $00000010L
      MCI_STATUS_CAN_REDO                 $00000020L
      MCI_STATUS_CAN_UNDO                 $00000030L

   /*************************************************/
   /* ulValue field values for MCI_STATUS_AUDIO     */
   /*************************************************/
      MCI_STATUS_AUDIO_ALL                   $00000000L
      MCI_STATUS_AUDIO_LEFT                  $00000001L
      MCI_STATUS_AUDIO_RIGHT                 $00000002L

/*************************************************/
/* MCI_STATUS item values for amp/mixer          */
/*************************************************/
      MCI_AMP_STATUS_PITCH                MCI_AMP_ITEM_BASE
      MCI_AMP_STATUS_TREBLE               (MCI_AMP_ITEM_BASE+1)
      MCI_AMP_STATUS_BASS                 (MCI_AMP_ITEM_BASE+2)
      MCI_AMP_STATUS_BALANCE              (MCI_AMP_ITEM_BASE+3)
      MCI_AMP_STATUS_GAIN                 (MCI_AMP_ITEM_BASE+4)
      MCI_AMP_STATUS_MONITOR              (MCI_AMP_ITEM_BASE+5)
      MCI_AMP_STATUS_MID                  (MCI_AMP_ITEM_BASE+6)
      MCI_AMP_STATUS_VOLUME               MCI_STATUS_VOLUME
      MCI_AMP_STATUS_LOUDNESS             (MCI_AMP_ITEM_BASE+7)
      MCI_AMP_STATUS_CROSSOVER            (MCI_AMP_ITEM_BASE+8)
      MCI_AMP_STATUS_REVERB               (MCI_AMP_ITEM_BASE+9)
      MCI_AMP_STATUS_ALC                  (MCI_AMP_ITEM_BASE+10)
      MCI_AMP_STATUS_CHORUS               (MCI_AMP_ITEM_BASE+11)
      MCI_AMP_STATUS_CUSTOM1              (MCI_AMP_ITEM_BASE+12)
      MCI_AMP_STATUS_CUSTOM2              (MCI_AMP_ITEM_BASE+13)
      MCI_AMP_STATUS_CUSTOM3              (MCI_AMP_ITEM_BASE+14)


/*************************************************/
/* MCI_STATUS item values for cd audio           */
/*************************************************/
      MCI_CD_STATUS_TRACK_TYPE            MCI_CD_ITEM_BASE
      MCI_CD_STATUS_TRACK_COPYPERMITTED   (MCI_CD_ITEM_BASE+1)
      MCI_CD_STATUS_TRACK_CHANNELS        (MCI_CD_ITEM_BASE+2)
      MCI_CD_STATUS_TRACK_PREEMPHASIS     (MCI_CD_ITEM_BASE+3)

    /************************************************/
    /* return values for CD MCI_STATUS message with */
    /*   MCI_CD_STATUS_TRACK_TYPE set               */
    /************************************************/
      MCI_CD_TRACK_AUDIO                  $00000001L
      MCI_CD_TRACK_DATA                   $00000002L
      MCI_CD_TRACK_OTHER                  $00000003L

/*************************************************/
/* MCI_STATUS item values for CDXA               */
/*************************************************/
      MCI_CDXA_STATUS_CHANNEL             MCI_CDXA_ITEM_BASE

    /************************************************/
    /*returned from call for MCI_CDXA_STATUS_CHANNEL*/
    /************************************************/
      MCI_CDXA_NONE                       $00000000L


/*************************************************/
/* MCI_STATUS item values for sequencer          */
/*************************************************/
      MCI_SEQ_STATUS_TEMPO                MCI_SEQ_ITEM_BASE
      MCI_SEQ_STATUS_OFFSET               (MCI_SEQ_ITEM_BASE+1)
      MCI_SEQ_STATUS_DIVTYPE              (MCI_SEQ_ITEM_BASE+2)
      MCI_SEQ_STATUS_MASTER               (MCI_SEQ_ITEM_BASE+3)
      MCI_SEQ_STATUS_PORT                 (MCI_SEQ_ITEM_BASE+4)
      MCI_SEQ_STATUS_SLAVE                (MCI_SEQ_ITEM_BASE+5)

   /**********************************************/
   /* Return value for current division type     */
   /**********************************************/
      MCI_SEQ_DIV_PPQN                    $00000001L
      MCI_SEQ_DIV_SMPTE_24                $00000002L
      MCI_SEQ_DIV_SMPTE_25                $00000003L
      MCI_SEQ_DIV_SMPTE_30DROP            $00000004L
      MCI_SEQ_DIV_SMPTE_30                $00000005L

   /*************************************************/
   /* MCI_STATUS items for videodisc                */
   /*************************************************/
      MCI_VD_STATUS_SPEED                 MCI_VD_ITEM_BASE
      MCI_VD_STATUS_FORWARD               (MCI_VD_ITEM_BASE+1)
      MCI_VD_MEDIA_TYPE                   (MCI_VD_ITEM_BASE+2)
      MCI_VD_STATUS_SIDE                  (MCI_VD_ITEM_BASE+3)
      MCI_VD_STATUS_DISC_SIZE             (MCI_VD_ITEM_BASE+4)

    /***********************************************/
    /* return values for videodisc status command  */
    /***********************************************/
      MCI_VD_SPEED_NORMAL                 $00000000L
      MCI_VD_SPEED_FAST                   $00000001L
      MCI_VD_SPEED_SLOW                   $00000002L

/*************************************************/
/* MCI_STATUS items for wave audio               */
/*************************************************/
      MCI_WAVE_STATUS_LEVEL               MCI_WAVE_ITEM_BASE
      MCI_WAVE_STATUS_SAMPLESPERSEC       (MCI_WAVE_ITEM_BASE+1)
      MCI_WAVE_STATUS_AVGBYTESPERSEC      (MCI_WAVE_ITEM_BASE+2)
      MCI_WAVE_STATUS_BLOCKALIGN          (MCI_WAVE_ITEM_BASE+3)
      MCI_WAVE_STATUS_FORMATTAG           (MCI_WAVE_ITEM_BASE+4)
      MCI_WAVE_STATUS_CHANNELS            (MCI_WAVE_ITEM_BASE+5)
      MCI_WAVE_STATUS_BITSPERSAMPLE       (MCI_WAVE_ITEM_BASE+6)

/*************************************************/
/* Common video MCI_STATUS items                 */
/*************************************************/
      MCI_VID_STATUS_HWND                 MCI_VID_ITEM_BASE
      MCI_VID_STATUS_AUDIO_COMPRESSION    (MCI_VID_ITEM_BASE+1)
      MCI_VID_STATUS_VIDEO_COMPRESSION    (MCI_VID_ITEM_BASE+2)
      MCI_VID_STATUS_IMAGE_COMPRESSION    (MCI_VID_ITEM_BASE+3)
      MCI_VID_STATUS_AUDIO_QUALITY        (MCI_VID_ITEM_BASE+4)
      MCI_VID_STATUS_VIDEO_QUALITY        (MCI_VID_ITEM_BASE+5)
      MCI_VID_STATUS_IMAGE_QUALITY        (MCI_VID_ITEM_BASE+6)
      MCI_VID_STATUS_IMAGE_BITSPERPEL     (MCI_VID_ITEM_BASE+7)
      MCI_VID_STATUS_IMAGE_PELFORMAT      (MCI_VID_ITEM_BASE+8)
      MCI_VID_STATUS_FORWARD              (MCI_VID_ITEM_BASE+9)
      MCI_VID_STATUS_NORMAL_RATE          (MCI_VID_ITEM_BASE+10)
      MCI_VID_STATUS_VIDEO_X_EXTENT       (MCI_VID_ITEM_BASE+11)
      MCI_VID_STATUS_VIDEO_Y_EXTENT       (MCI_VID_ITEM_BASE+12)
      MCI_VID_STATUS_IMAGE_X_EXTENT       (MCI_VID_ITEM_BASE+13)
      MCI_VID_STATUS_IMAGE_Y_EXTENT       (MCI_VID_ITEM_BASE+14)
      MCI_VID_STATUS_BRIGHTNESS           (MCI_VID_ITEM_BASE+15)
      MCI_VID_STATUS_CONTRAST             (MCI_VID_ITEM_BASE+16)
      MCI_VID_STATUS_HUE                  (MCI_VID_ITEM_BASE+17)
      MCI_VID_STATUS_SATURATION           (MCI_VID_ITEM_BASE+18)
      MCI_VID_STATUS_GREYSCALE            (MCI_VID_ITEM_BASE+19)
      MCI_VID_STATUS_SHARPNESS            (MCI_VID_ITEM_BASE+20)
      MCI_VID_STATUS_SPEED                (MCI_VID_ITEM_BASE+21)
      MCI_VID_STATUS_IMAGE_FILE_FORMAT    (MCI_VID_ITEM_BASE+22)
      MCI_VID_STATUS_TRANSPARENT_TYPE     (MCI_VID_ITEM_BASE+23)
      MCI_VID_STATUS_REF_INTERVAL         (MCI_VID_ITEM_BASE+24)
      MCI_VID_STATUS_MAXDATARATE          (MCI_VID_ITEM_BASE+25)
      MCI_VID_STATUS_VIDEO_FILE_FORMAT    (MCI_VID_ITEM_BASE+26)

   /*************************************************/
   /* Status Transparent Type returns               */
   /* MCI_VID_PALETTE                               */
   /* MCI_VID_RGB                                   */
   /* MCI_VID_YUV                                   */
   /*************************************************/
      MCI_VID_STATUS_TRANSPARENT_COLOR    (MCI_VID_ITEM_BASE+24)

/*************************************************/
/* MCI_STATUS items for digital video            */
/*************************************************/
      MCI_DGV_STATUS_HWND                 MCI_VID_STATUS_HWND
      MCI_DGV_STATUS_AUDIO_COMPRESSION    MCI_VID_STATUS_AUDIO_COMPRESSION
      MCI_DGV_STATUS_VIDEO_COMPRESSION    MCI_VID_STATUS_VIDEO_COMPRESSION
      MCI_DGV_STATUS_IMAGE_COMPRESSION    MCI_VID_STATUS_IMAGE_COMPRESSION
      MCI_DGV_STATUS_AUDIO_QUALITY        MCI_VID_STATUS_AUDIO_QUALITY
      MCI_DGV_STATUS_VIDEO_QUALITY        MCI_VID_STATUS_VIDEO_QUALITY
      MCI_DGV_STATUS_IMAGE_QUALITY        MCI_VID_STATUS_IMAGE_QUALITY
      MCI_DGV_STATUS_IMAGE_BITSPERPEL     MCI_VID_STATUS_IMAGE_BITSPERPEL
      MCI_DGV_STATUS_IMAGE_PELFORMAT      MCI_VID_STATUS_IMAGE_PELFORMAT
      MCI_DGV_STATUS_FORWARD              MCI_VID_STATUS_FORWARD
      MCI_DGV_STATUS_NORMAL_RATE          MCI_VID_STATUS_NORMAL_RATE
      MCI_DGV_STATUS_VIDEO_X_EXTENT       MCI_VID_STATUS_VIDEO_X_EXTENT
      MCI_DGV_STATUS_VIDEO_Y_EXTENT       MCI_VID_STATUS_VIDEO_Y_EXTENT
      MCI_DGV_STATUS_IMAGE_X_EXTENT       MCI_VID_STATUS_IMAGE_X_EXTENT
      MCI_DGV_STATUS_IMAGE_Y_EXTENT       MCI_VID_STATUS_IMAGE_Y_EXTENT
      MCI_DGV_STATUS_BRIGHTNESS           MCI_VID_STATUS_BRIGHTNESS
      MCI_DGV_STATUS_CONTRAST             MCI_VID_STATUS_CONTRAST
      MCI_DGV_STATUS_HUE                  MCI_VID_STATUS_HUE
      MCI_DGV_STATUS_SATURATION           MCI_VID_STATUS_SATURATION
      MCI_DGV_STATUS_SPEED                MCI_VID_STATUS_SPEED
      MCI_DGV_STATUS_SHARPNESS            MCI_VID_STATUS_SHARPNESS
      MCI_DGV_STATUS_REF_INTERVAL         MCI_VID_STATUS_REF_INTERVAL
      MCI_DGV_STATUS_MAXDATARATE          MCI_VID_STATUS_MAXDATARATE
      MCI_DGV_STATUS_VIDEO_FILE_FORMAT    MCI_VID_STATUS_VIDEO_FILE_FORMAT

      MCI_DGV_STATUS_CHANNELS             (MCI_DGV_ITEM_BASE+13)
      MCI_DGV_STATUS_BITSPERSAMPLE        (MCI_DGV_ITEM_BASE+14)
      MCI_DGV_STATUS_SAMPLESPERSEC        (MCI_DGV_ITEM_BASE+15)
      MCI_DGV_STATUS_FORMATTAG            (MCI_DGV_ITEM_BASE+16)
      MCI_DGV_STATUS_BLOCKALIGN           (MCI_DGV_ITEM_BASE+17)
      MCI_DGV_STATUS_AVGBYTESPERSEC       (MCI_DGV_ITEM_BASE+18)
      MCI_DGV_STATUS_VIDEO_COMPRESSION_SUBTYPE   (MCI_DGV_ITEM_BASE+19)
      MCI_DGV_STATUS_VIDEO_RECORD_RATE           (MCI_DGV_ITEM_BASE+20)
      MCI_DGV_STATUS_VIDEO_RECORD_FRAME_DURATION (MCI_DGV_ITEM_BASE+21)
      MCI_DGV_STATUS_RECORD_AUDIO         (MCI_DGV_ITEM_BASE+22)
      MCI_DGV_STATUS_TRANSPARENT_COLOR    (MCI_DGV_ITEM_BASE+23)
      MCI_DGV_STATUS_GRAPHIC_TRANSPARENT_COLOR (MCI_DGV_ITEM_BASE+23)  /* MUST BE SAME AS TRANSPARENT COLOR */
      MCI_DGV_STATUS_HWND_MONITOR         (MCI_DGV_ITEM_BASE+24)
      MCI_DGV_STATUS_DROPPED_FRAME_PCT    (MCI_DGV_ITEM_BASE+25)
      MCI_DGV_STATUS_AUDIOSYNC            (MCI_DGV_ITEM_BASE+26)
      MCI_DGV_STATUS_AUDIOSYNC_DIRECTION  (MCI_DGV_ITEM_BASE+27)
      MCI_DGV_STATUS_VIDEO_TRANSPARENT_COLOR (MCI_DGV_ITEM_BASE+28)  /* MUST BE SAME AS TRANSPARENT COLOR */
      MCI_DGV_STATUS_TUNER_TV_CHANNEL     (MCI_DGV_ITEM_BASE+29)
      MCI_DGV_STATUS_TUNER_LOW_TV_CHANNEL (MCI_DGV_ITEM_BASE+29)
      MCI_DGV_STATUS_TUNER_HIGH_TV_CHANNEL (MCI_DGV_ITEM_BASE+29)
      MCI_DGV_STATUS_TUNER_REGION          (MCI_DGV_ITEM_BASE+30)
      MCI_DGV_STATUS_TUNER_FINETUNE        (MCI_DGV_ITEM_BASE+31)
      MCI_DGV_STATUS_TUNER_FREQUENCY       (MCI_DGV_ITEM_BASE+32)
      MCI_DGV_STATUS_TUNER_AUDIO_CHANNEL   (MCI_DGV_ITEM_BASE+33)
      MCI_DGV_STATUS_TUNER_AFC             (MCI_DGV_ITEM_BASE+34)
      MCI_DGV_STATUS_VALID_SIGNAL          (MCI_DGV_ITEM_BASE+35)

/*************************************************/
/* MCI_STATUS item values for video overlay      */
/*************************************************/
      MCI_OVLY_STATUS_HWND                 MCI_VID_STATUS_HWND
      MCI_OVLY_STATUS_IMAGE_COMPRESSION    MCI_VID_STATUS_IMAGE_COMPRESSION
      MCI_OVLY_STATUS_IMAGE_BITSPERPEL     MCI_VID_STATUS_IMAGE_BITSPERPEL
      MCI_OVLY_STATUS_IMAGE_PELFORMAT      MCI_VID_STATUS_IMAGE_PELFORMAT
      MCI_OVLY_STATUS_IMAGE_X_EXTENT       MCI_VID_STATUS_IMAGE_X_EXTENT
      MCI_OVLY_STATUS_IMAGE_Y_EXTENT       MCI_VID_STATUS_IMAGE_Y_EXTENT
      MCI_OVLY_STATUS_BRIGHTNESS           MCI_VID_STATUS_BRIGHTNESS
      MCI_OVLY_STATUS_CONTRAST             MCI_VID_STATUS_CONTRAST
      MCI_OVLY_STATUS_HUE                  MCI_VID_STATUS_HUE
      MCI_OVLY_STATUS_SATURATION           MCI_VID_STATUS_SATURATION
      MCI_OVLY_STATUS_GREYSCALE            MCI_VID_STATUS_GREYSCALE
      MCI_OVLY_STATUS_IMAGE_QUALITY        MCI_VID_STATUS_IMAGE_QUALITY
      MCI_OVLY_STATUS_SHARPNESS            MCI_VID_STATUS_SHARPNESS
      MCI_OVLY_STATUS_IMAGE_FILE_FORMAT    MCI_VID_STATUS_IMAGE_FILE_FORMAT
      MCI_OVLY_STATUS_TRANSPARENT_TYPE     MCI_VID_STATUS_TRANSPARENT_TYPE
      MCI_OVLY_STATUS_TRANSPARENT_COLOR    MCI_VID_STATUS_TRANSPARENT_COLOR

   /*************************************************/
   /* Status Mode return values                     */
   /*************************************************/
      MCI_MODE_NOT_READY                  $00000001L
      MCI_MODE_PAUSE                      $00000002L
      MCI_MODE_PLAY                       $00000003L
      MCI_MODE_STOP                       $00000004L
      MCI_MODE_RECORD                     $00000005L
      MCI_MODE_SEEK                       $00000006L

   /*************************************************/
   /* Status Direction return values                */
   /*************************************************/
      MCI_FORWARD                         $00000000L
      MCI_REVERSE                         $00000001L

typedef struct _MCI_STATUS_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    ULONG   ulReturn;        /* Return field                            */
    ULONG   ulItem;          /* Item field for STATUS item to query     */
    ULONG   ulValue;         /* Status value field (this used to be)    */
                             /*  ulTrack but was changed in Rel 1.1     */
                             /*  to extend the status structure.        */
                             /*  See the programming reference on when  */
                             /*  ulValue is used and how...             */
} MCI_STATUS_PARMS;
typedef MCI_STATUS_PARMS   *PMCI_STATUS_PARMS;


typedef struct _MCI_CDXA_STATUS_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    ULONG   ulReturn;        /* Return field                            */
    ULONG   ulItem;          /* Item field for STATUS item to query     */
    ULONG   ulValue;         /* Status value field (this used to be)    */
                             /*  ulTrack but was changed in Rel 1.1     */
                             /*  to extend the status structure.        */
                             /*  See the programming reference on when  */
                             /*  ulValue is used and how...             */
    ULONG   ulChannel;       /* Channel                                 */
} MCI_CDXA_STATUS_PARMS;
typedef MCI_CDXA_STATUS_PARMS   *PMCI_CDXA_STATUS_PARMS;

/*********************************************************************/
/* flags and parameter structure for the MCI_STEP message            */
/*     $0000$00 are reserved for MCI_STEP flags                    */
/*********************************************************************/
      MCI_STEP_FRAMES                     $00000100L
      MCI_STEP_REVERSE                    $00000200L

typedef struct _MCI_STEP_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    ULONG   ulStep;          /* amount to step in current time format   */
} MCI_STEP_PARMS;
typedef MCI_STEP_PARMS   *PMCI_STEP_PARMS;

/*********************************************************************/
/* flags for the MCI_SYSINFO message                                 */
/*     $XXXXXX00 are reserved for MCI_SYSINFO flags                 */
/*********************************************************************/
      MCI_SYSINFO_QUANTITY                $00000100L
      MCI_SYSINFO_OPEN                    $00000200L
      MCI_SYSINFO_NAME                    $00000400L
      MCI_SYSINFO_INSTALLNAME             $00000800L
      MCI_SYSINFO_ITEM                    $00001000L
      MCI_SYSINFO_INI_LOCK                $00002000L

    /********************************************************/
    /* Extended SYSINFO functions                           */
    /********************************************************/
          MCI_SYSINFO_INSTALL_DRIVER      $00000001L
          MCI_SYSINFO_QUERY_DRIVER        $00000002L
          MCI_SYSINFO_DELETE_DRIVER       $00000004L
          MCI_SYSINFO_SET_PARAMS          $00000008L
          MCI_SYSINFO_QUERY_PARAMS        $00000010L
          MCI_SYSINFO_SET_CONNECTORS      $00000020L
          MCI_SYSINFO_QUERY_CONNECTORS    $00000040L
          MCI_SYSINFO_SET_EXTENSIONS      $00000080L
          MCI_SYSINFO_QUERY_EXTENSIONS    $00000100L
          MCI_SYSINFO_SET_ALIAS           $00000200L
          MCI_SYSINFO_QUERY_NAMES         $00000400L
          MCI_SYSINFO_SET_DEFAULT         $00000800L
          MCI_SYSINFO_QUERY_DEFAULT       $00001000L
          MCI_SYSINFO_SET_TYPES           $00002000L
          MCI_SYSINFO_QUERY_TYPES         $00004000L

    /********************************************************/
    /* Device Flags                                         */
    /********************************************************/
          MCI_SYSINFO_DEV_CONTROLLABLE    $00000001L
          MCI_SYSINFO_DEV_NONCONTROLLABLE $00000002L
          MCI_SYSINFO_DEVICESETTINGS      $00000004L

/*********************************************************************/
/* parameter structures for the MCI_SYSINFO message                  */
/*********************************************************************/
typedef struct _MCI_SYSINFO_PARMS {
    HWND    hwndDummyCallback; /* NOTIFY not allowed for SYSINFO          */
    PSZ     pszReturn;         /* Pointer to return buffer                */
    ULONG   ulRetSize;         /* Return buffer size                      */
    ULONG   ulNumber;          /* Ordinal Number                          */
    USHORT  usDeviceType;      /* MCI device type number                  */
    USHORT  usReserved0;       /* Reserved field                          */
    ULONG   ulItem;            /* Used to indicate the MCI_SYSINFO        */
                               /* extended function to perform            */
    PVOID   pSysInfoParm;
} MCI_SYSINFO_PARMS;
typedef MCI_SYSINFO_PARMS   *PMCI_SYSINFO_PARMS;

typedef struct _MCI_SYSINFO_LOGDEVICE {
    CHAR    szInstallName[MAX_DEVICE_NAME];       /* Device install name            */
    USHORT  usDeviceType;                         /* Device type number             */
    ULONG   ulDeviceFlag;                         /* Flag indicating whether device */
                                                  /*  device is controllable or not */
    CHAR    szVersionNumber[MAX_VERSION_NUMBER];  /* INI file version number        */
    CHAR    szProductInfo[MAX_PRODINFO];          /* Textual product description    */
    CHAR    szMCDDriver[MAX_DEVICE_NAME];         /* MCI Driver dll name            */
    CHAR    szVSDDriver[MAX_DEVICE_NAME];         /* VSD dll name                   */
    CHAR    szPDDName[MAX_PDD_NAME];              /* Device PDD name                */
    CHAR    szMCDTable[MAX_DEVICE_NAME];          /* Device type command table      */
    CHAR    szVSDTable[MAX_DEVICE_NAME];          /* Device specific command table  */
    USHORT  usShareType;                          /* Device sharing mode            */
    CHAR    szResourceName[MAX_DEVICE_NAME];      /* Resource name                  */
    USHORT  usResourceUnits;                      /* Total resource units available */
                                                  /*  for this device               */
    USHORT  usResourceClasses;                    /* Number of resource classes for */
                                                  /*  this device                   */
    USHORT  ausClassArray[MAX_CLASSES];           /* Maximum number of resource     */
                                                  /*  units for each class          */
    USHORT  ausValidClassArray[MAX_CLASSES][MAX_CLASSES]; /* Valid class combinations */
} MCI_SYSINFO_LOGDEVICE;
typedef MCI_SYSINFO_LOGDEVICE  *PMCI_SYSINFO_LOGDEVICE;


typedef struct _MCI_SYSINFO_DEVPARAMS {
    CHAR    szInstallName[MAX_DEVICE_NAME];       /* Device install name            */
    CHAR    szDevParams[MAX_DEV_PARAMS];          /* Device specific parameters     */
} MCI_SYSINFO_DEVPARAMS;
typedef MCI_SYSINFO_DEVPARAMS *PMCI_SYSINFO_DEVPARAMS;

typedef struct _CONNECT {
    USHORT usConnectType;                         /* Connector type                 */
    CHAR   szToInstallName[MAX_DEVICE_NAME];      /* Install name this connector    */
                                                  /*  is connected to               */
    USHORT usToConnectIndex;                      /* Connector index this connector */
                                                  /*  is connected to               */
} CONNECT;
typedef CONNECT *PCONNECT;


typedef struct _MCI_SYSINFO_CONPARAMS {
    CHAR    szInstallName[MAX_DEVICE_NAME];       /* Device install name            */
    USHORT  usNumConnectors;                      /* Number of device connectors    */
    CONNECT ConnectorList[MAX_CONNECTORS];        /* Connector list array           */
} MCI_SYSINFO_CONPARAMS;
typedef MCI_SYSINFO_CONPARAMS *PMCI_SYSINFO_CONPARAMS;

typedef struct _MCI_SYSINFO_EXTENSION {
    CHAR    szInstallName[MAX_DEVICE_NAME];       /* Device install name            */
    USHORT  usNumExtensions;                      /* Number of extensions           */
    CHAR    szExtension[MAX_EXTENSIONS][MAX_EXTENSION_NAME];
                                                  /* Extension name array           */
} MCI_SYSINFO_EXTENSION;
typedef MCI_SYSINFO_EXTENSION *PMCI_SYSINFO_EXTENSION;

typedef struct _MCI_SYSINFO_ALIAS {
    CHAR    szInstallName[MAX_DEVICE_NAME];       /* Device install name  */
    CHAR    szAliasName[MAX_ALIAS_NAME];          /* Alias name           */
} MCI_SYSINFO_ALIAS;
typedef MCI_SYSINFO_ALIAS *PMCI_SYSINFO_ALIAS;

typedef struct _MCI_SYSINFO_DEFAULTDEVICE {
    CHAR    szInstallName[MAX_DEVICE_NAME];       /* Device install name  */
    USHORT  usDeviceType;                         /* Device type number   */
} MCI_SYSINFO_DEFAULTDEVICE;
typedef MCI_SYSINFO_DEFAULTDEVICE *PMCI_SYSINFO_DEFAULTDEVICE;

typedef struct _MCI_SYSINFO_QUERY_NAME {
    CHAR    szInstallName[MAX_DEVICE_NAME];       /* Device install name  */
    CHAR    szLogicalName[MAX_DEVICE_NAME];       /* Logical device name  */
    CHAR    szAliasName[MAX_ALIAS_NAME];          /* Alias name           */
    USHORT  usDeviceType;                         /* Device type number   */
    USHORT  usDeviceOrd;                          /* Device type ordinal  */
} MCI_SYSINFO_QUERY_NAME;
typedef MCI_SYSINFO_QUERY_NAME *PMCI_SYSINFO_QUERY_NAME;

typedef struct _MCI_SYSINFO_TYPES {
    CHAR    szInstallName[MAX_DEVICE_NAME];       /* Device install name  */
    CHAR    szTypes[MAX_TYPEBUFFER+1];            /* EA types             */
} MCI_SYSINFO_TYPES;
typedef MCI_SYSINFO_TYPES *PMCI_SYSINFO_TYPES;


/*********************************************************************/
/* flags for the MCI_UNFREEZE message                                */
/*     $0000$00 are reserved for MCI_UNFREEZE flags                */
/*********************************************************************/
      MCI_OVLY_UNFREEZE_RECT              $00000100L
      MCI_OVLY_UNFREEZE_RECT_OUTSIDE      $00000200L

/*********************************************************************/
/* flags for the MCI_WHERE message                                   */
/*     $000$X00 are reserved for MCI_WHERE flags                   */
/*********************************************************************/
      MCI_VID_WHERE_DESTINATION           $00000100L
      MCI_VID_WHERE_SOURCE                $00000200L
      MCI_VID_WHERE_WINDOW                $00000400L

      MCI_DGV_WHERE_DESTINATION           MCI_VID_WHERE_DESTINATION
      MCI_DGV_WHERE_SOURCE                MCI_VID_WHERE_SOURCE
      MCI_DGV_WHERE_WINDOW                MCI_VID_WHERE_WINDOW
      MCI_DGV_WHERE_ADJUSTED              $00000800L

      MCI_OVLY_WHERE_DESTINATION          MCI_VID_WHERE_DESTINATION
      MCI_OVLY_WHERE_SOURCE               MCI_VID_WHERE_SOURCE
      MCI_OVLY_WHERE_WINDOW               MCI_VID_WHERE_WINDOW

/*********************************************************************/
/* flags and parameter structure for the MCI_WINDOW message          */
/*     $000$X00   are reserved for MCI_WINDOW flags                */
/*********************************************************************/
      MCI_VID_WINDOW_HWND                 $00000100L
      MCI_VID_WINDOW_STATE                $00000200L
      MCI_VID_WINDOW_TEXT                 $00000400L
      MCI_VID_WINDOW_DEFAULT              $00000800L

      MCI_DGV_WINDOW_HWND                 MCI_VID_WINDOW_HWND
      MCI_DGV_WINDOW_STATE                MCI_VID_WINDOW_STATE
      MCI_DGV_WINDOW_TEXT                 MCI_VID_WINDOW_TEXT
      MCI_DGV_WINDOW_DEFAULT              MCI_VID_WINDOW_DEFAULT

      MCI_OVLY_WINDOW_HWND                MCI_VID_WINDOW_HWND
      MCI_OVLY_WINDOW_STATE               MCI_VID_WINDOW_STATE
      MCI_OVLY_WINDOW_TEXT                MCI_VID_WINDOW_TEXT
      MCI_OVLY_WINDOW_DEFAULT             MCI_VID_WINDOW_DEFAULT

typedef  struct _MCI_VID_WINDOW_PARMS {
    HWND    hwndCallback;    /* PM window handle for MCI notify message */
    HWND    hwndDest;        /* Handle to the client window used for    */
                             /* the destination of the video image      */
    USHORT  usCmdShow;       /* Specifies how the window is displayed   */
    USHORT  usReserved1;     /* Reserved                                */
    PSZ     pszText;         /* The text to use as the window caption   */
    PSZ     pszAlias;        /* The window alias for the display window */
} MCI_VID_WINDOW_PARMS;

typedef MCI_VID_WINDOW_PARMS   MCI_DGV_WINDOW_PARMS;
typedef MCI_DGV_WINDOW_PARMS   *PMCI_DGV_WINDOW_PARMS;

typedef MCI_VID_WINDOW_PARMS   MCI_OVLY_WINDOW_PARMS;
typedef MCI_OVLY_WINDOW_PARMS  *PMCI_OVLY_WINDOW_PARMS;


/*********************************************************************/
/* flags and parameter structure for the MCI_TUNER  message          */
/*********************************************************************/
      MCI_DGV_AUDIO_CHANNEL               $00010000L
      MCI_DGV_TV_CHANNEL                  $00020000L
      MCI_DGV_FREQUENCY                   $00040000L
      MCI_DGV_FINETUNE_PLUS               $00080000L
      MCI_DGV_FINETUNE_MINUS              $00100000L
      MCI_DGV_REGION                      $00200000L
      MCI_DGV_AFC_ON                      $00400000L
      MCI_DGV_AFC_OFF                     $00800000L

typedef struct _MCI_DGV_TUNER_PARMS {
    HWND   hwndCallback;     /* PM window handle for MCI notify message    */
    ULONG  ulFrequency;      /* Tuner Frequency                            */
    ULONG  ulReserved0;      /* Reserved 0                                 */
    ULONG  ulTVChannel;      /* TV Channel                                 */
    LONG   lFineTune;        /* Fine tuning adjustments.                   */
    PSZ    pszRegion;        /* TV Channel Region                          */
    ULONG  ulReserved1;      /* Reserved 1                                 */
    ULONG  ulReserved2;      /* Reserved 2                                 */
} MCI_DGV_TUNER_PARMS;
typedef MCI_DGV_TUNER_PARMS   *LPMCI_DGV_TUNER_PARMS;


#pragma pack()
/*********************************************************************/
/*                                                                   */
/*  MCI system value defines                                         */
/*                                                                   */
/*********************************************************************/
      MSV_CLOSEDCAPTION                   $0
      MSV_MASTERVOLUME                    $1
      MSV_HEADPHONES                      $2
      MSV_SPEAKERS                        $3
      MSV_WORKPATH                        $4
      MSV_SYSQOSVALUE                     $5
      MSV_SYSQOSERRORFLAG                 $6

      MSV_MAX                             $7

#endif                       /* INCL_32 */

/*********************************************************************/
/* Playlist defines                                                  */
/*********************************************************************/
      DATA_OPERATION                      0
      BRANCH_OPERATION                    1
      LOOP_OPERATION                      2
      CALL_OPERATION                      3
      RETURN_OPERATION                    4
      EXIT_OPERATION                      5
      NOP_OPERATION                       6
      MESSAGE_OPERATION                   7
      CUEPOINT_OPERATION                  8

/*********************************************************************/
/*                                                                   */
/*  MCI Function prototypes                                          */
/*                                                                   */
/*********************************************************************/

#ifdef INCL_32
ULONG APIENTRY mciSendCommand   (USHORT   usDeviceID,
                                 USHORT   usMessage,
                                 ULONG    ulParam1,
                                 PVOID    pParam2,
                                 USHORT   usUserParm);

ULONG APIENTRY mciMakeGroup     (PUSHORT pusDeviceGroupID,
                                 USHORT  usDeviceCount,
                                 PUSHORT pausDeviceList,
                                 ULONG   ulFlags,
                                 ULONG   ulMMTime);


ULONG APIENTRY mciDeleteGroup   (USHORT   usGroupID);



BOOL APIENTRY mciSetSysValue (USHORT iSysValue, PVOID pValue);

BOOL  APIENTRY mciQuerySysValue (USHORT iSysValue, PVOID pValue);

ULONG  APIENTRY mciGetDeviceID  (PSZ  pszName);

#else                        /* INCL_32 */

      mciSendString mci16SendString
      mciGetErrorString mci16GetErrorString
      mciGetDeviceID mci16GetDeviceID

ULONG APIENTRY  mciSendString   (PSZ     pszCommandBuf,
                                 PSZ     pszReturnString,
                                 USHORT  usReturnLength,
                                 HWND    hwndCallBack,
                                 USHORT  usUserParm );

ULONG APIENTRY mciGetErrorString    (ULONG    usError,
                                     PSZ      pszBuffer,
                                     USHORT   usLength);

ULONG APIENTRY mciGetDeviceID  (PSZ  pszName);


#endif                       /* INCL_32 */


#ifndef _MEERROR_H_
     _MEERROR_H_
#endif

#ifndef NO_ERROR
     NO_ERROR                          0
#endif
*)

CONST
     MCIERR_BASE                      =5000;
     MCIERR_SUCCESS                   =0;
     MCIERR_INVALID_DEVICE_ID         =(MCIERR_BASE + 1);
     MCIERR_NO_MASTER                 =(MCIERR_BASE + 2);
     MCIERR_UNRECOGNIZED_KEYWORD      =(MCIERR_BASE + 3);
     MCIERR_MASTER_CONFLICT           =(MCIERR_BASE + 4);
     MCIERR_UNRECOGNIZED_COMMAND      =(MCIERR_BASE + 5);
     MCIERR_HARDWARE                  =(MCIERR_BASE + 6);
     MCIERR_INVALID_DEVICE_NAME       =(MCIERR_BASE + 7);
     MCIERR_OUT_OF_MEMORY             =(MCIERR_BASE + 8);
     MCIERR_DEVICE_OPEN               =(MCIERR_BASE + 9);
     MCIERR_CANNOT_LOAD_DRIVER        =(MCIERR_BASE + 10);
     MCIERR_MISSING_COMMAND_STRING    =(MCIERR_BASE + 11);
     MCIERR_PARAM_OVERFLOW            =(MCIERR_BASE + 12);
     MCIERR_MISSING_STRING_ARGUMENT   =(MCIERR_BASE + 13);
     MCIERR_BAD_INTEGER               =(MCIERR_BASE + 14);
     MCIERR_PARSER_INTERNAL           =(MCIERR_BASE + 15);
     MCIERR_DRIVER_INTERNAL           =(MCIERR_BASE + 16);
     MCIERR_MISSING_PARAMETER         =(MCIERR_BASE + 17);
     MCIERR_UNSUPPORTED_FUNCTION      =(MCIERR_BASE + 18);
     MCIERR_FILE_NOT_FOUND            =(MCIERR_BASE + 19);
     MCIERR_DEVICE_NOT_READY          =(MCIERR_BASE + 20);
     MCIERR_INTERNAL                  =(MCIERR_BASE + 21);
     MCIERR_DRIVER                    =(MCIERR_BASE + 22);
     MCIERR_CANNOT_USE_ALL            =(MCIERR_BASE + 23);
     MCIERR_MULTIPLE                  =(MCIERR_BASE + 24);
     MCIERR_EXTENSION_NOT_FOUND       =(MCIERR_BASE + 25);
     MCIERR_OUTOFRANGE                =(MCIERR_BASE + 26);
     MCIERR_CANNOT_ADD_ALIAS          =(MCIERR_BASE + 27);
     MCIERR_FLAGS_NOT_COMPATIBLE      =(MCIERR_BASE + 28);
     MCIERR_CANNOT_USE_NOUNLOAD       =(MCIERR_BASE + 29);
     MCIERR_FILE_NOT_SAVED            =(MCIERR_BASE + 30);
     MCIERR_DEVICE_TYPE_REQUIRED      =(MCIERR_BASE + 31);
     MCIERR_DEVICE_LOCKED             =(MCIERR_BASE + 32);
     MCIERR_DUPLICATE_ALIAS           =(MCIERR_BASE + 33);
     MCIERR_INSTANCE_INACTIVE         =(MCIERR_BASE + 34);

     MCIERR_COMMAND_TABLE             =(MCIERR_BASE + 35);
     MCIERR_INI_FILE_LOCKED           =(MCIERR_BASE + 37);

     MCIERR_NO_AUDIO_SUPPORT          =(MCIERR_BASE + 40);
     MCIERR_NOT_IN_PM_SESSION         =(MCIERR_BASE + 41);
     MCIERR_DUPLICATE_KEYWORD         =(MCIERR_BASE + 42);
     MCIERR_COMMAND_STRING_OVERFLOW   =(MCIERR_BASE + 43);
     MCIERR_DRIVER_PROC_NOT_FOUND     =(MCIERR_BASE + 44);
     MCIERR_INVALID_DEVICE_TYPE       =(MCIERR_BASE + 45);
     MCIERR_INVALID_DEVICE_ORDINAL    =(MCIERR_BASE + 46);
     MCIERR_HEADPHONES_NOT_SET        =(MCIERR_BASE + 47);
     MCIERR_SPEAKERS_NOT_SET          =(MCIERR_BASE + 48);
     MCIERR_SOUND_NOT_SET             =(MCIERR_BASE + 49);
     MCIERR_INVALID_BUFFER            =(MCIERR_BASE + 50);
     MCIERR_INVALID_MEDIA_TYPE        =(MCIERR_BASE + 51);
     MCIERR_INVALID_CONNECTOR_INDEX   =(MCIERR_BASE + 52);
     MCIERR_NO_CONNECTION             =(MCIERR_BASE + 53);
     MCIERR_INVALID_FLAG              =(MCIERR_BASE + 54);
     MCIERR_CANNOT_LOAD_DSP_MOD       =(MCIERR_BASE + 55);
     MCIERR_ALREADY_CONNECTED         =(MCIERR_BASE + 56);
     MCIERR_INVALID_CALLBACK_HANDLE   =(MCIERR_BASE + 57);
     MCIERR_DRIVER_NOT_FOUND          =(MCIERR_BASE + 58);
     MCIERR_DUPLICATE_DRIVER          =(MCIERR_BASE + 59);
     MCIERR_INI_FILE                  =(MCIERR_BASE + 60);
     MCIERR_INVALID_GROUP_ID          =(MCIERR_BASE + 61);
     MCIERR_ID_ALREADY_IN_GROUP       =(MCIERR_BASE + 62);
     MCIERR_MEDIA_CHANGED             =(MCIERR_BASE + 63);
     MCIERR_MISSING_FLAG              =(MCIERR_BASE + 64);
     MCIERR_UNSUPPORTED_FLAG          =(MCIERR_BASE + 65);
     MCIERR_DRIVER_NOT_LOADED         =(MCIERR_BASE + 66);
     MCIERR_INVALID_MODE              =(MCIERR_BASE + 67);
     MCIERR_INVALID_ITEM_FLAG         =(MCIERR_BASE + 68);
     MCIERR_INVALID_TIME_FORMAT_FLAG  =(MCIERR_BASE + 69);
     MCIERR_SPEED_FORMAT_FLAG         =(MCIERR_BASE + 70);
     MCIERR_INVALID_AUDIO_FLAG        =(MCIERR_BASE + 71);
     MCIERR_NODEFAULT_DEVICE          =(MCIERR_BASE + 72);
     MCIERR_DUPLICATE_EXTENSION       =(MCIERR_BASE + 73);
     MCIERR_FILE_ATTRIBUTE            =(MCIERR_BASE + 74);
     MCIERR_DUPLICATE_CUEPOINT        =(MCIERR_BASE + 75);
     MCIERR_INVALID_CUEPOINT          =(MCIERR_BASE + 76);
     MCIERR_CUEPOINT_LIMIT_REACHED    =(MCIERR_BASE + 77);
     MCIERR_MISSING_ITEM              =(MCIERR_BASE + 78);
     MCIERR_MISSING_TIME_FORMAT       =(MCIERR_BASE + 79);
     MCIERR_MISSING_SPEED_FORMAT      =(MCIERR_BASE + 80);
     MCIERR_INVALID_CONNECTOR_TYPE    =(MCIERR_BASE + 81);
     MCIERR_TARGET_DEVICE_FULL        =(MCIERR_BASE + 82);
     MCIERR_UNSUPPORTED_CONN_TYPE     =(MCIERR_BASE + 83);
     MCIERR_CANNOT_MODIFY_CONNECTOR   =(MCIERR_BASE + 84);
     MCIERR_RECORD_ABORTED            =(MCIERR_BASE + 85);
     MCIERR_GROUP_COMMAND             =(MCIERR_BASE + 86);
     MCIERR_DEVICE_NOT_FOUND          =(MCIERR_BASE + 87);
     MCIERR_RESOURCE_NOT_AVAILABLE    =(MCIERR_BASE + 88);
     MCIERR_INVALID_IO_PROC           =(MCIERR_BASE + 89);

     MCIERR_WAVE_OUTPUTSINUSE         =(MCIERR_BASE + 90);
     MCIERR_WAVE_SETOUTPUTINUSE       =(MCIERR_BASE + 91);
     MCIERR_WAVE_INPUTSINUSE          =(MCIERR_BASE + 92);
     MCIERR_WAVE_SETINPUTINUSE        =(MCIERR_BASE + 93);
     MCIERR_WAVE_OUTPUTUNSPECIFIED    =(MCIERR_BASE + 94);
     MCIERR_WAVE_INPUTUNSPECIFIED     =(MCIERR_BASE + 95);
     MCIERR_WAVE_OUTPUTSUNSUITABLE    =(MCIERR_BASE + 96);
     MCIERR_WAVE_SETOUTPUTUNSUITABLE  =(MCIERR_BASE + 97);
     MCIERR_WAVE_INPUTSUNSUITABLE     =(MCIERR_BASE + 98);
     MCIERR_WAVE_SETINPUTUNSUITABLE   =(MCIERR_BASE + 99);

     MCIERR_SEQ_DIV_INCOMPATIBLE      =(MCIERR_BASE + 100);
     MCIERR_SEQ_PORT_INUSE            =(MCIERR_BASE + 101);
     MCIERR_SEQ_PORT_NONEXISTENT      =(MCIERR_BASE + 102);
     MCIERR_SEQ_PORT_MAPNODEVICE      =(MCIERR_BASE + 103);
     MCIERR_SEQ_PORT_MISCERROR        =(MCIERR_BASE + 104);
     MCIERR_SEQ_TIMER                 =(MCIERR_BASE + 105);

     MCIERR_VDP_COMMANDCANCELLED      =(MCIERR_BASE + 106);
     MCIERR_VDP_COMMANDFAILURE        =(MCIERR_BASE + 107);
     MCIERR_VDP_NOTSPUNUP             =(MCIERR_BASE + 108);
     MCIERR_VDP_NOCHAPTER             =(MCIERR_BASE + 109);
     MCIERR_VDP_NOSIDE                =(MCIERR_BASE + 110);
     MCIERR_VDP_NOSIZE                =(MCIERR_BASE + 111);
     MCIERR_VDP_INVALID_TIMEFORMAT    =(MCIERR_BASE + 112);

     MCIERR_CLIPBOARD_ERROR           =(MCIERR_BASE + 114);
     MCIERR_CANNOT_CONVERT            =(MCIERR_BASE + 115);
     MCIERR_CANNOT_REDO               =(MCIERR_BASE + 116);
     MCIERR_CANNOT_UNDO               =(MCIERR_BASE + 117);
     MCIERR_CLIPBOARD_EMPTY           =(MCIERR_BASE + 118);

     MCIERR_INVALID_WORKPATH          =(MCIERR_BASE + 119);
     MCIERR_INDETERMINATE_LENGTH      =(MCIERR_BASE + 120);
     MCIERR_DUPLICATE_EA              =(MCIERR_BASE + 121);
     MCIERR_INVALID_CONNECTION        =(MCIERR_BASE + 122);
     MCIERR_CHANNEL_OFF               =(MCIERR_BASE + 123);
     MCIERR_CANNOT_CHANGE_CHANNEL     =(MCIERR_BASE + 124);
     MCIERR_FILE_IO                   =(MCIERR_BASE + 125);
     MCIERR_SYSTEM_FILE               =(MCIERR_BASE + 126);
     MCIERR_DISPLAY_RESOLUTION        =(MCIERR_BASE + 127);
     MCIERR_NO_ASYNC_PLAY_ACTIVE      =(MCIERR_BASE + 128);

     MCIERR_UNSUPP_FORMAT_TAG         =(MCIERR_BASE + 129);
     MCIERR_UNSUPP_SAMPLESPERSEC      =(MCIERR_BASE + 130);
     MCIERR_UNSUPP_BITSPERSAMPLE      =(MCIERR_BASE + 131);
     MCIERR_UNSUPP_CHANNELS           =(MCIERR_BASE + 132);
     MCIERR_UNSUPP_FORMAT_MODE        =(MCIERR_BASE + 133);
     MCIERR_NO_DEVICE_DRIVER          =(MCIERR_BASE + 134);
     MCIERR_CODEC_NOT_SUPPORTED       =(MCIERR_BASE + 135);

     MCIERR_TUNER_NO_HW               =(MCIERR_BASE + 136);
     MCIERR_TUNER_NO_AFC              =(MCIERR_BASE + 137);
     MCIERR_TUNER_AFC_ON              =(MCIERR_BASE + 138);
     MCIERR_TUNER_CHANNEL_SKIPPED     =(MCIERR_BASE + 139);
     MCIERR_TUNER_CHANNEL_TOO_LOW     =(MCIERR_BASE + 140);
     MCIERR_TUNER_CHANNEL_TOO_HIGH    =(MCIERR_BASE + 141);
     MCIERR_AUD_CHANNEL_OUTOFRANGE    =(MCIERR_BASE + 142);
     MCIERR_TUNER_INVALID_REGION      =(MCIERR_BASE + 143);
     MCIERR_SIGNAL_INVALID            =(MCIERR_BASE + 144);
     MCIERR_TUNER_MODE                =(MCIERR_BASE + 145);
     MCIERR_TUNER_REGION_NOT_SET      =(MCIERR_BASE + 146);
     MCIERR_TUNER_CHANNEL_NOT_SET     =(MCIERR_BASE + 147);

     MCIERR_CUSTOM_DRIVER_BASE        =(MCIERR_BASE + 256);

/******************************************/
/* Sync/Stream Manager Error Return codes */
/******************************************/

     MEBASE                           =(MCIERR_BASE + 500);
     ERROR_INVALID_STREAM             =(MEBASE + 1);
     ERROR_INVALID_HID                =(MEBASE + 2);

     ERROR_INVALID_OBJTYPE            =(MEBASE + 4);
     ERROR_INVALID_FLAG               =(MEBASE + 5);
     ERROR_INVALID_EVCB               =(MEBASE + 6);
     ERROR_INVALID_EVENT              =(MEBASE + 7);
     ERROR_INVALID_MMTIME             =(MEBASE + 8);
     ERROR_INVALID_NUMSLAVES          =(MEBASE + 9);
     ERROR_INVALID_REQUEST            =(MEBASE + 10);
     ERROR_INVALID_SPCBKEY            =(MEBASE + 11);
     ERROR_INVALID_HNDLR_NAME         =(MEBASE + 12);
     ERROR_INVALID_PROTOCOL           =(MEBASE + 13);
     ERROR_INVALID_BUFFER_SIZE        =(MEBASE + 14);
     ERROR_INVALID_BUFFER_RETURNED    =(MEBASE + 15);
     ERROR_INVALID_ACB                =(MEBASE + 16);
     ERROR_INVALID_RECORD_RETURNED    =(MEBASE + 17);
     ERROR_INVALID_MESSAGE            =(MEBASE + 18);

     ERROR_STREAM_NOT_OWNER           =(MEBASE + 99);
     ERROR_STREAM_USED                =(MEBASE + 100);
     ERROR_STREAM_CREATION            =(MEBASE + 101);
     ERROR_STREAM_NOTMASTER           =(MEBASE + 102);
     ERROR_STREAM_NOT_STOP            =(MEBASE + 103);
     ERROR_STREAM_OPERATION           =(MEBASE + 104);
     ERROR_STREAM_STOP_PENDING        =(MEBASE + 105);
     ERROR_STREAM_ALREADY_STOP        =(MEBASE + 106);
     ERROR_STREAM_ALREADY_PAUSE       =(MEBASE + 107);
     ERROR_STREAM_NOT_STARTED         =(MEBASE + 108);
     ERROR_STREAM_NOT_ACTIVE          =(MEBASE + 109);
     ERROR_START_STREAM               =(MEBASE + 110);
     ERROR_MASTER_USED                =(MEBASE + 111);
     ERROR_SPCBKEY_MISMATCH           =(MEBASE + 112);
     ERROR_INSUFF_BUFFER              =(MEBASE + 113);
     ERROR_ALLOC_RESOURCES            =(MEBASE + 114);
     ERROR_ACCESS_OBJECT              =(MEBASE + 115);
     ERROR_HNDLR_REGISTERED           =(MEBASE + 116);
     ERROR_DATA_ITEM_NOT_SPECIFIED    =(MEBASE + 117);
     ERROR_INVALID_SEQUENCE           =(MEBASE + 118);
     ERROR_INITIALIZATION             =(MEBASE + 119);
     ERROR_READING_INI                =(MEBASE + 120);
     ERROR_LOADING_HNDLR              =(MEBASE + 121);
     ERROR_HNDLR_NOT_FOUND            =(MEBASE + 122);
     ERROR_SPCB_NOT_FOUND             =(MEBASE + 123);
     ERROR_DEVICE_NOT_FOUND           =(MEBASE + 124);
     ERROR_TOO_MANY_EVENTS            =(MEBASE + 125);
     ERROR_DEVICE_OVERRUN             =(MEBASE + 126);
     ERROR_DEVICE_UNDERRUN            =(MEBASE + 127);
     ERROR_HNDLR_NOT_IN_INI           =(MEBASE + 128);
     ERROR_QUERY_STREAM_TIME          =(MEBASE + 129);
     ERROR_DATA_ITEM_NOT_SEEKABLE     =(MEBASE + 130);
     ERROR_NOT_SEEKABLE_BY_TIME       =(MEBASE + 131);
     ERROR_NOT_SEEKABLE_BY_BYTES      =(MEBASE + 132);
     ERROR_STREAM_NOT_SEEKABLE        =(MEBASE + 133);
     ERROR_PLAYLIST_STACK_OVERFLOW    =(MEBASE + 135);
     ERROR_PLAYLIST_STACK_UNDERFLOW   =(MEBASE + 136);
     ERROR_LOCKING_BUFFER             =(MEBASE + 137);
     ERROR_UNLOCKING_BUFFER           =(MEBASE + 138);
     ERROR_SEEK_PAST_END              =(MEBASE + 139);
     ERROR_SEEK_BACK_NOT_SUPPORTED    =(MEBASE + 140);
     ERROR_INTERNAL_ERROR             =(MEBASE + 141);
     ERROR_INTERNAL_CORRUPT           =(MEBASE + 142);
     ERROR_INSUFF_MEM                 =(MEBASE + 143);
     ERROR_LARGE_SEEK_BY_TIME         =(MEBASE + 144);
     ERROR_STREAM_PREROLLING          =(MEBASE + 145);
     ERROR_INI_FILE                   =(MEBASE + 146);
     ERROR_SEEK_BEFORE_BEGINNING      =(MEBASE + 147);
     ERROR_TOO_MANY_HANDLERS          =(MEBASE + 148);
     ERROR_ALLOC_HEAP                 =(MEBASE + 149);
     ERROR_END_OF_PLAYLIST            =(MEBASE + 150);
     ERROR_TOO_MANY_STREAMS           =(MEBASE + 151);
     ERROR_FILE_FORMAT_INCORRECT      =(MEBASE + 152);
     ERROR_DESTROY_STREAM             =(MEBASE + 153);
     ERROR_INVALID_NUMMASTERS         =(MEBASE + 154);
     ERROR_MASTER_CONFLICT            =(MEBASE + 155);
     ERROR_NO_MASTER                  =(MEBASE + 156);
     ERROR_NO_SYNC                    =(MEBASE + 157);

     ERROR_BUFFER_NOT_AVAILABLE       =(MEBASE + 400);
     ERROR_TOO_MANY_BUFFERS           =(MEBASE + 401);
     ERROR_TOO_MANY_RECORDS           =(MEBASE + 402);


(*
/*----- ERROR_INVALID_PROTOCOL ulErrorStatus defines -----*/
/*----- Refer to SHC_NEGOTIATE_RESULT api.*/
     PROTOCOL_SPCBLENGTH             1
     PROTOCOL_SPCBKEY                2
     PROTOCOL_DATAFLAG               3
     PROTOCOL_NUMRECORDS             4
     PROTOCOL_BLOCKSIZE              5
     PROTOCOL_BUFFERSIZE             6
     PROTOCOL_MINNUMBUFFERS          7
     PROTOCOL_MAXNUMBUFFERS          8
     PROTOCOL_SOURCESTART            9
     PROTOCOL_TARGETSTART            10
     PROTOCOL_BUFFERFLAG             11
     PROTOCOL_HANDLERFLAG            12
     PROTOCOL_SYNCTOLERANCE          13
     PROTOCOL_SYNCINTERVAL           14
     PROTOCOL_INTERNALERROR          -1

/***********************************/
/* MMIO Manager Error Return codes */
/***********************************/

     MMIOERR_BASE                    (MEBASE + 1000)
     MMIOERR_UNBUFFERED              (MMIOERR_BASE + 1L)
     MMIOERR_CANNOTWRITE             (MMIOERR_BASE + 2L)
     MMIOERR_CHUNKNOTFOUND           (MMIOERR_BASE + 3L)

     MMIOERR_INVALID_HANDLE          (MMIOERR_BASE + 4L)
     MMIOERR_INVALID_PARAMETER       (MMIOERR_BASE + 5L)
     MMIOERR_INTERNAL_SYSTEM         (MMIOERR_BASE + 6L)
     MMIOERR_NO_CORE                 (MMIOERR_BASE + 7L)

     MMIOERR_INI_OPEN                (MMIOERR_BASE + 8L)
     MMIOERR_INI_READ                (MMIOERR_BASE + 9L)

     MMIOERR_INVALID_BUFFER_LENGTH   (MMIOERR_BASE + 10L)
     MMIOERR_NO_BUFFER_ALLOCATED     (MMIOERR_BASE + 11L)
     MMIOERR_NO_FLUSH_FOR_MEM_FILE   (MMIOERR_BASE + 12L)
     MMIOERR_NO_FLUSH_NEEDED         (MMIOERR_BASE + 13L)
     MMIOERR_READ_ONLY_FILE          (MMIOERR_BASE + 14L)
     MMIOERR_WRITE_ONLY_FILE         (MMIOERR_BASE + 15L)
     MMIOERR_INSTALL_PROC_FAILED     (MMIOERR_BASE + 16L)
     MMIOERR_READ_FAILED             (MMIOERR_BASE + 17L)
     MMIOERR_WRITE_FAILED            (MMIOERR_BASE + 18L)
     MMIOERR_SEEK_FAILED             (MMIOERR_BASE + 19L)
     MMIOERR_CANNOTEXPAND            (MMIOERR_BASE + 20L)
     MMIOERR_FREE_FAILED             (MMIOERR_BASE + 21L)
     MMIOERR_EOF_SEEN                (MMIOERR_BASE + 22L)
     MMIOERR_INVALID_ACCESS_FLAG     (MMIOERR_BASE + 23L)
     MMIOERR_INVALID_STRUCTURE       (MMIOERR_BASE + 24L)
     MMIOERR_INVALID_SIZE            (MMIOERR_BASE + 25L)
     MMIOERR_INVALID_FILENAME        (MMIOERR_BASE + 26L)

     MMIOERR_CF_DUPLICATE_SEEN       (MMIOERR_BASE + 27L)
     MMIOERR_CF_ENTRY_NO_CORE        (MMIOERR_BASE + 28L)
     MMIOERR_CF_WO_UNSUPPORTED       (MMIOERR_BASE + 29L)
     MMIOERR_CF_ELEMENTS_OPEN        (MMIOERR_BASE + 30L)
     MMIOERR_CF_NON_BND_FILE         (MMIOERR_BASE + 31L)
     MMIOERR_CF_ENTRY_NOT_FOUND      (MMIOERR_BASE + 32L)

     MMIOERR_DELETE_FAILED           (MMIOERR_BASE + 33L)
     MMIOERR_OUTOFMEMORY             (MMIOERR_BASE + 34L)

     MMIOERR_INVALID_DLLNAME         (MMIOERR_BASE + 35L)
     MMIOERR_INVALID_PROCEDURENAME   (MMIOERR_BASE + 36L)
     MMIOERR_MATCH_NOT_FOUND         (MMIOERR_BASE + 37L)

     MMIOERR_SEEK_BEFORE_BEGINNING   (MMIOERR_BASE + 38L)
     MMIOERR_INVALID_FILE            (MMIOERR_BASE + 39L)
     MMIOERR_QOSUNAVAILABLE          (MMIOERR_BASE + 40L)
     MMIOERR_MEDIA_NOT_FOUND         (MMIOERR_BASE + 41L)

     MMIOERR_ERROR_IN_FRAME_DATA     (MMIOERR_BASE + 42L)
     MMIOERR_INVALID_DIM_ALIGN       (MMIOERR_BASE + 43L)
     MMIOERR_CODEC_NOT_SUPPORTED     (MMIOERR_BASE + 44L)

      MMIOERR_UNSUPPORTED_FUNCTION    (MMIOERR_BASE + 45L)
      MMIOERR_CLIPBRD_ERROR           (MMIOERR_BASE + 46L)
      MMIOERR_CLIPBRD_ACTIVE          (MMIOERR_BASE + 47L)
      MMIOERR_CLIPBRD_EMPTY           (MMIOERR_BASE + 48L)
      MMIOERR_NEED_NEW_FILENAME       (MMIOERR_BASE + 49L)
      MMIOERR_INVALID_TRACK_OPERATION (MMIOERR_BASE + 50L)
      MMIOERR_INCOMPATIBLE_DATA       (MMIOERR_BASE + 51L)
      MMIOERR_ACCESS_DENIED           (MMIOERR_BASE + 52L)
      MMIOERR_MISSING_FLAG            (MMIOERR_BASE + 53L)
      MMIOERR_INVALID_ITEM_FLAG       (MMIOERR_BASE + 54L)

/***********************************/
/* User defined Error Return codes */
/***********************************/

     USERERR_BASE                    (MMIOERR_BASE + 1000)  *)

/***********************************/
/* Dart                            */
/***********************************/

{DART constants}
Const MCI_MIXSETUP_INIT           = $00010000;
      MCI_MIXSETUP_DEINIT         = $00020000;
      MCI_MIXSETUP_QUERYMODE      = $00040000;
      MCI_ALLOCATE_MEMORY         = $00040000;
      MCI_DEALLOCATE_MEMORY       = $00080000;
      MIX_BUFFER_EOS              = $00000001;

      MCI_BUFFER      = 62;
      MCI_MIXSETUP    = 63;

{Constants for DART Callbacks}
      MIX_STREAM_ERROR    = $00000080;
      MIX_READ_COMPLETE   = $00000001;
      MIX_WRITE_COMPLETE  = $00000002;

{DART structures}
type
  PMCI_MIX_BUFFER = ^MCI_MIX_BUFFER;
  MCI_MIX_BUFFER = record
    ulStructLength : uLong;     { Structure length              }
    pBuffer        : pointer;   { Pointer to a buffer           }
    ulBufferLength : uLong;     { Length of the buffer          }
    ulFlags        : uLong;     { Flags                         }
    ulUserParm     : uLong;     { User parameter                }
    ulTime         : uLong;     { Device time in ms             }
    ulReserved1    : uLong;
    ulReserved2    : uLong;
  end;

{DART Callbacks}
type
  PMIXERPROC   = function(ulHandle : ulong; pBuffer : PMCI_MIX_BUFFER; ulFlags : ulong) : long; APIENTRY;
  PMIXEREVENT  = function(ulStatus : ulong; pBuffer : PMCI_MIX_BUFFER; ulFlags : ulong) : long; APIENTRY;

  MCI_MIXSETUP_PARMS = record
    hwndCallback    : hwnd;       { Window handle                 }
    ulBitsPerSample : Long;      { Bits per sample               }
    ulFormatTag     : ulong;      { Format tag                    }
    ulSamplesPerSec : ulong;      { Sampling rate                 }
    ulChannels      : ulong;      { Number of channels            }
    ulFormatMode    : ulong;      { Play or record                }
    ulDeviceType    : ulong;      { Device type                   }
    ulMixHandle     : ulong;      { Mixer handle                  }
    pmixWrite       : pmixerproc; { Entry point                   }
    pmixRead        : pmixerproc; { Entry point                   }
    pmixEvent       : pmixerevent;{ Entry point                   }
    pExtendedInfo   : pvoid;      { Extended information          }
    ulBufferSize    : ulong;      { Recommended buffer size       }
    ulNumBuffers    : ulong;      { Recommended number of buffers }
  end;

  PMCI_MIXSETUP_PARMS = ^MCI_MIXSETUP_PARMS;

  MCI_BUFFER_PARMS = record
    hwndCallback   : hwnd;
    ulStructLength : ulong;
    ulNumBuffers   : ulong;
    ulBufferSize   : ulong;
    ulMinToStart   : ulong;
    ulSrcStart     : ulong;
    ulTgtStart     : ulong;
    pBufList       : pvoid;
  end;

IMPORTS
      FUNCTION mmioSet(ahmmio:HMMIO;VAR pUserExtendmminfo:MMEXTENDINFO;
                       ulFlags:ULONG):ULONG;
           APIENTRY;  'MMIO' index 101;
      FUNCTION mmioQueryHeaderLength( ahmmio:HMMIO;
                                      VAR plHeaderLength:LONG;
                                      dwReserved:LONGWORD;
                                      dwFlags:LONGWORD ):LONGWORD;
           APIENTRY;  'MMIO' index 76;
      FUNCTION mmioGetHeader( ahmmio:HMMIO;
                              VAR pHeader;
                              lHeaderLength:LONG;
                              VAR plBytesRead:LONG;
                              dwReserved:ULONG;
                              dwFlags:ULONG ):LONGWORD;
           APIENTRY;  'MMIO' index 77;
      FUNCTION mmioOpen( pszFileName:CSTRING;
                         VAR apmmioinfo:MMIOINFO;
                         dwOpenFlags:LONGWORD ):HMMIO;
           APIENTRY;  'MMIO' index 27; 
{      FUNCTION mmioRead( mmIO: hmmio; pchBuffer: cString; cBytes: Longword ): Longword; }
      FUNCTION mmioRead( mmIO: hmmio; pchBuffer: pChar; cBytes: Long ): Long;
           APIENTRY;  'MMIO' index 28;
      FUNCTION mmioWrite( mmIO: hmmio; pchBuffer: pChar; cBytes: Long ): Long;
           APIENTRY;  'MMIO' index 29;
      FUNCTION mmioSeek( mmIO: hmmio; lOffset, lOrigin: Long ): Long;
           APIENTRY;  'MMIO' index 30;
      FUNCTION mmioFlush( mmIO: hmmio; usFlags: uShort ): uShort;
           APIENTRY;  'MMIO' index 31;
      FUNCTION mmioClose( ahmmio:HMMIO; wFlags:LONGWORD ):WORD;
           APIENTRY;  'MMIO' index 32;
      FUNCTION mmioAscend( mmIO: hmmio; pckinfo: pmmCkInfo; usFlags: uShort ): uShort;
           APIENTRY;  'MMIO' index 36;
      FUNCTION mmioDescend(mmIO: hmmio; pckinfo, pckinfoParent:
                           pMMCkInfo; usFlags: uShort ): uShort;
           APIENTRY;  'MMIO' index 37;

      FUNCTION mciSendCommand(usDeviceID: uShort; usMessage: uShort;
                              ulParam1: uLong;
                              var Param2; usUserParm: uShort): Ulong;
           APIENTRY; 'MDM' index 1;
      FUNCTION mciSendString(s:CSTRING;VAR ret:CSTRING;retlen:LONGWORD;
                             ahwnd:HWND;userParam:LONGWORD):LONGWORD;
           APIENTRY; 'MDM' index 2;
      FUNCTION mciGetErrorString(ulError:LONGWORD;
                                VAR pszBuffer:CSTRING;
                                usLength:LONGWORD):LONGWORD;
           APIENTRY; 'MDM' index 3;
      FUNCTION mciGetDeviceId(AliasName:CSTRING):LONGWORD;
           APIENTRY; 'MDM' index 16;

END;

/***********************************/
/* CAP.DLL                         */
/***********************************/

// Informationen: Multimedia Application Programminng Guide, mmapg.inf
type pCC_SET_PARMS = ^tCC_SET_PARMS;
     tCC_SET_PARMS = record
       ulRows           : LongWord;
       ulBackgroundColor: LongWord;
       ulTextColor      : LongWord;
       ulXposition      : LongWord;
       ulYposition      : LongWord;
       ulColumns        : LongWord;
     End;

     pCC_START_PARMS = ^tCC_START_PARMS;
     tCC_START_PARMS = Record
       hwndOwner   : HWND;
       pszDeviceID : PSZ;
       CaptionFile : PSZ;
     End;

// Structure for ccSendCommand
     pCC_STATUS_PARMS = ^tCC_STATUS_PARMS;
     tCC_STATUS_PARMS = Record
       ulItem  : LongWord;
       ulReturn: LongWord;
     End;

//  Constants for ccSendCommand
Const CC_START = 1;
      CC_STOP  = 2;
      CC_SET   = 3;
      CC_STATUS= 4;


// Constants for tCC_STATUS_PARMS
Const CC_STATUS_TEXT_COLUMNS    = 1;    // Columns of text in the caption window.
      CC_STATUS_TEXT_ROWS       = 2;    // Rowws of text in the caption window.
      CC_STATUS_TEXT_COLOR      = 3;    // Color index of the text color.
      CC_STATUS_BACKGROUND_COLOR= 4;    // Color index of the background color of the text window.
      CC_STATUS_X_POSITION      = 5;    // X-coordinate of the captioning window relative to the parent window.
      CC_STATUS_Y_POSITION      = 6;    // Y-coordinate of the captioning window relative to the parent window.

imports
      function  ccInitialize(hwndParent : HWND) : LongWord;
                  APIENTRY;  'CAP' index 1;
      function  ccSendCommand(usMsg : uShort; mp1, mp2 : mParam) : LongWord;
                  APIENTRY;  'CAP' index 2;
      procedure ccTerminate(hwndCaption : HWND);
                  APIENTRY;  'CAP' index 3;
end;


IMPLEMENTATION

function mmioFourCC( ch0, ch1, ch2, ch3: Char ): uLong;

begin
  Result := ord(ch0) or (ord(ch1) shl 8) or
           (ord(ch2) shl 16) or (ord(ch3) shl 24);
end;


END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  01-Jan-09  WD         Die Funktionen von der CAP.DLL eingebunden
}




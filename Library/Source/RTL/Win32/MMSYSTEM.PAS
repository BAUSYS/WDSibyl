
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library for Win32                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT MMSystem;

INTERFACE

USES WinBase,WinNt,WinDef;

CONST
     MAXPNAMELEN      =32;
     MAXERRORLENGTH   =128;

     MM_MICROSOFT     =1;

     MM_MIDI_MAPPER   =1;
     MM_WAVE_MAPPER   =2;

     MM_SNDBLST_MIDIOUT  =3;
     MM_SNDBLST_MIDIIN   =4;
     MM_SNDBLST_SYNTH    =5;
     MM_SNDBLST_WAVEOUT  =6;
     MM_SNDBLST_WAVEIN   =7;
     MM_ADLIB            =9;
     MM_MPU401_MIDIOUT   =10;
     MM_MPU401_MIDIIN    =11;
     MM_PC_JOYSTICK      =12;

TYPE
    MMVERSION=LONGWORD;
    MMRESULT=LONGWORD;
    LPUINT=^LONGWORD;

TYPE
    PMMTIME=^MMTIME;
    MMTIME=RECORD
                 wType:LONGWORD;
                 CASE Integer OF
                   1:(ms:LONGWORD);
                   2:(sample:LONGWORD);
                   3:(cb:LONGWORD);
                   4:(ticks:LONGWORD);
                   5:(smpte:RECORD
                                  hour:BYTE;
                                  min:BYTE;
                                  sec:BYTE;
                                  frame:BYTE;
                                  fps:BYTE;
                                  dummy:BYTE;
                                  pad:ARRAY[0..1] OF BYTE;
                            END);
                   6:(midi:RECORD
                                 songptrpos:LONGWORD;
                           END);
    END;

CONST
     TIME_MS         =$0001;
     TIME_SAMPLES    =$0002;
     TIME_BYTES      =$0004;
     TIME_SMPTE      =$0008;
     TIME_MIDI       =$0010;
     TIME_TICKS      =$0020;

CONST
     MM_JOY1MOVE         =$3A0;
     MM_JOY2MOVE         =$3A1;
     MM_JOY1ZMOVE        =$3A2;
     MM_JOY2ZMOVE        =$3A3;
     MM_JOY1BUTTONDOWN   =$3B5;
     MM_JOY2BUTTONDOWN   =$3B6;
     MM_JOY1BUTTONUP     =$3B7;
     MM_JOY2BUTTONUP     =$3B8;

     MM_MCINOTIFY        =$3B9;

     MM_WOM_OPEN         =$3BB;
     MM_WOM_CLOSE        =$3BC;
     MM_WOM_DONE         =$3BD;

     MM_WIM_OPEN         =$3BE;
     MM_WIM_CLOSE        =$3BF;
     MM_WIM_DATA         =$3C0;

     MM_MIM_OPEN         =$3C1;
     MM_MIM_CLOSE        =$3C2;
     MM_MIM_DATA         =$3C3;
     MM_MIM_LONGDATA     =$3C4;
     MM_MIM_ERROR        =$3C5;
     MM_MIM_LONGERROR    =$3C6;

     MM_MOM_OPEN         =$3C7;
     MM_MOM_CLOSE        =$3C8;
     MM_MOM_DONE         =$3C9;
     MM_MCISYSTEM_STRING =$3CA;

     MM_MIXM_LINE_CHANGE =$3D0;
     MM_MIXM_CONTROL_CHANGE  =$3D1;

CONST
     MMSYSERR_BASE          =0;
     WAVERR_BASE            =32;
     MIDIERR_BASE           =64;
     TIMERR_BASE            =96;
     JOYERR_BASE            =160;
     MCIERR_BASE            =256;

     MCI_STRING_OFFSET      =512;

     MIXERR_BASE            =1024;

     MCI_VD_OFFSET          =1024;
     MCI_CD_OFFSET          =1088;
     MCI_WAVE_OFFSET        =1152;
     MCI_SEQ_OFFSET         =1216;

     MMSYSERR_NOERROR      =0;
     MMSYSERR_ERROR        =(MMSYSERR_BASE + 1);
     MMSYSERR_BADDEVICEID  =(MMSYSERR_BASE + 2);
     MMSYSERR_NOTENABLED   =(MMSYSERR_BASE + 3);
     MMSYSERR_ALLOCATED    =(MMSYSERR_BASE + 4);
     MMSYSERR_INVALHANDLE  =(MMSYSERR_BASE + 5);
     MMSYSERR_NODRIVER     =(MMSYSERR_BASE + 6);
     MMSYSERR_NOMEM        =(MMSYSERR_BASE + 7);
     MMSYSERR_NOTSUPPORTED =(MMSYSERR_BASE + 8);
     MMSYSERR_BADERRNUM    =(MMSYSERR_BASE + 9);
     MMSYSERR_INVALFLAG    =(MMSYSERR_BASE + 10);
     MMSYSERR_INVALPARAM   =(MMSYSERR_BASE + 11);
     MMSYSERR_HANDLEBUSY   =(MMSYSERR_BASE + 12);
     MMSYSERR_INVALIDALIAS =(MMSYSERR_BASE + 13);
     MMSYSERR_LASTERROR    =(MMSYSERR_BASE + 13);

TYPE HDRVR=HANDLE;

CONST
     DRV_LOAD            =$0001;
     DRV_ENABLE          =$0002;
     DRV_OPEN            =$0003;
     DRV_CLOSE           =$0004;
     DRV_DISABLE         =$0005;
     DRV_FREE            =$0006;
     DRV_CONFIGURE       =$0007;
     DRV_QUERYCONFIGURE  =$0008;
     DRV_INSTALL         =$0009;
     DRV_REMOVE          =$000A;
     DRV_EXITSESSION     =$000B;
     DRV_POWER           =$000F;
     DRV_RESERVED        =$0800;
     DRV_USER            =$4000;

TYPE
    PDRVCONFIGINFO=^DRVCONFIGINFO;
    DRVCONFIGINFO=RECORD
                        dwDCISize:LONGWORD;
                        lpszDCISectionName:PChar;
                        lpszDCIAliasName:PChar;
    END;

CONST
     DRVCNF_CANCEL       =$0000;
     DRVCNF_OK           =$0001;
     DRVCNF_RESTART      =$0002;

     DRV_CANCEL          =DRVCNF_CANCEL;
     DRV_OK              =DRVCNF_OK;
     DRV_RESTART         =DRVCNF_RESTART;

     DRV_MCI_FIRST       =DRV_RESERVED;
     DRV_MCI_LAST        =DRV_RESERVED + $FFF;

CONST
     CALLBACK_TYPEMASK   =$00070000;
     CALLBACK_NULL       =$00000000;
     CALLBACK_WINDOW     =$00010000;
     CALLBACK_TASK       =$00020000;
     CALLBACK_THREAD     =$00020000;
     CALLBACK_FUNCTION   =$00030000;

TYPE
    PDRVCALLBACK=^DRVCALLBACK;
    DRVCALLBACK=PROCEDURE(ahdrvr:HDRVR;uMsg:LONGWORD;dwUser:LONGWORD;
                           dw1,dw2:LONGWORD);APIENTRY;

CONST
     SND_ALIAS      =$00010000;
     SND_FILENAME   =$00020000;
     SND_RESOURCE   =$00040004;

     SND_SYNC       =$00000000;
     SND_ASYNC      =$00000001;
     SND_NODEFAULT  =$00000002;
     SND_MEMORY     =$00000004;
     SND_LOOP       =$00000008;
     SND_NOSTOP     =$00000010;

     SND_NOWAIT     =$00002000;
     SND_VALIDFLAGS =$0017201F;
     SND_RESERVED   =$FF000000;
     SND_TYPE_MASK  =$00170007;
     SND_ALIAS_ID   =$00110000;
     SND_ALIAS_START=0;

(*
/****************************************************************************

                        Waveform audio support

****************************************************************************/

/* waveform audio error return values */
     WAVERR_BADFORMAT      (WAVERR_BASE + 0)    // unsupported wave format
     WAVERR_STILLPLAYING   (WAVERR_BASE + 1)    // still something playing
     WAVERR_UNPREPARED     (WAVERR_BASE + 2)    // header not prepared
     WAVERR_SYNC           (WAVERR_BASE + 3)    // device is synchronous
     WAVERR_LASTERROR      (WAVERR_BASE + 3)    // last error in range

/* waveform audio data types */
typedef HANDLE          HWAVE;
typedef HWAVE           HWAVEIN;
typedef HWAVE           HWAVEOUT;

typedef HWAVEIN     *LPHWAVEIN;
typedef HWAVEOUT     *LPHWAVEOUT;

typedef DRVCALLBACK     WAVECALLBACK;
typedef WAVECALLBACK     *LPWAVECALLBACK;

/* wave callback messages */
     WOM_OPEN        MM_WOM_OPEN
     WOM_CLOSE       MM_WOM_CLOSE
     WOM_DONE        MM_WOM_DONE
     WIM_OPEN        MM_WIM_OPEN
     WIM_CLOSE       MM_WIM_CLOSE
     WIM_DATA        MM_WIM_DATA

/* device ID for wave device mapper */
     WAVE_MAPPER     ((DWORD)(-1))

/* flags for dwFlags parameter in waveOutOpen() and waveInOpen() */
      WAVE_FORMAT_QUERY     $00000001
      WAVE_ALLOWSYNC        $00000002

/* wave data block header */
typedef struct wavehdr_tag {
    LPBYTE      lpData;               // pointer to locked data buffer
    DWORD       dwBufferLength;       // length of data buffer
    DWORD       dwBytesRecorded;      // used for input only
    DWORD       dwUser;               // for client's use
    DWORD       dwFlags;              // assorted flags (see defines)
    DWORD       dwLoops;              // loop control counter
    struct wavehdr_tag     *lpNext;   // reserved for driver
    DWORD                 reserved;   // reserved for driver
} WAVEHDR;
typedef WAVEHDR       *PWAVEHDR;
typedef WAVEHDR      *NPWAVEHDR;
typedef WAVEHDR      *LPWAVEHDR;

/* flags for dwFlags field of WAVEHDR */
     WHDR_DONE       $00000001  // done bit
     WHDR_PREPARED   $00000002  // set if this header has been prepared
     WHDR_BEGINLOOP  $00000004  // loop start block
     WHDR_ENDLOOP    $00000008  // loop end block
     WHDR_INQUEUE    $00000010  // reserved for driver

/* waveform output device capabilities structure */
typedef struct tagWAVEOUTCAPSA {
    WORD    wMid;                   // manufacturer ID
    WORD    wPid;                   // product ID
    MMVERSION vDriverVersion;       // version of the driver
    CHAR    szPname[MAXPNAMELEN];   // product name (NULL terminated string)
    DWORD   dwFormats;              // formats supported
    WORD    wChannels;              // number of sources supported
    WORD    wReserved1;             // packing
    DWORD   dwSupport;              // functionality supported by driver
} WAVEOUTCAPSA;
/* waveform output device capabilities structure */
typedef struct tagWAVEOUTCAPSW {
    WORD    wMid;                   // manufacturer ID
    WORD    wPid;                   // product ID
    MMVERSION vDriverVersion;       // version of the driver
    WCHAR   szPname[MAXPNAMELEN];   // product name (NULL terminated string)
    DWORD   dwFormats;              // formats supported
    WORD    wChannels;              // number of sources supported
    WORD    wReserved1;             // packing
    DWORD   dwSupport;              // functionality supported by driver
} WAVEOUTCAPSW;
#ifdef UNICODE
typedef WAVEOUTCAPSW WAVEOUTCAPS;
#else
typedef WAVEOUTCAPSA WAVEOUTCAPS;
#endif // UNICODE
typedef WAVEOUTCAPSA      *PWAVEOUTCAPSA;
typedef WAVEOUTCAPSW      *PWAVEOUTCAPSW;
#ifdef UNICODE
typedef PWAVEOUTCAPSW PWAVEOUTCAPS;
#else
typedef PWAVEOUTCAPSA PWAVEOUTCAPS;
#endif // UNICODE
typedef WAVEOUTCAPSA      *NPWAVEOUTCAPSA;
typedef WAVEOUTCAPSW      *NPWAVEOUTCAPSW;
#ifdef UNICODE
typedef NPWAVEOUTCAPSW NPWAVEOUTCAPS;
#else
typedef NPWAVEOUTCAPSA NPWAVEOUTCAPS;
#endif // UNICODE
typedef WAVEOUTCAPSA      *LPWAVEOUTCAPSA;
typedef WAVEOUTCAPSW      *LPWAVEOUTCAPSW;
#ifdef UNICODE
typedef LPWAVEOUTCAPSW LPWAVEOUTCAPS;
#else
typedef LPWAVEOUTCAPSA LPWAVEOUTCAPS;
#endif // UNICODE

/* flags for dwSupport field of WAVEOUTCAPS */
     WAVECAPS_PITCH        $00000001  // supports pitch control
     WAVECAPS_PLAYBACKRATE $00000002  // supports playback rate control
     WAVECAPS_VOLUME       $00000004  // supports volume control
     WAVECAPS_LRVOLUME     $00000008  // separate left-right volume control
     WAVECAPS_SYNC         $00000010

/* waveform input device capabilities structure */
typedef struct tagWAVEINCAPSA {
    WORD    wMid;                    // manufacturer ID
    WORD    wPid;                    // product ID
    MMVERSION vDriverVersion;        // version of the driver
    CHAR    szPname[MAXPNAMELEN];    // product name (NULL terminated string)
    DWORD   dwFormats;               // formats supported
    WORD    wChannels;               // number of channels supported
    WORD    wReserved1;              // structure packing
} WAVEINCAPSA;
/* waveform input device capabilities structure */
typedef struct tagWAVEINCAPSW {
    WORD    wMid;                    // manufacturer ID
    WORD    wPid;                    // product ID
    MMVERSION vDriverVersion;        // version of the driver
    WCHAR   szPname[MAXPNAMELEN];    // product name (NULL terminated string)
    DWORD   dwFormats;               // formats supported
    WORD    wChannels;               // number of channels supported
    WORD    wReserved1;              // structure packing
} WAVEINCAPSW;
#ifdef UNICODE
typedef WAVEINCAPSW WAVEINCAPS;
#else
typedef WAVEINCAPSA WAVEINCAPS;
#endif // UNICODE
typedef WAVEINCAPSA     *PWAVEINCAPSA;
typedef WAVEINCAPSW     *PWAVEINCAPSW;
#ifdef UNICODE
typedef PWAVEINCAPSW PWAVEINCAPS;
#else
typedef PWAVEINCAPSA PWAVEINCAPS;
#endif // UNICODE
typedef WAVEINCAPSA     *LPWAVEINCAPSA;
typedef WAVEINCAPSW     *LPWAVEINCAPSW;
#ifdef UNICODE
typedef LPWAVEINCAPSW LPWAVEINCAPS;
#else
typedef LPWAVEINCAPSA LPWAVEINCAPS;
#endif // UNICODE

/* defines for dwFormat field of WAVEINCAPS and WAVEOUTCAPS */
     WAVE_INVALIDFORMAT     $00000000       // invalid format
     WAVE_FORMAT_1M08       $00000001       // 11.025 kHz, Mono,   8-bit
     WAVE_FORMAT_1S08       $00000002       // 11.025 kHz, Stereo, 8-bit
     WAVE_FORMAT_1M16       $00000004       // 11.025 kHz, Mono,   16-bit
     WAVE_FORMAT_1S16       $00000008       // 11.025 kHz, Stereo, 16-bit
     WAVE_FORMAT_2M08       $00000010       // 22.05  kHz, Mono,   8-bit
     WAVE_FORMAT_2S08       $00000020       // 22.05  kHz, Stereo, 8-bit
     WAVE_FORMAT_2M16       $00000040       // 22.05  kHz, Mono,   16-bit
     WAVE_FORMAT_2S16       $00000080       // 22.05  kHz, Stereo, 16-bit
     WAVE_FORMAT_4M08       $00000100       // 44.1   kHz, Mono,   8-bit
     WAVE_FORMAT_4S08       $00000200       // 44.1   kHz, Stereo, 8-bit
     WAVE_FORMAT_4M16       $00000400       // 44.1   kHz, Mono,   16-bit
     WAVE_FORMAT_4S16       $00000800       // 44.1   kHz, Stereo, 16-bit

/* general waveform format (information common to all formats) */
/* as read from a file.  See Multimedia file formats in Programmer Reference */
typedef struct {
    WORD    wFormatTag;        // format type
    WORD    nChannels;         // number of channels (i.e. mono, stereo, etc.)
    DWORD   nSamplesPerSec;    // sample rate
    DWORD   nAvgBytesPerSec;   // for buffer estimation
    WORD    nBlockAlign;       // block size of data
} WAVEFORMAT;
typedef WAVEFORMAT       *PWAVEFORMAT;
typedef WAVEFORMAT      *NPWAVEFORMAT;
typedef WAVEFORMAT      *LPWAVEFORMAT;
typedef CONST WAVEFORMAT  *LPCWAVEFORMAT;
/* NOTE:  The fields in the structure above are copied into */
/* the MCI_WAVE_SET_PARMS structure during execution */

/* flags for wFormatTag field of WAVEFORMAT */
     WAVE_FORMAT_PCM     1  // Needed in resource files so outside #ifndef RC_INVOKED #endif

#ifndef RC_INVOKED


/* specific waveform format for PCM data */
typedef struct tagPCMWAVEFORMAT {
    WAVEFORMAT  wf;
    WORD        wBitsPerSample;        // corresponds to MCI_WAVE_SET_.... structure
} PCMWAVEFORMAT;
typedef PCMWAVEFORMAT       *PPCMWAVEFORMAT;
typedef PCMWAVEFORMAT      *NPPCMWAVEFORMAT;
typedef PCMWAVEFORMAT      *LPPCMWAVEFORMAT;

#ifndef _WAVEFORMATEX_
     _WAVEFORMATEX_

/*
 *  extended waveform format structure used for all non-PCM formats. this
 *  structure is common to all non-PCM formats.
 */
typedef struct tWAVEFORMATEX
{
    WORD        wFormatTag;         // format type
    WORD        nChannels;          // number of channels (i.e. mono, stereo...)
    DWORD       nSamplesPerSec;     // sample rate
    DWORD       nAvgBytesPerSec;    // for buffer estimation
    WORD        nBlockAlign;        // block size of data
    WORD        wBitsPerSample;     // number of bits per sample of mono data
    WORD        cbSize;             // the count in bytes of the size of
                                    // extra information (after cbSize)
} WAVEFORMATEX, *PWAVEFORMATEX,      *NPWAVEFORMATEX,     *LPWAVEFORMATEX;
typedef CONST WAVEFORMATEX  *LPCWAVEFORMATEX;

#endif // _WAVEFORMATEX_

/* waveform audio function prototypes */
UINT APIENTRY waveOutGetNumDevs(VOID);
MMRESULT APIENTRY waveOutGetDevCapsA(UINT uDeviceID, LPWAVEOUTCAPSA lpCaps,
    UINT cbCaps);
MMRESULT APIENTRY waveOutGetDevCapsW(UINT uDeviceID, LPWAVEOUTCAPSW lpCaps,
    UINT cbCaps);
#ifdef UNICODE
     waveOutGetDevCaps  waveOutGetDevCapsW
#else
     waveOutGetDevCaps  waveOutGetDevCapsA
#endif // !UNICODE

MMRESULT APIENTRY waveOutGetVolume(UINT uDeviceID, LPDWORD lpdwVolume);
MMRESULT APIENTRY waveOutSetVolume(UINT uDeviceID, DWORD dwVolume);

MMRESULT APIENTRY waveOutGetErrorTextA(MMRESULT err, LPSTR lpText, UINT cchText);
MMRESULT APIENTRY waveOutGetErrorTextW(MMRESULT err, LPWSTR lpText, UINT cchText);
#ifdef UNICODE
     waveOutGetErrorText  waveOutGetErrorTextW
#else
     waveOutGetErrorText  waveOutGetErrorTextA
#endif // !UNICODE

MMRESULT APIENTRY waveOutOpen(LPHWAVEOUT lphwo, UINT uDeviceID,
    LPCWAVEFORMAT lpFormat, DWORD dwCallback, DWORD dwInstance, DWORD dwFlags);

MMRESULT APIENTRY waveOutClose(HWAVEOUT hwo);
MMRESULT APIENTRY waveOutPrepareHeader(HWAVEOUT hwo, LPWAVEHDR pwh, UINT cbwh);
MMRESULT APIENTRY waveOutUnprepareHeader(HWAVEOUT hwo, LPWAVEHDR pwh, UINT cbwh);
MMRESULT APIENTRY waveOutWrite(HWAVEOUT hwo, LPWAVEHDR pwh, UINT cbwh);
MMRESULT APIENTRY waveOutPause(HWAVEOUT hwo);
MMRESULT APIENTRY waveOutRestart(HWAVEOUT hwo);
MMRESULT APIENTRY waveOutReset(HWAVEOUT hwo);
MMRESULT APIENTRY waveOutBreakLoop(HWAVEOUT hwo);
MMRESULT APIENTRY waveOutGetPosition(HWAVEOUT hwo, LPMMTIME lpmmt, UINT cbmmt);
MMRESULT APIENTRY waveOutGetPitch(HWAVEOUT hwo, LPDWORD pdwPitch);
MMRESULT APIENTRY waveOutSetPitch(HWAVEOUT hwo, DWORD dwPitch);
MMRESULT APIENTRY waveOutGetPlaybackRate(HWAVEOUT hwo, LPDWORD lpdwRate);
MMRESULT APIENTRY waveOutSetPlaybackRate(HWAVEOUT hwo, DWORD dwRate);

MMRESULT APIENTRY waveOutGetID(HWAVEOUT hwo, LPUINT lpuDeviceID);

MMRESULT APIENTRY waveOutMessage(HWAVEOUT hwo, UINT uMsg, DWORD dw1, DWORD dw2);

UINT APIENTRY waveInGetNumDevs(VOID);

MMRESULT APIENTRY waveInGetDevCapsA(UINT uDeviceID, LPWAVEINCAPSA lpCaps,
    UINT cbCaps);
MMRESULT APIENTRY waveInGetDevCapsW(UINT uDeviceID, LPWAVEINCAPSW lpCaps,
    UINT cbCaps);
#ifdef UNICODE
     waveInGetDevCaps  waveInGetDevCapsW
#else
     waveInGetDevCaps  waveInGetDevCapsA
#endif // !UNICODE

MMRESULT APIENTRY waveInGetErrorTextA(MMRESULT mmrError, LPSTR lpText, UINT cchText);
MMRESULT APIENTRY waveInGetErrorTextW(MMRESULT mmrError, LPWSTR lpText, UINT cchText);
#ifdef UNICODE
     waveInGetErrorText  waveInGetErrorTextW
#else
     waveInGetErrorText  waveInGetErrorTextA
#endif // !UNICODE

MMRESULT APIENTRY waveInOpen(LPHWAVEIN lphwi, UINT uDeviceID,
    LPCWAVEFORMAT lpwf, DWORD dwCallback, DWORD dwInstance, DWORD fdwOpen);
MMRESULT APIENTRY waveInClose(HWAVEIN hwi);
MMRESULT APIENTRY waveInPrepareHeader(HWAVEIN hwi, LPWAVEHDR lpwh, UINT cbwh);
MMRESULT APIENTRY waveInUnprepareHeader(HWAVEIN hwi, LPWAVEHDR lpwh, UINT cbwh);
MMRESULT APIENTRY waveInAddBuffer(HWAVEIN hwi, LPWAVEHDR lpwh, UINT cbwh);
MMRESULT APIENTRY waveInStart(HWAVEIN hwi);
MMRESULT APIENTRY waveInStop(HWAVEIN hwi);
MMRESULT APIENTRY waveInReset(HWAVEIN hwi);
MMRESULT APIENTRY waveInGetPosition(HWAVEIN hwi, LPMMTIME lpmmt, UINT cbmmt);
MMRESULT APIENTRY waveInGetID(HWAVEIN hwi, LPUINT lpuDeviceID);

MMRESULT APIENTRY waveInMessage(HWAVEIN hwi, UINT uMsg, DWORD dw1, DWORD dw2);


#endif  // RC_INVOKED
#endif  //ifndef MMNOWAVE



#ifndef MMNOMIDI
/****************************************************************************

                            MIDI audio support

****************************************************************************/

/* MIDI error return values */
     MIDIERR_UNPREPARED    (MIDIERR_BASE + 0)   // header not prepared
     MIDIERR_STILLPLAYING  (MIDIERR_BASE + 1)   // still something playing
     MIDIERR_NOMAP         (MIDIERR_BASE + 2)   // no current map
     MIDIERR_NOTREADY      (MIDIERR_BASE + 3)   // hardware is still busy
     MIDIERR_NODEVICE      (MIDIERR_BASE + 4)   // port no longer connected
     MIDIERR_INVALIDSETUP  (MIDIERR_BASE + 5)   // invalid setup (invalid MIF)
     MIDIERR_BADOPENMODE   (MIDIERR_BASE + 6)   // operation unsupported w/ open mode
     MIDIERR_LASTERROR     (MIDIERR_BASE + 5)   // last error in range

/* MIDI audio data types */
typedef HANDLE  HMIDI;
typedef HMIDI   HMIDIIN;
typedef HMIDI   HMIDIOUT;

typedef HMIDIIN     *LPHMIDIIN;
typedef HMIDIOUT     *LPHMIDIOUT;
typedef DRVCALLBACK MIDICALLBACK;
typedef MIDICALLBACK     *LPMIDICALLBACK;
     MIDIPATCHSIZE   128
typedef WORD PATCHARRAY[MIDIPATCHSIZE];
typedef WORD     *LPPATCHARRAY;
typedef WORD KEYARRAY[MIDIPATCHSIZE];
typedef WORD     *LPKEYARRAY;

/* MIDI callback messages */
     MIM_OPEN        MM_MIM_OPEN
     MIM_CLOSE       MM_MIM_CLOSE
     MIM_DATA        MM_MIM_DATA
     MIM_LONGDATA    MM_MIM_LONGDATA
     MIM_ERROR       MM_MIM_ERROR
     MIM_LONGERROR   MM_MIM_LONGERROR
     MOM_OPEN        MM_MOM_OPEN
     MOM_CLOSE       MM_MOM_CLOSE
     MOM_DONE        MM_MOM_DONE

/* device ID for MIDI mapper */
     MIDIMAPPER     (-1)       // Cannot be cast to DWORD as RC complains
     MIDI_MAPPER    ((DWORD)(-1))

/* flags for wFlags parm of midiOutCachePatches(), midiOutCacheDrumPatches() */
     MIDI_CACHE_ALL      1
     MIDI_CACHE_BESTFIT  2
     MIDI_CACHE_QUERY    3
     MIDI_UNCACHE        4

/* MIDI output device capabilities structure */
typedef struct tagMIDIOUTCAPSA {
    WORD    wMid;                  // manufacturer ID
    WORD    wPid;                  // product ID
    MMVERSION vDriverVersion;      // version of the driver
    CHAR    szPname[MAXPNAMELEN];  // product name (NULL terminated string)
    WORD    wTechnology;           // type of device
    WORD    wVoices;               // # of voices (internal synth only)
    WORD    wNotes;                // max # of notes (internal synth only)
    WORD    wChannelMask;          // channels used (internal synth only)
    DWORD   dwSupport;             // functionality supported by driver
} MIDIOUTCAPSA;
/* MIDI output device capabilities structure */
typedef struct tagMIDIOUTCAPSW {
    WORD    wMid;                  // manufacturer ID
    WORD    wPid;                  // product ID
    MMVERSION vDriverVersion;      // version of the driver
    WCHAR   szPname[MAXPNAMELEN];  // product name (NULL terminated string)
    WORD    wTechnology;           // type of device
    WORD    wVoices;               // # of voices (internal synth only)
    WORD    wNotes;                // max # of notes (internal synth only)
    WORD    wChannelMask;          // channels used (internal synth only)
    DWORD   dwSupport;             // functionality supported by driver
} MIDIOUTCAPSW;
#ifdef UNICODE
typedef MIDIOUTCAPSW MIDIOUTCAPS;
#else
typedef MIDIOUTCAPSA MIDIOUTCAPS;
#endif // UNICODE
typedef MIDIOUTCAPSA    *PMIDIOUTCAPSA;
typedef MIDIOUTCAPSW    *PMIDIOUTCAPSW;
#ifdef UNICODE
typedef PMIDIOUTCAPSW PMIDIOUTCAPS;
#else
typedef PMIDIOUTCAPSA PMIDIOUTCAPS;
#endif // UNICODE
typedef MIDIOUTCAPSA      *NPMIDIOUTCAPSA;
typedef MIDIOUTCAPSW      *NPMIDIOUTCAPSW;
#ifdef UNICODE
typedef NPMIDIOUTCAPSW NPMIDIOUTCAPS;
#else
typedef NPMIDIOUTCAPSA NPMIDIOUTCAPS;
#endif // UNICODE
typedef MIDIOUTCAPSA      *LPMIDIOUTCAPSA;
typedef MIDIOUTCAPSW      *LPMIDIOUTCAPSW;
#ifdef UNICODE
typedef LPMIDIOUTCAPSW LPMIDIOUTCAPS;
#else
typedef LPMIDIOUTCAPSA LPMIDIOUTCAPS;
#endif // UNICODE

/* flags for wTechnology field of MIDIOUTCAPS structure */
     MOD_MIDIPORT    1  // output port
     MOD_SYNTH       2  // generic internal synth
     MOD_SQSYNTH     3  // square wave internal synth
     MOD_FMSYNTH     4  // FM internal synth
     MOD_MAPPER      5  // MIDI mapper

/* flags for dwSupport field of MIDIOUTCAPS */
     MIDICAPS_VOLUME     $00000001  // supports volume control
     MIDICAPS_LRVOLUME   $00000002  // separate left-right volume control
     MIDICAPS_CACHE      $00000004

/* MIDI input device capabilities structure */
typedef struct tagMIDIINCAPSA {
    WORD        wMid;                   // manufacturer ID
    WORD        wPid;                   // product ID
    MMVERSION   vDriverVersion;         // version of the driver
    CHAR        szPname[MAXPNAMELEN];   // product name (NULL terminated string)
} MIDIINCAPSA;
/* MIDI input device capabilities structure */
typedef struct tagMIDIINCAPSW {
    WORD        wMid;                   // manufacturer ID
    WORD        wPid;                   // product ID
    MMVERSION   vDriverVersion;         // version of the driver
    WCHAR       szPname[MAXPNAMELEN];   // product name (NULL terminated string)
} MIDIINCAPSW;
#ifdef UNICODE
typedef MIDIINCAPSW MIDIINCAPS;
#else
typedef MIDIINCAPSA MIDIINCAPS;
#endif // UNICODE
typedef MIDIINCAPSA     *PMIDIINCAPSA;
typedef MIDIINCAPSW     *PMIDIINCAPSW;
#ifdef UNICODE
typedef PMIDIINCAPSW PMIDIINCAPS;
#else
typedef PMIDIINCAPSA PMIDIINCAPS;
#endif // UNICODE
typedef MIDIINCAPSA      *NPMIDIINCAPSA;
typedef MIDIINCAPSW      *NPMIDIINCAPSW;
#ifdef UNICODE
typedef NPMIDIINCAPSW NPMIDIINCAPS;
#else
typedef NPMIDIINCAPSA NPMIDIINCAPS;
#endif // UNICODE
typedef MIDIINCAPSA     *LPMIDIINCAPSA;
typedef MIDIINCAPSW     *LPMIDIINCAPSW;
#ifdef UNICODE
typedef LPMIDIINCAPSW LPMIDIINCAPS;
#else
typedef LPMIDIINCAPSA LPMIDIINCAPS;
#endif // UNICODE

/* MIDI data block header */
typedef struct midihdr_tag {
    LPBYTE      lpData;               // pointer to locked data block
    DWORD       dwBufferLength;       // length of data in data block
    DWORD       dwBytesRecorded;      // used for input only
    DWORD       dwUser;               // for client's use
    DWORD       dwFlags;              // assorted flags (see defines)
    struct midihdr_tag     *lpNext;   // reserved for driver
    DWORD       reserved;             // reserved for driver
} MIDIHDR;
typedef MIDIHDR       *PMIDIHDR;
typedef MIDIHDR      *NPMIDIHDR;
typedef MIDIHDR      *LPMIDIHDR;

/* flags for dwFlags field of MIDIHDR structure */
     MHDR_DONE       $00000001       // done bit
     MHDR_PREPARED   $00000002       // set if header prepared
     MHDR_INQUEUE    $00000004       // reserved for driver


/* MIDI function prototypes */
UINT APIENTRY midiOutGetNumDevs(VOID);

MMRESULT APIENTRY midiOutGetDevCapsA(UINT uDeviceID, LPMIDIOUTCAPSA lpCaps, UINT cbCaps);
MMRESULT APIENTRY midiOutGetDevCapsW(UINT uDeviceID, LPMIDIOUTCAPSW lpCaps, UINT cbCaps);
#ifdef UNICODE
     midiOutGetDevCaps  midiOutGetDevCapsW
#else
     midiOutGetDevCaps  midiOutGetDevCapsA
#endif // !UNICODE

MMRESULT APIENTRY midiOutGetVolume(UINT uId, LPDWORD lpdwVolume);
MMRESULT APIENTRY midiOutSetVolume(UINT uId, DWORD dwVolume);

MMRESULT APIENTRY midiOutGetErrorTextA(MMRESULT mmrError, LPSTR lpText, UINT cchText);
MMRESULT APIENTRY midiOutGetErrorTextW(MMRESULT mmrError, LPWSTR lpText, UINT cchText);
#ifdef UNICODE
     midiOutGetErrorText  midiOutGetErrorTextW
#else
     midiOutGetErrorText  midiOutGetErrorTextA
#endif // !UNICODE

MMRESULT APIENTRY midiOutOpen(LPHMIDIOUT lphmo, UINT uDeviceID,
    DWORD dwCallback, DWORD dwInstance, DWORD fdwOpen);
MMRESULT APIENTRY midiOutClose(HMIDIOUT hmo);
MMRESULT APIENTRY midiOutPrepareHeader(HMIDIOUT hmo, LPMIDIHDR lpmh, UINT cbmh);
MMRESULT APIENTRY midiOutUnprepareHeader(HMIDIOUT hmo, LPMIDIHDR lpmh, UINT cbmh);

MMRESULT APIENTRY midiOutShortMsg(HMIDIOUT hmo, DWORD dwMsg);
MMRESULT APIENTRY midiOutLongMsg(HMIDIOUT hmo, LPMIDIHDR lpmh, UINT cbmh);
MMRESULT APIENTRY midiOutReset(HMIDIOUT hmo);
MMRESULT APIENTRY midiOutCachePatches(HMIDIOUT hmo, UINT uBank, LPWORD lpwpa, UINT fuCache);
MMRESULT APIENTRY midiOutCacheDrumPatches(HMIDIOUT hmo,
             UINT uPatch, LPWORD lpwkya, UINT fuCache);
MMRESULT APIENTRY midiOutGetID(HMIDIOUT hmo, LPUINT lpuDeviceID);

MMRESULT APIENTRY midiOutMessage(HMIDIOUT hmo, UINT uMsg, DWORD dw1, DWORD dw2);

UINT APIENTRY midiInGetNumDevs(VOID);
MMRESULT APIENTRY midiInGetDevCapsA(UINT uDeviceID, LPMIDIINCAPSA lpCaps, UINT cbCaps);
MMRESULT APIENTRY midiInGetDevCapsW(UINT uDeviceID, LPMIDIINCAPSW lpCaps, UINT cbCaps);
#ifdef UNICODE
     midiInGetDevCaps  midiInGetDevCapsW
#else
     midiInGetDevCaps  midiInGetDevCapsA
#endif // !UNICODE

MMRESULT APIENTRY midiInGetErrorTextA(MMRESULT err, LPSTR lpText, UINT cchText);
MMRESULT APIENTRY midiInGetErrorTextW(MMRESULT err, LPWSTR lpText, UINT cchText);
#ifdef UNICODE
     midiInGetErrorText  midiInGetErrorTextW
#else
     midiInGetErrorText  midiInGetErrorTextA
#endif // !UNICODE

MMRESULT APIENTRY midiInOpen(LPHMIDIIN lphmi, UINT uDeviceID,
        DWORD dwCallback, DWORD dwInstance, DWORD fdwOpen);
MMRESULT APIENTRY midiInClose(HMIDIIN hmi);
MMRESULT APIENTRY midiInPrepareHeader(HMIDIIN hmi, LPMIDIHDR lpmh, UINT cbmh);
MMRESULT APIENTRY midiInUnprepareHeader(HMIDIIN hmi, LPMIDIHDR lpmh, UINT cbmh);
MMRESULT APIENTRY midiInAddBuffer(HMIDIIN hmi, LPMIDIHDR lpmh, UINT cbmh);
MMRESULT APIENTRY midiInStart(HMIDIIN hmi);
MMRESULT APIENTRY midiInStop(HMIDIIN hmi);
MMRESULT APIENTRY midiInReset(HMIDIIN hmi);
MMRESULT APIENTRY midiInGetID(HMIDIIN hmi, LPUINT lpuDeviceID);

MMRESULT APIENTRY midiInMessage(HMIDIIN hmi, UINT uMsg, DWORD dw1, DWORD dw2);

#endif  //ifndef MMNOMIDI



#ifndef MMNOAUX
/****************************************************************************

                        Auxiliary audio support

****************************************************************************/

/* device ID for aux device mapper */
     AUX_MAPPER     ((DWORD)(-1))

/* Auxiliary audio device capabilities structure */
typedef struct tagAUXCAPSA {
    WORD        wMid;                   // manufacturer ID
    WORD        wPid;                   // product ID
    MMVERSION   vDriverVersion;         // version of the driver
    CHAR        szPname[MAXPNAMELEN];   // product name (NULL terminated string)
    WORD        wTechnology;            // type of device
    WORD        wReserved1;             // packing
    DWORD       dwSupport;              // functionality supported by driver
} AUXCAPSA;
/* Auxiliary audio device capabilities structure */
typedef struct tagAUXCAPSW {
    WORD        wMid;                   // manufacturer ID
    WORD        wPid;                   // product ID
    MMVERSION   vDriverVersion;         // version of the driver
    WCHAR       szPname[MAXPNAMELEN];   // product name (NULL terminated string)
    WORD        wTechnology;            // type of device
    WORD        wReserved1;             // packing
    DWORD       dwSupport;              // functionality supported by driver
} AUXCAPSW;
#ifdef UNICODE
typedef AUXCAPSW AUXCAPS;
#else
typedef AUXCAPSA AUXCAPS;
#endif // UNICODE
typedef AUXCAPSA      *PAUXCAPSA;
typedef AUXCAPSW      *PAUXCAPSW;
#ifdef UNICODE
typedef PAUXCAPSW PAUXCAPS;
#else
typedef PAUXCAPSA PAUXCAPS;
#endif // UNICODE
typedef AUXCAPSA      *NPAUXCAPSA;
typedef AUXCAPSW      *NPAUXCAPSW;
#ifdef UNICODE
typedef NPAUXCAPSW NPAUXCAPS;
#else
typedef NPAUXCAPSA NPAUXCAPS;
#endif // UNICODE
typedef AUXCAPSA      *LPAUXCAPSA;
typedef AUXCAPSW      *LPAUXCAPSW;
#ifdef UNICODE
typedef LPAUXCAPSW LPAUXCAPS;
#else
typedef LPAUXCAPSA LPAUXCAPS;
#endif // UNICODE

/* flags for wTechnology field in AUXCAPS structure */
     AUXCAPS_CDAUDIO    1       // audio from internal CD-ROM drive
     AUXCAPS_AUXIN      2       // audio from auxiliary input jacks

/* flags for dwSupport field in AUXCAPS structure */
     AUXCAPS_VOLUME     $00000001   // supports volume control
     AUXCAPS_LRVOLUME   $00000002   // separate left-right volume control

/* auxiliary audio function prototypes */
UINT APIENTRY auxGetNumDevs(VOID);
MMRESULT APIENTRY auxGetDevCapsA(UINT uDeviceID, LPAUXCAPSA lpCaps, UINT cbCaps);
MMRESULT APIENTRY auxGetDevCapsW(UINT uDeviceID, LPAUXCAPSW lpCaps, UINT cbCaps);
#ifdef UNICODE
     auxGetDevCaps  auxGetDevCapsW
#else
     auxGetDevCaps  auxGetDevCapsA
#endif // !UNICODE
MMRESULT APIENTRY auxSetVolume(UINT uDeviceID, DWORD dwVolume);
MMRESULT APIENTRY auxGetVolume(UINT uDeviceID, LPDWORD lpdwVolume);

MMRESULT APIENTRY auxOutMessage(UINT uDeviceID, UINT uMsg, DWORD dw1, DWORD dw2);

#endif  //ifndef MMNOAUX

#ifndef MMNOMIXER
/****************************************************************************

                            Mixer Support

****************************************************************************/

// MM_MIXM_LINE_CHANGE and MM_MIXM_CONTROL_CHANGE are defined earlier

DECLARE_HANDLE(HMIXEROBJ);
typedef HMIXEROBJ      *LPHMIXEROBJ;

DECLARE_HANDLE(HMIXER);
typedef HMIXER         *LPHMIXER;

     MIXER_SHORT_NAME_CHARS      16
     MIXER_LONG_NAME_CHARS       64


/*  MMRESULT error return values specific to the mixer API */

     MIXERR_INVALLINE            (MIXERR_BASE + 0)
     MIXERR_INVALCONTROL         (MIXERR_BASE + 1)
     MIXERR_INVALVALUE           (MIXERR_BASE + 2)
     MIXERR_LASTERROR            (MIXERR_BASE + 2)


     MIXER_OBJECTF_HANDLE    $80000000L
     MIXER_OBJECTF_MIXER     $00000000L
     MIXER_OBJECTF_HMIXER    (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_MIXER)
     MIXER_OBJECTF_WAVEOUT   $10000000L
     MIXER_OBJECTF_HWAVEOUT  (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_WAVEOUT)
     MIXER_OBJECTF_WAVEIN    $20000000L
     MIXER_OBJECTF_HWAVEIN   (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_WAVEIN)
     MIXER_OBJECTF_MIDIOUT   $30000000L
     MIXER_OBJECTF_HMIDIOUT  (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_MIDIOUT)
     MIXER_OBJECTF_MIDIIN    $40000000L
     MIXER_OBJECTF_HMIDIIN   (MIXER_OBJECTF_HANDLE|MIXER_OBJECTF_MIDIIN)
     MIXER_OBJECTF_AUX       $50000000L


UINT APIENTRY mixerGetNumDevs(void);

typedef struct tMIXERCAPSA
{
    WORD            wMid;                   // manufacturer id
    WORD            wPid;                   // product id
    MMVERSION       vDriverVersion;         // version of the driver
    CHAR            szPname[MAXPNAMELEN];   // product name
    DWORD           fdwSupport;             // misc. support bits
    DWORD           cDestinations;          // count of destinations
} MIXERCAPSA;
typedef struct tMIXERCAPSW
{
    WORD            wMid;                   // manufacturer id
    WORD            wPid;                   // product id
    MMVERSION       vDriverVersion;         // version of the driver
    WCHAR           szPname[MAXPNAMELEN];   // product name
    DWORD           fdwSupport;             // misc. support bits
    DWORD           cDestinations;          // count of destinations
} MIXERCAPSW;
#ifdef UNICODE
typedef MIXERCAPSW MIXERCAPS;
#else
typedef MIXERCAPSA MIXERCAPS;
#endif // UNICODE
typedef MIXERCAPSA *PMIXERCAPSA;
typedef MIXERCAPSW *PMIXERCAPSW;
#ifdef UNICODE
typedef PMIXERCAPSW PMIXERCAPS;
#else
typedef PMIXERCAPSA PMIXERCAPS;
#endif // UNICODE
typedef MIXERCAPSA     *LPMIXERCAPSA;
typedef MIXERCAPSW     *LPMIXERCAPSW;
#ifdef UNICODE
typedef LPMIXERCAPSW LPMIXERCAPS;
#else
typedef LPMIXERCAPSA LPMIXERCAPS;
#endif // UNICODE



MMRESULT APIENTRY mixerGetDevCapsA(UINT uMxId, LPMIXERCAPSA pmxcaps, UINT cbmxcaps);
MMRESULT APIENTRY mixerGetDevCapsW(UINT uMxId, LPMIXERCAPSW pmxcaps, UINT cbmxcaps);
#ifdef UNICODE
     mixerGetDevCaps  mixerGetDevCapsW
#else
     mixerGetDevCaps  mixerGetDevCapsA
#endif // !UNICODE
MMRESULT APIENTRY mixerGetID(HMIXEROBJ hmxobj, UINT     *puMxId, DWORD fdwId);


MMRESULT APIENTRY mixerOpen(LPHMIXER phmx, UINT uMxId, DWORD dwCallback, DWORD dwInstance, DWORD fdwOpen);


MMRESULT APIENTRY mixerClose(HMIXER hmx);

DWORD APIENTRY mixerMessage(HMIXER hmx, UINT uMsg, DWORD dwParam1, DWORD dwParam2);

typedef struct tMIXERLINEA
{
    DWORD       cbStruct;               // size of MIXERLINE structure
    DWORD       dwDestination;          // zero based destination index
    DWORD       dwSource;               // zero based source index (if source)
    DWORD       dwLineID;               // unique line id for mixer device
    DWORD       fdwLine;                // state/information about line
    DWORD       dwUser;                 // driver specific information
    DWORD       dwComponentType;        // component type line connects to
    DWORD       cChannels;              // number of channels line supports
    DWORD       cConnections;           // number of connections [possible]
    DWORD       cControls;              // number of controls at this line
    CHAR        szShortName[MIXER_SHORT_NAME_CHARS];
    CHAR        szName[MIXER_LONG_NAME_CHARS];
    struct
    {
        DWORD   dwType;                 // MIXERLINE_TARGETTYPE_xxxx
        DWORD   dwDeviceID;             // target device ID of device type
        WORD    wMid;                   // of target device
        WORD    wPid;                   //      "
        MMVERSION  vDriverVersion;      //      "
        CHAR    szPname[MAXPNAMELEN];   //      "
    } Target;
} MIXERLINEA;
typedef struct tMIXERLINEW
{
    DWORD       cbStruct;               // size of MIXERLINE structure
    DWORD       dwDestination;          // zero based destination index
    DWORD       dwSource;               // zero based source index (if source)
    DWORD       dwLineID;               // unique line id for mixer device
    DWORD       fdwLine;                // state/information about line
    DWORD       dwUser;                 // driver specific information
    DWORD       dwComponentType;        // component type line connects to
    DWORD       cChannels;              // number of channels line supports
    DWORD       cConnections;           // number of connections [possible]
    DWORD       cControls;              // number of controls at this line
    WCHAR       szShortName[MIXER_SHORT_NAME_CHARS];
    WCHAR       szName[MIXER_LONG_NAME_CHARS];
    struct
    {
        DWORD   dwType;                 // MIXERLINE_TARGETTYPE_xxxx
        DWORD   dwDeviceID;             // target device ID of device type
        WORD    wMid;                   // of target device
        WORD    wPid;                   //      "
        MMVERSION  vDriverVersion;      //      "
        WCHAR   szPname[MAXPNAMELEN];   //      "
    } Target;
} MIXERLINEW;
#ifdef UNICODE
typedef MIXERLINEW MIXERLINE;
#else
typedef MIXERLINEA MIXERLINE;
#endif // UNICODE
typedef MIXERLINEA *PMIXERLINEA;
typedef MIXERLINEW *PMIXERLINEW;
#ifdef UNICODE
typedef PMIXERLINEW PMIXERLINE;
#else
typedef PMIXERLINEA PMIXERLINE;
#endif // UNICODE
typedef MIXERLINEA     *LPMIXERLINEA;
typedef MIXERLINEW     *LPMIXERLINEW;
#ifdef UNICODE
typedef LPMIXERLINEW LPMIXERLINE;
#else
typedef LPMIXERLINEA LPMIXERLINE;
#endif // UNICODE


/*  MIXERLINE.fdwLine */

     MIXERLINE_LINEF_ACTIVE              $00000001L
     MIXERLINE_LINEF_DISCONNECTED        $00008000L
     MIXERLINE_LINEF_SOURCE              $80000000L


/*  MIXERLINE.dwComponentType */

/*  component types for destinations and sources */

     MIXERLINE_COMPONENTTYPE_DST_FIRST       $00000000L
     MIXERLINE_COMPONENTTYPE_DST_UNDEFINED   (MIXERLINE_COMPONENTTYPE_DST_FIRST + 0)
     MIXERLINE_COMPONENTTYPE_DST_DIGITAL     (MIXERLINE_COMPONENTTYPE_DST_FIRST + 1)
     MIXERLINE_COMPONENTTYPE_DST_LINE        (MIXERLINE_COMPONENTTYPE_DST_FIRST + 2)
     MIXERLINE_COMPONENTTYPE_DST_MONITOR     (MIXERLINE_COMPONENTTYPE_DST_FIRST + 3)
     MIXERLINE_COMPONENTTYPE_DST_SPEAKERS    (MIXERLINE_COMPONENTTYPE_DST_FIRST + 4)
     MIXERLINE_COMPONENTTYPE_DST_HEADPHONES  (MIXERLINE_COMPONENTTYPE_DST_FIRST + 5)
     MIXERLINE_COMPONENTTYPE_DST_TELEPHONE   (MIXERLINE_COMPONENTTYPE_DST_FIRST + 6)
     MIXERLINE_COMPONENTTYPE_DST_WAVEIN      (MIXERLINE_COMPONENTTYPE_DST_FIRST + 7)
     MIXERLINE_COMPONENTTYPE_DST_VOICEIN     (MIXERLINE_COMPONENTTYPE_DST_FIRST + 8)
     MIXERLINE_COMPONENTTYPE_DST_LAST        (MIXERLINE_COMPONENTTYPE_DST_FIRST + 8)

     MIXERLINE_COMPONENTTYPE_SRC_FIRST       $00001000L
     MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED   (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 0)
     MIXERLINE_COMPONENTTYPE_SRC_DIGITAL     (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 1)
     MIXERLINE_COMPONENTTYPE_SRC_LINE        (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 2)
     MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE  (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 3)
     MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 4)
     MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 5)
     MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE   (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 6)
     MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER   (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 7)
     MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT     (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 8)
     MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY   (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 9)
     MIXERLINE_COMPONENTTYPE_SRC_ANALOG      (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10)
     MIXERLINE_COMPONENTTYPE_SRC_LAST        (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10)


/*  MIXERLINE.Target.dwType */

     MIXERLINE_TARGETTYPE_UNDEFINED      0
     MIXERLINE_TARGETTYPE_WAVEOUT        1
     MIXERLINE_TARGETTYPE_WAVEIN         2
     MIXERLINE_TARGETTYPE_MIDIOUT        3
     MIXERLINE_TARGETTYPE_MIDIIN         4
     MIXERLINE_TARGETTYPE_AUX            5



MMRESULT APIENTRY mixerGetLineInfoA (HMIXEROBJ hmxobj, LPMIXERLINEA pmxl, DWORD fdwInfo);
MMRESULT APIENTRY mixerGetLineInfoW (HMIXEROBJ hmxobj, LPMIXERLINEW pmxl, DWORD fdwInfo);
#ifdef UNICODE
     mixerGetLineInfo  mixerGetLineInfoW
#else
     mixerGetLineInfo  mixerGetLineInfoA
#endif // !UNICODE

     MIXER_GETLINEINFOF_DESTINATION      $00000000L
     MIXER_GETLINEINFOF_SOURCE           $00000001L
     MIXER_GETLINEINFOF_LINEID           $00000002L
     MIXER_GETLINEINFOF_COMPONENTTYPE    $00000003L
     MIXER_GETLINEINFOF_TARGETTYPE       $00000004L

     MIXER_GETLINEINFOF_QUERYMASK        $0000000FL

/*  MIXERCONTROL */

typedef struct tMIXERCONTROLA
{
    DWORD           cbStruct;           // size in bytes of MIXERCONTROL
    DWORD           dwControlID;        // unique control id for mixer device
    DWORD           dwControlType;      // MIXERCONTROL_CONTROLTYPE_xxx
    DWORD           fdwControl;         // MIXERCONTROL_CONTROLF_xxx
    DWORD           cMultipleItems;     // if MIXERCONTROL_CONTROLF_MULTIPLE set
    CHAR            szShortName[MIXER_SHORT_NAME_CHARS];
    CHAR            szName[MIXER_LONG_NAME_CHARS];
    union
    {
#if !defined(NO_ANONYMOUS_STRUCT)
        struct
        {
            LONG    lMinimum;           // signed minimum for this control
            LONG    lMaximum;           // signed maximum for this control
        };
        struct
        {
            DWORD   dwMinimum;          // unsigned minimum for this control
            DWORD   dwMaximum;          // unsigned maximum for this control
        };
#endif
        struct
        {
            LONG    lMinimum;           // signed minimum for this control
            LONG    lMaximum;           // signed maximum for this control
        } u1;
        struct
        {
            DWORD   dwMinimum;          // unsigned minimum for this control
            DWORD   dwMaximum;          // unsigned maximum for this control
        } u2;
        DWORD       dwReserved[6];
    } Bounds;
    union
    {
        DWORD       cSteps;             // # of steps between min & max
        DWORD       cbCustomData;       // size in bytes of custom data
        DWORD       dwReserved[6];      // !!! needed? we have cbStruct....
    } Metrics;
} MIXERCONTROLA;
typedef struct tMIXERCONTROLW
{
    DWORD           cbStruct;           // size in bytes of MIXERCONTROL
    DWORD           dwControlID;        // unique control id for mixer device
    DWORD           dwControlType;      // MIXERCONTROL_CONTROLTYPE_xxx
    DWORD           fdwControl;         // MIXERCONTROL_CONTROLF_xxx
    DWORD           cMultipleItems;     // if MIXERCONTROL_CONTROLF_MULTIPLE set
    WCHAR           szShortName[MIXER_SHORT_NAME_CHARS];
    WCHAR           szName[MIXER_LONG_NAME_CHARS];
    union
    {
#if !defined(NO_ANONYMOUS_STRUCT)
        struct
        {
            LONG    lMinimum;           // signed minimum for this control
            LONG    lMaximum;           // signed maximum for this control
        };
        struct
        {
            DWORD   dwMinimum;          // unsigned minimum for this control
            DWORD   dwMaximum;          // unsigned maximum for this control
        };
#endif
        struct
        {
            LONG    lMinimum;           // signed minimum for this control
            LONG    lMaximum;           // signed maximum for this control
        } u1;
        struct
        {
            DWORD   dwMinimum;          // unsigned minimum for this control
            DWORD   dwMaximum;          // unsigned maximum for this control
        } u2;
        DWORD       dwReserved[6];
    } Bounds;
    union
    {
        DWORD       cSteps;             // # of steps between min & max
        DWORD       cbCustomData;       // size in bytes of custom data
        DWORD       dwReserved[6];      // !!! needed? we have cbStruct....
    } Metrics;
} MIXERCONTROLW;
#ifdef UNICODE
typedef MIXERCONTROLW MIXERCONTROL;
#else
typedef MIXERCONTROLA MIXERCONTROL;
#endif // UNICODE
typedef MIXERCONTROLA *PMIXERCONTROLA;
typedef MIXERCONTROLW *PMIXERCONTROLW;
#ifdef UNICODE
typedef PMIXERCONTROLW PMIXERCONTROL;
#else
typedef PMIXERCONTROLA PMIXERCONTROL;
#endif // UNICODE
typedef MIXERCONTROLA     *LPMIXERCONTROLA;
typedef MIXERCONTROLW     *LPMIXERCONTROLW;
#ifdef UNICODE
typedef LPMIXERCONTROLW LPMIXERCONTROL;
#else
typedef LPMIXERCONTROLA LPMIXERCONTROL;
#endif // UNICODE


/*  MIXERCONTROL.fdwControl */

     MIXERCONTROL_CONTROLF_UNIFORM   $00000001L
     MIXERCONTROL_CONTROLF_MULTIPLE  $00000002L
     MIXERCONTROL_CONTROLF_DISABLED  $80000000L




/*  MIXERCONTROL_CONTROLTYPE_xxx building block defines */

     MIXERCONTROL_CT_CLASS_MASK          $F0000000L
     MIXERCONTROL_CT_CLASS_CUSTOM        $00000000L
     MIXERCONTROL_CT_CLASS_METER         $10000000L
     MIXERCONTROL_CT_CLASS_SWITCH        $20000000L
     MIXERCONTROL_CT_CLASS_NUMBER        $30000000L
     MIXERCONTROL_CT_CLASS_SLIDER        $40000000L
     MIXERCONTROL_CT_CLASS_FADER         $50000000L
     MIXERCONTROL_CT_CLASS_TIME          $60000000L
     MIXERCONTROL_CT_CLASS_LIST          $70000000L


     MIXERCONTROL_CT_SUBCLASS_MASK       $0F000000L

     MIXERCONTROL_CT_SC_SWITCH_BOOLEAN   $00000000L
     MIXERCONTROL_CT_SC_SWITCH_BUTTON    $01000000L

     MIXERCONTROL_CT_SC_METER_POLLED     $00000000L

     MIXERCONTROL_CT_SC_TIME_MICROSECS   $00000000L
     MIXERCONTROL_CT_SC_TIME_MILLISECS   $01000000L

     MIXERCONTROL_CT_SC_LIST_SINGLE      $00000000L
     MIXERCONTROL_CT_SC_LIST_MULTIPLE    $01000000L


     MIXERCONTROL_CT_UNITS_MASK          $00FF0000L
     MIXERCONTROL_CT_UNITS_CUSTOM        $00000000L
     MIXERCONTROL_CT_UNITS_BOOLEAN       $00010000L
     MIXERCONTROL_CT_UNITS_SIGNED        $00020000L
     MIXERCONTROL_CT_UNITS_UNSIGNED      $00030000L
     MIXERCONTROL_CT_UNITS_DECIBELS      $00040000L // in 10ths
     MIXERCONTROL_CT_UNITS_PERCENT       $00050000L // in 10ths


/*  MIXERCONTROL.dwControlType */

/*  Custom Controls */

     MIXERCONTROL_CONTROLTYPE_CUSTOM         (MIXERCONTROL_CT_CLASS_CUSTOM | MIXERCONTROL_CT_UNITS_CUSTOM)


/*  Meters (Boolean) */

/*  simply shows 'on or off' with the Boolean type */

     MIXERCONTROL_CONTROLTYPE_BOOLEANMETER   (MIXERCONTROL_CT_CLASS_METER | MIXERCONTROL_CT_SC_METER_POLLED | MIXERCONTROL_CT_UNITS_BOOLEAN)


/*  Meters (signed) */

/*      MIXERCONTROL.Bounds.lMinimum    = min */
/*      MIXERCONTROL.Bounds.lMaximum    = max */
/* */
/*  signed meters are meant for displaying levels that have a signed nature. */
/*  there is no requirment for the values above and below zero to be */
/*  equal in magnitude. that is, it is 'ok' to have a range from, say, -3 */
/*  to 12. however, the standard defined signed meter types may have */
/*  restrictions (such as the peakmeter). */
/* */
/*  MIXERCONTROL_CONTROLTYPE_PEAKMETER: a peak meter tells the monitoring */
/*  application the peak value reached (and phase) of a line (normally */
/*  wave input and output) over a small period of time. THIS IS NOT VU! */
/*  the bounds are fixed: */
/* */
/*      MIXERCONTROL.Bounds.lMinimum    = -32768    ALWAYS! */
/*      MIXERCONTROL.Bounds.lMaximum    = 32767     ALWAYS! */
/* */
/*  so 8 bit and 24 bit samples must be scaled appropriately. this is so */
/*  an application can display a 'bouncing blinky light' for a user and */
/*  also monitor a line for clipping. remember that 8 bit samples must */
/*  be converted to signed values (by the mixer driver)! */
/* */
/* */
/*  NOTE! meters are read only controls. also, a meter should only be */
/*  'active' when the line it is associated with is active (see fdwLine */
/*  in MIXERLINE). it is NOT an error to read a meter that is not active-- */
/*  the mixer driver should simply return 'no value' states (usually zero). */
/*  but it may be useful to stop monitoring a meter if the line is not */
/*  active... */
/* */
     MIXERCONTROL_CONTROLTYPE_SIGNEDMETER    (MIXERCONTROL_CT_CLASS_METER | MIXERCONTROL_CT_SC_METER_POLLED | MIXERCONTROL_CT_UNITS_SIGNED)
     MIXERCONTROL_CONTROLTYPE_PEAKMETER      (MIXERCONTROL_CONTROLTYPE_SIGNEDMETER + 1)


/* */
/*  Meters (unsigned) */
/* */
/*      MIXERCONTROL.Bounds.dwMinimum   = min */
/*      MIXERCONTROL.Bounds.dwMaximum   = max */
/* */
/*  unsigned meters are meant for displaying levels that have an unsigned */
/*  nature. there is no requirment for the values to be based at zero. */
/*  that is, it is 'ok' to have a range from, say, 8 to 42. however, the */
/*  standard defined unsigned meter types may have restrictions. */
/* */
/* */
/*  NOTE! meters are read only controls. also, a meter should only be */
/*  'active' when the line it is associated with is active (see fdwLine */
/*  in MIXERLINE). it is NOT an error to read a meter that is not active-- */
/*  the mixer driver should simply return 'no value' states (usually zero). */
/*  but it may be useful to stop monitoring a meter if the line is not */
/*  active... */
/* */
     MIXERCONTROL_CONTROLTYPE_UNSIGNEDMETER  (MIXERCONTROL_CT_CLASS_METER | MIXERCONTROL_CT_SC_METER_POLLED | MIXERCONTROL_CT_UNITS_UNSIGNED)


/* */
/*  Switches (Boolean) */
/* */
/*      MIXERCONTROL.Bounds.lMinimum    = ignored (though should be zero) */
/*      MIXERCONTROL.Bounds.lMaximum    = ignored (though should be one) */
/* */
/*  Boolean switches are for enabling/disabling things. they are either */
/*  on (non-zero for fValue, 1 should be used) or off (zero for fValue). */
/*  a few standard types are defined in case an application wants to search */
/*  for a specific type of switch (like mute)--and also to allow a different */
/*  looking control to be used (say for ON/OFF vs a generic Boolean). */
/* */
/* */
     MIXERCONTROL_CONTROLTYPE_BOOLEAN        (MIXERCONTROL_CT_CLASS_SWITCH | MIXERCONTROL_CT_SC_SWITCH_BOOLEAN | MIXERCONTROL_CT_UNITS_BOOLEAN)
     MIXERCONTROL_CONTROLTYPE_ONOFF          (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 1)
     MIXERCONTROL_CONTROLTYPE_MUTE           (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 2)
     MIXERCONTROL_CONTROLTYPE_MONO           (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 3)
     MIXERCONTROL_CONTROLTYPE_LOUDNESS       (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 4)
     MIXERCONTROL_CONTROLTYPE_STEREOENH      (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 5)


/* */
/*  a button switch is 'write only' and simply signals the driver to do */
/*  something. an example is a 'Calibrate' button like the one in the */
/*  existing Turtle Beach MultiSound recording prep utility. an application */
/*  sets the fValue to TRUE for all buttons that should be pressed. if */
/*  fValue is FALSE, no action will be taken. reading a button's value will */
/*  always return FALSE (not depressed). */
/* */
     MIXERCONTROL_CONTROLTYPE_BUTTON         (MIXERCONTROL_CT_CLASS_SWITCH | MIXERCONTROL_CT_SC_SWITCH_BUTTON | MIXERCONTROL_CT_UNITS_BOOLEAN)



     MIXERCONTROL_CONTROLTYPE_DECIBELS (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_DECIBELS)


/*  Number (signed integer) */

     MIXERCONTROL_CONTROLTYPE_SIGNED         (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_SIGNED)

/*  the units are in 10ths of 1 decibel */

/*  Number (usigned integer) */

     MIXERCONTROL_CONTROLTYPE_UNSIGNED       (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_UNSIGNED)

/*  the units are in 10ths of 1 percent */

     MIXERCONTROL_CONTROLTYPE_PERCENT        (MIXERCONTROL_CT_CLASS_NUMBER | MIXERCONTROL_CT_UNITS_PERCENT)


/* */
/*  Sliders (signed integer) */
/* */
/*  sliders are meant 'positioning' type controls (such as panning). */
/*  the generic slider must have lMinimum, lMaximum, and cSteps filled */
/*  in--also note that there is no restriction on these values (see */
/*  signed meters above for more). */
/* */
/* */
/*  MIXERCONTROL_CONTROLTYPE_PAN: this is meant to be a real simple pan */
/*  for stereo lines. the Bounds are fixed to be -32768 to 32767 with 0 */
/*  being dead center. these values are LINEAR and there are no units */
/*  (-32768 = extreme left, 32767 = extreme right). */
/* */
/*  if an application wants to display a scrollbar that does not contain */
/*  a bunch of 'dead space', then the scrollbar range should be set to */
/*  MIXERCONTROL.Metrics.cSteps and lValue should be scaled appropriately */
/*  with MulDiv. */
/* */
/*      MIXERCONTROL.Bounds.lMinimum    = -32768    ALWAYS! */
/*      MIXERCONTROL.Bounds.lMaximum    = 32768     ALWAYS! */
/*      MIXERCONTROL.Metrics.cSteps     = number of steps for range. */
/* */
/* */
/*  MIXERCONTROL_CONTROLTYPE_QSOUNDPAN: the initial version of Q-Sound (tm, */
/*  etc by Archer Communications) defines 'Q-Space' as a sortof semi-circle */
/*  with 33 positions (0 = extreme left, 33 = extreme right, 16 = center). */
/*  in order to work with our 'slider position' concept, we shift these */
/*  values to -15 = extreme left, 15 = extreme right, 0 = center. */
/* */
/*      MIXERCONTROL.Bounds.lMinimum    = -15   ALWAYS! */
/*      MIXERCONTROL.Bounds.lMaximum    = 15    ALWAYS! */
/*      MIXERCONTROL.Metrics.cSteps     = 1     ALWAYS! */
/* */
/* */
     MIXERCONTROL_CONTROLTYPE_SLIDER         (MIXERCONTROL_CT_CLASS_SLIDER | MIXERCONTROL_CT_UNITS_SIGNED)
     MIXERCONTROL_CONTROLTYPE_PAN            (MIXERCONTROL_CONTROLTYPE_SLIDER + 1)
     MIXERCONTROL_CONTROLTYPE_QSOUNDPAN      (MIXERCONTROL_CONTROLTYPE_SLIDER + 2)


/* */
/*  Simple Faders (unsigned integer) */
/* */
/*      MIXERCONTROL.Bounds.dwMinimum   = 0     ALWAYS! */
/*      MIXERCONTROL.Bounds.dwMaximum   = 65535 ALWAYS! */
/* */
/*      MIXERCONTROL.Metrics.cSteps     = number of steps for range. */
/* */
/*  these faders are meant to be as simple as possible for an application */
/*  to use. the Bounds are fixed to be 0 to $FFFF with $8000 being half */
/*  volume/level. these values are LINEAR and there are no units. 0 is */
/*  minimum volume/level, $FFFF is maximum. */
/* */
/*  if an application wants to display a scrollbar that does not contain */
/*  a bunch of 'dead space', then the scrollbar range should be set to */
/*  MIXERCONTROL.Metrics.cSteps and dwValue should be scaled appropriately */
/*  with MulDiv. */
/* */
     MIXERCONTROL_CONTROLTYPE_FADER          (MIXERCONTROL_CT_CLASS_FADER | MIXERCONTROL_CT_UNITS_UNSIGNED)
     MIXERCONTROL_CONTROLTYPE_VOLUME         (MIXERCONTROL_CONTROLTYPE_FADER + 1)
     MIXERCONTROL_CONTROLTYPE_BASS           (MIXERCONTROL_CONTROLTYPE_FADER + 2)
     MIXERCONTROL_CONTROLTYPE_TREBLE         (MIXERCONTROL_CONTROLTYPE_FADER + 3)
     MIXERCONTROL_CONTROLTYPE_EQUALIZER      (MIXERCONTROL_CONTROLTYPE_FADER + 4)


/* */
/*  List (single select) */
/* */
/*      MIXERCONTROL.cMultipleItems = number of items in list */
/* */
/*      MIXER_GETCONTROLDETAILSF_LISTTEXT should be used to get the text */
/*      for each item. */
/* */
/*      MIXERCONTROLDETAILS_BOOLEAN should be used to set and retrieve */
/*      what item is selected (fValue = TRUE if selected). */
/* */
/*  the generic single select lists can be used for many things. some */
/*  examples are 'Effects'. a mixer driver could provide a list of */
/*  different effects that could be applied like */
/* */
/*      Reverbs: large hall, warm hall, bright plate, warehouse, etc. */
/* */
/*      Delays: sweep delays, hold delays, 1.34 sec delay, etc. */
/* */
/*      Vocal: recital hall, alcove, delay gate, etc */
/* */
/*  lots of uses! gates, compressors, filters, dynamics, etc, etc. */
/* */
/* */
/*  MIXERCONTROL_CONTROLTYPE_MUX: a 'Mux' is a single selection multiplexer. */
/*  usually a Mux is used to select, say, an input source for recording. */
/*  for example, a mixer driver might have a mux that lets the user select */
/*  between Microphone or Line-In (but not both!) for recording. this */
/*  would be a perfect place to use a Mux control. some cards (for example */
/*  Media Vision's 16 bit Pro Audio cards) can record from multiple sources */
/*  simultaneously, so they would use a MIXERCONTROL_CONTROLTYPE_MIXER, not */
/*  a MIXERCONTROL_CONTROLTYPE_MUX). */
/* */
/* */
/*  NOTE! because single select lists can change what selections are */
/*  possible based on other controls (uhg!), the application must examine */
/*  the fValue's of all items after setting the control details so the */
/*  display can be refreshed accordingly. an example might be that an */
/*  audio card cannot change its input source while recording--so the */
/*  selection would 'fail' by keeping the fValue on the current selection */
/*  (but mixerSetControlDetails will succeed!). */
/* */
     MIXERCONTROL_CONTROLTYPE_SINGLESELECT   (MIXERCONTROL_CT_CLASS_LIST | MIXERCONTROL_CT_SC_LIST_SINGLE | MIXERCONTROL_CT_UNITS_BOOLEAN)
     MIXERCONTROL_CONTROLTYPE_MUX            (MIXERCONTROL_CONTROLTYPE_SINGLESELECT + 1)


/* */
/*  List (multiple select) */
/* */
/*      MIXERCONTROL.cMultipleItems = number of items in list */
/* */
/*      MIXER_GETCONTROLDETAILSF_LISTTEXT should be used to get the text */
/*      for each item. */
/* */
/*      MIXERCONTROLDETAILS_BOOLEAN should be used to set and retrieve */
/*      what item(s) are selected (fValue = TRUE if selected). */
/* */
/*  NOTE! because multiple select lists can change what selections are */
/*  selected based on other selections (uhg!), the application must examine */
/*  the fValue's of all items after setting the control details so the */
/*  display can be refreshed accordingly. an example might be that an */
/*  audio card cannot change its input source(s) while recording--so the */
/*  selection would 'fail' by keeping the fValue on the current selection(s) */
/*  (but mixerSetControlDetails will succeed!). */
/* */
     MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT (MIXERCONTROL_CT_CLASS_LIST | MIXERCONTROL_CT_SC_LIST_MULTIPLE | MIXERCONTROL_CT_UNITS_BOOLEAN)
     MIXERCONTROL_CONTROLTYPE_MIXER          (MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT + 1)


/* */
/*  Time Controls */
/* */
/*      MIXERCONTROL.Bounds.dwMinimum   = min */
/*      MIXERCONTROL.Bounds.dwMaximum   = max */
/* */
/*  time controls are meant for inputing time information. these can be */
/*  used for effects such as delay, reverb, etc. */
/* */
/* */
     MIXERCONTROL_CONTROLTYPE_MICROTIME      (MIXERCONTROL_CT_CLASS_TIME | MIXERCONTROL_CT_SC_TIME_MICROSECS | MIXERCONTROL_CT_UNITS_UNSIGNED)

     MIXERCONTROL_CONTROLTYPE_MILLITIME      (MIXERCONTROL_CT_CLASS_TIME | MIXERCONTROL_CT_SC_TIME_MILLISECS | MIXERCONTROL_CT_UNITS_UNSIGNED)



/* */
/*  MIXERLINECONTROLS */
/* */
/* */
/* */
typedef struct tMIXERLINECONTROLSA
{
    DWORD           cbStruct;       // size in bytes of MIXERLINECONTROLS
    DWORD           dwLineID;       // line id (from MIXERLINE.dwLineID)
    union
    {
        DWORD       dwControlID;    // MIXER_GETLINECONTROLSF_ONEBYID
        DWORD       dwControlType;  // MIXER_GETLINECONTROLSF_ONEBYTYPE
    } _UNION_NAME(u);
    DWORD           cControls;      // count of controls pmxctrl points to
    DWORD           cbmxctrl;       // size in bytes of _one_ MIXERCONTROL
    LPMIXERCONTROLA pamxctrl;       // pointer to first MIXERCONTROL array
} MIXERLINECONTROLSA;
/* */
/*  MIXERLINECONTROLS */
/* */
/* */
/* */
typedef struct tMIXERLINECONTROLSW
{
    DWORD           cbStruct;       // size in bytes of MIXERLINECONTROLS
    DWORD           dwLineID;       // line id (from MIXERLINE.dwLineID)
    union
    {
        DWORD       dwControlID;    // MIXER_GETLINECONTROLSF_ONEBYID
        DWORD       dwControlType;  // MIXER_GETLINECONTROLSF_ONEBYTYPE
    } _UNION_NAME(u);
    DWORD           cControls;      // count of controls pmxctrl points to
    DWORD           cbmxctrl;       // size in bytes of _one_ MIXERCONTROL
    LPMIXERCONTROLW pamxctrl;       // pointer to first MIXERCONTROL array
} MIXERLINECONTROLSW;
#ifdef UNICODE
typedef MIXERLINECONTROLSW MIXERLINECONTROLS;
#else
typedef MIXERLINECONTROLSA MIXERLINECONTROLS;
#endif // UNICODE
typedef MIXERLINECONTROLSA *PMIXERLINECONTROLSA;
typedef MIXERLINECONTROLSW *PMIXERLINECONTROLSW;
#ifdef UNICODE
typedef PMIXERLINECONTROLSW PMIXERLINECONTROLS;
#else
typedef PMIXERLINECONTROLSA PMIXERLINECONTROLS;
#endif // UNICODE
typedef MIXERLINECONTROLSA     *LPMIXERLINECONTROLSA;
typedef MIXERLINECONTROLSW     *LPMIXERLINECONTROLSW;
#ifdef UNICODE
typedef LPMIXERLINECONTROLSW LPMIXERLINECONTROLS;
#else
typedef LPMIXERLINECONTROLSA LPMIXERLINECONTROLS;
#endif // UNICODE


MMRESULT APIENTRY mixerGetLineControlsA(HMIXEROBJ hmxobj, LPMIXERLINECONTROLSA pmxlc, DWORD fdwControls);
MMRESULT APIENTRY mixerGetLineControlsW(HMIXEROBJ hmxobj, LPMIXERLINECONTROLSW pmxlc, DWORD fdwControls);
#ifdef UNICODE
     mixerGetLineControls  mixerGetLineControlsW
#else
     mixerGetLineControls  mixerGetLineControlsA
#endif // !UNICODE



     MIXER_GETLINECONTROLSF_ALL          $00000000L
     MIXER_GETLINECONTROLSF_ONEBYID      $00000001L
     MIXER_GETLINECONTROLSF_ONEBYTYPE    $00000002L

     MIXER_GETLINECONTROLSF_QUERYMASK    $0000000FL


typedef struct tMIXERCONTROLDETAILS
{
    DWORD           cbStruct;       // size in bytes of MIXERCONTROLDETAILS
    DWORD           dwControlID;    // control id to get/set details on

    DWORD           cChannels;      // number of channels in paDetails array

    union
    {
        HWND        hwndOwner;      // for MIXER_SETCONTROLDETAILSF_CUSTOM
        DWORD       cMultipleItems; // if _MULTIPLE, the number of items per channel
    } _UNION_NAME(u);
    DWORD           cbDetails;      // size of _one_ details_XX struct
    LPVOID          paDetails;      // pointer to array of details_XX structs

} MIXERCONTROLDETAILS, *PMIXERCONTROLDETAILS,     *LPMIXERCONTROLDETAILS;


/* */
/*  MIXER_GETCONTROLDETAILSF_LISTTEXT */
/* */
/* */
typedef struct tMIXERCONTROLDETAILS_LISTTEXTA
{
    DWORD           dwParam1;
    DWORD           dwParam2;
    CHAR            szName[MIXER_LONG_NAME_CHARS];
}       MIXERCONTROLDETAILS_LISTTEXTA;
/* */
/*  MIXER_GETCONTROLDETAILSF_LISTTEXT */
/* */
/* */
typedef struct tMIXERCONTROLDETAILS_LISTTEXTW
{
    DWORD           dwParam1;
    DWORD           dwParam2;
    WCHAR           szName[MIXER_LONG_NAME_CHARS];
}       MIXERCONTROLDETAILS_LISTTEXTW;
#ifdef UNICODE
typedef MIXERCONTROLDETAILS_LISTTEXTW MIXERCONTROLDETAILS_LISTTEXT;
#else
typedef MIXERCONTROLDETAILS_LISTTEXTA MIXERCONTROLDETAILS_LISTTEXT;
#endif // UNICODE
typedef MIXERCONTROLDETAILS_LISTTEXTA *PMIXERCONTROLDETAILS_LISTTEXTA;
typedef MIXERCONTROLDETAILS_LISTTEXTW *PMIXERCONTROLDETAILS_LISTTEXTW;
#ifdef UNICODE
typedef PMIXERCONTROLDETAILS_LISTTEXTW PMIXERCONTROLDETAILS_LISTTEXT;
#else
typedef PMIXERCONTROLDETAILS_LISTTEXTA PMIXERCONTROLDETAILS_LISTTEXT;
#endif // UNICODE
typedef MIXERCONTROLDETAILS_LISTTEXTA     *LPMIXERCONTROLDETAILS_LISTTEXTA;
typedef MIXERCONTROLDETAILS_LISTTEXTW     *LPMIXERCONTROLDETAILS_LISTTEXTW;
#ifdef UNICODE
typedef LPMIXERCONTROLDETAILS_LISTTEXTW LPMIXERCONTROLDETAILS_LISTTEXT;
#else
typedef LPMIXERCONTROLDETAILS_LISTTEXTA LPMIXERCONTROLDETAILS_LISTTEXT;
#endif // UNICODE


/* */
/*  MIXER_GETCONTROLDETAILSF_VALUE */
/* */
/* */
typedef struct tMIXERCONTROLDETAILS_BOOLEAN
{
    LONG            fValue;
}       MIXERCONTROLDETAILS_BOOLEAN,
      *PMIXERCONTROLDETAILS_BOOLEAN,
     *LPMIXERCONTROLDETAILS_BOOLEAN;

typedef struct tMIXERCONTROLDETAILS_SIGNED
{
    LONG            lValue;
}       MIXERCONTROLDETAILS_SIGNED,
      *PMIXERCONTROLDETAILS_SIGNED,
     *LPMIXERCONTROLDETAILS_SIGNED;


typedef struct tMIXERCONTROLDETAILS_UNSIGNED
{
    DWORD           dwValue;
}       MIXERCONTROLDETAILS_UNSIGNED,
      *PMIXERCONTROLDETAILS_UNSIGNED,
     *LPMIXERCONTROLDETAILS_UNSIGNED;


MMRESULT APIENTRY mixerGetControlDetailsA(HMIXEROBJ hmxobj, LPMIXERCONTROLDETAILS pmxcd, DWORD fdwDetails);
MMRESULT APIENTRY mixerGetControlDetailsW(HMIXEROBJ hmxobj, LPMIXERCONTROLDETAILS pmxcd, DWORD fdwDetails);
#ifdef UNICODE
     mixerGetControlDetails  mixerGetControlDetailsW
#else
     mixerGetControlDetails  mixerGetControlDetailsA
#endif // !UNICODE

     MIXER_GETCONTROLDETAILSF_VALUE      $00000000L
     MIXER_GETCONTROLDETAILSF_LISTTEXT   $00000001L

     MIXER_GETCONTROLDETAILSF_QUERYMASK  $0000000FL


MMRESULT APIENTRY mixerSetControlDetails(HMIXEROBJ hmxobj, LPMIXERCONTROLDETAILS pmxcd, DWORD fdwDetails);

     MIXER_SETCONTROLDETAILSF_VALUE      $00000000L
     MIXER_SETCONTROLDETAILSF_CUSTOM     $00000001L

     MIXER_SETCONTROLDETAILSF_QUERYMASK  $0000000FL

#endif // ifndef MMNOMIXER



#ifndef MMNOTIMER
/****************************************************************************

                            Timer support

****************************************************************************/

/* timer error return values */
     TIMERR_NOERROR        (0)                  // no error
     TIMERR_NOCANDO        (TIMERR_BASE+1)      // request not completed
     TIMERR_STRUCT         (TIMERR_BASE+33)     // time struct size

/* timer data types */
typedef VOID (CALLBACK TIMECALLBACK)(UINT uTimerID, UINT uMsg, DWORD dwUser, DWORD dw1, DWORD dw2);
typedef TIMECALLBACK     *LPTIMECALLBACK;


/* flags for wFlags parameter of timeSetEvent() function */
     TIME_ONESHOT              $00000000   // program timer for single event
     TIME_PERIODIC             $00000001   // program for continuous periodic event

     TIME_CALLBACK_FUNCTION    $00000000   // callback is function
     TIME_CALLBACK_EVENT_SET   $00000010   // callback is event - use SetEvent
     TIME_CALLBACK_EVENT_PULSE $00000020   // callback is event - use PulseEvent

/* timer device capabilities data structure */
typedef struct timecaps_tag {
    UINT    wPeriodMin;     // minimum period supported
    UINT    wPeriodMax;     // maximum period supported
} TIMECAPS;
typedef TIMECAPS       *PTIMECAPS;
typedef TIMECAPS      *NPTIMECAPS;
typedef TIMECAPS      *LPTIMECAPS;

/* timer function prototypes */
MMRESULT APIENTRY timeGetSystemTime(LPMMTIME lpmmt, UINT cbmmt);
DWORD APIENTRY timeGetTime(VOID);
UINT APIENTRY timeSetEvent(UINT uDelay, UINT uResolution,
    LPTIMECALLBACK lpFunction, DWORD dwUser, UINT uFlags);
MMRESULT APIENTRY timeKillEvent(UINT uTimerID);
MMRESULT APIENTRY timeGetDevCaps(LPTIMECAPS lptc, UINT cbtc);
MMRESULT APIENTRY timeBeginPeriod(UINT uPeriod);
MMRESULT APIENTRY timeEndPeriod(UINT uPeriod);

#endif  //ifndef MMNOTIMER


#ifndef MMNOJOY
/****************************************************************************

                            Joystick support

****************************************************************************/

/* joystick error return values */
     JOYERR_NOERROR        (0)                  // no error
     JOYERR_PARMS          (JOYERR_BASE+5)      // bad parameters
     JOYERR_NOCANDO        (JOYERR_BASE+6)      // request not completed
     JOYERR_UNPLUGGED      (JOYERR_BASE+7)      // joystick is unplugged

/* constants used with JOYINFO structure and MM_JOY* messages */
     JOY_BUTTON1         $0001
     JOY_BUTTON2         $0002
     JOY_BUTTON3         $0004
     JOY_BUTTON4         $0008
     JOY_BUTTON1CHG      $0100
     JOY_BUTTON2CHG      $0200
     JOY_BUTTON3CHG      $0400
     JOY_BUTTON4CHG      $0800

/* joystick ID constants */
     JOYSTICKID1         0
     JOYSTICKID2         1

/* joystick device capabilities data structure */
typedef struct tagJOYCAPSA {
    WORD    wMid;                  // manufacturer ID
    WORD    wPid;                  // product ID
    CHAR    szPname[MAXPNAMELEN];  // product name (NULL terminated string)
    UINT    wXmin;                 // minimum x position value
    UINT    wXmax;                 // maximum x position value
    UINT    wYmin;                 // minimum y position value
    UINT    wYmax;                 // maximum y position value
    UINT    wZmin;                 // minimum z position value
    UINT    wZmax;                 // maximum z position value
    UINT    wNumButtons;           // number of buttons
    UINT    wPeriodMin;            // minimum message period when captured
    UINT    wPeriodMax;            // maximum message period when captured
} JOYCAPSA;
/* joystick device capabilities data structure */
typedef struct tagJOYCAPSW {
    WORD    wMid;                  // manufacturer ID
    WORD    wPid;                  // product ID
    WCHAR   szPname[MAXPNAMELEN];  // product name (NULL terminated string)
    UINT    wXmin;                 // minimum x position value
    UINT    wXmax;                 // maximum x position value
    UINT    wYmin;                 // minimum y position value
    UINT    wYmax;                 // maximum y position value
    UINT    wZmin;                 // minimum z position value
    UINT    wZmax;                 // maximum z position value
    UINT    wNumButtons;           // number of buttons
    UINT    wPeriodMin;            // minimum message period when captured
    UINT    wPeriodMax;            // maximum message period when captured
} JOYCAPSW;
#ifdef UNICODE
typedef JOYCAPSW JOYCAPS;
#else
typedef JOYCAPSA JOYCAPS;
#endif // UNICODE
typedef JOYCAPSA      *PJOYCAPSA;
typedef JOYCAPSW      *PJOYCAPSW;
#ifdef UNICODE
typedef PJOYCAPSW PJOYCAPS;
#else
typedef PJOYCAPSA PJOYCAPS;
#endif // UNICODE
typedef JOYCAPSA      *NPJOYCAPSA;
typedef JOYCAPSW      *NPJOYCAPSW;
#ifdef UNICODE
typedef NPJOYCAPSW NPJOYCAPS;
#else
typedef NPJOYCAPSA NPJOYCAPS;
#endif // UNICODE
typedef JOYCAPSA      *LPJOYCAPSA;
typedef JOYCAPSW      *LPJOYCAPSW;
#ifdef UNICODE
typedef LPJOYCAPSW LPJOYCAPS;
#else
typedef LPJOYCAPSA LPJOYCAPS;
#endif // UNICODE

/* joystick information data structure */
typedef struct joyinfo_tag {
    UINT wXpos;                 // x position
    UINT wYpos;                 // y position
    UINT wZpos;                 // z position
    UINT wButtons;              // button states
} JOYINFO;
typedef JOYINFO       *PJOYINFO;
typedef JOYINFO      *NPJOYINFO;
typedef JOYINFO      *LPJOYINFO;

/* joystick function prototypes */
UINT     APIENTRY joyGetNumDevs(VOID);
MMRESULT APIENTRY joyGetDevCapsA(UINT uJoyId, LPJOYCAPSA lpjc, UINT cbjc);
MMRESULT APIENTRY joyGetDevCapsW(UINT uJoyId, LPJOYCAPSW lpjc, UINT cbjc);
#ifdef UNICODE
     joyGetDevCaps  joyGetDevCapsW
#else
     joyGetDevCaps  joyGetDevCapsA
#endif // !UNICODE
MMRESULT APIENTRY joyGetPos(UINT uJoyID, LPJOYINFO lpji);
MMRESULT APIENTRY joyGetThreshold(UINT uJoyID, LPUINT lpuThreshold);
MMRESULT APIENTRY joyReleaseCapture(UINT uJoyID);
MMRESULT APIENTRY joySetCapture(HWND hwnd, UINT uJoyID, UINT uPeriod,
    BOOL fChanged);
MMRESULT APIENTRY joySetThreshold(UINT uJoyID, UINT uThreshold);


#endif  //ifndef MMNOJOY

#ifndef MMNOMMIO
/****************************************************************************

                        Multimedia File I/O support

****************************************************************************/

/* MMIO error return values */
     MMIOERR_BASE            256
     MMIOERR_FILENOTFOUND     (MMIOERR_BASE + 1)  // file not found
     MMIOERR_OUTOFMEMORY      (MMIOERR_BASE + 2)  // out of memory
     MMIOERR_CANNOTOPEN       (MMIOERR_BASE + 3)  // cannot open
     MMIOERR_CANNOTCLOSE      (MMIOERR_BASE + 4)  // cannot close
     MMIOERR_CANNOTREAD       (MMIOERR_BASE + 5)  // cannot read
     MMIOERR_CANNOTWRITE      (MMIOERR_BASE + 6)  // cannot write
     MMIOERR_CANNOTSEEK       (MMIOERR_BASE + 7)  // cannot seek
     MMIOERR_CANNOTEXPAND     (MMIOERR_BASE + 8)  // cannot expand file
     MMIOERR_CHUNKNOTFOUND    (MMIOERR_BASE + 9)  // chunk not found
     MMIOERR_UNBUFFERED       (MMIOERR_BASE + 10) // file is unbuffered
     MMIOERR_PATHNOTFOUND     (MMIOERR_BASE + 11) // path incorrect
     MMIOERR_ACCESSDENIED     (MMIOERR_BASE + 12) // file was protected
     MMIOERR_SHARINGVIOLATION (MMIOERR_BASE + 13) // file in use
     MMIOERR_NETWORKERROR     (MMIOERR_BASE + 14) // network not responding
     MMIOERR_TOOMANYOPENFILES (MMIOERR_BASE + 15) // no more file handles
     MMIOERR_INVALIDFILE      (MMIOERR_BASE + 16) // default error file error

/* MMIO constants */
     CFSEPCHAR       '+'             // compound file name separator char.

/* MMIO data types */
typedef DWORD           FOURCC;         // a four character code
typedef LPSTR           HPSTR;          // a huge version of LPSTR
typedef LPCSTR          HPCSTR;         // a huge version of LPCSTR
typedef HANDLE          HMMIO;          // a handle to an open file
typedef LRESULT (CALLBACK MMIOPROC)(LPSTR lpmmioinfo, UINT uMsg,
            LPARAM lParam1, LPARAM lParam2);
typedef MMIOPROC     *LPMMIOPROC;

/* general MMIO information data structure */
typedef struct _MMIOINFO        // The MMIO state
{
        /* general fields */
        DWORD           dwFlags;        // general status flags
        FOURCC          fccIOProc;      // 4 char id for the I/O procedure
        LPMMIOPROC      pIOProc;        // pointer to I/O procedure
        UINT            wErrorRet;      // place for error to be returned
        HTASK           htask;          // alternate local task

        /* fields maintained by MMIO functions during buffered I/O */
        LONG            cchBuffer;      // size of I/O buffer (or 0L)
        HPSTR           pchBuffer;      // start of I/O buffer (or NULL)
        HPSTR           pchNext;        // pointer to next byte to read/write
        HPSTR           pchEndRead;     // pointer to last valid byte to read
        HPSTR           pchEndWrite;    // pointer to last byte to write
        LONG            lBufOffset;     // disk offset of start of buffer

        /* fields maintained by I/O procedure */
        LONG            lDiskOffset;    // disk offset of next read or write
        DWORD           adwInfo[3];     // data specific to type of MMIOPROC

        /* other fields maintained by MMIO */
        DWORD           dwReserved1;    // reserved for MMIO use
        DWORD           dwReserved2;    // reserved for MMIO use
        HMMIO           hmmio;          // handle to open file

} MMIOINFO;
typedef MMIOINFO       *PMMIOINFO;
typedef MMIOINFO      *NPMMIOINFO;
typedef MMIOINFO      *LPMMIOINFO;
typedef CONST MMIOINFO *LPCMMIOINFO;

/* RIFF chunk information data structure */
typedef struct MMCKINFO_tag      // structure for representing RIFF chunk info.
{
        FOURCC          ckid;           // chunk ID
        DWORD           cksize;         // chunk size
        FOURCC          fccType;        // form type or list type
        DWORD           dwDataOffset;   // offset of data portion of chunk
        DWORD           dwFlags;        // flags used by MMIO functions
} MMCKINFO;
typedef MMCKINFO       *PMMCKINFO;
typedef MMCKINFO      *NPMMCKINFO;
typedef MMCKINFO      *LPMMCKINFO;
typedef CONST MMCKINFO *LPCMMCKINFO;

/* bit field masks */
/* <dwFlags> field of MMIOINFO structure -- many same as OpenFile() flags */
/* Low word of flags will be passed to OpenFile() -- therefore, any MMIO-
    specific flags should be in the high word.  */
     MMIO_RWMODE     $00000003      // mask to get bits used for opening
                                        // file for reading/writing/both
     MMIO_SHAREMODE  $00000070      // file sharing mode number

/* constants for dwFlags field of MMIOINFO */
     MMIO_CREATE     $00001000      // create new file (or truncate file)
     MMIO_PARSE      $00000100      // parse new file returning path
     MMIO_DELETE     $00000200      // create new file (or truncate file)
     MMIO_EXIST      $00004000      // checks for existence of file
     MMIO_ALLOCBUF   $00010000      // mmioOpen() should allocate a buffer
     MMIO_GETTEMP    $00020000      // mmioOpen() should retrieve temp name

     MMIO_DIRTY      $10000000      // I/O buffer is dirty
/* MMIO_DIRTY is also used in the <dwFlags> field of MMCKINFO structure */


/* read/write mode numbers (bit field MMIO_RWMODE) */
     MMIO_READ       $00000000      // open file for reading only
     MMIO_WRITE      $00000001      // open file for writing only
     MMIO_READWRITE  $00000002      // open file for reading and writing

/* share mode numbers (bit field MMIO_SHAREMODE) */
     MMIO_COMPAT     $00000000      // compatibility mode
     MMIO_EXCLUSIVE  $00000010      // exclusive-access mode
     MMIO_DENYWRITE  $00000020      // deny writing to other processes
     MMIO_DENYREAD   $00000030      // deny reading to other processes
     MMIO_DENYNONE   $00000040      // deny nothing to other processes

/* flags for other functions */
     MMIO_FHOPEN             $0010  // mmioClose: keep file handle open
     MMIO_EMPTYBUF           $0010  // mmioFlush: empty the I/O buffer
     MMIO_TOUPPER            $0010  // mmioStringToFOURCC: cvt. to u-case
     MMIO_INSTALLPROC    $00010000  // mmioInstallIOProc: install MMIOProc
     MMIO_GLOBALPROC     $10000000  // mmioInstallIOProc: install globally
     MMIO_REMOVEPROC     $00020000  // mmioInstallIOProc:   remove MMIOProc
     MMIO_UNICODEPROC    $01000000  // mmioInstallIOProc: Unicode MMIOProc

     MMIO_FINDPROC       $00040000  // mmioInstallIOProc: find an MMIOProc
     MMIO_FINDCHUNK          $0010  // mmioDescend: find a chunk by ID
     MMIO_FINDRIFF           $0020  // mmioDescend: find a LIST chunk
     MMIO_FINDLIST           $0040  // mmioDescend: find a RIFF chunk
     MMIO_CREATERIFF         $0020  // mmioCreateChunk: make a LIST chunk
     MMIO_CREATELIST         $0040  // mmioCreateChunk: make a RIFF chunk


/* message numbers for MMIOPROC I/O procedure functions */
     MMIOM_READ      MMIO_READ       // read (must equal MMIO_READ!)
     MMIOM_WRITE    MMIO_WRITE       // write (must equal MMIO_WRITE!)
     MMIOM_SEEK              2       // seek to a new position in file
     MMIOM_OPEN              3       // open file
     MMIOM_CLOSE             4       // close file
     MMIOM_WRITEFLUSH        5       // write and flush
     MMIOM_RENAME            6       // rename specified file

     MMIOM_USER         $8000       // beginning of user-defined messages

/* standard four character codes */
     FOURCC_RIFF     mmioFOURCC('R', 'I', 'F', 'F')
     FOURCC_LIST     mmioFOURCC('L', 'I', 'S', 'T')

/* four character codes used to identify standard built-in I/O procedures */
     FOURCC_DOS      mmioFOURCC('D', 'O', 'S', ' ')
     FOURCC_MEM      mmioFOURCC('M', 'E', 'M', ' ')

/* flags for mmioSeek() */
#ifndef SEEK_SET
     SEEK_SET        0               // seek to an absolute position
     SEEK_CUR        1               // seek relative to current position
     SEEK_END        2               // seek relative to end of file
#endif  //ifndef SEEK_SET

/* other constants */
     MMIO_DEFAULTBUFFER      8192    // default buffer size

/* MMIO macros */

     mmioFOURCC( ch0, ch1, ch2, ch3 )                                \
                ( (DWORD)(BYTE)(ch0) | ( (DWORD)(BYTE)(ch1) << 8 ) |    \
                ( (DWORD)(BYTE)(ch2) << 16 ) | ( (DWORD)(BYTE)(ch3) << 24 ) )
/* This macro is machine byte-sex and word-sex dependent!! */
/* The characters are BYTES, so compatible with ANSI, not at all with UNICODE */

/* MMIO function prototypes */
FOURCC APIENTRY mmioStringToFOURCCA(LPCSTR sz, UINT uFlags);
/* MMIO function prototypes */
FOURCC APIENTRY mmioStringToFOURCCW(LPCWSTR sz, UINT uFlags);
#ifdef UNICODE
     mmioStringToFOURCC  mmioStringToFOURCCW
#else
     mmioStringToFOURCC  mmioStringToFOURCCA
#endif // !UNICODE

LPMMIOPROC APIENTRY mmioInstallIOProcA( FOURCC fccIOProc, LPMMIOPROC pIOProc,
                                        DWORD dwFlags);
LPMMIOPROC APIENTRY mmioInstallIOProcW( FOURCC fccIOProc, LPMMIOPROC pIOProc,
                                        DWORD dwFlags);
#ifdef UNICODE
     mmioInstallIOProc  mmioInstallIOProcW
#else
     mmioInstallIOProc  mmioInstallIOProcA
#endif // !UNICODE

HMMIO APIENTRY mmioOpenA( LPSTR szFileName, LPMMIOINFO lpmmioinfo, DWORD fdwOpen);
HMMIO APIENTRY mmioOpenW( LPWSTR szFileName, LPMMIOINFO lpmmioinfo, DWORD fdwOpen);
#ifdef UNICODE
     mmioOpen  mmioOpenW
#else
     mmioOpen  mmioOpenA
#endif // !UNICODE

MMRESULT APIENTRY mmioRenameA ( LPCSTR szFileName, LPCSTR szNewFileName,
                               LPCMMIOINFO lpmmioinfo, DWORD fdwRename);
MMRESULT APIENTRY mmioRenameW ( LPCWSTR szFileName, LPCWSTR szNewFileName,
                               LPCMMIOINFO lpmmioinfo, DWORD fdwRename);
#ifdef UNICODE
     mmioRename  mmioRenameW
#else
     mmioRename  mmioRenameA
#endif // !UNICODE

MMRESULT APIENTRY mmioClose(HMMIO hmmio, UINT fuClose);
LRESULT APIENTRY mmioRead(HMMIO hmmio, HPSTR pch, LONG cch);
LRESULT APIENTRY mmioWrite(HMMIO hmmio, HPCSTR pch, LONG cch);
LRESULT APIENTRY mmioSeek(HMMIO hmmio, LONG lOffset, int iOrigin);
MMRESULT APIENTRY mmioGetInfo(HMMIO hmmio, LPMMIOINFO lpmmioinfo, UINT fuInfo);
MMRESULT APIENTRY mmioSetInfo(HMMIO hmmio, LPCMMIOINFO lpmmioinfo, UINT fuInfo);
MMRESULT APIENTRY mmioSetBuffer( HMMIO hmmio, LPSTR pchBuffer, LONG cchBuffer,
    UINT fuBuffer);
MMRESULT APIENTRY mmioFlush(HMMIO hmmio, UINT fuFlush);
MMRESULT APIENTRY mmioAdvance(HMMIO hmmio, LPMMIOINFO lpmmioinfo, UINT fuAdvance);

LRESULT APIENTRY mmioSendMessage( HMMIO hmmio, UINT uMsg,
    LPARAM lParam1, LPARAM lParam2);
/* RIFF I/O prototypes */
MMRESULT APIENTRY mmioDescend(HMMIO hmmio, LPMMCKINFO lpmmcki,
    LPCMMCKINFO lpmmckiParent, UINT fuDescend);
MMRESULT APIENTRY mmioAscend(HMMIO hmmio, LPMMCKINFO lpmmcki, UINT fuAscend);
MMRESULT APIENTRY mmioCreateChunk(HMMIO hmmio, LPMMCKINFO lpmmcki, UINT fuCreate);

#endif  //ifndef MMNOMMIO


#ifndef MMNOMCI
/****************************************************************************

                            MCI support

****************************************************************************/

*)

TYPE
    MCIERROR=LONGWORD;
    MCIDEVICEID=LONGWORD;

(*
typedef UINT (CALLBACK *YIELDPROC)(MCIDEVICEID mciId, DWORD dwYieldData);

/*--------------------------------------------------------------------*\
                       MCI function prototypes
\*--------------------------------------------------------------------*/

MCIERROR APIENTRY mciSendCommandA(
    MCIDEVICEID mciId,
    UINT uMessage,
    DWORD dwParam1,
    DWORD dwParam2 );
MCIERROR APIENTRY mciSendCommandW(
    MCIDEVICEID mciId,
    UINT uMessage,
    DWORD dwParam1,
    DWORD dwParam2 );
#ifdef UNICODE
     mciSendCommand  mciSendCommandW
#else
     mciSendCommand  mciSendCommandA
#endif // !UNICODE

#ifdef UNICODE
     mciGetDeviceID  mciGetDeviceIDW
#else
     mciGetDeviceID  mciGetDeviceIDA
#endif // !UNICODE

MCIDEVICEID APIENTRY mciGetDeviceIDFromElementIDA(
    DWORD dwElementID,
    LPCSTR lpstrType );
MCIDEVICEID APIENTRY mciGetDeviceIDFromElementIDW(
    DWORD dwElementID,
    LPCWSTR lpstrType );
#ifdef UNICODE
     mciGetDeviceIDFromElementID  mciGetDeviceIDFromElementIDW
#else
     mciGetDeviceIDFromElementID  mciGetDeviceIDFromElementIDA
#endif // !UNICODE


BOOL APIENTRY mciSetYieldProc(MCIDEVICEID mciId, YIELDPROC fpYieldProc,
    DWORD dwYieldData);

HANDLE APIENTRY mciGetCreatorTask(MCIDEVICEID mciId);
YIELDPROC APIENTRY mciGetYieldProc(MCIDEVICEID mciId, LPDWORD pdwYieldData);
*)

CONST
     MCIERR_INVALID_DEVICE_ID        =(MCIERR_BASE + 1);
     MCIERR_UNRECOGNIZED_KEYWORD     =(MCIERR_BASE + 3);
     MCIERR_UNRECOGNIZED_COMMAND     =(MCIERR_BASE + 5);
     MCIERR_HARDWARE                 =(MCIERR_BASE + 6);
     MCIERR_INVALID_DEVICE_NAME      =(MCIERR_BASE + 7);
     MCIERR_OUT_OF_MEMORY            =(MCIERR_BASE + 8);
     MCIERR_DEVICE_OPEN              =(MCIERR_BASE + 9);
     MCIERR_CANNOT_LOAD_DRIVER       =(MCIERR_BASE + 10);
     MCIERR_MISSING_COMMAND_STRING   =(MCIERR_BASE + 11);
     MCIERR_PARAM_OVERFLOW           =(MCIERR_BASE + 12);
     MCIERR_MISSING_STRING_ARGUMENT  =(MCIERR_BASE + 13);
     MCIERR_BAD_INTEGER              =(MCIERR_BASE + 14);
     MCIERR_PARSER_INTERNAL          =(MCIERR_BASE + 15);
     MCIERR_DRIVER_INTERNAL          =(MCIERR_BASE + 16);
     MCIERR_MISSING_PARAMETER        =(MCIERR_BASE + 17);
     MCIERR_UNSUPPORTED_FUNCTION     =(MCIERR_BASE + 18);
     MCIERR_FILE_NOT_FOUND           =(MCIERR_BASE + 19);
     MCIERR_DEVICE_NOT_READY         =(MCIERR_BASE + 20);
     MCIERR_INTERNAL                 =(MCIERR_BASE + 21);
     MCIERR_DRIVER                   =(MCIERR_BASE + 22);
     MCIERR_CANNOT_USE_ALL           =(MCIERR_BASE + 23);
     MCIERR_MULTIPLE                 =(MCIERR_BASE + 24);
     MCIERR_EXTENSION_NOT_FOUND      =(MCIERR_BASE + 25);
     MCIERR_OUTOFRANGE               =(MCIERR_BASE + 26);
     MCIERR_FLAGS_NOT_COMPATIBLE     =(MCIERR_BASE + 28);
     MCIERR_FILE_NOT_SAVED           =(MCIERR_BASE + 30);
     MCIERR_DEVICE_TYPE_REQUIRED     =(MCIERR_BASE + 31);
     MCIERR_DEVICE_LOCKED            =(MCIERR_BASE + 32);
     MCIERR_DUPLICATE_ALIAS          =(MCIERR_BASE + 33);
     MCIERR_BAD_CONSTANT             =(MCIERR_BASE + 34);
     MCIERR_MUST_USE_SHAREABLE       =(MCIERR_BASE + 35);
     MCIERR_MISSING_DEVICE_NAME      =(MCIERR_BASE + 36);
     MCIERR_BAD_TIME_FORMAT          =(MCIERR_BASE + 37);
     MCIERR_NO_CLOSING_QUOTE         =(MCIERR_BASE + 38);
     MCIERR_DUPLICATE_FLAGS          =(MCIERR_BASE + 39);
     MCIERR_INVALID_FILE             =(MCIERR_BASE + 40);
     MCIERR_NULL_PARAMETER_BLOCK     =(MCIERR_BASE + 41);
     MCIERR_UNNAMED_RESOURCE         =(MCIERR_BASE + 42);
     MCIERR_NEW_REQUIRES_ALIAS       =(MCIERR_BASE + 43);
     MCIERR_NOTIFY_ON_AUTO_OPEN      =(MCIERR_BASE + 44);
     MCIERR_NO_ELEMENT_ALLOWED       =(MCIERR_BASE + 45);
     MCIERR_NONAPPLICABLE_FUNCTION   =(MCIERR_BASE + 46);
     MCIERR_ILLEGAL_FOR_AUTO_OPEN    =(MCIERR_BASE + 47);
     MCIERR_FILENAME_REQUIRED        =(MCIERR_BASE + 48);
     MCIERR_EXTRA_CHARACTERS         =(MCIERR_BASE + 49);
     MCIERR_DEVICE_NOT_INSTALLED     =(MCIERR_BASE + 50);
     MCIERR_GET_CD                   =(MCIERR_BASE + 51);
     MCIERR_SET_CD                   =(MCIERR_BASE + 52);
     MCIERR_SET_DRIVE                =(MCIERR_BASE + 53);
     MCIERR_DEVICE_LENGTH            =(MCIERR_BASE + 54);
     MCIERR_DEVICE_ORD_LENGTH        =(MCIERR_BASE + 55);
     MCIERR_NO_INTEGER               =(MCIERR_BASE + 56);

     MCIERR_WAVE_OUTPUTSINUSE        =(MCIERR_BASE + 64);
     MCIERR_WAVE_SETOUTPUTINUSE      =(MCIERR_BASE + 65);
     MCIERR_WAVE_INPUTSINUSE         =(MCIERR_BASE + 66);
     MCIERR_WAVE_SETINPUTINUSE       =(MCIERR_BASE + 67);
     MCIERR_WAVE_OUTPUTUNSPECIFIED   =(MCIERR_BASE + 68);
     MCIERR_WAVE_INPUTUNSPECIFIED    =(MCIERR_BASE + 69);
     MCIERR_WAVE_OUTPUTSUNSUITABLE   =(MCIERR_BASE + 70);
     MCIERR_WAVE_SETOUTPUTUNSUITABLE =(MCIERR_BASE + 71);
     MCIERR_WAVE_INPUTSUNSUITABLE    =(MCIERR_BASE + 72);
     MCIERR_WAVE_SETINPUTUNSUITABLE  =(MCIERR_BASE + 73);

     MCIERR_SEQ_DIV_INCOMPATIBLE     =(MCIERR_BASE + 80);
     MCIERR_SEQ_PORT_INUSE           =(MCIERR_BASE + 81);
     MCIERR_SEQ_PORT_NONEXISTENT     =(MCIERR_BASE + 82);
     MCIERR_SEQ_PORT_MAPNODEVICE     =(MCIERR_BASE + 83);
     MCIERR_SEQ_PORT_MISCERROR       =(MCIERR_BASE + 84);
     MCIERR_SEQ_TIMER                =(MCIERR_BASE + 85);
     MCIERR_SEQ_PORTUNSPECIFIED      =(MCIERR_BASE + 86);
     MCIERR_SEQ_NOMIDIPRESENT        =(MCIERR_BASE + 87);

     MCIERR_NO_WINDOW                =(MCIERR_BASE + 90);
     MCIERR_CREATEWINDOW             =(MCIERR_BASE + 91);
     MCIERR_FILE_READ                =(MCIERR_BASE + 92);
     MCIERR_FILE_WRITE               =(MCIERR_BASE + 93);

     MCIERR_NO_IDENTITY              =(MCIERR_BASE + 94);

     MCIERR_CUSTOM_DRIVER_BASE       =(MCIERR_BASE + 256);

(*
/****************************************************************************
*          MCI command message identifiers
*****************************************************************************/
/* Message numbers are hard coded because the resource compiler */
/* will otherwise fail on the RCDATA command table in mmsystem.rc */

/* They must be in the range between MCI_FIRST and MCI_LAST */

     MCI_FIRST                       DRV_MCI_FIRST   // $0800
/* Messages $801 and $802 are reserved */
     MCI_OPEN                        $0803
     MCI_CLOSE                       $0804
     MCI_ESCAPE                      $0805
     MCI_PLAY                        $0806
     MCI_SEEK                        $0807
     MCI_STOP                        $0808
     MCI_PAUSE                       $0809
     MCI_INFO                        $080A
     MCI_GETDEVCAPS                  $080B
     MCI_SPIN                        $080C
     MCI_SET                         $080D
     MCI_STEP                        $080E
     MCI_RECORD                      $080F
     MCI_SYSINFO                     $0810
     MCI_BREAK                       $0811
     MCI_SOUND                       $0812
     MCI_SAVE                        $0813
     MCI_STATUS                      $0814

     MCI_CUE                         $0830

     MCI_REALIZE                     $0840
     MCI_WINDOW                      $0841
     MCI_PUT                         $0842
     MCI_WHERE                       $0843
     MCI_FREEZE                      $0844
     MCI_UNFREEZE                    $0845

     MCI_LOAD                        $0850
     MCI_CUT                         $0851
     MCI_COPY                        $0852
     MCI_PASTE                       $0853
     MCI_UPDATE                      $0854
     MCI_RESUME                      $0855
     MCI_DELETE                      $0856

     MCI_LAST                        $0FFF

/* the next $400 message ID's are reserved for custom drivers */
     MCI_USER_MESSAGES               ($400 + MCI_FIRST)

/* device ID for "all MCI devices" */
     MCI_ALL_DEVICE_ID               ((MCIDEVICEID)-1)
/****************************************************************************
*   Structures for the lpdwParams (dwParam2) of mciSendCommand for those
*   command messages that may be parsed in string form.
*****************************************************************************/




/* constants for predefined MCI device types */
/* The resource compiler will not accept the symbolic version. */
/* It doesn't like the parentheses.                            */
     MCI_DEVTYPE_VCR             513 /* (MCI_STRING_OFFSET + 1)  */
     MCI_DEVTYPE_VIDEODISC       514 /* (MCI_STRING_OFFSET + 2)  */
     MCI_DEVTYPE_OVERLAY         515 /* (MCI_STRING_OFFSET + 3)  */
     MCI_DEVTYPE_CD_AUDIO        516 /* (MCI_STRING_OFFSET + 4)  */
     MCI_DEVTYPE_DAT             517 /* (MCI_STRING_OFFSET + 5)  */
     MCI_DEVTYPE_SCANNER         518 /* (MCI_STRING_OFFSET + 6)  */
     MCI_DEVTYPE_ANIMATION       519 /* (MCI_STRING_OFFSET + 7)  */
     MCI_DEVTYPE_DIGITAL_VIDEO   520 /* (MCI_STRING_OFFSET + 8)  */
     MCI_DEVTYPE_OTHER           521 /* (MCI_STRING_OFFSET + 9)  */
     MCI_DEVTYPE_WAVEFORM_AUDIO  522 /* (MCI_STRING_OFFSET + 10) */
     MCI_DEVTYPE_SEQUENCER       523 /* (MCI_STRING_OFFSET + 11) */

     MCI_DEVTYPE_FIRST               MCI_DEVTYPE_VCR
     MCI_DEVTYPE_LAST                MCI_DEVTYPE_SEQUENCER


     MCI_DEVTYPE_FIRST_USER          $1000

/* return values for 'status mode' command */
     MCI_MODE_NOT_READY              (MCI_STRING_OFFSET + 12)
     MCI_MODE_STOP                   (MCI_STRING_OFFSET + 13)
     MCI_MODE_PLAY                   (MCI_STRING_OFFSET + 14)
     MCI_MODE_RECORD                 (MCI_STRING_OFFSET + 15)
     MCI_MODE_SEEK                   (MCI_STRING_OFFSET + 16)
     MCI_MODE_PAUSE                  (MCI_STRING_OFFSET + 17)
     MCI_MODE_OPEN                   (MCI_STRING_OFFSET + 18)

/* constants used in 'set time format' and 'status time format' commands */
/* These are not based on MCI_FORMATS_OFFSET because of resource */
/* compiler limitations */
     MCI_FORMAT_MILLISECONDS         0
     MCI_FORMAT_HMS                  1
     MCI_FORMAT_MSF                  2
     MCI_FORMAT_FRAMES               3
     MCI_FORMAT_SMPTE_24             4
     MCI_FORMAT_SMPTE_25             5
     MCI_FORMAT_SMPTE_30             6
     MCI_FORMAT_SMPTE_30DROP         7
     MCI_FORMAT_BYTES                8
     MCI_FORMAT_SAMPLES              9
     MCI_FORMAT_TMSF                 10

/* MCI time format conversion macros */
/* Note that these macros are byte-sex dependent as the SMPT format gives */
/* the layout in storage that's wanted. */
     MCI_MSF_MINUTE(msf)             ((BYTE)(msf))
     MCI_MSF_SECOND(msf)             ((BYTE)(((WORD)(msf)) >> 8))
     MCI_MSF_FRAME(msf)              ((BYTE)((msf)>>16))

     MCI_MAKE_MSF(m, s, f)           ((DWORD)(((BYTE)(m) | \
                                                  ((WORD)(s)<<8)) | \
                                                 (((DWORD)(BYTE)(f))<<16)))

     MCI_TMSF_TRACK(tmsf)            ((BYTE)(tmsf))
     MCI_TMSF_MINUTE(tmsf)           ((BYTE)(((WORD)(tmsf)) >> 8))
     MCI_TMSF_SECOND(tmsf)           ((BYTE)((tmsf)>>16))
     MCI_TMSF_FRAME(tmsf)            ((BYTE)((tmsf)>>24))

     MCI_MAKE_TMSF(t, m, s, f)       ( (DWORD)( ( (BYTE)(t)            \
                                                   | ( (WORD)(m) << 8 )   \
                                                   )                      \
                                                 | ( ( (DWORD)(BYTE)(s)   \
                                                     | ( (WORD)(f) <<8 )  \
                                                     )                    \
                                                   << 16                  \
                                                   )                      \
                                                 )                        \
                                        )

     MCI_HMS_HOUR(hms)               ((BYTE)(hms))
     MCI_HMS_MINUTE(hms)             ((BYTE)(((WORD)(hms)) >> 8))
     MCI_HMS_SECOND(hms)             ((BYTE)((hms)>>16))

     MCI_MAKE_HMS(h, m, s)           ( (DWORD)( ( (BYTE)(h)            \
                                                   | ( (WORD)(m) <<8 )    \
                                                   )                      \
                                                 | ( ( (DWORD)(BYTE)(s) ) \
                                                   <<16                   \
                                                   )                      \
                                                 )                        \
                                        )

*)
CONST
     MCI_NOTIFY_SUCCESSFUL           =$0001;
     MCI_NOTIFY_SUPERSEDED           =$0002;
     MCI_NOTIFY_ABORTED              =$0004;
     MCI_NOTIFY_FAILURE              =$0008;

(*
/* NOTE: All flags must have an "L" suffix in order to be parsed as */
/* DWORDs by the resource compiler */

/* common flags for dwFlags parameter of MCI command messages */
     MCI_NOTIFY                      $00000001L
     MCI_WAIT                        $00000002L
     MCI_FROM                        $00000004L
     MCI_TO                          $00000008L
     MCI_TRACK                       $00000010L

/* flags for dwFlags parameter of MCI_OPEN command message */
     MCI_OPEN_SHAREABLE              $00000100L
     MCI_OPEN_ELEMENT                $00000200L
     MCI_OPEN_ALIAS                  $00000400L
     MCI_OPEN_ELEMENT_ID             $00000800L
     MCI_OPEN_TYPE_ID                $00001000L
     MCI_OPEN_TYPE                   $00002000L

/* flags for dwFlags parameter of MCI_SEEK command message */
     MCI_SEEK_TO_START               $00000100L
     MCI_SEEK_TO_END                 $00000200L

/* flags for dwFlags parameter of MCI_STATUS command message */
     MCI_STATUS_ITEM                 $00000100L
     MCI_STATUS_START                $00000200L

/* flags for dwItem field of the MCI_STATUS_PARMS parameter block */
     MCI_STATUS_LENGTH               $00000001L
     MCI_STATUS_POSITION             $00000002L
     MCI_STATUS_NUMBER_OF_TRACKS     $00000003L
     MCI_STATUS_MODE                 $00000004L
     MCI_STATUS_MEDIA_PRESENT        $00000005L
     MCI_STATUS_TIME_FORMAT          $00000006L
     MCI_STATUS_READY                $00000007L
     MCI_STATUS_CURRENT_TRACK        $00000008L


/* flags for dwFlags parameter of MCI_INFO command message */
     MCI_INFO_PRODUCT                $00000100L
     MCI_INFO_FILE                   $00000200L
     MCI_INFO_MEDIA_UPC              $00000400L
     MCI_INFO_MEDIA_IDENTITY         $00000800L

/* flags for dwFlags parameter of MCI_GETDEVCAPS command message */
     MCI_GETDEVCAPS_ITEM             $00000100L

/* flags for dwItem field of the MCI_GETDEVCAPS_PARMS parameter block */
     MCI_GETDEVCAPS_CAN_RECORD       $00000001L
     MCI_GETDEVCAPS_HAS_AUDIO        $00000002L
     MCI_GETDEVCAPS_HAS_VIDEO        $00000003L
     MCI_GETDEVCAPS_DEVICE_TYPE      $00000004L
     MCI_GETDEVCAPS_USES_FILES       $00000005L
     MCI_GETDEVCAPS_COMPOUND_DEVICE  $00000006L
     MCI_GETDEVCAPS_CAN_EJECT        $00000007L
     MCI_GETDEVCAPS_CAN_PLAY         $00000008L
     MCI_GETDEVCAPS_CAN_SAVE         $00000009L

/* flags for dwFlags parameter of MCI_SYSINFO command message */
     MCI_SYSINFO_QUANTITY            $00000100L
     MCI_SYSINFO_OPEN                $00000200L
     MCI_SYSINFO_NAME                $00000400L
     MCI_SYSINFO_INSTALLNAME         $00000800L

/* flags for dwFlags parameter of MCI_SET command message */
     MCI_SET_DOOR_OPEN               $00000100L
     MCI_SET_DOOR_CLOSED             $00000200L
     MCI_SET_TIME_FORMAT             $00000400L
     MCI_SET_AUDIO                   $00000800L
     MCI_SET_VIDEO                   $00001000L
     MCI_SET_ON                      $00002000L
     MCI_SET_OFF                     $00004000L

/* flags for dwAudio field of MCI_SET_PARMS or MCI_SEQ_SET_PARMS */
     MCI_SET_AUDIO_ALL               $00000000L
     MCI_SET_AUDIO_LEFT              $00000001L
     MCI_SET_AUDIO_RIGHT             $00000002L

/* flags for dwFlags parameter of MCI_BREAK command message */
     MCI_BREAK_KEY                   $00000100L
     MCI_BREAK_HWND                  $00000200L
     MCI_BREAK_OFF                   $00000400L

/* flags for dwFlags parameter of MCI_RECORD command message */
     MCI_RECORD_INSERT               $00000100L
     MCI_RECORD_OVERWRITE            $00000200L

/* flags for dwFlags parameter of MCI_SOUND command message */
     MCI_SOUND_NAME                  $00000100L

/* flags for dwFlags parameter of MCI_SAVE command message */
     MCI_SAVE_FILE                   $00000100L

/* flags for dwFlags parameter of MCI_LOAD command message */
     MCI_LOAD_FILE                   $00000100L

/* Note that some structures below do not have all the fields of the */
/* corresponding Win 3.1 structures.  Some reserved WORD sized fields */
/* have disappeared.  This is deliberate.  The structures are the same */
/* size (with one exception which is two bytes longer). */
/* */
/* The FIRST entry in each structure must be dwCallback.  A large union */
/* could be defined... but... */

/* generic parameter block for MCI command messages with no special parameters */
typedef struct tagMCI_GENERIC_PARMS {
    DWORD   dwCallback;
} MCI_GENERIC_PARMS;
typedef MCI_GENERIC_PARMS     *PMCI_GENERIC_PARMS;
typedef MCI_GENERIC_PARMS     *LPMCI_GENERIC_PARMS;

/* parameter block for MCI_OPEN command message */
typedef struct tagMCI_OPEN_PARMSA {
    DWORD   dwCallback;
    MCIDEVICEID wDeviceID;
    LPCSTR     lpstrDeviceType;
    LPCSTR     lpstrElementName;
    LPCSTR     lpstrAlias;
} MCI_OPEN_PARMSA;
/* parameter block for MCI_OPEN command message */
typedef struct tagMCI_OPEN_PARMSW {
    DWORD   dwCallback;
    MCIDEVICEID wDeviceID;
    LPCWSTR    lpstrDeviceType;
    LPCWSTR    lpstrElementName;
    LPCWSTR    lpstrAlias;
} MCI_OPEN_PARMSW;
#ifdef UNICODE
typedef MCI_OPEN_PARMSW MCI_OPEN_PARMS;
#else
typedef MCI_OPEN_PARMSA MCI_OPEN_PARMS;
#endif // UNICODE
typedef MCI_OPEN_PARMSA     *PMCI_OPEN_PARMSA;
typedef MCI_OPEN_PARMSW     *PMCI_OPEN_PARMSW;
#ifdef UNICODE
typedef PMCI_OPEN_PARMSW PMCI_OPEN_PARMS;
#else
typedef PMCI_OPEN_PARMSA PMCI_OPEN_PARMS;
#endif // UNICODE
typedef MCI_OPEN_PARMSA     *LPMCI_OPEN_PARMSA;
typedef MCI_OPEN_PARMSW     *LPMCI_OPEN_PARMSW;
#ifdef UNICODE
typedef LPMCI_OPEN_PARMSW LPMCI_OPEN_PARMS;
#else
typedef LPMCI_OPEN_PARMSA LPMCI_OPEN_PARMS;
#endif // UNICODE

/* parameter block for MCI_PLAY command message */
typedef struct tagMCI_PLAY_PARMS {
    DWORD   dwCallback;
    DWORD   dwFrom;
    DWORD   dwTo;
} MCI_PLAY_PARMS;
typedef MCI_PLAY_PARMS     *PMCI_PLAY_PARMS;
typedef MCI_PLAY_PARMS     *LPMCI_PLAY_PARMS;

/* parameter block for MCI_SEEK command message */
typedef struct tagMCI_SEEK_PARMS {
    DWORD   dwCallback;
    DWORD   dwTo;
} MCI_SEEK_PARMS;
typedef MCI_SEEK_PARMS     *PMCI_SEEK_PARMS;
typedef MCI_SEEK_PARMS     *LPMCI_SEEK_PARMS;

/* parameter block for MCI_STATUS command message */
typedef struct tagMCI_STATUS_PARMS {
    DWORD   dwCallback;
    DWORD   dwReturn;
    DWORD   dwItem;
    DWORD   dwTrack;
} MCI_STATUS_PARMS;
typedef MCI_STATUS_PARMS     * PMCI_STATUS_PARMS;
typedef MCI_STATUS_PARMS     * LPMCI_STATUS_PARMS;

/* parameter block for MCI_INFO command message */
typedef struct tagMCI_INFO_PARMSA {
    DWORD   dwCallback;
    LPSTR   lpstrReturn;
    DWORD   dwRetSize;
} MCI_INFO_PARMSA;
/* parameter block for MCI_INFO command message */
typedef struct tagMCI_INFO_PARMSW {
    DWORD   dwCallback;
    LPWSTR  lpstrReturn;
    DWORD   dwRetSize;
} MCI_INFO_PARMSW;
#ifdef UNICODE
typedef MCI_INFO_PARMSW MCI_INFO_PARMS;
#else
typedef MCI_INFO_PARMSA MCI_INFO_PARMS;
#endif // UNICODE
typedef MCI_INFO_PARMSA     * PMCI_INFO_PARMSA;
typedef MCI_INFO_PARMSW     * PMCI_INFO_PARMSW;
#ifdef UNICODE
typedef PMCI_INFO_PARMSW PMCI_INFO_PARMS;
#else
typedef PMCI_INFO_PARMSA PMCI_INFO_PARMS;
#endif // UNICODE
typedef MCI_INFO_PARMSA     * LPMCI_INFO_PARMSA;
typedef MCI_INFO_PARMSW     * LPMCI_INFO_PARMSW;
#ifdef UNICODE
typedef LPMCI_INFO_PARMSW LPMCI_INFO_PARMS;
#else
typedef LPMCI_INFO_PARMSA LPMCI_INFO_PARMS;
#endif // UNICODE

/* parameter block for MCI_GETDEVCAPS command message */
typedef struct tagMCI_GETDEVCAPS_PARMS {
    DWORD   dwCallback;
    DWORD   dwReturn;
    DWORD   dwItem;
} MCI_GETDEVCAPS_PARMS;
typedef MCI_GETDEVCAPS_PARMS     * PMCI_GETDEVCAPS_PARMS;
typedef MCI_GETDEVCAPS_PARMS     * LPMCI_GETDEVCAPS_PARMS;

/* parameter block for MCI_SYSINFO command message */
typedef struct tagMCI_SYSINFO_PARMSA {
    DWORD   dwCallback;
    LPSTR   lpstrReturn;
    DWORD   dwRetSize;
    DWORD   dwNumber;
    UINT    wDeviceType;
} MCI_SYSINFO_PARMSA;
/* parameter block for MCI_SYSINFO command message */
typedef struct tagMCI_SYSINFO_PARMSW {
    DWORD   dwCallback;
    LPWSTR  lpstrReturn;
    DWORD   dwRetSize;
    DWORD   dwNumber;
    UINT    wDeviceType;
} MCI_SYSINFO_PARMSW;
#ifdef UNICODE
typedef MCI_SYSINFO_PARMSW MCI_SYSINFO_PARMS;
#else
typedef MCI_SYSINFO_PARMSA MCI_SYSINFO_PARMS;
#endif // UNICODE
typedef MCI_SYSINFO_PARMSA     *PMCI_SYSINFO_PARMSA;
typedef MCI_SYSINFO_PARMSW     *PMCI_SYSINFO_PARMSW;
#ifdef UNICODE
typedef PMCI_SYSINFO_PARMSW PMCI_SYSINFO_PARMS;
#else
typedef PMCI_SYSINFO_PARMSA PMCI_SYSINFO_PARMS;
#endif // UNICODE
typedef MCI_SYSINFO_PARMSA     *LPMCI_SYSINFO_PARMSA;
typedef MCI_SYSINFO_PARMSW     *LPMCI_SYSINFO_PARMSW;
#ifdef UNICODE
typedef LPMCI_SYSINFO_PARMSW LPMCI_SYSINFO_PARMS;
#else
typedef LPMCI_SYSINFO_PARMSA LPMCI_SYSINFO_PARMS;
#endif // UNICODE

/* parameter block for MCI_SET command message */
typedef struct tagMCI_SET_PARMS {
    DWORD   dwCallback;
    DWORD   dwTimeFormat;
    DWORD   dwAudio;
} MCI_SET_PARMS;
typedef MCI_SET_PARMS     *PMCI_SET_PARMS;
typedef MCI_SET_PARMS     *LPMCI_SET_PARMS;

/* parameter block for MCI_BREAK command message */
typedef struct tagMCI_BREAK_PARMS {
    DWORD   dwCallback;
    int     nVirtKey;
    HWND    hwndBreak;
} MCI_BREAK_PARMS;
typedef MCI_BREAK_PARMS     * PMCI_BREAK_PARMS;
typedef MCI_BREAK_PARMS     * LPMCI_BREAK_PARMS;

/* parameter block for MCI_SOUND command message */
typedef struct tagMCI_SOUND_PARMSA {
    DWORD   dwCallback;
    LPCSTR   lpstrSoundName;
} MCI_SOUND_PARMSA;
/* parameter block for MCI_SOUND command message */
typedef struct tagMCI_SOUND_PARMSW {
    DWORD   dwCallback;
    LPCWSTR  lpstrSoundName;
} MCI_SOUND_PARMSW;
#ifdef UNICODE
typedef MCI_SOUND_PARMSW MCI_SOUND_PARMS;
#else
typedef MCI_SOUND_PARMSA MCI_SOUND_PARMS;
#endif // UNICODE
typedef MCI_SOUND_PARMSA     *PMCI_SOUND_PARMSA;
typedef MCI_SOUND_PARMSW     *PMCI_SOUND_PARMSW;
#ifdef UNICODE
typedef PMCI_SOUND_PARMSW PMCI_SOUND_PARMS;
#else
typedef PMCI_SOUND_PARMSA PMCI_SOUND_PARMS;
#endif // UNICODE
typedef MCI_SOUND_PARMSA     *LPMCI_SOUND_PARMSA;
typedef MCI_SOUND_PARMSW     *LPMCI_SOUND_PARMSW;
#ifdef UNICODE
typedef LPMCI_SOUND_PARMSW LPMCI_SOUND_PARMS;
#else
typedef LPMCI_SOUND_PARMSA LPMCI_SOUND_PARMS;
#endif // UNICODE

/* parameter block for MCI_SAVE command message */
typedef struct tagMCI_SAVE_PARMSA {
    DWORD    dwCallback;
    LPCSTR    lpfilename;
} MCI_SAVE_PARMSA;
/* parameter block for MCI_SAVE command message */
typedef struct tagMCI_SAVE_PARMSW {
    DWORD    dwCallback;
    LPCWSTR   lpfilename;
} MCI_SAVE_PARMSW;
#ifdef UNICODE
typedef MCI_SAVE_PARMSW MCI_SAVE_PARMS;
#else
typedef MCI_SAVE_PARMSA MCI_SAVE_PARMS;
#endif // UNICODE
typedef MCI_SAVE_PARMSA     *PMCI_SAVE_PARMSA;
typedef MCI_SAVE_PARMSW     *PMCI_SAVE_PARMSW;
#ifdef UNICODE
typedef PMCI_SAVE_PARMSW PMCI_SAVE_PARMS;
#else
typedef PMCI_SAVE_PARMSA PMCI_SAVE_PARMS;
#endif // UNICODE
typedef MCI_SAVE_PARMSA     *LPMCI_SAVE_PARMSA;
typedef MCI_SAVE_PARMSW     *LPMCI_SAVE_PARMSW;
#ifdef UNICODE
typedef LPMCI_SAVE_PARMSW LPMCI_SAVE_PARMS;
#else
typedef LPMCI_SAVE_PARMSA LPMCI_SAVE_PARMS;
#endif // UNICODE

/* parameter block for MCI_LOAD command message */
typedef struct tagMCI_LOAD_PARMSA {
    DWORD   dwCallback;
    LPCSTR   lpfilename;
} MCI_LOAD_PARMSA;
/* parameter block for MCI_LOAD command message */
typedef struct tagMCI_LOAD_PARMSW {
    DWORD   dwCallback;
    LPCWSTR  lpfilename;
} MCI_LOAD_PARMSW;
#ifdef UNICODE
typedef MCI_LOAD_PARMSW MCI_LOAD_PARMS;
#else
typedef MCI_LOAD_PARMSA MCI_LOAD_PARMS;
#endif // UNICODE
typedef MCI_LOAD_PARMSA     *PMCI_LOAD_PARMSA;
typedef MCI_LOAD_PARMSW     *PMCI_LOAD_PARMSW;
#ifdef UNICODE
typedef PMCI_LOAD_PARMSW PMCI_LOAD_PARMS;
#else
typedef PMCI_LOAD_PARMSA PMCI_LOAD_PARMS;
#endif // UNICODE
typedef MCI_LOAD_PARMSA     *LPMCI_LOAD_PARMSA;
typedef MCI_LOAD_PARMSW     *LPMCI_LOAD_PARMSW;
#ifdef UNICODE
typedef LPMCI_LOAD_PARMSW LPMCI_LOAD_PARMS;
#else
typedef LPMCI_LOAD_PARMSA LPMCI_LOAD_PARMS;
#endif // UNICODE

/* parameter block for MCI_RECORD command message */
typedef struct tagMCI_RECORD_PARMS {
    DWORD   dwCallback;
    DWORD   dwFrom;
    DWORD   dwTo;
} MCI_RECORD_PARMS;

typedef MCI_RECORD_PARMS     *PMCI_RECORD_PARMS;
typedef MCI_RECORD_PARMS     *LPMCI_RECORD_PARMS;

/*****************************************************************************
*    Standard command parameters for videodisc drivers                       *
*****************************************************************************/

/* string resource ID's for videodisc players */
/* return ID's for videodisc status command */
/* return ID's for videodisc MCI_GETDEVCAPS command */
/* flag for dwReturn field of MCI_STATUS_PARMS */
/* MCI_STATUS command, (dwItem == MCI_STATUS_MODE) */
     MCI_VD_MODE_PARK                (MCI_VD_OFFSET + 1)

/* flag for dwReturn field of MCI_STATUS_PARMS */
/* MCI_STATUS command, (dwItem == MCI_VD_STATUS_MEDIA_TYPE) */
     MCI_VD_MEDIA_CLV                (MCI_VD_OFFSET + 2)
     MCI_VD_MEDIA_CAV                (MCI_VD_OFFSET + 3)
     MCI_VD_MEDIA_OTHER              (MCI_VD_OFFSET + 4)

     MCI_VD_FORMAT_TRACK             $4001

/* flags for dwFlags parameter of MCI_PLAY command message */
     MCI_VD_PLAY_REVERSE             $00010000L
     MCI_VD_PLAY_FAST                $00020000L
     MCI_VD_PLAY_SPEED               $00040000L
     MCI_VD_PLAY_SCAN                $00080000L
     MCI_VD_PLAY_SLOW                $00100000L

/* flag for dwFlags parameter of MCI_SEEK command message */
     MCI_VD_SEEK_REVERSE             $00010000L

/* flags for dwItem field of MCI_STATUS_PARMS parameter block */
     MCI_VD_STATUS_SPEED             $00004002L
     MCI_VD_STATUS_FORWARD           $00004003L
     MCI_VD_STATUS_MEDIA_TYPE        $00004004L
     MCI_VD_STATUS_SIDE              $00004005L
     MCI_VD_STATUS_DISC_SIZE         $00004006L

/* flags for dwFlags parameter of MCI_GETDEVCAPS command message */
     MCI_VD_GETDEVCAPS_CLV           $00010000L
     MCI_VD_GETDEVCAPS_CAV           $00020000L

     MCI_VD_SPIN_UP                  $00010000L
     MCI_VD_SPIN_DOWN                $00020000L

/* flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block */
     MCI_VD_GETDEVCAPS_CAN_REVERSE   $00004002L
     MCI_VD_GETDEVCAPS_FAST_RATE     $00004003L
     MCI_VD_GETDEVCAPS_SLOW_RATE     $00004004L
     MCI_VD_GETDEVCAPS_NORMAL_RATE   $00004005L

/* flags for the dwFlags parameter of MCI_STEP command message */
     MCI_VD_STEP_FRAMES              $00010000L
     MCI_VD_STEP_REVERSE             $00020000L

/* flag for the MCI_ESCAPE command message */
     MCI_VD_ESCAPE_STRING            $00000100L

/* parameter block for MCI_PLAY command message */
typedef struct tagMCI_VD_PLAY_PARMS {
    DWORD   dwCallback;
    DWORD   dwFrom;
    DWORD   dwTo;
    DWORD   dwSpeed;
} MCI_VD_PLAY_PARMS;
typedef MCI_VD_PLAY_PARMS     *PMCI_VD_PLAY_PARMS;
typedef MCI_VD_PLAY_PARMS     *LPMCI_VD_PLAY_PARMS;

/* parameter block for MCI_STEP command message */
typedef struct tagMCI_VD_STEP_PARMS {
    DWORD   dwCallback;
    DWORD   dwFrames;
} MCI_VD_STEP_PARMS;
typedef MCI_VD_STEP_PARMS     *PMCI_VD_STEP_PARMS;
typedef MCI_VD_STEP_PARMS     *LPMCI_VD_STEP_PARMS;

/* parameter block for MCI_ESCAPE command message */
typedef struct tagMCI_VD_ESCAPE_PARMSA {
    DWORD   dwCallback;
    LPCSTR    lpstrCommand;
} MCI_VD_ESCAPE_PARMSA;
/* parameter block for MCI_ESCAPE command message */
typedef struct tagMCI_VD_ESCAPE_PARMSW {
    DWORD   dwCallback;
    LPCWSTR   lpstrCommand;
} MCI_VD_ESCAPE_PARMSW;
#ifdef UNICODE
typedef MCI_VD_ESCAPE_PARMSW MCI_VD_ESCAPE_PARMS;
#else
typedef MCI_VD_ESCAPE_PARMSA MCI_VD_ESCAPE_PARMS;
#endif // UNICODE
typedef MCI_VD_ESCAPE_PARMSA     *PMCI_VD_ESCAPE_PARMSA;
typedef MCI_VD_ESCAPE_PARMSW     *PMCI_VD_ESCAPE_PARMSW;
#ifdef UNICODE
typedef PMCI_VD_ESCAPE_PARMSW PMCI_VD_ESCAPE_PARMS;
#else
typedef PMCI_VD_ESCAPE_PARMSA PMCI_VD_ESCAPE_PARMS;
#endif // UNICODE
typedef MCI_VD_ESCAPE_PARMSA     *LPMCI_VD_ESCAPE_PARMSA;
typedef MCI_VD_ESCAPE_PARMSW     *LPMCI_VD_ESCAPE_PARMSW;
#ifdef UNICODE
typedef LPMCI_VD_ESCAPE_PARMSW LPMCI_VD_ESCAPE_PARMS;
#else
typedef LPMCI_VD_ESCAPE_PARMSA LPMCI_VD_ESCAPE_PARMS;
#endif // UNICODE

/* MCI extensions for waveform audio devices */

/*****************************************************************************
*   Standard command parameters for waveform audio drivers
*****************************************************************************/

     MCI_WAVE_PCM            (MCI_WAVE_OFFSET+0)
     MCI_WAVE_MAPPER         (MCI_WAVE_OFFSET+1)

/* flags for the dwFlags parameter of MCI_OPEN command message */
     MCI_WAVE_OPEN_BUFFER            $00010000L

/* flags for the dwFlags parameter of MCI_SET command message */
     MCI_WAVE_SET_FORMATTAG          $00010000L
     MCI_WAVE_SET_CHANNELS           $00020000L
     MCI_WAVE_SET_SAMPLESPERSEC      $00040000L
     MCI_WAVE_SET_AVGBYTESPERSEC     $00080000L
     MCI_WAVE_SET_BLOCKALIGN         $00100000L
     MCI_WAVE_SET_BITSPERSAMPLE      $00200000L

/* flags for the dwFlags parameter of MCI_STATUS, MCI_SET command messages */
     MCI_WAVE_INPUT                  $00400000L
     MCI_WAVE_OUTPUT                 $00800000L

/* flags for the dwItem field of MCI_STATUS_PARMS parameter block */
     MCI_WAVE_STATUS_FORMATTAG       $00004001L
     MCI_WAVE_STATUS_CHANNELS        $00004002L
     MCI_WAVE_STATUS_SAMPLESPERSEC   $00004003L
     MCI_WAVE_STATUS_AVGBYTESPERSEC  $00004004L
     MCI_WAVE_STATUS_BLOCKALIGN      $00004005L
     MCI_WAVE_STATUS_BITSPERSAMPLE   $00004006L
     MCI_WAVE_STATUS_LEVEL           $00004007L

/* flags for the dwFlags parameter of MCI_SET command message */
     MCI_WAVE_SET_ANYINPUT           $04000000L
     MCI_WAVE_SET_ANYOUTPUT          $08000000L

/* flags for the dwFlags parameter of MCI_GETDEVCAPS command message */
     MCI_WAVE_GETDEVCAPS_INPUTS      $00004001L
     MCI_WAVE_GETDEVCAPS_OUTPUTS     $00004002L

/* parameter block for MCI_OPEN command message */
typedef struct tagMCI_WAVE_OPEN_PARMSA {
    DWORD   dwCallback;
    MCIDEVICEID wDeviceID;
    LPCSTR    lpstrDeviceType;
    LPCSTR    lpstrElementName;
    LPCSTR    lpstrAlias;
    DWORD   dwBufferSeconds;
} MCI_WAVE_OPEN_PARMSA;
/* parameter block for MCI_OPEN command message */
typedef struct tagMCI_WAVE_OPEN_PARMSW {
    DWORD   dwCallback;
    MCIDEVICEID wDeviceID;
    LPCWSTR   lpstrDeviceType;
    LPCWSTR   lpstrElementName;
    LPCWSTR   lpstrAlias;
    DWORD   dwBufferSeconds;
} MCI_WAVE_OPEN_PARMSW;
#ifdef UNICODE
typedef MCI_WAVE_OPEN_PARMSW MCI_WAVE_OPEN_PARMS;
#else
typedef MCI_WAVE_OPEN_PARMSA MCI_WAVE_OPEN_PARMS;
#endif // UNICODE
typedef MCI_WAVE_OPEN_PARMSA     *PMCI_WAVE_OPEN_PARMSA;
typedef MCI_WAVE_OPEN_PARMSW     *PMCI_WAVE_OPEN_PARMSW;
#ifdef UNICODE
typedef PMCI_WAVE_OPEN_PARMSW PMCI_WAVE_OPEN_PARMS;
#else
typedef PMCI_WAVE_OPEN_PARMSA PMCI_WAVE_OPEN_PARMS;
#endif // UNICODE
typedef MCI_WAVE_OPEN_PARMSA     *LPMCI_WAVE_OPEN_PARMSA;
typedef MCI_WAVE_OPEN_PARMSW     *LPMCI_WAVE_OPEN_PARMSW;
#ifdef UNICODE
typedef LPMCI_WAVE_OPEN_PARMSW LPMCI_WAVE_OPEN_PARMS;
#else
typedef LPMCI_WAVE_OPEN_PARMSA LPMCI_WAVE_OPEN_PARMS;
#endif // UNICODE

/* parameter block for MCI_DELETE command message */
typedef struct tagMCI_WAVE_DELETE_PARMS {
    DWORD   dwCallback;
    DWORD   dwFrom;
    DWORD   dwTo;
} MCI_WAVE_DELETE_PARMS;
typedef MCI_WAVE_DELETE_PARMS     *PMCI_WAVE_DELETE_PARMS;
typedef MCI_WAVE_DELETE_PARMS     *LPMCI_WAVE_DELETE_PARMS;

/* parameter block for MCI_SET command message */
typedef struct tagMCI_WAVE_SET_PARMS {
    DWORD   dwCallback;
    DWORD   dwTimeFormat;
    DWORD   dwAudio;
    UINT    wInput;
    UINT    wOutput;
    WORD    wFormatTag;                // corresponds to WAVEFORMAT structure
    WORD    wReserved2;
    WORD    nChannels;                 // corresponds to WAVEFORMAT structure
    WORD    wReserved3;
    DWORD   nSamplesPerSec;
    DWORD   nAvgBytesPerSec;
    WORD    nBlockAlign;               // corresponds to WAVEFORMAT structure
    WORD    wReserved4;
    WORD    wBitsPerSample;            // corresponds to PCMWAVEFORMAT structure
    WORD    wReserved5;
} MCI_WAVE_SET_PARMS;
typedef MCI_WAVE_SET_PARMS     * PMCI_WAVE_SET_PARMS;
typedef MCI_WAVE_SET_PARMS     * LPMCI_WAVE_SET_PARMS;



/*****************************************************************************
*   Standard command parameters for CD audio drivers
*****************************************************************************/
     MCI_CDA_STATUS_TYPE_TRACK       $00004001L

/* flags for the dwReturn field of MCI_STATUS_PARMS parameter block */
/* MCI_STATUS command, (dwItem == MCI_CDA_STATUS_TYPE_TRACK) */
     MCI_CDA_TRACK_AUDIO             (0 + MCI_CD_OFFSET)
     MCI_CDA_TRACK_OTHER             (1 + MCI_CD_OFFSET)


/*****************************************************************************
*        Standard command parameters for MIDI Sequencer drivers
*****************************************************************************/

/* string resource ID's for sequencers */
/* return ids for status division type */

/* flags for the dwReturn field of MCI_STATUS_PARMS parameter block */
/* MCI_STATUS command, (dwItem == MCI_SEQ_STATUS_DIVTYPE) */
         MCI_SEQ_DIV_PPQN              (0 + MCI_SEQ_OFFSET)
         MCI_SEQ_DIV_SMPTE_24        (1 + MCI_SEQ_OFFSET)
         MCI_SEQ_DIV_SMPTE_25        (2 + MCI_SEQ_OFFSET)
         MCI_SEQ_DIV_SMPTE_30DROP    (3 + MCI_SEQ_OFFSET)
         MCI_SEQ_DIV_SMPTE_30        (4 + MCI_SEQ_OFFSET)

/* flags for the dwMaster field of MCI_SEQ_SET_PARMS parameter block */
/* MCI_SET command, (dwFlags == MCI_SEQ_SET_MASTER) */
         MCI_SEQ_FORMAT_SONGPTR      $4001
         MCI_SEQ_FILE                $4002
         MCI_SEQ_MIDI                $4003
         MCI_SEQ_SMPTE               $4004
         MCI_SEQ_NONE                65533

         MCI_SEQ_MAPPER              65535

/* flags for the dwItem field of MCI_STATUS_PARMS parameter block */
     MCI_SEQ_STATUS_TEMPO            $00004002L
     MCI_SEQ_STATUS_PORT             $00004003L
     MCI_SEQ_STATUS_SLAVE            $00004007L
     MCI_SEQ_STATUS_MASTER           $00004008L
     MCI_SEQ_STATUS_OFFSET           $00004009L
     MCI_SEQ_STATUS_DIVTYPE          $0000400AL

/* flags for the dwFlags parameter of MCI_SET command message */
     MCI_SEQ_SET_TEMPO               $00010000L
     MCI_SEQ_SET_PORT                $00020000L
     MCI_SEQ_SET_SLAVE               $00040000L
     MCI_SEQ_SET_MASTER              $00080000L
     MCI_SEQ_SET_OFFSET              $01000000L

/* parameter block for MCI_SET command message */
typedef struct tagMCI_SEQ_SET_PARMS {
    DWORD   dwCallback;
    DWORD   dwTimeFormat;
    DWORD   dwAudio;
    DWORD   dwTempo;
    DWORD   dwPort;
    DWORD   dwSlave;
    DWORD   dwMaster;
    DWORD   dwOffset;
} MCI_SEQ_SET_PARMS;
typedef MCI_SEQ_SET_PARMS     * PMCI_SEQ_SET_PARMS;
typedef MCI_SEQ_SET_PARMS     * LPMCI_SEQ_SET_PARMS;


/*****************************************************************************
*      Standard command parameters for animation
*****************************************************************************/


/* flags for dwFlags parameter of MCI_OPEN command message */
     MCI_ANIM_OPEN_WS                $00010000L
     MCI_ANIM_OPEN_PARENT            $00020000L
     MCI_ANIM_OPEN_NOSTATIC          $00040000L

/* flags for dwFlags parameter of MCI_PLAY command message */
     MCI_ANIM_PLAY_SPEED             $00010000L
     MCI_ANIM_PLAY_REVERSE           $00020000L
     MCI_ANIM_PLAY_FAST              $00040000L
     MCI_ANIM_PLAY_SLOW              $00080000L
     MCI_ANIM_PLAY_SCAN              $00100000L

/* flags for dwFlags parameter of MCI_STEP command message */
     MCI_ANIM_STEP_REVERSE           $00010000L
     MCI_ANIM_STEP_FRAMES            $00020000L

/* flags for dwItem field of MCI_STATUS_PARMS parameter block */
     MCI_ANIM_STATUS_SPEED           $00004001L
     MCI_ANIM_STATUS_FORWARD         $00004002L
     MCI_ANIM_STATUS_HWND            $00004003L
     MCI_ANIM_STATUS_HPAL            $00004004L
     MCI_ANIM_STATUS_STRETCH         $00004005L

/* flags for the dwFlags parameter of MCI_INFO command message */
     MCI_ANIM_INFO_TEXT              $00010000L

/* flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block */
     MCI_ANIM_GETDEVCAPS_CAN_REVERSE $00004001L
     MCI_ANIM_GETDEVCAPS_FAST_RATE   $00004002L
     MCI_ANIM_GETDEVCAPS_SLOW_RATE   $00004003L
     MCI_ANIM_GETDEVCAPS_NORMAL_RATE $00004004L
     MCI_ANIM_GETDEVCAPS_PALETTES    $00004006L
     MCI_ANIM_GETDEVCAPS_CAN_STRETCH $00004007L
     MCI_ANIM_GETDEVCAPS_MAX_WINDOWS $00004008L

/* flags for the MCI_REALIZE command message */
     MCI_ANIM_REALIZE_NORM           $00010000L
     MCI_ANIM_REALIZE_BKGD           $00020000L

/* flags for dwFlags parameter of MCI_WINDOW command message */
     MCI_ANIM_WINDOW_HWND            $00010000L
     MCI_ANIM_WINDOW_STATE           $00040000L
     MCI_ANIM_WINDOW_TEXT            $00080000L
     MCI_ANIM_WINDOW_ENABLE_STRETCH  $00100000L
     MCI_ANIM_WINDOW_DISABLE_STRETCH $00200000L

/* flags for hWnd field of MCI_ANIM_WINDOW_PARMS parameter block */
/* MCI_WINDOW command message, (dwFlags == MCI_ANIM_WINDOW_HWND) */
     MCI_ANIM_WINDOW_DEFAULT         $00000000L

/* flags for dwFlags parameter of MCI_PUT command message */
     MCI_ANIM_RECT                   $00010000L
     MCI_ANIM_PUT_SOURCE             $00020000L
     MCI_ANIM_PUT_DESTINATION        $00040000L

/* flags for dwFlags parameter of MCI_WHERE command message */
     MCI_ANIM_WHERE_SOURCE           $00020000L
     MCI_ANIM_WHERE_DESTINATION      $00040000L

/* flags for dwFlags parameter of MCI_UPDATE command message */
     MCI_ANIM_UPDATE_HDC             $00020000L

/* parameter block for MCI_OPEN command message */
typedef struct tagMCI_ANIM_OPEN_PARMSA {
    DWORD   dwCallback;
    MCIDEVICEID wDeviceID;
    LPCSTR    lpstrDeviceType;
    LPCSTR    lpstrElementName;
    LPCSTR    lpstrAlias;
    DWORD   dwStyle;
    HWND    hWndParent;
} MCI_ANIM_OPEN_PARMSA;
/* parameter block for MCI_OPEN command message */
typedef struct tagMCI_ANIM_OPEN_PARMSW {
    DWORD   dwCallback;
    MCIDEVICEID wDeviceID;
    LPCWSTR   lpstrDeviceType;
    LPCWSTR   lpstrElementName;
    LPCWSTR   lpstrAlias;
    DWORD   dwStyle;
    HWND    hWndParent;
} MCI_ANIM_OPEN_PARMSW;
#ifdef UNICODE
typedef MCI_ANIM_OPEN_PARMSW MCI_ANIM_OPEN_PARMS;
#else
typedef MCI_ANIM_OPEN_PARMSA MCI_ANIM_OPEN_PARMS;
#endif // UNICODE
typedef MCI_ANIM_OPEN_PARMSA     *PMCI_ANIM_OPEN_PARMSA;
typedef MCI_ANIM_OPEN_PARMSW     *PMCI_ANIM_OPEN_PARMSW;
#ifdef UNICODE
typedef PMCI_ANIM_OPEN_PARMSW PMCI_ANIM_OPEN_PARMS;
#else
typedef PMCI_ANIM_OPEN_PARMSA PMCI_ANIM_OPEN_PARMS;
#endif // UNICODE
typedef MCI_ANIM_OPEN_PARMSA     *LPMCI_ANIM_OPEN_PARMSA;
typedef MCI_ANIM_OPEN_PARMSW     *LPMCI_ANIM_OPEN_PARMSW;
#ifdef UNICODE
typedef LPMCI_ANIM_OPEN_PARMSW LPMCI_ANIM_OPEN_PARMS;
#else
typedef LPMCI_ANIM_OPEN_PARMSA LPMCI_ANIM_OPEN_PARMS;
#endif // UNICODE

/* parameter block for MCI_PLAY command message */
typedef struct tagMCI_ANIM_PLAY_PARMS {
    DWORD   dwCallback;
    DWORD   dwFrom;
    DWORD   dwTo;
    DWORD   dwSpeed;
} MCI_ANIM_PLAY_PARMS;
typedef MCI_ANIM_PLAY_PARMS     *PMCI_ANIM_PLAY_PARMS;
typedef MCI_ANIM_PLAY_PARMS     *LPMCI_ANIM_PLAY_PARMS;

/* parameter block for MCI_STEP command message */
typedef struct tagMCI_ANIM_STEP_PARMS {
    DWORD   dwCallback;
    DWORD   dwFrames;
} MCI_ANIM_STEP_PARMS;
typedef MCI_ANIM_STEP_PARMS     *PMCI_ANIM_STEP_PARMS;
typedef MCI_ANIM_STEP_PARMS     *LPMCI_ANIM_STEP_PARMS;

/* parameter block for MCI_WINDOW command message */
typedef struct tagMCI_ANIM_WINDOW_PARMSA {
    DWORD   dwCallback;
    HWND    hWnd;
    UINT    nCmdShow;
    LPCSTR   lpstrText;
} MCI_ANIM_WINDOW_PARMSA;
/* parameter block for MCI_WINDOW command message */
typedef struct tagMCI_ANIM_WINDOW_PARMSW {
    DWORD   dwCallback;
    HWND    hWnd;
    UINT    nCmdShow;
    LPCWSTR  lpstrText;
} MCI_ANIM_WINDOW_PARMSW;
#ifdef UNICODE
typedef MCI_ANIM_WINDOW_PARMSW MCI_ANIM_WINDOW_PARMS;
#else
typedef MCI_ANIM_WINDOW_PARMSA MCI_ANIM_WINDOW_PARMS;
#endif // UNICODE
typedef MCI_ANIM_WINDOW_PARMSA     * PMCI_ANIM_WINDOW_PARMSA;
typedef MCI_ANIM_WINDOW_PARMSW     * PMCI_ANIM_WINDOW_PARMSW;
#ifdef UNICODE
typedef PMCI_ANIM_WINDOW_PARMSW PMCI_ANIM_WINDOW_PARMS;
#else
typedef PMCI_ANIM_WINDOW_PARMSA PMCI_ANIM_WINDOW_PARMS;
#endif // UNICODE
typedef MCI_ANIM_WINDOW_PARMSA     * LPMCI_ANIM_WINDOW_PARMSA;
typedef MCI_ANIM_WINDOW_PARMSW     * LPMCI_ANIM_WINDOW_PARMSW;
#ifdef UNICODE
typedef LPMCI_ANIM_WINDOW_PARMSW LPMCI_ANIM_WINDOW_PARMS;
#else
typedef LPMCI_ANIM_WINDOW_PARMSA LPMCI_ANIM_WINDOW_PARMS;
#endif // UNICODE

/* parameter block for MCI_PUT, MCI_UPDATE, MCI_WHERE command messages */
typedef struct tagMCI_ANIM_RECT_PARMS {
    DWORD   dwCallback;
#ifdef MCI_USE_OFFEXT
    POINT   ptOffset;
    POINT   ptExtent;
#else   //ifdef MCI_USE_OFFEXT
    RECT    rc;
#endif  //ifdef MCI_USE_OFFEXT
} MCI_ANIM_RECT_PARMS;
typedef MCI_ANIM_RECT_PARMS     * PMCI_ANIM_RECT_PARMS;
typedef MCI_ANIM_RECT_PARMS     * LPMCI_ANIM_RECT_PARMS;

/* parameter block for MCI_UPDATE PARMS */
typedef struct tagMCI_ANIM_UPDATE_PARMS {
    DWORD   dwCallback;
    RECT    rc;
    HDC     hDC;
} MCI_ANIM_UPDATE_PARMS;
typedef MCI_ANIM_UPDATE_PARMS     * PMCI_ANIM_UPDATE_PARMS;
typedef MCI_ANIM_UPDATE_PARMS     * LPMCI_ANIM_UPDATE_PARMS;

/*****************************************************************************

    Standard command parameters for video overlay devices

*****************************************************************************/

/* flags for dwFlags parameter of MCI_OPEN command message */
     MCI_OVLY_OPEN_WS                $00010000L
     MCI_OVLY_OPEN_PARENT            $00020000L

/* flags for dwFlags parameter of MCI_STATUS command message */
     MCI_OVLY_STATUS_HWND            $00004001L
     MCI_OVLY_STATUS_STRETCH         $00004002L

/* flags for dwFlags parameter of MCI_INFO command message */
     MCI_OVLY_INFO_TEXT              $00010000L

/* flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block */
     MCI_OVLY_GETDEVCAPS_CAN_STRETCH $00004001L
     MCI_OVLY_GETDEVCAPS_CAN_FREEZE  $00004002L
     MCI_OVLY_GETDEVCAPS_MAX_WINDOWS $00004003L

/* flags for dwFlags parameter of MCI_WINDOW command message */
     MCI_OVLY_WINDOW_HWND            $00010000L
     MCI_OVLY_WINDOW_STATE           $00040000L
     MCI_OVLY_WINDOW_TEXT            $00080000L
     MCI_OVLY_WINDOW_ENABLE_STRETCH  $00100000L
     MCI_OVLY_WINDOW_DISABLE_STRETCH $00200000L

/* flags for hWnd parameter of MCI_OVLY_WINDOW_PARMS parameter block */
     MCI_OVLY_WINDOW_DEFAULT         $00000000L

/* flags for dwFlags parameter of MCI_PUT command message */
     MCI_OVLY_RECT                   $00010000L
     MCI_OVLY_PUT_SOURCE             $00020000L
     MCI_OVLY_PUT_DESTINATION        $00040000L
     MCI_OVLY_PUT_FRAME              $00080000L
     MCI_OVLY_PUT_VIDEO              $00100000L

/* flags for dwFlags parameter of MCI_WHERE command message */
     MCI_OVLY_WHERE_SOURCE           $00020000L
     MCI_OVLY_WHERE_DESTINATION      $00040000L
     MCI_OVLY_WHERE_FRAME            $00080000L
     MCI_OVLY_WHERE_VIDEO            $00100000L


/* parameter block for MCI_OPEN command message */
typedef struct tagMCI_OVLY_OPEN_PARMSA {
    DWORD   dwCallback;
    MCIDEVICEID wDeviceID;
    LPCSTR    lpstrDeviceType;
    LPCSTR    lpstrElementName;
    LPCSTR    lpstrAlias;
    DWORD   dwStyle;
    HWND    hWndParent;
 } MCI_OVLY_OPEN_PARMSA;
/* parameter block for MCI_OPEN command message */
typedef struct tagMCI_OVLY_OPEN_PARMSW {
    DWORD   dwCallback;
    MCIDEVICEID wDeviceID;
    LPCWSTR   lpstrDeviceType;
    LPCWSTR   lpstrElementName;
    LPCWSTR   lpstrAlias;
    DWORD   dwStyle;
    HWND    hWndParent;
 } MCI_OVLY_OPEN_PARMSW;
#ifdef UNICODE
typedef MCI_OVLY_OPEN_PARMSW MCI_OVLY_OPEN_PARMS;
#else
typedef MCI_OVLY_OPEN_PARMSA MCI_OVLY_OPEN_PARMS;
#endif // UNICODE
typedef MCI_OVLY_OPEN_PARMSA     *PMCI_OVLY_OPEN_PARMSA;
typedef MCI_OVLY_OPEN_PARMSW     *PMCI_OVLY_OPEN_PARMSW;
#ifdef UNICODE
typedef PMCI_OVLY_OPEN_PARMSW PMCI_OVLY_OPEN_PARMS;
#else
typedef PMCI_OVLY_OPEN_PARMSA PMCI_OVLY_OPEN_PARMS;
#endif // UNICODE
typedef MCI_OVLY_OPEN_PARMSA     *LPMCI_OVLY_OPEN_PARMSA;
typedef MCI_OVLY_OPEN_PARMSW     *LPMCI_OVLY_OPEN_PARMSW;
#ifdef UNICODE
typedef LPMCI_OVLY_OPEN_PARMSW LPMCI_OVLY_OPEN_PARMS;
#else
typedef LPMCI_OVLY_OPEN_PARMSA LPMCI_OVLY_OPEN_PARMS;
#endif // UNICODE

/* parameter block for MCI_WINDOW command message */
typedef struct tagMCI_OVLY_WINDOW_PARMSA {
    DWORD   dwCallback;
    HWND    hWnd;
    UINT    nCmdShow;
    LPCSTR    lpstrText;
} MCI_OVLY_WINDOW_PARMSA;
/* parameter block for MCI_WINDOW command message */
typedef struct tagMCI_OVLY_WINDOW_PARMSW {
    DWORD   dwCallback;
    HWND    hWnd;
    UINT    nCmdShow;
    LPCWSTR   lpstrText;
} MCI_OVLY_WINDOW_PARMSW;
#ifdef UNICODE
typedef MCI_OVLY_WINDOW_PARMSW MCI_OVLY_WINDOW_PARMS;
#else
typedef MCI_OVLY_WINDOW_PARMSA MCI_OVLY_WINDOW_PARMS;
#endif // UNICODE
typedef MCI_OVLY_WINDOW_PARMSA     * PMCI_OVLY_WINDOW_PARMSA;
typedef MCI_OVLY_WINDOW_PARMSW     * PMCI_OVLY_WINDOW_PARMSW;
#ifdef UNICODE
typedef PMCI_OVLY_WINDOW_PARMSW PMCI_OVLY_WINDOW_PARMS;
#else
typedef PMCI_OVLY_WINDOW_PARMSA PMCI_OVLY_WINDOW_PARMS;
#endif // UNICODE
typedef MCI_OVLY_WINDOW_PARMSA     * LPMCI_OVLY_WINDOW_PARMSA;
typedef MCI_OVLY_WINDOW_PARMSW     * LPMCI_OVLY_WINDOW_PARMSW;
#ifdef UNICODE
typedef LPMCI_OVLY_WINDOW_PARMSW LPMCI_OVLY_WINDOW_PARMS;
#else
typedef LPMCI_OVLY_WINDOW_PARMSA LPMCI_OVLY_WINDOW_PARMS;
#endif // UNICODE

/* parameter block for MCI_PUT, MCI_UPDATE, and MCI_WHERE command messages */
typedef struct tagMCI_OVLY_RECT_PARMS {
    DWORD   dwCallback;
#ifdef MCI_USE_OFFEXT
    POINT   ptOffset;
    POINT   ptExtent;
#else   //ifdef MCI_USE_OFFEXT
    RECT    rc;
#endif  //ifdef MCI_USE_OFFEXT
} MCI_OVLY_RECT_PARMS;
typedef MCI_OVLY_RECT_PARMS     * PMCI_OVLY_RECT_PARMS;
typedef MCI_OVLY_RECT_PARMS     * LPMCI_OVLY_RECT_PARMS;

/* parameter block for MCI_SAVE command message */
typedef struct tagMCI_OVLY_SAVE_PARMSA {
    DWORD   dwCallback;
    LPCSTR    lpfilename;
    RECT    rc;
} MCI_OVLY_SAVE_PARMSA;
/* parameter block for MCI_SAVE command message */
typedef struct tagMCI_OVLY_SAVE_PARMSW {
    DWORD   dwCallback;
    LPCWSTR   lpfilename;
    RECT    rc;
} MCI_OVLY_SAVE_PARMSW;
#ifdef UNICODE
typedef MCI_OVLY_SAVE_PARMSW MCI_OVLY_SAVE_PARMS;
#else
typedef MCI_OVLY_SAVE_PARMSA MCI_OVLY_SAVE_PARMS;
#endif // UNICODE
typedef MCI_OVLY_SAVE_PARMSA     * PMCI_OVLY_SAVE_PARMSA;
typedef MCI_OVLY_SAVE_PARMSW     * PMCI_OVLY_SAVE_PARMSW;
#ifdef UNICODE
typedef PMCI_OVLY_SAVE_PARMSW PMCI_OVLY_SAVE_PARMS;
#else
typedef PMCI_OVLY_SAVE_PARMSA PMCI_OVLY_SAVE_PARMS;
#endif // UNICODE
typedef MCI_OVLY_SAVE_PARMSA     * LPMCI_OVLY_SAVE_PARMSA;
typedef MCI_OVLY_SAVE_PARMSW     * LPMCI_OVLY_SAVE_PARMSW;
#ifdef UNICODE
typedef LPMCI_OVLY_SAVE_PARMSW LPMCI_OVLY_SAVE_PARMS;
#else
typedef LPMCI_OVLY_SAVE_PARMSA LPMCI_OVLY_SAVE_PARMS;
#endif // UNICODE

/* parameter block for MCI_LOAD command message */
typedef struct tagMCI_OVLY_LOAD_PARMSA {
    DWORD   dwCallback;
    LPCSTR    lpfilename;
    RECT    rc;
} MCI_OVLY_LOAD_PARMSA;
/* parameter block for MCI_LOAD command message */
typedef struct tagMCI_OVLY_LOAD_PARMSW {
    DWORD   dwCallback;
    LPCWSTR   lpfilename;
    RECT    rc;
} MCI_OVLY_LOAD_PARMSW;
#ifdef UNICODE
typedef MCI_OVLY_LOAD_PARMSW MCI_OVLY_LOAD_PARMS;
#else
typedef MCI_OVLY_LOAD_PARMSA MCI_OVLY_LOAD_PARMS;
#endif // UNICODE
typedef MCI_OVLY_LOAD_PARMSA     * PMCI_OVLY_LOAD_PARMSA;
typedef MCI_OVLY_LOAD_PARMSW     * PMCI_OVLY_LOAD_PARMSW;
#ifdef UNICODE
typedef PMCI_OVLY_LOAD_PARMSW PMCI_OVLY_LOAD_PARMS;
#else
typedef PMCI_OVLY_LOAD_PARMSA PMCI_OVLY_LOAD_PARMS;
#endif // UNICODE
typedef MCI_OVLY_LOAD_PARMSA     * LPMCI_OVLY_LOAD_PARMSA;
typedef MCI_OVLY_LOAD_PARMSW     * LPMCI_OVLY_LOAD_PARMSW;
#ifdef UNICODE
typedef LPMCI_OVLY_LOAD_PARMSW LPMCI_OVLY_LOAD_PARMS;
#else
typedef LPMCI_OVLY_LOAD_PARMSA LPMCI_OVLY_LOAD_PARMS;
#endif // UNICODE

#endif  //ifndef MMNOMCI


/****************************************************************************

                        DISPLAY Driver extensions

****************************************************************************/

#ifndef C1_TRANSPARENT
     CAPS1           94              // other caps
     C1_TRANSPARENT  $0001          // new raster cap
     NEWTRANSPARENT  3               // use with SetBkMode()

     QUERYROPSUPPORT 40              // use to determine ROP support
#endif  //ifndef C1_TRANSPARENT

/****************************************************************************

                        DIB Driver extensions

****************************************************************************/

     SELECTDIB       41              // DIB.DRV select dib escape
     DIBINDEX(n)     MAKELONG((n),$10FF)


/****************************************************************************

                        ScreenSaver support

    The current application will receive a syscommand of SC_SCREENSAVE just
    before the screen saver is invoked.  If the app wishes to prevent a
    screen save, return non-zero value, otherwise call DefWindowProc().

****************************************************************************/

#ifndef SC_SCREENSAVE

     SC_SCREENSAVE   $F140

#endif  //ifndef SC_SCREENSAVE

#ifdef __cplusplus
}                       // End of extern "C" {
#endif  // __cplusplus

#include "poppack.h"    /* Revert to default packing */

#endif // _INC_MMSYSTEM

#endif  /* __FLAT__ */
*)

IMPORTS
   FUNCTION mciSendString(CONST lpstrCommand:CSTRING;VAR lpstrReturnString:CSTRING;
                          uReturnLength:LONGWORD;hwndCallback:HWND):MCIError;
        APIENTRY;   'WINMM' name 'mciSendStringA';
   FUNCTION mciGetErrorString(mcierr:MCIERROR;VAR lpstrBuffer:CSTRING;
                              cchText:LONGWORD ):BOOL;
        APIENTRY;   'WINMM' name 'mciGetErrorStringA';
   FUNCTION mciGetDeviceID(CONST lpstrName:CSTRING):MCIDEVICEID;
        APIENTRY;   'WINMM' name 'mciGetDeviceIDA';
(*
LRESULT APIENTRY CloseDriver(HDRVR hDriver, LONG lParam1, LONG lParam2);
HDRVR   APIENTRY OpenDriver( LPCWSTR szDriverName, LPCWSTR szSectionName, LONG lParam2);
LRESULT APIENTRY SendDriverMessage( HDRVR hDriver, UINT uMsg, LONG lParam1, LONG lParam2);
HMODULE APIENTRY DrvGetModuleHandle( HDRVR hDriver );
HMODULE APIENTRY GetDriverModuleHandle( HDRVR hDriver );
LRESULT WINAPI   DefDriverProc(DWORD dwDriverIdentifier, HDRVR driverID, UINT message, LPARAM lParam1, LPARAM lParam2);
UINT APIENTRY mmsystemGetVersion(VOID);
BOOL APIENTRY sndPlaySoundA( LPCSTR lpszSoundName, UINT fuSound );
BOOL APIENTRY sndPlaySoundW( LPCWSTR lpszSoundName, UINT fuSound );
#ifdef UNICODE
     sndPlaySound  sndPlaySoundW
#else
     sndPlaySound  sndPlaySoundA
#endif // !UNICODE
BOOL APIENTRY PlaySoundA( LPCSTR lpszName, HMODULE hModule, DWORD dwFlags );
BOOL APIENTRY PlaySoundW( LPCWSTR lpszName, HMODULE hModule, DWORD dwFlags );
#ifdef UNICODE
     PlaySound  PlaySoundW
#else
     PlaySound  PlaySoundA
#endif // !UNICODE

sndAlias( ch0, ch1 ) \
                ( SND_ALIAS_START + (DWORD)(BYTE)(ch0) | ( (DWORD)(BYTE)(ch1) << 8 ))

SND_ALIAS_SYSTEMASTERISK        sndAlias('S', '*')
     SND_ALIAS_SYSTEMQUESTION        sndAlias('S', '?')
     SND_ALIAS_SYSTEMHAND            sndAlias('S', 'H')
     SND_ALIAS_SYSTEMEXIT            sndAlias('S', 'E')
     SND_ALIAS_SYSTEMSTART           sndAlias('S', 'S')
     SND_ALIAS_SYSTEMWELCOME         sndAlias('S', 'W')
     SND_ALIAS_SYSTEMEXCLAMATION     sndAlias('S', '!')
     SND_ALIAS_SYSTEMDEFAULT         sndAlias('S', 'D')

*)
END;

IMPLEMENTATION

END.
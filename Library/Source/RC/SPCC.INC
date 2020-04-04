
/* Changes within this file require changes to the language manager !! */

CONST
  SSPCCMsgStart              = 64768;

  /* Default SPCC string constants */
  SLanguage                  = 65000;

  /* Buttons */
  SOk                        = 65001;
  SOkButton                  = 65002;
  SCancel                    = 65003;
  SCancelButton              = 65004;
  SHelp                      = 65005;
  SHelpButton                = 65006;
  SOpen                      = 65007;
  SOpenButton                = 65008;
  SSave                      = 65009;
  SSaveButton                = 65010;
  SCreate                    = 65011;
  SCreateButton              = 65012;
  SChange                    = 65013;
  SChangeButton              = 65014;
  SFind                      = 65015;
  SFindButton                = 65016;
  SForward                   = 65017;
  SForwardButton             = 65018;
  SBackward                  = 65019;
  SBackwardButton            = 65020;
  SSearch                    = 65021;
  SSearchButton              = 65022;
  SReplace                   = 65023;
  SReplaceButton             = 65024;
  SConfirm                   = 65025;
  SConfirmButton             = 65026;
  SAll                       = 65027;
  SAllButton                 = 65028;
  SSelect                    = 65029;
  SSelectButton              = 65030;
  SYes                       = 65031;
  SYesButton                 = 65032;
  SNo                        = 65033;
  SNoButton                  = 65034;
  SAbort                     = 65035;
  SAbortButton               = 65036;
  SRetry                     = 65037;
  SRetryButton               = 65038;
  SIgnore                    = 65039;
  SIgnoreButton              = 65040;
  SClose                     = 65041;
  SCloseButton               = 65042;
  SInsert                    = 65043;
  SInsertButton              = 65044;
  SEdit                      = 65045;
  SEditButton                = 65046;
  SDelete                    = 65047;
  SDeleteButton              = 65048;
  SPrev                      = 65306;
  SPrevButton                = 65307;
  SNext                      = 65308;
  SNextButton                = 65309;
  SPrinter                   = 65260;
  SPrinterButton             = 65261;
  SNew                       = 65264;
  SNewButton                 = 65265;

  /* Captions */
  SError                     = 65049;
  SCriticalError             = 65050;
  SInformation               = 65051;
  SWarning                   = 65052;
  SMessage                   = 65053;
  SReadBlockFromFile         = 65054;
  SWriteBlockToFile          = 65055;
  SUser                      = 65262;
  SPassword                  = 65263;

  /* Standard file filters */
  SAllFiles                  = 65056;
  SVideoFiles                = 65057;
  SWaveFiles                 = 65058;

  /* Standard Hints */
  SClickHereToAccept         = 65059;
  SClickHereToCancel         = 65060;
  SClickHereToGetHelp        = 65061;
  SClickHereToCreateADir     = 65062;
  SPlayHint                  = 65063;
  SRecordHint                = 65064;
  SNextTrackHint             = 65065;
  SPreviousTrackHint         = 65066;
  SPauseHint                 = 65067;
  SRewindHint                = 65068;
  SStopHint                  = 65069;
  SFirstRecordHint           = 65070;
  SPriorRecordHint           = 65071;
  SNextRecordHint            = 65072;
  SLastRecordHint            = 65073;
  SInsertRecordHint          = 65074;
  SDeleteRecordHint          = 65075;
  SEditRecordHint            = 65076;
  SPostRecordHint            = 65077;
  SCancelRecordHint          = 65078;
  SRefreshRecordHint         = 65079;

  /* CREATEDIR Dialog */
  SCreateDirectory           = 65080;
  SEnterNewDirectory         = 65081;
  SCannotCreateDir           = 65082;

  /* CHANGEDIR dialog */
  SChangeDirectory           = 65083;
  SDirectoryName             = 65084;

  /* FIND Dialog */
  SFindText                  = 65085;
  SOptions                   = 65086;
  SCaseSensitive             = 65087;
  SWordsOnly                 = 65088;
  SScope                     = 65089;
  SGlobal                    = 65090;
  SSelectedText              = 65091;
  SOrigin                    = 65092;
  SEntireScope               = 65093;
  SFromCursor                = 65094;
  SDirection                 = 65095;

  /* FONT Dialog */
  SSelectAFont               = 65096;
  SName                      = 65097;
  SSize                      = 65098;
  SStyle                     = 65099;
  SItalic                    = 65100;
  SBold                      = 65101;
  SEmphasis                  = 65102;
  SOutline                   = 65103;
  SStrikeOut                 = 65104;
  SUnderScore                = 65105;
  SExampleText               = 65106;

  /* OPEN Dialog */
  SOpenAFile                 = 65107;
  SFileName                  = 65108;
  SFileType                  = 65109;
  SDrive                     = 65110;
  SFiles                     = 65111;
  SDirectories               = 65112;
  SChangeToTargetDir         = 65113;

  /* SAVE Dialog */
  SSaveFileAs                = 65114;

  /* REPLACE Dialog */
  SReplaceText               = 65115;

  /* COLOR Dialog */
  SSelectAColor              = 65116;
  SDefaultColors             = 65117;

  /* INFO Dialog */
  SProgram                   = 65266;
  SVersion                   = 65267;
  SPath                      = 65268;

  /* Standard error msgs */
  SStreamReadErrorText       = 65118;
  SStreamWriteErrorText      = 65119;
  SStreamCreateErrorText     = 65120;
  SStreamOpenErrorText       = 65121;
  SStreamSeekErrorText       = 65122;
  SListErrorText             = 65123;
  SCollectionErrorText       = 65124;
  SStringListDupeErrorText   = 65125;
  SStringListInsertErrorText = 65126;
  SEBitsErrorText            = 65127;
  SNoMoreTimers              = 65128;
  SCouldNotRemoveTimer       = 65129;
  SAppHelpFailed             = 65130;
  SProgramAborted            = 65131;
  SMainWindowFailed          = 65132;
  SCouldNotCreateWindow      = 65133;
  SMMAccessError             = 65134;
  SMDMNotFound               = 65135;
  SMMIONotFound              = 65136;
  SUnknownMCIError           = 65137;
  SNoFileName                = 65138;
  SFatalMCIError             = 65139;
  SWrongMovieHandle          = 65140;
  SCannotPerformDBAction     = 65141;
  SErrorFetchingSQLStatement = 65142;
  SErrorExecutingSQLStatement= 65143;
  SEmptyResultSet            = 65144;
  SDataSourceLinkError       = 65145;
  SSQLError                  = 65146;
  SErrLoadingDB              = 65147;
  SErrAllocDBEnv             = 65148;
  SErrAllocDBConnect         = 65149;
  SErrSettingDBOpts          = 65150;
  SErrorDBConnecting         = 65151;
  SCouldNotCopyText          = 65152;
  SCouldNotAccessClipboard   = 65153;
  SSaveQuery                 = 65154;
  SFileNotFound              = 65155;
  SErrorWriting              = 65156;
  SLineWouldBeTooLong        = 65157;
  SReplaceThisString         = 65158;
  SLoading                   = 65159;
  SSaving                    = 65160;
  SAlreadyExistsOverwrite    = 65161;
  SSearchStringNotFound      = 65162;
  SErrorWritingTemporaryFile = 65163;
  SErrorCreatingTemporaryFile= 65164;
  SCannotOpenIniFile         = 65165;
  SWriteError                = 65166;
  SInvalidOutlineNodeOwner   = 65167;
  SInvalidOutlineNodeIndex   = 65168;
  SInvalidOutlineNode        = 65169;
  SInvalidBitmap             = 65170;
  SInvalidIcon               = 65171;
  SInvalidCursor             = 65172;
  SInvalidListBoxItemIndex   = 65173;
  SInvalidMemoLineIndex      = 65174;
  SPropertyNotFound          = 65175;
  SPropertySkipped           = 65176;
  SPropertyReadOnly          = 65177;
  SCouldNotReadFromProperty  = 65178;
  SPropError                 = 65179;
  SComponentNotFound         = 65180;
  SUseRegisterClasses        = 65181;
  SSCUErrorInClass           = 65182;
  SMethodNotFound            = 65183;
  SCouldNotWriteToProperty   = 65184;
  SLinkNotFound              = 65185;


  /* SysUtils messages */
  SInvalidInteger            = 65186;
  SInvalidFloat              = 65187;
  SInvalidDate               = 65188;
  SInvalidTime               = 65189;
  SInvalidDateTime           = 65190;
  STimeEncodeError           = 65191;
  SDateEncodeError           = 65192;

  SInvalidFormat             = 65193;
  SArgumentMissing           = 65194;

  SDate                      = 65269;
  STime                      = 65270;
  SShortMonthNames           = 65195;

  SShortMonthJan             = 65195;
  SShortMonthFeb             = 65196;
  SShortMonthMar             = 65197;
  SShortMonthApr             = 65198;
  SShortMonthMay             = 65199;
  SShortMonthJun             = 65200;
  SShortMonthJul             = 65201;
  SShortMonthAug             = 65202;
  SShortMonthSep             = 65203;
  SShortMonthOct             = 65204;
  SShortMonthNov             = 65205;
  SShortMonthDec             = 65206;

  SLongMonthNames            = 65207;

  SLongMonthJanuary          = 65207;
  SLongMonthFebruary         = 65208;
  SLongMonthMarch            = 65209;
  SLongMonthApril            = 65210;
  SLongMonthMay              = 65211;
  SLongMonthJune             = 65212;
  SLongMonthJuly             = 65213;
  SLongMonthAugust           = 65214;
  SLongMonthSeptember        = 65215;
  SLongMonthOctober          = 65216;
  SLongMonthNovember         = 65217;
  SLongMonthDecember         = 65218;

  SShortDayNames             = 65219;

  SShortDayNamesSun          = 65219;
  SShortDayNamesMon          = 65220;
  SShortDayNamesTue          = 65221;
  SShortDayNamesWed          = 65222;
  SShortDayNamesThu          = 65223;
  SShortDayNamesFri          = 65224;
  SShortDayNamesSat          = 65225;

  SLongDayNames              = 65226;

  SLongDayNamesSunday        = 65226;
  SLongDayNamesMonday        = 65227;
  SLongDayNamesTuesday       = 65228;
  SLongDayNamesWednesday     = 65229;
  SLongDayNamesThursday      = 65230;
  SLongDayNamesFriday        = 65231;
  SLongDayNamesSaturday      = 65232;

  /* Dual ListBox */
  SSource                    = 65233;
  SDestination               = 65234;

  /* Printer Dialog */
  SSetupPrinter              = 65235;
  SSetPrinter                = 65236;
  SCurrentPrinter            = 65237;
  SProperties                = 65238;
  SClickHereToSetProperties  = 65239;
  SPrint                     = 65240;
  SPrintButton               = 65241;
  STitle                     = 65242;
  SCopies                    = 65243;
  SPages                     = 65244;
  SFrom                      = 65245;
  STo                        = 65246;
  SFile                      = 65247;

  SConfirmation              = 65248;    


  SInvalidIndex              = 65250;
  SNoHandleIC                = 65251;
  SNoHandleDC                = 65252;
  SNoHandlePS                = 65253;
  SPrinterIdle               = 65254;
  SPrinterBusy               = 65255;
  SDeviceNotFound            = 65256;
  SJobProperties             = 65257;
  SPrinterInit1              = 65258;
  SPrinterInit2              = 65259;

  SNextPage                  = 65300;
  SPreviousPage              = 65301;

  /* Standard Hints */
  SBackTrackHint             = 65302;
  SStepTrackHint             = 65303;
  SEjectHint                 = 65304;

  STerminateProgram          = 65305;


/* Changes within this file require changes to the language manager !! */


/* -- date -- -- from -- -- changes ---------------------------------------------- */
/* 17-Sep-05  WD         Konstanten: SPrinter (65260) und SPrinterButton (65261) eingebaut */
/* 18-Sep-05  WD         Konstanten: SUser (65262) und SPassword (65263) eingebaut */
/* 27-Okt-05  WD         Konstanten: SNew (65264) und SNewButton (65265) eingebaut */
/* 01-Dez-05  WD         Konstanten: SProgram (65266), SVersion (65267), SPath (65268), */
/*                                   SDate (65269), STime(65270) eingebaut */


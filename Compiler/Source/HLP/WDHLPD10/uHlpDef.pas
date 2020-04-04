Unit uHlpDef;             
               
Interface        

Uses Dos, Crt, uString, uSysInfo, SysUtils,
     SPC_DATA;

Const cVersion   = '1.01';
      cAnzSystem = 2;
      cSystem    : Array[0..cAnzSystem-1] of tStr5 = ('OS2', 'WIN32');

// Farben:
      UseExtraColor:BOOLEAN = FALSE;
      NormalColor = 'fc=default bc=default';
      ExtraColor = 'fc=blue';

// Sprache
      cLangAll = 'ALL';

// Fehlermeldungen
      cErrCouldNotOpen    = 'Could not open: ';


TYPE PRefList=^TRefList;
     TRefList=RECORD
                    refid:LONGINT;
                    refName:STRING;
                    defined:BOOLEAN;
                    Next:PRefList;
              END;

type tSettings = Record
       CompSystem   : trSystem;
       CompForLngInd: LongInt;
       CurrentLngInd: LongInt;
       Language     : tStringList;
       QuellName    : tFilename;
       ZielName     : tFilename;
       IncludeName  : tFilename;
       WaitAfterPrg : Boolean;
     end;


TYPE TTable=RECORD
               ch:CHAR;
               repl:STRING[15];
            END;
CONST
    MaxTransTable=8;
    TransTable:ARRAY[1..MaxTransTable] OF TTable=
         ((ch:':';repl:'&colon.'),
          (ch:'&';repl:'&amp.'),
          (ch:'^';repl:'&caret.'),
          {(ch:'*';repl:'&asterisk.'),}
          (ch:'@';repl:'&atsign.'),
          (ch:'\';repl:'&bslash.'),
          (ch:#39;repl:'&csq.'),
          (ch:'=';repl:'&eq.'),
          (ch:'!';repl:'&xclm.'));


var CompStatusMsg         : tCompStatusMsg;
    Quell,Ziel,IncludeFile: TEXT;
    WorkPath              : tFilename;
    InInclude             : BOOLEAN;
    line,IncludeLine      : LONGINT;
    Sprachen              : tStringList;
    RefBase               : LONGINT;
    RefBaseUsed           : BOOLEAN;
    IncFilename           : tFilename;

VAR RefList  : PRefList;
    ParamList: tStringList;
    RefCount : LONGINT;

    Settings : tSettings;

Implementation

Initialization
End.

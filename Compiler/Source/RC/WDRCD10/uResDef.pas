Unit uResDef;

Interface

Uses uStream, uString,
     uBmpList, uStringTableList;

Const cVersion           = '1.0';

var goConstList : tStringList;      // Werte die als Konstanten gespeichert worden sind

// Name-Resource
    goBmpNameList        : tcBmpNameList;
    goGroupIconNameList  : tcBmpNameList;
    goIconNameList       : tcBmpNameList;
    goPointerNameList    : tcBmpNameList;
    goStringTableNameList: tcStringTableList;

// ID-Resource
    goBmpIDList          : tcBmpIDList;
    goGroupIconIDList    : tcBmpIDList;
    goIconIDList         : tcBmpIDList;
    goPointerIDList      : tcBmpIDList;
    goStringTableIDList  : tcStringTableIDList;
    goPosResIDEnde       : LongWord;

    goOutput    : tMemoryStream;              // Speicher fuer das Ergebnis

type trResHeader = Record
       Version : Word;      // $43 (=67) Version 2.0; $44 (=68) Version 2.5
       Offset  : LongWord;  // Start der Daten; meisstens $8
       Reserve : Word;      // Rseerve? Keine Ahnung ob da was stehen soll.
     End;

type trResIDHeader = Record
       CntDummy1     : Array[0..3] of Word; // Unbekannt
       CntGroupIcons : Word;
       CntStringTable: Word;
       CntPointer    : Word;
       CntBitmap     : Word;
       CntIcons      : Word;
       CntDummy2     : Word;
     End;

type trResIDInfo = Record
       ResTyp        : Word;      // Bei Ptr/Icons/usw = 1; BMP=2; Str=5
       ResID         : Word;      // ID des Resource
       ResLength     : LongWord;  // Laenge des Resource
       Dummy1        : Word;      // Keine Ahnung; bei Test hat es immer den Inhalt: 3
       Offset        : LongWord;
     End;

type trResEnd = Record
       Dummy1        : Array[0..9] of Word; // Wird am Ende mit 0 gespeichert
     End;


Implementation

Initialization
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  24-Jul-2004 WD       Erstellung der Unit
}

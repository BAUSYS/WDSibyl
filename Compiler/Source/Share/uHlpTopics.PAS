Unit uHlpTopics;

Interface

Uses uString;

Const MaxHlpTopics=32;           // Maximale Anzahl der Topics

      HC_TOPIC=1;             {Topic}
      HC_INDEX=2;             {Index entry}
      HC_MASTERINDEX=3;       {MasterIndex entry}
      HC_FIG=4;               {Figure}
      HC_EFIG=5;              {End Figure}
      HC_IPFC=6;              {Real IPFC command}
      HC_HIGH=7;              {High text}
      HC_XMP=8;               {Example}
      HC_EXMP=9;              {End Example}
      HC_INCLUDE=10;          {Include file}
      HC_TITLE=11;            {Title}
      HC_COLOR=12;            {Color}
      HC_ULIST=13;            {Unordered list}
      HC_EULIST=14;           {End of unordered list}
      HC_LISTITEM=15;         {List entry for ULIST,SLIST and OLIST}
      HC_SLIST=16;            {Simple list}
      HC_ESLIST=17;           {End simple list}
      HC_OLIST=18;            {Ordered list}
      HC_EOLIST=19;           {End ordered list}
      HC_BITMAP=20;           {Include bitmap}
      HC_DLIST=21;            {Definition list}
      HC_EDLIST=22;           {End definition list}
      HC_DTERM=23;            {Definition term}
      HC_DDESC=24;            {Definition description}
      HC_HIDDEN=25;           {Hidden topic}
      HC_HCTX=26;             {Konstantenname}
      HC_REFBASE=27;          {Basis fÅr Referenzen}
      HC_SET_INCFILENAME=28;  {Filename der INC-Datei}
      HC_SET_LANG=29;         {Sprache setzen}
      HC_BOLD=30;             {Zeile Fett ausgeben}
      HC_UNDERLINE=31;        {Zeile Unterstrichen ausgeben}
      HC_BOLD_UNDERLINE=32;   {Zeile Fett und Unterstrichen ausgeben}

      HlpTopics:ARRAY[1..MaxHlpTopics] OF tStr10 =
        ('.TOPIC','.INDEX','.MASTERINDEX','.FIG','.EFIG','.IPFC','.HIGH',
         '.XMP','.EXMP','.INCLUDE','.TITLE','.COLOR','.ULIST','.EULIST',
         '.LISTITEM','.SLIST','.ESLIST','.OLIST','.EOLIST','.BITMAP',
         '.DLIST','.EDLIST','.DTERM','.DDESC','.HIDDEN','.HCTX','.REFBASE',
         '.SET_INCFILENAME', '.SET_LANG', '.BOLD','.UNDERLINE','.BOLD_UNDERLINE');

Implementation

Initialization
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  28-Feb-2008 WD       Topic UNDERLINE und BOLD_UNDERLINE eingebaut
}

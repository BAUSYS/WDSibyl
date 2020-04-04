Unit uHLPComp;

// Dokumentation: F:\Sprachen\HLP\IPFC\IPFC20.INF

Interface         

Uses Dos, Crt, uString, SysUtils, uSysInfo,
     SPC_DATA,
     uHlpTopics, uHlpDef;

Procedure InvokeHlp(VAR iPasParams:TPasParams;VAR iPasReturn:TPasReturn);

Implementation

Var ErrFound : Boolean;

PROCEDURE Error(msg:STRING);

BEGIN
  ErrFound:=true;
  if InInclude
    then CompStatusMsg(msg, Settings.IncludeName, errError, IncludeLine, 0)
    else CompStatusMsg(msg, Settings.QuellName, errError, line, 0);
END;

FUNCTION FromStr(s:String):LONGINT;
VAR r:LONGINT;
    c:Integer;
BEGIN
     VAL(s,r,c);
     IF c<>0 THEN Error('Illegal numeric format');
     FromStr:=r;
END;

PROCEDURE ReadLine(VAR s:STRING);
BEGIN
     IF InInclude THEN
     BEGIN
          inc(IncludeLine);
          {$i-}
          ReadLn(IncludeFile,s);
          {$i+}
     END
     ELSE
     BEGIN
          inc(Line);
          {$i-}
          ReadLn(Quell,s);
          {$i+}
     END;
     IF Ioresult<>0 THEN Error('File read error');
END;

PROCEDURE WriteLine(s:STRING);
BEGIN
  if (Settings.CurrentLngInd=0) or
     (Settings.CurrentLngInd=Settings.CompForLngInd) then
    Begin
      {$i-}
      Writeln(Ziel,s);
      {$i+}
      IF ioresult<>0 THEN Error('File write error');
    End;
END;

PROCEDURE GetNumber(VAR n:LONGINT;VAR Line:STRING);
VAR s:STRING;
    p:BYTE;
BEGIN
     WHILE ((Line[1]=#32)AND(Line<>'')) DO delete(Line,1,1);
     p:=pos(' ',Line);
     IF p<2 THEN
       Begin
         Error('Number expected');
         exit;
       end;
     s:=Copy(Line,1,p-1);
     Delete(Line,1,p);
     WHILE Line[Length(Line)]=#32 DO dec(Line[0]);
     n:=FromStr(s);
END;


PROCEDURE ScanLink(VAR Line:STRING);FORWARD;


{tommy}
PROCEDURE GetCommand(Line:STRING;VAR command:BYTE;VAR para1,para2:STRING);
VAR t:BYTE;
    s:String;
    n:LONGINT;
    bb:byte;
    p:BYTE;
    add:STRING;

LABEL found,l;

BEGIN
     command:=0;
     IF pos(' ',Line)=0 THEN s:=Line
     ELSE s:=Copy(Line,1,pos(' ',Line)-1);
     FOR t:=1 TO length(s) DO s[t]:=upcase(s[t]);

     IF s='.TOPIC' THEN
     BEGIN
          delete(Line,1,6); {delete .TOPIC}
          GetNumber(n,Line);
          para1:=tostr(n);
          para2:=Line;  {Topic name}
          command:=HC_TOPIC;
          exit;
     END;
     IF s='.HIDDEN' THEN
     BEGIN
          delete(Line,1,7); {delete .HIDDEN}
          GetNumber(n,Line);
          para1:=tostr(n);
          para2:=Line;  {Topic name}
          command:=HC_HIDDEN;
          exit;
     END;
     IF s='.HCTX' THEN
     BEGIN
          command:=HC_HCTX;
          goto found;
     END;
     IF s='.REFBASE' THEN
     BEGIN
          command:=HC_REFBASE;
          goto found;
     END;

     IF s='.INDEX' THEN
     BEGIN
          command:=HC_INDEX;
          delete(Line,1,6);
          GetNumber(n,Line);
          para1:=tostr(n);
          para2:=Line;  {Index name}
          WHILE para2[Length(para2)]=#32 do
            dec(Para2[0]);
          exit;
     END;
     IF s='.MASTERINDEX' THEN
     BEGIN
          command:=HC_MASTERINDEX;
          goto found;
     END;
     IF s='.FIG' THEN
     BEGIN
          command:=HC_FIG;
          exit;
     END;
     IF s='.EFIG' THEN
     BEGIN
          command:=HC_EFIG;
          exit;
     END;
     IF s='.XMP' THEN
     BEGIN
          command:=HC_XMP;
          exit;
     END;
     IF s='.EXMP' THEN
     BEGIN
          command:=HC_EXMP;
          exit;
     END;
     IF s='.REAL' THEN
     BEGIN
          command:=HC_IPFC;
          goto found;
     END;
     IF s='.IPFC' THEN
     BEGIN
          command:=HC_IPFC;
          goto found;
     END;
     IF s='.HIGH' THEN
     BEGIN
          command:=HC_HIGH;
          goto found;
     END;
     IF s='.INCLUDE' THEN
     BEGIN
          command:=HC_INCLUDE;
          goto found;
     END;
     IF s='.TITLE' THEN
     BEGIN
          command:=HC_TITLE;
          goto found;
     END;
     IF s='.COLOR' THEN
     BEGIN
          command:=HC_COLOR;
          goto found;
     END;
     IF s='.ULIST' THEN
     BEGIN
          command:=HC_ULIST;
          goto found;
     END;
     IF s='.EULIST' THEN
     BEGIN
          command:=HC_EULIST;
          goto found;
     END;
     IF s='.SLIST' THEN
     BEGIN
          command:=HC_SLIST;
          goto found;
     END;
     IF s='.ESLIST' THEN
     BEGIN
          command:=HC_ESLIST;
          goto found;
     END;
     IF s='.OLIST' THEN
     BEGIN
          command:=HC_OLIST;
          goto found;
     END;
     IF s='.EOLIST' THEN
     BEGIN
          command:=HC_EOLIST;
          goto found;
     END;
     IF s='.DLIST' THEN
     BEGIN
          command:=HC_DLIST;
          goto found;
     END;
     IF s='.EDLIST' THEN
     BEGIN
          command:=HC_EDLIST;
          goto found;
     END;
     IF s='.DTERM' THEN
     BEGIN
          command:=HC_DTERM;
          goto found;
     END;
     IF s='.DDESC' THEN
     BEGIN
          command:=HC_DDESC;
          goto found;
     END;

     IF s='.LISTITEM' THEN
     BEGIN
          command:=HC_LISTITEM;
          goto found;
     END;
     IF s='.BITMAP' THEN
     BEGIN
          command:=HC_BITMAP;
          goto found;
     END;

     if s='.SET_INCFILENAME' then
       begin
         command:=HC_SET_INCFILENAME;
         goto found;
       end;

     if s='.SET_LANG' then
       begin
         command:=HC_SET_LANG;
         goto found;
       end;

     if s='.BOLD' then
       Begin
         command:=HC_BOLD;
         goto found;
       end;

     if s='.UNDERLINE' then
       Begin
         command:=HC_UNDERLINE;
         goto found;
       End;

     if s='.BOLD_UNDERLINE' then
       Begin
         command:=HC_BOLD_UNDERLINE;
         goto found;
       End;

     exit;
found:
     delete(Line,1,length(s));
     para1:=Line;
     WHILE ((para1[1]=#32)AND(para1<>'')) DO delete(para1,1,1);
     WHILE para1[Length(para1)]=#32 do dec(Para1[0]);

     add := '';
     IF command = HC_IPFC THEN {Scanne nicht das IPFC Kommando}
     BEGIN
          p := pos('.',Para1);
          IF p > 0 THEN
          BEGIN
               add := copy(Para1,1,p);
               delete(Para1,1,p);
          END;
     END;

     WHILE pos('{',Para1) <> 0 DO ScanLink(Para1);
     Para1 := add + Para1;

l:
     bb:=pos('&bslash.#1',para1);
     IF bb<>0 THEN
     BEGIN
          Delete(para1,bb,9);
          para1[bb]:='{';
          goto l;
     END;
     bb:=pos('&bslash.#2',para1);
     IF bb<>0 THEN
     BEGIN
          Delete(para1,bb,9);
          para1[bb]:='}';
          goto l;
     END;
     bb:=pos('\#1',para1);
     IF bb<>0 THEN
     BEGIN
          Delete(para1,bb,2);
          para1[bb]:='{';
          goto l;
     END;
     bb:=pos('\#2',para1);
     IF bb<>0 THEN
     BEGIN
          Delete(para1,bb,2);
          para1[bb]:='}';
          goto l;
     END;
END;

FUNCTION NewRef(s:STRING):LONGINT;
VAR dummy: PRefList;
    t    : BYTE;
label l,l1;
BEGIN
     for t:=1 to length(s) do s[t]:=upcase(s[t]);
     IF RefList=NIL THEN
     BEGIN
          New(reflist);
          dummy:=reflist;
     END
     ELSE
     BEGIN
          dummy:=reflist;
          WHILE dummy^.Next<>NIL DO
          BEGIN
               if dummy^.refname=s THEN goto l;
               dummy:=dummy^.next;
          END;
          IF dummy^.refname=s THEN
          BEGIN
l:
               IF dummy^.defined THEN
                 Begin
                   Error('Duplicate topic: '+s);
                   exit;
                 end;
               dummy^.defined:=TRUE;
               goto l1;
          END;
          New(dummy^.Next);
          dummy:=dummy^.Next;
     END;

     RefBaseUsed := TRUE;
     dummy^.Refid:=RefBase+RefCount;
     inc(RefCount);
     dummy^.Next:=NIL;
     dummy^.RefName:=s;
     dummy^.defined:=TRUE;
l1:
     NewRef:=dummy^.refid;
END;

procedure DeleteRef;

var dummy, dummyNext: PRefList;

Begin
  dummyNext:=refList;
  while dummyNext^.Next<>NIL DO
    begin
      dummy:=dummyNext;
      dummyNext:=dummyNext^.Next;
      dispose(dummy);
    End;
  reflist:=nil;
End;

PROCEDURE SearchLink(Link:STRING;VAR ref:LONGINT);
VAR
   dummy:PRefList;
   t:BYTE;
BEGIN
     for t:=1 to length(link) do link[t]:=upcase(link[t]);
     IF RefList=NIL THEN
     BEGIN
          New(RefList);
          dummy:=RefList;
     END
     ELSE
     BEGIN
          dummy:=RefList;
          WHILE dummy^.Next<>NIL DO
          BEGIN
               IF dummy^.refname=link THEN
               BEGIN
                    ref:=dummy^.refid;
                    exit;
               END;
               dummy:=dummy^.next;
          END;
          IF dummy^.refname=link THEN
          BEGIN
               ref:=dummy^.refid;
               exit;
          END;
          new(DUMMY^.Next);
          dummy:=dummy^.next;
     END;

     RefBaseUsed := TRUE;
     dummy^.Refid:=RefBase+RefCount;
     inc(RefCount);
     dummy^.Next:=NIL;
     dummy^.RefName:=link;
     dummy^.defined:=FALSE;
     ref:=dummy^.Refid;
END;


PROCEDURE ScanLink(VAR Line:STRING);
VAR t,t1:BYTE;
    s,s1,s2,link,link1:STRING;
    ref:LONGINT;
    p:BYTE;
Label ll,ll1;
BEGIN
     t:=pos('{',Line);
     t1:=pos('}',Line);
     IF t1<t THEN
       Begin
         Error('Illegal link');
         exit;
       end;
     s:=copy(Line,1,t-1);
     link:=copy(Line,t+1,(t1-t)-1);
     IF pos(':',link)=0 THEN
     BEGIN
          link1:=link;
          s1:=copy(Line,t1+1,length(Line)-t1);
          SearchLink(link1,ref);
          p:=pos('.',link);
          IF p<>0 THEN
          BEGIN
               delete(link,p,1);
               insert('&per.',link,p);
          END;
          link:=':link reftype=hd res='+tostr(ref)+'.'+link+':elink.';
     END
     ELSE
     BEGIN
          link1:=link;
          link:=copy(link,1,pos(':',link)-1);
          Delete(Link1,1,pos(':',link1));
          s1:=copy(Line,t1+1,length(Line)-t1);
          SearchLink(link1,ref);
          p:=pos('.',link);
          IF p<>0 THEN
          BEGIN
               delete(link,p,1);
               insert('&per.',link,p);
          END;
          link:=':link reftype=hd res='+tostr(ref)+'.'+link+':elink.';
     END;

     s2:=s; {search for :}
     s:='';
ll:
     p:=Pos(':',s2);
     IF p<>0 THEN
     BEGIN
          s:=s+copy(s2,1,p-1);
          IF (pos(':link ',s2)=p) OR (pos(':elink.',s2)=p)
          THEN s:=s+':'
          ELSE s:=s+'&colon.';
          delete(s2,1,p);
          goto ll;
     END
     ELSE s:=s+s2;

     IF pos('{',s1)=0 THEN
     BEGIN
ll1:
          p:=Pos(':',s1);
          IF p<>0 THEN
          BEGIN
               delete(s1,p,1);
               insert('&colon.',s1,p);
               goto ll1;
          END;
     END;
     Line:=s+link+s1;
END;

function StripHeading(var S: string): string;
var
  P: LongInt;
begin
  P := Pos(':', S);
  if P = 0 then Result := S
  else
  begin
    Result := Copy(S, 1, P - 1);
    Delete(S, 1, P);
  end;
end;

Function Compile : Boolean;

VAR Line:STRING;
    p,t,t1,t2:BYTE;
    command,bb:BYTE;
    para1,para2,s,heading:STRING;
    LastHeading:STRING;
    Ref:LONGINT;
    dummy:PRefList;
    done:BOOLEAN;
    c:INTEGER;
    d,n,e:STRING;
    K:TEXT;
    KonstName:STRING;
    i:LONGINT;
    K0,K1:STRING;
    cb:LONGINT;
    Index : LongInt;
    KonstantenMaxStr:Byte;
    KonstStr : String;
    Konstanten   : TStringList;
    Topics       : TStringList;

Label l,l1,ll_l;

BEGIN
  Result:=false;
  Konstanten.Create;
  Topics.Create;
  RefBase := 1;
  RefBaseUsed := FALSE;
  KonstantenMaxStr:=0;

  WriteLine(':userdoc.');
  WriteLine(':docprof.');
  InInclude:=FALSE;
  Done:=FALSE;
  WHILE not Done DO
    BEGIN
      ReadLine(Line);
//      CompStatusMsg('Read: ' + Line,'',errNone,0,0);  // Leerzeile

      IF Line='' THEN
        BEGIN
          {Blank line}
          WriteLine(':p.');  {Paragraph}
          goto l1;
        END;

      IF Line[1]='.' THEN
        BEGIN
          GetCommand(Line,command,para1,para2);
          CASE command OF
            HC_INCLUDE:
              BEGIN
                IF InInclude THEN
                  Begin
                    Error('Illegal nested include');
                    exit;
                  end;
                InInclude:=TRUE;
                Settings.IncludeName:=Para1;
                IncludeLine:=1;
                Assign(Includefile,Settings.IncludeName);
                {$i-}
                reset(Includefile);
                {$i+}
                IF ioresult<>0 THEN
                  Begin
                    Error('Could not open:'+para1);
                    Exit;
                  End;
                goto l1;
              END;

            HC_TOPIC:
              BEGIN
                WriteLine('');
                heading := StripHeading(para2);
                // WriteLn('Topic: ', heading);
                Ref:=NewRef(para2);
                p:=pos('.',para2);
                IF p<>0 THEN
                  BEGIN
                    delete(para2,p,1);
                    insert('&per.',para2,p);
                  END;
                IF pos(' ',para2)=0
                  THEN
                    BEGIN
                       IF pos('.',para2)=0
                         THEN WriteLine(':h'+para1+' global name='+para2+' res='+
                                 tostr(ref)+'.'+heading)
                         ELSE WriteLine(':h'+para1+' global res='+
                                 tostr(ref)+'.'+heading);
                    END
                  ELSE WriteLine(':h'+para1+' global res='+
                               tostr(ref)+'.'+heading);
                LastHeading := heading;
              END;

            HC_HIDDEN:
              BEGIN
                WriteLine('');
                heading := StripHeading(para2);
                // WriteLn('Topic: ', heading);
                Ref:=NewRef(para2);
                p:=pos('.',para2);
                IF p<>0 THEN
                  BEGIN
                    delete(para2,p,1);
                    insert('&per.',para2,p);
                  END;
                IF pos(' ',para2)=0 THEN
                  BEGIN
                    IF pos('.',para2)=0
                      THEN WriteLine(':h'+para1+' hide global name='+para2+' res='+
                              tostr(ref)+'.'+heading)
                      ELSE WriteLine(':h'+para1+' hide global res='+
                              tostr(ref)+'.'+heading);
                  END
                ELSE WriteLine(':h'+para1+' hide global res='+
                               tostr(ref)+'.'+heading);
                LastHeading := heading;
              END;
            HC_HCTX:
              BEGIN
                // benutze 'para1' als Konstantenname;
                K0 := para1;
                UpcaseStr(K0);
                FOR i := 0 TO Konstanten.Count-1 DO
                  BEGIN
                    K1 := Konstanten[i];
                    UpcaseStr(K1);
                    IF K1 = K0 THEN
                      BEGIN
                        Error('Duplicate Constant identifier: '+para1);
                        exit;
                      END;
                  END;
                if length(para1) > KonstantenMaxStr
                  then KonstantenMaxStr:=length(para1);
                Konstanten.Add(para1);
                Topics.Add(LastHeading)
              END;

            HC_REFBASE:
              BEGIN
                // benutze 'para1' als Basis fÅr die Referenzen;
                IF not RefBaseUsed
                  THEN
                    BEGIN
                      val(para1,RefBase,c);
                      IF c <> 0 THEN RefBase := 1;
                    END
                  ELSE CompStatusMsg('.REFBASE will be ignored','',errNone,0,0);
              END;

            HC_FIG:WriteLine(':fig.');
            HC_EFIG:WriteLine(':efig.');
            HC_XMP:WriteLine(':xmp.');
            HC_EXMP:WriteLine(':exmp.');
            HC_IPFC:WriteLine(para1);

            HC_INDEX:
              BEGIN
                p:=pos('.',para2);
                IF p<>0 THEN
                  BEGIN
                    delete(para2,p,1);
                    insert('&per.',para2,p);
                  END;
                WriteLine(':i'+para1+' refid=fvhelp.'+para2);
              END;

            HC_MASTERINDEX:WriteLine(':i1 id=fvhelp.'+para1);

            HC_HIGH:
              BEGIN
                WriteLine(':cgraphic.');
                s:='';
                FOR p:=1 TO length(Para1) DO s:=s+#220;
                WriteLine(' '+s);
                WriteLine(' '+para1);
                s:='';
                FOR p:=1 TO length(para1) DO s:=s+#223;
                WriteLine(' '+s);
                WriteLine(':ecgraphic.');
              END;

            HC_TITLE:
              BEGIN
                if Paramlist.Find('T',Index) then  {ignore not .title}
                  WriteLine(':title.'+Para1);
              END;

            HC_BOLD:
              WriteLine(':hp2.'+Para1+':ehp2.');

            HC_UNDERLINE:
              WriteLine(':hp5.'+Para1+':ehp5.');

            HC_BOLD_UNDERLINE:
              WriteLine(':hp7.'+Para1+':ehp7.');

            HC_COLOR:
              BEGIN
                WriteLine(':color '+Para1+'.');
              END;
            HC_ULIST:
              BEGIN
                WriteLine(':ul '+Para1+'.');
              END;
            HC_EULIST:
              BEGIN
                WriteLine(':eul.');
              END;
            HC_SLIST:
              BEGIN
                WriteLine(':sl '+Para1+'.');
              END;
            HC_ESLIST:
              BEGIN
                WriteLine(':esl.');
              END;
            HC_OLIST:
              BEGIN
                WriteLine(':ol '+Para1+'.');
              END;
            HC_EOLIST:
              BEGIN
                WriteLine(':eol.');
              END;
            HC_DLIST:
              BEGIN
                WriteLine(':dl break=all tsize=3'+Para1+'.');
              END;
            HC_EDLIST:
              BEGIN
                WriteLine(':edl.');
              END;
            HC_DTERM:
              BEGIN
                WriteLine(':dt.'+Para1);
              END;
            HC_DDESC:
              BEGIN
                WriteLine(':dd.'+Para1);
              END;

            HC_LISTITEM:
              BEGIN
                WriteLine(':li.'+Para1);
              END;
            HC_BITMAP:
              BEGIN
                WriteLine(':artwork runin name='#39+Para1+#39'.');
              END;


{ Diverse Sets }
            HC_SET_INCFILENAME:
              Begin
                if IncFilename=''
                  then IncFilename:=para1
                  else CompStatusMsg('.INCFILENAME will be ignored','',errNone,0,0);
              End;

            HC_SET_LANG:
              Begin
                if Settings.Language.Find(para1,Settings.CurrentLngInd)=false then
                  Begin
                    Error('Illegal language ('+para1+')');
                    exit;
                  End;
                Writeln('Language:', para1,',',Settings.CurrentLngInd);
              End;



            ELSE
              Begin
                Error('Illegal command (' + Line + ')');
                exit;
              end;
          END; {case}
          goto l1; {Overread Topic command}
        END;

      IF pos('{',Line)<>0 THEN
        BEGIN
          WHILE pos('{',Line)<>0 DO ScanLink(Line);
          goto l;
        END;
      t1:=1;
ll_l:
      FOR t:=1 TO MaxTransTable DO
        BEGIN
          p:=0;
          FOR t2:=t1 TO length(line) DO
            BEGIN
              IF line[t2]=TransTable[t].ch THEN
                BEGIN
                  p:=t2;
                  t2:=length(line);
                END;
            END;
          IF p<>0 THEN
            BEGIN
              delete(Line,p,1);
              insert(TransTable[t].repl,Line,p);
              t1:=p+length(TransTable[t].repl);
              goto ll_l;
            END;
        END;
l:
      bb:=pos('&bslash.#1',line);
      IF bb<>0 THEN
        BEGIN
          Delete(Line,bb,9);
          Line[bb]:='{';
          goto l;
        END;
      bb:=pos('&bslash.#2',line);
      IF bb<>0 THEN
        BEGIN
          Delete(Line,bb,9);
          Line[bb]:='}';
          goto l;
        END;
      bb:=pos('\#1',line);
      IF bb<>0 THEN
        BEGIN
          Delete(Line,bb,2);
          Line[bb]:='{';
          goto l;
        END;
      bb:=pos('\#2',line);
      IF bb<>0 THEN
        BEGIN
          Delete(Line,bb,2);
          Line[bb]:='}';
          goto l;
        END;

      {FARBE}
      WHILE pos('Ô',Line) <> 0 DO
        BEGIN
          p := pos('Ô',Line);
          WriteLine(copy(Line,1,p-1));
          delete(Line,1,p);
          UseExtraColor := not UseExtraColor;
          IF UseExtraColor
            THEN WriteLine(':color '+ExtraColor+'.')
            ELSE WriteLine(':color '+NormalColor+'.');
        END;

      WriteLine(Line);

l1:
      IF InInclude
        THEN
          BEGIN
            IF Eof(IncludeFile) THEN
              BEGIN
                Close(IncludeFile);
                InInclude:=FALSE;
                IF Eof(Quell) THEN done:=TRUE;
              END;
           END
        ELSE IF Eof(Quell) THEN done:=TRUE;
    END;

  WriteLine(':euserdoc.');

  if Paramlist.Find('I',Index) then  {dont ignore not defined topics}
    BEGIN
      dummy:=RefList;
      WHILE dummy<>NIL DO
        BEGIN
          IF not dummy^.defined THEN
            Begin
              Error('Topic not defined: '+dummy^.refname);
              exit;
            end;
          dummy:=dummy^.Next;
        END;
  END;

  {Schreibe Konstantendatei raus}
  IF Konstanten.Count > 0 THEN
    BEGIN
      FSplit(FExpand(Settings.QuellName),d,n,e);
      if IncFilename=''
        then konstname := d + n + '.inc'
        else konstname := d + IncFilename;
      CompStatusMsg('Generating Constants File: '+KonstName,'',errNone,0,0);
      {$I-}
      Assign(K, KonstName);
      Rewrite(K,1);
      writeln(K, '/* Constants of ',Settings.QuellName,' */');
      writeln(K, '/*       Output ',KonstName,' */');
      writeln(K, '');
      writeln(K, 'CONST');
      FOR i := 0 TO Konstanten.Count-1 DO
        BEGIN
          SearchLink(Topics[i],cb);
          KonstStr:=Konstanten[i];
          writeln(K, '  ', KonstStr,
                  FillString(KonstantenMaxStr-length(KonstStr),' '),
                  ' = ', cb, ';');
        END;
      writeln(K, '');
      Close(K);
      {$I+}
    END;

// Alles compiliert
  Konstanten.Destroy;
  Topics.Destroy;

  Result:=true;
END;

Procedure SetLanguage(iParameter : String);

var Temp : String;
    Index    : LongInt;

Begin
  if iParameter[2]='='
    then
      Begin
        Temp:=copy(IParameter,3,255);
        Settings.Language.addSplit(Temp,',');
        for Index:=1 to Settings.Language.Count-1 do
          Begin
            Temp:=Settings.Language.Strings[Index];
            if (Temp<>'DE') and (Temp<>'EN') and (Temp<>'NL') then
              Begin
                CompStatusMsg('Error: Unknown Language: '+Temp,'',errNone,0,0);
                ErrFound:=true;
                exit;
              End;
          End;
      End
    else
      Begin
        CompStatusMsg('Error: Unknown Parameter: '+iParameter,'',errNone,0,0);
        ErrFound:=true;
        exit;
      End;
End;


Procedure ReadParameters(iPasParams:TPasParams; iPasReturn:TPasReturn);

Var Parameter: String;
    Index    : LongInt;

Label ParamErr;

Begin
  fillchar(Settings, sizeof(tSettings), #0);
  Settings.Language.Create;
//  if Settings.Language.Count=0 then
  Settings.Language.Add(cLangAll);

// Parameter analysieren
  Parameter:=Uppercase(iPasParams.Params);
  ParamList.Create;
  ParamList.AddSplit(Parameter,' ');

  if ParamList.Count=0 then
    Begin
      Settings.CompSystem:=goSysInfo.OS.System;
      exit;
    end;
  For Index:=0 to Paramlist.Count-1 do
    Begin
      Parameter:=ParamList.Strings[Index];
      if Parameter='' then continue;
      if Parameter[1]='-'
        then
          Begin
            Parameter:=Copy(Parameter,2,255);
            if (Parameter='W32') or (Parameter='WIN32')
              then Settings.CompSystem:=Win32
            else if Parameter = 'OS2'
              then Settings.CompSystem:=OS2
            else if Parameter='P'                 // Pause nach der Compilierung
              then Settings.WaitAfterPrg:=true
            else if Parameter[1] = 'L'            // Sprache definieren
              then SetLanguage(Parameter)
            else goto ParamErr;
          End
        else
          Begin
ParamErr:
            CompStatusMsg('Error: Unknown Parameter: '+Parameter,'',errNone,0,0);
            ErrFound:=true;
          End;
      if ErrFound then
        exit;
    End;

  CompStatusMsg('   for system: '+cSystem[ord(Settings.CompSystem)],'',errNone,0,0);
  for Index:=0 to Settings.Language.Count-1 do
    CompStatusMsg('   for Language: '+ Settings.Language.Strings[Index],'',errNone,0,0);
End;


Procedure InvokeHlp(var iPasParams:TPasParams;VAR iPasReturn:TPasReturn);

var FilePath, FileName, FileExt : String;
    CompForLng   : tStr2;

Begin
  Line:=0;
  RefList:=NIL;
  RefCount:=0;
  ErrFound:=false;

  CompStatusMsg:=iPasParams.MsgProc;
  CompStatusMsg('WDSibyl Help Compiler Version ' + cVersion,'',errNone,0,0);
  CompStatusMsg('Parameters: '+iPasParams.Params,'',errNone,0,0);
  CompStatusMsg('Compiling:  '+iPasParams.Quell,'',errNone,0,0);

  ReadParameters(iPasParams, iPasReturn);
  if ErrFound then exit;

// Gloabele Variablen und Pfade definieren
  FSplit(iPasParams.Quell, FilePath, FileName, FileExt);

  Settings.QuellName:=iPasParams.Quell;
  WorkPath:=FilePath;
  WorkPath[0]:=chr(ord(WorkPath[0])-1);    // Der String darf nicht mit "\" enden
  CompStatusMsg('WorkPath: '+WorkPath,'',errNone,0,0);
  chDir(WorkPath);

 // Output-Verzeichniss wurde angegeben
  if iPasParams.Out<>'' then // Output-Verzeichniss wurde angegeben
    WorkPath:=iPasParams.Out;

  For Settings.CompForLngInd:=1 to Settings.Language.Count-1 do
    Begin
      CompForLng:=Settings.Language.Strings[Settings.CompForLngInd];
      Settings.CurrentLngInd:=0;  // Text fuer alle Sprachen

      Settings.ZielName:=WorkPath+'\'+FileName;
      if CompForLng<>cLangAll then
        Settings.ZielName:=Settings.ZielName+'_'+CompForLng;
      Settings.ZielName:=Settings.ZielName+EXT_UC_IPF;
      CompStatusMsg('','',errNone,0,0);  // Leerzeile
      CompStatusMsg('OutputFile: '+Settings.ZielName,'',errNone,0,0);

      try
        Assign(quell,Settings.quellname);
        {$i-}
        reset(quell);
        {$i+}
        IF ioresult=0
          then
            Begin
              Assign(ziel,Settings.Zielname);
              {$i-}
              Rewrite(Ziel);
              {$i+}
              IF ioresult=0
                then
                  Begin
                    CompStatusMsg('Compiling...','',errNone,0,0);
                    if (Compile) and (ErrFound=false)
                      then CompStatusMsg('Compile successful !','',errNone,0,0);
                  End
                else CompStatusMsg(cErrCouldNotOpen+Settings.ZielName, '', errNone,0,0);
            End
          else CompStatusMsg(cErrCouldNotOpen+Settings.QuellName, '', errNone,0,0);

      except
        ON E:Exception DO
          CompStatusMsg('Internal Error: ' + E.Message, '', errNone,0,0);
      end;

    // Dateien wieder schliessen
      Close(Quell);
      Close(Ziel);
      CompStatusMsg('Files closed','',errNone,0,0);
      DeleteRef;

// Bei einem Fehler die IPF-Datei wieder loeschen
      if ErrFound then
        Begin
          DeleteFile(Settings.ZielName);
          break;  // Language-For-Schleife verlassen
        End;

    End;   // Language-For-Schleife

// Objekte loeschen
  Settings.Language.Destroy;
  if Settings.WaitAfterPrg then
    Begin
      CompStatusMsg('','',errNone,0,0);
      CompStatusMsg('Press any key.','',errNone,0,0);
      Readkey;
    end;            

  iPasReturn.Error:=ErrFound;
End;

begin
end.

{ -- date --- --from-- -- changes ----------------------------------------------
  11-Apr-2005 WD       Design-Aufbereitung der Include-Datei
  23-Dez-2005 WD       Sprache: NiederlÑndisch hinzugefÅgt
  28-Feb-2008 WD       Topic UNDERLINE und BOLD_UNDERLINE eingebaut
}

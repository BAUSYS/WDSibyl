unit Cache;

INTERFACE

uses dos,crt;

CONST
     maxcachefiles=10;
     mincacheamount=1024;
     maxcacheamount=63488;
     cerrorok=0;
     cerrornotinfile=1;
     cerrortoomanyfiles=2;
     cerrorclosed=3;
     cerrornomemory=4;
     cerrorcacheamount=5;
     cerrorother=99;

type
    cachefile=1..MaxCacheFiles;
    topentype=(corewrite,coreset,coappend);
    tbitpos=BYTE;
    tbitsize=BYTE;

var cacheioresult:BYTE;

FUNCTION cachefilepos(nr:CacheFile):LONGINT;
FUNCTION cacheeof(nr:CacheFile):BOOLEAN;
PROCEDURE cacheseek(nr:CacheFile;Pos:LONGINT);
PROCEDURE cacherewrite(var nr:CacheFile;fname:STRING; cache:word);
PROCEDURE cachereset(var nr:CacheFile;fname:STRING; cache:word);
PROCEDURE cacheappend(var nr:CacheFile;fname:STRING; cache:word);
PROCEDURE cacheerase(fname:STRING);
PROCEDURE cacheclose(var nr:CacheFile);
PROCEDURE cacheclose1(var nr:CacheFile);
PROCEDURE cacheread(nr:CacheFile; var value:BYTE);
PROCEDURE cachereadext(nr:CacheFile; var value; l:word);
PROCEDURE cachewrite(nr:CacheFile;value:BYTE);
PROCEDURE cachewriteext(nr:CacheFile; var value; l:word);
PROCEDURE cachewritestring(nr:CacheFile; var value; l:word);
PROCEDURE cacheexit;
FUNCTION cacheopen(fname:STRING;task:topentype;cacheamount:word):BYTE;
PROCEDURE CacheGetFTime(nr:CacheFile; var year,month,day,hour,min,sec:WORD);
FUNCTION Cachefilesize(nr:CacheFile):LONGINT;
PROCEDURE CacheInit;

IMPLEMENTATION

type
     treadorwrite=(_Read,_Write);
     BufferPointer=^PBufferPointer;
     PBufferPointer=ARRAY[0..65500] OF BYTE;

var
   filedata:ARRAY[0..MaxCacheFiles] OF
   RECORD
     block,lblock:LONGINT;
     offset,loffset:LONGINT;
     bitpos:tbitpos;
     changed:BOOLEAN;
     p:BufferPointer;
     maxcachemem:LONGINT;
     f:FILE;
   END;

PROCEDURE cacheinit;

var i:CacheFile;

BEGIN
  FOR i:=1 to maxcachefiles DO with filedata[i] DO p:=NIL;
  cacheioresult:=cerrorok;
END;

PROCEDURE CacheGetFTime(nr:CacheFile;var year,month,day,hour,min,sec:WORD);
VAR time:LONGINT;
    dt:datetime;
BEGIN
  {$i-}
  GetFTime(filedata[nr].f,time); 
  {$i+}
  IF doserror=0 THEN
  BEGIN
       cacheioresult:=cerrorok;
       Unpacktime(time,dt);
       year:=dt.year;
       month:=dt.month;
       day:=dt.day;
       hour:=dt.hour;
       min:=dt.min;
       sec:=dt.sec;
  END
  ELSE cacheioresult:=cerrorclosed;
END;

PROCEDURE expand(nr:CacheFile);
BEGIN
  with filedata[nr] DO
    BEGIN
      inc(loffset);
      IF loffset=maxcachemem THEN
        BEGIN
          inc(lblock); 
          loffset:=0; 
        END; 
    END; 
END;

FUNCTION cachefilepos(nr:CacheFile):LONGINT;
BEGIN
  with filedata[nr] DO cachefilepos:=block*maxcachemem+offset;
END;

FUNCTION Cachefilesize(nr:CacheFile):LONGINT;
BEGIN
  with filedata[nr] DO
    cachefilesize:=lblock*maxcachemem+loffset;
END;

PROCEDURE cblockio(nr:CacheFile;
blocknr:BYTE; task:treadorwrite);
var l:LONGINT;
    po:LONGINT;
BEGIN
  with filedata[nr] DO
    BEGIN
      IF changed THEN
      BEGIN
          changed:=FALSE;
          cblockio(nr,block,_Write);
          IF cacheioresult>cerrorok THEN Exit;
      END;
      IF blocknr=lblock THEN l:=loffset
      ELSE l:=maxcachemem;
      po:=maxcachemem;
      po:=po*blocknr;
      {$i-}
      Seek(f,po);
      {$i+}
      cacheioresult:=ioresult;
      IF l>0 THEN IF cacheioresult=0 THEN
      BEGIN
        CASE task OF
          {$i-}
          _Write:BlockWrite(f,p^,l);
          _Read :BlockRead(f,p^,l);
          {$i+}
        END; {case}
        cacheioresult:=ioresult;
      END;
    END;
END;


FUNCTION cacheeof(nr:CacheFile):BOOLEAN;
BEGIN
     with filedata[nr] DO cacheeof:=(offset=loffset)AND(block=lblock);
END;


PROCEDURE cacheseek(nr:CacheFile;Pos:LONGINT);
var
    pblock:Word;
    poffset:word;
BEGIN
  cacheioresult:=cerrorok;
  with filedata[nr] DO
    BEGIN
      pblock:=Pos DIV maxcachemem;
      poffset:=Pos MOD maxcachemem;
      IF Pos>loffset+maxcachemem*lblock
      THEN
      BEGIN
          cacheioresult:=cerrornotinfile;
          Exit;
      END;
      IF pblock<>block THEN cblockio(nr,pblock,_Read);
      bitpos:=0;
      offset:=poffset;
      block:=pblock;
    END;
END;

PROCEDURE cacheseekbit(nr:CacheFile;
bit:tbitpos);
BEGIN
  with filedata[nr] DO
  BEGIN
      bitpos:=bit;
      IF cacheeof(nr) THEN expand(nr);
  END;
END;

FUNCTION cacheopen(fname:STRING;task:topentype;cacheamount:word):BYTE;
var
   l:LONGINT;
   nr:BYTE;
LABEL l1;
BEGIN
  nr:=1;
  cacheioresult:=cerrorok;
  while(filedata[nr].p<>NIL)AND(nr<=maxcachefiles+1) DO inc(nr);
  IF nr>maxcachefiles THEN
  BEGIN
      cacheioresult:=cerrortoomanyfiles;
      Exit;
  END;
  cacheopen:=nr;

  IF(cacheamount>maxcacheamount)OR(cacheamount<mincacheamount)
  THEN
    BEGIN
      cacheioresult:=cerrorcacheamount;
      Exit;
    END;
  with filedata[nr] DO
    BEGIN
      maxcachemem:=cacheamount;
      IF maxavail<maxcachemem THEN
        BEGIN
l1:
             runerror(255);
        END;
      Assign(f,fname);
      changed:=FALSE;
      bitpos:=0;
      {$i-}
      CASE task OF
        corewrite:Rewrite(f,1);
        coAppend,coreset:Reset(f,1);
      END; {case}
      {$i+}
      cacheioresult:=ioresult;
      IF cacheioresult>cerrorok THEN Exit;
      l:=filesize(f);
      lblock:=l DIV maxcachemem;
      loffset:=l MOD maxcachemem;
      IF maxavail<maxcachemem THEN RunError(RunError_NoError);
      getmem(p,maxcachemem);
      IF p=NIL THEN
      BEGIN
            WriteLn('memallocseg Pointer is NIL');
            GOTO l1;
      END;
      IF task<>coappend THEN
        BEGIN
          cblockio(nr,0,_Read);
          block:=0; 
          offset:=0; 
        END
      ELSE
        BEGIN
          cblockio(nr,lblock,_Read);
          block:=lblock;
          offset:=loffset;
        END;
    END;
END;


PROCEDURE cacherewrite(var nr:CacheFile;
fname:STRING; cache:word);
BEGIN
  nr:=cacheopen(fname,corewrite,cache);
END;


PROCEDURE cachereset(var nr:CacheFile;fname:STRING; cache:word);
BEGIN
  nr:=cacheopen(fname,coreset,cache);
END;


PROCEDURE cacheappend(var nr:CacheFile;fname:STRING; cache:word);
BEGIN
  nr:=cacheopen(fname,coappend,cache);
END;



PROCEDURE cacheerase(fname:STRING);
var f:FILE;
BEGIN
  {$i-}
  Assign(f,fname);
  IF ioresult>0 THEN
    BEGIN
      cacheioresult:=ioresult;
      Exit;
    END;
  Erase(f);
  {$i+}
  cacheioresult:=ioresult;
END;


PROCEDURE cacheclose(var nr:CacheFile);
BEGIN
  IF nr=maxcachefiles THEN exit;
  IF filedata[nr].p=NIL THEN
    BEGIN
      cacheioresult:=cerrorclosed;
      Exit;
    END; 
  with filedata[nr] DO
    BEGIN
      IF changed THEN
        BEGIN
          changed:=FALSE; 
          cblockio(nr,block,_Write);
        END; 
      {$i-}
      Close(f);
      {$i+}
      cacheioresult:=ioresult;
      {if cioresult>0 then exit;}
      FreeMem(p,maxcachemem);
      p:=NIL;
    END;
  nr:=maxcachefiles;
END;


PROCEDURE cacheclose1(var nr:CacheFile);
BEGIN
  IF nr=maxcachefiles THEN exit;
  IF filedata[nr].p=NIL THEN
    BEGIN
      cacheioresult:=cerrorclosed;
      Exit;
    END; 
  with filedata[nr] DO
    BEGIN
      {$i-}
      Close(f); 
      {$i+}
      cacheioresult:=ioresult;
      {if cioresult>0 then exit;}
      FreeMem(p,maxcachemem); 
      p:=NIL; 
    END; 
  nr:=maxcachefiles;
END;


PROCEDURE cacheread(nr:CacheFile; var value:BYTE);

BEGIN
  IF cacheeof(nr) THEN
    BEGIN
      cacheioresult:=cerrornotinfile;
      Exit;
    END;
  with filedata[nr] DO
    BEGIN
      value:=p^[offset];
      inc(offset);
      IF offset=maxcachemem THEN
        BEGIN
          cblockio(nr,block+1,_Read);
          offset:=0;
          inc(block);
        END;
    END;
END;


PROCEDURE cachereadext(nr:CacheFile; var value; l:word);
var t:word;
    v:Bufferpointer;
BEGIN
  IF l=0 THEN exit;
  v:=Bufferpointer(@value);
  FOR t:=0 to l-1 DO cacheread(nr,v^[t]);
END;


PROCEDURE cachewrite(nr:CacheFile;value:BYTE);
BEGIN
    WITH filedata[nr] DO
    BEGIN
      IF value<>p^[offset] THEN
        BEGIN
          p^[offset]:=value;
          changed:=true;
        END;
      IF cacheeof(nr) THEN
        BEGIN
          changed:=true;
          expand(nr);
        END; 
      inc(offset); 
      IF offset=maxcachemem THEN
        BEGIN
          changed:=FALSE;
          {alten Block Schreiben}
          cblockio(nr,block,_Write);
          {neuen Block lesen}
          offset:=0;
          inc(block);
          cblockio(nr,block,_Read);
        END;
    END;
END;


PROCEDURE cachewriteext(nr:CacheFile; var value; l:word);
var
    t:word;
    v:Bufferpointer;
BEGIN
  IF l=0 THEN exit;
  v:=BufferPointer(@value);
  FOR t:=0 to l-1 DO cachewrite(nr,v^[t]);
END;


PROCEDURE cachewritestring(nr:CacheFile; var value; l:word);
var
    t:word;
    v:Bufferpointer;
BEGIN
  v:=BufferPointer(@value);
  FOR t:=0 to l-1 DO
    BEGIN
      cachewrite(nr,v^[t+1]);
      IF cacheioresult<>0 THEN Exit;
    END; 
END; 




var exitsave:pointer;


PROCEDURE cacheexit;
var
   i:CacheFile;
BEGIN
  exitproc:=exitsave;
  FOR i:=1 to maxcachefiles DO
    with filedata[i] DO IF p<>NIL THEN
      FreeMem(p,maxcachemem);
END;

BEGIN
  {filemode:=2;}
  exitsave:=exitproc;
  exitproc:=@cacheexit;
  cacheinit;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
}
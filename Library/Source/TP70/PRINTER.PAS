
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Runtime Library                                                 บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT Printer;
                 
INTERFACE

VAR Lst:TEXT;

IMPLEMENTATION

VAR PrinterExit:POINTER;

PROCEDURE NewExit;
BEGIN
     ExitProc:=PrinterExit;
     {$i-}
     Close(Lst);
     {$i+}
END;

BEGIN
     PrinterExit:=ExitProc;
     ExitProc:=@NewExit;
     Assign(Lst,'LPT1');
     {$i-}
     reset(Lst);
     If InOutRes<>0 then writeln('Can''t open printer-port: LPT1');
     {$i+}
END.
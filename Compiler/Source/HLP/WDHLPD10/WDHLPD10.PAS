Library WDHLPD10;

USES uHLPComp;
                       
{$IFDEF OS2}    
EXPORTS
  InvokeHLP    Index 1;
{$ENDIF}                            

{$IFDEF WIN32}         
EXPORTS
  InvokeHLP    Name 'INVOKEHLP';
{$ENDIF}

BEGIN
END.        

{ -- date --- --from-- -- changes ----------------------------------------------
  27-Feb-2005 WD       Help-Compiler in das WDSibyl-Projekt eingefuegt.

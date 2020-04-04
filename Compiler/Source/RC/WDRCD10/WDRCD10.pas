Library WDRCD10;

Uses uResDef, uResDll;
                                          
{$IFDEF OS2}         
EXPORTS           
  InvokeRes    Index 1;   
{$ENDIF}
                    
{$IFDEF WIN32}         
EXPORTS
  InvokeRes    Name 'INVOKERES';
{$ENDIF}

BEGIN
END.        

{ -- date --- --from-- -- changes ----------------------------------------------
  25-Nov-2004 WD       Erstellung des Projektes
}
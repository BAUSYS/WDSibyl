Library RexxDLL;

Uses RexxSAA;

Function FuncRexx(Name:PChar; argc : LongInt;
                   VAR rxArgs: RxArguments;
                   VAR qName : cString;
                   VAR retstr: RXSTRING) : LongWord; ApiEntry;

Begin
  Result:=0;
  if argc=0
    then
      Begin
        MakeRXStringPas(Retstr, 'RV=FuncRexx');
        Result:=0;
      End
    else
      result:=40;
End;

exports
  FuncRexx index  1;

Begin
End.

PROGRAM makeRC;

{$IFDEF OS2}  
{.$R Curs_OS2}  //RG 05.07.2017
{$R Cursors}    //RG 05.07.2017
{$ENDIF}

{$IFDEF Win32}
{.$R Curs_W32}  //RG 05.07.2017
{$R Cursors}    //RG 05.07.2017
{$ENDIF}

{$R WDSibyl}    //RG 05.07.2017
{$R Language}
{$R Buttons}
{$R CheckLB}
{$R Coolbar}
{$R DBCtrls}
{$R DirOutln}
{$R EditList}
{$R GLYPHBTN}
{$R Led}
{$R Mmedia}
{$R Seven}
{$R Spin}
{$R TabCtrls}

BEGIN
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  16-Sep-04  WD         Die RC-Dateien English.RC und German.RC durch Language.RC ersetzt.
  05-Jul-17  RG		Curs_OS und Curs_W32 durch Cursors ersetzt, WDSibyl eingefÅgt
}

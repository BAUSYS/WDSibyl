Unit uConst;

Interface

Uses uString, uSysInfo;        

Const cAnzSystem = 2;
      cSystem    : Array[0..cAnzSystem-1] of tStr5 = ('OS2', 'WIN32');

      cErrCmdNotFound    = 'Command %s not found.';
      cErrBmpNameInvalid = 'Invalid icon/Bitmap name';
      cErrBmpNotFound    = 'Icon/Bitmap not found: %s';
      cErrBmpDuplicate   = 'Icon/Bitmap name duplicate: %s';
      cErrIllegalFactor  = 'Illegal factor (%s)';
      cErrNothingSave    = 'Warning: Nothing to save';
      cErrExpected       = '%s expected';
      cErrStrTblRange    = 'String table entry id out of range (0-65535)';
      cErrIllNumFmt      = 'Illegal numeric format';
      cErrSyntaxError    = 'Syntax Error';
      cErrStrTblDuplicate= 'Duplicate string table entry: %s';
      cErrStrTblNameInv  = 'Invalid or missing String Table id or name';
      cErrConstRange     = 'Const entry id out of range (0-65535)';
      cErrConstDuplicate = 'Const-Name duplicate: %s';
      cErrIncFilenotFound= 'Could not open include file:%s';
      cErrUnexpectedEnd  = 'Unexpected End of source';
      cErrUnknownOS      = 'Unknown Operating System (%s)';
      cErrNotSupportet   = 'The statement <%s> at the moment not supported';

var CompSystem : trSystem;

Implementation

Initialization
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  24-Jul-2004 WD       Erstellung der Unit
}
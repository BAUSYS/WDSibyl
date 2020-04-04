PROGRAM makeSPCC;   
                         
uses BUTTONS, CACHE, CLASSES, CLIPBRD, COMCTRLS, DIALOGS,
     DDEMAN, DOCKTOOL, EDITORS, EXTCTRLS, FILECTRL, FORMS,
     GRAPHICS, GRIDS, LISTVIEW, MASK, MENUS, MESSAGES,
     OUTLINE, PRINTERS, STDCTRLS, TABCTRLS, TOOLSAPI,
     WRAPED;          
                  
Uses uLanguage,
     uConvert;   { Diverse Konvertierungsfunktionen }
           
BEGIN      
END.              

{ -- date -- -- from -- -- changes ----------------------------------------------
  12-Jun-04  WD         Unit "Dialogs" in eine eigenes Projekt "MakeDialog" verschoben
  05-Jul-04  WD         Unit "MMedia" in eine eigenes Projekt "MakeMultiMedia" verschoben
  14-Aug-04  WD         Unit "Color" in das Projekt "MakeRTL" verschoben
  16-Sep-04  WD         Die Unit "Language" aus dem Projekt entfernt.
  01-Jan-05  WD         Einbau der Unit "uConvert"
  16-Jun-05  MV/WD      WRAPED war auch in den Compnt-Projekt
  11-Aug-05  TB/WD      Komponente in das Projekt hinzugefuegt.
  27-Aug-05  WD         Komponete "tOKCancelButton" in ExtCtrls eingebaut
  26-Dez-05  WD         Datei "Synchobjs" entfernt. (-->RTL uebernommen uSysClass)
  17-Feb-06  WD         Langauge-Support eingebaut
}

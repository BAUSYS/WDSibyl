PROGRAM makeCompnt;
                           
uses BMPLIST, CHART, CALENDAR, CHECKLB, CLOCKS, COLORGRD, COOLBAR, DIROUTLN,
     DUALLIST, EDITLIST, GLYPHBTN, GRADIENT, HINTS, LED, SCKTCOMP, SEVEN,
     SPIN, SYNCCOMP, XPLORBTN, CHART;
            
uses uProgressText,
     uPorts,              { Komponente fuer die Serielle-Schnittstelle; vorher tSerial und Joystick }
     uColorWheel;         { Komponente fuer ColorWheel und ValueBar }
                   
BEGIN                   
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  08-Sep-04  WD         Einbau der Unit "Chart" in das Projekt
  08-Sep-04  WD         Die Klasse "tEditDate" in Calendar uebernommen
  26-Sep-04  WD         Die Unit uSerialPort umbenannt auf uPorts
  26-Sep-04  WD         Die Komponente uJoystickPort in uPorts eingebaut
  27-Aug-05  WD         Die Unit uOkCancelButton ausgebaut --> ExtCntrls
}
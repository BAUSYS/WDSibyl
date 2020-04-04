Unit uResDll;

Interface               

Uses SysUtils, uSysInfo,
     SPC_DATA,
     uString,
     uConst,
     uResDef,
     uResScan,
     uSourceFile,
     uBmpList, uStringTableList;

Procedure InvokeRes(VAR PasParams:TPasParams;VAR PasReturn:TPasReturn);

Implementation

Procedure CreateOutputFile;

var ResHeader : trResHeader;

Begin
  goOutput.Create;
  FillChar(ResHeader, sizeof(trResHeader), 0);
  ResHeader.Version := $44;  // = 68;
  ResHeader.Offset  := sizeof(trResHeader);
  goOutput.WriteBuffer(ResHeader, sizeof(trResHeader));
End;


Procedure WriteNameRes;

Begin
  goIconNameList.WriteOutput(goOutput, 0);
  goPointerNameList.WriteOutput(goOutput, 0);
  goBmpNameList.WriteOutput(goOutput, $0E);
//  goGroupIconNameList.WriteOutput(goOutput);
  goStringTableNameList.WriteOutput(goOutput);
End;

Procedure WriteIDRes;

Var ResIDHeader   : trResIDHeader;
    LenResID      : LongWord;
    PosLenResID   : LongInt;
    PosResIDHeader: LongInt;

Begin

{ Schreiben der Counts von den einzelnen Lists }
  FillChar(ResIDHeader, sizeof(trResIDHeader), #0);
  PosResIDHeader:=goOutput.Position;
  goOutput.WriteBuffer(ResIDHeader, sizeof(trResIDHeader));

{ Schreiben der Gesamtlaenge der ID-Respource. }
  PosLenResID:=goOutput.Position;   // Damit sp„ter der richtige Wert hingeschrieben werden kann
  LenResID:=$FF;                      // Die Richtige Laenge wird erst spaeter geschrieben
  goOutput.WriteBuffer(LenResID, sizeof(LenResID));

{ Schreiben der ResIDInfos }
  ResIDHeader.CntStringTable:= goStringTableIDList.WriteResIDInfo(goOutput);
  ResIDHeader.CntBitmap     := goBmpIDList.WriteResIDInfo(goOutput);
  ResIDHeader.CntGroupIcons := goGroupIconIDList.WriteResIDInfo(goOutput);
  ResIDHeader.CntIcons      := goIconIDList.WriteResIDInfo(goOutput);
  ResIDHeader.CntPointer    := goPointerIDList.WriteResIDInfo(goOutput);
  goPosResIDEnde:=goOutput.Position;

{ Schreiben der einzelnen Resoruce-IDs }
  LenResID := goStringTableIDList.WriteOutput(goOutput);
  LenResID := LenResID + goBmpIDList.WriteOutput(goOutput);
  LenResID := LenResID + goGroupIconIDList.WriteOutput(goOutput);
  LenResID := LenResID + goIconIDList.WriteOutput(goOutput);
  LenResID := LenResID + goPointerIDList.WriteOutput(goOutput);

{ Schreiben der Header Informationen }
  goOutput.Position:=PosResIDHeader;
  goOutput.WriteBuffer(ResIDHeader, sizeof(trResIDHeader));

{ Schreiben der richtigen Laenge }
  goOutput.Position:=PosLenResID;
  goOutput.WriteBuffer(LenResID, sizeof(LenResID));

{ Wieder ans Ende des Streams springen }
  goOutput.Position:=goOutput.Size;
End;

Procedure WriteEnd;

var ResEnd: trResEnd;     

Begin
  FillChar(ResEnd, SizeOf(trResEnd), #0);
  goOutput.WriteBuffer(ResEnd, SizeOf(trResEnd));
End;

Procedure InvokeRes(VAR PasParams:TPasParams;VAR PasReturn:TPasReturn);

label Ende;

Var ResScan       : tcResScan;
    CompStatusMsg : tCompStatusMsg;
    Size          : LongWord;
    Index         : LongInt;
    Parameter     : String;
    ParamList     : tStringList;
    WorkPath      : tFileName;
    OutputFilename: tFileName;

Begin
  CompStatusMsg:=PasParams.MsgProc;
  CompStatusMsg('WDSibyl Resource Compiler Version ' + cVersion,'',errNone,0,0);
  CompStatusMsg('Compiling: '+PasParams.Quell,'',errNone,0,0);

// Parameter analysieren
  Parameter:=Uppercase(PasParams.Params);
  ParamList.Create;
  ParamList.AddSplit(Parameter,'-');
  if ParamList.Count=0
    then CompSystem:=goSysInfo.OS.System
    else // Analyse
      if Paramlist.Find('W32',Index)
        then CompSystem:=Win32
        else
          Begin
            CompSystem:=OS2;
            While (CompSystem<>Unknown) and
                  (Paramlist.Find(cSystem[ord(CompSystem)], Index)=false) do
              inc(CompSystem);
          End;
  if CompSystem=Unknown then
    Begin
      CompStatusMsg('Error: Unknown OS: '+PasParams.Params,'',errNone,0,0);
      exit;
    end;
  CompStatusMsg('   for system: '+cSystem[ord(CompSystem)],'',errNone,0,0);

  OutputFilename:=ExtractFileName(PasParams.Quell);
  WorkPath:=ExtractFilePath(PasParams.Quell);
  WorkPath[0]:=chr(ord(WorkPath[0])-1);    // Der String darf nicht mit "\" enden
  CompStatusMsg('WorkPath: '+WorkPath,'',errNone,0,0);
  chDir(WorkPath);
  if PasParams.Out<>'' then // Output-Verzeichniss wurde angegeben
    WorkPath:=PasParams.Out;
  if CompSystem=OS2
    then OutputFilename:=WorkPath+'\'+ChangeFileExt(OutputFilename, EXT_UC_WDSibyl_Res_SRF)
    else OutputFilename:=WorkPath+'\'+ChangeFileExt(OutputFilename, EXT_UC_WDSibyl_Res_SRW);
  CompStatusMsg('OutputFile: '+OutputFilename,'',errNone,0,0);

// List-Variablen initialisieren
  goConstList.Create;
  goConstList.Sorted:=true;
  goConstList.Duplicates:=dupError;

  goBmpNameList.Create;
  goBmpNameList.Sorted:=false;
  goGroupIconNameList.Create;
  goIconNameList.Create;
  goIconNameList.Sorted:=false;
  goPointerNameList.Create;
  goStringTableNameList.Create;

  goBmpIDList.Create;
  goBmpIDList.ResTyp:=ResTyp_Bmp;
  goGroupIconIDList.Create;
  goIconIDList.Create;
  goIconIDList.ResTyp:=ResTyp_Icon;
  goPointerIDList.Create;
  goStringTableIDList.Create;

  CompStatusMsg('Lists created...','',errNone,0,0);

// Datei verarbeiten
  try
    ResScan.Create(PasParams.Quell);
  except
    CompStatusMsg('Error: Could not open sourcefile ' +PasParams.Quell,'',errNone,0,0);
    goto Ende;
  end;

//Datei ananlysieren
  CompStatusMsg('Analyse file...','',errNone,0,0);
  ResScan.CompStatusMsg:=CompStatusMsg;
  if (ResScan.Start=false) or
     (ResScan.Error) then goto Ende;

  CompStatusMsg('Successfull...','',errNone,0,0);

// Protokoll ausgeben
  CompStatusMsg('Generating '      + PasParams.Out,'',errNone,0,0);
  CompStatusMsg('Named Icons:'     + tostr(goIconNameList.Count),'',errNone,0,0);
  CompStatusMsg('Named Pointers:'  + tostr(goPointerNameList.Count),'',errNone,0,0);
  CompStatusMsg('Named Bitmaps:'   + tostr(goBmpNameList.Count),'',errNone,0,0);
  CompStatusMsg('Named Strings:'   + tostr(goStringTableNameList.Count),'',errNone,0,0);
  CompStatusMsg('Named GroupIcons:'+ tostr(goGroupIconNameList.Count),'',errNone,0,0);
  CompStatusMsg('Menus: 0','',errNone,0,0);
  CompStatusMsg('Dialogs: 0','',errNone,0,0);
  CompStatusMsg('Accels: 0','',errNone,0,0);
  CompStatusMsg('HelpTables: 0','',errNone,0,0);
  CompStatusMsg('HelpSubTables: 0','',errNone,0,0);
  CompStatusMsg('String tables:'   + tostr(goStringTableIDList.Count),'',errNone,0,0);
  CompStatusMsg('Pointers:'        + tostr(goPointerIDList.Count),'',errNone,0,0);
  CompStatusMsg('Bitmaps:'         + tostr(goBmpIDList.Count),'',errNone,0,0);
  CompStatusMsg('Icons:'           + tostr(goIconIDList.Count),'',errNone,0,0);
  CompStatusMsg('GroupIcons:'      + tostr(goGroupIconIDList.Count),'',errNone,0,0);

// Herstellen der Output-Daten
  CreateOutputFile;

// Schreiben der Daten
  try
    WriteNameRes;
    WriteIDRes;
    WriteEnd;
  except
    CompStatusMsg('Error: Could not write the Ouptut-File','',errNone,0,0);
    goto Ende;
  End;

// Ergebnis in das File schreiben.
  Size:=goOutput.Size;
  CompStatusMsg('Size of resource data:'+tostr(Size)+' Bytes','',errNone,0,0);
  if Size=0
    then CompStatusMsg(cErrNothingSave,'',errNone,0,0)
    else
      Begin
        try
          goOutput.SaveToFile(OutputFilename);
        except
          CompStatusMsg('Error: Could not save file '+OutputFilename,'',errNone,0,0);
          goto Ende;
        end;
        CompStatusMsg('Ressource file created !','',errNone,0,0);
      End;
  CompStatusMsg('Completed...','',errNone,0,0);

Ende:
  if goBmpNameList <>nil then goBmpNameList.Destroy;
  if goGroupIconNameList <>nil then goGroupIconNameList.Destroy;
  if goIconNameList <>nil then goIconNameList.Destroy;
  if goPointerNameList <>nil then goPointerNameList.Destroy;
  if goStringTableNameList <>nil then goStringTableNameList.Destroy;

  if goBmpIDList <>nil then goBmpIDList.Destroy;
  if goGroupIconIDList <>nil then goGroupIconIDList.Destroy;
  if goIconIDList <>nil then goIconIDList.Destroy;
  if goPointerIDList <>nil then goPointerIDList.Destroy;
  if goStringTableIDList <>nil then goStringTableIDList.Destroy;

  if goConstList<>nil then goConstList.Destroy;
  if goOutput<>nil then goOutput.Destroy;

  ResScan.Destroy;
  ParamList.Destroy;
End;

Initialization
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  24-Jul-2004 WD       Erstellung der Unit
}

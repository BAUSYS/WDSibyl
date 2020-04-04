Unit uSPRInstaller;

Interface

Uses uString, SysUtils, IniFiles, uSysInfo;

Type tSprInstallOutput = Procedure(txt1, txt2 : String);

var SprInstallOutput : tSprInstallOutput;
    ModifyPlatform   : tStr5;
    CompLibFile      : tFileName;
    SearchMask       : tFileName;
    SearchRecursiv   : Boolean;

Const W32IniSection = 'Win32 Standard Directories';
      Os2IniSection = 'Standard Directories';
      OS2SPRSection = 'Directories OS/2';
      W32SPRSection = 'Directories Win32';

      GeneralSection= 'General';
      PlatformIdent = 'Platform';

      CompSection   = 'Component Library ';
      CompLibIdent  = 'CompLibName';

      SibylIniFileName = 'SIBYL.INI';

Procedure ReplaceAllStdPath (Samplepath : string; Os2Dirs,W32Dirs : TSTringList);

Implementation

Function ExtractKey (inisection : String) : string;
// extracts the key from a ini-section
Begin
  Result := Copy (inisection,1, Pos('=',inisection)-1);
End;

Function ExtractValue (inisection : String) : string;
// extracts the Value from a ini-section
Var p : integer;
Begin
  p := Pos('=',inisection);
  Result := Copy (inisection,p+1, length(inisection)-p);
End;

Procedure ReplacePath (filename : string; Os2Path, W32Path : TStringList);
Var SPRFile : TASCIIIniFile;
    runner : integer;
Begin
  SprInstallOutput('proceeding ', Filename);

//  SPRFile := TASCIIIniFile.Create (filename);
  SPRFile.Create (filename);
  try
  for runner:=0 to Os2Path.Count-1 do
    SPRFile.WriteString (Os2SPRSection,
                         ExtractKey(Os2Path.Strings[runner]),
                         ExtractValue(Os2Path.Strings[runner]));

  for runner:=0 to W32Path.Count-1 do
    SPRFile.WriteString (W32SPRSection,
                         ExtractKey(W32Path.Strings[runner]),
                         ExtractValue(W32Path.Strings[runner]));

  //maybe there is a 'LastEditDir' so delete
  SPRFile.Erase (Os2SPRSection, 'LastEditDir');
  SPRFile.Erase (W32SPRSection, 'LastEditDir');

  // Modifizieren der General/Platform
  if ModifyPlatform<>'' then
    Begin
      SPRFile.WriteString(GeneralSection, PlatformIdent,ModifyPlatform);
      SPRFile.WriteString(CompSection+ModifyPlatform, CompLibIdent, CompLibFile);
    End;

  //SPRFile.Refresh;
  SPRFile.Destroy;
  except
    Readln
  end;                   

End;
          

Procedure ReplaceAllStdPath (Samplepath : string; Os2Dirs,W32Dirs : TSTringList);
Var FileSearchRec : TSearchRec;
Begin
  // first try to find any SPR in the current dir
  if FindFirst (SamplePath + '\'+SearchMask+EXT_UC_WDSibyl_SPR, faAnyFile AND NOT faDirectory,FileSearchRec)=0 then
    REPEAT
      ReplacePath (SamplePath +'\'+FileSearchRec.Name, Os2Dirs, W32Dirs);
    UNTIL (FindNext(FileSearchRec)<>0);
  FindClose (FileSearchRec);
  // now recursive throu all suibdirs...
  if SearchRecursiv then
    Begin
      if FindFirst (SamplePath+'\*.*', faDirectory,FileSearchRec)=0 then
        REPEAT
          if (FileSearchRec.Name<>'.') AND (FileSearchRec.Name<>'..') then
            ReplaceAllStdPath (SamplePath+'\'+FileSearchRec.Name, Os2Dirs, W32Dirs);
        UNTIL (FindNext(FileSearchRec)<>0);
      FindClose (FileSearchRec);
    End;
End;

Initialization
  ModifyPlatform:='';
  CompLibFile:='';
  SearchMask:='*';
  SearchRecursiv:=true;
End.

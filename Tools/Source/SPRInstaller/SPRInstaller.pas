Program SPRInstaller;

Uses SysUtils, crt, uString, IniFiles, uSysInfo,
     uSPRInstaller;

Const
     TextColor1= White;
     TextColor2= LightRed;
     UserColor = LightBlue;

Var  SibylIniFile : TASCIIIniFile;
     SibylIniFilePath, SampleDirectory,
     dummy : String;
     W32StdDirValues,
     Os2StdDirValues : TStringList;

     runner : integer;

{-- little helpers --}
Function ReadString (displayText : string) : string;
// displays a question and reads in a string
Var help : string;
Begin
  TextColor (TextColor1);
  write (DisplayText);
  TextColor (UserColor);
  readln (help);
  TextColor (TextColor1);
  Result := help;
End;

Procedure SprOutput(txt1, txt2 : String);

Begin
  TextColor (TextColor1);
  write (txt1);
  TextColor (TextColor2);
  writeln (txt2);
  TextColor (TextColor1);
End;

Function SearchForIniFile (Var path : string) : boolean;

Var SearchFileRec : TSearchRec;
    help : boolean;
    directory : string;

Begin
{$IFDEF OS2}
  Path:=Path+'bin\os2\'+SibylIniFilename;
{$ENDIF}
{$IFDEF Win32}
  Path:=Path+'bin\win32\'+SibylIniFilename;
{$ENDIF}
  Result:=fileExists(path);
End;

var p : string;

Begin
  writeln ('WDSibyl SPR Installer');
  writeln ('M.Potthoff & W.Draxler 2005..08');
  writeln;

  SprInstallOutput:=SprOutput;
  SibylIniFilePath:=goSysInfo.WDSibylInfo.Dir;
  if SibylIniFilePath='' then
    Begin
      readString ('Enter the path to your WDSibyl installation (e.g. c:\WDSibyl) : ');
      writeln ('trying to locate ', SibylIniFileName);
    End;

  if not  SearchForIniFile (SibylIniFilePath) then
    Begin
      writeln;
      writeln ('ini file not found!')
    End
  else
    Begin
      writeln;
      writeln ('found ', SibylIniFilePath);
      SibylIniFile := TASCIIIniFile.Create (SibylIniFilePath);

      writeln ('trying to read standard directories');
      // try to read dirs...
      Os2StdDirValues := TStringList.Create;
      W32StdDirValues := TStringList.Create;

      SibylIniFile.ReadSectionValues (Os2IniSection, Os2StdDirValues);
      SibylIniFile.ReadSectionValues (W32IniSection, W32StdDirValues);
{
      writeln (W32IniSection,' : ');
      writeln (W32StdDirValues.GetText);

      writeln (Os2IniSection,' : ');
      writeln (Os2StdDirValues.GetText);
}
      // now place at sample's spu...
      writeln;
      if ParamCount=0
        then
          Begin
            sampleDirectory := ReadString ('where are the samples installed (e.g. c:\WDSibyl\Samples) : ');
     // dummy := ReadString('press [Y]+[ENTER] to proceed');
     // if uppercase(Trim(Dummy))='Y' then
          End
        else
          Begin
            p:=UpperCase(ParamStr(1));
            if ExtractFileExt(p) = EXT_UC_WDSibyl_SPR
              then
                Begin
                  sampleDirectory:=ExtractFilePath(p);
                  SearchMask     :=ExtractFileName(p);
                  SearchMask     :=Copy(SearchMask,1,LastPos('.',SearchMask)-1);
                  SearchRecursiv :=false;
                End
              else sampleDirectory:=p;
            SampleDirectory:=AddPathSeparator(SampleDirectory);
          End;

      ReplaceAllStdPath (sampleDirectory, Os2StdDirValues, W32StdDirValues);

      SibylIniFile.Destroy;
      Os2StdDirValues.Destroy;
      W32StdDirValues.Destroy;
    End;

  write ('Press [RETURN] to end program');
  readln (Dummy);
End.
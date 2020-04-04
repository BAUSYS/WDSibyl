Unit uResScan;

Interface

Uses Classes, SPC_Data, SysUtils, uString,
     uSourceFile, uStream,
     uConst,
     uBmpList;

type trBefehl = (bfKeine, bfConst);

type tcResScan = Class
       private
         fSourceFile   : tcSourceFile;
         fCompStatusMsg: tCompStatusMsg;
         fError        : Boolean;
         fBefehl       : trBefehl

         Procedure ShowError(ErrText, ErrParam : String);
         Function NextToken(var iTokenStr: String) : Char;
         Function NextTokenDir(var iTokenStr: String) : Char;
         Function ExtractBmpName(Var iResName : String; Var iResID : LongInt; Var iBmpFileName : tFilename) : Boolean;
         Function MathStringLong(var iValue : LongInt) : Boolean;
         Procedure ScanBitmap;
         Procedure ScanConst(iToken : String; iCh : Char);
         Procedure ScanPointer;
         Procedure ScanGroupIcon;
         Procedure ScanIcon;
         Procedure ScanStringTable;
         Procedure ScanData;
         Procedure ScanSound;
         Procedure ScanVideo;
       public
         Function Start : Boolean;
         Constructor Create(iFileName : tFilename);
         Destructor Destroy; Override;

         Property CompStatusMsg : tCompStatusMsg Read fCompStatusMsg Write fCompStatusMsg;
         Property Error         : Boolean        Read fError;
     End;

Implementation

Uses uResDef;

Function tcResScan.NextToken(var iTokenStr: String) : Char;

Begin
  try
    Result:=fSourceFile.NextToken(iTokenStr);
  except
    on e:ESourceFileError do
      ShowError(e.Message,'');
  end;
//  Writeln('nextToken:', iTokenStr);
End;

Function tcResScan.NextTokenDir(var iTokenStr: String) : Char;

Begin
  fSourceFile.NextTokenIsDir:=true;    // Es wird ein Verzeichnis eingelsen
  Result:=NextToken(iTokenStr);
  fSourceFile.NextTokenIsDir:=false;
End;

Function tcResScan.MathStringLong(var iValue : LongInt) : Boolean;

Var ch,old_ch: Char;
    Token    : String;
    CoLst    : LongInt;
    CurValue : LongInt;
    Err      : Integer;

Begin
  Result:=false;
  iValue:=0;
  old_ch:=#0;
  Repeat
    CurValue:=0;
    ch:=NextToken(Token);
//    Writeln('Token: ',Token,', ',ch,', ',old_ch);
    CoLst:=goConstList.IndexOf(Token);
    if CoLst<0
      then
        Begin
          val(Token, CurValue, Err);
          if Err<>0 then
            Begin
              ShowError(cErrIllNumFmt, #0);
              exit;
            End;
        End
      else
        Begin
          Err:=0;   // Eine Konstante gefunden --> Kein Fehler
          CurValue:=goConstList.IDs[CoLst];
        End;

    case old_ch of
      '+',#0,#32 : iValue:=iValue+CurValue;
      '-'        : iValue:=iValue-CurValue;
      else
        Begin
          ShowError(cErrIllNumFmt, #0);
          exit;
        End;
    end;
    old_ch:=ch;
  Until ch=';';
  Result:=true;
End;


Procedure tcResScan.ScanConst(iToken : String; iCh : Char);

Var ResID : LongInt;

Begin
  if iCh='='
    then
      Begin         
        try
          if MathStringLong(ResID) then
            Begin
//              Writeln('MathStringLong:',iCH,', ',ResID);
              if ResID <= 0
                then ShowError(cErrConstRange, '')
                else goConstList.AddObjectID(iToken, nil, ResID);
            End;
        except
          ShowError(cErrIllegalFactor, iCh);
        end;
      end
    else ShowError(cErrIllegalFactor, iCh);
End;

Procedure tcResScan.ScanPointer;

Var ResName : String;
    ResID   : LongInt;
    BmpFile : tFilename;

Begin
  if ExtractBmpName(ResName, ResID, BmpFile) then
    Begin
//      Writeln('Pointer: ', ResName, '; ', ResID, '; ',BmpFile);
      try
        if ResID<0
          then goPointerNameList.AddBitmap(ResName, BmpFile)
          else goPointerNameList.AddBitmap(GenUniqueResName(ResID, 'TPOINTER'), BmpFile);
//               goIconIDList.AddBitmap(ResID, BmpFile);   // goPointerIDList.AddBitmap(ResID, BmpFile);
      except
        on e:EFOpenError do
          ShowError(cErrBmpNotFound, bmpFile);
        on e:EStringListError do
          ShowError(cErrBmpDuplicate, bmpFile);
      end;
    end;
  fBefehl:=bfKeine;
End;

Procedure tcResScan.ScanBitmap;

Var ResName : String;
    ResID   : LongInt;
    BmpFile : tFilename;

Begin
  if ExtractBmpName(ResName, ResID, BmpFile) then
    Begin
//      Writeln('Bmp: ', ResName, '; ', ResID, ';', '; ',BmpFile);
      try
        if ResID<0
          then goBmpNameList.AddBitmap(ResName, BmpFile)
          else goBmpNameList.AddBitmap(GenUniqueResName(ResID, 'TBITMAP'), BmpFile);
                // goBmpIDList.AddBitmap(ResID, BmpFile);
      except
        on e:EFOpenError do
          ShowError(cErrBmpNotFound, bmpFile);
        on e:EStringListError do
          ShowError(cErrBmpDuplicate, bmpFile);
      end;
    End;
  fBefehl:=bfKeine;
end;

Procedure tcResScan.ScanGroupIcon;

Var ResName : String;
    BmpFile : tFilename;
    ResID   : LongInt;

Begin
  if ExtractBmpName(ResName, ResID, BmpFile) then
    Begin
//      Writeln('GrpIcon: ', ResName, '; ', ResID, '; ',BmpFile);
      try
        if ResID<0
          then goIconNameList.AddBitmap(ResName, BmpFile) // goGroupIconNameList.AddBitmap(ResName, BmpFile)
          else goIconIDList.AddBitmap(ResID, BmpFile);    // goGroupIconIDList.AddBitmap(ResID, BmpFile)
      except
        fError:=true;
        on e:EFOpenError do
          ShowError(cErrBmpNotFound, bmpFile);
        on e:EStringListError do
          ShowError(cErrBmpDuplicate, bmpFile);
      end;
    End;
End;

Procedure tcResScan.ScanIcon;

Var ResName : String;
    ResID   : LongInt;
    BmpFile : tFilename;

Begin
  if ExtractBmpName(ResName, ResID, BmpFile) then
    Begin
//      Writeln('Icon: ', ResName, '; ', ResID, '; ',BmpFile);
      try
        if ResID<0
          then goIconNameList.AddBitmap(ResName, BmpFile)
          else goIconNameList.AddBitmap(GenUniqueResName(ResID, 'TICON'), BmpFile);
//             goIconIDList.AddBitmap(ResID, BmpFile);
      except
        on e:EFOpenError do
          ShowError(cErrBmpNotFound, bmpFile);
        on e:EStringListError do
          ShowError(cErrBmpDuplicate, bmpFile);
      end;
    End;
  fBefehl:=bfKeine;
End;

Procedure tcResScan.ScanData;

Begin
  ShowError(cErrNotSupportet, 'Data');
End;

Procedure tcResScan.ScanSound;

Begin
  ShowError(cErrNotSupportet, 'Sound');
End;

Procedure tcResScan.ScanVideo;

Begin
  ShowError(cErrNotSupportet, 'Video');
End;

Procedure tcResScan.ScanStringTable;
// Es gibt 2 Typen von Stringtabellen.
// .) Namen-Stringtabelle:
//    Diese wird in einer Tabelle/Subtabellen-Beziehnung aufgebaut
// .) ID-Stringtabelle:
//    Es gibt nur eine Tabelle. Diese beinhaltet alle Texte. Diese wird in der
//    Output in 16-Bloecke unterteilt.

var Ch        : Char;
    Value     : String;
    TblResName: String;
    TblResID  : Word;
    c         : Integer;

  Procedure ScanTable;

  var ResID    : LongInt;
      strResID : tStr5;
      err      : Integer;
      ResStrTbl: ^tStringList;

  Begin
    if TblResID=0 then
      Begin
        new(ResStrTbl);
        ResStrTbl^.Create;
        ResStrTbl^.Sorted:=true;
      End;

    Repeat
      Ch:=NextToken(Value);

      if Value<>'END' then  // Ende der Stringtabelle erreicht?
        Begin
          if ch=#0 then     // Ende der Datei erreicht?
            Begin
              ShowError(cErrExpected,'END');
              exit;
            End;

          if ch=','
            then
              Begin
                val(Value, ResID, err);
                if err<>0 then     // Jetzt koennte das noch eine Konstante sein
                  Begin
                    ResID:=goConstList.IndexOf(Value);
                    if ResID>=0 then
                      Begin
                        Err:=0;   // Eine Konstante gefunden --> Kein Fehler
                        ResID:=goConstList.IDs[ResID];
                      End;
                  End;
                if Err=0
                  then
                    Begin
                      if (ResID<0) or (ResID>MAXWORD) then
                        Begin
                          ShowError(cErrStrTblRange, '');
                          exit;
                        end;

                      Ch:=NextToken(Value);
                      if ch in [#39, #34]
                        then
                          If TblResID=0
                            then
                              Begin
                                if ResStrTbl^.IndexOfID(ResID)< 0
                                  then
                                    Begin
                                      FmtStr(StrResID, '%.5d', [ResID]);
                                      ResStrTbl^.AddObjectID(StrResID+';'+Value, nil, ResID);
                                    End
                                  else ShowError(cErrStrTblDuplicate,toStr(ResID));
                              End
                            else
                              Begin
                                if goStringTableIDList.IndexOfID(ResID)< 0
                                  then
                                    Begin
                                      FmtStr(StrResID, '%.5d', [ResID]);
                                      goStringTableIDList.AddObjectID(StrResID+';'+Value, nil, ResID)
                                    End
                                  else ShowError(cErrStrTblDuplicate,toStr(TblResID)+'/'+toStr(ResID));
                              End
                        else ShowError(cErrSyntaxError, '');
                    End
                  else ShowError(cErrIllNumFmt, '');
              End
            else ShowError(cErrIllNumFmt, '');
        End;

    Until (Value='END') or (fError=true);

   if (fError=false) and (TblResID=0) then
     goStringTableNameList.AddStringTable(TblResName, ResStrTbl^);
  End;

Begin
// Ueberpruefen ob eine ID oder Name angegeben worden ist.
  Ch:=NextToken(TblResName);
  if (TblResname='') or (TblResName='0') then
    Begin
      ShowError(cErrStrTblNameInv,'');
      exit;
    end;

// Bei ID muss der Res-Name geloescht werden. Damit kann
// zwischen den beiden Typen unterschieden werden
  Val(TblResName, TblResID, C);
  if c=0 then TblResName:='';

// Scannen der String-Tabelle-Eintraege
  if ch=#32 then
    Begin
      Ch:=NextToken(Value);
      if (ch=#32) and (Value='BEGIN')
        then ScanTable
        else ShowError(cErrExpected,'BEGIN');
    End;
  fBefehl:=bfKeine;
End;

Function tcResScan.Start : Boolean;

label Fehler_CmdNotFound;
label case_Else;

Var ch    : Char;
    Token : String;

Begin
  Result:=false;
  Repeat         
    try
      ch:=NextToken(Token);
    except
      if (fSourceFile.CompDir) and (Token='I') then
        Begin
          ShowError(cErrIncFilenotFound, fSourceFile.LastIncFileName);
          exit;
        end;
    end;
    if ch<>#0 then
      case Token[1] of
        'B' : if Token='BITMAP'
                then ScanBitmap
                else goto case_Else;
        'C' : if Token='CONST'
                then fBefehl:=bfConst
                else goto case_Else;
        'D' : if Token='DATA'
                then ScanData
                else goto case_Else;
        'G' : if Token='GROUPICON'
                then ScanGroupIcon
                else goto case_Else;
        'I' : if Token='ICON'
                then ScanIcon
                else goto case_Else;
        'P' : if Token='POINTER'
                then ScanPointer
                else goto case_Else;
        'S' : case Token[2] of
                'T' : if Token='STRINGTABLE'
                        then ScanStringTable
                        else goto case_Else;
                'O' : if Token='SOUND'
                        then ScanSound
                        else goto case_Else;
                else goto case_Else
              End;
        'V' : if Token='VIDEO'
                then ScanVideo
                else goto case_Else;
        else
case_Else:
          case fBefehl of
            bfConst : ScanConst(Token, ch);
            else goto Fehler_CmdNotFound;
          End;
      end;
  Until (ch=#0) or (fError=true);
  Result:=not fError;
  exit;

Fehler_CmdNotFound:
  if fError=false then // Es wurde noch kein Fehler ausgegeben
    ShowError(cErrCmdNotFound, Token);
End;

Function tcResScan.ExtractBmpName(Var iResName : String; Var iResID : LongInt;
                                  Var iBmpFileName : tFilename) : Boolean;

var ch : Char;
    c  : Integer;


Begin
  iResName:='';
  iResID:=0;
  iBmpFileName:='';
  Result:=false;
  ch:=NextToken(iResName);
  if ch=#32
    then
      Begin
        if iResName='' then exit;
        Val(iResName, iResID, C);
        if c=0
          then iResName:=''    // Es ist ein Zahl --> ID-Resournce
          else                 // Jetzt koennte es noch eine Konstante sein
            Begin
              iResID:=goConstList.IndexOf(iResName);
              if iResID>=0 then
                Begin
                  iResName:='';
                  iResID:=goConstList.IDs[iResID];
                End;

            End;
        ch:=NextTokenDir(iBmpFileName);
        if ch in [#32, #0]
          then
            Begin
              iBmpFileName:=ExpandFileName(iBmpFileName);
              Result:=true;
            end
          else ShowError(cErrBmpNameInvalid, '');
      end
    else ShowError(cErrBmpNameInvalid, '');
End;

Procedure tcResScan.ShowError(ErrText, ErrParam : String);

var ErrPos : tPoint;
    Erg    : String;

Begin
  fError:=true;
  ErrPos:=fSourceFile.TextPos;
  FmtStr(Erg, ErrText, [ErrParam]);
  CompStatusMsg(Erg, fSourceFile.FileName, errError, ErrPos.Y, ErrPos.X);
End;

Constructor tcResScan.Create(iFileName : tFilename);

Begin
  inherited Create;
  fError:=false;
  fSourceFile.Create(iFileName);
End;

Destructor tcResScan.Destroy;

Begin
  fSourceFile.Destroy;
  inherited Destroy;
End;


Initialization
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  24-Jul-2004 WD       Erstellung der Unit
  02-Mai-2006 WD       ScanData, ScanVideo, ScanSound eingebaut.
  03.Mai-2006 WD       Bitmap-Resource-ID auf Name-Resource umgebaut.
}

Unit uSourceFile;

Interface

Uses SysUtils, uSysInfo, uStream,
     uConst;

type tcSourceFile = Class
       private
         fFileName        : tFilename;
         fSize            : LongWord;
         fPosition        : LongWord;
         fMemory          : PCharArray;
         fLastCh          : Char;
         fUpper           : Boolean;
         fHochCh          : Char;

         fNextTokenIsDir  : Boolean;   // =true; Naechste Token ist ein Verzeichnis/Datei --> Einge TokenChar ignorieren z.b ":"

         fOldPosition     : LongWord;  // Alter "Position" Wert

         fCompDir         : Boolean;   // Das aktuelle Zeichen befindet sich in einer Compiler-Direktive
         fHelpDir         : Boolean;   // Das aktuelle Zeichen befindet sich in einer Hilfe
         
         fTokenCompDir    : Boolean;   // Der Token ist eine Compiler-Direktive
         fTokenHelp       : Boolean;   // Der Token ist eine Hilfe
         fSourceForOS     : trSystem;
         fSourceForBool   : Boolean;
         fRow             : LongWord;
         fRowStartPos     : LongWord;
         fLastIncFileName : tFilename;
         
         fAccept_HelpToken: Boolean    // = true; Der Text "{§H" wird als Token erkannt und akzeptiert

         Function getTextPos : tPoint;

         Procedure CompDir_Include;       // Includiert eine Datei in den Speicher hinzu
         Procedure CompDir_Ifdef;         // Compilerdirektive: IFDEF
         
//         Function CompDir_Help : String;  // Compilerdirektive: HELP
         Procedure SendError(ErrText, ErrParam : String);
       published
         Function getNextToken(var iTokenStr: String) : Char;
         Function getNextChar : Char;
       public
         Constructor Create(iFileName : tFilename);
         Destructor Destroy; Override;
         Function NextToken(var iTokenStr: String) : Char;

         Property FileName:TFilename        Read fFileName;
         Property LastIncFileName:tFilename Read fLastIncFileName;
         Property Memory:pCharArray         Read fMemory;
         Property Size:LongWord             Read fSize;
         Property Position:LongWord         Read fPosition Write fPosition;

         Property NextTokenIsDir: Boolean   Read fNextTokenIsDir Write fNextTokenIsDir;

         Property TextPos:tPoint            Read getTextPos;
         
         Property CompDir:Boolean           Read fCompDir;
         Property HelpDir:Boolean           Read fHelpDir;
         
         Property Upper:Boolean             Read fUpper;
         
         Property Accept_HelpToken:Boolean Read fAccept_HelpToken Write fAccept_HelpToken;

     end;

type ESourceFileError=Class(Exception);

type taTokenTyp= (taeTypCommand, taeTypString, taeTypLong, taeTypReal);

Function GetTokenTyp(iTokenStr : String) : taTokenTyp;
{Ermittelt den Typ des Strings }

Implementation

Function tcSourceFile.NextToken(var iTokenStr: String) : Char;

var ch : Char;

label Start;

Begin

Start:
  Result:=GetNextToken(iTokenStr);
  if (fTokenCompDir) then
    Begin
//      Writeln('TokenDire:', iTokenStr);
      Case iTokenStr[1] of
        'E' : Begin
                if iTokenStr='ENDIF' then
                  Begin
                    fSourceForBool:=true;
                    fSourceForOS:=CompSystem;
                    goto Start;   // Naechsten Token einlesen
                  End;
                if iTokenStr='ELSE' then
                  Begin
                    fSourceForBool:=false;
                    goto Start;
                  end;
              End;
                               
        'I' : Begin
                if iTokenStr='IFDEF' then
                  Begin
                    CompDir_Ifdef;
                    goto Start;   // Naechsten Token einlesen
                  End;
              End;
      End;
    End;
    
  if (fTokenHelp) then
    Begin
      Case iTokenStr[1] of
        'H' : Begin
                if iTokenStr='H' then
                  Begin
                    iTokenStr:='';
                    fUpper:=false;
                    ch:=getNextChar;
                    while ch <> '}' do
                      Begin
                        iTokenStr:=iTokenStr+ch;
                        ch:=getNextChar;
                      end;  
                    fUpper:=true;  
                    exit;
                  End;
              End;
      end;
    end;  

  if ((fSourceForBool) and
      (fSourceForOS <> CompSystem)) or
     ((fSourceForBool=false) and
      (fSourceForOS = CompSystem))
    then   // Source sind nicht fuer das Ergebnis-Betriebsystem
      goto Start;
// Write('Token:', iTokenStr); Readln;
End;

// **********************************************************************
// Compiler-Direktive
// **********************************************************************

Procedure tcSourceFile.CompDir_Ifdef;

Var Ch      : Char;
    Token   : String;

Begin
  Ch:=getNextToken(Token);
  if Token='DOSOS2' then
    Begin
      fSourceForOS:=OS2;
      exit;
    end;

  fSourceForOS:=OS2;
  fSourceForBool:=true;

// Herausfinden welches Betriebsystem bei ifdef angegeben worden ist
  While (Token<>cSystem[ord(fSourceForOS)]) and
        (fSourceForOS<>Unknown) do
   inc(fSourceForOS);
  if fSourceForOS=Unknown then
    SendError(cErrUnknownOS, Token);
End;

Procedure tcSourceFile.CompDir_Include;

var IncFileStream: tFileStream;
    ch           : Char;
    NewSize      : LongWord;
    FileSize     : LongWord;
    TempMemory   : PCharArray;

Begin
  fNextTokenIsDir:=true;             // Diverse TokenChar ignorieren
  ch:=getNextToken(fLastIncFileName);
  fNextTokenIsDir:=false;
  if (ch<>'}') and (fMemory^[fPosition]<>'}') then
    Begin
      SendError(cErrExpected, '}');
      Exit;
    End;
  fLastIncFileName:=ExpandFileName(fLastIncFileName);
  try
    IncFileStream.Create(fLastIncFileName, Stream_OpenRead);
  except
    SendError(cErrIncFilenotFound, fLastIncFileName);
    exit;
  end;
  FileSize:=IncFileStream.Size;
  NewSize:=fSize+FileSize;
  GetMem(TempMemory, NewSize);
// Kopieren des Teils vor dem Include
  move(fMemory^, TempMemory^, fPosition);
// Jetzt die Datei in den Speicher laden
  IncFileStream.Read(TempMemory^[fPosition], FileSize);
// Jetzt den Rest vom Buffer in den TempBuffer kopieren
  move(fMemory^[fPosition],TempMemory^[fPosition+FileSize], fSize-fPosition);
// Alten Memory-Speicher loeschen und den neuen als fMemory verwenden
  Freemem(fMemory, fSize);
  fSize:=NewSize;
  fMemory:=TempMemory;
  IncFileStream.Destroy;
End;

// **********************************************************************
// Token Verarbeitung
// **********************************************************************

Function tcSourceFile.getNextToken(var iTokenStr: String) : Char;
// Ermittlung des Naechsten Token
// fuer interne Zwecke notwendig

var ch     : Char;
    RepExit: Boolean;
    Durchl : LongWord;

label Start;
label IfUpperEnd;

Begin
  fOldPosition := Position;

Start:
  fTokenCompDir:=false;
  fTokenHelp:=false;
  fHelpDir:=false;
  iTokenStr:='';
  RepExit:=false;
  Durchl:=0;
  Repeat
    ch:=getNextChar;
  until ch<>#32;

  if FUpper
    then   // Pascal-Code
      Repeat
        if fCompDir then fTokenCompDir:=true;
        if fHelpDir then fTokenHelp:=true;
        inc(Durchl);

// Check auf Trennzeichen.        
        if (ch in [#0,#32,'*','[',']','(',')',',',';','=','{','}','&','^']) or
        
// "+" und "-" als Trennzeichen wenn es sich um kein Compilerdirective handelt.
           ((ch in ['+','-']) and (fCompDir=false)) or
           
// ".", ":" und  "/"  sind Trennezeichen, ausser es handelt sich um ein Verzeichnis.
           ((fNextTokenIsDir=false) and                                  
               ((ch='.') and not (fMemory[Position] in ['0'..'9'])) or   // Check auf "." in Zahlen
               ((fNextTokenIsDir=false) and (ch in [':','/'])))
          then
            Begin
              Result:=ch;
              if Durchl>1 then goto IfUpperEnd;
            End
          else
            Begin
              iTokenStr:=iTokenStr+ch;
              ch:=getNextChar;
              if Length(iTokenStr)>254 then goto IfUpperEnd;
            End;
      until RepExit
    else   // String/Text
      Begin
        Result:=fHochCh;
        Repeat
          inc(Durchl);
          if Durchl>1 then iTokenStr:=iTokenStr+ch;
          if Length(iTokenStr)>254 then RepExit:=true;
          ch:=getNextChar;
        Until fUpper=true;
      End;

IfUpperEnd:
  if (fCompDir) and (iTokenStr='I') and (Result=' ') then
    Begin
      CompDir_Include;
      goto Start;
    End;

// Writeln('getNextToken:', iTokenStr,', Result= "',Result,'"');
End;

Function tcSourceFile.getNextChar : Char;

label Chk_Char;

Var CurCh  : Char;

Begin
  Result:=#0;
Chk_Char:
  if fPosition>=fSize then  // Datei-Ende schon erreicht
    exit;

  CurCh:=fMemory[fPosition];
  if fUpper
    then
      Begin   // Es ist ein normaler Pacsal-Source --> Zeichen in Grossbuchstaben konvertieren
        case CurCh of
          #32      : Begin
                       Result:=#32;
                       if (fLastCh=#32) or
                          (fMemory[fPosition+1] in [#32, '=']) then   // noch ein leer Zeichen --> ignorieren
                         Begin
                           inc(fPosition);
                           goto Chk_Char;
                         End;
                     End;
          #9       : Begin    // Tabulator
                       fMemory[fPosition]:=#32;
                       goto Chk_Char;
                     End;
          #13, #10 : Begin    // Zeilenumbruch
                       inc(fRow);
                       fRowStartPos:=fPosition;
                       fMemory[fPosition]:=#32;
                       if fMemory[fPosition+1]=#10 then   // Zeilenumbruch --> ignorieren
                         Begin
                           inc(fPosition);
                           fMemory[fPosition]:=#32;
                         End;
                       goto Chk_Char;
                     End;
          #39, #34 : Begin   // Einfaches- oder Doppelteshochkomma
                       Result:=CurCh;
                       fUpper:=false;
                       fHochCh:=CurCh;
                     End;
          '/'      : Begin   // Koennte ein Zeilen-Kommentar sein
                       case fMemory[fPosition+1] of
                        '/' : Begin  // Zeilen-Kommentar --> ignorieren
                                Repeat
                                  inc(fPosition);
                                  if fPosition > fSize then exit;
                                until fMemory[fPosition] = #13;
                                inc(fPosition);
                                inc(fRow);
                                fRowStartPos:=fPosition;
                                if fMemory[fPosition]=#10 then inc(fPosition);
                                goto Chk_Char;
                              End;
                        '*' : Begin  // Super-Kommentar --> ignorieren
                                Repeat
                                  inc(fPosition);
                                  if fPosition > fSize then exit;
                                until (fMemory[fPosition] = '*') and
                                      (fMemory[fPosition+1] = '/');
                                inc(fPosition,2);
                                goto Chk_Char;
                              End;
                        else  Result:=CurCh;
                       End;
                     End;
          '{'      : Begin   // Kommentar ueber mehrere Zeilen
                       if fMemory[fPosition+1] = '$' then
                         Begin
                           inc(fPosition,2);
                           fCompDir:=true;
                           goto Chk_Char;
                         End
                       else if (fAccept_HelpToken) and (fMemory[fPosition+1] = '§') then
                         Begin
                           inc(fPosition,2);
                           fHelpDir:=true;
                           goto Chk_Char;
                         end   
                       else
                           Begin
                             Repeat
                               inc(fPosition);
                               if fPosition > fSize then exit;
                             until fMemory[fPosition] = '}';
                             inc(fPosition);
                             goto Chk_Char;
                           End;
                     End;
          '}'      : Begin  // Ende des Kommentares oder der Compilier-Directive
                       if fCompDir then
                         Begin
                           fCompDir:=false;
                           goto Chk_Char;
                         End
                       else if fHelpDir then
                         Begin
                           fHelpDir:=false;
                           fTokenHelp:=false;
                           goto Chk_Char;
                         End  
                       else Result:=CurCh;
                     End;
          else       Begin
                       if fUpper
                         then Result:=UpCase(CurCh)
                         else Result:=CurCh;
                     End;
        End;
      End
    else      // Der Text steht unter Hochkomma --> keine Zeichenumwandlung
      Begin
        if CurCh = fHochCh then
          Begin
            fUpper:=true;
            fHochCh:=#00;
          end;
        Result:=CurCh;
      End;

  inc(fPosition);
  fLastCh:=Result;
End;

// **********************************************************************
// Klassen-Funktionen
// **********************************************************************

Procedure tcSourceFile.SendError(ErrText, ErrParam : String);

var Erg    : String;

Begin
  FmtStr(Erg, ErrText, [ErrParam]);
  Raise ESourceFileError.Create(Erg);
End;

Function tcSourceFile.getTextPos : tPoint;

Begin
//  Writeln('zei:',fMemory[fPosition]);
  Result.X:=fOldPosition-fRowStartPos;
  Result.Y:=fRow;
End;


Constructor tcSourceFile.Create(iFileName : tFilename);

Var fStream : tFileStream;

Begin
  inherited Create;
  fFileName:=iFileName;
  fStream.Create(iFilename, Stream_OpenRead);
  fSize:=fStream.Size;
  GetMem(fMemory, fSize);
  fStream.Read(fMemory^[0], fSize);
  fStream.Destroy;
  fPosition:=0;
  fRow:=1;
  fRowStartPos:=0;
  fUpper:=true;
  fCompDir       :=false;
  fHelpDir       :=false;
  fTokenCompDir  :=false;
  fTokenHelp     :=false;
  fSourceForOS   :=CompSystem;
  fSourceForBool :=true;
  fNextTokenIsDir:=false;
  
  fAccept_HelpToken:=false;
End;

Destructor tcSourceFile.Destroy;

Begin
  FreeMem(fMemory, fSize);
  inherited Destroy;
End;

Function GetTokenTyp(iTokenStr : String) : taTokenTyp;

var HochCh : Char;

Begin
  Result:=taeTypCommand;
  HochCh:=iTokenStr[1];
  if (HochCh in [#39, #34]) and
     (iTokenStr[Length(iTokenStr)] = HochCh) then
    Begin
      Result:=taeTypString;
      exit;
    End;
End;

Initialization
End.

{ -- date --- --from-- -- changes ----------------------------------------------
  24-Jul-2004 WD       Erstellung der Unit
  16-Jul-2006 WD       Diverse Aenderungen fuer GenHelp ein- bzw. umgebaut.
  18-Sep-2006 WD       Den Punkt (ausser Zahlen) auch als Trennzeichen verwenden.
}

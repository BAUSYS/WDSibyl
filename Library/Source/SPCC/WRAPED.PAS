Unit WrapEd;

{

  An ancestor of SPCC TEditor (editors.pas),
  with the word wrap behaviour of OS/2 System Editor or Windows Notepad

  Author: Martin Vieregg  www.hypermake.com

  With HardReturn[Index] : boolean
  or   HR := GetPHardReturn (PLine)
  or   SetPHardReturn (PLine, HR)
  you have access to the information whether a line ends with a hard return or a soft return,
  while HR is a boolean variable and is true if it is a hard return.

  editors.pas and wraped.pas is implemented in my WSedit Freeware editor and in the Hypermake editor.
  Visit www.WriteAndSet.com and www.hypermake.com

  3.1.2005: property Wrap let you turn off wraped functionality,
                          if Wrap = FALSE, behaviour is like tEditor
                          Set this property before loading the text file!
                          default is TRUE

  23.6.2005: ciBreakReturn functionality added (breaking lines if they are too long, even there's no space
             for making a soft return, now you can e.g. edit a config.sys file with a long PATH= statement
             like you can do with OS/2 System editor or Windows Notepad

  11.3.2008: MaxColFixed : boolean
}

Interface

Uses
  Classes, Dialogs, Forms, Graphics, Buttons, Sysutils, Editors;

{const flags:
  ciSoftReturn, ciBreakReturn, defined in Editors.pas}

type
  ArrayOfChar = array[#0..#255] of char;
  TWrapEditor = Class (TEditor)
  Private
    Procedure _SetHardReturn(Y:LongInt;Const S:boolean);
    Function _GetHardReturn(Y:LongInt):boolean;
    Procedure _SetBreakReturn(Y:LongInt;Const S:boolean);
    Function _GetBreakReturn(Y:LongInt):boolean;
    ModifyingAction : boolean;
    FWrap : boolean;
  Protected
    Procedure cmBackSpace;override;
    Procedure cmDeleteLeftWord;override;
    Procedure cmBreakLine;override;
    Procedure cmDeleteChar;override;
    procedure cmDeleteRightWord;override;
    Procedure SetPHardReturn(pl:PLine;Const S:boolean); override;
    Function GetPHardReturn(pl:PLine):boolean; override;
    Procedure SetPBreakReturn(pl:PLine;Const S:boolean); override;
    Function GetPBreakReturn(pl:PLine):boolean; override;
    procedure UseNextReturnflag (pl : PLine); override;
    function FirstLineOfParagraph (plStart : PLine) : PLine;
    function LastLineOfParagraph (plStart : PLine) : PLine;
    procedure InvalidateParagraph;
    Procedure SelectParagraph(P:TEditorPos);
    Function _InsertText(P:Pointer; len:LongInt; marknew:Boolean):TLineX; override;
    Function _GetEditorBlock(Var P:Pointer; Var len:LongInt):Boolean; override;
    function DeleteIndent (pl : PLine; var Line : string) : byte; override;
    Procedure cmICBDeleteBlock;override;
    Procedure cmICBMoveBlock;override;
    Procedure SetModified(Value:Boolean);override;
    Procedure _WriteWorkLine; override;
    function TabToSpaces : boolean; virtual;
    function DelCursorCorrection : boolean;
  Public
    WrapCursorFeeling : boolean;{Cursor movement like in a wrap editor
                                 in comparison to a programmers editor;
                                 The difference is in areas where no characters are}
    MaxCol{width of the window in characters},
      ActualCol {right margin for formatting} : byte;
    DefaultIndentChar : char;
    function IndentChar (Line : PLine) : char; virtual;
    FormatSoon : boolean;
    DelayedFormat, ManualFormat, NoFormat : boolean;
      {if ManualFormat is true, you have to make a "FormatParagraphFromLine" by yourself
                                if FormatSoon is true, you have to execute FormatParagraphFromLine by a Timer}
    SaveAsShown : boolean;
    MaxColFixed : boolean;
    RememberCurrentY, RememberCurrentParagraph : longint;
    OldBlockPosition : TLineX;
    Property HardReturn[Index:LongInt]:boolean Read _GetHardReturn Write _SetHardReturn; //Default;
    Property BreakReturn[Index:LongInt]:boolean Read _GetBreakReturn Write _SetBreakReturn; //Default;
    property Wrap : boolean read FWrap write FWrap;
    function FormatParagraphFromLine (Y : longint) : boolean; virtual;
    function HardReturnDependentOnLastChar (llCh : char) : boolean; virtual;
    procedure ScanEvent(var KeyCode: TKeyCode; RepeatCount: Byte); override;
    procedure CharEvent(var Key : char; RepeatCount: Byte); override;
    Procedure cmCursorRight; override;
    Procedure cmCursorLeft; override;
    procedure Resize; override;
    function Paragraph2Line (HR : longint) : tEditorPos;
    function Editorpos2Paragraph (CurrentPos : tEditorPos) : longint;
    function LineX2ParagraphCharCount (LineX : TLineX) : longint;
    function ParagraphCharCount2LineX (FirstlineofPar : PLine; Count : longint) : TLineX;
    function ParagraphCharCount2EditorPos (Para, CharCount : longint) : tEditorPos;
    procedure ConditionalFormat (Charkey : boolean);
    procedure ReformatAll; virtual;
    procedure CodepageConversion (P:Pointer; len:LongInt); virtual;
    procedure CalculateMaxCol; virtual;
    procedure CommandInterpreter (var St : string; IsFirstLine : boolean); virtual;
    procedure GetActualCol (Pl : PLine); virtual;
    procedure SetScrollbarVisibility; virtual;
    function ScrollbarIsVisible : boolean; virtual;
    procedure SetupComponent; override;
    procedure cmEnter; override;
  end;

implementation

function TWrapEditor.Paragraph2Line (HR : longint) : tEditorPos;
  {calculates the true editor Line pos from the HR Hard-Return Number (number of paragraphs)}
  var
    Line : PLine;
    HardReturnLast, HardReturnAct : boolean;
    H{HardReturn counter}, S{Soft and Hard Return counter}, BeginOfParagraph : longint;
  begin
    result.X := 1;
    Line := FirstLine;
    S := 0; H := 0; HardReturnLast := true;
    while Line <> nil do begin
      inc (S);
      HardReturnAct := GetPHardReturn(Line);
      if HardReturnLast then BeginOfParagraph := S;
      if HardReturnAct {HardReturn = true} then inc (H);
      if H = HR then begin
        result.Y := BeginOfParagraph; exit;
      end;
      Line := Line^.next;
      HardReturnLast := HardReturnAct;
    end;
    {oops, nothing found}
    result.Y := 1;
  end;

function TWrapEditor.Editorpos2Paragraph (CurrentPos : tEditorPos) : longint;
  {calculates the Paragraph Number from the Editor pos}
  var
    P, L : longint; Line : PLine;
  begin
    if CurrentPos.Y = RememberCurrentY then
      result := RememberCurrentParagraph
    else begin
      P := 1; L := 1; Line := FirstLine;
      while (Line <> nil) and (L < CurrentPos.Y) do begin
        if GetPHardReturn(Line) then inc (P);
        inc (L); Line := Line^.next;
      end;
      RememberCurrentY := CurrentPos.Y;
      RememberCurrentParagraph := P;
      result := P;
    end;
  end;

function tWrapEditor.LineX2ParagraphCharCount (LineX : TLineX) : longint;
  {calculates the number of the character within a paragraph
   -> you can remember the position of a character even the paragraph is reformatted}
  var
    Pl, FirstPl : PLine; P : PString; Count : longint; IndentI : integer;
  begin
    Pl := FirstLineOfParagraph (LineX.Line); Count := 0;
    FirstPl := Pl;
    repeat
      P := PStrings[Pl];
      if P <> nil then begin
        if Pl = LineX.Line then Count := Count+LineX.X else begin
          Count := Count + length(P^)(*+1*);
          //if P^[length(P^)] = ' ' then dec (Count);
        end;
        if (IndentChar(nil) <> #0) and (Pl <> FirstPl) then begin
          IndentI := 1; while P^[IndentI] = IndentChar(Pl) do inc (IndentI);
          dec (IndentI);
          Count := Count - IndentI;
        end;
      end;
      if (Pl = nil) or (Pl = LineX.Line) then break;
      Pl := Pl^.next;
    until false;
    result := Count;
  end;

function tWrapEditor.ParagraphCharCount2LineX (FirstlineofPar : PLine; Count : longint) : TLineX;
  var
    Pl : PLine; P : PString; lenline, IndentI : integer;
  begin
    Pl := FirstLineofPar;
    repeat
      P := PStrings[Pl];
      if P = nil then break;
      lenline := length(P^)(*+1*); IndentI := 0;
      if (IndentChar(nil) <> #0) and (Pl <> FirstlineofPar) then begin
        IndentI := 1; while P^[IndentI] = IndentChar(Pl) do inc (IndentI);
        dec (IndentI);
        lenline := lenline - IndentI;
      end;
      if (Count <= lenline) {4.11.2002}or {Hardreturn}GetPHardReturn(Pl) then break;
      Count := Count - lenline;
      Pl := Pl^.next;
    until false;
    result.Line := Pl;
    result.X := Count + IndentI;
  end;

procedure tWrapEditor.ConditionalFormat (CharKey : boolean);
  var
    P : PString;
  begin
    if not FWrap then exit;
    if NoFormat then exit;
    if ManualFormat then begin
      P := PStrings[ActLine];
      if ((Cursorpos.X > MaxCol) and CharKey) or ((P <> nil) and (length(P^) > 250)) then
        FormatParagraphFromLine (Cursorpos.Y);
    end
    else begin
      if (not DelayedFormat) or ((Cursorpos.X > MaxCol) and CharKey) then
        FormatParagraphFromLine (Cursorpos.Y)
      else
        FormatSoon := true;
    end;
  end;

procedure TWrapEditor.CharEvent(var Key : char; RepeatCount: Byte);
  begin
    inherited CharEvent (Key, RepeatCount);
    ConditionalFormat (true);
  end;

procedure tWrapEditor.ScanEvent(var KeyCode: TKeyCode; RepeatCount: Byte);
  var
    P : PString;
  begin
    ModifyingAction := false;
    inherited ScanEvent (KeyCode, RepeatCount);
    if not FWrap then exit;
    if (KeyCode <> kbCtrl)
    and {Korrektur Erg„nzung 11.5.2000}(KeyCode <> kbAlt) and (KeyCode <> 0)
    and (KeyCode <> kbShift)
    and (KeyCode <> kbAltBksp) and (KeyCode <> kbAltShiftBksp)
    and (KeyCode <> kbCtrlBksp) and (KeyCode <> kbCtrlShiftBksp)
    then begin
      if ModifyingAction then ConditionalFormat (false);
      if WrapCursorFeeling then begin
        P := PStrings[ActLine];
        if (P <> nil) and (Cursorpos.X > length(P^)+1) then Cursorpos := Editorpos (Cursorpos.Y, length(P^)+1);
      end;
    end;
  end;

procedure tWrapEditor.cmCursorRight;
  var
    P : PString;
  begin
    P := PStrings[ActLine];
    if Wrap and WrapCursorFeeling and (P <> nil) and (Cursorpos.X > length(P^)(*+ord(not GetPHardReturn(ActLine))*)) then begin
      if ActLine <> LastLine then
        Cursorpos := Editorpos (Cursorpos.Y+1, 1);
    end
    else inherited cmCursorRight;
  end;

Procedure tWrapEditor.cmCursorLeft;
  var
    P : PString;
  begin
    if Wrap and WrapCursorFeeling and (Cursorpos.X = 1) and (ActLine^.prev <> nil) then begin
      P := PStrings[ActLine^.prev];
      Cursorpos := Editorpos (Cursorpos.Y-1, length(P^)+1+ord(not GetPHardReturn(ActLine^.prev)));
    end
    else inherited cmCursorLeft;
  end;

procedure TWrapEditor.cmBreakLine;
  var
    HRgemerkt : boolean;
  begin
    if not FWrap then begin
      inherited cmBreakLine;
      exit;
    end;
    HRgemerkt := GetPHardReturn (ActLine);
    inherited cmBreakLine;
    SetPHardReturn (ActLine, true);
    if ActLine^.next <> nil then
      SetPHardReturn (ActLine^.next, HRgemerkt);
    InvalidateEditor (0,0);
  end;

procedure TWrapEditor.cmDeleteLeftWord;
  var
    IndentI : byte; P : PString;
  begin
    if not FWrap then begin
      inherited cmDeleteLeftWord;
      exit;
    end;
    IndentI := 0;
    if (IndentChar(ActLine) <> #0) and (ActLine <> FirstLineOfParagraph (ActLine)) then begin
      P := PStrings[ActLine];
      if P <> nil then begin
        IndentI := 1; while P^[IndentI] = IndentChar(ActLine) do inc (IndentI);
        dec (IndentI);
      end;
    end;
    if Cursorpos.X <= IndentI+1 then cmBackspace
    else inherited cmDeleteLeftWord;
    //{new}FormatParagraphFromLine (Cursorpos.Y);
    ConditionalFormat (false);
  end;

function tWrapEditor.DelCursorCorrection : boolean;
  var
    Line : string;
    Leer : boolean;
    I : byte;
  begin
    result := false;
    if not FWrap then exit;
    if {Softreturn-Zeile} not GetPHardReturn (ActLine) then begin
      {seit WSedit 0.98. Ctrl-T und Ctrl-G hat unter Umst„nden am Zeilenende nicht mehr funktioniert}
      LoadStringOfPLine (ActLine, Line);
      if length(Line) = 0 then begin
        cmDeleteLine; result := true; exit; {wsed 0.98b}
      end;
      Leer := true;
      for I := Cursorpos.X to length(Line) do if Line[I] <> ' ' then begin
        Leer := false; break;
      end;
      if Leer and (Cursorpos.X <= length(Line)) then
        cmCursorEnd;
      {wenn der Cursor schon ganz rechts steht, dann an den Anfang der n„chsten Zeile,
       aber nur bei Zeilen mit weichem Return}
      if (Cursorpos.X > length(Line)) and (not GetPHardReturn (ActLine)) then begin
        {an den Anfang der n„chsten Zeile springen}
        //cmCursorRight;
        {wse098}cmCursorHome; cmCursorDown;
        {wse098b}
        if IndentChar(nil) <> #0 then begin
          LoadStringOfPLine (ActLine, Line);
          while (Cursorpos.X < length(Line)) and (Line[Cursorpos.X] = IndentChar(Actline)) do
            cmCursorRight;
        end;
        result := true; {L”schfunktion gel”scht}
      end;
    end;
  end;

procedure tWrapEditor.cmDeleteRightWord;
  begin
    if FormatParagraphFromLine (Cursorpos.Y) then exit;
    if DelCursorCorrection then exit;
    inherited cmDeleteRightWord;
    //{new}FormatParagraphFromLine (Cursorpos.Y);
  end;

procedure tWrapEditor.cmDeleteChar;
  begin
    if FormatParagraphFromLine (Cursorpos.Y) then exit;
    if DelCursorCorrection then exit;
    inherited cmDeleteChar;
    //{new}FormatParagraphFromLine (Cursorpos.Y);
    ConditionalFormat (false);
  end;



Procedure TWrapEditor.cmBackSpace;
  var
    Line : string; IndentI : byte; P : PString;
    NewCursorpos : tEditorpos;
    RememberCursorposY : longint;
    RememberActLineHR, DeleteSpace : boolean;
  begin
    if not FWrap then begin
      inherited cmBackSpace;
      exit;
    end;
    if IndentChar(nil) <> #0 then begin
      if ActLine <> FirstLineOfParagraph (ActLine) then begin
        LoadStringOfPLine (ActLine, Line);
        IndentI := 1; while Line[IndentI] = IndentChar(ActLine) do inc (IndentI);
        dec (IndentI);
        if (IndentI > 0) and (Cursorpos.X <= IndentI+1) then begin
          delete (Line, 1, IndentI); ReplacePLine (ActLine, Line);
          NewCursorpos.X := 1; NewCursorpos.Y := Cursorpos.Y;
          Cursorpos := NewCursorpos;
        end;
      end;
    end;
    RememberActLineHR := GetPHardReturn (ActLine);
    DeleteSpace := false;
    if (ActLine^.prev <> nil) and (not GetPHardReturn (ActLine^.prev)) then begin
      P := PStrings[ActLine^.prev];
      if (P <> nil) and (length(P^) > 0) then DeleteSpace := P^[length(P^)] = ' ';
    end;
    RememberCursorposY := Cursorpos.Y;
    inherited cmBackSpace;
    if RememberCursorposY = Cursorpos.Y+1 then begin
      {Backspace has deleted a line}
      {restore the Return value of the deleted line and set it to the line before}
      HardReturn[Cursorpos.Y] := RememberActLineHR;
      InvalidateEditor (Offsetpos.Y,Offsetpos.Y);
      {delete ending space of a softreturn line}
      if DeleteSpace then inherited.cmBackSpace;
    end;
    //{new}FormatParagraphFromLine (Cursorpos.Y);
    ConditionalFormat (false);
  end;

procedure TWrapEditor.cmEnter;
  var
    HR, DoFormat : boolean;
  begin
    {if pressing Enter, the current line gets a Hardreturn and the following line gets
     the return value of the current line.}
    if not FWrap then begin
      inherited cmEnter;
      exit;
    end;
    HR := HardReturn [Cursorpos.Y];
    DoFormat := Cursorpos.X > 1;
    inherited cmEnter;
    if PLines[Cursorpos.Y-1]{the old ActLine} <> nil then begin
      HardReturn[Cursorpos.Y-1] := true;
      HardReturn[Cursorpos.Y] := HR;
      InvalidateEditor (Offsetpos.Y-1,Offsetpos.Y);
      if DoFormat then FormatParagraphFromLine (Cursorpos.Y);
    end;
  end;

Procedure TWrapEditor.cmICBDeleteBlock;
  begin
    inherited cmICBDeleteBlock;
    FormatParagraphFromLine (Indices[ICB.First.Line]);
  end;

procedure TWrapEditor.cmICBMoveBlock;
  var
    HR_oldCursorpos, HR_oldFirstBlock, HR_oldLastBlock : boolean;
    oldICB : TICB;
  begin
    if (SelectMode = smColumnBlock) or (not FWrap) then
      inherited cmICBMoveBlock
    else begin
      HR_oldCursorpos := GetPHardReturn (ActLine);
      HR_oldFirstBlock := GetPHardReturn (ICB.First.Line);
      HR_oldLastBlock := GetPHardReturn (ICB.Last.Line);
      oldICB := ICB;
      OldBlockPosition := ICB.First;
      inherited cmICBMoveBlock;
      SetPHardReturn (ICB.First.Line, HR_oldFirstBlock);
      SetPHardReturn (ICB.Last.Line, HR_oldCursorpos);
      if Indices[oldICB.First.Line] > 0 {oldICB.First.Line still exists} then begin
        SetPHardReturn (oldICB.First.Line, HR_oldLastBlock);
        FormatParagraphFromLine (Indices[oldICB.First.Line]);
      end;
      FormatParagraphFromLine (Indices[ICB.First.Line]);
      FormatParagraphFromLine (Indices[ICB.Last.Line]);
      //InvalidateEditor (0,0);{ist schon in FormatParagraphFromLine enthalten}
    end;
  end;

Procedure tWrapEditor.SetModified(Value:Boolean);
  begin
    inherited SetModified (Value);
    ModifyingAction := true;
  end;


function tWrapEditor.TabToSpaces : boolean;
  begin
    TabToSpaces := false;{ist hier eigentlich egal}
  end;

Procedure TWrapEditor._WriteWorkLine;
Begin
   {the same procedure like in TEditor, but does not delete the SPACES at the end of the line}
     if not FWrap then begin
       inherited _WriteWorkLine;
       exit;
     end;
     WLactivated := False;
     If FActLine^.zk <> Nil Then Exit;
     (*While (Length(FWorkLine) > 0) And (FWorkLine[Length(FWorkLine)] = ' ')
        Do SetLength(FWorkLine,Length(FWorkLine)-1);*)
     If Length(FWorkLine) > StringLength Then SetLength(FWorkLine,StringLength);

     PLineNewString (FActLine, FWorkLine);
End;

function TWrapEditor.DeleteIndent (pl : PLine; var Line : string) : byte;
    var
      I : byte;
    begin
      I := 1;
      while (I <= length(Line)) and (Line[I] = IndentChar(pl)) do inc (I);
      dec (I);
      delete (Line, 1, I);
      result := I;
    end;

procedure TWrapEditor.GetActualCol (Pl : PLine);
  begin
    {overwrite this method to influence the right margin for formatting}
    //ActualCol := MaxCol;
  end;

function tWrapEditor.ScrollbarIsVisible : boolean;
  begin
    result := ActualCol > MaxCol;
  end;

procedure TWrapEditor.SetScrollbarVisibility;
  var
    OldScrollStyle : tScrollStyle;
    Rect : tRect;
  begin
    OldScrollStyle := Scrollbars;
    if ScrollbarIsVisible then begin {do not show vertical scrollbar}
      if Scrollbars <> ssBoth then
      Scrollbars := ssBoth
    end
    else
      Scrollbars := ssVertical;
    if OldScrollStyle <> Scrollbars then begin
      CalcSizes;
      if Scrollbars = ssBoth then begin
        {delete the last line}
        Rect.Left := 1; Rect.Right := ClientWidth; Rect.Top := Canvas.FontHeight*2; Rect.Bottom := 1;
        Redraw (Rect);
        HorzScrollBar.SetScrollRange(1,ActualCol+Cursorpos.X-Offsetpos.X{7/2006}, MaxCol);
        BottomScrollBar := HorzScrollBar;
      end
      else
        BottomScrollBar := nil;
      InvalidateEditor (0,0);
    end;
  end;

function TWrapEditor.FormatParagraphFromLine (Y : longint) : boolean;
  var
    I, J : byte; II : integer;
    Line, NextLine, MoveSt, IndentSt, TempSt : string;
    RememberModified, Finished, CursorMoved, StrongModified, Modified, BreakRet : boolean;
    ParagraphModified : boolean;
    NewCursorpos : tEditorpos;
    PlFirst, PlY, Pl : PLine;
    IndentI : byte;
    Fline : string;
    Bugcounter : longint;
    RememberICBFirstCharcount, RememberICBLastCharcount, FromLineY, OffsetY : longint;

  procedure ReplacePlYline (var St : string);
    var
      P : PString;
    begin
      if (not GetPHardReturn(PlY)) and (not GetPBreakReturn(PlY)) {line has got Softreturn} then begin
        {line should end with a SPACE}
        if (length(St) > 0) and (length (St) < 255) and (St[length(St)] <> ' ') and (St[length(St)] <> #240) then begin
          inc (St[0]); St[length(St)] := ' ';
        end;
      end;
      P := PStrings[PlY];
      if (P = nil) or (P^ <> St) then
        ReplacePLine (PlY, St);
    end;

  procedure StrongModification;
    begin
      if not StrongModified then begin
        BeginUpdate;
        StrongModified := true;
        result := true;
      end;
    end;

  begin {FormatParagraphFromLine}
    result := false;    
    if not FWrap then exit;
    FromLineY := Y;
    if NoFormat then exit;
    RememberModified := Modified;
    CalculateMaxCol;
    PlY := _Index2PLine (Y);
    if PLY = nil then exit; {Korrektur 2.5.2000 ^KV zum Textende fhrte zu Absturz}
    AdditionalUndo := true;
    StrongModified := false; result := false; ParagraphModified := false;
    //BeginUpdate;{2.5.2000 nach unten verschoben}
    PlFirst := FirstLineOfParagraph (PlY);

    {verhindern, daá Umbruch versucht wird, wenn Schneezeichen weit rechts steht; 28.5.2007}
    if (PlY = PlFirst) and (not GetPHardReturn(PlY){Softreturn}) then begin
      LoadStringOfPLine (PlY, Line);
      II := 0;
      for I := 1 to length(Line) do if Line[I] = IndentChar(PlY) then II := I;
      if II >= integer(ActualCol) - 20 then begin
        delete (Line, II, 1);
        ReplacePLine (PlY, Line);
        Beep (400, 20);
        exit;
      end;
    end;

    {zweites, drittes... Leerzeichen am Ende einer Softreturnzeile l”schen (wse098b)}
    Pl := PlFirst;
    while (Pl <> nil) and (not GetPHardReturn(Pl){Softreturn}) and (not GetPBreakReturn(Pl)) do begin
      LoadStringOfPline (Pl, Line);
      Modified := false;
      while (length(Line) > 1) and (Line[length(Line)] = ' ') and (Line[length(Line)-1] = ' ') do begin
        dec (Line[0]); Modified := true;
      end;
      if Modified then begin
        ReplacePLine (Pl, Line);
      end;
      Pl := Pl^.next;
    end;

    if (ICB.First.Line <> nil) and (FirstLineOfParagraph(ICB.First.Line) = PlFirst) then{Blockbegin inside this paragraph}
      RememberICBFirstCharcount := LineX2ParagraphCharCount (ICB.First)
    else
      RememberICBFirstCharcount := 0;
    if (ICB.Last.Line <> nil) and (FirstLineOfParagraph(ICB.Last.Line) = PlFirst) then{Blockend inside this paragraph}
      RememberICBLastCharcount := LineX2ParagraphCharCount (ICB.Last)
    else
      RememberICBLastCharcount := 0;
    GetActualCol (PlY);
    SetScrollbarVisibility;
    if IndentChar(nil) <> #0 then begin
      LoadStringOfPLine (PlFirst, Fline);
      I := length(Fline);
      while (I > 0) and (Fline[I] <> IndentChar(PlFirst)) do dec (I);
      {in I steckt nun die Spaltenzahl, in der das letzte Schneezeichen steht}
      IndentI := 0;
      for J := 1 to I do if (Fline[J] > #31) then inc (IndentI);
      //IndentI := I;
      IndentSt := '';
      for I := 1 to IndentI do begin
        inc (IndentSt[0]); IndentSt[ord(IndentSt[0])] := IndentChar(PlFirst);
      end;
    end
    else IndentI := 0; {Korrektur 28.4.00}
    LoadStringOfPLine (PlY, Line);
    Finished := false; BugCounter := 0;
    while (Y <= CountLines) and (not Finished) do begin
      inc (BugCounter);
      if BugCounter > 5000 then begin
        Beep (100, 200); {Bug!}
        break;
      end;
      if (IndentChar(nil) <> #0) and (Line <> '') and (PlFirst <> PlY) then begin
        DeleteIndent (PlY, Line);
        //for I := 1 to length(IndentSt) do IndentSt[I] := '*';
        Line := IndentSt + Line;
      end;
      if length(Line) < ActualCol then begin
        if GetPHardReturn(PlY) or (Y = CountLines) then begin
          Finished := true;
          if IndentChar(nil) <> #0 then
            ReplacePlYline (Line);
        end
        else begin
          {grab the first words of the next line and add it to this line}
          ParagraphModified := true;
          LoadStringOfPLine (PlY^.next, NextLine);
          DeleteIndent (PlY, NextLine);
          if length(Line) + 1 + length(NextLine) <= ActualCol then begin
            {complete next line can be added to old line}
            if (length(Line) = 0) or (Line[length(Line)] = ' ') then
              TempSt := Line + NextLine
            else if Line[length(Line)] = #240 then
              TempSt := copy (Line, 1, length(Line)-1) + NextLine
            else
              TempSt := Line + ' ' + NextLine;
            ReplacePlYline (TempSt);
            SetPHardReturn(PlY, GetPHardReturn(PlY^.next));
            StrongModification; DeleteLine (Y+1);
            inc (Y);
            PlY := _Index2PLine (Y);
            LoadStringOfPLine (PlY, Line);
          end
          else begin
            {only a part of the next line has to be added, no Return flags changed}
            II := ActualCol - length(Line);
            while (II > 0) and (NextLine[II] <> ' ') do dec (II);
            BreakRet := (II = 0{Nextline}) and GetPBreakReturn (PlY);
            if BreakRet then II := ActualCol - length(Line);
            //if BreakRet then Beep (100, 100) else
            //Beep (1000, 100);
            //if II > 0 then begin
            if BreakRet then
              TempSt := Line + copy (NextLine, 1, II)
            else if (length(Line) = 0) or (Line[length(Line)] = ' ') then
              TempSt := Line + copy (NextLine, 1, II-1)
            else if Line[length(Line)] = #240 then
              TempSt := copy (Line, 1, length(Line)-1) + copy (NextLine, 1, II-1)
            else
              TempSt := Line + ' ' + copy (NextLine, 1, II-1);
            ReplacePlYline (TempSt);
            inc (Y);
            PlY := _Index2PLine (Y);
            Line := copy (NextLine, II+1, 255);
            ReplacePlYline (Line);
            (*end
            else begin
              {line length is OK}
              if IndentChar(nil) <> #0 then
                ReplacePlYline (Line);
              inc (Y);
              PlY := _Index2PLine (Y);
              LoadStringOfPLine (PlY, Line);
            end;*)
          end;
        end;
      end
      else if (length(Line) > ActualCol)
           (*and not ((length(Line) = ActualCol+1) and (Line[length(Line)] = ' '))*)
           then begin
        {copy the text which is too long to the next line}
        ParagraphModified := true;
        I := ActualCol+1;
        while (I > 0) and (Line[I] <> ' ') do dec (I);
        BreakRet := I = 0;
        if BreakRet then I := ActualCol(*+1*);
        //if I > 0 then begin
          {I points to SPACE}
        MoveSt := copy (Line, I+1, 255);
        TempSt := copy (Line, 1, I{SPACE included});
        ReplacePlYline (TempSt);
        CursorMoved := false;
        if (Cursorpos.Y = Y) and (Cursorpos.X > I) then begin
          NewCursorpos.Y := Cursorpos.Y+1;
          NewCursorpos.X := Cursorpos.X - I + IndentI;
          //Beep (200, 20);
          Cursorpos := NewCursorpos;
          CursorMoved := true;
        end;
        if GetPHardReturn(PlY) then begin
          if (MoveSt = '') and (IndentI > 0) then begin
           {wse096 schwer reproduzierbarer Einrck-Tippfehler gefixt:}
            MoveSt := IndentSt;
          end;
          StrongModification; InsertLine{before} (Y+1, MoveSt);
          if CursorMoved then begin
            {oops, target line for cursor was not existing yet. Repeat jump}
            Cursorpos := NewCursorpos;
          end;
          SetPHardReturn(PlY, false);
          SetPBreakReturn (PlY, BreakRet);
          inc (Y);
          PlY := _Index2PLine (Y);
          LoadStringOfPLine (PlY, Line);
          SetPHardReturn(PlY, true);
        end
        else begin {current line has softreturn}
          SetPBreakReturn (PlY, BreakRet);
          inc (Y);
          PlY := _Index2PLine (Y);
          LoadStringOfPLine (PlY, Line);
          DeleteIndent (PlY, Line);
          if length(MoveSt) + 1 + length(Line) >= 255 then begin
            {oops, Line does not fit a String}
            StrongModification;
            InsertLine (Y, MoveSt);
            HardReturn[Y] := false; (*BreakReturn[Y] := BreakRet;*)
            {set Y to the old value}inc (Y);
            ReplacePlYline ({Y+1}Line);
            {the next loop, compile the same line which is yet too long}
            dec (Y);
            PlY := PLines[Y];
            LoadStringOfPLine (PlY, Line);
          end
          else begin
            if BreakRet or (length(MoveSt) = 0) or (MoveSt[length(MoveSt)] = ' ') then
              Line := MoveSt + Line
            else if MoveSt[length(MoveSt)] = #240 then
              Line := copy (MoveSt, 1, length(MoveSt)-1) + Line
            else
              Line := MoveSt + ' ' + Line;
            ReplacePlYline (Line);
          end;
        end;
        (*end
        else {do nothing} begin
          inc (Y);
          PlY := _Index2PLine (Y);
        end;*)
      end
      else {length(Line) = ActualCol} begin
        if GetPHardReturn(PlY) or (Y = CountLines) then Finished := true;
        if IndentChar(nil) <> #0 then
          ReplacePlYline (Line);
        inc (Y);
        PlY := _Index2PLine (Y);
        LoadStringOfPLine (PlY, Line);
      end;
      if (PlY <> nil) and (FirstLineOfParagraph (PlY) <> PlFirst) then Finished := true;{wse0.99f: vermeiden von Manipulationen im n„chsten Absatz}
    end; {while}
    if not GetPHardReturn(LastLine){last is softreturn} then SetPHardReturn (LastLine, true);
    if (RememberICBFirstCharcount > 0) or (RememberICBLastCharcount > 0) then begin
      _ICBClearMark;
      if RememberICBFirstCharcount > 0 then
        ICB.First := ParagraphCharCount2LineX (PlFirst, RememberICBFirstCharcount);
      if RememberICBLastCharcount > 0 then
        ICB.Last := ParagraphCharCount2LineX (PlFirst, RememberICBLastCharcount);
      _ICBSetMark;
    end;
    if StrongModified then EndUpdate
    else if ParagraphModified then begin
      OffsetY := CursorPos.Y-OffsetPos.Y;
      //for II := FromLineY to Y do begin Beep (2000, 100); Beep (2500, 100); end;
      //Beep (2000, 300);
      InvalidateEditor (FromLineY-OffsetY, Y-OffsetY);
    end;
    Modified := RememberModified;
    FormatSoon := false;
    AdditionalUndo := false;
  end; {FormatParagraphFromLine}

function TWrapEditor.FirstLineOfParagraph (plStart : PLine) : PLine;
  var
    Plast, Pl : PLine;
  begin
    Pl := plStart;
    repeat
      Plast := Pl;
      Pl := Pl^.prev;
      if Pl = nil then break;
      if GetPHardReturn (Pl) then break;
    until false;
    result := Plast;
  end;

function TWrapEditor.LastLineOfParagraph (plStart : PLine) : PLine;
  var
    Pl : PLine;
  begin
    Pl := plStart;
    while not ((Pl = nil) or GetPHardReturn (Pl) or (Pl = LastLine)) do Pl := Pl^.next;
    result := Pl;
  end;

Procedure TWrapEditor.SelectParagraph(P:TEditorPos);
Var  pl:PLine;
Begin
     DeselectAll;
     pl := _Index2PLine(P.Y);
     If (pl <> Nil) and (FSelectMode <> smColumnBlock) Then
     Begin
          ICB.First.Line := FirstLineOfParagraph(pl);
          ICB.First.X := 1;
          Pl := LastLineOfParagraph (Pl);
          if Pl = nil then exit;
          if Pl <> LastLine then begin
             ICB.Last.Line := pl^.next;
             ICB.Last.X := 1;
          End
          else begin
             ICB.Last.Line := pl;
             ICB.Last.X := Length(_PLine2PString(pl)^);
          end;
          _ICBCheckX;
          _ICBSetMark;
          ICBVisible := True;
     End;
     InvalidateEditor(0,0);
End;

procedure tWrapEditor.InvalidateParagraph;
  var
    ts, flp, llp : longint;
  begin
    ts := indices[TopScreenLine];
    flp := indices[FirstLineOfParagraph (Actline)];
    llp := indices[LastLineOfParagraph (Actline)];
    InvalidateEditor (flp-ts+1,llp-ts+1);
  end;

procedure TWrapEditor.UseNextReturnflag (pl : PLine);
  var
    HRnext : boolean;
  begin
    if pl = nil then exit;
    if pl^.next = nil then exit;
    HRnext := GetPHardReturn (pl^.next);
    SetPHardReturn (pl, HRnext);
  end;

Procedure TWrapEditor.SetPHardReturn(pl:PLine;Const S:boolean);
  begin
    if pl = Nil then Exit;    {indexerror}
    if S then
      pl^.flag := pl^.flag AND NOT ciSoftReturn
    else
      pl^.flag := pl^.flag OR ciSoftReturn;
  end;

Procedure TWrapEditor.SetPBreakReturn(pl:PLine;Const S:boolean);
  begin
    if pl = Nil then Exit;    {indexerror}
    if S then
      pl^.flag := pl^.flag OR ciBreakReturn
    else
      pl^.flag := pl^.flag AND NOT ciBreakReturn;
  end;

Procedure TWrapEditor._SetHardReturn(Y:LongInt;Const S:boolean);
  var
    pl : Pline;
  begin
    pl := _Index2PLine(Y);
    SetPHardReturn (pl, S);
  end;

Procedure TWrapEditor._SetBreakReturn(Y:LongInt;Const S:boolean);
  var
    pl : Pline;
  begin
    pl := _Index2PLine(Y);
    SetPBreakReturn (pl, S);
  end;

Function TWrapEditor.GetPHardReturn(pl:PLine):boolean;
  begin
    Result := true;
    if pl = Nil then Exit;    {indexerror}
    if pl^.flag AND ciSoftReturn <> 0 then
      Result := false
    else
      Result := true;
  end;

Function TWrapEditor.GetPBreakReturn(pl:PLine):boolean;
  begin
    Result := true;
    if pl = Nil then Exit;    {indexerror}
    if pl^.flag AND ciBreakReturn = 0 then
      Result := false
    else
      Result := true;
  end;

Function TWrapEditor._GetHardReturn(Y:LongInt):boolean;
  var
    pl : Pline;
  begin
    Result := true;
    pl := _Index2PLine(Y);
    if pl = Nil then Exit;    {indexerror}
    Result := GetPHardReturn (pl);
  end;

Function TWrapEditor._GetBreakReturn(Y:LongInt):boolean;
  var
    pl : Pline;
  begin
    Result := true;
    pl := _Index2PLine(Y);
    if pl = Nil then Exit;    {indexerror}
    Result := GetPBreakReturn (pl);
  end;

procedure TWrapEditor.CalculateMaxCol;
  var
    CalcCol : integer;
  begin
    if MaxColFixed then exit;
    CalcCol := (ClientWidth div Font.Width) - 5;
    if (CalcCol < 40) then CalcCol := 40
    else if (CalcCol > 250) then CalcCol := 250;
    MaxCol := CalcCol;
  end;

procedure TWrapEditor.ReformatAll;
  var
     Ptr:^LongWord;
     len:LongInt;
     LineX : tLineX;
     OldPara, OldCharCount : longint;
     RememberSelected, RememberModified, ROnly : boolean;
     OldSelectMode:TSelectMode;
     SelStart, SelEnd : tEditorpos;
     PSelStart, PSelEnd, CCSelStart, CCSelEnd: longint;
  begin
    OldSelectMode := FSelectMode;
    FSelectMode := smNonInclusiveBlock;
    if _GetEditorText(Ptr,len) then begin
      RememberModified := Modified;
      OldPara := Editorpos2Paragraph (Cursorpos);
      LineX.X := Cursorpos.X;
      LineX.Line := ActLine;
      OldCharCount := LineX2ParagraphCharCount (LineX);
      if Selected then begin
        GetSelectionStart (SelStart); GetSelectionEnd (SelEnd);
        PSelStart := Editorpos2Paragraph (SelStart); PSelEnd := Editorpos2Paragraph (SelEnd);
        LineX.X := SelStart.X; LineX.Line := ICB.First.Line;
        CCSelStart := LineX2ParagraphCharCount (LineX);
        PSelEnd := Editorpos2Paragraph (SelEnd); PSelEnd := Editorpos2Paragraph (SelEnd);
        LineX.X := SelEnd.X; LineX.Line := ICB.Last.Line;
        CCSelEnd := LineX2ParagraphCharCount (LineX);
      end;
      RememberSelected := Selected;
      BeginUpdate;
      ROnly := ReadOnly;
      if ROnly then ReadOnly := false;
      SelectAll;
      DeleteSelection;
      CodepageConversion (Ptr, len);
      _InsertText (Ptr, len-1{do not write #0 into editor}, false);
      FreeMem(Ptr,len);
      if ROnly then ReadOnly := true;
      Cursorpos := ParagraphCharCount2EditorPos (OldPara, OldCharCount);
      FUndolist.Clear;
      FRedolist.Clear;
      FSelectMode := OldSelectMode;
      if RememberSelected then begin
        SelStart := ParagraphCharCount2EditorPos (PSelStart, CCSelStart);
        SelEnd := ParagraphCharCount2EditorPos (PSelEnd, CCSelEnd);
        SetSelectionStart (SelStart); SetSelectionEnd (SelEnd);
      end;
      EndUpdate;
      Modified := RememberModified;
    end;
  end;

procedure tWrapEditor.CodepageConversion (P:Pointer; len:LongInt);
  begin
    {can be overwritten to make e.g. an OEM to ANSI conversion while running "ReformatAll"}
  end;

function tWrapEditor.ParagraphCharCount2EditorPos (Para, CharCount : longint) : tEditorPos;
  var
    Curpos : tEditorPos;
    Line : PLine;
    LineX : tLineX;
  begin
    Curpos := Paragraph2Line (Para);
    Line := PLines[Curpos.Y];
    LineX := ParagraphCharCount2LineX (Line, CharCount);
    Curpos.Y := Indices[LineX.Line];
    Curpos.X := LineX.X;
    result := Curpos;
  end;

procedure tWrapEditor.Resize;
  var
    OldCol : byte;
  begin
    inherited Resize;
    if not FWrap then exit;
    OldCol := MaxCol;
    CalculateMaxCol;
    if (MaxCol <> OldCol) and (MaxCol >= 30) then
      ReformatAll;
  end;

{Copy ICB To A Text block With the Length len; return True If successful}
Function TWrapEditor._GetEditorBlock(Var P:Pointer; Var len:LongInt):Boolean;
Var  pl:PLine;
     Ptr:Pointer;
     Str:String;
     zk:PString;
     lzk:Integer;
     CRLF, SPACE:String[5];
     area:TICB;
     I : byte;
  procedure CopyReturn;
    var
      lCh : char;
    begin
      if Pl^.zk = nil then lCh := #0 else lCh := Pl^.zk^[length(Pl^.zk^)];
      if SaveAsShown then begin
        if (not GetPHardReturn(pl){Softreturn}) and (lCh <> ' ') then begin
          System.Move(SPACE[1], Ptr^, 1);
          inc (Ptr);
        end;
        System.Move(CRLF[1], Ptr^, 2);
        inc (Ptr, 2);
      end
      else begin
        if GetPHardReturn(pl) then begin
          System.Move(CRLF[1], Ptr^, 2);
          Inc(Ptr, 2);
        end
        else if (not GetPBreakReturn(pl)) and (lCh <> ' ') then begin
          System.Move(SPACE[1], Ptr^, 1);
          inc (Ptr);
        end;
      end;
    end;
  function LenOfReturn (Pl : PLine) : longint;
    var
      lCh : char;
    begin
      if Pl^.zk = nil then lCh := #0 else lCh := Pl^.zk^[length(Pl^.zk^)];
      if GetPBreakReturn(pl) and (not GetPHardReturn(pl)) then
        result := 0
      else if SaveAsShown then begin
        if (not GetPHardReturn(pl){Softreturn}) and (lCh <> ' ') then
          result := 3
        else
          result := 2;
      end
      else begin
        if GetPHardReturn(Pl) then
          result := 2
        else
          result := ord (lCh <> ' ');
      end;
    end;
  procedure MoveString ({nicht var!}Str : string);
    begin
      (*
      {should not occur, but in any case, omit Zero-Characters in the string}
      I := 1;
      while I <= length (Str) do begin
        if Str[I] = #0 then delete (Str, I, 1);
        inc (I);
      end;
      *)

      (*
      if (IndentChar <> #0) and (FSelectMode = smColumnBlock) then begin
        {do not write IndentChars if Blockmode is selected}
        /*Spaces := true;
        for I := 1 to length (Str) do if Str[I] = IndentChar then Str[I] := ' '
        else if Str[I] <> ' ' then Spaces := false;*/
        Spaces := false;
      end;
      *)
      if (IndentChar(nil) <> #0) and not (SaveAsShown or (Pl = FirstLineOfParagraph(Pl))) then begin
        I := 1;
        while (I <= length(Str)) and (Str[I] = IndentChar(Pl)) do inc (I);
        dec (I);
      end
      else I := 0;
      //if not ((IndentChar <> #0) and (FSelectMode = smColumnBlock) and Spaces) then begin
        System.Move(Str[1+I], Ptr^, Length(Str)-I);   {NoANSI}
        Inc(Ptr, Length(Str)-I);
        {IndentChars are not moved, so correct len}
        dec(len, I);
      //end;
    end;
Begin {_GetEditorBlock}
     if not FWrap then begin
       result := inherited _GetEditorBlock (P, len);
       exit;
     end;
     Result := False;
     _ICBExtCorrectICB2;      {reorder firstx lastx If extselection}
     len := -1;
     area := ICB;
     If (area.First.Line = Nil) Or (area.Last.Line = Nil) Then Exit;

     If area.First.Line = area.Last.Line Then
     Begin
          len := area.Last.X - area.First.X;
          If len > 0 Then
          Begin
               Inc(len);         {terminating #0}
               GetMem(P,len);
               Str := _ReadString(area.First.Line,area.First.X,len-1) + #0;
               System.Move(Str[1], P^, len);    {NoANSI}
               Result := True;
          End;
     End
     Else
     Begin
          If FSelectMode <> smColumnBlock Then
          Begin
               pl := area.First.Line;
               lzk := Length(_PLine2PString(pl)^);
               {correct If To LONG}
               If area.First.X > lzk Then area.First.X := lzk+1;
               len := lzk - area.First.X+1+LenOfReturn(pl); {First Line}
               pl := pl^.Next;
               While pl <> area.Last.Line Do
               Begin
                    lzk := Length(_PLine2PString(pl)^);
                    Inc(len, lzk+LenOfReturn(pl));
                    pl := pl^.Next;
                    If pl = Nil Then Exit;
               End;
               Inc(len, area.Last.X +1);         {Last Line + terminating #0}
          End
          Else  {Extended Selection}
          Begin
               pl := area.First.Line;
               lzk := area.Last.X - area.First.X;
               len := lzk +LenOfReturn(pl);        {First Line}
               pl := pl^.Next;
               While pl <> area.Last.Line Do
               Begin
                    Inc(len, lzk+LenOfReturn(pl));
                    pl := pl^.Next;
                    If pl = Nil Then Exit;
               End;
               Inc(len, lzk +1);             {Last Line + terminating #0}
          End;

          GetMem(P,len);

          CRLF := #13#10;
          SPACE := ' ';
          pl := area.First.Line;
          Ptr := P;
          {First area Line}
          If FSelectMode <> smColumnBlock
          Then Str := _ReadString(area.First.Line,area.First.X,-1)
          Else Str := _ReadString(area.First.Line,area.First.X,lzk);
          MoveString (Str);
          CopyReturn;
          pl := pl^.Next;
          While pl <> area.Last.Line Do
          Begin
               If FSelectMode <> smColumnBlock Then
               Begin
                    zk := _PLine2PString(pl);
                    MoveString (zk^);
                    //System.Move(zk^[1], Ptr^, Length(zk^));    {NoANSI}
                    //Inc(Ptr, Length(zk^));
               End
               Else
               Begin
                    Str := _ReadString(pl,area.First.X,lzk);
                    MoveString (Str);
               End;
               CopyReturn;
               pl := pl^.Next;
          End;
          {Last area Line}
          If FSelectMode <> smColumnBlock
          Then Str := _ReadString(area.Last.Line,1,area.Last.X-1) + #0
          Else Str := _ReadString(area.Last.Line,area.First.X,lzk) + #0;
          MoveString (Str);

          {Martin Changed 22.01.00}
          len := len - 1;

          Result := True;
     End;
End;

Function TWrapEditor.HardReturnDependentOnLastChar (llCh : char) : boolean;
  begin
    result := true;
  end;


Function TWrapEditor._InsertText(P:Pointer; len:LongInt; marknew:Boolean):TLineX;
Var
     laststr : string;
     OldActLine:PLine;
  var
    St : string;
    llCh, lCh, Ch : char;
    Col, I, J : byte;
    bufp : pChar;
    bufI : longint;
    FirstLineOfBlock : PLine;
    IsFirstLine, RememberHardReturn, EditorWasEmpty : boolean;
    IndentI : byte; IndentSt : string;
    SoftreturnOccuring, ImportRunningText, _TabToSpaces : boolean;
  procedure CreateNewLine (HardReturn, BreakReturn : boolean);
    begin
      (*
      for I := 1 to length (St) do if St[I] = #9 then begin
        if (IndentChar = #0) or TabToSpaces then begin
          St[I] := ' ';
        end
        else St[I] := IndentChar;
      end;*)
      FWorkLine := FWorkLine + St;
      PLineNewString (FActLine, FWorkLine);
      WLactivated := False;
      _InsertLine(FActLine);
      SetPHardReturn (FActLine, HardReturn);
      SetPBreakReturn (FActLine, BreakReturn);
      FActLine := FActLine^.Next;
      FWorkLine := '';
      IsFirstLine := false;
      if not HardReturn then SoftreturnOccuring := true;
    end;
  begin
    if not FWrap then begin
      result := inherited _InsertText(P, len, marknew);
      exit;
    end;
    SoftreturnOccuring := false; ImportRunningText := false;
    CalculateMaxCol;
    GetActualCol (FActLine);
    SetScrollbarVisibility;
    RememberHardReturn := GetPHardReturn (FActLine); FirstLineOfBlock := FActLine;
    FillChar(Result, SizeOf(Result), 0);
    EditorWasEmpty := (FirstLine = LastLine) and (Lines[1] = '');
    If (len <= 0) Or (P = Nil) Then Exit;

    If FSelectMode = smColumnBlock Then marknew := False;
    OldActLine := FActLine;
    If marknew Then
    Begin
         _ICBClearMark;
         ICB.First.Line := FActLine;
         ICB.First.X := FFileCursor.X;
    End;
    If Not WLactivated Then _ReadWorkLine;
    IsFirstLine := true;
    If FFileCursor.X > Length(FWorkLine) Then laststr := ''
    Else laststr := Copy(FWorkLine,FFileCursor.X,255);
    SetLength(FWorkLine,FFileCursor.X-1);
    Ch := #0; lCh := #0; IndentI := 0;
    St[0] := #0; Col := 0;
    for I := 1 to 255 do IndentSt[I] := IndentChar(ActLine);
    _TabToSpaces := TabToSpaces;{TabToSpaces is slow! Do not use often}
    bufp := P;
    for bufI := 1 to len do begin
      llCh := lCh; lCh := Ch; Ch := char(bufp^);
      inc (Col);
      inc (St[0]); St[Col] := Ch;
      if (IndentChar(nil) = #0) or _TabToSpaces then begin
        if St[Col] = #9 then begin
          St[Col] := ' ';
          while Col mod 8 <> 0 do begin
            inc (St[0]); inc (Col); St[Col] := ' ';
          end;
        end;
      end
      else begin
        if (Ch = IndentChar(ActLine)) and (Col < ActualCol) then IndentI := Col;
        IndentSt[0] := chr(IndentI);
        if (St[Col] = #9) and (Col > 1) and (St[Col-1] = #9){two tabs} then begin
          {enter a space between the two tabs}
          inc (St[0]); St[Col] := ' '; inc (Col); St[Col] := #9;
        end;
      end;
      if (Col > ActualCol) and (not SaveAsShown) then begin
        {oops, line is too long -> inserting soft return!}
        I := Col;
        {running back to the rightmost space, here the soft return will be inserted}
        while (I > 0) and (St[I] <> ' ') do dec (I);
        if I > 0 then begin
          {a space has been found}
          St[0] := char(I);
          CreateNewLine (false{ist OK}, {break}false);
          for J := I to Col do St[J-I] := St[J];
          St[0] := char(Col-I);
          Col := Col-I;
          if IndentI > 0 then begin
            St := IndentSt + St; Col := Col + IndentI;
          end;
        end
        else begin
          I := ActualCol;
          St[0] := char(I);
          CreateNewLine (false{Softreturn, auch ok}, {breakreturn}true);
          for J := I to Col do St[J-I] := St[J];
          St[0] := char(Col-I);
          Col := Col-I;
        end;
      end
      else if (Col > 250) and SaveAsShown then begin
        ImportRunningText := true;
        CreateNewLine (false{auch ok}, {break}true);
        St[0] := #0; Col := 0;
      end;
      if (Ch = #10) and (lCh = #13) then begin
        if length(St) > 1 then dec(St[0], 2);{Achtung Underflow}
        if length(St) > 0 then CommandInterpreter (St, IsFirstLine);
        CreateNewLine (HardReturnDependentOnLastChar(llCh), false);
        IndentI := 0;
        St[0] := #0; Col := 0;
      end;
      inc (bufp);
    end;

    _ReadWorkLine;

    {Set Result To the End Of the inserted block}
    Result.Line := FActLine;
    Result.X := Length(FWorkLine) + {Korrektur 13.05.} length(St);
    Inc(Result.X);

    If marknew Then ICB.Last := Result;

    FWorkLine := FWorkLine + St + laststr;
    _WriteWorkLine;

    SetPHardReturn (ActLine, RememberHardReturn);

    _ICBCheckX;
    _ICBSetMark;
    ICBVisible := True;
    SetSliderValues;
    SetLineColorFlag(OldActLine,FActLine);
    FActLine := OldActLine;
    {$ifdef win32}
    InvalidateEditor (0,0); {Martin0106}
    {$endif}
    (*am 30.10.02 ausgeklammert
    if EditorWasEmpty and (CountLines > 1) then begin
      {delete the last empty line, that's the old empty firstline}
      PSt := PStrings[LastLine];
      if (PSt <> nil) and (length(PSt^) = 0) then begin
        DeleteLine (CountLines);
        SetPHardReturn ({new}LastLine, true);
      end;
    end;
    *)
    Modified := True;
    FormatParagraphFromLine (Indices[FirstLineOfBlock]);
    if SaveAsShown and SoftreturnOccuring and ImportRunningText then begin
      {show Error message}
      PostMsg (Application.MainForm.Handle, 7774,9,0);
    end;
  end;

function tWrapEditor.IndentChar (Line : PLine) : char;
  begin
    result := DefaultIndentChar;
  end;

procedure tWrapEditor.SetupComponent;
  begin
    inherited SetupComponent;
    FWrap := true; MaxColFixed := false;
    SaveAsShown := false;
    DefaultIndentChar := #0; WrapCursorFeeling := true; OldBlockPosition.Line := nil;
    DelayedFormat := false; ManualFormat := false; NoFormat := false;
    FormatSoon := false;
    RememberCurrentY := 0;
  end;

procedure tWrapEditor.CommandInterpreter (var St : string; IsFirstLine : boolean);
  begin
  end;


initialization
end.
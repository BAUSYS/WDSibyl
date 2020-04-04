
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit Mask;

Interface

Uses Dos,Messages,SysUtils,Color,Classes,Graphics,Buttons,Forms,StdCtrls,Dialogs,ClipBrd;

Const
   DefaultBlank:Char='_';
   MaskFieldSeparator:Char=';';
   MaskNoSave:Char='0';

   mMskTimeSeparator=':';
   mMskDateSeparator='/';
   mMskAlpha='L';
   mMskAlphaOpt='l';
   mMskAlphaNum='A';
   mMskAlphaNumOpt='a';
   mMskAscii='C';
   mMskAsciiOpt='c';
   mMskNumeric='0';
   mMskNumericOpt='9';
   mMskNumSymOpt='#';

   mDirReverse='!';
   mDirUpperCase='>';
   mDirLowerCase='<';
   mDirLiteral='\';

   EditTextExceptionMsg='Value in the edit field is invalid.'#13#10'Use escape key to cancel changes !';

Type
   EEditTextInvalid=Class(Exception);

   TOnEditTextInvalid=Procedure(Sender:TObject) Of Object;

   TMaskEdit=Class(TEdit)
      Private
             FEditMask:String;
             FCanvas:TCanvas;
             FMaskBlank:Char;
             FMaskSave:Boolean;
             FOnEditTextInvalid:TOnEditTextInvalid;
      Private
             Procedure SetEditMask(Const NewValue:String);
             Function GetCursorPos:LongInt;
             Function GetCurrentMask(Position:LongInt;Var UpLowCase:Byte;Var Blanks:Boolean):PChar;
             Procedure UpdateCursorPos;
             Function GetText:String;Virtual;
             Procedure SetText(Const NewValue:String);Virtual;
             Function GetIsMasked:Boolean;
             Function GetEditText:String;
             Procedure SetEditText(Const NewValue:String);
             Procedure CloseQuery(Sender:TObject;Var CanClose:Boolean);
      Protected
             Procedure EditTextInvalid;Virtual;
             Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
             Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
             Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
             Procedure SetupComponent;Override;
             Procedure SetupShow;Override;
             Procedure ParentNotification(Var Msg:TMessage);Override;
      Public
             Function ValidateEdit:Boolean;
      Protected
             Property InsertMode;
             Property OnCloseQuery;
      Public
             Property IsMasked:Boolean read GetIsMasked;
             Property EditText:String read GetEditText write SetEditText;
             Property MaskBlank:Char read FMaskBlank;
             Property MaskSave:Boolean read FMaskSave;
      Published
             Property EditMask:String read FEditMask write SetEditMask;
             Property Text:String read GetText write SetText;
             Property OnEditTextInvalid:TOnEditTextInvalid read FOnEditTextInvalid write FOnEditTextInvalid;
   End;

Function InsertMaskEdit(parent:TControl;Left,Bottom,Width,Height:LongInt;
                        Text,Hint:String):TMaskEdit;

Implementation

{$IFDEF OS2}
Uses PmWin;
{$ENDIF}


Function InsertMaskEdit(parent:TControl;Left,Bottom,Width,Height:LongInt;
                    Text,Hint:String):TMaskEdit;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Text:=Text;
     Result.Hint:=Hint;
     Result.AutoSize:=True;
     Result.parent := parent;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TMaskEdit Class implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TMaskEdit.SetupComponent;
Begin
     Inherited SetupComponent;

     FMaskBlank:=DefaultBlank;
     FMaskSave:=False;
     InsertMode:=False;
     OnCloseQuery:=CloseQuery;
End;

Procedure TMaskEdit.EditTextInvalid;
Begin
     If FOnEditTextInvalid<>Nil Then FOnEditTextInvalid(Self)
     Else Raise EEditTextInvalid.Create(EditTextExceptionMsg);
End;

Procedure TMaskEdit.ParentNotification(Var Msg:TMessage);
Begin
     Inherited ParentNotification(Msg);

     {$IFDEF OS2}
     If Msg.Param1Hi=EN_KILLFOCUS Then
     Begin
          Try
             If not ValidateEdit Then EditTextInvalid;
             InsertMode:=True;
          Except
             On E:EEditTextInvalid Do
             Begin
                  ErrorBox(E.Message);
                  Focus;
             End;
          End;
     End
     Else If Msg.Param1Hi=EN_SETFOCUS Then InsertMode:=False;
     {$ENDIF}
End;

Procedure TMaskEdit.CloseQuery(Sender:TObject;Var CanClose:Boolean);
Begin
     CanClose:=True;
     Try
        If not ValidateEdit Then EditTextInvalid;
     Except
        On E:EEditTextInvalid Do
        Begin
             ErrorBox(E.Message);
             Focus;
             CanClose:=False;
        End;
     End;
End;

Function TMaskEdit.ValidateEdit:Boolean;
Var s : String;
{    s1: String; }
    t:LongInt;
    t1:LongInt;
    CurrentMask:^CString;
{    UpLowCase:Byte; }
{    Blanks:Boolean; }

Label error;

Begin
     //validate EditText
     Result:=True; //Blanks are ok (required characters versus optional characters)
     s:=EditText;

     t:=1;
     t1:=1;
     While t<=254 Do
     Begin
          If t1>length(FEditMask) Then
          Begin
               SetLength(s,t-1);
               break;
          End;
          CurrentMask:=@FEditMask[t1];
          If t>length(s) Then break;

          If CurrentMask^[0]=MaskFieldSeparator Then
          Begin
               SetLength(s,t-1);
               break;
          End
          Else If CurrentMask<>Nil Then
          Begin
               Case CurrentMask^[0] Of
                 mDirLiteral:
                 Begin
                    if s[t]<>CurrentMask^[1] Then goto error;
                    t:=t+1;
                    t1:=t1+1;
                 End;
                 mDirUpperCase,mDirLowerCase,mDirReverse:;
                 mMskAlpha,mMskAlphaOpt:
                 Begin
                      If s[t] In ['A'..'Z','a'..'z'] Then
                      Begin
                      End
                      Else If s[t]=FMaskBlank Then
                      Begin
                           If CurrentMask^[0]<>mMskAlphaOpt Then Result:=False;
                      End
                      Else goto error;
                      t:=t+1;
                 End;
                 mMskAlphaNum,mMskAlphaNumOpt:
                 Begin
                      If s[t] In ['A'..'Z','a'..'z','0'..'9'] Then
                      Begin
                      End
                      Else If s[t]=FMaskBlank Then
                      Begin
                           If CurrentMask^[0]<>mMskAlphaNumOpt Then Result:=False;
                      End
                      Else goto error;
                      t:=t+1;
                 End;
                 mMskAscii,mMskAsciiOpt:
                 Begin
                      t:=t+1;
                 End;
                 mMskNumeric,mMskNumericOpt:
                 Begin
                      If s[t] In ['0'..'9'] Then
                      Begin
                      End
                      Else If s[t]=FMaskBlank Then
                      Begin
                          If CurrentMask^[0]<>mMskNumericOpt Then Result:=False;
                      End
                      Else goto error;
                      t:=t+1;
                 End;
                 mMskNumSymOpt:
                 Begin
                      If s[t] In ['+','-','0'..'9'] Then
                      Begin
                      End
                      Else If s[t]<>FMaskBlank Then goto error;
                      t:=t+1;
                 End;
                 mMskTimeSeparator:
                 Begin
                      If s[t]<>TimeSeparator Then goto error;
                      t:=t+1;
                 End;
                 mMskDateSeparator:
                 Begin
                      If s[t]<>DateSeparator Then goto error;
                      t:=t+1;
                 End;
                 Else
                 Begin
                    If s[t]<>CurrentMask^[0] Then goto error;
                    t:=t+1;
                 End;
               End; //case
          End
          Else
          Begin
error:
               EditTextInvalid;
               break;
          End;
          t1:=t1+1;
     End;

     If t<=length(s) Then goto error;
     If t1<=length(FEditMask) Then
      If FEditMask[t1]<>MaskFieldSeparator Then
     Begin
          While t1<=length(FEditMask) Do
          Begin
               CurrentMask:=@FEditMask[t1];
               Case CurrentMask^[0] Of
                  mDirLiteral:
                  Begin
                     s:=s+CurrentMask^[1];
                     t1:=t1+1;
                  End;
                  mDirUpperCase,mDirLowerCase,mDirReverse:;
                  mMskTimeSeparator:s:=s+TimeSeparator;
                  mMskDateSeparator:s:=s+DateSeparator;
                  mMskAlpha,mMskAlphaNum,mMskAscii,mMskNumeric:goto error;
                  mMskAlphaOpt,mMskAlphaNumOpt,mMskAsciiOpt,
                  mMskNumericOpt,mMskNumSymOpt:s:=s+FMaskBlank;
                  Else
                  Begin
                     s:=s+CurrentMask^[0];
                  End;
               End; //Case

               t1:=t1+1;
          End;
     End;

     If s<>EditText Then EditText:=s;
End;

Function TMaskEdit.GetText:String;
Var t,t1:Longint;
    CurrentMask:^CString;
Begin
    Result:=EditText;

    //delete optional literals and blanks if they're part of the mask
    //and they should not be included into text
    If Result<>'' Then If not FMaskSave Then
    Begin
         t1:=1;
         t:=1;
         While t1<=Length(FEditMask) Do
         Begin
              CurrentMask:=@FEditMask[t1];
              Case CurrentMask^[0] Of
                 mDirLiteral:
                 Begin
                    System.Delete(Result,t,1);
                    t1:=t1+1;
                 End;
                 mDirUpperCase,mDirLowerCase,mDirReverse:;
                 mMskAlpha,mMskAlphaOpt,
                 mMskAlphaNum,mMskAlphaNumOpt,
                 mMskAscii,mMskAsciiOpt,
                 mMskNumeric,mMskNumericOpt,
                 mMskNumSymOpt:
                 Begin
                     If Result[t]=FMaskBlank Then System.Delete(Result,t,1)
                     Else t:=t+1;
                 End;
                 mMskTimeSeparator,mMskDateSeparator:
                 Begin
                      System.Delete(Result,t,1);
                 End;
                 Else
                 Begin
                      System.Delete(Result,t,1);
                 End;
              End; //case
              t1:=t1+1;
         End;
    End;
End;

Procedure TMaskEdit.SetText(Const NewValue:String);
Var s,s1:String;
    t,t1:LongInt;
    CurrentMask:^CString;
    UpLowCase:Byte;
{    Blanks:Boolean; }

Begin
     s:=NewValue;
     t:=1;
     t1:=1;
     While t<=254 Do
     Begin
          If t1>length(FEditMask) Then
          Begin
               SetLength(s,t-1);
               break;
          End;
          CurrentMask:=@FEditMask[t1];
          If t>length(s) Then
          Begin
               SetLength(s,t);
               s[t]:=#32;
          End;
          If s[t]=#32 Then s[t]:=FMaskBlank;

          If CurrentMask^[0]=MaskFieldSeparator Then
          Begin
               SetLength(s,t-1);
               break;
          End
          Else If CurrentMask<>Nil Then
          Begin
               Case CurrentMask^[0] Of
                 mDirLiteral:
                 Begin
                    If FMaskSave Then s[t]:=CurrentMask^[1]
                    Else
                    Begin
                        s1:=CurrentMask^[1];
                        System.Insert(s1,s,t);
                    End;
                    t:=t+1;
                    t1:=t1+1;
                 End;
                 mDirUpperCase,mDirLowerCase,mDirReverse:;
                 mMskAlpha,mMskAlphaOpt:
                 Begin
                      If s[t] In ['A'..'Z','a'..'z'] Then
                      Begin
                           If UpLowCase=1 Then s[t]:=Upcase(s[t])
                           Else If UpLowCase=2 Then
                           Begin
                                s1:=s[t];
                                s1:=LowerCase(s1);
                                s[t]:=s1[1];
                           End;
                      End
                      Else s[t]:=FMaskBlank;
                      t:=t+1;
                 End;
                 mMskAlphaNum,mMskAlphaNumOpt:
                 Begin
                      If s[t] In ['A'..'Z','a'..'z','0'..'9'] Then
                      Begin
                           If UpLowCase=1 Then s[t]:=Upcase(s[t])
                           Else If UpLowCase=2 Then
                           Begin
                                s1:=s[t];
                                s1:=LowerCase(s1);
                                s[t]:=s1[1];
                           End;
                      End
                      Else s[t]:=FMaskBlank;
                      t:=t+1;
                 End;
                 mMskAscii,mMskAsciiOpt:
                 Begin
                      If UpLowCase=1 Then s[t]:=Upcase(s[t])
                      Else If UpLowCase=2 Then
                      Begin
                           s1:=s[t];
                           s1:=LowerCase(s1);
                           s[t]:=s1[1];
                      End;
                      t:=t+1;
                 End;
                 mMskNumeric,mMskNumericOpt:
                 Begin
                      If s[t] In ['0'..'9'] Then
                      Begin
                      End
                      Else s[t]:=FMaskBlank;
                      t:=t+1;
                 End;
                 mMskNumSymOpt:
                 Begin
                      If s[t] In ['+','-','0'..'9'] Then
                      Begin
                      End
                      Else s[t]:=FMaskBlank;
                      t:=t+1;
                 End;
                 mMskTimeSeparator:
                 Begin
                      If FMaskSave Then s[t]:=TimeSeparator
                      Else
                      Begin
                          s1:=TimeSeparator;
                          Insert(s1,s,t);
                      End;
                      t:=t+1;
                 End;
                 mMskDateSeparator:
                 Begin
                      If FMaskSave Then s[t]:=DateSeparator
                      Else
                      Begin
                          s1:=DateSeparator;
                          Insert(s1,s,t);
                      End;
                      t:=t+1;
                 End;
                 Else
                 Begin
                    If FMaskSave Then s[t]:=CurrentMask^[0]
                    Else
                    Begin
                        s1:=CurrentMask^[0];
                        System.Insert(s1,s,t);
                    End;
                    t:=t+1;
                 End;
               End; //case
          End
          Else break;
          t1:=t1+1;
     End;

     EditText:=s;
End;

Function TMaskEdit.GetIsMasked:Boolean;
Begin
     Result:=FEditMask<>'';
End;

Function TMaskEdit.GetEditText:String;
Begin
     Result:=Inherited Text;
End;

Procedure TMaskEdit.SetEditText(Const NewValue:String);
Var s:String;
Begin
     s:=Inherited Text;
     Inherited Text:=NewValue;
     //check if the text is valid
     Try
        ValidateEdit;
     Except
        //Ignore error
        Inherited Text:=s;
     End;
End;

Procedure TMaskEdit.SetEditMask(Const NewValue:String);
Var s,s1:String;
    t:LongInt;
    SepCount:Byte;
Begin
     FEditMask:=NewValue;

     s:=FEditMask;
     t:=1;
     SepCount:=0;

     s1:=s;
     For t:=1 To Length(s) Do s1[t]:=#0;

     t:=1;
     While t<=length(s) Do
     Begin
          If s[t]=MaskFieldSeparator Then
          Begin
               If SepCount=0 Then
               Begin
                    t:=t+1;
                    If ((t<=length(s))And(s[t]<>MaskNoSave)) Then
                      FMaskSave:=True
                    Else
                      FMaskSave:=False;
                    t:=t+1;
                    If s[t]<>MaskFieldSeparator Then
                    Begin
                         SetLength(s,t-1);
                         SetLength(s1,t-1);
                    End;
                    inc(SepCount);
               End
               Else
               Begin
                    t:=t+1;
                    If t<=length(s) Then
                    Begin
                         FMaskBlank:=s[t];
                         SetLength(s,t-4);
                         SetLength(s1,t-4);
                    End
                    Else
                    Begin
                         SetLength(s,t-5);
                         SetLength(s1,t-5);
                    End;
               End;
          End
          Else Case s[t] Of
             mDirLiteral:
             Begin
                  Delete(s,t,1);
                  Delete(s1,t,1);
                  t:=t+1;
             End;
             mDirUpperCase,mDirLowerCase,mDirReverse:
             Begin
                  Delete(s,t,1);
                  Delete(s1,t,1);
             End;
             mMskAlpha,mMskAlphaOpt,mMskAlphaNum,mMskAlphaNumOpt,
             mMskAscii,mMskAsciiOpt,mMskNumeric,mMskNumericOpt,mMskNumSymOpt:
             Begin
                  s1[t]:=FMaskBlank;
                  t:=t+1;
             End;
             mMskTimeSeparator,mMskDateSeparator:t:=t+1;
             Else t:=t+1;
          End; //case
     End;

     For t:=1 To length(s) Do If s1[t]<>#0 Then s[t]:=FMaskBlank;

     Text:=s;
End;

Procedure TMaskEdit.SetupShow;
Begin
     Inherited SetupShow;

     FCanvas.Create(Self);
     FCanvas.Init;
End;

Function TMaskEdit.GetCursorPos:LongInt;

{$IFDEF OS2}
Var Info:CursorInfo;
    s,s1:String;
    X:LongInt;
    t:LongInt;
    H:LongInt;
    Add,Start:LongInt;
{$ENDIF}

Begin
     Result:=-1;
     {$IFDEF OS2}
     If FCanvas=Nil Then exit;
     Info.hwnd:=Handle;
     If WinQueryCursorInfo(HWND_DESKTOP,Info) Then
     If Info.hwnd=Handle Then
     Begin
          Result:=Info.X;
          s:=Text;
          If BorderStyle=bsNone Then Add:=0
          Else Add:=3;
          X:=Add;
          t:=0;
          Start:=WinSendMsg(Handle,EM_QUERYFIRSTCHAR,0,0);
          FCanvas.Font:=Font;

          While ((Start+t+1<=length(s))And(X<Result)) Do
          Begin
               t:=t+1;
               s1:=Copy(s,Start+1,t);
               FCanvas.GetTextExtent(s1,X,H);
               X:=X+Add;
          End;

          If X>=Result Then Result:=Start+t
          Else Result:=0;
     End;
     {$ENDIF}
End;

Procedure TMaskEdit.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Begin
End;

Function TMaskEdit.GetCurrentMask(Position:LongInt;
                                  Var UpLowCase:Byte;Var Blanks:Boolean):PChar;
Var t:LongInt;
    EditPos:LongInt;
Begin
     Result:=Nil;
     UpLowCase:=0;
     Blanks:=False;

     If Position>=0 Then
     Begin
         EditPos:=0;
         t:=1;
         While t<=length(FEditMask) Do
         Begin
              If FEditMask[t]=MaskFieldSeparator Then exit;

              If Position=EditPos Then
               If not (FEditMask[t] In [mDirUpperCase,mDirLowerCase,mDirReverse]) Then
              Begin
                   Result:=@FEditMask[t];
                   exit;
              End;

              Case FEditMask[t] Of
                 mDirLiteral:  //Literal character
                 Begin
                      t:=t+2;
                      inc(EditPos);
                 End;
                 mDirUpperCase: //all upcase
                 Begin
                      UpLowCase:=1;
                      t:=t+1;
                 End;
                 mDirLowerCase: //all lowcase
                 Begin
                      UpLowCase:=2;
                      t:=t+1;
                 End;
                 mDirReverse: //blanks
                 Begin
                      Blanks:=True;
                      t:=t+1;
                 End;
                 Else
                 Begin
                      t:=t+1;
                      inc(EditPos);
                 End;
              End;
         End;
     End;
End;

Procedure TMaskEdit.UpdateCursorPos;
Var Position,Pos1:LongInt;
    CurrentMask:^CString;
    UpLowCase:Byte;
    Blanks:Boolean;
Label again;
Begin
     Position:=GetCursorPos;
again:
     If ((Position<0)Or(Position>length(FEditMask))) Then exit;
     CurrentMask:=GetCurrentMask(Position,UpLowCase,Blanks);
     If CurrentMask=Nil Then exit;

     Case CurrentMask^[0] Of
        mMskAlpha,mMskAlphaOpt,mMskAlphaNum,mMskAlphaNumOpt,
        mMskAscii,mMskAsciiOpt,mMskNumeric,mMskNumericOpt,mMskNumSymOpt:;
        Else
        Begin
             {$IFDEF OS2}
             WinSendMsg(Handle,WM_CHAR,KC_VIRTUALKEY OR KC_SCANCODE OR KC_TOGGLE,
                         224 Or (VK_RIGHT SHL 16));
             {$ENDIF}
             Pos1:=GetCursorPos;
             If Pos1<>Position Then
             Begin
                  Position:=Pos1;
                  goto again;
             End;
        End;
     End;
End;

Procedure TMaskEdit.CharEvent(Var key:Char;RepeatCount:Byte);
Var Position:LongInt;
    CurrentMask:PChar;
    UpLowCase:Byte;
    Blanks:Boolean;
    Valid:Boolean;
    s:String;
    Msg:PMessage;
Begin
     If not IsMasked Then
     Begin
          Inherited CharEvent(key,RepeatCount);
          exit;
     End;

     UpdateCursorPos;

     Position:=GetCursorPos;

     If ((Position<0)Or(Position>length(FEditMask))) Then
     Begin
         key:=#0;
         exit;
     End;

     CurrentMask:=GetCurrentMask(Position,UpLowCase,Blanks);
     If CurrentMask=Nil Then
     Begin
          key:=#0;
          exit;
     End;

     If key=#32 Then
     Begin
          key:=FMaskBlank;
          Valid:=True;
     End
     Else
     Begin
          Valid:=False;
          Case CurrentMask^[0] Of
             mDirLiteral:;
             mMskAlpha,mMskAlphaOpt: //Alpha
             Begin
                  If Key In ['A'..'Z','a'..'z'] Then
                    Valid:=True;
             End;
             mMskAlphaNum,mMskAlphaNumOpt: //Alpha and Num
             Begin
                  If Key In ['A'..'Z','a'..'z','0'..'9'] Then
                    Valid:=True;
             End;
             mMskNumeric,mMskNumericOpt: //any number
             Begin
                  If Key In ['0'..'9'] Then
                    Valid:=True;
             End;
             mMskNumSymOpt: //any number and +,-
             Begin
                  If Key In ['0'..'9','+','-'] Then
                    Valid:=True;
             End;
             mMskAscii,mMskAsciiOpt: //Any Char
             Begin
                  Valid:=True;
             End;
          End;
     End;

     If Valid Then
     Begin
          If UpLowCase=1 Then Key:=Upcase(Key)
          Else If UpLowCase=2 Then
          Begin
               s:=LowerCase(Key);
               Key:=s[1];
          End;
          Inherited CharEvent(key,RepeatCount);
     End
     Else key:=#0;

     If key<>#0 Then
     Begin
          Asm
             PUSH DWORD PTR SELF
             CALLN32 Forms.GetLastMsgAdr
             MOV Msg,EAX
          End;
          If Msg<>Nil Then TWMCHAR(Msg^).CharCode:=ord(key);
          LastMsg.CallDefaultHandler;
          UpdateCursorPos;
     End;
End;

Procedure TMaskEdit.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Var Position,Pos1:LongInt;
    CurrentMask:PChar;
    UpLowCase:Byte;
    Blanks:Boolean;
    s:String;
    t:LongInt;
    SStart,SLen:LongInt;
Label again;
Begin
     If not IsMasked Then
     Begin
          Inherited ScanEvent(KeyCode,RepeatCount);
          exit;
     End;

     If keycode<>kbNull Then
     Begin
        Case keycode of
          kbIns:
          Begin
               KeyCode:=kbNull;
               exit;
          End;
          kbShiftIns:  //Insert from clipboard
          Begin
               {$IFDEF OS2}
               If ClipBoard.HasFormat(CF_TEXT) Then
               Begin
                   s:=Inherited Text;
                   ClipBoard.Open(Handle);
                   CurrentMask:=PChar(ClipBoard.GetAsHandle(CF_TEXT));
                   If CurrentMask<>Nil Then Inherited Text:=CurrentMask^;
                   ClipBoard.Close;
                   //check if the text is valid
                   Try
                      ValidateEdit;
                   Except
                      //Ignore error
                      Inherited Text:=s;
                   End;
               End;
               {$ENDIF}
               KeyCode:=kbNull;
               exit;
          End;
          kbBkSp:
          Begin
               {$IFDEF OS2}
               WinSendMsg(Handle,WM_CHAR,KC_VIRTUALKEY OR KC_SCANCODE OR KC_TOGGLE,
                          224 Or (VK_LEFT SHL 16));
               WinSendMsg(Handle,WM_CHAR,KC_CHAR OR KC_TOGGLE OR KC_SCANCODE OR KC_VIRTUALKEY Or
                          (57 Shl 24),
                          32 Or (VK_SPACE Shl 16));
               WinSendMsg(Handle,WM_CHAR,KC_VIRTUALKEY OR KC_SCANCODE OR KC_TOGGLE,
                          224 Or (VK_LEFT SHL 16));
               {$ENDIF}
               keycode:=kbNull;
               exit;
          End;
          kbDel:
          Begin
               //check selection
               If ((SelStart>=0)And(SelLength>1)) Then
               Begin
                    SStart:=SelStart;
                    SLen:=SelLength;

                    s:=Text;
                    For t:=SelStart+1 To SelStart+SelLength Do
                    Begin
                         CurrentMask:=GetCurrentMask(t-1,UpLowCase,Blanks);
                         If CurrentMask<>Nil Then
                         Begin
                              If CurrentMask^[0] In
                                [mMskAlpha,mMskAlphaOpt,mMskAlphaNum,mMskAlphaNumOpt,
                                 mMskAscii,mMskAsciiOpt,mMskNumeric,mMskNumericOpt,mMskNumSymOpt] Then
                                    s[t]:=FMaskBlank;
                         End;
                    End;
                    Inherited Text:=s;
                    keycode:=kbNull;

                    SelStart:=SStart;
                    SelLength:=SLen;

                    exit;
               End;

               {$IFDEF OS2}
               WinSendMsg(Handle,WM_CHAR,KC_CHAR OR KC_TOGGLE OR KC_SCANCODE OR KC_VIRTUALKEY Or
                          (57 Shl 24),
                          32 Or (VK_SPACE Shl 16));
               WinSendMsg(Handle,WM_CHAR,KC_VIRTUALKEY OR KC_SCANCODE OR KC_TOGGLE,
                          224 Or (VK_LEFT SHL 16));
               {$ENDIF}
               keycode:=kbNull;
               exit;
          End;
          kbCLeft:
          Begin
               Position:=GetCursorPos;
               If Position=1 Then
               Begin
                    CurrentMask:=GetCurrentMask(Position-1,UpLowCase,Blanks);
                    If CurrentMask=Nil Then
                    Begin
                        keycode:=kbNull;
                        exit;
                    End;

                    Case CurrentMask^[0] Of
                       mMskAlpha,mMskAlphaOpt,mMskAlphaNum,mMskAlphaNumOpt,
                       mMskAscii,mMskAsciiOpt,mMskNumeric,mMskNumericOpt,mMskNumSymOpt:;
                       Else If Position>0 Then
                       Begin
                            keycode:=kbNull;
                            exit;
                       End;
                    End;
               End;
          End;
        End; //case

        LastMsg.CallDefaultHandler;

        If KeyCode In [kbCR{$IFDEF OS2},kbEnter{$ENDIF}] Then
        Begin
             KeyCode:=kbNull;
             exit;
        End;
     End;

     Position:=GetCursorPos;

     If ((Position<0)Or(Position>length(FEditMask))) Then
     Begin
         keycode:=kbNull;
         exit;
     End;

     If keycode=kbCLeft Then
     Begin
again:
          CurrentMask:=GetCurrentMask(Position,UpLowCase,Blanks);
          If CurrentMask=Nil Then
          Begin
              keycode:=kbNull;
              exit;
          End;

          Case CurrentMask^[0] Of
            mMskAlpha,mMskAlphaOpt,mMskAlphaNum,mMskAlphaNumOpt,
            mMskAscii,mMskAsciiOpt,mMskNumeric,mMskNumericOpt,mMskNumSymOpt:;
            Else If Position>0 Then
            Begin
                 {$IFDEF OS2}
                 WinSendMsg(Handle,WM_CHAR,KC_VIRTUALKEY OR KC_SCANCODE OR KC_TOGGLE,
                             224 Or (VK_LEFT SHL 16));
                 {$ENDIF}
                 Pos1:=GetCursorPos;
                 If Pos1<>Position Then If Pos1>0 Then
                 Begin
                      Position:=Pos1;
                      goto again;
                 End;
            End;
          End;
     End;

     UpdateCursorPos;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TMaskEditTextPropertyEditor Class implementation            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Type TMaskEditTextPropertyEditor=Class(TStringPropertyEditor)
       Public
         Function Execute(Var Value:String;ValueLen:LONGINT):TPropertyEditorReturn;Override;
     End;

Type TMaskEditTextPropEditDialog=Class(TDialog)
       Procedure SetupDlg;
     End;


Procedure TMaskEditTextPropEditDialog.SetupDlg;
Begin
  Caption:='Maked Text Editor';
  Width:=420;
  Height:=400;
  XAlign:=xaCenter;
  YAlign:=yaCenter;
  Color:=clLtGray;
  BorderStyle := bsDialog;
  BorderIcons := [biSystemMenu];

  InsertBitBtnNLS(Self,20,10,90,30,bkOk,SOkButton,SClickHereToAccept);
  InsertBitBtnNLS(Self,120,10,90,30,bkCancel,SCancelButton, SClickHereToCancel);
  InsertBitBtnNLS(Self,220,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
End;


Function TMaskEditTextPropertyEditor.Execute(Var Value:String;ValueLen:LONGINT):TPropertyEditorReturn;

VAR MaskEdit:TMaskEdit;
    Dlg:TMaskEditTextPropEditDialog;

Begin
  MaskEdit:=TMaskEdit(Owner);

  Dlg.Create(Nil);
  Dlg.SetupDlg;

  If Dlg.Execute Then
  Begin
       Value:='';
       result:=edOk;
  End
  Else result:=edCancel;
  Dlg.Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TMaskEditTextPropertyEditor Class implementation            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TMaskEditMaskPropertyEditor=CLASS(TStringPropertyEditor)
       Public
         Function Execute(Var Value:String;ValueLen:LONGINT):TPropertyEditorReturn;Override;
    End;

Type
    TMaskEditMaskPropEditDialog=Class(TDialog)
       Procedure SetupDlg;
       Procedure MasksClick(Sender:TObject);
       Procedure LoadMask(Const FileName:String);
       Procedure ClearItems;
       Procedure SetEditMask(NewMask:String);
       Procedure ListBoxItemFocus(Sender:TObject;Index:LongInt);
       Procedure EditTextInvalid(Sender:TObject);
       Procedure MaskChanged(Sender:TObject);
       Procedure BlankChanged(Sender:TObject);
       Procedure LiteralChanged(Sender:TObject);

       ListBox:TListBox;
       Edit1,Edit2:TEdit;
       CheckBox:TCheckBox;
       MaskEdit:TMaskEdit;
    End;

Procedure TMaskEditMaskPropEditDialog.EditTextInvalid(Sender:TObject);
Begin
     //do nothing
End;

Procedure TMaskEditMaskPropEditDialog.LiteralChanged(Sender:TObject);
Var s:String;
    b:Byte;
    s1:String;
{    s2:String; }
{    Blank:Char; }
Begin
  s:=MaskEdit.EditMask;
  b:=pos(';',s);
  If b=0 Then exit;
  s1:=Copy(s,1,b-1);
  Delete(s,1,b);
  b:=pos(';',s);
  If b=0 Then exit;
  Delete(s,1,b);
  If CheckBox.Checked
    Then s1:=s1+';1'
    Else s1:=s1+';0';
  SetEditMask(s1+';'+s);
End;


Procedure TMaskEditMaskPropEditDialog.BlankChanged(Sender:TObject);
Var s:String;
    b:Byte;
    s1,s2:String;
    Blank:String;
Begin
  s:=MaskEdit.EditMask;
  b:=pos(';',s);
  If b=0 Then exit;
  s1:=Copy(s,1,b-1);
  Delete(s,1,b);
  b:=pos(';',s);
  If b=0 Then exit;
  s2:=Copy(s,1,b-1);
  If Edit2.Text=''
    Then Blank:=' '
    Else Blank:=Edit2.Text[1];
  SetEditMask(s1+';'+s2+';'+Blank);
End;

Procedure TMaskEditMaskPropEditDialog.SetEditMask(NewMask:String);
Begin
     Edit1.OnChange:=Nil;
     If Edit1.Text<>NewMask Then Edit1.Text:=NewMask;
     Edit1.OnChange:=MaskChanged;
     MaskEdit.EditMask:=NewMask;
     Edit2.OnChange:=Nil;
     If Edit2.Text<>MaskEdit.MaskBlank Then Edit2.Text:=MaskEdit.MaskBlank;
     Edit2.OnChange:=BlankChanged;
     CheckBox.Checked:=MaskEdit.MaskSave;
End;

Procedure TMaskEditMaskPropEditDialog.MaskChanged(Sender:TObject);
Begin
     SetEditMask(Edit1.Text);
End;


Procedure TMaskEditMaskPropEditDialog.ListBoxItemFocus(Sender:TObject;Index:LongInt);
Var p:^String;
Begin
     p:=Pointer(ListBox.Items.Objects[Index]);
     SetEditMask(p^);
End;

Procedure TMaskEditMaskPropEditDialog.ClearItems;
Var t:LongInt;
    p:^String;
Begin
     For t:=0 To ListBox.Items.Count-1 Do
     Begin
          p:=Pointer(ListBox.Items.Objects[t]);
          DisposeStr(p);
     End;
     ListBox.Items.Clear;
End;

Procedure TMaskEditMaskPropEditDialog.LoadMask(Const FileName:String);
Var f:System.Text;
    s,s1,s2:String;
    p:^String;
    Mask:TMaskEdit;
    Save:Boolean;
Begin
     System.Assign(f,FileName);
     {$I-}
     Reset(f);
     {$I+}
     If IoResult<>0 Then
     Begin
         ErrorBox('Cannot open:'+FileName);
         exit;
     End;

     ClearItems;
     Mask.Create(Self);
     While not Eof(f) Do
     Begin
          {$I-}
          Readln(f,s);
          {$I+}
          If IoResult<>0 Then
          Begin
              ErrorBox('Cannot read file:'+FileName);
              break;
          End;

          While s[length(s)]=#32 do dec(s[0]);
          If s='' Then continue;

          If pos(';',s)=0 Then
          Begin
               ErrorBox('Illegal file format:'+FileName);
               break;
          End;

          s1:=Copy(s,1,pos(';',s)-1);
          Delete(s,1,pos(';',s));

          If pos(';',s)=0 Then
          Begin
               ErrorBox('Illegal file format:'+FileName);
               break;
          End;

          s2:=Copy(s,1,pos(';',s)-1);
          Delete(s,1,pos(';',s));

          Mask.EditMask:=s;
          p:=Nil;
          AssignStr(p,s);

          Save:=Mask.FMaskSave;
          Mask.FMaskSave:=False;
          Mask.Text:=s2;
          Mask.FMaskSave:=True;
          s2:=Mask.Text;
          Mask.FMaskSave:=Save;
          ListBox.Items.AddObject(s1+' ('+s2+')',TObject(p));
     End;
     Mask.Destroy;

     {$I-}
     System.Close(f);
     {$I+}
End;

Procedure TMaskEditMaskPropEditDialog.MasksClick(Sender:TObject);
Var OpenDialog:TOpenDialog;
    Dir,Name,Ext:String;
    OldDir:String;
Begin
  OpenDialog.Create(Nil);
  OpenDialog.AddFilter('Edit Masks','*.msk');

  FSplit(ParamStr(0),Dir,Name,Ext);
  If Dir[length(Dir)]='\' Then dec(Dir[0]);

  GetDir(0,OldDir);
  {$I-}
  ChDir(Dir);
  {$I+}

  OpenDialog.FileName:=Dir+'\*.msk';
  If OpenDialog.Execute Then LoadMask(OpenDialog.FileName);

  {$I-}
  ChDir(OldDir);
  {$I+}
End;

Procedure TMaskEditMaskPropEditDialog.SetupDlg;
Var Button:TButton;
    Dir,Name,Ext:String;
    GroupBox:TGroupBox;
Begin
  Caption:='EditMask Editor';
  Width:=460;
  Height:=350;
  XAlign:=xaCenter;
  YAlign:=yaCenter;
  Color:=clLtGray;
  BorderStyle := bsDialog;
  BorderIcons := [biSystemMenu];

  Button:=InsertButton(Self,20,10,90,30,'~Masks...','Click here to load masks');
  Button.OnClick:=MasksClick;

  InsertLabel(Self,200,275,100,20,'Sample Masks');
  ListBox:=InsertListBox(Self,200,60,240,215,'');
  ListBox.OnItemFocus:=ListBoxItemFocus;

  InsertLabel(Self,15,275,100,20,'Input Mask');
  Edit1:=InsertEdit(Self,15,250,170,20,'','');
  Edit1.OnChange:=MaskChanged;

  InsertLabel(Self,15,220,120,20,'Character for blanks:');
  Edit2:=InsertEdit(Self,145,220,30,20,'','');
  Edit2.OnChange:=BlankChanged;

  CheckBox:=InsertCheckBox(Self,15,190,160,20,'Save literal characters','');
  CheckBox.OnClick:=LiteralChanged;

  GroupBox:=InsertGroupBox(Self,15,130,170,50,'Test Input');
  MaskEdit:=InsertMaskEdit(GroupBox,10,10,150,20,'','');
  MaskEdit.OnEditTextInvalid:=EditTextInvalid;

  InsertBitBtnNLS(Self,120,10,90,30,bkOk,SOkButton,SClickHereToAccept);
  InsertBitBtnNLS(Self,220,10,90,30,bkCancel,SCancelButton, SClickHereToCancel);
  InsertBitBtnNLS(Self,320,10,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);

  FSplit(ParamStr(0),Dir,Name,Ext);
  If Dir[length(Dir)]='\' Then dec(Dir[0]);
  LoadMask(Dir+'\Germany.msk');
End;


Function TMaskEditMaskPropertyEditor.Execute(Var Value:String;ValueLen:LONGINT):TPropertyEditorReturn;

VAR MaskEdit:TMaskEdit;
    Dlg:TMaskEditMaskPropEditDialog;

Begin
  MaskEdit:=TMaskEdit(Owner);

  Dlg.Create(Nil);
  Dlg.SetupDlg;
  Dlg.SetEditMask(MaskEdit.EditMask);

  If Dlg.Execute
    Then
       Begin
         Value:=Dlg.MaskEdit.EditMask;
         result:=edOk;
       End
    Else result:=edCancel;
  Dlg.ClearItems;
  Dlg.Destroy;
End;


Initialization
   AddPropertyEditor(TMaskEdit,'EditMask',TMaskEditMaskPropertyEditor);
   AddPropertyEditor(TMaskEdit,'Text',TMaskEditTextPropertyEditor);
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
}

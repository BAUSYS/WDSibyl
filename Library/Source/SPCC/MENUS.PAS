
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    WDSibyl Portable Component Classes                                    บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ    Copyright (C) 2002..     Ing. Wolfgang Draxler,   All rights reserved.บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit Menus;
           
Interface                
             
{$B-}             

Uses Messages,SysUtils,Classes,Graphics,Color,
     uList, uString,uLanguage;

Type
    {Standard Menu entry styles}
    TMenuItemStyles=Set Of (misText,misBitmap,misOwnerDraw,
         misSubmenu,misMultMenu,misSysCommand,misHelp,misStatic,
         misButtonSeparator,misBreak,misBreakSeparator,misGroup,misSingle);

    {Standard Menu entry Flags}
    TMenuItemFlags=Set Of (mifNoDismiss,mifFramed,mifChecked,mifDisabled,
                           mifHilited);

{$M+}
    TMenuBreak=(mbNone,mbBreak,mbBarBreak,mbSeparator);
{$M-}

    {Menu Forward}
    TMenu=Class;

    TMenuItem=Class(TComponent)
      Private
         FParent:TMenuItem;
         FMenu:TMenu;
         FMenuOwner:TComponent; {Form}
         FHandle:HWindow;
         FItems:TList;
         FInitItems:TList;   {FItems Or Nil}
         FCaption:PString;
         FStyles:TMenuItemStyles;
         FFlags:TMenuItemFlags;
         FGlyph:TGraphic;
         FCommand:TCommand;
         FInternalCommand:TCommand;
         FCreated:Boolean;
         FDefWndProc:TWndProc;
         FHelpContext:THelpContext;
         FHelpContextString:string;   // Martin
         FShortCut:TKeyCode;
         FHint:PString;
         FOnClick:TNotifyEvent;
         {$IFDEF OS2}
         Procedure WMChar(Var Msg:TWMChar); Message WM_CHAR;
         Procedure WMHelp(Var Msg:TMessage); Message WM_HELP;
         {$ENDIF}
         Procedure SetShortCut(NewAccel:TKeyCode);
         Function GetCaption:String;
         Procedure SetCaption(NewCaption:String);
         Procedure SetStyles(NewStyles:TMenuItemStyles);
         Procedure SetFlags(NewFlags:TMenuItemFlags);
         Function GetULongFromStyle:LongWord;
         Function GetULongFromFlags:LongWord;
         Procedure SetGlyph(NewGlyph:TGraphic);
         Procedure SetHint(Const NewText:String);
         Function GetHint:String;
         Function GetChecked:Boolean;
         Procedure SetChecked(Value:Boolean);
         Function GetEnabled:Boolean;
         Procedure SetEnabled(Value:Boolean);
         Function GetBreak:TMenuBreak;
         Procedure SetBreak(Value:TMenuBreak);
         Function GetSubMenu:Boolean;
         Procedure SetSubMenu(Value:Boolean);
         Function GetCount:LongInt;
         Function GetItem(Index:LongInt):TMenuItem;
         Function GetMenuIndex:LongInt;
         Function GetIsEditMenuItem:Boolean;
         Function ConvertSystemAccel(itemcaption:String):String;
         {$IFDEF Win32}
         Procedure RedrawMenuBar;
         {$ENDIF}

         Property SaveLoadInfo; // in den MenuItem sinnlos.
      Protected
         Procedure SetupComponent;Override;
         Procedure GetChildren(Proc:TGetChildProc);Override;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
         Procedure CreateWnd;Virtual;
         Property Flags:TMenuItemFlags Read FFlags Write SetFlags;
         Property Styles:TMenuItemStyles Read FStyles Write SetStyles;
      Public
         Destructor Destroy;Override;
         Procedure Add(Item:TMenuItem);
         Procedure Insert(Index:LongInt;Item:TMenuItem);
         Function IndexOf(Item:TMenuItem):LongInt;
         Procedure RefreshLanguage; Virtual;
         Procedure Click;Virtual;
         Property IsEditMenuItem:Boolean Read GetIsEditMenuItem; {raus}
         Property Handle:HWindow Read FHandle;
         Property Count:LongInt Read GetCount;
         Property Items[Index:LongInt]:TMenuItem Read GetItem; Default;
         Property MenuIndex:LongInt Read GetMenuIndex; {Write SetMenuIndex;}
         Property Parent:TMenuItem Read FParent;
         property Menu:TMenu Read FMenu;
         Property InternalCommand:TCommand Read FInternalCommand;
         Property Glyph:TGraphic Read FGlyph Write SetGlyph;
      Published
         Property Caption:String Read GetCaption Write SetCaption;
         Property Command:TCommand Read FCommand Write FCommand;
         Property HelpContext:THelpContext Read FHelpContext Write FHelpContext;
         Property HelpContextString:string Read FHelpContextString Write FHelpContextString;  // Martin
         Property ShortCut:TKeyCode Read FShortCut Write SetShortCut;
         Property Hint:String Read GetHint Write SetHint;
         Property Checked:Boolean Read GetChecked Write SetChecked;
         Property Enabled:Boolean Read GetEnabled Write SetEnabled;
         Property Break:TMenuBreak Read GetBreak Write SetBreak;
         Property Submenu:Boolean Read GetSubMenu Write SetSubMenu;

         Property OnClick:TNotifyEvent Read FOnClick Write FOnClick;
    End;
    TMenuItemClass=Class Of TMenuItem;

    TMenu=Class(TComponent)
      Private
         FParent:TComponent;      {Frame}
         FItems:TMenuItem;
         FInitItems:TMenuItem;  {FItems Or Nil}
         FHandle:HWindow;
         FResourceId:LongWord;
         {$IFDEF OS2}
         FDefWndProc:TWndProc;
         {$ENDIF}
         FFont:TFont;
         FAlternateFontName:PString;
         fForeGroundColor : tColor;
         fBackGroundColor : tColor;

         {$IFDEF OS2}
         Procedure WMHelp(Var Msg:TMessage); Message WM_HELP;
         Procedure WMChar(Var Msg:TWMChar); Message WM_CHAR;
         Procedure WMPresParamChanged(Var Msg:TMessage); Message WM_PRESPARAMCHANGED;
         {$ENDIF}
         Function ItemFromCommand(Command:TCommand):TMenuItem;

//         Function GetColor(iPPid : LongWord) : tColor;
         Function GetSelectedMenuItem:TMenuItem;
         Function GetWidth:LongInt;
         Function GetHeight:LongInt;
         Procedure SetFont(NewFont:TFont);
      Protected
         Procedure SetupComponent;Override;
         Procedure GetChildren(Proc:TGetChildProc);Override;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
         Procedure LoadResource;
         Procedure CharEvent(entry:TMenuItem;Var key:Char;REP:Byte);Virtual;
         Procedure ScanEvent(entry:TMenuItem;Var KeyCode:TKeyCode;REP:Byte);Virtual;
         Procedure CreateMenu;Virtual;
         Property Width:LongInt Read GetWidth;
         Property Height:LongInt Read GetHeight;
      Public
         Procedure Show;Virtual;
         Destructor Destroy;Override;
         Procedure DisableCommands(Cmds:Array Of TCommand);
         Procedure EnableCommands(Cmds:Array Of TCommand);
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Function ItemFromInternalCommand(Command:TCommand):TMenuItem;
         Procedure WriteInfoToINI(InfoLine : String); Override;
         Function ReadInfoFromINI : String; Override;

         Property Handle:HWindow Read FHandle;
         Property Items:TMenuItem Read FItems;
         Property MenuItems[Command:TCommand]:TMenuItem Read ItemFromCommand;
         Property SelectedMenuItem:TMenuItem Read GetSelectedMenuItem;
         Property ForeGroundColor : tColor Read fForeGroundColor;
         Property BackGroundColor : tColor Read fBackGroundColor;

      Published
         Property ResourceId:LongWord Read FResourceId Write FResourceId;
         Property Font:TFont Read FFont Write SetFont;


    End;
    TMenuClass=Class Of TMenu;


    {MainMenu Class}
    TMainMenu=Class(TMenu)
      Protected
         Procedure SetupComponent;Override;
         Procedure Show;Override;
      Public
         Property Height;
    End;
    TMainMenuClass=Class Of TMainMenu;


    {$M+}
    TPopupAlignment=(paLeft,paCenter,paRight);
    {$M-}

    {PopupMenu Class}
    TPopupMenu=Class(TMenu)
      Private
         FAutoPopup:Boolean;
         FPopupComponent:TComponent;
         FAlignment:TPopupAlignment;
         FOnPopup:TNotifyEvent;
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateMenu;Override;
      Public
         Procedure Popup(X,Y:LongInt);Virtual;
         Destructor Destroy;Override;
         Property Width;
         Property Height;
         Property PopupComponent:TComponent Read FPopupComponent Write FPopupComPonent;
      Published
         Property AutoPopup:Boolean Read FAutoPopup Write FAutoPopup;
         Property Alignment:TPopupAlignment Read FAlignment Write FAlignment;
         Property OnPopup:TNotifyEvent Read FOnPopup Write FOnPopup;
    End;
    TPopupMenuClass=Class Of TPopupMenu;


{$IFDEF OS2}
Function GetKeyRepeat(Var M:TMessage):Byte;
{$ENDIF}


Function Insert_MenuItem(Menu: TMenu; MenuText: String; OnClick: TNotifyEvent) : TMenuItem;
{ Fuegt in ein Menu eine neue Menuezeile ein. }

Function Insert_MenuItem_Seperator(Menu: TMenu) : TMenuItem;
{ Fuegt in ein Menu ein Seperator ein }


implementation

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin,PmGpi,PmDev,PmStdDlg,PmBitmap,PmHelp;
{$ENDIF}

{$IFDEF Win32}
Uses WinDef,WinBase,WinNt,WinUser,WinGDI,CommCtrl;
{$ENDIF}

Uses Forms;

Type TPublicControl=Class(TControl)
         Property Form;
     End;

     TPublicForm=Class(TForm)
         Property MenuBar;
     End;

     TPublicFont=Class(TFont)
        Public
            Property InternalPointSize;
            Property FontInfo;
            Property Custom;
            {$IFDEF Win32}
            Property Handle;
            Property RefCount;
            {$ENDIF}
            Property AlternateName;
     End;



Function Insert_MenuItem(Menu: TMenu; MenuText: String; OnClick: TNotifyEvent) : TMenuItem;

Begin
 Result:=TMenuItem.Create(Menu);
 Result.Caption:=MenuText;
 Result.OnClick:=OnClick;
End;


Function Insert_MenuItem_Seperator(Menu: TMenu) : TMenuItem;

Begin
 Result:=TMenuItem.Create(Menu);
 Result.Caption:='-';
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TMenuItem Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
    MenuIDEEditStr     = '..........';


Function AccelToString(kbValue:TKeyCode):String;
Var  Mask:TKeyCode;
Begin
     Result := '';
     If kbValue And kb_Ctrl <> 0 Then Result := Result + 'Ctrl+';
     If kbValue And kb_Shift <> 0 Then Result := Result + 'Shift+';
     If kbValue And kb_Alt <> 0 Then Result := Result + 'Alt+';
     If kbValue And kb_Char <> 0
     Then Result := Result + UpCase(Chr(kbValue And 255));
     If kbValue And kb_VK <> 0 Then
     Begin
          Mask := kb_Ctrl Or kb_Shift Or kb_Alt Or kb_Char;
          Case kbValue And Not Mask Of
            kbF1:        Result := Result + 'F1';
            kbF2:        Result := Result + 'F2';
            kbF3:        Result := Result + 'F3';
            kbF4:        Result := Result + 'F4';
            kbF5:        Result := Result + 'F5';
            kbF6:        Result := Result + 'F6';
            kbF7:        Result := Result + 'F7';
            kbF8:        Result := Result + 'F8';
            kbF9:        Result := Result + 'F9';
            kbF10:       Result := Result + 'F10';
            kbF11:       Result := Result + 'F11';
            kbF12:       Result := Result + 'F12';
            kbCLeft:     Result := Result + 'Left';
            kbCRight:    Result := Result + 'Right';
            kbCUp:       Result := Result + 'Up';
            kbCDown:     Result := Result + 'Down';
            kbDel:       Result := Result + 'Del';
            kbIns:       Result := Result + 'Ins';
            kbEnd:       Result := Result + 'End';
            kbHome:      Result := Result + 'Home';
            kbPageDown:  Result := Result + 'PageDown';
            kbPageUp:    Result := Result + 'PageUp';
            kbBkSp:      Result := Result + 'BkSp';
            kbCR:        Result := Result + 'CR';
            kbEsc:       Result := Result + 'Esc';
            {$IFDEF OS2}
            kbEnter:     Result := Result + 'Enter';
            {$ENDIF}
            kbPrintScrn: Result := Result + 'PrintScrn';
            {$IFDEF OS2}
            kbBackTab:   Result := Result + 'BackTab';
            {$ENDIF}
            kbTab:       Result := Result + 'Tab';
            kbSpace:     Result := Result + 'Space';
            kbPause:     Result := Result + 'Pause';
            kbCapsLock:  Result := Result + 'CapsLock';
            kbScrollLock:Result := Result + 'ScrollLock';
            kbNumLock:   Result := Result + 'NumLock';
          End;
     End;

     If Result <> '' Then
       If Result[Length(Result)] = '+' Then Result := '';
End;




{$IFDEF OS2}
Function SubclassedMenuItemWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;CDECL;
Var  Menu:TMenuItem;
     aMsg:TMessage;
     Handled:Boolean;
Begin
     Menu:=Pointer(WinQueryWindowULong(Win,QWL_USER));  {Get VMT Pointer}
     If Menu=Nil Then Exit;
     aMsg.Receiver:=Win;
     aMsg.ReceiverClass:=Menu;
     aMsg.Msg:=Msg;
     aMsg.Param1:=para1;
     aMsg.Param2:=para2;
     aMsg.Handled:=False;

     If ((Application<>Nil)And(Application.OnMsgEvent<>Nil)) Then
     Begin
          Handled:=False;
          Application.OnMsgEvent(aMsg,Handled);
          aMsg.Handled:=aMsg.Handled Or Handled;
     End;

     If not aMsg.Handled Then Menu.Dispatch(aMsg);
     If Not aMsg.Handled
     Then aMsg.Result:=Menu.FDefWndProc(aMsg.Receiver,aMsg.Msg,
                                        aMsg.Param1,aMsg.Param2);
     Result:=aMsg.Result;
End;
{$ENDIF}


{$IFDEF Win32}
Procedure TMenuItem.RedrawMenuBar;
Var  Frame:TControl;
Begin
     If FMenuOwner <> Nil Then
     Begin
          Frame := TForm(FMenuOwner);
/*
          If Not (FMenuOwner Is TFrameControl) Then
            If FMenuOwner.Frame <> Nil Then Frame := TForm(FMenuOwner).Frame;
*/            
          DrawMenuBar(Frame.Handle);
     End;
End;
{$ENDIF}


{$IFDEF OS2}
Function GetKeyRepeat(Var M:TMessage):Byte;
Var  Queue:QMSG;
Begin
  Result := 1;
  IF M.param2LoByteHi>0 THEN Exit;
  While WinPeekMsg(AppHandle,Queue,0,WM_CHAR,WM_CHAR,0) Do
    Begin
      If (LongWord(Queue.mp1) = M.Param1) And
         (LongWord(Queue.mp2) = M.Param2)
         Then
           Begin
             WinGetMsg(AppHandle,Queue,0,WM_CHAR,WM_CHAR);
             Inc(Result);
           End
         Else Exit;
    End;
End;


Procedure TMenuItem.WMChar(Var Msg:TWMChar);
Var fsFlags:LongWord;
    REP:Byte;
    Menu:TMenu;
    Current:TMenuItem;
    CH:Char;
    {$IFDEF OS2}
    Param:TKeyCode;
    scan:Byte;
    ascii:Byte;
    virtkey:Word;
    {$ENDIF}
Label lsc;
Begin
     If Not (Self Is TMenuItem) Then Exit;

     Menu:=FMenu;
     If Menu=Nil Then Exit;

     Current:=Menu.GetSelectedMenuItem;
     If Current=Nil Then Exit;

     fsFlags := Msg.KeyData;
     REP := GetKeyRepeat(TMessage(Msg));
     scan := Msg.ScanCode;
     ascii := Lo(Msg.CharCode);
     virtkey := Msg.VirtualKeyCode;

     If fsFlags And KC_KEYUP <> 0 Then
     Begin
          If ((fsFlags And KC_VIRTUALKEY <> 0)And(ascii=32)And(Designed)) Then
          Begin
               //Special Handling For whitespace
               fsFlags := fsFlags Or KC_CHAR;
          End
          Else Exit;
     End;

     If fsFlags And KC_CHAR <> 0 Then
     Begin
          If (ascii < 32) Or  (fsFlags And KC_CTRL <> 0) Then Goto lsc;
          If (fsFlags And KC_VIRTUALKEY<>0) And (fsFlags And KC_SHIFT<>0)
          Then Goto lsc; {numerical block}
          CH := Chr(ascii);
          Menu.CharEvent(Current,CH,REP);

          If CH = #0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End
     Else
     Begin
lsc:
          Param := 0;
          If fsFlags And KC_VIRTUALKEY <> 0 Then Param := virtkey Or kb_VK
          Else Param := ascii Or kb_Char;       {E.G. Ctrl-J}

          If fsFlags And KC_ALT <> 0 Then Param := Param Or kb_Alt;
          If fsFlags And KC_SHIFT <> 0 Then Param := Param Or kb_Shift;
          If fsFlags And KC_CTRL <> 0 Then Param := Param Or kb_Ctrl;
          Menu.ScanEvent(Current,Param,REP);

          If Param = kbNull Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
End;
{$ENDIF}


Function GetMenuHandle(Item:TMenuItem):LongWord;
Begin
     Result := 0;
     Repeat
       If Item Is TMenuItem Then
       Begin
            If Item.Handle <> 0 Then
            Begin
                 Result := Item.Handle;
                 Exit;
            End;
            If Item.FParent = Nil Then   {Item Is root}
            Begin
                 Result := Item.FMenu.Handle;
                 Exit;
            End;
            Item := Item.FParent;
       End;
     Until Item = Nil;
End;


Procedure InsertMenuEntry(AParent,Item:TMenuItem; Index:LongInt);
Var  HMen:LongWord;
     CS:Cstring;
     Child:TForm;
     {$IFDEF OS2}
     mi:MENUITEM;
     p1,p2:LongWord;
     {$ENDIF}
     {$IFDEF Win32}
     cmd:TCommand;
     {$ENDIF}
Begin
     If AParent = Nil Then Exit;
     If Item = Nil Then Exit;

     {AParent already created}
     Item.FMenu := AParent.FMenu;
     If Item.FMenu Is TMenu Then
     Begin
          Item.SetDesigning(AParent.Designed);
          Item.FMenuOwner := TForm(Item.FMenu.Owner);
     End;

     HMen := GetMenuHandle(AParent);
     If Item.FCaption = Nil Then CS := ''
     Else CS := ConvertSystemMnemo(Item.ConvertSystemAccel(Item.FCaption^));
     {$IFDEF OS2}
     mi.afStyle := Item.GetULongFromStyle;
     mi.iPosition := Index;
     mi.afAttribute := Item.GetULongFromFlags;
     If Item.Handle = 0 Then Item.CreateWnd;
     mi.hwndSubMenu := Item.Handle;
     If Item.Glyph <> Nil Then mi.hItem := Item.Glyph.Handle
     Else mi.hItem := 0;
     mi.Id := Item.FInternalCommand;
     p1 := LongWord(@mi);
     p2 := LongWord(@CS);
     WinSendMsg(HMen,MM_INSERTITEM,p1,p2);
     {$ENDIF}
     {$IFDEF Win32}
     cmd := Item.FInternalCommand;
     OemToAnsi(CS,CS);
     If Item.Handle = 0 Then Item.CreateWnd;
     If Item.Handle <> 0 Then cmd := Item.Handle;
     InsertMenu(HMen,Index,MF_BYPOSITION Or Item.GetULongFromStyle Or
                           Item.GetULongFromFlags,cmd,CS);
     {$ENDIF}
     Item.FCreated := True;

     {Assign ShortCut}
     If Not Item.Designed Then
       If Item.FShortCut <> kbNull Then
         If Item.FMenuOwner Is TForm Then
         Begin
              Child := TForm(Item.FMenuOwner);
              Child.AddShortCut(Item.FShortCut, Item.FInternalCommand);
         End;
End;


Function TMenuItem.ConvertSystemAccel(itemcaption:String):String;
{ WD: Checkt den Menueeintrag auf das Zeichen "\t". Wenn dieser gefunden wird
      ersetzt die Funktion mit dem einem TAB-Zeichen und Taststaturtext }

Var  T:Longint;
     acl:String;
Begin
     Result := itemcaption;

     {Test whether Self Is A main entry Of the MainMenu}
     If FMenu Is TMainMenu Then
       If FMenu.FItems = FParent Then exit;

     T := Pos('\t', Result);
     If T > 0 Then
     Begin
          // manual shortcut
          Delete(Result,T,1);
          Result[T] := #9;
     End
     Else
     Begin
          // auto shortcut
          If ShortCut <> kbNull Then
          Begin
               acl := AccelToString(ShortCut);
               If acl <> '' Then Result := Result + #9 + acl;
          End;
     End;
End;


Procedure TMenuItem.SetGlyph(NewGlyph:TGraphic);
Var  HMen:LongWord;
     {$IFDEF OS2}
     mi:MENUITEM;
     cmd:TCommand;
     {$ENDIF}
Begin
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     If NewGlyph<>Nil Then
     Begin
          Include(FStyles,misBitmap);
          Exclude(FStyles,misText);
     End
     Else
     Begin
          Include(FStyles,misText);
          Exclude(FStyles,misBitmap);
     End;

     If FCreated Then
     Begin
          HMen:=GetMenuHandle(Self);
          {$IFDEF OS2}
          cmd:=FInternalCommand;
          WinSendMsg(HMen,MM_QUERYITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
          mi.afStyle:=GetULongFromStyle;
          If NewGlyph<>Nil Then mi.hItem:=NewGlyph.Handle;
          WinSendMsg(HMen,MM_SETITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
          {$ENDIF}
          {$IFDEF Win32}
          {...?}
          {$ENDIF}
     End;

     FGlyph:=NewGlyph;
End;


Function TMenuItem.GetULongFromStyle:LongWord;
Begin
     Result:=0;
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     {$IFDEF OS2}
     If FStyles*[misText]<>[] Then Result:=Result Or MIS_TEXT;
     If FStyles*[misBitmap]<>[] Then Result:=Result Or MIS_BITMAP;
     If FStyles*[misOwnerDraw]<>[] Then Result:=Result Or MIS_OWNERDRAW;
     If FStyles*[misSubmenu]<>[] Then Result:=Result Or MIS_SUBMENU;
     If Caption='-' Then
       If Not Designed Then Result:=(Result Or MIS_SEPARATOR) And (Not MIS_TEXT);
     If FStyles*[misStatic]<>[] Then
       If Not Designed Then Result:=Result Or MIS_STATIC;
     If FStyles*[misBreak]<>[] Then Result:=Result Or MIS_BREAK;
     If FStyles*[misBreakSeparator]<>[] Then Result:=Result Or MIS_BREAKSEPARATOR;
     If FStyles*[misGroup]<>[] Then Result:=Result Or MIS_GROUP;
     If FStyles*[misSingle]<>[] Then Result:=Result Or MIS_SINGLE;
     If FStyles*[misButtonSeparator]<>[] Then Result:=Result Or MIS_BUTTONSEPARATOR;
     If FStyles*[misMultMenu]<>[] Then Result:=Result Or MIS_MULTMENU;
     If FStyles*[misSysCommand]<>[] Then Result:=Result Or MIS_SYSCOMMAND;
     If FStyles*[misHelp]<>[] Then Result:=Result Or MIS_HELP;
     {$ENDIF}
     {$IFDEF Win32}
     If FStyles*[misText]<>[] Then Result:=Result Or MF_STRING;
     If FStyles*[misBitmap]<>[] Then Result:=Result Or MF_BITMAP;
     If FStyles*[misOwnerDraw]<>[] Then Result:=Result Or MF_OWNERDRAW;
     If FStyles*[misSubmenu]<>[] Then Result:=Result Or MF_POPUP;
     If Caption='-' Then
       If Not Designed Then Result:=(Result Or MF_SEPARATOR) And (Not MF_STRING);
     If FStyles*[misStatic]<>[] Then
       If Not Designed Then Result:=Result Or MF_GRAYED;
     If FStyles*[misBreak]<>[] Then Result:=Result Or MF_MENUBREAK;
     If FStyles*[misBreakSeparator]<>[] Then Result:=Result Or MF_MENUBARBREAK;
     (*
     If FStyles*[misMultMenu]<>[] Then Result:=Result Or MIS_MULTMENU;
     If FStyles*[misSysCommand]<>[] Then Result:=Result Or MIS_SYSCOMMAND;
     If FStyles*[misHelp]<>[] Then Result:=Result Or MIS_HELP;
     If FStyles*[misGroup]<>[] Then Result:=Result Or MIS_GROUP;
     If FStyles*[misSingle]<>[] Then Result:=Result Or MIS_SINGLE;
     If FStyles*[misButtonSeparator]<>[] Then Result:=Result Or MF_MENUBARBREAK;
     *)
     {$ENDIF}
End;


{$IFDEF OS2}
Procedure TMenuItem.WMHelp(Var Msg:TMessage);
Var  mi:TMenuItem;
     hctx:THelpContext;
Begin
     hctx := HelpContext;

     mi := FMenu.GetSelectedMenuItem;
     If mi <> Nil Then
       If mi.HelpContext <> 0 Then hctx := mi.HelpContext;

     If hctx <> 0 Then Application.HHelp(hctx,mi.HelpContextString);
     Msg.Handled := True;
End;
{$ENDIF}


Function TMenuItem.GetULongFromFlags:LongWord;
Begin
     Result:=0;
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     {$IFDEF OS2}
     If FFlags*[mifChecked]<>[] Then Result:=Result Or MIA_CHECKED;
     If FFlags*[mifDisabled]<>[] Then Result:=Result Or MIA_DISABLED;
     If FFlags*[mifNoDismiss]<>[] Then Result:=Result Or MIA_NODISMISS;
     If FFlags*[mifFramed]<>[] Then Result:=Result Or MIA_FRAMED;
     If FFlags*[mifHilited]<>[] Then Result:=Result Or MIA_HILITED;
     If Designed Then Result:=Result Or MIA_NODISMISS;
     {$ENDIF}
     {$IFDEF Win32}
     If FFlags*[mifChecked]<>[] Then Result:=Result Or MF_CHECKED;
     If FFlags*[mifDisabled]<>[] Then Result:=Result Or MF_DISABLED Or MF_GRAYED;
     (*
     If FFlags*[mifNoDismiss]<>[] Then Result:=Result Or MIA_NODISMISS;
     If FFlags*[mifFramed]<>[] Then Result:=Result Or MIA_FRAMED;
     If FFlags*[mifHilited]<>[] Then Result:=Result Or MIA_HILITED;
     If Designed Then Result:=Result Or MIA_NODISMISS;
     *)
     {$ENDIF}
End;


Procedure TMenuItem.SetStyles(NewStyles:TMenuItemStyles);
Var  HMen:LongWord;
     CS:Cstring;
     entry:TMenuItem;
     T:LongInt;
     cmd:TCommand;
     {$IFDEF OS2}
     mi:MENUITEM;
     p1,p2:LongWord;
     NewCaption:String;
     {$ENDIF}
     {$IFDEF Win32}
     mp:LongInt;
     NewCaption:String;
     {$ENDIF}
Begin
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     FStyles:=NewStyles;

     If FCreated Then
     Begin
          HMen:=GetMenuHandle(FParent);
          cmd:=FInternalCommand;
          {$IFDEF OS2}
          WinSendMsg(HMen,MM_QUERYITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
          {$ENDIF}

          If (FStyles*[misSubmenu]<>[]) Xor (FHandle<>0) Then
          Begin
               {$IFDEF OS2}
               WinSendMsg(HMen,MM_DELETEITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
               {$ENDIF}

               {$IFDEF Win32}
               mp:=GetMenuIndex;
               DeleteMenu(HMen,mp,MF_BYPOSITION);
               DisposeMenuHandleItem(TForm(FMenuOwner),FHandle,TComponent(Self));
               {$ENDIF}

               If FHandle=0 Then {misSubmenu Set}
               Begin
                    {$IFDEF OS2}
                    HMen := GetMenuHandle(FParent);
                    FHandle := WinCreateMenu(HMen,Nil);
                    WinSetWindowULong(FHandle,QWL_USER,LongWord(Self));    {VMT Pointer}
                    FDefWndProc:=Pointer(WinSubClassWindow(FHandle,@SubclassedMenuItemWndProc));
                    {$ENDIF}

                    {$IFDEF Win32}
                    FHandle:=WinUser.CreateMenu;
                    NewMenuHandleItem(TForm(FMenuOwner),FHandle,TComponent(Self));
                    {$ENDIF}
               End
               Else              {misSubmenu cleared}
               Begin
                    FHandle:=0;
                    {Clear All Submenu entries}
                    {Destroy subitems}
                    If FItems <> Nil Then
                    Begin
                         For T := FItems.Count-1 Downto 0
                            Do TMenuItem(FItems[T]).Destroy;
                         FItems.Destroy;
                         FItems := Nil;
                    End;
               End;

               {$IFDEF OS2}
               mi.afStyle:=GetULongFromStyle;
               mi.hwndSubMenu:=FHandle;
/*
               If FCaption<>Nil Then CS:=FCaption^
               Else CS:='';
*/
               NewCaption:=ConvertSystemAccel(Caption);
               CS:=ConvertSystemMnemo(NewCaption);
               p1:=LongWord(@mi);
               p2:=LongWord(@CS);
               WinSendMsg(HMen,MM_INSERTITEM,p1,p2);
               {$ENDIF}

               {$IFDEF Win32}
               If FHandle<>0 Then cmd:=FHandle;
/*
               NewCaption:=Caption;
               T:=Pos('\t',NewCaption);
               If T>0 Then
               Begin
                    Delete(NewCaption,T,1);
                    NewCaption[T]:=#9;

                    {Test whether Self Is A main entry Of the MainMenu}
                    If FMenu Is TMainMenu Then
                      If FMenu.FItems = FParent Then SetLength(NewCaption,T-1);
               End;
*/
               NewCaption:=ConvertSystemAccel(Caption);
               CS:=ConvertSystemMnemo(NewCaption);
                           OemToAnsi(CS,CS);
               InsertMenu(HMen,mp,MF_BYPOSITION Or GetULongFromStyle Or
                                  GetULongFromFlags,cmd,CS);
               RedrawMenuBar;
               {$ENDIF}

               If Designed Then
                 If FHandle<>0 Then
                   If Not IsEditMenuItem Then
               Begin
                    {Insert New Empty Item To edit the New Submenu Items}
                    entry.Create(FMenu.Owner);
                    entry.Caption:=MenuIDEEditStr;
                    Add(entry);
               End;
          End
          Else
          Begin
               {$IFDEF OS2}
               mi.afStyle:=GetULongFromStyle;
               mi.hwndSubMenu:=FHandle;
               WinSendMsg(HMen,MM_SETITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
               {$ENDIF}

               {$IFDEF Win32}
               If FHandle<>0 Then cmd:=FHandle;
/*
               NewCaption:=Caption;
               T:=Pos('\t',NewCaption);
               If T>0 Then
               Begin
                  Delete(NewCaption,T,1);
                  NewCaption[T]:=#9;

                  {Test whether Self Is A main entry Of the MainMenu}
                  If FMenu Is TMainMenu Then
                    If FMenu.FItems = FParent Then SetLength(NewCaption,T-1);
               End;
*/
               NewCaption:=ConvertSystemAccel(Caption);
               CS:=ConvertSystemMnemo(NewCaption);
               OemToAnsi(CS,CS);
               ModifyMenu(HMen,GetMenuIndex,MF_BYPOSITION Or GetULongFromStyle Or
                          GetULongFromFlags,cmd,CS);
               RedrawMenuBar;
               {$ENDIF}

          End;
     End;
End;


Procedure TMenuItem.SetFlags(NewFlags:TMenuItemFlags);
Var  HMen:LongWord;
     OldFlags:TMenuItemFlags;
     cmd:TCommand;
     {$IFDEF Win32}
     CS:Cstring;
     NewCaption:String;
     {$ENDIF}
Begin
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     OldFlags:=FFlags;
     FFlags:=NewFlags;

     If FCreated Then
     Begin
          HMen:=GetMenuHandle(Self);
          cmd:=FInternalCommand;
          {$IFDEF OS2}
          If FFlags*[mifNoDismiss]<>OldFlags*[mifNoDismiss] Then
              WinSendMsg(HMen,MM_SETITEMATTR,MPFROM2SHORT(cmd,1),
                         MPFROM2SHORT(MIA_NODISMISS,GetULongFromFlags And MIA_NODISMISS));
          If FFlags*[mifFramed]<>OldFlags*[mifFramed] Then
              WinSendMsg(HMen,MM_SETITEMATTR,MPFROM2SHORT(cmd,1),
                         MPFROM2SHORT(MIA_FRAMED,GetULongFromFlags And MIA_FRAMED));
          If FFlags*[mifChecked]<>OldFlags*[mifChecked] Then
              WinSendMsg(HMen,MM_SETITEMATTR,MPFROM2SHORT(cmd,1),
                         MPFROM2SHORT(MIA_CHECKED,GetULongFromFlags And MIA_CHECKED));
          If FFlags*[mifDisabled]<>OldFlags*[mifDisabled] Then
              WinSendMsg(HMen,MM_SETITEMATTR,MPFROM2SHORT(cmd,1),
                         MPFROM2SHORT(MIA_DISABLED,GetULongFromFlags And MIA_DISABLED));
          If FFlags*[mifHilited]<>OldFlags*[mifHilited] Then
              WinSendMsg(HMen,MM_SETITEMATTR,MPFROM2SHORT(cmd,1),
                         MPFROM2SHORT(MIA_HILITED,GetULongFromFlags And MIA_HILITED));
          {$ENDIF}
          {$IFDEF Win32}
          If FHandle<>0 Then cmd:=FHandle;
          NewCaption:=ConvertSystemAccel(Caption);
          CS:=ConvertSystemMnemo(NewCaption);
          OemToAnsi(CS,CS);
          ModifyMenu(HMen,GetMenuIndex,MF_BYPOSITION Or GetULongFromStyle Or
                     GetULongFromFlags,cmd,CS);
          RedrawMenuBar;
          {$ENDIF}
     End;
End;

Procedure TMenuItem.CreateWnd;

Var  T:LongInt;
     Item:TMenuItem;
     {$IFDEF OS2}
     HMen:LongWord;
     {$ENDIF}
Begin
     If FMenu = Nil Then Exit;
     If FMenu.FItems <> Self Then  {Not the root Item}
     Begin
          If Handle<>0 Then Exit;
          If FInitItems=Nil Then Exit;

          {$IFDEF OS2}
          HMen := GetMenuHandle(FParent);
          FHandle := WinCreateMenu(HMen,Nil);
          WinSetWindowULong(FHandle,QWL_USER,LongWord(Self));    {VMT Pointer}
          FDefWndProc:=Pointer(WinSubClassWindow(FHandle,@SubclassedMenuItemWndPRoc));
          {$ENDIF}
          {$IFDEF Win32}
          FHandle:=WinUser.CreateMenu;
          NewMenuHandleItem(TForm(FMenuOwner),FHandle,TComponent(Self));
          {$ENDIF}
     End;

     If FInitItems<>Nil Then
     Begin
          For T:=0 To FInitItems.Count-1 Do
          Begin
               Item:=FInitItems.Items[T];
               InsertMenuEntry(Self,Item,-1);
          End;
          FInitItems:=Nil;
     End;
End;


Function TMenuItem.GetCaption:String;

Begin
     Result:='';
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     If FCaption<>Nil Then Result:=FCaption^;
     If Result=MenuIDEEditStr Then Result:='';
End;


Procedure TMenuItem.SetCaption(NewCaption:String);
Var  CS:CString;
     HMen:LongWord;
     Own:TMenuItem;
     entry:TMenuItem;
{     T:Byte; }
     cmd:TCommand;
     DNS:TDesignerNotifyStruct;
     {$IFDEF OS2}
     mi:MENUITEM;
     {$ENDIF}
Begin
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

/*
     T:=Pos('\t',NewCaption);
     If T>0 Then
     Begin
          Delete(NewCaption,T,1);
          NewCaption[T]:=#9;

          {Test whether Self Is A main entry Of the MainMenu}
          If FMenu Is TMainMenu Then
            If FMenu.FItems = FParent Then SetLength(NewCaption,T-1);
     End;
*/

     If FCaption<>Nil Then
     Begin
          If Designed Then
            If FCreated Then
              If FParent <> Nil Then
                If IsEditMenuItem Then
                  If NewCaption<>MenuIDEEditStr Then
                  Begin
                       If (FParent.FParent = Nil) And
                          (FMenu Is TMainMenu) Then
                       Begin
                            {New main Menu entry}
                            entry.Create(FMenu.Owner);
                            entry.Caption:=MenuIDEEditStr;
                            FMenu.Items.Add(entry);

                            Own:=Self;
                       End
                       Else Own:=FParent;

                       {New SUB Menu entry}
                       entry.Create(FMenu.Owner);
                       entry.Caption:=MenuIDEEditStr;
                       Own.Add(entry);

                       If FMenu.Owner Is TForm Then
                       Begin
                            {GenNewComponent}
                            DNS.Sender := Self;
                            DNS.Code := dncNewMenuItem;
                            DNS.return := 0;
                            TForm(FMenu.Owner).DesignerNotification(DNS);
                       End;
                  End;

          DisposeStr(FCaption);
          FCaption:=Nil;
     End;

     If NewCaption <> '' Then AssignStr(FCaption,NewCaption);

     If FCreated Then
     Begin
          HMen:=GetMenuHandle(FParent);
          cmd:=FInternalCommand;

          NewCaption:=ConvertSystemAccel(NewCaption);   { WD: TAB und Accel in Text konvertieren }
          CS := ConvertSystemMnemo(NewCaption);
          {$IFDEF OS2}
          If (NewCaption = '-') And Not Designed Then
          Begin
               WinSendMsg(HMen,MM_QUERYITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
               mi.afStyle:=GetULongFromStyle;
               WinSendMsg(HMen,MM_SETITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
          End
          Else WinSendMsg(HMen,MM_SETITEMTEXT,cmd,LongWord(@CS));
          {$ENDIF}
          {$IFDEF Win32}
          If FHandle<>0 Then cmd:=FHandle;
          OemToAnsi(CS,CS);
          ModifyMenu(HMen,GetMenuIndex,MF_BYPOSITION Or GetULongFromFlags Or
                     GetULongFromStyle,cmd,CS);
          RedrawMenuBar;
          {$ENDIF}
     End;
End;


Procedure TMenuItem.SetupComponent;
Begin
     Inherited SetupComponent;

     Caption:=Name;
     FStyles:=[misText];
     FFlags:=[];
     FCommand:=cmNull;
     SaveLoadInfo:=false;

     If IsControl(TControl(Owner)) Then FMenuOwner:=TControl(Owner);

     If Application <> Nil Then FInternalCommand := Application.NewMenuItem(Self);
End;


Procedure TMenuItem.Add(Item:TMenuItem);
Begin
     Insert(-1,Item);
End;

Procedure TMenuItem.Insert(Index:LongInt;Item:TMenuItem);
Begin
     If Item = Nil Then Exit;
     Item.FParent := Self;

     If FItems = Nil Then FItems.Create;
     If Index > FItems.Count Then Index := FItems.Count;
     If Index < 0 Then Index := FItems.Add(Item)
     Else FItems.Insert(Index,Item);

     Styles := Styles + [misSubmenu];

     If FCreated Then InsertMenuEntry(Self,Item,Index)
     Else FInitItems := FItems;
End;

Procedure TMenuItem.SetShortCut(NewAccel:TKeyCode);

Var Child:TForm;
    OldAccel:LongWord;

Begin
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     {Test whether Self Is A main entry Of the MainMenu}
     If FMenu Is TMainMenu Then
       If FMenu.FItems = FParent Then Exit;

     OldAccel:=FShortCut;
     FShortCut:=NewAccel;
     If Not Designed Then
       If FShortCut<>kbNull Then
         If FMenuOwner Is TForm Then
         Begin
              Child:=TForm(FMenuOwner);
              If OldAccel<>kbNull Then Child.DeleteShortCut(OldAccel);
              Child.AddShortCut(FShortCut,FInternalCommand);
         End;

     {auto Add ShortCut String}

     SetCaption(Caption);
End;


Destructor TMenuItem.Destroy;
Var  HMen:LongWord;
     Child:TForm;
     idx,T:LongInt;
     {$IFDEF OS2}
     Id:Word;
     {$ENDIF}
Begin
     idx := GetMenuIndex;
     Try
        If FParent Is TMenuItem Then FParent.FItems.Remove(Self); {entferne aus Liste}
     Except
        //ErrorBox2('Menu item not found in Parent menu (Destroy)');
     End;

     HMen := GetMenuHandle(FParent);
     If HMen <> 0 Then
       If idx >= 0 Then
     Begin
          {$IFDEF OS2}
          Id := FInternalCommand;
          If WinSendMsg(HMen,MM_ITEMIDFROMPOSITION,idx,0) = Id
          Then WinSendMsg(HMen,MM_DELETEITEMBYPOS,idx,0)
          Else WinSendMsg(HMen,MM_DELETEITEM,MPFROM2SHORT(Id,1),0);
          {$ENDIF}
          {$IFDEF Win32}
          DeleteMenu(HMen,idx,MF_BYPOSITION);
          DisposeMenuHandleItem(TForm(FMenuOwner),FHandle,TComponent(Self));
          RedrawMenuBar;
          {$ENDIF}
     End;

     If Not Designed Then
       If FShortCut <> 0 Then
         If FMenuOwner Is TForm Then
     Begin
          Child := TForm(FMenuOwner);
          Child.DeleteShortCut(FShortCut);
          FShortCut := 0;
     End;

     If FHandle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinSubClassWindow(FHandle,@FDefWndProc);
          WinDestroyWindow(FHandle);
          {$ENDIF}
          {$IFDEF Win32}
          DestroyMenu(FHandle);   // war DestroyWindow(FHandle);
          {$ENDIF}
          FHandle := 0;
     End;

     {Destroy subitems}
     If FItems <> Nil Then
     Begin
          For T := FItems.Count-1 Downto 0 Do TMenuItem(FItems[T]).Destroy;
          FItems.Destroy;
          FItems := Nil;
     End;

     DisposeStr(FCaption);
     FCaption := Nil;

     Application.DeleteMenuItem(Self);

     Inherited Destroy;
End;


Function TMenuItem.IndexOf(Item:TMenuItem):LongInt;
Begin
     If FItems <> Nil Then Result := FItems.IndexOf(Item)
     Else Result := -1;
End;

Procedure TMenuItem.RefreshLanguage;

Var LngEntry: String;
    cCaption: cString;

Begin
  LngEntry:=LngMenuItemEntry+uppercase(UniqueName)+'_';
  Application.LogWriteln('RefreshLanguage.LngEntry: '+LngEntry);
  Self.Caption:= Application.LanguageFile.GetText(LngEntry+'CAPTION',Self.Caption);
  Self.Hint   := Application.LanguageFile.GetText(LngEntry+'HINT',Self.Hint);
End;



Procedure TMenuItem.LoadedFromSCU(SCUParent:TComponent);

var MenuOwnerForm : tForm;

Begin
     Inherited LoadedFromSCU(SCUParent);

// Texte von der Sprache-Datei einlesen
     if (designed=false) and
        (tForm(FMenuOwner).LanguageSupport) then
       RefreshLanguage;

// Konvertieren von "~" und "&"
     Self.Caption:=ConvertSCUMNemo(Self.Caption);

     If SCUParent Is TMenuItem Then TMenuItem(SCUParent).Add(Self);
     If SCUParent Is TMenu Then TMenu(SCUParent).FItems.Add(Self);
End;


Procedure TMenuItem.GetChildren(Proc:TGetChildProc);
Var  T:LongInt;
     Item:TMenuItem;
Begin
     If Count > 0 Then
     Begin
          For T := 0 To Count-1 Do
          Begin
               Item := Items[T];
               If Item.Designed Then
                 If Not Item.IsEditMenuItem Then Proc(Item);
          End;
     End;
End;


Procedure TMenuItem.SetHint(Const NewText:String);
Begin
     DisposeStr(FHint);
     FHint := Nil;
     If NewText = '' Then Exit;
     AssignStr(FHint,NewText);
End;


Function TMenuItem.GetHint:String;
Begin
     If FHint = Nil Then Result := ''
     Else Result := FHint^;
End;


Function TMenuItem.GetChecked:Boolean;
Begin
     Result := Flags * [mifChecked] <> [];
End;


Procedure TMenuItem.SetChecked(Value:Boolean);
Begin
     If GetChecked = Value Then Exit;

     If Value Then Flags := Flags + [mifChecked]
     Else Flags := Flags - [mifChecked];
End;


Function TMenuItem.GetEnabled:Boolean;
Begin
     Result := Flags * [mifDisabled] = [];
End;


Procedure TMenuItem.SetEnabled(Value:Boolean);
Begin
     If GetEnabled = Value Then Exit;

     If Value Then Flags := Flags - [mifDisabled]
     Else Flags := Flags + [mifDisabled];
End;


Function TMenuItem.GetBreak:TMenuBreak;
Begin
     If Caption = '-' Then Result := mbSeparator
     Else If FStyles * [misBreakSeparator] <> [] Then Result := mbBarBreak
     Else If FStyles * [misBreak] <> [] Then Result := mbBreak
          Else Result := mbNone;
End;


Procedure TMenuItem.SetBreak(Value:TMenuBreak);
Begin
     Case Value Of
       mbNone:
       Begin
            Exclude(FStyles,misBreak);
            Exclude(FStyles,misBreakSeparator);
            If Caption = '-' Then Caption := '';
       End;
       mbBreak:
       Begin
            Include(FStyles,misBreak);
            Exclude(FStyles,misBreakSeparator);
            If Caption = '-' Then Caption := '';
       End;
       mbBarBreak:
       Begin
            Exclude(FStyles,misBreak);
            Include(FStyles,misBreakSeparator);
            If Caption = '-' Then Caption := '';
       End;
       mbSeparator:
       Begin
            Exclude(FStyles,misBreak);
            Exclude(FStyles,misBreakSeparator);
            Caption := '-';
       End;
     End;
     SetStyles(FStyles); {Update the Menu}
End;


Function TMenuItem.GetSubMenu:Boolean;
Begin
     Result := styles * [misSubmenu] <> [];
End;


Procedure TMenuItem.SetSubMenu(Value:Boolean);
Begin
     If GetSubMenu = Value Then Exit;

     If Value Then styles := styles + [misSubmenu]
     Else styles := styles + [misSubmenu];
End;


Function TMenuItem.GetCount:LongInt;
Begin
     If FItems <> Nil Then Result := FItems.Count
     Else Result := 0;
End;


Function TMenuItem.GetItem(Index:LongInt):TMenuItem;
Begin
     If FItems <> Nil Then Result := TMenuItem(FItems[Index])
     Else Result := Nil;
End;


Function TMenuItem.GetMenuIndex:LongInt;
Begin
     If FParent <> Nil Then Result := FParent.IndexOf(Self)
     Else Result := -1;
End;


Function TMenuItem.GetIsEditMenuItem:Boolean;
Begin
     Result := False;
     If Designed Then
       If FCaption <> Nil Then
         If FCaption^ = MenuIDEEditStr Then Result := True;
End;


Procedure TMenuItem.Click;
Begin
     If FOnClick <> Nil Then FOnClick(Self);

     If IsControl(TControl(FMenuOwner)) Then
       SendMsg(TControl(FMenuOwner).Handle,WM_COMMAND,FCommand,0);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TMenu Class Implementation                                  บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Procedure TMenu.WMPresParamChanged(Var Msg:TMessage);

  Function GetColor(iPPid : LongWord) : tColor;

  Var NewColor : LongInt;

  Begin
    WinQueryPresParam(fHandle, iPPid, 0, Nil, 4, NewColor, QPF_NOINHERIT);
    Result:=NewColor;
  End;

Var PPid:LongWord;

Begin
///*   PP_MENUFOREGROUNDCOLOR
//   PP_MENUBACKGROUNDCOLOR
//   PP_MENUHILITEFGNDCOLOR
//   PP_MENUHILITEBGNDCOLOR
//   PP_MENUDISABLEDFGNDCOLOR
//   PP_MENUDISABLEDBGNDCOLOR */
//
  PPid := Msg.Param1;
  Case PPid Of
    PP_MENUFOREGROUNDCOLOR: fForeGroundColor := GetColor(PP_MENUFOREGROUNDCOLOR);
    PP_MENUBACKGROUNDCOLOR: fBackGroundColor := GetColor(PP_MENUBACKGROUNDCOLOR);
  End;

End;
{$ENDIF}

Destructor TMenu.Destroy;
Var  HMen:LongWord;
Begin
     If FHandle<>0 Then
     Begin
          HMen:=FHandle;
          FHandle:=0;

          {maybe FParent Is already destroyed}
          If Not (IsControl(TControl(FParent))) Then FParent := Nil;

          {$IFDEF OS2}
          WinSubClassWindow(HMen,@FDefWndProc);
          WinDestroyWindow(HMen);
          If FParent <> Nil Then
          Begin
               WinSendMsg(TControl(FParent).Handle,WM_UPDATEFRAME,FCF_MENU,0);
          End;
          {$ENDIF}

          {$IFDEF Win32}
          DestroyMenu(HMen);
          If FParent <> Nil Then
          Begin
               DisposeMenuHandleItem(TForm(FParent),HMen,TComponent(Self));
               SetMenu(TControl(FParent).Handle,0);
          End;
          {$ENDIF}
     End;

     FItems.Destroy;
     FItems := Nil;
     If FAlternateFontName<>Nil Then DisposeStr(FAlternateFontName);
     FAlternateFontName:=Nil;

     Inherited Destroy;
End;

{$IFDEF OS2}
Function SubclassedMenuWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;CDECL;
Var  Menu:TMenu;
     aMsg:TMessage;
     Handled:Boolean;
Begin
     Menu:=Pointer(WinQueryWindowULong(Win,QWL_USER));  {Get VMT Pointer}
     If Menu=Nil Then Exit;
     aMsg.Receiver:=Win;
     aMsg.ReceiverClass:=Menu;
     aMsg.Msg:=Msg;
     aMsg.Param1:=para1;
     aMsg.Param2:=para2;
     aMsg.Handled:=False;

     If ((Application<>Nil)And(Application.OnMsgEvent<>Nil)) Then
     Begin
          Handled:=False;
          Application.OnMsgEvent(aMsg,Handled);
          aMsg.Handled:=aMsg.Handled Or Handled;
     End;

     If Not aMsg.Handled Then Menu.Dispatch(aMsg);
     If Not aMsg.Handled
     Then aMsg.Result:=Menu.FDefWndProc(aMsg.Receiver,aMsg.Msg,
                                        aMsg.Param1,aMsg.Param2);
     Result:=aMsg.Result;
End;
{$ENDIF}

Procedure TMenu.SetFont(NewFont:TFont);
{$IFDEF OS2}
Var  S:String;
     C:Cstring;
     CS:Cstring;
{$ENDIF}
{$IFDEF Win32}
Var  aFontInfo:LOGFONT;
     FDefFontHandle:LongWord;
{$ENDIF}
Begin
     If FFont<>NewFont Then
     Begin
          DereferenceFont(FFont,True);
          FFont:=NewFont;
          ReferenceFont(FFont);
     End;

     {$IFDEF Win32}
     If FFont<>Nil Then
     Begin
          If TPublicFont(FFont).Handle<>0 Then
          Begin
               If FDefFontHandle<>TPublicFont(FFont).Handle Then
               Begin
                    FDefFontHandle:=TPublicFont(FFont).Handle;
                    TPublicFont(FFont).RefCount:=TPublicFont(FFont).RefCount+1;
               End;
          End
          Else
          Begin
               aFontInfo:=TPublicFont(FFont).FontInfo;
               aFontInfo.lfHeight:=TPublicFont(FFont).FontInfo.lfHeight;
               aFontInfo.lfWidth:=TPublicFont(FFont).FontInfo.lfWidth;
               aFontInfo.lfQuality:=DRAFT_QUALITY;
               aFontInfo.lfItalic:=0;
               aFontInfo.lfUnderline:=0;
               aFontInfo.lfStrikeOut:=0;
               aFontInfo.lfWeight:=FW_NORMAL;
               FDefFontHandle:=CreateFontIndirect(aFontInfo);
               TPublicFont(FFont).Handle:=FDefFontHandle;
               TPublicFont(FFont).RefCount:=1;
          End;
     End;
     {$ENDIF}

     If Handle <> 0 Then If FFont<>Nil Then
     Begin
          {$IFDEF OS2}
          If TPublicFont(FFont).InternalPointSize<>0 Then
          Begin
               S:=tostr(TPublicFont(FFont).InternalPointSize)+'.';
               C:=FFont.FaceName;
          End
          Else
          Begin
               S:=tostr((TPublicFont(FFont).FontInfo.sNominalPointSize) Div 10)+'.';
               C:=TPublicFont(FFont).FontInfo.szFaceName;
          End;

          CS:=S+C;
          WinSetPresParam(Handle,PP_FONTNAMESIZE,Length(CS)+1,CS);
          {$ENDIF}
          {$IFDEF Win32}
          SendMsg(Handle,WM_SETFONT,FDefFontHandle,1);
          {$ENDIF}
     End;
End;


Procedure TMenu.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
     If ResName = rnFont Then
     Begin
          If DataLen <> 0 Then
          Begin
               Font := ReadSCUFont(Data,DataLen);
               If ((Font<>Nil)And(TPublicFont(Font).AlternateName<>Nil)) Then
               Begin
                   AssignStr(FAlternateFontName,TPublicFont(Font).AlternateName^);
                   DisposeStr(TPublicFont(Font).AlternateName);
                   TPublicFont(Font).AlternateName:=Nil;
               End;
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


Function TMenu.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FFont = Nil Then
     Begin
          Result := True;
          Exit;
     End;

     DisposeStr(TPublicFont(FFont).AlternateName);
     TPublicFont(FFont).AlternateName:=FAlternateFontName;
     Result := FFont.WriteSCUResourceName(Stream,rnFont);
     TPublicFont(FFont).AlternateName:=Nil;
End;


Procedure TMenu.DisableCommands(Cmds:Array Of TCommand);
Var  T:LongInt;
     entry:TMenuItem;
Begin
     For T := Low(Cmds) To High(Cmds) Do
     Begin
          entry := ItemFromCommand(Cmds[T]);
          If entry <> Nil Then entry.Enabled := False;
     End;
End;


Procedure TMenu.EnableCommands(Cmds:Array Of TCommand);
Var  T:LongInt;
     entry:TMenuItem;
Begin
     For T := Low(Cmds) To High(Cmds) Do
     Begin
          entry := ItemFromCommand(Cmds[T]);
          If entry <> Nil Then entry.Enabled := True;
     End;
End;


{$IFDEF OS2}
Procedure TMenu.WMHelp(Var Msg:TMessage);
Var  mi:TMenuItem;
Begin
     mi := GetSelectedMenuItem;
     If mi <> Nil Then
       If mi.HelpContext <> 0 Then Application.HHelp(mi.HelpContext, mi.HelpContextString);

     Msg.Handled := True;
End;


Procedure TMenu.WMChar(Var Msg:TWMChar);
Var fsFlags:LongWord;
    REP:Byte;
    scan:Byte;
    ascii:Byte;
    virtkey:Word;
    Current:TMenuItem;
    CH:Char;
    Param:TKeyCode;
    SelItem:Word;
Label lsc;
Begin
     fsFlags := Msg.KeyData;
     REP := GetKeyRepeat(TMessage(Msg));
     scan := Msg.ScanCode;
     ascii := Lo(Msg.CharCode);
     virtkey := Msg.VirtualKeyCode;

     If fsFlags And KC_KEYUP <> 0 Then Exit;
     If Not (Self Is TMenu) Then Exit;

     SelItem:=WinSendMsg(Handle,MM_QUERYSELITEMID,MPFROM2SHORT(0,1),0);
     Current:=ItemFromInternalCommand(SelItem);
     If Current=Nil Then Exit;

     If fsFlags And KC_CHAR <> 0 Then
     Begin
          If (ascii < 32) Or  (fsFlags And KC_CTRL <> 0) Then Goto lsc;
          If (fsFlags And KC_VIRTUALKEY <> 0) And (fsFlags And KC_SHIFT <> 0)
          Then Goto lsc;    {numerical block}
          CH := Chr(ascii);
          CharEvent(Current,CH,REP);

          If CH = #0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End
     Else
     Begin
lsc:
          Param := 0;
          If fsFlags And KC_VIRTUALKEY <> 0 Then Param := virtkey Or kb_VK
          Else Param := ascii Or kb_Char;       {E.G. Ctrl-J}

          If fsFlags And KC_ALT <> 0 Then Param := Param Or kb_Alt;
          If fsFlags And KC_SHIFT <> 0 Then Param := Param Or kb_Shift;
          If fsFlags And KC_CTRL <> 0 Then Param := Param Or kb_Ctrl;
          ScanEvent(Current,Param,REP);

          If Param = kbNull Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
End;
{$ENDIF}


Procedure TMenu.CharEvent(entry:TMenuItem;Var key:Char;REP:Byte);
Var  Child:TForm;
Begin
     If Owner Is TForm Then
     Begin
          Child:=TForm(Owner);
          Child.MenuCharEvent(Self,entry,key,REP);

          If Designed Then key := #0;
     End;
End;


Procedure TMenu.ScanEvent(entry:TMenuItem;Var KeyCode:TKeyCode;REP:Byte);
Var  Child:TForm;
Begin
     If Owner Is TForm Then
     Begin
          Child:=TForm(Owner);
          Child.MenuScanEvent(Self,entry,KeyCode,REP);

          If Designed Then
            If Not (KeyCode In [kbEsc,kbCLeft,kbCRight])
            Then KeyCode := kbNull;
     End;
End;


Procedure TMenu.LoadedFromSCU(SCUParent:TComponent);
  Procedure ProcessSubMenus(ParentItem:TMenuItem);
  Var  T:LongInt;
       entry:TMenuItem;
  Begin
       {Append pseudo Menus}
       For T := 0 To ParentItem.Count-1 Do
       Begin
            entry := ParentItem.Items[T];
            If entry Is TMenuItem Then
            Begin
                 If ((Self Is TMainMenu) And (ParentItem = Items)) Or
                     (entry.Count > 0) Then ProcessSubMenus(entry);
            End;
       End;

       {New Submenu entry}
       entry.Create(Owner{Self});
       entry.Caption := MenuIDEEditStr;
       ParentItem.Add(entry);
  End;
Begin
     Inherited LoadedFromSCU(SCUParent);

     If Designed Then ProcessSubMenus(Items);
End;


Procedure TMenu.GetChildren(Proc:TGetChildProc);
Begin
     FItems.GetChildren(Proc);
End;


Function SearchSubEntry(Menu:TMenu;AParent:TMenuItem;Command:TCommand;
                        internal:Boolean):TMenuItem;
Var  T:LongInt;
     cmd:TCommand;
     entry:TMenuItem;
Begin
     Result := Nil;
     For T := 0 To AParent.Count-1 Do
     Begin
          entry := AParent.Items[T];
          If internal Then cmd := entry.FInternalCommand
          Else cmd := entry.FCommand;

          If cmd = Command Then
          Begin
               Result := entry;
               Exit;
          End;
          If entry.Count > 0 Then
          Begin
               Result := SearchSubEntry(Menu,entry,Command,internal);
               If Result <> Nil Then Exit;
          End;
     End;
End;


Function TMenu.ItemFromCommand(Command:TCommand):TMenuItem;
Begin
  Result := SearchSubEntry(Self,Items,Command,False);
End;


Function TMenu.ItemFromInternalCommand(Command:TCommand):TMenuItem;
Begin
  Result := Application.GetMenuItem(Command);
End;

Function TMenu.GetSelectedMenuItem:TMenuItem;
{$IFDEF OS2}
Var  SelItemId:Word;
{$ENDIF}
Begin
     {$IFDEF OS2}
     SelItemId := WinSendMsg(Handle,MM_QUERYSELITEMID,MPFROM2SHORT(0,1),0);
     Result := ItemFromInternalCommand(SelItemId);
     {$ENDIF}
     {$IFDEF Win32}
     Result:=Nil;
     {...?}
     {$ENDIF}
End;


Function TMenu.GetWidth:LongInt;
Var  rc:RECTL;
Begin
     Result := 0;
     {$IFDEF OS2}
     If FHandle <> 0 Then
       If WinQueryWindowRect(FHandle,rc) Then Result := rc.xRight;
     {$ENDIF}
     {$IFDEF Win32}
     If FHandle <> 0 Then
       If Items.Count > 0 Then
     Begin
          {rightmost MENUITEM}
          WinUser.GetMenuItemRect(TControl(FParent).Handle,FHandle,Items.Count-1,rc);
          Result := rc.Right;
          {leftmost MENUITEM}
          WinUser.GetMenuItemRect(TControl(FParent).Handle,FHandle,0,rc);
          Dec(Result,rc.Left);
     End;
     {$ENDIF}
End;


Function TMenu.GetHeight:LongInt;
Var  rc:RECTL;

Begin
     Result := 0;
     {$IFDEF OS2}
     If FHandle <> 0 Then
       If WinQueryWindowRect(FHandle,rc) Then Result := rc.yTop;
     {$ENDIF}
     {$IFDEF Win32}
     If FHandle <> 0 Then
       If Items.Count > 0 Then
     Begin
          {rightmost MENUITEM}
          WinUser.GetMenuItemRect(TControl(FParent).Handle,FHandle,Items.Count-1,rc);
          Result := rc.Bottom;
          {leftmost MENUITEM}
          WinUser.GetMenuItemRect(TControl(FParent).Handle,FHandle,0,rc);
          Dec(Result,rc.Top);
     End;
     {$ENDIF}
End;

Procedure TMenu.WriteInfoToINI(InfoLine : String);

Var CntrlInfo       : String;
    FontInfo        : String;

Begin
  if (Application=nil) or (Application.ProgramIniFile=nil) or
     (Application.FormInfoINI in [fiNone, fiLoadFormINI]) or
     (SaveLoadInfo=false) then exit;

    if fFont=nil
      then FontInfo:=';;'
      else FontInfo:=fFont.FaceName+ ';' + toStr(fFont.PointSize) + ';';

  CntrlInfo:= TagINI_Menu + FontInfo +
                            toStr(fForeGroundColor)  + ';' +
                            toStr(fBackGroundColor)  + ';' +
//                            HiliteFgndColor  +
//                            HiliteBgndColor  +
//                            DisableFgndColor +
//                            DisableBgndColor +
              TagINI_End + InfoLine;     //; + iif(InfoLine='','',';'+InfoLine);
  inherited WriteInfoToINI(CntrlInfo);
End;

Function TMenu.ReadInfoFromINI : String;

var TagInfoList: tStringList;
    FontName   : String;
    FontSize   : LongInt;

Begin
  if (Application=nil) or (Application.ProgramIniFile=nil) or
     (Application.FormInfoINI in [fiNone, fiSaveToINI]) or
     (SaveLoadInfo=false) then exit;

  result:=inherited ReadInfoFromINI;
  if result=''
    then
      Begin
        fForeGroundColor:=-1;
        fBackGroundColor:=-1;
      End
    else
      Begin
          TagInfoList.Create;

          Result:=getInfoTag(TagINI_Menu, result, TagInfoList);

          try
            FontName        := TagInfoList.Strings[0];
            FontSize        := StrToInt(TagInfoList.Strings[1]);
            FFont           := Screen.GetFontFromPointSize(FontName, FontSize);
            fForeGroundColor:= StrToInt(TagInfoList.Strings[2]);
            fBackGroundColor:= StrToInt(TagInfoList.Strings[3]);
          except
          end;
          TagInfoList.Destroy;
      End;
End;



Const
   TMenuItemRegistered:Boolean=False;

Procedure TMenu.SetupComponent;
Begin
     Inherited SetupComponent;

     SaveLoadInfo:=true;
     FFont:=Screen.MenuFont;
     FParent := TControl(Owner);
     If Owner <> Nil Then SetDesigning(Owner.Designed);

     FItems.Create(Nil);
     FItems.FParent := Nil;
     FItems.FMenu := Self;
     FItems.SetDesigning(Designed);
     Include(FItems.ComponentState, csDetail);

     If Not TMenuItemRegistered Then
     Begin
          RegisterClasses([TMenuItem]); {RuntimeSCU}
          TMenuItemRegistered := True;
     End;
End;


Procedure TMenu.LoadResource;
Begin
     {$IFDEF OS2}
     WinLoadMenu(TControl(FParent).Handle,0,FResourceId);
     {$ENDIF}
     {$IFDEF Win32}
     SetMenu(TControl(FParent).Handle,LoadMenu(DllModule,MAKEINTRESOURCE(FResourceId)^));
     {$ENDIF}
End;


Procedure TMenu.CreateMenu;

{$IFDEF OS2}
  Function SetColor(iPPid : LongWord; iColor : tColor) : Boolean;

  Var NewColor : tColor;

  Begin
    NewColor := SysColorToRGB(iColor);
    Result:=WinSetPresParam(fHandle,iPPid,4,NewColor);
    WinSetPresParam(fHandle,iPPid,4,NewColor);
  End;
{$ENDIF}

Begin
     {$IFDEF OS2}
     FHandle:=WinCreateMenu(TControl(FParent).Handle,Nil);  {Empty Menu}
     If FHandle=0 Then Exit;
     WinSetWindowULong(FHandle,QWL_USER,LongWord(Self));    {VMT Pointer}
     FDefWndProc:=Pointer(WinSubClassWindow(FHandle,@SubclassedMenuWndProc));

// Setzen der Farben
     if (fForeGroundColor<>0) and (fBackGroundColor<>0) then
       Begin
         if fForeGroundColor<>-1 then
           SetColor(PP_MENUFOREGROUNDCOLOR, fForeGroundColor);
         if fBackGroundColor<>-1 then
           SetColor(PP_MENUBACKGROUNDCOLOR, fBackGroundColor);
       End;
     {$ENDIF}

     {$IFDEF Win32}
     FHandle:=WinUser.CreateMenu;
     If FHandle=0 Then Exit;
     NewMenuHandleItem(TForm(FParent){Parent},FHandle,TComponent(Self));
     {$ENDIF}

// Setzen der Schriftart
     If FFont<>Nil Then SetFont(FFont);
End;

                        
Procedure TMenu.Show;
Begin
     If Not (IsControl(TControl(Owner))) Then Exit;
     If FParent = Nil Then Exit;
     If TControl(FParent).Handle = 0 Then Exit;

     If FResourceId<>0 Then
     Begin
          LoadResource;
          Exit;
     End;

     If FHandle=0 Then
     Begin
          CreateMenu;
          If FHandle = 0 Then Exit;

          FItems.CreateWnd;
          FItems.FCreated := True;
     End;

     If Not ((Self Is TMainMenu) Or (Self Is TPopupMenu)) Then
     Begin {?}
          {$IFDEF OS2}
          WinShowWindow(FHandle,True);
          {$ENDIF}
          {$IFDEF Win32}
          DrawMenuBar(TControl(FParent).Handle);
          {$ENDIF}
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TPopupMenu Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Destructor TPopUpMenu.Destroy;
Begin
     Inherited Destroy;
End;

Procedure TPopupMenu.SetupComponent;
Begin
     Inherited SetupComponent;

     FAutoPopup := True;
     FAlignment := paCenter;
     Include(ComponentState, csHandleLinks);
End;


Procedure TPopupMenu.CreateMenu;
Begin
     {$IFDEF OS2}
     Inherited CreateMenu;
     {$ENDIF}

     {$IFDEF Win32}
     FHandle:=WinUser.CreatePopupMenu;
     If FHandle=0 Then Exit;
     NewMenuHandleItem(TForm(FParent),FHandle,TComponent(Self));
     {$ENDIF}
End;

Procedure TPopupMenu.Popup(X,Y:LongInt);
{$IFDEF OS2}
Var  iditem:LongWord;
     AL:LongInt;
{$ENDIF}
{$IFDEF Win32}
Var  pt:TPoint;
     AL:Word;
{$ENDIF}
Begin
     If Handle = 0 Then Show;
     If Handle = 0 Then Exit;

     If FOnPopup <> Nil Then FOnPopup(Self);

     {$IFDEF OS2}
     If (Width = 0) And (FAlignment = paRight) Then
     Begin 
          // Create the Window outside Of the Screen To Get the Real Width
          WinPopupMenu(HWND_DESKTOP,Screen.HiddenWindow.Handle,Handle,
                       Screen.Width,Screen.Height, 0, 0);
     End;

     If FItems.Count > 0 Then iditem := FItems.Items[0].FInternalCommand
     Else iditem := 0;

     AL := PU_HCONSTRAIN Or PU_VCONSTRAIN;
     Case FAlignment Of
       paCenter: AL := AL Or PU_POSITIONONITEM;
       paRight: Dec(X, Width);
     End;
     WinPopupMenu(HWND_DESKTOP,Screen.HiddenWindow.Handle,Handle,X,Y,iditem,
                  AL Or PU_KEYBOARD Or PU_MOUSEBUTTON1);
     {$ENDIF}

     {$IFDEF Win32}
     WinUser.SetCursor(Screen.Cursors[crArrow]); {force Cursor}
     pt := Point(X,Y);
     TransformPointToWin32(pt,Nil,Nil);

     Case FAlignment Of
       paLeft: AL := TPM_LEFTALIGN;
       paCenter: AL := TPM_CENTERALIGN;
       paRight: AL := TPM_RIGHTALIGN;
     End;

     TrackPopupMenu(Handle,AL, pt.X,pt.Y,0,Screen.HiddenWindow.Handle,Nil);
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TMainMenu Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TMainMenu.SetupComponent;
Begin
     Inherited SetupComponent;

     Include(ComponentState, csHandleLinks);

     {Martin, idea from Aaron Lawrence}
     Font := Screen.MenuFont;
End;


Procedure TMainMenu.Show;
{$IFDEF OS2}
Var  HMen:LongWord;
     ulStyle:LongWord;
{$ENDIF}
Begin
     If FParent Is TForm Then
       If TForm(FParent).Frame <> Nil
       Then FParent := TForm(FParent).Frame;

     Inherited Show;

     If FHandle=0 Then Exit;

     {$IFDEF OS2}
     HMen:=WinWindowFromID(TControl(FParent).Handle,FID_MENU);

     If HMen<>0 Then
     Begin
          WinSetParent(HMen,WinQueryObjectWindow(HWND_DESKTOP),False);
          WinSetOwner(HMen,WinQueryObjectWindow(HWND_DESKTOP));
     End;

     ulStyle:=WinQueryWindowULong(FHandle,QWL_STYLE);
     ulStyle:=ulStyle Or {MS_ROOT Or} MS_ACTIONBAR Or WS_CLIPSIBLINGS;
     ulStyle:=ulStyle And Not WS_SAVEBITS;
     WinSetWindowULong(FHandle,QWL_STYLE,ulStyle);
     WinSetWindowUShort(FHandle,QWS_ID,FID_MENU);

     WinSetParent(FHandle,TControl(FParent).Handle,False);
     WinSetOwner(FHandle,TControl(FParent).Handle);

     WinSendMsg(TControl(FParent).Handle,WM_UPDATEFRAME,FCF_MENU,0);
     {$ENDIF}

     {$IFDEF Win32}
     SetMenu(TControl(FParent).Handle,FHandle);
     {$ENDIF}
End;


//   Function GetColor(iPPid : LongWord) : tStr10;
//
//   Var NewColor : LongInt;
//
//   Begin
//     {$IFDEF OS2}
//     WinQueryPresParam(fHandle, iPPid, 0, Nil, 4, NewColor, QPF_NOINHERIT);
//     {$ENDIF}
//     {$IFDEF Win32}
//     NewColor:='0';
//     {$ENDIF}
//     Result:=toStr(NewColor)+';';
//   End;
//    ForeGroundColor := GetColor(PP_MENUFOREGROUNDCOLOR);
//    BackGroundColor := GetColor(PP_MENUBACKGROUNDCOLOR);
//    HiliteFgndColor := GetColor(PP_MENUHILITEFGNDCOLOR);
//    HiliteBgndColor := GetColor(PP_MENUHILITEBGNDCOLOR);
//    DisableFgndColor:= GetColor(PP_MENUDISABLEDFGNDCOLOR);
//    DisableBgndColor:= GetColor(PP_MENUDISABLEDBGNDCOLOR);
//  Function SetColor(iPPid : LongWord; iColor : tStr10) : Boolean;
//
//   Var NewColor : LongInt;
//
//   Begin
//     NewColor:=StrtoInt(iColor);
//   AColor := SysColorToRGB(clblue);
//     Result:=WinSetPresParam(fHandle,iPPid,4,NewColor);
//     WinSetPresParam(fHandle,iPPid,4,NewColor);
//   End;
//  SetColor(PP_MENUFOREGROUNDCOLOR, TagInfoList.Strings[2]);
//  SetColor(PP_MENUBACKGROUNDCOLOR, TagInfoList.Strings[3]);
//  SetColor(PP_MENUHILITEFGNDCOLOR, TagInfoList.Strings[4]);
//  SetColor(PP_MENUHILITEBGNDCOLOR, TagInfoList.Strings[5]);
//  SetColor(PP_MENUDISABLEDFGNDCOLOR, TagInfoList.Strings[6]);
//  SetColor(PP_MENUDISABLEDBGNDCOLOR, TagInfoList.Strings[7]);


end.

{ -- date -- -- from -- -- changes ----------------------------------------------
  26-Sep-02  WD         Ausbau der LINUX-Teile
  08-Aug-05  MV/AL      Definition of a Menu default font
  18-Jul-05  WD         Einbau des Property ForeGroundColor, BackGroundColor
  20-Jul-05  WD         Abspeichern div Infos (tMenu) in die Application-INI-Datei
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  11-Sep-06  HO         GetKeyRepeat: Check auf m.param2lobytehi (DBCS-Handling)
}


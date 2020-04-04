
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit DDEMan;

Interface

Uses Dos,Messages,SysUtils,Classes,Forms,
     uList,
     uString;

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin;
{$ENDIF}
{$IFDEF WIN32}
Uses WinNT,WinBase,WinUser,DDeml;
{$ENDIF}

Type
    TDdeServerConv=Class;
    TDdeServerItem=Class;
    TDdeClientConv=Class;
    TDdeClientItem=Class;

    {$M+}
    TDataMode=(ddeAutomatic, ddeManual);

    TExecuteMacro=Procedure(Sender:TObject;macro:TStrings;Var Success:Boolean) Of Object;
    {$M-}

    TDdeClientConv=Class(TComponent)
      Private
         FDdeService:PString;
         FDdeTopic:PString;
         FItems: TList;
         FConnectMode:TDataMode;
         FForm:TForm;
         FConnected:Boolean;
         FObjectWindow:TControl;
         FOperationComplete:Boolean;
         FData:Pointer;
         FDataLen:LongInt;
         FTimeOut:LongWord;
         FOnClose:TNotifyEvent;
         FOnOpen:TNotifyEvent;
         FOnTimeOut:TNotifyEvent;
         {$IFDEF WIN32}
         FDdeData:LongWord;
         FConv:LongWord;
         {$ENDIF}
         Function GetDdeService:String;Virtual;
         Procedure SetDdeService(Const Value:String);Virtual;
         Function GetDdeTopic:String;Virtual;
         Procedure SetDdeTopic(Const Value:String);Virtual;
         Procedure SetConnectMode(NewValue:TDataMode);Virtual;
         Procedure RemoveItem(Item:TDdeClientItem);Virtual;
         Procedure InsertItem(Item:TDdeClientItem);Virtual;
         Function GetItem(Index:LongInt):TDdeClientItem;Virtual;
         Function GetItemCount:LongInt;Virtual;
         Procedure WaitForServer;Virtual;
      Protected
         Procedure SetupComponent;Override;
         Function CreateDdeConv(Const AppName,TopicName:String):Boolean;Virtual;
      Public
         Destructor Destroy;Override;
         Function PasteLink:Boolean;Virtual;
         Function OpenLink:Boolean;Virtual;
         Function SetLink(Const Service,topic:String):Boolean;Virtual;
         Procedure CloseLink;Virtual;
         Function StartAdvise(Item:String):Boolean;Virtual;
         Function StopAdvise(Item:String):Boolean;Virtual;
         Function PokeDataLines(Const Item:String;Data:TStrings):Boolean;Virtual;
         Function PokeData(Const Item:String;Data:PChar):Boolean;Virtual;
         Function ExecuteMacro(cmd: PChar;waitFlg:Boolean):Boolean;Virtual;
         Function ExecuteMacroLines(cmd:TStrings;waitFlg:Boolean):Boolean;Virtual;
         Function RequestData(Const Item:String):PChar;Virtual;
      Public
         Property ItemCount:LongInt Read GetItemCount;
         Property Items[Index:LongInt]:TDdeClientItem Read GetItem;
         Property Form:TForm Read FForm;
         Property Connected:Boolean Read FConnected;
      Published
         Property DdeService:String Read GetDdeService Write SetDdeService;
         Property DdeTopic:String Read GetDdeTopic Write SetDdeTopic;
         Property ConnectMode:TDataMode Read FConnectMode Write SetConnectMode;
         Property TimeOut:LongWord Read FTimeOut Write FTimeOut;
         Property OnClose:TNotifyEvent Read FOnClose Write FOnClose;
         Property OnOpen:TNotifyEvent Read FOnOpen Write FOnOpen;
         Property OnTimeOut:TNotifyEvent Read FOnTimeOut Write FOnTimeOut;
    End;

    TDdeClientItem=Class(TComponent)
      Private
         FLines: TStrings;
         FDdeClientItem:^String;
         FForm:TForm;
         FClientConv:TDdeClientConv;
         FOnChange: TNotifyEvent;
         {$IFDEF WIN32}
         FDdeData:LongWord;
         FConv:LongWord;
         {$ENDIF}
         Function GetText:String;Virtual;
         Function GetDdeClientItem:String;Virtual;
         Procedure SetDdeClientItem(Const NewValue:String);Virtual;
         Procedure SetDdeClientConv(SConv:TDdeClientConv);Virtual;
         Procedure SetText(Const Item:String);Virtual;
         Procedure SetLines(Value:TStrings);Virtual;
         Procedure ValueChanged;Virtual;
         Procedure OnAdvise(Text:PChar);Virtual;
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
      Public
         Destructor Destroy;Override;
         Function Advise:Boolean;Virtual;
         Function Unadvise:Boolean;Virtual;
         Function Request:Boolean;Virtual;
         Function Poke:Boolean;Virtual;
         Property Form:TForm Read FForm;
      Published
         Property Text:String Read GetText Write SetText;
         Property Lines: TStrings Read FLines Write SetLines;
         Property DdeConv: TDdeClientConv Read FClientConv Write SetDdeClientConV;
         Property DdeItem:String Read GetDdeClientItem Write SetDdeClientItem;
         Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
    End;

    TDdeServerConv=Class(TComponent)
      Private
         FItems:TList;
         FForm:TForm;
         FOnExecuteMacro:TExecuteMacro;
         FOnOpen:TNotifyEvent;
         FOnClose:TNotifyEvent;
         FDdeTopic:PString;
         {$IFDEF WIN32}
         FDdeData:LongWord;
         FConv:LongWord;
         {$ENDIF}
         Procedure InsertItem(Item:TDdeServerItem);Virtual;
         Procedure RemoveItem(Item:TDdeServerItem);Virtual;
         Function GetItemCount:LongInt;Virtual;
         Function GetItem(Index:LongInt):TDdeServerItem;Virtual;
         Function GetDdeTopic:String;Virtual;
         Procedure SetDdeTopic(NewValue:String);Virtual;
      Protected
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         Procedure ExecuteMacro(macro:TStrings;Var Success:Boolean);Virtual;
         Procedure Connect;Virtual;
         Procedure Disconnect;Virtual;
         Property ItemCount:LongInt Read GetItemCount;
         Property Items[Index:LongInt]:TDdeServerItem Read GetItem;
         Property Form:TForm Read FForm;
      Published
         Property OnExecuteMacro:TExecuteMacro Read FOnExecuteMacro Write FOnExeCuTeMAcro;
         Property OnOpen:TNotifyEvent Read FOnOpen Write FOnOpen;
         Property OnClose:TNotifyEvent Read FOnClose Write FOnClose;
         Property DdeTopic:String Read GetDdeTopic Write SetDdeTopic;
    End;

    TDdeServerItem=Class(TComponent)
      Private
         FLines:TStrings;
         FItem:^String;
         FForm:TForm;
         FServerConv:TDdeServerConv;
         FAdviseMode:LongInt;
         FAdviseModeSend:Boolean;
         FOnChange:TNotifyEvent;
         FOnPokeData:TNotifyEvent;
         {$IFDEF WIN32}
         FDdeData:LongWord;
         FConv:LongWord;
         {$ENDIF}
         Procedure ValueChanged;Virtual;
         Function GetItem:String;Virtual;
         Procedure SetItem(NewValue:String);Virtual;
         Function GetText:String;Virtual;
         Procedure SetText(Const Item:String);Virtual;
         Procedure SetLines(Value:TStrings);Virtual;
         Procedure SetServerConv(SConv:TDdeServerConv);Virtual;
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
      Public
         Destructor Destroy;Override;
         Procedure Change;Virtual;
         Property Form:TForm Read FForm;
      Published
         Property ServerConv:TDdeServerConv Read FServerConv Write SetServerConv;
         Property DdeItem:String Read GetItem Write SetItem;
         Property Text:String Read GetText Write SetText;
         Property Lines:TStrings Read FLines Write SetLines;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnPokeData:TNotifyEvent Read FOnPokeData Write FOnPokeData;
    End;

    TDdeMgr=Class(TComponent)
      Private
         FAppName:PString;
         FClientConvs:TList;
         FServerConvs:TList;
         FServerItems:TList;
         OWindows:TList;
         FClients:TList;
         {$IFDEF WIN32}
         FDdeInstId:LongInt;
         FHszApp:LongWord;
         {$ENDIF}
         Procedure PostDataChange(Const topic,Item:String);Virtual;
         Procedure SetAppName(Const Name:String);Virtual;
         Function GetAppName:String;Virtual;
         Procedure ResetAppName;Virtual;
         Function GetForm(Const topic:String):TForm;Virtual;
         Function GetServerItem(Const topic:String;Form:TForm;
                                Var Conv:TDdeServerConv):TDdeServerItem;Virtual;
         Function HasDDEServers(Form:TForm):Boolean;Virtual;
         Procedure InsertServerConv(SConv: TDdeServerConv);Virtual;
         Procedure RemoveServerConv(SConv: TDdeServerConv);Virtual;
         Procedure InsertServerItem(Item:TDdeServerItem);Virtual;
         Procedure RemoveServerItem(Item:TDdeServerItem);Virtual;
         Procedure GetTopics(Topics:TStrings;Form:TForm);Virtual;
         Procedure AddObjectWindow(OWindow:TControl);Virtual;
         Procedure RemoveObjectWindow(OWindow:TControl);Virtual;
         Function GetActiveDdeConnections:LongInt;Virtual;
         Procedure AddClient(client:TDdeClientConv);Virtual;
         Procedure RemoveClient(client:TDdeClientConv);Virtual;
         Procedure OpenClientLinks(Form:TForm);Virtual;
         Procedure CloseClientLinks(Form:TForm);Virtual;
         Procedure CloseAllLinks;Virtual;
      Protected
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         Function GetExeName:String;Virtual;
         {$IFDEF WIN32}
         Property DdeInstId:LongInt Read FDdeInstId Write FDdeInstId;
         {$ENDIF}
         Property AppName:String Read GetAppName Write SetAppName;
         Property ActiveDdeConnections:LongInt Read GetActiveDdeConnections;
    End;

Var
  DDEMgr: TDdeMgr;


Implementation

Uses uSysInfo;

{$IFDEF WIN32}
Function GetControl(ddeSrv:TDdeServerConv;Form:TControl;Const ItemName:string):TDdeServerItem;
Var
  t:LongInt;
  Ctrl:TComponent;
Begin
    Result:=Nil;
    If Form=Nil Then
    Begin
         If ddeSrv.Owner Then
          If ddeSrv.Owner is TForm Then Form:=TControl(ddeSrv.Owner);
         If Form=Nil Then exit;
    End;

    For t:=0 To Form.ComponentCount-1 Do
    Begin
         Ctrl:=Form.Components[t];
         If Ctrl Is TDdeServerItem Then
         Begin
             If ((Ctrl.Name=ItemName)Or(TDdeServerItem(Ctrl).DdeItem=ItemName)) Then
              If TDdeServerItem(Ctrl).FServerConv=ddeSrv Then
             Begin
                  Result := TDdeServerItem(Ctrl);
                  Exit;
             End;
         End;
         If Ctrl Is TControl Then
         Begin
              Result:=GetControl(ddeSrv,TControl(Ctrl),ItemName);
              if Result<>Nil Then exit;
         End;
    End; //for
End;


Function PokeData(ddeSrv:TDdeServerConv;Conv:HConv;hszTopic:HSZ;hszItem:HSZ;
                  Data:HDdeData;Fmt:Integer):LongInt;
Var
  Srvr:TDdeServerItem;
  Buffer:CString[4096];
  Len:LongWord;
  pData:Pointer;
Begin
     Result := dde_FNotProcessed;
     If Fmt <> CF_TEXT Then Exit;
     Len:=DdeQueryString(ddeMgr.FDdeInstId,hszItem,Buffer,SizeOf(Buffer),CP_WINANSI);
     Buffer[Len]:=#0;
     Srvr:=GetControl(ddeSrv,ddeSrv.FForm,Buffer);
     If Srvr<>Nil Then
     Begin
          pData:=DdeAccessData(Data,Len);
          If pData<>Nil Then
          Begin
              Srvr.Lines.SetText(PChar(pData));
              DdeUnaccessData(Data);
              Srvr.ValueChanged;
              if Assigned(Srvr.FOnPokeData) then Srvr.FOnPokeData(Srvr);
              Result := dde_FAck;
          End;
     End;
End;

Function RequestData(ddeSrv:TDdeServerConv;Conv:HConv;hszTopic:HSZ;hszItem :HSZ;
                     Fmt:Word):HDdeData;
Var
  Data: AnsiString;
  Buffer:CString[4096];
  Srvr:TDdeServerItem;
  Len:LongInt;
begin
    Result:=0;
    If Fmt <> CF_TEXT Then Exit;

    Len:=DdeQueryString(ddeMgr.FDdeInstId,hszItem,Buffer,SizeOf(Buffer),CP_WINANSI);
    Buffer[Len]:=#0;
    Srvr:=GetControl(ddeSrv,ddeSrv.FForm,Buffer);
    If Srvr<>Nil Then
    Begin
        Data := Srvr.Lines.Text;
        Result := DdeCreateDataHandle(DdeMgr.FDdeInstId,PChar(Data),
                                      Length(Data)+1,0,hszItem,Fmt,0);
    End;
End;

Function ExecuteMacro(ddeSrv:TDdeServerConv;Conv:HConv;hszTopic:HSZ;Data:HDdeData):LongInt;
var
  Len:LongWord;
  pData:Pointer;
  MacroLines:TStringList;
  Success:Boolean;
begin
  Result := dde_FNotProcessed;
  pData:=DdeAccessData(Data,Len);
  If pData<>Nil Then
  Begin
    If Assigned(ddeSrv.FOnExecuteMacro) Then
    Begin
      MacroLines := TStringList.Create;
      MacroLines.SetText(PChar(pData));
      ddeSrv.FOnExecuteMacro(ddeSrv,MacroLines,Success);
      MacroLines.Destroy;
    End;
    Result := dde_FAck;
  End;
End;

Function DdeMgrCallBack(CallType,Fmt:LongWord;Conv:HConv; hsz1, hsz2: HSZ;
                        Data:HDDEData;Data1,Data2:LongWord):HDDEData;ApiEntry;
Var
  ci: TConvInfo;
  ddeCli: TComponent;
  ddeSrv: TDdeServerConv;
  ddeObj: TComponent;
  xID: Integer;
  Form:TForm;
  Len:LongInt;
  Topic:CString;
  conns:Array[0..1] Of THSZPair;
Begin
  Result := 0;

  Case CallType of
       XTYP_CONNECT,XTYP_WILDCONNECT:
       Begin
            If ((hsz2=0)Or(DdeCmpStringHandles(hsz2,DdeMgr.FHszApp)=0)) Then
            Begin
                 Len:=DdeQueryString(DdeMgr.FDdeInstId,hsz1,Topic,255,CP_WINANSI);
                 Topic[Len]:=#0;
                 DdeMgr.GetServerItem(Topic,Nil,ddeSrv);
                 If ddeSrv<>Nil Then Result:=1
                 Else
                 Begin
                      Form:=DdeMgr.GetForm(Topic);
                      If Form<>Nil Then Result:=1;
                 End;
            End;

            If CallType=XTYP_WILDCONNECT Then
             If Result=1 Then
               If hsz2<>0 Then
            Begin
                 conns[0].hszSvc:=DdeMgr.FHszApp;
                 conns[0].hszTopic:=hsz2;
                 conns[1].hszSvc:=0;
                 conns[1].hszTopic:=0;
                 Result:=DdeCreateDataHandle(DdeMgr.FDdeInstId,conns,
                                             2*sizeof(THSZPair),0,0,CF_TEXT,0);
            End;
       End;
       XTYP_CONNECT_CONFIRM:
       Begin
            Len:=DdeQueryString(DdeMgr.FDdeInstId,hsz1,Topic,255,CP_WINANSI);
            Topic[Len]:=#0;
            DdeMgr.GetServerItem(Topic,Nil,ddeSrv);
            If ddeSrv<>Nil Then
            Begin
                 DdeSetUserHandle(Conv,QID_SYNC,LongWord(ddeSrv));
                 ddeSrv.Connect;
            End
            Else
            Begin
                 //eventuell ein Zwischenobjekt generieren, für ddeSrv=Nil und Form<>Nil
                 Form:=DdeMgr.GetForm(Topic);
            End;
       End;
  End;

  If Conv <> 0 Then
  Begin
       ci.cb := sizeof(TConvInfo);
       If CallType=XTYP_XACT_COMPLETE Then xID:=Data1
       Else xID := QID_SYNC;

       If DdeQueryConvInfo(Conv,xID,@ci)=0 Then Exit;
       Case CallType Of
            XTYP_ADVREQ,XTYP_REQUEST:
            Begin
                ddeSrv:=TDdeServerConv(ci.hUser);
                Result:=RequestData(ddeSrv,Conv,hsz1,hsz2,Fmt);
            End;
            XTYP_ADVSTOP:
            Begin
                ddeSrv:=TDdeServerConv(ci.hUser);
                //AdvStop(ddeSrv,Conv,hsz1,hsz2);
            End;
            XTYP_ADVSTART:
            Begin
                ddeSrv:=TDdeServerConv(ci.hUser);
                //Result:=AdvStart(ddeSrv,Conv,hsz1,hsz2,Fmt);
            End;
            XTYP_POKE:
            Begin
                ddeSrv:=TDdeServerConv(ci.hUser);
                Result:=PokeData(ddeSrv,Conv,hsz1,hsz2,Data,Fmt);
            End;
            XTYP_EXECUTE:
            Begin
                ddeSrv:=TDdeServerConv(ci.hUser);
                Result:=ExecuteMacro(ddeSrv,Conv,hsz1,Data);
            End;
            XTYP_XACT_COMPLETE:
            Begin
                ddeCli:=TComponent(ci.hUser);
                //If ddeCli<>Nil Then TDdeClientConv(ddeCli).XactComplete
            End;
            XTYP_ADVDATA:
            Begin
                ddeCli:=TComponent(ci.hUser);
                //DataChange(TDdeClientConv(ddeCli),Data,hsz2);
            End;
            XTYP_DISCONNECT:
            Begin
                ddeObj:=TComponent(ci.hUser);
                If ddeObj<>Nil Then
                Begin
                     If ddeObj Is TDdeClientConv Then TDdeClientConv(ddeObj).CloseLink
                     Else If ddeObj Is TDdeServerConv Then TDdeServerConv(ddeObj).Disconnect;
                     DdeSetUserHandle(Conv,QID_SYNC,0);
                End;
            End;
       End;
  End;
End;
{$ENDIF}

{$IFDEF OS2}
Function AllocDdeStruc(Receiver:HWND;Const ItemName:String;
                        Status,format:LongWord;Data:Pointer;DataLen:LongWord):PDDESTRUCT;
Var ddelen:LongWord;
    apid:PID;
    atid:TID;
    C:Cstring;
    P:Pointer;
Begin
     ddelen:=SizeOf(DDESTRUCT)+Length(ItemName)+1+DataLen;
     DosAllocSharedMem(Result,Nil,ddelen,PAG_COMMIT Or PAG_READ Or PAG_WRITE Or OBJ_GIVEABLE);
     WinQueryWindowProcess (Receiver,apid,atid);
     DosGiveSharedMem (Result,apid,PAG_READ Or PAG_WRITE);
     Result^.cbData:=ddelen;
     Result^.fsStatus:=Status;
     Result^.usFormat:=format;
     Result^.offszItemName:=SizeOf(DDESTRUCT);
     If DataLen>0 Then Result^.offabData:=SizeOf(DDESTRUCT)+Length(ItemName)+1
     Else Result^.offabData:=0;
     C:=ItemName;
     P:=Pointer(Result);
     Inc(P,SizeOf(DDESTRUCT));
     Move(C,P^,Length(ItemName)+1);
     Inc(P,Length(ItemName)+1);
     If DataLen>0 Then Move(Data^,P^,DataLen);
End;


Type
    TDdeObjectWindow=Class(TControl)
        FDdeClient:HWND;
        FDdeServer:HWND;
        FDdeForm:HWND;
        FDdeTopic:String;
        FServerItem:TDdeServerItem;
        FServerConv:TDdeServerConv;
        FClientConv:TDdeClientConv;
        FClientItem:TDdeClientItem;

        Procedure CreateWnd;Override;
        Procedure WMDDERequest(Var Msg:TMessage); Message WM_DDE_REQUEST;
        Procedure WMDDETerminate(Var Msg:TMessage); Message WM_DDE_TERMINATE;
        Procedure WMDDEExecute(Var Msg:TMessage); Message WM_DDE_EXECUTE;
        Procedure WMDDEInitiateAck(Var Msg:TMessage); Message WM_DDE_INITIATEACK;
        Procedure WMDDEData(Var Msg:TMessage); Message WM_DDE_DATA;
        Procedure WMDDEAck(Var Msg:TMessage); Message WM_DDE_ACK;
        Procedure WMDDEPoke(Var Msg:TMessage); Message WM_DDE_POKE;
        Procedure WMDDEAdvise(Var Msg:TMessage); Message WM_DDE_ADVISE;
        Procedure WMDDEUnadvise(Var Msg:TMessage); Message WM_DDE_UNADVISE;
        Destructor Destroy;Override;
     End;

//Server receives Advise Of Items
Procedure TDdeObjectWindow.WMDDEAdvise(Var Msg:TMessage);
Var Data,RetData:PDDESTRUCT;
    S:String;
    ItemName:PChar;
    Flags:LongWord;
    ServerItem:TDdeServerItem;
    T:LongInt;
Label Fail,found;
Begin
     Flags:=DDE_FAPPSTATUS;

     If Msg.Param2=0 Then  //no Data
     Begin
          Msg.Handled:=True;
          Msg.Result:=0;
          Exit;
     End;

     Data:=Pointer(Msg.Param2);
     ItemName:=Pointer(Data);
     Inc(ItemName,Data^.offszItemName);

     //look If we support the Item
     S:=ItemName^;

     //are we busy ??
     If FDdeClient<>Msg.Param1 Then Goto Fail;

     ServerItem:=FServerItem;

     If ServerItem<>Nil Then
     Begin
found:
          Inc(ServerItem.FAdviseMode);
          ServerItem.FAdviseModeSend:=Data^.fsStatus And DDE_FACKREQ<>0;
          RetData:=AllocDdeStruc(Msg.Param1,S,DDE_FACK,DDEFMT_TEXT,Nil,0);
     End
     Else If FServerConv<>Nil Then
     Begin
          //we directly Use A Server
          //look If there Is A Server Item In the Server List which has the Item Set
          For T:=0 To FServerConv.ItemCount-1 Do
          Begin
               ServerItem:=FServerConv.Items[T];
               If ServerItem.DdeItem=S Then Goto found;
          End;

          Goto Fail;  //Not found !
     End
     Else //failed !
     Begin
Fail:
          RetData:=AllocDdeStruc(Msg.Param1,S,DDE_FAPPSTATUS,DDEFMT_TEXT,Nil,0);
     End;

     WinDdePostMsg(Msg.Param1,Handle,WM_DDE_ACK,RetData^,DDEPM_RETRY);

     If Data<>Nil Then DosFreeMem(Data);
     Msg.Result:=0;
     Msg.Handled:=True;
End;

//Server receives Unadvise Of Items
Procedure TDdeObjectWindow.WMDDEUnadvise(Var Msg:TMessage);
Var Data,RetData:PDDESTRUCT;
    S:String;
    ItemName:PChar;
    Flags:LongWord;
    ServerItem:TDdeServerItem;
    T:LongInt;
Label Fail,found;
Begin
     Flags:=DDE_FAPPSTATUS;

     If Msg.Param2=0 Then  //no Data
     Begin
          Msg.Handled:=True;
          Msg.Result:=0;
          Exit;
     End;

     Data:=Pointer(Msg.Param2);
     ItemName:=Pointer(Data);
     Inc(ItemName,Data^.offszItemName);

     //look If we support the Item
     S:=ItemName^;
     //are we busy ??
     If FDdeClient<>Msg.Param1 Then Goto Fail;

     ServerItem:=FServerItem;

     If ((ServerItem<>Nil)And(ServerItem.FAdviseMode>0)) Then
     Begin
found:
          Dec(ServerItem.FAdviseMode);
          RetData:=AllocDdeStruc(Msg.Param1,S,DDE_FACK,DDEFMT_TEXT,Nil,0);
     End
     Else If FServerConv<>Nil Then
     Begin
          //we directly Use A Server
          //look If there Is A Server Item In the Server List which has the Item Set
          For T:=0 To FServerConv.ItemCount-1 Do
          Begin
               ServerItem:=FServerConv.Items[T];
               If ServerItem.DdeItem=S Then
                 If ServerItem.FAdviseMode>0 Then Goto found;
          End;

          Goto Fail;  //Not found !
     End
     Else //failed !
     Begin
Fail:
          RetData:=AllocDdeStruc(Msg.Param1,S,DDE_FAPPSTATUS,DDEFMT_TEXT,Nil,0);
     End;

     WinDdePostMsg(Msg.Param1,Handle,WM_DDE_ACK,RetData^,DDEPM_RETRY);

     If Data<>Nil Then DosFreeMem(Data);
     Msg.Result:=0;
     Msg.Handled:=True;
End;

//Server receives Data To be poked from client
Procedure TDdeObjectWindow.WMDDEPoke(Var Msg:TMessage);
Var Data,RetData:PDDESTRUCT;
    S:String;
    ItemName:PChar;
    Flags:LongWord;
    D:Pointer;
    ServerItem:TDdeServerItem;
    T:LongInt;
Label Fail,found;
Begin
     Flags:=DDE_FAPPSTATUS;

     If Msg.Param2=0 Then  //no Data
     Begin
          Msg.Handled:=True;
          Msg.Result:=0;
          Exit;
     End;

     Data:=Pointer(Msg.Param2);
     ItemName:=Pointer(Data);
     Inc(ItemName,Data^.offszItemName);
     D:=Pointer(Data);
     Inc(D,Data^.offabData);

     //look If we support the Item
     S:=ItemName^;
     //are we busy ??
     If ((FDdeClient<>Msg.Param1)Or(Data^.usFormat<>DDEFMT_TEXT)) Then Goto Fail;

     ServerItem:=FServerItem;

     If ServerItem<>Nil Then
     Begin
found:
          ServerItem.Lines.SetText(D);
          If ServerItem.OnPokeData<>Nil Then ServerItem.OnPokeData(ServerItem);
          ServerItem.Change;
          RetData:=AllocDdeStruc(Msg.Param1,S,DDE_FACK,DDEFMT_TEXT,Nil,0);
     End
     Else If FServerConv<>Nil Then
     Begin
          //we directly Use A Server
          //look If there Is A Server Item In the Server List which has the Item Set
          For T:=0 To FServerConv.ItemCount-1 Do
          Begin
               ServerItem:=FServerConv.Items[T];
               If ServerItem.DdeItem=S Then Goto found;
          End;

          Goto Fail;  //Not found !
     End
     Else //failed !
     Begin
Fail:
          RetData:=AllocDdeStruc(Msg.Param1,S,DDE_FAPPSTATUS,DDEFMT_TEXT,Nil,0);
     End;

     WinDdePostMsg(Msg.Param1,Handle,WM_DDE_ACK,RetData^,DDEPM_RETRY);

     If Data<>Nil Then DosFreeMem(Data);
     Msg.Result:=0;
     Msg.Handled:=True;
End;

//Server Or client acknowledges Data
Procedure TDdeObjectWindow.WMDDEAck(Var Msg:TMessage);
Var Data:PDDESTRUCT;
Begin
     Data:=Pointer(Msg.Param2);

     If FClientConv<>Nil Then
     Begin
          FClientConv.FData:=Nil;
          FClientConv.FDataLen:=0;
          FClientConv.FOperationComplete:=True;
     End;

     If Data<>Nil Then DosFreeMem(Data);
     Msg.Result:=0;
     Msg.Handled:=True;
End;

//A Server sends Data ON clients Request
Procedure TDdeObjectWindow.WMDDEData(Var Msg:TMessage);
Var Data,RetData:PDDESTRUCT;
    S:String;
    ItemName:PChar;
    Flags:LongWord;
    D:Pointer;
    ClientItem:TDdeClientItem;
    T:LongInt;
Begin
     Flags:=DDE_FAPPSTATUS;

     If Msg.Param2=0 Then  //no Data
     Begin
          Msg.Handled:=True;
          Msg.Result:=0;
          If FClientConv<>Nil Then
          Begin
               FClientConv.FData:=Nil;
               FClientConv.FDataLen:=0;
               FClientConv.FOperationComplete:=True;
          End;
          Exit;
     End;

     Data:=Pointer(Msg.Param2);
     ItemName:=Pointer(Data);
     Inc(ItemName,Data^.offszItemName);
     D:=Pointer(Data);
     Inc(D,Data^.offabData);
     If FClientConv<>Nil Then
     Begin

          FClientConv.FOperationComplete:=True;
          FClientConv.FData:=Nil;
          FClientConv.FDataLen:=0;
          Flags:=DDE_FACK;

          If Data^.fsStatus And DDE_FRESPONSE=0 Then //answer from Advise
          Begin
               If FClientConv.FItems<>Nil Then
                 For T:=0 To FClientConv.FItems.Count-1 Do
                 Begin
                      ClientItem:=FClientConv.FItems[T];
                      If ClientItem.DdeItem=ItemName^ Then ClientItem.OnAdvise(D);
                 End;
          End
          Else
          Begin
               If Data^.cbData=0 Then
               Begin
                    FClientConv.FData:=Nil;
                    FClientConv.FDataLen:=0;
               End
               Else
               Begin
                    GetMem(FClientConv.FData,Data^.cbData);
                    System.Move(D^,FClientConv.FData^,Data^.cbData);
                    FClientConv.FDataLen:=Data^.cbData;
               End;
          End;
     End;

     If Data^.fsStatus And DDE_FACKREQ<>0 Then
     Begin
          S:=ItemName^;
          RetData:=AllocDdeStruc(Msg.Param1,S,Flags,DDEFMT_TEXT,Nil,0);
          WinDdePostMsg(Msg.Param1,Handle,WM_DDE_ACK,RetData^,DDEPM_RETRY);
     End;

     If Data<>Nil Then DosFreeMem(Data);
     Msg.Result:=0;
     Msg.Handled:=True;
End;

//A Server acknowledges the Connect Request Of A client
Procedure TDdeObjectWindow.WMDDEInitiateAck(Var Msg:TMessage);
Var Data:PDDEINIT;
Label Fail;
Begin
     If Msg.Param2=0 Then //no Data
     Begin
          Msg.Handled:=True;
          Msg.Result:=0;
          If FClientConv<>Nil Then
          Begin
               FClientConv.FData:=Nil;
               FClientConv.FDataLen:=0;
               FClientConv.FOperationComplete:=True;
          End;
          Exit;
     End;

     Data:=Pointer(Msg.Param2);

     If ((FClientConv<>Nil)And(Not FClientConv.connected)And(FClientConv.DdeService=Data^.pszAppNAme^)And
         (FDdeTopic=Data^.pszTopic^)) Then
     Begin
          //acknowleded !!
          FClientConv.FConnected:=True;
          FDdeServer:=Msg.Param1;
          FClientConv.FData:=Nil;
          FClientConv.FDataLen:=0;
          FClientConv.FOperationComplete:=True;
     End
     Else
     Begin
Fail:
          WinDdePostMsg (Msg.Param1,Handle,WM_DDE_TERMINATE,Nil,DDEPM_RETRY) ;
          If FClientConv<>Nil Then
          Begin
               FClientConv.FData:=Nil;
               FClientConv.FDataLen:=0;
               FClientConv.FOperationComplete:=True;
          End;
     End;

     If Data<>Nil Then DosFreeMem(Data);
     Msg.Result:=0;
     Msg.Handled:=True;
End;

//A Server Or A client terminates conversation
Procedure TDdeObjectWindow.WMDDETerminate(Var Msg:TMessage);
Begin
     If Msg.Param1<>Handle Then //don't Terminate ourself !
     Begin
          WinDdePostMsg (Msg.Param1,Handle,WM_DDE_TERMINATE,Nil,DDEPM_RETRY) ;
          WinPostMsg(FDdeForm,WM_DDE_DESTROY,LongWord(Self),0);
     End;

     If FClientConv<>Nil Then
     Begin
          FClientConv.FData:=Nil;
          FClientConv.FDataLen:=0;
          FClientConv.FOperationComplete:=True;
     End;

     FDdeClient:=0;
     FDdeServer:=0;
     FDdeForm:=0;
     FServerItem:=Nil;
     FServerConv:=Nil;
     FClientItem:=Nil;
     Msg.Handled:=True;
     Msg.Result:=0;
End;

Destructor TDdeObjectWindow.Destroy;
Begin
     If FClientConv<>Nil Then
     Begin
          FClientConv.FData:=Nil;
          FClientConv.FDataLen:=0;
          FClientConv.FObjectWindow:=Nil;
          FClientConv.FOperationComplete:=True;
          FClientConv.FConnected:=False;
          If FClientConv.FOnClose<>Nil Then FClientConv.FOnClose(Self);
     End
     Else DDEMgr.RemoveObjectWindow(Self);

     Inherited Destroy;
End;

//A client requests Info from A Server
Procedure TDdeObjectWindow.WMDDERequest(Var Msg:TMessage);
Var Data,ReturnData:PDDESTRUCT;
    ItemName:PChar;
    S:String;
    P:PChar;
    len:LongInt;
    T:LongInt;
    FLastSender:HWND;
    FLastTopic:String;
    ServerItem:TDdeServerItem;
Label Fail,found;
Begin
     S:='';

     FLastTopic:=FDdeTopic;
     FLastSender:=FDdeClient;

     Data:=Pointer(Msg.Param2);
     If Data=Nil Then
     Begin
          Msg.Handled:=True;
          Msg.Result:=0;
          Exit;
     End;

     ItemName:=Pointer(Data);
     Inc(ItemName,Data^.offszItemName);

     //look If we support the Item
     S:=ItemName^;
     //are we busy ??
     If FLastSender<>Msg.Param1 Then Goto Fail;

     ServerItem:=FServerItem;

     If ServerItem<>Nil Then
     Begin
found:
          P:=ServerItem.Lines.GetText;
          If P<>Nil Then len:=Length(P^)+1
          Else len:=0;
          ReturnData:=AllocDdeStruc(Msg.Param1,S,DDE_FRESPONSE,DDEFMT_TEXT,P,len);
          StrDispose(P);
     End
     Else If FServerConv<>Nil Then
     Begin
          //we directly Use A Server
          //look If there Is A Server Item In the Server List which has the Item Set
          For T:=0 To FServerConv.ItemCount-1 Do
          Begin
               ServerItem:=FServerConv.Items[T];
               If ServerItem.DdeItem=S Then Goto found;
          End;

          Goto Fail;  //Not found !
     End
     Else //failed !
     Begin
Fail:
          ReturnData:=AllocDdeStruc(Msg.Param1,S,DDE_NOTPROCESSED,DDEFMT_TEXT,Nil,0);
     End;

     WinDdePostMsg(Msg.Param1,Handle,WM_DDE_DATA,ReturnData^,DDEPM_RETRY);

     If Data<>Nil Then DosFreeMem(Data);
     Msg.Result:=0;
     Msg.Handled:=True;
End;

//A client wants To Execute A macro At the Server
Procedure TDdeObjectWindow.WMDDEExecute(Var Msg:TMessage);
Var Data,ReturnData:PDDESTRUCT;
    ItemName:PChar;
    S:String;
    ServerConv:TDdeServerConv;
    Success:Boolean;
    Strings:TStringList;
    cmd:PChar;
    FLastSender:HWND;
    FLastTopic:String;
Label Fail;
Begin
     Data:=Pointer(Msg.Param2);
     If Data=Nil Then
     Begin
          Msg.Handled:=True;
          Msg.Result:=0;
          Exit;
     End;

     FLastTopic:=FDdeTopic;
     FLastSender:=FDdeClient;

     ItemName:=Pointer(Data);
     Inc(ItemName,Data^.offszItemName);

     //look If we support the Item
     S:=ItemName^;
     //are we busy ??
     If ((FLastSender<>Msg.Param1)Or(Data^.usFormat<>DDEFMT_TEXT)) Then Goto FaiL;

     ServerConv:=FServerConv;

     If ServerConv<>Nil Then
     Begin
          Strings.Create;
          If Data^.cbData<>0 Then
          Begin
               cmd:=Pointer(Data);
               Inc(cmd,Data^.offabData);
               Strings.SetText(cmd);
          End;
          Success:=False;
          ServerConv.ExecuteMacro(Strings,Success);
          Strings.Destroy;
          If Not Success Then Goto Fail;
          ReturnData:=AllocDdeStruc(Msg.Param1,'',DDE_FACK,DDEFMT_TEXT,Nil,0);
     End
     Else
     Begin
Fail:
          ReturnData:=AllocDdeStruc(Msg.Param1,'',DDE_FAPPSTATUS,DDEFMT_TEXT,Nil,0);
     End;
     WinDdePostMsg(Msg.Param1,Handle,WM_DDE_ACK,ReturnData^,DDEPM_RETRY);
     If Data<>Nil Then DosFreeMem(Data);
     Msg.Result:=0;
     Msg.Handled:=True;
End;

Procedure TDdeObjectWindow.CreateWnd;
Var ClassData:TClassData;
    FHandle:HWND;
Begin
     GetClassData(ClassData);
     FHandle:=WinCreateWindow(HWND_OBJECT,           //Parent
                              ClassData.ClassName,
                              '',                    //Caption
                              WS_DISABLED,           //flStyle
                              0,0,
                              0,0,                   //Position And Size
                              HWND_OBJECT,           //Owner
                              HWND_BOTTOM,           //Insert behind
                              WindowId,
                              Nil,                   //CtlData
                              Nil);                  //Presparams

     SetControlHandle(Self,FHandle);
     If FHandle=0 Then CreateError;

     WinSetWindowULong(FHandle,QWL_USER,LongWord(Self));    {VMT Pointer}
     SetDefWndProc(Self,Pointer(WinSubClassWindow(FHandle,@SubclassedWndProc)));
End;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDdeMgr Class Implementation                                บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TDdeMgr.PostDataChange(Const topic,Item:String);

{$IFDEF OS2}
Var T:LongInt;
    OWindow:TDdeObjectWindow;
    P:PChar;
    len:LongWord;
    ServerItem:TDdeServerItem;
    ReturnData:PDDESTRUCT;
{$ENDIF}

Begin
     {$IFDEF OS2}
     If OWindows<>Nil Then For T:=0 To OWindows.Count-1 Do
     Begin
          OWindow:=OWindows[T];
          If OWindow.FDdeTopic=topic Then If OWindow.FDdeClient<>0 Then
            If ((OWindow.FServerConv<>Nil)Or(OWindow.FServerItem<>Nil)) Then
          Begin
               ServerItem:=Nil;
               If OWindow.FServerItem<>Nil Then ServerItem:=OWindow.FServerItem
               Else
               Begin
                    For T:=0 To OWindow.FServerConv.ItemCount-1 Do
                    Begin
                         ServerItem:=OWindow.FServerConv.Items[T];
                         If ServerItem.DdeItem=Item Then break;
                    End;
               End;

               If ((ServerItem<>Nil)And(ServerItem.FAdviseMode>0)And(ServerItem.DdeITem=Item)) Then
               Begin
                    {$IFDEF OS2}
                    If ServerItem.FAdviseModeSend Then
                    Begin
                         P:=ServerItem.Lines.GetText;

                         If P<>Nil Then len:=Length(P^)+1
                         Else len:=0;
                         ReturnData:=AllocDdeStruc(OWindow.FDdeClient,Item,DDE_FAcKREq,
                                                   DDEFMT_TEXT,P,len);
                         StrDispose(P);
                    End
                    Else
                    Begin
                         ReturnData:=AllocDdeStruc(OWindow.FDdeClient,Item,DDE_NOtPROcESSED,DDEFmt_TEXT,
                                                   Nil,0)
                    End;
                    WinDdePostMsg(OWindow.FDdeClient,OWindow.Handle,WM_DDE_DATA,RetuRnData^,DDEPm_RETRY);
                    {$ENDIF}
               End;
          End;
     End;
     {$ENDIF}
End;

Procedure TDdeMgr.SetAppName(Const Name:String);
Var D,N,E:String;
Begin
     ResetAppName;
     FSplit(Name,D,N,E);
     If N<>'' Then
     Begin
          GetMem(FAppName,Length(N)+1);
          FAppName^:=N;
          {$IFDEF WIN32}
          FHszApp:=DdeCreateStringHandle(FDdeInstId,FAppName^,CP_WINANSI);
          DdeNameService(FDdeInstId,FHszApp,0,DNS_REGISTER);
          {$ENDIF}
     End;
End;

Function TDdeMgr.GetAppName:String;
Begin
     If FAppName<>Nil Then Result:=FAppName^
     Else Result:='';
End;

Procedure TDdeMgr.ResetAppName;
Begin
     If FAppName<>Nil Then FreeMem(FAppName,Length(FAppName^)+1);
     FAppName:=Nil;
     {$IFDEF WIN32}
     If FHszApp<>0 Then
     Begin
          DdeNameService(FDdeInstId,FHszApp,0,DNS_UNREGISTER);
          DdeFreeStringHandle(FDdeInstId,FHszApp);
     End;
     {$ENDIF}
End;

Function TDdeMgr.GetForm(Const topic:String):TForm;
Var T:LongInt;
    Server:TDdeServerConv;
Begin
     If FServerConvs<>Nil Then For T:=0 To FServerConvs.Count-1 Do
     Begin
          Server:=FServerConvs[T];
          If ((Server.Name=topic)Or(Server.DdeTopic=topic)) Then
          Begin
               Result:=Server.Form;  // we cannot determine the Item here
               Exit;
          End;
     End;
End;

Function TDdeMgr.GetServerItem(Const topic:String;Form:TForm;Var Conv:TDdeServerConv):TDdeServeRitem;
Var T:LongInt;
    Server:TDdeServerConv;
Begin
     //Items that have A Server
     If FServerConvs<>Nil Then For T:=0 To FServerConvs.Count-1 Do
     Begin
          Server:=FServerConvs[T];
          If Server.Form=Form Then
            If ((Server.Name=topic)Or(Server.DdeTopic=topic)) Then
            Begin
                 Conv:=Server;
                 Result:=Nil;  // we cannot determine the Item here
                 Exit;
            End;
     End;

     //Items without A Server
     If FServerItems<>Nil Then For T:=0 To FServerItems.Count-1 Do
     Begin
          Result:=FServerItems[T];
          If Result.Form=Form Then
          Begin
               If Result.Form.Caption=topic Then
               Begin
                    Conv:=Result.ServerConv;  //should be Nil
                    Exit;
               End;
          End;
     End;

     Conv:=Nil;
     Result:=Nil;
End;

Procedure TDdeMgr.InsertServerConv(SConv: TDdeServerConv);
Begin
     If FServerConvs=Nil Then FServerConvs.Create;
     FServerConvs.Add(SConv);
End;

Procedure TDdeMgr.RemoveServerConv(SConv: TDdeServerConv);
Begin
     Try
        FServerConvs.Remove(SConv);
     Except
     End;
End;

Procedure TDdeMgr.InsertServerItem(Item:TDdeServerItem);
Begin
     If FServerItems=Nil Then FServerItems.Create;
     FServerItems.Add(Item);
End;

Procedure TDdeMgr.RemoveServerItem(Item:TDdeServerItem);
Begin
     Try
        FServerItems.Remove(Item);
     Except
     End;
End;

Procedure TDdeMgr.SetupComponent;
Begin
     Inherited SetupComponent;
     {$IFDEF WIN32}
     FDdeInstId:=0;
     DdeInitialize(FDdeInstId,@DdeMgrCallBack,APPCLASS_STANDARD,0);
     {$ENDIF}

     AppName:=GetExeName;
End;

Destructor TDdeMgr.Destroy;
Begin
     If FServerConvs<>Nil Then FServerConvs.Destroy;
     FServerConvs:=Nil;
     If FClientConvs<>Nil Then FClientConvs.Destroy;
     FClientConvs:=Nil;
     If FServerItems<>Nil Then FServerItems.Destroy;
     FServerItems:=Nil;
     If OWindows<>Nil Then OWindows.Destroy;
     OWindows:=Nil;
     If FClients<>Nil Then FClients.Destroy;
     FClients:=Nil;
     ResetAppName;
     {$IFDEF WIN32}
     DdeUnInitialize(FDdeInstId);
     {$ENDIF}

     Inherited Destroy;
End;

Function TDdeMgr.GetExeName:String;
Begin
  Result:=goSysInfo.ProgramInfo.ExeName;
//  Result:=ParamStr(0);
//  UpcaseStr(Result);
End;

Procedure TDdeMgr.GetTopics(Topics:TStrings;Form:TForm);
Var T:LongInt;
    Server:TDdeServerConv;
    Item:TDdeServerItem;
Begin
     Topics.Clear;

     //Items that have A Server
     If FServerConvs<>Nil Then For T:=0 To FServerConvs.Count-1 Do
     Begin
          //process Items Topics
          Server:=FServerConvs[T];
          If Server.Form=Form Then Topics.Add(Server.DdeTopic);
     End;

     //Items that have no Server
     If FServerItems<>Nil Then For T:=0 To FServerItems.Count-1 Do
     Begin
          Item:=FServerItems[T];
          If Item.Form=Form Then Topics.Add(Item.Form.Caption);
     End;
End;

Function TDdeMgr.HasDDEServers(Form:TForm):Boolean;
Var T,t1:LongInt;
    Server:TDdeServerConv;
    Item:TDdeServerItem;
Begin
     Result:=False;

     //Items that have A Server
     If FServerConvs<>Nil Then For T:=0 To FServerConvs.Count-1 Do
     Begin
          //process Items Topics
          Server:=FServerConvs[T];
          If Server.Form=Form Then
          Begin
               Result:=True;
               Exit;
          End;

          For t1:=0 To Server.ItemCount-1 Do
          Begin
               Item:=Server.Items[t1];
               If Item.Form=Form Then
               Begin
                    Result:=True;
                    Exit;
               End;
          End;
     End;

     //Items that have no Server
     If FServerItems<>Nil Then For T:=0 To FServerItems.Count-1 Do
     Begin
          Item:=FServerItems[T];
          If Item.Form=Form Then
          Begin
               Result:=True;
               Exit;
          End;
     End;
End;

Procedure TDdeMgr.AddObjectWindow(OWindow:TControl);
Begin
     If OWindows=Nil Then OWindows.Create;
     OWindows.Add(OWindow);
End;

Procedure TDdeMgr.RemoveObjectWindow(OWindow:TControl);
Begin
     Try
        OWindows.Remove(OWindow);
     Except
     End;
End;

Function TDdeMgr.GetActiveDdeConnections:LongInt;
Begin
     If OWindows=Nil Then Result:=0
     Else Result:=OWindows.Count;
End;

Procedure TDdeMgr.AddClient(client:TDdeClientConv);
Begin
     If FClients=Nil Then FClients.Create;
     FClients.Add(client);
End;

Procedure TDdeMgr.RemoveClient(client:TDdeClientConv);
Begin
     Try
        FClients.Remove(client);
     Except
     End;
End;

Procedure TDdeMgr.OpenClientLinks(Form:TForm);
Var T:LongInt;
    client:TDdeClientConv;
Begin
     If FClients=Nil Then Exit;
     For T:=0 To FClients.Count-1 Do
     Begin
          client:=FClients[T];
          If client.Form=Form Then
            If client.ConnectMode=ddeAutomatic Then client.OpenLink;
     End;
End;

Procedure TDdeMgr.CloseClientLinks(Form:TForm);
Var T:LongInt;
    client:TDdeClientConv;
Begin
     If FClients=Nil Then Exit;
     For T:=0 To FClients.Count-1 Do
     Begin
          client:=FClients[T];
          If client.Form=Form Then client.CloseLink;
     End;
End;

Procedure TDdeMgr.CloseAllLinks;
Var T:LongInt;
    client:TDdeClientConv;
{$IFDEF OS2}
    OWindow:TDdeObjectWindow;
{$ENDIF}
Begin
     If FClients=Nil Then Exit;
     For T:=0 To FClients.Count-1 Do
     Begin
          client:=FClients[T];
          //don't allow To call event handlers because the Form might be destroyed already...
          client.OnClose:=Nil;
          client.OnTimeOut:=Nil;
          client.CloseLink;
     End;

     {$IFDEF OS2}
     If OWindows<>Nil Then For T:=0 To OWindows.Count-1 Do
     Begin
          OWindow:=OWindows[T];
          If OWindow.FDdeClient<>0 Then
          Begin
               //don't allow To call event handlers because the Form might be destroyed already...
               If OWindow.FServerConv<>Nil Then OWindow.FServerConv.OnClose:=Nil;

               {$IFDEF OS2}
               WinDdePostMsg(OWindow.FDdeClient,OWindow.Handle,WM_DDE_TERMINATE,Nil,DDEPM_RETRY);
               {$ENDIF}
               OWindow.FDdeClient:=0;
          End;
     End;
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDdeServerConv Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TDdeServerConv.SetupComponent;
Var TheOwner:TComponent;
Begin
     Inherited SetupComponent;

     TheOwner:=Owner;
     While TheOwner<>Nil Do
     Begin
          If TheOwner Is TForm Then
          Begin
               FForm:=TForm(TheOwner);
               break;
          End;

          TheOwner:=TheOwner.Owner;
     End;

     DDEMgr.InsertServerConv(Self);
     Include(ComponentState, csHandleLinks);
End;

Destructor TDdeServerConv.Destroy;
{$IFDEF OS2}
Var T:LongInt;
    OWindow:TDdeObjectWindow;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Try
     If DDEMgr.OWindows<>Nil Then For T:=0 To DDEMgr.OWindows.Count-1 Do
     Begin
          OWindow:=DDEMgr.OWindows[T];
          If OWindow.FServerConv=Self Then If OWindow.FDdeClient<>0 Then
          Begin
               {$IFDEF OS2}
               WinDdePostMsg(OWindow.FDdeClient,OWindow.Handle,WM_DDE_TERMINATE,Nil,DDEPM_RETRY);
               {$ENDIF}
               OWindow.FDdeClient:=0;
          End;
     End;
     Except
     End;

     Inherited Destroy;

     DDEMgr.RemoveServerConv(Self);
     If FItems<>Nil Then FItems.Destroy;
     FItems:=Nil;
     If FDdeTopic<>Nil Then FreeMem(FDdeTopic,Length(FDdeTopic^)+1);
     FDdeTopic:=Nil;
     {$ENDIF}
End;

Function TDdeServerConv.GetItemCount:LongInt;
Begin
     If FItems<>Nil Then Result:=FItems.Count
     Else Result:=0;
End;

Function TDdeServerConv.GetItem(Index:LongInt):TDdeServerItem;
Begin
     If ((Index>=0)And(FItems<>Nil)And(Index<FItems.Count)) Then Result:=FItems[Index]
     Else Result:=Nil;
End;

Procedure TDdeServerConv.InsertItem(Item:TDdeServerItem);
Begin
     If FItems=Nil Then FItems.Create;
     FItems.Add(Item);
End;

Procedure TDdeServerConv.RemoveItem(Item:TDdeServerItem);
Begin
     Try
        FItems.Remove(Item);
     Except
     End;
End;

Procedure TDdeServerConv.ExecuteMacro(macro:TStrings;Var Success:Boolean);
Begin
     If FOnExecuteMacro<>Nil Then FOnExecuteMacro(Self,macro,Success);
End;

Procedure TDdeServerConv.Connect;
Begin
     If FOnOpen<>Nil Then FOnOpen(Self);
End;

Procedure TDdeServerConv.Disconnect;
Begin
     If FOnClose<>Nil Then FOnClose(Self);
End;

Function TDdeServerConv.GetDdeTopic:String;
Begin
     If FDdeTopic=Nil Then Result:=Name
     Else Result:=FDdeTopic^;
End;

Procedure TDdeServerConv.SetDdeTopic(NewValue:String);
Begin
     If FDdeTopic<>Nil Then FreeMem(FDdeTopic,Length(FDdeTopic^)+1);
     FDdeTopic:=Nil;
     If NewValue<>'' Then
     Begin
          GetMem(FDdeTopic,Length(NewValue)+1);
          FDdeTopic^:=NewValue;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDdeServerItem Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TDdeServerItem.ValueChanged;
Var topic:String;
Begin
     If FOnChange<>Nil Then FOnChange(Self);

     If ServerConv<>Nil Then
     Begin
          topic:=ServerConv.DdeTopic;
          If topic='' Then topic:=ServerConv.Name
     End
     Else topic:=Form.Caption;
     If FAdviseMode>0 Then DDEMgr.PostDataChange(topic,DdeItem)
End;

Function TDdeServerItem.GetText:String;
Begin
     If FLines.Count>0 Then Result:=FLines.Strings[0]
     Else Result:='';
End;

Procedure TDdeServerItem.SetText(Const Item:String);
Begin
     FLines.Clear;
     FLines.Add(Item);
     ValueChanged;
End;

Procedure TDdeServerItem.SetLines(Value:TStrings);
Begin
     If FLines.Equals(Value) Then Exit; //Nothing To Do
     FLines.Assign(Value);
     ValueChanged;
End;

//If no topic Is Set, the Name Of the Server (If present) Or the Name
//Of the Form containing the TDdeServerItem Is used As topic
Function TDdeServerItem.GetItem:String;
Begin
     If FItem=Nil Then Result:=''
     Else Result:=FItem^;
End;

Procedure TDdeServerItem.SetItem(NewValue:String);
Begin
     If FItem<>Nil Then FreeMem(FItem,Length(FItem^)+1);
     GetMem(FItem,Length(NewValue)+1);
     FItem^:=NewValue;
End;

//If no Server Is specified, the DDEServerItem Is entered into the
//Items List Of the DDE Manager
Procedure TDdeServerItem.SetServerConv(SConv:TDdeServerConv);
Begin
     If FServerConv<>Nil Then
     Begin
          FServerConv.RemoveItem(Self);
          FServerConv.Notification(Self,opRemove);
     End;
     FServerConv := SConv;
     If FServerConv <> Nil Then
     Begin
          FServerConv.FreeNotification(Self);
          FServerConv.InsertItem(Self);
     End;
End;

Procedure TDdeServerItem.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FServerConv Then FServerConv := Nil;
End;


Procedure TDdeServerItem.SetupComponent;
Var TheOwner:TComponent;
Begin
     Inherited SetupComponent;

     TheOwner:=Owner;
     While TheOwner<>Nil Do
     Begin
          If TheOwner Is TForm Then
          Begin
               FForm:=TForm(TheOwner);
               break;
          End;

          TheOwner:=TheOwner.Owner;
     End;
     If FForm=Nil Then FForm:=Application.MainForm;

     FLines:=TStringList.Create;

     If Owner Is TDdeServerConv Then ServerConv:=TDdeServerConv(Owner) //we have A Server !
     Else DDEMgr.InsertServerItem(Self);  //we have no Server yet !
End;

Destructor TDdeServerItem.Destroy;
{$IFDEF OS2}
Var T:LongInt;
    OWindow:TDdeObjectWindow;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Try
        If DDEMgr.OWindows<>Nil Then For T:=0 To DDEMgr.OWindows.Count-1 Do
        Begin
             OWindow:=DDEMgr.OWindows[T];
             If OWindow.FClientItem=Self Then If OWindow.FDdeClient<>0 Then
             Begin
                  {$IFDEF OS2}
                  WinDdePostMsg(OWindow.FDdeClient,OWindow.Handle,WM_DDE_TERMINATE,Nil,DDEPM_RETRY);
                  {$ENDIF}
                  OWindow.FDdeClient:=0;
             End;
        End;
        ServerConv:=Nil; //Free Link
     Except
     End;
     FLines.Destroy;
     FLines:=Nil;
     If FItem<>Nil Then FreeMem(FItem,Length(FItem^)+1);
     FItem:=Nil;

     Inherited Destroy;
     {$ENDIF}
End;

Procedure TDdeServerItem.Change;
Begin
     If FOnChange<>Nil Then FOnChange(Self);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDdeClientConv Class Implementation                         บ
บ                                                                           บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDdeClientConv.GetDdeService:String;
Begin
     If FDdeService=Nil Then Result:=''
     Else Result:=FDdeService^;
End;

Procedure TDdeClientConv.SetDdeService(Const Value:String);
Begin
     If FDdeService<>Nil Then FreeMem(FDdeService,Length(FDdeService^)+1);
     GetMem(FDdeService,Length(Value)+1);
     FDdeService^:=Value;
End;

Function TDdeClientConv.GetDdeTopic:String;
Begin
     If FDdeTopic=Nil Then Result:=''
     Else Result:=FDdeTopic^;
End;

Procedure TDdeClientConv.SetDdeTopic(Const Value:String);
Begin
     If FDdeTopic<>Nil Then FreeMem(FDdeTopic,Length(FDdeTopic^)+1);
     GetMem(FDdeTopic,Length(Value)+1);
     FDdeTopic^:=Value;
End;

Procedure TDdeClientConv.SetConnectMode(NewValue:TDataMode);
Begin
     If NewValue=FConnectMode Then Exit;

     FConnectMode:=NewValue;
     If ComponentState*[csReading]=[] Then
     Begin
          If FConnectMode=ddeManual Then CloseLink
          Else OpenLink;
     End;
End;


{$HINTS OFF}
Function TDdeClientConv.CreateDdeConv(Const AppName,TopicName:String):Boolean;
Begin
     Result:=False;   {DDE noch rein}
End;
{$HINTS ON}

Procedure TDdeClientConv.SetupComponent;
Var TheOwner:TComponent;
Begin
     Inherited SetupComponent;

     FConnectMode:=ddeAutomatic;
     TheOwner:=Owner;
     While TheOwner<>Nil Do
     Begin
          If TheOwner Is TForm Then
          Begin
               FForm:=TForm(TheOwner);
               break;
          End;

          TheOwner:=TheOwner.Owner;
     End;
     If FForm=Nil Then FForm:=Application.MainForm;

     If FForm=Nil Then FForm:=Application.MainForm;
     Include(ComponentState, csHandleLinks);
     FTimeOut:=200;
     DDEMgr.AddClient(Self);
End;

Destructor TDdeClientConv.Destroy;
Begin
     CloseLink;
     DDEMgr.RemoveClient(Self);

     Inherited Destroy;

     If FDdeService<>Nil Then FreeMem(FDdeService,Length(FDdeService^)+1);
     FDdeService:=Nil;
     If FDdeTopic<>Nil Then FreeMem(FDdeTopic,Length(FDdeTopic^)+1);
     FDdeTopic:=Nil;
     If FItems<>Nil Then FItems.Destroy;
     FItems:=Nil;
     If FObjectWindow<>Nil Then FObjectWindow.Destroy;
     FObjectWindow:=Nil;
End;

Function TDdeClientConv.PasteLink:Boolean;
Begin
     Result:=False;
End;

Function TDdeClientConv.OpenLink:Boolean;
Begin
     If FConnected Then Exit;
     FConnected:=SetLink(DdeService,DdeTopic);
     If FConnected Then If FOnOpen<>Nil Then FOnOpen(Self);
     Result:=FConnected;
End;

Procedure TDdeClientConv.WaitForServer;
{$IFDEF OS2}
Var Queue:QMSG;
    TOut:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     TOut:=0;
     While True Do
     Begin
          If WinPeekMsg(AppHandle,Queue,0,0,0,PM_REMOVE) Then
             WinDispatchMsg(AppHandle,Queue);

          If FOperationComplete Then break;
          Inc(TOut);
          If TOut>TimeOut Then //Time out !
          Begin
               If OnTimeOut<>Nil Then OnTimeOut(Self);
               FData:=Nil;
               FDataLen:=0;
               break;
               //FOperationComplete:=True;
          End;
     End;
     {$ENDIF}
End;

Function TDdeClientConv.SetLink(Const Service,topic:String):Boolean;
{$IFDEF OS2}
Var cctxt:CONVCONTEXT;
    App,Top:Cstring;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If FConnected Then
     Begin
          Result:=True;
          Exit;
     End;
     If ((Service='')Or(topic='')) Then
     Begin
          Result:=False;
          Exit;
     End;
     If FObjectWindow<>Nil Then FObjectWindow.Destroy;
     FObjectWindow:=TDdeObjectWindow.Create(Nil);
     TDdeObjectWindow(FObjectWindow).CreateWnd;
     TDdeObjectWindow(FObjectWindow).FDdeTopic:=topic;
     TDdeObjectWindow(FObjectWindow).FClientConv:=Self;
     TDdeObjectWindow(FObjectWindow).FDdeForm:=Form.Handle;

     FillChar(cctxt,SizeOf(CONVCONTEXT),0);
     cctxt.cb:=SizeOf(CONVCONTEXT) ;
     cctxt.fsContext:=DDECTXT_CASESENSITIVE;
     App:=Service;
     Top:=topic;
     FOperationComplete:=False;
     FData:=Nil;
     WinDdeInitiate (FObjectWindow.Handle,App,Top,cctxt);
     WaitForServer;
     {$ENDIF}

     Result:=FConnected;
End;

Procedure TDdeClientConv.CloseLink;
Begin
     If Not FConnected Then Exit;
     If FObjectWindow=Nil Then
     Begin
          FConnected:=False;
          If FOnClose<>Nil Then FOnClose(Self);
          exit;
     End;
     {$IFDEF OS2}
     FOperationComplete:=False;
     FData:=Nil;
     WinDdePostMsg(TDdeObjectWindow(FObjectWindow).FDdeServer,
                   FObjectWindow.Handle,WM_DDE_TERMINATE,Nil,DDEPM_RETRY);
     WaitForServer;
     {$ENDIF}
     FConnected:=False;
     If FOnClose<>Nil Then FOnClose(Self);
End;

Function TDdeClientConv.StartAdvise(Item:String):Boolean;
{$IFDEF OS2}
Var SData:PDDESTRUCT;
{$ENDIF}
Begin
     If Not FConnected Then Exit;
     {$IFDEF OS2}
     FOperationComplete:=False;
     SData:=AllocDdeStruc(TDdeObjectWindow(FObjectWindow).FDdeServer,Item,
                          DDE_FACKREQ,DDEFMT_TEXT,Nil,0);
     WinDdePostMsg(TDdeObjectWindow(FObjectWindow).FDdeServer,FObjectWindow.Handle,
                   WM_DDE_ADVISE,SData^,DDEPM_RETRY);
     WaitForServer;
     {$ENDIF}
     Result:=FOperationComplete;
End;

Function TDdeClientConv.StopAdvise(Item:String):Boolean;
{$IFDEF OS2}
Var SData:PDDESTRUCT;
{$ENDIF}
Begin
     If Not FConnected Then Exit;
     {$IFDEF OS2}
     FOperationComplete:=False;
     SData:=AllocDdeStruc(TDdeObjectWindow(FObjectWindow).FDdeServer,Item,
                          0,DDEFMT_TEXT,Nil,0);
     WinDdePostMsg(TDdeObjectWindow(FObjectWindow).FDdeServer,FObjectWindow.Handle,
                   WM_DDE_UNADVISE,SData^,DDEPM_RETRY);
     WaitForServer;
     {$ENDIF}
     Result:=FOperationComplete;
End;

Function TDdeClientConv.PokeDataLines(Const Item: String; Data: TStrings):Boolean;
Var P:PChar;
Begin
     P:=Data.GetText;
     Result:=PokeData(Item,P);
     StrDispose(P);
End;

Function TDdeClientConv.PokeData(Const Item:String;Data:PChar):Boolean;
{$IFDEF OS2}
Var SData:PDDESTRUCT;
{$ENDIF}
Begin
     If ((Data=Nil)Or(Not FConnected)) Then Exit;  //Nothing To Poke
     {$IFDEF OS2}
     FOperationComplete:=False;
     SData:=AllocDdeStruc(TDdeObjectWindow(FObjectWindow).FDdeServer,Item,
                          0,DDEFMT_TEXT,Data,Length(Data^)+1);
     WinDdePostMsg(TDdeObjectWindow(FObjectWindow).FDdeServer,FObjectWindow.Handle,
                   WM_DDE_POKE,SData^,DDEPM_RETRY);
     WaitForServer;
     {$ENDIF}
     Result:=FOperationComplete;
End;

Function TDdeClientConv.ExecuteMacro(cmd:PChar;waitFlg:Boolean):Boolean;
{$IFDEF OS2}
Var SData:PDDESTRUCT;
{$ENDIF}
Begin
     Result:=False;
     If Not FConnected Then Exit;
     {$IFDEF OS2}
     FOperationComplete:=False;
     SData:=AllocDdeStruc(TDdeObjectWindow(FObjectWindow).FDdeServer,'',
                          0,DDEFMT_TEXT,cmd,Length(cmd^)+1);
     WinDdePostMsg(TDdeObjectWindow(FObjectWindow).FDdeServer,FObjectWindow.Handle,
                   WM_DDE_EXECUTE,SData^,DDEPM_RETRY);
     If waitFlg Then WaitForServer;
     {$ENDIF}
     Result:=True;
End;

Function TDdeClientConv.ExecuteMacroLines(cmd:TStrings;waitFlg:Boolean):Boolean;
Var P:PChar;
Begin
     P:=cmd.GetText;
     Result:=ExecuteMacro(P,waitFlg);
     StrDispose(P);
End;

Function TDdeClientConv.RequestData(Const Item:String):PChar;
{$IFDEF OS2}
Var pdde:PDDESTRUCT;
{$ENDIF}
Begin
     Result:=Nil;
     If Not FConnected Then Exit;
     {$IFDEF OS2}
     FData:=Nil;
     FOperationComplete:=False;
     pdde:=AllocDdeStruc(TDdeObjectWindow(FObjectWindow).FDdeServer,Item,
                         0,DDEFMT_TEXT,Nil,0);
     WinDdePostMsg (TDdeObjectWindow(FObjectWindow).FDdeServer,FObjectWindow.Handle,
                    WM_DDE_REQUEST,pdde^,DDEPM_RETRY) ;
     WaitForServer;
     Result:=FData;
     {$ENDIF}
End;

Procedure TDdeClientConv.RemoveItem(Item:TDdeClientItem);
Begin
     Try
        FItems.Remove(Item);
     Except
     End;
End;

Procedure TDdeClientConv.InsertItem(Item:TDdeClientItem);
Begin
     If FItems=Nil Then FItems.Create;
     FItems.Add(Item);
End;

Function TDdeClientConv.GetItem(Index:LongInt):TDdeClientItem;
Begin
     If ((FItems=Nil)Or(Index<0)Or(Index>=FItems.Count)) Then Result:=Nil
     Else Result:=FItems[Index];
End;

Function TDdeClientConv.GetItemCount:LongInt;
Begin
     If FItems=Nil Then Result:=0
     Else Result:=FItems.Count;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TDdeClientItem Class Implementation                         บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TDdeClientItem.Advise:Boolean;
Begin
     Result:=False;
     If DdeConv<>Nil Then
       If DdeConv.FConnected Then Result:=DdeConv.StartAdvise(DdeItem);
End;

Function TDdeClientItem.Unadvise:Boolean;
Begin
     Result:=False;
     If DdeConv<>Nil Then
       If DdeConv.FConnected Then Result:=DdeConv.StopAdvise(DdeItem);
End;

Function TDdeClientItem.Request:Boolean;
Begin
     Result:=False;
     If DdeConv<>Nil Then
       If DdeConv.FConnected Then
     Begin
          FLines.SetText(DdeConv.RequestData(DdeItem));
          ValueChanged;
          Result:=True;
     End;
End;

Function TDdeClientItem.Poke:Boolean;
Var P:PChar;
Begin
     Result:=False;
     If DdeConv<>Nil Then
       If DdeConv.FConnected Then
       Begin
            P:=FLines.GetText;
            Result:=DdeConv.PokeData(DdeItem,P);
            StrDispose(P);
       End;
End;

Function TDdeClientItem.GetText:String;
Begin
     If FLines.Count>0 Then Result:=FLines.Strings[0]
     Else Result:='';
End;

Procedure TDdeClientItem.SetText(Const Item:String);
Begin
     FLines.Clear;
     FLines.Add(Item);
End;

Function TDdeClientItem.GetDdeClientItem:String;
Begin
     If FDdeClientItem=Nil Then Result:=''
     Else Result:=FDdeClientItem^;
End;

Procedure TDdeClientItem.SetDdeClientItem(Const NewValue:String);
Begin
     If FDdeClientItem<>Nil Then FreeMem(FDdeClientItem,Length(FDdeClientItem^)+1);
     GetMem(FDdeClientItem,Length(NewValue)+1);
     FDdeClientItem^:=NewValue;
End;

Procedure TDdeClientItem.SetDdeClientConv(SConv:TDdeClientConv);
Begin
     If FClientConv<>Nil Then
     Begin
          FClientConv.RemoveItem(Self);
          FClientConv.Notification(Self,opRemove);
     End;
     FClientConv := SConv;
     If FClientConv <> Nil Then
     Begin
          FClientConv.FreeNotification(Self);
          FClientConv.InsertItem(Self);
     End;
End;

Procedure TDdeClientItem.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FClientConv Then FClientConv := Nil;
End;


Procedure TDdeClientItem.SetLines(Value:TStrings);
Begin
     If FLines.Equals(Value) Then Exit; //Nothing To Do
     FLines.Assign(Value);
End;

Procedure TDdeClientItem.OnAdvise(Text:PChar);
Var List:TStringList;
Begin
     List.Create;
     List.SetText(Text);
     SetLines(List);
     ValueChanged;
     List.Destroy;
End;

Procedure TDdeClientItem.SetupComponent;
Var TheOwner:TComponent;
Begin
     Inherited SetupComponent;

     FLines:=TStringList.Create;
     TheOwner:=Owner;
     While TheOwner<>Nil Do
     Begin
          If TheOwner Is TForm Then
          Begin
               FForm:=TForm(TheOwner);
               break;
          End;

          TheOwner:=TheOwner.Owner;
     End;
     If FForm=Nil Then FForm:=Application.MainForm;
End;

Destructor TDdeClientItem.Destroy;
Begin
     Try
        DdeConv:=Nil;
     Except
     End;
     FLines.Destroy;
     FLines:=Nil;

     Inherited Destroy;
End;

Procedure TDdeClientItem.ValueChanged;
Begin
     If FOnChange<>Nil Then FOnChange(Self);
End;

Procedure DdeMan_WMDdeDestroy(Var Msg:TMessage);
{$IFDEF OS2}
Var OWindow:TDdeObjectWindow;
{$ENDIF}
Begin
     {$IFDEF OS2}
     OWindow:=Pointer(Msg.Param1);
     Try
        OWindow.Destroy;
     Except
     End;
     {$ENDIF}
     Msg.Handled:=True;
     Msg.Result:=0;
End;

Procedure DdeMan_WMDdeInitiate(Self:TForm;Var Msg:TMessage);
{$IFDEF OS2}
Var Data:PDDEINIT;
    Sender:HWND;
    Server,topic:Cstring;
    Top:String;
    cContext:CONVCONTEXT;
    Topics:TStringList;
    T:LongInt;
    ServerItem:TDdeServerItem;
    ServerConv:TDdeServerConv;
    ObjectWindow:TDdeObjectWindow;
{$ENDIF}
Begin
     If DDEMgr=Nil Then exit;

     {$IFDEF OS2}
     Sender:=Msg.Param1;
     Data:=Pointer(Msg.Param2);
     If ((Data^.pszAppName^='')Or                  //any Application can resond - So we Do !
         (Data^.pszAppName^=DDEMgr.AppName)) Then  //This Is our Id !
     Begin
          FillChar(cContext,SizeOf(CONVCONTEXT),0);
          cContext.cb:=SizeOf(CONVCONTEXT);
          cContext.fsContext:=DDECTXT_CASESENSITIVE;  //All conversations are Case sensitive

          Top:=Data^.pszTopic^;

          If Top='' Then //All supported Topics For This Form
          Begin
               Topics.Create;

               DDEMgr.GetTopics(Topics,Self);

               For T:=0 To Topics.Count-1 Do
               Begin
                    Top:=Topics[T];

                    ObjectWindow.Create(Nil);
                    ObjectWindow.CreateWnd;
                    ObjectWindow.FDdeClient:=Sender;
                    ObjectWindow.FDdeForm:=Self.Handle;
                    ObjectWindow.FDdeTopic:=Top;
                    ObjectWindow.FServerItem:=DDEMgr.GetServerItem(Top,Self,ObjectWindow.FServerCOnv);

                    DDEMgr.AddObjectWindow(ObjectWindow);

                    Server:=DDEMgr.AppName;
                    topic:=Topics[T];
                    WinDdeRespond(Sender,ObjectWindow.Handle,Server,topic,cContext);
               End;

               Topics.Destroy;
          End
          Else If Data^.pszAppName^=DDEMgr.AppName Then //specific topic
          Begin
               ServerItem:=DDEMgr.GetServerItem(Top,Self,ServerConv);
               If ((ServerItem<>Nil)Or(ServerConv<>Nil)) Then
               Begin
                    If DDEMgr.HasDDEServers(Self) Then
                    Begin
                         ObjectWindow.Create(Nil);
                         ObjectWindow.CreateWnd;
                         ObjectWindow.FDdeClient:=Sender;
                         ObjectWindow.FDdeForm:=Self.Handle;
                         ObjectWindow.FDdeTopic:=Top;
                         ObjectWindow.FServerItem:=ServerItem;
                         ObjectWindow.FServerConv:=ServerConv;

                         DDEMgr.AddObjectWindow(ObjectWindow);

                         Server:=DDEMgr.AppName;
                         topic:=Top;
                         WinDdeRespond(Sender,ObjectWindow.Handle,Server,topic,cContext);
                    End;
               End;
          End;
     End;
     {$ENDIF}

     Msg.Handled:=True;
     Msg.Result:=1;
End;

Procedure DdeMan_OpenClientLinks(Form:TForm);
Begin
     DdeMgr.OpenClientLinks(Form);
End;

Procedure DdeMan_CloseClientLinks(Form:TForm);
Begin
     DdeMgr.CloseClientLinks(Form);
End;

Procedure DdeMan_CloseAllLinks;
Begin
     DdeMgr.CloseAllLinks;
End;

Begin
    DDEMgr.Create(Nil);
    Asm
       MOV EAX,@DDEMan_WMDdeDestroy
       MOV FORMS.DDEMan_WMDdeDestroy,EAX
       MOV EAX,@DdeMan_WMDdeInitiate
       MOV FORMS.DdeMan_WMDdeInitiate,EAX
       MOV EAX,@DdeMan_OpenClientLinks
       MOV FORMS.DdeMan_OpenClientLinks,EAX
       MOV EAX,@DdeMan_CloseClientLinks
       MOV FORMS.DdeMan_CloseClientLinks,EAX
       MOV EAX,@DdeMan_CloseAllLinks
       MOV FORMS.DdeMan_CloseAllLinks,EAX
    End;
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  28-Aug-05  WD         Variablen die nicht verwendet werden entfernt.
  09-Mar-06  WD         Paramstr(0) durch uSysInfo ersetzt.
}

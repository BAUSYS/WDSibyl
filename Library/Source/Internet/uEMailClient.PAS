Unit uEMailClient;

Interface

Uses
  Classes, Forms, ScktComp, SysUtils,
  uStream, uString, uDateTime, uList;

type
  tContentEncoding = (Bit7, Bit8);

  tcMailHeader = Class(tObject)
    private
      fOctets         : LongWord;
      fReturnPath     : String;
      fReceived       : tStringList;
      fMessageID      : String;
      fDate           : tDateTime;
      fMailFrom       : String;
      fMailTo         : tStringList;
      fMailCC         : tStringList;
      fXMailer        : String;
      fXLanguage      : String;
      fMimeVersion    : Byte;
      fMimeSubVersion : Byte;
      fSubject        : String;
      fContentType    : String;
      fContentEncoding: tContentEncoding;
      fXUIDL          : String;
      fStatus         : String;
      fBoundary       : String;
      fUserAgent      : String;
      fStreamHeaderLen: LongWord;
      fReplyTO        : String;
      fXOriginatingIP : String;

    public
      Procedure SetMailStream(iMailStream : tMemoryStream);
      constructor Create; virtual;
      destructor Destroy; Override;

      property Octets         : LongWord    Read fOctets;
      property ReturnPath     : String      Read fReturnPath;
      property Received       : tStringList Read fReceived;
      property MessageID      : String      Read fMessageID;
      property Date           : tDateTime   Read fDate;
      property MailFrom       : String      Read fMailFrom;
      property MailTo         : tStringList Read fMailTo;
      property MailCC         : tStringList Read fMailCC;
      property XMailer        : String      Read fXMailer;
      property XLanguage      : String      Read fXLanguage;
      property MimeVersion    : Byte        Read fMimeVersion;
      property MimeSubVersion : Byte        Read fMimeSubVersion;
      property Subject        : String      Read fSubject;
      property ContentType    : String      Read fContentType;
      property ContentEncoding: tContentEncoding Read fContentEncoding;
      property XUIDL          : String      Read fXUIDL;
      property Status         : String      Read fStatus;
      property UserAgent      : String      Read fUserAgent;
      property ReplyTO        : String      Read fReplyTO;
      property XOriginatingIP : String      Read fXOriginatingIP;

      property Boundary       : String      Read fBoundary;

      Property StreamHeaderLen: LongWord    Read fStreamHeaderLen;
    End;

  tcMail = Class(tObject)
    private
      fHeader : tcMailHeader;
      Procedure SetMailStream(iMailStream : tMemoryStream);
    public
      constructor Create; virtual;
      destructor Destroy; Override;

      Property MailStream : tMemoryStream Write SetMailStream;
      Property Header : tcMailHeader Read fHeader;
    Published

  end;

{ -------------------------------------------------------------------- }

Type tStatus   = (tStat_Connect, tStat_User, tStat_Pass, tStat_Connection,
                  tStat_Quit, tStat_Disconnected,
                  tStat_Status,
                  tStat_Top, tStat_GetHeader,
                  tStat_GetMail, tStat_RetrMail,
                  tStat_Delete,
                  tStat_GetMailSize,
                  tStat_GetServerSize,
                  tStat_Text);

type tpReceiveEvent = procedure(iSender: tObject; iRecText : String; iObject : tObject) of Object;

type
  tPop3Client=Class(TComponent)
  Private
    fUser        : String;
    fPasswort    : String;
    fStatus      : tStatus;
    fClientSocket: tClientSocket;

    fOnChangeStatus : tNotifyEvent;
    fOnReceive      : tpReceiveEvent;

    Procedure SetStatus(iStatus : tStatus);
    Function GetHost : String;
    Procedure SetHost(iHost : String);
    Function GetActive : Boolean;
    Procedure SetActive(iValue:Boolean);

    Procedure fOnRead(iSender: TObject; iSocket: TCustomWinSocket);
  Protected
    Procedure SetupComponent; Override;
  Public
    Destructor Destroy; Override;

    Procedure DeleteMail(iMailNr : LongWord);
    Procedure GetMail(iMailNr : LongWord);
    Procedure GetHeader(iMailNr : LongWord);
    Procedure GetServerSize;

    Procedure SendString(iStatus : tStatus; iString : String);

    Property Active  : Boolean Read GetActive Write SetActive;
    Property Status  : tStatus Read fStatus;
  Published
    Property Host    : String Read GetHost   Write SetHost;
    Property User    : String Read fUser     Write fUser;
    Property Passwort: String Read fPasswort Write fPasswort;

    Property OnChangeStatus : tNotifyEvent Read fOnChangeStatus Write fOnChangeStatus;
    Property OnReceive : tpReceiveEvent    Read fOnReceive      Write fOnReceive;
  End;

{ Exports
  tPOP3Client,'Internet','..\Bmp\Internet\EMailPOP.BMP'; }

Implementation         

Procedure tPOP3Client.GetServerSize;

Begin
  if fStatus = tStat_Disconnected then exit;
  SendString(tStat_GetServerSize, '');
End;

Procedure tPOP3Client.GetHeader(iMailNr : LongWord);

Begin
  if fStatus = tStat_Disconnected then exit;
  SendString(tStat_GetHeader, toStr(iMailNr));
End;

Procedure tPOP3Client.GetMail(iMailNr : LongWord);

Begin
  if fStatus = tStat_Disconnected then exit;
  SendString(tStat_GetMail, toStr(iMailNr));
End;

Procedure tPOP3Client.DeleteMail(iMailNr : LongWord);

Begin
  if fStatus = tStat_Disconnected then exit;
  SendString(tStat_Delete, toStr(iMailNr));
End;

Procedure tPOP3Client.SendString(iStatus : tStatus; iString : String);

Var SendStr : String;

Begin
  case iStatus of
    tStat_User         : SendStr:='USER ' + iString;
    tStat_Pass         : SendStr:='PASS ' + iString;
    tStat_Quit         : SendStr:='QUIT';
    tStat_GetHeader    : SendStr:='TOP ' + iString + ' 20';
    tStat_GetMail      : SendStr:='RETR ' + iString;
    tStat_GetServerSize: SendStr:='LIST ' + iString;

    tStat_Delete     : SendStr:='DELE ' + iString;

    tStat_Top        : SendStr:='TOP ' + iString;
    tStat_Status     : SendStr:='STAT';
    tStat_Text       : SendStr:=iString;
    tStat_GetMailSize: SendStr:='LIST ' + iString;
    else               SendStr:='';
  end;
  if SendStr <> '' then
    Begin
      Writeln('Send:',SendStr);
      SetStatus(iStatus);
      fClientSocket.Socket.SendText(SendStr+#13+#10);
    End;
End;

Procedure tPOP3Client.fOnRead(iSender: TObject; iSocket: TCustomWinSocket);

Var LenRead : LongWord;

  Procedure ReceiveBuffer;

  var Stream     : tMemoryStream;
      oSend       : tObject;
      oSendMail   : tcMail absolute oSend;
      oSendHeader : tcMailHeader absolute oSend;
      oSendSList  : tcLongWordList absolute oSend;
      RecText     : String;

    Procedure ReceiveGetServerList;

    var Temp1, Temp2: String;
        cou, anz    : LongWord;

    Begin
      oSendSList.Create;
      oSendSList.add(0);
      Split(Stream.Readln,' ',Temp1, Temp2);
      if uppercase(Temp2) =  'MESSAGES' then
        Begin
          anz:=StrtoInt(Temp1)-1;
          for cou:=0 to anz do
            Begin
              Split(Stream.Readln,' ',Temp1, Temp2);
              oSendSList.Add(strToInt(Temp2));
            End;
        End;
    End;

  Begin
    Stream.Create;
    Stream.SetSize(LenRead);
    iSocket.ReceiveBuf(Stream.Memory^[0],LenRead);
    recText:='';
    if fOnReceive<>nil then
      Begin
        case fStatus of
          tStat_GetMail  : Begin
                             oSendMail.Create;
                             oSendMail.SetMailStream(Stream);
                             recText:=oSendMail.Header.Subject;
                           End;
          tStat_GetHeader: Begin
                             oSendHeader.Create;
                             oSendHeader.SetMailStream(Stream);
                             recText:=oSendHeader.Subject;
                           End;
          tStat_GetServerSize: ReceiveGetServerList;
        end;
        fOnReceive(Self, recText, oSend);
        case fStatus of
          tStat_GetMail      : oSendMail.Destroy;
          tStat_GetHeader    : oSendHeader.Destroy;
          tStat_GetServerSize: oSendSList.Destroy;
        End;
      End;
    Stream.Destroy;

{ Status setzen }
    SetStatus(tStat_Connection);
  End;

  Procedure ReceiveCommand;

  var ErgText  : String;

  Begin
    ErgText:=iSocket.ReceiveText;
    Writeln('L=',LenRead,'  Empf:',ErgText);
    case fStatus of
      tStat_Connect: SendString(tStat_User, fUser);
      tStat_User   : SendString(tStat_Pass, fPasswort);
      tStat_Pass   : SetStatus(tStat_Connection);
      tStat_Quit   : Begin
                       SetStatus(tStat_Disconnected);
                       fClientSocket.Active:=false;
                     End;
      else fOnReceive(Self, ErgText, nil);
    End;
  End;

Var StatusText : tStr4;
    ErrText    : String;

Begin
  LenRead:=iSocket.ReceiveLength;
  iSocket.ReceiveBuf(StatusText[1],4);
  StatusText[0]:=#3;
  if StatusText = '+OK'
    then
      Begin
        if fStatus in [tStat_Top, tStat_GetMail, tStat_GetHeader,
                       tStat_GetServerSize]
          then ReceiveBuffer
          else ReceiveCommand;
      End
    else
      Begin
        ErrText:=trim(iSocket.ReceiveText);
        if StatusText = '-ER'
          then Writeln('Fehler:', StatusText,',',ErrText);
{          else Writeln('unn”tig'); }
      End;
End;


Procedure tPOP3Client.SetStatus(iStatus : tStatus);

Begin
  fStatus:=iStatus;
  if fOnChangeStatus <> nil then fOnChangeStatus(Self);
End;

Procedure tPOP3Client.SetActive(iValue:Boolean);

Begin
  if iValue = GetActive then exit;
  if iValue = true     { Verbindung wird hergestellt }
    then
      Begin
        if (fUser = '') or (fPasswort = '') then exit;
        fClientSocket.Active:=true;
        SetStatus(tStat_Connect);
      End
    else SendString(tStat_Quit, '');
End;

Function tPOP3Client.GetActive : Boolean;

Begin
  Result:=fClientSocket.Active;
End;

Procedure tPop3Client.SetHost(iHost : String);

Begin
  fClientSocket.Host:=iHost;
End;

Function tPop3Client.GetHost : String;

Begin
  Result:=fClientSocket.Host;
End;

Procedure tPop3Client.SetupComponent;
Begin
  Inherited SetupComponent;
  fStatus:=tStat_Disconnected;
  fClientSocket.Create(Self);
  if designed=false then
    Begin
      fClientSocket.Port:=110;
      fClientSocket.OnRead:=fOnRead;
    End;
  fUser:='';
  fPasswort:='';
End;

Destructor tPop3Client.Destroy;
Begin
  fClientSocket.Destroy;
  Inherited Destroy;
End;

{ -------------------------------------------------------------------------------- }

Type tHeaderTyp = (tHTReturnPath, tHTReceived, tHTMessageID, tHTDate,
                   tHTFrom, tHTTo, tHTCC, tHTXMailer, tHTXLanguage,
                   tHTMimeVersion, tHTSubject,
                   tHTContentType, tHTContentEncoding, tHTXUIDL, tHTStatus,
                   tHTUserAgent, tHTReplyTO, tHTXOriginatingIP,
                   tHTUnbekannt);

Const AnzHeaderTypText = 17;
      ArrHeaderTypText : Array[0..AnzHeaderTypText] of tStr26 =
               ('RETURN-PATH', 'RECEIVED', 'MESSAGE-ID', 'DATE', 'FROM', 'TO', 'CC',
                'X-MAILER', 'X-ACCEPT-LANGUAGE', 'MIME-VERSION', 'SUBJECT',
                'CONTENT-TYPE', 'CONTENT-TRANSFER-ENCODING', 'X-UIDL',
                'STATUS', 'USER-AGENT', 'REPLY-TO', 'X-ORIGINATING-IP');

Function EMailStrToDateTime(iDatum : String) : tDateTime;
{ Umwandeln von den E-Mail-Datumsformat in das Pascal "tDateTime"-Format }

Var sp : tStringList;
    dtd,dtt: tDateTime;
    Year, Mon, day : Word;

Begin
  sp.Create;
  if iDatum[1] in ['0'..'9'] then
    sp.Add('XXX');  {Der Wochentag fehlt }
  SplitAll(iDatum, ' ', sp);
{  for i:=0 to sp.count-1 do writeln(sp[i]); }
  Year:=strtoInt(sp.strings[3]);
  Mon:=MonthToNumber(sp.strings[2]);
  Day:=strtoInt(sp.strings[1]);
  dtd:=EncodeDate(Year,Mon,Day);
  dtt:=StrToTime(sp.Strings[4]);
  Result:=dtd+dtt;
End;

{ -------------------------------------------------------------------------------- }

Procedure tcMailHeader.SetMailStream(iMailStream : tMemoryStream);

Var Zeile       : String;
    TypText     : String;
    InfoText    : String;
    po          : Byte;
    HeaderTyp   : tHeaderTyp;
    OldHeaderTyp: tHeaderTyp;

Label CaseEnd;

Begin
  Writeln('Header.SetMailStream');
  iMailStream.Seek(soFromBeginning,0);
  Zeile:=UpperCase(iMailStream.Readln); // 1. Zeile: Enthaelkt die Octets (=8 Bit) vom Mail.
  split(Zeile, ' ', InfoText, TypText);
  if TypText='OCTETS' then
    fOctets:=StrToInt(InfoText);

  fReceived.Clear;
  fMailTo.Clear;
  fMailCC.Clear;

  Repeat
    Zeile:=UpperCase(iMailStream.Readln);
//    Writeln(Zeile);
    if Zeile[1] = ' '
      then
        Begin
          if Copy(Zeile,2,9) = 'BOUNDARY=' then
            Begin
              fBoundary:=TypText;
              HeaderTyp:=tHTUnbekannt
            End;
        End
      else
        Begin
          split(Zeile, ':', TypText, InfoText);
          InfoText:=trim(InfoText);
          TypText:=trim(TypText);
          HeaderTyp:=tHTReturnPath;
          While (HeaderTyp<tHTUnbekannt) and
                (TypText <> ArrHeaderTypText[Ord(HeaderTyp)]) do
            inc(HeaderTyp);
        End;
    Case HeaderTyp of
      tHTUnbekannt      : goto CaseEnd;
      tHTReturnPath     : fReturnPath := InfoText;
      tHTReceived       : fReceived.Add(InfoText);
      tHTMessageID      : fMessageID  := InfoText;
      tHTFrom           : fMailFrom   := InfoText;
      tHTStatus         : fStatus     := InfoText;
      tHTSubject        : fSubject    := InfoText;
      tHTDate           : fDate       := EMailStrToDateTime(InfoText);
      tHTTo             : fMailTO.AddSplit(InfoText, ',');
      tHTCC             : fMailCC.AddSplit(InfoText, ',');
      tHTXMailer        : fXMailer    := InfoText;
      tHTXLanguage      : fXLanguage  := InfoText;
      tHTMimeVersion    : Begin
                            po:=pos('.',InfoText);
                            fMimeVersion:=StrToInt(copy(InfoText,1,po-1));
                            fMimeSubVersion:=StrToInt(copy(Infotext,po+1,10));
                          End;
      tHTContentType    : fContentType:= InfoText;
      tHTContentEncoding: if InfoText='7BIT'
                            then fContentEncoding:=BIT7
                            else fContentEncoding:=BIT8;
      tHTXUIDL          : fXUIDL  := InfoText;
      tHTReplyTO        : fReplyTO:=InfoText;
      tHTXOriginatingIP : fXOriginatingIP:=InfoText;
    End;
CaseEnd:
    OldHeaderTyp:=HeaderTyp;
  Until Zeile[0] = #0;
  fStreamHeaderLen:=iMailStream.Position;
End;

constructor tcMailHeader.Create;

Begin
  inherited Create;
  fReceived.Create;
  fMailTo.Create;
  fMailCC.Create;
End;


destructor tcMailHeader.Destroy;

Begin
  fReceived.Destroy;
  fMailTo.Destroy;
  fMailCC.Destroy;
  inherited Destroy;
End;


{ -------------------------------------------------------------------------------- }

Procedure tcMail.SetMailStream(iMailStream : tMemoryStream);

Begin
  fHeader.SetMailStream(iMailStream);
Writeln(fHeader.StreamHeaderLen);

//  fBody.SetMailStream(iMailStream, fHeader.StreamHeaderLen);
End;

constructor tcMail.Create;

Begin
  inherited Create;
  fHeader.Create;
End;


destructor tcMail.Destroy;

Begin
  fHeader.Destroy;
  inherited Destroy;
End;


{ -------------------------------------------------------------------------------- }

Initialization
  {Klassen registrieren}
  RegisterClasses([tPop3Client]);
End.


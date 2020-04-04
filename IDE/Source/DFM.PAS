
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Visual Development Environment                                 บ
 บ                                                                          บ
 บ     Copyright (C) 1995,99 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ Sibyl Integrated Development Environment (IDE)                           บ
 บ Object-oriented development system.                                      บ
 บ                                                                          บ
 บ Copyright (C) 1995,99 SpeedSoft GbR, Germany                             บ
 บ                                                                          บ
 บ This program is free software; you can redistribute it and/or modify it  บ
 บ under the terms of the GNU General Public License (GPL) as published by  บ
 บ the Free Software Foundation; either version 2 of the License, or (at    บ
 บ your option) any later version. This program is distributed in the hope  บ
 บ that it will be useful, but WITHOUT ANY WARRANTY; without even the       บ
 บ implied warranty of MERCHANTABILITY or FITNESS for A PARTICULAR          บ
 บ PURPOSE.                                                                 บ
 บ See the GNU General Public License for more details. You should have     บ
 บ received a copy of the GNU General Public License along with this        บ
 บ program; if not, write to the Free Software Foundation, Inc., 59 Temple  บ
 บ Place - Suite 330, Boston, MA 02111-1307, USA.                           บ
 บ                                                                          บ
 บ In summary the original copyright holders (SpeedSoft) grant you the      บ
 บ right to:                                                                บ
 บ                                                                          บ
 บ - Freely modify and publish the sources provided that your modification  บ
 บ   is entirely free and you also make the modified source code available  บ
 บ   to all for free (except a fee for disk/CD production etc).             บ
 บ                                                                          บ
 บ - Adapt the sources to other platforms and make the result available     บ
 บ   for free.                                                              บ
 บ                                                                          บ
 บ Under this licence you are not allowed to:                               บ
 บ                                                                          บ
 บ - Create a commercial product on whatever platform that is based on the  บ
 บ   whole or parts of the sources covered by the license agreement. The    บ
 บ   entire program or development environment must also be published       บ
 บ   under the GNU General Public License as entirely free.                 บ
 บ                                                                          บ
 บ - Remove any of the copyright comments in the source files.              บ
 บ                                                                          บ
 บ - Disclosure any content of the source files or use parts of the source  บ
 บ   files to create commercial products. You always must make available    บ
 บ   all source files whether modified or not.                              บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
UNIT DFM;

//Delphi 2.0 Form Import
//Nov-06 RG bis und mit Delphi 7 mit Einschrnkungen:
//          - Datenbank,WideString (alles noch kaum von Bedeutung)...

INTERFACE

USES Dos, SysUtils, Classes, Forms, StdCtrls, Buttons, ExtCtrls,
     Dialogs, Editors, Graphics,
     Consts,Sib_Ctrl,Sib_Prj,Projects,Inspect,Sib_Edit,Form_Gen,
     ComCtrls,TabCtrls,
     uSysInfo,
     uStream, uString, uList;

procedure Import;

IMPLEMENTATION

CONST
     Prop_Unsigned  =$80;
     Prop_Signed    =$81;
     Prop_Float     =$82;
     Prop_Class     =$83;
     Prop_String    =$84; //132
     Prop_Enum      =$85;
     Prop_Set       =$86;
     Prop_Boolean   =$87;
     Prop_Char      =$88;
     Prop_CString   =$89;
     Prop_ClassVar  =$8a;
     Prop_ProcVar   =$8b;
     Prop_FuncVar   =$8c;
     Prop_Record    =$8d;
     Prop_Link      =$8e; //only used for SCU
     Prop_AnsiString=$8f; //bringt Exception


CONST
    FilerSignature: array[1..4] of Char = 'TPF0';

TYPE
    EDFMError=CLASS(Exception);

    //Nov-06 RG um die die Typen vaSingle..vaUTF8String erweitert
    TValueType = (vaNull, vaList, vaInt8, vaInt16, vaInt32, vaExtended,
                  vaString, vaIdent, vaFalse, vaTrue, vaBinary, vaSet, vaLString,
                  vaNil, vaCollection,
                  vaSingle, vaCurrency, vaDate, vaWString,vaInt64,vaUTF8String);


    TFilerFlag = (ffInherited, ffChildPos);
    TFilerFlags = set of TFilerFlag;

    PLongInt=^LONGINT;

    TMethod=RECORD
                  Code,Data:POINTER;
            end;


TYPE TPublicComponent=CLASS(TComponent)
        procedure Loaded;OVERRIDE;
        procedure LoadedFromSCU(SCUParent:TComponent);OVERRIDE;
        procedure LoadingFromSCU(SCUParent:TComponent);OVERRIDE;
     end;

TYPE
   PPropertyLink=^TPropertyLink;
   TPropertyLink=RECORD
                       Name:string;
                       Instance:TObject;
                       WriteKind:BYTE;
                       WriteProc:POINTER;
                       Next:PPropertyLink;
                 end;


var PropertyLinks:PPropertyLink;

var LastTabbedNoteBook:TTabbedNoteBook;
    LastNoteBook:TNoteBook;
    LastNoteBookHeight:LongInt;
    LastPanel:TPanel; //Nov-06 RG

procedure AddPropertyLink(CONST Name:string;Instance:TObject;WriteKind:BYTE;
                                WriteProc:POINTER);
var dummy:PPropertyLink;
begin
  New(Dummy);
  Dummy^.Name:=Name;
  Dummy^.Instance:=Instance;
  Dummy^.WriteKind:=WriteKind;
  Dummy^.WriteProc:=WriteProc;
  Dummy^.Next:=PropertyLinks;
  PropertyLinks:=dummy;
end;

procedure TPublicComponent.Loaded;
begin
  Inherited Loaded;
end;

procedure TPublicComponent.LoadedFromSCU(SCUParent:TComponent);
begin
  Inherited LoadedFromSCU(SCUParent);
end;

procedure TPublicComponent.LoadingFromSCU(SCUParent:TComponent);
begin
  Inherited LoadingFromSCU(SCUParent);
end;

var LastSCUForm:TForm;

var ActNameTable:POINTER;

function GetPropInfo(Instance:TObject;CONST FPropName:string):POINTER;
var
   s,s1:string;
   p:^longint;
   classinfo:^longint;
LABEL again;
begin
  result:=nil;
  s:=FPropName;
  UpcaseStr(s);
  p:=pointer(Instance);
  p:=pointer(p^);       {vmt}
  inc(p,4);
  classInfo:=pointer(p^);       {classInfo}
again:
  p:=classInfo;
  inc(p,12);
  p:=pointer(p^);               {PropertyInfo}
  inc(p,4);
  ActNameTable:=pointer(p^);
  inc(p,4);
  while p^ and 255<>0 DO
  begin
       move(p^,s1,p^ and 255+1);  //Property Name
       UpcaseStr(s1);
       if s1=s then {found}
       begin
           inc(p,length(s1)+1+1); {Name+Scope}
           result:=pointer(p^); {Property type info starting with len}
           exit;
       end;

       inc(p,length(s1)+1+1+4);    {Name+Scope+TypeInfo}
  end;

  {try to process parent}
  p:=ClassInfo;
  inc(p,4);
  if p^<>0 then
  begin
    ClassInfo:=pointer(p^);         {Parent vmt}
    inc(ClassInfo,4);
    ClassInfo:=pointer(ClassInfo^); {Parent ClassInfo}
    goto again;
  end;
end;


procedure GetClassPropertyValue(I: TComponent;var Value;PropInfo:POINTER);
var p:pointer;
    Fresult:LONGINT;
    Func:function(SelfObj:TObject):LONGINT;
    PropReadWriteSpec:^LONGINT;
    ReadKind:BYTE;
    ReadProc:Pointer;
begin
  PropReadWriteSpec:=PropInfo;   {Save this pointer}
  ReadKind:=PropReadWriteSpec^ and 255;    {0-not avail, 1-variable, 2-proc}
  inc(PropReadWriteSpec);
  ReadProc:=pointer(PropReadWriteSpec^);

  if ReadKind=0 then RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_WRITEONLY));

  if ReadKind=1 then {variable}
  begin
    p:=pointer(I);
    inc(p,longword(ReadProc));
    move(p^,Value,4);
  end
  else
  begin  {method}
    if ReadKind=2 then
    begin
         Func:=ReadProc;
         Fresult:=Func(I);
    end
    else
    begin
         ASM
            PUSH DWORD PTR I
            MOV EAX,ReadProc
            CALLN32 SYSTEM.!VmtCall
            MOV FResult,EAX
         end;
    end;
    move(Fresult,Value,4);
  end;
end;

procedure SetupDFM(Form:TForm;CONST FileName:string);
var Stream:TFileStream;

    function ReadValue: TValueType;
    begin
      fillchar(result,SizeOf(result),0);
      Stream.Read(Result,1); {!!}
    end;

    function ReadInteger: Longint;
    var S: Shortint;
        I: Integer;
    begin
      case ReadValue of
        vaInt8: begin
                  Stream.Read(S, 1);
                  Result := S;
                end;
        vaInt16:begin
                  Stream.Read(I,2);
                  Result := I;
                end;
        vaInt32:Stream.Read(Result, SizeOf(Result));
        vaInt64:Raise EDFMError.Create(LoadNLSStr(SiIllegalIntegerValue)+'(vaInt64)');
        else Raise EDFMError.Create(LoadNLSStr(SiIllegalIntegerValue));
      end;
    end;

    function NextValue: TValueType;
    begin
      Result := ReadValue;
      Stream.Position:=Stream.Position-1;
    end;

    function ReadStr: string;
    var L: Byte;
    begin
      Stream.Read(L,SizeOf(Byte));
      Result[0] := chr(L);
      Stream.Read(Result[1],L);
      L:=pos('&',Result);
      while L<>0 DO
      begin
        Result[L] := '~';
        L := Pos('&',result);
      end;
      //{$ifdef OS2}
      //  StrAnsiToOem(Result);
      //{$endif}
    end;

    procedure ReadPrefix(var Flags: TFilerFlags; var AChildPos:LONGINT);
    var
       Prefix: Byte;
    begin
      Flags := [];
      if Byte(NextValue) and $F0 = $F0 then
      begin
           Prefix := Byte(ReadValue);
           Byte(Flags) := Prefix and $0F;
           if ffChildPos in Flags then AChildPos := ReadInteger;
      end;
    end;

    function ReadIdent: string;
    var L: Byte;
    begin
      case ReadValue of
        vaIdent:begin
                  Stream.Read(L, SizeOf(Byte));
                  Result[0]:=chr(L);
                  Stream.Read(Result[1], L);
                end;
        vaFalse:Result := 'False';
        vaTrue:Result := 'True';
        vaNil:Result := 'nil';
        else RAISE EDFMError.Create(LoadNLSStr(SiIllegalIdentValue));
      end;
    end;

    procedure CheckValue(Value: TValueType);
    begin
      if ReadValue <> Value
      then RAISE EDFMError.Create(LoadNLSStr(SiValueCheckFailed));
    end;

    function ReadChar: Char;
    begin
      CheckValue(vaString);
      Stream.Read(Result, 1);
      if Ord(Result) <> 1 then RAISE EDFMError.Create(LoadNLSStr(SiIllegalChar));
      Stream.Read(Result, 1);
    end;

    function ReadFloat: Extended;
    begin
      if ReadValue = vaExtended
      then Stream.Read(Result, SizeOf(Result))
      else begin
             Stream.Position:=Stream.Position-1;
             Result := ReadInteger;
           end;
    end;

    function ReadString: string;
    var L : LONGINT;
        value : TValueType;
    begin
      L := 0;
      value := ReadValue;
      case value of
        vaString   : Stream.Read(L, SizeOf(Byte));
        vaLString  : Stream.Read(L, SizeOf(LongInt));
        vaIdent    : Stream.Read(L, SizeOf(Byte));
        vaWString  : begin
                       RAISE EDFMError.Create(LoadNLSStr(SiIllegalString)+'(vaWString)');
                     end;
        vaUTF8String:Stream.Read(L, SizeOf(LongWord));
        else RAISE EDFMError.Create(LoadNLSStr(SiIllegalString));
      end;
      Result[0]:=chr(L);
      Stream.Read(Result[1], ord(Result[0]));

      if value = vaUTF8String
      then begin
             Result := UTF8ToAnsi(Result);
             //nur bei UTF8-String und nur bei OS/2 ??
             {$ifdef OS2}
               StrAnsiToOem(Result);
             {$endif}
           end;

      // Zeichen '&' ersetzen duch '~'
      L:=pos('&',Result);
      while L<>0 do
      begin
        Result[L]:='~';
        L:=Pos('&',result);
      end;
    end;

    function ReadSet(SetType: Pointer):LONGINT;
    var EnumName: string;
    begin
      if ReadValue <> vaSet then RAISE EDFMError.Create(LoadNLSStr(SiIllegalSet));
      {???}
      {EnumType := GetTypeData(SetType)^.CompType;}
      Result := 0;
      while True DO
      begin
        EnumName := ReadStr;
        if EnumName = '' then Break;
        {???}
        {Include(TIntegerSet(Result), EnumValue(EnumType, EnumName));}
      end;
    end;

    procedure SkipPropValue;
    var L:LONGINT;
        b:TValueType;
        EnumName:string;
        p:POINTER;
    begin
      L:=0;
      b:=ReadValue;
      case b of
        vaNull :;
        vaList:begin
                 while NextValue<>vaNull DO SkipPropValue;
                 ReadValue;  //overread vaNull
               end;
        vaInt8 :Stream.Position:=Stream.Position+1;       //1Byte
        vaInt16:Stream.Position:=Stream.Position+2;       //2Byte
        vaInt32:Stream.Position:=Stream.Position+4;       //4Byte
        vaExtended:Stream.Position:=Stream.Position+10;   //oder SizeOf(Extended)
        vaString:begin
                   Stream.Read(L,SizeOf(Byte));
                   Stream.Position:=Stream.Position+L;
                 end;
        vaIdent:ReadStr;
        vaFalse:;
        vaTrue:;
        vaBinary:begin
                   Stream.Read(L,4); //length of binary data
                   GetMem(p,L);
                   Stream.Read(p^,L);
                   FreeMem(p,L);
                 end;
        vaSet:begin
                while True DO
                begin
                  EnumName := ReadStr;
                  if EnumName = '' then Break;
                end;
              end;
        vaLString:begin
                    Stream.Read(L, SizeOf(LONGINT));  //4Byte
                    Stream.Position:=Stream.Position+L;
                  end;
        vaNIL:;
        vaCollection:begin
                       while NextValue<>vaNull DO
                       begin
                         if NextValue<>vaList then Raise EDFMError.Create(LoadNLSStr(SiIllegalCollection));
                         ReadValue;  //Overrread vaList (1)
                         while NextValue<>vaNull DO
                         begin
                           ReadStr;  //skip property name
                           SkipPropValue;
                         end;
                         ReadValue; //overread vaNull
                       end;
                       ReadValue;  //overread vaNull
                     end;
        vaSingle:Stream.Position:=Stream.Position+SizeOf(Single);
      //vaCurrency
        vaDate:Stream.Position:=Stream.Position+SizeOf(TDateTime);
       {vaWString:begin
                    Stream.Read(L,4); //length
                    GetMem(p,L*sizeof(WideChar));
                    Stream.Read(p^,L*sizeof(WideChar));
                    FreeMem(p,L*sizeof(WideChar));
                  end;}
        vaInt64:Stream.Position:=Stream.Position+8;       //8Byte
        vaUTF8String:begin
                       Stream.Read(L, SizeOf(LongWord));  //4Byte
                       Stream.Position:=Stream.Position+L;
                     end;
        else begin
               RAISE EDFMError.Create(FmtLoadNLSStr(SiIllegalValueType,[tostr(ord(b))]));
             end;
     end;
    end;

    procedure ReadPropValue(Instance:TObject;PropInfo: Pointer;CONST PropName:string);
    const
      NilMethod: TMethod = (Code: nil; Data: nil);
    var
      PropType: ^longint;
      TypeLen:longword;
      TypeKind:Byte;
      WriteKind:Byte;
      WriteProc:Pointer;
      lll:longint;
      e:Extended;
      ss:shortstring;
      aValue:TValueType;
      s,s1,Params:string;
      b:LONGINT;
      p1:^LONGINT;
      ps:^string;
      Info:TPropertyTypeInfo;
      Ok:BOOLEAN;

      procedure SetPropertyValue(I:TObject;CONST value);
      var p:^longint;
          Proc:procedure(Value:LONGWORD;SelfObj:TObject);
          ProcVar:procedure(Value:POINTER;SelfObj:TObject);
          pb:^LONGWORD;
          pw:^WORD;
          pl:^LONGWORD;
          l:LONGWORD;
          temp:^string;
          tempAnsi:AnsiString;
      begin
         if WriteKind=1 then {Variable}
         begin
            p:=pointer(I);
            inc(p,longword(WriteProc));
            move(Value,p^,TypeLen);
         end
         else {Method}
         begin
           case TypeKind of
              Prop_AnsiString:
              begin
                temp:=@Value;
                tempAnsi:=temp^;
                if WriteKind=2 then
                begin
                  ProcVar:=pointer(WriteProc);
                  ProcVar(@TempAnsi,I);
                end
                else
                begin
                  l:=LONGWORD(WriteProc);
                  ASM
                     LEA EAX,TempAnsi
                     PUSH EAX
                     PUSH DWORD Ptr I
                     MOV EAX,l
                     CALLN32 SYSTEM.!VMTCALL
                  end;
                end;
              end;
              Prop_Signed,Prop_Unsigned,Prop_Class,Prop_Enum,Prop_Boolean,Prop_Char,Prop_ClassVar:
              begin
                Proc := pointer(WriteProc);
                case TypeLen of
                  1: begin
                       pb:=@Value;
                       l:=pb^;
                     end;
                  2: begin
                       pw:=@Value;
                       l:=pw^;
                     end;
                  4: begin
                       pl:=@Value;
                       l:=pl^;
                     end
                  else RAISE EDFMError.Create(LoadNLSStr(SiIllegalIntegerSize));  //no valid type size for VAL
                end; {case}

                if WriteKind=2 then
                begin
                  Proc(l,I);
                end
                else
                begin
                  ASM
                     PUSH DWORD PTR l
                     PUSH DWORD PTR I
                     MOV EAX,Proc
                     CALLN32 SYSTEM.!VMTCALL
                  end;
                end;
              end;
              Prop_Float,Prop_String,Prop_Set,Prop_CString,Prop_Record,Prop_ProcVar,Prop_FuncVar:
              begin
                if WriteKind=2 then
                begin
                  ProcVar:=pointer(WriteProc);
                  ProcVar(@Value,I);
                end
                else
                begin
                  l:=LONGWORD(WriteProc);
                  ASM
                     MOV EAX,Value
                     PUSH EAX
                     PUSH DWORD PTR I
                     MOV EAX,l
                     CALLN32 SYSTEM.!VMTCALL
                  end;
                end;
              end;
              else RAISE EDFMError.Create(LoadNLSStr(SiIllegalPropertyType));  //no valid type
           end; {case}
         end;
      end;

      function GetIntIdent(PropInfo: Pointer; CONST Ident: string;var ok:BOOLEAN):longint;
      var
        t,Start,Ende: Longint;
        ss,ss1: string;
        PropType:^longint;
        TypeLen:longint;
        TypeKind:Byte;
        pss:^String;
      begin
        ss := Ident;
        UpcaseStr(ss);
        Ok:=FALSE;

        //Problem Borderstyle=bsDialog behoben : nicht nach fbs... umwandeln
        //if ((ss='BSNONE')OR(ss='BSSINGLE')OR(ss='BSSIZEABLE')OR(ss='BSDIALOG')) then
        //  ss:='F'+ss;  {fbsNone,fbsSingle,fbsSizeable,fbsDialog}

        PropType:=PropInfo;
        //Skip read and write access infos
        if PropType^ and 255<>0 then inc(PropType,5)
        else inc(PropType);
        if PropType^ and 255<>0 then inc(PropType,5)
        else inc(PropType);

        TypeLen:=PropType^;
        inc(PropType,4);
        TypeKind:=PropType^ and 255;
        inc(PropType);

        if TypeKind=Prop_Enum then
        begin
          Start:=PropType^;
          inc(PropType,4);
          Ende:=PropType^;
          inc(PropType,4);
          for t:=Start TO Ende DO
          begin
            pss:=pointer(ActNameTable);
            inc(pss,PropType^);
            inc(PropType,4);
            ss1:=pss^;
            UpcaseStr(ss1);
            if ss=ss1 then
            begin
              result:=t;
              Ok:=TRUE;
              exit;
            end;
          end;
        end
        else
        begin
          while PropType^<>0 DO
          begin
            pss:=pointer(ActNameTable);
            inc(pss,PropType^);
            inc(PropType,4);
            ss1:=pss^;
            UpcaseStr(ss1);
            if ss=ss1 then
            begin
              result:=PropType^;
              Ok:=TRUE;
              exit;
            end;
            inc(PropType,4);  //overread value
          end;
        end;

        ErrorBox(FmtLoadNLSStr(SiIllegalIdent,[Ident]));
      end;


      procedure SetObjectIdent(Instance: TObject; PropInfo: Pointer;CONST Ident: string);
      var
        RootName, Name: string;
        P: Integer;
      begin
        RootName := '';
        Name := Ident;
        P := Pos('.', Ident);
        if P <> 0 then
        begin
          RootName := Copy(Ident, 1, P - 1);
          Name := Copy(Ident, P + 1, MaxInt);
        end;

        AddPropertyLink(Name,Instance,WriteKind,WriteProc);
      end;

    begin  //ReadPropValue
      PropType:=PropInfo;

      if not Instance.GetPropertyTypeInfo(PropName,Info) then RAISE EDFMError.Create('PropertyTypeInfo not found');

      TypeLen:=Info.Size;
      TypeKind:=Info.Typ;

      WriteKind:=Info.Write.Kind; {0-not avail, 1-variable, 2-proc, 3-VMT proc}
      WriteProc:=pointer(Info.Write.VarOffset);

    {?????}
      case TypeKind of
        Prop_Signed,Prop_Unsigned:
        begin
          Ok:=TRUE;
          if NextValue = vaIdent then lll:=GetIntIdent(PropInfo,ReadIdent,Ok)
                                 else lll:=ReadInteger;
          if ok then
          begin
            if WriteKind=0 then RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_WRITEONLY));
            SetPropertyValue(Instance,lll);
          end;
        end;
        Prop_Boolean:
        begin
          aValue:=ReadValue;
          if aValue=vaFalse then lll:=0
          else if aValue=vaTrue then lll:=1
          else RAISE EDFMError.Create(LoadNLSStr(SiIllegalBoolean));
          if WriteKind=0 then RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
          SetPropertyValue(Instance,lll);
        end;
        Prop_Char:
        begin
          lll:=ord(ReadChar);
          if WriteKind=0 then RAISE EDFMError.Create('');
          SetPropertyValue(Instance,lll);
        end;
        Prop_Enum:
        begin
          lll:=GetIntIdent(PropInfo,ReadIdent,Ok);
          if Ok then
          begin
             if WriteKind=0 then RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
             SetPropertyValue(Instance, lll);
          end;
        end;
        Prop_Float:
        begin
          e:=ReadFloat;
          if WriteKind=0 then RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
          SetPropertyValue(Instance, e);
        end;
        Prop_String,Prop_AnsiString:
        begin
          ss := ReadString;
          if WriteKind=0 then RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
          SetPropertyValue(Instance, ss);
        end;
        Prop_Set:
        begin
          lll:=ReadSet(PropType);
          if WriteKind=0 then RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
          SetPropertyValue(Instance, lll);
        end;
        Prop_Class:
        begin
          case NextValue of
            {
            vaNIL:
            begin
            end;
            }
            vaIdent:
            begin
               if WriteKind=0 then RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
               SetObjectIdent(Instance, PropInfo, ReadIdent);
            end;
            else SkipPropValue;
          end; //case
        end;
        Prop_ProcVar,Prop_FuncVar:
        begin
          if NextValue = vaNil then
          begin
            ReadValue;
            if WriteKind=0 then RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
            //SetPropertyValue(Instance, NilMethod);
          end
          else
          begin
            s:=ReadIdent;

            if WriteKind=0 then RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
            //if Instance.IDESCU_Data=NIL then New(PIDESCU_Data(Instance.IDESCU_Data));

            p1:=PropType;

            //Skip read and write access infos
            if p1^ and 255<>0 then inc(p1,5)
            else inc(p1);
            if p1^ and 255<>0 then inc(p1,5)
            else inc(p1);
            inc(p1,4);
            inc(p1);

            b:=p1^;
            inc(p1,4);  //Name (Index)
            Params:='';
            while b<>0 DO
            begin
              if Params<>'' then Params:=Params+';';
              ps:=ActNameTable+b;
              s1:=ps^;

              b:=p1^ and 255;
              inc(p1);
              case b of
                1:s1:=Key(_VAR_)+' '+s1;
                2:;
                3:s1:=Key(_CONST_)+' '+s1;
              end;

              Params:=Params+s1;
              b:=p1^;         //TypeName
              inc(p1,4);      //Name (Index)
              if b<>0 then
              begin
                ps:=ActNameTable+b;
                s1:=ps^;
                Params:=Params+':'+s1;
              end;

              b:=p1^;
              inc(p1,4);  //Name (Index)
            end; //while

            if Params='' then Params:=';'
            else Params:='('+Params+');';
            InsertMethodValid(LastSCUForm,TControl(Instance),PropName,s,Params);
          end;
        end;
      end;
    end;

    procedure ReadBitmap(Instance,Component:TComponent;PropName:string);
    var Bitmap:TBitmap;
        Len:LONGINT;
        p:Pointer;
        Info:TPropertyTypeInfo;
        s:string;
    begin
      ReadValue;           //skip vaBinary
      Stream.Read(Len,4);  //Binary data len

      if Component IS TImage
      then begin
             //skip bitmap name
             s:=ReadStr;
             PropName:='Picture';
           end
      else s:='';

      if ((Instance IS TIcon) OR (s='TIcon'))
      then Len:=766
      else Stream.Read(Len,4);  //Bitmap len
      GetMem(p,Len);
      Stream.Read(p^,Len);

      if ((Instance IS TIcon) OR (s='TIcon'))
      then Bitmap := TIcon.Create
      else Bitmap.Create;

      try
        Bitmap.LoadFromMem(p^,Len);
      except
        ErrorBox(LoadNLSStr(SiIncompatibleIconBitmapFormat));
        Bitmap.Destroy;
        Bitmap:=NIL;
      end;

      FreeMem(p,Len);
      if not Component.GetPropertyTypeInfo(PropName,Info) then exit;

      case Info.Write.Kind of
        1:begin
            p:=pointer(Component);
            inc(p,longword(Info.Write.VarOffset));
            move(Bitmap,p^,4);
          end;
        2,3:CallWriteProp(Component,Pointer(Info.Write.VarOffset),Info.Typ,4,@Bitmap);
      end; {case}

      if Bitmap<>NIL then Bitmap.Destroy;
    end;

    procedure ReadStringList(List:TStrings);
    begin
      ReadValue;           //skip vaList
      if ((NextValue<>vaString)and(NextValue<>vaLString))
      then begin
             Stream.Position:=Stream.Position-1;
             SkipPropValue;
           end
      else begin
             List.BeginUpdate;
             while NextValue<>vaNull DO List.Add(ReadString);
             List.EndUpdate;
             ReadValue;           //skip vaNull
           end;
    end;

    procedure ReadCollection(Collection:TCollection);
    var PropName:string;
        Item:TCollectionItem;
        PropInfo: POINTER;
        Col:TValueType;
    begin
      Col:=ReadValue;           //skip vaCollection

      if Col=vaList
      then begin
             while NextValue<>vaNull DO
             begin
               Item:=Collection.Add;

               try
                 if Item<>NIL then PropInfo := GetPropInfo(Item,'Text')
                              else PropInfo:=NIL;
               except
                 PropInfo:=NIL;
               end;

               if PropInfo<>NIL then ReadPropValue(Item,PropInfo,'Text')
                                else SkipPropValue;
             end;
           end
      else while NextValue<>vaNull DO
           begin
             if NextValue<>vaList then Raise EDFMError.Create(LoadNLSStr(SiIllegalCollection));

             ReadValue;  //skip vaList

             while NextValue<>vaNull DO
             begin
               Item:=Collection.Add;
               PropName:=ReadStr;  //get Property Name

               try
                 if Item<>NIL then PropInfo := GetPropInfo(Item,PropName)
                              else PropInfo:=NIL;
               except
                 PropInfo:=NIL;
               end;

               if PropInfo<>NIL then ReadPropValue(Item,PropInfo,PropName)
                                else SkipPropValue;
             end;
             ReadValue;  //skip vaNull
           end;
      ReadValue;  //skip vaNull
    end;

    procedure ReadProperty(Component:TComponent;var Left,Top,Width,Height:LONGINT);
    var PropPath:string;
        I,L,J:LONGINT;
        Instance:TComponent;
        FPropName:string;
        PropInfo: POINTER;
        PropValue: TObject;
        TypeKind:^Byte;
        Info:TPropertyTypeInfo;

    LABEL lab1;

    begin
      PropPath:=ReadStr;   //Font.Color
      I:=1;
      L:=Length(PropPath);
      Instance:=Component;
      while True DO
      begin
        J := I;
        while (I <= L) and (PropPath[I] <> '.') DO Inc(I);
        FPropName := Copy(PropPath, J, I - J);
        if I > L then Break;

        PropInfo := GetPropInfo(Component,FPropName);
        if PropInfo=NIL then
        begin
          Instance:=NIL;
          break;
        end;

        PropValue:=NIL;
        TypeKind:=PropInfo;

        //Skip access infos
        if TypeKind^<>0 then inc(TypeKind,5)
        else inc(TypeKind);
        if TypeKind^<>0 then inc(TypeKind,5)
        else inc(TypeKind);
        inc(TypeKind,4);   {overread type len}

        if TypeKind^ = Prop_Class then
        begin
          GetClassPropertyValue(Instance, PropValue,PropInfo);
        end;

        if not (PropValue IS TComponent) then
        begin
          if ((TObject(PropValue) IS TStrings)and(NextValue=vaList)) then
          begin
            ReadStringList(TStrings(PropValue));
            exit;
          end
          else
          begin
            Instance:=NIL;
            break;
          end;
        end
        else if PropValue IS TCollection then
        begin
          ReadCollection(TCollection(PropValue));
          exit;
        end;
        Instance := TComponent(PropValue);
        Inc(I);
      end;

      try
        if Instance<>NIL then PropInfo := GetPropInfo(Instance,FPropName)
                         else PropInfo:=NIL;
      except
        PropInfo:=NIL;
      end;

      if ((Instance=NIL) OR (Instance.Name='Font')) then
      begin
        if Instance IS TFont then
        begin
          if FPropName='Color' then
          begin
            Instance:=Component;    //z.B. TLabel,TBitBtn.. ?
            FPropName:='PenColor';
            if Instance.GetPropertyTypeInfo(FPropName,Info) then
            begin
              ActNameTable:=Info.NameTable;
              PropInfo:=Info.PropInfo;

              goto lab1;
            end;
          end;
        end;

        SkipPropValue;
      end
      else if Instance IS TBitmap then
      begin
        if ((FPropName='Data') and (NextValue=vaBinary)) then
        begin
          ReadBitmap(Instance,Component,'Glyph');
        end
        else SkipPropValue;
      end
      else if ((Instance IS THeaderControl)OR(Instance IS TStatusBar)) then
      begin
        if ((FPropName='Panels')and(Instance IS TStatusBar)) then
        begin
          ReadCollection(TStatusBar(Instance).Panels);
          exit;
        end
        else if ((FPropName='Sections')and(Instance IS THeaderControl)) then
        begin
          ReadCollection(THeaderControl(Instance).Sections);
          exit;
        end;

        if PropInfo<>NIL then goto lab1
        else SkipPropValue;
      end
      else if PropInfo <> NIL then
      begin
           if Instance IS TControl then
           begin
lab1:
             if FPropName='Left' then Left:=ReadInteger
             else if FPropName='Top' then Top:=ReadInteger
             else if FPropName='Width' then Width:=ReadInteger
             else if FPropName='Height' then
             begin
               Height:=ReadInteger;
               If ((Component IS TNoteBook)Or(Component IS TTabbedNoteBook)) then
                LastNoteBookHeight:=Height;
             end
             else if FPropName='ClientWidth' then
             begin
               if Instance IS TForm then
               begin
                    ASM
                       PUSH DWORD PTR Instance
                       CALLN32 Forms._GetAddWidth_
                       MOV I,EAX
                    end;
                    Width:=I+ReadInteger;
               end
               else Width:=ReadInteger;
             end
             else if FPropName='ClientHeight' then
             begin
               if Instance IS TForm then
               begin
                    ASM
                       PUSH DWORD PTR Instance
                       CALLN32 Forms._GetAddHeight_
                       MOV I,EAX
                    end;
                    Height:=I+ReadInteger;
               end
               else Height:=ReadInteger;
             end
             else begin
                    ReadPropValue(Instance,PropInfo,FPropName);
                  end;
           end
           else begin
                  ReadPropValue(Instance,PropInfo,FPropName);
                end;
      end
      else
      begin
        //read positions, it might be a reference...
        if NextValue IN [vaInt8,vaInt16,vaInt32,vaInt64] then
        begin
          if FPropName='Left' then Left:=ReadInteger
          else if FPropName='Top' then Top:=ReadInteger
          else if FPropName='Width' then Width:=ReadInteger
          else if FPropName='Height' then
          begin
            Height:=ReadInteger;
            If ((Component IS TNoteBook)Or(Component IS TTabbedNoteBook)) then
              LastNoteBookHeight:=Height;
          end
          else SkipPropValue;
        end
        else SkipPropValue;
      end;
    end;


    procedure ReadState(Component:TComponent;Owner:TComponent);
    var Left,Top,Width,Height:LONGINT;
        ComponentClass:TComponentClass;
        ReferenceControl:TControl;

        procedure SetBounds2(Control:TControl;Left,Top,Width,Height:LONGINT);
        var  Parent:TControl;
             Bottom:LONGINT;
             ParentClientHeight:LONGINT;
        begin
          if not (Control IS TControl) then exit;
          Parent := TControl(Owner);

          if Parent IS TPage then
          begin
            if ((LastTabbedNoteBook<>NIL)OR(LastNoteBook<>NIL)) then
            begin
                 {if LastTabbedNoteBook<>NIL then
                    ParentClientHeight:=LastTabbedNoteBook.PageRect.Top-LastTabbedNoteBook.PageRect.Bottom
                 else
                    ParentClientHeight:=LastNoteBook.ClientRect.Top-LastNoteBook.ClientRect.Bottom;
                 }
                 //subtract NoteBookMargin and TabHeight (hard coded in TabCtrls)
                 ParentClientHeight:=LastNoteBookHeight-10-25;
            end
            else
            begin
              if Parent IS TControl then ParentClientHeight := Parent.ClientHeight
              else ParentClientHeight := Screen.Height;
            end;
          end
          else
          begin
            if Parent IS TControl then ParentClientHeight := Parent.ClientHeight
            else ParentClientHeight := Screen.Height;
          end;

          Bottom := ParentClientHeight - Height - Top;
          Control.SetWindowPos(Left,Bottom-1,Width,Height);
        end;

    begin //ReadState
      Left:=10;
      Top:=200;
      Width:=440;
      Height:=340;
      try
        while NextValue<>vaNull DO ReadProperty(Component,Left,Top,Width,Height);

        if not (Component IS TControl) then
          if ((not (Component IS TComponent))OR(Component.ComponentState*[csReference]<>[])) then
            if Owner IS TControl then
        begin
          ComponentClass:=SearchClassByName('TReferenceWindow');

          ReferenceControl:=TControl(ComponentClass.Create(Owner));
          Include(ReferenceControl.ComponentState,csDesigning);
          Include(ReferenceControl.ComponentState,csReferenceControl);
          ASM
             PUSH DWORD PTR ReferenceControl
             PUSH DWORD PTR Component
             CALLN32 Classes.SetReference
          end;
          ReferenceControl.Parent:=TControl(Owner);
          Width:=ReferenceControl.Width;
          Height:=ReferenceControl.Height;
          Component:=TComponent(ReferenceControl);
        end;
      FINALLY
        if Component IS TControl then
        begin
//              TControl(Component).SetBounds2(Left,Top,Width,Height);
          SetBounds2(TControl(Component),Left,Top,Width,Height);
          TForm(Component).Font:=Screen.SmallFont; {typecast to have access to Font}
        end;
      end;
      CheckValue(vaNull);
    end;

    procedure SkipProperty;
    begin
      ReadStr; { Skips property name }
      SkipPropValue;
    end;

    procedure SkipComponent(SkipHeader: Boolean);
    var
       Flags: TFilerFlags;
       Position: LONGINT;
    begin
      if SkipHeader then
      begin
        ReadPrefix(Flags, Position);
        ReadStr;
        ReadStr;
      end;
      while NextValue<>vaNull DO SkipProperty;
      CheckValue(vaNull);
      while NextValue<>vaNull DO SkipComponent(True);
      CheckValue(vaNull);
    end;


    function ReadComponent(Owner: TComponent): TComponent;
    var
       CompClass, CompName: string;
       Flags: TFilerFlags;
       Position:LONGINT;
       TheClass:TComponentClass;
       Component:TComponent;

       function ComponentCreated: Boolean;
       begin
         Result := not (ffInherited in Flags) and (Component = nil);
       end;

       function Recover(var Component: TComponent): Boolean;
       begin
         Result := False;
         if ComponentCreated then Component.Free;
         Component := nil;
         SkipComponent(False);
         Result := TRUE;
       end;

       procedure CreateComponent;
       begin
         try
            TheClass := TComponentClass(SearchClassByName(CompClass));
            if TheClass=NIL then RAISE EDFMError.Create(FmtLoadNLSStr(SiCompClassNotFound,[CompClass]));
            Result := TheClass.Create(LastSCUForm);
            Include(Result.ComponentState,csDesigning);
            TPublicComponent(Result).LoadingFromSCU(Owner);
            Component:=Result;
         except
            ON E:Exception DO
            begin
                if not Recover(Result) then
                begin
                  raise;
                end
                else ErrorBox(FmtLoadNLSStr(SiConvertError,[E.Message]));
            end;
         end;
       end;

       procedure SetCompName;
       begin
         try
            Result.Name:=CompName;
         except
            if not Recover(Result) then raise;
         end;
       end;

    begin //ReadComponent
      ReadPrefix(Flags, Position);
      CompClass := ReadStr;  //z.B. 'TPanel'
      CompName := ReadStr;   //z.B. 'Panel1'

      Result := NIL;
      Component:=NIL;
      CreateComponent;

      if Result <> nil then
      begin
        //gibt es beim Import von TPanel keine Caption-Definition ist er leer
        //daher vorgngig auf leer setzten
        try
          if Result IS TPanel
          then begin
                 LastPanel:=TPanel(result);
                 LastPanel.Caption := '';
               end;
        except
        end;

        try
          if Result IS TTabbedNoteBook then
          begin
            LastTabbedNoteBook:=TTabbedNoteBook(result);
            LastTabbedNoteBook.ShowPageHint:=False;
          end;
          if Result IS TNoteBook then LastNoteBook:=TNoteBook(result);

          if not (ffInherited in Flags) then SetCompName;
          if Result = nil then Exit;
          ReadState(Result,Owner);
        except
          if ComponentCreated then Result.Free;
          RAISE;
        end;

        try
          while NextValue<>vaNull DO ReadComponent(result);
        except
          if Owner IS TControl then
            if result IS TControl then
              TControl(Owner).InsertControl(TControl(result));
          RAISE;
        end;

        if Owner IS TControl then
          if result IS TControl then
             TControl(Owner).InsertControl(TControl(result));

        CheckValue(vaNull);

        TPublicComponent(result).LoadedFromSCU(Owner);
        TPublicComponent(result).Loaded;
      end;
    end;

var
   Flags:TFilerFlags;
   Position:LONGINT;
   Signature:LONGINT;
   DFMDataLen:LONGINT;
   TypName:string;

begin
  LastTabbedNoteBook:=NIL;
  LastNoteBook:=NIL;
  LastNoteBookHeight:=0;
  try
    Stream:=NIL;
    FileMode:=fmInput;
    Stream:=TFileStream.Create(FileName,Stream_Open);
    FileMode:=fmInOut;

    Stream.Position:=Stream.Position+3;  //skip 3 Byte header
    while ReadValue<>vaNull DO ;         //Skip name
    Stream.Position:=Stream.Position+2;  //skip $3010
    Stream.Read(DFMDataLen,sizeof(DFMDataLen));
    //we are now at TPF0

    Stream.Read(Signature,sizeof(Signature));
    if Signature<>LONGINT(FilerSignature) then RAISE EDFMError.Create('Illegal signature');

    ReadPrefix(Flags,Position);
    TypName:=ReadStr;              //TypeName (TFORM1)
    Form.Name:=ReadStr;            //Name (Form1)

    ReadState(Form,NIL);
    while NextValue<>vaNull DO ReadComponent(Form);
    CheckValue(vaNull);
  FINALLY
    if Stream<>NIL then Stream.Destroy;
  end;
end;

procedure HandlePropertyLinks(Form:TForm);
var Next:PPropertyLink;
    p:POINTER;
    Proc:procedure(Value:LONGWORD;SelfObj:TObject);
    Instance:TObject;
    Component:TComponent;
    t:LONGINT;
begin
     while PropertyLinks<>NIL DO
     begin
        for t:=0 TO Form.ComponentCount-1 DO
        begin
          Component:=Form.Components[t];
          if Component.Name=PropertyLinks^.Name then
          begin
               if PropertyLinks^.WriteKind=1 then {Variable}
               begin
                 p:=pointer(PropertyLinks^.Instance);
                 inc(p,longword(PropertyLinks^.WriteProc));
                 move(Component,p^,4);
               end
               else {Method}
               begin
                 Proc:=pointer(PropertyLinks^.WriteProc);
                 Instance:=PropertyLinks^.Instance;

                 if PropertyLinks^.WriteKind=2 then
                 begin
                   Proc(LongWord(Component),Instance);
                 end
                 else
                 begin
                   ASM
                      PUSH DWORD PTR Component
                      PUSH DWORD PTR Instance
                      MOV EAX,Proc
                      CALLN32 SYSTEM.!VMTCALL
                   end;
                 end;
               end;
             end;
        end;
        Next:=PropertyLinks^.Next;
        Dispose(PropertyLinks);
        PropertyLinks:=Next;
     end;
end;

function ImportDFM(dfmName:string; var UnitName:string):TForm;
var  d,n,e:string;
     Add:LONGINT;
begin
  Result := NIL;
  PropertyLinks:=NIL;

  FSplit(dfmName,d,n,e);
  UnitName := d + n + '.PAS';
  if not FileExists(UnitName) then
  begin
    ErrorBox(FmtLoadNLSStr(SiCouldNotFindRelUnit,[UnitName]));
    exit;
  end;

  Result := FormEditClass.Create(NIL);
  Include(Result.ComponentState,csDesigning);
  LastSCUForm:=Result;
  TPublicComponent(Result).LoadingFromSCU(NIL);
  try
    SetupDFM(Result,dfmName);
  except
    ON Ex:Exception DO ErrorBox(FmtLoadNLSStr(SiConvertError,[Ex.Message]));
  end;
  Include(Result.DesignerState,dsAutoCreate); //all Delphi forms are auto-created !
  HandlePropertyLinks(Result);
  TPublicComponent(Result).LoadedFromSCU(NIL);
  TPublicComponent(Result).Loaded;

  if Result.Menu<>NIL then
  begin
    if Result.Menu.Handle<>0 then Add:=Result.Menu.Height
    else Add:=goSysInfo.Screen.MenuSize;

    //Realign controls because client height changed
    Result.Height:=Result.Height+Add;
  end;
end;


TYPE
    TSelectSCUDlg=CLASS(TDialog)
         FListBox:TListBox;
         procedure SetupComponent;OVERRIDE;
    end;

procedure TSelectSCUDlg.SetupComponent;
begin
  Inherited SetupComponent;

  Caption := LoadNLSStr(SiSelectAFormToImport);
  ClientWidth := 350;
  ClientHeight := 250;

  FListBox := InsertListBox(SELF,20,70,310,160,'');
  FListBox.Focus;

  InsertBitBtnNLS(SELF,20,20,90,30,bkOk,SOkButton,SClickHereToAccept);
  InsertBitBtnNLS(SELF,130,20,90,30,bkCancel,SCancelButton,SClickHereToCancel);
  InsertBitBtnNLS(SELF,240,20,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
end;

function ImportSCU(SCUName:string;var UnitName:string):TForm;
var  Stream:TMemoryStream;
     Dlg:TSelectSCUDlg;
     dummy:PSCUFileFormat;
     p,p1:^LONGINT;
     s,s1:string;
     SaveSCU:POINTER;
     t:LONGINT;

LABEL Found;

begin
     Result := NIL;

     try
        SaveSCU := SCUPointer;
        Stream.Create;
        Stream.LoadFromFile(SCUName);

        Dlg.Create(NIL);
        Dlg.HelpContext := hctxDialogSelectSCU;

        dummy := Pointer(Stream.Memory);

        //This modifies SCUPointer
        ASM
           PUSH DWORD PTR dummy
           CALLN32 SYSTEM.AddSCUData
        end;

        dummy:=SCUPointer;
        while dummy<>NIL DO
        begin
          p := Pointer(dummy);
          inc(p,dummy^.ObjectOffset);
          for t := 1 TO dummy^.ObjectCount DO
          begin
            p1 := p;

            inc(p,4);
            inc(p,(p^ and 255)+1);            //overread inspector class name
            System.Move(p^,s,(p^ and 255)+1); //runtime class name
            Dlg.FListBox.Items.Add(s);

            p := p1;
            inc(p,p^);
          end;

          dummy:=dummy^.NextEntry;
        end;

        if Dlg.FListBox.Items.Count > 0 then Dlg.FListBox.ItemIndex := 0;

        if (Dlg.Execute) and (Dlg.FListBox.ItemIndex >= 0) then
        begin
             s1:=Dlg.FListBox.Items[Dlg.FListBox.ItemIndex];

             dummy:=SCUPointer;
             while dummy<>NIL DO
             begin
               p := Pointer(dummy);
               inc(p,dummy^.ObjectOffset);
               for t := 1 TO dummy^.ObjectCount DO
               begin
                 p1 := p;

                 inc(p,4);
                 inc(p,(p^ and 255)+1);            //overread inspector class name
                 System.Move(p^,s,(p^ and 255)+1); //runtime class name
                 if s=s1 then
                 begin
                      SCUPointer:=dummy; {!!}
                      dummy^.UseEntry:=t-1;
                      goto found;
                 end;

                 p := p1;
                 inc(p,p^);
               end;

               dummy:=dummy^.NextEntry;
             end;
found:
             if dummy<>NIL then
             begin
               Result := FormEditClass.Create(NIL);
               UnitName := Result.UnitName;

               if not FileExists(UnitName) then
               begin
                 ErrorBox(FmtLoadNLSStr(SiCouldNotFindRelUnit,[UnitName]));
               end;
             end;
        end;
        Dlg.Destroy;

     except
        if Result <> NIL then Result.Destroy;
        Result := NIL;
        ErrorBox(LoadNLSStr(SiLoadError));
     end;
     Stream.Destroy;
     SCUPointer := SaveSCU;
end;


procedure Import;
var FOD:TOpenDialog;
    ret:BOOLEAN;
    s,d,n,e:string;
    UnitName:string;
    Form:TForm;
begin
  FOD.Create(NIL);
  FOD.HelpContext := hctxDialogOpenDFMSCU;
  FOD.Caption := LoadNLSStr(SiImportSibylDelphiForm);
  FOD.FileName := '';
  FOD.AddFilter(LoadNLSStr(SiAllFormFiles)+' (*.dfm;*.scu)','*.DFM;*.SCU');
  FOD.AddFilter(LoadNLSStr(SiSibylFormFiles)+' (*.scu)','*.SCU');
  FOD.AddFilter(LoadNLSStr(SiDelphiFormFiles)+' (*.dfm)','*.DFM');
  FOD.DefaultExt := GetDefaultExt('*.DFM;*.SCU');
  ret := FOD.Execute;
  s := FOD.FileName;
  FOD.Destroy;
  Screen.Update;
  if not ret then exit;

  FSplit(s,d,n,e);
  UpcaseStr(e);
  if e = '.DFM' then Form := ImportDFM(s,UnitName) {UnitName ist var}
  else Form := ImportSCU(s,UnitName);

  if Form = NIL then exit;

  if GenImportForm(Form,UnitName,NIL,0) then
  begin
    GenUpdateDFM(Form);

    Project.Modified := TRUE;
    Project.SCUModified := TRUE;
    Project.NeedRecompile := TRUE;

    Form.Show;
    Form.Focus;
  end
  else Form.Destroy;  {Form konnte nicht importiert werden}
end;


begin
end.


{ -- date -- -- from -- -- changes ----------------------------------------------
  10-Nov-06  RG      Problem Borderstyle=bs..... behoben
                     TValueTyp um vaSingle,vaCurrency,vaDate,vaWString,
                       vaInt64,vaUTF8String erweitert.
                     Einlesen von UTF8String, neue Funktion UTF8ToAnsi(Result),
                     SkipPropValue ergnzt: TPanel.Caption - Vorgabe = leer

  offen: Umsetzung von Font.Color nach PenColor funktioniert nicht
         TBitBtn.Glyph.Data -> Grafik anpassen: 'unsichtbarer' Hintergrund
         vaWString
         vaInt64
         TImage.Bitmap      -> Grafik konvertieren (TBitmap)

  wird noch nicht untersttzt: FormStyle=fsStayOnTop (TForm)
                               TLabel.Font.Color
                               TGauge (Beispiele), hnlich TProgressBar

  wird schlecht untersttzt: TScrollBox
  22-Apr-07  RG, WD  Funktion "UTF8ToAnsi" in die Unit uString verschoben.
}
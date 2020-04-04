
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit DualList;

Interface

Uses
  SysUtils,Classes,Forms,Buttons,StdCtrls,
  uString;

Type
  TDualList=Class(TControl)
    Private
       FSrcLabel:TLabel;
       FDstLabel:TLabel;
       FSrcList:TListBox;
       FDstList:TListBox;
       FAddBtn:TSpeedButton;
       FAddAllBtn:TSpeedButton;
       FDelBtn:TSpeedButton;
       FDelAllBtn:TSpeedButton;
       FOnChange:TNotifyEvent;
       Function GetSrcName:String;
       Procedure SetSrcName(Value:String);
       Function GetSrcItems:TStrings;
       Procedure SetSrcItems(Value:TStrings);
       Function GetDstName:String;
       Procedure SetDstName(Value:String);
       Function GetDstItems:TStrings;
       Procedure SetDstItems(Value:TStrings);
       Procedure UpdateButtons;
       Procedure EvItemSelect(Sender:TObject;Index:LongInt);
       Procedure EvAdd(Sender:TObject);
       Procedure EvAddAll(Sender:TObject);
       Procedure EvDel(Sender:TObject);
       Procedure EvDelAll(Sender:TObject);
       Procedure EvSrcDblClick(Sender:TObject);
       Procedure EvDstDblClick(Sender:TObject);
    Protected
       Procedure SetupComponent;Override;
       Procedure SetupShow;Override;
       Procedure Resize;Override;
       Procedure SetFocus;Override;
       Procedure FontChange;Override;
       Property Hint;
    Public
       Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
       Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
       Procedure Clear;

       Property SrcListBox:TListBox Read FSrcList;
       Property DstListBox:TListBox Read FDstList;
       Property XAlign;
       Property XStretch;
       Property YAlign;
       Property YStretch;
    Published
       Property Align;
       Property PenColor;
       Property DstItems:TStrings Read GetDstItems Write SetDstItems;
       Property DstName:String Read GetDstName Write SetDstName;
       Property Enabled;
       Property Font;
       Property ParentPenColor;
       Property ParentFont;
       Property SrcItems:TStrings Read GetSrcItems Write SetSrcItems;
       Property SrcName:String Read GetSrcName Write SetSrcName;
       Property TabOrder;
       Property Visible;
       Property ZOrder;

       Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
       Property OnFontChange;
       Property OnSetupShow;
  End;


Function InsertDualList(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Const SrcName,DstName:String):TDualList;


Implementation


Function InsertDualList(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Const SrcName,DstName:String):TDualList;
Begin
  Result.Create(parent);
  Result.SetWindowPos(Left,Bottom,Width,Height);
  Result.SrcName := SrcName;
  Result.DstName := DstName;
  Result.parent := parent;
End;


Procedure TDualList.Clear;

Begin
  FSrcList.Clear;
  FDstList.Clear;
  UpdateButtons;
end;

Procedure TDualList.SetFocus;
Begin
  Inherited SetFocus;

  FSrcList.CaptureFocus;
End;


Procedure TDualList.FontChange;
Var
  I:LongInt;
Begin
  Inherited FontChange;

  For I := 0 To ControlCount-1 Do Controls[I].Font := Font;
End;


Function TDualList.GetSrcName:String;
Begin
  Result := FSrcLabel.Caption;
End;


Procedure TDualList.SetSrcName(Value:String);
Begin
  FSrcLabel.Caption := Value;
End;


Function TDualList.GetSrcItems:TStrings;
Begin
  Result := FSrcList.Items;
End;


Procedure TDualList.SetSrcItems(Value:TStrings);
Begin
  FSrcList.Items := Value;
End;


Function TDualList.GetDstName:String;
Begin
  Result := FDstLabel.Caption;
End;


Procedure TDualList.SetDstName(Value:String);
Begin
  FDstLabel.Caption := Value;
End;


Function TDualList.GetDstItems:TStrings;
Begin
  Result := FDstList.Items;
End;


Procedure TDualList.SetDstItems(Value:TStrings);
Begin
  FDstList.Items := Value;
End;


Procedure TDualList.UpdateButtons;
Begin
  If Designed Then Exit;
  FAddBtn.Enabled   := FSrcList.ItemIndex >= 0;
  FAddAllBtn.Enabled:= FSrcList.Items.Count > 0;
  FDelBtn.Enabled   := FDstList.ItemIndex >= 0;
  FDelAllBtn.Enabled:= FDstList.Items.Count > 0;
End;


{$HINTS OFF}
Procedure TDualList.EvItemSelect(Sender:TObject;Index:LongInt);
Begin
  UpdateButtons;
End;

Procedure TDualList.EvAdd(Sender:TObject);

Var DstCount,I: LongInt;
    StrItem   : tStrItem;

Begin
  DstCount := FDstList.Items.Count;
  For I := FSrcList.Items.Count-1 DownTo 0 Do
    Begin
      If FSrcList.Selected[I] Then
      Begin
        FDstList.Items.Insert(DstCount, FSrcList.Items[I]);
        FSrcList.Items.Delete(I);
      End;
    End;
  UpdateButtons;
  If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TDualList.EvAddAll(Sender:TObject);
Var DstCount,I:LongInt;
Begin
  Cursor:=crHourGlass;
  FDstList.BeginUpdate;
  FSrcList.BeginUpdate;
  DstCount := FDstList.Items.Count;
  For I := FSrcList.Items.Count-1 DownTo 0 Do
    Begin
      FDstList.Items.Insert(DstCount, FSrcList.Items[I]);
    End;
  FSrcList.Items.Clear;
  UpdateButtons;
  FDstList.EndUpdate;
  FSrcList.EndUpdate;
  Cursor:=crDefault;
  If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TDualList.EvDel(Sender:TObject);
Var
  SrcCount,I:LongInt;
Begin
  SrcCount := FSrcList.Items.Count;
  For I := FDstList.Items.Count-1 DownTo 0 Do
  Begin
    If FDstList.Selected[I] Then
    Begin
      FSrcList.Items.Insert(SrcCount, FDstList.Items[I]);
      FDstList.Items.Delete(I);
    End;
  End;
  UpdateButtons;
  If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TDualList.EvDelAll(Sender:TObject);
Var
  SrcCount,I:LongInt;
Begin
  Cursor:=crHourGlass;
  FDstList.BeginUpdate;
  FSrcList.BeginUpdate;
  SrcCount := FSrcList.Items.Count;
  For I := FDstList.Items.Count-1 DownTo 0 Do
  Begin
    FSrcList.Items.Insert(SrcCount, FDstList.Items[I]);
  End;
  FDstList.Items.Clear;
  UpdateButtons;
  FDstList.EndUpdate;
  FSrcList.EndUpdate;
  Cursor:=crDefault;
  If FOnChange <> Nil Then FOnChange(Self);
End;

Procedure TDualList.EvSrcDblClick(Sender:TObject);

Begin
  EvAdd(Sender);
End;

Procedure TDualList.EvDstDblClick(Sender:TObject);

Begin
  EvDel(Sender);
End;

{$HINTS ON}


Function TDualList.WriteSCUResource(Stream:TResourceStream):Boolean;
Var
  aText:PChar;
Begin
  Result := Inherited WriteSCUResource(Stream);
  If Not Result Then Exit;

  aText := SrcItems.GetText;
  If aText <> Nil Then
  Begin
    Result := Stream.NewResourceEntry('rnSrcItems',aText^,Length(aText^)+1);
    StrDispose(aText);
  End;
  If Not Result Then Exit;

  aText := DstItems.GetText;
  If aText <> Nil Then
  Begin
    Result := Stream.NewResourceEntry('rnDstItems',aText^,Length(aText^)+1);
    StrDispose(aText);
  End;
End;


Procedure TDualList.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var
  aText:PChar;
Begin
  If ResName = 'rnSrcItems' Then
  Begin
    aText := @Data;
    SrcItems.SetText(aText);
  End
  Else
  If ResName = 'rnDstItems' Then
  Begin
    aText := @Data;
    DstItems.SetText(aText);
  End
  Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;



Procedure TDualList.SetupComponent;
Begin
  Inherited SetupComponent;

  Width := 340;
  Height := 200;
  ParentPenColor := True;
  ParentColor := True;
  TabStop := False;

  FSrcLabel := InsertLabel(Self,0,175,140,25,LoadNLSStr(SSource));
  FDstLabel := InsertLabel(Self,200,175,140,25,LoadNLSStr(SDestination));

  FSrcList := InsertListBox(Self,0,0,140,175,'');
  FSrcList.MultiSelect   := True;
  FSrcList.ExtendedSelect:= True;
  FSrcList.OnItemFocus   := EvItemSelect;
  FSrcList.OnItemSelect  := EvItemSelect;
  FSrcList.OnDblClick    := EvSrcDblClick;

  FDstList := InsertListBox(Self,200,0,140,175,'');
  FDstList.MultiSelect   := True;
  FDstList.ExtendedSelect:= True;
  FDstList.OnItemFocus   := EvItemSelect;
  FDstList.OnItemSelect  := EvItemSelect;
  FDstList.OnDblClick    := EvDstDblClick;

  FAddBtn := InsertSpeedButton(Self,155,145,30,30,0,'>','');
  FAddBtn.OnClick := EvAdd;
  FAddAllBtn := InsertSpeedButton(Self,110,40,30,30,0,'>>','');
  FAddAllBtn.OnClick := EvAddAll;
  FDelBtn := InsertSpeedButton(Self,155,75,30,30,0,'<','');
  FDelBtn.OnClick := EvDel;
  FDelAllBtn := InsertSpeedButton(Self,155,40,30,30,0,'<<','');
  FDelAllBtn.OnClick := EvDelAll;

  If Designed Then
    Begin
      Include(FSrcLabel.ComponentState, csDetail);
      Include(FDstLabel.ComponentState, csDetail);
      Include(FSrcList.ComponentState, csDetail);
      Include(FDstList.ComponentState, csDetail);
      Include(FAddBtn.ComponentState, csDetail);
      Include(FAddAllBtn.ComponentState, csDetail);
      Include(FDelBtn.ComponentState, csDetail);
      Include(FDelAllBtn.ComponentState, csDetail);
    End;
End;

Procedure TDualList.SetupShow;
Begin
  Inherited SetupShow;

  Resize;
  UpdateButtons;
End;


Procedure TDualList.Resize;
Var
  LBWidth:LongInt;
Begin
  Inherited Resize;

  LBWidth := (Width - 60) Div 2;
  FSrcLabel.SetWindowPos(0,Height-25,LBWidth,25);
  FDstLabel.SetWindowPos(Width-LBWidth,Height-25,LBWidth,25);

  FSrcList.SetWindowPos(0,0,LBWidth,Height-25);
  FDstList.SetWindowPos(Width-LBWidth,0,LBWidth,Height-25);

  FAddBtn.SetWindowPos(LBWidth+15,Height-55,30,30);
  FAddAllBtn.SetWindowPos(LBWidth+15,Height-90,30,30);
  FDelBtn.SetWindowPos(LBWidth+15,Height-125,30,30);
  FDelAllBtn.SetWindowPos(LBWidth+15,Height-160,30,30);
End;




Begin
  RegisterClasses([TDualList]);
End.


{ -- date -- -- from -- -- changes ----------------------------------------------
  17-Aug-05  WD         Umbau und Hinzufuegen von Funktionen in der Komponenten
}
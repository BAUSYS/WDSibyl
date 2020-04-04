
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit EditList;

Interface

Uses
  SysUtils, Color,Classes, Forms, Buttons, StdCtrls, ExtCtrls, XplorBtn,
  uString;


Type
  TEditBrowseEvent = Procedure(Sender:TObject;Var Item:String) Of Object;

  TEditListBox = Class(TControl)
    Private
      Edit:TEdit;
      BtnBrowse:TSpeedButton;
      FEditIndex:LongInt;
      FIgnoreExit:Boolean;
      FOnEnter:TNotifyEvent;
      FOnExit:TNotifyEvent;
      FOnBrowse:TEditBrowseEvent;
      Function GetItems:TStrings;
      Procedure SetItems(AStrings:TStrings);
      Function GetCaption:String;
      Procedure SetCaption(Value:String);
      Function GetHorzScroll:Boolean;
      Procedure SetHorzScroll(Value:Boolean);
      Function GetItemIndex:LongInt;
      Procedure SetItemIndex(Value:LongInt);
      Function GetTopIndex:LongInt;
      Procedure SetTopIndex(Value:LongInt);
      Procedure SetHint(Value:String);
      Procedure EvBtnInsert(Sender:TObject);
      Procedure EvBtnDelete(Sender:TObject);
      Procedure EvBtnUp(Sender:TObject);
      Procedure EvBtnDown(Sender:TObject);
      Procedure EvEditExit(Sender:TObject);
      Procedure EvEditScan(Sender:TObject;Var KeyCode:TKeyCode);
      Procedure EvItemFocus(Sender:TObject;Index:LongInt);
      Procedure EvItemSelect(Sender:TObject;Index:LongInt);
      Procedure EvItemKeyPress(Sender:TObject;Var key:Char);
      Procedure EvItemScan(Sender:TObject;Var KeyCode:TKeyCode);
      Procedure EvListEnter(Sender:TObject);
      Procedure EvListExit(Sender:TObject);
      Procedure EvBrowse(Sender:TObject);
      Procedure WriteBack;
      Procedure DoEdit(Index:LongInt);
    Protected
      Panel:TPanel;
      BtnNew:TExplorerButton;
      BtnDel:TExplorerButton;
      BtnUp:TExplorerButton;
      BtnDown:TExplorerButton;
      Procedure SetupComponent;Override;
      Procedure SetupShow;Override;
      Procedure SetFocus;Override;
    Public
      ListBox:TListBox;
      Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
      Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
      Procedure Clear;Virtual;
      Procedure BeginUpdate;
      Procedure EndUpdate;
      Property ItemIndex:LongInt Read GetItemIndex Write SetItemIndex;
      Property TopIndex:LongInt Read GetTopIndex Write SetTopIndex;
      Property XAlign;
      Property XStretch;
      Property YAlign;
      Property YStretch;
    Published
      Property Align;
      Property Caption:String Read GetCaption write SetCaption;
      Property Color;
      Property Enabled;
      Property Font;
      Property Hint Write SetHint;
      Property HorzScroll:Boolean Read GetHorzScroll Write SetHorzScroll;
      Property Items:TStrings Read GetItems Write SetItems;
      Property ParentColor;
      Property ParentPenColor;
      Property ParentFont;
      Property ParentShowHint;
      Property PenColor;
      Property PopupMenu;
      Property ShowHint;
      Property TabOrder;
      Property TabStop;
      Property Visible;
      Property ZOrder;

      Property OnBrowse:TEditBrowseEvent Read FOnBrowse Write FOnBrowse;
      Property OnEnter:TNotifyEvent Read FOnEnter Write FOnEnter;
      Property OnExit:TNotifyEvent Read FOnExit Write FOnExit;
      Property OnSetupShow;
  End;


Exports
  TEditListBox,'User','';


Implementation

{$r EditList}

Const
  BtnSize=26;


Procedure TEditListBox.SetupComponent;
Begin
  Inherited SetupComponent;

  Width := 220;
  Height := 150;
  Color := clEntryField;
  Ownerdraw := False;

  FEditIndex := -1;
  FIgnoreExit := False;

  ListBox := InsertListBox(SELF,0,0,Width,Height-(BtnSize+2),'');
  ListBox.Align := alFrame;
  ListBox.ParentColor := True;
  ListBox.ParentPenColor := True;
  ListBox.OnItemFocus := EvItemFocus;
  ListBox.OnItemSelect := EvItemSelect;
  ListBox.OnKeyPress := EvItemKeyPress;
  ListBox.OnScan := EvItemScan;
  ListBox.OnEnter := EvListEnter;
  ListBox.OnExit := EvListExit;
  Include(ListBox.ComponentState, csDetail);

  Panel := InsertPanel(SELF,0,Height-(BtnSize+2),Width,(BtnSize+2),
                       bvNone,bvLowered,1,' EditListBox');
  Panel.Align := alTop;
  Panel.Alignment := taLeftJustify;
  Panel.Color := clLtGray;
  Panel.ParentPenColor := True;
  Include(Panel.ComponentState, csDetail);

  BtnNew.Create(Panel);
  BtnNew.Parent := Panel;
  BtnNew.SetWindowPos(Panel.Width-4*BtnSize-1,1,BtnSize,BtnSize);
  BtnNew.Align := alFixedRightBottom;
  //BtnNew.Hint := 'New';
  BtnNew.NumGlyphs :=2 ;
  BtnNew.Glyph.LoadFromResourceName('BmpBtnNew');
  BtnNew.OnClick := EvBtnInsert;
  Include(BtnNew.ComponentState, csDetail);

  BtnDel.Create(Panel);
  BtnDel.Parent := Panel;
  BtnDel.SetWindowPos(Panel.Width-3*BtnSize-1,1,BtnSize,BtnSize);
  BtnDel.Align := alFixedRightBottom;
  BtnDel.NumGlyphs := 2;
  //BtnDel.Hint := 'Del';
  BtnDel.Glyph.LoadFromResourceName('BmpBtnDel');
  BtnDel.OnClick := EvBtnDelete;
  Include(BtnDel.ComponentState, csDetail);

  BtnUp.Create(Panel);
  BtnUp.Parent := Panel;
  BtnUp.SetWindowPos(Panel.Width-2*BtnSize-1,1,BtnSize,BtnSize);
  BtnUp.Align := alFixedRightBottom;
  //BtnUp.Hint := 'Up';
  BtnUp.NumGlyphs := 2;
  BtnUp.Glyph.LoadFromResourceName('BmpBtnUp');
  BtnUp.OnClick := EvBtnUp;
  Include(BtnUp.ComponentState, csDetail);

  BtnDown.Create(Panel);
  BtnDown.Parent := Panel;
  BtnDown.SetWindowPos(Panel.Width-BtnSize-1,1,BtnSize,BtnSize);
  BtnDown.Align := alFixedRightBottom;
  //BtnDown.Hint := 'Down';
  BtnDown.NumGlyphs := 2;
  BtnDown.Glyph.LoadFromResourceName('BmpBtnDown');
  BtnDown.OnClick := EvBtnDown;
  Include(BtnDown.ComponentState, csDetail);

  Edit.Create(ListBox);
  Edit.Parent := ListBox;
  Edit.Visible := False;
  Edit.OnExit := EvEditExit;
  Edit.OnScan := EvEditScan;
  Include(Edit.ComponentState, csDetail);
  Include(Edit.ComponentState, csAcceptsControls);

  BtnBrowse := InsertSpeedButton(Edit,0,0,0,0,0,'...','Browse');
  BtnBrowse.OnClick := EvBrowse;
  Include(BtnBrowse.ComponentState, csDetail);
End;


Procedure TEditListBox.SetupShow;
Begin
  Inherited SetupShow;

  IF Not Designed Then
  Begin
    ListBox.Items.Add('');
  End;
End;


Procedure TEditListBox.SetFocus;
Begin
     Inherited SetFocus;

     If Not Designed Then ListBox.CaptureFocus;
End;


Function TEditListBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Var  aText:PChar;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     aText := ListBox.Items.GetText;
     If aText <> Nil Then
     Begin
          Result := Stream.NewResourceEntry(rnItems,aText^,Length(aText^)+1);
          StrDispose(aText);
     End;
End;


Procedure TEditListBox.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  aText:PChar;
Begin
     If ResName = rnItems Then
     Begin
          aText := @Data;
          ListBox.Items.SetText(aText);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


Function TEditListBox.GetItemIndex:LongInt;
Begin
  Result := ListBox.ItemIndex;
End;


Procedure TEditListBox.SetItemIndex(Value:LongInt);
Begin
  ListBox.ItemIndex := Value;
End;


Function TEditListBox.GetTopIndex:LongInt;
Begin
  Result := ListBox.TopIndex;
End;


Procedure TEditListBox.SetTopIndex(Value:LongInt);
Begin
  ListBox.TopIndex := Value;
End;


Procedure TEditListBox.SetHint(Value:String);
Begin
  Panel.Hint := Value;
  ListBox.Hint := Value;
  TControl.Hint := Value;
End;


Procedure TEditListBox.Clear;
Begin
  ListBox.Clear;
End;


Procedure TEditListBox.BeginUpdate;
Begin
  ListBox.BeginUpdate;
End;


Procedure TEditListBox.EndUpdate;
Begin
  ListBox.EndUpdate;
End;


Function TEditListBox.GetItems:TStrings;
Begin
  Result := ListBox.Items;
End;


Procedure TEditListBox.SetItems(AStrings:TStrings);
Begin
  ListBox.Items := AStrings;
End;


Function TEditListBox.GetCaption:String;
Begin
  Result := Panel.Caption;
End;


Procedure TEditListBox.SetCaption(Value:String);
Begin
  Panel.Caption := Value;
End;


Function TEditListBox.GetHorzScroll:Boolean;
Begin
  Result := ListBox.HorzScroll;
End;


Procedure TEditListBox.SetHorzScroll(Value:Boolean);
Begin
  ListBox.HorzScroll := Value;
End;


Procedure TEditListBox.EvBtnInsert(Sender:TObject);
Var
  i:LongInt;
Begin
  If Edit.Showing Then WriteBack;

  If (ListBox.ItemIndex >= 0) And (ListBox.ItemIndex < ListBox.Items.Count) Then
  Begin
    i := ListBox.ItemIndex;
    ListBox.Items.Insert(ListBox.ItemIndex,'');
    ListBox.ItemIndex := i;
  End
  Else i := ListBox.Items.Add('');

  DoEdit(i);
End;


Procedure TEditListBox.EvBtnDelete(Sender:TObject);
Var
  i:LongInt;
Begin
  If Edit.Showing Then WriteBack;

  If (ListBox.ItemIndex >= 0) And (ListBox.ItemIndex < ListBox.Items.Count) Then
  Begin
    i := ListBox.ItemIndex;
    ListBox.Items.Delete(i);
    ListBox.ItemIndex := i;
  End;
End;


Procedure TEditListBox.EvBtnUp(Sender:TObject);
Var
  i:LongInt;
Begin
  If Edit.Showing Then WriteBack;

  If (ListBox.ItemIndex >= 1) And (ListBox.ItemIndex < ListBox.Items.Count) Then
  Begin
    i := ListBox.ItemIndex;
    ListBox.Items.Exchange(i,i-1);
    ListBox.ItemIndex := i-1;
  End;
End;


Procedure TEditListBox.EvBtnDown(Sender:TObject);
Var
  i:LongInt;
Begin
  If Edit.Showing Then WriteBack;

  If (ListBox.ItemIndex >= 0) And (ListBox.ItemIndex < ListBox.Items.Count-1) Then
  Begin
    i := ListBox.ItemIndex;
    ListBox.Items.Exchange(i,i+1);
    ListBox.ItemIndex := i+1;
  End;
End;


Procedure TEditListBox.WriteBack;
Begin
  If (FEditIndex >= 0) And (FEditIndex < ListBox.Items.Count) Then
  Begin
    ListBox.Items[FEditIndex] := Edit.Caption;
    ListBox.ItemIndex := FEditIndex;

    If FEditIndex = ListBox.Items.Count-1 Then
      If Edit.Caption <> '' Then ListBox.Items.Add('');
  End;


  Edit.Visible := False;
  ListBox.Focus;
End;


Procedure TEditListBox.DoEdit(Index:LongInt);
Var
  rc:TRect;
Begin
  rc := ListBox.ItemRect(Index);
  Edit.SetWindowPos(1,rc.Bottom-2,ListBox.Width-2,Edit.Height);
  Edit.Caption := ListBox.Items[Index];
  Edit.Visible := True;
  Edit.Focus;
  Edit.SelectAll;


  If @FOnBrowse <> Nil Then
  Begin
    BtnBrowse.SetWindowPos(Edit.Width-25-2,2,25,Edit.Height-4);
    BtnBrowse.Parent := Edit;
  End
  Else BtnBrowse.Parent := Nil;


  FEditIndex := Index;
End;


Procedure TEditListBox.EvEditExit(Sender:TObject);
Begin
  If FIgnoreExit Then Exit;

  If Edit.Showing Then WriteBack;
End;


Procedure TEditListBox.EvEditScan(Sender:TObject;Var KeyCode:TKeyCode);
Begin
  Case KeyCode Of
    kbCUp:
    Begin
      WriteBack;
      If ListBox.ItemIndex > 0 Then ListBox.ItemIndex := ListBox.ItemIndex -1;
      KeyCode := 0;
    End;
    kbCDown:
    Begin
      WriteBack;
      ListBox.ItemIndex := ListBox.ItemIndex +1;
      KeyCode := 0;
    End;
    kbCR
    {$IFDEF OS2}
    ,kbEnter
    {$ENDIF}
    :
    Begin
      WriteBack;
      KeyCode := 0;
    End;
    kbEsc:
    Begin
      Edit.Visible := False;
      ListBox.Focus;
      KeyCode := 0;
    End;
  End;
End;


Procedure TEditListBox.EvItemFocus(Sender:TObject;Index:LongInt);
Begin
  If Edit.Showing Then WriteBack;
End;


Procedure TEditListBox.EvItemSelect(Sender:TObject;Index:LongInt);
Begin
  DoEdit(Index);
End;


Procedure TEditListBox.EvItemKeyPress(Sender:TObject;Var key:Char);
Begin
  If (ListBox.ItemIndex >= 0) And (ListBox.ItemIndex < ListBox.Items.Count) Then
  Begin
    DoEdit(ListBox.ItemIndex);
    Edit.Caption := key;
    key := #0;
  End;
End;


Procedure TEditListBox.EvItemScan(Sender:TObject;Var KeyCode:TKeyCode);
Begin
  Case KeyCode Of
    kbIns:
    Begin
      EvBtnInsert(BtnNew);
      KeyCode := 0;
    End;
    kbDel:
    Begin
      EvBtnDelete(BtnDel);
      KeyCode := 0;
    End;
  End;
End;


Procedure TEditListBox.EvListEnter(Sender:TObject);
Begin
  If FOnEnter <> Nil Then FOnEnter(Self);
End;


Procedure TEditListBox.EvListExit(Sender:TObject);
Begin
  If FOnExit <> Nil Then FOnExit(Self);
End;


Procedure TEditListBox.EvBrowse(Sender:TObject);
Var
  s:String;
Begin
  FIgnoreExit := True;
  s := Edit.Caption;
  If FOnBrowse <> Nil Then FOnBrowse(Self, s);
  Edit.Caption := s;
  WriteBack;
  FIgnoreExit := False;
End;



Begin
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  09-Aug-04  MV       EditListbox.Listbox moved to public
                              stupid button hints deactivated, because Editlist.Hint gets overlayed
}
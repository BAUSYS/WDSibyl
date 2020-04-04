
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit Spin;

Interface

Uses SysUtils,Classes,Forms,Graphics,StdCtrls,Buttons,ComCtrls,
     uString;

Type
     TSpinButton=Class(TUpDown)
        Private
              FUpButton:TSpeedButton;
              FDownButton:TSpeedButton;
        Private
              Procedure ButtonOnPaint(Sender:TObject;Const rec:TRect);
              Function GetDownGlyph:TBitmap;
              Procedure SetDownGlyph(NewValue:TBitmap);
              Function GetDownNumGlyphs:TNumGlyphs;
              Procedure SetDownNumGlyphs(NewValue:TNumGlyphs);
              Function GetUpGlyph:TBitmap;
              Procedure SetUpGlyph(NewValue:TBitmap);
              Function GetUpNumGlyphs:TNumGlyphs;
              Procedure SetUpNumGlyphs(NewValue:TNumGlyphs);
        Public
              Procedure SetupComponent;Override;
        Published
              Property DownGlyph:TBitmap read GetDownGlyph write SetDownGlyph;
              Property DownNumGlyphs:TNumGlyphs read GetDownNumGlyphs write SetDownNumGlyphs;
              Property UpGlyph:TBitmap read GetUpGlyph write SetUpGlyph;
              Property UpNumGlyphs:TNumGlyphs read GetUpNumGlyphs write SetUpNumGlyphs;
     End;


     TSpinMode=(spSpinNumbers,spSpinList);

     TSpinEdit=Class(TControl)
        Private
              FEditorEnabled:Boolean;
              FButton:TSpinButton;
              FEdit:TEdit;
              FMinValue,FMaxValue:LongInt;
              FIncrement:LongInt;
              FItems:TStrings;
              FSpinMode:TSpinMode;
              FValue:LongInt;
        Private
              Procedure SetMaxValue(NewValue:LongInt);
              Procedure SetMinValue(NewValue:LongInt);
              Procedure SetValue(NewValue:LongInt);
              Procedure SetEditorEnabled(NewValue:Boolean);
              Procedure SetItems(NewValue:TStrings);
              Procedure SetSpinMode(NewValue:TSpinMode);
              Procedure ButtonClick(Sender:TObject);
              Procedure EditResize(Sender:TObject);
              Procedure EditChange(Sender:TObject);
              Procedure EditScan(Sender:TObject;Var KeyCode:TKeyCode);
        Protected
              Procedure SetupComponent;Override;
              Procedure SetupShow;Override;
              Procedure Resize;Override;
        Public
              Destructor Destroy;Override;
              Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
              Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
        Public
              Property Button:TSpinButton read FButton;
              Property Edit:TEdit read FEdit;
        Published
              Property Increment:LongInt read FIncrement write FIncrement;
              Property MaxValue:LongInt read FMaxValue write SetMaxValue;
              Property MinValue:LongInt read FMinValue write SetMinValue;
              Property Value:LongInt read FValue write SetValue;
              Property EditorEnabled:Boolean read FEditorEnabled write SetEditorEnabled;
              Property Items:TStrings read FItems write SetItems;
              Property SpinMode:TSpinMode read FSpinMode write SetSpinMode;
              Property Align;
              Property ClientHeight;
              Property ClientWidth;
              Property Enabled;
              Property OnBeforePaint;
              Property OnAfterPaint;
              Property TabOrder;
              Property TabStop;
              Property PopUpMenu;
              Property OnScan;
              Property OnSetupShow;
              Property OnShow;
              Property Visible;
              Property Font;
              Property ParentFont;
              Property Color;
              Property ParentColor;
              Property PenColor;
              Property ParentPenColor;
     End;

Implementation

{$R Spin}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TSpinButton Class Implementation                            บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Type TSpdBtn=Class(TBitBtn)
           Procedure DoRedraw(Const rec:TRect);
     End;


Procedure TSpdBtn.DoRedraw(Const rec:TRect);
Begin
     TBitBtn.Redraw(rec);
End;

Procedure TSpinButton.ButtonOnPaint(Sender:TObject;Const rec:TRect);
Begin
     TSpdBtn(Sender).DoRedraw(rec);
End;

Procedure TSpinButton.SetupComponent;
Var Up,Down:TSpeedButton;
    Bitmap:TBitmap;
Begin
     Inherited SetupComponent;

     Width:=20;
     Height:=25;

     //Get the buttons
     //because they are declared as private, we have to use ASM :-(
     Asm
        PUSH DWORD PTR SELF
        CALLN32 ComCtrls.GetUpRightButton
        MOV Up,EAX

        PUSH DWORD PTR SELF
        CALLN32 ComCtrls.GetDownLeftButton
        MOV Down,EAX
     End;

     Up.OnPaint:=ButtonOnPaint;
     Bitmap.Create;
     Bitmap.LoadFromResourceName('SpUp');
     Up.NumGlyphs:=1;
     Up.Glyph:=Bitmap;
     Bitmap.Destroy;
     Down.OnPaint:=ButtonOnPaint;
     Bitmap.Create;
     Bitmap.LoadFromResourceName('SpDown');
     Down.NumGlyphs:=1;
     Down.Glyph:=Bitmap;
     Bitmap.Destroy;

     FUpButton:=Up;
     FDownButton:=Down;
End;

Function TSpinButton.GetDownGlyph:TBitmap;
Begin
     Result:=FDownButton.Glyph;
End;

Procedure TSpinButton.SetDownGlyph(NewValue:TBitmap);
Begin
     FDownButton.Glyph:=NewValue;
End;

Function TSpinButton.GetDownNumGlyphs:TNumGlyphs;
Begin
     Result:=FDownButton.NumGlyphs;
End;

Procedure TSpinButton.SetDownNumGlyphs(NewValue:TNumGlyphs);
Begin
     FDownButton.NumGlyphs:=NewValue;
End;

Function TSpinButton.GetUpGlyph:TBitmap;
Begin
     result:=FUpButton.Glyph;
End;

Procedure TSpinButton.SetUpGlyph(NewValue:TBitmap);
Begin
     FUpButton.Glyph:=NewValue;
End;

Function TSpinButton.GetUpNumGlyphs:TNumGlyphs;
Begin
     Result:=FUpButton.NumGlyphs;
End;

Procedure TSpinButton.SetUpNumGlyphs(NewValue:TNumGlyphs);
Begin
     FUpButton.NumGlyphs:=NewValue;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TSpinEdit Class Implementation                              บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TSpinEdit.SetupComponent;
Begin
     Inherited SetupComponent;

     Width:=100;

     FMinValue:=0;
     FMaxValue:=100;
     FIncrement:=1;
     FSpinMode:=spSpinNumbers;
     FEditorEnabled:=True;

     FItems:=TStringList.Create;

     FEdit:=TEdit.Create(Self);
     Include(FEdit.ComponentState,csDetail);
     FEdit.Width:=100-12;
     FEdit.NumbersOnly:=True;
     FEdit.OnResize:=EditResize;
     FEdit.OnChange:=EditChange;
     FEdit.OnScan:=EditScan;
     FEdit.ParentFont:=True;
     FEdit.ParentColor:=True;
     FEdit.ParentPenColor:=True;
     FEdit.Parent:=Self;
     Height:=FEdit.Height;

     FButton.Create(Self);
     Include(FButton.ComponentState,csDetail);
     FButton.SetWindowPos(80,0,12,Height);
     FButton.FUpButton.OnClick:=ButtonClick;
     FButton.FDownButton.OnClick:=ButtonClick;
     FButton.ParentColor:=False;
     FButton.ParentPenColor:=False;
     FButton.Parent:=Self;
End;

Procedure TSpinEdit.EditChange(Sender:TObject);
Var i:LongInt;
    c:Integer;
Begin
     If SpinMode<>spSpinNumbers Then exit;

     Val(FEdit.Text,i,c);
     If ((c<>0)Or(i<MinValue)Or(i>MaxValue)) Then
     Begin
          If ((c=0)And(i<MinValue)) Then Value:=MinValue
          Else If ((c=0)And(i>MaxValue)) Then Value:=MaxValue;
     End
     Else
     Begin
          FValue:=i;
          If FEdit.Text<>tostr(FValue) Then FEdit.Text:=tostr(FValue);
     End;
End;


Procedure TSpinEdit.EditScan(Sender:TObject;Var KeyCode:TKeyCode);
Begin
     If OnScan <> Nil Then OnScan(Self, KeyCode);
End;


Procedure TSpinEdit.ButtonClick(Sender:TObject);
Begin
     If Sender=FButton.FUpButton Then
     Begin
          If SpinMode=spSpinNumbers Then
          Begin
               If Value<MaxValue Then Value:=Value+1;
          End
          Else
          Begin
               If Value<FItems.Count-1 Then Value:=Value+1;
          End;
     End
     Else
     Begin
          If SpinMode=spSpinNumbers Then
          Begin
               If Value>MinValue Then Value:=Value-1;
          End
          Else
          Begin
               If Value>0 Then Value:=Value-1;
          End;
     End;
End;

Procedure TSpinEdit.EditResize(Sender:TObject);
Begin
     If Height<>FEdit.Height Then Height:=FEdit.Height;
End;

Procedure TSpinEdit.SetupShow;
Begin
     Inherited SetupShow;

     FEdit.Width:=Width-12;
     FButton.Left:=Width-12;
     Height:=FEdit.Height;
     FButton.Height:=FEdit.Height;
     If SpinMode=spSpinNumbers Then FEdit.Text:=tostr(Value)
     Else If Value<FItems.Count Then FEdit.Text:=FItems[Value];
End;

Destructor TSpinEdit.Destroy;
Begin
     FItems.Destroy;
     FItems:=Nil;
     Inherited Destroy;
End;

Procedure TSpinEdit.Resize;
Begin
     Inherited Resize;

     If FEdit.Height<>Height Then FEdit.Height:=Height;
     FEdit.Width:=Width-12;
     FButton.Left:=Width-12;
     FButton.Height:=Height;
End;

Procedure TSpinEdit.SetMaxValue(NewValue:LongInt);
Begin
     FMaxValue:=NewValue;
     If Value>FMaxValue Then Value:=FMaxValue;
End;

Procedure TSpinEdit.SetMinValue(NewValue:LongInt);
Begin
     FMinValue:=NewValue;
     If Value<FMinValue Then Value:=FMinValue;
End;

Procedure TSpinEdit.SetValue(NewValue:LongInt);
Begin
     If SpinMode=spSpinNumbers Then
     Begin
          If ((NewValue<FMinValue)Or(NewValue>FMaxValue)) Then exit;
     End
     Else
     Begin
          If ((NewValue<0)Or(NewValue>FItems.Count-1)) Then exit;
     End;
     FValue:=NewValue;
     If SpinMode=spSpinNumbers Then FEdit.Text:=tostr(FValue)
     Else If FValue<FItems.Count Then FEdit.Text:=FItems[FValue];
End;

Procedure TSpinEdit.SetEditorEnabled(NewValue:Boolean);
Begin
     FEditorEnabled:=NewValue;
     FEdit.ReadOnly:=not NewValue;
End;

Procedure TSpinEdit.SetItems(NewValue:TStrings);
Begin
     If NewValue <> FItems Then FItems.Assign(NewValue);
     If SpinMode=spSpinList Then
     Begin
          If Value<0 Then Value:=0
          Else If Value>FItems.Count-1 Then Value:=FItems.Count-1
          Else FEdit.Text:=FItems[Value];
     End;
End;

Procedure TSpinEdit.SetSpinMode(NewValue:TSpinMode);
Begin
     FSpinMode:=NewValue;
     If SpinMode=spSpinNumbers Then
     Begin
          If Value<MinValue Then Value:=MinValue
          Else If Value>MaxValue Then Value:=MaxValue
          Else FEdit.Text:=tostr(Value);
          FEdit.ReadOnly:=not EditorEnabled;
     End
     Else
     Begin
          If Value<0 Then Value:=0
          Else If Value>FItems.Count-1 Then Value:=FItems.Count-1
          Else If Value<FItems.Count Then FEdit.Text:=FItems[Value];
          FEdit.ReadOnly:=True;
     End;
End;

Const rnSpinEditItems='rnSpinEditItems';

Procedure TSpinEdit.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var aText:PChar;
Begin
     If ResName = rnSpinEditItems Then
     Begin
          aText := @Data;
          Items.SetText(aText);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Function TSpinEdit.WriteSCUResource(Stream:TResourceStream):Boolean;
Var aText:PChar;
Begin
     Result:=Inherited WriteSCUResource(Stream);
     If not Result Then exit;

     aText := Items.GetText;
     If aText <> Nil Then
     Begin
          Result := Stream.NewResourceEntry(rnSpinEditItems,aText^,Length(aText^)+1);
          StrDispose(aText);
     End;
End;

Begin
     RegisterClasses([TSpinButton,TSpinEdit]);
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  28-Aug-05  WD        Variablen die nicht verwendet werden entfernt.
}
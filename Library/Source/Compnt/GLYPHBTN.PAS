
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


UNIT GlyphBtn;

INTERFACE

{$R GlyphBtn}

USES Classes,Forms,Graphics,Buttons;

TYPE TGlyphButton=CLASS(TSpeedButton)
        PRIVATE
              FGlyphOn:TBitmap;
              FCaptionOn:^STRING;
              FAllowDrawDown:BOOLEAN;
              FAllowDrawFrame:BOOLEAN;
        PRIVATE
              FUNCTION GetGlyphOff:TBitmap;
              PROCEDURE SetGlyphOff(NewValue:TBitmap);
              FUNCTION GetCaptionOff:STRING;
              PROCEDURE SetCaptionOff(CONST NewValue:STRING);
              FUNCTION GetCaptionOn:STRING;
              PROCEDURE SetCaptionOn(CONST NewValue:STRING);
              PROCEDURE SetAllowDrawDown(NewValue:BOOLEAN);
              FUNCTION GetGlyphOn:TBitmap;
              PROCEDURE SetGlyphOn(NewBitmap:TBitmap);
              PROCEDURE SetAllowDrawFrame(NewValue:BOOLEAN);
        PRIVATE
              PROPERTY Glyph;
              PROPERTY Kind;
              PROPERTY Caption;
        PROTECTED
              PROCEDURE DrawFrame(Down:BOOLEAN);OVERRIDE;
              PROCEDURE DrawText(CONST Caption:STRING;Down:BOOLEAN);OVERRIDE;
              PROCEDURE DrawBitmap(Bitmap:TBitmap;Down:BOOLEAN);OVERRIDE;
              PROCEDURE ReadSCUResource(CONST ResName:TResourceName;VAR Data;DataLen:LONGINT);OVERRIDE;
              FUNCTION WriteSCUResource(Stream:TResourceStream):BOOLEAN;OVERRIDE;
        PUBLIC
              PROCEDURE SetupComponent;OVERRIDE;
        PUBLISHED
              PROPERTY Align;
              PROPERTY Color;
              PROPERTY DragCursor;
              PROPERTY DragMode;
              PROPERTY Enabled;
              PROPERTY Font;
              PROPERTY ParentColor;
              PROPERTY ParentPenColor;
              PROPERTY ParentFont;
              PROPERTY ParentShowHint;
              PROPERTY PenColor;
              PROPERTY PopupMenu;
              PROPERTY ShowHint;
              PROPERTY TabOrder;
              PROPERTY TabStop;
              PROPERTY Visible;
              PROPERTY ZOrder;

              PROPERTY OnCanDrag;
              PROPERTY OnClick:TNotifyEvent Read FOnClick Write FOnClick;
              PROPERTY OnCommand;
              PROPERTY OnDblClick;
              PROPERTY OnDragDrop;
              PROPERTY OnDragOver;
              PROPERTY OnEndDrag;
              PROPERTY OnEnter;
              PROPERTY OnExit;
              PROPERTY OnFontChange;
              PROPERTY OnMouseClick;
              PROPERTY OnMouseDblClick;
              PROPERTY OnMouseDown;
              PROPERTY OnMouseMove;
              PROPERTY OnMouseUp;
              PROPERTY OnResize;
              PROPERTY OnSetupShow;
              PROPERTY OnStartDrag;
              PROPERTY GlyphOff:TBitmap read GetGlyphOff write SetGlyphOff;
              PROPERTY GlyphOn:TBitmap read GetGlyphOn write SetGlyphOn;
              PROPERTY CaptionOff:STRING read GetCaptionOff write SetCaptionOff;
              PROPERTY CaptionOn:STRING read GetCaptionOn write SetCaptionOn;
              PROPERTY AllowDrawDown:BOOLEAN read FAllowDrawDown write SetAllowDrawDown;
              PROPERTY AllowDrawFrame:BOOLEAN read FAllowDrawFrame write SetAllowDrawFrame;
     END;

     TOnOffSwitch=CLASS(TGlyphButton)
         PRIVATE
              PROPERTY GlyphOn;
              PROPERTY GlyphOff;
              PROPERTY AllowDrawDown;
         PROTECTED
              PROCEDURE ReadSCUResource(CONST ResName:TResourceName;VAR Data;DataLen:LONGINT);OVERRIDE;
              FUNCTION WriteSCUResource(Stream:TResourceStream):BOOLEAN;OVERRIDE;
         PUBLIC
              PROCEDURE SetupComponent;OVERRIDE;
     END;

IMPLEMENTATION

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TGlyphButton Class implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TGlyphButton.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Kind:=bkCustom;
     GroupIndex:=1;
     AllowAllUp:=TRUE;
     AllowDrawDown:=TRUE;
     FAllowDrawFrame:=TRUE;
END;

PROCEDURE TGlyphButton.DrawFrame(Down:BOOLEAN);
BEGIN
     IF not FAllowDrawFrame THEN exit;
     IF not FAllowDrawDown THEN Down:=FALSE;
     Inherited DrawFrame(Down);
END;

PROCEDURE TGlyphButton.DrawText(CONST Caption:STRING;Down:BOOLEAN);
VAR s:STRING;
BEGIN
     IF Down THEN s:=CaptionOn
     ELSE s:=CaptionOff;
     IF not FAllowDrawDown THEN Down:=FALSE;
     Inherited DrawText(s,Down);
END;

PROCEDURE TGlyphButton.DrawBitmap(Bitmap:TBitmap;Down:BOOLEAN);
VAR FBitmap:TBitmap;
BEGIN
     IF Down THEN FBitmap:=GlyphOn
     ELSE FBitmap:=GlyphOff;
     IF not FAllowDrawDown THEN Down:=FALSE;
     Inherited DrawBitmap(FBitmap,Down);
END;

FUNCTION TGlyphButton.GetGlyphOff:TBitmap;
BEGIN
     result:=Glyph;
END;

PROCEDURE TGlyphButton.SetGlyphOff(NewValue:TBitmap);
BEGIN
     Glyph:=NewValue;
END;

FUNCTION TGlyphButton.GetCaptionOff:STRING;
BEGIN
     result:=Caption;
END;

PROCEDURE TGlyphButton.SetCaptionOff(CONST NewValue:STRING);
BEGIN
     Caption:=NewValue;
END;

FUNCTION TGlyphButton.GetCaptionOn:STRING;
BEGIN
     IF FCaptionOn=NIL THEN result:=''
     ELSE result:=FCaptionOn^;
END;

PROCEDURE TGlyphButton.SetCaptionOn(CONST NewValue:STRING);
BEGIN
     IF FCaptionOn<>NIL THEN FreeMem(FCaptionOn,length(FCaptionOn^)+1);
     GetMem(FCaptionOn,length(NewValue)+1);
     FCaptionOn^:=NewValue;
     Refresh;
END;

PROCEDURE TGlyphButton.SetAllowDrawDown(NewValue:BOOLEAN);
BEGIN
     FAllowDrawDown:=NewValue;
     Refresh;
END;

FUNCTION TGlyphButton.GetGlyphOn:TBitmap;
BEGIN
     IF FGlyphOn = NIL THEN FGlyphOn.Create;
     Result := FGlyphOn;
END;

PROCEDURE TGlyphButton.SetGlyphOn(NewBitmap:TBitmap);
VAR  OldBitmap:TBitmap;
BEGIN
     OldBitmap := FGlyphOn;

     {create internal copy}
     IF NewBitmap <> NIL THEN FGlyphOn := NewBitmap.Copy
     ELSE FGlyphOn := NIL;

     IF FGlyphOn <> NIL THEN Include(FGlyphOn.ComponentState, csDetail);

     IF OldBitmap <> NIL THEN IF OldBitmap<>NewBitmap THEN OldBitmap.Destroy;

     Arrange;
     Refresh;
END;

PROCEDURE TGlyphButton.SetAllowDrawFrame(NewValue:BOOLEAN);
BEGIN
     FAllowDrawFrame:=NewValue;
     Refresh;
END;

PROCEDURE TGlyphButton.ReadSCUResource(CONST ResName:TResourceName;VAR Data;DataLen:LONGINT);
BEGIN
     IF ResName <> 'rnGlyphOn' THEN
     BEGIN
          Inherited ReadSCUResource(ResName,Data,DataLen);
          exit;
     END
     ELSE
     BEGIN
         IF FGlyphOn = NIL THEN FGlyphOn.Create;
         FGlyphOn.ReadSCUResource(rnBitmap,Data,DataLen);
     END;
END;


FUNCTION TGlyphButton.WriteSCUResource(Stream:TResourceStream):BOOLEAN;
BEGIN
     Result := Inherited WriteSCUResource(Stream);
     IF not Result THEN exit;

     IF (FGlyphOn <> NIL) AND (ComponentState * [csDetail] = [])
     THEN Result := FGlyphOn.WriteSCUResourceName(Stream,'rnGlyphOn')
     ELSE Result := TRUE;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TOnOffSwitch Class implementation                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TOnOffSwitch.SetupComponent;
VAR FBitmap:TBitmap;
BEGIN
     Inherited SetupComponent;

     AllowDrawDown:=FALSE;
     FBitmap.Create;
     FBitmap.LoadFromResourceName('TOnOffSwitch_On');
     GlyphOn:=FBitmap;
     FBitmap.LoadFromResourceName('TOnOffSwitch_Off');
     GlyphOff:=FBitmap;
     FBitmap.Destroy;
     Width:=30;
     Height:=42;
END;

PROCEDURE TOnOffSwitch.ReadSCUResource(CONST ResName:TResourceName;VAR Data;DataLen:LONGINT);
BEGIN
     IF ResName<>rnBitmap THEN Inherited ReadSCUResource(ResName,Data,DataLen);
END;

FUNCTION TOnOffSwitch.WriteSCUResource(Stream:TResourceStream):BOOLEAN;
BEGIN
     //don't write our Bitmaps here !
     result:=TButton.WriteSCUResource(Stream);
END;

BEGIN
     RegisterClasses([TGlyphButton,TOnOffSwitch]);
END.


{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Component                                                       บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit Seven;

{************************************************}
{                                                }
{ TSevenSegDisplay component                     }
{                                                }
{ A seven-segment display panel for Sibyl        }
{                                                }
{ Copyright (C) 1996-1997 Joerg Pleumann         }
{                                                }
{ Mail bugs to: pleumann@uni-duisburg.de         }
{                                                }
{************************************************}



{

 bug comment:

 (MV) this code does not work with specific Windows versions, e.g. Windows ME.
 The segments get totally corrupted, but with Win95 or WinNT it works fine.


}


interface

uses
  Color,Classes, Forms, Graphics;

type
  TSevenSegDisplay = class(TControl)
  private
    FDigits:      string;
    FSegments:    string;
    FBorderStyle: TBorderStyle;
    FMargin:      LongInt;

    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetDigits(const Value: string);
    procedure SetMargin(Value: LongInt);
  public
    constructor Create(Owner: TComponent); override;
    procedure Redraw(const Rec: TRect); override;

    property XAlign;
    property XStretch;
    property YAlign;
    property YStretch;
  published
    property Align;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;
      { Holds the border style of the seven segment
        display. The following values are supported:
        bsNone   - No border
        bsSingle - Border with 3D appearance }
    property Digits: string read FDigits write SetDigits;
      { The Digits property holds the current content
        string of the seven segment display. The
        following digits and characters are supported:

        The characters '0' to '9' and 'A' to 'F',
        allowing the display of decimal and
        hexadecimal numbers.

        The additional characters 'H', 'I', 'J', 'L',
        'N', 'O', 'R', 'S', 'U', and 'Y', allowing the
        display of the following strings:

        'ON'            'EIN'
        'OFF'           'AUS'
        'YES'           'JA'
        'NO'            'NEIN'
        'ERROR'         'FEHLER'

        I must, however, admit that some of the
        strings look very strange... :-)

        The minus sign ('-') highlights the center
        segment.

        The space (' ') results in a digit with no
        segments highlighted. The underscore ('_')
        results in a place with no segments at all.
        This might be useful if you want to display
        date and time in one panel, as an example.

        After each character, an additional modifier
        may be used to control the separators between
        two digits. The following modifiers are
        supported:

        '~'      - No separator at all, not even
                   the segments are displayed.
        '.', ',' - Highlights the lower separator
                   segment.
        ':'      - Highlights both separator segments.

        The modifiers are optional. If none of them
        is present, both separator segments are
        visible, but not highlighted. }
    property DragCursor;
    property DragMode;
    property Margin: LongInt read FMargin write SetMargin;
      { Holds the distance between each of the four
        borders and the digits. }
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property ZOrder;

    property OnCanDrag;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseClick;
    property OnMouseDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSetupShow;
    property OnStartDrag;
  end;

implementation

{$r Seven}

var
  Digits: TBitmap;

procedure DrawDigit(Canvas: TCanvas; Dest: TRect; Digit, Separator: Byte);
var
  SourceRect, DestRect: TRect;
begin
  DestRect := Dest;
  Dec(DestRect.Right, (Dest.Right - Dest.Left) div 5);

  with SourceRect do
  begin
    Left   := 20 * (Digit mod 10);
    Bottom := integer(60) - 30 * Int((Digit / 10));
    Right  := Left + 20;
    Top    := Bottom + 30;
  end;

  Digits.PartialDraw(Canvas, SourceRect, DestRect);

  DestRect.Left := DestRect.Right;
  DestRect.Right := Dest.Right;

  with SourceRect do
  begin
    Left   := 180 + Separator * 5;
    Right  := Left + 5;
    Bottom := 0;
    Top    := 30;
  end;

  Digits.PartialDraw(Canvas, SourceRect, DestRect);
end;

constructor TSevenSegDisplay.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  Width := 110;
  Height := 40;
  Color := clBlack;
  PenColor := clBlack;
  Margin := 5;
end;

procedure TSevenSegDisplay.Redraw(const Rec: TRect);
var
  DestRect: TRect;
  DigitWidth, DigitHeight: LongInt;
  I, B: Byte;
begin
  inherited Redraw(Rec);

  DestRect := ClientRect;

  if BorderStyle = bsSingle then
    DrawSystemBorder(self, DestRect, bsSingle);

  if FSegments = '' then Exit;

  DigitWidth := (Width - 2 * FMargin) div Length(FSegments);
  DigitHeight := Height - 2 * FMargin;

  DestRect := Rect(FMargin, FMargin, FMargin + DigitWidth, FMargin + DigitHeight);

  for I := 1 to Length(FSegments) do
  begin
    B := Ord(FSegments[I]);

    if not IsRectEmpty(IntersectRect(Rec, DestRect)) then
      DrawDigit(Canvas, DestRect, B and 31, B shr 5);

    Inc(DestRect.Left, DigitWidth);
    Inc(DestRect.Right, DigitWidth);
  end;
end;

procedure TSevenSegDisplay.SetBorderStyle(Value: TBorderStyle);
begin
  FBorderStyle := Value;
  Invalidate;
end;

procedure TSevenSegDisplay.SetDigits(const Value: string);
var
  I: Integer;
  C: Char;
  D: Byte;
begin
  if Value <> FDigits then
  begin
    FSegments := '';
    I := 1;
    while I <= Length(Value) do
    begin
      C := UpCase(Value[I]);
      case C of
        '0' .. '9': D := Ord(C) - Ord('0');
        'A' .. 'F': D := 10 + Ord(C) - Ord('A');
        'H'       : D := 16;
        'I'       : D := 17;
        'J'       : D := 18;
        'L'       : D := 19;
        'N'       : D := 20;
        'O'       : D := 21;
        'R'       : D := 22;
        'S'       : D :=  5;
        'U'       : D := 23;
        'Y'       : D := 24;
        ' '       : D := 26;
        '-'       : D := 27;
        '_'       : D := 28;
      else
        D := 255;
      end;
      Inc(I);

      if I <= Length(Value) then
      begin
        C := UpCase(Value[I]);
        case C of
          '~':      Inc(I);
          '.', ',': begin
                      D := D or 64;
                      Inc(I);
                    end;
          ':':      begin
                      D := D or 96;
                      Inc(I);
                    end;
        else
          D := D or 32;
        end;
      end
      else D := D or 32;

      if D <> 255 then FSegments := FSegments + Chr(D);
    end;
  end;

  FDigits := Value;

  InvalidateRect(Rect(FMargin, FMargin, Width - FMargin, Height - FMargin));
end;

procedure TSevenSegDisplay.SetMargin(Value: LongInt);
begin
  FMargin := Value;
  Invalidate;
end;

initialization
  RegisterClasses([TSevenSegDisplay]);

  Digits := TBitmap.Create;
  Digits.LoadFromResourceName('SevenSegDigits');

finalization

  Digits.Free;
end.


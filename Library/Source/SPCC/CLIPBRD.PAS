
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ    Sibyl Portable Component Classes                                      บ
 บ                                                                          บ
 บ    Copyright (C) 1995..2000 SpeedSoft Germany,   All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


Unit ClipBrd;

Interface

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin,PmGpi,PmDev,PmStdDlg,PmBitmap,PmHelp;
{$ENDIF}

{$IFDEF Win32}
Uses WinDef,WinBase,WinNt,WinUser,WinGDI,CommCtrl;
{$ENDIF}

Uses Messages,SysUtils,Classes;

{Standard Clipboard formats For Use within the SetData method In TClipBoard}
{$IFDEF OS2}
Const
    cfText             = CF_TEXT;
    cfBitmap           = CF_BITMAP;
    cfMetaFile         = CF_METAFILE;
    cfPalette          = CF_PALETTE;
    cfDspText          = CF_DSPTEXT;
    cfDspBitmap        = CF_DSPBITMAP;
    cfDspMetaFile      = CF_DSPMETAFILE;
{$ENDIF}
{$IFDEF Win32}
Const
    cfText             = CF_TEXT;
    cfBitmap           = CF_BITMAP;
    cfMetaFile         = CF_METAFILEPICT;
    cfPalette          = CF_PALETTE;
    cfDspText          = CF_DSPTEXT;
    cfDspBitmap        = CF_DSPBITMAP;
    cfDspMetaFile      = CF_DSPMETAFILEPICT;
{$ENDIF}

Type
    TClipBoard=Class(TComponent)
      Private
         FOpenWin: HWindow;
         Function GetOwner:HWindow;
         Function GetViewer:HWindow;
         Procedure SetViewer(Viewer:HWindow);
         Function GetFormatCount:LongInt;
         Function GetFormats(Index:LongInt):LongWord;
         Function GetAsText:AnsiString;
         Procedure SetAsText(NewValue:AnsiString);
      Public
         Function Open(ahwnd:HWindow):Boolean;
         Function Close:Boolean;
         Function Empty:Boolean;
         Function CountFormats:LongInt;
         Function EnumFormats(FormatIndex:LongWord):LongWord;
         Function IsFormatAvailable(Format:LongWord):Boolean;
         Function RegisterFormat(Const S:String):LongWord;
         Function GetFormatName(format:LongWord):String;
         Procedure SetTextBuf(Buffer:PChar);
         Function HasFormat(Format:LongWord):Boolean;
         Procedure SetAsHandle(Format,Handle:LongWord);
         Function GetAsHandle(Format:LongWord):LongWord;
         Procedure Clear;
         Function AllocateMemory(Size:LongInt):Pointer;
         Property Parent:HWindow Read GetOwner;
         Property Viewer:HWindow Read GetViewer Write SetViewer;
         Property AsText:AnsiString read GetAsText write SetAsText;
         Property FormatCount:LongInt read GetFormatCount;
         Property Formats[Index:LongInt]:LongWord read GetFormats;
         Function SetData(Data,format:LongWord):Boolean;
         Function GetData(format:LongWord):LongWord;
    End;

Var ClipBoard:TClipBoard;

Implementation

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Portable Component Classes (SPCC)                                   บ
บ                                                                           บ
บ This section: TClipBoard Class Implementation                             บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TClipBoard.GetOwner:HWindow;
Begin
     {$IFDEF OS2}
     Result := WinQueryClipbrdOwner(AppHandle);
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetClipboardOwner;
     {$ENDIF}
End;

Function TClipBoard.GetViewer:HWindow;
Begin
     {$IFDEF OS2}
     Result := WinQueryClipbrdViewer(AppHandle);
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetClipboardViewer;
     {$ENDIF}
End;

Procedure TClipBoard.SetViewer(Viewer:HWindow);
Begin
     {$IFDEF OS2}
     WinSetClipbrdViewer(AppHandle,Viewer);
     {$ENDIF}
     {$IFDEF Win32}
     SetClipboardViewer(Viewer);
     {$ENDIF}
End;


Function TClipBoard.Open(ahwnd:HWindow):Boolean;
Begin
     FOpenWin := ahwnd;
     {$IFDEF OS2}
     Result := WinOpenClipbrd(AppHandle);
     {$ENDIF}
     {$IFDEF Win32}
     Result := OpenClipboard(FOpenWin);
     {$ENDIF}
End;


Function TClipBoard.Close:Boolean;
Begin
     {$IFDEF OS2}
     Result := WinCloseClipbrd(AppHandle);
     {$ENDIF}
     {$IFDEF Win32}
     Result := CloseClipboard;
     {$ENDIF}
End;


Function TClipBoard.Empty:Boolean;
Begin
     {$IFDEF OS2}
     Result := WinEmptyClipbrd(AppHandle);
     If FOpenWin<>0 Then WinSetClipbrdOwner(AppHandle,FOpenWin);
     {$ENDIF}
     {$IFDEF Win32}
     Result := EmptyClipboard;
     {$ENDIF}
End;

Function TClipBoard.GetFormatCount:LongInt;
Begin
     Result:=CountFormats;
End;

Function TClipBoard.GetFormats(Index:LongInt):LongWord;
Begin
     Result:=EnumFormats(Index);
End;

Function TClipBoard.GetAsText:AnsiString;
Var p:PChar;
Begin
     p:=Pointer(GetData(cfText));
     If p=Nil Then Result:=''
     Else Result:=p^;
End;

Procedure TClipBoard.SetAsText(NewValue:AnsiString);
Begin
     SetTextBuf(PChar(NewValue));
End;

Procedure TClipBoard.SetTextBuf(Buffer:PChar);
Var Temp:PChar;
Begin
     If Buffer=Nil Then Empty
     Else
     Begin
          Temp:=AllocateMemory(length(Buffer^)+1);
          System.Move(Buffer^,Temp^,length(Buffer^)+1);
          SetData(LongWord(Temp),cfText);
     End;
End;

Function TClipBoard.AllocateMemory(Size:LongInt):Pointer;
Begin
     GetSharedMem(Result,Size);
End;

Function TClipBoard.HasFormat(Format:LongWord):Boolean;
Begin
     Result:=IsFormatAvailable(Format);
End;

Procedure TClipBoard.Clear;
Begin
     Empty;
End;

Function TClipBoard.SetData(Data,format:LongWord):Boolean;
{$IFDEF OS2}
Var  formatinfo:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If format In [cfBitmap,cfMetaFile,cfPalette,cfDspBitmap,cfDspMetaFile]
     Then formatinfo := CFI_HANDLE
     Else formatinfo := CFI_POINTER;
     Result := WinSetClipbrdData(AppHandle,Data,format,formatinfo);
     {$ENDIF}
     {$IFDEF Win32}
     Result := SetClipboardData(format,Data) <> 0;
     {$ENDIF}
End;


Function TClipBoard.GetData(format:LongWord):LongWord;
Begin
     {$IFDEF OS2}
     Result := WinQueryClipbrdData(AppHandle,format);
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetClipboardData(format);
     {$ENDIF}
End;

Procedure TClipBoard.SetAsHandle(Format,Handle:LongWord);
Begin
     SetData(Format,Handle);
End;

Function TClipBoard.GetAsHandle(Format:LongWord):LongWord;
Begin
     Result:=GetData(Format);
End;

Function TClipBoard.CountFormats:LongInt;
{$IFDEF OS2}
Var  ulNext:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Result := 0;
     ulNext := WinEnumClipbrdFmts(AppHandle,0);
     While ulNext <> 0 Do
     Begin
          Inc(Result);
          ulNext := WinEnumClipbrdFmts(AppHandle,ulNext);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     Result := CountClipboardFormats;
     {$ENDIF}
End;


Function TClipBoard.EnumFormats(FormatIndex:LongWord):LongWord;
Begin
     {$IFDEF OS2}
     Result := WinEnumClipbrdFmts(AppHandle,FormatIndex);
     {$ENDIF}
     {$IFDEF Win32}
     Result := EnumClipboardFormats(FormatIndex);
     {$ENDIF}
End;


Function TClipBoard.IsFormatAvailable(format:LongWord):Boolean;
{$IFDEF OS2}
Var  formatinfo:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Result := WinQueryClipbrdFmtInfo(AppHandle,format,formatinfo);
     {$ENDIF}
     {$IFDEF Win32}
     Result := IsClipboardFormatAvailable(format);
     {$ENDIF}
End;


Function TClipBoard.RegisterFormat(Const S:String):LongWord;
Var  CS:Cstring;
Begin
     CS := S;
     {$IFDEF OS2}
     Result := WinAddAtom(WinQuerySystemAtomTable,CS);
     {$ENDIF}
     {$IFDEF Win32}
     Result := RegisterClipboardFormat(CS);
     {$ENDIF}
End;


Function TClipBoard.GetFormatName(format:LongWord):String;
Var  L:LongInt;
     CS:Cstring;
Begin
     {$IFDEF OS2}
     L := WinQueryAtomName(WinQuerySystemAtomTable,format,CS,SizeOf(CS));
     {$ENDIF}
     {$IFDEF Win32}
     L := GetClipboardFormatName(format,CS,SizeOf(CS));
     {$ENDIF}
     If L = 0 Then
       If IsFormatAvailable(format) Then CS := '#'+tostr(format)
       Else CS:='';
     Result := CS;
End;

Begin
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  26-Sep-02   WD        Ausbau der LINUX-Teile

}

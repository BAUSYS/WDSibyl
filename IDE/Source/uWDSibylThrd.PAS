Unit uWDSibylThrd;

Interface

// Wenn das Programm im Debug-Modus gestartet wird, den Thread auch deaktivieren.
// Ansonsten kommt es zu unangenehmen nebeneffekte

Uses
  Classes, uSysClass, SysUtils;

Const ThrdWait       = 1000;
      ThrdWaitDestory= 100;

Type
  tWDSibylThrd = Class(TThread)
    Private
      fThrdClose : Boolean;
      Procedure CheckModFiles;
    Protected
      Procedure Execute; Override;
    Public
      Constructor Create; Virtual;
      Destructor Destroy; Override;

      Property ThrdClose : Boolean Read fThrdClose Write fThrdClose;
   End;

Var WDSibylThrd: tWDSibylThrd;

Implementation

Uses Consts, Sib_Prj, Sib_Edit, Forms, Dialogs;

Procedure tWDSibylThrd.CheckModFiles;

Var t      : LongInt;
    FN     : tFileName;
    txt    : String;
    Control: TSibEditor;
    DirInfo: tSearchRec;
    mbRet  : TMsgDlgReturn;

Begin
  IF CodeEditorRef = NIL THEN exit;   //beim VDE Start; CodeEditorRef in Consts definiert
  FOR t := 0 TO CodeEditorRef.MDIChildCount-1 DO
    BEGIN
      Control := TSibEditor(CodeEditorRef.MDIChildren[t]);
      if Control<>nil then
        Begin
          FN:=Control.FileName;
          if (SysUtils.FindFirst(FN, faAnyFile, DirInfo)=0) then
            Begin
              if (Control.FileSize <> DirInfo.Size) or
                 (Control.FileDateTime <> DirInfo.Time) then
                Begin
                  Txt:=FmtLoadNLSStr(SiFileModifiedReOpen,[FN]);
                  if Dialogs.MessageBox(txt, mtInformation,mbYesNo) = mrYes
                    then Control.ReOpenFile
                    else
                      Begin
                        Control.FileSize    := DirInfo.Size;
                        Control.FileDateTime:= DirInfo.Time;
                      End;
                End;
              SysUtils.FindClose(DirInfo);
            End;
        End;
    END;
End;

Procedure tWDSibylThrd.Execute;
Begin
  fThrdClose:=false;
  Repeat
    SysSleep(ThrdWait);    // 1 Sekunde warten.
    if (Application.Terminated=false) and (fThrdClose=false) then
      Begin
        CheckModFiles;
      End;
  Until fThrdClose;
End;

constructor tWDSibylThrd.Create;

Begin
  inherited Create(true);
  fThrdClose:=false;
End;

Destructor tWDSibylThrd.Destroy;

var Cou : LongWord;

Begin
  Cou:=0;
  Suspend;
  SysSleep(100);
  inherited Destroy;
End;

Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  19-Nov-06  WD         Unit und Thread programmiert
}


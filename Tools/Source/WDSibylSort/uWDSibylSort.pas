Unit uWDSibylSort;

Interface    

Uses
  Classes, Forms, Graphics, Buttons, Dialogs, StdCtrls,
  uString;

Type
  TMainForm = Class (TForm)
    OpenButton: TButton;
    OpenDialog: TOpenDialog;
    ProjectMemo: TMemo;
    SaveButton: TButton;
    SortFilesButton: TButton;
    Procedure SortFilesButtonOnClick (Sender: TObject);
    Procedure SaveButtonOnClick (Sender: TObject);
    Procedure OpenButtonOnClick (Sender: TObject);
  Public
    FileName: string;
  End;

Var
  MainForm: TMainForm;

Implementation

uses
  SysUtils;

Procedure TMainForm.SortFilesButtonOnClick (Sender: TObject);
var
  FileIndex: integer;
  KeyName: string;
  KeyValue: string;
  Files: TStringList;
Begin
//  MainFile0.File0
  FileIndex:= 0;

  Files:= TStringList.Create;

  Screen.Cursor:= crHourGlass;

  repeat
    KeyName:= 'MainFile0.File' + IntToStr( FileIndex );
    KeyValue:= ProjectMemo.Lines.Values[ KeyName ];
    if KeyValue = '' then
      break;
    if UpperCase( KeyValue ) = '[DEPENDENCIES]' then
      break;
    Files.Add( KeyValue );
    inc( FileIndex );
  until false;
  Files.Sort;
  ProjectMemo.BeginUpdate;
  while FileIndex > 0 do
  begin
    dec( FileIndex );
    KeyName:= 'MainFile0.File' + IntToStr( FileIndex );
    ProjectMemo.Lines.Values[ KeyName ]:= FIles[ FileIndex ];
  end;
  ProjectMemo.EndUpdate;
  Screen.Cursor:= crDefault;
  Files.Destroy;
End;

Procedure TMainForm.SaveButtonOnClick (Sender: TObject);
var
  F: TextFile;
  BackupFileName: string;
Begin
  if FileName = '' then
    exit;
  BackupFileName:= ChangeFileExt( Filename, '.spb' );
  AssignFile( F, BackupFileName );
  Erase( F );
  AssignFile( F, Filename );
  Rename( F, BackupFileName );
  ProjectMemo.Lines.SaveToFile( FileName );

End;

Procedure TMainForm.OpenButtonOnClick (Sender: TObject);
Begin
  if OpenDialog.Execute then
  begin
    try
      ProjectMemo.BeginUpdate;
      ProjectMemo.Lines.LoadFromFile( OpenDialog.FileName );
      ProjectMemo.EndUpdate;
      FileName:= OpenDialog.FileName;
    except
      ShowMessage( 'Could not load ' + OpenDialog.FileName );
    end;
  end;
End;

Initialization
  RegisterClasses ([TMainForm, TButton, TOpenDialog, TMemo]);
End.

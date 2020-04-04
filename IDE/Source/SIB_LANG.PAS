Unit SIB_LANG;

Interface

USES SysUtils,Classes,Forms,Menus, Dialogs,IniFiles,
     uSysInfo, uSysClass, uString, uList, uStream, 
     Consts, SIB_PRJ, FormEdit, Sib_Edit, SPC_Data;


Procedure CreateLngFile;

Implementation

Procedure CreateLngFile;

Var LngFile    : TAsciiIniFile;
    LngFileName: tFileName;
    frmCou     : LongInt;
    FormItem   : PFormListItem;
    FormOpen   : Boolean;
    Form       : tForm;

/*    CmpCou     : LongInt;

    Component  : tComponent;
    Section   : String; */

Begin
  LngFileName:=GetLngName;
  SetCompilerStatusMessage(LoadNLSStr(SiMenuCreateLngFileHint)+':' + LngFileName,'',errNone,0,0);
  try
    LngFile.Create(LngFileName);
    SetCompilerStatusMessage('Forms count: ' + tostr(Project.Forms.Count),'',errNone,0,0);
    for frmCou := 0 to Project.Forms.Count-1 do
      Begin     
        FormOpen:=false;
        FormItem := Project.Forms.Items[frmCou];

// Falls die Form nich offen ist, dann die Form oeffnen
        if FormItem^.Form = nil then
          Begin
            SetCompilerStatusMessage('Open:','',errNone,0,0);
//            OpenFormWindow(FormItem^.FormName);
            FormOpen:=true;
          End;
        Form := tForm(FormItem^.Form);
        if Form = nil then
          Begin
            SetCompilerStatusMessage(FormItem^.FormName+' not open','',errNone,0,0);
            continue;  // naechste Form einelsen
          End;
        SetCompilerStatusMessage('Write '+FormItem^.FormName+' open','',errNone,0,0)

// Die Form wieder schliessen
/*        if FormOpen then
          Begin
            Form.Close;
            FormItem^.Form:=nil;
          End; */
      End;

    SetCompilerStatusMessage(FmtLoadNLSStr(SiFileCreated,[LngFile.FileName]),'',errNone,0,0);

/*    LngFile.Create(GetLngName, fmCreate);
    for frmCou := 0 to Project.Forms.Count-1 do
      Begin
        FormOpen:=false;
        FormItem := Project.Forms.Items[frmCou];
        if FormItem^.Form = nil then
          Begin
            OpenFormWindow(FormItem^.FormName);
            FormOpen:=true;
          End;
        Form     := tForm(FormItem^.Form);
        if Form = nil
          then
            LngFile.Writeln('{ ' + FormItem^.FormName+' nicht offen }')
          else
            Begin
              LngFile.Writeln(Form.Name+'='+Form.Caption);
              for CmpCou:=0 to Form.ComponentCount-1 do
                Begin
                  Value_Cap :='';
                  Value_Hint:='';
                  Component:=Form.Components[CmpCou];
                  if Component is tControl
                  then
                    Begin
                      Value_Cap:=tControl(Component).Caption;
                      Value_Hint:=tControl(Component).Hint;
                    End
                  else
                    if Component is tMenuItem then
                      Begin
                        Value_Cap:=tMenuItem(Component).Caption;
                        Value_Hint:=tMenuItem(Component).Hint;
                      End;
                  Application.LogWriteln('Lng:' + Value_Cap + ', ' + Value_Hint);
                  if Value_Cap<>'' then
                    LngFile.Writeln(Form.Name+'.'+Component.Name+cLng_Caption+Value_Cap);
                  if Value_Hint<>'' then
                    LngFile.Writeln(Form.Name+'.'+Component.Name+cLng_Hint+Value_Hint);
                End;
            End;
        if FormOpen then
          Begin
            Form.Close;
            FormItem^.Form:=nil;
          End;
      End;
    LngFile.Destroy;
    MessageBox(FmtLoadNLSStr(SiFileCreated,[LngFile.FileName]),
               mtInformation, [mbOk]);
      SetCompilerStatusMessage(FmtLoadNLSStr(SiFileCreated,[LngFile.FileName]),'',errNone,0,0); }

*/
  except
    On E:Exception Do
      Begin
        ErrorBox(FmtLoadNLSStr(SiFileWriteError,[LngFile.FileName]));
      End;
  end;

End;


Initialization
End.

{ -- date -- -- from -- -- changes ----------------------------------------------
  29-Aug-05  WD         Erstellung der Datei
}
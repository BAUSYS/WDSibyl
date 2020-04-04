Unit uAppExp;

Interface

Uses
  Classes, Forms, Graphics, Buttons, Grids, StdCtrls, ExtCtrls, ToolsApi,
  Dialogs, Messages, Color, Menus, uList, uStream;

{$R AppExp}      //Bitmaps
{$r AppExp.scu}  //SCU Information

Type
    //App Expert             
    TAppExpert=Class(TIExpert)
        Function GetName:String; Override;
        Function GetAuthor:String; Override;
        Function GetComment:String; Override;
        Function GetPage:String; Override;
        Function GetGlyph: TBitmap; Override;
        Function GetStyle: TExpertStyle; Override;
        Function GetState: TExpertState; Override;
        Function GetIDString:String; Override;
        Function GetMenuText:String; Override;
        Procedure Execute; Override;
        Procedure Register; Override;
        Procedure Unload; Override;
    End;

//The first window of the expert
Type
  TAppExpertDlg0 = Class (TForm)
    Image1: TImage;
    NextBtn: TBitBtn;
    CancelBtn: TBitBtn;
    MainPanel: TPanel;
    InfoLabel: TLabel;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    VisualPrj: TRadioButton;
    NonvisualPrj: TRadioButton;
    GroupBox2: TGroupBox;
    AppTypeProgram: TRadioButton;
    AppTypeDLL: TRadioButton;
    Label1: TLabel;
    Procedure NonvisualPrjOnClick (Sender: TComponent);
    Procedure VisualPrjOnClick (Sender: TComponent);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var AppExpertDlg0: TAppExpertDlg0;

Implementation

Procedure RegisterBitmaps;Forward;
Procedure UnregisterBitmaps;Forward;
Function BitmapFromCommand(Command:TCommand):TBitmap;Forward;

//Private classes
Type
  TAppExpertDlg1 = Class (TForm)
    Image1: TImage;
    BackBtn: TBitBtn;
    CancelBtn: TBitBtn;
    MainPanel: TPanel;
    InfoLabel: TLabel;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    FileCheck: TCheckBox;
    FileCheckLabel: TLabel;
    EditCheck: TCheckBox;
    EditCheckLabel: TLabel;
    WindowCheck: TCheckBox;
    WindowCheckLabel: TLabel;
    HelpCheck: TCheckBox;
    HelpCheckLabel: TLabel;
    NextBtn: TBitBtn;
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Type
  TAppExpertDlg2 = Class (TForm)
    Image1: TImage;
    MainPanel: TPanel;
    BackBtn: TBitBtn;
    NextBtn: TBitBtn;
    CancelBtn: TBitBtn;
    AssocGrid: TStringGrid;
    InfoLabel: TLabel;
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Type
  TAppExpertDlg3 = Class (TForm)
    Image1: TImage;
    BackBtn: TBitBtn;
    NextBtn: TBitBtn;
    CancelBtn: TBitBtn;
    MainPanel: TPanel;
    InfoLabel: TLabel;
    Bevel1: TBevel;
    SpeedBarLayoutLabel: TLabel;
    SpeedBarLayout: TPanel;
    MenuEntriesLabel: TLabel;
    MenuListBox: TListBox;
    CommandsListBox: TListBox;
    AvailCommandsLabel: TLabel;
    InsertBtn: TBitBtn;
    RemoveBtn: TBitBtn;
    SpaceBtn: TBitBtn;
    Procedure SpeedBarLayoutOnPaint (Sender: TComponent; Const rec: TRect);
    Procedure InsertBtnOnClick (Sender: TComponent);
    Procedure RemoveBtnOnClick (Sender: TComponent);
    Procedure SpaceBtnOnClick (Sender: TComponent);
    Procedure SpeedBarLayoutOnMouseDown (Sender: TComponent;
      Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
    Procedure SpeedBarLayoutOnDestroy (Sender: TComponent);
    Procedure MenuListBoxOnItemFocus (Sender: TComponent; Index: LongInt);
    Procedure CommandsListBoxOnDrawItem (Sender: TComponent; Index: LongInt;
                                  Rec: TRect; State: TOwnerDrawState);
  Private
    {Insert private declarations here}
    ButtonList:TList;
    ButtonPos:LONGINT;
  Public
    {Insert public declarations here}
    Procedure AddButton(Command:TCommand);
    Procedure RemoveButton;
  End;

Type
  TAppExpertDlg4 = Class (TForm)
    Image1: TImage;
    BackBtn: TBitBtn;
    FinishBtn: TBitBtn;
    CancelBtn: TBitBtn;
    MainPanel: TPanel;
    InfoLabel: TLabel;
    GroupBox1: TGroupBox;
    HintsCheck: TCheckBox;
    StatusBarCheck: TCheckBox;
    Bevel1: TBevel;
    ProjectNameLabel: TLabel;
    PrjNameEdit: TEdit;
    Label1: TLabel;
    PrjDirEdit: TEdit;
    BitBtn1: TBitBtn;
    ChangeDirDialog1: TChangeDirDialog;
    Procedure BitBtn1OnClick (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var AppExpertDlg1: TAppExpertDlg1;
    AppExpertDlg2: TAppExpertDlg2;
    AppExpertDlg3: TAppExpertDlg3;
    AppExpertDlg4: TAppExpertDlg4;


{*************************************************************************************
 *                                                                                   *
 *                                                                                   *
 * TAppExpertDlg0 Class implementation                                               *
 *                                                                                   *
 *                                                                                   *
 *************************************************************************************}

Procedure TAppExpertDlg0.NonvisualPrjOnClick (Sender: TComponent);
Begin
  AppTypeProgram.Enabled:=TRUE;
  AppTypeDLL.Enabled:=TRUE;
End;

Procedure TAppExpertDlg0.VisualPrjOnClick (Sender: TComponent);
Begin
  AppTypeProgram.Checked:=TRUE;
  AppTypeProgram.Enabled:=FALSE;
  AppTypeDLL.Enabled:=FALSE;
End;

{*************************************************************************************
 *                                                                                   *
 *                                                                                   *
 * TAppExpertDlg3 Class implementation                                               *
 *                                                                                   *
 *                                                                                   *
 *************************************************************************************}


Const
    BmpFileOpen   =1;
    BmpFileNew    =2;
    BmpFileSave   =3;
    BmpFileSaveAs =4;
    BmpCut        =5;
    BmpCopy       =6;
    BmpPaste      =7;
    BmpUndo       =8;
    BmpRedo       =9;
    BmpTile       =10;
    BmpCascade    =11;
    BmpHelp       =12;

Var Bitmaps:Array[BmpFileOpen..BmpHelp] OF TBitmap;

Type TAppMenuItems=RECORD
                         Name:String[10];
                         Command:TCommand;
                   End;

Const AppMenuItems:Array[BmpFileOpen..BmpHelp] Of TAppMenuItems=
         (
          (Name:'Open';Command:cmNew),
          (Name:'New';Command:cmOpen),
          (Name:'Save';Command:cmSave),
          (Name:'Save As';Command:cmSaveAs),
          (Name:'Cut';Command:cmCut),
          (Name:'Copy';Command:cmCopy),
          (Name:'Paste';Command:cmPaste),
          (Name:'Undo';Command:cmUndo),
          (Name:'Redo';Command:cmRedo),
          (Name:'Tile';Command:cmTile),
          (Name:'Cascade';Command:cmCascade),
          (Name:'Help';Command:cmHelp)
         );

Procedure TAppExpertDlg3.SpeedBarLayoutOnPaint (Sender: TComponent; Const rec: TRect);
Var t:LongInt;
    Command:TCommand;
    Bitmap:TBitmap;
    x:LONGINT;
    rc:TRect;
Begin
     SpeedBarLayOut.Canvas.ClipRect:=rec;

     t:=0;
     If ButtonList<>Nil Then
     Begin
          x:=7;
          For t:=0 To ButtonList.Count-1 Do
          Begin
               If t=ButtonPos Then
               Begin
                    With SpeedBarLayOut Do
                    Begin
                         Canvas.Polygon([Point(x-3,2),Point(x+3,2),Point(x,6)]);
                         Canvas.BeginPath;
                         Canvas.PolyLine([Point(x-3,2),Point(x+3,2),Point(x,6)]);
                         Canvas.EndPath;
                         Canvas.PathToClipRegion(paDiff);
                    End;
               End;

               Command:=TCommand(ButtonList[t]);
               If Command=cmNull Then //Space
               Begin
                    inc(x,5);
               End
               Else
               Begin
                    Bitmap:=BitmapFromCommand(Command);
                    If Bitmap<>Nil Then
                    Begin
                         rc.Left:=x;
                         rc.Bottom:=8;
                         rc.Top:=rc.Bottom+20;
                         rc.Right:=rc.Left+20;
                         With SpeedBarLayout Do
                         Begin
                             Canvas.StretchDraw(rc.Left,rc.Bottom,20,20,Bitmap);
                             Canvas.ShadowedBorder(rc,clWhite,clBlack);
                             Canvas.ExcludeClipRect(rc);
                         End;
                         inc(x,20+1);
                    End;
               End;
          End;
     End;

     If t=ButtonPos Then
     Begin
          With SpeedBarLayOut Do
          Begin
               Canvas.Polygon([Point(x-3,2),Point(x+3,2),Point(x,6)]);
               Canvas.BeginPath;
               Canvas.PolyLine([Point(x-3,2),Point(x+3,2),Point(x,6)]);
               Canvas.EndPath;
               Canvas.PathToClipRegion(paDiff);
          End;
     End;

     SpeedBarLayout.Redraw(rec);
End;


Procedure TAppExpertDlg3.AddButton(Command:TCommand);
Begin
     If ButtonList=Nil Then ButtonList.Create;
     If ButtonPos=ButtonList.Count Then ButtonList.Add(Pointer(Command))
     Else ButtonList.Insert(ButtonPos,Pointer(Command));
     inc(ButtonPos);
     SpeedBarLayout.Refresh;
End;

Procedure TAppExpertDlg3.RemoveButton;
Begin
     If ((ButtonList=Nil)Or(ButtonList.Count=0)Or(ButtonPos>ButtonList.Count-1)) Then Exit;
     ButtonList.Delete(ButtonPos);
     If ButtonPos>ButtonList.Count Then ButtonPos:=ButtonList.Count;
     SpeedBarLayout.Refresh;
End;

Procedure TAppExpertDlg3.InsertBtnOnClick (Sender: TComponent);
Var s:String;
    t:LongInt;
Begin
     If AppExpertDlg3.CommandsListBox.ItemIndex<0 Then exit;
     s:=AppExpertDlg3.CommandsListBox.Items[AppExpertDlg3.CommandsListBox.ItemIndex];
     For t:=BmpFileOpen To BmpHelp Do If AppMenuItems[t].Name=s Then
     Begin
          AddButton(AppMenuItems[t].Command);
          exit;
     End;
End;

Procedure TAppExpertDlg3.RemoveBtnOnClick (Sender: TComponent);
Begin
  RemoveButton;
End;

Procedure TAppExpertDlg3.SpaceBtnOnClick (Sender: TComponent);
Begin
  AddButton(cmNull);  //Space
End;

Procedure TAppExpertDlg3.SpeedBarLayoutOnMouseDown (Sender: TComponent;
               Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
Var PosX:Longint;
    t:Longint;
    Command:TCommand;
Begin
     If Button=mbLeft Then
     Begin
          If X<7 Then
          Begin
               ButtonPos:=0;
               SpeedBarLayout.Refresh;
               exit;
          End
          Else If ButtonList<>Nil Then
          Begin
               PosX:=7;
               For t:=0 To ButtonList.Count-1 Do
               Begin
                    Command:=TCommand(ButtonList[t]);
                    If Command=cmNull Then
                    Begin
                         inc(PosX,5);
                         If X<=PosX Then If X>=PosX-5 Then
                         Begin
                              ButtonPos:=t;
                              SpeedBarLayout.Refresh;
                              exit;
                         End;
                    End
                    Else
                    Begin
                         inc(PosX,20+1);
                         If X>=PosX-20 Then If X<=PosX Then
                         Begin
                              If X>PosX-10 Then ButtonPos:=t+1
                              Else ButtonPos:=t;
                              SpeedBarLayout.Refresh;
                              exit;
                         End;
                    End;
               End;
          End;
     End;
End;

Procedure TAppExpertDlg3.SpeedBarLayoutOnDestroy (Sender: TComponent);
Begin
   If ButtonList<>Nil Then ButtonList.Destroy;
End;

Procedure TAppExpertDlg3.MenuListBoxOnItemFocus (Sender: TComponent; Index: LongInt);
Var s:String;
Begin
  CommandsListBox.BeginUpdate;
  CommandsListBox.Items.Clear;

  s:=MenuListBox.Items[Index];
  If s='File' Then
  Begin
       CommandsListBox.Items.Add('New');
       CommandsListBox.Items.Add('Open');
       CommandsListBox.Items.Add('Save');
       CommandsListBox.Items.Add('Save As');
  End
  Else If s='Edit' Then
  Begin
       CommandsListBox.Items.Add('Cut');
       CommandsListBox.Items.Add('Copy');
       CommandsListBox.Items.Add('Paste');
       CommandsListBox.Items.Add('Undo');
       CommandsListBox.Items.Add('Redo');
  End
  Else If s='Window' Then
  Begin
       CommandsListBox.Items.Add('Tile');
       CommandsListBox.Items.Add('Cascade');
  End
  Else If s='Help' Then
  Begin
       CommandsListBox.Items.Add('Help');
  End;

  CommandsListBox.EndUpdate;
End;

Procedure TAppExpertDlg3.CommandsListBoxOnDrawItem (Sender: TComponent;
                                             Index: LongInt; Rec: TRect; State: TOwnerDrawState);
Var s:String;
    Command:TCommand;
    t,W:LONGINT;
    Bitmap:TBitmap;
    rc:TRect;
Begin
     CommandsListBox.Canvas.ClipRect:=rec;

     s:=CommandsListBox.Items[Index];
     Command:=cmNull;
     For t:=BmpFileOpen To BmpHelp Do
       If AppMenuItems[t].Name=s Then
       Begin
            Command:=AppMenuItems[t].Command;
            break;
       End;

     W:=rec.Top-rec.Bottom-2;
     Bitmap:=BitmapFromCommand(Command);
     If Bitmap<>Nil Then
     Begin
          rc.Left:=rec.Left+1;
          rc.Bottom:=rec.Bottom+1;
          rc.Right:=rc.Left+W;
          rc.Top:=rc.Bottom+W;
          CommandsListBox.Canvas.StretchDraw(rc.Left,rc.Bottom,W,W,Bitmap);
          CommandsListBox.Canvas.ExcludeClipRect(rc);
     End;

     If State*[odSelected]<>[] Then CommandsListBox.Canvas.FillRect(rec,clDkGray)
     Else CommandsListBox.Canvas.FillRect(rec,CommandsListBox.Color);

     If State*[odSelected]<>[] Then
     Begin
          CommandsListBox.Canvas.Pen.Color:=clWhite;
          CommandsListBox.Canvas.Brush.Color:=clDkGray;
     End
     Else
     Begin
          CommandsListBox.Canvas.Pen.Color:=clBlack;
          CommandsListBox.Canvas.Brush.Color:=CommandsListBox.Color;
     End;
     CommandsListBox.Canvas.TextOut(rec.Left+W+5,rec.Bottom+5,s);

     CommandsListBox.Canvas.DeleteClipRegion;
End;

Procedure RegisterBitmaps;
Var t:Longint;
Begin
     For t:=BmpFileOpen To BmpHelp Do Bitmaps[t].Create;

     Bitmaps[BmpFileOpen].LoadFromResourceName('EXPTDEMO_Open');
     Bitmaps[BmpFileNew].LoadFromResourceName('EXPTDEMO_New');
     Bitmaps[BmpFileSave].LoadFromResourceName('EXPTDEMO_Save');
     Bitmaps[BmpFileSaveAs].LoadFromResourceName('EXPTDEMO_SaveAs');
     Bitmaps[BmpCut].LoadFromResourceName('EXPTDEMO_Cut');
     Bitmaps[BmpCopy].LoadFromResourceName('EXPTDEMO_Copy');
     Bitmaps[BmpPaste].LoadFromResourceName('EXPTDEMO_Paste');
     Bitmaps[BmpUndo].LoadFromResourceName('EXPTDEMO_Undo');
     Bitmaps[BmpRedo].LoadFromResourceName('EXPTDEMO_Redo');
     Bitmaps[BmpTile].LoadFromResourceName('EXPTDEMO_Tile');
     Bitmaps[BmpCascade].LoadFromResourceName('EXPTDEMO_Cascade');
     Bitmaps[BmpHelp].LoadFromResourceName('EXPTDEMO_Help');
End;

Function BitmapFromCommand(Command:TCommand):TBitmap;
Var Index:Longint;
Begin
     Case Command Of
         cmNew:Index:=BmpFileNew;
         cmOpen:Index:=BmpFileOpen;
         cmSave:Index:=BmpFileSave;
         cmSaveAs:Index:=BmpFileSaveAs;
         cmCut:Index:=BmpCut;
         cmCopy:Index:=BmpCopy;
         cmPaste:Index:=BmpPaste;
         cmUndo:Index:=BmpUndo;
         cmRedo:Index:=BmpRedo;
         cmTile:Index:=BmpTile;
         cmCascade:Index:=BmpCascade;
         cmHelp:Index:=BmpHelp;
         Else Index:=0;
     End;

     If Index>0 Then result:=Bitmaps[Index]
     Else result:=Nil;
End;

Procedure UnregisterBitmaps;
Var t:LongInt;
Begin
     For t:=BmpFileOpen To BmpHelp Do Bitmaps[t].Destroy;
End;

Procedure TAppExpertDlg4.BitBtn1OnClick (Sender: TObject);
Begin
  If ChangeDirDialog1.Execute Then PrjDirEdit.Text:=ChangeDirDialog1.Directory;
End;


{*************************************************************************************
 *                                                                                   *
 *                                                                                   *
 * TAppExpert Class implementation                                                   *
 *                                                                                   *
 *                                                                                   *
 *************************************************************************************}


Function TAppExpert.GetName:String;
Begin
     result:='AppExpert';
End;

Function TAppExpert.GetAuthor:String;
Begin
     result:='SpeedSoft';
End;

Function TAppExpert.GetComment:String;
Begin
     result:='(C) 1997 SpeedSoft.';
End;

Function TAppExpert.GetPage:String;
Begin
     result:='Projects';
End;

Function TAppExpert.GetGlyph: TBitmap;
CONST AppBitmap:TBitmap=Nil;
Begin
     If AppBitmap=Nil Then
     Begin
          AppBitmap.Create;
          AppBitmap.LoadFromResourceName('SpeedSoft_AppExp');
     End;
     result:=AppBitmap;
End;

Function TAppExpert.GetStyle: TExpertStyle;
Begin
     result:=esProject;
End;

Function TAppExpert.GetState: TExpertState;
Begin
     result:=[esEnabled];
End;

Function TAppExpert.GetIDString:String;
Begin
     result:='SpeedSoft.AppExpert';
End;

Function TAppExpert.GetMenuText:String;
Begin
     result:='~AppExpert';
End;

Procedure TAppExpert.Execute;
CONST
     FileCheck   =1;
     EditCheck   =2;
     WindowCheck =4;
     HelpCheck   =8;

     ShowHints         =1;
     EnableStatusBar   =2;

     MenuIDEEditStr    = '..........';

Var ModuleName,UnitIdent:String;
    MI:TIModuleInterface;
    FI:TIFormInterface;
    Form,ToolBar,Button,MainMenu,Menu,SubMenu,OpenDialog,SaveAsDialog:TIComponentInterface;
    Component:TComponent;
    ModalResult0,ModalResult1,ModalResult2,ModalResult3,ModalResult4:TCommand;
    Run:BOOLEAN;
    s,Filter,DefaultExt:String;
    MenuOptions,PrjOptions:LONGWORD;
    ToolBarButtons:TList;
    TheForm:TForm;
    t:LONGINT;               
    Command:TCommand;
    X:LONGINT;
    Bitmap:TBitmap;
    PrjName:String;
    VisualPrj:BOOLEAN;
    AppTypeDll:BOOLEAN;

    Procedure SetupMenuList;
    Begin
         With AppExpertDlg3.MenuListBox Do
         Begin
              BeginUpdate;
              Items.Clear;
           
              If MenuOptions And FileCheck<>0 Then Items.Add('File');
              If MenuOptions And EditCheck<>0 Then Items.Add('Edit');
              If MenuOptions And WindowCheck<>0 Then Items.Add('Window');
              If MenuOptions And HelpCheck<>0 Then Items.Add('Help');

              EndUpdate;
         End;
    End;

    Procedure GetResults;
    Var t:LONGINT;
        Command:TCommand;
        dir:String;
    Begin
         If ToolBarButtons=Nil Then ToolBarButtons.Create
         Else ToolBarButtons.Clear;

         If AppExpertDlg3.ButtonList<>Nil Then
           For t:=0 TO AppExpertDlg3.ButtonList.Count-1 Do
           Begin
                Command:=TCommand(AppExpertDlg3.ButtonList[t]);
                ToolBarButtons.Add(Pointer(Command));
           End;

         dir:=AppExpertDlg4.PrjDirEdit.Text;
         If dir[length(Dir)] IN ['/','\'] Then dec(dir[0]);
         {$I-}
         ChDir(Dir);
         {$I+}
         If IoResult<>0 Then
         Begin
              ErrorBox('Application directory does not exist');
              PrjName:='';
         End
         Else PrjName:=Dir+'\'+AppExpertDlg4.PrjNameEdit.Text;
    End;

    Procedure NewMenuItem(CONST Caption,Id:String;Command:TCommand);
    Var Stream:TMemoryStream;
    Begin
         SubMenu:=FI.CreateComponent(Menu,'TMenuItem','MenuItem'+Id,0,0,0,0);
         Component:=SubMenu.GetComponentHandle;
         TMenuItem(Component).Caption:=Caption;
         TMenuItem(Component).Command:=Command;
         If Id<>'' Then
         Begin
             Case Command Of
               cmOpen:
               Begin
                   Stream.Create;
                   Stream.Writeln('Begin');
                   Stream.Writeln('   If OpenDialog1.Execute Then');
                   Stream.Writeln('   Begin');
                   Stream.Writeln('   End;');
                   Stream.Writeln('End;');
                   SubMenu.SetEventProperty('OnClick',Id+'OnClick',Stream);
                   Stream.Destroy;
               End;
               cmSaveAs:
               Begin
                   Stream.Create;
                   Stream.Writeln('Begin');
                   Stream.Writeln('   If SaveDialog1.Execute Then');
                   Stream.Writeln('   Begin');
                   Stream.Writeln('   End;');
                   Stream.Writeln('End;');
                   SubMenu.SetEventProperty('OnClick',Id+'OnClick',Stream);
                   Stream.Destroy;
               End;
               Else SubMenu.SetEventProperty('OnClick',Id+'OnClick',Nil);
             End;
         End;
    End;

Begin
     AppExpertDlg0.Create(Nil);
     AppExpertDlg0.VisualPrj.Checked:=TRUE;
     AppExpertDlg0.AppTypeProgram.Checked:=TRUE;
     AppExpertDlg0.AppTypeProgram.Enabled:=FALSE;
     AppExpertDlg0.AppTypeDLL.Enabled:=FALSE;

     AppExpertDlg1.Create(Nil);
     AppExpertDlg2.Create(Nil);
     WITH AppExpertDlg2.AssocGrid Do
     Begin
          Cells[0,0]:='Filter';
          Cells[1,0]:='Description';
          Cells[0,1]:='*.*';
          Cells[1,1]:='All files';
     End;

     AppExpertDlg3.Create(Nil);
     AppExpertDlg4.Create(Nil);
     GetDir(0,s);
     AppExpertDlg4.PrjNameEdit.Text:='PrjName';
     AppExpertDlg4.PrjDirEdit.Text:=s;
     Run:=FALSE;
     ModalResult1:=cmNull;
     ModalResult2:=cmNull;
     ToolBarButtons:=Nil;

     Repeat
          AppExpertDlg0.xAlign:=xaCenter;
          AppExpertDlg0.yAlign:=yaCenter;
          AppExpertDlg0.ShowModal;
          ModalResult0:=AppExpertDlg0.ModalResult;
          VisualPrj:=AppExpertDlg0.VisualPrj.Checked;
          AppTypeDll:=AppExpertDlg0.AppTypeDLL.Checked;

          If ModalResult0=cmForward Then
          Repeat
               If not VisualPrj Then
               Begin
                    ModalResult1:=cmForward;
                    MenuOptions:=0;
               End
               Else
               Begin
                    AppExpertDlg1.xAlign:=xaCenter;
                    AppExpertDlg1.yAlign:=yaCenter;
                    AppExpertDlg1.ShowModal;
                    ModalResult1:=AppExpertDlg1.ModalResult;
                    MenuOptions:=GetPackedCheckBoxList([AppExpertDlg1.FileCheck,AppExpertDlg1.EditCheck,
                                                        AppExpertDlg1.WindowCheck,AppExpertDlg1.HelpCheck]);
               End;

               If ModalResult1=cmBack Then
               Begin
                    ModalResult1:=cmOk;
                    ModalResult0:=cmNull;
               End
               Else If ModalResult1=cmForward Then
               Repeat
                     If MenuOptions And FileCheck=0 Then ModalResult2:=cmForward
                     Else
                     Begin
                          AppExpertDlg2.xAlign:=xaCenter;
                          AppExpertDlg2.yAlign:=yaCenter;
                          AppExpertDlg2.ShowModal;
                          ModalResult2:=AppExpertDlg2.ModalResult;
                     End;
                     If ModalResult2=cmBack Then
                     Begin
                          ModalResult2:=cmOk;
                          ModalResult1:=cmNull;
                     End
                     Else If ModalResult2=cmForward Then
                     Begin
                          Repeat
                                If MenuOptions=0 Then ModalResult3:=cmForward
                                Else
                                Begin
                                     SetupMenuList;
                                     AppExpertDlg3.xAlign:=xaCenter;
                                     AppExpertDlg3.yAlign:=yaCenter;
                                     AppExpertDlg3.ShowModal;
                                     ModalResult3:=AppExpertDlg3.ModalResult;
                                End;
                                If ModalResult3=cmBack Then
                                Begin
                                     ModalResult3:=cmOk;
                                     ModalResult2:=cmOk;
                                     ModalResult1:=cmOk;
                                     ModalResult0:=cmOk;
                                     If not VisualPrj Then ModalResult0:=cmNull
                                     Else
                                     Begin
                                          If MenuOptions And FileCheck=0 Then ModalResult1:=cmNull
                                          Else ModalResult2:=cmNull;
                                     End;
                                End
                                Else If ModalResult3=cmForward Then
                                Begin
                                     Repeat
                                           AppExpertDlg4.xAlign:=xaCenter;
                                           AppExpertDlg4.yAlign:=yaCenter;
                                           AppExpertDlg4.ShowModal;
                                           ModalResult4:=AppExpertDlg4.ModalResult;
                                           PrjOptions:=GetPackedCheckBoxList([AppExpertDlg4.HintsCheck,AppExpertDlg4.StatusBarCheck]);
                                           If ModalResult4=cmBack Then
                                           Begin
                                                ModalResult4:=cmOk;
                                                ModalResult3:=cmOk;
                                                ModalResult2:=cmOk;
                                                ModalResult1:=cmOk;
                                                ModalResult0:=cmOk;
                                                If MenuOptions=0 Then
                                                Begin
                                                     If MenuOptions And FileCheck=0 Then ModalResult1:=cmNull
                                                     Else ModalResult2:=cmNull;
                                                End
                                                Else ModalResult3:=cmNull;
                                           End
                                           Else
                                           Begin
                                                ModalResult3:=cmOk;
                                                ModalResult2:=cmOk;
                                                ModalResult1:=cmOk;
                                                ModalResult0:=cmOk;
                                                If ModalResult4=cmOk Then
                                                Begin
                                                     Run:=TRUE;
                                                     GetResults;
                                                     If PrjName='' Then
                                                     Begin
                                                          ModalResult4:=cmNull;
                                                          Run:=FALSE;
                                                     End;
                                                End
                                                Else ModalResult4:=cmOk;
                                           End;
                                     Until ModalResult4=cmOk;
                                End
                                Else  //canceled
                                Begin
                                     ModalResult3:=cmOk;
                                     ModalResult2:=cmOk;
                                     ModalResult1:=cmOk;
                                     ModalResult0:=cmOk;
                                End;
                          Until ModalResult3=cmOk;
                     End
                     Else  //canceled
                     Begin
                          ModalResult2:=cmOk;
                          ModalResult1:=cmOk;
                          ModalResult0:=cmOk;
                     End;
               Until ModalResult2=cmOk
               Else
               Begin
                    ModalResult1:=cmOk; //canceled
                    ModalResult0:=cmOk;
               End;
          Until ModalResult1=cmOk
          Else ModalResult0:=cmOk; //canceled
     Until ModalResult0=cmOk;

     If Run Then
     Begin
          If not ToolServices.OpenProject(PrjName) Then
          Begin
               ErrorBox('Project cannot be created.');
               Run:=FALSE;
          End;
     End;

     Filter:='';
     DefaultExt:='';
     For t:=1 To AppExpertDlg2.AssocGrid.RowCount-1 Do
     Begin
         If AppExpertDlg2.AssocGrid.Cells[0,t]<>'' Then
         Begin
             If Filter<>'' Then Filter:=Filter+'|';
             Filter:=Filter+AppExpertDlg2.AssocGrid.Cells[1,t]+'|'+AppExpertDlg2.AssocGrid.Cells[0,t];
             If DefaultExt='' Then DefaultExt:=AppExpertDlg2.AssocGrid.Cells[0,t];
         End;
     End;

     AppExpertDlg0.Destroy;
     AppExpertDlg1.Destroy;
     AppExpertDlg2.Destroy;
     AppExpertDlg3.Destroy;
     AppExpertDlg4.Destroy;

     If not Run Then
     Begin
          If ToolBarButtons<>Nil Then ToolBarButtons.Destroy;
          exit; //canceled
     End;        
            
     If VisualPrj Then
     Begin
          If not ToolServices.GetNewModuleName(UnitIdent,ModuleName) Then
          Begin
               ErrorBox('Could not create new module !');
               If ToolBarButtons<>Nil Then ToolBarButtons.Destroy;

               exit;
          End;
          If not ToolServices.CreateModule(ModuleName,Nil,Nil,[cmfNewForm,cmfMainForm,
                                           cmfAddToProject,cmfNewUnit,cmfMarkModified,
                                           cmfUnNamed]) Then
          Begin
               ErrorBox('Could not create new module !');
               If ToolBarButtons<>Nil Then ToolBarButtons.Destroy;
               exit;
          End;

          MI:=ToolServices.GetModuleInterface(ModuleName);
          If MI=Nil Then
          Begin
               ErrorBox('Fatal AppExpert error');
               If ToolBarButtons<>Nil Then ToolBarButtons.Destroy;
               exit;
          End;

          FI:=MI.GetFormInterface;
          If FI=Nil Then
          Begin
               ErrorBox('Fatal AppExpert error');
               If ToolBarButtons<>Nil Then ToolBarButtons.Destroy;
               exit;
          End;

          Form:=FI.GetFormComponent;
          TheForm:=TForm(Form.GetComponentHandle);
          TheForm.ShowHint:=(PrjOptions And ShowHints)<>0;
          TheForm.Align:=alCenter;

          If MenuOptions<>0 Then
          Begin
               MainMenu:=FI.CreateComponent(Form,'TMainMenu','',0,0,0,0);
               If MenuOptions And FileCheck<>0 Then
               Begin
                    Menu:=FI.CreateComponent(MainMenu,'TMenuItem','',0,0,0,0);
                    Component:=Menu.GetComponentHandle;
                    TMenuItem(Component).Caption:='~File';

                    NewMenuItem('~New','New',cmNew);
                    NewMenuItem('~Open\tF3','Open',cmOpen);
                    NewMenuItem('~Save\tF2','Save',cmSave);
                    NewMenuItem('Save ~as','SaveAs',cmSaveAs);
                    NewMenuItem('-','',cmNull);
                    NewMenuItem('~Exit','',cmExit);

                    //Add Menu edit String
                    NewMenuItem(MenuIDEEditStr,'',cmNull);
               End;

               If MenuOptions And EditCheck<>0 Then
               Begin
                    Menu:=FI.CreateComponent(MainMenu,'TMenuItem','',0,0,0,0);
                    Component:=Menu.GetComponentHandle;
                    TMenuItem(Component).Caption:='~Edit';

                    NewMenuItem('~Undo\tAlt+BkSpace','Undo',cmUndo);
                    NewMenuItem('~Redo\tShift+Alt+BkSpace','Redo',cmRedo);
                    NewMenuItem('-','',cmNull);
                    NewMenuItem('Cu~t\tShift+Del','Cut',cmCut);
                    NewMenuItem('~Copy\tCtrl+Ins','Copy',cmCopy);
                    NewMenuItem('~Paste\tShift+Ins','Paste',cmPaste);

                    //Add Menu edit String
                    NewMenuItem(MenuIDEEditStr,'',cmNull);
               End;

               If MenuOptions And WindowCheck<>0 Then
               Begin
                    Menu:=FI.CreateComponent(MainMenu,'TMenuItem','',0,0,0,0);
                    Component:=Menu.GetComponentHandle;
                    TMenuItem(Component).Caption:='~Window';

                    NewMenuItem('~Tile','Tile',cmTile);
                    NewMenuItem('C~ascade','Cascade',cmCascade);
                    NewMenuItem('Cl~ose all','CloseAll',cmCloseAll);
                    NewMenuItem('-','',cmNull);
                    NewMenuItem('~Maximize','Maximize',cmMaximize);
                    NewMenuItem('~Next\tF6','Next',cmNext);
                    NewMenuItem('~Previous\tShift+F6','Previous',cmPrevious);
                    NewMenuItem('~Close\tAlt+F3','Close',cmCloseTop);

                    //Add Menu edit String
                    NewMenuItem(MenuIDEEditStr,'',cmNull);
               End;

               If MenuOptions And HelpCheck<>0 Then
               Begin
                    Menu:=FI.CreateComponent(MainMenu,'TMenuItem','',0,0,0,0);
                    Component:=Menu.GetComponentHandle;
                    TMenuItem(Component).Caption:='~Help';

                    NewMenuItem('~Contents\tF1','',cmHelp);
                    NewMenuItem('~Index\tShift+F1','',cmHelpIndex);
                    NewMenuItem('~Help on help','',cmHelpOnHelp);
                    NewMenuItem('~Keys help','',cmKeysHelp);

                    //Add Menu edit String
                    NewMenuItem(MenuIDEEditStr,'',cmNull);
               End;

               //Add Menu edit String
               Menu:=FI.CreateComponent(MainMenu,'TMenuItem','',0,0,0,0);
               Component:=Menu.GetComponentHandle;
               TMenuItem(Component).Caption:=MenuIDEEditStr;
          End;

          If ToolBarButtons.Count>0 Then
          Begin
               ToolBar:=FI.CreateComponent(Form,'TToolBar','',0,0,0,40);
               Component:=ToolBar.GetComponentHandle;
               //TToolBar(Component).Alignment:=tbTop;
               X:=8;
               For t:=0 To ToolBarButtons.Count-1 Do
               Begin
                    Command:=TCommand(ToolBarButtons[t]);
                    If Command=cmNull Then inc(X,5) //Space
                    Else
                    Begin
                         Case Command Of
                           cmNew:s:='New';
                           cmOpen:s:='Open';
                           cmSave:s:='Save';
                           cmSaveAs:s:='SaveAs';
                           cmExit:s:='Exit';
                           cmUndo:s:='Undo';
                           cmRedo:s:='Redo';
                           cmCut:s:='Cut';
                           cmCopy:s:='Copy';
                           cmPaste:s:='Paste';
                           cmTile:s:='Tile';
                           cmCascade:s:='Cascade';
                           cmCloseAll:s:='CloseAll';
                           cmMaximize:s:='Maximize';
                           cmNext:s:='Next';
                           cmPrevious:s:='Previous';
                           cmCloseTop:s:='Close';
                           cmHelp:s:='Help';
                           cmHelpIndex:s:='HelpIndex';
                           cmHelpOnHelp:s:='HelpOnHelp';
                           cmKeysHelp:s:='KeysHelp';
                           Else s:='';
                         End; //case
                         Button:=FI.CreateComponent(Form,'TSpeedButton',s+'Button',X,8,24,24);
                         Component:=Button.GetComponentHandle;
                         Bitmap:=BitmapFromCommand(Command);
                         TSpeedButton(Component).Parent:=TControl(ToolBar.GetComponentHandle);
                         TSpeedButton(Component).Glyph:=Bitmap;
                         TSpeedButton(Component).Caption:='';
                         TSpeedButton(Component).Command:=Command;

                         If Command In [cmNew,cmOpen,cmSave,cmSaveAs,cmUndo,cmRedo,
                                        cmCut,cmCopy,cmPaste] Then
                           Button.SetEventProperty('OnClick',s+'OnClick',Nil);
                         inc(X,25);
                         Button.Destroy;
                    End;
               End;
          End;

          If MenuOptions And FileCheck<>0 Then
          Begin
               OpenDialog:=FI.CreateComponent(Form,'TOpenDialog','',40,0,0,0);
               Component:=OpenDialog.GetComponentHandle;
               TOpenDialog(Component).Filter:=Filter;
               TOpenDialog(Component).DefaultExt:=DefaultExt;

               SaveAsDialog:=FI.CreateComponent(Form,'TSaveDialog','',80,0,0,0);
               Component:=SaveAsDialog.GetComponentHandle;
               TSaveDialog(Component).Filter:=Filter;
               TSaveDialog(Component).DefaultExt:=DefaultExt;
          End;

          //Display both the generated form And the Source for it
          If PrjOptions And EnableStatusBar<>0 Then
          Begin
             ToolBar:=FI.CreateComponent(Form,'TToolBar','',0,0,0,20);
             Component:=ToolBar.GetComponentHandle;
             TToolBar(Component).Alignment:=tbBottom;
          End;

          MI.ShowForm;
     End
     Else  //Nonvisual project
     Begin
          MI:=Nil;
          FI:=Nil;
          Form:=Nil;
     End;

     If MI<>Nil Then MI.ShowSource;

     //Destroy all interfaces !
     If ToolBarButtons<>Nil Then ToolBarButtons.Destroy;
     If Form<>Nil Then Form.Destroy;
     If MI<>Nil Then MI.Destroy;
     If FI<>Nil Then FI.Destroy;
End;

Procedure TAppExpert.Register;
Begin
     RegisterBitmaps;
End;

Procedure TAppExpert.Unload;
Begin
     UnregisterBitmaps;
End;


EXPORTS
      TAppExpert;

{*************************************************************************************
 *                                                                                   *
 *                                                                                   *
 * Unit initialization                                                               *
 *                                                                                   *
 *                                                                                   *
 *************************************************************************************}


Initialization
  RegisterClasses ([TAppExpertDlg1, TImage, TGroupBox, TBitBtn,
                    TLabel, TCheckBox,TAppExpertDlg2,
                    TAppExpertDlg3, TPanel, TBevel,
                    TAppExpertDlg4, TAppExpertDlg0,
                    TRadioButton, TEdit, TListBox, TStringGrid, TChangeDirDialog]);
  //Register the expert
  RegisterLibraryExperts([TAppExpert]);
End.

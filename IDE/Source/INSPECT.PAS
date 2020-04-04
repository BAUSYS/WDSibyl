
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     WDSibyl Visual Development Environment                               บ
 บ                                                                          บ
 บ     Copyright (C) 1995,99 SpeedSoft Germany,   All rights reserved.      บ
 บ     Copyright (C) 2005..  Ing. Wolfgang Draxler, All rights reserved.    บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ Sibyl Integrated Development Environment (IDE)                           บ
 บ Object-oriented development system.                                      บ
 บ                                                                          บ
 บ Copyright (C) 1995,99 SpeedSoft GbR, Germany                             บ
 บ                                                                          บ
 บ This program is free software; you can redistribute it and/or modify it  บ
 บ under the terms of the GNU General Public License (GPL) as published by  บ
 บ the Free Software Foundation; either version 2 of the License, or (at    บ
 บ your option) any later version. This program is distributed in the hope  บ
 บ that it will be useful, but WITHOUT ANY WARRANTY; without even the       บ
 บ implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR          บ
 บ PURPOSE.                                                                 บ
 บ See the GNU General Public License for more details. You should have     บ
 บ received a copy of the GNU General Public License along with this        บ
 บ program; if not, write to the Free Software Foundation, Inc., 59 Temple  บ
 บ Place - Suite 330, Boston, MA 02111-1307, USA.                           บ
 บ                                                                          บ
 บ In summary the original copyright holders (SpeedSoft) grant you the      บ
 บ right to:                                                                บ
 บ                                                                          บ
 บ - Freely modify and publish the sources provided that your modification  บ
 บ   is entirely free and you also make the modified source code available  บ
 บ   to all for free (except a fee for disk/CD production etc).             บ
 บ                                                                          บ
 บ - Adapt the sources to other platforms and make the result available     บ
 บ   for free.                                                              บ
 บ                                                                          บ
 บ Under this licence you are not allowed to:                               บ
 บ                                                                          บ
 บ - Create a commercial product on whatever platform that is based on the  บ
 บ   whole or parts of the sources covered by the license agreement. The    บ
 บ   entire program or development environment must also be published       บ
 บ   under the GNU General Public License as entirely free.                 บ
 บ                                                                          บ
 บ - Remove any of the copyright comments in the source files.              บ
 บ                                                                          บ
 บ - Disclosure any content of the source files or use parts of the source  บ
 บ   files to create commercial products. You always must make available    บ
 บ   all source files whether modified or not.                              บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

UNIT Inspect;

INTERFACE

USES SysUtils,Color,Classes,Forms,Graphics,Buttons,StdCtrls,ExtCtrls,Dialogs,TabCtrls,
     Consts,Projects,Sib_Prj,Sib_Ctrl,Form_Gen,PropEdit,BaseForm,Sib_Edit,
     WinList,Grids,OutLine,ListView,ComCtrls,FileCtrl,
     DDEMan,
     Menus, Messages,
     uSysInfo,
     uStream, uString, uList;

TYPE
    PComponentInterior=^TComponentInterior;

    PCompValuesPossible=^TCompValuesPossible;
    TCompValuesPossible=RECORD
         Name:PSTRING;
         Value:POINTER;
         ValueLen:LONGINT;
         RecordInterior:PComponentInterior;  //for records
    END;

    TComponentInterior=RECORD
         CompName:PSTRING;
         TypName:PSTRING;
         TypClass:TClass;
         CompData:PSTRING;
         CompTyp:BYTE;
         CompValue:POINTER;
         CompValueLen:LONGWORD;
         CompValueAdr:LONGWORD;     {nur fr records}
         IsRecordComponent:BOOLEAN;
         CompValuesPossible:TList;  {of PCompValuesPossible}
         ClassExtent:TList;  {of PComponentInterior}
         CanEdit:BOOLEAN;
         ParentInterior:PComponentInterior;
         Params:PSTRING;
         result:PSTRING;
         CanExtent:BOOLEAN;
         IsLink:BOOLEAN;
         Extended:LONGINT;
         Changed:BOOLEAN;
         ReadTyp:BYTE;
         ReadOffset:LONGWORD;
         WriteTyp:BYTE;
         WriteOffset:LONGWORD;
         Scope:BYTE; {8 published 16-stored}
    END;


    TComponentPage=CLASS(TComponent)
      PUBLIC
         Interior:TList;
         UpScrolled:LONGINT;
         PropertyNameSize:LONGINT;
         PropertyNameCX:LONGINT;  {Entfernung der Sizebar}
         SizeMode:BYTE;
         SizeCX:LONGINT;
         OffsetCX:LONGINT;
      PUBLIC
         PROCEDURE GetLargestString(Canvas:TCanvas;VAR CX,CY:LONGINT);
    END;


    TComponentNoteBook=CLASS(TControl)
      PUBLIC
         FieldCount:LONGINT;
         UpScrolled:LONGINT;
         ScrollBar:TScrollBar;
         LastMaxScroll:LONGINT;
         LastFieldCount:LONGINT;
         Selected:LONGINT;
         FEdit:TEdit;
         FComboBox:TInspectorComboBox;
         Picture:TImage;
         ActivePage:TComponentPage;
      PROTECTED
         PROCEDURE EvFontChange(Sender:TObject);
         PROCEDURE Resize;OVERRIDE;
         PROCEDURE Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);OVERRIDE;
         PROCEDURE ScrollLineUp(ScrollBar:TScrollBar);
         PROCEDURE ScrollPageUp(ScrollBar:TScrollBar);
         PROCEDURE ScrollPageDown(ScrollBar:TScrollBar);
         PROCEDURE ScrollLineDown(ScrollBar:TScrollBar);
         PROCEDURE ScrollVertTrack(ScrollBar:TScrollBar;NewPosition:LONGINT);
         PROCEDURE MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseMove(ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);OVERRIDE;
         PROCEDURE DoDblClk(Index:LONGINT);
         PROCEDURE SetupShow;Override;
         PROCEDURE CreateWnd;Override;
      PUBLIC
         FUNCTION InspectorFontHeight:LongInt;
         PROCEDURE Redraw(CONST rc:TRect);OVERRIDE;
         PROCEDURE SetSliderValues;
         PROCEDURE RedrawProperties(UpdateAll:BOOLEAN;rcu:TRect);
         PROCEDURE RedrawNames(UpdateAll:BOOLEAN;rcu:TRect);
         PROCEDURE EntryScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
         PROCEDURE EntryChanged(Sender:TObject);
         PROCEDURE EvComboDropDown(Sender:TObject);
         PROCEDURE EntryDblClkEvent(Sender:TObject);
         PROCEDURE WriteBackProperty(CONST Value:STRING);

         PROCEDURE EnableExtent(Data:PComponentInterior;Index:LONGINT);
         PROCEDURE DisableExtent(Data:PComponentInterior;Index:LONGINT);
         PROCEDURE SelectNext(Data:PComponentInterior;Index:LONGINT);
         PROCEDURE DisableSelect(DeleteEntry:BOOLEAN);
         PROCEDURE EnableSelect(NewSelected:LONGINT);
         PROCEDURE SetProperty(Data:PComponentInterior;Value:STRING;recu:TRect;ForceSet:BOOLEAN);
         PROCEDURE GenWriteComponent(iObject:TComponent;Value:POINTER;Data:PComponentInterior);
         PROCEDURE SelectListItemCombo(Sender:TObject;Index:LONGINT);
    END;


    TInspectorForm=CLASS(TSibylForm)
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         DESTRUCTOR Destroy;OVERRIDE;
    END;


    TInspector=CLASS(TControl)
      PUBLIC
         ComboBox:TComboBox;
         NoteBook:TComponentNoteBook;
         TabSet:TTabSet;
         Events:TComponentPage;
         Properties:TComponentPage;
         AClassName:PString;
         InspectedObject:TComponent;
         InspectedObjectsList:TList;
         InspectedForm:TForm;
         FocusFromFormular:BOOLEAN;
         FInspectorUpdateLocked:BOOLEAN;
      PRIVATE
         PROCEDURE EvPageChanged(Sender:TObject);
         PROCEDURE EvFontChange(Sender:TObject);
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE Resize;OVERRIDE;
         PROCEDURE Redraw(CONST rc:TRect);OVERRIDE;
      PUBLIC
         DESTRUCTOR Destroy;OVERRIDE;
         PROCEDURE AddInspectorItem(Instance:TComponent);
         PROCEDURE RemoveInspectorItem(Instance:TComponent);
         PROCEDURE RenameInspectorItem(Instance:TComponent;NewName:STRING);
         PROCEDURE EvSelectInspectorItem(Sender:TObject;Index:LONGINT);
         PROCEDURE SetInspectorData(Instance:TComponent);
         PROCEDURE SetupSetInspectorData(Instance:TComponent;MultipleEntries:BOOLEAN);
         PROCEDURE SetInspectorDataList(InstanceList:TList);
         PROCEDURE UpdateInspectorDataList(InstanceList:TList);
         PROCEDURE UpdateInspectorData(Instance:TComponent);
         PROCEDURE UpdateInspectorDataRec(Instance:TComponent;recu:TRect);
         PROCEDURE DeleteNonPublishedProperties(List:TList);
         PROCEDURE EnumAllProperties(Instance:TComponent;Update,ReadValues:BOOLEAN);
         PROCEDURE GetClassValues(Data:PComponentInterior);
         FUNCTION  GetPropString(Data:PComponentInterior;Update:BOOLEAN;Instance:TComponent):STRING;
         PROCEDURE SetInspectorFocus(Component:TComponent);
         PROCEDURE WriteBackProperties;
         PROPERTY Form;
    END;


PROCEDURE InitInspector;

FUNCTION InsertMethodValid(OwnerObject,ObjectToInsert:TControl;
                           PropertyName,MethodName,MethodParams:STRING):BOOLEAN;

PROCEDURE InsertDefaultEvent(Sender:TComponent);

VAR Inspector:TInspector;
    NotifySM:PROCEDURE(x,y,w,h:LONGINT;Component:TComponent);
    SelectCtrl:PROCEDURE(Component:TComponent);
    GetReferenceProc:FUNCTION(Sender:TComponent):TComponent;


IMPLEMENTATION

Uses MMedia, uMediaPlayer, uMMDevices;

CONST MoreString:STRING='More...';


PROCEDURE InitInspector;
VAR  InspectorForm:TInspectorForm;
BEGIN
     IF Inspector <> NIL THEN
     BEGIN
          IF Inspector.Form.WindowState = wsMinimized
          THEN Inspector.Form.WindowState := wsNormal;
          Inspector.Form.BringToFront;
          exit;
     END;

     MoreString := LoadNLSStr(SiMore);

     InspectorForm.Create(NIL);
     InspectorForm.HelpContext := hctxDialogInspectorForm;
     InspectorForm.Show;
     IF LastDesignForm <> NIL THEN Inspector.SetInspectorData(LastDesignForm);
     InspectorForm.Update;
END;


PROCEDURE TInspectorForm.SetupComponent;
BEGIN
     Inherited SetupComponent;

     DBCSStatusLine := TRUE;
     Caption := LoadNLSStr(SiObjectInspector);
     Color := clDlgWindow;
     Icon := InspectorIcon;
     BorderStyle := bsSizeable;
     BorderIcons := [biSystemMenu];
     SibylFormId := dwi_Inspector;
     OnTranslateShortCut := Application.MainForm.OnTranslateShortCut;

     Inspector.Create(SELF);
     InsertControl(Inspector);
END;


DESTRUCTOR TInspectorForm.Destroy;
BEGIN
     Inspector.SetInspectorData(NIL);    {release some memory}
     Inspector := NIL;
     Inherited Destroy;
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TInspector Class implementation                             บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

FUNCTION InspectorFont:TFont;
VAR  FontName:STRING;
     PointSize:LONGINT;
BEGIN
     IF IdeSettings.Fonts.InspectorFont <> '' THEN
       IF SplitFontName(IdeSettings.Fonts.InspectorFont,FontName,PointSize) THEN
       BEGIN
            Result := Screen.GetFontFromPointSize(FontName,PointSize);
            IF Result <> NIL THEN exit;
       END;

     Result := Screen.SmallFont;
END;


PROCEDURE TInspector.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Align := alClient;
     Color := clDlgWindow;
     Include(ComponentState, csAcceptsControls); {clip combobox}

     ComboBox.Create(SELF);
     ComboBox.Style := csDropDownList;
     ComboBox.Sorted := TRUE;
     ComboBox.OnItemSelect := Inspector.EvSelectInspectorItem;
     InsertControl(ComboBox);

     NoteBook.Create(SELF);
     Include(NoteBook.ComponentState, csAcceptsControls); {clip scrollbar}
     Include(NoteBook.ComponentState, csDetail); {Font Drop durchreichen}
     NoteBook.Color := clDlgWindow;
     NoteBook.OnFontChange := NoteBook.EvFontChange;

     Properties.Create(SELF);
     Properties.PropertyNameSize := IdeSettings.Inspect.PropertyNameSize;

     Events.Create(SELF);
     Events.PropertyNameSize := IdeSettings.Inspect.EventNameSize;

     NoteBook.ActivePage := Properties;
     NoteBook.ScrollBar.Create(NoteBook);
     NoteBook.ScrollBar.Kind := sbVertical;
     NoteBook.InsertControl(NoteBook.ScrollBar);
     InsertControl(NoteBook);

     TabSet.Create(SELF);
     TabSet.Align := alBottom;
     TabSet.Tabs.Add(LoadNLSStr(SiIProperties));
     TabSet.Tabs.Add(LoadNLSStr(SiIEvents));
     TabSet.TabIndex := 0;
     TabSet.OnClick := EvPageChanged;
     InsertControl(TabSet);

     Font := InspectorFont;
     OnFontChange := EvFontChange;
END;


PROCEDURE TInspector.SetupShow;
BEGIN
     Inherited SetupShow;
     Resize;
END;


PROCEDURE TInspector.EvFontChange(Sender:TObject);
VAR  s:STRING;
BEGIN
     IF not Visible THEN exit;  {wegen Canvas init}
     Invalidate;
     s := tostr(Font.PointSize) + '.' + Font.FaceName;
     IdeSettings.Fonts.InspectorFont := s;
     IdeSettings.Modified := TRUE;
     Resize;
END;


PROCEDURE TInspector.Resize;
BEGIN
     Inherited Resize;

     ComboBox.SetBounds(5,
                        5,
                        ClientWidth-10,
                        25);
     NoteBook.SetWindowPos(7,
                           30,
                           ClientWidth-14,
                           ClientHeight-(Combobox.Height+Combobox.Top+5)-30);
END;


PROCEDURE TInspector.Redraw(CONST rc:TRect);
VAR  rc1:TRect;
BEGIN
     Inherited Redraw(rc);
     rc1 := Notebook.WindowRect;
     InflateRect(rc1, 2, 2);
     DrawSystemBorder(SELF,rc1,bsSingle);
END;


PROCEDURE TInspector.EvPageChanged(Sender:TObject);
VAR  NewPage:TComponentPage;
BEGIN
     IF TabSet.TabIndex = 0 THEN NewPage := Properties
     ELSE NewPage := Events;

     IF NewPage = NoteBook.ActivePage THEN exit;  {nothing to do}

     NoteBook.ActivePage.UpScrolled := NoteBook.UpScrolled;    {store old}
     NoteBook.DisableSelect(TRUE);

     NoteBook.ActivePage := NewPage;
     NoteBook.UpScrolled := NewPage.UpScrolled;
     NoteBook.SetSliderValues;
     Notebook.Invalidate;
END;


PROCEDURE DisposeEntry(Data:PComponentInterior);
VAR t:LONGINT;
    dummy:PCompValuesPossible;
    Data1:PComponentInterior;
BEGIN
     WITH Data^ DO
     BEGIN
          DisposeStr(CompName);
          DisposeStr(CompData);
          IF CompValueLen>0 THEN
            IF not IsRecordComponent THEN FreeMem(CompValue,CompValueLen);
          DisposeStr(Params);
          IF CompValuesPossible<>NIL THEN
          BEGIN
              FOR t:=0 TO CompValuesPossible.Count-1 DO
              BEGIN
                   dummy:=CompValuesPossible.Items[t];

                   IF dummy^.RecordInterior<>NIL
                   THEN DisposeEntry(dummy^.RecordInterior);

                   //do not delete -> located in code segment or static
                   CASE Data^.CompTyp OF
                     PropType_Boolean:
                     BEGIN
                          DisposeStr(dummy^.Name);
                          IF dummy^.ValueLen > 0
                          THEN FreeMem(dummy^.Value,dummy^.ValueLen);
                     END;
                     PropType_Enum:
                     BEGIN
                          IF dummy^.ValueLen > 0
                          THEN FreeMem(dummy^.Value,dummy^.ValueLen);
                     END;
                     PropType_Class:
                     BEGIN
                          DisposeStr(dummy^.Name);
                          IF dummy^.ValueLen > 0
                          THEN FreeMem(dummy^.Value,dummy^.ValueLen);
                     END;
                   END; {case}

                   dispose(dummy);
              END;
              CompValuesPossible.Destroy;
              CompValuesPossible:=Nil;
         END;

         IF ClassExtent<>NIL THEN
         BEGIN
              FOR t:=0 TO ClassExtent.Count-1 DO
              BEGIN
                   Data1:=ClassExtent[t];
                   DisposeEntry(Data1);
              END;
              ClassExtent.Destroy;
              ClassExtent:=Nil;
         END;
     END;
     Dispose(Data);
END;


PROCEDURE TInspector.DeleteNonPublishedProperties(List:TList);
VAR ll:LONGINT;
    Data:PComponentInterior;
LABEL l4,l5;
BEGIN
     //delete properties not published
l4:
     FOR ll:=0 TO List.Count-1 DO
     BEGIN
          Data:=List.Items[ll];
          IF Data^.Scope AND 8<>8 THEN {not published}
          BEGIN
               List.Remove(Data);
               DisposeEntry(Data);
               goto l4;
          END;
     END;
l5:
     FOR ll:=0 TO Events.Interior.Count-1 DO
     BEGIN
          Data:=Events.Interior.Items[ll];
          IF Data^.Scope AND 8<>8 THEN {not published}
          BEGIN
               Events.Interior.Remove(Data);
               DisposeEntry(Data);
               goto l5;
          END;
     END;
END;


PROCEDURE TInspector.UpdateInspectorDataList(InstanceList:TList);
VAR Instance:TComponent;
    t,t1:LONGINT;
LABEL setit,found;
BEGIN
//  Application.LogWriteln('UpdateInspectorDataList');
     IF InstanceList.Count<2 THEN
     BEGIN
          IF InstanceList.Count=0 THEN UpdateInspectorData(NIL)
          ELSE UpdateInspectorData(TComponent(InstanceList[0]));
          exit;
     END;

     IF FInspectorUpdateLocked THEN exit;

     IF ((InspectedObjectsList=NIL)OR(InstanceList.Count<>InspectedObjectsList.Count)) THEN
     BEGIN
setit:
          SetInspectorDataList(InstanceList);
          exit;
     END;

     FOR t:=0 TO InspectedObjectsList.Count-1 DO
     BEGIN
          Instance:=InspectedObjectsList[t];
          FOR t1:=0 TO InstanceList.Count-1 DO
            IF Instance=InstanceList[t1] THEN goto found;
          goto setit; //not found -> list changed
found:
     END;

     Instance:=InspectedObjectsList[0];
     EnumAllProperties(Instance,TRUE,TRUE);
     NoteBook.RedrawProperties(FALSE,ClientRect);
END;

PROCEDURE TInspector.UpdateInspectorData(Instance:TComponent);
BEGIN
// Application.LogWriteln('UpdateInspectorData');
     IF FInspectorUpdateLocked THEN exit;

     IF Instance<>InspectedObject THEN
     BEGIN
          SetInspectorData(Instance);
          exit;
     END;

     IF Instance=NIL THEN exit;

     EnumAllProperties(Instance,TRUE,TRUE);
     NoteBook.RedrawProperties(FALSE,ClientRect);
END;


PROCEDURE TInspector.UpdateInspectorDataRec(Instance:TComponent;recu:TRect);
BEGIN
//  Application.LogWriteln('UpdateInspectorDataRec');
     IF FInspectorUpdateLocked THEN exit;

     IF Instance<>InspectedObject THEN
     BEGIN
          SetInspectorData(Instance);
          exit;
     END;

     IF Instance=NIL THEN exit;

     EnumAllProperties(Instance,TRUE,TRUE);
     NoteBook.RedrawProperties(FALSE,recu);
END;


PROCEDURE TInspector.AddInspectorItem(Instance:TComponent);
VAR  i:INTEGER;
BEGIN
     IF Instance = NIL THEN exit;
     IF Instance IS TMenuItem THEN exit;
     IF csDetail IN Instance.ComponentState THEN exit;
     IF csReferenceControl IN Instance.ComponentState THEN exit;

     IF not ((Instance IS TForm) AND
             (Instance.ComponentState * [csReference] <> [])) THEN
     BEGIN
          {Fge alle Elemente rekursiv ein}
          FOR i := 0 TO Instance.ComponentCount-1
             DO AddInspectorItem(Instance.Components[i]);
     END;

     ComboBox.Items.AddObject(Instance.Name,Instance);
(*
     ComboBox.Items.AddObject(Instance.Name+'('+Instance.ClassName+')',
                              Instance);
*)
END;


PROCEDURE TInspector.RemoveInspectorItem(Instance:TComponent);
VAR  i:INTEGER;
BEGIN
     IF Instance = NIL THEN exit;
     IF Instance IS TMenuItem THEN exit;
     IF csDetail IN Instance.ComponentState THEN exit;
     IF csReferenceControl IN Instance.ComponentState THEN exit;

     {Entferne alle Elemente rekursiv}
     FOR i := 0 TO Instance.ComponentCount-1 DO
     BEGIN
          RemoveInspectorItem(Instance.Components[i]);
     END;

     i := ComboBox.Items.IndexOfObject(Instance);
     IF i >= 0 THEN ComboBox.Items.Delete(i);
END;


PROCEDURE TInspector.RenameInspectorItem(Instance:TComponent;NewName:STRING);
VAR  i:LONGINT;
     s:STRING;
BEGIN
     IF Instance = NIL THEN exit;
     i := ComboBox.Items.IndexOfObject(Instance);
     IF i >= 0 THEN ComboBox.Items.Strings[i] := NewName
     ELSE ComboBox.Items.AddObject(NewName,Instance);

     IF Instance.TypeName <> '' THEN
     BEGIN
          Instance.TypeName := 'T'+ NewName;
          s := Instance.TypeName;
     END
     ELSE s := Instance.ClassName;
     ComboBox.Caption := NewName +':'+ s;
END;


{$HINTS OFF}
PROCEDURE TInspector.EvSelectInspectorItem(Sender:TObject;Index:LONGINT);
VAR
     Instance:TComponent;
BEGIN
     IF LastDesignForm = NIL THEN exit;
     Instance := TComponent(ComboBox.Items.Objects[Index]);
     IF Instance <> NIL THEN
     BEGIN
          SetInspectorData(Instance);
          SelectCtrl(Instance);
     END;
     LastDesignForm.BringToFront;
END;
{$HINTS ON}



DESTRUCTOR TInspector.Destroy;
BEGIN
     IF InspectedObjectsList<>NIL THEN InspectedObjectsList.Destroy;
     Inherited Destroy;
END;

PROCEDURE DestroyInterior(VAR Interior:TList);
VAR t:LONGINT;
    Data:PComponentInterior;
BEGIN
     IF Interior<>NIL THEN
     BEGIN
          FOR t:=0 TO Interior.Count-1 DO
          BEGIN
               Data:=Interior.Items[t];
               DisposeEntry(Data);
          END;
          Interior.Destroy;
          Interior:=NIL;
     END;
END;

PROCEDURE MergeLists(Dest,Source:TList);
VAR t,t1:LONGINT;
    Data,Data1:PComponentInterior;
    s,s1:STRING;
LABEL weiter;
BEGIN
     t:=0;
     WHILE t<=Dest.Count-1 DO
     BEGIN
          Data:=Dest[t];
          s:=Data^.CompName^;
          UpcaseStr(s);

          //skip name property, shared editing of name is restricted !
          IF s<>'NAME' THEN FOR t1:=0 TO Source.Count-1 DO
          BEGIN
               Data1:=Source[t1];

               IF ((Data^.CompTyp=Data1^.CompTyp)AND(Data^.CompValueLen=Data1^.CompValueLen)AND
                   (Data^.IsRecordComponent=Data1^.IsRecordComponent)AND
                   (Data^.ReadTyp=Data1^.ReadTyp)AND(Data^.ReadOffset=Data1^.ReadOffset)AND
                   (Data^.WriteTyp=Data1^.WriteTyp)AND(Data^.WriteOffset=Data1^.WriteOffset)) THEN
               BEGIN
                    s1:=Data1^.CompName^;
                    UpcaseStr(s1);
                    IF s=s1 THEN //keep this entry
                    BEGIN
                         inc(t);
                         goto weiter;
                    END;
               END;
          END;

          //delete this entry
          DisposeEntry(Data);
          Dest.Delete(t);
weiter:
     END;
END;

PROCEDURE TInspector.SetInspectorDataList(InstanceList:TList);
VAR t:LONGINT;
    Component:TComponent;
    RealProperties,RealEvents:TList;
    s:STRING;
    p,p1,pParent:^LONGINT;
BEGIN
//  Application.LogWriteln('SetInspectorDataList');
  IF InstanceList.Count<2 THEN
  BEGIN
       IF InstanceList.Count=0 THEN SetInspectorData(NIL)
       ELSE SetInspectorData(TComponent(InstanceList[0]));
       exit;
  END;

  IF FInspectorUpdateLocked THEN exit;

  WriteBackProperties;
  NoteBook.DisableSelect(TRUE);

  //NIL indicates an update with the same list as selected
  IF InstanceList<>NIL THEN
  BEGIN
      IF InspectedObjectsList=NIL THEN InspectedObjectsList.Create;
      InspectedObjectsList.Clear;

      FOR t:=0 TO InstanceList.Count-1 DO
        InspectedObjectsList.Add(InstanceList[t]);
  END;

  Component:=InspectedObjectsList[0];

  SetupSetInspectorData(Component,TRUE);
  Events.Interior.Create;
  Properties.Interior.Create;

  //determine common used properties and enter it into Events.Interior and Properties.Interior
  //AClassName will contain the name of the main selected item
  p:=POINTER(Component);
  p:=POINTER(p^);       //VMT Info
  inc(p,4);
  p:=POINTER(p^);       //ClassInfo
  p1:=p;
  inc(p,4);
  pParent:=POINTER(p^);  //Parent Class VMT or NIL
  inc(p,8);
  p:=POINTER(p^);       //Property Pointer

  inc(p1,16);   //onto ClassName
  System.Move(p1^,s,(p1^ AND 255)+1);  //Class Name
  AssignStr(AClassName,s);


  //Alle Properties in Properties.Interior und Events.Interior eintragen
  EnumAllProperties(Component,FALSE,TRUE);
  //Properties die nicht Published sind l”schen !
  DeleteNonPublishedProperties(Properties.Interior);

  RealProperties:=Properties.Interior;
  RealEvents:=Events.Interior;

  Events.Interior.Create;
  Properties.Interior.Create;

  FOR t:=1 TO InspectedObjectsList.Count-1 DO
  BEGIN
//     Application.LogWriteln('SetInspectorDataList:'+tostr(t));
       Component:=InspectedObjectsList[t];

       //Alle Properties in Properties.Interior und Events.Interior eintragen
       EnumAllProperties(Component,FALSE,FALSE);
       //Properties die nicht Published sind l”schen !
       DeleteNonPublishedProperties(Properties.Interior);

       //add those properties and events to RealProperties and
       //RealEvents that match the property name and type
       MergeLists(RealProperties,Properties.Interior);
       MergeLists(RealEvents,Events.Interior);

       DestroyInterior(Properties.Interior);
       DestroyInterior(Events.Interior);

       IF t<>InspectedObjectsList.Count-1 THEN
       BEGIN
            Events.Interior.Create;
            Properties.Interior.Create;
       END;
  END;

  //overwrite it, it contains NIL !
  Properties.Interior:=RealProperties;
  //overwrite it, it contains NIL !
  Events.Interior:=RealEvents;

  NoteBook.UpScrolled:=0;
  NoteBook.SetSliderValues;
  NoteBook.Invalidate;
//  Application.LogWriteln('SetInspectorDataList: Ende');
END;

PROCEDURE TInspector.SetupSetInspectorData(Instance:TComponent;MultipleEntries:BOOLEAN);
VAR Form:TForm;
    s:STRING;
BEGIN
     {Bestimme Form}
     Form := TForm(Instance);
     IF Form <> NIL THEN
     WHILE Form.Owner <> NIL DO Form := TForm(Form.Owner);

     IF Form <> InspectedForm THEN
     BEGIN
          ComboBox.Clear;
          AddInspectorItem(Form);
     END;
     InspectedForm := Form;

     IF ((Instance <> NIL)AND(not MultipleEntries)) THEN
     BEGIN
          s := Instance.TypeName;
          IF s = '' THEN s := Instance.ClassName;
          ComboBox.Caption := Instance.Name +':'+ s;
     END
     ELSE ComboBox.Caption := '';

     DestroyInterior(Events.Interior);
     DestroyInterior(Properties.Interior);

     DisposeStr(AClassName);
     AClassName:=NIL;

     InspectedObject:=Instance;
END;

PROCEDURE TInspector.SetInspectorData(Instance:TComponent);
VAR
   p,p1,pParent:^LONGINT;
   s:STRING;
BEGIN
//  Application.LogWriteln('SetInspectorData');
  IF FInspectorUpdateLocked THEN exit;

  WriteBackProperties;
  NoteBook.DisableSelect(TRUE);

  IF InspectedObjectsList<>NIL THEN
  BEGIN
       InspectedObjectsList.Destroy;
       InspectedObjectsList:=NIL;
  END;

  SetupSetInspectorData(Instance,FALSE);

  IF Instance=NIL THEN
  BEGIN
       Invalidate;
       exit;
  END;

  Events.Interior.Create;
  Properties.Interior.Create;

  p:=POINTER(Instance);
  p:=POINTER(p^);       //VMT Info
  inc(p,4);
  p:=POINTER(p^);       //ClassInfo
  p1:=p;
  inc(p,4);
  pParent:=POINTER(p^);  //Parent Class VMT or NIL
  inc(p,8);
  p:=POINTER(p^);       //Property Pointer

  inc(p1,16);           //onto ClassName
  System.Move(p1^,s,(p1^ AND 255)+1);  //Class Name
  AssignStr(AClassName,s);

//Alle Properties in Properties.Interior und Events.Interior eintragen
//  Application.LogWriteln('SetInspectorData: 1');
  EnumAllProperties(Instance,FALSE,TRUE);
//  Application.LogWriteln('SetInspectorData: 2');
//Properties die nicht Published sind l”schen !
  DeleteNonPublishedProperties(Properties.Interior);

  NoteBook.UpScrolled:=0;
  NoteBook.SetSliderValues;
  NoteBook.Invalidate;
//  Application.LogWriteln('SetInspectorData: Ende');
END;


VAR PropertyNameTable:POINTER;

PROCEDURE GetPropertyTyp(VAR p:POINTER;Data:PComponentInterior;Update:BOOLEAN);
VAR p1:^LONGINT;
    Typ:BYTE;
    b:LONGINT;
    U,O,t:LONGINT;
    s,s1:STRING;
    dummy:PCompValuesPossible;
    ps:^STRING;

   PROCEDURE AddToList(Len:LONGINT);
   VAR dummy1:PComponentInterior;
       ss:STRING;
       IsTColor:BOOLEAN;
       b:LONGINT;
   BEGIN
//        Application.LogWriteln('AddToList:' + toStr(Len));
        b:=p1^;  //extended info ??
        IsTColor:=FALSE;
        WHILE b<>0 DO
        BEGIN
             IF not Update THEN
             BEGIN
                  IF Data^.CompValuesPossible=NIL THEN
                    Data^.CompValuesPossible.Create;

                 new(dummy);
                 dummy^.name:=PropertyNameTable+p1^;
                 ss:=dummy^.name^;
                 UpcaseStr(ss);
                 IF ss='CLWHITE' THEN IsTColor:=TRUE;
             END;
             inc(p1,4);  //Name (Index)

             IF Len=-1 THEN  //Record
             BEGIN
                  Data^.CanExtent:=TRUE;
                  new(dummy1);
                  dummy1^.IsRecordComponent:=TRUE;
                  dummy1^.CompValueAdr:=p1^;  {Adresse der record komponente}
                  inc(p1,4);
                  dummy1^.CompValueLen:=p1^; {Lnge der Komponente}
                  inc(p1,4);
                  dummy1^.CompTyp:=p1^ AND 255;
                  GetPropertyTyp(p1,dummy1,Update);
                  IF not Update THEN dummy^.RecordInterior:=dummy1
                  ELSE DisposeEntry(dummy1);
                  IF not Update THEN Data^.CompValuesPossible.Add(dummy);
             END
             ELSE
             BEGIN
                  IF not Update THEN
                  BEGIN
                       dummy^.Value:=p1;
                       dummy^.ValueLen:=Len;
                       Data^.CompValuesPossible.Add(dummy);
                  END;

                  inc(p1,Len);
             END;
             b:=p1^;  //next name index
        END;
        inc(p1,4);
        IF IsTColor THEN
        BEGIN
             IF Data^.CompValuesPossible=NIL THEN
             Data^.CompValuesPossible.Create;

             new(dummy);
             dummy^.name:=@MoreString;
             Data^.CompValuesPossible.Add(dummy);
        END;
//        Application.LogWriteln('AddToList: Ende');
   END;

BEGIN
//  Application.LogWriteln('GetPropertyTyp');
  p1:=p;

  Typ:=p1^ AND 255;             //Property type
  inc(p1);

  CASE Typ OF
    PropType_Unsigned,PropType_Signed:
      BEGIN
        AddToList(4);
      END;

    PropType_Float:
      BEGIN
        AddToList(10);
      END;

    PropType_Boolean:   //Boolean
      BEGIN
        IF not Update THEN
          BEGIN
            IF Data^.CompValuesPossible=NIL THEN
               Data^.CompValuesPossible.Create;

            new(dummy);
            AssignStr(dummy^.Name,'True');
            getmem(dummy^.Value,1);
            b:=1;
            System.Move(b,dummy^.Value^,1);
            dummy^.ValueLen:=1;
            Data^.CompValuesPossible.Add(dummy);

            new(dummy);
            AssignStr(dummy^.Name,'False');
            getmem(dummy^.Value,1);
            b:=0;
            System.Move(b,dummy^.Value^,1);
            dummy^.ValueLen:=1;
            Data^.CompValuesPossible.Add(dummy);
          END;
     END;

     PropType_String,PropType_Char,PropType_CString:;

     PropType_Class:
       BEGIN
         ps:=PropertyNameTable+p1^;
//         Application.LogWriteln('PropType_Class: ' + ps^);
         s:=ps^;
         Data^.TypName:=ps;
         inc(p1,4);  //Name (Index)
         Data^.TypClass:=TClass(p1^);
         inc(p1,4);
//         Application.LogWriteln('PropType_Class:' + tohex(p1^));
         IF not Update THEN
           BEGIN
             IF Data^.CompValuesPossible=NIL THEN
                Data^.CompValuesPossible.Create;
             new(dummy);
             AssignStr(dummy^.Name, LoadNLSStr(SiPropertyNone));
             getmem(dummy^.Value,4);
             U:=0;
             System.Move(U,dummy^.Value^,4);
             dummy^.ValueLen:=4;
//             Application.LogWriteln('PropType_Class-Dummy: '+dummy^.Name^);
             Data^.CompValuesPossible.Add(dummy);
           END;
//         Application.LogWriteln('PropType_Class: ende');
       END;

     PropType_ClassVar:
       BEGIN
         ps:=PropertyNameTable+p1^;
         s:=ps^;
         inc(p1,4);  //Name (Index)
       END;

     PropType_Set:
       BEGIN
         Data^.CanExtent:=TRUE;
         GetPropertyTyp(p1,Data,Update);
       END;

     PropType_Enum:
       BEGIN
          U:=p1^;
          inc(p1,4);
          O:=p1^;
          inc(p1,4);

          IF not Update THEN Data^.CompValuesPossible.Create;

          FOR t:=U TO O DO
          BEGIN
               IF not Update THEN
               BEGIN
                  new(dummy);
                  dummy^.Name:=PropertyNameTable+p1^;
                  dummy^.ValueLen:=4;
                  getmem(dummy^.Value,4);
                  System.Move(t,dummy^.Value^,4);

                  Data^.CompValuesPossible.Add(dummy);
               END;
               inc(p1,4);  //Name (Index)
          END;
       END;

     PropType_ProcVar,PropType_FuncVar:
       BEGIN
         b:=p1^;
         inc(p1,4);  //Name (Index)
         s:='';
         WHILE b<>0 DO
         BEGIN
              IF s<>'' THEN s:=s+';';
              ps:=PropertyNameTable+b;
              s1:=ps^;

              b:=p1^ AND 255;
              inc(p1);
              CASE b OF
                1:s1:=Key(_VAR_)+' '+s1;
                2:;
                3:s1:=Key(_CONST_)+' '+s1;
              END;

              s:=s+s1;
              b:=p1^;         //TypeName
              inc(p1,4);      //Name (Index)
              IF b<>0 THEN
              BEGIN
                   ps:=PropertyNameTable+b;
                   s1:=ps^;
                   s:=s+':'+s1;
              END;

              b:=p1^;
              inc(p1,4);  //Name (Index)
         END; //while
         {Data^.Params := NewStr(s); das kostet Speicher}
         AssignStr(Data^.Params,s);

         IF Typ=$8c THEN
         BEGIN
              Data^.result:=POINTER(PropertyNameTable+p1^); //ObjFuncVar
              inc(p1,4); //Name (Index)
         END
         ELSE Data^.result:=NIL;
       END;

     PropType_Record:
       BEGIN
         AddToList(-1);
       END;
  END; {case}

  p:=p1;
//  Application.LogWriteln('GetPropertyTyp: Ende');
END;

PROCEDURE EraseObjMethod(OwnerObject,ActualObject:TControl;
                         PropertyName:STRING);
VAR Meth,Last:PIDE_Methods;
    s2,s3:STRING;
    t:LONGINT;
    Own:PIDE_OwnerList;
BEGIN
     s2:=PropertyName;
     UpcaseStr(s2);

     Meth:=OwnerObject.Methods;

     Last:=NIL;
     WHILE Meth<>NIL DO
     BEGIN
          FOR t:=0 TO Meth^.Owners.Count-1 DO
          BEGIN
               Own:=Meth^.Owners.Items[t];
               s3:=Own^.PropertyName^;
               UpcaseStr(s3);
               //Object method exists with same parent ??
               IF s3=s2 THEN
                 IF Own^.Objekt=ActualObject THEN //Property name match
               BEGIN
                    //Remove Method only if it has no more owners
                    IF Meth^.Owners.Count=1 THEN
                    BEGIN
                         //Method must be erased
                         IF not GenRemoveProc(OwnerObject,Meth^.Name^)
                         THEN exit; {Dialog "Manuelles Entfernen" verneint}
                         DisposeStr(Meth^.Name);
                         DisposeStr(Meth^.Params);
                         Meth^.Owners.Remove(Own);
                         DisposeStr(Own^.PropertyName);
                         Dispose(Own);
                         Meth^.Owners.Destroy;
                         IF Last=NIL THEN OwnerObject.Methods:=Meth^.Next
                         ELSE Last^.Next:=Meth^.Next;
                         Dispose(Meth);
                         exit;
                     END
                     ELSE  //only remove object from Parent list
                     BEGIN
                          Meth^.Owners.Remove(Own);
                          DisposeStr(Own^.PropertyName);
                          Dispose(Own);
                          exit;
                     END;
               END;
          END;

          Last:=Meth;
          Meth:=Meth^.Next;
     END;
END;

FUNCTION CompareMethodParameters(s,s1:STRING):BOOLEAN;

  PROCEDURE Normalize(VAR ss:STRING);
  BEGIN
       WHILE ((length(ss)>0)AND(ss[1] IN [#32,'('])) DO Delete(ss,1,1);
       WHILE ss[length(ss)] IN [#32,';',')'] DO dec(ss[0]);
       IF pos(')',ss)<>0 THEN ss[0]:=chr(pos(')',ss)-1);
       WHILE ss[length(ss)] IN [#32,';',')'] DO dec(ss[0]);
  END;

  FUNCTION CheckType(ss,ss1:STRING):BOOLEAN;
  VAR b:BYTE;
  BEGIN
       b:=Pos(':',ss);
       IF b<>0 THEN
       BEGIN
            Delete(ss,1,b);
            b:=Pos(':',ss1);
            IF b<>0 THEN
            BEGIN
                 Delete(ss1,1,b);
                 Normalize(ss);
                 Normalize(ss1);
                 Result:=ss=ss1;
            END
            ELSE Result:=FALSE; //Untyped
       END
       ELSE Result:=ss=ss1;
  END;

VAR b:BYTE;
    Temp,Temp1:STRING;
BEGIN
     Normalize(s);
     Normalize(s1);

     Result:=FALSE;
     IF s<>s1 THEN
     BEGIN
          b:=pos(';',s);
          WHILE b<>0 DO
          BEGIN
               Temp:=Copy(s,1,b-1);
               Delete(s,1,b);
               b:=pos(';',s1);
               IF b<>0 THEN
               BEGIN
                    Temp1:=Copy(s1,1,b-1);
                    Delete(s1,1,b);
                    IF not CheckType(Temp,Temp1) THEN
                    BEGIN
                         result:=FALSE; //not equal
                         exit;
                    END;
               END
               ELSE
               BEGIN
                    result:=FALSE;  //to less parameters
                    exit;
               END;
          END;

          Result:=CheckType(s,s1);
     END
     ELSE Result:=TRUE;
END;

FUNCTION InsertMethodValid(OwnerObject,ObjectToInsert:TControl;
                           PropertyName,MethodName,MethodParams:STRING):BOOLEAN;
VAR Meth,Last:PIDE_Methods;
    s,s1,s2,s3:STRING;
    t:LONGINT;
    Own:PIDE_OwnerList;
LABEL l;
BEGIN
     result:=FALSE;
     //IDEData:=OwnerObject.IDESCU_Data;
     //IF IDEData=NIL THEN exit;
     s:=MethodName;
     UpcaseStr(s);
     s1:=MethodParams;
     UpcaseStr(s1);
     s2:=PropertyName;
     UpcaseStr(s2);
     Meth:=OwnerObject.Methods;
     Last:=NIL;
     WHILE Meth<>NIL DO
     BEGIN
          s3:=Meth^.Name^;
          UpcaseStr(s3);
          IF s3=s THEN  //Method Names match ??
          BEGIN
               s3:=Meth^.Params^;
               UpcaseStr(s3);

               IF not CompareMethodParameters(s3,s1) THEN
               BEGIN
                    ErrorBox(FmtLoadNLSStr(SiDupMethodName,[MethodName]));
                    exit;
               END;

               FOR t:=0 TO Meth^.Owners.Count-1 DO
               BEGIN
                    Own:=Meth^.Owners.Items[t];
                    s3:=Own^.PropertyName^;
                    UpcaseStr(s3);
                    //Object method exists with same parent ??
                    IF s3=s2 THEN IF Own^.Objekt=ObjectToInsert THEN
                    BEGIN
                         result:=FALSE; //Do not insert method again
                         exit;
                    END;
               END;

               //Add new Parent
               new(Own);
               AssignStr(Own^.PropertyName,PropertyName);
               Own^.Objekt:=TComponent(ObjectToInsert);
               Meth^.Owners.Add(Own);
               result:=FALSE;  //do not insert method again
               exit;
          END
          ELSE  //Method names do not match
          BEGIN
               FOR t:=0 TO Meth^.Owners.Count-1 DO
               BEGIN
                    Own:=Meth^.Owners.Items[t];
                    s3:=Own^.PropertyName^;
                    UpcaseStr(s3);
                    //Object method exists with same parent ??
                    IF s3=s2 THEN
                      IF Own^.Objekt=ObjectToInsert THEN
                    BEGIN
                         //Rename Method only if it has no more owners
                         IF Meth^.Owners.Count=1 THEN
                         BEGIN
                              //Method has new name
                              IF GenRenameProc(TForm(OwnerObject),
                                               Meth^.Name^,MethodName)
                              THEN AssignStr(Meth^.Name,MethodName);
                              result:=FALSE;  {Do not Insert method again}
                              exit;
                          END
                          ELSE  //only remove object from Parent list
                          BEGIN
                               Meth^.Owners.Remove(Own);
                               AssignStr(Own^.PropertyName,'');
                               Dispose(Own);
                               //Insert the new method
                               goto l;
                          END;
                    END;
               END;
          END;
l:
          Last:=Meth;
          Meth:=Meth^.Next;
     END;

     IF Last=NIL THEN
     BEGIN
          new(Last);
          OwnerObject.Methods:=Last;
     END
     ELSE
     BEGIN
          new(Last^.Next);
          Last:=Last^.Next;
     END;

     AssignStr(Last^.Name,MethodName);
     AssignStr(Last^.Params,MethodParams);
     Last^.Owners.Create;

     new(Own);
     AssignStr(Own^.PropertyName,PropertyName);
     Own^.Objekt:=TComponent(ObjectToInsert);
     Last^.Owners.Add(Own);
     Last^.Next:=NIL;

     result:=TRUE;
END;


FUNCTION GetObjMethodName(OwnerObject,ActualObject:TControl;
                          PropertyName:STRING):STRING;
VAR Meth:PIDE_Methods;
    Own:PIDE_OwnerList;
    t:LONGINT;
    s2,s3:STRING;
BEGIN
     result:='';
     s2:=PropertyName;
     UpcaseStr(s2);

     //IF OwnerObject.IDESCU_Data=NIL THEN exit;
     Meth:=OwnerObject.Methods;

     WHILE Meth<>NIL DO
     BEGIN
          FOR t:=0 TO Meth^.Owners.Count-1 DO
          BEGIN
               Own:=Meth^.Owners.Items[t];
               s3:=Own^.PropertyName^;
               UpcaseStr(s3);
               IF s3=s2 THEN IF Own^.Objekt=ActualObject THEN //found
               BEGIN
                    result:=Meth^.Name^;
                    exit;
               END;
          END;

          Meth:=Meth^.Next;
     END;
END;


PROCEDURE InsertDefaultEvent(Sender:TComponent);
VAR s,s1,DefaultPropName,Value:STRING;
    Owner:TControl;
    Params:STRING;
    Info:TPropertyTypeInfo;
    p1:^LONGINT;
    b:LONGINT;
    ps:^STRING;
    t:LONGINT;
    aSender:TComponent;
    ret:TClassPropertyEditorReturn;
    ActualBitmapProperty:TBitmap;
    pt:TPoint;

TYPE DefaultPropRec=RECORD
                      aClass:TClass;
                      aName:STRING[20];
                    END;

CONST DefaultPropsCount=45;
      DefaultProps:ARRAY[1..DefaultPropsCount] OF DefaultPropRec=
              (
               (aClass:TForm;aName:'OnCreate'),
               (aClass:TLabel;aName:'OnClick'),
               (aClass:TEdit;aName:'OnChange'),
               (aClass:TMemo;aName:'OnChange'),
               (aClass:TButton;aName:'OnClick'),
               (aClass:TCheckBox;aName:'OnClick'),
               (aClass:TRadioButton;aName:'OnClick'),
               (aClass:TListBox;aName:'OnClick'),
               (aClass:TComboBox;aName:'OnChange'),
               (aClass:TScrollBar;aName:'OnChange'),
               (aClass:TGroupBox;aName:'OnClick'),
               (aClass:TRadioGroup;aName:'OnClick'),
               (aClass:TCheckGroup;aName:'OnClick'),
               (aClass:TPanel;aName:'OnClick'),
               (aClass:TBitBtn;aName:'OnClick'),
               (aClass:TSpeedButton;aName:'OnClick'),
               (aClass:TStringGrid;aName:'OnClick'),
               (aClass:TShape;aName:'OnDragDrop'),
               (aClass:TOutline;aName:'OnItemFocus'),
               (aClass:TListView;aName:'OnItemSelect'),
               (aClass:TTrackBar;aName:'OnChange'),
               (aClass:TUpDown;aName:'OnClick'),
               (aClass:TProgressBar;aName:'OnChange'),
               (aClass:TTimer;aName:'OnTimer'),
               (aClass:TFileListBox;aName:'OnChange'),
               (aClass:TDirectoryListBox;aName:'OnChange'),
               (aClass:TDriveComboBox;aName:'OnChange'),
               (aClass:TFilterComboBox;aName:'OnChange'),
               (aClass:TMediaPlayer;aName:'OnClick'),
               (aClass:TDdeClientConv;aName:'OnOpen'),
               (aClass:TDdeClientItem;aName:'OnChange'),
               (aClass:TDdeServerConv;aName:'OnExecuteMacro'),
               (aClass:TDdeServerItem;aName:'OnChange'),
               (aClass:TTabSet;aName:'OnChange'),
               (aClass:TNoteBook;aName:'OnPageChanged'),
               (aClass:TPaintBox;aName:'OnPaint'),
               (aClass:TValueSet;aName:'OnItemFocus'),
               (aClass:TMCIDevice;aName:'OnPositionChanged'),
               (aClass:TVideoWindow;aName:'OnPositionChanged'),
               (aClass:TVolumeControl;aName:'OnPositionChanged'),
               (aClass:TStatusBar;aName:'OnDrawPanel'),
               (aClass:THeaderControl;aName:'OnSectionClick'),
               (aClass:TSizeBorder;aName:'OnSized'),
               (aClass:TDrawGrid;aName:'OnDrawCell'),
               (aClass:TImageItemList;aName:'OnChange')
              );

BEGIN
     WHILE ((Sender IS TComponent)AND(Sender.ComponentState*[csDetail]<>[])) DO Sender:=Sender.Owner;
     IF not (Sender IS TComponent) THEN exit;
     Owner:=TForm(Sender);

     //suchen Parent Form
     WHILE not (Owner IS TForm) DO
     BEGIN
          IF Owner.Owner=NIL THEN exit;
          Owner:=TControl(Owner.Owner);
     END;

     DefaultPropName:='';
     aSender:=Sender;
     aSender:=GetReferenceProc(aSender);

     IF ASender IS TPopupMenu THEN //open editor
     BEGIN
          pt.X:=10;
          pt.Y:=50;
          IF Sender IS TControl THEN
            pt := TControl(Sender).Parent.ClientToScreen(Point(TControl(Sender).Left,
                                                         TControl(Sender).Bottom));
          TPopupMenu(ASender).PopUp(pt.X,pt.Y);
          exit;
     END;

     IF ASender IS TImage THEN
     BEGIN
          ActualBitmapProperty:=TImage(ASender).Bitmap;
          IF ActualBitmapProperty=NIL THEN ActualBitmapProperty.Create;

          ret:=CallClassPropertyEditor(ActualBitmapProperty);

          CASE ret OF
            peClear:
            BEGIN
                 IF TImage(ASender).Bitmap=NIL THEN ActualBitmapProperty.Destroy;
                 TImage(ASender).Bitmap:=NIL;
            END;
            peOk:
            BEGIN
                 TImage(ASender).Bitmap:=ActualBitmapProperty;
            END;
          END;
          Inspector.UpdateInspectorData(ASender);
          exit;
     END
     ELSE
     BEGIN
          FOR t:=1 TO DefaultPropsCount DO
          BEGIN
              IF aSender IS DefaultProps[t].aClass THEN
              BEGIN
                   DefaultPropName:=DefaultProps[t].aName;
                   break;
              END;
          END;
          IF DefaultPropName='' THEN exit;
     END;

     //look if the property is already present
     s:=GetObjMethodName(Owner,TControl(aSender),DefaultPropName);
     IF s<>'' THEN
     BEGIN
          GenGotoProc(Owner,s);
          exit;
     END;
//   Application.LogWriteln('GetPropertyTyp aufruf 1');
     IF not aSender.GetPropertyTypeInfo(DefaultPropName,Info) THEN exit;
     IF not (Info.Typ IN [PropType_ProcVar,PropType_FuncVar]) THEN exit;

     p1:=Info.TypeInfo;
     inc(p1);
     b:=p1^;
     inc(p1,4);  //Name (Index)
     Params:='';
     WHILE b<>0 DO
     BEGIN
          IF Params<>'' THEN Params:=Params+';';
          ps:=Info.NameTable+b;
          s1:=ps^;

          b:=p1^ AND 255;
          inc(p1);
          CASE b OF
             1:s1:=Key(_VAR_)+' '+s1;
             2:;
             3:s1:=Key(_CONST_)+' '+s1;
          END;

          Params:=Params+s1;
          b:=p1^;         //TypeName
          inc(p1,4);      //Name (Index)
          IF b<>0 THEN
          BEGIN
               ps:=Info.NameTable+b;
               s1:=ps^;
               Params:=Params+':'+s1;
          END;

          b:=p1^;
          inc(p1,4);  //Name (Index)
     END; //while

     s:=';';
     IF Params<>'' THEN s:='('+Params+');';
     Value:=aSender.Name+DefaultPropName;

     IF not InsertMethodValid(Owner,TControl(aSender),DefaultPropName,Value,s) THEN
     BEGIN
          //Update if something has changed (e.g. renaming)
          IF Inspector<>NIL THEN Inspector.UpdateInspectorData(Inspector.InspectedObject);
          exit;
     END;

     IF Inspector<>NIL THEN Inspector.UpdateInspectorData(Inspector.InspectedObject);

     Value := Value + s;
     IF not GenNewProc(Owner,Value,NIL) THEN ErrorBox(FmtLoadNLSStr(SiIllegalMethod,[Value]));
END;


FUNCTION Value2cmCommand(lw:LONGWORD):STRING;
VAR ll:LONGINT;
BEGIN
     result:=tostr(lw);
     ll:=lw-cmUser;
     IF ll<0 THEN exit;
     result:='cmUser+'+tostr(ll);
END;

FUNCTION Value2KbValue(lw:LONGWORD;Values:TList):STRING;
VAR
    dummy:PCompValuesPossible;
    t:LONGWORD;
    plw:^LONGWORD;
BEGIN
     result:='';
     FOR t:=0 TO Values.Count-1 DO
     BEGIN
          dummy:=Values.Items[t];
          plw:=dummy^.Value;
          IF plw^ AND 255=0 THEN
            IF lw AND plw^=plw^ THEN IF plw^<>cmNull THEN
          BEGIN
               IF dummy^.Name^<>'kb_Char' THEN
               BEGIN
                   IF result<>'' THEN result:=result+'+'+dummy^.Name^
                   ELSE result:=dummy^.Name^;
               END;
          END;
     END;
     IF lw AND kb_Char=kb_Char THEN
     BEGIN
          IF result<>'' THEN result:=result+'+'#39+chr(lw AND 255)+#39
          ELSE result:=#39+chr(lw AND 255)+#39;
     END;
END;

FUNCTION TInspector.GetPropString(Data:PComponentInterior;Update:BOOLEAN;Instance:TComponent):STRING;
VAR ps:^String;
    pc:^CString;
    pb:^Byte;
    pw:^Word;
    plw:^LongWord;
    lw:LONGWORD;
    IscmCommand:BOOLEAN;
    IskbValue:BOOLEAN;
    psi:^ShortInt;
    pi:^Integer;
    pli,pli1:^LongInt;
    ll:LONGINT;
    tt:LONGINT;
    dummy,FoundDummy:PCompValuesPossible;
    ss,ss1:STRING;
    pbo:^BOOLEAN;
    Data1:PComponentInterior;
    Control:TControl;
    psing:^Single;
    pdoub:^Double;
    pext:^Extended;
    e:EXTENDED;
BEGIN
     result:=#0;
     CASE Data^.CompTyp OF
        PropType_Record:
        BEGIN
             IF Data^.CompValuesPossible=NIL THEN exit;  //error

             result:='(';

             FOR tt:=0 TO Data^.CompValuesPossible.Count-1 DO
             BEGIN
                  dummy:=Data^.CompValuesPossible.Items[tt];
                  dummy^.RecordInterior^.CompValue:=Data^.CompValue+dummy^.RecordInterior^.CompValueAdr;
                  ss:=GetPropString(dummy^.RecordInterior,Update,Instance);
                  IF ss=#0 THEN
                  BEGIN
                       result:=#0;
                       exit;
                  END;

                  IF length(result)>1 THEN result:=result+';';
                  result:=result+dummy^.Name^+':'+ss;
             END;

             result:=result+')';

             IF Update THEN IF Data^.Extended>0 THEN
             BEGIN
                  FOR ll:=Data^.Extended TO Properties.Interior.Count-1 DO
                  BEGIN
                       Data1:=Properties.Interior.Items[ll];
                       IF Data1^.ParentInterior=Data THEN
                       BEGIN
                            ss:=GetPropString(Data1,Update,Instance);
                            AssignStr(Data1^.CompData,ss);
                            Data1^.Changed:=TRUE;
                       END;
                  END;
             END;
        END;
        PropType_String:
        BEGIN
             ps:=Data^.CompValue;
             result:=ps^;
        END;
        PropType_CString:
        BEGIN
             pc:=Data^.CompValue;
             result:=pc^;
        END;
        PropType_Unsigned:
        BEGIN
             CASE Data^.CompValueLen OF
               1:
               BEGIN
                    pb:=Data^.CompValue;
                    STR(pb^,result);
                    lw:=pb^;
               END;
               2:
               BEGIN
                    pw:=Data^.CompValue;
                    STR(pw^,result);
                    lw:=pw^;
               END;
               4:
               BEGIN
                    plw:=Data^.CompValue;
                    STR(plw^,result);
                    lw:=plw^;
               END;
             END;

             IsCmCommand:=FALSE;
             IsKbValue:=FALSE;
             IF Data^.CompValuesPossible<>NIL THEN
             BEGIN
                  IF Data^.CompData<>NIL THEN
                  BEGIN
                       ss1:=Data^.CompData^;
                       UpcaseStr(ss1);
                  END
                  ELSE ss1:='';
                  FoundDummy:=NIL;

                  FOR tt:=0 TO Data^.CompValuesPossible.Count-1 DO
                  BEGIN
                       dummy:=Data^.CompValuesPossible.Items[tt];
                       ss:=dummy^.name^;
                       UpcaseStr(ss);
                       IF ss='CMUSER' THEN IscmCommand:=TRUE;
                       IF ss='KBNULL' THEN IsKbValue:=TRUE;

                       IF dummy^.ValueLen=4 THEN
                       BEGIN
                            plw:=dummy^.Value;
                            IF plw^=lw THEN
                            BEGIN
                                 IF FoundDummy<>NIL THEN
                                 BEGIN
                                      IF ss=ss1 THEN FoundDummy:=dummy;  //another item with other name !
                                 END
                                 ELSE FoundDummy:=dummy;
                            END;
                       END
                       ELSE IF dummy^.ValueLen=2 THEN
                       BEGIN
                            pw:=dummy^.Value;
                            IF pw^=lw THEN
                            BEGIN
                                 IF FoundDummy<>NIL THEN
                                 BEGIN
                                      IF ss=ss1 THEN FoundDummy:=dummy;  //another item with other name !
                                 END
                                 ELSE FoundDummy:=dummy;
                            END;
                       END
                       ELSE IF dummy^.ValueLen=1 THEN
                       BEGIN
                            pb:=dummy^.Value;
                            IF pb^=lw THEN
                            BEGIN
                                 IF FoundDummy<>NIL THEN
                                 BEGIN
                                      IF ss=ss1 THEN FoundDummy:=dummy;  //another item with other name !
                                 END
                                 ELSE FoundDummy:=dummy;
                            END;
                       END;
                  END;

                  IF FoundDummy<>NIL THEN
                  BEGIN
                       result:=FoundDummy^.Name^;
                       exit;
                  END;
             END;

             IF IsCmCommand THEN result:=Value2CmCommand(lw); //convert number to cmXXX constant
             IF IsKbValue THEN result:=Value2KbValue(lw,Data^.CompValuesPossible);
        END;
        PropType_Signed:
        BEGIN
             CASE Data^.CompValueLen OF
               1:
               BEGIN
                    psi:=Data^.CompValue;
                    STR(psi^,result);
                    ll:=psi^;
               END;
               2:
               BEGIN
                    pi:=Data^.CompValue;
                    STR(pi^,result);
                    ll:=pi^;
               END;
               4:
               BEGIN
                    pli:=Data^.CompValue;
                    STR(pli^,result);
                    ll:=pli^;
               END;
             END;

             IF Data^.CompValuesPossible<>NIL THEN
             BEGIN
                  IF Data^.CompData<>NIL THEN
                  BEGIN
                       ss1:=Data^.CompData^;
                       UpcaseStr(ss1);
                  END
                  ELSE ss1:='';
                  FoundDummy:=NIL;

                  FOR tt:=0 TO Data^.CompValuesPossible.Count-1 DO
                  BEGIN
                       dummy:=Data^.CompValuesPossible.Items[tt];
                       ss:=dummy^.name^;
                       UpcaseStr(ss);

                       IF dummy^.ValueLen=4 THEN
                       BEGIN
                            pli:=dummy^.Value;
                            IF pli^=ll THEN
                            BEGIN
                                 IF FoundDummy<>NIL THEN
                                 BEGIN
                                      IF ss=ss1 THEN FoundDummy:=dummy;  //another item with other name !
                                 END
                                 ELSE FoundDummy:=dummy;
                            END;
                       END
                       ELSE IF dummy^.ValueLen=2 THEN
                       BEGIN
                            pi:=dummy^.Value;
                            IF pi^=ll THEN
                            BEGIN
                                 IF FoundDummy<>NIL THEN
                                 BEGIN
                                      IF ss=ss1 THEN FoundDummy:=dummy;  //another item with other name !
                                 END
                                 ELSE FoundDummy:=dummy;
                            END;
                       END
                       ELSE IF dummy^.ValueLen=1 THEN
                       BEGIN
                            psi:=dummy^.Value;
                            IF psi^=ll THEN
                            BEGIN
                                 IF FoundDummy<>NIL THEN
                                 BEGIN
                                      IF ss=ss1 THEN FoundDummy:=dummy;  //another item with other name !
                                 END
                                 ELSE FoundDummy:=dummy;
                            END;
                       END;
                  END;

                  IF FoundDummy<>NIL THEN
                  BEGIN
                       result:=FoundDummy^.Name^;
                       exit;
                  END;
             END;
        END;
        PropType_Float:
        BEGIN
             CASE Data^.CompValueLen OF
               4:
               BEGIN
                    psing:=Data^.CompValue;
                    STR(psing^,result);
                    e:=psing^;
               END;
               8:
               BEGIN
                    pdoub:=Data^.CompValue;
                    STR(pdoub^,result);
                    e:=pdoub^;
               END;
               10:
               BEGIN
                    pext:=Data^.CompValue;
                    STR(pext^,result);
                    e:=pext^;
               END;
             END;

             IF Data^.CompValuesPossible<>NIL THEN
             BEGIN
                  IF Data^.CompData<>NIL THEN
                  BEGIN
                       ss1:=Data^.CompData^;
                       UpcaseStr(ss1);
                  END
                  ELSE ss1:='';
                  FoundDummy:=NIL;

                  FOR tt:=0 TO Data^.CompValuesPossible.Count-1 DO
                  BEGIN
                       dummy:=Data^.CompValuesPossible.Items[tt];
                       ss:=dummy^.name^;
                       UpcaseStr(ss);

                       IF dummy^.ValueLen=10 THEN
                       BEGIN
                            pext:=dummy^.Value;
                            IF pext^=e THEN
                            BEGIN
                                 IF FoundDummy<>NIL THEN
                                 BEGIN
                                      IF ss=ss1 THEN FoundDummy:=dummy;  //another item with other name !
                                 END
                                 ELSE FoundDummy:=dummy;
                            END;
                       END
                       ELSE IF dummy^.ValueLen=8 THEN
                       BEGIN
                            pdoub:=dummy^.Value;
                            IF pdoub^=e THEN
                            BEGIN
                                 IF FoundDummy<>NIL THEN
                                 BEGIN
                                      IF ss=ss1 THEN FoundDummy:=dummy;  //another item with other name !
                                 END
                                 ELSE FoundDummy:=dummy;
                            END;
                       END
                       ELSE IF dummy^.ValueLen=4 THEN
                       BEGIN
                            psing:=dummy^.Value;
                            IF psing^=e THEN
                            BEGIN
                                 IF FoundDummy<>NIL THEN
                                 BEGIN
                                      IF ss=ss1 THEN FoundDummy:=dummy;  //another item with other name !
                                 END
                                 ELSE FoundDummy:=dummy;
                            END;
                       END;
                  END;

                  IF FoundDummy<>NIL THEN
                  BEGIN
                       result:=FoundDummy^.Name^;
                       exit;
                  END;
             END;
        END;
        PropType_Boolean:
        BEGIN
             pbo:=Data^.CompValue;
             IF pbo^=TRUE THEN result:='True'
             ELSE result:='False';
        END;
        PropType_Enum:
        BEGIN
             pli:=Data^.CompValue;
             IF Data^.CompValuesPossible<>NIL THEN
              IF pli^>=0 THEN IF pli^<Data^.CompValuesPossible.Count THEN
              BEGIN
                   dummy:=Data^.CompValuesPossible.Items[pli^];
                   IF dummy^.name<>NIL THEN
                   BEGIN
                        result:=dummy^.name^;
                   END
                   ELSE result:=#0;
              END;
        END;
        PropType_Set:
        BEGIN
             result:='[';
             IF Data^.CompValueLen<32 THEN
             BEGIN
                  pli:=Data^.CompValue;
                  IF pli<>NIL THEN
                   IF Data^.CompValuesPossible<>NIL THEN
                  BEGIN
                       FOR tt:=0 TO Data^.CompValuesPossible.Count-1 DO
                       BEGIN
                             dummy:=Data^.CompValuesPossible.Items[tt];
                             CASE dummy^.ValueLen OF
                                1:
                                BEGIN
                                     pb:=dummy^.Value;
                                     ll:=pb^;
                                END;
                                2:
                                BEGIN
                                     pw:=dummy^.Value;
                                     ll:=pw^;
                                END;
                                4:
                                BEGIN
                                     pli1:=dummy^.Value;
                                     ll:=pli1^;
                                END;
                                ELSE ll:=0;
                             END; {case}

                             IF pli^ AND (1 SHL ll) <>0 THEN
                             BEGIN
                                  IF dummy^.Name<>NIL THEN
                                  BEGIN
                                       IF result[length(result)]<>'[' THEN result:=result+',';
                                       result:=result+dummy^.name^;
                                  END;
                             END;
                       END;
                  END;
             END;
             IF result[length(result)]='[' THEN result:=result+' ';
             result:=result+']';

             IF Update THEN IF Data^.Extended>0 THEN
             BEGIN
                  FOR ll:=Data^.Extended TO Properties.Interior.Count-1 DO
                  BEGIN
                       Data1:=Properties.Interior.Items[ll];
                       IF Data1^.ParentInterior=Data THEN
                       BEGIN
                            DisposeStr(Data1^.CompData);
                            pli:=Data^.CompValue;
                            CASE Data1^.CompValueLen OF
                              1:
                              BEGIN
                                   pb:=Data1^.CompValue;
                                   tt:=pb^;
                              END;
                              2:
                              BEGIN
                                   pw:=Data1^.CompValue;
                                   tt:=pw^;
                              END;
                              4:
                              BEGIN
                                   pli1:=Data1^.CompValue;
                                   tt:=pli1^;
                              END;
                            END; {case}
                            IF pli^ AND (1 SHL tt)<>0 THEN
                            BEGIN
                                 Data1^.CompData := NewStr('True');
                            END
                            ELSE
                            BEGIN
                                 Data1^.CompData := NewStr('False');
                            END;
                            Data1^.Changed:=TRUE;
                       END;
                  END;
             END;
        END;
        PropType_FuncVar,PropType_ProcVar:
        BEGIN
             Control:=TControl(Instance);

             //suchen Parent Form
             WHILE not (Control IS TForm) DO
             BEGIN
                  IF Control.Owner=NIL THEN
                  BEGIN
                       result:=#0;
                       exit;  //failure
                  END;
                  Control:=TControl(Control.Owner);
             END;

             result:=GetObjMethodName(Control,TControl(Instance),Data^.CompName^);
        END;
     END; {case}
END;


VAR GlobalUpdate:BOOLEAN;
    GlobalInstance:TComponent;
    GlobalList:TList;
    GlobalReadValues:BOOLEAN;
    IsClass:BOOLEAN;


PROCEDURE EnumPropertiesProc(CONST Name:PString;CONST PropertyInfo:TPropertyTypeInfo);
VAR s,s1,s2:STRING;
    ll:LONGINT;
    Data,Data1:PComponentInterior;
    p2:^LONGWORD;
    ps:^STRING;
    t1:POINTER;
    t:LONGINT;
    o:TObject;
    c:TComponentClass;
    cc:TComponent;
LABEL l1,l2,add,l3;
BEGIN
//  Application.LogWriteln('EnumPropertiesProc:' + Name^);
  IF PropertyInfo.Scope AND 8<>8 THEN IF GlobalUpdate THEN exit;  //not published

  s2:=Name^;
  UpcaseStr(s2);
  PropertyNameTable:=PropertyInfo.NameTable;

  IF not GlobalUpdate THEN
    BEGIN
      FOR ll:=0 TO GlobalList.Count-1 DO
        BEGIN
          Data:=GlobalList.Items[ll];
          IF Data^.CompName<>NIL THEN
          BEGIN
            s1:=Data^.CompName^;
            UpcaseStr(s1);
            IF s1=s2 THEN
            BEGIN
                 {This entry is present - skip}
                 exit;
            END;
          END;
        END;

      IF IsClass THEN IF PropertyInfo.Typ IN [PropType_ProcVar,PropType_FuncVar] THEN exit;

      IF not IsClass THEN
        FOR ll:=0 TO Inspector.Events.Interior.Count-1 DO
          BEGIN
            Data:=Inspector.Events.Interior.Items[ll];
            IF Data^.CompName<>NIL THEN
              BEGIN
                s1:=Data^.CompName^;
                UpcaseStr(s1);
                IF s1=s2 THEN
                  BEGIN  {This entry is present - skip}
                    exit;
                  END;
              END;
          END;

      New(Data);
      AssignStr(Data^.CompName,Name^);
      Data^.Scope:=PropertyInfo.Scope;

      IF PropertyInfo.Scope AND 8<>8 THEN goto add; //not published (only placeholder
    END
  ELSE
    BEGIN
      FOR ll:=0 TO Inspector.Properties.Interior.Count-1 DO
        BEGIN
          Data:=Inspector.Properties.Interior.Items[ll];
// if Data^.CompName^='DataSet' then
//    Application.LogWriteln('Data:'+Data^.CompName^);

          IF Data^.CompName<>NIL THEN
            BEGIN
              s1:=Data^.CompName^;
              UpcaseStr(s1);
// if Data^.CompName^='DataSet' then
//   Application.LogWriteln('Data:' + s1 + '/' +s2);
              IF s1=s2 THEN goto l2;  //found !
            END;
        END;

      FOR ll:=0 TO Inspector.Events.Interior.Count-1 DO
        BEGIN
          Data:=Inspector.Events.Interior.Items[ll];
          IF Data^.CompName<>NIL THEN
            BEGIN
              s1:=Data^.CompName^;
              UpcaseStr(s1);
              IF s1=s2 THEN goto l2;  //found !
            END;
        END;

          {This entry is NOT present in any list - skip}
      exit;
    END;
l2:
if Data^.CompName^='DataSet' then
   Application.LogWriteln('Data: gefunden');

     IF not GlobalUpdate THEN
       BEGIN
         Data^.CompValueLen:=PropertyInfo.Size;
         GetMem(Data^.CompValue,Data^.CompValueLen);
         Data^.CompTyp:=PropertyInfo.Typ;              //Property type
       END;

     t1:=PropertyInfo.TypeInfo;

     GetPropertyTyp(t1,Data,GlobalUpdate);

     IF not GlobalUpdate THEN
       BEGIN
         Data^.ReadTyp:=PropertyInfo.Read.Kind;
         Data^.ReadOffset:=PropertyInfo.Read.VarOffset;
         Data^.WriteTyp:=PropertyInfo.Write.Kind;
         Data^.WriteOffset:=PropertyInfo.Write.VarOffset;
       END;

     IF GlobalReadValues THEN
       BEGIN
         //Read value of the property into Data^.CompValue
         CASE Data^.ReadTyp OF
            0:;           //not avail
            1:   BEGIN    //Var Offset
                   p2:=POINTER(GlobalInstance);
                   inc(p2,Data^.ReadOffset);
                   System.Move(p2^,Data^.CompValue^,Data^.CompValueLen);
                 END;
            2,3: BEGIN         //Procedure or Function (VMT call or direct)
                   CallReadProp(GlobalInstance,Pointer(Data^.ReadOffset),
                              Data^.CompTyp,Data^.CompValueLen,
                              Data^.CompValue);
                 END;
         END;
       END;

       IF PropertyEditorAvailable(GlobalInstance.ClassType,Data^.CompName^) THEN
         BEGIN
           Data^.CanEdit:=TRUE;
           //ErrorBox2('Found Property Editor for:'+Data^.CompName^);
         END;

       IF Data^.CompTyp=PropType_Class THEN IF not IsClass THEN
         BEGIN
          s:=Data^.TypName^;
          UpcaseStr(s);
          s1:=Data^.CompName^;
          UpcaseStr(s1);
          IF s1='ICON' THEN IF GlobalInstance IS TForm THEN s:='TICON';

          IF not ClassPropertyEditorAvailable(s) THEN
          BEGIN
               c:=Data^.TypClass;
               IF not (c IS TStringSelectList) THEN
               BEGIN
                    IF ((c<>NIL)AND(c IS TComponent)) THEN
                    BEGIN
                         IF not Data^.IsLink THEN //nur einmal abtesten
                         BEGIN
                              cc:=c.Create(NIL);
                              IF not (csHandleLinks IN cc.ComponentState) THEN
                              BEGIN
                                   Data^.CanExtent:=TRUE;
                                   Data^.ClassExtent.Create;
                              END
                              ELSE Data^.IsLink:=TRUE;
                              cc.Destroy;
                         END;
                    END
                    ELSE
                    BEGIN
                         Data^.CanExtent:=TRUE;
                         Data^.ClassExtent.Create;
                    END;
               END;
          END;
         END;

     s:=Inspector.GetPropString(Data,GlobalUpdate,GlobalInstance);
     IF s=#0 THEN
     BEGIN
          IF ((Data^.CompTyp=PropType_Class)AND(Data^.Extended>0)AND(GlobalUpdate)) THEN goto l3
          ELSE goto l1;
     END;

     IF GlobalUpdate THEN
     BEGIN
         ps:=Data^.CompData;
         IF ((ps=NIL)OR(ps^<>s)) THEN
         BEGIN
              AssignStr(Data^.CompData,s);
              Data^.Changed:=TRUE;
         END
         ELSE Data^.Changed:=FALSE;

         IF Data^.CompTyp=PropType_Class THEN IF Data^.Extended>0 THEN
         BEGIN
l3:
              System.Move(Data^.CompValue^,o,4);
              IF o<>NIL THEN //the class is not nil !
               FOR t:=Data^.Extended TO Inspector.Properties.Interior.Count-1 DO
               BEGIN
                    Data1:=Inspector.Properties.Interior.Items[t];
                    IF Data1^.ParentInterior<>Data THEN break;
                    {Read this value new}
                    //Read value of the property into Data^.CompValue
                    CASE Data1^.ReadTyp OF
                        0:;  //not avail
                        1:   //Var Offset
                        BEGIN
                             p2:=POINTER(o);
                             inc(p2,Data1^.ReadOffset);
                             System.Move(p2^,Data1^.CompValue^,Data1^.CompValueLen);
                        END;
                        2,3:   //Procedure or Function (VMT call or direct)
                        BEGIN
                             CallReadProp(o,Pointer(Data1^.ReadOffset),
                                          Data1^.CompTyp,Data1^.CompValueLen,
                                          Data1^.CompValue);
                        END;
                    END;

                    s:=Inspector.GetPropString(Data1,GlobalUpdate,GlobalInstance);

                    ps:=Data1^.CompData;
                    IF ((ps=NIL)OR(ps^<>s)) THEN
                    BEGIN
                         AssignStr(Data1^.CompData,s);
                         Data1^.Changed:=TRUE;
                    END
                    ELSE Data1^.Changed:=FALSE;
               END;
         END;
     END
     ELSE
     BEGIN
          Data^.CompData := NewStr(s);
     END;

l1:
     IF not GlobalUpdate THEN
     BEGIN
         IF Data^.CompTyp IN [PropType_ProcVar,PropType_FuncVar] THEN
         BEGIN
              FOR t:=0 TO Inspector.Events.Interior.Count-1 DO
              BEGIN
                   Data1:=Inspector.Events.Interior.Items[t];
                   IF Data1^.CompName<>NIL THEN IF Data^.CompName<>NIL THEN
                   BEGIN
                        IF Data1^.CompName^>Data^.CompName^ THEN
                        BEGIN
                             Inspector.Events.Interior.Insert(t,Data);
                             exit;
                        END;
                   END;
              END;
              Inspector.Events.Interior.Add(Data)
         END
         ELSE
         BEGIN
add:
              FOR t:=0 TO GlobalList.Count-1 DO
              BEGIN
                   Data1:=GlobalList.Items[t];
                   IF Data1^.CompName<>NIL THEN IF Data^.CompName<>NIL THEN
                   BEGIN
                        IF Data1^.CompName^>Data^.CompName^ THEN
                        BEGIN
                             GlobalList.Insert(t,Data);
                             exit;
                        END;
                   END;
              END;
              GlobalList.Add(Data);
         END;
     END;
//  Application.LogWriteln('EnumPropertiesProc: Ende');
END;


PROCEDURE TInspector.GetClassValues(Data:PComponentInterior);
VAR Instance:TComponent;
BEGIN
//  Application.LogWriteln('GetClassValues');
  IF Data^.ClassExtent=NIL
    THEN Data^.ClassExtent.Create
    ELSE IF Data^.ClassExtent.Count>0 THEN exit;  //alread done !
  IF Data^.CompValue=NIL THEN exit;
  GlobalUpdate:=FALSE;
  GlobalReadValues:=TRUE;
  System.Move(Data^.CompValue^,Instance,4);
  IF Instance=NIL THEN exit;
  GlobalInstance:=Instance;
  GlobalList:=Data^.ClassExtent;
  IsClass:=TRUE;
  Instance.EnumProperties(EnumPropertiesProc);
  DeleteNonPublishedProperties(Data^.ClassExtent);
END;


PROCEDURE TInspector.EnumAllProperties(Instance:TComponent;Update,ReadValues:BOOLEAN);
BEGIN
//  Application.LogWriteln('EnumAllProperties');
  GlobalUpdate:=Update;
  GlobalReadValues:=ReadValues;          
  GlobalInstance:=Instance;
  GlobalList:=Properties.Interior;           
  IsClass:=FALSE;
//  Application.LogWriteln('EnumAllProperties');
  Instance.EnumProperties(EnumPropertiesProc);
//  Application.LogWriteln('EnumAllProperties: Ende');
END;
                  

PROCEDURE TInspector.SetInspectorFocus(Component:TComponent);
BEGIN
     IF Component = NIL THEN exit;
     IF NoteBook = NIL THEN exit;
     UpdateInspectorData(Component);
     IF NoteBook.Selected = 0 THEN NoteBook.EnableSelect(NoteBook.UpScrolled+1);
     IF NoteBook.FEdit <> NIL THEN
       IF NoteBook.FEdit.Visible THEN NoteBook.FEdit.Focus;
     IF NoteBook.FComboBox <> NIL THEN
       IF NoteBook.FComboBox.Visible THEN NoteBook.FComboBox.Focus;
     FocusFromFormular := TRUE;
END;


PROCEDURE TInspector.WriteBackProperties;
BEGIN
     IF (NoteBook.FComboBox <> NIL) AND (NoteBook.FComboBox.Visible)
     THEN NoteBook.WriteBackProperty(NoteBook.FComboBox.Caption)
     ELSE IF (NoteBook.FEdit <> NIL) AND (NoteBook.FEdit.Visible)
          THEN NoteBook.WriteBackProperty(NoteBook.FEdit.Caption);
END;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TComponentNoteBook Class implementation                     บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TComponentNotebook.CreateWnd;
Begin
     Inherited CreateWnd;
End;

PROCEDURE TComponentNoteBook.SetupShow;
BEGIN
     Inherited SetupShow;
     {$IFDEF WIN32}
     FEdit.Create(SELF);
     FEdit.Font:=Font;
     FEdit.BorderStyle:=bsNone;
     FEdit.OnScan:=EntryScanEvent;
     FEdit.OnChange:=EntryChanged;
     FEdit.OnDblClick:=EntryDblClkEvent;
     Include(FEdit.ComponentState, csDetail); {Font Drop weiter}
     FEdit.Left:=-200;
     InsertControl(FEdit);

     FComboBox.Create(SELF);
     FComboBox.Sorted:=TRUE;
     FComboBox.Font:=Font;
     FComboBox.BorderStyle:=bsNone;
     FComboBox.Style:=csDropDown;
     Include(FComboBox.ComponentState, csDetail); {Font Drop weiter}
     FComboBox.OnItemSelect:=SelectListItemCombo;
     FComboBox.OnDblClick:=EntryDblClkEvent;
     IF FComboBox.Edit <> NIL THEN FComboBox.Edit.OnScan:=EntryScanEvent
     ELSE FComboBox.OnScan:=EntryScanEvent;
     FComboBox.OnDropDown:=EvComboDropDown;
     FComboBox.Left:=-200;
     InsertControl(FComboBox);
     {$ENDIF}
END;

FUNCTION TComponentNoteBook.InspectorFontHeight:LongInt;
BEGIN
     Result:=Canvas.Font.Height;
     {$IFDEF WIN32}
     Dec(Result);
     {$ENDIF}
END;

PROCEDURE TComponentNoteBook.RedrawProperties(UpdateAll:BOOLEAN;rcu:TRect);
VAR t:LONGINT;
    rc1,rc,rc2:TRect;
    yPos,Count:LONGINT;
    Page:TComponentPage;
    s:STRING;
    CX,CY:LONGINT;
    Data:PComponentInterior;
    Component:TComponent;
    pp:^POINTER;
    CX1,CY1:LONGINT;
    oldclip:TRect;
LABEL l;
BEGIN
     IF Canvas = NIL THEN exit;
     Page:=ActivePage;
     IF Page=NIL THEN exit;

     Canvas.ClipRect := rcu;  {?!}

     rc1:=ClientRect;
     Page.GetLargestString(Canvas,CX,CY);

     Canvas.Pen.Color:=clNavy;
     Count:=1;
     yPos:=rc1.Top-2-InspectorFontHeight;
     rc.Left:=CX+7;
     rc.Right:=rc1.Right-1;

     dec(rcu.Bottom,InspectorFontHeight+4);
     IF Page.Interior<>NIL THEN
     FOR t:=UpScrolled TO Page.Interior.Count-1 DO
     BEGIN
          IF Count>=FieldCount THEN break;

          Data:=Page.Interior.Items[t];

          IF yPos<rcu.Bottom THEN goto l;

          IF Data<>NIL THEN
          BEGIN
               IF ((Data^.Changed)OR(UpdateAll)) THEN
               BEGIN
                    rc.Bottom:=yPos;
                    rc.Top:=yPos+InspectorFontHeight;
                    oldclip:=Canvas.ClipRect;
                    Canvas.ClipRect:=rc;
                    IF Data^.CompData<>NIL THEN
                    BEGIN
                         s:=' '+Data^.CompData^+' ';
                         Canvas.GetTextExtent(s,CX1,CY1);
                         Canvas.TextOut(CX+7,yPos,s)
                    END
                    ELSE
                    BEGIN
                         IF Data^.CompTyp=PropType_Class THEN
                         BEGIN
                              IF Data^.CompValue=NIL THEN Component:=NIL
                              ELSE
                              BEGIN
                                   pp:=Data^.CompValue;
                                   Component:=TComponent(pp^);
                              END;

                              IF Component<>NIL THEN
                              BEGIN
                                   IF Component IS TStringSelectList THEN s:=TStringSelectList(Component).SelectedItem
                                   ELSE IF Component IS TComponent THEN
                                   BEGIN
                                        IF ((Component IS TComponent)AND(Component.Designed)AND
                                            (csHandleLinks IN Component.ComponentState)) THEN s:=Component.Name
                                        ELSE s:='('+Component.ClassName+')';
                                   END
                                   ELSE s:='('+Component.ClassName+')';
                              END
                              ELSE s:=LoadNLSStr(SiPropertyNone);

                              s:=' '+s+' ';
                              Canvas.GetTextExtent(s,CX1,CY1);
                              Canvas.TextOut(CX+7,yPos,s)
                         END;
                    END;
                    rc2.Left:=CX+7;
                    rc2.Right:=CX+7+CX1-1;
                    rc2.Bottom:=yPos;
                    rc2.Top:=yPos+CY1-1;
                    Canvas.ExcludeClipRect(rc2);
                    {??????????+-1}
                    Canvas.FillRect(rc,Color);
                    Canvas.ClipRect:=oldclip;
                    Data^.Changed:=FALSE;
               END;
          END;
l:
          dec(yPos,InspectorFontHeight+4);
          inc(Count);
     END;
     Canvas.Pen.Color:=clWindowText;  {?}

     IF Selected>0 THEN
       IF Page.Interior<>NIL THEN
     BEGIN
          IF ((Selected<UpScrolled+1)OR(Selected>=UpScrolled+FieldCount)) THEN
          BEGIN
               Data:=Page.Interior.Items[Selected-1];
               IF ((FEdit<>NIL)AND(FEdit.Visible)) THEN FEdit.Hide
               ELSE IF ((FComboBox<>NIL)AND(FComboBox.Visible)) THEN FComboBox.Hide;
          END
          ELSE
          BEGIN
               rc:=ClientRect;

               yPos:=rc.Top-1;
               FOR t:=UpScrolled+1 TO Selected-1 DO dec(yPos,InspectorFontHeight+4);

               t:=goSysInfo.Screen.VScrollSize;
               rc1.Left:=rc.Left+CX+5;
               rc1.Right:=rc.Right-t;
               rc1.Bottom:=yPos-(InspectorFontHeight+4);
               rc1.Top:=yPos-1;
               Data:=Page.Interior.Items[Selected-1];

               IF (FEdit<>NIL) AND (FEdit.Visible) THEN
               BEGIN
                    {$IFDEF OS2}
                    FEdit.SetWindowPos(rc1.Left,
                                       rc1.Bottom +1,
                                       rc1.Right-rc1.Left +2,
                                       rc1.Top-rc1.Bottom+1 -2);
                    {$ENDIF}
                    IF Data<>NIL THEN
                      IF Data^.CompData<>NIL THEN
                    BEGIN
                         IF FEdit.Caption<>Data^.CompData^
                         THEN FEdit.Caption:=Data^.CompData^;
                    END;
                    FEdit.Show;
               END ELSE
               IF (FComboBox<>NIL) AND (FComboBox.Visible) THEN
               BEGIN
                    {$IFDEF OS2}
                    FComboBox.SetWindowPos(rc1.Left,
                                           rc1.Bottom +1,
                                           rc1.Right-rc1.Left +1,
                                           rc1.Top-rc1.Bottom+1 -2);
                    {$ENDIF}                       
                    IF Data<>NIL THEN
                      IF Data^.CompData<>NIL THEN
                    BEGIN
                         IF FComboBox.Caption<>Data^.CompData^
                         THEN FComboBox.Caption:=Data^.CompData^;
                    END;
                    FComboBox.Show;
               END;
          END;
     END;
END;

PROCEDURE TComponentNoteBook.RedrawNames(UpdateAll:BOOLEAN;rcu:TRect);
VAR t:LONGINT;
    rc1,rc,rc2:TRect;
    yPos,Count:LONGINT;
    Page:TComponentPage;
    s:STRING;
    CX,CY:LONGINT;
    CX1,CY1:LONGINT;
    Data:PComponentInterior;
    oldclip:TRect;
LABEL l;
BEGIN
     IF Canvas = NIL THEN exit;
     Page:=ActivePage;
     IF Page=NIL THEN exit;

     Canvas.ClipRect := rcu;  {?!}

     rc1:=ClientRect;
     Page.GetLargestString(Canvas,CX,CY);

     Canvas.Pen.Color:=clWindowText;
     Count:=1;
     yPos:=rc1.Top-2-InspectorFontHeight;
     rc.Left:=3;
     rc.Right:=CX;
     dec(rcu.Bottom,InspectorFontHeight+4);
     IF Page.Interior<>NIL THEN
     FOR t:=UpScrolled TO Page.Interior.Count-1 DO
     BEGIN
          IF Count>=FieldCount THEN break;

          IF yPos<rcu.Bottom THEN goto l;

          Data:=Page.Interior.Items[t];
          IF Data<>NIL THEN
            IF Data^.CompName<>NIL THEN
          BEGIN
               IF ((Data^.Changed)OR(UpdateAll)) THEN
               BEGIN
                    rc.Bottom:=yPos;
                    rc.Top:=yPos+InspectorFontHeight;
                    s:=' ';
                    IF Data^.CanExtent THEN
                    BEGIN
                         IF Data^.Extended>0 THEN s:=s+'-'
                         ELSE s:=s+'+';
                    END;
                    s:=s+Data^.CompName^+' ';
                    Canvas.GetTextExtent(s,CX1,CY1);
                    oldclip:=Canvas.ClipRect;
                    Canvas.ClipRect:=rc;
                    Canvas.TextOut(3,yPos,s);
                    Data^.Changed:=FALSE;
                    rc2.Left:=3;
                    rc2.Right:=3+CX1-1;
                    rc2.Bottom:=yPos;
                    rc2.Top:=yPos+CY1-1;
                    Canvas.ExcludeClipRect(rc2); {exclude den Text}
                    Canvas.FillRect(rc,Color);
                    Canvas.ClipRect:=oldclip;
               END;
          END;
l:
          dec(yPos,InspectorFontHeight+4);
          inc(Count);
     END;

     IF Selected>0 THEN
       IF Selected>=UpScrolled+1 THEN
         IF Selected<UpScrolled+FieldCount THEN
     BEGIN
          rc:=ClientRect;

          yPos:=rc.Top-1;
          FOR t:=UpScrolled+1 TO Selected-1 DO dec(yPos,InspectorFontHeight+4);

          t:=goSysInfo.Screen.VScrollSize;
          rc.Left:=3;
          rc1.Right:=rc.Right-t-1;
          rc.Top:=yPos-1;
          rc.Bottom:=yPos-InspectorFontHeight-3;
          InflateRect(rc,1,1);
          Canvas.ShadowedBorder(rc,clBlack,clWhite);
     END;
END;

PROCEDURE TComponentNoteBook.SetSliderValues;
VAR  IntCount:LONGINT;
     Page:TComponentPage;
BEGIN
     Page:=ActivePage;
     IF Page=NIL THEN exit;
     IF Page.Interior <> NIL THEN
     BEGIN
          IF Page.Interior.Count - UpScrolled >= FieldCount
          THEN IntCount := Page.Interior.Count +1
          ELSE IntCount := UpScrolled + FieldCount;

          IF (LastMaxScroll <> IntCount) OR (LastFieldCount <> FieldCount)
          THEN ScrollBar.SetScrollRange(1,IntCount,FieldCount);
          LastMaxScroll := IntCount;
          LastFieldCount := FieldCount;
     END
     ELSE ScrollBar.SetScrollRange(1,1,FieldCount);
     ScrollBar.Position := UpScrolled+1;
END;


PROCEDURE TComponentNoteBook.Redraw(CONST rc:TRect);
VAR t:LONGINT;
    rc1:TRect;
    yPos:LONGINT;
    Page:TComponentPage;
    CX,CY:LONGINT;
BEGIN
     IF Canvas = NIL THEN exit;
     Inherited Redraw(rc);

     Canvas.Pen.Color:=clDkGray;
     Canvas.Brush.Color:=clDlgWindow;    //clLtGray

     Page:=ActivePage;
     IF Page=NIL THEN exit;

     Page.GetLargestString(Canvas,CX,CY);

     IF (Inspector.InspectedObject <> NIL) AND (FieldCount > 0) THEN
     BEGIN
          rc1:=ClientRect;
          yPos:=rc1.Top-InspectorFontHeight-5;
          FOR t:=2 TO FieldCount DO
          BEGIN
               IF t=FieldCount THEN Canvas.Line(3,yPos,rc1.Right,yPos)
               ELSE Canvas.Line(3,yPos,rc1.Right-3-ScrollBar.Width,yPos);
               dec(yPos,InspectorFontHeight+4);
          END;

          Canvas.Line(3+CX,rc1.Top-2,3+CX,yPos+InspectorFontHeight+4);
          Canvas.Pen.Color:=clWhite;
          Canvas.Line(4+CX,rc1.Top-2,4+CX,yPos+InspectorFontHeight+4);
          ScrollBar.Show;
     END
     ELSE
     BEGIN
          ScrollBar.Hide;
          LastMaxScroll := -1;
          LastFieldCount := -1;
     END;

     SetSliderValues;
     RedrawNames(TRUE,rc);
     RedrawProperties(TRUE,rc);
END;


{$HINTS ON}
PROCEDURE TComponentNoteBook.EvFontChange(Sender:TObject);
BEGIN
     Resize;
     IF FEdit <> NIL THEN FEdit.Font := Font;
     IF FComboBox <> NIL THEN FComboBox.Font := Font;
     Invalidate;
END;
{$HINTS ON}

PROCEDURE TComponentNoteBook.Resize;
VAR rc:TRect;
    YPos,t:LONGINT;
BEGIN
     Inherited Resize;

     rc:=ClientRect;
     FieldCount:=(rc.Top-rc.Bottom) DIV (InspectorFontHeight+4);
     inc(FieldCount);

     yPos:=rc.Top-1;
     FOR t:=1 TO FieldCount-1 DO dec(yPos,InspectorFontHeight+4);
     ScrollBar.SetWindowPos(rc.Right-ScrollBar.Width+1,yPos+1,
                            ScrollBar.Width,rc.Top-yPos);
     SetSliderValues;
END;


PROCEDURE TComponentNoteBook.Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;VAR ScrollPos:LONGINT);
BEGIN
     CASE ScrollCode OF
       scLineUp:        ScrollLineUp(ScrollBar);
       scLineDown:      ScrollLineDown(ScrollBar);
       scPageUp:        ScrollPageUp(ScrollBar);
       scPageDown:      ScrollPageDown(ScrollBar);
       scVertTrack,
       scVertPosition:  ScrollVertTrack(ScrollBar,ScrollPos);
     END;
     ScrollPos := UpScrolled + 1;

     IF ScrollCode IN [scVertPosition,scVertEndScroll] THEN CaptureFocus;
END;


{$HINTS OFF}
PROCEDURE TComponentNoteBook.ScrollLineUp(ScrollBar:TScrollBar);
VAR OldSel:LONGINT;
BEGIN
     IF UpScrolled=0 THEN exit;

     OldSel:=Selected;
     DisableSelect(FALSE);
     Selected:=OldSel;

     dec(UpScrolled);
     SetSliderValues;

     RedrawNames(TRUE,ClientRect);
     RedrawProperties(TRUE,ClientRect);
END;


PROCEDURE TComponentNoteBook.ScrollLineDown(ScrollBar:TScrollBar);
VAR Page:TComponentPage;
    OldSel:LONGINT;
BEGIN
     Page:=ActivePage;
     IF Page=NIL THEN exit;

     IF UpScrolled+FieldCount>Page.Interior.Count THEN exit;

     OldSel:=Selected;
     DisableSelect(FALSE);
     Selected:=OldSel;

     inc(UpScrolled);
     SetSliderValues;

     RedrawNames(TRUE,ClientRect);
     RedrawProperties(TRUE,ClientRect);
END;


PROCEDURE TComponentNoteBook.ScrollPageUp(ScrollBar:TScrollBar);
VAR Page:TComponentPage;
BEGIN
     IF UpScrolled=0 THEN exit;

     Page:=ActivePage;
     IF Page=NIL THEN exit;

     DisableSelect(TRUE);

     dec(UpScrolled,FieldCount);
     IF UpScrolled<0 THEN UpScrolled:=0;
     SetSliderValues;

     Invalidate;

     EnableSelect(UpScrolled+1);
END;


PROCEDURE TComponentNoteBook.ScrollPageDown(ScrollBar:TScrollBar);
VAR Page:TComponentPage;
BEGIN
     Page:=ActivePage;
     IF Page=NIL THEN exit;

     IF UpScrolled+FieldCount>Page.Interior.Count THEN exit;

     DisableSelect(TRUE);

     IF UpScrolled+FieldCount*2<Page.Interior.Count
     THEN inc(UpScrolled,FieldCount)
     ELSE
     BEGIN
          inc(UpScrolled,Page.Interior.Count-(UpScrolled+FieldCount-1));
     END;
     IF UpScrolled>Page.Interior.Count THEN UpScrolled:=Page.Interior.Count-1;
     IF UpScrolled<0 THEN UpScrolled:=0;
     SetSliderValues;

     Invalidate;

     EnableSelect(UpScrolled+FieldCount-1);
END;


PROCEDURE TComponentNoteBook.ScrollVertTrack(ScrollBar:TScrollBar;NewPosition:LONGINT);
VAR Page:TComponentPage;
    OldSel:LONGINT;
BEGIN
     Page:=ActivePage;
     IF Page=NIL THEN exit;

     IF NewPosition>Page.Interior.Count THEN exit;

     OldSel:=Selected;
     DisableSelect(FALSE);
     Selected:=OldSel;

     UpScrolled:=NewPosition-1;
     SetSliderValues;

     RedrawNames(TRUE,ClientRect);
     RedrawProperties(TRUE,ClientRect);
END;
{$HINTS ON}

{$HINTS OFF}
PROCEDURE TComponentNoteBook.SelectListItemCombo(Sender:TObject;Index:LONGINT);
VAR  Page:TComponentPage;
     Data:PComponentInterior;
     recu:TRect;
     yPos,t:LONGINT;
     pli:^LONGINT;
     ColorDlg:TColorDialog;
     s:STRING;
BEGIN
     Page:=ActivePage;
     IF Page=NIL THEN exit;

     IF Page.Interior<>NIL THEN
     BEGIN
          recu:=ClientRect;

          yPos:=recu.Top-1;

          FOR t:=UpScrolled+1 TO Selected DO dec(yPos,InspectorFontHeight+4);

          recu.Bottom:=yPos;
          recu.Top:=yPos+InspectorFontHeight+4;

          Data:=Page.Interior.Items[Selected-1];
          IF Data<>NIL THEN
            IF ((FComboBox<>NIL)AND(FComboBox.Visible)) THEN
            BEGIN
                s:=FComboBox.Caption;
                IF s=MoreString THEN
                BEGIN
                     {TColor Property editor}
                     FComboBox.Caption:='';
                     ColorDlg.Create(Application.MainForm);
                     ColorDlg.HelpContext := hctxDialogColorProperty;
                     pli:=Data^.CompValue;
                     ColorDlg.RGBColor := pli^;
                     IF ColorDlg.Execute
                     THEN s := tohex(ColorDlg.RGBColor)
                     ELSE s := tohex(pli^);
                     ColorDlg.Destroy;
                END;
                SetProperty(Data,s,recu,FALSE);
            END;
     END;

     TComboBox(Sender).Focus;
END;
{$HINTS ON}

PROCEDURE ConvertCMUser2Value(VAR s:STRING);
VAR s1:STRING;
    i:LONGINT;
    c:INTEGER;
BEGIN
     s1:=s;
     UpcaseStr(s1);
     delete(s1,1,length('CMUSER'));
     WHILE ((s1<>'')AND(s1[1]=#32)) DO s1:=Copy(s1,2,Length(s1)-1);
     IF ((s1='')OR(s1[1]<>'+')) THEN exit;
     delete(s1,1,1);  //erase +
     VAL(s1,i,c);
     IF c<>0 THEN exit;
     s:=tostr(cmUser+i);  //return cmUser value
END;

PROCEDURE Convertkb2Value(VAR s:STRING;Values:TList);
VAR
    s1,s2:STRING;
    Value,Value1:LONGWORD;
    b:BYTE;
   FUNCTION GetkbValueFromName(CONST test:STRING):BOOLEAN;
   VAR
      t:LONGWORD;
      dummy:PCompValuesPossible;
      plw:^LONGWORD;
      s3:STRING;
   BEGIN
        result:=FALSE;
        IF test[1]=#39 THEN
        BEGIN
            IF length(test)<>3 THEN exit; //error
            IF test[3]<>#39 THEN exit;  //error
            Value1:=ord(test[2]);
            IF Value AND kb_Char<>0 THEN exit;  //error
            Value:=Value OR kb_Char;
            result:=TRUE;
            exit;
        END
        ELSE FOR t:=0 TO Values.Count-1 DO
        BEGIN
             dummy:=Values.Items[t];
             s3:=dummy^.Name^;
             UpcaseStr(s3);
             IF s3=test THEN
             BEGIN
                  plw:=dummy^.Value;
                  Value1:=plw^;
                  IF Value1 AND 255 <> 0 THEN IF Value AND 255<>0 THEN exit; //error
                  result:=TRUE;
                  exit;
             END;
        END;
   END;
LABEL again;
BEGIN
     s1:=s;
     UpcaseStr(s1);
     s:='';
     Value:=0;
again:
     b:=pos('+',s1);
     IF b=0 THEN
     BEGIN
          IF not GetkbValueFromName(s1) THEN exit;  //error
          IF Value AND Value1=Value1 THEN IF Value1<>kb_Char THEN exit;  //error
          s:=tostr(Value OR Value1);
          exit;
     END;
     s2:=copy(s1,1,b);
     WHILE ((s2<>'')AND(s2[1]=#32)) DO s2:=Copy(s2,2,Length(s2)-1);
     WHILE s2[length(s2)]=#32 DO dec(s2[0]);
     dec(s2[0]);  //erase +
     delete(s1,1,b);
     WHILE ((s1<>'')AND(s1[1]=#32)) DO s1:=Copy(s1,2,Length(s1)-1);
     WHILE s1[length(s1)]=#32 DO dec(s1[0]);
     IF s1='' THEN exit;  //error
     IF not GetkbValueFromName(s2) THEN exit;  //error

     IF Value AND Value1=Value1 THEN IF Value1<>kb_Char THEN exit;  //error
     Value:=Value OR Value1;
     goto again;
END;

FUNCTION GetComponentFromOwner(AOwner:TComponent;Value:STRING;VAR p:POINTER):BOOLEAN;
VAR t:LONGINT;
    Component:TComponent;
    s:STRING;
BEGIN
     result:=FALSE;
     IF AOwner=NIL THEN exit;
     IF csReferenceControl IN AOwner.ComponentState THEN
     BEGIN
          AOwner:=AOwner.Owner;
          IF AOwner=NIL THEN exit;
     END;

     UpcaseStr(Value);
     FOR t:=0 TO AOwner.ComponentCount-1 DO
     BEGIN
          Component:=AOwner.Components[t];
          (* ignoriere ReferenzWindow da die Referenz auch in der ComponentListe steht *)
          IF csReferenceControl IN Component.ComponentState THEN continue;
          s:=Component.Name;
          UpcaseStr(s);
          IF csHandleLinks IN Component.ComponentState THEN
            IF Component.Designed THEN
              IF s=Value THEN
          BEGIN
               getmem(p,4);
               System.Move(Component,p^,4);
               result:=TRUE;
               exit;
          END;
     END;

     WHILE ((AOwner<>NIL)AND(not (AOwner IS TForm))) DO
     BEGIN
          IF AOwner IS TControl THEN
          BEGIN
              IF not (AOwner IS TForm) THEN
                AOwner:=TControl(AOwner).Parent;
          END
          ELSE AOwner := AOwner.Owner;

          IF AOwner<>NIL THEN
          BEGIN
               FOR t:=0 TO AOwner.ComponentCount-1 DO
               BEGIN
                    Component:=AOwner.Components[t];
                    (* ignoriere ReferenzWindow da die Referenz auch in der ComponentListe steht *)
                    IF csReferenceControl IN Component.ComponentState THEN continue;
                    s:=Component.Name;
                    UpcaseStr(s);
                    IF csHandleLinks IN Component.ComponentState THEN
                      IF Component.Designed THEN
                        IF s=Value THEN
                    BEGIN
                         getmem(p,4);
                         System.Move(Component,p^,4);
                         result:=TRUE;
                         exit;
                    END;
               END;
          END;
     END;
END;

PROCEDURE TComponentNoteBook.GenWriteComponent(iObject:TComponent;Value:POINTER;Data:PComponentInterior);
VAR p2:^LONGINT;
    t:LONGINT;
    iObject1:TComponent;
    LastX,LastY,LastWidth,LastHeight:LONGINT;
BEGIN
     CASE Data^.WriteTyp OF
       1:
       BEGIN
           p2:=POINTER(iObject);
           inc(p2,Data^.WriteOffset);
           System.Move(Value^,p2^,Data^.CompValueLen);
       END;
       2,3:
       BEGIN
           CallWriteProp(iObject,Pointer(Data^.WriteOffset),
                         Data^.CompTyp,
                         Data^.CompValueLen,Value);
       END;
     END;

     IF Inspector.InspectedObjectsList<>NIL THEN
       FOR t:=1 TO Inspector.InspectedObjectsList.Count-1 DO
     BEGIN
          iObject1:=Inspector.InspectedObjectsList[t];

          IF Data^.ParentInterior<>NIL THEN IF Data^.ParentInterior^.CompTyp=PropType_Class THEN
          BEGIN
               //Extended class property
               //geht nicht da Data^.ParentInterior fr jede
               //Komponente verschieden sein msste
               Continue;
               {System.Move(Data^.ParentInterior^.CompValue^,iObject1,4);  //get parent class
               IF iObject1=NIL THEN Continue;
               IF (iObject IS TBrush)OR(iObject IS TPen) THEN UpdateControl:=TRUE;}
          END;

          IF iObject1=iObject THEN Continue; //already written

          IF iObject1 IS TControl THEN
          BEGIN
             LastX:=TControl(iObject).Left;
             LastY:=TControl(iObject).Bottom;
             LastWidth:=TControl(iObject).Width;
             LastHeight:=TControl(iObject).Height;
          END;

          CASE Data^.WriteTyp OF
             1:
             BEGIN
                 p2:=POINTER(iObject1);
                 inc(p2,Data^.WriteOffset);
                 System.Move(Value^,p2^,Data^.CompValueLen);
             END;
             2,3:
             BEGIN
                 CallWriteProp(iObject1,Pointer(Data^.WriteOffset),
                               Data^.CompTyp,
                               Data^.CompValueLen,Value);
             END;
          END;

          IF iObject1 IS TControl THEN
          BEGIN
              IF (LastX<>TControl(iObject1).Left) OR
                 (LastY<>TControl(iObject1).Bottom) OR
                 (LastWidth<>TControl(iObject1).Width) OR
                 (LastHeight<>TControl(iObject1).Height)
               THEN NotifySM(LastX,LastY,LastWidth,LastHeight,iObject1);
          END;
     END;
END;


PROCEDURE TComponentNoteBook.SetProperty(Data:PComponentInterior;Value:STRING;
                                         recu:TRect;ForceSet:BOOLEAN);
VAR
    Control:TForm;
    t1:LONGINT;
    s,s1:STRING;
    dummy:PCompValuesPossible;
    iObject,iObject1:TComponent;
    ps:^STRING;
    cs:^CSTRING;
    pValue,pValue1,ppp:POINTER;
    li:LONGINT;
    lw:LONGWORD;
    psi:^ShortInt;
    pi:^Integer;
    pli:^LONGINT;
    pb:^BYTE;
    pw:^WORD;
    plw:^LongWord;
    c:INTEGER;
    f:Extended;
    psing:^SINGLE;
    pDoub:^Double;
    pExt:^Extended;
    pc:^Char;
    UpdateAll:BOOLEAN;
    LastX,LastY,LastWidth,LastHeight:LONGINT;
    IsCmCommand:BOOLEAN;
    IskbValue:BOOLEAN;
    Data1:PComponentInterior;
    Component:TComponent;
    pp:^POINTER;
    Own:TComponent;
    UpdateControl:BOOLEAN;
LABEL ex,skip,setstr;
BEGIN
     TRY
     iObject:=Inspector.InspectedObject;

     UpdateControl:=FALSE;
     IF Data^.ParentInterior<>NIL THEN IF Data^.ParentInterior^.CompTyp=PropType_Class THEN
     BEGIN
          //Extended class property
          System.Move(Data^.ParentInterior^.CompValue^,iObject,4);  //get parent class
          IF iObject=NIL THEN exit;  //??? error ???
          IF (iObject IS TBrush)OR(iObject IS TPen) THEN UpdateControl:=TRUE;
     END;

     IF Value=MoreString THEN Value:='';
     IsCmCommand:=FALSE;
     IsKbValue:=FALSE;

     IF iObject IS TControl THEN
     BEGIN
          LastX:=TControl(iObject).Left;
          LastY:=TControl(iObject).Bottom;
          LastWidth:=TControl(iObject).Width;
          LastHeight:=TControl(iObject).Height;
     END;

     UpdateAll:=FALSE;
     IF not (Data^.CompTyp IN [PropType_String,PropType_CString]) THEN
     BEGIN
          WHILE ((Value<>'')AND(Value[1]=#32)) DO delete(Value,1,1);
          WHILE Value[length(Value)]=#32 DO dec(Value[0]);
     END;
     IF Data^.CompData<>NIL THEN s:=Data^.CompData^
     ELSE s:='';
     UpcaseStr(s);
     s1:=Value;
     UpcaseStr(s1);

     IF Data^.CompTyp IN [PropType_String,PropType_CString] THEN
     BEGIN
          IF Data^.CompData<>NIL THEN
           IF Value=Data^.CompData^ THEN exit;
     END
     ELSE IF s=s1 THEN IF s<>'' THEN IF not ForceSet THEN exit;  //nothing to do
     Project.SCUModified := TRUE;

     //First search in values possible
     IF Data^.CompValuesPossible<>NIL THEN
       IF Data^.CompTyp<>PropType_Record THEN
     BEGIN
          IF Value='' THEN
          BEGIN
               IF Data^.CompTyp<>PropType_Class THEN exit;
               Component:=NIL;
               IF Data^.CompValue<>NIL THEN
               BEGIN
                    pp:=Data^.CompValue;
                    Component:=TComponent(pp^);
               END;
               IF Component IS TStringSelectList THEN goto setstr;
          END;

          IF Data^.CompTyp=PropType_Class THEN
            IF Value<>'' THEN
          BEGIN
               Component:=NIL;
               IF Data^.CompValue<>NIL THEN
               BEGIN
                    pp:=Data^.CompValue;
                    Component:=TComponent(pp^);
               END;
               IF Component IS TStringSelectList THEN
               BEGIN
setstr:
                    TStringSelectList(Component).SelectedItem:=Value;
                    Data^.Changed:=TRUE;
                    Inspector.UpdateInspectorDataRec(Inspector.InspectedObject,recu);
                    goto ex;
               END;

               IF iObject IS TControl THEN
               BEGIN
                    IF iObject IS TForm THEN Own:=iObject
                    ELSE Own := TControl(iObject).Parent;
               END
               ELSE Own := iObject.Owner;

               {IF GetComponentFromOwner(i.InspectedObject.Parent,Value,plw) THEN}
               IF GetComponentFromOwner(Own,Value,plw) THEN
               BEGIN
                    pValue:=plw;
                    goto skip;
               END;
          END;

          FOR t1:=0 TO Data^.CompValuesPossible.Count-1 DO
          BEGIN
               dummy:=Data^.CompValuesPossible.Items[t1];
               s:=dummy^.Name^;
               UpcaseStr(s);
               WHILE ((s<>'')AND(s[1]=#32)) DO s:=Copy(s,2,Length(s)-1);
               WHILE s[length(s)]=#32 DO dec(s[0]);
               IF s='CMUSER' THEN IsCmCommand:=TRUE;
               IF s='KBNULL' THEN IsKBValue:=TRUE;
               IF s1=s THEN  //found
               BEGIN
                    IF Data^.ParentInterior<>NIL THEN IF Data^.ParentInterior^.CompTyp<>PropType_Class THEN
                    BEGIN  {Set}
                         CASE Data^.CompValuelen of
                           1:
                           BEGIN
                                pb:=Data^.CompValue;
                                li:=pb^;
                           END;
                           2:
                           BEGIN
                                pw:=Data^.CompValue;
                                li:=pw^;
                           END;
                           4:
                           BEGIN
                                pli:=Data^.CompValue;
                                li:=pli^;
                           END;
                         END;
                         Data:=Data^.ParentInterior;
                         pli:=Data^.CompValue;
                         IF s='TRUE' THEN pli^:=pli^ OR (1 SHL li)
                         ELSE pli^:=pli^ AND NOT (1 SHL li);

                         GenWriteComponent(iObject,pli,Data);
                         Inspector.UpdateInspectorDataRec(Inspector.InspectedObject,recu);
                         goto ex;
                    END;

                    GenWriteComponent(iObject,Dummy^.Value,Data);
                    Inspector.UpdateInspectorDataRec(Inspector.InspectedObject,recu);
                    goto ex;
               END;
          END;
     END;

     IF IsCmCommand THEN IF pos('CMUSER',s1)=1 THEN ConvertCMUser2Value(Value);  //liefere Zahl
     IF IsKbValue THEN Convertkb2Value(Value,Data^.CompValuesPossible);  //liefere Zahl

     pValue:=NIL;
     CASE Data^.CompTyp OF
        PropType_String,PropType_CString:
        BEGIN
             IF length(Value)>=Data^.CompValueLen THEN Value[0]:=chr(Data^.CompValueLen-1);
             IF Data^.Comptyp=$84 THEN //PropType_String
             BEGIN
                  IF Data^.CompName^='Name' THEN
                  BEGIN
                       IF iObject IS TForm THEN
                       BEGIN
                            IF not GenRenameForm(TForm(iObject),Value) THEN
                            BEGIN
                                 IF ((FEdit<>NIL)AND(FEdit.Visible)) THEN FEdit.Caption:=iObject.Name
                                 ELSE IF ((FComboBox<>NIL)AND(FComboBox.Visible)) THEN FComboBox.Caption:=iObject.Name;
                                 exit;
                            END;
                       END
                       ELSE
                       BEGIN
                            IF not GenRenameComponent(iObject.Owner,iObject,Value) THEN
                            BEGIN
                                 IF ((FEdit<>NIL)AND(FEdit.Visible)) THEN FEdit.Caption:=iObject.Name
                                 ELSE IF ((FComboBox<>NIL)AND(FComboBox.Visible)) THEN FComboBox.Caption:=iObject.Name;
                                 exit;
                            END;
                       END;
                       Inspector.RenameInspectorItem(iObject,Value);

                       IF iObject IS TControl THEN
                       BEGIN
                            IF iObject.Name=TControl(iObject).Caption THEN
                            BEGIN
                                 TControl(iObject).Caption:=Value;
                                 UpdateAll:=TRUE;
                            END;
                       END;
                       IF iObject IS TForm THEN
                       BEGIN
                            RemoveWindowList(2,TForm(iObject));
                            AddWindowList(2,TForm(iObject));
                       END;
                  END;

                  GetMem(ps,Data^.CompValueLen);
                  ps^:=Value;
                  pValue:=ps;
             END
             ELSE
             BEGIN
                  IF Value='' THEN exit;
                  GetMem(cs,Data^.CompValueLen);
                  cs^:=Value;
                  pValue:=cs;
             END;
        END;
        PropType_Signed:
        BEGIN
             IF Value='' THEN exit;
             Val(Value,li,c);
             IF c<>0 THEN exit;
             CASE Data^.CompValueLen OF
               1:
               BEGIN
                    getmem(psi,1);
                    psi^:=li;
                    pValue:=psi;
               END;
               2:
               BEGIN
                    getmem(pi,2);
                    pi^:=li;
                    pValue:=pi;
               END;
               4:
               BEGIN
                    getmem(pli,4);
                    pli^:=li;
                    pValue:=pli;
               END;
               ELSE exit;
             END;
        END;
        PropType_Unsigned:
        BEGIN
             IF Value='' THEN exit;
             Val(Value,lw,c);
             IF c<>0 THEN exit;
             CASE Data^.CompValueLen OF
               1:
               BEGIN
                    getmem(pb,1);
                    pb^:=lw;
                    pValue:=pb;
               END;
               2:
               BEGIN
                    getmem(pw,2);
                    pw^:=lw;
                    pValue:=pw;
               END;
               4:
               BEGIN
                    getmem(plw,4);
                    plw^:=lw;
                    pValue:=plw;
               END;
               ELSE exit;
             END;
        END;
        PropType_Float:
        BEGIN
             IF Value='' THEN exit;
             Val(Value,f,c);
             IF c<>0 THEN exit;
             CASE Data^.CompValueLen OF
               4:
               BEGIN
                    getmem(pSing,4);
                    pSing^:=f;
                    pValue:=pSing;
               END;
               8:
               BEGIN
                    getmem(pDoub,8);
                    pDoub^:=f;
                    pValue:=pDoub;
               END;
               10:
               BEGIN
                    getmem(pExt,10);
                    pExt^:=f;
                    pValue:=pExt;
               END;
               ELSE exit;
             END;
        END;
        PropType_Char:
        BEGIN
             IF Value='' THEN exit;
             IF length(Value)<>1 THEN exit;

             GetMem(pc,Data^.CompValueLen);
             pc^:=Value[1];
             pValue:=pc;
        END;
        PropType_Set:
        BEGIN
             IF Value='' THEN exit;
             IF length(Value)<2 THEN exit;
             IF Value[1]<>'[' THEN exit;
             IF Value[length(Value)]<>']' THEN exit;
        END;
        PropType_ProcVar,PropType_FuncVar:
        BEGIN
             Control:=TForm(iObject);

             //suchen Parent Form
             WHILE not (Control IS TForm) DO
             BEGIN
                  IF Control.Owner=NIL THEN exit;
                  Control:=TForm(Control.Owner);
             END;

             IF Value=LoadNLSStr(SiPropertyNone) THEN Value:='';

             IF Value='' THEN //Erase method ??
             BEGIN
                  IF Data^.CompData<>NIL THEN
                  BEGIN
                       //Erase method
                       EraseObjMethod(Control,TControl(iObject),Data^.CompName^);

                       IF Inspector.InspectedObjectsList<>NIL THEN
                         FOR t1:=0 TO Inspector.InspectedObjectsList.Count-1 DO
                       BEGIN
                            iObject1:=Inspector.InspectedObjectsList[t1];
                            IF iObject1=iObject THEN continue;

                            //Erase method
                            EraseObjMethod(Control,TControl(iObject1),Data^.CompName^);
                       END;

                       DisposeStr(Data^.CompData);
                  END;
                  Data^.CompData:=NIL;
                  Inspector.UpdateInspectorDataRec(Inspector.InspectedObject,recu);
                  exit;
             END;

             IF not IsValidIdentifier(Value) THEN exit;

             s:=';';
             IF Data^.Params<>NIL THEN
               IF Data^.Params^<>'' THEN s:='('+Data^.Params^+');';
             s1:=Value;

             //Methode gltig und noch nicht vorhanden ??
             //wenn vorhanden Parameter identisch ??
             IF not InsertMethodValid(Control,TControl(iObject),
                                      Data^.CompName^,Value,s) THEN
             BEGIN
                  //Update if something has changed (e.g. renaming)
                  Inspector.UpdateInspectorDataRec(Inspector.InspectedObject,recu);
                  exit;
             END;

             Value := Value + s;

             IF not GenNewProc(Control,Value,NIL) THEN ErrorBox('Illegal method:'+Value)
             ELSE
             BEGIN
                  IF Inspector.InspectedObjectsList<>NIL THEN
                    FOR t1:=0 TO Inspector.InspectedObjectsList.Count-1 DO
                  BEGIN
                       iObject1:=Inspector.InspectedObjectsList[t1];
                       IF iObject=iObject1 THEN continue;

                       Value:=s1;

                       //Methode gltig und noch nicht vorhanden ??
                       //wenn vorhanden Parameter identisch ??
                       IF not InsertMethodValid(Control,TControl(iObject1),
                                                Data^.CompName^,Value,s) THEN continue;
                       Value := Value + s;

                       IF not GenNewProc(Control,Value,NIL) THEN ErrorBox('Illegal method:'+Value)
                  END;
             END;
             Inspector.UpdateInspectorDataRec(Inspector.InspectedObject,recu);
             exit;
        END;
        PropType_Class:
        BEGIN
             IF Value<>'' THEN exit;
             GetMem(plw,Data^.CompValueLen);
             plw^:=0;  //NIL
             pValue:=plw;
        END;
     END; {case}

skip:
     IF Data^.IsRecordComponent THEN
       IF pValue<>NIL THEN
     BEGIN
          Data1:=Data;
          pValue1:=pValue;
          Data:=Data^.ParentInterior;
          getmem(pValue,Data^.CompValueLen);
          System.Move(Data^.CompValue^,pValue^,Data^.CompValueLen);
          ppp:=pValue;
          inc(ppp,Data1^.CompValueAdr);  {Record address}
          System.Move(pValue1^,ppp^,Data1^.CompValueLen);
          freemem(pValue1,Data1^.CompValueLen);
     END;

     IF pValue<>NIL THEN
     BEGIN
          GenWriteComponent(iObject,pValue,Data);
          IF updateall THEN recu:=Inspector.ClientRect;
          Inspector.UpdateInspectorDataRec(Inspector.InspectedObject,recu);
          FreeMem(pValue,Data^.CompValueLen);
     END;
ex:
     IF iObject IS TControl THEN
     BEGIN
          IF (LastX<>TControl(iObject).Left) OR
             (LastY<>TControl(iObject).Bottom) OR
             (LastWidth<>TControl(iObject).Width) OR
             (LastHeight<>TControl(iObject).Height)
          THEN NotifySM(LastX,LastY,LastWidth,LastHeight,iObject);
     END;

     //for TBrush and TPen
{     IF UpdateControl THEN
       IF TCanvas(iObject.Owner).Control<>NIL THEN
         TCanvas(iObject.Owner).Control.Invalidate;   WD  }
     EXCEPT
       ON E:Exception DO ErrorBox(E.Message);
     END;
END;


PROCEDURE TComponentNoteBook.DisableSelect(DeleteEntry:BOOLEAN);
VAR rc:TRect;
    t,yPos:LONGINT;
    Page:TComponentPage;
    Data:PComponentInterior;
    OldSelect:LONGINT;
    recu:TRect;
BEGIN
     {$IFDEF WIN32}
     DeleteEntry:=False;
     {$ENDIF}

     IF Selected=0 THEN
     Begin
         IF DeleteEntry THEN
         BEGIN
              IF FEdit<>NIL THEN
              BEGIN
                   FEdit.Destroy;
                   FEdit:=NIL;
              END
              ELSE
              IF FComboBox<>NIL THEN
              BEGIN
                   FComboBox.Destroy;
                   FComboBox:=NIL;
              END;
         END
         ELSE
         BEGIN
              If FEdit<>Nil Then FEdit.Hide;
              If FComboBox<>Nil Then FComboBox.Hide;
         END;
         exit;
     End;

     Page:=ActivePage;
     IF Page=NIL THEN exit;

     OldSelect:=Selected;
     Selected:=0;

     recu:=ClientRect;

     yPos:=recu.Top-1;

     FOR t:=UpScrolled+1 TO OldSelect DO dec(yPos,InspectorFontHeight+4);

     recu.Bottom:=yPos;
     recu.Top:=yPos+InspectorFontHeight+4;

     IF Page.Interior<>NIL THEN
     BEGIN
          Data:=Page.Interior.Items[OldSelect-1];
          IF Data<>NIL THEN
          BEGIN
               IF ((FEdit<>NIL)AND(FEdit.Visible))
               THEN SetProperty(Data,FEdit.Caption,recu,FALSE)
               ELSE IF ((FComboBox<>NIL)AND(FComboBox.Visible))
                    THEN SetProperty(Data,FComboBox.Caption,recu,FALSE);
          END;
     END;

     IF DeleteEntry THEN
     BEGIN
          IF FEdit<>NIL THEN
          BEGIN
               FEdit.Destroy;
               FEdit:=NIL;
          END
          ELSE
          IF FComboBox<>NIL THEN
          BEGIN
               FComboBox.Destroy;
               FComboBox:=NIL;
          END;
     END
     ELSE
     BEGIN
          If FEdit<>Nil Then FEdit.Hide;
          If FComboBox<>Nil Then FComboBox.Hide;
     END;

     rc:=ClientRect;

     yPos:=rc.Top-1;

     IF OldSelect-1<UpScrolled THEN exit;
     IF OldSelect>UpScrolled+FieldCount-1 THEN exit;

     FOR t:=UpScrolled+1 TO OldSelect DO dec(yPos,InspectorFontHeight+4);

     {Vertiefung l”schen und die beiden Trennlinien malen}
     t:=goSysInfo.Screen.VScrollSize;
     rc.Left:=3;
     rc.Right:=rc.Right-t -1;
     rc.Top:=yPos+(InspectorFontHeight+3);
     rc.Bottom:=yPos+1;
     InflateRect(rc,1,1);
     Canvas.Pen.Color:=Color;
     Canvas.Line(rc.Left,rc.Bottom,rc.Left,rc.Top);  {l”schen}
     Canvas.Pen.Color:=clDkGray;
     Canvas.Line(rc.Left,rc.Bottom,rc.Right,rc.Bottom);
     Canvas.Line(rc.Left,rc.Top,rc.Right,rc.Top);
END;

PROCEDURE TComponentNoteBook.EnableSelect(NewSelected:LONGINT);
VAR shadow,rc,rc1:TRect;
    yPos,t:LONGINT;
    Page:TComponentPage;
    CX,CY:LONGINT;
    Data:PComponentInterior;
    dummy:PCompValuesPossible;
    s,s1:STRING;
    Component:TComponent;
    pp:^POINTER;
    OldEntry:TEdit;
    OldCombo:TInspectorComboBox;
    Alternate:BOOLEAN;
    Owner:TComponent;
    Meth:PIDE_Methods;
LABEL l,Combo,l1;
BEGIN
     IF Selected<>0 THEN DisableSelect(FALSE{TRUE});

     OldEntry:=FEdit;
     OldCombo:=FComboBox;

     FEdit:=NIL;
     FComboBox:=NIL;

     Page:=ActivePage;
     IF Page=NIL THEN goto l;
     IF Page.Interior=NIL THEN goto l;
     IF Page.Interior.Count = 0 THEN goto l;

     Page.GetLargestString(Canvas,CX,CY);

     Selected:=NewSelected;

     IF Selected<=0 THEN goto l;
     IF Selected>UpScrolled+FieldCount THEN goto l;
     IF Selected>Page.Interior.Count THEN Selected:=Page.Interior.Count;

     shadow:=ClientRect;

     yPos:=shadow.Top-1;
     FOR t:=UpScrolled+1 TO Selected-1 DO dec(yPos,InspectorFontHeight+4);

     shadow.Left:=3;
     shadow.Top:=yPos-1;
     shadow.Bottom:=yPos-InspectorFontHeight-3;

     Data:=Page.Interior.Items[Selected-1];
     rc:=ClientRect;
     t:=goSysInfo.Screen.VScrollSize;
     rc1.Left:=rc.Left+CX+5;
     rc1.Right:=rc.Right-t;
     rc1.Bottom:=yPos-(InspectorFontHeight+4);
     rc1.Top:=yPos-1;

     IF ((Data^.CanEdit)OR(Page=Inspector.Events)) THEN goto Combo;

     IF (Data^.CompValuesPossible=NIL) OR
        (Data^.CompTyp IN [PropType_Set,PropType_Record]) OR
        (Data^.ClassExtent<>NIL) THEN
     BEGIN
          IF OldEntry<>NIL THEN
          BEGIN
               FEdit:=OldEntry;
               FEdit.Hide;
          END
          ELSE
          BEGIN
               FEdit.Create(SELF);
               FEdit.Font:=Font;
               FEdit.BorderStyle:=bsNone;
               FEdit.OnScan:=EntryScanEvent;
               FEdit.OnChange:=EntryChanged;
               FEdit.OnDblClick:=EntryDblClkEvent;
               Include(FEdit.ComponentState, csDetail); {Font Drop weiter}
          END;

          {$IFDEF OS2}
          FEdit.SetWindowPos(rc1.Left,
                             rc1.Bottom +1,
                             rc1.Right-rc1.Left +2,
                             rc1.Top-rc1.Bottom+1 -2);
          {$ENDIF}
          {$IFDEF WIN32}
          FEdit.SetWindowPos(rc1.Left,
                             rc1.Bottom +2,
                             rc1.Right-rc1.Left+2,
                             rc1.Top-rc1.Bottom+1-3);
          {$ENDIF}

          shadow.Right := rc1.Right -1;

          IF Data^.CompData<>NIL THEN
          BEGIN
               FEdit.Caption:=Data^.CompData^;
          END
          ELSE
          BEGIN
               IF Data^.CompTyp=PropType_Class THEN
               BEGIN
                    IF Data^.CompValue=NIL THEN Component:=NIL
                    ELSE
                    BEGIN
                          pp:=Data^.CompValue;
                          Component:=TComponent(pp^);
                    END;

                    IF Component<>NIL THEN
                    BEGIN
                         IF Component IS TStringSelectList THEN s:=TStringSelectList(Component).SelectedItem
                         ELSE IF Component IS TComponent THEN
                         BEGIN
                              IF ((Component IS TComponent) AND
                                  (Component.Designed) AND
                                  (csHandleLinks IN Component.ComponentState)) THEN s:=Component.Name
                              ELSE s:='('+Component.ClassName+')';
                         END
                         ELSE s:='('+Component.ClassName+')';
                    END
                    ELSE s:=LoadNLSStr(SiPropertyNone);

                    FEdit.Caption:=s;
               END;
          END;

          IF OldEntry=NIL THEN InsertControl(FEdit)
          ELSE OldEntry:=NIL;
          FEdit.SetWindowPos(rc1.Left,
                             rc1.Bottom +1,
                             rc1.Right-rc1.Left +2,
                             rc1.Top-rc1.Bottom+1 -2);
          FEdit.Show;
          FEdit.Focus;
          FEdit.SelectAll;
     END
     ELSE
     BEGIN
Combo:
          Alternate:=FALSE;

          IF OldCombo<>NIL THEN
          BEGIN
               FComboBox:=OldCombo;
               FComboBox.Hide;
               FComboBox.Clear;
          END
          ELSE
          BEGIN
               FComboBox.Create(SELF);
               FComboBox.Sorted:=TRUE;
               FComboBox.Font:=Font;
               FComboBox.BorderStyle:=bsNone;
               FComboBox.Style:=csDropDown;
               Include(FComboBox.ComponentState, csDetail); {Font Drop weiter}
               FComboBox.OnItemSelect:=SelectListItemCombo;
               FComboBox.OnDblClick:=EntryDblClkEvent;
               IF FComboBox.Edit <> NIL THEN FComboBox.Edit.OnScan:=EntryScanEvent
               ELSE FComboBox.OnScan:=EntryScanEvent;
          END;

          FComboBox.SetWindowPos(rc1.Left,
                                 rc1.Bottom +1,
                                 rc1.Right-rc1.Left +1,
                                 rc1.Top-rc1.Bottom+1-2);

          shadow.Right := rc1.Right -1;


          IF Page=Inspector.Events THEN
          BEGIN
               //look what items we may add to the ComboBox

               //suchen Parent Form
               Owner:=Inspector.InspectedObject;
               WHILE not (Owner IS TForm) DO
               BEGIN
                    IF Owner.Owner=NIL THEN
                    BEGIN
                         Owner:=NIL;
                         break;
                    END;
                    Owner:=TControl(Owner.Owner);
               END;

               IF Owner<>NIL THEN
               BEGIN
                    IF Data^.Params<>NIL THEN s:=Data^.Params^
                    ELSE s:='';
                    UpcaseStr(s);

                    Meth:=Owner.Methods;
                    WHILE Meth<>NIL DO
                    BEGIN
                         IF Meth^.Params<>NIL THEN s1:=Meth^.Params^
                         ELSE s1:='';
                         UpcaseStr(s1);

                         IF CompareMethodParameters(s,s1) THEN
                           Begin
                             Application.LogWriteln('1 FComboBox.Items.Add:'+Meth^.Name^);
                             FComboBox.Items.Add(Meth^.Name^);
                           End;

                         Meth:=Meth^.Next;
                    END;
               END;

               Application.LogWriteln('1 FComboBox.Items.Add: <none>');
               FComboBox.Items.Add(LoadNLSStr(SiPropertyNone));
               FComboBox.Caption:=Data^.CompData^;
               Alternate:=FALSE;
               goto l1;
          END;

          IF Data^.CompData<>NIL THEN
          BEGIN
               IF Data^.CanEdit THEN Alternate:=TRUE
               ELSE Alternate:=FALSE;
               FComboBox.Caption:=Data^.CompData^;
          END
          ELSE
          BEGIN
               IF Data^.CompTyp=PropType_Class THEN
               BEGIN
                    IF Data^.CompValue=NIL THEN Component:=NIL
                    ELSE
                    BEGIN
                         pp:=Data^.CompValue;
                         Component:=TComponent(pp^);
                    END;

                    IF Component<>NIL THEN
                    BEGIN
                         IF Component IS TStringSelectList THEN s:=TStringSelectList(Component).SelectedItem
                         ELSE IF Component IS TComponent THEN
                         BEGIN
                              IF ((Component IS TComponent) AND
                                  (Component.Designed) AND
                                  (csHandleLinks IN Component.ComponentState)) THEN s:=Component.Name
                              ELSE s:='('+Component.ClassName+')';
                         END
                         ELSE s:='('+Component.ClassName+')';
                    END
                    ELSE s:=LoadNLSStr(SiPropertyNone);

                    FComboBox.Caption:=s;
                    Alternate:=TRUE;
               END;

               IF Data^.CanEdit THEN Alternate:=TRUE;
          END;

          Application.LogWriteln('EnableSelect Data^.CompValuesPossible:'+tohex(longWord(Data^.CompValuesPossible)));
          IF Data^.CompValuesPossible<>NIL THEN
            FOR t:=0 TO Data^.CompValuesPossible.Count-1 DO
            BEGIN
                 dummy:=Data^.CompValuesPossible.Items[t];
                 Application.LogWriteln('2 FComboBox.Items.Add:'+dummy^.Name^);
                 FComboBox.Items.Add(dummy^.Name^);
            END;
l1:
          IF OldCombo=NIL THEN
          BEGIN
               InsertControl(FComboBox);
               FComboBox.Show;
               FComboBox.OnDropDown:=EvComboDropDown;
          END
          ELSE
          BEGIN
               OldCombo:=NIL;
               FComboBox.Show;
          END;
          FComboBox.AlternateButton:=Alternate;
          FComboBox.Focus;
          FComboBox.SelectAll;
     END;
l:
     IF OldEntry<>NIL THEN
     BEGIN
          OldEntry.Hide;
          FEdit:=OldEntry;
     END
     ELSE IF OldCombo<>NIL THEN
     BEGIN
          OldCombo.Hide;
          FComboBox:=OldCombo;
     END;

     InflateRect(shadow,1,1);
     Canvas.ShadowedBorder(shadow,clBlack,clWhite);

     IF ((FEdit<>NIL)AND(FEdit.Visible)) THEN FEdit.Focus
     ELSE IF ((FComboBox<>NIL)AND(FComboBox.Visible)) THEN FComboBox.Focus;
END;


TYPE TListClass=CLASS OF TList;
     TStreamClass=CLASS OF TStream;
     TIconClass=CLASS OF TIcon;

{$HINTS OFF}
PROCEDURE TComponentNoteBook.EvComboDropDown(Sender:TObject);   { WD }
VAR  Page:TComponentPage;
     Data:PComponentInterior;
     InspectedObject:TComponent;
     ActualProperty:TComponent;
     ActualPropertyClass:TComponentClass;
     LClass:TClass;
     ListClass:TListClass;
     aList:TList;
     StreamClass:TStreamClass;
     aStream:TStream;
     p2:^POINTER;
     ps:^STRING;
     s:STRING;
     ret:TClassPropertyEditorReturn;
     recu:TRect;
     yPos,t:LONGINT;
     MyComp:TComponent;
     MyOwn:TComponent;
     StrList:TStringList;
     Combotext:STRING;
     ret1:TPropertyEditorReturn;
     RetList:TStringList;
     TempList:TList;
LABEL setprop,l1,setcap,ex;
BEGIN
  Application.LogWriteln('TComponentNoteBook.EvComboDropDown: '+tohex(longWord(sender)));
  Page:=ActivePage;
  Inspector.FInspectorUpdateLocked:=TRUE;  //no destroy of elements or FComboBox here !!!!
  IF Page<>NIL THEN
     BEGIN
         IF Page.Interior<>NIL THEN
         BEGIN
             Data:=Page.Interior.Items[Selected-1];
             Application.LogWriteln('Comp-Name:'+ Data^.CompName^+
                                    ', RT:' +tostr(Data^.ReadTyp));
             IF Data<>NIL THEN
             BEGIN
                  InspectedObject:=TComponent(Inspector.InspectedObject);
                  Application.LogWriteln('IO:'+tohex(longWord(InspectedObject)));
                  CASE Data^.ReadTyp OF
                     0: goto ex;
                     1:   //Var Offset
                     BEGIN
                          p2:=POINTER(InspectedObject);
                          inc(p2,Data^.ReadOffset);
                          System.Move(p2^,Data^.CompValue^,Data^.CompValueLen);
                     END;
                     2,3:   //Procedure or Function
                     BEGIN
                          CallReadProp(InspectedObject,Pointer(Data^.ReadOffset),
                                       Data^.CompTyp,Data^.CompValueLen,
                                       Data^.CompValue);
                     END;
                  END;

                  p2:=Data^.CompValue;
                  Application.LogWriteln('p2:'+tohex(longWord(p2)) + ', p2^:'+tohex(longWord(p2^)));

                  IF Data^.CanEdit THEN
                  BEGIN
                       RetList:=NIL;
                       ret1:=CallPropertyEditor(InspectedObject,Data^.CompName^,p2^,Data^.CompValueLen,RetList);
                       Application.LogWriteln('CanEdit: ' +tostr(ord(Ret1)));

                       CASE ret1 OF
                           edNoEditor:
                           BEGIN
                                IF FComboBox<>NIL THEN FComboBox.DroppedDown:=FALSE;
                           END;
                           edCancel:
                           BEGIN
                                IF FComboBox<>NIL THEN FComboBox.DroppedDown:=FALSE;
                           END;
                           edOk:
                           BEGIN
                                Project.SCUModified := TRUE;
                                CASE Data^.WriteTyp OF
                                   1,2,3:   //Var Offset
                                   BEGIN
                                       GenWriteComponent(InspectedObject,Data^.CompValue,Data);
                                   END;
                                   ELSE
                                   BEGIN
                                       ErrorBox(FmtLoadNLSStr(SiPropertyIsReadOnly,[Data^.CompName^]));
                                       IF p2^=NIL THEN ActualProperty.Destroy;
                                       goto ex;
                                   END;
                                END;

                                Data^.Changed:=TRUE;

                                recu:=ClientRect;

                                yPos:=recu.Top-1;

                                FOR t:=UpScrolled+1 TO Selected DO dec(yPos,InspectorFontHeight+4);

                                recu.Bottom:=yPos;
                                recu.Top:=yPos+InspectorFontHeight+4;

                                Inspector.FInspectorUpdateLocked:=FALSE;
                                Inspector.UpdateInspectorDataRec(Inspector.InspectedObject,recu);
                                IF InspectedObject IS TControl THEN TControl(InspectedObject).Invalidate;

                                IF FComboBox<>NIL THEN FComboBox.DroppedDown:=FALSE;
                           END;
                           edList:
                           BEGIN
                                IF RetList=NIL THEN
                                BEGIN
                                     IF FComboBox<>NIL THEN FComboBox.DroppedDown:=FALSE
                                END
                                ELSE IF FComboBox<>NIL THEN
                                BEGIN
                                     ComboText:=FComboBox.Caption;
                                     FComboBox.Clear;
                                     FComboBox.Caption:=ComboText;
                                     FComboBox.Items.Assign(RetList);
                                END;
                           END;
                       END;

                       IF RetList<>NIL THEN RetList.Destroy;
                  END
                  ELSE IF Data^.CompTyp=PropType_Class THEN
                  BEGIN
                     Application.LogWriteln('PropType_Class:'+tohex(longword(P2)));
                     ActualProperty:=TComponent(p2^);  // Zeigt auf das aktuelle Komponente.
                     Application.LogWriteln('1 ActualProperty:' +tohex(LongWord(ActualProperty)));

                     IF ActualProperty<>NIL THEN
                     BEGIN
                          IF ActualProperty IS TStringSelectList THEN
                          BEGIN
                               StrList:=TStringSelectList(ActualProperty).Items;
                               IF FComboBox<>NIL THEN FComboBox.Items := StrList;
                               goto ex;
                          END;
                     END;               

                     Application.LogWriteln('2 ActualProperty:' +tohex(LongWord(ActualProperty)));
                     IF ActualProperty=NIL THEN
                     BEGIN
                          s:=Data^.CompName^;
                          Application.LogWriteln('CompName: '+s + '/' + Data^.TypName^);
                          UpcaseStr(s);
                          IF ((s='ICON')AND(InspectedObject IS TForm))
                            THEN ActualPropertyClass:=SearchClassByName('TICON')
                            ELSE ActualPropertyClass:=SearchClassByName(Data^.TypName^);
                          Application.LogWriteln('3 ActualProperty:' +tohex(LongWord(ActualProperty)));
                          IF ActualPropertyClass=NIL THEN goto ex;
                          Application.LogWriteln('4 ActualProperty:' +tohex(LongWord(ActualProperty)));

                          LClass:=TClass(ActualPropertyClass);
                          IF LClass IS TList THEN
                          BEGIN
                               ListClass:=TListClass(ActualPropertyClass);
                               aList:=ListClass.Create;
                               ActualProperty:=TComponent(aList);
                          END
                          ELSE IF LClass IS TStream THEN
                          BEGIN
                               StreamClass:=TStreamClass(ActualPropertyClass);
                               aStream:=StreamClass.Create;
                               ActualProperty:=TComponent(aStream);
                          END
                          ELSE
                          BEGIN
                               ActualProperty:=ActualPropertyClass.Create(InspectedObject);
                          END;
                     END;

                     ret:=CallClassPropertyEditor(ActualProperty);

                     CASE ret OF
                       peOk:
                       BEGIN
                            goto SetProp;
                       END;
                       peNoEditor:
                       BEGIN
                            IF ((not (ActualProperty IS TComponent))OR(not (csHandleLinks IN ActualProperty.ComponentState))) THEN
                            BEGIN
                                 ErrorBox(FmtLoadNLSStr(SiNoPropertyEditor,[Data^.CompName^]));
                                 IF p2^=NIL THEN ActualProperty.Destroy;
                                 IF FComboBox<>NIL THEN FComboBox.DroppedDown:=FALSE;
                            END
                            ELSE
                            BEGIN
                                 IF FComboBox<>NIL THEN
                                 BEGIN
                                     ComboText:=FComboBox.Caption;
                                     FComboBox.Clear;
                                     FComboBox.Caption:=ComboText;
                                 END;

                                 ActualPropertyClass:=ActualProperty.ClassType;
                                 IF p2^=NIL THEN ActualProperty.Destroy;  //delete temporary class
                                 ActualProperty:=NIL;

                                 IF InspectedObject IS TControl THEN
                                 BEGIN
                                      IF InspectedObject IS TForm THEN MyOwn:=InspectedObject
                                      ELSE MyOwn:=TControl(InspectedObject).Parent;
                                 END
                                 ELSE MyOwn := InspectedObject.Owner;

                                 IF (MyOwn<>NIL)AND(csReferenceControl IN MyOwn.ComponentState)
                                 THEN MyOwn := MyOwn.Owner;

                                 TempList.Create;
                                 IF MyOwn<>NIL THEN
                                 BEGIN
                                      FOR t:=0 TO MyOwn.ComponentCount-1 DO
                                      BEGIN
                                           MyComp:=MyOwn.Components[t];
                                           (* ignoriere ReferenzWindows, weil die Referenz auch in der ComponentListe steht *)
                                           IF csReferenceControl IN MyComp.ComponentState THEN continue;

                                           IF csHandleLinks IN MyComp.ComponentState THEN
                                             IF MyComp.Designed THEN
                                               IF MyComp.InheritsFrom(ActualPropertyClass)
                                                 THEN TempList.Add(MyComp);
                                      END;
                                 END;

                                 WHILE ((MyOwn<>NIL)AND(not (MyOwn IS TForm))) DO
                                 BEGIN
                                      IF MyOwn IS TControl THEN
                                      BEGIN
                                           IF not (MyOwn IS TForm) THEN
                                            MyOwn:=TControl(MyOwn).Parent;
                                      END
                                      ELSE MyOwn := MyOwn.Owner;

                                      IF MyOwn<>NIL THEN
                                      BEGIN
                                           FOR t:=0 TO MyOwn.ComponentCount-1 DO
                                           BEGIN
                                                MyComp:=MyOwn.Components[t];
                                                (* ignoriere ReferenzWindows, weil die Referenz auch in der ComponentListe steht *)
                                                IF csReferenceControl IN MyComp.ComponentState THEN continue;

                                                IF csHandleLinks IN MyComp.ComponentState THEN
                                                  IF MyComp.Designed THEN
                                                    IF MyComp.InheritsFrom(ActualPropertyClass)
                                                      THEN TempList.Add(MyComp);
                                           END;
                                      END;
                                 END;

                                 InspectedObject.UpdateLinkList(Data^.CompName^,TempList);

                                 IF FComboBox<>NIL THEN FOR t:=0 TO TempList.Count-1 DO
                                 BEGIN
                                      MyComp:=TComponent(TempList[t]);
                                      Application.LogWriteln('3 FComboBox.Items.Add:'+MyComp.Name);
                                      FComboBox.Items.Add(MyComp.Name);
                                 END;
                                 TempList.Destroy;

                                 IF FComboBox<>NIL THEN
                                   Begin
                                     Application.LogWriteln('3 FComboBox.Items.Add: <None>');
                                     FComboBox.Items.Add(LoadNLSStr(SiPropertyNone));
                                   End;
                                 goto ex;
                            END;
                       END;
                       peCancel:
                       BEGIN
                            IF p2^=NIL THEN ActualProperty.Destroy;
                            System.Move(p2^,ActualProperty,4);
                            goto setcap;
                       END;
                       peClear:
                       BEGIN
                            IF Data^.WriteTyp IN [1,2,3] THEN
                            BEGIN
                                 IF p2^=NIL THEN ActualProperty.Destroy;
                                 ActualProperty:=NIL;
                            END;
setprop:
                            Project.SCUModified := TRUE;

                            CASE Data^.WriteTyp OF
                               1,2,3:
                               BEGIN
                                  System.Move(ActualProperty,Data^.CompValue^,Data^.CompValueLen);
                                  GenWriteComponent(InspectedObject,Data^.CompValue,Data);
                               END;
                               ELSE
                               BEGIN
                                   ErrorBox(FmtLoadNLSStr(SiPropertyIsReadOnly,[Data^.CompName^]));
                                   IF p2^=NIL THEN ActualProperty.Destroy;
                                   goto ex;
                               END;
                            END;
l1:
                            Data^.Changed:=TRUE;

                            recu:=ClientRect;

                            yPos:=recu.Top-1;

                            FOR t:=UpScrolled+1 TO Selected DO dec(yPos,InspectorFontHeight+4);

                            recu.Bottom:=yPos;
                            recu.Top:=yPos+InspectorFontHeight+4;

                            Inspector.FInspectorUpdateLocked:=FALSE;
                            Inspector.UpdateInspectorDataRec(Inspector.InspectedObject,recu);
                            IF InspectedObject IS TControl THEN
                            BEGIN
                                 TControl(InspectedObject).Invalidate;
                            END;
setcap:
                            IF ActualProperty IS TStringSelectList THEN s:=TStringSelectList(ActualProperty).SelectedItem
                            ELSE IF ActualProperty<>NIL THEN s:='('+ActualProperty.ClassName+')'
                            ELSE s:=LoadNLSStr(SiPropertyNone);

                            IF FComboBox<>NIL THEN
                            BEGIN
                                 FComboBox.Caption:=s;
                                 FComboBox.DroppedDown:=FALSE;
                            END;
                       END;
                     END; {case}
                  END;
             END;
         END;
  END;
ex:
  Inspector.FInspectorUpdateLocked:=FALSE;
END;
{$HINTS ON}


{$HINTS OFF}
PROCEDURE TComponentNoteBook.EntryDblClkEvent(Sender:TObject);
VAR  Page:TComponentPage;
     Data:PComponentInterior;
     FEntry:TEdit;
     recu:TRect;
     yPos,t:LONGINT;
     rcu:TRect;
     Control:TControl;
     i:TInspector;
BEGIN
     FEntry:=TEdit(Sender);

     IF TComponent(FEntry) IS TComboBox THEN
     BEGIN
          ASM
             PUSH DWORD PTR FEntry
             CALLN32 StdCtrls.GetComboEdit
             MOV FEntry,EAX
          END;
     END;

     Page:=ActivePage;
     IF Page=NIL THEN exit;

     IF Page.Interior<>NIL THEN
     BEGIN
          recu:=ClientRect;

          yPos:=recu.Top-1;

          FOR t:=UpScrolled+1 TO Selected DO dec(yPos,InspectorFontHeight+4);

          recu.Bottom:=yPos;
          recu.Top:=yPos+InspectorFontHeight+4;

          Data:=Page.Interior.Items[Selected-1];
          IF Data<>NIL THEN
          BEGIN
//               Msg.Handled := TRUE;
               IF not (Data^.CompTyp IN [PropType_ProcVar,PropType_FuncVar]) THEN exit;
               IF FEntry.Caption<>'' THEN
               BEGIN
                    i:=TInspector(Parent);
                    Control:=TForm(i.InspectedObject);

                    //suchen Parent Form
                    WHILE not (Control IS TForm) DO
                    BEGIN
                         IF Control.Owner=NIL THEN exit;
                         Control:=TForm(Control.Owner);
                    END;
                    IF Control<>NIL THEN GenGotoProc(Control,FEntry.Caption);
                    exit;
               END;
               FEntry.Caption:=Inspector.InspectedObject.Name+Data^.CompName^;

               SetProperty(Data,FEntry.Caption,recu,FALSE);
          END;
     END;
END;
{$HINTS ON}


PROCEDURE TComponentNoteBook.WriteBackProperty(CONST Value:STRING);
VAR  Page:TComponentPage;
     Data:PComponentInterior;
     recu:TRect;
     yPos,t:LONGINT;
BEGIN
     Page := ActivePage;
     IF Page = NIL THEN exit;

     IF Page.Interior <> NIL THEN
       IF Selected > 0 THEN   {von 1..n}
         IF Selected <= Page.Interior.Count THEN
     BEGIN
          recu := ClientRect;
          yPos := recu.Top-1;

          FOR t := UpScrolled+1 TO Selected DO dec(yPos,InspectorFontHeight+4);

          recu.Bottom := yPos;
          recu.Top := yPos+InspectorFontHeight+4;

          Data := Page.Interior.Items[Selected-1];
          IF Data <> NIL THEN SetProperty(Data,Value,recu,FALSE);
     END;
END;


{$HINTS OFF}
PROCEDURE TComponentNoteBook.EntryScanEvent(Sender:TObject;VAR Keycode:TKeyCode);
VAR  Page:TComponentPage;
     Data:PComponentInterior;
     FEntry:TEdit;
     recu:TRect;
     yPos,t:LONGINT;
     s:STRING;
     ScrollCount:LONGINT;
BEGIN
     FEntry:=TEdit(Sender);
     CASE KeyCode OF
       {$IFDEF OS2}
       kbCtrlCR,
       {$ENDIF}
       kbCtrlEnter:
       BEGIN
            KeyCode := kbNull;
            DoDblClk(Selected);
       END;
       kbCtrlTab:
       BEGIN
            KeyCode := kbNull;
            IF Inspector.TabSet.TabIndex = 0 THEN Inspector.TabSet.TabIndex := 1
            ELSE Inspector.TabSet.TabIndex := 0;

            UpScrolled:=0;
            SetSliderValues;
            EnableSelect(UpScrolled+1);
            Invalidate;
       END;
       kbF12:
       BEGIN
            KeyCode := kbNull;

            IF Inspector.InspectedForm <> NIL THEN
            BEGIN
                 s := GetUnitName(Inspector.InspectedForm);
                 IF LoadEditor(s,0,0,0,0,TRUE,CursorHome,Fokus,ShowIt) = NIL
                 THEN ErrorBox(FmtLoadNLSStr(SiUnitNotFound,[s]));
            END;
       END;
       kbEsc:
       BEGIN
            KeyCode := kbNull;
            {original Property Wert in das EntryField zurckschreiben}
       END;
       {$IFDEF OS2}
       kbCR,
       {$ENDIF}
       kbEnter,kbF11:
       BEGIN
            KeyCode := kbNull;

            WriteBackProperty(FEntry.Caption);

            IF Inspector.InspectedForm <> NIL THEN
              IF Inspector.FocusFromFormular OR (KeyCode IN [kbF11])
              THEN Inspector.InspectedForm.Focus;
            Inspector.FocusFromFormular := FALSE;
       END;
       kbCDown:
       BEGIN
            KeyCode := kbNull;

            Page:=ActivePage;
            IF Page=NIL THEN exit;
            IF Selected = Page.Interior.Count THEN exit; // schon ganz unten

            IF Selected<UpScrolled+1 THEN exit;
            IF Selected<UpScrolled+FieldCount-1 THEN EnableSelect(Selected+1)
            ELSE
            BEGIN
                 //Scroll line down
                 IF UpScrolled+FieldCount>Page.Interior.Count THEN exit;

                 {DisableSelect(TRUE);}

                 inc(UpScrolled);
                 SetSliderValues;

                 EnableSelect(UpScrolled+FieldCount-1);

                 RedrawNames(TRUE,ClientRect);
                 RedrawProperties(TRUE,ClientRect);
                 Update;
            END;
       END;
       kbCUp:
       BEGIN
            KeyCode := kbNull;

            Page:=ActivePage;
            IF Page=NIL THEN exit;
            IF Selected = 1 THEN exit;  // Schon ganz oben

            IF Selected>UpScrolled+1+FieldCount THEN exit;
            IF Selected>UpScrolled+1 THEN EnableSelect(Selected-1)
            ELSE
            BEGIN
                 //Scroll line up
                 IF UpScrolled=0 THEN exit;

                 {DisableSelect(TRUE);}

                 dec(UpScrolled);
                 SetSliderValues;

                 EnableSelect(UpScrolled+1);

                 RedrawNames(TRUE,ClientRect);
                 RedrawProperties(TRUE,ClientRect);
                 Update;
            END;
       END;
       kbPageDown:
       BEGIN
            KeyCode := kbNull;

            Page:=ActivePage;
            IF Page=NIL THEN exit;

            ScrollCount := FieldCount-1;

            IF Selected < UpScrolled+1 THEN exit;   // Entryfeld ist oben raus

            //Scroll page down
            IF Selected + ScrollCount > Page.Interior.Count
            THEN ScrollCount := Page.Interior.Count - Selected;

            IF ScrollCount = 0 THEN exit;  // schon ganz unten

            inc(UpScrolled, ScrollCount);

            EnableSelect(Selected + ScrollCount);

            SetSliderValues;
            Invalidate;
(*
            IF UpScrolled+FieldCount>Page.Interior.Count THEN exit;

            {DisableSelect(TRUE);}

            IF UpScrolled+FieldCount*2<Page.Interior.Count
            THEN inc(UpScrolled,FieldCount)
            ELSE inc(UpScrolled,Page.Interior.Count-(UpScrolled+FieldCount-1));
            IF UpScrolled>Page.Interior.Count THEN UpScrolled:=Page.Interior.Count-1;
            IF UpScrolled<0 THEN UpScrolled:=0;
            SetSliderValues;

            {Invalidate;}
            EnableSelect(UpScrolled+FieldCount-1);

            Invalidate;
            {RedrawNames(TRUE,ClientRect);
            RedrawProperties(TRUE,ClientRect);}
*)
       END;
       kbPageUp:
       BEGIN
            KeyCode := kbNull;

            Page:=ActivePage;
            IF Page=NIL THEN exit;

            ScrollCount := FieldCount-1;

            IF Selected > UpScrolled+1+FieldCount THEN exit;   // EntryField unten raus

            //Scroll page up
            IF Selected - ScrollCount < 1 THEN ScrollCount := Selected - 1;

            IF ScrollCount = 0 THEN exit;  // schon ganz oben

            IF ScrollCount > UpScrolled THEN   // goto 1. Eintrag
            BEGIN
                 UpScrolled := 0;

                 EnableSelect(1);
            END
            ELSE
            BEGIN
                 dec(UpScrolled, ScrollCount);

                 EnableSelect(Selected - ScrollCount);
            END;

            SetSliderValues;
            Invalidate;
(*
            IF Selected>UpScrolled+1+FieldCount THEN exit;

            //Scroll page up
            IF UpScrolled=0 THEN exit;

            {DisableSelect(TRUE);}

            dec(UpScrolled,FieldCount);
            IF UpScrolled<0 THEN UpScrolled:=0;
            SetSliderValues;

            {Invalidate;}
            EnableSelect(UpScrolled+1);

            Invalidate;
            {RedrawNames(TRUE,ClientRect);
            RedrawProperties(TRUE,ClientRect);}
*)
       END;
       kbCtrlF1:
       BEGIN
            KeyCode := kbNull;

            Page := ActivePage;
            IF Page = NIL THEN exit;
            IF Page.Interior = NIL THEN exit;

            s := '';
            Data := Page.Interior.Items[Selected-1];
            IF Data <> NIL THEN s := Data^.CompName^;

            IF (s = '') OR not Application.HelpJump(s)
            THEN Application.HelpIndex;
       END;
     END; {case}
END;
{$HINTS ON}


{$HINTS OFF}
PROCEDURE TComponentNoteBook.EntryChanged(Sender:TObject);
VAR  Page:TComponentPage;
     Data:PComponentInterior;
     FEntry:TEdit;
     recu:TRect;
     yPos,t:LONGINT;
BEGIN
     FEntry:=TEdit(Sender);
     Page:=ActivePage;
     IF Page=NIL THEN exit;
     IF Page.Interior=NIL THEN exit;
     IF Selected <= 0 THEN exit;
     {wenn der Name einer Property zu einem ungltigen Namen verndert wird,
      wird beim CursorUp die alte Property zurckgeschrieben
      -> durch DisableSelect ist aber inzwischen Selected = 0 gesetzt worden}

     Data:=Page.Interior.Items[Selected-1];
     IF Data<>NIL THEN
       IF Data^.CompTyp IN [$84,$89] THEN  //String or CString
         IF not (Inspector.InspectedObject IS TMenuItem) THEN
           IF (Data^.CompName^='Caption') OR (Data^.CompName^='Text') THEN
           BEGIN
                recu:=ClientRect;
                yPos:=recu.Top-1;

                FOR t:=UpScrolled+1 TO Selected
                   DO dec(yPos,InspectorFontHeight+4);

                recu.Bottom:=yPos;
                recu.Top:=yPos+InspectorFontHeight+4;

                SetProperty(Data,FEntry.Text,recu,FALSE);
           END;
END;
{$HINTS ON}

PROCEDURE TComponentNoteBook.DoDblClk(Index:LONGINT);
VAR Data:PComponentInterior;
    recu:TRect;
    yPos,t:LONGINT;
    i:TInspector;
    Control:TForm;
    Page:TComponentPage;
BEGIN
     Page:=ActivePage;
     IF Page=NIL THEN exit;
     IF Page.Interior=NIL THEN exit;

     Data:=Page.Interior.Items[Index-1];

     IF Data^.CompValuesPossible<>NIL THEN
     BEGIN
          IF Data^.CanExtent THEN
          BEGIN
               IF Data^.Extended>0 THEN DisableExtent(Data,Index)
               ELSE EnableExtent(Data,Index);
          END
          ELSE SelectNext(Data,Index); {SelectNext nicht fr ... Properties}
          exit;
     END;

     EnableSelect(Index);

     recu:=ClientRect;

     yPos:=recu.Top-1;

     FOR t:=UpScrolled+1 TO Selected DO dec(yPos,InspectorFontHeight+4);

     recu.Bottom:=yPos;
     recu.Top:=yPos+InspectorFontHeight+4;

     Data:=Page.Interior.Items[Selected-1];
     IF Data<>NIL THEN
     BEGIN
          IF ((FComboBox=NIL)OR(not FComboBox.Visible)) THEN exit;

          IF not (Data^.CompTyp IN [PropType_ProcVar,PropType_FuncVar]) THEN exit;

          IF FComboBox.Caption<>'' THEN
          BEGIN
               i:=TInspector(Parent);
               Control:=TForm(i.InspectedObject);

               //suchen Parent Form
               WHILE not (Control IS TForm) DO
               BEGIN
                    IF Control.Owner=NIL THEN exit;
                    Control:=TForm(Control.Owner);
               END;
               IF Control<>NIL THEN GenGotoProc(Control,FComboBox.Caption);
               exit;
          END;

          FComboBox.Caption:=Inspector.InspectedObject.Name+Data^.CompName^;

          SetProperty(Data,FComboBox.Caption,recu,FALSE);
     END;
END;

PROCEDURE TComponentNoteBook.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR rc:TRect;
    yPos,t:LONGINT;
    Count,Found:LONGINT;
    Page:TComponentPage;
LABEL l;
BEGIN
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     IF Button <> mbLeft THEN exit;

     Page:=ActivePage;
     IF Page=NIL THEN exit;
     IF Page.Interior=NIL THEN exit;

     rc:=ClientRect;

     yPos:=rc.Top-1;
     Found:=0;
     Count:=UpScrolled+1;
     FOR t:=1 TO FieldCount-1 DO
     BEGIN
          IF Y<=yPos THEN
            IF Y>=yPos-InspectorFontHeight THEN
          BEGIN
               Found:=Count;
               goto l;
          END;

          dec(yPos,InspectorFontHeight+4);
          inc(Count);
     END;
     exit;
l:
     IF Count>Page.Interior.Count THEN exit;

     DoDblClk(Found);
END;

PROCEDURE TComponentNoteBook.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR rc:TRect;
    yPos,t:LONGINT;
    Count,Found:LONGINT;
    Page:TComponentPage;
LABEL l;
BEGIN
     Inherited MouseDown(Button,ShiftState,X,Y);

     IF Button <> mbLeft THEN exit;

     Page:=ActivePage;
     IF Page=NIL THEN exit;

     IF (Page.SizeMode=1) THEN
     BEGIN
          Page.SizeMode:=2;
          Page.SizeCX:=X;
          IF Page.SizeCX<5 THEN Page.SizeCX:=5;
          Page.OffsetCX := Page.SizeCX - Page.PropertyNameCX;
          {Entf. zw. Maus und Balken}
          Canvas.ClipRect:=ClientRect;
          Canvas.Pen.Mode:=pmNot;
          Canvas.Pen.Color:=clBlack;
          Canvas.Line(Page.SizeCX-Page.OffsetCX+4,2,
                      Page.SizeCX-Page.OffsetCX+4,Height);
          Canvas.Pen.Mode:=pmCopy;
          Cursor:=crHSplit;
          LastMsg.Handled:=TRUE;
          MouseCapture:=TRUE;
          exit;
     END;

     IF Page.Interior=NIL THEN exit;

     rc:=ClientRect;

     yPos:=rc.Top-1;
     Found:=0;
     Count:=UpScrolled+1;
     FOR t:=1 TO FieldCount-1 DO
     BEGIN
          IF Y<=yPos THEN
            IF Y>=yPos-InspectorFontHeight THEN
          BEGIN
               Found:=Count;
               goto l;
          END;

          dec(yPos,InspectorFontHeight+4);
          inc(Count);
     END;
     exit;
l:
     IF Count>Page.Interior.Count THEN exit;

     EnableSelect(Found);
END;

PROCEDURE TComponentNoteBook.MouseMove(ShiftState:TShiftState;X,Y:LONGINT);
VAR Page:TComponentPage;
BEGIN
     Inherited MouseMove(ShiftState,X,Y);

     Page:=ActivePage;

     IF ((Page<>NIL)AND(Page.SizeMode=2)) THEN
     BEGIN
          Canvas.Pen.Mode:=pmNot;
          Canvas.Pen.Color:=clBlack;
          Canvas.Line(Page.SizeCX-Page.OffsetCX+4,2,
                      Page.SizeCX-Page.OffsetCX+4,Height);
          Page.SizeCX:=X;
          IF Page.SizeCX-Page.OffsetCX<5 THEN Page.SizeCX:=5+Page.OffsetCX;
          Canvas.Line(Page.SizeCX-Page.OffsetCX+4,2,
                      Page.SizeCX-Page.OffsetCX+4,Height);
          Canvas.Pen.Mode:=pmCopy;
          Cursor:=crHSplit;
     END
     ELSE
     BEGIN
         IF ((Page<>NIL)AND(X>=Page.PropertyNameCX)AND
             (X<=Page.PropertyNameCX+6)) THEN
         BEGIN
              Cursor:=crHSplit;
              IF Page<>NIL THEN Page.SizeMode:=1;
         END
         ELSE
         BEGIN
              Cursor:=crDefault;
              IF Page<>NIL THEN Page.SizeMode:=0;
         END;
     END;
     LastMsg.Handled:=TRUE;
END;

PROCEDURE TComponentNoteBook.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINT);
VAR Page:TComponentPage;
BEGIN
     Inherited MouseUp(Button,ShiftState,X,Y);

     IF Button <> mbLeft THEN exit;

     Page:=ActivePage;
     IF ((Page<>NIL)AND(Page.SizeMode=2)) THEN
     BEGIN
          Canvas.Pen.Mode:=pmNot;
          Canvas.Pen.Color:=clBlack;
          Canvas.Line(Page.SizeCX-Page.OffsetCX+4,2,
                      Page.SizeCX-Page.OffsetCX+4,Height);
          Canvas.Pen.Mode:=pmCopy;
          Page.SizeMode:=0;
          Cursor:=crDefault;
          LastMsg.Handled:=TRUE;
          MouseCapture:=FALSE;
          Page.PropertyNameSize:=Page.SizeCX-Page.OffsetCX;
          Invalidate;

          IF Page = Inspector.Properties
          THEN IdeSettings.Inspect.PropertyNameSize := Page.PropertyNameSize
          ELSE IdeSettings.Inspect.EventNameSize := Page.PropertyNameSize;
          IdeSettings.Modified := TRUE;
     END;
END;

PROCEDURE TComponentNoteBook.SelectNext(Data:PComponentInterior;Index:LONGINT);
VAR t,Found,yPos:LONGINT;
    s,s1:STRING;
    recu:TRect;
    Value:PCompValuesPossible;
BEGIN
     Application.LogWriteln('TComponentNoteBook.SelectNext');

     IF Data^.CompTyp=PropType_Class THEN
     BEGIN
          EvComboDropDown(NIL);
          exit;
     END;

     s:=Data^.CompData^;
     UpcaseStr(s);

     Found:=-1;
     FOR t:=0 TO Data^.CompValuesPossible.Count-1 DO
     BEGIN
          Value:=Data^.CompValuesPossible.Items[t];
          s1:=Value^.Name^;
          UpcaseStr(s1);
          IF s=s1 THEN //found
          BEGIN
               IF t<Data^.CompValuesPossible.Count-1 THEN Found:=t+1
               ELSE Found:=0;
               break;
          END;
     END;

     IF Found>=0 THEN
     BEGIN
          Value:=Data^.CompValuesPossible.Items[Found];
          s:=Value^.Name^;
          IF s=MoreString THEN
          BEGIN
               Value:=Data^.CompValuesPossible.Items[0];
               s:=Value^.Name^;
          END;
          {!!}
          AssignStr(Data^.CompData,s);
          recu:=ClientRect;
          yPos:=recu.Top-1;
          FOR t:=UpScrolled+1 TO Index DO dec(yPos,InspectorFontHeight+4);
          recu.Bottom:=yPos;
          recu.Top:=yPos+InspectorFontHeight+4;
          SetProperty(Data,s,recu,TRUE);
     END;
END;

PROCEDURE TComponentNoteBook.EnableExtent(Data:PComponentInterior;Index:LONGINT);
VAR dummy,dummy1:PComponentInterior;
    value:PCompValuesPossible;
    Page:TComponentPage;
    t:LONGINT;
    b:BYTE;
    ll,ll1:LONGINT;
    pli:^LONGINT;
    pb:^BYTE;
    pw:^WORD;
    s:STRING;
BEGIN
     Page:=ActivePage;

     CASE Data^.CompValueLen OF
       1:
       BEGIN
            pb:=Data^.CompValue;
            ll:=pb^;
       END;
       2:
       BEGIN
            pw:=Data^.CompValue;
            ll:=pw^;
       END;
       4:
       BEGIN
            pli:=Data^.CompValue;
            ll:=pli^;
       END;
       ELSE ll:=0;
     END; {case}

     IF Data^.CompTyp=PropType_Class THEN
     BEGIN
          Inspector.GetClassValues(Data);

          IF Data^.ClassExtent.Count=0 THEN exit;  //No data or property is NIL

          FOR t:=0 TO Data^.ClassExtent.Count-1 DO
          BEGIN
               dummy1:=Data^.ClassExtent[t];
               dummy1^.ParentInterior:=Data;
               s:=Dummy1^.CompName^;
               AssignStr(dummy1^.CompName,'     '+s);
               Page.Interior.Insert(Index+t,dummy1);
          END;

          Data^.ClassExtent.Clear; {!!}
     END
     ELSE FOR t:=0 TO Data^.CompValuesPossible.Count-1 DO
     BEGIN
          Value:=Data^.CompValuesPossible.Items[t];
          new(dummy);

          IF Data^.CompTyp=PropType_Record THEN
          BEGIN
          END
          ELSE
          BEGIN
               CASE Value^.ValueLen OF
                  1:
                  BEGIN
                      pb:=Value^.Value;
                      ll1:=pb^;
                  END;
                  2:
                  BEGIN
                      pw:=Value^.Value;
                      ll1:=pw^;
                  END;
                  4:
                  BEGIN
                      pli:=Value^.Value;
                      ll1:=pli^;
                  END;
                  ELSE ll1:=0;
               END; {case}
          END;

          IF Data^.CompTyp=PropType_Record THEN
          BEGIN
          END
          ELSE
          BEGIN
               IF ll AND (1 SHL ll1)<>0 THEN
               BEGIN
                    dummy^.CompData := NewStr('True');
               END
               ELSE
               BEGIN
                    dummy^.CompData := NewStr('False');
               END;
          END;

          dummy^.ParentInterior:=Data;
          dummy^.CompName := NewStr('     '+Value^.Name^);
          getmem(dummy^.CompValue,Value^.ValueLen);
          System.Move(Value^.Value^,dummy^.CompValue^,Value^.ValueLen);
          dummy^.CompValueLen:=Value^.ValueLen;
          IF Data^.CompTyp=PropType_Record THEN
          BEGIN
               dummy^.CompTyp:=Value^.RecordInterior^.CompTyp;
               dummy^.CompValueLen:=Value^.RecordInterior^.CompValueLen;
               dummy^.CompValuesPossible:=Value^.RecordInterior^.CompValuesPossible;
               dummy^.CompValue:=Data^.CompValue+Value^.RecordInterior^.CompValueAdr;
               dummy^.CompValueAdr:=Value^.RecordInterior^.CompValueAdr;
               dummy^.IsRecordComponent:=TRUE;
               s:=Inspector.GetPropString(dummy,FALSE,Inspector.InspectedObject);
               dummy^.CompData := NewStr(s);
          END
          ELSE
          BEGIN  //Set
               dummy^.CompTyp:=$87;       {Boolean}
               dummy^.CompValuesPossible.Create;

               new(Value);
               fillchar(Value^,sizeof(TCompValuesPossible),0);
               AssignStr(Value^.Name,'True');
               getmem(Value^.Value,1);
               b:=1;
               System.Move(b,Value^.Value^,1);
               Value^.ValueLen:=1;
               dummy^.CompValuesPossible.Add(Value);

               new(Value);
               AssignStr(Value^.Name,'False');
               getmem(Value^.Value,1);
               b:=0;
               System.Move(b,Value^.Value^,1);
               Value^.ValueLen:=1;
               dummy^.CompValuesPossible.Add(Value);
          END;
          Page.Interior.Insert(Index+t,dummy);
     END;

     Data^.Extended:=Index;
     SetSliderValues;
     Invalidate;
END;


PROCEDURE TComponentNoteBook.DisableExtent(Data:PComponentInterior;Index:LONGINT);
VAR dummy:PComponentInterior;
    t:LONGINT;
    Page:TComponentPage;
LABEL l;
BEGIN
     Page:=ActivePage;
l:
     FOR t:=Index TO Page.Interior.Count-1 DO
     BEGIN
          dummy:=Page.Interior.Items[t];
          IF dummy^.ParentInterior=Data THEN
          BEGIN
               Page.Interior.Remove(dummy);
               DisposeEntry(dummy);
               goto l;
          END;
     END;
     Data^.Extended:=0;
     SetSliderValues;
     Invalidate;
END;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: TComponentPage Class implementation                 บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

PROCEDURE TComponentPage.GetLargestString(Canvas:TCanvas;VAR CX,CY:LONGINT);
VAR t:LONGINT;
    Data:PComponentInterior;
    s:STRING;
    X,Y:LONGINT;
BEGIN
     CX:=0;
     CY:=0;
     IF Interior=NIL THEN exit;
     FOR t:=0 TO Interior.Count-1 DO
     BEGIN
          Data:=Interior.Items[t];
          IF Data<>NIL THEN IF Data^.CompName<>NIL THEN
          BEGIN
               s:=' ';
               IF Data^.CanExtent THEN s:=s+'+';
               IF Data^.Extended>0 THEN s:=s+'-';
               s:='++'+Data^.CompName^+' ';
               Canvas.GetTextExtent(s,X,Y);
               IF X>CX THEN CX:=X;
               IF Y>CY THEN CY:=Y;
          END;
     END;

     IF PropertyNameSize>0 THEN CX:=PropertyNameSize;
     PropertyNameCX:=CX;
END;

PROCEDURE SetInspData(Component:TComponent);
BEGIN
     IF Inspector<>NIL THEN Inspector.SetInspectorData(Component);
END;



BEGIN
     SetInspectorDataProc := SetInspData;
     InitInspectorProc := @InitInspector;
END.

{ -- date -- -- from -- -- changes ----------------------------------------------
  05-Jul-04  WD         Umbau der MultiMedia-Komponenten
  17-Mar-09  WD         Einbau der Komponente "tCheckGroup"
}
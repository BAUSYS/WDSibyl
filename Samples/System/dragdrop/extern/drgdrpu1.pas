Unit DrgDrpU1;

//Sibyl Drag & Drop example
//This example demonstrates drag 'n drop between two different applications.
//For this purpose a shared memory object is used that transfers data
//between the processes.

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, Dialogs, Buttons;

Type
  TDragDropForm = Class (TForm)
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    BitBtn1: TBitBtn;
    Procedure BitBtn1OnClick (Sender: TObject);
    Procedure ListBox1OnEndDrag (Sender: TObject; Target: TObject; X: LongInt;
                                 Y: LongInt);
    Procedure ListBox1OnDragDrop (Sender: TObject; Source: TObject; X: LongInt;
                                  Y: LongInt);
    Procedure ListBox1OnDragOver (Sender: TObject; Source: TObject; X: LongInt;
                                  Y: LongInt; State: TDragState; Var Accept: Boolean);
    Procedure ListBox1OnCanDrag (Sender: TObject; X: LongInt; Y: LongInt;
                                 Var Accept: Boolean);
    Procedure ListBox1OnStartDrag (Sender: TObject;Var DragData: TDragDropData);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  DragDropForm: TDragDropForm;

Implementation

//Name of the shared memory object
Const
    SharedMemName='DragDrop_ItemsInfo';

//Drag source identification
Const
    DragSourceId='Sibyl DragDrop Demo';

//information structure for drag/drop
Type
    TDragDropItem=Record
                        Len:Byte;         //length of string
                        Data:Array[0..0] Of Char;
                  End;

    PDragDropInfo=^TDragDropInfo;
    TDragDropInfo=Record
                        Count:LongWord;   //Count of elements
                        Items:Array[0..0] Of TDragDropItem;
                  End;

Procedure TDragDropForm.BitBtn1OnClick (Sender: TObject);
Var s:String;
Begin
   //Display an input box to add an item
   If InputQuery('Add an item','Type string to add:',s) Then
      ListBox1.Items.Add(s);
End;

Procedure TDragDropForm.ListBox1OnEndDrag (Sender: TObject; Target: TObject;
                                           X: LongInt; Y: LongInt);
Var t:LongInt;
Begin
    //Look if the items were dropped successfully...
    If Target Is TExternalDragDropObject Then
    Begin
       //remove the items dragged
       For t:=ListBox1.Items.Count-1 DownTo 0 Do
         If ListBox1.Selected[t] Then ListBox1.Items.Delete(t);
    End;

    //each process must free the shared memory !!
    FreeNamedSharedMem(SharedMemName);
End;

Procedure TDragDropForm.ListBox1OnDragDrop (Sender: TObject; Source: TObject;
                                            X: LongInt; Y: LongInt);
Var SharedMem:PDragDropInfo;
    t:Longint;
    Temp:^String;
Begin
    //Look if the target is valid for us...
    If ((Source Is TExternalDragDropObject)And
        (TExternalDragDropObject(Source).SourceWindow<>ListBox1.Handle)And
        (TExternalDragDropObject(Source).SourceType=drtString)And
        (TExternalDragDropObject(Source).SourceString=DragSourceId)) Then
    Begin  //accepted
       If not AccessNamedSharedMem(TExternalDragDropObject(Source).SourceFileName,
                                   SharedMem) Then exit;  //some error

       Temp:=@SharedMem^.Items;
       For t:=1 To SharedMem^.Count Do
       Begin
          ListBox1.Items.Add(Temp^);
          inc(Temp,length(Temp^)+1); //next item
       End;

       //each process must free the shared memory !!
       FreeNamedSharedMem(TExternalDragDropObject(Source).SourceFileName);
    End;
End;

Procedure TDragDropForm.ListBox1OnDragOver (Sender: TObject; Source: TObject;
                                            X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
Begin
    //Look if we can accept the target
    Accept:=((Source Is TExternalDragDropObject)And
             (TExternalDragDropObject(Source).SourceWindow<>ListBox1.Handle)And
             (TExternalDragDropObject(Source).SourceType=drtString)And
             (TExternalDragDropObject(Source).SourceString=DragSourceId));
End;

Procedure TDragDropForm.ListBox1OnCanDrag (Sender: TObject; X: LongInt;
                                           Y: LongInt; Var Accept: Boolean);
Begin
   //Look if dragging is allowed
   Accept:=ListBox1.SelCount>0;
End;

Procedure TDragDropForm.ListBox1OnStartDrag (Sender: TObject;
                                             Var DragData: TDragDropData);
Var t:Longint;
    MemLen:LongWord;
    SharedMem:PDragDropInfo;
    Temp:^String;
Begin
   //Look how much memory we need
   MemLen:=Sizeof(TDragDropInfo)-sizeof(TDragDropItem);
   For t:=0 To ListBox1.Items.Count-1 Do
    If ListBox1.Selected[t] Then inc(MemLen,length(ListBox1.Items[t])+1);

   //allocate the memory. We need shared memory because we want to give
   //the information to another process
   //free the shared memory
   GetNamedSharedMem(SharedMemName,SharedMem,MemLen);

   SharedMem^.Count:=0;
   Temp:=@SharedMem^.Items;  //start of variable information
   For t:=0 To ListBox1.Items.Count-1 Do
     If ListBox1.Selected[t] Then
     Begin
          Inc(SharedMem^.Count);
          Temp^:=ListBox1.Items[t];
          inc(Temp,length(Temp^)+1);  //next entry
     End;

   //Fill up the DragData structure
   DragData.SourceWindow := Handle;
   DragData.SourceType := drtString;
   DragData.SourceString:=DragSourceId;
   DragData.RenderType := drmSibyl;
   DragData.ContainerName := '';
   DragData.SourceFileName := SharedMemName;
   DragData.TargetFileName := '';
   DragData.SupportedOps := [doMoveable];
   DragData.DragOperation := doMove;
End;

Initialization
  RegisterClasses ([TDragDropForm, TLabel, TListBox, TBitBtn]);
End.

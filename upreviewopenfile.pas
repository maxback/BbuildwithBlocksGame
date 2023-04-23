unit uPreviewOpenFile;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Buttons, dos, LCLType, uAbstractDrawer, uCanvasDrawer, IniFiles,
  uBlockColection;

const
  C_SUBFOLDER_WORLDS = '\data\users\default\worlds\';

type

  { TfrmPreviewOpenFile }

  TfrmPreviewOpenFile = class(TForm)
    btnCancel: TBitBtn;
    btnOpen: TBitBtn;
    edtFilter: TEdit;
    gbPreview: TGroupBox;
    GroupBox2: TGroupBox;
    imageTargetPlace1hand: TImage;
    lblFilter: TLabel;
    lvWorlds: TListView;
    pvPreview: TPaintBox;
    Panel1: TPanel;
    tbZoom: TTrackBar;
    tmFilter: TTimer;
    tmPreview: TTimer;
    procedure edtFilterKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvWorldsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure tbZoomChange(Sender: TObject);
    procedure tmFilterTimer(Sender: TObject);

    function addPicture(const sFileName: string; testDuplication: boolean): integer;
    procedure tmPreviewTimer(Sender: TObject);
    //procedure addImageBlockToImageList(filepath: string; aList:TImageList);
  private
    FoCurrentLoadingFile: TIniFile;
    FoCurrentBlockNameDictionary: TStringList;

    FoMainDrawer: TAbstractDrawer;
    FoDrawer: TCanvasDrawer;

    procedure ApplyFilter(const filter: string);

    procedure PerformPreview;
    procedure ClearPreview;
  public
    FsName: string;
    class function Execute(const value: TAbstractDrawer; var sName: string): boolean;

    procedure setMainDrawer(const value: TAbstractDrawer);


  end;

var
  frmPreviewOpenFile: TfrmPreviewOpenFile;

implementation

{$R *.lfm}

{ TfrmPreviewOpenFile }

procedure TfrmPreviewOpenFile.FormCreate(Sender: TObject);
begin
  FoDrawer := TCanvasDrawer.Create(nil);
  FoDrawer.setCanvas(pvPreview.Canvas);
  ApplyFilter('*');
end;

procedure TfrmPreviewOpenFile.edtFilterKeyPress(Sender: TObject; var Key: char);
begin
  tmFilter.Enabled:=false;
  tmFilter.Enabled:=true;
end;

procedure TfrmPreviewOpenFile.FormDestroy(Sender: TObject);
begin
  FoDrawer.FoCurrentPlaceBlockCollection.Free;
  FoDrawer.Free;
end;

procedure TfrmPreviewOpenFile.lvWorldsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  ClearPreview;

  FsName := '';
  if not Assigned(lvWorlds.Selected) then
    exit;

  FsName := lvWorlds.Selected.Caption;
  tmPreview.Enabled:=true;
end;

procedure TfrmPreviewOpenFile.tbZoomChange(Sender: TObject);
begin
  ClearPreview;

  FoDrawer.Zoom := tbZoom.Position;

  tmPreview.Enabled:=true;
end;

procedure TfrmPreviewOpenFile.tmFilterTimer(Sender: TObject);
begin
  ApplyFilter(edtFilter.Text);
  if lvWorlds.CanFocus then
    lvWorlds.SetFocus;
  tmFilter.Enabled:=false;
end;

function TfrmPreviewOpenFile.addPicture(const sFileName: string;
  testDuplication: boolean): integer;
var
  i: integer;
begin
  if testDuplication then
  begin
    for i := Low(FoDrawer.FBlockSourceFileNames) to High(FoDrawer.FBlockSourceFileNames) do
    begin
      if FoDrawer.FBlockSourceFileNames[i] = sFileName then
        exit(i);
    end;
  end;
  SetLength(FoDrawer.FBlockSourceFileNames, Length(FoDrawer.FBlockSourceFileNames) + 1);
  i := High(FoDrawer.FBlockSourceFileNames);
  FoDrawer.FBlockSourceFileNames[i] := sFileName;
  //addImageBlockToImageList(FoDrawer.FBlockSourceFileNames[i], ImageListBlocksMenu);
  //addImageBlockToImageList(FoDrawer.FBlockSourceFileNames[i], inventoryImageList);

  //mmCmd.Lines.Add('log: block filie loaded: ' + FoDrawer.FBlockSourceFileNames[i] + ' in index ' + IntToStr(i));

  exit(i);
end;

procedure TfrmPreviewOpenFile.tmPreviewTimer(Sender: TObject);
begin
  tmPreview.Enabled:=false;
  PerformPreview;
end;

{
procedure TfrmPreviewOpenFile.addImageBlockToImageList(filepath: string;
  aList: TImageList);
var
  mImage:   TPicture;
  mBitmap:  TBitmap;
Begin
  if aList<>NIl then
  begin
    if FileExists(filepath,true) then
    begin
      mImage:=TPicture.Create;
      try

        (* Attempt to load image file *)
        try
          mImage.LoadFromFile(filepath);
        except
          on exception do;
        end;

        (* image successfully loaded? *)
        if (mImage.Width>0)
        and (mImage.Height>0) then
        begin
          (* Draw image to a bitmap *)
          mBitmap:=TBitmap.Create;
          try
            (* copy pixels + transparency info to bitmap *)
            mBitmap.Assign(mImage.Graphic);
            aList.add(mBitmap,NIL);
          finally
            mBitmap.Free;
          end;
        end;
      finally
        mImage.Free;
      end;
    end;
  end;
end;
}

procedure TfrmPreviewOpenFile.ApplyFilter(const filter: string);
var
  folder: string;
  SearchResult  : SearchRec;
  Attribute     : Word;
  s: string;
begin
  lvWorlds.Clear;

  folder := ExtractFilePath(Application.ExeName) + '\data\users\default\worlds\';

  Attribute := archive;
  s := filter;
  if (Pos('*', filter) <= 0) and (Pos('?', filter) <= 0) then
    s := '*' + s + '*';


  FindFirst (folder + s + '.World.ini', Attribute, SearchResult);
  while (DosError = 0) do
  begin
    lvWorlds.AddItem(SearchResult.Name, nil);
    FindNext(SearchResult);
  end;
  FindClose(SearchResult);

  ClearPreview;

  FsName := '';
  if not Assigned(lvWorlds.Selected) then
    exit;

  FsName := lvWorlds.Selected.Caption;
end;

procedure TfrmPreviewOpenFile.PerformPreview;
var
  sName, sImageName, sObject: string;
  i, x, y, z, index, imageIndex, blockCount, objectCount: integer;
  sl: TStringList;
begin

  sName := ExtractFilePath(Application.ExeName) + C_SUBFOLDER_WORLDS + FsName;

  if not FileExists(sName) then
    raise Exception.CreateFmt('File not exists: %s', [sName]);

  FoCurrentLoadingFile := TIniFile.Create(sName);
  FoCurrentBlockNameDictionary := TStringList.Create;
  sl := TStringList.Create;
  try
    blockCount :=
      FoCurrentLoadingFile.ReadInteger('count', 'block',
        FoCurrentBlockNameDictionary.Count);

    for i := 0 to blockCount - 1 do
    begin
      sImageName := FoCurrentLoadingFile.ReadString('block', IntToStr(i), '');
      if sImageName = '' then
        continue;
      imageIndex := addPicture(sImageName, true);
      FoCurrentBlockNameDictionary.Values[IntToStr(i)] := IntToStr(imageIndex);
    end;

    objectCount := FoCurrentLoadingFile.ReadInteger('count', 'object', 0);
    for i := 0 to objectCount - 1 do
    begin

      sObject := FoCurrentLoadingFile.ReadString('object', IntToStr(i), '');
      if sObject = '' then
        continue;
      sl.CommaText := sObject;
      if (sl[0] = 'v0') and (sl.Count >= 5) then
      begin
        x := StrToIntDef(sl[1], 0);
        y := StrToIntDef(sl[2], 0);
        z := StrToIntDef(sl[3], 0);
        index := StrToIntDef(sl[4], 0);

        imageIndex := StrToIntDef(FoCurrentBlockNameDictionary.Values[IntToStr(index)], 0);
        FoDrawer.FnSelectedBlockIndex := imageIndex;
        try
          FoDrawer.FnCurrentPlacePositionX := x;
          FoDrawer.FnCurrentPlacePositionY := y;
          FoDrawer.FnCurrentPlacePositionZ := z;

          FoDrawer.putNewBlock(imageTargetPlace1hand);
        except
          on E:Exception do
            Caption := 'Error on preview: ' + E.Message;
        end;
      end;

    end;
  finally
    sl.Free;
    FoCurrentBlockNameDictionary.Free;
    FoCurrentLoadingFile.Free;
  end;

end;

procedure TfrmPreviewOpenFile.ClearPreview;
begin
  if Assigned(FoDrawer.FoCurrentPlaceBlockCollection) then
    FoDrawer.FoCurrentPlaceBlockCollection.deleteAll(nil, true);

  pvPreview.Canvas.Brush.Color := clWhite;
  pvPreview.Canvas.Rectangle(1,1,pvPreview.Width,pvPreview.Height);
end;

class function TfrmPreviewOpenFile.Execute(const value: TAbstractDrawer;
  var sName: string): boolean;
begin
  Application.CreateForm(TfrmPreviewOpenFile, frmPreviewOpenFile);
  frmPreviewOpenFile.setMainDrawer(value);
  frmPreviewOpenFile.ShowModal;
  Result := frmPreviewOpenFile.ModalResult = mrOK;
  if result then
    sName := frmPreviewOpenFile.FsName;

  frmPreviewOpenFile.Free;

end;

procedure TfrmPreviewOpenFile.setMainDrawer(const value: TAbstractDrawer);
begin
  FoMainDrawer := value;

  with FoDrawer do
  begin
    loadBlockSourceFileNamesFrom(FoMainDrawer.FBlockSourceFilenames);
    FoCurrentPlaceBlockCollection := TBlockColection.create;//FoMainDrawer.FoCurrentPlaceBlockCollection;

    setSelectedBlockIndex(-1);
    FoCurrentPlaceImageTarget := FoMainDrawer.FoCurrentPlaceImageTarget;

    //FControlPlace1 := FoMainDrawer.FControlPlace1; //precisa??
    CurrentPlacePositionX := 0;
    CurrentPlacePositionY := 0;
    CurrentPlacePositionZ := 0;
    FnCurrentPlacePositionXMax := 0;
    FnCurrentPlacePositionYMax := 0;

    FnCurrentPlacePositionXMax := 1000;

    FnCurrentPlacePositionYMax := 1000;

    FnCurrentPlaceOffsetX := 0; //FoCurrentPlaceTabSeet.Width -
  //    (FnCurrentPlacePositionXMax * 40);

    FnCurrentPlaceOffsetY := 0; //FoCurrentPlaceTabSeet.Height -
  //    (FnCurrentPlacePositionYMax * 40);

    FnCurrentPlacePositionXMax := FnCurrentPlacePositionXMax - 1;
    FnCurrentPlacePositionYMax := FnCurrentPlacePositionYMax - 1;
  end;

end;

end.


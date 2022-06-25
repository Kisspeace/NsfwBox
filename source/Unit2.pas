//♡2022 by Kisspeace. https://github.com/kisspeace
unit unit2;

interface
uses
  SysUtils, Types, System.UITypes, Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  Fmx.Scroller, System.Threading, System.Generics.Collections, Net.HttpClient,
  Net.HttpClientComponent, Fmx.Layouts, NsfwXxx.Types, Fmx.ActnList, FMX.Memo,
  // Alcinoe
  AlFmxGraphics, AlFmxObjects,
  // NsfwBox
  NsfwBoxInterfaces, NsfwBoxContentScraper, NsfwBoxOriginPseudo,
  NsfwBoxOriginNsfwXxx, NsfwBoxGraphics, NsfwBoxOriginConst,
  NsfwBoxGraphics.Rectangle, NsfwBoxOriginR34App, NsfwBoxOriginR34JsonApi,
  NsfwBoxStyling, NsfwBoxOriginBookmarks, NsfwBoxHelper;

type

  TNBoxSelectMenu = class(TVertScrollBox)
    private
      FSelected: NativeInt;
      FSelectedBtn: TRectButton;
      FOnSelect: TNotifyEvent;
      procedure SetSelected(const value: NativeInt); virtual;
      {$IFDEF MSWINDOWS}
      procedure ClickTapRef(Sender: TObject);
      {$ENDIF}
      procedure BtnOnTap(Sender: TObject; const Point: TPointF); virtual;
    public
      property SelectedBtn: TRectButton read FSelectedBtn;
      property Selected: NativeInt read FSelected write SetSelected;
      property OnSelected: TNotifyEvent read FOnSelect write FOnSelect;
      {}
      function AddBtn(AText: string;
       AId: NativeInt = 0;
       AImageFilename: string = '';
       AShortImageName: boolean = false
      ): TRectButton; virtual;
      {}
      procedure ClearButtons;
      constructor Create(AOwner: TComponent);
      destructor Destroy; override;
  end;

  TNBoxOriginSetMenu = class(TNBoxSelectMenu)
    public
      BtnOriginNsfwXxx: TRectButton;
      BtnOriginR34App: TRectButton;
      BtnOriginR34JsonApi: TRectButton;
      BtnOriginPseudo: TRectButton;
      BtnOriginBookmarks: TRectButton;
      constructor Create(AOwner: TComponent);
      destructor Destroy; override;
  end;

  TNBoxCheckMenu = class(TVertScrollBox)
    private
      FCheckList: TList<TNBoxCheckButton>;
      procedure SetChecked(const value: TArray<NativeInt>);
      function GetChecked: TArray<NativeInt>;
    public
      property Checked: TArray<NativeInt> read GetChecked write SetChecked;
      function AddCheck(AText: string; AId: NativeInt): TNBoxCheckButton;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

  TNBoxSearchSubMenuBase = class(TLayout)
    public
      procedure DoAutoSize; virtual;
  end;

  TNBoxSearchMenu = Class(TLayout)
    private
      procedure OnOriginChanged(Sender: TObject);
      procedure OnNsfwXxxSortChanged(Sender: TObject);
      procedure OnNsfwXxxSearchTypeChanged(Sender: TObject);
      procedure BtnSelectMenuOnTap(Sender: TObject; const Point: TPointF);
      procedure SetRequest(const value: INBoxSearchRequest);
      function GetRequest: INBoxSearchRequest;
      procedure HideMenus;
      procedure HideOriginMenus;
      procedure ShowMainMenu;
    public
      OriginSetMenu: TNBoxOriginSetMenu;
      NsfwXxxSortMenu: TNBoxSelectMenu;
      NsfwXxxSearchTypeMenu: TNBoxSelectMenu;
      //-------------------//
      MainMenu: TVertScrollBox;
        EditRequest: TNBoxEdit;
        TopLayout: TLayout;
          BtnChangeOrigin: TRectButton;
          EditPageId: TNBoxEdit;
        NsfwXxxMenu: TNBoxSearchSubMenuBase;
          CheckGrid: TMultiLayout;
          BtnChangeSort: TRectButton;
          BtnChangeUrlType: TRectButton;
          CheckGallery,
          CheckImage,
          CheckVideo,
          CheckStraight,
          CheckTrans,
          CheckCartoons,
          CheckGay
          : TNBoxCheckButton;
      property Request: INBoxSearchRequest read GetRequest write SetRequest;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  End;

  TNBoxSettingsCheck = class(TAlRectangle, IIsChecked)
    private
      function GetIsChecked: Boolean; virtual;
      procedure SetIsChecked(const Value: Boolean); virtual;
      function IsCheckedStored: Boolean;
    public
      Check: TNBoxCheckButton;
      Text: TAlText;
      property IsChecked: Boolean read GetIsChecked write SetIsChecked;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

  TNBoxSettingsEdit = class(TNBoxSettingsCheck)
    public
      Edit: TNBoxEdit;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

  TNBoxMemo = class(TAlRectangle)
    public
      Memo: TMemo;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

implementation
uses Unit1;

{ TNBoxOriginSetMenu }

constructor TNBoxOriginSetMenu.Create(AOwner: TComponent);

  function NewBtn(AText: string; AOrigin: integer): TRectButton;
  begin
    Result := AddBtn(AText, AOrigin, Form1.AppStyle.GetImagePath(AOrigin));
  end;

begin
  inherited;
  FSelected := ORIGIN_NSFWXXX;
  BtnOriginNsfwxxx    := NewBtn(OriginToStr(ORIGIN_NSFWXXX), ORIGIN_NSFWXXX);
  BtnOriginR34App     := NewBtn(OriginToStr(ORIGIN_R34APP), ORIGIN_R34APP);
  BtnOriginR34JsonApi := NewBtn(OriginToStr(ORIGIN_R34JSONAPI), ORIGIN_R34JSONAPI);
  BtnOriginBookmarks  := NewBtn(OriginToStr(ORIGIN_BOOKMARKS), ORIGIN_BOOKMARKS);
  BtnOriginPseudo     := NewBtn(OriginToStr(ORIGIN_PSEUDO), ORIGIN_PSEUDO);
end;

destructor TNBoxOriginSetMenu.Destroy;
begin
  BtnOriginNsfwxxx.Free;
  BtnOriginR34App.Free;
  BtnOriginR34JsonApi.free;
  BtnOriginPseudo.Free;
  inherited;
end;

{ TNBoxSearchSubMenuBase }

procedure TNBoxSearchSubMenuBase.DoAutoSize;
var
  I: integer;
  Y, MaxY: single;
  Control: TControl;
begin
  MaxY := 0;
  for I := 0 to Self.Controls.Count - 1 do begin
    Y := Controls.Items[I].Position.Y;
    if ( Y > MaxY ) then begin
      MaxY := Y;
      Control := Controls.Items[I];
    end;
  end;

  Size.Height := MaxY + Control.Height;

end;

{ TNBoxSearchMenu }

procedure TNBoxSearchMenu.BtnSelectMenuOnTap(Sender: TObject;
  const Point: TPointF);
var
  Btn, Control: TControl;
begin
  Btn := TControl(Sender);
  Control := TControl(Btn.TagObject);
  HideMenus;
  Control.Visible := true;
end;

constructor TNBoxSearchMenu.Create(AOwner: TComponent);
var
  M: TRectF;
  IconPath: string;

  procedure BeBottom(AControl, AControlOnTop: TControl);
  begin
    AControl.Position.Y := AControlOnTop.Position.Y + 1;
  end;

  function NewCheck(AImageName, AText: string; AParent: TFmxObject = nil): TNBoxCheckButton;
  begin
    Result := Form1.CreateDefCheckButton(Self);
    with Result do begin
      Image.FileName := Form1.AppStyle.GetImagePath(AImageName);
      Text.Text := AText;
      IsChecked := true;
      Margins.Bottom := M.Top / 2;
    end;
    if not Assigned(AParent) then
      CheckGrid.AddControl(Result)
    else
      Result.Parent := AParent;
  end;

begin
  inherited;
  M := TRectF.Create(10, 10, 10, 0);

  OriginSetMenu := TNBoxOriginSetMenu.Create(Self);
  with OriginSetMenu do begin
    Parent := Self;
    Visible := false;
    Align := TAlignlayout.Client;
    OnSelected := Self.OnOriginChanged;
  end;

  MainMenu := TVertScrollBox.Create(self);
  With MainMenu do begin
    Parent := self;
    Align := TAlignLayout.Client;

    EditRequest := Form1.CreateDefEdit(Self);
    with EditRequest do begin
      Parent := MainMenu;
      Align := TAlignLayout.MostTop;
      Margins.Rect := M;
      Edit.TextPrompt := 'Request / tags / categories';
    end;

    TopLayout := TLayout.Create(Self);
    with TopLayout do begin
      Parent := MainMenu;
      Align := TAlignLayout.MostTop;
      Position.Y := EditRequest.Height + 100;
      Margins.Rect := M;

      BtnChangeOrigin := form1.CreateDefButton(Self, BTN_STYLE_DEF2);
      With BtnChangeOrigin do begin
        Parent := TopLayout;
        Align := TAlignlayout.Client;
        Margins.Right := M.Right;
        Text.Text := 'Change content provider';
        TagObject := OriginSetMenu; // linking button with menu
        OnTap := BtnSelectMenuOnTap;
      end;

      EditPageId := Form1.CreateDefEdit(Self);
      with EditPageId do begin
        Parent := TopLayout;
        Align := TAlignlayout.Right;
        Edit.TextSettings.HorzAlign := TTextAlign.Center;
        Edit.FilterChar := '1234567890';
        Edit.Text := '1';
        Edit.KeyboardType := TVirtualKeyboardType.NumberPad;
      end;

      Height := BtnChangeOrigin.Height;
    end;

    IconPath :=  Form1.AppStyle.GetImagePath(ICON_TAG);

    NsfwXxxSortMenu := TNBoxSelectMenu.Create(self);
    with NsfwXxxSortMenu do begin
      parent := Self;
      visible := false;
      Align := TAlignlayout.Client;

      Addbtn('Newest', Ord(Newest), IconPath);
      Addbtn('Popular', Ord(Popular), IconPath);
      Addbtn('Recommended', Ord(Recommended), IconPath);
      OnSelected := OnNsfwXxxSortChanged;
    end;

    NsfwXxxSearchTypeMenu:= TNBoxSelectMenu.Create(self);
    with NsfwXxxSearchTypeMenu do begin
      parent := Self;
      visible := false;
      Align := TAlignlayout.Client;

      Addbtn('Text request', Ord(TNsfwUrlType.Default), IconPath);
      Addbtn('User name', Ord(TNsfwUrlType.User), IconPath);
      Addbtn('Category', Ord(TNsfwUrlType.Category), IconPath);
      Addbtn('Related posts', Ord(TNsfwUrlType.Related), IconPath);
      OnSelected := OnNsfwXxxSearchTypeChanged;
    end;

    NsfwXxxMenu := TNBoxSearchSubMenuBase.Create(Self);
    with NsfwXxxMenu do begin
      Parent := mainmenu;
      Align := TAlignlayout.Top;
      Visible := false;

      CheckGallery  := NewCheck(ICON_IMAGE, 'Gallery (set of images)', NsfwXxxMenu);
      with CheckGallery do begin
        Align := TAlignlayout.Top;
        Margins.Rect := M;
      end;

      CheckGrid := TMultiLayout.Create(NsfwXxxMenu);
      with CheckGrid do begin
        Parent := NsfwXxxMenu;
        Align := TAlignLayout.Top;
        BeBottom(CheckGrid, CheckGallery);

        Margins.Rect := M;
        LayoutIndent := M.Top / 2;
        Margins.Left := LayoutIndent;
        Margins.Right := Margins.Left;
        Margins.Top := LayoutIndent;
        BlockCount := 2;

        CheckImage    := NewCheck(ICON_IMAGE, 'Image');
        CheckVideo    := NewCheck(ICON_VIDEO, 'Video');
        CheckStraight := NewCheck(ICON_STRAIGHT, 'Straight');
        CheckTrans    := NewCheck(ICON_TRANS, 'Transgender');
        CheckCartoons := NewCheck(ICON_CARTOONS, 'Cartoons');
        CheckGay      := NewCheck(ICON_GAY, 'Gay');

        ReCalcBlocksSize;
      end;

      BtnChangeSort := form1.CreateDefButton(Self, BTN_STYLE_DEF2);
      With BtnChangeSort do begin
        Parent := NsfwXxxMenu;
        Align := TAlignlayout.top;
        BeBottom(BtnChangeSort, CheckGrid);
        Margins.Rect := M;
        Text.Text := 'Change sort';
        TagObject := NsfwXxxSortMenu; // linking button with menu
        OnTap := BtnSelectMenuOnTap;
        Image.FileName := IconPath;
      end;

      BtnChangeUrlType := form1.CreateDefButton(Self, BTN_STYLE_DEF2);
      With BtnChangeUrlType do begin
        Parent := NsfwXxxMenu;
        Align := TAlignlayout.top;
        BeBottom(BtnChangeUrlType, BtnChangeSort);
        Margins.Rect := M;
        Text.Text := 'Change search type';
        TagObject := NsfwXxxSearchTypeMenu; // linking button with menu
        OnTap := BtnSelectMenuOnTap;
        Image.FileName := IconPath;
      end;

      DoAutoSize;
    end;

  end;

  Self.NsfwXxxSortMenu.Selected := Ord(Recommended);
  Self.NsfwXxxSearchTypeMenu.Selected := Ord(TNsfwUrlType.Default);

end;

destructor TNBoxSearchMenu.Destroy;
begin
  OriginSetMenu.Free;
  BtnChangeOrigin.Free;
  EditRequest.Free;
  EditPageId.Free;
  MainMenu.Free;
  inherited;
end;

function TNBoxSearchMenu.GetRequest: INBoxSearchRequest;
var
  O, tmp: Integer;
begin
  O := OriginSetMenu.Selected;

  if O = ORIGIN_NSFWXXX then begin

    Result := TNBoxSearchReqNsfwXxx.Create;
    with Result as TNBoxSearchReqNsfwXxx do begin

      var LTypes: TNsfwItemTypes := [];
      var LOris: TNsfwOris := [];

      if CheckGallery.IsChecked then
        include(LTypes, Gallery);
      if CheckImage.IsChecked then
        include(LTypes, Image);
      if CheckVideo.IsChecked then
        include(LTypes, Video);

      if CheckGay.IsChecked then
        include(LOris, Gay);
      if CheckTrans.IsChecked then
        include(LOris, Shemale);
      if CheckCartoons.IsChecked then
        include(LOris, Cartoons);
      if CheckStraight.IsChecked then
        include(LOris, Straight);

      Oris := LOris;
      Types := LTypes;
      SortType := TNsfwSort(NsfwXxxSortMenu.Selected);
      SearchType := TNsfwUrlType(NsfwXxxSearchTypeMenu.Selected);
    end;

  end else if (O = ORIGIN_R34APP) then begin
    Result := TNBoxSearchReqR34app.Create;
  end else if O = ORIGIN_R34JsonApi then begin
    Result := TNBoxSearchReqR34JsonApi.Create;
  end else if O = ORIGIN_PSEUDO then begin
    Result := TNBoxSearchReqPseudo.Create;
  end else if O = ORIGIN_BOOKMARKS then begin
    Result := TNBoxSearchReqBookmarks.Create;
  end;

  with Result do begin
    Request := EditRequest.Edit.Text;
    if TryStrToInt(EditPageId.Edit.Text, tmp) then
      Pageid := tmp;
  end;
end;

procedure TNBoxSearchMenu.HideMenus;
begin
  MainMenu.Visible := false;
  OriginSetMenu.Visible := false;
  NsfwXxxSortMenu.Visible := false;
  NsfwXxxSearchTypeMenu.Visible := false;
end;

procedure TNBoxSearchMenu.HideOriginMenus;
begin
  NsfwXxxMenu.Visible := false;
end;

procedure TNBoxSearchMenu.OnNsfwXxxSearchTypeChanged(Sender: TObject);
var
  SelectedType: TNsfwUrlType;
begin
  ShowMainMenu;
  SelectedType := TNsfwUrlType(Self.NsfwXxxSearchTypeMenu.Selected);
  case SelectedType of
    TNsfwUrlType.Default: BtnChangeUrlType.Text.Text := 'Text request';
    User:                 BtnChangeUrlType.Text.Text := 'User name';
    Category:             BtnChangeUrlType.Text.Text := 'Category';
    Related:              BtnChangeUrlType.Text.Text := 'Related posts';
  end;
end;

procedure TNBoxSearchMenu.OnNsfwXxxSortChanged(Sender: TObject);
var
  SelectedSort: TNsfwSort;
begin
  ShowMainMenu;
  SelectedSort := TNsfwSort(NsfwXxxSortMenu.Selected);
  case SelectedSort of
    Newest:      BtnChangeSort.Text.Text := 'Newest';
    Popular:     BtnChangeSort.Text.Text := 'Popular';
    Recommended: BtnChangeSort.Text.Text := 'Recommended';
  end;
end;

procedure TNBoxSearchMenu.OnOriginChanged(Sender: TObject);
begin
  BtnChangeOrigin.Image.FileName := form1.AppStyle.GetImagePath(OriginSetMenu.Selected);
  BtnChangeOrigin.Text.Text := '( ' + OriginToStr(OriginSetMenu.Selected) + ' ) Change content provider';
  OriginSetMenu.Visible := false;
  MainMenu.Visible := true;
  self.HideOriginMenus;
  if OriginSetMenu.Selected = ORIGIN_NSFWXXX then
    NsfwXxxMenu.Visible := true;
end;

procedure TNBoxSearchMenu.SetRequest(const value: INBoxSearchRequest);
begin
  OriginSetMenu.Selected := Value.Origin;
  EditRequest.Edit.Text := Value.Request;
  EditPageId.Edit.Text := Value.PageId.ToString;

  if Value is TNBoxSearchReqNsfwXxx then begin
    with Value as TNBoxSearchReqNsfwXxx do begin
      NsfwXxxSortMenu.Selected := Ord(SortType);
      NsfwXxxSearchTypeMenu.Selected := Ord(SearchType);
      CheckImage.IsChecked := ( Image in Types);
      CheckVideo.IsChecked := ( Video in Types);
      CheckGay.IsChecked   := ( Gay in Oris );
      CheckTrans.IsChecked := ( Shemale in Oris);
      CheckStraight.IsChecked := ( Straight in Oris );
      CheckCartoons.IsChecked := ( Cartoons in Oris );
    end;
  end;
end;

procedure TNBoxSearchMenu.ShowMainMenu;
begin
  HideMenus;
  MainMenu.Visible := true;
end;

{ TNBoxSelectMenu }

function TNBoxSelectMenu.AddBtn(AText: string; AId: NativeInt = 0;
  AImageFilename: string = ''; AShortImageName: boolean = false): TRectButton;
begin
  Result := form1.CreateDefButton(Self);
  with Result do begin
    Parent := Self;
    Align := TAlignLayout.Top;
    Position.Y := 0;
    Text.Text := AText;

    if AShortImageName then
      Image.FileName := Form1.AppStyle.GetImagePath(AImageFilename)
    else
      Image.FileName := AImageFilename;

    Tag := AId;
    OnTap := self.BtnOnTap;
    {$IFDEF MSWINDOWS}
    OnClick := Self.ClickTapRef;
    {$ENDIF}
  end;
end;

procedure TNBoxSelectMenu.BtnOnTap(Sender: TObject; const Point: TPointF);
begin
  FSelectedBtn := (Sender As TRectButton);
  Selected := TFmxObject(Sender).Tag;
end;

procedure TNBoxSelectMenu.ClearButtons;
var
  I: integer;
  C: TControl;
begin
  I := 0;
  for I := 0 to Self.Content.Controls.Count - 1 do begin
    C := Self.Content.Controls[0];
    if (C is TRectButton) then begin
      C.Free;
    end;
  end;
end;

{$IFDEF MSWINDOWS}
procedure TNBoxSelectMenu.ClickTapRef(Sender: TObject);
begin
  //log('lasagma');
  with Sender as TControl do begin
    Ontap(Sender, TPointF.Create(0, 0));
  end;
end;
{$ENDIF}

constructor TNBoxSelectMenu.Create(AOwner: TComponent);
begin
  inherited;
  FSelectedBtn := nil;
end;

destructor TNBoxSelectMenu.Destroy;
begin
  inherited;
end;

procedure TNBoxSelectMenu.SetSelected(const value: NativeInt);
begin
  FSelected := value;
  if Assigned(OnSelected) then
    OnSelected(self);
end;

{ TNBoxSettingsCheck }

constructor TNBoxSettingsCheck.Create(AOwner: TComponent);
begin
  inherited;

  Check := form1.CreateDefCheckButton(self, BTN_STYLE_DEF2);
  with Check do begin
    Parent := self;
    Align := TAlignlayout.MostTop;
    Text.TextSettings.HorzAlign := TTextAlign.Leading;
  end;

  Text := TAlText.Create(Self);
  with Text do begin
    Parent := self;
    Align := TAlignlayout.Client;
    Visible := true;
  end;

end;

destructor TNBoxSettingsCheck.Destroy;
begin
  Check.Free;
  Text.Free;
  inherited;
end;

function TNBoxSettingsCheck.GetIsChecked: Boolean;
begin
  Result := Check.IsChecked;
end;

function TNBoxSettingsCheck.IsCheckedStored: Boolean;
begin
  Result := true;
end;

procedure TNBoxSettingsCheck.SetIsChecked(const Value: Boolean);
begin
  Check.IsChecked := Value;
end;

{ TNBoxSettingsEdit }

constructor TNBoxSettingsEdit.Create(AOwner: TComponent);
begin
  inherited;

  Edit := Form1.CreateDefEdit(self, 0);
  with Edit do begin
    Parent := self;
    Align := TAlignLayout.Top;
  end;
end;

destructor TNBoxSettingsEdit.Destroy;
begin
  Edit.Free;
  inherited;
end;

{ TNBoxCheckMenu }

function TNBoxCheckMenu.AddCheck(AText: string;
  AId: NativeInt): TNBoxCheckButton;
begin
  Result := form1.CreateDefCheckButton(Self);
  with Result do begin
    Parent := Self;
    Align := TAlignlayout.Top;
    Position.Y := Single.MaxValue;
    Margins.Rect := TRectF.Create(6, 6, 6, 0);
    Text.Text := AText;
    Tag := AId;
  end;
  FCheckList.Add(Result);
end;

constructor TNBoxCheckMenu.Create(AOwner: TComponent);
begin
  inherited;
  FCheckList := TList<TNBoxCheckButton>.Create;
end;

destructor TNBoxCheckMenu.Destroy;
begin
  FCheckList.Free;
  inherited;
end;

function TNBoxCheckMenu.GetChecked: TArray<NativeInt>;
var
  I: integer;
begin
  Result :=[];
  for I := 0 to FCheckList.Count - 1 do begin
    if FCheckList.Items[I].IsChecked then
      Result := Result + [FCheckList.Items[I].Tag];
  end;
end;

procedure TNBoxCheckMenu.SetChecked(const value: TArray<NativeInt>);
var
  I, N: integer;
  Check: TNBoxCheckButton;
begin
  for I := 0 to FCheckList.Count - 1 do begin
    Check := FCheckList.Items[I];
    Check.IsChecked := false;
    for N := low(Value) to High(Value) do begin
      if Check.Tag = value[N] then begin
        Check.IsChecked := true;
        break;
      end;
    end;
  end;
end;

{ TNBoxMemo }

constructor TNBoxMemo.Create(AOwner: TComponent);
begin
  inherited;
  Memo := TMemo.Create(Self);
  with Memo do begin
    Parent := self;
    Memo.StyledSettings := [];
    Align := TAlignLayout.Client;
    Margins.Rect := TRectF.Create(6, 6, 6, 6);
  end;
end;

destructor TNBoxMemo.Destroy;
begin
  Memo.Free;
  inherited;
end;

end.

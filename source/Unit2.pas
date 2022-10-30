//♡2022 by Kisspeace. https://github.com/kisspeace
unit unit2;

interface
uses
  SysUtils, Types, System.UITypes, Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.ColumnsView, System.Threading, System.Generics.Collections, Net.HttpClient,
  Net.HttpClientComponent, Fmx.Layouts, NsfwXxx.Types, Fmx.ActnList, FMX.Memo,
  NetHttp.R34AppApi,
  // Alcinoe
  AlFmxGraphics, AlFmxObjects,
  // NsfwBox
  NsfwBoxInterfaces, NsfwBoxContentScraper, NsfwBoxOriginPseudo,
  NsfwBoxOriginNsfwXxx, NsfwBoxGraphics, NsfwBoxOriginConst,
  NsfwBoxGraphics.Rectangle, NsfwBoxOriginR34App, NsfwBoxOriginR34JsonApi,
  NsfwBoxOriginGivemepornClub, NsfwBoxStyling, NsfwBoxOriginBookmarks,
  NsfwBoxHelper, CoomerParty.Scraper, NsfwBoxOriginCoomerParty,
  NsfwBoxOriginRandomizer;

type

  TNBoxSelectMenu = class(TVertScrollBox)
    private
      FSelected: NativeInt;
      FSelectedStr: string;
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
      property SelectedStr: string read FSelectedStr;
      property OnSelected: TNotifyEvent read FOnSelect write FOnSelect;
      {}
      function AddBtn(AText: string;
       AId: NativeInt = 0;
       AImageFilename: string = '';
       AShortImageName: boolean = false
      ): TRectButton; overload; virtual;
      {}
      function AddBtnStr(AText: string;
       ATagStr: string = '';
       AImageFilename: string = '';
       AShortImageName: boolean = false
      ): TRectButton; overload; virtual;
      {}
      procedure ClearButtons;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

  TTNBoxSelectMenuList = TList<TNBoxSelectMenu>;

  TNBoxOriginSetMenu = class(TNBoxSelectMenu)
    public
      BtnOriginNsfwXxx: TRectButton;
      BtnOriginR34App: TRectButton;
      BtnOriginR34JsonApi: TRectButton;
      BtnOriginGivemepornClub: TRectButton;
      BtnOrigin9Hentaito: TRectButton;
      BtnOriginPseudo: TRectButton;
      BtnOriginBookmarks: TRectButton;
      BtnOriginCoomerParty: TRectButton;
      BtnOriginRandomizer: TRectButton;
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
    private
      procedure OnResizeEvent(Sender: TObject);
    public
      procedure DoAutoSize; virtual;
  end;

  TNBoxSearchSubMenuBaseList = TList<TNBoxSearchSubMenuBase>;

  TNBoxSearchMenu = Class(TLayout)
    private
      FSelectMenus: TTNBoxSelectMenuList;
      FProviderMenus: TNBoxSearchSubMenuBaseList;
      procedure OnOriginChanged(Sender: TObject);
      procedure OnNsfwXxxSortChanged(Sender: TObject);
      procedure OnNsfwXxxSearchTypeChanged(Sender: TObject);
      procedure OnNsfwXxxHostChanged(Sender: TObject);
      procedure OnGmpClubSearchTypeChanged(Sender: TObject);
      procedure OnR34AppBooruChanged(Sender: TObject);
      procedure OnCoomerPartyHostChanged(Sender: TObject);
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
      NsfwXxxHostChangeMenu: TNBoxSelectMenu;
      R34AppBooruChangeMenu: TNBoxSelectMenu;
      GmpClubSearchTypeMenu: TNBoxSelectMenu;
      CoomerPartyHostChangeMenu: TNBoxSelectMenu;
      //-------------------//
      MainMenu: TVertScrollBox;
        EditRequest: TNBoxEdit;
        TopLayout: TLayout;
          BtnChangeOrigin: TRectButton;
          EditPageId: TNBoxEdit;
        NsfwXxxMenu: TNBoxSearchSubMenuBase;
          CheckGrid: TColumnsLayout;
          BtnChangeSort: TRectButton;
          BtnChangeUrlType: TRectButton;
          BtnChangeSite: TRectButton;
          CheckGallery,
          CheckImage,
          CheckVideo,
          CheckStraight,
          CheckTrans,
          CheckCartoons,
          CheckGay
          : TNBoxCheckButton;
        GmpClubMenu: TNBoxSearchSubMenuBase;
          BtnGmpChangeSearchType: TRectButton;
        R34AppMenu: TNBoxSearchSubMenuBase;
          BtnR34AppChangeBooru: TRectButton;
        CoomerPartyMenu: TNBoxSearchSubMenuBase;
          EditCoomerPartyHost,
          EditCoomerPartyUserId,
          EditCoomerPartyService
          : TNBoxEdit;
          BtnCoomerPartyChangeSite: TRectButton;
        BookmarksMenu: TNBoxSearchSubMenuBase;
          EditBookmarksPath: TNBoxEdit;
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

  function NewBtn(AOrigin: integer): TRectButton;
  begin
    Result := AddBtn(OriginToStr(AOrigin), AOrigin, Form1.AppStyle.GetImagePath(AOrigin));
  end;


begin
  inherited;
  FSelected := ORIGIN_NSFWXXX;
  BtnOriginNsfwxxx    := NewBtn(ORIGIN_NSFWXXX);
  BtnOriginR34App     := NewBtn(ORIGIN_R34APP);
  BtnOriginR34JsonApi := NewBtn(ORIGIN_R34JSONAPI);
  BtnOriginGivemepornClub := NewBtn(ORIGIN_GIVEMEPORNCLUB);
  BtnOriginBookmarks  := NewBtn(ORIGIN_BOOKMARKS);
  BtnOriginPseudo     := NewBtn(ORIGIN_PSEUDO);
  BtnOrigin9Hentaito  := NewBtn(ORIGIN_9HENTAITO);
  BtnOriginCoomerParty := NewBtn(ORIGIN_COOMERPARTY);
  BtnOriginRandomizer  := NewBtn(ORIGIN_RANDOMIZER);
end;

destructor TNBoxOriginSetMenu.Destroy;
begin
  BtnOriginNsfwxxx.Free;
  BtnOriginR34App.Free;
  BtnOriginR34JsonApi.Free;
  BtnOriginGivemepornClub.Free;
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
//  Size.Height := Self.ChildrenRect.height;
end;

procedure TNBoxSearchSubMenuBase.OnResizeEvent(Sender: TObject);
begin
  Self.DoAutoSize;
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
  I: integer;
  M: TRectF;
  IconPath: string;

  procedure BeBottom(AControl, AControlOnTop: TControl);
  begin
    AControl.Position.Y := AControlOnTop.Position.Y + 1 + AControlOnTop.Height;
  end;

  function NewCheck(AImageName, AText: string; AParent: TFmxObject = nil): TNBoxCheckButton;
  begin
    Result := Form1.CreateDefCheckButton(Self);
    with Result do begin
      Image.ImageURL := Form1.AppStyle.GetImagePath(AImageName);
      Text.Text := AText;
      IsChecked := true;
      Margins.Bottom := M.Top / 2;
    end;
    if not Assigned(AParent) then
      Result.Parent := CheckGrid
    else
      Result.Parent := AParent;
  end;

  function NewSelectMenu: TNBoxSelectMenu;
  begin
    Result := TNBoxSelectMenu.Create(Self);
    with Result do begin
      Parent := Self;
      Visible := false;
      Align := TAlignlayout.Client;
    end;
    FSelectMenus.Add(Result);
  end;

  function NewProviderMenu: TNBoxSearchSubMenuBase;
  begin
    Result := TNBoxSearchSubMenuBase.Create(Self);
    with Result do begin
      Parent := MainMenu;
      Align := TAlignLayout.Top;
      Visible := false;
    end;
    FProviderMenus.Add(Result);
  end;

begin
  inherited;
  FSelectMenus := TTNBoxSelectMenuList.Create;
  FProviderMenus := TNBoxSearchSubMenuBaseList.Create;

  M := TRectF.Create(10, 10, 10, 0);

  OriginSetMenu := TNBoxOriginSetMenu.Create(Self);
  with OriginSetMenu do begin
    Parent := Self;
    Visible := false;
    Align := TAlignlayout.Client;
    OnSelected := Self.OnOriginChanged;
  end;
  FSelectMenus.Add(OriginSetMenu);

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

    NsfwXxxSortMenu := NewSelectMenu;
    with NsfwXxxSortMenu do begin
      Addbtn('Newest', Ord(Newest), IconPath);
      Addbtn('Popular', Ord(Popular), IconPath);
      Addbtn('Recommended', Ord(Recommended), IconPath);
      OnSelected := OnNsfwXxxSortChanged;
    end;

    NsfwXxxSearchTypeMenu := NewSelectMenu;
    with NsfwXxxSearchTypeMenu do begin
      Addbtn('Text request', Ord(TNsfwUrlType.Default), IconPath);
      Addbtn('User name', Ord(TNsfwUrlType.User), IconPath);
      Addbtn('Category', Ord(TNsfwUrlType.Category), IconPath);
      Addbtn('Related posts', Ord(TNsfwUrlType.Related), IconPath);
      OnSelected := OnNsfwXxxSearchTypeChanged;
    end;

    GmpClubSearchTypeMenu := NewSelectMenu;
    with GmpClubSearchTypeMenu do begin
      Addbtn('Default navigate', Ord(TGmpclubSearchType.Empty), IconPath);
      Addbtn('Search by tag', Ord(TGmpclubSearchType.Tag), IconPath);
      Addbtn('Search by category', Ord(TGmpclubSearchType.Category), IconPath);
      Addbtn('Random content', Ord(TGmpclubSearchType.Random), IconPath);
      OnSelected := OnGmpClubSearchTypeChanged;
    end;

    NsfwXxxHostChangeMenu := NewSelectMenu;
    with NsfwXxxHostChangeMenu do begin
      Addbtn('nsfw.xxx', Ord(TNsfwXxxSite.NsfwXxx), IconPath);
      Addbtn('pornpic.xxx', Ord(TNsfwXxxSite.PornpicXxx), IconPath);
      Addbtn('hdporn.pics', Ord(TNsfwXxxSite.HdpornPics), IconPath);
      OnSelected := OnNsfwXxxHostChanged;
      //Addbtn('', Ord(), IconPath);
    end;

    R34AppBooruChangeMenu := NewSelectMenu;
    with R34AppBooruChangeMenu do begin
      for I := 0 to Ord(TR34AppFreeBooru.e926net) do
        Addbtn(BooruToLink(TR34AppFreeBooru(I)), I, IconPath);
      OnSelected := Self.OnR34AppBooruChanged;
    end;

    CoomerPartyHostChangeMenu := NewSelectMenu;
    with CoomerPartyHostChangeMenu do begin
      AddBtnStr('coomer.party', URL_COOMER_PARTY, IconPath);
      AddBtnStr('kemono.party', URL_KEMONO_PARTY, IconPath);
      OnSelected := OnCoomerPartyHostChanged;
    end;

    R34AppMenu := NewProviderMenu;
    with R34AppMenu do begin
      BtnR34AppChangeBooru := form1.CreateDefButton(Self, BTN_STYLE_DEF2);
      With BtnR34AppChangeBooru do begin
        Parent := R34AppMenu;
        Align := TAlignlayout.top;
        Margins.Rect := M;
        Text.Text := 'Change booru';
        TagObject := Self.R34AppBooruChangeMenu; // linking button with menu
        OnTap := BtnSelectMenuOnTap;
        Image.ImageURL := IconPath;
      end;

    end;

    BookmarksMenu := NewProviderMenu;
    With BookmarksMenu do begin
      EditBookmarksPath := Form1.CreateDefEdit(Self);
      with EditBookmarksPath do begin
        Parent := BookmarksMenu;
        Align := TAlignlayout.Top;
        Margins.Rect := M;
        Edit.Text := '<BOOKMARKS>';
        Edit.TextPrompt := 'Bookmarks data base path';
      end;
    end;

    NsfwXxxMenu := NewProviderMenu;
    with NsfwXxxMenu do begin
      CheckGallery  := NewCheck(ICON_IMAGE, 'Gallery (set of images)', NsfwXxxMenu);
      with CheckGallery do begin
        Align := TAlignlayout.Top;
        Margins.Rect := M;
      end;

      CheckGrid := TColumnsLayout.Create(NsfwXxxMenu);
      with CheckGrid do begin
        Parent := NsfwXxxMenu;
        Align := TAlignLayout.Top;
        BeBottom(CheckGrid, CheckGallery);

        Margins.Rect := M;
        ItemsIndent := TPointF.Create(M.Top / 2, M.Top / 2);
        Margins.Left := ItemsIndent.X;
        Margins.Right := Margins.Left;
        Margins.Top := ItemsIndent.Y;
        ColumnsCount := 2;

        CheckImage    := NewCheck(ICON_IMAGE, 'Image');
        CheckVideo    := NewCheck(ICON_VIDEO, 'Video');
        CheckStraight := NewCheck(ICON_STRAIGHT, 'Straight');
        CheckTrans    := NewCheck(ICON_TRANS, 'Transgender');
        CheckCartoons := NewCheck(ICON_CARTOONS, 'Cartoons');
        CheckGay      := NewCheck(ICON_GAY, 'Gay');

        AutoSize := TRUE;
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
        Image.ImageURL := IconPath;
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
        Image.ImageURL := IconPath;
      end;

      BtnChangeSite := form1.CreateDefButton(Self, BTN_STYLE_DEF2);
      with BtnChangeSite do begin
        Parent := NsfwXxxMenu;
        Align := TAlignlayout.top;
        BeBottom(BtnChangeSite, BtnChangeUrlType);
        Margins.Rect := M;
        Text.Text := 'Change site';
        TagObject := Self.NsfwXxxHostChangeMenu; // linking button with menu
        OnTap := BtnSelectMenuOnTap;
        Image.ImageURL := IconPath;
      end;

      OnResize := OnResizeEvent;
    end;

    GmpClubMenu := NewProviderMenu;
    with GmpClubMenu do begin

      BtnGmpChangeSearchType := form1.CreateDefButton(Self, BTN_STYLE_DEF2);
      With BtnGmpChangeSearchType do begin
        Parent := GmpClubMenu;
        Align := TAlignlayout.top;
        Margins.Rect := M;
        Text.Text := 'Change search type';
        TagObject := GmpClubSearchTypeMenu; // linking button with menu
        OnTap := BtnSelectMenuOnTap;
        Image.ImageURL := IconPath;
      end;

    end;

    CoomerPartyMenu := NewProviderMenu;
    with CoomerPartyMenu do begin

      EditCoomerPartyHost := Form1.CreateDefEdit(Self);
      with EditCoomerPartyHost do begin
        Parent := CoomerPartyMenu;
        Align := TAlignlayout.Top;
        Margins.Rect := M;
        Edit.Text := URL_COOMER_PARTY;
        Edit.TextPrompt := 'Host URL';
      end;

      BtnCoomerPartyChangeSite := form1.CreateDefButton(Self, BTN_STYLE_DEF2);
      With BtnCoomerPartyChangeSite do begin
        Parent := CoomerPartyMenu;
        Align := TAlignlayout.top;
        Margins.Rect := M;
        Text.Text := 'Change host URL';
        TagObject := CoomerPartyHostChangeMenu; // linking button with menu
        OnTap := BtnSelectMenuOnTap;
        Image.ImageURL := IconPath;
      end;
      BeBottom(BtnCoomerPartyChangeSite, EditCoomerPartyHost);

      EditCoomerPartyUserId := Form1.CreateDefEdit(Self);
      with EditCoomerPartyUserId do begin
        Parent := CoomerPartyMenu;
        Align := TAlignlayout.Top;
        Margins.Rect := M;
        Edit.Text := '';
        Edit.TextPrompt := 'Artist Id';
      end;
      BeBottom(EditCoomerPartyUserId, BtnCoomerPartyChangeSite);

      EditCoomerPartyService := Form1.CreateDefEdit(Self);
      with EditCoomerPartyService do begin
        Parent := CoomerPartyMenu;
        Align := TAlignlayout.Top;
        Margins.Rect := M;
        Edit.Text := '';
        Edit.TextPrompt := 'Service name ( onlyfans, patreon, .. )';
      end;
      BeBottom(EditCoomerPartyService, EditCoomerPartyUserId);

    end;
  end;

//  Self.NsfwXxxSortMenu.Selected := Ord(Newest);
//  Self.NsfwXxxSearchTypeMenu.Selected := Ord(TNsfwUrlType.Default);
//  Self.GmpClubSearchTypeMenu.Selected := Ord(TGmpclubSearchType.Empty);
//  Self.NsfwXxxHostChangeMenu.Selected := Ord(TNsfwXxxSite.NsfwXxx);
//  Self.R34AppBooruChangeMenu.Selected := Ord(TR34AppFreeBooru.rule34xxx);
end;

destructor TNBoxSearchMenu.Destroy;
begin
  OriginSetMenu.Free;
  BtnChangeOrigin.Free;
  EditRequest.Free;
  EditPageId.Free;
  MainMenu.Free;
  FSelectMenus.Free;
  FProviderMenus.Free;
  inherited;
end;

function TNBoxSearchMenu.GetRequest: INBoxSearchRequest;
var
  O, tmp: Integer;
begin
  O := OriginSetMenu.Selected;
  Result := CreateReqByOrigin(O);

  case O of

    ORIGIN_NSFWXXX: begin
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
        Site := TNsfwXxxSite(NsfwXxxHostChangeMenu.Selected);
      end;
    end;

    ORIGIN_R34APP: begin
      With ( Result as TNBoxSearchReqR34App ) do begin
        Booru := TR34AppFreeBooru(Self.R34AppBooruChangeMenu.Selected);
      end;
    end;

    ORIGIN_GIVEMEPORNCLUB: begin
      with ( Result as TNBoxSearchReqGmpClub ) do begin
        SearchType := TGmpClubSearchType(GmpClubSearchTypeMenu.Selected);
      end;
    end;

    ORIGIN_COOMERPARTY: begin
      with ( Result as TNBoxSearchReqCoomerParty ) do begin
        Site := Self.EditCoomerPartyHost.Edit.Text;
        Service := Self.EditCoomerPartyService.Edit.Text;
        UserId := Self.EditCoomerPartyUserId.Edit.Text;
      end;
    end;

    ORIGIN_BOOKMARKS: begin
      with ( Result as TNBoxSearchReqBookmarks ) do begin
        Path := self.EditBookmarksPath.Edit.Text;
      end;
    end

  end;

  with Result do begin

    Request := EditRequest.Edit.Text;

    if TryStrToInt(EditPageId.Edit.Text, tmp) then
      PageId := tmp;

  end;
end;

procedure TNBoxSearchMenu.HideMenus;
var
  I: integer;
begin
  MainMenu.Visible := false;
  for I := 0 to FSelectMenus.Count - 1 do
    FSelectMenus[I].Visible := False;
end;

procedure TNBoxSearchMenu.HideOriginMenus;
var
  I: integer;
begin
  for I := 0 to FProviderMenus.Count - 1 do
    FProviderMenus[I].Visible := False;
end;

procedure TNBoxSearchMenu.OnCoomerPartyHostChanged(Sender: TObject);
begin
  ShowMainMenu;
  Self.EditCoomerPartyHost.Edit.Text := CoomerPartyHostChangeMenu.SelectedStr;
end;

procedure TNBoxSearchMenu.OnGmpClubSearchTypeChanged(Sender: TObject);
var
  Selected: TGmpClubSearchType;
begin
  ShowMainMenu;
  Selected := TGmpclubSearchType(Self.GmpClubSearchTypeMenu.Selected);
  case Selected of
    TGmpclubSearchType.Empty:    BtnGmpChangeSearchType.Text.Text := 'Default navigate';
    TGmpclubSearchType.Tag:      BtnGmpChangeSearchType.Text.Text := 'Search by tag';
    TGmpclubSearchType.Category: BtnGmpChangeSearchType.Text.Text := 'Search by category';
    TGmpclubSearchType.Random:   BtnGmpChangeSearchType.Text.Text := 'Random content';
  end;
end;

procedure TNBoxSearchMenu.OnNsfwXxxHostChanged(Sender: TObject);
var
  Selected: TNsfwXxxSite;
begin
  ShowMainMenu;
  Selected := TNsfwXxxSite(NsfwXxxHostChangeMenu.Selected);
  BtnChangeSite.Text.Text := TNsfwXxxSiteToUrl(Selected);
end;

procedure TNBoxSearchMenu.OnNsfwXxxSearchTypeChanged(Sender: TObject);
var
  SelectedType: TNsfwUrlType;
begin
  ShowMainMenu;
  SelectedType := TNsfwUrlType(Self.NsfwXxxSearchTypeMenu.Selected);
  case SelectedType of
    TNsfwUrlType.Default:  BtnChangeUrlType.Text.Text := 'Text request';
    TNsfwUrlType.User:     BtnChangeUrlType.Text.Text := 'User name';
    TNsfwUrlType.Category: BtnChangeUrlType.Text.Text := 'Category';
    TNsfwUrlType.Related:  BtnChangeUrlType.Text.Text := 'Related posts';
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
  BtnChangeOrigin.Image.ImageURL := form1.AppStyle.GetImagePath(OriginSetMenu.Selected);
  BtnChangeOrigin.Text.Text := '( ' + OriginToStr(OriginSetMenu.Selected) + ' ) Change content provider';
  self.HideMenus;
  //OriginSetMenu.Visible := False;
  MainMenu.Visible := True;
  self.HideOriginMenus;

  if OriginSetMenu.Selected = ORIGIN_NSFWXXX then
    NsfwXxxMenu.Visible := True
  else if ( OriginSetMenu.Selected = ORIGIN_GIVEMEPORNCLUB ) then
    GmpClubMenu.Visible := True
  else if ( OriginSetMenu.Selected = ORIGIN_R34APP ) then
    R34AppMenu.Visible := True
  else if ( OriginSetMenu.Selected = ORIGIN_COOMERPARTY ) then
    CoomerPartyMenu.Visible := True
  else if ( OriginSetMenu.Selected = ORIGIN_BOOKMARKS ) then
    BookmarksMenu.Visible := True;
end;

procedure TNBoxSearchMenu.OnR34AppBooruChanged(Sender: TObject);
var
  Selected: TR34AppFreeBooru;
begin
  ShowMainMenu;
  Selected := TR34AppFreeBooru(R34AppBooruChangeMenu.Selected);
  BtnR34AppChangeBooru.Text.Text := BooruToLink(Selected);
end;

procedure TNBoxSearchMenu.SetRequest(const value: INBoxSearchRequest);
begin
  OriginSetMenu.Selected := Value.Origin;
  EditRequest.Edit.Text := Value.Request;
  EditPageId.Edit.Text := Value.PageId.ToString;

  if ( Value is TNBoxSearchReqNsfwXxx ) then begin

    with ( Value as TNBoxSearchReqNsfwXxx ) do begin
      NsfwXxxSortMenu.Selected := Ord(SortType);
      NsfwXxxSearchTypeMenu.Selected := Ord(SearchType);
      NsfwXxxHostChangeMenu.Selected := Ord(Site);
      CheckImage.IsChecked := ( Image in Types);
      CheckVideo.IsChecked := ( Video in Types);
      CheckGay.IsChecked   := ( Gay in Oris );
      CheckTrans.IsChecked := ( Shemale in Oris);
      CheckStraight.IsChecked := ( Straight in Oris );
      CheckCartoons.IsChecked := ( Cartoons in Oris );
    end;

  end else if ( Value is TNBoxSearchReqGmpClub ) then begin

    with ( Value as TNBoxSearchReqGmpClub ) do begin
      GmpClubSearchTypeMenu.Selected := Ord(SearchType);
    end;

  end else if ( Value is TNBoxSearchReqR34App ) then begin

    With ( Value as TNBoxSearchReqR34App ) do begin
      Self.R34AppBooruChangeMenu.Selected := Ord(Booru);
    end;

  end else if ( Value is TNBoxSearchReqCoomerParty ) then begin

    with ( Value as TNBoxSearchReqCoomerParty ) do begin
      Self.EditCoomerPartyHost.Edit.Text := Site;
      Self.EditCoomerPartyUserId.Edit.Text := UserId;
      Self.EditCoomerPartyService.Edit.Text := Service;
    end;

  end else if ( Value is TNBoxSearchReqBookmarks ) then begin

    with ( Value as TNBoxSearchReqBookmarks ) do
      self.EditBookmarksPath.Edit.Text := Path;

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
      Image.ImageURL := Form1.AppStyle.GetImagePath(AImageFilename)
    else
      Image.ImageURL := AImageFilename;

    Tag := AId;
    OnTap := self.BtnOnTap;
    {$IFDEF MSWINDOWS}
    OnClick := Self.ClickTapRef;
    {$ENDIF}
  end;
end;

function TNBoxSelectMenu.AddBtnStr(AText: string; ATagStr,
  AImageFilename: string; AShortImageName: boolean): TRectButton;
begin
  Result := Self.AddBtn(AText, 0, AImageFilename, AShortImageName);
  Result.TagString := ATagStr;
end;

procedure TNBoxSelectMenu.BtnOnTap(Sender: TObject; const Point: TPointF);
begin
  FSelectedBtn := (Sender As TRectButton);
  FSelectedStr := TFmxObject(Sender).TagString;

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
var
  I: integer;
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

{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit unit2;

interface
uses
  SysUtils, Types, System.UITypes, Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.ColumnsView, System.Threading, System.Generics.Collections, Net.HttpClient,
  Net.HttpClientComponent, Fmx.Layouts, NsfwXxx.Types, Fmx.ActnList, FMX.Memo,
  NetHttp.R34AppApi,
  { Alcinoe }
  Alcinoe.FMX.Objects, Alcinoe.FMX.Graphics,
  { NsfwBox }
  NsfwBox.Interfaces, NsfwBox.ContentScraper, NsfwBox.Provider.Pseudo,
  NsfwBox.Provider.NsfwXxx, NsfwBox.Graphics, NsfwBox.Consts,
  NsfwBox.Graphics.Rectangle, NsfwBox.Provider.R34App, NsfwBox.Provider.R34JsonApi,
  NsfwBox.Provider.GivemepornClub, NsfwBox.Styling, NsfwBox.Provider.Bookmarks,
  NsfwBox.Helper, CoomerParty.Scraper, NsfwBox.Provider.CoomerParty,
  NsfwBox.Provider.Randomizer, NsfwBox.Provider.motherless, Motherless.types,
  Fapello.Types, NsfwBox.Provider.Fapello,
  NsfwBox.Provider.BepisDb, BooruScraper.Client.BepisDb;

type

  TNBoxSelectMenu = class(TVertScrollBox)
    private
      FSelected: NativeInt;
      FSelectedStr: string;
      FSelectedBtn: TRectButton;
      FOnSelect: TNotifyEvent;
      FDontChangeCurrentBtn: boolean;
      procedure SetSelected(const value: NativeInt); virtual;
      {$IFDEF MSWINDOWS}
      procedure ClickTapRef(Sender: TObject);
      {$ENDIF}
      procedure BtnOnTap(Sender: TObject; const Point: TPointF); virtual;
      function BtnIndexByIntTag(AId: NativeInt): integer;
    public
      function GetBtnByTag(AId: NativeInt): TRectButton;
      property SelectedBtn: TRectButton read FSelectedBtn;
      property Selected: NativeInt read FSelected write SetSelected;
      property SelectedStr: string read FSelectedStr;
      property OnSelected: TNotifyEvent read FOnSelect write FOnSelect;
      {}
      function AddBtn(ABtnClass: TRectButtonClass; AText: string): TRectButton; overload;
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
      constructor Create(AOwner: TComponent); override;
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
      procedure OnMotherlessMediaChanged(Sender: TObject);
      procedure OnMotherlessSortChanged(Sender: TObject);
      procedure OnMotherlessUploadDateChanged(Sender: TObject);
      procedure OnMotherlessMediaSizeChanged(Sender: TObject);
      procedure OnFapelloSearchTypeChanged(Sender: TObject);
      procedure DefaultSelectMenuOnChanged(Sender: TObject);
      procedure BtnSelectMenuOnTap(Sender: TObject; const Point: TPointF);
      procedure SetRequest(const value: INBoxSearchRequest);
      function GetRequest: INBoxSearchRequest;
      procedure HideMenus;
      procedure HideOriginMenus;
      procedure ShowMainMenu;
    public
      OriginSetMenu: TNBoxOriginSetMenu;
      NsfwXxxSortMenu,
      NsfwXxxSearchTypeMenu,
      NsfwXxxHostChangeMenu,
      R34AppBooruChangeMenu,
      GmpClubSearchTypeMenu,
      CoomerPartyHostChangeMenu,
      MotherlessSortChangeMenu,
      MotherlessMediaChangeMenu,
      MotherlessUploadDateChangeMenu,
      MotherlessMediaSizeChangeMenu,
      FapelloSearchTypeMenu,
      BepisDbSubjectMenu,
      BepisDbOrderByMenu,
      BepisDbKKGenderMenu,
      BepisDbKKPersonalityMenu,
      BepisDbKKGameTypeMenu
      : TNBoxSelectMenu;
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
          CheckGay,
          CheckBizarre
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
        MotherlessMenu: TNBoxSearchSubMenuBase;
          BtnMotherlessChangeSort: TRectButton;
          BtnMotherlessChangeMedia: TRectButton;
          BtnMotherlessChangeUploadDate: TRectButton;
          BtnMotherlessChangeMediaSize: TRectButton;
        BookmarksMenu: TNBoxSearchSubMenuBase;
          EditBookmarksPath: TNBoxEdit;
        FapelloMenu: TNBoxSearchSubMenuBase;
          BtnFapelloChangeSearchType: TRectButton;
        RandomizerMenu: TNBoxSearchSubMenuBase;
          BtnRandNsfwXxx: TNBoxCheckButton;
//          BtnRandR34App: TNBoxCheckButton;
          BtnRandGmpClub: TNBoxCheckButton;
          BtnRandCoomerParty: TNBoxCheckButton;
          BtnRandMotherless: TNBoxCheckButton;
          BtnRand9Hentaito: TNBoxCheckButton;
          BtnRandRule34xxx: TNBoxCheckButton;
          BtnRandGelbooru: TNBoxCheckButton;
          BtnRandXBooru: TNBoxCheckButton;
          BtnRandRule34PahealNet: TNBoxCheckButton;
        BepisDbMenu: TNBoxSearchSubMenuBase;
          BtnBepisDbChangeSubject: TRectButton;
          BtnBepisDbChangeOrderBy: TRectButton;
          BtnBepisDbChangeGender: TRectButton;
          BtnBepisDbChangePersonality: TRectButton;
          BtnBepisDbChangeGameType: TRectButton;
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
var
  I: integer;

  function NewBtn(AOrigin: integer): TRectButton;
  begin
    Result := AddBtn(OriginToStr(AOrigin), AOrigin, Form1.AppStyle.GetImagePath(AOrigin));
  end;

begin
  inherited;
  FSelected := ORIGIN_NSFWXXX;

  for I := 0 to PROVIDERS.Count - 1 do begin
    var LProvider := PROVIDERS[I];
    if (LProvider <> PROVIDERS.R34App) then
      NewBtn(LProvider.Id);
  end;
end;

destructor TNBoxOriginSetMenu.Destroy;
begin
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

  if Assigned(Control) then
    Size.Height := MaxY + Control.Height;
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

  function NewBtnCheck(AText: string; AParent: TControl; AImageName: string; AIsChecked: boolean = True): TNBoxCheckButton;
  begin
    Result := Form1.CreateDefCheckButton(Self);
    with Result do begin
      Image.ImageURL := AImageName;
      Text.Text := AText;
      Parent := AParent;
      Align := TAlignLayout.Top;
      Margins.Rect := M;
      IsChecked := AIsChecked;
    end;
  end;

  function NewSelectMenu: TNBoxSelectMenu; overload;
  begin
    Result := TNBoxSelectMenu.Create(Self);
    with Result do begin
      Parent := Self;
      Visible := false;
      Align := TAlignlayout.Client;
    end;
    FSelectMenus.Add(Result);
  end;

  function NewProviderMenu(AId: Integer): TNBoxSearchSubMenuBase;
  begin
    Result := TNBoxSearchSubMenuBase.Create(Self);
    with Result do begin
      Tag := AId;
      Parent := MainMenu;
      Align := TAlignLayout.Top;
      Visible := false;
    end;
    FProviderMenus.Add(Result);
  end;

  procedure SetBtnTriggerSelectMenu(ABtn: TRectbutton; AMenu: TNBoxSelectMenu);
  begin
    ABtn.OnTap := Self.BtnSelectMenuOnTap;
    AMenu.TagObject := ABtn;
    ABtn.TagObject := AMenu;
  end;

  function NewBtn(AParent: TControl; AText: string; ABeBottomControl: TControl = nil): TRectButton;
  begin
    Result := Form1.CreateDefButton(Self, BTN_STYLE_DEF2);
    with Result do begin
      Parent := AParent;
      Align := TAlignlayout.top;
      Margins.Rect := M;
      Text.Text := AText;
      if Assigned(ABeBottomControl) then
        BeBottom(Result, ABeBottomControl);
      Image.ImageURL := IconPath; //delete this
    end;
  end;

  function NewSelectBtn(AParent: TControl; AText: string; ASelectMenu: TNBoxSelectMenu; ABeBottomControl: TControl = nil): TRectButton;
  begin
    Result := NewBtn(AParent, AText, ABeBottomControl);
    SetBtnTriggerSelectMenu(Result, ASelectMenu);
  end;

  function NewSelectMenu(out AMenu: TNBoxSelectMenu; AParent: TControl; out ARepresentButton: TRectButton): TNBoxSelectMenu; overload;
  begin
    Result := NewSelectMenu;
    AMenu := Result;
    Result.OnSelected := DefaultSelectMenuOnChanged;
    ARepresentButton := NewSelectBtn(AParent, '', Result);
    ARepresentButton.Position.Y := Single.MaxValue;
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

    R34AppBooruChangeMenu := NewSelectMenu;
    with R34AppBooruChangeMenu do begin
      for I := 0 to Ord(TR34AppFreeBooru.e926net) do
        Addbtn(BooruToLink(TR34AppFreeBooru(I)), I, IconPath);
      OnSelected := Self.OnR34AppBooruChanged;
    end;

    R34AppMenu := NewProviderMenu(PROVIDERS.R34App.Id);
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

    BookmarksMenu := NewProviderMenu(PROVIDERS.Bookmarks.id);
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

    NsfwXxxMenu := NewProviderMenu(PROVIDERS.NsfwXxx.Id);

    with NewSelectMenu(NsfwXxxSortMenu, NsfwXxxMenu, BtnChangeSort) do
    begin
      Addbtn('Newest', Ord(Newest), Form1.AppStyle.GetImagePath(ICON_HISTORY));
      Addbtn('Popular', Ord(Popular), Form1.AppStyle.GetImagePath(ORIGIN_BOOKMARKS));
      Addbtn('Recommended', Ord(Recommended), IconPath);
    end;

    with NewSelectMenu(NsfwXxxSearchTypeMenu, NsfwXxxMenu, BtnChangeUrlType) do
    begin
      Addbtn('Text request', Ord(TNsfwUrlType.Default), IconPath);
      Addbtn('User name', Ord(TNsfwUrlType.User), Form1.AppStyle.GetImagePath(ICON_AVATAR));
      Addbtn('Category', Ord(TNsfwUrlType.Category), IconPath);
      Addbtn('Related posts', Ord(TNsfwUrlType.Related), Form1.AppStyle.GetImagePath(ICON_COPY));
    end;

    with NewSelectMenu(NsfwXxxHostChangeMenu, NsfwXxxMenu, BtnChangeSite) do
    begin
      Addbtn('nsfw.xxx', Ord(TNsfwXxxSite.NsfwXxx), IconPath);
      Addbtn('pornpic.xxx', Ord(TNsfwXxxSite.PornpicXxx), IconPath);
      Addbtn('hdporn.pics', Ord(TNsfwXxxSite.HdpornPics), IconPath);
    end;

    with NsfwXxxMenu do begin

      CheckGrid := TColumnsLayout.Create(NsfwXxxMenu);
      with CheckGrid do begin
        Parent := NsfwXxxMenu;
        Align := TAlignLayout.Top;

        Margins.Rect := M;
        ItemsIndent := TPointF.Create(M.Top / 2, M.Top / 2);
        Margins.Left := ItemsIndent.X;
        Margins.Right := Margins.Left;
        Margins.Top := ItemsIndent.Y;
        ColumnsCount := 2;

        CheckGallery  := NewCheck(ICON_IMAGE, 'Gallery (set of images)');
        CheckImage    := NewCheck(ICON_IMAGE, 'Image');
        CheckVideo    := NewCheck(ICON_VIDEO, 'Video');
        CheckStraight := NewCheck(ICON_STRAIGHT, 'Straight');
        CheckTrans    := NewCheck(ICON_TRANS, 'Transgender');
        CheckCartoons := NewCheck(ICON_CARTOONS, 'Cartoons');
        CheckGay      := NewCheck(ICON_GAY, 'Gay');
        CheckBizarre  := NewCheck(ICON_WARNING, 'Bizarre');

        AutoSize := TRUE;
      end;

      OnResize := OnResizeEvent;
    end;

    GmpClubMenu := NewProviderMenu(PROVIDERS.GMPClub.Id);

    with NewSelectMenu(GmpClubSearchTypeMenu, GmpClubMenu, BtnGmpChangeSearchType) do
    begin
      Addbtn('Default navigate', Ord(TGmpclubSearchType.Empty), IconPath);
      Addbtn('Search by tag', Ord(TGmpclubSearchType.Tag), IconPath);
      Addbtn('Search by category', Ord(TGmpclubSearchType.Category), IconPath);
      Addbtn('Random content', Ord(TGmpclubSearchType.Random), Form1.AppStyle.GetImagePath(ORIGIN_RANDOMIZER));
      Selected := Ord(TGmpclubSearchType.Empty);
    end;

    CoomerPartyMenu := NewProviderMenu(PROVIDERS.CoomerParty.Id);
    with CoomerPartyMenu do begin

      EditCoomerPartyHost := Form1.CreateDefEdit(Self);
      with EditCoomerPartyHost do begin
        Parent := CoomerPartyMenu;
        Align := TAlignlayout.Top;
        Margins.Rect := M;
        Edit.Text := URL_COOMER_PARTY;
        Edit.TextPrompt := 'Host URL';
      end;

      with NewSelectMenu(CoomerPartyHostChangeMenu, CoomerPartyMenu, BtnCoomerPartyChangeSite) do
      begin
        AddBtnStr('coomer.party', URL_COOMER_PARTY, IconPath);
        AddBtnStr('kemono.party', URL_KEMONO_PARTY, IconPath);
        OnSelected := OnCoomerPartyHostChanged;
      end;
      BtnCoomerPartyChangeSite.Text.Text := 'Change host URL';
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

    { Motherless menu -------- }

    MotherlessMenu := NewProviderMenu(PROVIDERS.Motherless.Id);
    MotherlessMediaChangeMenu := NewSelectMenu;
    with MotherlessMediaChangeMenu do begin
      OnSelected := OnMotherlessMediaChanged;
//      for I := Ord(TMotherlessMediaType.MediaImage) to Ord(TMotherlessMediaType.MediaVideo) do
//        Addbtn(MediaTypeToStr(TMotherlessMediaType(I)), I, IconPath);
      AddBtn(MediaTypeToStr(MediaImage), Ord(MediaImage), ICON_IMAGE, True);
      AddBtn(MediaTypeToStr(MediaVideo), Ord(MediaVideo), ICON_VIDEO, True);
    end;
    BtnMotherlessChangeMedia := NewSelectBtn(MotherlessMenu, '', MotherlessMediaChangeMenu);
    MotherlessMediaChangeMenu.Selected := ord(TMotherlessMediaType.MediaImage);

    MotherlessSortChangeMenu := NewSelectMenu;
    with MotherlessSortChangeMenu do begin
      OnSelected := OnMotherlessSortChanged;
      for I := Ord(TMotherlessSort.SortRecent) to Ord(TMotherlessSort.SortDate) do
        Addbtn(SortTypeToStr(TMotherlessSort(I)), I, IconPath);
    end;
    BtnMotherlessChangeSort := NewSelectBtn(MotherlessMenu, '', MotherlessSortChangeMenu, BtnMotherlessChangeMedia);
    MotherlessSortChangeMenu.Selected := Ord(TMotherlessSort.SortRecent);

    MotherlessUploadDateChangeMenu := NewSelectMenu;
    with MotherlessUploadDateChangeMenu do begin
      OnSelected := OnMotherlessUploadDateChanged;
      for I := Ord(TMotherLessUploadDate.DateAll) to Ord(TMotherLessUploadDate.DateThisYear) do
        Addbtn(UploadDateToStr(TMotherLessUploadDate(I)), I, ICON_HISTORY, True);
    end;
    BtnMotherlessChangeUploadDate := NewSelectBtn(MotherlessMenu, '', MotherlessUploadDateChangeMenu, BtnMotherlessChangeSort);
    MotherlessUploadDateChangeMenu.Selected := Ord(TMotherLessUploadDate.DateAll);

    MotherlessMediaSizeChangeMenu := NewSelectMenu;
    with MotherlessMediaSizeChangeMenu do begin
      OnSelected := OnMotherlessMediaSizeChanged;
      for I := Ord(TMotherLessMediaSize.SizeAll) to Ord(TMotherLessMediaSize.SizeBig) do
        Addbtn(MediaSizeToStr(TMotherLessMediaSize(I)), I, IconPath);
    end;
    BtnMotherlessChangeMediaSize := NewSelectBtn(MotherlessMenu, '', MotherlessMediaSizeChangeMenu, BtnMotherlessChangeUploadDate);
    MotherlessMediaSizeChangeMenu.Selected := Ord(TMotherLessMediaSize.SizeAll);
  end;

  { Fapello menu ---------------- }

  FapelloMenu := NewProviderMenu(PROVIDERS.Fapello.Id);
  with NewSelectMenu(FapelloSearchTypeMenu, FapelloMenu, BtnFapelloChangeSearchType) do
  begin
    AddBtn('Feed', Ord(TFapelloItemKind.FlFeed), Form1.AppStyle.GetImagePath(ICON_HISTORY));
    AddBtn('Author', Ord(TFapelloItemKind.FlThumb), Form1.AppStyle.GetImagePath(ICON_AVATAR));
    Selected := Ord(TFapelloItemKind.FlFeed);
  end;

  { BepisDb menu ---------------- }

  BepisDbMenu := NewProviderMenu(PROVIDERS.BepisDb.Id);

  with NewSelectMenu(BepisDbSubjectMenu, BepisDbMenu, BtnBepisDbChangeSubject) do
  begin
    AddBtn('Koikatsu cards', Ord(TBepisDbSearchOpt.TSubject.KoikatsuCards), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Koikatsu scenes', Ord(TBepisDbSearchOpt.TSubject.KoikatsuScenes), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Koikatsu clothing', Ord(TBepisDbSearchOpt.TSubject.KoikatsuClothing), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Artificial Academy 2 cards', Ord(TBepisDbSearchOpt.TSubject.AA2Cards), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Artificial Academy 2 scenes', Ord(TBepisDbSearchOpt.TSubject.AA2Scenes), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Honey Select', Ord(TBepisDbSearchOpt.TSubject.HoneySelectCards), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Play Home', Ord(TBepisDbSearchOpt.TSubject.PlayHomeCards), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('AI Shoujo / HS2 cards', Ord(TBepisDbSearchOpt.TSubject.AIHS2Cards), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('AI Shoujo / HS2 scenes', Ord(TBepisDbSearchOpt.TSubject.AIHS2Scenes), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Custom Order Maid 3D 2', Ord(TBepisDbSearchOpt.TSubject.COM3D2Cards), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Summer Heat', Ord(TBepisDbSearchOpt.TSubject.SummerHeatCards), Form1.AppStyle.GetImagePath(ICON_EDIT));
    Selected := Ord(TBepisDbSearchOpt.TSubject.KoikatsuCards);
  end;

  with NewSelectMenu(BepisDbOrderByMenu, BepisDbMenu, BtnBepisDbChangeOrderBy) do
  begin
    AddBtn('By date (descending)', Ord(TBepisDbSearchOpt.TOrderBy.OrderDateDescending), Form1.AppStyle.GetImagePath(ICON_HISTORY));
    AddBtn('By date (ascending)', Ord(TBepisDbSearchOpt.TOrderBy.OrderDateAscending), Form1.AppStyle.GetImagePath(ICON_HISTORY));
    AddBtn('By popularity', Ord(TBepisDbSearchOpt.TOrderBy.OrderPopularity), Form1.AppStyle.GetImagePath(ORIGIN_BOOKMARKS));
    Selected := Ord(TBepisDbSearchOpt.TOrderBy.OrderDateDescending);
  end;

  with NewSelectMenu(BepisDbKKGenderMenu, BepisDbMenu, BtnBepisDbChangeGender) do
  begin
    AddBtn('Gender unspecified', Ord(TBepisDbSearchOpt.TGender.GendUnspecified), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Gender female', Ord(TBepisDbSearchOpt.TGender.GendFemale), Form1.AppStyle.GetImagePath(ICON_STRAIGHT));
    AddBtn('Gender male', Ord(TBepisDbSearchOpt.TGender.GendMale), Form1.AppStyle.GetImagePath(ICON_GAY));
    Selected := Ord(TBepisDbSearchOpt.TGender.GendUnspecified);
  end;

  with NewSelectMenu(BepisDbKKPersonalityMenu, BepisDbMenu, BtnBepisDbChangePersonality) do
  begin
    AddBtn('Personality unspecified', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersUnspecified), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Sexy', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersSexy), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Ojousama', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersOjousama), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Snobby', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersSnobby), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Kouhai', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersKouhai), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Mysterious', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersMysterious), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Weirdo', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersWeirdo), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Yamato Nadeshiko', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersYamatoNadeshiko), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Tomboy', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersTomboy), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Pure', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersPure), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Simple', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersSimple), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Delusional', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersDelusional), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Motherly', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersMotherly), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('BigSisterly', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersBigSisterly), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Gyaru', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersGyaru), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Delinquent', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersDelinquent), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Wild', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersWild), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Wannable', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersWannabe), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Reluctant', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersReluctant), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Jinxed', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersJinxed), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Bookish', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersBookish), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Timid', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersTimid), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Typical Schoolgirl', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersTypicalSchoolgirl), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Trendy', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersTrendy), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Otaku', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersOtaku), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Yandere', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersYandere), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Lazy', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersLazy), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Quiet', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersQuiet), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Stubborn', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersStubborn), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Oldfashioned', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersOldFashioned), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Humble', Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersHumble), Form1.AppStyle.GetImagePath(ICON_EDIT));
//    AddBtn('', Ord(TBepisDbSearchOpt.TKoikatsuPersonality), Form1.AppStyle.GetImagePath(ICON_EDIT));
    Selected := Ord(TBepisDbSearchOpt.TKoikatsuPersonality.PersUnspecified);
  end;

  with NewSelectMenu(BepisDbKKGameTypeMenu, BepisDbMenu, BtnBepisDbChangeGameType) do
  begin
    AddBtn('Game type unspecified', Ord(TBepisDbSearchOpt.TKoikatsuGameType.GameUnspecified), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Game type: Base', Ord(TBepisDbSearchOpt.TKoikatsuGameType.GameBase), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Game type: Steam', Ord(TBepisDbSearchOpt.TKoikatsuGameType.GameSteam), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Game type: Steam 18+', Ord(TBepisDbSearchOpt.TKoikatsuGameType.GameSteam18), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Game type: Emotion Creators', Ord(TBepisDbSearchOpt.TKoikatsuGameType.GameEmotionCreators), Form1.AppStyle.GetImagePath(ICON_EDIT));
    AddBtn('Game type: Sunshine', Ord(TBepisDbSearchOpt.TKoikatsuGameType.GameSunshine), Form1.AppStyle.GetImagePath(ICON_EDIT));
    Selected := Ord(TBepisDbSearchOpt.TKoikatsuGameType.GameUnspecified);
  end;

  { Randomizer menu ------------- }

  RandomizerMenu := NewProviderMenu(PROVIDERS.Randomizer.id);
  BtnRandNsfwXxx := NewBtnCheck(OriginToStr(ORIGIN_NSFWXXX), RandomizerMenu, Form1.AppStyle.GetImagePath(ORIGIN_NSFWXXX));
//  BtnRandR34App := NewBtnCheck(OriginToStr(ORIGIN_R34APP), RandomizerMenu, Form1.AppStyle.GetImagePath(ORIGIN_R34APP));
  BtnRandGmpClub := NewBtnCheck(OriginToStr(ORIGIN_GIVEMEPORNCLUB), RandomizerMenu, Form1.AppStyle.GetImagePath(ORIGIN_GIVEMEPORNCLUB));
  BtnRandCoomerParty := NewBtnCheck(OriginToStr(ORIGIN_COOMERPARTY), RandomizerMenu, Form1.AppStyle.GetImagePath(ORIGIN_COOMERPARTY));
  BtnRandMotherless := NewBtnCheck(OriginToStr(ORIGIN_MOTHERLESS), RandomizerMenu, Form1.AppStyle.GetImagePath(ORIGIN_MOTHERLESS));
  BtnRand9Hentaito := NewBtnCheck(OriginToStr(ORIGIN_9HENTAITO), RandomizerMenu, Form1.AppStyle.GetImagePath(ORIGIN_9HENTAITO));
  BtnRandRule34xxx := NewBtnCheck(OriginToStr(PVR_RULE34XXX), RandomizerMenu, Form1.AppStyle.GetImagePath(PVR_RULE34XXX));
  BtnRandGelbooru := NewBtnCheck(OriginToStr(PVR_GELBOORU), RandomizerMenu, Form1.AppStyle.GetImagePath(PVR_GELBOORU));
  BtnRandRule34PahealNet := NewBtnCheck(OriginToStr(PVR_RULE34PAHEALNET), RandomizerMenu, Form1.AppStyle.GetImagePath(PVR_RULE34PAHEALNET));
  BtnRandXBooru := NewBtnCheck(OriginToStr(PVR_XBOORU), RandomizerMenu, Form1.AppStyle.GetImagePath(PVR_XBOORU));
  RandomizerMenu.DoAutoSize;
  RandomizerMenu.OnResize := RandomizerMenu.OnResizeEvent;

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
        if CheckBizarre.IsChecked then
          include(LOris, NsfwXxx.Types.Bizarre);

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

    ORIGIN_MOTHERLESS: begin
      with ( Result as TNBoxSearchReqMotherless ) do begin
        ContentType := TMotherlessMediaType(MotherlessMediaChangeMenu.Selected);
        Sort := TMotherlessSort(MotherlessSortChangeMenu.Selected);
        UploadDate := TMotherlessUploadDate(MotherlessUploadDateChangeMenu.Selected);
        MediaSize := TMotherlessMediaSize(MotherlessMediaSizeChangeMenu.Selected);
      end;
    end;

    ORIGIN_BOOKMARKS: begin
      with ( Result as TNBoxSearchReqBookmarks ) do begin
        Path := self.EditBookmarksPath.Edit.Text;
      end;
    end;

    ORIGIN_RANDOMIZER: begin
      with ( Result as TNBoxSearchReqRandomizer ) do begin
        Providers := [];
        if BtnRandNsfwXxx.IsChecked then Providers := Providers + [ORIGIN_NSFWXXX];
//        if BtnRandR34App.IsChecked then Providers := Providers + [ORIGIN_R34APP];
        if BtnRandGmpClub.IsChecked then Providers := Providers + [ORIGIN_GIVEMEPORNCLUB];
        if BtnRandCoomerParty.IsChecked then Providers := Providers + [ORIGIN_COOMERPARTY];
        if BtnRand9Hentaito.IsChecked then Providers := Providers + [ORIGIN_9HENTAITO];
        if BtnRandMotherless.IsChecked then Providers := Providers + [ORIGIN_MOTHERLESS];
        if BtnRandGelbooru.IsChecked then Providers := Providers + [PVR_GELBOORU];
        if BtnRandRule34xxx.IsChecked then Providers := Providers + [PVR_RULE34XXX];
        if BtnRandRule34PahealNet.IsChecked then Providers := Providers + [PVR_RULE34PAHEALNET];
        if BtnRandXBooru.IsChecked then Providers := Providers + [PVR_XBOORU];
      end;
    end;

    PVR_FAPELLO: begin
      With ( Result as TNBoxSearchReqFapello ) do begin
        RequestKind := TFapelloItemKind(FapelloSearchTypeMenu.Selected);
      end;
    end;

    PVR_BEPISDB: begin
      var LReq := ( Result as TNBoxSearchReqBepisDb );
      var LOpt := LReq.SearchOpt;
      LOpt.Subject := TBepisDbSearchOpt.TSubject(BepisDbSubjectMenu.Selected);
      LOpt.OrderBy := TBepisDbSearchOpt.TOrderBy(BepisDbOrderByMenu.Selected);
      LOpt.Gender := TBepisDbSearchOpt.TGender(BepisDbKKGenderMenu.Selected);
      LOpt.KoikatsuPersonality := TBepisDbSearchOpt.TKoikatsuPersonality(BepisDbKKPersonalityMenu.Selected);
      LOpt.KoikatsuGameType := TBepisDbSearchOpt.TKoikatsuGameType(BepisDbKKGameTypeMenu.Selected);
      LReq.SearchOpt := LOpt;
    end;

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

procedure TNBoxSearchMenu.DefaultSelectMenuOnChanged(Sender: TObject);
var
  LMenu: TNBoxSelectMenu;
  LRepresentBtn: TRectButton;
begin
  ShowMainMenu;
  LMenu := Sender as TNBoxSelectMenu;
  if Assigned(LMenu.TagObject) then
  begin
    LRepresentBtn := LMenu.TagObject as TRectButton;
    if Assigned(LMenu.SelectedBtn) then
    begin
      LRepresentBtn.Text.Text := LMenu.SelectedBtn.Text.Text;
      LRepresentBtn.Image.ImageURL := LMenu.SelectedBtn.Image.ImageURL;
    end;
  end;
end;

procedure TNBoxSearchMenu.OnCoomerPartyHostChanged(Sender: TObject);
begin
  ShowMainMenu;
  Self.EditCoomerPartyHost.Edit.Text := CoomerPartyHostChangeMenu.SelectedStr;
end;

procedure TNBoxSearchMenu.OnFapelloSearchTypeChanged(Sender: TObject);
var
  LMenu: TNBoxSelectMenu;
begin
  ShowMainMenu;
  LMenu := (Sender as TNBoxSelectMenu);
  if Assigned(LMenu.SelectedBtn) then begin
    BtnFapelloChangeSearchType.Image.ImageURL := LMenu.SelectedBtn.Image.ImageURL;
    BtnFapelloChangeSearchType.Text.Text := LMenu.SelectedBtn.Text.Text;
  end;
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
  if Assigned(GmpClubSearchTypeMenu.SelectedBtn) then
    BtnGmpChangeSearchType.Image.ImageURL := GmpClubSearchTypeMenu.SelectedBtn.Image.ImageURL;
end;

procedure TNBoxSearchMenu.OnMotherlessMediaChanged(Sender: TObject);
var
  LSelected: TMotherlessMediaType;
  LMenu: TNBoxSelectMenu;
begin
  ShowMainMenu;
  LMenu := (Sender as TNBoxSelectMenu);
  LSelected := TMotherlessMediaType(LMenu.Selected);
  BtnMotherlessChangeMedia.Text.Text := MediaTypeToStr(LSelected);

  if Assigned(LMenu.SelectedBtn) then
    BtnMotherlessChangeMedia.Image.ImageURL := LMenu.SelectedBtn.Image.ImageURL;
end;

procedure TNBoxSearchMenu.OnMotherlessMediaSizeChanged(Sender: TObject);
var
  LSelected: TMotherlessMediaSize;
begin
  ShowMainMenu;
  LSelected := TMotherlessMediaSize((Sender as TNBoxSelectMenu).Selected);
  BtnMotherlessChangeMediaSize.Text.Text := MediaSizeToStr(LSelected);
end;

procedure TNBoxSearchMenu.OnMotherlessSortChanged(Sender: TObject);
var
  LSelected: TMotherlessSort;
begin
  ShowMainMenu;
  LSelected := TMotherlessSort((Sender as TNBoxSelectMenu).Selected);
  BtnMotherlessChangeSort.Text.Text := SortTypeToStr(LSelected);
end;

procedure TNBoxSearchMenu.OnMotherlessUploadDateChanged(Sender: TObject);
var
  LSelected: TMotherlessUploadDate;
  LMenu: TNBoxSelectMenu;
begin
  ShowMainMenu;
  LMenu := (Sender as TNBoxSelectMenu);
  LSelected := TMotherlessUploadDate(LMenu.Selected);
  BtnMotherlessChangeUploadDate.Text.Text := UploadDateToStr(LSelected);

  if Assigned(LMenu.SelectedBtn) then
    BtnMotherlessChangeUploadDate.Image.ImageURL := LMenu.SelectedBtn.Image.ImageURL;
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
  if Assigned(NsfwXxxSearchTypeMenu.SelectedBtn) then
    BtnChangeUrlType.Image.ImageURL := NsfwXxxSearchTypeMenu.SelectedBtn.Image.ImageURL;
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
  if Assigned(NsfwXxxSortMenu.SelectedBtn) then
    BtnChangeSort.Image.ImageURL := NsfwXxxSortMenu.SelectedBtn.Image.ImageURL;
end;

procedure TNBoxSearchMenu.OnOriginChanged(Sender: TObject);
var
  I: integer;
  LProvider: TNBoxProviderInfo;
begin
  LProvider := PROVIDERS.ById(OriginSetMenu.Selected);
  BtnChangeOrigin.Image.ImageURL := form1.AppStyle.GetImagePath(LProvider.Id);
  BtnChangeOrigin.Text.Text := '( ' + LProvider.TitleName + ' ) Change content provider';
  Self.EditPageId.Edit.Text := LProvider.FisrtPageId.ToString;
  self.HideMenus;
  //OriginSetMenu.Visible := False;
  MainMenu.Visible := True;
  self.HideOriginMenus;

  for I := 0 to FProviderMenus.Count - 1 do
  if OriginSetMenu.Selected = FProviderMenus[I].Tag then begin
    FProviderMenus[I].Visible := True;
    Break;
  end;
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

  function _IN(AAr: TArray<Integer>; AInt: Integer): boolean;
  var
    LIndex, I: integer;
  begin
    LIndex := -1;
    for I := Low(AAr) to High(AAr) do begin
      if (AAr[I] = AInt) then begin
        LIndex := I;
        Break;
      end;
    end;

    Result := (LIndex <> -1)
  end;

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
      CheckBizarre.IsChecked  := ( Bizarre in Oris );
    end;

  end else if ( Value is TNBoxSearchReqGmpClub ) then begin

    with ( Value as TNBoxSearchReqGmpClub ) do begin
      GmpClubSearchTypeMenu.Selected := Ord(SearchType);
    end;

  end else if ( Value is TNBoxSearchReqR34App ) then begin

    With ( Value as TNBoxSearchReqR34App ) do begin
      Case Booru of
        TR34AppFreeBooru.rule34xxx: OriginSetMenu.Selected := PROVIDERS.Rule34xxx.Id;
        TR34AppFreeBooru.gelboorucom: OriginSetMenu.Selected := PROVIDERS.Gelbooru.Id;
      end;
    end;

  end else if ( Value is TNBoxSearchReqCoomerParty ) then begin

    with ( Value as TNBoxSearchReqCoomerParty ) do begin
      Self.EditCoomerPartyHost.Edit.Text := Site;
      Self.EditCoomerPartyUserId.Edit.Text := UserId;
      Self.EditCoomerPartyService.Edit.Text := Service;
    end;

  end else if ( Value is TNBoxSearchReqMotherless ) then begin

    with ( Value as TNBoxSearchReqMotherless ) do begin
      MotherlessSortChangeMenu.Selected := Ord(Sort);
      MotherlessMediaChangeMenu.Selected := Ord(ContentType);
      MotherlessUploadDateChangeMenu.Selected := Ord(UploadDate);
      MotherlessMediaSizeChangeMenu.Selected := Ord(MediaSize);
    end;

  end else if ( Value is TNBoxSearchReqBookmarks ) then begin

    with ( Value as TNBoxSearchReqBookmarks ) do
      self.EditBookmarksPath.Edit.Text := Path;

  end else if ( Value is TNBoxSearchReqRandomizer ) then begin

    with ( Value as TNBoxSearchReqRandomizer ) do begin
      BtnRandNsfwXxx.IsChecked := _IN(Providers, ORIGIN_NSFWXXX);
//      BtnRandR34App.IsChecked := _IN(Providers, ORIGIN_R34APP);
      BtnRandGmpClub.IsChecked := _IN(Providers, ORIGIN_GIVEMEPORNCLUB);
      BtnRandCoomerParty.IsChecked := _IN(Providers, ORIGIN_COOMERPARTY);
      BtnRand9Hentaito.IsChecked := _IN(Providers, ORIGIN_9HENTAITO);
      BtnRandMotherless.IsChecked := _IN(Providers, ORIGIN_MOTHERLESS);
      BtnRandRule34xxx.IsChecked := _IN(Providers, PVR_RULE34XXX);
      BtnRandGelbooru.IsChecked := _IN(Providers, PVR_GELBOORU);
    end;

  end else if ( Value is TNBoxSearchReqFapello ) then begin

    with ( Value as TNBoxSearchReqFapello ) do
      FapelloSearchTypeMenu.Selected := Ord(RequestKind);

  end else if (Value is TNBoxSearchReqBepisDb) then begin
    var LReq := Value as TNBoxSearchReqBepisDb;
    BepisDbSubjectMenu.Selected := Ord(LReq.SearchOpt.Subject);
    BepisDbOrderByMenu.Selected := Ord(LReq.SearchOpt.OrderBy);
    BepisDbKKGenderMenu.Selected := Ord(LReq.SearchOpt.Gender);
    BepisDbKKPersonalityMenu.Selected := Ord(LReq.SearchOpt.KoikatsuPersonality);
    BepisDbKKGameTypeMenu.Selected := Ord(LReq.SearchOpt.KoikatsuGameType);
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
  Result := Self.AddBtn(TRectButton, AText);
  with Result do begin
    Tag := AId;

    if not AImageFilename.IsEmpty then begin

      if AShortImageName then
        Image.ImageURL := Form1.AppStyle.GetImagePath(AImageFilename)
      else
        Image.ImageURL := AImageFilename;

    end;
  end;
end;

function TNBoxSelectMenu.AddBtn(ABtnClass: TRectButtonClass;
  AText: string): TRectButton;
begin
  Result := Form1.CreateDefButtonC(Self, ABtnClass, DEFAULT_IMAGE_CLASS);
  with Result do begin

    Parent := Self;
    Align := TAlignLayout.Top;
    Position.Y := 0;
    Text.Text := AText;

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

function TNBoxSelectMenu.BtnIndexByIntTag(AId: NativeInt): integer;
var
  I: integer;
begin
  for I := 0 to Content.Controls.Count - 1 do begin
    if (Content.Controls[I].Tag = AId) then begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure TNBoxSelectMenu.BtnOnTap(Sender: TObject; const Point: TPointF);
begin
  FSelectedBtn := (Sender As TRectButton);
  FSelectedStr := TFmxObject(Sender).TagString;
  FDontChangeCurrentBtn := True;
  try
    Selected := TFmxObject(Sender).Tag;
  finally
    FDontChangeCurrentBtn := False;
  end;
end;

procedure TNBoxSelectMenu.ClearButtons;
var
  I: integer;
  C: TControl;
begin
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
  FDontChangeCurrentBtn := False;
  FSelectedBtn := nil;
end;

destructor TNBoxSelectMenu.Destroy;
begin
  inherited;
end;

function TNBoxSelectMenu.GetBtnByTag(AId: NativeInt): TRectButton;
var
  LIndex: integer;
begin
  LIndex := BtnIndexByIntTag(AId);
  if LIndex <> -1 then
    Result := Content.Controls[LIndex] as TRectButton
  else
    Result := Nil;
end;

procedure TNBoxSelectMenu.SetSelected(const value: NativeInt);
var
  I: integer;
begin
  FSelected := value;
  if not FDontChangeCurrentBtn then FSelectedBtn := GetBtnByTag(Value);
  if Assigned(OnSelected) then OnSelected(self);
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

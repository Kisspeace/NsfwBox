//♡2022 by Kisspeace. https://github.com/kisspeace
// zalupka! 🤭  🫶🏻
unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, XSuperObject,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Color, FMX.Edit, FMX.Layouts,
  Net.HttpClient, Net.HttpClientComponent, IoUtils, NsfwBoxFilesystem, NsfwXxx.Types,
  NethttpClient.Downloader, FMX.Memo, FMX.Memo.Types, FMX.ScrollBox,
  System.Hash, FMX.Surfaces, System.Variants, System.Threading, system.NetEncoding,
  {$IFDEF ANDROID}
  Fmx.Helpers.Android, AndroidApi.Helpers,
  AndroidApi.JNI.GraphicsContentViewText,
  AndroidApi.JNI.JavaTypes,
  {$ENDIF} {$IFDEF MSWINDOWS}
  ShellApi, Windows,
  {$ENDIF}
  FMX.VirtualKeyboard, Fmx.Platform, SimpleClipboard,
  DbHelper, System.Generics.Collections,
  { Alcinoe ---------- }
  AlFmxGraphics, AlFmxObjects,
  { NsfwBox ---------- }
  NsfwBoxInterfaces, NsfwBoxSettings, NsfwBoxGraphics, NsfwBoxContentScraper,
  NsfwBoxOriginPseudo, NsfwBoxOriginNsfwXxx, NsfwBoxOriginR34App,
  NsfwBoxOriginR34JsonApi, NsfwBoxOriginBookmarks,
  NsfwBoxOriginCoomerParty, NsfwBoxOrigin9HentaiToApi, NsfwBoxOriginConst,
  NsfwBoxGraphics.Browser, NsfwBoxStyling, NsfwBoxGraphics.Rectangle,
  NsfwBoxDownloadManager, NsfwBoxBookmarks, NsfwBoxHelper,
  NsfwBox.UpdateChecker, NsfwBox.MessageForDeveloper, Unit2,
  { you-did-well! ---- }
  YDW.FMX.ImageWithURL.AlRectangle, YDW.FMX.ImageWithURLManager,
  YDW.FMX.ImageWithURLCacheManager, YDW.FMX.ImageWithURL.Interfaces;

type

  TIWUContentManager = TImageWithUrlManager;
  TIWUCacheManager = TImageWithURLCahceManager;

  TControlObjList = TObjectList<TControl>;
  TControlList = TList<TControl>;
  TProcedureRef = reference to procedure;

  TForm1 = class(TForm)
    MVMenu: TMultiView;
    MainLayout: TLayout;
    BrowserLayout: TLayout;
    MenuSearchSettings: TLayout;
    BrowserBtnsLayout: TLayout;
    StyleBook1: TStyleBook;
    MenuItem: TVertScrollBox;
    MenuSettings: TVertScrollBox;
    MenuDownloads: TVertScrollBox;
    MenuBookmarks: TVertScrollBox;
    MenuLog: TVertScrollBox;
    MenuBookmarksChange: TVertScrollBox;
    MenuBookmarksDoList: TVertScrollBox;
    DialogYesOrNo: TVertScrollBox;
    MenuSearchDoList: TVertScrollBox;
    MenuAnonMessage: TVertScrollBox;
    BrowserBtnsLayout2: TLayout;
    OnBrowserLayout: TLayout;
    MenuHistory: TVertScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FSettings: TNsfwBoxSettings;
    FAppStyle: TNBoxGUIStyle;
    FFormCreated: boolean;
    FCurrentBrowser: TNBoxBrowser;
    FCurrentItem: TNBoxCardBase;
    FCurrentBookmarksDb: TNBoxBookmarksDb;
    FCurrentBookmarkControl: TNBoxSettingsCheck;
    FCurrentBookmarkGroup: TBookmarkGroupRec;
    procedure SetSettings(const value: TNsfwBoxSettings);
    function GetSettings: TNsfwBoxSettings;
    function GetAppStyle: TNBoxGUIStyle;
    procedure SetAppStyle(const Value: TNBoxGUIStyle);
    procedure SetCurrentBrowser(const Value: TNBoxBrowser);
    procedure SetCurrentItem(const value: TNBoxCardBase);
    procedure SetCurrentBookmarkControl(const value: TNBoxSettingsCheck);
    procedure SetCurrentBookmarksDb(const value: TNBoxBookmarksDb);
    function GetSubHeader: string;
    procedure SetSubHeader(const Value: string);
  public
    { Public declarations }
    AfterUserEvent: TProcedureRef;
    TopRect: TAlRectangle;
      TopBtnApp: TRectButton;
      TopTextLayout: Tlayout;
        TopText: TAlText;
        TopBottomText: TAlText;
      TopBtnSearch: TRectButton;
      TopBtnPopMenu: TRectButton;
    MVRect: TAlRectangle;
      MVMenuScroll: TVertScrollBox;
        MenuBtnDownloads: TRectButton;
        MenuBtnBookmarks: TRectButton;
        MenuBtnSettings: TRectButton;
        MenuBtnNewTab: TRectButton;
    TabsScroll: TVertScrollBox;
    Browsers: TNBoxBrowserList;
    Tabs: TNBoxTabList;
    BtnNext: TRectButton;
    BtnPrev: TRectButton;

    { DialogYesOrNo }
    UserSayYes: boolean;
    TextDialog: TAlText;
    LayoutDialogYesOrNo: TLayout;
      BtnDialogYes,
      BtnDialogNo
      : TRectButton;

    { Layout Item Menu }
    BtnBrowse,
    BtnDownloadAll,
    BtnDownloadMenu,
    BtnPlay,
    BtnAddBookmark,
    BtnOpenRelated,
    BtnOpenAuthor,
    BtnCopyFullUrl,
    BtnCopyThumbUrl,
    BtnLogContentUrls,
    BtnShareContent,
    BtnDeleteBookmark,
    BtnDeleteCard,
    BtnShowTags
    : TRectButton;
    ButtonsItemMenu: TControlList;

    { MenuSearchDoList }
    BtnSearchAddBookmark,
    BtnSearchSetDefault
    : TRectButton;

    { MenuBookmarksDoList }
    BtnBMarkCreate,
    BtnBMarkOpen,
    BtnBMarkOpenLastPage,
    BtnBMarkChange,
    BtnBMarkDelete
    : TRectButton;
    ButtonsBMark: TControlList;

    { MenuBookmarksChange }
    LayoutBMarkChangeTop: TLayout;
      ImageBMark: TRectButton;
      EditBMarkName: TNBoxEdit;
    MemoBMarkAbout: TNBoxMemo;
    BtnBMarkSaveChanges: TRectButton;

    { search Settings Layout }
    SearchMenu: TNBoxSearchMenu;

    { Menu Downloads }
    DownloadFetcher: TNBoxFetchManager;
    DownloadManager: TNBoxDownloadManager;
    DownloadItems: TNBoxTabList;

    { Bookmarks menu }
    BookmarksControls: TControlObjList;

    { Menu log }
    MemoLog: TNBoxMemo;

    { Settings Menu }
    BtnOpenAppRep: TRectButton;
    CheckSetFullscreen,
    CheckSetAllowCookies,
    CheckSetAutoSaveSession,
    CheckSetSaveSearchHistory,
    CheckSetSaveTapHistory,
    CheckSetSaveDownloadHistory,
    CheckSetSaveTabHistory,
    CheckSetShowCaptions,
    CheckSetAllowDuplicateTabs,
    CheckSetAutoStartBrowse,
    CheckSetAutoCloseItemMenu,
    CheckSetDevMode,
    CheckSetAutoCheckUpdates,
    CheckSetShowScrollBars,
    CheckSetShowNavigateBackButton,
    CheckSetBrowseNextPageByScrollDown
    : TNBoxSettingsCheck;

    EditSetDefUseragent,
    EditSetDefDownloadPath,
    EditSetThreadsCount,
    EditSetMaxDownloadThreads,
    EditSetLayoutsCount,
    EditSetItemIndent,
    EditSetFilenameLogUrls,
    EditSetPlayParams,
    EditSetPlayApp
    : TNBoxSettingsEdit;

    BtnSetAnonMsg,
    BtnSetViewLog,
    BtnSetChangeOnItemTap,
    BtnSetChangeTheme,
    BtnSetSave
    : TRectButton;

    MenuChangeTheme: TNBoxSelectMenu;

    { Settings }
    CheckMenuSetOnItemTap: TNBoxCheckMenu;
    BtnSetSaveOnItemTap: TRectButton;

    MenuItemTags: TNBoxSelectMenu;
    MenuItemTagsOrigin: integer;

    { Anonymous message menu (MenuAnonMessage) }
    EditNickMsgForDev: TNBoxEdit;
    MemoMsgForDev: TNBoxMemo;
    BtnSendMsgForDev: TRectButton;


    function CreateTabText(ABrowser: TNBoxBrowser): string;
    function GetBetterFilename(AFilename: string; AOrigin: integer = -2): string;
    procedure AppOnException(Sender: TObject; E: Exception);
    procedure ClickTapRef(Sender: TObject);
    { -> Menu buttons ------------- }
    procedure MenuBtnDownloadsOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuBtnSettingsOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuBtnNewTabOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuBtnBookmarksOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuBtnHistoryOnTap(Sender: TObject; const Point: TPointF);
    { -> Other -------------------- }
    procedure TopBtnAppOnTap(Sender: TObject; const Point: TPointF);
    procedure TopBtnSearchOnTap(Sender: TObject; const Point: TPointF);
    procedure TopBtnPopMenuOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnNextOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnPrevOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuItemTagsOnSelected(Sender: TObject);
    procedure LayoutDialogYesOrNoOnResize(Sender: TObject);
    procedure OnIWUException(Sender: TObject; AImage: IImageWithURL; const AUrl: string; const AException: Exception);
    { -> Tabs --------------------- }
    procedure BtnTabCloseOnTap(Sender: TObject; const Point: TPointF);
    procedure TabOnTap(Sender: TObject; const Point: TPointF);
    { ----------------------------- }
    procedure BtnOpenAppRepOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetAnonMsgOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSendMsgForDevOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetChangeThemeOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnItemMenuOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetViewLogOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetSaveOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetChangeOnItemTapOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetSaveOnItemTapOnTap(Sender: TObject; const Point: TPointF);
    procedure CardOnTap(Sender: TObject; const Point: TPointF);
    procedure IconOnResize(Sender: TObject);
    procedure BookmarksControlOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuChangeThemeOnSelected(Sender: TObject);
    { -> Search Menu do list buttons }
    procedure BtnSearchAddBookmarkOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSearchSetDefaultOnTap(Sender: TObject; const Point: TPointF);
    { -> Bookmark menu buttons ---- }
    procedure BtnBMarkSaveChangesOnTap(Sender: TObject; const Point: TPointF);
    procedure BMarkOpen(AOpenLastPage: boolean);
    procedure BtnBMarkOpenOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnBMarkOpenLastPageOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnBMarkChangeOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnBMarkCreateOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnBMarkDeleteOnTap(Sender: TObject; const Point: TPointF);
    { -> Dialog Yes or No --------- }
    procedure BtnDialogYesOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnDialogNoOnTap(Sender: TObject; const Point: TPointF);
    { ----------------------------- }
    procedure DownloadFetcherOnFetched(Sender: TObject; var AItem: INBoxItem);
    procedure OnCreateDownloader(Sender: Tobject; const ADownloader: TNetHttpDownloader);
    procedure OnStartDownloader(Sender: Tobject; const ADownloader: TNetHttpDownloader);
    procedure CloseDownloadTabOnTap(Sender: TObject; const Point: TPointF);
    procedure DownloaderOnCreateWebClient(const Sender: TObject; AWebClient: TNetHttpClient);
    procedure DownloaderOnReceiveData(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var AAbort: Boolean);
    procedure DownloaderOnException(const Sender: TObject; const AError: Exception);
    procedure DownloaderOnFinish(Sender: TObject);
    { ----------------------------- }
    procedure ExecItemInteraction(AItem: TNBoxCardBase; AInteraction: TNBoxItemInteraction);
    procedure OnBrowsersNotify(Sender: TObject; const Item: TNBoxBrowser; Action: TCollectionNotification);
    { ----------------------------- }
    function IndexTabByBrowser(ABrowser: TNBoxBrowser): integer;
    function GetTab(ABrowser: TNBoxBrowser): TNBoxTab;
    { ----------------------------- }
    procedure RestoreDefaultSettings;
    {$IFDEF MSWINDOWS}
    procedure RestoreDefaultStyle;
    {$ENDIF}
    { ----------------------------- }
    procedure ChangeInterface(ALayout: TControl);
    procedure UserSelectBookmarkList(AWhenSelected: TProcedureRef);
    procedure UserBooleanDialog(AText: string; AWhenSelected: TProcedureRef);
    procedure GotoSearchSettings(ABrowser: TNBoxBrowser = nil);
    procedure GotoItemMenu(AItem: TNBoxCardBase);
    procedure GotoDownloadsMenu;
    procedure GotoItemTagsMenu(ATags: TArray<string>; AOrigin: integer);
    procedure GotoBookmarksMenu(ABookmarksDb: TNBoxBookmarksDb);
    { -> Browsers ----------------- }
    procedure OnBrowserViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure OnBrowserSetWebClient(Sender: TObject; AWebClient: TNetHttpClient; AOrigin: integer);
    procedure OnBrowserScraperCreate(Sender: TObject; var AScraper: TNBoxScraper);
    procedure OnBrowserReqChanged(Sender: TObject);
    procedure BrowserBeforeBrowse(Sender: TObject);
    { -> Cards events ------------- }
    procedure OnNewItem(Sender: TObject; var AItem: TNBoxCardBase);
    procedure OnSimpleCardResize(Sender: TObject);
    procedure OnCardAutoLook(Sender: TObject);
    { ----------------------------- }
    procedure SaveSettings;
    function LoadSettings: boolean;
    function LoadStyle: boolean;
    procedure ConnectSession;
    function LoadSession: boolean;
    procedure ReloadBookmarks(ADataBase: TNBoxBookmarksDb; ALayout: TControl);
    { -> Fabrics ------------------ }
    function CreateDefScroll(AOwner: TComponent): TVertScrollBox;
    function CreateDefRect(AOwner: TComponent): TAlRectangle;
    function CreateDefBrowser(AOwner: TComponent): TNBoxBrowser;
    function CreateDefTab(AOwner: TComponent): TNBoxTab;
    function CreateDefCheck(AOwner: TComponent): TRectTextCheck;
    function CreateDefCheckButton(AOwner: TComponent; AStyle: integer = 0): TNBoxCheckButton;
    function CreateDefRadioButton(AOwner: TComponent; AStyle: integer = 0): TNBoxRadioButton;
    function CreateDefButton(AOwner: TComponent; AStyle: integer = 0): TRectButton;
    function CreateDefText(AOwner: TComponent; AStyle: integer = 0): TAlText;
    function CreateDefEdit(AOwner: TComponent; AStyle: integer = 0): TNBoxEdit;
    function CreateDefMemo(AOwner: TComponent; AStyle: integer = 0): TNBoxMemo;
    function CreateDefSettingsCheck(AOwner: TComponent): TNBoxSettingsCheck;
    function CreateDefSettingsEdit(AOwner: TComponent; AStyle: integer = 0): TNBoxSettingsEdit;
    function CreateDefScraper: TNBoxScraper;
    { -> Download ----------------- }
    function AddDownload(AItem: INBoxItem): TNBoxTab; overload;
    function AddDownload(AUrl, AFullFilename: string): TNBoxTab; overload;
    { ----------------------------- }
    function AddSettingsCheck(ACaption: string; AText: string = ''): TNBoxSettingsCheck;
    function AddSettingsEdit(ACaption: string; AText: string = ''; AStyle: integer = 0): TNBoxSettingsEdit;
    function AddSettingsButton(AText: string; AImageName: string = ''): TRectButton;
    function AddBMarksDoListButton(AText: string; AImageName: string = ''; AOnTap: TTapEvent = nil; ATag: string = ''): TRectButton;
    function AddMenuBtn: TRectButton;
    function AddMenuSearchBtn(AText: string; AImageName: string = ''; AOnTap: TTapEvent = nil): TRectButton;
    function AddItemMenuBtn(ACaption: string; AAction: TNBoxItemInteraction; AImageName: string = ''; ATag: string = ''): TRectButton;
    function AddBrowser(ARequest: INBoxSearchRequest = nil; AAutoStartBrowse: boolean = false): TNBoxTab;
    procedure DeleteBrowser(ABrowser: TNBoxBrowser);
    { -> Properies ---------------- }
    property CurrentBrowser: TNBoxBrowser read FCurrentBrowser write SetCurrentBrowser;
    property CurrentItem: TNBoxCardBase read FCurrentItem write SetCurrentItem;
    property CurrentBookmarksDb: TNBoxBookmarksDb read FCurrentBookmarksDb write SetCurrentBookmarksDb;
    property CurrentBookmarkControl: TNBoxSettingsCheck read FCurrentBookmarkControl write SetCurrentBookmarkControl;
    property CurrentBookmarkGroup: TBookmarkGroupRec read FCurrentBookmarkGroup;
    property AppStyle: TNBoxGUIStyle read GetAppStyle write SetAppStyle;
    property Settings: TNsfwBoxSettings read GetSettings write SetSettings;
    property SubHeader: string read GetSubHeader write SetSubHeader;
  end;

var
  Form1: TForm1;
  APP_VERSION: TSemVer; // Current application version

  LOG_FILENAME         : string = 'log.txt';
  SETTINGS_FILENAME    : string = 'settings.json';
  BOOKMARKSDB_FILENAME : string = 'bookmarks.sqlite';
  SESSION_FILENAME     : string = 'session.sqlite';
  HISTORY_FILENAME     : string = 'history.sqlite';

  IWUContentManager: TIWUContentManager;
  BrowsersIWUContentManager: TIWUContentManager;
  IWUCacheManager: TIWUCacheManager;
  BookmarksDb: TNBoxBookmarksDb;
  HistoryDb: TNBoxBookmarksHistoryDb;
  Session: TNBoxBookmarksDb;
  NowLoadingSession: boolean   = false;
  NowUserSelect: boolean = false;
  DoWithAllItems: boolean = false;
  BadThingsNum: integer = 0;

const
  TAG_CAN_USE_MORE_THAN_ONE: string = '>';
  BTN_STYLE_DEF        = 0;
  BTN_STYLE_ICON       = 1;
  BTN_STYLE_ICON2      = 2;
  BTN_STYLE_ICON3      = 3;
  BTN_STYLE_DEF2       = 4;

  EDIT_STYLE_INT       = 1;

  TOPRECT_HEIGHT      = 48;
  CONTROLS_DEF_HEIGHT = 45;
  BUTTON_HEIGHT       = 50;
  TAB_DEF_HEIGHT      = 46;
  EDIT_DEF_HEIGHT     = 40;

  procedure Log(A: string); overload;
  procedure SyncLog(A: string); overload;
  procedure SyncLog(AEx: Exception; Astr: string); overload;
  procedure Log(AEx: Exception; Astr: string); overload;


implementation

{$R *.fmx}

{$IFDEF ANDROID}
procedure StartActivity(AUri: string; AAction: JString);
var
  Intent: JIntent;
begin
  Intent := TJintent.Create;
  Intent.setAction(AAction);
  Intent.setData(StrToJURI(AUri));
  TAndroidHelper.Activity.startActivity(Intent);
end;

procedure StartActivityView(AUri: string);
begin
  StartActivity(AUri, TJintent.JavaClass.ACTION_VIEW)
end;
{$ENDIF}

function ConcatS(const AStrs: TArray<string>; ASeparator: string = SLineBreak): string;
var
  I: integer;
begin
  Result := '';
  for I := Low(AStrs) to High(AStrs) do
    Result := Result + AStrs[I] + ASeparator;
end;

function _In(AArray: TArray<integer>; AValue: integer): boolean;
var
  I: integer;
begin
  Result := false;
  for I := Low(AArray) to high(AArray) do begin
    if AArray[I] = AValue then begin
      Result := true;
      exit;
    end;
  end;
end;

procedure WriteToFile(AFileName, Atext: string);
var
  F: TFileStream;
  Encoding: TEncoding;
  LBytes: TBytes;
  LDir: string;
begin
  try
    LDir := Tpath.GetDirectoryName(AFilename);
    if Not DirectoryExists(LDir) then
      CreateDir(LDir);

    if FileExists(AFilename) then
      F := TFileStream.Create(AFilename, FmOpenWrite)
    else
      F := TFileStream.Create(AFilename, FmCreate);

    Encoding := TEncoding.Default;
    LBytes := Encoding.GetBytes(AText);
    F.Position := F.Size;
    F.Write(LBytes, 0, Length(LBytes));
  finally
    F.Free;
  end;
end;

procedure Log(A: string); overload;
var
  Date: String;
begin
  Date := '[ ' + DateTimeToStr(Now) + ' ]: ';
  WriteToFile(LOG_FILENAME, Date + A + SLineBreak);
end;

procedure Log(AEx: Exception; Astr: string); overload;
begin
  Log(AStr + AEX.ClassName + ': ' + AEx.Message);
end;

procedure SyncLog(A: string);
var
  ThreadId: cardinal;
begin
  ThreadId := TThread.Current.ThreadID;
  Tthread.Synchronize(nil, procedure begin Log(ThreadId.ToString + ': ' + A); end);
end;

procedure SyncLog(AEx: Exception; Astr: string);
begin
  SyncLog(AStr + AEX.ClassName + ': ' + AEx.Message);
end;

function TForm1.AddBMarksDoListButton(AText: string; AImageName: string = '';
  AOnTap: TTapEvent = nil; ATag: string = ''): TRectButton;
begin
  Result := CreateDefButton(MenuBookmarksDoList);
  with Result do begin
    Parent := MenuBookmarksDoList;
    Align := TAlignlayout.Top;
    Image.FileName := AppStyle.GetImagePath(AImageName);
    Text.Text := AText;
    OnTap := AOnTap;
    TagString := ATag;
    ButtonsBMark.Add(Result);
  end;
end;

function TForm1.AddBrowser(ARequest: INBoxSearchRequest; AAutoStartBrowse: boolean): TNBoxTab;
var
  B: TNBoxBrowser;
  T: TNBoxTab;
begin
  B := Form1.CreateDefBrowser(BrowserLayout);
  Browsers.Add(B);
  with B do begin
    Tag              := -1;
    Parent           := BrowserLayout;
    OnRequestChanged := OnBrowserReqChanged;
    OnItemCreate     := OnNewItem;
    BeforeBrowse     := BrowserBeforeBrowse;
  end;

  T := Form1.CreateDefTab(B);
  Tabs.Add(T);
  with T do begin
    image.Visible := false;
    Align         := TAlignlayout.Top;
    Text.Text     := 'Empty tab';
    Position.Y    := Single.MaxValue; // to the bottom
    parent        := TabsScroll;
    Margins.Rect  := TRectF.Create(4, 4, 4, 0);
    Position.Y    := 0;
    Closebtn.OnTap   := BtnTabCloseOnTap;
    Closebtn.OnClick := form1.ClickTapRef;
    OnTap            := form1.TabOnTap;
    OnClick          := ClickTapRef;
  end;

  if Assigned(ARequest) then
    B.Request := ARequest;

  form1.OnBrowserLayout.BringToFront;
  Result := T;

  if AAutoStartBrowse then
    B.GoBrowse;
end;

function TForm1.AddDownload(AItem: INBoxItem): TNBoxTab;
var
  full, Filename, url: string;
  I: integer;
begin
  if Supports(AItem, IFetchableContent)
  And not (AItem as IFetchableContent).ContentFetched
  then begin
    DownloadFetcher.Add(AItem.Clone);
    exit;
  end;

  if Settings.SaveDownloadHistory then
    HistoryDb.DownloadGroup.Add(AItem);

  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  for I := 0 to high(AItem.ContentUrls) do begin
    url := AItem.ContentUrls[I];
    Filename := GetBetterFilename(url, AItem.Origin);
    full := Settings.DefDownloadPath;

    if not DirectoryExists(Full) then
      CreateDir(Full);

    full := TPath.Combine(full, Filename);

    if not fileexists(full) then
      AddDownload(Url, full);
  end;
end;

function TForm1.AddDownload(AUrl, AFullFilename: string): TNBoxTab;
var
  Loader: TNetHttpDownloader;
begin
  if not Fileexists(AFullFilename) then begin

    Result := CreateDefTab(MenuDownloads);
    with Result do begin
      Align := TAlignLayout.Top;
      Position.Y := 0;
      margins.Rect := TRectF.Create(10, 10, 10, 0);
      Text.Text := AFullFilename;
      Parent := MenuDownloads;
      Image.Visible := false;

      Closebtn.OnTap := CloseDownloadTabOnTap;
      {$IFDEF MSWINDOWS}
      Closebtn.OnClick := ClickTapRef;
      {$ENDIF}
    end;

    DownloadItems.Add(Result);
    Loader := Downloadmanager.AddDownload(Aurl, AFullFilename);
    Result.TagObject := Loader;
    Loader.Tag := DownloadItems.Count - 1;

  end else begin
    Result := nil;
    Log('Cant download already exists: ' + AFullFilename);
  end;
end;

function TForm1.AddItemMenuBtn(ACaption: string; AAction: TNBoxItemInteraction;
 AImageName: string = ''; ATag: string = ''): TRectButton;
begin
  Result := CreateDefButton(MenuItem);
  with Result do begin
    Parent := MenuItem;
    Align := TAlignlayout.Top;
    Image.FileName := AppStyle.GetImagePath(AImageName);
    Text.Text := ACaption;
    Tag := Ord(AAction);
    OnTap := BtnItemMenuOnTap;
    Result.TagString := ATag;
    ButtonsItemMenu.Add(Result);
  end;
end;

function TForm1.AddMenuBtn: TRectButton;
begin
  Result := CreateDefButton(MVMenuScroll);
  with Result do begin
    Parent := MVMenuScroll;
    Align := TAlignlayout.MostTop;
    Position.Y := 0;
  end;
end;

function TForm1.AddMenuSearchBtn(AText, AImageName: string;
  AOnTap: TTapEvent): TRectButton;
begin
  Result := CreateDefButton(MenuSearchDoList);
  with Result do begin
    Parent := MenuSearchDoList;
    Align := TAlignLayout.Top;
    Text.Text := AText;
    Position.Y := Single.MaxValue;
    Image.FileName := AppStyle.GetImagePath(AImageName);
    OnTap := AOnTap;
  end;
end;

procedure _SetDefSettingsControl(AControl: TControl);
begin
  with AControl do begin
    Parent := Form1.MenuSettings;
    Align := TAlignLayout.Top;
    Margins.Rect := TRectF.Create(7, 7, 7, 0);
    Position.Y := single.MaxValue;
  end;
end;

procedure _SetDefSettingsCheck(AValue: TNBoxSettingsCheck; ACaption, AText: string);
begin
  with AValue do begin
    _SetDefSettingsControl(AValue);
    Check.Text.Text := ACaption;
    if not ATExt.IsEmpty then begin
      Text.Visible := true;
      Text.Text := AText;
    end;
  end;
end;

function TForm1.AddSettingsButton(AText, AImageName: string): TRectButton;
begin
  Result := CreateDefButton(MenuSettings, BTN_STYLE_DEF2);
  with Result do begin
    _SetDefSettingsControl(Result);
    Text.Text := AText;
    if not AImageName.IsEmpty then
      Image.FileName := AppStyle.GetImagePath(AImageName);
  end;
end;

function TForm1.AddSettingsCheck(ACaption, AText: string): TNBoxSettingsCheck;
begin
  Result := CreateDefSettingsCheck(MenuSettings);
  _SetDefSettingsCheck(Result, ACaption, AText);
end;

function TForm1.AddSettingsEdit(ACaption, AText: string; AStyle: integer): TNBoxSettingsEdit;
begin
  Result := CreateDefSettingsEdit(MenuSettings, AStyle);
  _SetDefSettingsCheck(Result, ACaption, AText);
  with Result do begin
    Edit.Edit.TextPrompt := ACaption;
    Height := Height * 1.8;
  end;
end;

procedure TForm1.AppOnException(Sender: TObject; E: Exception);
begin
  SyncLog(E, 'AppException ' + Sender.ClassName + ': ');
end;

procedure TForm1.BookmarksControlOnTap(Sender: TObject; const Point: TPointF);
begin
  CurrentBookmarkControl := ( Sender As TNBoxSettingsCheck );

  if not NowUserSelect then begin
    DoWithAllItems := false;
    ChangeInterface(MenuBookmarksDoList);
  end else begin
    if assigned(Self.AfterUserEvent) then
      AfterUserEvent;
    NowUserSelect := false;
  end;
end;

procedure TForm1.BrowserBeforeBrowse(Sender: TObject);
begin
  if Settings.SaveSearchHistory then
    HistoryDb.SearchGroup.Add(( Sender as TNBoxBrowser ).Request);
end;

procedure TForm1.BtnBMarkChangeOnTap(Sender: TObject; const Point: TPointF);
begin
  ChangeInterface(MenuBookmarksChange);
  AfterUserEvent := procedure
  var
    Group: TBookmarkGroupRec;
  begin
    Group := CurrentBookmarkGroup;
    if ( Group.Id <> -1 ) then begin
      Group.Name := EditBMarkName.Edit.Text;
      Group.About := MemoBMarkAbout.memo.lines.Text;
      Group.UpdateGroup;
      GotoBookmarksMenu(CurrentBookmarksDb);
    end;
  end;
end;

procedure TForm1.BtnBMarkCreateOnTap(Sender: TObject; const Point: TPointF);
var
  Group: TBookmarkGroupRec;
begin
  Group := BookmarksDb.AddGroup('New ' + DateTimeToStr(now), 'New bookmarks group.');
  FCurrentBookmarkGroup := Group;
  ChangeInterface(MenuBookmarksChange);

  AfterUserEvent := procedure
  begin
    if ( Group.Id <> -1 ) then begin
      Group.Name := EditBMarkName.Edit.Text;
      Group.About := MemoBMarkAbout.memo.lines.Text;
      Group.UpdateGroup;
      ChangeInterface(MenuBookmarks);
    end;
  end;
end;

procedure TForm1.BtnBMarkDeleteOnTap(Sender: TObject; const Point: TPointF);
begin
  if DoWithAllItems then begin

    UserBooleanDialog('Are you sure ?' + SLineBreak + 'Delete ALL YOUR BOOKMARKS !',
    procedure
    var
      I: integer;
      Groups: TBookmarkGroupRecAr;
    begin
      if UserSayYes then begin
        Groups := CurrentBookmarksDb.GetBookmarksGroups;
        for I := 0 to Length(Groups) - 1 do begin
          Groups[I].DeleteGroup;
        end;
        BookmarksControls.Clear;
      end;
      GotoBookmarksMenu(CurrentBookmarksDb);
      AfterUserEvent := nil;
    end);

  end else begin

    var Word: string;

    if (CurrentBookmarksDb = HistoryDb) then
      Word := 'Clear'
    else
      Word := 'Delete';

    UserBooleanDialog('Are you sure ?' + SLineBreak + Word + ' bookmarks group: ' + CurrentBookmarkGroup.Name,
    procedure
    begin
      if UserSayYes then begin
        if (CurrentBookmarksDb = HistoryDb) then
          CurrentBookmarkGroup.ClearGroup
        else
          CurrentBookmarkGroup.DeleteGroup;

        CurrentBookmarkControl := nil;
      end;
      GotoBookmarksMenu(CurrentBookmarksDb);
      AfterUserEvent := nil;
    end);

  end;
end;

procedure TForm1.BMarkOpen(AOpenLastPage: boolean);
var
  Req: TNBoxSearchReqBookmarks;
  I: integer;
  Groups: TBookmarkGroupRecAr;
begin
  if DoWithAllItems then begin

    Groups := CurrentBookmarksDb.GetBookmarksGroups;
    for I := 0 to Length(Groups) - 1 do begin
      Req := TNBoxSearchReqBookmarks.Create;

      if AOpenLastPage then
        Req.PageId := Groups[I].GetMaxPage
      else
        Req.Pageid := 1;

      Req.Request := Groups[I].Id.ToString;

      if (CurrentBookmarksDb = HistoryDb) then
        Req.Path := HISTORY_BMRKDB
      else if (CurrentBookmarksDb = BookmarksDb) then
        Req.Path := REGULAR_BMRKDB;

      AddBrowser(Req);
      Browsers.Last.GoBrowse;
    end;

  end else begin

    Req := TNBoxSearchReqBookmarks.Create;

    if AOpenLastPage then
      Req.PageId := CurrentBookmarkGroup.GetMaxPage
    else
      Req.Pageid := 1;

    if (CurrentBookmarksDb = HistoryDb) then
      Req.Path := HISTORY_BMRKDB
    else if (CurrentBookmarksDb = BookmarksDb) then
      Req.Path := REGULAR_BMRKDB;

    Req.Request := CurrentBookmarkControl.Tag.ToString;
    AddBrowser(Req, true);

  end;

  CurrentBrowser := browsers.Last;
  ChangeInterface(Self.BrowserLayout);
end;

procedure TForm1.BtnBMarkOpenLastPageOnTap(Sender: TObject;
  const Point: TPointF);
begin
  BMarkOpen(True);
end;

procedure TForm1.BtnBMarkOpenOnTap(Sender: TObject; const Point: TPointF);
begin
  BMarkOpen(False);
end;

procedure TForm1.BtnBMarkSaveChangesOnTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(AfterUserEvent) then
    AfterUserEvent;
end;

procedure TForm1.BtnDialogNoOnTap(Sender: TObject; const Point: TPointF);
begin
  UserSayYes := false;
  if Assigned(AfterUserEvent) then
    AfterUserEvent;
end;

procedure TForm1.BtnDialogYesOnTap(Sender: TObject; const Point: TPointF);
begin
  UserSayYes := true;
  if Assigned(AfterUserEvent) then
    AfterUserEvent;
end;

procedure TForm1.BtnItemMenuOnTap(Sender: TObject; const Point: TPointF);
var
  Action: TNBoxItemInteraction;
  I: integer;
begin
  Action := TNBoxItemInteraction(TControl(Sender).Tag);

  if DoWithAllItems and ( CurrentBrowser.Items.Count > 0 ) then begin

    if ( Action = ACTION_ADD_BOOKMARK ) then begin

        UserSelectBookmarkList(
        procedure
        var
          Table: TBookmarkGroupRec;
          I: integer;
          Items: TArray<IHasOrigin>;
        begin
          if Assigned(CurrentBookmarkControl) then begin
            Table := BookmarksDb.GetGroupById(CurrentBookmarkControl.Tag);
            if ( Table.Id <> -1 ) then begin
              SetLength(Items, CurrentBrowser.Items.Count);
              for I := 0 to ( CurrentBrowser.Items.Count - 1 ) do begin
                var Card := CurrentBrowser.Items[I];
                if ( Card.HasBookmark and Card.Bookmark.IsRequest ) then
                  Items[I] := Card.Bookmark.AsRequest
                else if Card.HasPost then
                  Items[I] := Card.Post;
              end;

              if Length(Items) > 0 then begin
                Table.Add(Items);
                Items := nil;
              end;
            end;

            CurrentBookmarkControl := nil;
            ChangeInterface(Self.BrowserLayout);
          end;
        end);

    end else if (Action =  ACTION_DELETE_CARD) then begin

      if Assigned(CurrentBrowser) then begin
        CurrentBrowser.Clear;
      end;

    end else begin

      for I := 0 to CurrentBrowser.Items.Count - 1 do begin
        ExecItemInteraction(CurrentBrowser.Items[I], Action);
      end;

    end;

  end else begin
    if Assigned(CurrentItem) then
      ExecItemInteraction(CurrentItem, Action);
  end;

  if ( MenuItem.Visible and Settings.AutoCloseItemMenu )
  or ( Action = ACTION_DELETE_CARD ) then
    ChangeInterface(form1.BrowserLayout);
end;

procedure TForm1.BtnNextOnTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(CurrentBrowser) then
    CurrentBrowser.GoNextPage;
end;

procedure TForm1.BtnPrevOnTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(CurrentBrowser) then
    CurrentBrowser.GoPrevPage;
end;

procedure TForm1.BtnOpenAppRepOnTap(Sender: TObject; const Point: TPointF);
const              { https://github.com/Kisspeace/NsfwBox }
  GH_PAGE: string = 'https://github.com/101427274/505234915';
begin
  {$IFDEF ANDROID}
    StartActivityView(GH_PAGE);
  {$ENDIF} {$IFDEF MSWINDOWS}
    ShellExecute(0, 'open', Pchar(GH_PAGE), nil, nil, SW_SHOWNORMAL);
  {$ENDIF}
end;

procedure TForm1.BtnSearchAddBookmarkOnTap(Sender: TObject;
  const Point: TPointF);
begin
  UserSelectBookmarkList(procedure
  begin
    if Assigned(CurrentBookmarkControl) then begin
      if ( CurrentBookmarkGroup.Id <> -1 ) then
      CurrentBookmarkGroup.Add(SearchMenu.Request);
      CurrentBookmarkControl := nil;
      ChangeInterface(MenuSearchSettings);
    end;
  end);
end;

procedure TForm1.BtnSearchSetDefaultOnTap(Sender: TObject;
  const Point: TPointF);
begin

end;

procedure TForm1.BtnSendMsgForDevOnTap(Sender: TObject; const Point: TPointF);
var
  Success: boolean;
begin
  try
    Success := NsfwBox.MessageForDeveloper.SendMessage(
      EditNickMsgForDev.Edit.Text,
      Trim(MemoMsgForDev.Memo.Text));
  except
    Success := false;
  end;

  if Success then begin
    MemoMsgForDev.Memo.Lines.Clear;
    Showmessage('Success!');
  end else
    ShowMessage('Error.');
end;

procedure TForm1.BtnSetAnonMsgOnTap(Sender: TObject; const Point: TPointF);
begin
  ChangeInterface(MenuAnonMessage);
end;

procedure TForm1.BtnSetChangeOnItemTapOnTap(Sender: TObject;
  const Point: TPointF);
begin
  ChangeInterface(CheckMenuSetOnItemTap);
end;

procedure TForm1.BtnSetChangeThemeOnTap(Sender: TObject; const Point: TPointF);
begin
  ChangeInterface(MenuChangeTheme);
end;

procedure TForm1.BtnSetSaveOnItemTapOnTap(Sender: TObject;
  const Point: TPointF);
begin
  FSettings.ItemInteractions := CheckMenuSetOnItemTap.Checked;
  ChangeInterface(MenuSettings);
end;

procedure TForm1.BtnSetSaveOnTap(Sender: TObject; const Point: TPointF);
var
  NewSet: TNsfwBoxSettings;
  tmp: integer;
begin
  NewSet := TNsfwBoxSettings.Create;
  with NewSet do begin
    StyleName        := Settings.StyleName;
    ItemInteractions := Settings.ItemInteractions;
    DefaultUseragent := EditSetDefUseragent.Edit.Edit.Text;
    AllowCookies     := CheckSetAllowCookies.IsChecked;
    DefDownloadPath  := EditSetDefDownloadPath.Edit.Edit.Text;
    FilenameLogurls  := EditSetFilenameLogUrls.Edit.Edit.Text;
    {$IFDEF MSWINDOWS}
    ContentPlayApp    := EditSetPlayApp.Edit.Edit.Text;
    ContentPlayParams := EditSetPlayParams.Edit.Edit.Text;
    {$ENDIF}

    if trystrtoint(self.EditSetThreadsCount.Edit.Edit.Text, tmp) then
      ThreadsCount := tmp
    else
      ThreadsCount := 6;

    if tryStrtoint(Self.EditSetLayoutsCount.Edit.Edit.Text, tmp) then
      ContentLayoutsCount := tmp
    else
      ContentLayoutsCount := 2;

    if tryStrToInt(Self.EditSetItemIndent.Edit.Edit.Text, tmp) then
      ItemIndent := tmp
    else
      ItemIndent := 2;

    if tryStrtoint(Self.EditSetMaxDownloadThreads.Edit.Edit.Text, tmp) then
      MaxDownloadThreads := tmp
    else
      MaxDownloadThreads := 2;

    DownloadManager.MaxThreadCount := MaxDownloadThreads;

    Fullscreen           := CheckSetFullscreen.IsChecked;
    ShowCaptions         := CheckSetShowCaptions.IsChecked;
    AutoStartBrowse      := CheckSetAutoStartBrowse.IsChecked;
    AutoCloseItemMenu    := CheckSetAutoCloseItemMenu.IsChecked;
    AllowDuplicateTabs   := CheckSetAllowDuplicateTabs.IsChecked;
    DevMode              := CheckSetDevMode.IsChecked;
    AutoSaveSession      := CheckSetAutoSaveSession.IsChecked;
    SaveSearchHistory    := CheckSetSaveSearchHistory.IsChecked;
    SaveDownloadHistory  := CheckSetSaveDownloadHistory.IsChecked;
    SaveTapHistory       := CheckSetSaveTapHistory.IsChecked;
    SaveClosedTabHistory := CheckSetSaveTabHistory.IsChecked;
    AutoCheckUpdates     := CheckSetAutoCheckUpdates.IsChecked;
    ShowScrollbars       := CheckSetShowScrollBars.IsChecked;
    ShowNavigateBackButton := CheckSetShowNavigateBackButton.IsChecked;
    BrowseNextPageByScrollDown := CheckSetBrowseNextPageByScrollDown.IsChecked;

    if AutoSaveSession then
      ConnectSession;
  end;

  Settings := NewSet;
  NewSet.Free;
  SaveSettings;
  ChangeInterface(BrowserLayout);
end;

procedure TForm1.BtnSetViewLogOnTap(Sender: TObject; const Point: TPointF);
begin
  ChangeInterface(MenuLog);
end;

procedure TForm1.BtnTabCloseOnTap(Sender: TObject; const Point: TPointF);
var
  B: TNBoxBrowser;
  NewCount: integer;
begin
  B := ((Sender as TControl).Owner.Owner as TNBoxBrowser);

  if Settings.SaveClosedTabHistory then
    HistoryDb.TabGroup.Add(B.Request);  // Save this tab on history

  NewCount := Browsers.Count - 1;

  if (CurrentBrowser = B) and (NewCount > 0) then begin
    if (CurrentBrowser = Browsers.Last) and (NewCount > 1) then
      CurrentBrowser := Browsers.First
    else
      CurrentBrowser := Browsers.Last;
  end;

  DeleteBrowser(B);
end;

procedure TForm1.ChangeInterface(ALayout: TControl);
var
  I: integer;
  Post: INBoxitem;

  procedure _ChangeMenuMode(AControls: TControlList; AMultiple: boolean);
  var
    I: integer;
    LControl: TControl;
  begin
    For I := 0 to AControls.Count - 1 do begin
      LControl := AControls.Items[I];
      if AMultiple then
        LControl.Visible := ( LControl.TagString = TAG_CAN_USE_MORE_THAN_ONE )
      else
        LControl.Visible := true;
    end;
  end;

  procedure _SetVisible(AControls: TControlList; AVisible: boolean);
  var
    I: integer;
  begin
    for I := 0 to AControls.Count - 1 do
      AControls[I].Visible := AVisible;
  end;

  procedure _ResetPos(AControls: TControlList);
  var
    I: integer;
  begin
    for I := 0 to AControls.Count - 1 do
      AControls[I].Position.Y := Single.MaxValue;
  end;

begin
  Form1.MVMenu.HideMaster;
  for I := 0 to MainLayout.Controls.Count - 1 do begin
    MainLayout.Controls.Items[I].Visible := false;
  end;

  if ( ALayout = BrowserLayout ) then begin
  { Browser }
    BtnPrev.Visible := Settings.ShowNavigateBackButton;

  end else if ( ALayout = MenuSettings ) then begin
  { App settings menu }
    Settings := Settings;

  end else if ( ALayout = CheckMenuSetOnItemTap ) then begin
  { Menu change Card.OnTap actions }
    CheckMenuSetOnItemTap.Checked := Settings.ItemInteractions

  end else if ( ALayout = MenuChangeTheme ) then begin
  { Menu for change app theme\style }
    var ThemeFiles: TSearchRecAr;
    ThemeFiles := GetFiles(TPath.Combine(TNBoxPath.GetThemesPath, '*'));
    MenuChangeTheme.ClearButtons;
    for I := 0 to High(ThemeFiles) do begin
      if (pos('.json', ThemeFiles[I].Name) > 0) then
        MenuChangeTheme.AddBtn(ThemeFiles[I].Name, 0, ICON_NSFWBOX, true);
    end;

  end else if ( ALayout = MenuLog ) then begin
  { Menu with app log }
    if FileExists(LOG_FILENAME) then
      MemoLog.Memo.Lines.LoadFromFile(LOG_FILENAME);

    MemoLog.Memo.GoToTextEnd;

  end else if ( ALayout = MenuBookmarks ) then begin
  { Menu with bookmark groups }
    ReloadBookmarks(BookmarksDb, MenuBookmarks);

  end else if ( ALayout = MenuHistory ) then begin
  { Menu with bookmark groups but on HistoryDb }
    ReloadBookmarks(HistoryDb, MenuHistory);

  end else if ( ALayout = MenuBookmarksChange ) then begin
  { Menu for change bookmark group data }
    if Assigned(CurrentBookmarkControl) then begin
      EditBMarkName.Edit.Text := CurrentBookmarkGroup.Name;
      MemoBmarkAbout.Memo.Lines.Text := CurrentBookmarkGroup.About;
    end;

  end else if ( ALayout = MenuBookmarksDoList ) then begin
  { Menu with list of actions for selected bookmark list }
    _ChangeMenuMode(ButtonsBMark, DoWithAllItems);
    BtnBmarkCreate.Visible := DoWithAllItems;

  end else if ( ALayout = MenuItem ) then begin
  { Menu with CurrentItem (card) actions }
    if not DoWithAllItems then begin

      if CurrentItem.HasPost then begin
        _SetVisible(ButtonsItemMenu, true);
        Post := CurrentItem.Post;
        BtnShowTags.Visible    := Supports(Post, IHasTags);
        BtnOpenAuthor.Visible  := Supports(Post, IHasAuthor);
        BtnOpenRelated.Visible := ( Post is TNBoxNsfwXxxItem );
        BtnBrowse.Visible      := false;
      end else if CurrentItem.Bookmark.IsRequest then begin
        _SetVisible(ButtonsItemMenu, false);
        BtnBrowse.Visible      := true;
      end;
      BtnAddBookmark.Visible := true;
      BtnDeleteBookmark.Visible := CurrentItem.HasBookmark;

    end else begin
      _ChangeMenuMode(ButtonsItemMenu, DoWithAllItems);
    end;
    _ResetPos(ButtonsItemMenu);
  end;

  NowUserSelect := false;
  ALayout.Visible := true;
end;

procedure TForm1.ClickTapRef(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  with Sender as TControl do begin
    Ontap(Sender, TPointF.Create(0, 0));
  end;
  {$ENDIF}
end;

procedure TForm1.CloseDownloadTabOnTap(Sender: TObject; const Point: TPointF);
var
  Tab: TNBoxTab;
  Loader: TNetHttpDownloader;
begin
  try
    Tab := ( TControl(Sender).Parent as TNBoxTab );
    if Assigned(Tab.TagObject) then begin
      Loader := ( Tab.TagObject as TNetHttpDownloader );
      if Loader.IsRunning or (not Loader.IsAborted) then begin
        Loader.AbortRequest;
        Tab.Visible := false;
      end;
    end;
  except
    On E: Exception do begin
      Log(E, 'TForm1.CloseDownloadTabOnTap: ');
    end;
  end;
end;

procedure TForm1.ConnectSession;
begin
  if Length(Session.GetBookmarksGroups) < 1 then begin
    Session.AddGroup('session', 'tabs here');
  end;
end;

function RandReq: INBoxSearchRequest;
begin
  Result := nil;
  Result := TNBoxSearchReqNsfwxxx.Create;
end;

function TForm1.CreateDefBrowser(AOwner: TComponent): TNBoxBrowser;
begin
  Result := TNBoxBrowser.Create(AOwner);
  with Result do begin
    Align                    := TAlignlayout.Contents;
    MultiLayout.BlockCount   := Settings.ContentLayoutsCount;
    MultiLayout.LayoutIndent := Settings.ItemIndent;
    MaxParallelThumbLoaders  := Settings.ThreadsCount;
    Request                  := RandReq;
    Result.OnWebClientCreate := OnBrowserSetWebClient;
    Result.OnScraperCreate   := form1.OnBrowserScraperCreate;
    visible                  := false;
    ImageManager             := BrowsersIWUContentManager;
    OnViewportPositionChange := OnBrowserViewportPositionChange;

    if Self.FFormCreated then
      ShowScrollBars := Settings.ShowScrollBars;
  end;
end;

function TForm1.CreateDefButton(AOwner: TComponent; AStyle: integer): TRectButton;
begin
  Result := TRectButton.Create(AOwner);
  with Result do begin

    case Astyle of

      BTN_STYLE_DEF: begin
        AppStyle.Button.Apply(Result);
      end;

      BTN_STYLE_ICON: begin
        AppStyle.ButtonIcon.Apply(Result);
        text.Visible := false;
      end;

      BTN_STYLE_ICON2: begin
        AppStyle.ButtonIcon2.Apply(Result);
        Text.Visible := false;
      end;

      BTN_STYLE_ICON3: begin
        AppStyle.ButtonIcon3.Apply(Result);
        Text.Visible := false;
      end;

      BTN_STYLE_DEF2: begin
        AppStyle.Button2.Apply(Result);
      end;

    end;

    Text.Font.Size := 12;
    Text.Color := AppStyle.TextColors[0];
    Image.WrapMode := TAlImageWrapMode.Stretch;
    Image.OnResize := IconOnResize;
    Height := BUTTON_HEIGHT;
    Image.OnResize(Image);
  end;
end;

function TForm1.CreateDefCheck(AOwner: TComponent): TRectTextCheck;
const
  LP: single = 2;
begin
  Result := TRectTextCheck.Create(AOwner);
  with Result do begin
    Padding.Rect := TRectF.Create(LP, LP, LP, LP);
    Text.HorzTextAlign := TTextAlign.Center;
    Text.VertTextAlign := TTextAlign.Center;
    Text.Color := AppStyle.TextColors[0];
    Text.Font.Size := 11;
    AppStyle.Checkbox.Apply(Result);
    Height := CONTROLS_DEF_HEIGHT;
  end;
end;

function TForm1.CreateDefCheckButton(AOwner: TComponent;
  AStyle: integer): TNBoxCheckButton;
begin
  Result := TNBoxCheckButton.Create(AOwner);
  with Result do begin

    Case AStyle of
      BTN_STYLE_DEF: begin
        AppStyle.CheckButton.Apply(Result);
      end;

      BTN_STYLE_DEF2: begin
        AppStyle.CheckButtonSettings.Apply(Result);
      end;
    End;

    Height := CONTROLS_DEF_HEIGHT;
    Check.OnResize := IconOnResize;
    Image.OnResize := IconOnResize;
    Text.Font.Size := 11;
    Text.Color := AppStyle.TextColors[0];
    Image.WrapMode := TAlImageWrapMode.Stretch;
    Image.OnResize(Image);
    Check.OnResize(Check);
  end;
end;

function TForm1.CreateDefEdit(AOwner: TComponent; AStyle: integer): TNBoxEdit;
begin
  Result := TNBoxEdit.Create(AOwner);
  with Result do begin
    AppStyle.Edit.Apply(Result);
    Height := EDIT_DEF_HEIGHT;
  end;
end;

function TForm1.CreateDefMemo(AOwner: TComponent; AStyle: integer): TNBoxMemo;
begin
  Result := TNBoxMemo.Create(AOwner);
  with Result do begin
    Memo.TextSettings.FontColor := AppStyle.TextColors[0];
    Memo.TextSettings.WordWrap := true;
    AppStyle.Memo.Apply(Result);
    Memo.TextSettings.FontColor := AppStyle.TextColors[1];
  end;
end;

function TForm1.CreateDefRadioButton(AOwner: TComponent;
  AStyle: integer): TNBoxRadioButton;
begin
  Result := TNBoxRadioButton.Create(AOwner);
  with Result do begin
    AppStyle.CheckButton.Apply(Result);
    Height := CONTROLS_DEF_HEIGHT;
  end;
end;

function TForm1.CreateDefRect(AOwner: TComponent): TAlRectangle;
begin
  Result := TAlRectAngle.Create(AOwner);
  with Result do begin

    Stroke.Kind := TBrushKind.None;
  end;
end;

function TForm1.CreateDefScraper: TNBoxScraper;
begin
  Result := TNBoxScraper.Create;
  with Result do begin
    OnWebClientSet := Form1.OnBrowserSetWebClient;
  end;
end;

function TForm1.CreateDefScroll(AOwner: TComponent): TVertScrollBox;
begin
  Result := TVertScrollBox.Create(AOwner);
  with Result do begin
    Align := TAlignlayout.Client;
    if Self.FFormCreated then
      ShowScrollBars := Settings.ShowScrollBars;
  end;
end;

procedure _CreateDefSettingsCheckDef(AValue: TNBoxSettingsCheck);
begin
  with AValue do begin
    Check.Image.Visible := false;
    Padding.Rect := TrectF.Create(7, 7, 7, 7);
    form1.AppStyle.SettingsRect.Apply(AValue);
    Check.Text.Color := Form1.AppStyle.TextColors[0];
    Check.Text.Font.Size := 11;
    Text.Color := Form1.AppStyle.TextColors[1];
    Text.Font.Size := Check.Text.Font.Size;
    Height := BUTTON_HEIGHT + Padding.Top + Padding.Bottom;
  end;
end;

function TForm1.CreateDefSettingsCheck(AOwner: TComponent): TNBoxSettingsCheck;
begin
  Result := TNBoxSettingsCheck.Create(AOwner);
  _CreateDefSettingsCheckDef(Result);
end;

function TForm1.CreateDefSettingsEdit(AOwner: TComponent; AStyle: integer): TNBoxSettingsEdit;
begin
  Result := TNBoxSettingsEdit.Create(AOwner);
  _CreateDefSettingsCheckDef(Result);
  with Result do begin
    Edit.Margins.Top := 7;
    case AStyle of
      EDIT_STYLE_INT: begin
        with Edit.Edit do begin
          Textsettings.HorzAlign := TtextAlign.Center;
          KeyboardType := TVirtualKeyboardType.NumberPad;
          FilterChar := '1234567890';
          Text := '0';
        end;
      end;
    end;
  end;
end;

function TForm1.CreateDefTab(AOwner: TComponent): TNBoxTab;
begin
  Result := TNBoxTab.Create(AOwner);
  with Result do begin
    Image.WrapMode := TAlImageWrapMode.Stretch;
    Image.OnResize := IconOnResize;
    with CloseBtn do begin
      Text.Color := AppStyle.TextColors[0];
      Image.WrapMode := TAlImageWrapMode.Stretch;
      Image.OnResize := IconOnResize;
    end;
    AppStyle.tab.Apply(result);
    Height := TAB_DEF_HEIGHT;
  end;
end;

function TForm1.CreateDefText(AOwner: TComponent; AStyle: integer): TAlText;
begin
  Result := TAlText.Create(AOwner);
  with Result do begin
    Color := AppStyle.TextColors[AStyle];
    case AStyle of
      0: Font.Size := 16;
      1: Font.Size := 12;
    end;
    TextSettings.VertAlign := TTextAlign.Center;
    TextSettings.HorzAlign := TTextAlign.Leading;
  end;
end;

function TForm1.CreateTabText(ABrowser: TNBoxBrowser): string;
var
  Req: INBoxSearchRequest;
begin
  Req := ABrowser.Request;
  Result := Req.Request;

  if ( Result.IsEmpty ) then begin

    if ( Req is TNBoxSearchReqCoomerParty ) then begin
      var LReq: TNBoxSearchReqCoomerParty;
      LReq := (Req as TNBoxSearchReqCoomerParty);
      if ( not LReq.UserId.IsEmpty ) then
        Result := LReq.UserId;
    end;

    if ( Result.IsEmpty ) then
      Result := 'empty';

  end;

  Result := Result + ': ' + ABrowser.Request.PageId.ToString + ' | '
    + ABrowser.Items.Count.ToString;
end;

procedure TForm1.DeleteBrowser(ABrowser: TNBoxBrowser);
var
  LBrowserIndex, LTabIndex: integer;
  Groups: TBookmarkGroupRecAr;
  Group: TBookmarkGroupRec;
begin
  if ABrowser = FCurrentBrowser then
    FCurrentBrowser := nil;

  LBrowserIndex := Browsers.IndexOf(ABrowser);
  if ( LBrowserIndex = -1 ) then
    exit;

  LTabIndex := IndexTabByBrowser(ABrowser);
  if ( LTabIndex = -1 ) then
    exit;

  ABrowser.Visible := false;
  Tabs.Items[LTabIndex].Visible := false;

  if ABrowser.Tag <> -1 then begin
    Groups := Session.GetBookmarksGroups;
    if Length(Groups) > 0 then begin
      Group := Groups[0];
      Group.Delete(ABrowser.Tag);
    end;
  end;

  ABrowser.Free;
  Browsers.Delete(LBrowserIndex);
  Tabs.Delete(LTabIndex);
end;

procedure TForm1.ExecItemInteraction(AItem: TNBoxCardBase;
  AInteraction: TNBoxItemInteraction);
var
  I: integer;
  LPost: INBoxItem;
  LRequest: INBoxSearchRequest;
  LBookmark: TNBoxBookmark;
  LTmpReq: INBoxSearchRequest;

  procedure LTryFetchIfEmpty;
  var
    LScraper: TNBoxScraper;
  begin
    if Supports(LPost, IFetchableContent)
    And ( not (LPost as IFetchableContent).ContentFetched ) then begin
      LScraper := Form1.CreateDefScraper;
      try
        try
          LScraper.FetchContentUrls(LPost);
        finally
          LScraper.Free;
        end;
      except
        On E: Exception do begin
          Log(E, 'ExecItemInteraction TryFetchContent: ');
          ShowMessage(E.Message);
        end;
      end;
    end;
  end;

begin
  LRequest := nil;
  LTmpReq := nil;
  LPost := AItem.Post;
  LBookmark := Aitem.Bookmark;

  if Aitem.HasBookmark then
    LRequest := LBookmark.AsRequest;

  case AInteraction of

    ACTION_DELETE_CARD:
    begin
      if Assigned(CurrentBrowser) then begin
        I := CurrentBrowser.Items.IndexOf(Aitem);
        if ( I <> -1 ) then
          CurrentBrowser.Items.Delete(I);
      end;
    end;

    ACTION_OPEN_MENU: GotoItemMenu(AItem);

    ACTION_BROWSE:
    begin
      if not Assigned(Lrequest) then exit;
      AddBrowser(Lrequest.Clone, Settings.AutoStartBrowse);
    end;

    ACTION_DOWNLOAD_ALL:
    begin
      if not AItem.HasPost then exit;
      AddDownload(LPost);
    end;

    ACTION_PLAY_EXTERNALY:
    begin
      if not AItem.HasPost then exit;
      LTryFetchIfEmpty;
      {$IFDEF ANDROID}
      if ( LPost.ContentUrlCount > 0 ) then
        StartActivityView(LPost.ContentUrl);
      {$ENDIF} {$IFDEF MSWINDOWS}
      if ( LPost.ContentUrlCount > 0 ) then begin
        var LParams: string;
        LParams := Settings.ContentPlayParams.Replace(FORMAT_VAR_CONTENT_URL, LPost.ContentUrl);
        ShellExecute(0, 'open', PChar(Settings.ContentPlayApp), PChar(LParams), nil, SW_SHOWNORMAL);
      end;
      {$ENDIF}
    end;

    ACTION_LOG_URLS:
    begin
      try
        if not AItem.HasPost then exit;
        var urls: string := '';

        LTryFetchIfEmpty;

        for I := 0 to LPost.ContentUrlCount - 1 do
          urls := urls + LPost.ContentUrls[I] + SLineBreak;

        if not urls.IsEmpty then
          WriteToFile(Settings.FilenameLogUrls, urls);
      except
        on E: Exception do Log(E, 'ACTION_LOG_URLS: ');
      end;
    end;

    ACTION_OPEN_RELATED:
    begin
      if not AItem.HasPost then exit;
      LTmpReq := CreateRelatedReq(LPost);
      if Assigned(LTmpReq) then begin
        AddBrowser(LTmpReq, Settings.AutoStartBrowse);
      end;
    end;

    ACTION_OPEN_AUTHOR:
    begin
      if not AItem.HasPost then exit;
      LTmpReq := CreateAuthorReq(LPost);
      if Assigned(LTmpReq) then begin
        AddBrowser(LTmpReq, Settings.AutoStartBrowse);
      end;
    end;

    ACTION_ADD_BOOKMARK:
    begin
      UserSelectBookmarkList(
      procedure
      var
        Table: TBookmarkGroupRec;
      begin
        if Assigned(CurrentBookmarkControl) then begin
          Table := BookmarksDb.GetGroupById(CurrentBookmarkControl.Tag);
          if ( Table.Id <> -1 ) then begin
            if Assigned(LRequest) then
              Table.Add(LRequest)
            else
              Table.Add(LPost);
          end;

          CurrentBookmarkControl := nil;
          ChangeInterface(Self.BrowserLayout);
        end;
      end);
    end;

    ACTION_DELETE_BOOKMARK:
    begin
      if not Aitem.HasBookmark then exit;
      BookmarksDb.Delete(LBookmark.Id);
    end;

    ACTION_SHOW_TAGS:
    begin
      if not Aitem.HasPost then exit;
      if Supports(LPost, IHasTags) then begin

        LTryFetchIfEmpty;

        var tags_ar: TArray<string>;
        tags_ar := (LPost as IHasTags).Tags;
        GotoItemTagsMenu(tags_ar, LPost.Origin);

      end;
    end;

    ACTION_COPY_THUMB_URL:
    begin
      if Assigned(LPost) then
        CopyToClipboard(LPost.ThumbnailUrl);
    end;

    ACTION_COPY_CONTENT_URLS:
    begin
      if not Assigned(LPost) then exit;
      LTryFetchIfEmpty;
      CopyToClipboard(trim(ConcatS(LPost.ContentUrls)));
    end;

    ACTION_SHOW_FILES:
    begin
      if not Assigned(LPost) then exit;
      LTryFetchIfEmpty;
      var LBrowserTab: TNBoxTab;
      var LBrowser: TNBoxBrowser;
      LBrowserTab := self.AddBrowser(nil, false);
      LBrowser := TNBoxBrowser(LBrowserTab.Owner);
      
      for I := 0 to LPost.ContentUrlCount - 1 do begin
        var LNewCard := LBrowser.NewItem;
        var LFileItem := TNBoxPseudoItem.Create;
        var LThumbSet: boolean := false;

        LFileItem.ContentUrls := [LPost.ContentUrls[I]]; // One URL per file

        if LPost is TNBoxCoomerPartyItem then begin
          var LCoomerPost := (LPost as TNBoxCoomerPartyItem);
          if I < Length(LCoomerPost.Item.Thumbnails) then begin
            LFileItem.ThumbnailUrl := LCoomerPost.Site + LCoomerPost.Item.Thumbnails[I];
            LThumbSet := True;
          end;
        end else if LPost is TNBox9HentaitoItem then begin
          var L9HentItem := (LPost as TNBox9HentaitoItem);
          if I <= L9HentItem.Item.TotalPage then begin
            LFileItem.ThumbnailUrl := L9HentItem.Item.GetImageThumbUrl(I + 1);
            LThumbSet := True;
          end;
        end;


        if not LThumbSet then
          LFileItem.ThumbnailUrl := LPost.ThumbnailUrl;  
        
        LNewCard.Item := LFileItem;   
        LNewCard.Fill.Kind := TBrushkind.Bitmap;
        LNewCard.ImageURL := LNewCard.Post.ThumbnailUrl; // Start thumbnail load image
      end;

      Self.CurrentBrowser := LBrowser;
      LBrowserTab.Text.Text := 'Files list (' + LBrowser.Items.Count.ToString + ')';
      
    end;

  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  log('Destroing app');
  DownloadFetcher.Free;
  DownloadManager.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: integer;
  Control: TControl;

  procedure SetClick(A: TControl);
  var
    I: integer;
  begin
    if Assigned(A.OnTap) then
      A.OnClick := ClickTapRef;
    for I := 0 to A.Controls.Count - 1 do begin
      SetClick(A.Controls.Items[I]);
    end;
  end;

  function AddBottomLayout(AOwner: TFmxObject; AHeight: single): TLayout;
  begin
    Result := TLayout.Create(AOwner);
    with Result do begin
      parent := AOwner;
      Align := TAlignLayout.Top;
      Height := AHeight;
      Position.Y := Single.MaxValue;
    end;
  end;

begin
  FFormCreated := false;
  APP_VERSION := GetAppVersion;
  FCurrentBrowser := nil;

  SETTINGS_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, SETTINGS_FILENAME);
  BOOKMARKSDB_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, BOOKMARKSDB_FILENAME);
  SESSION_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, SESSION_FILENAME);
  HISTORY_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, HISTORY_FILENAME);
  LOG_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, LOG_FILENAME);
  TNBoxPath.CreateThumbnailsDir;
  FSettings := nil;
  FAppStyle := TNBoxGuiStyle.Create;

  Application.OnException := AppOnException;

  if not loadSettings then begin
    form1.RestoreDefaultSettings;
    SaveSettings;
  end;
  LoadStyle;

  {$IFDEF ANDROID}
    Form1.MVMenu.Mode := TMultiviewMode.Drawer;
  {$ENDIF}

  {$IFDEF MSWINDOWS}
    fSettings.Fullscreen := false;
    form1.Width := round(form1.Height * 1.6);
  {$ENDIF}

  Log('|-----------Application start ' + APP_VERSION.ToGhTagString + '---------------|');


  IWUCacheManager := TIWUCacheManager.Create(Self);
  IWUCacheManager.SetSaveAndLoadPath(Tpath.Combine(TNBoxPath.GetCachePath, 'thumbnails'));

  // IWU content manager for browsers only
  BrowsersIWUContentManager := TIWUContentManager.Create(Self);
  BrowsersIWUContentManager.OnImageLoadException := OnIWUException;
  BrowsersIWUContentManager.LoadThumbnailFromFile := True;
  BrowsersIWUContentManager.CacheManager := IWUCacheManager;

  // IWU content manager for other app images (like buttons)
  IWUContentManager := TIWUContentManager.Create(Self);
  IWUContentManager.OnImageLoadException := OnIWUException;
  IWUContentManager.LoadThumbnailFromFile := False;
  IWUContentManager.CacheManager := IWUCacheManager;

  DownloadItems := TNBoxTabList.Create;
  DownloadManager := TNBoxDownloadManager.Create(self);
  with Downloadmanager do begin
    OnCreateDownloader := self.OnCreateDownloader;
    OnStartDownloader  := Self.OnStartDownloader;
  end;

  DownloadFetcher := TNBoxFetchManager.Create(nil);
  DownloadFetcher.OnWebClientSet := Self.OnBrowserSetWebClient;
  DownloadFetcher.OnFetched := Self.DownloadFetcherOnFetched;

  Tabs := TNBoxTabList.Create;
  Browsers := TNBoxBrowserList.Create;
  ButtonsItemMenu := TControlList.Create;
  ButtonsBMark    := TControlList.Create;

  MemoLog := CreateDefMemo(MenuLog);
  with memoLog do begin
    parent := Menulog;
    Margins.Rect := TRectF.Create(6, 6, 6, 6);
    Align := TAlignLayout.Client;
  end;

  TopRect := CreateDefRect(form1);
  With TopRect do begin
    AppStyle.Topbar.Apply(TopRect.Fill);
    Align := TAlignlayout.MostTop;
    Parent := form1;
    Height := TOPRECT_HEIGHT;
  end;

  TopBtnApp := CreateDefButton(TopRect, BTN_STYLE_ICON3);
  with TopBtnApp do begin
    Parent := TopRect;
    Align := TAlignlayout.MostLeft;
    Image.FileName := AppStyle.GetImagePath(ICON_NSFWBOX);
    OnTap := TopBtnAppOnTap;
  end;

  TopTextLayout := TLayout.Create(TopRect);
  with TopTextLayout do begin
    Parent := TopRect;
    Align := TAlignLayout.Client;
    Padding.Top := 4;
    Padding.Bottom := 4;
  end;

  TopText := CreateDefText(TopTextLayout, 0);
  with TopText do begin
    Align := TAlignlayout.MostTop;
    AutoSize := true;
    Text := 'NsfwBox';
    parent := TopTextLayout;
  end;

  TopBottomText := CreateDefText(TopTextLayout, 1);
  with TopBottomText do begin
    Align := TAlignlayout.Top;
    AutoSize := true;
    Parent := TopTextLayout;
  end;
  {$IFDEF ANDROID}
  SubHeader := 'Make L☮ve, not war';
  {$ENDIF} {$IFDEF MSWINDOWS}
  SubHeader := 'Make Love, not war';
  {$ENDIF}

  TopBtnSearch := CreateDefButton(TopRect, BTN_STYLE_ICON2);
  with TopBtnSearch do begin
    parent := TopRect;
    align := TAlignlayout.right;
    Image.FileName := AppStyle.GetImagePath(ICON_SEARCH);
    OnTap := TopBtnSearchOnTap;
  end;

  TopBtnPopMenu := CreateDefButton(TopRect, BTN_STYLE_ICON2);
  with TopBtnPopMenu do begin
    Parent := TopRect;
    Align := TALignlayout.MostRight;
    Image.FileName := AppStyle.GetImagePath(ICON_MENU);
    OnTap := TopBtnPopMenuOnTap;
  end;

  MVRect := CreateDefRect(MVMenu);
  With MVRect do begin
    AppStyle.Multiview.Apply(MVRect.Fill);
    Align := TAlignLayout.Contents;
    Parent := MVMenu;
  end;

  BtnNext := CreateDefButton(BrowserBtnsLayout, BTN_STYLE_ICON);
  with BtnNext do begin
    Parent := BrowserBtnsLayout;
    Align := TAlignLayout.Right;
    OnTap := BtnNextOnTap;
    Width := Height;
    Image.FileName := AppStyle.GetImagePath(ICON_NEXT);
  end;

  BtnPrev := CreateDefButton(BrowserBtnsLayout2, BTN_STYLE_ICON);
  with BtnPrev do begin
    Parent := BrowserBtnsLayout2;
    Align := TAlignLayout.Right;
    OnTap := BtnPrevOnTap;
    Width := Height;
    Image.FileName := AppStyle.GetImagePath(ICON_NEXT);
    Image.RotationAngle := 180;
  end;

  MVMenuScroll := CreateDefScroll(MVRect);
  MVMenuScroll.Parent := MVRect;

  TabsScroll := MVMenuScroll;

  MenuBtnDownloads := AddMenuBtn;
  with MenuBtnDownloads do begin
    Text.Text := 'Downloads';
    IMage.FileName := AppStyle.GetImagePath(ICON_DOWNLOADS);
    OnTap := MenuBtnDownloadsOnTap;
  end;

  MenuBtnBookmarks := AddMenuBtn;
  with MenuBtnBookmarks do begin
    Text.Text := 'Bookmarks';
    Image.FileName := AppStyle.GetImagePath(ICON_BOOKMARKS);
    OnTap := MenuBtnBookmarksOnTap;
  end;

  MenuBtnBookmarks := AddMenuBtn;
  with MenuBtnBookmarks do begin
    Text.Text := 'History';
    Image.FileName := AppStyle.GetImagePath(ICON_HISTORY);
    OnTap := MenuBtnHistoryOnTap;
  end;

  MenuBtnSettings := AddMenuBtn;
  with MenuBtnSettings do begin
    Image.FileName := AppStyle.GetImagePath(ICON_SETTINGS);
    text.Text := 'Settings';
    OnTap := MenuBtnSettingsOnTap;
  end;

  MenuBtnNewTab := AddMenuBtn;
  with MenuBtnNewTab do begin
    image.FileName := AppStyle.GetImagePath(ICON_NEWTAB);
    Text.Text := 'Create new tab';
    OnTap := MenuBtnNewTabOnTap;
  end;

  SearchMenu := TNBoxSearchMenu.Create(self);
  with Searchmenu do begin
    Parent := MenuSearchSettings;
    Align := TAlignlayout.Client;
  end;

  BtnBrowse       := AddItemMenuBtn('Browse', ACTION_BROWSE, ICON_NEWTAB, TAG_CAN_USE_MORE_THAN_ONE);
  BtnDownloadAll  := AddItemMenuBtn('Download content', ACTION_DOWNLOAD_ALL, ICON_DOWNLOAD, TAG_CAN_USE_MORE_THAN_ONE);
  BtnDownloadMenu := AddItemMenuBtn('Show available files', ACTION_SHOW_FILES, ICON_DOWNLOAD);
  BtnPlay         := AddItemMenuBtn('Play externaly', ACTION_PLAY_EXTERNALY, ICON_PLAY);
  BtnAddBookmark  := AddItemMenuBtn('Add bookmark', ACTION_ADD_BOOKMARK, ICON_BOOKMARKS, TAG_CAN_USE_MORE_THAN_ONE);
  BtnOpenRelated  := AddItemMenuBtn('Open related', ACTION_OPEN_RELATED, ICON_NEWTAB, TAG_CAN_USE_MORE_THAN_ONE);
  BtnOpenAuthor   := AddItemMenuBtn('Open author', ACTION_OPEN_AUTHOR, ICON_NEWTAB, TAG_CAN_USE_MORE_THAN_ONE);
  BtnCopyFullUrl  := AddItemMenuBtn('Copy content url', ACTION_COPY_CONTENT_URLS, ICON_COPY);
  BtnCopyThumbUrl := AddItemMenuBtn('Copy thumbnail url', ACTION_COPY_THUMB_URL, ICON_COPY);
  BtnLogContentUrls := AddItemMenuBtn('Log content urls to file', ACTION_LOG_URLS, ICON_SAVE, TAG_CAN_USE_MORE_THAN_ONE);
  BtnShowTags       := AddItemMenuBtn('Show tags\categories', ACTION_SHOW_TAGS, ICON_TAG);
  //BtnShareContent := AddItemMenuBtn('Share content', ACTION_SHARE_CONTENT, ICON_COPY);
  BtnDeleteBookmark := AddItemMenuBtn('Delete from bookmarks', ACTION_DELETE_BOOKMARK, ICON_DELETE, TAG_CAN_USE_MORE_THAN_ONE);
  BtnDeleteCard     := AdditemMenuBtn('Delete (free object)', ACTION_DELETE_CARD, ICON_DELETE, TAG_CAN_USE_MORE_THAN_ONE);

  BtnOpenAppRep := AddSettingsButton('Author: Kisspeace ' + SLineBreak + 'Click to open GitHub repository', ICON_NSFWBOX);
  with BtnOpenAppRep do begin
    OnTap := BtnOpenAppRepOnTap;
    Height := Height * 1.5;
    Text.WordWrap := true;
  end;

  BtnSetAnonMsg := AddSettingsButton('Anonymous message for developer', ICON_TRANS);
  with BtnSetAnonMsg do begin
    OnTap := BtnSetAnonMsgOnTap;
    Height := Height * 1.25;
    Text.WordWrap := true;
  end;

  CheckSetFullscreen          := AddSettingsCheck('Fullscreen mode');
  CheckSetAllowCookies        := AddSettingsCheck('Allow cookies');
  CheckSetAutoSaveSession     := AddSettingsCheck('Auto save session');
  CheckSetSaveSearchHistory   := AddSettingsCheck('Save search history');
  CheckSetSaveDownloadHistory := AddSettingsCheck('Save download history');
  CheckSetSaveTapHistory      := AddSettingsCheck('Save tap history');
  CheckSetSaveTabHistory      := AddSettingsCheck('Save closed tab history');
  CheckSetShowCaptions        := AddSettingsCheck('Show content caption');

  CheckSetAllowDuplicateTabs  := AddSettingsCheck('Allow duplicate tabs');
  CheckSetAllowDuplicateTabs.Visible := false; // FIXME

  CheckSetBrowseNextPageByScrollDown := AddSettingsCheck('Browse next page by scrolling down');
  CheckSetAutoStartBrowse     := AddSettingsCheck('Auto start browse');
  CheckSetAutoCloseItemMenu   := AddSettingsCheck('Auto close item menu');
  CheckSetShowScrollBars      := AddSettingsCheck('Show scrollbars');
  CheckSetShowNavigateBackButton := AddSettingsCheck('Show navigate back button');
  EditSetDefUseragent         := AddSettingsEdit('Default Useragent string');
  EditSetDefDownloadPath      := AddSettingsEdit('Default downloads path');
  EditSetMaxDownloadThreads   := AddSettingsEdit('Max download threads count', '', EDIT_STYLE_INT);
  EditSetThreadsCount         := AddSettingsEdit('Threads count', '', EDIT_STYLE_INT);
  EditSetLayoutsCount         := AddSettingsEdit('Content layouts count', '', EDIT_STYLE_INT);
  EditSetItemIndent           := AddSettingsEdit('Items indent', '', EDIT_STYLE_INT);
  EditSetFilenameLogUrls      := AddSettingsEdit('Urls log filename');
  {$IFDEF MSWINDOWS}
  EditSetPlayApp              := AddSettingsEdit('Player application path');
  EditSetPlayParams           := AddSettingsEdit('Player params');
    EditSetPlayParams.Text.Text := FORMAT_VAR_CONTENT_URL + ' - being replaced with URL.';
    EditSetPlayParams.Size.Height := EditSetPlayParams.Height + 30;
  {$ENDIF}
  CheckSetDevMode             := AddSettingsCheck('Developer mode');
  CheckSetAutoCheckUpdates    := AddSettingsCheck('Auto check updates');

  CheckMenuSetOnItemTap := TNBoxCheckMenu.Create(MainLayout);
  with CheckMenuSetOnItemTap do begin
    Parent := MainLayout;
    Visible := false;
    Align := TAlignlayout.Client;

    AddCheck('Open menu', ACTION_OPEN_MENU);
    AddCheck('Download content', ACTION_DOWNLOAD_ALL);
    AddCheck('Play externaly', ACTION_PLAY_EXTERNALY);
    AddCheck('Add to bookmarks', ACTION_ADD_BOOKMARK);
    AddCheck('Delete from bookmarks', ACTION_DELETE_BOOKMARK);
    AddCheck('Log urls to file', ACTION_LOG_URLS);
    AddCheck('Copy content urls', ACTION_COPY_CONTENT_URLS);
    AddCheck('Copy thumbnail url', ACTION_COPY_THUMB_URL);
    AddCheck('Open related', ACTION_OPEN_RELATED);
    AddCheck('Open author', ACTION_OPEN_AUTHOR);
    AddCheck('Share content', ACTION_SHARE_CONTENT);
    AddCheck('Browse search request', ACTION_BROWSE);
    AddCheck('Delete (or hide) item', ACTION_DELETE_CARD);

    for I := 0 to Content.Controls.Count - 1 do begin
      Control := Content.Controls.Items[I];
      if Control is TNBoxCheckButton then
        (Control as TNBoxCheckButton).Image.FileName :=
          AppStyle.GetImagePath(ICON_SETTINGS);
    end;

    Checked := Settings.ItemInteractions;

    BtnSetSaveOnItemTap := CreateDefButton(CheckMenuSetOnItemTap, BTN_STYLE_DEF2);
    with BtnSetSaveOnItemTap do begin
      Parent := CheckMenuSetOnItemTap;
      Align := TAlignLayout.Top;
      Position.Y := Single.MaxValue;
      Margins.Rect := TRectF.Create(6, 6, 6, 0);
      Image.FileName := AppStyle.GetImagePath(ICON_SAVE);
      OnTap := BtnSetSaveOnItemTapOnTap;
      Text.Text := 'Save tap settings';
    end;

  end;

  MenuChangeTheme := TNBoxSelectMenu.Create(MainLayout);
  with MenuChangeTheme do begin
    Parent := MainLayout;
    Align  := TAlignlayout.Client;
    OnSelected := MenuChangeThemeOnSelected;
  end;

  BtnSetViewLog := AddSettingsButton('View log', ICON_NSFWBOX);
  with BtnSetViewLog do
    Ontap := BtnSetViewLogOnTap;

  BtnSetChangeOnItemTap := AddSettingsButton('Change content on tap action', ICON_SETTINGS);
  with BtnSetChangeOnItemTap do begin
    OnTap := BtnSetChangeOnItemTapOnTap;
  end;

  BtnSetChangeTheme := AddSettingsButton('Change theme style', ICON_SETTINGS);
  with BtnSetChangeTheme do
    OnTap := BtnSetChangeThemeOnTap;

  BtnSetSave := AddSettingsButton('Save settings', ICON_SAVE);
  with BtnSetSave do begin
    OnTap := BtnSetSaveOnTap;
  end;

  { Bottom menu settings layout }
  AddBottomLayout(MenuSettings, BtnSetSave.Margins.Top);

  LayoutBMarkChangeTop := TLayout.Create(MenuBookmarksChange);
  with LayoutBMarkChangeTop do begin
    parent := MenuBookmarksChange;
    Align := TAlignLayout.MostTop;

    ImageBMark := CreateDefButton(LayoutBMarkChangeTop, BTN_STYLE_DEF2);
    with ImageBMark do begin
      Parent := LayoutBMarkChangeTop;
      Align := TAlignLayout.MostLeft;
      OnResize := Self.IconOnResize;
      Margins.Right := 6;
      Image.Filename := AppStyle.GetImagePath(ICON_BOOKMARKS);
    end;

    EditBmarkName := Self.CreateDefEdit(LayoutBMarkChangeTop);
    with EditBMarkName do begin
      Parent := LayoutBMarkChangeTop;
      Align := TAlignLayout.Client;
      Edit.TextPrompt := 'Bookmark name..';
    end;

    Margins.Rect := TRectF.Create(10, 10, 10, 0);

  end;

  MemoBMarkAbout := CreateDefMemo(MenuBookmarksChange);
  with MemoBMarkAbout do begin
    Parent := MenuBookmarksChange;
    Align := TAlignLayout.Client;
    Margins.Rect := LayoutBMarkChangeTop.Margins.Rect;
  end;

  BtnBMarkSaveChanges := CreateDefButton(MenuBookmarksChange, BTN_STYLE_DEF2);
  with BtnBMarkSaveChanges do begin
    Parent := MenuBookmarksChange;
    Align := TAlignLayout.Bottom;
    OnTap := BtnBMarkSaveChangesOnTap;
    Margins.Rect := LayoutBMarkChangeTop.Margins.Rect;
    Margins.Bottom := Margins.Top;
    Image.FileName := AppStyle.GetImagePath(ICON_SAVE);
    Text.Text := 'Save changes';
    Position.Y := Single.MaxValue;
  end;

  BtnBMarkCreate := AddBMarksDoListButton('Create new bookmarks list', ICON_ADD, BtnBMarkCreateOnTap, TAG_CAN_USE_MORE_THAN_ONE);
  BtnBMarkOpen   := AddBMarksDoListButton('Open and show', ICON_NEWTAB, BtnBMarkOpenOnTap, TAG_CAN_USE_MORE_THAN_ONE);
  BtnBMarkOpenLastPage := AddBMarksDoListButton('Open and show (last page)', ICON_NEWTAB, BtnBMarkOpenLastPageOnTap, TAG_CAN_USE_MORE_THAN_ONE);
  BtnBMarkChange := AddBMarksDoListButton('Change bookmark list', ICON_EDIT, BtnBMarkChangeOnTap);
  BtnBMarkDelete := AddBMarksDoListButton('Delete', ICON_DELETE, BtnBMarkDeleteOnTap, TAG_CAN_USE_MORE_THAN_ONE);

  DialogYesOrNo.Padding.Rect := TRectF.Create(10, 10, 10, 10);

  TextDialog := Self.CreateDefText(DialogYesOrNo);
  with TextDialog do begin
    Parent := DialogYesOrNo;
    Align := TAlignLayout.Client;
    TextSettings.WordWrap := true;
    TextSettings.VertAlign := TTextAlign.Center;
    TextSettings.HorzAlign := TTextAlign.Center;
  end;

  LayoutDialogYesOrNo := TLayout.Create(DialogYesOrNo);
  With LayoutDialogYesOrNo do begin
    Parent := DialogYesOrNo;
    Align := TAlignlayout.Bottom;
    Height := 50;
    Margins.Rect := TRectF.Create(10, 0, 10, 50);
    OnResize := LayoutDialogYesOrNoOnResize;
  end;

  BtnDialogYes := Self.CreateDefButton(LayoutDialogYesOrNo, BTN_STYLE_DEF2);
  with BtnDialogYes do begin
    parent := LayoutDialogYesOrNo;
    Align := TAlignlayout.Left;
    Margins.Right := ( DialogYesOrNo.Padding.Left / 2 );
    Text.Text := 'Yes';
    Text.TextSettings.HorzAlign := TTextAlign.Center;
    OnTap := BtnDialogYesOnTap;
  end;

  BtnDialogNo := Self.CreateDefButton(LayoutDialogYesOrNo, BTN_STYLE_DEF2);
  with BtnDialogNo do begin
    parent := LayoutDialogYesOrNo;
    Align := TAlignlayout.Client;
    Margins.Left := ( DialogYesOrNo.Padding.Left / 2 );
    Text.Text := 'No';
    Text.TextSettings := BtnDialogYes.Text.TextSettings;
    OnTap := BtnDialogNoOnTap;
  end;

  { MenuAnonMessage }
  EditNickMsgForDev := Self.CreateDefEdit(MenuAnonMessage);
  with EditNickMsgForDev do begin
    Margins.Rect := TRectF.Create(10, 10, 10, 0);
    Parent := MenuAnonMessage;
    Edit.TextPrompt := 'Nickname (optional)';
    Align := TAlignLayout.MostTop;
  end;

  MemoMsgForDev := Self.CreateDefMemo(MenuAnonMessage);
  with MemoMsgForDev do begin
    Parent := MenuAnonMessage;
    Margins := EditNickMsgForDev.Margins;
    Memo.Text := '';
    Memo.AutoSelect := false;
    Memo.MaxLength := 2000;
    Align := TAlignLayout.Client;
  end;

  BtnSendMsgForDev := Self.CreateDefButton(MenuAnonMessage, BTN_STYLE_DEF2);
  with BtnSendMsgForDev do begin
    Margins := EditNickMsgForDev.Margins;
    Margins.Bottom := Margins.Top;
    Parent := MenuAnonMessage;
    Align := TAlignlayout.MostBottom;
    Text.Text := 'Send message';
    Image.FileName := AppStyle.GetImagePath(ICON_TRANS);
    OnTap := BtnSendMsgForDevOnTap;
  end;

  { MenuSearchDoList }
  BtnSearchAddBookmark := AddMenuSearchBtn('Add current request to bookmarks', ICON_BOOKMARKS, BtnSearchAddBookmarkOnTap);

  MenuItemTags := TNBoxSelectMenu.Create(Form1.MainLayout);
  MenuItemTags.Parent := Form1.MainLayout;
  MenuItemTags.Align := TAlignLayout.Client;
  MenuItemTags.OnSelected := MenuItemTagsOnSelected;

  BookmarksControls := TControlObjList.Create;
  ChangeInterface(BrowserLayout);

  FFormCreated := true;
  Settings := Settings;
  HistoryDb := TNBoxBookmarksHistoryDb.Create(HISTORY_FILENAME);
  BookmarksDb := TNBoxBookmarksDb.Create(BOOKMARKSDB_FILENAME);
  Session := TnBoxBookmarksDb.Create(SESSION_FILENAME);
  Session.PageSize := 100;
  ConnectSession;

  { Data base update }
  if not HistoryDb.HasGroup(HistoryDb.NAME_TABS_HISTORY) then begin
    { v1.3.0 }
    HistoryDb.AddGroup(HistoryDb.NAME_TABS_HISTORY, 'all tabs that been closed.');
    HistoryDb.Free;
    HistoryDb := TNBoxBookmarksHistoryDb.Create(HISTORY_FILENAME);
  end;

  CurrentBookmarksDb := BookmarksDb;

  if Settings.AutoSaveSession then
    loadSession;

  if Browsers.Count < 1 then
    AddBrowser(nil);

  CurrentBrowser := Browsers.Last;
  TabsScroll.ShowScrollBars := Settings.ShowScrollBars;

  {$IFDEF MSWINDOWS}
  MVMenu.Mode := TMultiviewMode.Panel;
  MvMenu.Width := 200;
  for I := 0 to Form1.Children.Count - 1 do begin
    var FmxObj: TFmxObject;
    FmxObj := Form1.Children.Items[I];
    if ( FmxObj is TControl ) then
      SetClick(FmxObj as TControl);
    if ( FmxObj is TCustomScrollBox ) then
      TCustomScrollBox(FmxObj).ShowScrollBars := Settings.ShowScrollBars;
  end;
  {$ENDIF}

  { Update checker thread creates and starts here }
  if Settings.AutoCheckUpdates then begin
    var LUpdateCheckTask: ITask;
    LUpdateCheckTask := TTask.Create(
    procedure
    Const
      RETRY_TIMEOUT: integer = 3500;
      RETRY_COUNT: integer = 10;
    var
      I: integer;
      LastRelease: TGithubRelease;
      LastVer: TSemVer;
      Success: boolean;
    begin
      Success := false;
      for I := 1 to RETRY_COUNT do begin
        LUpdateCheckTask.CheckCanceled;
        try
          LastRelease := GetLastRealeaseFromGitHub;
          Success := true;
          break;
        except
          On E: Exception do begin
            SyncLog(E, 'OnUpdateCheck: ');
            LUpdateCheckTask.Wait(RETRY_TIMEOUT);
          end;
        end;
      end;

      if not success then
        exit
      else begin
        LastVer := TSemVer.FromGhTagString(LastRelease.TagName);
        SyncLog('Last release: ' + LastVer.ToGhTagString);
      end;

      if ( LastVer > APP_VERSION ) then begin
        { New version available }
        TThread.Synchronize(Nil, procedure begin
          Form1.UserBooleanDialog('Update available: ' + LastRelease.Name + SLineBreak +
                                  LastRelease.Body + SLineBreak +
                                  'Click `Yes` to open release page.',
          procedure begin
            if UserSayYes then
            {$IFDEF ANDROID}
              StartActivityView(LastRelease.HtmlUrl);
            {$ENDIF} {$IFDEF MSWINDOWS}
              ShellExecute(0, 'open', Pchar(LastRelease.HtmlUrl), nil, nil, SW_SHOWNORMAL);
            {$ENDIF}
            Self.ChangeInterface(Self.BrowserLayout);
          end);
        end);
      end;

      end).Start;
  end;

  //var LStr, LEncStr: string;
  //LStr := '' + '?wait=true';
  //LEncStr := TNetEncoding.Base64String.Encode(LStr);
  //unit1.Log(LEncStr);

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  BrowsersIWUContentManager.Free;
  IWUContentManager.Free;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
var
  KeyboardService: IFMXVirtualKeyboardService;
  KeyboardAccess: boolean;
begin
  KeyboardAccess := TPlatformServices.Current.SupportsPlatformService
    (IFMXVirtualKeyboardService, IInterface(KeyboardService));

  case key of

    VkHardwareBack:
    begin
      if KeyboardAccess
      and (TVirtualKeyboardState.Visible in KeyboardService.VirtualKeyboardState) then  begin
        KeyboardService.HideVirtualKeyboard;
      end else if CheckMenuSetOnItemTap.Visible then begin
        ChangeInterface(MenuSettings);
      end else begin
        ChangeInterface(BrowserLayout);
      end;
      if MvMenu.IsShowed then
        MvMenu.HideMaster;
      Key := 0;
    end;

    VkEscape:
    begin
      {$IFDEF MSWINDOWS}
      Form1.FullScreen := false;
      {$ENDIF}
      ChangeInterface(BrowserLayout);
    end;

  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  FAppStyle.Form.Apply(form1.Fill);
end;

function TForm1.GetAppStyle: TNBoxGUIStyle;
begin
  Result := FAppStyle;
end;

function TForm1.GetBetterFilename(AFilename: string; AOrigin: integer): string;
var
  FileExt, DefaultExt: string;
  function MidN(const AStr: string; ALeft, ARight: string): string;
  var
    Lp, Rp, Ms : integer;
  begin
    Lp := Pos(ALeft, AStr);
    Ms := ALeft.Length + Lp;
    Rp := Pos(ARight, AStr, Ms);
    result := Copy(AStr, Ms, Rp - Ms);
  end;

begin
  FileExt := '';
  DefaultExt := '.mp4';

  if AOrigin = ORIGIN_NSFWXXX then begin
    FileExt := trim(MidN(AFilename, '?format=', '&'));
    if Not FileExt.IsEmpty then
      FileExt := '.' + FileExt;
  end;

  if FileExt.IsEmpty then
    FileExt := TPath.GetExtension(AFilename);

  if not Tpath.HasValidFileNameChars(FileExt, false) then
    FileExt := DefaultExt;

  Result := THashMD5.GetHashString(AFilename) + FileExt;
end;

function TForm1.GetSettings: TNsfwBoxSettings;
begin
  Result := Fsettings;
end;

function TForm1.GetSubHeader: string;
begin
  Result := TopBottomText.Text;
end;

function TForm1.GetTab(ABrowser: TNBoxBrowser): TNBoxTab;
var
  N: integer;
begin
  N := form1.IndexTabByBrowser(ABrowser);
  if N <> -1 then
    Result := Tabs.Items[N]
  else
    Result := nil;
end;

procedure TForm1.GotoBookmarksMenu(ABookmarksDb: TNBoxBookmarksDb);
begin
  CurrentBookmarksDb := ABookmarksDb;
  if CurrentBookmarksDb = BookmarksDb then
    ChangeInterface(MenuBookmarks)
  else if CurrentBookmarksDb = HistoryDb then
    ChangeInterface(MenuHistory)
end;

procedure TForm1.GotoDownloadsMenu;
begin
  ChangeInterface(MenuDownloads);
end;

procedure TForm1.GotoItemMenu(AItem: TNBoxCardBase);
begin
  CurrentItem := AItem;
  if not Assigned(CurrentItem) then
    exit;

  DoWithAllItems := false;
  ChangeInterface(MenuItem);
end;

procedure TForm1.GotoItemTagsMenu(ATags: TArray<string>; AOrigin: integer);
var
  I: integer;
begin
  MenuItemTagsOrigin := AOrigin;
  MenuItemTags.ClearButtons;

  for I := low(ATags) to high(ATags) do begin
    MenuItemTags.AddBtn(ATags[I], 0, ICON_TAG, true);
  end;

  ChangeInterface(MenuItemTags);
end;

procedure TForm1.GotoSearchSettings(ABrowser: TNBoxBrowser);
begin
  ChangeInterface(MenuSearchSettings);
  if Assigned(ABrowser) then begin
    SearchMenu.Request := ABrowser.Request;
  end;
end;

procedure TForm1.OnBrowserReqChanged(Sender: TObject);
var
  LTab: TNBoxTab;
  LBrowser: TNBoxBrowser;
  Groups: TBookmarkGroupRecAr;
  Group: TBookmarkGroupRec;
begin
  LBrowser := TNBoxBrowser(Sender);
  LTab := GetTab(Sender as TNBoxBrowser);

  if not Assigned(LTab) then
    Exit;

  LTab.Text.Text := CreateTabText(LBrowser);

  if ( not NowLoadingSession ) And Settings.AutoSaveSession then begin
    Groups := Session.GetBookmarksGroups;
    if Length(Groups) > 0 then begin
      Group := Groups[0];
      if ( LBrowser.Tag <> -1 ) then
        Group.Delete(LBrowser.Tag);

      Group.Add(LBrowser.Request);
      LBrowser.Tag := Group.GetMaxId;
    end;
  end;
end;

procedure SetDefToWebClient(AClient: TNetHttpClient; AOrigin: integer = 0);
begin
  with AClient do begin
    Useragent := Form1.Settings.DefaultUseragent;
    AutomaticDecompression := [THttpCompressionMethod.Any];
    Customheaders['Accept'] := '*/*';
    CustomHeaders['Accept-Language'] := 'en-US,en;q=0.5';
    CustomHeaders['Accept-Encoding'] := 'gzip, deflate'; { br not support }
    AllowCookies := Form1.Settings.AllowCookies;
    SendTimeout := 6000;
    ConnectionTimeout := 6000;
    ResponseTimeout := 6000;

    case AOrigin of
      ORIGIN_9HENTAITO:
      begin
        CustomHeaders['Accept'] := 'application/json, text/plain, */*';
        CustomHeaders['Content-Type'] := 'application/json;charset=utf-8';
      end;
    end;
  end;
end;

procedure TForm1.OnBrowserScraperCreate(Sender: TObject;
  var AScraper: TNBoxScraper);
begin
  AScraper.BookmarksDb := BookmarksDb;
  AScraper.HistoryDb := HistoryDb;
end;

procedure TForm1.OnBrowserSetWebClient(Sender: TObject;
  AWebClient: TNetHttpClient; AOrigin: integer);
begin
  tthread.Synchronize(Tthread.Current,
  procedure
  begin
    SetDefToWebClient(AWebClient, AOrigin);
  end);
end;

procedure TForm1.OnBrowsersNotify(Sender: TObject; const Item: TNBoxBrowser;
  Action: TCollectionNotification);
begin

end;

procedure TForm1.OnBrowserViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
var
  LBrowser: TNBoxBrowser;
begin
  LBrowser := TNBoxBrowser(Sender);
  if Settings.BrowseNextPageByScrollDown then begin
    if round(NewViewportPosition.Y) = round(LBrowser.ContentBounds.Height - LBrowser.Height) then begin
      // Scrolled down
      LBrowser.GoNextPage;
    end;
  end
end;

procedure TForm1.OnCardAutoLook(Sender: TObject);
var
  LCard: TNBoxCardBase;
  LCardS: TNBoxCardSimple;
begin
  LCard := (Sender as TNBoxCardBase);

  if (LCard is TNBoxCardSimple) then
    LCardS := (LCard as TNBoxCardSimple)
  else
    LCardS := nil;

  if LCard.HasPost then begin
    AppStyle.ItemCard.Apply(LCard);
    if Assigned(LCardS) then begin
      LCardS.Text.Color := AppStyle.TextColors[0];
      AppStyle.ItemCard.Fill2.Apply(LCardS.Rect.Fill);

      if LCards.Rect.Visible then
        LCardS.Rect.Visible := Settings.ShowCaptions;
    end;
  end else if ( LCard.HasBookmark and LCard.Bookmark.IsRequest ) then begin
    AppStyle.ItemCardRequest.Apply(LCard);
    if Assigned(LCardS) then begin
      LCardS.Text.Color := AppStyle.TextColors[0];
      AppStyle.ItemCardRequest.Fill2.Apply(LCardS.Rect.Fill);
    end;
  end;
end;

procedure TForm1.OnCreateDownloader(Sender: Tobject;
  const ADownloader: TNetHttpDownloader);
begin
  with ADownloader do begin
    SynchronizeEvents := true;
    RetryTimeout := 1500;
    OnCreateWebClient := self.DownloaderOnCreateWebClient;
    OnReceiveData := DownloaderOnReceiveData;
    OnRequestException := DownloaderOnException;
    OnFinish := Self.DownloaderOnFinish;
  end;
end;

procedure TForm1.OnIWUException(Sender: TObject; AImage: IImageWithURL;
  const AUrl: string; const AException: Exception);
begin
  TThread.Synchronize(nil,
  procedure
  begin
    Log(AException, 'OnIWUException ' + AUrl + ': ');
  end);
end;

function DownloadItemText(A: TNetHttpDownloader): string;
var
  ContentSize: int64;
  Kb: int64;
  FileSizeStr: string;

  function GetPercents: integer;
  var
    X: real;
  begin
    Result := 0;
    try
      if ContentSize > 0 then begin
        X := ContentSize / 100;
        Result := Round(A.ReadCount / X);
        if Result > 100 then Result := 100;
      end;
    except
      On E: Exception do begin
        Log(E, 'GetPercents: ');
      end;
    end;
  end;

begin
  ContentSize := A.ContentLength;
  Kb := Round(ContentSize / 1024);

  if Kb < 1024 then
    FileSizeStr := Kb.ToString + ' Kb.'
  else
    FileSizeStr := Round(Kb / 1024).ToString + ' Mb.';

  Result := '[ ' + GetPercents.ToString + '% ] of ' + FileSizeStr;
end;

procedure TForm1.DownloaderOnException(const Sender: TObject;
  const AError: Exception);
var
  Tab: TNBoxTab;
  Loader: TNetHttpDownloader;
  NewText: string;
begin
  try
    Loader := ( Sender as TNetHttpDownloader );

    TThread.Synchronize(TThread.Current, procedure begin
      Tab := DownloadItems.Items[Loader.Tag];
      NewText := DownloadItemText(Loader) + ' ' + AError.Message + ' try: ' + Loader.RetriedCount.ToString;
      Tab.Text.Text := newText;
    end);
  except
    On E: Exception do Log(E, 'TForm1.DownloaderOnException: ');
  end;
end;

procedure TForm1.DownloaderOnFinish(Sender: TObject);
var
  Tab: TNBoxTab;
  Loader: TNetHttpDownloader;
begin
  Loader := ( Sender as TNetHttpDownloader );
  Tab := DownloadItems.Items[Loader.Tag];
  Tab.Visible := false;
end;

procedure TForm1.DownloaderOnReceiveData(const Sender: TObject; AContentLength,
  AReadCount: Int64; var AAbort: Boolean);
var
  Tab: TNBoxTab;
  Loader: TNetHttpDownloader;
begin
  Loader := ( Sender as TNetHttpDownloader );
  if Loader.IsRunning then begin
    Tab := DownloadItems.Items[Loader.Tag];
    Tab.Text.Text := DownloadItemText(Loader);
  end;
end;

procedure TForm1.DownloadFetcherOnFetched(Sender: TObject;
  var AItem: INBoxItem);
var
  LItem: INBoxItem;
begin
  LItem := AItem;
  TThread.Synchronize(TThread.Current,
  procedure begin
    try
      AddDownload(LItem.Clone);
    except
      On E: Exception do Log(E, 'DownloadFetcherOnFetched: ');
    end;
  end);
end;

procedure TForm1.DownloaderOnCreateWebClient(const Sender: TObject;
  AWebClient: TNetHttpClient);
begin
  SetDefToWebClient(AWebClient);
end;

procedure TForm1.OnSimpleCardResize(Sender: TObject);
var
  S: TSize;
  M: single;
begin
  with (Sender as TNBoxCardSimple) do begin

    if fill.Bitmap.Bitmap.IsEmpty then begin
      Size.Height := Size.Width;
      exit;
    end;

    S := TSize.Create(fill.bitmap.Bitmap.Size);
    M := S.Width / S.Height;
    Size.Height := Size.Width / M;

    Rect.Height := round( size.Height / 3.6 );
    text.Font.Size := round( size.Width / 18 );
    text.Height := Rect.Height - ( Rect.Padding.Top + Rect.Padding.Bottom );
  end;
end;

procedure TForm1.OnNewItem(Sender: TObject; var AItem: TNBoxCardBase);
var
  B: TNBoxBrowser;
  T: TNBoxTab;
begin
  with AItem do begin
    OnTap := CardOnTap;
    OnAutoLook := OnCardAutoLook;

    AppStyle.ItemCard.Apply(AItem);

    if AItem is TNBoxCardSimple then
      OnResize := form1.OnSimpleCardResize;

    Margins.Top := Settings.ItemIndent;
    {$IFDEF MSWINDOWS}
    OnClick := ClickTapRef;
    {$ENDIF}
  end;

  B := TNboxBrowser(Sender);
  T := GetTab(B);
  if Assigned(T) then begin
    T.Text.Text := CreateTabText(B);
  end;
end;

procedure TForm1.OnStartDownloader(Sender: Tobject;
  const ADownloader: TNetHttpDownloader);
begin

end;

procedure TForm1.IconOnResize(Sender: TObject);
begin
  with ( Sender as TControl ) do begin
    Width := Height;
  end;
end;

function TForm1.IndexTabByBrowser(ABrowser: TNBoxBrowser): integer;
var
  I: integer;
begin
  result := -1;
  for I := 0 to Tabs.Count - 1 do begin
    if Tabs.Items[I].Owner = ABrowser then begin
      Result := I;
      Exit;
    end;
  end;
end;

procedure TForm1.CardOnTap(Sender: TObject; const Point: TPointF);
var
  I: integer;
  Item: TNBoxCardBase;
  Interactions: TArray<NativeInt>;
begin
  Item := ( Sender as TNBoxCardBase );

  if ( Settings.SaveTapHistory and Item.HasPost ) then
    HistoryDb.TapGroup.Add(Item.Post);

  Interactions := Settings.ItemInteractions;
  for I := 0 to High(Interactions) do begin
    Self.ExecItemInteraction(Item, Interactions[I]);
    if ( Interactions[I] = ACTION_DELETE_CARD ) then begin
      if MenuItem.Visible then
        ChangeInterface(BrowserLayout);
      exit;
    end;
  end;

end;

procedure TForm1.LayoutDialogYesOrNoOnResize(Sender: TObject);
begin
  BtnDialogYes.Width :=
    ( ( LayoutDialogYesOrNo.Width - ( BtnDialogYes.Margins.Right * 2 ) ) / 2 );
end;

function TForm1.LoadSession: boolean;
var
  Group: TBookmarkGroupRec;
  Groups: TBookmarkGroupRecAr;
  LBmrks: TBookmarkAr;
  I: integer;
begin
  Result := false;
  NowLoadingSession := true;
  try
    try
      Groups := Session.GetBookmarksGroups;
      if Length(Groups) < 1 then
        exit;

      Group := Groups[0];
      LBmrks := Group.GetPage;
      for I := High(LBmrks) Downto Low(LBmrks) do begin

        if not ( LBmrks[I].BookmarkType = SearchRequest ) then
          continue;

        AddBrowser(LBmrks[I].AsRequest);
        Browsers.Last.Tag := LBmrks[I].Id;
        LBmrks[I].Free;

      end;

      if Length(LBmrks) > 0 then
        Result := true;
    except
      On E: Exception do begin
        Log(E, 'LoadSession: ');
        Result := false;
      end;
    end;
  finally
    NowLoadingSession := false;
  end;
end;

function TForm1.LoadSettings: boolean;
var
  NewSettings: TNsfwBoxSettings;
  X: ISuperObject;
begin
  try
    try
      NewSettings := nil;
      Result := fileexists(SETTINGS_FILENAME);

      if Result then begin
        X := TSuperObject.ParseFile(SETTINGS_FILENAME);
        NewSettings := TNsfwBoxSettings.FromJSON(X);
        Settings := NewSettings;
      end;
    except
      on E: Exception do begin
        Result := false;
        Log(E, 'LoadSettings: ');
      end;
    end;
  finally
    if Assigned(NewSettings) then
      NewSettings.Free;
  end;
end;

function TForm1.LoadStyle: boolean;
var
  Fname: string;
  X: iSuperObject;
  NewStyle: TNBoxGUIStyle;
begin
  NewStyle := nil;
  Fname := IoUTils.TPath.Combine(TNBoxPath.GetThemesPath, Settings.StyleName);
  try
    try
      Result := FileExists(Fname);
      if Result then begin
        NewStyle := TNBoxGUIStyle.create;
        X := TSuperobject.ParseFile(Fname);
        NewStyle.AssignFromJSON(X);
        AppStyle := NewStyle;
      end;
    except
      On E: Exception do begin
        Result := false;
        Log(E, 'LoadStyle: ')
      end;
    end;
  finally
    if assigned(NewStyle) then NewStyle.Free;
  end;
end;

procedure TForm1.MenuBtnBookmarksOnTap(Sender: TObject; const Point: TPointF);
begin
  GotoBookmarksMenu(BookmarksDb);
end;

procedure TForm1.MenuBtnHistoryOnTap(Sender: TObject; const Point: TPointF);
begin
  GotoBookmarksMenu(HistoryDb);
end;

procedure TForm1.MenuBtnDownloadsOnTap(Sender: TObject; const Point: TPointF);
begin
  GotoDownloadsMenu;
end;

procedure TForm1.MenuBtnNewTabOnTap(Sender: TObject; const Point: TPointF);
begin
  try
    AddBrowser;
    CurrentBrowser := Browsers.Last;
    GotoSearchSettings(CurrentBrowser);
  except
    on E: Exception do
      Log(E, 'TForm1.MenuBtnNewTabOnTap: ');
  end;
end;

procedure TForm1.MenuBtnSettingsOnTap(Sender: TObject; const Point: TPointF);
begin
  ChangeInterface(MenuSettings);
end;

procedure TForm1.MenuChangeThemeOnSelected(Sender: TObject);
begin
  FSettings.StyleName := (Sender as TNBoxSelectMenu).SelectedBtn.Text.Text;
  SaveSettings;
  ChangeInterface(MenuSettings);
end;

procedure TForm1.MenuItemTagsOnSelected(Sender: TObject);
begin
  self.AddBrowser(CreateTagReq(MenuItemTagsOrigin,
                  MenuItemTags.SelectedBtn.Text.Text),
                  Settings.AutoStartBrowse);
end;

procedure TForm1.ReloadBookmarks(ADataBase: TNBoxBookmarksDb; ALayout: TControl);
var
  I: Integer;
  Groups: TBookmarkGroupRecAr;
  Control: TNBoxSettingsCheck;

  function _getName(AGroup: TBookmarkGroupRec): string;
  begin
    Result := AGroup.Name;
    if Settings.DevMode then begin
      Result := '[ id: ' + AGroup.Id.ToString + ' ] ' + Result;
      Result := '[ LastPage: ' + AGroup.GetMaxPage.ToString + ' ] ' + Result;
    end;

    Result := '(' + AGroup.GetItemsCount.ToString + ') ' + Result;
  end;

begin
  Groups := ADataBase.GetBookmarksGroups;
  BookmarksControls.Clear;

  for I := Low(Groups) to High(Groups) do begin
    Control := Self.CreateDefSettingsCheck(ALayout);
    with Control do begin
      Parent := ALayout;
      Check.Image.Visible := true;
      Check.Image.Margins.Rect := TRectF.Create(0, 5, 0, 5);

      if (ADataBase = BookmarksDb) then
        Check.Image.FileName := AppStyle.GetImagePath(ICON_BOOKMARKS)
      else if (ADataBase = HistoryDb) then
        Check.Image.FileName := AppStyle.GetImagePath(ICON_HISTORY);

      Align := TAlignLayout.Top;
      Position.Y := Single.MaxValue;
      Check.Text.Text := _getName(Groups[I]);
      Text.Text := Groups[I].About;
      Tag := Groups[I].Id;
      Check.HitTest := false;
      Text.HitTest := false;
      Text.VertTextAlign := TTextAlign.Leading;
      Check.Check.Visible := false;
      Check.Height := Control.Check.Height * 0.8;
      Height := Control.Height * 1.5;
      Margins.Rect := TRectF.Create(5, 5, 5, 0);
      OnTap := BookmarksControlOnTap;
      {$IFDEF MSWINDOWS}
      Control.OnClick := ClickTapRef;
      {$ENDIF}
    end;
    
    BookmarksControls.Add(Control);
  end;
end;

procedure TForm1.RestoreDefaultSettings;
begin
  if Assigned(FSettings) then
    FSettings.Free;

  FSettings := TNsfwBoxSettings.Create;
  with FSettings do begin
    DefaultUseragent := 'Mozilla/5.0 (Windows NT 10.0; rv:105.0) Gecko/20100101 Firefox/105.0';
    AllowCookies := false;
    DefDownloadPath := TPath.Combine(TPath.GetSharedDownloadsPath, 'NsfwBox');
    FilenameLogUrls := TPath.Combine(DefDownloadPath, 'nsfw-box-content-urls.txt');
    {$IFDEF MSWINDOWS}
    ContentLayoutsCount := 5;
    {$ENDIF}
  end;
end;

{$IFDEF MSWINDOWS}
procedure TForm1.RestoreDefaultStyle;
const
  GR_START: TNBoxPos = ( X: 0; y: 0.500000059604645; );
  GR_STOP: TNBoxPos  = ( X: 1; y: 0.499999970197678; );
//  {$IFDEF MSWINDOWS}
//  STROKE_THICKNESS  = 0.6;
//  {$ELSE}
//  STROKE_THICKNESS  = 0.3;
//  {$ENDIF}
  STROKE_THICKNESS  = 0.3;
  M                 = 14;

var
  LTapColor,
  LSecondColor
  : TAlphaColor;

  procedure _GrPos(var A: TNBoxGradientStyle);
  begin
    A.StartPos := GR_START;
    A.StopPos  := GR_STOP;
  end;

begin
  LTapColor    := GetColor(255, 255, 255, 20);
  LSecondColor := GetColor(15, 15, 15, 255);

  if Assigned(FAppStyle) then
    FAppStyle.Free;

  FAppStyle := TNBoxGUIStyle.Create;
  with FAppStyle do begin
    StyleName                 := 'another';
    StyleResPath              := 'default';

    TextColors                := [TAlphaColorrec.White, GetColor(255, 255, 255, 150)];

    with Form do begin
      kind               := TBrushKind.Solid;
      Color              := TAlphaColorRec.Black;
    end;

    with MultiView do begin
      //Color              := GetColor(210, 210, 210, 255);
      Kind               := TBrushKind.Gradient;
      Gradient.Colors    := [ GetColor(10, 10, 10, 255), GetColor(10, 10, 10, 255) ];
      Gradient.Style     := TGradientStyle.Linear;
    end;

    with TopBar do begin
      Gradient.Colors    := [ GetColor(10, 10, 10, 255), GetColor(25, 25, 25, 255) ];
      Kind               := TBrushKind.Gradient;
      Gradient.Style     := TGradientStyle.Linear;
      _GrPos(Topbar.Gradient);
    end;

    with Button do begin
      Fill.Kind          := TBrushKind.None;
      Stroke.Kind        := TBrushKind.None;
      Fill2.Kind         := TBrushKind.Solid;
      Stroke2.Kind       := TBrushKind.None;
      Fill2.Color        := LTapColor;
      XRadius            := 15;
      Yradius            := XRadius;
      ImageMargins       := TRectRec.New(8, 8, 8, 8);
    end;

    with Button2 do begin
      Fill.Kind         := TBrushKind.None;
      Fill2.Kind        := TbrushKind.Solid;
      Fill2.Color       := LTapColor;
      stroke.Kind       := TBrushKind.Solid;
      Stroke.Thickness  := STROKE_THICKNESS;
      Stroke.Color      := TAlphacolorrec.White;
      Stroke2.Color     := Stroke.Color;
      Stroke2.Thickness := Stroke.Thickness;
      Stroke2.Kind      := Tbrushkind.Solid;
      XRadius           := 15;
      Yradius           := XRadius;
      ImageMargins      := TRectRec.New(6, 6, 6, 6);
    end;

    with ItemCard do begin
      Stroke.Kind        := TBrushKind.None;
      Fill2.Kind         := TBrushKind.Gradient;
      Fill2.Gradient.Colors := [ GetColor(18, 18, 18, 150), GetColor(10, 10, 10, 255) ];
      Fill2.Gradient.Style  := TGradientStyle.Linear;
      _GrPos(Fill2.Gradient);
    end;

    With ItemCardRequest do begin
      Stroke.Kind        := TBrushKind.Solid;
      Stroke.Thickness   := STROKE_THICKNESS;
      Stroke.Color       := TAlphacolorRec.White;
      Fill.Kind          := TBrushKind.Solid;
      Fill.Color         := LSecondColor;
      XRadius            := 10;
      YRadius            := XRadius;
      Fill2.Kind         := TBrushKind.None;
    end;

    ButtonIcon.AssignFromJSON(Button.AsJSONObject);
    with ButtonIcon do begin
      Fill.Kind          := TBrushKind.Solid;
      Fill.Color         := GetColor(25, 25, 25, 255);
      XRadius            := 30;
      Yradius            := XRadius;
      ImageMargins       := TRectRec.New(m, m, m, m);
    end;

    ButtonIcon2.AssignFromJSON(Button.AsJSONObject);
    with ButtonIcon2 do begin
      XRadius            := 0;
      YRadius            := 0;
      ImageMargins       := TRectRec.New(m, m, m, m);
    end;

    ButtonIcon3.AssignFromJSON(ButtonIcon2.AsJSONObject);
    with ButtonIcon3 do begin
      ImageMargins       := Button.ImageMargins;
    end;

    with Checkbox do begin
      Fill.Kind         := TBrushKind.None;
      Fill2.Kind        := TbrushKind.None;
      stroke.Kind       := TBrushKind.Solid;
      Stroke.Thickness  := STROKE_THICKNESS;
      Stroke.Color      := $FF1A496A;
      Stroke2.Thickness := Stroke.Thickness;
      stroke2.Color     := GetColor(150, 250, 255, 150);
      Stroke2.Kind      := Tbrushkind.Solid;
    end;

    Tab.AssignFromJSON(Button2.AsJSONObject);
    with Tab do begin
      ImageFilename     := ICON_CURRENT_TAB;
      ImageMargins      := TRectRec.New(m, m, m, m);
      XRadius           := 15;
      Yradius           := XRadius;

      with Item do begin // CloseBtn
        ImageFilename     := ICON_CLOSETAB;
        Fill.Kind         := TBrushKind.None;
        Fill2.Kind        := TbrushKind.Solid;
        Fill2.Color       := LTapColor;
        stroke.Kind       := TBrushKind.none;
        Stroke2.Kind      := TBrushKind.None;
        XRadius           := 15;
        Yradius           := XRadius;
        ImageMargins      := TRectRec.New(m, m, 0, m);
      end;
    end;

    with Edit do begin
      Fill.Kind          := TBrushKind.None;
      Stroke.Kind        := TBrushKind.Solid;
      Stroke.Color       := Tab.Stroke.Color;
      Stroke.Thickness   := STROKE_THICKNESS + 0.06;
      XRadius            := 15;
      Yradius            := XRadius;
      FontColor          := TAlphaColorrec.White;
      FontSize           := 11;
      FontName           := 'Roboto';
    end;

    Memo.AssignFromJSON(Button2.AsJSON);

    CheckButton.AssignFromJSON(Button2.AsJSONObject);
    with CheckButton do begin
      ImageMargins      := TRectRec.New(m, m, m, m);
      XRadius           := 15;
      Yradius           := XRadius;

      with Item do begin // CheckRect
        Fill2.Kind         := TBrushKind.None;
        Fill.Kind          := TbrushKind.Solid;
        Fill.Color         := TAlphaColorRec.White;
        stroke2.Kind       := TBrushKind.Solid;
        Stroke2.Color      := Fill2.Color;
        stroke2.Thickness  := STROKE_THICKNESS;
        Stroke.Kind        := TBrushKind.None;
//        {$IFDEF MSWINDOWS}
//        XRadius            := 7;
//        {$ELSE}
//        XRadius            := 30;
//        {$ENDIF}
        XRadius            := 30;
        Yradius            := XRadius;
      end;
    end;

    with CheckButtonSettings do begin
      ImageMargins      := TRectRec.New(m, m, m, m);
      Fill.Kind         := TBrushKind.None;
      Fill2.Kind        := TbrushKind.None;
      Stroke.Kind       := TBrushKind.None;
      Stroke2.Kind      := Tbrushkind.None;

      Item.AssignFromJSON(CheckButton.Item.AsJSONObject);
    end;

    with SettingsRect do begin
      Fill.Kind         := TBrushKind.solid;
      Stroke.Kind       := TBrushkind.None;
      Fill.Color        := LSecondColor;
      XRadius           := 10;
      YRadius           := XRadius;
    end;

  end;

  AppStyle := FAppStyle;
  AppStyle.AsJSONObject.SaveTo(TPath.Combine(TNBoxPath.GetThemesPath, AppStyle.StyleName + '.json'), true);
end;
{$ENDIF}

procedure TForm1.SaveSettings;
begin
  Settings.AsJSONObject.SaveTo(SETTINGS_FILENAME, true);
end;

procedure TForm1.SetAppStyle(const Value: TNBoxGUIStyle);
begin
  FAppStyle.Assign(Value);
  if not FFormCreated then
    Exit;

  FAppStyle.Assign(Value);
  FAppStyle.Form.Apply(form1.Fill);
  FAppStyle.Topbar.Apply(TopRect.Fill);
  FAppStyle.Topbar.Apply(TopRect.Fill);
  FAppStyle.Multiview.Apply(MVRect.Fill);
end;

procedure TForm1.SetCurrentBookmarkControl(const value: TNBoxSettingsCheck);
begin
  FCurrentBookmarkControl := Value;
  if Assigned(value) then
    FCurrentBookmarkGroup := CurrentBookmarksDb.GetGroupById(CurrentBookmarkControl.Tag);
end;

procedure TForm1.SetCurrentBookmarksDb(const value: TNBoxBookmarksDb);
begin
  FCurrentBookmarksDb := value;
  FCurrentBookmarkControl := nil;
end;

procedure TForm1.SetCurrentBrowser(const Value: TNBoxBrowser);
var
  Tab: TNBoxTab;
begin
  if Assigned(FCurrentBrowser) then begin
    Tab := self.GetTab(FCurrentBrowser);
    Tab.Image.Visible := false;
    Tab.Image.FileName := '';
    FCurrentBrowser.Visible := false;
  end;

  FCurrentBrowser := Value;
  Tab := self.GetTab(FCurrentBrowser);
  Tab.Image.Visible := true;
  Tab.Image.FileName := AppStyle.GetImagePath(AppStyle.Tab.ImageFilename);
  FCurrentBrowser.Visible := true;
end;

procedure TForm1.SetCurrentItem(const value: TNBoxCardBase);
begin
  FCurrentItem := Value;
end;

procedure TForm1.SetSettings(const value: TNsfwBoxSettings);
var
  I: integer;
begin
  if not Assigned(FSettings) then
    FSettings := TNsfwBoxSettings.Create;

  FSettings.Assign(Value);
  if not FFormCreated then
    exit;

  BrowsersIWUContentManager.ThreadsCount := Settings.ThreadsCount;
//  IWUContentManager.EnableSaveToCache := Settings.

  EditSetDefUseragent.Edit.Edit.Text    := Settings.DefaultUseragent;
  EditSetDefDownloadPath.Edit.Edit.Text := Settings.DefDownloadPath;
  EditSetThreadsCount.Edit.Edit.Text    := Settings.ThreadsCount.ToString;
  EditSetLayoutsCount.Edit.Edit.Text    := Settings.ContentLayoutsCount.ToString;
  EditSetItemIndent.Edit.Edit.Text      := Settings.ItemIndent.ToString;
  EditSetFilenameLogUrls.Edit.Edit.Text := Settings.FilenameLogUrls;
  CheckSetFullscreen.IsChecked          := settings.Fullscreen;
  Form1.FullScreen                      := FSettings.Fullscreen;
  CheckSetAllowCookies.IsChecked        := Settings.AllowCookies;
  CheckSetShowCaptions.IsChecked        := Settings.ShowCaptions;
  CheckSetAllowDuplicateTabs.IsChecked  := Settings.AllowDuplicateTabs;
  CheckSetAutoStartBrowse.IsChecked     := Settings.AutoStartBrowse;
  CheckSetAutoCloseItemMenu.IsChecked   := Settings.AutoCloseItemMenu;
  EditSetMaxDownloadThreads.Edit.Edit.Text := Settings.MaxDownloadThreads.ToString;
  DownloadManager.MaxThreadCount        := Settings.MaxDownloadThreads;
  CheckSetDevMode.IsChecked             := Settings.DevMode;
  CheckSetAutoCheckUpdates.IsChecked    := Settings.AutoCheckUpdates;
  CheckSetShowScrollBars.IsChecked      := Settings.ShowScrollbars;
  CheckSetShowNavigateBackButton.IsChecked := Settings.ShowNavigateBackButton;
  CheckSetBrowseNextPageByScrollDown.IsChecked := Settings.BrowseNextPageByScrollDown;
  {$IFDEF MSWINDOWS}
  EditSetPlayParams.Edit.Edit.Text      := Settings.ContentPlayParams;
  EditSetPlayApp.Edit.Edit.Text         := Settings.ContentPlayApp;
  {$ENDIF}

  With SearchMenu.OriginSetMenu do begin
    BtnOriginPseudo.Visible := Settings.DevMode;
    BtnOriginBookmarks.Visible := Settings.DevMode;
//    BtnOrigin9Hentaito.Visible := Settings.DevMode;
  end;


  CheckSetAutoSaveSession.IsChecked     := Settings.AutoSaveSession;
  CheckSetSaveSearchHistory.IsChecked   := Settings.SaveSearchHistory;
  CheckSetSaveDownloadHistory.IsChecked := Settings.SaveDownloadHistory;
  CheckSetSaveTapHistory.IsChecked      := Settings.SaveTapHistory;
  CheckSetSaveTabHistory.IsChecked      := Settings.SaveClosedTabHistory;

  for I := 0 to Browsers.Count - 1 do begin
    with Browsers[I] do begin
      MultiLayout.BlockCount := Settings.ContentLayoutsCount;
      MultiLayout.LayoutIndent := Settings.ItemIndent;
    end;
  end;
end;

procedure TForm1.SetSubHeader(const Value: string);
begin
  TopBottomText.Text := Value;
end;

procedure TForm1.TabOnTap(Sender: TObject; const Point: TPointF);
var
  B: TNBoxBrowser;
begin
  ChangeInterface(BrowserLayout);
  B := ((Sender as TControl).Owner as TNBoxBrowser);
  CurrentBrowser := B;
  Form1.MVMenu.HideMaster;
end;

procedure TForm1.TopBtnAppOnTap(Sender: TObject; const Point: TPointF);
begin
  ChangeInterface(BrowserLayout);
end;

procedure TForm1.TopBtnPopMenuOnTap(Sender: TObject; const Point: TPointF);
begin
  if MenuBookmarks.Visible then begin
    DoWithAllItems := true;
    ChangeInterface(MenuBookmarksDoList);
  end else if MenuSearchSettings.Visible then begin
    ChangeInterface(MenuSearchDoList);
  end else if BrowserLayout.Visible then begin
    CurrentItem := nil;
    DoWithAllItems := true;
    ChangeInterface(MenuItem);
  end;
end;

procedure TForm1.TopBtnSearchOnTap(Sender: TObject; const Point: TPointF);
var
  Req: INBoxSearchRequest;
begin
  if MenuSearchSettings.Visible then begin
    if Assigned(CurrentBrowser) then begin
      Req := SearchMenu.Request;
      CurrentBrowser.Request := Req;

      ChangeInterface(form1.BrowserLayout);
      CurrentBrowser.GoBrowse;
    end;
  end else begin

    if not Assigned(CurrentBrowser) then begin
      AddBrowser(nil);
      CurrentBrowser := Browsers.Last;
    end;

    GotoSearchSettings(CurrentBrowser);
  end;
end;

procedure TForm1.UserBooleanDialog(AText: string; AWhenSelected: TProcedureRef);
begin
  ChangeInterface(DialogYesOrNo);
  NowUserSelect := true;
  TextDialog.Text := AText;
  AfterUserEvent := AWhenSelected;
end;

procedure TForm1.UserSelectBookmarkList(AWhenSelected: TProcedureRef);
begin
  GotoBookmarksMenu(BookmarksDb);
  NowUserSelect := true;
  AfterUserEvent := AWhenSelected;
end;

end.

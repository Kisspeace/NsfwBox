﻿{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit Unit1;

interface

uses
  {$IFDEF ANDROID}
  Fmx.Helpers.Android, AndroidApi.Helpers,
  AndroidApi.JNI.GraphicsContentViewText,
  AndroidApi.JNI.JavaTypes,
  {$ELSE IF MSWINDOWS}
  ShellApi, Windows, NsfwBox.WindowsTitlebar,
  {$ENDIF}
  System.SysUtils, System.Types, System.UITypes, System.Classes, Fmx.Objects,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, XSuperObject,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Color, FMX.Edit, FMX.Layouts,
  Net.HttpClient, Net.HttpClientComponent, IoUtils, NsfwBox.FileSystem,
  NethttpClient.Downloader, FMX.Memo, FMX.Memo.Types, FMX.ScrollBox, NsfwXxx.Types,
  System.Hash, FMX.Surfaces, System.Variants, System.Threading,
  system.NetEncoding, System.Net.URLClient, System.StartUpCopy,
  FMX.VirtualKeyboard, Fmx.Platform, SimpleClipboard,
  DbHelper, System.Generics.Collections, BooruScraper.Interfaces,
  NinehentaiTo.APITypes, System.SyncObjs, System.Math,
  { Alcinoe ---------- }
  Alcinoe.FMX.Graphics, Alcinoe.FMX.Objects,
  { Kastri ----------- }
  {$IFDEF ANDROID}
  DW.Toast.Android,
  {$ENDIF}
  { NsfwBox ---------- }
  NsfwBox.Interfaces, NsfwBox.Settings, NsfwBox.Graphics, NsfwBox.ContentScraper,
  NsfwBox.Provider.Pseudo, NsfwBox.Provider.NsfwXxx, NsfwBox.Provider.R34App,
  NsfwBox.Provider.R34JsonApi, NsfwBox.Provider.Bookmarks,
  NsfwBox.Provider.CoomerParty, NsfwBox.Provider.NineHentaiToApi, NsfwBox.Consts,
  NsfwBox.Provider.Randomizer, NsfwBox.Provider.BooruScraper,
  NsfwBox.Provider.Fapello, NsfwBox.Provider.GivemepornClub,
  NsfwBox.Provider.Motherless,
  NsfwBox.Graphics.Browser, NsfwBox.Styling, NsfwBox.Graphics.Rectangle,
  NsfwBox.DownloadManager, NsfwBox.Bookmarks, NsfwBox.Helper,
  NsfwBox.UpdateChecker, NsfwBox.MessageForDeveloper, Unit2,
  NsfwBox.Tests, NsfwBox.Logging, NsfwBox.Graphics.ImageViewer,
  NsfwBox.Utils, NsfwBox.GarbageCollector, NsfwBox.DataExportImport,
  NsfwBox.Cache,
  { you-did-well! ---- }
  YDW.FMX.ImageWithURL.AlRectangle, YDW.FMX.ImageWithURLManager,
  YDW.FMX.ImageWithURLCacheManager, YDW.FMX.ImageWithURL.Interfaces,
  YDW.FMX.ImageWithURL;

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
    MenuImageViewer: TVertScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FLock: TMREWSync;
    FAppDestroying: boolean;
    FSettings: TNsfwBoxSettings;
    FAppStyle: TNBoxGUIStyle;
    FFormCreated: boolean;
    FCurrentBrowser: TNBoxBrowser;
    FCurrentItem: TNBoxCardBase;
    FCurrentBookmarksDb: TNBoxBookmarksDb;
    FCurrentBookmarkControl: TNBoxSettingsCheck;
    FCurrentBookmarkGroup: TBookmarkGroupRec;
    FCurrentItemForWaitFetch: INBoxItem;
    FCurrentItemForWaitFetchEvent: TEvent;
    function GetAppDestroying: boolean;
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
    function GetAppFullscreen: boolean;
    procedure SetAppFullscreen(const Value: boolean);
    procedure SetCurrentItemForWaitFetch(const Value: INBoxItem);
  public
    { Public declarations }
    {$IFDEF MSWINDOWS}
    TitleBar: TNBoxFormTitleBar;
    {$ENDIF}

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
        MenuTestButtons: TList<TRectButton>;
    TabsScroll: TVertScrollBox;
    Browsers: TNBoxBrowserList;
    Tabs: TNBoxBrowserTabList;

    { OnBrowserLayout }
    BtnNext: TRectButton;
    BtnPrev: TRectButton;
    BtnStatus: TRectButton;

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
    BtnPlayInternaly,
    BtnPlayExternaly,
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
    BtnBMarkDelete,
    BtnBMarkPushUp,
    BtnBMarkPushDown
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
    HistoryDbControls: TControlObjList;

    { Menu log }
    MemoLog: TNBoxMemo;

    { Settings Menu }
    BtnOpenAppRep: TRectButton;
    CheckSetFullscreen,
    CheckSetAllowCookies,
    CheckSetEnableAllContent,
    CheckSetAutoSaveSession,
    CheckSetSaveSearchHistory,
    CheckSetSaveTapHistory,
    CheckSetSaveDownloadHistory,
    CheckSetSaveTabHistory,
    CheckSetShowCaptions,
    CheckSetShowBrowserStatus,
    CheckSetShowImageViewerStatus,
    CheckSetAllowDuplicateTabs,
    CheckSetAutoStartBrowse,
    CheckSetAutoCloseItemMenu,
    CheckSetDevMode,
    CheckSetAutoCheckUpdates,
    CheckSetShowScrollBars,
    CheckSetShowNavigateBackButton,
    CheckSetBrowseNextPageByScrollDown,
    CheckSetPlayExterWhenCantInter,
    CheckSetImageCacheSave,
    CheckSetImageCacheLoad,
    CheckSetAutoAcceptAllCertificates,
    CheckSetYDWSyncLoadFromFile,
    CheckSetUseNewAppTitlebar,
    CheckSetFetchAllBeforeAddBookmark
    : TNBoxSettingsCheck;

    EditSetDefUseragent,
    EditSetDefDownloadPath,
    EditSetThreadsCount,
    EditSetMaxDownloadThreads,
    EditSetLayoutsCount,
    EditSetItemIndent,
    EditSetFilenameLogUrls,
    EditSetPlayParams,
    EditSetPlayApp,
    EditSetDefBackupPath
    : TNBoxSettingsEdit;

    BtnSetAnonMsg,
    BtnSetViewLog,
    BtnSetChangeOnItemTap,
    BtnSetChangeTheme,
    BtnSetSave,
    BtnSetManageBackups,
    BtnSetChangeDownloadAllMode
    : TRectButton;

    { Settings }
    CheckMenuSetOnItemTap: TNBoxCheckMenu;
    BtnSetSaveOnItemTap: TRectButton;
    MenuChangeTheme: TNBoxSelectMenuStr;
    MenuChangeDownloadAllMode: TNBoxSelectMenuInt;

    MenuItemTags: TNBoxSelectMenuTag;
    MenuItemTagsOrigin: integer;

    { Image viewer menu }
    ImageViewer: TNBoxImageViewer;
    BtnStatusImageView: TRectButton;

    { Anonymous message menu (MenuAnonMessage) }
    EditNickMsgForDev: TNBoxEdit;
    MemoMsgForDev: TNBoxMemo;
    BtnSendMsgForDev: TRectButton;
    BtnSendLogs: TRectButton;

    { Menu for manage backups }
    MenuBackup: TVertScrollBox;
    EdtBackupFilename: TNBoxEdit;
    BtnCreateBackup: TRectButton;
    SelectMenuBackupFiles: TNBoxSelectMenuStr;
    EdtApplyBackupFilename: TNBoxEdit;
    BtnApplyBackup: TRectButton;

    function CreateTabText(ABrowser: TNBoxBrowser): string;
    procedure AppOnException(Sender: TObject; E: Exception);
    procedure ClickTapRef(Sender: TObject);
    procedure SetClick(A: TControl);
    { -> Menu buttons ------------- }
    procedure MenuBtnDownloadsOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuBtnDownloadsOnDblClick(Sender: TObject);
    procedure MenuBtnSettingsOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuBtnNewTabOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuBtnBookmarksOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuBtnHistoryOnTap(Sender: TObject; const Point: TPointF);
    { -> Other -------------------- }
    function GetHashedDownloadFullFilename(AFilename: string; AOrigin: integer = -2; AWithExtension: boolean = True): string;
    function FindDownloadedFullFilename(AUrl: string): string;
    procedure TopBtnAppOnTap(Sender: TObject; const Point: TPointF);
    procedure TopBtnSearchOnTap(Sender: TObject; const Point: TPointF);
    procedure TopBtnPopMenuOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnNextOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnPrevOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuItemTagsOnSelected(Sender: TObject);
    procedure LayoutDialogYesOrNoOnResize(Sender: TObject);
    procedure OnIWUFilterResponse(Sender: TObject; const AUrl: string; const AResponse: IHttpResponse; var AAllow: boolean);
    procedure OnIWUException(Sender: TObject; AImage: IImageWithURL; const AUrl: string; const AException: Exception);
    procedure NetHttpOnValidateCertAutoAccept(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate; var Accepted: Boolean);
    procedure SetDefToWebClient(AClient: TNetHttpClient; AOrigin: integer = -999);
    procedure ToastMessage(const AMessage: string; AShort: boolean);
    procedure OnIWUManagerCreateWebClient(Sender: TObject; AClient: TNetHttpClient);
    procedure OnImageViewerWebClient(Sender: TObject; AClient: TNetHttpClient);
    procedure OnImageViewerReceiveData(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var AAbort: Boolean);
    procedure SetBrowserStatus(const AStr: string; AImagePath: string = '');
    procedure SetImageViewerStatus(const AStr: string; AImagePath: string = '');
    function FetchContent(AItem: INBoxItem): INBoxItem;
    procedure ContentFetcherOnFetched(Sender: TObject; var AItem: INBoxItem);
    { -> Tabs --------------------- }
    procedure BtnTabCloseOnTap(Sender: TObject; const Point: TPointF);
    procedure TabOnTap(Sender: TObject; const Point: TPointF);
    { -> Send message for dev ----- }
    procedure BtnSetAnonMsgOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSendLogsOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSendMsgForDevOnTap(Sender: TObject; const Point: TPointF);
    { ----------------------------- }
    procedure BtnOpenAppRepOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetChangeThemeOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetManageBackupsOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnItemMenuOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetViewLogOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetSaveOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetChangeOnItemTapOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetChangeDownloadAllModeOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSetSaveOnItemTapOnTap(Sender: TObject; const Point: TPointF);
    procedure SettingsCheckOnTap(Sender: TObject; const Point: TPointF);
    procedure IconOnResize(Sender: TObject);
    procedure BookmarksControlOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuChangeThemeOnSelected(Sender: TObject);
    procedure MenuChangeDownloadAllModeOnSelected(Sender: TObject);
    { -> Search Menu do list buttons }
    procedure BtnSearchAddBookmarkOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnSearchSetDefaultOnTap(Sender: TObject; const Point: TPointF);
    { -> Bookmark menu buttons ---- }
    procedure MoveBookmarkGroupOrderIndex(AGroupId: UInt64; AMoveValue: integer);
    procedure DeleteFromBookmarkGroupOrder(AGroupId: UInt64);
    procedure BtnBMarkSaveChangesOnTap(Sender: TObject; const Point: TPointF);
    procedure BMarkOpen(AOpenLastPage: boolean);
    procedure BtnBMarkOpenOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnBMarkOpenLastPageOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnBMarkChangeOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnBMarkCreateOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnBMarkDeleteOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnBMarkPushUpOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnBMarkPushDownOnTap(Sender: TObject; const Point: TPointF);
    { -> Dialog Yes or No --------- }
    procedure BtnDialogYesOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnDialogNoOnTap(Sender: TObject; const Point: TPointF);
    { ----------------------------- }
    procedure DownloadFetcherOnFetched(Sender: TObject; var AItem: INBoxItem);
    procedure OnCreateDownloader(Sender: Tobject; const ADownloader: TNBoxDownloader);
    procedure OnStartDownloader(Sender: Tobject; const ADownloader: TNBoxDownloader);
    procedure CloseDownloadTabOnTap(Sender: TObject; const Point: TPointF);
    procedure DownloaderOnCreateWebClient(const Sender: TObject; AWebClient: TNetHttpClient);
    procedure DownloaderOnReceiveData(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var AAbort: Boolean);
    procedure DownloaderOnException(const Sender: TObject; const AError: Exception);
    procedure DownloaderOnFinish(Sender: TObject);
    procedure OnImageViewerFinished(Sender: TObject; ASuccess: boolean);
    { ----------------------------- }
    procedure ExecItemInteraction(AItem: TNBoxCardBase; AInteraction: TNBoxItemInteraction);
    procedure OnBrowsersNotify(Sender: TObject; const Item: TNBoxBrowser; Action: TCollectionNotification);
    { ----------------------------- }
    function IndexTabByBrowser(ABrowser: TNBoxBrowser): integer;
    { ----------------------------- }
    procedure RestoreDefaultSettings;
    {$IFDEF MSWINDOWS}
    procedure RestoreDefaultStyle;
    {$ENDIF}
    { Menu for manage backups ----- }
    procedure BtnCreateBackupOnTap(Sender: TObject; const Point: TPointF);
    procedure BtnApplyBackupOnTap(Sender: TObject; const Point: TPointF);
    procedure MenuBackupFilesOnSelect(Sender: TObject);
    { ----------------------------- }
    procedure ChangeInterface(ALayout: TControl);
    procedure UserSelectBookmarkList(AWhenSelected: TProcedureRef);
    procedure UserBooleanDialog(AText: string; AWhenSelected: TProcedureRef);
    procedure GotoSearchSettings(ABrowser: TNBoxBrowser = nil);
    procedure GotoItemMenu(AItem: TNBoxCardBase);
    procedure GotoDownloadsMenu;
    procedure GotoItemTagsMenu(ATags: TNBoxItemTagAr; AOrigin: integer);
    procedure GotoBookmarksMenu(ABookmarksDb: TNBoxBookmarksDb);
    function GotoImageViewer(AImageUrl: string; AQuietFail: boolean = False): boolean; { FALSE when cant show image by given URL }
    { -> Browsers ----------------- }
    procedure OnBrowserViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure OnBrowserSetWebClient(Sender: TObject; AWebClient: TNetHttpClient; AOrigin: integer);
    procedure OnBrowserExcept(Sender: TObject; const AExcept: Exception);
    procedure OnBrowserScraperCreate(Sender: TObject; var AScraper: TNBoxScraper);
    procedure OnBrowserReqChanged(Sender: TObject);
    procedure BrowserBeforeBrowse(Sender: TObject);
    procedure OnBrowserDblClick(Sender: TObject);
    procedure OnBrowserGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    { -> Cards events ------------- }
    procedure OnNewItem(Sender: TObject; var AItem: TNBoxCardBase);
    procedure OnSimpleCardResize(Sender: TObject);
    procedure OnCardAutoLook(Sender: TObject);
    procedure CardOnTap(Sender: TObject; const Point: TPointF);
    procedure CardOnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    { ----------------------------- }
    procedure SaveSettings;
    procedure SaveSettingsChanges;
    function LoadSettings: boolean;
    function LoadStyle: boolean;
    procedure ConnectSession;
    function LoadSession: boolean;
    procedure ReloadBookmarks(ADataBase: TNBoxBookmarksDb; ALayout: TControl);
    { -> Control utils ------------ }
    procedure ClearControlBitmap(AControl: TControl);
    procedure SetStretchImage(AImage: TControl);
    { -> Fabrics ------------------ }
    function CreateDefScroll(AOwner: TComponent): TVertScrollBox;
    function CreateDefRect(AOwner: TComponent): TAlRectangle;
    function CreateDefBrowser(AOwner: TComponent): TNBoxBrowser;
    function CreateDefTab(AOwner: TComponent; AClass: TNBoxTabClass): TNBoxTab; overload;
    function CreateDefTab(AOwner: TComponent): TNBoxTab; overload;
    function CreateDefCheck(AOwner: TComponent): TRectTextCheck;
    function CreateDefCheckButton(AOwner: TComponent; AStyle: integer = 0): TNBoxCheckButton;
    function CreateDefRadioButton(AOwner: TComponent; AStyle: integer = 0): TNBoxRadioButton;
    function CreateDefButtonC(AOwner: TComponent; AClass: TRectButtonClass; AImageClass: TControlClass; AStyle: integer = 0): TRectButton;
    function CreateDefButton(AOwner: TComponent; AStyle: integer = 0): TRectButton;
    function CreateDefText(AOwner: TComponent; AStyle: integer = 0): TAlText;
    function CreateDefEdit(AOwner: TComponent; AStyle: integer = 0): TNBoxEdit;
    function CreateDefMemo(AOwner: TComponent; AStyle: integer = 0): TNBoxMemo;
    function CreateDefSettingsCheck(AOwner: TComponent): TNBoxSettingsCheck;
    function CreateDefSettingsEdit(AOwner: TComponent; AStyle: integer = 0): TNBoxSettingsEdit;
    function CreateDefScraper: TNBoxScraper;
    function NewMenu: TVertScrollBox;
    { -> Download ----------------- }
    function AddDownload(AItem: INBoxItem; ADontFetch: boolean = False; ASelectFilesMode: TDownloadAllMode = damAllVersions): TNBoxTab; overload;
    function AddDownload(AUrl, AFullFilename: string): TNBoxTab; overload;
    { ----------------------------- }
    function AddSettingsCheck(ACaption, AAttrName: string; AText: string = ''): TNBoxSettingsCheck;
    function AddSettingsEdit(ACaption, AAttrName: string; AText: string = ''; AStyle: integer = 0): TNBoxSettingsEdit;
    function AddSettingsButtonC(AText: string; AImageName: string; AImageClass: TControlClass): TRectButton;
    function AddSettingsButton(AText: string; AImageName: string = ''): TRectButton;
    function AddBMarksDoListButton(AText: string; AImageName: string = ''; AOnTap: TTapEvent = nil; ATag: string = ''): TRectButton;
    function AddMenuBtn: TRectButton;
    function AddMenuSearchBtn(AText: string; AImageName: string = ''; AOnTap: TTapEvent = nil): TRectButton;
    function AddItemMenuBtn(ACaption: string; AAction: TNBoxItemInteraction; AImageName: string = ''; ATag: string = ''): TRectButton;
    function AddBrowser(ARequest: INBoxSearchRequest = nil; AAutoStartBrowse: boolean = false; AAbortIfReqExists: boolean = False): TNBoxBrowser.TNBoxTab;
    procedure DeleteBrowser(ABrowser: TNBoxBrowser; ADeleteFromSession: boolean = True);
    procedure DeleteAllBrowsers(ADeleteFromSession: boolean = True);
    { -> Properies ---------------- }
    property CurrentBrowser: TNBoxBrowser read FCurrentBrowser write SetCurrentBrowser;
    property CurrentItem: TNBoxCardBase read FCurrentItem write SetCurrentItem;
    property CurrentBookmarksDb: TNBoxBookmarksDb read FCurrentBookmarksDb write SetCurrentBookmarksDb;
    property CurrentBookmarkControl: TNBoxSettingsCheck read FCurrentBookmarkControl write SetCurrentBookmarkControl;
    property CurrentBookmarkGroup: TBookmarkGroupRec read FCurrentBookmarkGroup;
    property CurrentItemForWaitFetch: INBoxItem read FCurrentItemForWaitFetch write SetCurrentItemForWaitFetch;
    property AppStyle: TNBoxGUIStyle read GetAppStyle write SetAppStyle;
    property Settings: TNsfwBoxSettings read GetSettings write SetSettings;
    property SubHeader: string read GetSubHeader write SetSubHeader;
    property AppFullscreen: boolean read GetAppFullscreen write SetAppFullscreen;
    property AppDestroying: boolean read GetAppDestroying; // True when app destroying.
  end;

var
  Form1: TForm1;
  APP_VERSION: TSemVer; // Current application version

  LOG_FILENAME         : string = 'log.txt';
  YDW_LOG_FILENAME     : string = 'you-did-well-debug-log.txt';
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

  ContentFetcher: TNBoxFetchManager;
  FetchedItemsCache: TFetchedItemsCache;

  NowLoadingSession: boolean   = false;
  NowUserSelect: boolean = false;
  DoWithAllItems: boolean = false;

  { Static Images }
  DummyLoadingImage: Fmx.Graphics.TBitmap;

const
  TAG_CAN_USE_MORE_THAN_ONE: string = '>';
  BTN_STYLE_DEF        = 0;
  BTN_STYLE_ICON       = 1;
  BTN_STYLE_ICON2      = 2;
  BTN_STYLE_ICON3      = 3;
  BTN_STYLE_DEF2       = 4;

  EDIT_STYLE_INT       = 1;

  TOPRECT_HEIGHT      = 48;
  {$IFDEF MSWINDOWS}
    CONTROLS_DEF_HEIGHT = 40;
    BUTTON_HEIGHT       = 40;
    TAB_DEF_HEIGHT      = 40;
    EDIT_DEF_HEIGHT     = 35;
  {$ELSE}
    CONTROLS_DEF_HEIGHT = 45;
    BUTTON_HEIGHT       = 50;
    TAB_DEF_HEIGHT      = 46;
    EDIT_DEF_HEIGHT     = 40;
  {$ENDIF}

  DEFAULT_IMAGE_CLASS: TControlClass = TImageWithUrl;
  DEFAULT_BUTTON_CLASS: TRectButtonClass = TRectButton;

implementation

{$R *.fmx}

{$IFDEF ANDROID}
procedure StartActivity(AUri: string; AAction: JString; AType: string = '');
var
  Intent: JIntent;
begin
  try
    Intent := TJintent.Create;
    Intent.setAction(AAction);

    if not AType.IsEmpty then
      Intent.setDataAndType(StrToJURI(AUri), StringToJString(AType))
    else
      Intent.setData(StrToJURI(AUri));

    TAndroidHelper.Activity.startActivity(Intent);
  except On E: Exception do
    Log('StartActivity: ', E);
  end;
end;

procedure StartActivityView(AUri: string);
begin
  StartActivity(AUri, TJintent.JavaClass.ACTION_VIEW);
end;

procedure StartActivityViewVideo(AUri: string);
begin
  StartActivity(AUri, TJintent.JavaClass.ACTION_VIEW, 'video/*');
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
    LDir := TPath.GetDirectoryName(AFilename);
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

function TForm1.AddBMarksDoListButton(AText: string; AImageName: string = '';
  AOnTap: TTapEvent = nil; ATag: string = ''): TRectButton;
begin
  Result := CreateDefButton(MenuBookmarksDoList);
  with Result do begin
    Parent := MenuBookmarksDoList;
    Align := TAlignlayout.Top;
    Image.ImageURL := AppStyle.GetImagePath(AImageName);
    Text.Text := AText;
    OnTap := AOnTap;
    TagString := ATag;
    ButtonsBMark.Add(Result);
  end;
end;

function TForm1.AddBrowser(ARequest: INBoxSearchRequest;
  AAutoStartBrowse, AAbortIfReqExists: boolean): TNBoxBrowser.TNBoxTab;
var
  LBrowser: TNBoxBrowser;
  LTab: TNBoxBrowser.TNBoxTab;

  function IsSameRequestAlreadyExists(AReq: INBoxSearchRequest): boolean;
  var
    I: integer;
    LReqStrIsEmpty: boolean;
  begin
    for I := 0 to Browsers.Count - 1 do
    begin
      var LReq: INBoxSearchRequest := Browsers[I].Request;

      if not Assigned(LReq) or (LReq.Origin <> AReq.Origin) then
        Continue;

      LReqStrIsEmpty := AReq.Request.IsEmpty;

      if (AReq is TNBoxSearchReqNsfwXxx) and (not LReqStrIsEmpty) then
      begin
        var R1, R2: TNBoxSearchReqNsfwXxx;
        R1 := AReq as TNBoxSearchReqNsfwXxx;
        R2 := LReq as TNBoxSearchReqNsfwXxx;
        if (R1.SearchType = R2.SearchType) and (R1.Request = R2.Request) then
          Exit(True);
      end

      else if (AReq is TNBoxSearchReqBooru) and (not LReqStrIsEmpty) then
      begin
        if LReq.Request = AReq.Request then Exit(True);
      end

      else if (AReq is TNBoxSearchReqCoomerParty) then
      begin
        var R1, R2: TNBoxSearchReqCoomerParty;
        R1 := AReq as TNBoxSearchReqCoomerParty;
        R2 := LReq as TNBoxSearchReqCoomerParty;
        if (R1.Site = R2.Site)
        and (R1.UserId = R2.UserId) and (R1.Service = R2.Service)
        and (R1.Request = R2.Request) then
          Exit(True);
      end

      else if (AReq is TNBoxSearchReqFapello) and (not LReqStrIsEmpty) then
      begin
        var R1, R2: TNBoxSearchReqFapello;
        R1 := AReq as TNBoxSearchReqFapello;
        R2 := LReq as TNBoxSearchReqFapello;
        if (R1.RequestKind = R2.RequestKind) and (R1.Request = R2.Request) then
          Exit(True);
      end

      else if (AReq is TNBoxSearchReqGmpClub) and (not LReqStrIsEmpty) then
      begin
        var R1, R2: TNBoxSearchReqGmpClub;
        R1 := AReq as TNBoxSearchReqGmpClub;
        R2 := LReq as TNBoxSearchReqGmpClub;
        if (R1.SearchType = R2.SearchType) and (R1.Request = R2.Request) then
          Exit(True);
      end

      else if (AReq is TNBoxSearchReqMotherless) and (not LReqStrIsEmpty) then
      begin
        var R1, R2: TNBoxSearchReqMotherless;
        R1 := AReq as TNBoxSearchReqMotherless;
        R2 := LReq as TNBoxSearchReqMotherless;
        if (R1.Request = R2.Request)
        and (R1.ContentType = R2.ContentType)
        and (R1.MediaSize = R2.MediaSize)
        and (R1.UploadDate = R2.UploadDate)
        and (R1.Sort = R2.Sort) then
          Exit(True);
      end;

//      else if (AReq is TNBoxSearchReq9Hentaito) and (not LReqStrIsEmpty) then
//      begin
//        var R1, R2: TNBoxSearchReq9Hentaito;
//        R1 := AReq as TNBoxSearchReq9Hentaito;
//        R2 := LReq as TNBoxSearchReq9Hentaito;
//      end;

      FreeInterfaced(LReq);
    end;
    Result := False;
  end;

begin
  try
    { Exit if browser with same request is already exist. }
    if AAbortIfReqExists and Assigned(ARequest)
    and IsSameRequestAlreadyExists(ARequest) then
      Exit(Nil);

    LBrowser := Form1.CreateDefBrowser(BrowserLayout);
    Browsers.Add(LBrowser);
    with LBrowser do
    begin
      Tag              := -1;
      Parent           := BrowserLayout;
      OnRequestChanged := OnBrowserReqChanged;
      OnItemCreate     := OnNewItem;
      BeforeBrowse     := BrowserBeforeBrowse;
      DummyImage       := DummyLoadingImage;
    end;

    LTab := TNBoxBrowser.TNBoxTab(Form1.CreateDefTab(LBrowser, TNBoxBrowser.TNBoxTab));
    Tabs.Add(LTab);
    with LTab do
    begin
      ImageControl.Visible := false;
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
      Browser := LBrowser;
    end;

    LBrowser.Tab := LTab;

    try
      LBrowser.Request := ARequest;
    except
      On E: Exception do Log('AddBrowser B.Request := ARequest;', E);
    end;
    Form1.OnBrowserLayout.BringToFront;
    Result := LTab;

    if AAutoStartBrowse then
      LBrowser.GoBrowse;
  except
    On E: Exception do Log('AddBrowser', E);
  end;
end;

function TForm1.AddDownload(AItem: INBoxItem; ADontFetch: boolean;
  ASelectFilesMode: TDownloadAllMode): TNBoxTab;
var
  LFull, LUrl: string;
  I: integer;
  LFetchable: IFetchableContent;
  LUrlsAr: TArray<String>;
begin
  Result := Nil;

  if Not ADontFetch
  And Supports(AItem, IFetchableContent, LFetchable)
  And Not LFetchable.ContentFetched
  And not FetchedItemsCache.UpdateWithCached(AItem)
  then begin
    DownloadFetcher.Add(AItem.Clone);
    exit;
  end;

  if Settings.SaveDownloadHistory then
    HistoryDb.DownloadGroup.Add(AItem);

  LUrlsAr := AItem.GetContentUrls(ASelectFilesMode);
  for I := 0 to High(LUrlsAr) do
  begin
    LUrl := LUrlsAr[I];
    LFull := Settings.DefDownloadPath;

    if not DirectoryExists(LFull) then
      CreateDir(LFull);

    var LPreviewed: string;
    with ImageViewer.ImageManager.CacheManager
      as TImageWithURLCahceManager do
        LPreviewed := FindCachedFilename(LUrl);

    LFull := GetHashedDownloadFullFilename(LUrl, AItem.Origin);

    if not fileexists(LFull) then
    begin
      if (not LPreviewed.IsEmpty) then
      begin
        try
          TFile.Move(PChar(LPreviewed), PChar(LFull));
        except on E: Exception do
          Log('TForm1.AddDownload. Moving previewed.', E);
        end;
      end else
        AddDownload(LUrl, LFull);
    end;
  end;
end;

function TForm1.AddDownload(AUrl, AFullFilename: string): TNBoxTab;
var
  Loader: TNetHttpDownloader;
begin
  if not Fileexists(AFullFilename) then begin

    Result := CreateDefTab(MenuDownloads);
    with Result do
    begin
      Align := TAlignLayout.Top;
      Position.Y := 0;
      margins.Rect := TRectF.Create(10, 10, 10, 0);
      Text.Text := AFullFilename;
      Parent := MenuDownloads;
      ImageControl.Visible := false;

      Closebtn.OnTap := CloseDownloadTabOnTap;
      {$IFDEF MSWINDOWS}
      Closebtn.OnClick := ClickTapRef;
      {$ENDIF}
    end;

    Loader := Downloadmanager.AddDownload(Aurl, AFullFilename, Result);
    Result.TagObject := Loader;
    DownloadItems.Add(Result);

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
    Image.ImageURL := AppStyle.GetImagePath(AImageName);
    Text.Text := ACaption;
    Tag := Ord(AAction);
    OnTap := BtnItemMenuOnTap;
    Result.TagString := ATag;
    Text.TextIsHtml := True;
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
    Image.ImageURL := AppStyle.GetImagePath(AImageName);
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
      Height := Height + 20;
    end;
  end;
end;

function TForm1.AddSettingsButton(AText, AImageName: string): TRectButton;
begin
  Result := AddSettingsButtonC(AText, AImageName, DEFAULT_IMAGE_CLASS);
end;

function TForm1.AddSettingsButtonC(AText, AImageName: string;
  AImageClass: TControlClass): TRectButton;
begin
  Result := CreateDefButtonC(MenuSettings, DEFAULT_BUTTON_CLASS, AImageClass, BTN_STYLE_DEF2);
  with Result do begin
    _SetDefSettingsControl(Result);
    Text.Text := AText;
    if not AImageName.IsEmpty then
      Image.ImageURL := AppStyle.GetImagePath(AImageName);
  end;
end;

function TForm1.AddSettingsCheck(ACaption, AAttrName, AText: string): TNBoxSettingsCheck;
begin
  Result := CreateDefSettingsCheck(MenuSettings);
  _SetDefSettingsCheck(Result, ACaption, AText);
  Result.TagString := AAttrName;
end;

function TForm1.AddSettingsEdit(ACaption, AAttrName, AText: string; AStyle: integer): TNBoxSettingsEdit;
begin
  Result := CreateDefSettingsEdit(MenuSettings, AStyle);
  _SetDefSettingsCheck(Result, ACaption, AText);
  with Result do begin
    Edit.Edit.TextPrompt := ACaption;
    Height := Height * 1.8;
    TagString := AAttrName;
  end;
end;

procedure TForm1.AppOnException(Sender: TObject; E: Exception);
begin
  Log('AppException ' + Sender.ClassName, E);
end;

procedure TForm1.BookmarksControlOnTap(Sender: TObject; const Point: TPointF);
begin
  CurrentBookmarkControl := ( Sender As TNBoxSettingsCheck );

  if not NowUserSelect then
  begin
    DoWithAllItems := false;
    ChangeInterface(MenuBookmarksDoList);
  end else begin
    if assigned(Self.AfterUserEvent) then begin
      AfterUserEvent();
      AfterUserEvent := nil;
    end;
    NowUserSelect := false;
  end;
end;

procedure TForm1.BrowserBeforeBrowse(Sender: TObject);
var
  LReq: INBoxSearchRequest;
begin
  if not Settings.SaveSearchHistory then exit;
  try
    LReq := (Sender as TNBoxBrowser).Request;
    HistoryDb.SearchGroup.Add(LReq);
    if (CurrentBrowser = Sender) and Settings.ShowBrowserStatusBar then
      SetBrowserStatus('Search ' + LReq.PageId.ToString + ': '
      + PROVIDERS.ById(LReq.Origin).TitleName, AppStyle.GetImagePath(LReq.Origin));
  finally
    FreeInterfaced(LReq);
  end;
end;

procedure TForm1.BtnApplyBackupOnTap(Sender: TObject;
  const Point: TPointF);
var
  LFilename: string;
begin
  LFilename := EdtApplyBackupFilename.Edit.Text;
  if FileExists(LFilename) then
  begin
    try
      ImportAppData(LFilename, DEF_EXIM_OPTIONS);
      {$IFDEF MSWINDOWS}
      ShowMessage('Success. Please restart application.');
      Application.Terminate;
      {$ELSE}
      UserBooleanDialog('Success. Please restart application.',
        procedure begin
         Application.Terminate;
        end);
      {$ENDIF}
    except
      On E: Exception do
      begin
        Log('ApplyBackup', E);
        ShowMessage('Error: ' + E.Message);
      end;
    end;
  end else
    ShowMessage(LFilename + ' does not exist.');
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
  MoveBookmarkGroupOrderIndex(Group.Id, 1);
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
    begin
      if UserSayYes then begin

        if CurrentBookmarksDb = BookmarksDb then begin
          CurrentBookmarksDb.DeleteAllGroups;
          BookmarksControls.Clear;
          Settings.BookmarksOrder.Clear;
          SaveSettings;
        end else if CurrentBookmarksDb = HistoryDb then begin
          CurrentBookmarksDb.DeleteAllItems;
          HistoryDbControls.Clear;
        end;

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

        if (CurrentBookmarksDb = HistoryDb) then begin
          CurrentBookmarkGroup.ClearGroup;
        end else if (CurrentBookmarksDb = BookmarksDb) then begin
          CurrentBookmarkGroup.DeleteGroup;
          BookmarksControls.Clear;
          DeleteFromBookmarkGroupOrder(CurrentBookmarkGroup.Id);
        end;

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
  Req := Nil;
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

      AddBrowser(Req, True);
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
    AddBrowser(Req, True);

  end;

  CurrentBrowser := browsers.Last;
  ChangeInterface(Self.BrowserLayout);

  if Assigned(Req) then
    FreeInterfaced(Req);
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

procedure TForm1.MoveBookmarkGroupOrderIndex(AGroupId: UInt64; AMoveValue: integer);
var
  LIndex, LSwapWithIndex: integer;
  LOrder: TList<Int64>;
begin
  if AMoveValue = 0 then exit;
  LOrder := Settings.BookmarksOrder.LockList;
  try
    LIndex := LOrder.IndexOf(AGroupId);

    if (LIndex <> -1) then
    begin
      if AMoveValue < 0 then
        LSwapWithIndex := LIndex - AMoveValue
      else
        LSwapWithIndex := LIndex - AMoveValue;

      if LSwapWithIndex < 0 then
        LSwapWithIndex := 0
      else if LSwapWithIndex > (LOrder.Count - 1) then
        LSwapWithIndex := LOrder.Count - 1;

      if LIndex = LSwapWithIndex then exit;
      LOrder.Exchange(LIndex, LSwapWithIndex)
    end else if (AMoveValue > 0) then
      LOrder.Add(AGroupId);
  finally
    Settings.BookmarksOrder.UnlockList;
  end;
  SaveSettings;
end;

procedure TForm1.BtnBMarkPushDownOnTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(CurrentBookmarkControl) then
    MoveBookmarkGroupOrderIndex(CurrentBookmarkGroup.Id, -1);
end;

procedure TForm1.BtnBMarkPushUpOnTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(CurrentBookmarkControl) then
    MoveBookmarkGroupOrderIndex(CurrentBookmarkGroup.Id, 1);
end;

procedure TForm1.BtnBMarkSaveChangesOnTap(Sender: TObject; const Point: TPointF);
begin
  if Assigned(AfterUserEvent) then begin
    AfterUserEvent();
    AfterUserEvent := nil;
  end;
end;

procedure TForm1.BtnCreateBackupOnTap(Sender: TObject; const Point: TPointF);
var
  LDirectory: string;
  LFilename: string;
begin
  LFilename := EdtBackupFilename.Edit.Text;
  LDirectory := TPath.GetDirectoryName(LFilename);
  try
    if not DirectoryExists(LDirectory) then
      ForceDirectories(LDirectory);

    ExportAppData(LFilename, DEF_EXIM_OPTIONS);
    Log('New backup: ' + LFilename);
    ShowMessage('Success.');
  except
    On E: Exception do begin
      Log('CreateBackup', E);
      Showmessage('Error: ' + E.Message);
    end;
  end;
  EdtBackupFilename.Edit.Text := TPath.Combine(Settings.DefaultBackupPath, GenerateNewBackupFilename);
end;

procedure TForm1.BtnDialogNoOnTap(Sender: TObject; const Point: TPointF);
begin
  UserSayYes := false;
  if Assigned(AfterUserEvent) then
  begin
    AfterUserEvent();
    AfterUserEvent := nil;
  end;
end;

procedure TForm1.BtnDialogYesOnTap(Sender: TObject; const Point: TPointF);
begin
  UserSayYes := true;
  if Assigned(AfterUserEvent) then
  begin
    AfterUserEvent();
    AfterUserEvent := nil;
  end;
end;

procedure TForm1.BtnItemMenuOnTap(Sender: TObject; const Point: TPointF);
var
  Action: TNBoxItemInteraction;
  I: integer;
begin
  Action := TNBoxItemInteraction(TControl(Sender).Tag);

  if not Assigned(CurrentBrowser) then exit;

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
              ToastMessage(CurrentBrowser.Items.Count.ToString + ' items to ' + Table.Name, True);
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
    if Assigned(CurrentBookmarkControl) then
    begin
      if ( CurrentBookmarkGroup.Id <> -1 ) then
      begin
        var LReq := SearchMenu.Request;
        try
          CurrentBookmarkGroup.Add(LReq)
        finally
          FreeInterfaced(LReq);
        end;
      end;

      CurrentBookmarkControl := nil;
      ChangeInterface(MenuSearchSettings);
    end;
  end);
end;

procedure TForm1.BtnSearchSetDefaultOnTap(Sender: TObject;
  const Point: TPointF);
begin

end;

procedure TForm1.BtnSendLogsOnTap(Sender: TObject; const Point: TPointF);
var
  LFinalMsg: String;
  LSuccess: boolean;
begin
  try
    if FileExists(YDW_LOG_FILENAME) then
    begin
      LFinalMsg := TFile.ReadAllText(YDW_LOG_FILENAME);
      LFinalMsg := LFinalMsg + SLineBreak;
    end;

    if FileExists(LOG_FILENAME) then
      LFinalMsg := LFinalMsg + LoadCompressedLog(MAX_MSG_LENGTH - LFinalMsg.Length);

    LSuccess := SendMessage(EditNickMsgForDev.Edit.Text, LFinalMsg, True);
  except
    LSuccess := False;
  end;

  if LSuccess then
  begin
    Showmessage('Logs sended successfully!');
    BtnSendLogs.Visible := False;
  end else
    ShowMessage('Error.');
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

  if Success then
  begin
    MemoMsgForDev.Memo.Lines.Clear;
    Showmessage('Success!');
  end else
    ShowMessage('Error.');
end;

procedure TForm1.BtnSetAnonMsgOnTap(Sender: TObject; const Point: TPointF);
begin
  ChangeInterface(MenuAnonMessage);
end;

procedure TForm1.BtnSetChangeDownloadAllModeOnTap(Sender: TObject;
  const Point: TPointF);
begin
  ChangeInterface(MenuChangeDownloadAllMode);
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

procedure TForm1.BtnSetManageBackupsOnTap(Sender: TObject;
  const Point: TPointF);
var
  I: integer;
  LDirectory: string;
  LFiles: TSearchRecAr;
begin
  LDirectory := Settings.DefaultBackupPath;
  EdtBackupFilename.Edit.Text := TPath.Combine(LDirectory, GenerateNewBackupFilename);

  if DirectoryExists(LDirectory) then
  begin
    LFiles := GetFiles(LDirectory + PathDelim);

    SelectMenuBackupFiles.Menu.FreeControls;
    for I := High(LFiles) downto Low(LFiles) do
    begin
      var LFile := LFiles[I];
      if (LFile.Name = '.') or (LFile.Name = '..') then continue;

      var LNewBtn := SelectMenuBackupFiles.AddBtn(TRectButton,
        LFile.Name + ' (' + BytesCountToSizeStr(LFile.Size) + ')',
        TPath.Combine(LDirectory, LFile.Name));

      LNewBtn.ImageControl.Visible := False;
      LNewBtn.Text.Margins.Left := 5;
      LNewBtn.Position.Y := Single.MaxValue;
    end;
  end;

  ChangeInterface(MenuBackup);
end;

procedure TForm1.BtnSetSaveOnItemTapOnTap(Sender: TObject;
  const Point: TPointF);
begin
  FSettings.ItemInteractions := CheckMenuSetOnItemTap.Checked;
  ChangeInterface(MenuSettings);
end;

procedure TForm1.BtnSetSaveOnTap(Sender: TObject; const Point: TPointF);
begin
  SaveSettingsChanges;
  ChangeInterface(BrowserLayout);
end;

procedure TForm1.BtnSetViewLogOnTap(Sender: TObject; const Point: TPointF);
begin
  ChangeInterface(MenuLog);
end;

procedure TForm1.BtnTabCloseOnTap(Sender: TObject; const Point: TPointF);
var
  LBrowser: TNBoxBrowser;
  NewCount: integer;
  LReq: INBoxSearchRequest;
  IsCurrentBrowser: boolean;
begin
  LBrowser := ((Sender as TControl).Owner.Owner as TNBoxBrowser);

  if Settings.SaveClosedTabHistory then
  begin
    LReq := LBrowser.Request;
    try
      HistoryDb.TabGroup.Add(LReq);
    finally
      FreeInterfaced(LReq);
    end;
  end;

  NewCount := Browsers.Count - 1;
  IsCurrentBrowser := (CurrentBrowser = LBrowser);

  if IsCurrentBrowser and (NewCount > 0) then
  begin
    if (CurrentBrowser = Browsers.Last) then
      CurrentBrowser := Browsers.First
    else
      CurrentBrowser := Browsers.Last;
  end;

  { Hide item menu }
  if MenuItem.Visible and IsCurrentBrowser then
    ChangeInterface(BrowserLayout);

  DeleteBrowser(LBrowser);
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
    For I := 0 to AControls.Count - 1 do
    begin
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
  { Set CurrentItem to nil every time when user leave MenuItem }
  if MenuItem.Visible and (ALayout <> MenuItem) then
    CurrentItem := Nil;

  { Need to free bitmap on image viewer }
  if MenuImageViewer.Visible then
    Form1.ClearControlBitmap(ImageViewer);

  { Clear lines from log memo when user go away }
  if MenuLog.Visible then
    MemoLog.Memo.Lines.Clear;

  Form1.MVMenu.HideMaster;
  for I := 0 to MainLayout.Controls.Count - 1 do
    MainLayout.Controls.Items[I].Visible := false;

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
    MenuChangeTheme.Menu.FreeControls;
    for I := 0 to High(ThemeFiles) do
    begin
      if (pos('.json', ThemeFiles[I].Name) > 0) then
        MenuChangeTheme.AddBtn(
          TPath.GetFileNameWithoutExtension(ThemeFiles[I].Name),
          ThemeFiles[I].Name,
          AppStyle.GetImagePath(ICON_NSFWBOX)
        );
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
    BtnBMarkCreate.Visible := DoWithAllItems;
    BtnBMarkPushUp.Visible := not (CurrentBookmarksDb = HistoryDb);
    BtnBMarkPushDown.Visible := BtnBMarkPushUp.Visible;

  end else if ( ALayout = MenuItem ) then begin
  { Menu with CurrentItem (card) actions }
    if not DoWithAllItems then
    begin
      if CurrentItem.HasPost then
      begin
        _SetVisible(ButtonsItemMenu, true);
        Post := CurrentItem.Post;
        BtnShowTags.Visible    := Supports(Post, IHasTags);
        BtnOpenAuthor.Visible  := Supports(Post, IHasArtists);
        BtnOpenRelated.Visible := ( Post is TNBoxNsfwXxxItem );
        BtnBrowse.Visible      := false;

      end else if CurrentItem.Bookmark.IsRequest then begin
        _SetVisible(ButtonsItemMenu, false);
        BtnBrowse.Visible      := true;
      end;
      BtnAddBookmark.Visible := true;
      BtnDeleteBookmark.Visible := CurrentItem.HasBookmark;
    end else begin
      BtnOpenAuthor.Text.Text := 'Open artists';
      BtnDownloadAll.Text.Text := 'Download content';
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
  with Sender as TControl do
    Ontap(Sender, TPointF.Create(0, 0));
  {$ENDIF}
end;

procedure TForm1.CloseDownloadTabOnTap(Sender: TObject; const Point: TPointF);
var
  LTab: TNBoxTab;
  Loader: TNBoxDownloader;
begin
  try
    LTab := (TControl(Sender).Parent as TNBoxTab);
    if Assigned(LTab.TagObject) then
    begin
      Loader := (LTab.TagObject as TNBoxDownloader);
      if Loader.IsRunning And (not Loader.IsAborted) then
        DownloadManager.AbortDownload(Loader);
      LTab.Visible := False;
    end;
  except
    On E: Exception do begin
      Log('TForm1.CloseDownloadTabOnTap', E);
    end;
  end;
end;

procedure TForm1.ConnectSession;
begin
  if Length(Session.GetBookmarksGroups) < 1 then
    Session.AddGroup('session', 'tabs here');
end;

procedure TForm1.ContentFetcherOnFetched(Sender: TObject; var AItem: INBoxItem);
var
  IsCurrentItemForWait: boolean;
begin
  try
    FetchedItemsCache.Save(AItem, True);
    FLock.BeginWrite;
    try
      IsCurrentItemForWait := (AItem = FCurrentItemForWaitFetch);
      if IsCurrentItemForWait then
      begin
        FCurrentItemForWaitFetch := Nil;
        FCurrentItemForWaitFetchEvent.SetEvent;
      end;
    finally
      FLock.EndWrite;
    end;

    { Updating MenuItem }
    var LItem: INBoxItem := AItem;
    if IsCurrentItemForWait then
      TThread.Synchronize(Nil,
      procedure
      begin
        if MenuItem.Visible and Assigned(CurrentItem)
        and CurrentItem.HasPost and SameId(CurrentItem.Post, LItem) then
        begin
          CurrentItem.Post.Assign(LItem);
          GotoItemMenu(CurrentItem);
        end;
      end);
    LItem := Nil;

    FreeInterfaced(AItem);
  except
    On E: Exception do
      Log('ContentFetcherOnFetched', E);
  end;
end;

function TForm1.CreateDefBrowser(AOwner: TComponent): TNBoxBrowser;
begin
  Result := TNBoxBrowser.Create(AOwner);
  with Result do begin
    Align        := TAlignlayout.Contents;
    ColumnsCount := Settings.ContentLayoutsCount;
    ItemsIndent  := TPointF.Create(Settings.ItemIndent, Settings.ItemIndent);
    Request           := nil;
    OnWebClientCreate := OnBrowserSetWebClient;
    OnScraperCreate   := OnBrowserScraperCreate;
    OnException       := OnBrowserExcept;
    visible           := false;
    ImageManager      := BrowsersIWUContentManager;
    OnViewportPositionChange := OnBrowserViewportPositionChange;
    {$IFDEF MSWINDOWS}
    OnDblClick               := OnBrowserDblClick;
    {$ENDIF} {$IFDEF ANDROID}
    Touch.InteractiveGestures := [TInteractiveGesture.DoubleTap,
                                  TInteractiveGesture.Pan];
    OnGesture := OnBrowserGesture;
    {$ENDIF}

    if Self.FFormCreated then
      ShowScrollBars := Settings.ShowScrollBars;
  end;
end;

function TForm1.CreateDefButton(AOwner: TComponent; AStyle: integer): TRectButton;
begin
  Result := CreateDefButtonC(AOwner, DEFAULT_BUTTON_CLASS, DEFAULT_IMAGE_CLASS, AStyle);
end;

function TForm1.CreateDefButtonC(AOwner: TComponent; AClass: TRectButtonClass; AImageClass: TControlClass;
  AStyle: integer): TRectButton;
begin
  Result := AClass.Create(AOwner, AImageClass);
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
    SetStretchImage(ImageControl);
    ImageControl.OnResize := IconOnResize;
    Image.ImageManager := IWUContentManager;
    Height := BUTTON_HEIGHT;
    ImageControl.OnResize(ImageControl);
    {$IFDEF MSWINDOWS} OnClick := Form1.ClickTapRef; {$ENDIF}
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
        Result.Check.Align := TAlignLayout.MostLeft;
        Result.Padding.Left := 10;
      end;
    End;

    Height := CONTROLS_DEF_HEIGHT;
    Check.OnResize := IconOnResize;
    ImageControl.OnResize := IconOnResize;
    Text.Font.Size := 11;
    Text.Color := AppStyle.TextColors[0];
    Image.ImageManager := IWUContentManager;
    SetStretchImage(ImageControl);
    ImageControl.OnResize(ImageControl);
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
    Image.ImageManager := IWUContentManager;
  end;
end;

function TForm1.CreateDefRect(AOwner: TComponent): TAlRectangle;
begin
  Result := TAlRectAngle.Create(AOwner);
  with Result do
    Stroke.Kind := TBrushKind.None;
end;

function TForm1.CreateDefScraper: TNBoxScraper;
begin
  Result := TNBoxScraper.Create;
  with Result do
    OnWebClientSet := Form1.OnBrowserSetWebClient;
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
    Check.ImageControl.Visible := false;
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
  Result.Check.OnTap := SettingsCheckOnTap;
end;

function TForm1.CreateDefSettingsEdit(AOwner: TComponent; AStyle: integer): TNBoxSettingsEdit;
begin
  Result := TNBoxSettingsEdit.Create(AOwner);
  _CreateDefSettingsCheckDef(Result);
  with Result do
  begin
    Edit.Margins.Top := 7;
    Check.Check.Visible := False;
    case AStyle of
      EDIT_STYLE_INT: begin
        with Edit.Edit do
        begin
          Textsettings.HorzAlign := TtextAlign.Center;
          KeyboardType := TVirtualKeyboardType.NumberPad;
          FilterChar := '1234567890';
          Text := '0';
        end;
      end;
    end;
  end;
end;

function TForm1.CreateDefTab(AOwner: TComponent; AClass: TNBoxTabClass): TNBoxTab;
begin
  Result := AClass.Create(AOwner);
  with Result do begin
    SetStretchImage(ImageControl);
    ImageControl.OnResize := IconOnResize;
    Image.ImageManager := IWUContentManager;
    with CloseBtn do begin
      Text.Color := AppStyle.TextColors[0];
      SetStretchImage(ImageControl);
      ImageControl.OnResize := IconOnResize;
      Image.ImageManager := IWUContentManager;
    end;
    AppStyle.tab.Apply(result);
    Height := TAB_DEF_HEIGHT;
  end;
end;

function TForm1.CreateDefTab(AOwner: TComponent): TNBoxTab;
begin
  Result := CreateDefTab(AOwner, TNBoxTab);
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
  try
    Result := Req.Request;

    if ( Result.IsEmpty ) then
    begin
      if ( Req is TNBoxSearchReqCoomerParty ) then
      begin
        var LReq := (Req as TNBoxSearchReqCoomerParty);
        if (not LReq.UserId.IsEmpty) then
          Result := LReq.UserId;
        LReq := Nil;
      end;

      if ( Result.IsEmpty ) then
        Result := 'Empty';
    end;

    Result := Result + ' '
      + '<font color="' + COLOR_TAG_CHARACTER+ '">'
      + Req.PageId.ToString + '</font> : '
      + '<font color="' + COLOR_TAG_TOTAL_COUNT + '">'
      + ABrowser.Items.Count.ToString + '</font>';
  finally
    try
      FreeInterfaced(Req);
    except
      On E: Exception do begin
        Log('TForm1.CreateTabText finally', E);
        raise;
      end;
    end;
  end;
end;

procedure TForm1.DeleteAllBrowsers(ADeleteFromSession: boolean = True);
var
  I: integer;
begin
  for I := 0 to Browsers.Count - 1 do
    DeleteBrowser(Browsers.First, ADeleteFromSession);
end;

procedure TForm1.DeleteBrowser(ABrowser: TNBoxBrowser; ADeleteFromSession: boolean);
var
  LBrowserIndex, LTabIndex: integer;
  Groups: TBookmarkGroupRecAr;
  Group: TBookmarkGroupRec;
  LTab: TNBoxTab;
begin
  if ABrowser = FCurrentBrowser then
  begin
    FCurrentBrowser := nil;
    BtnStatus.Visible := False;
  end;

  LBrowserIndex := Browsers.IndexOf(ABrowser);
  if ( LBrowserIndex = -1 ) then
    exit;

  LTabIndex := IndexTabByBrowser(ABrowser);
  if ( LTabIndex = -1 ) then
    exit;
  LTab := Tabs.Items[LTabIndex];

  if (ABrowser.Tag <> -1) and ADeleteFromSession then
  begin
    Groups := Session.GetBookmarksGroups;
    if Length(Groups) > 0 then
    begin
      Group := Groups[0];
      Group.Delete(ABrowser.Tag);
    end;
  end;

  LTab.Visible := False;
  Browsers.Delete(LBrowserIndex);
  Tabs.Delete(LTabIndex);
  BlackHole.Throw(ABrowser);
end;

procedure TForm1.DeleteFromBookmarkGroupOrder(AGroupId: UInt64);
var
  LIndex: integer;
  LOrder: TList<int64>;
begin
  LOrder := Settings.BookmarksOrder.LockList;
  try
    LIndex := LOrder.IndexOf(AGroupId);
    if (LIndex <> -1) then
    begin
      LOrder.Delete(LIndex);
      SaveSettings;
    end;
  finally
    Settings.BookmarksOrder.UnlockList;
  end;
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
    LFetchable: IFetchableContent;
    LWaitItemAssigned: boolean;
  begin
    if Supports(LPost, IFetchableContent, LFetchable)
    And ( not LFetchable.ContentFetched ) then
    begin
      FLock.BeginRead;
      try
        LWaitItemAssigned := Assigned(CurrentItemForWaitFetch);
      finally
        FLock.EndRead;
      end;

      if not LWaitItemAssigned then
        LWaitItemAssigned := (FCurrentItemForWaitFetchEvent.WaitFor(2) = wrSignaled);

      if LWaitItemAssigned then
      begin
        if (FCurrentItemForWaitFetchEvent.WaitFor(4000) = wrSignaled) then
          FetchedItemsCache.UpdateWithCached(LPost)
        else begin
          {$IFDEF ANDROID}
          ToastMessage('Waiting too long.', True);
          {$ELSE}
//          Showmessage('Waiting too long.');
          {$ENDIF}
          Exit;
        end;
      end else
        {$IFDEF ANDROID}
        Form1.ToastMessage('Looks like nothing to fetch.', True);
        {$ELSE}
        Showmessage('Looks like nothing to fetch.');
        {$ENDIF}
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
      if Assigned(CurrentBrowser) then
      begin
        I := CurrentBrowser.Items.IndexOf(Aitem);
        if ( I <> -1 ) then
          CurrentBrowser.Items.Delete(I);
      end;
    end;

    ACTION_OPEN_MENU: GotoItemMenu(AItem);

    ACTION_BROWSE:
    begin
      if not Assigned(Lrequest) then exit;
      AddBrowser(Lrequest, Settings.AutoStartBrowse);
    end;

    ACTION_DOWNLOAD_ALL:
    begin
      if not AItem.HasPost then exit;
      AddDownload(LPost, False, Settings.DownloadAllMode);
    end;

    ACTION_PLAY_INTERNALY:
    begin
      if not AItem.HasPost then exit;
      LTryFetchIfEmpty;
      if not GotoImageViewer(LPost.ContentUrl,
        Settings.PlayExterWhenCantInter or AutopilotEnabled)
      and Settings.PlayExterWhenCantInter
        then ExecItemInteraction(AItem, ACTION_PLAY_EXTERNALY);
    end;

    ACTION_PLAY_EXTERNALY:
    begin
      if not AItem.HasPost then exit;
      LTryFetchIfEmpty;
      {$IFDEF ANDROID}
      if ( LPost.ContentUrlCount > 0 ) then
        StartActivityViewVideo(LPost.ContentUrl);
      {$ELSE IF MSWINDOWS}
      if ( LPost.ContentUrlCount > 0 ) then
      begin
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
        on E: Exception do Log('ACTION_LOG_URLS', E);
      end;
    end;

    ACTION_OPEN_RELATED:
    begin
      if not AItem.HasPost then exit;
      LTmpReq := CreateRelatedReq(LPost);
      if Assigned(LTmpReq) then
        AddBrowser(LTmpReq, Settings.AutoStartBrowse,
          not Settings.AllowDuplicateTabs);
    end;

    ACTION_OPEN_AUTHOR:
    begin
      if not AItem.HasPost then exit;
      var LPostArtists: IHasArtists;
      if Supports(LPost, IHasArtists, LPostArtists) then
      begin
        if Supports(LPost, IFetchableAuthors) then
          LTryFetchIfEmpty;

        var LArtists := LPostArtists.Artists;

        for i := 0 to High(LArtists) do
        begin
          LTmpReq := CreateArtistReq(LPost, LArtists[I]);
          if Assigned(LTmpReq) then
            AddBrowser(LTmpReq, Settings.AutoStartBrowse,
              not Settings.AllowDuplicateTabs);
        end;

      end;
    end;

    ACTION_ADD_BOOKMARK:
    begin

      if Settings.FetchAllBeforeAddBookmark then
        LTryFetchIfEmpty;

      UserSelectBookmarkList( { Need redisign }
      procedure
      var
        LTable: TBookmarkGroupRec;
      begin
        if Assigned(CurrentBookmarkControl) then
        begin
          LTable := BookmarksDb.GetGroupById(CurrentBookmarkControl.Tag);
          ToastMessage(LTable.Name + ' choosed.', True);

          if ( LTable.Id <> -1 ) then
          begin
            if Assigned(LRequest) then
              LTable.Add(LRequest) { LRequest can be Nil at this time. }
            else
              LTable.Add(LPost); { LPost can be Nil at this time. }
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
      if Supports(LPost, IHasTags) then
      begin
        if Supports(LPost, IFetchableTags) then
          LTryFetchIfEmpty;

        var LTags: TNBoxItemTagAr;
        LTags := (LPost as IHasTags).Tags;
        GotoItemTagsMenu(LTags, LPost.Origin);
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

      if (LPost.ContentUrlCount < 1) then
      begin
        {$IFDEF ANDROID}
        ToastMessage('Have no files', True);
        {$ELSE}
        showmessage('Have no files');
        {$ENDIF}
        exit;
      end;

      var LBrowserTab: TNBoxTab;
      var LBrowser: TNBoxBrowser;

      // FIXME
      var LReq: TNBoxSearchReqRandomizer := TNBoxSearchReqRandomizer.Create;
      LReq.Providers := [];

      LBrowserTab := self.AddBrowser(LReq, false);
      LBrowser := TNBoxBrowser(LBrowserTab.Owner);

      for I := 0 to LPost.ContentUrlCount - 1 do
      begin
        var LNewCard := LBrowser.NewItem;
        var LFileItem := TNBoxPseudoItem.Create;
        var LThumbSet: boolean := false;

        LFileItem.ContentUrls := [LPost.ContentUrls[I]]; // One URL per file

        if LPost is TNBoxCoomerPartyItem then
        begin
          var LCoomerPost := (LPost as TNBoxCoomerPartyItem);
          if I < Length(LCoomerPost.Item.Thumbnails) then
          begin
            if LCoomerPost.Item.Thumbnails[I].StartsWith('http') then
              LFileItem.ThumbnailUrl := LCoomerPost.Item.Thumbnails[I]
            else
              { Backwards compatibility }
              LFileItem.ThumbnailUrl := LCoomerPost.Site + LCoomerPost.Item.Thumbnails[I];
            LThumbSet := True;
          end;
        end else if LPost is TNBox9HentaitoItem then begin
          var L9HentItem := (LPost as TNBox9HentaitoItem);
          if I <= L9HentItem.Item.TotalPage then
          begin
            LFileItem.ThumbnailUrl := L9HentItem.Item.GetImageThumbUrl(I + 1);
            LThumbSet := True;
          end;
        end else if LPost is TNBoxNsfwXxxItem then begin
          var LNsfwXxxItem := (LPost as TNBoxNsfwXxxItem);
          if I < Length(LNsfwXxxItem.Item.Thumbnails) then
          begin
            LFileItem.ThumbnailUrl := LNsfwXxxItem.Item.Thumbnails[I];
            LThumbSet := True;
          end;
        end;

        if ((not LThumbSet) and (not LPost.ThumbnailUrl.IsEmpty)) then
          LFileItem.ThumbnailUrl := LPost.ThumbnailUrl
        else if not LThumbSet then
          LFileItem.ThumbnailUrl := GetThumbByFileExt(LFileItem.ContentUrl);

        LNewCard.Item := LFileItem;
        LNewCard.Fill.Kind := TBrushkind.Bitmap;
        LNewCard.ImageURL := LNewCard.Post.ThumbnailUrl; // Start thumbnail load image
      end;

      Self.CurrentBrowser := LBrowser;
      LBrowserTab.Text.Text := 'Files list (' + LBrowser.Items.Count.ToString + ')';
    end;
  end;

  if Assigned(LTmpReq) then
    FreeInterfaced(LTmpReq);
end;

function TForm1.FetchContent(AItem: INBoxItem): INBoxItem;
var
  LFetchable: IFetchableContent;
begin
  Result := Nil;
  if Supports(AItem, IFetchableContent, LFetchable)
  and not LFetchable.ContentFetched then
  begin
    if not FetchedItemsCache.UpdateWithCached(AItem) then
    begin
      Result := AItem.Clone;
      ContentFetcher.Add(Result);
    end;
  end;
end;

function TForm1.FindDownloadedFullFilename(AUrl: string): string;
var
  LFiles: TSearchRecAr;
  LPartialFilename: string;
begin
  LPartialFilename := Self.GetHashedDownloadFullFilename(AUrl, PVR_PSEUDO, False);
  LFiles := GetFiles(LPartialFilename + '*', faNormal);
  if Length(LFiles) > 0 then
    Result := TPath.Combine(Settings.DefDownloadPath, LFiles[0].name)
  else
    Result := '';
end;

procedure TForm1.SetClick(A: TControl);
var
  I: integer;
begin
  if Assigned(A.OnTap) then
    A.OnClick := ClickTapRef;
  for I := 0 to A.Controls.Count - 1 do
    SetClick(A.Controls.Items[I]);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: integer;
  Control: TControl;

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
  FLock := TMREWSync.Create;
  FCurrentItemForWaitFetchEvent := TEvent.Create;

  APP_VERSION := GetAppVersion;
  FCurrentBrowser := nil;

  SETTINGS_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, SETTINGS_FILENAME);
  BOOKMARKSDB_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, BOOKMARKSDB_FILENAME);
  SESSION_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, SESSION_FILENAME);
  HISTORY_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, HISTORY_FILENAME);
  LOG_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, LOG_FILENAME);
  YDW_LOG_FILENAME := TPath.Combine(TNBoxPath.GetAppMainPath, YDW_LOG_FILENAME);

  TNBoxPath.CreateThumbnailsDir;
  FSettings := nil;
  FAppStyle := TNBoxGuiStyle.Create;

  NsfwBox.Logging.LogFile := TNBoxLogFile.Create;
  NsfwBox.Logging.LogFile.Filename := LOG_FILENAME;

  Application.OnException := AppOnException;

  Log('|-----------Application start ' + APP_VERSION.ToGhTagString + '---------------|');

  if not loadSettings then
  begin
    form1.RestoreDefaultSettings;
    SaveSettings;
  end else begin
    if (Settings.SemVer < APP_VERSION) then
    begin
      {$IFDEF ANDROID}
      try
        Log('Refreshing assets begin');
        TDirectory.Delete(TNBoxPath.GetThemesPath, TRUE);
        TDirectory.CreateDirectory(TNBoxPath.GetThemesPath);
        System.StartUpCopy.CopyStartUpFiles;
        Log('Refreshing assets end.');
      except
        On E: Exception do Log('Refreshing with StartUpCopy', E);
      end;
      {$ENDIF}

      if (Settings.SemVer < TSemVer.Create(3, 0, 0)) then
        Settings.DefaultBackupPath := TNBoxPath.GetDefaultBackupPath;
      if (Settings.SemVer < TSemVer.Create(3, 2, 0)) then
        Settings.MaxTabsAtStartup := 100;
      SaveSettings;
    end;
  end;

  LoadStyle;

  IWUCacheManager := TIWUCacheManager.Create(Self);
  IWUCacheManager.SetSaveAndLoadPath(Tpath.Combine(TNBoxPath.GetCachePath, 'thumbnails'));

  // IWU content manager for browsers only
  BrowsersIWUContentManager := TIWUContentManager.Create(Self);
  with BrowsersIWUContentManager do begin
    OnImageLoadException := OnIWUException;
    OnFilterResponse := OnIWUFilterResponse;
    LoadThumbnailFromFile := True;
    CacheManager := IWUCacheManager;
    EnableSaveToCache := Settings.ImageCacheSave;
    EnableLoadFromCache := Settings.ImageCacheLoad;
    OnWebClientCreate := OnIWUManagerCreateWebClient;
  end;

  // IWU content manager for other app images (like buttons)
  IWUContentManager := TIWUContentManager.Create(Self);
  with IWUContentManager do begin
    OnImageLoadException := OnIWUException;
    OnFilterResponse := OnIWUFilterResponse;
    LoadThumbnailFromFile := False;
    CacheManager := IWUCacheManager;
    EnableSaveToCache := Settings.ImageCacheSave;
    EnableLoadFromCache := Settings.ImageCacheLoad;
    OnWebClientCreate := OnIWUManagerCreateWebClient;
  end;

  FetchedItemsCache := TFetchedItemsCache.Create(Self);
  FetchedItemsCache.StoragePath := TNBoxPath.GetFetchedItemsCachePath;
  ContentFetcher := TNBoxFetchManager.Create;
  ContentFetcher.OnWebClientSet := Self.OnBrowserSetWebClient;
  ContentFetcher.OnFetched := ContentFetcherOnFetched;

  DummyLoadingImage := FMX.Graphics.TBitmap.Create;
  try
    DummyLoadingImage.LoadFromFile(FAppStyle.GetImagePath(IMAGE_LOADING));
  except
    On E: Exception do Log('DummyLoadingImage.LoadFromFile', E);
  end;

  ImageViewer := TNBoxImageViewer.Create(Form1.MainLayout);
  with ImageViewer do begin
    Align := TAlignLayout.Client;
    Parent := MenuImageViewer;
    OnLoadingFinished := OnImageViewerFinished;
    with ImageManager as TIWUContentManager do begin
      OnWebClientCreate := OnImageViewerWebClient;
      OnFilterResponse := OnIWUFilterResponse;
      OnImageLoadException := OnIWUException;
    end;
  end;

  BtnStatusImageView := CreateDefButton(MenuImageViewer);
  with BtnStatusImageView do begin
    Parent := MenuImageViewer;
    Position.Point := TPointF.Create(10, 10);
    Height := 28;
    AppStyle.SettingsRect.Apply(BtnStatusImageView);
    ImageControl.Margins.Rect := TRectF.Create(4, 4, 5, 4);
    Image.ImageURL := AppStyle.GetImagePath(ICON_NEXT);
    Text.Color := TAlphaColorRec.White;
    Text.Font.Size := 10;
    FillMove := FillDef;
    StrokeMove.Kind := TBrushKind.None;
    Visible := False;
  end;

  with ImageViewer.ImageManager.CacheManager as TImageWithURLCahceManager do
  begin
    SetSaveAndLoadPath(TPath.Combine(TNBoxPath.GetCachePath, 'previewed'));
  end;

  {$IFDEF ANDROID}
    Form1.MVMenu.Mode := TMultiviewMode.Drawer;
  {$ELSE IF MSWINDOWS}
    if Settings.UseNewAppTitlebar then begin
      TitleBar := TNBoxFormTitleBar.Create(Self);
      TitleBar.Stroke.Kind := TBrushKind.None;
      AppStyle.Topbar.Apply(TitleBar.Fill);
      TitleBar.BtnTitle.ImageControl.Visible := False;
      TitleBar.BtnTitle.Margins.Left := 5;
      TitleBar.BtnTitle.Text.Text := '  🌈 NsfwBox v' + APP_VERSION.ToString;
      TitleBar.BtnClose.Image.ImageURL := AppStyle.GetImagePath(ICON_CLOSETAB);
      TitleBar.BtnMaxMin.Image.ImageURL := AppStyle.GetImagePath(ICON_CURRENT_TAB);
      TitleBar.BtnHide.Image.ImageURL := AppStyle.GetImagePath(ICON_MENU);
      Self.BorderStyle := TFmxFormBorderStyle.None;
    end;
    form1.Width := Round(Form1.Height * 1.6);
  {$ENDIF}

  DownloadItems := TNBoxTabList.Create;
  DownloadManager := TNBoxDownloadManager.Create;
  with Downloadmanager do begin
    OnCreateDownloader := self.OnCreateDownloader;
    OnStartDownloader  := Self.OnStartDownloader;
  end;

  DownloadFetcher := TNBoxFetchManager.Create;
  DownloadFetcher.OnWebClientSet := Self.OnBrowserSetWebClient;
  DownloadFetcher.OnFetched := Self.DownloadFetcherOnFetched;

  Tabs := TNBoxBrowserTabList.Create;
  Browsers := TNBoxBrowserList.Create;
  Browsers.OnNotify := OnBrowsersNotify;
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
    {$IFDEF MSWINDOWS}
    if Settings.UseNewAppTitlebar then
      TitleBar.DoMyJobWithMe(TopRect);
    {$ENDIF}
  end;

  TopBtnApp := CreateDefButton(TopRect, BTN_STYLE_ICON3);
  with TopBtnApp do begin
    Parent := TopRect;
    Align := TAlignlayout.MostLeft;
    Image.ImageURL := AppStyle.GetImagePath(ICON_NSFWBOX);
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
  {$ELSE IF MSWINDOWS}
  SubHeader := 'Make Love, not war';
  {$ENDIF}

  TopBtnSearch := CreateDefButton(TopRect, BTN_STYLE_ICON2);
  with TopBtnSearch do begin
    parent := TopRect;
    align := TAlignlayout.right;
    Image.ImageURL := AppStyle.GetImagePath(ICON_SEARCH);
    OnTap := TopBtnSearchOnTap;
  end;

  TopBtnPopMenu := CreateDefButton(TopRect, BTN_STYLE_ICON2);
  with TopBtnPopMenu do begin
    Parent := TopRect;
    Align := TALignlayout.MostRight;
    Image.ImageURL := AppStyle.GetImagePath(ICON_MENU);
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
    Image.ImageURL := AppStyle.GetImagePath(ICON_NEXT);
  end;

  BtnPrev := CreateDefButton(BrowserBtnsLayout2, BTN_STYLE_ICON);
  with BtnPrev do begin
    Parent := BrowserBtnsLayout2;
    Align := TAlignLayout.Right;
    OnTap := BtnPrevOnTap;
    Width := Height;
    Image.ImageURL := AppStyle.GetImagePath(ICON_NEXT);
    if (ImageControl is Timage) then
      (ImageControl as TImage).RotationAngle := 180;
  end;

  MVMenuScroll := CreateDefScroll(MVRect);
  MVMenuScroll.Parent := MVRect;

  TabsScroll := MVMenuScroll;

  MenuBtnDownloads := AddMenuBtn;
  with MenuBtnDownloads do begin
    Text.Text := 'Downloads';
    IMage.ImageURL := AppStyle.GetImagePath(ICON_DOWNLOADS);
    OnTap := MenuBtnDownloadsOnTap;
    OnDblClick := MenuBtnDownloadsOnDblClick;
  end;

  MenuBtnBookmarks := AddMenuBtn;
  with MenuBtnBookmarks do begin
    Text.Text := 'Bookmarks';
    Image.ImageURL := AppStyle.GetImagePath(ICON_BOOKMARKS);
    OnTap := MenuBtnBookmarksOnTap;
  end;

  MenuBtnBookmarks := AddMenuBtn;
  with MenuBtnBookmarks do begin
    Text.Text := 'History';
    Image.ImageURL := AppStyle.GetImagePath(ICON_HISTORY);
    OnTap := MenuBtnHistoryOnTap;
  end;

  MenuBtnSettings := AddMenuBtn;
  with MenuBtnSettings do begin
    Image.ImageURL := AppStyle.GetImagePath(ICON_SETTINGS);
    text.Text := 'Settings';
    OnTap := MenuBtnSettingsOnTap;
  end;

  MenuBtnNewTab := AddMenuBtn;
  with MenuBtnNewTab do begin
    image.ImageURL := AppStyle.GetImagePath(ICON_NEWTAB);
    Text.Text := 'Create new tab';
    OnTap := MenuBtnNewTabOnTap;
  end;

  MenuTestButtons := TList<TRectButton>.Create;

  SearchMenu := TNBoxSearchMenu.Create(self);
  with Searchmenu do begin
    Parent := MenuSearchSettings;
    Align := TAlignlayout.Client;
  end;

  BtnBrowse       := AddItemMenuBtn('Browse', ACTION_BROWSE, ICON_NEWTAB, TAG_CAN_USE_MORE_THAN_ONE);
  BtnDownloadAll  := AddItemMenuBtn('Download content', ACTION_DOWNLOAD_ALL, ICON_DOWNLOAD, TAG_CAN_USE_MORE_THAN_ONE);
  BtnDownloadMenu := AddItemMenuBtn('Show available files', ACTION_SHOW_FILES, ICON_FILES);
  BtnPlayInternaly := AddItemMenuBtn('Play / show content', ACTION_PLAY_INTERNALY, ICON_CURRENT_TAB);
  BtnPlayExternaly := AddItemMenuBtn('Play externaly', ACTION_PLAY_EXTERNALY, ICON_PLAY);
  BtnAddBookmark   := AddItemMenuBtn('Add bookmark', ACTION_ADD_BOOKMARK, ICON_BOOKMARKS, TAG_CAN_USE_MORE_THAN_ONE);
  BtnOpenRelated   := AddItemMenuBtn('Open related', ACTION_OPEN_RELATED, ICON_NEWTAB, TAG_CAN_USE_MORE_THAN_ONE);
  BtnOpenAuthor    := AddItemMenuBtn('Open artists', ACTION_OPEN_AUTHOR, ICON_AVATAR, TAG_CAN_USE_MORE_THAN_ONE);
  BtnCopyFullUrl   := AddItemMenuBtn('Copy content url', ACTION_COPY_CONTENT_URLS, ICON_COPY);
  BtnCopyThumbUrl  := AddItemMenuBtn('Copy thumbnail url', ACTION_COPY_THUMB_URL, ICON_COPY);
  BtnLogContentUrls := AddItemMenuBtn('Log content urls to file', ACTION_LOG_URLS, ICON_SAVE, TAG_CAN_USE_MORE_THAN_ONE);
  BtnShowTags       := AddItemMenuBtn('Show tags\categories', ACTION_SHOW_TAGS, ICON_TAG);
  //BtnShareContent := AddItemMenuBtn('Share content', ACTION_SHARE_CONTENT, ICON_COPY);
  BtnDeleteBookmark := AddItemMenuBtn('Delete from bookmarks', ACTION_DELETE_BOOKMARK, ICON_DELETE, TAG_CAN_USE_MORE_THAN_ONE);
  BtnDeleteCard     := AdditemMenuBtn('Delete (free object)', ACTION_DELETE_CARD, ICON_DELETE, TAG_CAN_USE_MORE_THAN_ONE);

  BtnOpenAppRep := AddSettingsButton('Author: <font color="'
    + COLOR_TAG_CHARACTER + '">Kisspeace</font> ' + SLineBreak
    + 'Click to open GitHub repository', ICON_NSFWBOX);
  with BtnOpenAppRep do begin
    OnTap := BtnOpenAppRepOnTap;
    Height := Height * 1.5;
    Text.WordWrap := true;
    Text.TextIsHtml := True;
  end;

  BtnSetAnonMsg := AddSettingsButtonC('Anonymous message for <font color="'
    + COLOR_TAG_CHARACTER + '">developer</font>', '', TNBoxImageTypes.AlRect);
  with BtnSetAnonMsg do begin
    OnTap := BtnSetAnonMsgOnTap;
    Height := Height * 1.25;
    Text.WordWrap := true;
    Text.TextIsHtml := True;
    with ImageControl as TNBoxImageTypes.AlRect do begin
      XRadius := 10;
      YRadius := XRadius;
    end;
    Image.ImageURL := 'https://avatars.githubusercontent.com/u/101427274';
  end;

  CheckSetFullscreen          := AddSettingsCheck('Fullscreen mode', 'Fullscreen');
  {$IFDEF MSWINDOWS}
  CheckSetUseNewAppTitlebar   := AddSettingsCheck('Use new titlebar', 'UseNewAppTitlebar');
  {$ENDIF}
  CheckSetAllowCookies        := AddSettingsCheck('Allow cookies', 'AllowCookies');
  CheckSetAutoAcceptAllCertificates := AddSettingsCheck('Accept all SSL\TLS certificates', 'AutoAcceptAllCertificates'); { issues on ANDROID }
  CheckSetEnableAllContent    := AddSettingsCheck('Enable all content (Gelbooru)', 'EnableAllContent');
  CheckSetAutoSaveSession     := AddSettingsCheck('Auto save session', 'AutoSaveSession');
  AddSettingsEdit('Max tabs count at startup', 'MaxTabsAtStartup', '', EDIT_STYLE_INT);
  CheckSetSaveSearchHistory   := AddSettingsCheck('Save search history', 'SaveSearchHistory');
  CheckSetSaveDownloadHistory := AddSettingsCheck('Save download history', 'SaveDownloadHistory');
  CheckSetSaveTapHistory      := AddSettingsCheck('Save tap history', 'SaveTapHistory');
  CheckSetSaveTabHistory      := AddSettingsCheck('Save closed tab history', 'SaveClosedTabHistory');
  CheckSetShowCaptions        := AddSettingsCheck('Show content caption', 'ShowCaptions');
  CheckSetShowBrowserStatus   := AddSettingsCheck('Show browser status bar', 'ShowBrowserStatusBar');
  CheckSetShowImageViewerStatus := AddSettingsCheck('Show image viewer status bar', 'ShowImageViewerStatusBar');
  CheckSetImageCacheSave      := AddSettingsCheck('Cache thumbnails', 'ImageCacheSave');
  CheckSetImageCacheLoad      := AddSettingsCheck('Load thumbnails from cache', 'ImageCacheLoad');
  CheckSetYDWSyncLoadFromFile := AddSettingsCheck('YDW full sync load images from file', 'YDWSyncLoadFromFile');
  CheckSetAllowDuplicateTabs  := AddSettingsCheck('Allow open duplicate tabs', 'AllowDuplicateTabs');
  CheckSetPlayExterWhenCantInter := AddSettingsCheck('Play file externally on fail', 'PlayExterWhenCantInter',
    'The file will be played externally when the application cannot play it on its own.');
  CheckSetBrowseNextPageByScrollDown := AddSettingsCheck('Browse next page by scrolling down', 'BrowseNextPageByScrollDown');
  CheckSetAutoStartBrowse     := AddSettingsCheck('Auto start browse', 'AutoStartBrowse');
  CheckSetAutoCloseItemMenu   := AddSettingsCheck('Auto close item menu', 'AutoCloseItemMenu');
  CheckSetFetchAllBeforeAddBookmark := AddSettingsCheck('Fetch data before add to bookmarks', 'FetchAllBeforeAddBookmark', 'Not work in bulk mode.');
  CheckSetShowScrollBars      := AddSettingsCheck('Show scrollbars', 'ShowScrollBars');
  CheckSetShowNavigateBackButton := AddSettingsCheck('Show navigate back button', 'ShowNavigateBackButton');
  EditSetDefUseragent         := AddSettingsEdit('Default Useragent string', 'DefaultUseragent');
  EditSetDefDownloadPath      := AddSettingsEdit('Default downloads path', 'DefDownloadPath');
  EditSetMaxDownloadThreads   := AddSettingsEdit('Max download threads count', 'MaxDownloadThreads', '', EDIT_STYLE_INT);
  EditSetThreadsCount         := AddSettingsEdit('Threads count', 'ThreadsCount', '', EDIT_STYLE_INT);
  EditSetLayoutsCount         := AddSettingsEdit('Content layouts count', 'ContentLayoutsCount', '', EDIT_STYLE_INT);
  EditSetItemIndent           := AddSettingsEdit('Items indent', 'ItemIndent', '', EDIT_STYLE_INT);
  EditSetFilenameLogUrls      := AddSettingsEdit('Urls log filename', 'FilenameLogUrls');
  {$IFDEF MSWINDOWS}
  EditSetPlayApp              := AddSettingsEdit('Player application path', 'ContentPlayApp');
  EditSetPlayParams           := AddSettingsEdit('Player params', 'ContentPlayParams', FORMAT_VAR_CONTENT_URL + ' - being replaced with URL.');
  {$ENDIF}
  EditSetDefBackupPath        := AddSettingsEdit('Default backup import \ export path', 'DefaultBackupPath');
  CheckSetDevMode             := AddSettingsCheck('Developer mode', 'DevMode');
  CheckSetAutoCheckUpdates    := AddSettingsCheck('Auto check updates', 'AutoCheckUpdates');

  CheckMenuSetOnItemTap := TNBoxCheckMenu.Create(MainLayout);
  with CheckMenuSetOnItemTap do begin
    Parent := MainLayout;
    Visible := false;
    Align := TAlignlayout.Client;

    AddCheck('Open menu', ACTION_OPEN_MENU);
    AddCheck('Download content', ACTION_DOWNLOAD_ALL);
    AddCheck('Show available files', ACTION_SHOW_FILES);
    AddCheck('Play / show content', ACTION_PLAY_INTERNALY);
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

    for I := 0 to Content.Controls.Count - 1 do
    begin
      Control := Content.Controls.Items[I];
      if Control is TNBoxCheckButton then
        (Control as TNBoxCheckButton).Image.ImageURL :=
          AppStyle.GetImagePath(ICON_SETTINGS);
    end;

    Checked := Settings.ItemInteractions;

    BtnSetSaveOnItemTap := CreateDefButton(CheckMenuSetOnItemTap, BTN_STYLE_DEF2);
    with BtnSetSaveOnItemTap do begin
      Parent := CheckMenuSetOnItemTap;
      Align := TAlignLayout.Top;
      Position.Y := Single.MaxValue;
      Margins.Rect := TRectF.Create(6, 6, 6, 0);
      Image.ImageURL := AppStyle.GetImagePath(ICON_SAVE);
      OnTap := BtnSetSaveOnItemTapOnTap;
      Text.Text := 'Save tap settings';
    end;

  end;

  BtnSetChangeDownloadAllMode := AddSettingsButton('Change download all mode', ICON_DOWNLOADS);
  BtnSetChangeDownloadAllMode.OnTap := BtnSetChangeDownloadAllModeOnTap;

  MenuChangeDownloadAllMode := TNBoxSelectMenuInt.Create(MainLayout);
  with MenuChangeDownloadAllMode do
  begin
    Parent := MainLayout;
    Align := TAlignLayout.Client;
    Menu.OnSelected := MenuChangeDownloadAllModeOnSelected;

    var LIconFilename := AppStyle.GetImagePath(ICON_DOWNLOAD);
    AddBtn('Download all available files', Ord(TDownloadAllMode.damAllVersions), LIconFilename);
    AddBtn('Prefer high resolution files', Ord(TDownloadAllMode.damHighResVersion), LIconFilename);
    AddBtn('Prefer medium or low resolution files', Ord(TDownloadAllMode.damMediumResVersion), LIconFilename);
  end;

  MenuChangeTheme := TNBoxSelectMenuStr.Create(MainLayout);
  with MenuChangeTheme do begin
    Parent := MainLayout;
    Align  := TAlignlayout.Client;
    Menu.OnSelected := MenuChangeThemeOnSelected;
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

  BtnSetManageBackups := AddSettingsButton('Manage backups', ICON_SETTINGS);
  BtnSetManageBackups.OnTap := BtnSetManageBackupsOnTap;

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
      Image.ImageURL := AppStyle.GetImagePath(ICON_BOOKMARKS);
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
    Image.ImageURL := AppStyle.GetImagePath(ICON_SAVE);
    Text.Text := 'Save changes';
    Position.Y := Single.MaxValue;
  end;

  BtnBMarkCreate := AddBMarksDoListButton('Create new bookmarks list', ICON_ADD, BtnBMarkCreateOnTap, TAG_CAN_USE_MORE_THAN_ONE);
  BtnBMarkOpen   := AddBMarksDoListButton('Open and show', ICON_NEWTAB, BtnBMarkOpenOnTap, TAG_CAN_USE_MORE_THAN_ONE);
  BtnBMarkOpenLastPage := AddBMarksDoListButton('Open and show (last page)', ICON_NEWTAB, BtnBMarkOpenLastPageOnTap, TAG_CAN_USE_MORE_THAN_ONE);
  BtnBMarkChange := AddBMarksDoListButton('Change bookmark list', ICON_EDIT, BtnBMarkChangeOnTap);
  BtnBMarkDelete := AddBMarksDoListButton('Delete', ICON_DELETE, BtnBMarkDeleteOnTap, TAG_CAN_USE_MORE_THAN_ONE);
  BtnBMarkPushUp := AddBMarksDoListButton('Push up in the list', ICON_CURRENT_TAB, BtnBMarkPushUpOnTap);
  BtnBMarkPushDown := AddBMarksDoListButton('Push down in the list', ICON_CURRENT_TAB, BtnBMarkPushDownOnTap);

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
    Image.ImageURL := AppStyle.GetImagePath(ICON_DONE);
  end;

  BtnDialogNo := Self.CreateDefButton(LayoutDialogYesOrNo, BTN_STYLE_DEF2);
  with BtnDialogNo do begin
    parent := LayoutDialogYesOrNo;
    Align := TAlignlayout.Client;
    Margins.Left := ( DialogYesOrNo.Padding.Left / 2 );
    Text.Text := 'No';
    Text.TextSettings := BtnDialogYes.Text.TextSettings;
    OnTap := BtnDialogNoOnTap;
    Image.ImageURL := AppStyle.GetImagePath(ICON_CLOSETAB);
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

  BtnSendLogs := CreateDefButton(MenuAnonMessage, BTN_STYLE_DEF2);
  with BtnSendLogs do begin
    Margins := EditNickMsgForDev.Margins;
    Parent := MenuAnonMessage;
    Align := TAlignlayout.Bottom;
    Text.Text := 'Send logs';
    Image.ImageURL := AppStyle.GetImagePath(ICON_NSFWBOX);
    OnTap := BtnSendLogsOnTap;
  end;

  BtnSendMsgForDev := CreateDefButton(MenuAnonMessage, BTN_STYLE_DEF2);
  with BtnSendMsgForDev do begin
    Margins := EditNickMsgForDev.Margins;
    Margins.Bottom := Margins.Top;
    Parent := MenuAnonMessage;
    Align := TAlignlayout.MostBottom;
    Text.Text := 'Send message';
    Image.ImageURL := AppStyle.GetImagePath(ICON_TRANS);
    OnTap := BtnSendMsgForDevOnTap;
  end;

  { MenuSearchDoList }
  BtnSearchAddBookmark := AddMenuSearchBtn('Add current request to bookmarks', ICON_BOOKMARKS, BtnSearchAddBookmarkOnTap);

  MenuItemTags := TNBoxSelectMenuTag.Create(Form1.MainLayout);
  MenuItemTags.Parent := Form1.MainLayout;
  MenuItemTags.Align := TAlignLayout.Client;
  MenuItemTags.Menu.OnSelected := MenuItemTagsOnSelected;

  BookmarksControls := TControlObjList.Create;
  HistoryDbControls := TControlObjList.Create;
  ChangeInterface(BrowserLayout);

  { Menu manage backups }
  MenuBackup := NewMenu;
  EdtBackupFilename := Form1.CreateDefEdit(MenuBackup);
  with EdtBackupFilename do
  begin
    Margins.Rect := TRectF.Create(10, 10, 10, 0);
    Align := TAlignLayout.MostTop;
    Edit.TextPrompt := 'Full file name';
    parent := MenuBackup;
  end;

  BtnCreateBackup := CreateDefButton(MenuBackup, BTN_STYLE_DEF2);
  With BtnCreateBackup do
  begin
    Align := TAlignlayout.Top;
    Margins := EdtBackupFilename.Margins;
    Text.Text := 'Create new backup archive';
    Image.ImageURL := AppStyle.GetImagePath(ICON_SAVE);
    Parent := MenuBackup;
    OnTap := BtnCreateBackupOnTap;
  end;

  EdtApplyBackupFilename := Form1.CreateDefEdit(MenuBackup);
  with EdtApplyBackupFilename do
  begin
    Margins.Rect := TRectF.Create(10, 10, 10, 0);
    Align := TAlignLayout.Top;
    Edit.TextPrompt := 'Full backup file name';
    parent := MenuBackup;
  end;

  BtnApplyBackup := CreateDefButton(MenuBackup, BTN_STYLE_DEF2);
  with BtnApplyBackup do
  begin
    Align := TAlignlayout.Top;
    Margins := EdtBackupFilename.Margins;
    Text.Text := 'Restore from backup archive';
    Image.ImageURL := AppStyle.GetImagePath(ICON_SAVE);
    Parent := MenuBackup;
    OnTap := BtnApplyBackupOnTap;
  end;

  SelectMenuBackupFiles := TNBoxSelectMenuStr.Create(MenuBackup);
  with SelectMenuBackupFiles do
  begin
    Parent := MenuBackup;
    Menu.OnSelected := MenuBackupFilesOnSelect;
    Align := TAlignLayout.Client;
    Margins.Rect := TRectF.Create(10, 10, 10, 10);
  end;

  BtnStatus := CreateDefButton(LayoutDialogYesOrNo);
  with BtnStatus do begin
    Parent := OnBrowserLayout;
    Position.Point := TPointF.Create(10, 10);
    Height := 28;
    AppStyle.SettingsRect.Apply(BtnStatus);
    ImageControl.Margins.Rect := TRectF.Create(4, 4, 5, 4);
    Image.ImageURL := AppStyle.GetImagePath(ICON_DONE);
    Text.Color := TAlphaColorRec.White;
    Text.Font.Size := 10;
    FillMove := FillDef;
    StrokeMove.Kind := TBrushKind.None;
    Text.Text := 'Status bar.';
  end;

  FFormCreated := TRUE;
  Settings := Settings;
  HistoryDb := TNBoxBookmarksHistoryDb.Create(HISTORY_FILENAME);
  BookmarksDb := TNBoxBookmarksDb.Create(BOOKMARKSDB_FILENAME);
  Session := TnBoxBookmarksDb.Create(SESSION_FILENAME);
  Session.PageSize := 100;
  ConnectSession;

  { Database update }
  if not HistoryDb.HasGroup(HistoryDb.NAME_TABS_HISTORY) then
  begin
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
  for I := 0 to Form1.Children.Count - 1 do
  begin
    var FmxObj: TFmxObject;
    FmxObj := Form1.Children.Items[I];
    if ( FmxObj is TControl ) then
      SetClick(FmxObj as TControl);
    if ( FmxObj is TCustomScrollBox ) then
      TCustomScrollBox(FmxObj).ShowScrollBars := Settings.ShowScrollBars;
  end;
  {$ENDIF}

  { Update checker thread creates and starts here }
  if Settings.AutoCheckUpdates then
  begin
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
        TTask.CurrentTask.CheckCanceled;
        try
          LastRelease := GetLastRealeaseFromGitHub;
          Success := true;
          break;
        except
          On E: Exception do begin
            Log('OnUpdateCheck', E);
            TTask.CurrentTask.Wait(RETRY_TIMEOUT);
          end;
        end;
      end;

      if not success then
        exit
      else begin
        LastVer := TSemVer.FromGhTagString(LastRelease.TagName);
        Log('Last release: ' + LastVer.ToGhTagString);
      end;

      if ( LastVer > APP_VERSION ) then begin
        { New version available }
        if AppDestroying then exit;

        TThread.Synchronize(Nil, procedure begin
          if AppDestroying then exit;

          {$IFDEF MSWINDOWS}
          if Settings.UseNewAppTitlebar then
            TitleBar.BtnTitle.Text.Text := TitleBar.BtnTitle.Text.Text + ' ( ' + LastRelease.Name + 'Available' + ' )';
          {$ENDIF}

          Form1.UserBooleanDialog('Update available: ' + LastRelease.Name + SLineBreak +
                                  LastRelease.Body + SLineBreak +
                                  'Click `Yes` to open release page.',
          procedure begin
            if UserSayYes then
            {$IFDEF ANDROID}
              StartActivityView(LastRelease.HtmlUrl);
            {$ELSE IF MSWINDOWS}
              ShellExecute(0, 'open', Pchar(LastRelease.HtmlUrl), nil, nil, SW_SHOWNORMAL);
            {$ENDIF}
            Self.ChangeInterface(Self.BrowserLayout);
          end);
        end);
      end else begin
        TThread.Synchronize(Nil, procedure begin
          if AppDestroying then exit;

          {$IFDEF MSWINDOWS}
          if Settings.UseNewAppTitlebar and ( LastVer = APP_VERSION ) then
            TitleBar.BtnTitle.Text.Text := TitleBar.BtnTitle.Text.Text + ' ( current )'
          else
            TitleBar.BtnTitle.Text.Text := TitleBar.BtnTitle.Text.Text + ' ( higher )';
          {$ENDIF}
        end);
      end;

    end).Start;
  end;

  { Read command line parameters }
  {$IFDEF MSWINDOWS}
  if paramcount >= 0 then begin
    for I := 1 to ParamCount do
      if ParamStr(I) = '--autopilot' then
        NsfwBox.Tests.TNBoxTests.StartAutopilot;
  end;
  {$ENDIF}
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FLock.BeginWrite;
  try
    FAppDestroying := True;
  finally
    FLock.EndWrite;
  end;

  log('Destroing app');

  try
    FreeAndNil(DownloadFetcher);
    FreeAndNil(DownloadManager);
    DeleteAllBrowsers(False);
    BlackHole.Terminate;
    BlackHole.WaitFor;
  except
    On E: Exception do
      Log('On Destroy', E);
  end;
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
      Form1.AppFullScreen := false;
      {$ENDIF}
      ChangeInterface(BrowserLayout);
    end;

    VkF5:
    begin
      if Assigned(CurrentBrowser) and BrowserLayout.Visible then
        CurrentBrowser.GoBrowse;
    end;

    vkReturn:
    begin
      if Assigned(Self.Focused) and (Self.Focused is TEdit) then begin
        var LFocused := (Self.Focused as TObject);
        if (LFocused = Self.SearchMenu.EditRequest.Edit)
        or (LFocused = Self.SearchMenu.EditPageId.Edit) then
          Self.TopBtnSearch.OnTap(TopBtnSearch, TPointF.Zero);
      end;
    end;
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
const
  MAX_STATUS_BAR_WIDTH = 216;
var
  W: Single;
begin
  if not FFormCreated then Exit;
  W := ((OnBrowserLayout.Width - BtnStatus.Position.X) / 100) * 35;
  if W < MAX_STATUS_BAR_WIDTH then
    W := OnBrowserLayout.Width - (BtnStatus.Position.X * 2);
  if W > MAX_STATUS_BAR_WIDTH then
    W := MAX_STATUS_BAR_WIDTH;
  BtnStatus.width := W;
  BtnStatusImageView.Width := W;
  if MenuImageViewer.Visible then
    ImageViewer.BestFit;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  FAppStyle.Form.Apply(form1.Fill);
  BrowsersIWUContentManager.SyncBitmapLoadFromFile := Settings.YDWSyncLoadFromFile;
  IWUContentManager.SyncBitmapLoadFromFile := Settings.YDWSyncLoadFromFile;
  IWUCacheManager.SyncBitmapLoadFromFile := Settings.YDWSyncLoadFromFile;
end;

function TForm1.GetAppDestroying: boolean;
begin
  FLock.BeginRead;
  try
    Result := FAppDestroying;
  finally
    FLock.EndRead;
  end;
end;

function TForm1.GetAppFullscreen: boolean;
begin
  Result := Form1.FullScreen;
end;

function TForm1.GetAppStyle: TNBoxGUIStyle;
begin
  Result := FAppStyle;
end;

function TForm1.GetHashedDownloadFullFilename(AFilename: string;
  AOrigin: integer; AWithExtension: boolean): string;
begin
  var LFilename := TNBoxPath.GetHashedDownloadedFilename(AFilename, AOrigin, AWithExtension);
  Result := TPath.Combine(Settings.DefDownloadPath, LFilename);
end;

function TForm1.GetSettings: TNsfwBoxSettings;
begin
  Result := Fsettings;
end;

function TForm1.GetSubHeader: string;
begin
  Result := TopBottomText.Text;
end;

procedure TForm1.GotoBookmarksMenu(ABookmarksDb: TNBoxBookmarksDb);
begin
  try
    CurrentBookmarksDb := ABookmarksDb;
    if CurrentBookmarksDb = BookmarksDb then
      ChangeInterface(MenuBookmarks)
    else if CurrentBookmarksDb = HistoryDb then
      ChangeInterface(MenuHistory)
  except
    On E: Exception do
      Log('GotoBookmarksMenu', E);
  end;
end;

procedure TForm1.GotoDownloadsMenu;
begin
  ChangeInterface(MenuDownloads);
end;

function TForm1.GotoImageViewer(AImageUrl: string; AQuietFail: boolean): boolean;
const
  FILE_EXTS: TArray<string> = ['.jpg', '.jpeg', '.png', '.gif'];
  DENY_HOSTS: TArray<string> = ['external-preview.redd.it', 'preview.redd.it'];
var
  LDownloadedFilename: string;
  LUri: TURI;
  LExt: string;
begin
  Result := True;
  Self.ClearControlBitmap(ImageViewer);
  LDownloadedFilename := Self.FindDownloadedFullFilename(AImageUrl);

  if (not LDownloadedFilename.IsEmpty) then
  begin
    LExt := TPath.GetExtension(LDownloadedFilename);
    if StrIn(FILE_EXTS, LExt) then
      AImageUrl := LDownloadedFilename;

  end else begin
    try
      LUri := TURI.Create(AImageUrl);
      LExt := TPath.GetExtension(LUri.Path);
    except
      LExt := '';
    end;

    if not StrIn(FILE_EXTS, LExt)
    or StrIn(DENY_HOSTS, LUri.Host) then begin
      { Looks like not a picture }
      if not AQuietFail then
      begin
        var LMsgForUser := 'Unsupported image format: ' + AImageUrl;
        {$IFDEF MSWINDOWS}
        ShowMessage(LMsgForUser);
        {$ENDIF} {$IFDEF ANDROID}
        ToastMessage(LMsgForUser, False);
        {$ENDIF}
      end;
      Exit(False);
    end;
  end;

  ChangeInterface(MenuImageViewer);
  SetImageViewerStatus(AImageUrl);
  BtnStatusImageView.Visible := settings.ShowImageViewerStatusBar;
  ImageViewer.ImageURL := AImageUrl;
end;

procedure TForm1.GotoItemMenu(AItem: TNBoxCardBase);
const
  MAX_STRS_DISPLAY = 3;
var
  I, Last: integer;
  LHasArtists: IHasArtists;
  LFilesCount: integer;
begin
  CurrentItem := AItem;
  if not Assigned(CurrentItem) then
    exit;

  DoWithAllItems := false;
  ChangeInterface(MenuItem);

  BtnOpenAuthor.Text.Text := 'Open artists';
  BtnDownloadAll.Text.Text := 'Download content';

  if CurrentItem.HasPost then
  begin
    if Supports(CurrentItem.Post, IHasArtists, LHasArtists) then
    begin
      var LArtists: TNBoxItemArtisAr := LHasArtists.Artists;
      var LNames: string := '';
      if Length(LArtists) > 0 then
      begin
        Last := Min(MAX_STRS_DISPLAY - 1, High(LArtists));
        for I := 0 to Last do
        begin
          LNames := LNames + LArtists[I].DisplayName;
          if I <> Last then
            LNames := LNames + ', ';
        end;
        BtnOpenAuthor.Text.Text := BtnOpenAuthor.Text.Text + ': '
          + '<font color="' + COLOR_TAG_ARTIST + '">'
          + LNames + '</font>';
      end;
    end;

    LFilesCount := CurrentItem.Post.ContentUrlCount;
    if LFilesCount > 0 then
      BtnDownloadAll.Text.Text := BtnDownloadAll.Text.Text + ' : '
        + '<font color="' + COLOR_TAG_TOTAL_COUNT + '">'
        + LFilesCount.ToString + '</font>';
  end;
end;

function ItemTagToCaption(ATag: INBoxItemTag): string;
var
  LColorHex: string;
  LOtherStr: string;
  LTagBooru: INBoxItemTagBooru;
  LTag9HentaiTo: INBoxItemTag9HentaiTo;
begin
  if Supports(ATag, INBoxItemTagBooru, LTagBooru) then begin

    case LTagBooru.Tag.Kind of
      TagGeneral:   LColorHex := COLOR_TAG_GENERAL;
      TagCopyright: LColorHex := COLOR_TAG_COPYRIGHT;
      TagMetadata:  LColorHex := COLOR_TAG_METADATA;
      TagCharacter: LColorHex := COLOR_TAG_CHARACTER;
      TagArtist:    LColorHex := COLOR_TAG_ARTIST;
    end;

    if ( LTagBooru.Tag.Count > 0 ) then
      LOtherStr := '<font color="' + COLOR_TAG_TOTAL_COUNT + '">'
      + LTagBooru.Tag.Count.ToString + '</font>'

  end else if Supports(ATag, INBoxItemTag9HentaiTo, LTag9HentaiTo) then begin

    case LTag9HentaiTo.Tag.Typ of
      TAG_TAG: LColorHex       := COLOR_TAG_GENERAL;
      TAG_PARODY: LColorHex    := COLOR_TAG_COPYRIGHT;
      TAG_GROUP: LColorHex     := COLOR_TAG_METADATA;
      TAG_CHARACTER: LColorHex := COLOR_TAG_CHARACTER;
      TAG_ARTIST: LColorHex    := COLOR_TAG_ARTIST;
    end;

  end else
    LColorHex := COLOR_TAG_GENERAL;

  Result := '<font color="' + LColorHex + '">'
    + THTMLEncoding.HTML.Encode(ATag.Value) + '</font> ' + LOtherStr;
end;

procedure TForm1.GotoItemTagsMenu(ATags: TNBoxItemTagAr; AOrigin: integer);
var
  I: integer;
  LNewBtn: TRectButton;
  LIconBmp: TBitmap;
begin
  MenuItemTagsOrigin := AOrigin;
  MenuItemTags.Menu.FreeControls;
  LIconBmp := TBitmap.Create;
  try
    var LImagePath: string := Form1.AppStyle.GetImagePath(ICON_TAG);
    if FileExists(LImagePath) then
      LIconBmp.LoadFromFile(Form1.AppStyle.GetImagePath(ICON_TAG));

    for I := low(ATags) to high(ATags) do
    begin
      LNewBtn := MenuItemTags.AddBtn(
        ItemTagToCaption(ATags[I]),
        ATags[I]);
      LNewBtn.Text.TextIsHtml := True;
      LNewBtn.Image.BitmapIWU.Assign(LIconBmp);
    end;
  finally
    LIconBmp.Free;
  end;
  ChangeInterface(MenuItemTags);
end;

procedure TForm1.GotoSearchSettings(ABrowser: TNBoxBrowser);
var
  LReq: INBoxSearchRequest;
begin
  ChangeInterface(MenuSearchSettings);
  if Assigned(ABrowser) then begin
    LReq := ABrowser.Request;
    try
      SearchMenu.Request := LReq;
    finally
      FreeInterfaced(LReq);
    end;
  end;
end;

procedure TForm1.OnBrowserDblClick(Sender: TObject);
begin
  { Reload page if items count zero }
  with (Sender as TNBoxBrowser) do begin
    if Items.Count = 0 then
      GoBrowse;
  end;
end;

procedure TForm1.OnBrowserExcept(Sender: TObject; const AExcept: Exception);
var
  LBrowser: TNBoxBrowser;
begin
  LBrowser := Sender as TNBoxBrowser;
  TThread.Synchronize(TThread.Current,
  procedure
  begin
    if (CurrentBrowser = LBrowser) and Settings.ShowBrowserStatusBar then
      SetBrowserStatus(AExcept.Message, AppStyle.GetImagePath(ICON_WARNING));
  end);
end;

procedure TForm1.OnBrowserGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    igiDoubleTap:
    begin
      Handled := True;
      OnBrowserDblClick(Sender);
    end;
  end;
end;

procedure TForm1.OnBrowserReqChanged(Sender: TObject);
var
  LNewTabImageName: string;
  LBrowser: TNBoxBrowser;
  Groups: TBookmarkGroupRecAr;
  Group: TBookmarkGroupRec;
  LReq: INBoxSearchRequest;
begin
  LBrowser := TNBoxBrowser(Sender);
  LReq := LBrowser.Request;
  try
    if not Assigned(LBrowser.Tab) then Exit;

    LBrowser.Tab.Text.TextIsHtml := True;
    LBrowser.Tab.Text.Text := CreateTabText(LBrowser);
    LNewTabImageName := AppStyle.GetImagePath(LReq.Origin);
    if LNewTabImageName <> LBrowser.Tab.Image.ImageURL then
      LBrowser.Tab.Image.ImageURL := LNewTabImageName;

    if ( not NowLoadingSession ) And Settings.AutoSaveSession then
    begin
      Groups := Session.GetBookmarksGroups;
      if Length(Groups) > 0 then
      begin
        Group := Groups[0];
        if ( LBrowser.Tag <> -1 ) then
          Group.Delete(LBrowser.Tag);

        Group.Add(LReq);
        LBrowser.Tag := Group.GetMaxId;
      end;
    end;
  finally
    try
      FreeInterfaced(LReq);
    except
      On E: Exception do Log('OnBrowserReqChanged finally', E);
    end
  end;
end;

procedure TForm1.SetDefToWebClient(AClient: TNetHttpClient; AOrigin: integer);
begin
  with AClient do begin

    if not (AOrigin = PVR_DANBOORU) then
    begin
      Useragent := Settings.DefaultUseragent;
      Customheaders['Accept'] := '*/*';
      CustomHeaders['Accept-Language'] := 'en-US,en;q=0.5';
      CustomHeaders['Accept-Encoding'] := 'gzip, deflate'; { br not support }
    end;

    AutomaticDecompression := [THttpCompressionMethod.Any];
    AllowCookies := Settings.AllowCookies;
    SendTimeout := 6000;
    ConnectionTimeout := 6000;
    ResponseTimeout := 6000;

    if Settings.AutoAcceptAllCertificates then
      AClient.OnValidateServerCertificate := Form1.NetHttpOnValidateCertAutoAccept;

    case AOrigin of
      PVR_9HENTAITO:
      begin
        CustomHeaders['Accept'] := 'application/json, text/plain, */*';
        CustomHeaders['Content-Type'] := 'application/json;charset=utf-8';
      end;
    end;
  end;
end;

procedure SetBtnStatus(ABtn: TRectButton; const AStr: string; const AImagePath: string);
begin
  ABtn.Visible := True;
  if not AImagePath.IsEmpty
  and (ABtn.Image.ImageUrl <> AImagePath) then
    ABtn.Image.ImageUrl := AImagePath;
  ABtn.Text.Text := AStr;
end;

procedure TForm1.SetImageViewerStatus(const AStr: string; AImagePath: string);
begin
  SetBtnStatus(BtnStatusImageView, AStr, AImagePath);
end;

procedure TForm1.OnBrowserScraperCreate(Sender: TObject;
  var AScraper: TNBoxScraper);
begin
  AScraper.BookmarksDb := BookmarksDb.Clone;
  AScraper.HistoryDb := HistoryDb.Clone;
end;

procedure TForm1.OnBrowserSetWebClient(Sender: TObject;
  AWebClient: TNetHttpClient; AOrigin: integer);
begin
  SetDefToWebClient(AWebClient, AOrigin);
end;

procedure TForm1.OnBrowsersNotify(Sender: TObject; const Item: TNBoxBrowser;
  Action: TCollectionNotification);
begin
  form1.MenuBtnNewTab.Text.Text := 'Create new tab ( ' + Browsers.Count.ToString +  ' )';
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
      if Not LBrowser.IsBrowsingNow then
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

  if LCard.HasPost then
  begin
    if Assigned(LCardS) then
    begin
      LCardS.Text.Color := AppStyle.TextColors[0];
      AppStyle.ItemCard.Fill2.Apply(LCardS.Rect.Fill);

      if LCards.Rect.Visible then
      begin
        var LCaptionInterface: IHasCaption;

        var LHasCaption := LCardS.HasPost
          and Supports(LCardS.Post, IHasCaption, LCaptionInterface)
          and (not LCaptionInterface.Caption.IsEmpty);

        LCardS.Rect.Visible := Settings.ShowCaptions
          and LHasCaption
          or (LCardS.Rect.Align = TAlignlayout.Client);
      end;
    end;
  end else if ( LCard.HasBookmark and LCard.Bookmark.IsRequest ) then begin
    if Assigned(LCardS) then
    begin
      LCardS.Text.Color := AppStyle.TextColors[0];
      LCardS.ImageURL := AppStyle.GetImagePath(IMAGE_REQUEST_ITEM);
    end;
  end;
  LCard.Fill.Kind := TBrushKind.Bitmap;
end;

procedure TForm1.OnCreateDownloader(Sender: Tobject;
  const ADownloader: TNBoxDownloader);
begin
  with ADownloader do begin
    SynchronizeEvents := True;
    RetryTimeout := 1500;
    OnCreateWebClient := DownloaderOnCreateWebClient;
    OnReceiveData := DownloaderOnReceiveData;
    OnRequestException := DownloaderOnException;
    OnFinish := Self.DownloaderOnFinish;
  end;
end;

procedure TForm1.OnIWUManagerCreateWebClient(Sender: TObject;
  AClient: TNetHttpClient);
begin
  AClient.OnValidateServerCertificate := Form1.NetHttpOnValidateCertAutoAccept;
end;

procedure TForm1.OnIWUException(Sender: TObject; AImage: IImageWithURL;
  const AUrl: string; const AException: Exception);
begin
  Log('OnIWUException ' + AUrl, AException);
  TThread.Synchronize(nil,
  procedure
  begin
    try
      AImage.BitmapIWU.LoadFromFile(AppStyle.GetImagePath(IMAGE_LOAD_ERROR));
    except end;
    if Sender = (ImageViewer.ImageManager as TObject) then
      SetImageViewerStatus(AException.Message, AppStyle.GetImagePath(ICON_WARNING));
  end);
end;

procedure TForm1.OnIWUFilterResponse(Sender: TObject; const AUrl: string;
  const AResponse: IHttpResponse; var AAllow: boolean);
begin
  if AResponse.MimeType.StartsWith('image/', TRUE) then
    AAllow := True
  else begin
    AAllow := False;
    if Sender = (ImageViewer.ImageManager as TObject) then
    TThread.Synchronize(TThread.Current, procedure begin
      SetImageViewerStatus('MimeType: ' + AResponse.MimeType, AppStyle.GetImagePath(ICON_WARNING));
    end);
  end;
end;

procedure TForm1.OnImageViewerFinished(Sender: TObject; ASuccess: boolean);
begin
  ImageViewer.BestFit;
end;

procedure TForm1.OnImageViewerReceiveData(const Sender: TObject;
  AContentLength, AReadCount: Int64; var AAbort: Boolean);
begin
  TThread.Synchronize(TThread.Current,
  procedure begin
    if not Settings.ShowImageViewerStatusBar then Exit;
    with BtnStatusImageView do
    begin
      Visible := not (AContentLength = AReadCount);
      if Visible then
      begin
        var LFileSizeStr := BytesCountToSizeStr(AContentLength);
        SetImageViewerStatus(
          '[ ' + GetPercents(AContentLength, AReadCount).toString + '% ] of ' + LFileSizeStr,
          AppStyle.GetImagePath(ICON_NEXT)
        );
      end;
    end;
  end);
end;

procedure TForm1.OnImageViewerWebClient(Sender: TObject;
  AClient: TNetHttpClient);
begin
  OnIWUManagerCreateWebClient(Sender, AClient);
  with AClient do
    OnReceiveData := OnImageViewerReceiveData;
end;

function DownloadItemText(A: TNetHttpDownloader): string;
var
  ContentSize: int64;
  FileSizeStr: string;
begin
  ContentSize := A.ContentLength;
  if ContentSize > 0 then
  begin
    FileSizeStr := BytesCountToSizeStr(ContentSize);
    Result := '[ ' + GetPercents(ContentSize, A.ReadCount).ToString
      + '% ] of ' + FileSizeStr;
  end else
    Result := 'Unknown size. Ready: ' + BytesCountToSizeStr(A.ReadCount);
end;

procedure TForm1.DownloaderOnException(const Sender: TObject;
  const AError: Exception);
var
  Loader: TNBoxDownloader;
  LNewText: string;
begin
  try
    Loader := (Sender as TNBoxDownloader);
    TThread.Synchronize(TThread.Current,
    procedure
    begin
      if Assigned(Loader.Tab) then begin
        LNewText := DownloadItemText(Loader) + ' '
          + AError.Message + ' try: ' + Loader.RetriedCount.ToString;
        Loader.Tab.Text.Text := LNewText;
      end;
    end);
  except
    On E: Exception do Log('TForm1.DownloaderOnException', E);
  end;
end;

procedure TForm1.DownloaderOnFinish(Sender: TObject);
var
  Loader: TNBoxDownloader;
begin
  try
    Loader := (Sender as TNBoxDownloader);
    var LIndex: integer := DownloadItems.IndexOf(Loader.Tab);
    if Assigned(Loader.Tab) then
    begin
      DownloadItems.Delete(LIndex);
      try
       { potential deadlock - Tab.CloseBtn have ImageWithUrl }
       { that need to be waited before destroy.              }
        BlackHole.Throw(Loader.Tab);
        Loader.Tab := Nil;
      except
        On E: Exception do Log('LTab.Free; with index of ' + LIndex.ToString, E);
      end;
    end else
      Log('DownloaderOnFinish: Loader.Tab not Assigned.');
  except
    On E: Exception do Log('DownloaderOnFinish', E);
  end;
end;

procedure TForm1.DownloaderOnReceiveData(const Sender: TObject; AContentLength,
  AReadCount: Int64; var AAbort: Boolean);
var
  Loader: TNBoxDownloader;
begin
  try
    Loader := (Sender as TNBoxDownloader);
    if Loader.IsRunning then
    begin
      if not Assigned(Loader.Tab) then exit;
      Loader.Tab.Text.Text := DownloadItemText(Loader);
    end;
  except
    On E: Exception do Log('DownloaderOnReceiveData', E);
  end;
end;

procedure TForm1.DownloadFetcherOnFetched(Sender: TObject;
  var AItem: INBoxItem);
var
  LItem: INBoxItem;
begin
  LItem := AItem;
  FetchedItemsCache.Save(LItem);
  TThread.Synchronize(TThread.Current,
  procedure begin
    try
      if not AppDestroying then AddDownload(LItem, True);
      FreeInterfaced(LItem);
    except
      On E: Exception do Log('DownloadFetcherOnFetched', E);
    end;
  end);
end;

procedure TForm1.DownloaderOnCreateWebClient(const Sender: TObject;
  AWebClient: TNetHttpClient);
begin
  SetDefToWebClient(AWebClient);
  AWebClient.AcceptEncoding := '';
end;

procedure TForm1.OnSimpleCardResize(Sender: TObject);
const
  MAX_FONT_SIZE = 16;
var
  S: TSize;
  M: single;
begin
  with (Sender as TNBoxCardSimple) do
  begin
    if fill.Bitmap.Bitmap.IsEmpty then
    begin
      Size.Height := Size.Width;
      if not (Rect.Align = TAlignLayout.Client) then Exit;
    end;

    if not (Rect.Align = TAlignLayout.Client) then
    begin
      S := TSize.Create(fill.bitmap.Bitmap.Size);
      M := S.Width / S.Height;
      Size.Height := Size.Width / M;

      Rect.Height := round( size.Height / 3.6 );
      text.Font.Size := round( size.Width / 18 );
      text.Height := Rect.Height - ( Rect.Padding.Top + Rect.Padding.Bottom );
    end else begin
      M := round(size.Width / 12);
      if M > MAX_FONT_SIZE then
        M := MAX_FONT_SIZE;
      Text.Font.Size := M;
    end;
  end;
end;

procedure TForm1.OnNewItem(Sender: TObject; var AItem: TNBoxCardBase);
var
  LBrowser: TNBoxBrowser;
begin
  with AItem do begin
    OnTap := CardOnTap;
    OnAutoLook := OnCardAutoLook;
    OnMouseDown := CardOnMouseDown;
    AppStyle.ItemCard.Apply(AItem);

    if AItem is TNBoxCardSimple then
      OnResize := form1.OnSimpleCardResize;

    Margins.Top := Settings.ItemIndent;
    {$IFDEF MSWINDOWS}
    OnClick := ClickTapRef;
    {$ENDIF}

    if Aitem.HasPost and (AItem is TNBoxCardSimple)
    and AItem.Post.ThumbnailUrl.IsEmpty then
    begin
      with TNBoxCardSimple(AItem) do begin
        Rect.Align := TAlignLayout.Client;
        Text.Align := TAlignLayout.Client;
      end;
    end;

    OnAutoLook(AItem);
  end;

  LBrowser := TNboxBrowser(Sender);
  if Assigned(LBrowser.Tab) then
    LBrowser.Tab.Text.Text := CreateTabText(LBrowser);
end;

procedure TForm1.OnStartDownloader(Sender: Tobject;
  const ADownloader: TNBoxDownloader);
begin

end;

procedure TForm1.IconOnResize(Sender: TObject);
begin
  with ( Sender as TControl ) do
    Width := Height;
end;

function TForm1.IndexTabByBrowser(ABrowser: TNBoxBrowser): integer;
var
  I: integer;
begin
  result := -1;
  for I := 0 to Tabs.Count - 1 do
  begin
    if Tabs.Items[I].Browser = ABrowser then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

procedure DefaultAfterClick(ACard: TNBoxCardBase);
begin
  if ACard.HasPost then
  begin
    Form1.CurrentItemForWaitFetch := Form1.FetchContent(ACard.Post);
    if Form1.Settings.SaveTapHistory then
      HistoryDb.TapGroup.Add(ACard.Post);
  end;
end;

procedure TForm1.CardOnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var
  LItem: TNBoxCardBase;
begin
  if Button = TMouseButton.mbRight then
  begin
    LItem := Sender as TNBoxCardBase;
    DefaultAfterClick(LItem);
    ExecItemInteraction(LItem, ACTION_OPEN_MENU);
  end;
end;

procedure TForm1.CardOnTap(Sender: TObject; const Point: TPointF);
var
  I: integer;
  Item: TNBoxCardBase;
  Interactions: TArray<NativeInt>;
begin
  Item := (Sender as TNBoxCardBase);
  DefaultAfterClick(Item);
  Interactions := Settings.ItemInteractions;
  for I := 0 to High(Interactions) do
  begin
    Self.ExecItemInteraction(Item, Interactions[I]);
    if ( Interactions[I] = ACTION_DELETE_CARD ) then
    begin
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
  LBookmarks: TBookmarkAr;
  LBookmark: TNBoxBookmark;
  I: integer;
  LPage: integer;
  LTab: TNBoxTab;
  LHitLimit: boolean;
begin
  Result := False;
  LHitLimit := False;
  NowLoadingSession := True;
  try
    try
      Groups := Session.GetBookmarksGroups;
      if Length(Groups) < 1 then
        exit;

      Group := Groups[0];
      LPage := Group.GetMaxPage;
      if LPage = 0 then Exit;
      repeat
        LBookmarks := Group.GetPage(LPage);
        if (not Result) and (Length(LBookmarks) > 0) then
          Result := True;

        for I := High(LBookmarks) downto Low(LBookmarks) do
        begin
          if Tabs.Count >= Settings.MaxTabsAtStartup then
          begin
            LHitLimit := True;
            Break;
          end;

          LBookmark := LBookmarks[I];
          if not (LBookmark.BookmarkType = SearchRequest) then
            continue;

          var LReq := LBookmark.AsRequest;
          LTab := AddBrowser(LReq);
          Browsers.Last.Tag := LBookmark.Id;

          LReq := Nil;
          LBookmarks[I] := Nil;
          LBookmark.FreeObj;
          FreeAndNil(LBookmark);
        end;
        Dec(LPage);
      until (LPage <= 0) or (LHitLimit);

      { Free garbage }
      if LHitLimit then
      begin
        For I := I downto Low(LBookmarks) do
        begin
          LBookmarks[I].FreeObj;
          FreeAndNil(LBookmarks[I]);
        end;
      end;

    except
      On E: Exception do begin
        Log('LoadSession', E);
        Result := False;
      end;
    end;
  finally
    NowLoadingSession := False;
  end;
end;

function TForm1.LoadSettings: boolean;
var
  NewSettings: TNsfwBoxSettings;
  X: ISuperObject;
  JsonStr: String;
begin
  try
    NewSettings := nil;
    Result := fileexists(SETTINGS_FILENAME);
    try
      if Result then
      begin
        X := TSuperObject.ParseFile(SETTINGS_FILENAME);
        JsonStr := X.AsJSON;
        NewSettings := TNSfwBoxSettings.Create;
        NewSettings.AssignFromJSONStr(JsonStr);
        Settings := NewSettings;
      end;
    except
      on E: Exception do
      begin
        Result := false;
        Log('LoadSettings', E);
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
      if Result then
      begin
        NewStyle := TNBoxGUIStyle.create;
        X := TSuperobject.ParseFile(Fname);
        NewStyle.AssignFromJSON(X);
        AppStyle := NewStyle;
      end;
    except
      On E: Exception do
      begin
        Result := false;
        Log('LoadStyle', E);
      end;
    end;
  finally
    if assigned(NewStyle) then NewStyle.Free;
  end;
end;

procedure TForm1.MenuBackupFilesOnSelect(Sender: TObject);
begin
  EdtApplyBackupFilename.Edit.Text := SelectMenuBackupFiles.Selected;
end;

procedure TForm1.MenuBtnBookmarksOnTap(Sender: TObject; const Point: TPointF);
begin
  GotoBookmarksMenu(BookmarksDb);
end;

procedure TForm1.MenuBtnHistoryOnTap(Sender: TObject; const Point: TPointF);
begin
  GotoBookmarksMenu(HistoryDb);
end;

procedure TForm1.MenuBtnDownloadsOnDblClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  ShellExecute(0, 'open', 'explorer', PChar(Settings.DefDownloadPath), nil, SW_SHOWNORMAL);
  {$ENDIF}
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
      Log('TForm1.MenuBtnNewTabOnTap', E);
  end;
end;

procedure TForm1.MenuBtnSettingsOnTap(Sender: TObject; const Point: TPointF);
begin
  ChangeInterface(MenuSettings);
end;

procedure TForm1.MenuChangeDownloadAllModeOnSelected(Sender: TObject);
begin
  FSettings.DownloadAllMode := TDownloadAllMode(MenuChangeDownloadAllMode.Selected);
  SaveSettings;
  ChangeInterface(MenuSettings);
end;

procedure TForm1.MenuChangeThemeOnSelected(Sender: TObject);
begin
  FSettings.StyleName := MenuChangeTheme.Selected;
  SaveSettings;
  ChangeInterface(MenuSettings);
end;

procedure TForm1.MenuItemTagsOnSelected(Sender: TObject);
var
  LReq: INBoxSearchRequest;
begin
  LReq := CreateTagReq(MenuItemTagsOrigin, MenuItemTags.Selected);
  try
    AddBrowser(LReq, Settings.AutoStartBrowse);
  finally
    FreeInterfaced(LReq);
  end;
end;

procedure TForm1.NetHttpOnValidateCertAutoAccept(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := TRUE;
end;

function TForm1.NewMenu: TVertScrollBox;
begin
  Result := TVertScrollBox.Create(MainLayout);
  Result.Parent := MainLayout;
  Result.Visible := False;
  Result.Align := TAlignLayout.Client;
end;

procedure TForm1.ReloadBookmarks(ADataBase: TNBoxBookmarksDb; ALayout: TControl);
var
  I: Integer;
  LGroups: TBookmarkGroupRecAr;
  LGroup: TBookmarkGroupRec;
  LControl: TNBoxSettingsCheck;
  LControls: TControlObjList;
  LOrder: TList<Int64>;

  function _getName(AGroup: TBookmarkGroupRec): string;
  begin
    Result := ' ' + AGroup.Name + ' <font color="' + COLOR_TAG_TOTAL_COUNT + '">'
      + AGroup.ItemsCount.ToString + ' </font>';
  end;

  function BookmarkControlById(AId: nativeint): TNBoxSettingsCheck;
  var
    I: integer;
  begin
    for I := 0 to LControls.Count - 1 do
    begin
      if (LControls[I].Tag = AId) then
      begin
        Result := LControls[I] as TNBoxSettingsCheck;
        Exit;
      end;
    end;
    Result := nil;
  end;

begin
  try
    if ADataBase = BookmarksDb then
      LControls := BookmarksControls
    else if ADataBase = HistoryDb then
      LControls := HistoryDbControls;

    LGroups := ADataBase.GetBookmarksGroups;

    for I := Low(LGroups) to High(LGroups) do
    begin
      LGroup := LGroups[I];
      LControl := BookmarkControlById(LGroup.Id);

      if assigned(LControl) then
      begin
      { Changing already exists control }
        with LControl do begin
          Check.Text.TextIsHtml := True;
          Check.Text.Text := _getName(LGroup);
          Text.Text := LGroup.About;
        end;

      end else begin
      { Making new control }
        LControl := Self.CreateDefSettingsCheck(ALayout);
        with LControl do
        begin
          Parent := ALayout;
          Check.ImageControl.Visible := true;
          Check.ImageControl.Margins.Rect := TRectF.Create(0, 5, 0, 5);

          if (ADataBase = BookmarksDb) then
            Check.Image.ImageURL := AppStyle.GetImagePath(ICON_BOOKMARKS)
          else if (ADataBase = HistoryDb) then
            Check.Image.ImageURL := AppStyle.GetImagePath(ICON_HISTORY);

          Align := TAlignLayout.Top;
          Position.Y := Single.MaxValue;
          Check.Text.TextIsHtml := True;
          Check.Text.Text := _getName(LGroup);
          Text.Text := LGroup.About;
          Tag := LGroup.Id;
          Check.HitTest := false;
          Text.HitTest := false;
          Text.VertTextAlign := TTextAlign.Leading;
          Check.Check.Visible := false;
          Check.Height := LControl.Check.Height * 0.8;
          Height := LControl.Height * 1.5;
          Margins.Rect := TRectF.Create(5, 5, 5, 0);
          OnTap := BookmarksControlOnTap;
          {$IFDEF MSWINDOWS}
          LControl.OnClick := ClickTapRef;
          {$ENDIF}
        end;
        LControls.Add(LControl);
      end;
    end;

    if ADataBase = BookmarksDb then
    begin
      LOrder := Settings.BookmarksOrder.LockList;
      try
        { Saving order of groups (v?.?.? -> >=v2.4.0) }
        if (LOrder.Count = 0)
        and (Length(LGroups) > 0) then
        begin
          for I := Low(LGroups) to High(LGroups) do
            LOrder.Add(LGroups[I].Id);
          SaveSettings;
        end;

        { applying order of groups }
        for I := LOrder.Count - 1 downto 0 do
        begin
          LControl := BookmarkControlById(LOrder[I]);
          if not Assigned(LControl) then Continue;
          LControl.Position.Y := 0 + I; { push up }
        end;
      finally
        Settings.BookmarksOrder.UnlockList;
      end;
    end;

  except
    On E: Exception do
      Log('ReloadBookmarks', E);
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
  Settings.SemVer := APP_VERSION;
  if FileExists(SETTINGS_FILENAME) then
    TFile.Delete(SETTINGS_FILENAME);
  WriteToFile(SETTINGS_FILENAME, Settings.ToJsonStr);
end;

procedure TForm1.SaveSettingsChanges;
var
  NewSet: TNsfwBoxSettings;
  I: integer;

  function ValidateInt(ASetEdit: TNBoxSettingsEdit; ADefaultValue: integer): Integer;
  begin
    if not TryStrToInt(ASetEdit.Edit.Edit.Text, Result) then
      ASetEdit.Edit.Edit.Text := ADefaultValue.ToString;
  end;

begin
  NewSet := TNsfwBoxSettings.Create;
  with NewSet do begin
    Assign(FSettings);

    ValidateInt(EditSetThreadsCount, 6);
    ValidateInt(EditSetLayoutsCount, 2);
    ValidateInt(EditSetItemIndent, 2);
    ValidateInt(EditSetMaxDownloadThreads, 2);

    var LControls := Form1.MenuSettings.Content.Controls;
    for I := 0 to LControls.Count - 1 do
    begin
      if LControls[I] is TNBoxSettingsEdit then
      begin { update edit }
        var LControl: TNBoxSettingsEdit := LControls[I] as TNBoxSettingsEdit;
        NewSet.Attributes[LControl.TagString] := LControl.Edit.Edit.Text;
      end;
    end;

    DownloadManager.ThreadsCount := MaxDownloadThreads;
    IWUContentManager.EnableSaveToCache := ImageCacheSave;
    IWUContentManager.EnableLoadFromCache := ImageCacheLoad;
    BrowsersIWUContentManager.EnableSaveToCache := ImageCacheSave;
    BrowsersIWUContentManager.EnableLoadFromCache := ImageCacheLoad;

    if not ShowImageViewerStatusBar then
      BtnStatusImageView.Visible := False;

    if AutoSaveSession then
      ConnectSession;

    if Assigned(Settings) then begin
      var LNewOrder, LOrder: TList<Int64>;
      LNewOrder := BookmarksOrder.LockList;
      try
        LOrder := Settings.BookmarksOrder.LockList;
        try
          LNewOrder.Clear;
          LNewOrder.AddRange(LOrder.ToArray);
        finally
          Settings.BookmarksOrder.UnlockList;
        end;
      finally
        BookmarksOrder.UnlockList;
      end;
    end;
  end;

  Settings := NewSet;
  NewSet.Free;
  SaveSettings;
end;

procedure TForm1.SetAppFullscreen(const Value: boolean);
begin
  Form1.FullScreen := Value;
  {$IFDEF MSWINDOWS}
    if Assigned(TitleBar) and Settings.UseNewAppTitlebar then
      TitleBar.Visible := Not Value; // if fullscreen then hide
    if Value then
    begin // fix position
      Form1.Top := 0;
      Form1.Left := 0;
    end;
  {$ENDIF}
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

procedure TForm1.SetBrowserStatus(const AStr: string; AImagePath: string);
begin
  SetBtnStatus(BtnStatus, AStr, AImagePath);
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
  LReq: INBoxSearchRequest;
begin
  if Assigned(FCurrentBrowser) then
  begin
    FCurrentBrowser.Tab.ImageControl.Visible := false;
    ClearControlBitmap(FCurrentBrowser.Tab.ImageControl);
    FCurrentBrowser.Visible := false;
  end;

  FCurrentBrowser := Value;
  FCurrentBrowser.Tab.ImageControl.Visible := true;

  LReq := FCurrentBrowser.Request;
  try
    FCurrentBrowser.Tab.Image.ImageURL := AppStyle.GetImagePath(LReq.Origin);
    FCurrentBrowser.Visible := true;
  finally
    FreeInterfaced(LReq);
  end;

  BtnStatus.Visible := False;
end;

procedure TForm1.SetCurrentItem(const value: TNBoxCardBase);
begin
  FCurrentItem := Value;
end;

procedure TForm1.SetCurrentItemForWaitFetch(const Value: INBoxItem);
begin
  FLock.BeginWrite;
  try
    FCurrentItemForWaitFetch := Value;
    FCurrentItemForWaitFetchEvent.ResetEvent;
  finally
    FLock.EndWrite;
  end;
end;

procedure TForm1.SetSettings(const value: TNsfwBoxSettings);
var
  I: integer;
begin
  if not Assigned(FSettings) then
    FSettings := TNsfwBoxSettings.Create;

  FSettings.Assign(Value);
  if not FFormCreated then Exit;

  BrowsersIWUContentManager.ThreadsCount := Settings.ThreadsCount;
  DownloadManager.ThreadsCount  := Settings.MaxDownloadThreads;

  if AppFullscreen <> FSettings.Fullscreen then
    AppFullScreen := FSettings.Fullscreen;

  var LControls := Form1.MenuSettings.Content.Controls;
  var LSettingsCheck: TNBoxSettingsCheck;
  for I := 0 to LControls.Count - 1 do
  begin
    var LControl := LControls[I];
    if LControl is TNBoxSettingsEdit then
    begin { update edit }
      with LControl as TNBoxSettingsEdit do
        Edit.Edit.Text := VarToStr(Settings.Attributes[LControl.TagString]);
    end

    else if LControl is TNBoxSettingsCheck then
    begin { update checkbox }
      LSettingsCheck := TNBoxSettingsCheck(LControl);
      LSettingsCheck.Check.IsChecked := Settings.Attributes[LSettingsCheck.TagString];
    end;
  end;

  if Settings.DevMode then NsfwBox.Tests.Init;
  for I := 0 to MenuTestButtons.Count - 1 do
    MenuTestButtons[I].Visible := Settings.DevMode;

  With SearchMenu.OriginSetMenu do
  begin
    var LBtn: TControl := Menu.GetControlByValue(PROVIDERS.Pseudo.id);
    if Assigned(LBtn) then LBtn.Visible := Settings.DevMode;
    LBtn := Menu.GetControlByValue(PROVIDERS.Bookmarks.id);
    if Assigned(LBtn) then LBtn.Visible := Settings.DevMode;
  end;

  for I := 0 to Browsers.Count - 1 do
  begin
    with Browsers[I] do
    begin
      ColumnsCount := Settings.ContentLayoutsCount;
      ItemsIndent := TPointF.Create(Settings.ItemIndent, Settings.ItemIndent);
    end;
  end;
end;

procedure TForm1.SetSubHeader(const Value: string);
begin
  TopBottomText.Text := Value;
end;

procedure TForm1.SettingsCheckOnTap(Sender: TObject; const Point: TPointF);
var
  LSettingsCheck: TNBoxSettingsCheck;
  LAttrName: string;
begin
  LSettingsCheck := TNBoxSettingsCheck(TControl(Sender).Parent);
  LAttrName := LSettingsCheck.TagString;
  Settings.Attributes[LAttrName] := LSettingsCheck.Check.IsChecked;
  SaveSettingsChanges;
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

procedure TForm1.ToastMessage(const AMessage: string; AShort: boolean);
begin
 {$IFDEF ANDROID}
 TToast.Make(AMessage, AShort);
 {$ENDIF}
end;

procedure TForm1.TopBtnAppOnTap(Sender: TObject; const Point: TPointF);
begin
  {$IFDEF COUNT_APP_OBJECTS}
  Form1.TopBottomText.Text := 'I: ' + BaseItemCounter.Count.ToString
  + ' B: ' + BookmarkItemCounter.Count.ToString
  + ' R: ' + ReqItemCounter.Count.ToString
  + ' C: ' + CardCounter.Count.ToString;
  {$ENDIF}
  ChangeInterface(BrowserLayout);
end;

procedure TForm1.TopBtnPopMenuOnTap(Sender: TObject; const Point: TPointF);
begin
  if MenuBookmarks.Visible then
  begin
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
  LReq: INBoxSearchRequest;
begin
  if MenuSearchSettings.Visible then
  begin
    if not Assigned(CurrentBrowser) then
      CurrentBrowser := AddBrowser(nil, false).Owner as TNBoxBrowser;

    LReq := SearchMenu.Request;
    try
      CurrentBrowser.Request := LReq;
      ChangeInterface(form1.BrowserLayout);
      CurrentBrowser.GoBrowse;
    finally
      FreeInterfaced(LReq);
    end;

  end else begin

    if not Assigned(CurrentBrowser) then
    begin
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
  try
    GotoBookmarksMenu(BookmarksDb);
    NowUserSelect := true;
    AfterUserEvent := AWhenSelected;
  except
    On E: Exception do
      Log('UserSelectBookmarkList', E);
  end;
end;

procedure TForm1.ClearControlBitmap(AControl: TControl);
var
  IWU: IImageWithUrl;
begin
  if (AControl is TImage) then
    (AControl as TImage).Bitmap.SetSize(0, 0)
  else if (AControl is TAlRectangle) then
    (AControl as TAlRectangle).Fill.Bitmap.Bitmap.SetSize(0, 0)
  else if (AControl is TRectangle) then
    (AControl as TRectangle).Fill.Bitmap.Bitmap.SetSize(0, 0)
  else if Supports(AControl, IImageWithUrl, IWU) then
    IWU.BitmapIWU.SetSize(0, 0);
end;

procedure TForm1.SetStretchImage(AImage: TControl);
begin
  if (AImage is TImage) then
    (AImage as TImage).WrapMode := TImageWrapMode.Stretch
  else if (AImage is TAlRectangle) then
    (AImage as TAlRectangle).Fill.Bitmap.WrapMode := TWrapMode.TileStretch
  else if (AImage is TRectangle) then
    (AImage as TRectangle).Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
end;

end.

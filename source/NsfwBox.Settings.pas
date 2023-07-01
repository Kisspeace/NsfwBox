{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Settings;

interface
uses
  Classes, System.SysUtils, XSuperObject, system.Generics.Collections,
  NsfwBox.UpdateChecker, NsfwBox.Logging, NsfwBox.Utils, System.Rtti,
  System.Variants;

Const

  ACTION_OPEN_MENU          = 0;
  ACTION_DOWNLOAD_ALL       = 1;
  ACTION_PLAY_EXTERNALY     = 2;
  ACTION_ADD_BOOKMARK       = 3;
  ACTION_DELETE_BOOKMARK    = 4;
  ACTION_LOG_URLS           = 5;
  ACTION_COPY_CONTENT_URLS  = 6;
  ACTION_COPY_THUMB_URL     = 7;
  ACTION_OPEN_RELATED       = 8;
  ACTION_OPEN_AUTHOR        = 9;
  ACTION_SHARE_CONTENT      = 10;
  ACTION_BROWSE             = 11;
  ACTION_DELETE_CARD        = 12;
  ACTION_SHOW_TAGS          = 13;
  ACTION_SHOW_FILES         = 14;
  ACTION_PLAY_INTERNALY     = 15;

  FORMAT_VAR_CONTENT_URL = '$(NSFWBOX_CONTENT_URL)';

type

  TNBoxItemInteraction = NativeInt;
  TNBoxItemInteractions = TArray<TNBoxItemInteraction>;

  TInt64Ar = TArray<Int64>;
  TBookmarksOrderList = TThreadList<Int64>;

  TDownloadAllMode = (
    damAllVersions,
    damHighResVersion,
    damMediumResVersion);

  { Application settings (Thread safe) }
  TNsfwBoxSettings = class
    private
      FLock: TMREWSync;
      FSemVer: TSemVer;
      FDefaultUseragent: string;
      FAllowCookies: boolean;
      FDefDownloadPath: string;
      FStyleName: string;
      FThreadsCount: integer;
      FContentLayoutsCount: integer;
      FItemIndent: single;
      FFullscreen: boolean;
      FAutoSaveSession: boolean;
      FSaveSearchHistory: boolean;
      FSaveDownloadHistory: boolean;
      FSaveTapHistory: boolean;
      FSaveClosedTabHistory: boolean;
      FBrowseNextPageByScrollDown: boolean;
      FImageCacheSave: boolean;
      FImageCacheLoad: boolean;
      FAutoAcceptAllCertificates: boolean;
      FYDWSyncLoadFromFile: boolean;
      FShowCaptions: boolean;
      FMaxDownloadThreads: integer;
      FAutoStartBrowse: boolean;
      FAllowDuplicateTabs: boolean;
      FAutoCloseItemMenu: boolean;
      FItemInteractions: TNBoxItemInteractions;
      FFilenameLogUrls: string;
      FDevMode: boolean;
      FAutoCheckUpdates: boolean;
      FShowScrollBars: boolean;
      FShowNavigateBackButton: boolean;
      FEnableAllContent: boolean;
      FFetchAllBeforeAddBookmark: boolean;
      FShowBrowserStatusBar: boolean;
      FShowImageViewerStatusBar: boolean;
      FPlayExterWhenCantInter: boolean;
      FDefaultBackupPath: string;
      {$IFDEF MSWINDOWS}
        FUseNewAppTitlebar: boolean;
        FContentPlayApp: string;
        FContentPlayParams: string;
      {$ENDIF}
      FDownloadAllMode: TDownloadAllMode;
      FBookmarksOrder: TBookmarksOrderList;
      FMaxTabsAtStartup: integer;
    private
      procedure SetF<T>(var AVariable: T; const ANewValue: T);
      procedure GetF<T>(var AVariable: T; out AOut: T);
      { -------------------- }
      function GetAllowCookies: boolean;
      function GetAllowDuplicateTabs: boolean;
      function GetAutoAcceptAllCertificates: boolean;
      function GetAutoCheckUpdates: boolean;
      function GetAutoCloseItemMenu: boolean;
      function GetAutoSaveSession: boolean;
      function GetAutoStartBrowse: boolean;
      function GetBookmarksOrder: TBookmarksOrderList;
      function GetBrowseNextPageByScrollDown: boolean;
      function GetContentLayoutsCount: integer;
      function GetDefaultBackupPath: string;
      function GetDefaultUseragent: string;
      function GetDefDownloadPath: string;
      function GetDevMode: boolean;
      function GetEnableAllContent: boolean;
      function GetFetchAllBeforeAddBookmark: boolean;
      function GetFilenameLogUrls: string;
      function GetFullscreen: boolean;
      function GetImageCacheLoad: boolean;
      function GetImageCacheSave: boolean;
      function GetItemIndent: single;
      function GetItemInteractions: TNBoxItemInteractions;
      function GetMaxDownloadThreads: integer;
      function GetPlayExterWhenCantInter: boolean;
      function GetSaveClosedTabHistory: boolean;
      function GetSaveDownloadHistory: boolean;
      function GetSaveSearchHistory: boolean;
      function GetSaveTapHistory: boolean;
      function GetSemVer: TSemVer;
      function GetShowBrowserStatusBar: boolean;
      function GetShowCaptions: boolean;
      function GetShowImageViewerStatusBar: boolean;
      function GetShowNavigateBackButton: boolean;
      function GetShowScrollBars: boolean;
      function GetStyleName: string;
      function GetThreadsCount: integer;
      function GetYDWSyncLoadFromFile: boolean;
      procedure SetSaveDownloadHistory(const Value: boolean);
      procedure SetAllowCookies(const Value: boolean);
      procedure SetAllowDuplicateTabs(const Value: boolean);
      procedure SetAutoAcceptAllCertificates(const Value: boolean);
      procedure SetAutoCheckUpdates(const Value: boolean);
      procedure SetAutoCloseItemMenu(const Value: boolean);
      procedure SetAutoSaveSession(const Value: boolean);
      procedure SetAutoStartBrowse(const Value: boolean);
      procedure SetBrowseNextPageByScrollDown(const Value: boolean);
      procedure SetContentLayoutsCount(const Value: integer);
      procedure SetDefaultBackupPath(const Value: string);
      procedure SetDefaultUseragent(const Value: string);
      procedure SetDefDownloadPath(const Value: string);
      procedure SetDevMode(const Value: boolean);
      procedure SetEnableAllContent(const Value: boolean);
      procedure SetFetchAllBeforeAddBookmark(const Value: boolean);
      procedure SetFilenameLogUrls(const Value: string);
      procedure SetFullscreen(const Value: boolean);
      procedure SetImageCacheLoad(const Value: boolean);
      procedure SetImageCacheSave(const Value: boolean);
      procedure SetItemIndent(const Value: single);
      procedure SetItemInteractions(const Value: TNBoxItemInteractions);
      procedure SetMaxDownloadThreads(const Value: integer);
      procedure SetPlayExterWhenCantInter(const Value: boolean);
      procedure SetSaveClosedTabHistory(const Value: boolean);
      procedure SetSaveSearchHistory(const Value: boolean);
      procedure SetSaveTapHistory(const Value: boolean);
      procedure SetSemVer(const Value: TSemVer);
      procedure SetShowBrowserStatusBar(const Value: boolean);
      procedure SetShowCaptions(const Value: boolean);
      procedure SetShowImageViewerStatusBar(const Value: boolean);
      procedure SetShowNavigateBackButton(const Value: boolean);
      procedure SetShowScrollBars(const Value: boolean);
      procedure SetStyleName(const Value: string);
      procedure SetThreadsCount(const Value: integer);
      procedure SetYDWSyncLoadFromFile(const Value: boolean);
      function GetDownloadAllMode: TDownloadAllMode;
      procedure SetDownloadAllMode(const Value: TDownloadAllMode);
      {$IFDEF MSWINDOWS}
        function GetUseNewAppTitlebar: boolean;
        procedure SetUseNewAppTitlebar(const Value: boolean);
        function GetContentPlayApp: string;
        function GetContentPlayParams: string;
        procedure SetContentPlayApp(const Value: string);
        procedure SetContentPlayParams(const Value: string);
      {$ENDIF}
      function GetAttribute(AName: string): variant;
      procedure SetAttribute(AName: string; const Value: variant);
      function GetMaxTabsAtStartup: integer;
      procedure SetMaxTabsAtStartup(const Value: integer);
    public
      property SemVer: TSemVer read GetSemVer write SetSemVer;
      property DefaultUseragent: string read GetDefaultUseragent write SetDefaultUseragent;
      property AllowCookies: boolean read GetAllowCookies write SetAllowCookies;
      property DefDownloadPath: string read GetDefDownloadPath write SetDefDownloadPath;
      property StyleName: string read GetStyleName write SetStyleName;
      property ThreadsCount: integer read GetThreadsCount write SetThreadsCount;
      property ContentLayoutsCount: integer read GetContentLayoutsCount write SetContentLayoutsCount;
      property ItemIndent: single read GetItemIndent write SetItemIndent;
      property Fullscreen: boolean read GetFullscreen write SetFullscreen;
      property AutoSaveSession: boolean read GetAutoSaveSession write SetAutoSaveSession;
      property SaveSearchHistory: boolean read GetSaveSearchHistory write SetSaveSearchHistory;
      property SaveDownloadHistory: boolean read GetSaveDownloadHistory write SetSaveDownloadHistory;
      property SaveTapHistory: boolean read GetSaveTapHistory write SetSaveTapHistory;
      property SaveClosedTabHistory: boolean read GetSaveClosedTabHistory write SetSaveClosedTabHistory;
      property BrowseNextPageByScrollDown: boolean read GetBrowseNextPageByScrollDown write SetBrowseNextPageByScrollDown;
      property ImageCacheSave: boolean read GetImageCacheSave write SetImageCacheSave;
      property ImageCacheLoad: boolean read GetImageCacheLoad write SetImageCacheLoad;
      property AutoAcceptAllCertificates: boolean read GetAutoAcceptAllCertificates write SetAutoAcceptAllCertificates;
      property YDWSyncLoadFromFile: boolean read GetYDWSyncLoadFromFile write SetYDWSyncLoadFromFile;
      property ShowCaptions: boolean read GetShowCaptions write SetShowCaptions;
      property MaxDownloadThreads: integer read GetMaxDownloadThreads write SetMaxDownloadThreads;
      property AutoStartBrowse: boolean read GetAutoStartBrowse write SetAutoStartBrowse;
      property AllowDuplicateTabs: boolean read GetAllowDuplicateTabs write SetAllowDuplicateTabs;
      property AutoCloseItemMenu: boolean read GetAutoCloseItemMenu write SetAutoCloseItemMenu;
      property ItemInteractions: TNBoxItemInteractions read GetItemInteractions write SetItemInteractions;
      property FilenameLogUrls: string read GetFilenameLogUrls write SetFilenameLogUrls;
      property DevMode: boolean read GetDevMode write SetDevMode;
      property AutoCheckUpdates: boolean read GetAutoCheckUpdates write SetAutoCheckUpdates;
      property ShowScrollBars: boolean read GetShowScrollBars write SetShowScrollBars;
      property ShowNavigateBackButton: boolean read GetShowNavigateBackButton write SetShowNavigateBackButton;
      property EnableAllContent: boolean read GetEnableAllContent write SetEnableAllContent;
      property FetchAllBeforeAddBookmark: boolean read GetFetchAllBeforeAddBookmark write SetFetchAllBeforeAddBookmark;
      property ShowBrowserStatusBar: boolean read GetShowBrowserStatusBar write SetShowBrowserStatusBar;
      property ShowImageViewerStatusBar: boolean read GetShowImageViewerStatusBar write SetShowImageViewerStatusBar;
      property PlayExterWhenCantInter: boolean read GetPlayExterWhenCantInter write SetPlayExterWhenCantInter;
      property DefaultBackupPath: string read GetDefaultBackupPath write SetDefaultBackupPath;
      property DownloadAllMode: TDownloadAllMode read GetDownloadAllMode write SetDownloadAllMode;
      property MaxTabsAtStartup: integer read GetMaxTabsAtStartup write SetMaxTabsAtStartup;
      {$IFDEF MSWINDOWS}
       property UseNewAppTitlebar: boolean read GetUseNewAppTitlebar write SetUseNewAppTitlebar;
       property ContentPlayApp: string read GetContentPlayApp write SetContentPlayApp;
       property ContentPlayParams: string read GetContentPlayParams write SetContentPlayParams;
      {$ENDIF}
      [DISABLE]
      property BookmarksOrder: TBookmarksOrderList read GetBookmarksOrder; { order of items (ids) in bookmarks menu  }
      [DISABLE]
      property Attributes[AName: string]: variant read GetAttribute write SetAttribute;
      function ToJsonStr: String;
      procedure AssignFromJsonStr(const AJson: String);
      procedure Assign(ASource: TNsfwBoxSettings);
      constructor Create;
      destructor Destroy; override;
  end;

implementation
uses
  NsfwBox.FileSystem;
{ TNsfwBoxSettings }

procedure TNsfwBoxSettings.Assign(ASource: TNsfwBoxSettings);
begin
  Self.AssignFromJsonStr(ASource.ToJsonStr);
end;

procedure TNsfwBoxSettings.AssignFromJsonStr(const AJson: String);
var
  X: ISuperObject;
  I: integer;
begin
  X := SO(AJson);
  Self.AssignFromJson(X);
//  Ar := TJson.Parse<TInt64Ar>(X.A['BookmarksOrder']); { <- not work }
  FLock.BeginWrite;
  try

    with FBookmarksOrder.LockList do
    begin
      try
        Clear;
        AddRange(TJsonHelper.ReadIntArray(X, 'BookmarksOrder'));
      finally
        FBookmarksOrder.UnlockList;
      end;
    end;

    FItemInteractions := TJsonHelper.ReadNativeIntArray(X, 'ItemInteractions');
  finally
    FLock.EndWrite;
  end;
end;

constructor TNsfwBoxSettings.Create;
begin
  FLock := TMREWSync.Create;
  FSemVer := TSemVer.Create(0, 0, 0);
  FDevMode                := false;
  FDefDownloadPath        := '';
  FDefaultUserAgent       := '';
  FFilenameLogUrls        := '';
  FStyleName              := 'default.json';
  FAllowCookies           := false;
  FThreadsCount           := 6;
  FContentLayoutsCount    := 2;
  FMaxDownloadThreads     := 4;
  FItemIndent             := 2;
  FAutoSaveSession        := true;
  FSaveSearchHistory      := true;
  FSaveDownloadHistory    := true;
  FSaveClosedTabHistory   := true;
  FSaveTapHistory         := false;
  FBrowseNextPageByScrollDown := True;
  FShowCaptions           := true;
  FAutoStartBrowse        := false;
  FAllowDuplicateTabs     := true;
  FAutoCloseItemMenu      := true;
  FItemInteractions       := [ ACTION_OPEN_MENU ];
  FAutoCheckUpdates       := true;
  FShowScrollBars         := true;
  FShowNavigateBackButton := True;
  FEnableAllContent       := True;
  FFetchAllBeforeAddBookmark := False;
  FShowBrowserStatusBar := True;
  FShowImageViewerStatusBar := True;
  FPlayExterWhenCantInter := False;
  {$IFDEF MSWINDOWS}
    FShowScrollBars       := false;
    FContentPlayApp       := 'C:\Program Files\VideoLAN\VLC\vlc.exe';
    FContentPlayParams    := '"' + FORMAT_VAR_CONTENT_URL + '"';
    FUseNewAppTitlebar    := True;
    FFullScreen           := False;
  {$ELSE IF ANDROID}
    FFullscreen           := True;
  {$ENDIF}
  FDefaultBackupPath := TNBoxPath.GetDefaultBackupPath;
  FImageCacheSave := True;
  FImageCacheLoad := True;
  FAutoAcceptAllCertificates := False;
  FYDWSyncLoadFromFile := False;
  FBookmarksOrder := TBookmarksOrderList.Create;
  FDownloadAllMode := TDownloadAllMode.damHighResVersion;
  FMaxTabsAtStartup := 100;
end;

destructor TNsfwBoxSettings.Destroy;
begin
  FLock.Free;
  BookmarksOrder.Free;
  inherited;
end;

function TNsfwBoxSettings.GetAllowCookies: boolean;
begin
  GetF<boolean>(FAllowCookies, Result);
end;

function TNsfwBoxSettings.GetAllowDuplicateTabs: boolean;
begin
  GetF<boolean>(FAllowDuplicateTabs, Result);
end;

function TNsfwBoxSettings.GetAttribute(AName: string): variant;
var
  Context: TRttiContext;
  Instance: TRttiInstanceType;
  LProperty: TRttiProperty;
begin
  Context := TRttiContext.Create;
  try
    Instance := Context.GetType(TNsfwBoxSettings).AsInstance;
    LProperty := Instance.GetProperty(AName);
    if Assigned(LProperty) then
    begin
      Result := LProperty.GetValue(Self).AsVariant;
    end;
  finally
    Context.Free;
  end;
end;

function TNsfwBoxSettings.GetAutoAcceptAllCertificates: boolean;
begin
  GetF<boolean>(FAutoAcceptAllCertificates, Result);
end;

function TNsfwBoxSettings.GetAutoCheckUpdates: boolean;
begin
  GetF<boolean>(FAutoCheckUpdates, Result);
end;

function TNsfwBoxSettings.GetAutoCloseItemMenu: boolean;
begin
  GetF<boolean>(FAutoCloseItemMenu, Result);
end;

function TNsfwBoxSettings.GetAutoSaveSession: boolean;
begin
  GetF<boolean>(FAutoSaveSession, Result);
end;

function TNsfwBoxSettings.GetAutoStartBrowse: boolean;
begin
  GetF<boolean>(FAutoStartBrowse, Result);
end;

function TNsfwBoxSettings.GetBookmarksOrder: TBookmarksOrderList;
begin
  Result := Self.FBookmarksOrder;
end;

function TNsfwBoxSettings.GetBrowseNextPageByScrollDown: boolean;
begin
  GetF<boolean>(FBrowseNextPageByScrollDown, Result);
end;

function TNsfwBoxSettings.GetContentLayoutsCount: integer;
begin
  GetF<integer>(FContentLayoutsCount, Result);
end;

{$IFDEF MSWINDOWS}
function TNsfwBoxSettings.GetContentPlayApp: string;
begin
  GetF<string>(FContentPlayApp, Result);
end;

function TNsfwBoxSettings.GetContentPlayParams: string;
begin
  GetF<string>(FContentPlayParams, Result);
end;

function TNsfwBoxSettings.GetUseNewAppTitlebar: boolean;
begin
  GetF<boolean>(FUseNewAppTitlebar, Result);
end;

procedure TNsfwBoxSettings.SetContentPlayApp(const Value: string);
begin
  SetF<string>(FContentPlayApp, Value);
end;

procedure TNsfwBoxSettings.SetContentPlayParams(const Value: string);
begin
  SetF<string>(FContentPlayParams, Value);
end;

procedure TNsfwBoxSettings.SetUseNewAppTitlebar(const Value: boolean);
begin
  SetF<boolean>(FUseNewAppTitleBar, Value);
end;
{$ENDIF}

function TNsfwBoxSettings.GetDefaultBackupPath: string;
begin
  GetF<string>(FDefaultBackupPath, Result);
end;

function TNsfwBoxSettings.GetDefaultUseragent: string;
begin
  GetF<string>(FDefaultUseragent, Result);
end;

function TNsfwBoxSettings.GetDefDownloadPath: string;
begin
  GetF<string>(FDefDownloadPath, Result);
end;

function TNsfwBoxSettings.GetDevMode: boolean;
begin
  GetF<boolean>(FDevMode, Result);
end;

function TNsfwBoxSettings.GetDownloadAllMode: TDownloadAllMode;
begin
  GetF<TDownloadAllMode>(FDownloadAllMode, Result);
end;

function TNsfwBoxSettings.GetEnableAllContent: boolean;
begin
  GetF<boolean>(FEnableAllContent, Result);
end;

procedure TNsfwBoxSettings.GetF<T>(var AVariable: T; out AOut: T);
begin
  FLock.BeginRead;
  try
    AOut := AVariable;
  finally
    FLock.EndRead;
  end;
end;

function TNsfwBoxSettings.GetFetchAllBeforeAddBookmark: boolean;
begin
  GetF<boolean>(FFetchAllBeforeAddBookmark, Result);
end;

function TNsfwBoxSettings.GetFilenameLogUrls: string;
begin
  GetF<string>(FFilenameLogUrls, Result);
end;

function TNsfwBoxSettings.GetFullscreen: boolean;
begin
  GetF<boolean>(FFullscreen, Result);
end;

function TNsfwBoxSettings.GetImageCacheLoad: boolean;
begin
  GetF<boolean>(FImageCacheLoad, Result);
end;

function TNsfwBoxSettings.GetImageCacheSave: boolean;
begin
  GetF<boolean>(FImageCacheSave, Result);
end;

function TNsfwBoxSettings.GetItemIndent: single;
begin
  GetF<single>(FItemIndent, Result);
end;

function TNsfwBoxSettings.GetItemInteractions: TNBoxItemInteractions;
begin
  FLock.BeginRead;
  try
    Result := Copy(FItemInteractions);
  finally
    FLock.EndRead;
  end;
end;

function TNsfwBoxSettings.GetMaxDownloadThreads: integer;
begin
  GetF<integer>(FMaxDownloadThreads, Result);
end;

function TNsfwBoxSettings.GetMaxTabsAtStartup: integer;
begin
  GetF<integer>(FMaxTabsAtStartup, Result);
end;

function TNsfwBoxSettings.GetPlayExterWhenCantInter: boolean;
begin
  GetF<boolean>(FPlayExterWhenCantInter, Result);
end;

function TNsfwBoxSettings.GetSaveClosedTabHistory: boolean;
begin
  GetF<boolean>(FSaveClosedTabHistory, Result);
end;

function TNsfwBoxSettings.GetSaveDownloadHistory: boolean;
begin
  GetF<boolean>(FSaveDownloadHistory, Result);
end;

function TNsfwBoxSettings.GetSaveSearchHistory: boolean;
begin
  GetF<boolean>(FSaveSearchHistory, Result);
end;

function TNsfwBoxSettings.GetSaveTapHistory: boolean;
begin
  GetF<boolean>(FSaveTapHistory, Result);
end;

function TNsfwBoxSettings.GetSemVer: TSemVer;
begin
  GetF<TSemVer>(FSemVer, Result);
end;

function TNsfwBoxSettings.GetShowBrowserStatusBar: boolean;
begin
  GetF<boolean>(FShowBrowserStatusBar, Result);
end;

function TNsfwBoxSettings.GetShowCaptions: boolean;
begin
  GetF<boolean>(FShowCaptions, Result);
end;

function TNsfwBoxSettings.GetShowImageViewerStatusBar: boolean;
begin
  GetF<boolean>(FShowImageViewerStatusBar, Result);
end;

function TNsfwBoxSettings.GetShowNavigateBackButton: boolean;
begin
  GetF<boolean>(FShowNavigateBackButton, Result);
end;

function TNsfwBoxSettings.GetShowScrollBars: boolean;
begin
  GetF<boolean>(FShowScrollBars, Result);
end;

function TNsfwBoxSettings.GetStyleName: string;
begin
  GetF<string>(FStyleName, Result);
end;

function TNsfwBoxSettings.GetThreadsCount: integer;
begin
  GetF<integer>(FThreadsCount, Result);
end;

function TNsfwBoxSettings.GetYDWSyncLoadFromFile: boolean;
begin
  GetF<boolean>(FYDWSyncLoadFromFile, Result);
end;

procedure TNsfwBoxSettings.SetSaveDownloadHistory(const Value: boolean);
begin
  SetF<boolean>(FSaveDownloadHistory, Value);
end;

procedure TNsfwBoxSettings.SetAllowCookies(const Value: boolean);
begin
  SetF<boolean>(FAllowCookies, Value);
end;

procedure TNsfwBoxSettings.SetAllowDuplicateTabs(const Value: boolean);
begin
  SetF<boolean>(FAllowDuplicateTabs, Value);
end;

procedure TNsfwBoxSettings.SetAttribute(AName: string; const Value: variant);
var
  Context: TRttiContext;
  Instance: TRttiInstanceType;
  LProperty: TRttiProperty;
  LValue: TValue;
begin
  Context := TRttiContext.Create;
  try
    Instance := Context.GetType(TNsfwBoxSettings).AsInstance;
    LProperty := Instance.GetProperty(AName);
    if Assigned(LProperty) then
    begin
      case LProperty.PropertyType.TypeKind of
        tkInteger:
        begin
          LValue := TValue.From<Integer>(StrToInt(VarToStr(Value)))
        end;

        tkFloat:
        begin
          LValue := TValue.From<Extended>(StrToFloat(VarToStr(Value)))
        end;

        else LValue := TValue.FromVariant(Value);
      end;
      LProperty.SetValue(Self, LValue);
    end;
  finally
    Context.Free;
  end;
end;

procedure TNsfwBoxSettings.SetAutoAcceptAllCertificates(const Value: boolean);
begin
  SetF<boolean>(FAutoAcceptAllCertificates, Value);
end;

procedure TNsfwBoxSettings.SetAutoCheckUpdates(const Value: boolean);
begin
  SetF<boolean>(FAutoCheckUpdates, Value);
end;

procedure TNsfwBoxSettings.SetAutoCloseItemMenu(const Value: boolean);
begin
  SetF<boolean>(FAutoCloseItemMenu, Value);
end;

procedure TNsfwBoxSettings.SetAutoSaveSession(const Value: boolean);
begin
  SetF<boolean>(FAutoSaveSession, Value);
end;

procedure TNsfwBoxSettings.SetAutoStartBrowse(const Value: boolean);
begin
  SetF<boolean>(FAutoStartBrowse, Value);
end;

procedure TNsfwBoxSettings.SetBrowseNextPageByScrollDown(const Value: boolean);
begin
  SetF<boolean>(FBrowseNextPageByScrollDown, Value);
end;

procedure TNsfwBoxSettings.SetContentLayoutsCount(const Value: integer);
begin
  SetF<integer>(FContentLayoutsCount, Value);
end;

procedure TNsfwBoxSettings.SetDefaultBackupPath(const Value: string);
begin
  SetF<string>(FDefaultBackupPath, Value);
end;

procedure TNsfwBoxSettings.SetDefaultUseragent(const Value: string);
begin
  SetF<string>(FDefaultUseragent, Value);
end;

procedure TNsfwBoxSettings.SetDefDownloadPath(const Value: string);
begin
  SetF<string>(FDefDownloadPath, Value);
end;

procedure TNsfwBoxSettings.SetDevMode(const Value: boolean);
begin
  SetF<boolean>(FDevMode, Value);
end;

procedure TNsfwBoxSettings.SetDownloadAllMode(const Value: TDownloadAllMode);
begin
  SetF<TDownloadAllMode>(FDownloadAllMode, Value);
end;

procedure TNsfwBoxSettings.SetEnableAllContent(const Value: boolean);
begin
  SetF<boolean>(FEnableAllContent, Value);
end;

procedure TNsfwBoxSettings.SetF<T>(var AVariable: T; const ANewValue: T);
begin
  FLock.BeginWrite;
  try
    AVariable := ANewValue;
  finally
    FLock.EndWrite;
  end;
end;

procedure TNsfwBoxSettings.SetFetchAllBeforeAddBookmark(const Value: boolean);
begin
  SetF<boolean>(FFetchAllBeforeAddBookmark, Value);
end;

procedure TNsfwBoxSettings.SetFilenameLogUrls(const Value: string);
begin
  SetF<string>(FFilenameLogUrls, Value);
end;

procedure TNsfwBoxSettings.SetFullscreen(const Value: boolean);
begin
  SetF<boolean>(FFullscreen, Value);
end;

procedure TNsfwBoxSettings.SetImageCacheLoad(const Value: boolean);
begin
  SetF<boolean>(FImageCacheLoad, Value);
end;

procedure TNsfwBoxSettings.SetImageCacheSave(const Value: boolean);
begin
  SetF<boolean>(FImageCacheSave, Value);
end;

procedure TNsfwBoxSettings.SetItemIndent(const Value: single);
begin
  SetF<single>(FItemIndent, Value);
end;

procedure TNsfwBoxSettings.SetItemInteractions(
  const Value: TNBoxItemInteractions);
begin
  FLock.BeginWrite;
  try
    FItemInteractions := Copy(Value);
  finally
    FLock.EndWrite;
  end;
end;

procedure TNsfwBoxSettings.SetMaxDownloadThreads(const Value: integer);
begin
  SetF<integer>(FMaxDownloadThreads, Value);
end;

procedure TNsfwBoxSettings.SetMaxTabsAtStartup(const Value: integer);
begin
  SetF<integer>(FMaxTabsAtStartup, Value);
end;

procedure TNsfwBoxSettings.SetPlayExterWhenCantInter(const Value: boolean);
begin
  SetF<boolean>(FPlayExterWhenCantInter, Value);
end;

procedure TNsfwBoxSettings.SetSaveClosedTabHistory(const Value: boolean);
begin
  SetF<boolean>(FSaveClosedTabHistory, Value);
end;

procedure TNsfwBoxSettings.SetSaveSearchHistory(const Value: boolean);
begin
  SetF<boolean>(FSaveSearchHistory, Value);
end;

procedure TNsfwBoxSettings.SetSaveTapHistory(const Value: boolean);
begin
  SetF<boolean>(FSaveTapHistory, Value);
end;

procedure TNsfwBoxSettings.SetSemVer(const Value: TSemVer);
begin
  SetF<TSemVer>(FSemVer, Value);
end;

procedure TNsfwBoxSettings.SetShowBrowserStatusBar(const Value: boolean);
begin
  SetF<boolean>(FShowBrowserStatusBar, Value);
end;

procedure TNsfwBoxSettings.SetShowCaptions(const Value: boolean);
begin
  SetF<boolean>(FShowCaptions, Value);
end;

procedure TNsfwBoxSettings.SetShowImageViewerStatusBar(const Value: boolean);
begin
  SetF<boolean>(FShowImageViewerStatusBar, Value);
end;

procedure TNsfwBoxSettings.SetShowNavigateBackButton(const Value: boolean);
begin
  SetF<boolean>(FShowNavigateBackButton, Value);
end;

procedure TNsfwBoxSettings.SetShowScrollBars(const Value: boolean);
begin
  SetF<boolean>(FShowScrollBars, Value);
end;

procedure TNsfwBoxSettings.SetStyleName(const Value: string);
begin
  SetF<string>(FStyleName, Value);
end;

procedure TNsfwBoxSettings.SetThreadsCount(const Value: integer);
begin
  SetF<integer>(FThreadsCount, Value);
end;

procedure TNsfwBoxSettings.SetYDWSyncLoadFromFile(const Value: boolean);
begin
  SetF<boolean>(FYDWSyncLoadFromFile, Value);
end;

function TNsfwBoxSettings.ToJsonStr: String;
var
  X: ISuperObject;
  A: ISuperArray;
  I: integer;
begin
  X := Self.AsJSONObject;
  with FBookmarksOrder.LockList do
  begin
    try
      A := TJson.SuperObject<TInt64Ar>(ToArray).AsArray;
    Finally
      FBookmarksOrder.UnlockList;
    End;
  end;
  X.A['BookmarksOrder'] := A;
  Result := X.AsJSON(True);
end;

end.

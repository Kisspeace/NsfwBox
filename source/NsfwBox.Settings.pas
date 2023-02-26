{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Settings;

interface
uses
  Classes, XSuperObject, system.Generics.Collections, NsfwBox.UpdateChecker;

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

  TNsfwBoxSettings = class
    SemVer: TSemVer;
    DefaultUseragent: string;
    AllowCookies: boolean;
    DefDownloadPath: string;
    StyleName: string;
    ThreadsCount: integer;
    ContentLayoutsCount: integer;
    ItemIndent: single;
    Fullscreen: boolean;
    AutoSaveSession: boolean;
    SaveSearchHistory: boolean;
    SaveDownloadHistory: boolean;
    SaveTapHistory: boolean;
    SaveClosedTabHistory: boolean;
    BrowseNextPageByScrollDown: boolean;
    ImageCacheSave: boolean;
    ImageCacheLoad: boolean;
    AutoAcceptAllCertificates: boolean;
    YDWSyncLoadFromFile: boolean;
    ShowCaptions: boolean;
    MaxDownloadThreads: integer;
    AutoStartBrowse: boolean;
    AllowDuplicateTabs: boolean;
    AutoCloseItemMenu: boolean;
    ItemInteractions: TNBoxItemInteractions;
    FilenameLogUrls: string;
    DevMode: boolean;
    AutoCheckUpdates: boolean;
    ShowScrollBars: boolean;
    ShowNavigateBackButton: boolean;
    EnableAllContent: boolean;
    FetchAllBeforeAddBookmark: boolean;
    {$IFDEF MSWINDOWS}
      UseNewAppTitlebar: boolean;
      ContentPlayApp: string;
      ContentPlayParams: string;
    {$ENDIF}
    procedure Assign(ASource: TNsfwBoxSettings);
    constructor Create;
  end;


implementation


{ TNsfwBoxSettings }

procedure TNsfwBoxSettings.Assign(ASource: TNsfwBoxSettings);
begin
  Self.AssignFromJSON(ASource.AsJSONObject);
end;

constructor TNsfwBoxSettings.Create;
begin
  SemVer := TSemVer.Create(0, 0, 0);
  DevMode                := false;
  DefDownloadPath        := '';
  DefaultUserAgent       := '';
  FilenameLogUrls        := '';
  StyleName              := 'default.json';
  AllowCookies           := false;
  ThreadsCount           := 6;
  ContentLayoutsCount    := 2;
  MaxDownloadThreads     := 4;
  ItemIndent             := 2;
  AutoSaveSession        := true;
  SaveSearchHistory      := true;
  SaveDownloadHistory    := true;
  SaveClosedTabHistory   := true;
  SaveTapHistory         := false;
  BrowseNextPageByScrollDown := True;
  ShowCaptions           := true;
  AutoStartBrowse        := false;
  AllowDuplicateTabs     := true;
  AutoCloseItemMenu      := true;
  ItemInteractions       := [ ACTION_OPEN_MENU ];
  AutoCheckUpdates       := true;
  ShowScrollBars         := true;
  ShowNavigateBackButton := True;
  EnableAllContent       := True;
  FetchAllBeforeAddBookmark := False;
  {$IFDEF MSWINDOWS}
    ShowScrollBars       := false;
    ContentPlayApp       := 'C:\Program Files\VideoLAN\VLC\vlc.exe';
    ContentPlayParams    := '"' + FORMAT_VAR_CONTENT_URL + '"';
    UseNewAppTitlebar    := True;
    FullScreen           := False;
  {$ELSE IF ANDROID}
    Fullscreen           := True;
  {$ENDIF}
  ImageCacheSave := True;
  ImageCacheLoad := True;
  AutoAcceptAllCertificates := False;
  YDWSyncLoadFromFile := False;
end;

end.

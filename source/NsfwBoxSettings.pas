//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxSettings;

interface
uses
  Classes, XSuperObject, system.Generics.Collections;

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
  ACTION_DOWNLOAD_MENU      = 14;

  FORMAT_VAR_CONTENT_URL = '$(NSFWBOX_CONTENT_URL)';

type

  TNBoxItemInteraction = NativeInt;

  TNBoxItemInteractions = TArray<TNBoxItemInteraction>;

  TNsfwBoxSettings = class
    Version: integer;
    DefaultUseragent: string;
    AllowCookies: boolean;
    DefDownloadPath: string;
    StyleName: string;
    ThreadsCount: integer;
    ContentLayoutsCount: integer;
    ItemIndent: single;
    //Language: string;
    Fullscreen: boolean;
    AutoSaveSession: boolean;
    SaveSearchHistory: boolean;
    SaveDownloadHistory: boolean;
    SaveTapHistory: boolean;
    SaveClosedTabHistory: boolean;
    //HighlightsDownloaded: boolean;
    ShowCaptions: boolean;
    //AutoRenameExistsFile: boolean;
    //DownloadDuplicates: boolean;
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
    {$IFDEF MSWINDOWS}
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
  Version                := 5;
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
  //Language               := 'EN';
  AutoSaveSession        := true;
  SaveSearchHistory      := true;
  SaveDownloadHistory    := true;
  SaveClosedTabHistory   := true;
  SaveTapHistory         := false;
  Fullscreen             := true;
  //HighlightsDownloaded   := false;
  ShowCaptions           := true;
  //AutoRenameExistsFile   := false;
  //DownloadDuplicates     := false;
  AutoStartBrowse        := false;
  AllowDuplicateTabs     := true;
  AutoCloseItemMenu      := true;
  ItemInteractions       := [ ACTION_OPEN_MENU ];
  AutoCheckUpdates       := true;
  ShowScrollBars         := true;
  ShowNavigateBackButton := True;
  {$IFDEF MSWINDOWS}
    ShowScrollBars       := false;
    ContentPlayApp := 'C:\Program Files\VideoLAN\VLC\vlc.exe';
    ContentPlayParams := '"' + FORMAT_VAR_CONTENT_URL + '"';
  {$ENDIF}
end;

end.

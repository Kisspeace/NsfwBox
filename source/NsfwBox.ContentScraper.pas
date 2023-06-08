{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.ContentScraper;

interface

uses
  System.SysUtils, System.Generics.Collections,
  R34App.Types,
  Nethttp.R34JsonApi, R34JsonApi.Types, Nethttp.Scraper.NsfwXxx,
  NsfwXxx.Types, givemeporn.club.Types, givemeporn.club.Scraper,
  NineHentaito.APITypes, NineHentaito.API, Net.HttpClientComponent,
  NsfwBox.Interfaces, NsfwBox.Provider.NsfwXxx, NsfwBox.Provider.R34JsonApi,
  NsfwBox.Provider.Pseudo, NsfwBox.Provider.R34App,
  NsfwBox.Provider.GivemepornClub, NsfwBox.Provider.NineHentaiToApi,
  NsfwBox.Provider.CoomerParty, CoomerParty.HTMLParser, CoomerParty.Scraper,
  CoomerParty.Types, motherless.Types, motherless.Scraper,
  NsfwBox.Provider.motherless, NsfwBox.Provider.Randomizer,
  NsfwBox.Consts, NsfwBox.Bookmarks, NsfwBox.Provider.Bookmarks,
  IoUtils, NsfwBox.FileSystem, System.Classes, System.SyncObjs,
  NsfwBox.Helper, System.Math, YDW.Threading, NsfwBox.Logging,
  NsfwBox.Provider.Fapello, Fapello.Types, Fapello.Scraper,
  BooruScraper.Interfaces, BooruScraper.Client.CompatibleGelbooru,
  BooruScraper.Parser.rule34xxx, BooruScraper.Parser.gelbooru,
  BooruScraper.Parser.Realbooru, BooruScraper.Parser.rule34us,
  BooruScraper.Client.rule34us,
  BooruScraper.Client.rule34PahealNet,
  BooruScraper.Parser.rule34PahealNet,
  BooruScraper.Urls, BooruScraper.ClientBase, BooruScraper,
  NsfwBox.Provider.BooruScraper, NsfwBox.Utils,
  BooruScraper.Client.BepisDb,
  NsfwBox.Provider.BepisDb;

const
  REGULAR_BMRKDB: string = '<BOOKMARKS>';
  HISTORY_BMRKDB: string = '<HISTORY>';

type
  TWebClientSetEvent = procedure(Sender: TObject; AWebClient: TNetHttpClient;
    AOrigin: integer) of object;
  TINBoxItemEvent = procedure(Sender: TObject; var AItem: INBoxItem) of object;

  TNBoxScraper = class(TObject)
  private
    FOnWebClientSet: TWebClientSetEvent;
    procedure SyncWebClientSet(AClient: TNetHttpClient; AOrigin: integer);
    procedure UploadItems(A: TNsfwXXXItemList; AList: INBoxHasOriginList);
    function GetContentPseudo(AList: INBoxHasOriginList;
      ARequest: string): boolean;
    function GetContentNsfwXxx(AList: INBoxHasOriginList; AReqParam: string;
      ASearchType: TNsfwUrlType; APageNum: integer; Asort: TnsfwSort;
      ATypes: TNsfwItemTypes; AOrientations: TNsfwOris;
      ASite: TNsfwXxxSite): boolean;
    function GetContentR34JsonApi(AList: INBoxHasOriginList; ATags: string = '';
      APageId: integer = 1; ALimit: integer = 20): boolean;
    // function GetContentR34App(AList: INBoxHasOriginList; ATags: string; APageId: integer; ALimit: integer; ABooru: TR34AppFreeBooru): boolean;
    function GetContentGmpClub(AList: INBoxHasOriginList; AReqParam: string;
      ASearchType: TGmpClubSearchType; APageNum: integer): boolean;
    function GetContent9Hentaito(AList: INBoxHasOriginList;
      const ASearch: T9HentaiBookSearchRec): boolean;
    function GetContentCoomerParty(AList: INBoxHasOriginList; ASite: string;
      ARequest, AUserId, AService: string; APageNum: integer): boolean;
    function GetContentMotherless(AList: INBoxHasOriginList; ARequest: string;
      APage: integer; AMediaType: TMotherlessMediaType; Asort: TMotherLessSort;
      ASize: TMotherlessMediaSize; AUploadDate: TMotherLessUploadDate): boolean;
    function GetContentFapello(AList: INBoxHasOriginList; ARequest: string;
      APageNum: integer; ASearchType: TFapelloItemKind): boolean;
    function GetContentBooruScraper(ABooruClient: IBooruClient;
      AProviderId: integer;
      AList: INBoxHasOriginList; ARequest: string;
      APageNum: integer): boolean;
    function GetContentBookmarks(AList: INBoxHasOriginList; ADbPath: string;
      ABookmarksListId: int64; APageId: integer = 1): boolean;
    { ------------------------------------- }
    function GetContentRandomizer(AList: INBoxHasOriginList;
      AProviders: TArray<integer>): boolean;
  public
    BookmarksDb: TNBoxBookmarksDb;
    HistoryDb: TNBoxBookmarksDb;
    procedure FetchContentUrls(APost: INBoxItem);
    procedure FetchTags(APost: INBoxItem);
    procedure FetchAuthors(APost: INBoxItem);
    function TryFetchContentUrls(APost: INBoxItem): boolean;
    function TryFetchTags(APost: INBoxItem): boolean;
    function TryFetchAuthors(APost: INBoxItem): boolean;
    function GetContent(ARequest: INBoxSearchRequest; AList: INBoxHasOriginList): boolean;
    property OnWebClientSet: TWebClientSetEvent read FOnWebClientSet
      write FOnWebClientSet;
    constructor Create;
    destructor Destroy; override;
  end;

  TNBoxFetchManager = Class(TGenericYDWQueuedThreadInterface<INBoxItem>)
  private
    FOnWebClientSet: TWebClientSetEvent;
    FOnFetched: TINBoxItemEvent;
    function GetPushToQueueEndOnFail: boolean;
    procedure SetPushToQueueEndOnFail(const value: boolean);
  protected
    FPushToQueueEndOnFail: boolean;
    procedure SubThreadExecute(AItem: INBoxItem); override;
  public
    property PushToQueueEndOnFail: boolean read GetPushToQueueEndOnFail write SetPushToQueueEndOnFail;
    property OnFetched: TINBoxItemEvent read FOnFetched write FOnFetched;
    property OnWebClientSet: TWebClientSetEvent read FOnWebClientSet write FOnWebClientSet;
    procedure Add(AItem: INBoxItem);
    constructor Create; override;
  End;

implementation

uses unit1;

{ TNBoxScraper }
constructor TNBoxScraper.Create;
begin
  FOnWebClientSet := Nil;
  BookmarksDb := Nil;
  HistoryDb := Nil;
end;

destructor TNBoxScraper.Destroy;
begin
  if Assigned(BookmarksDb) then BookmarksDb.Free;
  if Assigned(HistoryDb) then HistoryDb.Free;
  Inherited;
end;

procedure TNBoxScraper.FetchAuthors(APost: INBoxItem);
begin
  Self.FetchTags(APost);
end;

procedure TNBoxScraper.FetchContentUrls(APost: INBoxItem);
begin
  if (APost is TNBoxNsfwXxxItem) then
  begin
    var
      Client: TNsfwXxxScraper;
    var
      Item: TNBoxNsfwXxxItem;
    Item := (APost as TNBoxNsfwXxxItem);
    Client := TNsfwXxxScraper.Create;
    SyncWebClientSet(Client.WebClient, APost.Origin);
    try
      Item.Page := Client.GetPage(Item.Item.PostUrl);
    finally
      Client.Free;
    end;
  end
  else if (APost is TNBoxGmpClubItem) then
  begin
    var
      Client: TGmpClubScraper;
    var
      Item: TNBoxGmpClubItem;
    Item := (APost as TNBoxGmpClubItem);
    Client := TGmpClubScraper.Create;
    SyncWebClientSet(Client.WebClient, APost.Origin);
    try
      Item.Page := Client.GetPage(Item.Item.GetUrl, false);
    finally
      Client.Free;
    end;
  end
  else if (APost is TNBoxCoomerPartyItem) then
  begin
    var
      Client: TCoomerPartyScraper;
    var
      Item: TNBoxCoomerPartyItem;
    Item := (APost as TNBoxCoomerPartyItem);
    Client := TCoomerPartyScraper.Create;
    Client.Host := Item.Site;
    SyncWebClientSet(Client.Client, APost.Origin);
    try
      Item.Item := Client.GetPost(Item.Item.Author, Item.UIdInt);
    finally
      Client.Free;
    end;
  end
  else if (APost is TNBoxMotherlessItem) then
  begin
    var
    LClient := TMotherlessScraper.Create;
    var
    LItem := (APost as TNBoxMotherlessItem);
    SyncWebClientSet(LClient.WebClient, APost.Origin);
    try
      var
        LPage: TMotherlessPostPage;
      LPage := LClient.FetchFullPost(LItem.Page.Item.GetPageUrl);
      var
      LTmpItem := LItem.Page.Item;
      LPage.Item := LTmpItem;
      LItem.Page := LPage;
    finally
      LClient.Free;
    end;
  end
  else if (APost is TNBoxFapelloItem) then
  begin
    var
    LItem := (APost As TNBoxFapelloItem);
    if LItem.Kind = FlFeed then
      Exit;
    var
    LClient := TFapelloScraper.Create;
    SyncWebClientSet(LClient.Client, APost.Origin);
    try
      var
      LFull := LClient.GetFullContent(LItem.ThumbItem);
      LItem.Full := LFull;
    finally
      LClient.Free;
    end;
  end
  else if (APost is TNBoxBooruItemBase) then
  begin

    var
    LItem := (APost as TNBoxBooruItemBase);
    var
      LClient: IBooruClient;

    case APost.Origin of
      PVR_GELBOORU: LClient := BooruScraper.NewClientGelbooru;
      PVR_REALBOORU: LClient := BooruScraper.NewClientRealbooru;
      PVR_RULE34XXX: LClient := BooruScraper.NewClientRule34xxx;
      PVR_RULE34US: LClient := BooruScraper.NewClientRule34us;
      PVR_RULE34PAHEALNET: LClient := BooruScraper.NewClientRule34PahealNet;
      PVR_XBOORU: LClient := BooruScraper.NewClientXbooru;
      PVR_HYPNOHUBNET: LClient := BooruScraper.NewClientHypnohubnet;
      PVR_TBIB: LClient := BooruScraper.NewClientTbib;
      PVR_DANBOORU: LClient := BooruScraper.NewClientDonmaiUs(True);
      PVR_ALLTHEFALLEN: LClient := BooruScraper.NewClientAllTheFallen(True);
      PVR_BLEACHBOORU: LClient := BooruScraper.NewClientBleachbooru(True);
      PVR_ILLUSIONCARDS: LClient := BooruScraper.NewClientIllusioncards;
      PVR_HGOONBOORU: LClient := BooruScraper.NewClientHgoon;
    end;

    if Assigned(LClient) then
    begin
      SyncWebClientSet(TBooruClientBase(LClient).Client, APost.Origin);
      var
      LFull := LClient.GetPost(LItem.Full);
      LItem.MergeFull(LFull);
    end;
  end;
end;

procedure TNBoxScraper.FetchTags(APost: INBoxItem);
begin
  Self.FetchContentUrls(APost);
end;

function TNBoxScraper.GetContent(ARequest: INBoxSearchRequest;
  AList: INBoxHasOriginList): boolean;
var
  RequestAsInt: int64;
begin
  Result := false;

  if not TryStrToInt64(ARequest.Request, RequestAsInt) then
    RequestAsInt := 1;

  case ARequest.Origin of

    ORIGIN_NSFWXXX:
    begin
      with (ARequest As TNBoxSearchReqNsfwXxx) do
      begin
        Result := GetContentNsfwXxx(AList, Request, SearchType, Pageid,
          SortType, Types, Oris, Site);
      end;
    end;

    ORIGIN_R34JSONAPI:
    begin
      Result := GetContentR34JsonApi(AList, ARequest.Request,
        ARequest.Pageid);
    end;

    ORIGIN_GIVEMEPORNCLUB:
    begin
      with (ARequest As TNBoxSearchReqGmpClub) do
      begin
        Result := GetContentGmpClub(AList, Request, SearchType, Pageid);
      end;
    end;

    ORIGIN_9HENTAITO:
    begin
      with (ARequest As TNBoxSearchReq9Hentaito) do
      begin
        Result := GetContent9Hentaito(AList, SearchRec);
      end;
    end;

    ORIGIN_COOMERPARTY:
    begin
      with (ARequest As TNBoxSearchReqCoomerParty) do
      begin
        Result := GetContentCoomerParty(AList, Site, Request, UserId,
          Service, Pageid);
      end;
    end;

    ORIGIN_MOTHERLESS:
    begin
      with (ARequest As TNBoxSearchReqMotherless) do
      begin
        Result := GetContentMotherless(AList, Request, Pageid,
          ContentType, Sort, MediaSize, UploadDate);
      end;
    end;

    ORIGIN_PSEUDO:
    begin
      Result := GetContentPseudo(AList, ARequest.Request);
    end;

    ORIGIN_BOOKMARKS:
    begin
      with (ARequest As TNBoxSearchReqBookmarks) do
      begin
        Result := GetContentBookmarks(AList, Path, RequestAsInt,
          ARequest.Pageid);
      end;
    end;

    ORIGIN_RANDOMIZER:
    begin
      with (ARequest as TNBoxSearchReqRandomizer) do
      begin
        Result := GetContentRandomizer(AList, Providers);
      end;
    end;

    PVR_FAPELLO:
    begin
      with (ARequest as TNBoxSearchReqFapello) do
      begin
        Result := GetContentFapello(AList, Request, Pageid, RequestKind);
      end;
    end;

    PVR_GELBOORU:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientGelbooru,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_RULE34XXX:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientRule34xxx,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_REALBOORU:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientRealbooru,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_RULE34US:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientRule34us,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_RULE34PAHEALNET:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientRule34PahealNet,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_XBOORU:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientXbooru,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_HYPNOHUBNET:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientHypnohubnet,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_TBIB:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientTbib,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_DANBOORU:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientDonmaiUs(True),
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_ALLTHEFALLEN:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientAllTheFallen(True),
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_BLEACHBOORU:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientBleachbooru(True),
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_ILLUSIONCARDS:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientIllusioncards,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_HGOONBOORU:
    begin
      Result := GetContentBooruScraper(BooruScraper.NewClientHgoon,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

    PVR_BEPISDB:
    begin
      var LClient := BooruScraper.NewClientBepisDb As IBepisDbClient;
      var LReq := (ARequest as TNBoxSearchReqBepisDb);
      LClient.SearchOptions := LReq.SearchOpt;
      Result := GetContentBooruScraper(LClient,
        ARequest.Origin, AList, ARequest.Request, ARequest.PageId);
    end;

  end;
end;

function TNBoxScraper.GetContent9Hentaito(AList: INBoxHasOriginList;
  const ASearch: T9HentaiBookSearchRec): boolean;
var
  Client: T9HentaiClient;
  i: integer;
  Content: T9HentaiBookAr;
begin
  Result := false;
  Client := T9HentaiClient.Create;
  try
    SyncWebClientSet(Client.WebClient, ORIGIN_9HENTAITO);
    Content := Client.GetBook(ASearch);
    Result := (length(Content) > 0);
    for i := 0 to high(Content) do
    begin
      var
        Item: TNBox9HentaitoItem;
      Item := TNBox9HentaitoItem.Create(false);
      Item.Item := Content[i];
      AList.Add(Item);
    end;
  finally
    Client.Free;
  end;
end;

function TNBoxScraper.GetContentGmpClub(AList: INBoxHasOriginList;
  AReqParam: string; ASearchType: TGmpClubSearchType;
  APageNum: integer): boolean;
var
  Client: TGmpClubScraper;
  i: integer;
  Content: TGmpclubItemAr;
begin
  Result := false;
  Client := TGmpClubScraper.Create;
  try
    SyncWebClientSet(Client.WebClient, ORIGIN_GIVEMEPORNCLUB);
    case ASearchType of
      TGmpClubSearchType.Empty:
        begin
          Content := Client.GetItems(APageNum);
        end;
      TGmpClubSearchType.Random:
        begin
          Content := Client.GetRandomItems;
        end;
      TGmpClubSearchType.Tag:
        begin
          Content := Client.GetItemsByTag(AReqParam, APageNum);
        end;
      TGmpClubSearchType.Category:
        begin
          Content := Client.GetItemsByCategory(AReqParam, APageNum);
        end;
    end;
    Result := (length(Content) > 0);
    for i := 0 to high(Content) do
    begin
      var
        Item: TNBoxGmpClubItem;
      Item := TNBoxGmpClubItem.Create;
      Item.Item := Content[i];
      AList.Add(Item);
    end;
  finally
    Client.Free;
  end;
end;

function TNBoxScraper.GetContentMotherless(AList: INBoxHasOriginList;
  ARequest: string; APage: integer; AMediaType: TMotherlessMediaType;
  Asort: TMotherLessSort; ASize: TMotherlessMediaSize;
  AUploadDate: TMotherLessUploadDate): boolean;
var
  LClient: TMotherlessScraper;
  LContent: TMotherlessItemAr;
  i: integer;
begin
  Result := false;
  LClient := TMotherlessScraper.Create;
  try
    SyncWebClientSet(LClient.WebClient, ORIGIN_MOTHERLESS);
    LContent := LClient.Search(ARequest, APage, AMediaType, Asort, ASize,
      AUploadDate);
    Result := (length(LContent) > 0);
    for i := 0 to High(LContent) do
    begin
      var
      Item := TNBoxMotherlessItem.Create;
      var
      LTmp := Item.Page;
      LTmp.Item := LContent[i];
      Item.Page := LTmp;
      AList.Add(Item);
    end;
  finally
    LContent := nil;
    LClient.Free;
  end;
end;

function TNBoxScraper.GetContentBookmarks(AList: INBoxHasOriginList;
  ADbPath: string; ABookmarksListId: int64; APageId: integer): boolean;
var
  I: integer;
  Bookmarks: TBookmarkAr;
  TargetDb: TNBoxBookmarksDb;
begin
  Result := false;
  try
    if (ADbPath = REGULAR_BMRKDB) or ADbPath.IsEmpty then
      TargetDb := BookmarksDb
    else if (ADbPath = HISTORY_BMRKDB) then
      TargetDb := HistoryDb;

    if not Assigned(TargetDb) then Exit;

    Bookmarks := TargetDb.GetPage(ABookmarksListId, APageId);
    for I := low(Bookmarks) to high(Bookmarks) do
      AList.Add(Bookmarks[I]);

    Result := (Length(Bookmarks) > 0);
    Bookmarks := nil;
  except
    On E: exception do
      Log('TNBoxScraper.GetContentBookmarks', E);
  end;
end;

function TNBoxScraper.GetContentBooruScraper(ABooruClient: IBooruClient;
  AProviderId: integer; AList: INBoxHasOriginList;
  ARequest: string; APageNum: integer): boolean;
var
  i: integer;
  LContent: TBooruThumbAr;
  LContentSwitch: IEnableAllContent;
begin
  Result := false;

  if Supports(ABooruClient, IEnableAllContent, LContentSwitch) then
    LContentSwitch.EnableAllContent := Form1.Settings.EnableAllContent;

  with TBooruClientBase(ABooruClient) do
    SyncWebClientSet(Client, AProviderId);

  LContent := ABooruClient.GetPosts(ARequest, APageNum);
  Result := (length(LContent) > 0);

  for i := 0 to high(LContent) do
  begin
    var
    LItem := TNBoxBooruItemBase.Create(AProviderId);
    LItem.Full.Assign(LContent[I]);
    AList.Add(LItem);
  end;
end;

function TNBoxScraper.GetContentCoomerParty(AList: INBoxHasOriginList;
  ASite: string; ARequest, AUserId, AService: string;
  APageNum: integer): boolean;
var
  Client: TCoomerPartyScraper;
  i: integer;
  Content: TPartyPostsPage;
begin
  Result := false;
  Client := TCoomerPartyScraper.Create;
  Client.Host := ASite;
  try
    SyncWebClientSet(Client.Client, ORIGIN_COOMERPARTY);
    if (Trim(AUserId).IsEmpty or Trim(AService).IsEmpty) then
    begin
      // Search by recent posts
      Content := Client.GetRecentPostsByPageNum(ARequest, APageNum);
    end
    else
    begin
      // Search by artist posts
      Content := Client.GetArtistPostsByPageNum(ARequest, AUserId, AService,
        APageNum);
    end;
    Result := (length(Content.Posts) > 0);
    for i := 0 to High(Content.Posts) do
    begin
      var
        Item: TNBoxCoomerPartyItem;
      Item := TNBoxCoomerPartyItem.Create;
      Item.Site := Client.Host;
      Item.UIdInt := Content.Posts[i].Id;
      Item.Item := TPartyPostToTPartyPostPage(Content.Posts[i]);
      AList.Add(Item);
    end;
  finally
    Client.Free;
  end;
end;

function TNBoxScraper.GetContentFapello(AList: INBoxHasOriginList;
  ARequest: string; APageNum: integer; ASearchType: TFapelloItemKind): boolean;
var
  Client: TFapelloScraper;
  i: integer;
begin
  Result := false;
  Client := TFapelloScraper.Create;
  try
    SyncWebClientSet(Client.Client, Providers.Fapello.Id);
    case ASearchType of
      FlFeed:
        begin
          var
          LContent := Client.GetFeedItems(APageNum);
          Result := (length(LContent) > 0);
          for i := 0 to High(LContent) do
          begin
            var
            LItem := TNBoxFapelloItem.Create;
            LItem.Kind := FlFeed;
            LItem.FeedItem := LContent[i];
            AList.Add(LItem);
          end;
        end;
      FlThumb:
        begin
          var
          LContent := Client.GetAuthorContent(ARequest, APageNum);
          Result := (length(LContent) > 0);
          for i := 0 to High(LContent) do
          begin
            var
            LItem := TNBoxFapelloItem.Create;
            var
            LFeedItem := TFapelloFeedItem.New;
            LFeedItem.Author.Username := ARequest;
            LItem.Kind := FlThumb;
            LItem.FeedItem := LFeedItem;
            LItem.ThumbItem := LContent[i];
            AList.Add(LItem);
          end;
        end;
    end;
  finally
    Client.Free;
  end;
end;

function TNBoxScraper.GetContentPseudo(AList: INBoxHasOriginList;
  ARequest: string): boolean;
var
  i, C: integer;
  Files: TSearchRecAr;
begin
  C := AList.Count;
  Files := GetFiles(ARequest);
  for i := Low(Files) to High(Files) do
  begin
    if Files[i].Attr = faDirectory then
      continue;
    var
      Item: TNBoxPseudoItem;
    Item := TNBoxPseudoItem.Create;
    Item.ThumbnailUrl := IoUtils.TPath.Combine(TPath.GetDirectoryName(ARequest),
      Files[i].Name);
    AList.Add(Item);
  end;
  Result := (AList.Count > C);
end;

function TNBoxScraper.GetContentR34JsonApi(AList: INBoxHasOriginList;
  ATags: string; APageId, ALimit: integer): boolean;
var
  Client: TR34Client;
  i: integer;
  Content: TR34Items;
begin
  Result := false;
  Client := TR34Client.Create;
  Content := nil;
  try
    SyncWebClientSet(Client.WebClient, ORIGIN_R34JSONAPI);
    Content := Client.GetPosts(ATags, APageId, ALimit);
    Result := (length(Content) > 0);
    for i := 0 to length(Content) - 1 do
    begin
      var
        Item: TNBoxR34JsonApiItem;
      Item := TNBoxR34JsonApiItem.Create;
      Item.Item := Content[i];
      AList.Add(Item);
    end;
  finally
    Client.Free;
  end;
end;

function TNBoxScraper.GetContentRandomizer(AList: INBoxHasOriginList;
  AProviders: TArray<integer>): boolean;
var
  LProvider: integer;
  LRequest: INBoxSearchRequest;
begin
  Result := false;
  Randomize;

  if (length(AProviders) < 1) then Exit;

  LProvider := System.Math.RandomFrom(AProviders);
  LRequest := CreateReqByOrigin(LProvider);

  if (LRequest is TNBoxSearchReqNsfwXxx) then
  begin
    LRequest.Pageid := RandomRange(1, 50);
  end
  else if (LRequest.Origin in [Providers.R34App.Id, Providers.rule34xxx.Id,
    Providers.gelbooru.Id, Providers.rule34PahealNet.Id, Providers.XBooru.Id])
  then
  begin
    LRequest.Pageid := RandomRange(0, 1000);
  end
  else if (LRequest is TNBoxSearchReqGmpClub) then
  begin
    TNBoxSearchReqGmpClub(LRequest).SearchType := TGmpClubSearchType.Random
  end
  else if (LRequest is TNBoxSearchReqCoomerParty) then
  begin
    TNBoxSearchReqCoomerParty(LRequest).Pageid := RandomRange(0, 173628);
    TNBoxSearchReqCoomerParty(LRequest).Site :=
      CoomerParty.Scraper.URL_COOMER_PARTY;
  end
  else if (LRequest is TNBoxSearchReqMotherless) then
  begin
    LRequest.Pageid := RandomRange(0, 1500);
    TNBoxSearchReqMotherless(LRequest).ContentType :=
      TMotherlessMediaType(RandomRange(0, 1));
    TNBoxSearchReqMotherless(LRequest).Sort :=
      TMotherLessSort(RandomRange(0, 8));
  end
  else if (LRequest is TNBoxSearchReq9Hentaito) then
  begin
    LRequest.Pageid := RandomRange(0, 5119);
  end;

  try
    Result := Self.GetContent(LRequest, AList);
  finally
    FreeInterfaced(LRequest);
  end;
end;

procedure TNBoxScraper.SyncWebClientSet(AClient: TNetHttpClient;
  AOrigin: integer);
begin
  if Not Assigned(Self.OnWebClientSet) then Exit;
  TThread.Synchronize(TThread.Current,
  procedure
  begin
    OnWebClientSet(Self, AClient, AOrigin);
  end);
end;

function TNBoxScraper.TryFetchAuthors(APost: INBoxItem): boolean;
begin
  try
    FetchAuthors(APost);
    Result := true;
  except
    Result := false;
  end;
end;

function TNBoxScraper.TryFetchContentUrls(APost: INBoxItem): boolean;
begin
  try
    FetchContentUrls(APost);
    Result := true;
  except
    Result := false;
  end;
end;

function TNBoxScraper.TryFetchTags(APost: INBoxItem): boolean;
begin
  Result := Self.TryFetchContentUrls(APost);
end;

function TNBoxScraper.GetContentNsfwXxx(AList: INBoxHasOriginList;
  AReqParam: string; ASearchType: TNsfwUrlType; APageNum: integer;
  Asort: TnsfwSort; ATypes: TNsfwItemTypes; AOrientations: TNsfwOris;
  ASite: TNsfwXxxSite): boolean;
var
  Client: TNsfwXxxScraper;
  Content: TNsfwXXXItemList;
begin
  Result := false;
  Client := TNsfwXxxScraper.Create;
  Client.Host := TNsfwXxxSiteToUrl(ASite);
  Content := TNsfwXXXItemList.Create;
  try
    SyncWebClientSet(Client.WebClient, ORIGIN_NSFWXXX);
    Result := Client.GetItems(Content, AReqParam, ASearchType, APageNum, Asort,
      ATypes, AOrientations);
    UploadItems(Content, AList);
  finally
    Client.Free;
    Content.Free;
  end;
end;

procedure TNBoxScraper.UploadItems(A: TNsfwXXXItemList;
AList: INBoxHasOriginList);
var
  i: integer;
  Item: TNBoxNsfwXxxItem;
begin
  for i := 0 to A.Count - 1 do
  begin
    Item := TNBoxNsfwXxxItem.Create;
    Item.Item := A.Items[i];
    AList.Add(Item);
  end;
end;

{ TNBoxFetchManager }
procedure TNBoxFetchManager.Add(AItem: INBoxItem);
begin
  QueueAdd(AItem);
end;

constructor TNBoxFetchManager.Create;
begin
  inherited;
  FPushToQueueEndOnFail := True;
end;

function TNBoxFetchManager.GetPushToQueueEndOnFail: boolean;
begin
  FLock.BeginRead;
  try
    Result := FPushToQueueEndOnFail;
  finally
    FLock.EndRead;
  end;
end;

procedure TNBoxFetchManager.SetPushToQueueEndOnFail(const value: boolean);
begin
  FLock.BeginWrite;
  try
    FPushToQueueEndOnFail := value;
  finally
    FLock.EndWrite;
  end;
end;

procedure TNBoxFetchManager.SubThreadExecute(AItem: INBoxItem);
var
  LScraper: TNBoxScraper;
begin
  try
    LScraper := TNBoxScraper.Create;
    try
      LScraper.OnWebClientSet := Self.OnWebClientSet;

      while not LScraper.TryFetchContentUrls(AItem) do
      begin
        if TThread.Current.CheckTerminated then exit;
        if PushToQueueEndOnFail then
        begin
          Self.Add(AItem);
          Exit;
        end;
      end;

      // Fetched
      if TThread.Current.CheckTerminated then exit;
      if (Assigned(Self.OnFetched)) then
        Self.OnFetched(Self, AItem);
    finally
      LScraper.Free;
    end;
  Except
    On E: Exception do
    begin
      Log('TNBoxFetchManager.SubThreadExecute', E)
    end;
  end;
end;

end.

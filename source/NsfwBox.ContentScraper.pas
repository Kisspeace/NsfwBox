{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.ContentScraper;

interface

uses
  System.SysUtils, System.Generics.Collections,
  NetHttp.R34AppApi, R34App.Types,
  Nethttp.R34JsonApi, R34JsonAPi.Types, NetHttp.Scraper.NsfwXxx,
  NsfwXxx.Types, givemeporn.club.types, givemeporn.club.scraper,
  NineHentaito.APITypes, NineHentaito.API, Net.HttpClientComponent,
  NsfwBox.Interfaces, NsfwBox.Provider.NsfwXxx, NsfwBox.Provider.R34JsonApi,
  NsfwBox.Provider.Pseudo, NsfwBox.Provider.R34App,
  NsfwBox.Provider.GivemepornClub, NsfwBox.Provider.NineHentaiToApi,
  NsfwBox.Provider.CoomerParty, CoomerParty.HTMLParser, CoomerParty.Scraper,
  CoomerParty.Types, motherless.types, motherless.scraper,
  NsfwBox.Provider.motherless, NsfwBox.Provider.Randomizer,
  NsfwBox.Consts, NsfwBox.Bookmarks, NsfwBox.Provider.Bookmarks,
  IoUtils, NsfwBox.FileSystem, System.Classes, system.SyncObjs,
  NsfwBox.Helper, System.Math, YDW.Threading, NsfwBox.Logging,
  NsfwBox.Provider.Fapello, Fapello.Types, Fapello.Scraper;

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
      function GetContentPseudo(AList: INBoxHasOriginList; ARequest: string ): boolean;
      function GetContentNsfwXxx(AList: INBoxHasOriginList; AReqParam: string; ASearchType: TNsfwUrlType; APageNum: integer; Asort: TnsfwSort; ATypes: TNsfwItemTypes; AOrientations: TNsfwOris; ASite: TNsfwXxxSite): boolean;
      function GetContentR34JsonApi(AList: INBoxHasOriginList; ATags: string = ''; APageId: integer = 1; ALimit: integer = 20): boolean;
      function GetContentR34App(AList: INBoxHasOriginList; ATags: string; APageId: integer; ALimit: integer; ABooru: TR34AppFreeBooru): boolean;
      function GetContentGmpClub(AList: INBoxHasOriginList; AReqParam: string; ASearchType: TGmpClubSearchType; APageNum: integer): boolean;
      function GetContent9Hentaito(AList: INBoxHasOriginList; const ASearch: T9HentaiBookSearchRec): boolean;
      function GetContentCoomerParty(AList: INBoxHasOriginList; ASite: string; ARequest, AUserId, AService: string; APageNum: integer): boolean;
      function GetContentMotherless(AList: INBoxHasOriginList; ARequest: string; APage: integer; AMediaType: TMotherlessMediaType; ASort: TMotherLessSort; ASize: TMotherlessMediaSize; AUploadDate: TMotherLessUploadDate): boolean;
      function GetContentFapello(AList: INBoxHasOriginList; ARequest: string; APageNum: integer; ASearchType: TFapelloItemKind): boolean;
      function GetContentBookmarks(AList: INBoxHasOriginList; ADbPath: string; ABookmarksListId: int64; APageId: integer = 1): boolean;
      { ------------------------------------- }
      function GetContentRandomizer(AList: INBoxHasOriginList; AProviders: TArray<integer>): boolean;
    public
      BookmarksDb: TNBoxBookmarksDb;
      HistoryDb: TNBoxBookmarksDb;
      procedure FetchContentUrls(var APost: INBoxItem);
      procedure FetchTags(var APost: INBoxItem);
      function TryFetchContentUrls(var APost: INBoxItem): boolean;
      function TryFetchTags(var APost: INBoxItem): boolean;
      function GetContent(ARequest: INBoxSearchRequest; AList: INBoxHasOriginList): boolean;
      property OnWebClientSet: TWebClientSetEvent read FOnWebClientSet write FOnWebClientSet;
      constructor Create;
  end;

  TNBoxFetchManager = Class(TGenericYDWQueuedThreadInterface<INBoxItem>)
    private
      FQueue: TList<INBoxItem>;
      FOnWebClientSet: TWebClientSetEvent;
      FOnFetched: TINBoxItemEvent;
    protected
      procedure SubThreadExecute(AItem: INBoxItem); override;
    public
      property OnFetched: TINBoxItemEvent read FOnFetched write FOnFetched;
      property OnWebClientSet: TWebClientSetEvent read FOnWebClientSet write FOnWebClientSet;
      procedure Add(AItem: INBoxItem);
      constructor Create; override;
      destructor Destroy; override;
  End;

implementation
uses unit1;
{ TNBoxScraper }

constructor TNBoxScraper.Create;
begin
  Self.FOnWebClientSet := nil;
  Self.BookmarksDb := nil;
end;

procedure TNBoxScraper.FetchContentUrls(var APost: INBoxItem);
begin
  //unit1.SyncLog('FetchContentUrls: ' + APost.Origin.ToString + ' ' + APost.ThumbnailUrl);
  if ( APost is TNBoxNsfwXxxItem ) then begin

    var Client: TNsfwXxxScraper;
    var Item: TNBoxNsfwXxxitem;

    Item := ( APost as TNBoxNsfwXxxitem );
    Client := TNsfwXxxScraper.Create;
    SyncWebClientSet(Client.WebClient, APost.Origin);

    try
      Item.Page := Client.GetPage(Item.Item.PostUrl);
    finally
      Client.Free;
    end;

  end else if ( APost is TNBoxGmpClubItem ) then begin

    var Client: TGmpClubScraper;
    var Item: TNBoxGmpClubItem;

    Item := ( APost as TNBoxGmpClubItem );
    Client := TGmpClubScraper.Create;
    SyncWebClientSet(Client.WebClient, APost.Origin);

    try
      Item.Page := Client.GetPage(Item.Item.GetUrl, false);
    finally
      Client.Free;
    end;

  end else if ( APost is TNBoxCoomerPartyItem ) then begin

    var Client: TCoomerPartyScraper;
    var Item: TNBoxCoomerPartyItem;

    Item := ( APost as TNBoxCoomerPartyItem );
    Client := TCoomerPartyScraper.Create;
    Client.Host := Item.Site;
    SyncWebClientSet(Client.Client, APost.Origin);

    try
      Item.Item := Client.GetPost(Item.Item.Author, Item.UIdInt);
    finally
      Client.Free;
    end;

  end else if ( APost is TNBoxMotherlessItem ) then begin

    var LClient := TMotherlessScraper.Create;
    var LItem := (APost as TNBoxMotherlessItem);
    SyncWebClientSet(LClient.WebClient, APost.Origin);

    try
      var LPage: TMotherlessPostPage;
      LPage := LClient.FetchFullPost(LItem.Page.Item.GetPageUrl);
      var LTmpItem := LItem.Page.Item;
      LPage.Item := LTmpItem;
      LItem.Page := LPage;
    finally
      LClient.Free;
    end;

  end else if ( APost is TNBoxFapelloItem ) then begin

    var LItem := ( APost As TNBoxFapelloItem );
    if Litem.Kind = FlFeed then
      Exit;

    var LClient := TFapelloScraper.Create;
    SyncWebClientSet(LClient.Client, APost.origin);

    try
      var LFull := LClient.GetFullContent(LItem.ThumbItem);
      LItem.Full := LFull;
    finally
      LClient.free;
    end;

  end;
end;

procedure TNBoxScraper.FetchTags(var APost: INBoxItem);
begin
  self.FetchContentUrls(APost);
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
      with ( ARequest As TNBoxSearchReqNsfwXxx ) do begin
        Result := Self.GetContentNsfwXxx
          ( AList,
            Request,
            SearchType,
            Pageid,
            SortType,
            Types,
            Oris,
            Site );
      end;
    end;

    ORIGIN_R34APP:
    begin
      with ( ARequest As TNBoxSearchReqR34App ) do begin
        Result := self.GetContentR34App
        ( AList,
          Request,
          PageId,
          20,
          Booru );
      end;
    end;

    ORIGIN_R34JSONAPI:
    begin
      Result := self.GetContentR34JsonApi
      ( AList,
        ARequest.Request,
        ARequest.PageId );
    end;

    ORIGIN_GIVEMEPORNCLUB:
    begin
      with ( ARequest As TNBoxSearchReqGmpClub ) do begin
        Result := Self.GetContentGmpClub
        ( AList,
          Request,
          SearchType,
          PageId );
      end;
    end;

    ORIGIN_9HENTAITO:
    begin
      with ( ARequest As TNBoxSearchReq9Hentaito ) do begin
        Result := Self.GetContent9Hentaito
        ( AList,
          SearchRec);
      end;
    end;

    ORIGIN_COOMERPARTY:
    begin
      with ( ARequest As TNBoxSearchReqCoomerParty ) do begin
        Result := Self.GetContentCoomerParty
        ( AList,
          Site,
          Request,
          UserId,
          Service,
          PageId
        );
      end;
    end;

    ORIGIN_MOTHERLESS:
    begin
      with ( ARequest As TNBoxSearchReqMotherless ) do begin
        Result := Self.GetContentMotherless
        ( AList,
          Request,
          PageId,
          ContentType,
          Sort,
          MediaSize,
          UploadDate
        );
      end;
    end;

    ORIGIN_PSEUDO:
    begin
      Result := Self.GetContentPseudo(AList, ARequest.Request);
    end;

    ORIGIN_BOOKMARKS:
    begin
      with ( ARequest As TNBoxSearchReqBookmarks ) do begin
        Result := Self.GetContentBookmarks(Alist, Path, RequestAsInt, ARequest.PageId);
      end;
    end;

    ORIGIN_RANDOMIZER:
    begin
      with ( ARequest as TNBoxSearchReqRandomizer ) do begin
        Result := Self.GetContentRandomizer(AList, Providers);
      end;
    end;

    PVR_FAPELLO:
    begin
      with ( ARequest as TNBoxSearchReqFapello ) do begin
        Result := Self.GetContentFapello(AList, Request, PageId, RequestKind);
      end;
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
    for i := 0 to high(Content) do begin
      var Item: TNBox9HentaitoItem;
      Item := TNBox9HentaitoItem.Create(false);
      Item.Item := Content[I];
      AList.Add(Item);
    end;
  finally
    Client.Free;
  end;
end;

function TNBoxScraper.GetContentGmpClub(AList: INBoxHasOriginList; AReqParam: string;
  ASearchType: TGmpClubSearchType; APageNum: integer): boolean;
var
  Client: TGmpclubScraper;
  i: integer;
  Content: TGmpclubItemAr;
begin
  Result := false;
  Client := TGmpclubScraper.create;
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
    for i := 0 to high(Content) do begin
      var Item: TNBoxGmpClubItem;
      Item := TNBoxGmpClubItem.Create;
      Item.Item := Content[I];
      AList.Add(Item);
    end;

  finally
    Client.Free;
  end;
end;

function TNBoxScraper.GetContentMotherless(AList: INBoxHasOriginList;
  ARequest: string; APage: integer; AMediaType: TMotherlessMediaType;
  ASort: TMotherLessSort; ASize: TMotherlessMediaSize;
  AUploadDate: TMotherLessUploadDate): boolean;
var
  LClient: TMotherlessScraper;
  LContent: TMotherlessItemAr;
  I: integer;
begin
  Result := False;
  LClient := TMotherlessScraper.Create;
  try
    SyncWebClientSet(LClient.WebClient, ORIGIN_MOTHERLESS);

    LContent := LClient.Search(ARequest, APage, AMediaType, ASort, ASize, AUploadDate);
    Result := (Length(LContent) > 0);
    for I := 0 to High(LContent) do begin
      var Item := TNBoxMotherlessItem.Create;
      var LTmp := Item.Page;
      LTmp.Item := LContent[I];
      Item.Page := LTmp;
      AList.Add(Item);
    end;

  finally
    LContent := nil;
    LClient.Free;
  end;
end;

function TNBoxScraper.GetContentBookmarks(AList: INBoxHasOriginList; ADbPath: string;
  ABookmarksListId: int64; APageId: integer): boolean;
var
  I, C: integer;
  Groups: TBookmarkGroupRecAr;
  Group: TBookmarkGroupRec;
  bookmarks: TBookmarkAr;
  TargetDb: TNBoxBookmarksDb;
begin
  Result := false;

  if (ADbPath = REGULAR_BMRKDB) or ADbPath.IsEmpty then
    TargetDb := Self.BookmarksDb
  else if (ADbPath = HISTORY_BMRKDB) then
    TargetDb := Self.HistoryDb;

  if not Assigned(TargetDb) then
    exit;

  C := AList.Count;

  Groups := TargetDb.GetBookmarksGroups;
  for I := low(Groups) to high(Groups) do begin
    if Groups[i].Id = ABookmarksListId then begin
      Group := Groups[i];
      break;
    end;
  end;

  Bookmarks := Group.GetPage(APageId);
  for I := low(bookmarks) to high(bookmarks) do begin
   // if Bookmarks[I].BookmarkType = Content then
      AList.Add(Bookmarks[I]);
//    Bookmarks[I].Free;
  end;
  Bookmarks := nil;

  Result := (AList.Count > C);
end;

function TNBoxScraper.GetContentCoomerParty(AList: INBoxHasOriginList;
  ASite: string; ARequest, AUserId, AService: string;
  APageNum: integer): boolean;
var
  Client: TCoomerPartyScraper;
  I: integer;
  Content: TPartyPostsPage;
begin
  Result := false;
  Client := TCoomerPartyScraper.Create;
  Client.Host := ASite;
  try
    SyncWebClientSet(Client.Client, ORIGIN_COOMERPARTY);

    if ( Trim(AUserId).IsEmpty or Trim(AService).IsEmpty ) then begin
      // Search by recent posts
      Content := Client.GetRecentPostsByPageNum(ARequest, APageNum);
    end else begin
      // Search by artist posts
      Content := Client.GetArtistPostsByPageNum(ARequest, AUserId, AService, APageNum);
    end;

    Result := ( length(Content.Posts) > 0 );
    for I := 0 to High(Content.Posts) do begin
      var Item: TNBoxCoomerPartyItem;
      Item := TNBoxCoomerPartyItem.Create;
      Item.Site := Client.Host;
      Item.UIdInt := Content.Posts[I].Id;
      Item.Item := TPartyPostToTPartyPostPage(Content.Posts[I]);
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
  I: integer;
begin
  Result := False;
  Client := TFapelloScraper.Create;
  try
    SyncWebClientSet(Client.Client, PROVIDERS.Fapello.Id);

    case ASearchType of
      FlFeed:
      begin
        var LContent := Client.GetFeedItems(APageNum);
        Result := ( Length(LContent) > 0 );
        for I := 0 to High(LContent) do begin
          var LItem := TNBoxFapelloItem.Create;
          LItem.Kind := FlFeed;
          LItem.FeedItem := LContent[I];
          AList.Add(LItem);
        end;
      end;

      FlThumb:
      begin
        var LContent := Client.GetAuthorContent(ARequest, APageNum);
        Result := ( Length(LContent) > 0 );
        for I := 0 to High(LContent) do begin
          var LItem := TNBoxFapelloItem.Create;
          var LFeedItem := TFapelloFeedItem.New;
          LFeedItem.Author.Username := ARequest;
          LItem.Kind := FlThumb;
          LItem.FeedItem := LFeedItem;
          LItem.ThumbItem := LContent[I];
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
  I, C: integer;
  Files: TSearchRecAr;
begin
  C := AList.Count;
  Files := GetFiles(ARequest);

  for I := Low(Files) to High(Files) do begin
    if Files[I].Attr = faDirectory then
      continue;
    var item: TNBoxPseudoItem;
    item := TNBoxPseudoItem.Create;
    item.ThumbnailUrl := IoUtils.TPath.Combine(TPAth.GetDirectoryName(ARequest), Files[i].Name);
    AList.Add(Item);
  end;
  Result := (AList.Count > C);
end;

function TNBoxScraper.GetContentR34JsonApi(AList: INBoxHasOriginList; ATags: string;
  APageId, ALimit: integer): boolean;
var
  Client: TR34Client;
  i: integer;
  content: TR34Items;
begin
  Result := false;
  Client := TR34Client.Create;
  Content := nil;
  try
    SyncWebClientSet(Client.WebClient, ORIGIN_R34JSONAPI);

    Content := Client.GetPosts
      ( ATags,
        APageId,
        ALimit );

    Result := (length(Content) > 0);
    for I := 0 to length(Content) - 1 do begin
      var item: TNBoxR34JsonApiItem;
      item := TNBoxR34JsonApiItem.Create;
      item.Item := Content[i];
      Alist.Add(item);
    end;

  finally
    Client.Free;
  end;
end;

function TNBoxScraper.GetContentRandomizer(AList: INBoxHasOriginList; AProviders: TArray<integer>): boolean;
var
  LProvider: integer;
  LRequest: INBoxSearchRequest;
begin
  Result := False;
  Randomize;
  if (Length(AProviders) < 1) then exit;
  LProvider := System.Math.RandomFrom(AProviders);
  LRequest := CreateReqByOrigin(LProvider);

  if (LRequest is TNBoxSearchReqNsfwXxx) then begin
    LRequest.PageId := RandomRange(1, 50);
  end else if (LRequest is TNBoxSearchReqR34App) then
    LRequest.PageId := RandomRange(0, 1000)
  else if (LRequest is TNBoxSearchReqGmpClub) then
    TNBoxSearchReqGmpClub(LRequest).SearchType := TGmpClubSearchType.Random
  else if (LRequest is TNBoxSearchReqCoomerParty) then begin
    TNBoxSearchReqCoomerParty(LRequest).PageId := RandomRange(0, 173628);
    TNBoxSearchReqCoomerParty(LRequest).Site := CoomerParty.Scraper.URL_COOMER_PARTY;
  end else if ( LRequest is TNBoxSearchReqMotherless ) then begin
    LRequest.PageId := RandomRange(0, 1500);
    TNBoxSearchReqMotherless(LRequest).ContentType := TMotherlessMediaType(RandomRange(0, 1));
    TNBoxSearchReqMotherless(LRequest).Sort := TMotherlessSort(RandomRange(0, 8));
  end else if ( LRequest is TNBoxSearchReq9HentaiTo ) then begin
    LRequest.PageId := RandomRange(0, 5119);
  end;

  try
    Result := Self.GetContent(LRequest, AList);
  finally
    (LRequest as TObject).Free;
  end;
end;

procedure TNBoxScraper.SyncWebClientSet(AClient: TNetHttpClient; AOrigin: integer);
begin
  if Not Assigned(self.OnWebClientSet) then
    exit;

  TThread.Synchronize(Nil, procedure begin
    OnWebClientSet(Self, AClient, AOrigin);
  end);
end;

function TNBoxScraper.TryFetchContentUrls(var APost: INBoxItem): boolean;
begin
  try
    FetchContentUrls(APost);
    Result := true;
  except
    Result := false;
  end;
end;

function TNBoxScraper.TryFetchTags(var APost: INBoxItem): boolean;
begin
  Self.TryFetchContentUrls(APost);
end;

function TNBoxScraper.GetContentR34App(AList: INBoxHasOriginList; ATags: string;
  APageId, ALimit: integer; ABooru: TR34AppFreeBooru): boolean;
var
  Client: TR34AppClient;
  i: integer;
  content: TR34AppItems;
begin
  try
    Result := false;
    Content := nil;
    Client := TR34AppClient.Create;

    SyncWebClientSet(Client.WebClient, ORIGIN_R34APP);
    Content := Client.GetPosts(ATags, APageId, ALimit, ABooru);
    Result := ( length(Content) > 0 );

    for I := 0 to Length(Content) - 1 do begin
      var item: TNBoxR34AppItem;
      item := TNBoxR34AppItem.Create;
      item.Item := Content[i];
      Alist.Add(item);
    end;

  finally
    Client.Free;
  end;
end;

function TNBoxScraper.GetContentNsfwXxx(AList: INBoxHasOriginList;
  AReqParam: string; ASearchType: TNsfwUrlType; APageNum: integer;
  Asort: TnsfwSort; ATypes: TNsfwItemTypes; AOrientations: TNsfwOris;
  ASite: TNsfwXxxSite): boolean;
var
  Client: TNsfwXxxScraper;
  i: integer;
  Content: TNsfwXXXItemList;
begin
  Result := false;
  try
    Client := TNsfwXxxScraper.Create;
    Client.Host := TNsfwXxxSiteToUrl(ASite);
    Content := TNsfwXXXItemList.Create;

    SyncWebClientSet(Client.WebClient, ORIGIN_NSFWXXX);

    Result := Client.GetItems
      ( Content,
        AReqParam,
        ASearchType,
        APageNum,
        ASort,
        ATypes,
        AOrientations );

    UploadItems(Content, Alist);
  finally
    Client.Free;
    Content.Free;
  end;
end;

procedure TNBoxScraper.UploadItems(A: TNsfwXXXItemList;
  AList: INBoxHasOriginList);
var
  I: integer;
  item: TNBoxNsfwXxxItem;
begin
  for I := 0 to A.Count - 1 do begin
    item := TNBoxNsfwXxxItem.Create;
    item.item := A.Items[i];
    Alist.Add(item);
  end;
end;

{ TNBoxFetchManager }

procedure TNBoxFetchManager.Add(AItem: INBoxItem);
begin
  Self.QueueAdd(AItem);
end;

constructor TNBoxFetchManager.Create;
begin
  Inherited;
  FQueue := TList<INBoxItem>.Create;
end;

destructor TNBoxFetchManager.Destroy;
begin
  inherited;
  FQueue.Free;
end;

procedure TNBoxFetchManager.SubThreadExecute(AItem: INBoxItem);
var
  LScraper: TNBoxScraper;
begin
  try
    try
      LScraper := TNBoxScraper.Create;
      LScraper.OnWebClientSet := Self.OnWebClientSet;

      while not LScraper.TryFetchContentUrls(AItem) do begin
        TThread.Current.CheckTerminated;
      end;

      // Fetched
      TThread.Current.CheckTerminated;
      if ( Assigned(Self.OnFetched) ) then
        Self.OnFetched(Self, AItem);

    finally
      //TObject(AItem).Free;
      LScraper.Free;
    end;
  Except

    On E: Exception do begin
      Log('TNBoxFetchManager.SubThreadExecute', E)
    end;

  end;
end;

end.

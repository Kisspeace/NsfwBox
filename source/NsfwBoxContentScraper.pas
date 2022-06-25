//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxContentScraper;

interface

uses
  System.SysUtils, System.Generics.Collections,
  NetHttp.R34AppApi, R34App.Types,
  Nethttp.R34JsonApi, R34JsonAPi.Types, NetHttp.Scraper.NsfwXxx,
  NsfwXxx.Types, Net.HttpClientComponent,
  NsfwBoxInterfaces, NsfwBoxOriginNsfwXxx, NsfwBoxOriginR34JsonApi,
  NsfwBoxOriginPseudo, NsfwBoxOriginR34App,
  NsfwBoxOriginConst, NsfwBoxBookmarks, NsfwBoxOriginBookmarks,
  IoUtils, NsfwBoxFilesystem, System.Classes, system.SyncObjs,
  System.Threading, NsfwBoxThreading;

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
      function GetContentNsfwXxx(AList: INBoxHasOriginList; AReqParam: string; ASearchType: TNsfwUrlType; APageNum: integer; Asort: TnsfwSort; ATypes: TNsfwItemTypes; AOrientations: TNsfwOris ): boolean;
      function GetContentR34JsonApi(AList: INBoxHasOriginList; ATags: string = ''; APageId: integer = 1; ALimit: integer = 20): boolean;
      function GetContentR34App(AList: INBoxHasOriginList; ATags: string = ''; APageId: integer = 1; ALimit: integer = 20): boolean;
      function GetContentBookmarks(AList: INBoxHasOriginList; ABookmarksListId: int64; APageId: integer = 1): boolean;
    public
      BookmarksDb: TNBoxBookmarksDb;
      procedure FetchContentUrls(var APost: INBoxItem);
      function TryFetchContentUrls(var APost: INBoxItem): boolean;
      function GetContent(ARequest: INBoxSearchRequest; AList: INBoxHasOriginList): boolean;
      property OnWebClientSet: TWebClientSetEvent read FOnWebClientSet write FOnWebClientSet;
      constructor Create;
  end;

  TNBoxFetchManager = Class(TQueuedThreadComponentBase)
    private
      FQueue: TList<INBoxItem>;
      FOnWebClientSet: TWebClientSetEvent;
      FOnFetched: TINBoxItemEvent;
    public
      // Critical section
      property Queue: TList<INBoxItem> read FQueue;
      // Critical section end
      { this executes in locked criticalsec }
      function QueueCondition: boolean; override;
      //function AutoRestartCondition: boolean; override;
      function NewSubTask: ITask; override;
      { !! }
      property OnFetched: TINBoxItemEvent read FOnFetched write FOnFetched;
      property OnWebClientSet: TWebClientSetEvent read FOnWebClientSet write FOnWebClientSet;
      procedure Add(AItem: INBoxItem);
      constructor Create(AOwner: TComponent);
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
  if ( APost is TNBoxNsfwXxxItem ) then begin
    var Client: TNsfwXxxScraper;
    var Item: TNBoxNsfwXxxitem;
    item := ( APost as TNBoxNsfwXxxitem );
    Client := TNsfwXxxScraper.Create;
    SyncWebClientSet(Client.WebClient, APost.Origin);
    try
      Item.Page := Client.GetPage(Item.Item.PostUrl);
    finally
      Client.Free;
    end;
  end;
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
            Oris );
      end;
    end;

    ORIGIN_R34APP:
    begin
      Result := self.GetContentR34App
      ( AList,
        ARequest.Request,
        ARequest.PageId );
    end;

    ORIGIN_R34JSONAPI:
    begin
      Result := self.GetContentR34JsonApi
      ( AList,
        ARequest.Request,
        ARequest.PageId );
    end;

    ORIGIN_PSEUDO:
    begin
      Result := Self.GetContentPseudo(AList, ARequest.Request);
    end;

    ORIGIN_BOOKMARKS:
    begin
      Result := Self.GetContentBookmarks(Alist, RequestAsInt, ARequest.PageId);
    end;

  end;
end;

function TNBoxScraper.GetContentBookmarks(AList: INBoxHasOriginList;
  ABookmarksListId: int64; APageId: integer): boolean;
var
  I, C: integer;
  Groups: TBookmarkGroupRecAr;
  Group: TBookmarkGroupRec;
  bookmarks: TBookmarkAr;
begin
  Result := false;
  if not Assigned(BookmarksDb) then
    exit;

  C := AList.Count;

  Groups := BookmarksDb.GetBookmarksGroups;
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

function TNBoxScraper.GetContentR34App(AList: INBoxHasOriginList; ATags: string;
  APageId, ALimit: integer): boolean;
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

    Content := Client.GetPosts(ATags, APageId, ALimit);
    Result := ( length(Content) > 0 );
    for I := Low(Content) to High(Content) do begin
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
  Asort: TnsfwSort; ATypes: TNsfwItemTypes; AOrientations: TNsfwOris): boolean;
var
  Client: TNsfwXxxScraper;
  i: integer;
  Content: TNsfwXXXItemList;
begin
  Result := false;
  try
    Client := TNsfwXxxScraper.Create;
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
  //synclog('Add begin.');
  FLock.Enter;
  try
    FQueue.Add(AItem);
  finally
    FLock.Leave;
  end;

 // SyncLog('Before if');

  if ( not IsWorkingNow ) then begin
    //synclog('Starting thread!!');
    Self.StartTask;
  end;
  //synclog('Add end.');
end;

constructor TNBoxFetchManager.Create(AOwner: TComponent);
begin
  Inherited;
  FQueue := TList<INBoxItem>.Create;
end;

destructor TNBoxFetchManager.Destroy;
begin
  inherited;
  FQueue.Free;
end;

function TNBoxFetchManager.NewSubTask: ITask;
var
  LItem: INBoxItem;
begin
  LItem := FQueue.First.Clone;
  FQueue.Delete(0);
  //SyncLog('Deleted: ' + FQueue.Count.ToString);

  Result := TTask.Create(
  procedure
  var
    LScraper: TNBoxScraper;
  begin
    try
      try
        LScraper := TNBoxScraper.Create;
        LScraper.OnWebClientSet := Self.OnWebClientSet;

        while not LScraper.TryFetchContentUrls(LItem) do begin
          TTask.CurrentTask.CheckCanceled;
        end;

        // Fetched
        TTask.CurrentTask.CheckCanceled;
        if ( Assigned(Self.OnFetched) ) then
          Self.OnFetched(Self, LItem);

      finally
        //TObject(AItem).Free;
        LScraper.Free;
      end;
    Except

      On E: EOperationCancelled do begin
        // ignore
      end;

      On E: Exception do begin
        SyncLog(E, 'TNBoxFetchManager.Execute.Task: ')
      end;

    end;
  end);
end;

function TNBoxFetchManager.QueueCondition: boolean;
begin
  Result := ( FQueue.Count > 0 );
end;

end.

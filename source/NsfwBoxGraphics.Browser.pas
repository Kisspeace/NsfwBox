//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxGraphics.Browser;

interface
uses
  SysUtils, Types, System.UITypes, Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  Fmx.Scroller, System.Threading, System.Generics.Collections, Net.HttpClient,
  Net.HttpClientComponent, NsfwBoxFileSystem,
  // Alcinoe
  AlFmxGraphics, AlFmxObjects,
  // NsfwBox
  NsfwBoxInterfaces, NsfwBoxContentScraper, NsfwBoxOriginPseudo,
  NsfwBoxOriginNsfwXxx, NsfwBoxGraphics, NsfwBoxOriginConst,
  NsfwBoxBookmarks, NsfwBoxOriginR34App,
  // you-did-well!
  YDW.FMX.ImageWithURL.Interfaces, YDW.FMX.ImageWithURL.AlRectangle,
  YDW.FMX.ImageWithURLManager;

type

  TBrowserItemCreateEvent = procedure (Sender: TObject; var AItem: TNBoxCardBase) of object;
  TScraperCreateEvent = procedure (Sender: TObject; var AScraper: TNBoxScraper) of object;

  TNBoxBrowser = class(TMultiLayoutScroller)
    protected
      type
        TBrowserTh = Class;
        TBrowserSubTh = class(TThread)
          public
            Owner: TBrowserTh;
            Item: IHasOrigin;
            procedure Execute; override;
            procedure OnRecievData(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var AAbort: Boolean);
        end;
        TBrowserTh = Class(TThread)
          public
            Owner: TNBoxBrowser;
            Request: INBoxSearchRequest;
            MaxThreadsCount: integer;
            procedure Execute; override;
            destructor Destroy; override;
          End;

        TBrowserThList = TObjectList<TBrowserTh>;
    private
      FThreads: TBrowserThList;
      FMaxParallelThumbLoaders: integer;
      FRequest: INBoxSearchRequest;
      FOnItemCreate: TBrowserItemCreateEvent;
      FOnWebClientCreate: TWebClientSetEvent;
      FOnScraperCreate: TScraperCreateEvent;
      FOnRequestChanged: TNotifyEvent;
      FBeforeBrowse: TNotifyEvent;
      FImageManager: IImageWithUrlManager;
      procedure SetRequest(const value: INBoxSearchRequest);
      procedure OnItemImageLoadFinished(Sender: TObject; ASuccess: boolean);
    public
      Items: TNBoxCardObjList;
      function NewItem: TNBoxCardBase;
      procedure GoBrowse;
      procedure GoNextPage;
      procedure GoPrevPage;
      procedure TerminateThreads;
      procedure WaitForThreads;
      procedure Clear;
      property Request: INBoxSearchRequest read FRequest write SetRequest;
      property ImageManager: IImageWithUrlManager read FImageManager write FImageManager; //FIXME
      property MaxParallelThumbLoaders: integer read FMaxParallelThumbLoaders write FMaxParallelThumbLoaders;
      property BeforeBrowse: TNotifyEvent read FBeforeBrowse write FBeforeBrowse;
      property OnItemCreate: TBrowserItemCreateEvent read FOnItemCreate write FOnItemCreate;
      property OnScraperCreate: TScraperCreateEvent read FOnScraperCreate write FOnScraperCreate;
      property OnWebClientCreate: TWebClientSetEvent read FOnWebClientCreate write FOnWebClientCreate;
      property OnRequestChanged: TNotifyEvent read FOnRequestChanged write FOnRequestChanged;
      constructor Create(Aowner: Tcomponent); override;
      destructor Destroy; override;
  end;

  TNBoxBrowserList = TList<TNBoxBrowser>;

implementation
  uses unit1;

{ TNsfwBoxBrowser }

constructor TNBoxBrowser.Create(Aowner:Tcomponent);
begin
  Inherited create(Aowner);
  FOnScraperCreate      := nil;
  FBeforeBrowse         := nil;
  FOnWebClientCreate    := nil;
  FOnRequestChanged     := nil;
  FThreads := TBrowserThList.Create;
  items := TNBoxCardObjList.Create;
  LayoutIndent := 20;
  MultiLayout.PlusHeight := LayoutIndent;
  MultiLayout.BlockCount := 2;
  FMaxParallelThumbLoaders := 5;
  FRequest := TNBoxSearchReqNsfwXxx.create;
end;

procedure TNBoxBrowser.SetRequest(const value: INBoxSearchRequest);
var
  New: INBoxSearchRequest;
begin

  if Assigned(value) then
    New := value
  else
    New := TNBoxSearchReqNsfwXxx.Create;

  if Assigned(FRequest) then
    TObject(FRequest).Free;

  FRequest := new;

  if Assigned(OnRequestChanged) then
    OnRequestChanged(Self);
end;


procedure TNBoxBrowser.TerminateThreads;
var
  I: integer;
begin
  if ( FThreads.Count < 1 ) then
    exit;
  for I := 0 to ( FThreads.Count - 1 ) do begin
    FThreads.Items[I].Terminate;
  end;
end;

procedure TNBoxBrowser.WaitForThreads;
var
  I: integer;
begin
  if FThreads.Count < 1 then
    exit;

  for I := 0 to FThreads.Count - 1 do begin
    FThreads.Items[I].WaitFor;
  end;

  FThreads.Clear;
end;

Destructor TNBoxBrowser.Destroy;
begin
  self.Clear;
  items.Free;
  inherited Destroy;
end;

procedure TNBoxBrowser.GoBrowse;
var
  Th: TBrowserTh;
begin
  if Assigned(BeforeBrowse) then
    BeforeBrowse(Self);

  Th                 := TBrowserTh.Create(true);
  Th.Owner           := Self;
  Th.Request         := Self.Request.Clone;
  Th.MaxThreadsCount := Self.MaxParallelThumbLoaders;
  Th.FreeOnTerminate := false;
  Th.Start;
  FThreads.Add(Th);
   while not Th.Started do begin
    sleep(1);
  end;
end;

procedure TNBoxBrowser.GoNextPage;
begin
  Request.PageId := Request.PageId + 1;
  if Assigned(OnRequestChanged) then
    OnRequestChanged(Self);
  self.GoBrowse;
end;

procedure TNBoxBrowser.GoPrevPage;
begin
  Request.PageId := Request.PageId - 2;
  self.GoNextPage;
end;

function TNBoxBrowser.NewItem: TNBoxCardBase;
begin
  Result := TNBoxCardSimple.Create(self);
  Result.ImageManager := Self.ImageManager;
  Result.OnLoadingFinished := OnItemImageLoadFinished;
  Items.Add(Result);
  Self.MultiLayout.AddControl(Result);
  if Assigned(OnItemCreate) then
    OnItemCreate(Self, Result);
end;


procedure TNBoxBrowser.OnItemImageLoadFinished(Sender: TObject;
  ASuccess: boolean);
var
  LControl: TControl;
begin
  LControl := Sender As TControl;

  if Assigned(LControl.OnResize) then
    LControl.OnResize(LControl);

  Self.MultiLayout.ReCalcBlocksSize;
end;

procedure TNBoxBrowser.Clear;
var
  I: integer;
begin
  try
    TerminateThreads;
    WaitForThreads;

    if items.Count > 0 then begin
      items.Clear;
      MultiLayout.RecalcSize;
      MultiLayout.BlockPos := 0;
    end;
  except
    On E:Exception do
      SyncLog(E, 'TNBoxBrowser.clear: ');
  end;
end;


{ TNBoxBrowser.TBrowserSubTh }

procedure TNBoxBrowser.TBrowserSubTh.Execute;
const
  START_ITEM_HEIGHT: single = 320;
var
  Web: TNetHttpClient;
  Fetched: TStream;
  FName: string;
  CachedThumb: string;
  LItm: TNBoxCardBase;
  B: TNBoxBrowser;
  LPost: INBoxItem;
  LRequest: INBoxSearchRequest;
  LBookmark: TNBoxBookmark;
  BadThumb: boolean;
  Msg: string;
  Response: IHttpResponse;

  function IsValidImg(ARes: IHttpResponse): boolean;
  var
    I, C: integer;
    ContentType: string;
  const
    NotImageTypes: TArray<string> = ['text', 'html', 'json'];
  begin
    Result := true;
    //Unit1.SyncLog(ARes.HeaderValue['Content-Type']);
    ContentType := ARes.HeaderValue['Content-Type'];
    for I := 0 to High(NotImageTypes) - 1 do begin
      if ( pos(NotImageTypes[I].ToUpper, ContentType.ToUpper) > 0 ) then begin
        Result := false;
        break;
      end;
    end;
  end;

begin
  try
    try
      Fetched   := nil;
      web       := nil;
      LBookmark := nil;
      LPost     := nil;
      LRequest  := nil;
      Msg       := '';
      BadThumb  := false;
      B         := Owner.Owner;
      CachedThumb := '';

      if Supports(Item, INBoxItem) then begin
        LPost := ( Item as INBoxItem )
      end else if ( Item is TNBoxBookmark ) then begin
        LBookmark := TNBoxBookmark(Item);
        if ( LBookmark.BookmarkType = TNBoxBookmarkType.Content ) then
          LPost := LBookmark.AsItem
        else if ( LBookmark.BookmarkType = SearchRequest ) then
          LRequest := LBookmark.AsRequest;
      end;

      Self.Synchronize(
      procedure begin
        LItm := B.NewItem;

        With LItm do begin
          Height := START_ITEM_HEIGHT;

          if Assigned(LBookmark) then
            LItm.Item := LBookmark
          else
            LItm.Item := LPost.Clone;

          Visible := true;
        end;
      end);

      if Assigned(LPost) then
        CachedThumb := TNBoxPath.GetThumbnailByUrl(LPost.ThumbnailUrl);

      if Assigned(LPost) and FileExists(CachedThumb) then begin
        while ( not Self.Terminated ) do begin
          try
            Fetched := TFileStream.Create(CachedThumb, FmOpenRead); //!!
            break;
          except
            Sleep(100);
          end;
        end;
      end else if not ( Item.Origin = ORIGIN_PSEUDO ) and Assigned(LPost) then begin

        Web := TNetHttpClient.Create(nil);

        Self.Synchronize(
        procedure begin
          if Assigned(B.OnWebClientCreate) then begin
            B.OnWebClientCreate(B, Web, Item.Origin);
          end;
        end);

        Web.SynchronizeEvents := false;
        Web.OnReceiveData :=  OnRecievData;
        Web.OnSendData := OnRecievData;
        Web.Asynchronous := false;

        try

          Response := Web.Get(LPost.ThumbnailUrl);
          Fetched := Response.ContentStream;
          BadThumb := ( not IsValidImg(Response));

          if not BadThumb then begin
            TNBoxPath.CreateThumbnailsDir;
            (Fetched as TMemoryStream).SaveToFile(CachedThumb);
          end;

        except
          on E: Exception do begin
            Msg := E.ClassName + ': ' + E.Message;
            SyncLog(E, 'Fetch thumbnail: ');
            Fetched := nil;
          end;
        end;
      end;

      if Terminated then
        exit;

      Self.Synchronize(
      procedure
      var
        I: integer;
      begin
//        LItm := B.NewItem;
        With LItm do begin

//          if Assigned(LBookmark) then
//            LItm.Item := LBookmark
//          else
//            LItm.Item := LPost.Clone;

          try

            if Assigned(Fetched) then begin
              // when got thumbnail
              try
                if not BadThumb then
                  SetThumbnail(Fetched);
              except
                on E: Exception do begin
                  Log(E, 'TNBoxBrowser.TBrowserSubTh.Execute item sync SetThumbnail: ');
                  BadThumb := true;
                end;
              end;
            end else begin
              // when not
              if Assigned(LPost) then begin
                if Fileexists(LPost.ThumbnailUrl) then
                  SetThumbnail(LPost.ThumbnailUrl)
                else if ( not Msg.IsEmpty ) then begin


                end;
              end else if Assigned(LRequest) then begin
                Size.Height := Size.Width * 1;
              end;
            end;

            if BadThumb then begin
              Fill.Kind := TBrushKind.Solid;
            end;

            Visible := true;

            if Assigned(LItm.OnResize) then
              LItm.OnResize(LItm);

          except
            on E: Exception do
              Log(E, 'TNBoxBrowser.TBrowserSubTh.Execute item sync: ');
          end;
        end;

        B.MultiLayout.ReCalcBlocksSize;
      end);

    finally
      if (Fetched is TFileStream) then Fetched.Free;
      if Assigned(Web) then Web.Free;
    end;
  except
    on E: Exception do
      SyncLog(E, 'TNBoxBrowser.TBrowserSubTh.Execute: ');
  end;
end;

procedure TNBoxBrowser.TBrowserSubTh.OnRecievData(const Sender: TObject;
  AContentLength, AReadCount: Int64; var AAbort: Boolean);
begin
  if Self.Terminated then
    AAbort := true;
end;

{ TNBoxBrowser.TBrowserTh }

destructor TNBoxBrowser.TBrowserTh.Destroy;
begin
  if Assigned(Request) then
    ( Request as TInterfacedPersistent ).Free;
end;

procedure TNBoxBrowser.TBrowserTh.Execute;
const
  START_ITEM_HEIGHT: single = 320;
var
  I: integer;
  Scraper: TNBoxScraper;
  Content: INBoxHasOriginList;
//  LNewItems: TArray<TNBoxCardBase>;
  Fetched: boolean;

  LNewItem: TNBoxCardBase;
  LPost: INBoxItem;
  LRequest: INBoxSearchRequest;
  LBookmark: TNBoxBookmark;

  function IsNeedToBeSync: boolean;
  begin
    Result := ( Request.Origin = ORIGIN_BOOKMARKS );
  end;

begin
  try
    Fetched := false;
    Scraper := TNBoxScraper.Create;
    Content := INBoxHasOriginList.Create;

    Self.Synchronize(
    procedure
    begin

      if Assigned(Owner.OnWebClientCreate) then
        Scraper.OnWebClientSet := Owner.OnWebClientCreate;

      if Assigned(Owner.OnScraperCreate) then
        Owner.OnScraperCreate(Self.Owner, Scraper);

    end);

    if Terminated then
      exit;

    try

      if IsNeedToBeSync then begin
        Synchronize(procedure begin Fetched := Scraper.GetContent(Request, Content); end);
      end else begin
        Fetched := Scraper.GetContent(Request, Content);
      end;

      if not Fetched then
        exit;

    except
      on E: Exception do begin
        SyncLog(E, 'Origin: ' + Request.Origin.ToString + ' Browser Main thread -> Scraper.GetContent: ');
        exit;
      end;
    end;


    for I := 0 to Content.Count - 1 do begin
      var LContentItem := Content[I];

      if Self.Terminated then exit;

      LBookmark := nil;
      LPost     := nil;
      LRequest  := nil;

      Supports(LContentItem, INBoxItem, LPost);

      if ( LContentItem is TNBoxBookmark ) then begin
        LBookmark := TNBoxBookmark(LContentItem);
        if ( LBookmark.BookmarkType = TNBoxBookmarkType.Content ) then
          LPost := LBookmark.AsItem
        else if ( LBookmark.BookmarkType = SearchRequest ) then
          LRequest := LBookmark.AsRequest;
      end;

      Self.Synchronize(
      procedure
      begin
        LNewItem := Self.Owner.NewItem;

        With LNewItem do begin
          Height := START_ITEM_HEIGHT;

          if Assigned(LBookmark) then
            LNewItem.Item := LBookmark
          else
            LNewItem.Item := LPost.Clone;

          Visible := true;
          Fill.Kind := TBrushKind.Bitmap;

          if Assigned(LPost) then
            ImageURL := LPost.ThumbnailUrl;
        end;

        Self.Owner.MultiLayout.ReCalcBlocksSize;
      end);

    end;

//    LNewItems := [];
    Self.Synchronize(
    procedure
    var
      I: integer;
    begin


      Self.Owner.MultiLayout.ReCalcBlocksSize;
    end);




//    for I := 0 to Content.Count - 1 do begin
//      var Item := Content[I];
//
//      if Self.Terminated then
//        exit;
//
////      LBookmark := nil;
////      LPost     := nil;
////      LRequest  := nil;
////      B         := Self.Owner;
////
////      Supports(Item, INBoxItem, LPost);
////
////      if ( Item is TNBoxBookmark ) then begin
////        LBookmark := TNBoxBookmark(Item);
////        if ( LBookmark.BookmarkType = TNBoxBookmarkType.Content ) then
////          LPost := LBookmark.AsItem
////        else if ( LBookmark.BookmarkType = SearchRequest ) then
////          LRequest := LBookmark.AsRequest;
////      end;
//
//      Self.Synchronize(
//      procedure begin
//        LItm := B.NewItem;
//
//        With LItm do begin
//          Height := START_ITEM_HEIGHT;
//
//          if Assigned(LBookmark) then
//            LItm.Item := LBookmark
//          else
//            LItm.Item := LPost.Clone;
//
//          Visible := true;
//        end;
//
//        B.MultiLayout.ReCalcBlocksSize;
//      end);
//
//      LItm.Fill.Kind := TBrushKind.Bitmap;
//      if Assigned(LPost) then
//        LItm.ImageURL := LPost.ThumbnailUrl;
//
//    end;

  finally
    Scraper.Free;
    Content.Free;
  end;
end;

end.

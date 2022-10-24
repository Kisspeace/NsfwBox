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
  YDW.FMX.ImageWithURLManager, YDW.Threading;

type

  TBrowserItemCreateEvent = procedure (Sender: TObject; var AItem: TNBoxCardBase) of object;
  TScraperCreateEvent = procedure (Sender: TObject; var AScraper: TNBoxScraper) of object;

  TNBoxBrowser = class(TMultiLayoutScroller)
    protected
      type
        TBrowserWorker = Class(TInterfaceYDWQueuedThreadComponent<TNBoxSearchRequestBase>)
          protected
            Browser: TNBoxBrowser;
            procedure SubThreadExecute(AItem: TNBoxSearchRequestBase); override;
        End;
    private
      FWorker: TBrowserWorker;
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
      DummyImage: TBitmap;
      function NewItem: TNBoxCardBase;
      procedure GoBrowse;
      procedure GoNextPage;
      procedure GoPrevPage;
      procedure Clear;
      property Request: INBoxSearchRequest read FRequest write SetRequest;
      property ImageManager: IImageWithUrlManager read FImageManager write FImageManager; //FIXME
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
  FWorker := TBrowserWorker.Create(Self);
  FWorker.Browser := Self;
  FOnScraperCreate      := nil;
  FBeforeBrowse         := nil;
  FOnWebClientCreate    := nil;
  FOnRequestChanged     := nil;
  DummyImage            := nil;
  items := TNBoxCardObjList.Create;
  LayoutIndent := 20;
  MultiLayout.PlusHeight := LayoutIndent;
  MultiLayout.BlockCount := 2;
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

Destructor TNBoxBrowser.Destroy;
begin
  self.Clear;
  FWorker.Free;
  items.Free;
  inherited Destroy;
end;

procedure TNBoxBrowser.GoBrowse;
begin
  if Assigned(BeforeBrowse) then
    BeforeBrowse(Self);

  FWorker.QueueAdd(Self.Request.Clone as TNBoxSearchRequestBase);
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
    FWorker.Terminate;
    FWorker.WaitForFinish;

    if items.Count > 0 then begin
      for I := 0 to Items.Count - 1 do begin
        Items[I].AbortLoading;
      end;

      items.Clear;
      MultiLayout.RecalcSize;
      MultiLayout.BlockPos := 0;
    end;
  except
    On E:Exception do
      SyncLog(E, 'TNBoxBrowser.clear: ');
  end;
end;

{ TNBoxBrowser.TBrowserWorker }

procedure TNBoxBrowser.TBrowserWorker.SubThreadExecute(AItem: TNBoxSearchRequestBase);
const
  START_ITEM_HEIGHT: single = 320;
var
  I: integer;
  Scraper: TNBoxScraper;
  Content: INBoxHasOriginList;
  Fetched: boolean;

  LNewItem: TNBoxCardBase;
  LPost: INBoxItem;
  LRequest: INBoxSearchRequest;
  LBookmark: TNBoxBookmark;

  function IsNeedToBeSync: boolean;
  begin
    Result := ( AItem.Origin = ORIGIN_BOOKMARKS );
  end;

begin
  try
    Fetched := false;
    Scraper := TNBoxScraper.Create;
    Content := INBoxHasOriginList.Create;

    if Assigned(Browser.OnWebClientCreate) then
      Scraper.OnWebClientSet := Browser.OnWebClientCreate;

    if Assigned(Browser.OnScraperCreate) then
      Browser.OnScraperCreate(Self.Owner, Scraper);

    if TThread.Current.CheckTerminated then exit;

    try

      if IsNeedToBeSync then begin

        TThread.Synchronize(nil, procedure
        begin
          Fetched := Scraper.GetContent(AItem, Content);
        end);

      end else begin
        Fetched := Scraper.GetContent(AItem, Content);
      end;

      if not Fetched then exit;

    except
      on E: Exception do begin
        SyncLog(E, 'Origin: ' + AItem.Origin.ToString + ' Browser Main thread -> Scraper.GetContent: ');
        exit;
      end;
    end;

    for I := 0 to Content.Count - 1 do begin
      var LContentItem := Content[I];

      if TThread.Current.CheckTerminated then exit;

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

      TThread.Synchronize(nil,
      procedure
      begin
        LNewItem := Self.Browser.NewItem;

        With LNewItem do begin
          Height := START_ITEM_HEIGHT;

          if Assigned(LBookmark) then
            LNewItem.Item := LBookmark
          else
            LNewItem.Item := LPost; // LPost.Clone;

          Fill.Kind := TBrushKind.Bitmap;

          if Assigned(Self.Browser.DummyImage) then
            LnewItem.BitmapIWU.Assign(Self.Browser.DummyImage);

          if (Assigned(LPost) and (not LPost.ThumbnailUrl.IsEmpty)) then
            ImageURL := LPost.ThumbnailUrl;
        end;

        Self.Browser.MultiLayout.ReCalcBlocksSize;
      end);

    end;

  finally

    (AItem as TObject).Free;
    Scraper.Free;
    Content.Free;

  end;
end;

end.

{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Graphics.Browser;

interface
uses
  SysUtils, Types, System.UITypes, Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.ColumnsView, System.Threading, System.Generics.Collections, Net.HttpClient,
  Net.HttpClientComponent, NsfwBox.FileSystem,
  { Alcinoe }
  Alcinoe.FMX.Objects, Alcinoe.FMX.Graphics,
  { NsfwBox }
  NsfwBox.Interfaces, NsfwBox.ContentScraper, NsfwBox.Provider.Pseudo,
  NsfwBox.Provider.NsfwXxx, NsfwBox.Graphics, NsfwBox.Consts,
  NsfwBox.Bookmarks, NsfwBox.Provider.R34App, NsfwBox.Logging,
  NsfwBox.Utils,
  { you-did-well! }
  YDW.FMX.ImageWithURL.Interfaces, YDW.FMX.ImageWithURL.AlRectangle,
  YDW.FMX.ImageWithURLManager, YDW.Threading;

type

  TBrowserItemCreateEvent = procedure (Sender: TObject; var AItem: TNBoxCardBase) of object;
  TScraperCreateEvent = procedure (Sender: TObject; var AScraper: TNBoxScraper) of object;

  TNBoxBrowser = class(TColumnsView, IAbortableAndWaitable)
    protected
      type
        TBrowserWorker = Class(TGenericYDWQueuedThreadObject<TNBoxSearchRequestBase>)
          protected
            Browser: TNBoxBrowser;
            procedure SubThreadExecute(AItem: TNBoxSearchRequestBase); override;
        End;
    private
      FSync: TMREWSync;
      FWorker: TBrowserWorker;
      FRequest: INBoxSearchRequest;
      FOnItemCreate: TBrowserItemCreateEvent;
      FOnWebClientCreate: TWebClientSetEvent;
      FOnScraperCreate: TScraperCreateEvent;
      FOnRequestChanged: TNotifyEvent;
      FBeforeBrowse: TNotifyEvent;
      FImageManager: IImageWithUrlManager;
      function GetRequest: INBoxSearchRequest;
      procedure SetRequest(const value: INBoxSearchRequest);
      procedure OnItemImageLoadFinished(Sender: TObject; ASuccess: boolean);
    public
      Items: TNBoxCardObjList;
      DummyImage: TBitmap;
      { IAbortableAndWaitable }
      function IAbortableAndWaitable.IsExecuting = IsBrowsingNow;
      procedure IAbortableAndWaitable.AbortExecution = AbortBrowsing;
      procedure IAbortableAndWaitable.WaitFor = WaitFor;
      { --------------------- }
      function NewItem: TNBoxCardBase;
      procedure GoBrowse;
      procedure GoNextPage;
      procedure GoPrevPage;
      procedure AbortBrowsing;
      procedure WaitFor;
      procedure Clear;
      function IsBrowsingNow: boolean;
      property Request: INBoxSearchRequest read GetRequest write SetRequest;
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
  uses unit1, NsfwBox.GarbageCollector;

{ TNsfwBoxBrowser }

constructor TNBoxBrowser.Create(Aowner:Tcomponent);
begin
  Inherited create(Aowner);
  FSync := TMREWSync.Create;
  FWorker := TBrowserWorker.Create;
  FWorker.Browser := Self;
  FOnScraperCreate      := nil;
  FBeforeBrowse         := nil;
  FOnWebClientCreate    := nil;
  FOnRequestChanged     := nil;
  DummyImage            := nil;
  items := TNBoxCardObjList.Create(False);
  ColumnsCount := 2;
  FRequest := TNBoxSearchReqNsfwXxx.create;
end;

procedure TNBoxBrowser.SetRequest(const value: INBoxSearchRequest);
var
  New: INBoxSearchRequest;
begin
  FSync.BeginWrite;
  try
    try
      if Assigned(value) then
        New := value.Clone
      else
        New := TNBoxSearchReqNsfwXxx.Create;
    except
      On E: Exception do Log('TNBoxBrowser.SetRequest 110', E);
    end;

    if Assigned(FRequest) then
      FreeInterfaced(FRequest);

    FRequest := new;
  finally
    FSync.EndWrite;
  end;

  try
  if Assigned(OnRequestChanged) then
    OnRequestChanged(Self);
  except
      On E: Exception do Log('TNBoxBrowser.SetRequest 124', E);
    end;
end;

procedure TNBoxBrowser.WaitFor;
begin
  FWorker.WaitFor;
end;

Destructor TNBoxBrowser.Destroy;
begin
  FWorker.Terminate;
  FWorker.WaitFor;
  Self.Clear;
  FWorker.Free;
  Items.Free;
  FSync.Free;
  if Assigned(FRequest) then
    (FRequest as TObject).Free;
  FRequest := nil;
  inherited;
end;

function TNBoxBrowser.GetRequest: INBoxSearchRequest;
begin
  FSync.BeginRead;
  try
    if Assigned(FRequest) then
      Result := FRequest.Clone;
  finally
    FSync.EndRead;
  end;
end;

procedure TNBoxBrowser.GoBrowse;
begin
  if Assigned(BeforeBrowse) then BeforeBrowse(Self);
  FWorker.QueueAdd(Self.Request as TNBoxSearchRequestBase);
end;

procedure TNBoxBrowser.GoNextPage;
begin
  FSync.BeginWrite;
  try
    FRequest.PageId := FRequest.PageId + 1;
  finally
    FSync.EndWrite;
  end;

  if Assigned(OnRequestChanged) then
    OnRequestChanged(Self);
  GoBrowse;
end;

procedure TNBoxBrowser.GoPrevPage;
begin
  FSync.BeginWrite;
  try
    FRequest.PageId := FRequest.PageId - 1;
  finally
    FSync.EndWrite;
  end;

  if Assigned(OnRequestChanged) then
    OnRequestChanged(Self);
  GoBrowse;
end;

function TNBoxBrowser.IsBrowsingNow: boolean;
begin
  Result := FWorker.GetIsRunning;
end;

function TNBoxBrowser.NewItem: TNBoxCardBase;
begin
  try
    Result := TNBoxCardSimple.Create(Nil);
    Result.ImageManager := Self.ImageManager;
    Result.OnLoadingFinished := OnItemImageLoadFinished;
    Result.Fill.Kind := TBrushKind.Bitmap;

    FSync.BeginWrite;
    try
      Items.Add(Result);
      if Assigned(Self.DummyImage) then
        Result.BitmapIWU.Assign(Self.DummyImage);

      Result.Parent := Self;
    finally
      FSync.EndWrite;
    end;

    if Assigned(OnItemCreate) then
      OnItemCreate(Self, Result);
  except
    On E: Exception do begin
      Log('TNBoxBrowser.NewItem', E);
    end;
  end;
end;


procedure TNBoxBrowser.OnItemImageLoadFinished(Sender: TObject;
  ASuccess: boolean);
var
  LControl: TControl;
begin
  LControl := Sender As TControl;

  if Assigned(LControl.OnResize) then
    LControl.OnResize(LControl);

  Self.RecalcColumns;
end;

procedure TNBoxBrowser.AbortBrowsing;
begin
  FWorker.Terminate;
end;

procedure TNBoxBrowser.Clear;
var
  I: integer;
begin
  try
    FSync.BeginWrite;
    try
      if (Items.Count > 0) then begin
        for I := 0 to Items.Count - 1 do
          BlackHole.Throw(Items[I]);
        Items.Clear;

        RecalcColumns;
      end;
    finally
      FSync.EndWrite;
    end;

  except
    On E:Exception do
      Log('TNBoxBrowser.Clear', E);
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

begin
  try
    Fetched := false;
    Scraper := TNBoxScraper.Create;
    Content := INBoxHasOriginList.Create;
    try

      if Assigned(Browser.OnWebClientCreate) then
        Scraper.OnWebClientSet := Browser.OnWebClientCreate;

      if Assigned(Browser.OnScraperCreate) then
        Browser.OnScraperCreate(Self.Browser, Scraper);

      if TThread.Current.CheckTerminated then exit;

      try
        Fetched := Scraper.GetContent(AItem, Content);
        if not Fetched then exit;
      except
        on E: Exception do begin
          Log('Provider: ' + AItem.Origin.ToString + ' Browser -> Scraper.GetContent', E);
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

        if (LContentItem is TNBoxBookmark) then begin
          LBookmark := (LContentItem as TNBoxBookmark);
          if (LBookmark.BookmarkType = TNBoxBookmarkType.Content) then
            LPost := LBookmark.AsItem
          else if (LBookmark.BookmarkType = SearchRequest) then
            LRequest := LBookmark.AsRequest;
        end;

        TThread.Synchronize(TThread.Current,
        procedure
        begin
          LNewItem := Self.Browser.NewItem;

          With LNewItem do begin
            Height := START_ITEM_HEIGHT;

            if Assigned(LBookmark) then
              LNewItem.Item := LBookmark
            else
              LNewItem.Item := LPost;

            if (Assigned(LPost) and (not LPost.ThumbnailUrl.IsEmpty)) then
              ImageURL := LPost.ThumbnailUrl;
          end;

          Self.Browser.RecalcColumns;
        end);

      end;

    finally

      FreeAndNil(AItem);
      Scraper.Free;

      { freeing not used items. }
      for I := I to Content.Count - 1 do
      begin

        var LContentItem := Content[I];
        Content[I] := Nil;

        if (LContentItem is TNBoxBookmark) then
        begin
          LBookmark := (LContentItem as TNBoxBookmark);
          LBookmark.FreeObj;
        end;

        FreeInterfaced(LContentItem);
      end;

      Content.Free;

    end;
  except
    On E: Exception do
      Log('TNBoxBrowser.TBrowserWorker.SubThreadExecute', E);
  end;
end;

end.

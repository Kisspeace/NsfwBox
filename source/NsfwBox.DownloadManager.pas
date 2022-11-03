{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.DownloadManager;

interface
uses
  Classes, NetHttpClient.Downloader, Net.HttpClient, Net.HttpClientComponent,
  System.Threading, system.Generics.Collections, System.SysUtils, YDW.Threading,
  NsfwBox.Graphics;

type

  TNBoxDownloader = Class(TNetHttpDownloader)
    public
      Tab: TNBoxTab;
  End;

  TOnCreateDownloader = procedure (Sender: Tobject; const ADownloader: TNBoxDownloader) of object;
  TOnStartDownloader = TOnCreateDownloader;

  TDownloaderList = TList<TNetHttpDownloader>;
  TDownloaderObjList = TObjectList<TNetHttpDownloader>;

  TNBoxDownloadManager = class(TGenericYDWQueuedThreadObject<TNBoxDownloader>)
    private
      FSynchronizeEvents: boolean;
      FOnCreateDownloader: TOnCreateDownloader;
      FOnStartDownloader: TOnStartDownloader;
      procedure SetSynchronizeEvents(const value: boolean);
      function GetSynchronizeEvents: boolean;
    protected
      procedure SubThreadExecute(AItem: TNBoxDownloader); override;
    public
      function AddDownload(AUrl: string; AFilename: string; ATab: TNBoxTab = nil): TNBoxDownloader;
      procedure AbortDownload(ADownloader: TNBoxDownloader);
      property SynchronizeEvents: boolean read GetSynchronizeEvents write SetSynchronizeEvents default true;
      property OnCreateDownloader: TOnCreateDownloader read FOnCreateDownloader write FOnCreateDownloader;
      property OnStartDownloader: TOnStartDownloader read FOnStartDownloader write FOnStartDownloader;
      constructor Create; override;
      destructor Destroy; override;
  end;

implementation
 uses unit1;
{ TNBoxDownloadManager }

procedure TNBoxDownloadManager.AbortDownload(ADownloader: TNBoxDownloader);
begin
  Self.AbortItem(ADownloader);
end;

function TNBoxDownloadManager.AddDownload(AUrl,
  AFilename: string; ATab: TNBoxTab): TNBoxDownloader;
begin
  Result := TNBoxDownloader.Create;
  With Result do begin
    Url       := AUrl;
    Filename  := AFilename;
    AutoRetry := True;
    Tab       := ATab;
  end;

  if Assigned(OnCreateDownloader) then
    OnCreateDownloader(Self, Result);

  Self.QueueAdd(Result);
end;

constructor TNBoxDownloadManager.Create;
begin
  inherited;
  FSynchronizeEvents := true;
end;

destructor TNBoxDownloadManager.Destroy;
begin
  inherited;
end;

function TNBoxDownloadManager.GetSynchronizeEvents: boolean;
begin
  FLock.BeginRead;
  try
    Result := FSynchronizeEvents;
  finally
    FLock.EndRead;
  end;
end;

procedure TNBoxDownloadManager.SetSynchronizeEvents(const value: boolean);
begin
  FLock.BeginWrite;
  try
    FSynchronizeEvents := Value;
  finally
    FLock.EndWrite;
  end;
end;

procedure TNBoxDownloadManager.SubThreadExecute(AItem: TNBoxDownloader);
const
  WAIT_TIMEOUT = 10;
begin
  try
    try
       AItem.Start;

       while AItem.IsRunning do begin
         Sleep(WAIT_TIMEOUT);
         if TThread.Current.CheckTerminated then exit;
       end;

    finally
      FreeAndNil(AItem);
    end;
  Except
    On E: Exception do
      Unit1.SyncLog(E, 'TNBoxDownloadManager.SubThreadExecute');
  end;

end;

end.

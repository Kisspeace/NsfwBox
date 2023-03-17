{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.DownloadManager;

interface
uses
  Classes, NetHttpClient.Downloader, Net.HttpClient, Net.HttpClientComponent,
  System.Threading, system.Generics.Collections, System.SysUtils, YDW.Threading,
  NsfwBox.Graphics, NsfwBox.Logging;

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
  FSynchronizeEvents := True;
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
    {$IFDEF DEBUG}
    TThread.Current.NameThreadForDebugging('TNBoxDownloadManager.SubThread: ' + AItem.Filename);
    {$ENDIF}
    try
       while not TThread.Current.CheckTerminated do begin
         try
           AItem.Start;
           Break;
         except
           On E: Exception do begin
             Log('TNBoxDownloadManager.SubThreadExecute - AItem.Start.', E);
             Sleep(1000);
           end;
         end;
       end;

       try
         while AItem.IsRunning do begin
           Sleep(WAIT_TIMEOUT);
           if TThread.Current.CheckTerminated then
           begin
             AItem.AbortRequest;
             Break;
           end;
         end;
       except
          On E: Exception do Log('TNBoxDownloadManager.SubThreadExecute - waiting for finish.', E);
       end;
    finally
      try
        while AItem.IsRunning do
          Sleep(WAIT_TIMEOUT);
      except
        On E: Exception do Log('TNBoxDownloadManager.SubThreadExecute - finally waiting for finish.', E);

      end;
      FreeAndNil(AItem);  { FIXME }
    end;
  Except
    On E: Exception do
      Log('TNBoxDownloadManager.SubThreadExecute', E);
  end;

end;

end.

//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxDownloadManager;

interface
uses
  Classes, NetHttpClient.Downloader, Net.HttpClient, Net.HttpClientComponent,
  System.Threading, system.Generics.Collections, system.SyncObjs,
  System.SysUtils;

type

  TOnCreateDownloader =
    procedure (Sender: Tobject; const ADownloader: TNetHttpDownloader) of object;

  TOnStartDownloader = TOnCreateDownloader;

  TDownloaderList = TList<TNetHttpDownloader>;
  TDownloaderObjList = TObjectList<TNetHttpDownloader>;

  TNBoxDownloadManager = class(TComponent)
    private
      FNowDestroy: boolean;
      FSynchronizeEvents: boolean;
      FLock: TCriticalSection;
      FMainTask: ITask;
      FQueue: TDownloaderList;
      FMaxThreadCount: int64;
      FOnCreateDownloader: TOnCreateDownloader;
      FOnStartDownloader: TOnStartDownloader;
      procedure SetMaxThreadCount(const value: int64);
      function GetMaxThreadCount: int64;
      procedure SetSynchronizeEvents(const value: boolean);
      function GetSynchronizeEvents: boolean;
      procedure StartMainTask;
      procedure CancelAll;
    public
      function AddDownload(AUrl: string; AFilename: string): TNetHttpDownloader;
      property MaxThreadCount: int64 read GetMaxThreadCount write SetMaxThreadCount default 5;
      property SynchronizeEvents: boolean read GetSynchronizeEvents write SetSynchronizeEvents default true;
      property OnCreateDownloader: TOnCreateDownloader read FOnCreateDownloader write FOnCreateDownloader;
      property OnStartDownloader: TOnStartDownloader read FOnStartDownloader write FOnStartDownloader;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

implementation
 uses unit1;
{ TNBoxDownloadManager }

function TNBoxDownloadManager.AddDownload(AUrl,
  AFilename: string): TNetHttpDownloader;
begin
  Result := TNetHttpDownloader.Create(Self);
  With Result do begin
    Url           := AUrl;
    Filename      := AFilename;
    AutoRetry       := true;
  end;

  if Assigned(OnCreateDownloader) then
    OnCreateDownloader(Self, Result);

  FLock.enter;
  try
    FQueue.Add(Result);
    if not Assigned(FMainTask) then
      StartMainTask;

  finally
    FLock.Leave;
  end;
end;

procedure TNBoxDownloadManager.CancelAll;
begin
  FLock.enter;
  try
    if Assigned(FMainTask) then begin
      FMainTask.Cancel;
    end;
  finally
    FLock.Leave;
  end;
end;

constructor TNBoxDownloadManager.Create(AOwner: TComponent);
begin
  inherited;
  FNowDestroy := false;
  FSynchronizeEvents := true;
  FLock := TCriticalSection.Create;
  FQueue := TDownloaderList.Create;
  Self.FMaxThreadCount := 5;
  FMainTask := nil;
end;

destructor TNBoxDownloadManager.Destroy;
var
  I: integer;
begin
  FLock.enter;
  try
    FNowDestroy := true;
    OnStartDownloader := nil;
  finally
    FLock.Leave;
  end;

  if Assigned(FMainTask) then begin
    CancelAll;
    if TThread.Current.ThreadID = MainThreadId then begin
      try
        while not TTask.WaitForAll([FMainTask], 100) do
          CheckSynchronize(10);
      except

      end;
    end;
  end;

  For I := 0 to FQueue.Count - 1 do
    FQueue[I].Free;
  FQueue.Clear;
  
  FLock.Free;
  FQueue.Free;
  inherited;
end;

function TNBoxDownloadManager.GetSynchronizeEvents: boolean;
begin
  FLock.Enter;
  try
    Result := FSynchronizeEvents;
  finally
    FLock.Leave;
  end;
end;

function TNBoxDownloadManager.GetMaxThreadCount: int64;
begin
  Result := TInterlocked.Read(FMaxThreadCount);
end;

procedure TNBoxDownloadManager.SetSynchronizeEvents(const value: boolean);
begin
  FLock.Enter;
  try
    FSynchronizeEvents := Value;
  finally
    FLock.Leave;
  end;
end;

procedure TNBoxDownloadManager.SetMaxThreadCount(const value: int64);
begin
  TInterLocked.Exchange(FMaxThreadCount, value);
end;

procedure TNBoxDownloadManager.StartMainTask;
begin
  FMainTask := TTask.Create(
  procedure
  var
    I, Count, Pos: integer;
    id: string;
    Loaders: TDownloaderObjList;
    LoadersUpdated: boolean;

    procedure Update;
    begin
      try
      FLock.enter;
      try
        LoadersUpdated := ( FQueue.Count > 0 );
        if LoadersUpdated then begin
          Loaders.AddRange(FQueue);
          FQueue.Clear;
        end;
      finally
        FLock.Leave;
      end;
      except on E: Exception do
        SyncLog(E, 'EXCEPTION: On Update: ');
      end;
    end;

    function CanStart(A: TNetHttpDownloader): boolean;
    begin
      Result := not ( A.IsAborted or A.IsRunning );
    end;

    function RunningCount: integer;
    var
      I: integer;
    begin
      Result := 0;
      for I := 0 to Loaders.Count - 1 do begin
        if Loaders[I].IsRunning then
          Inc(Result);
      end;
    end;

  begin
    try
    try
      id := TThread.Current.ThreadID.ToString;
      Loaders := TDownloaderObjList.Create;

      Update;

      Pos := 0;  // Loaders.Items[0]; - Starts from first item.
      while LoadersUpdated do begin
        LoadersUpdated := false;

        for I := Pos to Loaders.Count - 1 do begin
          var Item: TNetHttpDownloader;
          Item := Loaders[I];
          Pos := I;

          FMainTask.CheckCanceled;
          while ( RunningCount >= MaxThreadCount ) do begin
            FMainTask.CheckCanceled;
            Sleep(100);
          end;

          With Item do begin
            if CanStart(Item) then begin

              if Assigned(OnStartDownloader) then begin
                if SynchronizeEvents then
                  TThread.Synchronize(TThread.Current, procedure begin OnStartDownloader(Self, Item) end)
                else
                  OnStartDownloader(Self, Item);
              end;

              try
                Start;
              except
                On E: EXception do begin
                  SyncLog(E, 'Exception: Downloader On Start: ');
                end;
              end;

            end;
          end;

        end;

        while ( RunningCount > 0 ) do begin
          FMainTask.CheckCanceled;
          sleep(10);
          Update;
          if LoadersUpdated then begin
            Break;
          end;
        end;

      end;

    finally

      for I := 0 to Loaders.Count - 1 do begin
        if Loaders[I].IsRunning then
          Loaders.items[I].AbortRequest;
      end;

      while ( RunningCount > 0 ) do
        sleep(50);

      Loaders.Free;
      //SyncLog('Exit from TNBoxDownloadManager main thread');
      FLock.enter;
      try
        if not FNowDestroy then begin
          Count := FQueue.Count;

          if ( Count > 0 ) then
            StartMainTask
          else
            FMainTask := nil;
        end;
      finally
        FLock.Leave;
      end;

    end;
    except

      On E: EOperationCancelled do begin
        // ignore
      end;

      On E: exception do begin
        SyncLog(E, 'TNBoxDownloadManager: ');
      end;

    end;
  end);
  FmainTask.Start;
end;


end.

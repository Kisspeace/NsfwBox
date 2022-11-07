{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NetHttpClient.Downloader;

interface
uses
  System.Net.URLClient, System.Net.HttpClient, System.SyncObjs,
  System.Net.HttpClientComponent, SysUtils, classes, YDW.Threading,
  NsfwBox.Logging;

type

  TCreateWebClientEvent = procedure(const Sender: TObject; AWebClient: TNetHttpClient) of object;

  TDownloader = Class(TYdwReusableThread)
    protected
      FIsAborted: boolean;
      FAsynchronous: boolean;
      FSynchronizeEvents: boolean;
      FAutoRetry: boolean;
      FRetriedCount: int64;
      FRetryTimeout: int64; { Milliseconds Timeout before retry }
      FStream: TStream;     { ContentStream }
      FUrl: string;
      FContentLength: int64;
      FReadCount: int64;
      FOnRecievData: TReceiveDataEvent;
      FOnSendData: TSendDataEvent;
      FOnRequestException: TRequestExceptionEvent;
      FOnFinish: TNotifyEvent;
      FOnCreateWebClient: TCreateWebClientEvent;
      procedure DoOnFinish; virtual;
      procedure DoOnSendData(const Sender: TObject; AContentLength: Int64; AWriteCount: Int64; var AAbort: Boolean);
      procedure DoOnReceiveData(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var AAbort: Boolean); virtual;
      procedure DoOnCreateWebClient(AWebClient: TNetHttpClient);
      procedure Execute; override;
    private
      function SafeGet<T>(var AVar: T): T;
      procedure SafeSet<T>(var AVar: T; AValue: T);
      function GetIsAborted: boolean;
      procedure SetIsAborted(const Value: boolean);
      function GetAutoRetry: boolean;
      procedure SetAutoRetry(const Value: boolean);
      function GetRetryTimeout: int64;
      procedure SetRetryTimeout(const Value: int64);
      function GetUrl: string;
      procedure SetUrl(const Value: string);
      function GetReadCount: int64;
      procedure SetReadCount(const Value: int64);
      function GetContentLength: int64;
      procedure SetContentLength(const Value: int64);
      function GetSynchronizeEvents: boolean;
      procedure SetSynchronizeEvents(const Value: boolean);
      function GetRetriedCount: int64;
      function GetIsRunning: boolean;
    public
      procedure Start; virtual;
      procedure AbortRequest;
      property Stream: TStream read FStream write FStream;
      property IsRunning: boolean read GetIsRunning;
      property IsAborted: boolean read GetIsAborted write SetIsAborted;
      property AutoRetry: boolean read GetAutoRetry write SetAutoRetry;
      property RetriedCount: int64 read GetRetriedCount;
      property RetryTimeout: int64 read GetRetryTimeout write SetRetryTimeout;
      property SynchronizeEvents: boolean read GetSynchronizeEvents write SetSynchronizeEvents;
      property Url: string read GetUrl write SetUrl;
      property ReadCount: int64 read GetReadCount write SetReadCount;
      property ContentLength: int64 read GetContentLength write SetContentLength;
      property OnReceiveData: TReceiveDataEvent read FOnRecievData write FOnRecievData;
      property OnSendData: TSendDataEvent read FOnSendData write FOnSendData;
      property OnRequestException: TRequestExceptionEvent read FOnRequestException write FOnRequestException;
      property OnCreateWebClient: TCreateWebClientEvent read FOnCreateWebClient write FOnCreateWebClient;
      property OnFinish: TNotifyEvent read FOnFinish write FOnFinish;
      Constructor Create; override;
      Destructor Destroy; override;
  End;

  TFileDownloader = class(TDownloader)
    protected
      FFilename: string;
      procedure DoOnFinish; override;
    private
      procedure SetFilename(const Value: string);
      function GetFilename: string;
    public
      procedure Start; override;
      property Filename: string read GetFilename write SetFilename;
  end;

  TNetHttpDownloader = TFileDownloader;

implementation
uses Unit1;
{ TDownloader }

procedure TDownloader.AbortRequest;
begin
  IsAborted := True;
end;

constructor TDownloader.Create;
begin
  inherited;
  FStream := nil;
  FIsAborted := False;
  FAutoRetry := True;
  FRetryTimeout := 1000;
  FUrl := '';
  FContentLength := 0;
  FRetriedCount := 0;
  FReadCount := 0;
end;

destructor TDownloader.Destroy;
begin
  if IsRunning then
    Self.AbortRequest;

  while IsRunning do begin
    if System.MainThreadID = TThread.Current.ThreadID then
      CheckSynchronize(0);
    Sleep(10);
  end;

  inherited;
end;


function TDownloader.GetAutoRetry: boolean;
begin
  Result := SafeGet(FAutoRetry);
end;

function TDownloader.GetContentLength: int64;
begin
  Result := SafeGet(FContentLength);
end;

function TDownloader.GetIsAborted: boolean;
begin
  Result := SafeGet(FIsAborted);
end;

function TDownloader.GetIsRunning: boolean;
begin
  Result := Inherited;
end;

function TDownloader.GetReadCount: int64;
begin
  Result := SafeGet(FReadCount);
end;

function TDownloader.GetRetriedCount: int64;
begin
  Result := SafeGet(FRetriedCount);
end;

function TDownloader.GetRetryTimeout: int64;
begin
  Result := SafeGet(FRetryTimeout);
end;

function TDownloader.GetSynchronizeEvents: boolean;
begin
  Result := SafeGet(FSynchronizeEvents);
end;

function TDownloader.GetUrl: string;
begin
  Result := SafeGet(Furl);
end;

procedure TDownloader.DoOnCreateWebClient(AWebClient: TNetHttpClient);
begin
  if not Assigned(OnCreateWebClient) then exit;
  if SynchronizeEvents then
    TThread.Synchronize(nil, procedure begin OnCreateWebClient(Self, AWebClient); end)
  else
    OnCreateWebClient(Self, AWebClient);
end;

procedure TDownloader.DoOnFinish;
begin
  if not Assigned(OnFinish) then exit;
  if SynchronizeEvents then
    Tthread.Synchronize(nil, procedure begin OnFinish(Self); end)
  else
    OnFinish(Self);
end;

procedure TDownloader.DoOnReceiveData(const Sender: TObject; AContentLength,
  AReadCount: Int64; var AAbort: Boolean);
begin
  Flock.BeginWrite;
  try
    FReadCount := AReadCount;
    FContentLength := AContentLength;
    AAbort := FIsAborted;
  finally
    FLock.EndWrite;
  end;

  if not Assigned(OnReceiveData) then exit;
  if SynchronizeEvents then begin
    var PseudoAbort := AAbort;
    TThread.Synchronize(nil, procedure begin OnReceiveData(Self, AContentLength, AReadCount, PseudoAbort); end);
  end else
    OnReceiveData(Self, AContentLength, AReadCount, AAbort);
end;

procedure TDownloader.DoOnSendData(const Sender: TObject; AContentLength,
  AWriteCount: Int64; var AAbort: Boolean);
begin
  Aabort := IsAborted;
  if not Assigned(OnSendData) then exit;
  if SynchronizeEvents then begin
    var PseudoAbort := AAbort;
    TThread.Synchronize(Tthread.Current, procedure begin OnSendData(Self, AContentLength, AWriteCount, PseudoAbort); end);
  end else
    OnSendData(Self, AContentLength, AWriteCount, AAbort);
end;

procedure TDownloader.Execute;
var
  LWebClient: TNetHttpClient;
begin
  try
    LWebClient := TNetHttpClient.Create(Nil);
    try
      DoOnCreateWebClient(LWebClient);

      with LWebClient do begin
        Asynchronous := false;
        SynchronizeEvents := false;
        OnReceiveData := Self.DoOnReceiveData;
        OnSendData := Self.DoOnSendData;
      end;

      while TRUE do begin

        if IsAborted then
          TThread.Current.Terminate;

        if TThread.Current.CheckTerminated then exit;

        try
          LWebClient.GetRange(Url, FStream.Position, -1, FStream);
        except
          On E: Exception do begin

            if Assigned(OnRequestException) then
              OnRequestException(Self, E);

            if AutoRetry and ( not IsAborted ) then begin

              FLock.BeginWrite;
              try
                inc(FRetriedCount);
              finally
                FLock.EndWrite;
              end;

              Sleep(RetryTimeout);
              Continue;
            end;

          end;

        end;
        Break;
      end;

    finally

      LWebClient.Free;
      DoOnFinish;

    end;
  except
    On E: Exception do
      Log('TDownloader.Execute', E);
  end;
end;

function TDownloader.SafeGet<T>(var AVar: T): T;
begin
  FLock.BeginRead;
  try
    Result := AVar;
  finally
    FLock.EndRead;
  end;
end;

procedure TDownloader.SafeSet<T>(var AVar: T; AValue: T);
begin
  FLock.BeginWrite;
  try
    AVar := AValue;
  finally
    FLock.EndWrite;
  end;
end;

procedure TDownloader.SetAutoRetry(const Value: boolean);
begin
  SafeSet(FAutoRetry, value);
end;

procedure TDownloader.SetContentLength(const Value: int64);
begin
  SafeSet(FContentLength, Value);
end;

procedure TDownloader.SetIsAborted(const Value: boolean);
begin
  SafeSet(FIsAborted, value);
end;

procedure TDownloader.SetReadCount(const Value: int64);
begin
  SafeSet(FReadCount, Value);
end;

procedure TDownloader.SetRetryTimeout(const Value: int64);
begin
  SafeSet(FRetryTimeout, value);
end;

procedure TDownloader.SetSynchronizeEvents(const Value: boolean);
begin
  SafeSet(FSynchronizeEvents, Value);
end;

procedure TDownloader.SetUrl(const Value: string);
begin
  FLock.BeginWrite;
  try
    FUrl := Value;
  finally
    FLock.EndWrite;
  end;
end;

procedure TDownloader.Start;
begin
  if IsRunning then exit;
  FLock.BeginWrite;
  try
    FIsAborted := False;
  finally
    FLock.EndWrite;
  end;
  inherited Start;
end;

{ TFileDownloader }

procedure TFileDownloader.DoOnFinish;
begin
  if Assigned(FStream) then
    FStream.Free;
  inherited;
end;

function TFileDownloader.GetFilename: string;
begin
  Result := SafeGet(FFilename);
end;

procedure TFileDownloader.SetFilename(const Value: string);
begin
  FLock.BeginWrite;
  try
    FFilename := Value;
  finally
    FLock.EndWrite;
  end;
end;

procedure TFileDownloader.Start;
begin
  if IsRunning then exit;
  FLock.BeginWrite;
  try
    FStream := TFileStream.Create(FFilename, FmCreate);
  finally
    Flock.EndWrite;
  end;
  inherited;
end;

end.

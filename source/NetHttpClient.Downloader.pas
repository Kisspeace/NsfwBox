//♡2022 by Kisspeace. https://github.com/kisspeace
unit NetHttpClient.Downloader;

interface
uses
  System.Net.URLClient, System.Net.HttpClient, System.SyncObjs,
  System.Net.HttpClientComponent, SysUtils, classes, System.Threading;

type

  TCreateWebClientEvent = procedure(const Sender: TObject; AWebClient: TNetHttpClient) of object;

  TDownloader = Class(TComponent)
    protected
      FTask: ITask;
      FLock: TCriticalSection;
      FIsRunning: boolean;
      FIsAborted: boolean;
      FAsynchronous: boolean;
      FSynchronizeEvents: boolean;
      FAutoRetry: boolean;
      FRetriedCount: int64;
      FRetryTimeout: int64;        // Milliseconds Timeout before retry
      FStream: TStream;            // ContentStream
      FUrl: string;
      FLostConnectionCount: int64;
      FContentLength: int64;
      FReadCount: int64;
      procedure DoOnFinish; virtual;
      procedure DoOnSendData(const Sender: TObject; AContentLength: Int64; AWriteCount: Int64; var AAbort: Boolean);
      procedure DoOnReceiveData(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var AAbort: Boolean); virtual;
    private
      FOnRecievData: TReceiveDataEvent;
      FOnSendData: TSendDataEvent;
      FOnRequestException: TRequestExceptionEvent;
      FOnFinish: TNotifyEvent;
      FOnCreateWebClient: TCreateWebClientEvent;
      procedure SafeSet(var AVar: boolean; ANew: boolean); overload;
      procedure SafeSet(var AVar: string; ANew: string);   overload;
      procedure SafeSet(var AVar: int64; ANew: int64);     overload;
      function SafeGet(var AVar: boolean): boolean;        overload;
      function SafeGet(var AVar: string): string;          overload;
      function SafeGet(var AVar: int64): int64;            overload;
      //--setters getters--
      function GetIsRunning: boolean;
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
      Constructor Create(AOwner: TComponent);
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
  uses unit1;
{ TDownloader }

procedure TDownloader.AbortRequest;
begin
  IsAborted := true;
end;

constructor TDownloader.Create(AOwner: TComponent);
begin
  inherited;
  FLock := TCriticalSection.Create;
  FTask := nil;
  FStream := nil;
  FIsRunning := false;
  FIsAborted := false;
  FAutoRetry := true;
  FRetryTimeout := 1400;
  FUrl := '';
  FContentLength := 0;
  FRetriedCount := 0;
  FReadCount := 0;
  FLostConnectionCount := 0;
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

  Flock.Free;
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
  Result := SafeGet(FIsRunning);
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

procedure TDownloader.DoOnFinish;
begin
  if Assigned(OnFinish) then begin
    if SynchronizeEvents then
      Tthread.Synchronize(TTHread.Current, procedure begin OnFinish(Self); end)
    else
      OnFinish(Self);
  end;
end;

procedure TDownloader.DoOnReceiveData(const Sender: TObject; AContentLength,
  AReadCount: Int64; var AAbort: Boolean);
begin
  Flock.Enter;
  try
    FReadCount := AReadCount;
    FContentLength := AContentLength;
    Aabort := FIsAborted;
  finally
    FLock.Leave;
    if Assigned(OnReceiveData) then begin
      if SynchronizeEvents then begin
        var PseudoAbort := AAbort;
        TThread.Synchronize(Tthread.Current, procedure begin OnReceiveData(Self, AContentLength, AReadCount, PseudoAbort); end);
      end else
        OnReceiveData(Self, AContentLength, AReadCount, AAbort);
    end;
  end;
end;

procedure TDownloader.DoOnSendData(const Sender: TObject; AContentLength,
  AWriteCount: Int64; var AAbort: Boolean);
begin
  Aabort := IsAborted;
  if Assigned(OnSendData) then begin
    if SynchronizeEvents then begin
      var PseudoAbort := AAbort;
      TThread.Synchronize(Tthread.Current, procedure begin OnSendData(Self, AContentLength, AWriteCount, PseudoAbort); end);
    end else
      OnSendData(Self, AContentLength, AWriteCount, AAbort);
  end;
end;

function TDownloader.SafeGet(var AVar: boolean): boolean;
begin
  FLock.Enter;
  try
    Result := Avar;
  finally
    FLock.Leave;
  end;
end;

function TDownloader.SafeGet(var AVar: string): string;
begin
  FLock.Enter;
  try
    Result := Avar;
  finally
    FLock.Leave;
  end;
end;

function TDownloader.SafeGet(var AVar: int64): int64;
begin
  FLock.Enter;
  try
    Result := Avar;
  finally
    FLock.Leave;
  end;
end;

procedure TDownloader.SafeSet(var AVar: boolean; ANew: boolean);
begin
  FLock.Enter;
  try
    AVar := ANew;
  finally
    FLock.Leave;
  end;
end;

procedure TDownloader.SafeSet(var AVar: string; ANew: string);
begin
  FLock.Enter;
  try
    AVar := ANew;
  finally
    FLock.Leave;
  end;
end;

procedure TDownloader.SafeSet(var AVar: int64; ANew: int64);
begin
  FLock.Enter;
  try
    AVar := ANew;
  finally
    FLock.Leave;
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
  FLock.Enter;
  try
    if not FIsRunning then
      Furl := Value;
  finally
    FLock.Leave;
  end;
end;

procedure TDownloader.Start;
begin
  if IsRunning then exit;
  FLock.Enter;
  try
    FIsRunning := true;
    FIsAborted := false;
  finally
    FLock.Leave;
  end;

  FTask := TTask.Create(
  procedure
  var
    WebClient: TNetHttpClient;
    GotError: boolean;
  begin
    try
      try
        WebClient := TNetHttpClient.Create(Self);

        if Assigned(OnCreateWebClient) then begin
          if SynchronizeEvents then
            TThread.Synchronize(TThread.Current, procedure begin OnCreateWebClient(Self, WebClient); end)
          else
            OnCreateWebClient(Self, WebClient);
        end;

        with WebClient do begin
          Asynchronous := false;
          SynchronizeEvents := false;
          OnReceiveData := Self.DoOnReceiveData;
          OnSendData := Self.DoOnSendData;
        end;

        while true do begin
          GotError := false;

          if IsAborted then
            FTask.Cancel;

          FTask.CheckCanceled;
          try
            var StartPos: int64;

            if FStream.Size < 1 then
              StartPos := 0
            else begin
              StartPos := FStream.Size;
              FStream.Position := StartPos;
            end;

            WebClient.GetRange(Url, StartPos, -1, FStream);
          except
            On E: Exception do begin
              GotError := true;

              if Assigned(OnRequestException) then
                OnRequestException(Self, E);

              if AutoRetry and ( not IsAborted ) then begin

                Flock.Enter;
                try
                  inc(FRetriedCount);
                finally
                  Flock.Leave;
                end;

                Sleep(RetryTimeout);
                Continue;
              end;

            end;
            
          end;
          Break;
        end;

      finally
        Flock.Enter;
        try
          FIsRunning := false;
          FTask := nil;
        finally
          FLock.Leave;
          DoOnFinish;
        end;
      end;
    except

    end;
  end);
  FTask.Start;
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
  FLock.Enter;
  try
    if not FIsRunning then
      FFilename := Value;
  finally
    FLock.Leave;
  end;
end;

procedure TFileDownloader.Start;
begin
  if IsRunning then exit;
  FLock.Enter;
  try
    FStream := TFileStream.Create(FFilename, FmCreate);
  finally
    Flock.Leave;
  end;
  inherited;
end;

end.

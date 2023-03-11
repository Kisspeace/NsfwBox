{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit DbHelper;

interface
uses
  classes, system.sysutils, System.IOUtils,
  ZConnection, ZSQLUpdate, ZSQLProcessor, ZClasses,
  ZExceptions, ZPlainSqLiteDriver, ZDataset,
  NsfwBox.Filesystem, NsfwBox.Logging;

type

  TDbHelper = class(TObject)
    private const
      TRY_TIMEOUT = 10;
    protected
      Query: TZQuery;
      SqlProc: TZSQLProcessor;
      procedure SetFilename(const value: string);
      function GetFilename: string;
      function BaseExists: boolean;
      procedure CreateBase; virtual; abstract;
      function TryExecSql: boolean;
      procedure ForceExecScript;
      procedure ForceExecSql;
      procedure ForceOpen;
    public
      Connection: TZConnection;
      procedure ForceConnect;
      property Filename: string read GetFilename write SetFilename;
      constructor Create(ADbFilename: string); virtual;
      destructor Destroy; virtual;
  end;

implementation

{ TDbListManager }

function TDbHelper.BaseExists: boolean;
begin
  Result := FileExists(Connection.Database);
end;

constructor TDbHelper.Create(ADbFilename: string);
begin
  Connection := TZConnection.Create(nil);
  Query := TZQuery.Create(nil);
  Query.Connection := Connection;
  SqlProc := TZSQLProcessor.Create(nil);
  SqlProc.Connection := Connection;

  with Connection do begin
    {$IFDEF ANDROID}
      Connection.LibraryLocation := TNBoxPath.GetLibPath('libsqliteX.so');
    {$ENDIF}
    Protocol := 'sqlite';
    ClientCodepage := 'UTF-8';
    Database := ADbFilename;
    Password := '';
    User     := '';
  end;

  if not BaseExists then begin
    Connection.Connect;
    CreateBase;
  end;
end;

destructor TDbHelper.Destroy;
begin
  if connection.Connected then
    Connection.Disconnect;

  Connection.Free;
  SqlProc.Free;
  Query.Free;
end;

procedure TDbHelper.ForceConnect;
begin
  while True do begin
    try
      Self.Connection.Connect;
      break;
    except
      On E: EZSQLException do begin
        if not (E.ErrorCode = SQLITE_BUSY) then
          Raise
      end;
    end;
  end;
end;

procedure TDbHelper.ForceExecScript;
begin
  while True do begin
    try
      SqlProc.Execute;
      break;
    except
      On E: EZSQLException do begin
        if not (E.ErrorCode = SQLITE_BUSY) then
          Raise
      end;
    end;
  end;
end;

procedure TDbHelper.ForceExecSql;
begin
  while not Self.TryExecSql do sleep(TRY_TIMEOUT);
end;

procedure TDbHelper.ForceOpen;
begin
  try
  while True do begin
    try
      Self.Query.Open;
      break;
    except
      On E: EZSQLException do begin
        if not (E.ErrorCode = SQLITE_BUSY) then
          Raise
      end;
    end;
  end;
  except
    On E: Exception do begin
      Log('TDbHelper.ForceOpen', E);
      raise;
    end;
  end;
end;

function TDbHelper.GetFilename: string;
begin
  Result := Connection.Database;
end;

procedure TDbHelper.SetFilename(const value: string);
begin
  Connection.Database := Value;
end;

function TDbHelper.TryExecSql: boolean;
begin
  try
    Self.Query.ExecSQL;
    Result := True;
  except
    On E: EZSQLException do begin
      if not (E.ErrorCode = SQLITE_BUSY) then
        Raise
    end;
  end;
end;

end.

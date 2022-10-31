{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit DbHelper;

interface
uses
  ZConnection, DB, classes, system.sysutils,
  ZDataset, System.IOUtils, NsfwBox.Filesystem;

type

  TDbHelper = class(TObject)
    protected
      Query: TZQuery;
      procedure SetFilename(const value: string);
      function GetFilename: string;
      function BaseExists: boolean;
      procedure CreateBase; virtual; abstract;
    public
      Connection: TZConnection;
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
  Query.Free;
end;

function TDbHelper.GetFilename: string;
begin
  Result := Connection.Database;
end;

procedure TDbHelper.SetFilename(const value: string);
begin
  Connection.Database := Value;
end;

end.

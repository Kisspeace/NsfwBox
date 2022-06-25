//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxBookmarks;

interface
uses
  System.SysUtils, System.Classes, XSuperObject, DbHelper,
  DB, NsfwBoxInterfaces, NsfwBoxOriginPseudo, NsfwBoxOriginNsfwXxx,
  NsfwBoxOriginR34App, NsfwBoxOriginR34JsonApi, NsfwBoxOriginConst;

type

  TNBoxBookmarkType = ( Content, SearchRequest );
  TNBoxBookmarksDb = class;

  TNBoxBookmark = class(TInterfacedPersistent, IHasOrigin)
    private
      FId: int64;
      FTableName: string;
      FObj: TInterfacedPersistent;
      FOrigin: integer;
      FBookmarkType: TNBoxBookmarkType;
      FAbout: string;
      FTime: TDateTime;
      function GetBookmarkType: TNBoxBookmarkType;
      function GetOrigin: integer;
      function GetTime: TDateTime;
      procedure SetObj(const value: TInterfacedPersistent);
    public
      property Id: int64 read FId write FId;
      property Tablename: string read FTableName write FTableName;
      property Obj: TInterfacedPersistent read FObj write SetObj;
      property Time: TDateTime read GetTime write FTime;
      property About: string read FAbout write FAbout;
      property Origin: integer read GetOrigin write FOrigin;
      property BookmarkType: TNBoxBookmarkType read GetBookmarkType write FBookmarkType;
      function IsRequest: boolean;
      function AsItem: INBoxItem;
      function AsRequest: INBoxSearchRequest;
      constructor Create(AItem: INBoxItem); overload;
      constructor Create(AItem: INBoxSearchRequest); overload;
      constructor Create; overload;
  end;

  TBookmarkAr = TArray<TNBoxBookmark>;

  TBookmarkGroupRec = record
    private
      FDb: TNBoxBookmarksDb;
    public
      Id: int64;
      Name: string;
      About: string;
      Timestamp: TDateTime;
      procedure Add(A: TNBoxBookmark);           overload;
      procedure Add(AValue: INBoxItem);          overload;
      procedure Add(AValue: INBoxSearchRequest); overload;
      function GetPage(APageNum: integer = 1): TBookmarkAr;
      function Get(AStart, AEnd: integer): TBookmarkAr;
      procedure DeleteGroup;
      procedure Delete(ABookmarkId: int64);
      function GetMaxId: int64;
      procedure UpdateGroup;
  end;

  TBookmarkGroupRecAr = TArray<TBookmarkGroupRec>;

  TNBoxBookmarksDb = class(TDbHelper)
    protected
      FPageSize: integer;
      procedure CreateBase; override;
      function ReadGroup: TBookmarkGroupRec;
    public
      property PageSize: integer read FPageSize write FPageSize;
      function GetBookmarksGroups: TBookmarkGroupRecAr;
      function GetGroupById(AGroupId: int64): TBookmarkGroupRec;
      procedure UpdateGroup(AGroupId: int64; ANew: TBookmarkGroupRec);
      function AddGroup(AName, AAbout: string): TBookmarkGroupRec;
      function GetLastGroup: TBookmarkGroupRec;
      procedure DeleteGroup(AGroupId: Int64);
      procedure DeleteAllGroups;
      procedure Delete(ABookmarkId: int64);
      procedure Add(AGroupId: int64; A: TNBoxBookmark);           overload;
      procedure Add(AGroupId: int64; AValue: INBoxItem);          overload;
      procedure Add(AGroupId: int64; AValue: INBoxSearchRequest); overload;
      function GetMaxId(AGroupId: int64): int64;
      function GetPage(AGroupId: int64; APageNum: integer = 1): TBookmarkAr;
      function Get(AGroupId: int64; AStart, AEnd: integer): TBookmarkAr;
      constructor Create(ADbFilename: string); override;
  end;

  TNBoxBookmarksHistoryDb = class(TNBoxBookmarksDb)
  private const
    NAME_SEARCH_HISTORY   = 'search history';
    NAME_TAP_HISTORY      = 'tap history';
    NAME_DOWNLOAD_HISTORY = 'download history';
  private
    FSearchTable: TBookmarkGroupRec;
    FTapTable: TBookmarkGroupRec;
    FDownloadTable: TBookmarkGroupRec;
  protected
    procedure CreateBase; override;
  public
    property SearchGroup: TBookmarkGroupRec read FSearchTable;
    property TapGroup: TBookmarkGroupRec read FTapTable;
    property DownloadGroup: TBookmarkGroupRec read FDownloadTable;
    constructor Create(ADbFilename: string); override;
  end;


implementation
uses NsfwBoxHelper, unit1;
{ TNBoxBookmark }

constructor TNBoxBookmark.Create(AItem: INBoxSearchRequest);
begin
  Obj := ( Aitem as TInterfacedPersistent );
end;

constructor TNBoxBookmark.Create(Aitem: INBoxItem);
begin
  Obj := ( Aitem as TInterfacedPersistent );
end;

function TNBoxBookmark.AsItem: INBoxItem;
begin
  if Supports(Obj, INBoxItem) then
    Result := ( Obj as INBoxItem )
  else
    Result := nil;
end;

function TNBoxBookmark.AsRequest: INBoxSearchRequest;
begin
  if Supports(Obj, INBoxSearchRequest) then
    Result := ( Obj as INBoxSearchRequest )
  else
    Result := nil;
end;


constructor TNBoxBookmark.Create;
begin
  FObj := nil;
end;

function TNBoxBookmark.GetBookmarkType: TNBoxBookmarkType;
begin
  Result := FBookmarkType;
end;


function TNBoxBookmark.GetOrigin: integer;
begin
  Result := FOrigin;
end;

function TNBoxBookmark.GetTime: TDateTime;
begin
  Result := FTime;
end;

function TNBoxBookmark.IsRequest: boolean;
var
  Req: INboxSearchRequest;
begin
  Req := AsRequest;
  Result := Assigned(Req);
end;

procedure TNBoxBookmark.SetObj(const value: TInterfacedPersistent);
begin
  FObj := Value;
  if Assigned(Obj) then begin

    Origin := (Obj as IHasOrigin).Origin;

    if Supports(Obj, INboxItem) then
      BookmarkType := Content
    else
      BookmarkType := SearchRequest;

  end;
end;

{ TNBoxBookmarksDb }

procedure TNBoxBookmarksDb.Add(AGroupId: int64; A: TNBoxBookmark);
begin
  if not Connection.Connected then
    Connection.Connect;

  With Query do begin
    Query.SQL.AddStrings([
      'INSERT INTO `items` (`group_id`, `origin`, `type`, `about`, `object`)',
      'VALUES',
      '  (:group_id, :origin, :type, :about, :object);'
    ]);
    Params.ParamByName('group_id').AsInt64  := AGroupId;
    Params.ParamByName('origin').AsInteger  := A.Origin;
    Params.ParamByName('type').AsInteger    := ord(A.FBookmarkType);
    Params.ParamByName('about').AsString    := A.About;
    //Params.ParamByName('timestamp').AsDateTime := A.Time;
    Params.ParamByName('object').AsString := A.Obj.AsJSON(false);
    ExecSQL;
    SQL.Clear;
  end;
end;

procedure TNBoxBookmarksDb.Add(AGroupId: int64; AValue: INBoxSearchRequest);
var
  B: TNboxBookmark;
begin
  try
    B := TNBoxBookmark.Create(AValue);
    B.Time := Now;
    Add(AGroupId, B);
  finally
    B.Free;
  end;
end;

procedure TNBoxBookmarksDb.Add(AGroupId: int64; AValue: INBoxItem);
var
  B: TNboxBookmark;
begin
  try
    B := TNBoxBookmark.Create(AValue);
    B.Time := Now;
    Add(AGroupId, B);
  finally
    B.Free;
  end;
end;

function TNBoxBookmarksDb.AddGroup(AName, AAbout: string): TBookmarkGroupRec;
var
  NewId: int64;
  TableName: string;
begin
  if not Connection.Connected then
    Connection.Connect;

  Result.FDb := self;
  Result.Name := AName;
  Result.About := AAbout;
  Result.Timestamp := now;
  Result.Id := 0;

  with Query do begin
    SQL.AddStrings([
      'INSERT INTO `groups` (`name`, `about`)',
      'VALUES (:name, :about);'
    ]);
    Params.ParamByName('name').AsString  := AName;
    Params.ParamByName('about').AsString := AAbout;
    ExecSQL;
    SQL.Clear;
  end;

  Result := Self.GetLastGroup;
end;

constructor TNBoxBookmarksDb.Create(ADbFilename: string);
begin
  inherited;
  FPageSize := 25;
end;

procedure TNBoxBookmarksDb.CreateBase;
begin
  Query.SQL.AddStrings([
    'CREATE TABLE `groups` (',
    '  `id`        INTEGER PRIMARY KEY AUTOINCREMENT,',
    '  `name`      VARCHAR(255),',
    '  `timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP,',
    '  `about`     TEXT',
    ');'
  ]);
  Query.ExecSQL;
  Query.SQL.Clear;

  Query.SQL.AddStrings([
    'CREATE TABLE `items` (',
    '  `origin`    INTEGER,',
    '  `type`      INTEGER,',
    '  `about`     TEXT,',
    '  `timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP,',
    '  `object`    JSON,',
    '  `group_id`  INTEGER DEFAULT 1,',
    '  FOREIGN KEY(group_id) REFERENCES `groups` (id)',
    ');'
  ]);
  Query.ExecSQL;
  Query.SQL.Clear;

  Query.SQL.AddStrings([
    'CREATE VIEW `only_content` AS',
    '  SELECT * FROM `items` WHERE (`type` = 0);'
  ]);
  Query.ExecSQL;
  Query.SQL.Clear;

  Query.SQL.AddStrings([
    'CREATE VIEW `only_requests` AS',
    '  SELECT * FROM `items` WHERE (`type` = 1);'
  ]);
  Query.ExecSQL;
  Query.SQL.Clear;
end;

procedure TNBoxBookmarksDb.Delete(ABookmarkId: int64);
begin
  if not Connection.Connected then
    Connection.Connect;

  Query.SQL.Text := 'DELETE FROM `items` WHERE ( `rowid` = :id);';
  Query.Params.ParamByName('id').AsInt64 := ABookmarkId;
  Query.ExecSQL;
  Query.SQL.Clear;
end;

procedure TNBoxBookmarksDb.DeleteAllGroups;
var
  I: integer;
  Tables: TBookmarkGroupRecAr;
begin
  if not Connection.Connected then
    Connection.Connect;

  Tables := Self.GetBookmarksGroups;
  for I := low(Tables) to high(Tables) do
    Tables[I].DeleteGroup;
end;                            

procedure TNBoxBookmarksDb.DeleteGroup(AGroupId: Int64);
begin
  if not Connection.Connected then
    Connection.Connect;

  with Query do begin
    SQL.Text := 'DELETE FROM `items` WHERE ( `group_id` = :id );';
    Params.ParamByName('id').AsInt64 := AGroupId;
    ExecSql;

    SQL.Text := 'DELETE FROM `groups` WHERE ( `id` = :id );';
    Params.ParamByName('id').AsInt64 := AGroupId;
    ExecSql;

    SQL.Clear;
  end;
end;

function TNBoxBookmarksDb.Get(AGroupId: int64; AStart, AEnd: integer): TBookmarkAr;
var
  I, Pos: integer;
  Bookmark: TNBoxBookmark;
  Json: string;
  tmp: TInterfacedPersistent;
begin
  Result := [];
  Pos := 1;

  if not Connection.Connected then
    Connection.Connect;

  Query.SQL.Text := 'SELECT `rowid` AS id, * FROM `items` WHERE ( `group_id` = ' + AGroupId.ToString + ' ) LIMIT ' + AStart.ToString + ', ' + (AEnd - AStart).ToString + ';';
  Query.Open;

  Query.First;
  while ( not Query.Eof ) do begin
    Bookmark := TNBoxBookmark.Create;

    with Bookmark do begin

      Id := Query.FieldByName('id').AsLargeInt;
      Origin := Query.FieldByName('origin').AsInteger;
      BookmarkType := TNBoxBookmarkType(Query.FieldByName('type').AsInteger);
      json := Query.FieldByName('object').AsString;

      case bookmarktype of

        Content: begin
          var Post: INBoxItem;
          Post := CreateItemByOrigin(Origin);
          tmp := (Post as TInterfacedPersistent);
          tmp.AssignFromJSON(Json);
          Bookmark.Obj := tmp;
        end;

        SearchRequest: begin
          var Req: INBoxSearchRequest;
          Req := CreateReqByOrigin(Origin);
          tmp := (Req as TInterfacedPersistent);
          tmp.AssignFromJSON(Json);
          Bookmark.Obj := tmp;
        end;

      end;

    end;

    Result := Result + [ Bookmark ];
    Query.Next;
    inc(Pos);

  end;

  Query.Close;
  Query.SQL.Clear;
end;

function TNBoxBookmarksDb.GetBookmarksGroups: TBookmarkGroupRecAr;
var
  Rec: TBookmarkGroupRec;
begin
  Result := [];

  if not Connection.Connected then
    Connection.Connect;

  Query.SQL.Text := 'SELECT * FROM `groups`;';
  Query.Open;
  Query.First;

  while ( not Query.Eof ) do begin
    Rec := Self.ReadGroup;
    Result := Result + [Rec];
    Query.Next;
  end;

  Query.Close;
  Query.SQL.Clear;
end;

function TNBoxBookmarksDb.GetMaxId(AGroupId: Int64): int64;
begin
  if not Connection.Connected then
    Connection.Connect;

  Result := -1;
  Query.SQL.Text := 'SELECT `rowid` FROM `items` WHERE ( `group_id` = ' + AGroupId.ToString + ' ) ORDER BY `rowid` DESC LIMIT 1;';
  Query.Open;
  try
    Query.First;
    Result := Query.FieldByName('rowid').AsLargeInt;
  except
    Result := -1;
  end;
  Query.Close;
  Query.SQL.Clear;
end;
//
//function TNBoxBookmarksDb.GetGroupById(AId: int64): TBookmarkGroupRec;
//var
//  Tables: TBookmarkTableRecAr;
//  I: integer;
//begin
//  Tables := Self.GetBookmarksTables;
//  for i := Low(Tables) to High(Tables) do begin
//    if Tables[I].Id = AId then begin
//      Result := Tables[I];
//      exit;
//    end;
//  end;
//  Result.Id := -1;
//end;

function TNBoxBookmarksDb.GetPage(AGroupId: int64; APageNum: integer): TBookmarkAr;
var
  LStart, LEnd: integer;
begin
  LStart := (APageNum - 1) * PageSize;
  if LStart < 1 then
    LStart := 1;
  LEnd   := LStart + PageSize;
  Result := Get(AGroupId, LStart, LEnd);
end;

function TNBoxBookmarksDb.ReadGroup: TBookmarkGroupRec;
begin
  With Result do begin
    Id := Query.FieldByName('id').AsLargeInt;
    Name := Query.FieldByName('name').AsString;
    About := Query.FieldByName('about').AsString;
    Timestamp := StrToDateTime(Query.FieldByName('timestamp').AsString);
    FDb := Self;
  end;
end;

function TNBoxBookmarksDb.GetGroupById(AGroupId: int64): TBookmarkGroupRec;
begin
  if not Connection.Connected then
    Connection.Connect;

  with Query do begin
    SQL.Text := 'SELECT * FROM `groups` WHERE ( `id` = :id );';
    Params.ParamByName('id').AsInt64 := AGroupId;
    Open;
    try
      First;
      Result := Self.ReadGroup;
    finally
      Close;
      SQL.Clear;
    end;
  end;
end;

function TNBoxBookmarksDb.GetLastGroup: TBookmarkGroupRec;
begin
  if not Connection.Connected then
    Connection.Connect;

  With Query do begin
    SQL.Text := 'SELECT * FROM `groups` ORDER BY `id` DESC LIMIT 1;';
    Open;
    try
      First;
      Result := Self.ReadGroup;
    finally
      Close;
      SQL.Clear;
    end;
  end;
end;

procedure TNBoxBookmarksDb.UpdateGroup(AGroupId: int64; ANew: TBookmarkGroupRec);
begin
  if not Connection.Connected then
    Connection.Connect;

  with Query do begin
    SQL.AddStrings([
      'UPDATE `groups`',
      'SET `name` = :name,',
      '    `about` = :about,',
      '    `timestamp` = :timestamp',
      'WHERE ( `id` = :id );'
    ]);
    Params.ParamByName('name').AsString := ANew.Name;
    Params.ParamByName('about').AsString := ANew.About;
    Params.ParamByName('timestamp').AsDateTime := ANew.Timestamp;
    Params.ParamByName('id').AsInt64 := AGroupId;
    ExecSql;
    SQL.Clear;
  end;
end;

{ TBookmarkGroupRec }

procedure TBookmarkGroupRec.Add(A: TNBoxBookmark);
begin
  FDb.Add(Id, A);
end;

procedure TBookmarkGroupRec.Add(AValue: INBoxItem);
begin
  FDb.Add(Id, AValue);
end;

procedure TBookmarkGroupRec.Add(AValue: INBoxSearchRequest);
begin
  FDb.Add(Id, AValue);
end;

procedure TBookmarkGroupRec.Delete(ABookmarkId: int64);
begin
  FDb.Delete(ABookmarkId);
end;

procedure TBookmarkGroupRec.DeleteGroup;
begin
  FDb.DeleteGroup(Id);
end;

function TBookmarkGroupRec.Get(AStart, AEnd: integer): TBookmarkAr;
begin
  Result := FDb.Get(Id, AStart, AEnd);
end;

function TBookmarkGroupRec.GetMaxId: int64;
begin
  Result := FDb.GetMaxId(Id);
end;

function TBookmarkGroupRec.GetPage(APageNum: integer): TBookmarkAr;
begin
  Result := FDb.GetPage(Id, APageNum);
end;

procedure TBookmarkGroupRec.UpdateGroup;
begin
  FDb.UpdateGroup(Id, Self);
end;

{ TNBoxBookmarksHistoryDb }

constructor TNBoxBookmarksHistoryDb.Create(ADbFilename: string);
var
  Groups: TBookmarkGroupRecAr;

  function GetByName(AName: string): TBookmarkGroupRec;
  var
    I: integer;
  begin
    for I := low(Groups) to high(Groups) do begin
      if ( Groups[I].Name = AName ) then begin
        Result := Groups[i];
        break;
      end;
    end;
  end;

begin
  inherited;
  Groups := Self.GetBookmarksGroups;
  FSearchTable := GetByName(Self.NAME_SEARCH_HISTORY);
  FTapTable    := GetByName(Self.NAME_TAP_HISTORY);
  FDownloadTable := GetByName(Self.NAME_DOWNLOAD_HISTORY);
end;

procedure TNBoxBookmarksHistoryDb.CreateBase;
begin
  inherited;
  AddGroup(Self.NAME_SEARCH_HISTORY, 'list of searched requests.');
  AddGroup(Self.NAME_DOWNLOAD_HISTORY, 'list of downloaded content.');
  AddGroup(Self.NAME_TAP_HISTORY, 'clicked items.');
end;

end.

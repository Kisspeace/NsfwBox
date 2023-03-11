{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Bookmarks;

interface
uses
  SysUtils, Classes, XSuperObject, XSuperJSON, DbHelper, System.JSON,
  NsfwBox.Interfaces, NsfwBox.Provider.Pseudo, NsfwBox.Provider.NsfwXxx,
  NsfwBox.Provider.R34App, NsfwBox.Provider.R34JsonApi, NsfwBox.Consts,
  NsfwBox.Helper, Math, system.Generics.Collections, NsfwBox.Logging,
  NsfwBox.Provider.BooruScraper, BooruScraper.Interfaces, BooruScraper.BaseTypes,
  BooruScraper.Serialize.Json, BooruScraper.Serialize.XSuperObject,
  ZExceptions, ZPlainSqLiteDriver;

type

  TSJsonMom = BooruScraper.Serialize.Json.TJsonMom;

  TNBoxBookmarkType = ( Content, SearchRequest );
  TNBoxBookmarksDb = class;

  TNBoxBookmark = class(TNoRefCountObject, IHasOrigin)
    private
      FId: int64;
      FTableName: string;
      FObj: TObject;
      FOrigin: integer;
      FBookmarkType: TNBoxBookmarkType;
      FAbout: string;
      FTime: TDateTime;
      function GetOrigin: integer;
      function GetTime: TDateTime;
      procedure SetObj(const value: TObject);
    public
      property Id: int64 read FId write FId;
      property Tablename: string read FTableName write FTableName;
      property Obj: TObject read FObj write SetObj;
      property Time: TDateTime read GetTime write FTime;
      property About: string read FAbout write FAbout;
      property Origin: integer read GetOrigin write FOrigin;
      property BookmarkType: TNBoxBookmarkType read FBookmarkType;
      function IsRequest: boolean;
      function AsItem: INBoxItem;
      function AsRequest: INBoxSearchRequest;
      constructor Create(AItem: INBoxItem); overload;
      constructor Create(AItem: INBoxSearchRequest); overload;
      constructor Create; overload;
      destructor destroy; override;
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
      ItemsCount: int64;
      procedure AddB(A: TNBoxBookmark);
      procedure Add(AValue: IHasOrigin);         overload;
      procedure Add(AValues: TArray<IHasOrigin>); overload;
      function GetPage(APageNum: integer = 1): TBookmarkAr;
      function Get(AStart, AEnd: integer): TBookmarkAr;
      procedure ClearGroup;
      procedure DeleteGroup;
      procedure Delete(ABookmarkId: int64);
      function GetItemsCount: int64;
      function GetMaxId: int64;
      function GetMaxPage: int64;
      procedure UpdateGroup;
  end;

  TBookmarkGroupRecAr = TArray<TBookmarkGroupRec>;

  TNBoxBookmarksDb = class(TDbHelper)
    protected
      FPageSize: integer;
      procedure CreateBase; override;
      function ReadGroup: TBookmarkGroupRec;
      function NewBookmark(AValue: IHasOrigin): TNBoxBookmark;
    public
      property PageSize: integer read FPageSize write FPageSize;
      { -------------------- }
      function GetBookmarksGroups: TBookmarkGroupRecAr;
      function GetGroupById(AGroupId: int64): TBookmarkGroupRec;
      function GetGroupsByName(AGroupName: string): TBookmarkGroupRecAr;
      procedure UpdateGroup(AGroupId: int64; ANew: TBookmarkGroupRec);
      function AddGroup(AName, AAbout: string): TBookmarkGroupRec;
      function GetLastGroup: TBookmarkGroupRec;
      procedure ClearGroup(AGroupId: int64);
      procedure DeleteGroup(AGroupId: Int64);
      procedure DeleteAllGroups;
      procedure DeleteAllItems;
      procedure Delete(ABookmarkId: int64);
      procedure AddB(AGroupId: int64; A: TNBoxBookmark);           overload;
      procedure AddB(AGroupId: int64; AValues: TBookmarkAr);       overload;
      procedure Add(AGroupId: int64; AValue: IHasOrigin);         overload;
      procedure Add(AGroupId: int64; AValues: TArray<IHasOrigin>); overload;
      function GetMaxId(AGroupId: int64): int64;
      function GetMaxPage(AGroupId: int64): int64;
      function GetItemsCount(AGroupId: int64): int64;
      function GetPage(AGroupId: int64; APageNum: integer = 1): TBookmarkAr;
      function Get(AGroupId: int64; AStart, AEnd: integer): TBookmarkAr;
      function Clone: TNBoxBookmarksDb;
      constructor Create(ADbFilename: string); override;
  end;

  TNBoxBookmarksHistoryDb = class(TNBoxBookmarksDb)
    private
      FSearchGroup: TBookmarkGroupRec;
      FTapGroup: TBookmarkGroupRec;
      FDownloadGroup: TBookmarkGroupRec;
      FTabGroup: TBookmarkGroupRec;
    protected
      procedure CreateBase; override;
    public const
      NAME_SEARCH_HISTORY   = 'search history';
      NAME_TAP_HISTORY      = 'tap history';
      NAME_DOWNLOAD_HISTORY = 'download history';
      NAME_TABS_HISTORY     = 'closed tabs history';
    public
      function HasGroup(AGroupName: string): boolean;
      property SearchGroup: TBookmarkGroupRec read FSearchGroup;
      property TapGroup: TBookmarkGroupRec read FTapGroup;
      property DownloadGroup: TBookmarkGroupRec read FDownloadGroup;
      property TabGroup: TBookmarkGroupRec read FTabGroup;
      constructor Create(ADbFilename: string); override;
  end;

  Procedure SafeAssignFromJSON(AObject: TObject; JSON: ISuperObject); overload;
  Procedure SafeAssignFromJSON(AObject: TObject; const AJsonString: string); overload;

  function ToJson(AObject: TObject): ISuperObject;
  function ToJsonObj(AObject: TObject): TJsonObject;
  function ToJsonStr(AObject: TObject): String;

implementation


function ToJson(AObject: TObject): ISuperObject;
begin
  if (AObject is TNBoxBooruItemBase) then begin
    Result := SO;
    var LObj := (AObject as TNBoxBooruItemBase);

    with Result do begin
      I['Origin'] := LObj.Origin;
      O['Full'] := TJsonMom.ToJson(LObj.Full);
    end;
  end else
    Result := AObject.AsJSONObject;
end;

function ToJsonObj(AObject: TObject): TJsonObject;
begin
  if (AObject is TNBoxBooruItemBase) then begin
    Result := TJsonObject.Create;
    var LObj := (AObject as TNBoxBooruItemBase);

    with Result do begin
      AddPair('Origin', LObj.Origin);
      AddPair('Full', TSJsonMom.ToJson(LObj.Full));
    end;
  end else
    Result := TJsonObject.ParseJSONValue(AObject.AsJSON) as TJsonObject; { slow }
end;

function ToJsonStr(AObject: TObject): String;
begin
  if (AObject is TNBoxBooruItemBase) then
  begin
    var LJson := ToJsonObj(AObject);
    try
      Result := LJson.ToJSON;
    finally
      LJson.Free;
    end;
  end else
    Result := ToJson(AObject).AsJSON(false);
end;

Procedure SafeAssignFromJSON(AObject: TObject; JSON: ISuperObject);
begin
  if ( AObject is TNBoxR34AppItem ) then begin

    try
      // v1.0.1
      if ( JSON.O['item'].Ancestor['tags'].DataType = TDataType.dtArray ) then begin
        var LTagsAr: ISuperArray;
        LTagsAr := JSON.O['item'].A['tags'].Clone;
        JSON.O['item'].Remove('tags');
        JSON.O['item'].O['tags'].A['general'] := LTagsAr;
      end;

    except
      On E: Exception do begin
        Log('SafeAssignFromJSON(TNBoxR34AppItem)', E);
        raise;
      end;
    end;

  end else if ( AObject is TNBoxBooruItemBase ) then begin

    try
      with (AObject as TNBoxBooruItemBase) do begin
        var LJsonTmp: TJsonObject;

        var LThumb: IBooruThumb := Nil;
        if JSON.Null['ThumbItem'] = TMemberStatus.jAssigned then
        begin
          LJsonTmp := TJsonObject.ParseJSONValue(JSON.O['ThumbItem'].AsJSON) as TJsonObject;
          try
            LThumb := TSJsonMom.FromJsonIBooruThumb(LJsonTmp);
          finally
            LJsonTmp.Free;
          end;
          Full.Assign(LThumb);
        end;

        if JSON.Null['Full'] = TMemberStatus.jAssigned then
        begin
          var LFull: IBooruPost := Nil;

          LJsonTmp := TJsonObject.ParseJSONValue(JSON.O['Full'].AsJSON) as TJsonObject;
          try
            LFull := TSJsonMom.FromJsonIBooruPost(LJsonTmp);
          finally
            LJsonTmp.Free;
          end;

          { v2.3.0 }
          if Assigned(LThumb) then begin
            LFull.SampleUrl := LFull.Thumbnail;
            LFull.Thumbnail := '';
          end;

          MergeFull(LFull);
        end;

      end;

      Exit; { !! }
    except
      On E: Exception do begin
        Log('SafeAssignFromJSON(TNBoxBooruItemBase) ' + SLineBreak + JSON.AsJSON(True), E);
        raise;
      end;
    end;

  end;

  try
    AObject.AssignFromJSON(JSON);
  except
    On E: exception do begin
      Log('AObject.AssignFromJSON(JSON): ' + AObject.ClassName + SLineBreak + JSON.AsJSON(True), E);
      raise;
    end;
  end;
end;

Procedure SafeAssignFromJSON(AObject: TObject; const AJsonString: string);
var
  LJson: ISuperObject;
begin
  try
    try
      LJson := SO(AJsonString);
    except
      On E: exception do begin
        Log('LJson := SO(AJsonString) ' + BoolToStr(Assigned(LJson), True) + ' ' + AJsonString, E);
        raise;
      end;
    end;
    SafeAssignFromJSON(AObject, LJson);
  except
    On E: exception do begin
      Log('SafeAssignFromJSON(string) ' + BoolToStr(Assigned(LJson), True) + ' ' + AJsonString, E);
      raise
    end;
  end;
end;

{ TNBoxBookmark }

constructor TNBoxBookmark.Create(AItem: INBoxSearchRequest);
begin
  Obj := ( Aitem as TObject );
end;

constructor TNBoxBookmark.Create(Aitem: INBoxItem);
begin
  Obj := ( Aitem as TObject );
end;

function TNBoxBookmark.AsItem: INBoxItem;
begin
  if not Supports(Obj, INBoxItem, Result) then
    Result := nil;
end;

function TNBoxBookmark.AsRequest: INBoxSearchRequest;
begin
  if not Supports(Obj, INBoxSearchRequest, Result) then
    Result := nil;
end;


constructor TNBoxBookmark.Create;
begin
  FObj := nil;
end;

destructor TNBoxBookmark.destroy;
begin
//  if Assigned(Self.Obj) then
//    Obj.Free;
  inherited;
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

procedure TNBoxBookmark.SetObj(const value: TObject);
var
  LHasOrigin: IHasOrigin;
begin
  FObj := Value;
  if Assigned(Obj) then begin

    supports(Obj, IHasOrigin, LHasOrigin);
    Origin := LHasOrigin.Origin;

    if Supports(Obj, INboxItem) then
      FBookmarkType := Content
    else
      FBookmarkType := SearchRequest;

  end;
end;

{ TNBoxBookmarksDb }

procedure TNBoxBookmarksDb.AddB(AGroupId: int64; A: TNBoxBookmark);
begin
  Self.AddB(AGroupId, [A]);
end;

procedure TNBoxBookmarksDb.AddB(AGroupId: int64; AValues: TBookmarkAr);
const
  MAX_ITEMS_COUNT: integer = 100;
  VALUES_TEMPLATE: string = '(:group_id%d, :origin%d, :type%d, :about%d, :object%d)';
var
  I, Stop, Pos, ArPos, Iter: integer;
begin
  try
    ArPos := 0;
    while True do begin
      Query.SQL.AddStrings([
        'INSERT INTO `items` (`group_id`, `origin`, `type`, `about`, `object`)',
        'VALUES'
      ]);

      Stop := ArPos + (MAX_ITEMS_COUNT - 1);
      if (Stop > High(AValues)) then
        Stop := High(AValues);

      Iter := 0;
      for I := ArPos to Stop do begin
        Query.SQL.Add(format(VALUES_TEMPLATE, [I, I, I, I, I]));

        if (I < Stop) then
          Query.SQL.Add(',');

        Pos := Iter * 5;
        with Query.Params do begin
          Items[Pos + 0].AsInt64 := AGroupId; // group_id
          Items[Pos + 1].AsInteger := AValues[I].Origin; // origin
          Items[Pos + 2].AsInteger := ord(AValues[I].FBookmarkType); // type
          Items[Pos + 3].AsString := AValues[I].About; // about
          Items[Pos + 4].AsString := ToJsonStr(AValues[I].Obj); // object
        end;
        inc(Iter);
      end;

      ForceExecSQL;
      Query.SQL.Clear;

      ArPos := I;
      if ArPos > High(AValues) then
        break;
    end;
  finally
    Query.SQL.Clear;
  end;
end;

procedure TNBoxBookmarksDb.Add(AGroupId: int64; AValue: IHasOrigin);
var
  B: TNboxBookmark;
begin
  try
    B := NewBookmark(AValue);
    AddB(AGroupId, B);
  finally
    B.Free;
  end;
end;

procedure TNBoxBookmarksDb.Add(AGroupId: int64; AValues: TArray<IHasOrigin>);
var
  I: integer;
  Bookmarks: TObjectList<TNBoxBookmark>;
begin
  Bookmarks := TObjectList<TNBoxBookmark>.Create;
  try
    for I := 0 to High(AValues) do
      Bookmarks.Add(NewBookmark(AValues[I]));
    Self.AddB(AGroupId, Bookmarks.ToArray);
  finally
    Bookmarks.Free;
  end;
end;

function TNBoxBookmarksDb.AddGroup(AName, AAbout: string): TBookmarkGroupRec;
begin
  try
    Result.FDb := self;
    Result.Name := AName;
    Result.About := AAbout;
    Result.Timestamp := now;
    Result.Id := 0;

    with Query do begin
      SQL.AddStrings([
        'INSERT INTO groups (name, about)',
        'VALUES (:name, :about);'
      ]);
      Params.ParamByName('name').AsString  := AName;
      Params.ParamByName('about').AsString := AAbout;
      ForceExecSql;
    end;

    Query.SQL.Clear;
    Result := Self.GetLastGroup;

  finally
    Query.SQL.Clear;
  end;
end;

procedure TNBoxBookmarksDb.ClearGroup(AGroupId: int64);
begin
  try
    Query.SQL.Text := 'DELETE FROM items WHERE (group_id = :id);';
    Query.Params.ParamByName('id').AsLargeInt := AGroupId;
    ForceExecSql
  finally
    Query.SQL.Clear;
  end;
end;

function TNBoxBookmarksDb.Clone: TNBoxBookmarksDb;
begin
  Result := TNBoxBookmarksDb.Create(Connection.Database);
  Result.ForceConnect;
end;

constructor TNBoxBookmarksDb.Create(ADbFilename: string);
begin
  inherited;
  FPageSize := 25;
end;

procedure TNBoxBookmarksDb.CreateBase;
begin
  try
    SqlProc.Script.AddStrings([
      'CREATE TABLE groups (',
      '  id        INTEGER PRIMARY KEY AUTOINCREMENT,',
      '  name      VARCHAR(255),',
      '  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,',
      '  about     TEXT',
      ');',

      'CREATE TABLE items (',
      '  origin    INTEGER,',
      '  type      INTEGER,',
      '  about     TEXT,',
      '  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,',
      '  object    JSON,',
      '  group_id  INTEGER DEFAULT 1,',
      '  FOREIGN KEY(group_id) REFERENCES groups (id)',
      ');',

      'CREATE VIEW only_content AS',
      '  SELECT * FROM items WHERE (type = 0);',

      'CREATE VIEW only_requests AS',
      '  SELECT * FROM items WHERE (type = 1);'
    ]);
    SqlProc.Execute;
  finally
    SqlProc.Script.Clear;
  end;
end;

procedure TNBoxBookmarksDb.Delete(ABookmarkId: int64);
begin
  try
    Query.SQL.Text := 'DELETE FROM items WHERE (rowid = :id);';
    Query.Params.ParamByName('id').AsInt64 := ABookmarkId;
    ForceExecSql;
  finally
    Query.SQL.Clear;
  end;
end;

procedure TNBoxBookmarksDb.DeleteAllGroups;
begin
  try
    SqlProc.Script.AddStrings([
      'BEGIN TRANSACTION;',
	      'DELETE FROM items;',
	      'DELETE FROM groups;',
      'COMMIT;',
      'VACUUM;'
    ]);
    ForceExecScript;
  finally
    SqlProc.Script.Clear;
  end;
end;                            

procedure TNBoxBookmarksDb.DeleteAllItems;
begin
  try
    SqlProc.Script.AddStrings([
      'DELETE FROM items;',
      'VACUUM;'
    ]);
    ForceExecScript;
  finally
    SqlProc.Script.Clear;
  end;
end;

procedure TNBoxBookmarksDb.DeleteGroup(AGroupId: Int64);
begin
  try
    SqlProc.Script.AddStrings([
      'BEGIN TRANSACTION;',
	      'DELETE FROM items WHERE (group_id = :id);',
	      'DELETE FROM groups WHERE (id = :id);',
      'COMMIT;',
      'VACUUM;'
    ]);

    SqlProc.Params.ParamByName('id').AsInt64 := AGroupId;
    ForceExecScript;
  finally
    SqlProc.Script.Clear;
  end;
end;

function TNBoxBookmarksDb.Get(AGroupId: int64; AStart, AEnd: integer): TBookmarkAr;
var
  I, Pos: integer;
  LBookmark: TNBoxBookmark;
  LBookmarkType: TNBoxBookmarkType;
  LJson: string;
  Tmp: TObject;
begin
  try
    try
      Result := [];
      Pos := 1;
      Query.SQL.Text := 'SELECT rowid AS id, * FROM items WHERE (group_id = :id) LIMIT :start, :count;';

      with Query.Params do begin
        ParamByName('id').AsLargeInt := AGroupId;
        ParamByName('start').AsInteger := AStart;
        ParamByName('count').AsInteger := (AEnd - AStart);
      end;

      ForceOpen;
      Query.First;
      while ( not Query.Eof ) do begin
        LBookmark := TNBoxBookmark.Create;

        with LBookmark do begin

          Id := Query.FieldByName('id').AsLargeInt;
          Origin := Query.FieldByName('origin').AsInteger;
          LBookmarkType := TNBoxBookmarkType(Query.FieldByName('type').AsInteger);
          LJson := Query.FieldByName('object').AsString;

          case LBookmarkType of

            Content: begin
              try
                var Post: INBoxItem;
                Post := CreateItemByOrigin(Origin);
                tmp := (Post as TObject);
                SafeAssignFromJSON(Tmp, LJson);
                LBookmark.Obj := tmp;
              except
                On E: exception do begin
                  Log('BookmarkType of Content', E);
                  raise;
                end;
              end;
            end;

            SearchRequest: begin
              var Req: INBoxSearchRequest;
              Req := CreateReqByOrigin(Origin);
              tmp := (Req as TObject);
              SafeAssignFromJSON(Tmp, LJson);
              LBookmark.Obj := tmp;
            end;

          end;

        end;

        Result := Result + [LBookmark];
        Query.Next;
        inc(Pos);
      end;

      Query.Close;
    finally
      Query.SQL.Clear;
    end;
  except
    On E: exception do begin
      Log('TNBoxBookmarksDb.Get', E);
      raise;
    end;
  end;
end;

function TNBoxBookmarksDb.GetBookmarksGroups: TBookmarkGroupRecAr;
var
  Rec: TBookmarkGroupRec;
begin
  try
    Result := [];

    Query.SQL.AddStrings([
      'SELECT g.*, IFNULL(r.cnt, 0) items_count',
      'FROM groups g',
      'LEFT JOIN ( SELECT r.group_id, COUNT(*) cnt',
      '	  FROM items r',
      '	  GROUP BY r.group_id) AS r',
      'ON r.group_id = g.id',
      'GROUP BY g.id'
    ]);

    ForceOpen;
    try
      Query.First;
      while ( not Query.Eof ) do begin
        Rec := Self.ReadGroup;
        Result := Result + [Rec];
        Query.Next;
      end;
    finally
      Query.Close;
    end;

  finally
    Query.SQL.Clear;
  end;
end;

function TNBoxBookmarksDb.GetMaxId(AGroupId: Int64): int64;
begin
  try
    Result := -1;
    Query.SQL.Text := 'SELECT rowid FROM items WHERE (group_id = :id) ORDER BY rowid DESC LIMIT 1;';
    Query.Params.ParamByName('id').AsInt64 := AGroupId;
    ForceOpen;

    try
      Query.First;
      Result := Query.FieldByName('rowid').AsLargeInt;
    except
      Result := -1;
    end;

    Query.Close;
  finally
    Query.SQL.Clear;
  end;
end;

function TNBoxBookmarksDb.GetMaxPage(AGroupId: int64): int64;
var
  count: int64;
begin
  count := GetItemsCount(AGroupId);
  if count > 0 then
    Result := Ceil(count / FPageSize)
  else
    Result := 0
end;

function TNBoxBookmarksDb.GetPage(AGroupId: int64; APageNum: integer): TBookmarkAr;
var
  LStart, LEnd: integer;
begin
  LStart := (APageNum - 1) * PageSize;
  if LStart < 0 then
    LStart := 0;
  LEnd   := LStart + PageSize;
  Result := Get(AGroupId, LStart, LEnd);
end;

function TNBoxBookmarksDb.NewBookmark(AValue: IHasOrigin): TNBoxBookmark;
begin
  Result := TNBoxBookmark.Create;
  Result.Obj := ( AValue as TObject );
  Result.Time := Now;
end;

function TNBoxBookmarksDb.ReadGroup: TBookmarkGroupRec;
begin
  With Result do begin
    ItemsCount := Query.FieldByName('items_count').AsLargeInt;
    Id := Query.FieldByName('id').AsLargeInt;
    Name := Query.FieldByName('name').AsString;
    About := Query.FieldByName('about').AsString;
    var LTimestamp := Query.FieldByName('timestamp').AsDateTime;
    Timestamp := LTimestamp;
    FDb := Self;
  end;
end;

function TNBoxBookmarksDb.GetGroupById(AGroupId: int64): TBookmarkGroupRec;
begin
  try
    Query.SQL.AddStrings([
      'SELECT * FROM (',
      '   SELECT g.*, IFNULL(r.cnt, 0) items_count',
      ' 	FROM groups g',
      '	  LEFT JOIN ( SELECT r.group_id, COUNT(*) cnt',
      '		  FROM items r',
      '		  GROUP BY r.group_id) AS r',
      '	 ON r.group_id = g.id',
      '	 GROUP BY g.id ) as g',
      'WHERE g.id = :id'
    ]);

    Query.Params.ParamByName('id').AsInt64 := AGroupId;
    ForceOpen;

    try
      Query.First;
      Result := Self.ReadGroup;
    finally
      Query.Close;
    end;

  finally
    Query.SQL.Clear;
  end;
end;

function TNBoxBookmarksDb.GetGroupsByName(
  AGroupName: string): TBookmarkGroupRecAr;
var
  Rec: TBookmarkGroupRec;
begin
  try
    Query.SQL.AddStrings([
      'SELECT * FROM (',
      '   SELECT g.*, IFNULL(r.cnt, 0) items_count',
      ' 	FROM groups g',
      '	  LEFT JOIN ( SELECT r.group_id, COUNT(*) cnt',
      '		  FROM items r',
      '		  GROUP BY r.group_id) AS r',
      '	 ON r.group_id = g.id',
      '	 GROUP BY g.id ) as g',
      'WHERE g.name = :name'
    ]);

    Query.Params[0].AsString := AGroupName;
    ForceOpen;

    try
      Query.First;
      while ( not Query.Eof ) do begin
        Rec := Self.ReadGroup;
        Result := Result + [Rec];
        Query.Next;
      end;
    finally
      Query.Close;
    end;

  finally
    Query.SQL.Clear;
  end;
end;

function TNBoxBookmarksDb.GetItemsCount(AGroupId: int64): int64;
begin
  try
    Query.SQL.Text := 'SELECT COUNT(*) FROM items WHERE (group_id = :id);';
    Query.Params.ParamByName('id').AsInt64 := AGroupId;
    ForceOpen;

    try
      Result := Query.FieldList[0].AsLargeInt;
    finally
      Query.Close;
    end;

  finally
    Query.SQL.Clear;
  end;
end;

function TNBoxBookmarksDb.GetLastGroup: TBookmarkGroupRec;
begin
  try
    Query.SQL.AddStrings([
      'SELECT * FROM (',
      '   SELECT g.*, IFNULL(r.cnt, 0) items_count',
      ' 	FROM groups g',
      '	  LEFT JOIN ( SELECT r.group_id, COUNT(*) cnt',
      '		  FROM items r',
      '		  GROUP BY r.group_id) AS r',
      '	 ON r.group_id = g.id',
      '	 GROUP BY g.id ) as g',
      'ORDER BY g.id DESC LIMIT 1'
    ]);

    ForceOpen;
    try
      Query.First;
      Result := Self.ReadGroup;
    finally
      Query.Close;
    end;

  finally
    Query.SQL.Clear;
  end;
end;

procedure TNBoxBookmarksDb.UpdateGroup(AGroupId: int64; ANew: TBookmarkGroupRec);
begin
  try
    Query.SQL.AddStrings([
      'UPDATE groups',
      'SET name = :name,',
      '    about = :about,',
      '    timestamp = :timestamp',
      'WHERE (id = :id);'
    ]);

    with Query.Params do begin
      ParamByName('name').AsString := ANew.Name;
      ParamByName('about').AsString := ANew.About;
      ParamByName('timestamp').AsDateTime := ANew.Timestamp;
      ParamByName('id').AsInt64 := AGroupId;
    end;

    ForceExecSql;

  finally
    Query.SQL.Clear;
  end;
end;

{ TBookmarkGroupRec }

procedure TBookmarkGroupRec.Add(AValue: IHasOrigin);
begin
  FDb.Add(Id, AValue);
end;

procedure TBookmarkGroupRec.Add(AValues: TArray<IHasOrigin>);
begin
  FDb.Add(Id, AValues);
end;

procedure TBookmarkGroupRec.AddB(A: TNBoxBookmark);
begin
  FDb.AddB(Id, A);
end;

procedure TBookmarkGroupRec.ClearGroup;
begin
  FDb.ClearGroup(Id);
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

function TBookmarkGroupRec.GetItemsCount: int64;
begin
  Result := FDb.GetItemsCount(Id);
end;

function TBookmarkGroupRec.GetMaxId: int64;
begin
  Result := FDb.GetMaxId(Id);
end;

function TBookmarkGroupRec.GetMaxPage: int64;
begin
  Result := FDb.GetMaxPage(Id);
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
  FSearchGroup := GetByName(Self.NAME_SEARCH_HISTORY);
  FTapGroup    := GetByName(Self.NAME_TAP_HISTORY);
  FDownloadGroup := GetByName(Self.NAME_DOWNLOAD_HISTORY);
  FTabGroup := GetByName(Self.NAME_TABS_HISTORY);
end;

procedure TNBoxBookmarksHistoryDb.CreateBase;
begin
  inherited;
  AddGroup(Self.NAME_SEARCH_HISTORY, 'list of searched requests.');
  AddGroup(Self.NAME_DOWNLOAD_HISTORY, 'list of downloaded content.');
  AddGroup(Self.NAME_TAP_HISTORY, 'clicked items.');
  AddGroup(Self.NAME_TABS_HISTORY, 'all tabs that been closed.');
end;

function TNBoxBookmarksHistoryDb.HasGroup(AGroupName: string): boolean;
var
  Groups: TBookmarkGroupRecAr;
begin
  Groups := Self.GetGroupsByName(AGroupName);
  Result := (Length(Groups) > 0);
end;

end.

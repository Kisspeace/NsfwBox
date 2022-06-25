//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxOriginR34App;

interface
uses
  System.SysUtils, System.Classes, NsfwBoxInterfaces, R34App.Types,
  NsfwBoxOriginConst, XSuperObject;

type

  TNBoxR34AppItem = class(TNBoxItemBase, INBoxitem, IUIdAsInt, IHasTags)
    protected
      FItem: TR34AppItem;
      procedure SetTags(const Value: TArray<string>);
      function GetTags: TArray<string>;
      function GetTagsCount: integer;
      function GetUidInt: int64;
      procedure SetUIdInt(const Value: int64);
      function GetCaption: string;
      procedure SetContentUrls(const Value: TArray<string>); override;
      function GetContentUrls: TArray<string>;               override;
      procedure SetThumbnailUrl(const Value: string);        override;
      function GetThumbnailUrl: string;                      override;
    public
      //--New--//
      property Item: TR34Appitem read FItem write FItem;
      //--Properties--//
      property Origin;
      [DISABLE] property UIdInt: int64 read GetUidInt write SetUidInt;
      [DISABLE] property ThumbnailUrl read GetThumbnailUrl write SetThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property Tags: TArray<string> read GetTags write SetTags;
      [DISABLE] property TagsCount: integer read GetTagsCount;
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      constructor Create;
  end;

  TNBoxSearchReqR34App = class(TNBoxSearchRequestBase)
    protected
      function GetOrigin: integer; override;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request;
      property PageId;
  end;

implementation

{ TNBoxR34XxxItem }


procedure TNBoxR34AppItem.Assign(ASource: INBoxItem);
begin
  if not ( ASource is TNBoxR34AppItem ) then
    Exit;
  with ( ASource as TNBoxR34Appitem ) do begin
    Self.Item := Item;
  end;
end;

function TNBoxR34AppItem.Clone: INBoxItem;
begin
  Result := TNBoxR34AppItem.Create;
  Result.Assign(self);
end;

constructor TNBoxR34AppItem.Create;
begin
  FOrigin := ORIGIN_R34APP;
end;

function TNBoxR34AppItem.GetCaption: string;
begin
  Result := item.TagsStr;
end;


function TNBoxR34AppItem.GetContentUrls: TArray<string>;
begin
  Result := [Item.high_res_file.url];
end;

function TNBoxR34AppItem.GetTags: TArray<string>;
begin
  Result := Item.tags;
end;

function TNBoxR34AppItem.GetTagsCount: integer;
begin
  Result := length(item.tags);
end;

function TNBoxR34AppItem.GetThumbnailUrl: string;
begin
  Result := item.preview_file.url;
  //Result := Fitem.low_res_file.url;
end;

function TNBoxR34AppItem.GetUidInt: int64;
begin
  Result := item.id;
end;

procedure TNBoxR34AppItem.SetContentUrls(const Value: TArray<string>);
begin
  if length(Value) > 0 then
    Fitem.high_res_file.url := Value[0]
  else
    Fitem.high_res_file.url := '';
end;

procedure TNBoxR34AppItem.SetTags(const Value: TArray<string>);
begin
  FItem.tags := Value;
end;

procedure TNBoxR34AppItem.SetThumbnailUrl(const Value: string);
begin
  FItem.preview_file.url := Value;
end;

procedure TNBoxR34AppItem.SetUIdInt(const Value: int64);
begin
  FItem.id := Value;
end;

{ TNBoxSearchReqR34Xxx }

function TNBoxSearchReqR34App.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqR34App.Create;
  with Result do begin
    Pageid := self.FPageId;
    Request := Self.FRequest;
  end;
end;

function TNBoxSearchReqR34App.GetOrigin: integer;
begin
  Result := ORIGIN_R34APP;
end;


end.

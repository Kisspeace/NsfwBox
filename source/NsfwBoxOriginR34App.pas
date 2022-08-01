//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxOriginR34App;

interface
uses
  System.SysUtils, System.Classes, NsfwBoxInterfaces, R34App.Types,
  NetHttp.R34AppApi, NsfwBoxOriginConst, XSuperObject;

type

  TNBoxR34AppItem = class(TNBoxItemBase, INBoxitem, IUIdAsInt,
    IHasTags, IHasAuthor)
    protected
      FItem: TR34AppItem;
      //procedure SetTags(const Value: TArray<string>);
      function GetTags: TArray<string>;
      function GetTagsCount: integer;
      function GetUidInt: int64;
      //procedure SetUIdInt(const Value: int64);
      function GetCaption: string;
      //procedure SetContentUrls(const Value: TArray<string>); override;
      function GetContentUrls: TArray<string>;               override;
      //procedure SetThumbnailUrl(const Value: string);        override;
      function GetThumbnailUrl: string;                      override;
      function GetAuthorName: string;
    public
      //--New--//
      property Item: TR34Appitem read FItem write FItem;
      //--Properties--//
      property Origin;
      [DISABLE] property UIdInt: int64 read GetUidInt; // write SetUidInt;
      [DISABLE] property ThumbnailUrl read GetThumbnailUrl; // write SetThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property Tags: TArray<string> read GetTags; // write SetTags;
      [DISABLE] property TagsCount: integer read GetTagsCount;
      [DISABLE] property AuthorName: string read GetAuthorName;
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      constructor Create;
  end;

  TNBoxSearchReqR34App = class(TNBoxSearchRequestBase)
    protected
      FBooru: TR34AppFreeBooru;
      function GetOrigin: integer; override;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request;
      property PageId;
      property Booru: TR34AppFreeBooru read FBooru write FBooru;
      constructor Create; override;
  end;

implementation
uses unit1;
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

function TNBoxR34AppItem.GetAuthorName: string;
begin
  if ( Length(Item.Tags.Artist) > 0 ) then
    Result := Item.Tags.Artist[0]
  else
    Result := '';
end;

function TNBoxR34AppItem.GetCaption: string;
begin
  Result := Item.Tags.ToString;
end;


function TNBoxR34AppItem.GetContentUrls: TArray<string>;
begin
  Result := [Item.HighResFile.Url];
end;

function TNBoxR34AppItem.GetTags: TArray<string>;
begin
  Result := Item.Tags.ToStringAr;
end;

function TNBoxR34AppItem.GetTagsCount: integer;
begin
  Result := Item.Tags.Count;
end;

function TNBoxR34AppItem.GetThumbnailUrl: string;
begin
  Result := item.PreviewFile.Url;
end;

function TNBoxR34AppItem.GetUidInt: int64;
begin
  Result := Item.id;
end;

//procedure TNBoxR34AppItem.SetContentUrls(const Value: TArray<string>);
//begin
//  if length(Value) > 0 then
//    Fitem.high_res_file.url := Value[0]
//  else
//    Fitem.high_res_file.url := '';
//end;
//
//procedure TNBoxR34AppItem.SetTags(const Value: TArray<string>);
//begin
//  FItem.tags := Value;
//end;
//
//procedure TNBoxR34AppItem.SetThumbnailUrl(const Value: string);
//begin
//  FItem.preview_file.url := Value;
//end;
//
//procedure TNBoxR34AppItem.SetUIdInt(const Value: int64);
//begin
//  FItem.id := Value;
//end;

{ TNBoxSearchReqR34Xxx }

function TNBoxSearchReqR34App.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqR34App.Create;
  with ( Result as TNBoxSearchReqR34App ) do begin
    Booru := Self.FBooru;
    Pageid := Self.FPageId;
    Request := Self.FRequest;
  end;
end;

constructor TNBoxSearchReqR34App.Create;
begin
  inherited;
  FPageId := 0;
  FBooru := TR34AppFreeBooru.rule34xxx;
end;

function TNBoxSearchReqR34App.GetOrigin: integer;
begin
  Result := ORIGIN_R34APP;
end;


end.

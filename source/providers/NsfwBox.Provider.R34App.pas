{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.R34App;

interface
uses
  System.SysUtils, System.Classes, NsfwBox.Interfaces, R34App.Types,
  NetHttp.R34AppApi, NsfwBox.Consts, XSuperObject;

type

  TNBoxR34AppItem = class(TNBoxItemBase, INBoxitem, IUIdAsInt,
    IHasTags, IHasArtists)
    protected
      FItem: TR34AppItem;
      function GetTags: TNBoxItemTagAr;
      function GetTagsCount: integer;
      function GetUidInt: int64;
      function GetCaption: string;
      function GetContentUrls: TArray<string>;               override;
      function GetThumbnailUrl: string;                      override;
      function GetArtists: TNBoxItemArtisAr;
    public
      property Item: TR34Appitem read FItem write FItem;
      property Origin;
      [DISABLE] property UIdInt: int64 read GetUidInt;
      [DISABLE] property ThumbnailUrl read GetThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property Tags: TNBoxItemTagAr read GetTags;
      [DISABLE] property TagsCount: integer read GetTagsCount;
      [DISABLE] property Artists: TNBoxItemArtisAr read GetArtists;
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      constructor Create; override;
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

{ TNBoxR34AppItem }

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
  inherited;
  FOrigin := PROVIDERS.R34App.Id;
end;

function TNBoxR34AppItem.GetArtists: TNBoxItemArtisAr;
begin
  if ( Length(Item.Tags.Artist) > 0 ) then
    Result := [TNBoxItemArtistBase.Create(Item.Tags.Artist[0], '')]
  else
    Result := [];
end;

function TNBoxR34AppItem.GetCaption: string;
begin
  Result := Item.Tags.ToString;
end;


function TNBoxR34AppItem.GetContentUrls: TArray<string>;
begin
  Result := [Item.HighResFile.Url];
end;

function TNBoxR34AppItem.GetTags: TNBoxItemTagAr;
begin
  Result := TNBoxItemTagBase.Convert(Item.Tags.ToStringAr);
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

{ TNBoxSearchReqR34App }

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
  Result := PROVIDERS.R34App.Id;
end;


end.

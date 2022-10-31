{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.NsfwXxx;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwXxx.Types;

type

  TNsfwXxxSite = (NsfwXxx, PornpicXxx, HdpornPics);

  TNBoxNsfwXxxItem = class( TNBoxItemBase, IUIdAsInt, IHasTags, IHasAuthor,
   IHasCaption, IFetchableContent, IFetchableTags)
    private
      FPage: TNsfwXxxPostPage;
      FItem: TNsfwXxxItem;
      //procedure SetTags(const Value: TArray<string>);
      function GetTags: TArray<string>;
      function GetTagsCount: integer;
      function GetTagsFetched: boolean;
      function GetContentFetched: boolean;
      function GetAuthorName: string;
      //procedure SetAuthorName(const Value: string);
      function GetUidInt: int64;
      //procedure SetUIdInt(const Value: int64);
      //procedure SetCaption(const Value: String);
      function GetCaption: string;
      //procedure SetContentUrls(const Value: TArray<string>); override;
      function GetContentUrls: TArray<string>;               override;
      //procedure SetThumbnailUrl(const Value: string);        override;
      function GetThumbnailUrl: string;                      override;
      function GetHasAuthorName: boolean;
    public
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      //--New--//
      property Item: TNsfwXxxitem read Fitem write Fitem;
      property Page: TNsfwXxxPostPage read Fpage write Fpage;
      //--Properties--//
      property Origin;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property UIdInt: int64 read GetUidInt; // write SetUidInt;
      [DISABLE] property Caption: string read GetCaption; // write SetCaption;
      [DISABLE] property AuthorName: string read GetAuthorName; // write SetAuthorName;
      [DISABLE] property ContentFetched: boolean read GetContentFetched;
      [DISABLE] property Tags: TArray<string> read GetTags; // write SetTags;
      [DISABLE] property TagsFetched: boolean read GetTagsFetched;
      constructor Create;
  end;

  TNBoxSearchReqNsfwXxx = class(TNBoxSearchRequestBase)
    protected
      FSearchtype: TNsfwUrlType;
      FSortType: TNsfwSort;
      FOris: TNsfwOris;
      FTypes: TNsfwItemTypes;
      FSite: TNsfwXxxSite;
      function GetOrigin: integer;                        override;
      procedure SetSearchType(const value: TNsfwUrlType);
      procedure SetSortType(const value: TNsfwSort);
      procedure SetOris(const value: TNsfwOris);
      procedure SetTypes(const value: TNsfwItemTypes);
    public
      function Clone: INBoxSearchRequest;                 override;
      property Origin;
      property Request;
      property PageId;
      property SearchType: TNsfwUrlType read FSearchType write SetSearchType;
      property SortType: TNsfwSort read FSortType write SetSortType;
      property Oris: TNsfwOris read FOris write SetOris;
      property Types: TNsfwItemTypes read FTypes write SetTypes;
      property Site: TNsfwXxxSite read FSite write FSite;
      constructor Create; override;
  end;

  function TNsfwXxxSiteToUrl(AValue: TNsfwXxxSite): string;

implementation

function TNsfwXxxSiteToUrl(AValue: TNsfwXxxSite): string;
begin
  case AValue of
    NsfwXxx:    Result := 'https://nsfw.xxx';
    PornpicXxx: Result := 'https://pornpic.xxx';
    HdpornPics: Result := 'https://hdporn.pics';
  end;
end;

{ TNBoxNsfwXxxItem }

procedure TNBoxNsfwXxxItem.Assign(ASource: INBoxItem);
begin
  if not ( ASource is TNBoxNsfwXxxItem ) then
    Exit;
  with ( ASource as TNBoxNsfwXxxItem ) do begin
    Self.Item := Item;
    Self.Page := Page;
  end;
end;

function TNBoxNsfwXxxItem.Clone: INBoxItem;
begin
  Result := TNBoxNsfwXxxItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxNsfwXxxItem.Create;
begin
  inherited;
  Item := TNsfwXxxitem.New;
  Page := TNsfwXxxPostPage.New;
  FOrigin := ORIGIN_NSFWXXX;
end;

function TNBoxNsfwXxxItem.GetAuthorName: string;
begin
  Result := Item.Username;
end;

function TNBoxNsfwXxxItem.GetCaption: string;
begin
  Result := Item.Caption;
end;

function TNBoxNsfwXxxItem.GetContentFetched: boolean;
begin
  Result := (length(self.ContentUrls) > 0);
end;

function TNBoxNsfwXxxItem.GetContentUrls: TArray<string>;
begin
  Result := [];
  if Length(Page.Items) > 0 then
    Result := Page.Items[0].Thumbnails;
end;

function TNBoxNsfwXxxItem.GetHasAuthorName: boolean;
begin
  Result := true;
end;

function TNBoxNsfwXxxItem.GetTags: TArray<string>;
begin
  if ( ContentFetched ) then
    Result := FPage.Items[0].Categories
  else
    Result := FItem.Categories;
end;

function TNBoxNsfwXxxItem.GetTagsCount: integer;
begin
  Result := Length(FItem.Categories);
end;

function TNBoxNsfwXxxItem.GetTagsFetched: boolean;
begin
  Result := Self.ContentFetched;
end;

function TNBoxNsfwXxxItem.GetThumbnailUrl: string;
begin
  if Length(Item.Thumbnails) > 0 then
    Result := Item.Thumbnails[0];
end;

function TNBoxNsfwXxxItem.GetUidInt: int64;
begin
  Result := FItem.Id;
end;

//procedure TNBoxNsfwXxxItem.SetAuthorName(const Value: string);
//begin
//  Fitem.Username := Value;
//end;
//
//procedure TNBoxNsfwXxxItem.SetCaption(const Value: String);
//begin
//  FItem.Caption := Value;
//end;

//procedure TNBoxNsfwXxxItem.SetContentUrls(const Value: TArray<string>);
//begin
//  if Length(FPage.Items) < 1 then
//    FPage.Items := [TNsfwXxxItem.New];
//  FPage.Items[0].Thumbnails := Value;
//end;

//procedure TNBoxNsfwXxxItem.SetTags(const Value: TArray<string>);
//begin
//  FItem.Categories := Value;
//end;
//
//procedure TNBoxNsfwXxxItem.SetThumbnailUrl(const Value: string);
//begin
//  if Length(FItem.Thumbnails) > 0 then
//    FItem.Thumbnails[0] := Value
//  else
//    Fitem.Thumbnails := [Value];
//end;

//procedure TNBoxNsfwXxxItem.SetUIdInt(const Value: int64);
//begin
//  FItem.Id := Value;
//end;

{ TNBoxSearchReqXxx }

function TNBoxSearchReqNsfwXxx.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqNsfwXxx.Create;
  with Result as TNBoxSearchReqNsfwXxx do begin
    Pageid := self.FPageId;
    Request := Self.FRequest;
    Searchtype := Self.FSearchtype;
    SortType := Self.FSortType;
    Oris := Self.FOris;
    Types := Self.FTypes;
    Site := Self.FSite;
  end;
end;

constructor TNBoxSearchReqNsfwXxx.Create;
begin
  inherited;
  FSearchtype := TNsfwUrlType.Default;
  FSortType := TNsfwSort.Recommended;
  FOris := [Straight, Gay, Shemale, Cartoons];
  FTypes := [Image, video, Gallery];
  FSite := TNsfwXxxSite.NsfwXxx;
end;

function TNBoxSearchReqNsfwXxx.GetOrigin: integer;
begin
  Result := ORIGIN_NSFWXXX;
end;

procedure TNBoxSearchReqNsfwXxx.SetOris(const value: TNsfwOris);
begin
  FOris := Value;
end;

procedure TNBoxSearchReqNsfwXxx.SetSearchType(const value: TNsfwUrlType);
begin
  FSearchType := value;
end;

procedure TNBoxSearchReqNsfwXxx.SetSortType(const value: TNsfwSort);
begin
  FSortType := Value;
end;

procedure TNBoxSearchReqNsfwXxx.SetTypes(const value: TNsfwItemTypes);
begin
  FTypes := value;
end;

end.

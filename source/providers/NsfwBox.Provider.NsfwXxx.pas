{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.NsfwXxx;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwXxx.Types, NsfwBox.Utils,
  NsfwBox.Settings, NsfwBox.Logging;

type

  TNsfwXxxSite = (NsfwXxx, PornpicXxx, HdpornPics);

  TNBoxNsfwXxxItem = class(TNBoxItemBase, IUIdAsInt, IHasTags, IHasArtists,
   IHasCaption, IFetchableContent, IFetchableTags)
    private
      FPage: TNsfwXxxPostPage;
      FItem: TNsfwXxxItem;
      function GetTags: TNBoxItemTagAr;
      function GetTagsFetched: boolean;
      function GetContentFetched: boolean;
      function GetArtists: TNBoxItemArtisAr;
      function GetUidInt: int64;
      function GetCaption: string;
      function GetContentUrls: TArray<string>; override;
      function GetThumbnailUrl: string; override;
    public
      procedure Assign(ASource: INBoxItem); override;
      function Clone: INBoxItem; override;
      function GetContentUrls(ASelectFilesMode: TDownloadAllMode): TArray<string>; override;
      { new }
      property Item: TNsfwXxxitem read Fitem write Fitem;
      property Page: TNsfwXxxPostPage read Fpage write Fpage;
      { properties }
      property Origin;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property UIdInt: int64 read GetUidInt;
      [DISABLE] property Caption: string read GetCaption;
      [DISABLE] property Artists: TNBoxItemArtisAr read GetArtists;
      [DISABLE] property ContentFetched: boolean read GetContentFetched;
      [DISABLE] property Tags: TNBoxItemTagAr read GetTags;
      [DISABLE] property TagsFetched: boolean read GetTagsFetched;
      constructor Create; override;
  end;

  TNBoxSearchReqNsfwXxx = class(TNBoxSearchRequestBase, IChangeableHost)
    protected
      FServiceHost: string;
      FSearchtype: TNsfwUrlType;
      FSortType: TNsfwSort;
      FOris: TNsfwOris;
      FTypes: TNsfwItemTypes;
      function GetServiceHost: string;
      procedure SetServiceHost(const Value: string);
      procedure SetSearchType(const value: TNsfwUrlType);
      procedure SetSortType(const value: TNsfwSort);
      procedure SetOris(const value: TNsfwOris);
      procedure SetTypes(const value: TNsfwItemTypes);
    public
      [DISABLE] property ServiceHost: string read GetServiceHost write SetServiceHost;
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request;
      property PageId;
      property SearchType: TNsfwUrlType read FSearchType write SetSearchType;
      property SortType: TNsfwSort read FSortType write SetSortType;
      property Oris: TNsfwOris read FOris write SetOris;
      property Types: TNsfwItemTypes read FTypes write SetTypes;
//      property Site: TNsfwXxxSite read FSite write FSite;
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
  if not ( ASource is Self.ClassType ) then
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
  FOrigin := PROVIDERS.NsfwXxx.Id;
end;

function TNBoxNsfwXxxItem.GetArtists: TNBoxItemArtisAr;
begin
  Result := [TNBoxItemArtistBase.Create(FItem.Username, FItem.UserAvatarUrl)];
end;

function TNBoxNsfwXxxItem.GetCaption: string;
begin
  Result := Item.Caption;
end;

function TNBoxNsfwXxxItem.GetContentFetched: boolean;
begin
  Result := (length(self.ContentUrls) > 0);
end;

function TNBoxNsfwXxxItem.GetContentUrls(
  ASelectFilesMode: TDownloadAllMode): TArray<string>;
begin
  if (Length(Page.Items) > 0)
  and (FItem.ItemType = TNsfwItemType.Video) then
  begin
    case ASelectFilesMode of
      damAllVersions: Result := ContentUrls;

      damHighResVersion: { Pick url for high res video file. }
        Result := TArrayHelper.PickValues<string>(FPage.Items[0].Thumbnails, [0]);

      damMediumResVersion: { Pick url for medium/low res video file. }
      begin                { when not exist - return firts url (high res). }
        Result := TArrayHelper.PickValues<string>(FPage.Items[0].Thumbnails, [1]);
        if Length(Result) = 0 then
          Result := ContentUrls;
      end;
    end;
  end else
    Result := ContentUrls;
end;

function TNBoxNsfwXxxItem.GetContentUrls: TArray<string>;
begin
  Result := [];
  if Length(Page.Items) > 0 then
    Result := Page.Items[0].Thumbnails;
end;

function TNBoxNsfwXxxItem.GetTags: TNBoxItemTagAr;
begin
  if ContentFetched then
    Result := TNBoxItemTagBase.Convert(FPage.Items[0].Categories)
  else
    Result := TNBoxItemTagBase.Convert(FItem.Categories);
end;

function TNBoxNsfwXxxItem.GetTagsFetched: boolean;
begin
  Result := Self.ContentFetched;
end;

function TNBoxNsfwXxxItem.GetThumbnailUrl: string;
begin
  Result := GetFirstStr(Item.Thumbnails);
end;

function TNBoxNsfwXxxItem.GetUidInt: int64;
begin
  Result := FItem.Id;
end;

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
    ServiceHost := Self.FServiceHost;
//    Site := Self.FSite;
  end;
end;

constructor TNBoxSearchReqNsfwXxx.Create;
begin
  inherited;
  FServiceHost := TNsfwXxxSiteToUrl(TNsfwXxxSite.NsfwXxx);
  Forigin := PVR_NSFWXXX;
  FSearchtype := TNsfwUrlType.Default;
  FSortType := TNsfwSort.Newest;
  FOris := [Straight, Gay, Shemale, Cartoons, Bizarre];
  FTypes := [Image, video, Gallery];
end;

function TNBoxSearchReqNsfwXxx.GetServiceHost: string;
begin
  Result := FServiceHost;
end;

procedure TNBoxSearchReqNsfwXxx.SetOris(const value: TNsfwOris);
begin
  FOris := Value;
end;

procedure TNBoxSearchReqNsfwXxx.SetSearchType(const value: TNsfwUrlType);
begin
  FSearchType := value;
end;

procedure TNBoxSearchReqNsfwXxx.SetServiceHost(const Value: string);
begin
  FServiceHost := Value;
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

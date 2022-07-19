//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxOriginGivemepornClub;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  givemeporn.club.types, NsfwBoxInterfaces, NsfwBoxOriginConst;

type

  TGmpClubSearchType = (Empty, Tag, Category, Random);

  TNBoxGmpClubItem = class( TNBoxItemBase, IUIdAsInt, IHasTags,
   IHasCaption, IFetchableContent, IFetchableTags)
    private
      FPage: TGmpclubFullPage;
      FItem: TGmpclubItem;
      procedure SetTags(const Value: TArray<string>);
      function GetTags: TArray<string>;
      function GetTagsCount: integer;
      function GetTagsFetched: boolean;
      function GetContentFetched: boolean;
      function GetUidInt: int64;
      procedure SetUIdInt(const Value: int64);
      procedure SetCaption(const Value: String);
      function GetCaption: string;
      procedure SetContentUrls(const Value: TArray<string>); override;
      function GetContentUrls: TArray<string>;               override;
      procedure SetThumbnailUrl(const Value: string);        override;
      function GetThumbnailUrl: string;                      override;
    public
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      //--New--//
      property Item: TGmpclubItem read Fitem write Fitem;
      property Page: TGmpclubFullPage read Fpage write Fpage;
      //--Properties--//
      property Origin;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property UIdInt: int64 read GetUidInt write SetUidInt;
      [DISABLE] property Caption: string read GetCaption write SetCaption;
      [DISABLE] property ContentFetched: boolean read GetContentFetched;
      [DISABLE] property Tags: TArray<string> read GetTags write SetTags;
      [DISABLE] property TagsFetched: boolean read GetTagsFetched;
      constructor Create;
  end;

  TNBoxSearchReqGmpClub = class(TNBoxSearchRequestBase)
    protected
      FSearchtype: TGmpClubSearchType;
      function GetOrigin: integer;                        override;
      procedure SetSearchType(const value: TGmpClubSearchType);
    public
      function Clone: INBoxSearchRequest;                 override;
      property Origin;
      property Request;
      property PageId;
      property SearchType: TGmpClubSearchType read FSearchType write SetSearchType;
      constructor Create; override;
  end;

implementation

{ TNBoxGmpClubItem }

procedure TNBoxGmpClubItem.Assign(ASource: INBoxItem);
begin
  if not ( ASource is TNBoxGmpClubItem ) then
    Exit;
  with ( ASource as TNBoxGmpClubItem ) do begin
    Self.Item := Item;
    Self.Page := Page;
  end;
end;

function TNBoxGmpClubItem.Clone: INBoxItem;
begin
  Result := TNBoxGmpClubItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxGmpClubItem.Create;
begin
  inherited;
  Item := TGmpclubItem.New;
  Page := TGmpclubFullPage.New;
  FOrigin := ORIGIN_GIVEMEPORNCLUB;
end;

function TNBoxGmpClubItem.GetCaption: string;
begin
  Result := Item.Title;
end;

function TNBoxGmpClubItem.GetContentFetched: boolean;
begin
  Result := (length(self.ContentUrls) > 0);
end;

function TNBoxGmpClubItem.GetContentUrls: TArray<string>;
begin
  Result := [];
  if ( not FPage.ContentUrl.IsEmpty ) then
    Result := [ FPage.ContentUrl ];
end;

function TNBoxGmpClubItem.GetTags: TArray<string>;
begin
  Result := FPage.Tags;
end;

function TNBoxGmpClubItem.GetTagsCount: integer;
begin
  Result := Length(FPage.Tags);
end;

function TNBoxGmpClubItem.GetTagsFetched: boolean;
begin
  Result := ( Length(FPage.Tags) > 0 );
end;

function TNBoxGmpClubItem.GetThumbnailUrl: string;
begin
  Result := FItem.ThumbnailUrl;
end;

function TNBoxGmpClubItem.GetUidInt: int64;
begin
  Result := FItem.Id;
end;

procedure TNBoxGmpClubItem.SetCaption(const Value: String);
begin
  FItem.Title := Value;
end;

procedure TNBoxGmpClubItem.SetContentUrls(const Value: TArray<string>);
begin
  if ( Length(Value) > 0 ) then
    FPage.ContentUrl := Value[0];
end;

procedure TNBoxGmpClubItem.SetTags(const Value: TArray<string>);
begin
  FPage.Tags := Value;
end;

procedure TNBoxGmpClubItem.SetThumbnailUrl(const Value: string);
begin
  FItem.ThumbnailUrl := Value;
end;

procedure TNBoxGmpClubItem.SetUIdInt(const Value: int64);
begin
  FItem.Id := Value;
end;

{ TNBoxSearchReqXxx }

function TNBoxSearchReqGmpClub.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqGmpClub.Create;
  with Result as TNBoxSearchReqGmpClub do begin
    Pageid := self.FPageId;
    Request := Self.FRequest;
    Searchtype := Self.FSearchtype;
  end;
end;

constructor TNBoxSearchReqGmpClub.Create;
begin
  inherited;
  FSearchtype := TGmpClubSearchType.Empty;
end;

function TNBoxSearchReqGmpClub.GetOrigin: integer;
begin
  Result := ORIGIN_GIVEMEPORNCLUB;
end;

procedure TNBoxSearchReqGmpClub.SetSearchType(const value: TGmpClubSearchType);
begin
  FSearchType := value;
end;

end.

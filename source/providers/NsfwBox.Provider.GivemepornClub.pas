{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.GivemepornClub;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  givemeporn.club.types, NsfwBox.Interfaces, NsfwBox.Consts;

type

  TGmpClubSearchType = (Empty, Tag, Category, Random);

  TNBoxGmpClubItem = class( TNBoxItemBase, IUIdAsInt, IHasTags,
   IHasCaption, IFetchableContent, IFetchableTags)
    private
      FPage: TGmpclubFullPage;
      FItem: TGmpclubItem;
      function GetTags: TNBoxItemTagAr;
      function GetTagsCount: integer;
      function GetTagsFetched: boolean;
      function GetContentFetched: boolean;
      function GetUidInt: int64;
      function GetCaption: string;
      function GetContentUrls: TArray<string>;               override;
      function GetThumbnailUrl: string;                      override;
    public
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      { new }
      property Item: TGmpclubItem read FItem write FItem;
      property Page: TGmpclubFullPage read Fpage write Fpage;
      property Origin;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property UIdInt: int64 read GetUidInt;
      [DISABLE] property Caption: string read GetCaption;
      [DISABLE] property ContentFetched: boolean read GetContentFetched;
      [DISABLE] property Tags: TNBoxItemTagAr read GetTags;
      [DISABLE] property TagsFetched: boolean read GetTagsFetched;
      constructor Create; override;
  end;

  TNBoxSearchReqGmpClub = class(TNBoxSearchRequestBase)
    protected
      FSearchtype: TGmpClubSearchType;
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
  FOrigin := PVR_GIVEMEPORNCLUB;
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

function TNBoxGmpClubItem.GetTags: TNBoxItemTagAr;
begin
  Result := TNBoxItemTagBase.Convert(FPage.Tags);
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
  FOrigin := PVR_GIVEMEPORNCLUB;
  FSearchtype := TGmpClubSearchType.Empty;
end;

procedure TNBoxSearchReqGmpClub.SetSearchType(const value: TGmpClubSearchType);
begin
  FSearchType := value;
end;

end.

{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.motherless;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  motherless.types, NsfwBox.Interfaces, NsfwBox.Consts;

type

  TNBoxMotherlessItem = class(TNBoxItemBase, IHasTags, IHasArtists,
   IHasCaption, IFetchableContent, IFetchableTags)
    protected
      FPage: TMotherlessPostPage;
      function GetTags: TNBoxItemTagAr;
      function GetTagsCount: integer;
      function GetTagsFetched: boolean;
      function GetContentFetched: boolean;
      function GetArtists: TNBoxItemArtisAr;
      function GetCaption: string;
      function GetContentUrls: TArray<string>; override;
      function GetThumbnailUrl: string; override;
      function GetHasAuthorName: boolean;
    public
      procedure Assign(ASource: INBoxItem); override;
      function Clone: INBoxItem; override;
      constructor Create; override;
      { Properties ------- }
      property Origin;
      property Page: TMotherlessPostPage read FPage write FPage;
  end;

  TNBoxSearchReqMotherless = class(TNBoxSearchRequestBase)
    protected
      FContentType: TMotherlessMediaType;
      FMediaSize: TMotherlessMediaSize;
      FUploadDate: TMotherLessUploadDate;
      FSort: TMotherLessSort;
      function GetOrigin: integer; override;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request;
      property PageId;
      property ContentType: TMotherlessMediaType read FContentType write FContentType;
      property MediaSize: TMotherlessMediaSize read FMediaSize write FMediaSize;
      property UploadDate: TMotherLessUploadDate read FUploadDate write FUploadDate;
      property Sort: TMotherLessSort read FSort write FSort;
      constructor Create; override;
  end;

  function MediaTypeToStr(AValue: TMotherlessMediaType): string;
  function SortTypeToStr(AValue: TMotherlessSort): string;
  function UploadDateToStr(AValue: TMotherLessUploadDate): string;
  function MediaSizeToStr(AValue: TMotherlessMediaSize): string;

implementation

function MediaTypeToStr(AValue: TMotherlessMediaType): string;
begin
  case AValue of
    MediaImage: Result := 'Image';
    MediaVideo: Result := 'Video';
  end;
end;

function SortTypeToStr(AValue: TMotherlessSort): string;
begin
  case AValue of
    SortRecent:        Result := 'Recent';
    SortLive:          Result := 'Watched now';
    SortFavorited:     Result := 'Favorited';
    SortMostviewed:    Result := 'Most viewed';
    SortMostcommented: Result := 'Most commented';
    SortPopular:       Result := 'Popular';
    SortArchived:      Result := 'Archived';
    SortRelevance:     Result := 'Relevance';
    SortDate:          Result := 'Date';
  end;
end;

function UploadDateToStr(AValue: TMotherLessUploadDate): string;
begin
  case AValue of
    DateAll:       Result := 'Anytime';
    Date24Hours:   Result := '24 hours';
    DateThisWeek:  Result := 'This week';
    DateThisMonth: Result := 'This month';
    DateThisYear:  Result := 'This year';
  end;
end;

function MediaSizeToStr(AValue: TMotherlessMediaSize): string;
begin
  case AValue of
    SizeAll:    Result := 'All sizes';
    SizeSmall:  Result := 'Small';
    SizeMedium: Result := 'Medium';
    SizeBig:    Result := 'Big';
  end;
end;

{ TNBoxMotherlessItem }

procedure TNBoxMotherlessItem.Assign(ASource: INBoxItem);
begin
  if not ( ASource is TNBoxMotherlessItem ) then
    Exit;

  with ( ASource as TNBoxMotherlessItem ) do begin
    Self.Page := Page;
  end;
end;

function TNBoxMotherlessItem.Clone: INBoxItem;
begin
  Result := TNBoxMotherlessItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxMotherlessItem.Create;
begin
  FPage := TMotherlessPostPage.Create('');
  FOrigin := PROVIDERS.Motherless.Id;
end;

function TNBoxMotherlessItem.GetArtists: TNBoxItemArtisAr;
begin
  Result := [TNBoxItemArtistBase.Create(FPage.Item.Author, '')];
end;

function TNBoxMotherlessItem.GetCaption: string;
begin
  Result := FPage.Item.Caption;
end;

function TNBoxMotherlessItem.GetContentFetched: boolean;
begin
  Result := (not FPage.ContentURL.IsEmpty);
end;

function TNBoxMotherlessItem.GetContentUrls: TArray<string>;
begin
  if Self.GetContentFetched then
    Result := [FPage.ContentURL]
  else
    Result := [];
end;

function TNBoxMotherlessItem.GetHasAuthorName: boolean;
begin
  Result := (not FPage.Item.Author.IsEmpty);
end;

function TNBoxMotherlessItem.GetTags: TNBoxItemTagAr;
begin
  Result := TNBoxItemTagBase.Convert(FPage.Tags);
end;

function TNBoxMotherlessItem.GetTagsCount: integer;
begin
  Result := Length(FPage.Tags);
end;

function TNBoxMotherlessItem.GetTagsFetched: boolean;
begin
  Result := Self.GetContentFetched;
end;

function TNBoxMotherlessItem.GetThumbnailUrl: string;
begin
  Result := FPage.Item.ThumbnailUrl;
end;

{ TNBoxSearchReqNsfwXxx }

function TNBoxSearchReqMotherless.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqMotherless.Create;
  with Result as TNBoxSearchReqMotherless do begin
    Pageid := self.FPageId;
    Request := Self.FRequest;
    ContentType := Self.ContentType;
    Sort := Self.Sort;
    MediaSize := self.MediaSize;
    UploadDate := Self.UploadDate;
  end;
end;

constructor TNBoxSearchReqMotherless.Create;
begin
  inherited;
  FContentType := MediaImage;
  Self.FMediaSize := SizeAll;
  Self.FUploadDate := DateAll;
  Self.FSort := TMotherlessSort.SortRecent;
end;

function TNBoxSearchReqMotherless.GetOrigin: integer;
begin
  Result := PROVIDERS.Motherless.Id;
end;

end.

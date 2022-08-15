//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxOriginCoomerParty;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  CoomerParty.Types, CoomerParty.Scraper,
  NsfwBoxInterfaces, NsfwBoxOriginConst;

type

  //TCoomerPartySite = (CoomerParty, KemonoParty);

  TNBoxCoomerPartyItem = class(TNBoxItemBase, IUIdAsInt, IHasCaption,
   IHasAuthor, IFetchableContent)
    private
      FSite: String;
      FId: int64;
      FItem: TPartyPostPage;
      function GetContentUrls: TArray<string>; override;
      function GetThumbnailUrl: string; override;
      function GetContentFetched: boolean;
      function GetCaption: string;
      function GetUidInt: int64;
      function GetAuthorName: string;
    public
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      //--New--//
      property Item: TPartyPostPage read FItem write FItem;
      property Site: String read FSite write FSite;
      //--Properties--//
      property Origin;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property AuthorName: string read GetAuthorName;
      [DISABLE] property UIdInt: int64 read GetUidInt write FId;
      [DISABLE] property Caption: string read GetCaption; // write SetCaption;
      [DISABLE] property ContentFetched: boolean read GetContentFetched;
      constructor Create;
  end;

  TNBoxSearchReqCoomerParty = class(TNBoxSearchRequestBase)
    private
      FUserId: string;
      FService: string;
      FSite: String;
    protected
      function GetOrigin: integer;                        override;
    public
      function Clone: INBoxSearchRequest;                 override;
      property Origin;
      property Request;
      property PageId;
      property Site: String read FSite write FSite;
      property UserId: string read FUserId write FUserId;
      property Service: string read FService write FService;
      constructor Create; override;
  end;

  function TPartyPostToTPartyPostPage(A: TPartyPost): TPartyPostPage;

implementation

function TPartyPostToTPartyPostPage(A: TPartyPost): TPartyPostPage;
begin
  Result.Author := A.Author;
  Result.Content := A.Content;
  Result.Timestamp := A.Timestamp;
  if ( not A.Thumbnail.IsEmpty ) then
    Result.Thumbnails := [A.Thumbnail];
end;

{ TNBoxCoomerPartyItem }

procedure TNBoxCoomerPartyItem.Assign(ASource: INBoxItem);
begin
  inherited;

  if (not (ASource is TNBoxCoomerPartyItem) ) then
    exit;

  with ( ASource as TNBoxCoomerPartyItem ) do begin
    Self.FItem := Item;
    Self.FSite := Site;
    Self.Fid := UIdInt;
  end;
end;

function TNBoxCoomerPartyItem.Clone: INBoxItem;
begin
  Result := TNBoxCoomerPartyItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxCoomerPartyItem.Create;
begin
  FOrigin := ORIGIN_COOMERPARTY;
  //FSite := TCoomerPartySite.CoomerParty;
  FSite := URL_COOMER_PARTY;
  FId := -1;
  FItem := TPartyPostPage.New;
end;

function TNBoxCoomerPartyItem.GetAuthorName: string;
begin
  Result := FItem.Author.Id;
end;

function TNBoxCoomerPartyItem.GetCaption: string;
begin
  Result := FItem.Content;
end;

function TNBoxCoomerPartyItem.GetContentFetched: boolean;
begin
  Result := (ContentUrlCount > 0);
end;

function TNBoxCoomerPartyItem.GetContentUrls: TArray<string>;
var
  I: integer;
begin
  for I := 0 to High(FItem.Files) do
    Result := Result + [Self.Site + FItem.Files[I]];
end;

function TNBoxCoomerPartyItem.GetThumbnailUrl: string;
begin
  if ( length(FItem.Thumbnails) > 0 ) then
    Result := Self.Site + Fitem.Thumbnails[0]
  else
    Result := '';
end;

function TNBoxCoomerPartyItem.GetUidInt: int64;
begin
  Result := FId;
end;

{ TNBoxSearchReqGmpClub }

function TNBoxSearchReqCoomerParty.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqCoomerParty.Create;
  with ( Result as TNBoxSearchReqCoomerParty ) do begin
    Pageid := self.FPageId;
    Request := Self.FRequest;
    Site := Self.Site;
    Service := Self.Service;
    UserId := Self.UserId;
  end;
end;

constructor TNBoxSearchReqCoomerParty.Create;
begin
  inherited;
  FUserId := '';
  FService := '';
end;

function TNBoxSearchReqCoomerParty.GetOrigin: integer;
begin
  Result := ORIGIN_COOMERPARTY;
end;

end.

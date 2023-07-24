{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.CoomerParty;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  CoomerParty.Types, CoomerParty.Scraper,
  NsfwBox.Interfaces, NsfwBox.Consts;

type

  TNBoxArtistCoomerParty = Class(TInterfacedObject, INBoxItemArtist, INBoxItemArtistCoomerParty)
    protected
      FArtist: TPartyArtist;
      function GetArtist: TPartyArtist;
      function GetDisplayName: string;
      function GetAvatarUrl: string;
      function GetContentCount: integer;
    public
      property Artist: TPartyArtist read GetArtist;
      property DisplayName: string read GetDisplayName;
      property AvatarUrl: string read GetAvatarUrl;
      property ContentCount: integer read GetContentCount;
      constructor Create(AArtist: TPartyArtist);
  End;

  TNBoxCoomerPartyItem = class(TNBoxItemBase, IUIdAsInt, IHasCaption,
   IHasArtists, IFetchableContent)
    private
      FSite: String;
      FId: int64;
      FItem: TPartyPostPage;
      function GetContentUrls: TArray<string>; override;
      function GetThumbnailUrl: string; override;
      function GetContentFetched: boolean;
      function GetCaption: string;
      function GetUidInt: int64;
      function GetArtists: TNBoxItemArtisAr;
    public
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      { new }
      property Item: TPartyPostPage read FItem write FItem;
      property Site: String read FSite write FSite;
      property Origin;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property Artists: TNBoxItemArtisAr read GetArtists;
      property UIdInt: int64 read GetUidInt write FId;
      [DISABLE] property Caption: string read GetCaption;
      [DISABLE] property ContentFetched: boolean read GetContentFetched;
      constructor Create; override;
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
  Result := TPartyPostPage.New;
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
  Inherited;
  FOrigin := PVR_COOMERPARTY;
  //FSite := TCoomerPartySite.CoomerParty;
  FSite := URL_COOMER_PARTY;
  FId := -1;
  FItem := TPartyPostPage.New;
end;

function TNBoxCoomerPartyItem.GetArtists: TNBoxItemArtisAr;
begin
  Result := [TNBoxArtistCoomerParty.Create(FItem.Author)];
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
  SetLength(Result, Length(FItem.Files));
  for I := 0 to High(FItem.Files) do
  begin
    if FItem.Files[I].StartsWith('http') then
      Result[I] := FItem.Files[I]
    else
      Result[I] := Self.Site + FItem.Files[I]; { Backwards compatibility }
  end;
end;

function TNBoxCoomerPartyItem.GetThumbnailUrl: string;
begin
  if ( length(FItem.Thumbnails) > 0 ) then
  begin
    if Fitem.Thumbnails[0].StartsWith('http') then
      Result := Fitem.Thumbnails[0]
    else
      Result := Self.Site + Fitem.Thumbnails[0]; { Backwards compatibility }
  end else
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
  Result := PROVIDERS.CoomerParty.Id;
end;

{ TNBoxArtistCoomerParty }

constructor TNBoxArtistCoomerParty.Create(AArtist: TPartyArtist);
begin
  FArtist := AArtist;
end;

function TNBoxArtistCoomerParty.GetArtist: TPartyArtist;
begin
  Result := FArtist;
end;

function TNBoxArtistCoomerParty.GetAvatarUrl: string;
begin
  Result := '';
end;

function TNBoxArtistCoomerParty.GetContentCount: integer;
begin
  Result := -1;
end;

function TNBoxArtistCoomerParty.GetDisplayName: string;
begin
  Result := FArtist.Name;
end;

end.

//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxHelper;

interface
uses
  NsfwBoxInterfaces,
  NsfwBoxOriginPseudo, NsfwBoxOriginNsfwXxx, NsfwBoxOriginR34App,
  NsfwBoxOriginBookmarks, NsfwBoxOriginR34JsonApi,
  NsfwBoxOriginGivemepornClub, NsfwBoxOrigin9HentaitoApi,
  NsfwBoxOriginCoomerParty,
  NsfwBoxOriginRandomizer,
  NsfwBox.Provider.motherless,
  NsfwBoxOriginConst,
  classes, sysutils, NsfwXxx.Types;

  function CreateItemByOrigin(AOrigin: integer): INBoxItem;
  function CreateReqByOrigin(AOrigin: integer): INBoxSearchRequest;
  function CreateRelatedReq(APost: INBoxItem): INBoxSearchRequest;
  function CreateAuthorReq(APost: INBoxItem): INBoxSearchRequest;
  function CreateTagReq(AOrigin: integer; ATag: string = ''): INBoxSearchRequest;

  function OriginToStr(AOrigin: integer): string;

implementation

function CreateItemByOrigin(AOrigin: integer): INBoxItem;
begin
  Case AOrigin of
    ORIGIN_NSFWXXX:    Result := TNBoxNsfwXxxItem.Create;
    ORIGIN_R34APP:     Result := TNBoxR34AppItem.Create;
    ORIGIN_R34JSONAPI: Result := TNBoxR34JsonApiItem.Create;
    ORIGIN_GIVEMEPORNCLUB: Result := TNBoxGmpClubItem.Create;
    ORIGIN_PSEUDO:     Result := TNBoxPseudoItem.Create;
    ORIGIN_9HENTAITO:  Result := TNBox9HentaiToItem.Create;
    ORIGIN_COOMERPARTY: Result := TNBoxCoomerPartyItem.Create;
    ORIGIN_MOTHERLESS: Result := TNBoxMotherlessItem.Create;
  end;
end;

function CreateReqByOrigin(AOrigin: integer): INBoxSearchRequest;
begin
  Case AOrigin of
    ORIGIN_NSFWXXX:    Result := TNBoxSearchReqNsfwXxx.Create;
    ORIGIN_R34APP:     Result := TNBoxSearchReqR34App.Create;
    ORIGIN_R34JSONAPI: Result := TNBoxSearchReqR34JsonApi.Create;
    ORIGIN_GIVEMEPORNCLUB: Result := TNBoxSearchReqGmpClub.Create;
    ORIGIN_PSEUDO:     Result := TNBoxSearchReqPseudo.Create;
    ORIGIN_BOOKMARKS:  Result := TNBoxSearchReqBookmarks.Create;
    ORIGIN_9HENTAITO:  Result := TNBoxSearchReq9HentaiTo.Create;
    ORIGIN_COOMERPARTY: Result := TNBoxSearchReqCoomerParty.Create;
    ORIGIN_RANDOMIZER: Result := TNBoxSearchReqRandomizer.Create;
    ORIGIN_MOTHERLESS: Result := TNBoxSearchReqMotherless.Create;
  end;
end;

function CreateRelatedReq(APost: INBoxItem): INBoxSearchRequest;
begin
  if ( APost is TNBoxNsfwxxxitem ) then begin
    Result := TNBoxSearchReqNsfwXxx.create;
    with ( Result as TNBoxSearchReqNsfwXxx ) do begin
      with ( APost as TNBoxNsfwXxxItem ) do begin
        Result.Request := Item.PostUrl;
      end;
      SearchType := TNsfwUrlType.Related;
    end;
  end else begin
    Result := nil;
  end;
end;

function CreateAuthorReq(APost: INBoxItem): INBoxSearchRequest;
begin
  Result := nil;
  if Supports(APost, IHasAuthor)
  and (APost as IHasAuthor).AuthorName.IsEmpty then
    exit;

  if ( APost is TNBoxNsfwXxxItem ) then begin

    Result := TNBoxSearchReqNsfwXxx.create;
    with ( Result as TNBoxSearchReqNsfwXxx ) do begin
      with ( APost as TNBoxNsfwXxxItem ) do
        Result.Request := AuthorName;
      SearchType := TNsfwUrlType.User;
    end;

  end else if ( APost is TNBoxR34AppItem ) then begin

    Result := TNBoxSearchReqR34App.Create;
    Result.Request := TNBoxR34AppItem(APost).AuthorName;

  end else if ( APost is TNBoxCoomerPartyItem ) then begin

    var LPost: TNBoxCoomerPartyItem;
    var LReq: TNBoxSearchReqCoomerParty;
    LReq := TNBoxSearchReqCoomerParty.Create;
    LPost := ( APost as TNBoxCoomerPartyItem );

    LReq.Site := LPost.Site;
    LReq.UserId := LPost.Item.Author.Id;
    LReq.Service := LPost.Item.Author.Service;

    Result := LReq;
  end;

end;

function CreateTagReq(AOrigin: integer; ATag: string = ''): INBoxSearchRequest;
begin
  Result := CreateReqByOrigin(AOrigin);
  Result.Request := ATag;
  case AOrigin of
    ORIGIN_NSFWXXX:
      ( Result as TNBoxSearchReqNsfwXxx ).SearchType := TNsfwUrlType.Category;
    ORIGIN_GIVEMEPORNCLUB:
      ( Result as TNBoxSearchReqGmpClub ).SearchType := TGmpClubSearchType.Tag;
  end;

end;

function OriginToStr(AOrigin: integer): string;
begin
  Case AOrigin of
    ORIGIN_NSFWXXX: Result    := 'nsfw.xxx';
    ORIGIN_R34JSONAPI: Result := 'R34-json-api';
    ORIGIN_R34APP: Result     := 'R34.app';
    ORIGIN_GIVEMEPORNCLUB: Result := 'givemeporn.club';
    ORIGIN_9HENTAITO:  Result := '9hentai.to';
    ORIGIN_COOMERPARTY: Result := '(coomer\kemono).party';
    ORIGIN_MOTHERLESS: Result := 'motherless.com';

    ORIGIN_BOOKMARKS: Result  := 'Bookmarks';
    ORIGIN_PSEUDO: Result     := 'None';
    ORIGIN_RANDOMIZER: Result := 'Randomizer';
  end;
end;

end.

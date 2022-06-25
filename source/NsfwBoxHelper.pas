//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxHelper;

interface
uses
  NsfwBoxInterfaces,
  NsfwBoxOriginPseudo, NsfwBoxOriginNsfwXxx, NsfwBoxOriginR34App,
  NsfwBoxOriginBookmarks, NsfwBoxOriginR34JsonApi, NsfwBoxOriginConst,
  classes, sysutils, NsfwXxx.Types;

  function CreateItemByOrigin(AOrigin: integer): INBoxItem;
  function CreateReqByOrigin(AOrigin: integer): INBoxSearchRequest;
  function CreateRelatedReq(APost: INBoxItem): INBoxSearchRequest;
  function CreateAuthorReq(APost: INBoxItem): INBoxSearchRequest;

  function OriginToStr(AOrigin: integer): string;

implementation

function CreateItemByOrigin(AOrigin: integer): INBoxItem;
begin
  Case AOrigin of
    ORIGIN_NSFWXXX:    Result := TNBoxNsfwXxxItem.Create;
    ORIGIN_R34APP:     Result := TNBoxR34AppItem.Create;
    ORIGIN_R34JSONAPI: Result := TNBoxR34JsonApiItem.Create;
    ORIGIN_PSEUDO:     Result := TNBoxPseudoItem.Create;
  end;
end;

function CreateReqByOrigin(AOrigin: integer): INBoxSearchRequest;
begin
  Case AOrigin of
    ORIGIN_NSFWXXX:    Result := TNBoxSearchReqNsfwXxx.Create;
    ORIGIN_R34APP:     Result := TNBoxSearchReqR34App.Create;
    ORIGIN_R34JSONAPI: Result := TNBoxSearchReqR34JsonApi.Create;
    ORIGIN_PSEUDO:     Result := TNBoxSearchReqPseudo.Create;
    ORIGIN_BOOKMARKS:  Result := TNBoxSearchReqBookmarks.Create;
  end;
end;

function CreateRelatedReq(APost: INBoxItem): INBoxSearchRequest;
begin
  if ( APost is TNBoxNsfwxxxitem ) then begin
    Result := TNBoxSearchReqNsfwXxx.create;
    with ( Result as TNBoxSearchReqNsfwXxx ) do begin
      with ( APost as TNBoxNsfwXxxItem ) do
        Result.Request := UidInt.ToString;
      SearchType := TNsfwUrlType.Related;
    end;
  end else begin
    Result := nil;
  end;
end;

function CreateAuthorReq(APost: INBoxItem): INBoxSearchRequest;
begin
  if ( APost is TNBoxNsfwXxxItem ) then begin
    Result := TNBoxSearchReqNsfwXxx.create;
    with ( Result as TNBoxSearchReqNsfwXxx ) do begin
      with ( APost as TNBoxNsfwXxxItem ) do
        Result.Request := AuthorName;
      SearchType := TNsfwUrlType.User;
    end;
  end else begin
    Result := nil;
  end;
end;

function OriginToStr(AOrigin: integer): string;
begin
  Case AOrigin of
    ORIGIN_NSFWXXX: Result    := 'nsfw.xxx';
    ORIGIN_R34JSONAPI: Result := 'R34-json-api';
    ORIGIN_R34APP: Result     := 'R34.app';
    ORIGIN_BOOKMARKS: Result  := 'Bookmarks';
    ORIGIN_PSEUDO: Result     := 'None';
  end;
end;

end.

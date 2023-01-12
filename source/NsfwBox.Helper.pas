{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Helper;

interface
uses
  NsfwBox.Interfaces, NsfwBox.Logging,
  NsfwBox.Provider.Pseudo, NsfwBox.Provider.NsfwXxx, NsfwBox.Provider.R34App,
  NsfwBox.Provider.Bookmarks, NsfwBox.Provider.R34JsonApi,
  NsfwBox.Provider.GivemepornClub, NsfwBox.Provider.NineHentaiToApi,
  NsfwBox.Provider.CoomerParty,
  NsfwBox.Provider.Randomizer,
  NsfwBox.Provider.motherless,
  NsfwBox.Provider.Fapello,
  NsfwBox.Provider.Gelbooru,
  NsfwBox.Provider.Rule34xxx,
  NsfwBox.Consts,
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
  try
    Result := PROVIDERS.ById(AOrigin).ItemClass.Create;
  except
    On E: Exception do
      Log('CreateItemByOrigin(' + AOrigin.ToString + ')', E);
  end;
end;

function CreateReqByOrigin(AOrigin: integer): INBoxSearchRequest;
begin
  try
    Result := PROVIDERS.ById(AOrigin).RequestClass.Create;
  except
    On E: Exception do
      Log('CreateReqByOrigin(' + AOrigin.ToString + ')', E);
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
var
  LAuthor: IHasAuthor;
  LAuthorStr: string;
begin
  Result := nil;

  if Supports(APost, IHasAuthor, LAuthor) then begin
    LAuthorStr := LAuthor.AuthorName;
    if LAuthorStr.IsEmpty then Exit;
  end else
    Exit;

  if ( APost is TNBoxNsfwXxxItem ) then begin

    Result := TNBoxSearchReqNsfwXxx.create;
    with ( Result as TNBoxSearchReqNsfwXxx ) do begin
      Result.Request := LAuthorStr;
      SearchType := TNsfwUrlType.User;
    end;

  end else if ( APost is TNBoxR34AppItem ) then begin

    Result := TNBoxSearchReqR34App.Create;
    Result.Request := LAuthorStr;

  end else if ( APost is TNBoxCoomerPartyItem ) then begin

    var LPost := ( APost as TNBoxCoomerPartyItem );
    var LReq := TNBoxSearchReqCoomerParty.Create;
    LReq.Site := LPost.Site;
    LReq.UserId := LPost.Item.Author.Id;
    LReq.Service := LPost.Item.Author.Service;
    Result := LReq;

  end else if ( APost is TNBoxFapelloItem ) then begin

    var LPost := ( Apost As TNBoxFapelloItem);
    var LReq := TNBoxSearchReqFapello.Create;
    LReq.RequestKind := TFapelloItemKind.FlThumb;
    LReq.Request := LPost.AuthorName;
    Result := LReq;

  end else if ( APost is TNBoxBooruItemBase ) then begin

    var LReq := CreateReqByOrigin(APost.Origin);
    LReq.Request := LAuthorStr;
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
var
  LProvider: TNBoxProviderInfo;
begin
  LProvider := PROVIDERS.ById(AOrigin);
  if Assigned(LProvider) then
    Result := LProvider.TitleName
  else
    Result := '';
end;

end.

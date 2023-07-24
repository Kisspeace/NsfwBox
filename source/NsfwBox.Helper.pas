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
  NsfwBox.Provider.BooruScraper,
  NsfwBox.Consts,
  classes, sysutils, NsfwXxx.Types;

  function CreateItemByOrigin(AOrigin: integer): INBoxItem;
  function CreateReqByOrigin(AOrigin: integer): INBoxSearchRequest;
  function CreateRelatedReq(APost: INBoxItem): INBoxSearchRequest;
  function CreateArtistReq(APost: INBoxItem; AArtist: INBoxItemArtist): INBoxSearchRequest;
  function CreateTagReq(AOrigin: integer; ATag: INBoxItemTag): INBoxSearchRequest;
  function OriginToStr(AOrigin: integer): string;
  function SameId(AItem1, AItem2: INBoxItem): boolean;

implementation

function CreateItemByOrigin(AOrigin: integer): INBoxItem;
var
  LItemClass: TNBoxItemBaseClass;
begin
  try
    LItemClass := PROVIDERS.ById(AOrigin).ItemClass;

    if (LItemClass = TNBoxBooruItemBase) then
      Result := TNBoxBooruItemBase.Create(AOrigin)
    else
      Result := LItemClass.Create;
  except
    On E: Exception do
      Log('CreateItemByOrigin(' + AOrigin.ToString + ')', E);
  end;
end;

function CreateReqByOrigin(AOrigin: integer): INBoxSearchRequest;
var
  LRequestClass: TNBoxSearchRequestBaseClass;
begin
  try
    LRequestClass := PROVIDERS.ById(AOrigin).RequestClass;

    if (LRequestClass = TNBoxSearchReqBooru) then
      Result := TNBoxSearchReqBooru.Create(AOrigin)
    else
      Result := LRequestClass.Create;
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

function CreateArtistReq(APost: INBoxItem; AArtist: INBoxItemArtist): INBoxSearchRequest;
begin
  Result := nil;

  if ( APost is TNBoxNsfwXxxItem ) then begin

    Result := TNBoxSearchReqNsfwXxx.create;
    with ( Result as TNBoxSearchReqNsfwXxx ) do begin
      Result.Request := AArtist.DisplayName;
      SearchType := TNsfwUrlType.User;
    end;

  end else if ( APost is TNBoxR34AppItem ) then begin

    Result := TNBoxSearchReqR34App.Create;
    Result.Request := AArtist.DisplayName;

  end else if ( APost is TNBoxCoomerPartyItem ) then begin

    var LPost := ( APost as TNBoxCoomerPartyItem );
    var LReq := TNBoxSearchReqCoomerParty.Create;
    LReq.Site := LPost.Site;
    LReq.UserId := LPost.Item.Author.Id;
    LReq.Service := LPost.Item.Author.Service;
    Result := LReq;

  end else if ( APost is TNBoxFapelloItem ) then begin

    var LReq := TNBoxSearchReqFapello.Create;
    var LArtist: INBoxItemArtistFapello;
    Supports(AArtist, INBoxItemArtistFapello, LArtist);

    LReq.RequestKind := TFapelloItemKind.FlThumb;
    LReq.Request := LArtist.Artist.Username;
    Result := LReq;

  end else if ( APost is TNBoxBooruItemBase ) then begin

    var LReq := CreateReqByOrigin(APost.Origin);
    LReq.Request := AArtist.DisplayName;
    Result := LReq;

  end;
end;

function CreateTagReq(AOrigin: integer; ATag: INBoxItemTag): INBoxSearchRequest;
var
  L9HentaiTag: INBoxItemTag9HentaiTo;
begin
  Result := CreateReqByOrigin(AOrigin);
  case AOrigin of

    PVR_NSFWXXX:
      ( Result as TNBoxSearchReqNsfwXxx ).SearchType := TNsfwUrlType.Category;

    PVR_GIVEMEPORNCLUB:
      ( Result as TNBoxSearchReqGmpClub ).SearchType := TGmpClubSearchType.Tag; 

  end;

  if Supports(ATag, INBoxItemTag9HentaiTo, L9HentaiTag) 
  and (Result.Origin = PVR_9HENTAITO) then begin
    ( Result as TNBoxSearchReq9HentaiTo ).SearchRec.AddIncludedTag(L9HentaiTag.Tag)
  end else 
    Result.Request := ATag.Value;
    
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

function SameId(AItem1, AItem2: INBoxItem): boolean;
var
  LUIdStr: IUidAsStr;
  LUIdInt: IUidAsInt;
begin
  if TObject(AItem1).ClassType = TObject(AItem2).ClassType then
  begin
    if Supports(AItem1, IUidAsInt, LUidInt) then
      Exit(LUIdInt.UIdInt = (AItem2 as IUIdAsInt).UIdInt)
    else if Supports(AItem1, IUIdAsStr, LUIdStr) then
      Exit(LUIdStr.UIdStr = (AItem2 as IUIdAsStr).UIdStr)
    else if (AItem1 is TNBoxFapelloItem) then
    begin
      var LItem1: TNBoxFapelloItem := (AItem1 as TNBoxFapelloItem);
      var LItem2: TNBoxFapelloItem := (AItem2 as TNBoxFapelloItem);
      Exit(LItem1.ThumbItem.FullPageUrl = LItem2.ThumbItem.FullPageUrl);
    end;
  end else
    Exit(False);
end;

end.

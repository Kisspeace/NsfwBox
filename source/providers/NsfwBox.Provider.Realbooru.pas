unit NsfwBox.Provider.Realbooru;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  BooruScraper.Interfaces, BooruScraper.BaseTypes,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwBox.Utils,
  NsfwBox.Provider.Gelbooru;

type

  TNBoxRealbooruItem = class(TNBoxBooruItemBase,
   IHasArtists, IHasTags, IFetchableTags, IFetchableContent, IFetchableAuthors)
    public
      //--Properties--//
      property Origin;
      { -------------- }
      function Clone: INBoxItem; override;
      constructor Create; override;
  end;

  TNBoxSearchReqRealbooru = class(TNBoxSearchRequestBase)
    protected
      function GetOrigin: integer; override;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request;
      property PageId;
      constructor Create; override;
  end;

implementation

{ TNBoxRealbooruItem }

function TNBoxRealbooruItem.Clone: INBoxItem;
begin
  Result := TNBoxRealbooruItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxRealbooruItem.Create;
begin
  inherited;
  Self.FOrigin := PROVIDERS.Realbooru.Id;
end;

{ TNBoxSearchReqRealbooru }

function TNBoxSearchReqRealbooru.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqRealbooru.Create;
  with Result as TNBoxSearchReqRealbooru do begin
    PageId := self.FPageId;
    Request := Self.FRequest;
  end;
end;

constructor TNBoxSearchReqRealbooru.Create;
begin
  inherited;
  Self.FPageId := PROVIDERS.Realbooru.FisrtPageId;
end;

function TNBoxSearchReqRealbooru.GetOrigin: integer;
begin
  Result := PROVIDERS.Realbooru.Id;
end;

end.

unit NsfwBox.Provider.Xbooru;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  BooruScraper.Interfaces, BooruScraper.BaseTypes,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwBox.Utils,
  NsfwBox.Provider.Gelbooru;

type

  TNBoxXBooruItem = class(TNBoxBooruItemBase,
   IHasAuthor, IHasTags, IFetchableTags, IFetchableContent, IFetchableAuthors)
    public
      //--Properties--//
      property Origin;
      { -------------- }
      function Clone: INBoxItem; override;
      constructor Create; override;
  end;

  TNBoxSearchReqXBooru = class(TNBoxSearchRequestBase)
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

{ TNBoxXBooruItem }

function TNBoxXBooruItem.Clone: INBoxItem;
begin
  Result := TNBoxXBooruItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxXBooruItem.Create;
begin
  inherited;
  Self.FOrigin := PROVIDERS.XBooru.Id;
end;

{ TNBoxSearchReqXBooru }

function TNBoxSearchReqXBooru.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqXBooru.Create;
  with Result as TNBoxSearchReqXBooru do begin
    PageId := self.FPageId;
    Request := Self.FRequest;
  end;
end;

constructor TNBoxSearchReqXBooru.Create;
begin
  inherited;
  Self.FPageId := PROVIDERS.XBooru.FisrtPageId;
end;

function TNBoxSearchReqXBooru.GetOrigin: integer;
begin
  Result := PROVIDERS.XBooru.Id;
end;

end.

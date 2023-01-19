unit NsfwBox.Provider.Rule34us;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  BooruScraper.Interfaces, BooruScraper.BaseTypes,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwBox.Utils,
  NsfwBox.Provider.Gelbooru;

type

  TNBoxRule34usItem = class(TNBoxBooruItemBase,
   IHasAuthor, IHasTags, IFetchableTags, IFetchableContent, IFetchableAuthors)
    public
      //--Properties--//
      property Origin;
      { -------------- }
      function Clone: INBoxItem; override;
      constructor Create; override;
  end;

  TNBoxSearchReqRule34us = class(TNBoxSearchRequestBase)
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

{ TNBoxRule34usItem }

function TNBoxRule34usItem.Clone: INBoxItem;
begin
  Result := TNBoxRule34usItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxRule34usItem.Create;
begin
  inherited;
  Self.FOrigin := PROVIDERS.Rule34us.Id;
end;

{ TNBoxSearchReqRule34us }

function TNBoxSearchReqRule34us.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqRule34us.Create;
  with Result as TNBoxSearchReqRule34us do begin
    PageId := self.FPageId;
    Request := Self.FRequest;
  end;
end;

constructor TNBoxSearchReqRule34us.Create;
begin
  inherited;
  Self.FPageId := PROVIDERS.Rule34us.FisrtPageId;
end;

function TNBoxSearchReqRule34us.GetOrigin: integer;
begin
  Result := PROVIDERS.Rule34us.Id;
end;

end.

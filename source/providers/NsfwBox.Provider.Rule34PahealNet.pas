unit NsfwBox.Provider.Rule34PahealNet;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  BooruScraper.Interfaces, BooruScraper.BaseTypes,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwBox.Utils,
  NsfwBox.Provider.Gelbooru;

type

  TNBoxRule34PahealNetItem = class(TNBoxBooruItemBase,
   IHasArtists, IHasTags, IFetchableTags, IFetchableContent, IFetchableAuthors)
    public
      //--Properties--//
      property Origin;
      { -------------- }
      function Clone: INBoxItem; override;
      constructor Create; override;
  end;

  TNBoxSearchReqRule34PahealNet = class(TNBoxSearchRequestBase)
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

{ TNBoxRule34PahealNetItem }

function TNBoxRule34PahealNetItem.Clone: INBoxItem;
begin
  Result := TNBoxRule34PahealNetItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxRule34PahealNetItem.Create;
begin
  inherited;
  Self.FOrigin := PROVIDERS.Rule34PahealNet.Id;
end;

{ TNBoxSearchReqRule34PahealNet }

function TNBoxSearchReqRule34PahealNet.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqRule34PahealNet.Create;
  with Result as TNBoxSearchReqRule34PahealNet do begin
    PageId := self.FPageId;
    Request := Self.FRequest;
  end;
end;

constructor TNBoxSearchReqRule34PahealNet.Create;
begin
  inherited;
  Self.FPageId := PROVIDERS.Rule34PahealNet.FisrtPageId;
end;

function TNBoxSearchReqRule34PahealNet.GetOrigin: integer;
begin
  Result := PROVIDERS.Rule34PahealNet.Id;
end;

end.

{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.Rule34xxx;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  BooruScraper.Interfaces, BooruScraper.BaseTypes,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwBox.Utils,
  NsfwBox.Provider.Gelbooru;

type

  TNBoxRule34xxxItem = class(TNBoxBooruItemBase,
   IHasArtists, IHasTags, IFetchableTags, IFetchableContent, IFetchableAuthors)
    public
      //--Properties--//
      property Origin;
      { -------------- }
      function Clone: INBoxItem; override;
      constructor Create; override;
  end;

  TNBoxSearchReqRule34xxx = class(TNBoxSearchRequestBase)
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

{ TNBoxSearchReqRule34xxx }

function TNBoxSearchReqRule34xxx.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqRule34xxx.Create;
  with Result as TNBoxSearchReqRule34xxx do begin
    PageId := self.FPageId;
    Request := Self.FRequest;
  end;
end;

constructor TNBoxSearchReqRule34xxx.Create;
begin
  inherited;
  Self.FPageId := PROVIDERS.Rule34xxx.FisrtPageId;
end;

function TNBoxSearchReqRule34xxx.GetOrigin: integer;
begin
  Result := PROVIDERS.Rule34xxx.Id;
end;

{ TNBoxRule34xxxItem }

function TNBoxRule34xxxItem.Clone: INBoxItem;
begin
  Result := TNBoxRule34xxxItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxRule34xxxItem.Create;
begin
  inherited;
  Self.FOrigin := PROVIDERS.Rule34xxx.Id;
end;

end.

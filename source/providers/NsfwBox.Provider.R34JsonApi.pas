{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.R34JsonApi;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  NsfwBox.Interfaces, NsfwBox.Consts, R34JsonApi.Types;

type

  TNBoxR34JsonApiItem = class(TNBoxItemBase, IUIdAsInt, IHasTags)
    protected
      FItem: TR34Item;
      function GetTags: TNBoxItemTagAr;
      function GetUidInt: int64;
      function GetContentUrls: TArray<string>;               override;
      function GetThumbnailUrl: string;                      override;
    public
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      { new }
      property Item: TR34item read FItem write FItem;
      property Origin;
      [DISABLE] property UIdInt: int64 read GetUidInt;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property Tags: TNBoxItemTagAr read GetTags;
      constructor Create; override;
  end;

  TNBoxSearchReqR34JsonApi = class(TNBoxSearchRequestBase)
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request;
      property PageId;
      constructor Create; override;
  end;

implementation

{ TNBoxR34JsonApiItem }

procedure TNBoxR34JsonApiItem.Assign(ASource: INBoxItem);
begin
  if not ( ASource is TNBoxR34JsonApiItem ) then
    Exit;
  with ( ASource as TNBoxR34JsonApiItem ) do begin
    Self.Item := Item;
  end;
end;

function TNBoxR34JsonApiItem.Clone: INBoxItem;
begin
  Result := TNBoxR34JsonApiItem.Create;
  Result.Assign(self);
end;

constructor TNBoxR34JsonApiItem.Create;
begin
  Inherited;
  FOrigin := PVR_R34JSONAPI;
end;

function TNBoxR34JsonApiItem.GetContentUrls: TArray<string>;
begin
  Result := [FItem.file_url];
end;

function TNBoxR34JsonApiItem.GetTags: TNBoxItemTagAr;
begin
  Result := TNBoxItemTagBase.Convert(FItem.tags);
end;

function TNBoxR34JsonApiItem.GetThumbnailUrl: string;
begin
  Result := Fitem.preview_url;
end;

function TNBoxR34JsonApiItem.GetUidInt: int64;
begin
  TryStrToInt64(Fitem.id, Result);
end;

{ TNBoxSearchReqR34JsonApi }

function TNBoxSearchReqR34JsonApi.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqR34JsonApi.Create;
  with Result do begin
    Pageid := self.FPageId;
    Request := Self.FRequest;
  end;
end;

constructor TNBoxSearchReqR34JsonApi.Create;
begin
  inherited;
  FOrigin := PVR_R34JSONAPI;
end;

end.





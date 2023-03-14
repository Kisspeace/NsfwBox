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
      //procedure SetTags(const Value: TArray<string>);
      function GetTags: TNBoxItemTagAr;
      function GetUidInt: int64;
      //procedure SetUIdInt(const Value: int64);
      //procedure SetContentUrls(const Value: TArray<string>); override;
      function GetContentUrls: TArray<string>;               override;
      //procedure SetThumbnailUrl(const Value: string);        override;
      function GetThumbnailUrl: string;                      override;
    public
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      //--New--//
      property Item: TR34item read FItem write FItem;
      //--Properties--//
      property Origin;
      [DISABLE] property UIdInt: int64 read GetUidInt; // write SetUidInt;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property Tags: TNBoxItemTagAr read GetTags; // write SetTags;
      constructor Create; override;
  end;

  TNBoxSearchReqR34JsonApi = class(TNBoxSearchRequestBase)
    private
      function GetOrigin: integer; override;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request: string read FRequest write SetRequest;
      property PageId: integer read FPageId write SetPageId;
  end;

implementation

{ TNBoxR34XxxItem }

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
  FOrigin := PROVIDERS.R34JsonApi.Id;
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

//procedure TNBoxR34JsonApiItem.SetContentUrls(const Value: TArray<string>);
//begin
//  if length(Value) > 0 then
//    Fitem.file_url := Value[0]
//  else
//    Fitem.file_url := '';
//end;
//
//procedure TNBoxR34JsonApiItem.SetTags(const Value: TArray<string>);
//begin
//  FItem.tags := Value;
//end;
//
//procedure TNBoxR34JsonApiItem.SetThumbnailUrl(const Value: string);
//begin
//  FItem.preview_url := Value;
//end;

//procedure TNBoxR34JsonApiItem.SetUIdInt(const Value: int64);
//begin
//  FItem.id := Value.ToString;
//end;

{ TNBoxSearchReqR34Xxx }

function TNBoxSearchReqR34JsonApi.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqR34JsonApi.Create;
  with Result do begin
    Pageid := self.FPageId;
    Request := Self.FRequest;
  end;
end;

function TNBoxSearchReqR34JsonApi.GetOrigin: integer;
begin
  Result := PROVIDERS.R34JsonApi.Id;
end;

end.

{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.Fapello;

interface

uses
  System.SysUtils, System.Classes, XSuperObject,
  Fapello.Types, Fapello.Scraper,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwBox.Utils;

type

  TFapelloItemKind = (FlFeed, FlThumb);

  TNBoxFapelloItem = class(TNBoxItemBase,
   IHasAuthor, IFetchableContent)
    private
      FKind: TFapelloItemKind;
      FFeedItem: TFapelloFeedItem;
      FThumbItem: TFapelloThumb;
      FFull: TFapelloContentPage;
      function GetContentUrls: TArray<string>; override;
      function GetThumbnailUrl: string; override;
      function GetAuthorName: string;
      function GetContentFetched: boolean;
    public
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      //--New--//
      property Kind: TFapelloItemKind read FKind write FKind;
      property FeedItem: TFapelloFeedItem read FFeedItem write FFeedItem;
      property ThumbItem: TFapelloThumb read FThumbItem write FThumbItem;
      property Full: TFapelloContentPage read FFull write FFull;
      //--Properties--//
      property Origin;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property AuthorName: string read GetAuthorName;
      [DISABLE] property ContentFetched: boolean read GetContentFetched;
      constructor Create;
  end;

  TNBoxSearchReqFapello = class(TNBoxSearchRequestBase)
    private
      FRequestKind: TFapelloItemKind;
    protected
      function GetOrigin: integer;                        override;
    public
      function Clone: INBoxSearchRequest;                 override;
      property Origin;
      property Request;
      property PageId;
      property RequestKind: TFapelloItemKind read FRequestKind write FRequestKind;
      constructor Create; override;
  end;

implementation

{ TNBoxFapelloItem }

procedure TNBoxFapelloItem.Assign(ASource: INBoxItem);
begin
  inherited;
  if (not (ASource is TNBoxFapelloItem) ) then
    exit;

  with ( ASource as TNBoxFapelloItem ) do begin
    Self.FKind := Kind;
    Self.FFeedItem := FeedItem;
    Self.FThumbItem := ThumbItem;
    Self.FFull := Full;
  end;
end;

function TNBoxFapelloItem.Clone: INBoxItem;
begin
  Result := TNBoxFapelloItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxFapelloItem.Create;
begin
  FOrigin := PROVIDERS.Fapello.Id;
  Kind := FlFeed;
  FeedItem := TFapelloFeedItem.New;
  ThumbItem := TFapelloThumb.New;
  Full := TFapelloContentPage.New;
end;

function TNBoxFapelloItem.GetAuthorName: string;
begin
  Result := FFeedItem.Author.Username;
  if Result.IsEmpty then
    Result := FFull.Author.Username;
end;

function TNBoxFapelloItem.GetContentFetched: boolean;
begin
  Result := Length(FFull.Thumbnails) > 0;
end;

function TNBoxFapelloItem.GetContentUrls: TArray<string>;
begin
  Result := FFull.Thumbnails;
end;

function TNBoxFapelloItem.GetThumbnailUrl: string;
begin
  case FKind of
    FlFeed: Result := GetFirstStr(FFeedItem.Thumbnails);
    FlThumb: Result := FThumbItem.ThumbnailUrl;
  end;
end;

{ TNBoxSearchReqFapello }

function TNBoxSearchReqFapello.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqFapello.Create;
  with ( Result as TNBoxSearchReqFapello ) do begin
    Pageid := self.FPageId;
    Request := Self.FRequest;
    RequestKind := Self.FRequestKind;
  end;
end;

constructor TNBoxSearchReqFapello.Create;
begin
  inherited;
  PageId := PROVIDERS.Fapello.FisrtPageId;
  FRequestKind := FlFeed;
end;

function TNBoxSearchReqFapello.GetOrigin: integer;
begin
  Result := PROVIDERS.Fapello.Id;
end;

end.

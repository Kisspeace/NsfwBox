{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.NineHentaiToApi;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  Ninehentaito.APITypes, NsfwBox.Interfaces, NsfwBox.Consts;

type

  TNBox9HentaitoItem = class(TNBoxItemBase, IUIdAsInt, IHasTags, IHasCaption) //IBook
    private
      FItem: T9HentaiBook;
      //FCurrentPage: integer; // default = -1 display cover image
      function GetTags: TArray<string>;
      function GetTagsCount: integer;
      function GetCaption: string;
      function GetContentUrls: TArray<string>;               override;
      function GetThumbnailUrl: string;                      override;
      function GetUidInt: int64;
    public
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      //--New--//
      property Item: T9HentaiBook read FItem write FItem;
      //--Properties--//
      property Origin;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property UIdInt: int64 read GetUidInt;
      [DISABLE] property Caption: string read GetCaption;
      [DISABLE] property Tags: TArray<string> read GetTags;
      constructor Create(AWithItem: boolean); overload;
      constructor Create; overload; override;
      destructor Destroy; override;
  end;

  TNBoxSearchReq9Hentaito = class(TNBoxSearchRequestBase, INBoxSearchRequest,
   IHasOrigin)
    protected
      FSearchRec: T9HentaiBookSearchRec;
      //FIncludedTags: T9HentaiTagAr;
      //FExcludedTags: T9HentaiTagAr;
      function GetOrigin: integer; override;
      procedure SetRequest(const value: string); override;
      function GetRequest: string;               override;
      procedure SetPageId(const value: integer); override;
      function GetPageId: integer; override;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property SearchRec: T9HentaiBookSearchRec read FSearchRec write FSearchRec;
      [DISABLE] property Request: string read GetRequest write SetRequest;
      [DISABLE] property PageId: integer read GetPageId write SetPageId;
      constructor Create;
  end;

implementation

{ TNBox9HentaitoItem }

procedure TNBox9HentaitoItem.Assign(ASource: INBoxItem);
begin
  inherited;
  if not ( ASource is TNBox9HentaitoItem ) then
    Exit;
  with ( ASource as TNBox9HentaitoItem ) do begin
    Self.FItem.Id := Item.Id;
    Self.FItem.Title := Item.Title;
    Self.FItem.AltTitle := Item.AltTitle;
    Self.FItem.TotalPage := Item.TotalPage;
    Self.FItem.TotalFavorite := Item.TotalFavorite;
    Self.FItem.TotalDownload := Item.TotalDownload;
    Self.FItem.TotalView := Item.TotalView;
    Self.FItem.ImageServer := Item.ImageServer;
    Self.FItem.Tags := Item.Tags;
  end;
end;

function TNBox9HentaitoItem.Clone: INBoxItem;
begin
  Result := TNBox9HentaitoItem.Create;
  Result.Assign(Self);
end;

constructor TNBox9HentaitoItem.Create;
begin
  Create(True);
end;

constructor TNBox9HentaitoItem.Create(AWithItem: boolean);
begin
  FOrigin := PROVIDERS.NineHentaiTo.Id;
  if AWithItem then
    FItem := T9HentaiBook.Create;
end;

destructor TNBox9HentaitoItem.Destroy;
begin
  FItem.Free;
  inherited;
end;

function TNBox9HentaitoItem.GetCaption: string;
begin
  Result := Item.Title;
end;

function TNBox9HentaitoItem.GetContentUrls: TArray<string>;
var
  I: integer;
begin
  SetLength(Result, Item.TotalPage);
  for I := 0 to high(Result) do begin
    Result[I] := Item.GetImageUrl(I + 1);
  end;
end;

function TNBox9HentaitoItem.GetTags: TArray<string>;
var
  I: integer;
begin
  SetLength(Result, Length(Item.Tags));
  for I := 0 to High(Result) do
    Result[i] := Item.Tags[I].Name;
end;

function TNBox9HentaitoItem.GetTagsCount: integer;
begin
  Result := length(Item.Tags);
end;

function TNBox9HentaitoItem.GetThumbnailUrl: string;
begin
  Result := Item.GetSmallCoverUrl;
end;

function TNBox9HentaitoItem.GetUidInt: int64;
begin
  Result := Item.Id;
end;

{ TNBoxSearchReq9Hentaito }

function TNBoxSearchReq9Hentaito.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReq9Hentaito.Create;
  with ( Result as TNBoxSearchReq9Hentaito ) do
    SearchRec := Self.FSearchRec;
end;

constructor TNBoxSearchReq9Hentaito.Create;
begin
  FSearchRec := T9HentaiBookSearchRec.New;
end;

function TNBoxSearchReq9Hentaito.GetOrigin: integer;
begin
  Result := PROVIDERS.NineHentaiTo.Id;
end;

function TNBoxSearchReq9Hentaito.GetPageId: integer;
begin
  Result := FSearchRec.Page;
end;

function TNBoxSearchReq9Hentaito.GetRequest: string;
begin
  Result := FSearchRec.Text;
end;

procedure TNBoxSearchReq9Hentaito.SetPageId(const value: integer);
begin
  FSearchRec.Page := value;
end;

procedure TNBoxSearchReq9Hentaito.SetRequest(const value: string);
begin
  FSearchRec.text := value;
end;

end.

{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.Pseudo;

interface
uses
  System.SysUtils, System.Classes, XSuperObject, NsfwBox.Interfaces,
  NsfwBox.Consts;

type

  // This item used to test graphic interface on dev mode

  TNBoxPseudoItem = class(TNBoxItemBase, INBoxItem, IHasCaption)
    private
      FUrls: TArray<string>;
      FThumb: string;
    protected
      //--Setters and Getters--//
      procedure SetContentUrls(const Value: TArray<string>);
      function GetContentUrls: TArray<string>;               override;
      procedure SetThumbnailUrl(const Value: string);
      function GetThumbnailUrl: string;                      override;
      function GetCaption: string;
    public
      procedure Assign(ASource: INBoxItem);                  override;
      function Clone: INBoxItem;                             override;
      //--Properties--//
      property Origin;
      [DISABLE] property ThumbnailUrl: string read GetThumbnailUrl write SetThumbnailUrl;
      [DISABLE] property ContentUrls: TArray<string> read GetContentUrls write SetContentUrls;
      [DISABLE] property Caption: string read GetCaption;
      [ALIAS('ThumbnailUrl')] property _ThumbnailUrl: string read FThumb write FThumb; // serialize
      [ALIAS('ContentUrls')] property _ContentUrls: TArray<string> read FUrls write FUrls; // serialize
      constructor Create; override;
  end;

  TNBoxSearchReqPseudo = class(TNBoxSearchRequestBase)
    protected
      //--Setters and Getters--//
      function GetOrigin: integer; override;
    public
      function Clone: INBoxSearchRequest; override;
      //--Properties--//
      property Origin: integer read GetOrigin;
      property Request;
      property PageId;
  end;

implementation

{ TNBoxPseudoItem }

procedure TNBoxPseudoItem.Assign(ASource: INBoxItem);
var
  I: TNBoxPseudoItem;
begin
  if not ( ASource is TNBoxPseudoItem ) then
    Exit;

  with ( ASource as TNBoxPseudoItem ) do begin
    self.FUrls   := ContentUrls;
    self.FThumb  := ThumbnailUrl;
    self.FOrigin        := Origin;
  end;
end;

function TNBoxPseudoItem.Clone: INBoxItem;
begin
  Result := TNBoxPseudoItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxPseudoItem.Create;
begin
  FOrigin := ORIGIN_PSEUDO;
end;

function TNBoxPseudoItem.GetCaption: string;
begin
  Result := Self.ContentUrl;
end;

function TNBoxPseudoItem.GetContentUrls: TArray<string>;
begin
  Result := Furls;
end;

function TNBoxPseudoItem.GetThumbnailUrl: string;
begin
  Result := FThumb;
end;

procedure TNBoxPseudoItem.SetContentUrls(const Value: TArray<string>);
begin
  Furls := Value;
end;

procedure TNBoxPseudoItem.SetThumbnailUrl(const Value: string);
begin
  FThumb := Value;
end;

{ TNBoxSearchReqPseudo }

function TNBoxSearchReqPseudo.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqPseudo.Create;
  with Result do begin
    Pageid := self.PageId;
    Request := Self.Request;
  end;
end;

function TNBoxSearchReqPseudo.GetOrigin: integer;
begin
  Result := PROVIDERS.Pseudo.Id;
end;

end.

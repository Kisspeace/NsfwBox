{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Consts;

interface
uses
  SysUtils, System.Classes, System.Generics.Collections,
  NsfwBox.Interfaces;

const
  ORIGIN_RANDOMIZER     = -3;
  ORIGIN_PSEUDO         = -2;
  ORIGIN_BOOKMARKS      = -1;
  ORIGIN_NSFWXXX        = 0;
  ORIGIN_R34JSONAPI     = 1;
  ORIGIN_R34APP         = 2;
  ORIGIN_GIVEMEPORNCLUB = 3;
  ORIGIN_9HENTAITO      = 4;
  ORIGIN_COOMERPARTY    = 5;
  ORIGIN_MOTHERLESS     = 6;
  PVR_FAPELLO           = 7; { PVR = provider }
  PVR_RULE34XXX         = 8;
  PVR_GELBOORU          = 9;
  PVR_REALBOORU         = 10;
  PVR_RULE34US          = 11;
  PVR_RULE34PAHEALNET   = 12;
  PVR_XBOORU            = 13;
  PVR_HYPNOHUBNET       = 14;
  PVR_TBIB              = 15;
  PVR_DANBOORU          = 16;
  PVR_ALLTHEFALLEN      = 17;
  PVR_BLEACHBOORU       = 18;

type

  TNBoxProviderInfo = Class(TObject)
    private
      FId: integer;
      FTitleName: string;
      FFirstPageId: integer;
      FIsWeb: boolean;
      FVisibleByDefault: boolean;
      FRequestClass: TNBoxSearchRequestBaseClass;
      FItemClass: TNBoxItemBaseClass;
    public
      property Id: Integer read FId;
      property TitleName: string read FTitleName;
      property RequestClass: TNBoxSearchRequestBaseClass read FRequestClass;
      property ItemClass: TNBoxItemBaseClass read FItemClass;
      property FisrtPageId: integer read FFirstPageId; { r34.app: 0, nsfw.xxx: 1 }
      property IsWeb: boolean read FIsWeb;
      property VisibleByDefault: boolean read FVisibleByDefault;
      { property ClassItem }
      { property ClassSearchRequest }
  End;

  TNBoxProviders = Class(TObject)
    strict private
      FItems: TObjectList<TNBoxProviderInfo>;
      { ------------------------- }
      FRandomizer: TNBoxProviderInfo;
      FPseudo: TNBoxProviderInfo;
      FBookmarks: TNBoxProviderInfo;
      { ------------------------- }
      FNsfwXxx: TNBoxProviderInfo;
      FR34App: TNBoxProviderInfo;
      FR34JsonApi: TNBoxProviderInfo;
      FCoomerParty: TNBoxProviderInfo;
      FGMPClub: TNBoxProviderInfo;
      FMotherless: TNBoxProviderInfo;
      F9HentaiTo: TNBoxProviderInfo;
      FFapello: TNBoxProviderInfo;
      FRule34xxx: TNBoxProviderInfo;
      FGelbooru: TNBoxProviderInfo;
      FRealbooru: TNBoxProviderInfo;
      FRule34us: TNBoxProviderInfo;
      FRule34PahealNet: TNBoxProviderInfo;
      FXBooru: TNBoxProviderInfo;
      FHypnohub: TNBoxProviderInfo;
      FTbib: TNBoxProviderInfo;
      FDanbooru: TNBoxProviderInfo;
      FAllTheFallen: TNBoxProviderInfo;
      FBleachbooru: TNBoxProviderInfo;
    private
      function GetItem(I: Integer): TNBoxProviderInfo;
      function GetCount: integer;
    public
      function ById(AId: Integer): TNBoxProviderInfo;
      property Items[I: Integer]: TNBoxProviderInfo read GetItem; default;
      property Count: integer read GetCount;
      { ------------------------- }
      property NsfwXxx: TNBoxProviderInfo read FNsfwXxx;
      property R34App: TNBoxProviderInfo read FR34App;
      property R34JsonApi: TNBoxProviderInfo read FR34JsonApi;
      property CoomerParty: TNBoxProviderInfo read FCoomerParty;
      property GMPClub: TNBoxProviderInfo read FGMPClub;
      property Motherless: TNBoxProviderInfo read FMotherless;
      property NineHentaiTo: TNBoxProviderInfo read F9HentaiTo;
      property Fapello: TNBoxProviderInfo read FFapello;
      property Rule34xxx: TNBoxProviderInfo read FRule34xxx;
      property Gelbooru: TNBoxProviderInfo read FGelbooru;
      property Realbooru: TNBoxProviderInfo read FRealbooru;
      property Rule34us: TNBoxProviderInfo read FRule34us;
      property Rule34PahealNet: TNBoxProviderInfo read FRule34PahealNet;
      property XBooru: TNBoxProviderInfo read FXBooru;
      property Hypnohub: TNBoxProviderInfo read FHypnohub;
      property TBib: TNBoxProviderInfo read FTbib;
      property Danbooru: TNBoxProviderInfo read FDanbooru;
      property AllTheFallen: TNBoxProviderInfo read FAllTheFallen;
      property Bleachbooru: TNBoxProviderInfo read FBleachbooru;
      { ------------------------- }
      property Randomizer: TNBoxProviderInfo read FRandomizer;
      property Pseudo: TNBoxProviderInfo read FPseudo;
      property Bookmarks: TNBoxProviderInfo read FBookmarks;
      { ------------------------- }
      constructor Create;
      destructor Destroy; override;
  End;

var
  PROVIDERS: TNBoxProviders;

implementation
uses
  NsfwBox.Provider.NsfwXxx, NsfwBox.Provider.R34JsonApi,
  NsfwBox.Provider.R34App, NsfwBox.Provider.Pseudo,
  NsfwBox.Provider.Bookmarks, NsfwBox.Provider.GivemepornClub,
  NsfwBox.Provider.NineHentaiToApi, NsfwBox.Provider.CoomerParty,
  NsfwBox.Provider.motherless, NsfwBox.Provider.Randomizer,
  NsfwBox.Provider.Fapello, NsfwBox.Provider.BooruScraper;

{ TNBoxProviders }

function TNBoxProviders.ById(AId: Integer): TNBoxProviderInfo;
var
  I: integer;
begin
  for I := 0 to Self.Count - 1 do
    if Self.Items[I].Id = AId then begin
      Result := Self.Items[I];
      exit;
    end;
  Result := nil;
end;

constructor TNBoxProviders.Create;

  function Add(AId: integer; ATitleName: string; AFirstPageId: integer;
    ARequestClass: TNBoxSearchRequestBaseClass; AItemClass: TNBoxItemBaseClass;
    AIsWeb: boolean = True; AVisibleByDefault: boolean = True): TNBoxProviderInfo;
  begin
    Result := TNBoxProviderInfo.Create;
    Result.FId := AId;
    Result.FTitleName := ATitleName;
    Result.FItemClass := AItemClass;
    Result.FRequestClass := ARequestClass;
    Result.FFirstPageId := AFirstPageId;
    Result.FIsWeb := AIsWeb;
    Result.FVisibleByDefault := AVisibleByDefault;
    FItems.Add(Result);
  end;

begin
  FItems := TObjectList<TNBoxProviderInfo>.Create;
  FBookmarks   := Add(ORIGIN_BOOKMARKS, 'Bookmarks', 1, TNBoxSearchReqBookmarks, nil, False, False);
  FPseudo      := Add(ORIGIN_PSEUDO, 'Files', 1, TNBoxSearchReqPseudo, TNBoxPseudoItem, False, False);

  FNsfwXxx     := Add(ORIGIN_NSFWXXX, 'nsfw.xxx', 1, TNBoxSearchReqNsfwXxx, TNBoxNsfwXxxItem);
  FCoomerParty := Add(ORIGIN_COOMERPARTY, 'coomer.party \ kemono.party', 1, TNBoxSearchReqCoomerParty, TNBoxCoomerPartyItem);
  FGMPClub     := Add(ORIGIN_GIVEMEPORNCLUB, 'givemeporn.club', 1, TNBoxSearchReqGmpClub, TNBoxGmpClubItem);
  FMotherless  := Add(ORIGIN_MOTHERLESS, 'motherless.com', 1, TNBoxSearchReqMotherless, TNBoxMotherlessItem);
  F9HentaiTo   := Add(ORIGIN_9HENTAITO, '9hentai.to', 0, TNBoxSearchReq9Hentaito, TNBox9HentaitoItem);
  FFapello     := Add(PVR_FAPELLO, 'Fapello.com', 1, TNBoxSearchReqFapello, TNBoxFapelloItem);
  FRule34xxx   := Add(PVR_RULE34XXX, 'Rule34.xxx', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);
  FGelbooru    := Add(PVR_GELBOORU, 'Gelbooru.com', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);
  FRealbooru   := Add(PVR_REALBOORU, 'Realbooru.com', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);
  FTbib        := Add(PVR_TBIB, 'Tbib.org', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);
  FRule34us    := Add(PVR_RULE34US, 'Rule34.us', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);
  FRule34PahealNet := Add(PVR_RULE34PAHEALNET, 'Rule34.paheal.net', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);
  FXBooru      := Add(PVR_XBOORU, 'Xbooru.com', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);
  FHypnohub    := Add(PVR_HYPNOHUBNET, 'Hypnohub.net', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);
  FDanbooru    := Add(PVR_DANBOORU, 'Danbooru.donmai.us', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);
  FAllTheFallen := Add(PVR_ALLTHEFALLEN, 'booru.allthefallen.moe', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);
  FBleachbooru := Add(PVR_BLEACHBOORU, 'bleachbooru.org', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase);

  FR34JsonApi  := Add(ORIGIN_R34JSONAPI, 'r34 JSON API', 0, TNBoxSearchReqR34JsonApi, TNBoxR34JsonApiItem);
  FR34App      := Add(ORIGIN_R34APP, 'r34.app', 0, TNBoxSearchReqR34App, TNBoxR34AppItem);
  FRandomizer  := Add(ORIGIN_RANDOMIZER, 'Randomizer', 0, TNBoxSearchReqRandomizer, nil, True, True);
end;

destructor TNBoxProviders.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TNBoxProviders.GetCount: integer;
begin
  Result := FItems.Count;
end;

function TNBoxProviders.GetItem(I: Integer): TNBoxProviderInfo;
begin
  Result := FItems.Items[I];
end;

initialization
  PROVIDERS := TNBoxProviders.Create;
finalization
  PROVIDERS.Free;
end.

{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Consts;

interface
uses
  { BooruScraper ------------ }
  BooruScraper.Urls,
  BooruScraper.Interfaces,
  BooruScraper.ClientBase,
  BooruScraper.Client.API.danbooru,
  BooruScraper.Client.API.TbibOrg,
  BooruScraper.Client.BepisDb,
  BooruScraper.Client.CompatibleGelbooru,
  BooruScraper.Client.e621,
  BooruScraper.Client.KenzatoUk,
  BooruScraper.Client.rule34PahealNet,
  BooruScraper.Client.Rule34us,
  BooruScraper.Parser.API.danbooru,
  BooruScraper.Parser.API.TbibOrg,
  BooruScraper.Parser.BepisDb,
  BooruScraper.Parser.e621,
  BooruScraper.Parser.gelbooru,
  BooruScraper.Parser.Kenzatouk,
  BooruScraper.Parser.Realbooru,
  BooruScraper.Parser.rule34PahealNet,
  BooruScraper.Parser.rule34us,
  BooruScraper.Parser.rule34xxx,
  { ------------------------- }
  SysUtils, System.Classes, System.Generics.Collections,
  NsfwBox.Interfaces, NsfwBox.Utils, System.JSON;

const
  { PVR = provider }
  PVR_RANDOMIZER     = -3;
  PVR_PSEUDO         = -2;
  PVR_BOOKMARKS      = -1;
  PVR_NSFWXXX        = 0;
  PVR_R34JSONAPI     = 1;
  PVR_R34APP         = 2;
  PVR_GIVEMEPORNCLUB = 3;
  PVR_9HENTAITO      = 4;
  PVR_COOMERPARTY    = 5;
  PVR_MOTHERLESS     = 6;
  PVR_FAPELLO           = 7;
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
  PVR_ILLUSIONCARDS     = 19;
  PVR_BEPISDB           = 20;
  PVR_HGOONBOORU        = 21;
  PVR_E621              = 22;
  PVR_BOORUSCRAPER      = 23;

  CUSTOM_PVR_ID_MIN = 1000;

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
      function CreateBaseRequest: INBoxSearchRequest; virtual;
      function CreateBaseItem: INBoxItem;
      function IsCustom: boolean;
      function IsPredefined: boolean;
      property Id: Integer read FId;
      property TitleName: string read FTitleName write FTitleName;
      property RequestClass: TNBoxSearchRequestBaseClass read FRequestClass;
      property ItemClass: TNBoxItemBaseClass read FItemClass;
      property FisrtPageId: integer read FFirstPageId; { r34.app: 0, nsfw.xxx: 1 }
      property IsWeb: boolean read FIsWeb;
      property VisibleByDefault: boolean read FVisibleByDefault;
  End;

  TNBoxProviderInfoCustom = Class(TNBoxProviderInfo)
    private
      FHost: string;
      FParentProvider: TNBoxProviderInfo;
    public
      function CreateBaseRequest: INBoxSearchRequest; override;
      function GetAdditionalJsonData: string; virtual;
      procedure SetAdditionalData(AJsonData: string); virtual;
      property ParentProvider: TNBoxProviderInfo read FParentProvider;
      property Host: string read FHost write FHost;
      constructor Create(AParent: TNBoxProviderInfo);
  End;

  TBooruScraperClientType = (
    bsTGelbooruLikeClient,
    bsTGelbooruClient,
    bsTRule34usClient,
    bsTRule34PahealNetClient,
    bsTKenzatoUkClient,
    bsTTbibAPIClient,
    bsTDanbooruAPIClient,
    bsTe621Client
  );

  TBooruScraperParserType = (
    bsTGelbooruParser,
    bsTe621Parser,
    bsTBepisDbParser,
    bsTTbibOrgAPIParser,
    bsTDanbooruAPIParser,
    bsTRule34xxxParser,
    bsTRule34usParser,
    bsTRule34pahealnetParser,
    bsTRealbooruParser,
    bsTKenzatoUkParser
  );

  TNBoxProviderInfoCustomBooruScraper = Class(TNBoxProviderInfoCustom)
    private
      FClientType: TBooruScraperClientType;
      FParserType: TBooruScraperParserType;
    public
      function CreateBaseRequest: INBoxSearchRequest; override;
      function GetAdditionalJsonData: string; override;
      procedure SetAdditionalData(AJsonData: string); override;
      property ClientType: TBooruScraperClientType read FClientType write FClientType;
      property ParserType: TBooruScraperParserType read FParserType write FParserType;
  End;

  TNBoxProviders = Class(TObject)
    strict private
      FItems: TObjectList<TNBoxProviderInfo>;
      FCustomProviderBiggerId: integer;
      { ------------------------- }
      FRandomizer,
      FPseudo,
      FBookmarks,
      { ------------------------- }
      FNsfwXxx,
      FR34App,
      FR34JsonApi,
      FCoomerParty,
      FGMPClub,
      FMotherless,
      F9HentaiTo,
      FFapello,
      FRule34xxx,
      FGelbooru,
      FRealbooru,
      FRule34us,
      FRule34PahealNet,
      FXBooru,
      FHypnohub,
      FTbib,
      FDanbooru,
      FAllTheFallen,
      FBleachbooru,
      FIllusioncards,
      FBepisDb,
      FHgoonBooru,
      FE621,
      FBooruScraper
      : TNBoxProviderInfo;
    private
      function GetNextCustomId: integer;
      function GetItem(I: Integer): TNBoxProviderInfo;
      function GetCount: integer;
    public
      function ById(AId: Integer): TNBoxProviderInfo;
      function AddProvider(ANew: TNBoxProviderInfo): boolean;
      { -------------------------- }
      function AddCustomBooru(ATitleName: string;
        AClientType: TBooruScraperClientType;
        AParserType: TBooruScraperParserType;
        AHost: string; AId: integer = -1): TNBoxProviderInfoCustomBooruScraper;
      { -------------------------- }
      property Items[I: Integer]: TNBoxProviderInfo read GetItem;
      property ProvidersById[AId: integer]: TNBoxProviderInfo read ById; default;
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
      property IllusionCards: TNBoxProviderInfo read FIllusioncards;
      property BepisDb: TNBoxProviderInfo read FBepisDb;
      property HGoonBooru: TNBoxProviderInfo read FHgoonBooru;
      property E621: TNBoxProviderInfo read FE621;
      property BooruScraper: TNBoxProviderInfo read FBooruScraper;
      { ------------------------- }
      property Randomizer: TNBoxProviderInfo read FRandomizer;
      property Pseudo: TNBoxProviderInfo read FPseudo;
      property Bookmarks: TNBoxProviderInfo read FBookmarks;
      { ------------------------- }
      constructor Create;
      destructor Destroy; override;
  End;

  function GetClientTypeById(AId: TBooruScraperClientType): TBooruClientBaseClass;
  function GetParserTypeById(AId: TBooruScraperParserType): TBooruParserClass;

var
  PROVIDERS: TNBoxProviders;

  LOG_FILENAME         : string = 'log.txt';
  YDW_LOG_FILENAME     : string = 'you-did-well-debug-log.txt';
  SETTINGS_FILENAME    : string = 'settings.json';
  BOOKMARKSDB_FILENAME : string = 'bookmarks.sqlite';
  SESSION_FILENAME     : string = 'session.sqlite';
  HISTORY_FILENAME     : string = 'history.sqlite';

implementation
uses
  NsfwBox.Provider.NsfwXxx, NsfwBox.Provider.R34JsonApi,
  NsfwBox.Provider.R34App, NsfwBox.Provider.Pseudo,
  NsfwBox.Provider.Bookmarks, NsfwBox.Provider.GivemepornClub,
  NsfwBox.Provider.NineHentaiToApi, NsfwBox.Provider.CoomerParty,
  NsfwBox.Provider.motherless, NsfwBox.Provider.Randomizer,
  NsfwBox.Provider.Fapello, NsfwBox.Provider.BooruScraper,
  NsfwBox.Provider.BepisDb;

function GetClientTypeById(AId: TBooruScraperClientType): TBooruClientBaseClass;
begin
  case AId of
    bsTGelbooruLikeClient: Result := TGelbooruLikeClient;
    bsTGelbooruClient: Result := TGelbooruClient;
    bsTRule34usClient: Result := TRule34usClient;
    bsTRule34PahealNetClient: Result := TRule34PahealNetClient;
    bsTKenzatoUkClient: Result := TKenzatoUkClient;
    bsTTbibAPIClient: Result := TTbibAPIClient;
    bsTDanbooruAPIClient: Result := TDanbooruAPIClient;
    bsTe621Client: Result := Te621Client;
  end;
end;

function GetParserTypeById(AId: TBooruScraperParserType): TBooruParserClass;
begin
  case AId of
    bsTGelbooruParser: Result := TGelbooruParser;
    bsTe621Parser: Result := Te621Parser;
    bsTBepisDbParser: Result := TBepisDbParser;
    bsTTbibOrgAPIParser: Result := TTbibOrgAPIParser;
    bsTDanbooruAPIParser: Result := TDanbooruAPIParser;
    bsTRule34xxxParser: Result := TRule34xxxParser;
    bsTRule34usParser: Result := TRule34usParser;
    bsTRule34pahealnetParser: Result := TRule34pahealnetParser;
    bsTRealbooruParser: Result := TRealbooruParser;
    bsTKenzatoUkParser: Result := TKenzatoUkParser;
  end;
end;

{ TNBoxProviders }

function TNBoxProviders.AddCustomBooru(ATitleName: string;
  AClientType: TBooruScraperClientType; AParserType: TBooruScraperParserType;
  AHost: string; AId: integer = -1): TNBoxProviderInfoCustomBooruScraper;
begin
  Result := TNBoxProviderInfoCustomBooruScraper.Create(FBooruScraper);
  Result.FClientType := AClientType;
  Result.FParserType := AParserType;
  Result.TitleName := ATitleName;
  Result.Host := AHost;
  if (AId <> -1)
    then Result.FId := AId
    else Result.FId := Self.GetNextCustomId;
  Self.AddProvider(Result);
end;

function TNBoxProviders.AddProvider(ANew: TNBoxProviderInfo): boolean;
begin
  Result := not Assigned(ById(ANew.Id));
  if Result then FItems.Add(ANew);
end;

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
    AddProvider(Result);
  end;

  function AddCustom(ATitleName: string; AParent: TNBoxProviderInfo;
    AHost: string): TNBoxProviderInfoCustom;
  begin
    Result := TNBoxProviderInfoCustom.Create(AParent);
    Result.FTitleName := ATitleName;
    Result.FHost := Ahost;
    Result.FId := Self.GetNextCustomId;
    AddProvider(Result);
  end;

begin
  FCustomProviderBiggerId := CUSTOM_PVR_ID_MIN;
  FItems := TObjectList<TNBoxProviderInfo>.Create;
  FBookmarks   := Add(PVR_BOOKMARKS, 'Bookmarks', 1, TNBoxSearchReqBookmarks, nil, False, False);
  FPseudo      := Add(PVR_PSEUDO, 'Files', 1, TNBoxSearchReqPseudo, TNBoxPseudoItem, False, False);

  FNsfwXxx     := Add(PVR_NSFWXXX, 'nsfw.xxx', 1, TNBoxSearchReqNsfwXxx, TNBoxNsfwXxxItem);
  FCoomerParty := Add(PVR_COOMERPARTY, 'coomer.party \ kemono.party', 1, TNBoxSearchReqCoomerParty, TNBoxCoomerPartyItem);
  FGMPClub     := Add(PVR_GIVEMEPORNCLUB, 'givemeporn.club', 1, TNBoxSearchReqGmpClub, TNBoxGmpClubItem);
  FMotherless  := Add(PVR_MOTHERLESS, 'motherless.com', 1, TNBoxSearchReqMotherless, TNBoxMotherlessItem);
  F9HentaiTo   := Add(PVR_9HENTAITO, '9hentai.to', 0, TNBoxSearchReq9Hentaito, TNBox9HentaitoItem);
  FFapello     := Add(PVR_FAPELLO, 'Fapello.com', 1, TNBoxSearchReqFapello, TNBoxFapelloItem);
  FBooruScraper := Add(PVR_BOORUSCRAPER, 'booru scraper', 0, TNBoxSearchReqBooru, TNBoxBooruItemBase); {PVR_BOORUSCRAPER}
  FBepisDb     := Add(PVR_BEPISDB, 'db.bepis.moe', 0, TNBoxSearchReqBepisDb, TNBoxBooruItemBase);

  FRule34xxx   := AddCustomBooru('Rule34.xxx', bsTGelbooruLikeClient, bsTRule34xxxParser, RULE34XXX_URL, PVR_RULE34XXX); {PVR_RULE34XXX}
  FGelbooru    := AddCustomBooru('Gelbooru.com', bsTGelbooruClient, bsTGelbooruParser, GELBOORU_URL, PVR_GELBOORU); {PVR_GELBOORU}
  FRealbooru   := AddCustomBooru('Realbooru.com', bsTGelbooruLikeClient, bsTRealbooruParser, REALBOORU_URL, PVR_REALBOORU); {PVR_REALBOORU}
  FTbib        := AddCustomBooru('Tbib.org', bsTTbibAPIClient, bsTTbibOrgAPIParser, TBIBORG_URL, PVR_TBIB); {PVR_TBIB}
  FRule34us    := AddCustomBooru('Rule34.us', bsTRule34usClient, bsTRule34usParser, RULE34US_URL, PVR_RULE34US); {PVR_RULE34US}
  FRule34PahealNet := AddCustomBooru('Rule34.paheal.net', bsTRule34PahealNetClient, bsTRule34pahealnetParser, RULE34PAHEALNET_URL, PVR_RULE34PAHEALNET); {PVR_RULE34PAHEALNET}
  FXBooru      := AddCustomBooru('Xbooru.com', bsTGelbooruLikeClient, bsTRule34xxxparser, XBOORU_URL, PVR_XBOORU); {PVR_XBOORU}
  FHypnohub    := AddCustomBooru('Hypnohub.net', bsTGelbooruLikeClient, bsTRule34xxxparser, HYPNOHUBNET_URL, PVR_HYPNOHUBNET); {PVR_HYPNOHUBNET}
  FDanbooru    := AddCustomBooru('Danbooru.donmai.us', bsTDanbooruAPIClient, bsTDanbooruAPIParser, DANBOORUDONMAIUS_URL, PVR_DANBOORU); {PVR_DANBOORU}
  FAllTheFallen := AddCustomBooru('booru.allthefallen.moe', bsTDanbooruAPIClient, bsTDanbooruAPIParser, BOORUALLTHEFALLENMOE_URL, PVR_ALLTHEFALLEN); {PVR_ALLTHEFALLEN}
  FBleachbooru := AddCustomBooru('bleachbooru.org', bsTDanbooruAPIClient, bsTDanbooruAPIParser, BLEACHBOORUORG_URL, PVR_BLEACHBOORU); {PVR_BLEACHBOORU}
  FIllusioncards := AddCustomBooru('illusioncards.booru.org', bsTGelbooruClient, bsTGelbooruParser, ILLUSIONCARDSBOORU_URL, PVR_ILLUSIONCARDS); {PVR_ILLUSIONCARDS}
  FHGoonBooru  := AddCustomBooru('hgoon.booru.org', bsTGelbooruClient, bsTGelbooruParser, HGOONBOORUORG_URL, PVR_HGOONBOORU); {PVR_HGOONBOORU}
  FE621        := AddCustomBooru('e621.net', bsTe621Client, bsTe621Parser, E621NET_URL, PVR_E621); {PVR_E621}

  AddCustomBooru('footfetishbooru.booru.org', bsTGelbooruLikeClient, bsTGelbooruParser, 'https://footfetishbooru.booru.org');


  FR34JsonApi  := Add(PVR_R34JSONAPI, 'r34 JSON API', 0, TNBoxSearchReqR34JsonApi, TNBoxR34JsonApiItem);
  FR34App      := Add(PVR_R34APP, 'r34.app', 0, TNBoxSearchReqR34App, TNBoxR34AppItem);
  FRandomizer  := Add(PVR_RANDOMIZER, 'Randomizer', 0, TNBoxSearchReqRandomizer, nil, True, True);

  AddCustom('pornpic.xxx', Self.NsfwXxx, 'https://pornpic.xxx');
  AddCustom('hdporn.pics', Self.NsfwXxx, 'https://hdporn.pics');
  AddCustom('kemono.su', Self.CoomerParty, 'https://kemono.su');
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

function TNBoxProviders.GetNextCustomId: integer;
begin
  Inc(FCustomProviderBiggerId);
  Result := FCustomProviderBiggerId;
end;

{ TNBoxProviderInfo }

function TNBoxProviderInfo.CreateBaseItem: INBoxItem;
begin
  if (FItemClass = TNBoxBooruItemBase) then
    Result := TNBoxBooruItemBase.Create(FId)
  else
    Result := FItemClass.Create;
  Result.SetProviderId(FId);
end;

function TNBoxProviderInfo.CreateBaseRequest: INBoxSearchRequest;
begin
  if (FRequestClass = TNBoxSearchReqBooru) then
    Result := TNBoxSearchReqBooru.Create(FId)
  else
    Result := FRequestClass.Create;
  Result.SetProviderId(FId);
end;

function TNBoxProviderInfo.IsCustom: boolean;
begin
  Result := Self is TNBoxProviderInfoCustom;
//  Result := Self.FId >= CUSTOM_PVR_ID_MIN;
end;

function TNBoxProviderInfo.IsPredefined: boolean;
begin
  Result := FId < CUSTOM_PVR_ID_MIN;
end;

{ TNBoxProviderInfoCustom }

constructor TNBoxProviderInfoCustom.Create(AParent: TNBoxProviderInfo);
begin
  FItemClass := AParent.ItemClass;
  FRequestClass := AParent.RequestClass;
  FFirstPageid := AParent.FFirstPageId;
  FIsWeb := AParent.IsWeb;
  FVisibleByDefault := AParent.VisibleByDefault;
  FParentProvider := AParent;
end;

function TNBoxProviderInfoCustom.CreateBaseRequest: INBoxSearchRequest;
var
  LChangeableHost: IChangeableHost;
begin
  Result := Inherited;
  if Supports(Result, IChangeableHost, LChangeableHost) then
    LChangeableHost.ServiceHost := Fhost;
end;

function TNBoxProviderInfoCustom.GetAdditionalJsonData: string;
begin
  Result := '{}';
end;

procedure TNBoxProviderInfoCustom.SetAdditionalData(AJsonData: string);
begin
  { Do nothing. }
end;

{ TNBoxProviderInfoCustomBooruScraper }

function TNBoxProviderInfoCustomBooruScraper.CreateBaseRequest: INBoxSearchRequest;
begin
  Result := Inherited;
  with Result as TNBoxSearchReqBooru do
  begin
    ClientType := Self.ClientType;
    ParserType := Self.ParserType;
  end;
end;

function TNBoxProviderInfoCustomBooruScraper.GetAdditionalJsonData: string;
var
  LJson: TJsonObject;
begin
  LJson := TJsonObject.Create;
  try
    LJson.AddPair('ClientType', Ord(ClientType));
    LJson.AddPair('ParserType', Ord(ParserType));
    Result := LJson.ToString;
  finally
    LJson.Free;
  end;
end;

procedure TNBoxProviderInfoCustomBooruScraper.SetAdditionalData(
  AJsonData: string);
var
  LJson: TJsonObject;
begin
  LJson := TJsonObject.ParseJSONValue(AJsonData) as TJsonObject;
  try
    ClientType := TBooruScraperClientType(LJson.GetValue<integer>('ClientType'));
    ParserType := TBooruScraperParserType(LJson.GetValue<integer>('ParserType'));
  finally
    LJson.Free;
  end;
end;

initialization
  PROVIDERS := TNBoxProviders.Create;
finalization
  PROVIDERS.Free;
end.

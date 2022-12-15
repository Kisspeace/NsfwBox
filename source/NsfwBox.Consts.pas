{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Consts;
interface
uses
  SysUtils, System.Classes, System.Generics.Collections;

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

type

  TNBoxProviderInfo = Class(TObject)
    private
      FId: integer;
      FTitleName: string;
      FFirstPageId: integer;
      FIsWeb: boolean;
      FVisibleByDefault: boolean;
    public
      property Id: Integer read FId;
      property TitleName: string read FTitleName;
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
    private
      function GetItem(I: Integer): TNBoxProviderInfo;
      function GetCount: integer;
    public
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
{ TNBoxProviders }

constructor TNBoxProviders.Create;

  function Add(AId: integer; ATitleName: string; AFirstPageId: integer; AIsWeb: boolean = True; AVisibleByDefault: boolean = True): TNBoxProviderInfo;
  begin
    Result := TNBoxProviderInfo.Create;
    Result.FId := AId;
    Result.FTitleName := ATitleName;
    Result.FFirstPageId := AFirstPageId;
    Result.FIsWeb := AIsWeb;
    Result.FVisibleByDefault := AVisibleByDefault;
    FItems.Add(Result);
  end;

begin
  FItems := TObjectList<TNBoxProviderInfo>.Create;
  FBookmarks := Add(ORIGIN_BOOKMARKS, 'Bookmarks', 1, False, False);
  FPseudo    := Add(ORIGIN_PSEUDO, 'Files', 1, False, False);
  FRandomizer := Add(ORIGIN_RANDOMIZER, 'Randomizer', 0, True, True);

  FNsfwXxx    := Add(ORIGIN_NSFWXXX, 'nsfw.xxx', 1);
  FR34App     := Add(ORIGIN_R34APP, 'r34.app', 0);
  FR34JsonApi := Add(ORIGIN_R34JSONAPI, 'r34 JSON API', 0);
  FCoomerParty := Add(ORIGIN_COOMERPARTY, 'coomer.party \ kemono.party', 1);
  FGMPClub    := Add(ORIGIN_GIVEMEPORNCLUB, 'givemeporn.club', 1);
  FMotherless := Add(ORIGIN_MOTHERLESS, 'motherless.com', 1);
  F9HentaiTo  := Add(ORIGIN_9HENTAITO, '9hentai.to', 0);
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

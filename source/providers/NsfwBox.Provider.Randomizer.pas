{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.Randomizer;

interface
uses
  System.SysUtils, System.Classes, XSuperObject, NsfwBox.Interfaces,
  NsfwBox.Consts, System.Generics.Collections;

type

  TNBoxSearchReqRandomizer = class(TNBoxSearchRequestBase)
    private
      FProviders: TArray<Integer>;
    public
      function Clone: INBoxSearchRequest; override;
      property Providers: TArray<Integer> read FProviders write FProviders;
      property Origin;
      constructor Create; override;
  end;

implementation

{ TNBoxSearchReqRandomizer }

function TNBoxSearchReqRandomizer.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqRandomizer.Create;
  with (Result as TNBoxSearchReqRandomizer) do begin
    Providers := Self.Providers;
  end;
end;

constructor TNBoxSearchReqRandomizer.Create;
begin
  inherited;
  FOrigin := PVR_RANDOMIZER;
  Providers := [
    NsfwBox.Consts.PROVIDERS.NsfwXxx.Id,
    NsfwBox.Consts.PROVIDERS.GMPClub.Id,
    NsfwBox.Consts.PROVIDERS.R34App.Id,
    NsfwBox.Consts.PROVIDERS.CoomerParty.Id,
    NsfwBox.Consts.PROVIDERS.Motherless.Id,
    NsfwBox.Consts.PROVIDERS.NineHentaiTo.Id,
    NsfwBox.Consts.PROVIDERS.Rule34xxx.Id,
    NsfwBox.Consts.PROVIDERS.Gelbooru.Id
  ];
end;

end.

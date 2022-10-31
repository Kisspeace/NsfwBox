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
    protected
      function GetOrigin: integer; override;
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
  Providers := [
    ORIGIN_NSFWXXX,
    ORIGIN_GIVEMEPORNCLUB,
    ORIGIN_R34APP,
    ORIGIN_COOMERPARTY,
    ORIGIN_MOTHERLESS,
    ORIGIN_9HENTAITO
  ];
end;

function TNBoxSearchReqRandomizer.GetOrigin: integer;
begin
  Result := ORIGIN_RANDOMIZER;
end;

end.

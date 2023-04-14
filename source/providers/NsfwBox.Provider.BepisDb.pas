{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.BepisDb;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  BooruScraper.Interfaces, BooruScraper.BaseTypes,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwBox.Utils,
  NsfwBox.Provider.BooruScraper,
  BooruScraper.Client.BepisDb;

type

   TNBoxSearchReqBepisDb = class(TNBoxSearchRequestBase)
    protected
      FSearchOpt: TBepisDbSearchOpt;
      function GetOrigin: integer; override;
      function GetRequest: string;               override;
      procedure SetRequest(const Value: string); override;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property SearchOpt: TBepisDbSearchOpt read FSearchOpt write FSearchOpt;
      [DISABLE] property Request;
      property PageId;
      constructor Create; override;
  end;

implementation

{ TNBoxSearchReqBepisDb }

function TNBoxSearchReqBepisDb.Clone: INBoxSearchRequest;
var
  LRes: TNBoxSearchReqBepisDb;
begin
  LRes := TNBoxSearchReqBepisDb.Create;
  LRes.FSearchOpt := Self.FSearchOpt;
  LRes.FPageId := Self.FPageId;
  Result := LRes;
end;

constructor TNBoxSearchReqBepisDb.Create;
begin
  inherited;
  FPageId := PROVIDERS.BepisDb.FisrtPageId;
  FSearchOpt := TBepisDbSearchOpt.Create;
end;

function TNBoxSearchReqBepisDb.GetOrigin: integer;
begin
  Result := PVR_BEPISDB;
end;

function TNBoxSearchReqBepisDb.GetRequest: string;
begin
  Result := FSearchOpt.Name;
end;

procedure TNBoxSearchReqBepisDb.SetRequest(const Value: string);
begin
  FSearchOpt.Name := Value;
end;

end.

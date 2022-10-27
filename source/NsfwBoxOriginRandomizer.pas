//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxOriginRandomizer;

interface
uses
  System.SysUtils, System.Classes, XSuperObject, NsfwBoxInterfaces,
  NsfwBoxOriginConst;

type

  TNBoxSearchReqRandomizer = class(TNBoxSearchRequestBase)
    protected
      function GetOrigin: integer; override;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
  end;


implementation

{ TNBoxSearchReqRandomizer }

function TNBoxSearchReqRandomizer.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqRandomizer.Create;
end;

function TNBoxSearchReqRandomizer.GetOrigin: integer;
begin
  Result := ORIGIN_RANDOMIZER;
end;

end.

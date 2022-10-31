{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.Randomizer;

interface
uses
  System.SysUtils, System.Classes, XSuperObject, NsfwBox.Interfaces,
  NsfwBox.Consts;

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

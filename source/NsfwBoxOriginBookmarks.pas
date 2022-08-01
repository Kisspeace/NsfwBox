//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxOriginBookmarks;

interface
uses
  System.SysUtils, System.Classes, NsfwBoxInterfaces,
  NsfwBoxOriginConst;

type

  TNBoxSearchReqBookmarks = class(TNBoxSearchRequestBase)
    protected
      function GetOrigin: integer; override;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request;
      property PageId;
  end;

implementation

{ TNBoxSearchReqBookmarks }

function TNBoxSearchReqBookmarks.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqBookmarks.Create;
  with Result do begin
    Pageid := self.FPageId;
    Request := Self.FRequest;
  end;
end;

function TNBoxSearchReqBookmarks.GetOrigin: integer;
begin
  Result := ORIGIN_BOOKMARKS;
end;

end.

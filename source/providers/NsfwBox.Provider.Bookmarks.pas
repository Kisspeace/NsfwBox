{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.Bookmarks;

interface
uses
  System.SysUtils, System.Classes, NsfwBox.Interfaces,
  NsfwBox.Consts;

type

  TNBoxSearchReqBookmarks = class(TNBoxSearchRequestBase)
    protected
      FPath: string;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request;
      property Path: string read FPath write FPath;
      property PageId;
      constructor Create; override;
  end;

implementation

{ TNBoxSearchReqBookmarks }

function TNBoxSearchReqBookmarks.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqBookmarks.Create;
  with (Result as TNBoxSearchReqBookmarks) do begin
    Pageid := self.FPageId;
    Request := Self.FRequest;
    Path := Self.Path;
  end;
end;

constructor TNBoxSearchReqBookmarks.Create;
begin
  inherited;
  FOrigin := PVR_BOOKMARKS;
end;

end.

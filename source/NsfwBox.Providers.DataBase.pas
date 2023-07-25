unit NsfwBox.Providers.DataBase;

interface
uses
  SysUtils, Classes, XSuperObject, XSuperJSON, DbHelper, System.JSON,
  NsfwBox.Interfaces, NsfwBox.Provider.Pseudo, NsfwBox.Provider.NsfwXxx,
  NsfwBox.Provider.R34App, NsfwBox.Provider.R34JsonApi, NsfwBox.Consts,
  NsfwBox.Helper, Math, system.Generics.Collections, NsfwBox.Logging,
  NsfwBox.Provider.BooruScraper, BooruScraper.Interfaces, BooruScraper.BaseTypes,
  BooruScraper.Serialize.Json, BooruScraper.Serialize.XSuperObject,
  ZExceptions, ZPlainSqLiteDriver;

type

  TNBoxBookmarksDb = class(TDbHelper)
    protected
      procedure CreateBase; override;
    public

  end;

implementation

{ TNBoxBookmarksDb }

procedure TNBoxBookmarksDb.CreateBase;
begin
  try
    SqlProc.Script.AddStrings([
      'CREATE TABLE providers (',
      '  id         INTEGER PRIMARY KEY AUTOINCREMENT,',
      '  parent_id  INTEGER,',
      '  title_name VARCHAR(255),',
      '  host       TEXT,',
      '  data       JSON,',
      '  timestamp  DATETIME DEFAULT CURRENT_TIMESTAMP',
      ');'
    ]);
    SqlProc.Execute;
  finally
    SqlProc.Script.Clear;
  end;
end;

end.

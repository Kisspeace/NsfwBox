unit NsfwBox.DataExportImport;

interface
uses
  Classes, Types, System.Generics.Collections,
  NsfwBox.Logging, System.Zip, SysUtils, DateUtils;

type

  TExImOption = (ExImSettings, ExImBookmarks, ExImHistory, ExImSession, ExImLogs);
  TExImOptions = Set of TExImOption;

const
  DEF_COMPRESSION = TZipCompression.zcDeflate;
  DEF_EXIM_OPTIONS = [ExImSettings..ExImLogs];

  procedure ExportAppData(AFileName: string; AOptions: TExImOptions = DEF_EXIM_OPTIONS);
  procedure ImportAppData(AFileName: string; AOptions: TExImOptions = DEF_EXIM_OPTIONS);
  function GenerateNewBackupFilename: string;

implementation
uses unit1;

function GenerateNewBackupFilename: string;
begin
  Result := 'NsfwBox-' + APP_VERSION.ToGhTagString +
    '-' + Now.Format('MM.dd.yyyy-HH.mm.ss') + '.zip';
end;

procedure ExportAppData(AFileName: string; AOptions: TExImOptions);
var
  LZip: System.Zip.TZipFile;
begin
  LZip := TZipFile.Create;
  try
    { WARNING: may cause many errors. }
    unit1.HistoryDb.Disconnet;
    unit1.BookmarksDb.Disconnet;
    unit1.Session.Disconnet;

    LZip.Open(AFilename, TZipMode.zmWrite);

    if ExImSettings in AOptions then
      LZip.Add(SETTINGS_FILENAME);

    if ExImBookmarks in AOptions then
      LZip.Add(BOOKMARKSDB_FILENAME);

    if (ExImHistory in AOptions) and FileExists(HISTORY_FILENAME) then
      LZip.Add(HISTORY_FILENAME);

    if (ExImSession in AOptions) and FileExists(SESSION_FILENAME) then
      LZip.Add(SESSION_FILENAME);

    if ExImLogs in AOptions then
    begin
      if FileExists(LOG_FILENAME) then
        LZip.Add(LOG_FILENAME);

      if FileExists(YDW_LOG_FILENAME) then
        LZip.Add(YDW_LOG_FILENAME);
    end;
  finally
    LZip.Free;
    unit1.HistoryDb.ForceConnect;
    unit1.BookmarksDb.ForceConnect;
    unit1.Session.ForceConnect;
  end;
end;

procedure ImportAppData(AFileName: string; AOptions: TExImOptions);
begin

end;

end.

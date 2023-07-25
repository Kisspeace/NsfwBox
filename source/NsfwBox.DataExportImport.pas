unit NsfwBox.DataExportImport;

interface
uses
  Classes, Types, System.Generics.Collections,
  NsfwBox.Logging, System.Zip, SysUtils, DateUtils,
  System.IOUtils, NsfwBox.Consts;

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

procedure BeforeExportImport;
begin
  { WARNING: may cause many errors. }
  Unit1.HistoryDb.Disconnet;
  Unit1.BookmarksDb.Disconnet;
  Unit1.Session.Disconnet;
end;

procedure AfterExportImport;
begin
  Unit1.HistoryDb.ForceConnect;
  Unit1.BookmarksDb.ForceConnect;
  Unit1.Session.ForceConnect;
end;

procedure ExportAppData(AFileName: string; AOptions: TExImOptions);
var
  LZip: System.Zip.TZipFile;
begin
  LZip := TZipFile.Create;
  try
    BeforeExportImport;

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
    AfterExportImport;
  end;
end;

procedure ImportAppData(AFileName: string; AOptions: TExImOptions);
var
  LZip: System.Zip.TZipFile;

  procedure Extract(AFilename: string);
  var
    LFileName: String;
  begin
    try
      LFilename := TPath.GetFileName(AFilename);
      if (LZip.IndexOf(LFilename) <> -1) then
        LZip.Extract(LFilename, TPath.GetDirectoryName(AFilename));
    Except
      On E: Exception do
      begin
        Log('ImportAppData ' + AFilename, E);
        Raise;
      end;
    end;
  end;

begin
  LZip := TZipFile.Create;
  try
    BeforeExportImport;

    LZip.Open(AFilename, TZipMode.zmRead);

    if ExImSettings in AOptions then
      Extract(SETTINGS_FILENAME);

    if ExImBookmarks in AOptions then
      Extract(BOOKMARKSDB_FILENAME);

    if (ExImHistory in AOptions) and FileExists(HISTORY_FILENAME) then
      Extract(HISTORY_FILENAME);

    if (ExImSession in AOptions) and FileExists(SESSION_FILENAME) then
      Extract(SESSION_FILENAME);

    if ExImLogs in AOptions then
    begin
      if FileExists(LOG_FILENAME) then
        Extract(LOG_FILENAME);

      if FileExists(YDW_LOG_FILENAME) then
        Extract(YDW_LOG_FILENAME);
    end;
  finally
    LZip.Free;
    AfterExportImport;
  end;
end;

end.

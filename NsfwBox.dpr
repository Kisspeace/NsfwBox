program NsfwBox;

uses
  System.StartUpCopy in 'source\tricks\System.StartUpCopy.pas',
  FMX.Forms,
  System.Hash,
  Unit1 in 'source\Unit1.pas' {Form1},
  NsfwBox.Settings in 'source\NsfwBox.Settings.pas',
  NsfwBox.Interfaces in 'source\NsfwBox.Interfaces.pas',
  NsfwBox.ContentScraper in 'source\NsfwBox.ContentScraper.pas',
  NsfwBox.Graphics in 'source\NsfwBox.Graphics.pas',
  NsfwBox.Graphics.Browser in 'source\NsfwBox.Graphics.Browser.pas',
  NsfwBox.Consts in 'source\NsfwBox.Consts.pas',
  NsfwBox.Styling in 'source\NsfwBox.Styling.pas',
  NsfwBox.Graphics.Rectangle in 'source\NsfwBox.Graphics.Rectangle.pas',
  Unit2 in 'source\Unit2.pas',
  NsfwBox.DownloadManager in 'source\NsfwBox.DownloadManager.pas',
  NsfwBox.Bookmarks in 'source\NsfwBox.Bookmarks.pas',
  DbHelper in 'source\DbHelper.pas',
  NsfwBox.Helper in 'source\NsfwBox.Helper.pas',
  NetHttpClient.Downloader in 'source\NetHttpClient.Downloader.pas',
  FMX.Scroller in 'source\FMX.Scroller.pas',
  NsfwBox.FileSystem in 'source\NsfwBox.FileSystem.pas',
  FMX.Color in 'source\FMX.Color.pas',
  SimpleClipboard in 'source\SimpleClipboard.pas',
  NsfwBox.UpdateChecker in 'source\NsfwBox.UpdateChecker.pas',
  NsfwBox.MessageForDeveloper in 'source\NsfwBox.MessageForDeveloper.pas',
  {$IFDEF MSWINDOWS}
  NsfwBox.WindowsTitlebar in 'source\NsfwBox.WindowsTitlebar.pas',
  Windows,
  {$ENDIF }
  FMX.ColumnsView in 'source\FMX.ColumnsView.pas',
  NsfwBox.Tests in 'source\NsfwBox.Tests.pas',
  NsfwBox.Logging in 'source\NsfwBox.Logging.pas',
  NsfwBox.Utils in 'source\NsfwBox.Utils.pas',
  NsfwBox.Graphics.ImageViewer in 'source\NsfwBox.Graphics.ImageViewer.pas',
  NsfwBox.Provider.Bookmarks in 'source\providers\NsfwBox.Provider.Bookmarks.pas',
  NsfwBox.Provider.CoomerParty in 'source\providers\NsfwBox.Provider.CoomerParty.pas',
  NsfwBox.Provider.Fapello in 'source\providers\NsfwBox.Provider.Fapello.pas',
  NsfwBox.Provider.BooruScraper in 'source\providers\NsfwBox.Provider.BooruScraper.pas',
  NsfwBox.Provider.GivemepornClub in 'source\providers\NsfwBox.Provider.GivemepornClub.pas',
  NsfwBox.Provider.motherless in 'source\providers\NsfwBox.Provider.motherless.pas',
  NsfwBox.Provider.NineHentaiToApi in 'source\providers\NsfwBox.Provider.NineHentaiToApi.pas',
  NsfwBox.Provider.NsfwXxx in 'source\providers\NsfwBox.Provider.NsfwXxx.pas',
  NsfwBox.Provider.Pseudo in 'source\providers\NsfwBox.Provider.Pseudo.pas',
  NsfwBox.Provider.R34App in 'source\providers\NsfwBox.Provider.R34App.pas',
  NsfwBox.Provider.R34JsonApi in 'source\providers\NsfwBox.Provider.R34JsonApi.pas',
  NsfwBox.Provider.Randomizer in 'source\providers\NsfwBox.Provider.Randomizer.pas',
  NsfwBox.GarbageCollector in 'source\NsfwBox.GarbageCollector.pas',
  NsfwBox.Provider.BepisDb in 'source\providers\NsfwBox.Provider.BepisDb.pas';

{$R *.res}

begin
  {$IFDEF MSWINDOWS}
  var Mutex := CreateMutex(nil, True, PChar('Global\NsfwBox:' + THashMD5.GetHashString(TNBoxPath.GetAppPath)));
  if (Mutex = 0) OR (GetLastError = ERROR_ALREADY_EXISTS) then exit;
  {$ENDIF}
//  GlobalUseSkia := True;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.

program NsfwBox;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'source\Unit1.pas' {Form1},
  NsfwBoxSettings in 'source\NsfwBoxSettings.pas',
  NsfwBoxInterfaces in 'source\NsfwBoxInterfaces.pas',
  NsfwBoxOriginNsfwXxx in 'source\NsfwBoxOriginNsfwXxx.pas',
  NsfwBoxOriginR34JsonApi in 'source\NsfwBoxOriginR34JsonApi.pas',
  NsfwBoxOriginR34App in 'source\NsfwBoxOriginR34App.pas',
  NsfwBoxContentScraper in 'source\NsfwBoxContentScraper.pas',
  NsfwBoxGraphics in 'source\NsfwBoxGraphics.pas',
  NsfwBoxOriginPseudo in 'source\NsfwBoxOriginPseudo.pas',
  NsfwBoxGraphics.Browser in 'source\NsfwBoxGraphics.Browser.pas',
  NsfwBoxOriginConst in 'source\NsfwBoxOriginConst.pas',
  NsfwBoxStyling in 'source\NsfwBoxStyling.pas',
  NsfwBoxGraphics.Rectangle in 'source\NsfwBoxGraphics.Rectangle.pas',
  Unit2 in 'source\Unit2.pas',
  NsfwBoxDownloadManager in 'source\NsfwBoxDownloadManager.pas',
  NsfwBoxBookmarks in 'source\NsfwBoxBookmarks.pas',
  DbHelper in 'source\DbHelper.pas',
  NsfwBoxHelper in 'source\NsfwBoxHelper.pas',
  NsfwBoxOriginBookmarks in 'source\NsfwBoxOriginBookmarks.pas',
  NetHttpClient.Downloader in 'source\NetHttpClient.Downloader.pas',
  FMX.Scroller in 'source\FMX.Scroller.pas',
  NsfwBoxFileSystem in 'source\NsfwBoxFileSystem.pas',
  FMX.Color in 'source\FMX.Color.pas',
  SimpleClipboard in 'source\SimpleClipboard.pas',
  NsfwBoxThreading in 'source\NsfwBoxThreading.pas',
  NsfwBoxOriginGivemepornClub in 'source\NsfwBoxOriginGivemepornClub.pas',
  NsfwBoxOrigin9hentaiToApi in 'source\NsfwBoxOrigin9hentaiToApi.pas',
  NsfwBox.UpdateChecker in 'source\NsfwBox.UpdateChecker.pas',
  NsfwBox.MessageForDeveloper in 'source\NsfwBox.MessageForDeveloper.pas',
  {$IFDEF MSWINDOWS}
  NsfwBoxWindowsTitlebar in 'source\NsfwBoxWindowsTitlebar.pas',
  {$ENDIF }
  NsfwBoxOriginCoomerParty in 'source\NsfwBoxOriginCoomerParty.pas',
  FMX.ColumnsView in 'source\FMX.ColumnsView.pas',
  NsfwBoxOriginRandomizer in 'source\NsfwBoxOriginRandomizer.pas',
  NsfwBox.Provider.motherless in 'source\NsfwBox.Provider.motherless.pas';

{$R *.res}

begin
//  GlobalUseSkia := True;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.

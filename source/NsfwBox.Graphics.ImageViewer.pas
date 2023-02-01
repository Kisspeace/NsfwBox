{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Graphics.ImageViewer;

interface
uses
  SysUtils, Types, System.UITypes, Classes, System.Variants,  FMX.Types,
  FMX.Controls, FMX.Forms, FMX.Graphics, Fmx.Color, FMX.Objects, FMX.Effects,
  FMX.Controls.Presentation, Fmx.StdCtrls, FMX.Layouts, FMX.Edit,
  NetHttpClient.Downloader, FMX.EditBox, FMX.NumberBox, NetHttp.Scraper.NsfwXxx,
  system.IOUtils, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, system.Generics.Collections, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo,
  Fmx.ActnList, NsfwXxx.Types,
  { Alcinoe ---------- }
  Alcinoe.FMX.Objects, Alcinoe.FMX.Graphics,
  { NsfwBox ---------- }
  NsfwBox.Interfaces, NsfwBox.Provider.NsfwXxx, NsfwBox.Provider.R34JsonApi,
  NsfwBox.ContentScraper, NsfwBox.Graphics.Rectangle,
  NsfwBox.Bookmarks, NsfwBox.Helper, NsfwBox.Provider.Bookmarks, NsfwBox.Logging,
  { you-did-well! ---- }
  YDW.FMX.ImageWithURL.AlRectangle, YDW.FMX.ImageWithURL.Interfaces,
  YDW.FMX.ImageWithURL.ImageViewer, YDW.FMX.ImageWithURLManager,
  YDW.FMX.ImageWithURLCacheManager;

type

  TNBoxImageViewer = Class(TImageWithUrlViewer)
    protected
      FImgManager: TImageWithUrlManager;
      FCacheManager: IImageWithUrlCacheManager;
    public
      Constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TNBoxImageViewer }

constructor TNBoxImageViewer.Create(AOwner: TComponent);
begin
  inherited;
  Self.StyleLookup := 'ImageViewer';
  FImgManager := TImageWithUrlManager.Create(Self);
  FImgManager.EnableSaveToCache := True;
  FImgManager.EnableLoadFromCache := True;
  FImgManager.LoadThumbnailFromFile := False;
  FCacheManager := TImageWithURLCahceManager.Create(Self);
  FImgManager.CacheManager := FCacheManager;
  Self.ImageManager := FImgManager;
end;

end.

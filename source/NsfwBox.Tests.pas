{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Tests;

interface
uses
  System.Classes,System.SysUtils, System.Diagnostics, System.Types,
  System.Generics.Collections, FMX.Controls, FMX.Types, FMX.Forms,
  { NsfwBox }
  NsfwBox.Provider.Bookmarks, NsfwBox.Interfaces, NsfwBox.Graphics,
  NsfwBox.Graphics.Browser, NsfwBox.ContentScraper,
  NsfwBox.Graphics.Rectangle, NsfwBox.Styling;

type

  TNBoxTests = Class(TObject)
    public
      class procedure TestBrowserOnTap(Sender: TObject; const Point: TPointF);
      class procedure TestDownloadsOnTap(Sender: TObject; const Point: TPointF);
  End;

  procedure Init(); { Call on form create }

implementation
uses Unit1;

procedure Init();

  function NewTestBtn(AText: string; AOnTap: TTapEvent; AIcon: string = ''): TRectButton;
  begin
    Result := Form1.AddMenuBtn;
    with Result do begin
      if not AIcon.IsEmpty then
        Image.ImageURL := Form1.AppStyle.GetImagePath(AIcon)
      else
        Image.ImageURL := Form1.AppStyle.GetImagePath(ICON_NSFWBOX);

      Text.Text := AText;
      OnTap := AOnTap;
      Result.Visible := Form1.Settings.DevMode;
    end;
    Form1.MenuTestButtons.Add(Result);
  end;

begin
  NewTestBtn('Stress test downloads', TNBoxTests.TestDownloadsOnTap);
  NewTestBtn('Stress test browser', TNBoxTests.TestBrowserOnTap);
end;

{ TNBoxTests }

class procedure TNBoxTests.TestBrowserOnTap(Sender: TObject; const Point: TPointF);
var
  LBrowser: TNBoxBrowser;
  LTab: TNBoxTab;
  Form1: TForm1;
begin
  Form1 := Unit1.Form1;
  LTab := Form1.AddBrowser(nil, False);
  LTab.CloseBtn.Visible := FALSE;
  LBrowser := LTab.Owner as TNBoxBrowser;
  Form1.CurrentBrowser := LBrowser;

  TThread.CreateAnonymousThread(
  procedure
  var
    I: integer;
  begin
    try
      try
        for I := 1 to 20 do begin
          TThread.Synchronize(Nil, procedure begin
            LBrowser.GoNextPage;
          end);

          {$IFDEF ANDROID}
            sleep(random(330));
          {$ELSE IF MSWINDOWS}
            Sleep(random(50));
          {$ENDIF}

          if I mod 3 = 0 then begin
            TThread.Synchronize(nil, procedure begin
              LBrowser.Clear;
            end);
          end;

          If TThread.Current.CheckTerminated then exit;
        end;
      finally
        TThread.Synchronize(Nil, procedure begin
          LTab.CloseBtn.Visible := TRUE;
        end);
      end;
    except On E: Exception do
        Log(E, 'TestButton: ');
    end;
  end).Start;
end;

class procedure TNBoxTests.TestDownloadsOnTap(Sender: TObject; const Point: TPointF);
var
  I: integer;
  Form1: TForm1;
begin
  Form1 := Unit1.Form1;
  Form1.AddBrowser();
  var LReq := TNBoxSearchReqBookmarks.Create;
  LReq.Request := '1';
  LReq.Path := NsfwBox.ContentScraper.REGULAR_BMRKDB;
  LReq.PageId := 1;
  Form1.CurrentBrowser := Form1.Browsers.Last;
  Form1.CurrentBrowser.Request := LReq;
  Form1.CurrentBrowser.GoBrowse;
  for I := 1 to 6 do
    Form1.CurrentBrowser.GoNextPage;

  while Form1.CurrentBrowser.IsBrowsingNow do begin
    Sleep(10);
    CheckSynchronize(10);
  end;
  DoWithAllItems := TRUE;
  Form1.BtnDownloadAll.OnTap(Form1.BtnDownloadAll, TPointF.Create(0, 0));

  TThread.CreateAnonymousThread(
  procedure
  var
    I: integer;
  begin
    try
      try
        I := 0;
        var LNeedWork: boolean := TRUE;
        while LNeedWork do begin
          TThread.Synchronize(Nil, procedure begin
            LNeedWork := (Form1.DownloadItems.Count > 0);
            if LNeedWork then begin
              var LIndex: integer := Random(Form1.DownloadItems.Count);
              var LTab := Form1.DownloadItems[LIndex];
              var hash: string := LTab.GetHashCode.ToString;
//              Unit1.Log('Test before tap: ' + Hash);
              try
                LTab.CloseBtn.OnTap(LTab.CloseBtn, TPointF.Create(0, 0));
              except On E: exception do Log(E, 'Test Downloaders: '); end;
              Inc(I);
//              Unit1.Log('Test after tap: ' + Hash);
            end;
            LNeedWork := TRUE;

          end);

          if TThread.Current.CheckTerminated then exit;
            Sleep(Random(25));
        end;
      except
        On E: exception do SyncLog(E, 'Test: ');
      end;
    finally
      SyncLog('Test in anonymous thread finished!');
    end;
  end).Start;
end;

end.

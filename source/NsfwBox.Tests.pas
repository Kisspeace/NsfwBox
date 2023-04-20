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
  NsfwBox.Graphics.Rectangle, NsfwBox.Styling, NsfwBox.Logging,
  NsfwBox.Consts, NsfwBox.Bookmarks;

type

  TNBoxTests = Class(TObject)
    public
      class procedure TestBrowserOnTap(Sender: TObject; const Point: TPointF);
      class procedure TestDownloadsOnTap(Sender: TObject; const Point: TPointF);
      class procedure TestBookmarksRead(Sender: TObject; const Point: TPointF);
      class procedure TryDeadlock(Sender: TObject; const Point: TPointF);
      class procedure TestLoadSession(Sender: TObject; const Point: TPointF);
      class procedure TestCompressLog(Sender: TObject; const Point: TPointF);
  End;

  procedure Init(); { Call on form create }

var
  Initialized: Boolean = FALSE;

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
  if Initialized then Exit;
  Initialized := TRUE;
  NewTestBtn('Stress test downloads', TNBoxTests.TestDownloadsOnTap);
  NewTestBtn('Stress test browser', TNBoxTests.TestBrowserOnTap);
  NewTestBtn('Test bookmarks read', TNBoxTests.TestBookmarksRead);
  NewTestBtn('Try Deadlock', TNBoxTests.TryDeadlock);
  NewTestBtn('Test load session', TNBoxTests.TestLoadSession);
  NewTestBtn('Show compressed log', TNBoxTests.TestCompressLog);
end;

{ TNBoxTests }

class procedure TNBoxTests.TestBookmarksRead(Sender: TObject;
  const Point: TPointF);
var
  LGroups: TBookmarkGroupRecAr;
  LAr: TBookmarkAr;
  I, N: integer;
begin
  LGroups := BookmarksDb.GetBookmarksGroups;
  if Length(LGroups) < 1 then exit;

  for N := 0 to High(LGroups) do
  begin
    for I := 1 to LGroups[N].GetMaxPage do
    begin
      LAr := LAr + LGroups[N].GetPage(I);
    end;
  end;

  With (Sender as TRectButton) do
    Text.Text := '(' + Length(LAr).ToString + ')' + 'Test bookmarks read';

  for I := Low(LAr) to High(LAr) do
  begin
    LAr[I].Obj.Free;
    LAr[I].Obj := Nil;
    LAr[I].Free;
  end;

  LAr := Nil;
end;

class procedure TNBoxTests.TestBrowserOnTap(Sender: TObject; const Point: TPointF);
var
  LBrowser: TNBoxBrowser;
  LTab: TNBoxTab;
  Form1: TForm1;
  I: integer;
begin
  Form1 := Unit1.Form1;
  LTab := Form1.AddBrowser(PROVIDERS.GMPClub.RequestClass.Create, False);
  LTab.CloseBtn.Visible := FALSE;
  LBrowser := LTab.Owner as TNBoxBrowser;
  Form1.CurrentBrowser := LBrowser;

  try
    for I := 1 to 20 do begin
      LBrowser.GoNextPage;
      Application.ProcessMessages;
      sleep(Random(550));
//      {$IFDEF ANDROID}
//        sleep(random(330));
//      {$ELSE IF MSWINDOWS}
//        Sleep(random(50));
//      {$ENDIF}

      if I mod 3 = 0 then begin
        LBrowser.Clear;
      end;

    end;
  finally
    LTab.CloseBtn.Visible := TRUE;
  end;
  Exit;

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
//            Application.ProcessMessages;
          end);

          {$IFDEF ANDROID}
            sleep(random(330));
          {$ELSE IF MSWINDOWS}
            Sleep(random(50));
          {$ENDIF}

//          if I mod 3 = 0 then begin
//            TThread.Synchronize(nil, procedure begin
//              LBrowser.Clear;
//              Application.ProcessMessages;
//            end);
//          end;

          If TThread.Current.CheckTerminated then exit;
        end;
      finally
        TThread.Synchronize(Nil, procedure begin
          LTab.CloseBtn.Visible := TRUE;
        end);
      end;
    except On E: Exception do
        Log('TestButton', E);
    end;
  end).Start;
end;

class procedure TNBoxTests.TestCompressLog(Sender: TObject;
  const Point: TPointF);
var
  LLog: string;
begin
  LLog := LoadCompressedLog(2000);
  Unit1.Form1.ChangeInterface(Form1.MenuLog);
  Unit1.Form1.MemoLog.Memo.Text := LLog;
end;

class procedure TNBoxTests.TestDownloadsOnTap(Sender: TObject; const Point: TPointF);
var
  I: integer;
  Form1: TForm1;
begin
  Form1 := Unit1.Form1;
  Form1.AddBrowser();
  var LReq := TNBoxSearchReqBookmarks.Create;
  LReq.Request := BookmarksDb.GetLastGroup.Id.ToString;
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

              try
                LTab.CloseBtn.OnTap(LTab.CloseBtn, TPointF.Create(0, 0));
              except On E: exception do Log('Test Downloaders', E); end;
              Inc(I);
            end;
            LNeedWork := TRUE;

          end);

          if TThread.Current.CheckTerminated then exit;
            Sleep(Random(25));
        end;
      except
        On E: exception do Log('Test', E);
      end;
    finally
      Log('Test in anonymous thread finished!');
    end;
  end).Start;
end;

class procedure TNBoxTests.TestLoadSession(Sender: TObject;
  const Point: TPointF);
var
  I: integer;
begin
  for I := 1 to 2 do begin
    Unit1.Form1.LoadSession;
    Application.ProcessMessages;
  end;
end;

class procedure TNBoxTests.TryDeadlock(Sender: TObject; const Point: TPointF);
var
  LGroups: TBookmarkGroupRecAr;
  LAr: TBookmarkAr;
  I, N: integer;
  LFin: Boolean;
const
  MAX_ITEMS_COUNT = 320;
begin
  LGroups := BookmarksDb.GetBookmarksGroups;
  if Length(LGroups) < 1 then exit;

  LFin := False;
  for N := 0 to High(LGroups) do
  begin
    for I := 1 to LGroups[N].GetMaxPage do
    begin
      LAr := LAr + LGroups[N].GetPage(I);
      if Length(LAr) >= MAX_ITEMS_COUNT then
      begin
        LFin := True;
        break;
      end;
    end;
    if LFin then break;
  end;

  With (Sender as TRectButton) do
    Text.Text := '(' + Length(LAr).ToString + ')' + 'Try Deadlock';

  Application.ProcessMessages;

  for I := Low(LAr) to High(LAr) do
  begin
    if not LAr[I].IsRequest then
      Unit1.Form1.AddDownload(LAr[I].AsItem);
  end;

  for I := Low(LAr) to High(LAr) do
  begin
    LAr[I].Obj.Free;
    LAr[I].Obj := Nil;
    LAr[I].Free;
  end;

  LAr := Nil;
end;

end.

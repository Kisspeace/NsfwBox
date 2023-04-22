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
      class procedure StartAutopilot;
      class procedure TestBrowserOnTap(Sender: TObject; const Point: TPointF);
      class procedure TestDownloadsOnTap(Sender: TObject; const Point: TPointF);
      class procedure TestBookmarksRead(Sender: TObject; const Point: TPointF);
      class procedure TryDeadlock(Sender: TObject; const Point: TPointF);
      class procedure TestLoadSession(Sender: TObject; const Point: TPointF);
      class procedure TestCompressLog(Sender: TObject; const Point: TPointF);
      class procedure TestStartAutopilot(Sender: TObject; const Point: TPointF);
  End;

  procedure Init(); { Call on form create }

var
  Initialized: Boolean = FALSE;
  AutopilotEnabled: boolean = FALSE;

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
  NewTestBtn('Autopilot mode', TNBoxTests.TestStartAutopilot);
end;

{ TNBoxTests }

function IsLuck(APercents: integer): Boolean;
var
  R: Integer;
begin
  R := Random(100);
  if APercents >= R then
    Exit(True)
  else Result := False;
end;

procedure WaitSomeTime(ADelay: cardinal = 750);
begin
  Application.ProcessMessages;
  CheckSynchronize(Random(ADelay));
end;

function RandomTab: TNBoxTab;
begin
  if Form1.Tabs.Count > 0 then
    Result := Form1.Tabs[Random(Form1.Tabs.Count)]
  else
    Result := Nil;
end;

function RandomCard: TNBoxCardBase;
begin
  if Assigned(Form1.CurrentBrowser)
  and (Form1.CurrentBrowser.Items.Count > 0) then
  begin
    Result := Form1.CurrentBrowser.Items[Random(Form1.CurrentBrowser.Items.Count)];
  end else Exit(Nil);
end;

function RandomBookmark: TControl;
begin
  if Form1.BookmarksControls.Count > 0 then begin
    Result := Form1.BookmarksControls[Random(Form1.BookmarksControls.Count)];
  end else Exit(Nil);
end;

procedure TapOn(ASender: TControl);
begin
  if Assigned(ASender.OnTap) then
    ASender.OnTap(ASender, TPointF.Zero);
end;

procedure CreateBookmarksList;
begin
  TapOn(Form1.MenuBtnBookmarks);
  WaitSomeTime(100);
  TapOn(Form1.BtnBMarkCreate);
  WaitSomeTime(400);
  TapOn(Form1.BtnBMarkSaveChanges);
end;

procedure AddRandomItemToBookmarks;
var
  LCard: TNBoxCardBase;
  LBookmark: TControl;
begin
  LCard := RandomCard;
  if Assigned(LCard) then
  begin
    TapOn(LCard);
    WaitSomeTime;
    TapOn(Form1.BtnAddBookmark);
    WaitSomeTime;
    LBookmark := RandomBookmark;
    if Assigned(LBookmark) then
      TapOn(LBookmark)
    else begin
      CreateBookmarksList;
      AddRandomItemToBookmarks;
    end;
  end;
end;

procedure ChangeSearchRequest;
begin
  TapOn(Form1.TopBtnSearch);
  WaitSomeTime(350);
  TapOn(Form1.SearchMenu.BtnChangeOrigin);
  WaitSomeTime;

  if IsLuck(20) then begin
    form1.SearchMenu.OriginSetMenu.Selected := ORIGIN_COOMERPARTY;
  end else if IsLuck(20) then begin
    form1.SearchMenu.OriginSetMenu.Selected := PROVIDERS.GMPClub.Id;
  end else if IsLuck(20) then begin
    form1.SearchMenu.OriginSetMenu.Selected := PROVIDERS.Rule34xxx.Id;
  end else begin
    form1.SearchMenu.OriginSetMenu.Selected := PROVIDERS.NsfwXxx.Id;
  end;

  WaitSomeTime(100);
  TapOn(Form1.TopBtnSearch);
end;

procedure ScrollBrowser;
begin
  if Assigned(Form1.CurrentBrowser) then begin
    Form1.CurrentBrowser.ScrollBy(0, Random(500));
    WaitSomeTime;
  end;
end;

procedure DoRandomActivity;
var
  LTab: TNBoxTab;
  LCard: TNBoxCardBase;
begin
  case Random(11) of
    0: begin { Create new tab }
      if IsLuck(75) then
        TapOn(Form1.MenuBtnNewTab);
    end;

    1: begin { Navigate }
      TapOn(Form1.BtnNext);
      if IsLuck(65) then ScrollBrowser;
      if IsLuck(50) then WaitSomeTime;
    end;

    2: begin { Change tab }
      LTab := RandomTab;
      if Assigned(LTab) then
        TapOn(LTab)
      else
        TapOn(Form1.MenuBtnNewTab);
    end;

    3: begin { Close tab }
      LTab := RandomTab;
      if Assigned(LTab) then
        TapOn(LTab.CloseBtn)
      else
        TapOn(Form1.MenuBtnNewTab);
    end;

    4: begin { Clear items in current browser }
      if Assigned(Form1.CurrentBrowser) then
        Form1.CurrentBrowser.Clear;
    end;

    5: begin { Open random image }
      LCard := RandomCard;
      if Assigned(LCard) then
      begin
        TapOn(LCard);
        WaitSomeTime;
        TapOn(Form1.BtnPlayInternaly);
      end;
    end;

    6: begin { Download random item }
      if not IsLuck(50) then Exit;
      LCard := RandomCard;
      if Assigned(LCard) then
      begin
        TapOn(LCard);
        WaitSomeTime;
        TapOn(Form1.BtnDownloadAll);
      end;
    end;

    7: begin { Create bookmark list }
      if IsLuck(40) then
        CreateBookmarksList;
    end;

    8: begin { Add random item to bookmarks }
      AddRandomItemToBookmarks;
    end;

    9: begin { Change search request }
      ChangeSearchRequest;
    end;

    10: begin { scroll down }
      ScrollBrowser;
    end;
  end;
end;

class procedure TNBoxTests.StartAutopilot;
begin
  AutopilotEnabled := True;
  TThread.CreateAnonymousThread(
  procedure
  var
    LTab: TNBoxTab;
    LCard: TNBoxCardBase;
    LBookmark: TControl;
    LFinish: boolean;
  begin
    try
      Log('Autopilot start.');
      TThread.Synchronize(TThread.Current,
      procedure begin
        TapOn(Form1.MenuBtnBookmarks);
        Form1.ChangeInterface(Form1.BrowserLayout);
      end);

      while (not Form1.AppDestroying) do
      begin
        TThread.Synchronize(TThread.Current,
        procedure begin
          DoRandomActivity;
        end);

        Sleep(Random(15));

        TThread.Synchronize(TThread.Current, procedure begin
          LFinish := (not AutopilotEnabled);
        end);
        if LFinish then Break;
        if TThread.Current.CheckTerminated then break;
      end;
    finally
      TThread.Synchronize(TTHread.Current, procedure begin
        AutopilotEnabled := False;
        Log('Autopilot finish.');
      end);
    end;
  end).Start;
end;

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

class procedure TNBoxTests.TestStartAutopilot(Sender: TObject;
  const Point: TPointF);
begin
  if not AutopilotEnabled then
    StartAutopilot
  else
    AutopilotEnabled := False;
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

{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Graphics;
interface
uses
  SysUtils, Types, System.UITypes, Classes, System.Variants,  FMX.Types,
  FMX.Controls, FMX.Forms, FMX.Graphics, Fmx.Color, FMX.Objects, FMX.Effects,
  FMX.Controls.Presentation, Fmx.StdCtrls, FMX.Layouts, FMX.Edit,
  NetHttpClient.Downloader, FMX.EditBox, FMX.NumberBox, NetHttp.Scraper.NsfwXxx,
  system.IOUtils, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, system.Generics.Collections, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, Alcinoe.FMX.Objects, Alcinoe.FMX.Graphics, NsfwXxx.Types,
  NsfwBox.Interfaces, NsfwBox.Provider.NsfwXxx, NsfwBox.Provider.R34JsonApi,
  NsfwBox.ContentScraper, NsfwBox.Graphics.Rectangle, Fmx.ActnList,
  NsfwBox.Bookmarks, NsfwBox.Helper, NsfwBox.Provider.Bookmarks, NsfwBox.Logging,
  NsfwBox.Utils,
  { you-did-well! ---- }
  YDW.FMX.ImageWithURL.AlRectangle;

type

  TNBoxCardBase = class(TAlRectangleImageWithURL)
    protected
      FItem: IHasOrigin;
      FOnAutoLook: TNotifyEvent;
      procedure AutoLook; virtual;
      function GetPost: INBoxItem;
      procedure SetItem(Value: IHasOrigin); virtual;
      function GetBookmark: TNBoxBookmark;
    public
      procedure SetThumbnail(AStream: TStream); overload; virtual; abstract;
      procedure SetThumbnail(AFilename: string); overload; virtual; abstract;
      property Item: IHasOrigin read FItem write SetItem;
      property Post: INBoxItem Read GetPost;
      property Bookmark: TNBoxBookmark read GetBookmark;
      property OnAutoLook: TNotifyEvent read FOnAutoLook write FOnAutoLook;
      function HasPost: boolean;
      function HasBookmark: boolean;
      Constructor Create(Aowner: TComponent); override;
      Destructor Destroy; override;
  end;

  TNBoxCardObjList = TObjectlist<TNBoxCardBase>;

  TNBoxCardSimple = class(TNBoxCardBase)
    protected
      procedure AutoLook; override;
      procedure SetItem(Value: IHasOrigin); override;
    public
      Text: TAlText;
      Rect: TAlRectangle;
      procedure SetThumbnail(AStream: TStream); override;
      procedure SetThumbnail(AFilename: string); override;
      property Item;
      property Post;
      property Bookmark;
      Constructor Create(Aowner: TComponent); override;
      Destructor Destroy; override;
  end;

  TTagButton = class(Tlayout)
    public
      Text: TAlText;
      Constructor Create(Aowner: Tcomponent); override;
      Destructor Destroy; override;
  end;

  TNBoxTab = class(TRectButton)
    public
      CloseBtn: TRectButton;
      constructor Create(Aowner: Tcomponent); override;
  end;

  TNBoxTabClass = Class of TNBoxTab;

  TNBoxTabList = TList<TNBoxTab>;

  TNBoxEdit = class(TAlRectangle)
    public
      Edit: TEdit;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

  TNBoxCheckButton = class(TRectButton, IIsChecked)
    protected
      {$IFDEF ANDROID}
      procedure Tap(const APoint: TPointF); override;
      {$ENDIF} {$IFDEF MSWINDOWS}
      procedure Click; override;
      {$ENDIF}
    private
      function GetIsChecked: Boolean; virtual;
      procedure SetIsChecked(const Value: Boolean); virtual;
      function IsCheckedStored: Boolean;
    public
      Check: TRectTextCheck;
      property IsChecked: Boolean read GetIsChecked write SetIsChecked;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

  TNBoxRadioButtonMode = (ByOwnerControls);

  TNBoxRadioButton = class(TNBoxCheckButton)
    private
      FWorkMode: TNBoxRadioButtonMode;
      procedure SetIsChecked(const Value: Boolean); override;
    public
      property WorkMode: TNBoxRadioButtonMode read FWorkMode write FWorkMode;
  end;

implementation
uses unit1;

{ TNsfwBoxItem }

procedure TNBoxCardSimple.AutoLook;
begin
  if not Assigned(FItem) then exit;
  if HasPost then begin

    if Supports(Post, IHasCaption) then begin
      Text.Text := (Post as IHasCaption).Caption;
      Rect.Visible := true;
    end else
      Rect.Visible := false;

  end else if ( HasBookmark and Bookmark.IsRequest ) then begin

    var str: string;
    with Bookmark.AsRequest do begin
      str := '[' + OriginToStr(Origin) + ']: ' + SLineBreak
      + 'Req: "' + Request + '"' + SLineBreak;

      if PageId > 1 then
        str := str + 'Page: ' + PageId.ToString + SLineBreak;
      if (Bookmark.AsRequest is TNBoxSearchReqBookmarks) then
        str := str + 'Path: ' + (Bookmark.AsRequest as TNBoxSearchReqBookmarks).Path;

      str := trim(str);
    end;

    Text.Text := str;
    Text.Font.Size := 11;
    Text.AutoSize := true;
    Rect.Visible := true;
    Rect.Fill.Kind := TBrushKind.None;
    Rect.Align := TAlignlayout.Client;

  end;
  Inherited;
end;

Constructor TNBoxCardSimple.Create(Aowner: Tcomponent);
const
  m: single = 4;
begin
  Inherited;
  Fill.Kind := tbrushkind.Bitmap;
  Fill.Bitmap.WrapMode := twrapmode.TileStretch;
  Stroke.Kind := tbrushkind.None;

  Rect := TAlRectangle.Create(self);
  with Rect do begin
    Align := talignlayout.MostBottom;
    Stroke.Kind := tbrushkind.None;
    Parent := self;
    Padding.Create(trectf.Create(m, m, m, m));
    HitTest := false;
  end;

  Text := TAlText.Create(self);
  with Text do begin
    HitTest := false;
    AutoSize := false;
    Parent := rect;
    Color := talphacolorrec.White;
    Align := talignlayout.Top;
    WordWrap := true;
    TextSettings.VertAlign := TTextalign.Center;
    TextSettings.HorzAlign := TtextAlign.Center;
  end;
end;

procedure TNBoxCardSimple.SetItem(Value: IHasOrigin);
begin
  inherited;
  AutoLook;
end;

procedure TNBoxCardSimple.SetThumbnail(AFilename: string);
begin
  Fill.Kind := TBrushKind.Bitmap;
  Fill.Bitmap.Bitmap.LoadFromFile(AFilename);
end;

procedure TNBoxCardSimple.SetThumbnail(AStream: TStream);
begin
  Fill.Kind := TBrushKind.Bitmap;
  Fill.Bitmap.Bitmap.LoadFromStream(AStream);
end;

Destructor TNBoxCardSimple.Destroy;
begin
  inherited;
end;

{ TTagButton }

Constructor TTagButton.Create(Aowner: Tcomponent);
begin
  inherited create(Aowner);
  HitTest := true;
  margins.Rect := trectf.Create(5, 5, 5, 5);
  Text := tAltext.Create(self);

  with text do begin
    Parent := self;
    HitTest := false;
    Align := Talignlayout.Contents;
    Color := talphacolorrec.White;
    textsettings.HorzAlign := ttextalign.Center;
    textsettings.VertAlign := ttextalign.Center;
  end;
end;

Destructor TTagButton.Destroy;
begin
  Text.Free;
  inherited Destroy;
end;

{ TNBoxTab }

constructor TNBoxTab.Create(Aowner: tcomponent);
begin
  inherited create(Aowner);
  Closebtn := TRectButton.Create(self);

  with closebtn do begin
    Parent := self;
    Align := talignlayout.MostRight;
    Cursor := CrHandPoint;
  end;

  with text do begin
    Align := talignlayout.Client;
    Font.Size := 10;
    AutoSize := false;
    WordWrap := false;
    Margins.Left := 8;
    Margins.Right := 4;
    HitTest := false;
    HorzTextAlign := ttextalign.Leading;
    VertTextAlign := ttextalign.Center;
    Color := talphacolorrec.White;
  end;
end;

{ TNBoxEdit }
constructor TNBoxEdit.Create(AOwner: TComponent);
begin
  inherited;
  Padding.Rect := TRectF.Create(4, 4, 4, 4);
  Edit := TEdit.Create(Self);
  with edit do begin
    Parent := Self;
    Align := TAlignlayout.Client;
    StyledSettings := [];
  end;
end;

destructor TNBoxEdit.Destroy;
begin
  inherited;
end;

{ TNBoxCheckButton }

{$IFDEF MSWINDOWS}
procedure TNBoxCheckButton.Click;
begin
  IsChecked := (not IsChecked);
  inherited;
end;
{$ENDIF}

constructor TNBoxCheckButton.Create(AOwner: TComponent);
begin
  inherited;
  Check := TRectTextCheck.Create(Self);

  with Check do begin
    Parent := self;
    Align := TAlignLayout.Right;
    Margins.Rect := TRectF.Create(0, 16, 16, 16);
    hitTest := false;
  end;
end;

destructor TNBoxCheckButton.Destroy;
begin
  Check.Free;
  inherited;
end;

function TNBoxCheckButton.GetIsChecked: Boolean;
begin
  Result := Check.IsChecked;
end;

function TNBoxCheckButton.IsCheckedStored: Boolean;
begin
  Result := true;
end;

procedure TNBoxCheckButton.SetIsChecked(const Value: Boolean);
begin
  Check.IsChecked := Value;
end;

{$IFDEF ANDROID}
procedure TNBoxCheckButton.Tap(const APoint: TPointF);
begin
  IsChecked := (not IsChecked);
  inherited;
end;
{$ENDIF}

{ TNBoxRadioButton }
procedure TNBoxRadioButton.SetIsChecked(const Value: Boolean);
var
  I: integer;
  List: TControlList;
begin
  inherited;
  if ( not IsChecked ) then
    exit;

  if WorkMode = ByOwnerControls then begin
    List := TControl(Owner).Controls;
    for I := 0 to List.Count - 1 do begin
      if ( List.Items[I] is TNBoxRadioButton ) then
       ( List.Items[I] as IIsChecked ).IsChecked := false;
    end;
  end;
end;

{ TNBoxCard }

procedure TNBoxCardBase.AutoLook;
begin
  if Assigned(OnAutoLook) then
    OnAutoLook(Self);
end;

constructor TNBoxCardBase.Create(Aowner: TComponent);
begin
  {$IFDEF COUNT_APP_OBJECTS} CardCounter.Inc; {$ENDIF}
  inherited;
  FItem := nil;
end;

destructor TNBoxCardBase.Destroy;
begin
  {$IFDEF COUNT_APP_OBJECTS} CardCounter.Dec; {$ENDIF}
  try
    if Assigned(FItem) then begin
      if HasBookmark then
        (FItem as TNBoxBookmark).FreeObj;

      FreeInterfaced(FItem);
    end;

    try
      inherited;
    except
      On E: Exception do
        Log('TNBoxCardBase.Destroy inherited', E);
    end;

  except
    On E: Exception do
      Log('TNBoxCardBase.Destroy', E);
  end;
end;

function TNBoxCardBase.GetBookmark: TNBoxBookmark;
begin
  if HasBookmark then
    Result := (FItem as TNBoxBookmark)
  else
    Result := nil;
end;

function TNBoxCardBase.GetPost: INBoxItem;
begin
  if not Assigned(FItem) then
  begin
    Result := nil;
    exit;
  end;

  if (FItem is TNBoxBookmark) then
  begin
    if TNBoxBookmark(FItem).BookmarkType = Content then
      Result := TNBoxBookmark(FItem).AsItem
    else
      Result := nil;
  end else begin
    Result := (FItem as INBoxItem);
  end;
end;

function TNBoxCardBase.HasBookmark: boolean;
begin
  Result := (FItem is TNBoxBookmark);
end;

function TNBoxCardBase.HasPost: boolean;
begin
  Result := Assigned(Post);
end;

procedure TNBoxCardBase.SetItem(Value: IHasOrigin);
begin
  if not Assigned(Value) then exit;
  if Assigned(FItem) then
    FreeInterfaced(FItem);
  FItem := Value;
end;

end.

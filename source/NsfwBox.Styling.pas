{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Styling;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  XSuperObject, Alcinoe.FMX.Objects, NsfwBox.Graphics.Rectangle, NsfwBox.Graphics,
  System.IOUtils, NsfwBox.FileSystem, NsfwBox.Consts;

const
  ICON_NSFWBOX     = 'app-icon.png';
  ICON_SEARCH      = 'search.png';
  ICON_MENU        = 'menu.png';
  ICON_CLOSETAB    = 'tab-close.png';
  ICON_CURRENT_TAB = 'current-tab.png';
  ICON_BOOKMARKS   = 'bookmarks.png';
  ICON_SETTINGS    = 'settings.png';
  ICON_NEWTAB      = 'new-tab.png';
  ICON_DOWNLOADS   = 'downloads.png';
  ICON_DOWNLOAD    = 'download.png';
  ICON_TAG         = 'tag.png';
  ICON_NEXT        = 'next.png';
  ICON_PLAY        = 'play.png';
  ICON_COPY        = 'copy.png';
  ICON_SAVE        = 'save.png';
  ICON_ADD         = 'add.png';
  ICON_EDIT        = 'edit.png';
  ICON_DELETE      = 'delete.png';
  ICON_HISTORY     = 'history.png';
  ICON_AVATAR      = 'avatar.png';
  ICON_FILES       = 'files.png';
  ICON_WARNING     = 'warning-sign.png';
  ICON_DONE        = 'done.png';

  ICON_IMAGE       = 'image.png';
  ICON_VIDEO       = 'video.png';
  ICON_STRAIGHT    = 'heterosexual.png';
  ICON_TRANS       = 'transgender.png';
  ICON_GAY         = 'gay.png';
  ICON_CARTOONS    = 'cartoons.png';

  ICON_ORIGIN_PREFIX = 'content-origin-';

  IMAGE_LOADING    = 'image-loading.png';
  IMAGE_LOAD_ERROR = 'image-loading-error.png';
  IMAGE_DUMMY_AUDIO = 'dummy-audio.png';
  IMAGE_DUMMY_VIDEO = 'dummy-video.png';
  IMAGE_REQUEST_ITEM = 'request-item.png';

  { HTML COLORS }
  COLOR_TAG_GENERAL   = '#FFFFFF';
  COLOR_TAG_COPYRIGHT = '#FFC0F3';
  COLOR_TAG_METADATA  = '#FFF9C0';
  COLOR_TAG_CHARACTER = '#C0FFC8';
  COLOR_TAG_ARTIST    = '#FFC0C0';

  COLOR_TAG_TOTAL_COUNT = '#90A4AE';


type

  TColorAr = TArray<TAlphaColor>;

  TNBoxPos = record
    X: Single;
    Y: single;
    class function New(Ax, Ay: single): TNBoxPos; static;
  end;

  TNBoxGradientStyle = class(TObject)
    Colors: TColorAr;
    Style: TGradientStyle;
    StartPos: TNBoxPos;
    StopPos: TNBoxPos;
    procedure Apply(AGradient: TGradient); virtual;
    constructor Create; virtual;
  end;

  TNBoxBrushStyle = class(TObject)
    Color: TAlphaColor;
    Gradient: TNBoxGradientStyle;
    Kind: TBrushKind;
    procedure Apply(ABrush: TBrush); virtual;
    constructor Create; virtual;
    destructor Destroy; virtual;
  end;

  TNBoxStrokeBrushStyle = class(TNBoxBrushStyle)
    Thickness: single;
    procedure Apply(AStroke: TStrokeBrush); virtual;
    constructor Create; override;
  end;

  TNBoxFillAndStroke = class(TObject)
    private
      Owner: TObject;
    public
      Fill: TNBoxBrushStyle;
      Stroke: TNBoxStrokeBrushStyle;
      procedure Apply(AValue: TObject); virtual;
      constructor Create(AOwner: TObject); virtual;
      destructor Destroy; virtual;
  end;

  TNBoxEditStyle = class(TNBoxFillAndStroke)
    FontName: string;
    FontSize: single;
    FontColor: TAlphaColor;
    XRadius: single;
    YRadius: single;
    procedure Apply(AValue: TObject); override;
    constructor Create(AOwner: TObject); override;
  end;

  TRectRec = record
    Left, Top, Right, Bottom: single;
    function AsRect: TRectF;
    class function New(ALeft, ATop, ARight, ABottom: single): TRectRec; static;
  end;

  TNBoxRectStyle = class(TNBoxFillAndStroke)
    private
      Owner: TObject;
    public
      ImageFilename: string;
      ImageMargins: TRectRec;
      Fill2: TNBoxBrushStyle;
      Stroke2: TNBoxStrokeBrushStyle;
      XRadius: single;
      YRadius: single;
      procedure Apply(AValue: TObject); override;
      constructor Create(AOwner: TObject); virtual;
      destructor Destroy; override;
  end;

  TNBoxTabStyle = class(TNBoxRectStyle)
    public
      Item: TNBoxRectStyle;
      procedure Apply(AValue: TNboxTab); overload; virtual;
      procedure Apply(AValue: TNBoxCheckButton); overload; virtual;
      constructor Create(AOwner: TObject); virtual;
      destructor Destroy; override;
  end;

  TNBoxGUIStyle = class(TObject)
    public
      StyleName: string;
      StyleResPath: string;
      TextColors: TColorAr;
      Form: TNBoxBrushStyle;
      Topbar: TNBoxBrushStyle;
      Multiview: TNBoxBrushStyle;
      Button: TNBoxRectStyle;
      Button2: TNBoxRectStyle;
      ButtonIcon: TNBoxRectStyle;
      ButtonIcon2: TNBoxRectStyle;
      ButtonIcon3: TNBoxRectStyle;
      Edit: TNBoxEditStyle;
      Tab: TNBoxTabStyle;
      Checkbox: TNBoxRectStyle;
      CheckButton: TNBoxTabStyle;
      SettingsRect: TNBoxRectStyle;
      CheckButtonSettings: TNBoxTabStyle;
      Memo: TNBoxRectStyle;
      ItemCard: TNBoxRectStyle;
      ItemCardRequest: TNBoxRectStyle;
      function GetImagePath(AOrigin: integer): string; overload;
      function GetImagePath(AImageName: string): string; overload;
      procedure Assign(AValue: TNBoxGUIStyle);
      constructor Create; virtual;
      destructor Destroy; override;
  end;



implementation

{ TNBoxGUIStyle }

procedure TNBoxGUIStyle.Assign(AValue: TNBoxGUIStyle);
begin
  Self.AssignFromJSON(AValue.AsJSONObject);
end;

constructor TNBoxGUIStyle.Create;
begin
  StyleName    := '';
  StyleResPath := '';
  TextColors   := [ TAlphacolorrec.White, TAlphacolorrec.Lightgray ];
  Form         := TNBoxBrushStyle.Create;
  Topbar       := TNBoxBrushStyle.Create;
  Multiview    := TNBoxBrushStyle.Create;
  Button       := TNBoxRectStyle.Create(Self);
  Button2      := TNBoxRectStyle.Create(Self);
  ButtonIcon   := TNBoxRectStyle.Create(Self);
  ButtonIcon2  := TNBoxRectStyle.Create(Self);
  ButtonIcon3  := TNBoxRectStyle.Create(Self);
  Edit         := TNBoxEditStyle.Create(Self);
  Tab          := TNBoxTabStyle.Create(Self);
  Checkbox     := TNBoxRectStyle.Create(Self);
  CheckButton  := TNBoxTabStyle.Create(Self);
  SettingsRect := TNBoxRectStyle.Create(Self);
  CheckButtonSettings := TNBoxTabStyle.Create(Self);
  Memo         := TNBoxRectStyle.Create(Self);
  ItemCard     := TNBoxRectStyle.Create(Self);
  ItemCardRequest := TNBoxRectStyle.Create(Self);
end;

destructor TNBoxGUIStyle.Destroy;
begin
  Form.Free;
  Topbar.Free;
  Multiview.Free;
  Button.Free;
  Button2.Free;
  ButtonIcon.Free;
  ButtonIcon2.Free;
  ButtonIcon3.Free;
  Edit.Free;
  Checkbox.Free;
  Tab.Free;
  CheckButton.Free;
  SettingsRect.Free;
  CheckButtonSettings.Free;
  Memo.Free;
  ItemCard.Free;
  ItemCardRequest.Free;
end;


function TNBoxGUIStyle.GetImagePath(AImageName: string): string;
begin
   Result := '';
   if AImageName.IsEmpty then
    exit;
   Result := TPath.Combine(TNBoxPath.GetThemesPath, Self.StyleResPath);
   Result := Tpath.Combine(Result, AImageName);
end;

function TNBoxGUIStyle.GetImagePath(AOrigin: integer): string;
begin
  case AOrigin of
    PVR_BLEACHBOORU: AOrigin := PVR_DANBOORU;
    PVR_E621: Exit('https://raw.githubusercontent.com/e621ng/e621ng/master/public/favicon-32x32.png');
  end;
  Result := GetImagePath(ICON_ORIGIN_PREFIX + AOrigin.ToString + '.png');
end;


{ TNBoxGradientStyle }

procedure TNBoxGradientStyle.Apply(AGradient: TGradient);
begin
  with AGradient do begin
    Color  := Self.Colors[0];
    color1 := self.Colors[1];
    style  := self.Style;
    StartPosition.Point := TPointF.Create(StartPos.X, StartPos.Y);
    StopPosition.Point := TPointF.Create(StopPos.X, StopPos.Y);
  end;
end;

constructor TNBoxGradientStyle.Create;
begin
  Colors := [TAlphacolorrec.Black, TAlphacolorrec.White];
  Style  := TGradientStyle.Linear;
  StartPos := TNBoxPos.New(0, 0);
  StopPos  := TNBoxPos.New(0, 0);
end;

{ TNBoxBrushStyle }

procedure TNBoxBrushStyle.Apply(ABrush: TBrush);
begin
  Self.Gradient.Apply(ABrush.Gradient);
  ABrush.Color := Color;
  ABrush.Kind := Kind;
end;

constructor TNBoxBrushStyle.Create;
begin
  Gradient := TNBoxGradientStyle.Create;
  Kind := TBrushKind.Gradient;
  Color := TAlphacolorrec.White;
end;

destructor TNBoxBrushStyle.Destroy;
begin
  Gradient.Free;
end;

{ TNBoxStrokeBrushStyle }

procedure TNBoxStrokeBrushStyle.Apply(AStroke: TStrokeBrush);
begin
  inherited Apply(AStroke as TBrush);
  AStroke.Thickness := self.Thickness;
end;

constructor TNBoxStrokeBrushStyle.Create;
begin
  inherited;
  Self.Thickness := 2;
end;

{ TNBoxFillAndStroke }

procedure TNBoxFillAndStroke.Apply(AValue: TObject);
begin
  with ( AValue as TAlRectangle ) do begin
    self.Fill.Apply(Fill);
    self.Stroke.Apply(Stroke);
  end;
end;

constructor TNBoxFillAndStroke.Create(AOwner: TObject);
begin
  Owner := AOwner;
  Fill := TNBoxBrushStyle.Create;
  Stroke := TNBoxStrokeBrushStyle.Create;
end;

destructor TNBoxFillAndStroke.Destroy;
begin
  Fill.Free;
  Stroke.Free;
end;

{ TNBoxRectStyle }

procedure TNBoxRectStyle.Apply(AValue: TObject);
var
  StylingFinished: boolean;
begin
  StylingFinished := false;

  if ( AValue is TRectButton ) then begin
    with ( AValue as TRectButton ) do begin

      self.Fill.Apply(FillDef);
      Self.Stroke.Apply(StrokeDef);
      Self.Fill2.Apply(FillMove);
      Self.Stroke2.Apply(StrokeMove);
      ImageControl.Margins.Rect := ImageMargins.AsRect;

      if not ImageFilename.IsEmpty then begin
        if ( Self.Owner is TNBoxGUIStyle ) then begin
          Image.ImageURL := ( Self.Owner as TNBoxGUIStyle )
            .GetImagePath(self.ImageFilename);
        end;
      end;

      StylingFinished := true;
    end;
  end else if ( AValue is TRectTextCheck ) then begin
    with ( AValue as TRectTextCheck ) do begin

      self.Fill.Apply(FillChecked);
      Self.Stroke.Apply(StrokeChecked);
      Self.Fill2.Apply(FillUnchecked);
      Self.Stroke2.Apply(StrokeUnchecked);

      StylingFinished := true;
    end;
  end;

  if ( AValue is TAlRectangle ) then begin
    With ( AValue as TAlRectangle ) do begin
      XRadius := self.XRadius;
      YRadius := self.YRadius;
      if not StylingFinished then begin
        Self.Fill.Apply(Fill);
        Self.Stroke.Apply(Stroke);
      end;
    end;
  end;

end;

constructor TNBoxRectStyle.Create(AOwner: TObject);
begin
  Inherited;
  Owner := AOwner;
  ImageFilename := '';
  ImageMargins := TRectRec.New(0, 0, 0, 0);
  Fill2   := TNBoxBrushStyle.Create;
  stroke2 := TNBoxStrokeBrushStyle.Create;
  XRadius := 0;
  YRadius := XRadius;
end;

destructor TNBoxRectStyle.Destroy;
begin
  Fill2.Free;
  Stroke2.Free;
  inherited;
end;

{ TNBoxPos }

class function TNBoxPos.New(Ax, Ay: single): TNBoxPos;
begin
  Result.X := Ax;
  Result.Y := Ay;
end;

{ TNBoxTabStyle }

procedure TNBoxTabStyle.Apply(AValue: TNboxTab);
begin
  inherited Apply(AValue);
  Item.Apply(AValue.CloseBtn);
end;

procedure TNBoxTabStyle.Apply(AValue: TNBoxCheckButton);
begin
  inherited Apply(AValue);
  Item.Apply(AValue.check);
  {$IFDEF MSWINDOWS}
  AValue.Check.XRadius := 6.5;
  AValue.Check.YRadius := AValue.Check.XRadius;
  {$ENDIF}
end;

constructor TNBoxTabStyle.Create(AOwner: TObject);
begin
  Inherited Create(AOwner);
  Item := TNBoxRectStyle.Create(AOwner);
end;

destructor TNBoxTabStyle.Destroy;
begin
  Item.free;
  inherited;
end;

{ TRectRec }

function TRectRec.AsRect: TRectF;
begin
  Result := TRectF.Create(Left, Top, right, bottom);
end;

class function TRectRec.New(ALeft, ATop, ARight, ABottom: single): TRectRec;
begin
  with Result do begin
    Left := ALeft;
    Right := ARight;
    Bottom := ABottom;
    Top := ATop;
  end;
end;

{ TNBoxEditStyle }

procedure TNBoxEditStyle.Apply(AValue: TObject);
begin
  inherited;
  if ( AValue is TNBoxEdit ) then begin
    with (AValue as TNBoxEdit) do begin
      Edit.FontColor := Self.FontColor;
      Edit.Font.Family := Self.FontName;
      Edit.Font.Size := Self.FontSize;
      XRadius := Self.XRadius;
      Yradius := Self.YRadius;
    end;
  end;
end;

constructor TNBoxEditStyle.Create(AOwner: TObject);
begin
  inherited;
  FontName  := 'Roboto';
  FontSize  := 12;
  FontColor := TAlphacolorrec.White;
  XRadius   := 0;
  YRadius   := 0;
end;



end.

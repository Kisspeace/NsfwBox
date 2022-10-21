//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxGraphics.Rectangle;

interface
uses
  SysUtils, System.Types, System.UITypes, Classes,
  FMX.Types, FMX.Controls, FMX.Graphics,
  FMX.TextLayout, FMX.MultiResBitmap,
  FMX.ActnList, AlFmxObjects, AlFmxGraphics, system.generics.collections,
  YDW.FMX.ImageWithURL;

type

  TRectText = class(TAlRectangle)
    public
      Text: TAlText;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

  TRectButton = class(TRectText)
    protected
      procedure Paint; override;
      procedure DoMouseEnter; override;
      procedure DoMouseLeave; override;
    private
      FFillDef: TBrush;
      FStrokeDef: TStrokeBrush;
      FFillMove: TBrush;
      FStrokeMove: TStrokeBrush;
      procedure SetFillDef(const Value: Tbrush);
      procedure SetFillMove(const Value: Tbrush);
      procedure SetStrokeDef(const Value: TStrokeBrush);
      procedure SetStrokeMove(const Value: TStrokeBrush);
    public
      Image: TImageWithURL;
      property FillDef: Tbrush read FFillDef write SetFillDef;
      property StrokeDef: TStrokeBrush read FStrokeDef write SetStrokeDef;
      property FillMove: Tbrush read FFillMove write SetFillMove;
      property StrokeMove: TStrokeBrush read FStrokeMove write SetStrokeMove;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

  TRectTextCheck = class(TRectText, IIsChecked)
    protected
      FOnChanged: TNotifyEvent;
      FCheckedBrush: Tbrush;
      FUnCheckedBrush: Tbrush;
      FCheckedStrokeBrush: TStrokeBrush;
      FUnCheckedStrokeBrush: TStrokeBrush;
      FIsChecked: boolean;
      procedure OnTapOverride(sender: TObject; const APoint: TPointF);
      procedure SetCheckedBrush(const A: Tbrush);
      procedure SetUnCheckedBrush(const A: Tbrush);
      procedure SetCheckedStokeBrush(const A: TStrokeBrush);
      procedure SetUnCheckedStokeBrush(const A: TStrokeBrush);
      procedure OnBrushChanged(Sender: TObject);
      procedure UpdateBrush;
      procedure Click; override;
      function GetIsChecked: Boolean; virtual;
      procedure SetIsChecked(const Value: Boolean); virtual;
      function IsCheckedStored: Boolean;
    public
      Constructor Create(Aowner: tcomponent); override;
      Destructor Destroy; override;
    published
      property IsChecked: Boolean read GetIsChecked write SetIsChecked default false;
      property FillChecked: Tbrush read FCheckedBrush write SetCheckedBrush;
      property FillUnChecked: Tbrush read FUnCheckedBrush write SetUnCheckedBrush;
      property StrokeChecked: TStrokeBrush read FCheckedStrokeBrush write SetCheckedStokeBrush;
      property StrokeUnchecked: TStrokeBrush read FUnCheckedStrokeBrush write SetUnCheckedStokeBrush;
      property OnChanged: TNotifyEvent read FOnChanged Write FOnChanged;
  end;

  TIsCheckedList = TList<IIsChecked>;

implementation

Constructor TRectTextCheck.Create(Aowner: tcomponent);
begin
  inherited create(Aowner);
  FIsChecked := false;
  FCheckedBrush := tbrush.Create(Fill.Kind, fill.Color);
  FUnCheckedBrush := tbrush.Create(Fill.Kind, fill.Color);
  FCheckedStrokeBrush := TStrokeBrush.Create(Fill.Kind, stroke.Color);
  FUnCheckedStrokeBrush := TStrokeBrush.Create(Fill.Kind, stroke.Color);
  FCheckedStrokeBrush.OnChanged := self.OnBrushChanged;
  FUnCheckedStrokeBrush.OnChanged := self.OnBrushChanged;
  FCheckedBrush.OnChanged := self.OnBrushChanged;
  FUnCheckedBrush.OnChanged := Self.OnBrushChanged;
  OnTap := OnTapOverride;
  ISChecked := false;
  Cursor := CrHandPoint;
end;

procedure TRectTextCheck.UpdateBrush;
begin
  if isChecked then begin
    Fill := FCheckedBrush;
    Stroke :=  FCheckedStrokeBrush;
  end else begin
    Fill := FUnCheckedBrush;
    Stroke :=  FUnCheckedStrokeBrush;
  end;
end;

procedure TRectTextCheck.OnBrushChanged(Sender: tobject);
begin
  UpdateBrush;
end;

Destructor TRectTextCheck.Destroy;
begin
  FCheckedBrush.Free;
  FUnCheckedBrush.Free;
  FCheckedStrokeBrush.Free;
  FUnCheckedStrokeBrush.Free;
  inherited;
end;

procedure TRectTextCheck.SetIsChecked(const Value: Boolean);
begin
  if Value = FIsChecked then exit;
  FIsChecked := value;
  UpdateBrush;
  if assigned(FOnChanged) then FOnChanged(Self);
end;

function TRectTextCheck.IsCheckedStored: Boolean;
begin
  Result := true;
end;

function TRectTextCheck.GetIsChecked: Boolean;
begin
  Result := FiSChecked;
end;

procedure TRectTextCheck.OnTapOverride(sender: TObject; const APoint: tpointf);
begin
  {$IFDEF ANDROID}
    if Enabled then
      IsChecked := (Not IsChecked);
  {$ENDIF}
end;

procedure TRectTextCheck.SetCheckedBrush(const A: Tbrush);
begin
  FCheckedBrush.Assign(A);
  UpdateBrush;
end;

procedure TRectTextCheck.SetCheckedStokeBrush(const A: TStrokeBrush);
begin
  FCheckedStrokeBrush.Assign(A);
  UpdateBrush;
end;

procedure TRectTextCheck.SetUnCheckedBrush(const A: Tbrush);
begin
  FUnCheckedBrush.Assign(A);
  UpdateBrush;
end;

procedure TRectTextCheck.SetUnCheckedStokeBrush(const A: TStrokeBrush);
begin
  FUnCheckedStrokeBrush.Assign(A);
  UpdateBrush;
end;

procedure TRectTextCheck.Click;
begin
  {$IFDEF MSWINDOWS}
    if Enabled then
      IsChecked := (Not IsChecked);
  {$ENDIF}
  inherited;
end;

{ TRectText }

constructor TRectText.Create(AOwner: TComponent);
begin
  inherited;
  Text := TAlText.create(self);
  Text.parent := self;
  Text.align := TAlignlayout.client;
  Text.hittest := false;
end;

destructor TRectText.Destroy;
begin
  Text.free;
  inherited;
end;

{ TRectButton }

constructor TRectButton.Create(AOwner: TComponent);
begin
  inherited;
  Cursor := CrhandPoint;
  FFillMove   := tbrush.Create(Fill.Kind, fill.Color);
  FStrokeMove := TStrokeBrush.Create(Fill.Kind, stroke.Color);
  FFillDef    := tbrush.Create(Fill.Kind, fill.Color);;
  FStrokeDef  := TStrokeBrush.Create(Fill.Kind, stroke.Color);

  Image := TImageWithURL.Create(Self);
  with Image do begin
    parent := Self;
    Hittest := false;
    Align := TAlignLayout.MostLeft;
  end;
end;

destructor TRectButton.Destroy;
begin
  FFillMove.Free;
  FFillDef.Free;
  FStrokeMove.Free;
  FStrokedef.Free;
  Image.Free;
  inherited;
end;

procedure TRectButton.DoMouseEnter;
begin
  inherited;
  Repaint;
end;

procedure TRectButton.DoMouseLeave;
begin
  inherited;
  Repaint;
end;

procedure TRectButton.Paint;
begin
  if Self.IsMouseOver then begin
    Fill := self.FillMove;
    Stroke := Self.FStrokeMove;
  end else begin
    Fill := Self.FillDef;
    Stroke := Self.StrokeDef;
  end;
  inherited;
end;

procedure TRectButton.SetFillDef(const Value: Tbrush);
begin
  FFillDef.Assign(value);
  Repaint;
end;

procedure TRectButton.SetFillMove(const Value: Tbrush);
begin
  FFillMove.Assign(value);
  Repaint;
end;

procedure TRectButton.SetStrokeDef(const Value: TStrokeBrush);
begin
  FStrokeDef.Assign(Value);
end;

procedure TRectButton.SetStrokeMove(const Value: TStrokeBrush);
begin
  FStrokeMove.Assign(value);
end;

end.


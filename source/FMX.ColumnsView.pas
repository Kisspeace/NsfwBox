{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit FMX.ColumnsView;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Layouts, FMX.Controls,
  Fmx.Types, System.Generics.Collections;

type

  TColumnsModule = Class(TComponent)
    public type
      TColumn = Class(TComponent)
        private
          FSize: TControlSize;
          FPosition: TPosition;
          FIsUpdating: boolean;
          function GetBottom: single;
          procedure SetPosition(const Value: TPosition);
          procedure SetSize(const Value: TControlSize);
          procedure OnChangeSize(Sender: TObject);
          procedure PlaceAfter(AItem: TControl; APrevItem: TControl = Nil);
        public
          Controls: TControlList;
          property Size: TControlSize read FSize write SetSize;
          property Position: TPosition read FPosition write SetPosition;
          property IsUpdating: boolean read FIsUpdating;
          procedure Add(ANew: TControl);
          procedure Recalc;
          procedure BeginUpdate;
          procedure EndUpdate;
          constructor Create(AOwner: TComponent); override;
          destructor Destroy; override;
      End;
      TColumnList = TObjectList<TColumn>;
    private
      procedure SetColumnsCount(const Value: integer);
      function GetMinColumn: TColumn;
      function GetMaxColumn: TColumn;
      procedure SetIndent(const Value: TPointF);
      function GetColumnsCount: integer;
    protected
      FColumns: TColumnList;
      FIndent: TPointF;
      FTargetControl: TControl;
      FAfterPlaceControl: TNotifyEvent;
      function GetChildControls: TControlList;
    public
      procedure RecalcColumns;
      function PlaceControl(ANew: TControl): TColumn;
      procedure DeleteControl(AControl: TControl);
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
      property ColumnsCount: integer read GetColumnsCount write SetColumnsCount;
      property ItemsIndent: TPointF read FIndent write SetIndent;
      property AfterPlaceControl: TNotifyEvent read FAfterPlaceControl write FAfterPlaceControl;
  End;

  TColumnsLayout = Class(TLayout)
    private
      function GetColumnsCount: integer;
      function GetItemsIndent: TPointF;
      procedure SetColumnsCount(const Value: integer);
      procedure SetItemsIndent(const Value: TPointF);
    procedure SetAutoSize(const Value: boolean);
    protected
      FColumnsModule: TColumnsModule;
      FAutoSize: boolean;
      procedure Resize; override;
      procedure DoAddObject(const AObject: TFmxObject); override;
      procedure DoRemoveObject(const AObject: TFmxObject); override;
      procedure DoAfterPlaceControl(Sender: TObject); virtual;
    public
      procedure RecalcColumns;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
      property ColumnsCount: integer read GetColumnsCount write SetColumnsCount;
      property ItemsIndent: TPointF read GetItemsIndent write SetItemsIndent;
      property AutoSize: boolean read FAutoSize write SetAutoSize;
  End;

  TColumnsVertScrollBox = Class(TVertScrollBox)
    private
      function GetColumnsCount: integer;
      function GetItemsIndent: TPointF;
      procedure SetColumnsCount(const Value: integer);
      procedure SetItemsIndent(const Value: TPointF);
    protected
      FColumnsModule: TColumnsModule;
      procedure Resize; override;
      procedure ContentAddObject(const AObject: TFmxObject); override;
      procedure ContentRemoveObject(const AObject: TFmxObject); override;
    public
      procedure RecalcColumns;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
      property ColumnsCount: integer read GetColumnsCount write SetColumnsCount;
      property ItemsIndent: TPointF read GetItemsIndent write SetItemsIndent;
  End;

  TColumnsView = TColumnsVertScrollBox;

implementation

{ TColumnsModule }

constructor TColumnsModule.Create(AOwner: TComponent);
begin
  Inherited;
  FColumns := TColumnList.Create;
  FTargetControl := TControl(AOwner);
  Self.ColumnsCount := 1;
end;

procedure TColumnsModule.DeleteControl(AControl: TControl);
var
  I: integer;
  LIndex: integer;
begin
  if (FColumns.Count < 1) then exit;

  for I := 0 to FColumns.Count - 1 do begin
    LIndex := FColumns[I].Controls.IndexOf(AControl);
    if (LIndex <> -1) then begin
      FColumns[I].Controls.Delete(LIndex);
      break;
    end;
  end;
end;

destructor TColumnsModule.Destroy;
begin
  FColumns.Free;
  inherited;
end;

function TColumnsModule.GetChildControls: TControlList;
begin
  if (FTargetControl is TScrollBox) then
    Result := TScrollBox(FTargetControl).Content.Controls
  else if (FTargetControl is TVertScrollBox) then
    Result := TVertScrollBox(FTargetControl).Content.Controls
  else if (FTargetControl is THorzScrollBox) then
    Result := THorzScrollBox(FTargetControl).Content.Controls
  else
    Result := FTargetControl.Controls;
end;

function TColumnsModule.GetColumnsCount: integer;
begin
  Result := FColumns.Count;
end;

function TColumnsModule.GetMaxColumn: TColumn;
var
  I: integer;
begin
  Result := Nil;
  if (FColumns.Count < 1) then exit;
  Result := FColumns.First;

  for I := 1 to FColumns.Count - 1 do begin
    if (FColumns[I].GetBottom > Result.GetBottom) then
      Result := FColumns[I];
  end;
end;

function TColumnsModule.GetMinColumn: TColumn;
var
  I: integer;
begin
  Result := Nil;
  if (FColumns.Count < 1) then exit;
  Result := FColumns.First;

  for I := 1 to FColumns.Count - 1 do begin
    if (FColumns[I].GetBottom < Result.GetBottom) then
      Result := FColumns[I];
  end;
end;

function TColumnsModule.PlaceControl(ANew: TControl): TColumn;
var
  LTargetColumn: TColumn;
begin
  if (FColumns.Count < 1) then begin
    Result := nil;
    exit;
  end;

  LTargetColumn := Self.GetMinColumn;
  ANew.Margins.Top := FIndent.Y;
  LTargetColumn.Add(ANew);
  Result := LTargetColumn;

  if Assigned(AfterPlaceControl) then
    AfterPlaceControl(Self);
end;

procedure TColumnsModule.RecalcColumns;
var
  I: Integer;
  LColumnWidth: Single;
  LIndents: Single;
  LItem: TColumn;
  LPrevItem: TColumn;
begin
  if (FColumns.Count < 1) then exit;

  LIndents := FColumns.Count * FIndent.X;
  LIndents := LIndents + FIndent.X;
  LColumnWidth := (FTargetControl.Width - LIndents) / FColumns.Count;

  LPrevItem := Nil;
  for i := 0 to FColumns.Count - 1 do begin
    LItem := FColumns[I];
    LItem.BeginUpdate;
    try
      LItem.Size.Width := LColumnWidth;
      LItem.Position.Y := FTargetControl.Padding.Top;

      if Assigned(LPrevItem) then
        LItem.Position.X := LPrevItem.Position.X + LColumnWidth + FIndent.X
      else
        LItem.Position.X := FIndent.X; // First column

    finally
      LItem.EndUpdate;
    end;

    LItem.Recalc;
    LPrevItem := LItem;
  end;
end;

procedure TColumnsModule.SetColumnsCount(const Value: integer);
var
  I: integer;
  LColumn: TColumnsModule.TColumn;
  LColumnsCount: integer;
  LControls: TControlList;
begin
  if (Value < 1) then
    LColumnsCount := 1
  else
    LColumnsCount := Value;

  LControls := Self.GetChildControls;

  FColumns.Clear;
  for I := 1 to LColumnsCount do begin
    LColumn := TColumnsModule.TColumn.Create(Self);
    FColumns.Add(LColumn);
  end;

  Self.RecalcColumns;
  if (LControls.Count < 1) then exit;

  for I := 0 to LControls.Count - 1 do begin
    Self.PlaceControl(LControls[I]);
  end;
end;

procedure TColumnsModule.SetIndent(const Value: TPointF);
begin
  FIndent := Value;
  Self.RecalcColumns;
end;

{ TColumnsView.TColumn }

procedure TColumnsModule.TColumn.Add(ANew: TControl);
var
  LLast: TControl;
begin
  if (Self.Controls.Count > 0) then
    LLast := Self.Controls.Last
  else
    LLast := Nil;

  Self.Controls.Add(ANew);
  Self.PlaceAfter(ANew, LLast);

  Self.BeginUpdate;
  FSize.Height := FSize.Height + ANew.Height + ANew.Position.Y;
  Self.EndUpdate;
end;

procedure TColumnsModule.TColumn.BeginUpdate;
begin
  Self.FIsUpdating := True;
end;

constructor TColumnsModule.TColumn.Create(AOwner: TComponent);
begin
  inherited;
  Controls := TControlList.Create;
  FSize := TControlSize.Create(TSizeF.Create(0, 0));
  FSize.OnChange := Self.OnChangeSize;
  FPosition := TPosition.Create(TPointF.Create(0, 0));
  FPosition.OnChange := OnChangeSize;
end;

destructor TColumnsModule.TColumn.Destroy;
begin
  Controls.Free;
  FSize.Free;
  FPosition.Free;
  inherited;
end;

procedure TColumnsModule.TColumn.EndUpdate;
begin
  Self.FIsUpdating := False;
end;

function TColumnsModule.TColumn.GetBottom: single;
begin
  if (Controls.Count < 1) then
    Result := Self.Position.Y
  else
    Result := Self.Controls.Last.BoundsRect.Bottom;
end;

procedure TColumnsModule.TColumn.OnChangeSize(Sender: TObject);
begin
  if not FIsUpdating then
    Self.Recalc;
end;

procedure TColumnsModule.TColumn.PlaceAfter(AItem, APrevItem: TControl);
begin
  AItem.Size.Width := FSize.Width;
  AItem.Position.X := FPosition.X;

  if Assigned(APrevItem) then
    AItem.Position.Y := APrevItem.BoundsRect.Bottom + AItem.Margins.Top
  else
    AItem.Position.Y := FPosition.Y;
end;

procedure TColumnsModule.TColumn.Recalc;
var
  I: integer;
begin
  if (Controls.Count < 1) then begin
    Self.BeginUpdate;
    Self.Size.Height := 0;
    exit;
    Self.EndUpdate;
  end;

  Self.BeginUpdate;
  try
    PlaceAfter(Controls.First{[0]}, Nil);
    for I := 1 to Controls.Count - 1 do begin
      PlaceAfter(Controls[I], Controls[I - 1]);
    end;

    Self.Size.Height := Self.GetBottom;
  finally
    Self.EndUpdate;
  end;
end;

procedure TColumnsModule.TColumn.SetPosition(const Value: TPosition);
begin
  FPosition.Assign(Value);
end;

procedure TColumnsModule.TColumn.SetSize(const Value: TControlSize);
begin
  FSize.Assign(Value);
end;

{ TColumnsVertScrollBox }

procedure TColumnsVertScrollBox.ContentAddObject(const AObject: TFmxObject);
begin
  Inherited;
  if (AObject is TControl) then
    FColumnsModule.PlaceControl(TControl(AObject))
end;

procedure TColumnsVertScrollBox.ContentRemoveObject(const AObject: TFmxObject);
begin
  if (AObject is TControl) then
    FColumnsModule.DeleteControl(TControl(AObject));
  inherited;
end;

constructor TColumnsVertScrollBox.Create(AOwner: TComponent);
begin
  inherited;
  FColumnsModule := TColumnsModule.Create(Self);
end;

destructor TColumnsVertScrollBox.Destroy;
begin
  FColumnsModule.Free;
  inherited;
end;

function TColumnsVertScrollBox.GetColumnsCount: integer;
begin
  Result := FColumnsModule.ColumnsCount;
end;

function TColumnsVertScrollBox.GetItemsIndent: TPointF;
begin
  Result := FColumnsModule.ItemsIndent;
end;

procedure TColumnsVertScrollBox.RecalcColumns;
begin
  FColumnsModule.RecalcColumns;
end;

procedure TColumnsVertScrollBox.Resize;
begin
  inherited;
  Self.RecalcColumns;
end;

procedure TColumnsVertScrollBox.SetColumnsCount(const Value: integer);
begin
  FColumnsModule.ColumnsCount := Value;
end;

procedure TColumnsVertScrollBox.SetItemsIndent(const Value: TPointF);
begin
  FColumnsModule.ItemsIndent := Value;
end;

{ TColumnsLayout }

constructor TColumnsLayout.Create(AOwner: TComponent);
begin
  inherited;
  FColumnsModule := TColumnsModule.Create(Self);
  FColumnsModule.AfterPlaceControl := Self.DoAfterPlaceControl;
end;

destructor TColumnsLayout.Destroy;
begin
  FColumnsModule.Free;
  inherited;
end;

procedure TColumnsLayout.DoAddObject(const AObject: TFmxObject);
begin
  inherited;
  if (AObject is TControl) then
    FColumnsModule.PlaceControl(TControl(AObject));
end;

procedure TColumnsLayout.DoAfterPlaceControl(Sender: TObject);
begin
  if AutoSize then
    Self.Resize;
end;

procedure TColumnsLayout.DoRemoveObject(const AObject: TFmxObject);
begin
  if (AObject is TControl) then
    FColumnsModule.DeleteControl(TControl(AObject));
  inherited;
end;

function TColumnsLayout.GetColumnsCount: integer;
begin
  Result := FColumnsModule.ColumnsCount;
end;

function TColumnsLayout.GetItemsIndent: TPointF;
begin
  Result := FColumnsModule.ItemsIndent;
end;

procedure TColumnsLayout.RecalcColumns;
begin
  FColumnsModule.RecalcColumns;
end;

procedure TColumnsLayout.Resize;
begin
  inherited;
  Self.RecalcColumns;
  if AutoSize then begin
    var LCol: TColumnsModule.TColumn;
    LCol := FColumnsModule.GetMaxColumn;
    if Assigned(LCol) then
      Self.Height := LCol.GetBottom;
  end;
end;

procedure TColumnsLayout.SetAutoSize(const Value: boolean);
begin
  FAutoSize := Value;
end;

procedure TColumnsLayout.SetColumnsCount(const Value: integer);
begin
  FColumnsModule.ColumnsCount := Value;
end;

procedure TColumnsLayout.SetItemsIndent(const Value: TPointF);
begin
  FColumnsModule.ItemsIndent := Value;
end;

end.

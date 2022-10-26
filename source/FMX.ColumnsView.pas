{  This unit is part of https://github.com/Kisspeace/NsfwBox }
unit FMX.ColumnsView;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Layouts, FMX.Controls,
  Fmx.Types, System.Generics.Collections;

type

  TColumnsView = Class(TVertScrollBox)
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
      procedure SetIndent(const Value: TPointF);
      function GetColumnsCount: integer;
    protected
      FColumns: TColumnList;
      FIndent: TPointF;
      procedure Resize; override;
      function PlaceControl(ANew: TControl): TColumn;
      procedure DoAddObject(const AObject: TFmxObject); override;
      procedure ContentRemoveObject(const AObject: TFmxObject); override;
    public
      procedure RecalcColumns;
//      procedure ClearContent;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
      property ColumnsCount: integer read GetColumnsCount write SetColumnsCount;
      property ItemsIndent: TPointF read FIndent write SetIndent;
  End;

implementation

{ TColumnsView }

//procedure TColumnsView.ClearContent;
//var
//  I: integer;
//begin
//  if (FColumns.Count < 1) then exit;
//
//  FColumns.Clear;
//  for I := 0 to Self.Content.Controls.Count - 1 do begin
//    Self.Content.Controls[I].Free;
//  end;
//  Self.Content.Controls.Clear;
//end;

procedure TColumnsView.ContentRemoveObject(const AObject: TFmxObject);
var
  I: integer;
  LIndex: integer;
begin
  if (AObject is TControl) and (FColumns.Count > 0) then begin
    for I := 0 to FColumns.Count - 1 do begin
      LIndex := FColumns[I].Controls.IndexOf(AObject as TControl);
      if (LIndex <> -1) then begin
        FColumns[I].Controls.Delete(LIndex);
        break;
      end;
    end;
  end;
  inherited;
end;

constructor TColumnsView.Create(AOwner: TComponent);
begin
  Inherited;
  FColumns := TColumnList.Create;
  Self.ColumnsCount := 1;
end;

destructor TColumnsView.Destroy;
begin
  FColumns.Free;
  inherited;
end;

procedure TColumnsView.DoAddObject(const AObject: TFmxObject);
begin
  inherited;
  if (AObject is TControl) and IsAddToContent(AObject) then
    Self.PlaceControl(AObject as TControl);
end;

function TColumnsView.GetColumnsCount: integer;
begin
  Result := FColumns.Count;
end;

function TColumnsView.GetMinColumn: TColumn;
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

function TColumnsView.PlaceControl(ANew: TControl): TColumn;
var
  LTargetColumn: TColumn;
begin
  if (FColumns.Count < 1) then begin
    Result := nil;
    exit;
  end;

//  if ANew.Parent <> Self.Content then
//    ANew.Parent := Self;

  LTargetColumn := Self.GetMinColumn;
  ANew.Margins.Top := FIndent.Y;
  LTargetColumn.Add(ANew);
  Result := LTargetColumn;
end;

procedure TColumnsView.RecalcColumns;
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
  LColumnWidth := (Self.Width - LIndents) / FColumns.Count;

  LPrevItem := Nil;
  for i := 0 to FColumns.Count - 1 do begin
    LItem := FColumns[I];
    LItem.BeginUpdate;
    try
      LItem.Size.Width := LColumnWidth;
      LItem.Position.Y := Self.Padding.Top;

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

procedure TColumnsView.Resize;
begin
  Self.RecalcColumns;
  inherited;
end;

procedure TColumnsView.SetColumnsCount(const Value: integer);
var
  I: integer;
  LColumn: TColumnsView.TColumn;
  LColumnsCount: integer;
begin
  if (Value < 1) then
    LColumnsCount := 1
  else
    LColumnsCount := Value;

  FColumns.Clear;
  for I := 1 to LColumnsCount do begin
    LColumn := TColumnsView.TColumn.Create(Self);
    FColumns.Add(LColumn);
  end;

  Self.RecalcColumns;
  if (Content.Controls.Count < 1) then exit;

  for I := 0 to Self.Content.Controls.Count - 1 do begin
    Self.PlaceControl(Content.Controls[I]);
  end;
end;

procedure TColumnsView.SetIndent(const Value: TPointF);
begin
  FIndent := Value;
  Self.RecalcColumns;
end;

{ TColumnsView.TColumn }

procedure TColumnsView.TColumn.Add(ANew: TControl);
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

procedure TColumnsView.TColumn.BeginUpdate;
begin
  Self.FIsUpdating := True;
end;

constructor TColumnsView.TColumn.Create(AOwner: TComponent);
begin
  inherited;
  Controls := TControlList.Create;
  FSize := TControlSize.Create(TSizeF.Create(0, 0));
  FSize.OnChange := Self.OnChangeSize;
  FPosition := TPosition.Create(TPointF.Create(0, 0));
  FPosition.OnChange := OnChangeSize;
end;

destructor TColumnsView.TColumn.Destroy;
begin
  Controls.Free;
  FSize.Free;
  FPosition.Free;
  inherited;
end;

procedure TColumnsView.TColumn.EndUpdate;
begin
  Self.FIsUpdating := False;
end;

function TColumnsView.TColumn.GetBottom: single;
begin
  if (Controls.Count < 1) then
    Result := Self.Position.Y
  else
    Result := Self.Controls.Last.BoundsRect.Bottom;
end;

procedure TColumnsView.TColumn.OnChangeSize(Sender: TObject);
begin
  if not FIsUpdating then
    Self.Recalc;
end;

procedure TColumnsView.TColumn.PlaceAfter(AItem, APrevItem: TControl);
begin
  AItem.Size.Width := FSize.Width;
  AItem.Position.X := FPosition.X;

  if Assigned(APrevItem) then
    AItem.Position.Y := APrevItem.BoundsRect.Bottom + AItem.Margins.Top
  else
    AItem.Position.Y := FPosition.Y;

end;

procedure TColumnsView.TColumn.Recalc;
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

procedure TColumnsView.TColumn.SetPosition(const Value: TPosition);
begin
  FPosition.Assign(Value);
end;

procedure TColumnsView.TColumn.SetSize(const Value: TControlSize);
begin
  FSize.Assign(Value);
end;


end.

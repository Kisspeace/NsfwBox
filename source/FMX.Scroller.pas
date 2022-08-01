//♡2022 by Kisspeace. https://github.com/kisspeace
// Maybe rewrite this classes later
unit Fmx.Scroller;

interface

 uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, Fmx.Layouts, FMX.Controls, Fmx.Types;

 type

  TMultiLayout = Class(TLayout)
    private
      FIndent: Single;
      FPlusHeight: Single;
      FBlockPos: integer;
      procedure FsetIndent(A: single); virtual;
      procedure FSetPlusHeight(A: single); virtual;
      procedure FSetBlockCount(A: cardinal); virtual;
      function FGetBlockCount: Cardinal;
      function FAddBlock: Tlayout; virtual;
    protected
      procedure Resize; override;
    public
      AutoCalculateHeight: boolean;
      PlaceItemBySize: boolean;
      HeightMultiplier: single;
      Blocks: TControlList;
      function GetControls: TControlList;
      Function GetItemWidth: Single;
      procedure AddControl(AControl: Tcontrol);
      procedure UpdateItemHeight; virtual;
      procedure UpdateBlocks; virtual;
      procedure ReCalcBlocksSize; virtual;
      procedure UpdateHeight; virtual;
      function GetMinBlock: TControl;
      property PlusHeight: single Read FPlusHeight write FSetPlusHeight;
      property LayoutIndent: Single read Findent write FsetIndent;
      property BlockCount: cardinal Read FGetBlockCount write FSetblockCount;
      property BlockPos: integer read FBlockPos write FBlockPos;
      Constructor Create(Aowner: Tcomponent); overload; override;
      Constructor Create(Aowner: Tcomponent; AblockCount: cardinal); overload;
      Destructor Destroy; override;
  end;

  TMultiLayoutScroller = Class(TVertScrollbox)
    private
      procedure FSetLayoutIndent(A: single);
      function FGetLayoutIndent: Single;
    public
      MultiLayout: TmultiLayout;
      property LayoutIndent: Single read FGetLayoutIndent write FSetLayoutIndent;
      constructor Create(Aowner: Tcomponent); override;
      destructor Destroy; override;
  End;

  procedure _ReExtendHeight(Acontrol: Tcontrol);

implementation

procedure _deleteNilControls(Acontrols: TcontrolList);
var
  i: integer;
  b: boolean;
begin
  b := true;
  while b do begin
    b := false;
    for i := 0 to acontrols.Count - 1 do begin
      if Acontrols.Items[i] = nil then begin
        b := true;
        acontrols.Delete(i);
        break;
      end;
    end;
  end;
end;

//procedure _FreeControls(AControls:TcontrolList);
//var
  //i: integer;
//begin
  //if Acontrols.Count < 1 then
    //exit;
  //for i := 0 to acontrols.Count - 1 do begin
    //Acontrols.Items[0].Free;
  //end;
//end;

function _GetHighest(Acontrols: TcontrolList):integer;
var
  i, N: integer;
  H: single;
begin
  Result := -1;

  if Acontrols.Count < 1 then
    exit;

  N := 0;
  H := Acontrols.First.Height;

  for I := 1 to Acontrols.Count - 1 do begin
    if Acontrols.Items[i].Height > H then begin
      H := Acontrols.Items[i].Height;
      N := i;
    end;
  end;

  Result := N;
end;

function _GetHeight(AControl: TControl):single;
begin
  Result := AControl.Height + AControl.Margins.Top + AControl.Margins.Bottom;
end;

procedure _ReExtendHeight(Acontrol: Tcontrol);
var
  i: integer;
  H: single;
begin
  H := 0;
  for i := 0 to acontrol.Controls.Count - 1 do begin
    H := H + _GetHeight(Acontrol.Controls.Items[i]);
  end;
  Acontrol.Height := H;
end;

procedure _ExtendHeight(Acontrol: Tcontrol);
var
  H: single;
begin
  H := Acontrol.Height + _GetHeight(Acontrol.Controls.Last);
  acontrol.Height := H;
end;

Constructor TMultiLayout.Create(Aowner: Tcomponent);
begin
  inherited create(aowner);
  FblockPos := 0;
  Blocks := Tcontrollist.Create;
end;

Constructor TMultiLayout.Create(Aowner: Tcomponent; AblockCount:cardinal);
begin
  Create(Aowner);
  BlockCount := AblockCount;
end;

function TMultiLayout.GetControls:TControlList;
var
  i: integer;
begin
  result := Tcontrollist.Create;
  for i := 0 to blockcount - 1 do begin
    result.AddRange(Blocks.Items[i].Controls);
  end;
end;

Function TMultiLayout.GetItemWidth:Single;
begin
  Result := (self.Width / controls.Count) - self.FIndent;
end;

procedure TMultiLayout.AddControl(AControl: Tcontrol);
var
  Block: Tcontrol;
begin
  if (FblockPos >= blocks.Count) then
    FblockPos := 0;

  if self.PlaceItemBySize then
    Block := GetMinBlock
  else
    Block := blocks.Items[FBlockPos];

  with AControl do begin
    parent := block;
    Position.Y := block.Height;
    Align := talignlayout.Top;
    if self.AutoCalculateHeight then begin
      acontrol.Height := self.GetItemWidth * self.HeightMultiplier;
    end;
  end;

  if Block.Controlscount = 1 then begin
    _ReExtendHeight(block);
  end else
    _ExtendHeight(Block);

  self.UpdateHeight;
  inc(self.FBlockPos);
end;

procedure TMultiLayout.UpdateItemHeight;
var
  i: integer;
  ctrls: Tcontrollist;
begin
  if self.AutoCalculateHeight then begin
    ctrls := self.GetControls;
    if ctrls.Count < 1 then
      exit;

    for I := 0 to ctrls.Count - 1 do begin
      with ctrls.Items[i] do begin
        height := width * self.HeightMultiplier;
      end;
    end;
  end;
end;

procedure TMultiLayout.ReCalcBlocksSize;
var
  I: integer;
begin
  if Blocks.Count < 1 then
    exit;
  for I := 0 to Blocks.Count - 1  do begin
    _ReExtendHeight(Blocks.Items[i]);
  end;
  self.UpdateHeight;
end;

function TMultiLayout.GetMinBlock: Tcontrol;
var
  i: integer;
begin
  Result := nil;
  if self.Blocks.Count < 1 then
    exit;
  Result := Blocks.Items[0];
  for I := 0 to self.Blocks.Count - 1 do begin
    if self.Blocks.Items[i].Height < result.Height then begin
      result := self.Blocks.Items[i];
    end;
  end;

end;

procedure TMultiLayout.UpdateHeight;
var
  N: integer;
begin
  N := _GetHighest(blocks);
  self.Height := blocks.Items[n].Height + Fplusheight;
end;

procedure TmultiLayout.UpdateBlocks;
var
  i: integer;
  W, X, P: single;
begin
  if blocks.Count < 1 then
    exit;

  W := (self.Width / blocks.Count);
  X := 0;

  P := LayoutIndent / 2;

  for i := 0 to (blocks.Count - 1) do begin
    with Blocks.Items[i] do begin
      Width := W;
      Padding.Left  := P;
      Padding.Right := P;
      position.X := X;
      X := X + W;
    end;
  end;

  blocks.First.Padding.Left := P * 2;
  blocks.Last.Padding.Right := P * 2;
end;

procedure TMultiLayout.FsetIndent(A: single);
begin
  FIndent := A;
  self.UpdateBlocks;
end;

procedure TMultiLayout.FSetPlusHeight(A: single);
begin
  FPlusheight := A;
  self.ReCalcBlocksSize;
end;

function TMultiLayout.FGetBlockCount:Cardinal;
begin
  Result := blocks.Count;
end;

procedure TMultiLayout.FSetBlockCount(A: cardinal);
var
  I: integer;
  cntrls: TcontrolList;
begin
  if A = self.blockCount then exit;

  cntrls := GetControls;
  if cntrls.Count > 0 then begin
    for i := 0 to cntrls.Count - 1 do begin
      cntrls.Items[i].Parent := nil;
    end;
  end;

  if blockcount > 0 then begin
    for i := 0 to blocks.Count - 1 do begin
      blocks.Items[i].Free;
    end;
  end;
  blocks.Clear;

  for i := 1 to A do begin
    self.FAddBlock;
  end;

  if cntrls.Count > 0 then begin
    for i := 0 to cntrls.Count - 1 do begin
      self.AddControl(cntrls.Items[i]);
    end;
  end;

  self.FBlockPos := 0;
  self.UpdateBlocks;
  Cntrls.Free;
end;

function TMultiLayout.FAddBlock:Tlayout;
var
  L: Tlayout;
  block: Tcontrol;
  Pos: single;
begin
  if blocks.Count > 0 then begin
    block := blocks.Last;
    Pos := block.Position.X + block.Width;
  end else
    pos := 0;

  L := tlayout.Create(self);
  L.Parent := self;
  L.Position.Y := 0;
  L.Position.X := Pos;

  Result := L;
  Blocks.Add(L);
end;

destructor TMultiLayout.Destroy;
begin
  //_freeControls(self.Controls);
  blocks.Free;
  inherited Destroy;
end;

procedure TMultiLayout.Resize;
begin
  self.UpdateBlocks;
  UpdateItemHeight;
  self.ReCalcBlocksSize;
end;

constructor TMultiLayoutScroller.Create(Aowner:Tcomponent);
begin
  inherited create(Aowner);
  MultiLayout := tmultilayout.Create(Self);
  MultiLayout.Parent := self;
  Multilayout.Align := Talignlayout.Top;
end;


procedure TMultiLayoutScroller.FSetLayoutIndent(A:single);
begin
  self.MultiLayout.LayoutIndent := A;
end;

function TMultiLayoutScroller.FGetLayoutIndent:Single;
begin
  Result := self.MultiLayout.LayoutIndent;
end;

destructor TMultiLayoutScroller.destroy;
begin
  Multilayout.Free;
  inherited destroy;
end;

end.

unit NsfwBox.GarbageCollector;

interface
uses
  Classes, System.SysUtils, System.Types, System.Threading,
  System.SyncObjs, System.Generics.Collections,
  FMX.Controls, System.Diagnostics,
  { NsfwBox -------------- }
  NsfwBox.Logging, NsfwBox.Graphics.Browser, NsfwBox.Graphics,
  NsfwBox.Graphics.Rectangle,
  { you-did-well --------- }
  YDW.Threading, YDW.FMX.ImageWithURL, YDW.FMX.ImageWithURL.Interfaces,
  YDW.FMX.ImageWithURLManager;

type

  TGarbageCollector = Class(TYdwReusableThread)
    private
      { The list of items that have IWUs. Clear it only when FWaitListIWU count is zero }
      FWaitList: TThreadList<TObject>;
      { The list of items that canceled, but still working. }
      FWaitListIWU: TThreadList<IImageWithUrl>;
      { Objects that straight away going to the FinalStation. }
      GarbageList: TThreadList<TObject>;
      { The list of all items that ready to be destroyed without waiting for any thread. }
      FFinalStation: TObjectList<TObject>;
      function TryAddIWU(AValue: TObject): boolean; overload;
      function TryAddIWUDeep(AValue: TControlList): boolean; overload;
    protected
      procedure DoSyncFreeGarbage;
      procedure Execute; override;
    public
      procedure Throw(AValue: TObject); { call this from main thread }
      Constructor Create; override;
      Destructor Destroy; override;
  End;

  var BlackHole: TGarbageCollector; { Global garbage collector. }

implementation

{ TGarbageCollector }

constructor TGarbageCollector.Create;
begin
  inherited;
  FWaitList := TThreadList<TObject>.Create;
  FWaitListIWU := TThreadList<IImageWithUrl>.Create;
  FFinalStation := TObjectList<TObject>.Create;
  GarbageList := TThreadList<TObject>.Create;
end;

destructor TGarbageCollector.Destroy;
begin
  inherited;
  GarbageList.Free;
  FWaitList.Free;
  FWaitListIWU.Free;
  FFinalStation.Free;
end;

procedure TGarbageCollector.DoSyncFreeGarbage;
begin
  if FFinalStation.Count > 0 then begin
//    Log('GarbageCollector destroying: ' + FFinalStation.Count.ToString);
    TThread.Synchronize(TThread.Current,
    procedure
    begin
      FFinalStation.Clear;
    end);
  end;
end;

procedure TGarbageCollector.Throw(AValue: TObject);
var
  I, N: integer;
  LToWaitList: boolean;
begin
  if AValue is TControl then begin

    var LControl := AValue as TControl;
    LControl.Parent := Nil;
    LControl.Visible := False;

    LToWaitList := TryAddIWU(LControl);
    if TryAddIWUDeep(LControl.Controls) then
      LToWaitList := True;

    if LToWaitList then
      FWaitList.Add(LControl);
  end;

  if not LToWaitList then
    GarbageList.Add(AValue);
end;

procedure TGarbageCollector.Execute;
var
  I: integer;
begin
  repeat
    try
      var LWaitList := FWaitList.LockList;
      var LIWUList := FWaitListIWU.LockList;
      try

        I := 0;
        while not TThread.CheckTerminated do begin
          if (LIWUList.Count <= I) then Break;
          if LIWUList[I].IsLoadingNow then begin
            LIWUList[I].AbortLoading;
            Inc(I); { shift pos to the next item. }
          end else begin
            LIWUList[I].ImageManager := Nil;
            LIWUList.Delete(I);
          end;
        end;

        { if IWUs list empty then LWaitList can be moved to FinalStation }
        { to free items in the main thead without waiting for IWUs threads. }
        if (LIWUList.Count = 0) and (LWaitList.Count > 0) then begin
//          Log('GarbageCollector moving: ' + LWaitList.Count.ToString);
          For I := 0 to LWaitList.Count - 1 do
            FFinalStation.Add(LWaitList[I]);
          LWaitList.Clear;
        end;

      finally
        FWaitListIWU.UnlockList;
        FWaitList.UnlockList;
      end;

      var LList := GarbageList.LockList;
      try
        for I := 0 to LList.Count - 1 do
          FFinalStation.Add(LList[I]);
        LList.Clear;
      finally
        GarbageList.UnlockList;
      end;

      DoSyncFreeGarbage;

    except
      On E: Exception do Log('GarbageCollector', E);
    end;
  until TThread.Current.CheckTerminated;
end;

function TGarbageCollector.TryAddIWU(AValue: TObject): boolean;
var
  LIWU: IImageWithUrl;
begin
  if Supports(AValue, IImageWithUrl, LIWU) then
  begin
    FWaitListIWU.Add(LIWU);
    Result := True;
  end;
end;

function TGarbageCollector.TryAddIWUDeep(AValue: TControlList): boolean;
var
  I: integer;
begin
  Result := False;
  for I := 0 to AValue.Count - 1 do begin
    if TryAddIWU(AValue[I]) then
      Result := True;
    if TryAddIWUDeep(AValue[I].Controls) then
      Result := True;
  end;
end;

initialization
begin
  BlackHole := TGarbageCollector.Create;
  BlackHole.Start;
end;

finalization
begin
  BlackHole.Destroy;
end;

end.

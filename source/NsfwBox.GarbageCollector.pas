unit NsfwBox.GarbageCollector;

interface
uses
  Classes, System.SysUtils, System.Types, System.Threading,
  System.SyncObjs, System.Generics.Collections,
  FMX.Controls, System.Diagnostics,
  { NsfwBox -------------- }
  NsfwBox.Logging, NsfwBox.Graphics.Browser, NsfwBox.Graphics,
  NsfwBox.Graphics.Rectangle, NsfwBox.Interfaces,
  { you-did-well --------- }
  YDW.Threading, YDW.FMX.ImageWithURL, YDW.FMX.ImageWithURL.Interfaces,
  YDW.FMX.ImageWithURLManager;

type

  TGarbageCollector = Class(TYdwReusableThread)
    private
      FAbortAndWaitList: TThreadList<IAbortableAndWaitable>;
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
      procedure Terminate;
      procedure WaitFor;
      Constructor Create; override;
      Destructor Destroy; override;
  End;

  var BlackHole: TGarbageCollector; { Global garbage collector. }

implementation

{ TGarbageCollector }

constructor TGarbageCollector.Create;
begin
  inherited;
  FAbortAndWaitList := TThreadList<IAbortableAndWaitable>.Create;
  FWaitList := TThreadList<TObject>.Create;
  FWaitListIWU := TThreadList<IImageWithUrl>.Create;
  FFinalStation := TObjectList<TObject>.Create(False);
  GarbageList := TThreadList<TObject>.Create;
end;

destructor TGarbageCollector.Destroy;
begin
  inherited;
  GarbageList.Free;
  FAbortAndWaitList.Free;
  FWaitList.Free;
  FWaitListIWU.Free;
  FFinalStation.Free;
end;

procedure TGarbageCollector.DoSyncFreeGarbage;
begin
  if FFinalStation.Count > 0 then begin
//    Log('GarbageCollector destroying: ' + FFinalStation.Count.ToString);
    try
      TThread.Synchronize(TThread.Current,
      procedure
      var
        I: integer;
        LStr: string;
      begin
        for I := 0 to FFinalStation.Count - 1 do
        begin
          try
            var LObj := FFinalStation[0];
            LStr := FFinalStation[0].ClassName;
            FFinalStation.Delete(0);
            LObj.Free;
          except
            On E: Exception do Log(I.ToString + ') ' + LStr, E);

          end;
        end;
        FFinalStation.Clear;
      end);
    except
      On E: Exception do Log('TGarbageCollector.DoSyncFreeGarbage', E);
    end;
  end;
end;

procedure TGarbageCollector.Terminate;
begin
  inherited Terminate;
end;

procedure TGarbageCollector.Throw(AValue: TObject);
var
  I, N: integer;
  LToWaitList: boolean;
  LAnW: IAbortableAndWaitable;
  LControl: TControl;
begin
  if Supports(AValue, IAbortableAndWaitable, LAnW) then
  begin
    LAnW.AbortExecution;
    FAbortAndWaitList.Add(LAnW);
  end;

  if AValue is TControl then
  begin
    LControl := AValue as TControl;
    LControl.Parent := Nil;
    LControl.Visible := False;

    if not (LControl is TNBoxBrowser) then
    begin
      LToWaitList := TryAddIWU(LControl);
      if TryAddIWUDeep(LControl.Controls) then
        LToWaitList := True;

      if LToWaitList then
        FWaitList.Add(LControl);
    end else
      Exit;

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
      var LAnWList := FAbortAndWaitList.LockList;
      try
        I := 0;
        while not TThread.CheckTerminated do
        begin
          if (LAnWList.Count <= I) then Break;
          var LAnW := LAnWList[I];
          if LAnW.IsExecuting then begin
            LAnW.AbortExecution;
            Inc(I); { shift pos to the next item. }
          end else begin
            FFinalStation.Add(LAnWList[I] as TObject);
            LAnWList.Delete(I);
          end;
        end;
      finally
        FAbortAndWaitList.UnlockList;
      end;

      var LWaitList := FWaitList.LockList;
      var LIWUList := FWaitListIWU.LockList;
      try

        I := 0;
        while not TThread.CheckTerminated do
        begin
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
        if (LIWUList.Count = 0) and (LWaitList.Count > 0) then
        begin
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

    if AValue[I] is TControl then
    begin
      if TryAddIWUDeep(AValue[I].Controls) then
        Result := True;
    end;
  end;
end;

procedure TGarbageCollector.WaitFor;
begin
  inherited WaitFor;
end;

initialization
begin
  BlackHole := TGarbageCollector.Create;
  BlackHole.Start;
end;

finalization
begin
  BlackHole.Free;
end;

end.

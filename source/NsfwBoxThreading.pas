//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxThreading;

interface
uses
  System.SysUtils, System.Generics.Collections,
  IoUtils, System.Classes, system.SyncObjs, System.Threading;

type

  TThreadComponentBase = class(TComponent)
    protected
      FIsWorkNow: boolean;
      FTask: ITask;
      FLock: TCriticalSection;
      function IsWorkingNow: boolean;
      procedure CreateTask;
      procedure StartTask;
      procedure StopTask; virtual;
      procedure WaitTask;
      procedure Execute; virtual; abstract;
    public
      property Lock: TCriticalSection read FLock;
      constructor Create(AOwner: TComponent);
      destructor Destroy; override;
  end;

  TQueuedThreadComponentBase = class(TThreadComponentBase)
    protected const
      DEFAULT_THREADS_COUNT: integer = 4;
    private
      procedure SetThreadsCount(const value: integer);
      function GetThreadsCount: integer;
    protected
      FTasks: TArray<ITask>;
      FThreadsCount: integer;
      function RunningCount: integer;
      { this executes in locked criticalsec }
      function QueueCondition: boolean; virtual; abstract;
      function AutoRestartCondition: boolean; virtual;
      function NewSubTask: ITask; virtual; abstract;
      { !! }
      procedure Execute; override;
    public
      property ThreadsCount: integer read GetThreadsCount write SetThreadsCount;
      constructor Create(AOwner: TComponent);
  end;

implementation
uses unit1;

{ TThreadComponentBase }

constructor TThreadComponentBase.Create(AOwner: TComponent);
begin
  Inherited;
  FLock := TCriticalSection.Create;
  FIsWorkNow := false;
  CreateTask;
end;

procedure TThreadComponentBase.CreateTask;
begin
  FTask := TTask.Create(procedure begin
    Flock.Enter;
    try
      FIsWorkNow := true;
    finally
      FLock.Leave;
    end;
    Self.Execute;
  end);
end;

destructor TThreadComponentBase.Destroy;
begin
  StopTask;
  WaitTask;
  FLock.Free;
  inherited;
end;

function TThreadComponentBase.IsWorkingNow: boolean;
begin
  FLock.Enter;
  try
    Result := Assigned(FTask) and FIsWorkNow;
  finally
    FLock.Leave;
  end;
//  Result := Assigned(FTask)
//        And ( FTask.Status <> TTaskStatus.Completed )
//        And ( FTask.Status <> TTaskStatus.Canceled )
//        And ( FTask.Status <> TTaskStatus.Created );
end;

procedure TThreadComponentBase.StartTask;
begin
  //if not Assigned(FTask) then
  CreateTask;
  FTask.Start;
end;

procedure TThreadComponentBase.StopTask;
begin
  if IsWorkingNow then
    FTask.Cancel;
end;

procedure TThreadComponentBase.WaitTask;
begin
//  if IsWorkingNow then begin
//    if ( TThread.Current.ThreadID = MainThreadId ) then begin
//      try
//        while not TTask.WaitForAll([FTask], 100) do
//          CheckSynchronize(10);
//      except
//
//      end;
//    end;
//  end;
  while IsWorkingNow do begin
    if ( TThread.Current.ThreadID = MainThreadId ) then
      CheckSynchronize(10)
    else
      Sleep(10);
  end;
end;

{ TQueuedThreadComponentBase }

function TQueuedThreadComponentBase.AutoRestartCondition: boolean;
begin
  Result := ( Self.QueueCondition )
        and ( TTask.CurrentTask.Status <> TTaskStatus.Canceled );
end;

constructor TQueuedThreadComponentBase.Create(AOwner: TComponent);
begin
  Inherited;
  FTasks := [];
  FThreadsCount := DEFAULT_THREADS_COUNT;
end;

procedure TQueuedThreadComponentBase.Execute;
const
  MICRO_SLEEP_TIME = 10;
var
  I: integer;
  LNewTask: ITask;
begin
  try
    try

      while ( TRUE ) do begin

        TTask.CurrentTask.CheckCanceled;

        While ( RunningCount >= Self.ThreadsCount ) do begin
          TTask.CurrentTask.CheckCanceled;
          Sleep(MICRO_SLEEP_TIME);
        end;

        FLock.Enter;
        try
          if ( not Self.QueueCondition ) then
            break;

          LNewTask := NewSubTask;
          FTasks := FTasks + [LNewTask];
          LNewTask.Start;
        finally
          FLock.Leave;
        end;

      end;

      // waiting for end
      while ( RunningCount > 0 ) do begin
        TTask.CurrentTask.CheckCanceled;
        sleep(MICRO_SLEEP_TIME);
      end;

    finally
      try
      // Cancel all tasks
      for I := 0 to High(FTasks) do begin
        FTasks[I].Cancel;
      end;

      FLock.Enter;
      try
        if Self.AutoRestartCondition then
          Self.StartTask;
      finally
        FIsWorkNow := false;
        FLock.Leave;
      end;
      except
      On E: Exception do begin
        SyncLog(E, 'QueuedThread finally except: ');
      end;
  end;
    end;
  except

    On E: EOperationCancelled do begin
      // ignore
    end;

    on E: Exception do begin
      SyncLog(E, 'QueuedThread: ');
    end;

  end;
end;

function TQueuedThreadComponentBase.GetThreadsCount: integer;
begin
  FLock.Enter;
  try
    Result := FThreadsCount;
  finally
    FLock.Leave;
  end;
end;

function TQueuedThreadComponentBase.RunningCount: integer;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to high(FTasks) do begin
    if  (FTasks[I].Status <> TTaskStatus.Completed)
    and (FTasks[I].Status <> TTaskStatus.Canceled)
    then
      Inc(Result);
  end;
end;

procedure TQueuedThreadComponentBase.SetThreadsCount(const value: integer);
begin
  FLock.Enter;
  try
    FThreadsCount := value;
  finally
    FLock.Leave;
  end;
end;

end.

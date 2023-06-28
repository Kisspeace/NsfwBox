unit NsfwBox.Cache;

interface
uses
  System.SysUtils, System.Types, System.Classes,
  System.Variants, System.Threading, System.IOUtils,
  System.Hash, System.Generics.Collections,
  YDW.Threading, NsfwBox.Logging, NsfwBox.Interfaces,
  NsfwBox.Bookmarks, NsfwBox.Utils, NsfwBox.Provider.Fapello;

type

  IKeyValueStorage<TKey, TValue> = Interface
    ['{6FC83D25-7F63-4A27-A825-74849C35B4CC}']
    { Public }
      function Contains(const AKey: TKey): boolean;
      procedure SetValue(const AKey: TKey; AValue: TValue);
      function GetValue(const AKey: TKey): TValue;
  End;

  { Generic file system cache }
  { Thread safe }
  TGenericFSCache<TKey, TValue> = Class(TComponent, IKeyValueStorage<TKey, TValue>)
    protected
      FLock: TMREWSync;
      FStoragePath: string;
      procedure SetStoragePath(const AValue: string);
      function GetStoragePath: string;
      function GetFilenameByKey(const AKey: TKey): string; virtual; abstract;
      procedure ValueSaveToFile(const AFilename: string; const AValue: TValue); virtual; abstract;
      function ValueLoadFromFile(const AFilename: string): TValue; virtual; abstract;
    public
      property StoragePath: string read GetStoragePath write SetStoragePath;
      function Contains(const AKey: TKey): boolean;
      procedure SetValue(const AKey: TKey; AValue: TValue); virtual;
      function GetValue(const AKey: TKey): TValue; virtual;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  End;

  TFetchedItemsCache = Class(TGenericFSCache<INBoxItem, INBoxItem>)
    protected
      function GetFilenameByKey(const AKey: INBoxItem): string; override;
      procedure ValueSaveToFile(const AFilename: string; const AValue: INBoxItem); override;
      function ValueLoadFromFile(const AFilename: string): INBoxItem; override;
    public
      procedure Save(AItem: INBoxItem; AReplaceIfExist: boolean = False); overload;
      function UpdateWithCached(AItem: INBoxItem): boolean;
  End;

implementation

{ TGenericFSCache<TKey, TValue> }

function TGenericFSCache<TKey, TValue>.Contains(const AKey: TKey): boolean;
begin
  Result := FileExists(GetFilenameByKey(AKey));
end;

constructor TGenericFSCache<TKey, TValue>.Create(AOwner: TComponent);
begin
  inherited;
  FLock := TMREWSync.Create;
end;

destructor TGenericFSCache<TKey, TValue>.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TGenericFSCache<TKey, TValue>.GetStoragePath: string;
begin
  FLock.BeginRead;
  try
    Result := FStoragePath;
  finally
    FLock.EndRead;
  end;
end;

function TGenericFSCache<TKey, TValue>.GetValue(const AKey: TKey): TValue;
begin
  FLock.BeginRead;
  try
    try
      Result := ValueLoadFromFile(GetFilenameByKey(AKey));
    except
      On E: Exception do
        Log('TGenericFSCache.GetValue', E);
    end;
  finally
    FLock.EndRead;
  end;
end;

procedure TGenericFSCache<TKey, TValue>.SetStoragePath(const AValue: string);
begin
  FLock.BeginWrite;
  try
    FStoragePath := AValue;
    if not DirectoryExists(FStoragePath) then
      TDirectory.CreateDirectory(FStoragePath);
  finally
    FLock.EndWrite;
  end;
end;

procedure TGenericFSCache<TKey, TValue>.SetValue(const AKey: TKey;
  AValue: TValue);
begin
  FLock.BeginWrite;
  try
    try
      ValueSaveToFile(GetFilenameByKey(AKey), AValue);
    except
      On E: Exception do
        Log('TGenericFSCache.SetValue', E);
    end;
  finally
    FLock.EndWrite;
  end;
end;

{ TFetchedItemsCache }

function TFetchedItemsCache.GetFilenameByKey(const AKey: INBoxItem): string;
const
  FILE_EXT: string = '.json';
var
  LId: IUIdAsInt;
  LIdS: IUIdAsStr;
begin
  Result := AKey.Origin.ToString;
  if Supports(AKey, IUIdAsInt, LId) then
    Result := Result + '-id' + LId.UIdInt.ToString
  else if Supports(AKey, IUIdAsStr, LIdS) then
    Result := Result + '-id' + LIdS.UIdStr
  else if (AKey is TNBoxFapelloItem) then
  begin
    var LKey: TNBoxFapelloItem := (AKey as TNBoxFapelloItem);
    Result := Result + '-id'
      + System.Hash.THashMD5.GetHashString(LKey.ThumbItem.FullPageUrl);
  end;

  Result := TPath.ChangeExtension(Result, FILE_EXT);
  Result := TPath.Combine(FStoragePath, Result);
end;

procedure TFetchedItemsCache.Save(AItem: INBoxItem; AReplaceIfExist: boolean);
begin
  if AReplaceIfExist or (not Contains(AItem)) then
    SetValue(AItem, AItem)
end;

function TFetchedItemsCache.UpdateWithCached(AItem: INBoxItem): boolean;
var
  LCachedItem: INBoxItem;
begin
  Result := Contains(AItem);
  if Result then
  begin
    LCachedItem := GetValue(AItem);
    try
      AItem.Assign(LCachedItem);
    finally
      FreeInterfaced(LCachedItem);
    end;
  end;
end;

function TFetchedItemsCache.ValueLoadFromFile(
  const AFilename: string): INBoxItem;
var
  LFile: TStringStream;
begin
  LFile := TStringStream.Create;
  try
    LFile.LoadFromFile(AFilename);
    LFile.Position := 0;
    Result := INBoxItemFromJson(LFile.ReadString(LFile.Size));
  finally
    LFile.Free;
  end;
end;

procedure TFetchedItemsCache.ValueSaveToFile(const AFilename: string;
  const AValue: INBoxItem);
var
  LStr: string;
  LFile: TStringStream;
begin
  LStr := ToJsonStr(AValue as TObject);
  LFile := TStringStream.Create;
  try
    LFile.WriteString(LStr);
    LFile.SaveToFile(AFilename);
  finally
    LFile.Free;
  end;
end;

end.

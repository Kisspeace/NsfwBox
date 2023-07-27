﻿{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Interfaces;

interface

uses
  System.SysUtils, Classes, System.Generics.Collections, XSuperObject,
  BooruScraper.Interfaces, Ninehentaito.APITypes, CoomerParty.Types,
  Fapello.Types, System.SyncObjs, NsfwBox.Settings;

type

  IHasOrigin = interface
    ['{59DFFA49-9CB7-49D0-BAF0-6230CEA2F3D5}']
    { private \ protected }
    function GetOrigin: integer;
    { public }
    property Origin: integer read GetOrigin;
  end;

  IUIdAsInt = interface
    ['{2258085A-60A0-4FB0-B68F-C4D3F44285B1}']
    { private \ protected }
    function GetUidInt: int64;
    { public }
    property UIdInt: int64 read GetUIdInt;
  end;

  IUIdAsStr = interface
    ['{ED700226-7A55-4A06-81A1-13DF2CC3EF8B}']
    { private \ protected }
    function GetUidStr: string;
    { public }
    property UIdStr: string read GetUIdStr;
  end;

  INBoxItemTag = interface
    ['{461DACE2-B4A1-4DB4-925F-C7B16F06CF75}']
    { private \ protected }
    function GetValue: string;
    { public }
    property Value: string read GetValue;
  end;

  INBoxItemTagGeneric<T> = interface(INBoxItemTag)
    ['{55A4C160-BCA1-41F4-AD90-7D014DE7D3BD}']
    { private \ protected }
    function GetTag: T;
    { public }
    property Tag: T read GetTag;
  end;

  INBoxItemTagBooru = interface(INBoxItemTagGeneric<IBooruTag>)
    ['{36D76E9D-D237-4CB8-89A4-F6106F7080AE}']
  end;

  INBoxItemTag9HentaiTo = interface(INBoxItemTagGeneric<T9HentaiTag>)
    ['{2216B559-84B4-4D1B-8675-78D250BF2F7D}']
  end;

  TNBoxItemTagAr = TArray<INBoxItemTag>;

  IHasTags = interface
    ['{598FEFF0-4DAD-425D-9480-4B78EA3B98FE}']
    { private \ protected }
    function GetTags: TNBoxItemTagAr;
    { public }
    property Tags: TNBoxItemTagAr read GetTags;
  end;

  IChangeableHost = Interface
    ['{052BA67F-FC58-4423-ABFD-F538ACE94517}']
    { private \ protected }
    procedure SetServiceHost(const Value: string);
    function GetServiceHost: string;
    { public }
    property ServiceHost: string read GetServiceHost write SetServiceHost;
  End;

  INBoxItemArtist = interface
    ['{076240E9-6DFD-4567-9FBC-0BE73E74A419}']
    { privite \ protected }
    function GetDisplayName: string;
    function GetAvatarUrl: string;
    function GetContentCount: integer;
    { public }
    property DisplayName: string read GetDisplayName;
    property AvatarUrl: string read GetAvatarUrl;
    property ContentCount: integer read GetContentCount;
  end;

  INBoxItemArtistGeneric<T> = interface(INBoxItemArtist)
    ['{4AAC263B-1BA5-4F11-88B7-5337F04E067C}']
    { privite \ protected }
    function GetArtist: T;
    { public }
    property Artist: T read GetArtist;
  end;

  INBoxItemArtistCoomerParty = interface(INBoxItemArtistGeneric<TPartyArtist>)
    ['{757AC0B0-7FEE-4138-8DAD-2824C16C59E1}']
  end;

  INBoxItemArtistFapello = interface(INBoxItemArtistGeneric<TFapelloAuthor>)
    ['{95518658-B53F-468F-8FF7-53B81020A425}']
  end;

  INBoxItemArtistBooru = interface(INBoxItemArtistGeneric<IBooruTag>)
    ['{46F2C3D6-46B2-47CA-B06A-9EDA7891C773}']
  end;

  TNBoxItemArtisAr = TArray<INBoxItemArtist>;

  IHasArtists = interface
    ['{6DD3C056-7BB6-4022-8AB4-217B2CB4777B}']
    { private \ protected }
    function GetArtists: TNBoxItemArtisAr;
    { public }
    property Artists: TNBoxItemArtisAr read GetArtists;
  end;

  IHasCaption = interface
    ['{75A5AF4D-D3F4-4919-A742-37684522013C}']
    { private \ protected }
    function GetCaption: string;
    { public }
    property Caption: string read GetCaption;
  end;

  IFetchableContent = interface
    ['{F3D17945-B4EB-471D-8ACA-3BB30EE25C35}']
    { private \ protected }
    function GetContentFetched: boolean;
    { public }
    property ContentFetched: boolean read GetContentFetched;
  end;

  IFetchableTags = interface
    ['{E90EDD2F-348D-4765-9F8F-C6748AF555BF}']
    { private \ protected }
    function GetTagsFetched: boolean;
    { public }
    property TagsFetched: boolean read GetTagsFetched;
  end;

  IFetchableAuthors = interface
    ['{8CBBE794-58F3-4A64-8CE7-B85E86B69F77}']
    { public }
    function IsAuthorsFetched: boolean;
  end;

  INBoxItem = interface(IHasOrigin)
    ['{8AB3F5DB-4DD1-4CD7-BD1C-EE6D35F98270}']
    { private \ protected }
    function GetContentUrls: TArray<string>; overload;
    function GetThumbnailUrl: string;
    procedure Assign(ASource: INBoxItem);
    function Clone: INBoxItem;
    { public }
    procedure SetProviderId(const AProviderId: integer);
    function ContentUrlCount: integer;
    function ContentUrl: string;
    function GetContentUrls(ASelectFilesMode: TDownloadAllMode): TArray<string>; overload;
    property ThumbnailUrl: string read GetThumbnailUrl; // write SetThumbnailUrl;
    property ContentUrls: TArray<string> read GetContentUrls; // write SetContentUrls;
  end;

  INBoxItemList = TList<INBoxItem>;
  INBoxHasOriginList = TList<IHasOrigin>;

  {$IFDEF COUNT_APP_OBJECTS}
  TRefCounter = Class(TObject)
    private
      FCount: integer;
      function GetCount: integer;
    public
      procedure Inc;
      Procedure Dec;
      property Count: integer read GetCount;
      constructor Create;
  End;
  {$ENDIF}

  TNBoxItemBase = class(TNoRefCountObject, INBoxItem, IHasOrigin)
    protected
      FOrigin: Integer;
      function GetContentUrls: TArray<string>; overload; virtual; abstract;
      function GetThumbnailUrl: string; virtual; abstract;
      function GetOrigin: integer; virtual;
      procedure SetOrigin(const Value: integer); { for XSuperObject }
    public
      procedure SetProviderId(const AProviderId: integer);
      function ContentUrlCount: integer; virtual;
      function ContentUrl: string; virtual;
      function GetContentUrls(ASelectFilesMode: TDownloadAllMode): TArray<string>; overload; virtual;
      procedure Assign(ASource: INBoxItem); virtual; abstract;
      function Clone: INBoxItem; virtual; abstract;
      [DISABLE] property Origin: integer Read GetOrigin write SetOrigin;
      [DISABLE] property ThumbnailUrl: string read GetThumbnailUrl;
      [DISABLE] property ContentUrls: TArray<string> read GetContentUrls;
      constructor Create; virtual;
      destructor Destroy; override;
  end;

  TNBoxItemBaseClass = Class of TNBoxItemBase;

  INBoxSearchRequest = interface(IHasOrigin)
    ['{E4BFD2A5-6D0C-450C-A2F8-F43EE36EB998}']
    { private \ protected }
    function GetRequest: string;
    procedure SetRequest(const Value: string);
    function GetPageId: integer;
    procedure SetPageId(const Value: integer);
    function Clone: INBoxSearchRequest;
    { public }
    procedure SetProviderId(const AProviderId: integer);
    property Request: string read GetRequest write SetRequest;
    property PageId: integer read GetPageId write SetPageId;
  end;

  TNBoxSearchRequestBase = class(TNoRefCountObject, INBoxSearchRequest, IHasOrigin)
    protected
      FOrigin: integer;
      FRequest: string;
      FPageId: integer;
      function GetOrigin: integer;
      function GetRequest: string;               virtual;
      procedure SetRequest(const Value: string); virtual;
      function GetPageId: integer;               virtual;
      procedure SetPageId(const Value: integer); virtual;
      procedure SetOrigin(const Value: integer); virtual;
    public
      procedure SetProviderId(const AProviderId: integer);
      function Clone: INBoxSearchRequest;        virtual; abstract;
      property Origin: integer read GetOrigin write SetOrigin;
      [DISABLE] property Request: string read GetRequest write SetRequest;
      [DISABLE] property PageId: integer read GetPageId write SetPageId;
      constructor Create; overload; virtual;
      Destructor Destroy; override;
  end;

  TNBoxSearchRequestBaseClass = Class of TNBoxSearchRequestBase;

  TNBoxItemTagBase = Class(TInterfacedObject, INBoxItemTag)
    protected
      FValue: string;
      function GetValue: string;
    public
      property Value: string read GetValue;
      Constructor Create(AValue: string);
      class function Convert(ATags: TArray<string>): TNBoxItemTagAr; static;
  End;

  TNBoxItemArtistBase = Class(TInterfacedObject, INBoxItemArtist)
    protected
      FDisplayName: string;
      FAvatarUrl: string;
      FContentCount: integer;
      function GetDisplayName: string;
      function GetAvatarUrl: string;
      function GetContentCount: integer;
    public
      property DisplayName: string read GetDisplayName;
      property AvatarUrl: string read GetAvatarUrl;
      property ContentCount: integer read GetContentCount;
      constructor Create(ADisplayName: string; AAvatarUrl: string; AContentCount: integer = -1);
  End;

  IAbortableAndWaitable = Interface
    ['{40FFEE8F-AEA6-4D35-BCEA-552315054444}']
    { public }
    function IsExecuting: boolean; { must be thread safe }
    procedure AbortExecution; { must be thread safe }
    procedure WaitFor; { must be thread safe }
  End;

{$IFDEF COUNT_APP_OBJECTS}
var
  BaseItemCounter: TRefCounter;
  BookmarkItemCounter: TRefCounter;
  ReqItemCounter: TRefCounter;
  CardCounter: TRefCounter;
{$ENDIF}

implementation

{ TNBoxSearchRequestBase }

constructor TNBoxSearchRequestBase.Create;
begin
  {$IFDEF COUNT_APP_OBJECTS} ReqItemCounter.Inc; {$ENDIF}
  PageId := 1;
  Request := '';
end;

destructor TNBoxSearchRequestBase.Destroy;
begin
  {$IFDEF COUNT_APP_OBJECTS} ReqItemCounter.Dec; {$ENDIF}
  inherited;
end;

function TNBoxSearchRequestBase.GetOrigin: integer;
begin
  Result := FOrigin;
end;

function TNBoxSearchRequestBase.GetPageId: integer;
begin
  Result := FPageId;
end;

function TNBoxSearchRequestBase.GetRequest: string;
begin
  Result := FRequest;
end;

procedure TNBoxSearchRequestBase.SetOrigin(const Value: integer);
begin

end;

procedure TNBoxSearchRequestBase.SetPageId(const Value: integer);
begin
  FPageId := Value;
end;

procedure TNBoxSearchRequestBase.SetProviderId(const AProviderId: integer);
begin
  FOrigin := AProviderId;
end;

procedure TNBoxSearchRequestBase.SetRequest(const Value: string);
begin
  FRequest := Value;
end;

{ TNBoxItemBase }

function TNBoxItemBase.ContentUrl: string;
begin
  if ( ContentUrlCount > 0 ) then
    Result := ContentUrls[0]
  else
    Result := '';
end;

function TNBoxItemBase.ContentUrlCount: integer;
begin
  Result := Length(ContentUrls);
end;

function TNBoxItemBase.GetContentUrls(
  ASelectFilesMode: TDownloadAllMode): TArray<string>;
begin
  Result := ContentUrls;
end;

constructor TNBoxItemBase.Create;
begin
  inherited;
  {$IFDEF COUNT_APP_OBJECTS} BaseItemCounter.Inc; {$ENDIF}
end;

destructor TNBoxItemBase.Destroy;
begin
  {$IFDEF COUNT_APP_OBJECTS} BaseItemCounter.Dec; {$ENDIF}
  inherited;
end;

function TNBoxItemBase.GetOrigin: integer;
begin
  Result := FOrigin;
end;

procedure TNBoxItemBase.SetOrigin(const Value: integer);
begin

end;

procedure TNBoxItemBase.SetProviderId(const AProviderId: integer);
begin
  FOrigin := AProviderId;
end;

{ TNBoxItemTagBase }

class function TNBoxItemTagBase.Convert(ATags: TArray<string>): TNBoxItemTagAr;
var
  I: integer;
begin
  SetLength(Result, Length(ATags));
  for I := 0 to High(ATags) do
    Result[I] := TNBoxItemTagBase.Create(ATags[I]);
end;

constructor TNBoxItemTagBase.Create(AValue: string);
begin
  FValue := AValue;
end;

function TNBoxItemTagBase.GetValue: string;
begin
  Result := FValue;
end;

{ TNBoxItemArtistBase }

constructor TNBoxItemArtistBase.Create(ADisplayName, AAvatarUrl: string;
  AContentCount: integer);
begin
  FDisplayName := ADisplayName;
  FAvatarUrl := AAvatarUrl;
  FContentCount := AContentCount;
end;

function TNBoxItemArtistBase.GetAvatarUrl: string;
begin
  Result := FAvatarUrl;
end;

function TNBoxItemArtistBase.GetContentCount: integer;
begin
  Result := FContentCount;
end;

function TNBoxItemArtistBase.GetDisplayName: string;
begin
  Result := FDisplayName;
end;

{$IFDEF COUNT_APP_OBJECTS}
{ TRefCounter }

constructor TRefCounter.Create;
begin
  FCount := 0;
end;

procedure TRefCounter.Dec;
begin
  TMonitor.Enter(Self);
  try
    FCount := FCount - 1;
  finally
    TMonitor.Exit(Self);
  end;
end;

function TRefCounter.GetCount: integer;
begin
  TMonitor.Enter(Self);
  try
    Result := FCount;
  finally
    TMonitor.Exit(Self);
  end;
end;

procedure TRefCounter.Inc;
begin
  TMonitor.Enter(Self);
  try
    FCount := FCount + 1;
  finally
    TMonitor.Exit(Self);
  end;
end;

initialization
begin
  BaseItemCounter := TRefCounter.Create;
  BookmarkItemCounter := TRefCounter.Create;
  ReqItemCounter := TRefCounter.Create;
  CardCounter := TRefCounter.Create;
end;
{$ENDIF}

end.

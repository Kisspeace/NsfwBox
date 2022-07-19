//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBoxInterfaces;

interface

uses
  System.SysUtils, Classes, System.Generics.Collections, XSuperObject;

type
{*
  IBeautyTemplate = interface

    //--Setters and Getters--//

    //--Properties--//

  end;
*}

  IHasOrigin = interface
    ['{59DFFA49-9CB7-49D0-BAF0-6230CEA2F3D5}']
    //--Setters and Getters--//
    function GetOrigin: integer;
    //--Properties--//
    property Origin: integer read GetOrigin;
  end;

  IUIdAsInt = interface
    ['{2258085A-60A0-4FB0-B68F-C4D3F44285B1}']
    //--Setters and Getters--//
    procedure SetUidInt(const value: int64);
    function GetUidInt: int64;
    //--Properties--//
    property UIdInt: int64 read GetUIdInt write SetUIdInt;
  end;

  IHasTags = interface
    ['{598FEFF0-4DAD-425D-9480-4B78EA3B98FE}']
    //--Setters and Getters--//
    procedure SetTags(const Value: TArray<string>);
    function GetTags: TArray<string>;
    //--Properties--//
    property Tags: TArray<string> read GetTags write SetTags;
  end;

  IHasAuthor = interface
    ['{6DD3C056-7BB6-4022-8AB4-217B2CB4777B}']
    //--Setters and Getters--//
    function GetAuthorName: string;
    procedure SetAuthorName(const Value: string);
    //--Properties--//
    property AuthorName: string read GetAuthorName write SetAuthorName;
  end;

  IHasCaption = interface
    ['{75A5AF4D-D3F4-4919-A742-37684522013C}']
    //--Setters and Getters--//
    procedure SetCaption(const Value: String);
    function GetCaption: string;
    //--Properties--//
    property Caption: string read GetCaption write SetCaption;
  end;

  IFetchableContent = interface
    ['{F3D17945-B4EB-471D-8ACA-3BB30EE25C35}']
    //--Setters and Getters--//
    function GetContentFetched: boolean;
    //--Properties--//
    property ContentFetched: boolean read GetContentFetched;
  end;

  IFetchableTags = interface
    ['{E90EDD2F-348D-4765-9F8F-C6748AF555BF}']
    //--Setters and Getters--//
    function GetTagsFetched: boolean;
    //--Properties--//
    property TagsFetched: boolean read GetTagsFetched;
  end;

  INBoxItem = interface(IHasOrigin)
    ['{8AB3F5DB-4DD1-4CD7-BD1C-EE6D35F98270}']
    //--Setters and Getters--//
    procedure SetContentUrls(const Value: TArray<string>);
    function GetContentUrls: TArray<string>;
    procedure SetThumbnailUrl(const Value: string);
    function GetThumbnailUrl: string;
    procedure Assign(ASource: INBoxItem);
    function Clone: INBoxItem;
    //--Public methods--//
    function ContentUrlCount: integer;
    function ContentUrl: string;
    //--Properties--//
    property ThumbnailUrl: string read GetThumbnailUrl write SetThumbnailUrl;
    property ContentUrls: TArray<string> read GetContentUrls write SetContentUrls;
  end;

  INBoxItemList = TList<INBoxItem>;
  INBoxHasOriginList = TList<IHasOrigin>;

  TNBoxItemBase = class(TInterfacedPersistent, INBoxItem, IHasOrigin)
    protected
      FOrigin: Integer;
      procedure SetContentUrls(const Value: TArray<string>);  virtual; abstract;
      function GetContentUrls: TArray<string>;                virtual; abstract;
      procedure SetThumbnailUrl(const Value: string);         virtual; abstract;
      function GetThumbnailUrl: string;                       virtual; abstract;
      function GetOrigin: integer;                            virtual;
      procedure SetOrigin(const Value: integer);              virtual;
    public
      function ContentUrlCount: integer;                      virtual;
      function ContentUrl: string;                            virtual;
      procedure Assign(ASource: INBoxItem);                   virtual; abstract;
      function Clone: INBoxItem;                              virtual; abstract;
      [DISABLE] property Origin: integer Read GetOrigin write SetOrigin;
      [DISABLE] property ThumbnailUrl: string read GetThumbnailUrl write SetThumbnailUrl;
      [DISABLE] property ContentUrls: TArray<string> read GetContentUrls write SetContentUrls;
  end;

  INBoxSearchRequest = interface(IHasOrigin)
    ['{E4BFD2A5-6D0C-450C-A2F8-F43EE36EB998}']
    //--Setters and Getters--//
    function GetRequest: string;
    procedure SetRequest(const Value: string);
    function GetPageId: integer;
    procedure SetPageId(const Value: integer);
    function Clone: INBoxSearchRequest;
    //--Properties--//
    property Request: string read GetRequest write SetRequest;
    property PageId: integer read GetPageId write SetPageId;
  end;

  TNBoxSearchRequestBase = class(TInterfacedPersistent, INBoxSearchRequest, IHasOrigin)
    protected
      FRequest: string;
      FPageId: integer;
      //--Setters and Getters--//
      function GetOrigin: integer;               virtual; abstract;
      function GetRequest: string;
      procedure SetRequest(const Value: string); virtual;
      function GetPageId: integer;               virtual;
      procedure SetPageId(const Value: integer); virtual;
      procedure SetOrigin(const Value: integer); virtual;
    public
      function Clone: INBoxSearchRequest;        virtual; abstract;
      //--Properties--//
      property Origin: integer read GetOrigin write SetOrigin;
      [DISABLE] property Request: string read GetRequest write SetRequest;
      [DISABLE] property PageId: integer read GetPageId write SetPageId;
      constructor Create; virtual;
  end;

implementation

{ TNBoxSearchRequestBase }

constructor TNBoxSearchRequestBase.Create;
begin
  PageId := 1;
  Request := '';
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

procedure TNBoxSearchRequestBase.SetRequest(const Value: string);
begin
  FRequest := Value;
end;

{ TNBoxItemBase }

function TNBoxItemBase.ContentUrl: string;
begin
  if ContentUrlCount > 0 then
    Result := ContentUrls[0];
end;

function TNBoxItemBase.ContentUrlCount: integer;
begin
  Result := Length(ContentUrls);
end;

function TNBoxItemBase.GetOrigin: integer;
begin
  Result := FOrigin;
end;

procedure TNBoxItemBase.SetOrigin(const Value: integer);
begin
  //FOrigin := Value;
end;


end.

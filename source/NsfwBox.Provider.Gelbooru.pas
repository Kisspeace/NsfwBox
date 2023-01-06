﻿{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.Gelbooru;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  BooruScraper.Interfaces, BooruScraper.BaseTypes,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwBox.Utils;

type

  TNBoxBooruItemBase = class(TNBoxItemBase,
   IHasAuthor, IHasTags, IFetchableTags, IFetchableContent, IFetchableAuthors)
    private
      FThumbItem: IBooruThumb;
      FFull: IBooruPost;
      function GetContentUrls: TArray<string>; override;
      function GetThumbnailUrl: string; override;
      function GetAuthorName: string;
      function GetContentFetched: boolean;
      function GetTagsFetched: boolean;
      function GetTags: TArray<string>;
      procedure SetThumbItem(const value: IBooruThumb); virtual;
      function GetThumbItem: IBooruThumb; virtual;
      procedure SetFull(const value: IBooruPost); virtual;
      function GetFull: IBooruPost; virtual;
    public
      function IsAuthorsFetched: boolean;
      procedure Assign(ASource: INBoxItem); override;
      //--New--//
      [DISABLE] property ThumbItem: IBooruThumb read GetThumbItem write SetThumbItem; { Cant be written correctly by XSuperJson }
      [DISABLE] property Full: IBooruPost read GetFull write SetFull; { Cant be written correctly by XSuperJson }
      //--Properties--//
      property Origin;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property AuthorName: string read GetAuthorName;
      [DISABLE] property Tags: TArray<string> read GetTags;
      [DISABLE] property ContentFetched: boolean read GetContentFetched;
      [DISABLE] property TagsFetched: boolean read GetTagsFetched;
      constructor Create; override;
  end;

  TNBoxBooruItemBaseClass = Class of TNBoxBooruItemBase;

  TNBoxGelbooruItem = class(TNBoxBooruItemBase,
   IHasAuthor, IHasTags, IFetchableTags, IFetchableContent, IFetchableAuthors)
    public
      //--Properties--//
      property Origin;
      { -------------- }
      function Clone: INBoxItem; override;
      constructor Create; override;
  end;

  TNBoxSearchReqGelbooru = class(TNBoxSearchRequestBase)
    protected
      function GetOrigin: integer; override;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request;
      property PageId;
      constructor Create; override;
  end;

implementation

{ TNBoxBooruItemBase }

procedure TNBoxBooruItemBase.Assign(ASource: INBoxItem);
begin
  inherited;
  if (not (ASource is TNBoxBooruItemBase) ) then exit;
  var LSource := ( ASource as TNBoxBooruItemBase );

  Self.ThumbItem := LSource.ThumbItem;
  Self.Full := LSource.Full;
end;

constructor TNBoxBooruItemBase.Create;
begin
  Self.FThumbItem := TBooruThumbBase.Create;
  Self.FFull := TBooruPostBase.Create;
end;

function TNBoxBooruItemBase.GetAuthorName: string;
begin
  if TagsFetched then begin
    var LArtists := Self.Full.GetTagsByType(TBooruTagType.TagArtist);
    if Length(LArtists) > 0 then
      Result := LArtists[0].Value;
  end else
    Result := '';
end;

function TNBoxBooruItemBase.GetContentFetched: boolean;
begin
  Result := (not Self.Full.ContentUrl.IsEmpty);
end;

function TNBoxBooruItemBase.GetContentUrls: TArray<string>;
begin
  if Self.ContentFetched then begin
    Result := [Self.FFull.ContentUrl];
    if Result[0] <> Self.Full.Thumbnail then
      Result := Result + [Self.Full.Thumbnail]; { Sample image }
  end else
    Result := [];
end;

function TNBoxBooruItemBase.GetFull: IBooruPost;
begin
  Result := Self.FFull;
end;

function TNBoxBooruItemBase.GetTags: TArray<string>;
begin
  if TagsFetched then
    Result := Self.Full.TagsValues
  else
    Result := Self.ThumbItem.TagsValues;
end;

function TNBoxBooruItemBase.GetTagsFetched: boolean;
begin
  Result := ContentFetched;
end;

function TNBoxBooruItemBase.GetThumbItem: IBooruThumb;
begin
  Result := Self.FThumbItem;
end;

function TNBoxBooruItemBase.GetThumbnailUrl: string;
begin
  Result := Self.ThumbItem.Thumbnail;
end;

function TNBoxBooruItemBase.IsAuthorsFetched: boolean;
begin
  Result := Self.ContentFetched;
end;

procedure TNBoxBooruItemBase.SetFull(const value: IBooruPost);
begin
  Self.FFull.Assign(value);
end;

procedure TNBoxBooruItemBase.SetThumbItem(const value: IBooruThumb);
begin
  Self.FThumbItem.Assign(value);
end;

{ TNBoxGelbooruItem }

function TNBoxGelbooruItem.Clone: INBoxItem;
begin
  Result := TNBoxGelbooruItem.Create;
  Result.Assign(Self);
end;

constructor TNBoxGelbooruItem.Create;
begin
  inherited;
  Self.FOrigin := PVR_GELBOORU;
end;

{ TNBoxSearchReqGelbooru }

function TNBoxSearchReqGelbooru.Clone: INBoxSearchRequest;
begin
  Result := TNBoxSearchReqGelbooru.Create;
  with Result as TNBoxSearchReqGelbooru do begin
    PageId := self.FPageId;
    Request := Self.FRequest;
  end;
end;

constructor TNBoxSearchReqGelbooru.Create;
begin
  inherited;
  Self.FPageId := PROVIDERS.Gelbooru.FisrtPageId;
end;

function TNBoxSearchReqGelbooru.GetOrigin: integer;
begin
  Result := PROVIDERS.Gelbooru.Id;
end;

end.

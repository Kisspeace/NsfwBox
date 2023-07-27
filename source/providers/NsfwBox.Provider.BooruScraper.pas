﻿{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Provider.BooruScraper;

interface
uses
  System.SysUtils, System.Classes, XSuperObject,
  BooruScraper.Interfaces, BooruScraper.BaseTypes,
  NsfwBox.Interfaces, NsfwBox.Consts, NsfwBox.Utils,
  NsfwBox.Settings, System.Generics.Collections;

type

  TNBoxItemTagBooru = Class(TInterfacedObject, INBoxItemTag, INBoxItemTagBooru)
    protected
      FTag: IBooruTag;
      function GetValue: string;
      procedure SetTag(value: IBooruTag);
      function GetTag: IBooruTag;
    public
      property Tag: IBooruTag read GetTag write SetTag;
      property Value: string read GetValue;
      constructor Create(ATag: IBooruTag);
      class function Convert(ATag: IBooruTag): INBoxItemTag; overload; static;
      class function Convert(ATags: TBooruTagList): TNBoxItemTagAr; overload; static;
  End;

  TNBoxItemArtistBooru = Class(TNBoxItemTagBooru, INBoxItemArtist, INBoxItemArtistBooru)
    protected
      function GetArtist: IBooruTag;
      function GetDisplayName: string;
      function GetAvatarUrl: string;
      function GetContentCount: integer;
    public
      property Artist: IBooruTag read GetArtist;
      property DisplayName: string read GetDisplayName;
      property AvatarUrl: string read GetAvatarUrl;
      property ContentCount: integer read GetContentCount;
  End;

  TNBoxBooruItemBase = class(TNBoxItemBase, IUIdAsInt,
   IHasArtists, IHasTags, IFetchableTags, IFetchableContent, IFetchableAuthors)
    private
      FFull: IBooruPost;
      function GetContentUrls: TArray<string>; override;
      function GetThumbnailUrl: string; override;
      function GetArtists: TNBoxItemArtisAr;
      function GetContentFetched: boolean;
      function GetTagsFetched: boolean;
      function GetTags: TNBoxItemTagAr;
      procedure SetFull(const value: IBooruPost); virtual;
      function GetFull: IBooruPost; virtual;
      function GetUidInt: int64;
    public
      procedure MergeFull(const APost: IBooruPost);
      function IsAuthorsFetched: boolean;
      function Clone: INBoxItem; override;
      procedure Assign(ASource: INBoxItem); override;
      function GetContentUrls(ASelectFilesMode: TDownloadAllMode): TArray<string>; override;
      { new }
      [DISABLE] property Full: IBooruPost read GetFull write SetFull; { Cant be written correctly by XSuperJson }
      { properties }
      property Origin;
      [DISABLE] property ThumbnailUrl;
      [DISABLE] property ContentUrls;
      [DISABLE] property Artists: TNBoxItemArtisAr read GetArtists;
      [DISABLE] property Tags: TNBoxItemTagAr read GetTags;
      [DISABLE] property ContentFetched: boolean read GetContentFetched;
      [DISABLE] property TagsFetched: boolean read GetTagsFetched;
      constructor Create(AOrigin: integer);
  end;

  TNBoxBooruItemBaseClass = Class of TNBoxBooruItemBase;

  TNBoxSearchReqBooru = class(TNBoxSearchRequestBase, IChangeableHost)
    protected
      FServiceHost: string;
      FClientType: TBooruScraperClientType;
      FParserType: TBooruScraperParserType;
      procedure SetServiceHost(const Value: string);
      function GetServiceHost: string;
    public
      function Clone: INBoxSearchRequest; override;
      property Origin;
      property Request;
      property PageId;
      property ServiceHost: string read GetServiceHost write SetServiceHost;
      property ClientType: TBooruScraperClientType read FClientType write FClientType;
      property ParserType: TBooruScraperParserType read FParserType write FParserType;
      constructor Create(AOrigin: integer);
  end;

implementation

{ TNBoxBooruItemBase }

procedure TNBoxBooruItemBase.Assign(ASource: INBoxItem);
begin
  inherited;
  if not (ASource is Self.ClassType) then exit;
  var LSource := ( ASource as TNBoxBooruItemBase );

  Self.Full := LSource.Full;
end;

constructor TNBoxBooruItemBase.Create(AOrigin: integer);
begin
  Inherited Create;
  Self.FOrigin := AOrigin;
  Self.FFull := TBooruPostBase.Create;
end;

function TNBoxBooruItemBase.GetArtists: TNBoxItemArtisAr;
var
  I: integer;
  LArtistTags: TBooruTagAr;
  LTagCopy: IBooruTag;
begin
  if TagsFetched then begin

    LArtistTags := Full.GetTagsByType(TBooruTagType.TagArtist);
    SetLength(Result, Length(LArtistTags));

    for I := 0 to High(Result) do begin
      supports(LArtistTags[I].Clone, IBooruTag, LTagCopy);
      Result[I] := TNBoxItemArtistBooru.Create(LTagCopy);
    end;

  end else
    Result := [];
end;

function TNBoxBooruItemBase.GetContentFetched: boolean;
begin
  Result := (not ((Full.ContentUrl.IsEmpty) and (Full.SampleUrl.IsEmpty)));
end;

function TNBoxBooruItemBase.GetContentUrls(
  ASelectFilesMode: TDownloadAllMode): TArray<string>;
begin
  if ContentFetched then
  begin
    case ASelectFilesMode of
      damAllVersions: Result := ContentUrls;
      damHighResVersion: Result := [FFull.ContentUrl];

      damMediumResVersion:
      begin
        Result := [FFull.SampleUrl];
        if Length(Result) = 0 then
          Result := ContentUrls;
      end;
    end;
  end else
    Result := [];
end;

function TNBoxBooruItemBase.GetContentUrls: TArray<string>;
begin
  if ContentFetched then begin
    if not Full.ContentUrl.IsEmpty then
      Result := [FFull.ContentUrl];

    if (FFull.ContentUrl <> Full.SampleUrl)
    and not (Full.SampleUrl.IsEmpty) then
      Result := Result + [Full.SampleUrl]; { Sample image }
  end else
    Result := [];
end;

function TNBoxBooruItemBase.GetFull: IBooruPost;
begin
  Result := Self.FFull;
end;

function TNBoxBooruItemBase.GetTags: TNBoxItemTagAr;
begin
  Result := TNBoxItemTagBooru.Convert(Self.Full.Tags);
end;

function TNBoxBooruItemBase.GetTagsFetched: boolean;
begin
  Result := ContentFetched;
end;

function TNBoxBooruItemBase.GetThumbnailUrl: string;
begin
  Result := Self.FFull.Thumbnail;
end;

function TNBoxBooruItemBase.GetUidInt: int64;
begin
  Result := FFull.Id;
end;

function TNBoxBooruItemBase.IsAuthorsFetched: boolean;
begin
  Result := Self.ContentFetched;
end;

procedure TNBoxBooruItemBase.MergeFull(const APost: IBooruPost);
begin
  if APost.Thumbnail.IsEmpty then
    APost.Thumbnail := Full.Thumbnail;

  if (APost.Id = BOORU_NOTSET) then
    APost.Id := Full.Id;

  Full := APost;
end;

procedure TNBoxBooruItemBase.SetFull(const value: IBooruPost);
begin
  Self.FFull.Assign(value);
end;


{ TNBoxBooruItem }

function TNBoxBooruItemBase.Clone: INBoxItem;
begin
  Result := TNBoxBooruItemBase.Create(FOrigin);
  Result.Assign(Self);
end;

{ TNBoxSearchReqGelbooru }

function TNBoxSearchReqBooru.Clone: INBoxSearchRequest;
var
  LRes: TNBoxSearchReqBooru;
begin
  LRes := TNBoxSearchReqBooru.Create(FOrigin);
  LRes.PageId := self.FPageId;
  LRes.Request := Self.FRequest;
  LRes.FServiceHost := Self.FServiceHost;
  LRes.FClientType := Self.FClientType;
  LRes.FParserType := Self.FParserType;
  Result := LRes;
end;

constructor TNBoxSearchReqBooru.Create(AOrigin: integer);
begin
  Inherited Create;
  FServicehost := '';
  FClientType := TBooruScraperClientType.bsTGelbooruLikeClient;
  FParserType := TBooruScraperParserType.bsTRule34xxxParser;
  FOrigin := AOrigin;
  Self.FPageId := BooruScraper.Interfaces.BOORU_FIRSTPAGE;
end;

function TNBoxSearchReqBooru.GetServiceHost: string;
begin
  Result := FServiceHost;
end;

procedure TNBoxSearchReqBooru.SetServiceHost(const Value: string);
begin
  FServiceHost := Value;
end;

{ TNBoxItemTagBooru }

class function TNBoxItemTagBooru.Convert(ATags: TBooruTagList): TNBoxItemTagAr;
var
  I: integer;
begin
  SetLength(Result, ATags.Count);
  for I := 0 to ATags.Count - 1 do
    Result[I] := Convert(ATags[I]);
end;

class function TNBoxItemTagBooru.Convert(ATag: IBooruTag): INBoxItemTag;
var
  LTagCopy: IBooruTag;
begin
  supports(ATag.Clone, IBooruTag, LTagCopy);
  Result := TNBoxItemTagBooru.Create(LTagCopy);
end;

constructor TNBoxItemTagBooru.Create(ATag: IBooruTag);
begin
  Tag := ATag;
end;

function TNBoxItemTagBooru.GetTag: IBooruTag;
begin
  Result := FTag;
end;

function TNBoxItemTagBooru.GetValue: string;
begin
  Result := Tag.Value;
end;

procedure TNBoxItemTagBooru.SetTag(value: IBooruTag);
begin
  FTag := value;
end;

{ TNBoxItemArtistBooru }

function TNBoxItemArtistBooru.GetArtist: IBooruTag;
begin
  Result := Tag;
end;

function TNBoxItemArtistBooru.GetAvatarUrl: string;
begin
  Result := '';
end;

function TNBoxItemArtistBooru.GetContentCount: integer;
begin
  Result := Tag.Count;
end;

function TNBoxItemArtistBooru.GetDisplayName: string;
begin
  Result := Value;
end;

end.

//♡2022 by Kisspeace. https://github.com/kisspeace
unit NsfwBox.UpdateChecker;

interface
uses
  System.SysUtils, Classes, System.Net.HttpClient,
  {$IFDEF ANDROID}
  AndroidApi.Helpers,
  AndroidApi.JNI.JavaTypes,
  AndroidApi.JNI.GraphicsContentViewText,
  {$ENDIF}
  System.Net.HttpClientComponent, XSuperObject;

type

  TGithubUser = record
    [ALIAS('login')] Login: string;
    [ALIAS('id')] Id: Uint64;
    [ALIAS('avatar_url')] AvatarUrl: string;
  end;

  TGithubAsset = record
    [ALIAS('id')] Id: Uint64;
    [ALIAS('name')] Name: string;
    //[ALIAS('uploader')] Uploader: TGithubUser;
    [ALIAS('size')] Size: int64;
    [ALIAS('download_count')] DownloadCount: integer;
    [ALIAS('created_at')] CreatedAt: TDateTime;
    [ALIAS('updated_at')] UpdatedAt: TDateTime;
    [ALIAS('browser_download_url')] DownloadUrl: string;
  end;

  TGithubAssetAr = TArray<TGithubAsset>;

  TGithubRelease = record
    [ALIAS('id')] Id: Uint64;
    [ALIAS('author')] Author: TGithubUser;
    [ALIAS('tag_name')] TagName: String;
    [ALIAS('name')] Name: string;
    [ALIAS('created_at')] CreatedAt: TDateTime;
    [ALIAS('updated_at')] UpdatedAt: TDateTime;
    [ALIAS('assets')] Assets: TGithubAssetAr;
    [ALIAS('html_url')] HtmlUrl: string;
    [ALIAS('body')] Body: string;
  end;

  TGithubReleaseAr = TArray<TGithubRelease>;

  TGithubClient = Class(TObject)
    private const
      API_URL: string = 'https://api.github.com';
    public
      WebClient: TNetHttpClient;
      function GetReleases(AAuthor: string; ARepo: string): TGithubReleaseAr;
      constructor Create;
      destructor Destroy;
  End;

  TSemVer = record
    Major: Cardinal;
    Minor: Cardinal;
    Patch: Cardinal;
    function ToString: string;
    function ToGhTagString: string;
    {* Operator Overloading *}
    class operator Equal(a: TSemVer; b: TSemVer): Boolean;
    class operator GreaterThan(a: TSemVer; b: TSemVer): Boolean;
    class operator GreaterThanOrEqual(a: TSemVer; b: TSemVer): Boolean;
    class operator LessThan(a: TSemVer; b: TSemVer): Boolean;
    class operator LessThanOrEqual(a: TSemVer; b: TSemVer): Boolean;
    {* *}
    class function FromString(AString: string): TSemVer; static;
    class function FromGhTagString(AString: string): TSemVer; static;
    constructor Create(AMajor, AMinor, APatch: Cardinal);
  end;

  function GetAppVersion: TSemVer;
  function GetLastRealeaseFromGitHub: TGithubRelease;

implementation

function GetAppVersion: TSemVer;
begin
  {$IFDEF MSWINDOWS}
    GetProductVersion(ParamStr(0),
       Result.Major,
       Result.Minor,
       Result.Patch);
  {$ENDIF} {$IFDEF ANDROID}
    var LPkgInfo: JPackageInfo;
    LPkgInfo := TAndroidHelper.Activity.getPackageManager.getPackageInfo(
      SharedActivity.getPackageName, 0);
    Result := TSemVer.FromString(JStringToString(LPkgInfo.versionName));
  {$ENDIF}
end;

function GetLastRealeaseFromGitHub: TGithubRelease;
var
  Github: TGitHubClient;
  Releases: TGithubReleaseAr;
begin
  Github := TGitHubClient.Create;
  try
    Releases := Github.GetReleases('Kisspeace', 'NsfwBox');
    if ( Length(Releases) > 0 ) then
      Result := Releases[0];
  finally
    Github.Free;
  end;
end;

{ TGithubClient }

constructor TGithubClient.Create;
begin
  WebClient := TNetHttpClient.Create(nil);
  WebClient.AcceptEncoding := 'gzip, deflate';
  WebClient.Accept := '*/*';
  WebClient.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0';
end;

destructor TGithubClient.Destroy;
begin
  WebClient.Free;
end;

function TGithubClient.GetReleases(AAuthor, ARepo: string): TGithubReleaseAr;
var
  Content: string;
begin
  Content := WebClient.Get(API_URL + '/repos/' + AAuthor + '/' + ARepo + '/releases').ContentAsString;
  Result := TJson.Parse<TGithubReleaseAr>(Content);
end;

{ TAppVersion }

constructor TSemVer.Create(AMajor, AMinor, APatch: Cardinal);
begin
  Self.Major := AMajor;
  Self.Minor := AMinor;
  Self.Patch := APatch;
end;


class operator TSemVer.Equal(a, b: TSemVer): Boolean;
begin
  Result := ( a.Major = b.Major )
        and ( a.Minor = b.Minor )
        and ( a.Patch = b.Patch );
end;

class function TSemVer.FromGhTagString(AString: string): TSemVer;
var
  N: integer;
begin
  N := Pos('V', AString.ToUpper);
  Result := TSemVer.FromString(Copy(AString, N + 1, Length(AString)));
end;

class function TSemVer.FromString(AString: string): TSemVer;
var
  N1, N2, L: integer;
begin
  AString := Trim(AString);
  L := Length(AString);
  N1 := Pos('.', AString);
  Result.Major := StrToInt(Copy(AString, Low(AString), N1 - 1));
  N2 := Pos('.', AString, N1 + 1);
  Result.Minor := StrToInt(Copy(AString, (N1 + 1), N2 - (N1 + 1)));
  Result.Patch := StrToInt(Copy(AString, (N2 + 1), L));
end;

class operator TSemVer.GreaterThan(a, b: TSemVer): Boolean;
begin
  Result := false;
  if ( a.Major > b.Major ) then begin
    Result := true;
    exit;
  end else if ( b.Major = a.Major ) and ( a.Minor > b.Minor ) then begin
    Result := true;
    exit;
  end else if ( b.Minor = a.Minor ) and ( a.Patch > b.Patch ) then begin
    Result := true;
    exit;
  end;
end;

class operator TSemVer.GreaterThanOrEqual(a, b: TSemVer): Boolean;
begin
  Result := ( a > b ) or ( a = b );
end;

class operator TSemVer.LessThan(a, b: TSemVer): Boolean;
begin
  Result := ( b > a );
end;

class operator TSemVer.LessThanOrEqual(a, b: TSemVer): Boolean;
begin
  Result := ( a < b ) or ( a = b );
end;

function TSemVer.ToGhTagString: string;
begin
  Result := 'v' + Self.ToString;
end;

function TSemVer.ToString: string;
begin
  Result := Major.ToString + '.' + Minor.ToString + '.' + Patch.ToString;
end;

end.

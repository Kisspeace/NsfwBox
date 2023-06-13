{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.FileSystem;

interface
uses
  Classes, SysUtils, Types, system.IOUtils, system.Hash,
  NsfwBox.Consts;

type

  TNBoxPath = class
    public
      {$IFDEF MSWINDOWS}
      class function GetAppPath: string; static;
      {$ENDIF}
      class function GetCachePath: string; static;
      class function GetAppMainPath: string; static;
      class function GetThemesPath: string; static;
      class function GetThumbnailsPath: string; static;
      class function GetFetchedItemsCachePath: string; static;
      class function GetThumbnailByUrl(AUrl: string): string; static;
      class function GetLibPath(ALibFilename: string): string; static;
      class function GetHashedDownloadedFilename(AFilename: string; AOrigin: integer = -2; AWithExtension: boolean = True): string; static;
      class function GetDefaultBackupPath: string; static;
      class procedure CreateThumbnailsDir; static;
  end;

  TSearchRecAr = TArray<TSearchRec>;


  function GetFiles(APath: string = ''; AType: integer = faAnyFile): TSearchRecAr;


implementation

function GetFiles(APath: string; AType: integer): TSearchRecAr;
var
  Sr: TSearchRec;
begin
  Result := [];
  if FindFirst(APath + '*.*', AType, Sr) = 0 then begin
    Repeat
      Result := Result + [Sr];
    Until FindNext(Sr) <> 0;
    FindClose(Sr);
  end;
end;

{ TNBoxPath }

class procedure TNBoxPath.CreateThumbnailsDir;
begin
  if not DirectoryExists(TNBoxPath.GetThumbnailsPath) then
    CreateDir(TNBoxPath.GetThumbnailsPath);
end;

class function TNBoxPath.GetAppMainPath: string;
begin
  {$IFDEF MSWINDOWS}
  Result := TNBoxPath.GetAppPath;
  {$ENDIF}

  {$IFDEF ANDROID}
  Result := Tpath.GetDocumentsPath;
  {$ENDIF}
end;

{$IFDEF MSWINDOWS}
class function TNBoxPath.GetAppPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;
{$ENDIF}

class function TNBoxPath.GetCachePath: string;
begin
  {$IFDEF MSWINDOWS}
  Result := TPath.Combine(TNBoxPath.GetAppMainPath, 'cache');
  {$ENDIF}

  {$IFDEF ANDROID}
  Result := TPath.GetCachePath;
  {$ENDIF}
end;

class function TNBoxPath.GetDefaultBackupPath: string;
var
  LSubDirs: string;
begin
  LSubDirs := TPath.Combine('NsfwBox', 'Backups');
  {$IFDEF MSWINDOWS}
  Result := TPath.Combine(TPath.GetDocumentsPath, LSubDirs);
  {$ELSE}
  Result := TPath.Combine(TPath.GetSharedDocumentsPath, LSubDirs);
  {$ENDIF}
end;

class function TNBoxPath.GetFetchedItemsCachePath: string;
begin
  Result := TPath.Combine(TNBoxPath.GetCachePath, 'fetched-posts');
end;

class function TNBoxPath.GetHashedDownloadedFilename(AFilename: string;
  AOrigin: integer; AWithExtension: boolean): string;
var
  FileExt, DefaultExt: string;
  function MidN(const AStr: string; ALeft, ARight: string): string;
  var
    Lp, Rp, Ms : integer;
  begin
    Lp := Pos(ALeft, AStr);
    Ms := ALeft.Length + Lp;
    Rp := Pos(ARight, AStr, Ms);
    result := Copy(AStr, Ms, Rp - Ms);
  end;

  function GetBefore(const ASource: string; ASub: string): string;
  var
    LPos: integer;
  begin
    LPos := ASource.IndexOf(ASub);
    if LPos <> -1 then begin
      Result := ASource.Substring(0, LPos);
    end;
  end;

begin
  FileExt := '';
  if AWithExtension then begin

    DefaultExt := '.mp4';

    if AOrigin = ORIGIN_NSFWXXX then begin
      FileExt := trim(MidN(AFilename, '?format=', '&'));
      if Not FileExt.IsEmpty then
        FileExt := '.' + FileExt;
    end;

    if FileExt.IsEmpty then
      FileExt := TPath.GetExtension(AFilename);

    if FileExt.Contains('?') then
      FileExt := GetBefore(FileExt, '?');

    if not Tpath.HasValidFileNameChars(FileExt, false) then
      FileExt := DefaultExt;

  end;
  Result := THashMD5.GetHashString(AFilename) + FileExt;
end;

class function TNBoxPath.GetLibPath(ALibFilename: string): string;
begin
  {$IFDEF ANDROID}
  Result := TPath.Combine(TPath.GetDocumentsPath, 'libs');
  Result := TPath.Combine(Result, ALibFilename);
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  Result := '';
  {$ENDIF}
end;

class function TNBoxPath.GetThemesPath: string;
begin
  Result := TPath.Combine(TNBoxPath.GetAppMainPath, 'themes');
end;

class function TNBoxPath.GetThumbnailByUrl(AUrl: string): string;
var
  FileExt: string;
begin
  FileExt := TPath.GetExtension(AUrl);
  Result := THashMD5.GetHashString(AUrl) + FileExt;
  Result := TPath.Combine(TNBoxPath.GetThumbnailsPath, Result);
end;

class function TNBoxPath.GetThumbnailsPath: string;
begin
  Result := TPath.Combine(TNBoxPath.GetCachePath, 'thumbnails');
end;

end.
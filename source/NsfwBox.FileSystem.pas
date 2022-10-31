{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.FileSystem;

interface
uses
  Classes, SysUtils, Types, system.IOUtils, system.Hash;

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
      class function GetThumbnailByUrl(AUrl: string): string; static;
      class function GetLibPath(ALibFilename: string): string; static;
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
  Result := TNBoxPath.GetAppMainPath;
  {$ENDIF}

  {$IFDEF ANDROID}
  Result := TPath.GetCachePath;
  {$ENDIF}
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
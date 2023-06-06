unit NsfwBox.Utils;

interface

uses
  Classes, SysUtils, System.Generics.Collections, System.IOUtils,
  NsfwBox.Logging;

type
  PInterface = ^IInterface;

  function GetFirstStr(Ar: TArray<string>): string;
  function StrIn(const Ar: TArray<string>; AStr: string; AIgnoreCase: boolean = True): boolean;
  function BytesCountToSizeStr(ABytesCount: int64): string;
  function GetPercents(AFull, APiece: Real): integer;
  function GetThumbByFileExt(const AFilename: string): string;

  ///<summary>FreeAndNil for interfaced objects without reference counting.</summary>
  procedure FreeInterfaced(const [ref] AObject: IInterface);


implementation
uses Unit1, NsfwBox.Styling;

procedure FreeInterfaced(const [ref] AObject: IInterface);
var
  LTmp: TObject;
begin
  try
    LTmp := AObject As TObject;
    FreeAndNil(LTmp);
    TObject(Pointer(@AObject)^) := nil;
  except
    On E: Exception do Log('Utils.FreeInterfaced', E);
  end;
end;

function BytesCountToSizeStr(ABytesCount: int64): string;
const
  UNITS: Tarray<string> = ['Kb', 'Mb', 'Gb'];
var
  I: integer;
  LValue: int64;
begin
  LValue := ABytesCount;
  for I := 0 to High(UNITS) do begin
    LValue := Round(LValue / 1024);
    if LValue < 1024 then
      Break;
  end;
  Result := LValue.ToString + ' ' + UNITS[I];
end;

function GetPercents(AFull, APiece: Real): integer;
var
  X: Real;
begin
  Result := 0;
  try
    if AFull > 0 then begin
      X := AFull / 100;
      Result := Round(APiece / X);
      if Result > 100 then Result := 100;
    end;
  except
    On E: Exception do begin
      Log('GetPercents', E);
    end;
  end;
end;

function GetFirstStr(Ar: TArray<string>): string;
begin
  if Length(Ar) > 0 then
    Result := Ar[0]
  else
    Result := '';
end;

function StrIn(const Ar: TArray<string>; AStr: string; AIgnoreCase: boolean): boolean;
var
  I: integer;
begin
  Result := False;
  for I := 0 to High(Ar) do begin
    if AIgnoreCase then
      Result := (UpperCase(Ar[I]) = UpperCase(AStr))
    else
      Result := (Ar[I] = AStr);

    if Result then Exit;
  end;
end;

function GetThumbByFileExt(const AFilename: string): string;
const
  VIDEO: TArray<string> = ['.m4v', '.mp4', '.webm'];
  AUDIO: TArray<string> = ['.mp3', '.m4a', '.ogg', '.wav'];
var
  LExt: string;
begin
  LExt := TPath.GetExtension(AFilename);
  if StrIn(VIDEO, LExt, True) then
    Result := Form1.AppStyle.GetImagePath(IMAGE_DUMMY_VIDEO)
  else if StrIn(AUDIO, LExt, True) then
    Result := Form1.AppStyle.GetImagePath(IMAGE_DUMMY_AUDIO)
  else
    Result := Form1.AppStyle.GetImagePath(IMAGE_LOADING);
end;

end.

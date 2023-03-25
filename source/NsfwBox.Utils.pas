unit NsfwBox.Utils;

interface

uses
  Classes, SysUtils, System.Generics.Collections,
  NsfwBox.Logging;

type
  PInterface = ^IInterface;

  function GetFirstStr(Ar: TArray<string>): string;
  function StrIn(const Ar: TArray<string>; AStr: string; AIgnoreCase: boolean = True): boolean;
  function BytesCountToSizeStr(ABytesCount: int64): string;

  ///<summary>FreeAndNil for interfaced objects without reference counting.</summary>
  procedure FreeInterfaced(const [ref] AObject: IInterface);

implementation

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

end.

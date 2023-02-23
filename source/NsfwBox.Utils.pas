unit NsfwBox.Utils;

interface

uses
  Classes, SysUtils, System.Generics.Collections;

  function GetFirstStr(Ar: TArray<string>): string;
  function StrIn(const Ar: TArray<string>; AStr: string; AIgnoreCase: boolean = True): boolean;

implementation

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

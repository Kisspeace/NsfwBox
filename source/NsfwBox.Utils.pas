unit NsfwBox.Utils;

interface
uses
  Classes, SysUtils, System.Generics.Collections;

  function GetFirstStr(Ar: TArray<string>): string;

implementation

function GetFirstStr(Ar: TArray<string>): string;
begin
  if Length(Ar) > 0 then
    Result := Ar[0]
  else
    Result := '';
end;

end.

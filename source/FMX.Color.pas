unit FMX.Color;

interface
uses
  System.classes, System.uitypes, system.SysUtils;

 function GetColor(R, G, B: Byte; A: byte = 255): TAlphaColor;
 function GetRandomColor(AAlpha: boolean): TAlphaColor; overload;
 Function GetRandomColor(AAlpha: boolean; ABrightness: byte): TAlphaColor; overload;
 function ChangeBrightnessColor(AColor: TAlphaColor; AValue: byte): TAlphaColor;
 function BGRToHex(AColor: TAlphaColor): string;
 function ABGRToHex(Acolor: TAlphaColor): string;

implementation

function BgrToHex(Acolor: TAlphaColor): string;
begin
  Result :=
    Inttohex(TAlphaColorRec(AColor).B, 1) +
    Inttohex(TAlphaColorRec(AColor).G, 1) +
    Inttohex(TAlphaColorRec(AColor).R, 1)
  ;
end;

function AbgrToHex(Acolor: TAlphaColor): string;
begin
  result := Inttohex(TAlphaColorRec(AColor).A, 1) + BGRToHex(AColor);
end;

function GetColor(R, G, B: Byte; A: byte = 255): TAlphaColor;
begin
  TAlphaColorRec(Result).R := R;
  TAlphaColorRec(Result).G := G;
  TAlphaColorRec(Result).B := B;
  TAlphaColorRec(Result).A := A;
end;


function GetRandomColor(AAlpha: boolean): TAlphaColor;
begin
  Result := GetColor(Random(256), Random(256), Random(256));
  if AAlpha then
    TAlphaColorRec(Result).A := Random(256);
end;

Function GetRandomColor(AAlpha: boolean; ABrightness: byte): TAlphaColor;
begin
  Result := GetColor(Random(ABrightness), Random(ABrightness), Random(ABrightness));
  if AAlpha then
    TAlphaColorRec(Result).A := Random(256);
end;

function ChangeBrightnessColor(AColor: TAlphaColor; AValue: byte): TAlphaColor;
var
  R, G, B: byte;
begin
  R := TAlphaColorRec(AColor).R;
  G := TAlphaColorRec(AColor).G;
  B := TAlphaColorRec(AColor).B;

  if R < AValue then AValue := R;
  if G < AValue then AValue := G;
  if B < AValue then AValue := B;

  Result := GetColor(R - AValue, G - AValue, B - AValue, TAlphaColorRec(AColor).A);
end;

end.

unit FMX.Color;

interface
 uses
  System.classes, System.uitypes, system.SysUtils;

 function GetColor(R, G, B, A: Byte): TAlphaColor; overload;
 function GetColor(R, G, B: Byte): TAlphaColor; overload;
 function GetRandomColor(Alpha: boolean): Talphacolor; overload;
 Function GetRandomColor(Alpha: boolean; Brightness: byte): talphacolor; overload;
 function ChangeBrightnessColor(color: TAlphacolor; value: byte): talphacolor;
 function BgrToHex(Acolor: Talphacolor): string;
 function AbgrToHex(Acolor: TalphaColor): string;

implementation

function BgrToHex(Acolor: Talphacolor): string;
begin
  Result :=
   Inttohex(Talphacolorrec(Acolor).B, 1) +
   Inttohex(Talphacolorrec(Acolor).G, 1) +
   Inttohex(Talphacolorrec(Acolor).R, 1)
   ;
end;

function AbgrToHex(Acolor: TalphaColor): string;
begin
  result := Inttohex(Talphacolorrec(Acolor).A, 1) + Bgrtohex(Acolor);
end;

function GetColor(R, G, B, A: Byte): TAlphaColor;
var
  Color: talphacolor;
begin
  talphacolorrec(color).R := r;
  talphacolorrec(color).G := g;
  talphacolorrec(color).b := b;
  talphacolorrec(color).a := a;
  Result := Color;
end;

function GetColor(R, G, B: Byte): TAlphaColor;
begin
  Result := getColor(R, G, B, 255);
end;

function GetRandomColor(Alpha: boolean): Talphacolor;
var
  Color: talphacolor;
begin
  Talphacolorrec(color).R := Random(256);
  Talphacolorrec(color).G := Random(256);
  Talphacolorrec(color).B := Random(256);
  if Alpha then
    Talphacolorrec(color).A := Random(256)
  else
    Talphacolorrec(Color).A := 255;
  Result := Color;
end;

Function GetRandomColor(Alpha: boolean; Brightness: byte): TAlphaColor;
var
  Color: TAlphaColor;
begin
  Talphacolorrec(color).R := Random(brightness);
  Talphacolorrec(color).G := Random(brightness);
  Talphacolorrec(color).B := Random(brightness);
  if Alpha then
    Talphacolorrec(color).A := Random(256)
  else
    Talphacolorrec(Color).A := 255;
  Result := Color;
end;

function ChangeBrightnessColor(color: TAlphacolor; value: byte): talphacolor;
var
  R, G, B: byte;
begin
  R := talphacolorrec(Color).R;
  G := talphacolorrec(Color).G;
  B := talphacolorrec(Color).B;

  if R < value then value := R;
  if G < value then value := G;
  if B < value then value := B;

  Result := getcolor(R - value, G - value, B - value, TAlphacolorrec(color).a);
end;

end.

{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Logging;

interface
uses
  SysUtils, System.Diagnostics, System.Classes,
  { you-did-well! ---- }
  YDW.Debug;

type

  TNBoxLogFile = YDW.Debug.TLogFile;

  procedure Log(AText: string; AExcept: Exception); overload;
  procedure Log(AText: string); overload;

var
  LogFile: TLogFile;

implementation

procedure Log(AText: string; AExcept: Exception);
begin
  LogFile.Log(AText, AExcept);
end;

procedure Log(AText: string);
begin
  LogFile.Log(AText);
end;

end.

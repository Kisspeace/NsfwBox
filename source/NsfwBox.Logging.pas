{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.Logging;

interface
uses
  SysUtils, System.Diagnostics, System.Classes,
  BooruScraper.Parser.Utils,
  { you-did-well! ---- }
  YDW.Debug;

type

  TNBoxLogFile = YDW.Debug.TLogFile;

  procedure Log(AText: string; AExcept: Exception); overload;
  procedure Log(AText: string); overload;

  function LoadCompressedLog(AUpToCharsCount: integer): string;

var
  LogFile: TLogFile;

implementation
uses unit1;

procedure Log(AText: string; AExcept: Exception);
begin
  LogFile.Log(AText, AExcept);
end;

procedure Log(AText: string);
begin
  LogFile.Log(AText);
end;

function LoadCompressedLog(AUpToCharsCount: integer): string;
var
  LStrings: TStrings;
  LStr: string;
  I, N: integer;
  LDupCount: integer;
begin
  try
    LStrings := TStringList.Create;
    try
      LStrings.LoadFromFile(Unit1.LOG_FILENAME);
      if LStrings.Count < 1 then Exit('');
      for I := 0 to LStrings.Count - 1 do
      begin
        LStr := LStrings[I];

        { Timestamp erasing }
        if LStr.StartsWith('[ ') then
          LStr := LStr.Substring(LStr.IndexOf(' ]: ') + 4);

        if LStr.StartsWith('MainThread') then begin
          { Compress MainThread to M }
          LStr := LStr.Replace('MainThread', 'M');

          { Comperss message about app start }
          if LStr.Contains('Application start') then
          begin
            LStr := LStr.Replace('Application start', '');
            LStr := LStr.Replace('M,', '');
            LStr := LStr.Trim(['|', '-', ' ']);
          end;

          if LStr.Contains('AppException') then
            LStr := LStr.Replace('AppException', 'App');

        end else if LStr.StartsWith('Thread(') then begin
          { Compress Thread( to T }
          LStr := LStr.Replace('Thread(', 'T');

          if LStr.Contains('Provider: ') then
            LStr := LStr.Replace('Provider: ', 'PVR');
        end;

        if LStr.Contains('- {EXCEPTION!} -') then begin
          LStr := LStr.Replace('- {EXCEPTION!} -', 'Ex');
          LStr := LStr.Replace('Argument out of range', 'ArgOOR');
        end;

        if LStr.Contains('Access violation') then begin
          LStr := LStr.Replace('Access violation', 'AV');
          LStr := LStr.Replace('at address', 'at');
          LStr := LStr.Replace('in module ''NsfwBox.exe''.', '');
          LStr := LStr.Replace('Read of address', 'R');
          LStr := LStr.Replace('TPlatformWin', 'Win');
        end;

        { Compress message about closing app }
        if LStr.Contains('Destroing app') then
          LStr := 'x'
        { not necessary lines }
        else if LStr.Contains('Last release:')
        or LStr.Contains('Disallow MimeType:')
        or LStr.Contains('(12002) The operation')
        or LStr.Contains('(12007) The server')
        or LStr.Contains('java.net.') then
          LStr := '';

        LStrings[I] := LStr;
      end;

      { Compress same lines }
      I := 0;
      LDupCount := 0;
      LStr:= '';
      while True do begin
        if (I >= LStrings.Count) then break;
        if (LStr = LStrings[I]) then
        begin
          if not LStr.IsEmpty then
            Inc(LDupCount);
        end else begin
          if (LDupCount > 0) then begin
            LStrings.Insert(I + 1, '^+' + LDupCount.ToString);
            for N := I downto (I - LDupCount) do
              LStrings[N] := '';
            Inc(I);
          end;
          LStr := LStrings[I];
          LDupCount := 0;
        end;
        Inc(I);
      end;

      { Delete empty lines }
      I := 0;
      while True do begin
        if (I >= LStrings.Count) then break;
        if LStrings[I].IsEmpty then begin
          LStrings.Delete(I);
        end else Inc(I);
      end;

      { Limit chars count }
      Result := LStrings.Text;
      if (AUpToCharsCount > 0) and (Result.Length > AUpToCharsCount) then
      begin
        var LStart := Result.Length - AUpToCharsCount;
        Result := Result.Substring(LStart, AUpToCharsCount)
      end;
    finally
      LStrings.Free;
    end;
  except
    On E: Exception do begin
      NsfwBox.Logging.log('LoadCompressedLog', E);
    end;
  end;
end;

end.

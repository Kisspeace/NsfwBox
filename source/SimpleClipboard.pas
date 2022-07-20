unit SimpleClipboard;

interface
Uses
  fmx.Platform, fmx.Clipboard;

  function CopyToClipboard(const AText: string): boolean;

implementation

function CopyToClipboard(const AText: string): boolean;
var
  ClipBoard: IFMXExtendedClipboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService
  (IFMXExtendedClipboardService, clipboard) then
  begin
    ClipBoard.SetText(AText);
    Result := true;
  end else
    Result := false;
end;

end.

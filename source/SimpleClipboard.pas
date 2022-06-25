unit SimpleClipboard;

interface
Uses
  fmx.Platform, fmx.Clipboard;

  function CopyToClipboard(const Atext: string): boolean;

implementation

function CopyToClipboard(const Atext: string): boolean;
var
  ClipBoard: IFMXExtendedClipboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService
  (IFMXExtendedClipboardService, clipboard) then
  begin
    ClipBoard.SetText(Atext);
    Result := true;
  end else
    Result := false;
end;

end.

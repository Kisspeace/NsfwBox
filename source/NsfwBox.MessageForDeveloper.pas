{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.MessageForDeveloper;

interface
uses
  Classes, SysUtils, Net.HttpClient, Net.HttpClientComponent,
  XSuperObject, System.NetEncoding, NsfwBox.Logging, NsfwBox.Utils;


  function SendMessage(ANickname, AMessage: string): boolean;

const
  MAX_MSG_LENGTH = 2000;

implementation
uses unit1;

function SendMessage(ANickname, AMessage: string): boolean;
const
  DUCK: string = 'aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTAwMzM4' +
  'NzA3NjU0MjIwNTk1Mi9pN1BaekhwM3Y3dnh0TmZTdmJza29zU21FTHl2UW9YampVTU9Q' +
  'ZDNTaVplSkpxbmI2QXVDUk9hNi1nOHlFZFp0eWZHNz93YWl0PXRydWU=';
var
  Client: TNetHttpClient;
  Json: ISuperObject;
  RequestBody: TStringStream;
  Response: IHttpResponse;
  Url: string;
begin
  Result := false;
  Json := SO();
  ANickname := trim(ANickName);

  if (AMessage.Length > MAX_MSG_LENGTH) then
    AMessage := AMessage.Substring(MAX_MSG_LENGTH - AMessage.Length, MAX_MSG_LENGTH);

  if ( not ANickname.IsEmpty ) then
    Json.S['username'] := ANickname;
  Json.S['content'] := AMessage;

  Client := TNetHttpClient.Create(nil);
  Client.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0';
  Client.ContentType := 'application/json';
  Client.AcceptEncoding := 'gzip, deflate';
  Client.Accept := '*/*';
  Client.SendTimeout := 5000;
  Client.ConnectionTimeout := 5000;
  Client.ResponseTimeout := 6000;

  RequestBody := TStringStream.Create(Json.AsJSON(false));
  Url := TNetEncoding.Base64String.Decode(DUCK);
  try
    Response := Client.Post(Url, RequestBody);
    try
      Json := SO(Response.ContentAsString);
      Result := Json.Contains('content');
    except

    end;
    //unit1.Log(Response.ContentAsString);
  finally
    Client.Free;
    RequestBody.Free;
  end;
end;

end.

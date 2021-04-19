{
########################################################
#          SIMPLE REST EXAMPLE IN PASCAL(LAZARUS       #
########################################################
}
program simpleRest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Dos,
  Classes,
  fphttpclient,
  fpopenssl,
  jsonparser,
  openssl,
  jsonscanner,
  opensslsockets;

var
  nParam: integer;
  Url: string;
  Rest: TFPHttpClient;
  Resultado: string;
  saveFile: TStringlist;
  HH, MM, SS, MS: word;
begin

  if paramCount() < 1 then
  begin
    writeLn('Follow example: ' + #10#10 + 'lazRest url savefile' + #10);
    exit;
  end;

  Url := ParamStr(1);


  InitSSLInterface;

  Rest := TFPHttpClient.Create(nil);
  try
    try
      Rest.AllowRedirect := True;
      DecodeTime(Now, HH, MM, SS, MS);
      Writeln(#10 + 'Starting : ' + FormatDateTime('hh:mm:ss', Now));
      Resultado := Rest.Get(Url);
    except
      on E: EHttpClient do
      begin
        writeln(#10 + '[ERROR]');
        writeln(#10 + E.Message + #10);
        exit;
      end
      else
        raise;
    end;
  finally
    Rest.Free;
  end;
  Writeln(#10 + 'Finished : ' + FormatDateTime('hh:mm:ss', Now));
  writeLn(#10 + 'Response code: ' + IntToStr(Rest.ResponseStatusCode));
   if paramCount() > 1 then
  begin
    saveFile:= TStringlist.create;
  try
    saveFile.Add(Resultado);
    saveFile.SaveToFile(ParamStr(2));
  finally
    saveFile.Free;
    Writeln(#10 + 'Saved to : ' + ParamStr(2));
  end;
  end else
    WriteLn(#10 +Resultado);

end.

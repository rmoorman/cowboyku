%% Feel free to use, reuse and abuse the code in this file.

-module(http_body_qs).
-behaviour(cowboyku_http_handler).
-export([init/3, handle/2, terminate/3]).

init({_, http}, Req, _) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	{Method, Req2} = cowboyku_req:method(Req),
	HasBody = cowboyku_req:has_body(Req2),
	{ok, Req3} = maybe_echo(Method, HasBody, Req2),
	{ok, Req3, State}.

maybe_echo(<<"POST">>, true, Req) ->
	case cowboyku_req:body_qs(Req) of
		{error,badlength} ->
			echo(badlength, Req);
		{ok, PostVals, Req2} ->
			echo(proplists:get_value(<<"echo">>, PostVals), Req2)
	end;

maybe_echo(<<"POST">>, false, Req) ->
	cowboyku_req:reply(400, [], <<"Missing body.">>, Req);
maybe_echo(_, _, Req) ->
	%% Method not allowed.
	cowboyku_req:reply(405, Req).

echo(badlength, Req) ->
	cowboyku_req:reply(413, [], <<"POST body bigger than 16000 bytes">>, Req);
echo(undefined, Req) ->
	cowboyku_req:reply(400, [], <<"Missing echo parameter.">>, Req);
echo(Echo, Req) ->
	cowboyku_req:reply(200, [
		{<<"content-type">>, <<"text/plain; charset=utf-8">>}
	], Echo, Req).

terminate(_, _, _) ->
	ok.

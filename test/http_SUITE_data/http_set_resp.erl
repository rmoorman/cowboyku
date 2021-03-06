%% Feel free to use, reuse and abuse the code in this file.

-module(http_set_resp).
-behaviour(cowboyku_http_handler).
-export([init/3, handle/2, terminate/3]).

init({_Transport, http}, Req, Opts) ->
	Headers = proplists:get_value(headers, Opts, []),
	Body = proplists:get_value(body, Opts, <<"http_handler_set_resp">>),
	Req2 = lists:foldl(fun({Name, Value}, R) ->
		cowboyku_req:set_resp_header(Name, Value, R)
	end, Req, Headers),
	Req3 = cowboyku_req:set_resp_body(Body, Req2),
	Req4 = cowboyku_req:set_resp_header(<<"x-cowboyku-test">>, <<"ok">>, Req3),
	Req5 = cowboyku_req:set_resp_cookie(<<"cake">>, <<"lie">>, [], Req4),
	{ok, Req5, undefined}.

handle(Req, State) ->
	case cowboyku_req:has_resp_header(<<"x-cowboyku-test">>, Req) of
		false -> {ok, Req, State};
		true ->
			case cowboyku_req:has_resp_body(Req) of
				false -> {ok, Req, State};
				true ->
					{ok, Req2} = cowboyku_req:reply(200, Req),
					{ok, Req2, State}
			end
	end.

terminate(_, _, _) ->
	ok.

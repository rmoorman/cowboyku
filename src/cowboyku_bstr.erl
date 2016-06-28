%% Copyright (c) 2011-2013, Loïc Hoguin <essen@ninenines.eu>
%%
%% Permission to use, copy, modify, and/or distribute this software for any
%% purpose with or without fee is hereby granted, provided that the above
%% copyright notice and this permission notice appear in all copies.
%%
%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
%% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
%% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

%% @doc Binary string manipulation.
-module(cowboyku_bstr).

%% Binary strings.
-export([capitalize_token/1]).
-export([to_lower/1]).
-export([to_upper/1]).

%% Characters.
-export([char_to_lower/1]).
-export([char_to_upper/1]).

-on_load(init/0).

init() ->
    case code:priv_dir(cowboyku_bstr) of
        {error, bad_name} ->
            case code:which(?MODULE) of
                Filename when is_list(Filename) ->
                    SoName = filename:join([filename:dirname(Filename),"../priv", "cowboyku"]);
                _ ->
                    SoName = filename:join("../priv", "cowboyku")
            end;
         Dir ->
            SoName = filename:join(Dir, "cowboyku")
    end,
    erlang:load_nif(SoName, 0).


%% @doc Capitalize a token.
%%
%% The first letter and all letters after a dash are capitalized.
%% This is the form seen for header names in the HTTP/1.1 RFC and
%% others. Note that using this form isn't required, as header name
%% are case insensitive, and it is only provided for use with eventual
%% badly implemented clients.
-spec capitalize_token(B) -> B when B::binary().
capitalize_token(B) ->
    erlang:nif_error({error, not_loaded}).

%% @doc Convert a binary string to lowercase.
-spec to_lower(B) -> B when B::binary().
to_lower(B) ->
	<< << (char_to_lower(C)) >> || << C >> <= B >>.

%% @doc Convert a binary string to uppercase.
-spec to_upper(B) -> B when B::binary().
to_upper(B) ->
	<< << (char_to_upper(C)) >> || << C >> <= B >>.

%% @doc Convert [A-Z] characters to lowercase.
%% @end
%% We gain noticeable speed by matching each value directly.
-spec char_to_lower(char()) -> char().
char_to_lower($A) -> $a;
char_to_lower($B) -> $b;
char_to_lower($C) -> $c;
char_to_lower($D) -> $d;
char_to_lower($E) -> $e;
char_to_lower($F) -> $f;
char_to_lower($G) -> $g;
char_to_lower($H) -> $h;
char_to_lower($I) -> $i;
char_to_lower($J) -> $j;
char_to_lower($K) -> $k;
char_to_lower($L) -> $l;
char_to_lower($M) -> $m;
char_to_lower($N) -> $n;
char_to_lower($O) -> $o;
char_to_lower($P) -> $p;
char_to_lower($Q) -> $q;
char_to_lower($R) -> $r;
char_to_lower($S) -> $s;
char_to_lower($T) -> $t;
char_to_lower($U) -> $u;
char_to_lower($V) -> $v;
char_to_lower($W) -> $w;
char_to_lower($X) -> $x;
char_to_lower($Y) -> $y;
char_to_lower($Z) -> $z;
char_to_lower(Ch) -> Ch.

%% @doc Convert [a-z] characters to uppercase.
-spec char_to_upper(char()) -> char().
char_to_upper($a) -> $A;
char_to_upper($b) -> $B;
char_to_upper($c) -> $C;
char_to_upper($d) -> $D;
char_to_upper($e) -> $E;
char_to_upper($f) -> $F;
char_to_upper($g) -> $G;
char_to_upper($h) -> $H;
char_to_upper($i) -> $I;
char_to_upper($j) -> $J;
char_to_upper($k) -> $K;
char_to_upper($l) -> $L;
char_to_upper($m) -> $M;
char_to_upper($n) -> $N;
char_to_upper($o) -> $O;
char_to_upper($p) -> $P;
char_to_upper($q) -> $Q;
char_to_upper($r) -> $R;
char_to_upper($s) -> $S;
char_to_upper($t) -> $T;
char_to_upper($u) -> $U;
char_to_upper($v) -> $V;
char_to_upper($w) -> $W;
char_to_upper($x) -> $X;
char_to_upper($y) -> $Y;
char_to_upper($z) -> $Z;
char_to_upper(Ch) -> Ch.

%% Tests.

-ifdef(TEST).

capitalize_token_test_() ->
	%% {Header, Result}
	Tests = [
		{<<"heLLo-woRld">>, <<"Hello-World">>},
		{<<"Sec-Websocket-Version">>, <<"Sec-Websocket-Version">>},
		{<<"Sec-WebSocket-Version">>, <<"Sec-Websocket-Version">>},
		{<<"sec-websocket-version">>, <<"Sec-Websocket-Version">>},
		{<<"SEC-WEBSOCKET-VERSION">>, <<"Sec-Websocket-Version">>},
		{<<"Sec-WebSocket--Version">>, <<"Sec-Websocket--Version">>},
		{<<"Sec-WebSocket---Version">>, <<"Sec-Websocket---Version">>}
	],
	[{H, fun() -> R = capitalize_token(H) end} || {H, R} <- Tests].

-endif.

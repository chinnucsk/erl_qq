-module(eqq_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	lager:start(),
	hm_misc:ensure_started(crypto),
	hm_misc:ensure_started(ibrowse),
    eqq_sup:start_link().

stop(_State) ->
	lager:stop(),
    ok.

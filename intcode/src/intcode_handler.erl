%%----------------------------------------------------------------------
%%
%% Intcode handler
%%
%%----------------------------------------------------------------------
-module(intcode_handler).

-export([init/2]).

%%----------------------------------------------------------------------
init(Req0, State) ->
	#{path := <<"/",Puzzle:1/binary,"/",Input_value:1/binary>>} = Req0,
    Req = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain">>},
        intcode:run(binary_to_list(Puzzle), 
			binary_to_integer(Input_value)),
        Req0),
    {ok, Req, State}.
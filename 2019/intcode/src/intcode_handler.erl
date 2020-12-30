%%----------------------------------------------------------------------
%%
%% Intcode handler
%%
%%----------------------------------------------------------------------
-module(intcode_handler).

-export([init/2]).

%%----------------------------------------------------------------------
init(Req0, State) ->
	#{path := <<"/",Puzzle:1/binary,"/",Input_value/binary>>} = Req0,
    {ok, File} = file:read_file([
        "/Users/madde/Sites/advent-of-code-2019/input/puzzle", 
        binary_to_list(Puzzle), ".txt"]),
    {List,_} = lists:mapfoldl(fun(X, N) -> 
        {{N, binary_to_integer(X)}, N + 1} end, 0, 
        binary:split(File, <<",">>, [global])),
    Puzzle_input = dict:from_list(List),
    Input_values = lists:map(fun(I) -> binary_to_integer(I) end,
    	binary:split(Input_value,<<"-">>, [global])),
    Req = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain">>}, 
        intcode:run(Puzzle_input, Input_values), Req0),
    {ok, Req, State}.
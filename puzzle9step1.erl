% Should be 2350741403

-module (puzzle9step1).

-export ([start/0]).

start() ->
    ets:new(program, [named_table, public, ordered_set]),
    {ok, File} = file:read_file(
        "/Users/madde/Sites/advent-of-code-2019/input/puzzle5.txt"),
    Program = lists:map(fun(X) -> binary_to_integer(X) end, 
        binary:split(File, <<",">>, [global])),
    lists:mapfoldl(fun(X, N) -> ets:insert(program, {N, X}), {ok, N + 1} end, 
        0, Program),
    put(relative_b, 0),
    run(0).

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
write(<<"2">>, N, Data) -> case ets:lookup(program, get(relative_b) + N) of 
    [{_,N1}] -> ets:insert(program, {N1, Data}); _ -> ok end;

write(_, N, Data) -> case ets:lookup(program, N) of 
    [{_,N1}] -> ets:insert(program, {N1, Data}); _ -> ok end.

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
read(<<"0">>, [{_,Data}]) -> 
    case ets:lookup(program, Data) of [{_,N}] -> N; _ -> 0 end;
read(<<"1">>, [{_,Data}]) -> Data;
read(<<"2">>, [{_,Data}]) -> case ets:lookup(program, get(relative_b) + Data) of 
    [{_,N}] -> N; _ -> 0 end;
read(Mode, N) -> read(Mode, ets:lookup(program, N)).

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
run(N) ->
    Optcode = case ets:lookup(program, N) of
        [{_,99}] -> exit(get(result));
        [{_,O}] -> erlang:iolist_to_binary(["0000",integer_to_binary(O)])
    end,
    Mode = binary:part(Optcode, {byte_size(Optcode)-2, -3}),
    Instruction = binary:part(Optcode, {byte_size(Optcode), -2}),
    N1 = match(N, Mode, Instruction),
    run(N1).

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
match(N, <<M3:1/binary, M2:1/binary, M1:1/binary>>, <<_,"1">>) -> 
    write(M3, N+3, read(M1, N+1) + read(M2, N+2)), N + 4;

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
match(N, <<M3:1/binary, M2:1/binary, M1:1/binary>>, <<_,"2">>) -> 
    write(M3, N+3, read(M1, N+1) * read(M2, N+2)), N + 4;

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
match(N, <<_M3:1/binary, _M2:1/binary, M1:1/binary>>, <<_,"3">>) -> 
    % {ok, Term} = io:read("Input the ID of the system to test: "), 
    Term = 5,
    io:format("Term ~p~n",[Term]),
    write(M1, N+1, Term), N + 2;

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
match(N, <<_M3:1/binary, _M2:1/binary, M1:1/binary>>, <<_,"4">>) -> 
    put(result, read(M1, N+1)),
    io:format("result ~p~n",[get(result)]),
    N + 2;

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
match(N, <<_M3:1/binary, M2:1/binary, M1:1/binary>>, <<_,"5">>) -> 
    case read(M1, N+1) of 0 -> N + 3; _ -> read(M2, N+2) end;

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
match(N, <<_M3:1/binary, M2:1/binary, M1:1/binary>>, <<_,"6">>) -> 
    case read(M1, N+1) of 0 -> read(M2, N+2); _ -> N + 3 end;

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
match(N, <<M3:1/binary, M2:1/binary, M1:1/binary>>, <<_,"7">>) -> 
    case read(M1, N+1) < read(M2, N+2) of true -> write(M3, N+3, 1); 
        _ -> write(M3, N+3, 0) end, N + 4;

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
match(N, <<M3:1/binary, M2:1/binary, M1:1/binary>>, <<_,"8">>) -> 
    case read(M1, N+1) == read(M2, N+2) of true -> write(M3, N+3, 1); 
        _ -> write(M3, N+3, 0) end, N + 4;

%% -----------------------------------------------------------------------------
%%
%% -----------------------------------------------------------------------------
match(N, <<_M3:1/binary, _M2:1/binary, M1:1/binary>>, <<_,"9">>) -> 
    put(relative_b, get(relative_b) + read(M1, N+1)), N + 2.


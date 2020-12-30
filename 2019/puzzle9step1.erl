%%----------------------------------------------------------------------
%%
%% Intcode computer
%%
%%----------------------------------------------------------------------
-module(puzzle9step1).

-export([start/0]).

%%----------------------------------------------------------------------
%% Load puzzle input. Set parameters.
%%----------------------------------------------------------------------
start() ->
    {ok, File} = file:read_file(
        "/Users/madde/Sites/advent-of-code-2019/input/puzzle9.txt"),
    {List,_} = lists:mapfoldl(fun(X, N) -> 
        {{N, binary_to_integer(X)}, N + 1} end, 0, 
        binary:split(File, <<",">>, [global])),
    Puzzle_input = dict:from_list(List),
    put(relative_base, 0),
    put(input_value, 2),
    put(output_value, null),
    run_intcodes(Puzzle_input, 0).

%%----------------------------------------------------------------------
%% Get index based on mode
%%----------------------------------------------------------------------
get_index(Dict, Index, "0") -> 
    case dict:find(Index, Dict) of {ok, Value} -> Value; _ -> 0 end;
get_index(_, Index, "1") -> Index;
get_index(Dict, Index, "2") -> 
    get(relative_base) + get_index(Dict, Index, "0").

%%----------------------------------------------------------------------
%% Get data based on index
%%----------------------------------------------------------------------
get_data(Dict, Index, Mode) -> 
    case dict:find(get_index(Dict, Index, Mode), Dict) of 
        {ok, Value} -> Value; _ -> 0 end.

%%----------------------------------------------------------------------
%% Run the puzzle input recursively until Opcode is "99"
%%----------------------------------------------------------------------
run_intcodes(Puzzle_input, Idx) ->
    {ok, Modes} = dict:find(Idx, Puzzle_input),
    [Mc, Mb, Ma|Opcode] = string:right(integer_to_list(Modes), 5, $0),
    A = get_data(Puzzle_input, Idx + 1, [Ma]),
    B = get_data(Puzzle_input, Idx + 2, [Mb]),
    C = get_index(Puzzle_input, Idx + 3, [Mc]),

    case Opcode of 
        "01" -> 
            Puzzle_input1 = dict:store(C, A + B, Puzzle_input),
            run_intcodes(Puzzle_input1, Idx + 4);

        "02" -> 
            Puzzle_input1 = dict:store(C, A * B, Puzzle_input),
            run_intcodes(Puzzle_input1, Idx + 4);

        "03" -> 
            A1 = get_index(Puzzle_input, Idx + 1, [Ma]),
            Puzzle_input1 = dict:store(A1, get(input_value), 
                Puzzle_input),
            run_intcodes(Puzzle_input1, Idx + 2);

        "04" -> 
            put(output_value, A),
            run_intcodes(Puzzle_input, Idx + 2);

        "05" -> 
            case A /= 0 of 
                true -> run_intcodes(Puzzle_input, B);
                _ -> run_intcodes(Puzzle_input, Idx + 3)
            end;          

        "06" -> 
            case A == 0 of 
                true -> run_intcodes(Puzzle_input, B);
                _ -> run_intcodes(Puzzle_input, Idx + 3)
            end;

        "07" -> 
            X = case A < B of true -> 1; _ -> 0 end,
            Puzzle_input1 = dict:store(C, X, Puzzle_input),
            run_intcodes(Puzzle_input1, Idx + 4);

        "08" -> 
            X = case A == B of true -> 1; _ -> 0 end,
            Puzzle_input1 = dict:store(C, X, Puzzle_input),
            run_intcodes(Puzzle_input1, Idx + 4);

        "09" -> 
            put(relative_base, get(relative_base) + A),
            run_intcodes(Puzzle_input, Idx + 2);

        "99" -> get(output_value)

    end.
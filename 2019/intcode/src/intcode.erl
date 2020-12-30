%%----------------------------------------------------------------------
%%
%% Intcode computer
%%
%%----------------------------------------------------------------------
-module(intcode).

-export([run/2]).

%%----------------------------------------------------------------------
%% Load puzzle input. Set parameters.
%%----------------------------------------------------------------------
run(Puzzle_input, Input_values) ->
    put(relative_base, 0),
    put(input_values, Input_values),
    put(output_value, []),
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
            [Input_value|Input_values] = get(input_values),
            Puzzle_input1 = dict:store(A1, Input_value, 
                Puzzle_input),
            put(input_values, Input_values),
            run_intcodes(Puzzle_input1, Idx + 2);

        "04" -> 
            put(output_value, 
                get(output_value) ++ [integer_to_binary(A)]),
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
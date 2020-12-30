%%----------------------------------------------------------------------
%% This solution sort of works, but needs to be optimized (using A* or
%% something else prioritizing the paths).
%%----------------------------------------------------------------------

%%----------------------------------------------------------------------
%% Import and format data. Get lists of doors and keys.
%% Run all possible solutions of path/4. Get the a list of lengths of 
%% all paths that are not preceded by a shorter path, and return the 
%% smallest number of that list.
%%----------------------------------------------------------------------
start(Result) :-
    retractall(shortest_path(_)), asserta(shortest_path(inf)),
    init_data, plot_path,
    cell(A, "@"),
    findall(Door, door(Door,_), Doors),
    findall(Key, key(Key,_), Keys),
    findall(Length, path(A, Doors, Keys, Length), Bag),
    min_list(Bag, Result).

%%----------------------------------------------------------------------
%% Start at pos. Walk through the maze. If succeeding to get all the
%% keys, update and return shortest_path.
%%----------------------------------------------------------------------
path(A, Doors, Keys, Path) :- 
    walk(A, [A], 0, Keys, Doors, Path),
    retractall(shortest_path(_)), asserta(shortest_path(Path)),
    format('walk done ~p~n',[Path]).

%%----------------------------------------------------------------------
%% Walk through the maze until fail, or all keys are collected.
%%----------------------------------------------------------------------
walk(_, _, Steps, [], _, Steps).
walk(A, Visited, Steps, Keys, Doors, Result) :-
    connected(A, C, Steps1),
    (member(C, Keys) ; true),
    \+ member(C, Visited),
    \+ member(C, Doors),
    shortest_path(Shortest_path),
    Steps2 is Steps1 + Steps,
    Steps2 < Shortest_path,
    (
        member(C, Keys) ->
            key(C, Key),
            delete(Keys, C, Keys1),
            (door(D, Key) -> delete(Doors, D, Doors1) ; Doors1 = Doors),
            Visited1 = [C]
        ; Keys1 = Keys, Doors1 = Doors, Visited1 = [C|Visited]
    ),
    walk(C, Visited1, Steps2, Keys1, Doors1, Result).

%%----------------------------------------------------------------------
%% Import and format data
%%----------------------------------------------------------------------
init_data :-
    retractall(connected(_,_,_)), retractall(cell(_,_)), 
    retractall(pos(_)), retractall(key(_,_)), retractall(door(_,_)),
    open('/Users/madde/Sites/advent-of-code-2019/input/puzzle18.txt', 
        read, Stream), 
    init_data(0, Stream), !.
init_data(_, Stream) :- at_end_of_stream(Stream), close(Stream).
init_data(Y, Stream) :-
    read_line_to_string(Stream, Line), 
    init_cells(Y, 0, Line),
    Y1 is Y + 1, 
    init_data(Y1, Stream).

%%----------------------------------------------------------------------
%% Assert each cell in the maze as cell/2
%%----------------------------------------------------------------------
init_cells(Y, X, Line) :-
    sub_string(Line, X, 1, _, Cell),
    (Cell \= "#" -> assertz(cell({Y, X}, Cell)) ; true),
    set_type(Y, X, Cell),
    X1 is X + 1, 
    init_cells(Y, X1, Line).
init_cells(_, _, _).

%%----------------------------------------------------------------------
%% Depending on the type of the cell (door, key, initial position,
%% nothing), assert to relevant clause, or do nothing.
%%----------------------------------------------------------------------
set_type(_, _, "#").
set_type(_, _, ".").
set_type(Y, X, "@") :- asserta(pos({Y, X})).
set_type(Y, X, Sub) :- string_lower(Sub, Sub), asserta(key({Y, X}, Sub)).
set_type(Y, X, Sub) :- string_upper(Sub, Sub), string_lower(Sub, Door), 
    asserta(door({Y, X}, Door)).
set_type(_, _, _).

%%----------------------------------------------------------------------
%% Plot available paths between keys and doors (it's never relevant to 
%% go to an empty cell).
%%----------------------------------------------------------------------
plot_path :- 
    findall(0, (cell(Pos, Cell), Cell \= ".", plot_path(Pos, [Pos])), _).

plot_path(From, [{Y, X}|Path]) :-
    (Y1 is Y + 1 ; Y1 is Y - 1 ; X1 is X + 1; X1 is X - 1),
    (Y1 = Y ; X1 = X),
    \+ member({Y1, X1}, Path),
    length([{Y1, X1},{Y, X}|Path], Len), Length is Len - 1,
    cell({Y1, X1}, Cell),
    (Cell = "." -> 
        plot_path(From, [{Y1, X1},{Y, X}|Path])
    ; 
        ((connected(From, {Y1, X1}, Length1), Length1 < Length) ->
            true
        ;
            retractall(connected(From, {Y1, X1}, _)),
            retractall(connected({Y1, X1}, From, _)),
            asserta(connected(From, {Y1, X1}, Length)),
            asserta(connected({Y1, X1}, From, Length))
        )
    ).
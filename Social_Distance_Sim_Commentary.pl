% This is where I began, solve takes 5-user arguments. This is what drives the entire program,
% So I knew I had to create a base case as well as another rule that will do the actual problem solving.
% I created another argument '[StartPos]' as a way to hold the current path being generated.
% (Starting Coord, Ending Y Coord, Grid Size, [Locations of People], Result)
solve(StartPos, Ending, [GridX,GridY], PeoplePos, Result) :-
	solve(StartPos, Ending, [GridX,GridY], PeoplePos, [StartPos], Result).

% BASE CASE - When a node with a y-coordinate value = Ending is reached.
solve([_, _], Ending, _, _, [S|_], [Result]) :-
    last(Y, S),
    Y is Ending,
    Result = S.

% Recursively generates a path that is safely distanced from people in the park, as well
% as within the boundaries of the grid. When finished, the base case will be called, and a result
% will be produced.
solve([_,_], Ending, [GridX,GridY], PeoplePos, [S|Path], [S|Result]) :-
    travel(S, NextState),
    check_safety(NextState, PeoplePos),
    check_boundary(NextState,[GridX,GridY]),
    not_member(NextState, Path), 
    solve([_,_], Ending, [GridX,GridY], PeoplePos, [NextState, S | Path], Result).

check_safety(_, []). % BASE CASE - every point is safe, the park is empty

% Checks all locations to see if they are close, returns true if no one is near
check_safety([X1,Y1], [[X2,Y2]|PeoplePos]) :-
    distance([X1,X2],[Y1,Y2]),
    check_safety([X1,Y1], PeoplePos).

% Determines whether a coordinate (X1,Y1) is within a
% specified distance 6 of another cooridnate (X2,Y2)
% returns true if socially distanced (more than 6 feet away).
% Taken directly from my microproject submission.
distance([X1,X2],[Y1,Y2]) :- 
    Dist is round(sqrt((X2-X1)^2 + (Y2-Y1)^2)),
    6 =< Dist.

% This is used to grab the Y-Coordinate to determine whether or not the end of park has been reached
last(X,[X]).
last(X,[_|Z]) :- last(X,Z).

% Prevents duplicates in the list. This was taken directly from the Week 9 folder video "Farmer,
% Goat, Wolf, Cabbage Version 2.
not_member(_, []) :- !.
not_member(X, [Head|Tail]) :- X \= Head,
    not_member(X, Tail).
                                             
% Checks to see whether or not the cvurrent point is in the grid boundaries 
check_boundary([X,Y], [GridX,GridY]) :-
    X  >= 0,
    X < GridX,
    Y >= 0,
    Y < GridY.

% Controls the movement between coordinates, altering the x and y values of a coordinate when necessary.
travel(S, NextState) :-
    move_forward(S, NextState).

travel(S, NextState) :-
    move_right(S, NextState).

travel(S, NextState) :-
    move_left(S, NextState).

move_forward([X1,Y1], [X2,Y2]) :-
    X2 is X1,
    Y2 is Y1 + 1.

move_right([X1,Y1], [X2,Y2]) :-
    X2 is X1 - 1,
    Y2 is Y1.

move_left([X1,Y1], [X2,Y2]) :-
    X2 is X1 + 1,
    Y2 is Y1.
-module(example).

-include("vardump.hrl").

-export([
    function_clause/0,
    all/0
    ]).

% examples

all() ->
    function_clause(),
    anonymous_function(),
    case_clause(),
    ok.

function_clause() ->
    Foo = 1 + 2,
    Bar = "hello",
    Buzz = buzz123,
    
    ?dump("My foo value is ?Foo and bar value is ?Bar", Buzz, 3*Foo),
    % => example:16: My foo value is 3 and bar value is "hello"; Buzz = buzz123; 3 * Foo = 9

    ?dump("Say $Bar to $Buzz"),
    % => example:19: Say "hello" to buzz123

    ok.


anonymous_function() ->
    Bar = "gravitsapa",
    Fun = fun(Foo, Buzz) -> 
        ?dump("Hello ?Foo! Hello ?Buzz!"),
        % => example:'-anonymous_function/0-fun-0-':33: Hello "Tinki Vinki"! Hello "Po"!

        ?dump(Foo, Buzz, Bar)
        % => example:'-anonymous_function/0-fun-0-':34: Foo = "Tinki Vinki"; Buzz = "Po"; Bar = "gravitsapa"
    end,
    Fun("Tinki Vinki", "Po").


case_clause() ->
    A = 1, B = 1, C = 0,
    Discriminant = B*B - 4*A*C,
    case Discriminant of
        Pos when Pos > 0 -> 
            ?dump("Discriminant is positive (?Discriminant), there are two roots"),
            ?dump("First coefficient is ?A, second is ?B, third is ?C");
        Pos when Pos == 0 -> ?dump("Discriminant is zero, there are one root");
        Pos when Pos < 0 -> ?dump("Discriminant is negative (?Discriminant), there are no roots")
    end.

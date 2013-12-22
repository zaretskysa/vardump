-ifndef(VARDUMP_HRL).
-define(VARDUMP_HRL, true).

-compile({parse_transform, vardump}).


-define(FUN, element(2, element(2, process_info(self(), current_function)))).

-define(_STRINGIFY(Expr), vardump_stringify__(??Expr, Expr)).

-define(_STRINGIFY_LIST(Expr1), 
    [?_STRINGIFY(Expr1)]).
-define(_STRINGIFY_LIST(Expr1, Expr2), 
    [?_STRINGIFY(Expr1), ?_STRINGIFY(Expr2)]).
-define(_STRINGIFY_LIST(Expr1, Expr2, Expr3), 
    [?_STRINGIFY(Expr1), ?_STRINGIFY(Expr2), ?_STRINGIFY(Expr3)]).
-define(_STRINGIFY_LIST(Expr1, Expr2, Expr3, Expr4), 
    [?_STRINGIFY(Expr1), ?_STRINGIFY(Expr2), ?_STRINGIFY(Expr3), ?_STRINGIFY(Expr4)]).
-define(_STRINGIFY_LIST(Expr1, Expr2, Expr3, Expr4, Expr5), 
    [?_STRINGIFY(Expr1), ?_STRINGIFY(Expr2), ?_STRINGIFY(Expr3), ?_STRINGIFY(Expr4), ?_STRINGIFY(Expr5)]).

-define(_CALL_DUMP(Messages), vardump:dumpc(?MODULE, ?FUN, ?LINE, Messages)).
-define(_CALL_DUMPL(Messages), vardump:dumpl(?MODULE, ?FUN, ?LINE, Messages)).

-define(dump(), vardump:dumpc()).
-define(dump(Val1), ?_CALL_DUMP(?_STRINGIFY_LIST(Val1))).
-define(dump(Val1, Val2), ?_CALL_DUMP(?_STRINGIFY_LIST(Val1, Val2))).
-define(dump(Val1, Val2, Val3), ?_CALL_DUMP(?_STRINGIFY_LIST(Val1, Val2, Val3))).
-define(dump(Val1, Val2, Val3, Val4), ?_CALL_DUMP(?_STRINGIFY_LIST(Val1, Val2m Val3, Val4))).
-define(dump(Val1, Val2, Val3, Val4, Val5), ?_CALL_DUMP(?_STRINGIFY_LIST(Val1, Val2m Val3, Val4, Val5))).

-define(dumpl(), vardump:dumpl()).
-define(dumpl(Val1), ?_CALL_DUMPL(?_STRINGIFY_LIST(Val1))).
-define(dumpl(Val1, Val2), ?_CALL_DUMPL(?_STRINGIFY_LIST(Val1, Val2))).
-define(dumpl(Val1, Val2, Val3), ?_CALL_DUMPL(?_STRINGIFY_LIST(Val1, Val2, Val3))).
-define(dumpl(Val1, Val2, Val3, Val4), ?_CALL_DUMPL(?_STRINGIFY_LIST(Val1, Val2m Val3, Val4))).
-define(dumpl(Val1, Val2, Val3, Val4, Val5), ?_CALL_DUMPL(?_STRINGIFY_LIST(Val1, Val2m Val3, Val4, Val5))).


-endif. % VARDUMP_HRL


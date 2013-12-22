-module(vardump).

-export([
    parse_transform/2,
    dumpc/0,
    dumpc/4,
    dumpl/0,
    dumpl/4
    ]).


parse_transform(Forms, _Options) ->
    lists:map(fun stringify_vars/1, Forms).

dumpc() ->
    write_console("").

dumpc(Module, Fun, Line, Messages) ->
    Joined = string:join(Messages, "; "),
    Message = io_lib:format("~p:~p:~p: ~s", [Module, Fun, Line, Joined]),
    write_console(Message).

write_console(Message) ->
    io:format("~s~n", [Message]).

build_message(Module, Fun, Line, Messages) ->
    Joined = string:join(Messages, "; "),
    io_lib:format("~p:~p:~p: ~s", [Module, Fun, Line, Joined]).

dumpl() ->
    write_log("").

dumpl(Module, Fun, Line, Messages) ->
    write_log(build_message(Module, Fun, Line, Messages)).

write_log(Message) ->
    error_logger:info_msg("~s~n", [Message]).


stringify_vars({call, Line1, {atom, _Line2, vardump_stringify__}, [Name, Value] = _Args}) ->
    io_lib_format_call(Line1, Name, Value);

stringify_vars({First}) ->
    {stringify_vars(First)};

stringify_vars({First, Second}) ->
    {stringify_vars(First), stringify_vars(Second)};

stringify_vars({First, Second, Third}) ->
    {stringify_vars(First), stringify_vars(Second), stringify_vars(Third)};

stringify_vars({First, Second, Third, Fourth}) ->
    {
        stringify_vars(First),
        stringify_vars(Second),
        stringify_vars(Third),
        stringify_vars(Fourth)
    };

stringify_vars({First, Second, Third, Fourth, Fifth}) ->
    {
        stringify_vars(First),
        stringify_vars(Second),
        stringify_vars(Third),
        stringify_vars(Fourth),
        stringify_vars(Fifth)
    };

stringify_vars(Form) when is_list(Form) ->
    lists:map(fun stringify_vars/1, Form);

stringify_vars(Form) ->
    Form.


io_lib_format_call(Line, NameForm, ValueForm) ->
    FormatCallForm = {call, Line,
        {remote, Line, {atom, Line, io_lib}, {atom, Line, format}},
        io_lib_format_args(Line, NameForm, ValueForm)
    },
    make_flatten(Line, FormatCallForm).

make_flatten(Line, Form) ->
    {call, Line,
        {remote, Line, {atom, Line, lists}, {atom, Line, flatten}},
        [Form]
    }.

% build message string by substituting var values in format string
io_lib_format_args(Line, _NameForm, {string, Line, Format} = _ValueForm) ->
    Rx = "[\\$|\\?](\\w+)",
    VarsNames = case re:run(Format, Rx, [global, {capture, all_but_first, list}]) of
        {match, Values} -> lists:concat(Values);
        _Other -> []
    end,
    IoLibFormat = re:replace(Format, Rx, "~p", [global, {return, list}]),
    VarFormCreator = fun(VarName) -> {var, Line, list_to_atom(VarName)} end,
    VarsForms = lists:map(VarFormCreator, VarsNames),
    [
        {string, Line, IoLibFormat},
        cons_form(Line, VarsForms)
    ];

% make message string from VarName/VarValue pair
io_lib_format_args(Line, NameForm, ValueForm) ->
    [
        {string, Line, "~s = ~p"},
        cons_form(Line, [NameForm, ValueForm])
    ].


cons_form(Line, []) ->
    {nil, Line};

cons_form(Line, [First | Rest]) ->
    {cons, Line, First, cons_form(Line, Rest)}.

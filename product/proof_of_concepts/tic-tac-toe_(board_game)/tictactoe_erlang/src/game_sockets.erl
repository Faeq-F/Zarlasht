main(_) -> ets:new(globals_table, []), io:fwrite("Hello, World!"), save_sockets_dict(dict:new()), io:fwrite(get_sockets_dict()).



save_sockets_dict(dict) ->
  ets:insert(globals_table, {sockets, dict}).

get_sockets_dict() ->
  [{sockets, dict}] = ets:lookup(globals_table, sockets).
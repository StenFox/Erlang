-module(test).
-author("StenFox").

%% API
-export([main/0]).

getNumber(0,_) -> [];
getNumber(N,M) when N == M -> [];
getNumber(N,M) -> [N | getNumber(N - 1,M)].

getList(N,M) -> [X || X <- getNumber(N - 1,M), N rem X == 0].

getPerfectList(N,M,Pid) -> List = [X || X <- getNumber(N,M), X == lists:sum(getList(X,0))],Pid ! List.

spawner(N,_,K,_) when N =< K -> 0;
spawner(N,Step,0,Pid) -> spawn(fun() -> getPerfectList(Step,0,Pid)end),spawner(N,Step,Step,Pid);
spawner(N,Step,K,Pid) -> spawn(fun() -> getPerfectList(K+Step,K,Pid)end),spawner(N,Step,K+Step,Pid).

display()->
  receive
    Msg-> erlang:display(Msg)
  end,
  display().

main() ->
  spawner(10000,1000,0,spawn(fun()->display()end)).

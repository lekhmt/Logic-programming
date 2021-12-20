% факты, описывающие возможные способы перестановки двух предметов мебели
permutation([0,B,C,D,E,F],[B,0,C,D,E,F]).
permutation([A,0,C,D,E,F],[A,C,0,D,E,F]).
permutation([A,B,C,0,E,F],[A,B,C,E,0,F]).
permutation([A,B,C,D,0,F],[A,B,C,D,F,0]).
permutation([0,B,C,D,E,F],[D,B,C,0,E,F]).
permutation([A,0,C,D,E,F],[A,E,C,D,0,F]).
permutation([A,B,0,D,E,F],[A,B,F,D,E,0]).

% можно ли поменять предметы местами?
move(A,B) :-
    permutation(A,B);
    permutation(B,A).

% предикат продления пути
prolong([X|T],[Y,X|T]) :-
    move(X,Y),
    not(member(Y,[X|T])).

% вывод пути
show_answer([_]) :- !.
show_answer([A,B|Tail]) :-
    show_answer([B|Tail]),
    nl, write(B), write(' -> '),
    write(A).


% основной предикат поиска в глубину
depth_first(X,Y) :-
    depth([X],Y,P),
    show_answer(P).

% рекурсивный предикат поиска в глубину
depth([X|T],X,[X|T]).
depth(P,Y,R) :-
    prolong(P,P1),
    depth(P1,Y,R).

% ?- depth_first(["стол", "стул", "шкаф", "стул", 0, "кресло"], ["стол", "стул", "кресло", "стул", 0, "шкаф"]).


% основной предикат поиска в ширину
breadth_search(X,Y) :-
    breadth([[X]],Y,P),
    show_answer(P).

% рекурсивный предикат поиска в ширину
breadth([[X|T]|_],X,[X|T]).
breadth([P|QI],X,R) :-
    findall(Z,prolong(P, Z), T),
    append(QI,T,QO), !,
    breadth(QO,X,R).
breadth([_|T],Y,L) :- breadth(T,Y,L).

% ?- breadth_search(["стол", "стул", "шкаф", "стул", 0, "кресло"], ["стол", "стул", "кресло", "стул", 0, "шкаф"]).


% основной предикат поиска в глубину с итеративным заглублением
iteration_depth_search(Start,Finish) :-
    search_id(Start,Finish, Way),
    show_answer(Way).

% предикат, генерирующий глубину поиска от 1 и далее
int(1).
int(M) :-
    int(N),
    M is N+1.

% рекурсивный предикат поиска в глубину с итеративным заглублением
search_id(Start,Finish,Path) :-
    int(Limit),
    search_id(Start,Finish,Path,Limit).

search_id(Start,Finish,Path,DepthLimit) :-
    depth_id([Start],Finish,Path,DepthLimit).

depth_id([Finish|T],Finish,[Finish|T],0).
depth_id(Path,Finish,R,N) :-
    N>0,
    prolong(Path,NewPath),
    N1 is N-1,
    depth_id(NewPath,Finish,R,N1).

?- iteration_depth_search(["стол", "стул", "шкаф", "стул", 0, "кресло"], ["стол", "стул", "кресло", "стул", 0, "шкаф"]).
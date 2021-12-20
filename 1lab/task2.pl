% Task 2: Relational Data

% The line below imports the data
:- ['four.pl'].

sum([], S) :- S is 0.
sum([H|T], S) :- sum(T, S0), S is H + S0.


% для каждого студента найти средний балл и сдал ли он экзамены

merge([], []).
merge([H|T], S) :- merge(T, S0), append(H, S0, S).

average(M, N, G) :- findall(X, subject(_, X), GS),
              merge(GS, G0),
              findall(F, member(grade(M, F), G0), G), sum(G, N0),
              findall(K, subject(K, _), S), length(S, S0),
              N is N0/S0.

do_all_average([]).
do_all_average([H|T]) :- write(H), write(": "),
                         average(H, N, G),
                         format('~2f', N),
                         member(2, G) -> write(", не сдал."), nl,
                         do_all_average(T);
                         write(", сдал."), nl,
                         do_all_average(T).

all_average :- findall(X, group(_, X), S0),
               merge(S0, S),
               do_all_average(S).


% для каждого предмета найти количество не сдавших студентов

find_fails_for_subject(S, N) :- subject(S, R),
                                findall(M, member(grade(M, 2), R), O),
                                length(O, N).

do_find_fails([]).
do_find_fails([H|T]) :- write(H), write(": "),
                        find_fails_for_subject(H, N),
                        write(N), write("."), nl,
                        do_find_fails(T).

find_fails :- findall(K, subject(K, _), S),
              do_find_fails(S).


% для каждой группы найти студента с максимальным средним баллом

refactor([], S) :- append([], [], S).
refactor([H|T], S) :- refactor(T, S0), average(H, N, _), append([[H, N]], S0, S).

max(L, R, O) :- L > R -> O is L; O is R.

findmax([], MX) :- MX is 0.
findmax([[_, N]|T], MX) :- findmax(T, MX0),
                           max(N, MX0, MX).

print([]).
print([H|T]) :- write(H), write(" "), print(T).

do_average_group([]).
do_average_group([H|T]) :- write(H), write(": "),
                           group(H, S0),
                           refactor(S0, S),
                           findmax(S, MX),
                           format('~2f', MX),
                           findall(M, member([M, MX], S), O),
                           write(" [ "), print(O), write("]"), nl,
                           do_average_group(T).

average_group :- findall(G, group(G, _), R),
                 do_average_group(R).


?- write("1. Для каждого студента найти средний балл и сдал ли он экзамены"), nl.
?- all_average, nl.
?- write("2. Для каждого предмета найти количество не сдавших студентов"), nl.
?- find_fails, nl.
?- write("3. Для каждой группы найти студента с максимальным средним баллом"), nl.
?- average_group, nl.

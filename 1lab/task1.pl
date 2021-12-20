% вичисление длины списка
length_t([], 0).
length_t([_|Y], N) :- length_t(Y, N1), N is N1 + 1.

% проверка на наличие элемента в списке
member_t(A, [A|_]).
member_t(A, [_|Z]) :- member_t(A, Z).

% конкатенация списков
append_t([], X, X).
append_t([A|X], Y, [A|Z]) :- append(X, Y, Z).

% удаление элемента из списка
remove_t(X, [X|T], T).
remove_t(X, [Y|T], [Y|T1]) :- remove_t(X, T, T1).

% перестановка элементов списка
permute_t([], []).
permute_t(L, [X|T]) :- remove_t(X, L, R), permute_t(R, T).

% выделение подпоследовательности элементов листа
sublist_t(S, L) :- append_t(_, L1, L), append(S, _, L1).

% удаление всех элементов списка по заданному значению
delete_t(_, [], []).
delete_t(X, [X|T], L) :- delete_t(X, T, L).
delete_t(X, [Y|T], [Y|T1]) :- delete_t(X, T, T1).

% удаление всех элементов списка по заданному значению с помощью встроенного предиката
delete_s(X, L, L) :- not(member(X, L)).
delete_s(X, L, R) :- member(X, L), remove_t(X, L, NEW_L), delete_s(X, NEW_L, R), !.

% слияние двух упорядоченных списков
merge_t([], X, X).
merge_t(X, [], X).
merge_t([L|LS], [R|RS], [L|M]) :- merge(LS, [R|RS], M), L < R.
merge_t([L|LS], [R|RS], [R|M]) :- merge([L|LS], RS, M), R =< L.

% разность упорядоченных множеств
minus(L, [], L).
minus(L, [H|T], RS) :- merge_t(L, [H|T], P), delete_t(H, P, R), minus(R, T, RS).

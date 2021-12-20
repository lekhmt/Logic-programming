:- ['data.pl'].

% ЗАДАНИЕ 3

cousin_t(X, M) :- parent(P, X), parent(P1, P), parent(P1, O), P \= O, parent(O, M), sex(M, "M").

% ЗАДАНИЕ 4

% вспомогательные предикаты родства
father(X, Y) :- sex(X, "M"), parent(X, Y).
mother(X, Y) :- sex(X, "F"), parent(X, Y).
son(X, Y) :- sex(X, "M"), parent(Y, X).
daughter(X, Y) :- sex(X, "F"), parent(Y, X).
brother(X, Y) :- sex(X, "M"), parent(Z, X), parent(Z, Y), X \= Y.
sister(X, Y) :- sex(X, "F"), parent(Z, X), parent(Z, Y), X \= Y.
husband(X, Y) :- sex(X, "M"), sex(Y, "F"), parent(X, Z), parent(Y, Z).
wife(X, Y) :- husband(Y, X).
uncle(X, Y) :- parent(Z, Y), brother(X, Z).
aunt(X, Y) :- parent(Z, Y), sister(X, Z).
grandfather(X, Y) :- sex(X, "M"), parent(X, Z), parent(Z, Y).
grandmother(X, Y) :- sex(X, "Y"), parent(X, Z), parent(Z, Y).
grandson(X, Y) :- sex(X, "M"), parent(Z, X), parent(Y, Z).
granddaughter(X, Y) :- sex(X, "F"), parent(Z, X), parent(Y, Z).
cousin(X, Y) :- uncle(Z, X), parent(Z, Y).
cousin(X, Y) :- aunt(Z, X), parent(Z, Y).
nephew(X, Y) :- sex(X, "M"), (aunt(Y, X) ; uncle(Y, X)).
niece(X, Y) :- sex(X, "F"), (aunt(Y, X) ; uncle(Y, X)).


% возможные переходы
move(X, Y, father) :- father(X, Y).
move(X, Y, mother) :- mother(X, Y).
move(X, Y, son) :- son(X, Y).
move(X, Y, daughter) :- daughter(X, Y).
move(X, Y, brother) :- brother(X, Y).
move(X, Y, sister) :- sister(X, Y).
move(X, Y, husband) :- husband(X, Y).
move(X, Y, wife) :- wife(X, Y).
move(X, Y, uncle) :- uncle(X, Y).
move(X, Y, aunt) :- aunt(X, Y).
move(X, Y, grandfather) :- grandfather(X, Y).
move(X, Y, grandmother) :- grandmother(X, Y).
move(X, Y, grandson) :- grandson(X, Y).
move(X, Y, granddaughter) :- granddaughter(X, Y).
move(X, Y, cousin) :- cousin(X, Y).
move(X, Y, nephew) :- nephew(X, Y).
move(X, Y, niece) :- niece(X, Y).


% реализация поиска в глубину с итеративным заглублением
prolong([X|T],[Y,X|T]) :-
    move(X,Y,_),
    not(member(Y,[X|T])).

search_id(Start,Finish,Path,DepthLimit) :-
    depth_id([Start],Finish,Path,DepthLimit).

depth_id([Finish|T],Finish,[Finish|T],0).
depth_id(Path,Finish,R,N) :-
    N>0,
    prolong(Path,NewPath),
    N1 is N-1,
    depth_id(NewPath,Finish,R,N1).

for(A, A, _).
for(X, A, B) :- A < B, A1 is A + 1, for(X, A1, B).

relative(X, Y) :-
    for(Current, 1, 5),
    search_id(X, Y, Path, Current),
    reverse(Path, ReversedPath),
    print_answer(ReversedPath).

reverse([], []).
reverse([X], [X]).
reverse([X|T], R) :-
    reverse(T, RT),
    append(RT, [X], R).

print_answer([X, Y]) :- move(X, Y, R), !, write(R), nl.
print_answer([X, Y|T]) :- move(X, Y, R), !, write(R), write(' of '), print_answer([Y|T]).

% ЗАДАНИЕ 5

% предикат разделения списка на 2 части
split(L, P1, P2) :- append(P1, P2, L), not(length(P1, 0)), not(length(P2, 0)).

% список возможных вопросов
questions(['How many', 'how many', 'Who is', 'who is', 'Is', 'is', 'Who are', 'who are']).
% список возможных родственных связей
relations(['father', 'mother', 'son', 'daughter', 'brother', 'sister', 'husband', 'wife',
    'uncle', 'aunt', 'grandfather', 'grandmother', 'grandson', 'granddaughter', 'cousin',
    'nephew', 'niece']).

% перевод множественного числа в единственное
plural('fathers', 'father').
plural('mothers', 'mother').
plural('sons', 'son').
plural('daughters', 'daughter').
plural('brothers', 'brother').
plural('sisters', 'sister').
plural('husbands', 'husband').
plural('wife', 'wives').
plural('uncles', 'uncle').
plural('aunts', 'aunt').
plural('grandfathers', 'grandfather').
plural('grandmothers', 'grandmother').
plural('grandsons', 'grandson').
plural('granddaughters', 'granddaughter').
plural('cousins', 'cousin').
plural('nephews', 'nephew').
plural('nieces', 'niece').

% предикаты проверки корректности ключевых слов запроса
check_name(N) :- sex(N, _).
check_relative(R) :-
    relations(L),
    member(R, L).
check_question(Q) :-
    questions(L),
    member(Q, L).

% описание грамматических переходов
% phrase -> question + semantic
check_phrase([Q|S], X) :-
    check_question(Q),
    (Q == 'How many' ; Q == 'how many'),
    check_semantic_1(S, X).

check_phrase([Q|S], X) :-
    check_question(Q),
    (Q == 'Who is' ; Q == 'who is'),
    check_semantic_2(S, X).

check_phrase([Q|S], X) :-
    check_question(Q),
    (Q == 'Is' ; Q == 'is'),
    check_semantic_3(S, X).

check_phrase([Q|S], X) :-
    check_question(Q),
    (Q == 'Who are' ; Q == 'who are'),
    check_semantic_4(S, X).

% "how many" semantic -> relative + ... + name + ...
check_semantic_1(S, X) :-
    split(S, [P|_], [P2|_]),
    plural(P, P1),
    check_relative(P1),
    check_name(P2), !,
    append([P1], [P2], X).

% "who is" semantic -> name + "'s" + ... + relation + ...
check_semantic_2(S, X) :-
    split(S, [P1, "'s" |_], [P2|_]),
    check_name(P1),
    check_relative(P2), !,
    append([P1], [P2], X).

% "who is" semantic -> relation + 'for' + ... + name + ...
check_semantic_2(S, X) :-
    split(S, [P1, 'for'|_], [P2|_]),
    check_relative(P1),
    check_name(P2), !,
    append([P2], [P1], X).

% "is" semantic -> name + name + "'s" + ... + relation + ...
check_semantic_3([H|T], X) :-
    check_name(H),
    split(T, [P1, "'s"|_], [P2|_]),
    check_name(P1),
    check_relative(P2), !,
    append([H], [P1], Tmp),
    append(Tmp, [P2], X).

% "is" semantic -> name + relation + "for" + ... + name + ...
check_semantic_3([H|T], X) :-
    check_name(H),
    split(T, [P1, 'for'|_], [P2|_]),
    check_relative(P1),
    check_name(P2), !,
    append([H], [P2], Tmp),
    append(Tmp, [P1], X).

% "who are" semantic -> name + "and" + ... name + ...
check_semantic_4(S, X) :-
    split(S, [P1, 'and'|_], [P2|_]),
    check_name(P1),
    check_name(P2), !,
    append([P1], [P2], X).

% основной предикат запроса
request(X, Y) :- check_phrase(X, MS), analyze(MS, Y).

% "how many", MS = [Relation, Name]
analyze(MS, Y) :-
    MS = [R, Name],
    check_name(Name),
    check_relative(R),
    setof(X, move(X, Name, R), L),
    length(L, Y).

% "who is", MS = [Name, Relation]
analyze(MS, Y) :-
    MS = [X, R],
    check_name(X),
    check_relative(R),
    move(Y, X, R).

% "is", MS = [Name, Name, Relation]
analyze(MS, _) :-
    MS = [X, Y, R],
    move(X, Y, R).

% "who are", MS = [Name, Name]
analyze(MS, Y) :-
    MS = [N1, N2],
    check_name(N1),
    check_name(N2),
    define(N1, N2, Y).

define(N1, N2, Y) :-
    move(N1, N2, R),
    ((R == 'mother', sex(N2, "M"), Y = "mother and son");
    (R == 'mother', sex(N2, "F"), Y = "mother and daughter");
    (R == 'father', sex(N2, "M"), Y = "father and son");
    (R == 'father', sex(N2, "F"), Y = "father and daughter");
    (R == 'son', sex(N1, "M"), Y = "son and father");
    (R == 'son', sex(N1, "F"), Y = "son and mother");
    (R == 'daughter', sex(N1, "M"), Y = "daughter and father");
    (R == 'daughter', sex(N1, "F"), Y = "daughter and mother");
    (R == 'grandmother', sex(N2, "M"), Y = "grandmother and grandson");
    (R == 'grandmother', sex(N2, "F"), Y = "grandmother and granddaughter");
    (R == 'grandfather', sex(N2, "M"), Y = "grandfather and grandson");
    (R == 'grandfather', sex(N2, "F"), Y = "grandfather and granddaughter");
    (R == 'grandson', sex(N1, "M"), Y = "grandson and grandfather");
    (R == 'grandson', sex(N1, "F"), Y = "grandson and grandmother");
    (R == 'granddaughter', sex(N1, "M"), Y = "granddaughter and grandfather");
    (R == 'granddaughter', sex(N1, "F"), Y = "granddaughter and grandmother");
    ((R == 'sister' ; R == 'brother'), Y = "siblings");
    (R == 'husband', Y = "husband and wife");
    (R == 'wife', Y = "wife and husband");
    (R == 'cousin', Y = "cousins");
    (R == 'uncle', sex(N2, "M"), Y = "uncle and nephew");
    (R == 'uncle', sex(N2, "F"), Y = "uncle and niece");
    (R == 'aunt', sex(N2, "M"), Y = "aunt and nephew");
    (R == 'aunt', sex(N2, "F"), Y = "aunt and niece");
    (R == 'nephew', sex(N2, "M"), Y = "nephew and uncle");
    (R == 'nephew', sex(N2, "F"), Y = "nephew and aunt");
    (R == 'niece', sex(N2, "M"), Y = "niece and uncle");
    (R == 'nephew', sex(N2, "F"), Y = "niece and aunt")).


% ?- request(['how many', 'cousins', 'does', "Matvej Leuhin", 'have', '?'], A), write(A).
% ?- request(['Who is', 'mother', 'for', "Matvej Leuhin", '?'], A), write(A).
% ?- request(['is', "Nikolaj Kovalevich", "Matvej Leuhin", "'s", 'grandfather'], _).
% ?- request(['Who are', "Matvej Leuhin", 'and', "Sergej Kovalevich", '?'], A), write(A).

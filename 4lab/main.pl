% Реализовать разбор предложений английского языка. В
% предложениях у объекта (подлежащего) могут быть заданы
% цвет, размер, положение. В результате разбора должны
% получиться структуры представленные в примере.

% Артикли
article("a").
article("A").
article("an").
article("An").
article("the").
article("The").

% Цвета
color("white").
color("black").
color("gray").
color("red").
color("orange").
color("yellow").
color("green").
color("blue").
color("purple").

% Размер
size("big").
size("little").
size("small").
size("tiny").
size("huge").

% Подлежащее
object("book").
object("pen").
object("pencil").
object("cup").
object("table").
object("chair").
object("floor").

preposition("in").
preposition("on").
preposition("under").
preposition("above").
preposition("behind").

verb("is").

location("in", X, in(X)).
location("on", X, on(X)).
location("under", X, under(X)).
location("above", X, above(X)).
location("behind", X, behind(X)).

test(["the", "red", "book", "is", "on", "the", "table"]).
test(["A", "tiny", "cup", "is", "under", "the", "chair"]).
test(["the", "small", "pencil", "is", "black"]).

sentence([X], s(X)).
sentence([X, Y], s(X, Y)).

sentence([A, S, O | T], R) :-
    article(A),
    size(S),
    object(O),
    sentence([object(O, size(S)) | T], R).

sentence([A, C, O | T], R) :-
    article(A),
    color(C),
    object(O),
    sentence([object(O, color(C)) | T], R).

sentence([object(O, size(S)), "is", P, A, O1 | T], R) :-
    object(O1),
    article(A),
    location(P, O1, Location),
    sentence([location(object(O, size(S)), Location) | T], R).

sentence([object(O, color(C)), "is", P, A, O1 | T], R) :-
    object(O1),
    article(A),
    location(P, O1, Location),
    sentence([location(object(O, color(C)), Location) | T], R).

sentence([object(O, size(S)), "is", C | T], R) :-
    color(C),
    sentence([object(O, size(S)), color(C) | T], R).

sentence([object(O, color(C)), "is", S | T], R) :-
    size(S),
    sentence([object(O, color(C)), size(S) | T], R).



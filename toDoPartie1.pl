/* TBox */
concept(T, Q) :- setof(X, cnamena(X), CNAtom), member(T, CNAtom), concept(Q).
/* ABox concepts */
concept(T, Q) :- setof(X, iname(X), Inst), member(T, Inst), concept(Q).
/* ABox roles */
concept(T, U, V) :- setof(X, iname(X), Inst), member(T, Inst), member(U, Inst), setof(X, rname(X), Role), member(V, Role).

concept(and(A, B)) :- concept(A), concept(B).
concept(or(A, B)) :- concept(A), concept(B).
concept(some(A, B)) :- setof(X, rname(X), Role), member(A, Role), concept(B).
concept(all(A, B)) :- setof(X, rname(X), Role), member(A, Role), concept(B).
concept(not(A)) :- concept(A).
concept(A) :- setof(X, cnamea(X), CAtom), member(A, CAtom).

autoref.
traitement_Tbox.
traitement_Abox.

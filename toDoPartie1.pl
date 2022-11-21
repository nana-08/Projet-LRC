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

autoref(Conc, Def, X) :- autoref(Conc, Def, X).
autoref(Conc, _, Conc) :- write(user_error, "Concept auto-referant"), halt.
autoref(Conc, _, X) :- X\==Conc.
autoref(Conc, and(A, B), X) :- autoref(Conc, _, A), autoref(B).


traitement_Tbox([]).
traitement_Tbox([T|Q]) :- traitement_Tbox(Q).
traitement_Abox.

/* ----- CONCEPT ----- */
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
concept(A) :- setof(X, cnamena(X), CNAtom), member(A, CNAtom).


/* ----- AUTOREF ----- */
autoref(Concept, and(A, B)) :- autoref(Concept, A), autoref(Concept, B).
autoref(Concept, or(A, B)) :- autoref(Concept, A, CNA), autoref(Concept, B, CNA).
autoref(Concept, some(_, B)) :- autoref(Concept, B).
autoref(Concept, all(_, B)) :- autoref(Concept, B).
autoref(Concept, not(A)) :- autoref(Concept, A).
autoref(Concept, Concept) :- write(user_error, "Erreur: Concept auto-referant présent dans la TBox d'origine.\n"), halt.
autoref(Concept, A) :- A\==Concept, setof(X, cnamena(X), CNAtom), member(A, CNAtom), setof(A, equiv(A, DefA), _), autoref(Concept, DefA).
autoref(_, A) :- setof(X, cnamea(X), CAtom), member(A, CAtom).


/* ----- NNF (fourni) ----- */
nnf(not(and(C1,C2)),or(NC1,NC2)):- nnf(not(C1),NC1),nnf(not(C2),NC2),!.
nnf(not(or(C1,C2)),and(NC1,NC2)):- nnf(not(C1),NC1),nnf(not(C2),NC2),!.
nnf(not(all(R,C)),some(R,NC)):- nnf(not(C),NC),!.
nnf(not(some(R,C)),all(R,NC)):- nnf(not(C),NC),!.
nnf(not(not(X)),X):-!.
nnf(not(X),not(X)):-!.
nnf(and(C1,C2),and(NC1,NC2)):- nnf(C1,NC1),nnf(C2,NC2),!.
nnf(or(C1,C2),or(NC1,NC2)):- nnf(C1,NC1), nnf(C2,NC2),!.
nnf(some(R,C),some(R,NC)):- nnf(C,NC),!.
nnf(all(R,C),all(R,NC)) :- nnf(C,NC),!.
nnf(X,X).


/* ----- TRAITEMENT TBOX ----- */
remplace(and(A, B), and(NewA, NewB)) :- remplace(A, NewA), remplace(B, NewB).
remplace(or(A, B), or(NewA, NewB)) :- remplace(A, NewA), remplace(B, NewB).
remplace(some(A, B), some(A, NewB)) :- remplace(B, NewB).
remplace(all(A, B), all(A, NewB)) :- remplace(B, NewB).
remplace(not(A), not(NewA)) :- remplace(A, NewA).
remplace(C, C) :- setof(X, cnamea(X), CAtom), member(C, CAtom).
remplace(C, Def) :- setof(X, cnamena(X), CNAtom), member(C, CNAtom), setof(C, equiv(C, DefC), _), remplace(DefC, Def).

traitement_Tbox([], []).
traitement_Tbox([(Concept, Def)|Q], [(Concept, NewDef)|TBox]) :- concept(Concept, Def), autoref(Concept, Def), remplace(Def, NewD), nnf(NewD, NewDef), traitement_Tbox(Q, TBox).


/* ----- TRAITEMENT ABOX ----- */

traitement_Abox([],[],[],[]).
traitement_Abox([(I,C)|Qc],[(I1, I2, R)|Qr],[(I,NewC)|ABoxC],[(I1, I2, R)|ABoxR]) :- concept(I,C), remplace(C, A), nnf(A, NewC), concept(I1, I2, R),traitement_Abox(Qc, Qr, ABoxC, ABoxR).
traitement_Abox([(I,C)|Qc],[],[(I,NewC)|ABoxC],[]) :-concept(I,C), remplace(C, A), nnf(A, NewC),traitement_Abox(Qc, [], ABoxC, []).
traitement_Abox([],[(I1, I2, R)|Qr],[],[(I1, I2, R)|ABoxR]) :-concept(I1, I2, R), traitement_Abox([], Qr, [], ABoxR).



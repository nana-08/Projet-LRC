/* --------- tri_Abox --------- */
tri_Abox([],[],[],[],[],[]).
tri_Abox([(I, some(R,C))|Q],[(I, some(R,C))|Lie],Lpt,Li,Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([(I, all(R,C))|Q],Lie,[(I, all(R,C))|Lpt],Li,Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([(I, and(C1,C2))|Q],Lie,Lpt,[(I, and(C1,C2))|Li],Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([(I, or(C1,C2))|Q],Lie,Lpt,Li,[(I, or(C1,C2))|Lu],Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([A|Q],Lie,Lpt,Li,Lu,[A|Ls]) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).

/* --------- resolution --------- */
resolution(Lie,Lpt,Li,Lu,Ls,Abr) :- complete_some(Lie,Lpt,Li,Lu,Ls,Abr),
                                    transformation_and(Lie,Lpt,Li,Lu,Ls,Abr),
                                    deduction_all(Lie,Lpt,Li,Lu,Ls,Abr),
                                    transformation_or(Lie,Lpt,Li,Lu,Ls,Abr).

/* --------- complete_some --------- */
complete_some([],_,_,_,_,_).
complete_some([(A,some(R,C))|Q],Lpt,Li,Lu,Ls,Abr) :- nl, write(A),write(" : "),write(" ∃ "),write(R),write("."),write(C), nl,genere(B), 
                                            evolue((B,C), Q, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1), 
                                            affiche_evolution_Abox(Ls, [(A,some(R,C))|Q], Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, [(A,B,R)|Abr]),
                                            resolution(Lie1,Lpt1,Li1,Lu1,Ls1,[(A,B,R)|Abr]).  

/* --------- transformation_and --------- */
transformation_and(_,_,[],_,_,_).
transformation_and(Lie,Lpt,[(A,and(C1,C2))|Q],Lu,Ls,Abr) :- nl, write(A),write(" : "),write(C1),write(" ⊓ "),write(C2), nl,
                                            evolue((A,C1),Q, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1), 
                                            evolue((A,C2),Lie1, Lpt1, Li1, Lu1, Ls1, Lie2, Lpt2, Li2, Lu2, Ls2), 
                                            affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls2, Lie2, Lpt2, Li2, Lu2, Abr),
                                            resolution(Lie2,Lpt2,Li2,Lu2,Ls2,Abr).  

/* --------- deduction_all --------- */
deduction_all(_,[],_,_,_,_).
deduction_all(Lie,[(A,all(R,C))|Q],Li,Lu,Ls,Abr) :- member((A,B,R),Abr), nl, write(A),write(" : "),write(" ∀ "),write(R),write("."),write(C), nl,
                                            evolue((B,C), Q, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1), 
                                            affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1,Abr),
                                            resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr).  
deduction_all(Lie,[_|Q],Li,Lu,Ls,Abr) :- resolution(Lie,Q,Li,Lu,Ls,Abr).

/* --------- transformation_or --------- */
transformation_or(_,_,_,[],_,_).
transformation_or(Lie,Lpt,Li,[(A,or(C1,C2))|Q],Ls,Abr) :- nl, write(A),write(" : "),write(C1),write(" ⊔ "),write(C2), nl,
                                            evolue((A,C1),Q, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1), 
                                            evolue((A,C2),Q, Lpt, Li, Lu, Ls, Lie2, Lpt2, Li2, Lu2, Ls2), 
                                            affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, Abr),
                                            affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls2, Lie2, Lpt2, Li2, Lu2, Abr),
                                            resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr),
                                            resolution(Lie2,Lpt2,Li2,Lu2,Ls2,Abr). 

/* --------- clash --------- */
clash((I,C), L) :- nnf(not(C), NonC),nl,nl, member((I, NonC), L), nl, write("Clash ! Impossible de continuer."), nl, break.
clash((I,C), L) :- nnf(not(C), NonC),nl,nl, not(member((I,NonC),L)).

/* --------- evolue --------- */
evolue(A, Lie, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1) :- clash(A,Lie), clash(A,Lpt), 
                                            clash(A,Li), clash(A,Lu), clash(A,Ls),
                                            tri_Abox([A],Lie1,Lpt1,Li1,Lu1,Ls1).

/* --------- affiche_evolution_Abox --------- */
affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, Abr1) :- nl, write("Etat de la A-box au depart:"), nl,
                                            write(Ls), write(Lie), write(Lpt), write(Li), write(Lu), write(Abr), nl,
                                            write("Etat de la A-box après assertion:"), nl,
                                            write(Ls1), write(Lie1), write(Lpt1), write(Li1), write(Lu1), write(Abr1).


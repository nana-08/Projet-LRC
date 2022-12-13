/* --------- tri_Abox --------- */
tri_Abox([],[],[],[],[],[]).
tri_Abox([(I, some(R,C))|Q],[(I, some(R,C))|Lie],Lpt,Li,Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([(I, all(R,C))|Q],Lie,[(I, all(R,C))|Lpt],Li,Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([(I, and(C1,C2))|Q],Lie,Lpt,[(I, and(C1,C2))|Li],Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([(I, or(C1,C2))|Q],Lie,Lpt,Li,[(I, or(C1,C2))|Lu],Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([A|Q],Lie,Lpt,Li,Lu,[A|Ls]) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).

/* --------- resolution --------- */
resolution(Lie,Lpt,Li,Lu,Ls,Abr) :- write("--------- PASSAGE DANS LE NOEUD ∃ ---------"),nl,complete_some(Lie,Lpt,Li,Lu,Ls,Abr),
                                    write("--------- PASSAGE DANS LE NOEUD ⊓ ---------"),nl,transformation_and(Lie,Lpt,Li,Lu,Ls,Abr),
                                    write("--------- PASSAGE DANS LE NOEUD ∀ ---------"),nl,deduction_all(Lie,Lpt,Li,Lu,Ls,Abr),
                                    write("--------- PASSAGE DANS LE NOEUD ⊔ ---------"),nl,transformation_or(Lie,Lpt,Li,Lu,Ls,Abr),
                                    nl,write("Aucun clash n'a été détecté. La proposition initiale n'a pas pu être démontrée."),nl,
                                    write("############ ECHEC ############"),nl,abort.

/* --------- complete_some --------- */
complete_some([],_,_,_,_,_).
complete_some([(A,some(R,C))|Q],Lpt,Li,Lu,Ls,Abr) :- write("# On considère l'assertion  "),write(A),write(" : "),lisibilite(some(R,C)),nl,genere(B), 
                                            evolue((B,C), Q, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1), 
                                            affiche_evolution_Abox(Ls, [(A,some(R,C))|Q], Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, [(A,B,R)|Abr]),
                                            resolution(Lie1,Lpt1,Li1,Lu1,Ls1,[(A,B,R)|Abr]).  

/* --------- transformation_and --------- */
transformation_and(_,_,[],_,_,_).
transformation_and(Lie,Lpt,[(A,and(C1,C2))|Q],Lu,Ls,Abr) :- write("# On considère l'assertion  "),write(A),write(" : "),lisibilite(and(C1,C2)),nl,
                                            evolue((A,C1), Lie, Lpt, Q, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1), 
                                            evolue((A,C2),Lie1, Lpt1, Li1, Lu1, Ls1, Lie2, Lpt2, Li2, Lu2, Ls2), 
                                            affiche_evolution_Abox(Ls, Lie, Lpt, [(A,and(C1,C2))|Q], Lu, Abr, Ls2, Lie2, Lpt2, Li2, Lu2, Abr),
                                            resolution(Lie2,Lpt2,Li2,Lu2,Ls2,Abr).  

/* --------- deduction_all --------- */
deduction_all(_,[],_,_,_,_).
deduction_all(Lie,[(A,all(R,C))|Q],Li,Lu,Ls,Abr) :- member((A,B,R),Abr), write("# On considère l'assertion  "),write(A),write(" : "),lisibilite(all(R,C)),nl,
                                            evolue((B,C), Lie, Q, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1), 
                                            affiche_evolution_Abox(Ls, Lie, [(A,all(R,C))|Q], Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1,Abr),
                                            resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr).  

/* --------- transformation_or --------- */
transformation_or(_,_,_,[],_,_).
transformation_or(Lie,Lpt,Li,[(A,or(C1,C2))|Q],Ls,Abr) :- write("# On considère l'assertion  "),write(A),write(" : "),lisibilite(or(C1,C2)),nl,
                                            evolue((A,C1),Lie, Lpt, Li, Q, Ls, Lie1, Lpt1, Li1, Lu1, Ls1), 
                                            evolue((A,C2),Lie, Lpt, Li, Q, Ls, Lie2, Lpt2, Li2, Lu2, Ls2), 
                                            affiche_evolution_Abox(Ls, Lie, Lpt, Li, [(A,or(C1,C2))|Q], Abr, Ls1, Lie1, Lpt1, Li1, Lu1, Abr),
                                            affiche_evolution_Abox(Ls, Lie, Lpt, Li, [(A,or(C1,C2))|Q], Abr, Ls2, Lie2, Lpt2, Li2, Lu2, Abr),
                                            resolution(Lie1,Lpt1,Li1,Lu1,Ls1,Abr),
                                            resolution(Lie2,Lpt2,Li2,Lu2,Ls2,Abr). 

/* --------- clash --------- */
clash((I,C), L) :- nnf(not(C), NonC),member((I, NonC), L),write("Clash ! Impossible de continuer."), nl, abort.
clash((I,C), L) :- nnf(not(C), NonC),not(member((I,NonC),L)).

/* --------- notation préfixe ---> infixe + symboles --------- */
lisibilite(and(C1,C2)) :- write("("),lisibilite(C1),write(") ⊓ ("),lisibilite(C2),write(")").
lisibilite(or(C1,C2)) :- lisibilite(C1),write(" ⊔ "),lisibilite(C2).
lisibilite(some(R,C)) :- write("∃"),lisibilite(R),write("."),lisibilite(C).
lisibilite(all(R,C)) :- write("∀"),lisibilite(R),write("."),lisibilite(C).
lisibilite(not(F)) :- write("¬"),lisibilite(F).
lisibilite(F) :- write(F).

lisibiliteListe([]).
lisibiliteListe([(I, F)]) :- write(I),write(" : "),lisibilite(F).
lisibiliteListe([(I, F)|Q]) :- write(I),write(" : "),lisibilite(F),write("; "),lisibiliteListe(Q).

lisibiliteAbr([]).
lisibiliteAbr([(A,B,R)]) :- write("< "),write(A),write(", "),write(B),write(" > : "),write(R).
lisibiliteAbr([(A,B,R)|Q]) :- write("< "),write(A),write(", "),write(B),write(" > : "),write(R),write("; "),lisibiliteAbr(Q).

/* --------- evolue --------- */
evolue(A, Lie, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1) :- clash(A,Lie),clash(A,Lpt),clash(A,Li),clash(A,Lu),clash(A,Ls),
                                            concatene([],Lie,Lie1),concatene([],Lpt,Lpt1),concatene([],Li,Li1),concatene([],Lu,Lu1),concatene([],Ls,Ls1),
                                            tri_Abox([A],Lie1,Lpt1,Li1,Lu1,Ls1).

/* --------- affiche_evolution_Abox --------- */
affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, Abr1) :- write("# ETAT DE LA ABOX AVANT INSERTION :"), nl,
                                            write("Ls = ["),lisibiliteListe(Ls),write("] ; "),
                                            write("Lie = ["),lisibiliteListe(Lie),write("] ; "),
                                            write("Lpt = ["),lisibiliteListe(Lpt),write("] ; "),
                                            write("Li = ["),lisibiliteListe(Li),write("] ; "),
                                            write("Lu = ["),lisibiliteListe(Lu),write("] ; "),
                                            write("Abr = ["),lisibiliteAbr(Abr),write("] "),nl,nl,
                                            write("# ETAT DE LA ABOX APRES INSERTION :"), nl,
                                            write("Ls = ["),lisibiliteListe(Ls1),write("] ; "),
                                            write("Lie = ["),lisibiliteListe(Lie1),write("] ; "),
                                            write("Lpt = ["),lisibiliteListe(Lpt1),write("] ; "),
                                            write("Li = ["),lisibiliteListe(Li1),write("] ; "),
                                            write("Lu = ["),lisibiliteListe(Lu1),write("] ; "),
                                            write("Abr = ["),lisibiliteAbr(Abr1),write("]"),nl,nl.


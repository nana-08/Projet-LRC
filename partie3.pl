/* --------- tri_Abox --------- */
tri_Abox([],[],[],[],[],[]).
tri_Abox([(I, some(R,C))|Q],[(I, some(R,C))|Lie],Lpt,Li,Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([(I, all(R,C))|Q],Lie,[(I, all(R,C))|Lpt],Li,Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([(I, and(C1,C2))|Q],Lie,Lpt,[(I, and(C1,C2))|Li],Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([(I, or(C1,C2))|Q],Lie,Lpt,Li,[(I, or(C1,C2))|Lu],Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).
tri_Abox([A|Q],Lie,Lpt,Li,Lu,[A|Ls]) :- tri_Abox(Q,Lie,Lpt,Li,Lu,Ls).


/* --------- resolution --------- */
resolution(Lie,Lpt,Li,Lu,Ls,Abr) :- nl,write("------------------------"),nl,write("PASSAGE DANS LE NOEUD ∃"),nl,write("------------------------"),nl,nl,complete_some(Lie,Lpt,Li,Lu,Ls,Abr),
                                   nl,write("------------------------"),nl,write("PASSAGE DANS LE NOEUD ⊓"),nl,write("------------------------"),nl,nl,transformation_and(Lie,Lpt,Li,Lu,Ls,Abr),
                                    nl,write("------------------------"),nl,write("PASSAGE DANS LE NOEUD ∀"),nl,write("------------------------"),nl,nl,deduction_all(Lie,Lpt,Li,Lu,Ls,Abr),
                                    nl,write("------------------------"),nl,write("PASSAGE DANS LE NOEUD ⊔"),nl,write("------------------------"),nl,nl,transformation_or(Lie,Lpt,Li,Lu,Ls,Abr),
                                    nl,write("Aucun clash n'a été détecté. La proposition initiale n'a pas pu être démontrée."),nl,
                                    write("############ ECHEC ############"),nl,abort.


/* --------- complete_some --------- */
complete_some([],_,_,_,_,_).
complete_some([(A,some(R,C))|Q],Lpt,Li,Lu,Ls,Abr) :-write("# On considère l'assertion  "),write(A),write(" : "),lisibilite(some(R,C)),nl,genere(B),
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
clash((I,C), L) :- nnf(not(C), NonC),member((I, NonC), L),write("Clash ! Impossible d'ajouter à l'ABox la négation de la proposition."),nl,
                                            write("SUPER ! La proposition initiale est démontrée !"),nl,write("############ SUCCES ############"),nl, abort.
clash((I,C), L) :- nnf(not(C), NonC),not(member((I,NonC),L)).


/* --------- notation préfixe ---> infixe + symboles --------- */
lisibilite(and(C1,C2)) :- write("("),lisibilite(C1),write(") ⊓ ("),lisibilite(C2),write(")").
lisibilite(or(C1,C2)) :- lisibilite(C1),write(" ⊔ "),lisibilite(C2).
lisibilite(some(R,C)) :- write("∃"),write(R),write("."),lisibilite(C).
lisibilite(all(R,C)) :- write("∀"),write(R),write("."),lisibilite(C).
lisibilite(not(F)) :- write("¬"),lisibilite(F).
lisibilite(F) :- write(F).

lisibiliteListe([]).
lisibiliteListe([(I, F)]) :- write(I),write(" : "),lisibilite(F).
lisibiliteListe([(I, F)|Q]) :- write(I),write(" : "),lisibilite(F),write("; "),lisibiliteListe(Q).

lisibiliteAbr([]).
lisibiliteAbr([(A,B,R)]) :- write("< "),write(A),write(", "),write(B),write(" > : "),write(R).
lisibiliteAbr([(A,B,R)|Q]) :- write("< "),write(A),write(", "),write(B),write(" > : "),write(R),write("; "),lisibiliteAbr(Q).


/* --------- evolue --------- */
evolue((I, some(R,C)), Lie, Lpt, Li, Lu, Ls, [(I,some(R,C))|Lie], Lpt, Li, Lu, Ls) :- clash((I, some(R,C)),Lie).
evolue((I, all(R,C)), Lie, Lpt, Li, Lu, Ls, Lie, [(I, all(R,C))|Lpt], Li, Lu, Ls) :- clash((I, all(R,C)),Lpt).
evolue((I, and(R,C)), Lie, Lpt, Li, Lu, Ls, Lie, Lpt, [(I, and(R,C))|Li], Lu, Ls) :- clash((I, and(R,C)),Li).
evolue((I, or(R,C)), Lie, Lpt, Li, Lu, Ls, Lie, Lpt, Li, [(I, or(R,C))|Lu], Ls) :- clash((I, or(R,C)),Lu).
evolue(A, Lie, Lpt, Li, Lu, Ls, Lie, Lpt, Li, Lu, [A|Ls]) :- clash(A,Ls).


/* --------- affiche_evolution_Abox --------- */
affiche_evolution_Abox(Ls, Lie, Lpt, Li, Lu, Abr, Ls1, Lie1, Lpt1, Li1, Lu1, Abr1) :- nl,nl,write("--------- # ETAT DE LA ABOX AVANT INSERTION : ---------"),nl,nl,
                                            write("Ls = ["),lisibiliteListe(Ls),write("]"),nl,
                                            write("Lie = ["),lisibiliteListe(Lie),write("]"),nl,
                                            write("Lpt = ["),lisibiliteListe(Lpt),write("]"),nl,
                                            write("Li = ["),lisibiliteListe(Li),write("]"),nl,
                                            write("Lu = ["),lisibiliteListe(Lu),write("]"),nl,
                                            write("Abr = ["),lisibiliteAbr(Abr),write("]"),nl,nl,
                                            write("--------- # ETAT DE LA ABOX APRES INSERTION : ---------"),nl,nl,
                                            write("Ls = ["),lisibiliteListe(Ls1),write("]"),nl,
                                            write("Lie = ["),lisibiliteListe(Lie1),write("]"),nl,
                                            write("Lpt = ["),lisibiliteListe(Lpt1),write("]"),nl,
                                            write("Li = ["),lisibiliteListe(Li1),write("]"),nl,
                                            write("Lu = ["),lisibiliteListe(Lu1),write("]"),nl,
                                            write("Abr = ["),lisibiliteAbr(Abr1),write("]"),nl,nl.


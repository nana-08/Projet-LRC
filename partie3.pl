/* --------- tri_Abox --------- */
tri_Abox([],Lie,Lpt,Li,Lu,Ls).
tri_Abox([(I, some(R,C))|Q],Lie,Lpt,Li,Lu,Ls) :- tri_Abox(Q, [(I, some(R,C))|Lie],Lpt,Li,Lu,Ls).
tri_Abox([(I, all(R,C))|Q],Lie,Lpt,Li,Lu,Ls) :- tri_Abox(Q,Lie,[(I, all(R,C))|Lpt],Li,Lu,Ls).
tri_Abox([(I, and(C1,C2))|Q],Lie,Lpt,Li,Lu,Ls) :- tri_Abox(Q,Lie,Lpt,[(I, and(C1,C2))|LI],Lu,Ls).
tri_Abox([(I, or(C1,C2))|Q],Lie,Lpt,Li,Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,[(I, or(C1,C2))|Lu],Ls).
tri_Abox([A|Q],Lie,Lpt,Li,Lu,Ls) :- tri_Abox(Q,Lie,Lpt,Li,Lu,[A|Ls]).

/* --------- resolution --------- */
resolution(Lie,Lpt,Li,Lu,Ls,Abr) :- complete_some(Lie,Lpt,Li,Lu,Ls,Abr),
                                    transformation_and(Lie,Lpt,Li,Lu,Ls,Abr),
                                    deduction_all(Lie,Lpt,Li,Lu,Ls,Abr),
                                    transformation_or(Lie,Lpt,Li,Lu,Ls,Abr).

/* --------- complete_some --------- */
complete_some([],Lpt,Li,Lu,Ls,Abr).
complete_some([(A,some(R,C))|Q],Lpt,Li,Lu,Ls,Abr) :- genere(B), resolution(Q,Lpt,Li,Lu,[(B,C)|Ls],[(A,B,R)|Abr]).  

/* --------- transformation_and --------- */
transformation_and(Lie,Lpt,[],Lu,Ls,Abr).
transformation_and(Lie,Lpt,[(A,and(C1,C2))|Q],Lu,Ls,Abr) :- resolution(Q,Lpt,Q,Lu,[(A,C1),(A,C2)|Ls],Abr).  

/* --------- deduction_all --------- */
deduction_all(Lie,[(A,all(R,C))|Q],Li,Lu,Ls,Abr) :- member((A,B,R),Abr), resolution(Lie,Q,Li,Lu,[(B,C)|Ls],Abr).  

/* --------- transformation_or --------- */
transformation_or(Lie,Lpt,Li,[(A,or(C1,C2))|Q],Ls,Abr) :- resolution(Lie,Lpt,Li,Q,[(A,C1)|Ls]), resolution(Lie,Lpt,Li,Q,[(A,C2)|Ls]).  

/* --------- evolue --------- */
evolue(A, Lie, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1) :- resolution(Lie1,Lpt1,Li1,Lu1,Ls1).

/* --------- affiche_evolution_Abox --------- */
affiche_evolution_Abox(Ls1, Lie1, Lpt1, Li1, Lu1, Abr1, Ls2, Lie2,
Lpt2, Li2, Lu2, Abr2).
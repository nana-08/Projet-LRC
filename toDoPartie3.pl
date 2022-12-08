compteur(1).

troisieme_etape(Abi,Abr):-tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls), resolution(Lie,Lpt,Li,Lu,Ls,Abr),nl,write("Youpiiiii, on a démontré la proposition initiale !!!").

/* --------- tri_Abox --------- */
tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls).

/* --------- resolution --------- */
resolution(Lie,Lpt,Li,Lu,Ls,Abr).

/* --------- complete_some --------- */
complete_some(Lie,Lpt,Li,Lu,Ls,Abr).  

/* --------- transformation_and --------- */
transformation_and(Lie,Lpt,Li,Lu,Ls,Abr).  

/* --------- deduction_all --------- */
deduction_all(Lie,Lpt,Li,Lu,Ls,Abr).  

/* --------- transformation_or --------- */
transformation_or(Lie,Lpt,Li,Lu,Ls,Abr).  

/* --------- evolue --------- */
evolue(A, Lie, Lpt, Li, Lu, Ls, Lie1, Lpt1, Li1, Lu1, Ls1).

/* --------- affiche_evolution_Abox --------- */
affiche_evolution_Abox(Ls1, Lie1, Lpt1, Li1, Lu1, Abr1, Ls2, Lie2,
Lpt2, Li2, Lu2, Abr2).
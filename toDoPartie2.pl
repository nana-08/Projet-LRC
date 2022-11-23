programme :-premiere_etape(Tbox,Abi,Abr),deuxieme_etape(Abi,Abi1,Tbox),troisieme_etape(Abi1,Abr).

/* --------- PARTIE 1 --------- */

premiere_etape(Tbox,Abi,Abr):- traitement_Tbox(Tbox, NewTbox),traitement_Abox(Abi,Abr,ABoxC,ABoxR).

/* --------- PARTIE 2 --------- */

deuxieme_etape(Abi,Abi1,Tbox):-saisie_et_traitement_prop_a_demontrer(Abi,Abi1,Tbox).

saisie_et_traitement_prop_a_demontrer(Abi,Abi1,Tbox) :-nl,write('Entrez le numero du type de proposition que vous voulez demontrer :'),nl,
write('1 Une instance donnee appartient a un concept donne.'),nl,write('2 Deux concepts n"ont pas d"elements en commun(ils ont une intersection vide).'),nl, read(R), suite(R,Abi,Abi1,Tbox).

suite(1,Abi,Abi1,Tbox) :-acquisition_prop_type1(Abi,Abi1,Tbox),!.
suite(2,Abi,Abi1,Tbox) :-acquisition_prop_type2(Abi,Abi1,Tbox),!.
suite(R,Abi,Abi1,Tbox) :-nl,write('Cette reponse est incorrecte.'),nl,saisie_et_traitement_prop_a_demontrer(Abi,Abi1,Tbox).

/* acquisition_prop_type1 */

acquisition_prop_type1([],[],Tbox).
acquisition_prop_type1([A|B],[D|Abi1],Tbox):-recursivite(not(A),Newprop),nnf(Newprop,D),acquisition_prop_type1(B,Abi1,Tbox).

recursivite([],[]).
recursivite([X|Q],[NewRes|Res]):-remplace(X,NewRes),recursivite(Q,Res).

/* acquisition_prop_type1 */
acquisition_prop_type2([],[],Tbox).
acquisition_prop_type2([(C1,C2)|B],[D|Abi1],Tbox):-recursivite(and(C1,C2),Newprop),nnf(Newprop,D),acquisition_prop_type2(B,Abi1,Tbox).

/* --------- PARTIE 3 --------- */

troisieme_etape(Abi1,Abr).


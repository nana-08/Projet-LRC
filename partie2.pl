saisie_et_traitement_prop_a_demontrer(Abi,Abe,Tbox) :- nl, write('Entrez le numero du type de proposition que vous voulez demontrer :'), nl,
write('1 Une instance donnee appartient a un concept donne.'), nl, write('2 Deux concepts n"ont pas d"elements en commun(ils ont une intersection vide).'),
nl, read(R), suite(R,Abi,Abe,Tbox).

suite(1,Abi,Abe,Tbox) :- acquisition_prop_type1(Abi,Abe,Tbox),!.
suite(2,Abi,Abe,Tbox) :- acquisition_prop_type2(Abi,Abe,Tbox),!.
suite(_,Abi,Abe,Tbox) :- nl, write('Cette reponse est incorrecte.'),nl,saisie_et_traitement_prop_a_demontrer(Abi,Abe,Tbox).


/* acquisition_prop_type1 */

acquisition_prop_type1(Abi,[(I, NotC)|Abi],_) :- nl, write("Entrez l'instance :"), nl, read(I), nl, write("Entrez le concept :"), nl, read(C),
                                        remplace(C, NewC), nnf(not(NewC), NotC),
                                        write("--------- ON VEUT DEMONTRER LA PROPOSITION :  "),write(I),write(" : "),lisibilite(C),nl,nl,
                                        write("On ajoute à la ABox l'assertion suivante : "),write(I),write(" : "),lisibilite(NotC),nl,nl.

/* acquisition_prop_type2 */

/* generation d'un nouvel identificateur d'instance instance */

concatene([],L1,L1).
concatene([X|Y],L1,[X|L2]) :- concatene(Y,L1,L2).

genere(Nom) :- compteur(V),nombre(V,L1),concatene([105,110,115,116],L1,L2),V1 is V+1,dynamic(compteur/1),retract(compteur(V)),
        dynamic(compteur/1),assert(compteur(V1)),name(Nom,L2).

nombre(0,[]).
nombre(X,L1) :- R is (X mod 10), Q is ((X-R)//10), chiffre_car(R,R1), char_code(R1,R2), nombre(Q,L), concatene(L,[R2],L1).

chiffre_car(0,'0').
chiffre_car(1,'1').
chiffre_car(2,'2').
chiffre_car(3,'3').
chiffre_car(4,'4').
chiffre_car(5,'5').
chiffre_car(6,'6').
chiffre_car(7,'7').
chiffre_car(8,'8').
chiffre_car(9,'9').

acquisition_prop_type2(Abi,[(I, C1etC2)|Abi],_):- genere(I), nl, write("Entrez C1 :"), nl, read(C1), nl, write("Entrez C2 :"), nl, read(C2),
                                            remplace(C1, NewC1), remplace(C2, NewC2), nnf(and(NewC1, NewC2), C1etC2),nl,nl,
                                            write("--------- ON VEUT DEMONTRER LA PROPOSITION : "),write("("),lisibilite(C1),write(") ⊓ ("),lisibilite(C2),write(") ⊑ ⊥"),nl,nl,
                                            write("On ajoute à la ABox l'assertion suivante : "),nl,write(I),write(" : "),lisibilite(C1etC2),nl,nl.



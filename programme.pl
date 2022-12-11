compteur(1).

premiere_etape(Tbox,Abi,Abr) :- 
                traitement_Tbox([(sculpteur,and(personne,some(aCree,sculpture))),
                    (auteur,and(personne,some(aEcrit,livre))),
                    (editeur,and(personne,and(not(some(aEcrit,livre)),some(aEdite,livre)))),
                    (parent,and(personne,some(aEnfant,anything))),
                    (parentAuteur, and(parent, auteur))], Tbox), 
                traitement_Abox([(michelAnge,personne), 
                    (david,sculpture), 
                    (sonnets,livre),
                    (vinci,personne), 
                    (joconde,objet),
                    (lovecraft, auteur),
                    (cthulhu, livre),
                    (pierre, parent),
                    (pierre, editeur)],[(michelAnge, david, aCree), 
                                        (michelAnge, sonnets, aEcrit),
                                        (vinci,joconde, aCree),
                                        (lovecraft, cthulhu, aEcrit)],Abi,Abr).

deuxieme_etape(Abi,Abe,Tbox) :- saisie_et_traitement_prop_a_demontrer(Abi,Abe,Tbox).

troisieme_etape(Abi,Abr) :- tri_Abox(Abi,Lie,Lpt,Li,Lu,Ls), 
                            resolution(Lie,Lpt,Li,Lu,Ls,Abr),
                            nl,write("Youpiiiii, on a démontré la proposition initiale !!!").

programme(Abe) :-   premiere_etape(Tbox,Abi,Abr), 
                    deuxieme_etape(Abi,Abe,Tbox),
                    troisieme_etape(Abe,Abr).
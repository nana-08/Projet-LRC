equiv(sculpteur,and(personne,some(aCree,sculpture))).
equiv(auteur,and(personne,some(aEcrit,livre))).
equiv(editeur,and(personne,and(not(some(aEcrit,livre)),some(aEdite,livre)))).
equiv(parent,and(personne,some(aEnfant,anything))).

cnamea(personne).
cnamea(livre).
cnamea(objet).
cnamea(sculpture).
cnamea(anything).
cnamea(nothing).

cnamena(auteur).
cnamena(editeur).
cnamena(sculpteur).
cnamena(parent).

iname(michelAnge).
iname(david).
iname(sonnets).
iname(vinci).
iname(joconde).

rname(aCree).
rname(aEcrit).
rname(aEdite).
rname(aEnfant).

inst(michelAnge,personne).
inst(david,sculpture).
inst(sonnets,livre).
inst(vinci,personne).
inst(joconde,objet).

instR(michelAnge, david, aCree).
instR(michelAnge, sonnets, aEcrit).
instR(vinci, joconde, aCree).

/* T-Box */
[(sculpteur,and(personne,some(aCree,sculpture))),
(auteur,and(personne,some(aEcrit,livre))),
(editeur,and(personne,and(not(some(aEcrit,livre)),some(aEdite,livr
e)))),
(parent,and(personne,some(aEnfant,anything)))]

/* A-Box */
[(michelAnge,personne), (david,sculpture), (sonnets,livre),
(vinci,personne), (joconde,objet)]
[(michelAnge, david, aCree), (michelAnge, sonnet, aEcrit),(vinci,
joconde, aCree)]

setof(Motif, But, Liste).
/* setof/3 crée une liste des instantiations de Motif par retours arrières sur But et unifie le
résultat dans Liste. Si le But n’a pas de solution, setof retournera la liste vide []. Il y a
suppression des doublons. */
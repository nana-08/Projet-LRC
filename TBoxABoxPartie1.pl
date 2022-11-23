equiv(sculpteur,and(personne,some(aCree,sculpture))).
equiv(auteur,and(personne,some(aEcrit,livre))).
equiv(editeur,and(personne,and(not(some(aEcrit,livre)),some(aEdite,livre)))).
equiv(parent,and(personne,some(aEnfant,anything))).
/* equiv(sculpture, and(objet, all(creePar, sculpteur))). test autoref */
equiv(parentAuteur, and(parent, auteur)).

/* identificateurs des concepts atomiques */
cnamea(personne).
cnamea(livre).
cnamea(objet).
cnamea(sculpture).
cnamea(anything).
cnamea(nothing).

/* identificateurs des concepts non atomiques */
cnamena(auteur).
cnamena(editeur).
cnamena(sculpteur).
/* cnamena(sculpture). test autoref */
cnamena(parent).
cnamena(parentAuteur).

/* identificateurs des instances */
iname(michelAnge).
iname(david).
iname(sonnets).
iname(vinci).
iname(joconde).
iname(lovecraft).
iname(cthulhu).

/* identificateurs des rôles */
rname(aCree).
/* rname(creePar). test autoref */
rname(aEcrit).
rname(aEdite).
rname(aEnfant).

/* instantiations de concepts */
inst(michelAnge,personne).
inst(david,sculpture).
inst(sonnets,livre).
inst(vinci,personne).
inst(joconde,objet).
inst(lovecraft, auteur).
inst(cthulhu, livre).

/* instantiations de rôles */
instR(michelAnge, david, aCree).
instR(michelAnge, sonnets, aEcrit).
instR(vinci, joconde, aCree).
instR(lovecraft, cthulhu, aEcrit).

/*
T-Box
[(sculpteur,and(personne,some(aCree,sculpture))),
(auteur,and(personne,some(aEcrit,livre))),
(editeur,and(personne,and(not(some(aEcrit,livre)),some(aEdite,livre)))),
(parent,and(personne,some(aEnfant,anything))),
(parentAuteur, and(parent, auteur))].

A-Box
assertions de concepts
[(michelAnge,personne), 
(david,sculpture), 
(sonnets,livre),
(vinci,personne), 
(joconde,objet),
(lovecraft, auteur),
(cthulhu, livre)].
assertions de rôles
[(michelAnge, david, aCree), 
(michelAnge, sonnets, aEcrit),
(vinci,joconde, aCree),
(lovecraft, cthulhu, aEcrit)].
*/
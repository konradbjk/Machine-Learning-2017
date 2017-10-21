/*-----------------------------------------------------------------*/
/* VS                                                              */
/* Mitchell's bi-directional search strategy in the version space  */
/*-----------------------------------------------------------------*/
/*  Copyright (c) 1988 Luc De Raedt                                */
/*  This program is free software; you can redistribute it and/or  */
/*  modify it under the terms of the GNU General Public License    */
/*  Version 1 as published by the Free Software Foundation.        */
/*-----------------------------------------------------------------*/
/*  Batch mode added and SWI-Prolog adaptated, Zdravko Markov 2004 */
/*-----------------------------------------------------------------*/
/*  References:   Generalization as Search,                        */
/*                Tom Mitchell,                                    */
/*                Artificial Intelligence  18, 1982.               */
/*                                                                 */
/*                Machine Learning, Tom Mitchell, McGraw Hill,     */
/*                1997, Chapter 2.                                 */
/*-----------------------------------------------------------------*/

/*-----------------------------------------------------------------*/
/* Interactive mode: ?- vs.                                        */
/*-----------------------------------------------------------------*/
/* "vs" learns a concept, beginning with only one example and      */
/* asking for the classification of further examples, which it     */
/* constructs itself or are specified by the user.                 */
/* Examples are specified as list of values, e.g. [red, square].   */
/* The first example must be positive (p).                         */
/*                                                                 */
/* NOTE that all values must appear as leaves in a taxonomy loaded */
/* in the database as facts "son" (see the file taxonomy.pl).      */
/*                                                                 */
/* NOTE also that all input must end with a FULL STOP (.).         */
/* This applies to examples, classes (p or n) and answers y or n.  */
/*-----------------------------------------------------------------*/

/*-----------------------------------------------------------------*/
/* Batch mode: ?- batch.                                           */
/*-----------------------------------------------------------------*/
/* In this mode the examples must be loaded in the Prolog database */
/* represented as facts in two possible formats:                   */
/*                                                                 */
/* 1. example(Id,Class,[V1,V2,...,Vn]).                            */
/*    The examples in the file shapes.pl are in this format        */
/*                                                                 */
/* 2. example(Id,Class,[A1=V1,A2=V2,...,An=Vn]).                   */
/*    The examples in the file animals.pl are in this format       */
/*                                                                 */
/* NOTE 1: All values Vn should appear as leaves in a taxonomy     */
/* defined as a set of facts son(Son,Parent). See the file         */
/* taxonomy.pl for an example.                                     */
/*                                                                 */
/* NOTE 2: The class of the first example in the database (as in   */
/* the file) is assumed to be the positive calss (+ or p). All     */
/* examples from other classes are consireder as negative (- or n).*/
/*-----------------------------------------------------------------*/

/*-------------- Batch mode ---------------------------------------*/
batch :- 
     findall(Vs/C,(example(_,C,L),get_vals(L,Vs)),[First/Pos|Es]),
     initialize(First,G,S),
     write(+),writeln(First),
     write('G-set: '), writeln(G),
     write('S-set: '), writeln(S),
     vs(G,S,Es,Pos), !.
batch :-
     writeln('Impossible to generate relevant examples').

vs([],_,_,_) :-
     writeln('There is no consistent concept description in this language !'), !.
vs(_,[],_,_) :-
     writeln('There is no consistent concept description in this language !'), !.
vs([CONCEPT],[CONCEPT],_,_) :- !,
     writeln('The consistent generalization is: '), writeln(CONCEPT).
vs(_,_,[],_) :- !,
     writeln('No more examples.').
vs(G,S,[Ex/C|Examples],Pos) :-
     (C=Pos,CLASS=p,write(+); CLASS=n,write(-)), !,
     writeln(Ex),
     adjust_versionspace(CLASS,Ex,G,S,NG,NS),
     (NG==G,NS==S,true;
      write('G-set: '), writeln(NG),
      write('S-set: '), writeln(NS)
     ), !,
     vs(NG,NS,Examples,Pos).

/*----------------- Interactive mode -----------------------------*/
vs :-
     writeln('Type the first positive example: '),
     read_ex(POS_EX),
     nl,
     initialize(POS_EX,G,S),
     versionspace(G,S).

/*----------------------------------------------------------------*/
/*  Call:         versionspace (+G_SET,+S_SET)                    */
/*  Arguments:    G_SET = Set of most general concepts            */
/*                S_SET = Set of most special concepts            */
/*----------------------------------------------------------------*/
/* Succeeds if there is a consistent concept, which               */
/* is in the versionspace between g and s it will ask for the     */
/* classification of examples, which it generates.                */
/*----------------------------------------------------------------*/
versionspace([],_) :-
     writeln('There is no consistent concept description in this language !'),
     !.
versionspace(_,[]) :-
     writeln('There is no consistent concept description in this language !'),
     !.
versionspace([CONCEPT],[CONCEPT]) :-
     ! ,
     writeln('The consistent generalization is: '),
     writeln(CONCEPT).
versionspace(G,S) :-
     write('G-set: '),
     writeln(G),
     write('S-set: '),
     writeln(S),
     nl,
     get_next_example(G,S,NEXT_EX,CLASS),
     adjust_versionspace(CLASS,NEXT_EX,G,S,NG,NS),
     versionspace(NG,NS).
versionspace(_,_) :-
     writeln('Impossible to generate relevant examples').

get_next_example(_,_,NEXT_EX,CLASS) :-
     write('Generate next example (y/n) ? '),
     read_ans(y,n,YN), YN=n, !,
     write('Type the example: '), nl,
     read_ex(NEXT_EX),
     write('Classification of the example ? [p/n] '),
     read_ans(p,n,CLASS),
     nl.
get_next_example(G,S,NEXT_EX,CLASS) :-
     write('Next example: '),
     generate_ex(G,S,NEXT_EX),
     ! ,
     writeln(NEXT_EX),
     write('Classification of the example ? [p/n] '),
     read_ans(p,n,CLASS),
     nl.

/*----------------------------------------------------------------*/
/*  Call:         adjust_versionspace(+CLASSIFICATION,            */
/*                                    +EXAMPLE,                   */
/*                                    +G_SET,                     */
/*                                    +S_SET,                     */
/*                                    -UPDATED_S_SET,             */
/*                                    -UPDATED_G_SET)             */
/*  Arguments:    CLASSIFICATION = of the example p for positive  */
/*                                 or n for negative              */
/*                EXAMPLE        = the example itself             */
/*                G_SET          = the actual G-set               */
/*                S_SET          = the actual S-set               */
/*                UPDATED_G_SET  = the updated G-set              */
/*                UPDATED_S_SET  = the updated S-set              */
/*----------------------------------------------------------------*/
/* Succeeds if UPDATED_G_SET and UPDATED_S_SET specify the updated*/
/* versionspace of G_SET and S_SET wrt EXAMPLE and CLASSIFICATION.*/
/*----------------------------------------------------------------*/
adjust_versionspace(p,EX,G,S,NG,NS) :-
     retain_g(G,NG,EX),
     generalize_s(S,S1,NG,EX),
     prune_s(S1,NS).
adjust_versionspace(n,EX,G,S,NG,NS) :-
     retain_s(S,NS,EX),
     specialize_g(G,G1,NS,EX),
     prune_g(G1,NG).

/*----------------------------------------------------------------*/
/*  Call:         retain_g(+G_SET,-UPDATED_G_SET,+EXAMPLE)        */
/*  Arguments:    G_SET          = the actual G-set               */
/*                UPDATED_G_SET  = the updated G-set              */
/*                EXAMPLE        = the example itself             */
/*----------------------------------------------------------------*/
/* Succeeds if UPDATED_G_SET lists the elements of G_SET          */
/* which cover the EXAMPLE                                        */
/*----------------------------------------------------------------*/
retain_g([],[],_) :- ! .
retain_g([CONCEPT|G],[CONCEPT|NG],EX) :-
     covers(CONCEPT,EX),
     ! ,
     retain_g(G,NG,EX).
retain_g([_|G],NG,EX) :-
     retain_g(G,NG,EX).

/*----------------------------------------------------------------*/
/*  Call:         retain_s(+S_SET,-UPDATED_S_SET,+EXAMPLE)        */
/*  arguments:    S_SET          = the actual S-set               */
/*                UPDATED_S_SET  = the updated S-set              */
/*                EXAMPLE        = the example itself             */
/*----------------------------------------------------------------*/
/* Succeeds if UPDATED_S_SET lists the elements of S_SET          */
/* which do not cover the EXAMPLE                                 */
/*----------------------------------------------------------------*/
retain_s([],[],_) :- ! .
retain_s([CONCEPT|S],[CONCEPT|NS],EX) :-
     \+ covers(CONCEPT,EX),
     !,
     retain_s(S,NS,EX).
retain_s([_|S],NS,EX) :-
     retain_s(S,NS,EX).

/*----------------------------------------------------------------*/
/*  Call:         generalize_s(+S_SET,-UPDATED_S_SET,             */
/*                             +G_SET,+EXAMPLE)                   */
/*  arguments:    S_SET          = the actual S-set               */
/*                UPDATED_S_SET  = the updated S-set              */
/*                G_SET          = the actual G-set               */
/*                EXAMPLE        = the example itself             */
/*----------------------------------------------------------------*/
/* Succeeds if UPDATED_S_SET lists the minimal                    */
/* generalizations of the elements in S_SET wrt EXAMPLE such that */
/* there is an element in G_SET which is more general.            */
/*----------------------------------------------------------------*/
generalize_s(S,NS,NG,EX) :-
     setof(NCON,CON^(member(CON,S),
                 valid_least_generalization(CON,EX,NCON,NG)),
           NS), !.
generalize_s(_,[],_,_).

/*----------------------------------------------------------------*/
/*  Call:         generalize_g(+G_SET,-UPDATED_G_SET,             */
/*                             +S_SET,+EXAMPLE)                   */
/*  Arguments:    G_SET          = the actual G-set               */
/*                UPDATED_G_SET  = the updated G-set              */
/*                S_SET          = the actual S-set               */
/*                EXAMPLE        = the example itself             */
/*----------------------------------------------------------------*/
/* Succeeds if UPDATED_G_SET lists the greatest                   */
/* specializations of the elements in G_SET wrt EXAMPLE such that */
/* there is an element in S_SET which is more specific.           */
/*----------------------------------------------------------------*/
specialize_g(G,NG,NS,EX) :-
     setof(NCONCEPT,
           CONCEPT^(member(CONCEPT,G),
            valid_greatest_specialization(CONCEPT,EX,NCONCEPT,NS)),
          NG), !.
specialize_g(_,[],_,_).
/*----------------------------------------------------------------*/
/*  Call:         valid_least_generalization(+CONCEPT,+EXAMPLE,   */
/*                                           -GENERALIZATION,     */
/*                                           +G_SET)              */
/*  Arguments:    CONCEPT        = concept description            */
/*                EXAMPLE        = the example itself             */
/*                GENERALIZATION = a new generalization           */
/*                G_SET          = the actual G-set               */
/*----------------------------------------------------------------*/
/* Succeeds if GENERALIZATION is a                                */
/* least generalization of EXAMPLE and CONCEPT such that there is */
/* an element in G_SET which is more general than GENERALIZATION  */
/*----------------------------------------------------------------*/
valid_least_generalization(CONCEPT,EX,NCONCEPT,NG) :-
     least_generalization(CONCEPT,EX,NCONCEPT),
     member(GENERAL,NG),
     more_general(GENERAL,NCONCEPT).

/*----------------------------------------------------------------*/
/*  Call:       valid_greatest_specialization(+CONCEPT,+EXAMPLE,  */
/*                                            -SPECIALIZATION,    */
/*                                             +S_SET)            */
/*  Arguments:    CONCEPT        = concept description            */
/*                EXAMPLE        = the example itself             */
/*                SPECIALIZATION = a new specialization           */
/*                S_SET          = the actual S-set               */
/*----------------------------------------------------------------*/
/* Succeeds if SPECIALIZATION is a greatest specialization of     */
/* CONCEPT wrt EXAMPLE such that there is an element in S_SET     */
/* which is more specific than SPECIALIZATION                     */
/*----------------------------------------------------------------*/
valid_greatest_specialization(CONCEPT,EX,NCONCEPT,NS) :-
     greatest_specialization(CONCEPT,EX,NCONCEPT),
     member(SPECIFIC,NS),
     more_general(NCONCEPT,SPECIFIC).

/*----------------------------------------------------------------*/
/*  Call:         prune_s(+S_SET,-PRUNED_S_SET)                   */
/*  arguments:    S_SET          = the actual S-set               */
/*                PRUNED_S_SET   = the pruned S-set               */
/*----------------------------------------------------------------*/
/* Succeeds if PRUNED_S_SET is the set of non-redundant           */
/* elements in S_SET. An element is non-redundant if there is no  */
/* element in S_SET which is more specific. PRUNE_S using an      */
/* accumulating parameter to store intermediate results.          */
/*----------------------------------------------------------------*/
prune_s(S,NS) :-
     prune_s_acc(S,S,NS).
prune_s_acc([],_,[]) :- ! .
prune_s_acc([SPECIFIC|S],ACC,NS) :-
     member(SPECIFIC1,ACC),
     SPECIFIC1 \== SPECIFIC,
     more_general(SPECIFIC,SPECIFIC1 ),
     ! ,
     prune_s_acc(S,ACC,NS).
prune_s_acc([SPECIFIC|S],ACC,[SPECIFIC|NS]) :-
     prune_s_acc(S,ACC,NS).

/*----------------------------------------------------------------*/
/*  Call:         prune_s(+G_SET,-PRUNED_G_SET)                   */
/*  Arguments:    G_SET          = the actual G-set               */
/*                PRUNED_G_SET   = the pruned G-set               */
/*----------------------------------------------------------------*/
/* Succeeds if PRUNED_G_SET is the set of non-redundant           */
/* elements in G_SET an element is non-redundant if there is no   */
/* element in G_SET which is more general. PRUNE_G using an       */
/* accumulating parameter to store intermediate results.          */
/*----------------------------------------------------------------*/
prune_g(G,NG) :-
     prune_g_acc(G,G,NG).
prune_g_acc([],_,[]) :- ! .
prune_g_acc([GENERAL|G],ACC,NG) :-
     member(GENERAL1,ACC),
     GENERAL \== GENERAL1,
     more_general(GENERAL1,GENERAL),
     ! ,
     prune_g_acc(G,ACC,NG).
prune_g_acc([GENERAL|G],ACC,[GENERAL|NG]) :-
     prune_g_acc(G,ACC,NG).

/*----------------------------------------------------------------*/
/* GENERATION OF EXAMPLES                                         */
/*----------------------------------------------------------------*/
/*  Call:         allcovers(+CONCEPT_LIST,+EXAMPLE)               */
/*  Arguments:    CONCEPT_LIST = list of concepts                 */
/*                EXAMPLE      = the actual example               */
/*----------------------------------------------------------------*/
/* Succeeds if all elements of CONCEPT_LIST cover EXAMPLE         */
/*----------------------------------------------------------------*/
allcovers([],_) :- ! .
allcovers([CON|REST],EX) :-
     covers(CON,EX),
     allcovers(REST,EX).

/*----------------------------------------------------------------*/
/*  Call:         generate_ex(+G_SET,+S_SET,+EXAMPLE)             */
/*  Arguments:    G_SET   = the actual G-set                      */
/*                S_SET   = the actual S-set                      */
/*                EXAMPLE = the actual example                    */
/*----------------------------------------------------------------*/
/* Succeeds if EXAMPLE is a relevant example. A relevant example  */
/* is one whose classification cannot be derived from s and g     */
/*----------------------------------------------------------------*/
generate_ex([GENERAL|_],S,EX) :-
     find_ex(GENERAL,EX),
     \+ allcovers(S,EX).
generate_ex([_|G],S,EX) :-
     generate_ex(G,S,EX).

/*----------------------------------------------------------------*/
/*  Call:         find_ex(+CONCEPT,+EXAMPLE)                      */
/*  Arguments:    CONCEPT = general concept                       */
/*                EXAMPLE = the actual example                    */
/*----------------------------------------------------------------*/
/* Succeeds if EXAMPLE is an example in the language of  the      */
/* versionspace such that it is covered by the element in EXAMPLE */
/*----------------------------------------------------------------*/
find_ex([],[]) :- ! .
find_ex([GENERAL|G],[LEAF|EX]) :-
     isa(LEAF,GENERAL),
     leaf(LEAF),
     find_ex(G,EX).

/*----------------------------------------------------------------*/
/* REPRESENTATION LANGUAGE DEPENDENT PREDICATES                   */
/*----------------------------------------------------------------*/
/*----------------------------------------------------------------*/
/*  Call:         initialize(+EXAMPLE,-G_SET,-S_SET)              */
/*  Arguments:    EXAMPLE = the positive example                  */
/*                G_SET   = initial G-set                         */
/*                S_SET   = initial S-set                         */
/*----------------------------------------------------------------*/
/* Succeeds if G_SET is the g-set and S_SET is the s-set derived  */
/* from the positive example                                      */
/*----------------------------------------------------------------*/
initialize(POS_EX,[TOP],[POS_EX])  :-
     max(TOP,POS_EX).

/*----------------------------------------------------------------*/
/*  Call:         covers(+CONCEPT,+EXAMPLE)                       */
/*  Arguments:    CONCEPT = concept description                   */
/*                EXAMPLE = example                               */
/*----------------------------------------------------------------*/
/* Succeeds if CONCEPT covers EXAMPLE                             */
/*----------------------------------------------------------------*/
covers([],[]) .
covers([C|CONCEPT],[E|EXAMPLE]) :-
     isa(E,C),
     covers(CONCEPT,EXAMPLE).

/*----------------------------------------------------------------*/
/*  Call:      least_generalization(+CONCEPT1,+EXAMPLE,-CONCEPT2) */
/*  Arguments: CONCEPT1 = concept description                     */
/*             EXAMPLE  = example                                 */
/*             CONCEPT2 = concept description                     */
/*----------------------------------------------------------------*/
/* Succeeds if CONCEPT2 is the least generalization of CONCEPT1   */
/* and CONCEPT2                                                   */
/*----------------------------------------------------------------*/
least_generalization([],[],[]) .
least_generalization([CONCEPT|C],[EX|E],[NCONCEPT|N]) :-
     lge(CONCEPT,EX,NCONCEPT),
     least_generalization(C,E,N).

/*----------------------------------------------------------------*/
/*  Call:   greatest_specialization(+CONCEPT1,+EXAMPLE,-CONCEPT2) */
/*  Arguments: CONCEPT1 = concept description                     */
/*             EXAMPLE  = example                                 */
/*             CONCEPT2 = concept description                     */
/*----------------------------------------------------------------*/
/* Succeeds if CONCEPT2 is the greatest specialization of         */
/* CONCEPT1 and CONCEPT2                                          */
/*----------------------------------------------------------------*/
greatest_specialization([CONCEPT|C],[EX|_],[NCONCEPT|C]) :-
     gsp(CONCEPT,EX,NCONCEPT).
greatest_specialization([CONCEPT|C],[_|E],[CONCEPT|N]) :-
     greatest_specialization(C,E,N).

/*----------------------------------------------------------------*/
/*  Call:         more_general(+CONCEPT1,+CONCEPT2)               */
/*  Arguments:    CONCEPT1 = concept description                  */
/*                CONCEPT2 = concept description                  */
/*----------------------------------------------------------------*/
/* Succeeds if CONCEPT1 is more general than CONCEPT2             */
/*----------------------------------------------------------------*/
more_general(CONCEPT1,CONCEPT2) :-
     covers(CONCEPT1,CONCEPT2).

/*----------------------------------------------------------------*/
/* AUXILIARY PREDICATES                                           */
/*----------------------------------------------------------------*/
/*----------------------------------------------------------------*/
/*  Call:         max(+CONCEPT,+EXAMPLE)                          */
/*  Arguments:    CONCEPT = concept description                   */
/*                EXAMPLE = example                               */
/*----------------------------------------------------------------*/
/* Succeeds if CONCEPT is a most general concept description      */
/* which covers EXAMPLE                                           */
/*----------------------------------------------------------------*/
max([],[]) :- ! .
max([TOP|T],[EX|E]) :-
     top1(TOP,EX),
     max(T,E).

/*----------------------------------------------------------------*/
/*  Call:        top1(+CONCEPT,+EXAMPLE)                          */
/*  Arguments:    CONCEPT = concept description                   */
/*                EXAMPLE = example                               */
/*----------------------------------------------------------------*/
/* succeeds if CONCEPT is a most general concept description      */
/* which covers EXAMPLE in a taxonomy                             */
/*----------------------------------------------------------------*/
top1(TOP,EX) :-
     isa(EX,TOP),
     \+ son(TOP,_).

/*----------------------------------------------------------------*/
/*  Call:         leaf(+X)                                        */
/*  Arguments:    X = leaf of a taxonomy                          */
/*----------------------------------------------------------------*/
/* Succeeds if X is a leaf in the taxonomy                        */
/*----------------------------------------------------------------*/
leaf(X) :-
     \+ son(_,X).

/*----------------------------------------------------------------*/
/*  Call:         isa(X,Y)                                        */
/*  Arguments:    X = knot of a taxonomy                          */
/*                Y = knot of a taxonomy                          */
/*----------------------------------------------------------------*/
/* Inheritance                                                    */
/*----------------------------------------------------------------*/
isa(X,X) .
isa(X,Y) :-
     son(X,Z),
     isa(Z,Y).

/*----------------------------------------------------------------*/
/*  Call:         lge(X,Y,Z)                                      */
/*  Arguments:    X = knot of a taxonomy                          */
/*                Y = knot of a taxonomy                          */
/*                Z = knot of a taxonomy                          */
/*----------------------------------------------------------------*/
/* Succeeds if Z is least generalization of X and Y in a taxonomy */
/*----------------------------------------------------------------*/
lge(X1,X2,X1) :-
     isa(X2,X1),
     ! .

lge(X1,X2,L) :-
     son(X1,F),
     lge(F,X2,L).

/*----------------------------------------------------------------*/
/*  Call:         gsp(X,Y,Z)                                      */
/*  Arguments:    X = knot of a taxonomy                          */
/*                Y = knot of a taxonomy                          */
/*                Z = knot of a taxonomy                          */
/*----------------------------------------------------------------*/
/* Succeeds if Z is greatest specialization of X and Y in a       */
/* taxonomy.                                                      */
/*----------------------------------------------------------------*/
gsp(X1,X2,X1) :-
     \+ isa(X2,X1),
     ! .

gsp(X1,X2,G) :-
     son(S,X1),
     gsp(S,X2,G).

/*----------------------------------------------------------------*/
read_ex(EX) :-
     repeat,
     read(EX),
     check_ex(EX), !.

check_ex([]) :- !.
check_ex([X|T]) :- 
     clause(son(X,_),true), !,
     check_ex(T).
check_ex([X|T]) :- 
     clause(son(_,X),true), !,
     check_ex(T).
check_ex([X|_]) :-
     write(X),
     write(' is not defined!'),nl,
     write('Type the example again: '),
     !, fail.
check_ex(_) :-
     write('Wrong format! The example must be a list of values.'),nl,
     write('Type the example again: '),
     fail.

read_ans(X,Y,ANS) :-
     repeat,
     read(ANS),
     check_ans(X,Y,ANS), !.

check_ans(X,_,X) :- !.
check_ans(_,X,X) :- !.
check_ans(X,Y,Z) :-
    write(Z), write(' is unknown. Type '),
    write(X),write(' or '),write(Y), write(': '),
    fail.

/*----------------------------------------------------------------*/

get_vals([],[]) :- !.
get_vals([_=V|T],[V|L]) :- !,
    get_vals(T,L).
get_vals([V|T],[V|L]) :-
    get_vals(T,L).

/*----------------------------------------------------------------*/

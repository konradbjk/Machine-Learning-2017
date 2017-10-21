
example(1, mammal,   [has_covering=hair,     milk=t, homeothermic=t, habitat=land, eggs=f, gills=f]).
example(2, mammal,   [has_covering=none,     milk=t, homeothermic=t, habitat=sea,  eggs=f, gills=f]).
example(3, mammal,   [has_covering=hair,     milk=t, homeothermic=t, habitat=sea,  eggs=t, gills=f]).
example(4, mammal,   [has_covering=hair,     milk=t, homeothermic=t, habitat=air,  eggs=f, gills=f]).
example(5, fish,     [has_covering=scales,   milk=f, homeothermic=f, habitat=sea,  eggs=t, gills=t]).
example(6, reptile,  [has_covering=scales,   milk=f, homeothermic=f, habitat=land, eggs=t, gills=f]).
example(7, reptile,  [has_covering=scales,   milk=f, homeothermic=f, habitat=sea,  eggs=t, gills=f]).
example(8, bird,     [has_covering=feathers, milk=f, homeothermic=t, habitat=air,  eggs=t, gills=f]).
example(9, bird,     [has_covering=feathers, milk=f, homeothermic=t, habitat=land, eggs=t, gills=f]).
example(10,amphibian,[has_covering=none,     milk=f, homeothermic=f, habitat=land, eggs=t, gills=f]).

/* Convert nominal attributes into structural (for vs.pl)              */

/* Make sure only one of the following taxonomies is not commented     */
/* In fact, there must be as many taxonomies as attributes, but if no  */
/* experiment generation is used, they all can share the root node (?) */

/* Use this taxonomy if no experiment generation is used  */
son(hair,?).
son(none,?).
son(scales,?).
son(feathers,?).

son(land,?).
son(sea,?).
son(air,?).

son(t,?).
son(f,?).


/* Use this taxonomy if experiment generation is used 

son(hair,any_covering).
son(none,any_covering).
son(scales,any_covering).
son(feathers,any_covering).

son(land,any_habitat).
son(sea,any_habitat).
son(air,any_habitat).

son(t,any_value).
son(f,any_value).
*/
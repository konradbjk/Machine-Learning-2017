/*-------------------------------------------------------------------*/
/* EXAMPLE TAXONOMIES                                                */
/* Note that the actual taxonomies are defined with the facts "son". */
/* The pictures below are Prolog comment (not used by Prolog)        */
/*-------------------------------------------------------------------*/
/*
               color
         ________|________
        |                 |
      mono               poly
  ______|________        __|__
 |   |     |     |      |     |
red blue white black  orange pink


                            shape
               _______________|_______________
              |                               |
           polygon                           oval
     _________|_______                        |
    |                 |                       |
 3-sided           4-sided                    |
    |          _______|________            ___|____
    |         |       |        |          |        |
triangle  rectangle square trapezoid    circle  ellipse

*/
son(mono,color).
son(poly,color).
son(red,mono).
son(blue,mono).
son(white,mono).
son(black,mono).
son(orange,poly).
son(pink,poly).

son(polygon,shape).
son(oval,shape).
son(3-sided,polygon).
son(4-sided,polygon).
son(triangle,3-sided).
son(rectangle,4-sided).
son(square,4-sided).
son(trapezoid,4-sided).
son(circle,oval).
son(ellipse,oval).

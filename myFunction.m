function [IndexX,IndexY] = myFunction(M,V)
   % Funkcja poszukująca wartości V w macierzy M
   % Funkcja zwraca indeksy znalezionej wartości, lub -1,-1
   [rows,cols] = size(M);
   IndexX = IndexY =-1; 
   for i=1:rows,
     for j=1:cols
       if M(i,j) == V
         IndexX = i;
         IndexY = j;
         return;
       endif
     end
   end
end

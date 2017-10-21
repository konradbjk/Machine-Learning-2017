function h = findS(X,C)
    %h is the searched hypotestit
    %X is a training set, where each rows contain one training set
    %Function should implement the findS algorithm:
    %1. Initialize h to the most specific hypotesis in H
    %2. For each positive training instance x
    %      For each attribute constraint a_i in h
    %        If the constraint a_i is satisfied by x, then do nothing
    %        Else replace a_i in h by the next more general constraint that is satisfied by x
    %3. Return h

    %YOUR CODE HERE
xL=length(X);
cL=length(C);
[N,M]=size(X);
h=zeros(1,xL);

for a=1:cL
 if C(a)== 1
  for b=1:M
   if h(b) == 0
    h(b)=X(a,b);
   elseif X(a,b) != h(b) && h(b) != Inf
    h(b)=Inf;
   endif
  end
 endif
end


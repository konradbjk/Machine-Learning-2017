A=zeros(10,10);
v=zeros(10,1);
x=zeros(10,1);
tic,
for i = 1:10
  for j = 1:10 
    x(i) = v(i) + A(i, j) * v(j); 
  end
end,toc
tic,x=v .+ A*v,toc


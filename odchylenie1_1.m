tic,
x=rand(1,10^8);
N=length(x);
u=mean(x);
odchylenie=sqrt((sum((x.-u).^2))/(N-1)),toc




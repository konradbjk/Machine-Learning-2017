x=rand(5);
N=length(x);
u1=mean(x(1,:));
u2=mean(x(2,:));
u3=mean(x(3,:));
odchylenie1=sqrt((sum((x(1,:).-u1).^2))/(N-1))
odchylenie2=sqrt((sum((x(2,:).-u2).^2))/(N-1))
odchylenie3=sqrt((sum((x(3,:).-u3).^2))/(N-1))

timestart = time();
x=rand(1,10^6);
N=length(x);
u=mean(x);
odchylenie=sqrt((sum((x.-u).^2))/(N-1))
timestop = time();
printf('Czas wykonania to %d sekund.\n',(timestop-timestart));



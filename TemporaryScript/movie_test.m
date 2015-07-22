clear;
n=30;
M=moviein(n);
t=1:100;
for i=1:30
    x4=0.54-0.46*cos(pi/i*t);
    plot(t,x4);
    M(:,i)=getframe;
end
movie(M,-5);
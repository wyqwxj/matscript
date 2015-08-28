close;
clear all;
t=[[-20:0.1:-eps],[eps:0.1:20]];
x1=sinc(t);
figure;
h=animatedline;
%axis([1 403 -0.4 1.4]);
for i = 0:100
    x2=zeros(1,202);
    x2(101+ i)=1;
    x2(101-  i)=1;
    Y=conv(x2,x1);
    clearpoints(h);
    addpoints(h,[1:size(Y,2)],Y);
    pause(0.2);
end
    

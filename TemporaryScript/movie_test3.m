clear
close all;
num=4000;
x=linspace(0,1000,num);
x4=0.54-0.46*cos(pi*x);
figure
h=animatedline(x,x4);
drawnow;
grid on;

for i=1:1000
    clearpoints(h);
    x4=0.54-0.46*cos(pi/i*x);
    addpoints(h,x,x4);
    pause(0.1);
    drawnow update
end


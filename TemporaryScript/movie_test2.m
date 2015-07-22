t=1:100;
x4=0.54-0.46*cos(pi*t);
h=plot(t,x4,'EraseMode','xor');
for i=1:0.1:100
    x4=0.54-0.46*cos(pi/i*t);
    set(h,'ydata',x4);
    pause(0.1);
    drawnow update
end

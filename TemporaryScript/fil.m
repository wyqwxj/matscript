clear;
close all;
subplot(211);
h1=animatedline('Color','r');
axis([0,1,0,1.5]);
subplot(212);
h2=animatedline;
axis([0,1,-3,0]);
ww=(([0:1000])/1000);
H=zeros(1,501);
for i=0:1000;
    clearpoints(h1);
    clearpoints(h2);
    M=10+i;
    n=[-M:M];
    n(n==0)=eps;
    wc=0.5*pi;
    
    for w=1:1001
        q=((w-1)/1000)*pi;
        H(w)=sum(((sin(wc*n))./(pi*n)).*exp(-1i*q*n));
    end
    Hr=abs(H);
    %addpoints(h1,ww,Hr);
    %plot(ww,Hr);
    %subplot(212);
    %plot(ww,unwrap(angle(H)/(2*pi)));
    addpoints(h1,ww,Hr);
    addpoints(h2,ww,unwrap(angle(H)));
    drawnow update;
    pause(0.04)
end

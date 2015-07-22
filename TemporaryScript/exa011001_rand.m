clear 
clear figure

% N=5000;
% u=rand(1,N);
% u_mean=mean(u);
% power_u=var(u);
% subplot(211)
% plot(u(1:100));grid on;
% subplot(212)
% hist(u,50);grid on;
%

%
N=500;p1=1;p2=0.1;f=1/8;Mlag=60;
u=randn(1,N);u2=u*sqrt(p2);n=[0:N-1];
s=sin(2*pi*f*n);
x1=u(1:N)+s;rx1=xcorr(x1,Mlag,'biased');
subplot(211);
plot(rx1);hold on;
u2=u*sqrt(p2);x2=u2(1:N)+s;
rx2=xcorr(x2,Mlag,'biased');
subplot(212);
plot(rx2);hold off


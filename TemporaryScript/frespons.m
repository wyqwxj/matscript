clc;
close all;
n=-1:3;x=1:5;
k=0:500;w=(pi/500)*k;
X=x*(exp(-1i*pi/500)).^(n'*k);
magX=abs(X);angX=angle(X);
subplot(2,1,1);plot(w/pi,magX);title('幅度响应');grid;
ylabel('幅度');xlabel('以\pi为单位的频率');
subplot(2,1,2);plot(w/pi,angX);title('相位响应');grid;
ylabel('相位/\pi');xlabel('以\pi为单位的频率');
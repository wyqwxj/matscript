close all;
N=100;
n=[0:N-1];
h=0.54-0.46*cos(2*pi*n/(N-1));
plot(abs(fft(h)));

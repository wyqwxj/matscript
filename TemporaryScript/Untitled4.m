n=0:2000; 
H=zeros(1000);
for n1=1:1000
H(n1)=sum(0.8.^n.*cos(0.01*n).*exp(-1j*n*(2*pi)*(n1/1000)));
end
subplot(311);
plot(abs(H));
subplot(312);
w=linspace(0,2*pi,1000);
H1=(1-0.8*exp(-1j*w).*cos(0.01))./(1-2*0.8*exp(-1i*w).*cos(0.01)+0.8^2*exp(-2j*w));
plot(abs(H1));

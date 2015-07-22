n=0:11;
H=zeros(1,1000);
%xn=cos(n*pi/6);
for N=1:1000
    H(N)=sum(cos(n*pi/6).*exp(-1i*n*(N/1000)*2*pi)); %DTFT
end
subplot(311);
plot(abs(H));
subplot(312);
n1=1:1000;
w=(n1/1000)*(2*pi);
H1=exp(-1i*6*w).*cos(6*w).*(2-sqrt(3)*exp(-1i*w))./(1-sqrt(3)*exp(-1i*w)-exp(-2i*w)); %may be the answer is wrong
plot(abs(H1));
Xk=zeros(1,size(n,2));
for k=n
    Xk(k+1)=sum(cos(n*pi/6).*exp(-1i*2*(pi/12)*n*k)); %DFT
end
subplot(313);
stem(abs(Xk));


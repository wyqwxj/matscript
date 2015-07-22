close all;
result=zeros(1,100);
for n=1:100
    result(n)=exp(j*2*pi*n/3);
end
plot(result,'*r');
grid on;
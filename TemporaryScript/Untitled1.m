N=100;
sum=0;
for n=1:N
    sum=sum+exp((1i*2*pi/N)*6*(n-1));
end
disp('sum=');disp(abs(sum));
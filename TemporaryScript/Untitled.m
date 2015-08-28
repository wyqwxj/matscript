close all;
xx=0:0.001:2;
y3=(7.4/2.7)*xx;
y4=(2.8465*xx)-0.1121;
figure;
plot(xx, y3);
hold on;
plot(xx, y4);
legend('Theoretical','Actual measurement');
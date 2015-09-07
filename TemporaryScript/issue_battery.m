close;
A=  [4.35   4.346   4.274   4.184   4.103    4.053    4.023   3.991   3.935   3.756];
B1=[10.29 30.106 55.63   81.75   107.87  133.99  160.11 186.23 212.35 238.47];
B2=[0        0.65     11.103 32.117 42.623  63.637  74.143 74.143 95.157 168.703];
D= B1 - B2;
plot(A,B1);
hold on;
plot(A,B2);
plot(A,D,'--');
for i = 1:size(D,2)
    text(A(i)+0.01, D(i)+6, ['(' ,num2str(A(i)),',' ,num2str(D(i)),')'])
    plot(A(i),D(i), 'r*');
end
legend('充电曲线','放电曲线','偏差');
grid on;
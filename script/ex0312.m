close;
A = 10;
T = 20;
f0 = 1/T;
omega0 = 2*pi/f0;
figure;
h = animatedline;
X=zeros(1,101);
kk = -50:50;
for i = 1000:-1:1
    tao = T * i / 1000;
    for k = kk
        if k~=0
            X( k+51 ) = A * tao/T * sin( k*pi*f0*tao ) ./ ( k*pi*f0*tao );
        else
            X( k+51 ) = A * tao/T ;
        end
    end
    clearpoints(h);
    %addpoints(h,kk,X);
    stem(kk,X);
    %pause(0.1);
    drawnow update
end
%��tao = T ʱ�� �൱��һ��ֱ���źŵĸ���Ҷ������ΪƵ���еĳ弤�ź�
%��tao �ӽ���0ʱ �� �൱�����弤�źŵĸ���Ҷ���� ��Ƶ����Ϊֱ���ź�

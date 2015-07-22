clear;
x0=0;               %给出x(0|0)，初始状态向量
p0=0;               %给出p(0|0)，初始方差
o=0.98;             %给出转移阵φ
q=0.9;              %给出系统噪声w(k)的方差
b=0.9;              %给出干扰阵G
r=[3,3,3,3,3];
%r=[4,5.6,7.2,6.45,3.1];             %给出观测噪声v(k+1)的方差
c=[0.98,0.98,0.98,0.98,0.98];
ll=50;              
N=5;
m=100;


H=c';
R=diag(r);
for k=1:ll
    w=sqrt(q)*randn(1);  %给出系统噪声w(k)
    %集中式
     cd_x=0;
     cd_p=0;
     cdfa_e=0;
     %分步滤波
     af_x=0;
     af_p=0;
     fafss_e=0;
  for j=1:m

   if k==1
       x(k)=o*x0+b*w;
       for i=1:N
           v(i)=sqrt(r(i))*randn(1);  %给出观测噪声v(k+1)
           z(k,i)=c(i)*x(k)+v(i);
       end 
   %分布滤波过程---1
     for i=1:N                                                                                    
       if i==1 
        x_yc(k,i)=o*x0;                 %计算预测值
        p_yc(k,i)=o*p0*o'+b*q*b';   %计算预测误差协方差阵
        K(k,i)=p_yc(k,i)*c(i)'*inv(c(i)*p_yc(k,i)*c(i)'+r(i)); %计算增益阵
        x_gj(k,i)=x_yc(k,i)+K(k,i)*(z(k,i)-c(i)*x_yc(k,i));  %计算估计值
        p_gj(k,i)=(1-K(k,i)*c(i))*p_yc(k,i);   %计算估计误差协方差阵
       else
        x_yc(k,i)=x_gj(k,i-1);
        p_yc(k,i)=p_gj(k,i-1);
        K(k,i)=p_yc(k,i)*c(i)'*inv(c(i)*p_yc(k,i)*c(i)'+r(i));
        x_gj(k,i)=x_yc(k,i)+K(k,i)*(z(k,i)-c(i)*x_yc(k,i));
        p_gj(k,i)=(1-K(k,i)*c(i))*p_yc(k,i);
       end
     end
      
   %集中式滤波过程
      zz=[z(k,1);z(k,2);z(k,3);z(k,4);z(k,5)];
      xc_yc(k)=o*x0;
      pc_yc(k)=o*p0*o'+b*q*b';
      kc=pc_yc(k)*H'*inv(H*pc_yc(k)*H'+R);
      xc_gj(k)=xc_yc(k)+kc*(zz-H*xc_yc(k));
      pc_gj(k)=(1-kc*H)*pc_yc(k);
  else
        x(k)=o*x(k-1)+b*w;
        for i=1:N
           v(i)=sqrt(r(i))*randn(1);  %给出观测噪声v(k+1)
           z(k,i)=c(i)*x(k)+v(i);
        end
      %分步滤波过程---2
      for i=1:N                                                                                         
       if i==1 
        p_yc(k,i)=o*p_z(k-1)*o'+b*q*b';     %计算预测值
        x_yc(k,i)=o*x_z(k-1);       %计算预测误差协方差阵
        K(k,i)=p_yc(k,i)*c(i)'*inv(c(i)*p_yc(k,i)*c(i)'+r(i));    %计算增益阵
        x_gj(k,i)=x_yc(k,i)+K(k,i)*(z(k,i)-c(i)*x_yc(k,i));   %计算估计值
        p_gj(k,i)=(1-K(k,i)*c(i))*p_yc(k,i);    %计算估计误差协方差阵
       else
        x_yc(k,i)=x_gj(k,i-1);
        p_yc(k,i)=p_gj(k,i-1);
        K(k,i)=p_yc(k,i)*c(i)'*inv(c(i)*p_yc(k,i)*c(i)'+r(i));
        x_gj(k,i)=x_yc(k,i)+K(k,i)*(z(k,i)-c(i)*x_yc(k,i));
        p_gj(k,i)=(1-K(k,i)*c(i))*p_yc(k,i);
       end       
      end
      
     %集中滤波滤波过程
      zz=[z(k,1);z(k,2);z(k,3);z(k,4);z(k,5)];
      xc_yc(k)=o*xc_gj(k-1);
      pc_yc(k)=o*pc_gj(k-1)*o'+b*q*b';
      kc=pc_yc(k)*H'*inv(H*pc_yc(k)*H'+R);
      xc_gj(k)=xc_yc(k)+kc*(zz-H*xc_yc(k));
      pc_gj(k)=(1-kc*H)*pc_yc(k);
      
      
  end
  %分步滤波处理
   p_z(k)=p_gj(k,N); 
   x_z(k)=x_gj(k,N);
   af_x=af_x+x_z(k);
   af_p=af_p+p_z(k);
   fafss_e=x_z(k)-x(k)+fafss_e;
   %集中式滤波处理
   cd_x=cd_x+xc_gj(k);
   cd_p=cd_p+pc_gj(k);
   cdfa_e=xc_gj(k)-x(k)+cdfa_e;
  
end
  xc_gj(k)=cd_x/m;
  pc_gj(k)=cd_p/m;
  e_cdfa(k)=cdfa_e/m;
  
   x_z(k)=af_x/m;
   p_z(k)=af_p/m;
   e_fafss(k)=fafss_e/m;
end



hold on
plot(x,':');

plot(xc_gj,'b')

plot(x_z,'*');
title('FAFSS融合与CDFA融合效果比较')
xlabel('X--时间')
ylabel('Y--幅值')
legend('状态值','CDFA','FAFSS')
hold off

figure
hold on
plot(xc_gj-x,'b')
plot(x_z-x,'*')
xlabel('X--时间')
ylabel('Y--误差')
legend('CDFA','FAFSS')
hold off

%figure
%hold on
%plot(pc_gj,'b')
%plot(p_z,'*')

%title('估计误差协方差比较')
%xlabel('X--时间 (步骤K)')
%ylabel('Y--幅值')
%legend('P-CDFA','P-FAFSS')
%hold off


%figure
%plot(xc_gj-x_z)

%figure
%plot(pc_gj-p_z)


sume_afss=0;
sume_cdfa=0;
for i=1:ll
   %自己的算法 
   sume_afss=sume_afss+abs(e_fafss(i));
   %集中式融合算法
   sume_cdfa=sume_cdfa+abs(e_cdfa(i)); 
end
ee_fafss=sume_afss/ll 
ee_cdfa=sume_cdfa/ll
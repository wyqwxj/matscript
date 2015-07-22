%图1是DFT图形，图2是将xn补零后的DFT图形
clear;
N = 12;
n = 0:N-1;
Xk = zeros( 1,N );

for k=0:N-1
    Xk( k+1 ) = sum( cos( n*pi/6 ) .* exp( -1j*2*( pi/N )*n*k ) );
end

subplot( 311 );
stem( abs( Xk ) );
xn = cos( n*pi/6 );
xn1 = [ xn, zeros( 1,N ) ];
n=0:2*N-1;

for k=0:(2*N-1)
    Xk( k+1 ) = sum( xn1 .* exp( -1j*2*( pi/( 2*N ) )*n*k ) );
end

subplot( 312 );
stem( abs( Xk ) );
%这里对xn的两个值中间插入0
for k=0:2*N-1
    if ( mod( k,2 ) == 0 )
        xn2( k+1 ) = cos( k*pi/12 );
    else
        xn2( k+1 ) = 0;
    end
end

for k=0:2*N-1
    Xk( k+1 ) = sum( xn2 .* exp( -1j*2*( pi/( 2*N ) )*n*k ) );
end

subplot( 313 );
stem( abs( Xk ) );
%图中可以看出 xn确实出现了循环
    
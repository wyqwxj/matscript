%ͼ1��DFTͼ�Σ�ͼ2�ǽ�xn������DFTͼ��
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
%�����xn������ֵ�м����0
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
%ͼ�п��Կ��� xnȷʵ������ѭ��
    
clear
close
fd = fopen( 'C:\memory3.bin', 'r' );
data = fread( fd, 'int32' );
 subplot( 211 );
plot( data );
axis([0,10000,2000,3500]);
grid on;
fd = fopen( 'C:\memory4.bin', 'r' );
data = fread( fd, 'int32' );
subplot(212);
plot( data );
%axis([0,10000,2000,3500]);
grid on;

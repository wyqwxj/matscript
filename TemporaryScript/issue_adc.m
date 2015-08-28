clear
close
fd = fopen( 'C:\data.bin', 'r' );
data = fread( fd, 'int32' );
subplot( 211 );
plot( data );

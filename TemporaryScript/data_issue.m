clear
close
fd = fopen( 'C:\memory.bin', 'r' );
data = fread( fd, 'int16' );
subplot( 211 );
plot( data );
axis( [0,16000,-32768,32768] );
title( 'with no HP filter' )
%now create a hp filter
num = [0.927246093 -1.8544941 0.927246903];
den = [1 -1.906005859 0.911376953];
y = filter( num, den, data );
subplot(212);
plot( y );
axis( [0,16000,-32768,32768] );
title( 'with HP filter' )
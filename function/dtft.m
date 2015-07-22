function [X]=dtft(x,n,w)
X=x*exp(-1i*n*w);
end
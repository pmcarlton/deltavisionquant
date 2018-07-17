function [R, S]=hlbrtcrv(M,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Y = hlbrtcrv(M,N)
% HiLBeRT CuRVe (function)
%	This function returns the path cooridinates of a
%	Hilbert Space Filling curve for an MxN matrix.  
%
% INPUT ARGUMENTS:
%	M    -> Number of Rows for the Hilbert path.
%	N    -> Number of Columns for the Hilbert path.
%
% OUTPUT ARGUMENT:
%	R    -> The row cooridinates of the Hilbert path.
%	S    -> The column cooridinates of the Hilbert path.
%
% EXAMPLE:
%	Y = hilbert(32);
%	imagesc(Y);
%	axis image;
%	hold on;
%	[R,S] = hlbrtcrv(32,32);
%	plot(R,S,'r');
%
% Daniel Leo Lau
% lau@ece.udel.edu
%
% June 16, 1998
% Copyright 1998 Daniel Leo Lau
%
% Last modified on June 16, 1998
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y=hilbert(max([M N]));
Y=Y(1:M,1:N);
Y=Y(1:M*N)';
[s, I]=sort(Y);

if (nargout==2)
	[R,S]=meshgrid(1:N,1:M);
	R=R(I);
	S=S(I);
else
	R=I;
end;
return;
function res=convexifyz(im);
%give a binary image m
%returns a convexified (in Z) version of m

im3a=cumsum(im,3);
im3b=rotdim(cumsum(rotdim(im,2,[1 3]),3),2,[1 3]);

res=((im3a & im3b));

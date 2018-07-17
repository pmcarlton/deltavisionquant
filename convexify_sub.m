function res=convexify_sub(im);
%give a binary image m
%returns a convexified (all dims) version of m
%trying to return only central/largest object .. hacky, 020110118

im1a=cumsum(im,1);
im1b=rotdim(cumsum(rotdim(im,2,[1 2]),1),2,[1 2]);
im2a=cumsum(im,2);
im2b=rotdim(cumsum(rotdim(im,2,[1 2]),2),2,[1 2]);
im3a=cumsum(im,3);
im3b=rotdim(cumsum(rotdim(im,2,[1 3]),3),2,[1 3]);

res = im1a+im1b+im2a+im2b+im3a+im3b;

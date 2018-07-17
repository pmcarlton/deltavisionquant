function [out,gt]=g2bw(in);

%makes a binary image from any 2D matrix

in=double(in);
ia=max(in(:));ii=min(in(:));
if(find(in)),
in-=ii;in./=ia;
in=(floor(in.*256));
end
in=uint8(in);
gt=graythresh(in);
out=im2bw(in,gt);
gt*=ia;gt+=ii;

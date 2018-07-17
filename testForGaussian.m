function rs=testForGaussian(z,sz,st);

%given a column x, check for gaussian with gauss2dcirc
[x,y]=meshgrid(1:sz);
disp(size(z));
[xc,yc,amp,width]=gauss2dcirc(z,x,y,st);
rs=amp;

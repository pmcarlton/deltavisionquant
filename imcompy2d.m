function res=imcompy2d(g,im1,im2,reset);
persistent x;
persistent y;
persistent zs;
persistent hx;
persistent hy;

s=size(im1);

if(isempty(x) | reset),
[x,y]=meshgrid(1:s(2),1:s(1));
zs=ones(size(y(:)));
mat2=[x(:) y(:) zs];
hx = mean(1:s(1));
hy = mean(1:s(2));
end;

mat3=mat2;
%mat3(:,1)-=hx;
%mat3(:,2)-=hy;
%mat3(:,3)-=hz;
g1 = [g [0;0;1]]; %leaving the dummy 3th column alone, making 6-dimensional simplex rather than 9-dimensional
mat3=mat3 * g1;
%mat3(:,1)+=hx;
%mat3(:,2)+=hy;
%mat3(:,3)+=hz;
x1=reshape(mat3(:,1),size(x));y1=reshape(mat3(:,2),size(y));
im3=interp2(x,y,im1,x1,y1,'linear',0);
res=im3-im2;res=sum(res(:).^2);
end


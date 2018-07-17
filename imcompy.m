function res=imcompy(g,im1,im2,reset);
persistent x;
persistent y;
persistent z;
persistent zs;
persistent hx;
persistent hy;
persistent hz;

s=size(im1);

if(isempty(x) | reset),
disp('Initializing...');
[x,y,z]=ndgrid(1:s(1),1:s(2),1:s(3));
zs=ones(size(z(:)));
mat2=[x(:) y(:) z(:) zs];
hx = mean(1:s(1));
hy = mean(1:s(2));
hz = mean(1:s(3));
end;

mat3=mat2;
%mat3(:,1)-=hx;
%mat3(:,2)-=hy;
%mat3(:,3)-=hz;
g1 = [g [0;0;0;1]]; %leaving the dummy 4th column alone, making 12-dimensional simplex rather than 16-dimensional
mat3=mat3 * g1;
%mat3(:,1)+=hx;
%mat3(:,2)+=hy;
%mat3(:,3)+=hz;
x1=reshape(mat3(:,1),size(x));y1=reshape(mat3(:,2),size(y));z1=reshape(mat3(:,3),size(z));
im3=interpn(x,y,z,im1,x1,y1,z1,'linear',0);
res=im3-im2;res=sum(res(:).^2);
end


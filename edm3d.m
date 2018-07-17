function e = edm3d(s)

%creates 3D distance map; each element is its distance from the center

[x,y]=meshgrid(1:s);
m=mean(x(:));
x-=m;y-=m;
x=repmat(x,[1 1 s]);
y=repmat(y,[1 1 s]);
z=rotdim(x,1,[2 3]);

e=sqrt(x.^2 + y.^2 + z.^2);


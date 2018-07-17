function e = edm3d2(s)

%creates 3D distance map; each element is its distance from the center

%[x,y]=meshgrid(1:s);

[x,y,z]=ndgrid(1:s(1),1:s(2),1:s(3));
x-=mean(x(:));
y-=mean(y(:));
z-=mean(z(:));

e=sqrt(x.^2 + y.^2 + z.^2);


function [xc,yc,Amp,wx,wy] = gauss2dellipse(z,x,y,noiselevel)

%see pdf for help again

cols=find(mean(z,1)>4*noiselevel/sqrt(size(z,2)));
rows=find(mean(z,2)>4*noiselevel/sqrt(size(z,1)));

z=z(rows,cols);x=x(rows,cols);y=y(rows,cols);
x=x(:);y=y(:);Z=z(:)+(1e-15);
noise=log(max(Z+noiselevel,1e-10))-log(max(Z-noiselevel,1e-20));
wght=(1./noise);
wght(Z<=noiselevel)=0;

n=[ones(size(x)) x x.^2 y y.^2].*(wght*ones(1,5));
d=log(Z).*wght;
a=n\d;

wx=sqrt(-.5/a(3));
wy=sqrt(-.5/a(5));
xc=a(2)/(-2*a(3));
yc=a(4)/(-2*a(5));
Amp=exp(a(1)-a(3)*xc^2-a(5)*yc^2);


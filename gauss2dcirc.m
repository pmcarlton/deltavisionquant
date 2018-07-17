function [xc,yc,Amp,width]=gauss2dcirc(z,x,y,noiselevel)

%see pdf for help

x=x(:);y=y(:);Z=z(:)+(1e-15);

noise=log(max(Z+noiselevel,1e-10))-log(max(Z-noiselevel,1e-20));
wght=(1./noise);
wght(Z<=0)=0;

n=[x y log(Z) ones(size(x))].*(wght*ones(1,4));
d=-(x.^2+y.^2).*wght;
a=n\d;

xc = -.5*a(1);
yc = -.5*a(2);
width=sqrt(a(3)/2);
Amp=exp((a(4)-xc^2-yc^2)/(-2*width^2));


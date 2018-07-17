function im=ringpts(r,len,numpts)

%makes a ring

if(len <= (r*2)), len = (r*2+1);end
ts=1/numpts;
theta=linspace(0,(2*pi),1+numpts);
theta=theta(1:numpts);
[x,y]=pol2cart(theta,r);
k=zeros(len);
x=floor(0.5+x+floor(len/2));
y=floor(0.5+y+floor(len/2));
  for l=1:numpts;
	k(x(l),y(l))=1;
  end

im=k;

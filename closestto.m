function y=closestto(x,val)

% returns index of x closest to val

x=abs(x-val);
y=find(x==min(x(:)));

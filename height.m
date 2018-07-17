function res=height(x);

%length of the last non-singleton dimension

s=size(squeeze(x));
res=s(end);


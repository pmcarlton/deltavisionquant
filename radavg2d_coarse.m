function [a,fa]=radavg2d_coarse(b,eps)
    %returns the radially-averaged version of image b in array a... only odd+square for now.
    %coarse: don't treat values differing by less than eps as unique
l=length(b);
a=zeros(l);
st=((l-1)/2);
rng=(-st:st)';

rng=rng*ones(1,l);
rng=rng+(j.*rot90(rng));

rng=abs(rng);
mm=max(rng(:));
c=linspace(eps,mm,mm/eps);
f=[];
fa=[];
for l=1:length(c);
    f2=f;
    f=find(rng<=c(l));
    f3=setdiff(f,f2);
    fa=[fa;rng(f3(:))];
    a(f3)=mean(b(f3));
    end


function a=radavg2d(b)
    %returns the radially-averaged version of image b in array a... only odd+square for now.
    
l=length(b);
a=zeros(l);
st=((l-1)/2);
rng=(-st:st)';

rng=rng*ones(1,l);
rng=rng+(j.*rot90(rng));

rng=abs(rng);
c=unique(rng);

for l=1:length(c);
    f=find(rng==c(l));
    a(f)=mean(b(f));
    end


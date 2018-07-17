% c2=4;
% c3=.3;
% c6=.035;
c2=1;
c3=.2;
c6=.035;

%c4=100000000000;
%c5=.14;

t=10000;
nucs=100; %number of nuclei to run in parallel
pbr=zeros(t,nucs);
prp=pbr;
dsb=pbr;

dsb=zeros(t,nucs);
for l=2:t;
   % pbr(l,:)=(c1-(c2.*dsb(l-1,:)))./c3;
    pbr(l,:)=c3./(dsb(l-1,:)+c2);

    prp(l,:)=(dsb(l-1,:)./c4).^c5;

    dsb(l,:)+=dsb(l-1,:);
%    dsb(l,:)+=(rand(1,nucs)<c6);
dsb(l,:)+=(rand(1,nucs)<pbr(l,:));
%dsb(l,:)-=(rand(1,nucs)<prp(l,:));
    dsb(l,:)-=(rand(1,nucs)<c6);
    dsb(l,find(dsb(l,:)<0))=0;
end

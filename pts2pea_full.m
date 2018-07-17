#!/usr/local/bin/octave -q

fn=argv;fn=fn{1};

a=mrcread(fn);
pts=load(strcat(fn,'.pts'));

%find indices of points belonging to w1,w2...

c4=pts(:,4);
c4max=max(c4);
for l=1:c4max;c4t(l)=sum(c4==l);end
nwav=max(c4t);

if(nwav==1),
pts=pts(:,1:3)+1;

s=size(a);zs=s(3)/2;
r1=1:zs;
r2=(zs+1):s(3);

p1=pea_byhand(a(:,:,r1),pts,[31 31 13]);
p2=pea_byhand(a(:,:,r2),pts,[31 31 13]);

p=[nrm2d(p1(:,:,7)) zeros(31,1) nrm2d(p2(:,:,7))];

save('-binary',strcat(fn,'.pea.oct'),'p1','p2');
imwrite(p,strcat(fn,'.pea.png'));

end %if nwav==1

if(nwav==2),
c4t=min(find(c4t==1));
pts1=pts(1:(c4t-1),1:3)+1;
pts2=pts(c4t:end,1:3)+1;
s=size(a);zs=s(3)/3;
r1=1:zs;r2=(zs+1):zs*2;r3=(zs*2+1):zs*3;

p11=pea_byhand(a(:,:,r1),pts1,[31 31 13]);
p21=pea_byhand(a(:,:,r2),pts1,[31 31 13]);
p31=pea_byhand(a(:,:,r3),pts1,[31 31 13]);
p12=pea_byhand(a(:,:,r1),pts2,[31 31 13]);
p22=pea_byhand(a(:,:,r2),pts2,[31 31 13]);
p32=pea_byhand(a(:,:,r3),pts2,[31 31 13]);

%p=[nrm2d(p11(:,:,7)) zeros(31,1) nrm2d(p21(:,:,7)) zeros(31,1) nrm2d(p31(:,:,7))];
%p=[p; nrm2d(p12(:,:,7)) zeros(31,1) nrm2d(p22(:,:,7)) zeros(31,1) nrm2d(p32(:,:,7))];
%p=[nrm2d(max(p11,[],3)) nrm2d(max(p21,[],3)) nrm2d(max(p31,[],3))];
%p=[p;nrm2d(max(p12,[],3)) nrm2d(max(p22,[],3)) nrm2d(max(p32,[],3))];

save('-binary',strcat(fn,'.peafull.oct'),'p11','p21','p31','p12','p22','p32','pts1','pts2','a','c4t');
%imwrite(p,strcat(fn,'.pea.png'));

end %if nwav==2



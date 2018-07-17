#!/usr/local/bin/octave -q

fn=argv;fn=fn{1};
disp(fn);

a=mrcread(fn);
pts=load(strcat(fn,'.pts'));

%find indices of points belonging to w1,w2...

pts=pts(:,1:3)+1;
ra=floor(30.*rand(size(pts))-15);
rpts=pts+ra;
for l=1:3;
    rpts(find(rpts(:,l)<min(pts(:,l))),l)=min(pts(:,l))(1);
    rpts(find(rpts(:,l)>max(pts(:,l))),l)=max(pts(:,l))(1);
end

s=size(a);zs=s(3)/4; %customized for 4 wavelengths as of now
r1=1:zs;r2=(zs+1):zs*2;r3=(zs*2+1):zs*3;r4=(zs*3+1):zs*4;

p11=pea_byhand_mean(a(:,:,r1),pts,[31 31 13]);
p21=pea_byhand_mean(a(:,:,r2),pts,[31 31 13]);
p31=pea_byhand_mean(a(:,:,r3),pts,[31 31 13]);
p41=pea_byhand_mean(a(:,:,r4),pts,[31 31 13]);

rp11=pea_byhand_mean(a(:,:,r1),rpts,[31 31 13]);
rp21=pea_byhand_mean(a(:,:,r2),rpts,[31 31 13]);
rp31=pea_byhand_mean(a(:,:,r3),rpts,[31 31 13]);
rp41=pea_byhand_mean(a(:,:,r4),rpts,[31 31 13]);

save('-binary',strcat(fn,'.peamean.oct'),'p11','p21','p31','p41','rp11','rp21','rp31','rp41');

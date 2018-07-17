#!/usr/bin/octave -q
#
# reads a file, makes a mask from the largest object (without touching the edges), carves out data from that mask at midsection +/- 2 sections, and does cross-correlation between all wavelengths for that data. data written out to SSV file with filenames interspersed (separated with % sign)
# TODO ?
# 02015-02-24 pmc

function tf=bwedge(bw)
tf=sum(bw(1,:))+sum(bw(:,1))+sum(bw(end,:))+sum(bw(:,end));
end

fns=argv;

fout="corms.txt";
for thefile=1:numel(fns),
    fn=fns{thefile};

[prec,arch]=mrc_endicheck(fn);
fid=fopen(fn,"r",arch);
fseek(fid,16,SEEK_SET);
sx=fread(fid,1,'int32',0,arch);
fseek(fid,20,SEEK_SET);
sy=fread(fid,1,'int32',0,arch);
fseek(fid,24,SEEK_SET);
sz=fread(fid,1,'int32',0,arch);
fseek(fid,196,SEEK_SET);
nw=fread(fid,1,'int16',0,arch);
fclose(fid);

a=mrcread(fn);
s=size(a);sn=s(3)/nw;
b=a(:,:,1:sn);
b=max(b,[],3);b=nrm2d(b);
a=reshape(a,[s(1) s(2) sn nw]);
ff=1.0;mskc=ones(size(b));

while(bwedge(mskc)), %increases threshold until no edge touching left
    disp(ff);
    bq=b;bm=b-b;
        for l=1:2;
            bg=graythresh(bq)*ff;
            bqm=(bq>bg);
            bm=(bm|(bqm));
            bq=nrm2d(bq.*(bq<bg));
        end
        bm=bwlabel(bm);
        u=unique(bm);
        for l=1:numel(u)-1
            ll(l)=numel(find(bm==l));
        end
        ll=find(ll==max(ll));
        msk=(bm==ll);
        [x,y]=find(msk);j=convhull(x,y);x=x(j);y=y(j);
        mskc=poly2mask(y,x,size(msk)(1),size(msk)(2)); %note reversed x,y
        mskc=bwmorph(mskc,'dilate');
        ff+=0.01;
    end
%    im(mskc);
for l=1:sn;am=a(:,:,l,1).*mskc;am=am(find(am(:)));aml(l)=mean(am).*std(am);
end
mdsc=find(aml==max(aml))(1); %finds mid-section (sec. where mean*std is highest)
if(mdsc<3),
    mdsc=3;
end
if(mdsc>(sn-2)),
    mdsc=(sn-2);
end
a=a(:,:,mdsc-2:mdsc+2,:);
cols=[];
mask5=repmat(mskc,[1 1 5]);
for l=1:4;
    r=squeeze(a(:,:,:,l)).*mask5;
    r=r(find(mask5))(:);
%    disp(numel(r));
    cols(:,l)=r;
end
%cols-=repmat(min(cols),[length(cols) 1]); %normalization
%cols./=repmat(max(cols),[length(cols) 1]);%of data
corm=corr(cols);
corm=(tril(corm,-1,'pack'))'; %selects column vector of cross-corr values only
corm=[sum(cols) mean(cols) std(cols) corm];
dlmwrite(fout,corm," ","-append");
dlmwrite(fout,strcat("%",fn),"","-append");
printf("Wrote corm for %s \n",fn);
end

#!/usr/bin/octave -q

% ica-3wav-thresh: takes a 3-wave data file and writes the ICA'd version out
% 02014-04-17pmc
% for CREST/Kai's data
%
% --> 'thresh' == thresholding on DAPI, so only nuclear pixels are subjected to ICA.

% customized: DAPI must be 1st wavelength; must have only 3 wavelengths

arg_list=argv();

DATAFILE=arg_list{1};
OUTFILE=strcat(DATAFILE,'.ica');
NWAV=3;

disp(cstrcat("reading ",DATAFILE));fflush(1);
dat=mrcread(DATAFILE);
[prec,arch]=mrc_endicheck(DATAFILE);

ds=size(dat);
zs=ds(3)/3;

dat=reshape(dat,[ds(1) ds(2) zs 3]);
% check for zero-sections in wv3 from chromatic-shift
for l=0:3;
s=sum(dat(:,:,end-l,3)(:));
if(s==0),dat(:,:,end-l,:)=0;end
end
dat=reshape(dat,[ds(1) ds(2) ds(3)]);

dapi=dat(:,:,1:zs);
mds=[0 0];
for l=1:zs;
    r=sort(dapi(:,:,l)(:));
    r=var(r);
    %r=var(r).*r(floor(length(r).*0.99));
    if(mds(1)<r),mds=[r l];
    end;
end
#disp(mds);

%r=dapi(:,:,mds(2));

%straight maxproj method:
r=max(dapi,[],3);

r=nrm2d(r);g=graythresh(r);
rb=(r>g);

thck=10;thckk=thck-1;
#rb2=bwmorph(rb,'thicken',thck);
#rb2=(1-rb2);
#rb2(1:thck,:)=0;rb2(:,1:thck)=0;rb2(:,end-thckk:end)=0;rb2(end-thckk:end,:)=0;
rb2=imdilate(rb,edm(9,9)<5.5);

f=find(rb2==0);
for l=1:ds(3);r=dat(:,:,l);r(f)=0;dat(:,:,l)=r;end

cols1=reshape(dat,[prod([ds(1) ds(2) zs]) 3]);
fc=find(cols1(:,1));
cols=cols1(fc,:);

cols1-=cols1;
cols=bsxfun(@minus,cols,mean(cols));

[z,sep,mix]=fastica(cols');
save("-ascii",strcat(DATAFILE,'.mat'),'sep','mix');
z=z';
z-=repmat(min(z),[length(z) 1]);
for l=1:3;r=z(:,l);
    r=hist(r,100);
    rf=find(r==max(r));
    if(rf>50),
        z(:,l)=(-(z(:,l)));
        end; #endif
    end; #endfor

z-=repmat(min(z),[length(z) 1]);
mz=max(z);mz(find(mz==0))=1;
z.*=repmat(65535./mz,[length(z) 1]);
cols1(fc,:)=z;

datpca=reshape(cols1,size(dat));

mrcwrite_prec_arch(datpca,OUTFILE,prec,arch);

hdrcmd=cstrcat('dd bs=4 count=256 conv=notrunc if=',DATAFILE,' of=',OUTFILE,' 2>/dev/null');
system(hdrcmd);

% set the header fields for intensities
intens=[min(z);max(z)];
w1scale=fopen('/tmp/w1scale','w');
fwrite(w1scale,intens(:,1),'float32',0,arch);
fclose(w1scale);
w23scale=fopen('/tmp/w23scale','w');
fwrite(w23scale,intens(:,2:3)(:),'float32',0,arch);
fclose(w23scale);

w1cmd= cstrcat('dd ibs=1 obs=1 count=8 conv=notrunc seek=76 if=/tmp/w1scale of=',OUTFILE,' 2>/dev/null');
w23cmd=cstrcat('dd ibs=1 obs=1 count=16 conv=notrunc seek=136 if=/tmp/w23scale of=',OUTFILE,' 2>/dev/null');

system(w1cmd);
system(w23cmd);


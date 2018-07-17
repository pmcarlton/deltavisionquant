#!/usr/bin/octave -q

% crop_edges.m
% --replaces N pixels at XY borders with 0
% to help with Preibisch stitching
% 20170807pmc

arg_list=argv();

DATAFILE=arg_list{1};
OUTFILE=strcat(DATAFILE,'.crop');

disp(cstrcat("reading ",DATAFILE));fflush(1);
dat=mrcread(DATAFILE);
[prec,arch]=mrc_endicheck(DATAFILE);

ds=size(dat);
zs=ds(3)/3;

cols=double(reshape(dat,[prod([ds(1) ds(2) zs]) 3]));
cols=bsxfun(@minus,cols,mean(cols));

[z]=fastica(cols');
z=z';
for l=1:3;r=z(:,l); r=hist(r,100);rf=find(r==max(r));if(rf>50),z(:,l)=(-(z(:,l)));end
end

z-=repmat(min(z),[length(z) 1]);
mz=max(z);mz(find(mz==0))=1;
z.*=repmat(65535./mz,[length(z) 1]);

datpca=reshape(z,size(dat));

mrcwrite_prec_arch(datpca,OUTFILE,prec,arch);

hdrcmd=cstrcat('dd bs=4 count=256 conv=notrunc if=',DATAFILE,' of=',OUTFILE);
system(hdrcmd);

% set the header fields for intensities
intens=[min(z);max(z)];
w1scale=fopen('/tmp/w1scale','w');
fwrite(w1scale,intens(:,1),'float32',0,arch);
fclose(w1scale);
w23scale=fopen('/tmp/w23scale','w');
fwrite(w23scale,intens(:,2:3)(:),'float32',0,arch);
fclose(w23scale);

w1cmd= cstrcat('dd ibs=1 obs=1 count=8 conv=notrunc seek=76 if=/tmp/w1scale of=',OUTFILE);
w23cmd=cstrcat('dd ibs=1 obs=1 count=16 conv=notrunc seek=136 if=/tmp/w23scale of=',OUTFILE);

system(w1cmd);
system(w23cmd);


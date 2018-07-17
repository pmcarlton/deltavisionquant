#!/usr/bin/octave -q

#ica-2wav
#

arg_list=argv();

DATAFILE=arg_list{1};
OUTFILE=strcat(DATAFILE,'.ica');
NWAV=3;

disp(cstrcat("reading ",DATAFILE));fflush(1);
dat=mrcread(DATAFILE);
[prec,arch]=mrc_endicheck(DATAFILE);

ds=size(dat);
zs=ds(3)/2;

cols=reshape(dat,[prod([ds(1) ds(2) zs]) 2]);
cols=bsxfun(@minus,cols,mean(cols));

[z]=fastica(cols');
z=z';

zm1=mode(z(:,1));
if(sum(z(:,1)<zm1)>sum(z(:,1)>zm1)), z(:,1)=-(z(:,1)); end

zm2=mode(z(:,2));
if(sum(z(:,2)<zm2)>sum(z(:,2)>zm2)), z(:,2)=-(z(:,2)); end

z-=repmat(min(z),[length(z) 1]);

datpca=reshape(z,size(dat));
mrcwrite_prec_arch(datpca,OUTFILE,prec,arch);

hdrcmd=cstrcat('dd bs=4 count=256 conv=notrunc if=',DATAFILE,' of=',OUTFILE,' 2>/dev/null');
system(hdrcmd);

% set the header fields for intensities
intens=[min(z);max(z)];
w1scale=fopen('/tmp/w1scale','w');
fwrite(w1scale,intens(:,1),'float32',0,arch);
fclose(w1scale);
w2scale=fopen('/tmp/w2scale','w');
fwrite(w2scale,intens(:,2)(:),'float32',0,arch);
fclose(w2scale);

w1cmd= cstrcat('dd ibs=1 obs=1 count=8 conv=notrunc seek=76 if=/tmp/w1scale of=',OUTFILE,' 2>/dev/null');
w2cmd=cstrcat('dd ibs=1 obs=1 count=8 conv=notrunc seek=136 if=/tmp/w2scale of=',OUTFILE,' 2>/dev/null');

system(w1cmd);
system(w2cmd);


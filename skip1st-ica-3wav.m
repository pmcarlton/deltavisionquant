#!/usr/bin/octave -q

% customized: DAPI must be 1st wavelength; must have total 4 wavelengths

arg_list=argv();

DATAFILE=arg_list{1};
OUTFILE=strcat(DATAFILE,'.ica');
NWAV=3;

disp(cstrcat("reading ",DATAFILE));fflush(1);
dat=mrcread(DATAFILE);
[prec,arch]=mrc_endicheck(DATAFILE);

ds=size(dat);
zs=ds(3)/4;

cols=reshape(dat,[prod([ds(1) ds(2) zs]) 4]);
dcol=cols(:,1);
cols=bsxfun(@minus,cols,mean(cols));

[z]=fastica(cols(:,2:4)');
z=z';

for l=1:3; r=z(:,l);r=floor(nrm2d(r).*100);
    disp([mode(r) sum(r<mode(r)) sum(r>mode(r))]);
    if(sum(r<mode(r))>sum(r>mode(r))), z(:,l)=(-z(:,l)); end; 
    end
z-=repmat(min(z),[length(z) 1]);
z=[cols(:,1) z];

datpca=reshape(z,size(dat));
mrcwrite_prec_arch(datpca,OUTFILE,prec,arch);

hdrcmd=cstrcat('dd bs=4 count=256 conv=notrunc if=',DATAFILE,' of=',OUTFILE,' 2>/dev/null');
system(hdrcmd);

% set the header fields for intensities
intens=[min(z);max(z)];
w1scale=fopen('/tmp/w1scale','w');
fwrite(w1scale,intens(:,1),'float32',0,arch);
fclose(w1scale);
w234scale=fopen('/tmp/w234scale','w');
fwrite(w234scale,intens(:,2:4)(:),'float32',0,arch);
fclose(w234scale);

w1cmd= cstrcat('dd ibs=1 obs=1 count=8 conv=notrunc seek=76 if=/tmp/w1scale of=',OUTFILE,' 2>/dev/null');
w234cmd=cstrcat('dd ibs=1 obs=1 count=24 conv=notrunc seek=136 if=/tmp/w234scale of=',OUTFILE,' 2>/dev/null');

system(w1cmd);
system(w234cmd);


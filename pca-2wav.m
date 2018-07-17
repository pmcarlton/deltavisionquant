#!/usr/bin/octave -q

% pca-2wav: takes a 2-wave data file and writes the PCA'd version out
% 02014-04-21pmc
% for CREST/Kai's data

arg_list=argv();

DATAFILE=arg_list{1};
OUTFILE=strcat(DATAFILE,'.pca');
NWAV=3;

disp(cstrcat("reading ",DATAFILE));fflush(1);
dat=mrcread(DATAFILE);
[prec,arch]=mrc_endicheck(DATAFILE);
ds=size(dat);

cols=reshape(dat,[prod([ds(1) ds(2) ds(3)/2]) 2]);
cols=bsxfun(@minus,cols,mean(cols));

[pc,z,w]=princomp(cols);

z(:,1)=(-(z(:,1))); %usually negative, for some reason

datpca=reshape(z,size(dat));

mrcwrite_prec_arch(datpca,OUTFILE,prec,arch);

hdrcmd=cstrcat('dd bs=4 count=256 conv=notrunc if=',DATAFILE,' of=',OUTFILE);
system(hdrcmd);

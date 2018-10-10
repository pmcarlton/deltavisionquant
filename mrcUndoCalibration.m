#!/usr/local/bin/octave --no-gui

argsnow=argv;
fname1=argsnow{1};
fname2=argsnow{2};
uncal=strcat('uncal_',fname1);

disp(fname1);
disp(fname2);

%writes a freaking MRC file in floating point format. It's about freaking time.
%020100903 hey it beats writing Wakate-A, pmc

%020180416 can actually specify header from struct now

%determine if it's complex...
%
%mrcUndoCalibration -- first divides by wave 1, then adds wave 0, from a .cal 
%file -- SINGLE WAVE FILES ONLY!!! 20181010pmc
%
% added code from mrcmultiplysec3 to read+copy extended header ... forgot to 
% have that in write_prec_arch originally 20181010pmc

[hdr,raw_hdr,buf,prec,arch,exthdr]=mrcReadFullDetails(fname1);
[hdrx,raw_hdrx,bufx,precx,archx,exthdrx]=mrcReadFullDetails(fname2);

[xs,ys,zs]=size(buf);
for l=1:zs
    buf(:,:,l)./=bufx(:,:,2);
    buf(:,:,l)-=bufx(:,:,1);
end

mrcwrite_prec_arch(buf,uncal,prec,arch,hdr,exthdr);

#!/usr/bin/octave -q
#
#as is, for 2 wavelengths, makes pol based on 1st (DAPI)
# TODO make for N waves using 1st (DAPI) as pol source

fn=argv; fn=fn{1};imout=strcat(fn,'.png');fnout=strcat(fn,'.pol');

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
disp(nw);disp('wavelengths');
fclose(fid);


a=mrcread(fn);
s=size(a);sn=s(3)/nw;
a=a(:,:,1:sn);
a=nrm2d(max(a,[],3));
a=(a>graythresh(a));
a=bwmorph(a,'dilate',5);
a=bwfill(a,'holes');
a=bwmorph(a,'erode',3);
[la,num]=bwlabel(a);
for l=1:num;
    os(l)=sum(la(:)==l);
    end
a=(la==find(os==max(os)));
imwrite(a,imout);
[x,y]=find(a);
h=convhull(x,y);
h=h(1:end-1);
x=x(h)+sx;y=y(h)+sy;

fid=fopen(fnout,'w');
%print out polygon file
fprintf(fid,"polfmt2\n");
for wn=1:nw;
for l=1:sn;
    fprintf(fid,cstrcat('section ',num2str(sz+l-1),' ',num2str(wn),' 0',"\n"));
    fprintf(fid,cstrcat('polygon 0 1 ',num2str(length(h)),"\n"));
    for l=1:length(h);
        fprintf(fid,cstrcat('point ',num2str(x(l)),' ',num2str(y(l)),"\n"));
    end
end #end sn
end
fprintf(fid,"end\n");
fclose(fid);

mkfpcmd=cstrcat("mk-fp-pars.pl ",fn);
system(mkfpcmd);

fpcmd=cstrcat("fp.com ",fn,".pars");
system(fpcmd);

peacmd=cstrcat("pts2pea_full.m ",fn);
system(peacmd);

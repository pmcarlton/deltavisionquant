#!/usr/local/bin/octave -q
%
%fociscript_usefunctions.m -- for counting rad-51 foci as a standalone executable, 2013-06-08pmc

arg_list=argv();
W=3;HW=floor(W/2);

if(nargin<4),
    DATAFILE="/you need to specify a file";
    DAPI=1;
    RAD=2;
    NWAV=2;
else
    DATAFILE=arg_list{1};
    DAPI=str2num(arg_list{2});
    RAD=str2num(arg_list{3});
    NWAV=str2num(arg_list{4});
end

pkg load image

if(DAPI==RAD),disp("YOUR WAVELENGTHS ARE BAD AND YOU SHOULD FEEL BAD");end
if(NWAV<max(DAPI,RAD)), disp("YOU SHOULD HAVE MORE WAVELENGTHS");end

disp("reading file...");disp(DATAFILE);fflush(1);
dat=mrcread(DATAFILE);
ds=size(dat);
zs=reshape(1:ds(3),[ds(3)/NWAV NWAV]);

DAPI=dat(:,:,zs(:,DAPI));
RAD=dat(:,:,zs(:,RAD));

DAPI=DAPI.*(DAPI>0); %added to prevent undercounting, 20130910pmc
RAD=RAD.*(RAD>0); %added to prevent undercounting, 20130910pmc

clear dat;

RAD-=min(RAD(:));
RAD./=max(RAD(:)); #normalized

maxdapi=nrm2d(max(DAPI,[],3));dg=graythresh((maxdapi));dg=(maxdapi>dg);
dg=bwmorph(dg,'dilate',2);
disp("calculating point maxima...");fflush(1);
maxrad=max(RAD,[],3);dg=maxrad.*dg;
%sometimes the Otsu method places the fore/back boundary between cellular background and non-gonad
%region. need to do some fudging (throwing away the bottom few gray levels) to prevent that.
%2013-10-02pmc
%level=sqrt(graythresh(maxrad.^2));fg=sum(maxrad(:)>level);
%level=graythresh(maxrad);
level=graythresh(dg(find(dg)));
fg=sum(maxrad(:)>level);
%if(fg./prod(size(maxrad))) > 0.02, %no more than 2% of pixels should be foreground
if(fg./numel(maxrad)) > 0.05, %no more than 5% of pixels should be foreground
    disp("going up...");
    %mtt=maxrad(find(maxrad>level));level=mean(mtt)+(std(mtt)/2); %go up 0.5 std
    mtt=maxrad(find(maxrad>level));level=mean(mtt)+std(mtt); %go up 1 std
    mtt=maxrad(find(maxrad>level));level=mean(mtt)+std(mtt); %go up 1 std
    %mtt=maxrad(find(maxrad>level));level=mean(mtt)+(std(mtt)/2); %go up 0.5 std
    %mtt=maxrad(find(maxrad>level));level=mean(mtt)-std(mtt); %go down 1 std
    %mtt=maxrad(find(maxrad>level));level=mean(mtt)-std(mtt); %go down another std
end
%maxrad.*=(dg>=level); %so the picture comes out correct
maxrad.*=(maxrad>=level); %so the picture comes out correct
printf("found RAD-51 graylevel... %.4f",level);fflush(1);

disp(strcat("RAD size is:",num2str(size(RAD))));
localmax=minmaxfilt(RAD,W,'max','same'); %requires MinMaxFilt package .mex files 20130607pmc
radsignals=( (localmax==RAD) .* (RAD >= level) );

disp("finding nucleus centers...");fflush(1);
[surfs,nuccenters,maxdapi]=f_nuc2surf(DAPI);

disp("counting foci...");fflush(1);

f=find(radsignals);
[x,y,z]=ind2sub(size(RAD),f);
foci=[x y z].*repmat([.064 .064 .2],[length(x) 1]);

output=countfoci(nuccenters, foci,maxdapi,maxrad,DATAFILE);

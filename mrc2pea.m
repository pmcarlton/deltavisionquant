#!/usr/local/bin/octave -q
#
# TODO: save area and perimeter of mask
#       

pkg load image
PEASIZE=[31 31 13];
HPEA=ceil(PEASIZE./2);
ptmax=2000;

fnall=argv(); fn=fnall{1};imout=strcat(fn,'.png');fnout=strcat(fn,'.pol');
tw=zeros(4,1);
for li=1:4;tw(li)=str2num(fnall{li+1});end
%for li=2:5;tw(li-1)=fnall{li}(:);end %wavelength thresholds

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

%printf("sx: %i sy: %i sz: %i nw: %i",sx,sy,sz,nw);

disp("Reading image...");
a=mrcread(fn);
s=size(a);sn=s(3)/nw;
da=a(:,:,1:sn); %selects 1st wavelength (DAPI) only
da=nrm2d(max(da,[],3));
da=(da>graythresh(da));
da=bwmorph(da,'dilate',5);
da=bwfill(da,'holes');
da=bwmorph(da,'erode',3);
[la,num]=bwlabel(da);
for l=1:num;
    os(l)=sum(la(:)==l);
    end
da=(la==find(os==max(os)));
imwrite(da,imout);
[x,y]=find(da);
h=convhull(x,y);
%h=h(1:end-1);

% mask entire image with convex hull mask obtained from DAPI image projection
ms=poly2mask(y,x,s(1),s(2)); %% NB: y and x reversed, ok
a.*=repmat(ms,[1 1 s(3)]);
a=reshape(a,[s(1) s(2) sn nw]);

mm(:,:,1)=nrm2d(max(a(:,:,:,1),[],3));
mm(:,:,3)=ms;

% find maxima points > than Otsu threshold of max-proj-3d
% or trying now 20150403pmc with manually specified thresholds
disp("Finding maxima points...");
for l=1:nw;r=a(:,:,:,l);
    %r-=min(r(:));r./=max(r(:));
    rp=max(r,[],3);
    %rpt=graythresh(rp)/2;
    rpt=(mean(rp(:)))+std(rp(:));
    rmaxima=(r==minmaxfilt(r,3,'max','same'));
%rpts=rmaxima;
    %rpts=rmaxima & (r>rpt);
    rpts=rmaxima & (r>tw(l));
    f=find(rpts);
    if(numel(f)>ptmax),
        [h,i]=sort(r(f),'descend');
        f=f(1:ptmax);
    end
    disp("This is how many points were found:");
    disp(size(f));
    disp("and that was how many points were found.");
    [x,y,z]=ind2sub(size(rpts),f);
    rplist{l}=[x y z];
    pm(:,:,l)=nrm2d(max(rpts,[],3));
end
% do PEA
e=0;
xys=PEASIZE(1);
for l=1:nw;pt=rplist{l};
    rpt=pt+floor(30.*rand(size(pt))-15);
    rpt=mod(rpt,[s(1) s(2) sn])+1;
    for ll=1:nw;r=a(:,:,:,ll);
        peadata{++e}=pea_byhand_mean(r,pt,PEASIZE);
        rpeadata{e}=pea_byhand_mean(r,rpt,PEASIZE);
        peacent{e}=peadata{e}(HPEA(1),HPEA(2),HPEA(3));
        rpeacent{e}=rpeadata{e}(HPEA(1),HPEA(2),HPEA(3));
        imgz((l-1)*xys+1:l*xys,(ll-1)*xys+1:ll*xys)=nrm2d(max(peadata{e},[],3));
        rimgz((l-1)*xys+1:l*xys,(ll-1)*xys+1:ll*xys)=nrm2d(max(rpeadata{e},[],3));
    end
end

save("-binary",strcat(fn,".pea"),"peadata","rplist","peacent","rpeadata","rpeacent","imgz","rimgz");

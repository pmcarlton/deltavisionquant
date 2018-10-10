function mm=xs_measure(buf,name)

% xs_measure takes a 4-wavelength .STR straightened chromosome file, and does
% for each chromosome in the .STR file:
% - finds the COSA-1 focus
% - finds the chromosome length in pixels
% - finds the long/total and short/total ratios
% - integrates intensity of all signals on long and short arms
% - returns answer in structure array 'mm'
%
% 20180207pmc

pkg load image

spacing=3;
objwidth=13;
twidth=spacing+objwidth;

s=size(buf);
nxs=[s(2)+spacing]/twidth; % assumes .STR made with width=13 and spacing=3 :: s(2)+WIDTH/(WIDTH+SPACING)
printf("I think there are %i chromosomes based on image size. \n",nxs);
s1=sum(buf,3)==0;
s2=s1(1,:);
s3=(find(diff(s2)<0));
s4=length(s3)+1;
printf("I think there are %i chromosomes based on image spacing. \n",s4);

if(s4!=nxs),
    printf("%s has a chromosome discrepancy!",name);
end

td=[1 1+find(diff(s2)<0)];
tz=s1;tz(end+1,:)=1;
%for l=1:s4;tde(l)=min(find(tz(:,td(l))==1))-1;end %should have length of each obj
%the above was failing for special cases where a 0 value was part of an object
%(likely happened when the model got close to a zero-section created by
%z-shifting).
%the below should accurately report the first row where _all 13_ pixels of the
%chromosome are 1; i.e., the end row
for l=1:s4;tde(l)=min(find(sum(tz(:,td(l):td(l)+12),2)==objwidth))-1;end

f0=fspecial('gaussian',[13 13 2],2);
% f0=f0.*(f0>1e-4);        %% exclude corners; weighted
%f0=(f0>(1e-3));           %% exclude corners and border; masked
f0=f0.*(f0>(1e-2));           %% disk, weighted
f0=rotdim(f0,1,[1,3]);
f0(1,:,:)=[];

for iter=0:(s4-1)
    xsl=tde(iter+1);
%    printf("xsl is %i and that's what xsl is\n",xsl);

f=repmat(f0,[xsl 1 1]);

    cn=iter+1;

    colstart=td(iter+1);
    cols=[colstart]:[colstart+objwidth-1];
    xs=reshape(buf(1:xsl,cols,:),[xsl 13 13 4]);
    cosam=max(max(xs(:,:,:,2).*f,[],3),[],2);
    cm=find(cosam==max(cosam));
    cm=floor(mean(cm(:))); %in case it has 2 or more peaks
    if(cm>(xsl/2)),xs=flip(xs,1); %flips chromosome if COSA-1 is at "wrong" end
        cosam=max(max(xs(:,:,:,2).*f,[],3),[],2);
        cm=find(cosam==max(cosam)); %re-finds COSA-1 max if needed
        cm=floor(mean(cm(:))); %in case it has 2 or more peaks
    end

    dapi=xs(:,:,:,1);dapi.*=f;
    cosa=xs(:,:,:,2);cosa.*=f;
    sypp=xs(:,:,:,3);sypp.*=f;
    pans=xs(:,:,:,4);pans.*=f;
    %dapi=xs(:,:,:,1);dapi-=min(dapi(find(dapi(:))));dapi.*=f;
    %cosa=xs(:,:,:,2);cosa-=min(cosa(find(cosa(:))));cosa.*=f;
    %sypp=xs(:,:,:,3);sypp-=min(sypp(find(sypp(:))));sypp.*=f;
    %pans=xs(:,:,:,4);pans-=min(pans(find(pans(:))));pans.*=f;
    allimg=[nrm2d(sum(dapi,3)) nrm2d(sum(cosa,3)) nrm2d(sum(sypp,3)) nrm2d(sum(pans,3))];

    sa=cm/xsl;la=(xsl-cm)/xsl;

    mstr.allimg=allimg;
    mstr.xsl=xsl;
    mstr.cm=cm;

    mstr.dapisa=sum(sum(dapi(1:cm,:,:),2),3);
    mstr.cosasa=sum(sum(cosa(1:cm,:,:),2),3);
    mstr.syppsa=sum(sum(sypp(1:cm,:,:),2),3);
    mstr.panssa=sum(sum(pans(1:cm,:,:),2),3);

    mstr.dapila=sum(sum(dapi(cm+1:end,:,:),2),3);
    mstr.cosala=sum(sum(cosa(cm+1:end,:,:),2),3);
    mstr.syppla=sum(sum(sypp(cm+1:end,:,:),2),3);
    mstr.pansla=sum(sum(pans(cm+1:end,:,:),2),3);

    mstr.all=[[mstr.dapisa;mstr.dapila] [mstr.cosasa;mstr.cosala] ...
    [mstr.syppsa;mstr.syppla] [mstr.panssa;mstr.pansla]];
    mstr.nall=mstr.all-min(mstr.all); %broadcast 1x4->Nx4
    mstr.nall./=sum(mstr.nall); %normalized to summed intensity
    mstr.name=name;
    mm{cn}=mstr;
end


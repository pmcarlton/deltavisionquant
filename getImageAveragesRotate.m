function avgs=getImageAveragesRotate(N,xy,z,pl);

%
%function avgs=getImageAverages(N,xy,z,pl);
%N is the image data; xy and z are final neighborhood sizes; pl is point list

%customized -- expects 3 wavelengths, concatenated in Z!
%make sure to get points in correct orientation!
%make sure image data is double, not uint8!

%also rotates brightest point into RightForward quadrant; no changing Z (to preserve any chirality)

%20100407pmc

l=length(pl);

s=size(N);rows=s(1);cols=s(2);wsecs=s(3);
secs=wsecs/3;

w0=N(:,:,1:1+(secs-1));
w1=N(:,:,secs:((2*secs)-1));
w2=N(:,:,(2*secs):wsecs);

hxy=floor(xy/2);
hz=floor(z/2);

w0_m=zeros(xy,xy,z);
w1_m=zeros(xy,xy,z);
w2_m=zeros(xy,xy,z);

for li=1:l,
	xr=pl(li,1)-hxy : pl(li,1) + hxy;
	yr=pl(li,2)-hxy : pl(li,2) + hxy;
	zr=pl(li,3)-hz  : pl(li,3) + hz ;

	xr(find(xr<1)) = rows + xr(find(xr<1));
	yr(find(yr<1)) = cols + yr(find(yr<1));
	zr(find(zr<1)) = secs + zr(find(zr<1));

	xr(find(xr>rows))=xr(find(xr>rows))-rows;
	yr(find(yr>cols))=yr(find(yr>cols))-cols;
	zr(find(zr>secs))=zr(find(zr>secs))-secs;

	disp([xr yr zr]);
	w0p=w0(xr,yr,zr);
	w1p=w1(xr,yr,zr);
	w2p=w2(xr,yr,zr);

	if (mean(w0p(:,:,1:hz)(:)) > mean(w0p(:,:,hz+1:z)(:))),
	  w0p=rotdim(w0p,2,[1 3]);end
	w0q1=mean(w0p(1:hxy,1:hxy,:)(:));
	w0q2=mean(w0p(hxy+1:xy,1:hxy,:)(:));
	w0q3=mean(w0p(hxy+1:xy,hxy+1:xy,:)(:));
	w0q4=mean(w0p(1:hxy,hxy+1:xy,:)(:));
	[s1,s2]=sort([w0q1 w0q2 w0q3 w0q4]);
	w0p=rotdim(w0p,-(s2(end)-1),[1 2]);

	if (mean(w1p(:,:,1:hz)(:)) > mean(w1p(:,:,hz+1:z)(:))),
	  w1p=rotdim(w1p,2,[1 3]);end
	w1q1=mean(w1p(1:hxy,1:hxy,:)(:));
	w1q2=mean(w1p(hxy+1:xy,1:hxy,:)(:));
	w1q3=mean(w1p(hxy+1:xy,hxy+1:xy,:)(:));
	w1q4=mean(w1p(1:hxy,hxy+1:xy,:)(:));
	[s1,s2]=sort([w1q1 w1q2 w1q3 w1q4]);
	w1p=rotdim(w1p,-(s2(end)-1),[1 2]);

	if (mean(w2p(:,:,1:hz)(:)) > mean(w2p(:,:,hz+1:z)(:))),
	  w2p=rotdim(w2p,2,[1 3]);end

	w2q1=mean(w2p(1:hxy,1:hxy,:)(:));
	w2q2=mean(w2p(hxy+1:xy,1:hxy,:)(:));
	w2q3=mean(w2p(hxy+1:xy,hxy+1:xy,:)(:));
	w2q4=mean(w2p(1:hxy,hxy+1:xy,:)(:));
	[s1,s2]=sort([w2q1 w2q2 w2q3 w2q4]);
	w2p=rotdim(w2p,-(s2(end)-1),[1 2]);

%	w1p(hxy-3:hxy+3,hxy-3:hxy+3,:)=0;
	w0_m+=w0p;
	w1_m+=w1p;
	w2_m+=w2p;
	end

w0_m./=l;
w1_m./=l;
w2_m./=l;

avgs{1}=w0_m;avgs{2}=w1_m;avgs{3}=w2_m;


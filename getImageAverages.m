function avgs=getImageAverages(N,xy,z,pl);

%
%function avgs=getImageAverages(N,xy,z,pl);
%N is the image data; xy and z are final neighborhood sizes; pl is point list

%customized -- expects 3 wavelengths, concatenated in Z!
%make sure to get points in correct orientation!
%make sure image data is double, not uint8!

%20100407pmc

l=length(pl);

s=size(N);rows=s(1);cols=s(2);wsecs=s(3);
secs=wsecs/3;

w0=N(:,:,1:secs);
w1=N(:,:,secs+1:(2*secs));
w2=N(:,:,(2*secs)+1:wsecs);

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
	w0_m+=w0(xr,yr,zr);
	w1_m+=w1(xr,yr,zr);
	w2_m+=w2(xr,yr,zr);
	end

w0_m./=l;
w1_m./=l;
w2_m./=l;

avgs{1}=w0_m;avgs{2}=w1_m;avgs{3}=w2_m;

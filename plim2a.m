%pointlist and image -> mean of the images.
%conventions: the Axx start at 0 and go to N (you supply N)
%
%N  = the full image, made by placing each A0, A1, etc. in a section. 
%	  NB! make sure you know which wavelength is in which group
%xy = the desired xy neighborhood
%z  = the desired z  neighborhood
%pl = the list of points (x,y,z)



function avgs=getAvgs(N,xy,z,pl);

l=length(pl);

s=size(N);rows=s(1);cols=s(2);wsecs=s(3);
secs=wsecs/3;

w0=N(:,:,1:1+(secs-1));
w1=N(:,:,secs:((2*secs)-1));
w2=N(:,:,(2*secs):wsecs);


hxy=floor(xy/2);
hz=floor(z/2);

w0_4d=zeros(xy,xy,z,l);
w1_4d=w0_4d;
w2_4d=w0_4d;

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

	w0_4d(:,:,:,li)=w0(xr,yr,zr);
	w1_4d(:,:,:,li)=w1(xr,yr,zr);
	w2_4d(:,:,:,li)=w2(xr,yr,zr);

	end

avgs{1}=mean(w0_4d,4);
avgs{2}=mean(w1_4d,4);
avgs{3}=mean(w2_4d,4);


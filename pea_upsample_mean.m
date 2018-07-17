function result = pea_upsample_mean(im, pts, bs);
%function result = pea(im, pts, bs);
%point environment averaging
%example: bs=[9 9 5]; %x,y,z size of each 3D block
%given a list of points and an image data file, a final XYZ block size,
%place blocks centered at points into a new structure.
%to work directly with points as provided by FindPoints, it first transposes x/y to row/col
%for TIFF files: use flipud on raw images
%for Img2Mat files: use ' (transpose) on raw images
%020100716pmc
%UPSAMPLE version: define rsf (resize factor) 
%important point: the pts file should have subpixel precision if it's going to work
%it should also work without subpixel precision, of course
%020100820pmc

rsf=3;	%resize factor
pts=pts(:,[2 1 3 4]);
pts = pts + 1; %since FindPoints is zero-based
le=size(pts);
le=le(1);

x=bs(1);y=bs(2);z=bs(3);

subImage=zeros(x,y,z);
subIm2=zeros(size(subImage).*rsf);
result=zeros(size(subIm2));

s=size(im);xs=s(1);ys=s(2);zs=s(3);
hx1=floor(x/2)-1;hx2=x-hx1;
hy1=floor(y/2)-1;hy2=y-hy1;
hz1=floor(z/2)-1;hz2=z-hz1;

rows=[xs-hx1:xs 1:xs 1:hx2];
cols=[ys-hy1:ys 1:ys 1:hy2];
zscs=[zs-hz1:zs 1:zs 1:hz2];
% result = zeros([bs.*rsf le]);

for l=1:le;
	r=pts(l,:);
	rshift=r-floor(r);
	r=floor(r);
	theRows=rows(r(1):r(1)+(x-1));
	theCols=cols(r(2):r(2)+(y-1));
	theZscs=zscs(r(3):r(3)+(z-1));

	subImage = im(theRows,theCols,theZscs);
	for xq=1:x;
	  for yq=1:y;
		for zq=1:z;
		  roq=((xq-1)*rsf+1:xq*rsf);
		  coq=((yq-1)*rsf+1:yq*rsf);
		  zoq=((zq-1)*rsf+1:zq*rsf);
	      subIm2(roq,coq,zoq)=subImage(xq,yq,zq); 
end;end;end

	  rshift .*= rsf;
	  rshift = fix(rshift);
	  subIm2 = circshift(subIm2,-rshift(1:3));
	
	  %if you want to normalize:
	  if(find(subIm2)), subIm2 -= min(subIm2(:));subIm2 ./= max(subIm2(:));end

	result += subIm2;

	disp(le-l);fflush(stdin);
	end


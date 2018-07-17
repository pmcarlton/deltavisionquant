function result = pea_subpixel(im, pts, bs);
%function result = pea(im, pts, bs);
%point environment averaging
%example: bs=[9 9 5]; %x,y,z size of each 3D block
%given a list of points and an image data file, a final XYZ block size,
%place blocks centered at points into a new structure.
%to work directly with points as provided by FindPoints, it first transposes x/y to row/col
%for TIFF files: use flipud on raw images
%for Img2Mat files: use ' (transpose) on raw images
%020100716pmc
%modifications for sub-pixel shifting: use interpn!
%first try, 020100811pmc


pts=pts(:,[2 1 3 4]);
le=size(pts);
le=le(1);

pts = pts + 1; %since FindPoints is zero-based
sbp=pts-floor(pts);
pts=floor(pts);

x=bs(1);y=bs(2);z=bs(3);
[xx,yy,zz]=ndgrid(1:x,1:y,1:z);

s=size(im);xs=s(1);ys=s(2);zs=s(3);
hx1=floor(x/2)-1;hx2=x-hx1;
hy1=floor(y/2)-1;hy2=y-hy1;
hz1=floor(z/2)-1;hz2=z-hz1;

rows=[xs-hx1:xs 1:xs 1:hx2];
cols=[ys-hy1:ys 1:ys 1:hy2];
zscs=[zs-hz1:zs 1:zs 1:hz2];
result = zeros([bs le]);

for l=1:le;
	r=pts(l,:);
	thesbp=sbp(l,:);
	theRows=rows(r(1):r(1)+(x-1));
	theCols=cols(r(2):r(2)+(y-1));
	theZscs=zscs(r(3):r(3)+(z-1));

	subImage = im(theRows,theCols,theZscs);
	%if(find(subImage)), subImage -= min(subImage(:));subImage ./= max(subImage(:));end
	subImage = interpn(xx,yy,zz,subImage,xx+thesbp(1),yy+thesbp(2),zz+thesbp(3),'linear',0);
	result(:,:,:,l) = subImage;
	end

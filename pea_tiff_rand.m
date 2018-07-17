function result = pea_tiff_rand(im, pts, bs);
%point environment averaging
%example: bs=[9 9 5]; %x,y,z size of each 3D block
%given a list of points and an image data file, a final XYZ block size,
%place blocks centered at points into a new structure.
%to work directly with points as provided by FindPoints, it first transposes x/y to row/col: [1 2 3 4]->[2 1 3 4]
%pea_tiff_rand = uses random points, to control

pts=pts(:,[2 1 3]);
pts = pts + 1; %since FindPoints is zero-based
le=length(pts);

x=bs(1);y=bs(2);z=bs(3);

ptthr=max(pts);
for l=1:le;
  pts(l,1)=predrand(pts(l,1),ptthr(1));
  pts(l,2)=predrand(pts(l,2),ptthr(2));
  pts(l,3)=predrand(pts(l,3),ptthr(3));
end

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
	theRows=rows(r(1):r(1)+(x-1));
	theCols=cols(r(2):r(2)+(y-1));
	theZscs=zscs(r(3):r(3)+(z-1));

	subImage = im(theRows,theCols,theZscs);
	%if(find(subImage)), subImage -= min(subImage(:));subImage ./= max(subImage(:));end
	result(:,:,:,l) = subImage;

	end



function yy=predrand(pt,thr);

%predictably 'randomizes' a point to a new point 1->threshold

pt=pt+1827312;
pt=pt*ceil(pt/2);
pt=pt.*sin(pt);
pt=ceil(pt);
yy=mod(pt,thr)+1;
end


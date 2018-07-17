function result = pea_tiff_circrand(im, pts, bs, ra);
%point environment averaging
%example: bs=[9 9 5]; %x,y,z size of each 3D block
%given a list of points and an image data file, a final XYZ block size,
%place blocks centered at points into a new structure.
%to work directly with points as provided by FindPoints, it first transposes x/y to row/col: [1 2 3 4]->[2 1 3 4]
%pea_tiff_circrand = uses points intentionally shifted to +r, to control

pts=pts(:,[2 1 3]);
pts = pts + 1; %since FindPoints is zero-based
le=length(pts);

theta=rand(le,1).*2.*pi;theta-=pi;
thx=ra.*cos(theta);thy=ra.*sin(theta);
thx=ceil(thx-.5);thy=ceil(thy-.5);
pts(:,1)+=thx;pts(:,2)+=thy;

x=bs(1);y=bs(2);z=bs(3);

s=size(im);xs=s(1);ys=s(2);zs=s(3);
hx1=floor(x/2)-1;hx2=x-hx1;
hy1=floor(y/2)-1;hy2=y-hy1;
hz1=floor(z/2)-1;hz2=z-hz1;

rows=[xs-(hx1+ra):xs 1:xs 1:(hx2+ra)];
cols=[ys-(hy1+ra):ys 1:ys 1:(hy2+ra)];
zscs=[zs-hz1:zs 1:zs 1:hz2];
result = zeros([bs le]);

for l=1:le;
	r=pts(l,:);
	theRows=rows((r(1)+ra):(r(1)+ra)+(x-1));
	theCols=cols((r(2)+ra):(r(2)+ra)+(y-1));
	theZscs=zscs(r(3):r(3)+(z-1));
	subImage = im(theRows,theCols,theZscs);
	%if(find(subImage)), subImage -= min(subImage(:));subImage ./= max(subImage(:));end
	result(:,:,:,l) = subImage;

	end

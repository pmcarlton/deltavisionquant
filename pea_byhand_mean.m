function result = pea_byhand_mean(im, pts, bs);
%function result = pea(im, pts, bs);
%point environment averaging
%example: bs=[9 9 5]; %x,y,z size of each 3D block
%given a list of points and an image data file, a final XYZ block size,
%place blocks centered at points into a new structure.
%020100722pmc

%do not change 'pts', since we made it 'by hand' ha ha
%EXCEPT: should probably add 1, since octave is 1-based and FindPoints zero-based. Works out of the box when using mrcread. 20110609pmc

le=length(pts);

x=bs(1);y=bs(2);z=bs(3);
s=size(im);xs=s(1);ys=s(2);zs=s(3);
hx1=floor(x/2)-1;hx2=x-hx1;
hy1=floor(y/2)-1;hy2=y-hy1;
hz1=floor(z/2)-1;hz2=z-hz1;

rows=[xs-hx1:xs 1:xs 1:hx2];
cols=[ys-hy1:ys 1:ys 1:hy2];
zscs=[zs-hz1:zs 1:zs 1:hz2];
result = zeros([bs]);

for l=1:le;
	r=pts(l,:);
	theRows=rows(r(1):r(1)+(x-1));
	theCols=cols(r(2):r(2)+(y-1));
	theZscs=zscs(r(3):r(3)+(z-1));

	subImage = im(theRows,theCols,theZscs);
%	if(find(subImage)), subImage -= min(subImage(:));subImage ./= max(subImage(:));end %uncomment to normalize intensities
	result(:,:,:) += subImage;

	end
	result ./= le;

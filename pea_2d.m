function result = pea_2d(im, pts, bs);
%function result = pea(im, pts, bs);
%point environment averaging
%example: bs=[9 9]; %x,y size of each 322block
%given a list of points and an image data file, a final XY block size,
%place blocks centered at points into a new structure.
%020100830

%do not change 'pts', since we made it 'by hand' ha ha

le=length(pts);

x=bs(1);y=bs(2);
s=size(im);xs=s(1);ys=s(2);
hx1=floor(x/2)-1;hx2=x-hx1;
hy1=floor(y/2)-1;hy2=y-hy1;

rows=[xs-hx1:xs 1:xs 1:hx2];
cols=[ys-hy1:ys 1:ys 1:hy2];
result = zeros([bs le]);

f1=find(pts(:,1)<=0);pts(f1,1)+=xs;
f1=find(pts(:,2)<=0);pts(f1,2)+=ys;
f1=find(pts(:,1)>xs);pts(f1,1)-=xs;
f1=find(pts(:,2)>ys);pts(f1,2)-=ys;

for l=1:le;
	r=pts(l,:);
	theRows=rows(r(1):r(1)+(x-1));
	theCols=cols(r(2):r(2)+(y-1));

	subImage = im(theRows,theCols);
	%if(find(subImage)), subImage -= min(subImage(:));subImage ./= max(subImage(:));end
%	result(:,:,l) = radavg2d(subImage);
	result(:,:,l) = (subImage);

	end





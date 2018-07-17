function result = shiftXYZ2(inmat, shft)

% shifts inmat by xs, ys, zs
% where -1 < xs ys zs < 1

xs=shft(1);ys=shft(2);zs=shft(3);
xs2=1-xs;ys2=1-ys;zs2=1-zs;
xsm=[xs xs2];
ysm=[ys;ys2];
zsm=[zs zs2]; %so we'll need to do some rotation.

s=size(inmat);
if(length(s) < 3), disp("Matrix to shift must be 3D!");break;
end
ysize=s(2);
zsize=s(3);
for l=1:zsize;
    inmat(:,:,l)=conv2(inmat(:,:,l),xsm,'same');
	  inmat(:,:,l)=conv2(inmat(:,:,l),ysm,'same');
	end

	inmat=rotdim(inmat,1,[2 3]);
	for l=1:ysize;
	    inmat(:,:,l)=conv2(inmat(:,:,l),zsm,'same');
	  end

	  result=rotdim(inmat,-1,[2 3]);


function result = shiftXYZ(inmat, xyz)

% shifts inmat by xs, ys, zs
% where -1 < xs ys zs < 1
% uses interpn - easier?
% first argument shifts rows, second shifts cols, third shifts planes!
xs=xyz(1);ys=xyz(2);zs=xyz(3);
s=size(inmat);
if(length(s) < 3), disp("Matrix to shift must be 3D!");break;
end

[x,y,z]=ndgrid(1:s(1),1:s(2),1:s(3));

result=interpn(x,y,z,inmat,x+xs,y+ys,z+zs,'linear',0);


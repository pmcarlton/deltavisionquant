function nnp=placeNPs(np,tri)
%reads in a mesh of triangles and normals (3N x 6, output of 'reo.m') and a grid of points (the NP coordinates)
%and moves each point to the plane defined by the nearest triangle midpoint and the normal of that triangle

%first re-calculate triangle midpoints and normals (lame..)
l=length(tri);
tri=tri(:,1:3);
tri2=reshape(reshape(tri,[3 l])',[l/3 3 3]);

trimidpoints=mean(tri2,3);

trinorms=cross(tri(3:3:end,:)-tri(1:3:end,:),tri(2:3:end,:)-tri(1:3:end,:));

lt=length(trimidpoints);
ln=length(np);
for i=1:ln;
    nm=repmat(np(i,:),[lt 1]);
    nm=nm-trimidpoints;
    nm=sqrt(sum(nm'.^2)');
    npi(i)=find(nm==min(nm));
    end
%now have indices of triangles that are closest to each NP point

trimidpoints_do=trimidpoints(npi,:);
disp("trimidpoints_do"),disp(size(trimidpoints_do));
trinorms_do=trinorms(npi,:);
disp("trinorms_do"),disp(size(trinorms_do));

sn=-dot(trinorms_do,np-trimidpoints_do,2);
disp("sn"),disp(size(sn));
sd=dot(trinorms_do,trinorms_do,2);
disp("sd"),disp(size(sd));
sb=sn./sd;
disp("sb"),disp(size(sb));

nnp = np+(repmat(sb,[1 3]).*trinorms_do);

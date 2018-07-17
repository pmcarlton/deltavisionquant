function v = minimizeradiusvar4d(subtraction,x)  %  ,lastval)

    % subtracts 'subtraction' from x, then finds variance of radius in polar coords
	%does for 4d - i.e., given tracks along the surface of a nucleus, finds the xyz coordinates that minimize (1)variance of the radius to the tracks and (2)variance of the track from itself
    %20090427  pmc

%  e=zeros(60,5);guess=[0 0 0];for l=1:60;if(l>2),guess=e(l-1,1:3);end;f=find(a(:,5)==l);r=a(f,1:3);[e(l,1:3),e(l,4),e(l,5)]=adsmax('minimizeradiusvar3d',guess,[1e-4 Inf],[],eye(3),r);end

%input x size is [Ntimes, 3, Ntracks]
%input subtraction size is [Ntimes,3]
ss=size(x);
subtraction=repmat(subtraction,[1 1 ss(3)]);
y=x-subtraction;
ra=squeeze(sqrt(sum(y.^2,2)));
%testrad=mean(ra-2);
v2=mean(diff(ra).^2);v2=mean(v2(:));
%ra=ra(:);
testrad=mean(ra(:));
v = median(var(ra,[],2));
%v=1/(testrad*(v*v2));
v=1/(testrad*(v)*v2);


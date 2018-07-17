function v = minimizeradiusvar3d(subtraction,x)  %  ,lastval)

    % subtracts 'subtraction' from x, then finds variance of radius in polar coords
    % minimizing var(r) should show best circle
    %20090427  pmc
    %

%  e=zeros(60,5);guess=[0 0 0];for l=1:60;if(l>2),guess=e(l-1,1:3);end;f=find(a(:,5)==l);r=a(f,1:3);[e(l,1:3),e(l,4),e(l,5)]=adsmax('minimizeradiusvar3d',guess,[1e-4 Inf],[],eye(3),r);end


y=x-repmat(subtraction,[length(x) 1]);
ra=sqrt(sum(y.^2,2));
%testrad=mean(ra-2);
testrad=mean(ra.^2);
v = var(ra);
disp(v);
v=1/((testrad^2)*v);


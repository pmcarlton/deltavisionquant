function v=radmin(centers,points)
% for finding centers of point clusters
rad=0.55;
s=rows(centers);
rp=rows(points);
d=zeros(rp,s);
for l=1:s;
    dd=points-repmat(centers(l,:),[rp 1]);
    d(:,l)=sqrt(sum(dd.^2,2));
    end
e=d;
e(find(e<rad))=0;
e=min(e,[],2);

printf("uncp= %i ",length(find(e)));
v=(sum(e).^2);
%v=sqrt(sum(e));
printf("v= %.4f \n",v);
end

function [res,info]=nuc2shel(nuc,shn);

%takes a 3d bw image (nuc), does bwdistsc, and returns NxM matrix
%of M shells, each with N pixels (matrix contains indices into nuc)

tmp=bwdistsc(1 - nuc,[.0396 .0396 .125]);  %since the nucleus is positive, and we want distance from 1-pixels. aspect ratio for standard OMX images
f=find(tmp);
l=length(f);
m=l./shn;
m=floor(m);
ll=m.*shn;

eb=tmp(f);
[h,i]=sort(eb);
f=f(i);
h=h(1:ll);i=i(1:ll);f=f(1:ll);
disp(l-ll);disp('missing values');
res=reshape(f,[m shn]);

for l=1:shn;
	r=tmp(res(:,l));r=r(:);
	rqmin(l)=min(r);
	rqmean(l)=mean(r);
	rqmax(l)=max(r);
	end
info=[rqmin;rqmean;rqmax]';
	


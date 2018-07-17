function [res,info]=nuc2shel3(nuc,sheldist);

%takes a 3d bw image (nuc), does bwdistsc, and returns NxM matrix
%of M shells, of varying pixel number  but equal distance

tmp=bwdistsc(1 - nuc,[.0396 .0396 .125]);  %since the nucleus is positive, and we want distance from 1-pixels. aspect ratio for standard OMX images
f=find(tmp);
l=length(f);
%m=l./shn;
%m=floor(m);
%ll=m.*shn;

eb=tmp(f);
mind=min(eb);maxd=max(eb);
%sheld=linspace(mind,maxd,shn);
sheld=(mind:sheldist:maxd);
shn=length(sheld);
for li=1:(shn-1);
	f2=f(find((eb>=sheld(li)) & (eb<sheld(li+1))));
	res{li}=(f2);
    end

for l=1:(shn-1);
	r=tmp(res{l});r=r(:);
	rqmin(l)=min(r);
	rqmean(l)=mean(r);
	rqmax(l)=max(r);
	end
info=[rqmin;rqmean;rqmax]';


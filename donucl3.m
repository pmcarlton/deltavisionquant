function [ee,res,dapi,info]=donucl3(data,sheldist,thresh)

%function [ee,res,dapi,info]=donucl3(data,sheldist,thresh)
%goes from nucleus to intensity-by-shell for all 3 wavelengths.
%highly customized -- 1 stack containing all 3 waves, dapi is 1st third.
%return values: ee=shell data,res=result,dapi=masked dapi,info=mean dist of each shell etc
%20100926pmc
%donucl3 = use distance sheldist, not number of shells (i.e. use 100nm = 0.1 for sheldist)

s=size(data);
nz=s(3);
z=nz/3;

d=data(:,:,1:z);
p1=data(:,:,(z+1):(z*2));
p2=data(:,:,(z*2+1):nz);

e=d-d;
for l=1:z;
e(:,:,l)=getnuc2(data(:,:,l),thresh,1);
end
e=convexifyz(e);

dapi=e;
[ee,info]=nuc2shel3(e,sheldist);
nshells=length(info);

for l=1:(nshells)
  	r=d(ee{l});r=r(find(r>0));
	dai(l)=sum(r);
  	r=p1(ee{l});r=r(find(r>0));
	p1i(l)=sum(r);
  	r=p2(ee{l});r=r(find(r>0));
	p2i(l)=sum(r);

%	dai(l)=sum(d(ee{l}));
%	p1i(l)=sum(p1(ee{l}));
%	p2i(l)=sum(p2(ee{l}));
	eal(l)=length(ee{l});
	end

res=[dai;p1i;p2i;eal]';


function [ee,res,dapi,info]=donucl2debug(data,nshells,thresh)

%function [ee,res,dapi,info]=donucl2debug(data,nshells,thresh)
%goes from nucleus to intensity-by-shell for all 3 wavelengths.
%highly customized -- 1 stack containing all 3 waves, dapi is 1st third.
%return values: ee=shell data,res=result,dapi=masked dapi,info=mean dist of each shell etc
%20100926pmc

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
[ee,info]=nuc2shel2(e,nshells);

%octave:616> #for l=1:10;dai(l)=sum(d(f(:,l)));rei(l)=sum(re(f(:,l)));gri(l)=sum(gr(f(:,l)));end

for l=1:(nshells-1)
	dai(l)=sum(d(ee{l}));
	eal(l)=length(ee{l});
	p1i(l)=sum(p1(ee{l}));
	p2i(l)=sum(p2(ee{l}));
	end

res=[dai;p1i;p2i;eal]';


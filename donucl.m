function [res,dapi,info]=donucl(data,nshells,thresh)

%goes from nucleus to intensity-by-shell for all 3 wavelengths.
%highly customized -- 1 stack containing all 3 waves, dapi is 1st third.
%20100926pmc

s=size(data);
nz=s(3);
z=nz/3;

d=data(:,:,1:z);
p1=data(:,:,(z+1):(z*2));
p2=data(:,:,(z*2+1):nz);

e=d-d;
for l=1:z;
e(:,:,l)=getnuc(data(:,:,l),thresh,1);
end

dapi=e;
[e,info]=nuc2shel(e,nshells);

%octave:616> #for l=1:10;dai(l)=sum(d(f(:,l)));rei(l)=sum(re(f(:,l)));gri(l)=sum(gr(f(:,l)));end

for l=1:nshells
	dai(l)=sum(d(e(:,l)));
	p1i(l)=sum(p1(e(:,l)));
	p2i(l)=sum(p2(e(:,l)));
	end

res=[dai;p1i;p2i]';

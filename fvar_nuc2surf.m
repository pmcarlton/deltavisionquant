#!/usr/bin/octave -q
function [surfs,nuccenters,maxdapi,mpts]=fvar_nuc2surf(DAPI);
#f_nuc2surf.m -- function for finding nuclei centers, 2013-06-10pmc

W=3;HW=floor(W/2);
pixsize=[.064 .064 .2];

disp("finding nucleus centers...");fflush(1);
DAPI-=min(DAPI(:));
DAPI./=max(DAPI(:)); #normalized
maxdapi=max(DAPI,[],3);
dlevel=graythresh(maxdapi);
localmax=minmaxfilt(DAPI,W,'max','same');
do; %do-loop added 20130617 to prevent too-many-points syndrome
dapisignals=( (localmax==DAPI) .* (DAPI>= dlevel) );
f=find(dapisignals);
[dx dy dz]=ind2sub(size(DAPI),f);
dpts=[dx dy dz].*repmat(pixsize,[length(dx) 1]);
#dpts=[dx dy dz].*repmat([.064 .064 .2],[length(dx) 1]);
printf("using %i peaks...",length(f));
dlevel*=1.05; %part of do-loop
until(length(f)<25000); %part of do-loop

rad=2;bb=dpts;o=2;
pmove=10;
for ll=1:pmove;
    aa=bb;
    for l=1:length(dpts);
        r=repmat(aa(l,:),[length(aa) 1]);
        r=sqrt(sum((aa-r).^2,2));
        r(find(r==0))=(max(r)+(2*rad));
        f=find(r<rad & r>.128); #ignore closer than 2 pixels
        if(f),
            r=mean(aa(f,:))-aa(l,:);
            xx=r./sqrt(sum(r.^2));
            bb(l,:)=aa(l,:)+(xx./o);
        end
        mpts{ll}=bb;
    end
    printf("%i ",pmove-ll);fflush(1);
end

#now center clusters are in bb
#replace all points <2rad with 0
ee=0;
for l=1:length(bb);
    r=bb(l,:);
    if(r),
        f=find(bb(:,1));
        r=repmat(r,[length(f) 1]);
        r-=bb(f,:);
        r=sqrt(sum(r.^2,2));
        ff=find(r<(2*rad));
        ee=ee+1;
        surfs1{ee}=[dpts(f(ff),:) f(ff)];
        bb(f(ff(2:end)),:)=0;
        end
    end

e=0;
for l=1:length(surfs1);
    r=surfs1{l};
    if(size(r)(1))>20, %need to have >= 20 points 
        [h,v]=convhulln(r(:,1:3),'Pp');
        if(v>6), %seems rather small, but some nuclei are small?!
            e=e+1;
            surfs{e}=r;
            volumes(e)=v;
            hulls{e}=h;
            end
        end
    end

nuccenters=zeros(length(surfs),3);
for l=1:length(surfs);
r=surfs{l};
nuccenters(l,:)=mean(r(:,1:3));
end
surfs=surfs1; %all of them, put this back when solved!20130610pmc
end #endfunction

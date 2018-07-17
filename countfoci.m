function [npts,ptdists]=countfoci(nuc1, pts1,maxdapi,maxrad,name)

#countfoci.m
#Usage:
#inputs `nuc1` and `pts1` are lists of 3d pts (whitespace-separated x, y, z coords) (with possibly extra columns that are ignored)
#`nuc` should be the centers of nuclei found with fociscript.m
#`pts` should be the centers of RAD-51 or other foci 
#the program calculates all possible nuc x pts distances and makes some
#reasonable assumptions about clustering to assign points to nuclei.
#20130605pmc

[a001,a002]=system("uuidgen");
save('-hdf5',strcat('/tmp/lastplot',a002,'.hdf'),'nuc1','pts1','maxdapi','maxrad','name');
#make the background picture:
gtmx=graythresh(maxrad);
maxdapi-=nrm2d(conv2(maxrad>(gtmx+std(maxrad(find(maxrad>gtmx)))),fspecial('gaussian',[5 5],1),'same'));
#maxdapi-=nrm2d(conv2(maxrad>gtmx),fspecial('gaussian',[5 5],1),'same'));
maxdapi=(flipud(rot90(maxdapi)));

CIRC=(2.*[sin(pi/10:pi/10:2*pi);cos(pi/10:pi/10:2*pi)])';
MAXRAD=3.0;

nuc=nuc1(:,1:3);pts=pts1(:,1:3);
nnuc=size(nuc)(1);
lenpts=size(pts)(1);

ptdists=zeros(lenpts,1);

# get the vector of nearest neighbors:

nne=zeros(lenpts,1);
for l=1:lenpts;
    r=nuc-repmat(pts(l,:),[nnuc 1]); r=sqrt(sum(r.^2,2));
    r=r+(.000001.*rand(size(r))); #break ties
    nne(l)=find(r==min(r));
    end

# assign points to each nucleus

for l=1:nnuc;
#    pt{l}=[0 0 0]; %trying to keep 0-focus nuclei
    pt{l}=[];
    ptsbs=find(nne==l);
    if(ptsbs),
        thepts=pts(ptsbs,:); #limit choices to points that are nearest neighbors to current nucleus
        nthepts=size(thepts)(1);
        r=sqrt(sum((repmat(nuc(l,:),[nthepts 1])-thepts).^2,2)); #all distances in one go
        ptdists(ptsbs)=r;
        [h,i]=sort(r);
        hm=max(find(h<MAXRAD));
        if(hm),
            pt{l}=thepts(i(1:hm),:); #simply keeping all points below MAXRAD
            end
        end
    end

npts=pt;

close all;hold off;figure(1);hold on;
imagesc(maxdapi);colormap gray;axis square;
ttl=strrep(name,"_","\\_"); #prevent underscore->subscript conversion in title
title(ttl);
for l=1:nnuc;
    xy=[CIRC+repmat(nuc(l,1:2),[length(CIRC) 1])];
    if(!isempty(npts{l})),
        xy=[xy ; npts{l}(:,1:2)];
        xy=xy(convhull(xy(:,1),xy(:,2),"Pp"),:); #Pp suppresses verbose output
        xy./=.064;
        patches(l)=plot(xy(:,1),xy(:,2),'color',[0.70703125 0.53515625 0],'linewidth',2);
        fcn(l)=size(npts{l})(1);
        plot(npts{l}(:,1)./.064,npts{l}(:,2)./.064,'o','markersize',2,'linewidth',0.25,'color',[0.421875 0.44140625 0.765625]);
        text(nuc(l,1)./.064,nuc(l,2)./.064,num2str(fcn(l)),'color',[0.04 0.02 0.05],'fontname','courier','fontsize',15,'horizontalalignment','center');
    else
        xy./=.064;
        patches(l)=plot(xy(:,1),xy(:,2),'color',[0.70703125 0.33515625 0],'linewidth',1);
        text(nuc(l,1)./.064,nuc(l,2)./.064,'0','color',[0.44 0.02 0.05],'fontname','courier','fontsize',15,'horizontalalignment','center');
        end
    end
hold off;axis image;
print(1,strcat(name,'.eps'),'-color');
%disp('number of foci in each nucleus:');
%disp(fcn)
close
end %end function

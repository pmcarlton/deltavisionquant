function [npts,ptdists]=countfoci(nuc1, pts1,maxdapi,maxrad,name)

#countfoci.m
#Usage:
#inputs `nuc1` and `pts1` are lists of 3d pts (whitespace-separated x, y, z coords) (with possibly extra columns that are ignored)
#`nuc` should be the centers of nuclei picked with "PickPoints" in Priism
#`pts` should be the results file from FindPeaks in Priism
#the program calculates all possible nuc x pts distances and makes some
#reasonable assumptions about clustering to assign points to nuclei.
#20130605pmc

# spent a lot of time on this, but I think there's no alternative to loading the DAPI channel and using that as a clue to where to draw the line;
# there will never be a principled way to choose which focus truly belongs to another if it's close to midway between the two nuclear centers.
# TODO implement as an interactive shell: ask the user for the DATA file, the NUCPTS file, and the RADPTS file, then let it crunch
# yay, more computing...type2? 20130605pmc

#of course - should sort by nearest neighbor first (7pm)

maxdapi-=nrm2d(conv2(maxrad>graythresh(maxrad),fspecial('gaussian',[5 5],1),'same'));
maxdapi=(flipud(rot90(maxdapi)));
% maxrad=(flipud(rot90(maxrad)));
% maxdapi=repmat(1-(nrm2d(maxdapi)),[1 1 3]);
% maxdapi(:,:,1)-=((nrm2d(maxrad)));
% maxdapi(:,:,3)-=((nrm2d(maxrad)));
% maxdapi.^=2;

CIRC=(2.*[sin(pi/10:pi/10:2*pi);cos(pi/10:pi/10:2*pi)])';
MAXRAD=3.0;
MINRAD=3;
PRUNEPTS=30;

nuc=nuc1(:,1:3);pts=pts1(:,1:3);
nnuc=size(nuc)(1);
lenpts=size(pts)(1);

ptdists=zeros(lenpts,1);

#nuc.*=repmat([.064 .064 .2],[nnuc 1]);
#pts.*=repmat([.064 .064 .2],[lenpts 1]);

JUMP=[5 0 0];
# get the vector of nearest neighbors:

nne=zeros(lenpts,1);
for l=1:lenpts;
    r=nuc-repmat(pts(l,:),[nnuc 1]); r=sqrt(sum(r.^2,2));
    r=r+(.000001.*rand(size(r))); #break ties
    nne(l)=find(r==min(r));
    end

# assign points to each nucleus

for l=1:nnuc;
    pt{l}=[];
    ptsbs=find(nne==l);
    if(ptsbs),
        thepts=pts(ptsbs,:); #limit choices to points that are nearest neighbors to current nucleus
    #    thepts=[thepts;mean(thepts)+JUMP];
        nthepts=size(thepts)(1);
        r=sqrt(sum((repmat(nuc(l,:),[nthepts 1])-thepts).^2,2)); #all distances in one go
        ptdists(ptsbs)=r;
        #ptdists(ptsbs)=r(1:end-1); #end-1 so as not to include the JUMP-distance
        [h,i]=sort(r);
        hm=max(find(h<MAXRAD));
    #    hi=min(find(h>=mean(h)));h(1:hi)=h(hi);
    #    disp(['hi' num2str(hi) 'hm' num2str(hm)]);
    #    rdi=diff(h(1:hm));
    #    rd=max(find(rdi==max(rdi))); #going by biggest jump...not the best assumption at all
    #    disp('rd is');disp(rd);disp('and that is what rd is.');
        if(hm),
            pt{l}=thepts(i(1:hm),:); #simply keeping all points below MAXRAD
            end
        #pt{l}=thepts(i(1:rd),:);
        end
    end

# prune more based on distances within the point set, if more than N points are there

# for l=1:nnuc;
#     dmat=[];
#     rp=pt{l};
#     rpl=size(rp)(1);
#     if(rpl > PRUNEPTS), #debug
#         for li=1:rpl;
#         rp2=rp; rp2(li,:)=[];
#         r=repmat(rp(li,:),[rpl-1 1]);r-=rp2;
#         r=sqrt(sum(r.^2,2));
#         dmat(:,li)=r;
#         end;
#         dmi=mean(min(dmat))+(std(min(dmat)));
#         dmif=max(find(min(dmat)<=dmi));
#         npts{l}=rp(1:dmif,:);
#             else
#             npts{l}=pt{l};
#         end
#     end
npts=pt;

close all;hold off;figure(1);hold on;
#image(flipud(rot90(-maxdapi)));
imagesc(maxdapi);colormap gray;axis square;
#plot(pts(:,1)./.064,pts(:,2)./.064,'kx','markersize',4);

for l=1:nnuc;
    if(!isempty(npts{l})),
        xy=[CIRC+repmat(nuc(l,1:2),[length(CIRC) 1])];
        xy=[xy ; npts{l}(:,1:2)];
        xy=xy(convhull(xy(:,1),xy(:,2),"Pp"),:); #Pp suppresses verbose output
        xy./=.064;
        patches(l)=plot(xy(:,1),xy(:,2),'color',[0.70703125 0.53515625 0]);
        fcn(l)=size(npts{l})(1);
        plot(npts{l}(:,1)./.064,npts{l}(:,2)./.064,'o','markersize',4,'linewidth',1,'color',[0.421875 0.44140625 0.765625]);
        text(nuc(l,1)./.064,nuc(l,2)./.064,num2str(fcn(l)),'color',[0.04 0.02 0.05],'fontname','courier','fontsize',21,'horizontalalignment','center');
        end
    end
print(1,strcat(name,'.eps'),'-color','-solid');
%disp('number of foci in each nucleus:');
%disp(fcn)
close
end %end function

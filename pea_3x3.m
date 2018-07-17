#20110613pmc - 
#for 3 wavelengths
#supply an image data file of 3 wavelengths, and 3 point files as a cell array,
#and this program does the 3x3 PEA (mean)

function res=pea_3x3(img,pl,bsize)

debug_on_error(1);
xysize=bsize(1:2);zsize=bsize(3);
out=zeros(xysize(1)*3,xysize(1)*3,zsize);

s=size(img);
zs=s(3)/3;
ra{1}=1:zs;ra{2}=(zs+1):zs*2;ra{3}=(zs*2)+1:zs*3;
e=0;
for li=0:2
    pts=pl{li+1};
    pts=pts(:,1:3)+1;   %so keep the points as FindPeaks gives them to you
    for li2=0:2
        e=e+1;
        res{e}=pea_byhand_mean(img(:,:,ra{li2+1}),pts,bsize);
        res{e}-=min(res{e}(:));
        res{e}./=max(res{e}(:));
        printf("%i %i ,", li,li2);
        fflush(stdout);
    end
end


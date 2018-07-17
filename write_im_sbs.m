function fn=write_im_sbs(fname)
fn=0; sz=64; am=[];
a=mrcread(fname);
s=size(a);
for m=1:s(3);
    am(m)=var(a(:,:,m)(:)).*mean(a(:,:,m)(:));
    end;
a=a(17:end-16,17:end-16,find(am>=(max(am)./1.2)));
aq=im2col(a,[sz sz],"distinct");
clear a;
aqs=sum(aq);
aq=aq(:,find(aqs>=(mean(aqs)./2)));
if(!(isempty(aq))),aq=nrm2d(aq);
    ss=size(aq);
    for mm=1:ss(2);
        imt=strcat(fname,sprintf("_tko%.6i.png",mm));
        imwrite((reshape(aq(:,mm),[sz sz])),imt);
        fn=fn+1;
        disp(imt); fflush(1);
        end;
    end;
end

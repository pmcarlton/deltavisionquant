#!/usr/bin/octave  -q

fn=argv;fn=fn{1};fnout=strcat(fn,'.txt');
load(fn);
o=1;
e=0;
for l=1:2;for ll=1:3;
    r=eval(strcat('p',num2str(ll),num2str(l))); %iterates p11,p21,p31,p12,p22,p32
    sr=[size(r)+1]./2;
    r=r(sr(1)-o:sr(1)+o,sr(2)-o:sr(2)+o,sr(3)-o:sr(3)+o,:)(:);
    e=e+1;
    y(:,e)=hist(r,100);  %to get histograms
end;end

dlmwrite(fnout,y,"\t");

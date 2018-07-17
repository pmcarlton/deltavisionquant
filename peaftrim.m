#!/usr/bin/octave  -q

fn=argv;fn=fn{1};fnout=strcat(fn,'.sbs');
load(fn);
o=1;
e=0;
for l=1:2;for ll=1:3;
    e=e+1;
    r=eval(strcat('p',num2str(ll),num2str(l))); %iterates p11,p21,p31,p12,p22,p32
    sr=[size(r)+1]./2;
    rr{e}=r(sr(1)-o:sr(1)+o,sr(2)-o:sr(2)+o,sr(3)-o:sr(3)+o,:);
    rnames{e}=strcat('p',num2str(ll),num2str(l));
end;end

save("-binary",fnout,"rr","rnames");

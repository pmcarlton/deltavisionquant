#!/usr/bin/octave  -q

fn=argv;fn=fn{1};fnout=strcat(fn,'.txt');
load(fn);
p11=rr{1};p12=rr{4};
d=[p11(:);p12(:)];
[y,bins]=hist(d,100);
p11h=hist(p11(:),bins);
p12h=hist(p12(:),bins);
y=[p11h;p12h]';y./=repmat(sum(y),[100 1]);

dlmwrite(fnout,y,"\t");

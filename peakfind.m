function res=peakfind(x)

%x should be a vector, not matrix
%simple peak finding; returns the indices of the peaks
%020110118pmc

d1=x(1:end-1)-x(2:end);
d2=x(2:end)-x(1:end-1);
d3=[0 d1<0] & [d2<0 0];
res=find(d3);

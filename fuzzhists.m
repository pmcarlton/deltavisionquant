function y=fuzzhists(basename,leftend,rightend,binnum);

%highlycustomized program --
%loads all files matching pattern:
%basename.NNNNNNNN.oct
%where NNNNNNNN is successively replaced by all lowercase octomers.
%each file is simply a list of numbers indicating the hit locations.
%you must specify the left and right end, and the number of bins to make.
%the result is a 65536 x $NBINS matrix containing hit numbers.
% 020120330_09:37_pmc

y=zeros(65536,binnum);
v=dec2base([0:65535]','acgt',8);
bins=linspace(leftend,rightend,binnum+1);
bins(1)=[];
bins-=(bins(1)/2);
for i=1:65536,
    s=strcat(basename,'.',v(i,:),'.oct');
    n=load(s);printf(".");
    h=hist(n,bins);
    y(i,:)=h;
end


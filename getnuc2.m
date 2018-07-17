function res=getnuc2(mo, o, smooth);
%input is image; output is largest bwim shape above threshold o

gausthr=0.005;
o2f=2.5;   %2-level thresholding for the win
sd=7; %distance for smoothing via double-bwdistsc
sd2=7; %distance for smoothing via double-bwdistsc
o2=o/o2f;
m=mo;
mma=max(m(:));
q=[];
if(mma>o),   %IOW, if at least one pixel is greater than the value o
	m=(m>o2); %binarize @ threshold o2
	m=bwdistsc(m);  %do distance transform
	m=(m>sd);  %binarize @ threshold sd (distance from edge)
	m=bwdistsc(m); %do another distance transform
	m=(m>sd2);  %binarize @ threshold sd2 (distance from edge)
	%disp(length(find(m)));
	m=bwlabel(m);
	mlmax=max(m(:));
	for l=1:mlmax;
		jj=mo(find(m==l)); %find pixels in original image that are part of largest object IS BAD since there might be 2 objects or 3 if the nucleus is peanut-shaped!
		%q(l)=sum(m(:)==l)*sum(jj);
		q(l)=sum(jj);       %find the sum of those pixels - i.e. judge by how bright the original image is, not just how large the object is
		%q(l)=sum(m(:)==l);
		end;
	[qi,qh]=sort(q);
	lll=length(qh);
	res=(m==find(q==max(q)));
	if(lll>1), res+=(m==qh(lll-1)); end
	%res=(m==find(q==max(q)));
	else
	res=zeros(size(mo));
	end

if(smooth),
	m=conv2(res,fspecial('gaussian',[15 15],5),'same');
	m=bwmorph(m>gausthr,'thin',4);
	j=bwlabel(1-m);q=[];for l=1:max(j(:));q(l)=sum(j(:)==l);end; %label the holes and background
	f=find(q==max(q));bk=(j==f); %bk is the background
	holes=(j>0)-bk;m=m+holes;
	res=m;
	end

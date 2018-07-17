function res=getnuc4(mo, o,o2, smooth, convexhull);
%input is image; output is largest bwim shape above threshold o
%implemented double-specified thresholds
%gentnuc4 -- implement convhull of each bwobject, 2011年1月20日木曜日 14:37:06


gausthr=0.0001;
%o2f=10;   %2-level thresholding for the win
sd=7; %distance for smoothing via double-bwdistsc
sd2=7; %distance for smoothing via double-bwdistsc
%o2=o/o2f;  %just specify it , duh 020110120
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
	for l=1:mlmax;qq(l)=sum(m(:)==l);end;
	[yy,ii]=sort(qq,'descend');l=length(ii);for ll=1:l;if(ll<5),objlist(ll)=(ii(ll));end;end
	%now have 'objlist' containing labels of up to the 4 biggest objects
	rsq=m(1,1);objlist(find(objlist==rsq))=[];
	%disp(rsq);
	if(length(objlist)<2),disp("ONLY ONE OBJECT - JACKED UP!");disp(objlist);end
    res=zeros(size(m));
	for l=1:length(objlist),res |= (m==objlist(l));end
	%  res=m;

	else %if mma <= o
	res=zeros(size(mo));
	end

if(smooth),
	m=conv2(res,fspecial('gaussian',[15 15],5),'same');
	m=bwmorph(m>gausthr,'thin',4);
	j=bwlabel(1-m);q=[];for l=1:max(j(:));q(l)=sum(j(:)==l);end; %label the holes and background
	f=find(q==max(q));bk=(j==f); %bk is the background
	holes=(j>0)-bk;m=m+holes;
	if(m(1,1)),m=(1-m);end
	res=m;
	end

if(convexhull),
	[rsi,csi]=size(res);
	res2=zeros(rsi,csi);
	res3=zeros(rsi,csi);
	j=bwlabel(res);
	for l=1:max(j(:));
		[x,y]=find(j==l);
		r=convhull(x,y);
		res2=poly2mask(y(r),x(r),rsi,csi);
		res3|=res2;
		end
	res=res3;
	end


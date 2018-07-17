function res=getnuc(mo, o, smooth);
%input is image; output is largest bwim shape above threshold o

o2f=5;   %2-level thresholding for the win

o2=o/o2f;
m=mo;
mma=max(m(:));
q=[];
if(mma>o), 
	m=(m>o2);
	m=bwlabel(m);
	mlmax=max(m(:));
	for l=1:mlmax;
		jj=mo(find(m==l));
		%q(l)=sum(m(:)==l)*sum(jj);
		q(l)=sum(jj);
		%q(l)=sum(m(:)==l);
		end;
	res=(m==find(q==max(q)));
	else
	res=zeros(size(mo));
	end

if(smooth),
	m=conv2(res,fspecial('gaussian',[15 15],5),'same');
	m=bwmorph(m>.025,'thin',4);
	j=bwlabel(1-m);q=[];for l=1:max(j(:));q(l)=sum(j(:)==l);end; %label the holes and background
	f=find(q==max(q));bk=(j==f); %bk is the background
	holes=(j>0)-bk;m=m+holes;
	res=m;
	end


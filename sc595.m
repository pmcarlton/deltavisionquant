function a=sc595(b)
%normalizes a 2d matrix to 5%,95%


b=squeeze(b);
ss=size(b);

m=sort(b(:));s=length(m);s1=ceil(s.*.05);s2=ceil(s.*.95);
b(find(b>=s2))=s2;
b(find(b<=s1))=0;b-=s1;s2-=s1;
if(s2!=0), a=b./s2;
else a=b;
end
end


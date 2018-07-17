function a=im2(b)
    %normalizes a 2d matrix to (0..1), then views it

[d1,d2]=image_viewer('/bin/sh /Users/pcarlton/bin/octview.sh %s');


b=squeeze(double(b));
m=sort(b(:));s=length(m);s1=m(ceil(s.*.05));s2=m(ceil(s.*.95));
b(find(b<=s1))=s1;b(find(b>=s2))=s2;
b=b-s1;
s2-=s1;
if(s2), a=b./s2;
else a=b;
end;

imshow(a);
end


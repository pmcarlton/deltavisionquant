function a=im3(b)
%normalizes a 2d matrix to (0..1), then views it

[d1,d2]=image_viewer('/bin/sh /Users/pcarlton/bin/octview.sh %s');

b=squeeze(b);
ss=size(b);
if(q=(find(ss(end)==3))),  %only do it if it's 3 layers

rh=zeros(ss(1),ss(2)*3);   %concatenate horizontally
e=0;ry=ss(2);
for li=0:2,
co=(li*ry)+1:(li+1)*ry;
bb=b(:,:,li+1);

m=sort(bb(:));s=length(m);s1=ceil(s.*.05);s2=ceil(s.*.95);
bb(find(bb>=s2))=s2;
bb(find(bb<=s1))=0;bb-=s1;s2-=s1;
if(s2!=0), a=bb./s2;
else a=bb;
end;

rh(:,co)=a;
end

a=rh;
disp(size(a));
imshow(a);
end %yes, it was 3 layers


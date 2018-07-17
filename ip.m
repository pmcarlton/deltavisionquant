function a=ip(b)
    %normalizes a 2d matrix to (0..1), then views it

#[d1,d2]=image_viewer('/bin/sh /Users/pcarlton/bin/octview.sh %s');

b=double(b);
m=min(b(:)); b=b-m;
m=max(b(:));
if(m!=0), a=b./m;
else a=b;
end;

#imshow(a);
[retval,name]=system("uuidgen");
name(end)=[];
name=strcat("/tmp/img.",name,".tif");
imwrite(a,name);
%cmd=cstrcat("display -geometry +0+0 ",name," &");
cmd=cstrcat("open -a Preview.app \t ",name);
system(cmd);
system(strcat("echo \t ",name," | pbcopy"));

end


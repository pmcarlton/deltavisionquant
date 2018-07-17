function result=mrcwrite_prec_arch(array,fname,prec,arch);

%writes a freaking MRC file in floating point format. It's about freaking time.
%020100903 hey it beats writing Wakate-A, pmc

%determine if it's complex...
homedir=getenv("HOME");
cplx=0;
if(iscomplex(array)), cplx=1;end

[retval,uuid]=system('uuidgen');
timestr=strftime(" 0%Y%m%d %H:%M:%S",localtime(time));
str1=strcat("Created on Octave, ",timestr);
[retval,uid]=system('echo ${USER}@${HOSTNAME}');
str1(end+1:80)=0;
disp (str1);
uid(end)=[];
uid(end+1:80)=0;
disp (uid);
uuid(end)=[];
uuid(end+1:80)=0;
disp (uuid);

s=size(array);
l=length(s);
nx=s(2);ny=s(1);
nt=1;
nz=1;
nsec=1;
if(l>2),nz=s(3);
  nsec*=nz;
  if(l>3),nt=s(4);
	nsec*=nt;
  end
  end

%array=rotdim(array,-1,[1 2]);
arr=single(array(:));
arrmin=min(arr);
arrmax=max(arr);
%tmp=load('/Users/pcarlton/Desktop/GENOFIELD_poster/mrchdr.oct');
tmp=load(strcat(homedir,'/Octavefiles/mrchdr.oct'));
hdr=tmp.hdr3;

hdr(2)=int32(nx);
hdr(1)=int32(ny);
%hdr(1)=int32(nx);
%hdr(2)=int32(ny);
hdr(3)=int32(nsec);
if(cplx),hdr(4)=int32(4); %set complex floating-point mode
else
hdr(4)=int32(2);  %set floating-point mode
end
hdr(46)=int32(nt);

fout=fopen(fname,'w');
fwrite(fout,hdr(1:19),'int32',0,arch);
fwrite(fout,arrmin,'float32',0,arch);
fwrite(fout,arrmax,'float32',0,arch);
fwrite(fout,hdr(22:end),'int32',0,arch);
%fwrite(out,hdr,'int32','ieee-le');

fseek(fout,224);
fwrite(fout,str1);
fwrite(fout,uid);
fwrite(fout,uuid);
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));
fwrite(fout,char(zeros(1,80)));

if(cplx),arr2=zeros(1,length(arr)*2);
  arr2(1:2:end)=real(arr);
  arr2(2:2:end)=imag(arr);
  arr=arr2;
end

fseek(fout,1024);
result=fwrite(fout,arr,prec,0,arch);
fflush(fout);
fclose(fout);
printf("%i records written to %s \n",result,fname);

